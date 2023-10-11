//Ч�������ҳ
//CZF0133 2021-01-20
var LocColumns=getCurColumnsInfo('BA.G.LocBenefitInfo','','','');
var LocqueryParams={ClassName:"web.DHCEQ.BA.RPTList",QueryName:"GetLocBenefitInfo"};
var StatCatColumns=getCurColumnsInfo('BA.G.StatCatBenefitInfo','','','');
var StatCatqueryParams={ClassName:"web.DHCEQ.BA.RPTList",QueryName:"GetStatCatBenefitInfo"};
var EQColumns=getCurColumnsInfo('BA.G.EquipBenefitInfo','','','');
var node="web.DHCEQ.BA.RPTEchart_GetBenefitAnaly";
var TendTabClickNum=0;		//���Ʒ���ҳǩ�������
var SocialTabClickNum=0;	//���Ч��ҳǩ�������
var SameEQTabClickNum=0;	//ͬ���豸�����������
var MoreClickNum=0;			//����������
var SelectID="";
jQuery(document).ready(function()
{
	defindTitleStyle();
	initUserInfo();
	$("#hosptitle").html(curHospitalName+"Ч�����");
	//initYearBox();
	initButton();
	initEvent();
	initYearFlag();	
	initMonthFlag();
	initHalfYear();
	initQuarter();
	initStartDate();
	$("#MonthFlag").radio('setValue',true);	//Ĭ��Ϊ��� modifed by wy 2022-8-11 2871141Ĭ���·�
	fillRadio();
	initChartsOrGrid();		//��ʼ�����ذ�ť
	var ChartStr = "InComeTypeAnaly^ItemBenefitInfo^ItemInOutRate^LocBenefitInfo^LocInComeRate^LocOutItemInfo^StatCatBenefitInfo^StatCatInOutRate^BAEQNumAmount^BAInOutAmount^BAInOutQoQ^BAInOutYoY^BACheckPerson"
	var PeriodType=""
	var checkedRadioJObj = $("input[name='PeriodType']:checked");
	if(checkedRadioJObj.length>0) var PeriodType=checkedRadioJObj[0].id;
	var ChartsParams=node+","+$('#Job').val()+","+$('#StartDate').datebox('getText')+","+$('#EndDate').datebox('getText')+","+curUserID+","+curLocID+","+curSSGroupID+","+PeriodType+","+ChartStr;
	initEchartsObjMap();
	initChartsDefine(ChartStr,ChartsParams);	//��ʼ��ͼ����÷��������ݱ�������ʱglobal�� //1733788 modified by czf 2021-01-20
	//initBenefitEQSummary();
	$HUI.tabs("#tIndexTabs",{
		onSelect:function(title)
		{
			if (title=="���Ʒ���")
			{
				if (TendTabClickNum>0) return;		//�����ظ�����
				//$("#EquipStatCatDistribute").parent().css({'height':'339px','display':'block'});
				var ChartStr = "EquipOutFeeInfo^EquipOutFeeQOY^LocInComeQoY^LocOutFeeQoY^InComeTypeQoYRate"
				var ChartsParams=node+","+$('#Job').val()+","+$('#StartDate').datebox('getText')+","+$('#EndDate').datebox('getText')+","+curUserID+","+curLocID+","+curSSGroupID+","+PeriodType+","+ChartStr;
				//EchartsObjMap["LocEquipNums"]="EquipLocDistribute";
				//EchartsObjMap["StatCatEquipAmount"]="EquipStatCatDistribute";
				EchartsObjMap["EquipOutFeeInfo"]="EquipOutFeeAnaly";
				EchartsObjMap["EquipOutFeeQOY"]="EquipOutFeeAnaly";	//֧����ͬ��
				EchartsObjMap["LocInComeQoY"]="LocInComeQoY";
				EchartsObjMap["LocOutFeeQoY"]="LocInComeQoY";
				EchartsObjMap["InComeTypeQoYRate"]="InComeOriginQoY";
				initChartsDefine(ChartStr,ChartsParams);
				
				//����ȫԺ�������
				EchartsObj=new Array();
				EchartsObjMap=new Array();
				EchartsObjOption=new Array();
				var ChartStr = "LatelyOutFee^LatelyCheckPerson^LatelyInOut^LatelyInOutYOYRate"
				var ChartsParams=node+","+$('#Job').val()+","+curUserID;
				EchartsObjMap["LatelyCheckPerson"]="LatelyCheckPerson";
				EchartsObjMap["LatelyOutFee"]="LatelyOutFee";
				EchartsObjMap["LatelyInOut"]="LatelyHospBA";
				EchartsObjMap["LatelyInOutYOYRate"]="LatelyHospBA";
				initChartsDefine(ChartStr,ChartsParams);
				TendTabClickNum+=1;
			}
			if(title=="���Ч��")
			{
				if (SocialTabClickNum>0) return;
				var ChartStr = "LocCheckPerson^ItemCheckPeron^ItemWorkLoad"
				var ChartsParams=node+","+$('#Job').val()+","+$('#StartDate').datebox('getText')+","+$('#EndDate').datebox('getText')+","+curUserID+","+curLocID+","+curSSGroupID+","+PeriodType+","+ChartStr;
				EchartsObjMap["LocCheckPerson"]="LocCheckPerson";
				EchartsObjMap["ItemCheckPeron"]="ItemCheckPeron";
				EchartsObjMap["ItemWorkLoad"]="ItemWorkLoad";
				initChartsDefine(ChartStr,ChartsParams);
				//ҽ������������
				var ChartStr = "DoctorPositiveRate";
				var ChartsParams=","+"web.DHCEQ.BA.RPTEchart_DoctorPositiveRate"+","+$('#Job').val();
				EchartsObj=new Array();
				EchartsObjMap=new Array();
				EchartsObjOption=new Array();
				EchartsObjMap["DoctorPositiveRate"]="DoctorPositiveRate";
				initChartsDefine(ChartStr,ChartsParams);
				SocialTabClickNum+=1;
			}
			if(title=="ͬ���豸����")
			{
				initSameEQAnaly("N");
			}
		}
	});
});

