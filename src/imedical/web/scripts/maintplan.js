//�������
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
	muilt_Tab()  //add by lmm 2020-06-29 �س���һ�����
	// MZY0082	1965418		2021-07-14	�����������Ҹ�ֵ
	if (getElementValue("MaintLocDesc")!="") setElement("MaintLoc",getElementValue("MaintLocDesc"));
	jQuery("#BExecutePlan").linkbutton({iconCls: 'icon-w-stamp'});
	jQuery("#BExecutePlan").on("click", BExecutePlan_Click);
	jQuery("#BUpdate").linkbutton({iconCls: 'icon-w-save'});
	jQuery("#BUpdate").on("click", BUpdate_Click);
	jQuery("#BClose").linkbutton({iconCls: 'icon-w-close'});
	jQuery("#BClose").on("click", BClose_Click);
}


//��ʼ����ѯͷ���
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
	// MZY0102	2160563		2021-11-24	�����ƻ�ȥ�����յȼ�
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		var CycleType = $HUI.combobox('#CycleType',{
			valueField:'id', textField:'text',panelHeight:"auto",
			data:[
				{
					id: '1',
					text: '�̶�����'
				},
				{
					id: '2',
					text: '�̶�ʱ��(����)'
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
				text: '�̶�����'
			},{
				id: '2',
				text: '�̶�ʱ��(����)'
			},{
				id: '3',
				text: '�̶�ʱ��(һ��)'
			},{
				id: '4',
				text: '���ݷ��յȼ�'
			/*},{	// MZY0120	2022-04-13	������ʱ�ƻ�
				id: '5',
				text: '�̶��·�(����)'
			},{
				id: '6',
				text: '�̶��·�(һ��)'	*/
			}],
			onSelect:function(){
                cycleTypeChange();
            },
		});
	}
}	
// MZY0091	2069079		2021-08-26	���Ϊ���Ԫ�غͰ�ť����
//����������ѡ���¼�
function cycleTypeChange()
{
	var CycleType=getElementValue("CycleType")
	if(CycleType==1)	//�̶�����
	{
		setElement("CycleUnit","")
		setElement("CycleUnitDR","")
		setElement("CycleNum","")
		setElement("SDate","")
		setElement("EDate","")
	}
	else if ((CycleType==2)||(CycleType==5))	//�̶�ʱ��(����)	�̶��·�(����)
	{
		setElement("CycleUnit","��")
		setElement("CycleUnitDR","1")
		setElement("CycleNum","1")
		setElement("SDate","")
		setElement("EDate","")
	}
	else if ((CycleType==3)||(CycleType==6))	//�̶�ʱ��(һ��)	�̶��·�(һ��)
	{
		setElement("CycleUnit","")
		setElement("CycleUnitDR","")
		setElement("CycleNum","")
		setElement("SDate","")
		setElement("EDate","")
	}
	else if (CycleType==4)					//���յȼ�
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
	if(CycleType==1)	//�̶�����
	{
		disableElement("CycleUnit",false)
		disableElement("CycleNum",false)
		disableElement("SDate",true)
		disableElement("EDate",true)
	}
	else if ((CycleType==2)||(CycleType==5))	//�̶�ʱ��(����)	�̶��·�(����)
	{
		disableElement("CycleUnit",true)
		disableElement("CycleNum",true)
		// MZY0099	2200320		2021-11-13
		disableElement("SDate",true)
		disableElement("EDate",true)
	}
	else if ((CycleType==3)||(CycleType==6))	//�̶�ʱ��(һ��)	�̶��·�(һ��)
	{
		disableElement("CycleUnit",true)
		disableElement("CycleNum",true)
		disableElement("SDate",false)
		disableElement("EDate",false)
	}
	else if (CycleType==4)						//���յȼ�
	{
		disableElement("CycleUnit",true)
		disableElement("CycleNum",true)
		disableElement("SDate",true)
		disableElement("EDate",true)
	}
}
///add by lmm 2018-11-01
///���������湴ѡ��ı��¼�
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
				setElement("CycleUnitDR","")	//add by csj 20190214 ��ռ�������DR
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
///ִ�й�ѡ��ʱ���ֵ��ʧ���¸�ֵ
function fillCheckBox()
{
	var RowID=getElementValue("RowID");
  	if ((RowID=="")||(RowID==0)) return;
  	
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "GetOneMaintPlan",RowID);
	list=list.replace(/\ +/g,"")	//ȥ���ո�
	list=list.replace(/[\r\n]/g,"")	//ȥ���س�����
	list=list.split("^");
	setElement("TempPlanflag",list[45]);  //add by lmm 2018-11-08
	setElement("FixTimeflag",list[46]);
}

