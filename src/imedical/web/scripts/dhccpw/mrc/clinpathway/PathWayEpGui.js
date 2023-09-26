
function PathWayEp(PathWayVerID, IsReadOnly){
	//�ɲ�����pathNode
	var obj = new Object();
	obj.PathWayVerID = PathWayVerID;
	//window.alert("VerID��" + obj.PathWayVerID);
	//var pathStr=pathNode.id.split("_") Modified By LiYang 2010-12-26
	//var epStr="�ٴ�·����" + ParentText +" �׶�ά��"; //Modified By LiYang 2010-12-25
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
			{header: '����', width: 400, dataIndex: 'desc', sortable: true}
			,{header: '���', width: 100, dataIndex: 'episode', sortable: true}
			,{header: '��ע', width: 180, dataIndex: 'notes', sortable: true}
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
		,fieldLabel : '����'
	});
	obj.PathWayEpnum = new Ext.form.NumberField({
		id : 'PathWayEpnum'
		,width : 100
		,anchor : '99%'
		,fieldLabel : '�׶����'
		,allowDecimals:false
		,nanText : 'ֻ������������!'
	});
	obj.PathWayEpNote = new Ext.form.TextArea({
		id : 'PathWayEpNote'
		,height : 75
		,width : 200
		,anchor : '99%'
		,fieldLabel : '��ע'
	});
	obj.PathWayEpAdd = new Ext.Button({
		id : 'PathWayEpAdd',
		iconCls : 'icon-add',
		text:'���'
		,disabled : IsReadOnly
	});
	obj.PathWayEpUpdate = new Ext.Button({
		id : 'PathWayEpUpdate'
		,text : '����',
		iconCls : 'icon-save'
		,disabled : IsReadOnly
	});
	obj.PathWayEpDelete = new Ext.Button({
		id : 'PathWayEpDelete',
		text:'ɾ��',
		iconCls : 'icon-delete'
		,disabled : IsReadOnly
	});
	obj.PathWayEpClearBtn = new Ext.Button({
		id : 'PathWayEpClearBtn',
		text:'���',
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
	obj.PathWayEpWin = new Ext.Viewport({ //Modified By LiYang 2010-12-25 �޸Ľ���ΪǶ��ʽ
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
	//�¼��������
  obj.LoadEvent();
  obj.setEpisode()
  return obj;
}

