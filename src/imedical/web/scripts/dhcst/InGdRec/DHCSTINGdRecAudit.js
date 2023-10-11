// /名称:入库审核
// /描述: 入库审核
// /编写者：zhangdongmei
// /编写日期: 2012.07.05

var APPName="DHCSTPURPLANAUDIT"
var PurPlanParam=PHA_COM.ParamProp(APPName)

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParam.length<1){
		GetParam();  //初始化参数配置
	}
	ChartInfoAddFun();
	
	function ChartInfoAddFun() {
		// 入库部门
		var PhaLoc=new Ext.ux.LocComboBox({
			fieldLabel : $g('入库部门'),
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '95%',
			width : 120,
			emptyText : $g('入库部门...'),
			groupId:gGroupId
		});
	
		var Vendor=new Ext.ux.VendorComboBox({
			id : 'Vendor',
			name : 'Vendor',
			anchor : '95%',
			width : 140
		});
		
		// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : $g('起始日期'),
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 100,
					value : DefaultStDate()
				});

		// 截止日期
		var EndDate = new Ext.ux.DateField({
					fieldLabel : $g('截止日期'),
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					width : 100,
					value : DefaultEdDate()
				});

		// 审批
		var InGrFlag = new Ext.form.Checkbox({
					fieldLabel : $g('审批'),
					id : 'InGrFlag',
					name : 'InGrFlag',
					anchor : '90%',
					width : 120,
					checked : false
				});

		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					id:"SearchBT",
					text : $g('查询'),
					tooltip : $g('点击查询'),
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						Query();
					}
				});
		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
					id:'ClearBT',
					text : $g('清屏'),
					tooltip : $g('点击清屏'),
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
					}
				});
		// 审核确认按钮
		var CheckBT = new Ext.Toolbar.Button({
					id:'CheckBT',
					text : $g('审核确认'),
					tooltip : $g('点击审核确认'),
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					disabled : true,
					handler : function() {
						Audit();
					}
				});

		// 打印按钮
		var PrintBT = new Ext.Toolbar.Button({
					id:'PrintBT',
					text : $g('打印'),
					tooltip : $g('点击打印'),
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						var rowData=MasterGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", $g("请选择需要打印的入库单!"));
							return;
						}
						var DhcIngr = rowData.get("IngrId");
						PrintRec(DhcIngr,gParam[13]);
					}
				});
		
		/* 列设置按钮 */
        var GridColSetBT = new Ext.Toolbar.Button({
            text:$g('列设置'),
            tooltip:$g('列设置'),
            iconCls:'page_gear',
            handler:function(){
                GridSelectWin.show();
            }
        });

		// 确定按钮
		var returnBT = new Ext.Toolbar.Button({
			text : $g('确定'),
			tooltip : $g('点击确定'),
			iconCls : 'page_goto',
			handler : function() {
				var selectradio = Ext.getCmp('GridSelectModel').getValue();
				if(selectradio){
					var selectModel =selectradio.inputValue;	
					if (selectModel=='1') {
						GridColSet(MasterGrid,"DHCSTIMPORT");
						
					}
					else {
						GridColSet(DetailGrid,"DHCSTIMPORT");   							
					}						
				}
				GridSelectWin.hide();
			}
		});

		// 取消按钮
		var cancelBT = new Ext.Toolbar.Button({
				text : $g('取消'),
				tooltip : $g('点击取消'),
				iconCls : 'page_delete',
				handler : function() {
					GridSelectWin.hide();
				}
			});

		//选择按钮
		var GridSelectWin=new Ext.Window({
			title:$g('选择'),
			width : 210,
			height : 110,
			labelWidth:100,
			closeAction:'hide' ,
			plain:true,
			modal:true,
			items:[{
				xtype:'radiogroup',
				id:'GridSelectModel',
				anchor: '95%',
				columns: 2,
				style: 'padding:10px 10px 10px 10px;',
				items : [{
						checked: true,				             
							boxLabel: $g('入库单'),
							id: 'GridSelectModel1',
							name:'GridSelectModel',
							inputValue: '1' 							
						},{
						checked: false,				             
							boxLabel: $g('入库单明细'),
							id: 'GridSelectModel2',
							name:'GridSelectModel',
							inputValue: '2' 							
						}]
					}],
			
			buttons:[returnBT,cancelBT]
   		})	
				
				
		/**
		 * 查询方法
		 */
		function Query() {
			var PhaLoc = Ext.getCmp("PhaLoc").getValue();
			var Vendor = Ext.getCmp("Vendor").getValue();
			if(PhaLoc==""){
				Msg.info("warning", $g("请选择入库部门!"));
				return;
			}
			
			var StartDate = Ext.getCmp("StartDate").getValue();
			if(StartDate!=""){
				StartDate=StartDate.format(App_StkDateFormat);
			}else{
				Msg.info("warning",$g("请选择开始日期!"));
				return;
			}
			
			var EndDate = Ext.getCmp("EndDate").getValue()
			if(EndDate!=""){
				EndDate=EndDate.format(App_StkDateFormat);
			}else{
				Msg.info("warning",$g("请选择截止日期!"));
				return;
			}

			var InGrFlag = (Ext.getCmp("InGrFlag").getValue()==true?'Y':'N');
			var ListParam=StartDate+'^'+EndDate+'^'+''+'^'+Vendor+'^'+PhaLoc+'^Y^^'+InGrFlag;
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam("ParamStr",ListParam);
			MasterStore.removeAll();
			DetailGrid.store.removeAll();
			MasterStore.load({
				params:{start:0, limit:Page},
				callback:function(r,options, success){
					if(success==false){
	     				Msg.info("error", $g("查询错误，请查看日志!"));
	     			}else{
	     				if(r.length>0){
		     				MasterGrid.getSelectionModel().selectFirstRow();
		     				MasterGrid.getSelectionModel().fireEvent('rowselect',this,0);
		     				MasterGrid.getView().focusRow(0);
	     				}
	     			}
				}
			});
			

		}

		/**
		 * 清空方法
		 */
		function clearData() {
			SetLogInDept(PhaLoc.getStore(),'PhaLoc');
			Ext.getCmp("Vendor").setValue("");
			Ext.getCmp("InGrFlag").setValue(0);
			Ext.getCmp("StartDate").setValue(DefaultStDate());
			Ext.getCmp("EndDate").setValue(DefaultEdDate());
			MasterGrid.store.removeAll();
			DetailGrid.store.removeAll();
			CheckBT.setDisabled(true);
			
			PrintBT.setDisabled(true);
		}

		/**
		 * 审核方法
		 */
		function Audit() {
			var rowData=MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", $g("请选择需要审核的入库单!"));
				return;
			}
			//var InGrFlag = Ext.getCmp("InGrFlag").getValue();
			var AuditDate=rowData.get("AuditDate");
			var InGrFlag = (AuditDate!=""?'Y':'N');
			if (InGrFlag == "Y") {
				Msg.info("warning", $g("入库单已审核!"));
				return;
			}
			
			var StrParam=gGroupId+"^"+gLocId
			var DhcIngr = rowData.get("IngrId");
			//增加医共体先上传主院判断
			var CanSengFlag=tkMakeServerCall("PHA.IN.HDCM.Client.DHCMClient","CheckIfSendHDCM",DhcIngr)
			if(CanSengFlag=="Y")
			{
				var ret=tkMakeServerCall("PHA.IN.HDCM.Client.DHCMClient","IngdItm",DhcIngr)
				if(ret==0)
				{
					Msg.info("success", $g("入库上传医共体主院成功!"));
				}
				else 
				{
					Msg.info("error", $g("入库单上传主院失败：")+ret);
					return;
				}
			}
			
			///检查预算项目
			var ret = SendBusiData(DhcIngr,"IMPORT","AUDIT")
			if(!ret) return;

			var loadMask=ShowLoadMask(document.body,$g("审核中..."));
			var url = DictUrl
					+ "ingdrecaction.csp?actiontype=Audit&Rowid="
					+ DhcIngr + "&User=" + userId+"&StrParam="+StrParam;

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : $g('查询中...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							loadMask.hide();
							if (jsonData.success == 'true') {
								Msg.info("success", $g("审核成功!"));
								DetailGrid.store.removeAll();
								MasterStore.reload({
									callback:function(){
										//根据参数设置自动打印
										if(gParam[4]=='1'){
											/*
											 * 20190903,yunhaibao,masterstore加载中,调了润乾打印,导致reload.callback一直在回调
											 * 下方confirm也是一个道理,query完成后,再延时回调
											 */
											PrintRec.defer(500,this,[DhcIngr,gParam[13]]);
										}else if(gParam[4]=='2'){
											Ext.Msg.confirm($g('提示'),$g('是否打印？'),
										      function(btn){
										        if(btn=='yes'){
										          PrintRec.defer(500,this,[DhcIngr,gParam[13]]);					
										        }else{
		          
										        }
										      },this);
										}									
									}
								});
							} else {
								var Ret=jsonData.info;
								if(Ret==-101){
									Msg.info("error", $g("入库单不存在!"));
								}else if(Ret==-100){
									Msg.info("error", $g("加锁失败!"));
								}else if(Ret==-102){
									Msg.info("error", $g("入库单尚未完成，不能审核!"));
								}else if(Ret==-104){
									Msg.info("error", $g("更新入库主表失败!"));
								}else if(Ret==-110){
									Msg.info("error", $g("药品和科室不能为空!"));
								}else if(Ret==-111){
									Msg.info("error", $g("生成批次信息失败!"));
								}else if(Ret==-112){
									Msg.info("error", $g("保存批次附加信息失败!"));
								}else if(Ret==-113){
									Msg.info("error", $g("处理库存失败!"));
								}else if(Ret==-114){
									Msg.info("error", $g("保存台帐失败!"));
								}else if(Ret==-115){
									Msg.info("error", $g("更新入库明细失败!"));
								}else if(Ret==-5){
									Msg.info("error", $g("售价与当前价不一致，且当天已有生效调价记录，请确认!"));
								}else if(Ret==-1){
									Msg.info("error", $g("售价与当前价不一致，请确认!"));
								}else if(Ret==-2||Ret==-3){
									Msg.info("error", $g("保存调价记录失败!"));
								}else if(Ret==-4){
									Msg.info("error", $g("审核调价记录失败!"));
								}else if(Ret==-201){
									Msg.info("error", $g("处理临购药品失败!"));
								}else if(Ret==-202){
									Msg.info("error", $g('处理临购预授权数据失败，部分药品已经维护"禁止"管控级别限制用药不能再维护"允许",请核实!'));
								}else{
									Msg.info("error", $g("审核失败:")+Ret);
								}
								
							}
						},
						scope : this
					});
		}

		// 信息列表
		// 访问路径
		var MasterUrl = DictUrl	+ 'ingdrecaction.csp?actiontype=Query';;
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["IngrId","IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
			"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
			"StkGrp","RpAmt","SpAmt","AuditDate","AuditUser","Margin"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "IngrId",
					fields : fields
				});
		// 数据集
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					baseParams:{ParamStr:''}
				});
		
		var nm = new Ext.grid.RowNumberer();
		var MasterCm = new Ext.grid.ColumnModel([nm, {
					header : "rowid",
					dataIndex : 'IngrId',
					width : 60,
					align : 'right',
					sortable : true,
					hidden : true/*,
					hideable : false*/
				}, {
					header : $g("单号"),
					dataIndex : 'IngrNo',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : $g('入库部门'),
					dataIndex : 'RecLoc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g('经营企业'),
					dataIndex : 'Vendor',
					width : 170,
					align : 'left',
					sortable : true
				}, {
					header : $g("入库日期"),
					dataIndex : 'CreateDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("制单人"),
					dataIndex : 'CreateUser',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : $g("入库类型"),
					dataIndex : 'IngrType',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : $g("审核人"),
					dataIndex : 'AuditUser',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : $g('审核日期'),
					dataIndex : 'AuditDate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("订单号"),
					dataIndex : 'PoNo',
					width : 110,
					align : 'left',
					sortable : true
				}, {
					header : $g("进价金额"),
					dataIndex : 'RpAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("售价金额"),
					dataIndex : 'SpAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("进销差价"),
					dataIndex : 'Margin',
					width : 80,
					align : 'right',
					
					sortable : true
				}]);
		MasterCm.defaultSortable = true;
		
		var GridPagingToolbar = new Ext.PagingToolbar({
			store:MasterStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
			emptyMsg:$g("没有记录")
		});
		
		var MasterGrid = new Ext.grid.GridPanel({
			region : 'center',
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
			var rowData = MasterStore.data.items[rowIndex];
			var InGrRowId = rowData.get("IngrId");
			DetailStore.removeAll();
			DetailStore.load({params:{start:0,limit:9999,Parref:InGrRowId}});
                           
           var AuditDate = rowData.get("AuditDate");
           var InGrFlag = (AuditDate!=""?'Y':'N');
			//var InGrFlag = Ext.getCmp("InGrFlag").getValue();
			if (InGrFlag == "Y") {
				CheckBT.setDisabled(true);
				
				PrintBT.setDisabled(false);
			} else {
				CheckBT.setDisabled(false);
				
				PrintBT.setDisabled(true);
			}
		});

		// 信息明细
		// 访问路径
		var DetailUrl = DictUrl+ 'ingdrecaction.csp?actiontype=QueryIngrDetail';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// 指定列参数	
		var fields = ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb", "Margin", "RecQty",
			"Remarks", "IncCode", "IncDesc","InvNo", "Manf", "Rp", "RpAmt",
			"Sp", "SpAmt", {name:'InvDate',type:'date',dateFormat:App_StkDateFormat},
			"QualityNo", "SxNo","Remark","MtDesc","PubDesc","Spec","OriginDesc","InsuCode","InsuDesc"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Ingri",
					fields : fields
				});
		// 数据集
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : "Ingri",
					dataIndex : 'Ingri',
					width : 80,
					align : 'right',
					sortable : true,
					hidden : true,
					hideable : false
				}, {
					header : $g("代码"),
					dataIndex : 'IncCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g('名称'),
					dataIndex : 'IncDesc',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : $g("生产企业"),
					dataIndex : 'Manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("产地"),
					dataIndex : 'OriginDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("批号"),
					dataIndex : 'BatchNo',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("有效期"),
					dataIndex : 'ExpDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g('单位'),
					dataIndex : 'IngrUom',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : $g("数量"),
					dataIndex : 'RecQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("进价"),
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("售价"),
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("发票号"),
					dataIndex : 'InvNo',
					width : 80,
					align : 'left',
					sortable : true
						/*,
					editor : new Ext.form.TextField({
								selectOnFocus : true,
								allowBlank : false,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											var invNo = field.getValue();
											if (invNo == null
													|| invNo.length <= 0) {
												Msg.info("warning", "发票号不能为空!");												
												return;
											}

											var cell = DetailGrid
													.getSelectionModel()
													.getSelectedCell();
											DetailGrid
													.startEditing(cell[0], 12);
										}
									}
								}
							})
							*/
				}, {
					header : $g("发票日期"),
					dataIndex : 'InvDate',
					width : 90,
					align : 'left',
					sortable : true,
					renderer :Ext.util.Format.dateRenderer(App_StkDateFormat)
						/*,
					editor : new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : false,
						format : 'Y-m-d',
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var invDate = field.getValue();
									if (invDate == null || invDate.length <= 0) {
										Msg.info("warning", "发票日期不能为空!");											
										return;
									}
								}
							}
						}
					})
					*/
				}, {
					header : $g("进价金额"),
					dataIndex : 'RpAmt',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("售价金额"),
					dataIndex : 'SpAmt',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("进销差价"),
					dataIndex : 'Margin',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("规格"),
					dataIndex : 'Spec',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("国家医保编码"),
					dataIndex : 'InsuCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("国家医保名称"),
					dataIndex : 'InsuDesc',
					width : 80,
					align : 'left',
					sortable : true
				}
				]);

		
		var DetailGrid = new Ext.grid.EditorGridPanel({
					region : 'south',
					title : '',
					height : 200,
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1
				});
		var HisListTab = new Ext.form.FormPanel({
					labelWidth : 60,
					labelAlign : 'right',
					frame : true,
					title:$g('入库单审核'),
					autoScroll : false,
					autoHeight:true,
					//bodyStyle : 'padding:0px 0px 0px 0px;',					
					tbar : [SearchBT, '-', ClearBT, '-', CheckBT,  '-', PrintBT, '-',GridColSetBT],
					items:[{
						xtype:'fieldset',
						title:$g('查询条件'),
						layout: 'column',    // Specifies that the items will now be arranged in columns
						style:DHCSTFormStyle.FrmPaddingV,
						items : [{ 				
							columnWidth: 0.2,
			            	xtype: 'fieldset',
			            	border:false,    // Default config options for child items
			            	border: false,
			            	items: [PhaLoc,InGrFlag]
						},{ 				
							columnWidth: 0.2,
			            	xtype: 'fieldset',
			            	border: false,
			            	items: [Vendor]
							
						},{ 				
							columnWidth: 0.15,
			            	xtype: 'fieldset',
			            	border: false,
			            	items: [StartDate]
							
						},{ 				
							columnWidth: 0.15,
			            	xtype: 'fieldset',
			            	border: false,
			            	items: [EndDate]
							
						},{ 				
							columnWidth: 0.2,
			            	xtype: 'fieldset',
			            	border: false,
			            	items: [BudgetProComb]
							
						}]
						
					}]
				});
	

		// 页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                height: DHCSTFormStyle.FrmHeight(1)+40, // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: $g('入库单'),			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid       
			               
			            }, {
			                region: 'south',
			                split: true,
                			height: 250,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: $g('入库单明细'),
			                layout: 'fit', // specify layout manager for items
			                items: DetailGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
				RefreshGridColSet(MasterGrid,"DHCSTIMPORT");
				RefreshGridColSet(DetailGrid,"DHCSTIMPORT");		
		Query();
		SetBudgetPro(Ext.getCmp("PhaLoc").getValue(),"IMPORT",[3],"InGrFlag") //加载HRP预算项目
	}
})
