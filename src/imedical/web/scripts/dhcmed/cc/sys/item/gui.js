function InitViewport(SubCatID){
	var obj = new Object();
	/*********************************************************************
	/以下为监控项目维护主窗体
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
			,{name: 'CDDesc', mapping: 'CDDesc'}
			,{name: 'IDSubCatDr', mapping: 'IDSubCatDr'}
			,{name: 'IDExpression', mapping: 'IDExpression'}
			,{name: 'IDRange', mapping: 'IDRange'}
			,{name: 'IDResume', mapping: 'IDResume'}
			,{name: 'ItemGrade', mapping: 'ItemGrade'}
			,{name: 'ItemScore', mapping: 'ItemScore'}
			,{name: 'ItemGroup', mapping: 'ItemGroup'}
			,{name: 'ItemActive', mapping: 'ItemActive'}
			,{name: 'ItemActiveDesc', mapping: 'ItemActiveDesc'}
			,{name: 'ItemAbsolute', mapping: 'ItemAbsolute'}
			,{name: 'ItemAbsoluteDesc', mapping: 'ItemAbsoluteDesc'}
			,{name: 'ItemIsSensitive', mapping: 'ItemIsSensitive'}
			,{name: 'ItemIsSensitiveDesc', mapping: 'ItemIsSensitiveDesc'}
			,{name: 'ItemIsSpecificity', mapping: 'ItemIsSpecificity'}
			,{name: 'ItemIsSpecificityDesc', mapping: 'ItemIsSpecificityDesc'}
			,{name: 'ItemIsRunOnce', mapping: 'ItemIsRunOnce'}
			,{name: 'ItemIsRunOnceDesc', mapping: 'ItemIsRunOnceDesc'}
			,{name: 'AdmType', mapping: 'AdmType'}
			,{name: 'AdmTypeDesc', mapping: 'AdmTypeDesc'}
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
			,{header: '代码', width: 50, dataIndex: 'IDCode', sortable: false}
			,{header: '描述', width: 150, dataIndex: 'IDDesc', sortable: false}
			,{header: '表达式', width: 150, dataIndex: 'IDExpression', sortable: false}
			,{header: '等级', width: 40, dataIndex: 'ItemGroup', sortable: false}
			,{header: '分数', width: 40, dataIndex: 'ItemScore', sortable: false}
			,{header: '是否<br>有效', width: 40, dataIndex: 'ItemActiveDesc', sortable: false}
			//,{header: '是否绝<br>对条件', width: 50, dataIndex: 'ItemAbsoluteDesc', sortable: false}
			//,{header: '是否敏<br>感条件', width: 50, dataIndex: 'ItemIsSensitiveDesc', sortable: false}
			//,{header: '是否特<br>异条件', width: 50, dataIndex: 'ItemIsSpecificityDesc', sortable: false}
			//,{header: '是否运<br>行一次', width: 50, dataIndex: 'ItemIsRunOnceDesc', sortable: false}
			,{header: '就诊类型', width: 100, dataIndex: 'AdmTypeDesc', sortable: false}
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
		/* removed by wuqk 2012-09-13  控件已更换 为 RichTextBoxCtl.CAB*/
		//modify by PanLei 2011-10-21 更改classid, 解决监控中心的函数控件表达式表单无法使用的问题
		,html : "<OBJECT id='txtExpression' classid='clsid:8BD21D10-EC42-11CE-9E0D-00AA006002F3' codebase='RICHTX32.OCX' width='98.5%' height='55' VIEWASTEXT><PARAM NAME='ScrollBars' VALUE='3'></OBJECT>"
		//,html : "<OBJECT id='txtExpression' classid='CLSID:F4DB9267-4DFA-40C7-BF0E-819D4CE239D5' codebase='../addins/client/RichTextBoxCtl.CAB#version=1,0,0,0' width='98.5%' height='55' VIEWASTEXT><PARAM NAME='ScrollBars' VALUE='3'></OBJECT>"
	});

	
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,anchor : '99%'
		,text : '查询'
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
	obj.ItemIsActive = new Ext.form.Checkbox({
		id : 'ItemIsActive'
		,checked : true
		,boxLabel : '是否有效'
	});
	obj.ItemIsAbsolute = new Ext.form.Checkbox({
		id : 'ItemIsAbsolute'
		,checked : false
		,boxLabel : '绝对条件'
	});
	
	obj.ItemIsSensitive = new Ext.form.Checkbox({
		id : 'ItemIsSensitive'
		,checked : false
		,boxLabel : '敏感性条件'
	});

	obj.ItemIsSpecificity = new Ext.form.Checkbox({
		id : 'ItemIsSpecificity'
		,checked : false
		,boxLabel : '特异性条件'
	});	
	obj.ItemIsRunOnce = new Ext.form.Checkbox({
		id : 'ItemIsRunOnce'
		,checked : false
		,boxLabel : '只运行一次'
	});		
	
	obj.ItemScore = new Ext.form.NumberField({
		id : 'ItemScore'
		,fieldLabel : '分数'
		,labelSeparator :''
		,anchor : '99%'
		,allowDecimals:false
		,nanText : '只允许输入整数!'
	});
	
	obj.cbgAdmType = new Ext.form.CheckboxGroup({
		id : 'cbgAdmType'
		,fieldLabel : '就诊类型'
		,labelSeparator :''
		,xtype : 'checkboxgroup'
		,columns : 3
		,items : [
			{id : 'cbgAdmType-O', boxLabel : '门诊', name : 'cbgAdmType-O', inputValue : 'O', checked : false}
			,{id : 'cbgAdmType-E', boxLabel : '急诊', name : 'cbgAdmType-E', inputValue : 'E', checked : false}
			,{id : 'cbgAdmType-I', boxLabel : '住院', name : 'cbgAdmType-I', inputValue : 'I', checked : false}
		]
		,width : 200
		,height : 22
	});
	
	var DataGrade = [['1','一级'],['2','二级'],['3','三级']]; 
	var StoreGrade = new Ext.data.SimpleStore({fields:['key','value'],data:DataGrade});
	obj.GradeCombo=new Ext.form.ComboBox({
		fieldLabel:'等级'
		,labelSeparator :''
		,id:"grade"
		,displayField:'value'
		,valueField:'key'
		,store: StoreGrade
		//,typeAhead: true
		//,selectOnFocus:true,
		,emptyText:'选择等级...'
		//,allowBlank:true
		,mode:'local'
		//,editable:true 
		,anchor : '99%'
	});
	
	obj.LeftPanel = new Ext.Panel({
		id : 'LeftPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,height : 280
		,columnWidth : .70
		,layout : 'form'
		,frame : true
		,items:[
			{
				layout : 'column',
				items : [
					{
						width:180
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.IDCode]
					},{
						width:130
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.GradeCombo]
					},{
						width:130
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 40
						,items: [obj.ItemScore]
					}
				]
			},{
				layout : 'column',
				items : [
					{
						width:150
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 60
						,items: [obj.ItemIsActive]
					},{
						width:280
						,layout : 'form'
						,labelAlign : 'right'
						,labelWidth : 70
						,items: [obj.cbgAdmType]
					}
				]
			}
			,obj.IDDesc
			,obj.IDResume
			,obj.pnExpression
			,obj.pnCalcSymbol
		]
		,buttons:[
			//obj.btnFind
			obj.btnAdd
			,obj.btnDelete
		]
	});
	obj.tvPackageTreeLoader = new Ext.tree.TreeLoader({
		nodeParameter : 'Arg1',
		dataUrl : ExtToolSetting.TreeQueryPageURL,
		baseParams : {
			ClassName : 'DHCMed.CCService.Sys.CtrlItmTree',
			QueryName : 'BuildMethodAppJson',
			Arg2 : '',
			ArgCnt : 2
		}
	});
	obj.tvPackage = new Ext.tree.TreePanel({
		id : 'tvPackage'
		,RootNodeCaption : '函数库'
		//,autoScroll : true
		,buttonAlign : 'center'
		,loader : obj.tvPackageTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'-root-', text:'函数库'})
	});
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .30
		,height : 280
		//,frame : true     //修复IE11非兼容下函数库不显示问题
		,autoScroll : true
		,items:[
			obj.tvPackage
		]
	});
	
	obj.IDEditPanel = new Ext.Panel({
		id : 'IDEditPanel'
		,height : 295
		,buttonAlign : 'center'
		,region : 'south'
		,frame : true
		,layout : 'column'
		,items:[
			obj.LeftPanel
			,obj.RightPanel
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
	/监控项目:关联医嘱项
	/*********************************************************************/
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
			,{header: '医嘱名称', width: 200, dataIndex: 'ArcimDesc', sortable: true}
			//,{header: '医嘱大类', width: 100, dataIndex: 'ORCATDesc', sortable: true}
			,{header: '医嘱子类', width: 80, dataIndex: 'ARCICDesc', sortable: true}
		]
		,plugins : obj.ARCIMListCheckCol
		,viewConfig : {
			forceFit : true
		}
	});
	obj.OEDesc = new Ext.form.TextField({
		id : 'OEDesc'
		,fieldLabel : '医嘱名称'
		,labelSeparator :''
		,anchor : '99%'
	});
	obj.OEBtnFind = new Ext.Button({
		id : 'OEBtnFind'
		,iconCls : 'icon-find'
		,anchor : '99%'
		,text : '查询'
	});
	obj.OEBtnUpdate = new Ext.Button({
		id : 'OEBtnUpdate'
		,iconCls : 'icon-add'
		,anchor : '99%'
		,text : '添加'
	});
	obj.OEManage = new Ext.Panel({
		id : 'OEManage'
		,height : 75
		,region : 'south'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,frame : true
		,layout : 'form'
		,items:[
			obj.OEDesc
		]
		,buttons:[
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
	
	/*********************************************************************
	/监控项目:关联诊断库
	/*********************************************************************/
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
			,{header: '诊断编码', width: 80, dataIndex: 'ICD9CMCode', sortable: true}
			,{header: '诊断名称', width: 200, dataIndex: 'Descs', sortable: true}
		]
		,plugins : obj.MRCICDDxListCheckCol
		,viewConfig : {
			forceFit : true
		}
	});
	obj.MRCICD9CMCode = new Ext.form.TextField({
		id : 'MRCICD9CMCode'
		,fieldLabel : '诊断编码'
		,labelSeparator :''
		,anchor : '99%'
	});
	obj.DBtnFind = new Ext.Button({
		id : 'DBtnFind'
		,iconCls : 'icon-find'
		,anchor : '99%'
		,text : '查询'
	});
	obj.DBtnUpdate = new Ext.Button({
		id : 'DBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '99%'
		,text : '添加'
	});
	obj.MRCICDDxManage = new Ext.Panel({
		id : 'MRCICDDxManage'
		,height : 75
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,frame : true
		,region : 'south'
		,layout : 'form'
		,items:[
			obj.MRCICD9CMCode
		]
		,buttons:[
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
	
	/*********************************************************************
	/监控项目:关联检验值
	/*********************************************************************/
	obj.LabCode = new Ext.form.TextField({
		id : 'LabCode'
		,fieldLabel : '代码'
		,labelSeparator :''
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
		,labelSeparator :''
		,anchor : '95%'
		,disabled : true
	});
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
		,labelSeparator :''
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
			{name: 'TestCode', mapping: 'TestCode'}
			,{name: 'TestName', mapping: 'TestName'}
		])
	});
	obj.LabItmDesc = new Ext.form.ComboBox({
		id : 'LabItmDesc'
		,minChars : 0
		,displayField : 'TestName'
		,fieldLabel : '检验项目'
		,labelSeparator :''
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
		,labelSeparator :''
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
		,labelSeparator :''
		,valueField : 'Code'
		,triggerAction : 'all'
		,anchor : '95%'
		//,forceSelection : true
	});
	obj.LabResume = new Ext.form.TextField({
		id : 'LabResume'
		,fieldLabel : '备注'
		,labelSeparator :''
		,anchor : '95%'
	});
	obj.LabBtnAddItem = new Ext.Button({
		id : 'LabBtnAddItem'
		,text : '<<<'
	});
	obj.LabBtnDelItem = new Ext.Button({
		id : 'LabBtnDelItem'
		,text : '>>>'
	});
	obj.CenterPanel = new Ext.Panel({
		id : 'CenterPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,labelWidth : 60
		,layout : 'form'
		,items:[
			obj.LabCode
			,obj.LabDesc
			,obj.LabRoom
			,obj.LabItmDesc
			,obj.LabOperChar
			,obj.LabValue
			,obj.LabRowid
		]
		,buttons:[
			obj.LabBtnAddItem
			,obj.LabBtnDelItem
		]
	});
	obj.LabBtnUpdate = new Ext.Button({
		id : 'LabBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '99%'
		,text : '添加'
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
		,layout : 'form'
		,items:[
			obj.CenterPanel
		]
		,buttons:[
			obj.LabBtnUpdate
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
			obj.LabManage
		]
	});
	obj.tabPanel = new Ext.TabPanel({
		id : 'Panel10'
		,activeTab : 2
		,buttonAlign : 'center'
		,items:[
			obj.ARCIMEditPanel
			,obj.MRCICDDxPanel
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
		,minWidth : 250
		,maxWidth : 350
		,width : 300
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
			param.ClassName = 'DHCMed.CCService.Sys.ItemDicSrv';
			param.QueryName = 'QryItems';
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
	obj.ARCIMListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Sys.CommonSrv';
			param.QueryName = 'QryArcimByAlias';
			param.Arg1 = obj.OEDesc.getRawValue();
			param.ArgCnt = 1;
	});
	obj.ARCIMListStore.load({});
	obj.MRCICDDxListStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.Base.MRCICDDx';
			param.QueryName = 'QueryByDescAlias';
			param.Arg1 = obj.MRCICD9CMCode.getRawValue();
			param.ArgCnt = 1;
	});
	obj.MRCICDDxListStore.load({});
	obj.LabRoomStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Sys.CommonSrv';
			param.QueryName = 'GetDepartment';
			param.ArgCnt = 0;
	});
	obj.LabRoomStore.load({});
	obj.LabItmDescStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Sys.CommonSrv';
			param.QueryName = 'GetTestCode';
			param.Arg1 = obj.LabRoom.getValue();
			param.Arg2 = '';
			param.Arg3 = obj.LabItmDesc.getRawValue();
			param.ArgCnt = 3;
	});
	obj.LabItmDescStore.load({});
	obj.LabOperCharStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Sys.CommonSrv';
			param.QueryName = 'QryLabCompareOperator';
			param.Arg1 = 'CompareOperator';
			param.ArgCnt = 1;
	});
	obj.LabOperCharStore.load({});
	obj.LabValueStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.CCService.Sys.CommonSrv';
			param.QueryName = 'GetValueListByCode';
			param.Arg1 = obj.LabItmDesc.getValue();
			param.ArgCnt = 1;
	});
	obj.LabValueStore.load({});
	
	InitViewportEvent(obj);
	obj.LoadEvent(arguments);
	return obj;
}

