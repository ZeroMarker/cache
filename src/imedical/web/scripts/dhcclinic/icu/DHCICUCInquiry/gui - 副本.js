function InitViewScreen(){
	var obj = new Object();
	
	obj.ICUCICode = new Ext.form.TextField({
		id : 'ICUCICode'
		,fieldLabel : '����'
		,anchor : '95%'
	}); 
	obj.ICUCISearchLevel = new Ext.form.TextField({
		id : 'ICUCISearchLevel'
		,fieldLabel : '��������'
		,anchor : '95%'
	});
	
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .12
		,labelWidth:60
		,layout : 'form'
		,items:[
			obj.ICUCICode
			,obj.ICUCISearchLevel
		]
	});	
	
	obj.ICUCIDesc = new Ext.form.TextField({
		id : 'ICUCIDesc'
		,fieldLabel : '����'
		,anchor : '95%'
	}); 
	
	obj.ICUCIIcuaCount = new Ext.form.TextField({
		id : 'ICUCIIcuaCount'
		,fieldLabel : 'ͳ��'
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
			obj.ICUCIDesc
			,obj.ICUCIIcuaCount
			,obj.Rowid
		]
	});
	
	obj.ICUCICtlocDrstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ICUCICtlocDrstore = new Ext.data.Store({
		proxy: obj.ICUCICtlocDrstoreProxy,
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
	obj.ICUCICtlocDr = new Ext.form.ComboBox({
		id : 'ICUCICtlocDr'
		,store:obj.ICUCICtlocDrstore
		,minChars:1
		,displayField:'oprCtLoc'
		,fieldLabel : '����'
		,valueField : 'oprLocId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.ICUCIResultCount = new Ext.form.TextField({
		id : 'ICUCIResultCount'
		,fieldLabel : '���ͳ��'
		,anchor : '95%'
	}); 
	
	
		
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,labelWidth:60
		,layout : 'form'
		,items:[
			obj.ICUCICtlocDr
			,obj.ICUCIResultCount
		]
	});
	//ȡ����
	/*
	obj.ICUCIType = new Ext.form.TextField({
		id : 'ICUCIType'
		,fieldLabel : '����'
		,anchor : '95%'
	}); 
	*/
		var data=[
		['A','All'],
		['L','Location'],
		['U','User']
	]
	obj.comTypeStoreProxy=data;
	obj.comTypeStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});

	obj.comTypeStore.load({});
	obj.ICUCIType = new Ext.form.ComboBox({
		id : 'ICUCIType'
		,minChars : 1
		,fieldLabel : '����'
		,triggerAction : 'all'
		,mode:'local'
		,store : obj.comTypeStore
		,displayField : 'desc'
		,valueField : 'code'
		//,allowBlank : false
		,anchor :'95%'
	});
	obj.ICUCIUpdateUserDr = new Ext.form.TextField({
		id : 'ICUCIUpdateUserDr'
		,fieldLabel : '�����û�'
		,anchor : '95%'
	}); 
	obj.ICUCIUpdateDate = new Ext.form.TextField({
		id : 'ICUCIUpdateDate'
		,fieldLabel : '��������'
		,anchor : '95%'
	}); 
	obj.ICUCIUpdateTime = new Ext.form.TextField({
		id : 'ICUCIUpdateTime'
		,fieldLabel : '����ʱ��'
		,anchor : '95%'
	});
	obj.ICUCIDataType = new Ext.form.TextField({
		id : 'ICUCIDataType'
		,fieldLabel : 'ͳ������'
		,anchor : '95%'
	}); 
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .12
		,labelWidth:60
		,layout : 'form'
		,items:[
			obj.ICUCIType
			,obj.ICUCIDataType
		]
	});
	
	
	obj.ICUCIStatusstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ICUCIStatusstore = new Ext.data.Store({
		proxy: obj.ICUCIStatusstoreProxy,
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
	obj.ICUCIStatus = new Ext.form.ComboBox({
		id : 'ICUCIStatus'
		,store:obj.ICUCIStatusstore
		,minChars:1
		,displayField:'StatusDesc'
		,fieldLabel : '״̬'
		,valueField : 'StatusCode'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.addbutton = new Ext.Button({
		id : 'addbutton'
		,text : '����'
	});
	obj.deletebutton = new Ext.Button({
		id : 'deletebutton'
		,text : 'ɾ��'
	});
	obj.updatebutton = new Ext.Button({
		id : 'updatebutton'
		,text : '����'
	});	
	obj.Panel5 = new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .14
		,labelWidth:60
		,layout : 'form'
		,items:[
			obj.ICUCIUpdateDate
			,obj.ICUCIStatus
		]
	});
	obj.Panel6 = new Ext.Panel({
		id : 'Panel6'
		,buttonAlign : 'center'
		,columnWidth : .12
		,labelWidth:60
		,layout : 'form'
		,items:[
			obj.ICUCIUpdateTime
			,obj.ICUCIUpdateUserDr
		]
	});
	obj.Panel7 = new Ext.Panel({
		id : 'Panel7'
		,buttonAlign : 'center'
		,columnWidth : .04
		,layout : 'form'
		,items:[			
			obj.addbutton
			,obj.updatebutton
       ]
	});	
	obj.Panel8 = new Ext.Panel({
		id : 'Panel8'
		,buttonAlign : 'center'
		,columnWidth : .04
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
		,height : 60
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
			,{name: 'TICUCICode', mapping : 'TICUCICode'}
			,{name: 'TICUCIDesc', mapping : 'TICUCIDesc'}
			,{name: 'TICUCICtlocDr', mapping : 'TICUCICtlocDr'}
			,{name: 'TICUCICtloc', mapping : 'TICUCICtloc'}
			,{name: 'TICUCIStatusCode', mapping: 'TICUCIStatusCode'}
			,{name: 'TICUCIStatus', mapping: 'TICUCIStatus'}
			,{name: 'TICUCISearchLevel', mapping: 'TICUCISearchLevel'}
			,{name: 'TICUCIIcuaCount', mapping: 'TICUCIIcuaCount'}
			,{name: 'TICUCIResultCount', mapping: 'TICUCIResultCount'}
			
			,{name: 'TICUCIType', mapping: 'TICUCIType'}
			,{name: 'TICUCIUpdateUserDr', mapping: 'TICUCIUpdateUserDr'}
			,{name: 'TICUCIUpdateDate', mapping: 'TICUCIUpdateDate'}
			,{name: 'TICUCIDataType', mapping: 'TICUCIDataType'}
		])
	});

    obj.retGridPanel = new Ext.grid.EditorGridPanel({
		id : 'retGridPanel'
		,store : obj.retGridPanelStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns:[
		new Ext.grid.RowNumberer()
		,{header: '����', width: 150, dataIndex: 'TICUCICode', sortable: true}
		,{header: '����', width: 150, dataIndex: 'TICUCIDesc', sortable: true}
		,{header: '����', width: 200, dataIndex: 'TICUCICtloc', sortable: true}
		,{header: 'TICUCICtlocDr',width: 10, dataIndex : 'TICUCICtlocDr' ,hidden:true}
		,{header: '״̬', width: 150, dataIndex: 'TICUCIStatus', sortable: true}
		,{header: '��������', width: 150, dataIndex: 'TICUCISearchLevel', sortable: true}
		,{header: 'ͳ��', width:150, dataIndex: 'TICUCIIcuaCount', sortable: true}
		,{header: '���ͳ��', width: 150, dataIndex: 'TICUCIResultCount', sortable: true}
		// Add by DTJ 2014-03-12
		,{header: '����', width: 150, dataIndex: 'TICUCIType', sortable: true}
		,{header: '�û�', width: 150, dataIndex: 'TICUCIUpdateUserDr', sortable: true}
		,{header: '��������', width: 150, dataIndex: 'TICUCIUpdateDate', sortable: true}
		,{header: 'ͳ������', width: 150, dataIndex: 'TICUCIDataType', sortable: true}

		]
//		,viewConfig:
//		{
//			forceFit: false
//		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 200,
			store : obj.retGridPanelStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
		})
	});
	obj.ICUCICtlocDrstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCInquiry';
		param.QueryName = 'ctloclookup';
		param.Arg1=obj.ICUCICtlocDr.getRawValue();
		param.ArgCnt = 1;
	});
	//obj.ICUCICtlocDrstore.load({});
	
	obj.ICUCIStatusstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCInquiry';
		param.QueryName = 'Statuslookup';
		param.ArgCnt = 0;
	});
	//obj.ICUCIStatusstore.load({});
	obj.retGridPanelStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCInquiry';
		param.QueryName = 'FindICUCInquiry';
		param.Arg1=obj.ICUCICtlocDr.getValue();
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
		,height : 240
		,title : '��֢��ѯ'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
			obj.inquirypanel
			,obj.inquiryresult
		]
	});
	
