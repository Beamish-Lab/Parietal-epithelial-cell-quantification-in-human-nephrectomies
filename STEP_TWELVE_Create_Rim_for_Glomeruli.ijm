macro "STEP_TWELVE_Create_Rim_for_Glomeruli" {
default_path = "Select path"

//Obtain the base information regarding number of directories in the run and location of the run file
Dialog.create("Processing Setup");
Dialog.addNumber("Number of source directories in run:", 1);
Dialog.show();

number_of_directories = Dialog.getNumber();


//setup the variables for the next data entry steps
source_directories = newArray(number_of_directories);
roi_directories = newArray(number_of_directories);
rim_directories = newArray(number_of_directories);
pax8_directories = newArray(number_of_directories);


//get the source directories from the user
Dialog.create("ENTER THE SOURCE DIRECTORIES");
for (i = 0; i < number_of_directories; i++) {
	Dialog.addMessage("SOURCE DIRECTORIES")
  	Dialog.addDirectory("CHANNEL " + (i) + " Segmented Glomeruli: ",default_path);
  	Dialog.addDirectory("CHANNEL " + (i) + " Outline ROIs: ",default_path);
}
Dialog.show();

for (i = 0; i < number_of_directories; i++) {
	source_directories[i] = Dialog.getString();
	roi_directories[i] = Dialog.getString();
}


for(q=0; q<number_of_directories; q++){
files_to_process=getFileList(source_directories[q]); 
rois_to_process=getFileList(roi_directories[q]); 
rim_to_process=getFileList(rim_directories[q]); 
pax8_to_process=getFileList(pax8_directories[q]); 
number_of_files=files_to_process.length;
source_directory_components = split(source_directories[q], "\\"); 
source_last_folder_name = source_directory_components[source_directory_components.length-1]; //find the name of the folder where the source is (one up from the source folder); this will be the root for the output folder
output_directory_components = Array.slice(source_directory_components,0,source_directory_components.length-1); //extract the path to the source folder one level up 
rim_directories[q] = String.join(output_directory_components,"\\")+"\\Rims";
File.makeDirectory(rim_directories[q]);
for (aa=0; aa<rois_to_process.length; aa++) {
	roiManager("reset");
	current_file=files_to_process[aa];
	run("Close All");
	open(source_directories[q]+current_file);
	open(roi_directories[q]+rois_to_process[aa]);
	roiManager("add");
roiManager("Select", 0);
RoiManager.scale(1.05, 1.05, true);
roiManager("add");
roiManager("Select", 1);
RoiManager.scale(0.82, 0.82, true);
roiManager("add");
roiManager("Select", 2);
roiManager("delete");
roiManager("Select", 1);
roiManager("Rename", "IN");
roiManager("Select", 0);
roiManager("Rename", "OUT");
roiManager("save",  rim_directories[q]+"\\"+rois_to_process[aa]+"_RIM.zip");
run("Close All");
roiManager("reset");
	}
	roiManager("reset");
	run("Close All");
}
print("Done");
}