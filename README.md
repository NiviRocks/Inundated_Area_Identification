# Inundated_Area_Identification
## Version 3
### Algorithm:
- Step 1: Find minimum pixel value (Vmin) in image/matrix.
- Step 2: Set Global threshold (t) to SD of the whole image.
- Step 3: Find water pixel p and draw a window around pixel p.
- Step 4: Calculate mean (m1) of the pixels in the window in range _[Vmin, Vmin + t]_ using global threshold _t_.
- Step 5: Increase the threshold, _t_ by a small value _Δt_. Let, this be the local threshold, _t1’_.
- Step 6: Now calculate the mean (m2) of the window again.
- Step 7: If _abs(m1-m2) > x_  then increase _t1’_ by _Δt_ 
- Step 8: Terminate when mean difference is constant or negligible (<= x ).
- Step 9: Else repeat from step 3 to step 7.
- Step 10: With the final value of Local Threshold _∂_ grow the region.
#
P.s.: mean difference acceptable range _x_ are choosen by trial and error

### Limitation
- Cannot Identify small regions or cluster of small regions

### Conclusion
- Final Solution of the Project.
