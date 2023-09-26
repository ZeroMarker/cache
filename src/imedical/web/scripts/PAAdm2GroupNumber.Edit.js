// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

// Log 60222 Bo 09-08-2006: Taken from file PAPerson.Edit.js, function ViewFamilyDrLookUp
	
// Referral Doctor
//(DocTitle,DocDesc,DocMname,DocFname,refdId,DocCode,DocSpec,ClinCode,clinId,ClinProvNo,ClinAddr,ClinSuburb,tele,clindatefrom,clindateto,expired,type,ClinDesc,ClinCity,ClinZip,DoctorProvNo,DocZip,DocHCA)
// 0       ,1      ,2       ,3       ,4     ,5 	    ,6      ,7       ,8     ,9         ,10      ,11        ,12  ,13          ,14        ,15     ,16  ,17      ,18      ,19,	     20,	     ,21   ,22		
function ViewFamilyDrLookUp(str) {
	//alert(str);
	var lu = str.split("^");
	var obj;
	var obj1=document.getElementById("REFDDesc");
	if (obj1) obj1.value = lu[1];
	obj=document.getElementById("REFDForename");
	if (obj) obj.value = lu[3];
}

function DocumentLoadHandler(e) {
	var obj;


	// Edit component logic
	obj=document.getElementById('GRPDateFrom');
	if (obj) obj.onchange=DateFromChangeHandler;

	obj=document.getElementById('GRPDateTo');
	if (obj) obj.onchange=DateToChangeHandler;


	// List component logic
	var objTable=document.getElementById("tPAAdm2GroupNumber_List");
	if (objTable)
	{
		var numRows=objTable.rows.length;
		var currentRow;
		var currentIdObj,currentLink;
		for (i=1;i<numRows;i++)
		{
			currentRow=objTable.rows[i];
			currentIdObj=document.getElementById("GRPRowIDz"+i);
			currentLink=document.getElementById("edit1z"+i);
			if (currentLink) currentLink.onclick=editClickHandler;
		}
	}


}

function DateToChangeHandler(e) {
		GRPDateTo_changehandler(e) 
		var from=document.getElementById('GRPDateFrom')
		var to=document.getElementById('GRPDateTo')
		var fromdt=DateStringToArray(from.value)
		var todt=DateStringToArray(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
			alert("\'" + t['GRPDateTo'] + "\' " + t['XINVALID'] + "\n");
			to.value=""
			}
		}
	
}


function DateFromChangeHandler(e) {
		GRPDateFrom_changehandler(e)
		var to=document.getElementById('GRPDateTo')
		var from=document.getElementById('GRPDateFrom')
		var fromdt=DateStringToArray(from.value)
		var todt=DateStringToArray(to.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if ((to)&&(from)) {
			if (dtto< dtfrom) {
			alert("\'" + t['GRPDateFrom'] + "\' " + t['XINVALID'] + "\n");
			from.value=""
			}
		}
	
}

function editClickHandler (evt) {
	var eSrc=websys_getSrcElement(evt);
	eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	currentLink=document.getElementById("edit1z"+row);
	var rowObj=document.getElementById("GRPRowIDz"+row);
	var idObj=document.getElementById("GRPID");
	if ((rowObj)&&(idObj)&&(rowObj.value)!="") idObj.value=rowObj.value;
}

function closeClickHandler() {
	self.close();
	return false;
}

var closeObj=document.getElementById("Close1");
if (closeObj) closeObj.onclick=closeClickHandler;
document.body.onload = DocumentLoadHandler;