//职业暴露类型->检验结果对照->Gui
function InitExpTypeEpdWin() {
    var obj = new Object();
    obj.RecRowID = "";
    $.parser.parse(); // 解析整个页面

    //初始化下拉菜单
    obj.cboEpdType = Common_ComboDicID('cboEpdType', 'OEPatInfType');
    obj.refreshLabItem = function (ItemCode) {
        var cbox = $HUI.combobox("#" + ItemCode, {
            url: $URL,
            editable: true,
            allowNull: true,
            defaultFilter: 4,     //text字段包含匹配或拼音首字母包含匹配 不区分大小写
            valueField: 'ID',
            textField: 'FieldDesc',
            onBeforeLoad: function (param) {    //在请求加载数据之前触发，返回 false 则取消加载动作
                param.ClassName = 'DHCHAI.DPS.LabTCMapSrv';
                param.QueryName = 'QryLabTCMapToCombo';
                param.ResultSetType = 'array';
            }
        });
        return;
    }
    obj.refreshLabItem("cboLabItem");
    obj.txtLabItemRst = Common_ComboDicID('cboLabOperator', 'OECompOperator');
    obj.refreshLabItem("cboLabItem2");
    obj.txtLabItemRst2 = Common_ComboDicID('cboLabOperator2', 'OECompOperator');
    //职业暴露类型
    obj.gridOccExpTypeEpd = $HUI.datagrid("#gridOccExpTypeEpd", {
        fit: true,
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
            ClassName: "DHCHAI.IRS.OccExpTypeSrv",
            QueryName: "QryOccExpTypeEpd",
            aTypeID: Parref
        },
        columns: [[
			{ field: 'EpdTypeDesc', title: '感染类型', width: '100'},
			{ field: 'BTDesc', title: '规则说明', width: '150'},
            {
                field: 'LabEpdDesc', title: '筛查规则', width: '200',
                formatter: function (value, row, index) {
                    return '<span title="' + value + '">' + value + '</span>';
                }
            },
			{
			    field: 'IsActive', title: '是否有效', width: '100',
			    formatter: function (value, row, index) {
			        return (value == '1' ? '是' : '否');
			    }
			},
			{
			    field: 'ActDate', title: '时间', width: '300',
			    formatter: function (value, row, index) {
			        return row["ActDate"] + ' ' + row["ActTime"];
			    }
			},
            { field: 'ActUser', title: '操作人', width: '100'},
            { field: 'Note', title: '备注', width: '100'}
        ]],
        onSelect: function (rindex, rowData) {
            if (rindex > -1) {
                obj.gridOccExpTypeEpd_onSelect();
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
    InitExpTypeEpdWinEvent(obj);
    obj.LoadEvent(arguments);
    return obj;


}