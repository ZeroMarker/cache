var workday = {
    calendar:null,
    CareProviderList:null,
    CareProviderGroups:null,
    CareProviderContainer:null
}

$(document).ready(function(){
    var calendarEl = document.getElementById('calendar');

    workday.calendar = $('#calendar').fullCalendar({
        editable: true,
        selectable: true,
        header:{
            left:'prev',
            center:'title',
            right:'today,next'
        }, 
        events:function(start, end, timezone, callback) {
            $.ajax({
                url: ANCSP.DataQuery,
                type: "post",
                data: {
                    ClassName: 'DHCAN.BLL.CrewArrange',
                    QueryName: 'FindWorkdays',
                    Arg1: start.format(),
                    Arg2: end.format(),
                    ArgCnt: 2
                },
                dataType: "json",
                success: function(data) {
                    var events = toCalendarDatas(data);
                    callback(events);
                },
                error: function(jqXHR, textStatus, errorThrown) {
                    alert("error");
                }
            });
        },
        dayClick: function(date, e, view) {
            
        }
    });

     //设置拖拽人员卡片
     $('.event-i').draggable({
        edge: 5,
        revert: true,
        proxy: 'clone',
        cursor: 'pointer',
        onBeforeDrag: function(e) {},
        onStartDrag: function(e) {},
        onStopDrag: function(e) {},
        onEndDrag: function(e) {}
    });

    //workday.calendar.fullCalendar('gotoDate','2019-08-01');
    setDropAreas();

    $('.fc-button').on('click',function(){
        setDropAreas();
    });
});

function setDropAreas(){
    $('.fc-day').droppable({
        accept: '.event-i',
        onDragEnter: function(e, source) {
            $(this).addClass('event-container-dragenter');
        },
        onDragLeave: function(e, source) {
            $(this).removeClass('event-container-dragenter');
        },
        onDrop: function(e, source) {
            var date = $(this).attr('data-date');
            var title = $(source).text();
            var type = $(source).attr('data-type');
            var savingData = {
                ClassName:'DHCAN.Config.Workday',
                DayDate:date,
                DayType:type,
                Description:title
            };
            dhccl.saveDatas(ANCSP.MethodService,{
                ClassName:'DHCAN.BLL.CrewArrange',
                MethodName:'SetWorkday',
                Arg1:session.DeptID,
                Arg2:dhccl.formatObject(savingData),
                Arg3:session.UserID,
                ArgCnt:3
            },function(data){
                workday.calendar.fullCalendar('refetchEvents');
            });
            $(this).removeClass('event-container-dragenter');
        }
    });
}

var editview = {
    render:function(){

    }
}

function toCalendarDatas(jsonDatas) {
    var calendarDatas = [];
    if (jsonDatas && jsonDatas.length > 0) {
        $.each(jsonDatas, function(index, item) {
            calendarDatas.push({
                id: item.RowId,
                title: item.Description,
                allDay: true,
                start: item.DayDate,
                end: item.DayDate,
                backgroundColor: item.DayType=='ON'?'#8A71D6':'#FC5951',
                borderColor: item.DayType=='ON'?'#8A71D6':'#FC5951',
                DayDate: item.DayDate,
                DayType: item.DayType,
                RowId: item.RowId,
            });
        });
    }
    return calendarDatas;
}