// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
// ab 28.06.02

var f=document.all.fepr_Worklist_Edit;
var tbl=document.getElementById("tepr_Worklist_Edit");

function DocumentLoadHandler()
{
	var objWorkID=document.getElementById("WorkID");
	checkWorklistItem();
	
	var objItm=document.getElementById("AddItem")
	if (objItm) objItm.onblur=checkWorklistItem;
	
	obj=document.getElementById('update1');
	if (obj) obj.onclick=UpdateHandler;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateHandler;
	
	disableSizes();

	for (var i=1; i<tbl.rows.length; i++) {
		var objPID=document.getElementById("wpidz"+i);
		var objName=document.getElementById("ItemNamez"+i);
		var objPComp=document.getElementById("ItemParamCompz"+i);
		var objItemID=document.getElementById("ItemIDz"+i);
		
		if ((objPID)&&(objName)) {
			if (objPID.value!="") objName.style.fontWeight="bold";
		}
		if ((objPID)&&(objWorkID)&&(objItemID)&&(objName)&&(objPComp)&&(objPComp.value!="")) {
			objName.onclick=OpenParams;
		}
		else if ((objPID)&&(objWorkID)&&(objItemID)&&(objName)&&(objPComp)&&(objPComp.value=="")) {
			//objName.disabled=true;
            objName.onclick=LinkDisable2;
            objName.style.fontWeight="normal";
			objName.style.textDecoration="none";
		}
		
		var objSeq=document.getElementById("Sequencez"+i);
		if (objSeq) objSeq.onblur=SequenceOnBlurHandler;
		
		var objSeq=document.getElementById("FrameRightz"+i);
		if (objSeq) objSeq.onclick=SequenceOnBlurHandler;
		
		var objSeq=document.getElementById("FrameTopz"+i);
		if (objSeq) objSeq.onclick=SequenceOnBlurHandler;
		
		var objSeq=document.getElementById("FrameLeftz"+i);
		if (objSeq) objSeq.onclick=SequenceOnBlurHandler;
		
		var objSeq=document.getElementById("FrameBottomz"+i);
		if (objSeq) objSeq.onclick=SequenceOnBlurHandler;
		
		var LinkOnly=document.getElementById("LinkOnlyz"+i);
		var LinkNewWindow=document.getElementById("LinkNewWindowz"+i);
		if ((LinkOnly)&&(LinkNewWindow)&&(!LinkOnly.checked)) {
			LinkNewWindow.disabled=true;
		}
	}
	
	return;
}

function OpenParams(evt)
{
	// sets the link if the item has a parameter component set (for setting specific parameters depending on component)
	var eSrc=websys_getSrcElement(evt);
	var i=eSrc.id.split("z");
	var i=i[1];
	
	var objPID=document.getElementById("wpidz"+i);
	if (objPID) var pid=objPID.value;
	var objPComp=document.getElementById("ItemParamCompz"+i);
	if (objPComp) var pcomp=objPComp.value;
	var objItemID=document.getElementById("ItemIDz"+i);
	if (objItemID) var itemid=objItemID.value;
	var objWorkID=document.getElementById("WorkID");
	if (objWorkID) var workid=objWorkID.value;
	var objWorkName=document.getElementById("name");
	if (objWorkName) var workname=objWorkName.value;
	var objSeq=document.getElementById("seqz"+i);
	if (objSeq) var seq=objSeq.value;
	
	var Frame="";
	var FrameBottom=document.getElementById("FrameBottomz"+i);
	var FrameTop=document.getElementById("FrameTopz"+i);
	var FrameRight=document.getElementById("FrameRightz"+i);
	var FrameLeft=document.getElementById("FrameLeftz"+i);
	if ((FrameBottom)&&(FrameBottom.checked)) Frame="B";
	if ((FrameTop)&&(FrameTop.checked)) Frame="T";
	if ((FrameRight)&&(FrameRight.checked)) Frame="R";
	if ((FrameLeft)&&(FrameLeft.checked)) Frame="L";
	
	
	if (eSrc.tagName=="A") {
		//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT='+pcomp+"&ID="+pid+"&WorkID="+workid+"&ItemID="+itemid,'','toolbar=no,location=no');
		var url = 'websys.default.csp?WEBSYS.TCOMPONENT='+pcomp+"&ID="+pid+"&WorkID="+workid+"&WorkName="+workname+"&ItemID="+itemid+"&Frame="+Frame+"&Sequence="+seq;
		websys_lu(url);
	}
	return;
}

function disableSizes() {
	var obj=document.getElementById("StyleCode");
	var objS1=document.getElementById("FrameSize1");
	var objS2=document.getElementById("FrameSize2");
	var objS3=document.getElementById("FrameSize3");
	if (obj) {
		if (obj.value=="LR") {
			DisableField("FrameSize2");
			DisableField("FrameSize3");
		}
		if (obj.value=="TB") {
			DisableField("FrameSize1");
			DisableField("FrameSize3");
		}
		if ((obj.value=="TLR")&&(obj.value=="BLR")) {
			DisableField("FrameSize3");
		}
	}
	return;
}

function UpdateHandler() {
	// check valid numbers for frame sizes
	var objS1=document.getElementById("FrameSize1");
	var objS2=document.getElementById("FrameSize2");
	var objS3=document.getElementById("FrameSize3");
	if ((objS1)&&(objS1.value!="")) {
		if ((isNaN(objS1.value))||(objS1.value<0)||(objS1.value>100)) {
			alert(t["InvalidSize"]);
			objS1.value="";
			websys_setfocus("FrameSize1");
			return;
		}
		if ((isNaN(objS2.value))||(objS2.value<0)||(objS2.value>100)) {
			alert(t["InvalidSize"]);
			objS2.value="";
			websys_setfocus("FrameSize2");
			return;
		}
		if ((isNaN(objS3.value))||(objS3.value<0)||(objS3.value>100)) {
			alert(t["InvalidSize"]);
			objS3.value="";
			websys_setfocus("FrameSize3");
			return;
		}
	}
	
	return update1_click();
}

