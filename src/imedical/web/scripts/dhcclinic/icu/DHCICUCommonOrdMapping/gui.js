function InitViewScreen()
{ 
	var obj = new Object();
	
	//ҽ������
	obj.ViewSuperCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.ViewSuperCatStore = new Ext.data.Store({
		proxy: obj.ViewSuperCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
		[
		     {name: 'RowId', mapping: 'RowId'}
			,{name: 'ORCatDesc', mapping: 'ORCatDesc'}
		])
	});	
	obj.ViewSuperCat = new Ext.form.ComboBox({
		id : 'ViewSuperCat'
		,store:obj.ViewSuperCatStore
		,minChars:1	
		,displayField:'ORCatDesc'	
		,fieldLabel : 'ҽ������'
		,valueField : 'RowId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.ViewSuperCatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCode';
		param.QueryName = 'FindViewSuperCat';
		param.Arg1 = obj.ViewSuperCat.getRawValue();
		param.ArgCnt = 1;
	});
	obj.ViewSuperCatStore.load({});
	
	
	
	//ҽ������
	obj.ViewCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.ViewCatStore = new Ext.data.Store({
		proxy: obj.ViewCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
		[
		     {name: 'RowId', mapping: 'RowId'}
			,{name: 'ARCICatDesc', mapping: 'ARCICatDesc'}
		])
	});	
	obj.ViewCat = new Ext.form.ComboBox({
		id : 'ViewCat'
		,store:obj.ViewCatStore
		,minChars:1	
		,displayField:'ARCICatDesc'	
		,fieldLabel : 'ҽ������'
		,valueField : 'RowId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.ViewCatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCode';
		param.QueryName = 'FindViewCat';
		param.Arg1 = obj.ViewCat.getRawValue();
		param.Arg2 = obj.ViewSuperCat.getRawValue();
		param.ArgCnt = 2;
	});
	obj.ViewCatStore.load({});
	
	
	//ҽ����
	obj.ArcimStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.ArcimStore = new Ext.data.Store({
		proxy: obj.ArcimStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ARCIMastRowID'
		}, 
		[
		     {name: 'ARCIMastRowID', mapping: 'ARCIMastRowID'}
			,{name: 'ARCIMastDesc', mapping: 'ARCIMastDesc'}
		])
	});	
	obj.Arcim = new Ext.form.ComboBox({
		id : 'Arcim'
		,store:obj.ArcimStore
		,minChars:1	
		,displayField:'ARCIMastDesc'	
		,fieldLabel : 'ҽ����'
		,valueField : 'ARCIMastRowID'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.ArcimStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCode';
		param.QueryName = 'FindOrcItmMast';
		param.Arg1 = obj.Arcim.getRawValue();
		param.Arg2 = obj.ViewCat.getValue();
		param.ArgCnt = 2;
	});
	obj.ArcimStore.load({});
	
	
	
	//ҽ����ע
	obj.OeoriNote = new Ext.form.TextField({
		id : 'OeoriNote'
		,fieldLabel : 'ҽ����ע'
		,anchor : '95%'
		//,width : 532
	});	
	
	obj.Panel11 = new Ext.Panel({
		id : 'Panel11'
		,buttonAlign : 'center'
		,columnWidth : .25
		,labelWidth:80
		,layout : 'form'
		,items:[
			obj.ViewSuperCat
			,obj.ViewCat
			,obj.Arcim
			//,obj.Dept
			,obj.OeoriNote
		]
	});
	
	
	//����ҽ��
	obj.AncoStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.AncoStore = new Ext.data.Store({
		proxy: obj.AncoStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
		     {name: 'rowid', mapping: 'rowid'}
			,{name: 'ComOrdRowDesc', mapping: 'ComOrdRowDesc'}
		])
	});	
	obj.Anco = new Ext.form.ComboBox({
		id : 'Anco'
		,store:obj.AncoStore
		,minChars:1	
		,displayField:'ComOrdRowDesc'	
		,fieldLabel : '����ҽ��'
		,valueField : 'rowid'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.AncoStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCode';
		param.QueryName = 'FindCommonOrd';
		param.Arg1 = obj.Anco.getRawValue();
		param.Arg2 = obj.ViewCat.getRawValue();
		param.ArgCnt = 2;
	});
	obj.AncoStore.load({});
	
	
	//�ٶ�
	obj.SpeedUnitStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.SpeedUnitStore = new Ext.data.Store({
		proxy: obj.SpeedUnitStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ANCSURowId'
		}, 
		[
		     {name: 'ANCSURowId', mapping: 'ANCSURowId'}
			,{name: 'ANCSUDesc', mapping: 'ANCSUDesc'}
		])
	});	
	obj.SpeedUnit = new Ext.form.ComboBox({
		id : 'SpeedUnit'
		,store:obj.SpeedUnitStore
		,minChars:1	
		,displayField:'ANCSUDesc'	
		,fieldLabel : '�ٶ�'
		,valueField : 'ANCSURowId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.SpeedUnitStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCode';
		param.QueryName = 'Findspeedunit';
		param.Arg1 = obj.Arcim.getRawValue();
		param.Arg2 = obj.ViewCat.getRawValue();
		param.ArgCnt = 2;
	});
	obj.SpeedUnitStore.load({});
	
	
	//��λ
	obj.UomStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.UomStore = new Ext.data.Store({
		proxy: obj.UomStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ANCSURowId'
		}, 
		[
		     {name: 'ANCSURowId', mapping: 'ANCSURowId'}
			,{name: 'ANCSUDesc', mapping: 'ANCSUDesc'}
		])
	});	
	obj.Uom = new Ext.form.ComboBox({
		id : 'Uom'
		,store:obj.UomStore
		,minChars:1	
		,displayField:'ANCSUDesc'	
		,fieldLabel : '��λ'
		,valueField : 'ANCSURowId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.UomStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCode';
		param.QueryName = 'FindUom';
		param.Arg1 = obj.Arcim.getRawValue();
		param.Arg2 = obj.ViewCat.getRawValue();
		param.ArgCnt = 2;
	});
	obj.UomStore.load({});
	
	
	obj.Panel12 = new Ext.Panel({
		id : 'Panel12'
		,buttonAlign : 'center'
		,columnWidth : .25
		,labelWidth:80
		,layout : 'form'
		,items:[
			obj.Anco
			,obj.SpeedUnit
			,obj.Uom
		]
	});
	
	//������
	obj.PrepareVolume = new Ext.form.TextField({
		id : 'PrepareVolume'
		,fieldLabel : '������'
		,anchor : '95%'
	});
	
	
	//����
	obj.Abbreviate = new Ext.form.TextField({
		id : 'Abbreviate'
		,fieldLabel : '����'
		,anchor : '95%'
	});
	
	
	//����
	obj.Qty = new Ext.form.TextField({
		id : 'Qty'
		,fieldLabel : '����'
		,anchor : '95%'
	});
	
	obj.Panel13 = new Ext.Panel({
		id : 'Panel13'
		,buttonAlign : 'center'
		,columnWidth : .25
		,labelWidth:80
		,layout : 'form'
		,items:[
			obj.PrepareVolume
			,obj.Abbreviate
			,obj.Qty
		]
	});
	
	
	//ȱʡ�ٶ�
	obj.DefSpeed = new Ext.form.TextField({
		id : 'DefSpeed'
		,fieldLabel : 'ȱʡ�ٶ�'
		,anchor : '95%'
	});
	
	//Ũ��
	obj.Density = new Ext.form.TextField({
		id : 'Density'
		,fieldLabel : 'Ũ��'
		,anchor : '95%'
	});
	
	//ʹ�ÿ���
	obj.DeptStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.DeptStore = new Ext.data.Store({
		proxy: obj.DeptStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'TTemplateID'
		}, 
		[
		     {name: 'TTemplateID', mapping: 'TTemplateID'}
			,{name: 'TDeptName', mapping: 'TDeptName'}
		])
	});	
	obj.Dept = new Ext.form.ComboBox({
		id : 'Dept'
		,store:obj.DeptStore
		,minChars:1	
		,displayField:'TDeptName'	
		,fieldLabel : 'ʹ�ÿ���'
		,valueField : 'TTemplateID'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.DeptStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUPara';
		param.QueryName = 'FindICUParaDept';
		param.ArgCnt = 0;
	});
	obj.DeptStore.load({});
	
	obj.Panel14 = new Ext.Panel({
		id : 'Panel14'
		,buttonAlign : 'center'
		,columnWidth : .25
		,labelWidth:80
		,layout : 'form'
		,items:[
			obj.DefSpeed
			,obj.Density
			,obj.Dept
		]
	});
	
	obj.fPanel = new Ext.Panel({
		id:"fPanel"
		,buttonAlign:"center"
		,labelAlign:"right"
		,labelWidth:60
		,height:100
		,region:"center"
		,layout:"column"
		,items:[
			obj.Panel11
			,obj.Panel12
			,obj.Panel13
			,obj.Panel14
		]
	});
	
	
	
	obj.addButton = new Ext.Button({
		id : 'addButton'
		,width:60
		,text : '���'
	});
	obj.deleteButton = new Ext.Button({
		id : 'deleteButton'
		,width:60
		,text : 'ɾ��'
	});
	obj.saveButton = new Ext.Button({
		id : 'saveButton'
		,width:60
		,text : '����'
	});
	obj.addButtonPanel = new Ext.Panel({
		id : 'addButtonPanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.addButton
		]

	});
	obj.deleteButtonPanel = new Ext.Panel({
		id : 'deleteButtonPanel'
		,buttonAlign : 'center'	
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.deleteButton
		]

	});
	obj.saveButtonPanel = new Ext.Panel({
		id : 'saveButtonPanel'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		    obj.saveButton
		    ]

	});	
	obj.buttonPanel = new Ext.Panel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 30
		,region : 'south'
		,layout : 'column'
		,items:[
			obj.addButtonPanel
			,obj.deleteButtonPanel
			,obj.saveButtonPanel
		]
	});
	
	obj.floorPanel = new Ext.Panel({
		id : 'floorPanel'
		,buttonAlign : 'center'
		,height : 200
		,region : 'north'
		,layout : 'border'
		,frame : true
		,title : 'ҽ����������ҽ��'
		,collapsible:true
		,animate:true
		,items:[
			obj.fPanel
			,obj.buttonPanel
		]
    });
    
    
    
    obj.retGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelStore = new Ext.data.Store({
		proxy: obj.retGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: ''
		}, 
	    [
			{name: 'tAncoId', mapping : 'tAncoId'}
			,{name: 'tAncoDesc', mapping: 'tAncoDesc'}
			,{name: 'tSpeedUnitId', mapping: 'tSpeedUnitId'}
			,{name: 'tSpeedUnitDesc', mapping: 'tSpeedUnitDesc'}
			,{name: 'tUomId', mapping: 'tUomId'}
			,{name: 'tUomDesc', mapping: 'tUomDesc'}
			,{name: 'tDensity', mapping: 'tDensity'}
			,{name: 'tQty', mapping: 'tQty'}
			,{name: 'tPrepareVolume', mapping: 'tPrepareVolume'}
			,{name: 'tAbbreviate', mapping: 'tAbbreviate'}
			,{name: 'tDefSpeed', mapping: 'tDefSpeed'}
			,{name: 'tViewSuperCatIDT', mapping: 'tViewSuperCatIDT'}
			,{name: 'tViewSuperCatDescT', mapping: 'tViewSuperCatDescT'}
			,{name: 'tViewCatIDT', mapping: 'tViewCatIDT'}
			,{name: 'tViewCatDescT', mapping: 'tViewCatDescT'}
			,{name: 'tArcimIDT', mapping: 'tArcimIDT'}
			,{name: 'tArcimDescT', mapping: 'tArcimDescT'}
			,{name: 'tOeoriNoteT', mapping: 'tOeoriNoteT'}
			,{name: 'tDeptId', mapping: 'tDeptId'}
			,{name: 'tDeptDesc', mapping: 'tDeptDesc'}
		])
	});
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true // columns are not sortable by default           
		}
        ,columns: [
			new Ext.grid.RowNumberer(),
			{header: '����ҽ��ID',width: 80,dataIndex: 'tAncoId',sortable: true}
			,{header: '�ٶ�ID',width: 80,dataIndex: 'tSpeedUnitId',sortable: true}
        	,{header: '��λID',width: 80,dataIndex: 'tUomId',sortable: true}
			,{header: 'Ũ��ID',width: 80,dataIndex: 'toperStat',sortable: true}
			,{header: 'Ũ��',width: 80,dataIndex: 'tDensity',sortable: true}
			,{header: '����',width: 80,dataIndex: 'tQty',sortable: true}
			,{header: '������',width: 80,dataIndex: 'tPrepareVolume',sortable: true}
			,{header: '����',width: 80,dataIndex: 'tAbbreviate',sortable: true}
			,{header: 'ȱʡ�ٶ�',width: 80,dataIndex: 'tDefSpeed',sortable: true}
			,{header: '����ID',width: 80,dataIndex: 'tViewSuperCatIDT',sortable: true}
			,{header: 'С��ID',width: 80,dataIndex: 'tViewCatIDT',sortable: true}
			,{header: 'ҽ����ID',width: 80,dataIndex: 'tArcimIDT',sortable: true}
			,{header: 'ҽ����ע',width: 80,dataIndex: 'tOeoriNoteT',sortable: true}
			,{header: 'ҽ������',width: 80,dataIndex: 'tViewSuperCatDescT',sortable: true}
			,{header: 'ҽ������',width: 80,dataIndex: 'tViewCatDescT',sortable: true}
			,{header: 'ҽ����',width: 80,dataIndex: 'tArcimDescT',sortable: true}
			,{header: '�ٶ�',width: 80,dataIndex: 'tSpeedUnitDesc',sortable: true}
			,{header: '��λ',width: 80,dataIndex: 'tUomDesc',sortable: true}
			,{header: 'tDeptId',width: 80,dataIndex: 'tDeptId',sortable: true}
			,{header: 'tDeptDesc',width: 160,dataIndex: 'tDeptDesc',sortable: true}
			
		]
	});
	
	 obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) 
		,clicksToEdit:1    
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
		,viewConfig:
		{
			forceFit: false
			
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
	});
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCode';
		param.QueryName = 'FindICUOrdMap';
		param.Arg1 = obj.ViewSuperCat.getValue();
		param.Arg2 = obj.ViewCat.getValue();
		param.Arg3 = obj.Arcim.getValue();
		param.Arg4 = obj.OeoriNote.getValue(); 
		param.ArgCnt = 4;
	});
	obj.retGridPanelStore.load({
		params : {
		start:0
		,limit:20
		}});
	
	obj.Panel23 = new Ext.Panel({
		id : 'Panel23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	
	obj.Panel25 = new Ext.Panel({
		id : 'Panel25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});
	
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panel23
			,obj.Panel25
		    ,obj.retGridPanel
		]
	});
	

	
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.floorPanel
			,obj.resultPanel
		]
	}); 
	
	
	InitViewScreenEvent(obj);
	
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
    obj.addButton.on("click", obj.addButton_click, obj);
    obj.deleteButton.on("click", obj.deleteButton_click, obj);
    obj.saveButton.on("click", obj.saveButton_click, obj);
	
    return obj;
  	
}