$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "名称", width: 160 },
            { field: "EquipTypeDesc", title: "类型", width: 120 },
            { field: "EquipMFRDesc", title: "品牌", width: 120 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "设备型号",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.EquipModel,
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindEquipModel",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: null,
        openCallBack: null,
        closeCallBack: null
    });
    dataForm.initDataForm();

    dataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterEquipMFR").combobox("getValue");
            param.ArgCnt = 1
        }
    });

    $("#filterEquipMFR,#EquipMFR").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindEquipMFR";
            param.ArgCnt = 0;
        }
    });

    $("#EquipType").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindEquipType";
            param.ArgCnt = 0;
        }
    });
});