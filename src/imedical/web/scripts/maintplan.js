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
	setRequiredElements("Name^PreWarnDaysNum^FromDate^MaintUser");  // MZY0111	2401927		2022-01-14
	initMessage();
	//add by lmm 2019-09-09 1018529
	defindTitleStyle(); 
	initButtonWidth();
	initButton();
	initLookUp();
	initCycleTypeData();	//CZF0134 2021-02-23
	cycleTypeChange();		// MZY0083	2034404		2021-07-19
	initTopPanel();
	jQuery("#BCancelSubmit").linkbutton({iconCls: 'icon-w-cancel'});
	jQuery("#BCancelSubmit").on("click", BCancelSubmit_Click);	
	muilt_Tab()  //add by lmm 2020-06-29 回车下一输入框
	// MZY0082	1965418		2021-07-14	修正保养科室赋值
	if (getElementValue("MaintLocDesc")!="") setElement("MaintLoc",getElementValue("MaintLocDesc"));
	jQuery("#BExecutePlan").linkbutton({iconCls: 'icon-w-stamp'});
	jQuery("#BExecutePlan").on("click", BExecutePlan_Click);
	jQuery("#BUpdate").linkbutton({iconCls: 'icon-w-save'});
	jQuery("#BUpdate").on("click", BUpdate_Click);
	jQuery("#BClose").linkbutton({iconCls: 'icon-w-close'});
	jQuery("#BClose").on("click", BClose_Click);
}


//初始化查询头面板
function initTopPanel()
{
	// MZY0076	2021-05-25
	$("#MonthStr").datebox({
		onChange: function(newVal,oldValue){
			//alertShow(newVal+":"+oldValue)
			var list = tkMakeServerCall("web.DHCEQReport", "GetReportDate",newVal,"",3);
			list=list.split("^");
			setElement("SDate", list[0]);
			setElement("EDate", list[1]);
		}
	});
	FillData();
	SetEnabled();
	ContrlMaintCheck();
}
//CZF0134 2021-02-23
function initCycleTypeData()
{
	// MZY0102	2160563		2021-11-24	计量计划去掉风险等级
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var CycleType = $HUI.combobox('#CycleType',{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[
				{
					id: '1',
					text: '固定周期'
				},
				{
					id: '2',
					text: '固定时间(周期)'
				}
			],
			onSelect:function(){
	                cycleTypeChange();
	            },
		});
	}
	else
	{
		var CycleType = $HUI.combobox('#CycleType',{
		valueField:'id', textField:'text',panelHeight:"auto",
		data:[{
				id: '1',
				text: '固定周期'
			},{
				id: '2',
				text: '固定时间(周期)'
			},{
				id: '3',
				text: '固定时间(一次)'
			},{
				id: '4',
				text: '根据风险等级'
			/*},{	// MZY0120	2022-04-13	增加临时计划
				id: '5',
				text: '固定月份(周期)'
			},{
				id: '6',
				text: '固定月份(一次)'	*/
			}],
			onSelect:function(){
                cycleTypeChange();
            },
		});
	}
}	
// MZY0091	2069079		2021-08-26	拆分为清空元素和按钮控制
//周期类型行选择事件
function cycleTypeChange()
{
	var CycleType=getElementValue("CycleType")
	if(CycleType==1)	//固定周期
	{
		setElement("CycleUnit","")
		setElement("CycleUnitDR","")
		setElement("CycleNum","")
		setElement("SDate","")
		setElement("EDate","")
	}
	else if ((CycleType==2)||(CycleType==5))	//固定时间(周期)	固定月份(周期)
	{
		setElement("CycleUnit","年")
		setElement("CycleUnitDR","1")
		setElement("CycleNum","1")
		setElement("SDate","")
		setElement("EDate","")
	}
	else if ((CycleType==3)||(CycleType==6))	//固定时间(一次)	固定月份(一次)
	{
		setElement("CycleUnit","")
		setElement("CycleUnitDR","")
		setElement("CycleNum","")
		setElement("SDate","")
		setElement("EDate","")
	}
	else if (CycleType==4)					//风险等级
	{
		setElement("CycleUnit","")
		setElement("CycleUnitDR","")
		setElement("CycleNum","")
		setElement("SDate","")
		setElement("EDate","")
	}
	disableElementForChange();
}
function disableElementForChange()
{
	var CycleType=getElementValue("CycleType")
	if(CycleType==1)	//固定周期
	{
		disableElement("CycleUnit",false)
		disableElement("CycleNum",false)
		disableElement("SDate",true)
		disableElement("EDate",true)
	}
	else if ((CycleType==2)||(CycleType==5))	//固定时间(周期)	固定月份(周期)
	{
		disableElement("CycleUnit",true)
		disableElement("CycleNum",true)
		// MZY0099	2200320		2021-11-13
		disableElement("SDate",true)
		disableElement("EDate",true)
	}
	else if ((CycleType==3)||(CycleType==6))	//固定时间(一次)	固定月份(一次)
	{
		disableElement("CycleUnit",true)
		disableElement("CycleNum",true)
		disableElement("SDate",false)
		disableElement("EDate",false)
	}
	else if (CycleType==4)						//风险等级
	{
		disableElement("CycleUnit",true)
		disableElement("CycleNum",true)
		disableElement("SDate",true)
		disableElement("EDate",true)
	}
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
				setItemRequire("CycleNum",true)
				setItemRequire("CycleUnit",true)
				setItemRequire("CycleUnitDR",true)
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
	setElement("CycleType",list[45]);  //CZF0134 2021-02-23
	setElement("FeeType",list[46]);	
	setElement("SDate",list[47]);
	setElement("EDate",list[48]);
	setElement("PlanNo",list[49]);
	//setElement("CycleUnit",list[7],"value");	
	setElement("CycleUnit",list[sort+3]);
	setElement("MPHold1_SSUSRName",list[sort+17]);	//czf 2021-02-01 1756587
	// MZY0076	2021-05-25
	if (list[47]!="")
	{
		//$('#MonthStr').datebox('setValue', "2021-04-06")
		setElement("MonthStr", list[47].substring(0,7));
	}
}

