macro "STEP_THIRTEEN_Make_PEC_and_Podocyte_Images" {
default_path = "\\ENTER YOUR PATH HERE\\"
default_path = "Select path"

//Obtain the base information regarding number of directories in the run and location of the run file
Dialog.create("Processing Setup");
Dialog.addNumber("Number of source directories in run:", 1);
Dialog.show();

number_of_directories = Dialog.getNumber();


//setup the variables for the next data entry steps
source_directories = newArray(number_of_directories);
pecoutput_directories = newArray(number_of_directories);
podooutput_directories = newArray(number_of_directories);
rim_directories = newArray(number_of_directories);

//get the source directories from the user
Dialog.create("ENTER THE SOURCE DIRECTORIES");
for (i = 0; i < number_of_directories; i++) {
	Dialog.addMessage("SOURCE DIRECTORIES")
  	Dialog.addDirectory("CHANNEL " + (i) + " SEGMENTED NUCLEI IMAGES: ",default_path);
  	Dialog.addDirectory("CHANNEL " + (i) + " RIMS: ",default_path);
}
Dialog.show();

for (i = 0; i < number_of_directories; i++) {
	source_directories[i] = Dialog.getString();
	rim_directories[i] = Dialog.getString();
}


for(q=0; q<number_of_directories; q++){

files_to_process=getFileList(source_directories[q]); 
rims=getFileList(rim_directories[q]); 
number_of_files=files_to_process.length;
k=0;
source_directory_components = split(rim_directories[q], "\\"); 
source_last_folder_name = source_directory_components[source_directory_components.length-1]; //find the name of the folder where the source is (one up from the source folder); this will be the root for the output folder
output_directory_components = Array.slice(source_directory_components,0,source_directory_components.length-1); //extract the path to the source folder one level up 
pecoutput_directories[q] = String.join(output_directory_components,"\\")+"\\pecs";
File.makeDirectory(pecoutput_directories[q]);
podooutput_directories[q] = String.join(output_directory_components,"\\")+"\\podos";
File.makeDirectory(podooutput_directories[q]);

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
	open(rim_directories[q]+current_rim);
	run("Select All");
	roiManager("Add");
	roiManager("Select", 0);
	roiManager("Select", newArray(0,2));
	roiManager("XOR");
	roiManager("Add");
	run("Convert to Mask");
	run("Analyze Particles...", "size=5-Infinity display add composite");
	n = roiManager("count");
for (i = 2; i < n; i++) {
    roiManager("select", i);
    roiManager("Measure");
	og_area = getResult("Area", 0);
	seventy_area = og_area * 0.7;
	roiManager("Select", 3);
	roiManager("Select", newArray(3,i));
	roiManager("OR");
	roiManager("add");
	roiManager("Select", n+i-2);
	roiManager("Measure");
	new_area = getResult("Area", 1);
	if(new_area >= seventy_area){
	setForegroundColor(0, 0, 0);
	Roi.setFillColor(0, 0, 0);
	roiManager("Fill");
	roiManager("Select", 1);
	setForegroundColor(0, 0, 0);
	Roi.setFillColor(0, 0, 0);
	roiManager("Fill");
	}
}
	saveAs("Tiff", pecoutput_directories[q]+"\\"+current_file+"_PECS");
	roiManager("reset");
	run("Close All");
	open(source_directories[q]+current_file);
	open(rim_directories[q]+current_rim);
	run("Select All");
	roiManager("Add");
	roiManager("Select", newArray(1,2));
	roiManager("XOR");
	roiManager("Add");
	run("Convert to Mask");
	run("Analyze Particles...", "size=5-Infinity display add composite");
	n = roiManager("count");
for (i = 2; i < n; i++) {
    roiManager("select", i);
    roiManager("Measure");
	og_area = getResult("Area", 0);
	seventy_area = og_area * 0.7;
	roiManager("Select", 3);
	roiManager("Select", newArray(3,i));
	roiManager("OR");
	roiManager("add");
	roiManager("Select", n+i-2);
	roiManager("Measure");
	new_area = getResult("Area", 1);
	if(new_area >= seventy_area){
	setForegroundColor(0, 0, 0);
	Roi.setFillColor(0, 0, 0);
	roiManager("Fill");
	roiManager("Select", 1);
	setForegroundColor(0, 0, 0);
	Roi.setFillColor(0, 0, 0);
	roiManager("Fill");
	}
}
	saveAs("Tiff", podooutput_directories[q]+"\\"+current_file+"_Podocytes");
	roiManager("reset");
	run("Close All");
}}
print("Done");
}