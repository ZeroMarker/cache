var SelectedRow = -1;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //系统参数
    initButtonWidth()  //hisui改造 add by kdf 2018-10-18
	InitEvent();	
	disabled(true);//灰化
	KeyUp("FromAction^TimeUnit");	//清空选择
	Muilt_LookUp("FromAction^TimeUnit");
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
    combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("PRowID") ;
  	combindata=combindata+"^"+GetElementValue("FromActionDR") ;
  	combindata=combindata+"^"+GetElementValue("TimeNum") ;
  	combindata=combindata+"^"+GetElementValue("TimeUnitDR") ;
  	combindata=combindata+"^"+GetElementValue("AlarmNum") ;
  	combindata=combindata+"^"+GetChkElementValue("ActiveTimeFlag") ;
  	combindata=combindata+"^"+GetChkElementValue("ActivePreFlag") ;
  	combindata=combindata+"^"+GetElementValue("Hold1") ;
  	combindata=combindata+"^"+GetElementValue("Hold2") ;
  	combindata=combindata+"^"+GetElementValue("Hold3") ;
  	combindata=combindata+"^"+GetElementValue("Hold4") ;
  	combindata=combindata+"^"+GetElementValue("Hold5") ;
  	return combindata;
}
function BUpdate_Click() 
{
	if (condition()) return;
		var Hold1=GetElementValue("Hold1");  // add by kdf 2018-12-13 需求号：635169 begin
	var Regx = /^[0-9]*$/;
    if (!Regx.test(Hold1)) {
	    alertShow("时效检测顺序只能为数字!")
        return ;
     }									// add by kdf 2018-12-13  需求号：635169 end
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,"");
	if ((result=="")||(result<0))
	{
		messageShow("","","",t[result]);
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
		messageShow("","","",t[-3001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) location.reload();	
}
///选择表格行触发此方法
/// modified by kdf 2018-10-18 hisui-改造
function SelectRowHandler(index , rowdata)
{
	if (SelectedRow==index)	
	{
		Clear();
		disabled(true);//灰化	
		SelectedRow=-1;
		$('#tDHCEQPrescriptionList').datagrid('unselectAll');  //hisui改造 add by kdf 2018-10-17
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=index;
		rowid=rowdata.TRowID ; 
		SetData(rowid);//调用函数
		disabled(false);//反灰化
	}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("FromAction",""); 
	SetElement("FromActionDR","");
	SetElement("TimeNum","");
	SetElement("TimeUnit","");
	SetElement("TimeUnitDR","");
	SetElement("AlarmNum","");
	SetChkElement("ActiveTimeFlag","");
	SetChkElement("ActivePreFlag","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,rowid);
	var list=gbldata.split("^");
	SetElement("FromActionDR",list[1]);
	SetElement("TimeNum",list[2]);
	SetElement("TimeUnitDR",list[3]);
	SetElement("AlarmNum",list[4]);
	SetChkElement("ActiveTimeFlag",list[15]);
	SetChkElement("ActivePreFlag",list[16]);
	SetElement("Hold1",list[7]);
	SetElement("Hold2",list[8]);
	SetElement("Hold3",list[9]);
	SetElement("Hold4",list[10]);
	SetElement("Hold5",list[11]);
	SetElement("RowID",list[12])
	SetElement("FromAction",list[13]); 
	SetElement("TimeUnit",list[14]);
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
function GetTimeUnit(value) 
{
	var obj=document.getElementById("TimeUnitDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
function GetAction(value) 
{
	var obj=document.getElementById("FromActionDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}

document.body.onload = BodyLoadHandler;
