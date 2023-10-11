var SelectedRow=0;
var rowid=0;
var readonly;
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();
	initButtonWidth()
	initButtonColor();//cjc 2023-01-18 设置极简积极按钮颜色
	initPanelHeaderStyle();//cjc 2023-01-17 初始化极简面板样式
	
	//add by cjc 20230208管理类组输入框宽度
	document.getElementById("EquipType").classList.add("textbox");
	document.getElementById("EquipType").style.width='';
}

function InitPage()
{
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("EquipType");
	if (obj) obj.onchange=EquipType_Change;
	var obj=document.getElementById("BussinessType");
	if (obj) obj.onchange=BussinessType_Change;
	FillEquipType();
	SetBussinessType();
}

function FillEquipType()
{
	var equiptypeinfos=getElementValue("EquipTypeInfos");
	var obj=document.getElementById("EquipType");
	var equiptypelist=equiptypeinfos.split("&");
	var typeids=getElementValue("EquipTypeIDs");
	if (typeids!="") typeids=","+typeids+",";
	for (var i=0;i<equiptypelist.length;i++)
	{
		var list=equiptypelist[i].split("^");
		obj.options.add(new Option(list[1],list[13],true,true));
		if (typeids.indexOf(","+list[13]+",")>-1)
		{	obj.options[i].selected=true;
		}
		else
		{	obj.options[i].selected=false;	}
	}	
}

function EquipType_Change()
{
	var typeids=GetSelectedEquipType(1);
	setElement("EquipTypeIDs",typeids);
}

function GetSelectedEquipType(type)
{
	var typeids="";
	var obj=document.getElementById("EquipType");
	for (var i=0;i<obj.options.length;i++)
	{
		if (obj.options[i].selected!=true) continue;
		if (typeids!="") typeids=typeids+",";
		if (type==1)
		{	typeids=typeids+obj.options[i].value;}
		else
		{	typeids=typeids+obj.options[i].text;}
	}
	return typeids;
}
function BussinessType_Change()
{
	var BussinessType=getElementValue("BussinessType");
	setElement("BussinessTypeDR",BussinessType);
}
function SetBussinessType()
{
	setElement("BussinessType",getElementValue("BussinessTypeDR"));
}
function BFind_Click()
{
	var BussinessNo=getElementValue("BussinessNo");
	var BussinessTypeDR=getElementValue("BussinessType");
	var EquipTypeIDs=getElementValue("EquipTypeIDs");
	var Month=getElementValue("Month");
	var TMENU=getElementValue("TMENU");
	var url='websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQFinancialReviewFind&BussinessNo='+BussinessNo+"&EquipTypeIDs="+EquipTypeIDs+"&BussinessTypeDR="+BussinessTypeDR+"&Month="+Month+"&TMENU="+TMENU;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;
}
document.body.onload = BodyLoadHandler;
