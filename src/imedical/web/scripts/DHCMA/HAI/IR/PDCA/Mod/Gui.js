//PDCA模板
var objScreen = new Object();
function InitModWin() {
    var obj = objScreen;
    $.parser.parse();	 	// 解析整个页面

	obj.RecRowID = "";
    //PDCA模板列表
	obj.gridMod = $HUI.datagrid("#gridMod", {
		fit: true,
		iconCls:"icon-resort",
		headerCls:'panel-header-gray',
		pagination: true, 		//如果为true, 则在DataGrid控件底部显示分页工具栏
		singleSelect: true,		//单行选择
		autoRowHeight: false,	//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
		fitColumns: false,
		nowrap: true, 
		fitColumns: true,
		loadMsg:'数据加载中...',
		pageSize: 20,
		pageList : [20,50,100],
		url:$URL,
		queryParams:{
		    ClassName: "DHCHAI.IRS.PDCAModSrv",
		    QueryName: "QryPDCAModBase"
		},
		columns:[[
			{ field: 'Count', title: 'ID', width: 100 },
			{ field: 'ModCode', title: '代码', width: 100},
			{ field: 'ModName', title: '模板名称', width: 200},
            {
                field: 'ModExt', title: '模板定义', width: 200,
                formatter: function (value, row, index) {
                    return " <a href='#' style='white-space:normal; color:#40a2de' onclick='objScreen.OpenView(\"" + row.ModID + "\");'>模板定义</a>";
                }
            },
			{ field: 'IsActive', title: '是否有效', width: 100,
				formatter: function (value, row, index) {
                    return value=="1"?"是":"否";
                }
            },
			{ field: 'ModResume', title: '备注说明', width: 300 }
		]],
		onSelect:function(rindex,rowData){
		    if (rindex > -1) {
		        obj.gridMod_onSelect();
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
	InitModWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
	
	
}