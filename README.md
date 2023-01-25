# Inundated_Area_Identification
## Version 3
### Key Points are:
- Image pixel values converted into 0-1 range
- Minimum pixel, Vmin intensity value is found from the whole image
- The Global Threshold, t is selected
- This threshold is used to find the water pixel, global range for water pixel is [Vmin,Vmin+t]
- Window around water pixel is considered
- Local threshold ø is increased slowly till mean difference x of the above window is greater than ∆d
- Then region growing around the water pixel using local threshold ø
#
P.s.: Both global theshold _t_ and mean difference acceptable range _x_ are choosen by trial and error

### Limitation
- Causes overfitting

### Follow Up Work
- Need for a algorithm to determine _t_ without trial and error method.
- Reduce overfitting
