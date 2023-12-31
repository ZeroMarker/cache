$(document).ready(function() {
    $("#dataBox").datagrid({
        headerCls: 'panel-header-gray'
    });
    var columns = [
        [
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "名称", width: 160 },
            { field: "BasePosX", title: "中心X坐标", width: 100 },
            { field: "BasePosY", title: "中心Y坐标", width: 100 },
            { field: "Width", title: "图例宽度", width: 100 },
            { field: "Height", title: "图例高度", width: 100 },
            { field: "LineWeight", title: "线宽", width: 100 },
            { field: "ImageUrl", title: "图片URL", width: 160 },
            { field: "FillShapeDesc", title: "填充图形", width: 80 },
            {
                field: "Operation",
                title: "图例数据",
                width: 160,
                formatter: function(value, row, index) {
                    var url = "dhcan.legenddata.csp?legendID=" + row.RowId;
                    var html = "<a href='#' onclick='openLegendData(\"" + url + "\")'>图例数据</a>";
                    return html;
                }
            }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "手术麻醉图例",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: "DHCAN.Code.Legend",
        queryType: ANCLS.BLL.CodeQueries,
        queryName: "FindLegends",
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
            param.Arg1 = $("#filterDesc").val();
            param.ArgCnt = 1;
        }
    });
});

function openLegendData(url) {
    window.open(url);
}

function initDefaultValue() {
    $("#FillShape").combobox("clear");
}