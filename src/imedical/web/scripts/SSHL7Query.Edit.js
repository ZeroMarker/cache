// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 21.04.05

function DocumentLoadHandler() {
    var obj=document.getElementById('remove1');
    if (obj) obj.onclick=RemoveClickHandler;
    PopulateList();
}

function BuildQueryString() {
    var lstItems=document.getElementById("QueryTypes");
    var obj=document.getElementById("QueryString");
    if ((lstItems)&&(obj)) {
        obj.value="";
        for(var i=0; i<lstItems.length; i++) {
            if (i>0) obj.value=obj.value+"*";
            obj.value=obj.value+lstItems[i].value;
        }
    }
}

function PopulateList() {
    var lstItems=document.getElementById("QueryTypes");
    var obj=document.getElementById("QueryString");
    var objdesc=document.getElementById("QueryStringDesc");
    if ((lstItems)&&(obj)) {
        var ary=obj.value.split("*");
        var arydesc=objdesc.value.split("*");
        for(var i=0; i<ary.length; i++) {
            if (arydesc[i]!="") lstItems[i]= new Option(arydesc[i],ary[i]);
        }
    }
}

function RemoveClickHandler() {
    var lstItems=document.getElementById("QueryTypes");
    if (lstItems) {
        var j=lstItems.selectedIndex;
        if (j!=-1) {
            // Remove selected item from Listbox.
            lstItems.remove(j);
        }
        BuildQueryString();
    }
	return false;
}

function HL7QUSearchTypesLookup(str) {
    var lstItems=document.getElementById("QueryTypes");
	var lu = str.split("^");
    
	if (lu[1]!="") {
		//Check selected Outbound Table not already in Listbox.
		for(i=0; i<lstItems.length; i++) {
			if (lstItems[i].value==lu[2]) {
				alert("'" + lu[0] + "' " + t['AlreadyExists']);
				// Clear LookUp.
				var obj=document.getElementById('HL7QUSearchTypes');
				if (obj) obj.value="";
				return false;
			}
		}

		// Add selected LookUp item into Listbox.
		var num=lstItems.length;
		lstItems[num]= new Option(lu[0],lu[2]);
		// Clear LookUp.
		var obj=document.getElementById('HL7QUSearchTypes');
		if (obj) obj.value="";
        
        BuildQueryString();
	}
}

document.body.onload=DocumentLoadHandler;