function initEvent()
{
	//jQuery("#BMore").linkbutton({iconCls: 'icon-w-find'});
	$("#BMore").on("click", BMore_Clicked);
	//jQuery("#BMore").linkbutton({text:'����'});
}

function BMore_Clicked()
{
	MoreClickNum+=1;
	var AllItemFlag="N";
	if (MoreClickNum%2==0){
		AllItemFlag="N";
		$("#BMore").text('����>>>');
	}else{
		AllItemFlag="Y";
		$("#BMore").text('����<<<');
	}
	SameEQTabClickNum=0;
	initSameEQAnaly(AllItemFlag);
}

///ͬ���豸Ч�����
function initSameEQAnaly(AllItemFlag)
{
	if (SameEQTabClickNum>0) return;
	var jsonData=tkMakeServerCall("web.DHCEQ.BA.RPTCommon","GetBAEQItemKeyWords",AllItemFlag)
	jsonData=jQuery.parseJSON(jsonData);
	var string=eval('(' + jsonData.Data+ ')');
	$("#EQItemList").keywords({
		singleSelect:true,
		//labelCls:'red',
		items:string,
		onClick:function(v){
			ItemKeyWordClick();
		}
	});
	if ((SelectID!="")&&(string.length>0))
	{
		for (var i=0;i<string.length;i++)
		{
			if (string[i].id==SelectID)
			{
				$("#EQItemList").keywords('select',SelectID);
				break;
			}
		}
	} 
	var SelectType=$("#EQItemList").keywords("getSelected");
	if (SelectType.length<1)
	{
		$("#SameEQCharts").css('display','none');
		$("#NoDataPic").css('display','block');
	}
	SameEQTabClickNum+=1;
}

function ItemKeyWordClick()
{
	var SelectType=$("#EQItemList").keywords("getSelected");
	var ItemDR=""
	if (SelectType) ItemDR=SelectType[0].id;
	if (ItemDR!="")
	{
		$("#SameEQCharts").css('display','block');
		$("#NoDataPic").css('display','none');
		//��ʼ��ͬ��Ч��
		var ChartStr = "SameEQBAInfo^SameEQLocBAInfo";
		var ChartsParams="web.DHCEQ.BA.RPTEchart_GetSameEQBAChart"+","+ItemDR+","+$('#Job').val()+","+$('#StartDate').datebox('getText')+","+$('#EndDate').datebox('getText')+","+getElementValue("QXType")+","+curUserID+","+curLocID+","+curSSGroupID;
		EchartsObjMap["SameEQBAInfo"]="SameEQBAInfo";
		EchartsObjMap["SameEQLocBAInfo"]="SameEQLocBAInfo";
		initChartsDefine(ChartStr,ChartsParams);
		//��ʼ��ͬ���豸ά�����
		EchartsObj=new Array();
		EchartsObjMap=new Array();
		EchartsObjOption=new Array();
		var ChartStr = "SameEQMaintInfo^SameEQMaintRate^SameEQMaintTimeCost";
		var ChartsParams="web.DHCEQ.BA.RPTEchart_GetSameEQMaintChart"+","+ItemDR+","+$('#Job').val()+","+$('#StartDate').datebox('getText')+","+$('#EndDate').datebox('getText')+","+getElementValue("QXType")+","+curUserID+","+curLocID+","+curSSGroupID;
		EchartsObjMap["SameEQMaintInfo"]="SameEQMaintInfo";
		EchartsObjMap["SameEQMaintRate"]="SameEQMaintInfo";
		EchartsObjMap["SameEQMaintTimeCost"]="SameEQMaintTimeCost";
		initChartsDefine(ChartStr,ChartsParams);
	}
	else
	{
		$("#SameEQCharts").css('display','none');
		$("#NoDataPic").css('display','block');
	}
	SelectID=ItemDR;
}

