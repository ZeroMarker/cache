// /名称: 采购计划单执行情况查询
// /描述: 采购计划单执行情况查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.03

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gIncId='';
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var PurNo = new Ext.form.TextField({
				fieldLabel : '采购单号',
				id : 'PurNo',
				name : 'PurNo',
				anchor : '90%',
				width : 120
			});

	// 供应商
	var Vendor = new Ext.ux.VendorComboBox({
				fieldLabel : '供应商',
				id : 'Vendor',
				name : 'Vendor',
				anchor : '90%',
				emptyText : '供应商...',
				params : {LocId : 'PhaLoc'}
	});
// 物资类组
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			width : 200
		}); 
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '采购部门',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : '采购部门...',
				groupId:session['LOGON.GROUPID'],
				childCombo : 'Vendor'
			});
	// 请求部门
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '请求部门',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '请求部门...',
					defaultLoc:{}
		});
		// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '起始日期',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					
					width : 120,
					value : new Date().add(Date.DAY, - 7)
				});
		// 截止日期
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '截止日期',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					
					width : 120,
					value : new Date()
				});

			
		var InciDesc = new Ext.form.TextField({
			fieldLabel : '物资名称',
			id : 'InciDesc',
			name : 'InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = '';
						GetPhaOrderInfo(field.getValue(), stktype);
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
			Ext.getCmp("InciDesc").setValue(record.get("InciDesc"));
		}
		
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : '查询',
					tooltip : '点击查询',
					width : 70,
					height : 30,
					iconCls:'page_find',
					handler : function() {
						Query();
					}
				});
		/**
		 * 查询方法
		 */
		function Query() {
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "请选择采购部门!");
				return;
			}
			var reqloc=Ext.getCmp("RequestPhaLoc").getValue();
			var VenId = Ext.getCmp("Vendor").getValue();
			var startDate = Ext.getCmp("StartDate").getValue();
			if(Ext.isEmpty(startDate)){
				Msg.info('warning', '起始日期不可为空');
				return false;
			}
			startDate = startDate.format(ARG_DATEFORMAT);
			var endDate = Ext.getCmp("EndDate").getValue();
			if(Ext.isEmpty(endDate)){
				Msg.info('warning', '截止日期不可为空');
				return false;
			}
			endDate = endDate.format(ARG_DATEFORMAT);
			var PurNo =  Ext.getCmp("PurNo").getValue();
			if(Ext.getCmp("InciDesc").getValue()==""){
				gIncId="";
			}
			var StkGrp=Ext.getCmp("StkGrpType").getValue();
			var AuditLevel=2;
			//科室id^开始日期^截止日期^计划单号^类组id^供应商id^物资id^完成标志^审核标志^包含支配科室^审核级别
			var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+PurNo+'^'+StkGrp+'^'+VenId+'^'+gIncId+'^^^'+"^"+AuditLevel+"^"+reqloc;
			var Page=GridPagingToolbar.pageSize;
			//MasterStore.setBaseParam("strParam",ListParam);
			DetailStore.setBaseParam("strParam",ListParam);
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			MasterStore.removeAll();
			DetailStore.load({params:{start:0, limit:99999}})
