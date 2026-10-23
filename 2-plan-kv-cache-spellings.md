<!-- claude-projects-attribution: {"github_login":"TarunYadgirkar"} -->
_Requested by **Tarun** · [project thread](https://claude.ai/code/project/chan_01MT32jfMtue9SNVDns5yv4Q?thread=cmsg_01MT32jfMtue9SNVDns5yv4QJgiwzvm4Wypi6SjxiaWzbG)_

Some vLLM `--kv-cache-dtype` spellings were priced at the 2 B fallback, `gitm plan` rejected vLLM's own `bfloat16`, `float16` and `fp8_e5m2`, and `gitm capture` crashed on a cache the planner can't price (E75, G6). Follows the [ENG-119] sweep-refusal PR (merge that first; this diff includes its commit): the sweep's cache note needs its refused rows.

## What's in it
- **`gitm plan --kv-cache-dtype`.** Also takes `bfloat16`, `float16` and `fp8_e5m2`, priced by their bytes. `fp8_inc`, the Intel Gaudi plugin's spelling, is refused: no in-tree attention backend lists it.
- **Notes.** An explicit spelling prints that the planner didn't check this model and GPU's attention backend takes it. `bf16` and `fp16` print that they're the planner's labels, which `vllm serve` rejects. A sweep prints the note only if a row was priced.
- **`kv_elem_bytes`.** Reads vLLM's spellings: every fp8 variant is one byte, and `nvfp4_4over6` is NVFP4's layout. Turboquant and per-token-head caches raise `ValueError`, since no format here describes their scales.
- **Attach.** The predicted-graph sidecar catches that, prints `skipped (...)` and writes nothing, instead of crashing the capture.
- **Help and audit.** The help says what an explicit fp8 spelling prices, and that Hopper's sparse-MLA backend stores 656 B per GLM-5.2 entry against the 576 priced. The K2.6 audit lists the new choices.

## Open questions
- **Backend support isn't checked.** A priced spelling may be one this model's backend rejects (`fp8_e5m2` on a CUDA MLA model). The note says so.
- **Two KV rates for glm-5.2-fp8 (G13).** `auto` prices 52,608 B/token (RoPE kept bf16, as the entry says the vendor's `--kv-cache-dtype fp8` does). An explicit fp8 spelling prices 47,616 (both halves fp8, as the override has done since #127). Which layout an explicit fp8 should mean is a modelling choice.
- **A float16 cache on a bf16 model (G12).** vLLM accepts `--kv-cache-dtype float16` on K2.6 and writes bf16 bits into it (`config/cache.py:326-342` only logs; upstream #60859 and #54338 are open). The planner prices it and doesn't tell anyone to pass it.
- **Spellings `gitm plan` doesn't take.** `fp8_ds_mla`, turboquant, per-token-head and `nvfp4` are still argparse's "invalid choice", with no reason given.
- **deepseek-v4.1-flash.** Its graph prices the cache with `weight_bytes`, so through the Python API it doesn't refuse turboquant or per-token-head, and prices `nvfp4_4over6` at 2 B. A v0.29.0 server can't run those spellings on V4 (`models/deepseek_v4/sparse_mla.py:47-51`, `v1/attention/backends/mla/rocm_aiter_mla_sparse.py:269-275`), and the CLI doesn't take them.
- **The Hopper fp8_ds_mla gap is only in the help.** `gitm plan glm-5.2 --gpu H200 --kv-cache-dtype fp8` prices 576 B per entry, and its per-run note doesn't say vLLM stores 656 there (`mla_attention.py:349-355`). Not every glm_moe_dsa entry is sparse (Kimi isn't), so a per-run note needs its own check. Follow-up?
- **The H200 deploy runs `vllm/vllm-openai:latest`,** which is v0.31.0 today. The notes and the refusal cite v0.29.0, the MI355X image. v0.30.0 added `nvfp4_ds_mla` (352 B per entry), which `kv_elem_bytes` prices at 2 B and `gitm plan` rejects.
- **The attach flag mapper collapses every `fp8*` flag to `fp8` (G7).** So attach prices `fp8_inc` (which `gitm plan` refuses), `fp8_ds_mla` and `fp8_per_token_head` as plain fp8, while `int8_per_token_head` is skipped. Pre-existing (`serve/model_config.py:171`).

Nothing here has run on hardware.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01XAD6vuCMEFYZTAGrQDwqSD
