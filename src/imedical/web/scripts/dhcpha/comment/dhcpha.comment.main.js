///处方点评主界面JS
///Creator:LiangQiang
///CreatDate:2012-05-20
document.write("<object id='CaesarComponent' classid='clsid:8C028072-4FD2-46AE-B6D2-63E9F9B4155F' codebase = '../addins/client/dtywzxUIForMS.cab#version1.0.0.1'>");
document.write("</object>");
var unitsUrl = 'dhcpha.comment.main.save.csp';

var logonuser = session['LOGON.USERID'];
var logongroup = session['LOGON.GROUPID'];
var logonloc = session['LOGON.CTLOCID']

Ext.onReady(function() {
    Ext.QuickTips.init(); // 浮动信息提示
    Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    // StartDaTongDll();
    PatInfo = {
        adm: 0,
        patientID: 0,
        episodeID: 0,
        admType: "I",
        prescno: 0,
        orditem: 0,
        zcyflag: 0
            // datongflag:100  
    };

//重新load Tab,并加载数据
var HrefRefresh = function() {
    var adm = PatInfo.adm;
    var patientID = PatInfo.patientID;
    var episodeID = PatInfo.episodeID;
    var admType = PatInfo.admType;
    var prescno = PatInfo.prescno;
    var orditem = PatInfo.orditem;
    var zcyflag = PatInfo.zcyflag;
    // var datongflag= PatInfo.datongflag;
    var p = Ext.getCmp("ToolsTabPanel").getActiveTab();
    var iframe = p.el.dom.getElementsByTagName("iframe")[0];

    if (p.id == "framepaallergy") {
        iframe.src = 'dhcdoc.allergyenter.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm;
    }

    if (p.id == "framerisquery") {
        iframe.src = ' dhcapp.inspectrs.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm;
    }

    if (p.id == "framelabquery") {
        iframe.src = 'dhcapp.seepatlis.csp' + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&NoReaded=' + '1';
    }

    if (p.id == "frameprbrowser") {
        //iframe.src='dhc.epr.public.episodebrowser.csp?EpisodeID='+ adm;
        var LocID = session['LOGON.CTLOCID'];
        //iframe.src = p.src + '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + LocID;
        iframe.src = 'emr.browse.csp'+ '?PatientID=' + patientID + '&EpisodeID=' + adm + '&EpisodeLocID=' + LocID;
    }


    //明细
    if (p.id == "frameordquery") {
        if (adm == 0) return;
        FindDiagData(adm);
        FindOrdDetailData(prescno);
        FindLogData(orditem);
        CheckArcExist(prescno);
    }

    //处方预览
    if (p.id == "prescriptioninfo") {
        if (zcyflag == 0) {
            iframe.src = 'dhcpha.comment.prescriptioninfo.csp' + '?PrescNo=' + prescno + '&EpisodeID=' + adm;
        } else {
            iframe.src = 'dhcpha.comment.cyprescriptioninfo.csp' + '?PrescNo=' + prescno + '&EpisodeID=' + adm;
        }
    }

    //本次医嘱
    if (p.id == "frameadmordquery") {
        //iframe.src = p.src + '?EpisodeID=' + adm;
        iframe.src = 'oeorder.opbillinfo.csp' + '?EpisodeID=' + adm;
    }
};

//大通处方分析
var DaTongAnalyseButton = new Ext.Button({
    width: 65,
    id: "DaTongAnalyseBtn",
    text: '处方分析',
    iconCls: "page_analysis",
    listeners: {
        "click": function() {

            PrescAnalyse();
        }
    }
});

var ClearButton = new Ext.Button({
    width: 65,
    id: "ClearButton",
    text: '清屏',
    listeners: {
        "click": function() {
            ClearWindow();
        }
    }
});

var OkButton = new Ext.Button({
    width: 55,
    id: "OkButton",
    text: '合理',
    iconCls: "page_ok",
    listeners: {
        "click": function() {
            CommontOk();
        }
    }
});

var BadButton = new Ext.Button({
    width: 60,
    id: "BadButton",
    text: '不合理',
    iconCls: "page_bad",
    listeners: {
        "click": function() {
            CommontBad();
        }
    }
});

var FindNoButton = new Ext.Button({
    width: 55,
    id: "FindNoButton",
    iconCls: "page_find",
    text: '查单',
    listeners: {
        "click": function() {
            FindCommentFun(1);
        }
    }
});

/// 医嘱数据table 
var sm = new Ext.grid.CheckboxSelectionModel(); // add checkbox
var nm = new Ext.grid.RowNumberer();
var ordgridcm = new Ext.grid.ColumnModel([
    nm,
    { header: '合理用药', dataIndex: 'DrugUseImg', width: 75 },
    { header: '预审', dataIndex: 'passtext', width: 75 },
    { header: '登记号', dataIndex: 'patno', width: 75, hidden: true },
    { header: '姓名', dataIndex: 'patname', width: 60, hidden: true },
    { header: '性别', dataIndex: 'patsex', width: 40, hidden: true },
    { header: '年龄', dataIndex: 'patage', width: 40, hidden: true },
    { header: '费别', dataIndex: 'type', width: 60, hidden: true },
    { header: '诊断', dataIndex: 'diag', width: 500, hidden: true },
    { header: '处方号', dataIndex: 'prescno', width: 125 },
    { header: '结果', dataIndex: 'curret', width: 125 },
    { header: '科室', dataIndex: 'dept', width: 80, hidden: true },
    { header: 'adm', dataIndex: 'adm', hidden: true },
    { header: 'orditem', dataIndex: 'orditem', hidden: true },
    { header: 'porcess', dataIndex: 'porcess', hidden: true },
    { header: 'waycode', dataIndex: 'waycode', hidden: true },
    { header: '点评明细id', dataIndex: 'pcntsi', hidden: true },
    { header: 'zcyflag', dataIndex: 'zcyflag', width: 90, hidden: 'true' },
    { header: 'datongflag', dataIndex: 'datongflag', hidden: true },
    { header: 'papmi', dataIndex: 'papmi', hidden: true }
]);

var ordgridds = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
        'DrugUseImg',
        'prescno',
        'patno',
        'patname',
        'patsex',
        'patage',
        'type',
        'dept',
        'diag',
        'adm',
        'orditem',
        'porcess',
        'curret',
        'waycode',
        'pcntsi',
        'zcyflag',
        'datongflag',
        'papmi'
    ]),
    remoteSort: true
});

