
var eprPageSize = 30;
var AdmStatus = "", startDate = "", endDate = "",medicareNo = "",locID="";
var eprEpisodeStore = new Ext.data.JsonStore({
    url: '../web.eprajax.eprepisodelistFS.cls?StartDate=' + startDate + '&EndDate=' + endDate+ '&MedicareNo=' + medicareNo+ '&ALocID=' + locID,
    root: 'data',
    totalProperty: 'totalCount',
    fields: [
        { name: 'PatientID' },
        { name: 'EpisodeID' },
		{ name: 'MedicareNo'},
        { name: 'PAPMIName' },
        { name: 'PAPMIDOB' },
        { name: 'PAPMISex' },
        { name: 'ManualFlag'},
        { name: 'OutManualFlag'},
        { name: 'MessageFlag'},
        { name: 'ProblemFlag'},
        { name: 'EprDocStatusDesc' },
        { name: 'EstimDischDate' },
        { name: 'EprNurStatusDesc' },
        { name: 'EprPdfStatusDesc' },
        { name: 'StatusDesc' },
        { name: 'PAAdmDepCodeDR' },
        { name: 'MainDiagnos' },
        { name: 'AdmDateTime' },
		{ name: 'PAAdmDocCodeDR' },
		{ name: 'CreateOutUser' },
		{ name: 'Illness' },
		{ name: 'BedNo' }
    ]
});
eprEpisodeStore.load({ params: { start: 0, limit: eprPageSize} });
var sm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
var cm = new Ext.grid.ColumnModel([
	sm,
    { header: '<div style="text-align:center">病人姓名</div>', dataIndex: 'PAPMIName', align: 'center', width: 100 },
	{ header: '<div style="text-align:center">出生日期</div>', dataIndex: 'PAPMIDOB', align: 'center' },
    { header: '<div style="text-align:center">性别</div>', dataIndex: 'PAPMISex', align: 'center', width: 100 },
	{ header: '门诊质控', width: 90, dataIndex: '', sortable: false, menuDisabled:true, align: 'center'
	,renderer : function(v, m, rd, r, c, s){
			var MessageFlag  = rd.get("MessageFlag");
			if (MessageFlag !=0){
				return "<img height='15' src='../scripts/emr/image/icon/forbid.png'/>";
				//m.attr = 'style="background:#FF5151;"';
			}
			return v;
		}
	},
	{ header: '<div style="text-align:center">质控医生</div>', dataIndex: 'CreateOutUser', sortable: true ,width: 150, align: 'center' },
	{ header: '就诊时间', width: 100, dataIndex: 'AdmDateTime', sortable: false, menuDisabled:true, align: 'center'},
    { header: '<div style="text-align:center">诊断</div>', dataIndex: 'MainDiagnos',width: 130 , align: 'center'},
    { header: '<div style="text-align:center">主管医生</div>', dataIndex: 'PAAdmDocCodeDR', align: 'center', width: 80, align: 'center' }
   
]);
var getLocStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.GetQualityDicList.cls',
	fields: ['ID', 'Name'],
	root: 'data',
	totalProperty: 'TotalCount',
	//baseParams: { AdmStatus:"A"},
	listeners: {
		'beforeload': function() {
			var txtValueText = Ext.getCmp("cbxLoc").getRawValue();
			getLocStore.baseParams = {AdmStatus:"O",DicQuery: txtValueText};
		}
	}
})
var getDocStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.GetQualityDicList.cls',
	fields: ['UserID', 'UserDesc'],
	root: 'data',
	totalProperty: 'TotalCount'
})

