$(function() {
    $("#dataBox").datagrid({
        headerCls: 'panel-header-gray'
    });
    var columns = [
        [
            { field: "RowId", title: "RowId", width: 120, hidden: true },
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "名称", width: 240 },
            { field: "ModelDesc", title: "设备型号", width: 240 },
            { field: "TcpipAddress", title: "设备IP地址", width: 240 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "麻醉设备",
        gridTool: $("#dataTools"),
        form: $("#dataForm"),
        modelType: "DHCAN.Device",
        queryType: dhcan.bll.dataQuery,
        queryName: "FindDevice",
        dialog: null,
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    dataForm.initDataForm();
})

$("#Model").combobox({
    valueField: "RowId",
    textField: "Description",
    url: ANCSP.DataQuery,
    onBeforeLoad: function(param) {
        param.ClassName = dhcan.bll.dataQuery;
        param.QueryName = "FindDeviceModel";
        param.Arg1 = "";
        param.Arg2 = "";
        param.Arg3 = "";
        param.Arg4 = "";
        param.ArgCnt = 4;
    },
    mode: "remote"
})