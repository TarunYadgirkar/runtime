#!/bin/bash
set -e
cd "$(dirname "$0")"
echo 1; gh pr create --repo GitM-Labs/runtime --base main --head TarunYadgirkar:tarun/plan-sweep-refusal --title '[ENG-119] planner: report a refused config per sweep row, and skip it in the proposer' --body-file 1-plan-sweep-refusal.md
echo 2; gh pr create --repo GitM-Labs/runtime --base main --head TarunYadgirkar:tarun/plan-kv-cache-spellings --title '[ENG-120] planner: price vLLM'"'"'s --kv-cache-dtype spellings by their bytes' --body-file 2-plan-kv-cache-spellings.md
echo 3; gh pr create --repo GitM-Labs/runtime --base main --head TarunYadgirkar:tarun/plan-expert-knee --title '[ENG-121] planner: print the expert knee where the graph'"'"'s moe_routed node flips' --body-file 3-plan-expert-knee.md
echo 4; gh pr create --repo GitM-Labs/runtime --base main --head TarunYadgirkar:tarun/plan-fp4-rules-v029 --title '[ENG-122] planner: re-read the MXFP4 and NVFP4 rules at vLLM v0.29.0' --body-file 4-plan-fp4-rules-v029.md
echo 5; gh pr create --repo GitM-Labs/runtime --base main --head TarunYadgirkar:tarun/h001-refusals --title '[ENG-123] hypotheses: H-001 refuses setups it cannot price' --body-file 5-h001-refusals.md
echo 6; gh pr create --repo GitM-Labs/runtime --base main --head TarunYadgirkar:tarun/h001-quant-count --title '[ENG-124] hypotheses: H-001 counts AITER'"'"'s activation quants from the MXFP4 graph' --body-file 6-h001-quant-count.md
echo 7; gh pr create --repo GitM-Labs/runtime --base main --head TarunYadgirkar:tarun/h001-deferral-doc --title '[ENG-125] docs: defer H-001 from the Oct 19 three and say why' --body-file 7-h001-deferral-doc.md
echo 8; gh pr create --repo GitM-Labs/runtime --base main --head TarunYadgirkar:tarun/v4-o-lora-rank --title '[ENG-126] planner: price DeepSeek V4'"'"'s output projection per group' --body-file 8-v4-o-lora-rank.md
echo 9; gh pr create --repo GitM-Labs/runtime --base main --head TarunYadgirkar:tarun/lever-classes --title '[ENG-79] kernels: give every lever a class and a restart cost' --body-file 9-lever-classes.md
