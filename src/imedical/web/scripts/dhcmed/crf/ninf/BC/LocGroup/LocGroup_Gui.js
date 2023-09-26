
function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = "";
	obj.chkDisplayAll = Common_Checkbox("chkDisplayAll","显示全部");
	obj.txtDeptDesc = Common_TextField("txtDeptDesc","科室");
	obj.txtLocGrpDesc = Common_TextField("txtLocGrpDesc","科室组");
	obj.chkICUFlag = Common_Checkbox("chkICUFlag","ICU科室");
	obj.chkOperFlag = Common_Checkbox("chkOperFlag","手术科室");
	
	obj.GridLocGroupStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.GridLocGroupStore = new Ext.data.Store({
		proxy: obj.GridLocGroupStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DeptCode'
		},
		[
			{name: 'LocGrpID', mapping : 'LocGrpID'}
			,{name: 'DeptCode', mapping : 'DeptCode'}
			,{name: 'DeptDesc', mapping: 'DeptDesc'}
			,{name: 'HospCode', mapping: 'HospCode'}
			,{name: 'HospDesc', mapping: 'HospDesc'}
			,{name: 'LocType', mapping: 'LocType'}
			,{name: 'LocGroup', mapping: 'LocGroup'}
			,{name: 'ICUFlag', mapping: 'ICUFlag'}
			,{name: 'ICUFlagDesc', mapping: 'ICUFlagDesc'}
			,{name: 'OperFlag', mapping: 'OperFlag'}
			,{name: 'OperFlagDesc', mapping: 'OperFlagDesc'}
			,{name: 'ErrFlag', mapping: 'ErrFlag'}
		])
	});
	obj.GridLocGroup = new Ext.grid.EditorGridPanel({
		id : 'GridLocGroup'
		,store : obj.GridLocGroupStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '科室', width: 150, dataIndex: 'DeptDesc', sortable: true, menuDisabled:false, align: 'left'}
			,{header: '科室<br>类型', width: 70, dataIndex: 'LocType', sortable: true, menuDisabled:false, align: 'center'}
			,{header: '科室组', width:150, dataIndex: 'LocGroup', sortable: true, menuDisabled:false, align: 'left'}
			,{header: 'ICU科室', width: 70, dataIndex: 'ICUFlagDesc', sortable: true, menuDisabled:false, align: 'center'}
			,{header: '手术科室', width:70, dataIndex: 'OperFlagDesc', sortable: true, menuDisabled:false, align: 'center'}
			,{header: '医院', width: 150, dataIndex: 'HospDesc', sortable: true, menuDisabled:false, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 25,
			store : obj.GridLocGroupStore,
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
		,iconCls : 'icon-edit'
		,width: 80
		,text : '更新'
	});
	
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-Delete'
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
										width : 120
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.chkDisplayAll]
									},{
										width : 240
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 40
										,items: [obj.txtDeptDesc]
									},{
										width : 200
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 60
										,items: [obj.txtLocGrpDesc]
									},{
										width : 100
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.chkICUFlag]
									},{
										width : 100
										,layout : 'form'
										,labelAlign : 'right'
										,labelWidth : 70
										,items: [obj.chkOperFlag]
									},{
										width : 10
									},{
										width : 80
										,layout : 'form'
										,items: [obj.btnUpdate]
									},{
										width : 10
									},{
										width : 80
										,layout : 'form'
										,items: [obj.btnDelete]
									},{
										width : 10
									},{
										width : 80
										,layout : 'form'
										,items: [obj.btnFind]
									}
								]
							}
						]
					},{
						region: 'center',
						layout : 'fit',
						items : [
							obj.GridLocGroup
						]
					}
				]
			}
		]
	});
	
	obj.GridLocGroupStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINFService.BC.LocGroupSrv';
		param.QueryName = 'QryLocGroupList';
		var IsDisplayAll = Common_GetValue("chkDisplayAll");
		if (IsDisplayAll) {
			param.Arg1 = 1;
		} else {
			param.Arg1 = 0;
		}
		param.Arg2 = LogonHospID;
		param.Arg3 = Common_GetValue("txtLocGrpDesc");
		param.Arg4 = Common_GetValue("txtDeptDesc");
		param.ArgCnt = 4;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

