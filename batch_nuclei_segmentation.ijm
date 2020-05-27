// Created as part of the Online Workshop 
// FIJI Macro Writing for Cell Biologist by the University of Melbourne (Facilitator: Dr Ellie Hyun-Jung Cho, twitter.com/EllieCho_7)
// https://microscopy.unimelb.edu.au/#om
// More Resources: https://microscopy.unimelb.edu.au/optical-microscopy/fiji-workshop-resources 

// Batch Cell counting template

// Set input and output directories
indir = getDirectory("Select Input Directory");
outdir = getDirectory("Pick Output Directory");
list = getFileList(indir);

// start batch for loop
setBatchMode(true);
for (i = 0; i < list.length; i++) {
	
// Open image, get name, duplicate
open(indir + list[i]);
nameonly = File.nameWithoutExtension;
run("Duplicate...", "title=dup");

// make binary, watershed, analyze particles 
selectWindow(list[i]);
setAutoThreshold("Default dark");
setOption("BlackBackground", true);
run("Convert to Mask");
run("Watershed");
run("Set Measurements...", "area mean redirect=dup decimal=3");
run("Analyze Particles...", "size=100-Infinity circularity=0.50-1.00 show=[Bare Outlines] display exclude summarize");

// made proof image
rename("outline");
run("Invert");
imageCalculator("Add", "dup","outline");

// save proof images
selectWindow("dup");
outname = nameonly + "_result";
saveAs("jpeg", outdir + outname);
selectWindow("Results");
saveAs("txt", outdir + outname + "_results.csv");
selectWindow("Summary");
saveAs("txt", outdir + outname + "_summary.csv");
close(outname + "_summary.csv");
close(outname + "_results.csv");
// Clean Wroskpace
run("Close All");
run("Collect Garbage");

}
close("Results");