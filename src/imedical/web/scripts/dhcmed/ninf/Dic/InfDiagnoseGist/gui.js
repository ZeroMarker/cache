
function  InitwinScreen()
{
	var obj = new Object();
    obj.RecRowID = "";
	obj.InfDiagnosID = "";
	obj.InfDiagnosDesc = "";
    var objRec = arguments[0];
	if (objRec){
		obj.InfDiagnosID = objRec.get("RowID");
		obj.InfDiagnosDesc = objRec.get("IDDesc");
	}
	
	obj.CboIDGType = Common_ComboToDic("CboIDGType","类型","NINFDiagType");
	obj.txtIDGCode = Common_TextField("txtIDGCode","代码");
	obj.txtIDGDesc = Common_TextArea("txtIDGDesc","诊断标准",50);
	
	obj.gridInfDiagnoseGistStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridInfDiagnoseGistStore = new Ext.data.Store({
		proxy: obj.gridInfDiagnoseGistStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total'
			,idProperty: 'IDGRowID'                     
		},
		[
			{name: 'IDGRowID', mapping : 'IDGRowID'}     
			,{name: 'IDGTypeID', mapping: 'IDGTypeID'}
			,{name: 'IDGTypeDesc', mapping: 'IDGTypeDesc'}
			,{name: 'IDGCode', mapping: 'IDGCode'}
			,{name: 'IDGDesc', mapping: 'IDGDesc'}
		])
	});
	obj.gridInfDiagnoseGist = new Ext.grid.EditorGridPanel({
		id : 'gridInfDiagnoseGist'
		,store : obj.gridInfDiagnoseGistStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '类型', width: 70, dataIndex: 'IDGTypeDesc', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '代码', width: 50, dataIndex: 'IDGCode', sortable: false, menuDisabled:true, align: 'center'}
			,{header: '诊断标准', width:200, dataIndex: 'IDGDesc', sortable: false, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	obj.btnSaveToGist = new Ext.Button({
		id : 'winfBtnSave'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.btnDeleteToGist = new Ext.Button({
		id : 'btnDeleteToGist'
		,iconCls : 'icon-delete'
		,text : '删除'
	});
    obj.btnExitToGist = new Ext.Button({
		id : 'btnExitToGist'
		,iconCls : 'icon-exit'
		,text : '退出'
	});
    obj.winPanel = new Ext.Panel({
		id : 'winPanel'
		,layout : 'fit'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'south',
						height: 100,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width:300
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.CboIDGType]
									},{
										columnwidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 50
										,items : [obj.txtIDGCode]
									}
									]
							},{
								layout : 'column',
								items : [
								{ 
								       columnWidth:1
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtIDGDesc]
								}	
                           ]
						}
					]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridInfDiagnoseGist
						]
					}
				],
				bbar : [obj.btnSaveToGist,obj.btnDeleteToGist,obj.btnExitToGist,'->','…']
			}
		]
	});
	
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 500
		,buttonAlign : 'center'
		,width : 650
		,modal : true
		,title : obj.InfDiagnosDesc + '的诊断标准'
		,layout : 'fit'
		,items:[
			obj.winPanel
		]
	});
	
	obj.gridInfDiagnoseGistStoreProxy.on('beforeload', function(objProxy, param){        
		param.ClassName = 'DHCMed.NINFService.Dic.InfDiagnoseGist';                   //传入的类名
		param.QueryName = 'QryInfDiagnoseGist';                                       //query名
		param.Arg1 = obj.InfDiagnosID;                                                //输入的参数
		param.ArgCnt = 1;                                                             //参数的数量
	});
	
	InitwinScreenEvent(obj);
  	obj.LoadEvent(arguments);
	return obj;
}
