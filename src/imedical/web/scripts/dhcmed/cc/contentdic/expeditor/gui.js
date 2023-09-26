
function ExpressionEditor(){
	var obj = new Object();
	obj.pnExpression = new Ext.Panel({
		id : 'pnExpression'
		,buttonAlign : 'center'
		,html : "<OBJECT id='txtExpression' classid='clsid:3B7C8860-D78F-101B-B9B5-04021C009402' codebase='RICHTX32.OCX' width='500' height='150' VIEWASTEXT><PARAM NAME='ScrollBars' VALUE='3'></OBJECT>"
		,items:[
		]
	});
	obj.btnSymbolGreat = new Ext.Button({
		id : 'btnGreat'
		,tooltip : '����'
		,text : '>'
});
	obj.btnSymbolGreatEqual = new Ext.Button({
		id : 'btnGreatEqual'
		,tooltip : '���ڵ���'
		,text : '>='
});
	obj.btnSymbolLess = new Ext.Button({
		id : 'btnLess'
		,tooltip : 'С��'
		,text : '<<'
});
	obj.btnSymbolLessEqual = new Ext.Button({
		id : 'btnLessEqual'
		,tooltip : 'С�ڵ���'
		,text : '<='
});
	obj.btnSymbolAdd = new Ext.Button({
		id : 'btnAdd'
		,tooltip : '���'
		,text : '+'
});
	obj.btnSymbolMinus = new Ext.Button({
		id : 'btnMinus'
		,tooltip : '���'
		,text : '-'
});
	obj.btnSymbolMulti = new Ext.Button({
		id : 'btnMulti'
		,tooltip : '���'
		,text : '*'
});
	obj.btnSymbolDivide = new Ext.Button({
		id : 'btnDivide'
		,tooltip : '���'
		,text : '/'
});
	obj.btnSymbolAnd = new Ext.Button({
		id : 'btnAnd'
		,tooltip : '��'
		,text : '.and.'
});
	obj.btnSymbolOr = new Ext.Button({
		id : 'btnOr'
		,tooltip : '��'
		,text : '.or.'
});
	obj.btnSymbolRight = new Ext.Button({
		id : 'btnRight'
		,tooltip : '������'
		,text : ')'
});
	obj.btnSymbolLeft = new Ext.Button({
		id : 'btnLeft'
		,tooltip : '������'
		,text : '('
});
	obj.pnCalcSymbol = new Ext.Panel({
		id : 'pnCalcSymbol'
		,buttonAlign : 'center'
		,bodyStyle : 'padding:20px'
		,defaults : {width:50}
		,title : '�������'
		,collapsible : true
		,layoutConfig : {columns: 4}
		,layout : 'table'
		,frame : true
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
		,height : 300
		,RootNodeCaption : '������'
		,autoHeight : true
		,buttonAlign : 'center'

		,loader : obj.tvPackageTreeLoader,
		root : new Ext.tree.AsyncTreeNode({id:'0', text:'������'})

});
	obj.pnFunctionLib = new Ext.Panel({
		id : 'pnFunctionLib'
		,buttonAlign : 'center'
		,title : '������'
		,collapsible : true
		,layout : 'fit'
		,items:[
			obj.tvPackage
		]
	});
	obj.frmEditor = new Ext.form.FormPanel({
		id : 'frmEditor'
		,buttonAlign : 'center'
		,labelWidth : 80
		,labelAlign : 'right'
		,height : 200
		,layout : 'form'
		,items:[
			obj.pnExpression
			,obj.pnCalcSymbol
			,obj.pnFunctionLib
		]
	});
	/*obj.Window1 = new Ext.Window({
		id : 'Window1'
		,height : 400
		,buttonAlign : 'center'
		,width : 600
		,layout : 'fit'
		,items:[
			obj.FormPanel2
		]
	});*/
	InitExpressionEditorEvent(obj);
	//�¼��������
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
  return obj;
}

