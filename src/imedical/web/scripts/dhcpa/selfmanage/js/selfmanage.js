//�Բ����
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
		items:[	{html:'<div id="ext-gen13" class="x-panel-header x-unselectable" style="-moz-user-select: none;">�Բ�����</div>',colspan:2,width:document.body.clientWidth,height:25},
				{html:'<div id="adiv"></div>',colspan:1,width:(document.body.clientWidth)/2,height:(document.body.clientHeight)},
				{html:'<div id="bdiv"></div>',colspan:1,width:(document.body.clientWidth)/2,height:(document.body.clientHeight)}
				
		],
  		renderTo: Ext.getBody()//renderTo:'mainPanel'�������븺������󶨵�һ��div���mainPanel����div��ID
		})
		
		var leftpanel = new Ext.Panel({
			renderTo:'adiv',
			title:'�Բ鶨��',
			items:itemGrid	
		});
		var rightpanel = new Ext.Panel({
			renderTo:'bdiv',
			title:'�Բ���ϸ',
			items:detailReport,
			tbar:[addButton,'-',delButton,'-',updateButton]
		});
		
	
	
})