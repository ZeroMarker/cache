Ext.onReady(function(){
	Ext.QuickTips.init();
	//Ext.state.Manager.setProvider(new Ext.state.CookieProvider());
	var uPanel = new Ext.Panel({
		//title: '业务项码表',
		region: 'south',
		height:300,
		layout: 'column',
		items: [{columnWidth:.25,items:specialUnitGrid},{columnWidth:.25,items:inFiltfDeptsGrid},{columnWidth:.25,items:inFilttDeptsGrid},{columnWidth:.25,items:inFiltPatDeptsGrid}]
	});
	
	var rightUPLPanel = new Ext.Panel({
  		title: '收入过滤规则',
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

