//20170307+GY+icoitem
function InitViewScreen(){
	var obj = new Object();
	
	obj.itemcode = new Ext.form.TextField({
		id : 'itemcode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	obj.IcucioiId = new Ext.form.TextField({
		id : 'IcucioiId'
		,hidden : true
    });
    /*
	obj.IcucioiDr = new Ext.form.TextField({
		id : 'IcucioiDr'
		,hidden : true
    });
    */
	obj.itemtypestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.itemtypestore = new Ext.data.Store({
		proxy: obj.itemtypestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tCode'
		}, 
		[
			{name: 'tCode', mapping: 'tCode'}
			,{name: 'tDesc', mapping: 'tDesc'}
		])
	});
	
	
	obj.itemtype = new Ext.form.ComboBox({
		id : 'itemtype'
		,store:obj.itemtypestore
		,minChars:1
		,displayField:'tDesc'
		,fieldLabel : '类型'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
		,labelSeparator: ''
		,mode: 'local'
	});
	
	obj.IcucioiStrategystoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.IcucioiStrategystore = new Ext.data.Store({
		proxy: obj.IcucioiStrategystoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tCode'
		}, 
		[
			{name: 'tCode', mapping: 'tCode'}
			,{name: 'tDesc', mapping: 'tDesc'}
		])
	});
	
	
	obj.IcucioiStrategy = new Ext.form.ComboBox({
		id : 'IcucioiStrategy'
		,store:obj.IcucioiStrategystore
		,minChars:1
		,displayField:'tDesc'
		,fieldLabel : '策略'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
		,labelSeparator: ''
		,mode: 'local'
	});
	
	obj.IcucioiStrategystoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = 'SummaryStrategy';
		param.ArgCnt = 1;
	});
	obj.IcucioiStrategystore.load({});
