
function BodyOnloadHandler() {

}


function PassReceipts() {
	var tbl=document.getElementById("tARCloseShift_List");
	var f=document.getElementById("fARCloseShift_List");
	if ((f)&&(tbl)) {
		var aryID=new Array(); var aryStat=new Array(); var n=0;
		for (var i=0;i<tbl.rows.length;i++) {
			var obj=document.getElementById('Selectz'+i);
			if (obj) {
				if (obj.checked==true) {
					aryID[n]=document.getElementById('ReceiptNoz'+i);
					n++;
				}
			}
		}
		return aryID.join("^");
	}
	return "";

}


//document.body.onload=BodyOnloadHandler;