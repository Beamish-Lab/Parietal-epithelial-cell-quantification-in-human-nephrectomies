macro "STEP_EIGHT_Crop_Glomeruli" {
default_path = "\\ENTER YOUR PATH HERE\\"
default_path = "Select path"

//Obtain the base information regarding number of directories in the run and location of the run file
Dialog.create("Processing Setup");
Dialog.addNumber("Number of source directories in run:", 4);
Dialog.show();

number_of_directories = Dialog.getNumber();


//setup the variables for the next data entry steps
source_directories = newArray(number_of_directories);
output_directories = newArray(number_of_directories);
ROI_directories = newArray(number_of_directories);
corr_dir = newArray(number_of_directories);

//get the source directories from the user
Dialog.create("ENTER THE SOURCE DIRECTORIES");
for (i = 0; i < number_of_directories; i++) {
	Dialog.addMessage("SOURCE DIRECTORIES")
  	Dialog.addDirectory("CHANNEL " + (i) + " FULL RESOLUTION RESTITCH IMAGES: ",default_path);
  	Dialog.addDirectory("CHANNEL " + (i) + " ROI OUTPUT FROM PP2: ",default_path);
}
Dialog.show();

for (i = 0; i < number_of_directories; i++) {
	source_directories[i] = Dialog.getString();
	ROI_directories[i] = Dialog.getString();
}


for(q=0; q<number_of_directories; q++){
count = 0;
files_to_process=getFileList(source_directories[q]); 
rois_to_process=getFileList(ROI_directories[q]); 
number_of_files=files_to_process.length;
number_of_rois = rois_to_process.length;
x_corr = newArray();
y_corr = newArray();
glo_id = newArray();
source_directory_components = split(ROI_directories[q], "\\"); 
source_last_folder_name = source_directory_components[source_directory_components.length-1]; //find the name of the folder where the source is (one up from the source folder); this will be the root for the output folder
output_directory_components = Array.slice(source_directory_components,0,source_directory_components.length-1); //extract the path to the source folder one level up 
output_directories[q] = String.join(output_directory_components,"\\")+"\\cropped";
corr_dir[q] =  String.join(output_directory_components,"\\");
File.makeDirectory(output_directories[q]);
for(p=0;p<number_of_files;p++){
for (i = 0; i < number_of_rois; i++) {
	roiManager("reset");
	open(source_directories[q]+files_to_process[p]);
	open(ROI_directories[q]+rois_to_process[i]);
	roiManager("add");
	roiManager("Select", 0);
	run("Enlarge...", "enlarge=50");
	roiManager("Update");
	roiManager("Select", 0);
	run("Select Bounding Box");
	roiManager("add");
	roiManager("Select", 0);
	run("From ROI Manager");
	run("Set Measurements...", "area centroid perimeter shape feret's display redirect=None decimal=6");
	roiManager("Select", 1);
	roiManager("measure");
	x_corr[count] = getResult("X", i);
	y_corr[count] = getResult("Y", i);
	glo_id[count] = i;
	run("Crop");
	saveAs("Tiff", output_directories[q]+"\\"+files_to_process[p]+"_"+rois_to_process[i]+"_Cropped");
	run("Close All");
	count=count+1;
}
run("Clear Results");
count=count+1;
}
run_file_name ="Corrdinates Glomeruli.csv";
Table.create(run_file_name);
Table.setColumn("Glomeruli ID", glo_id);
Table.setColumn("X Corrdinate", x_corr);
Table.setColumn("Y Corrdinate", y_corr);
Table.save(corr_dir[q]+"\\" + run_file_name);
run("Clear Results");
count=0;
}
print("Done");
}
