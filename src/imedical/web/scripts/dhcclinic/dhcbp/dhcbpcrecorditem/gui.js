//20170307+dyl
function InitViewScreen(){
	var obj=new Object();
		obj.BPCRIRowId = new Ext.form.TextField({
		id : 'BPCRIRowId'
		,hidden:true
		,anchor : '95%'
	});
	obj.BPCRICode = new Ext.form.TextField({
		id : 'BPCRICode'
		,fieldLabel : '记录项目代码'
		,labelSeparator: ''
		,anchor : '95%'
	});

	obj.BPCRIDesc = new Ext.form.TextField({
		id : 'BPCRIDesc'
		,fieldLabel : '记录项目名称'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.BPCRIMultiValueDesc = new Ext.form.TextField({
		id : 'BPCRIMultiValueDesc'
		,fieldLabel : '多数值代码串'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.BPCRIOptions = new Ext.form.TextField({
		id : 'BPCRIOptions'
		,fieldLabel : '选项指针'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.BPCRISortNo = new Ext.form.TextField({
		id : 'BPCRISortNo'
		,fieldLabel : '排序号'
		,labelSeparator: ''
		,anchor : '95%'
	});
		obj.BPCRIMin = new Ext.form.TextField({
		id : 'BPCRIMin'
		,fieldLabel : '正常最小值'
		,labelSeparator: ''
		,anchor : '95%'
	});
		
	obj.BPCRIMax = new Ext.form.TextField({
		id : 'BPCRIMax'
		,fieldLabel : '正常最大值'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
		
	obj.BPCRIImpossibleMin = new Ext.form.TextField({
		id : 'BPCRIImpossibleMin'
		,fieldLabel : '不可能最小值'
		,labelSeparator: ''
		,anchor : '95%'
	});
		obj.BPCRIImpossibleMax = new Ext.form.TextField({
		id : 'BPCRIImpossibleMax'
		,fieldLabel : '不可能最大值'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	
	obj.BPCRIMainRecordItemDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
    function seltextmain(v, record) { 
         return record.BPCRIRowId+" || "+record.BPCRIDesc; 
    } 
   	obj.BPCRIMainRecordItemDrStore = new Ext.data.Store({
      	proxy: obj.BPCRIMainRecordItemDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'BPCRIRowId'   
      		}, 
      		[	
      			{name: 'BPCRIRowId', mapping: 'BPCRIRowId'}
      			,{ name: 'selecttext', convert: seltextmain}
      			//,{name: 'BPCRICode', mapping: 'BPCRICode'}
      			//,{name: 'BPCRIDesc', mapping: 'BPCRIDesc'}
    
      		])
      	});		
   obj.BPCRIMainRecordItemDr =new Ext.form.ComboBox({
      	id : 'obj.BPCRIMainRecordItemDr'
      	,store : obj.BPCRIMainRecordItemDrStore
      	,minChars : 0
      	//,displayField : 'BPCRIDesc'
      	,displayField : 'selecttext'
      	,fieldLabel : '主记录项'
      	,labelSeparator: ''
      	,valueField : 'BPCRIRowId'
      	,editable : false
      	,triggerAction : 'all'
      	,anchor : '95%'
              });	
    obj.BPCRIMainRecordItemDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCBPCRecordItem';
      	param.QueryName = 'FindBPCRecordItem';
      	param.ArgCnt = 0;
      	});
      	obj.BPCRIMainRecordItemDrStore.load();
	
	obj.BPCRIBPCRecordCatDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
      	
    function seltextcat(v, record) { 
         return record.BPCRCId+" || "+record.BPCRCDesc; 
    } 
   	obj.BPCRIBPCRecordCatDrStore = new Ext.data.Store({
      	proxy: obj.BPCRIBPCRecordCatDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'BPCRCId'   
      		}, 
      		[	
      			{name: 'BPCRCId', mapping: 'BPCRCId'}
      			,{ name: 'selecttext', convert: seltextcat}
      			//,{name: 'BPCRCCode', mapping: 'BPCRCCode'}
      			//,{name: 'BPCRCDesc', mapping: 'BPCRCDesc'}
    
      		])
      	});		
   obj.BPCRIBPCRecordCatDr =new Ext.form.ComboBox({
      	id : 'obj.BPCRIBPCRecordCatDr'
      	,store : obj.BPCRIBPCRecordCatDrStore
      	,minChars : 0
      	//,displayField : 'BPCRCDesc'
      	,displayField : 'selecttext'
      	,fieldLabel : '监护大类'
      	,labelSeparator: ''
      	,valueField : 'BPCRCId'
      	,editable : false
      	,triggerAction : 'all'
      	,anchor : '95%'
              });	
    obj.BPCRIBPCRecordCatDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCBPCRecordItem';
      	param.QueryName = 'FindBPCReCat';
      	param.ArgCnt = 0;
      	});
      	obj.BPCRIBPCRecordCatDrStore.load();  
  	
    obj.BPCRIArcimDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
    function seltextarcim(v, record) { 
         return record.arcimId+" || "+record.arcimDesc; 
    } 
   	obj.BPCRIArcimDrStore = new Ext.data.Store({
      	proxy: obj.BPCRIArcimDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'arcimId'   
      		}, 
      		[	
      			{name: 'arcimId', mapping: 'arcimId'}
      			,{ name: 'selecttext', convert: seltextarcim}
      			//,{name: 'arcimDesc', mapping: 'arcimDesc'}
    
      		])
      	});		
   obj.BPCRIArcimDr =new Ext.form.ComboBox({
      	id : 'obj.BPCRIArcimDr'
      	,store : obj.BPCRIArcimDrStore
      	,minChars : 0
      	//,displayField : 'arcimDesc'
      	,displayField : 'selecttext'
      	,fieldLabel : '医嘱名称'
      	,labelSeparator: ''
      	,valueField : 'arcimId'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '95%'
              });	
    obj.BPCRIArcimDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANCCommonOrd';
      	param.QueryName = 'GetMasterItem';
      	param.Arg1 = " ";
      	param.Arg2 = obj.BPCRIArcimDr.getRawValue();
      	param.ArgCnt = 2;
      	});
      	obj.BPCRIArcimDrStore.load();
	
    obj.BPCRIUomDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
    function seltextuom(v, record) { 
         return record.UomRowId+" || "+record.UomDesc; 
    } 
   	obj.BPCRIUomDrStore = new Ext.data.Store({
      	proxy: obj.BPCRIUomDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'UomRowId'   
      		}, 
      		[	
      			{name: 'UomRowId', mapping: 'UomRowId'}
      			,{ name: 'selecttext', convert: seltextuom}
      			//,{name: 'UomDesc', mapping: 'UomDesc'}
    
      		])
      	});		
   obj.BPCRIUomDr =new Ext.form.ComboBox({
      	id : 'obj.BPCRIUomDr'
      	,store : obj.BPCRIUomDrStore
      	,minChars : 0
      	//,displayField : 'UomDesc'
      	,displayField : 'selecttext'
      	,fieldLabel : '单位'
      	,labelSeparator: ''
      	,valueField : 'UomRowId'
      	,editable : false
      	,triggerAction : 'all'
      	,anchor : '95%'
              });	
    obj.BPCRIUomDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANCCommonOrd';
      	param.QueryName = 'FindUom';
      	param.ArgCnt = 0;
      	});
      	obj.BPCRIUomDrStore.load();
      	 
    obj.BPCRITypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
    function seltexttype(v, record) { 
         return record.RowId+" || "+record.Desc; 
    }
   	obj.BPCRITypeStore = new Ext.data.Store({
      	proxy: obj.BPCRITypeStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'RowId'   
      		}, 
      		[	
      			{name: 'RowId', mapping: 'RowId'}
      			,{ name: 'selecttext', convert: seltexttype}
      			//,{name: 'Desc', mapping: 'Desc'}
    
      		])
      	});		
   obj.BPCRIType =new Ext.form.ComboBox({
      	id : 'obj.BPCRIType'
      	,store : obj.BPCRITypeStore
      	,minChars : 0
      	//,displayField : 'Desc'
      	,displayField : 'selecttext'
      	,fieldLabel : '记录类型'
      	,labelSeparator: ''
      	,valueField : 'RowId'
      	,editable : false
      	,triggerAction : 'all'
      	,anchor : '95%'
              });	
    obj.BPCRITypeStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCBPCRecordItem';
      	param.QueryName = 'FindBPCRIType';
      	param.ArgCnt = 0;
      	});
      	obj.BPCRITypeStore.load();
      	
    obj.BPCRIDataTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
    function seltextdt(v, record) { 
         return record.RowId+" || "+record.Desc; 
    } 
   	obj.BPCRIDataTypeStore = new Ext.data.Store({
      	proxy: obj.BPCRIDataTypeStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'RowId'   
      		}, 
      		[	
      			{name: 'RowId', mapping: 'RowId'}
      			,{ name: 'selecttext', convert: seltextdt}
      			//,{name: 'Desc', mapping: 'Desc'}
    
      		])
      	});		
   obj.BPCRIDataType =new Ext.form.ComboBox({
      	id : 'obj.BPCRIDataType'
      	,store : obj.BPCRIDataTypeStore
      	,minChars : 0
      	//,displayField : 'Desc'
      	,displayField : 'selecttext'
      	,fieldLabel : '数值类型'
      	,labelSeparator: ''
      	,valueField : 'RowId'
      	,editable : false
      	,triggerAction : 'all'
      	,anchor : '95%'
              });	
    obj.BPCRIDataTypeStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCBPCRecordItem';
      	param.QueryName = 'BPCRIDataType';
      	param.ArgCnt = 0;
      	});
      	obj.BPCRIDataTypeStore.load();
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .16
		,layout : 'form'
		,items:[
		obj.BPCRICode
		,obj.BPCRIArcimDr
		,obj.BPCRIMultiValueDesc
		]
	});
	obj.Panel2= new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .16
		,layout : 'form'
		,items:[
		obj.BPCRIDesc
		,obj.BPCRIUomDr
		,obj.BPCRISortNo
		]
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .16
		,layout : 'form'
		,items:[
		obj.BPCRIBPCRecordCatDr
		,obj.BPCRIOptions  
		,obj.BPCRIMin
		,obj.BPCRIRowId
		]
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .16
		,layout : 'form'
		,items:[
		obj.BPCRIType
		,obj.BPCRIDataType
		,obj.BPCRIMax
		]
	});
		obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .16
		,layout : 'form'
		,items:[
		obj.BPCRIImpossibleMin
		,obj.BPCRIImpossibleMax
		,obj.BPCRIMainRecordItemDr
		]
	});
		obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,width:86
		,text : '查询'
	});
		obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,style:'margin-left:20px'
		,width:86
		,iconCls:'icon-add'
		,text : '增加'
	});
		obj.btnUpd = new Ext.Button({
		id : 'btnUpd'
		,style:'margin-top:3px;margin-left:20px'
		,width:86
		,iconCls:'icon-edit'
		,text : '更新'
	});
		obj.btnDel = new Ext.Button({
		id : 'btnDel'
		,width:86
		,iconCls:'icon-delete'
		,style:'margin-top:3px;margin-left:20px'
		,text : '删除'
	});
	obj.buttonpanel = new Ext.Panel({
		id : 'buttonpanel'
		,buttonAlign : 'left'
		,columnWidth : .18
		,layout : 'form'
		,items:[
		obj.btnAdd
		,obj.btnUpd
		,obj.btnDel
		]
		,buttons:[
			
		]
	});

	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,height:80
		,region : 'north'
		,layout : 'column'
		,items:[
		  obj.Panel1
	     ,obj.Panel2
	     ,obj.Panel3
	     ,obj.Panel4
	     ,obj.Panel5
	  	,obj.buttonpanel
		]
	});
	
	
    obj.CLCScoreOptionPanel = new Ext.Panel({
		id : 'CLCScoreOptionPanel'
		,buttonAlign : 'center'
		,height : 120
		,title : '记录项目'
		,iconCls:'icon-manage'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
		     obj.fPanel
		     //,obj.chkFormPanel
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
			idProperty: 'tRowId'   
		}, 
		[	
			{name: 'tRowId', mapping: 'tRowId'}
			,{name: 'tBPCRICode', mapping: 'tBPCRICode'}
			,{name: 'tBPCRIDesc', mapping: 'tBPCRIDesc'}
			,{name: 'tBPCRIBPCRecordCatDr', mapping: 'tBPCRIBPCRecordCatDr'}
			,,{name: 'tBPCRIBPCRecordCat', mapping: 'tBPCRIBPCRecordCat'}
			,{name: 'tBPCRITypeDr', mapping: 'tBPCRITypeDr'}
			,,{name: 'tBPCRIType', mapping: 'tBPCRIType'}
			,{name: 'tBPCRIArcimDr', mapping: 'tBPCRIArcimDr'}
			,,{name: 'tBPCRIArcim', mapping: 'tBPCRIArcim'}
			,{name: 'tBPCRIUomDr', mapping: 'tBPCRIUomDr'}
			,{name: 'tBPCRIUom', mapping: 'tBPCRIUom'}
			,{name: 'tBPCRIOptions', mapping: 'tBPCRIOptions'}
			,{name: 'tBPCRIDataType', mapping: 'tBPCRIDataType'}
			,{name: 'tBPCRIDataTypeDr', mapping: 'tBPCRIDataTypeDr'}
			,{name: 'tBPCRIMultiValueDesc', mapping: 'tBPCRIMultiValueDesc'}
			,{name: 'tBPCRISortNo', mapping: 'tBPCRISortNo'}
			,{name: 'tBPCRIMin', mapping: 'tBPCRIMin'}
			,{name: 'tBPCRIMax', mapping: 'tBPCRIMax'}
			,{name: 'tBPCRIImpossibleMin', mapping: 'tBPCRIImpossibleMin'}
			,{name: 'tBPCRIImpossibleMax', mapping: 'tBPCRIImpossibleMax'}
			,{name: 'tBPCRIMainRecordItem', mapping: 'tBPCRIMainRecordItem'}
			,{name: 'tBPCRIMainRecordItemDr', mapping: 'tBPCRIMainRecordItemDr'}
	
	]
	)});		
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true            
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,{header: '行号', width: 50, dataIndex: 'tRowId',sortable: true,hidden:true}
			,{header: '监护代码', width: 150, dataIndex: 'tBPCRICode', sortable: true}
			,{header: '监护名称', width: 150, dataIndex: 'tBPCRIDesc', sortable: true}
			,{header: '监护大类', width: 100, dataIndex: 'tBPCRIBPCRecordCat', sortable: true}	
			,{header: '监护类型', width: 100, dataIndex: 'tBPCRIType', sortable: true}	
			,{header: '医嘱名称', width: 100, dataIndex: 'tBPCRIArcim',sortable: true}
			,{header: '单位', width: 100, dataIndex: 'tBPCRIUom', sortable: true}
			,{header: '选项指针', width: 100, dataIndex: 'tBPCRIOptions', sortable: true}
			,{header: '数值类型', width: 100, dataIndex: 'tBPCRIDataType', sortable: true}
			,{header: '多数值代码串', width: 100, dataIndex: 'tBPCRIMultiValueDesc', sortable: true}
			,{header: '排序号', width: 150, dataIndex: 'tBPCRISortNo',sortable: true}
			,{header: '正常最小值', width: 100, dataIndex: 'tBPCRIMin', sortable: true}
			,{header: '正常最大值', width: 100, dataIndex: 'tBPCRIMax', sortable: true}
			,{header: '不可能最小值', width: 100, dataIndex: 'tBPCRIImpossibleMin', sortable: true}	
			,{header: '不可能最大值', width: 100, dataIndex: 'tBPCRIImpossibleMax', sortable: true}
			,{header: '主记录', width: 100, dataIndex: 'tBPCRIMainRecordItem', sortable: true}	
		]
	})
	obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
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
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,plugins : obj.retGridPanelCheckCol
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,tbar:obj.tb
		,items:[
		obj.retGridPanel
		]
	});
		obj.retGridPanelStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCBPCRecordItem';
		param.QueryName = 'FindBPCReItem';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load();
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			 
			 obj.resultPanel
			 ,obj.CLCScoreOptionPanel
		]
	});
	InitViewScreenEvent(obj);
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnDel.on("click", obj.btnDel_click, obj);
	obj.btnAdd.on("click", obj.btnAdd_click, obj);
	obj.btnUpd.on("click", obj.btnUpd_click, obj);
  	obj.LoadEvent(arguments);
	return obj;
}


