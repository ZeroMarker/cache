//Create by zs
// 20150515
//�ļ����ӹ���
function InitviewScreen(){
	var obj = new Object();
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	var type=objAudit.DocumentType();
	typeid=type.split("^")[1];
	var treetype=objAudit.DocunmentStree();
	obj.DocumentName = new Ext.form.TextField({
		id : 'DocumentName'
		,width : 150
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '�ĵ�����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.DocumentID = new Ext.form.TextField({
		id : 'DocumentID'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'ID'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,hidden:true
		//,valueField : 'rowid'
	});
	obj.DocumentType = new Ext.form.TextField({
		id : 'DocumentType'
		,width : 100
		,hidden:true
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '����'
		,editable : true
		,value:type.split("^")[0]  //Ĭ�ϸ����ļ�
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.DocumentAdd = new Ext.Button({
		id : 'DocumentAdd'
		,iconCls : 'icon-add'
		,text : '����'
	});
	obj.DocumentUpdate = new Ext.Button({
		id : 'DocumentUpdate'
		,iconCls : 'icon-update'
		,text : '�޸�'
	});
	obj.DocumentDelete = new Ext.Button({
		id : 'DocumentDelete'
		,iconCls : 'icon-Delete'
		,text : 'ɾ��'
	});
	obj.DocumentQuery = new Ext.Button({
		id : 'DocumentQuery'
		,iconCls : 'icon-find'
		,text : '��ѯ'
	});
	obj.DocumentBatch = new Ext.Button({
		id : 'DocumentBatch'
		,iconCls : 'icon-update'
		,text : '����'
	});
	obj.Documentmenu=new Ext.menu.Menu({  
                id:'Documentmenu',  
                items:[{       
				        text:'����',  
						iconCls : 'icon-add',
                        handler:function(){  
                           obj.DocumentAdd_OnClick();  
                           }  
                      }]  
            });  
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('�ļ����ƣ�'),obj.DocumentName,'-',obj.DocumentQuery,'-',obj.DocumentBatch,'-',obj.DocumentAdd,'-',obj.DocumentUpdate,'-',obj.DocumentDelete,obj.DocumentID,obj.DocumentType]
			});
	obj.Documenttree = new Ext.tree.TreePanel({
	            id:'Documenttree',
			    region : 'west',
				width:300,
				//height:500,
				bodystyle:"height:100%",
				title:'�����ļ�',
				tbar:obj.tbmode,
    			//animate:true,
    			enableDD:false,
    			containerScroll:true,
				//loader: new Ext.tree.TreeLoader({dataUrl:'PMP.Document.csp?actiontype=DirTree'}),
		        loader: new Ext.tree.TreeLoader({dataUrl:'PMP.Document.csp?actiontype=Plantree&TYPE='+treetype}),
		        rootVisible:false,
		        //lines:false,
		        //autoScroll:true,
		        root: new Ext.tree.AsyncTreeNode({
		        text: 'text',
				id:'id',
		        expanded:true
				})
	});
	obj.Documenttreeshore = new Ext.tree.TreePanel({
	            id:'Documenttreeshore',
	           // border:false,
			   region : 'west',
				width:250,
				//height:500,
				bodystyle:"height:100%",
				title:'�����ļ�',
				tbar:obj.tbmode,
    			//animate:true,
    			enableDD:false,
    			containerScroll:true,
				//loader: new Ext.tree.TreeLoader({dataUrl:'PMP.Document.csp?actiontype=DirTree'}),
		        loader: new Ext.tree.TreeLoader({dataUrl:'PMP.Document.csp?actiontype=Plantree&TYPE='+treetype}),
		        rootVisible:false,
		        //lines:false,
		        //autoScroll:true,
		        root: new Ext.tree.AsyncTreeNode({
		        text: 'text',
				id:'id',
		        expanded:true
				})
	});
	obj.Documenttreesh = new Ext.tree.TreePanel({
	            id:'Documenttreesh',
	           // border:false,
			   region : 'west',
				width:250,
				//height:500,
				bodystyle:"height:100%",
				title:'�ļ�����',
				tbar:obj.tbmode,
    			//animate:true,
    			enableDD:false,
    			containerScroll:true,
				//loader: new Ext.tree.TreeLoader({dataUrl:'PMP.Document.csp?actiontype=DirTree'}),
		        loader: new Ext.tree.TreeLoader({dataUrl:'PMP.Document.csp?actiontype=Plantree&TYPE='+treetype}),
		        rootVisible:false,
		        //lines:false,
		        //autoScroll:true,
		        root: new Ext.tree.AsyncTreeNode({
		        text: 'text',
				id:'id',
		        expanded:true
				})
	});
	//****************************** End ****************************
	obj.DocumentGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.DocumentGridStore = new Ext.data.Store({
		proxy: obj.DocumentGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['DocumentGridRowid'
		,'DocumentGridDesc'
		,'DocumentGridCode'
		,'DocumentGridStatus'
		,'DocumentGridCreatUser'
		,'DocumentGridCreatDate'
		,'DocumentGridCreatTime'
		,'DocumentGridGroup'
		,'DocumentGridLevel'
		,'DocumentGridDownloadsCount'
		,'DocumentGridReceive'
		,'DocumentGridFtpName'
		,'DocumentGridSize'
		,'DocumentGridType'
		,'DocumentGridShare'])
	});
	obj.DocumentGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'DocumentDetailStore';
			param.Arg1 = obj.DocumentID.getRawValue();
			param.Arg2 = obj.DocumentType.getRawValue();
			param.Arg3 = obj.DocumentName.getRawValue();   
			param.ArgCnt = 3;
	});
	obj.gridDocumentCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.DocumentGridPanel = new Ext.grid.GridPanel({
		id : 'DocumentGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		,width : 850
		//,height : 560
		,bodystyle:"height:100%"
		,plugins : obj.gridDocumentCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.DocumentGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridDocumentCheckCol
			, {header : "����",width : 200,forceFit : true,dataIndex : 'node',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
			   var nodeType=obj.DocumentType.getValue();
			   if(record.get("DocumentGridReceive")=="Y"){
			    if(record.get("DocumentGridShare")=="Y"){
				formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='Download'>����</a>";
				if (nodeType=="receive"){
				 formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='receive'>����</a>";
				};
				if (nodeType=="myself"){
				 formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='receive'>����</a>";
                 formatStr=formatStr+" | <a href='javascript:void({2});' onclick='javscript:return false;' class='Delete'>ɾ��</a>";
				 formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='DeleteShare'>ȡ������</a>";
				};
                 			   
			    strRet = "<div class='controlBtn'>" + formatStr + "</div>";
				}
				else{
				formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='Download'>����</a>";
				if (nodeType=="receive"){
				 formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='receive'>����</a>";
				};
				if (nodeType=="myself"){
				 formatStr=formatStr+" | <a href='javascript:void({1});' onclick='javscript:return false;' class='receive'>����</a>";
                 formatStr=formatStr+" | <a href='javascript:void({2});' onclick='javscript:return false;' class='Delete'>ɾ��</a>";	
			     formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Share'>����</a>";;
				};
			    strRet = "<div class='controlBtn'>" + formatStr + "</div>";
				};
			   
			   }
			   else {
			    if(record.get("DocumentGridShare")=="Y"){
				formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='Download'>����</a>";
			    if (nodeType=="myself"){
				 formatStr=formatStr+" | <a href='javascript:void({2});' onclick='javscript:return false;' class='Delete'>ɾ��</a>";
				 formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='DeleteShare'>ȡ������</a>";
				}; 		
			    strRet = "<div class='controlBtn'>" + formatStr + "</div>";
				}
				else{
				formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='Download'>����</a>";	
			    if (nodeType=="myself"){
			     formatStr=formatStr+" | <a href='javascript:void({2});' onclick='javscript:return false;' class='Delete'>ɾ��</a>";
			     formatStr=formatStr+" | <a href='javascript:void({3});' onclick='javscript:return false;' class='Share'>����</a>";;
				};
			    strRet = "<div class='controlBtn'>" + formatStr + "</div>";
				};
			   
			   };
			   return strRet;
			   }}
			, { header : 'Rowid', width : 150, dataIndex : 'DocumentGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '�ļ�����', width : 200, dataIndex : 'DocumentGridDesc', sortable : false ,align : 'center'}
			, { header : '�ļ�����', width : 100, dataIndex : 'DocumentGridCode', sortable : false, align : 'center',editable: true }
			, { header : '�ļ���С', width : 100, dataIndex : 'DocumentGridSize',sortable : true,align : 'center' }
			, { header : '�ļ�����', width : 100, dataIndex : 'DocumentGridType',sortable : true,align : 'center' }
			, { header : '�ļ�״̬', width : 80, dataIndex : 'DocumentGridStatus',sortable : true,align : 'center' }
			, { header : '������Ա', width : 100, dataIndex : 'DocumentGridCreatUser', sortable : true, align : 'center' }
			, { header : '��������', width : 100, dataIndex : 'DocumentGridCreatDate',sortable : true,align : 'center' }
			, { header : '����ʱ��', width : 100, dataIndex : 'DocumentGridCreatTime',sortable : true,align : 'center'}
			, { header : '�ĵ�����', width : 100, dataIndex : 'DocumentGridGroup',sortable : true,align : 'center' }
			, { header : '�ļ�����', width : 100, dataIndex : 'DocumentGridLevel',hidden:true,sortable : true,align : 'center' }
			, { header : '���ش���', width : 100, dataIndex : 'DocumentGridDownloadsCount',sortable : true,align : 'center' }
			, { header : '���ձ�־', width : 100, dataIndex : 'DocumentGridReceive',sortable : true,align : 'center' }
			, { header : '�������ļ�����', width : 100, dataIndex : 'DocumentGridFtpName',sortable : true,align : 'center' }
			, { header : '�����־', width : 100, dataIndex : 'DocumentGridShare',sortable : true,align : 'center' }]		
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.DocumentGridStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼'
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			enableRpwBody : true
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
	if (typeid=="0"){
	obj.tabs = new Ext.TabPanel({   
	    id:'tabs',
        activeTab:0,  //��ʼ��ʾ�ڼ���Tabҳ   
		bodystyle:"height:100%",
        //deferredRender: false,//�Ƿ�����ʾÿ����ǩ��ʱ������Ⱦ��ǩ�е�����.Ĭ��true   
        tabPosition: 'top',//��ʾTabPanelͷ��ʾ��λ��,ֻ������ֵtop��bottom.Ĭ����top.   
        enableTabScroll: true,//��Tab��ǩ����ʱ,���ֹ�����   
        items: [obj.Documenttree,obj.Documenttreeshore,obj.Documenttreesh],
		listeners:{ 
                 tabchange:function(tp,p){ 
                   if(p.id=="Documenttree"){
					  obj.DocumentType.setValue("myself");
					  obj.DocumentID.setValue('');
					  obj.DocumentGridStore.load();
					  };
					if(p.id=="Documenttreeshore"){
					   obj.DocumentType.setValue("share");
					   obj.DocumentID.setValue('');
					   obj.DocumentGridStore.load();
						};
					if(p.id=="Documenttreesh"){
					   obj.DocumentType.setValue("receive");
					   obj.DocumentID.setValue('');
					   obj.DocumentGridStore.load();
					    };
                    } 
                } 
    });
	};
    if (typeid=="1"){
	obj.tabs = new Ext.TabPanel({   
	    id:'tabs',
		bodystyle:"height:100%",
        activeTab:0,  //��ʼ��ʾ�ڼ���Tabҳ   
        //deferredRender: false,//�Ƿ�����ʾÿ����ǩ��ʱ������Ⱦ��ǩ�е�����.Ĭ��true   
        tabPosition: 'top',//��ʾTabPanelͷ��ʾ��λ��,ֻ������ֵtop��bottom.Ĭ����top.   
        enableTabScroll: true,//��Tab��ǩ����ʱ,���ֹ�����   
        items: [obj.Documenttreeshore,obj.Documenttree,obj.Documenttreesh],
		listeners:{ 
                 tabchange:function(tp,p){ 
                   if(p.id=="Documenttree"){
					  obj.DocumentType.setValue("myself");
					  obj.DocumentID.setValue('');
					  obj.DocumentGridStore.load();
					  };
					if(p.id=="Documenttreeshore"){
					   obj.DocumentType.setValue("share");
					   obj.DocumentID.setValue('');
					   obj.DocumentGridStore.load();
						};
					if(p.id=="Documenttreesh"){
					   obj.DocumentType.setValue("receive");
					   obj.DocumentID.setValue('');
					   obj.DocumentGridStore.load();
					    };
                    } 
                } 
    });
	};
	if (typeid=="2"){
	obj.tabs = new Ext.TabPanel({   
	    id:'tabs',
		bodystyle:"height:100%",
        activeTab:0,  //��ʼ��ʾ�ڼ���Tabҳ   
        //deferredRender: false,//�Ƿ�����ʾÿ����ǩ��ʱ������Ⱦ��ǩ�е�����.Ĭ��true   
        tabPosition: 'top',//��ʾTabPanelͷ��ʾ��λ��,ֻ������ֵtop��bottom.Ĭ����top.   
        enableTabScroll: true,//��Tab��ǩ����ʱ,���ֹ�����   
        items: [obj.Documenttreesh,obj.Documenttree,obj.Documenttreeshore],
		listeners:{ 
                 tabchange:function(tp,p){ 
                   if(p.id=="Documenttree"){
					  obj.DocumentType.setValue("myself");
					  obj.DocumentID.setValue('');
					  obj.DocumentGridStore.load();
					  };
					if(p.id=="Documenttreeshore"){
					   obj.DocumentType.setValue("share");
					   obj.DocumentID.setValue('');
					   obj.DocumentGridStore.load();
						};
					if(p.id=="Documenttreesh"){
					   obj.DocumentType.setValue("receive");
					   obj.DocumentID.setValue('');
					   obj.DocumentGridStore.load();
					    };
                    } 
                } 
    });
	};
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [
		   {region:"west",
		    width:250,
			bodystyle:"height:100%",
	        collapsible:true,
	        frame:true,     //�������  
	        title:"�ļ�Ŀ¼",
	        layout:"fit",
	        items:obj.tabs	
	       },{
		    region:"center",
	        collapsible:true,
			bodystyle:"height:100%",
	        frame:true,     
	        title:"�ļ���ϸ",
	        layout:"fit",
	        items:obj.DocumentGridPanel		        
	      }]
	});
	//--------------------------------------------------------------------------------------------
	obj.DocumentGridStore.removeAll();
	//obj.DocumentGridStore.load();
	InitviewScreenEvent(obj);	
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}

