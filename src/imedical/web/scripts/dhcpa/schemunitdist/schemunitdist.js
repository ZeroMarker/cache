Ext.onReady(function(){
	Ext.QuickTips.init();  
	//��ʼ������Tips
	var SchemDetailDistPanel = new Ext.Panel({
    title : '���䷨KPI�ο�ֵ����',
    id:'SchemDetailDistPanel',
	layout : 'border',
	region:'center',
    items : [extremumForm,{//���
		id: 'SchemDetailDistGrid',
		//id: 'center_panel',
		region: 'center',
		layout: 'card',
		items: [{id:'first_center',html:''}]
}]            
	});
	var MainViewPort = new Ext.Viewport({
      layout:'border',
      items : SchemDetailDistPanel,
      renderTo: 'MainViewPort'
  });
});