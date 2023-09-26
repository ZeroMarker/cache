// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//md script redeveloped as per spec 46433

var frm = document.forms["fPAExemptionItems_List"];
function DocumentLoadHandler(e) {
	var objTable=document.getElementById("tPAExemptionItems_List");
	var objEx=document.getElementById("ID");
	var eSrc;
	var newlink=document.getElementById("New1");
	if (newlink) newlink.onclick=NewClickHander;

	var update=document.getElementById("update1");
	if (update) update.onclick=updateClickHandler;
	
	document.getElementById("tPAExemptionItems_List").onclick=DetailsClickHandler;


	if (objTable)
	{
		var numRows=objTable.rows.length;
		var currentRow;
		var currentIdObj,currentLink;

		for (i=1;i<numRows;i++)
		{
			currentRow=objTable.rows[i];
			currentIdObj=document.getElementById("ITM_RowIdz"+i);
			//currentLink=document.getElementById("editz"+i);
			if (currentIdObj&&objEx&&(currentIdObj.value==objEx.value))
			{
				//alert(currentIdObj.value);
				currentLink.click();
			}
		}

	} //Row Highlight
    
   
}


function DetailsClickHandler(e) {
	var EpiID="",PatID="",TWKFLI="",TWKFL="",mradm="";
	var PatID=document.getElementById("PatientID")
	if (PatID) PatID=PatID.value;
	var TWKFL=document.getElementById("TWKFL")
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI")
	if (TWKFLI) TWKFLI=TWKFLI.value;

	var lastRow;
	
	var eSrc = websys_getSrcElement(e);
	if (parent.frames["paexitem_edit"]) {
		if (eSrc.tagName=="IMG") {
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
			
			if (eSrc.id.indexOf("editz")==0) {
				eSrc.target = "paexitem_edit";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PAExemptionItems.Edit&" + currentlink[1];

				eSrc=websys_getParentElement(eSrc);
					//if (selectedRowObj!=eSrc) SelectRow();
			}
			
			if (eSrc.id.indexOf("ARCIMDescz")==0) {
				eSrc.target = "paexitem_edit";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PAExemptionItems.Edit&" + currentlink[1];

				eSrc=websys_getParentElement(eSrc);
					//if (selectedRowObj!=eSrc) SelectRow();
			}
		}
	}
}

function updateClickHandler() {
	if (window.name=="paexitem_list") {
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name;
		}
	return update1_click();
	
}

function NewClickHander() {
  //var eSrc =document.getElementById("New1");
   //alert("eSrc :"+eSrc.href)
	if ((parent)&&(parent.frames)&&(parent.frames["paexitem_edit"])) {
	
	var EpiID="",PatID="",PARREF="",TWKFL="",TWKFLI="",admtype="";
	var PatID=document.getElementById("PatientID")
	if (PatID) PatID=PatID.value;
	var exiid=document.getElementById("EXIId");
 	if (exiid) exiid=exiid.value;
	var parref=document.getElementById("PARREF");
	if (parref) parref=parref.value;
 	var TWKFL=document.getElementById("TWKFL")
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI")
	if (TWKFLI) TWKFLI=TWKFLI.value;
	var CONTEXT=document.getElementById("CONTEXT")
	if (CONTEXT) CONTEXT=CONTEXT.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAExemptionItems.Edit&" +"&PatientID="+PatID+"&EXIId="+exiid+"&PARREF="+parref+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&CONTEXT="+CONTEXT
	websys_createWindow(lnk,"paexitem_edit",""); 
	return false;
	}
}

document.body.onload = DocumentLoadHandler;

