// Copy and paste this script into a new Macro in Fiji/ImageJ and run there


input = getDirectory("Choose a Directory");
list = getFileList(input);
output = input + "Max Projections" + File.separator;

setBatchMode(true);

// Check if output file already exists in this directory
if (File.exists(output)) 
  exit("Destination directory already exists; remove it and then run this macro again");

// Make output file
File.makeDirectory(output);

// Ask user for number of colors
numberOfColors = getNumber("Enter the number of colors:", 3);

// Ask user if they want to exclude any channels
excludeResponse = getString("Do you want to exclude any channels from being saved individually? (yes/no)", "no");
excludeChannel = false;
channelToExclude = 0;

if (excludeResponse == "yes") {
    excludeChannel = true;
    channelToExclude = getNumber("Enter the channel number to exclude (1 to " + numberOfColors + "):", 1);
}

zstackResponse = getString("Do you want to z-stack your images? (yes/no)", "yes");

// Cycle through each image in file
for (i = 0; i < list.length; i++) { 
    if (endsWith(list[i], ".nd2")) {
        // Open image
        run("Bio-Formats Importer", "open=[" + input + list[i] + "] autoscale color_mode=Colorized rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        
        if (zstackResponse == "yes") {
            // Max intensity z projection 
            run("Z Project...", "projection=[Max Intensity]"); 
            imageName = getTitle();
            print(imageName);
        } else {
            imageName = getTitle();
            print(imageName);
        }
        // // Max intensity z projection 
        // run("Z Project...", "projection=[Max Intensity]"); 
        // imageName = getTitle();
        // print(imageName);
        
        // Duplicate image, merge duplicate, then save merged image as png
        run("Duplicate...", "duplicate");
        Property.set("CompositeProjection", "Sum");
        Stack.setDisplayMode("composite");
        saveAs("png", output + (i+1) + "_" + imageName + "_merge.png");
        
        // Split original MAX image into separate channels
        selectWindow(imageName);
        run("Split Channels");
        
        // For each channel, adjust brightness, then save as png
        for (j=1; j<=numberOfColors; j++) {
            splitImageName = "C" + j + "-" + imageName;
            selectWindow(splitImageName);
            print(getTitle());
            
            // Save color channels selectively
            if (!(excludeChannel && j == channelToExclude)) {
                saveAs("png", output + (i+1) + "_" + splitImageName + ".png");
            }
        }
     
        // Close all windows to prepare for the next image
        while (nImages > 0) {
            selectImage(nImages);
            close();
        }
    } 
}
