
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
		id :'uPanel',
	    title:'������Ŀ��������ϱ�',
		region: 'center',
		layout: 'border',
		items: itemGrid
	});
	
 var uDetailGridPanel = new Ext.Panel({
 	    id :'uDetailGridPanel',
	    title:'��Ŀ�о����',
		region: 'center',
		layout: 'border',
		items: DetailGrid
	});
	var uParticipantsInfoPanel = new Ext.Panel({
		id:'uParticipantsInfoPanel',
	    title:'��������Ա��Ϣ',
		region: 'center',
		layout: 'border',
		items: ParticipantsInfoGrid
	});
	var uPrjItemInfoPanel = new Ext.Panel({
		id :'uPrjItemInfoPanel',
	    title:'������Ϣ',
		region: 'center',
		layout: 'border',
		items: PrjItemInfoGrid
	});
	var uTabPanel = new Ext.TabPanel({
		id:'uTabPanel',
		activeTab: 0,
		region: 'center',
//		listeners: {                    
//         'beforetabchange' : function(){
//             //ѡ�����֮ǰ�洢��ǰѡ���һЩ����
//               //var obj = tabs.getActiveTab();//����ʵ�ִ洢��ǰѡ��Ĳ���
//                //var selectedRow = itemGrid.getSelectionModel().getSelections();
//	              //var Year = selectedRow[0].get("HeadDr");
//                },
//         'tabchange' : function(){
//             //ѡ�����֮����¼������Զ�����ܲ���
//               //uPrjItemInfoPanel.setTitle("Title");
//               //getComponent('YearField').setValue("2014");
//               alert("tabchange");
//               var textyear = uPrjItemInfoPanel.getEI().query('iframe')[0].TextField;
//               textyear.setValue("2014");
//          
//                }
//          },

		items: [uPanel,uDetailGridPanel,uParticipantsInfoPanel,uPrjItemInfoPanel]                           
	});
//Ext.getCmp('uPanel').on('tabchange',this.tabChange,this);
	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});