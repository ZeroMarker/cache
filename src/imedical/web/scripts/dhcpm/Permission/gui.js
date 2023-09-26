//Create by zzp
// 20150505
//�����������
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.PerName= new Ext.form.TextField({
		id : 'PerName'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��Ŀ����'
		//,regex:  /^\d+(\.\d{1,2})?$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PerRowidHid= new Ext.form.TextField({
		id : 'PerRowidHid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Ȩ��Rowid'
		,editable : true
		,hidden:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PerSName = new Ext.form.TextField({
		id : 'PerSName'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Ȩ������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.PerLive = new Ext.form.TextField({
		id : 'PerLive'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Ȩ�޼���'
		,regex:  /^\d+(\.\d{1,2})?$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PerAdd = new Ext.Button({
		id : 'PerAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.PerUpdate = new Ext.Button({
		id : 'PerUpdate'
		,iconCls : 'icon-update'
		,text : '�޸�'
	});
	obj.PerQuery = new Ext.Button({
		id : 'PerQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.PerDelete = new Ext.Button({
		id : 'PerDelete'
		,iconCls : 'icon-find'
		,text : 'ɾ��'
	});
	obj.PerBatch = new Ext.Button({
		id : 'PerBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	/**����ɾ**/
	obj.tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [obj.PerAdd, '-', obj.PerUpdate, '-', obj.PerDelete]
		});
	/** ���������� */
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('��Ŀ���ƣ�'),obj.PerName,'-',new Ext.Toolbar.TextItem('Ȩ�����ƣ�'),obj.PerSName,'-',new Ext.Toolbar.TextItem('Ȩ�޼���'),obj.PerLive,'-',obj.PerQuery,'-',obj.PerBatch,obj.PerRowidHid],
				listeners : {
					render : function() {
						obj.tbbutton.render(obj.PerGridPanel.tbar);
					}
				}
			});
	//**************************��һ��Grid�Ĳ�ѯ******************
	obj.PerDetailLoc = new Ext.form.TextField({
		id : 'PerDetailLoc'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PerDetailUser = new Ext.form.TextField({
		id : 'PerDetailUser'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�û�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PerDetailAdd = new Ext.Button({
		id : 'PerDetailAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.PerDetailUpdate = new Ext.Button({
		id : 'PerDetailUpdate'
		,iconCls : 'icon-update'
		,text : '�޸�'
	});
	obj.PerDetailDelete = new Ext.Button({
		id : 'PerDetailDelete'
		,iconCls : 'icon-update'
		,text : 'ɾ��'
	});
	obj.PerDetailQuery= new Ext.Button({
		id : 'PerDetailQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.PerDetailBatch = new Ext.Button({
		id : 'PerDetailBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	/**����ɾ**/
	obj.tbbuttonPerDetail = new Ext.Toolbar({
	        //id : 'tbbuttonPerDetail',
			enableOverflow : true,
			items : [obj.PerDetailAdd, '-',obj.PerDetailUpdate, '-',obj.PerDetailDelete,'-',new Ext.Toolbar.TextItem('�������ͣ�'),obj.PerDetailLoc,'-',new Ext.Toolbar.TextItem('�û����ƣ�'),obj.PerDetailUser,'-',obj.PerDetailQuery,'-',obj.PerDetailBatch]
		});
	//****************************** End ****************************
	obj.PerGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL	
			
		}));
	obj.PerGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Common';
			param.QueryName = 'PermisQuery';
			param.Arg1 = Ext.getCmp('PerName').getValue();
			param.Arg2 = Ext.getCmp('PerSName').getValue();
			param.Arg3 = Ext.getCmp('PerLive').getValue();
			param.ArgCnt = 3;
	});
	obj.PerGridStore = new Ext.data.Store({
		proxy: obj.PerGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record'
			,totalProperty: 'total'
			,fields:[{
			name: 'PermisRowid',
			mapping: 'PermisRowid'
			},{
			name: 'PermisLiveName',
			mapping: 'PermisLiveName'
			},{
			name: 'PermisLive',
			mapping: 'PermisLive'
			},{
			name: 'PermisPerName', 
			mapping: 'PermisPerName'
			},{
			name: 'PermisPerId',
			mapping: 'PermisPerId'
			},{
			name: 'PermisCreatDate',
			mapping: 'PermisCreatDate'
			},{
			name: 'PermisCreatTime',
			mapping: 'PermisCreatTime'
			},{
			name: 'PermisUserName',
			mapping: 'PermisUserName'
			},{
			name: 'PermisAudit',
			mapping: 'PermisAudit'
			},{
			name: 'PermisAuditId',
		    mapping: 'PermisAuditId'
			},{
			name: 'PermisTAudit',
			mapping: 'PermisTAudit'
			},{
			name: 'PermisTAuditId',
			mapping: 'PermisTAuditId'
			},{
			name: 'PermisMustAu',
			mapping: 'PermisMustAu'
			},{
			name: 'PermisMustAuId',
			mapping: 'PermisMustAuId'
			},{
			name: 'PermisType',
			mapping: 'PermisType'
			},{
			name:'PermisTypeid',
			mapping:'PermisTypeid'
			}]
		})
	});
	obj.PerGridCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.PerGridPanel  = new Ext.grid.GridPanel({
		id : 'PerGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		,region : 'north'
		,bodystyle:"width:100%"
		,bodystyle:"width:100%"
		,autoWidth:true
		,collapsible: true
		,height: 270
		,minHeight: 200
        ,maxHeight: 300
		,title:'�������'
		,plugins : obj.PerGridCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.PerGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.PerGridCheckCol
			, { header : 'ModRowid', width : 100, dataIndex : 'PermisRowid', sortable : false ,align : 'center',hidden:true}
			, { header : 'Ȩ������', width : 150, dataIndex : 'PermisLiveName', sortable : false, align : 'center'}
			, { header : 'Ȩ�޼���', width : 120, dataIndex : 'PermisLive', sortable : false ,align : 'center'}
			, { header : '��Ŀ����', width : 120, dataIndex : 'PermisPerName', sortable : true, align : 'center' }
			, { header : '��ĿRowid', width : 120, dataIndex : 'PermisPerId',sortable : true,align : 'center',hidden:true }
			, { header : '��������', width : 120, dataIndex : 'PermisCreatDate',sortable : true,align : 'center' }
			, { header : '����ʱ��', width : 100, dataIndex : 'PermisCreatTime',sortable : true,align : 'center'}
			, { header : 'Ȩ���û�', width : 100, dataIndex : 'PermisUserName',sortable : true,align : 'center' }
			, { header : '���״̬', width : 100, dataIndex : 'PermisAudit',sortable : true,align : 'center' }
			, { header : '���״̬Rowid', width : 100, dataIndex : 'PermisAuditId',sortable : true,align : 'center',hidden:true }
			, { header : '�������', width : 100, dataIndex : 'PermisTAudit',sortable : true,align : 'center' }
			, { header : '�������Rowid', width : 150, dataIndex : 'PermisTAuditId',sortable : true,align : 'center',hidden:true }
			, { header : '�������', width : 150, dataIndex : 'PermisMustAu',sortable : true,align : 'center' }
			, { header : '�������Rowid', width : 150, dataIndex : 'PermisMustAuId',sortable : true,align : 'center',hidden:true}
			, { header : '�������', width : 120, dataIndex : 'PermisType',sortable : true,align : 'center'}
			, { header : '�������id', width : 120, dataIndex : 'PermisTypeid',hidden:true,sortable : true,align : 'center'}]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.PerGridStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}����¼',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			forceFit: true // ע�ⲻҪ��autoFill:true,�������õĻ���GridPanel�Ĵ�С�仯��������resize������ʱ�����Զ�����column�Ŀ��
            ,scrollOffset: 0 //��������Ļ�������grid�����ұ��и��հף�������������λ��
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
	obj.PerDetailGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL	
		}));
	obj.PerDetailGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Common';
			param.QueryName = 'PermisQueryDetail';
			param.Arg1 = Ext.getCmp('PerRowidHid').getValue();
			param.Arg2 = Ext.getCmp('PerDetailLoc').getValue();
			param.Arg3 = Ext.getCmp('PerDetailUser').getValue();
			param.ArgCnt = 3;
	});
	obj.PerDetailGridStore = new Ext.data.Store({
		proxy: obj.PerDetailGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			fields:[{
			name: 'PermisSRowid', 
			mapping: 'PermisSRowid'
			},{
			name: 'PermisSLiveName',
			mapping: 'PermisSLiveName'
			},{
			name: 'PermisSLive', 
			mapping: 'PermisSLive'
			},{
			name: 'PermisSUserName',
			mapping: 'PermisSUserName'
			},{
			name: 'PermisSUserId',
			mapping: 'PermisSUserId'
			},{
			name: 'PermisSCreatDate',
			mapping: 'PermisSCreatDate'
			},{
			name: 'PermisSCreatTime',
			mapping: 'PermisSCreatTime'
			},{
			name: 'PermisSLoc',
			mapping: 'PermisSLoc'
			},{
			name: 'PermisSLocId',
			mapping: 'PermisSLocId'
			}]
		})
	});
	obj.PerDetailGridCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox

	obj.PerDetailGridPanel  = new Ext.grid.GridPanel({
		id : 'PerDetailGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		,collapsible: true
		,region:'center'
		,autoWidth:true
		,bodystyle:"width:100%"
		,bodystyle:"height:100%"
		,title:'���������ϸ'
		,plugins : obj.PerDetailGridCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.PerDetailGridStore
		,tbar:obj.tbbuttonPerDetail
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.PerDetailGridCheckCol
			, { header : 'PerSRowid', width : 100, dataIndex : 'PermisSRowid', sortable : false ,align : 'center',hidden:true}
			, { header : 'Ȩ������', width : 100, dataIndex : 'PermisSLiveName', sortable : false, align : 'center'}
			, { header : 'Ȩ�޼���', width : 100, dataIndex : 'PermisSLive', sortable : false ,align : 'center'}
			, { header : 'Ȩ���û�', width : 100, dataIndex : 'PermisSUserName', sortable : true, align : 'center' }
			, { header : '�û�Rowid', width : 100, dataIndex : 'PermisSUserId',sortable : true,align : 'center',hidden:true }
			, { header : '��������', width : 100, dataIndex : 'PermisSCreatDate',align : 'center'}
			, { header : '����ʱ��', width : 100, dataIndex : 'PermisSCreatTime',sortable : true,align : 'center' }
			, { header : '��������', width : 100, dataIndex : 'PermisSLoc',sortable : true,align : 'center' }
			, { header : '��������Rwoid', width : 150, dataIndex : 'PermisSLocId',sortable : true,align : 'center',hidden:true }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.PerDetailGridStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}����¼',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			forceFit: true // ע�ⲻҪ��autoFill:true,�������õĻ���GridPanel�Ĵ�С�仯��������resize������ʱ�����Զ�����column�Ŀ��
            ,scrollOffset: 0 //��������Ļ�������grid�����ұ��и��հף�������������λ��
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
    obj.PUPanal=new Ext.Panel({
			id : 'PUPanal'
			//,layout : 'form'
			,layout : 'fit'
			,title:'�������'
			//,width : '50%'
			//,width : 1200
		    //,height: '50%'
			,frame:true
			,region : 'center'
			//,collapsible: true
			//,border:true
			,items:[obj.PerGridPanel ]
		});
	obj.PUPanalMoude=new Ext.Panel({
			id : 'PUPanalMoude'
			,layout : 'fit'
			//,width : '50%'
			,region:"center" 
			//,height: '50%'
			,title:'���������ϸ'
			//,width : 1200
		   // ,height: 500
			//,collapsible: true
			//,border:true
			,items:[obj.PerDetailGridPanel]
		});
	obj.PUPanalTol=new Ext.Panel({
			id : 'PUPanalTol'
			//,layout : 'fit'
			//,width : '100%'
			//,region:"center" 
			,layout : 'border'
			//,width : 1200
		    //,height: 800
			//,collapsible: true
			//,border:true
			,items:[obj.PUPanal,obj.PUPanalMoude]
		});
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		//,width : 1200
		//,height: 800
	    //,layout : 'border'
		//,layout : 'border'
		,layout : 'border'
		//,enableTabScroll:true
		,items : [obj.PerGridPanel,obj.PerDetailGridPanel]
		});
	
	//--------------------------------------------------------------------------------------------
	obj.PerGridStore.removeAll();
	obj.PerGridStore.load({params : {start:0,limit:10}});
	obj.PerDetailGridStore.removeAll();
	obj.PerDetailGridStore.load({params : {start:0,limit:10}});
	InitviewScreenEvent(obj);	
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}
//������̴����ڣ��������޸ģ�
function PerAddUpWind(){
    var obj = new Object();
	var objDocument = ExtTool.StaticServerObject("web.PMP.Document");
	var HisVersions=objDocument.HisVersions();
	obj.PerProNameStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=ModeuleProNameStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	if(HisVersions=="1"){
	obj.PerUserStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=PermissionUserStore'
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
	obj.PerUserStore = new Ext.data.Store({
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
			param.QueryName = 'PermissionUserStoreNew';  
			param.Arg1 = '';   //obj.ContractStatus.getRawValue(); ��ȡ�����ֵ  getValue()��ȡ��̨��ֵ
			param.ArgCnt = 1;
	});
	};
	obj.PerStatusStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=PerStatusStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.PermisMustAuStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=PermisMustAuStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});	
	obj.PermisTAuditStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=PermisTAuditStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
    obj.PerCATtypeStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=PerCATtypeStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});	
    obj.PerCATtypeStore.load();		
	obj.PerProNameStore.load();
	obj.PerUserStore.load();
	obj.PerStatusStore.load();
	obj.PermisMustAuStore.load();
	obj.PermisTAuditStore.load({params : {InPut:'1'}})
	obj.PermisSAddRowid= new Ext.form.TextField({
		id : 'PermisSAddRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.PermisSAddFlag= new Ext.form.TextField({
		id : 'PermisSAddFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PermisSAddPerName= new Ext.form.ComboBox({
		id : 'PermisSAddPerName'
		,width : 100
		,mode:'local'
		,minChars : 1
		,store:obj.PerProNameStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '��Ŀ����'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PermisSMustA= new Ext.form.ComboBox({
		id : 'PermisSMustA'
		,width : 100
		,minChars : 1
		,store:obj.PermisMustAuStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '�������'
		,valueNotFoundText : ''
		,editable : true
		//,disabled:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PermisSAddName = new Ext.form.TextField({
		id : 'PermisSAddName'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Ȩ������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PermisSAddLive = new Ext.form.TextField({
		id : 'PermisSAddLive'
		,width : 100
		//,store : obj.cboLocStore
		//,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Ȩ�޼���'
		,disabled:true
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PermisSAddACT= new Ext.form.ComboBox({
		id : 'PermisSAddACT'
		,width : 100
		,minChars : 1
		//,store : obj.cboLocStore
		,mode:'local'
		,store:obj.PerStatusStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '��˽��'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PermisSAddUser= new Ext.form.ComboBox({
		id : 'PermisSAddUser'
		,width : 100
		,minChars : 1
		//,store : obj.cboLocStore
		,mode:'local'
		,store:obj.PerUserStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : 'Ȩ���û�'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,listeners:{
        	beforequery : function(e){
            	var combo = e.combo;
                if(!e.forceAll){
                	var value = e.query;
                	combo.store.filterBy(function(record,id){
                		var text = record.get(combo.displayField);
                		return (text.indexOf(value)!=-1);
                	});
                	combo.expand();
                	return false;
                }
        	}
        }
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PermisSAddACTT= new Ext.form.ComboBox({
		id : 'PermisSAddACTT'
		,width : 100
		,minChars : 1
		//,store : obj.cboLocStore
		,mode:'local'
		,store:obj.PermisTAuditStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '�������'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PermisSAddType= new Ext.form.ComboBox({
		id : 'PermisSAddType'
		,width : 100
		,minChars : 1
		//,store : obj.cboLocStore
		,mode:'local'
		,store:obj.PerCATtypeStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '�������'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PermisSAdd = new Ext.Button({
		id : 'PermisSAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.PermisSDelete = new Ext.Button({
		id : 'PermisSDelete'
		,iconCls : 'icon-delete'
		,text : 'ȡ��'
	});
	obj.winTPanelMenu = new Ext.form.FormPanel({
		id : 'winTPanelMenu'
		//,labelAlign : 'right'
		,buttonAlign : 'center'
		,autoHeight : true
        ,autoWidth : true
		,layout : 'form'
		,hideLabel:false
		,labelAlign : "right"
		,labelWidth:60
		,frame : true
		,items:[{   // ��1
                layout : "column",         // �������ҵĲ���
                items : [{
                          columnWidth : .5       // ��������������ռ�ٷֱ�
                          ,layout : "form"       // �������µĲ���
                          ,items : [obj.PermisSAddRowid]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PermisSAddFlag]
                         }]
                },{ // ��2
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PermisSAddPerName]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PermisSMustA]
                         }]
                },{ // ��3
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PermisSAddName]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PermisSAddLive]
                         }]
                },{ // ��4
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PermisSAddACT]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PermisSAddUser]
                         }]
                },{ // ��5
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PermisSAddACTT]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PermisSAddType]
                         }]
                }]
	}); 
	obj.menuwind = new Ext.Window({
		id : 'menuwind'
		,height : 250
		,buttonAlign : 'center'
		,width : 450
		,modal : true
		,title : '���������ϸ'
		,layout : 'form'
		,border:true
		,items:[
			   obj.winTPanelMenu
		]
		,buttons:[
			   obj.PermisSAdd
			  ,obj.PermisSDelete
		]
	});
	PerAddUpWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

