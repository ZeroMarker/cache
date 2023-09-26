/// -------------------------------
/// Create by JDL 2011-05-12 JDL0081
/// 付款计划
/// -------------------------------
function BodyLoadHandler() 
{
	InitUserInfo();
	InitPage();	
	initButtonWidth()  //hisui改造 add by czf 20180831
	SetComboboxRequired()
	SetSourceAmount()
}
///初始化页面
function InitPage()
{
	var ReadOnly=GetElementValue("ReadOnly");
	if (ReadOnly=="1")
	{
		//var tbl=GetParentTable("PayPercent");
		//if (tbl) tbl.removeNode(true);
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
	}
	else
	{
		var obj=document.getElementById("BUpdate");
		if (obj) obj.onclick=BUpdate_click;
		var obj=document.getElementById("BDelete");
		if (obj) obj.onclick=BDelete_click;
	}
	
	if (opener)
	{
		var obj=document.getElementById("BClose");
		if (obj) obj.onclick=CloseWindow;
	}
	else
	{
		EQCommon_HiddenElement("BClose")
	}
	var obj=document.getElementById("PayPercent");
	if (obj) obj.onkeydown=PayPercent_KeyDown;
}

///获取数据
function GetData()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ;
	combindata=combindata+"^"+GetElementValue("Desc") ;
	combindata=combindata+"^"+GetElementValue("SourceType") ;
	combindata=combindata+"^"+GetElementValue("SourceID") ;
	combindata=combindata+"^"+GetElementValue("PayType") ;
	combindata=combindata+"^"+GetElementValue("DateType") ;
	combindata=combindata+"^"+GetElementValue("PlanPayDate") ;
	combindata=combindata+"^"+GetElementValue("PeriodNum") ;
	combindata=combindata+"^"+GetElementValue("PeriodUnitDR") ;
	combindata=combindata+"^"+GetElementValue("PayPercent") ;
	combindata=combindata+"^"+GetElementValue("PayAmount") ;
	combindata=combindata+"^"+GetElementValue("Condition") ;
	combindata=combindata+"^"+GetElementValue("PayFlag") ;
	combindata=combindata+"^"+GetElementValue("Remark") ;
	combindata=combindata+"^"+GetElementValue("Hold1") ;
	combindata=combindata+"^"+GetElementValue("Hold2") ;
	combindata=combindata+"^"+GetElementValue("Hold3") ;
	combindata=combindata+"^"+GetElementValue("Hold4") ;
	combindata=combindata+"^"+GetElementValue("Hold5") ;
  	return combindata;
}

///填充数据
function FillData()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="") return;
	var encmeth=GetElementValue("GetFillData");
	
	var ReturnList=cspRunServerMethod(encmeth,RowID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	list=ReturnList.split("^");
	
	var sort=18;
	SetElement("Desc",list[0]);
	//SetElement("SourceType",list[1]);
	//SetElement("SourceID",list[2]);
	SetElement("PayType",list[3]);
	SetElement("DateType",list[4]);
	SetElement("PlanPayDate",list[sort+2]);
	SetElement("PeriodNum",list[6]);
	SetElement("PeriodUnitDR",list[7]);
	SetElement("PayPercent",list[8]);
	SetElement("PayAmount",list[9]);
	SetElement("Condition",list[10]);
	SetElement("PayFlag",list[11]);
	SetElement("Remark",list[12]);
	SetElement("Hold1",list[13]);
	SetElement("Hold2",list[14]);
	SetElement("Hold3",list[15]);
	SetElement("Hold4",list[16]);
	SetElement("Hold5",list[17]);
}

///更新付款计划
function BUpdate_click()
{
	SaveData();
}

///保存数据
function SaveData()
{
	if (CheckData()) return true;

	var val=GetData();
	var encmeth=GetElementValue("GetUpdate");
	var rtn=cspRunServerMethod(encmeth,val);
	var list=rtn.split("^");	
	if (list[0]==0)
	{
		alertShow("操作成功!")
		window.location.reload();
	}
	else
	{
		messageShow("","","",EQMsg("操作失败",t[list[0]]));
	}	
}

