Ext.BLANK_IMAGE_URL = '../scripts/ext3/resources/images/default/s.gif';

Ext.onReady
(
	function()
	{
		Ext.QuickTips.init();
	
		var uPanel = new Ext.Panel
		(
			{
	    		title: '科研项目科目字典维护',
				region: 'center',
				layout: 'border',
				items: mainGrid
			}
		);

		var uTabPanel = new Ext.TabPanel
		(
			{
				activeTab: 0,
				region: 'center',
				items: uPanel                           
			}
		);

		var uViewPort = new Ext.Viewport
		(
			{
				layout: 'border',
				items: uPanel,
				renderTo: 'uViewPort'
			}
		);
	}
);