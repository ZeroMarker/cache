
//打印方案******************************************
//打印方案维护弹出窗口
var win = new Ext.Window({
	id : 'schemeWin',
	layout : 'fit', 		// 自动适应Window大小
	width : 1000,
	height : 600,
	title : '当前打印方案选择',
	closeAction: 'hide',
	animateTarget : 'btnScheme',
	// raggable: true, 		//不可拖动
	modal : true, 			//遮挡后面的页面
	resizable : true, 		// 重置窗口大小
	html : '<iframe id="frmScheme" style="width:100%; height:100%" src="dhc.epr.centralizedprintselection.csp?PatientID='
		+ patientID
		+ '&EpisodeID='
		+ episodeID
		+ '"></iframe>'
});

//关闭时重载打印选项表格
win.on('hide',function(){
	var grid = Ext.getCmp('grid');
	var store = grid.getStore(grid);
	store.load();
});

win.on('close',function(){
	var grid = Ext.getCmp('grid');
	var store = grid.getStore(grid);
	store.load();
});

function showRecordWin(){
	//打印方案维护弹出窗口
	var winRecord = new Ext.Window({
		id: 'recordWin',
		layout: 'fit', // 自动适应Window大小
		width: 1000,
		height: 600,
		title: '打印记录',
		closeAction: 'close',
		// raggable: true, 		//不可拖动
		modal: true, //遮挡后面的页面
		resizable: true, // 重置窗口大小
		autoScroll:true,
		html: '<iframe id="frmRecord" style="width:100%; height:100%" src="dhc.epr.centralizedprintrecord.csp"></iframe>'
	});
	
	winRecord.show();
}

//toolbar******************************************
var tbarOp = new Ext.Toolbar({
	border:true,
	items:[{
		id : 'btnScheme',
		cls: 'x-btn-text-icon' ,
		icon:'../scripts/epr/Pics/print/maintain.gif',
		text : '当前打印方案选择',
		handler : function() {
			win.show();
		}	
	},
	'->', 
	'请输入打印份数：',
	{
		xtype:'textfield',
		id:'txtCopies',
		width:60,
		emptyText:'1',
		defaultValue:'1',
		value:'1'
	},
	'-',
	{
		id:'btnPrint',
		name:'btnPrint',
		text:'打印',
		cls: 'x-btn-text-icon' ,
		icon:'../scripts/epr/Pics/btnConfirm.gif',
		pressed:false,
		handler:printClick
	},
	'-',
	{
		//当前默认打印机名称
		xtype:'hidden',
		id:'currentDefPrinter',
		value:''
	}]
});

var tbarPatientInfo = new Ext.Toolbar({
	border:true,
	items:[
	'病人基本信息：',{xtype:'tbspacer'},
	'<font color="#666666">姓名：</font>',
	{
		id:'patName',
		pressed:false,
		handleMouseEvents:false,
		enable:false,
		text:patName
	},
	{xtype:'tbspacer'},'-',{xtype:'tbspacer'},
	'<font color="#666666">性别:</font>',
	{
		id:'patSex',
		pressed:false,
		handleMouseEvents:false,
		enable:false,
		text:patSex
	},
	{xtype:'tbspacer'},'-',{xtype:'tbspacer'},
	'<font color="#666666">就诊科室:</font>',
	{
		id:'currentDept',
		pressed:false,
		handleMouseEvents:false,
		enable:false,
		text:currentDept
	}]
});

var tbarSchemeInfo = new Ext.Toolbar({
	border:true,
	items:[
	'打印方案信息：',{xtype:'tbspacer'},
	'<font color="#666666">方案名称：</font>',
	{
		id:'schemeName',
		pressed:false,
		handleMouseEvents:false,
		enable:false,
		text:''
	},
	{xtype:'tbspacer'},'-',{xtype:'tbspacer'},
	'<font color="#666666">方案描述:</font>',
	{
		id:'schemeDesc',
		pressed:false,
		handleMouseEvents:false,
		enable:false,
		text:''
	},
	{xtype:'tbspacer'},'-',{xtype:'tbspacer'},
	'<font color="#666666">创建者:</font>',
	{
		id:'createUserID',
		pressed:false,
		handleMouseEvents:false,
		enable:false,
		text:''
	},
	{xtype:'tbspacer'},'-',{xtype:'tbspacer'},
	'<font color="#666666">创建日期时间:</font>',
	{
		id:'createDateTime',
		pressed:false,
		handleMouseEvents:false,
		enable:false,
		text:''
	},
	{xtype:'tbspacer'},'-',{xtype:'tbspacer'},
	'<font color="#666666">最近修改日期时间:</font>',
	{
		id:'modifyDateTime',
		pressed:false,
		handleMouseEvents:false,
		enable:false,
		text:''
	}]
});

