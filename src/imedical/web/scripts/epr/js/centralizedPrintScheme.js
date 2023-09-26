
var schemeID = new Ext.getCmp('currentSchemeID');

//toolbar***********************************
var tbarSaveTemplate = new Ext.Toolbar({
	border : false,
	items : [{
		//记录当前方案的id
		xtype:'hidden',
		id:'currentSchemeID',
		value:''		
	},
	'方案名称：',
	{
		xtype:'textfield',
		id:'schemeName',
		width:150,
		emptyText:'方案名称'
	},
	'-',
	'描述：',
	{
		xtype:'textfield',
		id:'schemeDesc',
		width:150,
		emptyText:'方案描述'		
	},
	'->',
	{
		xtype: 'button',
		id : 'btnMoveUpItem',
		text:'上移',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/up.gif',
		handler: moveUpScheme
	},
	'-',
	{
		xtype: 'button',
		id : 'btnMoveDownItem',
		text:'下移',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/down.gif',
		handler: moveDownScheme
	},
	'-',
	{
		xtype: 'button',
		id : 'btnAddScheme',
		text:'新建方案',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/add.gif',
		handler: addScheme
	},
	'-',
	{
		xtype: 'button',
		id : 'btnModifyScheme',
		text:'修改名称描述',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/modify.gif',
		handler: modifyScheme
	},
	'-',
	{
		xtype: 'button',
		id : 'btnDeleteScheme',
		text:'删除方案',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/delete.gif',
		handler: deleteScheme
	}]
});

//方案表格toolbar
var tbarSchemeEditGrid = new Ext.Toolbar({
	items:[{
		xtype: 'button',
		id : 'btnAddItem',
		text:'增加打印项目',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/add.gif',
		handler: addItem
	},
	'-',
	{
		xtype: 'button',
		id : 'btnDeleteItem',
		text:'删除打印项目',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/delete.gif',
		handler: deleteItem
	},
	'-',
	{
		xtype: 'button',
		id : 'btnMoveUpItem',
		text:'上移',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/up.gif',
		handler: moveUpItem
	},
	'-',
	{
		xtype: 'button',
		id : 'btnMoveDownItem',
		text:'下移',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/down.gif',
		handler: moveDownItem
	},
	'-',
	{
		xtype: 'button',
		id : 'btnMoveTopItem',
		text:'置顶',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/top.gif',
		handler: moveTop
	},
	'-',
	{
		xtype: 'button',
		id : 'btnMoveBottomItem',
		text:'置底',
		cls: 'x-btn-text-icon',
		icon: '../scripts/epr/Pics/print/bottom.gif',
		handler: moveBottom
	}]
});

//方案表格toolbar
var tbarGrid = new Ext.Toolbar({
	items:[
	{
		xtype: 'button',
		id : 'btnDefaultScheme',
		text:'设为当前打印方案',
		cls: 'x-btn-text-icon',
		handler: setDefaultScheme
	},
	'-',
	{
		xtype: 'button',
		id : 'btnDefaultPDF',
		text:'设为生成PDF方案',
		cls: 'x-btn-text-icon',
		handler: setDefaultPDF
	},
	'-',
	'<font color="FF0000">（当前打印方案为黄色，pdf方案为蓝色，两者为同一方案时为绿色）</font>'
	]
});

//Status toolbar
var tbarStatus = new Ext.Toolbar({
	items:[
	{
		id:'status',
		pressed:false,
		handleMouseEvents:false,
		enable:false,
		text:''
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

//加载状态栏
schemeEditStore.on('load', function(){
	Ext.getCmp('status').setText('<font color="FF0000">请将续打的两个项目挨着放置</font>');
});

schemeEditStore.load();

var schemeEditSM = new Ext.grid.CheckboxSelectionModel();

var schemeEditCM = new Ext.grid.ColumnModel([schemeEditSM,
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
	sm:schemeEditSM,
	autoScroll:true,
	containerScroll:true,
	stripeRows: true,
	frame:true,
	loadMask:true,
	autoExpandColumn:'text',
	enableColumnHide:true,
	viewConfig:{
		forceFit:true
	},
	tbar:tbarSchemeEditGrid,
	listeners:{
		'render':function(){
			tbarStatus.render(this.tbar);			
		}
	} 
}); 

//方案表格******************************************
//方案表格
var schemeStore = new Ext.data.JsonStore({
	url:'../web.eprajax.CentralizedPrintScheme.cls?Action=getscheme&EpisodeID='+ episodeID + '&UserID=' + userID,
    fields: [
		{name: 'IsDefault'},
		{name: 'IsPDF'},
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
	tbar:tbarGrid,
	listeners:{
		'render':function(){
			tbarSaveTemplate.render(this.tbar);			
		}
	}  
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
