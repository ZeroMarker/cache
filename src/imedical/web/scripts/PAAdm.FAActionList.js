// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

//md script redeveloped as per spec 46433

var frm = document.forms["fPAAdm_FAActionList"];
function DocumentLoadHandler(e) {
	var objTable=document.getElementById("tPAAdm_FAActionList");
	var objEx=document.getElementById("ID");
	var eSrc;
	
	document.getElementById("tPAAdm_FAActionList").onclick=DetailsClickHandler;


	if (objTable)
	{
		var numRows=objTable.rows.length;
		var currentRow;
		var currentIdObj,currentLink;

		for (i=1;i<numRows;i++)
		{
			currentRow=objTable.rows[i];
			currentIdObj=document.getElementById("Actionsz"+i);
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
	
	var TWKFL=document.getElementById("TWKFL")
	if (TWKFL) TWKFL=TWKFL.value;
	var TWKFLI=document.getElementById("TWKFLI")
	if (TWKFLI) TWKFLI=TWKFLI.value;

	var lastRow;
	
	var eSrc = websys_getSrcElement(e);
	if (parent.frames["paadmfaex_edit"]) {
		if (eSrc.tagName=="IMG") {
			eSrc=websys_getParentElement(eSrc)
		}
		if (eSrc.tagName=="A") {
			
			if (eSrc.id.indexOf("Actionsz")==0) {
				eSrc.target = "paadmfaex_edit";
				var currentlink=eSrc.href.split("?");
				eSrc.href = "websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.FAActionEdit&" + currentlink[1];

				eSrc=websys_getParentElement(eSrc);
					//if (selectedRowObj!=eSrc) SelectRow();
			}
			
			
		}
	}
}



document.body.onload = DocumentLoadHandler;

