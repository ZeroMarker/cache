// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
function returnFalse(){
	return false;
}

function BodyLoadHandler()
{
	//log59284 TedT make the link disabled
	var obj=1;
	for (var i=1; obj; i++){
		obj=document.getElementById("NOTIncludedForDischSumz"+i);
		if(obj) {
			obj.disabled=true;
			obj.onclick=returnFalse
		}
	}
	
	//var obj=document.getElementById("ContextHolder");
	//if(obj)
	//{
	//	alert(obj.value);
	//}
}

//function BodyLoadHandler() {
	//RemoveUnwantedIcons();
//}
//BC 6-Feb-2002: Removed as no longer required
/*function RemoveUnwantedIcons() {
	var tbl=document.getElementById("tMRNursingNotes_List2");
	var f=document.getElementById("fMrNursingNotes_List2");
	if ((f)&&(tbl)) {
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById('IDz'+i);
			if (obj) {
				if (obj.value=="") {
					var obj=document.getElementById('Notesz'+i);
					if (obj) {
						obj.innerHTML="";
						var deletenode=obj.removeNode(false);
					}
				}
			}
		}
	}
	return false;
}*/

document.body.onload = BodyLoadHandler;