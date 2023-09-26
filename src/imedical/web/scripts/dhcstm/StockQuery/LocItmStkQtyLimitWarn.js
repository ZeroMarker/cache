// /名称: 库存报警-按上下限
// /描述:  库存报警-按上下限
// /编写者：zhangdongmei
// /编写日期: 2012.08.14
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
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

		var UseFlag = new Ext.form.Checkbox({
					hideLabel : true,
					boxLabel : '仅在用品种',
					id : 'UseFlag',
					name : 'UseFlag',
					anchor : '90%',
					checked : false
				});

		var StkBin = new Ext.ux.ComboBox({
					fieldLabel : '货位码',
					id : 'StkBin',
					name : 'StkBin',
					anchor : '90%',
					width : 140,
					//store : StkBinStore,
					store : LocStkBinStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{LocId:'PhaLoc'},
					filterName:'Desc'
				});
				
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
	
			// 可选条件
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
			var StkBin=Ext.getCmp("StkBin").getValue();
		
			gStrParam=phaLoc+"^"+StkGrpRowId+"^"+DHCStkCatGroup
			+"^"+StkBin+"^"+UseFlag;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize,Params:gStrParam}});

		}
				
		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
					iconCls : 'page_clearscreen',
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
			Ext.getCmp("UseFlag").setValue(false);
			Ext.getCmp("StkBin").setValue('');
			
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, sm, {
					header : "incil",
					dataIndex : 'incil',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '物资代码',
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "物资名称",
					dataIndex : 'desc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "规格",
					dataIndex : 'spec',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "单位",
					dataIndex : 'stkUom',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "可用库存",
					dataIndex : 'avaQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "库存上限",
					dataIndex : 'maxQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "库存下限",
					dataIndex : 'minQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "标准库存",
					dataIndex : 'repQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "厂商",
					dataIndex : 'manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : '库存分类',
					dataIndex : 'incscDesc',
					width : 150,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmStkQtyLimitWarn&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["incil", "inci", "code", "desc","spec", "manf", "maxQty", "minQty",
				"repQty", "avaQty", "incscDesc", "stkUom"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "incil",
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
			//		sm : new Ext.grid.CheckboxSelectionModel(),
					sm:sm,
					loadMask : true,
					bbar : StatuTabPagingToolbar,
					viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var StkQty=record.get("avaQty");
						var MaxQty=record.get("maxQty");
						var MinQty=record.get("minQty");
						if(parseFloat(StkQty)>MaxQty){
							return 'classRed';
						}else if(parseFloat(StkQty)<MinQty){
							return 'classGrassGreen';
						}					
                    }
            	}
		});
		
	var HisListTab = new Ext.ux.FormPanel({
		title:"库存报警-按上下限",
		tbar : [SearchBT, '-', RefreshBT],		
		items:[{
			xtype : 'fieldset',
			title : '查询条件',
			layout : 'column',	
			style : 'padding:5px 0px 0px 5px',
			defaults : {border:false,xtype:'fieldset'},
			items : [{
						columnWidth:0.3,
						items : [PhaLoc,StkBin]
					},{
						columnWidth:0.25,
						items : [StkGrpType,DHCStkCatGroup]
					},{
						columnWidth:0.15,
						items : [UseFlag]
					},{
						columnWidth:0.3,
						defaultType: 'textfield',
						labelWidth : 110,
						defaults: {width: 50, border:false},
						items : [{
							fieldLabel:'库存量高于上限',
							cls: 'my-background-Red'
						},{
							fieldLabel:'库存量低于下限',							
							cls: 'my-background-GrassGreen'
						}]
					}]
		    }]	
		});

	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [ HisListTab,StockQtyGrid],
		renderTo : 'mainPanel'
	});
})