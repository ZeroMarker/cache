// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
//Log 56894 BoC 12/12/2006

function BodyOnloadHandler() {
	var objTable=document.getElementById("tMRClinicalPathways_CycleDayList");
	var pobj=document.getElementById("PatientID");
	if (objTable){
		var numRows=objTable.rows.length;
		for (i=1;i<numRows;i++){
			var OrderItemObj=document.getElementById("OrderItemz"+i);
			if (OrderItemObj) OrderItemObj.onclick=OrderItemClickHandler;
			//Log 62631 PeterC 13/03/07
			var DelObj=document.getElementById("delete1z"+i);
			if((DelObj)&&(pobj)&&(pobj.value!="")) {
				DelObj.disabled=true;
				DelObj.style.visibility = "hidden";
 				DelObj.onclick=BlankClickHandler;
			}
		}
	}
}

function BlankClickHandler() {
	return false;
}

function OrderItemClickHandler(e){
	var eSrc=websys_getSrcElement(e);
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	var ItemDR="";
	var link="";
	var ItemDRObj=document.getElementById("ItemDRz"+row);
	if (ItemDRObj) ItemDR=ItemDRObj.value;
	if (ItemDR.indexOf("||")==-1) {
		link="websys.default.csp?WEBSYS.TCOMPONENT=MRClinicalPathways.OSItemList&ARCOSRowId="+ItemDR;
	} else {
		link="mrclinicalpathways.orderdetails.csp?ItemID="+ItemDR;
	}
	window.open(link,'MRCOrderDetails','top=50,left=100,width=400,height=300,scrollbars=yes,resizable=yes');
}

window.onload=BodyOnloadHandler;