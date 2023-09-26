//设备折旧设置表查询
var SelectedRow = 0;
var rowid=0;
function BodyLoadHandler() 
{
	document.body.scroll="no";
	KeyUp("EquipName^DepreMethod")	
	Muilt_LookUp("EquipName^DepreMethod");
	var obj=document.getElementById("BFind");//查找
	if (obj) obj.onclick=BFind_Click;
	var obj=document.getElementById("BAdd");//更新
	if (obj) obj.onclick=BAdd_Click;
	//RowidLink();//rowid连接
}

function BAdd_Click()
{
	parent.location.href="dhceqdepreset.csp";
}
function BFind_Click()
{
var DepreMethodDR=GetElementValue("DepreMethodDR")
var EquipNameDR=GetElementValue("EquipNameDR")
parent.frames["DHCEQDepreSetList"].location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSetList&EquipNameDR='+EquipNameDR+'&DepreMethodDR='+DepreMethodDR;
//parent.ocation.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQDepreSetList&EquipNameDR='+EquipNameDR+'&DepreMethodDR='+DepreMethodDR;
	}
///选择表格行触发此方法
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQDeviceMap');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		document.all["BAdd"].style.display="inline";
		Clear();	
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		document.all["BAdd"].style.display="none";//隐藏
		SelectedRow=selectrow;
		rowid=GetCElementValue("TRowIDz"+SelectedRow);
		SetData(rowid);//调用函数
		}
}
function Clear()
{
	SetElement("Omdr",""); 
	SetElement("Uomtype","");
	}
function SetData(rowid)
{
	var encmeth=GetElementValue("GetData");
	if (encmeth=="")return;var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	var list=gbldata.split("^");
	//alertShow("list"+list);
	SetElement("RowID",list[0]); //rowid
	SetElement("Equip",list[1]); //设备
	SetElement("Device",list[2]);//仪器
	SetElement("DeviceSource",list[3]);//设备来源
	SetElement("Remark",list[4]);//备注
	SetElement("AddUser",list[5]);//新增人
	SetElement("AddDate",list[6]);//新增日期
	SetElement("AddTime",list[7]);//新增时间
	SetElement("UpdateUser",list[8]);//更新人
	SetElement("UpdateDate",list[9]);//更新日期
	SetElement("UpdateTime",list[10]);//更新时间
}
function EquipNameDR(value)//设备名称
{
	//alertShow(value);
	var obj=document.getElementById("EquipNameDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
}
function DepreMethodDR(value)//折旧方法
{
	//alertShow(value);
	var obj=document.getElementById("DepreMethodDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1])
}
document.body.onload = BodyLoadHandler;