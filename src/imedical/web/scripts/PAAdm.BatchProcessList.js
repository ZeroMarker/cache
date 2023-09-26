// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var f=document.forms["fPAAdm_BatchProcessList"];
var tbl=document.getElementById("tPAAdm.BatchProcessList");

document.body.onload=BodyLoadHandler;


function BodyLoadHandler(){
	
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAllClickHandler;
	//var obj=document.getElementById('update1')
	//if (obj) obj.onclick=UpdateAll;
}


function EpisodeIDGetSelected() {
	var arrEpisodeIDs=new Array();
	var arrRegos=new Array();  
	var eSrc=websys_getSrcElement();
	var tbl=getTable(eSrc);
	var frm=getFrmFromTbl(tbl);
	var selected=0;
	var el = document.getElementById("admstring");
	var rl = document.getElementById("regostring");	

	for (var row=1; row<tbl.rows.length; row++) {
		var cbx=frm.elements["Selectz"+row];
		//if (cbx) alert("row number="+row+" cbx.checked= "+cbx.checked+" cbx.disabled="+cbx.disabled);
		if ((cbx.checked) && (!cbx.disabled)) {
			arrEpisodeIDs[selected]=frm.elements["EpisodeIDz"+row].value;
			arrRegos[selected]=document.getElementById("RegHidenz"+row).value;
			selected++;
			if (el) el.value = arrEpisodeIDs.join(",");
			if (rl) rl.value = arrRegos.join(",");
			//alert(el.value)
		}
	}
	return arrEpisodeIDs;
}

// checks all the 'select' checkboxes in the list
function SelectAllClickHandler(e) {
	var objSA=document.getElementById("SelectAll");
	if (objSA) {
		for (var j=0;j<tbl.rows.length;j++) {
			var obj=document.getElementById("Selectz"+j);
			if (obj) {
				//if (objSA.checked==true) obj.click();
				//else obj.click();
				if ((objSA.checked==true)&&(obj.checked==false)&&(obj.disabled==false)) { obj.click(); }
				if ((objSA.checked==false)&&(obj.checked==true)&&(obj.disabled==false)) { obj.click(); }
				

			}	
		}
	}
}

function UpdateAll() {
	//alert("update clicked")
	//EpisodeIDGetSelected();
	//var el = document.getElementById("admstring");
	//alert(el.value);
	//var rl = document.getElementById("regostring");	
	//alert(rl.value);
	//return false;
	return update1_click();
}
