function DocumentLoadHandler(e) {
	var objTable=document.getElementById("tMRPsychDetails_List");
	var objPsych=document.getElementById("ID");
	var eSrc;
	var newlink=document.getElementById("New1");
	if (newlink) newlink.onclick=NewClickHander;

	var update=document.getElementById("update1");
	if (update) update.onclick=UpdateClickHander;
	
	document.getElementById("tMRPsychDetails_List").onclick=MRPsychDetailsClickHandler;


	if (objTable)
	{
		var numRows=objTable.rows.length;
		var currentRow;
		var currentIdObj,currentLink;

		for (i=1;i<numRows;i++)
		{
			currentRow=objTable.rows[i];
			currentIdObj=document.getElementById("RowIDz"+i);
			currentLink=document.getElementById("editz"+i);
			if (currentIdObj&&objPsych&&(currentIdObj.value==objPsych.value))
			{
				//alert(currentIdObj.value);
				currentLink.click();
			}
		}

	} //Row Highlight
    
    // ab 10.02.05 - 49022 - disable new and edit links if showing from patient details
    if (!parent.frames["MRPsychDetailsEdit"]) {
        DisableAllFields(0,",update1,");
    }
}


function MRPsychDetailsClickHandler(e) {
	var EpiID="",PatID="",TWKFLI="",TWKFL="",mradm="";
	var EpiID=document.getElementById("EpisodeID")
	if (EpiID) EpiID=EpiID.value;
	var PatID=document.getElementById("PatientID")
	if (PatID) PatID=PatID.value;
	var mradm=document.getElementById("mradm")
	if (mradm) mradm=mradm.value;
	var TWKFL=document.getElementById("TWKFL")
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI")
	if (TWKFLI) TWKFLI=TWKFLI.value;

	var lastRow;
	
	var eSrc = websys_getSrcElement(e);
	if (parent.frames["MRPsychDetailsEdit"]) {
		if (eSrc.tagName=="IMG") {
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
			
			if (eSrc.id.indexOf("editz")==0) {
				eSrc.target = "MRPsychDetailsEdit";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=MRPsychDetails.Edit&" + currentlink[1];

				eSrc=websys_getParentElement(eSrc);
					//if (selectedRowObj!=eSrc) SelectRow();
			}
			
			if (eSrc.id.indexOf("DateFromz")==0) {
				eSrc.target = "MRPsychDetailsEdit";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=MRPsychDetails.Edit&" + currentlink[1];

				eSrc=websys_getParentElement(eSrc);
					//if (selectedRowObj!=eSrc) SelectRow();
			}
		}
	}
}

function NewClickHander() {
	var eSrc = websys_getSrcElement(e);
	
	//var currentlink=eSrc.href.split("?"); 
	if ((parent)&&(parent.frames)&&(parent.frames["MRPsychDetailsEdit"])) {
	
	var EpiID="",PatID="",TWKFLI="",TWKFL="",mradm="";
	var EpiID=document.getElementById("EpisodeID")
	if (EpiID) EpiID=EpiID.value;
	var PatID=document.getElementById("PatientID")
	if (PatID) PatID=PatID.value;
	var mradm=document.getElementById("mradm")
	if (mradm) mradm=mradm.value;
	var CONTEXT=document.getElementById("CONTEXT")
	if (CONTEXT) CONTEXT=CONTEXT.value;
	// ab 2.07.04 - need to send through workflow aswell
	var TWKFL=document.getElementById("TWKFL")
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI")
	if (TWKFLI) TWKFLI=TWKFLI.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=MRPsychDetails.Edit&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+mradm+"&mradm="+mradm+"&CONTEXT="+CONTEXT;
	websys_createWindow(lnk,"MRPsychDetailsEdit",""); 

	return false;
	}
}


function UpdateClickHander() {
	if (window.name=="MRPsychDetailsList") {
		var frm = document.forms["fMRPsychDetails_List"];
		if (frm.elements['TWKFL'].value!="") frm.elements['TFRAME'].value=window.parent.name
		
	}
	
	return update1_click();
}

document.body.onload = DocumentLoadHandler;

