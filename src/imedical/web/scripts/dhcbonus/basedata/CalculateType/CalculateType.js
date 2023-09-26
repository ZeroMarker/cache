/**
 * name:bonusitemtype author:liuyang Date:2011-3-8
 */
Ext.onReady(function() {
			Ext.QuickTips.init(); // 初始化所有Tips
			
			var uPanel = new Ext.Panel({
						title : '单元核算类别设置',
						region : 'center',
						layout : 'border',
						items : [CalculateTypeGroupPanel, CalculateTypePanel,CalcTypeTargetPanel]
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