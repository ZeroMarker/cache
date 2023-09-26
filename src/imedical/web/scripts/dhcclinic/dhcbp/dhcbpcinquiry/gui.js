//update by GY 20170307
function InitViewScreen(){
	var obj = new Object();
	
	obj.BPCICode = new Ext.form.TextField({
		id : 'BPCICode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.BPCISearchLevel = new Ext.form.TextField({
		id : 'BPCISearchLevel'
		,fieldLabel : '搜索级别'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .12
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.BPCICode
			,obj.BPCISearchLevel
		]
	});	
	
	obj.BPCIDesc = new Ext.form.TextField({
		id : 'BPCIDesc'
		,fieldLabel : '描述'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	
	obj.BPCIBPaCount = new Ext.form.TextField({
		id : 'BPCIBPaCount'
		,fieldLabel : '统计'
		,labelSeparator: ''
		,anchor : '95%'
	}); 


	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
    });	
    
	obj.Panel2 = new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .12
		,layout : 'form'
		,items:[
			obj.BPCIDesc
			,obj.BPCIBPaCount
			,obj.Rowid
		]
	});
	
	obj.BPCICtlocDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.BPCICtlocDrstore = new Ext.data.Store({
		proxy: obj.BPCICtlocDrstoreProxy,
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
	obj.BPCICtlocDr = new Ext.form.ComboBox({
		id : 'BPCICtlocDr'
		,store:obj.BPCICtlocDrstore
		,minChars:1
		,displayField:'oprCtLoc'
		,fieldLabel : '科室'
		,valueField : 'oprLocId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.BPCIResultCount = new Ext.form.TextField({
		id : 'BPCIResultCount'
		,fieldLabel : '结果统计'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	
	
		
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.BPCICtlocDr
			,obj.BPCIResultCount
		]
	});
	
	obj.BPCIType = new Ext.form.TextField({
		id : 'BPCIType'
		,fieldLabel : '类型'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.BPCIUpdateUserDr = new Ext.form.TextField({
		id : 'BPCIUpdateUserDr'
		,fieldLabel : '更新用户'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.BPCIUpdateDate = new Ext.form.TextField({
		id : 'BPCIUpdateDate'
		,fieldLabel : '更新日期'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.BPCIUpdateTime = new Ext.form.TextField({
		id : 'BPCIUpdateTime'
		,fieldLabel : '更新时间'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.BPCIDataType = new Ext.form.TextField({
		id : 'BPCIDataType'
		,fieldLabel : '统计类型'
		,labelSeparator: ''
		,anchor : '95%'
	}); 
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .12
		,layout : 'form'
		,labelWidth : 60
		,items:[
			obj.BPCIType
			,obj.BPCIDataType

		]
	});
	
	
	obj.BPCIStatusstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.BPCIStatusstore = new Ext.data.Store({
		proxy: obj.BPCIStatusstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'StatusCode'
		}, 
		[
			{name: 'StatusCode', mapping: 'StatusCode'}
			,{name: 'StatusDesc', mapping : 'StatusDesc'}
			
		])
	});
	obj.BPCIStatus = new Ext.form.ComboBox({
		id : 'BPCIStatus'
		,store:obj.BPCIStatusstore
		,minChars:1
		,displayField:'StatusDesc'
		,fieldLabel : '状态'
		,valueField : 'StatusCode'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,iconCls : 'icon-add'
		,width:86
		,style: 'margin-left:5px'
		,text : '增加'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,iconCls : 'icon-delete'
		,style: 'margin-left:5px'
		,width:86
		,text : '删除'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,iconCls : 'icon-updateSmall'
		,style: 'margin-left:5px;margin-Top:5px'
		,width:86
		,text : '更新'
	});	
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .12
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.BPCIStatus
			,obj.BPCIUpdateDate
		]
	});
	obj.Panel6 = new Ext.Panel({
		id : 'Panel6'
		,buttonAlign : 'center'
		,columnWidth : .12
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.BPCIUpdateTime
			,obj.BPCIUpdateUserDr
		]
	});
	obj.Panel7 = new Ext.Panel({
		id : 'Panel7'
		,buttonAlign : 'left'
		,columnWidth : .09
		,layout : 'form'
		,items:[			
			obj.addbutton
			,obj.updatebutton
       ]
	});	
	obj.Panel8 = new Ext.Panel({
		id : 'Panel8'
		,buttonAlign : 'left'
		,columnWidth : .09
		,layout : 'form'
		,items:[
            obj.deletebutton
       ]
	});	

	obj.inquirypanel = new Ext.form.FormPanel({
		id : 'inquirypanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 40
		,region : 'north'
		,height : 70
		,layout : 'column'
		,frame : true
		,items:[
			obj.Panel1
			,obj.Panel2
			,obj.Panel3
			,obj.Panel4
			,obj.Panel5
			,obj.Panel6
			,obj.Panel7
			,obj.Panel8
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
			{name: 'TRowid', mapping : 'TRowid'}
			,{name: 'TBPCICode', mapping : 'TBPCICode'}
			,{name: 'TBPCIDesc', mapping : 'TBPCIDesc'}
			,{name: 'TBPCICtlocDr', mapping : 'TBPCICtlocDr'}
			,{name: 'TBPCICtloc', mapping : 'TBPCICtloc'}
			,{name: 'TBPCIStatusCode', mapping: 'TBPCIStatusCode'}
			,{name: 'TBPCIStatus', mapping: 'TBPCIStatus'}
			,{name: 'TBPCISearchLevel', mapping: 'TBPCISearchLevel'}
			,{name: 'TBPCIBpaCount', mapping: 'TBPCIBpaCount'}
			,{name: 'TBPCIResultCount', mapping: 'TBPCIResultCount'}
			,{name: 'TBPCIType', mapping: 'TBPCIType'}
			,{name: 'TBPCIUpdateUserDr', mapping: 'TBPCIUpdateUserDr'}
			,{name: 'TBPCIUpdateDate', mapping: 'TBPCIUpdateDate'}
			,{name: 'TBPCIDataType', mapping: 'TBPCIDataType'}
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
		,{header: '代码', width: 150, dataIndex: 'TBPCICode', sortable: true}
		,{header: '描述', width: 150, dataIndex: 'TBPCIDesc', sortable: true}
		,{header: '科室', width: 200, dataIndex: 'TBPCICtloc', sortable: true}
		,{header: '状态', width: 150, dataIndex: 'TBPCIStatus', sortable: true}
		,{header: '搜索级别', width: 150, dataIndex: 'TBPCISearchLevel', sortable: true}
		,{header: '统计', width:150, dataIndex: 'TBPCIBpaCount', sortable: true}
		,{header: '结果统计', width: 150, dataIndex: 'TBPCIResultCount', sortable: true}
		// Add by DTJ 2014-03-12
		,{header: '类型', width: 150, dataIndex: 'TBPCIType', sortable: true}
		,{header: '用户', width: 150, dataIndex: 'TBPCIUpdateUserDr', sortable: true}
		,{header: '更新日期', width: 150, dataIndex: 'TBPCIUpdateDate', sortable: true}
		,{header: '统计类型', width: 150, dataIndex: 'TBPCIDataType', sortable: true}

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
	obj.BPCICtlocDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCInquiry';
		param.QueryName = 'ctloclookup';
		param.Arg1=obj.BPCICtlocDr.getRawValue();
		param.ArgCnt = 1;
	});
	obj.BPCICtlocDrstore.load({});
	
	obj.BPCIStatusstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCInquiry';
		param.QueryName = 'Statuslookup';
		param.ArgCnt = 0;
	});

	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCInquiry';
		param.QueryName = 'FindBPCInquiry';
		param.Arg1=obj.BPCICtlocDr.getValue();
		param.ArgCnt = 1;
	});
	obj.retGridPanelStore.load({});
	
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
	obj.inquiryresult = new Ext.Panel({
		id : 'inquiryresult'
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
	obj.findinquiry = new Ext.Panel({
		id : 'findinquiry'
		,buttonAlign : 'center'
		,height : 300
		,title : '血液净化查询'
		,region : 'north'
		,layout : 'border'
		,iconCls : 'icon-manage'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.inquirypanel
			,obj.inquiryresult
		]
	});
	
//////////////////////////////////////////////////////	
	/*obj.BPCIICode = new Ext.form.TextField({
		id : 'BPCIICode'
		,fieldLabel : '代码'
		,anchor : '95%'
	});	*/
    obj.BPCRIMainBPCRIDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.BPCRIMainBPCRIDrStore = new Ext.data.Store({
      	proxy: obj.BPCRIMainBPCRIDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'RowId'   
      		}, 
      		[	//ancodesc,ancoCode,rowid
      			{name: 'RowId', mapping: 'tRowId'}
      			,{name: 'BPCRICode', mapping: 'tBPCRICode'}
      			,{name: 'BPCRIDesc', mapping: 'tBPCRIDesc'}
      		])
      	});		
  obj.BPCIICode =new Ext.form.ComboBox({
      	id : 'obj.BPCIICode'
      	,store : obj.BPCRIMainBPCRIDrStore
      	,minChars : 0
      	,displayField : 'BPCRICode'
      	,fieldLabel : '代码'
      	,valueField : 'RowId'
      	,editable : true
      	,triggerAction : 'all'
      	,labelSeparator: ''
      	,anchor : '95%'
              });	
    obj.BPCRIMainBPCRIDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCBPCRecordItem';
      	param.QueryName = 'FindBPCReItem';
      	param.Arg1=obj.BPCIICode.getRawValue(); 
      	param.Arg2="";    
      	param.ArgCnt = 2;
      	});
      	//obj.BPCRIMainBPCRIDrStore.load();     	
      	
	obj.BPCIIDataField = new Ext.form.TextField({
		id : 'BPCIIDataField'
		,fieldLabel : '字段'
		,labelSeparator: ''
		,anchor : '95%'
	});	

	obj.BPCIIMultiple = new Ext.form.TextField({
		id : 'BPCIIMultiple'
		,fieldLabel : '多选值'
		,labelSeparator: ''
		,anchor : '95%'
	});	

