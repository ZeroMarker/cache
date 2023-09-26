//update by GY 20170307
function InitViewScreen(){
	var obj = new Object();
	obj.bpcCCode = new Ext.form.TextField({
		id : 'bpcCCode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.bpcCMembraneArea = new Ext.form.TextField({
		id : 'bpcCMembraneArea'
		,fieldLabel : '膜面积'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	 //透析方式	
    obj.BPCBPModeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.BPCBPModeStore = new Ext.data.Store({
	    proxy : obj.BPCBPModeStoreProxy
		,reader : new Ext.data.JsonReader({
		    root : 'record'
			,totalProperty : 'total'
			,idProperty : 'tBPCBPMRowId'
		},
		[   
		     {name: 'checked', mapping : 'checked'}
		    ,{name:'tBPCBPMDesc',mapping:'tBPCBPMDesc'}
			,{name:'tBPCBPMRowId',mapping:'tBPCBPMRowId'}
			,{name:'tBPCBPMDept',mapping:'tBPCBPMDept'}
		])
	
	});
	
	obj.BPCBPMode = new Ext.ux.form.LovCombo({
	    id : 'BPCBPMode'
		,store : obj.BPCBPModeStore
		,minChars : 1
		,displayField : 'tBPCBPMDesc' //+'tBPCBPMDept'
		,fieldLabel : '透析方式'
		,valueField : 'tBPCBPMRowId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '85%'
	}); 
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });	
    
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,labelWidth : 50
		,items:[
			obj.bpcCCode
			,obj.bpcCMembraneArea
			//,obj.BPCBPMode
			,obj.Rowid
		]
	});
	
	obj.bpcCDesc = new Ext.form.TextField({
		id : 'bpcCDesc'
		,fieldLabel : '描述'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.bpcCHighFluxedstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextyn(v, record) { 
         return record.Id+" || "+record.Desc; 
    } 
	obj.bpcCHighFluxedstore = new Ext.data.Store({
		proxy: obj.bpcCHighFluxedstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{ name: 'selecttext', convert: seltextyn}
			//,{name: 'Desc', mapping : 'Desc'}
		])
	});
	obj.bpcCHighFluxed = new Ext.form.ComboBox({
		id : 'bpcCHighFluxed'
		,store:obj.bpcCHighFluxedstore
		,minChars:1
		//,displayField:'Desc'
		,displayField:'selecttext'
		,fieldLabel : '是否高通量'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
		
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .30
		,layout : 'form'
		,labelWidth : 80
		,items:[
			obj.bpcCDesc
			,obj.bpcCHighFluxed
		]
	});
	
	obj.bpcCTypestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltexttype(v, record) { 
         return record.Id+" || "+record.Desc; 
    } 
	obj.bpcCTypestore = new Ext.data.Store({
		proxy: obj.bpcCTypestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{ name: 'selecttext', convert: seltexttype}
			//,{name: 'Desc', mapping : 'Desc'}
			
		])
	});
	obj.bpcCType = new Ext.form.ComboBox({
		id : 'bpcCType'
		,store:obj.bpcCTypestore
		,minChars:1
		//,displayField:'Desc'
		,displayField:'selecttext'
		,fieldLabel : '类型'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});

	obj.bpcCArcimDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltextarcim(v, record) { 
         return record.Id+" || "+record.Desc; 
    }
	obj.bpcCArcimDrstore = new Ext.data.Store({
		proxy: obj.bpcCArcimDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'Id', mapping: 'Id'}
			,{ name: 'selecttext', convert: seltextarcim}
			//,{name: 'arcimDesc', mapping : 'arcimDesc'}
		])
	});
	obj.bpcCArcimDr = new Ext.form.ComboBox({
		id : 'bpcCArcimDr'
		,store:obj.bpcCArcimDrstore
		,minChars:1
		//,displayField:'arcimDesc'
		,displayField:'selecttext'
		,fieldLabel : '医嘱'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
			
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .25
		,layout : 'form'
		,labelWidth : 30
		,items:[
			obj.bpcCType
			,obj.bpcCArcimDr
		]
	});	
