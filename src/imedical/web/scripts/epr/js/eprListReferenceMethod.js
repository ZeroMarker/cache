function getMultiRecordStore() {
    var store = new Ext.data.JsonStore({
        url: '../web.eprajax.reference.reflistrecord.cls?EpisodeID=' + chkEpisodeID + '&PrintTemplateDocID=' + prtTemplateDocID,
        root: 'data',
        totalProperty: 'totalCount',
        fields: [
            { name: 'ID' },
            { name: 'Title' },
            { name: 'Remark' },
            { name: 'EPRNum' },
            { name: 'HappenDate' },
            { name: 'HappenTime' },
            { name: 'CreateUser' },
            { name: 'TemplateID' },
            { name: 'TemplateVersion' }
        ]
    });

    store.on('load', function() {
        Ext.get('tabEPRRecordList').unmask();
    });

    store.on('loadexception', function(proxy, options, response, e) {
        Ext.get('tabEPRRecordList').unmask();
    });

    return store;
}

//创建就诊列表的Grid
function getMultiGridPanel() {
    var multiRecordStore = getMultiRecordStore();
    //multiRecordStore.load();
    multiRecordStore.load({ params: { start: 0, limit: 18} });

    var sm = new Ext.grid.CheckboxSelectionModel({
        dataIndex: "ID",
        singleSelect: true,
        listeners: {
            'beforerowselect': function(SelectionModel, rowIndex, keepExisting, record) {
                if (record.data["TemplateID"] != templateID || record.data["TemplateVersion"] != templateVersion) {
                    Ext.Msg.alert("提示信息", "该病程记录版本与目前版本不匹配，不能引用!");
                    return false;
                } else {
                    return true;
                }
            },
            'rowselect': function(record, index, e) {
                chkInstanceID = record.getSelected().get("ID");
                templateID = record.getSelected().get("TemplateID");
                templateVersion = record.getSelected().get("TemplateVersion");
            }
        }
    });

    var cm = new Ext.grid.ColumnModel([sm,
        { header: '<div style="text-align:center">标题</div>', dataIndex: 'Title', width: 3 },
        { header: '<div style="text-align:center">备注</div>', dataIndex: 'Remark', width: 3 },
        { header: '发生日期', dataIndex: 'HappenDate', width: 1, align: "center" },
        { header: '发生时间', dataIndex: 'HappenTime', width: 1, align: "center" },
        { header: '创建者', dataIndex: 'CreateUser', width: 1, align: "center" }
    ]);

    var recordGrid = new Ext.grid.GridPanel({
        id: 'multiRecordGrid',
        border: false,
        store: multiRecordStore,
        cm: cm,
        sm: sm,
        autoScroll: true,
        height: 480,
        bodyStyle: 'width:99%',
        autoWidth: true,
        frame: true,
        stripeRows: true,
        viewConfig: {
            forceFit: true,
            getRowClass: function(record, rowIndex, rowParams, store) {
                if (record.data["TemplateID"] != templateID || record.data["TemplateVersion"] != templateVersion) {
                    return "Eligible-Row";
                }
            }
        },
        tbar: [
            '->',
            '-',
            { id: 'btnReference', text: '引用', cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/btnReference.gif', pressed: false, handler: doReference }
        ],
        bbar: new Ext.PagingToolbar({
            store: multiRecordStore,
            pageSize: 18,
            displayInfo: true,
            displayMsg: '第 {0} 条到  {1} 条, 一共 {2} 条',
            beforePageText: '页码',
            afterPageText: '总页数 {0}',
            firstText: '首页',
            prevText: '上一页',
            nextText: '下一页',
            lastText: '末页',
            refreshText: '刷新',
            emptyMsg: "没有记录"
        })
    });

    return recordGrid;
}

//加载可重复模板记录列表
function loadMultiRecordList() {
    Ext.get('tabEPRRecordList').mask('载入数据,请稍候...', 'x-mask-loading');
    
    //将后台返回的json在前台生成GridPanel然后渲染到div中
    var divRecord = Ext.get("divMultiRecord");
    var multiGrid = new getMultiGridPanel();
    document.getElementById("divMultiRecord").innerHTML = "";
    multiGrid.render(divRecord);
}

function doSearch() {
    var admitType = Ext.getCmp('cboAdmType').getValue();
    var argDiagnosDesc = Ext.getCmp('txtArgDiagnosDesc').getValue();

    Ext.getCmp('episodeGrid').getEl().mask('数据重新加载中，请稍等...', 'x-mask-loading');
    var store = Ext.getCmp('episodeGrid').getStore();
    var url = '../web.eprajax.episodeListGrid.cls?patientID=' + patientID + '&admType=' + admitType + '&argDiagnosDesc=' + escape(argDiagnosDesc);
    store.proxy.conn.url = url;
    //store.load();
	store.load({ params: { start: 0, limit: 5} });

    store.on('load', function(store, record) {
        Ext.get('episodeGrid').unmask();
    });

    store.on('loadexception', function() {
        Ext.get('episodeGrid').unmask();
    });
}

function doConfirm() {
    var tpMultiple = Ext.getCmp("tpMultiple");
    var tabEPRRecordList = Ext.getCmp("tabEPRRecordList");
    tpMultiple.setActiveTab(tabEPRRecordList);

    //加载日常病程记录列表
    loadMultiRecordList();
}

function doReference() {
    var selModel = Ext.getCmp('multiRecordGrid').getSelectionModel();
    var selects = selModel.getSelections();
    if (selects.length == 0) {
        Ext.MessageBox.alert('操作提示', '请选择某条记录再进行病历引用!');
        return;
    }
    var chkInstanceID = selects[0].data["ID"];
    var chkEPRNum = selects[0].data["EPRNum"];

    var tpMultiple = Ext.getCmp("tpMultiple");
    var tabEPRReference = Ext.getCmp("tabEPRReference");
    tpMultiple.setActiveTab(tabEPRReference);
    
    var divTemplate = Ext.get("divTemplate");
    document.getElementById("divTemplate").innerHTML = "";
    var frameUrl = 'dhc.epr.ref.loadtemplate.csp?Refresh=1&LoadType=Multiple&EpisodeID=' + episodeID + '&InstanceID=' + chkInstanceID;
    var iframeScript = '<iframe id="frameTemplate" style="width:100%;height:440;" src="' + frameUrl + '" ></iframe>';
    var refPanel = new Ext.Panel({
        id: 'pnlReference',
        header: false,
        frame: true,
        collapsible: false,
        items: [
            {
                id: "pnlTemplate",
                height: 440,
                html: iframeScript
            }
        ],
        bbar: [
            '->',
	        '-',
	        { id: 'btnConfirmAndLog', text: '确定', cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/btnConfirm.gif', pressed: false, listeners: { 'click': function() { confirmAndLog(); } } }
        ]
	}).render(divTemplate);
}

function confirmAndLog() {
    var objEPRForm = frames['frameTemplate'].eprform;
    if (objEPRForm) {
        objEPRForm.PrnTemplateDocID = prtTemplateDocID;
        objEPRForm.EPRNum = "-1";
        var status = objEPRForm.SaveClick(true, "reference");
        var newInstanceID = objEPRForm.InstanceDataID;
        if (newInstanceID != "") {
            alert("引用成功!");
            Ext.getCmp('btnConfirmAndLog').disable();
        }
        var obj = objEPRForm.StatusAfterSaveNewFrameWork;
        var newLogID = obj.split('^')[1];

        objEPRForm.InvokePreviewService(patientID, episodeID, newLogID, prtTemplateID, "Normal", newInstanceID, userID, prtTemplateDocID);

        Ext.getCmp('refLogGrid').getEl().mask('数据重新加载中，请稍等...', 'x-mask-loading');
        var store = Ext.getCmp('refLogGrid').getStore();
        var url = '../web.eprajax.reference.refjournal.cls?EpisodeID=' + episodeID + '&RefType=' + refType + "&UserID" + userID;
        store.proxy.conn.url = url;
        store.load();

        store.on('load', function(store, record) {
            Ext.get('refLogGrid').unmask();
        });

        store.on('loadexception', function() {
            Ext.get('refLogGrid').unmask();
        });

        parent.frames['centerTab'].createEprList(patientID, episodeID, templateDocID, prtTemplateDocID);
        //parent.parent.OpenRecordClickHandler(episodeID, categoryID, profileID, instanceID, eprNum, profileID, patientID, newLogID, prtTemplateDocID);
    }
}

function doClose() {
    var win = parent.Ext.getCmp('winReference');
    win.close(this);
}