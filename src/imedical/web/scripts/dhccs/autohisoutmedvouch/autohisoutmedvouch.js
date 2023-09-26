Ext.onReady(function(){
	Ext.QuickTips.init();                           
//	var tabPanel = new Ext.TabPanel({
// 	activeTab: 0,
// 	region:'center',
// 	items:[autohisoutmedvouchMain]               
// });
  var mainPanel = new Ext.Viewport({
  	layout: 'border',
  	items : [autohisoutmedvouchForm,autohisoutmedvouchMain]
  });
});