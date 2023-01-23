# Inundated_Area_Identification
## Version 1
### Key Points are:
- Image pixel values converted into 0-1 range
- Minimum value for Global Threshold, _t_ is selected
- This is increased by small value locally till mean difference is more than _x_
- The local threshold is then used for region growing
#
P.s.: Both global theshold _t_ and mean difference acceptable range _x_ are choosen by trial and error

### Limitation
- Global threshold and mean difference acceptable range keep changing for different image
- This method either causes overfitting or underfitting.

### Follow Up Work
- Need for a algorithm to determine _t_ and _x_ without trial and error method applicable for all kind of data.
