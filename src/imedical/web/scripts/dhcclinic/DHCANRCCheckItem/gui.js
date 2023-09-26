function InitViewScreen()
{
    var obj = new Object();
	obj.AnrcmcDr=""
	obj.Code= new Ext.form.TextField({
		id : 'Code'
		,fieldLabel : '代码'
		,anchor : '95%'
	});
	var comboData=[
		['T','基础处理']
		,['L','检验']
		,['E','检查']
		,['C','会诊']
		,['R','特殊危险因素']
		];
	var comboproxy = new Ext.data.MemoryProxy(comboData);
	var columnName = new Ext.data.Record.create([
		{ name: "tCode", type: "string" },
		{ name: "tDesc", type: "string" }
		]);
	var reader = new Ext.data.ArrayReader({}, columnName);
	var combostore = new Ext.data.Store({
		proxy: comboproxy,
        reader: reader,
		autoLoad: true
		});

	combostore.load();	
	obj.Type = new Ext.form.ComboBox({
		id : 'Type'
		,store :combostore		
		,minChars : 1
		,displayField : 'tDesc'
		,fieldLabel : '类型'
		,valueField : 'tCode'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.RowNumber= new Ext.form.TextField({
		id : 'RowNumber'
		,fieldLabel : '行号|行高|列号|列高'
		,anchor : '95%'
	});	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.Code
			,obj.Type
			,obj.RowNumber
		]
	});	
	obj.Desc= new Ext.form.TextField({
		id : 'Desc'
		,fieldLabel : '描述'
		,anchor : '95%'
	});
	obj.TestCode=new Ext.form.TextField({
		id : 'TestCode'
		,fieldLabel : '检验代码'
		,anchor : '95%'
	});
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.Desc
			,obj.TestCode
		]
	});	
	obj.DefAnrcmcDrStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
    obj.DefAnrcmcDrStore=new Ext.data.Store({
		proxy:obj.DefAnrcmcDrStoreProxy,
		reader:new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
		[
			{name: 'AnrcmcId', mapping: 'RowId'},
			{name: 'AnrcmcCode', mapping: 'Code'},
			{name: 'AnrcmcDesc', mapping: 'Desc'}
			//,{name: 'CtlocId', mapping: 'CtlocDr'},
			//{name: 'CtlocDesc', mapping: 'Ctloc'}

		])
	});
	obj.DefAnrcmcDr=new Ext.form.MultiSelect({
		id:'DefAnrcmcDr',
	    fieldLabel:'风险管理级别',
		valueField:'AnrcmcId',
	    displayField:'AnrcmcDesc',
	    store:obj.DefAnrcmcDrStore,
	    minChars:1,
	    triggerAction:'all',
	    anchor:'95%',
		//width: 200,
		editable: false,
		mode: 'local',
		allowBlank: false,
		emptyText: '请选择',
		maxHeight:200, //下拉框的最大高度
		listeners:{
		    "select":function(combo,record,index)
		    	{
					obj.DefAnrcmcDr.setValue(record.data.AnrcmcId);
					obj.AnrcmcDr=record.data.AnrcmcId;							    	
	    		}
	    }
	});
	obj.ExamCode= new Ext.form.TextField({
		id : 'ExamCode'
		,fieldLabel : '检查代码'
		,anchor : '95%'
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.DefAnrcmcDr
			,obj.ExamCode
		]
	});
	obj.ClcmsDrStoreProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ClcmsDrStore=new Ext.data.Store({
		proxy:obj.ClcmsDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'clcmsRowId'
		}, 
		[
			{name: 'clcmsRowId', mapping: 'clcmsRowId'},
			{name: 'clcmsDesc', mapping: 'clcmsDesc'},
			{name: 'clcmsCode', mapping: 'clcmsCode'}
		])
	});
	obj.ClcmsDr=new Ext.form.ComboBox({
	    id : 'ClcmsDr'
		,store : obj.ClcmsDrStore
		,minChars : 1
		,displayField : 'clcmsDesc'
		,fieldLabel : '医疗专业表'
		,valueField : 'clcmsRowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.ConsultationCode= new Ext.form.TextField({
		id : 'ConsultationCode'
		,fieldLabel : '会诊代码'
		,anchor : '95%'
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ClcmsDr
			,obj.ConsultationCode
		]
	});	
	var comboTypeData=[
		['Checked','名称勾选']
		,['Result','是否正常']
		,['Note','描述']
		,['Sample','勾选无文字']
		];
	var comboTypeproxy = new Ext.data.MemoryProxy(comboTypeData);
	var columnTypeName = new Ext.data.Record.create([
		{ name: "DisplayRowId", type: "string" },
		{ name: "DisplayRowDesc", type: "string" }
		]);
	var reader = new Ext.data.ArrayReader({}, columnTypeName);
	var comboTypestore = new Ext.data.Store({
		proxy: comboTypeproxy,
        reader: reader,
		autoLoad: true
		});
	comboTypestore.load();	
	obj.DisplayType=new Ext.form.MultiSelect({
		id:'DisplayType',
	    fieldLabel:'控件风格',
		valueField:'DisplayRowId',
	    displayField:'DisplayRowDesc',
	    store:comboTypestore,
	    minChars:1,
	    triggerAction:'all',
	    anchor:'95%',
		//width: 200,
		editable: false,
		mode: 'local',
		allowBlank: false,
		emptyText: '请选择',
		maxHeight:200 //下拉框的最大高度
	});
	var DisIfData=[
		['Y','是']
		,['N','否']
		];
	var DisIfproxy = new Ext.data.MemoryProxy(DisIfData);
	var columnDisIfName = new Ext.data.Record.create([
		{ name: "DisIfRowId", type: "string" },
		{ name: "DisIfRowDesc", type: "string" }
		]);
	var reader = new Ext.data.ArrayReader({}, columnDisIfName);
	var DisIfstore = new Ext.data.Store({
		proxy: DisIfproxy,
        reader: reader,
		autoLoad: true
		});
	DisIfstore.load();
	obj.DisIf = new Ext.form.ComboBox({
		id : 'DisIf'
		,store :DisIfstore		
		,minChars : 1
		,displayField : 'DisIfRowDesc'
		,fieldLabel : '是否显示'
		,valueField : 'DisIfRowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});	
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.DisplayType
		    ,obj.DisIf 		
		]
	});	
	obj.RowId=new Ext.form.TextField({
		id : 'RowId'
		,hidden:true
	});
	
	obj.formPanel = new Ext.form.FormPanel({
		id : 'formPanel'
		,height:100
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'north'
		,layout : 'column'
		,frame:true
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.RowId
			,obj.Panel5
		]
	});
	
	/*obj.selectbutton = new Ext.Button({
		id : 'selectbutton'
		,width:60
		,text : '查询'
	});
	obj.selectPanel = new Ext.Panel({
		id : 'selectPanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'column'
		,buttons:[
			obj.selectbutton
		]
	});*/
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,width:60
		,text : '添加'
	});
	obj.addPanel = new Ext.Panel({
		id : 'addPanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'column'
		,buttons:[
			obj.addbutton
		]
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,width:60
		,text : '修改'
	});
	obj.updatePanel = new Ext.Panel({
		id : 'updatePanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'column'
		,buttons:[
			obj.updatebutton
		]
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,width:60
		,text : '删除'
	});
	obj.deletePanel = new Ext.Panel({
		id : 'deletePanel'
		,buttonAlign : 'right'
		,columnWidth : .2
		,layout : 'column'
		,buttons:[
			obj.deletebutton
		]
	});
	obj.buttonPanel=new Ext.form.FormPanel({
		id:'buttonPanel'
		,buttonAlign:'center'
		,region:'center'
		,lableWidth:80
		,layout:'column'
		,height:80
		,buttons:[
	        //obj.selectPanel,
		    obj.updatePanel,
		    obj.addPanel,
		    obj.deletePanel
		
		]});
	obj.ParentPanel=new Ext.Panel({
		id:'ParentPanel'
		,height:200
		,title:'风险核查项维护'
		,region:'north'
		,layout:'border'
		,frame : true
		,collapsible:true //折叠选项框
		,animate:true
		,items:[
		    obj.formPanel
		    ,obj.buttonPanel
		]
		});
	
	
	obj.storeProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	
   	obj.store=new Ext.data.Store({
	   	proxy: obj.storeProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
	    [
			{name: 'RowId', mapping : 'RowId'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'DefAnrcmcDr', mapping: 'DefAnrcmcDr'}
			,{name: 'DefAnrcmcDesc', mapping: 'DefAnrcmcDesc'}
			,{name: 'ClcmsDr', mapping: 'ClcmsDr'}
			,{name: 'ClcmsDesc', mapping: 'ClcmsDesc'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'TestCode', mapping: 'TestCode'}
			,{name: 'ExamCode', mapping: 'ExamCode'}
			,{name: 'ConsultationCode', mapping: 'ConsultationCode'}
			,{name: 'DisProject', mapping: 'DisProject'}
			,{name: 'DisDecide', mapping: 'DisDecide'}
			,{name: 'DisRowColNum', mapping: 'DisRowColNum'}
		])
		});

	obj.storeProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCCheckItem';
		param.QueryName = 'FindANRCCheckItem';
		param.Arg1=obj.Desc.getRawValue();
		param.ArgCnt=1;		
	});
		obj.store.load({});

	var cm=new Ext.grid.ColumnModel({
	   	defaultSortable:true
	   	,columns:[
	   	new Ext.grid.RowNumberer()
	   	,{
		   	header:'RowID'
		   	,width:100
		   	,dataIndex:'RowId'
		   	,sortable:true
		   	}
	   	,{
		   	header:'代码'
		   	,width:100
		   	,dataIndex:'Code'
		   	,sortable:true
		   	}
	   	,{
		   	header:'描述'
		   	,width:100
		   	,dataIndex:'Desc'
		   	,sortable:true
		   	}
	   	,{
		   	header:'DefAnrcmcDr'
		   	,width:100
		   	,dataIndex:'DefAnrcmcDr'
		   	,sortable:true
		   	}
		,{
			header:'风险管理级别'
		   	,width:100
		   	,dataIndex:'DefAnrcmcDesc'
		   	,sortable:true
		   	}
	   	,{
		   	header:'ClcmsDr'
		   	,width:100
		   	,dataIndex:'ClcmsDr'
		   	,sortable:true
		   	}
	   	,{
		   	header:'医疗专业表'
		   	,width:100
		   	,dataIndex:'ClcmsDesc'
		   	,sortable:true
		   	}
	   	,{
		   	header:'类型'
		   	,width:100
		   	,dataIndex:'Type'
		   	,sortable:true
		   	}
	   	,{
		   	header:'检验代码'
		   	,width:100
		   	,dataIndex:'TestCode'
		   	,sortable:true
		   	} 
		,{
		   	header:'检查代码'
		   	,width:100
		   	,dataIndex:'ExamCode'
		   	,sortable:true
		   	}
	   	,{
		   	header:'会诊代码'
		   	,width:100
		   	,dataIndex:'ConsultationCode'
		   	,sortable:true
		   	}
		]
		   	});	
	obj.retGridPanel=new Ext.grid.GridPanel({
		id:'retGridPanel'
		,store:obj.store
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:cm
		,bbar:new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.store,
		    displayMsg: '显示记录： {0} - {1} 共有{2}条记录',
			displayInfo: true,
		    emptyMsg: '没有记录'
			})
		});
	obj.ResultPanel=new Ext.Panel({
		id:'ResultPanel'
		,buttonAlign : 'center'
		,title:'风险核查项查询结果'
		,region:'center'
		,layout:'border'
		,frame : true
		,items:[
		    obj.retGridPanel
		]
		});
	obj.ViewScreen=new Ext.Viewport({
		id:'ViewScreen'
		,layout:'border'
		,items:[
		    obj.ParentPanel
		    ,obj.ResultPanel
		]});
		
	obj.DefAnrcmcDrStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCManageClass';
		param.QueryName = 'FindANRCManageClass';
		param.ArgCnt=0;
	});
	obj.DefAnrcmcDrStore.load({});
	obj.ClcmsDrStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANRCCheckItem';
		param.QueryName = 'FindMedicalSpecialty';
		param.ArgCnt = 0;
	});
	obj.ClcmsDrStore.load({});
	InitViewScreenEvent(obj);
	
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);

	obj.LoadEvent(arguments);
	return obj;
}