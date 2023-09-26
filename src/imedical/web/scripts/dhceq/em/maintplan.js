//界面入口
jQuery(document).ready
(
	function()
	{
		setTimeout("initDocument();",50);
	}
);
function initDocument()
{
	if (getElementValue("BussType")==2)
	{
		Component="DHCEQInspectPlanNew"
	}
	if (getElementValue("MaintTypeDR")==5)
	{
		Component="DHCEQMeteragePlanNew"
	}
	//add by lmm 2019-09-09 1018529
	setRequiredElements("Name^CycleNum^CycleUnit^PreWarnDaysNum^FromDate")  //add by lmm 2019-09-09 1018529
	initMessage();
	//add by lmm 2019-09-09 1018529
	defindTitleStyle(); 
	initButtonWidth();
	initButton();
	initLookUp();
	initTopPanel();
	jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-cancel'});
	jQuery("#BCancelSubmit").on("click", BCancelSubmit_Click);	
	muilt_Tab()  //add by lmm 2020-06-29 回车下一输入框
}


//初始化查询头面板
function initTopPanel()
{
	FillData();
	SetEnabled();
	ContrlMaintCheck();
}
///add by lmm 2018-11-01
///描述：界面勾选框改变事件
function ContrlMaintCheck()
{
	if($("#TempPlanflag").is(':checked')==true)
	{
		
		disableElement("CycleNum",true)
		disableElement("CycleUnit",true)
		setElement("CycleUnit","")
		setElement("CycleUnitDR","")	//add by lmm 2019-05-16 894632
		
	}
	if($("#FixTimeflag").is(':checked')==true)
	{
		disableElement("SDate",false)
		disableElement("EDate",false)
		
	}
	$('#TempPlanflag').checkbox({ 
		onCheckChange:function(e,value)
		{
			if($("#TempPlanflag").is(':checked')==true)
			{
				disableElement("CycleUnit",true)
				setElement("CycleUnit","")
				setElement("CycleUnitDR","")	//add by lmm 2019-05-16 894632
				disableElement("CycleNum",true)
				setElement("CycleNum","")
				disableElement("SDate",true)
				disableElement("EDate",true)
				$("#FixTimeflag").checkbox("disable");
				//add by lmm 2091-10-14 1036810 begin
				setItemRequire("CycleNum",false)
				setItemRequire("CycleUnit",false)
				setItemRequire("CycleUnitDR",false)

			}
			else
			{
				disableElement("CycleUnit",false)
				disableElement("CycleNum",false)
				$("#FixTimeflag").checkbox("enable");
				setItemRequire("CycleNum",true)
				setItemRequire("CycleUnit",true)
				setItemRequire("CycleUnitDR",true)
				
			}
		}
	}); 
	$('#FixTimeflag').checkbox({ 
		onCheckChange:function()
		{
			if($("#FixTimeflag").is(':checked')==true)
			{
				disableElement("SDate",false)
				disableElement("EDate",false)
				//modify by lmm 2019-01-10 begin 802966
				disableElement("CycleUnit",true)
				disableElement("CycleNum",true)
				setElement("CycleUnit","")
				setElement("CycleUnitDR","")	//add by csj 20190214 清空计量周期DR
				setElement("CycleNum","")
				setItemRequire("CycleNum",false)
				setItemRequire("CycleUnit",false)
				setItemRequire("CycleUnitDR",false)

			}
			else
			{
				disableElement("SDate",true)
				disableElement("EDate",true)
				disableElement("CycleUnit",false)
				disableElement("CycleNum",false)
				//modify by lmm 2019-01-10 end 802966
				setItemRequire("CycleNum",true)
				setItemRequire("CycleUnit",true)
				setItemRequire("CycleUnitDR",true)
				
				//add by lmm 2091-10-14 1036810 end
			}
		}
		
	});
	fillCheckBox();
}
///add by lmm 2018-11-01
///执行勾选框时间后值丢失重新赋值
function fillCheckBox()
{
	var RowID=getElementValue("RowID");
  	if ((RowID=="")||(RowID==0)) return;
  	
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "GetOneMaintPlan",RowID);
	list=list.replace(/\ +/g,"")	//去掉空格
	list=list.replace(/[\r\n]/g,"")	//去掉回车换行
	list=list.split("^");
	setElement("TempPlanflag",list[45]);  //add by lmm 2018-11-08
	setElement("FixTimeflag",list[46]);
	
	
}

