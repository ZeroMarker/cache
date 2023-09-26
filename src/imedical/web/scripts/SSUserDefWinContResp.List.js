// Copyright (c) 2006 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 
// ab 10.05.06 52166


function BodyLoadHandler(e) {
	var tbl=document.getElementById("tSSUserDefWinContResp_List");
	if (tbl) {
		for (var i=1;i<tbl.rows.length;i++) {
			// if already generated, do not allow delete or code change
			var obj=document.getElementById("RESP_Generatedz"+i);
			if ((obj)&&(obj.value=="Y")) {
				var objcode=document.getElementById("RESP_Codez"+i);
				if (objcode) {
					objcode.disabled=true;
				}
				// ab 29.08.06 60717
				var objcode=document.getElementById("RESP_Scorez"+i);
				if (objcode) {
					objcode.disabled=true;
				}
				
				var objdel=document.getElementById("delete1z"+i);
				if (objdel) {
					objdel.disabled=true;
					objdel.onclick=LinkDisable;
					objdel.href="javascript:LinkListDisable();";
					if (objdel.firstChild) {
						objdel.firstChild.style.visibility="hidden";
					}
				}
			}
			
			// ab 5.07.06 59985 - actions NOT enabled for listboxes
			var obj=document.getElementById("ControlType");
			if ((obj)&&(obj.value=="Extended_ListBox")) {
				var objdel=document.getElementById("RespActionsz"+i);
				if (objdel) {
					objdel.disabled=true;
					objdel.onclick=LinkDisable;
					objdel.href="javascript:LinkListDisable();";
					if (objdel.firstChild) {
						objdel.firstChild.style.visibility="hidden";
					}
				}
				// ab 14.11.06 61557
				var objdel=document.getElementById("CPW_Descz"+i);
				if (objdel) {
					objdel.disabled=true;
					objdel.className="disabledField";
				}
				var objdel=document.getElementById("lt2194iCPW_Descz"+i);
				if (objdel) {
					objdel.style.visibility="hidden";
				}
			}
		}
	}
	
}

function LinkListDisable() {
	return;
}

document.body.onload = BodyLoadHandler;
