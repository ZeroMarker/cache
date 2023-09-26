
var eprPageSize = 100;
var AdmStatus = "", startDate = "", endDate = "",medicareNo = "",locID="", specialAdm = "";
var eprEpisodeStore = new Ext.data.JsonStore({
    url: '../web.eprajax.eprepisodelistFS.cls?AdmStatus=' + AdmStatus + '&StartDate=' + startDate + '&EndDate=' + endDate+ '&MedicareNo=' + medicareNo+ '&ALocID=' + locID + '&SpecialAdm=' + specialAdm,
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
        { name: 'DisManualFlag'},
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
		{ name: 'CreateAdmUser' },
		{ name: 'Illness' },
		{ name: 'QualityFlag' },
		{ name: 'DeathDate' },
		{ name: 'InPathWayStatus' },
		{ name: 'Attending' },
		{ name: 'Chief' },
		{ name: 'BedNo',type:'number' }
    ]
});

eprEpisodeStore.load({ params: { start: 0, limit: eprPageSize} });
eprEpisodeStore.on('beforeload', function(store, options) {
        //debugger;
        var params = {
	        MedicareNo : Ext.getCmp('txtMedicareNo').getValue(),
			AdmStatus : "D" ,
			StartDate : Ext.getCmp('dtStartDate').getRawValue(),
			EndDate : Ext.getCmp('dtEndDate').getRawValue(),
			ALocID : Ext.getCmp('cbxLoc').getValue(),
			SpecialAdm : Ext.getCmp('cboAdm').getValue(),
			start: 0, limit: eprPageSize
	        };
	     eprEpisodeStore.baseParams = params
	    //Ext.apply(store.proxy.extraParams, params);
        //Ext.get('eprEpisodeGrid').unmask();
    });
var sm = new Ext.grid.CheckboxSelectionModel({handleMouseDown: Ext.emptyFn});
var cm = new Ext.grid.ColumnModel([
	sm,
	{ header: '<div style="text-align:center">病案号</div>', dataIndex: 'MedicareNo', align: 'center', width: 100  },
    { header: '<div style="text-align:center">病人姓名</div>', dataIndex: 'PAPMIName', align: 'center', width: 100 
    ,renderer : function(v, m, rd, r, c, s){
			var DeathDate  = rd.get("DeathDate");
			if (DeathDate !=""){
				//m.attr = 'style="background:#FF5151;"';
				m.attr = 'style="color:#FF0033;font-weight:bold;"';
			}
			return v;
		}
    },
	{ header: '<div style="text-align:center">出生日期</div>', dataIndex: 'PAPMIDOB', align: 'center', width: 100  },
    { header: '<div style="text-align:center">性别</div>', dataIndex: 'PAPMISex', align: 'center', width: 100 },
	{ header: '入院时间', width: 100, dataIndex: 'AdmDateTime', sortable: false, menuDisabled:true, align: 'center'},
	{ header: '出院时间', width: 100, dataIndex: 'EstimDischDate', sortable: false, menuDisabled:true, align: 'center'},
    { header: '<div style="text-align:center">诊断</div>', dataIndex: 'MainDiagnos',width: 130 , align: 'center'},
    { header: '<div style="text-align:center">经治医生</div>', dataIndex: 'PAAdmDocCodeDR', align: 'center', width: 100, align: 'center' },
    { header: '<div style="text-align:center">床号</div>',dataIndex: 'BedNo', align: 'center', width: 100, align: 'center' }
     //{ header: '<div style="text-align:center">分数</div>', dataIndex: 'DisScore', align: 'center', width: 80, align: 'center' }
]);
var getLocStore = new Ext.data.JsonStore({
	autoLoad: false,
	url: '../web.eprajax.query.getDicList.cls',
	fields: ['ID', 'DicAlias', 'DicCode', 'DicDesc'],
	root: 'data',
	totalProperty: 'TotalCount',
	baseParams: { start: 0, limit: 12},
	listeners: {
		'beforeload': function() {
			var txtValueText = Ext.getCmp("cbxLoc").getRawValue();
			getLocStore.baseParams = { DicCode: 'S07', DicQuery: txtValueText};
		}
	}
})