var eprEpisodeGrid = new Ext.grid.GridPanel({
    id: 'eprEpisodeGrid',
    layout: 'fit',
    border: false,
    store: eprEpisodeStore,
    cm: cm,
    sm: sm,
    viewConfig: { forceFit: true },
    autoScroll: true,
    frame: true,
    stripeRows: true,
		keys:[{
		key: Ext.EventObject.ENTER,
		scope:this,
		fn: EnterEvent
	}],
	tbar: new Ext.Toolbar({
		id: 'treeTbar1',
		autoWidth: true,
		items: [
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'科室',
		{
				id: 'cbxLoc',
				name: 'cbxLoc',
				xtype: 'combo',
				fieldLabel: '科室',
				minChars: 1,
				store:getLocStore,
				displayField: 'Name',
				valueField: 'ID',
				triggerAction: 'all',
				selectOnFocus: true,
				emptyText: '请选择患者科室',
				listWidth: 240,
				//pageSize: 12,
				mode : 'remote'
			},
			'-',
		'医生',
		{
				id: 'cbxDoc',
				name: 'cbxDoc',
				xtype: 'combo',
				fieldLabel: '医生',
				minChars: 1,
				store:getDocStore,
				displayField: 'UserDesc',
				valueField: 'UserID',
				triggerAction: 'all',
				selectOnFocus: true,
				emptyText: '请选择患者医生',
				listWidth: 240,
				//pageSize: 12,
				mode : 'remote',
				listeners:{
					'expand' : function(){
						//alert(action);
						getDocStore.removeAll();
						var Locid = Ext.getCmp("cbxLoc").getValue();
						getDocStore.baseParams = {Action:"GetUserID",AdmStatus:"O",LocId:Locid};
						getDocStore.load();
					}
				}
			},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'开始日期',
		{
		    id: 'dtStartDate',
		    xtype: 'datefield',
		    fieldLabel: '开始日期',
		    format: 'Y-m-d',
		    width: 165,
		    lableWidth: 165,
		    labelAlign: 'right',
		    readOnly: false,
		    emptyText: '开始日期'
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		
		'-',
		'结束日期',
		{
		    id: 'dtEndDate',
		    xtype: 'datefield',
		    fieldLabel: '结束日期',
		    format: 'Y-m-d',
		    width: 165,
		    lableWidth: 165,
		    labelAlign: 'right',
		    readOnly: false,
		    emptyText: '结束日期'
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		{
		    id: 'btnSearch',
		    text: '查找',
		    cls: 'x-btn-text-icon',
		    icon: '../scripts/epr/Pics/btnSearch.gif',
		    pressed: false,
		    handler: doSearch
		}]
	}),
    bbar: new Ext.PagingToolbar({
        id: "eprPagingToolbar",
        store: eprEpisodeStore,
        pageSize: eprPageSize,
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
    }),
    viewConfig: {
        'getRowClass': function(record,rowindex,rowParams,store){
                  if(record.data.OutManualFlag == 'Y' ){ 
                         return 'x-grid-record-yellow';
                  }
            }},
    	listeners: {
        'render': function(){
                treeTbar2.render(this.tbar);
		},
		'rowdblclick':function(grid,rowindex,e){
	             goEPRPDF(grid, rowindex, e);
        }
    }
});

var treeTbar2 = new Ext.Toolbar({
	id: 'treeTbar2',
	autoWidth: true,
    items: [
     '->',
    	{
		    id: 'btnSearch',
		    text: '取消手工质控',
		    cls: 'x-btn-text-icon',
		    pressed: false,
		    handler: CancelManualFlag
		},
		'->','-'
	]
});

var eprPortal = new Ext.Viewport({
    id: 'patientListPort',
    layout: 'border',
    border: false,
    margins: '0 0 0 0',
    shim: false,
    collapsible: true,
    animCollapse: false,
    constrainHeader: true,
	items: [{ 
		title:"门诊质控查询",  
    	border: false,region: "center", layout: "border",
		items: [{ 
			border: false,id: 'episodelist',region: "center", layout: "fit", items:eprEpisodeGrid
		}]
	}]
});


function CancelManualFlag() {
	var selections = eprEpisodeGrid.getSelectionModel().getSelections();
	if (selections.length == 0) 
	{
			alert("请选择患者");
			return;
	}
	var record = selections[0];
	var EpisodeID = record.get("EpisodeID");
	var SignUserID = userID
	Ext.Ajax.request({
		url: '../web.eprajax.EPRSetManualFlag.cls',
		params: {EpisodeID:EpisodeID,SignUserID:SignUserID,Action:"Cancel",Status:"O"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret ==1 )
			{
				alert("取消成功！");
				doSearch();
			}
		}
	}) 		
}
function EnterEvent() {
	var btnobj=document.getElementById('btnSearch');
		btnobj.click();
}

function doSearch() { 
    //debugger;
	var AdmStatus = "O"
	var startDate = Ext.getCmp('dtStartDate').getRawValue();
	var endDate = Ext.getCmp('dtEndDate').getRawValue();
	if (startDate>endDate)
	{
		alert("开始日期不能大于结束日期！");
		return;
	}
	var locID = Ext.getCmp('cbxLoc').getValue();
	//if (((startDate=="")||(endDate==""))&&(medicareNo==""))
	if (((startDate=="")||(endDate==""))||(locID==""))
	{
		alert("请输入科室开始和结束时间作为查询条件！");
		return;
	}
	var docID = Ext.getCmp('cbxDoc').getValue();
    Ext.getCmp('eprEpisodeGrid').getEl().mask('数据重新加载中，请稍等');
    var s = Ext.getCmp('eprEpisodeGrid').getStore();
    var url = '../web.eprajax.eprepisodelistFS.cls?AdmStatus=' + AdmStatus + '&StartDate=' + escape(startDate) + '&EndDate=' + escape(endDate) + '&ALocID=' + locID + '&ADocID=' + docID;
    s.proxy.conn.url = url;
    s.load({ params: { start: 0, limit: eprPageSize} });
    s.on('load', function(store, record) {
        //debugger;
        Ext.get('eprEpisodeGrid').unmask();
    });
    s.on('loadexception', function(proxy, options, response, e) {
        //debugger;
        Ext.get('eprEpisodeGrid').unmask();
    });
}
function goEPRPDF(grid, rowindex, e) {
    //debugger;
    var record = grid.getStore().getAt(rowindex);
    var episodeID = record.get("EpisodeID");
    var action = "O"
        var win = new Ext.Window({
            id: 'winBrowse',
            layout: 'fit', 	//自动适应Window大小 
            title: '患者病历',
            frame: true,
            width: 1200,
            height: 640,
            shim: false,
            animCollapse: false,
            constrainHeader: true,
            resizable: true,
            modal: true,
            maximizable: true,
            raggable: true, //不可拖动
            items: [
		        {
		            html: '<iframe id="eprWrite" scrolling="no" frameborder="0" style="width:100%; height:100%;" src="dhc.epr.quality.checkrule.csp?EpisodeID=' + episodeID + '&action=' + action +'"></iframe>'
		        }
	        ]
        });
        win.show();
		win.maximize();
}