//			MasterStore.load({
//				params:{start:0, limit:Page},
//				callback:function(r,options,success){
//					if(!success){
//						Msg.info("error","查询有误,请查看日志!");
//					}else if(r.length>0){
//						MasterGrid.getSelectionModel().selectFirstRow();
//						MasterGrid.getView().focusRow(0);
//					}
//				}
//			});
		}

		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
					}
				});
				
		var DHCPlanStatusStore = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
				totalProperty : "results",
				root : 'rows'
			}, ['Description', 'RowId'])
		});
		// 审核状态
		var DHCPlanStatus=new Ext.form.ComboBox({ 
			fieldLabel:'<font color=blue>审核状态</font>',
			id : 'DHCPlanStatus',
			name : 'DHCPlanStatus',
			StkType:App_StkTypeCode,     //标识类组类型
			store : DHCPlanStatusStore,
	        valueField : 'RowId',
	        displayField : 'Description',
	        allowBlank : true,
	        triggerAction : 'all',
	        selectOnFocus : true,
	        forceSelection : true,
	        minChars : 1,
	        pageSize : 999,
	        listWidth : 250,
	        valueNotFoundText : '',
			emptyText : '审核状态...',
			anchor : '90%'
		});
		
		
	DHCPlanStatus.on('beforequery', function(e){
		this.store.removeAll();
		this.store.proxy=new Ext.data.HttpProxy({url : 'dhcstm.orgutil.csp?actiontype=GetPlanStatus',method:'POST'});
	    this.store.load({params:{start:0,limit:999}});
		});			
		/**
		 * 清空方法
		 */
		function clearData() {
			//Ext.getCmp("PhaLoc").setValue("");
			Ext.getCmp("Vendor").setValue("");
			Ext.getCmp("PurNo").setValue("");
			Ext.getCmp("InciDesc").setValue("");
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, -7));
			Ext.getCmp("EndDate").setValue(new Date());
			MasterGrid.store.removeAll();
			//MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}

		// 访问路径
		var MasterUrl = DictUrl	+ 'inpurplanaction.csp?actiontype=query';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
				
		var fields = ["RowId", "PurNo", "Loc", "Date", "User", "PoFlag","CmpFlag", "StkGrp", "AuditFlag", "DHCPlanStatus", "DHCPlanStatusDesc"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Rowid",
					fields : fields
				});
		// 数据集
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					baseParams:{strParam:""}
				});
		var nm = new Ext.grid.RowNumberer();
		var MasterCm = new Ext.grid.ColumnModel([nm, {
					header : "RowId",
					dataIndex : 'RowId',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "计划单号",
					dataIndex : 'PurNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '采购科室',
					dataIndex : 'Loc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "计划单日期",
					dataIndex : 'Date',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : "采购员",
					dataIndex : 'User',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "是否已生成订单",
					dataIndex : 'PoFlag',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "完成标志",
					dataIndex : 'CmpFlag',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "审批标志",
					dataIndex : 'AuditFlag',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "类组",
					dataIndex : 'StkGrp',
					width : 100,
					align : 'left',
					sortable : true
				},{
	            header:"审核状态",
                dataIndex:'DHCPlanStatus',
                width:250,
                align:'left',
                sortable:true,
               // editor : new Ext.grid.GridEditor(conditionNameField),
                renderer :Ext.util.Format.comboRenderer2(DHCPlanStatus,"DHCPlanStatus","DHCPlanStatusDesc")
	 }]);
	 
		MasterCm.defaultSortable = true;
		var GridPagingToolbar = new Ext.PagingToolbar({
			store:MasterStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
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
					bbar:[GridPagingToolbar]
				});

		// 添加表格单击行事件
		MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
            DetailPanel.fireEvent('tabchange',DetailPanel,DetailPanel.getActiveTab());
