$(document).ready(function() {
    $("#dataBox").datagrid({
        headerCls: 'panel-header-gray'
    });
    var columns = [
        [
            { field: "Code", title: "代码", width: 160 },
            { field: "Description", title: "名称", width: 200 },
            { field: "Spec", title: "规格", width: 200 },
            { field: "UnitDesc", title: "单位", width: 120 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "耗材项目",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: "DHCAN.Consumable",
        queryType: dhcan.bll.dataQuery,
        queryName: "FindConsumable",
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
        onBeforeLoad: function(param) {
            param.Arg1 = $("#filterRoom").val();
            param.ArgCnt = 1;
        }
    });

    $("#Unit").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = dhcan.bll.dataQuery;
            param.QueryName = "FindUnit";
            param.ArgCnt = 0;
        }
    });
});

function initDefaultValue(dataForm) {
    // if (dataForm.hasRowSelected(false) === false) {
    //     $("#Active").combobox("setValue", "Y");
    // }
}