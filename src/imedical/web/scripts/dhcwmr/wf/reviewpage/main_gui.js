var objScreen = new Object();
function InitReviewPage(){
    var obj = objScreen;
	var strURL="dhc.epr.fs.checkallinonewmr.csp?EpisodeID=" + EpisodeID;
	obj.btnReviewPass = new Ext.Button({
		id : 'btnReviewPass'
		,icon: '../scripts/dhcwmr/img/update.gif'
		,text : '<span style="font-weight:bold;color:#457294;font-size:16;">复核通过</span>'
		,width : 90
	});
	obj.btnReviewNotPass = new Ext.Button({
		id : 'btnReviewNotPass'
		,icon: '../scripts/dhcwmr/img/delete.gif'
		,text : '<span style="font-weight:bold;color:#457294;font-size:16;">复核未通过</span>'
		,width : 90
	});
	
	obj.btnFinaAuditPass = new Ext.Button({
		id : 'btnFinaAuditPass'
		,icon: '../scripts/dhcwmr/img/update.gif'
		,text : '<span style="font-weight:bold;color:#457294;font-size:16;">财务审核通过</span>'
		,width : 90
	});
	obj.btnFinaAuditNotPass = new Ext.Button({
		id : 'btnFinaAuditNotPass'
		,icon: '../scripts/dhcwmr/img/delete.gif'
		,text : '<span style="font-weight:bold;color:#457294;font-size:16;">撤销财务审核</span>'
		,width : 90
	});
	obj.btnClose = new Ext.Button({
		id : 'btnClose'
		,icon: '../scripts/dhcwmr/img/remove.png'
		,text : '<span style="font-weight:bold;color:#457294;font-size:16;">关闭</span>'
		,width : 80
	});
	
	obj.MainPanel = new Ext.Panel({
		id : 'MainPanel'
		,autoScroll : true
		,frame : true
		//,html : '<iframe name="rightPanel" scrolling="atuo" frameborder="0" width="100%" height="100%" src=dhc.epr.fs.checkallinonewmr.csp?"&EpisodeID=' + EpisodeID + '></iframe>'
		,html : "<iframe name='rightPanel' scrolling='atuo' frameborder='0' width='100%' height='100%' src='" + strURL + "'/>"
		,tbar : ['-',{id:'msgReviewPage',text:'病历复核(三单一致)',style:'font-weight:bold;font-size:16px;',xtype:'label'},
		'-',obj.btnReviewPass,
		'-',obj.btnReviewNotPass,
		//'-',obj.btnFinaAuditPass,
		//'-',obj.btnFinaAuditNotPass,
		'-',obj.btnClose,'-']
	});
	
    obj.MainViewPort=new Ext.Viewport({
        id:'MainViewPortId'
        ,layout : 'fit'
		,items:[
			obj.MainPanel
		]
    });
	
	InitReviewPageEvents(obj);
	obj.LoadEvents(arguments);
	return obj;
}