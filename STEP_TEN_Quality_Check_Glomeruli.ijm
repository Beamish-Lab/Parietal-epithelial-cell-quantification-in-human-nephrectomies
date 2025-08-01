macro "STEP_TEN_Quality_Check_Glomeruli" {
default_path = "\\ENTER YOUR PATH HERE\\"

//get information
Dialog.create("Enter annotation information")
Dialog.addMessage("This macro will remove non-glomeruli" );
Dialog.addDirectory("Cropped Glomeruli: ", default_path);
Dialog.addDirectory("DAB Glomeruli: ", default_path);
Dialog.addDirectory("Output: ", default_path);
Dialog.show();


source_directory = Dialog.getString();
seg_dir = Dialog.getString();
output_directory = Dialog.getString();
files_to_process=getFileList(source_directory); 
seg_to_process = getFileList(seg_dir); 
number_of_files=files_to_process.length;
items = newArray("REMOVE", "SAVE");
for (aa=0; aa<number_of_files; aa++) {
	current_file=files_to_process[aa];
	for(i = 0; i<seg_to_process.length; i++){
		if(indexOf(seg_to_process[i], substring(current_file, 0,current_file.length-4)) != -1){
			open(seg_dir+seg_to_process[i]);
			seg_current = seg_to_process[i];
		}
	}
	Dialog.create("Should this image be removed?")
	Dialog.addRadioButtonGroup("Select REMOVE if non-glomeruli", items, 1, 2, "SAVE");
	Dialog.show();
	answer = Dialog.getRadioButton();
	if(answer == "SAVE"){
		saveAs("Tiff", output_directory+seg_current);
	}
	run("Close All");
}
}