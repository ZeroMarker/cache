//装载页面  函数名称固定
function BodyLoadHandler() {
	hidePanelTitle(); //added by LMH 20230211 UI 极简组件界面弹框面板标题隐藏
	initPanelHeaderStyle(); //added by LMH 20230211 UI 极简组件界面标题格式
	showBtnIcon('BAdd^BUpdate^BDelete',false); //modified by LMH 20230211 动态设置是否极简显示按钮图标
	initButtonColor(); //added by LMH 20230211 UI 初始化按钮颜色
	initButtonWidth();///Add By QW 2018-08-31 HISUI改造:修改按钮长度
	setButtonText();///Add By QW 2018-09-29 HISUI改造:按钮文字规范
	InitPage();
	ChangeStatus(false);
	InitUserInfo();
	// MZY0094	2094508		2021-09-13
	var ApproveSet=tkMakeServerCall("web.DHCEQCApproveSet","GetOneApproveSet",GetElementValue("ApproveSetDR"));
	var Detail=ApproveSet.split("^");
	document.getElementById("cEQTitle").innerHTML = "设备审批流: "+Detail[1];
}

function InitPage(){
	var BAobj=document.getElementById("BAdd");
	if (BAobj) BAobj.onclick=BUpdate_click;
	var BUobj=document.getElementById("BUpdate");
	if (BUobj) BUobj.onclick=BUpdate_click;
	var BDobj=document.getElementById("BDelete");
	if (BDobj) BDobj.onclick=BDelete_click;
	var BDobj=document.getElementById("BClose");
	if (BDobj) BDobj.onclick=BClose_click;
	KeyUp("ConditionFields");
	Muilt_LookUp("ConditionFields");	
}
//点击表格项填充自由项,函数名称固定
///Modify By QW 2018-08-31 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
var SelectedRow = -1;
function SelectRowHandler(index,rowdata)	{
    if(index==SelectedRow)
    {
		SetElement("RowID","");
		Fill("^^^^^^^^^^^")
		SelectedRow=-1;
		ChangeStatus(false);
		$('#tDHCEQCApproveCondition').datagrid('unselectAll');
		return;
	 }
	ChangeStatus(true);
	FillData(rowdata.TRowID)
	SelectedRow = index
}
///Modify By QW 2018-08-31 HISUI改造：点击选择行后，界面无法正常填充数据
///修改FillData方法的传入参数
function FillData(RowID)
{
	SetElement("RowID",RowID);
	var obj=document.getElementById("fillData");
	if (obj){var encmeth=obj.value} else {var encmeth=""};
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	Fill(ReturnList)
}
function Fill(ReturnList)
{
	list=ReturnList.split("^");
	SetElement("ApproveSetDR",list[0]);
	SetElement("ConditionFieldsDR",list[1]);
	SetElement("Value",list[2]);
	SetElement("ToValue",list[3]);
	SetElement("ConditionFields",list[9]);
	SetElement("TableName",list[10]);
	SetElement("Type",list[11]);
	//Add By QW20210607 BUG:QW0119 需求号:1944805 begin
	if (GetElementValue("Type")=="0")
	{
		ReadOnlyElement("ToValue",true)
	}
	else
	{
		ReadOnlyElement("ToValue",false)
	}
	//Add By QW20210607 BUG:QW0119 end
}
function BClose_click()
{
	//Modified By QW20181026 需求号:723859 关闭模态窗口,window.close()不起作用;
	websys_showModal("close");  
}
//更新按钮点击函数
function BUpdate_click()
{
	if (CheckNull()) return;
	var val=GetValue();
	var Return=UpdateData(val,"0");
	if (Return!=0)
	{
		window.location.reload();
	}
	else
	{
		messageShow("","","",Return+"  "+t["01"]);
	}
}
function GetValue()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("ApproveSetDR") ;
  	combindata=combindata+"^"+GetElementValue("ConditionFieldsDR") ;
  	combindata=combindata+"^"+GetElementValue("Value") ;
  	combindata=combindata+"^"+GetElementValue("ToValue") ;
  	return combindata;
}
//删除按钮点击函数
function BDelete_click()
{
	var truthBeTold = window.confirm(t["02"]);
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
	var Return=UpdateData(RowID,"1");
	if (Return<0)
	{
		messageShow("","","",Return+"  "+t["01"]);
	}
	else
	{
		window.location.reload();
	}
}
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	return false;
}
function UpdateData(val,AppType)
{
	var encmeth=GetElementValue("upd");
	var Return=cspRunServerMethod(encmeth,val,AppType);
	return Return;
}

function GetConditionFields(value) 
{
	var list=value.split("^");
	SetElement("ConditionFieldsDR",list[0]);
	SetElement("ConditionFields",list[1]);
	SetElement("TableName",list[2]);  //Add By QW20210607 BUG:QW0119 需求号:1944805
	SetElement("Type",list[3]);
	if (GetElementValue("Type")==0)
	{
		ReadOnlyElement("ToValue",true)
	}
	else
	{
		ReadOnlyElement("ToValue",false)
	}
}
function ChangeStatus(Value)
{
	InitPage();
	DisableBElement("BUpdate",!Value);
	DisableBElement("BDelete",!Value);
	DisableBElement("BAdd",Value);
}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