/*
 *Description:�ƻ�����¼�
 *author:������
*/
function FillData()
{
	var RowID=getElementValue("RowID");
  	if ((RowID=="")||(RowID==0)) return;
  	
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "GetOneMaintPlan",RowID);
	//list=list.replace(/\ +/g,"")	//ȥ���ո�   modify by lmm 2020-04-10 1268230
	list=list.replace(/[\r\n]/g,"")	//ȥ���س�����
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
	setElement("MaintUser",list[sort+6]);	//modify by csj 2020-02-17 ����ţ�1192187
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
 *Description:�ƻ������¼�
 *params:SourceType���б�������� RowID:��ǰ��RowID index����ǰ���к�
 *author:������
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
			alertShow("�̶�ʱ�䷶Χ��ʼ���ڴ��ڽ�������,������.");
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
		//�����豸��Χ  �����ж�
		if ($("#equiprange")[0].contentWindow.CheckGridData()) return;
		EquipRangeval=$("#equiprange")[0].contentWindow.GetEquipRangeval(); //�����豸��Χ ��ȡ�豸ָ����Χ��ʶ
		EquipRangevalList=$("#equiprange")[0].contentWindow.GetEquipRangevalList(); //�����豸��Χ ��ȡ�豸ָ����Χ����
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
		alertShow("����ʧ�ܣ�");
		return;	
	}
		alertShow("���³ɹ���");
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
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;
}

/*
 *Description:��ȡ�ƻ���Ϣ��
 *author:������
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
	combindata=combindata+"^"+getElementValue("CycleType"); 	//�������� //CZF0134 2021-02-23
	combindata=combindata+"^"+getElementValue("FeeType");   	//��������
	combindata=combindata+"^"+getElementValue("SDate"); 
	combindata=combindata+"^"+getElementValue("EDate"); 
	
	return combindata;
}
/*
 *Description:�ƻ��ύ�¼�
 *author:������
*/
function BSubmit_Clicked()
{
	if ($('#RowID').val()=="") return;
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "SubmitData",$('#RowID').val());
	//modify by lmm 2020-03-27 1247417 
	if (Rtn<0) 
	{
		//Modefied by zc0122 2022-10-12 �޸ķ���ֵ begin
		if (Rtn=="-1001")
		{
			alertShow("��ǰ�ƻ�������δ���з��յȼ�����Ϣ!");
		}
		else
		{
			alertShow("�ύʧ�ܣ�");
		}
		//Modefied by zc0122 2022-10-12 �޸ķ���ֵ end
		return;	
	}
		alertShow("�ύ�ɹ���");
	var url = "";
	if ((getElementValue("BussType")==2)&&(getElementValue("MaintTypeDR")==5))
	{
		url = 'dhceq.em.meterageplan.csp?RowID='+Rtn+"&QXType="+getElementValue("QXType")+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR")+"&Status=2&SourceType=2"+"&EquipRangeDR="+getElementValue("EquipRangeDR");	//CZF0134 2021-02-23 begin
	}
	else if (getElementValue("BussType")==1)
	{
		// Modfied by zc0122 2022-10-12 �������AddFlag begin
		if (getElementValue("AddFlag")==1)
		{
			url = 'dhceq.em.maintplansimple.csp?RowID='+$('#RowID').val()+"&EquipDRStr="+getElementValue("EquipDRStr")+"&Status=2&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR")+"&EquipRangeDR="+getElementValue("EquipRangeDR")+"&AddFlag="+getElementValue("AddFlag");
		}
		else
		{
			url = 'dhceq.em.maintplan.csp?RowID='+Rtn+"&QXType="+getElementValue("QXType")+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR")+"&Status=2&SourceType=2"+"&EquipRangeDR="+getElementValue("EquipRangeDR");
		
		}
		// Modfied by zc0122 2022-10-12 �������AddFlag  end
	}
	else
	{
		url = 'dhceq.em.inspectplan.csp?RowID='+Rtn+"&QXType="+getElementValue("QXType")+"&BussType="+getElementValue("BussType")+"&MaintTypeDR="+getElementValue("MaintTypeDR")+"&Status=2&SourceType=2"+"&EquipRangeDR="+getElementValue("EquipRangeDR");	//CZF0134 2021-02-23 end
	}
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;
}
/*
 *Description:��ť�һ��¼�
 *author:������
*/
//modify by lmm 2020-04-27
function SetEnabled()
{
	//modify by zc0053 2019-11-25  ȡֵ����  begin
	var Status=getElementValue("Status"); //$("#Status").val();
	var ReadOnly=getElementValue("ReadOnly");  //$("#ReadOnly").val;
	//modify by zc0053 2019-11-25  ȡֵ����  end
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
 *Description:��ť�һ��¼�
 *params:vElementID����ťid vValue���һ�ֵ
 *author:������
*/
function DisableBElement(vElementID,vValue)
{
	var obj=document.getElementById(vElementID);
	if (obj)
	{
		if (vValue==true)
		{
			//��ť�һ�����
			jQuery("#"+vElementID).linkbutton("disable")
		}
		else
		{
			//��ť����
			jQuery("#"+vElementID).linkbutton("enable")
		}
	}
}
/*
 *Description:�ƻ�ɾ���¼�
 *params:SourceType���б�������� RowID:��ǰ��RowID index����ǰ���к�
 *author:������
*/
function BDelete_Clicked() 
{
	messageShow("confirm","","","�Ƿ�ɾ���ƻ�����?","",DeleteData,"");
}
function DeleteData() 
{
	var RowID=getElementValue("RowID");
	var SourceType=getElementValue("SourceType");
	var list = tkMakeServerCall("web.DHCEQ.EM.BUSEquipRange","GetOneEquipRange",RowID,SourceType);
	list=list.replace(/\ +/g,"")	//ȥ���ո�
	list=list.replace(/[\r\n]/g,"")	//ȥ���س�����
	list=list.split("^");
	var EquipRangeDR=list[0];
	//var DeleteEquipRangevalList=EquipRangedelvalList();
  	if (RowID=="") return;
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "DeleteData",RowID,EquipRangeDR);
	if (Rtn<0) 
	{
		alertShow("����ʧ�ܣ�");
		return;	
	}
		alertShow("���³ɹ���");
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
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href=url;
}
/*
 *Description:��ֵ��ֵ�ж�
 *author:������
*/
///modify by lmm 2019-01-13 ���ӹ̶�ʱ���ж�����
function CheckInvalidData()
{
	if ((((CycleType==2)))&&(IsValidateNumber(getElementValue("PreWarnDaysNum"),0,0,0,1)==0))	//CZF0134 2021-02-23 begin
	{
		alertShow("Ԥ�������쳣,������.");
		return true;
	}
	//modify by lmm 2019-01-29 820696
	var CycleType=getElementValue("CycleType")
	if (((IsValidateNumber(getElementValue("CycleNum"),0,0,0,1)==0)||(IsValidateNumber(getElementValue("CycleUnitDR"),0,0,0,1)==0))&&(CycleType==1))		// MZY0082	1958011		2021-07-14
	{
		alertShow("�������������쳣,������.");
		return true;
	}
	return false;
}

