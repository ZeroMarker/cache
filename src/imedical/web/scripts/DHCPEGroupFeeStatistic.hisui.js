//名称	DHCPEGroupFeeStatistic.hisui.js
//功能	团体费用统计
//创建	2019.09.09
//创建人  ln

$(function(){
	InitCombobox();

    //查询
	$("#BFind").click(function() {	
		BFind_click();		
    });
    
    //清屏
	$("#BClear").click(function() {	
		BClear_click();		
    });

	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEGroupFeeStatistic.raq");
});

//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	$(".hisui-combogrid").combogrid('setValue',"");
	
	InitCombobox();
	BFind_click();
}


//查询
function BFind_click(){
		
	var GADM=$("#GADM").combogrid("getValue");
	if (GADM == "undefined" || GADM == undefined) {var GADM="";}

	var lnk = "&BeginDate="+$("#BeginDate").datebox('getValue')
			+ "&EndDate="+$("#EndDate").datebox('getValue')
			+ "&GADM="+GADM
			+ "&CTLOCID="+session['LOGON.CTLOCID'];
	//alert(lnk)
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEGroupFeeStatistic.raq" + lnk);
	// document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName=DHCPEGroupFeeStatistic.raq"+lnk;
}

function InitCombobox(){
	
	//团体
	var GroupNameObj = $HUI.combogrid("#GADM",{
		panelWidth:450,
		panelHeight:260,
		url:$URL+"?ClassName=web.DHCPE.DHCPEGAdm&QueryName=GADMList",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'TRowId',
		textField:'TGDesc',
		onBeforeLoad:function(param){
			param.GBIDesc = param.q;
		},
		columns:[[
			{field:'TRowId',title:'团体ID',width:80},
			{field:'TGDesc',title:'团体名称',width:140},
			{field:'TGStatus',title:'状态',width:100},
			{field:'TAdmDate',title:'日期',width:100}		
		]]
	});
}