//	obj.tRowid = new Ext.form.TextField({
//		id : 'tRowid'
//		,hidden : true
//    });	
//     
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 45
		,layout : 'form'
		,items:[
			obj.itemcode
			,obj.itemtype
			//,obj.viewcat
			//,obj.tRowid
			,obj.IcucioiStrategy
			,obj.IcucioiId
			//,obj.IcucioiDr
		]
	});
	
	obj.itemname = new Ext.form.TextField({
		id : 'itemname'
		,fieldLabel : '名称'
		,labelSeparator: ''
		,anchor : '95%'
	}); 

	/*obj.itemviewcatstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
	obj.itemviewcatstore = new Ext.data.Store({
		proxy: obj.itemviewcatstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ICUCRIVCId'
		}, 
		[
		     {name: 'ICUCRIVCId', mapping: 'ICUCRIVCId'}
			,{name: 'ICUCRIVCDesc', mapping: 'ICUCRIVCDesc'}
		])
	});	*/
	/*obj.itemviewcat = new Ext.form.ComboBox({
		id : 'itemviewcat'
		,store:obj.itemviewcatstore
		,minChars:1	
		,displayField:'ICUCRIVCDesc'	
		,fieldLabel : '显示分类'
		,valueField : 'ICUCRIVCId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
		,labelSeparator: ''
		,mode: 'local'
	}); 	*/
	
	obj.IcucioiDrDescstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.IcucioiDrDescstore = new Ext.data.Store({
		proxy: obj.IcucioiDrDescstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tIcucioiId'
		}, 
		[
			{name: 'tIcucioiId', mapping: 'tIcucioiId'}
			,{name: 'tIcucioiDesc', mapping: 'tIcucioiDesc'}
			,{name: 'tIcucioiCode', mapping: 'tIcucioiCode'}
		])
	});
	
	
	obj.IcucioiDrDesc = new Ext.form.ComboBox({
		id : 'IcucioiDrDesc'
		,store:obj.IcucioiDrDescstore
		,minChars:1
		,displayField:'tIcucioiDesc'
		,fieldLabel : '主项名称'
		,valueField : 'tIcucioiId'
		,triggerAction : 'all'
		,anchor : '95%'
		,labelSeparator: ''
		,editable : false
		,selectOnFocus : true
		//,mode: 'local'
	});
	
	obj.IcucioiDrDescstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCIOItem';
		param.QueryName = 'LookupIcucioiDr';
		param.ArgCnt = 0;
	});
	obj.IcucioiDrDescstore.load({});
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,labelWidth : 65
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.itemname
			//,obj.itemviewcat
			,obj.IcucioiDrDesc
			//,obj.viewsupcat
		]
	});

	obj.itemctlocstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.itemctlocstore = new Ext.data.Store({
		proxy: obj.itemctlocstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ctlocId'
		}, 
		[
			,{name: 'ctlocId', mapping: 'ctlocId'}
			,{name: 'ctlocDesc', mapping: 'ctlocDesc'}
		])
	});
	obj.itemctloc = new Ext.form.ComboBox({
		id : 'itemctloc'
		,store:obj.itemctlocstore
		,minChars:1
		,displayField:'ctlocDesc'
		,fieldLabel : '科室'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	});

	obj.itemcomorderstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.itemcomorderstore = new Ext.data.Store({
		proxy: obj.itemcomorderstoreProxy,
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
	obj.itemcomorder = new Ext.form.ComboBox({
		id : 'itemcomorder'
		,store:obj.itemcomorderstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '常用医嘱'
		,valueField : 'ID'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
    
	obj.IcucioiValueFieldstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.IcucioiValueFieldstore = new Ext.data.Store({
		proxy: obj.IcucioiValueFieldstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'DataField', mapping: 'DataField'}
		])
	});
	
	
	obj.IcucioiValueField = new Ext.form.ComboBox({
		id : 'IcucioiValueField'
		,store:obj.IcucioiValueFieldstore
		,minChars:1
		,displayField:'DataField'
		,fieldLabel : '对应字段'
		,valueField : 'DataField'
		,triggerAction : 'all'
		,anchor : '95%'
		,labelSeparator: ''
		,editable : false
		,selectOnFocus : true
		//,mode: 'local'
	});
	
	obj.IcucioiValueFieldstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCommonOrd';
		param.QueryName = 'FindDataField';
		param.ArgCnt = 0;
	});
	obj.IcucioiValueFieldstore.load({});
	
	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,labelWidth : 65
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.itemctloc
			,obj.itemcomorder
			,obj.IcucioiValueField
		]
	});

	obj.itemynusestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.itemynusestore = new Ext.data.Store({
		proxy: obj.itemynusestoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tCode'
		}, 
		[
			{name: 'tCode', mapping: 'tCode'}
			,{name: 'tDesc', mapping: 'tDesc'}
		])
	});
	obj.itemynuse = new Ext.form.ComboBox({
		id : 'itemynuse'
		,store:obj.itemynusestore
		,minChars:1
		,displayField:'tDesc'
		,fieldLabel : '是否可用'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});

	obj.itemusemethodstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.itemusemethodstore = new Ext.data.Store({
		proxy: obj.itemusemethodstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'PHCIN_RowId'
		}, 
		[
			{name: 'PHCIN_RowId', mapping: 'PHCIN_RowId'}
			,{name: 'PHCIN_Desc1', mapping: 'PHCIN_Desc1'}
		])
	});
	obj.itemusemethod = new Ext.form.ComboBox({
		id : 'itemusemethod'
		,store:obj.itemusemethodstore
		,minChars:1
		,displayField:'PHCIN_Desc1'
		,fieldLabel : '用法'
		,valueField : 'PHCIN_RowId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
	});
		
	obj.IcucioiMultiple = new Ext.form.TextField({
		id : 'IcucioiMultiple'
		,fieldLabel : '倍数'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 65
		,layout : 'form'
		,items:[
			obj.itemynuse
			,obj.itemusemethod
			,obj.IcucioiMultiple
		]
	});

	obj.itemynusestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1='YesNo';
		param.ArgCnt = 1;
	});
	obj.itemynusestore.load({});

	obj.itemusemethodstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCOESet';
		param.QueryName = 'GetInstruc';
		param.ArgCnt = 0;
	});
	obj.itemusemethodstore.load({});
	
		obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-add'
		,width:76
		,style:'margin-top:3px'
		,text : '增加'
	});

	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,iconCls : 'icon-updateSmall'
		
		,width:76
		,text : '更新'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,iconCls : 'icon-delete'
		,width:76
		,style:'margin-top:3px'
		,text : '删除'
	});
	obj.findbutton = new Ext.Button({
		id : 'findbutton'
		,iconCls : 'icon-find'
		,width:76
		,text : '查询'
	});
 obj.labelNote=new Ext.form.Label(
	{
		id:'labelNote'
		,text:'代码、名称、科室、是否可用、显示分类为查询项'
		,style:'color:red;font-size:14'
		,width:200
		,height:20
	})	
	obj.btn1 = new Ext.Panel({
		id : 'btn1'
		,buttonAlign : 'center'
		,columnWidth : .12
		,style:'margin-left:20px'
		,layout : 'form'
        ,items:[
            obj.findbutton
            ,obj.addbutton
            ,obj.labelNote
       ]
	});
