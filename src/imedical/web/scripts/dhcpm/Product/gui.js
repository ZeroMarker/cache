//Create by zzp
// 20150515
//产品管理
function InitviewScreen(){
	var obj = new Object();
    obj.ProductTypeStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ProductTypeStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ProductSupplierStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ProductSupplierStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ProductTypeStore.load();
	obj.ProductSupplierStore.load();
	//******************************Start****************************
	obj.ProductCode	= new Ext.form.TextField({
		id : 'ProductCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '产品编码'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ProductDesc = new Ext.form.TextField({
		id : 'ProductDesc'
		,width : 150
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '产品名称'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		,valueField : 'rowid'
	});
	obj.ProductSupplier = new Ext.form.ComboBox({
		id : 'ProductSupplier'
		,width : 150
		,store : obj.ProductSupplierStore
		,minChars : 1
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '供应商'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductType = new Ext.form.ComboBox({
		id : 'ProductType'
		,width : 100
		,store : obj.ProductTypeStore
		,minChars : 1
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '产品分类'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductAdd = new Ext.Button({
		id : 'ProductAdd'
		,iconCls : 'icon-add'
		,text : '新增'
	});
	obj.ProductUpdate = new Ext.Button({
		id : 'ProductUpdate'
		,iconCls : 'icon-update'
		,text : '修改'
	});
	obj.ProductDelete = new Ext.Button({
		id : 'ProductDelete'
		,iconCls : 'icon-Delete'
		,text : '删除'
	});
	obj.ProductQuery = new Ext.Button({
		id : 'ProductQuery'
		,iconCls : 'icon-find'
		,text : '查询'
	});
	obj.ProductBatch = new Ext.Button({
		id : 'ProductBatch'
		,iconCls : 'icon-update'
		,text : '重置'
	});
	/**增改**/
	obj.tbbutton = new Ext.Toolbar({
			enableOverflow : true,
			items : [obj.ProductAdd, '-', obj.ProductUpdate,'-',obj.ProductDelete]
		});
	/** 搜索工具条 */
	obj.tb = new Ext.Toolbar({
	            //enableOverflow : true,
				id : 'tb',
				items : [new Ext.Toolbar.TextItem('产品编码：'),obj.ProductCode,'-',new Ext.Toolbar.TextItem('产品名称：'),obj.ProductDesc,'-',new Ext.Toolbar.TextItem('产品供应商：'),obj.ProductSupplier,'-',new Ext.Toolbar.TextItem('产品分类：'),obj.ProductType,'-',obj.ProductQuery,'-',obj.ProductBatch],
				listeners : {
					render : function() {
						obj.tbbutton.render(obj.ProductGridPanel.tbar);
					}
				}
			});
	
	//****************************** End ****************************
	obj.ProductGridStoreProxy = new Ext.data.HttpProxy(new Ext.data.Connection({
			url : ExtToolSetting.RunQueryPageURL
		}));
	obj.ProductGridStore = new Ext.data.Store({
		proxy: obj.ProductGridStoreProxy,
		reader: new Ext.data.JsonReader({
			root: 'record',
			totalProperty: 'total',
			idProperty: 'rowid'
		}, 
		['ProductGridRowid'
		,'ProductGridCode'
		,'ProductGridDesc'
		,'ProductGridType'
		,'ProductGridTypeid'
		,'ProductGridVersions'
		,'ProductGridStandard'
		,'ProductGridSupplier'
		,'ProductGridSupplierid'
		,'ProductGridProducer'
		,'ProductGridProducerid'
		,'ProductGridCount'
		,'ProductGridUnit'
		,'ProductGridUnitid'
		,'ProductGridPrice'
		,'ProductGridTotalPrice'
		,'ProductGridPData'
		,'ProductGridPTime'
		,'ProductGridPUser'
		,'ProductGridPUserid'
		,'ProductGridGData'
		,'ProductGridGTime'
		,'ProductGridGUser'
		,'ProductGridGUserid'
		,'ProductGridDate'
		,'ProductGridTime'
		,'ProductGridUser'
		,'ProductGridRemark'])
	});
	obj.ProductGridStoreProxy.on('beforeload', function(objProxy, param){
			param.ClassName = 'web.PMP.Document';
			param.QueryName = 'ProductGridStore';
			param.Arg1 = obj.ProductCode.getRawValue();
			param.Arg2 = obj.ProductDesc.getRawValue();
			param.Arg3 = obj.ProductSupplier.getValue();
			param.Arg4 = obj.ProductType.getValue();
			param.ArgCnt = 4;
	});
	obj.gridProductCheckCol = new Ext.grid.CheckColumn({dataIndex: 'checked', width: 40,checked:true });  //checkbox
	obj.ProductGridPanel = new Ext.grid.GridPanel({
		id : 'ProductGridPanel'
		,loadMask : true
		,buttonAlign : 'center'
		,loadMask : {text:'正在查询中，请稍等...'}
		//,region : 'west'
		//,split: true
		//,collapsible: true
		,width : 300
		,height: 100
		,minHeight: 10
        ,maxHeight: 500
		,plugins : obj.gridProductCheckCol
		,sm: new Ext.grid.RowSelectionModel({singleSelect:true})
		//,editable: true
		,store : obj.ProductGridStore
		,tbar:obj.tb
		,columns: [
			new Ext.grid.RowNumberer()
			//,obj.gridProductCheckCol
			, { header : 'Rowid', width : 200, dataIndex : 'ProductGridRowid', sortable : false ,hidden: true ,align : 'center'}
			, { header : '产品编码', width : 150, dataIndex : 'ProductGridCode', sortable : false, align : 'center',editable: true }
			, { header : '产品名称', width : 150, dataIndex : 'ProductGridDesc', sortable : false ,align : 'center'}
			, { header : '产品分类', width : 150, dataIndex : 'ProductGridType', sortable : true, align : 'center' }
			, { header : '产品分类id', width : 150, dataIndex : 'ProductGridTypeid', hidden: true ,sortable : true, align : 'center' }
			, { header : '版本/型号', width : 150, dataIndex : 'ProductGridVersions',sortable : true,align : 'center' }
			, { header : '产品规格', width : 150, dataIndex : 'ProductGridStandard',sortable : true,align : 'center' }
			, { header : '供应商', width : 150, dataIndex : 'ProductGridSupplier',sortable : true,align : 'center'}
			, { header : '供应商id', width : 150, dataIndex : 'ProductGridSupplierid',hidden: true ,sortable : true,align : 'center'}
			, { header : '生产商', width : 150, dataIndex : 'ProductGridProducer',sortable : true,align : 'center' }
			, { header : '生产商id', width : 150, dataIndex : 'ProductGridProducerid',hidden: true ,sortable : true,align : 'center' }
			, { header : '数量', width : 150, dataIndex : 'ProductGridCount',sortable : true,align : 'center' }
			, { header : '单位', width : 150, dataIndex : 'ProductGridUnit',sortable : true,align : 'center' }
			, { header : '单位id', width : 150, dataIndex : 'ProductGridUnitid',hidden: true ,sortable : true,align : 'center' }
			, { header : '单价', width : 150, dataIndex : 'ProductGridPrice',sortable : true,align : 'center' }
			, { header : '总价', width : 150, dataIndex : 'ProductGridTotalPrice',sortable : true,align : 'center' }
			, { header : '采购日期', width : 150, dataIndex : 'ProductGridPData',sortable : true,align : 'center' }
			, { header : '采购时间', width : 150, dataIndex : 'ProductGridPTime',sortable : true,align : 'center' }
			, { header : '采购人', width : 150, dataIndex : 'ProductGridPUser',sortable : true,align : 'center' }
			, { header : '采购人id', width : 150, dataIndex : 'ProductGridPUserid',hidden: true ,sortable : true,align : 'center' }
			, { header : '到货日期', width : 150, dataIndex : 'ProductGridGData',sortable : true,align : 'center' }
			, { header : '到货时间', width : 150, dataIndex : 'ProductGridGTime',sortable : true,align : 'center' }
			, { header : '到货接收人', width : 150, dataIndex : 'ProductGridGUser',sortable : true,align : 'center' }
			, { header : '到货接收人id', width : 150, dataIndex : 'ProductGridGUserid',hidden: true ,sortable : true,align : 'center' }
			, { header : '创建日期', width : 150, dataIndex : 'ProductGridDate',sortable : true,align : 'center' }
			, { header : '创建时间', width : 150, dataIndex : 'ProductGridTime',sortable : true,align : 'center' }
			, { header : '创建人', width : 150, dataIndex : 'ProductGridUser',sortable : true,align : 'center' }
			, { header : '备注', width : 150, dataIndex : 'ProductGridRemark',sortable : true,align : 'center' }]
		   ,bbar: new Ext.PagingToolbar({
			pageSize : 20,
			store : obj.ProductGridStore,
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
	obj.ProductPanal=new Ext.Panel({
			id : 'ProductPanal'
			,layout : 'fit'
			,width : '100%'
			,title:'产品管理'
			,region : 'center'
			//,collapsible: true
			,border:true
			,items:[obj.ProductGridPanel]
		});
		
	obj.viewScreen = new Ext.Viewport({
		id : 'viewScreen'
		,layout : 'border'
		,items : [obj.ProductPanal]});
	
	//--------------------------------------------------------------------------------------------
	obj.ProductGridStore.removeAll();
	obj.ProductGridStore.load({params : {start:0,limit:22}});
	InitviewScreenEvent(obj);	
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}
//新增、修改小界面
function ProductMenuWind(){
    var obj = new Object();
	obj.PUUserStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Common.csp?actiontype=DepartUserStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ProductMenuSupplierStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ProductSupplierStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ProductMenuTypeStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ProductTypeStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ProductMenuUnitStore=new Ext.data.Store({
	  			proxy: new Ext.data.HttpProxy({
			    url:'PMP.Document.csp?actiontype=ProductMenuUnitStore'
			}),
	    reader:new Ext.data.JsonReader({
	    				totalProperty : "results",
							root : 'rows'
							},['RowId','Description'])
    	});
	obj.ProductMenuSupplierStore.load();
	obj.ProductMenuTypeStore.load();
	obj.ProductMenuUnitStore.load();
	obj.PUUserStore.load();
	obj.ProductRowid= new Ext.form.TextField({
		id : 'ProductRowid'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : 'Rowid'
		//,editable : true
		,triggerAction : 'all'
		,disabled:true
		,anchor : '99%'
	});
	obj.ProductFlag	= new Ext.form.TextField({
		id : 'ProductFlag'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '操作类型'
		,disabled:true
		//,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ProductMenuCode	= new Ext.form.TextField({
		id : 'ProductMenuCode'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '产品编码'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ProductMenuDesc = new Ext.form.TextField({
		id : 'ProductMenuDesc'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '产品名称'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuType = new Ext.form.ComboBox({
		id : 'ProductMenuType'
		,width : 100
		,store : obj.ProductMenuTypeStore
		,minChars : 1
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '产品分类'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuVersions = new Ext.form.TextField({
		id : 'ProductMenuVersions'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '版本/型号'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuStandard = new Ext.form.TextField({
		id : 'ProductMenuStandard'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '产品规格'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuSupplier = new Ext.form.ComboBox({
		id : 'ProductMenuSupplier'
		,name:'ProductMenuSupplierName'
		,width : 100
		,store : obj.ProductMenuSupplierStore
		,minChars : 1
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '供应商'
		,valueNotFoundText : ''
		,editable : true
		,hiddenName:'ProductMenuSupplierName'
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuProducer = new Ext.form.ComboBox({
		id : 'ProductMenuProducer'
		,width : 100
		,store : obj.ProductMenuSupplierStore
		,minChars : 1
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '生产商'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuCount = new Ext.form.TextField({
		id : 'ProductMenuCount'
		,width : 100
		,minChars : 1
		,mode : 'local'
        ,displayField : 'desc'   //界面显示值
		,fieldLabel : '产品数量'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuUnit = new Ext.form.ComboBox({
		id : 'ProductMenuUnit'
		,width : 100
		,minChars : 1
		,mode : 'local'
	    ,store : obj.ProductMenuUnitStore   
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '产品单位'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuPrice = new Ext.form.TextField({
		id : 'ProductMenuPrice'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '单价'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuTotalPrice = new Ext.form.TextField({
		id : 'ProductMenuTotalPrice'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '总价'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuPurchaseData = new Ext.form.DateField({
		id : 'ProductMenuPurchaseData'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '采购日期'
		,format:'Y-m-d'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuPurchaseTime = new Ext.form.TimeField({
		id : 'ProductMenuPurchaseTime'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '采购时间'
		//,renderTo: Ext.get('times') 
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,invalidText:'请选择时间或输入有效格式的时间'
		,regexText:'时间格式错误，正确格式hh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ProductMenuPurchaseUser = new Ext.form.ComboBox({
		id : 'ProductMenuPurchaseUser'
		,width : 100
		,store : obj.PUUserStore
		,minChars : 1
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '采购人员'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuGoodsData = new Ext.form.DateField({
		id : 'ProductMenuGoodsData'
		,width : 100
		//,store : obj.cboLocStore
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '到货日期'
		,format:'Y-m-d'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuGoodsTime = new Ext.form.TimeField({
		id : 'ProductMenuGoodsTime'
		,width : 100
		,minChars : 1
		,displayField : 'desc'
		,fieldLabel : '到货时间'
		//,renderTo: Ext.get('times') 
	    ,regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/
		,invalidText:'请选择时间或输入有效格式的时间'
		,regexText:'时间格式错误，正确格式hh:mm:ss'
		,autoShow: true
	    ,format: 'H:i:s'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ProductMenuGoodsUser = new Ext.form.ComboBox({
		id : 'ProductMenuGoodsUser'
		,width : 100
		,store : obj.PUUserStore
		,minChars : 1
		,valueField : 'RowId'  //后台值
        ,displayField : 'Description'   //界面显示值
		,fieldLabel : '接收人员'
		,valueNotFoundText : ''
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
		//,valueField : 'rowid'
	});
	obj.ProductMenuRemark = new Ext.form.TextArea({
		id : 'ProductMenuRemark'
		,width : 100
		,minChars : 1
		,height : 150
		,displayField : 'desc'
		,fieldLabel : '备注信息'
		,editable : true
		,triggerAction : 'all'
		,anchor : '99%'
	});
	obj.ProductMenuAdd = new Ext.Button({
		id : 'ProductMenuAdd'
		,iconCls : 'icon-add'
		,text : '保存'
	});
	obj.ProductMenuDelete = new Ext.Button({
		id : 'ProductMenuDelete'
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
		,labelWidth:60
		,frame : true
		,items:[{   // 行1
                layout : "column",         // 从左往右的布局
                items : [{
                          columnWidth : .5       // 该列有整行中所占百分比
                          ,layout : "form"       // 从上往下的布局
                          ,items : [obj.ProductRowid]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ProductFlag]
                         }]
                },{ // 行2
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.ProductMenuCode]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ProductMenuDesc]
                         }]
                },{ // 行3
                layout : "column",        
                items : [{
                          columnWidth : .5      
                          ,layout : "form"     
                          ,items : [obj.ProductMenuSupplier]
                         },{
                          columnWidth : .5
                          ,layout : "form"
                          ,items : [obj.ProductMenuProducer]
                         }]
                },{ // 行4
                layout : "column",        
                items : [{
                          columnWidth : .25     
                          ,layout : "form"     
                          ,items : [obj.ProductMenuCount]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ProductMenuUnit]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ProductMenuPrice]
                         },{
                          columnWidth : .25
                          ,layout : "form"
                          ,items : [obj.ProductMenuTotalPrice]
                         }]
                },{ // 行5
                layout : "column",        
                items : [{
                          columnWidth : .33      
                          ,layout : "form"     
                          ,items : [obj.ProductMenuType]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.ProductMenuVersions]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.ProductMenuStandard]
                         }]
                },{ // 行6
                layout : "column",        
                items : [{
                          columnWidth : .33      
                          ,layout : "form"     
                          ,items : [obj.ProductMenuPurchaseData]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.ProductMenuPurchaseTime]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.ProductMenuPurchaseUser]
                         }]
                },{ // 行7
                layout : "column",        
                items : [{
                          columnWidth : .33      
                          ,layout : "form"     
                          ,items : [obj.ProductMenuGoodsData]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.ProductMenuGoodsTime]
                         },{
                          columnWidth : .33
                          ,layout : "form"
                          ,items : [obj.ProductMenuGoodsUser]
                         }]
                },{ // 行8
                layout : "column",        
                items : [{
                          columnWidth : 1      
                          ,layout : "form"     
                          ,items : [obj.ProductMenuRemark]
                         }]
                }]
	}); 
	obj.menuwindadd = new Ext.Window({
		id : 'menuwindadd'
		,height : 430
		,buttonAlign : 'center'
		,width : 560
		,modal : true
		,title : '产品明细'
		,layout : 'form'
		,border:true
		,items:[
			   obj.winTPanelMenuadd
		]
		,buttons:[
			   obj.ProductMenuAdd
			  ,obj.ProductMenuDelete
		]
	});
	ProductMenuWindEvent(obj);
	//事件处理代码
	obj.LoadEvent(arguments);
	return obj;
}
