//设备机型
var SelectedRow = -1; //hisui改造 add by kdf 2018-10-17
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //系统参数
    initButtonWidth()  //hisui改造 add by kdf 2018-10-17 按钮样式修改
	InitEvent();	
	disabled(true);//灰化
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

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("Code") ;
  	combindata=combindata+"^"+GetElementValue("Desc") ;
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	return combindata;
}

function BAdd_Click()
{
	BUpdate_Click() 
}

function BUpdate_Click() 
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,"");
	if(result=="") 
	{
		messageShow("","","",t[-3001]);
		return
	}
	if (result>0)
	{
		messageShow("","","",t[0]);
		location.reload();
	}	
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		messageShow("","","",t[-3001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		messageShow("","","",t[0]);
		location.reload();	
	}
}
///选择表格行触发此方法
///modify by by kdf 2018-10-17
///描述：hisui改造 更改值获取方式 并添加入参
///入参：index 行号
///      rowdata 行json数据
function SelectRowHandler(index,rowdata)
{
	if (SelectedRow==index)	
	{
		Clear(); //add By  20150825  HHM00005
		disabled(true);//灰化	
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		$('#tDHCEQCEvaluateGroup').datagrid('unselectAll');  
	}
	else
	{
		SelectedRow=index;
		//rowid=GetElementValue("TRowIDz"+SelectedRow);
		rowid=rowdata.TRowID;
		
		SetData(rowid);//调用函数
		disabled(false);//反灰化
	}
}

//add By 20150824 HHM0005
//清空选项内容
function Clear()
{
	SetElement("Code","");
	SetElement("Desc","")
	SetElement("Remark","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("RowID",list[0])
	SetElement("Code",list[1]); 
	SetElement("Desc",list[2]);
	SetElement("Remark",list[3]);
	
}
function disabled(value)//灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
document.body.onload = BodyLoadHandler;
