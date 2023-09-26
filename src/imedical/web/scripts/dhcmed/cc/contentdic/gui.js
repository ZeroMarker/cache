function InitViewport(){
	var obj = new Object();
	obj.IDListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.IDListStore = new Ext.data.Store({
		proxy: obj.IDListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'IDCode', mapping: 'IDCode'}
			,{name: 'IDDesc', mapping: 'IDDesc'}
			,{name: 'CDDesc', mapping: 'CDDesc'}
			,{name: 'IDSubCatDr', mapping: 'IDSubCatDr'}
			,{name: 'IDExpression', mapping: 'IDExpression'}
			,{name: 'IDRange', mapping: 'IDRange'}
			,{name: 'IDResume', mapping: 'IDResume'}
		])
	});
	obj.IDListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.IDList = new Ext.grid.GridPanel({
		id : 'IDList'
		,store : obj.IDListStore
		,region : 'center'
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 100, dataIndex: 'IDCode', sortable: true}
			,{header: '描述', width: 150, dataIndex: 'IDDesc', sortable: true}
			,{header: '子分类', width: 100, dataIndex: 'CDDesc', sortable: true}
			,{header: '表达式', width: 350, dataIndex: 'IDExpression', sortable: true}
			,{header: '范围', width: 150, dataIndex: 'IDRange', sortable: true}
			//,{header: '备注', width: 150, dataIndex: 'IDResume', sortable: true}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.IDListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})

});
	obj.LeftPanel = new Ext.Panel({
		id : 'LeftPanel'
		,buttonAlign : 'center'
		,columnWidth : .05
		,items:[
		]
	});
	obj.IDCode = new Ext.form.TextField({
		id : 'IDCode'
		,fieldLabel : '代码'
		,anchor : '95%'
});
	obj.IDSubCatDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.IDSubCatDrStore = new Ext.data.Store({
		proxy: obj.IDSubCatDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'ISCode', mapping: 'ISCode'}
			,{name: 'ISCDesc', mapping: 'ISCDesc'}
			,{name: 'ISCCatDr', mapping: 'ISCCatDr'}
			,{name: 'CDDesc', mapping: 'CDDesc'}
		])
	});
	obj.IDSubCatDr = new Ext.form.ComboBox({
		id : 'IDSubCatDr'
		,store : obj.IDSubCatDrStore
		,minChars : 0
		,displayField : 'ISCDesc'
		,fieldLabel : '子分类'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
});
	obj.IDRange = new Ext.form.TextField({
		id : 'IDRange'
		,fieldLabel : '范围'
		,anchor : '95%'
});
	obj.IDRowid = new Ext.form.TextField({
		id : 'IDRowid'
		,hidden : true
});
	obj.IDDesc = new Ext.form.TextField({
		id : 'IDDesc'
		,anchor : '95%'
		,fieldLabel : '描述'
});
	obj.IDExpression = new Ext.form.TextField({
		id : 'IDExpression'
		,fieldLabel : '表达式'
		,anchor : '95%'
});
	obj.IDResume = new Ext.form.TextField({
		id : 'IDResume'
		,fieldLabel : '备注'
		,anchor : '95%'
});
	obj.LeftCenterPanel = new Ext.Panel({
		id : 'LeftCenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			obj.IDCode
			,obj.IDDesc
			,obj.IDSubCatDr
			,obj.IDRange
		]
	});
