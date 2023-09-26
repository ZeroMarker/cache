Ext.BLANK_IMAGE_URL = '../scripts/ext2/resources/images/default/s.gif';

Ext.onReady(function(){
	Ext.QuickTips.init();
	var View = new Ext.Viewport({
  	layout: 'border',
  	items : mainGrid,
  	renderTo: 'mainPanel'
  });
});