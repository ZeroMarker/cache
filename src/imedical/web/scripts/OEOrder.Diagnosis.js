var tbl;

function BodyLoadHandler(){
	var update=document.getElementById("update");
	if(update) update.onclick=UpdateClickHandler;
	
	var diag=document.getElementById("MRDiaIDs");
	if(diag) diag=diag.value;
	tbl=document.getElementById("tMRDiagnos_ListEMR2");
	if(tbl && diag && diag!="") {
		for (var i=1;i<tbl.rows.length;i++) {
			var sel=document.getElementById("SelectItemz"+i);
			var id=document.getElementById("MRDIA_RowIdz"+i);
			if(sel && id && diag.indexOf(id.value)>=0) sel.checked=true;
		}
	}
}

//log60323 TedT
function UpdateClickHandler() {
	var diaIDs="";
	
	if(tbl) {
		for (var i=1;i<tbl.rows.length;i++) {
			var sel=document.getElementById("SelectItemz"+i);
			if(sel && sel.checked) {
				var id=document.getElementById("MRDIA_RowIdz"+i);
				if(id) diaIDs=diaIDs+id.value+"^";
			}
		}
	}
	
	if(diaIDs=="") {
		alert(t['NO_SELECT']);
		return false;
	}
	
	var MR=document.getElementById("MRDiaIDs");
	if(MR) MR.value=diaIDs;
	
	update_click();
}

document.body.onload = BodyLoadHandler;