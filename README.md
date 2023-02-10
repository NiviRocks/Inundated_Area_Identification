# Inundated_Area_Identification
## Version 4
### Hypothesis
- SD of the whole image must be greater than the SD of the window.
- Thus, the local threshold must be first assumed as SD of the window and then it's value is incremented as per the below Algorithm.
### Algorith :
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
P.s.: mean difference acceptable range _x_ are choosen by trial and error

### Limitation
- Cannot Identify small regions or cluster of small regions
- Causes Overfitting (for large water region)
- Not better than Version 3

### Conclusion
- SD of window can be greater than SD of the whole image
- Hypothesis is proved as false.
