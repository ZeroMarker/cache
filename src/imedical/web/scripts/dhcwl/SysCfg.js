dhcwl.mkpi.SysCfg = function(){

	var sysCfgTitle = "指标系统配置首页";
	
	//	为自由布局border的center区域添加一个空面板。？border的center区域？添加border布局的子面板。
	var blankPanel = new Ext.Panel({
		id:'blankPanel'
		//header:true,
		//html:'<img src="dhcwl/kpi/test.jpg"></img>'
	});
	
	var isBlankPanelInit = false;	//	延迟加载。否则可以考虑在sysCfgPanel构造过程中加载。
	var filterFuncObj="",execCodeObj="",logCfgObj="",taskCfgObj="",otherSysCfgObj="";
	var filterFuncPanel="",execCodePanel="",logCfgPanel="",taskCfgPanel="",otherSysCfgPanel="";
	
	function InitBlankPanel() {
		filterFuncObj = new dhcwl.mkpi.FilterFuncCfg(), filterFuncPanel = filterFuncObj.GetFilterFuncPanel();
		execCodeObj = new dhcwl.mkpi.ExecCodeCfg(), execCodePanel = execCodeObj.GetExcCodePanel();
		logCfgObj = new dhcwl.mkpi.GlobalLogCfg(), logCfgPanel = logCfgObj.GetGlobalLogCfgPanel();
		taskCfgObj = new dhcwl.mkpi.GlobalTaskCfg(), taskCfgPanel = taskCfgObj.GetGlobalTaskCfgPanel();
		otherSysCfgObj=new dhcwl.mkpi.OtherSysCfg(), otherSysCfgPanel=otherSysCfgObj.GetOtherSysCfgPanel();
		errorCheckObj=new dhcwl.mkpi.ErrorCheck(), errorCheckPanel=errorCheckObj.GetErrorCheckPanel();

		blankPanel.add(filterFuncPanel);
		blankPanel.add(execCodePanel);
		blankPanel.add(logCfgPanel);
		blankPanel.add(taskCfgPanel);
		blankPanel.add(otherSysCfgPanel);
		blankPanel.add(errorCheckPanel);
		blankPanel.doLayout();
		sysCfgPanel.doLayout();
		filterFuncPanel.hide();
		execCodePanel.hide();
		logCfgPanel.hide();
		taskCfgPanel.hide();
		otherSysCfgPanel.hide();
		errorCheckPanel.hide();
		isBlankPanelInit = true;
	}
	
	var menuTree = new Ext.tree.TreePanel({
		width:150,
		//frame:true,
		height:520,
		xtype:'treepanel',
		autoScroll:true,
		split:true,
		loader:new Ext.tree.TreeLoader(),
		root:new Ext.tree.AsyncTreeNode({
			id:'root',
			text:'支持的配置项',
			expanded:true,
			children:[{
				text:'<font color=blue>过滤函数配置</font>',
				leaf:true,
				listeners:{
					'click': function(node,e){
						if (false==isBlankPanelInit) {
							InitBlankPanel();
						}
						execCodePanel.hide();
						logCfgPanel.hide();
						taskCfgPanel.hide();
						otherSysCfgPanel.hide();
						errorCheckPanel.hide();
						sysCfgTitle = '过滤函数配置';
						Ext.getCmp('cfgPageMainTitle').setTitle(sysCfgTitle);
						filterFuncPanel.show();
						filterFuncObj.ReLoad();
						if (!!filterFuncObj) {
							filterFuncObj.InitPanelSize();
						}
					}
				}
			}, {
				text:'<font color=blue>任务执行代码配置</font>',
				leaf:true,
				listeners:{
					'click': function(node,e){
						if (false==isBlankPanelInit) {
							InitBlankPanel();
						}
						filterFuncPanel.hide();
						logCfgPanel.hide();
						taskCfgPanel.hide();
						otherSysCfgPanel.hide();
						errorCheckPanel.hide();
						sysCfgTitle = '任务执行代码配置';
						Ext.getCmp('cfgPageMainTitle').setTitle(sysCfgTitle);
						execCodePanel.show();
						execCodeObj.ReLoad();
						if (!!execCodeObj) {
							execCodeObj.InitPanelSize();
						}
					}
				}
			}, {
				text:'<font color=blue>日志全局配置</font>',
				leaf:true,
				listeners:{
					'click': function(node,e){
						if (false==isBlankPanelInit) {
							InitBlankPanel();
						}
						filterFuncPanel.hide();
						execCodePanel.hide();
						taskCfgPanel.hide();
						otherSysCfgPanel.hide();
						errorCheckPanel.hide();
						sysCfgTitle = '日志全局配置';
						Ext.getCmp('cfgPageMainTitle').setTitle(sysCfgTitle);
						logCfgPanel.show();
					}
				}
			}, {
				text:'<font color=blue>指标任务全局配置</font>',
				leaf:true,
				listeners:{
					'click': function(node,e){
						if (false==isBlankPanelInit) {
							InitBlankPanel();
						}
						filterFuncPanel.hide();
						execCodePanel.hide();
						logCfgPanel.hide();
						otherSysCfgPanel.hide();
						errorCheckPanel.hide();
						sysCfgTitle = '指标任务全局配置';
						Ext.getCmp('cfgPageMainTitle').setTitle(sysCfgTitle);
						taskCfgPanel.show();
					}
				}
			}, {
				text:'<font color=blue>其他系统配置</font>',
				leaf:true,
				listeners:{
					'click': function(node,e){
						if (false==isBlankPanelInit) {
							InitBlankPanel();
						}
						filterFuncPanel.hide();
						execCodePanel.hide();
						logCfgPanel.hide();
						taskCfgPanel.hide();
						errorCheckPanel.hide();
						sysCfgTitle = '其他系统配置';
						Ext.getCmp('cfgPageMainTitle').setTitle(sysCfgTitle);
						otherSysCfgPanel.show();

					}
				}
			}, {
				text:'<font color=blue>指标常见问题检查</font>',
				leaf:true,
				listeners:{
					'click': function(node,e){
						if (false==isBlankPanelInit) {
							InitBlankPanel();
						}
						filterFuncPanel.hide();
						execCodePanel.hide();
						logCfgPanel.hide();
						taskCfgPanel.hide();
						errorCheckPanel.hide();
						otherSysCfgPanel.hide();
						errorCheckObj.LoadErrorInfor();
						sysCfgTitle = '错误显示';
						Ext.getCmp('cfgPageMainTitle').setTitle(sysCfgTitle);
						errorCheckPanel.show();

					}
				}
			}]
		}),
		rootVisible:false
	});
	
	var sysCfgPanel = new Ext.Panel({
		id:'sysCfgPanel',
		title:'系统配置',
		defaults: {
		    collapsible: true,
		    split: true,
		    bodyStyle: 'padding:5px'
		},
		monitorResize:true,
		layout:'border',
		items:[{
			region:'west',
			title:'系统配置菜单',
			frame:true,
			width:150,	// west和east必须的初始化属性
			//height:550,
			items:menuTree,
			listeners:{
				'collapse':function(panel){
					if ((!!execCodeObj)&&(!!filterFuncObj)&&(!!blankPanel)){
						execCodeObj.InitPanelSize();
						filterFuncObj.InitPanelSize();
						//blankPanel.doLayout();
						//sysCfgPanel.doLayout();
					}
				},
				'expand':function(panel){
					if ((!!execCodeObj)&&(!!filterFuncObj)&&(!!blankPanel)){
						execCodeObj.InitPanelSize();
						filterFuncObj.InitPanelSize();
						//blankPanel.doLayout();
						//sysCfgPanel.doLayout();
					}
				}
			}
		},{
			region:'center',
			title:'指标系统配置首页',
			id:'cfgPageMainTitle',
			header:true,
			frame:true,
			collapsible: false,
			autoScroll:true,
			items:blankPanel
		}]
	});
	
	this.GetSysCfgPanel = function(){
		InitBlankPanel();
    	return sysCfgPanel;
	}
}