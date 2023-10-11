var SCColumns=getCurColumnsInfo('BA.G.StatCatBenefitInfo','','','');
var SCqueryParams={ClassName:"web.DHCEQ.BA.RPTList",QueryName:"GetStatCatBenefitInfo"};
var EQColumns=getCurColumnsInfo('BA.G.EquipBenefitInfo','','','');
var EQqueryParams={ClassName:"web.DHCEQ.BA.RPTBaseList",QueryName:"GetBenefitEquip"};
var node="web.DHCEQ.BA.RPTEchart_StatGetBenefitAnaly";

jQuery(document).ready(function()
{
	defindTitleStyle();
	initUserInfo();
	var ChartsParams=node+","+$('#Job').val()+","+$('#StartDate').datebox('getText')+","+$('#EndDate').datebox('getText')+","+curSSUserID+","+curLocID+","+curUserID+","+$("#StatCatDR").val();
	initEchartsObjMap();
	initChartsDefine("SCPerMonthFacWorkLoad^SCPerMonthBenefit^SCEquipOutFeeInfo",ChartsParams);
	fillData();		//在initChartsDefine之后调用
	initSCEchartGrid();
	initSCBenefitEQGrid();
	//initButton();
	jQuery("#BFind").on("click", BFind_Clicked);
	jQuery("#BFind").linkbutton({text:'查询'});
});

function fillData()
{
	var BenefitInfo=tkMakeServerCall("web.DHCEQ.BA.RPTEchart","GetTempInfo","web.DHCEQ.BA.RPTEchart_GetBenefitAnaly","StatCatBenefit","",$('#Job').val(),curUserID,getElementValue("StatCatDR"));
	var BenefitList=BenefitInfo.split("^");
	$("#StatCat").text(getElementValue("StatCatDesc"));
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
	EchartsObjMap["SCPerMonthFacWorkLoad"]="SCWorkLoad";
	EchartsObjMap["SCPerMonthBenefit"]="SCBenefitCharts";
	EchartsObjMap["SCEquipOutFeeInfo"]="SCOutFee";	
}

function initButton()
{
	jQuery("#BFind").linkbutton({iconCls: 'icon-w-find'});
	jQuery("#BFind").on("click", BFind_Clicked);
}

function initSCEchartGrid()
{
	 $HUI.datagrid("#SCBenefitGrid",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.BA.RPTList",
			QueryName:"GetStatCatBenefitInfo",
			nodestr:node,
			EJob:getElementValue("Job"),
			CurUserID:curSSUserID,
			StatCatDR:$("#StatCatDR").val(),
			Type:1
		},
		toolbar:[],
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列。
	    columns:SCColumns,
		pagination:true,
		pageSize:10,
		pageNumber:1,
		pageList:[10,20,30,40,50]
	});
	//queryParams.EJob=getElementValue("EJob");
	//createdatagrid("tEquipSummary",queryParams,Columns);
}

function initSCBenefitEQGrid()
{
	 $HUI.datagrid("#tSCBenefitEquipList",{
		url:$URL,
		queryParams:{
			ClassName:"web.DHCEQ.BA.RPTBaseList",
			QueryName:"GetBenefitEquip",
			StartDate:$('#StartDate').datebox('getText'),
			EndDate:$('#EndDate').datebox('getText'),
			StatCatDR:$("#StatCatDR").val()
		},
		toolbar:[],
		border:false,
	    fit:true,
	    singleSelect:true,
	    rownumbers: true,  //如果为true，则显示一个行号列。
	    columns:EQColumns,
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
	var val="&StartDate="+$('#StartDate').datebox('getText')+"&EndDate="+$('#EndDate').datebox('getText')+"&Job="+$("#Job").val()+"&StatCatDR="+$("#StatCatDR").val()+"&StatCat="+$("#StatCatDesc").val();
	url="dhceq.ba.statcatbenefitanaly.csp?"+val;
	if ('function'==typeof websys_getMWToken){		//czf 2023-02-14 token启用参数传递
		url += "&MWToken="+websys_getMWToken()
	}
	window.location.href= url;
}
