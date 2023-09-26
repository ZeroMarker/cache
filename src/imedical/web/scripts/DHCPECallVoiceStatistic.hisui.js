//名称	DHCPECallVoiceStatistic.hisui.js
//功能	体检叫号统计
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
	
	$("#ShowFlag").combobox('setValue',"User");
	BFind_click();
}


//查询
function BFind_click(){
	var BeginDate = "", EndDate = "", ShowFlag = "", reportName = "";   
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "User") reportName = "DHCPEStatisticCallVoice.raq";
	else if (ShowFlag == "Doc") reportName = "DHCPECallVoiceDocStatistic.raq";
	else { alert("请选择查询类型！"); return false;}
	
	var CTLOCID = session["LOGON.CTLOCID"];
	var GROUPID = session["LOGON.GROUPID"];
	var USERID = session["LOGON.USERID"];
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&USERID=" + USERID
			+ "&CTLOCID=" + CTLOCID			
			;
	document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;

}

function InitCombobox(){
	
	// 查询类型
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'User',text:'按人员查询',selected:true},
			{id:'Doc',text:'按医生查询'}
		]
	});
}