function BDelete_click()
{
	var RowID=GetElementValue("RowID");
	if (RowID=="")
	{
		messageShow("","","",t[-1001]);
		return;
	}
	var truthBeTold = window.confirm(t["-4003"]);		//Add By DJ 2016-12-06
    if (!truthBeTold) return;
	var encmeth=GetElementValue("GetDelData");
	var rtn=cspRunServerMethod(encmeth,RowID);
	if (rtn==0)
	{
		alertShow("删除成功!")
		window.location.reload();
	}
	else
	{
		messageShow("","","",EQMsg("操作失败",t[rtn]));
	}	
}

///HISUI改造 add by czf 20180831
//点击表格项填充自由项,函数名称固定
var SelectedRow = -1;
function SelectRowHandler(index,rowdata)	{
	if (index==SelectedRow){
		ClearData();
		SelectedRow= -1;
		rowid=0;
		SetElement("RowID","");
		$('#tDHCEQPayPlan').datagrid('unselectAll'); 
		return;
		}
	rowid=rowdata.TRowID;
	if (rowid=="") return;
	SetElement("RowID",rowid);
	FillData();   
    SelectedRow = index;
}
/*
function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex; //当前选择行
	var TRowID="";
	if (selectrow==SelectedRow)
	{		
		SelectedRow=0;		
	}
	else
	{
		TRowID=GetElementValue("TRowIDz"+selectrow);
		SetElement("RowID",TRowID);
    	SelectedRow = selectrow;
	}
	if (TRowID=="")
	{
		ClearData();
	}
	else
	{
		FillData();
	}
	
}*/

///清除数据
function ClearData()
{
	SetElement("RowID","");
	SetElement("Desc","");
	//SetElement("SourceType","");
	//SetElement("SourceID","");
	SetElement("PayType","");
	SetElement("DateType","");
	SetElement("PlanPayDate","");
	SetElement("PeriodNum","");
	SetElement("PeriodUnitDR","");
	SetElement("PayPercent","");
	SetElement("PayAmount","");
	SetElement("Condition","");
	SetElement("PayFlag","");
	SetElement("Remark","");
	SetElement("Hold1","");
	SetElement("Hold2","");
	SetElement("Hold3","");
	SetElement("Hold4","");
	SetElement("Hold5","");
}

function CheckData()
{
	if (CheckMustItemNull()) return true;
	var PayPercent=GetElementValue("PayPercent");
	if (PayPercent!="")
	{
		if ((parseFloat(PayPercent)<=0)||(parseFloat(PayPercent)>100))
		{
			alertShow("请输入有效的付款比例!");
			return true;
		}
	}
	if (GetElementValue("DateType")=="1")
	{
		if (GetElementValue("PlanPayDate")=="")
		{			
			alertShow("请录入指定的计划付款日期!");
			return true;
		}
	}
	else
	{
		if (GetElementValue("PeriodNum")=="")
		{			
			alertShow("请录入计划付款周期数!");
			return true;
		}
		if (GetElementValue("PeriodUnitDR")=="")
		{			
			alertShow("请录入计划付款周期单位!");
			return true;
		}
	}
}
function SetSourceAmount()
{
	var SourceType=GetElementValue("SourceType")
	var SourceID=GetElementValue("SourceID")
	var encmeth=GetElementValue("GetSourceAmount");
	var ReturnList=cspRunServerMethod(encmeth,SourceType,SourceID);
	ReturnList=ReturnList.replace(/\\n/g,"\n");
	SetElement("SourceAmount",ReturnList)
}
function PayPercent_KeyDown()
{
	if (event.keyCode==13)
	{
		var SourceAmount=GetElementValue("SourceAmount")
		var PayPercent=GetElementValue("PayPercent")
		var GetPayAmount=parseFloat(SourceAmount*PayPercent/100)
		SetElement("PayAmount",GetPayAmount.toFixed(2))
	}
}
document.body.onload = BodyLoadHandler;