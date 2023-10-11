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
    
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEQualityManager.raq");
})


//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	
	$("#ShowFlag").combobox('setValue',"Err");
	InitCombobox();
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEQualityManager.raq");
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEQualityManager.raq";
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
	
	var CurLoc = session["LOGON.CTLOCID"];
	
	var lnk = "&StartDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&VIPLevel=" + VIPLevel
			+ "&CurLoc=" + CurLoc
			;
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + lnk);
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;

}

function InitCombobox(){
	
	/*
	//VIP等级	
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.HISUICommon&QueryName=FindVIP&ResultSetType=array",
		valueField:'id',
		textField:'desc',
		});
	*/
	
	//VIP等级-多院区 
	var VIPObj = $HUI.combobox("#VIPLevel",{
		url:$URL+"?ClassName=web.DHCPE.CT.HISUICommon&QueryName=FindVIP&ResultSetType=array&LocID="+session['LOGON.CTLOCID'],
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
			{id:'Err',text:$g('责任人'),selected:true},
			{id:'Create',text:$g('上报人')}
		]
	});
	
}
// 解决iframe中 润乾csp 跳动问题
function ShowRunQianUrl(iframeId, url) {
    var iframeObj = document.getElementById(iframeId)
    if (iframeObj) {
	    iframeObj.src=url;
	    //debugger;
	    $(iframeObj).hide();
	    if (iframeObj.attachEvent) {
		    iframeObj.attachEvent("onload", function(){
		        $(this).show();
		    });
	    } else {
		    iframeObj.onload = function(){
		        $(this).show();
		    };
	    }
    }
}