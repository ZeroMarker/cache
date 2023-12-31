$(document).ready(function() {
    $("#dataBox").datagrid({
        headerCls: 'panel-header-gray'
    });
    var columns = [
        [
            { field: "ConsumableDesc", title: "耗材项目", width: 160 },
            { field: "Spec", title: "规格", width: 160 },
            { field: "Qty", title: "数量", width: 100 },
            { field: "UnitDesc", title: "单位", width: 120 },
            { field: "RegUserDesc", title: "入库人", width: 120 },
            { field: "RegDateTime", title: "入库时间", width: 200 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "耗材入库登记",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: "DHCAN.ConsumableRegister",
        queryType: dhcan.bll.dataQuery,
        queryName: "FindConsumableRegister",
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