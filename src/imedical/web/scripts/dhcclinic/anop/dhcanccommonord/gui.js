//20170303+dyl
function InitViewScreen(){
	var obj=new Object();

	obj.ANCOCode = new Ext.form.TextField({
		id : 'ANCOCode'
		,fieldLabel : '代码'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.ANCODesc = new Ext.form.TextField({
		id : 'ANCODesc'
		,fieldLabel : '名称'
		,labelSeparator: ''
		,anchor : '98%'
	});

	obj.ANCOTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOTypeStore = new Ext.data.Store({
      	proxy: obj.ANCOTypeStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'ID'   
      		}, 
      		[	
      			{name: 'ID', mapping: 'ID'}
      			,{name: 'OperStatus', mapping: 'OperStatus'}
      		])
      	});		
   obj.ANCOType =new Ext.form.ComboBox({
      	id : 'ANCOType'
      	,store : obj.ANCOTypeStore
      	,minChars : 0
      	,displayField : 'OperStatus'
      	,fieldLabel : '分类'
      	,labelSeparator: ''
      	,valueField : 'ID'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ANCOTypeStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANCCommonOrd';
      	param.QueryName = 'GetFlag';
      	param.ArgCnt = 0;
      	});
    obj.ANCOTypeStore.load();
    
    
    obj.ANCOArcimDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOArcimDrStore = new Ext.data.Store({
      	proxy: obj.ANCOArcimDrStoreProxy,
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
   obj.ANCOArcimDr =new Ext.form.ComboBox({
      	id : 'ANCOArcimDr'
      	,store : obj.ANCOArcimDrStore
      	,minChars : 0
      	,displayField : 'arcimDesc'
      	,fieldLabel : '医嘱名称'
      	,labelSeparator: ''
      	,valueField : 'arcimId'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ANCOArcimDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANCCommonOrd';
      	param.QueryName = 'GetMasterItem';
      	param.Arg1 = " ";
      	param.Arg2 = obj.ANCOArcimDr.getRawValue();
      	param.ArgCnt = 2;
      	});
     obj.ANCOArcimDrStore.load();
      	
       
       
    obj.ANCOViewCatDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOViewCatDrStore = new Ext.data.Store({
      	proxy: obj.ANCOViewCatDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'ANCEViewCatId'   
      		}, 
      		[	
      			{name: 'ANCEViewCatId', mapping: 'ANCEViewCatId'}
      			,{name: 'ANCEViewCat', mapping: 'ANCEViewCat'}
      		])
      	});		
   obj.ANCOViewCatDr =new Ext.form.ComboBox({
      	id : 'ANCOViewCatDr'
      	,store : obj.ANCOViewCatDrStore
      	,minChars : 0
      	,displayField : 'ANCEViewCat'
      	,fieldLabel : '显示分类'
      	,labelSeparator: ''
      	,valueField : 'ANCEViewCatId'
      	,multiSelect : true
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ANCOViewCatDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANCCommonOrd';
      	param.QueryName = 'FindANCEViewCat';
      	param.Arg1="";
      	param.ArgCnt = 1;
      	});
    obj.ANCOViewCatDrStore.load();
      	
	
    var data = [];
	obj.listANCOViewCatDrStoreProxy=data;
	obj.listANCOViewCatDrStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'listId'}
			,{name: 'listDesc'}
		])
	});
	obj.listANCOViewCatDrStore.load();
	obj.listANCOViewCatDr = new Ext.ListView({
	    id : 'listANCOViewCatDr'
		,store: obj.listANCOViewCatDrStore
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
    
    obj.ANCOUomDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOUomDrStore = new Ext.data.Store({
      	proxy: obj.ANCOUomDrStoreProxy,
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
   obj.ANCOUomDr =new Ext.form.ComboBox({
      	id : 'ANCOUomDr'
      	,store : obj.ANCOUomDrStore
      	,minChars : 0
      	,displayField : 'UomDesc'
      	,fieldLabel : '单位'
      	,labelSeparator: ''
      	,valueField : 'UomRowId'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ANCOUomDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANCCommonOrd';
      	param.QueryName = 'FindUom';
      	param.ArgCnt = 0;
      	});
    obj.ANCOUomDrStore.load();    
    
    obj.ANCOIconDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOIconDrStore = new Ext.data.Store({
      	proxy: obj.ANCOIconDrStoreProxy,
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
   obj.ANCOIconDr =new Ext.form.ComboBox({
      	id : 'ANCOIconDr'
      	,store : obj.ANCOIconDrStore
      	,minChars : 0
      	,displayField : 'IconDesc'
      	,fieldLabel : '图例'
      	,labelSeparator: ''
      	,valueField : 'IconRowId'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ANCOIconDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANCCommonOrd';
      	param.QueryName = 'FindIcon';
      	param.ArgCnt = 0;
      	});
    obj.ANCOIconDrStore.load();      	   
         	    	
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
	width:20,
	height:20,
	onFocus:function(){ 
	   var colorFieldId=this.id;
	   var colorWin=new Ext.Window({
	    border:false,
	    closeAction:'hide',
	    closable:false,
	    resizable:false,
	    width:155,
	    height:100,
	    items:[new Ext.ColorPalette({
	     listeners:{
	      'select':function(palette, selColor){  
		   Ext.getDom(colorFieldId).color=selColor;
	       Ext.getDom(colorFieldId).style.background="#"+selColor;      
	       colorWin.hide(); 
	      }
	     }
	    })]
	   });
	   colorWin.x=this.getPosition()[0]+this.width
	   colorWin.y=this.getPosition()[1]; 
	   colorWin.show();
	},
	afterRender :function(cf,position){   
	   Ext.form.TextField.superclass.afterRender.call(this,cf,position); 
	   Ext.getDom(this.id).style.background=this.color;
	},
	setColor:function(color){
	   if(!color)color="#FFFFFF";
	   Ext.getDom(this.id).color=color;
	   Ext.getDom(this.id).style.background="#"+color; 
	},
	getColor:function(){
	   return Ext.getDom(this.id).color; 
	}
	});
  Ext.reg('ColoField', Ext.form.TextField); 
  obj.ANCOColor=new Ext.ux.ColoField({
         id:'ANCOColor',
         color:'', //设置默认颜色
       labelSeparator:':', 
       anchor : '98%',
       fieldLabel:'颜色'
      ,labelSeparator: ''
   })
 
   	
   obj.ANCOAnApplyStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOAnApplyStore = new Ext.data.Store({
      	proxy: obj.ANCOAnApplyStoreProxy,
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
   obj.ANCOAnApply =new Ext.form.ComboBox({
      	id : 'ANCOAnApply'
      	,store : obj.ANCOAnApplyStore
      	,minChars : 0
      	,displayField : 'Desc'
      	,fieldLabel : 'An应用'
      	,labelSeparator: ''
      	,valueField : 'Id'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
   obj.ANCOAnApplyStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindICUCRIAnApply';
      	param.ArgCnt = 0;
      	});
   obj.ANCOAnApplyStore.load();
      	
    obj.ANCOIcuApplyStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOIcuApplyStore = new Ext.data.Store({
      	proxy: obj.ANCOIcuApplyStoreProxy,
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
   obj.ANCOIcuApply =new Ext.form.ComboBox({
      	id : 'ANCOIcuApply'
      	,store : obj.ANCOIcuApplyStore
      	,minChars : 0
      	,displayField : 'Desc'
      	,fieldLabel : 'Icu应用'
      	,labelSeparator: ''
      	,valueField : 'Id'
      	,editable : false
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
   obj.ANCOIcuApplyStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindICUCRIAnApply';
      	param.ArgCnt = 0;
      	});
    obj.ANCOIcuApplyStore.load();
      	
      	  
	obj.ANCOOptions = new Ext.form.TextField({
		id : 'ANCOOptions'
		,fieldLabel : '选项'
		,labelSeparator: ''
		,anchor : '98%'
	});
	
    obj.ANCOICUCIOIDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOICUCIOIDrStore = new Ext.data.Store({
      	proxy: obj.ANCOICUCIOIDrStoreProxy,
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
   obj.ANCOICUCIOIDr =new Ext.form.ComboBox({
      	id : 'ANCOICUCIOIDr'
      	,store : obj.ANCOICUCIOIDrStore
      	,minChars : 0
      	,displayField : 'itmDesc'
      	,fieldLabel : '观察项'
      	,labelSeparator: ''
      	,valueField : 'itmId'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ANCOICUCIOIDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCIOItem';
      	param.QueryName = 'FindICUCIOItemDesc';
      	param.ArgCnt = 0;
      	});
    obj.ANCOICUCIOIDrStore.load();
    
	obj.ANCOMultiValueDesc = new Ext.form.TextField({
		id : 'ANCOMultiValueDesc'
		,fieldLabel : '多数值名'
		,labelSeparator: ''
		,anchor : '98%'
	});
	
	obj.ANCOSortNo = new Ext.form.TextField({
		id : 'ANCOSortNo'
		,fieldLabel : '排序号'
		,labelSeparator: ''
		,anchor : '98%'
	});
  
    obj.ANCOArcosDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOArcosDrStore = new Ext.data.Store({
      	proxy: obj.ANCOArcosDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'arcosId'   
      		}, 
      		[	
      			{name: 'arcosId', mapping: 'arcosId'}
      			,{name: 'arcosDesc', mapping: 'arcosDesc'}
      		])
      	});		
   obj.ANCOArcosDr =new Ext.form.ComboBox({
      	id : 'ANCOArcosDr'
      	,store : obj.ANCOArcosDrStore
      	,minChars : 0
      	,displayField : 'arcosDesc'
      	,fieldLabel : '医嘱套'
      	,labelSeparator: ''
      	,valueField : 'arcosId'
      	,editable : false
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ANCOArcosDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANOrder';
      	param.QueryName = 'FindARCOrdSets';
      	param.ArgCnt = 0;
      	});
    obj.ANCOArcosDrStore.load();
      	
    obj.ANCODataTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCODataTypeStore = new Ext.data.Store({
      	proxy: obj.ANCODataTypeStoreProxy,
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
   obj.ANCODataType =new Ext.form.ComboBox({
      	id : 'ANCODataType'
      	,store : obj.ANCODataTypeStore
      	,minChars : 0
      	,displayField : 'tDesc'
      	,fieldLabel : '数据类型'
      	,labelSeparator: ''
      	,valueField : 'tCode'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ANCODataTypeStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCCLCom';
      	param.QueryName = 'LookUpComCode';
      	param.Arg1='DataType'
      	param.ArgCnt = 1;
      	});
    obj.ANCODataTypeStore.load(); 	
 

    obj.ANCOIsContinueStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOIsContinueStore = new Ext.data.Store({
      	proxy: obj.ANCOIsContinueStoreProxy,
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
   obj.ANCOIsContinue =new Ext.form.ComboBox({
      	id : 'ANCOIsContinue'
      	,store : obj.ANCOIsContinueStore
      	,minChars : 0
      	,displayField : 'Desc'
      	,fieldLabel : '是否继续'
      	,labelSeparator: ''
      	,valueField : 'Id'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
   obj.ANCOIsContinueStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCICUCRecordItem';
      	param.QueryName = 'FindICUCRIAnApply';
      	param.ArgCnt = 0;
      	});
   obj.ANCOIsContinueStore.load(); 

   obj.ANCOAnMethodDr = new Ext.form.TextField({
		id : 'ANCOAnMethodDr'
		//,hidden : true
		,fieldLabel : '麻醉方法指向'
		,labelSeparator: ''
		,anchor : '98%'
	});   
	  	   	     		
	obj.ANCOMax = new Ext.form.TextField({
		id : 'ANCOMax'
		,fieldLabel : '最大值'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.ANCOMin = new Ext.form.TextField({
		id : 'ANCOMin'
		,fieldLabel : '最小值'
		,labelSeparator: ''
		,anchor : '98%'
	});
    
    obj.ANCOImpossibleMax = new Ext.form.TextField({
		id : 'ANCOImpossibleMax'
		,fieldLabel : '极限值大'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.ANCOImpossibleMin = new Ext.form.TextField({
		id : 'ANCOImpossibleMin'
		,fieldLabel : '极限值小'
		,labelSeparator: ''
		,anchor : '98%'
	});
    
    obj.ANCOMainAncoDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOMainAncoDrStore = new Ext.data.Store({
      	proxy: obj.ANCOMainAncoDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'rowid'   
      		}, 
      		[	//ancodesc,ancoCode,rowid
      			{name: 'rowid', mapping: 'rowid'}
      			,{name: 'ancodesc', mapping: 'ancodesc'}
      			,{name: 'ancoCode', mapping: 'ancoCode'}
      		])
      	});		
   obj.ANCOMainAncoDr =new Ext.form.ComboBox({
      	id : 'ANCOMainAncoDr'
      	,store : obj.ANCOMainAncoDrStore
      	,minChars : 0
      	,displayField : 'ancodesc'
      	,fieldLabel : '主项'
      	,labelSeparator: ''
      	,valueField : 'rowid'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ANCOMainAncoDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANCCommonOrd';
      	param.QueryName = 'FindAncoMain';
      	//param.Arg1=obj.ANCOMainAncoDr.getRawValue();
      	param.Arg1="N";
      	param.Arg2="N";
      	param.ArgCnt = 2;
      	});
    obj.ANCOMainAncoDrStore.load();
      	
	obj.ANCODataFieldstoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
    
	obj.ANCODataFieldstore = new Ext.data.Store({
		proxy: obj.ANCODataFieldstoreProxy,
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
	obj.ANCODataField = new Ext.form.ComboBox({
		id : 'ANCODataField'
		,store:obj.ANCODataFieldstore
		,minChars:1	
		,displayField:'DataField'	
		,fieldLabel : '对应字段'
		,labelSeparator: ''
		,valueField : 'DataField'
		,triggerAction : 'all'
		,anchor : '98%'
		,editable : true
		,mode: 'local'
	}); 	
	
	obj.ANCODataFieldstoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCCommonOrd';
		param.QueryName = 'FindDataField';
		param.ArgCnt = 0;
	});
	obj.ANCODataFieldstore.load({});	
	
	obj.ANCODataFormat = new Ext.form.TextField({
		id : 'ANCODataFormat'
		,fieldLabel : '数据格式'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.ANCOFormatField = new Ext.form.TextField({
		id : 'ANCOFormatField'
		,fieldLabel : '格式字段'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.ANCOFormat = new Ext.form.TextField({
		id : 'ANCOFormat'
		,fieldLabel : '格式'
		,labelSeparator: ''
		,anchor : '98%'
	});
	obj.ANCORowId= new Ext.form.TextField({
			id : 'ANCORowId'
			,hidden : true
			,anchor : '98%'
		});
      	
      	
   obj.ANCOTemplateAncoDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOTemplateAncoDrStore = new Ext.data.Store({
      	proxy: obj.ANCOTemplateAncoDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'RowId'   
      		}, 
      		[	//ancodesc,ancoCode,rowid
      			{name: 'rowid', mapping: 'rowid'}
      			,{name: 'ancodesc', mapping: 'ancodesc'}
      			,{name: 'ancoCode', mapping: 'ancoCode'}
      		])
      	});		
   obj.ANCOTemplateAncoDr =new Ext.form.ComboBox({
      	id : 'ANCOTemplateAncoDr'
      	,store : obj.ANCOTemplateAncoDrStore
		,listeners:{
		    select:function(combo,record,index){
			    try{
                    obj.ANCOTemplateSubAncoDrStore.removeAll();
                    
                    obj.ANCOTemplateSubAncoDrStore.reload();

		           }
		        catch(ex)
		        {
			         Ext.MessageBox.alert("错误","数据加载失败。");

		        }
		}
		}
      	,minChars : 0
      	,displayField : 'ancodesc'
      	,fieldLabel : '模版'
      	,labelSeparator: ''
      	,valueField : 'rowid'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ANCOTemplateAncoDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANCCommonOrd';
      	param.QueryName = 'FindAncoMain';
      	//param.Arg1=obj.ANCOTemplateAncoDr.getRawValue();
      	param.Arg1="N";
      	param.Arg2="N";
      	param.ArgCnt = 2;
      	});
   obj.ANCOTemplateAncoDrStore.load();
 
    obj.ANCOTemplateSubAncoDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
      	url : ExtToolSetting.RunQueryPageURL
      	}));
   	obj.ANCOTemplateSubAncoDrStore = new Ext.data.Store({
      	proxy: obj.ANCOTemplateSubAncoDrStoreProxy,
      	reader: new Ext.data.JsonReader({
      		root: 'record',
      		totalProperty: 'total',
      		idProperty: 'rowid'   
      		}, 
      		[	//ancodesc,ancoCode,rowid
      			{name: 'rowid', mapping: 'rowid'}
      			,{name: 'ancodesc', mapping: 'ancodesc'}
      			,{name: 'ancoCode', mapping: 'ancoCode'}
      		])
      	});		
   obj.ANCOTemplateSubAncoDr =new Ext.form.ComboBox({
      	id : 'ANCOTemplateSubAncoDr'
      	,store : obj.ANCOTemplateSubAncoDrStore
      	,minChars : 0
      	,displayField : 'ancodesc'
      	,fieldLabel : '模版子项'
      	,labelSeparator: ''
      	,valueField : 'rowid'
      	,editable : true
      	,triggerAction : 'all'
      	,anchor : '98%'
              });	
    obj.ANCOTemplateSubAncoDrStoreProxy.on('beforeload', function(objProxy, param){
      	param.ClassName = 'web.DHCANCCommonOrd';
      	param.QueryName = 'FindSubAncoMain';
      	//param.Arg1=obj.ANCOTemplateSubAncoDr.getValue();
      	param.Arg1="";
      	param.Arg2="";
      	param.Arg3="N";
      	param.Arg4="N";
      	param.ArgCnt = 4;
      	});
    obj.ANCOTemplateSubAncoDrStore.load();
 
    var data = [];
	obj.listTempSubAncoDrStoreProxy=data;
	obj.listTempSubAncoDrStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(data),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'listId'}
			,{name: 'listDesc'}
		])
	});
	obj.listTempSubAncoDrStore.load();
	obj.listTempSubAncoDr = new Ext.ListView({
	    id : 'listTempSubAncoDr'
		,store: obj.listTempSubAncoDrStore
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
		    obj.listANCOViewCatDr
		]
	});	
	
    obj.listPanel2 = new Ext.Panel({
	    id : 'listPanel2'
	    //,width:100
	    //,anchor:'70%'
		,frame : true
		,items : [
		    obj.listTempSubAncoDr
		]
	});   
	obj.btnSch = new Ext.Button({
		id : 'btnSch'
		,iconCls : 'icon-find'
		,text : '查询'
	});
		obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,iconCls : 'icon-add'
		,text : '新增'
	});
		obj.btnUpd = new Ext.Button({
		id : 'btnUpd'
		,iconCls : 'icon-update'
		,text : '更新'
	});
		obj.btnDel = new Ext.Button({
		id : 'btnDel'
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	obj.schSubChildPl1 = new Ext.Panel({
		id : 'schSubChildPl1'
		,buttonAlign : 'center'
		,columnWidth : .5
		//,style:'margin-top:-10px;'
		,layout : 'form'
		,items:[
		obj.btnAdd
		]
		,buttons:[
			
		]
	});
	obj.schSubChildPl2 = new Ext.Panel({
		id : 'schSubChildPl2'
		,buttonAlign : 'center'
		,style:'margin-left:10px;'
		,columnWidth : .5
		,layout : 'form'
		,items:[
		obj.btnUpd
		]
		,buttons:[
			
		]
	});
	obj.Panelbutton1 = new Ext.Panel({
	    id : 'Panelbutton1'
		,buttonAlign : 'center'
		,style:'margin-left:15px;'
		,layout : 'column'
		,items : [
		    obj.schSubChildPl1
		    ,obj.schSubChildPl2
		]
	});   
	obj.schSubChildPl3 = new Ext.Panel({
		id : 'schSubChildPl3'
		,buttonAlign : 'center'
		,columnWidth : .5
		//,style:'margin-top:-10px'
		,layout : 'form'
		,items:[
		obj.btnSch
		]
		,buttons:[
			
		]
	});
	obj.schSubChildPl4 = new Ext.Panel({
		id : 'schSubChildPl4'
		,buttonAlign : 'center'
		//,style:'margin-top:-10px'
		,columnWidth : .5
		,layout : 'form'
		,items:[
		obj.btnDel
		]
		,buttons:[
			
		]
	});
	obj.Panelbutton2= new Ext.Panel({
	    id : 'Panelbutton2'
		,buttonAlign : 'center'
		,style:'margin-left:10px;'
		,layout : 'column'
		,items : [
		    obj.schSubChildPl3
		    ,obj.schSubChildPl4
		]
	});   				
    obj.Panel1 = new Ext.Panel({
		id : 'Panel1'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.ANCOCode
		,obj.ANCOType
		,obj.ANCOMax
		,obj.ANCOOptions
		,obj.ANCOUomDr
		,obj.ANCODataField
		//,obj.ANCOFormat
		]
	});
	obj.Panel2= new Ext.Panel({
		id : 'Panel2'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.ANCODesc
		,obj.ANCOICUCIOIDr 
		,obj.ANCOMin
		,obj.ANCOMainAncoDr
		,obj.ANCOIconDr
		,obj.ANCOColor
		]
	});
	obj.Panel3 = new Ext.Panel({
		id : 'Panel3'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.ANCODataType
		,obj.ANCODataFormat
		,obj.ANCOImpossibleMax
		,obj.ANCOMultiValueDesc
		,obj.ANCOSortNo
		,obj.Panelbutton1 
		]
	});
	obj.Panel4 = new Ext.Panel({
		id : 'Panel4'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.ANCOArcimDr
		//,obj.ANCODataField
		,obj.ANCOFormatField
		,obj.ANCOImpossibleMin
		,obj.ANCOArcosDr
		,obj.ANCOTemplateAncoDr
		,obj.Panelbutton2
		]
	});
	
	obj.Panel5= new Ext.Panel({
		id : 'Panel5'
		,buttonAlign : 'center'
		,columnWidth : .2
		,layout : 'form'
		,items:[
		obj.ANCOViewCatDr
		,obj.listPanel1
		,obj.ANCOTemplateSubAncoDr
		,obj.listPanel2
		,obj.ANCORowId
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
		,height:190
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
	
	
		obj.schSubChildPl5 = new Ext.Panel({
		id : 'schSubChildPl5'
		,buttonAlign : 'left'
		,columnWidth : .01
		,layout : 'form'
		,items:[
			//obj.btnSch 
		]
	});
	
	
	obj.schSubChildPl6 = new Ext.Panel({
		id : 'schSubChildPl6'
		,buttonAlign : 'left'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			//obj.textICUCRIAllApply
			   ]
	});
		obj.schSubChildPl7 = new Ext.Panel({
		id : 'schSubChildPl7'
		,buttonAlign : 'left'
		,columnWidth : .1
		,layout : 'form'
		,items:[
			//obj.textICUCRIANApply
			   ]
	});


	obj.chkFormPanel = new Ext.form.FormPanel({
		id : 'chkFormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,region : 'center'
		,layout : 'column'
		,items:[
			//obj.schSubChildPl1
			//obj.schSubChildPl2
			//,obj.schSubChildPl3
			obj.schSubChildPl5
			//,obj.schSubChildPl5
			,obj.schSubChildPl6
			,obj.schSubChildPl7
			]	
	});
    obj.CLCScoreOptionPanel = new Ext.Panel({
		id : 'CLCScoreOptionPanel'
		,buttonAlign : 'center'
		,height : 200
		,title : '常用医嘱'
		,iconCls : 'icon-manage'
		,region : 'north'
		,layout : 'border'
		,frame : true
		,collapsible:true
		,animate:true
		,items:[
		     obj.fPanel,
		     obj.chkFormPanel
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
			idProperty: 'rowid'   
		}, 
		[	
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'ComID', mapping: 'ComID'}
			,{name: 'ComDes', mapping: 'ComDes'}
			,{name: 'ComCatID', mapping: 'ComCatID'}
			,{name: 'ComCat', mapping: 'ComCat'}
			,{name: 'ComItmID', mapping: 'ComItmID'}
			,{name: 'ComItm', mapping: 'ComItm'}
			,{name: 'tANCEViewCat', mapping: 'tANCEViewCat'}
			,{name: 'tANCEViewCatId', mapping: 'tANCEViewCatId'}
			,{name: 'tUomRowId', mapping: 'tUomRowId'}
			,{name: 'tUomDesc', mapping: 'tUomDesc'}
			,{name: 'tIconRowId', mapping: 'tIconRowId'}
			,{name: 'tIconDesc', mapping: 'tIconDesc'}
			,{name: 'tColorDesc', mapping: 'tColorDesc'}
			,{name: 'tOptions', mapping: 'tOptions'}
			,{name: 'tItmDesc', mapping: 'tItmDesc'}
			,{name: 'tAncoMultiValueDesc', mapping: 'tAncoMultiValueDesc'}
			,{name: 'tItmId', mapping: 'tItmId'}
			,{name: 'tAncoSortNo', mapping: 'tAncoSortNo'}
			,{name: 'arcosId', mapping: 'arcosId'}
			,{name: 'tArcos', mapping: 'tArcos'}
			,{name: 'ancoDataType', mapping: 'ancoDataType'}
			,{name: 'tAncoDataTypeDesc', mapping: 'tAncoDataTypeDesc'}
			,{name: 'tAncoIsContinue', mapping: 'tAncoIsContinue'}
			,{name: 'tAncoAnMethodDr', mapping: 'tAncoAnMethodDr'}
			,{name: 'tAncoMax', mapping: 'tAncoMax'}
			,{name: 'tAncoMin', mapping: 'tAncoMin'}
			,{name: 'tANCOImpossibleMax', mapping: 'tANCOImpossibleMax'}
			,{name: 'tANCOImpossibleMin', mapping: 'tANCOImpossibleMin'}
			,{name: 'tANCOMainAncoDr', mapping: 'tANCOMainAncoDr'}
			,{name: 'tANCOMainAncodesc', mapping: 'tANCOMainAncodesc'}
			,{name: 'tANCODataField', mapping: 'tANCODataField'}
			,{name: 'tANCODataFormat', mapping: 'tANCODataFormat'}
			,{name: 'tANCOFormatField', mapping: 'tANCOFormatField'}
			,{name: 'tANCOTemplateAncoDrID', mapping: 'tANCOTemplateAncoDrID'}
			,{name: 'tANCOTemplateAncoDr', mapping: 'tANCOTemplateAncoDr'}
			,{name: 'ANCOTemplateSubAncoDrID', mapping: 'ANCOTemplateSubAncoDrID'}
			,{name: 'tANCOTemplateSubAncoDr', mapping: 'tANCOTemplateSubAncoDr'}
		])
	});		
	var cm = new Ext.grid.ColumnModel({
		defaults:
		{
			sortable: true            
		}
        ,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 100, dataIndex: 'ComID',sortable: true}
			,{header: '名称', width: 150, dataIndex: 'ComDes',sortable: true}
			,{header: '对应医嘱项', width: 150, dataIndex: 'ComItm', sortable: true}
			,{header: '项目分类', width: 100, dataIndex: 'ComCat', sortable: true}
			,{header: '显示分类', width: 150, dataIndex: 'tANCEViewCat', sortable: true}	
			,{header: 'tANCEViewCatId', width: 100, dataIndex: 'tANCEViewCatId', sortable: true}
			,{header: '行号', width: 50, dataIndex: 'rowid',sortable: true}
			,{header: '图例Id', width: 50, dataIndex: 'tIconRowId',sortable: true}
			,{header: '图例名称', width: 100, dataIndex: 'tIconDesc', sortable: true}
			,{header: '单位Id', width: 50, dataIndex: 'tUomRowId', sortable: true}
			,{header: '单位', width: 100, dataIndex: 'tUomDesc', sortable: true}	
			,{header: '颜色', width: 100, dataIndex: 'tColorDesc', sortable: true}
			,{header: '选项', width: 100, dataIndex: 'tOptions',sortable: true}
			,{header: '多数值名', width: 100, dataIndex: 'tAncoMultiValueDesc',sortable: true}
			,{header: 'tItmId', width: 50, dataIndex: 'tItmId', sortable: true}
			,{header: '观察项', width: 100, dataIndex: 'tItmDesc', sortable: true}
			,{header: '排序号', width: 100, dataIndex: 'tAncoSortNo', sortable: true}
			,{header: '医嘱套', width: 100, dataIndex: 'tArcos', sortable: true}	
			,{header: '数据类型', width: 100, dataIndex: 'tAncoDataTypeDesc', sortable: true}
			//,{header: '最大值', width: 100, dataIndex: 'tAncoMax', sortable: true}
			//,{header: '最小值', width: 100, dataIndex: 'tAncoMin', sortable: true}
			//,{header: '极限值大', width: 100, dataIndex: 'tANCOImpossibleMax', sortable: true}
			//,{header: '极限值小', width: 100, dataIndex: 'tANCOImpossibleMin', sortable: true}
			//,{header: '主项', width: 100, dataIndex: 'tANCOMainAncoDesc', sortable: true}
			//,{header: '数据格式', width: 100, dataIndex: 'tANCODataFormat', sortable: true}
			,{header: '对应字段', width: 100, dataIndex: 'tANCODataField', sortable: true}
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
			pageSize : 1000,
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
		param.ClassName = 'web.DHCANCCommonOrd';
		param.QueryName = 'FindANCCommonOrd';
		param.Arg1=obj.ANCODesc.getValue();
		param.Arg2=obj.ANCOViewCatDr.getValue();
		param.Arg3=obj.ANCOType.getRawValue();
		param.Arg4='N';
		param.Arg5='N';
		param.ArgCnt =5;
	});
	obj.retGridPanelStore.load({
	params : {
		start:0
		,limit:1000
	}});
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,items:[
			 
			 obj.resultPanel
			 ,obj.CLCScoreOptionPanel
		]
	});
	InitViewScreenEvent(obj);
	obj.retGridPanel.on("rowclick", obj.retGridPanel_rowclick, obj);
	obj.btnSch.on("click", obj.btnSch_click, obj);
	obj.btnDel.on("click", obj.btnDel_click, obj);
	obj.btnAdd.on("click", obj.btnAdd_click, obj);
	obj.btnUpd.on("click", obj.btnUpd_click, obj);
	obj.ANCOViewCatDr.on('select',obj.ANCOViewCatDr_select,obj);
	obj.listANCOViewCatDr.on('dblClick',obj.listANCOViewCatDr_dblClick,obj);
	obj.ANCOTemplateSubAncoDr.on('select',obj.ANCOTemplateSubAncoDr_select,obj);
	obj.listTempSubAncoDr.on('dblClick',obj.listTempSubAncoDr_dblClick,obj);
  	obj.LoadEvent(arguments);
	return obj;
}


