document.write('<style> .x-grid3-cell-inner {white-space:normal !important;} </style>'); //内容长的时候换行
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[itemGrid]                                 //添加Tabs
  });
	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
  });