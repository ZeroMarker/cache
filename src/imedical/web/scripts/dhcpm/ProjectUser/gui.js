//Create by zzp
// 20150504
//��Ŀ��Ա����
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.PUTel= new Ext.form.TextField({
		id : 'PUTel'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ϵ��ʽ'
		,regex:  /^\d+(\.\d{1,2})?$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PURowid= new Ext.form.TextField({
		id : 'PURowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '����ʦrowid'
		,editable : true
		,hidden:true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PUPerject = new Ext.form.TextField({
		id : 'PUPerject'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��Ŀ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.PUUserName1 = new Ext.form.TextField({
		id : 'PUUserName1'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '����ʦ����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PUModNamejs = new Ext.form.TextField({
		id : 'PUModNamejs'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ģ������'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PUAdd = new Ext.Button({
		id : 'PUAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.PUUpdate = new Ext.Button({
		id : 'PUUpdate'
		,iconCls : 'icon-update'
		,text : '�޸�'
	});
	obj.PUQuery = new Ext.Button({
		id : 'PUQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.PUAddMod = new Ext.Button({
		id : 'PUAddMod'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.PUUpdateMod = new Ext.Button({
		id : 'PUUpdateMod'
		,iconCls : 'icon-update'
		,text : '�޸�'
	});
	obj.PUQueryMod = new Ext.Button({
		id : 'PUQueryMod'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.PUBatch = new Ext.Button({
		id : 'PUBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	/**����**/
	obj.tbbuttonMod = new Ext.Toolbar({
			enableOverflow : true,
			items : [obj.PUAddMod, '-',obj.PUUpdateMod,'-',new Ext.Toolbar.TextItem('ģ�����ƣ�'),obj.PUModNamejs,'-',obj.PUQueryMod]
		});
	/**����**/
	obj.tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [obj.PUAdd, '-', obj.PUUpdate]
		});
	/** ���������� */
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('����ʦ���ƣ�'),obj.PUUserName1,'-',new Ext.Toolbar.TextItem('��Ŀ���ƣ�'),obj.PUPerject,'-',new Ext.Toolbar.TextItem('��ϵ�绰��'),obj.PUTel,'-',obj.PUQuery,'-',obj.PUBatch,obj.PURowid],
				listeners : {
					render : function() {
						obj.tbbutton.render(obj.PUGridPanel.tbar);
					}
				}
			});
	
	//****************************** End ****************************
	

	obj.PUGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL	
			
		}));
	obj.PUGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMPProjectUser';
			param.QueryName = 'QueryProjectUser';
			param.Arg1 = Ext.getCmp('PUPerject').getValue();
			param.Arg2 = Ext.getCmp('PUUserName1').getValue();
			param.Arg3 = Ext.getCmp('PUTel').getValue();
			param.ArgCnt = 3;
	});
	obj.PUGridStore = new Ext.data.Store({
		proxy: obj.PUGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			fields:[{
			name: 'TRowid', 
			mapping: 'TRowid'
			},{
			name: 'TProject', 
			mapping: 'TProject'
			},{
			name: 'TUser',
			mapping: 'TUser'
			},{
			name: 'TDictionary', 
			mapping: 'TDictionary'
			},{
			name: 'TPhone',
			mapping: 'TPhone'
			},{
			name: 'TEmail',
			mapping: 'TEmail'
			},{
			name: 'TDate1',
			mapping: 'TDate1'
			},{
			name: 'TTime1',
			mapping: 'TTime1'
			},{
			name: 'TDate2',
			mapping: 'TDate2'
			},{
			name: 'TTime2',
			mapping: 'TTime2'
			},{
			name: 'TRemark',
			mapping: 'TRemark'
			},{
			name: 'TProjectID',
			mapping: 'TProjectID'
			},{
			name: 'TUserid',
			mapping: 'TUserid'
			},{
			name: 'TDictionaryId',
			mapping: 'TDictionaryId'
			},{
			name: 'TNewUserName',
			mapping: 'TNewUserName'
			},{
			name: 'TNewUserNO',
			mapping: 'TNewUserNO'
			},{
			name: 'TPassWord',
			mapping: 'TPassWord'
			}]
		})
	});
	obj.gridPUCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.PUGridPanel = new Ext.grid.GridPanel({
		id : 'PUGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		,region : 'north'
		//,split: true
		,collapsible: true
		,title:'����ʦ����'
		//,width : 1500
		,bodystyle:"width:100%"
		,autoWidth:true
		,height: 270
		,minHeight: 200
        ,maxHeight: 300
		,plugins : obj.gridPUCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,editable: true
		,store : obj.PUGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridPUCheckCol
			, { header : 'Rowid', width : 80, dataIndex : 'TRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '��Ŀ����', width : 150, dataIndex : 'TProject', sortable : false, align : 'center',editable: true }
			, { header : '�û�����', width : 120, dataIndex : 'TNewUserName', sortable : true, align : 'center' }
			, { header : 'Эͬ�ʺ�', width : 120, dataIndex : 'TNewUserNO', sortable : true, align : 'center' }
			, { header : 'ְ��', width : 120, dataIndex : 'TDictionary', sortable : true, align : 'center' }
			, { header : '��ϵ��ʽ', width : 120, dataIndex : 'TPhone',sortable : true,align : 'center' }
			, { header : '�����ʼ�', width : 120, dataIndex : 'TEmail',sortable : true,align : 'center' }
			, { header : '��������', width : 100, dataIndex : 'TDate1',align : 'center'}
			, { header : '����ʱ��', width : 100, dataIndex : 'TTime1',sortable : true,align : 'center' }
			, { header : '�뿪����', width : 100, dataIndex : 'TDate2',sortable : true,align : 'center' }
			, { header : '�뿪ʱ��', width : 100, dataIndex : 'TTime2',sortable : true,align : 'center' }
			, { header : '��ע', width : 100, dataIndex : 'TRemark',sortable : true,align : 'center' }
			, { header : '��ĿRowid', width : 150, dataIndex : 'TProjectID',sortable : true,align : 'center',hidden: true }
			, { header : '����ʦUserID', width : 150, dataIndex : 'TUserid',sortable : true,align : 'center',hidden: true }
			, { header : 'ְ��id', width : 150, dataIndex : 'TDictionaryId',sortable : true,align : 'center',hidden: true }
			, { header : 'HIS�û���', width : 120, dataIndex : 'TUser', sortable : false ,align : 'center'}
			, { header : '��������', width : 100, dataIndex : 'TPassWord',sortable : true,align : 'center',inputType: 'password' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 10,
			store : obj.PUGridStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2} ����¼',
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
	
	obj.PUModuleStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL	
			
		}));
	obj.PUModuleStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMPModuleUser';
			param.QueryName = 'QueryModuleUser';
			param.Arg1 = Ext.getCmp('PURowid').getValue();
			param.Arg2 = Ext.getCmp('PUModNamejs').getValue();
			param.ArgCnt = 2;
	});
	obj.PUModuleStore = new Ext.data.Store({
		proxy: obj.PUModuleStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			fields:[{
			name: 'TRowid', 
			mapping: 'TRowid'
			},{
			name: 'TMDUUser',
			mapping: 'TMDUUser'
			},{
			name: 'TMDUModule', 
			mapping: 'TMDUModule'
			},{
			name: 'TMDUStDate',
			mapping: 'TMDUStDate'
			},{
			name: 'TMDUStTime',
			mapping: 'TMDUStTime'
			},{
			name: 'TMDUEnDate',
			mapping: 'TMDUEnDate'
			},{
			name: 'TMDUEnTime',
			mapping: 'TMDUEnTime'
			},{
			name: 'TMDURemark',
			mapping: 'TMDURemark'
			},{
			name: 'TMDUDate',
			mapping: 'TMDUDate'
			},{
			name: 'TMDUTime',
			mapping: 'TMDUTime'
			},{
			name: 'TMDUModuleID',
			mapping: 'TMDUModuleID'
			}]
		})
	});
	obj.PUModuleCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.PUModulePanel = new Ext.grid.GridPanel({
		id : 'PUModulePanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		,bodystyle:"width:100%"
		,bodystyle:"height:100%"
		//,height:330
		,title:'����ʦģ����ϸ'
		,collapsible: true
		,region:'center'
		,autoWidth:true
		,plugins : obj.PUModuleCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		,store : obj.PUModuleStore
		,tbar:obj.tbbuttonMod
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.PUModuleCheckCol
			, { header : 'ModRowid', width : 100, dataIndex : 'TRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '����ʦ����', width : 100, dataIndex : 'TMDUUser', sortable : false, align : 'center',editable: true }
			, { header : 'ģ������', width : 100, dataIndex : 'TMDUModule', sortable : false ,align : 'center'}
			, { header : '��ʼ����', width : 100, dataIndex : 'TMDUStDate', sortable : true, align : 'center' }
			, { header : '��ʼʱ��', width : 100, dataIndex : 'TMDUStTime',sortable : true,align : 'center' }
			, { header : '��������', width : 100, dataIndex : 'TMDUEnDate',align : 'center'}
			, { header : '����ʱ��', width : 100, dataIndex : 'TMDUEnTime',sortable : true,align : 'center' }
			, { header : '��ע', width : 100, dataIndex : 'TMDURemark',sortable : true,align : 'center' }
			, { header : '��������', width : 150, dataIndex : 'TMDUDate',sortable : true,align : 'center' }
			, { header : '����ʱ��', width : 150, dataIndex : 'TMDUTime',sortable : true,align : 'center' }
			, { header : 'ģ��Rowid', width : 150, dataIndex : 'TMDUModuleID',sortable : true,align : 'center',hidden: true }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.PUModuleStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}����¼',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
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
					//this.el.setSize(csize.width, csize.height);document.body.clientHeight-Ext.get('topPanel').getHeight()
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
			,layout : 'form'
			,title:'����ʦ��ϸ'
			,frame:true
			,region : 'center'
			,items:[obj.PUGridPanel]
		});
	obj.PUPanalMoude=new Ext.Panel({
			id : 'PUPanalMoude'
			,layout : 'fit'
			//,width : '100%'
			,region:"center" 
			,title:'����ʦģ��'
			//,bodystyle:"height:100%"
		    ,autoHeight:true
			,border:true
			,items:[obj.PUModulePanel]
		});
	obj.PUPanalTol=new Ext.Panel({
			id : 'PUPanalTol'
			,layout : 'form'
			,region:"center" 
			,bodystyle:"height:100%"
			,items:[obj.PUPanal,obj.PUPanalMoude]
		});
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		//,width : 1200
		//,height: 800
	    ,layout : 'border'
		//,enableTabScroll:true
		,items : [obj.PUGridPanel,obj.PUModulePanel]
		});
	
	//--------------------------------------------------------------------------------------------
	obj.PUGridStore.removeAll();
	obj.PUGridStore.load({params : {start:0,limit:10}});
	obj.PUModuleStore.removeAll();
	obj.PUModuleStore.load({params : {start:0,limit:10}});
	InitviewScreenEvent(obj);	
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

