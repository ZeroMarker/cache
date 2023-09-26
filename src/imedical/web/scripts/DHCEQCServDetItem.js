//Modefied by zc 2014-09-10  zc0005
//代码和描述为必填项?只需判断是否为空就可以
// DHCEQCServDetItem.js
var SelectedRow = 0;
var SelectRow = 0;
var rowid=0;
var rows;

function BodyLoadHandler()
{
	InitUserInfo();
	InitButton(false);
}

function InitButton(isselected)
{
	var obj=document.getElementById("BClose");
	if (obj) obj.onclick=BClose_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=Clear;
	
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;	
	var obj=document.getElementById("ExType");
	if (obj) obj.onchange=ExType_change;
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;    ///modify by lmm 353624
	
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
	EnableUnit();
}

function BAdd_Click()
{
	if (CheckSaveData()) return;
	SaveData(0);
}

function BUpdate_Click() 
{
	if (CheckSaveData()) return;
	SaveData(0);
}

function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		alertShow(t['04']);
		return;
	}
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
    SaveData(1);
}
function ExType_change()
{
	SetElement("ExTypeDR",GetElementValue("ExType"));
}

function BClose_Click()
{
	window.close();
}

function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCServDetItem"+val;
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	//+组件名 就是你的组件显示 Query 结果的部分
	var objtbl =document.getElementById('tDHCEQCServDetItem');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)
	{
		Clear();	
		InitButton(false);	//灰化
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);		//调用函数
		InitButton(true);
	}
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var sort=14
	var list=gbldata.split("^");
	//alertShow(gbldata);
	SetElement("RowID",list[0]); //rowid
	SetElement("Desc",list[1]);
	SetElement("Code",list[2]);
	SetElement("UnitDR",list[3]);
	SetElement("Unit",list[sort+1]);
	SetElement("Price",list[4]);
	SetElement("ExType",list[5]);
	
	SetElement("ExID",list[6]);
	SetElement("Remark",list[7]);
	SetChkElement("ImportFlag",list[8]);
	SetElement("MinMinutes",list[9]);
	SetElement("MinutesPerTimes",list[10]);
	SetElement("MaxMinutes",list[11]);
	SetElement("UpdateDate",list[13]);
	SetElement("ExDesc",list[14]);
	///EnableModel()
}
function SaveData(isDel)
{
	var encmeth=GetElementValue("GetUpdate");
	var plist=CombinData();	
	//alertShow(plist);
	if (encmeth=="")
	{
		alertShow(t[-4001]);
		return;
	}
	var result=cspRunServerMethod(encmeth,'','',plist,isDel);
	if (result>0)
	{	location.reload();	}
}
function CombinData()
{
	var combindata="";
	combindata=GetElementValue("RowID");
  	combindata=combindata+"^"+GetElementValue("Desc");
  	combindata=combindata+"^"+GetElementValue("Code");
  	combindata=combindata+"^"+GetElementValue("UnitDR");
  	combindata=combindata+"^"+GetElementValue("Price");			//5
  	combindata=combindata+"^"+GetElementValue("ExTypeDR");
  	combindata=combindata+"^"+GetElementValue("ExID");
  	combindata=combindata+"^"+GetElementValue("Remark");
  	combindata=combindata+"^"+GetChkElementValue("ImportFlag");
  	combindata=combindata+"^"+GetElementValue("MinMinutes");	//10
  	combindata=combindata+"^"+GetElementValue("MinutesPerTimes");
  	combindata=combindata+"^"+GetElementValue("MaxMinutes");
  	combindata=combindata+"^"+GetElementValue("ExDesc");

  	return combindata;
}
function EnableUnit()
{
	//alertShow(GetElementValue("ExType"));
	// Lis,other
	if ((GetElementValue("ExType")==1)||(GetElementValue("ExType")==""))
	{
		DisableElement("ExID",false);
		DisableElement("ExDesc",true);
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iExDesc").style.visibility="hidden";
	}
	// His
	if (GetElementValue("ExType")==2)
	{
		DisableElement("ExID",true);
		DisableElement("ExDesc",false);
		document.getElementById("ld"+GetElementValue("GetComponentID")+"iExDesc").style.visibility="";
	}
	SetElement("ExTypeDR",GetElementValue("ExType"))
}
function ExType_change()
{
	EnableUnit();
	SetElement("ExID","");
	SetElement("ExDesc","");
}

function GetExDesc(value)
{
	//alertShow(value)
	var list=value.split("^");
	SetElement("ExID",list[1]);
	SetElement("ExDesc",list[0]);
}
function Clear()
{
	SetElement("RowID","");
	SetElement("Desc","");
	SetElement("Code","");
	SetElement("Price","");
	SetElement("UnitDR","");
	SetElement("Unit","");
	SetElement("ExType","");
	SetElement("ExTypeDR","");
	SetElement("ExID","");
	SetElement("MinutesPerTimes","");
	SetElement("ExDesc","");
	SetElement("MinMinutes","");
	SetElement("MaxMinutes","");
	SetElement("Remark","");
	SetChkElement("ImportFlag",0);
	InitButton(false);
}
function CheckSaveData()
{
	if (CheckMustItemNull()) return true;
	
	//if (GetElementValue("Code")=="") return true;
	//if (GetElementValue("Desc")=="") return true;
	//Mozy0049	2011-3-30
	if (IsValidateNumber(GetElementValue("Price"),1,1,0,1)==0)
	{
		alertShow("单价数据异常,请修正.");
		return true;
	}
	return false;
}
document.body.onload = BodyLoadHandler;
