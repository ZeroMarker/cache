///��������������JS
///Creator:LiangQiang
///CreatDate:2012-05-20
document.write("<object id='CaesarComponent' classid='clsid:8C028072-4FD2-46AE-B6D2-63E9F9B4155F' codebase = '../addins/client/dtywzxUIForMS.cab#version1.0.0.1'>");
document.write("</object>");
var unitsUrl = 'dhcpha.comment.main.save.csp';

var logonuser = session['LOGON.USERID'];
var logongroup = session['LOGON.GROUPID'];
var logonloc = session['LOGON.CTLOCID']

Ext.onReady(function() {
    Ext.QuickTips.init(); // ������Ϣ��ʾ
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

//����load Tab,����������
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


    //��ϸ
    if (p.id == "frameordquery") {
        if (adm == 0) return;
        FindDiagData(adm);
        FindOrdDetailData(prescno);
        FindLogData(orditem);
        CheckArcExist(prescno);
    }

    //����Ԥ��
    if (p.id == "prescriptioninfo") {
        if (zcyflag == 0) {
            iframe.src = 'dhcpha.comment.prescriptioninfo.csp' + '?PrescNo=' + prescno + '&EpisodeID=' + adm;
        } else {
            iframe.src = 'dhcpha.comment.cyprescriptioninfo.csp' + '?PrescNo=' + prescno + '&EpisodeID=' + adm;
        }
    }

    //����ҽ��
    if (p.id == "frameadmordquery") {
        //iframe.src = p.src + '?EpisodeID=' + adm;
        iframe.src = 'oeorder.opbillinfo.csp' + '?EpisodeID=' + adm;
    }
};

//��ͨ��������
var DaTongAnalyseButton = new Ext.Button({
    width: 65,
    id: "DaTongAnalyseBtn",
    text: '��������',
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
    text: '����',
    listeners: {
        "click": function() {
            ClearWindow();
        }
    }
});

var OkButton = new Ext.Button({
    width: 55,
    id: "OkButton",
    text: '����',
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
    text: '������',
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
    text: '�鵥',
    listeners: {
        "click": function() {
            FindCommentFun(1);
        }
    }
});

/// ҽ������table 
var sm = new Ext.grid.CheckboxSelectionModel(); // add checkbox
var nm = new Ext.grid.RowNumberer();
var ordgridcm = new Ext.grid.ColumnModel([
    nm,
    { header: '������ҩ', dataIndex: 'DrugUseImg', width: 75 },
    { header: 'Ԥ��', dataIndex: 'passtext', width: 75 },
    { header: '�ǼǺ�', dataIndex: 'patno', width: 75, hidden: true },
    { header: '����', dataIndex: 'patname', width: 60, hidden: true },
    { header: '�Ա�', dataIndex: 'patsex', width: 40, hidden: true },
    { header: '����', dataIndex: 'patage', width: 40, hidden: true },
    { header: '�ѱ�', dataIndex: 'type', width: 60, hidden: true },
    { header: '���', dataIndex: 'diag', width: 500, hidden: true },
    { header: '������', dataIndex: 'prescno', width: 125 },
    { header: '���', dataIndex: 'curret', width: 125 },
    { header: '����', dataIndex: 'dept', width: 80, hidden: true },
    { header: 'adm', dataIndex: 'adm', hidden: true },
    { header: 'orditem', dataIndex: 'orditem', hidden: true },
    { header: 'porcess', dataIndex: 'porcess', hidden: true },
    { header: 'waycode', dataIndex: 'waycode', hidden: true },
    { header: '������ϸid', dataIndex: 'pcntsi', hidden: true },
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

var ordgridcmPagingToolbar = new Ext.PagingToolbar({ //��ҳ����
    store: ordgridds,
    pageSize: 200
        //��ʾ���½���Ϣ
        //displayInfo:true,
        //displayMsg:'��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
        //prevText:"��һҳ",
        //nextText:"��һҳ",
        //refreshText:"ˢ��",
        //lastText:"���ҳ",
        //firstText:"��һҳ",
        //beforePageText:"��ǰҳ",
        //afterPageText:"��{0}ҳ",
        //emptyMsg: "û������"
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

///���table 
var diaggridcm = new Ext.grid.ColumnModel({
    columns: [
        { header: '���', dataIndex: 'diag', width: 800 }
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
    fieldLabel: "�������"
});

var PreAntAmtField = new Ext.form.TextField({
    width: 120,
    id: "PreAntAmtText",
    fieldLabel: "��������ҩ���"
});

///ҽ����ϸ����table
var orddetailgridcm = new Ext.grid.ColumnModel({
    columns: [
        { header: 'ҽ������', dataIndex: 'incidesc', width: 280 },
        { header: '����', dataIndex: 'qty', width: 40 },
        { header: '��λ', dataIndex: 'uomdesc', width: 70 },
        { header: '����', dataIndex: 'dosage', width: 60 },
        { header: 'Ƶ��', dataIndex: 'freq', width: 100 },
        { header: '���', dataIndex: 'spec', width: 120, hidden: true },
        { header: '�÷�', dataIndex: 'instruc', width: 80 },
        { header: '��ҩ�Ƴ�', dataIndex: 'dura', width: 80 },
        { header: 'ʵ���Ƴ�', dataIndex: 'realdura', width: 60, hidden: true },
        { header: '����', dataIndex: 'form', width: 120 },
        { header: '����ҩ��', dataIndex: 'basflag', width: 70 },
        { header: 'ҽ��', dataIndex: 'doctor', width: 100 },
        { header: 'ҽ����������', dataIndex: 'orddate', width: 150 },
        { header: 'ҽ����ע', dataIndex: 'remark', width: 70 },
        { header: '����', dataIndex: 'manf', width: 250 , hidden: true},
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
    //��ʾ���½���Ϣ
    displayInfo: true,
    displayMsg: '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
    prevText: "��һҳ",
    nextText: "��һҳ",
    refreshText: "ˢ��",
    lastText: "���ҳ",
    firstText: "��һҳ",
    beforePageText: "��ǰҳ",
    afterPageText: "��{0}ҳ",
    emptyMsg: "û������"
});

var orddetailgrid = new Ext.grid.GridPanel({
    region: 'west',
    id: 'orddetailgridtbl', // add by myq 20150518
    stripeRows: true,
    height: 280,
    autoScroll: true,
    title: "ҩƷ�б�",
    enableHdMenu: false,
    ds: orddetailgridds,
    cm: orddetailgridcm,
    enableColumnMove: false,
    tbar: ['�������:', PreAmtField, '-', '��������ҩ���:', PreAntAmtField],
    bbar: orddetailgridcmPagingToolbar,
    trackMouseOver: 'true'
});

var commentloggridcm = new Ext.grid.ColumnModel({
    columns: [
        { header: '���', dataIndex: 'comgrpno', width: 50 },
        { header: '����ԭ��', dataIndex: 'comreason', width: 300 },
        { header: '����', dataIndex: 'patname', hidden: true },
        { header: '������', dataIndex: 'prescno', hidden: true },
        { header: '��������', dataIndex: 'comdate', width: 100 },
        { header: '����ʱ��', dataIndex: 'comtime', width: 100 },
        { header: '������', dataIndex: 'comuser', width: 120 },
        { header: '�������', dataIndex: 'comresult', width: 100 },
        { header: '���ϸ�ʾֵ', dataIndex: 'comfactor', width: 100 },
        { header: 'ҩʦ����', dataIndex: 'comadvice', width: 150 },
        { header: 'ҩʦ��ע', dataIndex: 'comphnote', width: 80 },
        { header: 'ҽ������', dataIndex: 'comdocadvice', width: 60, hidden: true },
        { header: 'ҽ����ע', dataIndex: 'comdocnote', width: 80 },
        { header: '��Ч', dataIndex: 'comactive', width: 40 }
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
    title: '������־',
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

///�ұߵ�Form
var toolform = new Ext.TabPanel({
    id: 'ToolsTabPanel',
    region: 'center',
    margins: '3 3 3 3',
    frame: false,
    activeTab: 0,
    items: [{
        title: 'ҽ����ϸ',
        id: 'frameordquery',
        layout: 'form',
        items: [diaggrid, orddetailgrid, commentloggrid]
    }, {
        title: '����Ԥ��',
        frameName: 'prescriptioninfo',
        html: '<iframe id="prescription" width=100% height=100% src= ></iframe>',
        id: 'prescriptioninfo'
    }, {
        title: '������¼',
        frameName: 'framepaallergy',
        html: '<iframe id="paallergyFrame" width=100% height=100% src=dhcpha.comment.paallergy.csp></iframe>',
        src: 'dhcpha.comment.paallergy.csp',
        id: 'framepaallergy'
    }, {
        title: '����¼',
        frameName: 'framerisquery',
        html: '<iframe id="framerisquery" width=100% height=100% src=dhcpha.comment.risquery.csp></iframe>',
        src: 'dhcpha.comment.risquery.csp',
        id: 'framerisquery'
    }, {
        title: '�����¼',
        frameName: 'framelabquery',
        //html: '<iframe id="framelabquery" width=100% height=100% src=dhcpha.comment.labquery.csp></iframe>',		
        //src: 'dhcpha.comment.labquery.csp',
        html: '<iframe id="framelabquery" width=100% height=100% src=jquery.easyui.dhclaborder.csp></iframe>',
        src: 'jquery.easyui.dhclaborder.csp',
        id: 'framelabquery'
    }, {
        title: '�������',
        frameName: 'frameprbrowser',
        //html: '<iframe id="frmeprbrowser" width=100% height=100% src=emr.interface.browse.category.csp></iframe>',		
        //src: 'emr.interface.browse.category.csp',
        html: '<iframe id="frmeprbrowser" width=100% height=100% src=emr.interface.browse.episode.csp></iframe>',
        src: 'emr.interface.browse.episode.csp', //����	
        id: 'frameprbrowser'
    }, {
        title: '����ҽ��',
        frameName: 'frameadmordquery',
        html: '<iframe id="frameadmordquery" width=100% height=100% src=dhcpha.comment.admordquery.csp></iframe>',
        src: 'dhcpha.comment.queryorditemds.csp',
        id: 'frameadmordquery'
    }],
    tbar: [
        '������:', { xtype: 'tbtext', id: 'baseInfoPrescNo', height: '20', width: '110', text: '', cls: 'x-panel-header' }, '-',
        '�ǼǺ�:', { xtype: 'tbtext', id: 'baseInfoIPNo', height: '20', width: '80', text: '', cls: 'x-panel-header' }, '-',
        '����:', { xtype: 'tbtext', id: 'baseInfoName', height: '20', width: '70', text: '', cls: 'x-panel-header' }, "-",
        '�Ա�:', { xtype: 'tbtext', id: 'baseInfoSex', height: '20', width: '50', text: '', cls: 'x-panel-header' }, "-",
        '����:', { xtype: 'tbtext', id: 'baseInfoAge', height: '20', width: '40', text: '', cls: 'x-panel-header' }, "-",
        '�ѱ�:', { xtype: 'tbtext', id: 'baseInfoType', height: '20', width: '50', text: '', cls: 'x-panel-header' }, "-",
        '����:', { xtype: 'tbtext', id: 'baseInfoLoc', height: '20', width: '125', text: '', cls: 'x-panel-header' }
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
    title: '��������',
    collapsible: true,
    frame: false,
    width: 400,
    layout: 'border',
    defaults: {
        split: false //�Ƿ��зָ���  
            //collapsible: true,           //�Ƿ�����۵� 
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
///�����б�grid �������¼�
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

///���´���(�����ѯ����)
function OpenMoreFindWindow() {
    MoreFindFun();
}

///�鵥����,ѡȡ������,��������������
QueryCommontItm = function(PCNTSRowid, MainTitle, RetFlag, Phama) {
    ClearWindow();
    waitMask = new Ext.LoadMask(Ext.getBody(), { msg: "ϵͳ���ڴ������ݣ����Ժ�..." });
    waitMask.show();
    ordgridds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=QueryCommontItm&PCNTSRowid=' + PCNTSRowid + '&RetFlag=' + RetFlag + '&Phama=' + Phama });
    ordgridds.load({
        params: { start: 0, limit: ordgridcmPagingToolbar.pageSize },
        callback: function(r, options, success) {
            waitMask.hide();
            if (success == false) {
                Ext.Msg.show({ title: 'ע��', msg: '��ѯʧ�� !', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
            } else {
                //westPanel.setTitle(MainTitle);
            }
        }
    });
}

/// ���ݴ����Ų鿴ҽ����ϸ
function FindOrdDetailData(prescno) {
    //alert("prescno:"+prescno)
    orddetailgridds.removeAll();
    orddetailgridds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=FindOrdDetailData&PrescNo=' + prescno });
    orddetailgridds.load({
        params: { start: 0, limit: orddetailgridcmPagingToolbar.pageSize },
        callback: function(r, options, success) {
            if (success == false) {
                Ext.Msg.show({ title: 'ע��', msg: '��ѯʧ�� !', buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
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

//��ѯ��־
function FindLogData(orditem) {
    var currow = ordgrid.getSelectionModel().getSelected();
    var pcntsi = currow.data.pcntsi; // MYQ 20160805 �����ӱ�id
    commentloggridds.removeAll();
    commentloggridds.proxy = new Ext.data.HttpProxy({ url: unitsUrl + '?action=QueryCommontLog&OrdItem=' + orditem + '&Pcntsi=' + pcntsi });
    commentloggridds.load({
        callback: function(r, options, success) {
            if (success == false) {
                Ext.Msg.show({
                    title: 'ע��',
                    msg: '��ѯʧ�� !',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.INFO
                });
            }
        }
    });
}

//��ѯ���
function FindDiagData(adm) {
    diaggridds.removeAll();
    diaggridds.proxy = new Ext.data.HttpProxy({
        url: unitsUrl + '?action=GetMRDiagnosDesc&adm=' + adm
    });
    diaggridds.load({
        callback: function(r, options, success) {
            if (success == false) {
                Ext.Msg.show({
                    title: 'ע��',
                    msg: '��ѯʧ�� !',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.INFO
                });
            }
        }
    });
}

/// ��PatInfo
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

///��Grid  1 ȫ��  2���ұ�grid
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

///����
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


///�ϸ�
function CommontOk() {
    var row = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections();
    if (!(row)) {
        Ext.Msg.getDialog().setWidth(500);
        Ext.MessageBox.alert("��ʾ", "δѡ�м�¼!");
        return;
    }
    if (row == 0) {
        Ext.Msg.getDialog().setWidth(500);
        Ext.MessageBox.alert("��ʾ", "δѡ�м�¼!");
        return;
    }
    var orditm = row[0].data.orditem;
    var pcntsi = row[0].data.pcntsi;
    var pcntsflag = tkMakeServerCall("web.DHCSTCNTSMAIN", "GetPCNTSComFlag", pcntsi, session['LOGON.GROUPID'])
    if (pcntsflag == -11) {
        msgtxt = "�ô����ѵ���,������¼�İ�ȫ��û���޸ĵ�Ȩ��!"
        Ext.Msg.show({
            title: '��ʾ',
            msg: msgtxt,
            buttons: Ext.Msg.OK,
            icon: Ext.MessageBox.INFO
        });
        return;
    } else if (pcntsflag == -10) {
        msgtxt = "δ��ȡ�������ӱ���ߵ�¼��ȫ��!"
        Ext.Msg.show({
            title: '��ʾ',
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


//���з���Ҫ��Ķ���ϸ�
function AllCommontOk() {
    Ext.Msg.show({
        title: 'ע��',
        msg: '��Ҫ�͵�����������ҩ����ӿ�,��δ���� !',
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


///���ϸ�
function CommontBad() {
    var row = Ext.getCmp("ordgridtbl").getSelectionModel().getSelections();
    if (!(row)) {
        Ext.Msg.getDialog().setWidth(500);
        Ext.MessageBox.alert("��ʾ", "δѡ�м�¼!");
        return;
    }
    if (row == 0) {
        Ext.Msg.getDialog().setWidth(500);
        Ext.MessageBox.alert("��ʾ", "δѡ�м�¼!");
        return;
    }
    var orditm = row[0].data.orditem;
    var waycode = row[0].data.waycode;
    var pcntsi = row[0].data.pcntsi;
    var pcntsflag = tkMakeServerCall("web.DHCSTCNTSMAIN", "GetPCNTSComFlag", pcntsi, session['LOGON.GROUPID'])
    if (pcntsflag == -11) {
        msgtxt = "�ô����ѵ���,������¼�İ�ȫ��û���޸ĵ�Ȩ��!"
        Ext.Msg.show({ title: '��ʾ', msg: msgtxt, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
        return;
    } else if (pcntsflag == -10) {
        msgtxt = "δ��ȡ�������ӱ���ߵ�¼��ȫ��!"
        Ext.Msg.show({ title: '��ʾ', msg: msgtxt, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
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


///����������
function SaveCommontResult(currow, ret, orditm, reasondr, input) {
    var User = session['LOGON.USERID'];
    var currow = ordgrid.getSelectionModel().getSelected();
    var pcntsi = currow.data.pcntsi; // MYQ 20160805 �����ӱ�id
    var otherstr = pcntsi
    Ext.Ajax.request({
        url: unitsUrl + '?action=SaveItmResult&User=' + User + '&CommontResult=' + ret + '&OrdItm=' + orditm + '&ReasonDr=' + reasondr + '&Input=' + encodeURI(input) + '&Otherstr=' + otherstr,
        waitMsg: '������...',
        failure: function(result, request) {
            Ext.Msg.show({
                title: '����',
                msg: '������������!',
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
                    msgtxt = "�ѵ���,��û���޸ĵ�Ȩ��!"
                } else if (jsonData.retvalue == "-3") {
                    msgtxt = "�������������ҩƷ���ɱ�ʧ��,���������ڱ�ע��Ϣ��������,���ٴκ�ʵ!"
                }
                else if (jsonData.retvalue="-44"){
				  	msgtxt="����ϸ�ѷ������ҩʦ,��û�е�������ϸ��Ȩ��!"
				  }
                Ext.Msg.show({ title: '��ʾ', msg: msgtxt, buttons: Ext.Msg.OK, icon: Ext.MessageBox.INFO });
            }
        },
        scope: this
    });
}

/// �Ҽ��˵�    
ordgrid.addListener('rowcontextmenu', rightClickFn);
var rightClick = new Ext.menu.Menu({
    id: 'rightClickCont',
    items: [{
        id: 'ExportXls',
        handler: AllCommontOk,
        text: 'һ������'
    }]
})

orddetailgrid.addListener('rowcontextmenu', rightClickFn1);
var rightClick1 = new Ext.menu.Menu({
    id: 'rightClickCont1',
    items: [{
        id: 'DaTongYDTS',
        handler: DaTongYDTSBtnClick,
        text: 'ҩ����ʾ'
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
                    title: 'ע��',
                    msg: 'δ���ô��������ӿڣ����ڲ�������-����ҩ��-������ҩ�����������Ӧ����!',
                    buttons: Ext.Msg.OK,
                    icon: Ext.MessageBox.INFO
                });
		return;
	}
	if (passType=="DHC"){
		// ����֪ʶ��
		/* DHCSTPHCMPASS.PassAnalysis({ 
		 	GridId: "grid-presc", 
		 	MOeori: "orditem",
		 	PrescNo:"prescno", 
		 	GridType: "JqGrid", 
		 	Field: "druguse",
		 	ResultField:"druguseresult"
		 });*/
	}else if (passType=="DT"){
		// ��ͨ
		 StartDaTongDll(); 
		 DaTongPrescAnalyse();  
	}else if (passType=="MK"){
		// ����
		MKPrescAnalyse(); 
	}else if (passType=="YY"){
	}
}


/********************** ���ô�ͨ������ҩ start   **************************/
//��ͨ��������
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
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// �Ƶ�
        if (myrtn == 2) { var imgname = "warning3.gif"; }	// �ڵ�
        record.set("datongflag", myrtn)
        var str = "<img id='DrugUseImg" + i + "'" + " src='../scripts/pharmacy/images/" + imgname + "'>";
        ordgrid.getView().getCell(i, 1).innerHTML = str;
    }
}

//�е���¼�
function orddetailgridcmClick(grid, rowIndex, columnIndex, e) {
    if (columnIndex == 2) {
        var record = ordgrid.getStore().getAt(rowIndex);
        var orditem = record.data.orditem;
        var myPrescXML = tkMakeServerCall("web.DHCSTPIVADaTongInterface", "GetDaTongOutPresInfo", orditem);
        myrtn = dtywzxUI(28676, 1, myPrescXML);
    }
}


//��ʼ��
function StartDaTongDll() {
    dtywzxUI(0, 0, "");
}

function dtywzxUI(nCode, lParam, sXML) {
    var result;
    result = CaesarComponent.CRMS_UI(nCode, lParam, sXML, "");
    return result;
}

///��ͨҩ����ʾ
function DaTongYDTSBtnClick() {
    Ext.Msg.show({
        title: 'ע��',
        msg: '��Ҫ�͵�����������ҩ����ӿ�,��δ���� !',
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

/********************** ���ô�ͨ������ҩ end   **************************/
    
/********************** ��������������ҩ start   **************************/


//��ͨ��������
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
        if (myrtn == 0) { var imgname = "warning0.gif"; }	// ����
        if (myrtn == 1) { var imgname = "warning1.gif"; }	// �Ƶ�
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
	var XHZYRetCode=0  //������鷵�ش���
	MKXHZY1(prescno,flag);
	//��Ϊͬ������,ȡ��McPASS.ScreenHighestSlcode
	//��Ϊ�첽����,����ûص���������.
	//ͬ���첽ΪMcConfig.js MC_Is_SyncCheck true-ͬ��;false-�첽
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
            //alert("û����");
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
	ppi.PatCode = PatArr[0];			// ���˱���
	ppi.InHospNo= PatArr[11]
	ppi.VisitCode =PatArr[7]            // סԺ����
	ppi.Name = PatArr[1];				// ��������
	ppi.Sex = PatArr[2];				// �Ա�
	ppi.Birthday = PatArr[3];			// ��������
	
	ppi.HeightCM = PatArr[5];			// ���
	ppi.WeighKG = PatArr[6];			// ����
	ppi.DeptCode  = PatArr[8];			// סԺ����
	ppi.DeptName  =PatArr[12]
	ppi.DoctorCode =PatArr[13] ;		// ҽ��
	ppi.DoctorName =PatArr[9]
	ppi.PatStatus =1
	ppi.UseTime  = PatArr[4];		   	// ʹ��ʱ��
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
		//����core�ģ�������core���ر�Ƶ�Ψһ��ţ�����ĵ�div��idҲӦ�ú���������
        drug = new Params_Mc_Drugs_In();
        
        drug.Index = OrderArr[0];             			//ҩƷ���
        drug.OrderNo =OrderArr[0]; 		        		//ҽ����
        drug.DrugUniqueCode = OrderArr[1];  	//ҩƷ����
        drug.DrugName =  OrderArr[2]; 			//ҩƷ����
        drug.DosePerTime = OrderArr[3]; 	   //��������
		drug.DoseUnit =OrderArr[4];   	        //��ҩ��λ      
        drug.Frequency =OrderArr[5]; 	        //��ҩƵ��
        drug.RouteCode = OrderArr[8]; 	   		//��ҩ;������
        drug.RouteName = OrderArr[8];   		//��ҩ;������
		drug.StartTime = OrderArr[6];			//����ʱ��
        drug.EndTime = OrderArr[7]; 			//ͣ��ʱ��
        drug.ExecuteTime = ""; 	   				//ִ��ʱ��
		drug.GroupTag = OrderArr[10]; 	       //������
        drug.IsTempDrug = OrderArr[11];          //�Ƿ���ʱ��ҩ 0-���� 1-��ʱ
        drug.OrderType = 0;    //ҽ������� 0-����(Ĭ��);1-������;2-��ͣ��;3-��Ժ��ҩ
        drug.DeptCode = PrescMInfo[7].split("-")[1];     //�������ұ���
        drug.DeptName =  PrescMInfo[4]; 	  //������������
        drug.DoctorCode =PrescMInfo[6];   //����ҽ������
        drug.DoctorName =PrescMInfo[2];     //����ҽ������
		drug.RecipNo = "";            //������
        drug.Num = "";                //ҩƷ��������
        drug.NumUnit = "";            //ҩƷ����������λ          
        drug.Purpose = 0;             //��ҩĿ��(1Ԥ����2���ƣ�3Ԥ��+����, 0Ĭ��)  
        drug.OprCode = ""; //�������,���Ӧ������,��','����,��ʾ��ҩΪ�ñ�Ŷ�Ӧ��������ҩ
		drug.MediTime = ""; //��ҩʱ��(��ǰ,����,����)(0-δʹ��1- 0.5h����,2-0.5-2h,3-��2h)
		drug.Remark = "";             //ҽ����ע 
		arrayDrug[arrayDrug.length] = drug;
    
	}
	McDrugsArray = arrayDrug;
	var arrayAllergen = new Array();
	var pai;
	var AllergenInfoArr=AllergenInfo.split(String.fromCharCode(1));
	for(var i=0; i<AllergenInfoArr.length ;i++){
		var AllergenArr=AllergenInfoArr[i].split("^");
        
     	var allergen = new Params_Mc_Allergen_In();
     	allergen.Index = i;        //���  
      	allergen.AllerCode = AllergenArr[0];    //����
      	allergen.AllerName = AllergenArr[1];    //����  
      	allergen.AllerSymptom =AllergenArr[3]; //����֢״ 
      	 
		arrayAllergen[arrayAllergen.length] = allergen;
	}
	McAllergenArray = arrayAllergen;
	//����״̬������
	 var arrayMedCond = new Array();
	var pmi;
  	var MedCondInfoArr=MedCondInfo.split(String.fromCharCode(1));
	for(var i=0; i<MedCondInfoArr.length ;i++){			
		var MedCondArr=MedCondInfoArr[i].split("^");
       
      	var medcond;       
      	medcond = new Params_Mc_MedCond_In();
      	medcond.Index = i	;              			//������
     	medcond.DiseaseCode = MedCondArr[0];        //��ϱ���
      	medcond.DiseaseName = MedCondArr[1];     //�������
 		medcond.RecipNo = "";              //������
      	arrayMedCond[arrayMedCond.length] = medcond;     
      
	}
	var arrayoperation = new Array();
	McOperationArray = arrayoperation;
}

//********************** ��������������ҩ end   **************************/    
    
if (LoadPCNTID != "") {
    QueryCommontItm(LoadPCNTID, "", "", "");
}
    
    
    
});