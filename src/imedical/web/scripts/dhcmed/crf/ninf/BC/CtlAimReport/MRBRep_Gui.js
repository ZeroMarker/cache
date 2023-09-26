function InitAimRepLnk(aEpisodeID, aCtlResults){
	var obj = new Object();
	obj.EpisodeID = aEpisodeID;
	obj.CtlResults = aCtlResults;
	
	obj.pnAimReport = new Ext.Panel({
		title : '������ҩ��',
		html : '<iframe id="ifAimReport" width="100%" height="100%" src="#"/>'
	});
	
	obj.pnClose = new Ext.Panel({
		title : '�ر�'
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
		,title : 'Ŀ���Լ��'
		,layout : 'fit'
		,items:[
			obj.TabPanelList
		]
	});
	
	InitAimRepLnkEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

