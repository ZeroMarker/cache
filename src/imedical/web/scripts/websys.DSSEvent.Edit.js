	//function BodyUnloadHandler(e) {
//	if ((self == top)) {
//		var win=window.opener;
//		if (win) {
//			win.treload('websys.csp');
//		}
//	}
//}
//we don;t need to do this, updat eshould link to websys.relaod.csp
//document.body.onunload=BodyUnloadHandler;
document.body.onload=BodyLoadHandler;
// Log 54140 YC - Broker on websys.DSSEvent.Edit will not run if we have a change handler
// change handler is activated after the broker/lookup runs
//var objET=document.getElementById('EventType');		//Event Type
//if (objET) objET.onchange=EventTypeChangeHandler;

function BodyLoadHandler() {
	// if we've been opened
	uobj=document.getElementById('update1');
	if (uobj) uobj.onclick=UpdateClickHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateClickHandler;
	IDobj=document.getElementById("ID");
	if (IDobj){
		delobj=document.getElementById('delete1');
		if (IDobj.value=="") {
			if (delobj) {
				delobj.disabled=true;
				delobj.onclick="";
			}
		} else {
			if (delobj) delobj.onclick=DeleteClickHandler;

		}
	}
	var classobj=document.getElementById("Class")
	if (classobj) {
		classobj.readOnly=true;
	} else {
		cobj=document.getElementById("ClassDisplayName")
		if (cobj) alert("The item Class MUST be on the page")
		//this is added at syds request
	}
	PopulateTriggers();
	EventTypeChangeHandler();
}

// ab 15.01.07 60826
function PopulateTriggers() {
	var obj=document.getElementById("ClassTrigger");
	var objsel=document.getElementById("ClassTriggerSel");
	if ((obj)&&(objsel)) {
		var triggers=objsel.value;
		for (var i=0;i<obj.length;i++) {
			if (((triggers.indexOf("OnBeforeUpdate")!=-1)||(triggers.indexOf("OnAfterUpdate")!=-1))&&(obj.options[i].value=="OnUpdate")) obj.options[i].selected=true;
			if (((triggers.indexOf("OnBeforeInsert")!=-1)||(triggers.indexOf("OnAfterInsert")!=-1))&&(obj.options[i].value=="OnInsert")) obj.options[i].selected=true;
			if (((triggers.indexOf("OnBeforeDelete")!=-1)||(triggers.indexOf("OnAfterDelete")!=-1))&&(obj.options[i].value=="OnDelete")) obj.options[i].selected=true;
		}
	}
}

function SetTXTStatus(obj,blnStatus) {
	if (!blnStatus) {
		obj.value='';
		obj.readOnly=!blnStatus;
		obj.className='disabledField';
	}
	else{
		obj.readOnly=!blnStatus;
		obj.className='enabledField';
	}
}
function SetCMDStatus(obj,blnStatus) {
	obj.disabled=!blnStatus
}


// required to populate field for use in EventTypeChangeHandler
function LookUpEventType(str) {
	var lu = str.split("^");
	var obj;
	obj=document.getElementById('EventType');
	if (obj) obj.value = lu[0];
	EventTypeChangeHandler()
}


function EventTypeChangeHandler() {
	var objET=document.getElementById('EventType');		//Event Type
	//var objCL=document.getElementById('Class');
	var objCLD=document.getElementById('ClassDisplayName');
	var objClass=document.getElementById('Class');
	var objCT=document.getElementById('ClassTrigger');
	var objCM=document.getElementById('Component');
	var objCMT=document.getElementById('ComponentTrigger');

	var objCLButt=document.getElementById('ld1214iClassDisplayName');
	var objCTButt=document.getElementById('ld1214iClassTrigger');
	var objCMButt=document.getElementById('ld1214iComponent');
	var objCMTButt=document.getElementById('ld1214iComponentTrigger');

	if ((objET)&&(objET.value=="Component")) {
		labelMandatory("Component");
		labelMandatory("ComponentTrigger");
	} else {
		labelNormal("Component");
		labelNormal("ComponentTrigger");
	}

	if (objET) {
		//alert(objET.value);
		switch (objET.value){
		case 'Class':
			//if (objCL) SetTXTStatus(objCL,true);
			if (objCLD) SetTXTStatus(objCLD,true);
			if (objCT) {
				//SetTXTStatus(objCT,true);
				objCT.disabled=false;
			}
			if (objCM) SetTXTStatus(objCM,false);
			if (objCMT) SetTXTStatus(objCMT,false);
			if (objCLButt) SetCMDStatus(objCLButt,true);
			if (objCTButt) SetCMDStatus(objCTButt,true);
			if (objCMButt) SetCMDStatus(objCMButt,false);
			if (objCMTButt) SetCMDStatus(objCMTButt,false);
			break;
		case 'Component':
			//if (objCL) SetTXTStatus(objCL,false);
			if (objCLD) SetTXTStatus(objCLD,false);
			if (objCT) {
				UnSelectAllOptions(objCT);
				//SetTXTStatus(objCT,false);
				objCT.disabled=true;
			}
			if (objCM) SetTXTStatus(objCM,true);
			if (objCMT) SetTXTStatus(objCMT,true);
			if (objCLButt) SetCMDStatus(objCLButt,false);
			if (objCTButt) SetCMDStatus(objCTButt,false);
			if (objCMButt) SetCMDStatus(objCMButt,true);
			if (objCMTButt) SetCMDStatus(objCMTButt,true);
			//if (objClass) objClass.value="";
			break;
		default :
			//if (objCL) SetTXTStatus(objCL,false);
			if (objCLD) SetTXTStatus(objCLD,false);
			if (objCT) SetTXTStatus(objCT,false);
			if (objCM) SetTXTStatus(objCM,false);
			if (objCMT) SetTXTStatus(objCMT,false);
			if (objCLButt) SetCMDStatus(objCLButt,false);
			if (objCTButt) SetCMDStatus(objCTButt,false);
			if (objCMButt) SetCMDStatus(objCMButt,false);
			if (objCMTButt) SetCMDStatus(objCMTButt,false);
			if (objClass) objClass.value="";
			break;
		}
	}
}

