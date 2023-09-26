var Component="DHCEQMaintAlert"
function BodyLoadHandler() 
{	
	if (GetElementValue("BussType")==2)
	{
		Component="DHCEQInspectAlert"
		if (GetElementValue("MaintTypeDR")==5)
		{
			Component="DHCEQMeterageAlert"
		}
	}
	InitPage();
}
function InitPage()
{
	if (GetElementValue("BussType")==2)
	{
		KeyUp("Equip^MaintLoc^PlanName");
		Muilt_LookUp("Equip^MaintLoc^PlanName");
	}
	else
	{
		KeyUp("Equip^MaintType^MaintLoc^PlanName");
		Muilt_LookUp("Equip^MaintType^MaintLoc^PlanName");
	}
	var obj=document.getElementById("BExecute");
	if (obj) obj.onclick=BExecute_Clicked;
	var obj=document.getElementById("SelectAll");
	if (obj) obj.onclick=SelectAll_Clicked;
}

function BExecute_Clicked()
{
	var valRowIDs=""
	var objtbl=document.getElementById('t'+Component);
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		var TRowID=GetElementValue("TRowIDz"+i)
		var TEquipDR=GetElementValue("TEquipDRz"+i)
		var ListInfo=TRowID+"^"+TEquipDR
		var TFlag=GetElementValueNew("TFlagz"+i,"2")
		var tmp=","+valRowIDs+",";
		if (tmp.indexOf(","+ListInfo+",")==-1)
		{
			if (TFlag==true)
			{
				if (valRowIDs!="") valRowIDs=valRowIDs+",";
				valRowIDs=valRowIDs+ListInfo;
			}			
		}
		else
		{
			if (TFlag==false)
			{
				tmp=tmp.replace(","+ListInfo+",",",")
				valRowIDs=tmp.substring(1,tmp.length - 1)
			}
		}
	}
	if (valRowIDs=="")
	{
		alertShow("请选择要执行计划的设备.")
		return;
	}
  	var BussType=GetElementValue("BussType")
  	if (BussType=="") return;
  	var encmeth=GetElementValue("Execute")
  	if (encmeth=="") return;
	var Rtn=cspRunServerMethod(encmeth,valRowIDs,BussType);
	if (Rtn==0)
	{
		 alertShow("执行成功!")
		 window.location.href= 'websys.default.csp?WEBSYS.TCOMPONENT='+Component+"&QXType="+GetElementValue("QXType")+"&BussType="+GetElementValue("BussType")+"&MaintLocDR="+GetElementValue("MaintLocDR")+"&MaintTypeDR="+GetElementValue("MaintTypeDR");			//Add By DJ 2015-12-28
	}
}

function SelectAll_Clicked()
{
	var valRowIDs=""
	var eSrc=window.event.srcElement;
	var obj=document.getElementById("SelectAll");
	var Objtbl=document.getElementById('t'+Component);
	var Rows=Objtbl.rows.length;
	for (var i=1;i<Rows;i++)
	{
		var selobj=document.getElementById('TFlagz'+i);
		selobj.checked=obj.checked;
		if (selobj.checked==true)
		{
			var Select=document.getElementById("TFlagz"+i);
			var Select=Select.checked
		}
	}
}

function GetEquip(value)
{
    GetLookUpID("EquipDR",value);
}
function GetMaintType (value)
{
    GetLookUpID("MaintTypeDR",value);
}
function GetMaintLoc (value)
{
    GetLookUpID("MaintLocDR",value);
}
//add by zx 2015-09-14 Bug ZX0032
function GetPlanNameID(value)
{
	GetLookUpID("PlanNameDR",value);
}
document.body.onload = BodyLoadHandler;