# Inundated_Area_Identification
## Version 3
### Key Points are:
- Step 1: Find minimum pixel value (Vmin) in image/matrix.
- Step 2: Set threshold (t) to SD of the whole image.
- Step 3: Find water pixel p and draw a window around pixel p.
- Step 4: Calculate mean (m1) of the pixels in the window in range [Vmin, Vmin + t] using global threshold t.
- Step 5: Find the SD of the window and increase it by a small value Δt (let the local threshold be t1’) and calculate the mean (m2) of the window again.
- Step 6: If abs(m1-m2) > x  then increase t1’ by Δt 
- Step 7: Terminate when mean difference is constant or negligible (<= x ) or local threshold is greater than global threshold ti’ > t (where i ϵ [1,.., n] ) .
- Step 8: Else repeat from step 3 to step 6.
- Step 9: With the final tn’ (local threshold) grow the region.
#
P.s.: Both global theshold _t_ and mean difference acceptable range _x_ are choosen by trial and error

### Limitation
- Causes overfitting

### Follow Up Work
- Need for a algorithm to determine _t_ without trial and error method.
- Reduce overfitting
