var LocColumns=getCurColumnsInfo('BA.G.LocBenefitInfo','','','');
var LocqueryParams={ClassName:"web.DHCEQ.BA.RPTList",QueryName:"GetLocBenefitInfo"};
var LocEQColumns=getCurColumnsInfo('BA.G.EquipBenefitInfo','','','');
var LocEQqueryParams={ClassName:"web.DHCEQ.BA.RPTBaseList",QueryName:"GetBenefitEquip"};
var node="web.DHCEQ.BA.RPTEchart_LocGetBenefitAnaly";

jQuery(document).ready(function()
{
	defindTitleStyle();
	initUserInfo();
	var ChartsParams=node+","+$('#Job').val()+","+$('#StartDate').datebox('getText')+","+$('#EndDate').datebox('getText')+","+curUserID+","+curLocID+","+curSSGroupID+","+$("#StoreLocDR").val();
	initEchartsObjMap();
	initChartsDefine("LocPerMonthFacWorkLoad^LocPerMonthBenefit^LocEquipOutFeeInfo",ChartsParams);
	fillData();		//在initChartsDefine之后调用
	initLocEchartGrid();
	initLocBenefitEQGrid();
	initButton();
});

function fillData()
{
	var BenefitInfo=tkMakeServerCall("web.DHCEQ.BA.RPTEchart","GetTempInfo","web.DHCEQ.BA.RPTEchart_GetBenefitAnaly","LocBenefit","",$('#Job').val(),curUserID,getElementValue("StoreLocDR"));
	var BenefitList=BenefitInfo.split("^");
	$("#StoreLoc").text(getElementValue("StoreLocDesc"));
	$("#AllEQNum").text(BenefitList[14]);
	$("#AllEQAmount").text(BenefitList[13]+"元");
	$("#AllInCome").text(BenefitList[2]+"元");
	$("#AllOutFee").text(BenefitList[12]+"元");
	$("#PerDayInCome").text(BenefitList[23]+"元");
	$("#PepleNum").text(BenefitList[26]);
	$("#PerDayPepleNum").text(BenefitList[28]);
}

function initEchartsObjMap()
{
	EchartsObjMap["LocPerMonthFacWorkLoad"]="LocWorkLoad";
	EchartsObjMap["LocPerMonthBenefit"]="LocBenefitCharts";
	EchartsObjMap["LocEquipOutFeeInfo"]="LocOutFee";	
}

function initButton()
{
	jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BFind").on("click", BFind_Clicked);
}

function initLocEchartGrid()
{
	 $HUI.datagrid("#LocBenefitGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.BA.RPTList",
			QueryName:"GetLocBenefitInfo",
			nodestr:node,
			EJob:getElementValue("Job"),
			CurUserID:curUserID,
			StoreLocDR:$("#StoreLocDR").val(),
			Type:1
		},
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列。
	    columns:LocColumns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50]
	});
	//queryParams.EJob=getElementValue("EJob");
	//createdatagrid("tEquipSummary",queryParams,Columns);
}

function initLocBenefitEQGrid()
{
	 $HUI.datagrid("#tLocBenefitEquipList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.BA.RPTBaseList",
			QueryName:"GetBenefitEquip",
			StartDate:$('#StartDate').datebox('getText'),
			EndDate:$('#EndDate').datebox('getText'),
			StoreLocDR:$("#StoreLocDR").val()
		},
		border:true,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列。
	    columns:LocEQColumns,
		pagination:true,
		pageSize:25,
		pageNumber:1,
		pageList:[25,50,100,200,300]
	});
	//queryParams.EJob=getElementValue("EJob");
	//createdatagrid("tEquipSummary",queryParams,Columns);
}

function BFind_Clicked()
{
	var val="&StartDate="+$('#StartDate').datebox('getText')+"&EndDate="+$('#EndDate').datebox('getText')+"&Job="+$("#Job").val()+"&StoreLocDR="+$("#StoreLocDR").val()+"&StoreLoc="+$("#StoreLocDesc").val();
	url="dhceq.ba.locbenefitanaly.csp?"+val;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
}
