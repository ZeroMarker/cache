function InitwinSendFeedback(SummaryID, LnkSummaryIDs, callback){
	var obj = new Object();
	
	obj.SummaryID = SummaryID;
	obj.LnkSummaryIDs = LnkSummaryIDs;
	
	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboToDepartmentStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboToDepartmentStore = new Ext.data.Store({
		proxy: obj.cboToDepartmentStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'CTLocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'CTLocID', mapping: 'CTLocID'}
			,{name: 'CTLocCode', mapping: 'CTLocCode'}
			,{name: 'CTLocDesc', mapping: 'CTLocDesc'}
		])
	});
	obj.cboToDepartment = new Ext.form.ComboBox({
		id : 'cboToDepartment'
		,store : obj.cboToDepartmentStore
		,minChars : 1
		,displayField : 'CTLocDesc'
		,width : 240
		,fieldLabel : '目标科室'
		,valueField : 'CTLocID'
		,triggerAction : 'all'
});

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboToDoctorStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboToDoctorStore = new Ext.data.Store({
		proxy: obj.cboToDoctorStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'UserRowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'UserRowid', mapping: 'UserRowid'}
			,{name: 'UserCode', mapping: 'UserCode'}
			,{name: 'UserName', mapping: 'UserName'}
			,{name: 'UserLoc', mapping: 'UserLoc'}
		])
	});
	obj.cboToDoctor = new Ext.form.ComboBox({
		id : 'cboToDoctor'
		,store : obj.cboToDoctorStore
		,minChars : 1
		,displayField : 'UserName'
		,width : 240
		,fieldLabel : '目标医师'
		,valueField : 'UserRowid'
		,triggerAction : 'all'
});
	obj.txtNotice = new Ext.form.TextArea({
		id : 'txtNotice'
		,width : 222
		,fieldLabel : '发送信息'
		,style : 'overflow-y:hidden'
}); 

	obj.cboMarkColorStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.cboMarkColorStore = new Ext.data.Store({
		proxy: obj.cboMarkColorStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ColorNumber'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
		])
	});
	obj.cboMarkColor = new Ext.form.ComboBox({
		id : 'cboMarkColor'
		,width : 18
		,store : obj.cboMarkColorStore
		,minChars : 1
		,displayField : 'Description'
		,valueField : 'Code'
		,editable : false
		,triggerAction : 'all'
		,hideParent : true
		,listWidth : 350
});
	obj.btnOK = new Ext.Button({
		id : 'btnOK'
		,text : '确定'
		,iconCls : 'icon-save'
});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,text : '取消'
		,iconCls : 'icon-cancel'
});

	obj.Panela = new Ext.form.FormPanel({
		id : 'Panels'
		,buttonAlign : 'center'
		,layout : 'form'
		,columnWidth : 0.845
		,labelWidth : 60
		,items:[
			obj.txtNotice
		]
	});
	
	obj.Panelb = new Ext.Panel({
		id : 'Panelt'
		,buttonAlign : 'center'
		,columnWidth : 0.1
		,items:[
			obj.cboMarkColor
		]
	});
	
	obj.fpContents = new Ext.Panel({
		id : 'fpContents'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.Panela
			,obj.Panelb
		]
	});

	//Add by LiYang 2013-03-27 增加反馈报告类型功能
	obj.cboRepTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboRepTypeStore = new Ext.data.Store({
		proxy: obj.cboRepTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'ID', mapping: 'ID'}
			,{name: 'Active', mapping: 'Active'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'HospitalDr', mapping: 'HospitalDr'}
			,{name: 'StrA', mapping: 'StrA'}
			,{name: 'StrB', mapping: 'StrB'}
			,{name: 'StrC', mapping: 'StrC'}
			,{name: 'StrD', mapping: 'StrD'}
			,{name: 'Type', mapping: 'Type'}
		])
	});
	obj.cboRepType = new Ext.form.ComboBox({
		id : 'cboRepType'
		,store : obj.cboRepTypeStore
		,minChars : 0
		,displayField : 'Description'
		,fieldLabel : '报告类别'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'Code'
		,width : 300
		,disabled : true //Add By LiYang 2013-04-07根据报告筛选报告类别
	});
	
	obj.Panelc  = new Ext.form.FormPanel({
		id : 'ss'
		,buttonAlign : 'center'
		,layout : 'form'
		,columnWidth : 0.9
		,labelWidth : 60
		,items:[
			obj.cboToDepartment
			,obj.cboToDoctor
			,obj.cboRepType 
		]
	});
	
	obj.Paneld = new Ext.Panel({
		id : 'tt'
		,buttonAlign : 'center'
		,layout : 'column'
		//,height :100
		,items:[
			obj.Panelc
		]
	});


	
	obj.Panele = new Ext.Panel({
		id : 'aaa'
		,height : 220
		,buttonAlign : 'center'
		,width : 350
		,frame : true
		,layout : 'form'
		,items:[
			obj.Paneld
			,obj.fpContents
		]
	});
	obj.winSendFeedback = new Ext.Window({
		id : 'winSendFeedback'
		,buttonAlign : 'center'
		,width : 370
		,height : 230
		,title : '发送提示'
		,layout : 'fit'
		,modal : true
		,frame : true
		,items:[
			obj.Panele
		]
	,	buttons:[
			obj.btnOK
			,obj.btnCancel
		]
	});
	obj.cboToDepartmentStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.Base.Ctloc';
			param.QueryName = 'QryCTLoc';
			param.Arg1 = '';
			param.Arg2 = 'E';
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	obj.cboToDoctorStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.Base.SSUser';
			param.QueryName = 'QueryByName';
			param.Arg1 = obj.cboToDoctor.getRawValue();
			param.Arg2 = '';
			param.ArgCnt = 2;
	});
	//Add By Liyang 2013-03-27 加载报告类别
	obj.cboRepTypeStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SS.Dictionary';
			param.QueryName = 'QueryByType';
			param.Arg1 = 'FeedBackRepType';
			param.Arg2 = 1;
			param.ArgCnt = 2;
	});		
	
	obj.cboMarkColorStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.Arg1 = 'NoticeMessage';
			param.ArgCnt = 1;
	});
	obj.cboMarkColorStore.load({});
	
	InitwinSendFeedbackEvent(obj);
	//事件处理代码
	obj.btnOK.on("click", obj.btnOK_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	obj.cboMarkColor.on("beforeselect", obj.cboMarkColor_beforeselect, obj);
  obj.LoadEvent(arguments);
  return obj;
}

