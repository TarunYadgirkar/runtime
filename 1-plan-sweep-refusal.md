<!-- claude-projects-attribution: {"github_login":"TarunYadgirkar"} -->
_Requested by **Tarun** · [project thread](https://claude.ai/code/project/chan_01MT32jfMtue9SNVDns5yv4Q?thread=cmsg_01MT32jfMtue9SNVDns5yv4QJgiwzvm4Wypi6SjxiaWzbG)_

`gitm plan --sweep` stopped at the first config the planner refuses (#187 made it print `cannot plan` and exit 2 there), and the hypothesis proposer crashed on one (E18). Now each refused sweep row says why and the other rows still print, and the proposer skips with that reason. Follow-up to #127.

## What's in it
- **Sweep.** A refused row prints `<batch> cannot plan: <reason>`, the other rows still print, and the sweep exits 2 like a single refused plan.
- **Proposer.** `HypothesisProposer` catches `UnsupportedExecution` from `predict` and records `cannot price this workload: ...` as the skip reason.
- **Tests.** A refused execution and a sharding the graph refuses, each reported per sweep row, and the proposer skip.

## Open questions
- **The proposer catches `UnsupportedExecution` only (G15).** A TP that doesn't divide the heads raises the graph's plain `ValueError` out of `propose`, where the sweep prints a row. vLLM refuses that TP too. Catching `ValueError` there would also hide real bugs in `predict`, so it's left as is.

Nothing here has run on hardware.

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01XAD6vuCMEFYZTAGrQDwqSD
