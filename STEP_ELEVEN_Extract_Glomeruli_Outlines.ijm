macro "STEP_ELEVEN_Extract_Glomeruli_Outlines" {
default_path = "Select path"

//Obtain the base information regarding number of directories in the run and location of the run file
Dialog.create("Processing Setup");
Dialog.addNumber("Number of source directories in run:", 4);
Dialog.show();

number_of_directories = Dialog.getNumber();


//setup the variables for the next data entry steps
source_directories = newArray(number_of_directories);
output_directories = newArray(number_of_directories);
quality_check = newArray(number_of_directories);


//get the source directories from the user
Dialog.create("ENTER THE SOURCE DIRECTORIES");
for (i = 0; i < number_of_directories; i++) {
	Dialog.addMessage("SOURCE DIRECTORIES")
  	Dialog.addDirectory("CHANNEL " + (i) + " SEGMENTATED IMAGES: ",default_path);
}
Dialog.show();

for (i = 0; i < number_of_directories; i++) {
	source_directories[i] = Dialog.getString();
}


for(q=0; q<number_of_directories; q++){
files_to_process=getFileList(source_directories[q]); 
number_of_files=files_to_process.length;
max = 0;
max_index = 0;
roiManager("reset");
source_directory_components = split(source_directories[q], "\\"); 
source_last_folder_name = source_directory_components[source_directory_components.length-1]; //find the name of the folder where the source is (one up from the source folder); this will be the root for the output folder
output_directory_components = Array.slice(source_directory_components,0,source_directory_components.length-1); //extract the path to the source folder one level up 
output_directories[q] = String.join(output_directory_components,"\\")+"\\Outlines";
File.makeDirectory(output_directories[q]);
for (aa=0; aa<number_of_files; aa++) {
	current_file=files_to_process[aa];
	open(source_directories[q]+current_file);
	run("Convert to Mask");
	run("Dilate");
	run("Fill Holes");
	run("Erode");
	run("Analyze Particles...", "display add composite");
	n = roiManager("count");
	max = -1;
	max_index = 0;
if(n != 0){
for (i = 0; i < n; i++) {
    roiManager("select", i);
   	roiManager("Measure");
   	if(getResult("Area", i) > max){
   		max = getResult("Area", i);
   		max_index = i;
   	}
}
run("Clear Results");
	roiManager("Select", max_index);
	roiManager("Save", output_directories[q]+"\\"+current_file+"_OUTLINE.roi");
}
	run("Close All");
	roiManager("reset");

}
}
print("Done");
}