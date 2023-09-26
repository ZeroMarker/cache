//页面Gui
function InitPatTypeListWin(){
	var obj = new Object();
	obj.RecRowID1 = "";
	obj.RecRowID2 = "";		
    $.parser.parse(); // 解析整个页面 
   
	obj.gridPatType = $HUI.datagrid("#PatType",{
		fit: true,
		title: "特殊患者分类",
		headerCls:'panel-header-gray',
		iconCls:'icon-star-yellow',
		toolbar: [],  //配置项toolbar为空时,会在标题与列头产生间距"
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.SPEService.PatType",
			QueryName:"QryPatType"
	    },
		columns:[[
			{field:'PTCode',title:'代码',width:'40'},
			{field:'PTDesc',title:'名称',width:'200'}, 
			{field:'PTIsActiveDesc',title:'是否<br>有效',width:'60'},
			{field:'PTResume',title:'备注',width:'90'}	
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPatType_onSelect();
			}
		}
	});
    
    obj.gridPatTypeSub = $HUI.datagrid("#PatTypeSub",{
		fit: true,
		title: "特殊患者子分类",
		headerCls:'panel-header-gray',
		iconCls:'icon-star-light-yellow',
		toolbar: [],  //配置项toolbar为空时,会在标题与列头产生间距"
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: true, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMed.SPEService.PatTypeSub",
			QueryName:"QryPatTypeSub",
			ParRef:obj.RecRowID1
	    },
		columns:[[
			{field:'PTSCode',title:'代码',width:'50'},
			{field:'PTSDesc',title:'名称',width:'150'},
			{field:'PTSIcon',title:'图标定义',width:'150'},
			{field:'PTSAutoMarkDesc',title:'自动<br>标记',width:'60'},
			{field:'PTSAutoCheckDesc',title:'自动<br>审核',width:'60'},
			//{field:'PTSAutoCloseDesc',title:'自动<br>关闭',width:'60'}, 
			{field:'PTSIsActiveDesc',title:'是否<br>有效',width:'60'},
			{field:'PTSResume',title:'备注',width:'170'}
		]],
		onBeforeLoad: function (param) {
            var firstLoad = $(this).attr("firstLoad");
            if (firstLoad == "false" || typeof (firstLoad) == "undefined")
            {
                $(this).attr("firstLoad","true");
                return false;
            }
            return true;
		},
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPatTypeSub_onSelect();
			}
		}
		
	});
	
	InitPatTypeListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


