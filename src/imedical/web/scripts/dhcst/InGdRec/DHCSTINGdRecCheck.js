// /名称: 入库单验收
// /描述: 入库单验收
// /编写者：zhangdongmei
// /编写日期: 2012.07.18
		
Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gParamNew = PHA_COM.ParamProp("DHCSTIMPORT")
	var PoisonDoubleSignFlag = false
	if (gParamNew.PoisonDoubleSign == "N" ) PoisonDoubleSignFlag = true
	var gIngrRowid="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    if(gParam.length<1){
		GetParam();  //初始化参数配置
	}	
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置 wyx 公共变量取类组设置gParamCommon[9]

	}
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : $g('入库部门'),
		id : 'PhaLoc',
		name : 'PhaLoc',
		width : 200,
		emptyText : $g('入库部门...'),
		groupId:gGroupId
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		width : 200
	});
		
	// 入库单号
	var InGrNo = new Ext.form.TextField({
		fieldLabel : $g('入库单号'),
		id : 'InGrNo',
		name : 'InGrNo',
		anchor : '90%',
		width : 120,
		disabled : false
	});

	// 发票号
	var InvNo = new Ext.form.TextField({
				fieldLabel : $g('发票号'),
				id : 'InvNo',
				name : 'InvNo',
				anchor : '90%',
				width : 120,
				disabled : false
			});
	
	// 起始日期
	var StartDate= new Ext.ux.DateField({
		fieldLabel : $g('起始日期'),
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		width : 60,
		value : new Date()
	});

	// 结束日期
	var EndDate= new Ext.ux.DateField({
		fieldLabel : $g('结束日期'),
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		width : 60,
		value : new Date()
	});



	// 审核标志
	var AuditFlag = new Ext.form.Checkbox({
		boxLabel : $g('已审核'),
		id : 'AuditFlag',
		name : 'AuditFlag',
		anchor : '90%',
		width : 150,
		checked : true,
		disabled:false
	});
	// 完成标志
	var CompleteFlag = new Ext.form.Checkbox({
		boxLabel : $g('已完成(未审核)'),
		id : 'CompleteFlag',
		name : 'CompleteFlag',
		anchor : '90%',
		width : 150,
		checked : false,
		disabled:false
	});
	
	// 完成标志
	var PMZJYFlag = new Ext.form.Checkbox({
		boxLabel : $g('麻醉精一'),
		id : 'PMZJYFlag',
		name : 'PMZJYFlag',
		anchor : '90%',
		width : 150,
		checked : false,
		disabled:false,
		hidden:PoisonDoubleSignFlag
		
	});
	
	// 检索按钮
	var searchBT = new Ext.Toolbar.Button({
				text : $g('查询'),
				tooltip : $g('点击查询入库单信息'),
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchDurgData();
				}
			});

	function searchDurgData() {
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
		var InGrNo = Ext.getCmp("InGrNo").getValue();
		var Vendor = Ext.getCmp("Vendor").getValue();
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", $g("请选择入库部门!"));
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", $g("请选择开始日期和截止日期!"));
			return;
		}
		var AuditFlag= Ext.getCmp("AuditFlag").getValue();
		if(AuditFlag==true){
			AuditFlag="Y";
		}else{
			AuditFlag="N";
		}
		var CompleteFlag= Ext.getCmp("CompleteFlag").getValue();
		if(CompleteFlag==true){
			CompleteFlag="Y";
		}else{
			CompleteFlag="N";
		}
		if (AuditFlag=="Y"){CompleteFlag=""}
		var InvNo= Ext.getCmp("InvNo").getValue();
		var MZJYFlag = Ext.getCmp("PMZJYFlag").getValue()  ? 'Y' : 'N';
		
		var ListParam = [StartDate, EndDate, InGrNo, Vendor, PhaLoc, CompleteFlag, "", AuditFlag, InvNo, MZJYFlag].join("^")
		var Page=GridPagingToolbar.pageSize;
		//GrMasterInfoStore.baseParams['ParamStr']=ListParam;
		//GrMasterInfoStore.baseParams={ParamStr:ListParam};
		GrMasterInfoStore.setBaseParam('ParamStr',ListParam);
		GrMasterInfoStore.load({params:{start:0, limit:Page}});
		
		GrDetailInfoGrid.store.removeAll();
	}

	// 选取按钮
	var acceptBT = new Ext.Toolbar.Button({
				text : $g('验收'),
				tooltip : $g('点击验收'),
				iconCls : 'page_goto',
				height:30,
				width:70,
				handler : function() {
					acceptData();
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
						var rowData=GrMasterInfoGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", $g("请选择需要打印的入库单!"));
							return;
						}
						var DhcIngr = rowData.get("IngrId");
						PrintRecCheck(DhcIngr,gParam[13]);
					}
				});
				
		// 麻醉精一审核1
		var MZJYAudit1 = new Ext.Toolbar.Button({
					id:'MZJYAudit1',
					text : $g('麻精审核1'),
					tooltip : $g('点击审核'),
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					hidden:PoisonDoubleSignFlag,
					handler : function() {
						MZJYDoubleSign("MZJY1")
					}
				});
		// 麻醉精一审核2
		var MZJYAudit2 = new Ext.Toolbar.Button({
					id:'MZJYAudit2',
					text : $g('麻精审核2'),
					tooltip : $g('点击审核'),
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					hidden:PoisonDoubleSignFlag,
					handler : function() {
						MZJYDoubleSign("MZJY2");
					}
				});
	// 麻醉精一药品双签
	function MZJYDoubleSign(Status){
		var rowData=GrMasterInfoGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", $g("请选择需要审核的入库单!"));
			return;
		}
		var DhcIngr = rowData.get("IngrId");
		var Table = "User.DHCINGdRec"
		var Ret = tkMakeServerCall("web.DHCST.DHCINGdRec","SaveStatus",Table,DhcIngr,Status,gUserId,"","Y")
		var RetArr = Ret.split("^")
		if(RetArr[0]>0){
			Msg.info("success", $g("审核成功!"));
			Query(gIngrRowid);
			GrMasterInfoStore.reload();
			return;
		}
		else{
			Msg.info("warning", $g("审核失败:") + RetArr[1]);
			return;
		}
	}			
	
		
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
		var returnColSetBT = new Ext.Toolbar.Button({
			text : $g('确定'),
			tooltip : $g('点击确定'),
			iconCls : 'page_goto',
			handler : function() {
				var selectradio = Ext.getCmp('GridSelectModel').getValue();
				if(selectradio){
					var selectModel =selectradio.inputValue;	
					if (selectModel=='1') {
						GridColSet(GrMasterInfoGrid,"DHCSTIMPORT");						
					}
					else {
						GridColSet(GrDetailInfoGrid,"DHCSTIMPORT");   							
					}						
				}
				GridSelectWin.hide();
			}
		});

		// 取消按钮
		var cancelColSetBT = new Ext.Toolbar.Button({
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
			
			buttons:[returnColSetBT,cancelColSetBT]
		})


	/**
	 * 保存验收信息
	 */
	function acceptData() {
		if(gIngrRowid==""){
			Msg.info("warning", $g("请选择入库单!"));
			return;
		}
		var ListDetail="";
		var rowCount = GrDetailInfoGrid.getStore().getCount();
		if(rowCount=="0"){
			Msg.info("warning", $g("请选择入库单!"));
			return;
		}
		var rowData=GrMasterInfoGrid.getSelectionModel().getSelected();
		var AcceptUser=rowData.get("AcceptUser");
		var InGrFlag = (AcceptUser!=""?'Y':'N');
		if (InGrFlag == "Y") {
			Msg.info("warning", $g("入库单已验收!"));
			return;
		}
		for (var i = 0; i < rowCount; i++) {
			var rowData = GrDetailInfoStore.getAt(i);	
			//新增或数据发生变化时执行下述操作
			//if(rowData.data.newRecord || rowData.dirty){				
				var Ingri=rowData.get("Ingri");
				var CheckPort = rowData.get("CheckPort");
				var CheckRepNo = rowData.get("CheckRepNo");
				var CheckRepDate =Ext.util.Format.date(rowData.get("CheckRepDate"),App_StkDateFormat);
				var AdmNo = rowData.get("AdmNo");
				var AdmExpdate =Ext.util.Format.date(rowData.get("AdmExpdate"),App_StkDateFormat);
				var Remark = rowData.get("Remark");				
				
				var str = Ingri + "^" + CheckPort + "^"	+ CheckRepNo + "^" + CheckRepDate + "^"+ AdmNo + "^" + AdmExpdate + "^" + Remark;	
						
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+xRowDelim()+str;
				}
			//}
			
		}
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=SaveCheckInfo";
		Ext.Ajax.request({
					url : url,
					params:{IngrId:gIngrRowid,UserId:gUserId,ListDetail:ListDetail},
					method : 'POST',
					waitMsg : $g('处理中...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 刷新界面
							Msg.info("success", $g("验收成功!"));
							// 7.显示入库单数据
							Query(gIngrRowid);
							GrMasterInfoStore.reload();

						} else {
							var ret=jsonData.info;
							Msg.info("error", $g("验收失败：")+ret);								
						}
					},
					scope : this
				});
		
	}
	// 清空按钮
	var clearBT = new Ext.Toolbar.Button({
				text : $g('清屏'),
				tooltip : $g('点击清屏'),
				iconCls : 'page_clearscreen',
				height:30,
				width:70,
				handler : function() {
					clearData();
				}
			});

	function clearData() {
		SetLogInDept(PhaLoc.getStore(),'PhaLoc');
		Ext.getCmp("AuditFlag").setValue("Y");
		Ext.getCmp("CompleteFlag").setValue("N");
		Ext.getCmp("InGrNo").setValue("");
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("InvNo").setValue("");
		Ext.getCmp("StartDate").setValue(new Date());
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("PMZJYFlag").setValue("N");
		
		GrMasterInfoGrid.store.removeAll();
		GrDetailInfoGrid.store.removeAll();
		gIngrRowid="";
	}

	// 3关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : $g('关闭'),
				tooltip : $g('关闭界面'),
				iconCls : 'close',
				handler : function() {
					window.close();
				}
			});

	// 访问路径
	var MasterInfoUrl = DictUrl	+ 'ingdrecaction.csp?actiontype=Query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "GET"
			});

	// 指定列参数
	var fields = ["IngrId","IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
			"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
			"StkGrp","RpAmt","SpAmt","AcceptUser","AuditDate","MZJYAudit1","MZJYAudit2"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "IngrId",
				fields : fields
			});
	// 数据集
	var GrMasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				baseParams:{ParamStr:''}
			});
	var nm = new Ext.grid.RowNumberer();
	var GrMasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'IngrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : $g("入库单号"),
				dataIndex : 'IngrNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("经营企业"),
				dataIndex : 'Vendor',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : $g('验收人'),
				dataIndex : 'AcceptUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : $g('制单日期'),
				dataIndex : 'CreateDate',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : $g('审核日期'),
				dataIndex : 'AuditDate',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : $g('采购员'),
				dataIndex : 'PurchUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : $g("完成标志"),
				dataIndex : 'Complete',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : $g("麻精审核1"),
				dataIndex : 'MZJYAudit1',
				width : 90,
				align : 'left',
				sortable : true,
				hidden:PoisonDoubleSignFlag
			}, {
				header : $g("麻精审核2"),
				dataIndex : 'MZJYAudit2',
				width : 90,
				align : 'left',
				sortable : true,
				hidden:PoisonDoubleSignFlag
			}
			
			
			]);
	GrMasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:GrMasterInfoStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g("没有记录")
	});
	var GrMasterInfoGrid = new Ext.grid.GridPanel({
				id : 'GrMasterInfoGrid',
				title : '',
				height : 170,
				cm : GrMasterInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : GrMasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// 添加表格单击行事件
	GrMasterInfoGrid.on('rowclick', function(grid, rowIndex, e) {
		var InGr = GrMasterInfoStore.getAt(rowIndex).get("IngrId");
		gIngrRowid=InGr;
		Query(InGr);
		
	});

	function Query(Parref){
		GrDetailInfoStore.load({params:{start:0,limit:9999,sort:'Rowid',dir:'Desc',Parref:Parref}});
	}
	
	// 访问路径
	var DetailInfoUrl = DictUrl
					+ 'ingdrecaction.csp?actiontype=QueryIngrDetail';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	// 指定列参数 	
	var fields = ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb",  "Margin", "RecQty",
			"Remarks", "IncCode", "IncDesc","InvNo", "Manf", "Rp", "RpAmt",
			"Sp", "SpAmt", "InvDate","QualityNo", "SxNo","Remark","MtDesc","PubDesc",
			"CheckPort","CheckRepNo",{name:'CheckRepDate',type:'date',dateFormat:App_StkDateFormat},"AdmNo",
			{name:'AdmExpdate',type:'date',dateFormat:App_StkDateFormat},"CheckPack","Spec","InsuCode","InsuDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Ingri",
				fields : fields
			});
	// 数据集
	var GrDetailInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var GrDetailInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "Ingri",
				dataIndex : 'Ingri',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : $g('药品代码'),
				dataIndex : 'IncCode',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g('药品名称'),
				dataIndex : 'IncDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : $g("生产企业"),
				dataIndex : 'Manf',
				width : 180,
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
				header : $g("单位"),
				dataIndex : 'IngrUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("数量"),
				dataIndex : 'RecQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("检测口岸"),
				dataIndex : 'CheckPort',
				width : 90,
				align : 'left',
				sortable : true,
				editor : new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = GrDetailInfoGrid.getSelectionModel()
											.getSelectedCell();
									var index=GetColIndex(GrDetailInfoGrid,"CheckRepNo");
									if(index>0){
										GrDetailInfoGrid.startEditing(cell[0], index);
									}
								}
							}
						}
					})
			}, {
				header : $g("检测报告"),
				dataIndex : 'CheckRepNo',
				width : 90,
				align : 'left',
				sortable : true,
				editor : new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = GrDetailInfoGrid.getSelectionModel()
											.getSelectedCell();
									var index=GetColIndex(GrDetailInfoGrid,"CheckRepDate");
									if(index>0){
										GrDetailInfoGrid.startEditing(cell[0], index);
									}
								}
							}
						}
					})
			}, {
					header :$g( "报告日期"),
					dataIndex : 'CheckRepDate',
					width : 100,
					align : 'center',
					sortable : true,	
					renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
					editor : new Ext.form.DateField({
						selectOnFocus : true,
						allowBlank : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									
									var cell = GrDetailInfoGrid.getSelectionModel()
											.getSelectedCell();
									var index=GetColIndex(GrDetailInfoGrid,"AdmNo");
									if(index>0){
										GrDetailInfoGrid.startEditing(cell[0], index);
									}
								}
							}
						}
					})
					
				}, {
				header : $g("注册证号"),
				dataIndex : 'AdmNo',
				width : 90,
				align : 'left',
				sortable : true,
				editor : new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cell = GrDetailInfoGrid.getSelectionModel()
											.getSelectedCell();
									var index=GetColIndex(GrDetailInfoGrid,"AdmExpdate");
									if(index>0){
										GrDetailInfoGrid.startEditing(cell[0], index);
									}
								}
							}
						}
					})
			}, {
					header : $g("注册证有效期"),
					dataIndex : 'AdmExpdate',
					width : 100,
					align : 'center',
					sortable : true,	
					renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
					editor : new Ext.form.DateField({
						selectOnFocus : true,
						allowBlank : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									
									var cell = GrDetailInfoGrid.getSelectionModel()
											.getSelectedCell();
									var index=GetColIndex(GrDetailInfoGrid,"Remark");
									if(index>0){
										GrDetailInfoGrid.startEditing(cell[0], index);
									}
								}
							}
						}
					})
					
				}, {
				header : $g("摘要"),
				dataIndex : 'Remark',
				width : 90,
				align : 'left',
				sortable : true,
				editor : new Ext.form.TextField()
			}, {
				header : $g("进价"),
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
			
				sortable : true
			}, {
				header : $g("售价"),
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header :$g( "发票号"),
				dataIndex : 'InvNo',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("发票日期"),
				dataIndex : 'InvDate',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("进价金额"),
				dataIndex : 'RpAmt',
				width : 100,
				align : 'left',
				
				sortable : true
			}, {
				header : $g("售价金额"),
				dataIndex : 'SpAmt',
				width : 100,
				align : 'left',
				
				sortable : true
			}, {
				header : $g("规格"),
				dataIndex : 'Spec',
				width : 100,
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
			}]);
	GrDetailInfoCm.defaultSortable = true;
	var GrDetailInfoGrid = new Ext.grid.EditorGridPanel({
				title : '',
				height : 170,
				cm : GrDetailInfoCm,
				sm : new Ext.grid.CellSelectionModel({}),
				store : GrDetailInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				clicksToEdit : 1
			});

		var InfoForm= new Ext.form.FormPanel({
				frame : true,
				labelAlign : 'right',
				id : "InfoForm",
				autoHeight:true,
				labelWidth: 60,	
				title:$g('入库单查询与验收'),
				tbar : [searchBT, '-', clearBT, '-', acceptBT,'-',PrintBT,'-',GridColSetBT,'-',MZJYAudit1,'-',MZJYAudit2],	//, '-', closeBT
				items:[{
					xtype:'fieldset',
					title:$g("查询条件"),
					layout:'column',
					style:DHCSTFormStyle.FrmPaddingV,
					items : [{ 				
						columnWidth: 0.25,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [PhaLoc,Vendor]
					
					},{ 				
						columnWidth: 0.15,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [StartDate,EndDate]
					
					},{ 				
						columnWidth: 0.2,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [InGrNo,InvNo]
					
					},{ 				
						columnWidth: 0.15,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [AuditFlag,CompleteFlag]
					
					}
					,{ 				
						columnWidth: 0.15,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [PMZJYFlag]
					
					}
					
					]
				}]
			});
			
		// 页面布局
		var mainPanel = new Ext.Viewport({
				title : $g('入库单验收'),
				layout : 'border',
				renderTo : 'mainPanel',
				items : [            // create instance immediately
		            {
		                region: 'north',
		                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
						width: 225,
		                layout: 'fit', // specify layout manager for items
		                items:InfoForm
		            }, {
		                region: 'west',
		                title: $g('入库单'),
		                collapsible: true,
		                split: true,
		                width:document.body.clientWidth*0.3,
		                minSize: 175,
		                maxSize: 400,
		                margins: '0 5 0 0',
		                layout: 'fit', // specify layout manager for items
		                items: GrMasterInfoGrid       
		               
		            }, {
		                region: 'center',
		                title: $g('入库单明细'),
		                layout: 'fit', // specify layout manager for items
		                items: GrDetailInfoGrid       
		               
		            }
       			]			
		});
		
		RefreshGridColSet(GrMasterInfoGrid,"DHCSTIMPORT");   //根据自定义列设置重新配置列
		RefreshGridColSet(GrDetailInfoGrid,"DHCSTIMPORT");   //根据自定义列设置重新配置列
	
	
})
