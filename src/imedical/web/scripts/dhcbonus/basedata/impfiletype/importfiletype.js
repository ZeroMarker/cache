/**
 * name:bonusemployee author:liuyang Date:2011-1-24
 */
Ext.onReady(function() {
			Ext.QuickTips.init(); // ��ʼ������Tips BonusEmployeeTab

			var uPanel = new Ext.Panel({
						title : '���ݵ���ģ��ά��',
						region : 'center',
						layout : 'border',
						items : [importFileTypeTab, CalculateTypePanel
								]
					});
			var tabPanel = new Ext.TabPanel({
						activeTab : 0,
						region : 'center',
						items : [uPanel]
					});

			var mainPanel = new Ext.Viewport({
						layout : 'border',
						items : tabPanel,
						renderTo : 'mainPanel'
					});
		});