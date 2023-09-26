
//科内需求小界面
function InHandleSubScreen(){
	
	var obj = new Object();
		
 obj.cboAuditUser = Common_ComboUser("cboAuditUser","处理人","");
 //----------------------------------------------
 
 obj.winAuditUser = new Ext.Panel({
		id : 'winAuditUser'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.cboAuditUser
		]
	});

 obj.textHandleStr = new Ext.form.TextField({
		id : 'textHandleStr'
		,width : 100
		,fieldLabel : ''
		,allowBlank : false
		//,store : obj.cboLocStore
		//,minChars : 1
		//,editable : false
		//,triggerAction : 'all'
		,anchor : '99%'
		//,disabled:true
	});
	
	obj.winHandleStr = new Ext.Panel({
		id : 'winHandleStr'
		//,buttonAlign : 'left'
		,columnWidth : .6
		,layout : 'form'
		,items:[
			obj.textHandleStr
		]
	});
	obj.winFPanel1 = new Ext.form.FormPanel({
		id : 'winFPanel1'
		,buttonAlign : 'center'
		//,labelAlign : 'right'
		//,labelWidth : 80
		//,height : 180
		//,region : 'north'
		,layout : 'column'
		//,frame : true
		,items:[
			obj.winAuditUser
			,obj.winHandleStr
			//,obj.chkActivePanel
			//,obj.LocActivePanel
		]
	});
	
	
//-------------------------------------------------------
 
 
 
 
 
 
/* obj.winAudiUserPanel = new Ext.Panel({
		id : 'winAudiUserPanel'
		,buttonAlign : 'center'
		//,region : 'center'
		//,columnWidth : .3
		,layout : 'form'
		,anchor : '60%'
		,items:[
			obj.cboAuditUser
		]
	});  */
	
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
			//obj.winAudiUserPanel
			obj.winFPanel1
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
		,title : '处理人员'
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
	
	
	
	InHandleSubScreenEvent(obj);
	
	
	
	//事件处理代码
obj.LoadEvent(arguments);
	
	return obj;
	
}