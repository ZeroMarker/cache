var eprPageSize = 20;
var papmiNo = "",patientName = "";
//打印记录******************************************

var store = new Ext.data.JsonStore({
	url: "../web.eprajax.onestepprintrecord.cls",
    root: 'data',
    totalProperty: 'totalCount',
    fields: [
		{name: 'UserName'},
		{name: 'UserID'},
		{name: 'UserCTLoc'},
		{name: 'PatientID'},
		{name: 'PatientName'},
		{name: 'FinishDateTime'},
		{name: 'EpisodeID'},
		{name: 'PrintTempName'},
		{name: 'PAAdmDate'},
		{name: 'PADischgeDate'}
	]
	,
	listeners: {
		'beforeload': function() {
			papmiNo = Ext.getCmp('txtPatientNo').getValue();
			patientName = Ext.getCmp('txtPatientName').getValue();
			store.removeAll();
			store.baseParams = { papmiNo: papmiNo, patientName: patientName};
		}
	}
});
  


var cm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(), 
	{header:'操作医师',dataIndex:'UserName',width:100},
	{header:'操作医师科室',dataIndex:'UserCTLoc',width:100},
	{header:'患者姓名',dataIndex:'PatientName',width:100},
	{header:'病人号',dataIndex:'PatientID',width:100},
	{header:'入院日期',dataIndex:'PAAdmDate',width:100},
	{header:'出院日期',dataIndex:'PADischgeDate',width:100},
	{header:'打印完成时间',dataIndex:'FinishDateTime',width:150},
	{header:'打印项目',dataIndex:'PrintTempName',width:1000}
]);
    
var grid = new Ext.grid.GridPanel({
	id:'grid',
	store:store,
	cm:cm,
	autoScroll:true,
	containerScroll:true,
	stripeRows: true,
	frame:true,
	loadMask:true,
	forceFit:true,
	tbar: new Ext.Toolbar({
		id: 'treeTbar',
		autoWidth: true,
		items: [
			'-',
			'登记号',
			{
				id: 'txtPatientNo',
				xtype: 'textfield',
				fieldLabel: '登记号',
				emptyText: '登记号',
				width: 100
			},
			'-',
			'患者姓名',
			{
				id: 'txtPatientName',
				xtype: 'textfield',
				fieldLabel: '患者姓名',
				emptyText: '患者姓名',
				width: 120
			},
			'-',
			//'->',
			{
				id: 'btnSearch',
				text: '查询',
				cls: 'x-btn-text-icon',
				icon: '../scripts/epr/Pics/btnSearch.gif',
				pressed: false,
				handler: doSearch
			},
			'-'
		]
	}),
	bbar: new Ext.PagingToolbar({
        id: "eprPagingToolbar",
        store: store,
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
    })
}); 

//view******************************************
var view = new Ext.Viewport({
	id: 'printRecordViewPort',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	collapsible: true,
	margins:'0 0 0 0',           
	layout: "border",  
	border: false,   
		items: [{
		border:false,
		region:'center',
		layout:'fit',
		split: true,
		collapsible: true,  
		width:310,
		items:grid
	}]
});

//数据加载异常
store.on('loadexception', function (proxy, options, response, e) {
	alert(response.responseText);
});

store.load({ params: { start: 0, limit: eprPageSize} });

function doSearch() {
	store.load({ params: { start: 0, limit: eprPageSize} });
}
