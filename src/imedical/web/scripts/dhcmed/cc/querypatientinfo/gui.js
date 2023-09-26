function InitwinViewport(){
	var obj = new Object();
	obj.LeftPanel = new Ext.Panel({
		id : 'LeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.InHospital = new Ext.form.Checkbox({
		id : 'InHospital'
		,checked : true
		,fieldLabel : '在院/出院'
		,anchor : '95%'
});
	obj.MrNo = new Ext.form.TextField({
		id : 'MrNo'
		,fieldLabel : '病案号'
		,anchor : '95%'
});
	obj.RegNo = new Ext.form.TextField({
		id : 'RegNo'
		,fieldLabel : '登记号'
		,anchor : '95%'
});
	obj.DateFrom = new Ext.form.DateField({
		id : 'DateFrom'
		,fieldLabel : '开始日期'
		,anchor : '95%'
		,format: 'Y-m-d'
});
	obj.DateTo = new Ext.form.DateField({
		id : 'DateTo'
		,fieldLabel : '结束日期'
		,anchor : '95%'
		,format: 'Y-m-d'
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
		,mode : 'local'
		,store : obj.LocStore
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
		,store : obj.WardStore
		,mode : 'local'
		,typeAhead : true
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'Rowid'
});
	obj.bed = new Ext.form.ComboBox({
		id : 'bed'
		,minChars : 1
		,fieldLabel : '床号'
		,anchor : '95%'
		,triggerAction : 'all'
});
	obj.PatName = new Ext.form.TextField({
		id : 'PatName'
		,fieldLabel : '姓名'
		,anchor : '95%'
});
	obj.CardNo = new Ext.form.TextField({
		id : 'CardNo'
		,fieldLabel : '卡号'
		,anchor : '95%'
});
	obj.BtnFind = new Ext.Button({
		id : 'BtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.CenterPanel = new Ext.Panel({
		id : 'CenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items:[
			obj.InHospital
			,obj.CardNo
			,obj.RegNo
			,obj.MrNo
			,obj.PatName
			,obj.Loc
			,obj.Ward
			,obj.DateFrom
			,obj.DateTo
		],buttons:[
			obj.BtnFind
		]
	});
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	/*		1		************横向显示查询条件****************
	obj.ColumnPanel1 = new Ext.Panel({
		id : 'ColumnPanel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,items:[
		]
	});
	obj.ColumnPanel2 = new Ext.Panel({
		id : 'ColumnPanel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.InHospital
			,obj.CardNo
			,obj.RegNo
		]
	});
	
	obj.ColumnPanel3 = new Ext.Panel({
		id : 'ColumnPanel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.MrNo
			,obj.Loc
			,obj.Ward
		]
	});
	obj.ColumnPanel4 = new Ext.Panel({
		id : 'ColumnPanel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.PatName
			,obj.DateFrom
			,obj.DateTo
		]
	});
	obj.ColumnPanel5 = new Ext.Panel({
		id : 'ColumnPanel5'
		,buttonAlign : 'center'
		,columnWidth : .2
		,items:[
		]
	});
	obj.QryFPanelNorth = new Ext.form.FormPanel({
		id : 'QryFPanelNorth'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 70
		,title : '病人信息查询'
		,collapsible : true
		,region : 'north'
		,layout : 'column'
		,frame : true
		,height : 180
		,items:[
			obj.ColumnPanel1
			,obj.ColumnPanel2
			,obj.ColumnPanel3
			,obj.ColumnPanel4
			,obj.ColumnPanel5
		],buttons:[
			obj.BtnFind
		]
	});
	*/
	obj.QryFPanel = new Ext.form.FormPanel({
		id : 'QryFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 70
		,title : '病人信息查询'
		,collapsible : true
		,region : 'west'
		,layout : 'column'
		,frame : true
		,width : 280
		,items:[
			obj.LeftPanel
			,obj.CenterPanel
			,obj.RightPanel
		]
	});
	obj.PatListGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PatListGridStore = new Ext.data.Store({
		proxy: obj.PatListGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: ''
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
			,{name: 'DisDate', mapping: 'DisDate'}
		])
	});
	obj.PatListGridCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.PatListGrid = new Ext.grid.GridPanel({
		id : 'PatListGrid'
		,store : obj.PatListGridStore
		,buttonAlign : 'center'
		,region : 'center'
		,title : '病人列表'
		,columns: [
			new Ext.grid.RowNumberer()
			//,{header: '就诊号', width: 80, dataIndex: 'Paadm', sortable: true}
			,{header: '登记号', width: 80, dataIndex: 'RegNo', sortable: true}
			,{header: '患者姓名', width: 100, dataIndex: 'PatientName', sortable: true}
			,{header: '年龄', width: 60, dataIndex: 'Age', sortable: true}
			,{header: '性别', width: 60, dataIndex: 'Sex', sortable: true}
			,{header: '主管医生', width: 120, dataIndex: 'DoctorName', sortable: true}
			,{header: '科室', width: 120, dataIndex: 'Department', sortable: true}
			,{header: '病区', width: 120, dataIndex: 'Ward', sortable: true}
			,{header: '病床', width: 120, dataIndex: 'Bed', sortable: true}
			,{header: '住院日期', width: 96, dataIndex: 'AdmitDate', sortable: true}
			,{header: '出院日期', width: 96, dataIndex: 'DisDate', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.PatListGridStore,
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
			//obj.QryFPanelNorth	//把 obj.QryFPanel注释掉，解除本行注释及"1"处注释就可以横向显示查询条件
			,obj.PatListGrid
			
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
	obj.PatListGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.QryPatientInfo';
			param.QueryName = 'QueryPatientInfo';
			param.Arg1 = (obj.InHospital.getValue()? "A":"D");		//是否在院
			param.Arg2 = obj.MrNo.getValue();
			param.Arg3 = obj.RegNo.getValue();
			param.Arg4 = obj.DateFrom.getValue();
			param.Arg5 = obj.DateTo.getValue();
			param.Arg6 = obj.Loc.getValue();
			param.Arg7 = obj.Ward.getValue();
			param.Arg8 = obj.PatName.getValue();
			param.Arg9 = obj.CardNo.getValue();
			param.Arg10 = "I";		// 住院类型 I/O/E  以"/"分割
			param.ArgCnt = 10;
	});
	InitwinViewportEvent(obj);
	//事件处理代码
	obj.PatListGrid.on("rowcontextmenu", obj.PatListGrid_rowcontextmenu, obj);
	obj.BtnFind.on("click", obj.BtnFind_click, obj);
	obj.RegNo.on("specialkey", obj.Text_specialkey, obj);
	obj.CardNo.on("specialkey", obj.Text_specialkey, obj);
	obj.MrNo.on("specialkey", obj.Text_specialkey, obj);
	obj.PatName.on("specialkey", obj.Text_specialkey, obj);
  	obj.LoadEvent(arguments);
  	return obj;
}

