var Component="DHCEQMaintPlanNew"

function BodyLoadHandler() 
{
	if (GetElementValue("BussType")==2)
	{
		Component="DHCEQInspectPlanNew"
		if (GetElementValue("MaintTypeDR")==5)
		{
			Component="DHCEQMeteragePlanNew"
		}
	}
	InitUserInfo();	
	InitPage();
	FillData();	
	SetEnabled();	
	SetDisplay();	
	KeyUp("SourceID^MaintLoc^CycleUnit^MaintUser^MeasureDept^Service^MaintType^MaintMode","N");
	Muilt_LookUp("SourceID^MaintLoc^CycleUnit^MaintUser^MeasureDept^Service^MaintType^MaintMode","N");
}

function InitPage()
{
	var obj=document.getElementById("BUpdate");
	if (obj) obj.onclick=BUpdate_Click;
	
	var obj=document.getElementById("BDelete");
	if (obj) obj.onclick=BDelete_Click;
	
	var obj=document.getElementById("BSubmit");
	if (obj) obj.onclick=BSubmit_Click;
	
	var obj=document.getElementById("BCancelSubmit");
	if (obj) obj.onclick=BCancelSubmit_Click;
		
	//var obj=document.getElementById("BExecute");
	//if (obj) obj.onclick=BExecute_Click;
	
	var obj=document.getElementById("BMaintPlanItem");
	if (obj) obj.onclick=BMaintPlanItem_Click;
	/*
	if (GetElementValue("BussType")==1)
	{
		if (obj) obj.onclick=BMaintPlanItem_Click;
	}else
	{
		if (obj) obj.onclick=BInspectPlanItem_Click;
	}*/
	
	var obj=document.getElementById("BMaintPlanPart");
	if (obj) obj.onclick=BMaintPlanPart_Click;
	
	var obj=document.getElementById("ld"+GetElementValue("GetComponentID")+"iSourceID");
	if (obj) obj.onclick=BSourceID_Click;
	
	var obj=document.getElementById("SourceType");
	if (obj) obj.onchange=SourceType_Click;
	
	var obj=document.getElementById("MeasureFlag");
	if (obj) obj.onclick=MeasureFlag_Click;
}
function FillData()
{
	var RowID=GetElementValue("RowID");
  	if ((RowID=="")||(RowID==0)) return;
	var encmeth=GetElementValue("fillData");		//Add By DJ 2016-12-05
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID);
	Rtn=Rtn.replace(/\\n/g,"\n");
	list=Rtn.split("^");
	var sort=44;
	SetElement("Name",list[0]);
	SetElement("Type",list[1]);
	SetElement("SourceType",list[2]);
	SetElement("SourceIDDR",list[3]);
	SetElement("ModelDR",list[4]);
	SetElement("Content",list[5]);
	SetElement("CycleNum",list[6]);
	SetElement("CycleUnitDR",list[7]);
	SetElement("MaintTypeDR",list[8]);
	SetElement("FromDate",list[9]);
	SetElement("EndDate",list[10]);
	SetElement("PreWarnDaysNum",list[11]);
	SetElement("MaintFee",list[12]);
	SetElement("MaintLocDR",list[13]);
	SetElement("MaintUserDR",list[14]);
	SetElement("MaintModeDR",list[15]);
	SetElement("ContractDR",list[16]);
	SetChkElement("MeasureFlag",list[17]);
	SetElement("MeasureDeptDR",list[18]);
	SetElement("MeasureHandler",list[19]);
	SetElement("MeasureTel",list[20]);
	SetElement("ServiceDR",list[21]);
	SetElement("ServiceHandler",list[22]);
	SetElement("ServiceTel",list[23]);
	SetElement("Remark",list[24]);
	SetElement("Status",list[25]);
	/*
	SetElement("UpdateUserDR",list[0]);
	SetElement("UpdateDate",list[0]);
	SetElement("UpdateTime",list[0]);
	SetElement("SubmitUserDR",list[0]);
	SetElement("SubmitDate",list[0]);
	SetElement("SubmitTime",list[0]);
	SetElement("AuditUserDR",list[0]);
	SetElement("AuditDate",list[0]);
	SetElement("AuditTime",list[0]);
	*/
	SetChkElement("InvalidFlag",list[35]);
	/*
	SetElement("DelUserDR",list[0]);
	SetElement("DelDate",list[0]);
	SetElement("DelTime",list[0]);
	*/
	SetElement("Hold1",list[39]);
	SetElement("Hold2",list[40]);
	SetElement("Hold3",list[41]);
	SetElement("Hold4",list[42]);
	SetElement("Hold5",list[43]);
	
	SetElement("SourceID",list[sort+1]);
	SetElement("Model",list[sort+2]);
	SetElement("CycleUnit",list[sort+3]);
	SetElement("MaintType",list[sort+4]);
	SetElement("MaintLoc",list[sort+5]);
	SetElement("MaintUser",list[sort+6]);
	SetElement("MaintMode",list[sort+7]);
	SetElement("Contract",list[sort+8]);
	SetElement("MeasureDept",list[sort+9]);
	SetElement("Service",list[sort+10]);
	SetElement("No",list[sort+16]);
}

