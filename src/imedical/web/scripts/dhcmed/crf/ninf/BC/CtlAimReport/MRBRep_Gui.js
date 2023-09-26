function InitAimRepLnk(aEpisodeID, aCtlResults){
	var obj = new Object();
	obj.EpisodeID = aEpisodeID;
	obj.CtlResults = aCtlResults;
	
	obj.pnAimReport = new Ext.Panel({
		title : '多重耐药菌',
		html : '<iframe id="ifAimReport" width="100%" height="100%" src="#"/>'
	});
	
	obj.pnClose = new Ext.Panel({
		title : '关闭'
	});
	
	obj.TabPanelList = new Ext.TabPanel({
		id : 'TabPanelList'
		,frame : true
		,activeTab : 0
		,items:[
			obj.pnAimReport
			,obj.pnClose
		]
	});
	
	obj.WinAimRepLnk = new Ext.Window({
		id : 'WinAimRepLnk'
		,width : 700
		,height : 450
		,closable : true
		,modal : true
		,maximized : false
		,title : '目标性监测'
		,layout : 'fit'
		,items:[
			obj.TabPanelList
		]
	});
	
	InitAimRepLnkEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