var eprEpisodeGrid = new Ext.grid.GridPanel({
    id: 'eprEpisodeGrid',
    layout: 'fit',
    border: false,
    store: eprEpisodeStore,
    cm: cm,
    sm: sm,
    viewConfig: { forceFit: true ,scrollOffset: 0},
    autoScroll: true,
    frame: true,
    stripeRows: false,
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
				displayField: 'DicDesc',
				valueField: 'DicCode',
				triggerAction: 'all',
				selectOnFocus: true,
				emptyText: '请选择患者科室',
				listWidth: 240,
				pageSize: 12,
				mode : 'remote'
			},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',	
		'病案号',
		{
		    id: 'txtMedicareNo',
		    xtype: 'textfield',
		    fieldLabel: '病案号',
		    emptyText: '病案号',
		    width: 80
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'开始日期',
		{
		    id: 'dtStartDate',
		    xtype: 'datefield',
		    fieldLabel: '开始日期',
		    format: 'Y-m-d',
		    width: 135,
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
		    width: 135,
		    lableWidth: 165,
		    labelAlign: 'right',
		    readOnly: false,
		    emptyText: '结束日期'
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		'重点患者',
		{
			id:'cboAdm',
			name: 'cboAdm',
			width:120,
			resizable: false,
			xtype : 'combo',
			fieldLabel: '重点患者',
			valueField: 'returnValue',
			displayField: 'displayText',
			//readOnly: true,
			triggerAction : 'all', 
			selectOnFocus: true,
			emptyText: '请选择...',
			mode: 'local',
			store: new Ext.data.SimpleStore({
				fields:['returnValue','displayText'],
				data:[['OverAdm','住院超过31天患者'],['Death','死亡患者'],['TerminallyIll','病危患者'],['DiseaseSeve','病重患者']]
			})
		},
		{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},{xtype:'tbspacer'},
		'-',
		{
		    id: 'btnSearch',
		    text: '查找',
		    cls: 'x-btn-text-icon',
		    icon: '../scripts/epr/Pics/browser.gif',
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
                  if(record.data.DisManualFlag == 'Y' ){ 
                         return 'x-grid-record-yellow';
                  }
            }},
 		listeners: {
        'render': function(){
                treeTbar2.render(this.tbar);
		}}
	});
var treeTbar2 = new Ext.Toolbar({
	id: 'treeTbar2',
	autoWidth: true,
    items: [
    	'->',
    	{
		    id: 'btnOpen',
		    text: '解除封锁',
		    cls: 'x-btn-text-icon',
		    icon: '../Image/icons/lock_open.png',
		    pressed: false,
		    handler: doOpen
		},
    	'->',
    	{
		    id: 'btnLock',
		    text: '封锁病历',
		    cls: 'x-btn-text-icon',
		    icon: '../Image/icons/lock.png',
		    pressed: false,
		    handler: doLock
		}
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
		title:"出院患者查询", 
    	border: false,region: "center", layout: "border",
		items: [{ 
			border: false,id: 'episodelist',region: "center", layout: "fit", items:eprEpisodeGrid
		}]
	}]
});


function doLock() {
	var selections = eprEpisodeGrid.getSelectionModel().getSelections();
	if (selections.length == 0) 
	{
			alert("请选择患者");
			return;
	}
	var record = selections[0];
	var EpisodeID = record.get("EpisodeID");
	var UserID = userID
	Ext.Ajax.request({
		url: '../web.eprajax.lockpatiet.cls',
		params: {EpisodeID:EpisodeID,UserID:UserID,AllLock:1,Action:"SetData"},
		success: function(response, options){
			var ret = response.responseText;
			if (ret ==1 )
			{
				alert("封锁成功！");
			}
		}
	}) 		
}
function EnterEvent() {
	var btnobj=document.getElementById('btnSearch');
		btnobj.click();
}
function doOpen()
{
	window.open("dhc.epr.quality.disopenlock.csp"); 
}

function doSearch() { 
    //debugger;
	var medicareNo = Ext.getCmp('txtMedicareNo').getValue();
	var AdmStatus = "D" ;
	var startDate = Ext.getCmp('dtStartDate').getRawValue();
	var endDate = Ext.getCmp('dtEndDate').getRawValue();
	var locID = Ext.getCmp('cbxLoc').getValue();
	var specialAdm = Ext.getCmp('cboAdm').getValue();
	if ((((startDate=="")||(endDate==""))&&(medicareNo==""))&&((locID=="")))
	{
		alert("请输入病案号或开始和结束时间作为查询条件！");
		return;
	}
    Ext.getCmp('eprEpisodeGrid').getEl().mask('数据重新加载中，请稍等');
    var s = Ext.getCmp('eprEpisodeGrid').getStore();
    var url = '../web.eprajax.eprepisodelistFS.cls?AdmStatus=' + AdmStatus + '&StartDate=' + escape(startDate) + '&EndDate=' + escape(endDate) + '&MedicareNo=' + medicareNo + '&ALocID=' + locID + '&SpecialAdm=' + specialAdm;
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

