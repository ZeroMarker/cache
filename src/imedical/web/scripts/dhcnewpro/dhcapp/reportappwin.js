/// 报告预约详情窗口
showItmAppDetWin = function(arReqID){

	if($('#newWin').is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="newWin"></div>');
	$("#newWin").append('<div id="tabWin"></div>');
	
	$("#tabWin").append('<div id="app" title="预约"></div>');
	$("#tabWin").append('<div id="det" title="预约详情"></div>');
	$("#det").html('<div id="dgAppList"></div>');
	
	/// 预约详情窗口
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		closed:"true",
		onClose:function(){
			$("#newWin").remove();
		}
	};
	
	new WindowUX('预约详情', 'newWin', '1200', '600', option).Init();
	
	/// 预约详情tab标签
	var option = {
		border:true,
		fit:true,
	    onSelect:function(title){
	        var tab = $("#tabWin").tabs('getSelected');  // 获取选择的面板
	        var tbId = tab.attr("id");
	        var maintab="";
	        switch(tbId){
	            case "det":
					//maintab="dhcpha.comment.paallergy.csp";  //预约详情
					$('#dgAppList').datagrid('resize',{width: 1100,height: 500 });
					$("#dgAppList").datagrid("reload");
					break;
				case "app":
					maintab="dhc.ris.appointment.csp";       //预约
					break;
			}
			if (maintab != ""){
				//iframe 定义
		        var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="'+maintab+'?PatientID='+ "" +'&EpisodeID='+ EpisodeID +'"></iframe>';
		        tab.html(iframe);
	        }
	    }
	    
	}

	new TabsUX('预约详情', 'tabWin', option).Init();
	$('#newWin').window('open');
	
	initAppItmList(arReqID);   /// 预约详情
}

/// 预约详情 DataGrid初始定义
function initAppItmList(arReqID){
	
	///  定义columns
	var columns=[[
		{field:'ItemLabel',title:'项目',width:220},
		{field:'PartDesc',title:'部位',width:120},
		{field:'ItemStatus',title:'预约状态',width:120},
		{field:'ItemDate',title:'日期',width:120},
		{field:'ItemTime',title:'时间',width:120},
		{field:'ItemMach',title:'设备',width:120}
		
	]];
	
	///  定义datagrid
	var option = {
		//showHeader:false,
		rownumbers : true,
		singleSelect : true
	};

	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqAppList&arReqID="+arReqID;
	new ListComponent('dgAppList', columns, uniturl, option).Init(); 
}
