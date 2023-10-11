/**
* Description: ������Դά��
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
* [���ܸ���]  
* @Author wangguoying
* @Date 2022-12-21
*/
function copyByWeek() {
    var beginDate = $("#SWeekDate").datebox("getValue");
    var endDate = $("#TWeekDate").datebox("getValue");
    if (beginDate == "" || endDate == "") {
        $.messager.popover({ msg: "Դ���ں�Ŀ�����ڶ�����Ϊ��", type: "error" });
        return false;
    }
    var copyTeam = $("#CopyTeam").checkbox("getValue") ? "Y" : "N";
    $.messager.confirm("��ʾ", "ȷ�Ͻ���" + beginDate + "���ĺ�Դ���ܸ��Ƶ���" + endDate + "����Ŀ�����Ѵ��ں�Դʱ����������", function (r) {
        if (r) {
            var ret = tkMakeServerCall("web.DHCPE.PreHomeTeam", "CopyByWeek", $("#H_PGADM").val(), beginDate, endDate, copyTeam, session["LOGON.USERID"]);
            if (ret == "0") {
                $.messager.popover({ msg: "���Ƴɹ���", type: "success" });
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
* [�򿪱༭����]
* @param    {[Object]}    event    [��ǰ��Դ]  
* @Author wangguoying
* @Date 2022-10-20
*/
function showEditWin(dateStr) {
    var dateStr = dateStr.substring(0, 10);
    var lnk = "dhcpe.prehome.time.csp?&DateStr=" + dateStr + "&PGADM=" + $("#H_PGADM").val();
    $('#TimeEditWin').dialog({
        title: 'ʱ��ά���� ' + '��' + dateStr + '�� ',
        iconCls: "icon-w-clock",
        closable: false,
        width: 900,
        height: 630,
        cache: false,
        content: "<iframe src='" + lnk + "' style='width:100%;height:100%;border:0'></iframe> ",
        modal: true,
        buttons: [{
            text: 'ȷ��',
            iconCls: 'icon-ok',
            handler: function () {
                _GV.Calendar.refetchEvents();
                $HUI.dialog('#TimeEditWin').close();
            }
        }, {
            text: '�ر�',
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
 * [��ʼ������]
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
                text: '���ܸ���', click: function () {
                    showWeekCopy();
                }
            }
        },
        dayCellClassNames: function (dateInfo) { //��Ԫ����Ⱦ����
            // if (dateInfo.isPast) return "expire-cell";
        },
        dayCellDidMount: function (arg) {
            if (arg.isPast) {
                var tdBg = $(arg.el).find(".fc-daygrid-day-bg");
                tdBg.html("<div style='text-align:center;color: #ccc;'>�ѹ���</div>");
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
        locale: "zh-cn", //����
        weekNumbers: true, //��ʾ�ڼ���
        editable: true,
        navLinks: true, //�����ת
        selectable: true,
        selectMirror: true,
        height: "100%",
        progressiveEventRendering: true, //����ʽ��Ⱦ�¼����ڽ��յ�ÿ���¼�Դʱ�������������¸�����Ⱦ��������Ϊĳ���¼�Դ���������еĶ�����ʾ
        select: function (arg) {
            if (arg.start < new Date() && !datesAreOnSameDay(arg.start, new Date())) {
                $.messager.popover({
                    msg: "�ѹ���",
                    type: "info",
                    timeout: 1000
                });
                return; //���켰��ǰ�Ĳ������ٱ༭
            }
            showEditWin(arg.startStr);
        },
        eventClick: function (arg) {
            if (arg.event.start < new Date() && !datesAreOnSameDay(arg.event.start, new Date())) {
                $.messager.popover({
                    msg: "�ѹ���",
                    type: "info",
                    timeout: 1000
                });
                return; //���켰��ǰ�Ĳ������ٱ༭
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
                $.messager.alert('��ʾ', '��ȡ����Դʧ�ܣ�', "error");
            }
        },
        eventContent: function (arg) {
            return { html: "<div style='padding-left:5px;'>" + arg.event.title + "</div>" }
        }
    });
    _GV.Calendar.render();
}


$(init);