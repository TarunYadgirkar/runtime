<!-- claude-projects-attribution: {"github_login":"TarunYadgirkar"} -->
_Requested by **Tarun** · [project thread](https://claude.ai/code/project/chan_01MT32jfMtue9SNVDns5yv4Q?thread=cmsg_01MT32jfMtue9SNVDns5yv4QJgiwzvm4Wypi6SjxiaWzbG)_

H-001 prices AITER's MXFP4 MoE and linear on gfx950 at vLLM v0.29.0. Its `applies` now refuses setups that run something else, instead of pricing them as if they didn't. Follow-up to #127.

## What's in it
- **Refusals.** `VLLM_ROCM_USE_AITER` or `VLLM_ROCM_USE_AITER_MOE` off; AITER shared-expert fusion on (385 experts, top-9, another kernel family); a `moe_backend` or `linear_backend` other than `auto`, top-level or in `kernel_config`; `VLLM_DISABLED_KERNELS` with `AiterMxfp4LinearKernel` as one of its comma-separated entries (vLLM matches whole entries and doesn't strip spaces); and an NVFP4 baseline on MI355X, which runs a Triton emulation the planner doesn't price. The non-gfx950 refusal now cites v0.29.0.
- **Env flags.** Read the way vLLM parses them (`envs.py:1235-1237`). `None` in `Workload.serving` means unset.
- **Doc.** H-001's applicability conditions, the CUDA exclusion and step 3's log lines are re-read at v0.29.0 and AITER v0.1.19. The loop deployment meets every condition.
- **Tests.** One per refusal, comma lists and near-miss names for `VLLM_DISABLED_KERNELS`, and the loop deployment's env, which applies.

## Open questions
- **Batch invariance and LoRA** aren't refused. Either makes AITER's fused MoE decline the config (`modular_kernel.py:592-595`), and the oracle falls to emulation. The planner can't see them; arm B's log lines catch it.
- **The rest of the doc** still cites the first derivation at v0.19.1. It's re-read in the follow-up that counts the activation quants.

Nothing here has run on hardware.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01XAD6vuCMEFYZTAGrQDwqSD
