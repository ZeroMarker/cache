$(function() {
    var dataBox = $("#dataBox"),
        dataForm = $("#dataForm");
    dataBox.treegrid({
        idField: "RowId",
        treeField: "Description",
        title: "设备型号",
        columns: [
            [
                //{field:"RowId",title:"RowId",width:120,hidden:true},
                { field: "Description", title: "描述", width: 160 },
                { field: "Code", title: "代码", width: 100 },
                { field: "DeviceTypeDesc", title: "设备类型", width: 160 },
                { field: "CollectType", title: "采集类型", width: 160 },
                { field: "Port", title: "通讯端口号", width: 100 },
                { field: "FactoryDesc", title: "设备厂家", width: 160 },
                { field: "InterfaceTypeDesc", title: "接口类型", width: 100 },
                { field: "DocUrl", title: "配置文档地址", width: 200 }
            ]
        ],
        queryParams: {
            ClassName: dhcan.bll.dataQuery,
            QueryName: "FindDeviceModel",
            Arg1: "",
            Arg2: "",
            Arg3: "",
            Arg4: "",
            ArgCnt: 4
        },
        fit: true,
        singleSelect: true,
        rownumbers: true,
        toolbar: "#dataTools",
        url: ANCSP.DataQuery,
        headerCls: 'panel-header-gray',
        /*striped:true,
        pagination: true,
        pageSize: 200,
        pageList: [50, 100, 200],*/
        onClickRow: function(row) {
            console.log(row);
            dataForm.form('load', row);
        }
    });

    dataForm.form({
        url: dhccl.csp.dataService,
        onSubmit: function(param) {
            param.ClassName = "DHCAN.DeviceModel";
            var isValidata = $(this).form("validate");
            return isValidata;
        },
        /*queryParams:{
            ClassName:"DHCAN.DeviceModel"
        },*/
        success: function(data) {
            dhccl.showMessage(data, "保存", null, null, function() {
                dataForm.form("clear");
                dataBox.treegrid("reload");
            })
        }
    });

    $("#btnQuery").linkbutton({
        onClick: function() {
            dataBox.treegrid("reload", {
                ClassName: dhcan.bll.dataQuery,
                QueryName: "FindDeviceModel",
                Arg1: $("#Factory").combobox("getValue"),
                Arg2: $("#InterfaceType").combobox("getValue"),
                Arg3: $("#DeviceType").combobox("getValue"),
                Arg4: $("#CollectType").val(),
                ArgCnt: 4
            });
        }
    });
    $("#btnAdd").linkbutton({
        onClick: function() {
            $("#RowId").val("");
            dataForm.submit();
        }
    });
    $("#btnEdit").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected(dataBox, true)) {
                dataForm.submit();
            }
        }
    });
    $("#btnDel").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected(dataBox, true)) {
                $.messager.confirm("确认", "是否删除该记录？", function(result) {
                    if (result) {
                        var msg = dhccl.removeData("DHCAN.DeviceModel", $("#RowId").val());
                        dhccl.showMessage(msg, "删除", null, null, function() {
                            dataForm.form("clear");
                            dataBox.treegrid("reload");
                        })
                    }
                })
            }
        }
    })
})

$("#DeviceType").combobox({
    valueField: "RowId",
    textField: "Description",
    url: ANCSP.DataQuery,
    onBeforeLoad: function(param) {
        param.ClassName = dhcan.bll.dataQuery;
        param.QueryName = "FindDeviceType";
        param.ArgCnt = 0;
    }
});
$("#Factory").combobox({
    valueField: "RowId",
    textField: "Description",
    url: ANCSP.DataQuery,
    onBeforeLoad: function(param) {
        param.ClassName = dhcan.bll.dataQuery;
        param.QueryName = "FindDeviceFactory";
        param.ArgCnt = 0;
    }
});
$("#InterfaceType").combobox({
    valueField: "value",
    textField: "text",
    data: [
        { value: "RJ45", text: "RJ45" },
        { value: "USB", text: "USB" },
        { value: "RS232", text: "RS232" },
        { value: "Other", text: "其他" }
    ]
});