function PUUserAddUpWind(){
    var obj = new Object();
	var objDocument = ExtTool.StaticServerObject("web.PMP.Document");
	var HisVersions=objDocument.HisVersions();
	obj.PUUserProNameStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=ModeuleProNameStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	if (HisVersions=="1"){
	obj.PUUserStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=ProjectUserStore'
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
	obj.PUUserStore = new Ext.data.Store({
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
			param.QueryName = 'ProjectUserStoreNew';  
			param.Arg1 = '';   //obj.ContractStatus.getRawValue(); ��ȡ�����ֵ  getValue()��ȡ��̨��ֵ
			param.ArgCnt = 1;
	});
	}
	obj.PUUserZCStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=PUUserZCStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.PUUserProNameStore.load();
	obj.PUUserZCStore.load();
	obj.PUUserStore.load();
	obj.PUUserAddRowid= new Ext.form.TextField({
		id : 'PUUserAddRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.PUUserAddFlag= new Ext.form.TextField({
		id : 'PUUserAddFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PUUserNewName= new Ext.form.TextField({
		id : 'PUUserNewName'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�û�����'
		//,disabled:true
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PUUserNewNo= new Ext.form.TextField({
		id : 'PUUserNewNo'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Эͬ�ʺ�'
		//,disabled:true
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PUUserAddPassWord= new Ext.form.TextField({
		id : 'PUUserAddPassWord'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,inputType: 'password'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PUUserAddPerName= new Ext.form.ComboBox({
		id : 'PUUserAddPerName'
		,width : 100
		,mode:'local'
		,minChars : 1
		,store:obj.PUUserProNameStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '��Ŀ����'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PUUserName= new Ext.form.ComboBox({
		id : 'PUUserName'
		,width : 100
		,minChars : 1
		,store:obj.PUUserStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : 'HIS�û�'
		,valueNotFoundText : ''
		,editable : true
		//,disabled:true
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
	});
	obj.PUUserAddUserTel = new Ext.form.TextField({
		id : 'PUUserAddUserTel'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ϵ�绰'
		,regex:  /^\d+(\.\d{1,2})?$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PUUserAddUserEmail = new Ext.form.TextField({
		id : 'PUUserAddUserEmail'
		,width : 100
		//,store : obj.cboLocStore
		//,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�����ʼ�'
		,regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PUUserAddZC= new Ext.form.ComboBox({
		id : 'PUUserAddZC'
		,width : 100
		,minChars : 1
		//,store : obj.cboLocStore
		,mode:'local'
		,store:obj.PUUserZCStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : 'ְ��'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PUUserAddInDate = new Ext.form.DateField({
		id : 'PUUserAddInDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,emptyText:'��ѡ������'
	    ,format:'Y-m-d'
	    ,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PUUserAddInTime = new Ext.form.TimeField({
		id : 'PUUserAddInTime'
		,width : 100
		,displayField : 'desc'
		,fieldLabel : '����ʱ��'
		,renderTo: Ext.get('times') 
	    //,emptyText:'��ѡ��ʱ��'
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,invalidText:'��ѡ��ʱ���������Ч��ʽ��ʱ��'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PUUserAddOuDate = new Ext.form.DateField({
		id : 'PUUserAddOuDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�뿪����'
		,format:'Y-m-d'
	    //,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
		,setMinValue:Ext.getCmp('PUUserAddInDate').getValue()
	});
	obj.PUUserAddOuTime = new Ext.form.TimeField({
		id : 'PUUserAddOuTime'
		,width : 100
		,displayField : 'desc'
		,fieldLabel : '�뿪ʱ��'
		,renderTo: Ext.get('times') 
	    //,emptyText:'��ѡ��ʱ��'
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,invalidText:'��ѡ��ʱ���������Ч��ʽ��ʱ��'
		,regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.PUUserAddbz = new Ext.form.TextArea({
		id : 'PUUserAddbz'
		,width : 100
		,minChars : 1
		,height : 100
		,displayField : 'desc'
		,fieldLabel : '��ע'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.PUMenuAdd = new Ext.Button({
		id : 'PUMenuAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.PUMenuDelete = new Ext.Button({
		id : 'PUMenuDelete'
		,iconCls : 'icon-delete'
		,text : 'ȡ��'
	});
	/*
	obj.winTPanelMenu = new Ext.form.FormPanel({
		id : 'winTPanelMenu'
		,labelAlign:'left'    
        ,autoHeight : true
        ,autoWidth : true
        //,bodyStyle:'margin-left:5'
        ,buttonAlign:'center'
        ,frame:true
        ,layout:"column"
        ,hideLabel:false
        ,labelWidth:60
		,items:[obj.PUUserAddFlag]
	}); 
	*/
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
                          ,items : [obj.PUUserAddRowid]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PUUserAddFlag]
                         }]
                },{ // ��2
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PUUserNewName]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PUUserNewNo]
                         }]
                },{ // ��3
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PUUserAddPerName]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PUUserName]
                         }]
                },{ // ��4
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PUUserAddUserTel]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PUUserAddUserEmail]
                         }]
                },{ // ��5
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PUUserAddInDate]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PUUserAddInTime]
                         }]
                },{ // ��6
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PUUserAddOuDate]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PUUserAddOuTime]
                         }]
                },{ // ��7  
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.PUUserAddZC]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.PUUserAddPassWord]
                         }]
                },{ // ��8
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.PUUserAddbz]
                         }]
                }]
	}); 
	obj.menuwind = new Ext.Window({
		id : 'menuwind'
		,height : 350
		,buttonAlign : 'center'
		,width : 550
		,modal : true
		,title : '����ʦ��ϸ'
		,layout : 'form'
		,border:true
		,items:[
			   obj.winTPanelMenu
		]
		,buttons:[
			   obj.PUMenuAdd
			  ,obj.PUMenuDelete
		]
	});
	PUUserAddUpWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

