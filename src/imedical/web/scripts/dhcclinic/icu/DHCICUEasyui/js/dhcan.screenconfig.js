$(document).ready(function() {
    var columns = [
        [
            { field: "FloorDesc", title: "手术楼层", width: 120 },
            { field: "ClientIP", title: "客户端IP", width: 240 },
            { field: "Description", title: "大屏名称", width: 160 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "大屏配置",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Config.Screen,
        queryType: ANCLS.BLL.ConfigQueries,
        queryName: "FindScreenConfig",
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
            param.Arg1 = $("#filterOperFloor").val();
            param.ArgCnt = 1;
        }
    })

    $("#filterOperFloor,#Floor").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: dhcan.bll.dataQuery,
        //     QueryName: "FindAnaestType",
        //     ArgCnt: 0
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindOperFloor";
            param.ArgCnt = 0;
        }
    });

});

function initDefaultValue(dataForm) {

}