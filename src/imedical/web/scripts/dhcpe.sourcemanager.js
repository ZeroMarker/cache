/**
* Description: ��Դ����
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
    $(".panel-header.panel-header-gray").css("border-radius", "4px 4px 0 0"); //�巽Բ��
    init_calendar();
    init_event();
}


function init_event() {

    /** ��Դģ�� */
    $("#BtnTemplate").on("click", showTemplate);

    /** ���� */
    $("#BtnOpen").on("click", function () {
        setStopFlag("N")
    });

    /** ͣ�� */
    $("#BtnStop").on("click", function () {
        setStopFlag("Y")
    });

    /** ���ܸ��� */
    $("#CopyByWeek").on("click", copyByWeek);

    /** ���¸��� */
    $("#CopyByMonth").on("click", copyByMonth);
}

/**
* [��Դģ�崰��]  
* @Author wangguoying
* @Date 2022-10-10
*/
function showTemplate() {
    var lnk = "dhcpe.sourcetemplate.csp"
    $('#SourceTemplateWin').dialog({
        title: 'ʱ��ģ��',
        iconCls: "icon-w-list",
        width: 1400,
        height: 700,
        cache: false,
        closable: false,
        content: "<iframe src='" + PEURLAddToken(lnk) + "' style='width:100%;height:100%;border:0'></iframe> ",
        modal: true,
        buttons: [{
            text: 'ȷ��',
            iconCls: 'icon-ok',
            handler: function () {
                $HUI.dialog('#SourceTemplateWin').close();
                _GV.Calendar.refetchEvents();
            }
        }, {
            text: '�ر�',
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
* [���ٴ���] 
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
        $.messager.popover({ msg: "�ھ���Դ�ͷ��ھ���Դ������Ϊ��", type: "error" });
        return false;
    }
    if (beginDate == "" || endDate == "") {
        $.messager.popover({ msg: "��ʼ���ںͽ������ڲ���Ϊ�գ�", type: "error" });
        return false;
    }
    var ret = tkMakeServerCall("web.DHCPE.Endoscope.SourcePool", "BatchUpdateSource", beginDate + "^" + endDate, total + "^" + otherNum + "^" + publicNum + "^" + expertNum + '^', mode, session["LOGON.USERID"]);
    if (ret == "0") {
        $.messager.popover({ msg: "�����ɹ���", type: "success" });
        _GV.Calendar.refetchEvents();
    } else {
        $.messager.popover({ msg: ret.split("^")[1], type: "error" });
        return false;
    }
}

/**
* [���ܸ��ƺ�Դ] 
* @Author wangguoying
* @Date 2022-10-20
*/
function copyByWeek() {
    var mode = getMode();
    var beginDate = $("#SWeekDate").datebox("getValue");
    var endDate = $("#TWeekDate").datebox("getValue");
    if (beginDate == "" || endDate == "") {
        $.messager.popover({ msg: "Դ�����ܺ�Ŀ�������ܶ�����Ϊ��", type: "error" });
        return false;
    }
    var sDateRange = tkMakeServerCall(_GV.className, "GetWeekDateRange", beginDate, "HTML");
    var eDateRange = tkMakeServerCall(_GV.className, "GetWeekDateRange", endDate, "HTML");
    $.messager.confirm("��ʾ", "ȷ�Ͻ���<label class='tip'>" + sDateRange.split("^")[0] + "��" + sDateRange.split("^")[6] + "</label>���ĺ�Դ��Ӧ���Ƶ���<label class='tip'>" + eDateRange.split("^")[0] + "��" + eDateRange.split("^")[6] + "</label>�����ѱ�ʹ�ú�Դ��������", function (r) {
        if (r) {
            var ret = tkMakeServerCall(_GV.className, "CopySourceByWeek", beginDate, endDate, session["LOGON.CTLOCID"], mode, session["LOGON.USERID"]);
            if (ret == "0") {
                $.messager.popover({ msg: "���Ƴɹ���", type: "success" });
                _GV.Calendar.refetchEvents();
            } else {
                $.messager.popover({ msg: ret.split("^")[1], type: "error" });
                return false;
            }
        }
    });
}


/**
* [���¸��ƺ�Դ] 
* @Author wangguoying
* @Date 2022-10-20
*/
function copyByMonth() {
    var mode = getMode();
    var beginDate = $("#SMonthDate").datebox("getValue");
    var endDate = $("#TMonthDate").datebox("getValue");
    if (beginDate == "" || endDate == "") {
        $.messager.popover({ msg: "Դ�·ݺ�Ŀ���·ݶ�����Ϊ��", type: "error" });
        return false;
    }
    $.messager.confirm("��ʾ", "ȷ�Ͻ���<label class='tip'>" + beginDate + "</label>���ĺ�Դ��Ӧ���Ƶ���<label class='tip'>" + endDate + "</label>�����ѱ�ʹ�ú�Դ��������", function (r) {
        if (r) {
            var ret = tkMakeServerCall(_GV.className, "CopySourceByMonth", beginDate, endDate, session["LOGON.CTLOCID"], mode, session["LOGON.USERID"]);
            if (ret == "0") {
                $.messager.popover({ msg: "�����ɹ���", type: "success" });
                _GV.Calendar.refetchEvents();
            } else {
                $.messager.popover({ msg: ret.split("^")[1], type: "error" });
                return false;
            }
        }
    });
}

/**
* [��ȡ����ģʽ]
* @Author wangguoying
* @Date 2022-08-25
*/
function getMode() {
    return $("input[name='CreateMode']:checked").val();
}

/**
* [�򿪱༭����]
* @param    {[Object]}    event    [��ǰ��Դ]  
* @Author wangguoying
* @Date 2022-10-20
*/
function showEditWin(event) {
    console.log(event);
    var cls = event.extendedProps.type.split("_")[1],
        clsName = cls == "I" ? "�ڲ���Դ" : "�ⲿ��Դ",
        dateStr = event.startStr.substring(0, 10);
    var lnk = "dhcpe.sourcetemplate.time.csp?Type=M&LocID=" + session["LOGON.CTLOCID"] + "&DateStr=" + dateStr + "&Class=" + cls;
    $('#TimeEditWin').dialog({
        title: 'ʱ��ά���� ' + '��' + dateStr + '�� ' + clsName,
        iconCls: "icon-w-clock",
        closable: false,
        width: 1200,
        height: 630,
        cache: false,
        content: "<iframe src='" + PEURLAddToken(lnk) + "' style='width:100%;height:100%;border:0'></iframe> ",
        modal: true,
        buttons: [{
            text: 'ȷ��',
            iconCls: 'icon-w-ok',
            handler: function () {
                _GV.Calendar.refetchEvents();
                $HUI.dialog('#TimeEditWin').close();
            }
        }, {
            text: '�ر�',
            iconCls: 'icon-w-cancel',
            handler: function () { _GV.Calendar.refetchEvents(); $HUI.dialog('#TimeEditWin').close(); }
        }]
    });
}

/**
* [���浥�պ�Դ]   
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
        $.messager.popover({ msg: "���ڲ���Ϊ�գ�", type: "error" });
        return false;
    }
    if (total == "" || otherNum == "") {
        $.messager.popover({ msg: "�ھ���Դ�ͷ��ھ���Դ������Ϊ��", type: "error" });
        return false;
    }
    var ret = tkMakeServerCall("web.DHCPE.Endoscope.SourcePool", "UpdateEndoscopeSource", dateStr, total + "^" + otherNum + "^" + publicNum + "^" + expertNum + '^', session["LOGON.USERID"]);
    if (parseInt(ret) > 0) {
        $HUI.dialog('#manager-edit-win').close();
        $.messager.popover({ msg: "�����ɹ���", type: "success" });
        _GV.Calendar.refetchEvents();
    } else {
        $.messager.popover({ msg: ret.split("^")[1], type: "error" });
        return false;
    }
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
            right: 'dayGridMonth,timeGridWeek,timeGridDay,list'
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
        locale: "zh-cn", //����
        weekNumbers: true, //��ʾ�ڼ���
        editable: true,
        navLinks: true, //�����ת
        selectable: true,
        selectMirror: true,
        height: "100%",
        droppable: true,
        progressiveEventRendering: true, //����ʽ��Ⱦ�¼����ڽ��յ�ÿ���¼�Դʱ�������������¸�����Ⱦ��������Ϊĳ���¼�Դ���������еĶ�����ʾ
        select: function (arg) {

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
                $.messager.alert('��ʾ', '��ȡ����Դʧ�ܣ�', "error");
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
            return dropInfo.allDay && draggedEvent.allDay && dropInfo.end > new Date();  //ֻ�����ƶ�ȫ���ճ�

        },
        eventReceive: function (info) {
        },
        eventDrop: eventDrop
    });
    _GV.Calendar.render();
}

/**
* [����Event���ú󴥷�]
* @param    {[Object]}    eventDrop    [�ϷŲ���]
* @return   {[object]}    
* @Author wangguoying
* @Date 2022-10-20
*/
function eventDrop(eventDropInfo) {
    var oldDate = eventDropInfo.oldEvent.startStr,
        newDate = eventDropInfo.event.startStr,
        clsType = eventDropInfo.oldEvent.extendedProps.type.split("_")[1],
        clsText = clsType == "I" ? "�ڲ���Դ" : "�ⲿ��Դ";
    new Promise((resolve, reject) => {
        $.messager.confirm("��ʾ", "ȷ�Ͻ���<label class='tip'>" + oldDate + "</label>���ġ�<label class='tip'>" + clsText + "</label>�����Ƶ���<label class='tip'>" + newDate + "</label>��", function (r) {
            if (r) {
                resolve();
            }
        });
    }).then(() => {
        var events = _GV.Calendar.getEvents();
        var existRecord = events.find(el => el.allDay && el.startStr == newDate && el.extendedProps.type == "Day_" + clsType && el._instance.defId != eventDropInfo.oldEvent._instance.defId);
        if (existRecord) {
            $.messager.confirm("��ʾ", "��<label class='tip'>" + oldDate + "</label>���Ѵ��ڡ�<label class='tip'>" + clsText + "</label>�����Ƿ񸲸ǣ�", function (r) {
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
* [��������� ����]
* @param    {[String]}    param    []
* @return   {[object]}    
* @Author wangguoying
* @Date 2022-10-20
*/
function copyByDate(SourceDate, EndDate, ClsType) {
    var ret = tkMakeServerCall(_GV.className, "CopyByDate", SourceDate, EndDate, session["LOGON.CTLOCID"], ClsType, "COVER", session["LOGON.USERID"]);
    if (ret == "0") {
        $.messager.popover({ msg: "���Ƴɹ���", type: "success" });
        _GV.Calendar.refetchEvents();
    } else {
        $.messager.popover({ msg: ret.split("^")[1], type: "error" });
        return false;
    }
}

/**
* [��/ͣ��]
* @param    {[String]}    flag    [Y��ͣ��  N������]
* @return   {[object]}    
* @Author wangguoying
* @Date 2022-10-20
*/
function setStopFlag(flag) {
    var beginDate = $("#QucikBeginDate").datebox("getValue");
    var endDate = $("#QucikEndDate").datebox("getValue");
    if (beginDate == "" || endDate == "") {
        $.messager.popover({ msg: "��ʼ���ںͽ������ڲ���Ϊ�գ�", type: "error" });
        return false;
    }
    var statDesc = flag == "Y" ? "ͣ��" : "����";
    tips = "ȷ������" + beginDate + "��" + endDate + "�����óɡ�" + statDesc + "��״̬��";
    tips = flag == "Y" ? tips + " <br><label class='tip'>ͣ��󽫲�����ԤԼ��ʱ��Σ�</label>" : tips;
    $.messager.confirm("��ʾ", tips, function (r) {
        if (r) {
            var ret = tkMakeServerCall(_GV.className, "SetStoFlag", beginDate, endDate, flag, session["LOGON.CTLOCID"], session["LOGON.USERID"]);
            if (ret == "0") {
                $.messager.popover({ msg: "���óɹ���", type: "success" });
                _GV.Calendar.refetchEvents();
            } else {
                $.messager.popover({ msg: ret.split("^")[1], type: "error" });
                return false;
            }
        }
    });
}

$(init);