//打印进度条
var pbar = new Ext.ProgressBar({
	text:'准备打印',
	id:'pbar',
	hidden: true
});

//打印项表格******************************************
//分组表格
var store = new Ext.data.JsonStore({
	url: "../web.eprajax.CentralizedPrintDisplay.cls?EpisodeID=" + episodeID + "&PatientID=" + patientID + "&UserID=" + userID  + "&CTLocID=" + ctlocid + "&SSGroupID=" + ssgroupid,
	fields: [
		{name: 'id'},
		{name: 'text'},
		{name: 'detailInfo'},
		{name: 'order',type:'int'},
		{name: 'pageInformation'},
		{name: 'pageRange'}
	],
	sortInfo: {field: 'order', direction: "ASC" }
});
  
//数据加载异常
store.on('loadexception', function (proxy, options, response, e) {
	alert("a+"+response.responseText);
});

store.load();
store.on('load', function(){
	getSchemeInfo();
});

var sm = new Ext.grid.CheckboxSelectionModel();

var cm = new Ext.grid.ColumnModel([sm,
	{header:'序号',dataIndex:'order',width:50},
	{header:'ID',dataIndex:'id',width:150,hidden:true},
	{header:'打印项',dataIndex:'text',width:500},
	{header:'detailInfo',dataIndex:'detailInfo',width:300,hidden:true},
	{header:'页码',dataIndex:'pageInformation',width:300},
	{header:'页数',dataIndex:'pageRange',width:300}
]);
    
var grid = new Ext.grid.GridPanel({
	id:'grid',
	store:store,
	cm:cm,
	sm:sm,
	autoScroll:true,
	containerScroll:true,
	stripeRows: true,
	frame:true,
	enableColumnHide:true,
	enableColumnMove:false,
	enableColumnResize:false,
	enableHdMenu:false,
	loadMask:true,
	viewConfig:{
		forceFit:true
	},
	tbar:[{
		id: 'chkIsPageQueue',
		name: 'chkIsPageQueue',
		xtype: 'checkbox',
		boxLabel: '页码是否连续',
		hideLabel: true,
		checked: true
	},
	'->',
	{
		id : 'btnRecord',
		cls: 'x-btn-text-icon' ,
		icon:'../scripts/epr/Pics/browser.gif',
		text : '打印记录',
		handler : showRecordWin
	}],
	bbar: pbar
}); 

//view******************************************
var view = new Ext.Viewport({
	id: 'printViewPort',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	collapsible: true,
	bodyStyle:'padding:0px 0px 0px 0px',           
	layout: "border",  
	border: false,              
	items: [{
		border:true,
		region:'north',
		layout:'border',
		height: 90,
		bodyStyle:'padding:0px 0px 0px 0px',
		items:[{
			border:true,
			region:'north',
			layout:'fit',
			height: 30,
			bodyStyle:'padding:0px 0px 0px 0px',
			items:tbarOp
		},{
			border:true,
			region:'center',
			layout:'fit',
			height: 30,
			bodyStyle:'padding:0px 0px 0px 0px',
			items:tbarPatientInfo
		},{
			border:true,
			region:'south',
			layout:'fit',
			height: 30,
			bodyStyle:'padding:0px 0px 0px 0px',
			items:tbarSchemeInfo
		}]
	},{
		//打印项表格
		border:true,
		region:'center',
		layout:'fit',
		split: true,
		collapsible: true,  
		bodyStyle:'padding:0px 0px 0px 0px',
		items:grid   
    },{
		//隐藏div为打印准备，打印时嵌套iframe封装打印的csp
		border:false,
		region:'south',
		layout:'fit',
		bodyStyle:'padding:0px 0px 0px 0px',
		html: '<DIV id="i_frame_div" width="1px" height="1px" style="display:none"></DIV>'
	}] 
});