var ordgridcmPagingToolbar = new Ext.PagingToolbar({ //分页工具
    store: ordgridds,
    pageSize: 200
        //显示右下角信息
        //displayInfo:true,
        //displayMsg:'当前记录 {0} -- {1} 条 共 {2} 条记录',
        //prevText:"上一页",
        //nextText:"下一页",
        //refreshText:"刷新",
        //lastText:"最后页",
        //firstText:"第一页",
        //beforePageText:"当前页",
        //afterPageText:"共{0}页",
        //emptyMsg: "没有数据"
});

var ordgrid = new Ext.grid.EditorGridPanel({
    stripeRows: true,
    id: 'ordgridtbl',
    frame: false,
    enableHdMenu: false,
    ds: ordgridds,
    cm: ordgridcm,
    enableColumnMove: false,
    sm: sm,
    bbar: ordgridcmPagingToolbar,
    trackMouseOver: 'true'
});

///诊断table 
var diaggridcm = new Ext.grid.ColumnModel({
    columns: [
        { header: '诊断', dataIndex: 'diag', width: 800 }
    ]
});


var diaggridds = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
        'diag'
    ]),
    remoteSort: true
});

var diaggrid = new Ext.grid.EditorGridPanel({
    height: 100,
    //width:700,
    frame: false,
    stripeRows: true,
    id: 'diaggridtbl',
    enableHdMenu: false,
    ds: diaggridds,
    cm: diaggridcm,
    enableColumnMove: false,
    trackMouseOver: 'true'
});

var PreAmtField = new Ext.form.TextField({
    width: 120,
    id: "PreAmtText",
    fieldLabel: "处方金额"
});

var PreAntAmtField = new Ext.form.TextField({
    width: 120,
    id: "PreAntAmtText",
    fieldLabel: "处方抗菌药金额"
});

///医嘱明细数据table
var orddetailgridcm = new Ext.grid.ColumnModel({
    columns: [
        { header: '医嘱名称', dataIndex: 'incidesc', width: 280 },
        { header: '数量', dataIndex: 'qty', width: 40 },
        { header: '单位', dataIndex: 'uomdesc', width: 70 },
        { header: '剂量', dataIndex: 'dosage', width: 60 },
        { header: '频次', dataIndex: 'freq', width: 100 },
        { header: '规格', dataIndex: 'spec', width: 120, hidden: true },
        { header: '用法', dataIndex: 'instruc', width: 80 },
        { header: '用药疗程', dataIndex: 'dura', width: 80 },
        { header: '实用疗程', dataIndex: 'realdura', width: 60, hidden: true },
        { header: '剂型', dataIndex: 'form', width: 120 },
        { header: '基本药物', dataIndex: 'basflag', width: 70 },
        { header: '医生', dataIndex: 'doctor', width: 100 },
        { header: '医嘱开单日期', dataIndex: 'orddate', width: 150 },
        { header: '医嘱备注', dataIndex: 'remark', width: 70 },
        { header: '厂家', dataIndex: 'manf', width: 250 , hidden: true},
        { header: 'oeorditm', dataIndex: 'oeorditm', width: 80, hidden: true }
    ]
});

var orddetailgridds = new Ext.data.Store({
    proxy: "",
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
        'incidesc',
        'qty',
        'uomdesc',
        'dosage',
        'freq',
        'spec',
        'instruc',
        'dura',
        'realdura',
        'form',
        'basflag',
        'doctor',
        'orddate',
        'remark',
        'manf',
        'oeorditm'
    ]),
    remoteSort: true
});

var orddetailgridcmPagingToolbar = new Ext.PagingToolbar({
    store: orddetailgridds,
    pageSize: 200,
    //显示右下角信息
    displayInfo: true,
    displayMsg: '当前记录 {0} -- {1} 条 共 {2} 条记录',
    prevText: "上一页",
    nextText: "下一页",
    refreshText: "刷新",
    lastText: "最后页",
    firstText: "第一页",
    beforePageText: "当前页",
    afterPageText: "共{0}页",
    emptyMsg: "没有数据"
});

