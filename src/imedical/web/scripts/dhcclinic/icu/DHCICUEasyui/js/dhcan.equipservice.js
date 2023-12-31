$(document).ready(function() {
    $("#StartDate,#EndDate").datebox("setValue", (new Date()).format("yyyy-MM-dd"));
    var columns = [
        [
            { field: "ServiceDate", title: "日期", width: 100 },
            {
                field: "EquipDesc",
                title: "设备",
                width: 200,
                formatter: function(value, row, index) {
                    return "<h4>设备：" + value + "</h4><p>房间：" + row.LocDesc + "</p><p>品牌：" + row.EquipMFRDesc + "</p><p>型号：" + row.EquipModelDesc + "</p>";
                }
            },
            { field: "Phenomenon", title: "现象", width: 160 },
            { field: "CodeDesc", title: "代码与描述", width: 200 },
            { field: "ServiceMethod", title: "处理方法", width: 200 },
            { field: "ServiceResult", title: "结果", width: 160 },
            { field: "Duration", title: "停机时间", width: 100 },
            { field: "ServiceDeptDesc", title: "维修人科室", width: 120 },
            { field: "ServiceProvDesc", title: "维修人", width: 100 },
            { field: "AppProvDesc", title: "报修人", width: 100 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "设备维修记录",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Model.EquipService,
        queryType: ANCLS.BLL.DataQueries,
        queryName: "FindEquipService",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: initDefaultValue,
        closeCallBack: null
    });
    dataForm.initDataForm();
    dataForm.datagrid.datagrid({
        nowrap: false,
        onBeforeLoad: function(param) {
            param.Arg1 = $("#StartDate").datebox("getValue");
            param.Arg2 = $("#EndDate").datebox("getValue");
            param.ArgCnt = 2;
        }
    });

    $("#Equip").combogrid({
        idField: "RowId",
        textField: "EquipDesc",
        panelWidth: 300,
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.ConfigQueries;
            param.QueryName = "FindDeptEquip";
            param.Arg1 = session.DeptID;
            param.ArgCnt = 1;
        },
        columns: [
            [
                { field: 'EquipCode', title: '设备编号', width: 80 },
                { field: 'EquipDesc', title: '设备名称', width: 100 },
                { field: 'LocDesc', title: '设备位置', width: 80 }
            ]
        ]
    });

    $("#ServiceProv,#AppProv").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = dhccl.bll.admission;
            param.QueryName = "FindCareProvByLoc";
            param.Arg1 = "";
            if (param.q) {
                param.Arg1 = param.q;
            }
            var arg2 = session.DeptID;
            if ($(this).attr("id") === "ServiceProv") {
                arg2 = $("#ServiceDept").combobox("getValue");
            }
            param.Arg2 = arg2;
            param.ArgCnt = 2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote"
    });

    $("#ServiceDept").combobox({
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = dhccl.bll.admission;
            param.QueryName = "FindLocation";
            param.Arg1 = "";
            if (param.q) {
                param.Arg1 = param.q;
            }
            param.Arg2 = "INOPDEPT^OUTOPDEPT^EMOPDEPT^OP^EMOP^OUTOP";
            param.ArgCnt = 2;
        },
        valueField: "RowId",
        textField: "Description",
        mode: "remote",
        onChange: function(newValue, oldValue) {
            $("#ServiceProv").combobox("reload");
        }
    });
});

function initDefaultValue(dataForm) {
    $("#ServiceDept").combobox("setValue", session.DeptID);
    $("#ServiceDate").datebox("setValue", (new Date()).format("yyyy-MM-dd"));
}