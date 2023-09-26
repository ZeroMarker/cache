// DHCEQBuyPlanFind.js
/// ----------------------------------------------
/// Modified By HZY 2011-10-18 HZY0016
/// 修改函数:SetEnabled
/// Desc:当Type!="0"时,屏蔽?新增(New)?按钮
/// ---------------------------------------------- 
function BodyLoadHandler()
{
	InitUserInfo();		
	InitPage();
	SetEnabled();
	SetLink();
	SetElement("PlanTypeList",GetElementValue("PlanTypeListDR"))
}
function SetLink()
{
	var SelRowObj;
	var objtbl=document.getElementById('tDHCEQBuyPlanFind');
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('TDetailz'+i);
		if (SelRowObj)
		{
		SelRowObj.onclick=lnk_Click;//调用
		SelRowObj.href="#";
		}
	}	
}
function lnk_Click()
{
	var row=GetTableCurRow();
	var lnk=GetHref(row);//调用
    window.location.href=lnk;
    //window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
}
function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}
function GetHref(row)
{
	var PlanTypeobj=document.getElementById('TPlanTypez'+row);
	var RowIDobj=document.getElementById('TRowIDz'+row);
	var RowID=RowIDobj.value;
	var PlanType=PlanTypeobj.value;
	var ApproveRole=GetElementValue("ApproveRole");
	var ApproveSetDR=GetElementValue("TApproveSetDRz"+row)
	var ComponentName=""
	var lnk="";
	switch (PlanType) 
	{ 
   	case "0" : //日常
       //ComponentName="DHCEQBuyPlan"
       //lnk='dhceqbuyplan.csp?RowID='+RowID+'&Type='+GetElementValue("Type")+"&CurRole="+ApproveRole+"&ApproveSetDR="+ApproveSetDR;
       lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanNew&WaitAD=off&RowID='+RowID+'&Type='+GetElementValue("Type")+"&CurRole="+ApproveRole;
       break;
   	case "1" : //年度
       ComponentName="DHCEQBuyPlanYear"
       lnk='websys.default.csp?WEBSYS.TCOMPONENT='+ComponentName+'&BuyPlanDR='+RowID+'&Type='+GetElementValue("Type")+'&Year='+GetCElementValue('TPlanYearz'+row)+"&CurRole="+ApproveRole+"&ApproveSetDR="+ApproveSetDR+"&EquipTypeID="+GetElementValue('TEquipTypeDRz'+row);
       break;
    case "2" : //年度分配
       ComponentName="DHCEQBuyPlanYearDeal"
       lnk='websys.default.csp?WEBSYS.TCOMPONENT='+ComponentName+'&BuyPlanDR='+RowID+'&Type='+GetElementValue("Type")+"&CurRole="+ApproveRole+"&ApproveSetDR="+ApproveSetDR;
        break; 
	} 
	return lnk;
}

function SetEnabled()
{
	var Type=GetElementValue("Type");
	if (Type!="0")
	{
		DisableBElement("BAdd",true);
		DisableBElement("BAddNew",true);	//屏蔽"新增(New)"按钮. Add By HZY 2011-10-18 HZY0016.
	}
	else
	{
		EQCommon_HiddenElement("WaitAD");
		EQCommon_HiddenElement("cWaitAD");
	}
	if (Type!="1")
	{
		EQCommon_HiddenElement("ReplacesAD");
		EQCommon_HiddenElement("cReplacesAD");
	}
	EQCommon_HiddenElement("PlanTypeList");
	EQCommon_HiddenElement("cPlanTypeList");
}
function InitPage()
{
	KeyUp("Status");
	Muilt_LookUp("Status");
	var obj=document.getElementById("BAdd");
	if (obj) obj.onclick=BAdd_Clicked;
	var obj=document.getElementById("WaitAD");
	if (obj) obj.onchange=CheckChange;
	var obj=document.getElementById("ReplacesAD")
	if (obj) obj.onchange=CheckChange;
	// Mozy0041	2011-2-14
	var obj=document.getElementById("BAddNew");
	if (obj) obj.onclick=BAddNew_Clicked;
}
function CheckChange()
{
	var eSrc=window.event.srcElement;
	if (eSrc.checked)
	{
		if (eSrc.id=="WaitAD") SetChkElement("ReplacesAD","0");
		if (eSrc.id=="ReplacesAD") SetChkElement("WaitAD","0");
	} 
}
function BAdd_Clicked()
{
	var PlanType=GetElementValue("PlanType")
	if (PlanType==0)
	{
		window.location.href= 'dhceqbuyplan.csp?Type=0'+'&PlanType='+PlanType
	}
	else if (PlanType==1)
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanYear&Type=0'+'&PlanType='+PlanType
	}
	else
	{
		window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanYearDeal&Type=0'+'&PlanType='+PlanType
	}
}
// Mozy0045	2011-3-14
function BAddNew_Clicked()
{
	location.href="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQBuyPlanNew&WaitAD=off&Type=0&PlanType="+GetElementValue("PlanType");
}
function GetStatus (value)
{
    GetLookUpID("StatusDR",value);
}

document.body.onload = BodyLoadHandler;