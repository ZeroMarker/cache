//设备生命周期费用记录表
function BodyLoadHandler() 
{
	KeyUp("UseLoc^ManageLoc^FeeType^Equip");
	Muilt_LookUp("UseLoc^ManageLoc^FeeType^Equip");
	if (1==GetElementValue("ReadOnly"))
	{
		DisableBElement("BAdd",true);
	}
	else
	{
		var obj=document.getElementById("BAdd");
		if (obj) obj.onclick=BAdd_Click;
	}
	SetLink();//费用类型连接	
}

function BAdd_Click()
{
	var str="dhceqlifefee.csp"
    window.open(str,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=880,height=660,left=130,top=20')
}
/*
function BFind_Click() // 查找
{
	if(document.all["BFind"].disabled==false)
	{
	//var obj;
	//var iEquipDR="",iEquip="",iManageLoc="",iUseLoc="",iFeeTypeDR="",iFeeType="",iStartDate="",iEndDate="",iStatus=""
	obj=document.getElementById("EquipDR");
	if (obj) { iEquipDR=obj.value; }
	//var iEquipDR=GetElementValue("EquipDR")
	var iEquip=GetElementValue("Equip")
	var iManageLoc=GetElementValue("ManageLoc")
	var iUseLoc=GetElementValue("UseLoc")
	var iFeeTypeDR=GetElementValue("FeeTypeDR")
	var iFeeType=GetElementValue("FeeType")
	var iStartDate=GetElementValue("StartDate")
	var iEndDate=GetElementValue("EndDate")
	var iStatus=GetElementValue("Status")
	//obj=document.getElementById("BFind");
	// if (obj && obj.disabled) { return false; }
	var lnk='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQLifeFeeFind'
		+"&EquipDR="+iEquipDR
		+"&Equip="+iEquip
		+"&ManageLoc="+iManageLoc
		+"&UseLoc="+iUseLoc
		+"&FeeTypeDR="+iFeeTypeDR
		+"&FeeType="+iFeeType
		+"&StartDate="+iStartDate
		+"&EndDate="+iEndDate
		+"&Status="+iStatus
		;
	//window.location.href='websys.default.csp?WEBSYS.TCOMPONENT=DHCEQLifeFeeFind'//&RowID='+Return
	window.location.href=lnk;
	}
}
*/
function EndDate_Click()
{
	var StartDate=GetElementValue("EndDate")
}
function StartDate_Click()
{
	var StartDate=GetElementValue("StartDate")
}
function EquipDR(value)//设备名称
{
	//alertShow(value);
	var obj=document.getElementById("EquipDR");
	var val=value.split("^");	
	if (obj) obj.value=val[1];
	//alertShow(val[1]);
}
function FeeTypeDR(value) // 费用类型
{
	//alertShow(value);
	var obj=document.getElementById("FeeTypeDR");
	var val=value.split("^");	
	if (obj) obj.value=val[2];
}
function ManageLocDR(value) // 管理科室
{
	//alertShow(value);
	var obj=document.getElementById("ManageLocDR");
	var val=value.split("^");	
	if (obj) obj.value=val[2];
	//alertShow(val[2]);
}
function UseLocDR(value) // 使用科室
{
	//alertShow(value);
	var obj=document.getElementById("UseLocDR");
	var val=value.split("^");	
	if (obj) obj.value=val[2];
}
///////////////////////////////////////
function SetLink()//费用类型连接
{
	var SelRowObj;
	var objtbl=document.getElementById('tDHCEQLifeFeeFind');
	var rows=objtbl.rows.length;
	for (var i=1;i<rows;i++)
	{
		SelRowObj=document.getElementById('TFeeTypez'+i);
		if (SelRowObj)
		{
		SelRowObj.onclick=lnk_Click;//调用
		SelRowObj.href="#";
		}
	}	
}
function lnk_Click()
{
	var eSrc=window.event.srcElement;	//获取事件源头
	var row=GetRowByColName(eSrc.id);//调用
  if(GetCElementValue("TIsInputFlagz"+row)=="N")//是否人工录入
	{
	var lnk=GetHref(row);//调用
	if (lnk=="") 
	{
		alertShow(t[-1002])
	return;
	}
	window.open(lnk,'_blank','toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width=890,height=650,left=120,top=0');
	}
	else
	{
		alertShow(t[-3001])
		return
		}
}
function GetRowByColName(colname)
{
	var offset=colname.lastIndexOf("z");
	var row=colname.substring(offset+1);
	return row;
}
function GetHref(row)
{
	var Lifechang="";
	var SelRowObj="";
	var TypeObj=document.getElementById('TFeeTypeDRz'+row);
	var Typeid=document.getElementById('TFeeTypeidDRz'+row);
	var SourceID=Typeid.value;
	var lnk="";
	if(TypeObj.value==1)//设备原值 DHC_EQEquip 
	{
	ComponentName="DHCEQEquip"
	lnk='websys.default.csp?WEBSYS.TCOMPONENT='+ComponentName+'&RowID='+SourceID;
	}
	else if(TypeObj.value==2)//附加费 DHC_EQAppendFee
	{
		ComponentName="DHCEQAppendFee"
	lnk='websys.default.csp?WEBSYS.TCOMPONENT='+ComponentName+'&EquipDR='+SourceID;	
	}
	else
	{
	//////////////////////////////
	 if(TypeObj.value==3)//维修费		DHC_EQMaintRequest  
	{
		SelRowObj=document.getElementById('TEquipDRz'+row);
		ComponentName="DHCEQMaintRequest"
		lnk=ComponentName+'.csp?'+'&RowID='+SourceID+'&EquipDR='+SelRowObj.value+'&Status=解决';
		}
	else if(TypeObj.value==4)//保养费		DHC_EQMaintPlan 
	{
		SelRowObj=document.getElementById('TEquipDRz'+row);
		ComponentName="DHCEQMaint"
		lnk=ComponentName+'.csp?'+'&RowID='+SourceID+'&EquipDR='+SelRowObj.value;
		}
 	else if(TypeObj.value==5)//检查费		DHC_EQCInspectResult
	{
		SelRowObj=document.getElementById('TEquipDRz'+row);
		ComponentName="DHCEQInspect"
		lnk=ComponentName+'.csp?'+'&RowID='+SourceID+'&EquipDR='+SelRowObj.value;
		}
	else if(TypeObj.value==6)//折旧费		DHC_EQMonthDepre 
	{
		SelRowObj=document.getElementById('TEquipDRz'+row);
		ComponentName="DHCEQMonthDepre"
		var gbldata=SetDataname(SourceID);//调用函数
		if (gbldata=="") return "";
		var list=gbldata.split("^");
		//+'&RowID='+SourceID
		//if(list[1]&list[0]&)
		//{
		var DepreSetId=list[0]	
		var DepreMethodId=list[1]
	
		var PreDepreMonth=list[2]
		//}
		lnk=ComponentName+'.csp?'+'&EquipDR='+SelRowObj.value+'&DepreSetId='+DepreSetId+'&DepreMethodId='+DepreMethodId+'&PreDepreMonth='+PreDepreMonth;
		}
	else if(TypeObj.value==7)//资源耗用费用		DHC_EQUsedResource
	{
		SelRowObj=document.getElementById('TEquipDRz'+row);
		//SelRowObj=document.getElementById('TFeeTypeidDRz'+row);
		ComponentName="DHCEQUsedResource"
		lnk=ComponentName+'.csp?'+'&theID='+SourceID+'&EquipDR='+SelRowObj.value;
		}	
 	//lnk=ComponentName+'.csp?'+'&RowID='+SelRowObj.value;//+'&ChangeType='+ChangeType+'&EquipNameDR='+EquipNameDR;
	}
	return lnk;
}
function SetDataname(rowid)
{
	var encmeth=GetElementValue("DHCEQMonthDepre");
	if (encmeth=="")return;
	var gbldata=cspRunServerMethod(encmeth,'','',rowid);
	return gbldata;
}
document.body.onload = BodyLoadHandler;