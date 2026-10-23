<!-- claude-projects-attribution: {"github_login":"TarunYadgirkar"} -->
_Requested by **Tarun** · [project thread](https://claude.ai/code/project/chan_01MT32jfMtue9SNVDns5yv4Q?thread=cmsg_01MT32jfMtue9SNVDns5yv4QJgiwzvm4Wypi6SjxiaWzbG)_

The expert "knee" line in `gitm plan` disagreed with the floor (E72): it ignored prefill rows and the per-rank expert slice, and used its own MoE formula. It now reports where the graph's own `moe_routed` node turns compute-bound. Follow-up to #127.

## What's in it
- **`moe_routed_cost`.** The node's FLOPs and bytes, moved out of `_emit_layer` so the graph and the knee line share them. No graph number changes.
- **`moe_routed_knee`.** Bisects the rows per expert where that node turns compute-bound: 60.3 for K2.6 NVFP4 on H200, where the old per-GEMM formula said 67. Sharding moves it only through a rank's padding and `ep_imbalance`.
- **The line.** Counts this step's decode and prefill rows and prints `never` when the node can't turn compute-bound. When the node is launch-bound at the knee, it says that instead of "compute-bound above".
- **Docs.** `quant-arithmetic.md`, the K2.6 audit and H-001 call 60.3 the node's knee and 67 the knee of one 7,168 x 2,048 GEMM.
- **Tests.** The knee sits where the node's bound flips for kimi-k2.6 on H200 and glm-5.2-fp8 on B200, at TP1, TP8 and EP8, across phases. A padded 2,880-wide MXFP4 expert on B200 moves it between TP1 and TP8, and `gitm plan` prints the knee at the run's TP. The launch-bound note, and `never` for a spec with no routed experts per token.

## Open questions
- **Activation traffic (G11).** `moe_routed_cost` charges 4N activation bytes per row-expert, unchanged from main. vLLM's Marlin MoE path on H200 moves 6N (`marlin_moe.py:118-203`); with 6N the knee is 61.5, not 60.3. Same root as Rahul's filed GEMM-traffic item.

Nothing here has run on hardware.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01XAD6vuCMEFYZTAGrQDwqSD