function PerAddUpDetailWind(){
    var obj = new Object();
	var objDocument = ExtTool.StaticServerObject("web.PMP.Document");
	var HisVersions=objDocument.HisVersions();
	if(HisVersions=="1"){
	obj.PerDetailUserStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=PermissionUserStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	}
	else{
	obj.PerDetailUserStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.PerDetailUserStore = new Ext.data.Store({
		proxy: obj.PerDetailUserStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['RowId'
		,'Description'])
	});
	obj.PerDetailUserStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Common';
			param.QueryName = 'PermissionUserStoreNew';  
			param.Arg1 = '';   //obj.ContractStatus.getRawValue(); ��ȡ�����ֵ  getValue()��ȡ��̨��ֵ
			param.ArgCnt = 1;
	});

	};
	obj.PerDetailLocStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=PerDetailLocStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.PerDetailUserStore.load();
	obj.PerDetailLocStore.load();
	obj.PerDetailAddRowid= new Ext.form.TextField({
		id : 'PerDetailAddRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.PerDetailAddFlag= new Ext.form.TextField({
		id : 'PerDetailAddFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PerDetailAddUser= new Ext.form.ComboBox({
		id : 'PerDetailAddUser'
		,width : 100
		,mode:'local'
		//,minChars : 1
		,store:obj.PerDetailUserStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '�û�����'
		,valueNotFoundText : ''
		,editable : true
		,listeners:{
        	beforequery : function(e){
            	var combo = e.combo;
                if(!e.forceAll){
                	var value = e.query;
                	combo.store.filterBy(function(record,id){
                		var text = record.get(combo.displayField);
                		return (text.indexOf(value)!=-1);
                	});
                	combo.expand();
                	return false;
                }
        	}
        }
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PerDetailLocType= new Ext.form.ComboBox({
		id : 'PerDetailLocType'
		,width : 100
		//,minChars : 1
		,store:obj.PerDetailLocStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '��������'
		,valueNotFoundText : ''
		,editable : true
		//,disabled:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PerDetailAdd = new Ext.Button({
		id : 'PerDetailAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.PerDetailDelete = new Ext.Button({
		id : 'PerDetailDelete'
		,iconCls : 'icon-delete'
		,text : 'ȡ��'
	});
	obj.winTPanelMenu = new Ext.Panel({
		id : 'winTPanelMenu'
		,buttonAlign : 'center'
		,margins : '{3,0,0,0}'
		,layout : 'form'
		,region : 'center'
		,labelWidth:60
		,frame : true
		,items:[
		     obj.PerDetailAddRowid
			,obj.PerDetailAddFlag 
			,obj.PerDetailAddUser
			,obj.PerDetailLocType 	
		]
	}); 
	obj.menuwind = new Ext.Window({
		id : 'menuwind'
		,height : 250
		,buttonAlign : 'center'
		,width : 250
		,modal : true
		,title : 'Ȩ������'
		,layout : 'border'
		,border:true
		,items:[
			obj.winTPanelMenu
		]
		,buttons:[
			   obj.PerDetailAdd
			  ,obj.PerDetailDelete
		]
	});
    PerAddUpDetailWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

