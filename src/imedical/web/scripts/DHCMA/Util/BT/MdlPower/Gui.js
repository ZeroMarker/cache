//页面Gui
function InitMdlPowerListWin(){
	var obj = new Object();
    $.parser.parse(); // 解析整个页面
	obj.SSGroupID = "";
	obj.SSGroupAlias = "";
	
	//安全组列表
	obj.gridSSGroup = $HUI.datagrid("#gridSSGroup",{
		fit: true,
		title: "产品模块权限-安全组",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false, //定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		loadMsg:'数据加载中...',
		columns:[[
			{field:'GrpDesc',title:'安全组',width:'235'},
			{field:'SYSDesc',title:'系统',width:'125'}
		]],
		onSelect:function(rindex,rowData){
			if (rindex>-1) {
				obj.gridSSGroup_onSelect();
			}
		},
		onLoadSuccess:function(data){
			//刷新模块角色授权列表
			obj.treegridMdlPowerLoad();
		}
	});
	
	//安全组检索
	$("#txtSSGroup").keyup(function(){
		obj.SSGroupAlias = $('#txtSSGroup').val();
		obj.gridSSGroupLoad();
		obj.treegridMdlPowerLoad();
	})
	
	//模块角色授权列表
	obj.treegridMdlPower = $HUI.treegrid("#treegridMdlPower",{
		fit: true,
		title: "产品模块权限-模块角色授权",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		idField:'rowIdField',
		treeField:'rowTreeField',
		rownumbers:true,
		showFooter: true,
		checkbox:true,
		loadMsg:'数据加载中...',
		columns:[[
			{field:'rowTreeField',title:'模块角色',width:300,align:'left'},
			{field:'ActDateTime',title:'操作时间',width:160,align:'center'},
			{field:'ActUserDesc',title:'操作人',width:120,align:'center'}
		]],
		onCheckNode:function(row,checked){
			//alert(row["MdlID"] + "," + row["MdlRoleID"]+",checked="+checked);
			if (checked != (row['IsActive'] == '是')){
				obj.UpdateMdlPower(row,checked);
			}
		},
		onBeforeCheckNode:function(row,checked){
			//alert(row["MdlID"] + "," + row["MdlRoleID"]+",checked="+checked);
		},
		onLoadSuccess:function(row,data){
			$.each(data.rows, function(ind,row){
				if (row['IsActive'] == '是'){
					$('#treegridMdlPower').treegrid('checkNode',row['rowIdField']);
				}
			});
		}
	});
	
	InitMdlPowerListWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}