function InitViewport(SubCatID){
	var obj = new Object();
	/*********************************************************************
	/����Ϊ�����Ŀά��������
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
			,{header: '����', width: 50, dataIndex: 'IDCode', sortable: false}
			,{header: '����', width: 150, dataIndex: 'IDDesc', sortable: false}
			,{header: '����ʽ', width: 150, dataIndex: 'IDExpression', sortable: false}
			,{header: '�ȼ�', width: 40, dataIndex: 'ItemGroup', sortable: false}
			,{header: '����', width: 40, dataIndex: 'ItemScore', sortable: false}
			,{header: '�Ƿ�<br>��Ч', width: 40, dataIndex: 'ItemActiveDesc', sortable: false}
			//,{header: '�Ƿ��<br>������', width: 50, dataIndex: 'ItemAbsoluteDesc', sortable: false}
			//,{header: '�Ƿ���<br>������', width: 50, dataIndex: 'ItemIsSensitiveDesc', sortable: false}
			//,{header: '�Ƿ���<br>������', width: 50, dataIndex: 'ItemIsSpecificityDesc', sortable: false}
			//,{header: '�Ƿ���<br>��һ��', width: 50, dataIndex: 'ItemIsRunOnceDesc', sortable: false}
			,{header: '��������', width: 100, dataIndex: 'AdmTypeDesc', sortable: false}
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
		,fieldLabel : '����ʽ'
		,labelSeparator :''
		/* removed by wuqk 2012-09-13  �ؼ��Ѹ��� Ϊ RichTextBoxCtl.CAB*/
		//modify by PanLei 2011-10-21 ����classid, ���������ĵĺ����ؼ�����ʽ�����޷�ʹ�õ�����
		,html : "<OBJECT id='txtExpression' classid='clsid:8BD21D10-EC42-11CE-9E0D-00AA006002F3' codebase='RICHTX32.OCX' width='98.5%' height='55' VIEWASTEXT><PARAM NAME='ScrollBars' VALUE='3'></OBJECT>"
		//,html : "<OBJECT id='txtExpression' classid='CLSID:F4DB9267-4DFA-40C7-BF0E-819D4CE239D5' codebase='../addins/client/RichTextBoxCtl.CAB#version=1,0,0,0' width='98.5%' height='55' VIEWASTEXT><PARAM NAME='ScrollBars' VALUE='3'></OBJECT>"
	});

	
	obj.btnFind = new Ext.Button({
		id : 'btnFind'
		,iconCls : 'icon-find'
		,anchor : '99%'
		,text : '��ѯ'
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
	obj.ItemIsActive = new Ext.form.Checkbox({
		id : 'ItemIsActive'
		,checked : true
		,boxLabel : '�Ƿ���Ч'
	});
	obj.ItemIsAbsolute = new Ext.form.Checkbox({
		id : 'ItemIsAbsolute'
		,checked : false
		,boxLabel : '��������'
	});
	
	obj.ItemIsSensitive = new Ext.form.Checkbox({
		id : 'ItemIsSensitive'
		,checked : false
		,boxLabel : '����������'
	});

	obj.ItemIsSpecificity = new Ext.form.Checkbox({
		id : 'ItemIsSpecificity'
		,checked : false
		,boxLabel : '����������'
	});	
	obj.ItemIsRunOnce = new Ext.form.Checkbox({
		id : 'ItemIsRunOnce'
		,checked : false
		,boxLabel : 'ֻ����һ��'
	});		
	
	obj.ItemScore = new Ext.form.NumberField({
		id : 'ItemScore'
		,fieldLabel : '����'
		,labelSeparator :''
		,anchor : '99%'
		,allowDecimals:false
		,nanText : 'ֻ������������!'
	});
	
	obj.cbgAdmType = new Ext.form.CheckboxGroup({
		id : 'cbgAdmType'
		,fieldLabel : '��������'
		,labelSeparator :''
		,xtype : 'checkboxgroup'
		,columns : 3
		,items : [
			{id : 'cbgAdmType-O', boxLabel : '����', name : 'cbgAdmType-O', inputValue : 'O', checked : false}
			,{id : 'cbgAdmType-E', boxLabel : '����', name : 'cbgAdmType-E', inputValue : 'E', checked : false}
			,{id : 'cbgAdmType-I', boxLabel : 'סԺ', name : 'cbgAdmType-I', inputValue : 'I', checked : false}
		]
		,width : 200
		,height : 22
	});
	
	var DataGrade = [['1','һ��'],['2','����'],['3','����']]; 
	var StoreGrade = new Ext.data.SimpleStore({fields:['key','value'],data:DataGrade});
	obj.GradeCombo=new Ext.form.ComboBox({
		fieldLabel:'�ȼ�'
		,labelSeparator :''
		,id:"grade"
		,displayField:'value'
		,valueField:'key'
		,store: StoreGrade
		//,typeAhead: true
		//,selectOnFocus:true,
		,emptyText:'ѡ��ȼ�...'
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
		,RootNodeCaption : '������'
		//,autoScroll : true
		,buttonAlign : 'center'
		,loader : obj.tvPackageTreeLoader
		,root : new Ext.tree.AsyncTreeNode({id:'-root-', text:'������'})
	});
	obj.RightPanel = new Ext.Panel({
		id : 'RightPanel'
		,buttonAlign : 'center'
		,columnWidth : .30
		,height : 280
		//,frame : true     //�޸�IE11�Ǽ����º����ⲻ��ʾ����
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
	/�����Ŀ:����ҽ����
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
			,{header: 'ҽ������', width: 200, dataIndex: 'ArcimDesc', sortable: true}
			//,{header: 'ҽ������', width: 100, dataIndex: 'ORCATDesc', sortable: true}
			,{header: 'ҽ������', width: 80, dataIndex: 'ARCICDesc', sortable: true}
		]
		,plugins : obj.ARCIMListCheckCol
		,viewConfig : {
			forceFit : true
		}
	});
	obj.OEDesc = new Ext.form.TextField({
		id : 'OEDesc'
		,fieldLabel : 'ҽ������'
		,labelSeparator :''
		,anchor : '99%'
	});
	obj.OEBtnFind = new Ext.Button({
		id : 'OEBtnFind'
		,iconCls : 'icon-find'
		,anchor : '99%'
		,text : '��ѯ'
	});
	obj.OEBtnUpdate = new Ext.Button({
		id : 'OEBtnUpdate'
		,iconCls : 'icon-add'
		,anchor : '99%'
		,text : '����'
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
		,title : 'ҽ��'
		,layout : 'border'
		,items:[
			obj.ARCIMList
			,obj.OEManage
		]
	});
	
	/*********************************************************************
	/�����Ŀ:������Ͽ�
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
			,{header: '��ϱ���', width: 80, dataIndex: 'ICD9CMCode', sortable: true}
			,{header: '�������', width: 200, dataIndex: 'Descs', sortable: true}
		]
		,plugins : obj.MRCICDDxListCheckCol
		,viewConfig : {
			forceFit : true
		}
	});
	obj.MRCICD9CMCode = new Ext.form.TextField({
		id : 'MRCICD9CMCode'
		,fieldLabel : '��ϱ���'
		,labelSeparator :''
		,anchor : '99%'
	});
	obj.DBtnFind = new Ext.Button({
		id : 'DBtnFind'
		,iconCls : 'icon-find'
		,anchor : '99%'
		,text : '��ѯ'
	});
	obj.DBtnUpdate = new Ext.Button({
		id : 'DBtnUpdate'
		,iconCls : 'icon-update'
		,anchor : '99%'
		,text : '����'
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
		,title : '���'
		,layout : 'border'
		,items:[
			obj.MRCICDDxList
			,obj.MRCICDDxManage
		]
	});
	
	/*********************************************************************
	/�����Ŀ:��������ֵ
	/*********************************************************************/
	obj.LabCode = new Ext.form.TextField({
		id : 'LabCode'
		,fieldLabel : '����'
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
		,fieldLabel : '����'
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
		,fieldLabel : 'ʵ����'
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
		,fieldLabel : '������Ŀ'
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
		,fieldLabel : '������'
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
		,fieldLabel : 'ֵ'
		,labelSeparator :''
		,valueField : 'Code'
		,triggerAction : 'all'
		,anchor : '95%'
		//,forceSelection : true
	});
	obj.LabResume = new Ext.form.TextField({
		id : 'LabResume'
		,fieldLabel : '��ע'
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
		,text : '����'
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
		,title : '����'
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
