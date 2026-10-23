<!-- claude-projects-attribution: {"github_login":"TarunYadgirkar"} -->
_Requested by **Tarun** · [project thread](https://claude.ai/code/project/chan_01MT32jfMtue9SNVDns5yv4Q?thread=cmsg_01MT32jfMtue9SNVDns5yv4QJgiwzvm4Wypi6SjxiaWzbG)_

H-001 counted MXFP4 activation quants two ways: as nodes in the floor, and again as guessed launches charged at all, half or none across the band (E19). It now counts the quant nodes the MXFP4 graph carries, read from AITER v0.1.19's tuned Kimi rows, and charges them like any other node. Follows the [ENG-123] H-001 refusals PR (merge that first; this diff includes its commit).

## What's in it
- **Graph.** `glm_graph` adds the MXFP4 quants AITER runs as their own kernels: the shared expert's two inputs, the dense layer's down input, and routed stage 2's input unless the tuned stage-1 kernel writes fp4 itself (`aiter_mxfp4_routed_quants`, keyed on AITER's padded token count and the per-rank intermediate after ROCm's round-up to 256, the width stage 2 is quantised at).
- **H-001.** Charges those nodes at every end of the band on the measured basis, since each quant feeds a GEMM on the same stream. The arithmetic lines split the routed quants from the bundled shared-expert and dense ones.
- **Registered row.** -47.9 / 0.9 / 33.6% (was -44.8 / 3.3 / 35.6%).
- **Doc.** The rest of H-001 re-read at v0.29.0 and AITER v0.1.19: the quant counts, the band, the decode-only steps the count holds for, and the kernel names a trace shows.
- **Tests.** The tuned-row lookup at every padded token count at TP8, TP4, TP16 and TP32, the quant count at three batch shapes, each quant's input width at TP8, TP16 and TP32, and the mean as the floor ratio.

## Open questions
- **Prefill-sized steps.** Above 256 tokens (stage 1) and 1,024 (stage 2) AITER splits each quant into two kernels. That's not modelled: about 0.24 ms of launch floor at an 8,192-token step, none on the decode rows.
- **Other shapes and AITER versions.** Other shapes fall back to two routed quants per layer: the rule only knows Kimi's tuned TP8 and TP4 rows, as AITER v0.1.19 ships them. AITER main has retuned those rows (TP8 now fuses the quant at 32 and 64 tokens too), so a newer image changes the count at the 64- and 32-sequence rows.
- **`classify_op` filing.** It files AITER's fused quant-and-sort under `moe_permute` and the Triton linear quant as unmodeled, so a deviation report can't pair most of the new quant nodes. The doc says to sum the quants by kernel name. Changing the taxonomy touches every trace.
- **The band is wide** (-47.9 to 33.6%), and H-001 isn't on the Oct 19 schedule.
- **Kimi K3 (#187).** K3 has MXFP4 experts and no tuned AITER row for its shape, so it gets both routed quants: 92 more nodes, 0.18 GB at B=32. The pinned 721.44 GB in `tests/test_catalogue_kimi_k3.py` and the design note's 721.4 move to 721.62 / 721.6. K3's recipe is MXFP4 weights with MXFP8 activations, and whether that runs AITER's W4A4 path at all wasn't checked. Question for Adit.

Nothing here has run on hardware.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01XAD6vuCMEFYZTAGrQDwqSD
