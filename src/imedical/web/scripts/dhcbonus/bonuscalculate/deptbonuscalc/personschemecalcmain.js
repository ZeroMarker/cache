/**
  *name:deptbonuscalc
  *author:zhaoliguo
  *Date:2011-1-11
 */
 
 /*
 ��������SchemeType
	1�����Һ��㷽��
	2���ɲ����㷽��
*/
var p_SchemeType = 2
Ext.onReady(function(){
	Ext.QuickTips.init();
	 
	
	var uPanel = new Ext.Panel({
		title: '��Ԫ�������',
		region: 'center',
		layout: 'border',
		items: [SchemGrid,bonusitemgrid]
	});

	var uTabPanel = new Ext.TabPanel({
		activeTab: 0,
		region: 'center',
		items: uPanel                                 
	});

	var uViewPort = new Ext.Viewport({
		layout: 'border',
		items : uTabPanel,
		renderTo: 'uViewPort'
	});
});