var orddetailgrid = new Ext.grid.GridPanel({
    region: 'west',
    id: 'orddetailgridtbl', // add by myq 20150518
    stripeRows: true,
    height: 280,
    autoScroll: true,
    title: "药品列表",
    enableHdMenu: false,
    ds: orddetailgridds,
    cm: orddetailgridcm,
    enableColumnMove: false,
    tbar: ['处方金额:', PreAmtField, '-', '处方抗菌药金额:', PreAntAmtField],
    bbar: orddetailgridcmPagingToolbar,
    trackMouseOver: 'true'
});

var commentloggridcm = new Ext.grid.ColumnModel({
    columns: [
        { header: '组号', dataIndex: 'comgrpno', width: 50 },
        { header: '点评原因', dataIndex: 'comreason', width: 300 },
        { header: '姓名', dataIndex: 'patname', hidden: true },
        { header: '处方号', dataIndex: 'prescno', hidden: true },
        { header: '点评日期', dataIndex: 'comdate', width: 100 },
        { header: '点评时间', dataIndex: 'comtime', width: 100 },
        { header: '点评人', dataIndex: 'comuser', width: 120 },
        { header: '点评结果', dataIndex: 'comresult', width: 100 },
        { header: '不合格警示值', dataIndex: 'comfactor', width: 100 },
        { header: '药师建议', dataIndex: 'comadvice', width: 150 },
        { header: '药师备注', dataIndex: 'comphnote', width: 80 },
        { header: '医生反馈', dataIndex: 'comdocadvice', width: 60, hidden: true },
        { header: '医生备注', dataIndex: 'comdocnote', width: 80 },
        { header: '有效', dataIndex: 'comactive', width: 40 }
    ]
});

var orditem = "";
var commentloggridds = new Ext.data.Store({
    //proxy: "",	
    autoLoad: true,
    proxy: new Ext.data.HttpProxy({
        url: unitsUrl +
            '?action=QueryCommontLog&OrdItem=' + orditem,
        method: 'POST'
    }),

    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
    }, [
        'comgrpno',
        'patname',
        'prescno',
        'comdate',
        'comtime',
        'comuser',
        'comresult',
        'comreason',
        'comfactor',
        'comadvice',
        'comdocadvice',
        'comactive',
        'comphnote',
        'comdocnote',
        'comactive'
    ]),
    remoteSort: true
});



var commentloggrid = new Ext.grid.GridPanel({
    title: '点评日志',
    frame: false,
    region: 'center',
    stripeRows: true,
    autoScroll: true,
    enableHdMenu: false,
    ds: commentloggridds,
    cm: commentloggridcm,
    enableColumnMove: false,
    trackMouseOver: 'true'
});

commentloggrid.on('afterlayout', function(view, layout) {
    commentloggrid.setHeight(document.body.clientHeight - diaggrid.getSize().height - orddetailgrid.getSize().height - 55)
}, this);

///右边的Form
var toolform = new Ext.TabPanel({
    id: 'ToolsTabPanel',
    region: 'center',
    margins: '3 3 3 3',
    frame: false,
    activeTab: 0,
    items: [{
        title: '医嘱明细',
        id: 'frameordquery',
        layout: 'form',
        items: [diaggrid, orddetailgrid, commentloggrid]
    }, {
        title: '处方预览',
        frameName: 'prescriptioninfo',
        html: '<iframe id="prescription" width=100% height=100% src= ></iframe>',
        id: 'prescriptioninfo'
    }, {
        title: '过敏记录',
        frameName: 'framepaallergy',
        html: '<iframe id="paallergyFrame" width=100% height=100% src=dhcpha.comment.paallergy.csp></iframe>',
        src: 'dhcpha.comment.paallergy.csp',
        id: 'framepaallergy'
    }, {
        title: '检查记录',
        frameName: 'framerisquery',
        html: '<iframe id="framerisquery" width=100% height=100% src=dhcpha.comment.risquery.csp></iframe>',
        src: 'dhcpha.comment.risquery.csp',
        id: 'framerisquery'
    }, {
        title: '检验记录',
        frameName: 'framelabquery',
        //html: '<iframe id="framelabquery" width=100% height=100% src=dhcpha.comment.labquery.csp></iframe>',		
        //src: 'dhcpha.comment.labquery.csp',
        html: '<iframe id="framelabquery" width=100% height=100% src=jquery.easyui.dhclaborder.csp></iframe>',
        src: 'jquery.easyui.dhclaborder.csp',
        id: 'framelabquery'
    }, {
        title: '病历浏览',
        frameName: 'frameprbrowser',
        //html: '<iframe id="frmeprbrowser" width=100% height=100% src=emr.interface.browse.category.csp></iframe>',		
        //src: 'emr.interface.browse.category.csp',
        html: '<iframe id="frmeprbrowser" width=100% height=100% src=emr.interface.browse.episode.csp></iframe>',
        src: 'emr.interface.browse.episode.csp', //可用	
        id: 'frameprbrowser'
    }, {
        title: '本次医嘱',
        frameName: 'frameadmordquery',
        html: '<iframe id="frameadmordquery" width=100% height=100% src=dhcpha.comment.admordquery.csp></iframe>',
        src: 'dhcpha.comment.queryorditemds.csp',
        id: 'frameadmordquery'
    }],
    tbar: [
        '处方号:', { xtype: 'tbtext', id: 'baseInfoPrescNo', height: '20', width: '110', text: '', cls: 'x-panel-header' }, '-',
        '登记号:', { xtype: 'tbtext', id: 'baseInfoIPNo', height: '20', width: '80', text: '', cls: 'x-panel-header' }, '-',
        '姓名:', { xtype: 'tbtext', id: 'baseInfoName', height: '20', width: '70', text: '', cls: 'x-panel-header' }, "-",
        '性别:', { xtype: 'tbtext', id: 'baseInfoSex', height: '20', width: '50', text: '', cls: 'x-panel-header' }, "-",
        '年龄:', { xtype: 'tbtext', id: 'baseInfoAge', height: '20', width: '40', text: '', cls: 'x-panel-header' }, "-",
        '费别:', { xtype: 'tbtext', id: 'baseInfoType', height: '20', width: '50', text: '', cls: 'x-panel-header' }, "-",
        '科室:', { xtype: 'tbtext', id: 'baseInfoLoc', height: '20', width: '125', text: '', cls: 'x-panel-header' }
    ],
    listeners: {
        tabchange: function(tp, p) {
            HrefRefresh();
        }
    }
});

