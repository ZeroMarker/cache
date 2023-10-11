
Ext.onReady(function(){
	Ext.QuickTips.init();

	var uPanel = new Ext.Panel({
		id :'uPanel',
	    title:'横向项目申请材料上报',
		region: 'center',
		layout: 'border',
		items: itemGrid
	});
	
 var uDetailGridPanel = new Ext.Panel({
 	    id :'uDetailGridPanel',
	    title:'项目研究情况',
		region: 'center',
		layout: 'border',
		items: DetailGrid
	});
	var uParticipantsInfoPanel = new Ext.Panel({
		id:'uParticipantsInfoPanel',
	    title:'课题组人员信息',
		region: 'center',
		layout: 'border',
		items: ParticipantsInfoGrid
	});
	var uPrjItemInfoPanel = new Ext.Panel({
		id :'uPrjItemInfoPanel',
	    title:'经费信息',
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
//             //选项卡触发之前存储当前选项卡的一些参数
//               //var obj = tabs.getActiveTab();//可以实现存储当前选项卡的参数
//                //var selectedRow = itemGrid.getSelectionModel().getSelections();
//	              //var Year = selectedRow[0].get("HeadDr");
//                },
//         'tabchange' : function(){
//             //选项卡触发之后的事件，可以定义接受参数
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