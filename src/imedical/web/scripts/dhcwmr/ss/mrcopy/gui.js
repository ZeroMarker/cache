function InitviewScreen(){
	var obj = new Object();
	obj.txtMrNo = new Ext.form.TextField({
		id : 'txtMrNo'
		,fieldLabel : '病案号'
		,labelSeparator :''
		,enableKeyEvents : true
		,FieldCode : 'COPY_REQ_PEOPLE'
});
	obj.pnMrNo = new Ext.Panel({
		id : 'pnMrNo'
		,buttonAlign : 'center'
		,width : 250
		,layout : 'form'
		,items:[
			obj.txtMrNo
		]
	});
	obj.btnQryPat = new Ext.Button({
		id : 'btnQryPat'
		,text : '查询患者信息'
		,iconCls : 'icon-find'
});
	obj.pnBtnQry = new Ext.Panel({
		id : 'pnBtnQry'
		,buttonAlign : 'center'
		,items:[
			obj.btnQryPat
		]
	});

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.gridVolStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.gridVolStore = new Ext.data.Store({
		proxy: obj.gridVolStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'VolID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'VolID', mapping: 'VolID'}
			,{name: 'EpisodeID', mapping: 'EpisodeID'}
			,{name: 'PatientID', mapping: 'PatientID'}
			,{name: 'PatientName', mapping: 'PatientName'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'DisDate', mapping: 'DisDate'}
			,{name: 'Ward', mapping: 'Ward'}
			,{name: 'CurrStatusID', mapping: 'CurrStatusID'}
			,{name: 'CurrStatusDesc', mapping: 'CurrStatusDesc'}
			,{name: 'DisplayText', mapping: 'DisplayText'}
			,{name: 'MrNo', mapping: 'MrNo'}
		])
	});
	obj.gridVolCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridVol = new Ext.grid.GridPanel({
		id : 'gridVol'
		,height : 150
		,store : obj.gridVolStore
		,title : '就诊列表'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,obj.gridVolCheckCol
			,{header: '姓名', width: 100, dataIndex: 'PatientName', sortable: true}
			,{header: '性别', width: 100, dataIndex: 'Sex', sortable: true}
			,{header: '住院日期', width: 100, dataIndex: 'AdmitDate', sortable: true}
			,{header: '出院日期', width: 100, dataIndex: 'DisDate', sortable: true}
			,{header: '病房', width: 100, dataIndex: 'Ward', sortable: true}
			,{header: '当前状态', width: 100, dataIndex: 'CurrStatusDesc', sortable: true}
		]
		,plugins : obj.gridVolCheckCol});
	obj.pnPatCond = new Ext.Panel({
		id : 'pnPatCond'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.pnMrNo
			//,obj.pnBtnQry
			,obj.gridVol
		]
	});
	obj.frPatient = new Ext.form.FieldSet({
		id : 'frPatient'
		,buttonAlign : 'center'
		,title : '患者信息'
		,items:[
			obj.pnPatCond
		]
	});

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboCopyGoalStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboCopyGoalStore = new Ext.data.Store({
		proxy: obj.cboCopyGoalStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicRowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicRowID', mapping: 'DicRowID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
			,{name: 'DicType', mapping: 'DicType'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'HospDr', mapping: 'HospDr'}
			,{name: 'HospDesc', mapping: 'HospDesc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.cboCopyGoal = new Ext.form.ComboBox({
		id : 'cboCopyGoal'
		,store : obj.cboCopyGoalStore
		,minChars : 1
		,displayField : 'DicDesc'
		,fieldLabel : '复印目的'
		,labelSeparator :''
		,valueField : 'DicRowID'
		,triggerAction : 'all'
		,FieldCode : 'COPY_GOAL'
});
	obj.pn1 = new Ext.Panel({
		id : 'pn1'
		,buttonAlign : 'center'
		,columnWidth : 0.3
		,layout : 'form'
		,items:[
			obj.cboCopyGoal
		]
	});

	var objConn = new Ext.data.Connection({url : ExtToolSetting.RunQueryPageURL});
	objConn.on('requestcomplete',
				function(conn, response, Options){
				if(response.responseText.indexOf('<b>CSP Error</b>')>-1)
					ExtTool.alert('Error', response.responseText, Ext.MessageBox.ERROR);
				}
			);
	obj.cboReqPeopleStoreProxy = new Ext.data.HttpProxy(objConn);
	obj.cboReqPeopleStore = new Ext.data.Store({
		proxy: obj.cboReqPeopleStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicRowID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'DicRowID', mapping: 'DicRowID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
			,{name: 'DicType', mapping: 'DicType'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'HospDr', mapping: 'HospDr'}
			,{name: 'HospDesc', mapping: 'HospDesc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.cboReqPeople = new Ext.form.ComboBox({
		id : 'cboReqPeople'
		,minChars : 1
		,store : obj.cboReqPeopleStore
		,valueField : 'DicRowID'
		,fieldLabel : '复印人员类别'
		,labelSeparator :''
		,displayField : 'DicDesc'
		,triggerAction : 'all'
		,FieldCode : 'COPY_REQ_PEOPLE'
});
	obj.pn2 = new Ext.Panel({
		id : 'pn2'
		,buttonAlign : 'center'
		,columnWidth : 0.3
		,layout : 'form'
		,items:[
			obj.cboReqPeople
		]
	});
	obj.pnCpyInfo1 = new Ext.Panel({
		id : 'pnCpyInfo1'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.pn1
			,obj.pn2
		]
	});
	obj.pnCpyInfo2 = new Ext.Panel({
		id : 'pnCpyInfo2'
		,autoHeight : true
		,buttonAlign : 'center'
		//,title : '复印内容'
		,layout : 'form'
		,width : 800
		,items:[
		]
	});
	obj.txtNum = new Ext.form.NumberField({
		id : 'txtNum'
		,fieldLabel : '复印页数'
		,labelSeparator :''
		,FieldCode : 'COPY_PAGES'
});
	obj.pn3 = new Ext.Panel({
		id : 'pn3'
		,buttonAlign : 'center'
		,columnWidth : 0.3
		,layout : 'form'
		,items:[
			obj.txtNum
		]
	});
	obj.txtPrice = new Ext.form.TextField({
		id : 'txtPrice'
		,fieldLabel : '复印金额'
		,labelSeparator :''
		,FieldCode : 'COPY_PRICE'
});
	obj.pn4 = new Ext.Panel({
		id : 'pn4'
		,buttonAlign : 'center'
		,columnWidth : 0.3
		,layout : 'form'
		,items:[
			obj.txtPrice
		]
	});
	obj.pnCpyInfo3 = new Ext.Panel({
		id : 'pnCpyInfo3'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.pn3
			,obj.pn4
		]
	});
	obj.txtResume = new Ext.form.TextArea({
		id : 'txtResume'
		,fieldLabel : '备注'
		,labelSeparator :''
		,FieldCode : 'COPY_RESUME'
		,width : 300
});
	obj.frCpy = new Ext.form.FieldSet({
		id : 'frCpy'
		,buttonAlign : 'center'
		,title : '复印信息'
		,layout : 'form'
		,items:[
			obj.pnCpyInfo1
			,obj.pnCpyInfo2
			,obj.pnCpyInfo3
			,obj.txtResume
		]
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
});
	obj.btnClear = new Ext.Button({
		id : 'btnClear'
		,iconCls : 'icon-clearscreen'
		,text : '清屏'
});
	obj.frScreen = new Ext.form.FormPanel({
		id : 'frScreen'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,frame : true
		,title : 'title'
		,items:[
			obj.frPatient
			,obj.frCpy
		]
	,	buttons:[
			obj.btnSave
			,obj.btnClear
		]
	});
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'fit'
		,items:[
			obj.frScreen
		]
	});
	obj.gridVolStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.WorkFlowSrv';
			param.QueryName = 'QryVolume';
			param.Arg1 = obj.txtMrNo.getValue();
			param.Arg2 = CurrMrType.RowID;
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	obj.cboCopyGoalStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.DictionarySrv';
			param.QueryName = 'QryDicByType';
			param.Arg1 = 'COPY_GOAL';
			param.Arg2 = 1;
			param.ArgCnt = 2;
	});
	obj.cboReqPeopleStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCWMR.SSService.DictionarySrv';
			param.QueryName = 'QryDicByType';
			param.Arg1 = 'COPY_REQ_PEOPLE';
			param.Arg2 = 1;
			param.ArgCnt = 2;
	});
	InitviewScreenEvent(obj);
	//事件处理代码
	obj.btnQryPat.on("click", obj.btnQryPat_click, obj);
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnClear.on("click", obj.btnClear_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}