obj.keypanel2 = new Ext.Panel({
		id : 'keypanel2'
		,buttonAlign : 'center'
		,columnWidth : .12
		,style:'margin-left:20px'
		,layout : 'form'
        ,items:[
        obj.updatebutton
            ,obj.deletebutton
       ]
	});
	obj.conditionPanel = new Ext.form.FormPanel({
		id : 'conditionPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		,layout : 'column'
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.btn1
			,obj.keypanel2
		]
	});


	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 140
		,title : '重症项目汇总'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,iconCls : 'icon-manage'
		,items:[
			obj.conditionPanel
			//,obj.keypanel
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
			idProperty: 'tIcucioiId'
		}, 
	    [
			{name: 'tIcucioiId', mapping: 'tIcucioiId'}
			,{name: 'tIcucioiCode', mapping: 'tIcucioiCode'}
			,{name: 'tIcucioiDesc', mapping: 'tIcucioiDesc'}
			,{name: 'tIcucioiTypeDesc', mapping: 'tIcucioiTypeDesc'}
			,{name: 'tAncoDesc', mapping: 'tAncoDesc'}
			,{name: 'tAncvcDesc', mapping: 'tAncvcDesc'}
			,{name: 'tPhcinDesc', mapping: 'tPhcinDesc'}
			,{name: 'tIcucioiActiveDesc', mapping: 'tIcucioiActiveDesc'}
			,{name: 'tCtlocDesc', mapping: 'tCtlocDesc'}
			,{name: 'tIcucioiType', mapping: 'tIcucioiType'}
			,{name: 'tAncoId', mapping: 'tAncoId'}
			,{name: 'tAncvcId', mapping: 'tAncvcId'}
			,{name: 'tPhcinId', mapping: 'tPhcinId'}
			,{name: 'tIcucioiActive', mapping: 'tIcucioiActive'}
			,{name: 'tCtlocId', mapping: 'tCtlocId'}
			,{name: 'tIcucioiDrCode', mapping: 'tIcucioiDrCode'}
			,{name: 'tIcucioiDrDesc', mapping: 'tIcucioiDrDesc'}
			,{name: 'tIcucioiDr', mapping: 'tIcucioiDr'}
			,{name: 'tIcucioiStrategyDesc', mapping: 'tIcucioiStrategyDesc'}
			,{name: 'tIcucioiMultiple', mapping: 'tIcucioiMultiple'}
			,{name: 'tIcucioiValueField', mapping: 'tIcucioiValueField'}
//			,{name: 'tAncvcSummaryType', mapping: 'tAncvcSummaryType'}
//			,{name: 'tOptions', mapping: 'tOptions'}
		])
	});
	var selnum=0
    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({
			singleSelect:true
			,listeners:{
				'rowselect': function(){
					selnum=1;
                  },
                  'rowdeselect': function(){
					selnum=0;
                  }
			}
			}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: 'tIcucioiId', width: 50, dataIndex: 'tIcucioiId', sortable: true}
		,{header: '代码', width: 100, dataIndex: 'tIcucioiCode', sortable: true}
		,{header: '常用医嘱', width: 80, dataIndex: 'tAncoDesc', sortable: true}
		,{header: '名称', width: 50, dataIndex: 'tIcucioiDesc', sortable: true}
		,{header: '用法', width: 50, dataIndex: 'tPhcinDesc', sortable: true}
		,{header: '类型', width: 50, dataIndex: 'tIcucioiTypeDesc', sortable: true}
		,{header: '显示分类', width: 100, dataIndex: 'tAncvcDesc', sortable: true}
		,{header: '是否可用', width: 80, dataIndex: 'tIcucioiActiveDesc', sortable: true}
		,{header: '科室', width: 250, dataIndex: 'tCtlocDesc', sortable: true}
		,{header: 'tIcucioiType', width: 50, dataIndex: 'tIcucioiType', sortable: true}
		,{header: 'tAncvcId', width: 50, dataIndex: 'tAncvcId', sortable: true}
		,{header: 'tPhcinId', width: 50, dataIndex: 'tPhcinId', sortable: true}
		,{header: 'tAncoId', width: 50, dataIndex: 'tAncoId', sortable: true}
		,{header: 'tIcucioiActive', width: 50, dataIndex: 'tIcucioiActive', sortable: true}
		,{header: 'tCtlocId', width: 50, dataIndex: 'tCtlocId', sortable: true}
		,{header: '主项代码', width: 50, dataIndex: 'tIcucioiDrCode', sortable: true}
		,{header: '主项名称', width: 50, dataIndex: 'tIcucioiDrDesc', sortable: true}
		,{header: '主项RowId', width: 50, dataIndex: 'tIcucioiDr', sortable: true}
		,{header: '策略', width: 50, dataIndex: 'tIcucioiStrategyDesc', sortable: true}
		,{header: '倍数', width: 50, dataIndex: 'tIcucioiMultiple', sortable: true}
		,{header: '对应字段', width: 50, dataIndex: 'tIcucioiValueField', sortable: true}
