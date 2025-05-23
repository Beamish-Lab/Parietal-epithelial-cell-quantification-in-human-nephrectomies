macro "STEP_FIFTEEN_Per_Patient_Data_Extraction" {
default_path = "\\ENTER YOUR PATH HERE\\"
default_path = "Select path"

//Obtain the base information regarding number of directories in the run and location of the run file
Dialog.create("Processing Setup");
Dialog.addNumber("Number of source directories in run:", 1);
Dialog.show();

number_of_directories = Dialog.getNumber();


//setup the variables for the next data entry steps
pecsource_directories = newArray(number_of_directories);
podosource_directories = newArray(number_of_directories);
output_directories = newArray(number_of_directories);
outline_directories = newArray(number_of_directories);
rim_directories = newArray(number_of_directories);

//get the source directories from the user
Dialog.create("ENTER THE SOURCE DIRECTORIES");
for (i = 0; i < number_of_directories; i++) {
	Dialog.addMessage("SOURCE DIRECTORIES")
  	Dialog.addDirectory("CHANNEL " + (i) + " SEGMENTED PEC IMAGES: ",default_path);
  	Dialog.addDirectory("CHANNEL " + (i) + " SEGMENTED PODOCYTE IMAGES: ",default_path);
  	Dialog.addDirectory("CHANNEL " + (i) + " OUTLINES : ",default_path);
}
Dialog.show();

for (i = 0; i < number_of_directories; i++) {
	pecsource_directories[i] = Dialog.getString();
	podosource_directories[i] = Dialog.getString();
	outline_directories[i] = Dialog.getString();
}

time_stamp = Make_Time_Stamp();
for(q=0; q<number_of_directories; q++){
pecs_to_process=getFileList(pecsource_directories[q]); 
podo_to_process=getFileList(podosource_directories[q]);
outlines=getFileList(outline_directories[q]); 
number_of_files=pecs_to_process.length;
kid_id = newArray();
glo_id = newArray();
nuclei_id = newArray();
glo_count = newArray();
nuclei_count = newArray();
pec_count = newArray();
podo_count = newArray();
glo_perim = newArray();
glo_area = newArray();
pax8_area = newArray();
pax8_feretdi = newArray();
pax8_mindi = newArray();
pax8_perim = newArray();
pax8_round = newArray();
peccount_per_gloperim = newArray();
podo_per_gloarea = newArray();
count = 0;
av_kid_id = newArray();
av_glo_count= newArray();
av_pec_count =newArray();
av_podo_count=newArray();
av_nuclei_count =newArray();
av_glo_perim =newArray();
av_glo_area = newArray();
av_pax8_area = newArray();
av_pax8_feretdi=newArray();
av_pax8_mindi= newArray();
av_pax8_perim = newArray();
av_pax8_round = newArray();
av_peccount_per_gloperim = newArray();
av_podo_per_area = newArray();
source_directory_components = split(outline_directories[q], "\\"); 
source_last_folder_name = source_directory_components[source_directory_components.length-1]; //find the name of the folder where the source is (one up from the source folder); this will be the root for the output folder
output_directory_components = Array.slice(source_directory_components,0,source_directory_components.length-1); //extract the path to the source folder one level up 
output_directories[q] = String.join(output_directory_components,"\\");
for (aa=0; aa<number_of_files; aa++) {
	pax8_area_sum = 0;
	pax8_feretdi_sum  = 0;
	pax8_mindi_sum = 0;
	pax8_perim_sum  = 0;
	pax8_round_sum = 0;
	glo_count_curr = number_of_files;
	open(pecsource_directories[q]+pecs_to_process[aa]);
	current_seg = pecs_to_process[aa];
	component = split(current_seg, "_");
	kid_id_curr = component[0];
	glo_id_curr = component[2];
	check_name = component[0]+"_"+component[1]+"_"+component[2]+"_";
	roiManager("reset");
	run("Convert to Mask");
	run("Set Measurements...", "area perimeter shape feret's display redirect=None decimal=6");
	outline_index = 0;
	for(x = 0; x< outlines.length;x++){
		if(indexOf(outlines[x], check_name) != -1){
			outline_index = x;
		}
	}
	open(outline_directories[q]+outlines[outline_index]);
	roiManager("Add");
	roiManager("Select", 0);
	roiManager("Measure");
	glo_perim[count] = getResult("Perim.", 0);
	glo_area[count] = getResult("Area", 0);
	roiManager("reset");
	run("Clear Results");
	run("Analyze Particles...", "size=3-Infinity display add composite");
	n = roiManager("count");
	pecs = n;
	kid_id[count] = kid_id_curr;
	glo_id[count]  = glo_id_curr;
	pec_count[count]  = n;
	for (i = 0; i < n; i++) {
	pax8_area_sum = pax8_area_sum+getResult("Area", i);
	pax8_feretdi_sum  = pax8_feretdi_sum+getResult("Feret", i);
	pax8_mindi_sum = pax8_mindi_sum+getResult("MinFeret", i);
	pax8_perim_sum  = pax8_perim_sum+getResult("Perim.", i);
	pax8_round_sum  = pax8_round_sum+getResult("Round", i);
}
run("Close All");
roiManager("reset");
run("Clear Results");

	open(podosource_directories[q]+podo_to_process[aa]);
	open(outline_directories[q]+outlines[outline_index]);
	roiManager("Add");
	roiManager("Select", 0);
	roiManager("Measure");
	glo_perim[count] = getResult("Perim.", 0);
	glo_area[count] = getResult("Area", 0);
	run("Convert to Mask");
	roiManager("reset");
	run("Clear Results");
	run("Analyze Particles...", "size=3-Infinity display add composite");
	n = roiManager("count");
	kid_id[count] = kid_id_curr;
	glo_id[count]  = glo_id_curr;
	pec_count[count] = pecs;
	podo_count[count] = n;
	nuclei_count[count]  = n+pecs;
	for (i = 0; i < n; i++) {
	pax8_area_sum = pax8_area_sum+getResult("Area", i);
	pax8_feretdi_sum  = pax8_feretdi_sum+getResult("Feret", i);
	pax8_mindi_sum = pax8_mindi_sum+getResult("MinFeret", i);
	pax8_perim_sum  = pax8_perim_sum+getResult("Perim.", i);
	pax8_round_sum  = pax8_round_sum+0;
}

	glo_count[count] = glo_count_curr;
	pax8_area[count]  = pax8_area_sum/(n+pecs);
	pax8_feretdi[count]  = pax8_feretdi_sum/(n+pecs);
	pax8_mindi[count]  = pax8_mindi_sum/(n+pecs);
	pax8_perim[count]  = pax8_perim_sum/(n+pecs);
	pax8_round[count]  = pax8_round_sum/(pecs);
	peccount_per_gloperim[count] = pec_count[count]/glo_perim[count];
	podo_per_gloarea[count] = podo_count[count]/glo_area[count];
	count++;
run("Close All");
roiManager("reset");
run("Clear Results");
}

	av_glo_count[0]=0;
	av_pec_count[0] =0;
	av_podo_count[0]=0;
	av_nuclei_count[0] = 0;
	av_glo_perim[0] = 0;
	av_glo_area[0] = 0;
	av_pax8_area[0] = 0;
	av_pax8_feretdi[0]= 0;
	av_pax8_mindi[0]= 0;
	av_pax8_perim[0] = 0;
	av_pax8_round[0] = 0;
	av_peccount_per_gloperim[0] = 0;
	av_podo_per_area[0] = 0;
for(i=0; i<glo_count.length;i++){
	av_glo_count[0]+=glo_count[i];
	av_pec_count[0] +=pec_count[i];
	av_podo_count[0]+=podo_count[i];
	av_nuclei_count[0] += nuclei_count[i];
	av_glo_perim[0] += glo_perim[i];
	av_glo_area[0] += glo_area[i];
	av_pax8_area[0] += pax8_area[i];
	av_pax8_feretdi[0]+= pax8_feretdi[i];
	av_pax8_mindi[0]+= pax8_mindi[i];
	av_pax8_perim[0] += pax8_perim[i];
	av_peccount_per_gloperim[0] += peccount_per_gloperim[i];
	av_podo_per_area[0] += podo_per_gloarea[i];
}
for(i=0;i<pax8_round.length;i++){
	if(pax8_round[i] > 0){
	print(pax8_round[i]);
	av_pax8_round[0] +=pax8_round[i];
	print(av_pax8_round[0]);
	}
}


av_kid_id[0] = kid_id[0];
av_glo_count[0] = av_glo_count[0]/glo_count.length;
av_pec_count[0] =av_pec_count[0]/glo_count.length;
av_podo_count[0]=av_podo_count[0]/glo_count.length;
av_nuclei_count[0] = av_nuclei_count[0]/glo_count.length;
av_glo_perim[0] =av_glo_perim[0]/glo_count.length;
av_glo_area[0] = av_glo_area[0]/glo_count.length;
av_pax8_area[0] = av_pax8_area[0]/glo_count.length;
av_pax8_feretdi[0]=av_pax8_feretdi[0]/glo_count.length;
av_pax8_mindi[0]= av_pax8_mindi[0]/glo_count.length;
av_pax8_perim[0] = av_pax8_perim[0]/glo_count.length;
av_pax8_round[0] = av_pax8_round[0]/glo_count.length;
av_peccount_per_gloperim[0] = av_peccount_per_gloperim[0]/glo_count.length;
av_podo_per_area[0] = av_podo_per_area[0]/glo_count.length;
run_file_name ="Patient Kidney Anaylsis_" + time_stamp +".csv";
Table.create(run_file_name);
Table.setColumn("Kidney ID", av_kid_id);
Table.setColumn("Glomeruli Count", av_glo_count);
Table.setColumn("Average Nuclei Count", av_nuclei_count);
Table.setColumn("Average PEC Count", av_pec_count);
Table.setColumn("Average Podocyte Count", av_podo_count);
Table.setColumn("Average Glomeruli Perim.", av_glo_perim);
Table.setColumn("Average Glomeruli Area", av_glo_area);
Table.setColumn("Average Nuclei Surface Area", av_pax8_area);
Table.setColumn("Average Nuclei Feret", av_pax8_feretdi);
Table.setColumn("Average Nuclei MinFeret", av_pax8_mindi);
Table.setColumn("Average Nuclei Perim.", av_pax8_perim);
Table.setColumn("Average Nuclei Circ.", av_pax8_round);
Table.setColumn("Average PEC Count per Glomeruli Perim.", av_peccount_per_gloperim);
Table.setColumn("Average Podocyte Count per Glomeruli Area", av_podo_per_area);
Table.save(output_directories[q] + "\\"+run_file_name);
	}

print("Done");
}

function Make_Time_Stamp () {
    //function to make a time stamp of all digits e.g. 04052021_1423 for April 5, 2021 at 2:23 PM
     getDateAndTime(year, month, dayOfWeek, dayOfMonth, hour, minute, second, msec);
     if (month<9) {time_stamp_output = "0";}//month is a zero based index 
     time_stamp_output = d2s(month+1,0);//month is a zero based index 
     if (dayOfMonth<10) {time_stamp_output = time_stamp_output+"0";}
     time_stamp_output = time_stamp_output+dayOfMonth;
     time_stamp_output = time_stamp_output+year+"_";
     if (hour<10) {time_stamp_output = time_stamp_output+"0";}
     time_stamp_output = time_stamp_output+hour;
     if (minute<10) {time_stamp_output = time_stamp_output+"0";}
     time_stamp_output = time_stamp_output+minute;
     return time_stamp_output;
  }