function initEchartsObjMap()
{
	EchartsObjMap["InComeTypeAnaly"]="InComeTypeAnaly";
	//EchartsObjMap["LocEquipNums"]="EquipLocDistribute";
	//EchartsObjMap["StatCatEquipAmount"]="EquipStatCatDistribute";		//1733788 modified by czf 2021-01-20
	EchartsObjMap["ItemBenefitInfo"]="HospEquipAnaly";
	EchartsObjMap["ItemInOutRate"]="HospEquipAnaly";
	EchartsObjMap["LocBenefitInfo"]="LocBenefitView";
	EchartsObjMap["LocInComeRate"]="LocBenefitView";
	//EchartsObjMap["EquipOutFeeInfo"]="EquipOutFeeAnaly";
	EchartsObjMap["LocOutItemInfo"]="LocOutItemInfo";
	EchartsObjMap["StatCatBenefitInfo"]="StatCatBenefitView";
	EchartsObjMap["StatCatInOutRate"]="StatCatBenefitView";
}

//CZF0133 2021-02-22 ��ʼ�����ذ�ť
function initChartsOrGrid()
{
	$(".eq_swichbox").each(function(){
		var id=$(this)[0].id;
		$HUI.switchbox('#'+id,{
	        onText:'ͼ��',
	        offText:'��ϸ',
	        size:'mini',
	        onClass:'primary',
	        offClass:'gray',
			onSwitchChange:function(e,obj){
				switch(id) {
			     case "ChartsOrGrid1":
			        if($(this).switchbox('getValue'))
			        {
				        $("#StatCatBenefitView").css('display','block');
						$("#StatCatBenefitGrid").css('display','none');
				    }
		            else
		            {
			            $("#StatCatBenefitView").css('display','none');
						$("#StatCatBenefitGrid").css('display','block');
						initStatCatBenefitGrid();
			        }
			        break;
			     case "ChartsOrGrid2":
			        if($(this).switchbox('getValue'))
			        {
				        $("#HospEquipAnaly").css('display','block');
						$("#HospEquipGrid").css('display','none');
				    }
		            else
		            {
			            $("#HospEquipAnaly").css('display','none');
						$("#HospEquipGrid").css('display','block');
						initHospEquipGrid();
			      	}
			        break;
			     case "ChartsOrGrid3":
					if($(this).switchbox('getValue'))
					{
						$("#LocBenefitView").css('display','block');
						$("#LocBenefitGrid").css('display','none');
					}
		            else
		            {
			            $("#LocBenefitView").css('display','none');
						$("#LocBenefitGrid").css('display','block');
			            initLocBenefitGrid();
			        }
			        break;  
			     default:
			        break;
				} 
	        }
		});
	});
}

function initYearFlag()
{
	$HUI.radio('#YearFlag',{
		onCheckChange:function(e,value){
			if(value)
			{
				disableElement("EndDate",true);
				var StartDate=getElementValue("StartDate");
				var Year=StartDate.split("-")[0];
				setElement("StartDate",Year+"-01");
				setElement("EndDate",Year+"-12");
			}
			else
			{
				disableElement("EndDate",false);
			}
		}
	});
}

function initHalfYear()
{
	$HUI.radio('#HalfYear',{
		onCheckChange:function(e,value){
			if(value)
			{
				disableElement("EndDate",true);
				var StartDate=FormatDate(GetCurrentDate()).split("-")[0]; //add by wy 2022-9-13 2871143ȡ��ǰ�·�
				var Year=StartDate.split("-")[0];
				var Month=+StartDate.split("-")[1];
				if(Month<7) {setElement("StartDate",Year+"-01");setElement("EndDate",Year+"-06");}
				else {setElement("StartDate",Year+"-07");setElement("EndDate",Year+"-12");}
			}
			else
			{
				disableElement("EndDate",false);
			}
		}
	});
}

