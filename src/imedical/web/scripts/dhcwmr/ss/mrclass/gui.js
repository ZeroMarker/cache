
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.MrCode   = "";
	obj.MrDesc   = "";
	
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtDesc = Common_TextField("txtDesc","描述");
	obj.txtResume = Common_TextField("txtResume","备注");
	
	obj.GridMrClassStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridMrClassStore = new Ext.data.Store({
		proxy: obj.GridMrClassStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'MrID'
		},
		[
			{name: 'MrID', mapping : 'MrID'}
			,{name: 'MrCode', mapping : 'MrCode'}
			,{name: 'MrDesc', mapping: 'MrDesc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.GridMrClass = new Ext.grid.EditorGridPanel({
		id : 'GridMrClass'
		,store : obj.GridMrClassStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '代码', width: 60, dataIndex: 'MrCode', sortable: true, menuDisabled:false, align: 'center'}
			,{header: '描述', width: 100, dataIndex: 'MrDesc', sortable: true, menuDisabled:false, align: 'center'}
			,{header: '备注', width: 300, dataIndex: 'Resume', sortable: true, menuDisabled:false, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 25,
			store : obj.GridMrClassStore,
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
						height: 75,
						layout : 'form',
						frame : true,
						items : [
							{
								layout : 'column',
								items : [
									{
										width : 240
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtCode]
									},{
										width : 240
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtDesc]
									},{
										width : 300
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtResume]
									}
								]
							}
						]
						,bbar : [obj.btnUpdate,obj.btnDelete]
					},{
						region: 'center',
						layout : 'fit',
						items : [
							obj.GridMrClass
						]
					}
				]
			}
		]
	});
	
	obj.GridMrClassStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.SSService.MrClassSrv"
		param.QueryName = "QryMrClass"
		param.Arg1 = obj.MrCode
		param.ArgCnt = 1
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

