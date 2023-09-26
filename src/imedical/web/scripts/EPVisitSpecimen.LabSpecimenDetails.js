// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objParentWindow=window.opener;
var flag=0;

function UpdateClickHandler() {
	/*
	var obj=document.getElementById("Orders");
	//if ((obj)&&(obj.disabled)) obj.disabled = false;

	var selected=false;
	var lst=document.getElementById("Orders");
	if (lst) {
		for (var j=0; j<lst.length; j++) {
			if (lst.options[j].selected == true) {
				selected = true;
			}
		}
	}
	if (selected==false) {
		alert(t["OrderNotSelected"]);
		flag=0;
		return false;
	}

	var obj=document.getElementById("volumecol");
	if ((obj)&&(pos!=0)) obj.disabled = false;

	flag=1;
	var lst=document.getElementById("Orders");
	var selectedorderids = document.getElementById("selectedorderids");
	var specimenids = allspecimenids.split ("^")
	if ((lst)&&(selectedorderids)) {
		selectedorderids.value = "";
		for (var j=0; j<lst.length; j++) {

			if (lst.options[j].selected == true) {
				if (selectedorderids.value!="") { selectedorderids.value = selectedorderids.value + "^";}
				selectedorderids.value = selectedorderids.value + (specimenids[j]) ;
			}
		}
	}
	*/

	// Log 41647 - AI - 25-02-2004 : If invalid container, do not update.
	var obj=document.getElementById("container");

	if ((obj)&&(obj.className=="clsInvalid")) {
		return false;
	}
	if ((obj)&&(obj.className=="clsRequired") && (obj.value=="")) return false;
	// end Log 41647

	flag=1;
	return update_click();
}

function BodyUnloadHandler() {
	if ((objParentWindow)&&(flag==1)) {
		//objParentWindow.location.reload();
		objParentWindow.treload('websys.csp');
	}
}

// 02/06/2005 YC dont really need this method because we are no longer adding specimens
function ordersChangeHandler() {
	var lst=document.getElementById("Orders");
	var IDlst=document.getElementById("SpecBuffer");
	var currentorder = document.getElementById("currentorder");
	if ((lst)&&(currentorder)&&(IDlst)) {
		currentorder.value = "";
		var orderid=IDlst.value.split('^');
		for (var j=0; j<lst.length; j++) {
			if ((lst.options[j].selected == true)&&(!currentorder.value.match(orderid[j]))) { //not already in the list
				if (currentorder.value!="") currentorder.value = currentorder.value + ",";
				currentorder.value = currentorder.value + orderid[j];
			} 
		}
	}
}

function BodyLoadHandler() {
	var obj=document.getElementById("update");
	if (obj) obj.onclick = UpdateClickHandler;

	var obj=document.getElementById("Orders");
	if (obj) {
		obj.disabled = ordersdisabled;
		// YC 02/06/2005 - not adding specimens anymore so not needed
		//obj.onchange = ordersChangeHandler;
	}

	/*
	if (objParentWindow) {
		var objSpec=objParentWindow.document.getElementById("SpecsBuffer");
		//alert(objSpec.value)
		var obj=document.getElementById("SpecBuffer");
		//alert(obj.value)
		if ((objSpec)&&(obj)) {
			obj.value=objSpec.value;
		}
	}
	*/

	var obj=document.getElementById("volumecol");
	if (obj) {
		if (extlab=="Y") {
			obj.disabled=false;
		} else {
			obj.disabled=true;
		}
	}
	var obj=document.getElementById("Orders");
	if (obj) {
		if (extlab=="Y") {
			obj.multiple=false;
		} else {
			obj.multiple=true;
		}
	}
	/*
	var arrOrders=ordersbuffer.split("^");
	if (obj) {
		obj.selectedIndex = -1;
		for (var i=0; i<arrOrders.length; i++) {
			var arrOrder=arrOrders[i].split(String.fromCharCode(1));
			// if external system - we require the order ID as the hidden field (used to add specimens)
			// if LabTrak - we require the External Testset Code
			if (extlab=="Y") {
				var code=arrOrder[0];
			} else {
				var code=arrOrder[1];
			}
			var desc=arrOrder[2];
			//alert("order= "+i+" code= "+code+" desc= "+desc);
			obj.options[obj.length]=new Option(desc,code);
		}
		if (orderids!="") SetSelectedTestSets(orderids);
	}
	*/
	var arrOrders=allorders.split("^");
	if (obj) {
		obj.selectedIndex = -1;
		for (var i=0; i<arrOrders.length; i++) {
			var arrOrder=arrOrders[i];
			obj.options[obj.length]=new Option(arrOrder,arrOrder);
		}
		if (orderids!="") SetSelectedTestSets(orderids);
	}

	// container mandatory ofr LabTrak..
	if (extlab!="Y") {
		MandatoryField("container");
	} else {
		UnMandatoryField("container");

	}
}

function MandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById("c"+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "clsRequired";
		if (lbl) lbl.className = "clsRequired";
	}
}

function UnMandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById("c"+fldName);
	if (fld) {
		if (lbl) lbl.className = "";
	}
}

function SetSelectedTestSets(SelectedTests) {
	//alert(SelectedTests);
	var arrSelected = SelectedTests.split(",");
	var lst=document.getElementById("Orders");
	if (lst) {
		lst.selectedIndex=-1;
		for (var i in arrSelected) {
			if (arrSelected[i] == "") continue;
			for (var j=0; j<lst.length; j++) {
				//var arrTestSet=lst.options[j].value.split(",");
				//var arrSelTestSet=arrSelected[i].split(",");
				//alert(arrSelected[i]+"+"+lst.options[j].value);
				//if (arrSelTestSet.length==2) {
					//alert(arrSelected[i]+"+"+lst.options[j].value)
					if (arrSelected[i] == lst.options[j].value) {
						lst.options[j].selected = true;
					}
				//} else {
				//	alert(arrSelected[i]+"+"+arrTestSet[1])
				//	if (arrSelected[i] == arrTestSet[1]) {
				//		lst.options[j].selected = true;
				//	}
				//}
			}
		}
	}
}


document.body.onunload=BodyUnloadHandler;
document.body.onload=BodyLoadHandler;
