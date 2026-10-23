<!-- claude-projects-attribution: {"github_login":"TarunYadgirkar"} -->
_Requested by **Tarun** · [project thread](https://claude.ai/code/project/chan_01MT32jfMtue9SNVDns5yv4Q?thread=cmsg_01MT32jfMtue9SNVDns5yv4Q16a4HRXJ5tqAHw8YuU43WB)_

DeepSeek V4's `o_lora_rank` is per group, but `moe_graph` read it as a total, so wo_a and wo_b were 16x low on V4 Pro and 8x on V4 Flash. This is the first follow-up listed in #187.

## What's in it
- **Weights.** `model_weight_bytes` charges wo_a as n_heads x head_dim x o_lora_rank and wo_b as o_groups x o_lora_rank x hidden, both split by TP, as vLLM builds them (v0.32.0 `models/deepseek_v4/attention.py:265-284`). V4 Pro goes from -1.48% to -0.24% against the published size (+11.07 GB), V4 Flash 0731 from -2.25% to -0.63% (+2.70 GB).
- **Graph.** `attn_out_proj` is this rank's groups, each projecting its heads to its own rank, then wo_b over all local groups' ranks.
- **Entries.** The grouped-projection item is gone from the V4 Pro and V4 Flash 0731 `unmodelled` lists. Their totals, V4.1 Flash's (-38.0% to -37.4%, +2.84 GB) and the `model_weight_bytes` docstring are updated.
- **Tests.** The pin #187 left for this fix now checks the pair is 11.81 GB on V4 Pro and that `model_weight_bytes` counts all of it, plus `attn_out_proj`'s bytes at TP1 and TP8.

## Open questions
- **TP above o_groups.** At TP16 V4 Flash has 8 groups for 16 ranks. vLLM computes `n_local_groups = n_groups // tp`, which is 0 there; the planner charges one group. Whether vLLM runs that at all wasn't checked.
- **V4.1 Flash's design note** (`docs/deepseek-v4.1-flash/DESIGN-NOTE.md`, G7 and C18) still lists the bug. Left for its owner.
- **H200 ceiling for V4 Pro.** The ceiling doc compared the planner with hand math; this moves the planner's attention weights. Not re-run here.

Nothing here has run on hardware.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01XAD6vuCMEFYZTAGrQDwqSD
