
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtDesc = Common_TextField("txtDesc","名称");
	obj.txtResume = Common_TextField("txtResume","备注");

	obj.gridWorkItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridWorkItemStore = new Ext.data.Store({
		proxy: obj.gridWorkItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping : 'Id'}
			,{name: 'WCode', mapping : 'WCode'}
			,{name: 'WDesc', mapping: 'WDesc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.gridWorkItem = new Ext.grid.EditorGridPanel({
		id : 'gridWorkItem'
		,store : obj.gridWorkItemStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '代码', width: 80, dataIndex: 'WCode', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '名称', width: 200, dataIndex: 'WDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 280, dataIndex: 'Resume', sortable: true, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridWorkItemStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
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
						labelWidth : 70,
						items : [
							{
								layout : 'column',
								items : [
									{
										columnWidth:.15
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtCode]
									},{
										columnWidth:.25
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtDesc]
									},{
										columnWidth:.35
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
						//frame : true,
						items : [
							obj.gridWorkItem
						]
					}
				],
				bbar : [obj.btnUpdate,'->','…']   //fix Bug 6596 by pylian 不再允许删除操作项目
			}
		]
	});
	
	obj.gridWorkItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.SSService.WorkItemSrv"
		param.QueryName = "QryWorkItem"
		
		param.ArgCnt = 0
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

