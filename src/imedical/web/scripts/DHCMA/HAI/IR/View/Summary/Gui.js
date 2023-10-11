//页面Gui
function InitSummaryWin(){
	var obj = new Object();
	obj.ViewIcon    = [];	//图例
	obj.CurrNo = 1;	//图例默认页
	obj.column      = 60;   //默认列数
	obj.ViewBackColor=[];	//背景色	
	obj.ViewBackColor = [
		["KSS1","#FFE1E1",$g("非限制级")],
		["KSS2","#F9E79F",$g("限制级")],
		["KSS3","#A9DFBF",$g("特殊级")]
	];		
	/*		
	//初始化高度
	var wh = $(window).height();
	$("body").height(wh-10);
	
	//自适应高度
	$(window).resize(function(){
		var wh = $(window).height();
		$("body").height(wh-10);
		window.location.reload();
	});
	*/
	// 渲染图例
	//var runQuery = $.Tool.RunQuery("DHCHAI.IRS.CCInfViewSrv","QryInfViewIcon");
	var runQuery =$cm({
				ClassName:"DHCHAI.IRS.CCInfViewSrv",
				QueryName:"QryInfViewIcon",
	        	rows:1000000
			},false);
	if (!runQuery) {
		//$.Tool.alert('图例信息为空 ！');
		$.messager.alert("确认", $g("图例信息为空 ！"), 'info');
		return;
	}
	else{
		obj.ViewIcon = runQuery.rows;
		for(var i = 0 ;i<obj.ViewIcon.length;i++){
			var desc = obj.ViewIcon[i].desc;
			var src = obj.ViewIcon[i].src;
			var html = '<div><img src = "' + src + '"/><p>'+desc+'</p></div>' ;
			$('#img_span').append(html);
		}
		//背景色类型特殊处理
		for(var i = 0 ;i<obj.ViewBackColor.length;i++){
			var desc = obj.ViewBackColor[i][2];
			var src = obj.ViewBackColor[i][1];
			var html = '<div><div class="pull-left" style = "background-color:' + src + ';width:14px;height:14px;margin-top:8px;"></div>&nbsp;<p style="margin-top:5px;">'+desc+'</p></div>' ;
			$('#img_span').append(html);
		}
		//刷新处理
		var desc = $g("上页");
		var src = "";
		var html = '<div style="height: 24px; border-left: 1px solid LightGrey; border-right: 0px solid LightGrey;margin: 1px 1px;margin-top:3px; "><a id="previous" style="cursor: pointer;vertical-align: middle; margin-left: 3px">'+desc+'</a></div>' ;
		$('#img_span').append(html);
		var desc = $g("下页");
		var src = "";
		var html = '<div style="margin-top:3px;"><a id="next" style="cursor: pointer;vertical-align: middle;">'+desc+'</a></div>' ;
		$('#img_span').append(html);
	}
	obj.gridViewDetail = $HUI.datagrid("#gridViewDetail",{
		fit: true,
		headerCls:'panel-header-gray',
		iconCls:'icon-resort',
		pagination: false, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		nowrap:true,
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 9999,
		columns:[[
			{field:'ActDate',title:'日期',width:100},
			{field:'DiagStr',title:'诊断依据',width:160},
			{field:'TreatStr',title:'治疗措施',width:220}
		]],
		onSelect:function(rindex,rowData){
		
		},
		onDblClickRow:function(rowIndex,rowData){
		},
		onLoadSuccess:function(data){
            dispalyEasyUILoad(); //隐藏效果
		}
	});
	InitSummaryWinEvent(obj);
	return obj;
}
