Ext.onReady(function(){
	Ext.QuickTips.init();  
	//��ʼ������Tips
	var SchemDetailPanel = new Ext.Panel({
    title : '��Ч����-��Ч��������-���ҷ���',
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