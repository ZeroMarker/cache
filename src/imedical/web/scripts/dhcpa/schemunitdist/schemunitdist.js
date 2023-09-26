Ext.onReady(function(){
	Ext.QuickTips.init();  
	//初始化所有Tips
	var SchemDetailDistPanel = new Ext.Panel({
    title : '区间法KPI参考值设置',
    id:'SchemDetailDistPanel',
	layout : 'border',
	region:'center',
    items : [extremumForm,{//表格
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