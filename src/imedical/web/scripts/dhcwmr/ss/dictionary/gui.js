function InitViewport1(){
	var obj = new Object();
	obj.RecRowID = '';
	obj.DicType = '';
	
	obj.btnDicTpAdd = new Ext.Toolbar.Button({
		id : 'btnDicTpAdd'
		,iconCls : 'icon-add'
		,width: 80
		,text : '添加'
	});
	
	obj.btnDicTpEdit = new Ext.Toolbar.Button({
		id : 'btnDicTpEdit'
		,iconCls : 'icon-edit'
		,width: 80
		,text : '编辑'
	});
	
	obj.Code = Common_TextField("Code","代码");
	obj.Desc = Common_TextField("Desc","描述");
	obj.cboHospId = Common_ComboToCTHosp("cboHospId","医院");
	obj.DicIsActive  = Common_Checkbox("DicIsActive","是否有效");
	obj.DicResume = Common_TextField("DicResume","备注");
	
	//字典类别
	obj.gridDicTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridDicTypeStore = new Ext.data.Store({
		proxy: obj.gridDicTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DicRowID'
		},
		[
			{name: 'DicRowID', mapping : 'DicRowID'}
			,{name: 'DicCode', mapping : 'DicCode'}
			,{name: 'DicDesc', mapping: 'DicDesc'}
			,{name: 'DicType', mapping: 'DicType'}
			,{name: 'HospDr', mapping: 'HospDr'}
			,{name: 'HospDesc', mapping: 'HospDesc'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'Resume', mapping: 'Resume'}
		])
		,sortInfo:{field: 'DicDesc', direction: "ASC"}
	});
	obj.gridDicType = new Ext.grid.EditorGridPanel({
		id : 'gridDicType'
		,store : obj.gridDicTypeStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,autoScroll : true
		,region : 'center'
		,loadMask : true
		,tbar : ['系统字典']
		,bbar : [obj.btnDicTpAdd,obj.btnDicTpEdit]
		,columns: [
			{header: '', width: 60, dataIndex: 'DicDesc', sortable: true, menuDisabled:true, align: 'left'}
		]
		,viewConfig : {
			forceFit : true
		}
	});
	
	//字典项
	obj.gridDicItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridDicItemCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.gridDicItemStore = new Ext.data.Store({
		proxy: obj.gridDicItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowID'
		},
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RowID', mapping : 'DicRowID'}
			,{name: 'DicsCode', mapping : 'DicCode'}
			,{name: 'DicsDesc', mapping: 'DicDesc'}
			,{name: 'DicsType', mapping: 'DicType'}
			,{name: 'HospsDr', mapping: 'HospDr'}
			,{name: 'HospsDesc', mapping: 'HospDesc'}
			,{name: 'aIsActive', mapping: 'IsActive'}
			,{name: 'DicResume', mapping: 'Resume'}
		])
	});
	obj.gridDicItem = new Ext.grid.EditorGridPanel({
		id : 'gridDicItem'
		,store : obj.gridDicItemStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,tbar : ['字典项目']
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 30, dataIndex: 'DicsCode', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '描述', width: 80, dataIndex: 'DicsDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '是否有效', width: 60, dataIndex: 'aIsActive', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '医院', width: 100, dataIndex: 'HospsDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '备注', width: 80, dataIndex: 'DicResume', sortable: true, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 30,
			store : obj.gridDicItemStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
    });
    
	obj.btnUpdate = new Ext.Toolbar.Button({
		id : 'btnUpdate'
		,iconCls : 'icon-save'
		,width: 80
		,text : '保存'
	});
	
	obj.btnDelete = new Ext.Toolbar.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,width: 80
		,text : '删除'
	});
	//字典类别panel
	obj.DicTypePanel = new Ext.Panel({
		buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,items:[
			{
				layout : 'fit'
				,region : 'center'
				,items:[obj.gridDicType]
			}
		]
	});
	
	obj.DicItemPanel = new Ext.Panel({
		region : 'center'
		,layout : 'border'
		,items:[
			{
				layout : 'fit'
				,region : 'center'
				,width:600 
				,items:[obj.gridDicItem]
			},{
				layout : 'fit'
				,region : 'south'
				,height : 40
				,frame : true
				,items :[
				{
					layout : 'column',
					items : [
					{
						width : 120
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.Code]
					},{
						width : 150
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.Desc]
					},{
						width : 220
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.cboHospId]
					},{
						width : 100
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.DicIsActive]
					},{
						width : 280
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.DicResume]
					}]
				}]
			}
		],bbar : [obj.btnUpdate,obj.btnDelete,'->','…']
	});
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			{
				layout : 'fit'
				,region : 'west'
				,width:200 	
				,items:[obj.DicTypePanel]
			},{
				layout : 'fit'
				,region : 'center'
				,items:[obj.DicItemPanel]
			}
		]
	});
	
	obj.gridDicTypeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.DictionarySrv';
		param.QueryName = 'QryDicByType';
		param.Arg1 = "SYS";
		param.Arg2 = "";
		param.Arg3 = "";
		param.ArgCnt = 3;
	});
	
	obj.gridDicItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.SSService.DictionarySrv';
		param.QueryName = 'QryDicByType';
		param.Arg1 = obj.DicType;
		param.Arg2 = "";
		param.Arg3 = "";
		param.ArgCnt = 3;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

function InitWinEdit(objDic){
	var obj = new Object();
	obj.objDic = objDic;
	obj.DicID = '';
	//窗口组件
	obj.DicCode =  Common_TextField("DicCode","代码");
	obj.DicDesc =  Common_TextField("DicDesc","描述");
	obj.IsActive =  Common_Checkbox("IsActive","是否有效");
	obj.Resume =  Common_TextField("Resume","备注");
	
	obj.winfPanel = new Ext.Panel({
		id : 'winfPanel'
		,layout : 'form'
		,region : 'center'
		,frame : true
		,labelAlign : 'right'
		,labelWidth : 80
		,items:[
			obj.DicCode
			,obj.DicDesc
			,obj.IsActive
			,obj.Resume
		]
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-undo'
		,text : '取消'
	});
	obj.WinEdit = new Ext.Window({
		id : 'WinEdit'
		,width : 400
		,plain : true
		,buttonAlign : 'center'
		,height : 300
		,title : '基础字典编辑'
		,layout : 'fit'
		,modal : true
		,items:[
			obj.winfPanel
		]
		,buttons:[
			obj.btnSave
			,obj.btnCancel
		]
	});
	InitWinEditEvent(obj);
    obj.LoadEvent(arguments);
    return obj;
}
