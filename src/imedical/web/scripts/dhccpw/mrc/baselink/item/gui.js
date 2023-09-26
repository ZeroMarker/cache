function InitViewport(SubCatID){
	var obj = new Object();
	/*********************************************************************
	/����Ϊ������Ŀά��������
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
			,{header: '����', width: 80, dataIndex: 'IDCode', sortable: false}
			,{header: '����', width: 150, dataIndex: 'IDDesc', sortable: false}
			,{header: '���ʽ', width: 150, dataIndex: 'IDExpression', sortable: false}
			,{header: '˵��', width: 150, dataIndex: 'IDResume', sortable: false}
		]
		,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.IDListStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})
		,viewConfig : {
			forceFit : true
		}
	});
	obj.IDCode = new Ext.form.TextField({
		id : 'IDCode'
		,fieldLabel : '����'
		,labelSeparator :''
		,anchor : '99%'
	});
	obj.IDResume = new Ext.form.TextField({
		id : 'IDResume'
		,fieldLabel : '˵��'
		,labelSeparator :''
		,anchor : '99%'
	});
	obj.IDDesc = new Ext.form.TextField({
		id : 'IDDesc'
		,anchor : '99%'
		,fieldLabel : '����'
		,labelSeparator :''
	});
	obj.pnExpression = new Ext.Panel({
    id : 'pnExpression'
		,buttonAlign : 'center'
		,fieldLabel : '���ʽ'
		,labelSeparator :''
		/* removed by wuqk 2012-09-13  �ؼ��Ѹ��� Ϊ RichTextBoxCtl.CAB
		//modify by PanLei 2011-10-21 ����classid, ���������ĵĺ����ؼ����ʽ���޷�ʹ�õ�����
		//,html : "<OBJECT id='txtExpression' classid='clsid:8BD21D10-EC42-11CE-9E0D-00AA006002F3' codebase='RICHTX32.OCX' width='98.5%' height='55' VIEWASTEXT><PARAM NAME='ScrollBars' VALUE='3'></OBJECT>" */
		,html : "<OBJECT id='txtExpression' classid='CLSID:F4DB9267-4DFA-40C7-BF0E-819D4CE239D5' codebase='../addins/client/RichTextBoxCtl.CAB#version=1,0,0,0' width='98.5%' height='55' VIEWASTEXT><PARAM NAME='ScrollBars' VALUE='3'></OBJECT>"
	});

	obj.btnAdd = new Ext.Button({
		id : 'btnAdd'
		,iconCls : 'icon-save'
		,anchor : '99%'
		,text : '����'
	});
	obj.btnDelete = new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,anchor : '99%'
		,text : 'ɾ��'
	});
	obj.btnSymbolGreat = new Ext.Button({
		id : 'btnGreat'
		,tooltip : '����'
		,text : '>'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolGreatEqual = new Ext.Button({
		id : 'btnGreatEqual'
		,tooltip : '���ڵ���'
		,text : '>='
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolLess = new Ext.Button({
		id : 'btnLess'
		,tooltip : 'С��'
		,text : '<<'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolLessEqual = new Ext.Button({
		id : 'btnLessEqual'
		,tooltip : 'С�ڵ���'
		,text : '<='
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolAdd = new Ext.Button({
		id : 'btnSymbolAdd'
		,tooltip : '���'
		,text : '+'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolMinus = new Ext.Button({
		id : 'btnMinus'
		,tooltip : '���'
		,text : '-'
		,anchor : '99%'
		,columnWidth : .160
	});
	obj.btnSymbolMulti = new Ext.Button({
		id : 'btnMulti'
		,tooltip : '���'
		,text : '*'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolDivide = new Ext.Button({
		id : 'btnDivide'
		,tooltip : '���'
		,text : '/'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolAnd = new Ext.Button({
		id : 'btnAnd'
		,tooltip : '��'
		,text : '.and.'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolOr = new Ext.Button({
		id : 'btnOr'
		,tooltip : '��'
		,text : '.or.'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolRight = new Ext.Button({
		id : 'btnRight'
		,tooltip : '������'
		,text : ')'
		,anchor : '99%'
		,columnWidth : .166
	});
	obj.btnSymbolLeft = new Ext.Button({
		id : 'btnLeft'
		,tooltip : '������'
		,text : '('
		,anchor : '99%'
		,columnWidth : .160
	});
	obj.pnCalcSymbol = new Ext.Panel({
		id : 'pnCalcSymbol'
		,fieldLabel : '������'
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
	/������Ŀ:������Ŀ��麯����
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
		,RootNodeCaption : '������'
		,autoScroll : true
		,buttonAlign : 'center'
		,loader : obj.tvPackageTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'-root-', text:'������'})
	});
	obj.MethodLibPanel = new Ext.Panel({
		id : 'MethodLibPanel'
		,buttonAlign : 'center'
		,frame : true
		,title : '������'
		,layout : 'fit'
		,items:[
			obj.tvPackage
		]
	});
	
	/*********************************************************************
	/������Ŀ:�������Ӳ�������ģ��Ŀ¼��
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
		,RootNodeCaption : '������'
		,autoScroll : true
		,buttonAlign : 'center'
		,loader : obj.eprCategoryTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'-root-', text:'���Ӳ���Ŀ¼��'})
	});
	obj.EPRLinkPanel = new Ext.Panel({
		id : 'EPRLinkPanel'
		,buttonAlign : 'center'
		,frame : true
		,title : '���Ӳ���'
		,layout : 'fit'
		,items:[
			obj.eprCategoryTree
		]
	});
	
	/*********************************************************************
	/�Ҳ���Ӳ���������Ŀ
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

