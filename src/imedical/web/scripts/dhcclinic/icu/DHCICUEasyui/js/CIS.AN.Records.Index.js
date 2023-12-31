/**
 * HIS查看手术麻醉病历
 * @author yongyang 2019-08-08
 */

var currentpage = {};

$(document).ready(function() {
    if (existOperSchedule == "N") return;
    setBanner();
    setTabs();
    loadOperSchedules();
});

/**
 * 加载手术
 */
function loadOperSchedules() {
    currentpage.operlist = $('#oper_list');
    currentpage.operlist.delegate('.oper-i', 'click', function() {
        if (!$(this).hasClass('oper-i-selected')) {
            currentpage.operlist.find('.oper-i-selected').removeClass('oper-i-selected');
            $(this).addClass('oper-i-selected');
            var operSchedule = $(this).data('data');
            refreshContent(operSchedule);
        }
    });

    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperScheduleList,
        QueryName: 'GetHISOperSchedules',
        Arg1: mappedAdmId,
        Arg2: medcareNo,
        Arg3: regNo,
        ArgCnt: 3
    }, 'json', true, function(data) {
        var length = data.length;
        currentpage.operlist.empty();
        var element;
        for (var i = 0; i < length; i++) {
            element = $('<span class="oper-i"></span>').appendTo(currentpage.operlist);
            operview.render(element, data[i]);
            if (i == 0) {
                element.addClass('oper-i-selected');
                refreshContent(data[i]);
            }
        }
    })
}

/**
 * 渲染手术
 */
var operview = {
    render: function(container, operSchedule) {
        container.empty();
        container.data('data', operSchedule);
        container.addClass('hisui-tooltip');

        $('<span class="oper-i-date"></span>').text(operSchedule.OperDate).appendTo(container);
        $('<span class="oper-i-name"></span>').text(operSchedule.OperInfo).appendTo(container);

        var infoArr = [];
        infoArr.push('<b>' + operSchedule.Patient + '</b>');
        infoArr.push(operSchedule.PatDeptDesc + ' ' + operSchedule.PatBedCode);
        infoArr.push(operSchedule.PrevDiagnosisDesc);
        infoArr.push(operSchedule.OperInfo);
        infoArr.push(operSchedule.AnaestMethod || operSchedule.PrevAnaMethodDesc);
        infoArr.push('主刀：' + operSchedule.SurgeonDesc);
        infoArr.push('助手：' + operSchedule.AssistantDesc);
        infoArr.push('麻醉：' + operSchedule.AnaCareProv);
        infoArr.push('手术护士：' + operSchedule.ScrubNurseDesc + "," + operSchedule.CircualNurseDesc);

        container.attr('title', infoArr.join('<br>'));

        container.tooltip({
            position: 'bottom'
        })
    }
}

/**
 * 设置病人信息栏
 */
function setBanner() {
    currentpage.banner = operScheduleBanner.init('#patinfo_banner', {
        retrieveLabResultHandler: retrieveLabResult
    });
}

/**
 * 设置标签页
 */
function setTabs() {
    currentpage.tabs = $('#main_tabs');

    currentpage.tabs.tabs('options').onSelect = function(title, index) {
        var tab = currentpage.tabs.tabs('getTab', index);
        var tabOpts = tab.panel('options');
        if (tabOpts.content !== tabOpts.page) {
            tabOpts.content = tabOpts.page;
            tab.panel('refresh');
        }
    }

    var href = 'CIS.AN.OperRiskAssessment.csp?moduleCode=OperRiskAssessment',
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    currentpage.tabs.tabs('add', {
        selected: true,
        title: '手术风险评估',
        closable: false,
        content: '',
        url: href,
        page: content
    });

    var href = 'CIS.AN.OperSafetyCheck.csp?moduleCode=OperSafetyCheck',
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    currentpage.tabs.tabs('add', {
        selected: false,
        title: '手术安全核查',
        closable: false,
        content: '',
        url: href,
        page: content
    });

    var href = 'CIS.AN.OperCount.csp?moduleCode=OperCount',
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    currentpage.tabs.tabs('add', {
        selected: false,
        title: '手术护理记录',
        closable: false,
        content: '',
        url: href,
        page: content
    });

    var href = 'CIS.AN.PreANVisit.csp?moduleCode=PreAnaVisit',
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    currentpage.tabs.tabs('add', {
        selected: false,
        title: '麻醉术前访视',
        closable: false,
        content: '',
        url: href,
        page: content
    });

    var href = 'CIS.AN.AnaestRecord.csp?moduleCode=AnaestRecord&readonly=1',
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    currentpage.tabs.tabs('add', {
        selected: false,
        title: '麻醉监护',
        closable: false,
        content: '',
        url: href,
        page: content
    });

    var href = 'CIS.AN.PostANVisit.csp?moduleCode=PostAnaVisit',
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    currentpage.tabs.tabs('add', {
        selected: false,
        title: '麻醉术后访视',
        closable: false,
        content: '',
        url: href,
        page: content
    });
}

function refreshContent(operSchedule) {
    currentpage.banner.loadData(operSchedule);
    var tabs = currentpage.tabs.tabs("tabs");
    var selectedTab = currentpage.tabs.tabs("getSelected");
    var opsId = operSchedule.RowId;
    for (var i = 0; i < tabs.length; i++) {
        var tab = tabs[i];
        var tabOpts = tab.panel("options");
        var href = tabOpts.url + "&opsId=" + opsId;
        var content = "<iframe scrolling='yes' frameborder='0' src='" + href + "' style='width:100%;height:99%;'></iframe>";
        if (tab === selectedTab) {
            currentpage.tabs.tabs("update", {
                tab: tab,
                options: {
                    page: content,
                    content: content
                }
            });
        } else {
            currentpage.tabs.tabs("update", {
                tab: tab,
                options: {
                    page: content
                }
            });
        }
    }
}

function retrieveLabResult(medcareNo, callback) {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: 'FindLabDataByMedcareNo',
        Arg1: medcareNo,
        ArgCnt: 1
    }, 'json', true, function(data) {
        if (callback) callback(data);
    })
}