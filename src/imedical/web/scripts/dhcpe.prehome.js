/**
* Description: 主场号源维护
* FileName: dhcpe.prehome.js
* Creator: wangguoying
* Date: 2022-12-09
*/


var _GV = {
    Calendar: null
}

const datesAreOnSameDay = (first, second) =>
    first.getFullYear() === second.getFullYear() &&
    first.getMonth() === second.getMonth() &&
    first.getDate() === second.getDate();

function init() {
    init_calendar();
    // init_event();
    // init_content();
    // init_grid();
}

/**
* [按周复制]  
* @Author wangguoying
* @Date 2022-12-21
*/
function copyByWeek() {
    var beginDate = $("#SWeekDate").datebox("getValue");
    var endDate = $("#TWeekDate").datebox("getValue");
    if (beginDate == "" || endDate == "") {
        $.messager.popover({ msg: "源日期和目标日期都不能为空", type: "error" });
        return false;
    }
    var copyTeam = $("#CopyTeam").checkbox("getValue") ? "Y" : "N";
    $.messager.confirm("提示", "确认将【" + beginDate + "】的号源整周复制到【" + endDate + "】，目标周已存在号源时，将跳过！", function (r) {
        if (r) {
            var ret = tkMakeServerCall("web.DHCPE.PreHomeTeam", "CopyByWeek", $("#H_PGADM").val(), beginDate, endDate, copyTeam, session["LOGON.USERID"]);
            if (ret == "0") {
                $.messager.popover({ msg: "复制成功！", type: "success" });
                $("#copy-week-win").dialog("close");
                _GV.Calendar.refetchEvents();
            } else {
                $.messager.popover({ msg: ret.split("^")[1], type: "error" });
                return false;
            }
        }
    });
}



/**
* [打开编辑窗口]
* @param    {[Object]}    event    [当前号源]  
* @Author wangguoying
* @Date 2022-10-20
*/
function showEditWin(dateStr) {
    var dateStr = dateStr.substring(0, 10);
    var lnk = "dhcpe.prehome.time.csp?&DateStr=" + dateStr + "&PGADM=" + $("#H_PGADM").val();
    $('#TimeEditWin').dialog({
        title: '时段维护： ' + '【' + dateStr + '】 ',
        iconCls: "icon-w-clock",
        closable: false,
        width: 900,
        height: 630,
        cache: false,
        content: "<iframe src='" + lnk + "' style='width:100%;height:100%;border:0'></iframe> ",
        modal: true,
        buttons: [{
            text: '确定',
            iconCls: 'icon-ok',
            handler: function () {
                _GV.Calendar.refetchEvents();
                $HUI.dialog('#TimeEditWin').close();
            }
        }, {
            text: '关闭',
            iconCls: 'icon-cancel',
            handler: function () { _GV.Calendar.refetchEvents(); $HUI.dialog('#TimeEditWin').close(); }
        }]
    });
}
function showWeekCopy() {
    $("#SWeekDate").datebox("setValue", "");
    $("#TWeekDate").datebox("setValue", "");
    $("#CopyTeam").checkbox("check");
    $("#copy-week-win").dialog("open");
}


/**
 * [初始化日历]
 * @Author   wangguoying
 * @DateTime 2021-10-13
 */
function init_calendar() {
    var calendarEl = document.getElementById('calendar');
    _GV.Calendar = new FullCalendar.Calendar(calendarEl, {
        headerToolbar: {
            left: 'prevYear,prev,next,nextYear today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay,list templateWeekBtn'
        },
        customButtons: {
            templateWeekBtn: {
                text: '按周复制', click: function () {
                    showWeekCopy();
                }
            }
        },
        dayCellClassNames: function (dateInfo) { //单元格渲染钩子
            // if (dateInfo.isPast) return "expire-cell";
        },
        dayCellDidMount: function (arg) {
            if (arg.isPast) {
                var tdBg = $(arg.el).find(".fc-daygrid-day-bg");
                tdBg.html("<div style='text-align:center;color: #ccc;'>已过期</div>");
                arg.isDisabled = true;
            }
        },
        eventDidMount: function (arg) {
            var detail = arg.event.extendedProps.detail;
            if (detail && detail != "") {
                var content = document.createElement("div");
                content.innerHTML = detail;
                tippy(arg.el, {
                    content: content
                });
            }
        },
        locale: "zh-cn", //语种
        weekNumbers: true, //显示第几周
        editable: true,
        navLinks: true, //点击跳转
        selectable: true,
        selectMirror: true,
        height: "100%",
        progressiveEventRendering: true, //渐进式渲染事件。在接收到每个事件源时呈现它。将导致更多渲染。不会因为某个事件源出错导致所有的都不显示
        select: function (arg) {
            if (arg.start < new Date() && !datesAreOnSameDay(arg.start, new Date())) {
                $.messager.popover({
                    msg: "已过期",
                    type: "info",
                    timeout: 1000
                });
                return; //今天及以前的不允许再编辑
            }
            showEditWin(arg.startStr);
        },
        eventClick: function (arg) {
            if (arg.event.start < new Date() && !datesAreOnSameDay(arg.event.start, new Date())) {
                $.messager.popover({
                    msg: "已过期",
                    type: "info",
                    timeout: 1000
                });
                return; //今天及以前的不允许再编辑
            }
            showEditWin(arg.event.startStr);
        },
        droppable: false, // this allows things to be dropped onto the calendar
        eventAllow: function (dropInfo, draggedEvent) {
            return false;
        },
        events: {
            url: 'dhcpe.premanager.eventsjson.csp?PGADM=' + $("#H_PGADM").val(),
            method: 'Get',
            extraParams: {
                dateType: 'HOME'
            },
            failure: function () {
                $.messager.alert('提示', '获取数据源失败！', "error");
            }
        },
        eventContent: function (arg) {
            return { html: "<div style='padding-left:5px;'>" + arg.event.title + "</div>" }
        }
    });
    _GV.Calendar.render();
}


$(init);