//		,{header: '小结类型', width: 100, dataIndex: 'tAncvcSummaryType', sortable: true}
//		,{header: '选项', width: 100, dataIndex: 'tOptions', sortable: true}
		]
//		,viewConfig:
//		{
//			forceFit: false
//		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 50,
			store : obj.retGridPanelStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		    ,listeners:{
			    'change':function(){
				    if(selnum)
				    {
					    selnum=0;
					    obj.retGridPanel.getSelectionModel().clearSelections();
					    obj.retGridPanelStore.removeAll();
					    obj.retGridPanelStore.reload({
						    params : {
								start:0
								,limit:50
								}});
					    return;
				    }
			    }
		    }
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
		,title : '重症项目汇总结果'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,iconCls : 'icon-result'
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
	

	obj.itemtypestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCCLCom';
		param.QueryName = 'LookUpComCode';
		param.Arg1 = 'InputOutput';
		param.ArgCnt = 1;
	});
	obj.itemtypestore.load({});
	
	/*obj.itemviewcatstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCRecordItem';
		param.QueryName = 'FindICUCRIViewCat';
		param.Arg1='Y';
		param.ArgCnt = 1;
	});
	*/
	//obj.itemviewcatstore.load({});
	
	obj.itemctlocstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocList';
		param.Arg1='';
		param.Arg2='ICU';
		param.ArgCnt = 2;
	});
	obj.itemctlocstore.load({});
	
	obj.itemcomorderstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUPara';
		param.QueryName = 'FindANCComOrd';
		param.Arg1="";
		param.Arg2=obj.itemcomorder.getRawValue();
		param.Arg3='Y';
		param.ArgCnt = 3;
	});
	obj.itemcomorderstore.load({});

	
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCIOItem';
		param.QueryName = 'FindICUCIOItem';
		
		param.Arg1 = obj.itemname.getValue();
		param.Arg2 = obj.itemctloc.getValue();
		param.Arg3 = "";
		param.Arg4 = obj.itemcode.getValue();
		param.Arg5 =obj.itemynuse.getValue();
		param.ArgCnt = 5;
	});
	obj.retGridPanelStore.load({
	    params : {
				start:0
				,limit:50
			}
	});
	
	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
    obj.findbutton.on("click", obj.findbutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}