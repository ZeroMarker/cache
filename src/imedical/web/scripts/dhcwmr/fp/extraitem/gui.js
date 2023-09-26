
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.txtCode = Common_TextField("txtCode","代码");
	obj.txtDesc = Common_TextField("txtDesc","描述");
	obj.cboType = Common_ComboToDic("cboType","数据类型","DataType");
	obj.cboDicCode = Common_ComboToDic("cboDicCode","字典","SYS");
	obj.txtResume = Common_TextField("txtResume","备注");
	
	obj.gridExtraItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridExtraItemStore = new Ext.data.Store({
		proxy: obj.gridExtraItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ItemID'
		},
		[
			{name: 'ItemID', mapping : 'ItemID'}
			,{name: 'ItemCode', mapping : 'ItemCode'}
			,{name: 'ItemDesc', mapping: 'ItemDesc'}
			,{name: 'TypeID', mapping: 'TypeID'}
			,{name: 'TypeCode', mapping: 'TypeCode'}
			,{name: 'TypeDesc', mapping: 'TypeDesc'}
			,{name: 'DicID', mapping: 'DicID'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.gridExtraItem = new Ext.grid.EditorGridPanel({
		id : 'gridExtraItem'
		,store : obj.gridExtraItemStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 80, dataIndex: 'ItemCode', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '描述', width: 150, dataIndex: 'ItemDesc', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '数据类型', width: 120, dataIndex: 'TypeDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '字典', width: 200, dataIndex: 'DicDesc', sortable: true, menuDisabled:true, align: 'left'}
			,{header: '备注', width: 200, dataIndex: 'Resume', sortable: true, menuDisabled:true, align: 'left'} //update by pylian 修改编目附加项“备注”不能更新问题
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.gridExtraItemStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
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
						height: 35,
						layout : 'column',
						frame : true,
						items : [
							{
								width : 100
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
								width : 150
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 70
								,items: [obj.cboType]
							},{
								width : 240
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 40
								,items: [obj.cboDicCode]
							},{
								columnWidth:.98
								,layout : 'form'
								,labelAlign : 'right'
								,labelWidth : 40
								,items: [obj.txtResume]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						//frame : true,
						items : [
							obj.gridExtraItem
						]
					}
				],
				bbar : [obj.btnUpdate,obj.btnDelete,'->','…']
			}
		]
	});
	
	obj.gridExtraItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = "DHCWMR.FP.ExtraItem"
		param.QueryName = "QryExtraItem"
		param.ArgCnt = 0
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

