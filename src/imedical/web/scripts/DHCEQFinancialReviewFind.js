var SelectedRow=0;
var rowid=0;
var readonly;
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();
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
	var equiptypeinfos=GetElementValue("EquipTypeInfos");
	var obj=document.getElementById("EquipType");
	var equiptypelist=equiptypeinfos.split("&");
	var typeids=GetElementValue("EquipTypeIDs");
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
	SetElement("EquipTypeIDs",typeids);
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
	var BussinessType=GetElementValue("BussinessType");
	SetElement("BussinessTypeDR",BussinessType);
}
function SetBussinessType()
{
	SetElement("BussinessType",GetElementValue("BussinessTypeDR"));
}
function BFind_Click()
{
	var BussinessNo=GetElementValue("BussinessNo");
	var BussinessTypeDR=GetElementValue("BussinessTypeDR");
	var EquipTypeIDs=GetElementValue("EquipTypeIDs");
	var Month=GetElementValue("Month");
	var TMENU=GetElementValue("TMENU");
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQFinancialReviewFind&BussinessNo='+BussinessNo+"&EquipTypeIDs="+EquipTypeIDs+"&BussinessTypeDR="+BussinessTypeDR+"&Month="+Month+"&TMENU="+TMENU;
}
document.body.onload = BodyLoadHandler;