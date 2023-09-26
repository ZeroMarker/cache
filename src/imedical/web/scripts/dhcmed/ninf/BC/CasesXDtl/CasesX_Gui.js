
function InitSendMassage(EpisodeID,CasesXDates){
	var obj = new Object();
	obj = InitCasesXDtl(obj);
	obj.EpisodeID = EpisodeID;
	obj.CasesXDates = CasesXDates;
	
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-cancel'
		,width : 70
		,text : '�ر�'
	})
	
	var htmlMainPanel = '<div id="PatXTemplateDIV"></div>'
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,region : 'center'
		,autoScroll : true
		//,frame : true
		,html : htmlMainPanel
	});
	
	obj.winSendMassage = new Ext.Window({
		id : 'winSendMassage'
		,buttonAlign : 'center'
		,width : 850
		,height : 600
		,title : '���Ʋ���ɸ��'
		,layout : 'fit'
		,modal : true
		,frame : true
		,items:[
			obj.MainPanel
		]
		,bbar : ['->',obj.btnCancel]
	});
	
	InitSendMassageEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