function SetEnabled()
{
	var Status=GetElementValue("Status");
	var ReadOnly=GetElementValue("ReadOnly"); //add by zx 201-09-18
	if (Status=="")
	{
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BMaintPlanItem",true);
		DisableBElement("BMaintPlanPart",true);
	}
	else if (Status=="0")
	{
		DisableBElement("BCancelSubmit",true);
	}
	else if (ReadOnly=="1")
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
		DisableBElement("BCancelSubmit",true);
		DisableBElement("BMaintPlanItem",true);
		DisableBElement("BMaintPlanPart",true);
	}	
	else 
	{
		DisableBElement("BUpdate",true);
		DisableBElement("BDelete",true);
		DisableBElement("BSubmit",true);
	}
}

function GetMaintInfoList()
{
	var combindata="";
  	combindata=GetElementValue("RowID") ; //
	combindata=combindata+"^"+GetElementValue("Name") ; //
	combindata=combindata+"^"+GetElementValue("BussType") ; //
	combindata=combindata+"^"+GetElementValue("SourceType") ; //
	combindata=combindata+"^"+GetElementValue("SourceIDDR") ; //
	combindata=combindata+"^"+GetElementValue("ModelDR") ; //
	combindata=combindata+"^"+GetElementValue("Content") ; //
	combindata=combindata+"^"+GetElementValue("CycleNum") ; //
	combindata=combindata+"^"+GetElementValue("CycleUnitDR") ; //
	combindata=combindata+"^"+GetElementValue("MaintTypeDR") ; //
	combindata=combindata+"^"+GetElementValue("FromDate") ; //
	combindata=combindata+"^"+GetElementValue("EndDate") ; //
	combindata=combindata+"^"+GetElementValue("PreWarnDaysNum") ; //
	combindata=combindata+"^"+GetElementValue("MaintFee") ; //
	combindata=combindata+"^"+GetElementValue("MaintLocDR") ; //
	combindata=combindata+"^"+GetElementValue("MaintUserDR") ; //
	combindata=combindata+"^"+GetElementValue("MaintModeDR") ; //
	combindata=combindata+"^"+GetElementValue("ContractDR") ; //
	combindata=combindata+"^"+GetChkElementValue("MeasureFlag") ; //
	combindata=combindata+"^"+GetElementValue("MeasureDeptDR") ; //
	combindata=combindata+"^"+GetElementValue("MeasureHandler") ; //
	combindata=combindata+"^"+GetElementValue("MeasureTel") ; //
	combindata=combindata+"^"+GetElementValue("ServiceDR") ; //
	combindata=combindata+"^"+GetElementValue("ServiceHandler") ; //
	combindata=combindata+"^"+GetElementValue("ServiceTel") ; //
	combindata=combindata+"^"+GetElementValue("Remark") ; //
	combindata=combindata+"^"+GetElementValue("Status") ; //
	/*
	combindata=combindata+"^"+GetElementValue("UpdateUserDR") ; //
	combindata=combindata+"^"+GetElementValue("UpdateDate") ; //
	combindata=combindata+"^"+GetElementValue("UpdateTime") ; //
	combindata=combindata+"^"+GetElementValue("SubmitUserDR") ; //
	combindata=combindata+"^"+GetElementValue("SubmitDate") ; //
	combindata=combindata+"^"+GetElementValue("SubmitTime") ; //
	combindata=combindata+"^"+GetElementValue("AuditUserDR") ; //
	combindata=combindata+"^"+GetElementValue("AuditDate") ; //
	combindata=combindata+"^"+GetElementValue("AuditTime") ; //
  	//combindata=combindata+"^"+curUserID ;
	*/
	combindata=combindata+"^"+GetChkElementValue("InvalidFlag") ; //
	/*
	combindata=combindata+"^"+GetElementValue("DelUserDR") ; //
	combindata=combindata+"^"+GetElementValue("DelDate") ; //
	combindata=combindata+"^"+GetElementValue("DelTime") ; //
	*/
	combindata=combindata+"^"+GetElementValue("Hold1") ; //
	combindata=combindata+"^"+GetElementValue("Hold2") ; //
	combindata=combindata+"^"+GetElementValue("Hold3") ; //
	combindata=combindata+"^"+GetElementValue("Hold4") ; //
	combindata=combindata+"^"+GetElementValue("Hold5") ; //

	return combindata;
}

