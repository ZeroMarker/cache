//页面Gui
function InitPathComplListWin(){
	var obj = new Object();
	obj.RecRowID1 = "";
	obj.RecRowID2 = "";		
    $.parser.parse(); // 解析整个页面 
	
	obj.gridPathCompl = $HUI.datagrid("#gridPathCompl",{
		fit: true,
		title: "合并症维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathComplSrv",
			QueryName:"QryPathCompl"
	    },
		columns:[[
			{field:'BTID',title:'ID',width:'50',},
			{field:'BTCode',title:'代码',width:'90',sortable:true},
			{field:'BTDesc',title:'名称',width:'250'}, 
			{field:'BTIsActiveDesc',title:'是否有效',width:'80'},
			/*{field:'BTActDate',title:'处置日期',width:'100'},	
			{field:'BTActTime',title:'处置时间',width:'100'},*/
			{field:'BTActUserDesc',title:'处置人',width:'135'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridPathCompl_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathCompl_onDbselect(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
			$("#btnSubAdd").linkbutton("disable");
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
			//if(obj.RecRowID1)$('#PathCompl').datagrid('selectRecord',obj.RecRowID1);
		}
	});
    
    obj.gridPathComplExt = $HUI.datagrid("#gridPathComplExt",{
		fit: true,
		title: "合并症扩展项维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		pageSize: 10,
		pageList : [10,20,50,100,200],
	    url:$URL,
	    queryParams:{
		    ClassName:"DHCMA.CPW.BTS.PathComplExtSrv",
			QueryName:"QryPathComplExt",
			aParRef:obj.RecRowID1
	    },
		columns:[[{field:'BTSID',title:'ID',width:'120'},
 				{field:'ExtDesc',title:'扩展项',width:'310'}
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
				obj.gridPathComplExt_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
				obj.gridPathComplExt_onDbSelect(rowData);
			}
		},
		onLoadSuccess:function(data){	
			//if($("#btnAdd").hasClass("l-btn-disabled")){
			if(obj.RecRowID1){
				$("#btnSubAdd").linkbutton("enable");
			}else{
				$("#btnSubAdd").linkbutton("disable");
			}
			$("#btnSubEdit").linkbutton("disable");
			$("#btnSubDelete").linkbutton("disable");
		}
	});
	
	InitPathComplListWinEvent(obj);	
	obj.LoadEvent(arguments);
	return obj;
}


