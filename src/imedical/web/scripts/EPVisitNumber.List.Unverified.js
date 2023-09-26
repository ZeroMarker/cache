// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

/*Procedure for allowing multiple profiles on the same page is to dynamically change the id of a
  profiles form, table menu and table list to be unique.  The unique id is obtained from
  adding the document.forms.length property on to the end of their existing names.*/
/*var df=document.forms;
var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
if (ltbl) {ltbl.id=ltbl.id+df.length,ltbl.Name=ltbl.id;}
df[df.length-1].id=df[df.length-1].id+df.length;df[df.length-1].name=df[df.length-1].name+df.length;

var frm=document.getElementById("f"+ltbl.id.substring(1,ltbl.id.length));
var eSrc=websys_getSrcElement();
var tbl=getTableName(eSrc);
var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));*/

var tbl=document.getElementById("tEPVisitNumber_List_Unverified");
var f=document.getElementById("fEPVisitNumber_List_Unverified");


function ChangeLocation(lnk,newwin) {
	var found=0;
	var tbl;
	var eSrc=websys_getSrcElement();
	if(eSrc) tbl=getTableName(eSrc);

	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		var allids = "";
		for (i in aryfound) {
			var row=aryfound[i];
			// check for specific values - these values must be hidden in the component
			if (!f.elements["OERowIDsz"+row]) continue;
			if (f.elements["OERowIDsz"+row].value!="") {
				if (allids!="") {allids += "^";}
				allids += f.elements["OERowIDsz"+row].value;
			}
		}
		lnk+= "&AllOrderIDs=" + escape(allids);
		websys_lu(lnk,0,newwin);

	}
}


