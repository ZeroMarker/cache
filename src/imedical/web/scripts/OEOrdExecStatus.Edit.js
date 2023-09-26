// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function updateClick() {
	var old=document.getElementById("OldStat");
	var stat=document.getElementById("STCHAdminStatusDR");
	if ((old) && (stat)) {
		if (old.innerText==stat.value) {
			alert(t['SAME_STAT']);
			return false;
		}
	}
	return Update_click();
}

var upd=document.getElementById("Update");
if (upd) upd.onclick=updateClick;