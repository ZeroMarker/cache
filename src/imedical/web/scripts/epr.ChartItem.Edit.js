// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

/*function updateHandler() {
	if (window.opener) window.opener.location.reload();
	//if (window.opener) window.history.go();
    return update1_click();
}
*/

var f=document.forms['fepr_ChartItem_Edit'];

function BodyLoadHandler() {
	var graphlist = f.elements['Graphs'];
	ClearAllList(graphlist)
   	if (self==top) websys_reSizeT();
	var GraphString=document.getElementById('GraphString');
	if (GraphString) {
		var Arrstrings=GraphString.value.split("^")
		callAddItemToList(graphlist,Arrstrings[0],Arrstrings[1]);
		var AdHocGraphLink=document.getElementById('AdHocGraphLink');
		if (AdHocGraphLink) {
			AdHocGraphLink.checked=(Arrstrings[3]==1)
		}
	}
	var obj = document.getElementById('update1');
	if (obj) {
		obj.onclick=UpdateClickHandler;
	}
	var obj = document.getElementById('DelSelected');
	if (obj) {
		obj.onclick=DelSelectedClickHandler;
	}
}

function LookUpGraph(val) {
	f.GraphDR.value="";
	var ovals=val.split("^");

	//ovals[1]=loopArrayForMatches(allquestxt,allquesval,ovals[0].split("^"));
	TransferToList(f.Graphs,val);
}

function DelSelectedClickHandler(e) {
	ClearSelectedList(f.Graphs);
	return false;
}


function UpdateClickHandler(e) {
	var obj=document.getElementById("update1");
	if ((obj)&&(obj.disabled)) {
		return false
	}
	// put the selected graphs in a holder for updating
	var objGraphs = f.Graphs;
	var ary=returnValues(objGraphs);
	f.GraphString.value=ary.join(",");
	return update1_click()
}

document.body.onload = BodyLoadHandler;