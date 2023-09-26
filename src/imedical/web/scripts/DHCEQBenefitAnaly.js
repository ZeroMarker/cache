var SelectedRow=0;
var RowCount=0;
//装载页面  函数名称固定
function BodyLoadHandler() {
	InitUserInfo();
	InitEvent();	//初始化
	SetTableEvent();
	KeyUp("CTLoc^Equip");	//清空选择	
	Muilt_LookUp("CTLoc^Equip");
	Muilt_Tab("Year^Month^PlanUse^FactUse^Amount");
	FillData();
	DisabledButton();
	websys_firstfocus();	
}

function InitEvent() //初始化
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	var obj=document.getElementById("BAudit");
	if (obj) obj.onclick=BAudit_Click;
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Click;
	var obj=document.getElementById("Amount");
	if (obj) obj.onkeyup=Amountkeyup;
	var obj=document.getElementById("Year");
	if (obj) obj.onchange=Yearchange;
	var obj=document.getElementById("Month");
	if (obj) obj.onchange=Monthchange;
	var obj=document.getElementById("PlanUse");
	if (obj) obj.onkeyup=PlanUsekeyup;
	var obj=document.getElementById("FactUse");
	if (obj) obj.onkeyup=FactUsekeyup;
}

function DisabledButton()
{
	var Status=GetElementValue("Status");
	var QXType=GetElementValue("QXType");
	if (QXType==1)
	{
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
	}
	else
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	if (Status=="")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
	}
	if (Status==0)
	{
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
	}
	if (Status==1)
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
	if (Status==2)
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BAudit",true);
	}
}

function Yearchange()
{
	var Year=GetElementValue("Year");
	if (isNaN(Year)||(Year.length!=4))
	{
		alertShow("请正确输入年份(格式:YYYY)");
		SetElement("Year","");
		websys_setfocus("Year");
		return
	}
}

function Monthchange()
{
	var Month=GetElementValue("Month");
	if ((isNaN(Month))||(Month<1)||(Month>12)||(Month.length!=2))
	{
		alertShow("请正确输入月份(格式:MM)");
		SetElement("Month","");
		websys_setfocus("Month");
		return
	}
}

function PlanUsekeyup()
{
	var PlanUse=GetElementValue("PlanUse");
	if (((PlanUse!="")&&(PlanUse<0))||(isNaN(PlanUse)))
	{
		alertShow("请正确输入计划工作量");
		SetElement("PlanUse","");
		websys_setfocus("PlanUse");
		return
	}
}

function FactUsekeyup()
{
	var FactUse=GetElementValue("FactUse");
	if (((FactUse!="")&&(FactUse<0))||(isNaN(FactUse)))
	{
		alertShow("请正确输入实际工作量");
		SetElement("FactUse","");
		websys_setfocus("FactUse");
		return
	}
}

function Amountkeyup()
{
	var Amount=GetElementValue("Amount");
	if (((Amount!="")&&(Amount<0))||(isNaN(Amount)))
	{
		alertShow("请正确输入收入总额!");
		SetElement("Amount","")
		var OutTotalFee=GetElementValue("OutTotalFee");
		var ProfitLossAmount=0-OutTotalFee;
		SetElement("ProfitLossAmount",ProfitLossAmount.toFixed(2));
		SetElement("ProfitRate",0);
		websys_setfocus("Amount");
		return
	}
	if (Amount=="")
	{
		Amount=0
	}
	var OutTotalFee=GetElementValue("OutTotalFee");
	if (OutTotalFee=="")
	{
		SetElement("OutTotalFee",0.00);
	}
	var ProfitLossAmount=Amount-OutTotalFee;
	SetElement("ProfitLossAmount",ProfitLossAmount.toFixed(2));
	if (Amount==0)
	{
		var ProfitRate=0
	}
	else
	{
		var ProfitRate=ProfitLossAmount/Amount*100;		
	}
	ProfitRate=ProfitRate.toFixed(2);
	SetElement("ProfitRate",ProfitRate);
}

