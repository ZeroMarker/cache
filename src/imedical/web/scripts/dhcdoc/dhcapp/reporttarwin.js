/// 收费项目明细窗口

showTarItmWin = function(param){
	var ParamId=param.split("||")[0]+"Part"+param.split("^")[1].split("$$")[0];
	if ($('#dgTarItm'+ParamId).length>0){
		$('#dgTarItm'+ParamId).remove();
	}
	$("#CellTar"+ParamId).popover({
		width:600,
		height:$("#CellTar"+ParamId).offset().top-90,
		title:"收费明细",
		content:'<table id="dgTarItm'+ParamId+'"></<table>',
		trigger:'hover',
		placement:'auto-top',
		onShow:function(){
			initTarItmList(param);
			//LoadTarItmList(param)
		}
	});
	$("#CellTar"+ParamId).popover('show');
	/*if($("#newTarWin").is(":visible")){return;}  //窗体处在打开状态,退出

	$('body').append('<div id="newTarWin"></div>');
	$("#newTarWin").append('<div id="dgTarItm"></div>');
	
	/// 预约详情窗口
	var option = {
		collapsible:false,
		minimizable:false,
		maximizable:false,
		border:true,
		closed:"true"
	};
	
	new WindowUX('收费明细', 'newTarWin', '700', '400', option).Init();
	
	initTarItmList();   /// 收费项目明细
	LoadTarItmList(param);*/
}

/// 收费项目明细 DataGrid初始定义
function initTarItmList(param){
	
	///  定义columns
	var columns=[[
		{field:'TarCode',title:'项目代码',width:100,formatter:SetCellFontColor},
		{field:'TarDesc',title:'项目名称',width:220},
		{field:'TarQty',title:'数量',width:80},
		{field:'TarPrice',title:'单价',width:80},
		{field:'TarCost',title:'价格',width:80,formatter:SetCellFontColor},
		{field:'TarDiscCost',title:'折后价',width:80,formatter:SetCellFontColor}
		
	]];
	$('#dgTarItm'+param.split("||")[0]+"Part"+param.split("^")[1].split("$$")[0]).datagrid({  
		fit : true,
		width : 'auto',
		border : true,
		//striped : true,
		singleSelect : true,
		fitColumns : true,
		autoRowHeight : false,
		url:$URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqTarList&param="+param,
		loadMsg : '加载中..',  
		pagination : true,  //是否分页
		rownumbers : true,  //
		idField:"TarCode",
		pageSize:15,
		pageList : [15,50,100,200],
		columns :columns,
		onClickRow:function(rowIndex, rowData){
		
		},
       onLoadSuccess:function(data){
	       //$("#Moster"+param.split("||")[0]).popover('show');
	   },
	   onBeforeLoad:function(param){
	   }
	});
	/*///  定义datagrid
	var option = {
		rownumbers : true,
		singleSelect : true
	};

	var uniturl = "";
	new ListComponent('dgTarItm', columns, uniturl, option).Init(); */
}

/// 加载收费项明细
function LoadTarItmList(param){

	var uniturl = $URL+"?ClassName=web.DHCAPPExaReportQuery&MethodName=QueryExaReqTarList&param="+param;
	$('#dgTarItm').datagrid({url:uniturl});
	
}

/// 设置字体显示颜色
function SetCellFontColor(value, rowData, rowIndex){
	
	var htmlstr = value;
	if (rowData.TarCode == "合计："){
		htmlstr = "<span style='color:red; font-weight:bold'>"+value+"</span>"
	}
	return htmlstr;
}