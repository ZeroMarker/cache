//Modefied by zc 2014-09-10  zc0005
//代码和描述为必填项?只需判断是否为空就可以
// DHCEQCServDetItem.js
var SelectedRow = -1; ///Modify By QW 2018-10-08 HISUI改造
var SelectRow = 0;
var rowid=0;
var rows;

function BodyLoadHandler()
{
	initButtonWidth();///Add By QW 2018-10-10 HISUI改造:修改按钮长度
	setButtonText();///Add By QW 2018-10-10 HISUI改造:按钮文字规范
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
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;    ///modify by lmm 353624
	///add by QW 2018-10-08 描述：hisui改造 隐藏/放开放大镜
	$('#ExDesc').lookup('options').onBeforeShowPanel= function(){
 			return $("#ExDesc").lookup('options').hasDownArrow
	};
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
	EnableUnit();
}
///add by QW 2018-10-10
///描述：hisui改造 下拉列表onchange事件更改
 $('#ExType').combobox({
    onChange: function () {
	   ExType_change();
    }
 })
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
	///modified by ZY0215 2020-04-02
	messageShow("confirm","","",t[-4003],"",confirmFun,"")
}
///modified by ZY0215 2020-04-02
function confirmFun()
{
	rowid=GetElementValue("RowID");
	if (rowid=="")
	{
		messageShow("","","",t['04']);
		return;
	}
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
///Add By QW 2018-10-10 hisui组件调整步骤
function BFind_Click()
{
	var val="&Code="+GetElementValue("Code");
	val=val+"&Desc="+GetElementValue("Desc");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCServDetItem"+val;
}
///选择表格行触发此方法
//Modify By QW 2018-10-10 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
function SelectRowHandler(index,rowdata)
{
	if(index==SelectedRow)
    {
		Clear();	
		InitButton(false);	//灰化
		SelectedRow=-1;	
		SetElement("RowID","");
		$('#tDHCEQCServDetItem').datagrid('unselectAll');
		return;
	 }
	SelectedRow=index;
	SetData(rowdata.TRowID);//调用函数
	InitButton(true);
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var sort=14
	var list=gbldata.split("^");
	//messageShow("","","",gbldata);
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
	//messageShow("","","",plist);
	if (encmeth=="")
	{
		messageShow("","","",t[-4001]);
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
	//messageShow("","","",GetElementValue("ExType"));
	// Lis,other
	if ((GetElementValue("ExType")==1)||(GetElementValue("ExType")==""))
	{
		DisableElement("ExID",false);
		///add by QW 2018-10-10 描述：hisui改造 隐藏/放开放大镜
		$("#ExDesc").lookup({hasDownArrow:false,disable:true})
	}
	// His
	if (GetElementValue("ExType")==2)
	{
		DisableElement("ExID",true);
		///add by QW 2018-10-10 描述：hisui改造 隐藏/放开放大镜
		$("#ExDesc").lookup({hasDownArrow:true,disable:false})
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
	//messageShow("","","",value)
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
