Ext.QuickTips.init();

function getUxTabPanel() {
    var Uxtabpanel = new Ext.ux.TabPanel({
        id: 'uxTabPanel',
        tabPosition: 'right',    //choose 'left' or 'right' for vertical tabs; 'top' or 'bottom' for horizontal tabs 
        textAlign: 'left',
        renderTo: 'divBrowse',  //id of an existing DOM element 
        width: 600,
        height: 380,
        tabWidth: 95,
        enableTabScroll: true,
        defaults: { autoScroll: true, iconcss: 'nav' },
        items: [{
            id: 'RT0',
            layout: 'fit',
            title: '全部',
            tabTip: '全部',
            //iconCls:'icon-by-category',
            //height: 8,
            closable: false,
            html: '<iframe id="frmBrowserPhoto_RT0" style="width:100%; height:100%" src=""></iframe>'
        }]
    });

    CreateUxTabPanel();

    return Uxtabpanel;
}

function CreateUxTabPanel() {
    var categoryChapterInfo = "";
    var uxtab = Ext.getCmp("uxTabPanel");
    var flag = "";
    //debugger;
    if (Ext.getCmp("uxTabPanel")) {
        Ext.Ajax.request({
            url: '../web.eprajax.CategoryChapterInfo.cls',
            timeout: 5000,
            params: { EpisodeIDList: episodeID, PatientID: patientID, ActionType: "1" },
            success: function(response, opts) {
                categoryChapterInfo = response.responseText;
                //debugger;
                if (categoryChapterInfo == "") {
                    return;
                }
                var categoryChapterList = categoryChapterInfo.split("@");
                for (var i = 0; i < categoryChapterList.length; i++) {
                    var info = categoryChapterList[i].split('*');
                    var titleStr = "";

                    //当病历CategoryChapter名称过长，大于6个字，进行名称处理，显示前6个字+“..”
                    if (info[1].length > 6) {
                        titleStr = info[1].substring(0, 6);
                        titleStr += "..";
                    } else {
                        titleStr = info[1];
                    }

                    if (admitType == 'I') {
                        //就诊类型为住院，默认病历浏览加载除去“全部”后的第一个选项卡
                        if (info[2] == categoryCharpterID) {
                            uxtab.add({
                                'id': categoryChapterList[i],
                                'title': titleStr,
                                tabTip: info[1], //给tab页签新增一个浮动的提示框
                                //iconCls:'icon-by-category',
                                layout: 'fit',
                                closable: false,
                                html: '<iframe id="frmBrowserPhoto_' + categoryChapterList[i] + '" style="width:100%; height:100%" src=""></iframe>'
                            }).show();
                        } else {
                            uxtab.add({
                                'id': categoryChapterList[i],
                                'title': titleStr,
                                tabTip: info[1], //给tab页签新增一个浮动的提示框
                                //iconCls:'icon-by-category',
                                layout: 'fit',
                                closable: false,
                                html: '<iframe id="frmBrowserPhoto_' + categoryChapterList[i] + '" style="width:100%; height:100%" src=""></iframe>'
                            });
                        }
                    } else {
                        //若为急诊或者门诊，则默认加载“全部”选项卡
                        uxtab.add({
                            'id': categoryChapterList[i],
                            'title': titleStr,
                            tabTip: info[1], //add by loo on 2010-8-18 给tab页签新增一个浮动的提示框
                            //iconCls:'icon-by-category',
                            layout: 'fit',
                            closable: false,
                            html: '<iframe id="frmBrowserPhoto_' + categoryChapterList[i] + '" style="width:100%; height:100%" src=""></iframe>'
                        });

                        uxtab.setActiveTab('RT0');
                        var panel = uxtab.getActiveTab();
                        getInfoFromTab(uxtab, panel);
                    }
                }
            },
            failure: function(response, opts) {
                alert(response.responseText);
            }
        });
    }

    //创建完毕，取消蒙版效果
    parent.Ext.getCmp('tabEPRBrowse').getEl().unmask();
}

var UxTabPanel = getUxTabPanel();
var tabPort = new Ext.Viewport({
    layout: 'border',
    items: [{
        region: 'center',
        layout: 'fit',
        items: UxTabPanel
    }]
});

UxTabPanel.on('tabchange', function(tabpanel, panel) {
    getInfoFromTab(tabpanel, panel);
});

function getInfoFromTab(tabpanel, panel) {
    if (panel.id == 'RT0') {
        var count = 0;
        var allImageList = '';
        //循环遍历所有tab页签,取出id，然后拼接出全部的imageList字符串
        tabpanel.items.each(function(item) {
            if (item != panel) {
                var list = item.id.split('*');
                if (allImageList == '') {
                    allImageList = list[3];
                } else {
                    allImageList = allImageList + '@' + list[3];
                }
            }
        });

        imageList = allImageList;
        var str = 'PatientID=' + patientID + '&EpisodeID=' + episodeID + '&ImageList=' + escape(imageList);
        Ext.getDom('frmBrowserPhoto_RT0').src = 'dhc.epr.ref.browseeprimage.csp?' + str;
    } else {
        var list = panel.id.split('*');
        var parentId = list[0];
        var categoryChapterId = list[2];
        imageList = list[3];
        Ext.getDom('frmBrowserPhoto_' + panel.id).src = 'dhc.epr.ref.browseeprimage.csp?PatientID=' + patientID + '&EpisodeID=' + episodeID + '&ImageList=' + escape(imageList);
    }
}