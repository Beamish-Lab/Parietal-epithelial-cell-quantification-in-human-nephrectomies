macro "STEP_NINE_Convert_Glomeruli_to_DAB" {
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

//get the source directories from the user
Dialog.create("ENTER THE SOURCE DIRECTORIES");
for (i = 0; i < number_of_directories; i++) {
	Dialog.addMessage("SOURCE DIRECTORIES")
  	Dialog.addDirectory("Original Cropped Images: ", default_path);
}
Dialog.show();

for (i = 0; i < number_of_directories; i++) {
	source_directories[i] = Dialog.getString();
}


for(q=0; q<number_of_directories; q++){
	files_to_process=getFileList(source_directories[q]); 
number_of_files=files_to_process.length;
source_directory_components = split(source_directories[q], "\\"); 
source_last_folder_name = source_directory_components[source_directory_components.length-1]; //find the name of the folder where the source is (one up from the source folder); this will be the root for the output folder
output_directory_components = Array.slice(source_directory_components,0,source_directory_components.length-1); //extract the path to the source folder one level up 
output_directories[q] = String.join(output_directory_components,"\\")+"\\DAB";
File.makeDirectory(output_directories[q]);
for (aa=0; aa<files_to_process.length; aa++) {
	current_file=files_to_process[aa];
	open(source_directories[q]+current_file);
	C2_output_temp_window_name = current_file+"-(Colour_2)";
	run("Colour Deconvolution", "vectors=[User values] " +
		"[r1]=0.651 [g1]=0.701 [b1]=0.29 " +
		"[r2]=0.269 [g2]=0.568 [b2]=0.778 " +
		"[r3]=0.633 [g3]=-0.713 [b3]=0.302");
	selectWindow(C2_output_temp_window_name);
	saveAs("Tiff", output_directories[q]+"\\"+current_file+"_DAB");
	run("Close All");

}}
}
