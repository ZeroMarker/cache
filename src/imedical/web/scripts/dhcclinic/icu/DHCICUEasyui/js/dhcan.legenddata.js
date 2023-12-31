$(document).ready(function() {
    var columns = [
        [
            { field: "ShapeTypeDesc", title: "形状", width: 120 },
            { field: "StartPosX", title: "起点(圆心)X坐标", width: 120 },
            { field: "StartPosY", title: "起点(圆心)Y坐标", width: 120 },
            { field: "EndPosX", title: "终点X坐标", width: 120 },
            { field: "EndPosY", title: "终点Y坐标", width: 120 },
            { field: "Radius", title: "圆半径", width: 100 },
            { field: "RadianMultiple", title: "弧度倍数", width: 100 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术麻醉图例数据",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: "DHCAN.Code.LegendData",
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindLegendData",
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

    $("#Legend").val(dhccl.getQueryString("legendID"));
    dataForm.datagrid.datagrid({
        onBeforeLoad: function(param) {
            param.Arg1 = dhccl.getQueryString("legendID");
            param.ArgCnt = 1;
        }
    });
});

function initDefaultValue() {
    $("#Legend").val(dhccl.getQueryString("legendID"));
}