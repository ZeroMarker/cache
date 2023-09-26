/* 调整 科室 下拉框高度，避免遮挡，可用此复写 gen目录下的 2015-8-5 jdl

function UseLoc_lookuphandler(e) {
	if (evtName=='UseLoc') {
		window.clearTimeout(evtTimer);
		evtTimer='';
		evtName='';
	}
	var type=websys_getType(e);
	var key=websys_getKey(e);
	if ((type=='click')||((type=='keydown')&&(key==117))) {
		var url='websys.lookup.csp';
		url += '?ID=d51154iUseLoc&CONTEXT=Kweb.DHCEQFind:GetEQLoc&TLUDESC='+encodeURI(t['UseLoc']);
		url += "&TLUJSF=GetUseLocID";
		var obj=document.getElementById('QXType');
		if (obj) url += "&P1=" + websys_escape(obj.value);
		var obj=document.getElementById('UseLoc');
		if (obj) url += "&P2=" + websys_escape(obj.value);
		websys_lu(url,1,{height:160});
		return websys_cancel();
	}
}
var obj=document.getElementById('UseLoc');
if (obj) obj.onkeydown=UseLoc_lookuphandler;
var obj=document.getElementById('ld51154iUseLoc');
if (obj) obj.onclick=UseLoc_lookuphandler;

var SelectedRow=0;
var rowid=0;
function BodyLoadHandler() 
{
	InitPage();
}

///初始化页面
function InitPage()
{
	document.body.scroll="no";
	
	var obj=document.getElementById("Model");
	if (obj) obj.onkeyup=Standard_KeyUp;
	
	var obj=document.getElementById("UseLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	
	var obj=document.getElementById("ManageLoc");
	if (obj) obj.onkeyup=Standard_KeyUp;
	
	var obj=document.getElementById("StatusDisplay");
	if (obj) obj.onkeyup=StatusDisplay_KeyUp;
	
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
}

function StatusDisplay_KeyUp()
{
	var obj=document.getElementById("Status");
	if (obj) obj.value=""
}

function BAdd_Click()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquip";
	parent.location.href=lnk;
}

function BFind_Click()
{
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipList";
	lnk=lnk+"&No="+GetElementValue("No");
	lnk=lnk+"&Name="+GetElementValue("Name");
	lnk=lnk+"&Code="+GetElementValue("Code");
	lnk=lnk+"&UseLocDR="+GetElementValue("UseLocDR");
	lnk=lnk+"&ManageLocDR="+GetElementValue("ManageLocDR");
	lnk=lnk+"&StoreLocDR="+GetElementValue("StoreLocDR");
	lnk=lnk+"&ModelDR="+GetElementValue("ModelDR");
	lnk=lnk+"&Status="+GetElementValue("Status");
	parent.DHCEQEquipList.location.href=lnk;
}

document.body.onload = BodyLoadHandler;
*/