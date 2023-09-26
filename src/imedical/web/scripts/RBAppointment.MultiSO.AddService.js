// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var lstItems=document.getElementById('ServiceList');
BuildServiceHeader()

function BuildServiceHeader() {
	var win=window.opener
	var descAry=win.sGrpDesc.split("^")
	var idAry=win.sGrp.split("^")
	for (var i=0;i<descAry.length-1;i++) {
		if (idAry[i].lastIndexOf("S")!=-1) {
			var inx=lstItems.length
			lstItems[inx]= new Option(descAry[i],idAry[i]);
			lstItems[inx].disabled=1;
			lstItems[inx].className="disabledField";
			//debugger;
		}
	}
}

function DocumentLoadHandler() {
	var obj=document.getElementById('Remove'); 
	if (obj) obj.onclick=RemoveClickHandler;

	var obj=document.getElementById('Update'); 
	if (obj) obj.onclick=UpdateClickHandler;
	
	if (lstItems) lstItems.onclick=ServListClickHandler;
}

function ServListClickHandler(e) {
	//debugger;
	//var eSrc=websys_getSrcElement(e)
	//eSrc.options[0]
	//if (!eSrc.disabled) {
	//if (eSrc.value.lastIndexOf("S")==-1) {
	//	eSrc.selectedIndex=-1;
	//}
}

function ServiceLookUp(str) {
	var lu = str.split("^");
	//alert(lu[0]+","+lu[1])

	//Check selected segment not already in Listbox.
	for(j=0; j<lstItems.length; j++) {
		if (lstItems[j].innerText==lu[0]) {
			alert(lu[0] + " " + t['AlreadyExist']);
			return false;
		}
	}

	lstItems[lstItems.length]= new Option(lu[0],lu[1]);
	var obj=document.getElementById('Service');
	if (obj) obj.value="";
	websys_setfocus("Service");
}

function RemoveClickHandler() {
	//debugger;
	var i=lstItems.selectedIndex;
	if (!lstItems(lstItems.selectedIndex).disabled) {
	//if (i!=-1) {
		lstItems.remove(i);
	} else {
		alert(t['CantRemove'])
	}
	return false;
}

function UpdateClickHandler() {
	var obj=document.getElementById('sessionId');
	if (obj) sessionId=obj.value;

	var obj=document.getElementById('date');
	if (obj) date=obj.value;
	
	//Build Service Header string
	var ServiceHeaderStr=""
	var ServiceIdStr=""
	for(j=0; j<lstItems.length; j++) {
		//if (lstItems[j].value.lastIndexOf("S")==-1) {
			ServiceHeaderStr+=lstItems[j].innerText+"^"
			ServiceIdStr+=lstItems[j].value+"S"+"^"
		//}
	}
	//debugger;
	//alert(ServiceIdStr)
	var win=window.opener;
	//while (win.opener) {win=win.opener;}
	websys_createWindow('rbappointment.multiso.reload.csp?sessionId='+sessionId+'&date='+date+'&ServiceHeader='+ServiceHeaderStr+'||'+ServiceIdStr+'&winHandle='+win.name,'TRAK_hidden')
	//websys_createWindow('websys.default.csp?ServiceHeader=hello','TRAK_hidden')
	//alert(win.name)
}

document.body.onload=DocumentLoadHandler;