function BUpdate_Click() 
{
	if (CheckNull()) return;
	if (CheckInvalidData()) return;
	var combindata=GetMaintInfoList();
  	var encmeth=GetElementValue("UpdateData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,combindata);
	if (Rtn<0) 
	{
		alertShow(t["04"]);
		return;	
	}
	//add by HHM 20150910 HHM0013
	//添加操作成功是否提示
	ShowMessage();
	//****************************	
    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+Component+'&RowID='+Rtn+"&QXType="+GetElementValue("QXType")+"&BussType="+GetElementValue("BussType")+"&MaintTypeDR="+GetElementValue("MaintTypeDR");
}

function BDelete_Click() 
{
	var truthBeTold = window.confirm(t["-4003"]);	
	if (!truthBeTold) return;
	var RowID=GetElementValue("RowID");
  	if (RowID=="") return;
  	var encmeth=GetElementValue("DeleteData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID)
	if (Rtn<0) 
	{
		alertShow(t["07"]);
		return;	
	}
    window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+Component+'&RowID='+"&QXType="+GetElementValue("QXType")+"&BussType="+GetElementValue("BussType")+"&MaintTypeDR="+GetElementValue("MaintTypeDR");
}

function BSubmit_Click() 
{
	var RowID=GetElementValue("RowID");
  	if (RowID=="") return;
  	var encmeth=GetElementValue("SubmitData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID);
	if (Rtn<0) 
	{
		alertShow(t["09"]);
		return;	
	}
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+Component+'&RowID='+Rtn+"&QXType="+GetElementValue("QXType")+"&BussType="+GetElementValue("BussType")+"&MaintTypeDR="+GetElementValue("MaintTypeDR");
}

function BCancelSubmit_Click() 
{
	var RowID=GetElementValue("RowID");
  	if (RowID=="") return;
  	var encmeth=GetElementValue("CancelSubmitData")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,RowID);
	if (Rtn<0) 
	{
		alertShow(t["09"]);
		return;	
	}
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+Component+'&RowID='+"&QXType="+GetElementValue("QXType")+"&BussType="+GetElementValue("BussType")+"&MaintTypeDR="+GetElementValue("MaintTypeDR");	//Modified By HZY 2012-04-23 HZY0028. 公司测试出的Bug.
}

/*
function BExecute_Click() 
{
	var RowID=GetElementValue("RowID");
  	if (RowID=="") return;
	var Status=GetElementValue("Status");
  	if (Status=="") return;
	if (Status!="1")
	{
		alertShow(t["13"]);
		return;
	}
  	var encmeth=GetElementValue("checkmaint")
  	if (encmeth=="") return;
	var sqlco=cspRunServerMethod(encmeth,"","",RowID);
	if (sqlco<0) 
	{
		alertShow(t["15"]);
		return;	
	}
	var upd=document.getElementById('execute');
	if (upd){var encmeth=upd.value} else {var encmeth=""};
	var User=curUserID ;
	var ReturnValue=cspRunServerMethod(encmeth,"","",RowID,User);
	var ReturnList=ReturnValue.split("^");
	var sqlco=ReturnList[0];
	var IRowID=ReturnList[1];
	if (sqlco<0) 
	{
		alertShow(t["14"]);
		return;	
	}
	window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintPlanNew&RowID='
}
*/
function CheckNull()
{
	if (CheckMustItemNull()) return true;
	if (CheckItemNull(1,"CycleUnit","周期单位")) return true;
	return false;
}
function CheckInvalidData()
{
	if (IsValidateNumber(GetElementValue("PreWarnDaysNum"),0,0,0,1)==0)
	{
		alertShow("预警天数异常,请修正.");
		return true;
	}
	if (IsValidateNumber(GetElementValue("CycleNum"),0,0,0,1)==0)
	{
		alertShow("保养周期数据异常,请修正.");
		return true;
	}
	return false;
}
function BMaintPlanItem_Click() 
{
	var MaintPlanDR=GetElementValue("RowID");
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintPlanItem&MaintPlanDR='+MaintPlanDR+"&BussType="+GetElementValue("BussType");
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0');
}
/*
function BInspectPlanItem_Click() 
{
	var InspectPlanDR=document.getElementById("RowID").value; 
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQInspectPlanItem&InspectPlanDR='+InspectPlanDR;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=700,height=500,left=320,top=0');
}*/

function BMaintPlanPart_Click() 
{
	var MaintPlanDR=GetElementValue("RowID");
	var str='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQMaintPlanpart&MaintPlanDR='+MaintPlanDR;
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=600,height=400,left=320,top=0');
}
function GetMaintType(value) 
{
	GetLookUpID("MaintTypeDR",value);
}

function GetMaintLoc(value) 
{
	GetLookUpID("MaintLocDR",value);
}

function GetMaintMode(value) 
{
	GetLookUpID("MaintModeDR",value);
}
function GetMeasureDeptID(value)
{
	GetLookUpID("MeasureDeptDR",value);
	///add by lmm begin 2017-06-27 396400 自动带出赋值
	var val=value.split("^");
	SetElement('MeasureHandler',val[3]);
	SetElement('MeasureTel',val[4]);
	///add by lmm end 2017-06-27 396400

}
function GetServiceID(value)
{
	GetLookUpID("ServiceDR",value);
}

function GetCycleUnit(value) 
{
	GetLookUpID("CycleUnitDR",value);
}

function GetMaintUser(value) 
{
	GetLookUpID("MaintUserDR",value);
}
function GetModelID(value)
{	
	GetLookUpID("ModelDR",value);
}
function SetEquipCat(id,text)
{
	SetElement('SourceID',text);
	SetElement('SourceIDDR',id);
}
function GetMasterItemID(value) 
{
	var list=value.split("^")
	SetElement('SourceID',list[0]);
	SetElement('SourceIDDR',list[1]);
}
function GetEquipID(value) 
{
	var list=value.split("^")
	SetElement('SourceID',list[0]);
	SetElement('SourceIDDR',list[1]);
	SetElement('No',list[3]);
	SetElement('ModelDR',list[6]);
	SetElement('Model',list[7]);
}

function SetDisplay()
{
	ReadOnlyCustomItem(GetParentTable("Name"),GetElementValue("Status"));
	var val="No"
	if (GetElementValue("SourceType")==1) val="No^Model";		//1:设备分类 2:设备项 3:设备
	ReadOnlyElements(val,true)
	if (GetElementValue("SourceType")!=2) DisableElement(GetLookupName("Model"),true);
	ReadOnlyElements("MeasureDept^MeasureHandler^MeasureTel",true)
	DisableElement(GetLookupName("MeasureDept"),true);
}
function BSourceID_Click()
{	
	var value=GetElementValue("SourceType")
	if (value=="1") //1:设备分类 
	{
		var CatName=GetElementValue("SourceID")
		var str="websys.default.csp?WEBSYS.TCOMPONENT=DHCEQCEquipCatTree&Type=SelectTree&CatName="+CatName;
    	window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=360,height=460,left=150,top=150')
	}else if (value=="2") //2:设备项 
	{
		LookUp("","web.DHCEQCMasterItem:GetMasterItem","GetMasterItemID",",,SourceID");
	}else if (value=="3") //3:设备
	{
		if (GetElementValue("MaintTypeDR")==5)                                               ////modified by czf 2017-04-13  begin
		{
			LookUp("","web.DHCEQEquip:GetShortEquip","GetEquipID","SourceID,,,,,,'Y',");	    
		}
		else
		{
			LookUp("","web.DHCEQEquip:GetShortEquip","GetEquipID","SourceID");          ////modified by czf 2017-04-13  begin
		}
	}
}
function SourceType_Click()
{
	SetElement('SourceID',"");
	SetElement('SourceIDDR',"");
	SetElement('No',"");
	SetElement('ModelDR',"");
	SetElement('Model',""); 
	SetChkElement("MeasureFlag",false);     //modified by czf begin 需求号：337913
	DisableElement("MeasureFlag",false);
	var MaintTypeDR=GetElementValue("MaintTypeDR");
	var value=GetElementValue("SourceType")//1:设备分类 2:设备项 3:设备
	if (value=="2") //2:设备项 
	{
		ReadOnlyElements("Model",false)		
		DisableElement(GetLookupName("Model"),false);
	}
	if ((value=="3")&&(MaintTypeDR=="5"))     //设备
	{
		SetChkElement("MeasureFlag",true);
		DisableElement("MeasureFlag",true);
	}
	MeasureFlag_Click()         //add by wy 2017-12-25
}
function MeasureFlag_Click()
{
	var MeasureFlag=GetElementValue("MeasureFlag")
	var value=true
	if (MeasureFlag==true)  value=false
	if (value==true)
	{
		SetElement("MeasureDept","");
		SetElement("MeasureHandler","");
		SetElement("MeasureTel",""); 
	}
	ReadOnlyElements("MeasureDept^MeasureHandler^MeasureTel",value)
	DisableElement(GetLookupName("MeasureDept"),value);
}
document.body.onload = BodyLoadHandler;
