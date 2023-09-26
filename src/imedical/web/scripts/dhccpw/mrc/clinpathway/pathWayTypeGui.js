
function PathWayType(){
	var obj = new Object();
	obj.typeRowid1="";
	obj.PathTypeGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PathTypeGridStore = new Ext.data.Store({
		proxy: obj.PathTypeGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'typeRowid'
		}, 
		[
			{name: 'typeRowid', mapping: 'Rowid'}
			,{name: 'typeCode', mapping: 'code'}
			,{name: 'typeDesc', mapping: 'desc'}
		])
	});
	//obj.GridPanel2CheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.PathTypeGrid = new Ext.grid.GridPanel({
		id : 'PathTypeGrid'
		,store : obj.PathTypeGridStore
		,buttonAlign : 'center'
		,height : 200
		,region : 'center'
		,columns: [
			{header: 'Code', width: 300, dataIndex: 'typeCode', sortable: true}
			,{header: '类型名称', width: 300, dataIndex: 'typeDesc', sortable: true}
		]
		,stripeRows : true
                ,autoExpandColumn : 'typeDesc'
                ,bodyStyle : 'width:100%'
                ,autoWidth : true
                ,autoScroll : true
                ,viewConfig : {
                    forceFit : true
                }
	});
	obj.PathTypeCode = new Ext.form.TextField({
		id : 'PathTypeCode'
		,fieldLabel : 'Code',
		anchor:"98%"
	});
	obj.PathTypeDesc = new Ext.form.TextField({
		id : 'PathTypeDesc'
		,fieldLabel : '类型名称',
		anchor:"98%"
	});
	obj.PathTypeAdd = new Ext.Button({
		id : 'pathType_Add'
		,text : '添加',
		iconCls:"icon-add"
	});
	obj.PathTypeUpdate = new Ext.Button({
		id : 'PathTypeUpdate'
		,text : '保存',
		iconCls:"icon-save"
	});
	obj.PathTypeDelete = new Ext.Button({
		id : 'PathTypeDelete'
		,text : '删除',
		iconCls:"icon-delete"
	});
	obj.pnLeft = new Ext.Panel({
		id : 'pnLeft'
		,buttonAlign : 'center'
		,columnWidth : 0.2
		,layout : 'form'
		,items:[]
	});
	obj.pnCenter = new Ext.Panel({
		id : 'pnCenter'
		,buttonAlign : 'center'
		,columnWidth : 0.6
		,layout : 'form'
		,items:[
			obj.PathTypeCode
			,obj.PathTypeDesc
		]
	});
	obj.pnRight = new Ext.Panel({
		id : 'pnRight'
		,buttonAlign : 'center'
		,columnWidth : 0.2
		,layout : 'form'
		,items:[]
	});
	
	obj.ConditionPanel=new Ext.form.FormPanel({
		id : 'panelTitle'
		,buttonAlign : 'center'
		,labelWidth : 70
		,labelAlign : 'right'
		,height : 110
		,frame : true
		,region : 'south'
		,layout:"column"
		,items:[
			obj.pnLeft
			,obj.pnCenter
			,obj.pnRight
		]
		,buttons:[
			//obj.PathTypeAdd, //Modified By LiYang 2011-05-08
			obj.PathTypeUpdate
			//,obj.PathTypeDelete  //Modify by wuqk 2011-07-21  路径类型不允许删除
		]
	})
	//modified By LiYang 2010-12-21 使用ViewPort代替原来的window，使界面嵌入原来的tab-panel
	obj.TypeWin = new Ext.Viewport({
		id : 'pathTypeWin'
		,height : 450
		,buttonAlign : 'center'
		,width : 400
		,title : '临床路径类型'
		,layout : 'border'
		,frame : true
		,closeAction: 'close'
		//,resizable:false
		,closable:true
		,modal: true
		,items:[
			obj.PathTypeGrid
			,obj.ConditionPanel
		]
		,scope:this
	});
	obj.PathTypeGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWayType';
			param.QueryName = 'GetPathWayType';
			param.ArgCnt = 0;
	});
	obj.PathTypeGridStore.load({});
	pathWayTypeEvent(obj);
	//obj.PathTypeAdd.on("click", obj.PathTypeAdd_click, obj);
	//obj.PathTypeUpdate.on("click",obj.updateType,obj);
	obj.PathTypeUpdate.on("click",obj.btnSaveOnclick,obj);
	//obj.PathTypeGrid.getSelectionModel().on('rowselect', obj.rowSelect);
	obj.PathTypeGrid.on('rowclick', obj.rowSelect);
	obj.PathTypeDelete.on("click",obj.deleteType,obj)
	//事件处理代码
  obj.LoadEvent();
  return obj;
}

