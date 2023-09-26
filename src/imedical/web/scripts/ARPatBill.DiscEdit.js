// Copyright (c) 2004 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//Log 63090 - 22.03.2007
var objUpdate = document.getElementById("update1");		

function BodyLoadHandler() {
	//dont want them to change the amt, as disc amt (ARPatientBill tbl) and allocation data (ARPatBillDiscAlloc tbl) 
	//can have a mismatch

	var objDiscAmt = document.getElementById("ARPBLDiscretAmt");
	if (objDiscAmt) objDiscAmt.disabled = true;
	
	if (objUpdate) objUpdate.onclick=refreshAndClose;	//Log 63090 - 22.03.2007
}

//Log 63090 - 22.03.2007
function refreshAndClose() {
	if (window.opener) {
		if ((window.opener.name!="eprmenu")&&(window.opener.name!="TRAK_menu")) {
			window.opener.treload('websys.csp');
			window.opener.close();
		}
		if (window.opener.parent) {
			if (window.opener.parent.name=="TRAK_main") {
				if (window.opener.parent.frames["BR.ARPatBillFindBatch"]) {
					var frm=window.opener.parent.frames["BR.ARPatBillFindBatch"];
					if (frm) {
						var winBatchFind = frm.window;
						winBatchFind.treload('websys.csp');
						winBatchFind.close();
					}	
				}	
			}	
		}		
	}
	else {
		if (window.top.opener) {
			window.top.opener.treload('websys.csp');
			window.top.opener.close();
		}
		
		if (window.top.opener.parent) {
			if (window.top.opener.parent.name=="TRAK_main") {
				if (window.top.opener.parent.frames["BR.ARPatBillFindBatch"]) {
					var frm=window.top.opener.parent.frames["BR.ARPatBillFindBatch"];
					if (frm) {
						var winBatchFind = frm.window;
						winBatchFind.treload('websys.csp');
						winBatchFind.close();
					}	
				}	
			}	
		}
	}	
	return update1_click();
}

document.body.onload = BodyLoadHandler;