//Create by zzp
// 20150515
//公司管理
function InitviewScreen(){
	var obj = new Object();
	//******************************Start****************************
	obj.CompanyTel	= new Ext.form.TextField({
		id : 'CompanyTel'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '联系方式'
		,regex:  /^\d+(\.\d{1,2})?$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CompanyCode = new Ext.form.TextField({
		id : 'CompanyCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '编码'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.CompanyDesc = new Ext.form.TextField({
		id : 'CompanyDesc'
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
	obj.CompanyAddress = new Ext.form.TextField({
		id : 'CompanyAddress'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '地址'
		,editable : true
		//,regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyAdd = new Ext.Button({
		id : 'CompanyAdd'
		,iconCls : 'icon-add'
		,text : '新增'
	});
	obj.CompanyUpdate = new Ext.Button({
		id : 'CompanyUpdate'
		,iconCls : 'icon-update'
		,text : '修改'
	});
	obj.CompanyDelete = new Ext.Button({
		id : 'CompanyDelete'
		,iconCls : 'icon-delete'
		,text : '删除'
	});
	obj.CompanyQuery = new Ext.Button({
		id : 'CompanyQuery'
		,iconCls : 'icon-find'
		,text : '查询'
	});
	obj.CompanyBatch = new Ext.Button({
		id : 'CompanyBatch'
		,iconCls : 'icon-update'
		,text : '重置'
	});
	/**增改**/
	obj.tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [obj.CompanyAdd, '-', obj.CompanyUpdate,'-',obj.CompanyDelete]
		});
	/** 搜索工具条 */
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('编码：'),obj.CompanyCode,'-',new Ext.Toolbar.TextItem('描述：'),obj.CompanyDesc,'-',new Ext.Toolbar.TextItem('联系方式：'),obj.CompanyTel,'-',new Ext.Toolbar.TextItem('地址：'),obj.CompanyAddress,'-',obj.CompanyQuery,'-',obj.CompanyBatch],
				listeners : {
					render : function() {
						obj.tbbutton.render(obj.CompanyGridPanel.tbar);
					}
				}
			});
	
	//****************************** End ****************************
	
    obj.CompanyGridStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CompanyGridStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['CompanyGridRowid','CompanyGridCode','CompanyGridDesc','CompanyGridAddress','CompanyGridPhone','CompanyGridWebsite','CompanyGridEmail','CompanyGridLawPerson','CompanyGridType','CompanyGridListing','CompanyGridPhone1','CompanyGridPhone2','CompanyGridPostCdoe','CompanyGridEmail1','CompanyGridEmail2','CompanyGridFlag','CompanyGridRemark','CompanyGridCreatUser','CompanyGridCreatDate','CompanyGridCreatTime','CompanyGridTypeid','CompanyGridListingid'])
    	});
	obj.gridCompanyCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.CompanyGridPanel = new Ext.grid.GridPanel({
		id : 'CompanyGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'正在查询中，请稍等...'}
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.gridCompanyCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.CompanyGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridCompanyCheckCol
			, { header : 'Rowid', width : 200, dataIndex : 'CompanyGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '公司编码', width : 200, dataIndex : 'CompanyGridCode', sortable : false, align : 'center',editable: true }
			, { header : '公司名称', width : 200, dataIndex : 'CompanyGridDesc', sortable : false ,align : 'center'}
			, { header : '公司地址', width : 300, dataIndex : 'CompanyGridAddress', sortable : true, align : 'center' }
			, { header : '公司电话', width : 150, dataIndex : 'CompanyGridPhone',sortable : true,align : 'center' }
			, { header : '公司网址', width : 150, dataIndex : 'CompanyGridWebsite',sortable : true,align : 'center'}
			, { header : '公司邮箱', width : 150, dataIndex : 'CompanyGridEmail',sortable : true,align : 'center' }
			, { header : '法人代表', width : 150, dataIndex : 'CompanyGridLawPerson',sortable : true,align : 'center' }
			, { header : '公司类型', width : 150, dataIndex : 'CompanyGridType',sortable : true,align : 'center' }
			, { header : '是否上市', width : 150, dataIndex : 'CompanyGridListing',sortable : true,align : 'center' }
			, { header : '公司电话1', width : 150, dataIndex : 'CompanyGridPhone1',sortable : true,align : 'center' }
			, { header : '公司电话2', width : 150, dataIndex : 'CompanyGridPhone2',sortable : true,align : 'center' }
			, { header : '邮编', width : 150, dataIndex : 'CompanyGridPostCdoe',sortable : true,align : 'center' }
			, { header : '公司邮箱1', width : 150, dataIndex : 'CompanyGridEmail1',sortable : true,align : 'center' }
			, { header : '公司邮箱2', width : 150, dataIndex : 'CompanyGridEmail2',sortable : true,align : 'center' }
			, { header : '有效标志', width : 150, dataIndex : 'CompanyGridFlag',sortable : true,align : 'center' }
			, { header : '备注', width : 150, dataIndex : 'CompanyGridRemark',sortable : true,align : 'center' }
			, { header : '创建人', width : 150, dataIndex : 'CompanyGridCreatUser',sortable : true,align : 'center' }
			, { header : '创建日期', width : 150, dataIndex : 'CompanyGridCreatDate',sortable : true,align : 'center' }
			, { header : '创建时间', width : 150, dataIndex : 'CompanyGridCreatTime',sortable : true,align : 'center' }
			, { header : '公司类型id', width : 150, dataIndex : 'CompanyGridTypeid',hidden:true,sortable : true,align : 'center' }
			, { header : '是否上市id', width : 150, dataIndex : 'CompanyGridListingid',hidden:true,sortable : true,align : 'center' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.CompanyGridStore,
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
	obj.CompanyPanal=new Ext.Panel({
			id : 'CompanyPanal'
			,layout : 'fit'
			,title:'公司管理'
			,width : '100%'
			,region : 'center'
			,collapsible: true
			,border:true
			,items:[obj.CompanyGridPanel]
		});
		
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [obj.CompanyPanal]});
	
	//--------------------------------------------------------------------------------------------
	obj.CompanyGridStore.removeAll();
	obj.CompanyGridStore.load();
	InitviewScreenEvent(obj);	
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}

function CompanyMenuWind(){
    var obj = new Object();
	obj.CompanyMenuTypeStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CompanyMenuTypeStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.CompanyMenuListingStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=CompanyMenuListingStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.CompanyMenuTypeStore.load();
	obj.CompanyMenuListingStore.load();
	obj.CompanyRowid= new Ext.form.TextField({
		id : 'CompanyRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.CompanyFlag	= new Ext.form.TextField({
		id : 'CompanyFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '操作类型'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CompanyMenuCode	= new Ext.form.TextField({
		id : 'CompanyMenuCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '公司编码'
		//,regex:  /^\d+(\.\d{1,2})?$/
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CompanyMenuDesc = new Ext.form.TextField({
		id : 'CompanyMenuDesc'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '公司名称'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuAddress = new Ext.form.TextField({
		id : 'CompanyMenuAddress'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '公司地址'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuTel = new Ext.form.TextField({
		id : 'CompanyMenuTel'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '公司电话'
		,editable : true
		,regex:  /^\d+(\.\d{1,2})?$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuWebsite = new Ext.form.TextField({
		id : 'CompanyMenuWebsite'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '公司网址'
		,editable : true
		//,regex:  ((http|https|ftp):(\/\/|\\\\)((\w)+[.]){1，}(net|com|cn|org|cc|tv|[0-9]{1，3})(((\/[\~]*|\\[\~]*)(\w)+)|[.](\w)+)*(((([?](\w)+){1}[=]*))*((\w)+){1}([\&](\w)+[\=](\w)+)*)*)
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuEmeail = new Ext.form.TextField({
		id : 'CompanyMenuEmeail'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '公司邮箱'
		,editable : true
		,regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuLawPerson = new Ext.form.TextField({
		id : 'CompanyMenuLawPerson'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '法人代表'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuType = new Ext.form.ComboBox({
		id : 'CompanyMenuType'
		,width : 100
		,minChars : 1
		,mode : 'local'
	    ,store : obj.CompanyMenuTypeStore   
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '公司类型'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuListing = new Ext.form.ComboBox({
		id : 'CompanyMenuListing'
		,width : 100
		,minChars : 1
		,mode : 'local'
	    ,store : obj.CompanyMenuListingStore   
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '是否上市'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuTel1 = new Ext.form.TextField({
		id : 'CompanyMenuTel1'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '公司电话1'
		,editable : true
		,regex:  /^\d+(\.\d{1,2})?$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuTel2 = new Ext.form.TextField({
		id : 'CompanyMenuTel2'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '公司电话2'
		,editable : true
		,regex:  /^\d+(\.\d{1,2})?$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuPostCdoe = new Ext.form.TextField({
		id : 'CompanyMenuPostCdoe'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '邮编'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuEmeail1 = new Ext.form.TextField({
		id : 'CompanyMenuEmeail1'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '公司邮箱1'
		,editable : true
		,regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuEmeail2 = new Ext.form.TextField({
		id : 'CompanyMenuEmeail2'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '公司邮箱2'
		,editable : true
		,regex: /^\s*\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*(\;\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*)*(\;)*\s*$/
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.CompanyMenuRemark = new Ext.form.TextArea({
		id : 'CompanyMenuRemark'
		,width : 100
		,minChars : 1
		,height : 150
		,displayField : 'desc'
		,fieldLabel : '备注信息'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.CompanyMenuAdd = new Ext.Button({
		id : 'CompanyMenuAdd'
		,iconCls : 'icon-add'
		,text : '保存'
	});
	obj.CompanyMenuDelete = new Ext.Button({
		id : 'CompanyMenuDelete'
		,iconCls : 'icon-delete'
		,text : '取消'
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
		,labelWidth:65
		,frame : true
		,items:[{   // 行1
                layout : "column",         // 从左往右的布局
                items : [{
                          columnWidth : .5       // 该列有整行中所占百分比
                          ,layout : "form"       // 从上往下的布局
                          ,items : [obj.CompanyRowid]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CompanyFlag]
                         }]
                },{ // 行2
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuCode]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CompanyMenuDesc]
                         }]
                },{ // 行3
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuTel]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CompanyMenuEmeail]
                         }]
                },{ // 行4
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuTel1]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CompanyMenuTel2]
                         }]
                },{ // 行5
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuEmeail1]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CompanyMenuEmeail2]
                         }]
                },{ // 行6
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuWebsite]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.CompanyMenuPostCdoe]
                         }]
                },{ // 行7
                layout : "column",        
                items : [{
                          columnWidth : .33      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuLawPerson]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.CompanyMenuType]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.CompanyMenuListing]
                         }]
                },{ // 行8
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuAddress]
                         }]
                },{ // 行9
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.CompanyMenuRemark]
                         }]
                }]
	}); 
	obj.menuwindadd = new Ext.Window({
		id : 'menuwindadd'
		,height : 470
		,buttonAlign : 'center'
		,width : 550
		,modal : true
		,title : '公司明细'
		,layout : 'form'
		,border:true
		,items:[
			   obj.winTPanelMenuadd
		]
		,buttons:[
			   obj.CompanyMenuAdd
			  ,obj.CompanyMenuDelete
		]
	});
	CompanyMenuWindEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}