<!-- claude-projects-attribution: {"github_login":"TarunYadgirkar"} -->
_Requested by **Tarun** · [project thread](https://claude.ai/code/project/chan_01MT32jfMtue9SNVDns5yv4Q?thread=cmsg_01MT32jfMtue9SNVDns5yv4QJgiwzvm4Wypi6SjxiaWzbG)_

Records why H-001 isn't one of the Oct 19 three, and what it needs first. Doc only.

## What's in it
- **Status.** Deferred on 2026-10-07 and kept registered, for three reasons: the primary metric (replayed HBM bytes per MoE layer) has no Tier-2 replay tool yet, the loop pod serves one checkpoint by name, and the GSM8K gate allows a 1.0-point loss where AMD's model card already shows 0.99.
- **Experiment and budget.** Says the loop deployment can't swap the checkpoint yet, and adds budget rows for serving a second checkpoint and for the Tier-2 replay. The 559 GB download can start without GPUs.
- **Gates.** Puts AMD's reported GSM8K drop next to the gate, with its standard error. AMD ran eager at TP4 and arm B runs graphs at TP8, with ROCm/aiter#3632 (graph-capture corruption for this backend) open, so an arm B gate failure is rerun eager before it counts.
- **Fix.** The dense-FFN bug note points at #127 (`65a8828`) instead of a commit that isn't on main.

## Open questions
- **Owners.** Nobody is assigned to serving a second checkpoint from the loop pod, or to the Tier-2 replay.
- **An eager control arm for arm B.** aiter#3632 wasn't checked at v0.1.19. Whether to plan the eager arm up front, rather than only after a gate failure, is a budget call.

Nothing here has run on hardware.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01XAD6vuCMEFYZTAGrQDwqSD
