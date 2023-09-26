
//Status toolbar
var tbarPatientInfo = new Ext.Toolbar({
	items:[
	{
		id:'tbarPatientInfo',
		pressed:false,
		handleMouseEvents:false,
		enable:false,
		text:patientInfo
	}]
});

var store = new Ext.data.JsonStore({
	url: '../web.eprajax.stat.RecordList.cls?Action=getsingle&EpisodeID=' + episodeID,
	fields: [
		{name: 'Count',type: 'int'}, 
		{name: 'Name'}, 
		{name: 'Status'}, 
		{name: 'CreateUser'}, 
		{name: 'CreateDateTime'}, 
		{name: 'SignInfo'}
	],
	sortInfo: {
		field: 'Count',
		direction: "ASC"
	}
});

//数据加载异常
store.on('loadexception', function (proxy, options, response, e) {
	//debugger;
	alert(response.responseText);
});

store.load();

var sm = new Ext.grid.RowSelectionModel({ singleSelect: true });

var cm = new Ext.grid.ColumnModel([
	{header: "序号", width: 50, sortable: true, dataIndex: 'Count'},
	{header: "病历名称", width: 150, sortable: true, dataIndex: 'Name'},
	{header: "当前状态", width: 150, sortable: true, dataIndex: 'Status'},
	{header: "创建者", width: 100, sortable: true, dataIndex: 'CreateUser'},
	{header: "创建日期时间", width: 200, sortable: true, dataIndex: 'CreateDateTime'},
	{header: "签名信息", width: 150, sortable: true, dataIndex: 'SignInfo'}
]);

var grid = new Ext.grid.GridPanel({
	store: store,
	sm:sm,
	cm: cm,
	width: 600,
	height: 500,
	autoExpandColumn:5,
	//collapsible: true,
	animCollapse: false,
	title: '唯一模版',
	iconCls: 'icon-grid'
});

var storeMultiple = new Ext.data.JsonStore({
	url: '../web.eprajax.stat.RecordList.cls?Action=getmultiple&EpisodeID=' + episodeID,
	fields: [
		{name: 'Count',type: 'int'}, 
		{name: 'PrintDocID'}, 
		{name: 'Status'}, 
		{name: 'Name'}
	],
	sortInfo: {
		field: 'Count',
		direction: "ASC"
	}
});

//数据加载异常
storeMultiple.on('loadexception', function (proxy, options, response, e) {
	//debugger;
	alert(response.responseText);
});

storeMultiple.load();

// row expander
var expander = new Ext.grid.RowExpander({
	tpl : new Ext.XTemplate(
        '<div class="detailGrid">',
        '',
        '</div>'
	)
});

var smMultiple = new Ext.grid.RowSelectionModel({ singleSelect: true });

var cmMultiple = new Ext.grid.ColumnModel([
	expander,
	{header: "序号", width: 50, sortable: true, dataIndex: 'Count'},
	{header: "病历名称", width: 150, sortable: true, dataIndex: 'Name'},
	{header: "病历ID", width: 100, sortable: true, dataIndex: 'PrintDocID'},
	{header: "当前状态", width: 150, sortable: true, dataIndex: 'Status'}
]);

var gridMultiple = new Ext.grid.GridPanel({
	id: 'gridMultiple',
	store: storeMultiple,
	sm:smMultiple,
	cm: cmMultiple,
	width: 600,
	height: 300,
	autoExpandColumn:4,
	plugins: expander,
	//collapsible: true,
	animCollapse: false,
	iconCls: 'icon-grid',
	title: '可重复模版'
});

expander.on("expand",function(expander,r,body,rowIndex){
	//查找 grid
	var PrintDocID = Ext.getCmp('gridMultiple').getStore().getAt(rowIndex).data['PrintDocID'];

	var storeMultipleDetail = new Ext.data.JsonStore({
		url: '../web.eprajax.stat.RecordList.cls?Action=getmultipledetail&EpisodeID=' + episodeID +'&EPRDocID=' + PrintDocID,
		fields: [
			{name: 'Count',type: 'int'}, 
			{name: 'Name'}, 
			{name: 'Status'}, 
			{name: 'CreateUser'}, 
			{name: 'CreateDateTime'}, 
			{name: 'SignInfo'}
		],
		sortInfo: {
			field: 'Count',
			direction: "ASC"
		}
	});
		
	//数据加载异常
	storeMultipleDetail.on('loadexception', function (proxy, options, response, e) {
		//debugger;
		alert(response.responseText);
	});
		
	storeMultipleDetail.load();
		
	var smMultipleDetail = new Ext.grid.RowSelectionModel({ singleSelect: true });
		
	var cmMultipleDetail = new Ext.grid.ColumnModel([
		{header: "序号", width: 50, sortable: true, dataIndex: 'Count'},
		{header: "病历名称", width: 150, sortable: true, dataIndex: 'Name'},
		{header: "当前状态", width: 150, sortable: true, dataIndex: 'Status'},
		{header: "创建者", width: 100, sortable: true, dataIndex: 'CreateUser'},
		{header: "创建日期时间", width: 200, sortable: true, dataIndex: 'CreateDateTime'},
		{header: "签名信息", width: 150, sortable: true, dataIndex: 'SignInfo'}
	]);
		
	var gridMultipleDetail = new Ext.grid.GridPanel({
		store:storeMultipleDetail,
		sm:smMultipleDetail,
		cm:cmMultipleDetail,
		autoWidth:true,
		autoHeight:true,
		autoExpandColumn:5,
		renderTo:Ext.DomQuery.select("div.detailGrid",body)[0],		
		listeners:{
			//去除选中子表同时选中上层表格中的行
			mouseover: function(e){
        		e.stopEvent();
			},
			rowmousedown: function(g, r, e){
        		e.stopEvent();
			}
		}
	});
});

//view******************************************
var view = new Ext.Viewport({
	id: 'viewPort',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	collapsible: true,
	margins:'0 0 0 0',           
	layout: "border",  
	border: false,              
	items: [{
		border:true,
		region:'north',
		layout:'fit',
		height: 30,
		bodyStyle:'padding:0px 0px 0px 0px',
		items:tbarPatientInfo
	},{
        border:true,
		region:'center',
		layout:'fit',
		bodyStyle:'padding:0px 0px 0px 0px',
		split: true,
		collapsible: true,  
		items:grid   
	},{
        border:true,
		region:'south',
		layout:'fit',
		height: 200,
		bodyStyle:'padding:0px 0px 0px 0px',
		split: true,
		collapsible: true,  
		items:gridMultiple    
	}]
});