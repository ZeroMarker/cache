
/*
* Description: �걾�ɼ�һ��
* FileName: DHCPESpecList.new.hisui.js
* Creator: xueying
* Date: 2023-02-21
*/
var locale="zh-cn";

var _GV = {
    Calendar: null
}

const datesAreOnSameDay = (first, second) =>
    first.getFullYear() === second.getFullYear() &&
    first.getMonth() === second.getMonth() &&
    first.getDate() === second.getDate();
    
function init() {

	var langcode=session['LOGON.LANGCODE']  //Ӣ��ģʽsession
	if(langcode=='EN'){
		locale="af";	
	}else{
		locale="zh-cn"
	}


    init_calendar();  
}

// [��ʼ������]
function init_calendar() {
    var calendarEl = document.getElementById('calendar');
    _GV.Calendar = new FullCalendar.Calendar(calendarEl, {
        headerToolbar: {
            left: 'prevYear,prev,next,nextYear today',
            center: 'title',
            //right: 'dayGridMonth,timeGridWeek,timeGridDay,list templateWeekBtn'  
        },
        customButtons: {
	        
        },
        dayCellClassNames: function (dateInfo) { //��Ԫ����Ⱦ����
           
        },
        dayCellDidMount: function (arg) {
	       
	      
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
        locale:locale, //����
        weekNumbers: true, //��ʾ�ڼ���
        editable: true,
        navLinks: true, //�����ת
        selectable: true,
        selectMirror: true,
        height: "100%",
        progressiveEventRendering: true, //����ʽ��Ⱦ�¼����ڽ��յ�ÿ���¼�Դʱ�������������¸�����Ⱦ��������Ϊĳ���¼�Դ���������еĶ�����ʾ
        select: function (arg) {
	        showSpecDetailWin(arg.event.startStr);
        },
        eventClick: function (arg) {
	      
            showSpecDetailWin(arg.event.startStr);
        },
        droppable: false, // this allows things to be dropped onto the calendar
        eventAllow: function (dropInfo, draggedEvent) {
            return false;
        },
        events: {
            url: 'dhcpespecdetail.new.hisui.csp',
            method: 'Get',
            extraParams: {
               
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


//�ɼ���ϸ����
function showSpecDetailWin(dateStr) {
    var dateStr = dateStr.substring(0, 10);
	var lnk = "dhcpespecdetail.hisui.csp?BeginDate=" + dateStr + "&EndDate=" + dateStr + "&Type=Item";
	//websys_lu(lnk,false,'width=1100,height=700,hisui=true,title='+$g('�걾�ɼ���Ϣ'))
	$HUI.window("#SpecDetailWin", {
        		title: "�걾�ɼ���Ϣ",
        		iconCls: "icon-w-paper",
        		collapsible: false,
       			 minimizable: false,
        		maximizable: false,
        		resizable: false,
        		closable: true,
        		modal: true,
        		width: 1100,
        		height: 700,
        		content: '<iframe src="' + PEURLAddToken(lnk) + '" width="100%" height="100%" frameborder="0"></iframe>'
    		}); 
  
}
$(init);