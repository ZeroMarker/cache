//名称	DHCPEFeeStatistic.hisui.js
//功能	体检费用统计
//创建	2020.02.24
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
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEFeeStatistic.raq");
});

//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	$("#GroupName").combogrid('setValue',"");
	
	$("#ShowFlag").combobox('setValue',"Item");
	InitCombobox();
	BFind_click();
}

//查询
function BFind_click(){
	var BeginDate = "", EndDate = "", GroupDR = "", ShowFlag = "", reportName = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate = $("#EndDate").datebox('getValue');

	var GroupDR=$("#GroupName").combogrid("getValue");
	if (GroupDR == "undefined" || GroupDR == undefined) {var GroupDR="";}
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "Item") reportName = "DHCPEFeeStatistic.raq";
	else if (ShowFlag == "User") reportName = "DHCPEFeeStatistic1.raq";
	else { alert("请选择查询类型！"); return false;}
	
	var CurLoc = session["LOGON.CTLOCID"];	
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&GroupDR=" + GroupDR
			+ "&ShowFlag=" + ShowFlag
			+ "&CurLoc=" + CurLoc
			;
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + lnk);
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
}
function InitCombobox(){
	
	//团体
	var GroupNameObj = $HUI.combogrid("#GroupName",{
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
	})
	
	// 查询类型
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'Item',text:$g('按医嘱查询'),selected:true},
			{id:'User',text:$g('按人员查询')}
		]
	});
}