//名称	DHCPEArcItemStatistic.hisui.js
//功能	体检医嘱数量统计
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
    
})


//清屏
function BClear_click(){
	
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	//$(".hisui-combogrid").combogrid('setValue',"");
	$("#ARCIMDesc").combogrid('setValue',"");
	
	$("#ShowFlag").combobox('setValue',"Item");
    InitCombobox();
	BFind_click();
}


//查询
function BFind_click(){
	var BeginDate = "", EndDate = "", ARCIMDR = "", ShowFlag = "", reportName = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
    var EndDate = $("#EndDate").datebox('getValue');
	
	var ARCIMDR=$("#ARCIMDesc").combogrid("getValue");
	if (ARCIMDR == undefined || ARCIMDR == "undefined") { var ARCIMDR = ""; }
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "Item") 
	{
		reportName = "DHCPEItemDetailStatistic.raq";
		var lnk = "&BeginDate=" + BeginDate + "&EndDate=" + EndDate + "&ARCIM=" + ARCIMDR;
	}
	else if (ShowFlag == "Set") 
	{
	    reportName = "DHCPESetDetatilStatistic.raq";
	    var lnk = "&BeginDate=" + BeginDate + "&EndDate=" + EndDate;
	}
	else { alert("请选择查询类型！"); return false;}
	
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&ARCIM=" + ARCIMDR
			;
			
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
}

function InitCombobox(){
	
	//体检项目
	var ARCIMDescObj = $HUI.combogrid("#ARCIMDesc",{
		panelWidth:450,
		panelHeight:243,
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindStationOrder",
		mode:'remote',
		delay:200,
		pagination:true,
		minQueryLen:1,
        rownumbers:true,//序号   
		fit: true,
		pageSize: 5,
		pageList: [5,10],
		idField:'id',
		textField:'desc',	
        onBeforeLoad:function(param){
			param.Desc = param.q;
		},		
		columns:[[
			{field:'Code',title:'编码',width:80},
			{field:'desc',title:'名称',width:180},
			{field:'id',title:'ID',width:80}			
		]]
	})
		
	//VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
		
	// 查询类型
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'Item',text:'按医嘱查询',selected:true},
			{id:'Set',text:'按套餐查询'}
		]
	});

}