//////////////////////////////////////////////////////	
	/*obj.ICUCIICode = new Ext.form.TextField({
		id : 'ICUCIICode'
		,fieldLabel : '����'
		,anchor : '95%'
	});	*/
    obj.ICUCRIMainICUCRIDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRIMainICUCRIDrStore = new Ext.data.Store({
      	proxy: obj.ICUCRIMainICUCRIDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'RowId'   
      		}, 
      		[	//ancodesc,ancoCode,rowid
      			{name: 'rowid', mapping: 'tRowId'}
      			,{name: 'IcucDesc', mapping: 'tICUCRICode'}
      			,{name: 'IcucCode', mapping: 'tICUCRIDesc'}
      		])
      	});		
  obj.ICUCIICode =new Ext.form.ComboBox({
      	id : 'obj.ICUCIICode'
      	,store : obj.ICUCRIMainICUCRIDrStore
      	,minChars : 0
      	,displayField : 'IcucDesc'
      	,fieldLabel : '����'
      	,valueField : 'rowid'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '95%'
              });	
    obj.ICUCRIMainICUCRIDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindICUCRecordItem';
      	param.Arg1=obj.ICUCIICode.getRawValue();
      	param.Arg2="";
      	param.Arg3="";
      	param.Arg4="";
      	param.Arg5="";
      	param.ArgCnt = 5;
      	});
      	//obj.ICUCRIMainICUCRIDrStore.load();     	
      	
	obj.ICUCIIDataField = new Ext.form.TextField({
		id : 'ICUCIIDataField'
		,fieldLabel : '�ֶ�'
		,anchor : '95%'
	});	

	obj.ICUCIIMultiple = new Ext.form.TextField({
		id : 'ICUCIIMultiple'
		,fieldLabel : '��ѡֵ'
		,anchor : '95%'
	});	