function FillData()
{
	var rowid=GetElementValue("BARowID");
	if (rowid=="")
	{
		var today=GetElementValue("Today");
		SetElement("Year",today.substring(0,4));
		SetElement("Month",today.substring(5,7));
		var EQRowID=GetElementValue("EquipDR");
		if (EQRowID!="")
		{
			GetEquip("^"+EQRowID);
			DisableElement("Equip",true);
			DisableElement("CTLoc",true);
		}
		return
	}
	var encmeth=GetElementValue("GetData");
	if (encmeth=="") return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	gbldata=gbldata.replace(/\\n/g,"\n"); //"\n"转换为回车符
	var list=gbldata.split("^");
	SetElement("Year",list[2]);
	SetElement("Month",list[3]);
	GetEquip("^"+list[6]);
	SetElement("BARowID",list[0]);
	SetElement("BANo",list[1]);
	SetElement("CTLocDR",list[4]);
	SetElement("CTLoc",list[5]);
	SetElement("EquipDR",list[6]);
	SetElement("Equip",list[7]);
	SetElement("PlanUse",list[8]);
	SetElement("FactUse",list[9]);
	SetElement("Amount",list[10]);
	SetElement("ProfitLossAmount",list[11]);
	SetElement("OriginalFee",list[12]);
	SetElement("Status",list[13]);
	SetElement("ProfitRate",list[14]);
	SetElement("Remark",list[15]);
	SetElement("OutTotalFee",list[16]);
}

function SetTableEvent()
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCEQBenefitAnaly');//+组件名 就是你的组件显示 Query 结果的部分
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	RowCount=lastrowindex;
	for (var i=1;i<=lastrowindex;i++)
	{
		var obj=document.getElementById("TFeez"+i);
		if (obj) obj.onkeyup=TFeekeyup;
		if (i==1)
		{
			DisableElement("TFeez1",true);
		}
		var obj=document.getElementById("TDutyUserz"+i);
		if (obj) obj.onkeydown=DutyUser_KeyDown;
		var Desc="lt"+GetElementValue("GetComponentID")+"iTDutyUserz";
		var obj=document.getElementById(Desc+i);
		if (obj) obj.onclick=LookUpDutyUser;
		Muilt_Tab("TFeez"+i+"^TRemarkz"+i);
	}
}

function DutyUser_KeyDown()
{
	if (event.keyCode==13)
	{
		LookUpDutyUser();
	}
}

function LookUpDutyUser()
{
	SelectedRow=GetTableCurRow();
	LookUp("","web.DHCEQFind:EQUser","GetDutyUser","'',TDutyUserz"+SelectedRow+",''");
}

function GetDutyUser(value)
{
	var type=value.split("^");
	SetElement("TDutyUserz"+SelectedRow,type[0]);
	SetElement("TDutyUserDRz"+SelectedRow,type[1]);
	var obj=document.getElementById("TDutyUserz"+SelectedRow)
	if (obj)
	{
		websys_nextfocusElement(obj)
	}
}

function TFeekeyup()
{
	SelectedRow=GetTableCurRow();
	var TFee=GetElementValue("TFeez"+SelectedRow);
	var TName=GetCElementValue("TResourceTypez"+SelectedRow);
	if (((TFee!="")&&(TFee<0))||(isNaN(TFee)))
	{
		alertShow("请正确输入:["+TName+"]");
		SetElement("TFeez"+SelectedRow,"");
		websys_setfocus("TFeez"+SelectedRow);
	}
	var OutFee=0;
	for (var i=1;i<=RowCount;i++)
	{
		var Fee=GetElementValue("TFeez"+i);
		if (Fee=="")
		{
			Fee=0;
		}
		OutFee=OutFee+Number(Fee);
	}
	var AmountFee=GetElementValue("Amount");
	if (AmountFee=="")
	{
		AmountFee=0
	}
	var ProfitLossAmount=AmountFee-OutFee;
	SetElement("OutTotalFee",OutFee.toFixed(2));
	SetElement("ProfitLossAmount",ProfitLossAmount.toFixed(2));
	if (AmountFee==0)
	{
		SetElement("ProfitRate",0.00);
	}
	else
	{
		var ProfitRate=ProfitLossAmount/AmountFee*100;
		ProfitRate=ProfitRate.toFixed(2);
		SetElement("ProfitRate",ProfitRate);
	}
}