toolform.on('afterlayout', function(view, layout) {
    toolform.setHeight(document.body.clientHeight)
}, this);

var westPanel = new Ext.Panel({
    region: 'west',
    title: '点评处方',
    collapsible: true,
    frame: false,
    width: 400,
    layout: 'border',
    defaults: {
        split: false //是否有分割线  
            //collapsible: true,           //是否可以折叠 
            //bodyStyle: 'padding:1px' 
    },
    tbar: [
        FindNoButton, "-", OkButton, "-", BadButton, "-", DaTongAnalyseButton
    ],
    items: [{
        region: 'center',
        layout: 'fit',
        items: [ordgrid]
    }]
});
var port = new Ext.Viewport({
    layout: 'border',
    items: [westPanel, toolform]

});

////-----------------Events-----------------///
///处方列表grid 单击行事件
ordgrid.on('rowclick', function(grid, rowIndex, e) {
    var selectedRow = ordgridds.data.items[rowIndex];
    var prescno = selectedRow.data["prescno"];
    var patno = selectedRow.data["patno"];
    var patname = selectedRow.data["patname"];
    var patsex = selectedRow.data["patsex"];
    var patage = selectedRow.data["patage"];
    var pattype = selectedRow.data["type"];
    var dept = selectedRow.data["dept"];
    var orditem = selectedRow.data["orditem"];
    var adm = selectedRow.data["adm"];
    var zcyflag = selectedRow.data["zcyflag"];
    var datongflag = selectedRow.data["datongflag"];
    var papmi = selectedRow.data["papmi"];

    Ext.getCmp("baseInfoPrescNo").setText(prescno); //
    Ext.getCmp("baseInfoIPNo").setText(patno);
    Ext.getCmp("baseInfoName").setText(patname);
    Ext.getCmp("baseInfoSex").setText(patsex);
    Ext.getCmp("baseInfoAge").setText(patage);
    Ext.getCmp("baseInfoType").setText(pattype);
    Ext.getCmp("baseInfoLoc").setText(dept);

    PatInfo.adm = adm;
    PatInfo.patientID = papmi;
    PatInfo.episodeID = adm;
    PatInfo.prescno = prescno;
    PatInfo.orditem = orditem;
    PatInfo.zcyflag = zcyflag;
    PatInfo.datongflag = datongflag;

    //FindDiagData(adm);	
    //FindOrdDetailData(prescno);
    //FindLogData(orditem);
    HrefRefresh();
});

///打开新窗体(更多查询条件)
function OpenMoreFindWindow() {
    MoreFindFun();
}