/*
 *Description:计划填充事件
 *author:李苗苗
*/
function FillData()
{
	
	var RowID=getElementValue("RowID");
  	if ((RowID=="")||(RowID==0)) return;
  	
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "GetOneMaintPlan",RowID);
	//list=list.replace(/\ +/g,"")	//去掉空格   modify by lmm 2020-04-10 1268230
	list=list.replace(/[\r\n]/g,"")	//去掉回车换行
	list=list.split("^");

	var sort=50;
	setElement("Name",list[0]);
	setElement("Type",list[1]);
	setElement("Content",list[5]);   //add by lmm 2018-11-08 743473
	setElement("CycleNum",list[6]);
	setElement("CycleUnitDR",list[7]);
	setElement("MaintTypeDR",list[8]);
	setElement("FromDate",list[9]);
	//setElement("EndDate",list[10]);
	setElement("PreWarnDaysNum",list[11]);
	setElement("MaintFee",list[12]);
	setElement("MaintLocDR",list[13]);   //modify by lmm 2018-11-16 752023
	setElement("MaintUserDR",list[14]);
	//setElement("MeasureFlag",list[17]);
	setElement("MeasureDeptDR",list[18]);
	setElement("MeasureHandler",list[19]);
	setElement("MeasureTel",list[20]);
	setElement("ServiceDR",list[21]);
	setElement("ServiceHandler",list[22]);
	setElement("ServiceTel",list[23]);
	setElement("Remark",list[24]);
	setElement("Status",list[25]);
	setElement("InvalidFlag",list[35]);
	setElement("Hold1",list[39]);
	setElement("Hold2",list[40]);
	setElement("Hold3",list[41]);
	setElement("Hold4",list[42]);
	setElement("Hold5",list[43]);
	
	setElement("CycleUnit",list[sort+3]);
	setElement("MaintType",list[sort+4]);
	setElement("MaintLoc",list[sort+5]);  //modify by lmm 2018-11-16 752023
	setElement("MaintUser",list[sort+6]);	//modify by csj 2020-02-17 需求号：1192187
	setElement("MeasureDept",list[sort+9]);
	setElement("Service",list[sort+10]);
	setElement("No",list[sort+16]);
			
	//setElement("TotalFee",list[44]);
	setElement("TempPlanflag",list[45]);  //add by lmm 2018-11-08
	setElement("FixTimeflag",list[46]);
	setElement("SDate",list[47]);
	setElement("EDate",list[48]);
	setElement("PlanNo",list[49]);
	//setElement("CycleUnit",list[7],"value");	
	setElement("CycleUnit",list[sort+3]);
	
}

