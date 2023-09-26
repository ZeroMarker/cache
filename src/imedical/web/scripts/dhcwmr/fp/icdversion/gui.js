
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtDesc = Common_TextField("txtDesc","描述");
	obj.txtResume = Common_TextField("txtResume","备注");
	
	obj.GridICDVersionStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridICDVersionStore = new Ext.data.Store({
		proxy: obj.GridICDVersionStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping : 'Id'}
			,{name: 'ICDCode', mapping : 'Code'}
			,{name: 'ICDDesc', mapping: 'Desc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.GridICDVersion = new Ext.grid.EditorGridPanel({
		id : 'GridICDVersion'
		,store : obj.GridICDVersionStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 100, dataIndex: 'ICDCode', sortable: true, menuDisabled:false, align: 'left'}
			,{header: '描述', width: 150, dataIndex: 'ICDDesc', sortable: true, menuDisabled:false, align: 'left'}
			,{header: '备注', width: 300, dataIndex: 'Resume', sortable: true, menuDisabled:false, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 25,
			store : obj.GridICDVersionStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
	
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,width: 80
		,text : '查找'
	});
	
	obj.btnUpdate = new Ext.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-update'
		,width: 80
		,text : '更新'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width: 80
		,text : '删除'
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'fit'
		,items:[
			{
				region: 'center',
				layout : 'border',
				frame : true,
				items : [
					{
						region: 'south',
						height: 40,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 150
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtCode]
									},{
										width : 200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtDesc]
									},{
										width : 550
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtResume]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						items : [
							obj.GridICDVersion
						]
					}
				],
				bbar : [obj.btnUpdate,obj.btnDelete,'->']
			}
		]
	});
	
	obj.GridICDVersionStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.FP.ICDVersion"
		param.QueryName = "QryICDVersion"
		
		param.ArgCnt = 0
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

