Ext.onReady(function(){
	Ext.QuickTips.init();  
	//��ʼ������Tips
	var SchemDetailPanel = new Ext.Panel({
    title : '������ѯ',
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