/*	obj.BPCIIToTime = new Ext.form.TextField({
		id : 'BPCIIToTime'
		,fieldLabel : '终止时间'
		,anchor : '95%'
	});	*/
	obj.BPCIIToTime = new Ext.form.TimeField({
	    id : 'BPCIIToTime'
		,format : 'H:i'
		//,increment : 30
		,fieldLabel : '终止时间'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.BPCIILevel = new Ext.form.TextField({
		id : 'BPCIILevel'
		,fieldLabel : '筛选层'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	obj.BPCIIRowid = new Ext.form.TextField({
		id : 'BPCIIRowid'
		,hidden : true
    });				
   	obj.itempanel1 = new Ext.Panel({
		id : 'itempanel1'
		,buttonAlign : 'center'
		,columnWidth : .18
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.BPCIICode
			,obj.BPCIIDataField
			,obj.BPCIIMultiple
			,obj.BPCIIToTime
			,obj.BPCIILevel
			,obj.BPCIIRowid
		]
	});
		
	obj.BPCIIDesc = new Ext.form.TextField({
		id : 'BPCIIDesc'
		,fieldLabel : '描述'
		,labelSeparator: ''
		,anchor : '95%'
	});			
		
/*	obj.BPCIIIsSingle = new Ext.form.TextField({
		id : 'BPCIIIsSingle'
		,fieldLabel : '返回单条数据'
		,anchor : '95%'
	});	*/
	obj.BPCIIIsSinglestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.BPCIIIsSinglestore = new Ext.data.Store({
		proxy: obj.BPCIIIsSinglestoreProxy,
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
	
	
	obj.BPCIIIsSingle = new Ext.form.ComboBox({
		id : 'BPCIIIsSingle'
		,store:obj.BPCIIIsSinglestore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '返回单条数据'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.BPCIIIsSinglestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCInquiry';
		param.QueryName = 'FindBoolen';
		param.ArgCnt = 0;
	});
	obj.BPCIIIsSinglestore.load({});
	
	obj.BPCIIStartDateTime = new Ext.form.TextField({
		id : 'BPCIIStartDateTime'
		,fieldLabel : '开始时间'
		,labelSeparator: ''
		,anchor : '95%'
	});	
	
/*	obj.BPCIIExactTime = new Ext.form.TextField({
		id : 'BPCIIExactTime'
		,fieldLabel : '准确时间'
		,anchor : '95%'
	});	*/
	obj.BPCIIExactTime = new Ext.form.TimeField({
	    id : 'BPCIIExactTime'
		,format : 'H:i'
		//,increment : 30
		,fieldLabel : '准确时间'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.additembtn = new Ext.Button({
		id : 'additembtn'
		,iconCls : 'icon-add'
		,width:86
		,text : '增加'
	});	
	obj.itempanel2 = new Ext.Panel({
		id : 'itempanel2'
		,buttonAlign : 'center'
		,columnWidth : .18
		,layout : 'form'
		,labelWidth : 90
		,items:[
			obj.BPCIIDesc
			,obj.BPCIIIsSingle
			,obj.BPCIIStartDateTime
			,obj.BPCIIExactTime
		]
	});
		
/*	obj.BPCIIType = new Ext.form.TextField({
		id : 'BPCIIType'
		,fieldLabel : '类型'
		,anchor : '95%'
	});*/
	obj.BPCIITypestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.BPCIITypestore = new Ext.data.Store({
		proxy: obj.BPCIITypestoreProxy,
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
	obj.BPCIIType = new Ext.form.ComboBox({
		id : 'BPCIIType'
		,store:obj.BPCIITypestore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '类型'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.BPCIITypestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCInquiry';
		param.QueryName = 'FindType';
		param.ArgCnt = 0;
	});
	obj.BPCIITypestore.load({});
	
	obj.BPCIIMinQty = new Ext.form.TextField({
		id : 'BPCIIMinQty'
		,fieldLabel : '最小值'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.BPCIIDurationHour = new Ext.form.TextField({
		id : 'BPCIIDurationHour'
		,fieldLabel : '持续时间'
		,labelSeparator: ''
		,anchor : '95%'
	});
/*	obj.BPCIIRefBPriId = new Ext.form.TextField({
		id : 'BPCIIRefBPriId'
		,fieldLabel : '基准常用医嘱'
		,anchor : '95%'
	});*/

	obj.BPCIIRefBPriIdstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltext(v, record) { 
         return record.tRowId+" || "+record.tICUCRIDesc; 
    } 
	obj.BPCIIRefBPriIdstore = new Ext.data.Store({
		proxy: obj.BPCIIRefBPriIdstoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'tRowId'
		}, 
		[
			{name: 'tRowId', mapping: 'tRowId'}
			//,{name: 'tICUCRICode', mapping: 'tICUCRICode'}
			//,{name: 'tICUCRIDesc', mapping: 'tICUCRIDesc'}
			,{ name: 'selecttexts', convert: seltext}
		])
	});
	obj.BPCIIRefBPriId = new Ext.form.ComboBox({
		id : 'BPCIIRefBPriId'
		,store:obj.BPCIIRefBPriIdstore
		,minChars:1
		//,displayField:'tBPCRIDesc'
		,displayField:'selecttexts'
		,fieldLabel : '基准常用医嘱'
		,valueField : 'tRowId'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.BPCIIRefBPriIdstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCRecordItem';
		param.QueryName = 'FindICUCRecordItem';
		param.Arg1=obj.BPCIIRefBPriId.getRawValue();
		param.Arg2="";
		param.Arg3="";
		param.Arg4="";
		param.Arg5=""
		param.ArgCnt = 5;
	});
	//obj.BPCIIRefBPriIdstore.load({});
	obj.updateitembtn = new Ext.Button({
		id : 'updateitembtn'
		,iconCls : 'icon-updateSmall'
		,width:86
		,style: 'margin-Top:5px'
		,text : '更新'
	});		
	obj.itempanel3 = new Ext.Panel({
		id : 'itempanel3'
		,buttonAlign : 'center'
		,columnWidth : .18
		,layout : 'form'
		,labelWidth : 90
		,items:[
			obj.BPCIIType
			,obj.BPCIIMinQty
			,obj.BPCIIDurationHour
			,obj.BPCIIRefBPriId
		]
	});
/*	obj.BPCIIIsSearch = new Ext.form.TextField({
		id : 'BPCIIIsSearch'
		,fieldLabel : '查找项'
		,anchor : '95%'
	});*/
	obj.BPCIIIsSearchstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.BPCIIIsSearchstore = new Ext.data.Store({
		proxy: obj.BPCIIIsSearchstoreProxy,
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
	
	
	obj.BPCIIIsSearch = new Ext.form.ComboBox({
		id : 'BPCIIIsSearch'
		,store:obj.BPCIIIsSearchstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '查找项'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.BPCIIIsSearchstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCBPCInquiry';
		param.QueryName = 'FindBoolen';
		param.ArgCnt = 0;
	});
	obj.BPCIIIsSearchstore.load({});
	
	obj.BPCIIMaxQty = new Ext.form.TextField({
		id : 'BPCIIMaxQty'
		,fieldLabel : '最大值'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.BPCIIOeoriNote = new Ext.form.TextField({
		id : 'BPCIIOeoriNote'
		,fieldLabel : '医嘱备注'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.BPCIIRefValue = new Ext.form.TextField({
		id : 'BPCIIRefValue'
		,fieldLabel : '基准值'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.deleteitembtn = new Ext.Button({
		id : 'deleteitembtn'
		,iconCls : 'icon-delete'
		,width:86
		,style: 'margin-Top:5px'
		,text : '删除'
	});			
	obj.itempanel4 = new Ext.Panel({
		id : 'itempanel4'
		,buttonAlign : 'center'
		,columnWidth : .18
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.BPCIIIsSearch
			,obj.BPCIIMaxQty
			,obj.BPCIIOeoriNote
			,obj.BPCIIRefValue
		]
	});
	
/*	obj.BPCIIIsDisplay = new Ext.form.TextField({
		id : 'BPCIIIsDisplay'
		,fieldLabel : '显示项'
		,anchor : '95%'
	});*/
	obj.BPCIIIsDisplaystoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.BPCIIIsDisplaystore = new Ext.data.Store({
		proxy: obj.BPCIIIsDisplaystoreProxy,
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
	
	
	obj.BPCIIIsDisplay = new Ext.form.ComboBox({
		id : 'BPCIIIsDisplay'
		,store:obj.BPCIIIsDisplaystore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '显示项'
		,valueField : 'Id'
		,triggerAction : 'all'
		,labelSeparator: ''
		,anchor : '95%'
	});
	
	obj.BPCIIIsDisplaystoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCInquiry';
		param.QueryName = 'FindBoolen';
		param.ArgCnt = 0;
	});
	obj.BPCIIIsDisplaystore.load({});
	
	obj.BPCIINote = new Ext.form.TextField({
		id : 'BPCIINote'
		,fieldLabel : '说明'
		,labelSeparator: ''
		,anchor : '95%'
	});

/*	obj.BPCIIFromTime = new Ext.form.TextField({
		id : 'BPCIIFromTime'
		,fieldLabel : '起始时间'
		,anchor : '95%'
	});*/
	obj.BPCIIFromTime = new Ext.form.TimeField({
	    id : 'BPCIIFromTime'
		,format : 'H:i'
		//,increment : 30
		,fieldLabel : '起始时间'
		,labelSeparator: ''
		,anchor : '95%'
	});
	obj.BPCIISeqNo = new Ext.form.TextField({
		id : 'BPCIISeqNo'
		,fieldLabel : '排序号'
		,labelSeparator: ''
		,anchor : '95%'
	});		
	obj.itempanel5 = new Ext.Panel({
		id : 'itempanel5'
		,buttonAlign : 'center'
		,columnWidth : .18
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.BPCIIIsDisplay
			,obj.BPCIINote
			,obj.BPCIIFromTime
			,obj.BPCIISeqNo
		]
	});
	obj.itempanel6 = new Ext.Panel({
		id : 'itempanel6'
		,buttonAlign : 'right'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			obj.additembtn
			,obj.updateitembtn
			,obj.deleteitembtn
		]
	});
	obj.inquiryitempanel = new Ext.form.FormPanel({
		id : 'inquiryitempanel'
		,buttonAlign : 'left'
		,labelAlign : 'right'
		,region : 'north'
		,height : 140
		,layout : 'column'
		,frame : true
		,items:[
			obj.itempanel1
			,obj.itempanel2
			,obj.itempanel3	
			,obj.itempanel4	
			,obj.itempanel5	
			,obj.itempanel6	
		]
	});
	obj.retGridPanelitemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.retGridPanelitemStore = new Ext.data.Store({
		proxy: obj.retGridPanelitemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'TRowid'
		}, 
	    [
			{name: 'TRowid', mapping : 'TRowid'}
			,{name: 'TBPCIICode', mapping: 'TBPCIICode'}
			,{name: 'TBPCIIDesc', mapping: 'TBPCIIDesc'}
			,{name: 'TBPCIIType', mapping: 'TBPCIIType'}
			,{name: 'TBPCIITypeD', mapping: 'TBPCIITypeD'}
			,{name: 'TBPCIIIsSearch', mapping: 'TBPCIIIsSearch'}
			,{name: 'TBPCIIIsSearchD', mapping: 'TBPCIIIsSearchD'}
			,{name: 'TBPCIIIsDisplay', mapping: 'TBPCIIIsDisplay'}
			,{name: 'TBPCIIIsDisplayD', mapping: 'TBPCIIIsDisplayD'}
			,{name: 'TBPCIIDataField', mapping: 'TBPCIIDataField'}
			,{name: 'TBPCIIIsSingle', mapping: 'TBPCIIIsSingle'}
			,{name: 'TBPCIIIsSingleD', mapping: 'TBPCIIIsSingleD'}
			,{name: 'TBPCIIMinQty', mapping: 'TBPCIIMinQty'}
			,{name: 'TBPCIIMaxQty', mapping: 'TBPCIIMaxQty'}
			,{name: 'TBPCIINote', mapping: 'TBPCIINote'}
			,{name: 'TBPCIIMultiple', mapping: 'TBPCIIMultiple'}
			,{name: 'TBPCIIStartDateTime', mapping: 'TBPCIIStartDateTime'}
			,{name: 'TBPCIIDurationHour', mapping: 'TBPCIIDurationHour'}
			,{name: 'TBPCIIOeoriNote', mapping: 'TBPCIIOeoriNote'}
			,{name: 'TBPCIIFromTime', mapping: 'TBPCIIFromTime'}
			,{name: 'TBPCIIToTime', mapping: 'TBPCIIToTime'}
			,{name: 'TBPCIIExactTime', mapping: 'TBPCIIExactTime'}
			,{name: 'TBPCIIRefIcuriId', mapping: 'TBPCIIRefIcuriId'}
			,{name: 'TBPCIIRefIcuriDesc', mapping: 'TBPCIIRefIcuriDesc'}
			,{name: 'TBPCIIRefValue', mapping: 'TBPCIIRefValue'}
			,{name: 'TBPCIISeqNo', mapping: 'TBPCIISeqNo'}
			,{name: 'TBPCIILevel', mapping: 'TBPCIILevel'}

		])
	});

    obj.retGridPanelitem = new Ext.grid.EditorGridPanel({
		id : 'retGridPanelitem'
		,store : obj.retGridPanelitemStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ID', width: 100, dataIndex: 'TRowid', sortable: true}
			,{header: '代码', width: 100, dataIndex: 'TBPCIICode', sortable: true}
			,{header: '描述', width: 100, dataIndex: 'TBPCIIDesc', sortable: true}
			,{header: '类型', width: 100, dataIndex: 'TBPCIITypeD', sortable: true}
			,{header: '查找项', width: 150, dataIndex: 'TBPCIIIsSearchD', sortable: true}
			,{header: '显示项', width: 150, dataIndex: 'TBPCIIIsDisplayD', sortable: true}
			,{header: '字段', width: 100, dataIndex: 'TBPCIIDataField', sortable: true}
			,{header: '返回单条数据', width: 100, dataIndex: 'TBPCIIIsSingleD', sortable: true}
			,{header: '最小值', width: 50, dataIndex: 'TBPCIIMinQty', sortable: true}
			,{header: '最大值', width: 150, dataIndex: 'TBPCIIMaxQty', sortable: true}
			,{header: '说明', width: 150, dataIndex: 'TBPCIINote', sortable: true}
			,{header: '多选值', width: 150, dataIndex: 'TBPCIIMultiple', sortable: true}
			,{header: '开始时间', width: 150, dataIndex: 'TBPCIIStartDateTime', sortable: true}
			,{header: '持续小时', width: 150, dataIndex: 'TBPCIIDurationHour', sortable: true}
			,{header: '医嘱备注', width: 150, dataIndex: 'TBPCIIOeoriNote', sortable: true}
			,{header: '起始时间', width: 150, dataIndex: 'TBPCIIFromTime', sortable: true}
			,{header: '终止时间', width: 150, dataIndex: 'TBPCIIToTime', sortable: true}
			,{header: '准确时间', width: 150, dataIndex: 'TBPCIIExactTime', sortable: true}
			,{header: '基准常用医嘱', width: 150, dataIndex: 'TBPCIIRefIcuriDesc', sortable: true}
			,{header: '基准值', width: 150, dataIndex: 'TBPCIIRefValue', sortable: true}
			,{header: '排序号', width: 150, dataIndex: 'TBPCIISeqNo', sortable: true}
			,{header: '筛选值', width: 150, dataIndex: 'TBPCIILevel', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 150,
			store : obj.retGridPanelitemStore,
		    displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
		    emptyMsg: '没有记录'
		})
		});
	obj.Panelitem23 = new Ext.Panel({
		id : 'Panelitem23'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'north'
		,items:[
		]
	});
	obj.Panelitem25 = new Ext.Panel({
		id : 'Panelitem25'
		,hidden:true
		,buttonAlign : 'center'
		,region : 'south'
		,items:[
		]
	});	
	obj.inquiryitemresult = new Ext.Panel({
		id : 'inquiryitemresult'
		,buttonAlign : 'center'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
		    obj.Panelitem23
			,obj.Panelitem25
		    ,obj.retGridPanelitem
			
		]
	});
		
	obj.findinquiryitem = new Ext.Panel({
		id : 'findinquiryitem'
		,buttonAlign : 'center'
		,title:'血液净化查询项目'
		,region : 'center'
		,layout : 'border'
		,iconCls : 'icon-manage'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.inquiryitempanel
			,obj.inquiryitemresult
		]
	});
/////////////////////////////////////////////////////////
		
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,defaults: {
            split: true
        ,collapsible: true
        }
		,items:[
			obj.findinquiry
			,obj.findinquiryitem
		]
	});
	
///////////////////////////////////////////////////////////	
	 InitViewScreenEvent(obj);
	
     obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	 obj.addbutton.on("click", obj.addbutton_click, obj);
	 obj.deletebutton.on("click", obj.deletebutton_click, obj);
	 obj.updatebutton.on("click", obj.updatebutton_click, obj);
    
     obj.retGridPanelitem.on("rowclick", obj.retGridPanelitem_rowclick, obj);
     obj.additembtn.on("click", obj.additembtn_click, obj);
     obj.updateitembtn.on("click", obj.updateitembtn_click, obj);
     obj.deleteitembtn.on("click", obj.deleteitembtn_click, obj);   
          
    obj.LoadEvent(arguments);    
    return obj;	
	
}