function LinkDisable(evt) {
	if (evt.disabled) {
		return false;
	}
	return true;
}

function LinkDisable2() {
	return false;
}

function SequenceOnBlurHandler(e)
{
  // loop through all the rows and make sure sequence numbers for components on the same frame are not the same
 var eSrc=websys_getSrcElement(e);
 if ((eSrc)&&(eSrc.value!="")) {
	var currRow=eSrc.id.split("z");
	var currRow=currRow[1];
	if (eSrc==document.getElementById("FrameLeftz"+currRow)) eSrc=document.getElementById("Sequencez"+currRow);
	if (eSrc==document.getElementById("FrameRightz"+currRow)) eSrc=document.getElementById("Sequencez"+currRow);
	if (eSrc==document.getElementById("FrameTopz"+currRow)) eSrc=document.getElementById("Sequencez"+currRow);
	if (eSrc==document.getElementById("FrameBottomz"+currRow)) eSrc=document.getElementById("Sequencez"+currRow);
	if ((eSrc)&&(eSrc.value!="")) {
		for (var i=1; i<tbl.rows.length; i++) {
			var objSeq=document.getElementById("Sequencez"+i);
			if (objSeq) {
				var sFrameLeft=document.getElementById("FrameLeftz"+i)
				var currFrameLeft=document.getElementById("FrameLeftz"+currRow);
				var sFrameRight=document.getElementById("FrameRightz"+i)
				var currFrameRight=document.getElementById("FrameRightz"+currRow);
				var sFrameTop=document.getElementById("FrameTopz"+i)
				var currFrameTop=document.getElementById("FrameTopz"+currRow);
				var sFrameBottom=document.getElementById("FrameBottomz"+i)
				var currFrameBottom=document.getElementById("FrameBottomz"+currRow);
				if ((currRow!=i)&&(objSeq.value==eSrc.value)) {
					if ((sFrameLeft.checked&&currFrameLeft.checked)||(sFrameRight.checked&&currFrameRight.checked)||
					(sFrameTop.checked&&currFrameTop.checked)||(sFrameBottom.checked&&currFrameBottom.checked)) {
						alert(t["SameSeq"]);
						eSrc.value="";
						eSrc.focus();
					}
				}
			}
		}
	}
 }
 return;
}

function WorklistItemLookupSelect(str)
{
	checkWorklistItem();
	return;
}

function checkWorklistItem()
{
	var objItm=document.getElementById("AddItem")
	var objFrm=document.getElementById("AddItemFrame")
	
	if ((objItm)&&(objFrm))
	{
		if (objItm.value=="") {
			DisableField("AddItemFrame");
			DisableLookup("ld1420iAddItemFrame");
		}
		else if (objItm.value!=""){
			EnableField("AddItemFrame");
			EnableLookup("ld1420iAddItemFrame");
		}
	}
	return;
}

document.body.onload=DocumentLoadHandler;

function SelectRowHandler()	{
	// make sure one and only one frame checkbox is checked for each item
	var FrameLeft,FrameRight,FrameTop,FrameBottom;
	var eSrc=window.event.srcElement;
	
	if (eSrc.tagName=="IMG") eSrc=eSrc.parentElement;
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry.length>0) {
		FrameLeft=document.getElementById("FrameLeftz"+eSrcAry[1]);
		FrameRight=document.getElementById("FrameRightz"+eSrcAry[1]);
		FrameTop=document.getElementById("FrameTopz"+eSrcAry[1]);
		FrameBottom=document.getElementById("FrameBottomz"+eSrcAry[1]);
		LinkOnly=document.getElementById("LinkOnlyz"+eSrcAry[1]);
		LinkNewWindow=document.getElementById("LinkNewWindowz"+eSrcAry[1]);
		if (eSrcAry[0]=="FrameLeft") {
			FrameLeft.checked=true;
			FrameRight.checked=false;
			FrameTop.checked=false;
			FrameBottom.checked=false;
			return;
		}
		if (eSrcAry[0]=="FrameRight") {
			FrameLeft.checked=false;
			FrameRight.checked=true;
			FrameTop.checked=false;
			FrameBottom.checked=false;
			return;
		}
		if (eSrcAry[0]=="FrameTop") {
			FrameRight.checked=false;
			FrameLeft.checked=false;
			FrameBottom.checked=false;
			FrameTop.checked=true;
			return;
		}
		if (eSrcAry[0]=="FrameBottom") {
			FrameRight.checked=false;
			FrameTop.checked=false;
			FrameLeft.checked=false;
			FrameBottom.checked=true;
			return;
		}
		
		if ((LinkOnly)&&(LinkNewWindow)&&(eSrcAry[0]=="LinkOnly")) {
			if (LinkOnly.checked) {
				LinkNewWindow.disabled=false;
			} else {
				LinkNewWindow.disabled=true;
				LinkNewWindow.checked=false;
			}
		}
	}
}

function EnableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";

	}
}
function DisableField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if ((fld)&&(fld.tagName=="INPUT")) {
		fld.value = "";
		fld.disabled = true;
		fld.className = "disabledField";

	}
}

function DisableLookup(fldName)
{
	var obj=document.getElementById(fldName);
	if (obj) obj.disabled=true;
}

function EnableLookup(fldName)
{
	var obj=document.getElementById(fldName);
	if (obj) obj.disabled=false;
}

