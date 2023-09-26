
var schemeID = new Ext.getCmp('currentSchemeID');

//toolbar***********************************
//方案表格toolbar
var tbarGrid = new Ext.Toolbar({
	items:[
	{
		//记录当前方案的id
		xtype:'hidden',
		id:'currentSchemeID',
		value:''
	},
	{
		xtype: 'button',
		id : 'btnDefaultScheme',
		text:'设为当前打印方案',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/ok.gif',
		handler: setDefaultScheme
	},
	'-',
	{
		xtype:'button',
		text:'返回',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/back.gif',
		handler:moveBack
	}]
});

//方案编辑表格***********************************
//方案表格
var schemeID = ""
var schemeEditStore = new Ext.data.JsonStore({
	url:'../web.eprajax.CentralizedPrintScheme.cls?Action=loaddefault&EpisodeID='+ episodeID + '&UserID=' + userID,
    fields: [
		{name: 'id'},
		{name: 'text'},
		{name: 'detailInfo'},
		{name: 'order',type:'int'}
	],
	sortInfo: {field: 'order', direction: "ASC" },
	listeners : {  
		load : function() {  
			var records = new Array();  
			Ext.getCmp('schemeEditGrid').getStore().each(function(record) {  
				for (var i=0;i<recordIds.length;i++){
					if(recordIds[i]==record.data.id){
						records.push(record);  
					}
				}
			});  
			Ext.getCmp('schemeEditGrid').getSelectionModel().selectRecords(records,true);
		}  
	}  
});
    
//数据加载异常
schemeEditStore.on('loadexception', function (proxy, options, response, e) {
	alert(response.responseText);
});

schemeEditStore.load();

var schemeEditCM = new Ext.grid.ColumnModel([
	{header:'序号',dataIndex:'order',width:50},
	{header:'项目名称',dataIndex:'text',width:800},
	{header:'项目id',dataIndex:'id',width:150,hidden:true},
	{header:'项目细节',dataIndex:'detailInfo',width:200,hidden:true}
]);

//方案编辑表格  
var schemeEditGrid = new Ext.grid.GridPanel({
	id:'schemeEditGrid',
	store:schemeEditStore,
	cm:schemeEditCM,
	autoScroll:true,
	containerScroll:true,
	stripeRows: true,
	frame:true,
	loadMask:true,
	autoExpandColumn:'text',
	enableColumnHide:true,
	viewConfig:{
		forceFit:true
	}
}); 

//方案表格******************************************
//方案表格
var schemeStore = new Ext.data.JsonStore({
	url:'../web.eprajax.CentralizedPrintScheme.cls?Action=getscheme&EpisodeID='+ episodeID + '&UserID=' + userID,
    fields: [
		{name: 'IsDefault'},
		{name: 'SchemeID'},
		{name: 'SchemeName'},
		{name: 'SchemeDesc'},
		{name: 'CreateUserName'},
		{name: 'CreateUserID'},
		{name: 'Order',type:'int'},
		{name: 'CreateDateTime'},
		{name: 'ModifyDateTime'}
	],
	sortInfo: {field: 'Order', direction: "ASC" }
});

//默认方案增加背景色
schemeStore.on('load', function(){
	//默认方案上色
	changeRowBackgroundColor(Ext.getCmp('schemeGrid'));
	var records = new Array();  
	Ext.getCmp('schemeGrid').getStore().each(function(record) { 
		if(selectSchemeID == record.data.SchemeID){
			records.push(record);  
		}
	});  
	Ext.getCmp('schemeGrid').getSelectionModel().selectRecords(records,true);
});
    
//数据加载异常
schemeStore.on('loadexception', function (proxy, options, response, e) {
	alert(response.responseText);
});

schemeStore.load();

var sm = new Ext.grid.CheckboxSelectionModel({ singleSelect: true });

var cm = new Ext.grid.ColumnModel([sm,
	{header:'序号',dataIndex:'Order',width:50,sortable: true},
	{header:'创建者',dataIndex:'CreateUserName',width:100,sortable: true},
	{header:'创建日期时间',dataIndex:'CreateDateTime',width:150,sortable: true},
	{header:'最近修改日期时间',dataIndex:'ModifyDateTime',width:150,sortable: true},
	{header:'方案名称',dataIndex:'SchemeName',width:250,sortable: true},
	{header:'方案描述',dataIndex:'SchemeDesc',width:450,sortable: true},
	{header:'创建者id',dataIndex:'CreateUserID',width:70,hidden:true}
]);

//方案表格   
var schemeGrid = new Ext.grid.GridPanel({
	id:'schemeGrid',
	//title:'方案管理',
	store:schemeStore,
	cm:cm,
	sm:sm,
	autoScroll:true,
	containerScroll:true,
	stripeRows: true,
	frame:true,
	loadMask:true,
	autoExpandColumn:'SchemeDesc',
	viewConfig:{
		forceFit:true
	},
	tbar:tbarGrid
});

//处理列表单击事件，点击行则加载相应的方案树（刷新方案树）
schemeGrid.addListener('rowclick', gridRowClick, false); 

//view******************************************
var view = new Ext.Viewport({
	id: 'printViewPort',
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
        height:220,
		bodyStyle:'padding:0px 0px 0px 0px',
        split: true,
		collapsible: true,  
        items:schemeGrid
	},{
		border:true,
		region:'center',
		layout:'fit',
		bodyStyle:'padding:0px 0px 0px 0px',
		height: 400,
		split: true,
		collapsible: true,  
		items:schemeEditGrid       
	}]
});
