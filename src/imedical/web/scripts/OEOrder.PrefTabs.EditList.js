// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var cbxSaveWkfl=document.getElementById('SaveContextWorkflow');
var lstTabs=document.getElementById("LISTTabs");
var fldAddTab=document.getElementById("NAMEAddTab");
var objType=document.getElementById("XTYPE");
var objContext=document.getElementById("XCONTEXT");
var objCTLOC=document.getElementById("CTLOCoverride");
var brokerCTLOC="";

var itemdataDelim = String.fromCharCode(4);
var groupitemDelim = String.fromCharCode(28);
var tabgroupDelim = String.fromCharCode(1);

if (cbxSaveWkfl) {
	if (objContext.value=="") cbxSaveWkfl.disabled=true;
	////从西医界面打开，要勾上
	if (document.getElementById("CMFlag").value!=""){
		cbxSaveWkfl.checked=true
	}else{
		cbxSaveWkfl.checked=true;
		//cbxSaveWkfl.disabled=true;
	}
	cbxSaveWkfl.onclick=SaveContextWorkflowSelectHandler
}

//if location field had value, then was cleared, broker select function does not get called, but we need
//to reset the 'save preference against' field back to the defaulting location.
if (objCTLOC) {
	brokerCTLOC=objCTLOC.onchange;
	objCTLOC.onchange=CTLOCChangeHandler;
}
if (fldAddTab) fldAddTab.onblur=TabAddBlurHandler;

var delete1Obj=document.getElementById("delete1");
if (delete1Obj) delete1Obj.onclick=delete1ClickHandler;

function delete1ClickHandler() {
	var HrefURL=window.location.href;
	delete1_click();
	window.location.href=HrefURL;
}
function GetDesc(type) {
	var desc=""; var ref=""
	var wkfldesc="";
	//Log 52176 30/09/05 PeterC
	var HospDesc="";
	var HObj=document.getElementById("HospitalDesc");
	if((HObj)&&(HObj.value!="")) HospDesc=HObj.value;

	if ((cbxSaveWkfl)&&(cbxSaveWkfl.checked)) wkfldesc=" + "+objContext.value;
	switch (type) {
		case 'L':
			var loc=document.getElementById("CTLOC").value;
			if ((objCTLOC)&&(objCTLOC.value!="")) loc=objCTLOC.value;
			desc = t['CTLOC'] + " (" + loc + ")" + wkfldesc;
			break;
		case 'G':
			desc = t['SSGRP'] + " (" + session["LOGON.GROUPDESC"] + ")" + wkfldesc;
			break;
		case 'T':
			desc = t['SITE'] + " (" + session["LOGON.SITECODE"] + ")" + wkfldesc;
			break;
		case 'H':
			desc = t['HOSP'] + " (" + HospDesc + ")" + wkfldesc;
			break;
		default:
			desc = t['SSUSR'] + " (" + session["LOGON.USERNAME"] + ")" + wkfldesc;
			break;
	}
	return desc;
}
function GetDesc1(type) {
	var desc=""; var ref=""
	var wkfldesc="";
	//Log 52176 30/09/05 PeterC
	var HospDesc="";
	var HObj=document.getElementById("HospitalDesc");
	if((HObj)&&(HObj.value!="")) HospDesc=HObj.value;

	if ((cbxSaveWkfl)&&(cbxSaveWkfl.checked)) wkfldesc=" + "+"西医";
	switch (type) {
		case 'L':
			var loc=document.getElementById("CTLOC").value;
			if ((objCTLOC)&&(objCTLOC.value!="")) loc=objCTLOC.value;
			desc = t['CTLOC'] + " (" + loc + ")" + wkfldesc;
			break;
		case 'G':
			desc = t['SSGRP'] + " (" + session["LOGON.GROUPDESC"] + ")" + wkfldesc;
			break;
		case 'T':
			desc = t['SITE'] + " (" + session["LOGON.SITECODE"] + ")" + wkfldesc;
			break;
		case 'H':
			desc = t['HOSP'] + " (" + HospDesc + ")" + wkfldesc;
			break;
		default:
			desc = t['SSUSR'] + " (" + session["LOGON.USERNAME"] + ")" + wkfldesc;
			break;
	}
	return desc;
}
function SetOrgFavSaveAs(type) {
	objType.value=type;
	var obj=document.getElementById('SaveContextAs');
	if (obj) obj.innerText=GetDesc(type);
	
	var obj=document.getElementById('SaveContextAsDesc');
	if (obj) obj.innerText=GetDesc1(type);
}

function OEOrderPrefTabsEditList_BodyLoadHandler() {
	//run this initially to set correct settings, especially when page is re-displayed upon error.
	SetOrgFavSaveAs(objType.value);

	var obj=document.getElementById("update1");
	if (obj) obj.onclick=UpdateItems;
	if (tsc['update1']) websys_sckeys[tsc['update1']]=UpdateItems;
	var obj=document.getElementById("TabDelete");
	if (obj) obj.onclick=TabItemsDelete;
	if (tsc['TabDelete']) websys_sckeys[tsc['TabDelete']]=TabItemsDelete;
	var obj=document.getElementById("TabUp");
	if (obj) obj.onclick=TabItemsMoveUp;
	if (tsc['TabUp']) websys_sckeys[tsc['TabUp']]=TabItemsMoveUp;
	var obj=document.getElementById("TabDown");
	if (obj) obj.onclick=TabItemsMoveDown;
	if (tsc['TabDown']) websys_sckeys[tsc['TabDown']]=TabItemsMoveDown;
	var obj=document.getElementById("TabEdit");
	if (obj) obj.onclick=TabEditClickHandler;
	if (tsc['TabEdit']) websys_sckeys[tsc['TabEdit']]=TabEditClickHandler;
	
	//控制组件左上角菜单的可操作属性,仅当前可操作的菜单是可点击的
	//ContralMenuEnable();
}
document.body.onload=OEOrderPrefTabsEditList_BodyLoadHandler;

