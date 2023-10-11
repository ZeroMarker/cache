//采购申请分析首页
//ZY 2022-07-27 2849911
var node="web.DHCEQ.EM.RPTBuyReqEchart_GetBuyRequestAnaly";
jQuery(document).ready(function()
{
	defindTitleStyle();
	initUserInfo();
	$("#hosptitle").html(curHospitalName+"采购申请分析");
	initButton();
	initYearFlag();	
	initMonthFlag();
	initHalfYear();
	initQuarter();
	$("#YearFlag").radio('setValue',true);	//默认为年度
	initStartDate();
	fillRadio();
    /// modified by ZY 2893882 20220913
    var ChartStr = "BuyReqStatus^BuyReqPurchaseType^BuyReqRequestLoc^BuyReqYearFlag^BuyReqStatusAnaly^BuyReqPurchaseTypeAnaly^BuyReqYearFlagAnaly^BuyReqLocAnalyNum^BuyReqLocAnalyAmount"
    //var ChartStr = "BuyReqStatus^BuyReqPurchaseType^BuyReqRequestLoc^BuyReqYearFlag^BuyReqStatusAnaly^BuyReqPurchaseTypeAnaly^BuyReqYearFlagAnaly"
	var PeriodType=""
	var checkedRadioJObj = $("input[name='PeriodType']:checked");
	if(checkedRadioJObj.length>0) var PeriodType=checkedRadioJObj[0].id;
	var ChartsParams=node+","+$('#Job').val()+","+$('#StartDate').datebox('getText')+","+$('#EndDate').datebox('getText')+","+curUserID+","+curLocID+","+curSSGroupID+","+PeriodType+","+ChartStr;
	initEchartsObjMap();
	initChartsDefine(ChartStr,ChartsParams);
	initChartsDefine("EQOverYearInStock","")
});

function initEchartsObjMap()
{
	EchartsObjMap["EQOverYearInStock"]="YearControl";
	
	EchartsObjMap["BuyReqStatusAnaly"]="BuyReqStatusAnaly";
	EchartsObjMap["BuyReqPurchaseTypeAnaly"]="BuyReqPurchaseTypeAnaly";
	EchartsObjMap["BuyReqYearFlagAnaly"]="BuyReqYearFlagAnaly";
	
	EchartsObjMap["BuyReqLocAnalyNum"]="BuyReqLocAnaly"
	EchartsObjMap["BuyReqLocAnalyAmount"]="BuyReqLocAnaly"
	
	EchartsObjMap["EQOverYearInStock"]="BuyReqInStockAnaly";
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
				var StartDate=getElementValue("StartDate");
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
				var StartDate=getElementValue("StartDate");
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
				disableElement("EndDate",true);
				var StartDate=getElementValue("StartDate");
				setElement("EndDate",StartDate);
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
	var url="dhceq.em.buyrequestanaly.csp?"+val;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
}
