Ext.onReady(function(){
	Ext.QuickTips.init();  
	//��ʼ������Tips
	detailReportPanel = new Ext.Panel({
    title : '����ָ��ѡ��',
    layout : 'border',
	region:'center',
    items : [detailReport],
	tbar:menubar
	});
	SchemPanel = new Ext.Panel({
    title : '����ָ��ѡ��',
    layout : 'border',
		//region:'center',
    items : [SchemGrid,detailReportPanel]            
	});
	var SchemDetailPanel = new Ext.Panel({
    title : '����ָ��Ȩ������',
    layout : 'border',
		region:'center',
    items : [detailsetReport],
	tbar:detailsetmenubar
	});
	var SchemDetailDistPanel = new Ext.Panel({
    title : '�������������',
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
	var SchemDetailAddPanel = new Ext.Panel({
    title : '�ۡ��ӷַ�KPI��׼�ƶ�',
    layout : 'border',
		region:'center',
    items : [detailaddReport],
	tbar:detailaddmenubar
	});
	var SchemTabPanel = new Ext.TabPanel({
    	activeTab: 0,
    	items:[SchemPanel,SchemDetailPanel,SchemDetailDistPanel,SchemDetailAddPanel]                          //���Tabs
  	});
	
   var SchemMainPanel = new Ext.Panel({
      	title : '��Ч�����ƶ�',
      	layout : 'fit',
      	collapsible: false,
      	plain: true,
      	frame: true,
				region:'center',
      	items : SchemTabPanel                 //���Tab���
	});
	var MainViewPort = new Ext.Viewport({
      layout:'border',
      items : SchemMainPanel,
      renderTo: 'MainViewPort'
  });
});