function UnSelectAllOptions(obj) {
	for (var i=0;i<obj.length;i++) {
		obj.options[i].selected=false;
	}
}

function ClassDisplayNameLookup(str) {
	//alert(str);
 	var lu = str.split("^");
	var obj;
	obj=document.getElementById("Class");
	if (obj) obj.value = lu[1];
	obj=document.getElementById("ClassHidden");
	if (obj) obj.value = lu[1];
	obj=document.getElementById("ClassDisplayName");
	if (obj) obj.value = lu[0];
}

function UpdateClickHandler() {
	var ret;
	if (CheckDates("StartDate", "EndDate")) {
		UpdateTriggers();
		ret = update1_click();
	}
}

// ab 15.01.07 60826
function UpdateTriggers() {
	var obj=document.getElementById("ClassTrigger");
	var objsel=document.getElementById("ClassTriggerSel");
	var triggers="";
	
	if ((obj)&&(objsel)) {
		for (var i=0;i<obj.length;i++) {
			if (obj.options[i].selected==true) {
				if (triggers!="") triggers=triggers+",";
				if (obj.options[i].value=="OnUpdate") triggers=triggers+"OnBeforeUpdate,OnAfterUpdate";
				if (obj.options[i].value=="OnInsert") triggers=triggers+"OnBeforeInsert,OnAfterInsert";
				if (obj.options[i].value=="OnDelete") triggers=triggers+"OnBeforeDelete,OnAfterDelete";
			}
		}
		objsel.value=triggers;
	}
}

function DeleteClickHandler() {
	//var url="websys.csp?XCOMPONENT=1212";
	var url="websys.default.csp?WEBSYS.TCOMPONENT=websys.DSSEvent.Find";
	var win=window.opener;
	if (win.parent[1]) win.parent[1].location.href=url;
	return delete1_click()
}

function CheckDates(FromObjName,ToObjName) {
	// SA: The cache function called will do all the date from/to validation
	// This function will just check that the mandatory fields have been filled.

	var objDateFrom=document.getElementById(FromObjName)
	var objDateTo=document.getElementById(ToObjName)

	if ((objDateFrom)&&(objDateFrom.value!="")&&(objDateTo)&&(objDateTo.value!="")) {
		var fromdt=SplitDateStr(objDateFrom.value)
		var todt=SplitDateStr(objDateTo.value)
		var dtto=new Date(todt["yr"], todt["mn"]-1, todt["dy"]);
		var dtfrom=new Date(fromdt["yr"], fromdt["mn"]-1, fromdt["dy"]);
		if (dtto< dtfrom) {
			alert(t['ENDDATE IS INVALID']);
			objDateTo.className='clsInvalid';
			websys_setfocus(ToObjName);
			return false;
		}
	}

	return true;
}

function SplitDateStr(strDate) {
 	var arrDateComponents = new Array(3);
 	var arrDate = strDate.split(dtseparator);
 	switch (dtformat) {
  	case "YMD":
   	arrDateComponents["yr"] = arrDate[0];
   	arrDateComponents["mn"] = arrDate[1];
   	arrDateComponents["dy"] = arrDate[2];
   	break;
  	case "MDY":
   	arrDateComponents["yr"] = arrDate[2];
   	arrDateComponents["mn"] = arrDate[0];
   	arrDateComponents["dy"] = arrDate[1];
   	break;
  	default:
   	arrDateComponents["yr"] = arrDate[2];
   	arrDateComponents["mn"] = arrDate[1];
   	arrDateComponents["dy"] = arrDate[0];
   	break;
 	}
 	return arrDateComponents;
}


function ComponentLookup(str) {
	var lu=str.split("^");
	var ClassName=lu[1];
	var ClassName2=ClassName.split(".");
	if (ClassName2[0]=="web") ClassName="User."+ClassName2[1];
	var obj=document.getElementById("Class");
	if (obj) { obj.value=ClassName; }
	var obj=document.getElementById("ClassHidden");
	if (obj) { obj.value=ClassName; }
	var obj=document.getElementById("ComponentTrigger");
	var objonload=document.getElementById("TriggerOnLoad");
	if ((objonload)&&(obj)) obj.value=objonload.value;
}

function labelMandatory(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "clsRequired";
	}
}
function labelNormal(fld) {
	var lbl = document.getElementById('c' + fld)
	if (lbl) {
		lbl.className = "";
	}
}