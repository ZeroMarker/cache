Ext.onReady(function(){
	Ext.QuickTips.init();  
	//初始化所有Tips
	var SchemDetailPanel = new Ext.Panel({
    title : '方案查询',
    layout : 'border',
		region:'center',
    items : [detailsetReport],
	tbar:detailsetmenubar
	});
	var MainViewPort = new Ext.Viewport({
      layout:'border',
      items : SchemDetailPanel,
      renderTo: 'MainViewPort'
  });
});