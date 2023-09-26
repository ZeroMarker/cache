//自查管理
Ext.onReady(function(){
		Ext.QuickTips.init();
			
		var viewport =new Ext.Viewport({
			layout: {
			type:'table',
			columns:2
		},
		autoScroll:true,
		enableTabScroll: true,
		defaults: {  width: 70, height: 30 },
		items:[	{html:'<div id="ext-gen13" class="x-panel-header x-unselectable" style="-moz-user-select: none;">自查设置</div>',colspan:2,width:document.body.clientWidth,height:25},
				{html:'<div id="adiv"></div>',colspan:1,width:(document.body.clientWidth)/2,height:(document.body.clientHeight)},
				{html:'<div id="bdiv"></div>',colspan:1,width:(document.body.clientWidth)/2,height:(document.body.clientHeight)}
				
		],
  		renderTo: Ext.getBody()//renderTo:'mainPanel'，这句代码负责把面板绑定到一个div层里，mainPanel就是div的ID
		})
		
		var leftpanel = new Ext.Panel({
			renderTo:'adiv',
			title:'自查定义',
			items:itemGrid	
		});
		var rightpanel = new Ext.Panel({
			renderTo:'bdiv',
			title:'自查明细',
			items:detailReport,
			tbar:[addButton,'-',delButton,'-',updateButton]
		});
		
	
	
})