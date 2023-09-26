//Create by zzp
// 20150503
//������������
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.DepartLoc	= new Ext.form.TextField({
		id : 'DepartLoc'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.DepartUser = new Ext.form.TextField({
		id : 'DepartUser'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�û�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.DepartType = new Ext.form.ComboBox({
		id : 'DepartType'
		,width : 100
		,minChars : 1
		,fieldLabel : '����'
		,valueNotFoundText : ''
		,editable : true
		,mode:'local'
		,store:new Ext.data.ArrayStore({    
						fields:['code','desc']
						,data:[['L','���ҷ���'],['F','�������']]
						})
		,displayField:'desc'
		,valueField:'code'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.DepartFlaga = new Ext.form.Checkbox({
		id : 'DepartFlaga'
		,checked : true
		,fieldLabel : '�Ƿ���Ч'
		,anchor : '99%'
	});
	obj.DepartAdd = new Ext.Button({
		id : 'DepartAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.DepartUpdate = new Ext.Button({
		id : 'DepartUpdate'
		,iconCls : 'icon-update'
		,text : '�޸�'
	});
	obj.DepartQuery = new Ext.Button({
		id : 'DepartQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.DepartBatch = new Ext.Button({
		id : 'DepartBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	/**����**/
	obj.tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [obj.DepartAdd, '-', obj.DepartUpdate]
		});
	/** ���������� */
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('�������ƣ�'),obj.DepartLoc,'-',new Ext.Toolbar.TextItem('�û����ƣ�'),obj.DepartUser,'-',new Ext.Toolbar.TextItem('���ͣ�'),obj.DepartType,'-',new Ext.Toolbar.TextItem('�Ƿ���Ч��'),obj.DepartFlaga,'-',obj.DepartQuery,'-',obj.DepartBatch],
				listeners : {
					render : function() {
						obj.tbbutton.render(obj.DepartGridPanel.tbar);
					}
				}
			});
	
	//****************************** End ****************************
	obj.DepartGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL	
			
		}));
	obj.DepartGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.PMPGetDepartAudit';
			param.QueryName = 'DepartAuditDetail';
			param.Arg1 = Ext.getCmp('DepartLoc').getValue();
			param.Arg2 = Ext.getCmp('DepartUser').getValue();
			param.Arg3 = Ext.getCmp('DepartType').getValue();
			param.Arg4 = Ext.getCmp('DepartFlaga').getValue();
			param.ArgCnt = 4;
	});
	obj.DepartGridStore = new Ext.data.Store({
		proxy: obj.DepartGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			fields:[{
			name: 'AuditRowid', 
			mapping: 'AuditRowid'
			},{
			name: 'AuditLocName', 
			mapping: 'AuditLocName'
			},{
			name: 'AuditUserName',
			mapping: 'AuditUserName'
			},{
			name: 'Effect', 
			mapping: 'Effect'
			},{
			name: 'Typedesc',
			mapping: 'Typedesc'
			},{
			name: 'AuditLocDr',
			mapping: 'AuditLocDr'
			},{
			name: 'AuditUserDr',
			mapping: 'AuditUserDr'
			}]
		})
	});
	obj.gridDepartCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.DepartGridPanel = new Ext.grid.GridPanel({
		id : 'DepartGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		//,region : 'west'
		//,split: true
		//,collapsible: true
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.gridDepartCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.DepartGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			,obj.gridDepartCheckCol
			, { header : 'AuditRowid', width : 200, dataIndex : 'AuditRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '��������', width : 200, dataIndex : 'AuditLocName', sortable : false, align : 'center',editable: true }
			, { header : '�û�����', width : 200, dataIndex : 'AuditUserName', sortable : false ,align : 'center'}
			, { header : '��Ч��־', width : 300, dataIndex : 'Effect', sortable : true, align : 'center' }
			, { header : '�������', width : 150, dataIndex : 'Typedesc',sortable : true,align : 'center' }
			, { header : '����Rowid', width : 150, dataIndex : 'AuditLocDr',align : 'center',hidden:true}
			, { header : '�û�Rowid', width : 150, dataIndex : 'AuditUserDr',sortable : true,align : 'center',hidden:true }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.DepartGridStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			scrollOffset: 0
			,enableRpwBody : true
			,showPreview : true
			,layout : function() {
				if (!this.mainBody) {
					return;
				}
				var g = this.grid;
				var c = g.getGridEl();
				var csize = c.getSize(true);
				var vw = csize.width;
				if (!g.hideHeaders && (vw < 20 || csize.height < 20)) {
					return;
				}
				if (g.autoHeight) {
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				} else {
					this.el.setSize(csize.width, csize.height);
					var hdHeight = this.mainHd.getHeight();
					var vh = csize.height - (hdHeight);
					this.scroller.setSize(vw, vh);
					if (this.innerHd) {
						this.innerHd.style.width = (vw) + 'px';
					 }
				}
				if (this.forceFit) {
					if (this.lastViewWidth != vw) {
						this.fitColumns(false, false);
						this.lastViewWidth = vw;
					 }
				} else {
					this.autoExpand();
					this.syncHeaderScroll();
				}
				this.onLayout(vw, vh);
			}
		}
	});
	//--------------------------------------------------------------------
	obj.DepartPanal=new Ext.Panel({
			id : 'DepartPanal'
			,layout : 'fit'
			,width : '100%'
			,region : 'center'
			,collapsible: true
			,border:true
			,items:[obj.DepartGridPanel]
		});
		
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [obj.DepartPanal]});
	
	//--------------------------------------------------------------------------------------------
	obj.DepartGridStore.removeAll();
	obj.DepartGridStore.load({params : {start:0,limit:20}});   
	InitviewScreenEvent(obj);	
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

