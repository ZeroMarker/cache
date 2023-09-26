var SelectedRow = -1;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler()
{
	initButtonWidth();///Add By QW 2018-08-31 HISUI改造:修改按钮长度
	setButtonText();///Add By QW 2018-09-29 HISUI改造:按钮文字规范
	InitEvent();
	disabled(true);
}

function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
}

function BAdd_Click() //添加
{
	var encmeth=GetElementValue("upd");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n");
	if(result<0)
	{
		alertShow("当前记录已存在,操作失败!");
		return
	}
	else
	{
		location.reload();	
	}
}
function BUpdate_Click() //修改
{
	var encmeth=GetElementValue("upd");
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,'0');
	result=result.replace(/\\n/g,"\n");
	if(result<0) 
	{
		alertShow("当前记录已存在,操作失败!");
		return;
	}
	else 
	{
		location.reload();
	}
}
function BDelete_Click() //删除
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm("确定删除该记录?");
    if (!truthBeTold) return;
	var encmeth=GetElementValue("upd");
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result<0) 
	{
		alertShow("删除失败!");
		return ;
	}
	else 
	{
		location.reload();	
	}
}
function CombinData()
{
	var ApproveFlowAllowDR=GetElementValue("ApproveFlowAllowDR");
	if (ApproveFlowAllowDR=="")
	{
		alertShow("请选择审批步骤!")
		return
	}
	var combindata="";
    combindata=GetElementValue("RowID");
	combindata=combindata+"^"+GetElementValue("ApproveFlowDR");
	combindata=combindata+"^"+GetElementValue("ApproveFlowAllowDR");
	combindata=combindata+"^"+GetElementValue("Type");
  	return combindata;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
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
		$('#tDHCEQCApproveFlowAllow').datagrid('unselectAll');
		return;
	 }
	
	SelectedRow = index
	SetData(rowdata.TRowID);//调用函数
	disabled(false)//反灰化()
}

function Clear()
{
	SetElement("ApproveFlowAllowDR","");
	SetElement("ApproveFlowAllow","");
}

function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	//messageShow("","","",gbldata)
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("ApproveFlowAllowDR",list[2]); 
	SetElement("ApproveFlowAllow",list[6]); 
	
}

function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)
	DisableBElement("BAdd",!value)
}

function GetApproveFlowRole(value)
{
	var val=value.split("^");	
	//messageShow("","","",val)
	SetElement("ApproveFlowAllowDR",val[0])	
	SetElement("ApproveFlowAllow",val[2])	

}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
