// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.




function UpdateClickHandler () {

	var batchstr="";
	var batchid="";
	var Seltbl = document.getElementById("tPharmacy_SelectBatch");
	var SelForm= document.getElementById("fPharmacy_SelectBatch");
	if (Seltbl && SelForm) {
		for (var curr_row=1; curr_row<Seltbl.rows.length; curr_row++) {
			var BatchID=SelForm.elements["BatchIDz" + curr_row].value;
			var HIDDENBatchName=SelForm.elements["HIDDENBatchNamez" + curr_row].value;
			var HIDDENAvail=SelForm.elements["HIDAvailz" + curr_row].value;
			var Taken=SelForm.elements["Takenz" + curr_row].value;
			// only add batches with SOME item taken
			if (Taken =="") continue;
			if (parseFloat(Taken) <= 0) continue;

			if (parseFloat(Taken) > parseFloat(HIDDENAvail)) {
				alert(t['INSUFFQUAN']);
				return false;
			}
			if (batchid.length>0) { batchid += "&" };
			batchid += BatchID + ',' + Taken;
			if (batchstr.length>0) { batchstr += ", " };
			batchstr += HIDDENBatchName;
		}
		//batchid = escape(batchid );

		var par_win=window.opener;
		try {
			var objBatch=par_win.document.getElementById("OEOREStockBatches");
			if (objBatch) {
				objBatch.value = batchstr;
			}
			var objBatch=par_win.document.getElementById("HidStockBatches");
			if (objBatch) {
				objBatch.value = batchid;
			}
		} catch (err) {
			//
		}
		return Update_click();
	}
}

function BodyLoadHandler() {

	//// Log 53528
	var par_win=window.opener;
	try {
		var objBatch=par_win.document.getElementById("HidStockBatches");
		if (objBatch && objBatch.value!="") {
			var qtysflag="N";
			var BatchSel=objBatch.value+"&";
			var lu = BatchSel.split("&");
			// check not default page load
			if ((lu[0].indexOf(",")!=-1) && (lu[0].indexOf(",")!="")) qtysflag="Y";
			var Seltbl = document.getElementById("tPharmacy_SelectBatch");
			var SelForm= document.getElementById("fPharmacy_SelectBatch");
			if (Seltbl && SelForm) {
				for (var curr_row=1; curr_row<Seltbl.rows.length; curr_row++) {
					var BatchID=SelForm.elements["BatchIDz" + curr_row].value;
					var Taken=SelForm.elements["Takenz" + curr_row];
					Taken.value="";
					for (var cnt=0; cnt<lu.length-1; cnt++) {
						if (qtysflag=="N") {
							var objQtyreq=document.getElementById("HidQtyReq");
							if ((BatchID==lu[cnt]) && objQtyreq) Taken.value=objQtyreq.value;
						}
						if (qtysflag=="Y") {
							var lu2 = lu[cnt].split(",");
							if (BatchID==lu2[0]) Taken.value=lu2[1];
						}
					}
					if (Taken.value=="") Taken.value=0;
				}
			} 
		}
	} catch (err) {}


	var objUpdate=document.getElementById("Update");
	if (objUpdate) {
		objUpdate.onclick=UpdateClickHandler;
	}
	/*
	if (window.opener) {
		var objExecIDs=document.getElementById("ExecIDs");
		var TableRow = "";
		var objTableRow=document.getElementById("TableRow");
		if (objTableRow) TableRow = objTableRow.value;
		var objParentExecIDs=window.opener.document.getElementById("OEORIExecz"+TableRow);
		if (objParentExecIDs && objExecIDs) {
			objExecIDs.value = objParentExecIDs.value;
		}
	}
	*/
}



document.body.onload = BodyLoadHandler;
