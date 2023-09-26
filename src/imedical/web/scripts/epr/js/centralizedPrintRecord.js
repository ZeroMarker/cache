var eprPageSize = 20;

//打印记录******************************************

var store = new Ext.data.JsonStore({
	url: "../web.eprajax.CentralizedPrintRecord.cls",
    root: 'data',
    totalProperty: 'totalCount',
    fields: [
		{name: 'UserName'},
		{name: 'UserID'},
		{name: 'PatientID'},
		{name: 'RegisterNo'},
		{name: 'PatientName'},
		{name: 'StartDateTime'},
		{name: 'FinishDateTime'},
		{name: 'DescAll'}
	]
});
  
//数据加载异常
store.on('loadexception', function (proxy, options, response, e) {
	alert(response.responseText);
});

store.load({ params: { start: 0, limit: eprPageSize} });

var cm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(), 
	{header:'操作医师',dataIndex:'UserName',width:100},
	{header:'登记号',dataIndex:'RegisterNo',width:100},
	{header:'患者姓名',dataIndex:'PatientName',width:100},
	{header:'病人号',dataIndex:'PatientID',width:100},
	{header:'打印操作时间',dataIndex:'StartDateTime',width:150},
	{header:'打印完成时间',dataIndex:'FinishDateTime',width:150},
	{header:'打印项目',dataIndex:'DescAll',width:1000}
]);
   
function query(){
	var name = Ext.getCmp('Name').getValue();
	var regno = Ext.getCmp('RegNo').getValue();
	var s = Ext.getCmp('grid').getStore();
	var url = '../web.eprajax.CentralizedPrintRecord.cls?name=' + escape(name) +'&registerno='+regno;
	s.proxy.conn.url = url;
	s.load({
		params: {
			start: 0,
			limit: eprPageSize
		}
	});
}
   
var tbar = new Ext.Toolbar({
	border : false,
	items : [
	'姓名：',
	{
		xtype:'textfield',
		id:'Name',
		width:150,
		emptyText:'患者姓名'
	},
	'-',
	'登记号：',
	{
		xtype:'textfield',
		id:'RegNo',
		width:150,
		emptyText:'登记号'
	},
	'-',
	{
		xtype: 'button',
		id : 'btnQuery',
		text:'查询',
		handler: query
	}]
});
    
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
	tbar:tbar,
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

