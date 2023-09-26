function InitwinScreen(AimType){
	var obj = new Object();
	obj.YesNoStore = new Ext.data.SimpleStore({
		fields : ['YesNoDesc','YesNoCode'],
		data : 
		[['Y','Y'],['N','N']]
	});
	var fm = Ext.form;
	var cm = new Ext.grid.ColumnModel({
        defaults: {
            sortable: true // columns are not sortable by default           
        },
        columns: [
             {
                header: '科室',
                dataIndex: 'LocDesc',
                width: 250
            }, {
                header: '是否有效',
                dataIndex: 'Active',
                width: 60,
        		editor: new fm.ComboBox({
          			typeAhead: true
          			,triggerAction: 'all'
          			,lazyRender: true
					,store : obj.YesNoStore
					,displayField : 'YesNoDesc'
					,valueField : 'YesNoCode'
					,editable : false
					,mode: 'local'
                })
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
			idProperty: 'LocID'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'LocID', mapping: 'LocID'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'LocDesc', mapping: 'LocDesc'}
			,{name: 'Active', mapping: 'IsActive'}
		])
	});

	obj.LocConListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });

	obj.LocConList = new Ext.grid.EditorGridPanel({
		id : 'SACEditGridPanel'
		,store : obj.LocConListStore
		,cm : cm
		,buttonAlign : 'center'
		,title : '关联科室'
		,frame: true
		,clicksToEdit: 1
		,region : 'center'
});

	obj.BtnSave = new Ext.Button({
		id : 'BtnSave'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
	});
	obj.winScreen = new Ext.Window({
		id : 'winScreen'
		,height : 500
		,buttonAlign : 'center'
		,width : 380
		,modal : true
		,layout : 'border'
		,items:[
			obj.LocConList
		],buttons:[
			obj.BtnSave
		]
	});
	obj.LocConListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.NINFService.Aim.CtlocOperSrv';
			param.QueryName = 'QryLocActiveByType';
			param.Arg1 = AimType;
			param.Arg2 = "E";
			param.ArgCnt = 2;
	});
	obj.LocConListStore.load({});
	
	obj.BtnSave.on("click",function()
	{
		var objType = ExtTool.StaticServerObject("DHCMed.NINFService.Aim.CtlocOperSrv");
		var ErrorFlag=0;
		for(var i = 0; i < obj.LocConListStore.getCount(); i ++)  //遍历对照列表
    	{
    		var objData = obj.LocConListStore.getAt(i);
    		var LocID = objData.get("LocID");
    		var Active = objData.get("Active");
				var str="^"+AimType+"^"+LocID+"^"+Active
				
				var ret=objType.UpdateCtlocOperInfo(str);
				if(ret<0) ErrorFlag=1;
			}
		if(ErrorFlag==0) 
		{
			alert("数据保存成功!!");	
			obj.LocConListStore.load({});
		}
	});
	//obj.LoadEvent(arguments);
  return obj;
}
