/**
 * 模块:     排班管理-人员排班日历
 * 编写日期: 2018-08-27
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var CurDate = '';
$(function () {
    var curDate = new Date();
    var curMonth = curDate.getMonth() + 1;
    CurDate = curDate.getFullYear() + '-' + (curMonth < 10 ? '0' + curMonth : curMonth) + '-' + (curDate.getDate() < 10 ? '0' + curDate.getDate() : curDate.getDate());
    InitGridUser();
    InitCalUserSche();
    $('#txtAlias').on('keypress', function (event) {
        if (event.keyCode == '13') {
            Query();
        }
    });
    $('.dhcpha-win-mask').remove();
});

function InitGridUser() {
    var columns = [
        [
            {
                field: 'userId',
                title: 'userId',
                width: 125,
                hidden: true
            },
            {
                field: 'userCode',
                title: '人员工号',
                width: 70,
                hidden: true
            },
            {
                field: 'userName',
                title: '人员姓名',
                width: 70
            },
            {
                field: 'colorFlag',
                title: '颜色标识',
                width: 125,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCSTPIVAS.UserSchedul',
            QueryName: 'PIVAScheUser',
            inputStr: SessionLoc
        },
        fitColumns: true,
        toolbar: '#gridUserBar',
        columns: columns,
        pagination: false,
        onDblClickRow: function (rowIndex, rowData) {},
        rowStyler: function (rowIndex, rowData) {
            var colorFlag = rowData.colorFlag;
            if (colorFlag == 1) {
                //return 'background-color:transparent;';
            } else if (colorFlag == 2) {
                return 'background-color:#e2ffde;color:#3c763d;';
            } else if (colorFlag == 3) {
                return 'background-color:#fff3dd;color:#ff3d2c;';
            }
        },
        onClickRow: function (rowIndex, rowData) {
            // 查询日历
            $('#calUserSche').fullCalendar('refetchEvents');
        },
        onLoadSuccess: function () {
            $('#calUserSche').fullCalendar('refetchEvents');
        }
    };
    // 人员排序,已关联的显示在最上,没有岗位在中间(灰色),其他岗位在最后(浅红)
    DHCPHA_HUI_COM.Grid.Init('gridUser', dataGridOption);
}

function InitCalUserSche() {
    $('#calUserSche').fullCalendar({
        header: {
            left: 'prev',
            center: 'title',
            right: 'next' //,basicWeek' // basicDay', //agendaWeek,agendaDay 精确时间段的视图
        },
        defaultDate: CurDate,
        editable: false, // 不可拖动
        lang: 'zh-cn',
        monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
        monthNamesShort: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
        dayNames: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
        dayNamesShort: ['周日', '周一', '周二', '周三', '周四', '周五', '周六'],
        today: ['今天'],
        eventColor: '#40a2de',
        eventBorderColor: 'white',
        height: 500, // 整体高度
        views: {
            dayGridMonth: {
                // name of view
                titleFormat: { year: 'numeric', month: '2-digit', day: '2-digit' }
                // other view-specific options here
            }
        },
        //contentHeight: 50, // 有数据的行高
        /*
        buttonText: {
            today: '|',
            prev: '<',
            next: '>',
            month: '月视图',
            basicWeek: '周视图',
            basicDay: '日视图'
        },*/
        // 动态查询
        events: function (start, end, timezone, callback) {
            var stDate = moment(start).format('YYYY-MM-DD');
            var edDate = moment(end).format('YYYY-MM-DD');
            var gridSelect = $('#gridUser').datagrid('getSelected');
            var userId = '';
            if (gridSelect != null) {
                userId = gridSelect.userId;
            }
            var locId = SessionLoc;
            var inputStr = stDate + '^' + edDate + '^' + locId + '^' + userId;
            $.cm(
                {
                    ClassName: 'web.DHCSTPIVAS.UserSchedul',
                    QueryName: 'UserCalenSche',
                    inputStr: inputStr,
                    ResultSetType: 'Array'
                },
                function (retData) {
                    events = retData;
                    callback(events);
                }
            );
        }
    });
}

function Query() {
    var txtAlias = $('#txtAlias').val();
    $('#gridUser').datagrid('query', {
        inputStr: SessionLoc + '^' + txtAlias
    });
    $('#txtAlias').val('');
}

