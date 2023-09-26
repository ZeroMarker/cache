function DocumentLoadHandler(e) {
	var objTable=document.getElementById("tPAAdm2MaternityComplic_List");
	var objMatComp=document.getElementById("ID");
	var eSrc;
	//alert(objMatComp.value);
	var newlink=document.getElementById("New1");
	if (newlink) newlink.onclick=NewClickHander;

	document.getElementById("tPAAdm2MaternityComplic_List").onclick=PAAdm2MaternityComplicClickHandler;

	if (objTable)
	{
		var numRows=objTable.rows.length;
		var currentRow;
		var currentIdObj,currentLink;

		for (i=1;i<numRows;i++)
		{
			currentRow=objTable.rows[i];
			currentIdObj=document.getElementById("RowIDz"+i);
			currentLink=document.getElementById("MaternityComplicationz"+i);
			if (currentIdObj&&objMatComp&&(currentIdObj.value==objMatComp.value))
			{
				//alert(currentIdObj.value);
				currentLink.click();
			}
		}

	} //Row Highlight
}


function PAAdm2MaternityComplicClickHandler(e) {
	var EpiID="",PatID="",TWKFLI="",TWKFL="";
	var EpiID=document.getElementById("EpisodeID")
	if (EpiID) EpiID=EpiID.value;
	var PatID=document.getElementById("PatientID")
	if (PatID) PatID=PatID.value;
	var TWKFL=document.getElementById("TWKFL")
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI")
	if (TWKFLI) TWKFLI=TWKFLI.value;

	var lastRow;
	
	var eSrc = websys_getSrcElement(e);
	if (parent.frames["lower"]) {
		if (eSrc.tagName=="IMG") {
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
			
			if (eSrc.id.indexOf("MaternityComplicationz")==0) {
				//alert("date")
				eSrc.target = "lower";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PAAdm2MaternityComplic.Edit&" + currentlink[1];

				eSrc=websys_getParentElement(eSrc);
					//if (selectedRowObj!=eSrc) SelectRow();
			}
			//
			if (eSrc.id.indexOf("delete1z")==0) {
				eSrc.target="_parent"
				if  (TWKFLI.value=="") { 
					var currentlink=eSrc.href.split("?"); 
					var lnk="paadm2maternitycomplicationframe.csp?EpisodeID="+EpiID+"&PatientID="+PatID;
					alert("if: "+lnk)
				} else { 
					//alert(eSrc.href);
					var currentlink=eSrc.href.split("&ID=");
					lnk=eSrc.href
					//lnk=currentlink[0]+"&ID="+currentlink[1]+"&EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+EpiID;
					//alert("else: "+lnk)
				}
				//alert(lnk)
				eSrc.href=lnk
			}
		}
	}
}

function NewClickHander() {
	var eSrc = websys_getSrcElement(e);
	var currentlink=eSrc.href.split("?"); 
	if ((parent)&&(parent.frames)&&(parent.frames["lower"])) {
	
	var EpiID="",PatID="",TWKFLI="",TWKFL="";
	var EpiID=document.getElementById("EpisodeID")
	if (EpiID) EpiID=EpiID.value;
	var PatID=document.getElementById("PatientID")
	if (PatID) PatID=PatID.value;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=PAAdm2MaternityComplic.Edit&" +"EpisodeID="+EpiID+"&PatientID="+PatID+"&PARREF="+EpiID
	websys_createWindow(lnk,"lower",""); 

	return false;
	}
}

function clearFormHandler() {
	var obj=document.getElementById("trafficID")
	obj.value=""
	var obj=document.getElementById("ID")
	obj.value=""
	var el=document.forms["fPATrafficAccident_Edit"].elements;
	//var el=frm.elements
		for (var i=0;i<el.length;i++) {
		if ((el[i].type!="hidden")&&(!el[i].disabled)) {
			el[i].value=""					
		}	
	}	
	
	return false
}

document.body.onload = DocumentLoadHandler;

