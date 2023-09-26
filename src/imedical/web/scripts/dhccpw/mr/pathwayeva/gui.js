function InitPathWayEvaWindow(WinParent,PathWayID,UserID){
	var obj = new Object();
	obj.UserID = UserID;
	obj.PathWayID = PathWayID;
	obj.CurrRstID="";
	obj.WinParent = WinParent;
	if ((!obj.PathWayID)||(!obj.UserID)) return;
  
	var objClinPathWaysEva = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysEva");
	var elems=objClinPathWaysEva.GetEvaElements(obj.PathWayID);
	window.eval(elems);
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-save'
		,text : '±£´æ'
	});
	
	obj.ConditionPanel = new Ext.form.FormPanel({
		id : 'ConditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'form'
		,frame : true
		,autoScroll : true
		,items:subelements
	});
	
	obj.PathWayRstWindow = new Ext.Window({
		//id : 'PathWayRstWindow'
		//,collapsed : true
		buttonAlign : 'center'
		,maximized : false
		,resizable : false
		,title : 'Â·¾¶ÆÀ¹À'
		,layout : 'fit'
		,width : 400
		,height : panelheight //275
		,modal: true
		,items:[
			obj.ConditionPanel
		]
		,buttons:[
			obj.btnUpdate
		]
	});
	InitPathWayEvaWindowEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}