/**
* Description: 号源管理
* FileName: dhcpe.sourcemanager.js
* Creator: wangguoying
* Date: 2022-10-10
*/

var _GV = {
    className: "web.DHCPE.SourceManager",
    Calendar: null
}

const datesAreOnSameDay = (first, second) =>
    first.getFullYear() === second.getFullYear() &&
    first.getMonth() === second.getMonth() &&
    first.getDate() === second.getDate();

function init() {
    $(".panel-header.panel-header-gray").css("border-radius", "4px 4px 0 0"); //五方圆角
    init_calendar();
    init_event();
}


function init_event() {

    /** 号源模板 */
    $("#BtnTemplate").on("click", showTemplate);

    /** 开诊 */
    $("#BtnOpen").on("click", function () {
        setStopFlag("N")
    });

    /** 停诊 */
    $("#BtnStop").on("click", function () {
        setStopFlag("Y")
    });

    /** 按周复制 */
    $("#CopyByWeek").on("click", copyByWeek);

    /** 按月复制 */
    $("#CopyByMonth").on("click", copyByMonth);
}

/**
* [号源模板窗口]  
* @Author wangguoying
* @Date 2022-10-10
*/
function showTemplate() {
    var lnk = "dhcpe.sourcetemplate.csp"
    $('#SourceTemplateWin').dialog({
        title: '时段模板',
        iconCls: "icon-w-list",
        width: 1400,
        height: 700,
        cache: false,
        closable: false,
        content: "<iframe src='" + PEURLAddToken(lnk) + "' style='width:100%;height:100%;border:0'></iframe> ",
        modal: true,
        buttons: [{
            text: '确定',
            iconCls: 'icon-ok',
            handler: function () {
                $HUI.dialog('#SourceTemplateWin').close();
                _GV.Calendar.refetchEvents();
            }
        }, {
            text: '关闭',
            iconCls: 'icon-cancel',
            handler: function () { $HUI.dialog('#SourceTemplateWin').close(); }
        }]
    });
}

function quickClean() {
    $("#TotalNum").val("");
    $("#QucikBeginDate").datebox("setValue", "");
    $("#QucikEndDate").datebox("setValue", "");
}




function updateCanlendarSize() {
    _GV.Calendar.updateSize();
}


/**
* [快速创建] 
* @Author wangguoying
* @Date 2022-08-25
*/
function quickCreate() {
    var mode = getMode();
    var total = $("#TotalNum").val();
    var otherNum = $("#OtherNum").val();
    var publicNum = $("#PublicNum").val();
    var expertNum = $("#ExpertNum").val();
    var beginDate = $("#QucikBeginDate").datebox("getValue");
    var endDate = $("#QucikEndDate").datebox("getValue");
    if (total == "" || otherNum == "") {
        $.messager.popover({ msg: "内镜号源和非内镜号源都不能为空", type: "error" });
        return false;
    }
    if (beginDate == "" || endDate == "") {
        $.messager.popover({ msg: "开始日期和结束日期不能为空！", type: "error" });
        return false;
    }
    var ret = tkMakeServerCall("web.DHCPE.Endoscope.SourcePool", "BatchUpdateSource", beginDate + "^" + endDate, total + "^" + otherNum + "^" + publicNum + "^" + expertNum + '^', mode, session["LOGON.USERID"]);
    if (ret == "0") {
        $.messager.popover({ msg: "创建成功！", type: "success" });
        _GV.Calendar.refetchEvents();
    } else {
        $.messager.popover({ msg: ret.split("^")[1], type: "error" });
        return false;
    }
}

/**
* [按周复制号源] 
* @Author wangguoying
* @Date 2022-10-20
*/
function copyByWeek() {
    var mode = getMode();
    var beginDate = $("#SWeekDate").datebox("getValue");
    var endDate = $("#TWeekDate").datebox("getValue");
    if (beginDate == "" || endDate == "") {
        $.messager.popover({ msg: "源日期周和目标日期周都不能为空", type: "error" });
        return false;
    }
    var sDateRange = tkMakeServerCall(_GV.className, "GetWeekDateRange", beginDate, "HTML");
    var eDateRange = tkMakeServerCall(_GV.className, "GetWeekDateRange", endDate, "HTML");
    $.messager.confirm("提示", "确认将【<label class='tip'>" + sDateRange.split("^")[0] + "至" + sDateRange.split("^")[6] + "</label>】的号源对应复制到【<label class='tip'>" + eDateRange.split("^")[0] + "至" + eDateRange.split("^")[6] + "</label>】，已被使用号源将跳过！", function (r) {
        if (r) {
            var ret = tkMakeServerCall(_GV.className, "CopySourceByWeek", beginDate, endDate, session["LOGON.CTLOCID"], mode, session["LOGON.USERID"]);
            if (ret == "0") {
                $.messager.popover({ msg: "复制成功！", type: "success" });
                _GV.Calendar.refetchEvents();
            } else {
                $.messager.popover({ msg: ret.split("^")[1], type: "error" });
                return false;
            }
        }
    });
}


