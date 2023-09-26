var SelectedRow = 0;
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	FillData();
	KeyUp("Equip");
	Muilt_LookUp("Equip");
	SetEnabled();
	
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

function BDelete_Click() //删除
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") 
	{
	alertShow(t["02"])
	return;
	}
	var result=cspRunServerMethod(encmeth,'','',rowid,'1');
	result=result.replace(/\\n/g,"\n")
	if (result>0) 
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipBenefitEvaluate'
	} 
	else
	{
		alertShow("删除失败");
	}
		
}
function BUpdate_Click() //修改
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n")
	if(result=="") 
	{
	alertShow(t["03"]);
	return
	}
	if (result>0) 
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipBenefitEvaluate&RowID='+result;
	} 
	else
	{
		alertShow("更新失败");
	}	
}
function BAdd_Click() //添加
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var plist=CombinData(); //函数调用
	var result=cspRunServerMethod(encmeth,'','',plist);
	result=result.replace(/\\n/g,"\n");
	if(result=="")
	{
		alertShow(t["03"])
		return
	}
	if (result>0) 
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQEquipBenefitEvaluate&RowID='+result;
	} 
	else
	{
		alertShow("新增失败");
	}
}

function CombinData()
{
	var combindata="";
    combindata=GetElementValue("RowID") ;//
    combindata=combindata+"^"+GetElementValue("EquipDR") ;//设备
    combindata=combindata+"^"+GetElementValue("Year") ;//年
	combindata=combindata+"^"+GetElementValue("Material");
	combindata=combindata+"^"+GetElementValue("OperatorCount");
	combindata=combindata+"^"+GetElementValue("MedicalItem");
	combindata=combindata+"^"+GetElementValue("YearRunTime");
	combindata=combindata+"^"+GetElementValue("FeeOfEmployee");
	combindata=combindata+"^"+GetElementValue("UsePerMonthNum");
	combindata=combindata+"^"+GetElementValue("WorkLoadPerMonthNum");
	combindata=combindata+"^"+GetElementValue("ReclaimYearsNum");
	combindata=combindata+"^"+GetElementValue("UseRate");
	combindata=combindata+"^"+GetElementValue("GoodRate");
	combindata=combindata+"^"+GetElementValue("YearIncomeFee");
	combindata=combindata+"^"+GetElementValue("CostFee");
	combindata=combindata+"^"+GetElementValue("YearMaintFee");
	combindata=combindata+"^"+GetElementValue("ClinicEffect");
	combindata=combindata+"^"+GetElementValue("ResoureState");
	combindata=combindata+"^"+GetElementValue("WaterPerMonthNum");
	combindata=combindata+"^"+GetElementValue("ElectricityPerMonthNum");
	combindata=combindata+"^"+GetElementValue("ComeIncreaseRate");
	combindata=combindata+"^"+GetElementValue("OutIncreaseRate");
	//combindata=combindata+"^"+GetElementValue("Hold1");
	//combindata=combindata+"^"+GetElementValue("Hold2");
	//combindata=combindata+"^"+GetElementValue("Hold3");
	//combindata=combindata+"^"+GetElementValue("Hold4");
	//combindata=combindata+"^"+GetElementValue("Hold5");
  	return combindata;
}
	
function FillData()
{
	var obj=document.getElementById("RowID");
	if (obj) var RowID=obj.value;
	if (RowID=="") return;
	var encmeth=GetElementValue("filldata");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',RowID);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	SetElement("RowID",list[0]); //rowid
	SetElement("EquipDR",list[1]);
	SetElement("Year",list[2]);
	SetElement("Material",list[3]);
	SetElement("OperatorCount",list[4]);
	SetElement("MedicalItem",list[5]);
	SetElement("YearRunTime",list[6]);
	SetElement("FeeOfEmployee",list[7]);
	SetElement("UsePerMonthNum",list[8]);
	SetElement("WorkLoadPerMonthNum",list[9]);
	SetElement("ReclaimYearsNum",list[10]);
	SetElement("UseRate",list[11]);
	SetElement("GoodRate",list[12]);
	SetElement("YearIncomeFee",list[13]);
	SetElement("CostFee",list[14]);
	SetElement("YearMaintFee",list[15]);
	SetElement("ClinicEffect",list[16]);
	SetElement("ResoureState",list[17]);
	SetElement("WaterPerMonthNum",list[18]);
	SetElement("ElectricityPerMonthNum",list[19]);
	SetElement("ComeIncreaseRate",list[20]);
	SetElement("OutIncreaseRate",list[21]);
	SetElement("Hold1",list[22]);
	SetElement("Hold2",list[23]);
	SetElement("Hold3",list[24]);
	SetElement("Hold4",list[25]);
	SetElement("Hold5",list[26]);	
	SetElement("Equip",list[27]);
	SetElement("EquipNo",list[28]);
}
function SetEnabled()
{
	var RowID=GetElementValue("RowID");
	if (RowID!="")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BUpdate",false);
		DisableBElement("BDelete",false);
	}
	else
	{
		DisableBElement("BAdd",false);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
	}
}
function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
function GetEquip(value)
{
	var list=value.split("^")
	SetElement('Equip',list[0]);
	SetElement('EquipDR',list[1]);
	SetElement('EquipNo',list[3]);
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