function PUUserModAddUpWind(){
    var obj = new Object();
	obj.AddPuModeNameStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=AddPuModeNameStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.AddPuModeNameStore.load();
	obj.AddModeRowid= new Ext.form.TextField({
		id : 'AddModeRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'    //1@@2
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.AddModeFlag= new Ext.form.TextField({
		id : 'AddModeFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.AddModeName= new Ext.form.ComboBox({
		id : 'AddModeName'
		,width : 100
		,mode:'local'
		,store:obj.AddPuModeNameStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : 'ģ������'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AddModeInDate = new Ext.form.DateField({
		id : 'AddModeInDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��ʼ����'
		,emptyText:'��ѡ������'
	    ,format:'Y-m-d'
	    ,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.AddModeInTime = new Ext.form.TimeField({
		id : 'AddModeInTime'
		,width : 100
		,displayField : 'desc'
		,fieldLabel : '��ʼʱ��'
		,renderTo: Ext.get('times') 
	    //,emptyText:'��ѡ��ʱ��'
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,invalidText:'��ѡ��ʱ���������Ч��ʽ��ʱ��'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.AddModeOuDate = new Ext.form.DateField({
		id : 'AddModeOuDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '��������'
		,format:'Y-m-d'
	    //,value:new Date().add(Date.DAY,0)
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
		,setMinValue:Ext.getCmp('AddModeInDate').getValue()
	});
	obj.AddModeOuTime = new Ext.form.TimeField({
		id : 'AddModeOuTime'
		,width : 100
		,displayField : 'desc'
		,fieldLabel : '����ʱ��'
		,renderTo: Ext.get('times') 
	    //,emptyText:'��ѡ��ʱ��'
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,invalidText:'��ѡ��ʱ���������Ч��ʽ��ʱ��'
		,regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.AddModebz = new Ext.form.TextArea({
		id : 'AddModebz'
		,width : 100
		,minChars : 1
		,height : 100
		,displayField : 'desc'
		,fieldLabel : '��ע'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.AddModeAdd = new Ext.Button({
		id : 'AddModeAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.AddModeDelete = new Ext.Button({
		id : 'AddModeDelete'
		,iconCls : 'icon-delete'
		,text : 'ȡ��'
	});
	obj.winTPanelMenuadd = new Ext.form.FormPanel({
		id : 'winTPanelMenuadd'
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
                          ,items : [obj.AddModeRowid]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.AddModeFlag]
                         }]
                },{ // ��2
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.AddModeName]
                         }]
                },{ // ��3
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.AddModeInDate]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.AddModeInTime]
                         }]
                },{ // ��4
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.AddModeOuDate]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.AddModeOuTime]
                         }]
                },{ // ��5
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.AddModebz]
                         }]
                }]
	}); 
	obj.menuwindadd = new Ext.Window({
		id : 'menuwindadd'
		,height : 300
		,buttonAlign : 'center'
		,width : 450
		,modal : true
		,title : '����ʦ��ϸ'
		,layout : 'form'
		,border:true
		,items:[
			   obj.winTPanelMenuadd
		]
		,buttons:[
			   obj.AddModeAdd
			  ,obj.AddModeDelete
		]
	});
    PUUserModAddUpWindEvent(obj);
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}