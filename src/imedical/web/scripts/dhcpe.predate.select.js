/**
 * Description: 号源时段选择
 * FileName: dhcpe.predate.select.js
 * Creator: wangguoying
 * Date: 2023-02-02
 */


var _GV = {
    Calendar: null,
    locale:"zh-cn"
}

function init() {
	var langcode=session['LOGON.LANGCODE']  //英文模式session
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
        dayCellClassNames: function(dateInfo) { //单元格渲染钩子
            // if (dateInfo.isPast) return "expire-cell";
        },
        dayCellDidMount: function(arg) {
            if (arg.isPast) {
                var tdBg = $(arg.el).find(".fc-daygrid-day-bg");
                tdBg.html("<div style='text-align:center;color: #ccc;'>"+$g("已过期")+"</div>");
                arg.isDisabled = true;
            }
        },
        locale: _GV.locale, //语种
        weekNumbers: true, //显示第几周
        editable: true,
        navLinks: true, //点击跳转
        selectable: true,
        selectMirror: true,
        height: "100%",
        droppable: false,
        progressiveEventRendering: true, //渐进式渲染事件。在接收到每个事件源时呈现它。将导致更多渲染。不会因为某个事件源出错导致所有的都不显示
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
                        $.messager.alert("提示", ret, "error");
                        return false;
                    }
                } catch (e) {
                    $.messager.alert("提示", e.message, "error");
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
                $.messager.alert('提示', '获取数据源失败！', "error");
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