// /名称: 库存报警-按上下限
// /描述:  库存报警-按上下限
// /编写者：zhangdongmei
// /编写日期: 2012.08.14
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gIncId='';
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId=session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	
	//统计科室
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '科室',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId,
			stkGrpId : 'StkGrpType'
		});
		
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		anchor:'90%',
		width : 140,
		LocId:gLocId,
		UserId:gUserId,
		childCombo : 'DHCStkCatGroup'
	}); 
	
	var DHCStkCatGroup = new Ext.ux.ComboBox({
				fieldLabel : '库存分类',
				id : 'DHCStkCatGroup',
				name : 'DHCStkCatGroup',
				anchor : '90%',
				store : StkCatStore,
				valueField : 'RowId',
				displayField : 'Description',
				params:{StkGrpId:'StkGrpType'}
			});
	var InciDesc = new Ext.form.TextField({
	fieldLabel : '物资名称',
	id : 'InciDesc',
	name : 'InciDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var inputDesc=field.getValue();
				var stkGrp=Ext.getCmp("StkGrpType").getValue();
				GetPhaOrderInfo(inputDesc,stkGrp);
				}
			}
		}
	});
    /**
     * 调用物资窗体并返回结果
     */
    function GetPhaOrderInfo(item, stktype) {
        if (item != null && item.length > 0) {
            GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
        }
    }
    /**
     * 返回方法
     */
    function getDrugList(record) {
        if (record == null || record == "") {
            return;
        }
        gIncId = record.get("InciDr");
        var incDesc=record.get("InciDesc");
        Ext.getCmp("InciDesc").setValue(incDesc);
    }
			
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : '查询',
					tooltip : '点击查询',
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						searchData();
					}
				});

		/**
		 * 查询方法
		 */
		function searchData() {
			// 必选条件
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "科室不能为空！");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
	        if(Ext.getCmp("InciDesc").getValue()==""){
            	gIncId="";
        	}
			// 可选条件
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
		
			gStrParam=phaLoc+"^"+StkGrpRowId+"^"+DHCStkCatGroup+"^"+gIncId;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize,Params:gStrParam}});

		}
				
		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
					iconCls : 'page_refresh',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * 清空方法
		 */
		function clearData() {
			gStrParam='';
			Ext.getCmp("DHCStkCatGroup").setValue('');			
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
					header : "ILERowId",
					dataIndex : 'ILERowId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				},{
					header : "Inci",
					dataIndex : 'Inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '物资代码',
					dataIndex : 'InciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "物资名称",
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "具体规格",
					dataIndex : 'SpecDesc',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "基本单位",
					dataIndex : 'BUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				},{
					header : "包装单位",
					dataIndex : 'PUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "可用库存",
					dataIndex : 'AvaQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "库存上限",
					dataIndex : 'MaxQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "库存下限",
					dataIndex : 'MinQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : '库存分类',
					dataIndex : 'IncscDesc',
					width : 150,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmSpecStkQtyLimitWarn&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["ILERowId", "Inci", "InciCode", "InciDesc","SpecDesc", "BUomDesc", "PUomDesc", "AvaQty",
				"MaxQty", "MinQty", "IncscDesc"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "ILERowId",
					fields : fields
				});
		// 数据集
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
					emptyMsg : "No results to display",
					prevText : "上一页",
					nextText : "下一页",
					refreshText : "刷新",
					lastText : "最后页",
					firstText : "第一页",
					beforePageText : "当前页",
					afterPageText : "共{0}页",
					emptyMsg : "没有数据",
					doLoad:function(C){
						var B={},
						A=this.getParams();
						B[A.start]=C;
						B[A.limit]=this.pageSize;
						B[A.sort]='desc';
						B[A.dir]='ASC';
						
						B['Params']=gStrParam;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});

		var StockQtyGrid = new Ext.ux.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					//sm : new Ext.grid.CheckboxSelectionModel(),
					sm:sm,
					loadMask : true,
					bbar : StatuTabPagingToolbar,
					viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var StkQty=record.get("AvaQty");
						var MaxQty=record.get("MaxQty");
						var MinQty=record.get("MinQty");
						if(parseFloat(StkQty)>MaxQty){
							return 'classRed';
						}else if(parseFloat(StkQty)<MinQty){
							return 'classGrassGreen';
						}					
                    }
            	}
		});
	
var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			region : 'north',
			title:"库存报警-按具体规格库存上下限",
			height : 200,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 1px 1px 5px;',
			tbar : [SearchBT, '-', RefreshBT],		
		    items:[{
						layout : 'column',	
						title:'查询条件',	
						xtype: 'fieldset',
						defaults: { border:false},
						items : [{
									columnWidth:0.3,
									autoHeight : true,
									height:150,
									xtype: 'fieldset',
									defaults: {width: 180, border:false},    // Default config options for child items
									items : [PhaLoc,InciDesc]
								},{
									columnWidth:0.25,
									autoHeight : true,
									height:150,
									xtype: 'fieldset',
									defaults: {width: 180, border:false},    // Default config options for child items
									items : [StkGrpType,DHCStkCatGroup]
								},{
									columnWidth:0.2,
									autoHeight : true,
									height:150,
									xtype: 'fieldset',
									defaultType: 'textfield',
									defaults: {width: 80, border:false},    // Default config options for child items
									items : [{
										fieldLabel:'库存量高于上限',
										//style:{background-color:'#FF0000'},
										cls: 'my-background-Red'
									},{
										fieldLabel:'库存量低于下限',							
										cls: 'my-background-GrassGreen'
									}]
								}]
		    }]	
		});
// 5.2.页面布局
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [ HisListTab       
			               
			            , {
			                region: 'center',
			                title: '明细',			               
			                layout: 'fit', // specify layout manager for items
			                items: StockQtyGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
})