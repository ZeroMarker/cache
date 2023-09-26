/// -------------------------------
/// 创建:ZY  2009-09-10   BugNo.:ZY0012
/// 描述:审批动作
/// --------------------------------
var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler()
{
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
		alertShow(t[-1000])
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
		alertShow(t[-1000])
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
		alertShow(t[-1000])
		return
	}
	if (result==0)location.reload();			
}

///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQCApproveAction');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;	
	var rowObj=getRow(eSrc);	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		Clear();
		disabled(true)//灰化	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false)//反灰化
		}
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
