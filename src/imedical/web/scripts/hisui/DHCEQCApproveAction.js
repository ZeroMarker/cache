/// -------------------------------
/// 创建:ZY  2009-09-10   BugNo.:ZY0012
/// 描述:审批动作
/// --------------------------------
var SelectedRow = -1; ///Modify By QW 2018-08-31 HISUI改造
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler()
{
	hidePanelTitle(); //added by LMH 20230211 UI 极简组件界面弹框面板标题隐藏
	initPanelHeaderStyle(); //added by LMH 20230211 UI 极简组件界面标题格式
	showBtnIcon('BAdd^BUpdate^BDelete',false); //modified by LMH 20230211 动态设置是否极简显示按钮图标
	initButtonColor(); //added by LMH 20230211 UI 初始化按钮颜色
	initButtonWidth();///Add By QW 2018-08-31 HISUI改造:修改按钮长度
	setButtonText();///Add By QW 2018-09-29 HISUI改造:按钮文字规范
	InitUserInfo();
	InitEvent();	//初始化
	disabled(true);//灰化
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}

function BAdd_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist,'0');
	result=result.replace(/\\n/g,"\n")
	if(result!=0)
	{
		messageShow("","","",t[-1000])
		return
	}
	if (result==0)location.reload();
}

function BUpdate_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(result!=0)
	{
		messageShow("","","",t[-1000])
		return
	}
	if (result==0)location.reload();	
}

function BDelete_Click()
{
	var plist=CombinData(); //函数调用
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,'','',plist,'1');
	result=result.replace(/\\n/g,"\n")
	if(result!=0)
	{
		messageShow("","","",t[-1000])
		return
	}
	if (result==0)location.reload();			
}

///选择表格行触发此方法
///Modify By QW 2018-08-31 HISUI改造：点击选择行后，界面无法正常填充数据
///解决方法传入index,rowdata两个参数，并修改判断逻辑
function SelectRowHandler(index,rowdata)
{
   if(index==SelectedRow)
    {
		Clear();
		disabled(true)//灰化	
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		$('#tDHCEQCApproveAction').datagrid('unselectAll');
		return;
	 }
	SelectedRow = index
	SetData(rowdata.TRowID);//调用函数
	disabled(false)//反灰化
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	SetElement("RowID",rowid);
	SetElement("Desc",list[0]);
	SetElement("ClassName",list[1]);
	SetElement("Method",list[2])
}

function disabled(value)//灰化
{
	InitEvent();	
	DisableBElement("BAdd",!value)
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
  	combindata=combindata+"^"+GetElementValue("Desc") ;
  	combindata=combindata+"^"+GetElementValue("ClassName") ;
  	combindata=combindata+"^"+GetElementValue("Method") ;
  	combindata=combindata+"^"+GetElementValue("StepRowID") ;
  	return combindata;
}
function Clear()
{
	SetElement("RowID","");
	SetElement("Desc","");
	SetElement("ClassName","");
	SetElement("Method","");
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;	
	return false;
}

document.body.onload = BodyLoadHandler;
