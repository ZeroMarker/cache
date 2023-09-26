
function InitViewportCate(){
	var obj = new Object();
	obj.CateID=CateID;
	obj.CateCode=CateCode;
	
	obj.gridListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridListStore = new Ext.data.Store({
		proxy: obj.gridListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping : 'ID'}
			,{name: 'Code', mapping : 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
			,{name: 'HospitalDr', mapping: 'HospitalDr'}
			,{name: 'HOSPDesc', mapping: 'HOSPDesc'}
			,{name: 'Active', mapping: 'Active'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'StrA', mapping: 'StrA'}
			,{name: 'StrB', mapping: 'StrB'}
			,{name: 'StrC', mapping: 'StrC'}
			,{name: 'StrD', mapping: 'StrD'}
		])
	});
	
	obj.gridList = new Ext.grid.EditorGridPanel({
		id : 'gridList'
		,store : obj.gridListStore
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,columnLines : true
		,region : 'center'
		,loadMask : true
		,columns: [
			{header: '代码', width: 100, dataIndex: 'Code', menuDisabled:true, align: 'left'}
			,{header: '名称', width: 120, dataIndex: 'Description', menuDisabled:true, align: 'left'}
			,{header: '是否<br>有效', width: 60, dataIndex: 'Active', menuDisabled:true, align: 'center'
				,renderer: function(value, metaData, record, rowIndex, colIndex, store) {
					if (value=="1") {return "是"}
					else {return "否"}
				}
			}
			//,{header: '医院', width: 100, dataIndex: 'HOSPDesc', menuDisabled:true, align: 'center'}
			,{header: '起始日期', width: 80, dataIndex: 'DateFrom', menuDisabled:true, align: 'center'}
			,{header: '截止日期', width: 80, dataIndex: 'DateTo', menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[obj.gridList]
	});
	
	obj.gridListStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.NINF.Dic.Cate';
		param.QueryName = 'QueryByType02';
		param.Arg1 = obj.CateCode;
		param.Arg2 = '';
		param.ArgCnt = 2;
	});
	
	InitViewport1Event(obj);
	obj.LoadEvent(arguments);
	return obj;
}

function InitWinCateEdit(){
	var obj = new Object();
	obj.Code = new Ext.form.TextField({
		id : 'Code'
		,width : 100
		,allowBlank : false
		,fieldLabel : '代码'
		,disabled : true
		,anchor : '98%'
	});
	obj.Description = new Ext.form.TextField({
		id : 'Description'
		,width : 100
		,allowBlank : false
		,fieldLabel : '描述'
		,anchor : '98%'
	});
	obj.HispsDescsStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.HispsDescsStore = new Ext.data.Store({
		proxy: obj.HispsDescsStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'hosName', mapping: 'hosName'}
		])
	});
	obj.HispsDescs = new Ext.form.ComboBox({
		id : 'HispsDescs'
		,width : 100
		,store : obj.HispsDescsStore
		,minChars : 1
		,displayField : 'hosName'
		,fieldLabel : '医院'
		,editable : 'false'
		,triggerAction : 'all'
		,valueField : 'rowid'
		,anchor : '98%'
	});
	obj.DateFrom = new Ext.form.DateField({
		id : 'DateFrom'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '起始日期'
		,anchor : '98%'
	});
	obj.DateTo = new Ext.form.DateField({
		id : 'DateTo'
		,format : 'Y-m-d'
		,width : 100
		,fieldLabel : '结束日期'
		,anchor : '98%'
	});
	obj.Active = new Ext.form.Checkbox({
		id : 'Active'
		,fieldLabel : '是否有效'
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '保存'
	});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-exit'
		,text : '取消'
	});
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 70
		,region : 'center'
		,layout : 'form'
		,frame : true
		,items:[
			obj.Code
			,obj.Description
			,obj.Active
			//,obj.HispsDescs
			,obj.DateFrom
			,obj.DateTo
		]
		,buttons:[
			obj.btnSave
			,obj.btnCancel
		]
	});
	obj.winEdit = new Ext.Window({
		id : 'winEdit'
		,buttonAlign : 'center'
		,width : 350
		,height : 240
		,title : '编辑'
		,layout : 'fit'
		,modal : true
		,items:[
			obj.fPanel
		]
	});
	obj.HispsDescsStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.Base.Hospital';
		param.QueryName = 'QueryHosInfo';
		param.ArgCnt = 0;
	});
	obj.HispsDescsStore.load({});
	
	InitwinEditEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}
