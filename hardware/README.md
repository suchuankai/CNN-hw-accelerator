# Hardware Design

## Description

We have implemented two versions, one with clock-gating and one without.

## Result
|                  | Total cell area | data arrival time |  Total power |
|  ----            | ----            | -----             | ----         |
| no clock-gating  | 664064  (µm^2)  | 9.23 (ns)         | 18.55 mw     |
| clock-gating     | 682319  (µm^2)  | 9.32 (ns)         | 12.67 mw     |

## Instruction
Function simulation
```
ncverilog tb.v Top.v +access+r
```
Gate-level simulation
```
ncverilog tb.v Top_syn.v tsmc13_neg.v +define+SDF +access+r
```

# PE design
![image](https://github.com/suchuankai/CNN-accelerator/assets/69788052/3e70f773-2572-415d-958e-0f11e18f5b98)

