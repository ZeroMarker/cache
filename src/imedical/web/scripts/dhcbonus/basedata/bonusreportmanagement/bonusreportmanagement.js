/**
 * name:bonusreportmanagement author:houbo Date:2013-3-27
 */
Ext.onReady(function() {
			Ext.QuickTips.init(); // ��ʼ������Tips bonusreportmanagementTab

			var uPanel = new Ext.Panel({
						title : '�Զ��屨��ά��',
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