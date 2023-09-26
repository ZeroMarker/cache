function InitPathWaySyndWindow(WinParent, PathWayID, UserID){
	var obj = new Object();
	obj.UserID = UserID;
	obj.PathWayID = PathWayID;
	obj.WinParent = WinParent;
	if ((!obj.PathWayID)||(!obj.UserID)) return;
	
	obj.SyndromeServer = ExtTool.StaticServerObject("web.DHCCPW.MR.ClinPathWaysSyndrome");
	
	obj.cboCompl1 = new Ext.form.ComboBox({
		id : 'cboCompl1'
		,fieldLabel : '合并症'
		,width : 100
		,store : new Ext.data.ArrayStore({
			id : 'cboCompl1Store'
			,fields : [ 'Code', 'Desc' ]
			,data : [ ['Y', '有'], ['N', '无'] ]
		})
		,mode : 'local'
		,minChars : 1
		,valueField : 'Code'
		,displayField : 'Desc'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.cboCompl2 = new Ext.form.ComboBox({
		id : 'cboCompl2'
		,fieldLabel : '并发症'
		,width : 100
		,store : new Ext.data.ArrayStore({
			id : 'cboCompl2Store'
			,fields : [ 'Code', 'Desc' ]
			,data : [ ['Y', '有'], ['N', '无'] ]
		})
		,mode : 'local'
		,minChars : 1
		,valueField : 'Code'
		,displayField : 'Desc'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.txtCompl1 = new Ext.form.TextArea({
		id : 'txtCompl1'
		,height : 70
		,width : 100
		,fieldLabel : ''	// 合并症
		,anchor : '95%'
	});
	
	obj.txtCompl2 = new Ext.form.TextArea({
		id : 'txtCompl2'
		,height : 70
		,width : 100
		,fieldLabel : ''	// 并发症
		,anchor : '95%'
	});
	
	obj.btnSyndUpdate = new Ext.Button({
		id : 'btnSyndUpdate'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	
	obj.btnSyndClose = new Ext.Button({
		id : 'btnSyndClose'
		,iconCls : 'icon-exit'
		,text : '退出'
	});
	
	obj.PathWaySyndPanel = new Ext.form.FormPanel({
		id : 'PathWaySyndPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 70
		,bodyBorder : 'padding:0 0 0 0'
		,layout : 'form'
		,frame : true
		,region : 'center'
		,items:[ obj.cboCompl1, obj.txtCompl1, obj.cboCompl2, obj.txtCompl2 ]
		,buttons:[ obj.btnSyndUpdate, { xtype : 'tbspacer', width : 50 }, obj.btnSyndClose ]
	});
	
	obj.PathWaySyndWindow = new Ext.Window({
		id : 'PathWaySyndWindow'
		,title : '临床路径合并症、并发症'
		,layout : 'border'
		,width : 400
		,height : 285
		,modal: true
		,collapsed : true
		,maximized : false
		,resizable : false
		,buttonAlign : 'center'
		,items:[ obj.PathWaySyndPanel ]
	});
	
	InitPathWaySyndWindowEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}