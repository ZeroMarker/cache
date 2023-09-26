function InitViewport(){
	var obj = new Object();
	var fm = Ext.form;
	obj.NormalLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.NormalLocStore = new Ext.data.Store({
		proxy: obj.NormalLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'myid'
		}, 
		[
			 {name: 'checked', mapping : 'checked'}
      ,{name: 'myid', mapping: 'myid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
		])
	});
	var cm = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true // columns are not sortable by default           
        },
        columns: [
             {
                header: '代码',
                dataIndex: 'HandLiquidCode',
                width: 150
            }, 
            {
                header: '名称',
                dataIndex: 'HLName',
                width: 250
            }, 
            {
                header: '容量',
                dataIndex: 'HlVolume',
                width: 150,
                editor: new fm.TextField({
                })
            }, 
            {
                header: '单位',
                dataIndex: 'HlUnit',
                width: 150
            },  
            {
                header: '消毒液/洗手液',
                dataIndex: 'NormalLoc',
                width: 150,
      		   		editor: new fm.ComboBox({
      		   		minChars : 1
					,displayField : 'Description'
					,store : obj.NormalLocStore
					,triggerAction : 'all'
					,anchor : '95%'
					,valueField : 'Code'
					,mode: 'local'
					,lazyRender : true
					,typeAhead: true
					,forceSelection : true
                })
                ,renderer: function(value,metadata,record){
         				if(value==1) return "速干手消毒液";
         				if(value==2) return "洗手液";
							return value;	
						}
          }
        ]
    });
    obj.LocConListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.LocConListStore = new Ext.data.Store({
		autoDestroy: true,
		proxy: obj.LocConListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'HandLiquidCode', mapping: 'HandLiquidCode'}
			,{name: 'HLName', mapping: 'HLName'}
			,{name: 'HlVolume', mapping: 'HlVolume'}
			,{name: 'HlUnit', mapping: 'HlUnit'}
			,{name: 'NormalLoc', mapping: 'Type'}
		])
	});

	obj.LocConListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });

	obj.LocConList = new Ext.grid.EditorGridPanel({
		id : 'SACEditGridPanel'
		,store : obj.LocConListStore
		,cm : cm
		,buttonAlign : 'center'
		,title : '洗手液、速干手消毒液类型维护'
		,frame: true
		,clicksToEdit: 1
});
	obj.LocConListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Aim.HandHealthSrv';
			param.QueryName = 'QueryHandHType';
			param.ArgCnt = 0;
	});
	obj.LocConListStore.load({});
	
	obj.BtnSave = new Ext.Button({
		id : 'BtnSave'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
});
	obj.LocFPanel = new Ext.form.FormPanel({
		id : 'LocFPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,frame : true
		,region : 'center'
		,layout: 'fit'
		,items:[
			obj.LocConList
		]
		,buttons:[
			obj.BtnSave
		]
	});
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.LocFPanel
		]
	});
	obj.NormalLocStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCMed.SSService.DictionarySrv';
		param.QueryName = 'QryDictionary';
		param.Arg1 = 'HandLiquidType';
		param.ArgCnt = 1;
	});
	obj.NormalLocStore.load({});
	InitViewportEvent(obj);
	obj.BtnSave.on("click", obj.BtnSave_click, obj);
  obj.LoadEvent(arguments);
  return obj;
}