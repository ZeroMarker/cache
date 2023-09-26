Ext.onReady(function(){
	Ext.QuickTips.init();  
	//初始化所有Tips
	var SchemDetailPanel = new Ext.Panel({
    title : '绩效考核-绩效分析报告-科室反馈',
    layout : 'border',
		region:'center',
    items : [detailsetReport],
	tbar:detailsetmenubar,
	bbar:textfile
	});
	var MainViewPort = new Ext.Viewport({
      layout:'border',
      items : SchemDetailPanel,
      renderTo: 'MainViewPort'
  });
});