function GetEquip(value)
{
	var user=value.split("^");
	var obj=document.getElementById('EquipDR');
	obj.value=user[1];
	var obj=new Equipment(user[1],"");	
	SetElement("CTLoc",obj.UseLoc);
	SetElement("CTLocDR",obj.UseLocDR);
	SetElement("Model",obj.Model);
	SetElement("ModelDR",obj.ModelDR);
	SetElement("Unit",obj.Unit);
	SetElement("UnitDR",obj.UnitDR);
	SetElement("EquipNo",obj.No);
	SetElement("StartDate",obj.StartDate);
	SetElement("OriginalFee",obj.OriginalFee);
	SetElement("PlanUse",obj.WorkLoadPerMonth);
	//2009-11-20 党军 begin
	//当前设备该月折旧费用自动提取?
	//并记录在费用明细中第一条记录(即费用明细中第一条记录费用名称必须为折旧费)
	var encmeth=GetElementValue("GetDepreFee");
	if (encmeth=="") return;
	var result=cspRunServerMethod(encmeth,user[1],GetElementValue("Year")+"-"+GetElementValue("Month"));
	SetElement("TFeez1",result);
	var OutFee=0;
	for (var i=1;i<=RowCount;i++)
	{
		var Fee=GetElementValue("TFeez"+i);
		if (Fee=="")
		{
			Fee=0;
		}
		OutFee=OutFee+Number(Fee);
	}
	var AmountFee=GetElementValue("Amount");
	if (AmountFee=="")
	{
		AmountFee=0
	}
	var ProfitLossAmount=AmountFee-OutFee;
	SetElement("OutTotalFee",OutFee.toFixed(2));
	SetElement("ProfitLossAmount",ProfitLossAmount.toFixed(2));
	if (AmountFee==0)
	{
		SetElement("ProfitRate",0.00);
	}
	else
	{
		var ProfitRate=ProfitLossAmount/AmountFee*100;
		ProfitRate=ProfitRate.toFixed(2);
		SetElement("ProfitRate",ProfitRate);
	}
	//2009-11-20 党军 end
}

function BUpdate_Click()
{
	if (condition()) return;
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var BAStr=Combindata(); //函数调用
	var BAStrList=Combindatalist();
	var result=cspRunServerMethod(encmeth,BAStr,BAStrList,'2');
	result=result.replace(/\\n/g,"\n")
	if (result==-99)
	{
		alertShow(t["02"]);
		location.reload();
		return
	}
	if (result>0)
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBenefitAnaly&BARowID='+result
	}
	else
	{
		alertShow(t["01"]);
		return
	}
}

function BDelete_Click()
{
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var BAStr=GetElementValue("BARowID"); //函数调用
	var result=cspRunServerMethod(encmeth,BAStr,'','1');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBenefitAnaly&BARowID='
	}
	else
	{
		alertShow(t["01"]);
		return
	}
}

function BSubmit_Click()
{
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var BAStr=GetElementValue("BARowID"); //函数调用
	var result=cspRunServerMethod(encmeth,BAStr,'','3');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		location.reload();
	}
	else
	{
		alertShow(t["01"]);
		return
	}
}

function BCancelSubmit_Click()
{
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var BAStr=GetElementValue("BARowID"); //函数调用
	var result=cspRunServerMethod(encmeth,BAStr,'','4');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		location.reload();
	}
	else
	{
		alertShow(t["01"]);
		return
	}
}

function BAudit_Click()
{
	var encmeth=GetElementValue("GetUpdate");
	if (encmeth=="") return;
	var BAStr=GetElementValue("BARowID"); //函数调用
	var result=cspRunServerMethod(encmeth,BAStr,'','5');
	result=result.replace(/\\n/g,"\n")
	if (result>0)
	{
		location.reload();
	}
	else
	{
		alertShow(t["01"]);
		return
	}
}

function Combindata()
{
	var combindata="";
	combindata=GetElementValue("BARowID");
	combindata=combindata+"^"+GetElementValue("Year");
	combindata=combindata+"^"+GetElementValue("Month");
	combindata=combindata+"^"+GetElementValue("CTlocDR");
	combindata=combindata+"^"+GetElementValue("EquipDR");
	combindata=combindata+"^"+GetElementValue("PlanUse");
	combindata=combindata+"^"+GetElementValue("FactUse");
	combindata=combindata+"^"+GetElementValue("Amount");
	combindata=combindata+"^"+GetElementValue("ProfitLossAmount");
	combindata=combindata+"^"+GetElementValue("OriginalFee");
	combindata=combindata+"^"+GetElementValue("Status");
	combindata=combindata+"^"+GetElementValue("ProfitRate");
	combindata=combindata+"^"+GetElementValue("Remark");
	combindata=combindata+"^"+GetElementValue("OutTotalFee");
	return combindata
}

function Combindatalist()
{
	var combindata="";
	var liststr="";
	for (var i=1;i<=RowCount;i++)
	{
		combindata=GetElementValue("TRowIDz"+i);
		combindata=combindata+"^"+GetElementValue("TResourceTypeDRz"+i);
		combindata=combindata+"^"+GetElementValue("TFeez"+i);
		combindata=combindata+"^"+GetElementValue("TDutyUserDRz"+i);
		combindata=combindata+"^"+GetElementValue("TRemarkz"+i);
		liststr=liststr+combindata+"||";
	}
	return liststr
}

function GetCTLoc(value) {
	var type=value.split("^");
	var obj=document.getElementById("CTLocDR");
	obj.value=type[1];
}

function condition()//条件
{
	if (CheckMustItemNull()) return true;
	return false;
}
//定义页面加载方法
document.body.onload = BodyLoadHandler;
