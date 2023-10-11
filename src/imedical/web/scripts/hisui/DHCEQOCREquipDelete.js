var SelectedRow = -1;	//HISUI改造 modified by czf 20180929
var rowid=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	DisableBElement("BDelete",true);
	initButtonWidth()  //hisui改造 add by czf 20180929
	initButtonColor();//cjc 2023-01-18 设置极简积极按钮颜色
	initPanelHeaderStyle();//cjc 2023-01-17 初始化极简面板样式
}

function InitEvent() //初始化
{
	//modified by ZY0303 20220615 2709599  增加院区清空处理
	// 20140410  Mozy0126
	Muilt_LookUp("Provider^EquipType^Hospital");
	KeyUp("Provider^EquipType^Hospital");
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	//add by csj 20190906 需求号：1020586
	$('#BFind').click(function(){
		if (!$(this).linkbutton('options').disabled){
			$('#tDHCEQOCREquipDelete').datagrid('load',{ComponentID:getValueById("GetComponentID"),QXType:getValueById("QXType"),Equip:getValueById("Equip"),ProviderDR:getValueById("ProviderDR"),EquipTypeDR:getValueById("EquipTypeDR"),StartDate:getValueById("StartDate"),EndDate:getValueById("EndDate"),HospitalDR:getValueById("HospitalDR")}); //Modified By QW20210629 BUG:QW0131
			SetElement("RowID","");
			DisableBElement("BDelete",true);
		}
	});
	//Add By QW20210629 BUG:QW0131 院区 begin
	var HosCheckFlag=tkMakeServerCall("web.DHCEQCommon","GetSysInfo","990051");
	if(HosCheckFlag=="0")
	{
		hiddenObj("cHospital",1);
		hiddenObj("Hospital",1);
	}
	//Add By QW20210629 BUG:QW0131 院区 end
}

function BDelete_Click() //删除
{
	rowid=GetElementValue("RowID");
	var truthBeTold = window.confirm(t["-4003"]);
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetUpdate");
	var result=cspRunServerMethod(encmeth,rowid);
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		location.reload();
	}
	else
	{
		if (result==-99)
		{
			alertShow("当前验收单据已入库或其明细已有入库记录!");
		}
		if (result==-98)
		{
			alertShow("当前验收单无明细记录!");
		}
		messageShow("","","",t["01"]);
	}
}
///选择表格行触发此方法
///HISUI改造 modified by czf 20180929
function SelectRowHandler(index,rowdata)
{
	if (index==SelectedRow)
	{
		DisableBElement("BDelete",true);
		SelectedRow=-1;
		rowid=0;
		SetElement("RowID","");
		$('#tDHCEQOCREquipDelete').datagrid('unselectAll');		// MZY0056	1528180		2020-09-29	清空行选中
	}
    else
    {
		SelectedRow=index;
		rowid=rowdata.TRowID;
		SetElement("RowID",rowid);
		DisableBElement("BDelete",false);
		InitEvent();
	}
}

/*
///选择表格行触发此方法
function SelectRowHandler()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQOCREquipDelete');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	if (!selectrow)	 return;
	if (SelectedRow==selectrow)	{
		DisableBElement("BDelete",true);
		SelectedRow=0;
		rowid=0;
		SetElement("RowID","");
		}
	else{
		SelectedRow=selectrow;
		rowid=GetElementValue("TRowIDz"+SelectedRow);
		SetElement("RowID",rowid);
		DisableBElement("BDelete",false);
		InitEvent();
		}
}*/
// 20140410  Mozy0126
function GetProvider(value)
{
	GetLookUpID("ProviderDR",value);
}
function GetEquipType(value)
{
	GetLookUpID("EquipTypeDR",value);
}
//Add By QW20210629 BUG:QW0131 院区
function GetHospital(value)
{
	GetLookUpID("HospitalDR",value); 			
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
