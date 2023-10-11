
Ext.onReady(function(){
	
	Ext.QuickTips.init();
	
	var uPanel = new Ext.Panel({
		title: '项目结题材料上报',
		region: 'center',
		layout: 'border',
		items: [itemGrid,queryPanel]
	});
	
	var PrjPanel = new Ext.Panel({
	  title:'项目结题',
		region: 'center',
		layout: 'border',
		items: [PrjCompletionPanel,PrjCompletionGrid]
		//items: [form]
	});

	var PrjTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: [uPanel,PrjPanel]            
	});

	var MainViewPort = new Ext.Viewport({
		layout: 'border',
		items : PrjTabPanel,
		renderTo: 'MainViewPort'
	});

});

