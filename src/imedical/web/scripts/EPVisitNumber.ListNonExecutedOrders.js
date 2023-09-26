// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var f=document.getElementById("fEPVisitNumber_ListNonExecutedOrders");

/*function SelectRowHandler() {
	//If Arrived Column was clicked then perform status update.
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry.length>0) {
		if (eSrcAry[0]=="Arrived") {
			var obj=document.getElementById('ArrivalDateFlagz'+eSrcAry[1]);
			if (obj) {
				var ArrivalDate=obj.value;
			} else {
				var ArrivalDate="";
			}
			var obj2=f.elements['OERowIDsz'+eSrcAry[1]];
			if (obj2) {
				var OERowIDs=obj2.value;
			}
			//alert('epvisitnumber.labcollectionchangestatus.csp?ArrivalDate='+ArrivalDate+'&OERowIDs='+OERowIDs);
			websys_createWindow('epvisitspecimen.labchangestatus.csp?ArrivalDate='+ArrivalDate+'&OERowIDs='+OERowIDs,window.name,'');
			return false;
		}
	}
}
*/
