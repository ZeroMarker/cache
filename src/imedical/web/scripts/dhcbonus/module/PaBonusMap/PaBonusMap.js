/**
  *name:DrgsTargetMap
  *describe:Drgsָ��ӳ��
  *author:lxw
  *Date:2015-04-17
 */
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips

	var tabPanel = new Ext.TabPanel({
  	activeTab: 0,
  	region:'center',
  	items:[MainGrid]                                 
  });

	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });
});