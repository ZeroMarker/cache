function InitwinFeedbackEva(){
	var obj = new Object();
	obj.rdoCorrect = new Ext.form.Radio({
		checked : true
		,name : 'rdoIsCorrect'
		,width : 82
		,height : 22
		,boxLabel : '准确'
	});
	obj.rdoInCorrect = new Ext.form.Radio({
		name : 'rdoIsCorrect'
		,width : 82
		,height : 22
		,boxLabel : '不准确'
	});
	obj.rdoGrpCorrect = new Ext.form.RadioGroup({
		width : 200
		,fieldLabel : '准确性'
		,columns : 3
		,items:[
			obj.rdoCorrect
			,obj.rdoInCorrect
		]
	});

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboInCorrectReasonStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboInCorrectReasonStore = new Ext.data.Store({
		proxy: obj.cboInCorrectReasonStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'myid', mapping: 'myid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'Active', mapping: 'Active'}
			,{name: 'HispsDescs', mapping: 'HispsDescs'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'HospDr', mapping: 'HospDr'}
		])
	});
	obj.cboInCorrectReasonStore.on("load", 
		function(objStore){
			var objRec = new Ext.data.Record(
				{
					checked : false,
					myid : "",
					Code : "",
					Description : "请选择...",
					Type : "",
					Active : 1,
					HispsDescs : "",
					DateFrom : "",
					DateTo : "",
					HospDr : ""
				}
			);
			objStore.insert(0, [objRec]);
			obj.cboInCorrectReason.setValue("");
		}
	, obj);
	
	
	obj.cboInCorrectReason = new Ext.form.ComboBox({
		width : 200
		,minChars : 1
		,displayField : 'Description'
		,fieldLabel : '不准确原因'
		,store : obj.cboInCorrectReasonStore
		,triggerAction : 'all'
		,valueField : 'myid'
});
	obj.rdoReportOnTime = new Ext.form.Radio({
		checked : true
		,name : 'rdoIsOnTime'
		,width : 82
		,height : 22
		,boxLabel : '及时'
});
	obj.rdoReportLate = new Ext.form.Radio({
		name : 'rdoIsOnTime'
		,width : 82
		,height : 22
		,boxLabel : '不及时'
});
	obj.rdoNotReport = new Ext.form.Radio({
		name : 'rdoIsOnTime'
		,width : 82
		,height : 22
		,boxLabel : '漏报'
});
	obj.rdoGrpReportOnTime = new Ext.form.RadioGroup({
		width : 200
		,fieldLabel : '及时性'
		,columns : 3
		,items:[
			obj.rdoReportOnTime
			,obj.rdoReportLate
			,obj.rdoNotReport
		]
	});
	obj.txtResumeText = new Ext.form.TextArea({
		width : 200
		,fieldLabel : '备注'
});
	obj.btnOK = new Ext.Button({
		text : '确定'
});
	obj.btnCancel = new Ext.Button({
		text : '取消'
});
	obj.winFeedbackEva = new Ext.Window({
		height : 236
		,buttonAlign : 'center'
		,width : 335
		,title : '干预评估'
		,layout : 'form'
		,modal : true
		,items:[
			obj.rdoGrpCorrect
			,obj.cboInCorrectReason
			,obj.rdoGrpReportOnTime
			,obj.txtResumeText
		]
	,	buttons:[
			obj.btnOK
			,obj.btnCancel
		]
	});
	obj.cboInCorrectReasonStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.DictionarySrv';
			param.QueryName = 'QryDictionary';
			param.Arg1 = 'CtlFeedBackErrorReason';
			param.Arg2 = 1;
			param.ArgCnt = 2;
	});
	InitwinFeedbackEvaEvent(obj);
	//事件处理代码
	obj.btnOK.on("click", obj.btnOK_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

