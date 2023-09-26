function InitViewport1(){
	var obj = new Object();
	
	
	obj.btnNew =new Ext.Toolbar.Button({ //new Ext.Button({
		id : 'btnNew'
		,iconCls : 'icon-new'
		,text : '�½�'
	});
	obj.btnEdit = new Ext.Toolbar.Button({ //new Ext.Toolbar.Button({
		id : 'btnEdit'
		,iconCls : 'icon-pencil'
		,text : '�༭'
	});
	obj.btnDelete = new Ext.Toolbar.Button({ //new Ext.Button({
		id : 'btnDelete'
		,iconCls : 'icon-delete'
		,text : 'ɾ��'
	});
	
	obj.ViewPanel = new Ext.Panel({
		id : 'ViewPanel'
		,height : 100
		,buttonAlign : 'center'
		,region : 'north'
		,frame : true
		,title : '�Զ���ҳǩ'
		,layout : 'form'
		,items:[]
		,tbar:[
			obj.btnNew
			,obj.btnEdit
			,obj.btnDelete
		]
	});
	
	obj.GridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.GridPanelStore = new Ext.data.Store({
		proxy: obj.GridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'Rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'Rowid', mapping: 'Rowid'}
			,{name: 'Code', mapping: 'Code'}
			,{name: 'Description', mapping: 'Description'}
			,{name: 'IsActive', mapping: 'IsActive'}
			,{name: 'Resume', mapping: 'Resume'}
		])
	});
	obj.GridPanelCheckCol = new Ext.grid.CheckColumn({header:'', dataIndex: 'checked', width: 50 });
	
	obj.GridPanel = new Ext.grid.GridPanel({
		id : 'GridPanel'
		,header : true
		,buttonAlign : 'center'
		,store : obj.GridPanelStore
		//,height : 550
		,loadMask : true
		,region : 'center'
		,frame : true
		,viewConfig: {forceFit: true}
		,columns: [
			new Ext.grid.RowNumberer()
			,{header: '����', width: 100, dataIndex: 'Code', sortable: true}
			,{header: '����', width: 120, dataIndex: 'Description', sortable: true}
			,{header: '�Ƿ���Ч', width: 120, dataIndex: 'IsActive', sortable: true}
			,{header: '��ע', width: 120, dataIndex: 'Resume', sortable: true}
		]
		,tbar:[obj.btnNew,obj.btnEdit,obj.btnDelete]
		/*,bbar: new Ext.PagingToolbar({
			//pageSize : 20,
			store : obj.GridPanelStore,
			displayMsg: '�ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})*/
	});
	obj.Viewport1 = new Ext.Viewport({
		id : 'Viewport1'
		,layout : 'border'
		,items:[
			obj.GridPanel
		]
	});
	obj.GridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.PortletsSrv';
			param.QueryName = 'QryPortlets';
			param.ArgCnt = 0;
	});
	obj.GridPanelStore.load({
	/*params : {
			start:0
			,limit:20
		}
	*/	});
	
	InitViewport1Event(obj);
	//�¼��������
	obj.GridPanel.on("rowclick", obj.GridPanel_rowclick, obj);
	obj.GridPanel.on("rowdblclick", obj.GridPanel_rowdblclick, obj);
	obj.btnNew.on("click", obj.btnNew_click, obj);
	obj.btnEdit.on("click", obj.btnEdit_click, obj);
	obj.btnDelete.on("click", obj.btnDelete_click, obj);
	obj.LoadEvent(arguments);
	return obj;
}
function InitWinEdit(){
	var obj = new Object();
	
	obj.Rowid = new Ext.form.TextField({
		id : 'Rowid'
		,hidden : true
	});
	obj.winfPCode = new Ext.form.TextField({
		id : 'Code'
		,allowBlank : false
		,fieldLabel :'����'
		,anchor : '95%'
	});
	obj.winfPDescription = new Ext.form.TextField({
		id : 'Description'
		,allowBlank : false
		,fieldLabel : '����'
		,anchor : '95%'
	});
	obj.winfPAutoRefreash = new Ext.form.Checkbox({
		id : 'AutoRefreash'
		,fieldLabel : '�Զ�ˢ��'
		,height : 25
		,anchor : '95%'
	});
	obj.winfPFrequency = new Ext.form.ComboBox({
		hiddenName : 'Frequency'
		,fieldLabel : 'Ƶ��'
		,anchor : '95%'
		,mode: 'local'
		,triggerAction : 'all'
		//,disabled: true
		,store: new Ext.data.ArrayStore({
			fields: ['key', 'text'],
			data: [[5, '5����'], [15, '15����'], [30, '30����'], [60, '60����']]
		}),
		valueField: 'key',
		displayField: 'text'
   });
	obj.winfPResume = new Ext.form.TextField({
		id : 'Resume'
		,fieldLabel : '��ע'
		,anchor : '95%'
	});
	obj.winfPIsActive = new Ext.form.Checkbox({
		id : 'IsActive'
		,fieldLabel : '��Ч'
		,height : 25
		,anchor : '95%'
	});
	obj.winfPHeight = new Ext.form.NumberField({
		id : 'Height'
		,fieldLabel : '�߶�'
		,anchor : '95%'
	});
	obj.winfPMessage = new Ext.form.TextField({
		id : 'Message'
		,fieldLabel : '��ʾ��Ϣ'
		,anchor : '95%'
	});

	obj.winfPMsgClassMethod = new Ext.form.TextField({
		id : 'MsgClassMethod'
		,fieldLabel : '�෽��'
		,anchor : '95%'
		,emptyText:"className||classMethod||args(����֮����','���)"
	});
	obj.winfPProductDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.winfPProductDrStore = new Ext.data.Store({
		proxy: obj.winfPProductDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'ProName', mapping: 'ProName'}
		])
	});
	obj.winfPProductDr = new Ext.form.ComboBox({
		id : 'winfPProductDr'
		,store : obj.winfPProductDrStore
		,minChars : 1
		,displayField : 'ProName'
		,fieldLabel : '������Ʒ'
		,triggerAction : 'all'
		,anchor : '95%'
		,valueField : 'rowid'
	});
	obj.winfPMsgMenuDrStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.winfPMsgMenuDrStore = new Ext.data.Store({
		proxy: obj.winfPMsgMenuDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'MenuCode', mapping: 'MenuCode'}
			,{name: 'MenuCaption', mapping: 'MenuCaption'}
		])
	});

	obj.winfPMsgMenuDr = new Ext.form.ComboBox({
		id : 'MsgMenuDr'
		,store : obj.winfPMsgMenuDrStore
		//,minChars : 0  //�û���������������ַ��� (mode = 'remote'Ĭ��Ϊ4 �������mode = 'local' ʱΪ0�����editable = false ������Ӧ�ô�������)
		,displayField : 'MenuCaption'
		,fieldLabel : '���Ӳ˵�'
		//,editable:false
		,triggerAction : 'all'
		,valueField : 'rowid'
		,anchor : '95%'
	});
	obj.winfPMsgURL = new Ext.form.TextField({
		id : 'MsgURL'
		,fieldLabel : '���ӵ�ַ'
		,anchor : '95%'
	});
	
	obj.winfPQueryName = new Ext.form.TextField({
		id : 'QueryName'
		,fieldLabel : 'Query'
		,anchor : '95%'
		,emptyText:'className||queryName'
	});
	obj.winfPDtlMenuStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.winfPDtlMenuStore = new Ext.data.Store({
		proxy: obj.winfPMsgMenuDrStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		[
			{name: 'checked', mapping : 'checked'}
			,{name: 'rowid', mapping: 'rowid'}
			,{name: 'MenuCode', mapping: 'MenuCode'}
			,{name: 'MenuCaption', mapping: 'MenuCaption'}
		])
	});

	obj.winfPDtlMenu = new Ext.form.ComboBox({
		id : 'DtlMenuDr'
		,store : obj.winfPMsgMenuDrStore
		//,minChars : 0
		,displayField : 'MenuCaption'
		,fieldLabel : '���Ӳ˵�'
		//,editable : true
		,triggerAction : 'all'
		,valueField : 'rowid'
		,anchor : '95%'
	});

	obj.winfPDtlURL = new Ext.form.TextField({
		id : 'DtlURL'
		,fieldLabel : '���ӵ�ַ'
		,anchor : '95%'
	});
	obj.winfPDtlShowType = new Ext.form.RadioGroup({
		id : 'DtlShowType',
		height : 23,
		fieldLabel: '��ʾ����',
		columns: 'auto', //��վһ�������С����12px����12px�µ�ѡ��͸�ѡ�����ִ�ֱ���жԲ��룬�ο�http://www.cnblogs.com/yjzhu/archive/2012/12/07/2807737.html
		//disabled: true,
		items: [
		    {boxLabel: '���',  name: 'DtlShowType', inputValue: 'grid',style:"vertical-align:middle; margin-top:-2px;"},
		    {boxLabel: 'ͼ��',  name: 'DtlShowType', inputValue: 'chart', checked: true,style:"vertical-align:middle; margin-top:-2px;"},
		    {boxLabel: '��ϵ��ͼ��',  name: 'DtlShowType', inputValue: 'mschart',style:"vertical-align:middle; margin-top:-2px;"}
		]
	});
	//��ϸ���ñ������
	var checkCol = new Ext.grid.CheckColumn({
       header: '�Ƿ�<br>��ʾ',
       dataIndex: 'isHidden',
       width: 55
    });
	obj.editGridPanelStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.editGridPanelStore = new Ext.data.Store({
		proxy: obj.editGridPanelStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'colName'
		}, 
		[
			//{name: 'checked', mapping : 'checked'}
			{name: 'colName', mapping: 'colName'}
			,{name: 'dataIndex', mapping: 'dataIndex'}
			,{name: 'colHeader', mapping: 'colHeader'}
			,{name: 'isHidden', mapping: 'isHidden', type : 'int'}
		])
	});

	obj.editGridPanel = new Ext.grid.EditorGridPanel({
		id : 'editGridPanel'
		//,header : true   //Panel��headerElement. ֻ���� ��Ԫ�ر��������� title�� tools 
		//,buttonAlign : 'center'
		,store : obj.editGridPanelStore
		,height : 210
		//,autoHeight : true
		//,autoWidth : true
		,loadMask : true
		//,region : 'center'  //������ֻ���ڸ����չ����һ������ΪBorderLayout��������
		//,frame : true      //Ĭ�������ʹ�� false ����Ⱦ�򵥵�1px�������α߿�
		,plugins:checkCol
		,clicksToEdit: 1
		,hidden: true
		,viewConfig: {forceFit: true}
		,columns: [
				new Ext.grid.RowNumberer()
				,{header: '����', width: 100, dataIndex: 'colName', sortable: true,editor: {
				          xtype: 'textfield',
				          allowBlank: false
				      }}
				,{header: 'Query<br>��������', width: 120, dataIndex: 'dataIndex', sortable: true,editor: {
				          xtype: 'textfield',
				          allowBlank: false
				      }}
				,{header: '�б���', width: 120, dataIndex: 'colHeader', sortable: true,editor: {
				          xtype: 'textfield',
				          allowBlank: false
				      }}    
				,checkCol
		]	
		,tbar:['-',
				{
					text: '����',
					iconCls: 'icon-add',			
					handler: function(){
						obj.onAdd();
					}
		   	},'-', {
					text: 'ɾ��',
					iconCls: 'icon-delete',				
					handler: function(){
						obj.onDelete();	
					}
				},'-'
			]
	});
	//��ϸ����ͼ������
	obj.showcCType=new Ext.form.ComboBox({
		id : 'showcCType'
		,typeAhead: true
		,triggerAction: 'all'
		, mode: 'local'
		,editable:false
		,store: new Ext.data.ArrayStore({
				fields: [
				        'myId',
				        'displayText'
				    			],
				data: [[1, '��״ͼ'], [2, '��״ͼ'],[3, '����ͼ']]
		})
		,valueField: 'myId'
		,displayField: 'displayText'
		,fieldLabel : 'ͼ��'
		,anchor : '95%'
	});
  obj.showcCX=new Ext.form.TextField({
		id : 'showcCX'
		,fieldLabel : '������Ϣ(X��)'
		,anchor : '95%'
	});
  obj.showcCY=new Ext.form.TextField({
		id : 'showcCY'
		,fieldLabel : '��ֵ��Ϣ(Y��)'
		,anchor : '95%'
	});
	obj.showcCXIndex=new Ext.form.TextField({
			id : 'showcCXIndex'
			,fieldLabel : '��ӦQuery������'
			,anchor : '95%'
	});
	obj.showcCYIndex=new Ext.form.TextField({
			id : 'showcCYIndex'
			,fieldLabel : '��ӦQuery������'
			,anchor : '95%'
	});
	obj.shCol21 = new Ext.Panel({
		id : 'shCol21'
		//,buttonAlign : 'center'
		,columnWidth : 0.5
		,layout : 'form'
		,items:[
			obj.showcCX
			,obj.showcCY
			,obj.showcCType			      
		]
	});
	obj.shCol22 = new Ext.Panel({
		id : 'shCol22'
		//,buttonAlign : 'center'
		,columnWidth : 0.5
		,layout : 'form'
		,items:[
			obj.showcCXIndex
			,obj.showcCYIndex
		]
	});
  obj.pnShow2=new Ext.Panel({
		//id : 'pnShow2'
		//,buttonAlign : 'center'
		//,columnWidth : 0.5
		layout : 'column'
		,labelWidth: 75
		//,hidden: true
		,items:[		
			obj.shCol21
			,obj.shCol22
		]
	});
	//��ϸ���ö�ϵ��ͼ������
	obj.showcMX=new Ext.form.TextField({
		id : 'showcMX'
		,fieldLabel : '������Ϣ1(X��)'
		,anchor : '95%'
	});
	obj.showcMY=new Ext.form.TextField({
			id : 'showcMY'
			,fieldLabel : '��ֵ��Ϣ (Y��)'
			,anchor : '95%'
	});
	obj.showcMZ=new Ext.form.TextField({
			id : 'showcMZ'
			,fieldLabel : '������Ϣ2(Z��)'
			,anchor : '95%'
	});
	obj.showcMXIndex=new Ext.form.TextField({
			id : 'showcMXIndex'
			,fieldLabel : '��ӦQuery������'
			,anchor : '95%'
	});
	obj.showcMYIndex=new Ext.form.TextField({
			id : 'showcMYIndex'
			,fieldLabel : '��ӦQuery������'
			,anchor : '95%'
	});
	obj.showcMZIndex=new Ext.form.TextField({
			id : 'showcMZIndex'
			,fieldLabel : '��ӦQuery������'
			,anchor : '95%'
	});
	obj.showcMType=new Ext.form.ComboBox({
		id : 'showcMType'
		,typeAhead: true
		,triggerAction: 'all'
		, mode: 'local'
		,store: new Ext.data.ArrayStore({
          fields: [
                   'myId',
                   'displayText'
                  ],
          data: [[1, '����ͼ'], [2, '����ͼ']]
     })
		,valueField: 'myId'
		,displayField: 'displayText'
		,fieldLabel : 'ͼ������'
		,anchor : '95%'
	});
	obj.shCol11 = new Ext.Panel({
		id : 'shCol11'
		//,buttonAlign : 'center'
		,columnWidth : 0.5
		,layout : 'form'
		,items:[
			obj.showcMX
			,obj.showcMY
			,obj.showcMZ
			,obj.showcMType
		]
	});
	obj.shCol12 = new Ext.Panel({
		id : 'shCol12'
		//,buttonAlign : 'center'
		,columnWidth : 0.5
		,layout : 'form'
		,items:[
			obj.showcMXIndex
			,obj.showcMYIndex
			,obj.showcMZIndex
		]
	});
	obj.pnShow3=new Ext.Panel({
		//id : 'pnShow3'
		//,buttonAlign : 'center'
		//,columnWidth : 0.5
		labelWidth: 75
		,layout : 'column'
		,hidden: true
		,items: [
			obj.shCol11,
			obj.shCol12
		 ]
	});	
	obj.winfPDtlShowConfig = new Ext.form.FieldSet({
   		id : 'DtlShowConfigPanel'//�淶
   		,layout : 'form'
   		//,autoHeight : true
   		//,anchor : '95%'
   		//,hidden: true
  		//,disabled: true
   		//,fieldLabel : '��ʾ����'
   		,items : [
				obj.editGridPanel,
				//obj.pnShow1,
				obj.pnShow2,
				obj.pnShow3
   		]
   	});
  obj.pnCol11 = new Ext.Panel({
		id : 'pnCol11'
		,buttonAlign : 'center'
		,columnWidth : 0.5
		,layout : 'form'
		,items:[
			obj.winfPCode
			,obj.winfPAutoRefreash
			,obj.winfPHeight
			,obj.winfPResume
		]
	});
	obj.pnCol12 = new Ext.Panel({
		id : 'pnCol12'
		,buttonAlign : 'center'
		,columnWidth : 0.5
		,layout : 'form'
		,items:[
			obj.winfPDescription			
			,obj.winfPFrequency     
			,obj.winfPIsActive
			,obj.winfPProductDr
		]
	});
	obj.frmEdit1 = new Ext.form.FieldSet({
		id : 'frmEdit1'
		,width: 450
		//,height : 230	
		,buttonAlign : 'center'
		//,region : 'south'
		,title : '������Ϣ'
		,layout : 'column'
		,items:[
			obj.pnCol11
			,obj.pnCol12
		]
	});
		
	obj.winfTab = new Ext.TabPanel({
		activeTab: 0,
		plain:true,
		deferredRender: false,
		autoHeight : true,
		width: 450,
		items: 
		[{
				title : '��ʾ��Ϣ'
				,layout:'form'
				//,width: 460
				,height : 300	
				,frame : true
				//,layout : 'column'
				,items:[
						//obj.pnCol21
						//,obj.pnCol22
						obj.winfPMessage   
						,obj.winfPMsgURL
						,obj.winfPMsgClassMethod
						,obj.winfPMsgMenuDr
					]
			},{
				title : '��ϸ��Ϣ'
				,id:"1"
				,layout:'form'
				,frame : true
				//,width: 460
				,height : 300	
				//,layout : 'column'
				,items:[
					obj.winfPQueryName
					,obj.winfPDtlMenu
					,obj.winfPDtlURL
					,obj.winfPDtlShowType
					,obj.winfPDtlShowConfig
				]
			}
		]
  });

	obj.winfPanel = new Ext.form.FormPanel({
		id : 'winfPanel'
		,buttonAlign : 'center'
		,labelAlign : 'right'
		,autoScroll:true
		,labelWidth : 70
		,height : 480
		//,width : 500
		,region : 'center'
		//,renderTo : document.body
		,layout : 'form'
		,frame : true
		,items:[						 
            obj.frmEdit1
            ,obj.winfTab
            ,obj.Rowid
		]
	});
	obj.btnQuery = new Ext.Button({
		id : 'btnQuery'
		//,iconCls : 'icon-find'
		,text : '��ȡ���store'
		,hidden:true
	});
	obj.btnSave = new Ext.Button({
		id : 'btnSave'
		,iconCls : 'icon-save'
		,text : '����'
	});
	obj.btnCancel = new Ext.Button({
		id : 'btnCancel'
		,iconCls : 'icon-cancel'
		,text : '�ر�'
	});
	obj.WinEdit = new Ext.Window({
		id : 'WinEdit'
		,width : 500
		,plain : true
		,buttonAlign : 'center'
		//,height : 300
		,title : 'ҳǩ�༭'
		,layout : 'fit'
		,modal : true
		,items:[
			obj.winfPanel
		]
		,buttons:[
			obj.btnQuery,
			obj.btnSave
			,obj.btnCancel
		]
	});
	obj.winfPProductDrStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.ProductsSrv';
			param.QueryName = 'QueryProInfo';
			param.Arg1 = '';
			param.ArgCnt = 1;
	});
	obj.winfPProductDrStore.load({});
	obj.winfPMsgMenuDrStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MenusSrv';
			param.QueryName = 'FindMenuInfoFromCaption';
			param.Arg1 = obj.winfPProductDr.getValue();
			param.ArgCnt = 1;
	});
	//	obj.winfPMsgMenuDrStore.load({});
	obj.winfPDtlMenuStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.MenusSrv';
			param.QueryName = 'FindMenuInfoFromCaption';
			param.Arg1 = obj.winfPProductDr.getValue();
			param.ArgCnt = 1;
	});
	obj.editGridPanelStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'DHCMed.SSService.PortletsSrv';
			param.QueryName = 'GetGridInfoById';
			param.Arg1 = obj.Rowid.getValue();
			param.Arg2 = obj.winfPQueryName.getValue();
			param.ArgCnt = 2;
		});
	//	obj.editGridPanelStore.load({});
	
	InitWinEditEvent(obj);
	//�¼��������
	obj.btnQuery.on("click", obj.btnQuery_click, obj);
	obj.btnSave.on("click", obj.btnSave_click, obj);
	obj.btnCancel.on("click", obj.btnCancel_click, obj);
	obj.winfPMsgMenuDr.on("expand",obj.winfPMsgMenuDr_click,obj);
	obj.winfPDtlShowType.on("change",obj.winfPDtlShowType_check,obj);
	obj.winfPAutoRefreash.on('check',obj.winfPAutoRefreash_check,obj);
	obj.LoadEvent(arguments);
	return obj;
}

