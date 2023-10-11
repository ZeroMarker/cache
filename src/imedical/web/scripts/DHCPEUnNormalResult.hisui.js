//名称	DHCPEUnNormalResult.hisui.js
//功能	体检异常结果统计
//创建	2021.07.27
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
    
	ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=DHCPEUnNormalResult.raq");
})


//清屏
function BClear_click(){
	$("#BeginDate,#EndDate").datebox('setValue')
	$("#GroupName").combogrid('setValue',"");
	$("#ARCIMDesc").combogrid('setValue',"");
	
	InitCombobox();
	BFind_click();
}


//查询
function BFind_click(){
	var BeginDate = "", EndDate = "", GroupDR="", OEItem="", ShowFlag = "", reportName = "";
	var BeginDate=$("#BeginDate").datebox('getValue');
	var EndDate=$("#EndDate").datebox('getValue');
	
	var GroupDR=$("#GroupName").combogrid("getValue");
	if (GroupDR == undefined || GroupDR == "undefined") { var GroupDR = ""; }
		
	var OEItem=$("#ARCIMDesc").combogrid("getValue");
	if (OEItem == undefined || OEItem == "undefined") { var OEItem = ""; }
	
	var ShowFlag = $("#ShowFlag").combogrid("getValue");
	if (ShowFlag == "User") reportName = "DHCPEUnNormalResult.raq";
	else if (ShowFlag == "Item") reportName = "DHCPEUnResultForItem.raq";
	else { alert("请选择查询类型！"); return false;}
	
	var lnk = "&BeginDate=" + BeginDate
			+ "&EndDate=" + EndDate
			+ "&GroupDR=" + GroupDR
			+ "&OEItem=" + OEItem
			+ "&CTLOCID=" + session["LOGON.CTLOCID"]
			;
	
    ShowRunQianUrl("ReportFile", "dhccpmrunqianreport.csp?reportName=" + reportName + lnk);	
	//document.getElementById('ReportFile').src="dhccpmrunqianreport.csp?reportName=" + reportName + lnk;
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
			param.LocID=session['LOGON.CTLOCID'];
			param.hospId=session['LOGON.HOSPID']
		},		
		columns:[[
			{field:'Code',title:'编码',width:80},
			{field:'desc',title:'名称',width:180},
			{field:'id',title:'ID',width:80}			
		]]
	})
	
	// 查询类型
	$HUI.combobox("#ShowFlag", {
		valueField:'id',
		textField:'text',
		panelHeight:"auto",
		editable:false,
		data:[
			{id:'User',text:$g('按人员显示'),selected:true},
			{id:'Item',text:$g('按医嘱显示')}
		]
	});
}