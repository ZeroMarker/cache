﻿//公共模板类型->项目定义->Gui
function InitExpTypeExtWin() {
    var obj = new Object();
    obj.RecRowID = "";
    $.parser.parse(); // 解析整个页面
    //初始化信息
    obj.cboExtType = Common_ComboDicID('cboExtType', 'BPItemType',1);
    obj.cboDatType = Common_ComboDicID('cboDatType', 'BPDataType',1);
    obj.cboDicType = Common_ComboDicID('cboDicType', 'BPDicType',1);
    //公共模板类型
    obj.gridOccExpTypeExt = $HUI.datagrid("#gridOccExpTypeExt", {
        fit: true,
        //title: "公共模板项目定义",
        iconCls: "icon-resort",
        headerCls: 'panel-header-gray',
        pagination: true, //如果为true, 则在DataGrid控件底部显示分页工具栏
        rownumbers: false, //如果为true, 则显示一个行号列
        singleSelect: true,
        autoRowHeight: false,//定义是否设置基于该行内容的行高度。设置为 false，则可以提高加载性能
        fitColumns: false,
        nowrap: true, fitColumns: true,
        loadMsg: '数据加载中...',
        pageSize: 20,
        pageList: [20, 50, 100],
        url: $URL,
        queryParams: {
            ClassName: "DHCHAI.IRS.ComTemplateDefSrv",
            QueryName: "QryComTempTypeExt",
            aTypeID: Parref
        },
        columns: [[
			{ field: 'ID', title: 'ID', width: '100', align: 'left' },
			{ field: 'Code', title: '代码', width: '100', align: 'left' },
			{ field: 'Desc', title: '描述', width: '300', align: 'left' },
			{ field: 'TypeDesc', title: '项目分类', width: '150', align: 'left' },
			{ field: 'DatDesc', title: '数据格式', width: '200', align: 'left' },
            { field: 'DicDesc', title: '关联字典', width: '120', align: 'left' },
            {
                field: 'IsRequired', title: '是否必填', width: '120', align: 'center',
                formatter: function (value, row, index) {
                    return (value == '1' ? '是' : '否');
                }
            }
        ]],
        onSelect: function (rindex, rowData) {
            if (rindex > -1) {
                obj.gridOccExpTypeExt_onSelect();
            }
        },
        onDblClickRow: function (rowIndex, rowData) {
            if (rowIndex > -1) {
                obj.LayerEdit();
                obj.layer(rowData);
            }
        },
        onLoadSuccess: function (data) {
            $("#btnAdd").linkbutton("enable");
            $("#btnEdit").linkbutton("disable");
            $("#btnDelete").linkbutton("disable");
        }
    });
    InitExpTypeExtWinEvent(obj);
    obj.LoadEvent(arguments);
    return obj;


}