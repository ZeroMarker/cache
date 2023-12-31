$(document).ready(function() {
    $("#dataBox").datagrid({
        //headerCls: 'panel-header-gray',
        bodyCls: 'panel-bodyr-gray',
        border: false
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
                    var url = "CT.AN.LegendData.csp?legendID=" + row.RowId;
                    var html = "<a href='#' onclick='openLegendData(\"" + url + "\",\"" + row.Description + "\")'>图例数据</a>";
                    return html;
                }
            }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        //gridTitle: "手术麻醉图例",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: ANCLS.Code.Legend,
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

    $("#FillShape").combobox({
        data:CommonArray.WhetherOrNot,
        valueField:"value",
        textField:"text"
    });
});
$("body").keydown(function (e) {  
    if (e.keyCode == 13) {  
        document.getElementById("btnQuery").click();
    }  
});

function openLegendData(url,Description) {
    var href="<iframe scrolling='yes' frameborder='0' src='" + url + "' style='width:100%;height:100%'></iframe>";
    $("#LegendDataDialog").dialog({
        content:href,
        title:"图例数据-"+Description,
        forceRefreshOnOpen:true,
		iconCls:'icon-w-paper'
    });
    $("#LegendDataDialog").dialog("open");
    //window.open(url);
}

function initDefaultValue() {
    //$("#FillShape").combobox("clear");
}