function initQuarter()
{
	$HUI.radio('#Quarter',{
		onCheckChange:function(e,value){
			if(value)
			{
				disableElement("EndDate",true);
				var StartDate=FormatDate(GetCurrentDate()).split("-")[0]; //add by wy 2022-9-13 2871143ȡ��ǰ�·�
				var Year=StartDate.split("-")[0];
				var Month=+StartDate.split("-")[1];
				if(Month<4) {setElement("StartDate",Year+"-01");setElement("EndDate",Year+"-03");}
				else if(Month<7) {setElement("StartDate",Year+"-04");setElement("EndDate",Year+"-06");}
				else if (Month<10) {setElement("StartDate",Year+"-07");setElement("EndDate",Year+"-09");}
				else {setElement("StartDate",Year+"-10");setElement("EndDate",Year+"-12");}
			}
			else
			{
				disableElement("EndDate",false);
			}
		}
	});
}

function initMonthFlag()
{
	$HUI.radio('#MonthFlag',{
		onCheckChange:function(e,value){
			if(value)
			{
				//modifed by wy 2022-8-11 2871143Ĭ��ǰһ��
				var EndDate=tkMakeServerCall("web.DHCEQReport","GetPreMonth",FormatDate(GetCurrentDate()))
				setElement("EndDate",EndDate);
				setElement("StartDate",EndDate);
				disableElement("EndDate",true);
			}
			else
			{
				disableElement("EndDate",false);
			}
		}
	});
}

function initStartDate()
{
	$HUI.datebox('#StartDate',{
		onSelect:function(obj){
			var StartDate=getElementValue("StartDate");
			var YearFlag=$("#YearFlag").radio('getValue');
			var MonthFlag=$("#MonthFlag").radio('getValue');
			var HalfYear=$("#HalfYear").radio('getValue');
			var Quarter=$("#Quarter").radio('getValue');
			var Year=StartDate.split("-")[0];
			var Month=+StartDate.split("-")[1];
			if (YearFlag)
			{
				setElement("StartDate",Year+"-01");
				setElement("EndDate",Year+"-12");
			}
			if (MonthFlag)
			{
				setElement("EndDate",StartDate);
			}
			if (HalfYear)
			{
				if(Month<7) {setElement("StartDate",Year+"-01");setElement("EndDate",Year+"-06");}
				else {setElement("StartDate",Year+"-07");setElement("EndDate",Year+"-12");}
			}
			if(Quarter)
			{
				if(Month<4) {setElement("StartDate",Year+"-01");setElement("EndDate",Year+"-03");}
				else if(Month<7) {setElement("StartDate",Year+"-04");setElement("EndDate",Year+"-06");}
				else if (Month<10) {setElement("StartDate",Year+"-07");setElement("EndDate",Year+"-09");}
				else {setElement("StartDate",Year+"-10");setElement("EndDate",Year+"-12");}
			}
		}
	});
}

function fillRadio()
{
	if ($("#YearFlag").val()=="true") $("#YearFlag").radio('setValue',true);
	if ($("#MonthFlag").val()=="true") $("#MonthFlag").radio('setValue',true);
	if ($("#HalfYear").val()=="true") $("#HalfYear").radio('setValue',true);
	if ($("#Quarter").val()=="true") $("#Quarter").radio('setValue',true);
}

function BFind_Clicked()
{
	var val="&StartDate="+$('#StartDate').datebox('getText')+"&EndDate="+$('#EndDate').datebox('getText');
	val=val+"&YearFlag="+$("#YearFlag").radio('getValue')+"&MonthFlag="+$("#MonthFlag").radio('getValue')+"&HalfYear="+$("#HalfYear").radio('getValue')+"&Quarter="+$("#Quarter").radio('getValue');
	url="dhceq.ba.benefitindex.csp?"+val;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token���ò�������
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
}

function initYearBox()
{
	var cbox = $HUI.combobox("#YearFilter",{
		valueField:'id',
		textField:'text',
		value:'6',
		//multiple:true,
		//rowStyle:'checkbox', //��ʾ�ɹ�ѡ����ʽ
		selectOnNavigation:false,
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'1',text:'2015'},{id:'2',text:'2016'},{id:'3',text:'2017'}
			,{id:'4',text:'2018'},{id:'5',text:'2019'},{id:'6',text:'2020'}
		],
		onSelect:function(){
			//ˢ��ͼ��
		}
	});

}

