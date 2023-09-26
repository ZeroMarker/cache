
function BodyOnloadHandler() {
	ARCashTransaction_Translate();
	//DisableCash();
}


function ARCashTransaction_Translate(e) {
	var tbl=document.getElementById("tARCashierTransactions_List");

	for (var i=1; i<tbl.rows.length; i++) {

		var objTot=document.getElementById("Totz"+i);
		//alert(i);
		if (objTot) {
			var tot=objTot.value;

			if(tbl) {
				var tblLen=(tbl.rows.length)-1;
				var cell,cell1,cell2,cell3,cell4,row,cellbefore="";
				var index1,index2,index3,index4=1000000;
				var objCash=document.getElementById("REC_Cashz"+i);
				var objCard=document.getElementById("REC_Cardz"+i);
				var objCheque=document.getElementById("REC_Chequesz"+i);
				var objDirect=document.getElementById("REC_Directz"+i);
					
				if(objCash) cell1=websys_getParentElement(objCash);
				if(objCard) cell2=websys_getParentElement(objCard);
				if(objCheque) cell3=websys_getParentElement(objCheque);
				if(objDirect) cell4=websys_getParentElement(objDirect);
					
				if(cell1) index1=cell1.cellIndex;
				if(cell2) index2=cell2.cellIndex;
				if(cell3) index3=cell3.cellIndex;
				if(cell4) index4=cell4.cellIndex;
				
				if((index1<index2)&&(index1!=1000000)) cell=cell1
				else if(index2!=1000000) {cell=cell2;}	
			}
			if ((tot!="")&&(tot=="TOT")) {
				if(tbl) {
					if(cell) {
						row=websys_getParentElement(cell);
						if(tbl.rows[row.rowIndex].cells[cell.cellIndex-1]) tbl.rows[row.rowIndex].cells[cell.cellIndex-1].innerText=t['TOT'];
					}
				}	
			}
			if ((tot!="")&&(tot=="ADJ")) {
				if(tbl) {
					if(cell) {
						row=websys_getParentElement(cell);
						if(tbl.rows[row.rowIndex].cells[cell.cellIndex-1]) tbl.rows[row.rowIndex].cells[cell.cellIndex-1].innerText=t['ADJ'];
					}
				}
			}
			if ((tot!="")&&(tot=="GRD")) {
				if(tbl) {
					if(cell) {
						row=websys_getParentElement(cell);
						if(tbl.rows[row.rowIndex].cells[cell.cellIndex-1]) tbl.rows[row.rowIndex].cells[cell.cellIndex-1].innerText=t['GRD'];
					}
				}
			}
		}
	}
}	

function DisableCash() {
	var tbl=document.getElementById("tARCashierTransactions_List");
	for (var i=1; i<tbl.rows.length; i++) {
		var TotVal=document.getElementById("Totz"+i);
		if ((TotVal) && (TotVal.value!="ADJ")) {
			var CashCol=document.getElementById("REC_Cashz"+i);
			if (CashCol) {CashCol.disabled=true; CashCol.onclick=LinkDisable;}
		}	}
}
	
function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);

	if (el.disabled||el.id=="") return false;

	return true;
}



document.body.onload=BodyOnloadHandler;