// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 07.04.05 - 46451

function DocumentLoadHandler() {
    var obj=document.getElementById("TRISYMDesc");
    if (obj) obj.onblur=TRISYMDescBlurHandler;
    
    var obj=document.getElementById('find1');
	if (obj) obj.onclick= FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
    
    var obj=document.getElementById('update1');
	if (obj) obj.onclick= UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;    
    
    ColourRows();
}

function FindClickHandler(e) {
    TRISYMDescBlurHandler();
    var eSrc = websys_getSrcElement(e);
    var obj=document.getElementById("SympID");
    if ((eSrc)&&(obj)&&(eSrc.href)) {
        eSrc.href=eSrc.href+"&SympID="+obj.value;
    }
    return find1_click();
}

function UpdateClickHandler(e) {
	//alert("msd");
	var eSrc = websys_getSrcElement(e);
     var obj=document.getElementById("CatID");
     var objStr=document.getElementById("SympProID");
     if ((obj)&&(objStr)) {
     var unstr
     if  (objStr.value!="") { unstr=objStr.value+"@"+obj.value }
     else {unstr=obj.value; }
     objStr.value=unstr
     //alert(unstr);
     }
     if ((eSrc)&&(objStr)&&(eSrc.href)) {
        eSrc.href=eSrc.href+"&SympProID="+objStr.value;
	//alert(eSrc.href);
    }
    return update1_click();
}

function TRISYMDescLookup(str) {
    var lu = str.split("^");
    var obj=document.getElementById("SympID");
    if (obj) obj.value=lu[1];
}

function TRISYMDescBlurHandler() {
    var obj=document.getElementById("TRISYMDesc");
    var objcode=document.getElementById("SympID");
    if ((obj)&&(objcode)&&(obj.value=="")) objcode.value="";
}


// set the rows of the list to the triage category colours
function ColourRows() {
    var objTable=document.getElementById("tPACTriageSymptoms_List");
    if (objTable) {
		var numRows=objTable.rows.length;
		var currentRow,currentColour;
    
		for (var i=1;i<numRows;i++)
		{
			currentRow=objTable.rows[i];
			currentColour=document.getElementById("TriageColourz"+i);
            if (currentColour) currentColour=currentColour.value;
            if ((currentRow)&&(currentColour!="")) currentRow.style.backgroundColor=currentColour;
            
            currentRow.onclick=RowClickHandler;
		}    
    }
}

// set triage category of selected row to set on episode
function RowClickHandler(e) {
    var eSrc = websys_getSrcElement(e);
    var obj=document.getElementById("CatID");
    var objdesc=document.getElementById("CatDesc");
    if ((objdesc)&&(obj)&&(eSrc)) {
        if (eSrc.tagName=="LABEL") eSrc=websys_getParentElement(eSrc);
        if (eSrc.tagName=="TD") eSrc=websys_getParentElement(eSrc);
        //alert("msd");
        
        if (eSrc.className!="clsRowSelected") {
	    var obj2=document.getElementById("PROBRowIDz"+eSrc.rowIndex);
	   //alert(obj2.value);
            if (obj2) obj.value=obj2.value;
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

document.body.onload=DocumentLoadHandler;