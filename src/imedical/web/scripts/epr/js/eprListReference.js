Ext.QuickTips.init();

function getAdmitGridPanel() {
    var store = getEpisodeStore();
    //store.load();
	store.load({ params: { start: 0, limit: 5} });

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true,
        listeners: {
            'rowselect': function(record, index, e) {
                chkAdmType = admitGrid.getStore().getAt(index).data['AdmType'];
                chkDiagnos = admitGrid.getStore().getAt(index).data['Diagnosis'];
                chkEpisodeID = admitGrid.getStore().getAt(index).data['EpisodeID'];
            }
        }
    });

    var cm = new Ext.grid.ColumnModel([sm,
        { header: '就诊日期', dataIndex: 'AdmDate', width: 70 },
        { header: '诊断', dataIndex: 'Diagnosis' },
        { header: '类型', dataIndex: 'AdmType', width: 40, renderer: getAdmitType },
        { header: '科室', dataIndex: 'CurDept', width: 80 }
    ]);

    var episodeGrid = new Ext.grid.GridPanel({
        id: 'episodeGrid',
        layout: 'fit',
        border: false,
        autoScroll: true,
        bodyStyle: 'width:99%',
        autoWidth: true,
        height: 300,
        store: store,
        cm: cm,
        sm: sm,
        viewConfig: {
            forceFit: true
        },
        frame: true,
        tbar: [
	        '就诊类型',
		    '-',
		    {
		        id: 'cboAdmType',
		        xtype: 'combo',
		        width: 60,
		        resizable: false,
		        valueField: 'returnValue',
		        displayField: 'displayText',
		        readOnly: true,
		        triggerAction: 'all',
		        mode: 'local',
		        store: comboStore,
		        value: admitType
		    },
		    {
		        id: 'txtArgDiagnosDesc',
		        emptyText: '诊断内容',
		        xtype: 'textfield',
		        width: 80
		    },
		    '-',
		    {
		        id: 'btnSearch',
		        text: '查询',
		        cls: 'x-btn-text-icon',
		        icon: '../scripts/epr/Pics/btnSearch.gif',
		        pressed: false,
		        handler: doSearch
		    },
		    '-',
		    {
		        id: 'btnConfirm',
	            text: '确定',
	            cls: 'x-btn-text-icon',
	            icon: '../scripts/epr/Pics/btnConfirm.gif',
	            pressed: false,
	            handler: doConfirm
		    }
	    ],
		bbar:
			new Ext.PagingToolbar({
				id: "pagToolbar",
				store: store,
				//pageSize: queryPageSize,
				pageSize:5,
				displayMsg:'共{2}条',
				beforePageText: '页码',
				afterPageText: '总页数 {0}',
				displayInfo: true,	
				firstText: '首页',
				prevText: '上 一页',
				nextText: '下一页',
				lastText: '末页',
				refreshText: '刷新',
				emptyMsg: "没有记录"
			})
    });

    return episodeGrid;
}

function getRefLogGridPanel() {
    var logStore = getRefLogStore();
    logStore.load();

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true,
        listeners: {
            'rowselect': function(record, index, e) {
                //debugger;
                //chkRefLogID = record.getSelected().get("ID");
                //alert(chkRefLogID);
            },
            'rowdblclick': function(cm, index, record) {
                //debugger;
            }
        }
    });

    var cm = new Ext.grid.ColumnModel([sm,
        { header: '<div style="text-align:center">标题</div>', dataIndex: 'Title', width: 200 },
        { header: '<div style="text-align:center">日期</div>', dataIndex: 'RefDate', width: 110 }
    ]);

    var logGrid = new Ext.grid.GridPanel({
        id: 'refLogGrid',
        layout: 'fit',
        title: '病历引用日志',
        border: false,
        store: logStore,
        cm: cm,
        sm: sm,
        autoScroll: true,
        bodyStyle: 'width:99%',
        autoWidth: true,
        height: 180,
        frame: true,
        stripeRows: true,
        viewConfig: {
            forceFit: true
        }
    });

    return logGrid;
}

var admitGrid = getAdmitGridPanel();
var refLogGrid = getRefLogGridPanel();

