
function PathWayEp(PathWayVerID, IsReadOnly){
	//旧参数：pathNode
	var obj = new Object();
	obj.PathWayVerID = PathWayVerID;
	//window.alert("VerID：" + obj.PathWayVerID);
	//var pathStr=pathNode.id.split("_") Modified By LiYang 2010-12-26
	//var epStr="临床路径：" + ParentText +" 阶段维护"; //Modified By LiYang 2010-12-25
	obj.pathRowid=obj.PathWayVerID.split("||")[0]; //pathStr[0]//Modified By LiYang 2010-12-25
	obj.pathWayEpRowid="";
	obj.PathWayEpGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PathWayEpGridStore = new Ext.data.Store({
		proxy: obj.PathWayEpGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'desc', mapping: 'desc'}
			,{name: 'episode', mapping: 'episode'}
			,{name: 'notes', mapping: 'notes'}
		])
	});
	//obj.PathWayEpGridCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.PathWayEpGrid = new Ext.grid.GridPanel({
		id : 'PathWayEpGrid'
		,store : obj.PathWayEpGridStore
		,buttonAlign : 'center'
		,width : 380
		,region : 'center'
		,height : 200
		,columns: [
			{header: '描述', width: 400, dataIndex: 'desc', sortable: true}
			,{header: '序号', width: 100, dataIndex: 'episode', sortable: true}
			,{header: '备注', width: 180, dataIndex: 'notes', sortable: true}
		]
		,stripeRows : true
        ,autoExpandColumn : 'desc'
        ,bodyStyle : 'width:100%'
        ,autoWidth : true
        ,autoScroll : true
        ,viewConfig : {
            forceFit : true
        }
	});
	obj.PathWayEpLab = new Ext.form.Label({
		id : 'PathWayEpLab'
		,height : 10
	});
	obj.PathWayEpDesc = new Ext.form.TextField({
		id : 'PathWayEpDesc'
		,width : 100
		,anchor : '99%'
		,fieldLabel : '描述'
	});
	obj.PathWayEpnum = new Ext.form.NumberField({
		id : 'PathWayEpnum'
		,width : 100
		,anchor : '99%'
		,fieldLabel : '阶段序号'
		,allowDecimals:false
		,nanText : '只允许输入整数!'
	});
	obj.PathWayEpNote = new Ext.form.TextArea({
		id : 'PathWayEpNote'
		,height : 75
		,width : 200
		,anchor : '99%'
		,fieldLabel : '备注'
	});
	obj.PathWayEpAdd = new Ext.Button({
		id : 'PathWayEpAdd',
		iconCls : 'icon-add',
		text:'添加'
		,disabled : IsReadOnly
	});
	obj.PathWayEpUpdate = new Ext.Button({
		id : 'PathWayEpUpdate'
		,text : '保存',
		iconCls : 'icon-save'
		,disabled : IsReadOnly
	});
	obj.PathWayEpDelete = new Ext.Button({
		id : 'PathWayEpDelete',
		text:'删除',
		iconCls : 'icon-delete'
		,disabled : IsReadOnly
	});
	obj.PathWayEpClearBtn = new Ext.Button({
		id : 'PathWayEpClearBtn',
		text:'清空',
		iconCls : 'icon-cancel'
		,disabled : IsReadOnly
	});
	obj.SubPanel1 = new Ext.Panel({
		id : 'SubPanel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		]
	});
	obj.SubPanel3 = new Ext.Panel({
		id : 'SubPanel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		]
	});
	obj.SubPanel2 = new Ext.Panel({
		id : 'SubPanel2'
		,buttonAlign : 'center'
		,columnWidth : .6
		,layout : 'form'
		,items:[
			obj.PathWayEpDesc
			,obj.PathWayEpnum
			,obj.PathWayEpNote
		]
	});

	obj.pathWayEdit=new Ext.form.FormPanel({
		id : 'panelTitle'
		,buttonAlign : 'center'
		,labelWidth : 60
		,labelAlign : 'right'
		,height : 150
		,layout:'column'
		,frame : true
		,region : 'south'
		,items:[
			obj.SubPanel1,
			obj.SubPanel2,
			obj.SubPanel3
		],
		buttons:[
			obj.PathWayEpAdd
			,obj.PathWayEpUpdate
			,obj.PathWayEpDelete
			,obj.PathWayEpClearBtn 
		]
	})
	obj.PathWayEpWin = new Ext.Viewport({ //Modified By LiYang 2010-12-25 修改界面为嵌入式
		id : 'PathWayEpWin'
		//,title:epStr //Modified BY LiYang 2010-12-29
		,height : 483
		,buttonAlign : 'center'
		,width : 500
		,layout : 'form'
		,modal : true
		,layout : 'border'
		,resizable:false
		,items:[
			obj.PathWayEpGrid,
			obj.pathWayEdit
		]
	});
	obj.PathWayEpGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.PathWayEp';
			param.QueryName = 'GetPathWayEp';
			param.Arg1 = obj.pathRowid;
			param.ArgCnt = 1;
	});
	obj.PathWayEpGridStore.load({});
	PathWayEpEvent(obj);
	obj.PathWayEpAdd.on('click',obj.AddPahtWayEp);
	obj.PathWayEpGrid.getSelectionModel().on('rowselect',obj.PathWayEpSelect);
	obj.PathWayEpClearBtn.on('click',obj.PathWayEpClear);
	obj.PathWayEpUpdate.on('click',obj.UpdatePathWayEp);
	obj.PathWayEpDelete.on('click',obj.DeletePathWayEp);
	//事件处理代码
  obj.LoadEvent();
  obj.setEpisode()
  return obj;
}

