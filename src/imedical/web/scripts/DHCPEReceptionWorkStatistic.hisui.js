//名称	DHCPEReceptionWorkStatistic.hisui.js
//功能	体检中心工作量统计
//创建	2019.08.21
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
    
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEReceptionWorkStatistic2.raq");
})


//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$(".hisui-combobox").combobox('setValue',"");
	//$(".hisui-combogrid").combogrid('setValue',"");
	$("#GroupName").combogrid('setValue',"");
	
	$("#ShowFlag").combobox('setValue',"User");
	InitCombobox();
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEReceptionWorkStatistic2.raq");
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=DHCPEReceptionWorkStatistic2.raq";
}


//查询
function BFind_click(){
	var BeginDate = "", EndDate = "", GroupDR = "", VIPLevel="", ShowFlag = "", reportName = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
    var EndDate = $("#EndDate").datebox('getValue');
	
	var GroupDR=$("#GroupName").combogrid("getValue");
	if (GroupDR == undefined || GroupDR == "undefined") { var GroupDR = ""; }
	
	var VIPLevel=$("#VIPLevel").combobox('getValue');
	if (VIPLevel==undefined) {var VIPLevel="";}
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "User") reportName = "DHCPEReceptionWorkStatistic.raq";
	else if (ShowFlag == "Date") reportName = "DHCPEEveryDateWorkStatistic.raq";
	else { alert("请选择查询类型！"); return false;}
	
	var CurLoc = session["LOGON.CTLOCID"];	
	var CurGroup = session['LOGON.GROUPID'];
	var CurUser = session["LOGON.USERID"];
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&GroupDR=" + GroupDR
			+ "&VIPLevel=" + VIPLevel
			+ "&ShowFlag=" + ShowFlag
			+ "&CurLoc=" + CurLoc
			+ "&CurGroup=" + CurGroup
			+ "&CurUser=" + CurUser
			;
	
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + lnk);
	//document.getElementById('ReportFile').src = "dhccpmrunqianreport.csp?reportName=" + reportName + lnk;

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
	});
	
	// 查询类型
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'User',text:$g('按人员查询'),selected:true},
			{id:'Date',text:$g('按日期查询')}
		]
	});
	
}