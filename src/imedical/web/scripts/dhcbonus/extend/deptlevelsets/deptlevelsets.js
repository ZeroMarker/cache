var reportPanel;                                 //�����
var reportTabPanel;                              //Tab���

Ext.onReady(function(){
	Ext.QuickTips.init();                        //��ʼ������Tips
	
	reportPanel = new Ext.Panel({
     	title : '���ŷֲ��',
     	layout : 'border',
	region:'center',
     	items : [detailReport,deptLevelSetsGrid]                  //����Tab���
  		//tbar: menubar                             //����TopMenu
	});
	reportTabPanel = new Ext.TabPanel({
   		activeTab: 0,
		region: 'center',
   		items:reportPanel         //����Tabs
 		});
	var mainPanel = new Ext.Viewport({
     	layout:'border',
     	items : reportTabPanel,
     	renderTo: 'mainPanel'
 	})
});