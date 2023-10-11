
Ext.onReady(function(){
	Ext.QuickTips.init();                             //初始化所有Tips
	var tabPanel = new Ext.Panel({
  	layout: 'border',
  	region:'center',
  	items:[queryPanel,itemGrid]                                 //添加Tabs
  });
	var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : tabPanel,
  	renderTo: 'mainPanel'
  });


/*
   new Ext.Panel({
     renderTo:Ext.getBody(),
     width:400,
     height:200,
     layout:"column",
     items:[{columnWidth:.5,
          title:"面板1"},
     {columnWidth:.5,
          title:"面板2"}]
    });
	
	*/
});