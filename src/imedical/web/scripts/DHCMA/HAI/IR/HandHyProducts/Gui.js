//页面Gui
function InitHandHyProductsWin() {
	var obj = new Object();
	obj.RecRowID = "";
	$.parser.parse(); // 解析整个页面
    //初始化标本类型下拉菜单
	obj.cboUnit = Common_ComboDicID('cboUnit', 'HandHyUnit');
	//手卫生用品列表
	obj.gridHdProducts = $HUI.datagrid("#gridHdProducts", {
		fit: true,
		//title: "手卫生用品维护",
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
		rownumbers: false, //如果为true, 则显示一个行号列
		singleSelect: true,
		nowrap: true, fitColumns: true, //自动填充
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100],
		url:$URL,
		queryParams:{
		    ClassName: "DHCHAI.IRS.HandHyProductsSrv",
		    QueryName: "QryHHProducts"
		},
		columns:[[
			{ field: 'ID', title: 'ID', width: 100 },
			{ field: 'HHPCode', title: '代码', width: 150},
			{ field: 'HHPDesc', title: '名称', width: 150 },
			{ field: 'HHPPinyin', title: '拼音码', width: 150 },
			{ field: 'HHPSpec', title: '规格', width: 150 },
            { field: 'UnitDesc', title: '单位', width: 150 },
            { field: 'AvgAmount', title: '次均用量', width: 150 },
            {
                field: 'IsActive', title: '是否有效', width: 100,
                formatter: function (value, row, index) {
                    return (value == '1' ? '是' : '否');
                }
            },
            { field: 'Resume', title: '备注', width: 300 }
		]],
		onSelect:function(rindex,rowData){
		    if (rindex > -1) {
		        obj.gridHdProducts_onSelect();
			}
		},
		onDblClickRow:function(rowIndex,rowData){
			if(rowIndex>-1){
			    $('#LayerEdit').show(); 
			    obj.layer(rowData);
			}
		},
		onLoadSuccess:function(data){
			$("#btnAdd").linkbutton("enable");
			$("#btnEdit").linkbutton("disable");
			$("#btnDelete").linkbutton("disable");
		}
	});
	InitHandHyProductsWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
	
	
}