/*
 *Description:计划保存事件
 *params:SourceType：列表类型序号 RowID:当前行RowID index：当前行行号
 *author:李苗苗
*/
function BSave_Clicked()
{	
	if (checkMustItemNull()) return	//add by lmm 2019-09-09 1018529
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
	// MZY0076	2021-05-25
	var combindata=GetMaintInfoList();
	var EquipRangeval="";
	var EquipRangevalList="";
	if (jQuery("#equiprange").length>0)
	{
		//调用设备范围  条件判断
		if ($("#equiprange")[0].contentWindow.CheckGridData()) return;
		EquipRangeval=$("#equiprange")[0].contentWindow.GetEquipRangeval(); //调用设备范围 获取设备指定范围标识
		EquipRangevalList=$("#equiprange")[0].contentWindow.GetEquipRangevalList(); //调用设备范围 获取设备指定范围数据
	}
	else
	{
		var EquipRangeval="^^2^^N^N^N^N^Y^N";
		var EquipRangevalList="";
		var EquipDRList=getElementValue("EquipDRStr").split(",");
		for (var i = 0; i < EquipDRList.length; i++) 
		{
			if (EquipRangevalList!="") EquipRangevalList=EquipRangevalList+"&";
			EquipRangevalList=EquipRangevalList+"^5^"+EquipDRList[i]+"^Y";
		}
	}
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "SaveData",combindata,EquipRangeval,EquipRangevalList);
	var Rtn=Rtn.split("^")
	if ($('#RowID').val()=="") $('#RowID').val(Rtn[1])	//CZF0134 2021-02-23
	if (Rtn[1]<0) 
	{
		alertShow("更新失败！");
		return;	
	}
		alertShow("更新成功！");
	//****************************
	setElement("EquipRangeDR",Rtn[2]);	//CZF0134 2021-02-23 begin
	var url=""
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		url = 'dhceq.em.meterageplan.csp?RowID='+$('#RowID').val()+"&BussType="+getElementValue("BussType")+"&Status=0&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR")+"&EquipRangeDR="+getElementValue("EquipRangeDR");
	}
	else if (jQuery("#equiprange").length==0)
	{
		url = 'dhceq.em.maintplansimple.csp?RowID='+$('#RowID').val()+"&EquipDRStr="+getElementValue("EquipDRStr")+"&Status=0&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR")+"&EquipRangeDR="+getElementValue("EquipRangeDR");
	}
	else if (getElementValue("BussType")==1)
	{
		url = 'dhceq.em.maintplan.csp?RowID='+$('#RowID').val()+"&BussType="+getElementValue("BussType")+"&Status=0&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR")+"&EquipRangeDR="+getElementValue("EquipRangeDR");
	}	
	else
	{
		url ='dhceq.em.inspectplan.csp?RowID='+$('#RowID').val()+"&BussType="+getElementValue("BussType")+"&Status=0&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR")+"&EquipRangeDR="+getElementValue("EquipRangeDR");	//CZF0134 2021-02-23 end
	}
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;
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
	combindata=combindata+"^"+getElementValue("CycleNum"); 
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
	combindata=combindata+"^"+getElementValue("CycleType"); 	//周期类型 //CZF0134 2021-02-23
	combindata=combindata+"^"+getElementValue("FeeType");   	//费用类型
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
		//Modefied by zc0122 2022-10-12 修改返回值 begin
		if (Rtn=="-1001")
		{
			alertShow("当前计划单存在未进行风险等级的信息!");
		}
		else
		{
			alertShow("提交失败！");
		}
		//Modefied by zc0122 2022-10-12 修改返回值 end
		return;	
	}
		alertShow("提交成功！");
	var url = "";
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		url = 'dhceq.em.meterageplan.csp?RowID='+Rtn+"&QXType="+getElementValue("QXType")+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR")+"&Status=2&SourceType=2"+"&EquipRangeDR="+getElementValue("EquipRangeDR");	//CZF0134 2021-02-23 begin
	}
	else if (getElementValue("BussType")==1)
	{
		// Modfied by zc0122 2022-10-12 增加入参AddFlag begin
		if (getElementValue("AddFlag")==1)
		{
			url = 'dhceq.em.maintplansimple.csp?RowID='+$('#RowID').val()+"&EquipDRStr="+getElementValue("EquipDRStr")+"&Status=2&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR")+"&EquipRangeDR="+getElementValue("EquipRangeDR")+"&AddFlag="+getElementValue("AddFlag");
		}
		else
		{
			url = 'dhceq.em.maintplan.csp?RowID='+Rtn+"&QXType="+getElementValue("QXType")+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR")+"&Status=2&SourceType=2"+"&EquipRangeDR="+getElementValue("EquipRangeDR");
		
		}
		// Modfied by zc0122 2022-10-12 增加入参AddFlag  end
	}
	else
	{
		url = 'dhceq.em.inspectplan.csp?RowID='+Rtn+"&QXType="+getElementValue("QXType")+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR")+"&Status=2&SourceType=2"+"&EquipRangeDR="+getElementValue("EquipRangeDR");	//CZF0134 2021-02-23 end
	}
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;
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
		disableElement("BSave",false);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").unbind();
		// MZY0093	2021-09-08
		jQuery("#BExecutePlan").linkbutton("disable");
		jQuery("#BExecutePlan").unbind();
	}
	else if (Status=="0")
	{
		disableElement("BSave",false);
		disableElement("BDelete",false);
		disableElement("BSubmit",false);
		
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").unbind();
		// MZY0120	2022-04-13
		jQuery("#BExecutePlan").linkbutton("disable");
		jQuery("#BExecutePlan").unbind();
	}
	else if (Status=="2")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		
		jQuery("#BCancelSubmit").linkbutton("enable")
		$('#DHCEQLoc').datagrid('hideColumn','TDeleteList')
		$('#DHCEQMastitem').datagrid('hideColumn','TDeleteList')
		$('#DHCEQEquip').datagrid('hideColumn','TDeleteList')		
		//DisableBElement("BDelete",true);
		//DisableBElement("BSubmit",true);
		// MZY0093	2021-09-08
		jQuery("#BUpdate").linkbutton("disable");
		jQuery("#BUpdate").unbind();
		//MZY0120	2022-04-13
		//jQuery("#BExecutePlan").linkbutton("disable");
		//jQuery("#BExecutePlan").unbind();
	}	
	else if (Status=="3")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").unbind();
		$('#DHCEQLoc').datagrid('hideColumn','TDeleteList')
		$('#DHCEQMastitem').datagrid('hideColumn','TDeleteList')
		$('#DHCEQEquip').datagrid('hideColumn','TDeleteList')
		// MZY0093	2021-09-08
		jQuery("#BUpdate").linkbutton("disable");
		jQuery("#BUpdate").unbind();
		jQuery("#BExecutePlan").linkbutton("disable");
		jQuery("#BExecutePlan").unbind();
	}
	//modify by lmm 2020-05-26
	if (ReadOnly=="1")
	{
		disableElement("BSave",true);
		disableElement("BDelete",true);
		disableElement("BSubmit",true);
		
		jQuery("#BCancelSubmit").linkbutton("disable")
		jQuery("#BCancelSubmit").unbind();
		// MZY0093	2021-09-08
		jQuery("#BUpdate").linkbutton("disable");
		jQuery("#BUpdate").unbind();
		jQuery("#BExecutePlan").linkbutton("disable")
		jQuery("#BExecutePlan").unbind();
	}	
	//MZY0074	1833242		2021-04-30
	if($("#FixTimeflag").is(':checked')==true)
	{
		disableElement("SDate",false);
		disableElement("EDate",false);
		disableElement("CycleUnit",true);
		disableElement("CycleNum",true);
	}
	// MZY0091	2069079		2021-08-26
	disableElementForChange();
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
	var url="";
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		url= 'dhceq.em.meterageplan.csp?RowID='+"&BussType="+getElementValue("BussType")+"&Status=&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}
	else if (getElementValue("BussType")==1)
	{
		url= 'dhceq.em.maintplan.csp?RowID='+"&BussType="+getElementValue("BussType")+"&Status=&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}	
	else
	{
		url= 'dhceq.em.inspectplan.csp?RowID='+"&BussType="+getElementValue("BussType")+"&Status=&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;
}
/*
 *Description:数值框值判断
 *author:李苗苗
*/
///modify by lmm 2019-01-13 增加固定时间判断条件
function CheckInvalidData()
{
	if ((((CycleType==2)))&&(IsValidateNumber(getElementValue("PreWarnDaysNum"),0,0,0,1)==0))	//CZF0134 2021-02-23 begin
	{
		alertShow("预警天数异常,请修正.");
		return true;
	}
	//modify by lmm 2019-01-29 820696
	var CycleType=getElementValue("CycleType")
	if (((IsValidateNumber(getElementValue("CycleNum"),0,0,0,1)==0)||(IsValidateNumber(getElementValue("CycleUnitDR"),0,0,0,1)==0))&&(CycleType==1))		// MZY0082	1958011		2021-07-14
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
	//add by czf 2021-02-01 1756587
	if (vElementID=="MPHold1_SSUSRName")
	{
		setElement("Hold1",item.TRowID)
	}
}
///add by lmm 2018-11-01 下拉框dr值清空
function clearData(vElementID)
{
	setElement(vElementID+"DR","")
	if (vElementID=="MPHold1_SSUSRName")	//add by czf 2021-02-01 1756587
	{
		setElement("Hold1",item.TRowID)
	}
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
	var url="";
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		url= 'dhceq.em.meterageplan.csp?RowID='+getElementValue("RowID")+"&BussType="+getElementValue("BussType")+"&Status="+getElementValue("Status")+"&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}
	else if (getElementValue("BussType")==1)
	{
		url= 'dhceq.em.maintplan.csp?RowID='+getElementValue("RowID")+"&BussType="+getElementValue("BussType")+"&Status="+getElementValue("Status")+"&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}	
	else
	{
		url= 'dhceq.em.inspectplan.csp?RowID='+getElementValue("RowID")+"&BussType="+getElementValue("BussType")+"&Status="+getElementValue("Status")+"&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR");
	}
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;	
}
// MZY0076	2021-05-25
function BClose_Click()
{
	//websys_showModal("options").mth();
	closeWindow('modal');
}
function BUpdate_Click()
{
	if (checkMustItemNull()) return
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
	if(CheckInvalidData()) return;
	// MZY0093	2021-09-08
	if ($('#RowID').val()=="")
	{
		var combindata=GetMaintInfoList();
		var EquipRangeval="";
		var EquipRangevalList="";
		if (jQuery("#equiprange").length>0)
		{
			//调用设备范围  条件判断
			if ($("#equiprange")[0].contentWindow.CheckGridData()) return;
			EquipRangeval=$("#equiprange")[0].contentWindow.GetEquipRangeval(); //调用设备范围 获取设备指定范围标识
			EquipRangevalList=$("#equiprange")[0].contentWindow.GetEquipRangevalList(); //调用设备范围 获取设备指定范围数据
		}
		else
		{
			var EquipRangeval="^^2^^N^N^N^N^Y^N";
			var EquipRangevalList="";
			var EquipDRList=getElementValue("EquipDRStr").split(",");
			for (var i = 0; i < EquipDRList.length; i++) 
			{
				// $CASE(typedr,"":"","1":"类组","2":"类型","3":"分类","4":"科室","5":"设备","6":"设备项")
				if (EquipRangevalList!="") EquipRangevalList=EquipRangevalList+"&";
				EquipRangevalList=EquipRangevalList+"^5^"+EquipDRList[i]+"^Y";
				//EquipRangevalList="^5^23^Y&^5^22^Y"
			}
		}
		var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "SaveData",combindata,EquipRangeval,EquipRangevalList);
	}
	else
	{
		combindata=$('#RowID').val();
		combindata=combindata+"^"+getElementValue("Name");
		combindata=combindata+"^"+getElementValue("MaintLocDR");
		combindata=combindata+"^"+getElementValue("MaintUserDR");
		combindata=combindata+"^"+getElementValue("SDate");
		combindata=combindata+"^"+getElementValue("EDate");
		var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "SaveDataSimple",combindata);
	}
	var SaveRtn=Rtn.split("^");
	 $('#RowID').val(SaveRtn[1]);
	if (SaveRtn[1]<0) 
	{
		alertShow("更新失败！");
		return;	
	}
	var url='dhceq.em.maintplansimple.csp?RowID='+$('#RowID').val()+"&EquipDRStr="+getElementValue("EquipDRStr")+"&Status=0&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR")+"&EquipRangeDR="+getElementValue("EquipRangeDR")+"&AddFlag="+getElementValue("AddFlag");
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
}
function BExecutePlan_Click()
{
	// BAssign_Clicked
	// BUpdate_Click();	 MZY0093	2021-09-08
	/*	MZY0120	2022-04-13
	var SubmitRtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "SubmitData", getElementValue("RowID"));
	if (SubmitRtn<0)
	{
		alertShow("提交失败！");
		return;
	}*/
	if ((getElementValue("MaintUserDR")=="")||(getElementValue("MonthStr")==""))
	{
		alertShow("请选择分派的'维护工程师'和'维护月份' !")
	}
	else
	{
		messageShow("confirm","","","本计划单分派维护工程师: "+getElementValue("MaintUser")+"("+getElementValue("MonthStr")+")", "", Assign)
	}
}
function Assign()
{
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "Assign", getElementValue("RowID"), getElementValue("MaintLocDR"), getElementValue("MaintUserDR"), getElementValue("SDate"), getElementValue("EDate"));
	if (Rtn<0)
	{
		alertShow("操作失败！ "+Rtn);
	}
	else
	{
		alertShow("操作成功！");
		// MZY0083	2033451		2021-07-19
		var url='dhceq.em.maintplansimple.csp?RowID='+$('#RowID').val()+'&ReadOnly=1';
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
}