obj.bpcCtlocDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.bpcCtlocDrstore = new Ext.data.Store({
		proxy: obj.bpcCtlocDrstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'oprLocId'
		}, 
		[
			{name: 'oprLocId', mapping: 'oprLocId'}
			,{name: 'oprCtLoc', mapping : 'oprCtLoc'}
		])
	});
	obj.bpcCtlocDr = new Ext.form.ComboBox({
		id : 'bpcCtlocDr'
		,store:obj.bpcCtlocDrstore
		,minChars:1
		,displayField:'oprCtLoc'
		,fieldLabel : '科室'
		,valueField : 'oprLocId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.bpcCtlocDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCInquiry';
		param.QueryName = 'ctloclookup';
		param.Arg1=obj.bpcCtlocDr.getRawValue();
		param.ArgCnt = 1;
	});
	obj.bpcCtlocDrstore.load({});
	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .20
		,layout : 'form'
		,labelWidth : 30
		,items:[
			obj.bpcCtlocDr
		]
	});	
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,region : 'center'
		,layout : 'column'
		,columnWidth : .78
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
		]
	});

	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:86
		,iconCls : 'icon-add'
		,text : '增加'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:86
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:86
		,iconCls : 'icon-updateSmall'	
		,text : '更新'
	});
	
	obj.keypanel1 = new Ext.Panel({
		id : 'keypanel1'
		,buttonAlign : 'center'
		,layout : 'form'
		,columnWidth : .3
        ,items:[
            obj.addbutton
       ]
	});
	obj.keypanel2 = new Ext.Panel({
		id : 'keypanel2'
		,buttonAlign : 'center'
		,layout : 'form'
		,columnWidth : .3
        ,items:[
              obj.updatebutton
       ]
	});	
	obj.keypanel3 = new Ext.Panel({
		id : 'keypanel3'
		,buttonAlign : 'center'
		,layout : 'form'
		,columnWidth : .3
        ,items:[
              obj.deletebutton
       ]
	});		
	obj.buttonPanel = new Ext.form.FormPanel({
		id : 'buttonPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,height : 40
		,layout : 'column'
		//,columnWidth : .3
		,frame : false
		,items:[
			obj.keypanel1
			,obj.keypanel2
			,obj.keypanel3
		]
	});
	obj.Panel = new Ext.Panel({
		id : 'Panel'
		,buttonAlign : 'center'
		,columnWidth : .22
		,layout : 'form'
		,labelWidth : 60
		,items:[
				obj.BPCBPMode
				,obj.buttonPanel
		]
	});	
	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 90
		,title : '材料码表维护'
		,iconCls : 'icon-manage'
		,region : 'north'
		,layout : 'column'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.conditionPanel
			,obj.Panel
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
			idProperty: 'tID'
		}, 
	    [
			,{name: 'tID', mapping : 'tID'}
			,{name: 'tBPCCCode', mapping: 'tBPCCCode'}
			,{name: 'tBPCCDesc', mapping: 'tBPCCDesc'}
			,{name: 'tBPCCType', mapping: 'tBPCCType'}
			,{name: 'tBPCCTypeD', mapping: 'tBPCCTypeD'}
			,{name: 'tBPCCMembraneArea', mapping: 'tBPCCMembraneArea'}
			,{name: 'tBPCCHighFluxed', mapping: 'tBPCCHighFluxed'}
			,{name: 'tBPCCHighFluxedD', mapping: 'tBPCCHighFluxedD'}
			,{name: 'tBPCCArcimDr', mapping: 'tBPCCArcimDr'}
			,{name: 'tBPCCArcim', mapping: 'tBPCCArcim'}
			,{name: 'tBPCBPMRowId', mapping: 'tBPCBPMRowId'}
			,{name: 'tBPCBPMDesc', mapping: 'tBPCBPMDesc'}
			,{name: 'tBPCBPMDept', mapping: 'tBPCBPMDept'}
			,{name: 'tBPCBPMDeptDr', mapping: 'tBPCBPMDeptDr'}
		])
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: '代码', width: 150, dataIndex: 'tBPCCCode', sortable: true}
		,{header: '描述', width: 200, dataIndex: 'tBPCCDesc', sortable: true}
		,{header: '类型', width: 150, dataIndex: 'tBPCCTypeD', sortable: true}
		,{header: '膜面积', width: 100, dataIndex: 'tBPCCMembraneArea', sortable: true}
		,{header: '是否高通量', width: 80, dataIndex: 'tBPCCHighFluxedD', sortable: true}
		,{header: '医嘱', width: 200, dataIndex: 'tBPCCArcim', sortable: true}
		,{header: '透析方式', width: 200, dataIndex: 'tBPCBPMDesc', sortable: true}
		,{header: '科室', width: 200, dataIndex: 'tBPCBPMDept', sortable: true}
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
	
    obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			obj.functionPanel
			,obj.resultPanel
		]
	});
	
	obj.BPCBPModeStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCBloodPurificationMode';
		param.QueryName = 'FindDHCBPCBPMode';
		//param.Arg1 = obj.bpcCtlocDr.getValue();
		param.Arg1 = "";
		param.ArgCnt = 1;
	}); 
	obj.BPCBPModeStore.load({});

	obj.bpcCHighFluxedstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCConsumable';
		param.QueryName = 'FindCBoolen';
		param.ArgCnt = 0;
	});
	obj.bpcCHighFluxedstore.load({});
		
	obj.bpcCTypestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCConsumable';
		param.QueryName = 'FindCType';
		param.ArgCnt = 0;
	});
	obj.bpcCTypestore.load({});
	
	obj.bpcCArcimDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPOrder';
		param.QueryName = 'GetArcimList';
		param.Arg1=" ";
		param.Arg2=obj.bpcCArcimDr.getRawValue();
		param.ArgCnt = 2;
	});
	obj.bpcCArcimDrstore.load({});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCConsumable';
		param.QueryName = 'FindConsumable';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});
	
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.bpcCtlocDr.on('select',obj.bpcCtlocDr_select,obj);
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}