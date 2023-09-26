var objScreen = new Object();
function InitviewScreen(){
	var obj = objScreen;
	//输出配置查询参数
	obj.gridOutCol_QryArg_Mode='';
	obj.gridOutCol_QryArg_CondfigID='';
	obj.gridOutCol_QryArg_DataType='';
	obj.gridOutCol_QryArg_argID='';
	obj.cboDateType = Common_ComboToDic("cboDateType","日期类型<font color='red'>*</font>","FPQryDateType");
	obj.dtFromDate = Common_DateFieldToDate("dtFromDate","开始日期<font color='red'>*</font>");
	obj.dtToDate = Common_DateFieldToDate("dtToDate","结束日期<font color='red'>*</font>");
	obj.cboLogical = Common_ComboToDic("cboLogical","逻辑关系<font color='red'>*</font>","LogicalRealation");
	obj.cboOperCode = Common_ComboToDic("cboOperCode","操作符<font color='red'>*</font>","CompareCode");
	obj.txtCompValue = Common_TextField("txtCompValue","比较值<font color='red'>*</font>");
	
	//查询条件
	obj.gridInputCondStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridInputCondStore = new Ext.data.Store({
		proxy: obj.gridInputCondStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},[
			{name: 'ID', mapping : 'ID'}
			,{name: 'IsChecked', mapping : 'IsChecked'}
			,{name: 'LogicalID', mapping : 'LogicalID'}
			,{name: 'LogicalDesc', mapping : 'LogicalDesc'}
			,{name: 'QryType', mapping : 'QryType'}
			,{name: 'QryID', mapping : 'QryID'}
			,{name: 'QryDesc', mapping : 'QryDesc'}
			,{name: 'OperID', mapping : 'OperID'}
			,{name: 'OperDesc', mapping : 'OperDesc'}
			,{name: 'CompVal', mapping : 'CompVal'}
		])
	});
	obj.gridInputCond = new Ext.grid.GridPanel({
		id : 'gridInputCond'
		,height : 200
		,store : obj.gridInputCondStore
		,buttonAlign : 'center'
		,columns: [
			{header: '选择', width: 60, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get('IsChecked');
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '逻辑', width: 60, dataIndex: 'LogicalDesc', sortable: true, menuDisabled:true, align: 'center'}
			,{header: '条件描述', width: 200, dataIndex: '', sortable: true, menuDisabled:true, align: 'left',
				renderer : function(v, m, rd, r, c, s) {
					m.attr = 'style="white-space:normal;"';
					var QryDesc = rd.get('QryDesc');
					var OperDesc = rd.get('OperDesc');
					var CompVal = rd.get('CompVal');
					return QryDesc + OperDesc + CompVal;
				}
			}
		]
		,viewConfig : {
			forceFit : true
		}
	});

	//大类
	obj.cboDataCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboDataCatStore = new Ext.data.Store({
		proxy: obj.cboDataCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboDataCat = new Ext.form.ComboBox({
		id : 'cboDataCat'
		,fieldLabel : '大类<font color="red">*</font>'
		,store : obj.cboDataCatStore
		,minChars : 1
		,displayField : 'Desc'
		,valueField : 'ID'
		,editable : false
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});

	//子类
	obj.cboDataSubCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboDataSubCatStore = new Ext.data.Store({
		proxy: obj.cboDataSubCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboDataSubCat = new Ext.form.ComboBox({
		id : 'cboDataSubCat'
		,fieldLabel : '子类<font color="red">*</font>'
		,store : obj.cboDataSubCatStore
		,minChars : 1
		,displayField : 'Desc'
		,valueField : 'ID'
		,editable : false
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});

	//数据项
	obj.cboDataFieldStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboDataFieldStore = new Ext.data.Store({
		proxy: obj.cboDataFieldStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},[
			{name: 'ItemDesc', mapping: 'ItemDesc'}
			,{name: 'ItemCat', mapping: 'ItemCat'}
			,{name: 'ID', mapping: 'ID'}
		])
	});
	obj.cboDataField = new Ext.form.ComboBox({
		id : 'cboDataField'
		,fieldLabel : '数据项'
		,store : obj.cboDataFieldStore
		,minChars : 1
		,displayField : 'ItemDesc'
		,valueField : 'ID'
		,editable : false
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});
	//订制样式
	obj.cboCondCfgStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboCondCfgStore = new Ext.data.Store({
		proxy: obj.cboCondCfgStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},[
			{name: 'ID', mapping : 'ID'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboCondCfg = new Ext.form.ComboBox({
		id : 'cboCondCfg'
		,fieldLabel : '订制样式'
		,store : obj.cboCondCfgStore
		,region : 'north'
		,height : 30
		,minChars : 1
		,displayField : 'Desc'
		,valueField : 'ID'
		,editable : false
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});
	//增加条件
	obj.btnAddCond = new Ext.Button({
		id : 'btnAddCond'
		,iconCls : 'icon-update'
		,text : '增加条件'
		,width : 40
	});
	//导出数据
	obj.btnExport = new Ext.Button({
		id : 'btnExport'
		,iconCls : 'icon-export'
		,text : '导出数据'
		,width : 40
	});
	//检索病历
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		,iconCls:'icon-find'
		,text : '检索病历'
		,width : 40
	});

	//添加样式
	obj.btnAddCfg = new Ext.Button({
		id : 'btnAddCfg'
		,iconCls : 'icon-update'
		,text : '添加样式'
		,width : 50
	});
	//删除样式
	obj.btnDelCfg = new Ext.Button({
		id : 'btnDelCfg'
		,iconCls : 'icon-delete'
		,text : '删除样式'
		,width : 50
	});
	//检索数据项字典
	obj.btnQryItemDic = new Ext.Button({
		id : 'btnQryItemDic'
		,iconCls:'icon-find'
		,text : ''
		,width : 40
	});

	//查询条件设置
	obj.formInput = new Ext.Panel({
		id : 'formInput'
		,frame : true
		,layout : 'form'
		,labelAlign : 'right'
		,labelWidth : 80
		,buttonAlign:'center'
		,items:[
			obj.cboDateType
			,obj.dtFromDate
			,obj.dtToDate
			,{
				layout : 'column'
				,items: [
					{
						width : 87
						,html : '<div style="width=100%;text-align:right;font-size:12px;"><br>条件定义<font color="red">*</font>：</div>'
					},{
						columnWidth : 1
						,layout : 'fit'
						,buttonAlign : 'left'
						,items: [obj.gridInputCond]
					}
				]
			}
			,obj.cboLogical
			,obj.cboDataCat
			,obj.cboDataSubCat
			,obj.cboDataField
			,obj.cboOperCode
			,{
				layout : 'column'
				,height : 30
				,items : [
					{
						layout:'form'
						,columnWidth:.9
						,labelAlign : 'right'
						,labelWidth : 80
						,items:[obj.txtCompValue]
					},{
						layout:'form'
						,columnWidth:.1
						,labelAlign : 'right'
						,labelWidth : 0
						,items:[obj.btnQryItemDic]
					}
				]
			}
			,{
				layout : 'fit'
				,buttonAlign : 'center'
				,buttons : [obj.btnAddCond,obj.btnQuery,obj.btnExport]
			}
			,obj.cboCondCfg
			,{
				layout : 'fit'
				,buttonAlign : 'center'
				,buttons : [obj.btnAddCfg,obj.btnDelCfg]
			}
		]
	});

	obj.chkDataSubCat = Common_Checkbox('chkDataSubCat','子类');
	//输出子类
	obj.cboOutDataSubCatStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.cboOutDataSubCatStore = new Ext.data.Store({
		proxy: obj.cboOutDataSubCatStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},[
			{name: 'ID', mapping: 'ID'}
			,{name: 'Desc', mapping: 'Desc'}
		])
	});
	obj.cboOutDataSubCat = new Ext.form.ComboBox({
		id : 'cboOutDataSubCat'
		,fieldLabel : '数据项'
		,store : obj.cboOutDataSubCatStore
		,minChars : 1
		,displayField : 'Desc'
		,valueField : 'ID'
		//,editable : false
		,triggerAction : 'all'
		,width : 80
		,anchor : '100%'
	});
	obj.txtItemAlias = Common_TextField("txtItemAlias","检索");
	//输出列
	obj.gridOutColStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
		url : ExtToolSetting.RunQueryPageURL
	}));
	obj.gridOutColStore = new Ext.data.Store({
		proxy: obj.gridOutColStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ID'
		},
		[
			{name: 'ID', mapping : 'ID'}
			,{name: 'IsChecked', mapping : 'IsChecked'}
			,{name: 'DataType',mapping : 'DataType'}
			,{name: 'Desc', mapping: 'Desc'}

		])
	});
	obj.gridOutCol = new Ext.grid.EditorGridPanel({
		id : 'gridOutCol'
		,store : obj.gridOutColStore
		,columnLines : true
		,layout : 'fit'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '选择', width: 40, dataIndex: 'IsChecked', sortable: false, menuDisabled:true, align: 'center'
				,renderer: function(v, m, rd, r, c, s){
					var IsChecked = rd.get('IsChecked');
					if (IsChecked == '1') {
						return "<IMG src='../scripts/dhcwmr/img/checked.gif'>";
					} else {
						return "<IMG src='../scripts/dhcwmr/img/unchecked.gif'>";
					}
				}
			}
			,{header: '名称', width: 150, dataIndex: 'Desc', sortable: false, menuDisabled:true, align: 'center'}
		]
		,viewConfig : {
			forceFit : true
		}
    });
	
	//输出设置Tab
	obj.formOutput = new Ext.Panel({
		id : 'formOutput'
		,frame : true
		,layout : 'border'
		,items:[
			{
				region : 'north'
				,layout : 'form'
				,labelAlign : 'right'
				,labelWidth : 60
				,height : 90
				,items : [obj.chkDataSubCat,obj.cboOutDataSubCat,obj.txtItemAlias]
			},{
				region : 'center'
				,layout : 'fit'
				,items : [obj.gridOutCol]
			}
		]
	});
	//TabPanel
	obj.pnConditionSub = new Ext.TabPanel({
		id : 'pnConditionSub'
		,resizeTabs: true
		,minTabWidth: 90
		,tabWidth: 100
		,activeTab:0
		,buttonAlign : 'center'
		,defaults : {
			layout : 'fit',
			autoScroll : false,
			iconCls : 'icon-tab-default',
			bodyStyle : "margin:0;padding:0;width:100%;height:100%"
		}
		,items : [
			{
				title:'查询条件'
				,closable:false
				,layout:'fit'
				,items:[obj.formInput]
			},{
				title: '输出设置'
				,closable:false
				,layout:'fit'
				,items:[obj.formOutput]
			}
		]
	});
	
	//查询条件面板
	obj.pnCondition = new Ext.Panel({
		id : 'pnCondition',
		region : 'east',
		split:true,
		collapsible: true,
		collapsed : false,
        lines:false,
        animCollapse:false,
        animate: false,
        collapseMode:'mini',
		collapseFirst:false,
		hideCollapseTool:true,
		border:true,
		boxMinWidth : 350,
		boxMaxWidth : 350,
		width : 350,
		layout : 'fit',
		items:[obj.pnConditionSub]
	});
	
	obj.localData=[];
    obj.ResultGridStore = new Ext.data.Store({
        proxy: new Ext.ux.data.PagingMemoryProxy(obj.localData),
        remoteSort:true,
        reader: new Ext.data.ArrayReader({}, [
            {name: 'EpisodeID', mapping : 'EpisodeID'}
			,{name: 'item1', mapping : 'item1'}
			,{name: 'item2', mapping : 'item2'}
			,{name: 'item3', mapping : 'item3'}
			,{name: 'item4', mapping : 'item4'}
			,{name: 'item5', mapping : 'item5'}
			,{name: 'item6', mapping : 'item6'}
			,{name: 'item7', mapping : 'item7'}
			,{name: 'item8', mapping : 'item8'}
			,{name: 'item9', mapping : 'item9'}
			,{name: 'item10', mapping : 'item10'}
			,{name: 'item11', mapping : 'item11'}
			,{name: 'item12', mapping : 'item12'}
			,{name: 'item13', mapping : 'item13'}
			,{name: 'item14', mapping : 'item14'}
			,{name: 'item15', mapping : 'item15'}
			,{name: 'item16', mapping : 'item16'}
			,{name: 'item17', mapping : 'item17'}
			,{name: 'item18', mapping : 'item18'}
			,{name: 'item19', mapping : 'item19'}
			,{name: 'item20', mapping : 'item20'}
			,{name: 'item21', mapping : 'item21'}
			,{name: 'item22', mapping : 'item22'}
			,{name: 'item23', mapping : 'item23'}
			,{name: 'item24', mapping : 'item24'}
			,{name: 'item25', mapping : 'item25'}
			,{name: 'item26', mapping : 'item26'}
			,{name: 'item27', mapping : 'item27'}
			,{name: 'item28', mapping : 'item28'}
			,{name: 'item29', mapping : 'item29'}
			,{name: 'item30', mapping : 'item30'}
			,{name: 'item31', mapping : 'item31'}
			,{name: 'item32', mapping : 'item32'}
			,{name: 'item33', mapping : 'item33'}
			,{name: 'item34', mapping : 'item34'}
			,{name: 'item35', mapping : 'item35'}
			,{name: 'item36', mapping : 'item36'}
			,{name: 'item37', mapping : 'item37'}
			,{name: 'item38', mapping : 'item38'}
			,{name: 'item39', mapping : 'item39'}
			,{name: 'item40', mapping : 'item40'}
			,{name: 'item41', mapping : 'item41'}
			,{name: 'item42', mapping : 'item42'}
			,{name: 'item43', mapping : 'item43'}
			,{name: 'item44', mapping : 'item44'}
			,{name: 'item45', mapping : 'item45'}
			,{name: 'item46', mapping : 'item46'}
			,{name: 'item47', mapping : 'item47'}
			,{name: 'item48', mapping : 'item48'}
			,{name: 'item49', mapping : 'item49'}
			,{name: 'item50', mapping : 'item50'}
        ])
    });
	obj.ResultGrid = new Ext.grid.GridPanel({
		id : 'ResultGrid'
		,store : obj.ResultGridStore
		,columnLines : true
		,selModel : new Ext.grid.RowSelectionModel({singleSelect : true})
		,region : 'center'
		,height : 310
		,columns: []
		,bbar:new Ext.PagingToolbar({
			store:obj.ResultGridStore,
			pageSize:200,
			prependButtons:true,
			displayInfo:true,
			displayMsg:'当前显示第 {0} 到 {1}条,共 {2}条',
			emptyMsg:"没有记录信息"
		})
    });
	
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items:[
			obj.ResultGrid,
			obj.pnCondition
		]
	});

	obj.cboDataFieldStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MQService.DataItemSrv';
		param.QueryName = 'QryDataField';
		param.Arg1 = '';
		param.Arg2 = Common_GetValue('cboDataCat');
		param.Arg3 = Common_GetValue('cboDataSubCat');
		param.ArgCnt = 3;
	});

	obj.cboDataCatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MQService.DataCatSrv';
		param.QueryName = 'QryDataCat';
		param.ArgCnt = 0;
	});

	obj.cboDataSubCatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MQService.DataCatSrv';
		param.QueryName = 'QryDataSubCat';
		param.Arg1 = Common_GetValue('cboDataCat');
		param.ArgCnt = 1;
	});

	obj.gridOutColStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MQService.ConditionSrv';
		param.QueryName = 'QryCondCol';
		param.Arg1 = obj.gridOutCol_QryArg_Mode;			
		param.Arg2 = obj.gridOutCol_QryArg_CondfigID;		
		param.Arg3 = obj.gridOutCol_QryArg_DataType;
		param.Arg4 = obj.gridOutCol_QryArg_argID;
		param.Arg5 = Common_GetValue('txtItemAlias');
		param.ArgCnt = 5;
	});

	obj.cboCondCfgStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MQ.CondConfig';
		param.QueryName = 'QryCondCfg';
		param.ArgCnt = 0;
	});
	
	obj.cboOutDataSubCatStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MQService.ConditionSrv';
		param.QueryName = 'QryCondCol';
		param.Arg1 = 2;
		param.Arg2 = '';
		param.Arg3 = 'DataSubCat';
		param.Arg4 = '';
		param.Arg5 = Common_GetText('cboOutDataSubCat');
		param.ArgCnt = 5;
	});

	obj.gridInputCondStoreProxy.on('beforeload', function(objProxy, param){
		param.ClassName = 'DHCWMR.MQService.ConditionSrv';
		param.QueryName = 'QryCondInput';
		param.Arg1 = Common_GetValue('cboCondCfg');
		param.ArgCnt = 1;
	});

	InitviewScreenEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}