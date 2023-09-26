Ext.onReady(function(){
	Ext.QuickTips.init();  
	//初始化所有Tips
	detailReportPanel = new Ext.Panel({
    title : '方案指标选择',
    layout : 'border',
	region:'center',
    items : [detailReport],
	tbar:menubar
	});
	SchemPanel = new Ext.Panel({
    title : '方案指标选择',
    layout : 'border',
		//region:'center',
    items : [SchemGrid,detailReportPanel]            
	});
	var SchemDetailPanel = new Ext.Panel({
    title : '方案指标权重设置',
    layout : 'border',
		region:'center',
    items : [detailsetReport],
	tbar:detailsetmenubar
	});
	var SchemDetailDistPanel = new Ext.Panel({
    title : '区间分数段设置',
    id:'SchemDetailDistPanel',
	layout : 'border',
	region:'center',
    items : [extremumForm,{//表格
		id: 'SchemDetailDistGrid',
		//id: 'center_panel',
		region: 'center',
		layout: 'card',
		items: [{id:'first_center',html:''}]
}]            
	});
	var SchemDetailAddPanel = new Ext.Panel({
    title : '扣、加分法KPI标准制定',
    layout : 'border',
		region:'center',
    items : [detailaddReport],
	tbar:detailaddmenubar
	});
	var SchemTabPanel = new Ext.TabPanel({
    	activeTab: 0,
    	items:[SchemPanel,SchemDetailPanel,SchemDetailDistPanel,SchemDetailAddPanel]                          //添加Tabs
  	});
	
   var SchemMainPanel = new Ext.Panel({
      	title : '绩效方案制定',
      	layout : 'fit',
      	collapsible: false,
      	plain: true,
      	frame: true,
				region:'center',
      	items : SchemTabPanel                 //添加Tab面板
	});
	var MainViewPort = new Ext.Viewport({
      layout:'border',
      items : SchemMainPanel,
      renderTo: 'MainViewPort'
  });
});