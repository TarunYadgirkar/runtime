<!-- claude-projects-attribution: {"github_login":"TarunYadgirkar"} -->
_Requested by **Tarun** · [project thread](https://claude.ai/code/project/chan_01MT32jfMtue9SNVDns5yv4Q?thread=cmsg_01MT32jfMtue9SNVDns5yv4QJgiwzvm4Wypi6SjxiaWzbG)_

Three of the planner's FP4 execution rules were read from vLLM v0.19.1, but the MI355X loop image runs vLLM v0.29.0 and AITER v0.1.19. This re-reads them there. Follow-up to #127.

## What's in it
- **MXFP4 on Blackwell (G8).** TRT-LLM pads the per-rank intermediate to 128 at v0.29.0 (`oracle/mxfp4.py:740-742`), not 256; hidden stays 256. No catalogue entry moves, since they're exact multiples either way.
- **MXFP4 on CDNA4.** The rule's source is re-read: AITER needs both AITER flags and gfx950, the tuned Kimi rows run two stages, each fed by an MXFP4 activation quant unless stage 1 writes fp4 itself, and the A16W4 cktile path is off for them. Pricing is unchanged.
- **NVFP4 on CDNA4 (G4).** Still refused, with the v0.29.0 reason: it runs a Triton emulation no rule prices (at v0.19.1 there was no kernel). `UnsupportedExecution`'s docstring and message cover that case.
- **Docs.** `quant-arithmetic.md` says which passages were re-read at v0.29.0 and AITER v0.1.19, and that the Quark checkpoint that emulates on CUDA is the W4A4 one (AMD's Kimi). A weight-only one keeps the bf16 backends.
- **#185's numbers.** The EP example moves to v0.29.0's padding: a 2,880-wide MXFP4 expert pads to 3,072 x 2,944, 9.0% more bytes, not 13.8%. The `kimi-k2.6` on MI355X row quotes the new refusal.
- **Tests.** The padding tests pin 128 per rank, including under EP, and a forced Marlin on Blackwell gets the same bytes and padding as TRT-LLM.

## Open questions
- **Pricing NVFP4 emulation.** A rule needs the bytes of a dequant inside the GEMM on every forward, which nobody has measured. `_FORCED`'s `emulation` entry still prices v0.19.1's unfused 20 B per weight chain.
- **MXFP8 on Hopper** is refused from a v0.19.1 read. v0.29.0 lists an EMULATION backend for it too (`oracle/mxfp8.py:30`); not re-read here.
- **The CDNA4 MXFP4 backend label** stays `aiter_ck2stages`, though the tuned rows mostly run FlyDSL kernels. Renaming it changes `gitm plan` output.
- **CDNA4 MXFP4 padding.** The rule pads 256/256, right for the W4A4 path it prices (`oracle/mxfp4.py:759-761`). AITER's MXFP4-weight, bf16-activation path with SiLU rounds both to 128 (`:749-758`).

Nothing here has run on hardware.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01XAD6vuCMEFYZTAGrQDwqSD
