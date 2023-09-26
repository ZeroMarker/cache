// DHCEQCServiceDetails.js
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
	if (obj) obj.onclick=BFind_Click;
	
	DisableBElement("BAdd",isselected);
	DisableBElement("BUpdate",!isselected);
	DisableBElement("BDelete",!isselected);
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

function BClose_Click()
{
	window.close();
}
///Add By QW 2018-10-10 hisui组件调整步骤
function BFind_Click()
{
	var val="&ServiceItem="+GetElementValue("ServiceItem");
	val=val+"&ServDetItem="+GetElementValue("ServDetItem");
	window.location.href="websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCEQCServiceDetails"+val;
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
		$('#tDHCEQCServiceDetails').datagrid('unselectAll');
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
	var sort=5
	var list=gbldata.split("^");
	//messageShow("","","",gbldata);
	SetElement("RowID",list[0]); //rowid
	SetElement("ServiceItemDR",list[1]);
	SetElement("ServiceItem",list[sort+1]);
	SetElement("ServDetItemDR",list[2]);
	SetElement("ServDetItem",list[sort+2]);
	SetElement("Quantity",list[3]);
	SetElement("Remark",list[4]);
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
  	combindata=combindata+"^"+GetElementValue("ServiceItemDR");
  	combindata=combindata+"^"+GetElementValue("ServDetItemDR");
  	combindata=combindata+"^"+GetElementValue("Quantity");
  	combindata=combindata+"^"+GetElementValue("Remark");
	
  	return combindata;
}
function Clear()
{
	SetElement("RowID","");
	SetElement("ServiceItemDR","");
	SetElement("ServiceItem","");
	SetElement("ServDetItemDR","");
	SetElement("ServDetItem","");
	SetElement("Quantity","");
	SetElement("Remark","");
	InitButton(false);
}
function GetServiceItem(value)
{
	var type=value.split("^");
	var obj=document.getElementById("ServiceItemDR");
	obj.value=type[1];
}
function GetServDetItem(value)
{
	//messageShow("","","",value);
	var type=value.split("^");
	var obj=document.getElementById("ServDetItemDR");
	obj.value=type[1];
}
function CheckSaveData()
{
	if (CheckMustItemNull()) return true;

	//if (GetElementValue("ServiceItemDR")=="") return true;
	//if (GetElementValue("ServDetItemDR")=="") return true;
	//Mozy0049	2011-3-30
	if (IsValidateNumber(GetElementValue("Quantity"),1,0,0,1)==0)
	{
		alertShow("数量异常,请修正.");
		//SetElement("Quantity","");
		return true;
	}
	return false;
}
document.body.onload = BodyLoadHandler;