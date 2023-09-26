// /名称: 转移入库单据查询		
// /编写者：zhangdongmei
// /编写日期: 2012.07.24
// /2013-07-17 根据转移出库查询修改
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
    var gGroupId=session['LOGON.GROUPID'];
    var gLocId=session['LOGON.CTLOCID'];
    var gInciRowId="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	ChartInfoAddFun();
	// 登录设置默认值
	SetLogInDept(PhaDeptStore, "RequestPhaLoc");
	//取参数配置
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}
	function ChartInfoAddFun() {
		// 请求部门
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '接收部门',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '接收部门...',
					groupId:gGroupId
					
		});
		
		// 供给部门
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '供给部门',
					id : 'SupplyPhaLoc',
					name : 'SupplyPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '供给部门...',
					defaultLoc:{}
				});


		// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '起始日期',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 120,
					value : DefaultStDate()
				});
		// 截止日期
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '截止日期',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					width : 120,
					value : DefaultEdDate()
				});

		var StatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['10', '未完成'], ['11', '已完成'],['20', '出库审核不通过'],['21', '出库审核通过'],['30', '拒绝接收'],['31', '已接收'],['32', '部分接收']]
		});
		
		var Status = new Ext.form.ComboBox({
			fieldLabel : '转移单状态',
			id : 'Status',
			name : 'Status',
			anchor:'90%',
			width : 100,
			store : StatusStore,
			triggerAction : 'all',
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			editable : true,
			valueNotFoundText : ''
		});
		
		// 药品类组
		var StkGrpType=new Ext.ux.StkGrpComboBox({   //StkGrpType.store.reload();
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			width : 200
		}); 
		// 药品名称
		var InciDesc = new Ext.form.TextField({
			fieldLabel : '药品名称',
			id : 'InciDesc',
			name : 'InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});

			/**
		 * 调用药品窗体并返回结果
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
			var inciDr = record.get("InciDr");
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(InciDesc);
			gInciRowId=inciDr;
		}
		
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : '查询',
					tooltip : '点击查询',
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						Query();
					}
				});
		/**
		 * 查询方法
		 */
		function Query() {
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
			if (requestphaLoc == null || requestphaLoc.length <= 0) {
				Msg.info("warning", "请选择请求部门!");
				return;
			}
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			var statue =  Ext.getCmp("Status").getValue();
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var inci=gInciRowId;
			if(Ext.getCmp("InciDesc").getValue()==""){
				inci="";
			}
			var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^^'+statue+'^^^'+stkgrpid+"^"+inci;
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam('ParamStr',ListParam);
			MasterStore.load({params:{start:0, limit:Page}});
			DetailGrid.store.removeAll();
			MasterStore.removeAll();
			MasterStore.on('load',function(){
				if (MasterStore.getCount()>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
	        });
		}

		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
					text : '清屏',
					tooltip : '点击清屏',
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
					}
				});
		/**
		 * 清空方法
		 */
		function clearData() {
			SetLogInDept(PhaDeptStore, "SupplyPhaLoc");
			Ext.getCmp("RequestPhaLoc").setValue("");
			//Ext.getCmp("SupplyPhaLoc").setValue("");
			Ext.getCmp("Status").setValue("");
			//Ext.getCmp("StkGrpType").setValue("");
			StkGrpType.store.reload();
			Ext.getCmp("InciDesc").setValue("");
			Ext.getCmp("StartDate").setValue(DefaultStDate());
			Ext.getCmp("EndDate").setValue(DefaultEdDate());
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}
		
		// 打印按钮
		var PrintBT = new Ext.Toolbar.Button({
					text : '打印',
					tooltip : '点击打印',
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						var rowData=MasterGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", "请选择需要打印的转移单!");
							return;
						}
						var init = rowData.get("init");
						PrintInIsTrf(init,gParam[8]);
					}
				});
		
		// 访问路径
		var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName",
		"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode","inAckDate","inAckTime","inAckUser"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "init",
					fields : fields
				});
		// 数据集
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var MasterCm = new Ext.grid.ColumnModel([nm, {
					header : "RowId",
					dataIndex : 'init',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "转移单号",
					dataIndex : 'initNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '请求单号',
					dataIndex : 'reqNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "请求部门",
					dataIndex : 'toLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "供给部门",
					dataIndex : 'frLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "转移日期",
					dataIndex : 'dd',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : "单据状态",
					dataIndex : 'StatusCode',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "制单人",
					dataIndex : 'userName',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "入库确认日期",
					dataIndex : 'inAckDate',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "入库确认时间",
					dataIndex : 'inAckTime',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "入库确认人",
					dataIndex : 'inAckUser',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : "进价金额",
					dataIndex : 'RpAmt',
					width : 80,
					align : 'right',					
					sortable : true,
					renderer:FormatGridRpAmount
				}, {
					header : "售价金额",
					dataIndex : 'SpAmt',
					width : 80,
					align : 'right',					
					sortable : true,
					renderer:FormatGridSpAmount
				}, {
					header : "进销差价",
					dataIndex : 'MarginAmt',
					width : 80,
					align : 'right',					
					sortable : true,
					renderer:FormatGridRpAmount
				}, {
					header : "备注",
					dataIndex : 'Remark',
					width : 100,
					align : 'left',
					sortable : true
				}]);
		MasterCm.defaultSortable = true;
		var GridPagingToolbar = new Ext.PagingToolbar({
			store:MasterStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:'第 {0} 条到 {1}条, 一共 {2} 条',
			emptyMsg:"没有记录"
		});
		var MasterGrid = new Ext.grid.GridPanel({
					title : '',
					height : 170,
					cm : MasterCm,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					store : MasterStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					bbar:GridPagingToolbar
				});

		// 添加表格单击行事件
		MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var InIt = MasterStore.getAt(rowIndex).get("init");
			var status =  Ext.getCmp("Status").getValue();
			DetailStore.setBaseParam('Parref',InIt+"^"+status)
			DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
		});

		// 转移明细
		// 访问路径
		var DetailUrl =  DictUrl
					+ 'dhcinistrfaction.csp?actiontype=QueryDetail';;;
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["initi", "inrqi", "inci","inciCode",
				"inciDesc", "inclb", "batexp", "manf","manfName",
				 "qty", "uom", "sp","status","remark",
				"reqQty", "inclbQty", "reqLocStkQty", "reqstkbin",
				"pp", "spec", "gene", "formDesc","newSp",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "initi",
					fields : fields
				});
		// 数据集
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : "转移细项RowId",
					dataIndex : 'initi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "药品Id",
					dataIndex : 'inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '药品代码',
					dataIndex : 'inciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '药品名称',
					dataIndex : 'inciDesc',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : "批次Id",
					dataIndex : 'inclb',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "批次/效期",
					dataIndex : 'batexp',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "生产厂商",
					dataIndex : 'manfName',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : "批次库存",
					dataIndex : 'inclbQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "转移数量",
					dataIndex : 'qty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "转移单位",
					dataIndex : 'TrUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "进价",
					dataIndex : 'rp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : "售价",
					dataIndex : 'sp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : "请求数量",
					dataIndex : 'reqQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "货位码",
					dataIndex : 'reqstkbin',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "请求方库存",
					dataIndex : 'reqLocStkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "占用数量",
					dataIndex : 'inclbDirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "可用数量",
					dataIndex : 'inclbAvaQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "批次售价",
					dataIndex : 'newSp',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "规格",
					dataIndex : 'spec',
					width : 100,
					align : 'left',
					sortable : true
				},{
					header : "处方通用名",
					dataIndex : 'gene',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "剂型",
					dataIndex : 'formDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "售价金额",
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',					
					sortable : true,
					renderer:FormatGridSpAmount
				}, {
					header : "进价金额",
					dataIndex : 'rpAmt',
					width : 100,
					align : 'right',					
					sortable : true,
					renderer:FormatGridRpAmount
				}]);
       var GridDetailPagingToolbar = new Ext.PagingToolbar({
			store:DetailStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:'第 {0} 条到 {1}条, 一共 {2} 条',
			emptyMsg:"没有记录"
		});
		var DetailGrid = new Ext.grid.GridPanel({
					title : '',
					height : 200,
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					bbar:GridDetailPagingToolbar,
					loadMask : true
				});

		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
			labelAlign : 'right',
			title:"转移入库查询",
			frame : true,
			autoHeight:true,
			//autoScroll : true,
			tbar : [SearchBT, '-', ClearBT, '-', PrintBT],
			items:[{
				xtype:'fieldset',
				layout:'column',
				defaults:{border:false},
				title:'查询条件',
				style:DHCSTFormStyle.FrmPaddingV,
				items : [{ 				
					columnWidth: 0.3,
					xtype:'fieldset',
	            	items: [RequestPhaLoc,SupplyPhaLoc]
					
				},{ 				
					columnWidth: 0.23,
					xtype:'fieldset',	            	
					items: [StartDate,EndDate]
					
				},{ 				
					columnWidth: 0.23,
					xtype:'fieldset',
	            	items: [StkGrpType,InciDesc]
					
				},{ 				
					columnWidth: 0.23,
					xtype:'fieldset',
					labelWidth:80,
	            	items: [Status]
					
				}]
			}]
		});

		// 页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: '出库单',			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid       
			               
			            }, {
			                region: 'south',
			                split: true,
                			height: 250,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: '出库单明细',
			                layout: 'fit', // specify layout manager for items
			                items: DetailGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
	}

})