
//信息科分配需审核人小界面
function toAuditSubScreen(){
	
	var obj = new Object();
		
 obj.cboAuditUser = Common_ComboUser("cboAuditUser","需审核人","");
obj.winAudiUserPanel = new Ext.Panel({
		id : 'winAudiUserPanel'
		,buttonAlign : 'center'
		//,region : 'center'
		//,columnWidth : .3
		,layout : 'form'
		,anchor : '60%'
		,items:[
			obj.cboAuditUser
		]
	}); 
	
	obj.winAudiResult = new Ext.form.TextArea({ 
		id : 'winAudiResult'
		,height : 100
		,fieldLabel : '说明'
		,anchor : '90%'
	});
	obj.winexplainPanel = new Ext.Panel({
		//title: '理由'
		id : 'winexplainPanel'
		,buttonAlign : 'center'
		,border: true
		//,margins: '{5000,0,0,5000}'
		//,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.winAudiResult
		]
	});
	obj.DemandID = new Ext.form.TextField({
		id : 'DemandID'
		,hidden : true
		});
		
	obj.StatusCode = new Ext.form.TextField({
		id : 'StatusCode'
		,hidden : true
		});
		
		
	obj.btnConfirm = new Ext.Button({
		id : 'btnConfirm'
		,iconCls : 'icon-add'
		//,columnWidth : .15
		,text : '确定'
	});
	
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-cancel'
		//,columnWidth : .15
		,text : '取消'
	});
	
	
obj.winTPanelName1 = new Ext.Panel({
		id : 'winTPanelName1'
		,labelAlign : 'right'
		,buttonAlign : 'center'
		,margins : '{5,0,0,0}'
		//,height:'80%'
		,title : '分配人员'
		,layout : 'form'
		,region : 'center'
		,frame : true
		,items:[
			obj.winAudiUserPanel
			,obj.winexplainPanel	
			,obj.DemandID
			,obj.StatusCode
		]
		
	}); 
	
		
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 280
		,buttonAlign : 'center'
		,width : 500
		,modal : true
		,title : '需审核人员'
		,layout : 'border'
		,border:true
		,items:[
			obj.winTPanelName1
			//obj.winTPanelUser
			
		
	
		]
		,	buttons:[
			obj.btnConfirm
			,obj.btnCancel
			
		]
	});
	
	
	
	toAuditSubScreenEvent(obj);
	
	
	
	//事件处理代码
	obj.LoadEvent(arguments);
	
	return obj;
	
}