/*	obj.ICUCIIToTime = new Ext.form.TextField({
		id : 'ICUCIIToTime'
		,fieldLabel : '��ֹʱ��'
		,anchor : '95%'
	});	*/
	obj.ICUCIIToTime = new Ext.form.TimeField({
	    id : 'ICUCIIToTime'
		,format : 'H:i'
		//,increment : 30
		,fieldLabel : '��ֹʱ��'
		,anchor : '95%'
	});
	obj.ICUCIILevel = new Ext.form.TextField({
		id : 'ICUCIILevel'
		,fieldLabel : 'ɸѡ��'
		,anchor : '95%'
	});	
	obj.ICUCIIRowid = new Ext.form.TextField({
		id : 'ICUCIIRowid'
		,hidden : true
    });				
   	obj.itempanel1 = new Ext.Panel({
		id : 'itempanel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ICUCIICode
			,obj.ICUCIIDataField
			,obj.ICUCIIMultiple
			,obj.ICUCIIToTime
			,obj.ICUCIILevel
			,obj.ICUCIIRowid
		]
	});
		
	obj.ICUCIIDesc = new Ext.form.TextField({
		id : 'ICUCIIDesc'
		,fieldLabel : '����'
		,anchor : '95%'
	});			
		
/*	obj.ICUCIIIsSingle = new Ext.form.TextField({
		id : 'ICUCIIIsSingle'
		,fieldLabel : '���ص�������'
		,anchor : '95%'
	});	*/
	obj.ICUCIIIsSinglestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ICUCIIIsSinglestore = new Ext.data.Store({
		proxy: obj.ICUCIIIsSinglestoreProxy,
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
	
	
	obj.ICUCIIIsSingle = new Ext.form.ComboBox({
		id : 'ICUCIIIsSingle'
		,store:obj.ICUCIIIsSinglestore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '���ص�������'
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.ICUCIIIsSinglestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCInquiry';
		param.QueryName = 'FindBoolen';
		param.ArgCnt = 0;
	});
	//obj.ICUCIIIsSinglestore.load({});
	
	obj.ICUCIIStartDateTime = new Ext.form.TextField({
		id : 'ICUCIIStartDateTime'
		,fieldLabel : '��ʼʱ��'
		,anchor : '95%'
	});	
	
/*	obj.ICUCIIExactTime = new Ext.form.TextField({
		id : 'ICUCIIExactTime'
		,fieldLabel : '׼ȷʱ��'
		,anchor : '95%'
	});	*/
	obj.ICUCIIExactTime = new Ext.form.TimeField({
	    id : 'ICUCIIExactTime'
		,format : 'H:i'
		//,increment : 30
		,fieldLabel : '׼ȷʱ��'
		,anchor : '95%'
	});
	obj.additembtn = new Ext.Button({
		id : 'additembtn'
		,text : '����'
	});	
	obj.itempanel2 = new Ext.Panel({
		id : 'itempanel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ICUCIIDesc
			,obj.ICUCIIIsSingle
			,obj.ICUCIIStartDateTime
			,obj.ICUCIIExactTime
		]
		,buttons:[
		    obj.additembtn
		]
	});
		
/*	obj.ICUCIIType = new Ext.form.TextField({
		id : 'ICUCIIType'
		,fieldLabel : '����'
		,anchor : '95%'
	});*/
	obj.ICUCIITypestoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ICUCIITypestore = new Ext.data.Store({
		proxy: obj.ICUCIITypestoreProxy,
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
	obj.ICUCIIType = new Ext.form.ComboBox({
		id : 'ICUCIIType'
		,store:obj.ICUCIITypestore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '����'
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.ICUCIITypestoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCInquiry';
		param.QueryName = 'FindType';
		param.ArgCnt = 0;
	});
	//obj.ICUCIITypestore.load({});
	
	obj.ICUCIIMinQty = new Ext.form.TextField({
		id : 'ICUCIIMinQty'
		,fieldLabel : '��Сֵ'
		,anchor : '95%'
	});
	obj.ICUCIIDurationHour = new Ext.form.TextField({
		id : 'ICUCIIDurationHour'
		,fieldLabel : '����ʱ��'
		,anchor : '95%'
	});
/*	obj.ICUCIIRefIcuriId = new Ext.form.TextField({
		id : 'ICUCIIRefIcuriId'
		,fieldLabel : '��׼����ҽ��'
		,anchor : '95%'
	});*/

	obj.ICUCIIRefIcuriIdstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    function seltext(v, record) { 
         return record.tRowId+" || "+record.tICUCRIDesc; 
    } 
	obj.ICUCIIRefIcuriIdstore = new Ext.data.Store({
		proxy: obj.ICUCIIRefIcuriIdstoreProxy,
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
	obj.ICUCIIRefIcuriId = new Ext.form.ComboBox({
		id : 'ICUCIIRefIcuriId'
		,store:obj.ICUCIIRefIcuriIdstore
		,minChars:1
		//,displayField:'tICUCRIDesc'
		,displayField:'selecttexts'
		,fieldLabel : '��׼����ҽ��'
		,valueField : 'tRowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.ICUCIIRefIcuriIdstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCRecordItem';
		param.QueryName = 'FindICUCRecordItem';
		param.Arg1=obj.ICUCIIRefIcuriId.getRawValue();
		param.Arg2="";
		param.Arg3="";
		param.Arg4="";
		param.Arg5=""
		param.ArgCnt = 5;
	});
	//obj.ICUCIIRefIcuriIdstore.load({});
	obj.updateitembtn = new Ext.Button({
		id : 'updateitembtn'
		,text : '����'
	});		
	obj.itempanel3 = new Ext.Panel({
		id : 'itempanel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ICUCIIType
			,obj.ICUCIIMinQty
			,obj.ICUCIIDurationHour
			,obj.ICUCIIRefIcuriId
		]
		,buttons:[
		    obj.updateitembtn
		]
	});
/*	obj.ICUCIIIsSearch = new Ext.form.TextField({
		id : 'ICUCIIIsSearch'
		,fieldLabel : '������'
		,anchor : '95%'
	});*/
	obj.ICUCIIIsSearchstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ICUCIIIsSearchstore = new Ext.data.Store({
		proxy: obj.ICUCIIIsSearchstoreProxy,
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
	
	
	obj.ICUCIIIsSearch = new Ext.form.ComboBox({
		id : 'ICUCIIIsSearch'
		,store:obj.ICUCIIIsSearchstore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '������'
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.ICUCIIIsSearchstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCInquiry';
		param.QueryName = 'FindBoolen';
		param.ArgCnt = 0;
	});
	//obj.ICUCIIIsSearchstore.load({});
	
	obj.ICUCIIMaxQty = new Ext.form.TextField({
		id : 'ICUCIIMaxQty'
		,fieldLabel : '���ֵ'
		,anchor : '95%'
	});
	obj.ICUCIIOeoriNote = new Ext.form.TextField({
		id : 'ICUCIIOeoriNote'
		,fieldLabel : 'ҽ����ע'
		,anchor : '95%'
	});
	obj.ICUCIIRefValue = new Ext.form.TextField({
		id : 'ICUCIIRefValue'
		,fieldLabel : '��׼ֵ'
		,anchor : '95%'
	});
	obj.deleteitembtn = new Ext.Button({
		id : 'deleteitembtn'
		,text : 'ɾ��'
	});			
	obj.itempanel4 = new Ext.Panel({
		id : 'itempanel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ICUCIIIsSearch
			,obj.ICUCIIMaxQty
			,obj.ICUCIIOeoriNote
			,obj.ICUCIIRefValue
		]
		,buttons:[
		    obj.deleteitembtn
		]
	});
	
/*	obj.ICUCIIIsDisplay = new Ext.form.TextField({
		id : 'ICUCIIIsDisplay'
		,fieldLabel : '��ʾ��'
		,anchor : '95%'
	});*/
	obj.ICUCIIIsDisplaystoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ICUCIIIsDisplaystore = new Ext.data.Store({
		proxy: obj.ICUCIIIsDisplaystoreProxy,
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
	
	
	obj.ICUCIIIsDisplay = new Ext.form.ComboBox({
		id : 'ICUCIIIsDisplay'
		,store:obj.ICUCIIIsDisplaystore
		,minChars:1
		,displayField:'Desc'
		,fieldLabel : '��ʾ��'
		,valueField : 'Id'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	
	obj.ICUCIIIsDisplaystoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCInquiry';
		param.QueryName = 'FindBoolen';
		param.ArgCnt = 0;
	});
	//obj.ICUCIIIsDisplaystore.load({});
	
	obj.ICUCIINote = new Ext.form.TextField({
		id : 'ICUCIINote'
		,fieldLabel : '˵��'
		,anchor : '95%'
	});

/*	obj.ICUCIIFromTime = new Ext.form.TextField({
		id : 'ICUCIIFromTime'
		,fieldLabel : '��ʼʱ��'
		,anchor : '95%'
	});*/
	obj.ICUCIIFromTime = new Ext.form.TimeField({
	    id : 'ICUCIIFromTime'
		,format : 'H:i'
		//,increment : 30
		,fieldLabel : '��ʼʱ��'
		,anchor : '95%'
	});
	obj.ICUCIISeqNo = new Ext.form.TextField({
		id : 'ICUCIISeqNo'
		,fieldLabel : '�����'
		,anchor : '95%'
	});		
	obj.itempanel5 = new Ext.Panel({
		id : 'itempanel5'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
			obj.ICUCIIIsDisplay
			,obj.ICUCIINote
			,obj.ICUCIIFromTime
			,obj.ICUCIISeqNo
		]
	});
	obj.inquiryitempanel = new Ext.form.FormPanel({
		id : 'inquiryitempanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'north'
		,height : 150
		,layout : 'column'
		,frame : true
		,items:[
			obj.itempanel1
			,obj.itempanel2
			,obj.itempanel3	
			,obj.itempanel4	
			,obj.itempanel5		
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
			,{name: 'TICUCIICode', mapping: 'TICUCIICode'}
			,{name: 'TICUCIIDesc', mapping: 'TICUCIIDesc'}
			,{name: 'TICUCIIType', mapping: 'TICUCIIType'}
			,{name: 'TICUCIITypeD', mapping: 'TICUCIITypeD'}
			,{name: 'TICUCIIIsSearch', mapping: 'TICUCIIIsSearch'}
			,{name: 'TICUCIIIsSearchD', mapping: 'TICUCIIIsSearchD'}
			,{name: 'TICUCIIIsDisplay', mapping: 'TICUCIIIsDisplay'}
			,{name: 'TICUCIIIsDisplayD', mapping: 'TICUCIIIsDisplayD'}
			,{name: 'TICUCIIDataField', mapping: 'TICUCIIDataField'}
			,{name: 'TICUCIIIsSingle', mapping: 'TICUCIIIsSingle'}
			,{name: 'TICUCIIIsSingleD', mapping: 'TICUCIIIsSingleD'}
			,{name: 'TICUCIIMinQty', mapping: 'TICUCIIMinQty'}
			,{name: 'TICUCIIMaxQty', mapping: 'TICUCIIMaxQty'}
			,{name: 'TICUCIINote', mapping: 'TICUCIINote'}
			,{name: 'TICUCIIMultiple', mapping: 'TICUCIIMultiple'}
			,{name: 'TICUCIIStartDateTime', mapping: 'TICUCIIStartDateTime'}
			,{name: 'TICUCIIDurationHour', mapping: 'TICUCIIDurationHour'}
			,{name: 'TICUCIIOeoriNote', mapping: 'TICUCIIOeoriNote'}
			,{name: 'TICUCIIFromTime', mapping: 'TICUCIIFromTime'}
			,{name: 'TICUCIIToTime', mapping: 'TICUCIIToTime'}
			,{name: 'TICUCIIExactTime', mapping: 'TICUCIIExactTime'}
			,{name: 'TICUCIIRefIcuriId', mapping: 'TICUCIIRefIcuriId'}
			,{name: 'TICUCIIRefIcuriDesc', mapping: 'TICUCIIRefIcuriDesc'}
			,{name: 'TICUCIIRefValue', mapping: 'TICUCIIRefValue'}
			,{name: 'TICUCIISeqNo', mapping: 'TICUCIISeqNo'}
			,{name: 'TICUCIILevel', mapping: 'TICUCIILevel'}

		])
	});

    obj.retGridPanelitem = new Ext.grid.EditorGridPanel({
		id : 'retGridPanelitem'
		,store : obj.retGridPanelitemStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //����Ϊ����ѡ��ģʽ
		,clicksToEdit:1    //�����༭
		,loadMask : true
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: 'ID', width: 100, dataIndex: 'TRowid', sortable: true}
			,{header: '����', width: 100, dataIndex: 'TICUCIICode', sortable: true}
			,{header: '����', width: 100, dataIndex: 'TICUCIIDesc', sortable: true}
			,{header: '����', width: 100, dataIndex: 'TICUCIITypeD', sortable: true}
			,{header: '������', width: 150, dataIndex: 'TICUCIIIsSearchD', sortable: true}
			,{header: '��ʾ��', width: 150, dataIndex: 'TICUCIIIsDisplayD', sortable: true}
			,{header: '�ֶ�', width: 100, dataIndex: 'TICUCIIDataField', sortable: true}
			,{header: '���ص�������', width: 100, dataIndex: 'TICUCIIIsSingleD', sortable: true}
			,{header: '��Сֵ', width: 50, dataIndex: 'TICUCIIMinQty', sortable: true}
			,{header: '���ֵ', width: 150, dataIndex: 'TICUCIIMaxQty', sortable: true}
			,{header: '˵��', width: 150, dataIndex: 'TICUCIINote', sortable: true}
			,{header: '��ѡֵ', width: 150, dataIndex: 'TICUCIIMultiple', sortable: true}
			,{header: '��ʼʱ��', width: 150, dataIndex: 'TICUCIIStartDateTime', sortable: true}
			,{header: '����Сʱ', width: 150, dataIndex: 'TICUCIIDurationHour', sortable: true}
			,{header: 'ҽ����ע', width: 150, dataIndex: 'TICUCIIOeoriNote', sortable: true}
			,{header: '��ʼʱ��', width: 150, dataIndex: 'TICUCIIFromTime', sortable: true}
			,{header: '��ֹʱ��', width: 150, dataIndex: 'TICUCIIToTime', sortable: true}
			,{header: '׼ȷʱ��', width: 150, dataIndex: 'TICUCIIExactTime', sortable: true}
			,{header: '��׼����ҽ��', width: 150, dataIndex: 'TICUCIIRefIcuriDesc', sortable: true}
			,{header: '��׼ֵ', width: 150, dataIndex: 'TICUCIIRefValue', sortable: true}
			,{header: '�����', width: 150, dataIndex: 'TICUCIISeqNo', sortable: true}
			,{header: 'ɸѡֵ', width: 150, dataIndex: 'TICUCIILevel', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 150,
			store : obj.retGridPanelitemStore,
		    displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
		    emptyMsg: 'û�м�¼'
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
		,title:'��֢��ѯ��Ŀ'
		,region : 'center'
		,layout : 'border'
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

