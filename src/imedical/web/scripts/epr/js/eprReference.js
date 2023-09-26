Ext.QuickTips.init();

var isTreeRefresh = false;
var isPageRefresh = false;

function getAdmitGridPanel() {
    var store = getEpisodeStore();
    //store.load();
	store.load({ params: { start: 0, limit: 5} });

    var sm = new Ext.grid.CheckboxSelectionModel({
        singleSelect: true,
        listeners: {
            'rowselect': function(record, index, e) {
                chkAdmType = admitGrid.getStore().getAt(index).data['AdmType'];
                chkAdmDate = admitGrid.getStore().getAt(index).data['AdmDate'];
                chkAdmTime = admitGrid.getStore().getAt(index).data['AdmTime'];
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
        height: 160,
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
		        forceSelection: true,
		        selectOnFocus: true,
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
                //选中对象触发的事件
                //chkRefLogID = record.getSelected().get("ID");
            },
            'rowdblclick': function(cm, index, record) {
                //alert("rowdbclicked!");
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
        height: 105,
        frame: true,
        stripeRows: true,
        viewConfig: {
            forceFit: true
        }
    });

    return logGrid;
}

var Tree = Ext.tree;
var loader = new Tree.TreeLoader({
    requestMethod: "GET",
    dataUrl: "../web.eprajax.reference.refeprtree.cls"
});

loader.on("beforeload", function(treeloader, node) {
    treeloader.baseParams.NewEpisodeID = episodeID;
    treeloader.baseParams.OldEpisodeID = chkEpisodeID;
    treeloader.baseParams.PrintTemplateDocID = prtTemplateDocID;
}, this);

loader.on("load", function(treeloader, node, response) {
    //debugger;
});

//add by YHY 2013-12-11 默认展开选中树节点 
function nodeExpandCallBack(node) 
{
	var nodeID = node.id;
	var childNodes = node.childNodes;
	if (node.attributes.checked == true || node.id == "RT0")
	{
	   for (var j = 0; j < childNodes.length; j++)
	   {
			if (childNodes[j].attributes.checked == true && childNodes[j].isLeaf() == false)
			{
				childNodes[j].expand(false, true, nodeExpandCallBack);
			}
	   }   
	}
	
}

loader.on("loadexception", function(tree, node, response) {
    //debugger;
    var obj = response.responseText;
    alert(obj);
});

var tree = new Tree.TreePanel({
    id: "eprRefTree",
    title: '病历引用树',
    rootVisible: false,
    autoScroll: true,
    trackMouseOver: false,
    animate: false,
    containerScroll: true,
    bodyStyle: 'padding: 0 5px 5px 0',
    lines: true,
    height: 210,
    frame: true,
    checkModel: 'cascade',
    border: true,
    loader: loader
});

var rootNode = new Tree.AsyncTreeNode({
    id: "RT0",
    nodeType: 'async',
    draggable: false
});

tree.on("checkchange", function(node, checked) {
    //debugger;
    node.attributes.checked = checked;
    node.eachChild(function(child) {
        if (!child.attributes.disabled) {
            child.ui.toggleCheck(checked);
            child.attributes.checked = checked;
            child.fireEvent('checkchange', child, checked);
        }
    });
}, tree);

tree.setRootNode(rootNode);
rootNode.expand(true);

var admitGrid = getAdmitGridPanel();
var refLogGrid = getRefLogGridPanel();

var tpSingle = new Ext.TabPanel({
    id: "tpSingle",
    region: "center",
    activeTab: 0,
    deferredRender: true,
    items: [
        {
            id: "tabEPRReference",
            title: '病历引用',
            border: false,
            html: '<div id="divReference" style="width:100%;height:100%;text-align:center;"><table style="width:100%;height:100%"><tr><td style="text-align:center;"><img src="../scripts/epr/Pics/eprReference.jpg"/></td></tr></table></div><div id="divEditorDll"><iframe id="frameWholeTemplate" src="dhc.epr.ref.loadtemplate.csp?Refresh=0&LoadType=Single&EpisodeID=' + episodeID + '&InstanceID=' + instanceID + '&TemplateDocID=' + templateDocID + '"></iframe></div>',
            tbar: [
                '->',
                '-',
                { id: 'btnWholeReference', text: '全部引用', cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/btnAllReference.gif', pressed: false, listeners: { 'click': function() { doWholeReference(); } } },
                '-',
                { id: 'btnBatchReference', text: '分步引用', cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/btnStepReference.gif', pressed: false, listeners: { 'click': function() { doBatchReference(); } } }
            ]
        },
        {
            id: "tabEPRBrowse",
            title: '病历浏览',
            border: false,
            html: '<div style="width:100%;height:100%;OVERFLOW-y:auto;" id="divBrowser"></div>'
        }
    ]
});

var tpSingle = Ext.getCmp("tpSingle");
var activeTab = tpSingle.getActiveTab();
tpSingle.on('tabchange', function(tabpanel, panel) {
    if (panel.id == "tabEPRReference") {
        if (chkEpisodeID == "") {
            document.getElementById("divReference").innerHTML = '<table style="width:100%;height:100%"><tr><td style="text-align:center;"><img src="../scripts/epr/Pics/eprReference.jpg"/></td></tr></table>';
        }
    }
    if (panel.id == "tabEPRBrowse") {
        if (chkEpisodeID != "") {
            Ext.getCmp('tabEPRBrowse').getEl().mask('载入数据,请稍候...', 'x-mask-loading');
            document.getElementById("divBrowser").innerHTML = '<iframe id="frmBrowse" style="width:100%; height:100%" src="dhc.epr.ref.recordbrowse.csp?EpisodeID=' + chkEpisodeID + '&PatientID=' + patientID + '&PrintTemplateDocID=' + prtTemplateDocID + '&AdmitType=' + chkAdmType + ' "></iframe>';
        } else {
            document.getElementById("divBrowser").innerHTML = '<table style="width:100%;height:100%"><tr><td style="text-align:center;"><img src="../scripts/epr/Pics/eprRefBrowser.jpg"/></td></tr></table>';
        }
    }
});

var frmMainContent = new Ext.Viewport({
    id: "vpReference",
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
		            { id: 'btnClose', text: '关闭', handleMouseEvents: false, cls: 'x-btn-text-icon', icon: '../scripts/epr/Pics/btnClose.gif', pressed: false, listeners: { 'click': function() { doClose(isTreeRefresh, isPageRefresh); } } }
                ]
            })
	    },
	    tpSingle,
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
	                height: 160,
	                border: false,
	                items: admitGrid
	            },
	            {
	                id: "refTree",
	                region: "center",
	                border: false,
	                items: tree
	            },
	            {
	                id: "itemRefLog",
	                region: "south",
	                border: false,
	                height:105,
	                items: refLogGrid
	            }
	        ]
	    }
	]
});