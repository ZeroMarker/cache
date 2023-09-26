function InitviewScreen(){
	var obj = new Object();
	
	//初始化界面模块
	var arrTabItems = [];
	if (typeof InitLIS == 'function') {
		obj = InitLIS(obj);                      //加载 检验系统
		arrTabItems = arrTabItems.concat([obj.LISDATA_ViewPort]);
	}
	if (typeof InitOPR == 'function') {
		obj = InitOPR(obj);                      //加载 手麻系统
		arrTabItems = arrTabItems.concat([obj.OPRDATA_ViewPort]);
	}
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen',
		layout : 'border',
		items : [
			{
				region : 'north',
				layout : 'form',
				height : 45,
				frame : true,
				html : '<table border="0" width="100%" height="100%"><tr><td align="center" ><big><b>' + Title + '</b></big></td></tr></table>'
			},{
				region : 'center',
				layout : 'anchor',
				autoScroll : true,
				items : arrTabItems,
				bbar : ['->',"‘最后同步时间’为空，表示数据未同步！"]
			}
		]
	});
	
  InitviewScreenEvent(obj);
  obj.LoadEvent(arguments);
  return obj;
}


