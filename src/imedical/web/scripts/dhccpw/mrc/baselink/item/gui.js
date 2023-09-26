function InitViewport(SubCatID){
	var obj = new Object();
	/*********************************************************************
	/以下为关联项目维护主窗体
	/*********************************************************************/
	obj.SubCatID=SubCatID;
	obj.CurrRowid="";
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
			{name: 'rowid', mapping: 'rowid'}
			,{name: 'IDCode', mapping: 'IDCode'}
			,{name: 'IDDesc', mapping: 'IDDesc'}
			,{name: 'IDSubCatDr', mapping: 'IDSubCatDr'}
			,{name: 'IDExpression', mapping: 'IDExpression'}
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
			,{header: '代码', width: 80, dataIndex: 'IDCode', sortable: false}
			,{header: '描述', width: 150, dataIndex: 'IDDesc', sortable: false}
			,{header: '表达式', width: 150, dataIndex: 'IDExpression', sortable: false}
			,{header: '说明', width: 150, dataIndex: 'IDResume', sortable: false}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.IDListStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
		})
		,viewConfig : {
			forceFit : true
		}
	});
	obj.IDCode = new Ext.form.TextField({
		id : 'IDCode'
		,fieldLabel : '代码'
		,labelSeparator :''
		,anchor : '99%'
	});
	obj.IDResume = new Ext.form.TextField({
		id : 'IDResume'
		,fieldLabel : '说明'
		,labelSeparator :''
		,anchor : '99%'
	});
	obj.IDDesc = new Ext.form.TextField({
		id : 'IDDesc'
		,anchor : '99%'
		,fieldLabel : '描述'
		,labelSeparator :''
	});
	obj.pnExpression = new Ext.Panel({
    id : 'pnExpression'
		,buttonAlign : 'center'
		,fieldLabel : '表达式'
		,labelSeparator :''
		/* removed by wuqk 2012-09-13  控件已更换 为 RichTextBoxCtl.CAB
		//modify by PanLei 2011-10-21 更改classid, 解决监控中心的函数控件表达式表单无法使用的问题
		//,html : "<OBJECT id='txtExpression' classid='clsid:8BD21D10-EC42-11CE-9E0D-00AA006002F3' codebase='RICHTX32.OCX' width='98.5%' height='55' VIEWASTEXT><PARAM NAME='ScrollBars' VALUE='3'></OBJECT>" */
		,html : "<OBJECT id='txtExpression' classid='CLSID:F4DB9267-4DFA-40C7-BF0E-819D4CE239D5' codebase='../addins/client/RichTextBoxCtl.CAB#version=1,0,0,0' width='98.5%' height='55' VIEWASTEXT><PARAM NAME='ScrollBars' VALUE='3'></OBJECT>"
	});

	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,iconCls : 'icon-save'
		,anchor : '99%'
		,text : '保存'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,anchor : '99%'
		,text : '删除'
	});
	obj.btnSymbolGreat = new Ext.Button({
		id : 'btnGreat'
		,tooltip : '大于'
		,text : '>'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolGreatEqual = new Ext.Button({
		id : 'btnGreatEqual'
		,tooltip : '大于等于'
		,text : '>='
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolLess = new Ext.Button({
		id : 'btnLess'
		,tooltip : '小于'
		,text : '<<'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolLessEqual = new Ext.Button({
		id : 'btnLessEqual'
		,tooltip : '小于等于'
		,text : '<='
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolAdd = new Ext.Button({
		id : 'btnSymbolAdd'
		,tooltip : '相加'
		,text : '+'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolMinus = new Ext.Button({
		id : 'btnMinus'
		,tooltip : '相减'
		,text : '-'
		,anchor : '99%'
		,columnWidth : .160
	});
	obj.btnSymbolMulti = new Ext.Button({
		id : 'btnMulti'
		,tooltip : '相乘'
		,text : '*'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolDivide = new Ext.Button({
		id : 'btnDivide'
		,tooltip : '相除'
		,text : '/'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolAnd = new Ext.Button({
		id : 'btnAnd'
		,tooltip : '与'
		,text : '.and.'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolOr = new Ext.Button({
		id : 'btnOr'
		,tooltip : '或'
		,text : '.or.'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolRight = new Ext.Button({
		id : 'btnRight'
		,tooltip : '右括号'
		,text : ')'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolLeft = new Ext.Button({
		id : 'btnLeft'
		,tooltip : '左括号'
		,text : '('
		,anchor : '99%'
		,columnWidth : .160
	});
	obj.pnCalcSymbol = new Ext.Panel({
		id : 'pnCalcSymbol'
		,fieldLabel : '操作符'
		,labelSeparator :''
		,layout : 'column'
		,anchor : '100%'
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
		]
	});
	obj.LeftPanel = new Ext.Panel({
		id : 'LeftPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,columnWidth : .70
		,layout : 'form'
		,frame : true
		,items:[
			obj.IDCode
			,obj.IDDesc
			,obj.IDResume
			,obj.pnExpression
			,obj.pnCalcSymbol
		]
		,buttons:[
			obj.btnAdd
			,obj.btnDelete
		]
	});
	
	obj.IDEditPanel = new Ext.Panel({
		id : 'IDEditPanel'
		,height : 265
		,buttonAlign : 'center'
		,region : 'south'
		,frame : true
		,layout : 'fit'
		,items:[
			obj.LeftPanel
		]
	});
	obj.IDFormPanel = new Ext.form.FormPanel({
		id : 'IDFormPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 80
		,region : 'center'
		,layout : 'border'
		//,frame : true
		,items:[
			obj.IDList
			,obj.IDEditPanel
		]
	});
	
	
	/*********************************************************************
	/关联项目:关联项目检查函数库
	/*********************************************************************/
	obj.tvPackageTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter : 'Arg1',
		dataUrl : ExtToolSetting.TreeQueryPageURL,
		baseParams : {
			ClassName : 'web.DHCCPW.MRC.BaseLinkMethodSrv',
			QueryName : 'BuildMethodAppJson',
			Arg2 : '',
			ArgCnt : 2
		}
	});
	obj.tvPackage = new Ext.tree.TreePanel({
		id : 'tvPackage'
		,RootNodeCaption : '函数库'
		,autoScroll : true
		,buttonAlign : 'center'
		,loader : obj.tvPackageTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'-root-', text:'函数库'})
	});
	obj.MethodLibPanel = new Ext.Panel({
		id : 'MethodLibPanel'
		,buttonAlign : 'center'
		,frame : true
		,title : '函数库'
		,layout : 'fit'
		,items:[
			obj.tvPackage
		]
	});
	
	/*********************************************************************
	/关联项目:关联电子病历界面模板目录树
	/*********************************************************************/
	obj.eprCategoryTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter : 'Arg1',
		dataUrl : ExtToolSetting.TreeQueryPageURL,
		baseParams : {
			ClassName : 'web.DHCCPW.MRC.BaseLinkItemSrv',
			QueryName : 'BuildEPRCategJson',
			ArgCnt : 1
		}
	});
	obj.eprCategoryTree = new Ext.tree.TreePanel({
		id : 'eprCategoryTree'
		,RootNodeCaption : '函数库'
		,autoScroll : true
		,buttonAlign : 'center'
		,loader : obj.eprCategoryTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'-root-', text:'电子病历目录树'})
	});
	obj.EPRLinkPanel = new Ext.Panel({
		id : 'EPRLinkPanel'
		,buttonAlign : 'center'
		,frame : true
		,title : '电子病历'
		,layout : 'fit'
		,items:[
			obj.eprCategoryTree
		]
	});
	
	/*********************************************************************
	/右侧电子病历关联项目
	/*********************************************************************/
	obj.tabPanel = new Ext.TabPanel({
		id : 'tabPanel'
		,activeTab : 0
		,buttonAlign : 'center'
		,collapsible : true
		,collapsed : true
		,region : 'east'
		,width : 300
		,items:[
			obj.MethodLibPanel
			,obj.EPRLinkPanel
		]
	});
	/*
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
		,minWidth : 250
		,maxWidth : 350
		,width : 300
		,items:[
			obj.tabPanel
		]
	});
	*/
	obj.Viewport = new Ext.Viewport({
		id : 'Viewport'
		,layout : 'border'
		,items:[
			obj.IDFormPanel
			,obj.tabPanel
		]
	});
	obj.IDListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.DHCCPW.MRC.BaseLinkItemSrv';
			param.QueryName = 'QryItemDic';
			param.Arg1 = obj.IDDesc.getRawValue();
			param.Arg2 = obj.SubCatID;
			param.ArgCnt = 2;
	});
	obj.IDListStore.load({
		params : {
			start:0
			,limit:20
		}
	});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

