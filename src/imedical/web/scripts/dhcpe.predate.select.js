/**
 * Description: ��Դʱ��ѡ��
 * FileName: dhcpe.predate.select.js
 * Creator: wangguoying
 * Date: 2023-02-02
 */


var _GV = {
    Calendar: null,
    locale:"zh-cn"
}

function init() {
	var langcode=session['LOGON.LANGCODE']  //Ӣ��ģʽsession
	if(langcode=='EN'){
		_GV.locale="en";	
	}
    init_calendar();
}

function init_calendar() {
    var calendarEl = document.getElementById('calendar');
    _GV.Calendar = new FullCalendar.Calendar(calendarEl, {
        headerToolbar: {
            left: 'prevYear,prev,next,nextYear today',
            center: 'title',
            right: 'dayGridMonth,timeGridWeek,timeGridDay,list'
        },
        dayCellClassNames: function(dateInfo) { //��Ԫ����Ⱦ����
            // if (dateInfo.isPast) return "expire-cell";
        },
        dayCellDidMount: function(arg) {
            if (arg.isPast) {
                var tdBg = $(arg.el).find(".fc-daygrid-day-bg");
                tdBg.html("<div style='text-align:center;color: #ccc;'>"+$g("�ѹ���")+"</div>");
                arg.isDisabled = true;
            }
        },
        locale: _GV.locale, //����
        weekNumbers: true, //��ʾ�ڼ���
        editable: true,
        navLinks: true, //�����ת
        selectable: true,
        selectMirror: true,
        height: "100%",
        droppable: false,
        progressiveEventRendering: true, //����ʽ��Ⱦ�¼����ڽ��յ�ÿ���¼�Դʱ�������������¸�����Ⱦ��������Ϊĳ���¼�Դ���������еĶ�����ʾ
        select: function(arg) {

        },
        eventClick: function(arg) {
            if (arg.event.extendedProps.type == "SELECT") {
                var date = arg.event.startStr.substring(0, 10);
                var time = arg.event.title.substring(0, 17);
                var callback = $("#H_CBFunc").val();
                var winId = $("#H_WinId").val();
                try {
                    var ret = null;
                    var execStr = "ret = parent.window." + callback + "(\""+ $("#H_PIADM").val() + "\",\"" + date + "\",\"" + time + "\",\"" + arg.event.extendedProps.detailId + "\");";
                    eval(execStr);
                    if (ret == 0) {
                        parent.window.$("#" + winId).window("close");
                    } else {
                        $.messager.alert("��ʾ", ret, "error");
                        return false;
                    }
                } catch (e) {
                    $.messager.alert("��ʾ", e.message, "error");
                    return false;
                }
            }
        },
        // eventOrder: "-title",
        events: {
            url: 'dhcpe.premanager.eventsjson.csp',
            method: 'Get',
            extraParams: {
                dateType: 'SELECTDATE',
                preClass: $("#PreClass").switchbox("getValue") ? "O" : "I",
                piadm: $("#H_PIADM").val(),
                extStr: $("#H_ExtStr").val()
            },
            failure: function() {
                $.messager.alert('��ʾ', '��ȡ����Դʧ�ܣ�', "error");
            }
        },
        eventContent: function(arg) {
            return { html: "<div style='padding:2px 5px'>" + arg.event.title + "</div>" }
        },
        eventDidMount: function(arg) {
            var tips = arg.event.extendedProps.tips;
            if (tips && tips != "") {
                var content = document.createElement("div");
                content.innerHTML = arg.event.extendedProps.type == "Time" ? arg.event.title + "<br>" + tips : tips;
                tippy(arg.el, {
                    content: content
                });
            }
        }
    });
    _GV.Calendar.render();
}

$(init);