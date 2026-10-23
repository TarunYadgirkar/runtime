First half of ENG-79: every lever in `library.yaml` gets a `lever_class` and a `restart_cost`, and a test fails if one is missing. The verifier (each lever mapped through planner, apply path, engine layer and telemetry key) and the CI rule come in a second PR.

## What's in it

- `gitm/kernels/spec.py`: two optional fields on `InterventionSpec`. `lever_class` is 1, 2 or 3 (ENG-79's classes; named `lever_class` because `class` is a Python keyword). `restart_cost` is `none`, `restart` or `rebuild`. They're optional so specs built in code still validate; the test enforces them for the library.
- `gitm/kernels/library.yaml`: both fields on all 28 levers.
- `tests/test_lever_classes.py`: every library lever has both fields, a missing one is caught, and an out-of-range class is rejected.

## Open questions

- 11 levers are marked `# open, for Sebastian` with the question inline: fp8 KV and CPU offload (restart or rebuild), spec decode, FlashInfer and DeepGEMM (class 1 or 2), Ray, expert parallel and EPLB (class 1 or 3), and the three non-vLLM levers (does restart_cost apply).
- Sebastian: your loop doc uses scheduling/structural and hot/restart/unsupported. Should these fields use those words?
- Today `knob_kind()` says every lever is structural, so nothing is truly `none` yet. Should `restart_cost` say what vLLM could do, or what gitm does now?
- Nathan: is `lever_class` the name `qualify_run` should read?

🤖 Generated with [Claude Code](https://claude.com/claude-code)

https://claude.ai/code/session_01XAD6vuCMEFYZTAGrQDwqSD
