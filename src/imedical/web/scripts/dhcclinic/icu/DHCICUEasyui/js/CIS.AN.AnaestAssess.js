var currentpage = {};

$(document).ready(function() {
    setTabs();
});

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

    var opsId = session.OPSID;
    var href = 'CIS.AN.GoldmanAssess.csp?act=assess&opsId=' + opsId,
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    currentpage.tabs.tabs('add', {
        selected: true,
        title: 'Goldman心脏高危因素评分',
        closable: false,
        content: content,
        url: href,
        page: content
    });

    var href = 'CIS.AN.ChildPughAssess.csp?act=assess&opsId=' + opsId,
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    currentpage.tabs.tabs('add', {
        selected: false,
        title: 'Child-Pugh肝脏疾病患者手术危险性评分',
        closable: false,
        content: content,
        url: href,
        page: content
    });
}