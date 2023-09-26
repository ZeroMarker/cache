
function StepItemCat(){
	var obj = new Object();
	obj.ItemRowid=""
	obj.StepItemCatGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.StepItemCatGridStore = new Ext.data.Store({
		proxy: obj.StepItemCatGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'DateFrom', mapping: 'DateFrom'}
			,{name: 'DateTo', mapping: 'DateTo'}
		])
	});
	//obj.StepItemCatGridCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.StepItemCatGrid = new Ext.grid.GridPanel({
		id : 'StepItemCatGrid'
		,store : obj.StepItemCatGridStore
		,height : 250,
		region : 'center',
		width:530
		,columns: [
			{header: '代码', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '描述', width: 100, dataIndex: 'Desc', sortable: true}
			,{header: '开始日期', width: 100, dataIndex: 'DateFrom', sortable: true}
			,{header: '结束日期', width: 100, dataIndex: 'DateTo', sortable: true}
		]
		,stripeRows : true
                ,autoExpandColumn : 'Desc'
                ,bodyStyle : 'width:100%'
                ,autoWidth : true
                ,autoScroll : true
                ,viewConfig : {
                    forceFit : true
                }
	});
	obj.Panel6 = new Ext.Panel({
		id : 'Panel6'
		,buttonAlign : 'center'
		,width : 100
		,columnWidth : .2
		,items:[]
	});
	obj.ItemCatCode = new Ext.form.TextField({
		id : 'ItemCatCode'
		,width : 150
		,anchor : '99%'
		,fieldLabel : '代码'
		,allowBlank:false,
		validateOnBlur:false
	});
	obj.ItemCatDesc = new Ext.form.TextField({
		id : 'ItemCatDesc'
		,width : 150
		,anchor : '99%'
		,fieldLabel : '描述'
		,allowBlank:false,
		validateOnBlur:false
	});
	obj.ItemCatDateFrom = new Ext.form.DateField({
		id : 'ItemCatDateFrom'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 150
		,fieldLabel : '开始日期'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,value : new Date()
		//,allowBlank:false
		//,validateOnBlur:false
	});
	obj.ItemCatDateTo = new Ext.form.DateField({
		id : 'ItemCatDateTo'
		//,format : 'Y-m-d'
		,format : ((typeof websys_DateFormat == 'undefined')?"Y-m-d":websys_DateFormat)
		,width : 150
		,fieldLabel : '结束日期'
		,anchor : '99%'
		,altFormats : 'Y-m-d|d/m/Y'
		//,value : new Date()
		//,allowBlank:false
		//,validateOnBlur:false
	});
	obj.Panel7 = new Ext.Panel({
		id : 'Panel7'
		,buttonAlign : 'center'
		,width : 100
		,columnWidth : .3
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 70
		,items:[
			obj.ItemCatCode
			,obj.ItemCatDesc
		]
	});
	obj.Panel8 = new Ext.Panel({
		id : 'Panel8'
		,buttonAlign : 'center'
		,width : 100
		,columnWidth : .3
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 70
		,items:[
			obj.ItemCatDateFrom
			,obj.ItemCatDateTo
		]
	});
	obj.ItemCatAdd = new Ext.Button({
		id : 'ItemCatAdd'
		,iconCls : 'icon-add'
		,text : '添加'
});
	obj.ItemCatUpdate = new Ext.Button({
		id : 'ItemCatUpdate'
		,iconCls : 'icon-save'
		,text : '保存'
});
	obj.ItemCatDelete = new Ext.Button({
		id : 'ItemCatDelete'
		,iconCls : 'icon-delete'
		,text : '删除'
});
	obj.ItemCatClear = new Ext.Button({
		id : 'ItemCatClear'
		,iconCls : 'icon-cancel'
		,text : '清空'
});
	obj.Panel5 = new Ext.form.FormPanel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,height : 105
		,layout : 'column'
		,region : 'south'
		,labelAlign : 'right',
		frame:true
		,labelWidth : 80
		,items:[
			obj.Panel6
			,obj.Panel7
			,obj.Panel8
		]
		,buttons:[
			//obj.ItemCatAdd
			obj.ItemCatUpdate
			,obj.ItemCatDelete
			//,obj.ItemCatClear
		]
	});
	obj.StepItemCatWindow = new Ext.Viewport({
		id : 'StepItemCatWindow'
		,height : 500,
		title:"项目大类维护"
		,buttonAlign : 'center',
		resizable:false,
		modal:true
		,width : 550
		,layout : 'border'
		,items:[
			obj.StepItemCatGrid
			,obj.Panel5
		],
		scope:this
		
	});
	obj.StepItemCatGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.StepItemCategory';
			param.QueryName = 'GetStepItemCat';
			param.ArgCnt = 0;
	});
	obj.StepItemCatGridStore.load({});
	StepItemCatEvent(obj);
	//obj.ItemCatAdd.on('click',obj.AddItemCat,obj)
	//obj.ItemCatClear.on('click',obj.ClearItem)
	//obj.ItemCatUpdate.on('click',obj.UpdateItem,obj)
	obj.ItemCatUpdate.on('click',obj.btnSaveOnclick,obj)
	obj.ItemCatDelete.on('click',obj.DeleteItem,obj)
	//obj.StepItemCatGrid.getSelectionModel().on('rowselect',obj.ItemSelected)
	obj.StepItemCatGrid.on('rowclick',obj.ItemSelected)
	//事件处理代码
  obj.LoadEvent();
  return obj;
}