function ContralMenuEnable() {
	var obj=document.getElementById("MenuAuthOrderOrgFavId");
	if (obj) {
		var MenuAuthOrderOrgFavId=obj.value;
		//如果找不到对应的组件菜单,则不处理
		if (MenuAuthOrderOrgFavId=="") return;
		var LinkTagAry=document.getElementsByTagName("a");
		for (var i=0;i<LinkTagAry.length;i++) {
			if (LinkTagAry[i].id.indexOf('tbM')!=-1) {
				if (LinkTagAry[i].id.split('tbM')[1]!=MenuAuthOrderOrgFavId) LinkTagAry[i].innerHTML="";
			}
		}
	}
}
function SaveContextWorkflowSelectHandler() {
	/*if (cbxSaveWkfl.checked){
		cbxSaveWkfl.checked=false
	}else{
		cbxSaveWkfl.checked=true
	}*/
	SetOrgFavSaveAs(objType.value);
}

function UpdateItems() {
	if ((objType.value!="U")&&(objType.value!="L")){
		alert("目前只支持保存为个人或科室,请重新选择保存参数!")
		return false;
	}
	for (var j=0; j<lstTabs.options.length; j++) {
		desc=lstTabs.options[j].text;
		if (desc!="") {
			lstTabs.options[j].value = desc + tabgroupDelim + lstTabs.options[j].value;
			lstTabs.options[j].selected = true;
		}
	}
	if (window.opener) {
		document.getElementById('OEWIN').value=window.opener.name;
		document.getElementById('PREFTAB').value=1;
	}
	return update1_click();
}
window.onbeforeunload = DocumentUnloadHandler;
function DocumentUnloadHandler(){
	if (window.opener) {
		window.opener.OEPrefChangeHandel(objType.value);
	}
}
function TabItemsDelete() {
	if (lstTabs) ClearSelectedList(lstTabs);
	return false;
}
function TabItemsMoveUp() {
	for (var j=1; j<lstTabs.options.length; j++) {
		if ((lstTabs.options[j].selected)&&(!lstTabs.options[j-1].selected)) Swap(lstTabs,j,j-1);
	}
	return false;
}
function TabItemsMoveDown() {
	var max = lstTabs.options.length-1;
	for (var j=max; j>=0; j--) {
		if ((lstTabs.options[j].selected)&&(!lstTabs.options[j+1].selected)) Swap(lstTabs,j,j+1);
	}
	return false;
}

function TabAddItem() {
	AddItemSingle(lstTabs,"",fldAddTab.value);
	lstTabs.selectedIndex = -1;
	lstTabs.options[lstTabs.options.length-1].selected = true;
	fldAddTab.value="";
}

function TabEditClickHandler(evt) {
	if (!lstTabs) return false;
	if ((fldAddTab)&&(fldAddTab.value!="")) TabAddItem();
/**********
//can't use "get" data submission due to length of data, must use form "post" method
	//var lnk=document.getElementById("TabEdit");
	var lnk=websys_getSrcElement();
	if (lnk.tagName=="IMG") lnk=websys_getParentElement(lnk);
	var arrlnk=lnk.href.split('?');
	var url=arrlnk[0]+"?TWKFL=&TWKFLI=&"+arrlnk[1]; //reset workflow to display tab edit screen
	if (lstTabs) {
		var selecteditm=lstTabs.selectedIndex;
		if (selecteditm==-1) { alert(t['noTabSelected']); return false; }
		KeepOneItemSelected();
		url += "&TABDESC="+lstTabs.options[selecteditm].text;
		url += "&TABITEMS="+escape(lstTabs.options[selecteditm].value);
		websys_createWindow(url,"ORDERFAVPANEL","width=600,height=440,scrollbars=1,resizable=1");
	}
*********/
	var selecteditm=lstTabs.selectedIndex;
	if (selecteditm==-1) { alert(t['noTabSelected']); return false; }
	KeepOneItemSelected();
	var editform=document.forms['custom_OEOrderPrefTabsEditList_TabEdit'];
	editform.elements['TABDESC'].value=lstTabs.options[selecteditm].text;
	editform.elements['TABITEMS'].value=lstTabs.options[selecteditm].value; //escape(lstTabs.options[selecteditm].value);
	//websys_createWindow('',"ORDERFAVPANEL","width=900,height=600,scrollbars=1,resizable=1");
	editform.submit();
	return false;
}

function TabAddBlurHandler(evt) {
	if (fldAddTab.value=="") return;
	var obj=document.getElementById("TabEdit");
	if (obj) obj.click();
}

function KeepOneItemSelected() {
	var firstselected=lstTabs.selectedIndex;
	if (firstselected==-1) return;
	for (var j=firstselected+1; j<lstTabs.options.length; j++) {
		if (lstTabs.options[j].selected) lstTabs.options[j].selected=false;
	}
}

function CTLOCSelectHandler() {
	if (objType.value=="L") SetOrgFavSaveAs(objType.value);
}
function CTLOCChangeHandler() {
	if (objCTLOC.value=="") CTLOCSelectHandler();
	if (brokerCTLOC) brokerCTLOC();
}