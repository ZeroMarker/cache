// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function SelectRowHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	if(row==0) {
		return false;
	}
	var urlObj=document.getElementById("HiddenURLz"+row);
	var RollRowID,PosRowID,PatientID,MRType,RTMASMRNo,DOB,SURName,GIVName,RollNo,POSRTMASDR,IsBulkEdit,path,TWKFL,context,hidRegNo,PinVerified,TWKFLI,RollHosp="";
	
	var Obj=document.getElementById("hidRollRowIDz"+row);
	if ((Obj)&&(Obj.value)!="") RollRowID=Obj.value;
	var Obj=document.getElementById("hidPosRowIDz"+row);
	if ((Obj)&&(Obj.value)!="") PosRowID=Obj.value;
	//var Obj=document.getElementById("PatientIDz"+row);
	//if ((Obj)&&(Obj.value)!="") PatientID=Obj.value;
	PatientID=""
	var Obj=document.getElementById("hidMRTypez"+row);
	if ((Obj)&&(Obj.value)!="") MRType=Obj.value;
	var Obj=document.getElementById("hidRTMASMRNoz"+row);
	if ((Obj)&&(Obj.value)!="") RTMASMRNo=Obj.value;
	var Obj=document.getElementById("hidDOBz"+row);
	if ((Obj)&&(Obj.value)!="") DOB=Obj.value;
	var Obj=document.getElementById("hidSURNamez"+row);
	if ((Obj)&&(Obj.value)!="") SURName=Obj.value;
	var Obj=document.getElementById("hidGIVNamez"+row);
	if ((Obj)&&(Obj.value)!="") GIVName=Obj.value;
	var Obj=document.getElementById("hidRollNoz"+row);
	if ((Obj)&&(Obj.value)!="") RollNo=Obj.value;
	var Obj=document.getElementById("hidPOSRTMASDRz"+row);
	if ((Obj)&&(Obj.value)!="") POSRTMASDR=Obj.value;
	var Obj=document.getElementById("IsBulkEdit");
	if ((Obj)&&(Obj.value)!="") IsBulkEdit=Obj.value;
	var Tobj=document.getElementById("TWKFL");
	var TIobj=document.getElementById("TWKFLI");
	var Obj=document.getElementById("PinVerified");
	if(Obj) PinVerified=Obj.value;
	var Obj=document.getElementById("hidRegNoz"+row);
	if ((Obj)&&(Obj.value)!="") hidRegNo=Obj.value;
	var Obj=document.getElementById("HidRollHospz"+row);
	if ((Obj)&&(Obj.value)!="") RollHosp=Obj.value;
	if (Tobj) TWKFL=Tobj.value;
	if (TIobj) TWKFLI=TIobj.value;
	context=session['CONTEXT'];
	path ="rtbulkmicrofilmframes.csp?OEMFRollRowId="+RollNo+"&POSRowId="+PosRowID+"&PatientID="+PatientID+"&MRType="+MRType+"&RTMASMRNo="+RTMASMRNo+"&DOB="+DOB+"&SURName="+SURName+"&GIVName="+GIVName+"&OEMFRollID="+RollNo+"&POSRTMASDR="+POSRTMASDR+"&hidPosDupSURName="+SURName+"&hidPosDupGIVName="+GIVName+"&hidPosDupMRN="+RTMASMRNo+"&IsBulkEdit="+IsBulkEdit+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+context+"&RegNo="+hidRegNo+"&PinVerified="+PinVerified+"&HospitalDR="+RollHosp;
	//alert("Path: "+path);
	window.location=path;

}