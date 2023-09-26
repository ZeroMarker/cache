var objScreen = new Object();
function InitViewport1(){
	var obj = new Object();
	objScreen = obj;
	
	obj.cboHospital = Common_ComboToSSHospAA("cboHospital","医院",SSHospCode,"NINF");
	
	obj.cboSurvMethod = new Ext.form.ComboBox({
		id : 'cboSurvMethod'
		,minChars : 0
		,emptyText : '请选择...'
		,displayField : 'displayText'
		,fieldLabel : '调查方法'
		,editable : false
		,triggerAction : 'all'
		,anchor : '100%'
		,valueField : 'myId'
		,mode: 'local'
		,store: new Ext.data.ArrayStore({
		   fields: ['myId','displayText'],
		   data: [[1, '全院统一开展'],[2, '分科依次开展']]
		})
	});	
	obj.dtFromDate = new Ext.form.DateField({
		id : 'dtFromDate',
		//format : 'Y-m-d',
		format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat),
		fieldLabel : '开始日期',
		anchor : '100%',
		altFormats : 'Y-m-d|d/m/Y'
	});
	obj.dtToDate = new Ext.form.DateField({
		id : 'dtToDate',
		//format : 'Y-m-d',
		format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat),
		fieldLabel : '结束日期',
		anchor : '100%',
		altFormats : 'Y-m-d|d/m/Y'
	});
	obj.txtResume=new Ext.form.TextField({
		id:'txtResume'
		,fieldLabel:'备注'
		,anchor : '100%'
	});
	obj.btnSave =new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-update'
		,text : '更新'
		,width : 70
	});
	obj.btnQuery =new Ext.Button({
		id : 'btnQuery'
		,iconCls : 'icon-find'
		,text : '查询'
		,width : 70
	});
	
	obj.ViewPanel = new Ext.FormPanel({
		id : 'ViewPanel'
		,height : 100
		,region : 'north'
		,frame : true
		,title : '横断面调查方法执行登记表'
		,layout : 'form'
		,items:[
			{
				layout : 'column'
				,items : [
					{
						width : 200
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items : [obj.cboHospital]
					},{
						width : 180
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items : [obj.cboSurvMethod]
					},{
						width : 180
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items : [obj.dtFromDate]
					},{
						width : 180
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items : [obj.dtToDate]
					}
				]
			},{
				layout : 'column'
				,items : [
					{
						width : 740
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items : [obj.txtResume]
					},{
						width : 10
						,height : 1
					},{
						width : 70
						,layout : 'form'
						,items : [obj.btnQuery]
					},{
						width : 10
						,height : 1
					},{
						width : 70
						,layout : 'form'
						,items : [obj.btnSave]
					}
				]
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
			idProperty: 'Ind'
		},[
			{name: 'Ind', mapping: 'Ind'}
			,{name: 'RowID', mapping: 'RowID'}
			,{name: 'SESurvNumber', mapping: 'SESurvNumber'}
			,{name: 'SEHospCode', mapping: 'SEHospCode'}
			,{name: 'SEHospDR', mapping: 'SEHospDR'}			
			,{name: 'SEHospDesc', mapping: 'SEHospDesc'}
			,{name: 'SESurvMethodDR', mapping: 'SESurvMethodDR'}
			,{name: 'SESurvMethod', mapping: 'SESurvMethod'}
			,{name: 'SESurvSttDate', mapping: 'SESurvSttDate'}
			,{name: 'SESurvEndDate', mapping: 'SESurvEndDate'}
			,{name: 'SEUpdateDate', mapping: 'SEUpdateDate'}
			,{name: 'SEUpdateTime', mapping: 'SEUpdateTime'}
			,{name: 'SEUpdateUser', mapping: 'SEUpdateUser'}
			,{name: 'SEUserCode', mapping: 'SEUserCode'}
			,{name: 'SEUserName', mapping: 'SEUserName'}
			,{name: 'SEResume', mapping: 'SEResume'}
		])
	});
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'GridPanel'
		,buttonAlign : 'center'
		,store : obj.GridPanelStore
		,loadMask : true
		,region : 'center'
		,frame : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ID', width: 60, dataIndex: 'RowID', sortable: true,hidden:true}
			,{header: '调查编号', width: 100, dataIndex: 'SESurvNumber', sortable: true}
			,{header: '医院', width: 150, dataIndex: 'SEHospDesc', sortable: true}
			,{header: '调查方法', width: 120, dataIndex: 'SESurvMethod', sortable: true}
			,{header: '调查开始日期', width: 100, dataIndex: 'SESurvSttDate', sortable: true}
			,{header: '调查结束日期', width: 100, dataIndex: 'SESurvEndDate', sortable: true}
			,{header: '更新日期', width: 100, dataIndex: 'SEUpdateDate', sortable: true}
			,{header: '更新时间', width: 80, dataIndex: 'SEUpdateTime', sortable: true}
			,{header: '操作员', width: 80, dataIndex: 'SEUserName', sortable: true}
			,{header: '备注', width: 200, dataIndex: 'SEResume' }
		]
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
	
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.CSS.Service';
		param.QueryName = 'QrySurvExec';
		param.Arg1 = Common_GetValue('cboHospital');
		param.Arg2 = Common_GetValue('cboSurvMethod');
		param.Arg3 = Common_GetValue('dtFromDate');
		param.Arg4 = Common_GetValue('dtToDate');
		param.ArgCnt = 4;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}


