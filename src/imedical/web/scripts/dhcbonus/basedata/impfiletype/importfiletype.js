/**
 * name:bonusemployee author:liuyang Date:2011-1-24
 */
Ext.onReady(function() {
			Ext.QuickTips.init(); // 初始化所有Tips BonusEmployeeTab

			var uPanel = new Ext.Panel({
						title : '数据导入模板维护',
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