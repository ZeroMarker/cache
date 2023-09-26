function InitViewport1(){
	var obj = new Object();	
	
	obj.cboSurvNumberStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboSurvNumberStore = new Ext.data.Store({
		proxy : obj.cboSurvNumberStoreProxy,
		reader : new Ext.data.JsonReader({
			root : 'record',
			totalProperty : 'total',
			idProperty : 'rowid'
		}, [
			{name: 'RowID', mapping: 'RowID'}
			,{name: 'SESurvNumber', mapping: 'SESurvNumber'}
			,{name: 'SEHospCode', mapping: 'SEHospCode'}
			,{name: 'SEHospDR', mapping: 'SEHospDR'}			
			,{name: 'SEHospDesc', mapping: 'SEHospDesc'}
			,{name: 'SESurvMethodDR', mapping: 'SESurvMethodDR'}
			,{name: 'SESurvMethod', mapping: 'SESurvMethod'}
			,{name: 'SESurvSttDate', mapping: 'SESurvSttDate'}
			,{name: 'SESurvEndDate', mapping: 'SESurvEndDate'}
		])
	});
	obj.cboSurvNumber = new Ext.form.ComboBox({
		id : 'cboSurvNumber'
		,store : obj.cboSurvNumberStore
		,fieldLabel : '调查编号'
		,emptyText : '请选择...'
		,editable : false
		,minChars : 0
		,queryDelay:1
		,typeAhead : false
		,tpl: new Ext.XTemplate(
			'<table border="0" width="100%">',
				'<thead align="center"><tr>',
					'<th>调查编号</th>',
					'<th>医院</th>',
					'<th>调查方法</th>',
					'<th>开始日期</th>',
					'<th>结束日期</th>',
				'</tr></thead>',
				'<tpl for="."><tr class="x-combo-list-item">',
					'<td>{SESurvNumber}</td>',
					'<td>{SEHospDesc}</td>',
					'<td>{SESurvMethod}</td>',
					'<td>{SESurvSttDate}</td>',
					'<td>{SESurvEndDate}</td>',
				'</tr></tpl>',
			'</table>'
		)
		//,hideTrigger:true
		,triggerAction : 'all'
		//,itemSelector: 'div.search-item'
		,minListWidth:500
		,valueField : 'RowID'
		,displayField : 'SESurvNumber'
		,loadingText: '查询中,请稍等...'
		,width : 80
		,anchor : '100%'
	});
	
	obj.cboHospital = Common_ComboToSSHospAA("cboHospital","医院",SSHospCode,"NINF");
	obj.cboLoc = Common_ComboToLoc("cboLoc","科室","E","","I","cboHospital");
	
	obj.dtSurvDate = new Ext.form.DateField({
		id : 'dtSurvDate',
		format : 'Y-m-d',
		fieldLabel : '调查日期',
		anchor : '100%',
		altFormats : 'Y-m-d|d/m/Y'
	});
	
	obj.btnSave =new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-update'
		,text : '生成应查患者就诊记录'
	});
	
	obj.ViewPanel = new Ext.FormPanel({
		id : 'ViewPanel'
		,height : 60
		,region : 'north'
		,frame : true
		,title : '横断面床旁调查生成记录'
		,layout : 'column'
		,items:[
			{
				width : 200
				,layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 60
				,items: [obj.cboHospital]
			},{
				width : 200
				,layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 60
				,items: [obj.cboSurvNumber]
			},{
				width : 180
				,layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 60
				,items: [obj.dtSurvDate]
			},{
				width : 200
				,layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 40
				,items: [obj.cboLoc]
			},{
				width : 20
			},{
				width : 160
				,layout : 'form'
				,items: [obj.btnSave]
			}
		]
	});
	
	obj.GridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridPanelStore = new Ext.data.Store({
		proxy: obj.GridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		},[
			{name: 'RowID', mapping: 'RowID'}
			,{name: 'SurvNumber', mapping: 'SurvNumber'}
			,{name: 'SurvLoc', mapping: 'SurvLoc'}
			,{name: 'SurvLocDesc', mapping: 'SurvLocDesc'}
			,{name: 'SurvDate', mapping: 'SurvDate'}
			,{name: 'UpdateDate', mapping: 'UpdateDate'}
			,{name: 'UpdateTime', mapping: 'UpdateTime'}
			,{name: 'UpdateUser', mapping: 'UpdateUser'}
			,{name: 'UpdateUserName', mapping: 'UpdateUserName'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'GridPanel'
		,store : obj.GridPanelStore
		,loadMask : true
		,region : 'center'
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ID', width: 60, dataIndex: 'RowID', sortable: true,hidden:true}
			,{header: '调查编号', width: 100, dataIndex: 'SurvNumber', sortable: true}
			,{header: '调查日期', width: 80, dataIndex: 'SurvDate', sortable: true}
			,{header: '科室', width: 150, dataIndex: 'SurvLocDesc', sortable: true}
			,{header: '是否有效', width: 50, dataIndex: 'IsActive', sortable: true}
			,{header: '生成日期', width: 80, dataIndex: 'UpdateDate', sortable: true}
			,{header: '生成时间', width: 60, dataIndex: 'UpdateTime', sortable: true}
			,{header: '操作员', width: 60, dataIndex: 'UpdateUserName', sortable: true}
			,{header: '备注', width: 200, dataIndex: 'Resume'}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.GridPanelStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig: {
			forceFit: true
		}
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.ViewPanel,
			obj.GridPanel
		]
	});
	
	obj.cboSurvNumberStoreProxy.on('beforeload', function(objProxy, param) {
		param.ClassName = 'DHCMed.NINFService.CSS.Service';
		param.QueryName = 'QrySurvExec';
		param.Arg1 = Common_GetValue('cboHospital');
		param.ArgCnt = 1;
	});
	
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.CSS.Service';
		param.QueryName = 'QryBedSurvLog';
		param.Arg1 = Common_GetText('cboSurvNumber');
		param.ArgCnt = 1;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}


