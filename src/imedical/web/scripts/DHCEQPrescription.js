var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo(); //系统参数
	InitEvent();	
	disabled(true);//灰化
	KeyUp("SourceType^Hospital^EquipType^Action");	//清空选择
	Muilt_LookUp("SourceType^Hospital^EquipType^Action");
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
	var obj=document.getElementById("BFind");
	if (obj) obj.onclick=BFind_Click;
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
	combindata=combindata+"^"+GetElementValue("SourceTypeDR") ;
  	combindata=combindata+"^"+GetElementValue("HospitalDR") ;
  	combindata=combindata+"^"+GetElementValue("EquipTypeDR") ; //Modified by HHM 20150914 HHM0018
  	combindata=combindata+"^"+GetElementValue("ActionDR") ;
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
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,plist,"");
	if ((result=="")||(result<0))
	{
		alertShow(t[result]);
		//alertShow(t[-3001]);
		return
	}
	if (result>0) 
	{
		alertShow("保存成功！") //add by lmm 2018-03-06 522898
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
		alertShow(t[-3001])
		return;
	}
	var result=cspRunServerMethod(encmeth,rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		alertShow("删除成功！") //add by lmm 2018-03-06 522980
		location.reload();	
	}
}
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQPrescription');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	
	{
		Clear();
		disabled(true);//灰化	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
	}
	else
	{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		disabled(false);//反灰化
	}
}
function Clear()
{
	SetElement("RowID","")
	SetElement("SourceType",""); 
	SetElement("SourceTypeDR","");
	SetElement("Hospital","");
	SetElement("HospitalDR","");
	SetElement("EquipType","");
	SetElement("EquipTypeDR","");
	SetElement("Action","");
	SetElement("ActionDR","");
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
	SetElement("RowID",list[9])
	SetElement("SourceType",list[10]); 
	SetElement("SourceTypeDR",list[0]);
	SetElement("Hospital",list[11]); 
	SetElement("HospitalDR",list[1]);
	SetElement("EquipType",list[12]); 
	SetElement("EquipTypeDR",list[2]);
	SetElement("Action",list[13]); 
	SetElement("ActionDR",list[3]);
	SetElement("Hold1",list[4]);
	SetElement("Hold2",list[5]);
	SetElement("Hold3",list[6]);
	SetElement("Hold4",list[7]);
	SetElement("Hold5",list[8]);
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
	var obj=document.getElementById("SourceTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
function GetHospital(value) 
{
	var obj=document.getElementById("HospitalDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
function GetEquipType(value) 
{
	var obj=document.getElementById("EquipTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
function GetAction(value) 
{
	var obj=document.getElementById("ActionDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
}
function BFind_Click()
{
	var val="";
	val=val+"&SourceTypeDR="+GetElementValue("SourceTypeDR");
	val=val+"&HospitalDR="+GetElementValue("HospitalDR");
	val=val+"&EquipTypeDR="+GetElementValue("EquipTypeDR");
	val=val+"&ActionDR="+GetElementValue("ActionDR");
	val=val+"&SourceType="+GetElementValue("SourceType");//增加四个传入值 需求号：264589  add by MWZ 2016-09-29 begin
	val=val+"&Hospital="+GetElementValue("Hospital");
	val=val+"&EquipType="+GetElementValue("EquipType");
	val=val+"&Action="+GetElementValue("Action");// end 2016-09-29
	window.location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQPrescription"+val;
}
document.body.onload = BodyLoadHandler;