function DepartMenuWind(){
    var obj = new Object();
	var objDocument = ExtTool.StaticServerObject("web.PMP.Document");
	var HisVersions=objDocument.HisVersions();
	obj.DepartLocStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=DepartLocStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	if(HisVersions=="1"){
	obj.DepartUserStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=DepartUserStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	}
	else{
	obj.PUUserStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.DepartUserStore = new Ext.data.Store({
		proxy: obj.PUUserStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['RowId'
		,'Description'])
	});
	obj.PUUserStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Common';
			param.QueryName = 'DepartUserStoreNew';  
			param.Arg1 = '';   //obj.ContractStatus.getRawValue(); ��ȡ�����ֵ  getValue()��ȡ��̨��ֵ
			param.ArgCnt = 1;
	});
	};
	obj.DepartTypeStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=DepartTypeStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.DepartLocStore.load();
	obj.DepartUserStore.load();
	obj.DepartTypeStore.load();
	obj.DepartRowid= new Ext.form.TextField({
		id : 'DepartRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.DepartFlag	= new Ext.form.TextField({
		id : 'DepartFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Flag'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.DepartAddLoc= new Ext.form.ComboBox({
		id : 'DepartAddLoc'
		,width : 100
		//,minChars : 1
		,mode:'local'
		,store:obj.DepartLocStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '��������'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.DepartAddUser = new Ext.form.ComboBox({
		id : 'DepartAddUser'
		,width : 100
		,mode:'local'
		,store:obj.DepartUserStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '�û�����'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.DepartAddType = new Ext.form.ComboBox({
		id : 'DepartAddType'
		,width : 100
		,fieldLabel : '����'
		,valueNotFoundText : ''
		,editable : true
		,mode:'local'
		,store:obj.DepartTypeStore
		,displayField:'Description'
		,valueField:'RowId'
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.DepartMenuAdd = new Ext.Button({
		id : 'DepartMenuAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.DepartMenuDelete = new Ext.Button({
		id : 'DepartMenuDelete'
		,iconCls : 'icon-delete'
		,text : 'ȡ��'
	});
	obj.winTPanelMenu = new Ext.Panel({
		id : 'winTPanelMenu'
		//,labelAlign : 'right'
		,buttonAlign : 'center'
		,margins : '{3,0,0,0}'
		//,height:'80%'
		,layout : 'form'
		,region : 'center'
		,labelWidth:60
		,frame : true
		,items:[
		     obj.DepartRowid
			,obj.DepartFlag
			,obj.DepartAddLoc
			,obj.DepartAddUser 
			,obj.DepartAddType
		]
	}); 
	obj.menuwind = new Ext.Window({
		id : 'menuwind'
		,height : 350
		,buttonAlign : 'center'
		,width : 450
		,modal : true
		,title : '������ϸ'
		,layout : 'border'
		,border:true
		,items:[
			   obj.winTPanelMenu
		]
		,buttons:[
			   obj.DepartMenuAdd
			  ,obj.DepartMenuDelete
		]
	});
	DepartMenuWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}