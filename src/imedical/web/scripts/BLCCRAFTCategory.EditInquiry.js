//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

OldCRAFTCDescKeyDown="";
objCRAFTCDesc=document.getElementById("CRAFTCDesc");
objCRAFTCLowInlierBoundary=document.getElementById("CRAFTCLowInlierBoundary");
objCRAFTCHighInlierBoundary=document.getElementById("CRAFTCHighInlierBoundary");
objCRAFTCDHSAverageLOS=document.getElementById("CRAFTCDHSAverageLOS");
objCRAFTCSameDayWeight=document.getElementById("CRAFTCSameDayWeight");
objCRAFTCShortStayWeight=document.getElementById("CRAFTCShortStayWeight");
objCRAFTCLowOutlierPerDiem=document.getElementById("CRAFTCLowOutlierPerDiem");
objCRAFTCInlierWeight=document.getElementById("CRAFTCInlierWeight");
objCRAFTCHighOutlierPerDiem=document.getElementById("CRAFTCHighOutlierPerDiem");
//RQG 16.05.03 L35723
objVersionID=document.getElementById("CRAFTVersionID");

function BodyLoadHandler() {

	if (objCRAFTCDesc) {
		OldCRAFTCDescKeyDown=objCRAFTCDesc.onkeydown;
		objCRAFTCDesc.onkeydown=CRAFTCDescKeyDown;
	}

}

function CRAFTCDescKeyDown() {

	if (typeof OldCRAFTCDescKeyDown!="function") origcode=new Function(OldCRAFTCDescKeyDown); 
	if (OldCRAFTCDescKeyDown()==false) return false;

	if (objCRAFTCLowInlierBoundary) objCRAFTCLowInlierBoundary.value = "";
	if (objCRAFTCHighInlierBoundary) objCRAFTCHighInlierBoundary.value = "";
	if (objCRAFTCDHSAverageLOS) objCRAFTCDHSAverageLOS.value = "";
	if (objCRAFTCSameDayWeight) objCRAFTCSameDayWeight.value = "";
	if (objCRAFTCShortStayWeight) objCRAFTCShortStayWeight.value = "";
	if (objCRAFTCLowOutlierPerDiem) objCRAFTCLowOutlierPerDiem.value = "";
	if (objCRAFTCInlierWeight) objCRAFTCInlierWeight.value = "";
	if (objCRAFTCHighOutlierPerDiem) objCRAFTCHighOutlierPerDiem.value = "";

}

function CraftCategoryLookUpHandler(str) {
 	var lu = str.split("^");
	var obj;

	if ((lu[3]!="")&&(objCRAFTCLowInlierBoundary)) objCRAFTCLowInlierBoundary.value = lu[3];
	if ((lu[4]!="")&&(objCRAFTCHighInlierBoundary)) objCRAFTCHighInlierBoundary.value = lu[4];
	if ((lu[5]!="")&&(objCRAFTCDHSAverageLOS)) objCRAFTCDHSAverageLOS.value = lu[5];
	if ((lu[6]!="")&&(objCRAFTCSameDayWeight)) objCRAFTCSameDayWeight.value = lu[6];
	if ((lu[7]!="")&&(objCRAFTCShortStayWeight)) objCRAFTCShortStayWeight.value = lu[7];
	if ((lu[8]!="")&&(objCRAFTCLowOutlierPerDiem)) objCRAFTCLowOutlierPerDiem.value = lu[8];
	if ((lu[9]!="")&&(objCRAFTCInlierWeight)) objCRAFTCInlierWeight.value = lu[9];
	if ((lu[10]!="")&&(objCRAFTCHighOutlierPerDiem)) objCRAFTCHighOutlierPerDiem.value = lu[10];

}

function CraftVersionLookUpHandler(str) {
 	var lu = str.split("^");
	var obj;
	alert(lu[2]);
	if ((lu[2]!="")&&(objVersionID)) objVersionID.value = lu[2];


}

document.body.onload=BodyLoadHandler;
