//by+2017-03-06+dhcclcscore
function InitViewScreen(){
	var obj = new Object();
	
	obj.clcscorecode = new Ext.form.TextField({
		id : 'clcscorecode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.clcscorefactor = new Ext.form.TextField({
		id : 'clcscorefactor'
		,fieldLabel : '系数'
		,labelSeparator: ''
		,anchor : '95%'
	});
			
	obj.clcscorecaneditstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.clcscorecaneditstore = new Ext.data.Store({
		proxy: obj.clcscorecaneditstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	
	
	obj.clcscorecanedit = new Ext.form.ComboBox({
		id : 'clcscorecanedit'
		,store:obj.clcscorecaneditstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '能否编辑'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });	
    
	
	
	obj.clcscoredesc = new Ext.form.TextField({
		id : 'clcscoredesc'
		,fieldLabel : '描述'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	
	obj.clcscorebasevalue = new Ext.form.TextField({
		id : 'clcscorebasevalue'
		,fieldLabel : '基值'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	
	obj.clcscoreJianYan = new Ext.form.TextField({
		id : 'clcscoreJianYan'
		,fieldLabel : '检验结果'
		,labelSeparator: ''
		,labelWidth : 100
		,anchor : '95%'
	}); 
	
	obj.clcscoreuomdr = new Ext.form.TextField({
		id : 'clcscoreuomdr'
		,fieldLabel : 'uom指向'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,labelWidth : 100
		,columnWidth:.2
		,layout : 'form'
		,items:[
			obj.clcscorecode
			,obj.clcscorefactor
			,obj.clcscorecanedit
			,obj.clcscoreJianYan
			,obj.Rowid
		]
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,labelWidth : 100
		,columnWidth:.2
		,layout : 'form'
		,items:[
			obj.clcscoredesc
			,obj.clcscorebasevalue
			,obj.clcscoreuomdr
		]
	});

	obj.clcscoreismainstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.clcscoreismainstore = new Ext.data.Store({
		proxy: obj.clcscoreismainstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.clcscoreismain = new Ext.form.ComboBox({
		id : 'clcscoreismain'
		,store:obj.clcscoreismainstore
		,minChars:1
		,displayField:'Desc'
		,labelSeparator: ''
		,fieldLabel : '是否主评分'
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
	});

	obj.clcscoretypestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.clcscoretypestore = new Ext.data.Store({
		proxy: obj.clcscoretypestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.clcscoretype = new Ext.form.ComboBox({
		id : 'clcscoretype'
		,store:obj.clcscoretypestore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '类型'
		,labelSeparator: ''
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.clcscomordstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.clcscomordstore = new Ext.data.Store({
		proxy: obj.clcscomordstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	
	
	obj.clcscomord = new Ext.form.ComboBox({
		id : 'clcscomord'
		,store:obj.clcscomordstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '关联医嘱项'
		,labelSeparator: ''
		,valueField : 'ID'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,labelWidth : 100
		,columnWidth:.2
		,layout : 'form'
		,items:[
			obj.clcscoretype
			,obj.clcscoreismain
			,obj.clcscomord
			]
	});	
	
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,text : '添加'
		,iconCls : 'icon-add'
		,width:86
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,text : '更新'
		,width:86
		,iconCls : 'icon-updateSmall'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,text : '删除'
		,width:86
		,iconCls : 'icon-delete'
	});
	/*obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,text : '查找'
	});*/
	
	obj.addButtonPanel = new Ext.Panel({
		id : 'addButtonPanel'
		,buttonAlign : 'right'
		,layout : 'form'
		,items:[
		    obj.addbutton
		]

	});
	obj.deleteButtonPanel = new Ext.Panel({
		id : 'deleteButtonPanel'
		,buttonAlign : 'center'	
		,layout : 'form'
		,style:'margin-top :3px;'
		,items:[
		    obj.deletebutton
		]

	});
	obj.updatebuttonPanel = new Ext.Panel({
		id : 'updatebuttonPanel'
		,buttonAlign : 'center'
		,style:'margin-top :3px;'
		
		,layout : 'form'
		,items:[
		   obj.updatebutton
		    ]

	});	
	obj.buttonPanel = new Ext.Panel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 100
		,columnWidth:.2
		,style:'margin-left :30px;'
		//,region : 'south'
		,layout : 'form'
		,items:[
			obj.addButtonPanel
			,obj.deleteButtonPanel 
			,obj.updatebuttonPanel
		]
	});
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.buttonPanel
		]
	});	
	
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 140
		,title : '评分项码表维护'
		,iconCls : 'icon-manage'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
			//,obj.buttonPanel
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
			idProperty: 'TRowid'
		}, 
	    [
			,{name: 'TRowid', mapping : 'TRowid'}
			,{name: 'TCLCSCode', mapping: 'TCLCSCode'}
			,{name: 'TCLCSDesc', mapping: 'TCLCSDesc'}
			,{name: 'TCLCSType', mapping: 'TCLCSType'}
			,{name: 'TCLCSFactor', mapping: 'TCLCSFactor'}
			,{name: 'TCLCSBaseValue', mapping: 'TCLCSBaseValue'}
			,{name: 'TCLCSIsMainScore', mapping: 'TCLCSIsMainScore'}
			,{name: 'TCLCSCanEdit', mapping: 'TCLCSCanEdit'}
			,{name: 'TCLCSUomdr', mapping: 'TCLCSUomdr'}
			,{name: 'TCLCSComOrdDr', mapping: 'TCLCSComOrdDr'}
			,{name: 'TCLCSComOrd', mapping: 'TCLCSComOrd'}
			,{name: 'TCLCSJianYan', mapping: 'TCLCSJianYan'}
		])
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		//,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: 'ID值', width: 40, dataIndex: 'TRowid', sortable: true}
		,{header: '代码', width: 150, dataIndex: 'TCLCSCode', sortable: true}
		,{header: '描述', width: 150, dataIndex: 'TCLCSDesc', sortable: true}
		,{header: '类型', width: 100, dataIndex: 'TCLCSType', sortable: true}
		,{header: '系数', width: 40, dataIndex: 'TCLCSFactor', sortable: true}
		,{header: '基值', width: 50, dataIndex: 'TCLCSBaseValue', sortable: true}
		,{header: '是否主评分', width: 80, dataIndex: 'TCLCSIsMainScore', sortable: true}
		,{header: '能否编辑', width: 60, dataIndex: 'TCLCSCanEdit', sortable: true}
		,{header: 'uom指向', width: 100, dataIndex: 'TCLCSUomdr', sortable: true}
		//,{header: '关联医嘱项ID', width: 100, dataIndex: 'TCLCSComOrdDr', sortable: true}
		,{header: '关联医嘱项', width: 150, dataIndex: 'TCLCSComOrd', sortable: true}
		,{header: '检验项目', width: 100, dataIndex: 'TCLCSJianYan', sortable: true}
		]
//		,viewConfig:
//		{
//			forceFit: false
//		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
	});

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

	obj.clcscorecaneditstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCScore';
		param.QueryName = 'FindBoolen';
		param.ArgCnt = 0;
	});
	obj.clcscorecaneditstore.load({});
	
	obj.clcscoreismainstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCScore';
		param.QueryName = 'FindBoolen';
		param.ArgCnt = 0;
	});
	obj.clcscoreismainstore.load({});
	
	obj.clcscoretypestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCScore';
		param.QueryName = 'FindType';
		param.ArgCnt = 0;
	});
	obj.clcscoretypestore.load({});
	
	obj.clcscomordstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUPara';
		param.QueryName = 'FindANCComOrd';
		param.Arg1="";
		param.Arg2=obj.clcscomord.getRawValue();
		param.Arg3="Y";
		param.ArgCnt = 3;
	});
	obj.clcscomordstore.load({});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCScore';
		param.QueryName = 'FindCLCScore';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	
    obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.functionPanel
			,obj.resultPanel
		]
	});
	
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.retGridPanel.on("rowdblclick", obj.retGridPanel_rowdblclick, obj);
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
  //obj.findbutton.on("click", obj.findbutton_click, obj);

    obj.LoadEvent(arguments);
	return obj;
}