///查单界面,选取点评单,调出点评单内容
QueryCommontItm = function(PCNTSRowid, MainTitle, RetFlag, Phama) {
    ClearWindow();
    waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "系统正在处理数据，请稍候..." });
    waitMask.show();
    ordgridds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=QueryCommontItm&PCNTSRowid=' + PCNTSRowid + '&RetFlag=' + RetFlag + '&Phama=' + Phama });
    ordgridds.load({
        params: { start: 0, limit: ordgridcmPagingToolbar.pageSize },
        callback: function(r, options, success) {
            waitMask.hide();
            if (success == false) {
                Ext.Msg.show({ title: '注意', msg: '查询失败 !', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
            } else {
                //westPanel.setTitle(MainTitle);
            }
        }
    });
}

/// 根据处方号查看医嘱明细
function FindOrdDetailData(prescno) {
    //alert("prescno:"+prescno)
    orddetailgridds.removeAll();
    orddetailgridds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=FindOrdDetailData&PrescNo=' + prescno });
    orddetailgridds.load({
        params: { start: 0, limit: orddetailgridcmPagingToolbar.pageSize },
        callback: function(r, options, success) {
            if (success == false) {
                Ext.Msg.show({ title: '注意', msg: '查询失败 !', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
            } else {
                var ret = tkMakeServerCall("web.DHCSTCNTSCOMMON", "GetPreAmtData", prescno);
                var tmparr = ret.split("^");
                var amt = tmparr[0];
                var antamt = tmparr[1];
                Ext.getCmp("PreAntAmtText").setValue(antamt);
                Ext.getCmp("PreAmtText").setValue(amt);
            }
        }
    });
}

//查询日志
function FindLogData(orditem) {
    var currow = ordgrid.getSelectionModel().getSelected();
    var pcntsi = currow.data.pcntsi; // MYQ 20160805 点评子表id
    commentloggridds.removeAll();
    commentloggridds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=QueryCommontLog&OrdItem=' + orditem + '&Pcntsi=' + pcntsi });
    commentloggridds.load({
        callback: function(r, options, success) {
            if (success == false) {
                Ext.Msg.show({
                    title: '注意',
                    msg: '查询失败 !',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.INFO
                });
            }
        }
    });
}

//查询诊断
function FindDiagData(adm) {
    diaggridds.removeAll();
    diaggridds.proxy = new Ext.data.HttpProxy({
        url: unitsUrl + '?action=GetMRDiagnosDesc&adm=' + adm
    });
    diaggridds.load({
        callback: function(r, options, success) {
            if (success == false) {
                Ext.Msg.show({
                    title: '注意',
                    msg: '查询失败 !',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.INFO
                });
            }
        }
    });
}

/// 清PatInfo
function ClearPatInfo() {
    PatInfo.adm = 0;
    PatInfo.patientID = 0;
    PatInfo.episodeID = 0;
    PatInfo.admType = "";

    Ext.getCmp("baseInfoPrescNo").setText('');
    Ext.getCmp("baseInfoIPNo").setText('');
    Ext.getCmp("baseInfoName").setText('');
    Ext.getCmp("baseInfoSex").setText('');
    Ext.getCmp("baseInfoAge").setText('');
    Ext.getCmp("baseInfoType").setText('');
    Ext.getCmp("baseInfoLoc").setText('');

}

///清Grid  1 全清  2清右边grid
function ClearGrid(flag) {
    Ext.getCmp("PreAntAmtText").setValue('');
    Ext.getCmp("PreAmtText").setValue('');
    if (flag == 1) {
        ordgridds.removeAll();
    }
    diaggridds.removeAll();
    //orddetailgridds.removeAll();
    //orddetailgridds.setBaseParam('PrescNo','')
    orddetailgridds.load({ params: { start: 0, limit: 0 } })
    orddetailgrid.getStore().removeAll()
    commentloggridds.removeAll();
    ClearPatInfo();
    HrefRefresh();
}

///清屏
function ClearWindow() {
    Ext.getCmp("PreAntAmtText").setValue('');
    Ext.getCmp("PreAmtText").setValue('');
    diaggridds.removeAll();
    ordgridds.removeAll();
    orddetailgridds.removeAll();
    commentloggridds.removeAll();
    ClearPatInfo();
    HrefRefresh();
}


///合格
function CommontOk() {
    var row = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections();
    if (!(row)) {
        Ext.Msg.getDialog().setWidth(500);
        Ext.MessageBox.alert("提示", "未选中记录!");
        return;
    }
    if (row == 0) {
        Ext.Msg.getDialog().setWidth(500);
        Ext.MessageBox.alert("提示", "未选中记录!");
        return;
    }
    var orditm = row[0].data.orditem;
    var pcntsi = row[0].data.pcntsi;
    var pcntsflag = tkMakeServerCall("web.DHCSTCNTSMAIN", "GetPCNTSComFlag", pcntsi, session['LOGON.GROUPID'])
    if (pcntsflag == -11) {
        msgtxt = "该处方已点评,您所登录的安全组没有修改的权限!"
        Ext.Msg.show({
            title: '提示',
            msg: msgtxt,
            buttons: Ext.Msg.OK,
            icon: Ext.MessageBox.INFO
        });
        return;
    } else if (pcntsflag == -10) {
        msgtxt = "未获取到点评子表或者登录安全组!"
        Ext.Msg.show({
            title: '提示',
            msg: msgtxt,
            buttons: Ext.Msg.OK,
            icon: Ext.MessageBox.INFO
        });
        return;
    }
    var ret = "Y";
    var reasondr = "";
    var advicetxt = "";
    var factxt = "";
    var phnote = "";
    var GrpID = session['LOGON.GROUPID'];
    var input = advicetxt + "^" + factxt + "^" + phnote + "^" + GrpID;
    var selectedRow = ordgrid.getSelectionModel().getSelected();
    SaveCommontResult(selectedRow, ret, orditm, reasondr, input)
}


//所有符合要求的都点合格
function AllCommontOk() {
    Ext.Msg.show({
        title: '注意',
        msg: '需要和第三方合理用药软件接口,暂未开放 !',
        buttons: Ext.Msg.OK,
        icon: Ext.MessageBox.INFO
    });
    return;

    var totalnum = ordgrid.getStore().getCount();
    if (totalnum == 0) {
        return;
    }

    for (var i = 0; i < totalnum; i++) {
        var record = ordgrid.getStore().getAt(i);
        var datongflag = record.data.datongflag;
        if (datongflag = 0) {
            var orditm = record.data.orditem;
            var ret = "Y";
            var reasondr = "";
            var advicetxt = "";
            var factxt = "";
            var phnote = "";
            var GrpID = session['LOGON.GROUPID'];
            var input = advicetxt + "^" + factxt + "^" + phnote + "^" + GrpID;
            var selectedRow = ordgrid.getSelectionModel().getSelected();
            SaveCommontResult(selectedRow, ret, orditm, reasondr, input);
        }
    }
    ordgridds.reload();
}


///不合格
function CommontBad() {
    var row = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections();
    if (!(row)) {
        Ext.Msg.getDialog().setWidth(500);
        Ext.MessageBox.alert("提示", "未选中记录!");
        return;
    }
    if (row == 0) {
        Ext.Msg.getDialog().setWidth(500);
        Ext.MessageBox.alert("提示", "未选中记录!");
        return;
    }
    var orditm = row[0].data.orditem;
    var waycode = row[0].data.waycode;
    var pcntsi = row[0].data.pcntsi;
    var pcntsflag = tkMakeServerCall("web.DHCSTCNTSMAIN", "GetPCNTSComFlag", pcntsi, session['LOGON.GROUPID'])
    if (pcntsflag == -11) {
        msgtxt = "该处方已点评,您所登录的安全组没有修改的权限!"
        Ext.Msg.show({ title: '提示', msg: msgtxt, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
        return;
    } else if (pcntsflag == -10) {
        msgtxt = "未获取到点评子表或者登录安全组!"
        Ext.Msg.show({ title: '提示', msg: msgtxt, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
        return;
    }
    var retstr = showModalDialog('dhcpha.comment.selectreason.csp?orditm=' + orditm + '&waycode=' + waycode, '', 'dialogHeight:600px;dialogWidth:1000px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
    if (!(retstr)) {
        return;
    }
    if (retstr == "") {
        return;
    }
    retarr = retstr.split("@");
    var ret = "N";
    var reasondr = retarr[0];
    var advicetxt = retarr[2];
    var factxt = retarr[1];
    var phnote = retarr[3];
    var selectedRow = ordgrid.getSelectionModel().getSelected();
    var GrpID = session['LOGON.GROUPID'];
    var input = advicetxt + "^" + factxt + "^" + phnote + "^" + GrpID;
    SaveCommontResult(selectedRow, ret, orditm, reasondr, input)
}


///保存点评结果
function SaveCommontResult(currow, ret, orditm, reasondr, input) {
    var User = session['LOGON.USERID'];
    var currow = ordgrid.getSelectionModel().getSelected();
    var pcntsi = currow.data.pcntsi; // MYQ 20160805 点评子表id
    var otherstr = pcntsi
    Ext.Ajax.request({
        url: unitsUrl + '?action=SaveItmResult&User=' + User + '&CommontResult=' + ret + '&OrdItm=' + orditm + '&ReasonDr=' + reasondr + '&Input=' + encodeURI(input) + '&Otherstr=' + otherstr,
        waitMsg: '处理中...',
        failure: function(result, request) {
            Ext.Msg.show({
                title: '错误',
                msg: '请检查网络连接!',
                buttons: Ext.Msg.OK,
                icon: Ext.MessageBox.ERROR
            });
        },
        success: function(result, request) {
            var jsonData = Ext.util.JSON.decode(result.responseText);
            if (jsonData.retvalue == 0) {
                ClearGrid(2);
                ordgridds.reload();
                if (top && top.HideExecMsgWin) {
                    top.HideExecMsgWin();
                }
            } else {
                msgtxt = jsonData.retinfo;
                if (jsonData.retvalue == "-33") {
                    msgtxt = "已点评,您没有修改的权限!"
                } else if (jsonData.retvalue == "-3") {
                    msgtxt = "保存点评孙表或者药品禁忌表失败,可能是由于备注信息过长导致,请再次核实!"
                }
                else if (jsonData.retvalue="-44"){
				  	msgtxt="该明细已分配点评药师,您没有点评此明细的权限!"
				  }
                Ext.Msg.show({ title: '提示', msg: msgtxt, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
            }
        },
        scope: this
    });
}

/// 右键菜单    
ordgrid.addListener('rowcontextmenu', rightClickFn);
var rightClick = new Ext.menu.Menu({
    id: 'rightClickCont',
    items: [{
        id: 'ExportXls',
        handler: AllCommontOk,
        text: '一键点评'
    }]
})

orddetailgrid.addListener('rowcontextmenu', rightClickFn1);
var rightClick1 = new Ext.menu.Menu({
    id: 'rightClickCont1',
    items: [{
        id: 'DaTongYDTS',
        handler: DaTongYDTSBtnClick,
        text: '药典提示'
    }]
});

function rightClickFn(grid, rowindex, e) {
    e.preventDefault();
    rightClick.showAt(e.getXY());
}

function rightClickFn1(grid, rowindex, e) {
    e.preventDefault();
    rightClick1.showAt(e.getXY());
}
    
    
function PrescAnalyse(){
	var passType=tkMakeServerCall("web.DHCOutPhCommon","GetPassProp",logongroup,logonloc,logonuser);
	if (passType==""){
		Ext.Msg.show({
                    title: '注意',
                    msg: '未设置处方分析接口，请在参数设置-门诊药房-合理用药厂商中添加相应厂商!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.INFO
                });
		return;
	}
	if (passType=="DHC"){
		// 东华知识库
		/* DHCSTPHCMPASS.PassAnalysis({ 
		 	GridId: "grid-presc", 
		 	MOeori: "orditem",
		 	PrescNo:"prescno", 
		 	GridType: "JqGrid", 
		 	Field: "druguse",
		 	ResultField:"druguseresult"
		 });*/
	}else if (passType=="DT"){
		// 大通
		 StartDaTongDll(); 
		 DaTongPrescAnalyse();  
	}else if (passType=="MK"){
		// 美康
		MKPrescAnalyse(); 
	}else if (passType=="YY"){
	}
}


/********************** 调用大通合理用药 start   **************************/
//大通处方分析
function DaTongPrescAnalyse() {
    var totalnum = ordgrid.getStore().getCount();
    if (totalnum == 0) {
        return;
    }
    for (var i = 0; i < totalnum; i++) {
        var record = ordgrid.getStore().getAt(i);
        var prescno = record.data.prescno;
        var datongflag = record.data.datongflag;
        var baseinfo = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDocBaseInfoByPresc", prescno);
        var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescInfoXML", prescno);
        myrtn = dtywzxUI(6, baseinfo, myPrescXML);
        if (myrtn == 0) { var imgname = "warning0.gif"; }
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// 黄灯
        if (myrtn == 2) { var imgname = "warning3.gif"; }	// 黑灯
        record.set("datongflag", myrtn)
        var str = "<img id='DrugUseImg" + i + "'" + " src='../scripts/pharmacy/images/" + imgname + "'>";
        ordgrid.getView().getCell(i, 1).innerHTML = str;
    }
}

//列点击事件
function orddetailgridcmClick(grid, rowIndex, columnIndex, e) {
    if (columnIndex == 2) {
        var record = ordgrid.getStore().getAt(rowIndex);
        var orditem = record.data.orditem;
        var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongOutPresInfo", orditem);
        myrtn = dtywzxUI(28676, 1, myPrescXML);
    }
}


//初始化
function StartDaTongDll() {
    dtywzxUI(0, 0, "");
}

function dtywzxUI(nCode, lParam, sXML) {
    var result;
    result = CaesarComponent.CRMS_UI(nCode, lParam, sXML, "");
    return result;
}

///大通药典提示
function DaTongYDTSBtnClick() {
    Ext.Msg.show({
        title: '注意',
        msg: '需要和第三方合理用药软件接口,暂未开放 !',
        buttons: Ext.Msg.OK,
        icon: Ext.MessageBox.INFO
    });
    return;
    var rows = Ext.getCmp("orddetailgridtbl").getSelectionModel().getSelections(); // modified by myq 20150518 ordgridtbl->orddetailgridtbl
    var totalnum = rows.length;
    if (totalnum == 0) {
        return;
    }
    var currow = orddetailgrid.getSelectionModel().getSelected();
    var orditm = currow.get("oeorditm");
    dtywzxUI(3, 0, "");
    var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDTYDTS", orditm);
    myrtn = dtywzxUI(12, 0, myPrescXML);
}

/********************** 调用大通合理用药 end   **************************/
    
/********************** 调用美康合理用药 start   **************************/


//大通处方分析
function MKPrescAnalyse() {
    var totalnum = ordgrid.getStore().getCount();
    if (totalnum == 0) {
        return;
    }
    for (var i = 0; i < totalnum; i++) {
        var record = ordgrid.getStore().getAt(i);
        var prescno = record.data.prescno;
        myrtn = HLYYPreseCheck(prescno,0); 
        var imgname = ""
        if (myrtn == 0) { var imgname = "warning0.gif"; }	// 合理
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// 黄灯
        if (myrtn == 2) { var imgname = "warning2.gif"; }	// 
        if (myrtn == 3) { var imgname = "warning3.gif"; }	// 
        if (myrtn == 4) { var imgname = "warning4.gif"; }	// 
        if (imgname == "") { var imgname = myrtn }
        record.set("datongflag", myrtn)
        var str = "<img id='DrugUseImg" + i + "'" + " src='../scripts/pharmacy/images/" + imgname + "'>";
        ordgrid.getView().getCell(i, 1).innerHTML = str;
    }
}


function HLYYPreseCheck(prescno,flag){
	var XHZYRetCode=0  //处方检查返回代码
	MKXHZY1(prescno,flag);
	//若为同步处理,取用McPASS.ScreenHighestSlcode
	//若为异步处理,需调用回调函数处理.
	//同步异步为McConfig.js MC_Is_SyncCheck true-同步;false-异步
	XHZYRetCode=McPASS.ScreenHighestSlcode;
	return XHZYRetCode	
}

function MKXHZY1(prescno,flag){
	MCInit1(prescno);
	HisScreenData1(prescno);
	MDC_DoCheck(HIS_dealwithPASSCheck,flag);
}

function MCInit1(prescno) {
	var PrescStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var prescdetail=PrescStr.split("^")
	var pass = new Params_MC_PASSclient_In();
    pass.HospID = prescdetail[0];  
    pass.UserID = prescdetail[1];
    pass.UserName = prescdetail[2];
    pass.DeptID = prescdetail[3];
    pass.DeptName = prescdetail[4];
    pass.CheckMode ="mzyf"  //MC_global_CheckMode;
    MCPASSclient = pass;
}

function HIS_dealwithPASSCheck(result) {
        if (result > 0) {
        }
        else {
            //alert("没问题");
        }

	return result ;
}


function HisScreenData1(prescno){
	var Orders="";
	var Para1=""
	
	var PrescMStr=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescMainInfo", prescno);
	var PrescMInfo=PrescMStr.split("^")
	var Orders=tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetPrescDetailInfo", prescno);
	if (Orders==""){return;}
	var DocName=PrescMInfo[2];
	var EpisodeID=PrescMInfo[5];
	if (EpisodeID==""){return}
	var ret=tkMakeServerCall("web.DHCHLYY","GetPrescInfo",EpisodeID,Orders,DocName);
	var TempArr=ret.split(String.fromCharCode(2));
	var PatInfo=TempArr[0];
	var MedCondInfo=TempArr[1];
	var AllergenInfo=TempArr[2];
	var OrderInfo=TempArr[3];
	var PatArr=PatInfo.split("^");
	
	
	var ppi = new Params_MC_Patient_In();
	ppi.PatCode = PatArr[0];			// 病人编码
	ppi.InHospNo= PatArr[11]
	ppi.VisitCode =PatArr[7]            // 住院次数
	ppi.Name = PatArr[1];				// 病人姓名
	ppi.Sex = PatArr[2];				// 性别
	ppi.Birthday = PatArr[3];			// 出生年月
	
	ppi.HeightCM = PatArr[5];			// 身高
	ppi.WeighKG = PatArr[6];			// 体重
	ppi.DeptCode  = PatArr[8];			// 住院科室
	ppi.DeptName  =PatArr[12]
	ppi.DoctorCode =PatArr[13] ;		// 医生
	ppi.DoctorName =PatArr[9]
	ppi.PatStatus =1
	ppi.UseTime  = PatArr[4];		   	// 使用时间
	ppi.CheckMode = MC_global_CheckMode
	ppi.IsDoSave = 1
	MCpatientInfo  = ppi;
    var arrayDrug = new Array();
	var pri;
  	var OrderInfoArr=OrderInfo.split(String.fromCharCode(1));
  	//alert(OrderInfo)
  	McRecipeCheckLastLightStateArr = new Array();
	for(var i=0; i<OrderInfoArr.length ;i++){    
		var OrderArr=OrderInfoArr[i].split("^");
		//传给core的，并且由core返回变灯的唯一编号，构造的灯div的id也应该和这个相关联
        drug = new Params_Mc_Drugs_In();
        
        drug.Index = OrderArr[0];             			//药品序号
        drug.OrderNo =OrderArr[0]; 		        		//医嘱号
        drug.DrugUniqueCode = OrderArr[1];  	//药品编码
        drug.DrugName =  OrderArr[2]; 			//药品名称
        drug.DosePerTime = OrderArr[3]; 	   //单次用量
		drug.DoseUnit =OrderArr[4];   	        //给药单位      
        drug.Frequency =OrderArr[5]; 	        //用药频次
        drug.RouteCode = OrderArr[8]; 	   		//给药途径编码
        drug.RouteName = OrderArr[8];   		//给药途径名称
		drug.StartTime = OrderArr[6];			//开嘱时间
        drug.EndTime = OrderArr[7]; 			//停嘱时间
        drug.ExecuteTime = ""; 	   				//执行时间
		drug.GroupTag = OrderArr[10]; 	       //成组标记
        drug.IsTempDrug = OrderArr[11];          //是否临时用药 0-长期 1-临时
        drug.OrderType = 0;    //医嘱类别标记 0-在用(默认);1-已作废;2-已停嘱;3-出院带药
        drug.DeptCode = PrescMInfo[7].split("-")[1];     //开嘱科室编码
        drug.DeptName =  PrescMInfo[4]; 	  //开嘱科室名称
        drug.DoctorCode =PrescMInfo[6];   //开嘱医生编码
        drug.DoctorName =PrescMInfo[2];     //开嘱医生姓名
		drug.RecipNo = "";            //处方号
        drug.Num = "";                //药品开出数量
        drug.NumUnit = "";            //药品开出数量单位          
        drug.Purpose = 0;             //用药目的(1预防，2治疗，3预防+治疗, 0默认)  
        drug.OprCode = ""; //手术编号,如对应多手术,用','隔开,表示该药为该编号对应的手术用药
		drug.MediTime = ""; //用药时机(术前,术中,术后)(0-未使用1- 0.5h以内,2-0.5-2h,3-于2h)
		drug.Remark = "";             //医嘱备注 
		arrayDrug[arrayDrug.length] = drug;
    
	}
	McDrugsArray = arrayDrug;
	var arrayAllergen = new Array();
	var pai;
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++){
		var AllergenArr=AllergenInfoArr[i].split("^");
        
     	var allergen = new Params_Mc_Allergen_In();
     	allergen.Index = i;        //序号  
      	allergen.AllerCode = AllergenArr[0];    //编码
      	allergen.AllerName = AllergenArr[1];    //名称  
      	allergen.AllerSymptom =AllergenArr[3]; //过敏症状 
      	 
		arrayAllergen[arrayAllergen.length] = allergen;
	}
	McAllergenArray = arrayAllergen;
	//病生状态类数组
	 var arrayMedCond = new Array();
	var pmi;
  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
	for(var i=0; i<MedCondInfoArr.length ;i++){			
		var MedCondArr=MedCondInfoArr[i].split("^");
       
      	var medcond;       
      	medcond = new Params_Mc_MedCond_In();
      	medcond.Index = i	;              			//诊断序号
     	medcond.DiseaseCode = MedCondArr[0];        //诊断编码
      	medcond.DiseaseName = MedCondArr[1];     //诊断名称
 		medcond.RecipNo = "";              //处方号
      	arrayMedCond[arrayMedCond.length] = medcond;     
      
	}
	var arrayoperation = new Array();
	McOperationArray = arrayoperation;
}

//********************** 调用美康合理用药 end   **************************/    
    
if (LoadPCNTID != "") {
    QueryCommontItm(LoadPCNTID, "", "", "");
}
    
    
    
});