// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 07.04.05 - 46451
var mintrcat=100;
var minttcatdesc="";
function LogDocumentLoadHandler() {
    
    
    var obj=document.getElementById('update3');
	if (obj) obj.onclick= Update3ClickHandler;
	if (tsc['update3']) websys_sckeys[tsc['update3']]=Update3ClickHandler;    
    
	ColourRowsL();
	//SetRowsL();
}


function Update3ClickHandler() {
    if (window.opener) {
	var obj=window.opener.document.getElementById("SympProID");
        var objdesc=document.getElementById("SympProID");
	var obj2=window.opener.document.getElementById("CTACUDesc");
        var objdesc2=document.getElementById("CatDesc");
	var tslink=window.opener.document.getElementById("TriageSymptoms");
	if ((objdesc)&&(obj)) {
	obj.value=objdesc.value;
	if ((obj.value=="")&&(tslink)) tslink.style.fontWeight="";
	if ((obj.value!="")&&(tslink)) tslink.style.fontWeight="bold";
	}
	if ((objdesc2)&&(obj2)){
	if (objdesc2.value!="") { obj2.value=objdesc2.value; }
	else if (minttcatdesc!="") { 
	obj2.value=minttcatdesc;
	//objdesc2.value=minttcatdesc;
	}
	}
	window.opener.document.forms['fPAAdm_EditEmergency'].elements['TDIRTY'].value=2;
	
    }
    return update3_click();
}



// set the rows of the list to the triage category colours
function ColourRowsL() {
	//alert("function called");
    var objTable=document.getElementById("tPACTriageSymptomsLog_List");
    if (objTable) {
		var numRows=objTable.rows.length;
		var currentRow,currentColour,currecttricatcode,currentttricatdesc;
    
		for (var i=1;i<numRows;i++)
		{
			currentRow=objTable.rows[i];
			currentColour=document.getElementById("TriageColour2z"+i);
			currentttricatcode=document.getElementById("CTACUCode2z"+i);
			currentttricatdesc=document.getElementById("CTACUDesc2z"+i);
			if ((currentttricatcode)&&(currentttricatdesc)) {
				currentttricatcode=currentttricatcode.value;
				if (currentttricatcode<mintrcat)
				{
				mintrcat=currentttricatcode;
				minttcatdesc=currentttricatdesc.value;
				}
				
			}
		if (currentColour) {
		currentColour=currentColour.value;
		//alert(currentColour);
		}
		if ((currentRow)&&(currentColour!="")) currentRow.style.backgroundColor=currentColour;
            
		currentRow.onclick=RowClickHandlerL;
		}    
    }
    //alert(minnrtcat);
    //alert(minttcatdesc);
}

function RowClickHandlerL(e) {
    var eSrc = websys_getSrcElement(e);
     var objdesc=document.getElementById("CatDesc");
    if ((objdesc)&&(eSrc)) {
        if (eSrc.tagName=="LABEL") eSrc=websys_getParentElement(eSrc);
        if (eSrc.tagName=="TD") eSrc=websys_getParentElement(eSrc);
        //alert("msd");
        
        if (eSrc.className!="clsRowSelected") {
	    var obj2=document.getElementById("CTACUDesc2z"+eSrc.rowIndex);
            if (obj2) objdesc.value=obj2.value;
        } else {
	    obj.value="";
            objdesc.value="";
        }
    }
    //alert(objdesc.value);
    return;
}
document.body.onload=LogDocumentLoadHandler;