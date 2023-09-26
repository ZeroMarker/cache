Ext.onReady(function(){
	Ext.QuickTips.init();
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	var uPanel = new Ext.Panel({
		region: 'south',
		height:300,
		layout: 'column',
		items: [{columnWidth:.50,items:specialUnitGrid},{columnWidth:.50,items:inFiltfDeptsGrid}]
	});
	
	var rightUPLPanel = new Ext.Panel({
  		title: '收入分配规则',
  		region:'center',
		layout: 'border',
		border: false,
		items: [uPanel,specialParamPanel]
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

