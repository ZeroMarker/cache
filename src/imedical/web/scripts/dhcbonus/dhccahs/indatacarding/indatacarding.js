Ext.onReady(function(){
	Ext.QuickTips.init();
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	var uPanel = new Ext.Panel({
		//title: 'ҵ�������',
		region: 'south',
		height:300,
		layout: 'fit',
		items: [inDataCardRuleGrid]
	});
	
	var rightUPLPanel = new Ext.Panel({
  		title: '������������',
  		region:'center',
		layout: 'border',
		border: false,
		items: [uPanel,inDataCardingPanel]
	});


  var tabPanel = new Ext.TabPanel({
      activeTab: 0,
      region:'center',
      items:[
      		rightUPLPanel
      ]
  });
  
  var mainPanel = new Ext.Viewport({
      layout:'border',
      items : tabPanel,
      renderTo: 'mainPanel'
  });
  
});