function initStatCatBenefitGrid()
{
	var PeriodType=""
	var checkedRadioJObj = $("input[name='PeriodType']:checked");
	if(checkedRadioJObj.length>0) var PeriodType=checkedRadioJObj[0].id;
	$HUI.datagrid("#StatCatBenefitGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.BA.RPTList",
			QueryName:"GetStatCatBenefitInfo",
			nodestr:node,
			EJob:getElementValue("Job"),
			CurUserID:curUserID,
			Type:0,
			vStartDate:$('#StartDate').datebox('getText'),
			vEndDateL:$('#EndDate').datebox('getText'),
			vPeriodType:PeriodType
		},
		toolbar:[],
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
	    columns:StatCatColumns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
	});
	//queryParams.EJob=getElementValue("EJob");
	//createdatagrid("tEquipSummary",queryParams,Columns);
}

function initLocBenefitGrid()
{
	var PeriodType=""
	var checkedRadioJObj = $("input[name='PeriodType']:checked");
	if(checkedRadioJObj.length>0) var PeriodType=checkedRadioJObj[0].id;
	 $HUI.datagrid("#LocBenefitGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.BA.RPTList",
			QueryName:"GetLocBenefitInfo",
			nodestr:node,
			EJob:getElementValue("Job"),
			CurUserID:curUserID,
			Type:0,
			vStartDate:$('#StartDate').datebox('getText'),
			vEndDateL:$('#EndDate').datebox('getText'),
			vPeriodType:PeriodType
		},
		toolbar:[],
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
	    columns:LocColumns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
	});
	//queryParams.EJob=getElementValue("EJob");
	//createdatagrid("tEquipSummary",queryParams,Columns);
}

function initBenefitEQSummary()
{
	var BenefitInfo=tkMakeServerCall("web.DHCEQ.BA.RPTEchart","GetTempInfo","web.DHCEQ.BA.RPTEchart_GetBenefitAnaly","BenefitEQSummary","",$('#Job').val(),curUserID);
	var BenefitList=BenefitInfo.split("^");
	$("#BenefitEQNum").text(BenefitList[14]);
	$("#BenefitEQAmount").text(BenefitList[13]);
	$("#BenefitEQIncomeAmount").text(BenefitList[2]);
	$("#BenefitEQOutFeeAmount").text(BenefitList[12]);
}

/*
function locBenefitAnaly(index)
{
	var curRowObj=$('#LocBenefitGrid').datagrid('getRows')[index];
	var StoreLoc=curRowObj.TStoreLoc;
	var StoreLocDR=curRowObj.TStoreLocDR;
	var StartDate=$('#StartDate').datebox('getText');
	var EndDate=$('#EndDate').datebox('getText');
	var Job=$('#Job').val();
	var url="dhceq.ba.locbenefitanaly.csp?&StoreLoc="+StoreLoc+"&StoreLocDR="+StoreLocDR+"&StartDate="+StartDate+"&EndDate="+EndDate+"&Job="+Job;
	showWindow(url,"����Ч�����","","","icon-w-paper","modal")
}

function statcatBenefitAnaly(index)
{
	var curRowObj=$('#LocBenefitGrid').datagrid('getRows')[index];
	var StoreLoc=curRowObj.TStoreLoc;
	var StoreLocDR=curRowObj.TStoreLocDR;
	var StartDate=$('#StartDate').datebox('getText');
	var EndDate=$('#EndDate').datebox('getText');
	var Job=$('#Job').val();
	var url="dhceq.ba.statcatbenefitanaly.csp?&StoreLoc="+StoreLoc+"&StoreLocDR="+StoreLocDR+"&StartDate="+StartDate+"&EndDate="+EndDate+"&Job="+Job;
	showWindow(url,"����Ч�����","","","icon-w-paper","modal")
}
*/

//ȫԺ�豸��ϸ
function initHospEquipGrid()
{
	 $HUI.datagrid("#HospEquipGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.BA.RPTBaseList",
			QueryName:"GetBenefitEquip",
			StartDate:$('#StartDate').datebox('getText'),
			EndDate:$('#EndDate').datebox('getText')
		},
		toolbar:[],
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //���Ϊtrue������ʾһ���к��С�
	    columns:EQColumns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50],
	});
	//queryParams.EJob=getElementValue("EJob");
	//createdatagrid("tEquipSummary",queryParams,Columns);
}
