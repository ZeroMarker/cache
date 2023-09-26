
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
	},
	{xtype:'tbspacer'},'-',{xtype:'tbspacer'},
	'<font color="#666666">病案号:</font>',
	{
		id:'patMedRecordNo',
		pressed:false,
		handleMouseEvents:false,
		enable:false,
		text:patMedRecordNo
	},
	{xtype:'tbspacer'},'-',{xtype:'tbspacer'},
	'<font color="#666666">登记号:</font>',
	{
		id:'patRegNo',
		pressed:false,
		handleMouseEvents:false,
		enable:false,
		text:patRegNo
	}]
});

//打印进度条
var pbar = new Ext.ProgressBar({
	text:'准备生成',
	id:'pbar'
	//hidden: true
});

//view******************************************
Ext.onReady(function(){ 
var view = new Ext.Viewport({
	id: 'pdfCreateViewPort',
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
		layout:'fit',
		height: 30,
		bodyStyle:'padding:0px 0px 0px 0px',
		items:tbarPatientInfo
	},{
		//打印项表格
		border:true,
		region:'center',
		layout:'fit',
		height: 30,
		bodyStyle:'padding:0px 0px 0px 0px',
		items:pbar   
    },{
		//隐藏div为打印准备，打印时嵌套iframe封装打印的csp
		border:false,
		region:'south',
		layout:'fit',
		bodyStyle:'padding:0px 0px 0px 0px',
		html: '<DIV id="i_frame_div" width="1px" height="1px" style="display:none"></DIV>'
	}] 
});
});
