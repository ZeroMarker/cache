/**
 * name:bonusreportmanagement author:houbo Date:2013-3-27
 */
Ext.onReady(function() {
			Ext.QuickTips.init(); // 初始化所有Tips bonusreportmanagementTab

			var uPanel = new Ext.Panel({
						title : '自定义报表维护',
						region : 'center',
						layout : 'border',
						items : [BonusReportManagementTab, BonusReportManagementCellPanel
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