//by+2017-03-03
function InitViewScreen(){
	var obj=new Object();
	obj.ICUCRIDesc = new Ext.form.TextField({
		id : 'ICUCRIDesc'
		,fieldLabel : '名称'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.ICUCRICode = new Ext.form.TextField({
		id : 'ICUCRICode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.ICUCRIColor = new Ext.form.TextField({
		id : 'ICUCRIColor'
		,fieldLabel : '颜色'
		,labelSeparator: ''
		,hidden : true
		,anchor : '98%'
	});
	obj.ICUCRIOptions = new Ext.form.TextField({
		id : 'ICUCRIOptions'
		,fieldLabel : '选项'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.ICUCRIMultiValueDesc = new Ext.form.TextField({
		id : 'ICUCRIMultiValueDesc'
		,fieldLabel : '多数值名'
		,anchor : '98%'
		,labelSeparator: ''
	});
	obj.ICUCRISortNo = new Ext.form.TextField({
		id : 'ICUCRISortNo'
		,fieldLabel : '排序号'
		,labelSeparator: ''
		,anchor : '98%'
	});
	
		obj.ICUCRIMax = new Ext.form.TextField({
		id : 'ICUCRIMax'
		,fieldLabel : '最大值'
		,labelSeparator: ''
		,anchor : '98%'
	});
		obj.ICUCRIMin = new Ext.form.TextField({
		id : 'ICUCRIMin'
		,fieldLabel : '最小值'
		,labelSeparator: ''
		,anchor : '98%'
	});
    
    	obj.ICUCRIImpossibleMax = new Ext.form.TextField({
		id : 'ICUCRIImpossibleMax'
		,fieldLabel : '极限值大'
		,labelSeparator: ''
		,anchor : '98%'
	});
		obj.ICUCRIImpossibleMin = new Ext.form.TextField({
		id : 'ICUCRIImpossibleMin'
		,fieldLabel : '极限值小'
		,labelSeparator: ''
		,anchor : '98%'
	});
/*		obj.ICUCRIDataField = new Ext.form.TextField({
		id : 'ICUCRIDataField'
		,fieldLabel : '对应字段'
		,anchor : '98%'
	});*/
	obj.ICUCRIDataFieldstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.ICUCRIDataFieldstore = new Ext.data.Store({
		proxy: obj.ICUCRIDataFieldstoreProxy,
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
	obj.ICUCRIDataField = new Ext.form.ComboBox({
		id : 'ICUCRIDataField'
		,store:obj.ICUCRIDataFieldstore
		,minChars:1	
		,displayField:'DataField'	
		,fieldLabel : '对应字段'
		,labelSeparator: ''
		,valueField : 'DataField'
		,triggerAction : 'all'
		,anchor : '95%'
		,editable : false
		,selectOnFocus : true
		,mode: 'local'
	}); 	
	
	obj.ICUCRIDataFieldstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCICUCRecordItem';
		param.QueryName = 'FindIcuDataField';
		param.ArgCnt = 0;
	});
	obj.ICUCRIDataFieldstore.load({});	
	
	
	obj.ICUCRIAnMethodDr = new Ext.form.TextField({
		id : 'ICUCRIAnMethodDr'
		,hidden : true
		,anchor : '98%'
	});
	
		obj.ICUCRIFormat = new Ext.form.TextField({
		id : 'ICUCRIFormat'
		,fieldLabel : '格式'
		,labelSeparator: ''
		,anchor : '98%'
	});
		obj.ICUCRIDataFormat = new Ext.form.TextField({
		id : 'ICUCRIDataFormat'
		,fieldLabel : '数据格式'
		,labelSeparator: ''
		,anchor : '98%'
	});
		obj.ICUCRIFormatField = new Ext.form.TextField({
		id : 'ICUCRIFormatField'
		,fieldLabel : '格式字段'
		,labelSeparator: ''
		,anchor : '98%'
	});
	
		obj.ICUCRISumFormat = new Ext.form.TextField({
		id : 'ICUCRISumFormat'
		,fieldLabel : '汇总格式'
		,labelSeparator: ''
		,anchor : '98%'
	});
		obj.ICUCRISumFormatField = new Ext.form.TextField({
		id : 'ICUCRISumFormatField'
		,fieldLabel : '汇总格式字段'
		,labelSeparator: ''
		,anchor : '98%'
	});
	
	
	 obj.textICUCRIAllApply = new Ext.form.Checkbox({
			id : 'obj.textICUCRIAllApply'
			,fieldLabel : '全选'
			,labelSeparator: ''
			,anchor : '98%'
		});
		
	 obj.textICUCRIANApply = new Ext.form.Checkbox({
			id : 'obj.textICUCRIANApply'
			,fieldLabel : 'AN'
			,anchor : '98%'
		});
		
	obj.ICUCRIRowId= new Ext.form.TextField({
			id : 'obj.ICUCRIRowId'
			,hidden : true
			,anchor : '98%'
		});
		
	obj.ICUCRITypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRITypeStore = new Ext.data.Store({
      	proxy: obj.ICUCRITypeStoreProxy,
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
   obj.ICUCRIType =new Ext.form.ComboBox({
      	id : 'obj.ICUCRIType'
      	,store : obj.ICUCRITypeStore
      	,minChars : 0
      	,displayField : 'Desc'
      	,fieldLabel : '分类'
      	,valueField : 'Id'
      	,labelSeparator: ''
		,editable : false
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ICUCRITypeStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindICUCRIType';
      	param.ArgCnt = 0;
      	});
    //obj.ICUCRITypeStore.load();
      	
      	
      	
    obj.ICUCRIArcimDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRIArcimDrStore = new Ext.data.Store({
      	proxy: obj.ICUCRIArcimDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'Id'   
      		}, 
      		[	
      			{name: 'arcimId', mapping: 'arcimId'}
      			,{name: 'arcimDesc', mapping: 'arcimDesc'}
    
      		])
      	});		
   obj.ICUCRIArcimDr =new Ext.form.ComboBox({
      	id : 'ICUCRIArcimDr'
      	,store : obj.ICUCRIArcimDrStore
      	,minChars : 0
      	,displayField : 'arcimDesc'
      	,fieldLabel : '医嘱名称'
      	,labelSeparator: ''
      	,valueField : 'arcimId'
		,editable : true
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ICUCRIArcimDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANCCommonOrd';
      	param.QueryName = 'GetMasterItem';
      	param.Arg1 = " ";
      	param.Arg2 = obj.ICUCRIArcimDr.getRawValue();
      	param.ArgCnt = 2;
      	});
      	//obj.ICUCRIArcimDrStore.load();
      	
      	obj.ICUCRIViewCatDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRIViewCatDrStore = new Ext.data.Store({
      	proxy: obj.ICUCRIViewCatDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'ICUCRIVCId'   
      		}, 
      		[	
      			{name: 'ICUCRIVCId', mapping: 'ICUCRIVCId'}
      			,{name: 'ICUCRIVCDesc', mapping: 'ICUCRIVCDesc'}
      		])
      	});		
   obj.ICUCRIViewCatDr =new Ext.form.ComboBox({
      	id : 'obj.ICUCRIViewCatDr'
      	,store : obj.ICUCRIViewCatDrStore
      	,minChars : 0
      	,displayField : 'ICUCRIVCDesc'
      	,fieldLabel : '显示分类'
      	,valueField : 'ICUCRIVCId'
      	,labelSeparator: ''
      	,labelSeparator: ''
      	,multiSelect : true
		,editable : true
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ICUCRIViewCatDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindICUCRIViewCat';
      	param.Arg1="Y";
      	param.ArgCnt = 1;
      	});
      	//obj.ICUCRIViewCatDrStore.load();
      	
	
    var data = [];
	obj.listICUCRIViewCatDrStoreProxy=data;
	obj.listICUCRIViewCatDrStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'listId'}
			,{name: 'listDesc'}
		])
	});
	//obj.listICUCRIViewCatDrStore.load();
	obj.listICUCRIViewCatDr = new Ext.ListView({
	    id : 'listICUCRIViewCatDr'
		,store: obj.listICUCRIViewCatDrStore
		,multiSelect: true
		//,width : 120
		,height : 40
		,bodyStyle :'overflow-x:hidden;overflow-y:auto'
		,hideHeaders : true
		,columns: [{
		        header : 'listDesc'
                ,dataIndex: 'listDesc'
            }]
    });
      	
      obj.listPanel1 = new Ext.Panel({
	    id : 'listPanel1'
	    //,width:100
	    //,anchor:'70%'
		,frame : true
		,items : [
		    obj.listICUCRIViewCatDr
		]
	});	
      	

    var data = [];
	obj.listTempSubICUCRDrStoreProxy=data;
	obj.listTempSubICUCRDrStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'listId'}
			,{name: 'listDesc'}
		])
	});
	//obj.listTempSubICUCRDrStore.load();
	obj.listTempSubICUCRDr = new Ext.ListView({
	    id : 'listTempSubICUCRDr'
		,store: obj.listTempSubICUCRDrStore
		,multiSelect: true
		//,width : 120
		,height : 40
		,bodyStyle :'overflow-x:hidden;overflow-y:auto'
		,hideHeaders : true
		,columns: [{
		        header : 'listDesc'
                ,dataIndex: 'listDesc'
            }]
    });
      	
      obj.listPanel2 = new Ext.Panel({
	    id : 'listPanel2'
	    //,width:100
	    //,anchor:'70%'
		,frame : true
		,items : [
		    obj.listTempSubICUCRDr
		]
	});
	
	
    obj.ICUCRIUomDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRIUomDrStore = new Ext.data.Store({
      	proxy: obj.ICUCRIUomDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'UomRowId'   
      		}, 
      		[	
      			{name: 'UomRowId', mapping: 'UomRowId'}
      			,{name: 'UomDesc', mapping: 'UomDesc'}
      		])
      	});		
   obj.ICUCRIUomDr =new Ext.form.ComboBox({
      	id : 'obj.ICUCRIUomDr'
      	,store : obj.ICUCRIUomDrStore
      	,minChars : 0
      	,displayField : 'UomDesc'
      	,fieldLabel : '单位'
      	,labelSeparator: ''
      	,valueField : 'UomRowId'
		,editable : true
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ICUCRIUomDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindUom';
      	param.ArgCnt = 0;
      	});
      	//obj.ICUCRIUomDrStore.load();
      	
      	
      	obj.ICUCRIIconDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRIIconDrStore = new Ext.data.Store({
      	proxy: obj.ICUCRIIconDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'IconRowId'   
      		}, 
      		[	
      			{name: 'IconRowId', mapping: 'IconRowId'}
      			,{name: 'IconDesc', mapping: 'IconDesc'}
      		])
      	});		
   obj.ICUCRIIconDr =new Ext.form.ComboBox({
      	id : 'obj.ICUCRIIconDr'
      	,store : obj.ICUCRIIconDrStore
      	,minChars : 0
      	,displayField : 'IconDesc'
      	,fieldLabel : '图例'
      	,valueField : 'IconRowId'
		,editable : true
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ICUCRIIconDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindIcon';
      	param.ArgCnt = 0;
      	});
      	//obj.ICUCRIIconDrStore.load();
      	
      	
      	obj.ICUCRIAnApplyStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRIAnApplyStore = new Ext.data.Store({
      	proxy: obj.ICUCRIAnApplyStoreProxy,
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
   obj.ICUCRIAnApply =new Ext.form.ComboBox({
      	id : 'obj.ICUCRIAnApply'
      	,store : obj.ICUCRIAnApplyStore
      	,minChars : 0
      	,displayField : 'Desc'
      	,fieldLabel : 'An应用'
      	,valueField : 'Id'
		,editable : true
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
   obj.ICUCRIAnApplyStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindICUCRIAnApply';
      	param.ArgCnt = 0;
      	});
      	//obj.ICUCRIAnApplyStore.load();
      	
      	obj.ICUCRIIcuApplyStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRIIcuApplyStore = new Ext.data.Store({
      	proxy: obj.ICUCRIIcuApplyStoreProxy,
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
   obj.ICUCRIIcuApply =new Ext.form.ComboBox({
      	id : 'obj.ICUCRIIcuApply'
      	,store : obj.ICUCRIIcuApplyStore
      	,minChars : 0
      	,displayField : 'Desc'
      	,fieldLabel : 'Icu应用'
      	,valueField : 'Id'
      	,editable : true
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
   obj.ICUCRIIcuApplyStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindICUCRIAnApply';
      	param.ArgCnt = 0;
      	});
      	//obj.ICUCRIIcuApplyStore.load();
      	
     obj.ICUCRIDataTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRIDataTypeStore = new Ext.data.Store({
      	proxy: obj.ICUCRIDataTypeStoreProxy,
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
   obj.ICUCRIDataType =new Ext.form.ComboBox({
      	id : 'ICUCRIDataType'
      	,store : obj.ICUCRIDataTypeStore
      	,minChars : 0
      	,displayField : 'Desc'
      	,fieldLabel : '数据类型'
      	,valueField : 'Id'
		,editable : false
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
      	
              });	
    obj.ICUCRIDataTypeStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindICUCRIDataType';
      	param.ArgCnt = 0;
      	});
      	//obj.ICUCRIDataTypeStore.load(); 	
  
      obj.ICUCRIIsContinueStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRIIsContinueStore = new Ext.data.Store({
      	proxy: obj.ICUCRIIsContinueStoreProxy,
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
   obj.ICUCRIIsContinue =new Ext.form.ComboBox({
      	id : 'obj.ICUCRIIsContinue'
      	,store : obj.ICUCRIIsContinueStore
      	,minChars : 0
      	,displayField : 'Desc'
      	,fieldLabel : '是否继续'
      	,valueField : 'Id'
		,editable : true
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
   obj.ICUCRIIsContinueStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindICUCRIAnApply';
      	param.ArgCnt = 0;
      	});
      	//obj.ICUCRIIsContinueStore.load();
      	
      	obj.ICUCRITemplateICUCRIDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRITemplateICUCRIDrStore = new Ext.data.Store({
      	proxy: obj.ICUCRITemplateICUCRIDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'RowId'   
      		}, 
      		[	//ancodesc,ancoCode,rowid
      			{name: 'rowid', mapping: 'rowid'}
      			,{name: 'IcucDesc', mapping: 'IcucDesc'}
      			,{name: 'IcucCode', mapping: 'IcucCode'}
      		])
      	});		
   obj.ICUCRITemplateICUCRIDr =new Ext.form.ComboBox({
      	id : 'obj.ICUCRITemplateICUCRIDr'
      	,store : obj.ICUCRITemplateICUCRIDrStore
		,listeners:{
		    select:function(combo,record,index){
			    try{
                    obj.ICUCRITemplateSubICUCRIDrStore.removeAll();
                    
                    //obj.ICUCRITemplateSubICUCRIDrStore.reload();

		           }
		        catch(ex)
		        {
			         Ext.MessageBox.alert("错误","数据加载失败。");

		        }
		}
		}
      	,minChars : 0
      	,displayField : 'IcucDesc'
      	,fieldLabel : '模版'
      	,valueField : 'rowid'
		,editable : true
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ICUCRITemplateICUCRIDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindIcucMain';
      	param.Arg1=obj.ICUCRITemplateICUCRIDr.getRawValue();
      	param.Arg2="";
      	param.Arg3="";
      	param.ArgCnt = 3;
      	});
      	//obj.ICUCRITemplateICUCRIDrStore.load();
      	
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
      			{name: 'rowid', mapping: 'rowid'}
      			,{name: 'IcucDesc', mapping: 'IcucDesc'}
      			,{name: 'IcucCode', mapping: 'IcucCode'}
      		])
      	});		
   obj.ICUCRIMainICUCRIDr =new Ext.form.ComboBox({
      	id : 'obj.ICUCRIMainICUCRIDr'
      	,store : obj.ICUCRIMainICUCRIDrStore
      	,minChars : 0
      	,displayField : 'IcucDesc'
      	,fieldLabel : '主项'
      	,valueField : 'rowid'
		,editable : true
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ICUCRIMainICUCRIDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindIcucMain';
      	param.Arg1=obj.ICUCRIMainICUCRIDr.getRawValue();
      	param.Arg2="";
      	param.Arg3="";
      	param.ArgCnt = 3;
      	});
      	//obj.ICUCRIMainICUCRIDrStore.load();
      	
      	obj.ICUCRITemplateSubICUCRIDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRITemplateSubICUCRIDrStore = new Ext.data.Store({
      	proxy: obj.ICUCRITemplateSubICUCRIDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'rowid'   
      		}, 
      		[	//ancodesc,ancoCode,rowid
      			{name: 'rowid', mapping: 'rowid'}
      			,{name: 'icucdesc', mapping: 'icucdesc'}
      			,{name: 'icucCode', mapping: 'icucCode'}
      		])
      	});		
   obj.ICUCRITemplateSubICUCRIDr =new Ext.form.ComboBox({
      	id : 'obj.ICUCRITemplateSubICUCRIDr'
      	,store : obj.ICUCRITemplateSubICUCRIDrStore
      	,minChars : 0
      	,displayField : 'icucdesc'
      	,fieldLabel : '模版子项'
      	,labelSeparator: ''
      	,valueField : 'rowid'
		,editable : true
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ICUCRITemplateSubICUCRIDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindIcucSubAncoMain';
      	param.Arg1=obj.ICUCRITemplateICUCRIDr.getValue();
      	param.Arg2="";
      	param.Arg3="";
      	param.Arg4="";
      	param.ArgCnt = 4;
      	});
      	//obj.ICUCRITemplateSubICUCRIDrStore.load();
      	
      	
    obj.ICUCRIICUCIOIDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRIICUCIOIDrStore = new Ext.data.Store({
      	proxy: obj.ICUCRIICUCIOIDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'itmId'   
      		}, 
      		[	
      			{name: 'itmId', mapping: 'itmId'}
      			,{name: 'itmDesc', mapping: 'itmDesc'}
      		])
      	});		
   obj.ICUCRIICUCIOIDr =new Ext.form.ComboBox({
      	id : 'obj.ICUCRIICUCIOIDr'
      	,store : obj.ICUCRIICUCIOIDrStore
      	,minChars : 0
      	,displayField : 'itmDesc'
      	,fieldLabel : '汇总项'
      	,valueField : 'itmId'
		,editable : true
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ICUCRIICUCIOIDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCIOItem';
      	param.QueryName = 'FindICUCIOItemDesc';
      	param.ArgCnt = 0;
      	});
      	//obj.ICUCRIICUCIOIDrStore.load();
      	
      	obj.ICUCRIArcosDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ICUCRIArcosDrStore = new Ext.data.Store({
      	proxy: obj.ICUCRIArcosDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'ArcosRowId'   
      		}, 
      		[	
      			{name: 'ArcosRowId', mapping: 'ArcosRowId'}
      			,{name: 'ArcosDesc', mapping: 'ArcosDesc'}
      		])
      	});	
      	//20160912+dyl	
   obj.ICUCRIArcosDr =new Ext.form.ComboBox({
      	id : 'ICUCRIArcosDr'
      	,store : obj.ICUCRIArcosDrStore
      	,minChars : 0
      	,displayField : 'ArcosDesc'
      	,fieldLabel : '医嘱套'
      	,valueField : 'ArcosRowId'
		,editable : true
		,selectOnFocus : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ICUCRIArcosDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindArcos';
      	param.ArgCnt = 0;
      	});
      	//obj.ICUCRIArcosDrStore.load();
   
    //颜色
 
	Ext.ux.ColoField=Ext.extend(Ext.form.TextField,{
	defaultAutoCreate : {tag: "input", type: "text", size: "24", autocomplete: "off"},
	id:'colorField',
	name:'color',
	
	labelWidth:1,
	fieldLabel : ' ',
	labelSeparator:' ',
	style:'cursor:hand;',
	color:'', //默认颜色
	width:40,
	height:20,
	onFocus:function(){ 
	   var colorFieldId=this.id;
	   /*if (Ext.getCmp('colorWin'))
	     {
		    Ext.getCmp('colorWin').show();
		    return ;
	     }*/
	   var colorWin=new Ext.Window({
		id:'colorWin',
	    border:false,
	    modal:true,
	    closeAction:'close',
	    closable:true,
	    resizable:true,
	    autoScroll:true, 
	    width:170,
	    height:130,
	    items:[new Ext.ColorPalette({
	     listeners:{
	      'select':function(palette, selColor){      
	       Ext.getDom(colorFieldId).style.background=selColor;      
	       colorWin.close(); 
	      }
	     }
	    })]
	   });
	   colorWin.x=this.getPosition()[0]-this.width;
	   colorWin.y=this.getPosition()[1]+this.height; 
	   colorWin.show();
	},
	afterRender :function(cf,position){   
	   Ext.form.TextField.superclass.afterRender.call(this,cf,position); 
	   Ext.getDom(this.id).style.background=this.color;
	},
	setColor:function(color){
	   Ext.getDom(this.id).style.background=color; 
	},
	getColor:function(){
	   return Ext.getDom(this.id).style.background; 
	}
	});
  Ext.reg('ColoField', Ext.form.TextField); 
  obj.ICUColor=new Ext.ux.ColoField({
         id:'ICUColor',
         color:'', //设置默认颜色
       labelSeparator:':', 
       anchor : '95%',
       fieldLabel:'颜色'
       ,labelSeparator: ''
      
   })
   //20170927+dyl
   obj.chkIfActive = new Ext.form.Checkbox({
		id : 'chkIfActive'
		,boxLabel : '<span style=\'font-size:14px;\'>未激活</span>'
		,autoWidth:true
		,style:'margin-left :40px;'
		,anchor : '100%'
	});
	obj.btnActive = new Ext.Button({
		id : 'btnActive'
		,text : '激活'
		,style:'margin-left :30px;'
		,width :80
		,iconCls : 'icon-setting'
	});
		obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,text : '查询'
		,style:'margin-left :30px;'
		,width :86
		,iconCls : 'icon-find'
	});
	obj.PanelS5 = new Ext.Panel({
		id : 'PanelS5'
		,buttonAlign : 'left'
		,labelWidth:20
		,columnWidth : .1
		,layout : 'column'
		,items:[
		obj.chkIfActive
		,obj.btnSch 
		]
	});
		obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,text : '添加'
		,style:'margin-left :100px;'
		,width :86
		,iconCls : 'icon-add'
	});
		obj.btnUpd = new Ext.Button({
		id : 'btnUpd'
		,text : '更新'
		,width :86
		,style:'margin-left :60px;'
		,iconCls : 'icon-updateSmall'
	});
		obj.btnDel = new Ext.Button({
		id : 'btnDel'
		,text : '删除'
		,width :86
		,style:'margin-left :10px;'
		,iconCls : 'icon-delete'
	});
	obj.PanelS6 = new Ext.Panel({
		id : 'PanelS6'
		,buttonAlign : 'left'
		,labelWidth:20
		,columnWidth : .1
		,layout : 'column'
		,items:[
		obj.btnDel 
		,obj.btnActive
		]
	});
	obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.ICUCRICode
		,obj.ICUCRIType
		,obj.ICUCRIMax
		,obj.ICUCRIOptions
		,obj.ICUCRITemplateICUCRIDr
		,obj.ICUCRIIconDr
		,obj.PanelS5
		]
	});
	obj.Panel2= new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.ICUCRIDesc
		,obj.ICUCRIICUCIOIDr //obj.ICUCRIColor
		,obj.ICUCRIMin
		,obj.ICUCRIMainICUCRIDr
		,obj.ICUCRIFormat
		,obj.ICUCRIFormatField
		,obj.ICUCRIUomDr
		,obj.btnAdd
		]
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.ICUCRIDataType
		,obj.ICUCRIDataFormat
		,obj.ICUCRIImpossibleMax
		,obj.ICUCRIDataField
		,obj.ICUCRISortNo
		,obj.ICUCRIMultiValueDesc
		,obj.btnUpd
		]
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.ICUCRIArcimDr
		,obj.ICUCRIFormatField
		,obj.ICUCRIImpossibleMin
		,obj.ICUCRISumFormat
		,obj.ICUCRISumFormatField
		,obj.ICUCRIArcosDr //obj.ICUCRIColor
		,obj.PanelS6
		]
	});
	
	obj.Panel5= new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.ICUColor
		,obj.ICUCRIViewCatDr
		,obj.listPanel1
		,obj.ICUCRITemplateSubICUCRIDr
		,obj.listPanel2
		,obj.ICUCRIRowId
		,obj.ICUCRIAnMethodDr
		//,obj.ICUCRIColor
		]
	});
	obj.Panel6= new Ext.Panel({
		id : 'Panel6'
		,buttonAlign : 'center'
		,columnWidth : .05
		,layout : 'form'
		,items:[	]
	});
	obj.fPanel = new Ext.form.FormPanel({
		id : 'fPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,height:180
		,region : 'north'
		,layout : 'column'
		,items:[
		  obj.Panel1
	     ,obj.Panel2
	     ,obj.Panel3
	     ,obj.Panel4
	     ,obj.Panel5
	     ,obj.Panel6
		]
	});
    obj.CLCScoreOptionPanel = new Ext.Panel({
		id : 'CLCScoreOptionPanel'
		,buttonAlign : 'center'
		,height : 220
		,title : '常用医嘱'
		,region : 'north'
		,layout : 'form'
		,frame : true
		,iconCls : 'icon-manage'
		,collapsible:true
		,animate:true
		,items:[
		     obj.fPanel
		    ]
	})
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
			,{name: 'tICUCRICode', mapping: 'tICUCRICode'}
			,{name: 'tICUCRIDesc', mapping: 'tICUCRIDesc'}
			,{name: 'tICUCRIType', mapping: 'tICUCRIType'}
			,{name: 'tICUCRITypeDesc', mapping: 'tICUCRITypeDesc'}
			,{name: 'tICUCRIArcimDr', mapping: 'tICUCRIArcimDr'}
			,{name: 'tICUCRIArcim', mapping: 'tICUCRIArcim'}
			,{name: 'tICUCRIViewCatDr', mapping: 'tICUCRIViewCatDr'}
			,{name: 'tICUCRIViewCat', mapping: 'tICUCRIViewCat'}
			,{name: 'tICUCRIUomDr', mapping: 'tICUCRIUomDr'}
			,{name: 'tICUCRIUom', mapping: 'tICUCRIUom'}
			,{name: 'tICUCRIIconDr', mapping: 'tICUCRIIconDr'}
			,{name: 'tICUCRIIcon', mapping: 'tICUCRIIcon'}
			,{name: 'tICUCRIColor', mapping: 'tICUCRIColor'}
			,{name: 'tICUCRIAnApply', mapping: 'tICUCRIAnApply'}
			,{name: 'tICUCRIIcuApply', mapping: 'tICUCRIIcuApply'}
			,{name: 'tICUCRIOptions', mapping: 'tICUCRIOptions'}
			,{name: 'tICUCRIICUCIOIDr', mapping: 'tICUCRIICUCIOIDr'}
			,{name: 'tICUCRIICUCIOI', mapping: 'tICUCRIICUCIOI'}
			,{name: 'tICUCRIMultiValueDesc', mapping: 'tICUCRIMultiValueDesc'}
			,{name: 'tICUCRISortNo', mapping: 'tICUCRISortNo'}
			,{name: 'tICUCRIArcosDr', mapping: 'tICUCRIArcosDr'}
			,{name: 'tICUCRIArcos', mapping: 'tICUCRIArcos'}
			,{name: 'tICUCRIDataType', mapping: 'tICUCRIDataType'}
			,{name: 'tICUCRIDataTypeDesc', mapping: 'tICUCRIDataTypeDesc'}
			,{name: 'tICUCRIIsContinue', mapping: 'tICUCRIIsContinue'}
			,{name: 'tICUCRIAnMethodDr', mapping: 'tICUCRIAnMethodDr'}
			,{name: 'tICUCRIMax', mapping: 'tICUCRIMax'}
			,{name: 'tICUCRIMin', mapping: 'tICUCRIMin'}
			,{name: 'tICUCRIImpossibleMax', mapping: 'tICUCRIImpossibleMax'}
			,{name: 'tICUCRIImpossibleMin', mapping: 'tICUCRIImpossibleMin'}
			,{name: 'tICUCRIMainICUCRIDr', mapping: 'tICUCRIMainICUCRIDr'}
			,{name: 'tICUCRIMainICUCRI', mapping: 'tICUCRIMainICUCRI'}
			,{name: 'tICUCRIDataField', mapping: 'tICUCRIDataField'}
			,{name: 'tICUCRIDataFielddesc', mapping: 'tICUCRIDataFielddesc'}
			,{name: 'tICUCRIDataFormat', mapping: 'tICUCRIDataFormat'}
			,{name: 'tICUCRIFormat', mapping: 'tICUCRIFormat'}
			,{name: 'tICUCRIFormatField', mapping: 'tICUCRIFormatField'}
			,{name: 'tICUCRITemplateICUCRIDr', mapping: 'tICUCRITemplateICUCRIDr'}
			,{name: 'tICUCRITemplateICUCRI', mapping: 'tICUCRITemplateICUCRI'}
			,{name: 'tICUCRITemplateSubICUCRIDr', mapping: 'tICUCRITemplateSubICUCRIDr'}
			,{name: 'tICUCRITemplateSubICUCRI', mapping: 'tICUCRITemplateSubICUCRI'}
			,{name: 'tICUCRISumFormat', mapping: 'tICUCRISumFormat'}
			,{name: 'tICUCRISumFormatField', mapping: 'tICUCRISumFormatField'}
			
		])
	});		
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true            
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 100, dataIndex: 'tICUCRICode',sortable: true}
			,{header: '名称', width: 100, dataIndex: 'tICUCRIDesc',sortable: true}
			,{header: '对应医嘱项', width: 100, dataIndex: 'tICUCRIArcim', sortable: true}
			,{header: '项目分类', width: 100, dataIndex: 'tICUCRITypeDesc', sortable: true}
			,{header: '显示分类', width: 100, dataIndex: 'tICUCRIViewCat', sortable: true}	
			,{header: 'tICUCRIViewCatDr', width: 100, dataIndex: 'tICUCRIViewCatDr', sortable: true}
			,{header: '行号', width: 100, dataIndex: 'tRowId',sortable: true}
			,{header: '图例Id', width: 100, dataIndex: 'tICUCRIIconDr',sortable: true}
			,{header: '图例名称', width: 100, dataIndex: 'tICUCRIIcon', sortable: true}
			,{header: '单位Id', width: 100, dataIndex: 'tICUCRIUomDr', sortable: true}
			,{header: '单位', width: 100, dataIndex: 'tICUCRIUom', sortable: true}	
			,{header: '颜色', width: 100, dataIndex: 'tICUCRIColor', sortable: true}
			,{header: '对应字段', width: 100, dataIndex: 'tICUCRIDataField', sortable: true}
			,{header: '选项', width: 100, dataIndex: 'tICUCRIOptions',sortable: true}
			,{header: '多数值名', width: 100, dataIndex: 'tICUCRIMultiValueDesc',sortable: true}
			,{header: 'tItmId', width: 100, dataIndex: 'tICUCRIICUCIOIDr', sortable: true}
			,{header: '排序号', width: 100, dataIndex: 'tICUCRISortNo', sortable: true}
			,{header: '主项', width: 100, dataIndex: 'tICUCRIMainICUCRI', sortable: true}
			,{header: '医嘱套', width: 100, dataIndex: 'tICUCRIArcos', sortable: true}	
			,{header: '数据类型', width: 100, dataIndex: 'tICUCRIDataTypeDesc', sortable: true}
			,{header: '最大值', width: 100, dataIndex: 'tICUCRIMax', sortable: true}
			,{header: '最小值', width: 100, dataIndex: 'tICUCRIMin', sortable: true}
			,{header: '极限值大', width: 100, dataIndex: 'tICUCRIImpossibleMax', sortable: true}	
			,{header: '极限值小', width: 100, dataIndex: 'tICUCRIImpossibleMin', sortable: true}
			,{header: '汇总格式', width: 100, dataIndex: 'tICUCRISumFormat', sortable: true}	
			,{header: '汇总格式字段', width: 100, dataIndex: 'tICUCRISumFormatField', sortable: true}
			,{header: '观察项', width: 100, dataIndex: 'tICUCRIICUCIOI', sortable: true}
			,{header: '模版子项', width: 100, dataIndex: 'tICUCRITemplateSubICUCRI', sortable: true}
						
		]
	})
	var selnum=0;
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
		,cm:cm
		,viewConfig:
		{
			forceFit: false
			
		}
		,bbar: new Ext.PagingToolbar({
			pageSize : 2000,
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
								,limit:2000
								}});
					    //return;
				    }
			    }
		    }
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
		param.ClassName = 'web.DHCICUCRecordItem';
		param.QueryName = 'FindICUCRecordItem';
		param.Arg1=obj.ICUCRIDesc.getValue();
		param.Arg2=obj.ICUCRIViewCatDr.getRawValue();
		param.Arg3=obj.ICUCRIType.getRawValue();
		param.Arg4=obj.ICUCRICode.getValue();
		param.Arg5=obj.ICUCRIDataType.getValue();
		//alert(obj.chkIfActive.getValue())
		param.Arg6=obj.chkIfActive.getValue()?'Y':'N';
		param.ArgCnt =6;
	});
	obj.retGridPanelStore.load({
	params : {
		start:0
		,limit:2000
	}});
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,defaults: {
            split: true
        }
		,items:[
			 
			 obj.resultPanel
			 ,obj.CLCScoreOptionPanel
		]
	});
	InitViewScreenEvent(obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnDel.on("click", obj.btnDel_click, obj);
	//20170927+dyl
	obj.btnActive.on("click", obj.btnActive_click, obj);
	obj.btnAdd.on("click", obj.btnAdd_click, obj);
	obj.btnUpd.on("click", obj.btnUpd_click, obj);
	//颜色
	//obj.ICUColor.on("click", obj.ICUColor_click, obj);
	 //   obj.ICUColor.on("keypress", HexFilter, obj);
	//    obj.ICUColor.on("onblur", FormatColor, obj);
	//obj.btnUpd.on("click", obj.btnUpd_click, obj);
	//obj.btnUpd.on("click", obj.btnUpd_click, obj);
	//
	obj.ICUCRIViewCatDr.on('select',obj.ICUCRIViewCatDr_select,obj);
	obj.ICUCRITemplateSubICUCRIDr.on('select',obj.ICUCRITemplateSubICUCRIDr_select,obj);
	obj.listICUCRIViewCatDr.on('dblClick',obj.listICUCRIViewCatDr_dblClick,obj);
	obj.listTempSubICUCRDr.on('dblClick',obj.listTempSubICUCRDr_dblClick,obj);
  	obj.LoadEvent(arguments);
	return obj;
}


