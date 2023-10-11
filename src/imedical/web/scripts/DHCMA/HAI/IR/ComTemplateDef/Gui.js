//公共模板类型->Gui
var objScreen = new Object();
function InitExpTypeWin() {
    var obj = objScreen;
    $.parser.parse(); // 解析整个页面

	obj.RecRowID = "";
    //初始化标本类型下拉菜单
	obj.cboUnit = Common_ComboDicID('cboUnit', 'HandHyUnit');
    //公共模板类型
	obj.gridExpType = $HUI.datagrid("#gridExpType", {
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
		    ClassName: "DHCHAI.IRS.ComTemplateDefSrv",
		    QueryName: "QryComTempType"
		},
		columns:[[
			{ field: 'ID', title: 'ID', width: 100, align: 'left' },
			{ field: 'BTCode', title: '代码', width: 100, align: 'left'},
			{ field: 'BTDesc', title: '描述', width: 200,align: 'left' },
            {
                field: 'num1', title: '项目定义', width: 200, align: 'left',
                formatter: function (value, row, index) {
                    return " <a href='#' style='white-space:normal; color:#40a2de' onclick='objScreen.OpenView1(\"" + row.ID + "\");'>项目定义</a>";
                }
            },
            {
                field: 'num2', title: '模板预览', width: 200, align: 'left',
                formatter: function (value, row, index) {
                    return " <a href='#' style='white-space:normal; color:#40a2de' onclick='objScreen.OpenView2(\"" + row.ID + "\");'>模板预览</a>";
                }
            },
			{ field: 'IsActDesc', title: '是否有效', width: 100, align: 'left' },
			{ field: 'Resume', title: '说明', width: 300, align: 'left' }
		]],
		onSelect:function(rindex,rowData){
		    if (rindex > -1) {
		        obj.gridExpType_onSelect();
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
	InitExpTypeWinEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
	
	
}