/**
 * name:bonusemployee author:liuyang Date:2011-1-24
 */
Ext.onReady(function() {
			Ext.QuickTips.init(); // 初始化所有Tips

/*			var uPanel = new Ext.Panel({
						title : '单元核算类别设置',
						region : 'center',
						layout : 'border',
						items : [BonusEmployeeTab,CalcTypeTargetPanel]
					});*/
			
			var tabPanel = new Ext.TabPanel({
						activeTab : 0,
						region : 'center',
						items : [BonusEmployeeTab]
					});

			var mainPanel = new Ext.Viewport({
						layout : 'border',
						items : tabPanel,
						renderTo : 'mainPanel'
					});
		});