/**
* [按月复制号源] 
* @Author wangguoying
* @Date 2022-10-20
*/
function copyByMonth() {
    var mode = getMode();
    var beginDate = $("#SMonthDate").datebox("getValue");
    var endDate = $("#TMonthDate").datebox("getValue");
    if (beginDate == "" || endDate == "") {
        $.messager.popover({ msg: "源月份和目标月份都不能为空", type: "error" });
        return false;
    }
    $.messager.confirm("提示", "确认将【<label class='tip'>" + beginDate + "</label>】的号源对应复制到【<label class='tip'>" + endDate + "</label>】，已被使用号源将跳过！", function (r) {
        if (r) {
            var ret = tkMakeServerCall(_GV.className, "CopySourceByMonth", beginDate, endDate, session["LOGON.CTLOCID"], mode, session["LOGON.USERID"]);
            if (ret == "0") {
                $.messager.popover({ msg: "创建成功！", type: "success" });
                _GV.Calendar.refetchEvents();
            } else {
                $.messager.popover({ msg: ret.split("^")[1], type: "error" });
                return false;
            }
        }
    });
}

/**
* [获取创建模式]
* @Author wangguoying
* @Date 2022-08-25
*/
function getMode() {
    return $("input[name='CreateMode']:checked").val();
}

/**
* [打开编辑窗口]
* @param    {[Object]}    event    [当前号源]  
* @Author wangguoying
* @Date 2022-10-20
*/
function showEditWin(event) {
    console.log(event);
    var cls = event.extendedProps.type.split("_")[1],
        clsName = cls == "I" ? "内部号源" : "外部号源",
        dateStr = event.startStr.substring(0, 10);
    var lnk = "dhcpe.sourcetemplate.time.csp?Type=M&LocID=" + session["LOGON.CTLOCID"] + "&DateStr=" + dateStr + "&Class=" + cls;
    $('#TimeEditWin').dialog({
        title: '时段维护： ' + '【' + dateStr + '】 ' + clsName,
        iconCls: "icon-w-clock",
        closable: false,
        width: 1200,
        height: 630,
        cache: false,
        content: "<iframe src='" + PEURLAddToken(lnk) + "' style='width:100%;height:100%;border:0'></iframe> ",
        modal: true,
        buttons: [{
            text: '确定',
            iconCls: 'icon-w-ok',
            handler: function () {
                _GV.Calendar.refetchEvents();
                $HUI.dialog('#TimeEditWin').close();
            }
        }, {
            text: '关闭',
            iconCls: 'icon-w-cancel',
            handler: function () { _GV.Calendar.refetchEvents(); $HUI.dialog('#TimeEditWin').close(); }
        }]
    });
}

/**
* [保存单日号源]   
* @Author wangguoying
* @Date 2022-08-25
*/
function saveSouce() {
    var dateStr = $("#W_CurDate").html()
    var total = $("#W_TotalNum").val();
    var otherNum = $("#W_OtherNum").val();
    var publicNum = $("#W_PublicNum").val();
    var expertNum = $("#W_ExpertNum").val();
    if (dateStr == "") {
        $.messager.popover({ msg: "日期不能为空！", type: "error" });
        return false;
    }
    if (total == "" || otherNum == "") {
        $.messager.popover({ msg: "内镜号源和非内镜号源都不能为空", type: "error" });
        return false;
    }
    var ret = tkMakeServerCall("web.DHCPE.Endoscope.SourcePool", "UpdateEndoscopeSource", dateStr, total + "^" + otherNum + "^" + publicNum + "^" + expertNum + '^', session["LOGON.USERID"]);
    if (parseInt(ret) > 0) {
        $HUI.dialog('#manager-edit-win').close();
        $.messager.popover({ msg: "创建成功！", type: "success" });
        _GV.Calendar.refetchEvents();
    } else {
        $.messager.popover({ msg: ret.split("^")[1], type: "error" });
        return false;
    }
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
            right: 'dayGridMonth,timeGridWeek,timeGridDay,list'
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
        locale: "zh-cn", //语种
        weekNumbers: true, //显示第几周
        editable: true,
        navLinks: true, //点击跳转
        selectable: true,
        selectMirror: true,
        height: "100%",
        droppable: true,
        progressiveEventRendering: true, //渐进式渲染事件。在接收到每个事件源时呈现它。将导致更多渲染。不会因为某个事件源出错导致所有的都不显示
        select: function (arg) {

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
            showEditWin(arg.event);
        },
        eventOrder: "-title",
        events: {
            url: 'dhcpe.premanager.eventsjson.csp',
            method: 'Get',
            extraParams: {
                dateType: 'SM'
            },
            failure: function () {
                $.messager.alert('提示', '获取数据源失败！', "error");
            }
        },
        eventContent: function (arg) {
            return { html: "<div style='padding:5px;'>" + arg.event.title + "</div>" }
        },
        eventDidMount: function (arg) {
            var tips = arg.event.extendedProps.tips;
            if (tips && tips != "") {
                var content = document.createElement("div");
                content.innerHTML = arg.event.extendedProps.type == "Time" ? arg.event.title + "<br>" + tips : tips;
                tippy(arg.el, {
                    content: content
                });
            }
        },
        eventAllow: function (dropInfo, draggedEvent) {
            return dropInfo.allDay && draggedEvent.allDay && dropInfo.end > new Date();  //只允许移动全天日程

        },
        eventReceive: function (info) {
        },
        eventDrop: eventDrop
    });
    _GV.Calendar.render();
}

