// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
/*	var tblOrdItemOS=document.getElementById("tOEOrder_OrderItemOSList");
	if (tblOrdItemOS) {
		//debugger;
		//alert(document.getElementById("r54457196r2118iOrderSetListz4").name);
		//var ttt=document.getElementById("AddItemz4")
		arrCx=document.getElementsByTagName("INPUT");
		for (var i=0; i<arrCx.length; i++) {
			if (arrCx[i].type=="checkbox") {
				alert(arrCx[i].id);
			}
		}
	}*/

function BodyLoadHandler() {
	//alert("here")
	var OrderSetID=document.getElementById("OrderSetID").value

	var tblOrdItemOS=document.getElementById("tOEOrder_OrderItemOSList");
	if (tblOrdItemOS){
		for (var i=1; i<tblOrdItemOS.rows.length; i++) {
			var AddItemOSObj=tblOrdItemOS.rows[i].cells[2]
			if (AddItemOSObj) {
				//AddItemOSObj.onclick=AddItemOSClickHandler;
				//AddItemOSObj.id="AddItemOS"+OrderSetID+"z"+i;
				//AddItemOSObj.name="AddItemOS"+OrderSetID+"z"+i;
			}
		}
	}
	
}

function SelectClickHandler(){
	var eTABLE=document.getElementById("tOEOrder_OrderItemList");
	var value=true;
	if (eTABLE){
		for (var i=1; i<eTABLE.rows.length; i++) {
			var AddItemObj=document.getElementById("AddItemz"+i);
			if ((i==1)&&(AddItemObj.checked)) value=false; 
			if ((AddItemObj)&&(AddItemObj.disabled!=true)) {
				AddItemObj.checked=value;
			}
		}
	}
	return false;
}

function AddItemOSClickHandler(evt) {
	var el = websys_getSrcElement(evt);
	alert(el.name);
}
document.body.onload = BodyLoadHandler;