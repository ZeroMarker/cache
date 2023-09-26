//设备医嘱项对照表
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{	
    InitUserInfo();
	InitEvent();
	KeyUp("Equip^OrderItem");
	Muilt_LookUp("Equip^OrderItem");	
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
function BDelete_Click() 
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t[-4003]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)location.reload();	
}
function BUpdate_Click() 
{
	if (condition()) return;
var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(!result)alertShow(t[-3001])
	if (result>0)location.reload();	
}
function BAdd_Click() //增加
{
	if (condition()) return;
var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="")return;
	var plist=CombinData(); //函数调用
	//alertShow("plist:"+plist);
	var result=cspRunServerMethod(encmeth,'','',plist,'2');
	result=result.replace(/\\n/g,"\n")
	if(!result)alertShow(t[-3001])
	if (result>0)location.reload();	
}	
	function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//1
	combindata=combindata+"^"+GetElementValue("EquipDR") ;//结果
  	combindata=combindata+"^"+GetElementValue("OrderItemDR") ; //仪器
  	combindata=combindata+"^"+GetElementValue("Remark") ; //
  	combindata=combindata+"^"+curUserID;//审核人5
  	return combindata;
}

///选择表格行触发此方法
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQOrderItemMap');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		//document.all["BAdd"].style.display="inline";
		Clear();
		disabled(true)//灰化		
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		//document.all["BAdd"].style.display="none";//隐藏
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		//SetElement("RowID",rowid);
		SetData(rowid);//调用函数
		disabled(false)//反灰化
		}
}
function Clear()
{
	SetElement("Equip",""); //设备
	SetElement("OrderItem","");//仪器
	SetElement("Remark","");//备注
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n");
	var list=gbldata.split("^");
	//alertShow("list"+list);
	var sort=14
	SetElement("RowID",list[0]); //rowid
	SetElement("Equip",list[1]); //设备1
	SetElement("OrderItem",list[2]);//仪器2
	SetElement("Remark",list[3]);//备注3
	SetElement("EquipDR",list[4]); //设备4
	SetElement("OrderItemDR",list[5]); //医嘱项代码5
}
function EquipDR(value)//设备名称
{
	//alertShow(value);
	var obj=document.getElementById("EquipDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
}
function OrderItemDR(value)//设备名称
{
	//alertShow(value);
	var obj=document.getElementById("OrderItemDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
}
function disabled(value)//反灰化
{
	InitEvent();
	DisableBElement("BUpdate",value)
	DisableBElement("BDelete",value)	
	DisableBElement("BAdd",!value)
}	
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	/*
	if (CheckItemNull(1,"Equip")) return true;
	if (CheckItemNull(1,"OrderItem")) return true;
	*/
	return false;
}
document.body.onload = BodyLoadHandler;