///////////////////////////////////////////////////////////////////////////////////

function InitWinScreen(){
	var obj = new Object();

	obj.clcsoptioncode = new Ext.form.TextField({
		id : 'clcsoptioncode'
		,fieldLabel : '代码'
		,anchor : '80%'
	});
	
	obj.clcsopmaxvalue = new Ext.form.TextField({
		id : 'clcsopmaxvalue'
		,fieldLabel : '最大值'
		,anchor : '80%'
	});
	
	obj.opRowid = new Ext.form.TextField({
		id : 'opRowid'
		,hidden : true
    });	  
    
    obj.opclcsotype = new Ext.form.TextField({
		id : 'opclcsotype'
		,hidden : true
    });	 

	obj.opPanel1 = new Ext.Panel({
		id : 'opPanel1'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.clcsoptioncode
			,obj.clcsopmaxvalue
			,obj.opRowid
			,obj.opclcsotype
		]
	});
	
	obj.clcsoptiondesc = new Ext.form.TextField({
		id : 'clcsoptiondesc'
		,fieldLabel : '描述'
		,anchor : '80%'
	}); 
	
	obj.clcscorevalue = new Ext.form.TextField({
		id : 'clcscorevalue'
		,fieldLabel : '评分值'
		,anchor : '80%'
	}); 
	
	obj.opPanel2 = new Ext.Panel({
		id : 'opPanel2'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.clcsoptiondesc
			,obj.clcscorevalue
		]
	});
	
	obj.clcsopminvalue = new Ext.form.TextField({
		id : 'clcsopminvalue'
		,fieldLabel : '最小值'
		,anchor : '80%'
	}); 
	obj.opCLCSRowid = new Ext.form.TextField({
		id : 'opCLCSRowid'
		,fieldLabel : '父表ID'
		,anchor : '80%'
    });	  
	obj.opPanel3 = new Ext.Panel({
		id : 'opPanel3'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.clcsopminvalue
			,obj.opCLCSRowid
			]
	});
	
	obj.opconditionPanel = new Ext.form.FormPanel({
		id : 'opconditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.opPanel1
			,obj.opPanel2
			,obj.opPanel3
		]
	});	
	
	obj.opaddbutton = new Ext.Button({
		id : 'opaddbutton'
		,text : '添加'
	});
	obj.opupdatebutton = new Ext.Button({
		id : 'opupdatebutton'
		,text : '更新'
	});
	obj.opdeletebutton = new Ext.Button({
		id : 'opdeletebutton'
		,text : '删除'
	});
	obj.opexitbutton = new Ext.Button({
		id : 'opexitbutton'
		,text : '退出'
	});
	
	obj.opkeypanel = new Ext.Panel({
		id : 'opkeypanel'
		,buttonAlign : 'center'
		,layout : 'column'
        ,buttons:[
            obj.opaddbutton
            ,obj.opupdatebutton
            ,obj.opdeletebutton
            ,obj.opexitbutton
       ]
	});
	
	obj.opbuttonPanel = new Ext.form.FormPanel({
		id : 'opbuttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,height : 50
		,region : 'south'
		,layout : 'column'
		,frame : false
		,items:[
			obj.opkeypanel
		]
	});
	obj.opfunctionPanel = new Ext.Panel({
		id : 'opfunctionPanel'
		,buttonAlign : 'center'
		,height : 120
		//,title : '评分项码表维护'
		,region : 'north'
		,layout : 'border'
		,frame : true
		//,collapsible:true
		//,animate:true
		,items:[
			obj.opconditionPanel
			,obj.opbuttonPanel
		]
    });
    
	obj.opretGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.opretGridPanelStore = new Ext.data.Store({
		proxy: obj.opretGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'TRowid'
		}, 
	    [
			{name: 'TRowid', mapping : 'TRowid'}
			,{name: 'TCLCSRowid', mapping: 'TCLCSRowid'}
			,{name: 'TCLCSOCode', mapping: 'TCLCSOCode'}
			,{name: 'TCLCSODesc', mapping: 'TCLCSODesc'}
			,{name: 'TCLCSOMinValue', mapping: 'TCLCSOMinValue'}
			,{name: 'TCLCSOMaxValue', mapping: 'TCLCSOMaxValue'}
			,{name: 'TCLCSOScoreValue', mapping: 'TCLCSOScoreValue'}
			,{name: 'TCLCSOType', mapping: 'TCLCSOType'}
		])
	});

    obj.opretGridPanel = new Ext.grid.EditorGridPanel({
		id : 'opretGridPanel'
		,store : obj.opretGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: 'ID值', width: 50, dataIndex: 'TRowid', sortable: true}
		,{header: '评分表ID值', width: 100, dataIndex: 'TCLCSRowid', sortable: true}
		,{header: '代码', width: 50, dataIndex: 'TCLCSOCode', sortable: true}
		,{header: '描述', width: 100, dataIndex: 'TCLCSODesc', sortable: true}
		,{header: '类型', width: 50, dataIndex: 'TCLCSOType', sortable: true}
		,{header: '最小值', width: 100, dataIndex: 'TCLCSOMinValue', sortable: true}
		,{header: '最大值', width: 100, dataIndex: 'TCLCSOMaxValue', sortable: true}
		,{header: '评分值', width: 100, dataIndex: 'TCLCSOScoreValue', sortable: true}
		]
	});

	obj.opPanel23 = new Ext.Panel({
		id : 'opPanel23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.opPanel25 = new Ext.Panel({
		id : 'opPanel25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});	
   	obj.opresultPanel = new Ext.Panel({
		id : 'opresultPanel'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.opPanel23
			,obj.opPanel25
		    ,obj.opretGridPanel
		]
	});
    obj.WinScreen = new Ext.Window({
		id : 'WinScreen'
		,height : 500
		,buttonAlign : 'center'
		,width : 700
		,modal : true
		,title : '评分选项编辑'
		,layout : 'border'
		,items:[
			obj.opfunctionPanel
			,obj.opresultPanel
		]
	});	

//	obj.opretGridPanelStoreProxy.on('beforeload', function(objProxy, param){
//		param.ClassName = 'web.DHCCLCScore';
//		param.QueryName = 'FindClCSOption';
//		param.Arg1=5;
//		//param.Arg1 = obj.opCLCSRowid.getValue();
//		param.ArgCnt = 1;
//	});
//	obj.opretGridPanelStore.load({});  
	
	InitWinScreenEvent(obj);
	
    obj.opaddbutton.on("click", obj.opaddbutton_click, obj);
	obj.opdeletebutton.on("click", obj.opdeletebutton_click, obj);
	obj.opupdatebutton.on("click", obj.opupdatebutton_click, obj);
    obj.opexitbutton.on("click", obj.opexitbutton_click, obj); 
    obj.opretGridPanel.on("rowclick", obj.opretGridPanel_rowclick, obj);
   
    obj.LoadEvent(arguments);    
    return obj;
}