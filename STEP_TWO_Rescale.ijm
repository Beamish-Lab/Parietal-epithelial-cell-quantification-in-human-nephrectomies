macro "STEP_TWO_Rescale" {
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
scaling_factors = newArray(number_of_directories);

//get the source directories from the user
//Set scaling factor
Dialog.create("ENTER THE SOURCE DIRECTORIES");
for (i = 0; i < number_of_directories; i++) {
	Dialog.addMessage("SOURCE DIRECTORIES")
  	Dialog.addDirectory("Tiled Images: ", default_path);
	Dialog.addDirectory("Output Folder: ", default_path);
	Dialog.addNumber("Scaling Factor", 4);
}
Dialog.show();

for (i = 0; i < number_of_directories; i++) {
	source_directories[i] = Dialog.getString();
	output_directories[i] = Dialog.getString();
	scaling_factors[i] = Dialog.getNumber();
}


for(q=0; q<number_of_directories; q++){
	files_to_process=getFileList(source_directories[q]); 
number_of_files=files_to_process.length;
for (aa=0; aa<files_to_process.length; aa++) {
	current_file=files_to_process[aa];
	open(source_directories[q]+current_file);
	index = indexOf(current_file, ".tif");
	RootName = substring(current_file, 0, index);
	width = getWidth();
	height = getHeight();
	run("Size...", "width="+width/scaling_factors[q]+" height="+height/scaling_factors[q]+" depth=1 constrain average interpolation=Bilinear");
	saveAs("Tiff", output_directories[q]+RootName+"_Rescale");
	run("Close All");

}}
}