//********************表达式编辑器************************
	obj.pnExpression = new Ext.Panel({
		id : 'pnExpression'
		,buttonAlign : 'center'
		,fieldLabel : '表达式'
		,html : "<OBJECT id='txtExpression' classid='clsid:3B7C8860-D78F-101B-B9B5-04021C009402' codebase='RICHTX32.OCX' width='400' height='100' VIEWASTEXT><PARAM NAME='ScrollBars' VALUE='3'></OBJECT>"
		,items:[
		]
	});
	obj.RightCenterPanel = new Ext.Panel({
		id : 'RightCenterPanel'
		,buttonAlign : 'center'
		,columnWidth : .6
		,layout : 'form'
		,items:[
			//,obj.IDExpression
			//,obj.IDResume
			//,obj.IDRange
			obj.pnExpression
		]
	});
	
	obj.InsertPanel = new Ext.Panel({
		id : 'InsertPanel'
		,buttonAlign : 'center'
		,columnWidth : .3
		,layout : 'form'
		,items:[
			//obj.IDDesc
			//,obj.IDExpression
			//,obj.IDResume
		]
	});
	
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .05
		,items:[
		]
	});
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,iconCls : 'icon-save'
		,anchor : '95%'
		,text : '保存'
});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
});

	obj.btnSymbolGreat = new Ext.Button({
		id : 'btnGreat'
		,tooltip : '大于'
		,text : '>'
});
	obj.btnSymbolGreatEqual = new Ext.Button({
		id : 'btnGreatEqual'
		,tooltip : '大于等于'
		,text : '>='
});
	obj.btnSymbolLess = new Ext.Button({
		id : 'btnLess'
		,tooltip : '小于'
		,text : '<<'
});
	obj.btnSymbolLessEqual = new Ext.Button({
		id : 'btnLessEqual'
		,tooltip : '小于等于'
		,text : '<='
});
	obj.btnSymbolAdd = new Ext.Button({
		id : 'btnSymbolAdd'
		,tooltip : '相加'
		,text : '+'
});
	obj.btnSymbolMinus = new Ext.Button({
		id : 'btnMinus'
		,tooltip : '相减'
		,text : '-'
});
	obj.btnSymbolMulti = new Ext.Button({
		id : 'btnMulti'
		,tooltip : '相乘'
		,text : '*'
});
	obj.btnSymbolDivide = new Ext.Button({
		id : 'btnDivide'
		,tooltip : '相除'
		,text : '/'
});
	obj.btnSymbolAnd = new Ext.Button({
		id : 'btnAnd'
		,tooltip : '与'
		,text : '.and.'
});
	obj.btnSymbolOr = new Ext.Button({
		id : 'btnOr'
		,tooltip : '或'
		,text : '.or.'
});
	obj.btnSymbolRight = new Ext.Button({
		id : 'btnRight'
		,tooltip : '右括号'
		,text : ')'
});
	obj.btnSymbolLeft = new Ext.Button({
		id : 'btnLeft'
		,tooltip : '左括号'
		,text : '('
});
	obj.pnCalcSymbol = new Ext.Panel({
		id : 'pnCalcSymbol'
		,buttonAlign : 'center'
		,bodyStyle : 'padding:20px'
		,defaults : {width:50}
		//,title : '运算符号'
		,columnWidth : .7
		//,collapsible : true
		,layoutConfig : {columns: 3}
		,height : 150
		,layout : 'table'
		//,frame : true
		,items:[
			obj.btnSymbolGreat
			,obj.btnSymbolGreatEqual
			,obj.btnSymbolLess
			,obj.btnSymbolLessEqual
			,obj.btnSymbolAdd
			,obj.btnSymbolMinus
			,obj.btnSymbolMulti
			,obj.btnSymbolDivide
			,obj.btnSymbolAnd
			,obj.btnSymbolOr
			,obj.btnSymbolRight
			,obj.btnSymbolLeft
			,obj.IDRowid
		]
	});
obj.tvPackageTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter : 'Arg1',
		dataUrl : ExtToolSetting.TreeQueryPageURL,
		baseParams : {
			ClassName : 'DHCMed.CCService.MethodPackageSrv',
			QueryName : 'QueryPackageMethod',
			Arg2 : '',
		ArgCnt : 2
		}
		});
	obj.tvPackage = new Ext.tree.TreePanel({
		id : 'tvPackage'
		,height : 160
		,RootNodeCaption : '函数库'
		,autoScroll : true
		,buttonAlign : 'center'
		,loader : obj.tvPackageTreeLoader,
		root : new Ext.tree.AsyncTreeNode({id:'0', text:'函数库'})

});
	obj.pnFunctionLib = new Ext.Panel({
		id : 'pnFunctionLib'
		,buttonAlign : 'center'
		,header : false
		//,title : '函数库'
		//,collapsible : true
		,columnWidth : .5
		,layout : 'fit'
		,items:[
			obj.tvPackage
		]
	});
	obj.LeftOperationPanel = new Ext.Panel({
		id : 'LeftOperationPanel'
		,buttonAlign : 'center'
		//,collapsible : true
		,columnWidth : .2
		,layout : 'form'
		,items:[
		]
	});
	obj.OperationPanel = new Ext.Panel({
		id : 'OperationPanel'
		,buttonAlign : 'center'
		//,collapsible : true
		,columnWidth : .45
		,layout : 'column'
		,items:[
			//obj.pnExpression
			obj.LeftOperationPanel
			,obj.pnCalcSymbol
		]
	});
	obj.pnInsertPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .05
		,layout : 'column'
		,autoScroll : true
		,items:[
			//obj.pnCalcSymbol
			obj.OperationPanel
			,obj.pnFunctionLib
		]
	});
	InitExpressionEditorEvent(obj);
	//事件处理代码
	obj.btnSymbolGreat.on("click", obj.btnSymbolGreat_click, obj);
	obj.btnSymbolGreatEqual.on("click", obj.btnSymbolGreatEqual_click, obj);
	obj.btnSymbolLess.on("click", obj.btnSymbolLess_click, obj);
	obj.btnSymbolLessEqual.on("click", obj.btnSymbolLessEqual_click, obj);
	obj.btnSymbolAdd.on("click", obj.btnSymbolAdd_click, obj);
	obj.btnSymbolMinus.on("click", obj.btnSymbolMinus_click, obj);
	obj.btnSymbolMulti.on("click", obj.btnSymbolMulti_click, obj);
	obj.btnSymbolDivide.on("click", obj.btnSymbolDivide_click, obj);
	obj.btnSymbolAnd.on("click", obj.btnSymbolAnd_click, obj);
	obj.btnSymbolOr.on("click", obj.btnSymbolOr_click, obj);
	obj.btnSymbolRight.on("click", obj.btnSymbolRight_click, obj);
	obj.btnSymbolLeft.on("click", obj.btnSymbolLeft_click, obj);
	obj.tvPackage.on("dblclick", obj.tvPackage_dblclick, obj);
  obj.LoadEvent(arguments);

