var objScreen = new Object();
function InitIndexBaseWin() {
    var obj = objScreen;
    $.parser.parse(); // 解析整个页面

	obj.RecRowID = "";
    //PDCA指标库
	obj.gridIndexBase = $HUI.datagrid("#gridIndexBase", {
		fit: true,
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		autoRowHeight: false,//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		fitColumns: false,
		nowrap: true, fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100],
		url:$URL,
		queryParams:{
		    ClassName: "DHCHAI.IRS.PDCAIndexBaseSrv",
		    QueryName: "QryPDCAIndexBase"
		},
		columns:[[
			{ field: 'ID', title: 'ID', width: 40 },
			{ field: 'IndexCode', title: '指标代码', width: 100},
			{ field: 'IndexDesc', title: '指标名称', width: 100},
			/*指标分类(暂时不启用)
			{ field: 'IndexType', title: '指标分类', width: 100},
			*/
			{ field: 'KPA', title: '标准值', width: 50},
			{ field: 'LinkRep', title: '报表名称', width: 150},
			{ field: 'LinkRepPath', title: '报表路径', width: 180},
			{ field: 'LinkParm', title: '报表参数', width: 180},
			{ field: 'LinkCsp', title: '关联csp', width: 100},
			{ field: 'IsActive', title: '是否有效', width: 50,
				formatter: function (value, row, index) {
                    return value=="1"?"是":"否";
                }
			}
		]],
		onSelect:function(rindex,rowData){
		    if (rindex > -1) {
		        obj.gridIndexBase_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
			    obj.LayerEdit();    //打开编辑框
			    obj.layer(rowData);     //初始化编辑框
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	
	InitIndexBaseWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}