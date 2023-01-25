# Inundated_Area_Identification
## Version 3
### Key Points are:
- Image pixel values converted into 0-1 range
- Minimum pixel, _Vmin_ intensity value is found from the whole image
- The Global Threshold, _t_ is selected 
- This threshold is used to find the water pixel, global range for water pixel is [Vmin,Vmin+t]
- Window around water pixel is considered
- Local threshold _ø_ is increased slowly till mean difference _x_ of the above window is greater than ∆d
- Then region growing around the water pixel using local threshold _ø_

### Limitation
- Causes overfitting 

### Follow Up Work
- Reduce overfitting