/*
 *Description:计划保存事件
 *params:SourceType：列表类型序号 RowID:当前行RowID index：当前行行号
 *author:李苗苗
*/
function BSave_Clicked() 
{	

	var ReqNum=0;
	if (checkMustItemNull()) return	//add by lmm 2019-09-09 1018529
	
	//add by lmm 2020-04-24 begin 1288845
	
	if((getElementValue("SDate")!="")&&(getElementValue("EDate")!=""))
	{
		var SDate = tkMakeServerCall("web.DHCEQCommon", "TransValueFromPage",getElementValue("SDate"),"date");
		var EDate = tkMakeServerCall("web.DHCEQCommon", "TransValueFromPage",getElementValue("EDate"),"date");
		if (SDate>EDate)
		{
			alertShow("固定时间范围开始日期大于结束日期,请修正.");
			return;
		}
	}
	//add by lmm 2020-04-24 end 1288845
	if(CheckInvalidData()) return;
	//调用设备范围  条件判断
	if($("#equiprange")[0].contentWindow.CheckGridData()) return;
	
	var combindata=GetMaintInfoList();
	var EquipRangeval=$("#equiprange")[0].contentWindow.GetEquipRangeval(); //调用设备范围 获取设备指定范围标识
	
	var EquipRangevalList=$("#equiprange")[0].contentWindow.GetEquipRangevalList(); //调用设备范围 获取设备指定范围数据
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "SaveData",combindata,EquipRangeval,EquipRangevalList);
	var Rtn=Rtn.split("^")
	if ($('#RowID').val()=="") $('#RowID').val(Rtn[2])
	if (Rtn[2]<0) 
	{
		alertShow("更新失败！");
		return;	
	}
		alertShow("更新成功！");
	//****************************
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		window.location.href= 'dhceq.em.meterageplan.csp?RowID='+$('#RowID').val()+"&BussType="+getElementValue("BussType")+"&Status=0&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}
	else if (getElementValue("BussType")==1)
	{
		window.location.href= 'dhceq.em.maintplan.csp?RowID='+$('#RowID').val()+"&BussType="+getElementValue("BussType")+"&Status=0&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}	
	else
	{
		window.location.href= 'dhceq.em.inspectplan.csp?RowID='+$('#RowID').val()+"&BussType="+getElementValue("BussType")+"&Status=0&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}	


}



/*
 *Description:获取计划信息串
 *author:李苗苗
*/
function GetMaintInfoList()
{
	var combindata="";
  	combindata=getElementValue("RowID") ; 
	combindata=combindata+"^"+getElementValue("Name") ; 
	combindata=combindata+"^"+getElementValue("BussType") ; 
	combindata=combindata+"^"; 
	combindata=combindata+"^"; 
	combindata=combindata+"^"; 
	combindata=combindata+"^"+getElementValue("Content");  //modify by lmm 2018-11-08 743473
	combindata=combindata+"^"+getElementValue("CycleNum") ; 
	combindata=combindata+"^"+getElementValue("CycleUnitDR"); 
	combindata=combindata+"^"+getElementValue("MaintTypeDR"); 
	combindata=combindata+"^"+getElementValue("FromDate"); 
	combindata=combindata+"^"; //+getElementValue("EndDate") 
	combindata=combindata+"^"+getElementValue("PreWarnDaysNum"); 
	combindata=combindata+"^"+getElementValue("MaintFee"); 
	combindata=combindata+"^"+getElementValue("MaintLocDR");  //modify by lmm 2018-11-16 752023
	combindata=combindata+"^"+getElementValue("MaintUserDR") ; 
	combindata=combindata+"^"+getElementValue("MaintModeDR") ; 
	combindata=combindata+"^"; //+getElementValue("ContractDR")
	combindata=combindata+"^"; //+getElementValue("MeasureFlag") 
	combindata=combindata+"^"+getElementValue("MeasureDeptDR") ; 
	combindata=combindata+"^"+getElementValue("MeasureHandler") ; 
	combindata=combindata+"^"+getElementValue("MeasureTel"); 
	combindata=combindata+"^"+getElementValue("ServiceDR"); 
	combindata=combindata+"^"+getElementValue("ServiceHandler"); 
	combindata=combindata+"^"+getElementValue("ServiceTel"); 
	combindata=combindata+"^"+getElementValue("Remark"); 
	combindata=combindata+"^"+getElementValue("Status"); 
	combindata=combindata+"^"+getElementValue("InvalidFlag"); 
	combindata=combindata+"^"+getElementValue("Hold1"); 
	combindata=combindata+"^"+getElementValue("Hold2"); 
	combindata=combindata+"^"+getElementValue("Hold3"); 
	combindata=combindata+"^"+getElementValue("Hold4"); 
	combindata=combindata+"^"+getElementValue("Hold5"); 
	combindata=combindata+"^"+getElementValue("TotalFee"); 
	combindata=combindata+"^"+getElementValue("TempPlanflag");   //modify by lmm 2019-01-10 802911
	combindata=combindata+"^"+getElementValue("FixTimeflag");   

	combindata=combindata+"^"+getElementValue("SDate"); 
	combindata=combindata+"^"+getElementValue("EDate"); 
	
	return combindata;
}
/*
 *Description:计划提交事件
 *author:李苗苗
*/
function BSubmit_Clicked()
{
	if ($('#RowID').val()=="") return;
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "SubmitData",$('#RowID').val());
	//modify by lmm 2020-03-27 1247417 
	if (Rtn<0) 
	{
		alertShow("提交失败！");
		return;	
	}
		alertShow("提交成功！");
	//****************************	
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		window.location.href= 'dhceq.em.meterageplan.csp?RowID='+Rtn+"&QXType="+getElementValue("QXType")+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR")+"&Status=2&SourceType=2";
	}
	else if (getElementValue("BussType")==1)
	{
		window.location.href= 'dhceq.em.maintplan.csp?RowID='+Rtn+"&QXType="+getElementValue("QXType")+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR")+"&Status=2&SourceType=2";
	}
	else
	{
		window.location.href= 'dhceq.em.inspectplan.csp?RowID='+Rtn+"&QXType="+getElementValue("QXType")+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR")+"&Status=2&SourceType=2";
	}

	
}
/*
 *Description:按钮灰化事件
 *author:李苗苗
*/
//modify by lmm 2020-04-27
function SetEnabled()
{
	//modify by zc0053 2019-11-25  取值问题  begin
	var Status=getElementValue("Status"); //$("#Status").val();
	var ReadOnly=getElementValue("ReadOnly");  //$("#ReadOnly").val;
	//modify by zc0053 2019-11-25  取值问题  end
	if (Status=="")
	{
		jQuery("#BSave").linkbutton("enable")
		jQuery("#BSubmit").linkbutton("disable")  	//modify by zc0053 2019-11-25 提交按钮灰化  begin
		jQuery("#BSubmit").unbind();   				//modify by zc0053 2019-11-25 提交按钮灰化  end
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BDelete").unbind();
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").unbind();
		//DisableBElement("BUpdate",true);
		//DisableBElement("BDelete",true);
		//DisableBElement("BSubmit",true);
	}
	else if (Status=="0")
	{
		jQuery("#BSave").linkbutton("enable")
		jQuery("#BSubmit").linkbutton("enable")
		jQuery("#BDelete").linkbutton("enable")
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").unbind();
	}
	else if (Status=="2")
	{
		jQuery("#BSave").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSave").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BCancelSubmit").linkbutton("enable")
		$('#DHCEQLoc').datagrid('hideColumn','TDeleteList')
		$('#DHCEQMastitem').datagrid('hideColumn','TDeleteList')
		$('#DHCEQEquip').datagrid('hideColumn','TDeleteList')		
		//DisableBElement("BUpdate",true);
		//DisableBElement("BDelete",true);
		//DisableBElement("BSubmit",true);
	}	
	else if (Status=="3")
	{
		jQuery("#BSave").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSave").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").unbind();
		$('#DHCEQLoc').datagrid('hideColumn','TDeleteList')
		$('#DHCEQMastitem').datagrid('hideColumn','TDeleteList')
		$('#DHCEQEquip').datagrid('hideColumn','TDeleteList')		
	}
	//modify by lmm 2020-05-26
	if (ReadOnly=="1")
	{
		jQuery("#BSave").linkbutton("disable")
		jQuery("#BSubmit").linkbutton("disable")
		jQuery("#BDelete").linkbutton("disable")
		jQuery("#BSave").unbind();
		jQuery("#BSubmit").unbind();
		jQuery("#BDelete").unbind();
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").unbind();
	}	
	//modify by lmm 2020-05-26

}
/*
 *Description:按钮灰化事件
 *params:vElementID：按钮id vValue：灰化值
 *author:李苗苗
*/
function DisableBElement(vElementID,vValue)
{
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		if (vValue==true)
		{
			//按钮灰化处理
			jQuery("#"+vElementID).linkbutton("disable")
			
		}
		else
		{
			//按钮启用
			jQuery("#"+vElementID).linkbutton("enable")
		}
	}
}
/*
 *Description:计划删除事件
 *params:SourceType：列表类型序号 RowID:当前行RowID index：当前行行号
 *author:李苗苗
*/
function BDelete_Clicked() 
{
	messageShow("confirm","","","是否删除计划单据?","",DeleteData,"");
}
function DeleteData() 
{
	var RowID=getElementValue("RowID");
	var SourceType=getElementValue("SourceType");
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange","GetOneEquipRange",RowID,SourceType);
	list=list.replace(/\ +/g,"")	//去掉空格
	list=list.replace(/[\r\n]/g,"")	//去掉回车换行
	list=list.split("^");
	var EquipRangeDR=list[0];
	//var DeleteEquipRangevalList=EquipRangedelvalList();
  	if (RowID=="") return;
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "DeleteData",RowID,EquipRangeDR);
	if (Rtn<0) 
	{
		alertShow("更新失败！");
		return;	
	}
		alertShow("更新成功！");
	//****************************
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		window.location.href= 'dhceq.em.meterageplan.csp?RowID='+"&BussType="+getElementValue("BussType")+"&Status=&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}
	else if (getElementValue("BussType")==1)
	{
		window.location.href= 'dhceq.em.maintplan.csp?RowID='+"&BussType="+getElementValue("BussType")+"&Status=&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}	
	else
	{
		window.location.href= 'dhceq.em.inspectplan.csp?RowID='+"&BussType="+getElementValue("BussType")+"&Status=&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}	
		
}
/*
 *Description:数值框值判断
 *author:李苗苗
*/
///modify by lmm 2019-01-13 增加固定时间判断条件
function CheckInvalidData()
{
	if ((($("#FixTimeflag").is(':checked')==false))&&(IsValidateNumber(getElementValue("PreWarnDaysNum"),0,0,0,1)==0))
	{
		alertShow("预警天数异常,请修正.");
		return true;
	}
	//modify by lmm 2019-01-29 820696
	if ((IsValidateNumber(getElementValue("CycleNum"),0,0,0,1)==0)&&($("#FixTimeflag").is(':checked')==false)&&($("#TempPlanflag").is(':checked')==false))
	{
		alertShow("保养周期数据异常,请修正.");
		return true;
	}
	return false;
}

///add by lmm 2018-11-01 下拉框dr赋值
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	//add by csj 20190812 根据维护的计量部门赋计量人、计量电话值
	if(vElementID=="MeasureDept")
	{
		setElement("MeasureHandler",item.TContPerson)
		setElement("MeasureTel",item.TTel)
	}
	//add by lmm 2019-08-29 990906 begin
	if (vElementID=="Service")
	{
		setElement("ServiceHandler",item.TContPerson)
		setElement("ServiceTel",item.TTel)
	}
	//add by lmm 2019-08-29 990906 end
	
}
///add by lmm 2018-11-01 下拉框dr值清空
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
}
///add by lmm 2019-10-28 1040240 LMM0048
function AppendFileDetail()
{
	$("#equiprange")[0].contentWindow.EquipList_Clicked()
	
}

function BCancelSubmit_Click()
{
	var RowID=getElementValue("RowID")
  	if (RowID=="") return;
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "CancelSubmitData",RowID);
	if (Rtn<0) 
	{
		alertShow("更新失败！");
		return;	
	}
		alertShow("更新成功！");
	//****************************
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		window.location.href= 'dhceq.em.meterageplan.csp?RowID='+getElementValue("RowID")+"&BussType="+getElementValue("BussType")+"&Status="+getElementValue("Status")+"&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}
	else if (getElementValue("BussType")==1)
	{
		window.location.href= 'dhceq.em.maintplan.csp?RowID='+getElementValue("RowID")+"&BussType="+getElementValue("BussType")+"&Status="+getElementValue("Status")+"&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}	
	else
	{
		window.location.href= 'dhceq.em.inspectplan.csp?RowID='+getElementValue("RowID")+"&BussType="+getElementValue("BussType")+"&Status="+getElementValue("Status")+"&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}	
}

