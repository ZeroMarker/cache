//20180412 同步体温单配置
function InitViewScreen(){
	var obj = new Object();
	
	//RowId
	obj.RowId = new Ext.form.TextField({
		id : 'RowId'
		,hidden : true
    });
    
    //常用医嘱
    function selcomord(v, record) { 
         return record.Desc+" || "+record.ID; 
    }
    obj.RecordItemstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.RecordItemstore = new Ext.data.Store({
		proxy: obj.RecordItemstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		}, 
		[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Desc', mapping: 'Desc'}
		    ,{ name: 'selecttext', convert: selcomord}
		])
	});
	obj.RecordItem = new Ext.form.ComboBox({
		id : 'RecordItem'
		,store:obj.RecordItemstore
		,minChars:1
		,displayField:'selecttext'
		,fieldLabel : '常用医嘱'
		,valueField : 'Code'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	});
	
	//观察项
	obj.ObserveItemstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ObserveItemstore = new Ext.data.Store({
		proxy: obj.ObserveItemstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
		[
			{name: 'RowId', mapping: 'RowId'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.ObserveItem = new Ext.form.ComboBox({
		id : 'ObserveItem'
		,store:obj.ObserveItemstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '观察项'
		,valueField : 'RowId'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	});
	
	//时间点个数
	obj.DayFactor=new Ext.form.TextField({
		id : 'DayFactor'
		,fieldLabel : '时间点个数'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
	//开始时间
	obj.StartTime=new Ext.form.TimeField({
	    id : 'StartTime'
		,format : 'H:i'
		,increment : 5
		,labelSeparator: ''
		,fieldLabel : '开始时间'
		,anchor : '95%'
	});
	
	//时间间隔
	obj.ValidSpan=new Ext.form.TimeField({
	    id : 'ValidSpan'
		,format : 'H:i'
		,increment : 5
		,labelSeparator: ''
		,fieldLabel : '时间间隔'
		,anchor : '95%'
	});
	
	//类型
	var data = [
		['R','监护数据'],
		['A','重症安排']
	]
	obj.TypestoreProxy=data;
	obj.Typestore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'Code'}
			,{name: 'Desc'}
		])
	});
	obj.Type=new Ext.form.ComboBox({
		id : 'Type'
		,store : obj.Typestore
		,minChars : 1
		,fieldLabel : '类型'
		,triggerAction : 'all'
		,displayField : 'Desc'
		,anchor : '95%'
		,valueField : 'Code'
	});
	
	//异常值
	obj.UpperThreshold=new Ext.form.TextField({
		id : 'UpperThreshold'
		,fieldLabel : '异常值'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	//异常处理时间间隔
	obj.Interval=new Ext.form.TextField({
		id : 'Interval'
		,fieldLabel : '异常处理时间间隔'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	//汇总值插入时间
	obj.SummaryInsertTime=new Ext.form.TimeField({
	    id : 'SummaryInsertTime'
		,format : 'H:i'
		,increment : 5
		,labelSeparator: ''
		,fieldLabel : '汇总值插入时间'
		,anchor : '95%'
	});
	
	//科室
	obj.CtlocstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.Ctlocstore = new Ext.data.Store({
		proxy: obj.CtlocstoreProxy,
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
	obj.Ctloc=new Ext.form.ComboBox({
		id : 'Ctloc'
		,store:obj.Ctlocstore
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
	//策略
	obj.Strategy=new Ext.form.TextField({
		id : 'Strategy'
		,fieldLabel : '策略'
		,labelSeparator: ''
		,anchor : '95%'
	});
	//备用常用医嘱
	obj.SpareIcucriCode = new Ext.form.ComboBox({
		id : 'SpareIcucriCode'
		,store:obj.RecordItemstore
		,minChars:1
		,displayField:'selecttext'
		,fieldLabel : '备用常用医嘱'
		,valueField : 'ID'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : true
		,labelSeparator: ''
		,mode: 'local'
	});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 80
		,layout : 'form'
		,items:[
			obj.RecordItem
			,obj.ValidSpan
			,obj.SummaryInsertTime
		]
	});
	
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,labelWidth : 80
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.ObserveItem
			,obj.Type
			,obj.Ctloc
			
		]
	});

	
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,labelWidth : 80
		,columnWidth : .15
		,layout : 'form'
		,items:[
			obj.DayFactor
			,obj.UpperThreshold
			,obj.Strategy
		]
	});


	
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .15
		,labelWidth : 120
		,layout : 'form'
		,items:[
			obj.StartTime
			,obj.Interval
			,obj.SpareIcucriCode
			
		]
	});

	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-add'
		,width:80
		,text : '添加'
		,style:'margin-bottom:5px;'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,iconCls : 'icon-update'
		,width:80
		,text : '修改'
		,style:'margin-bottom:5px;'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,iconCls : 'icon-delete'
		,width:80
		,text : '删除'
	});
	
	obj.keypanel2 = new Ext.Panel({
		id : 'keypanel2'
		,buttonAlign : 'center'
		,columnWidth : .12
		,columnHeight:30
		,style:'margin-left:20px'
		,layout : 'form'
        ,items:[
        	obj.addbutton
        	,obj.updatebutton
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
			,obj.keypanel2
		]
	});


	obj.functionPanel = new Ext.Panel({
		id : 'functionPanel'
		,buttonAlign : 'center'
		,height : 140
		,title : '体温单同步项目配置'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,collapsible:true
		,animate:true
		,iconCls : 'icon-manage'
		,items:[
			obj.conditionPanel
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
			idProperty: 'RowId'
		}, 
	    [
			{name: 'RowId', mapping: 'RowId'}
			,{name: 'RecordItemId', mapping: 'RecordItemId'}
			,{name: 'ObserveItemId', mapping: 'ObserveItemId'}
			,{name: 'ObserveItem', mapping: 'ObserveItem'}
			,{name: 'DayFactor', mapping: 'DayFactor'}
			,{name: 'StartTime', mapping: 'StartTime'}
			,{name: 'ValidSpan', mapping: 'ValidSpan'}
			,{name: 'Type', mapping: 'Type'}
			,{name: 'UpperThreshold', mapping: 'UpperThreshold'}
			,{name: 'Interval', mapping: 'Interval'}
			,{name: 'SummaryInsertTime', mapping: 'SummaryInsertTime'}
			,{name: 'CtlocId', mapping: 'CtlocId'}
			,{name: 'Strategy', mapping: 'Strategy'}
			,{name: 'SpareIcucriCode', mapping: 'SpareIcucriCode'}
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
		,columns: [
			new Ext.grid.RowNumberer(),
			{ dataIndex: "RowId", header: "ID", width: 60, sortable: true },
            { dataIndex: "RecordItemId", header: "常用医嘱代码", width: 120, sortable: true },
           	{ dataIndex: "ObserveItemId", header: "观察项Id", width: 60, sortable: true },
           	{ dataIndex: "ObserveItem", header: "观察项", width: 100, sortable: true },
           	{ dataIndex: "DayFactor", header: "时间点个数", width: 60, sortable: true},
           	{ dataIndex: "StartTime", header: "开始时间", width: 100, sortable: true },
           	{ dataIndex: "ValidSpan", header: "时间间隔", width: 100, sortable: true },
           	{ dataIndex: "Type", header: "类型", width: 100, sortable: true, formatter:function(value,index,row){
	           	if (value==='R') return '监护数据';
	           	if (value==='A') return '重症安排';
	           	return '';
	           	}
            },
          	{ dataIndex: "UpperThreshold", header: "异常值", width: 60, sortable: true },
           	{ dataIndex: "Interval", header: "异常处理时间间隔", width: 100, sortable: true },
           	{ dataIndex: "SummaryInsertTime", header: "汇总插入时间", width: 100, sortable: true },
           	{ dataIndex: "CtlocId", header: "科室ID", width: 100, sortable: true },
           	{ dataIndex: "Strategy", header: "策略", width: 100, sortable: true },
           	{ dataIndex: "SpareIcucriCode", header: "备用常用医嘱代码", width: 100, sortable: true }
		]
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
		,title : '体温单同步项目配置结果'
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
	
	obj.RecordItemstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUPara';
		param.QueryName = 'FindANCComOrd';
		param.Arg1='';
		param.Arg2=obj.RecordItem.getValue();
		param.Arg3='Y';
		param.ArgCnt = 3;
	});
	obj.RecordItemstore.load({});

	obj.ObserveItemstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCTemperature';
		param.QueryName = 'FindObserveItem';
		param.ArgCnt = 0;
	});
	obj.ObserveItemstore.load({});
	
	obj.CtlocstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocList';
		param.Arg1='';
		param.Arg2='ICU';
		param.ArgCnt = 2;
	});
	obj.Ctlocstore.load({});
	
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCTemperature';
		param.QueryName = 'FindICUCTemper';
		param.ArgCnt = 0;
	});
	obj.retGridPanelStore.load({});

	InitViewScreenEvent(obj);
	
	//事件处理代码
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	
	obj.addbutton.on("click", obj.addbutton_click, obj);
	obj.updatebutton.on("click", obj.updatebutton_click, obj);
	obj.deletebutton.on("click", obj.deletebutton_click, obj);
	obj.LoadEvent(arguments);
	return obj;
}