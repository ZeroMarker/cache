// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function LoadHandler() {

	var reason = document.getElementById('Reason')
	var creason = document.getElementById('cReason')

	var obj=document.getElementById('update1')
	if (obj) {
		obj.onclick=UpdateHandler;
		websys_sckeys[tsc['update1']]=UpdateHandler;
	}
	if (reason) {	//ANA 30-04-02 LOG 24537 Not a hidden field.
	}
}
function ChangeStatusHandler(val) {
	ary=val.split("^");
	newOEItemStatus=ary[1];

	var newobj=document.getElementById("newOEItemStatus"); //LOG 31191
	if (newobj) newobj.value=newOEItemStatus;
}

//ChangeVarianceHandler isn't called anymore
function ChangeVarianceHandler(val) {
	ary=val.split("^");
	newVarReason=ary[1];

	var newobj=document.getElementById("newVarReason"); //LOG 31191
	if (newobj) newobj.value=newVarReason;
}

function UpdateHandler() {
	//var newobj=document.getElementById("newOEItemStatus"); //LOG 31191
	//if (newobj){ newOEItemStatus=newobj.value;  }
	//var goobj=document.getElementById("goAhead"); //LOG 31191
	//if (goobj) goAhead=goobj.value;

	goAhead=1
	var result="";

	var bfobj=document.getElementById("BilledFlag");
	if (bfobj) {
		var bfvalue=bfobj.value.split("^");
		for (var bm=0;bm<bfvalue.length;bm++) {
			if (bfvalue[bm]=="TR"||bfvalue[bm]=="R") {
				alert(t['CanNotChangeStatus']);
				goAhead=0;
				break;
			}
		}		
	}
	//Log 64703 - 01.11.2007
	var billsList="";
	var objbills = document.getElementById("linkedBills");
	if ((objbills)&&(objbills.value!=0)) {
		result=objbills.value; 
	}
	if ((goAhead==1)&&(newOEItemStatus=="D")&&(result!="")) {
		var result=result.split("^");
		billsList=result[1];
		if (confirm(t['LINKED_ORDERS']+": "+billsList+". "+t['LINKED_ORDERS2'])) {
			goAhead=1
		} 
		else {
			goAhead=0;
			window.close();
			var win=window.opener;
			if (win) {
				win.treload('websys.csp');
			}			
		}	
	}	
	if ((goAhead==1)&&(newOEItemStatus=="D")&&(billsList=="")) if (confirm(t['OE_DISCONTINUE'])) {goAhead=1} else {goAhead=0};
	if ((goAhead==1)&&(newOEItemStatus=="E")) if (confirm(t['OE_EXECUTE'])) {goAhead=1} else {goAhead=0};
	if ((goAhead==1)&&(newOEItemStatus=="H")) if (confirm(t['OE_HOLDCONFIRM'])) {goAhead=1} else {goAhead=0};
	if ((goAhead==1)&&(newOEItemStatus=="V")) if (confirm(t['OE_VERIFY'])) {goAhead=1} else {goAhead=0};
	if (goAhead==1) {
		if (checkNewStatus(newOEItemStatus)) {
			return update1_click();
		}
		else {
			window.close();
			var win=window.opener;
			if (win) {
				win.treload('websys.csp');
			}
		}
	} else {
		return false;
	}
}
//Replaced $c(1) with ^ and $c(2) with *
function checkNewStatus(newOEItemStatus) {
	var Allow="";
	var Aobj=document.getElementById("AllowToDiscont");
	if (Aobj) Allow=Aobj.value;
	var objOE=f.elements["OrderString"];
	var newString="";
	if (objOE) {
		var arrayOE=objOE.value.split("^");  //array
		for (var count=0;count<arrayOE.length;count++) {
			var arrayItem=arrayOE[count].split("*");
			//var OEItemName=arrayItem[1]; //log60961 TEdT
			var currentOEItemStatus=arrayItem[1];
			var paid=arrayItem[2];
			var goAhead=true;
			if ((currentOEItemStatus=="IP")&&(newOEItemStatus!='D')) {
				alert(t['OE_INPROG']);
				goAhead=false;
			}
			else if (newOEItemStatus=='E') {
				if (currentOEItemStatus=="E") {alert(t['OE_EXECUTED']);goAhead=false;}
			}
			else if (newOEItemStatus=='V') {
				if (currentOEItemStatus=="V") {alert(t['OE_VERIFIED']);goAhead=true;}
			}
			else if (newOEItemStatus=='D') {
				if (currentOEItemStatus=="D") {alert(t['OE_DISCONTINUED']);goAhead=false;}
				if (paid=='D'){if (!confirm(t['OE_DISCONTINUEPAID'])) goAhead=false;} //Log 17482
			}
			else if (newOEItemStatus=='H') {
				if (currentOEItemStatus=="H") {alert(t['OE_HELD']);goAhead=false;}
			}
			if (goAhead) {
				if (newString=="") {
					newString=arrayItem[0]; //log60961 TEdT
				} else {
					newString=newString+"^"+arrayItem[0]; //log60961 TEdT
				}
			}
		}
		objOE.value = newString;
	}
	return (newString!="");
}
function XcheckNewStatus(newOEItemStatus) {
	var Allow="";
	var Aobj=document.getElementById("AllowToDiscont");
	if (Aobj) Allow=Aobj.value;
	var objOE=f.elements["OrderString"];
	//var OrderStringobj=document.getElementById("OrderString"); //LOG 31191
	//if (OrderStringobj) OrderStringobj.value=f.elements["OrderString"].value
	//alert("55xx f.elements[OrderString] = "+f.elements["OrderString"].value);
	var newString="";
	if (objOE) {
		var arrayOE=objOE.value.split(String.fromCharCode(1));  //array
		for (var count=0;count<arrayOE.length;count++) {
			var arrayItem=arrayOE[count].split(String.fromCharCode(2));
			//alert("71xx arrayItem = "+arrayItem);
			var OEItemName=arrayItem[1];
			var currentOEItemStatus=arrayItem[2];
			var paid=arrayItem[3];
			var goAhead=true;
			// Log 47534 - AI - 29-11-2004 : Remove the immediate check of changing Status from In Progress to Dicontinued.
			// 				 Check will be done in web.OEOrder - CheckStatusSecurityGroup.
			//if (currentOEItemStatus=="IP") {
			if ((currentOEItemStatus=="IP")&&(newOEItemStatus!='D')) {
				alert(t['OE_INPROG']);
				goAhead=false;
			}
			else if (newOEItemStatus=='E') {
				if (currentOEItemStatus=="E") {alert(t['OE_EXECUTED']);goAhead=false;}
				//if (paid!="P") {alert(t['OE_EXECUTEUNPAID']);goAhead=false;}  //TODO: Needed for Indian settings
			}
			//if (newOEItemStatus=='H') if (paid=='P'){if (!confirm(t['OE_HOLDPAID'])) goAhead=false;} //Log 17482 for india
			else if (newOEItemStatus=='V') {
				// Log 50731 - AI - 29-03-2005 : Allow Executed Orders to be changed.
				//if (currentOEItemStatus=="E") {alert(t['OE_EXECUTED']);goAhead=false;}
				if (currentOEItemStatus=="V") {alert(t['OE_VERIFIED']);goAhead=true;}
			}
			else if (newOEItemStatus=='D') {
				// Log 50731 - AI - 29-03-2005 : Allow Executed Orders to be changed.
				//if ((currentOEItemStatus=="E") && (Allow!="Y")) {alert(t['OE_NOTALLOWDISC']);goAhead=false;}
				if (currentOEItemStatus=="D") {alert(t['OE_DISCONTINUED']);goAhead=false;}
				if (paid=='D'){if (!confirm(t['OE_DISCONTINUEPAID'])) goAhead=false;} //Log 17482
			}
			else if (newOEItemStatus=='H') {
				// Log 50731 - AI - 29-03-2005 : Allow Executed Orders to be changed.
				//if (currentOEItemStatus=="E") {alert(t['OE_NOTALLOWHOLD']);goAhead=false;}
				if (currentOEItemStatus=="H") {alert(t['OE_HELD']);goAhead=false;}
			}
			// Log 50731 - AI - 29-03-2005 : Allow Executed Orders to be changed.
			//if ((goAhead)&&(currentOEItemStatus=='E')) {
			//	if ((newOEItemStatus!='D')||(Allow!="Y")) {
			//		alert(t['OE_NOTALLOWEXECTUED']);
			//		goAhead=false;
			//	}
			//}

			if (goAhead) {
				if (newString=="") {
					newString=arrayOE[count];
				} else {
					newString=newString+String.fromCharCode(1)+arrayOE[count];
				}
			}
		}
		objOE.value = newString;
	}
	return (newString!="");
}


var f=document.fOEOrder_ChangeStatus;

//var OrderStringobj=document.getElementById("OrderString"); //LOG 31191
//if (OrderStringobj) OrderStringobj.value=f.elements["OrderString"].value

var newOEItemStatus;
var goAhead;
var newVarReason;

var newobj=document.getElementById("newOEItemStatus"); //LOG 31191
if (newobj) {
	newOEItemStatus=newobj.value;
} else {
	newOEItemStatus="";
}

var goAheadobj=document.getElementById("goAhead"); //LOG 31191
if (goAheadobj) {
	goAhead=goAheadobj.value;
}
else {
	goAhead=0;
}

var newVarobj=document.getElementById("newVarReason"); //LOG 31191
if (newVarobj) {
	newVarReason=newVarobj.value;
} else {
	newVarReason="";
}


window.onload=LoadHandler;