//*******************************************************

	obj.ExpressionEditor = new ExpressionEditor();
	obj.IDEditPanel = new Ext.Panel({
		id : 'IDEditPanel'
		,height : 330
		,buttonAlign : 'center'
		,region : 'south'
		,frame : true
		,layout : 'form'
		,items:[
			{
				layout : 'column',
				items:[
					obj.LeftPanel
					,obj.LeftCenterPanel
					,obj.RightCenterPanel
					,obj.InsertPanel
					,obj.RightPanel
					]
			}
			,
			{
				height:300,
				layout:"form",
				items:
				[
					//obj.pnExpression
					obj.pnInsertPanel
				]
			}
			//{height:150,region:"south",html:'<OBJECT id="txtExpression" codeBase="RichTx32.OCX" classid="clsid:3B7C8860-D78F-101B-B9B5-04021C009402" codebase="../addins/client/RichTx32.CAB" width="500" height="150" width="400" VIEWASTEXT></OBJECT>'}
		]
	,	buttons:[
			obj.btnFind
			,obj.btnAdd
			,obj.btnDelete
		]
	});
	obj.IDFormPanel = new Ext.form.FormPanel({
		id : 'IDFormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		,layout : 'border'
		,frame : true
		,items:[
			obj.IDList
			,obj.IDEditPanel
		]
	});
	obj.ARCIMListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ARCIMListStore = new Ext.data.Store({
		proxy: obj.ARCIMListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'ArcimID'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'ArcimID', mapping: 'ArcimID'}
			,{name: 'ArcimDesc', mapping: 'ArcimDesc'}
			,{name: 'ORCATDesc', mapping: 'ORCATDesc'}
			,{name: 'ARCICDesc', mapping: 'ARCICDesc'}
			,{name: 'ARCIMCode', mapping: 'ARCIMCode'}
			,{name: 'ArcimDR', mapping: 'ArcimDR'}
			,{name: 'ARCICOrdCatDR', mapping: 'ARCICOrdCatDR'}
			,{name: 'ARCIMItemCatDR', mapping: 'ARCIMItemCatDR'}
		])
	});
	obj.ARCIMListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.ARCIMList = new Ext.grid.GridPanel({
		id : 'ARCIMList'
		,region : 'center'
		,store : obj.ARCIMListStore
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.ARCIMListCheckCol
			,{header: '医嘱名称', width: 100, dataIndex: 'ArcimDesc', sortable: true}
			,{header: '医嘱大类', width: 100, dataIndex: 'ORCATDesc', sortable: true}
			,{header: '医嘱子类', width: 100, dataIndex: 'ARCICDesc', sortable: true}
		]
		,plugins : obj.ARCIMListCheckCol});
	obj.Panel34 = new Ext.Panel({
		id : 'Panel34'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.OEDesc = new Ext.form.TextField({
		id : 'OEDesc'
		,fieldLabel : '医嘱名称'
		,anchor : '95%'
});
	obj.nIDSubCatDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.nIDSubCatDrStore = new Ext.data.Store({
		proxy: obj.nIDSubCatDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'ISCode', mapping: 'ISCode'}
			,{name: 'ISCDesc', mapping: 'ISCDesc'}
			,{name: 'ISCCatDr', mapping: 'ISCCatDr'}
		])
	});
	obj.nIDSubCatDr = new Ext.form.ComboBox({
		id : 'nIDSubCatDr'
		,store : obj.nIDSubCatDrStore
		,minChars : 0
		,displayField : 'ISCDesc'
		,fieldLabel : '项目子类'
		,valueField : 'rowid'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
});
	obj.Panel35 = new Ext.Panel({
		id : 'Panel35'
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items:[
			obj.OEDesc
			//,obj.nIDSubCatDr
		]
	});
	obj.Panel36 = new Ext.Panel({
		id : 'Panel36'
		,buttonAlign : 'center'
		,columnWidth : .1
		,layout : 'form'
		,items:[
		]
	});
	obj.OEBtnFind = new Ext.Button({
		id : 'OEBtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.OEBtnUpdate = new Ext.Button({
		id : 'OEBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
});
	obj.OEManage = new Ext.Panel({
		id : 'OEManage'
		,height : 80
		,region : 'south'
		,buttonAlign : 'center'
		,frame : true
		,layout : 'column'
		,items:[
			obj.Panel34
			,obj.Panel35
			,obj.Panel36
		]
	,	buttons:[
			obj.OEBtnFind
			,obj.OEBtnUpdate
		]
	});
	obj.ARCIMEditPanel = new Ext.Panel({
		id : 'ARCIMEditPanel'
		,buttonAlign : 'center'
		,frame : true
		,title : '医嘱'
		,layout : 'border'
		,items:[
			obj.ARCIMList
			,obj.OEManage
		]
	});
	obj.MRCICDDxListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MRCICDDxListStore = new Ext.data.Store({
		proxy: obj.MRCICDDxListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'MRCID'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'MRCID', mapping: 'MRCID'}
			,{name: 'ICD9CMCode', mapping: 'ICD9CMCode'}
			,{name: 'Descs', mapping: 'Descs'}
		])
	});
	obj.MRCICDDxListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.MRCICDDxList = new Ext.grid.GridPanel({
		id : 'MRCICDDxList'
		,region : 'center'
		,store : obj.MRCICDDxListStore
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.MRCICDDxListCheckCol
			,{header: '诊断编码', width: 100, dataIndex: 'ICD9CMCode', sortable: true}
			,{header: '诊断名称', width: 200, dataIndex: 'Descs', sortable: true}
		]
		,plugins : obj.MRCICDDxListCheckCol});
	obj.LeftMRCICDDxPanel = new Ext.Panel({
		id : 'LeftMRCICDDxPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.MRCICD9CMCode = new Ext.form.TextField({
		id : 'MRCICD9CMCode'
		,fieldLabel : '诊断编码'
		,anchor : '95%'
});
	obj.MRCIDSubCatDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.MRCIDSubCatDrStore = new Ext.data.Store({
		proxy: obj.MRCIDSubCatDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'ISCCode', mapping: 'ISCCode'}
			,{name: 'ISCDesc', mapping: 'ISCDesc'}
			,{name: 'ISCCatDr', mapping: 'ISCCatDr'}
		])
	});
	obj.MRCIDSubCatDr = new Ext.form.ComboBox({
		id : 'MRCIDSubCatDr'
		,store : obj.MRCIDSubCatDrStore
		,minChars : 0
		,displayField : 'ISCDesc'
		,fieldLabel : '项目子类'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
});
	obj.CenterMRCICDDxPanel = new Ext.Panel({
		id : 'CenterMRCICDDxPanel'
		,height : 120
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items:[
			obj.MRCICD9CMCode
			//,obj.MRCIDSubCatDr
		]
	});
	obj.RightMRCICDDxPanel = new Ext.Panel({
		id : 'RightMRCICDDxPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.DBtnFind = new Ext.Button({
		id : 'DBtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.DBtnUpdate = new Ext.Button({
		id : 'DBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
});
	obj.MRCICDDxManage = new Ext.Panel({
		id : 'MRCICDDxManage'
		,height : 80
		,buttonAlign : 'center'
		,frame : true
		,region : 'south'
		,layout : 'column'
		,items:[
			obj.LeftMRCICDDxPanel
			,obj.CenterMRCICDDxPanel
			,obj.RightMRCICDDxPanel
		]
	,	buttons:[
			obj.DBtnFind
			,obj.DBtnUpdate
		]
	});
	obj.MRCICDDxPanel = new Ext.Panel({
		id : 'MRCICDDxPanel'
		,buttonAlign : 'center'
		,title : '诊断'
		,layout : 'border'
		,items:[
			obj.MRCICDDxList
			,obj.MRCICDDxManage
		]
	});
	obj.CDicListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.CDicListStore = new Ext.data.Store({
		proxy: obj.CDicListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'CDCode', mapping: 'CDCode'}
			,{name: 'CDDesc', mapping: 'CDDesc'}
			,{name: 'CDType', mapping: 'CDType'}
			,{name: 'CDTypeDesc', mapping: 'CDTypeDesc'}
			,{name: 'CDExpression', mapping: 'CDExpression'}
			,{name: 'CDResume', mapping: 'CDResume'}
		])
	});
	obj.CDicListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.CDicList = new Ext.grid.GridPanel({
		id : 'CDicList'
		,region : 'center'
		,store : obj.CDicListStore
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 100, dataIndex: 'CDCode', sortable: true}
			,{header: '描述', width: 100, dataIndex: 'CDDesc', sortable: true}
			,{header: '类型', width: 100, dataIndex: 'CDTypeDesc', sortable: true}
			,{header: '表达式', width: 100, dataIndex: 'CDExpression', sortable: true}
			,{header: '备注', width: 100, dataIndex: 'CDResume', sortable: true}
		]});
	obj.LeftCDicPanel = new Ext.Panel({
		id : 'LeftCDicPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.CDCode = new Ext.form.TextField({
		id : 'CDCode'
		,fieldLabel : '代码'
		,anchor : '95%'
});
	obj.CDDesc = new Ext.form.TextField({
		id : 'CDDesc'
		,fieldLabel : '描述'
		,anchor : '95%'
});	
	obj.CDTypeStore = new Ext.data.SimpleStore({
		fields : ['CDTypeDesc','CDTypeCode'],
		data : 
		[['医嘱','OE'],['诊断','D'],['检验','L']]
	});
	obj.CDType = new Ext.form.ComboBox({
		id : 'CDType'
		,store : obj.CDTypeStore
		,displayField : 'CDTypeDesc'
		,fieldLabel : '类型'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'CDTypeCode'
		,mode: 'local'
});
	obj.CDExpression = new Ext.form.TextField({
		id : 'CDExpression'
		,fieldLabel : '表达式'
		,anchor : '95%'
});
	obj.CDResume = new Ext.form.TextField({
		id : 'CDResume'
		,fieldLabel : '备注'
		,anchor : '95%'
});
	obj.CDRowid = new Ext.form.TextField({
		id : 'CDRowid'
		,hidden : true
});
	obj.CenterCDicPanel = new Ext.Panel({
		id : 'CenterCDicPanel'
		,buttonAlign : 'center'
		,columnWidth : .8
		,layout : 'form'
		,items:[
			obj.CDCode
			,obj.CDDesc
			,obj.CDType
			,obj.CDExpression
			,obj.CDResume
			,obj.CDRowid
		]
	});
	obj.RightCDicPanel = new Ext.Panel({
		id : 'RightCDicPanel'
		,buttonAlign : 'center'
		,columnWidth : .1
		,items:[
		]
	});
	obj.CDBtnFind = new Ext.Button({
		id : 'CDBtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.CDUpdate = new Ext.Button({
		id : 'CDUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
});
	obj.CDDelete = new Ext.Button({
		id : 'CDDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
});
	obj.CDicPanel11 = new Ext.Panel({
		id : 'CDicPanel11'
		,height : 200
		,buttonAlign : 'center'
		,region : 'south'
		,frame : true
		,layout : 'column'
		,collapsible : true
		,items:[
			obj.LeftCDicPanel
			,obj.CenterCDicPanel
			,obj.RightCDicPanel
		]
	,	buttons:[
			obj.CDBtnFind
			,obj.CDUpdate
			,obj.CDDelete
		]
	});
	obj.CDicPanel = new Ext.Panel({
		id : 'CDicPanel'
		,buttonAlign : 'center'
		,title : '普通'
		,layout : 'border'
		//,frame : true
		,items:[
			obj.CDicList
			,obj.CDicPanel11
		]
	});
	obj.LabListStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.LabListStore = new Ext.data.Store({
		proxy: obj.LabListStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'CDCode', mapping: 'CDCode'}
			,{name: 'CDDesc', mapping: 'CDDesc'}
			,{name: 'CDType', mapping: 'CDType'}
			,{name: 'CDTypeDesc', mapping: 'CDTypeDesc'}
			,{name: 'CDExpression', mapping: 'CDExpression'}
			,{name: 'CDResume', mapping: 'CDResume'}
		])
	});
	obj.LabListCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	obj.LabList = new Ext.grid.GridPanel({
		id : 'LabList'
		,height : 60
		,region : 'center'
		,store : obj.LabListStore
		,buttonAlign : 'center'
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '代码', width: 70, dataIndex: 'CDCode', sortable: true}
			,{header: '描述', width: 200, dataIndex: 'CDDesc', sortable: true}
			,{header: '类型', width: 0, dataIndex: 'CDTypeDesc', sortable: true}
			,{header: '表达式', width: 120, dataIndex: 'CDExpression', sortable: true}
			,{header: '备注', width: 150, dataIndex: 'CDResume', sortable: true}
		]});
	obj.LeftFPanel = new Ext.Panel({
		id : 'Panel13'
		,buttonAlign : 'center'
		,columnWidth : .05
		,items:[
		]
	});
	obj.LabCode = new Ext.form.TextField({
		id : 'LabCode'
		,fieldLabel : '代码'
		,anchor : '95%'
		,disabled : true
});
	obj.LabRowid = new Ext.form.TextField({
		id : 'LabRowid'
		,hidden : true
		,hideLabel : true
});
	obj.LabDesc = new Ext.form.TextField({
		id : 'LabDesc'
		,value : ''
		,fieldLabel : '描述'
		,anchor : '95%'
		,disabled : true
});
	obj.LabItmExplainStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.LabItmExplainStore = new Ext.data.Store({
		proxy: obj.LabItmExplainStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Expresion'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'Expresion', mapping: 'Expresion'}
			,{name: 'HideText', mapping: 'HideText'}
		])
	});
	obj.LabItmExplainCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 0 });
	obj.LabItmExplain = new Ext.grid.GridPanel({
		id : 'LabItmExplain'
		,fieldLabel : '表达式'
		,store : obj.LabItmExplainStore
		,height : 120
		,anchor : '95%'
		,columns: [
			{header: '   ', width: 200, dataIndex: 'Expresion'}
			,{header: '', width: 0, dataIndex: 'HideText'}
		]});
	obj.LabRoomStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.LabRoomStore = new Ext.data.Store({
		proxy: obj.LabRoomStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'DepNo'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'DepNo', mapping: 'DepNo'}
			,{name: 'DepName', mapping: 'DepName'}
		])
	});
	obj.LabRoom = new Ext.form.ComboBox({
		id : 'LabRoom'
		,store : obj.LabRoomStore
		,minChars : 0
		,displayField : 'DepName'
		,fieldLabel : '实验室'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'DepNo'
});
	obj.LabItmDescStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.LabItmDescStore = new Ext.data.Store({
		proxy: obj.LabItmDescStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'TestCode'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'TestCode', mapping: 'TestCode'}
			,{name: 'TestName', mapping: 'TestName'}
		])
	});
	obj.LabItmDesc = new Ext.form.ComboBox({
		id : 'LabItmDesc'
		,minChars : 0
		,displayField : 'TestName'
		,fieldLabel : '检验项目'
		,store : obj.LabItmDescStore
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'TestCode'
		,forceSelection : true
});
	obj.LabOperCharStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.LabOperCharStore = new Ext.data.Store({
		proxy: obj.LabOperCharStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'DicCode', mapping: 'DicCode'}
			,{name: 'DicName', mapping: 'DicName'}
		])
	});
	obj.LabOperChar = new Ext.form.ComboBox({
		id : 'LabOperChar'
		,store : obj.LabOperCharStore
		,minChars : 0
		,displayField : 'DicName'
		,fieldLabel : '操作符'
		,editable : false
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'DicCode'
});
	obj.LabValueStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.LabValueStore = new Ext.data.Store({
		proxy: obj.LabValueStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Code'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'Code', mapping: 'Code'}
			,{name: 'Descs', mapping: 'Descs'}
		])
	});
	obj.LabValue = new Ext.form.ComboBox({
		id : 'LabValue'
		,store : obj.LabValueStore
		,minChars : 1
		,displayField : 'Descs'
		,fieldLabel : '值'
		,valueField : 'Code'
		,triggerAction : 'all'
		,anchor : '95%'
		//,forceSelection : true
});
	obj.LabResume = new Ext.form.TextField({
		id : 'LabResume'
		,fieldLabel : '备注'
		,anchor : '95%'
});
	obj.LabBtnAddItem = new Ext.Button({
		id : 'LabBtnAddItem'
		,text : '<--'
});
	obj.LabBtnDelItem = new Ext.Button({
		id : 'LabBtnDelItem'
		,text : '-->'
});
	obj.CenterPanel = new Ext.Panel({
		id : 'Panel14'
		,buttonAlign : 'center'
		,columnWidth : .9
		,layout : 'form'
		,items:[
			obj.LabCode
			,obj.LabDesc
			//,obj.LabItmExplain
			,obj.LabRoom
			,obj.LabItmDesc
			,obj.LabOperChar
			,obj.LabValue
			//,obj.LabResume
			,obj.LabRowid
		]
	,	buttons:[
			obj.LabBtnAddItem
			,obj.LabBtnDelItem
		]
	});
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .05
		,anchor : '95%'
		,layout : 'form'
		,items:[
		]
	});
	obj.LabBtnFind = new Ext.Button({
		id : 'LabBtnFind'
		,iconCls : 'icon-find'
		,anchor : '95%'
		,text : '查询'
});
	obj.LabBtnUpdate = new Ext.Button({
		id : 'LabBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '95%'
		,text : '更新'
});
	obj.LabBtnDelete = new Ext.Button({
		id : 'LabBtnDelete'
		,iconCls : 'icon-delete'
		,anchor : '95%'
		,text : '删除'
});
	obj.LabManage = new Ext.Panel({
		id : 'LabManage'
		,buttonAlign : 'center'
		,region : 'center'
		,height : 330
		,frame : true
		//,collapsible : true
		//,titleCollapse : false
		//,collapsed : true
		//,autoScroll : true
		,layout : 'column'
		,items:[
			obj.LeftFPanel
			,obj.CenterPanel
			,obj.RightPanel
		]
	,	buttons:[
			//obj.LabBtnFind
			obj.LabBtnUpdate
			//,obj.LabBtnDelete
		]
	});
	obj.LabPanel = new Ext.Panel({
		id : 'LabPanel'
		,buttonAlign : 'center'
		//,frame : true
		,border : false
		,title : '检验'
		,layout : 'border'
		,items:[
			//obj.LabList
			obj.LabManage
		]
	});
	obj.tabPanel = new Ext.TabPanel({
		id : 'Panel10'
		,activeTab : 0
		,buttonAlign : 'center'
		,items:[
			obj.ARCIMEditPanel
			,obj.MRCICDDxPanel
			//,obj.CDicPanel
			,obj.LabPanel
		]
	});
	obj.LeftFPanel = new Ext.form.FormPanel({
		id : 'LeftFPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		//,autoScroll : true
		,labelWidth : 80
		,collapsible : true
		,collapsed : true
		,deferredRender : false
		,region : 'east'
		,split : true
		,monitorResize : true
		,frame : true
		,layout : 'fit'
		,maskDisabled : true
		,border : true
		,minWidth : 350
		,maxWidth : 600
		,width : 400
		,items:[
			obj.tabPanel
		]
	});
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.IDFormPanel
			,obj.LeftFPanel
		]
	});
	obj.IDListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ContentDicSrv';
			param.QueryName = 'QueryItemDicInfo';
			param.Arg1 = obj.IDDesc.getValue();
			param.Arg2 = obj.IDSubCatDr.getValue();
			param.ArgCnt = 2;
	});
	obj.IDListStore.load({
	params : {
		start:0
		,limit:20
	}});

	obj.IDSubCatDrStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ContentDicSrv';
			param.QueryName = 'FindItemSubCatInfo';
			param.ArgCnt = 0;
	});
	obj.IDSubCatDrStore.load({});
	obj.ARCIMListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ContentDicSrv';
			param.QueryName = 'QueryByDescAlias';
			param.Arg1 = obj.OEDesc.getValue();
			param.ArgCnt = 1;
	});
	obj.ARCIMListStore.load({});
	obj.nIDSubCatDrStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ContentDicSrv';
			param.QueryName = 'FindItemSubCatInfo';
			param.ArgCnt = 0;
	});
	obj.nIDSubCatDrStore.load({});
	obj.MRCICDDxListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.Base.MRCICDDx';
			param.QueryName = 'QueryByDescAlias';
			param.Arg1 = obj.MRCICD9CMCode.getValue();
			param.ArgCnt = 1;
	});
	obj.MRCICDDxListStore.load({});
	obj.MRCIDSubCatDrStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ContentDicSrv';
			param.QueryName = 'FindItemSubCatInfo';
			param.ArgCnt = 0;
	});
	obj.MRCIDSubCatDrStore.load({});
	obj.CDicListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ContentDicSrv';
			param.QueryName = 'QueryContentDicInfo';
			param.Arg1 = obj.CDCode.getValue();
			param.Arg2 = obj.CDType.getValue();
			param.Arg3 = '';
			param.ArgCnt = 3;
	});
	obj.CDicListStore.load({});
	obj.LabListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ContentDicSrv';
			param.QueryName = 'QueryContentDicInfo';
			param.Arg1 = obj.LabCode.getValue();
			param.Arg2 = '';
			param.Arg3 = '检验';
			param.ArgCnt = 3;
	});
	obj.LabListStore.load({});
	obj.LabItmExplainStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = '';
			param.QueryName = '';
			param.ArgCnt = 0;
	});
	obj.LabRoomStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ContentDicSrv';
			param.QueryName = 'GetDepartment';
			param.ArgCnt = 0;
	});
	obj.LabRoomStore.load({});
	obj.LabItmDescStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ContentDicSrv';
			param.QueryName = 'GetTestCode';
			param.Arg1 = obj.LabRoom.getValue();
			param.Arg2 = '';
			param.Arg3 = obj.LabItmDesc.getRawValue();
			param.ArgCnt = 3;
	});
	obj.LabItmDescStore.load({});
	obj.LabOperCharStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ContentDicSrv';
			param.QueryName = 'FindOperCharFromDic';
			param.Arg1 = 'CompareOperator';
			param.ArgCnt = 1;
	});
	obj.LabOperCharStore.load({});
	obj.LabValueStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.ContentDicSrv';
			param.QueryName = 'GetValueListByCode';
			param.Arg1 = obj.LabItmDesc.getValue();
			param.ArgCnt = 1;
	});
	obj.LabValueStore.load({});
	InitViewportEvent(obj);
	//事件处理代码
	obj.ARCIMList.on("rowclick", obj.ARCIMList_rowclick, obj);
	obj.OEBtnUpdate.on("click", obj.ARCIMList_rowclick, obj);
	obj.MRCICDDxList.on("rowclick", obj.MRCICDDxList_rowclick, obj);
	obj.DBtnUpdate.on("rowclick", obj.MRCICDDxList_rowclick, obj);
	obj.IDList.on("rowclick", obj.IDList_rowclick, obj);
	obj.btnFind.on("click", obj.btnFind_click, obj);
	obj.btnAdd.on("click", obj.btnAdd_click, obj);
	obj.btnDelete.on("click", obj.btnDelete_click, obj);
	obj.OEDesc.on("specialkey", obj.OEDesc_change, obj);
	obj.MRCICD9CMCode.on("specialkey", obj.DBtnFind_click, obj);
	obj.OEBtnFind.on("click", obj.OEBtnFind_click, obj);
	obj.DBtnFind.on("click", obj.DBtnFind_click, obj);
	obj.DBtnUpdate.on("click", obj.DBtnUpdate_click, obj);
	obj.CDicList.on("rowclick", obj.CDicList_rowclick, obj);
	obj.CDBtnFind.on("click", obj.CDBtnFind_click, obj);
	obj.CDUpdate.on("click", obj.CDUpdate_click, obj);
	obj.CDDelete.on("click", obj.CDDelete_click, obj);
	obj.LabList.on("rowclick", obj.LabList_rowclick, obj);
	obj.LabItmExplain.on("rowclick", obj.LabItmExplain_rowclick, obj);
	obj.LabRoom.on("select", obj.LabRoom_select, obj);
	obj.LabItmDesc.on("select", obj.LabItmDesc_select, obj);
	obj.LabBtnAddItem.on("click", obj.LabBtnAddItem_click, obj);
	obj.LabBtnDelItem.on("click", obj.LabBtnDelItem_click, obj);
	obj.LabBtnFind.on("click", obj.LabBtnFind_click, obj);
	obj.LabBtnUpdate.on("click", obj.LabBtnUpdate_click, obj);
	obj.LabBtnDelete.on("click", obj.LabBtnDelete_click, obj);
	obj.tabPanel.on("tabchange", obj.tabPanel_tabchange, obj);
  obj.LoadEvent();
  return obj;
}