/**
* [排期Event放置后触发]
* @param    {[Object]}    eventDrop    [拖放参数]
* @return   {[object]}    
* @Author wangguoying
* @Date 2022-10-20
*/
function eventDrop(eventDropInfo) {
    var oldDate = eventDropInfo.oldEvent.startStr,
        newDate = eventDropInfo.event.startStr,
        clsType = eventDropInfo.oldEvent.extendedProps.type.split("_")[1],
        clsText = clsType == "I" ? "内部号源" : "外部号源";
    new Promise((resolve, reject) => {
        $.messager.confirm("提示", "确认将【<label class='tip'>" + oldDate + "</label>】的【<label class='tip'>" + clsText + "</label>】复制到【<label class='tip'>" + newDate + "</label>】", function (r) {
            if (r) {
                resolve();
            }
        });
    }).then(() => {
        var events = _GV.Calendar.getEvents();
        var existRecord = events.find(el => el.allDay && el.startStr == newDate && el.extendedProps.type == "Day_" + clsType && el._instance.defId != eventDropInfo.oldEvent._instance.defId);
        if (existRecord) {
            $.messager.confirm("提示", "【<label class='tip'>" + oldDate + "</label>】已存在【<label class='tip'>" + clsText + "</label>】，是否覆盖？", function (r) {
                if (r) {
                    copyByDate(oldDate, newDate, clsType);
                }
            });
        } else {
            copyByDate(oldDate, newDate, clsType);
        }
    });
    eventDropInfo.revert();
}

/**
* [按日期类别 复制]
* @param    {[String]}    param    []
* @return   {[object]}    
* @Author wangguoying
* @Date 2022-10-20
*/
function copyByDate(SourceDate, EndDate, ClsType) {
    var ret = tkMakeServerCall(_GV.className, "CopyByDate", SourceDate, EndDate, session["LOGON.CTLOCID"], ClsType, "COVER", session["LOGON.USERID"]);
    if (ret == "0") {
        $.messager.popover({ msg: "复制成功！", type: "success" });
        _GV.Calendar.refetchEvents();
    } else {
        $.messager.popover({ msg: ret.split("^")[1], type: "error" });
        return false;
    }
}

/**
* [开/停诊]
* @param    {[String]}    flag    [Y：停诊  N：开诊]
* @return   {[object]}    
* @Author wangguoying
* @Date 2022-10-20
*/
function setStopFlag(flag) {
    var beginDate = $("#QucikBeginDate").datebox("getValue");
    var endDate = $("#QucikEndDate").datebox("getValue");
    if (beginDate == "" || endDate == "") {
        $.messager.popover({ msg: "开始日期和结束日期不能为空！", type: "error" });
        return false;
    }
    var statDesc = flag == "Y" ? "停诊" : "开诊";
    tips = "确定将【" + beginDate + "至" + endDate + "】设置成【" + statDesc + "】状态？";
    tips = flag == "Y" ? tips + " <br><label class='tip'>停诊后将不允许预约该时间段！</label>" : tips;
    $.messager.confirm("提示", tips, function (r) {
        if (r) {
            var ret = tkMakeServerCall(_GV.className, "SetStoFlag", beginDate, endDate, flag, session["LOGON.CTLOCID"], session["LOGON.USERID"]);
            if (ret == "0") {
                $.messager.popover({ msg: "设置成功！", type: "success" });
                _GV.Calendar.refetchEvents();
            } else {
                $.messager.popover({ msg: ret.split("^")[1], type: "error" });
                return false;
            }
        }
    });
}

$(init);