function AddDocumentWind (){
    var obj = new Object();
	var objAudit = ExtTool.StaticServerObject("web.PMP.Document");
	var HisVersions=objAudit.HisVersions();
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
			param.QueryName = 'DepartUserStoreNew';  
			param.Arg1 = '';   //obj.ContractStatus.getRawValue(); ��ȡ�����ֵ  getValue()��ȡ��̨��ֵ
			param.ArgCnt = 1;
	});
	};
    obj.PerUserStore.load();
	obj.AddDoFileUser= new Ext.form.ComboBox({
		id : 'AddDoFileUser'
		,width : 100
		,mode:'local'
		,minChars : 1
		,store:obj.PerUserStore
		,displayField:'Description'
		,valueField:'RowId'
		,fieldLabel : '�����û�'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
    obj.AddDoFileShire = new Ext.form.Checkbox({
		id : 'AddDoFileShire'
		,checked : false
		,fieldLabel : '�Ƿ���'
		,anchor : '99%'
	 });
    obj.AddDoFileAdd = new Ext.Button({
		id : 'AddDoFileAdd'
		,iconCls : 'icon-add'
		,text : '�ϴ�'
	});	 
	obj.AddDoFileDelete = new Ext.Button({
		id : 'AddDoFileDelete'
		,iconCls : 'icon-Delete'
		,text : 'ȡ��'
	});
	obj.AddDoFileAddFile = new Ext.Button({
		id : 'AddDoFileAddFile'
		,iconCls : 'icon-add'
		,text : '����ļ�'
	});
	obj.AddDoFileType = new Ext.form.TextField({
		id : 'AddDoFileType'
		,width : 100
		,hidden:true
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '����'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.AddDoFileRowid = new Ext.form.TextField({
		id : 'AddDoFileRowid'
		,width : 100
		,hidden:true
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'id'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.tbAddDocument = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tbAddDocument',
				items : [obj.AddDoFileAdd,'-',obj.AddDoFileDelete,'-',new Ext.Toolbar.TextItem('�����û���'),obj.AddDoFileUser,'-',new Ext.Toolbar.TextItem('�Ƿ����'),obj.AddDoFileShire,obj.AddDoFileType,obj.AddDoFileRowid]
			});
	//****************************** End ****************************
	obj.AddDoFileGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.AddDoFileGridStore = new Ext.data.Store({
		proxy: obj.AddDoFileGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['AddDoFileGridRowid'
		,'AddDoFileGridDesc'
		,'AddDoFileGridCode'
		,'AddDoFileGridSize'
		,'AddDoFileGridType'
		,'AddDoFileUrl'])
	});
	obj.AddDoFileGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'AddDoFileGridStore';
			param.Arg1 = '';
			param.ArgCnt = 1;
	});
	obj.AddDoFileCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.AddDoFileGridPanel = new Ext.grid.GridPanel({
		id : 'AddDoFileGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'���ڲ�ѯ�У����Ե�...'}
		,width : 850
		,height : 560
		,plugins : obj.AddDoFileCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.AddDoFileGridStore
		,tbar:obj.tbAddDocument
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.AddDoFileCheckCol
			, {header : "����",width : 60,forceFit : true,dataIndex : 'node',align : 'center',renderer: function (value, metaData, record, rowIndex, colIndex, store) {
			   var strRet = "";
				formatStr = "<a href='javascript:void({0});' onclick='javscript:return false;' class='AddDelete'>ɾ��</a>";
			    strRet = "<div class='controlBtn'>" + formatStr + "</div>";
			   return strRet;
			   }}
			, { header : 'Rowid', width : 150, dataIndex : 'AddDoFileGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '�ļ�����', width : 200, dataIndex : 'AddDoFileGridDesc', sortable : false ,align : 'center'}
			, { header : '�ļ�����', width : 100, dataIndex : 'AddDoFileGridCode', sortable : false, align : 'center',editable: true }
			, { header : '�ļ���С', width : 100, dataIndex : 'AddDoFileGridSize',sortable : true,align : 'center' }
			, { header : '�ļ�����', width : 100, dataIndex : 'AddDoFileGridType',sortable : true,align : 'center' }
			, { header : '�ļ�·��', width : 250, dataIndex : 'AddDoFileUrl',sortable : true,align : 'center' }]		
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.AddDoFileGridStore,
			displayMsg: '��ʾ��¼�� {0} - {1} �ϼƣ� {2}',
			displayInfo: true,
			emptyMsg: 'û�м�¼',
			items:['-',obj.AddDoFileAddFile]
		})	
	    ,iconCls: 'icon-grid'
		,viewConfig : {
			//forceFit : true
			enableRpwBody : true
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
	obj.menuwindAddDo = new Ext.Window({
		id : 'menuwindAddDo'
		,height : 440
		,buttonAlign : 'center'
		,width : 700
		,modal : true
		,title : '����ĵ�'
		,layout : 'fit'
		,border:true
		,items:[obj.AddDoFileGridPanel]
	});
	obj.AddDoFileGridStore.load();
	AddDocumentWindEvent(obj);	
	//�¼��������
	obj.LoadEvent(arguments);
	return obj;
}
