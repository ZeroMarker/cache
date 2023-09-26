
var currentpage={};

$(document).ready(function() {
    currentpage.opaId = dhccl.getUrlParam('opaid');
    setTabs();
    setBanner();
    loadArrange();
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

    var href = 'dhcangoldmanassess.csp?act=assess&opaid=' + (currentpage.opaId || ''),
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    currentpage.tabs.tabs('add', {
        selected: true,
        title: 'Goldman心脏高危因素评分',
        closable: false,
        content: '',
        url: href,
        page: content
    });

    var href = 'dhcanchildpughassess.csp?act=assess&opaid=' + (currentpage.opaId || ''),
        content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:99%"></iframe>';

    currentpage.tabs.tabs('add', {
        selected: false,
        title: 'Child-Pugh肝脏疾病患者手术危险性评分',
        closable: false,
        content: '',
        url: href,
        page: content
    });
}


function loadArrange(){
    $.ajax({
        url: 'dhcclinic.jquery.csp',
        async: true,
        data: {
            ClassName: 'web.DHCANOPAssess',
            QueryName: 'FindArrange',
            Arg1: currentpage.opaId || '',
            ArgCnt: 1
        },
        type: 'post',
        dataType: 'json',
        success: function(data) {
            if(data && data.rows && data.rows.length>0){
                currentpage.banner.loadData(data.rows[0]);
            }
        }
    });

}

/**
 * 设置病人信息栏
 */
function setBanner(){
    currentpage.banner = operScheduleBanner.init('#patinfo_banner', {});
}