var tools = [
    {
        id: 'gear',
        qtip: '还原',
        handler: function(e, target, panel) {
            var pnlEpisodeList = Ext.getCmp("eprEpisodelist");
            if (pnlEpisodeList.getState().collapsed) { return; }
            pnlEpisodeList.setHeight(228);
            pnlEpisodeList.afterExpand();
        }
    },
    {
        id: 'maximize',
        qtip: '最大',
        handler: function(e, target, panel) {
            var pnlEpisodeList = Ext.getCmp("eprEpisodelist");
            if (pnlEpisodeList.getState().collapsed) { return; }
            pnlEpisodeList.setHeight(300);
            pnlEpisodeList.afterExpand();
        }
    }
];
var eprPortal = new Ext.Viewport({
    id: 'eprPortal',
    layout: 'border',
    border: false,
    margins: '0 0 0 0',
    shim: false,
    collapsible: true,
    animCollapse: false,
    constrainHeader: true,
    items: [
        {
            id: 'eprEpisodelist',
            region: 'north',
            layout: 'fit',
            title: ' ',
            border: false,
            margins: '0 0 0 0',
            collapsible: true,
            collapsed: true,
            titleCollapse: true,
            split: true,
            height: 200,
            minSize: 200,
            maxSize: 300,
            tools: tools,
            html:'<iframe id ="episodeListFrame" style="width:100%; height:100%" src=' + episodeListURL + '></iframe>'
        }, {
            id: 'eprMainCenter',
            region: 'center',
            layout: 'fit',
            html: '<iframe id ="mainFrame" style="width:100%; height:100%" src=' + redirectURL + '></iframe>'
        }
    ]
});

//获取头菜单信息
function getMenuForm() {
    var win = top.frames['eprmenu'];
    if (win) {
        var frm = win.document.forms['fEPRMENU'];
        return frm;
    }

    var frm = parent.frames[0].document.forms["fEPRMENU"];
    if (frm) return frm;
    frm = top.document.forms["fEPRMENU"];
    return frm
}

//切换当前患者
function doSwitch(PatientID,EpisodeID,mradm) {
	// 当病历书写或者病历浏览等含有病人就诊信息列表的页面设置为“弹出窗口”模式时，切换病历时，利用菜单获取病人信息失败、报错，故采用直接传参方法获取病人信息
    //var frm = getMenuForm();
    //var frmEpisodeID = frm.EpisodeID;
    //var frmPatientID = frm.PatientID;
    //var frmmradm = frm.mradm;
    //frmPatientID.value = PatientID;
    //frmEpisodeID.value = EpisodeID;
    //frmmradm.value = mradm;

    Ext.Ajax.request({
        url: '../web.eprajax.ajaxGetEPRType.cls',
        params: { EpisodeID: EpisodeID },
        success: function(response, opts) {
            //debugger;
            var src = "";
            var typeID = response.responseText;
            if (typeID == "1") {
                src = "../csp/epr.newfw.main.csp?EpisodeID=" + EpisodeID;
            } else {
                src = "../csp/epr.chartbook.csp?EpisodeID=" + EpisodeID;
            }
            Ext.get("mainFrame").dom.src = src;
        },
        failure: function(response, opts) {
            //debugger;
            alert(response.responseText);
        }
    });
}