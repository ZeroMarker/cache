// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ANA LOG 33235

//if (parent.frames["MicroFilmBulkList"])	document.forms['fRTMaster_MicroFilmBulkEdit'].target="MicroFilmBulkList";

function zSelectRowHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	//var	row=arry[arry.length-1];
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	var urlObj=document.getElementById("HiddenURLz"+row);
	//if (urlObj) alert("url "+urlObj.href);
	window.location=urlObj.href
}

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
	var RollRowID,PosRowID,PatientID,MRType,RTMASMRNo,DOB,SURName,GIVName,RollNo,POSRTMASDR,IsBulkEdit,path,TWKFL,TWKFLI,context,PinVerified="";
	
	var Obj=document.getElementById("OEMFRowIdz"+row);
	if ((Obj)&&(Obj.value)!="") RollRowID=Obj.value;
	var Obj=document.getElementById("POSRowIdz"+row);
	if ((Obj)&&(Obj.value)!="") PosRowID=Obj.value;
	var Obj=document.getElementById("PatientID");
	if ((Obj)&&(Obj.value)!="") PatientID=Obj.value;
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
	var Tobj=document.getElementById("TWKFL");
	if (Tobj) TWKFL=Tobj.value;
	var TIobj=document.getElementById("TWKFLI");
	if (TIobj) TWKFLI=TIobj.value;
	var Obj=document.getElementById("PinVerified");
	if(Obj) PinVerified=Obj.value;
	context=session['CONTEXT'];
	IsBulkEdit="N";
	path ="rtmaster.microfilmdetails.csp?OEMFRollRowId="+RollNo+"&POSRowId="+PosRowID+"&PatientID="+PatientID+"&MRType="+MRType+"&RTMASMRNo="+RTMASMRNo+"&DOB="+DOB+"&SURName="+SURName+"&GIVName="+GIVName+"&OEMFRollID="+RollNo+"&POSRTMASDR="+POSRTMASDR+"&hidPosDupSURName="+SURName+"&hidPosDupGIVName="+GIVName+"&hidPosDupMRN="+RTMASMRNo+"&IsBulkEdit="+IsBulkEdit+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+context+"&PinVerified="+PinVerified;
	//alert("Path: "+path);
	window.location=path;
	
}

