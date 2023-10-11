
/*
* Description: 标本采集一览
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

	var langcode=session['LOGON.LANGCODE']  //英文模式session
	if(langcode=='EN'){
		locale="af";	
	}else{
		locale="zh-cn"
	}


    init_calendar();  
}

// [初始化日历]
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
        dayCellClassNames: function (dateInfo) { //单元格渲染钩子
           
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
        locale:locale, //语种
        weekNumbers: true, //显示第几周
        editable: true,
        navLinks: true, //点击跳转
        selectable: true,
        selectMirror: true,
        height: "100%",
        progressiveEventRendering: true, //渐进式渲染事件。在接收到每个事件源时呈现它。将导致更多渲染。不会因为某个事件源出错导致所有的都不显示
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
                $.messager.alert('提示', '获取数据源失败！', "error");
            }
        },
        eventContent: function (arg) {
            return { html: "<div style='padding-left:5px;'>" + arg.event.title + "</div>" }
        }
    });
    _GV.Calendar.render();
}


//采集明细窗口
function showSpecDetailWin(dateStr) {
    var dateStr = dateStr.substring(0, 10);
	var lnk = "dhcpespecdetail.hisui.csp?BeginDate=" + dateStr + "&EndDate=" + dateStr + "&Type=Item";
	//websys_lu(lnk,false,'width=1100,height=700,hisui=true,title='+$g('标本采集信息'))
	$HUI.window("#SpecDetailWin", {
        		title: "标本采集信息",
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