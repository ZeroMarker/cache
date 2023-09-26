var SelectedRow = -1;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //系统参数
    initButtonWidth()  //hisui改造 add by kdf 2018-10-18
	InitEvent();	
	disabled(true);//灰化
	KeyUp("SourceType");	//清空选择
	Muilt_LookUp("SourceType");
}
function InitEvent()
{
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BClear");
	if (obj) obj.onclick=BClear_Click;
}
function BClear_Click() 
{
	Clear();
	disabled(true);
}
function CombinData()
{
	var combindata="";
	//add by HHM 20150914 HHM0019 
	//去除字符串前后空格
    combindata=GetElementValue("RowID") ;
    var Code=trim(GetElementValue("Code"));
    var Desc=trim(GetElementValue("Desc"));
	combindata=combindata+"^"+Code;
  	combindata=combindata+"^"+Desc;
  	//*************************************
  	combindata=combindata+"^"+GetElementValue("Remark") ;
  	combindata=combindata+"^"+GetElementValue("SourceTypeID") ;
  	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ;
  	return combindata;
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
	if (result>0) location.reload();
}
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
		messageShow("","","",t[-3002])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
///选择表格行触发此方法
// modified by kdf 2018-10-17 hisui-改造
function SelectRowHandler(index ,rowdata)
{
	if (SelectedRow==index)	
	{
		Clear();
		disabled(true);//灰化	
		SelectedRow=-1;
		$('#tDHCEQCAction').datagrid('unselectAll');  //hisui改造 add by kdf 2018-10-17
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=index;
		rowid=rowdata.TRowID;
		SetData(rowid);//调用函数
		disabled(false);//反灰化
	}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("Code",""); 
	SetElement("Desc","");
	SetElement("Remark","");
	SetElement("SourceTypeID","");
	SetElement("SourceType","");
	SetElement("InvalidFlag","");
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
	SetElement("SourceTypeID",list[4]);
	SetElement("SourceType",list[5]);
	SetChkElement("InvalidFlag",list[6]);	
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
function GetApproveType(value) 
{
	var obj=document.getElementById("SourceTypeID");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
document.body.onload = BodyLoadHandler;