//			var PurId = MasterStore.getAt(rowIndex).get("RowId");
//			DetailStore.removeAll();
//			DetailStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',parref:PurId}});
		});

		// 转移明细
		// 访问路径
		var DetailUrl =  DictUrl
					+ 'inpurplanaction.csp?actiontype=queryAll';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["PurNo", "Loc", "Date", "User", "PoFlag","CmpFlag", "StkGrp", "AuditFlag", "DHCPlanStatus", "DHCPlanStatusDesc","RowId", "IncId", "IncCode","IncDesc","Spec", "Manf", "Qty", "Uom","Rp",
				 "RpAmt", "Vendor", "Carrier","ReqLoc","RecQty","LeftQty","SpecDesc"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "RowId",
					fields : fields
				});
		// 数据集
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : "计划单号",
					dataIndex : 'PurNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '采购科室',
					dataIndex : 'Loc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : "计划单日期",
					dataIndex : 'Date',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : "采购员",
					dataIndex : 'User',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "是否已生成订单",
					dataIndex : 'PoFlag',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "完成标志",
					dataIndex : 'CmpFlag',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "审批标志",
					dataIndex : 'AuditFlag',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "采购明细项RowId",
					dataIndex : 'RowId',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "物资Id",
					dataIndex : 'IncId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '物资代码',
					dataIndex : 'IncCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '物资名称',
					dataIndex : 'IncDesc',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : "规格",
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "具体规格",
					dataIndex : 'SpecDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "采购数量",
					dataIndex : 'Qty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "单位",
					dataIndex : 'Uom',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "进价",
					dataIndex : 'Rp',
					width : 60,
					align : 'right',
					sortable : true
				}, {
					header : "进价金额",
					dataIndex : 'RpAmt',
					width : 60,
					align : 'right',
					sortable : true
				}, {
					header : "供应商",
					dataIndex : 'Vendor',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "厂商",
					dataIndex : 'Manf',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "配送商",
					dataIndex : 'Carrier',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "申购科室",
					dataIndex : 'ReqLoc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "入库数量",
					dataIndex : 'RecQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "未到货数量",
					dataIndex : 'LeftQty',
					width : 100,
					align : 'right',
					sortable : true
				}]);

		var DetailGrid = new Ext.ux.GridPanel({
					title : '',
					id:'DetailGrid',
					height : 200,
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true
				});

		var HisListTab = new Ext.form.FormPanel({
			labelWidth: 60,	
			labelAlign : 'right',
			frame : true,
			tbar : [SearchBT, '-', ClearBT],			
			items : [{
				xtype:'fieldset',
				title:'查询条件',
				style : 'padding:5px 0px 0px 5px;',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				defaults: {border:false},    // Default config options for child items
				items:[{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',
	            	items: [PhaLoc,Vendor]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            
	            	items: [StartDate,EndDate]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [PurNo,RequestPhaLoc]					
				},{ 				
					columnWidth: 0.25,
	            	xtype: 'fieldset',	            	
	            	items: [InciDesc,StkGrpType]					
				}]
			}]			
		});


		var DetailGridPanel = new Ext.Panel({
			title : '采购单明细',
			id : 'DetailGridPanel',
			autoScroll:true,
			layout:'fit',
			items : DetailGrid
		});
		
		var INPURPlanInfoPanel = new Ext.Panel({
		    title : '物资明细',
			id : 'INPURPlanInfoPanel',
			autoScroll:true,
			layout:'fit',
			html:'<iframe id="frameINPURPlanInfo" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		});
	
		var LocInfoPanel = new Ext.Panel({
			title : '科室请领明细',
			id : 'LocInfoPanel',
			autoScroll:true,
			layout:'fit',
			html:'<iframe id="frameLocInfo" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		});
	
		var DetailPanel = new Ext.TabPanel({
			activeTab : 0,
			deferredRender : true,
			items : [DetailGridPanel],
			listeners : {
				tabchange : function(tabpanel,panel){
					var PlanRec = MasterGrid.getSelectionModel().getSelected();
					if(Ext.isEmpty(PlanRec)){
						return;
					}
					var PurId = PlanRec.get('RowId');
					if(panel.id == 'DetailGridPanel'){
						DetailStore.removeAll();
			            DetailStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',parref:PurId}});
					}else if(panel.id == 'INPURPlanInfoPanel'){
						var p_URL = PmRunQianUrl+'?reportName=DHCSTM_INPURPLAN_ReqInfo.raq'
							+"&Parref=" + PurId;
						var reportFrame=document.getElementById("frameINPURPlanInfo");
						reportFrame.src=p_URL;
					}else if(panel.id == 'LocInfoPanel'){
						var p_URL = PmRunQianUrl+'?reportName=DHCSTM_INPURPLAN_ReqLocInfo.raq'
							+"&Parref=" + PurId;
						var reportFrame=document.getElementById("frameLocInfo");
						reportFrame.src=p_URL;
					}
				}
			}
		});


		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                title:'采购单执行情况查询',
			                height: 170, // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }
//			            , {
//			                region: 'west',
//			                width:300,
//			                minSize: 200,
//                			maxSize: 350,
//                			collapsible: true,
//                			split:true,
//			                title: '采购单',			               
//			                layout: 'fit', // specify layout manager for items
//			                items: MasterGrid
//			            }
			            , {
			                region: 'center',
			                layout: 'fit', // specify layout manager for items
			                items: DetailPanel
			            }
	       			],
					renderTo : 'mainPanel'
				});
})