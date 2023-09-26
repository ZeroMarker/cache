var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler()
{
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
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCApproveFlowAllow');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)
	{
		Clear();	
		disabled(true)//灰化
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false)//反灰化
	}
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
	//alertShow(gbldata)
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
	//alertShow(val)
	SetElement("ApproveFlowAllowDR",val[0])	
	SetElement("ApproveFlowAllow",val[2])	

}

//定义页面加载方法
document.body.onload = BodyLoadHandler;
