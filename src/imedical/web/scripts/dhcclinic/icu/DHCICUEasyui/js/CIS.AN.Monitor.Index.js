/**
 * 实时监控主界面
 * @author yongyang 2019-05-08
 */

var monitor = {};

$(document).ready(function() {
    setDate();
    loadOperCount();
    setTabs();
});

/**
 * 设置日期
 */
function setDate() {
    monitor.date = new Date();
    $('#current_date').text(monitor.date.format(constant.dateFormat));
}

/**
 * 加载手术计数
 */
function loadOperCount() {
    dhccl.getDatas(ANCSP.MethodService, {
        ClassName: 'CIS.AN.BL.RealTimeMonitor',
        MethodName: 'GetSummaryInfo',
        Arg1: monitor.date.format(constant.dateFormat),
        ArgCnt: 1
    }, 'text', true, function(data) {
        if (data) {
            var data = $.parseJSON(data);
            var container = $('#types');

            $.each(data.types, function(index, type) {
                var element = $('<span class="summary-type"></span>').appendTo(container);
                element.attr('data-key', type.code);
                element.append(type.text);
                $('<a href="#" class="summary-type-count"></a>').text(type.qty).appendTo(element);
            });
        }
    })
}

/**
 * 设置标签页
 */
function setTabs() {
    monitor.tabs = $('#main_tabs');

    monitor.tabs.tabs('options').onSelect = function(title, index) {
        var tab = monitor.tabs.tabs('getTab', index);
        var tabOpts = tab.panel('options');
        if (tabOpts.content !== tabOpts.page) {
            tabOpts.content = tabOpts.page;
            tab.panel('refresh');
        }
    }

    var href = 'CIS.AN.Monitor.Room.csp',
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    monitor.tabs.tabs('add', {
        selected: true,
        title: '总览',
        closable: false,
        content: '',
        url: href,
        page: content
    });

    var href = 'CIS.AN.Monitor.Process.csp?moduleCode=',
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    monitor.tabs.tabs('add', {
        selected: false,
        title: '手术进度',
        closable: false,
        content: '',
        url: href,
        page: content
    });

    var href = 'CIS.AN.Monitor.Vitalsign.csp?moduleCode=',
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    monitor.tabs.tabs('add', {
        selected: false,
        title: '生命体征',
        closable: false,
        content: '',
        url: href,
        page: content
    });
}


/**
 * 定时刷新任务
 */
function autoRefresh() {
    setInterval(function() {
        loadOperCount();
    }, 300000); //每隔5分钟自动刷新界面
}