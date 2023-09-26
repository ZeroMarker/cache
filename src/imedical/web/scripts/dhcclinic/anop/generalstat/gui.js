function InitViewScreen(){
	Ext.QuickTips.init();
	var obj = new Object();

	obj.anciId = 0;
	obj.ifInquiry = 'N';
	obj.dateType = 'OP';
	obj.historySeq = "";
	obj.queryFilter = "";
	obj.pageSize = 50;
	obj.currentPageStart = 0;
	
	InitCommonQueryStore(obj);

	InitCommon(obj);

	obj.comOPRelateLocStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comOPRelateLocStore = new Ext.data.Store({
		proxy: obj.comOPRelateLocStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Id'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Desc', mapping: 'Desc'}
			,{name: 'Id', mapping: 'Id'}
		])
	});
	obj.comOPRelateLocStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCClinicCom';
		param.QueryName = 'FindLocListByType';
		param.ArgCnt = 0;
	});
	obj.comOPRelateLocStore.load({});

		//查询策略
	obj.comInquiryStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.comInquiryStore = new Ext.data.Store({
		proxy: obj.comInquiryStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'RowId'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'RowId', mapping: 'RowId'}
			,{name: 'ANCICode', mapping: 'ANCICode'}
			,{name: 'ANCIDesc', mapping: 'ANCIDesc'}
			,{name: 'ANCIDisplayDesc', mapping: 'ANCIDisplayDesc'}
			,{name: 'IfStartStoreTimeLine', mapping: 'IfStartStoreTimeLine'}
			,{name: 'ANCICtlocDr', mapping: 'ANCICtlocDr'}
			,{name: 'ANCICtloc', mapping: 'ANCICtloc'}
			,{name: 'ANCIStatus', mapping: 'ANCIStatus'}
			,{name: 'ANCIStatusDesc', mapping: 'ANCIStatusDesc'}
			,{name: 'ANCIType', mapping: 'ANCIType'}
			,{name: 'ANCITypeDesc', mapping: 'ANCITypeDesc'}
			,{name: 'ANCISearchLevel', mapping: 'ANCISearchLevel'}
			,{name: 'ANCIOpaCount', mapping: 'ANCIOpaCount'}
			,{name: 'ANCIResultCount', mapping: 'ANCIResultCount'}
			,{name: 'ANCIIsByDate', mapping: 'ANCIIsByDate'}
			,{name: 'ANCIDataType', mapping: 'ANCIDataType'}
			,{name: 'ANCIDataTypeDesc', mapping: 'ANCIDataTypeDesc'}
			,{name: 'ANCIDateTimeType', mapping: 'ANCIDateTimeType'}
			,{name: 'ANCIDateTimeTypeDesc', mapping: 'ANCIDateTimeTypeDesc'}
			,{name: 'ANCIUpdateUserDr', mapping: 'ANCIUpdateUserDr'}
			,{name: 'ANCIUpdateUser', mapping: 'ANCIUpdateUser'}
			,{name: 'ANCIUpdateDate', mapping: 'ANCIUpdateDate'}
			,{name: 'ANCIUpdateTime', mapping: 'ANCIUpdateTime'}
			,{name: 'ANCIIsActive', mapping: 'ANCIIsActive'}
		])
	});
	obj.comInquiry = new Ext.form.ComboBox({
		id : 'comInquiry'
		,store : obj.comInquiryStore
		,minChars : 1
		,displayField : 'ANCIDisplayDesc'
		,fieldLabel : '已保存策略'
		,valueField : 'RowId'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comInquiryStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANCInquiry';
		param.QueryName = 'FindANCInquiry';
		param.Arg1 = "";
		param.ArgCnt = 1;
	});
	obj.comInquiryStore.load({});
	obj.chkStartStoreTimeLine = new Ext.form.Checkbox({
		id : 'chkStartStoreTimeLine'
		,fieldLabel : '存储时间数据'
		,anchor : '95%'
	});
	obj.chkInquiryIsActive = new Ext.form.Checkbox({
		id : 'chkInquiryIsActive'
		,fieldLabel : '是否可用'
		,anchor : '95%'
		,checked : true
	});
	/*obj.comInquiryLoc = new Ext.form.ComboBox({
		id : 'comInquiryLoc'
		,store : obj.comOPRelateLocStore
		,minChars : 1
		,displayField : 'ctlocDesc'
		,fieldLabel : '策略可用科室'
		,valueField : 'ctlocId'
		,triggerAction : 'all'
		,anchor : '95%'
	});*/
	obj.comInquiryLoc = new Ext.ux.form.LovCombo({
		id:'comInquiryLoc'
		,fieldLabel : '策略可用科室'
      	,minChars : 1
		,displayField : 'Desc'
		,store : obj.comOPRelateLocStore
		,triggerAction : 'all'
		,hideTrigger:false
		,anchor : '95%'
		,valueField : 'Id'
		,mode: 'local'
		,grow:true
		,minListWidth : 200
		,lazyRender : true
		,hideOnSelect:false
		,autoHeight:true
		,queryInFields:true
		,selectOnFocus:false
		,queryFields:['Desc'] //这个数组是用来设定查询字段的。
		,renderer: function(value,metadata,record){
			var rv = value
		    var rva = rv.split(new RegExp(','+ ' *'));
		    var va = [];
		    var snapshot = this.store.snapshot || this.store.data;
		    Ext.each(rva, function(v) {
		      	var ex=0;
			    snapshot.each(function(r) {
					if(v == r.get(this.valueField))
					{
						va.push(r.get(this.displayField));
						ex=1;
				  	}
				});
				if(ex==0) va.push(v)
			});
	       	va.join(',');
          	return va;
        }
    });
	obj.txtInquiryCode = new Ext.form.TextField({
		id : 'txtInquiryCode'
		,fieldLabel : '策略代码'
		,anchor : '95%'
		,enableKeyEvents:true
		,minLength:0
		,maxLength:50 
	});
	obj.txtInquiryDesc = new Ext.form.TextField({
		id : 'txtInquiryDesc'
		,fieldLabel : '策略名称'
		,anchor : '95%'
		,enableKeyEvents:true
		,minLength:0
		,maxLength:50 
	});
	var booldata=[
		["Y","是"]
		,["N","否"]
	];
	obj.boolStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(booldata),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});

	var dataType=[
		["P","单个病人"]
		,["M","多个病人"]
		,["L","本科室手术"]
		,["S","统计"]
	];
	obj.dataTypeStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(dataType),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.dataTypeStore.load({});
	var anciType=[
		["A","所有"]
		,["L","科室"]
		,["U","用户"]
	];
	obj.anciTypeStoreProxy=anciType;
	obj.anciTypeStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(anciType),
		reader: new Ext.data.ArrayReader({}, 
		[
			{name: 'code'}
			,{name: 'desc'}
		])
	});
	obj.anciTypeStore.load({});
	obj.comANCIType = new Ext.form.ComboBox({
		id : 'comANCIType'
		,store : obj.anciTypeStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '策略权限类型'
		,valueField : 'code'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.comANCIDataType = new Ext.form.ComboBox({
		id : 'comANCIDataType'
		,store : obj.dataTypeStore 
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '策略查询类型'
		,valueField : 'code'
		,triggerAction : 'all'
		,anchor : '95%'
	});
	obj.txtInquiryStatus = new Ext.form.TextField({
		id : 'txtInquiryStatus'
		,fieldLabel : '策略查询状态'
		,anchor : '95%'
		,readOnly : true
		,enableKeyEvents:true
		,minLength:0
		,maxLength:10
	});
	obj.btnSaveInquiry = new Ext.Button({
		id : 'btnSaveInquiry'
		,iconCls : 'icon-save'
		,text : '保存查询策略'
	});
	obj.btnSaveInquiry.setTooltip("保存策略配置和策略项目配置!<br/><span style=\'color:red;\'>未勾选可用的策略将不在展示界面显示</span>");
	obj.btnComplexSch = new Ext.Button({
		id : 'btnComplexSch'
		,iconCls : 'icon-search'
		,text : '查询'
	});
	obj.btnComplexSch.setTooltip("可以通过设置开始结束日期改变筛选范围!");
	obj.selectInquiryColPanel = new Ext.Panel({
		id : 'selectInquiryColPanel'
		,buttonAlign : 'center'
		,columnWidth : .95
		,layout : 'form'
		,items : [
			obj.comInquiry
			,obj.chkInquiryIsActive
			,obj.txtInquiryCode
			,obj.txtInquiryDesc
			,obj.comANCIDataType
			,obj.comANCIType
			,obj.comInquiryLoc
			,obj.chkStartStoreTimeLine
			//,obj.txtInquiryStatus
		]
	});
	obj.selectInquiryPanel = new Ext.form.FormPanel({
		id : 'selectInquiryPanel'
		,buttonAlign : 'center'
		,labelWidth : 80
		,region : 'center'
		,labelAlign : 'right'
		,layout : 'column'
		,autoScroll : true
		,items : [
			obj.selectInquiryColPanel
		]
		,buttons:[
			obj.btnComplexSch
			,obj.btnSaveInquiry
		]
	});

	obj.inquiryToolMenu = new Ext.menu.Menu({
		items:[
		]
	});

	InitInquiryTool(obj);

	obj.complexSeachPanel = new Ext.Panel({
		id : 'complexSeachPanel'
		,buttonAlign : 'center'
		,title : '选择查询策略'
		,width :200
		,layout : 'border'
		,region : 'center'
		,frame :true
		,items:[
			obj.selectInquiryPanel
		]
		,tools:[
			{
				id:'gear',
				qtip:'策略工具',
				handler: function(event,toolEl,panel){
					obj.inquiryToolMenu.show(toolEl);
				}
			}
		]
	});
	//查询策略子项
	obj.summaryTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.summaryTypeStore = new Ext.data.Store({
		proxy: obj.summaryTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'   
		}, 
		[	
			{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.summaryTypeStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetSummaryType';
		param.ArgCnt =0;
	});
	obj.summaryTypeStore.load({});
	obj.inquiryStartDateTimeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.inquiryStartDateTimeStore = new Ext.data.Store({
		proxy: obj.inquiryStartDateTimeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'   
		}, 
		[	
			{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.inquiryStartDateTimeStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetInquiryStartDateTime';
		param.ArgCnt =0;
	});
	obj.inquiryStartDateTimeStore.load({});
	obj.inquiryItemTypeStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.inquiryItemTypeStore = new Ext.data.Store({
		proxy: obj.inquiryItemTypeStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'   
		}, 
		[	
			{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.inquiryItemTypeStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetInquiryItemType';
		param.ArgCnt =0;
	});
	obj.inquiryItemTypeStore.load({});
	obj.inquiryDataFieldStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.inquiryDataFieldStore = new Ext.data.Store({
		proxy: obj.inquiryDataFieldStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'   
		}, 
		[	
			{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
		])
	});
	obj.inquiryDataFieldStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetInquiryDataField';
		param.ArgCnt =0;
	});
	obj.inquiryDataFieldStore.load({});
	obj.ANCInquiryItemStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.ANCInquiryItemStore = new Ext.data.Store({
		proxy: obj.ANCInquiryItemStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'code'
		}, 
		[
			{name: 'code', mapping: 'code'}
			,{name: 'desc', mapping: 'desc'}
			,{name: 'type', mapping: 'type'}
			,{name: 'query', mapping: 'query'}
			,{name: 'displayField', mapping: 'displayField'}
			,{name: 'valueField', mapping: 'valueField'}
			,{name: 'valueOption', mapping: 'valueOption'}
			,{name: 'multiDelimiter', mapping: 'multiDelimiter'}
		])
	});
	obj.ANCInquiryItemStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetAllANCInquiryItem';
		param.ArgCnt = 0;
	});
	obj.InquiryTypeItem = new Object();
	obj.InquiryEmptyTypeItem = new Array();
	obj.ANCInquiryItemStore.load({});
	obj.btnAddInquiryItem = new Ext.Button({
		id : 'btnAddInquiryItem'
		,iconCls : 'icon-add'
		,text : '添加查询项目'
	});
	obj.btnAddInquiryItem.setTooltip("添加一行到策略项目数据表格中!");
	obj.btnDeleteInquiryItem = new Ext.Button({
		id : 'btnDeleteInquiryItem'
		,iconCls : 'icon-delete'
		,text : '删除选中行'
	});
	obj.btnDeleteInquiryItem.setTooltip("删除已保存的数据后将不能恢复!");
	obj.InquiryItemGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.InquiryItemGridStore = new Ext.data.Store({
		proxy: obj.InquiryItemGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'anciiId'
		}, 
		[
			{name: 'anciiId', mapping: 'anciiId'}
			,{name: 'anciiSub', mapping: 'anciiSub'}
			,{name: 'anciiRelateAnciiSub', mapping: 'anciiRelateAnciiSub'}
			,{name: 'anciiCode', mapping: 'anciiCode'}
			,{name: 'anciiDesc', mapping: 'anciiDesc'}
			,{name: 'anciiType', mapping: 'anciiType'}
			,{name: 'anciiIsSearch', mapping: 'anciiIsSearch'}
			,{name: 'anciiIsDisplay', mapping: 'anciiIsDisplay'}
			,{name: 'anciiIsSingle', mapping: 'anciiIsSingle'}
			,{name: 'anciiMinQty', mapping: 'anciiMinQty'}
			,{name: 'anciiMaxQty', mapping: 'anciiMaxQty'}
			,{name: 'anciiNote', mapping: 'anciiNote'}
			,{name: 'anciiMultiple', mapping: 'anciiMultiple'}
			,{name: 'anciiMultipleDesc', mapping: 'anciiMultipleDesc'}
			,{name: 'anciiStartDateTime', mapping: 'anciiStartDateTime'}
			,{name: 'anciiDurationHour', mapping: 'anciiDurationHour'}
			,{name: 'anciiRefValue', mapping: 'anciiRefValue'}
			,{name: 'anciiRefAncoId', mapping: 'anciiRefAncoId'}
			,{name: 'anciiRefAncoDesc', mapping: 'anciiRefAncoDesc'}
			,{name: 'anciiDataField', mapping: 'anciiDataField'}
			,{name: 'anciiOeoriNote', mapping: 'anciiOeoriNote'}
			,{name: 'anciiFromTime', mapping: 'anciiFromTime'}
			,{name: 'anciiToTime', mapping: 'anciiToTime'}
			,{name: 'anciiExactTime', mapping: 'anciiExactTime'}
			,{name: 'anciiSeqNo', mapping: 'anciiSeqNo'}
			,{name: 'anciiLevel', mapping: 'anciiLevel'}
			,{name: 'anciiFromAncoId', mapping: 'anciiFromAncoId'}
			,{name: 'anciiToAncoId', mapping: 'anciiToAncoId'}
			,{name: 'anciiSummaryType', mapping: 'anciiSummaryType'}
			,{name: 'anciiDurationInterval', mapping: 'anciiDurationInterval'}
			,{name: 'multiDelimiter', mapping: 'multiDelimiter'}
			,{name: 'anciiColumnWidth', mapping: 'anciiColumnWidth'}
			,{name: 'anciiIsResultSearch', mapping: 'anciiIsResultSearch'}
			,{name: 'anciiFromDate',mapping: 'anciiFromDate'}
			,{name: 'anciiToDate',mapping: 'anciiToDate'}
			,{name: 'anciiIsNegative', mapping: 'anciiIsNegative'}
		])
	});
	obj.InquiryItemGridStoreProxy.on('beforeload',function(objProxy, param){
		param.ClassName = 'web.DHCANOPStat';
		param.QueryName = 'GetANCISearchItems';
		param.Arg1=obj.anciId;
		param.ArgCnt =1;
	});
	obj.InquiryItemRecord = new Ext.data.Record.create([ 
		{name: 'anciiId',type:'string'}
		,{name: 'anciiSub',type:'string'}
		,{name: 'anciiRelateAnciiSub',type:'string'}
		,{name: 'anciiCode',type:'string'}
		,{name: 'anciiDesc',type:'string'}
		,{name: 'anciiType',type:'string'}
		,{name: 'anciiIsSearch',type:'bool'}
		,{name: 'anciiIsDisplay',type:'bool'}
		,{name: 'anciiIsSingle',type:'bool'}
		,{name: 'anciiMinQty',type:'string'}
		,{name: 'anciiMaxQty',type:'string'}
		,{name: 'anciiNote',type:'string'}
		,{name: 'anciiMultiple',type:'string'}
		,{name: 'anciiMultipleDesc',type:'string'}
		,{name: 'anciiStartDateTime',type:'string'}
		,{name: 'anciiDurationHour',type:'string'}
		,{name: 'anciiRefValue',type:'string'}
		,{name: 'anciiRefAncoId',type:'string'}
		,{name: 'anciiRefAncoDesc',type:'string'}
		,{name: 'anciiDataField',type:'string'}
		,{name: 'anciiOeoriNote',type:'string'}
		,{name: 'anciiFromTime',type:'string'}
		,{name: 'anciiToTime',type:'string'}
		,{name: 'anciiExactTime',type:'string'}
		,{name: 'anciiSeqNo',type:'string'}
		,{name: 'anciiLevel',type:'string'}
		,{name: 'anciiFromAncoId',type:'string'}
		,{name: 'anciiToAncoId',type:'string'}
		,{name: 'anciiSummaryType',type:'string'}
		,{name: 'anciiDurationInterval',type:'string'}
		,{name: 'multiDelimiter',type:'string'}
		,{name: 'anciiColumnWidth',type:'string'}
		,{name: 'anciiIsResultSearch',type:'bool'}
		,{name: 'anciiFromDate',type:'string'}
		,{name: 'anciiToDate',type:'string'}
		,{name: 'anciiIsNegative',type:'bool'}
	]); 
	obj.comRelateAnciiData = []; 
	obj.comRelateAnciiStore = new Ext.data.Store({
		proxy: new Ext.data.MemoryProxy(obj.comRelateAnciiData),
		reader: new Ext.data.ArrayReader({},
		[
			{name: 'value'}
		])

	});
	obj.isSearchCheckCol = new Ext.grid.CheckColumn({
		header:'条件项', 
		dataIndex: 'anciiIsSearch', 
		width: 60,
		tooltip:'条件项勾选后将作为查询条件对手术进行筛选'
	});
	obj.isDisplayCheckCol = new Ext.grid.CheckColumn({
		header:'结果项', 
		dataIndex: 'anciiIsDisplay', 
		width: 60,
		tooltip:'显示结果项，在统计策略中将作为行生成的参数'
	});
	obj.isResultSearchCheckCol = new Ext.grid.CheckColumn({
		header:'结果二次筛选项', 
		dataIndex: 'anciiIsResultSearch', 
		width: 60,
		tooltip:'结果二次筛选项勾选后将作为查询条件或显示结果序列的值'
	});
	obj.isSingleCheckCol = new Ext.grid.CheckColumn({
		header:'返回单条数据', 
		dataIndex: 'anciiIsSingle', 
		width: 60,
		tooltip:'当查询项目有多个值时，匹配到一个满足条件的马上返回'
	});
	obj.isNegativeCheckCol = new Ext.grid.CheckColumn({
		header:'反向匹配', 
		dataIndex: 'anciiIsNegative', 
		width: 60,
		tooltip:'相当于逻辑非'
	});
	obj.InquiryItemGridCM = new Ext.grid.ColumnModel({
        columns: [
			new Ext.grid.RowNumberer()
			,{
				header: 'ID'
				,width: 40
				,dataIndex: 'anciiSub'
				,sortable: false
        	}
			,{
				header: '关联'
				,width: 40
				,dataIndex: 'anciiRelateAnciiSub'
				,sortable: false
				,editor: new Ext.form.ComboBox({
		      		minChars : 1
					,store : obj.comRelateAnciiStore
			    	,triggerAction : 'all'
					,anchor : '95%'
					,displayField : 'value'
					,valueField : 'value'
					,mode: 'local'
					//,lazyRender : true
					,forceSelection : true
					,editable : true
					,selectOnFocus:true
					,resizable:false 
                })
				,tooltip:'<span style=\'color:red;\'>关联将生成一个树形的查询结构，关联项条件未满足时直接跳出</span>'
        	}
			,{
				header: '类型'
				,width: 100
				,dataIndex: 'anciiType'
				,sortable: false
				,editor: new Ext.form.ComboBox({
		      		minChars : 1
					,displayField : 'desc'
					,store : obj.inquiryItemTypeStore
			    	,triggerAction : 'all'
					,anchor : '95%'
					,valueField : 'code'
					,mode: 'local'
					,lazyRender : true
					//,typeAhead: true
					,forceSelection : false
					,selectOnFocus:true
					,resizable:false 
                })
          		,renderer: function(value,metadata,record){
					var index = obj.inquiryItemTypeStore.find('code',value);
					if(index==-1) index = obj.inquiryItemTypeStore.find('desc',value);
					if(index!=-1)
					{
						try{
							return obj.inquiryItemTypeStore.getAt(index).data.desc;
						}
						catch(ex){}
					}
					return value;	
				}
				,tooltip:'<span style=\'color:red;\'>查询项目的类型，为空的项目将不会有筛选结果</span>'
        	}
			,{
				header: '<span style=\'color:red;\'>查询项</span>'
				,width: 80
				,dataIndex: 'anciiDesc'
				,sortable: false
				,editor: new Ext.form.ComboBox({
		      		minChars : 1
					,displayField : 'desc'
					,store : obj.ANCInquiryItemStore
			    	,triggerAction : 'all'
					,anchor : '95%'
					,valueField : 'desc'
					,minListWidth : 300
					,listClass:'list-anop_select'
					//,pageSize : obj.pageSize
					,mode: 'local'
					,lazyRender : true
					//,typeAhead: true
					,forceSelection : false
					,selectOnFocus:true
					,resizable:false 
                })
          		,renderer: function(value,metadata,record){
					var index = obj.ANCInquiryItemStore.find('code',value);
					if(index==-1) index = obj.ANCInquiryItemStore.find('desc',new RegExp("^"+value.replace("(","\\(").replace(")","\\)")+"$"));
					if(index!=-1)
					{
						try{
							return obj.ANCInquiryItemStore.getAt(index).data.desc;
						}
						catch(ex){}
					}
					return value;	
				}
				,tooltip:'查询项目的名称，通过选择会自动填入项目代码和类型，名称可自行修改(列名现在不由查询项名生成,可不修改)<br/><span style=\'color:red;\'>请先选择之后再修改名称，否则不能自动带入代码!<br/><span style=\'font-weight:bold;\'>不能为空</span></span>'
        	}
			,{
				header: '列名'
				,width: 100
				,dataIndex: 'anciiNote'
				,sortable: false
				,editor: new Ext.form.TextField({
					anchor : '95%'
					,enableKeyEvents:true
					,minLength:0
					,maxLength:50
                })
				,tooltip:'结果中显示列名，无则使用查询项名称代替'
        	}
			,obj.isSearchCheckCol
			,obj.isDisplayCheckCol
			,obj.isResultSearchCheckCol
			,{	header: '<span style=\'color:red;\'>筛选层</span>'
				, width: 40
				, dataIndex: 'anciiLevel'
				,editor: new Ext.form.TextField({
					anchor : '95%'
					,enableKeyEvents:true
					,minLength:0
					,maxLength:3
                })
				,tooltip:'<span style=\'color:red;\'>在统计策略中筛选层是列的标识，相同筛选层对应一列<br/>条件项的筛选层<span style=\'font-weight:bold;\'>不能重复</span></span>'
			}
			,{
				header: '计算公式'
				,width: 80
				,dataIndex: 'anciiRefValue'
				,editor: new Ext.form.TextField({
						anchor : '95%'
						,enableKeyEvents:true
						,minLength:0
						,maxLength:100
					})
				,tooltip:'格式:{1}*({2}+{3}-{4})/{5}<br/><span style=\'color:red;\'>统计</span>类型:{}中的序号是<span style=\'color:red;\'>筛选层</span><br/><span style=\'color:red;\'>其他</span>类型:{}中的序号是<span style=\'color:red;\'>ID</span>'
			}
			,{	header: '排序号'
				,width: 40
				,dataIndex: 'anciiSeqNo'
				,editor: new Ext.form.NumberField({
					anchor : '95%'
					,enableKeyEvents:true
					,allowNegative:false
					,decimalPrecision:0
					,minValue:0
					,maxLength:5
                })
			}
			,{
				header: '<span style=\'color:red;\'>代码</span>'
				,width: 80
				,dataIndex: 'anciiCode'
				,sortable: false
				,editor: new Ext.form.TextField({
					anchor : '95%'
					,enableKeyEvents:true
					,minLength:0
					,maxLength:50
                })
				,tooltip:'<span style=\'color:red;\'>后台查询数据的标识，如果有错误将不能获取正确数据<span style=\'font-weight:bold;\'>不能为空</span></span>'
        	}
			,{
				header: '汇总类型'
				,width: 140
				,dataIndex: 'anciiSummaryType'
				,sortable: false
				,editor: new Ext.ux.form.LovCombo({
					minChars : 1
					,displayField : 'desc'
					,store : obj.summaryTypeStore
					,triggerAction : 'all'
					,hideTrigger:false
					,anchor : '95%'
					,minListWidth : 200
					,valueField : 'code'
					,mode: 'local'
					,grow:true
					,lazyRender : true
					,hideOnSelect:false
				    ,autoHeight:true
				    ,queryInFields:true
				    ,selectOnFocus:false
				    ,queryFields:['desc','code'] //这个数组是用来设定查询字段的。
				})
				,renderer: function(value,metadata,record){
				  metadata.attr = 'style="white-space:normal;"';
				  var va = [];
				  try
				  {
					var rv = value
					var rva = rv.split(new RegExp(','+ ' *'));
					var snapshot = obj.summaryTypeStore.snapshot || obj.summaryTypeStore.data;
					Ext.each(rva, function(v) {
						var ex=0;
						snapshot.each(function(r) {
						  if(v === r.get('code')) {
							va.push(r.get('desc'));
							ex=1;
						  }
						  })
						  if(ex==0)
						  {
							va.push(v)
						  }
						 })
				  }
				  catch(exception)
				  {
					
				  }
				  va.join(',');
				  return va;
				}
				,tooltip:'<span style=\'color:red;\'>统计数据的类型，可以多选</span>'				
        	}
			,{
				header: '选择多选值'
				, width: 150
				, dataIndex: 'anciiMultipleDesc'
				, sortable: true
				,editor: new Ext.ux.form.LovCombo({
					minChars : 1
					,displayField : 'desc'
					,store : obj.refCommonQueryStore
					,triggerAction : 'all'
					,hideTrigger:false
					,anchor : '95%'
					,valueField : 'value'
					,mode: 'local'
					,pageSize : obj.pageSize
					,minListWidth : 400
					,grow:true
					,lazyRender : true
					,hideOnSelect:false
				    ,autoHeight:true
				    ,queryInFields:true
				    ,selectOnFocus:false
				    ,queryFields:['desc','value'] //这个数组是用来设定查询字段的。
				})
				,renderer: function(value,metadata,record){
				  metadata.attr = 'style="white-space:normal;"';
				  var va = [];
				  try
				  {
					var rv = value
					var rva = rv.split(new RegExp(','+ ' *'));
					var snapshot = obj.refCommonQueryStore.snapshot || obj.refCommonQueryStore.data;
					Ext.each(rva, function(v) {
						var ex=0;
						snapshot.each(function(r) {
						  if(v === r.get('value')) {
							va.push(r.get('desc'));
							ex=1;
						  }
						  })
						  if(ex==0)
						  {
							va.push(v)
						  }
						 })
				  }
				  catch(exception)
				  {
					
				  }
				  va.join(',');
				  return va;
				}
				,tooltip:'<span>多选值可以通过这里选择生成</span>'
			}
			,{
				header: '多选值'
				, width: 80
				, dataIndex: 'anciiMultiple'
				,editor: new Ext.form.TextField({
						anchor : '95%'
						,enableKeyEvents:true
						,minLength:0
						,maxLength:500
					})
				,tooltip:'<span style=\'color:red;\'>进行值匹配的重要参数,<br/>所有条件都不填表示对应项目的值不为空即可</span>'
			}
			,obj.isSingleCheckCol
			//,obj.isNegativeCheckCol
			,{
				header: '最大值'
				,width: 60
				,dataIndex: 'anciiMaxQty'
				,sortable: false
				,editor: new Ext.form.NumberField({
					anchor : '95%'
					,enableKeyEvents:true
					,decimalPrecision:2
					,allowNegative:true
                })
				,tooltip:'<span style=\'color:red;\'>数值项目值≤最大值</span>'
        	}
			,{
				header: '最小值'
				,width: 60
				,dataIndex: 'anciiMinQty'
				,sortable: false
				,editor: new Ext.form.NumberField({
					anchor : '95%'
					,enableKeyEvents:true
					,decimalPrecision:2
					,allowNegative:true
                })
				,tooltip:'<span style=\'color:red;\'>数值项目值≥最小值</span>'
        	}
			,{
				header: '字段'
				,width: 80
				,dataIndex: 'anciiDataField'
				,sortable: false
				,editor: new Ext.form.ComboBox({
		      		minChars : 1
					,displayField : 'desc'
					,store : obj.inquiryDataFieldStore
			    	,triggerAction : 'all'
					,anchor : '95%'
					,valueField : 'code'
					,mode: 'local'
					,lazyRender : true
					//,typeAhead: true
					,forceSelection : false
					,selectOnFocus:true
					,resizable:false 
                })
          		,renderer: function(value,metadata,record){
					var index = obj.inquiryDataFieldStore.find('code',value);
					if(index==-1) index = obj.inquiryDataFieldStore.find('desc',value);
					if(index!=-1)
					{
						try
						{
							return obj.inquiryDataFieldStore.getAt(index).data.desc;
						}
						catch(ex)
						{
						}
					}
					return value;	
				}
				,tooltip:'<span style=\'color:red;\'>项目数据的对应属性分类，相同项目匹配不同值时在此设置</span>'
        	}
			,{
				header: '医嘱备注'
				,width: 60
				,dataIndex: 'anciiOeoriNote'
				,sortable: false
				,editor: new Ext.form.TextField({
					anchor : '95%'
					,enableKeyEvents:true
					,minLength:0
					,maxLength:20
                })
        	}
			,{
				header: '开始日期时间(手术相关)'
				,width: 80
				,dataIndex: 'anciiStartDateTime'
				,sortable: false
				,editor: new Ext.form.ComboBox({
		      		minChars : 1
					,displayField : 'desc'
					,store : obj.inquiryStartDateTimeStore
			    	,triggerAction : 'all'
					,anchor : '95%'
					,valueField : 'code'
					,mode: 'local'
					,lazyRender : true
					//,typeAhead: true
					,forceSelection : false
					,selectOnFocus:true
					,resizable:false 
                })
          		,renderer: function(value,metadata,record){
					var index = obj.inquiryStartDateTimeStore.find('code',value);
					if(index==-1) index = obj.inquiryStartDateTimeStore.find('desc',value);
					if(index!=-1)
					{
						try
						{
							return obj.inquiryStartDateTimeStore.getAt(index).data.desc;
						}
						catch(ex)
						{
						}
					}
					return value;	
				}
				,tooltip:'<span style=\'color:red;\'>手术麻醉关键时间点，用以生成基准开始结束时间，将根据关键时间点来限制查询对应数据的时间属性值</span>'
        	}
			,{
				header: '持续小时'
				,width: 60
				,dataIndex: 'anciiDurationHour'
				,sortable: false
				,editor: new Ext.form.NumberField({
					anchor : '95%'
					,enableKeyEvents:true
					,decimalPrecision:0
					,allowNegative:true
                })
				,tooltip:'<span style=\'color:red;\'>与手术麻醉关键时间点一起生成基准时间范围，为正值则之和为基准结束时间，为负值则之和为基准开始时间</span>'
        	}
			,{
				header: '开始日期'
				,width: 100
				,dataIndex: 'anciiFromDate'
				,sortable: false
				,editor: new Ext.form.DateField({
					format:'Y-m-d'
				})
				,tooltip:'<span style=\'color:red;\'>确切的开始日期，用于日期时间匹配</span>'
        	}
			,{
				header: '开始时间'
				,width: 60
				,dataIndex: 'anciiFromTime'
				,sortable: false
				,editor: new Ext.form.TimeField({
					format:'H:i'
					,increment: 30
				})
				,tooltip:'<span style=\'color:red;\'>基准开始时间与此时间之和将作为数据查询的开始时间</span>'
        	}
			,{
				header: '结束日期'
				,width: 100
				,dataIndex: 'anciiToDate'
				,sortable: false
				,editor: new Ext.form.DateField({
					format:'Y-m-d'
				})
				,tooltip:'<span style=\'color:red;\'>确切的结束日期，用于日期时间匹配</span>'
        	}
			,{
				header: '结束时间'
				,width: 60
				,dataIndex: 'anciiToTime'
				,sortable: false
				,editor: new Ext.form.TimeField({
					format:'H:i'
					,increment: 30
				})
				,tooltip:'<span style=\'color:red;\'>基准结束时间与此时间之和将作为数据查询的结束时间</span>'
        	}
			,{
				header: '准确时间'
				,width: 60
				,dataIndex: 'anciiExactTime'
				,sortable: false
				,editor: new Ext.form.TimeField({
					format:'H:i'
					,increment: 30
				})
				,tooltip:'<span style=\'color:red;\'>基准开始时间与此时间之和将作为数据查询的准确时间</span>'
        	}
			,{
				header: '参考常用医嘱ID'
				,width: 60
				,dataIndex: 'anciiRefAncoId'
				,sortable: false
				,editor: new Ext.form.TextField({
					anchor : '95%'
					,enableKeyEvents:true
					,minLength:0
					,maxLength:20
                })
				,tooltip:'<span style=\'color:red;\'>麻醉监护数据基础项目Id</span>'
        	}
			,{
				header: '起始常用医嘱ID'
				,width: 60
				,dataIndex: 'anciiFromAncoId'
				,sortable: false
				,editor: new Ext.form.TextField({
					anchor : '95%'
					,enableKeyEvents:true
					,minLength:0
					,maxLength:20
                })
				,tooltip:'<span style=\'color:red;\'>麻醉监护数据基础项目Id起始值</span>'
        	}
			,{
				header: '终止常用医嘱ID'
				,width: 60
				,dataIndex: 'anciiToAncoId'
				,sortable: false
				,editor: new Ext.form.TextField({
					anchor : '95%'
					,enableKeyEvents:true
					,minLength:0
					,maxLength:20
                })
				,tooltip:'<span style=\'color:red;\'>麻醉监护数据基础项目Id结束值</span>'
        	}
			,{
				header: '时间间隔'
				,width: 60
				,dataIndex: 'anciiDurationInterval'
				,sortable: false
				,editor: new Ext.form.TextField({
					anchor : '95%'
					,enableKeyEvents:true
					,minLength:0
					,maxLength:20
                })
        	}
			,{	header: '列宽'
				,width: 60
				,dataIndex: 'anciiColumnWidth'
				,editor: new Ext.form.NumberField({
					anchor : '95%'
					,enableKeyEvents:true
					,allowNegative:false
					,decimalPrecision:0
					,minValue:0
					,maxLength:3
                })
				,tooltip:'<span>设置结果中显示列初始宽度</span>'
			}
		]
	})
	obj.InquiryItemGridPanel = new Ext.grid.EditorGridPanel({
		id : 'InquiryItemGridPanel'
		,store : obj.InquiryItemGridStore
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true}) //设置为单行选中模式
		,clicksToEdit:1    //单击编辑
		,loadMask : true
		,columnLines : true
		,region : 'center'
		,buttonAlign : 'center'
		,cm:obj.InquiryItemGridCM
		,viewConfig:
		{
			forceFit: false
		}
		,plugins :[obj.isSearchCheckCol,obj.isDisplayCheckCol,obj.isSingleCheckCol,obj.isResultSearchCheckCol,obj.isNegativeCheckCol]
	});
	obj.InquiryItemPanel = new Ext.Panel({
		id : 'InquiryItemPanel'
		,buttonAlign : 'center'
		,title : '查询项目'
		,height : 340
		,region : 'south'
		,layout : 'border'
		,frame : true
		,items : [
			obj.InquiryItemGridPanel
		]
		,buttons:[
			obj.btnAddInquiryItem
			,obj.btnDeleteInquiryItem
		]
	});
	//查询结果
	
	InitResultGridPanel(obj);

	obj.schPanel = new Ext.Panel({
		id : 'schPanel'
		,width : 300
		,title : '手术综合查询'
		,region : 'west'
		,layout : 'border'
		,collapsible:true
		,animate:true
		,defaults: {
            split: true
        }
		,items:[
			obj.SeachDatePanel
			,obj.complexSeachPanel
			,obj.InquiryItemPanel
		]
	});
	obj.resultPanel = new Ext.Panel({
		id : 'resultPanel'
		,title : '手术查询结果'
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
			obj.retGridPanel
		]
	});
	obj.ViewScreen = new Ext.Viewport({
		id : 'ViewScreen'
		,layout : 'border'
		,defaults: {
            split: true
			,collapsible: true
        }
		,items:[
			obj.schPanel
			,obj.resultPanel
		]
	});

	InitViewScreenEvent(obj);

	InitSortItemWindow(obj);

	InitOpaInfoWindow(obj);

	obj.btnSaveInquiry.on('click',obj.btnSaveInquiry_click,obj);
	obj.btnAddInquiryItem.on('click',obj.btnAddInquiryItem_click,obj);
	obj.comInquiry.on('select',obj.comInquiry_select,obj);
	obj.comInquiry.on('blur',obj.comInquiry_blur,obj);
	obj.btnComplexSch.on('click',obj.btnComplexSch_click,obj);
	obj.btnDeleteInquiryItem.on('click',obj.btnDeleteInquiryItem_click,obj);
	obj.InquiryItemGridStore.on('load',obj.InquiryItemGridStore_load,obj);
	obj.InquiryItemGridPanel.on("rowclick", obj.InquiryItemGridPanel_rowclick, obj);
	obj.InquiryItemGridPanel.on("beforeedit",obj.InquiryItemGridPanel_beforeedit,obj);
	obj.InquiryItemGridPanel.on("validateedit",obj.InquiryItemGridPanel_validateedit,obj);
	obj.InquiryItemGridPanel.on("afteredit",obj.InquiryItemGridPanel_afteredit,obj);
	obj.ANCInquiryItemStore.on("load",obj.ANCInquiryItemStore_load,obj);
	obj.LoadEvent(arguments);
	return obj;
}