///add by lmm 2018-11-01 ������dr��ֵ
function setSelectValue(vElementID,item)
{
	setElement(vElementID+"DR",item.TRowID)
	//add by csj 20190812 ����ά���ļ������Ÿ������ˡ������绰ֵ
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
///add by lmm 2018-11-01 ������drֵ���
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
		alertShow("����ʧ�ܣ�");
		return;	
	}
		alertShow("���³ɹ���");
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
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
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
			alertShow("�̶�ʱ�䷶Χ��ʼ���ڴ��ڽ�������,������.");
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
			//�����豸��Χ  �����ж�
			if ($("#equiprange")[0].contentWindow.CheckGridData()) return;
			EquipRangeval=$("#equiprange")[0].contentWindow.GetEquipRangeval(); //�����豸��Χ ��ȡ�豸ָ����Χ��ʶ
			EquipRangevalList=$("#equiprange")[0].contentWindow.GetEquipRangevalList(); //�����豸��Χ ��ȡ�豸ָ����Χ����
		}
		else
		{
			var EquipRangeval="^^2^^N^N^N^N^Y^N";
			var EquipRangevalList="";
			var EquipDRList=getElementValue("EquipDRStr").split(",");
			for (var i = 0; i < EquipDRList.length; i++) 
			{
				// $CASE(typedr,"":"","1":"����","2":"����","3":"����","4":"����","5":"�豸","6":"�豸��")
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
		alertShow("����ʧ�ܣ�");
		return;	
	}
	var url='dhceq.em.maintplansimple.csp?RowID='+$('#RowID').val()+"&EquipDRStr="+getElementValue("EquipDRStr")+"&Status=0&SourceType=2&MaintTypeDR="+getElementValue("MaintTypeDR")+"&EquipRangeDR="+getElementValue("EquipRangeDR")+"&AddFlag="+getElementValue("AddFlag");
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
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
		alertShow("�ύʧ�ܣ�");
		return;
	}*/
	if ((getElementValue("MaintUserDR")=="")||(getElementValue("MonthStr")==""))
	{
		alertShow("��ѡ����ɵ�'ά������ʦ'��'ά���·�' !")
	}
	else
	{
		messageShow("confirm","","","���ƻ�������ά������ʦ: "+getElementValue("MaintUser")+"("+getElementValue("MonthStr")+")", "", Assign)
	}
}
function Assign()
{
	var Rtn = tkMakeServerCall("web.DHCEQ.EM.BUSMaintPlan", "Assign", getElementValue("RowID"), getElementValue("MaintLocDR"), getElementValue("MaintUserDR"), getElementValue("SDate"), getElementValue("EDate"));
	if (Rtn<0)
	{
		alertShow("����ʧ�ܣ� "+Rtn);
	}
	else
	{
		alertShow("�����ɹ���");
		// MZY0083	2033451		2021-07-19
		var url='dhceq.em.maintplansimple.csp?RowID='+$('#RowID').val()+'&ReadOnly=1';
		if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
			url += "&MWToken="+websys_getMWToken()
		}
		window.location.href= url;
	}
}
