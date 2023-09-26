//Create by zs
// 20150515
//文件审核管理管理
function InitviewScreen(){
	var obj = new Object();
		//文档创建人
		obj.DocumentCreatUserStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=DocumentCreatUserStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
		//文档分组
		obj.DocumentGroupStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=DocumentGroupStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
		//文档级别
		obj.DocumentLevelStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=DocumentLevelStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.DocumentCreatUserStore.load();
	obj.DocumentGroupStore.load();
	obj.DocumentLevelStore.load();
	//******************************Start****************************
		obj.TextArry=new Ext.Panel({
		//renderTo:Ext.getBody(),
		//title:'解决方案',
		//width:700,
		height:145,
		//autoHeight : true,
		autoWidth : true,
		layout:'column',
		Resizable:'yes',
		items:[{xtype:'htmleditor',id:'TextArry',autoWidth : true}]
		});
	
		obj.DocumentCreatUser = new Ext.form.ComboBox({
		id : 'DocumentCreatUser'
		,width : 150
		,store : obj.DocumentCreatUserStore
		,minChars : 1
		,valueField : 'RowId'           //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '创建人员'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
		obj.DocumentGroup = new Ext.form.ComboBox({
		id : 'DocumentGroup'
		,width : 150
		,store : obj.DocumentGroupStore
		,minChars : 1
		,valueField : 'RowId'           //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '文档分组'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
		obj.DocumentLevel = new Ext.form.ComboBox({
		id : 'DocumentLevel'
		,width : 150
		,store : obj.DocumentLevelStore
		,minChars : 1
		,valueField : 'RowId'           //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '文档级别'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.DocumentCode = new Ext.form.TextField({
		id : 'DocumentCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '编码'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.DocumentDesc = new Ext.form.TextField({
		id : 'DocumentDesc'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '描述'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.DocumentCreatDate = new Ext.form.DateField({
		id : 'DocumentCreatDate'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '创建日期'
		,format:'Y-m-d'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.DocumentAdd = new Ext.Button({
		id : 'DocumentAdd'
		,iconCls : 'icon-add'
		,text : '调整记录'
	});
	obj.DocumentUpdate = new Ext.Button({
		id : 'DocumentUpdate'
		,iconCls : 'icon-update'
		,text : '审核通过'
	});
	obj.DocumentDelete = new Ext.Button({
		id : 'DocumentDelete'
		,iconCls : 'icon-delete'
		,text : '删除记录'
	});
	obj.DocumentQuery = new Ext.Button({
		id : 'DocumentQuery'
		,iconCls : 'icon-find'
		,text : '查询'
	});
	obj.DocumentBatch = new Ext.Button({
		id : 'DocumentBatch'
		,iconCls : 'icon-update'
		,text : '重置'
	});
	/**增删改工具条**/
	obj.AUDTools = new Ext.Toolbar({
			labelAlign : 'center',
			buttonAlign : 'center',
			enableOverflow : true,
			items : [obj.DocumentAdd, '-', obj.DocumentUpdate,'-',obj.DocumentDelete]
	});
	/**查询重置工具条**/
	obj.QBTools = new Ext.Toolbar({
			enableOverflow : true,
			labelAlign : 'center',
			buttonAlign : 'center',
			items : [obj.DocumentQuery,'-',obj.DocumentBatch]
		});
	obj.winTPanelMenuadd = new Ext.form.FormPanel({
		id : 'winTPanelMenuadd'
		//,labelAlign : 'right'
		,buttonAlign : 'center'
		,autoHeight : true
        ,autoWidth : true
		,layout : 'form'
		,hideLabel:false
		,labelAlign : 'center'
		,labelWidth:60
		,frame : true		
		,items:[{   // 增加删除修改工具条
                layout : "column",               // 从左往右的布局
                items : [{
						  columnWidth : 1
                          ,layout : "form"       // 从上往下的布局
                          ,items : [obj.AUDTools]
                         }]
								},{   //增加控制布局
                layout : "column",              
                items : [{
						  columnWidth : 1
						  ,margins:'10,0,0,0'
                          ,layout : "form"       
                          ,items : []
                         }]
				},{   // 文档编码
                layout : "column",               
                items : [{
						  columnWidth : 1
                          ,layout : "form"       
                          ,items : [obj.DocumentCode]
                         }]
				},{  // 文档名称
                layout : "column",        
                items : [{
						  columnWidth : 1					
                          ,layout : "form"     
                          ,items : [obj.DocumentDesc]
                         }]
				},{ // 创建人
                layout : "column",        
                items : [{ 
						  columnWidth : 1				
                          ,layout : "form"     
                          ,items : [obj.DocumentCreatUser]
                         }]
				},{ // 创建日期
                layout : "column",        
                items : [{ 
						  columnWidth : 1				
                          ,layout : "form"     
                          ,items : [obj.DocumentCreatDate]
                         }]
				},{ // 文档分组
                layout : "column",        
                items : [{ 
						  columnWidth : 1				
                          ,layout : "form"     
                          ,items : [obj.DocumentGroup]
                         }]
				},{ // 文档级别
                layout : "column",        
                items : [{ 
						  columnWidth : 1				
                          ,layout : "form"     
                          ,items : [obj.DocumentLevel]
                         }]
						 				},{ // 文档级别
                layout : "column",        
                items : [{ 
						  columnWidth : 1
                          ,layout : "form"     
                          ,items : [obj.QBTools]
                         }]
				}]
						 
	});
	//****************************** End ****************************
	
    obj.DocumentGridStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=DocumentGridStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
										},['CompanyGridRowid','CompanyGridCode','CompanyGridDesc','CompanyGridAddress','CompanyGridPhone','CompanyGridWebsite','CompanyGridEmail','CompanyGridLawPerson','CompanyGridType','CompanyGridListing','CompanyGridPhone1','CompanyGridPhone2','CompanyGridPostCdoe','CompanyGridEmail1','CompanyGridEmail2','CompanyGridFlag','CompanyGridRemark','CompanyGridCreatUser','CompanyGridCreatDate','CompanyGridCreatTime'])
    	});
	obj.gridDocumentCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.DocumentGridPanel = new Ext.grid.GridPanel({
		id : 'DocumentGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'正在查询中，请稍等...'}
		,width : 400
		,height : 380
		,plugins : obj.gridDocumentCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.DocumentGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridDocumentCheckCol
			, { header : 'Rowid', width : 200, dataIndex : 'DocumentGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '文档编码', width : 150, dataIndex : 'DocumentGridCode', sortable : false, align : 'center',editable: true }
			, { header : '文档名称', width : 150, dataIndex : 'DocumentGridDesc', sortable : false ,align : 'center'}
			, { header : '创建人员', width : 100, dataIndex : 'DocumentGridCreatUser', sortable : true, align : 'center' }
			, { header : '创建日期', width : 150, dataIndex : 'DocumentGridCreatDate',sortable : true,align : 'center' }
			, { header : '创建时间', width : 150, dataIndex : 'DocumentGridCreatTime',sortable : true,align : 'center'}
			, { header : '文档分组', width : 150, dataIndex : 'DocumentGridGroup',sortable : true,align : 'center' }
			, { header : '文档级别', width : 150, dataIndex : 'DocumentGridLevel',sortable : true,align : 'center' }
			, { header : '文档状态', width : 150, dataIndex : 'DocumentGridStatus',sortable : true,align : 'center' }
			, { header : '下载次数', width : 150, dataIndex : 'DocumentGridDownloadsCount',sortable : true,align : 'center' }
			, { header : '接收标志', width : 150, dataIndex : 'DocumentGridReceive',sortable : true,align : 'center' }]		
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.DocumentGridStore,
			displayMsg: '显示记录： {0} - {1} 合计： {2}',
			displayInfo: true,
			emptyMsg: '没有记录'
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
	obj.DocumentFrm=new Ext.Panel({
			id : 'DocumentFrm'
			,layout : 'fit'
			,title:'文件列表'
			,width : '100%'
			,region : 'center'
			,collapsible: true
			,border:true
			,items:[obj.DocumentGridPanel]
		});	
	obj.FrmMain=new Ext.form.FormPanel({
			  labelAlign:'left',    
              autoHeight : true,
              autoWidth : true,
              bodyStyle:'margin-left:5',
              buttonAlign:'center',  
              frame:true,
              layout:"column",
              hideLabel:false,
              labelWidth:60,
              items:[obj.TextArry,obj.DocumentFrm]
              });
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [{region:"west",
		    width:300,
	        collapsible:true,
	        frame:true,     //面板属性  
	        title:"查询信息",
	        layout:"form",
	        items:obj.winTPanelMenuadd	
	        },
	        {region:"center",
	        collapsible:true,
	        frame:true,     
	        title:"文件审核",
	        layout:"form",
	        items:obj.FrmMain	        
	        }]
	});
	
	//--------------------------------------------------------------------------------------------
	obj.DocumentGridStore.removeAll();
	obj.DocumentGridStore.load();
	InitviewScreenEvent(obj);	
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}
