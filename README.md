# ImageGrid
 Create a grid of microscopy images for quick visualization

1. Open Fiji/ImageJDrag, Plugins->New->Macro 
2. Copy and paste contents of ND2toPNG_FIJI_Macro.ijm into this new macro folder (optionally save this macro file for ease of use in the future)
3. Run fiji macro, it will ask how many color channels your image has, if you would like to exclude any from being shown individually (ex. Dapi), then it will ask for the directory of ND2 images
    - This script assumes your images are z-stacks and will make max IP z stacks, delete this part of the code if your images are not z-stacks
4. Open imagegrid.ipynb, run this script to create quick grid of all the png files the fiji macro generated