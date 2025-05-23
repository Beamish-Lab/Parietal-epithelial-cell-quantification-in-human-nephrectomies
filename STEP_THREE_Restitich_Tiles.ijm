macro "STEP_THREE_Restitich_Tiles" {
//default_path = "\\ENTER YOUR PATH HERE\\"
default_path = "Select path"

//Obtain the base information regarding number of directories in the run and location of the run file
Dialog.create("Processing Setup");
Dialog.addNumber("Number of source directories in run:", 4);
Dialog.addString("Rescale Fold:", "4");
Dialog.addString("Tile Size:", "13000");
Dialog.show();

number_of_directories = Dialog.getNumber();
num = Dialog.getString();
tile_size = Dialog.getString();

//setup the variables for the next data entry steps
source_directories = newArray(number_of_directories);
output_directories = newArray(number_of_directories);


//get the source directories from the user
Dialog.create("ENTER THE SOURCE DIRECTORIES");
for (i = 0; i < number_of_directories; i++) {
	Dialog.addMessage("SOURCE DIRECTORIES")
  	Dialog.addDirectory("CHANNEL " + (i) + " RESCALED OUTPUT: ",default_path);
}
Dialog.show();

for (i = 0; i < number_of_directories; i++) {
	source_directories[i] = Dialog.getString();
}

for(q = 0; q<number_of_directories;q++){
files_to_process=getFileList(source_directories[q]); 
number_of_files=files_to_process.length;
rows = 0;
columns =0;
for (i = 0; i < number_of_files; i++) {
	current_file=files_to_process[i];
	for (j = 0; j < number_of_files; j++) {
		if(indexOf(current_file,"1_"+(j*tile_size)+"_0") != -1){
			columns = columns+1;
		}
	}
}

for (i = 0; i < number_of_files; i++) {
	current_file=files_to_process[i];
	if(indexOf(current_file,"1_0_") != -1){
		rows = rows+1;
	}
}
print(rows);
print(columns);


for (i = 0; i < rows; i++) {
	for (j = 0; j < columns; j++) {
		check = "_1_"+(j*tile_size)+"_"+(i*tile_size)+"_";
		for (aa=0; aa<number_of_files; aa++) {
			current_file=files_to_process[aa];
			index = indexOf(current_file, ".svs");
			RootName = substring(current_file, 0, index);
				if(indexOf(current_file, check) != -1){
					open(source_directories[q]+current_file);
					//waitForUser;
			}
		}
	}
}
run("Images to Stack", "method=[Copy (top-left)] use");
run("Make Montage...", "columns="+columns+" rows="+rows+" scale=1");
selectWindow("Stack");
close();
source_directory_components = split(source_directories[q], "\\"); 
source_last_folder_name = source_directory_components[source_directory_components.length-1]; //find the name of the folder where the source is (one up from the source folder); this will be the root for the output folder
output_directory_components = Array.slice(source_directory_components,0,source_directory_components.length-1); //extract the path to the source folder one level up 
output_directories[q] = String.join(output_directory_components,"\\")+"\\"+RootName+" Restitch "+num;
File.makeDirectory(output_directories[q]);
saveAs("Tiff", output_directories[q]+"\\"+RootName+"_Restitch");
run("Close All");
}
print("Done");
}