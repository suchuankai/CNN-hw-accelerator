# Hardware Design

## Description

We have implemented two versions, one with clock-gating and one without.

## Result
|                  | Total cell area | data arrival time |  Total power |
|  ----            | ----            | -----             | ----         |
| no clock-gating  | 787756  (µm^2)  | 9.26 (ns)         | 21.43 mw     |
| clock-gating     | 804187  (µm^2)  | 9.21 (ns)         | 20.55 mw     |

## Instruction
Function simulation
```
ncverilog tb.v Top.v +access+r
```
Gate-level simulation
```
ncverilog tb.v Top_syn.v tsmc13_neg.v +define+SDF +access+r
```

## PE design
![image](https://github.com/suchuankai/CNN-hw-accelerator/assets/69788052/3643e383-560e-4ddf-80d8-34f08b185838)


