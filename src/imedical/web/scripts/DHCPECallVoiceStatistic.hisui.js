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
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEStatisticCallVoice.raq");
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
	
	var CurLoc = session["LOGON.CTLOCID"];
	var CurUser = session["LOGON.USERID"];
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&CurUser=" + CurUser
			+ "&CurLoc=" + CurLoc			
			;
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + lnk);
}

function InitCombobox(){
	
	// 查询类型
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'User',text:$g('按人员查询'),selected:true},
			{id:'Doc',text:$g('按医生查询')}
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
