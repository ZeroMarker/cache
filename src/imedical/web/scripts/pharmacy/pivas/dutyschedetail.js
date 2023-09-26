/**
 * 模块:     排班管理-班次岗位日历
 * 编写日期: 2018-08-28
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var CurDate = "";
$(function() {
    var curDate = new Date();
    var curMonth = curDate.getMonth() + 1;
    CurDate = curDate.getFullYear() + "-" + (curMonth < 10 ? "0" + curMonth : curMonth) + "-" + ((curDate.getDate() < 10) ? ("0" + curDate.getDate()) : curDate.getDate());
    InitGridSchedul();
    InitCalDutySche();
    $('#txtAlias').on('keypress', function(event) {
        if (event.keyCode == "13") {
            Query();
        }
    });
});

function InitGridSchedul() {
    var columns = [
        [{
                field: "psId",
                title: 'psId',
                width: 125,
                hidden: true
            },
            {
                field: "psCode",
                title: '班次代码',
                width: 70
            },
            {
                field: "psDesc",
                title: '班次名称',
                width: 100
            },
            {
                field: "colorFlag",
                title: '颜色标识',
                width: 125,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.DutyScheDetail',
            QueryName: 'PIVASchedul',
            inputStr: SessionLoc
        },
        fitColumns: true,
        columns: columns,
        pagination: false,
        onDblClickRow: function(rowIndex, rowData) {

        },
        rowStyler: function(rowIndex, rowData) {
            var colorFlag = rowData.colorFlag;
            if (colorFlag == 1) {
                //return 'background-color:transparent;';
            } else if (colorFlag == 2) {
                return 'background-color:#e2ffde;color:#3c763d;';
            } else if (colorFlag == 3) {
                return 'background-color:#fff3dd;color:#ff3d2c;';
            }
        },
        onClickRow: function(rowIndex, rowData) {
            // 查询日历
            $('#calDutySche').fullCalendar('refetchEvents');
        },
        onLoadSuccess: function() {
            $('#calDutySche').fullCalendar('refetchEvents');
        }
    };
    // 人员排序,已关联的显示在最上,没有岗位在中间(灰色),其他岗位在最后(浅红)
    DHCPHA_HUI_COM.Grid.Init("gridSchedul", dataGridOption);
}

function InitCalDutySche() {
    $('#calDutySche').fullCalendar({
        header: {
            left: 'prev,next',
            center: 'title',
            right: 'month,basicWeek,basicDay', //agendaWeek,agendaDay 精确时间段的视图
        },
        defaultDate: CurDate,
        editable: false, // 不可拖动
        lang: "zh-cn",
        monthNames: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
        monthNamesShort: ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"],
        dayNames: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
        dayNamesShort: ["周日", "周一", "周二", "周三", "周四", "周五", "周六"],
        today: ["今天"],
        eventColor: "#40a2de",
        eventBorderColor: "white",
        height: 500, // 整体高度
        //contentHeight: 50, // 有数据的行高
        buttonText: {
            today: '|',
            prev: '<',
            next: '>',
            month: '月视图',
            basicWeek: '周视图',
            basicDay: '日视图'
        },
        // 动态查询
        events: function(start, end, timezone, callback) {
            var stDate = moment(start).format('YYYY-MM-DD');
            var edDate = moment(end).format('YYYY-MM-DD');
            var gridSelect = $("#gridSchedul").datagrid("getSelected");
            var scheId = "";
            if (gridSelect != null) {
                scheId = gridSelect.psId;
            }
            var locId = SessionLoc;
            var inputStr = stDate + "^" + edDate + "^" + locId + "^" + scheId;
            $.cm({
                ClassName: "web.DHCSTPIVAS.DutyScheDetail",
                QueryName: "DutyCalenSche",
                inputStr: inputStr,
                ResultSetType: 'Array'
            }, function(retData) {
                events = retData;
                callback(events);
            });

        }

    });
}

function Query() {

}