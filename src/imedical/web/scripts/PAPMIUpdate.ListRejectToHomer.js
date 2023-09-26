//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var tbl=document.getElementById("tPAPMIUpdate_ListRejectToHomer");
var f=document.getElementById("fPAPMIUpdate_ListRejectToHomer");

function BodyLoadHandler() {
  var obj=document.getElementById('BatchResubmit');
  if (obj) obj.onclick=BatchResubmitHandler;
}

function selectAll(e) {
	if ((f)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById('Selectz'+i);
			if (obj) {
				obj.checked=true;
			}
		}
	}
	return false;
}

function BatchResubmitHandler() {
	var objIDs=document.getElementById("SelectedIDs");
	if ((f)&&(tbl)) {
		var aryID=new Array(); var aryStat=new Array(); var n=0;
		for (var i=1;i<tbl.rows.length;i++) {
			if ((f.elements["Selectz"+i])&&(f.elements["Selectz"+i].checked)) {
				aryID[n]=f.elements['IDz'+i].value;
				n++;
			}
		}
		// return aryID.join("^");
		var saveID=aryID.join("^");
	}
	if (saveID!="") {
		var objIDs=document.getElementById("SelectedIDs");
		objIDs.value=saveID+"^";
	}

	if ((objIDs)&&(objIDs.value!="")) return BatchResubmit_click();
}

function ClickHandler(e) {
	var eSrc = websys_getSrcElement(e);
	if (eSrc.id=="SelectAll") {
		selectAll(e);
		return false;
	}
	return true;
}

document.onclick = ClickHandler;
document.body.onload=BodyLoadHandler;