var tabPanel = new Ext.TabPanel({
    id: "tpMultiple",
    region: "center",
    activeTab: 0,
    deferredRender: true,
    items: [
        {
            id: 'tabEPRRecordList',
            title: '病历列表',
            region: "center",
            html: '<div style="width:100%;height:100%;OVERFLOW-y:auto;" id="divMultiRecord"><table style="width:100%;height:100%"><tr><td style="text-align:center;"><img src="../scripts/epr/Pics/eprListRecord.jpg"/></td></tr></table></div>'
        },
        {
            id: "tabEPRReference",
            title: '病历引用',
            html: '<div style="width:100%;height:100%;OVERFLOW-y:auto;" id="divTemplate"></div>'
        },
        {
            id: "tabEPRBrowse",
            title: '病历浏览',
            border: false,
            region: "center",
            layout: "fit",
            html: '<div style="width:100%;height:100%;OVERFLOW-y:auto;" id="divBrowser"></div>'
        }
    ]
});

var frmMainContent = new Ext.Viewport({
    id: "vpListReference",
    layout: "border",
    shim: false,
    animCollapse: false,
    constrainHeader: true,
    collapsible: false,
    margins: "0 0 0 0",
    border: false,
    items: [
	    {
	        id: "header",
	        region: "north",
	        height: 25,
	        frame: true,
	        border: false,
	        html: '<h2 style="text-align:center;height:100%;">病历引用向导</h2>'
	    },
	    {
	        id: "bottom",
	        region: "south",
	        height: 25,
	        items: new Ext.Toolbar({
	            border: false,
	            items: [
                    '->', '-',
		            { id: 'btnClose', text: '关闭', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/btnClose.gif', pressed: false, handler: doClose }
                ]
	        })
	    },
	    tabPanel,
	    {
	        id: "pnlWest",
	        region: "west",
	        layout: "border",
	        width: 330,
	        border: false,
	        title: '就诊信息',
	        split: true,
	        collapsible: true,
	        items: [
	            {
	                region: "north",
	                height: 300,
                    border: false,
                    items: admitGrid
	            },
	            {
	                region: "center",
	                border: false,
	                items: refLogGrid
	            }
	        ]
	    }
	]
});

var tpMultiple = Ext.getCmp("tpMultiple");
var activeTab = tpMultiple.getActiveTab();
tpMultiple.on('tabchange', function(tabpanel, panel) {
    if (panel.id == "tabEPRRecordList") {
        if (chkEpisodeID == "") {
            document.getElementById("divMultiRecord").innerHTML = '<table style="width:100%;height:100%"><tr><td style="text-align:center;"><img src="../scripts/epr/Pics/eprListRecord.jpg"/></td></tr></table>';
        }
    } else if (panel.id == "tabEPRReference") {
        if (chkEpisodeID == "") {
            document.getElementById("divTemplate").innerHTML = '<table style="width:100%;height:100%"><tr><td style="text-align:center;"><img src="../scripts/epr/Pics/eprListReference.jpg"/></td></tr></table>';
        }
    } else if (panel.id == "tabEPRBrowse") {
        if (chkEpisodeID != "") {
            Ext.getCmp('tabEPRBrowse').getEl().mask('载入数据,请稍候...', 'x-mask-loading');
            document.getElementById("divBrowser").innerHTML = '<iframe id="frmBrowse" style="width:100%; height:100%" src="dhc.epr.ref.recordbrowse.csp?EpisodeID=' + chkEpisodeID + '&PatientID=' + patientID + '&PrintTemplateDocID=' + prtTemplateDocID + '&AdmitType=' + chkAdmType + ' "></iframe>';
        } else {
            document.getElementById("divBrowser").innerHTML = '<table style="width:100%;height:100%"><tr><td style="text-align:center;"><img src="../scripts/epr/Pics/eprRefBrowser.jpg"/></td></tr></table>';
        }
    }
});

admitGrid.on('rowdblclick', function(g, index, e) {
    chkEpisodeID = g.getStore().getAt(index).data['EpisodeID'];
    var tpMultiple = Ext.getCmp("tpMultiple");
    var tabEPRRecordList = Ext.getCmp("tabEPRRecordList");
    tpMultiple.setActiveTab(tabEPRRecordList);
    
    //加载日常病程记录列表
    loadMultiRecordList();
});