//名称	DHCPEStationIncomeStatistic.hisui.js
//功能	科室收入统计
//创建	2019.11.29
//创建人  yp

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
    
})


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
	var BeginDate = "", EndDate = "", GroupDR = "", ShowFlag = "";
	var BeginDate = $("#BeginDate").datebox('getValue');
	/*if (BeginDate == "") {
		$.messager.alert("提示","请输入开始日期！");
		//$.messager.popover({msg:"请输入开始日期！", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}*/
	
	var EndDate = $("#EndDate").datebox('getValue');
	/*if (EndDate == "") {
		$.messager.alert("提示","请输入结束日期！");
		//$.messager.popover({msg:"请输入结束日期！", type:"alert", timeout: 3000, showType:"slide"});
		return false;
	}*/
	
	var GroupDR = $("#GroupName").combogrid("getValue");
	if (GroupDR == undefined || GroupDR == "undefined") { var GroupDR = ""; }
	
	var CurLoc = session["LOGON.CTLOCID"];
	
	var src = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&GroupDR=" + GroupDR
			+ "&CTLOCID=" + CurLoc
			;
	
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEStationIncomeStatistic.raq" + src;
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
			param.ShowPersonGroup="1";
		},
		columns:[[
			{field:'TRowId',title:'团体ID',width:80},
			{field:'TGDesc',title:'团体名称',width:140},
			{field:'TGStatus',title:'状态',width:100},
			{field:'TAdmDate',title:'日期',width:100}		
		]]
	})
}