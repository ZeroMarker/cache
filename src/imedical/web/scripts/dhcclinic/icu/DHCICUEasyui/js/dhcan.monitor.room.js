/**
 * 实时监控：术间总览
 * @author yongyang 2019-05-08
 */

var monitor = {
    operDeptList: [],
    roomList:[]
}

$(document).ready(function() {
    monitor.header = $('#header');
    monitor.content = $('#content');
    loadOperRoom();
});

/**
 * 加载手术间
 */
function loadOperRoom() {
    dhccl.getDatas(ANCSP.MethodService, {
        ClassName: 'DHCAN.BLL.RealTimeMonitor',
        MethodName: 'GetRoomSummaryInfo',
        Arg1: "",
        Arg2:session.DeptID,
        ArgCnt: 1
    }, 'text', true, function(data) {
        if (data) {
            var data = $.parseJSON(data);
            monitor.operDeptList = data.OperDepts
            monitor.roomList = [];
            monitor.content.hide();
            monitor.content.empty();
            $.each(data.OperDepts,function(index,operDept){
                monitor.roomList = monitor.roomList.concat(operDept.Rooms);
                
                var headerEl=$('<span class="operdept-tag operdept-tag-selected"></span>')
                .attr('data-rowid',operDept.RowId)
                .text(operDept.Description)
                .appendTo(monitor.header);

                var contentEl=$('<div class="operdept"></div>')
                .appendTo(monitor.content);

                deptview.render(contentEl,operDept);
            });
            monitor.content.show();
        }
    })
}

/**
 * 手术科室视图
 */
var deptview = {
    render:function(container, dept){
        container.empty();
        container.data('data',dept);

        var header = $('<div class="operdept-header"></div>').appendTo(container);
        var content = $('<div class="operdept-content"></div>').appendTo(container);

        $('<span class="operdept-header-text"></span>').text(dept.Description).appendTo(header);
        var summary=dept.Summary;
        var summaryEl=$('<span class="operdept-header-summary"></span>')
        .append('<span>共<span class="operdept-badge">'+(summary.Total||0)+'</span>手术间</span>')
        .append('<span>已占用<span class="operdept-badge">'+(summary.Occupied||0)+'</span>间</span>')
        .append('<span>空闲<span class="operdept-badge">'+(summary.Available||0)+'</span>间</span>')
        .appendTo(header);

        $.each(dept.Rooms,function(index,room){
            var element = $('<div class="room"></div>').appendTo(content);
            roomview.render(element,room);
        });
    }
}

/**
 * 手术间视图
 */
var roomview = {
    render: function(container, room) {
        container.empty();
        container.data('data', room);

        var header = $('<div class="room-header"></div>').appendTo(container);
        var content = $('<div class="room-content hisui-tooltip" data-options="position:\'top\'"></div>').appendTo(container);
        var tagContainer = $('<div class="room-tag-container"></div>').appendTo(container);

        $('<span class="room-header-text"></span>').text(room.Description).appendTo(header);
        var processbar = $('<span class="room-processbar"></span>').appendTo(header);

        processbarview.render(processbar,room.OperCount);

        if (room.CurrentOper) {
            var patinfo = patientInfo.render(content,room.CurrentOper);
            if(room.CurrentOper.IsEmerency=='Y'){
                tagContainer.append('<span class="room-tag hisui-tooltip" data-options="position:\'top\'" title="急诊">急</span>');
            }
            if(room.CurrentOper.IsLongDuration=='Y'){
                tagContainer.append('<span class="room-tag hisui-tooltip" data-options="position:\'top\'" title="手术时长超过3小时" style="color:#FEE464;">超时</span>');
            }

            container.find('.hisui-tooltip').tooltip({});
            container.removeClass('room-available');
            container.addClass('room-occupied');
        }
        else {
            content.append('<span>空闲</span>');
            container.removeClass('room-occupied');
            container.addClass('room-available');
        }
    }
};

/**
 * 进度条
 */
var processbarview = {
    render:function(dom,process){
        var barWidth = 50;
        var bar = $('<span class="room-processbar-bar" style="display:inline-block;"></span>').width(barWidth).appendTo(dom);
        var text = $('<span class="room-processbar-text" style="display:inline-block;"></span>')
        .html('<span class="room-processbar-text-finished">'+process.Finished+'</span>/<span class="room-processbar-text-all">'+process.All+'</span>')
        .appendTo(dom);

        if (process.Finished){
            $('<span class="room-processbar-finished" style="display:inline-block;text-align:center;">&nbsp;</span>')
            .width(barWidth * process.Finished / process.All)
            .appendTo(bar);
        }

        if (process.Proceeding){
            $('<span class="room-processbar-proceeding" style="display:inline-block;text-align:center;">&nbsp;</span>')
            .width(barWidth * process.Proceeding / process.All)
            .appendTo(bar);
        }
    }
}

/**
 * 手术信息
 */
var patientInfo = {
    render: function(container,operSchedule) {
        container.empty();

        var info, infoArray = [];
        infoArray.push('<span class="patinfo-patient">' + operSchedule.Patient + '</span>');
        infoArray.push('<span>' + operSchedule.MedcareNo + '</span>');
        infoArray.push('<br/>');
        infoArray.push('<span>' + operSchedule.PatDept + '</span>');
        infoArray.push('<br/>');
        infoArray.push('<span>' + operSchedule.Diagnosis + '</span>');
        infoArray.push('<br/>');
        infoArray.push('<span>' + operSchedule.Operation + '</span>');
        infoArray.push('<br/>');
        infoArray.push('<span>' + operSchedule.AnaMethod + '</span>');
        info = infoArray.join('');

        container.append(info);

        infoArray = [];
        infoArray.push('<span>主刀：' + operSchedule.Surgeon + '</span>');
        infoArray.push('<br/>');
        infoArray.push('<span>麻醉：' + operSchedule.AnaDoctor + '</span>');
        infoArray.push('<br/>');
        infoArray.push('<span>器械：' + operSchedule.ScrubNurse + '</span>');
        infoArray.push('<br/>');
        infoArray.push('<span>巡回：' + operSchedule.CircualNurse + '</span>');
        info = infoArray.join('');
        container.attr('title',info);
    }
}

/**
 * 定时刷新任务
 */
function autoRefresh(){
    setInterval(function() {
        loadOperRoom();
    }, 300000); //每隔5分钟自动刷新界面
}