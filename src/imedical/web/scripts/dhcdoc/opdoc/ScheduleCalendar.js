$(function(){
    InitResCombo();
    InitEvent();
});
function InitEvent(){
    $('.last-month').click(function(){RefreshMonth(-1);});
    $('.next-month').click(function(){RefreshMonth(1);});
    $('#pCalendar').panel({
        onResize:function(){
            RefreshMonth(0);
        }
    });
    $('.schedule-calendar tbody').on('click','div.one-schedule',function(){
        var ASRowid=$(this).attr('ASRowid');
        if(!ASRowid) return;
		var url=window.location.origin+"/imedical/web/form.htm?CASTypeCode=MWHOSAuth2&ViewCode=DocApp&ASRowid="+ASRowid+"&AppMethodID=" +ServerObj.AppMethodID;
        OpenWindow(url,'预约/加号',1600,700);
    });
}
function InitResCombo()
{
    $('#ResComb').singleCombo({
	    editable:false,
	    panelHeight:'auto',
        valueField:'ResRowid',   
        textField:'ResDesc',
        ClassName:'DHCDoc.OPAdm.Appoint',
        QueryName:'QueryDocMark',
        queryParams:{LogonResId:ServerObj.LogResID},
        onSelect:function(record){
            RefreshMonth(0);
        },
        onLoadSuccess:function(data){
            if(data.length){
                $(this).setValue(data[0]['ResRowid']);
            }else{
                RefreshMonth(0);
            }
        }
    });
}
function RefreshMonth(Flag)
{
    var YM=$('#Month').text();
    if(!Number(YM.split('-')[0])) YM=ServerObj.CurDate.split('-').slice(0,2).join('-');
    var Y=YM.split('-')[0];
    var M=YM.split('-')[1];
    M=Number(M)+Flag;
    if(M>12) M=1,Y=Number(Y)+1;
    if(M<1) M=12,Y=Number(Y)-1;
    if(M<10) M='0'+M;
    ReDrawCalendar(Y+'-'+M);
}
function ReDrawCalendar(YM)
{
    $.messager.progress({text:'加载中...'}); 
    $('.schedule-calendar>tbody').empty();
    var Y=YM.split('-')[0];
    var M=YM.split('-')[1];
    $('#Month').text(Y+'-'+M);
    var MonthFirstDate=Y+'-'+M+'-'+'01';
    var NextM=Number(M)+1;
    if(NextM>12) Y=Number(Y)+1,NextM=1;
    if(NextM<10) NextM='0'+NextM;
    var NextMonthFirstDate=Y+'-'+NextM+'-'+'01';
    var MonthLastDate=GetDateAddDays(NextMonthFirstDate,-1);
    var MonthFirstWeek=GetDateWeek(MonthFirstDate);
    var CalendarFirstDate=GetDateAddDays(MonthFirstDate,1-MonthFirstWeek);
    var date = GetDateObj(GetDateAddDays(CalendarFirstDate,-1));
    while(CompareDate(MonthLastDate,date)>=0){
        var $tr=$('<tr></tr>');
        for(var i=0;i<7;i++){
            date.setDate(date.getDate()+1);
            var d=date.getDate();
            if(d<10) d='0'+d;
            var $date=$('<div class="date-tip">'+d+'</div>');
            if((date.getMonth()+1)!=Number(M)) $date.addClass('not-same-month');
            $tr.append($('<td></td>').append($date));
        }
        $('.schedule-calendar>tbody').append($tr);
    }
    $('.schedule-calendar>tbody>tr').height($('.schedule-calendar>tbody').height()/$('.schedule-calendar>tbody>tr').size());
    var CalendarLastDate=$.fn.datebox.defaults.formatter(date);
    var ResRowid=$('#ResComb').getValue();
    if(ResRowid!=""){
        $.cm({ 
            ClassName:"DHCDoc.OPAdm.Appoint",
            MethodName:"GetCalendarSchedule", 
            ResRowid:ResRowid,
            SttDate:CalendarFirstDate,
            EndDate:CalendarLastDate,
            AppMethodID:ServerObj.AppMethodID
        },function(data){
            var tdHeight=$('.schedule-calendar td').height();
            var $calendar=$('.schedule-calendar tbody').find('td');
            $.each(data,function(dayIndex,dayData){
                var ScheduleCnt=dayData.length;
                if(!ScheduleCnt) return true;
                if(ScheduleCnt==1){
                    if(dayData[0].TimeRange.indexOf('上午')>-1){
                        dayData.push({});
                        ScheduleCnt++;
                    }else if(dayData[0].TimeRange.indexOf('下午')>-1){
                        dayData.unshift({});
                        ScheduleCnt++;
                    }
                }
                var itemHeight=tdHeight/ScheduleCnt+'px';
                $.each(dayData,function(itemIndex,scheduleObj){
                    var $schedule=$('<div></div>').css({'height':itemHeight,'line-height':itemHeight});
                    var ASRowid=scheduleObj.ASRowid;
                    if(ASRowid){
                        var TimeRange=scheduleObj.TimeRange;
                        var ASStatusCode=scheduleObj.ASStatusCode;
                        var AvailQty=scheduleObj.AvailQty;
                        $schedule.addClass('one-schedule').attr('ASRowid',ASRowid).text(TimeRange);
                        if(ASStatusCode=="S")  $schedule.addClass("stop");
                        else if(Number(AvailQty)<=0)  $schedule.addClass("no-seqno");
                    }
                    $calendar.eq(dayIndex).append($schedule);
                });
            });
            $.messager.progress('close'); 
        },function(err){
            $.messager.progress('close'); 
        });
    }else{
        $.messager.progress('close');
    }
}
function OpenWindow(url,name,iWidth,iHeight)
{
	url+="&userCode="+session['LOGON.USERCODE']+"&SSUSERGROUPID="+session['LOGON.GROUPID']+"&DEPARTMENTID="+session['LOGON.CTLOCID'];
	var mtop=websys_getTop();
	if(mtop&&mtop.parent&&mtop.parent.postMessage){
		var list = {name:name,link:url,width:iWidth,height:iHeight};
		mtop.parent.postMessage( {embedWindow: list}, "*");
	}else{
		/*websys_showModal({
			iconCls:'icon-w-find',
			url:IndicateObj.linkUrl,
			title:IndicateObj.Text,
			width:'90%',height:'90%'
		});*/
		var iTop = (window.screen.height-30-iHeight)/2;       //获得窗口的垂直位置;
		var iLeft = (window.screen.width-10-iWidth)/2;        //获得窗口的水平位置;
		window.open(url,name,'height='+iHeight+',,innerHeight='+iHeight+',width='+iWidth+',innerWidth='+iWidth+',top='+iTop+',left='+iLeft+',toolbar=no,menubar=no,scrollbars=auto,resizeable=no,location=no,status=no');
	}
}