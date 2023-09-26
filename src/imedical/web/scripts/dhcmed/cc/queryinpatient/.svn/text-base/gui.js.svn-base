function InitwinViewport(){
	var obj = new Object();
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,items:[
		]
	});
	obj.LocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.LocStore = new Ext.data.Store({
		proxy: obj.LocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.Loc = new Ext.form.ComboBox({
		id : 'Loc'
		,selectOnFocus : true
		,forceSelection : true
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '科室'
		,store : obj.LocStore
		,mode : 'local'
		,typeAhead : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
});
	obj.WardStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.WardStore = new Ext.data.Store({
		proxy: obj.WardStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.Ward = new Ext.form.ComboBox({
		id : 'Ward'
		,selectOnFocus : true
		,forceSelection : true
		,minChars : 1
		,displayField : 'Desc'
		,fieldLabel : '病区'
		,mode : 'local'
		,store : obj.WardStore
		,typeAhead : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
});
	obj.EasyInfect = new Ext.form.Checkbox({
		id : 'EasyInfect'
		,fieldLabel : '有易感因素'
		,anchor : '95%'
});
	obj.CenterPanel = new Ext.Panel({
		id : 'CenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .4
		,layout : 'form'
		,items:[
			obj.Loc
			,obj.Ward
			,obj.EasyInfect
		]
	});
	obj.LeftPanel = new Ext.Panel({
		id : 'LeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,items:[
		]
	});
	obj.QryPanel = new Ext.Panel({
		id : 'QryPanel'
		,buttonAlign : 'center'
		,layout : 'column'
		,items:[
			obj.RightPanel
			,obj.CenterPanel
			,obj.LeftPanel
		]
	});
	obj.BtnFind = new Ext.Button({
		id : 'BtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.QryFPanel = new Ext.form.FormPanel({
		id : 'QryFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 150
		,region : 'north'
		,frame : true
		,title : '在院患者查询'
		,items:[
			obj.QryPanel
		]
	,	buttons:[
			obj.BtnFind
		]
	});
	obj.InPatientGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.InPatientGridStore = new Ext.data.Store({
		proxy: obj.InPatientGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RegNo'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RegNo', mapping: 'RegNo'}
			,{name: 'PatientName', mapping: 'PatientName'}
			,{name: 'Age', mapping: 'Age'}
			,{name: 'Sex', mapping: 'Sex'}
			,{name: 'AdmitDate', mapping: 'AdmitDate'}
			,{name: 'Room', mapping: 'Room'}
			,{name: 'Bed', mapping: 'Bed'}
			,{name: 'DoctorName', mapping: 'DoctorName'}
			,{name: 'Paadm', mapping: 'Paadm'}
			,{name: 'Department', mapping: 'Department'}
			,{name: 'Ward', mapping: 'Ward'}
		])
	});
	obj.InPatientGridCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.InPatientGrid = new Ext.grid.GridPanel({
		id : 'InPatientGrid'
		,store : obj.InPatientGridStore
		,buttonAlign : 'center'
		,region : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '登记号', width: 80, dataIndex: 'RegNo', sortable: true}
			,{header: '姓名', width: 100, dataIndex: 'PatientName', sortable: true}
			,{header: '年龄', width: 60, dataIndex: 'Age', sortable: true}
			,{header: '性别', width: 60, dataIndex: 'Sex', sortable: true}
			,{header: '住院日期', width: 120, dataIndex: 'AdmitDate', sortable: true}
			,{header: '主管医生', width: 120, dataIndex: 'DoctorName', sortable: true}
			,{header: '科室', width: 120, dataIndex: 'Department', sortable: true}
			,{header: '病区', width: 120, dataIndex: 'Ward', sortable: true}
			,{header: '病床', width: 120, dataIndex: 'Bed', sortable: true}
		]		
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.InPatientGridStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		});
	obj.winViewport = new Ext.Viewport({
		id : 'winViewport'
		,layout : 'border'
		,items:[
			obj.QryFPanel
			,obj.InPatientGrid
		]
	});
	obj.LocStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.InPatientQry';
			param.QueryName = 'QueryCtloc';
			param.Arg1 = 'E';
			param.ArgCnt = 1;
	});
	obj.LocStore.load({});
	obj.WardStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.InPatientQry';
			param.QueryName = 'QueryAllWard';
			param.ArgCnt = 0;
	});
	obj.WardStore.load({});
	obj.InPatientGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.InPatientQry';
			param.QueryName = 'QueryCurrentInPatient';
			param.Arg1 = obj.Loc.getValue();
			param.Arg2 = obj.Ward.getValue();
			param.Arg3 = "I";   // 住院类型 I/O/E  以"/"分割
			param.ArgCnt = 3;
	});
	InitwinViewportEvent(obj);
	//事件处理代码
  obj.LoadEvent(arguments);
  obj.Loc.on("select",obj.ComBox_select,obj);
  obj.Ward.on("select",obj.ComBox_select,obj);
  obj.EasyInfect.on("check",obj.ComBox_select,obj);
  obj.InPatientGrid.on("rowcontextmenu", obj.InPatientGrid_rowcontextmenu, obj);
  obj.BtnFind.on("click", obj.BtnFind_click, obj);
  return obj;
}

