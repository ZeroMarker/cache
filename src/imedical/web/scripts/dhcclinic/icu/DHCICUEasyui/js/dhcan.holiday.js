$(document).ready(function() {
    var columns = [
        [
            { field: "Code", title: "代码", width: 120 },
            { field: "Description", title: "名称", width: 240 },
            { field: "Alias", title: "别名", width: 160 },
            { field: "AnaTypeDesc", title: "麻醉类型", width: 240 },
            { field: "ActiveDesc", title: "是否激活", width: 120 }
        ]
    ];
    var dataForm = new DataForm({
        datagrid: $("#dataBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#dataTools",
        form: $("#dataForm"),
        modelType: "DHCAN.Holiday",
        queryType: dhcan.bll.dataQuery,
        queryName: "FindHolidays",
        dialog: $("#dataDialog"),
        addButton: $("#btnAdd"),
        editButton: $("#btnEdit"),
        delButton: $("#btnDel"),
        queryButton: $("#btnQuery"),
        submitCallBack: initDefaultValue,
        openCallBack: null,
        closeCallBack: null
    });
    dataForm.initDataForm();

    $("#calendar").fullCalendar({
        height: 600,
        editable: true,
        selectable: true,
        dayClick: function(date, jsEvent, view) {
            $("#DayDate").datebox("setValue", date.format());
            dataDialog.dialog("open");
        },
        eventClick: function(calEvent, jsEvent, view) {
            dataForm.form.form("load", calEvent);
            dataForm.dialog.dialog("open");
        },
        events: function(start, end, timezone, callback) {
            $.ajax({
                url: ANCSP.DataQuery,
                type: "post",
                data: {
                    ClassName: dhcan.bll.dataQuery,
                    QueryName: dataForm.queryName,
                    Arg1: start.format(),
                    Arg2: end.format(),
                    ArgCnt: 2
                },
                dataType: "json",
                success: function(data) {
                    var event = toCalendarDatas(data);
                    callback(event);
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert("error");
                }
            });
        }
    });
});

function toCalendarDatas(jsonDatas) {
    var calendarDatas = [];
    if (jsonDatas && jsonDatas.length > 0) {
        $.each(jsonDatas, function(index, item) {
            calendarDatas.push({
                id: item.RowId,
                title: item.DayTypeDesc,
                allDay: true,
                start: item.DayDate,
                end: item.DayDate,
                DayDate: item.DayDate,
                DayType: item.DayType,
                RowId: item.RowId
            });
        });
    }
    return calendarDatas;
}

function initDefaultValue() {
    $('#calendar').fullCalendar('refetchEvents');
}