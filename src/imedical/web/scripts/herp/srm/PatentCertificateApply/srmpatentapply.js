
Ext.onReady(function(){
	Ext.QuickTips.init();                             //��ʼ������Tips
	
	var wincount=0,
	tipw=[];
	//��һ���������õ���
	tipw[wincount] = new Ext.ux.TipsWindow(
	{
	title: "ר�����������ʾ",
	autoHide: 5,
	count:wincount+1,//���õ������ǵڼ���
	//5���Զ��ر�
	html: "��ע����ѻ���ר����ʱ�ɷѣ�"
	});
	tipw[wincount].show();
	
	var tPanel =  new Ext.Panel({
		title:'ר��Ժ��֤������',
		//activeTab: 0,
		layout: 'border',
		region:'center',
		items:[queryPanel,itemGrid]                                 //���Tabs
  });
	
	var tabPanel = new Ext.TabPanel({
		activeTab:0,
		region:'center',
		items:tPanel
	});
	
	var mainPanel = new Ext.Viewport({
		layout: 'border',
		items : tPanel,
		renderTo: 'mainPanel'
  });
});