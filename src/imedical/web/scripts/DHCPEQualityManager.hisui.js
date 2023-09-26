//名称	DHCPEQualityManager.hisui.js
//功能	质量上报统计
//创建	2020.06.21
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
	
	$("#ShowFlag").combobox('setValue',"Err");
	InitCombobox();
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEQualityManager.raq";
}


//查询
function BFind_click(){
	var BeginDate = "", EndDate = "", VIPLevel="", ShowFlag = "", reportName = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
    var EndDate = $("#EndDate").datebox('getValue');
		
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (VIPLevel==undefined) {var VIPLevel="";}
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "Err") reportName = "DHCPEQualityManager.raq";
	else if (ShowFlag == "Create") reportName = "DHCPEQualityManager1.raq";
	else { $.messager.alert("提示","请选择查询类型！","info");  return false;}
	
	var CTLOCID = session["LOGON.CTLOCID"];
	
	var lnk = "&StartDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&VIPLevel=" + VIPLevel
			+ "&CTLOCID=" + CTLOCID
			;
	
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;

}

function InitCombobox(){
	
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
			{id:'Err',text:'责任人',selected:true},
			{id:'Create',text:'上报人'}
		]
	});
	
}