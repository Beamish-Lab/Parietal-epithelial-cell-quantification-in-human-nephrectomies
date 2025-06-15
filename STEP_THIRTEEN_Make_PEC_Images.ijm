macro "STEP_THIRTEEN_Make_PEC_Images" {
default_path = "\\ENTER YOUR PATH HERE\\"
default_path = "Select path"

//Obtain the base information regarding number of directories in the run and location of the run file
Dialog.create("Processing Setup");
Dialog.addNumber("Number of source directories in run:", 1);
Dialog.show();

number_of_directories = Dialog.getNumber();


//setup the variables for the next data entry steps
source_directories = newArray(number_of_directories);
output_directories = newArray(number_of_directories);
rim_directories = newArray(number_of_directories);

//get the source directories from the user
Dialog.create("ENTER THE SOURCE DIRECTORIES");
for (i = 0; i < number_of_directories; i++) {
	Dialog.addMessage("SOURCE DIRECTORIES")
  	Dialog.addDirectory("CHANNEL " + (i) + " SEGMENTED PAX8 IMAGES: ",default_path);
  	Dialog.addDirectory("CHANNEL " + (i) + " RIMS: ",default_path);
  	Dialog.addDirectory("CHANNEL " + (i) + " OUTPUT: ",default_path);
}
Dialog.show();

for (i = 0; i < number_of_directories; i++) {
	source_directories[i] = Dialog.getString();
	rim_directories[i] = Dialog.getString();
	output_directories[i] = Dialog.getString();
}


for(q=0; q<number_of_directories; q++){

files_to_process=getFileList(source_directories[q]); 
rims=getFileList(rim_directories[q]); 
number_of_files=files_to_process.length;
k=0;

for (aa=0; aa<number_of_files; aa++) {
	run("Clear Results");
	run("Close All");
	roiManager("reset");
	run("Set Measurements...", "area centroid display redirect=None decimal=3");
	current_file=files_to_process[aa];
	index = indexOf(current_file, "Cropped");
	for (i = 0; i < rims.length; i++) {
		if(indexOf(rims[i], substring(current_file,0,index)) != -1){
			current_rim = rims[i];
		}
	}
	open(source_directories[q]+current_file);
	print(current_file);
	open(rim_directories[q]+current_rim);
	print(current_rim);
	width = getWidth();
	height = getHeight();
	run("Convert to Mask");
run("Analyze Particles...", "size=5-Infinity display add composite");
run("Clear Results");
n = roiManager("count");
roi_count = 3;
roi_index = 2;
select_rois = newArray();
count = 0;
end_roi = n;
roiManager("Select", 0);
roiManager("Measure");
roiManager("Select", 1);
roiManager("Measure");
out_area = getResult("Area", 0);
in_area = getResult("Area", 1);
run("Clear Results");
current_count = roiManager("count");
while(roi_count<n && roi_index<current_count) {
	run("Set Measurements...", "area centroid display redirect=None decimal=3");
	run("Clear Results");
	roiManager("select", roi_index);
	roiManager("Measure");
	og_area = getResult("Area", 0);
	thirty_area = og_area * 0.3;
	seventy_area = og_area * 0.7;
	roiManager("Select", newArray(0,roi_index));
	roiManager("OR");
	roiManager("add");
	roiManager("Select", newArray(1,roi_index));
	roiManager("OR");
	roiManager("add");
	end_roi = roiManager("count")-1;
	roiManager("select", end_roi);
	roiManager("Measure");
	new_IN_area = getResult("Area", 1);
	roiManager("select", end_roi-1);
	roiManager("Measure");
	new_OUT_area = getResult("Area", 2);
	roiManager("select", end_roi);
	roiManager("delete");
	roiManager("select", end_roi-1);
	roiManager("delete");
	if(new_IN_area == in_area){
		roiManager("select", roi_index);
		roiManager("delete");
	}
	if(new_IN_area != in_area && out_area == new_OUT_area){
		if(new_IN_area >= (in_area + seventy_area)){
			select_rois[count] = i;
			count++;
			roi_index++;
		}
		else{
		roiManager("select", roi_index);
		roiManager("delete");
	}
	}
	else if(new_OUT_area != out_area){
		if(new_OUT_area <= out_area+thirty_area){
			select_rois[count] = i;
			count++;
			roi_index++;
		}
		else{
		roiManager("select", roi_index);
		roiManager("delete");
	}
	}
roi_count++;
current_count = roiManager("count");
   
}
newImage(current_file+"_Multipoint", "8-bit black", width, height, 1);
selectImage(current_file+"_Multipoint");
roiManager("Select", 0);
roiManager("delete");
roiManager("Select", 0);
roiManager("delete");
n = roiManager("count");
for (i = 0; i < n; i++) {
    roiManager("select", i);
    setForegroundColor(128, 128, 128);
    roiManager("Fill");
}
for (i = 0; i < n; i++) {
    roiManager("select", 0);
    roiManager("delete");
}
roiManager("Show All without labels");
saveAs("Zip", output_directories[q] + current_file+"_Multipoint");
run("Close All");
roiManager("reset");
}}
print("Done");
)


