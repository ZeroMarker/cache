// /名称: 入库单验收
// /描述: 入库单验收
// /编写者：zhangdongmei
// /编写日期: 2012.07.18
		
Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId = session['LOGON.CTLOCID'];
	var gIngrRowid="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '入库部门',
		id : 'PhaLoc',
		name : 'PhaLoc',
		width : 200,
		emptyText : '入库部门...',
		groupId:gGroupId,
		childCombo : 'Vendor'
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		params : {LocId : 'PhaLoc'}
	});
		
	// 入库单号
	var InGrNo = new Ext.form.TextField({
		fieldLabel : '入库单号',
		id : 'InGrNo',
		name : 'InGrNo',
		anchor : '90%',
		width : 120,
		disabled : false
	});

	// 发票号
	var InvNo = new Ext.form.TextField({
				fieldLabel : '发票号',
				id : 'InvNo',
				name : 'InvNo',
				anchor : '90%',
				width : 120,
				disabled : false
			});
	
	// 起始日期
	var StartDate= new Ext.ux.DateField({
		fieldLabel : '起始日期',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		width : 120,
		value : DefaultStDate()
	});

	// 结束日期
	var EndDate= new Ext.ux.DateField({
		fieldLabel : '结束日期',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		width : 120,
		value : DefaultEdDate()
	});



	// 审核标志
	var AuditFlag = new Ext.form.Checkbox({
		boxLabel : '包括已审核',
		id : 'AuditFlag',
		name : 'AuditFlag',
		anchor : '90%',
		width : 150,
		checked : false,
		disabled:false
	});

	// 检索按钮
	var searchBT = new Ext.Toolbar.Button({
				text : '检索',
				tooltip : '点击检索入库单信息',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchDurgData();
				}
			});

	function searchDurgData() {
		var StartDate=Ext.getCmp("StartDate").getValue();
		var EndDate=Ext.getCmp("EndDate").getValue();
		if(StartDate==""||EndDate==""){
			Msg.info("warning","开始日期或截止日期不能为空！");
			return;
		}
		var StartDate = StartDate.format(ARG_DATEFORMAT).toString();
		var EndDate = EndDate.format(ARG_DATEFORMAT).toString();
		var InGrNo = Ext.getCmp("InGrNo").getValue();
		var Vendor = Ext.getCmp("Vendor").getValue();
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "请选择入库部门!");
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "请选择开始日期和截止日期!");
			return;
		}
		var CompleteFlag = 'Y';
		var AuditFlag= Ext.getCmp("AuditFlag").getValue();
		if(AuditFlag==true){
			AuditFlag="";
		}else{
			AuditFlag="N";
		}
		var InvNo= Ext.getCmp("InvNo").getValue();
		var ListParam=StartDate+'^'+EndDate+'^'+InGrNo+'^'+Vendor+'^'+PhaLoc
			+'^'+CompleteFlag+'^^'+AuditFlag+'^'+InvNo;
		var Page=GridPagingToolbar.pageSize;
		GrMasterInfoStore.setBaseParam('ParamStr',ListParam);
		GrDetailInfoGrid.store.removeAll();
		GrMasterInfoStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options,success){
				if(r.length>0 && success){
					GrMasterInfoGrid.getSelectionModel().selectFirstRow();
				}
			}
		});
	}

	// 选取按钮
	var acceptBT = new Ext.Toolbar.Button({
				text : '验收',
				tooltip : '点击验收',
				iconCls : 'page_goto',
				height:30,
				width:70,
				handler : function() {
					acceptData();
				}
			});

	/**
	 * 保存验收信息
	 */
	function acceptData() {
		if(gIngrRowid==""){
			Msg.info("warning", "请选择入库单!");
			return;
		}
		var ListDetail="";
		var rowCount = GrDetailInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = GrDetailInfoStore.getAt(i);	
			//新增或数据发生变化时执行下述操作
			if(rowData.data.newRecord || rowData.dirty){
				var Ingri=rowData.get("Ingri");
				var CheckPort = rowData.get("CheckPort");
				var CheckRepNo = rowData.get("CheckRepNo");
				var CheckRepDate =Ext.util.Format.date(rowData.get("CheckRepDate"),ARG_DATEFORMAT);
				var AdmNo = rowData.get("AdmNo");
				var AdmExpdate =Ext.util.Format.date(rowData.get("AdmExpdate"),ARG_DATEFORMAT);
				var Remark = rowData.get("Remark");				
				//20160606zhangxiao
				var AOGTemp = rowData.get("AOGTemp"); //到货温度
				var PackGood=rowData.get('PackGood')
				var AcceptCon=rowData.get("AcceptCon");	//验收结论
				var Token = rowData.get("Token");
				var LocalToken = rowData.get("LocalToken");
				var CheckRemarks = rowData.get("CheckRemarks");
				var ProdCertif=rowData.get("ProdCertif");
				var str = Ingri + "^" + CheckPort + "^"	+ CheckRepNo + "^" + CheckRepDate + "^"+ AdmNo
					+ "^" + AdmExpdate + "^" + Remark+"^"+AOGTemp+"^"+PackGood+"^"+AcceptCon
					+ "^" + Token + "^" + LocalToken + "^" + CheckRemarks+"^"+ProdCertif;
						
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+xRowDelim()+str;
				}
			}
		}
		if(ListDetail==""){
			Msg.info("warning", "请维护验收信息");
			return;
		}
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=SaveCheckInfo";
		Ext.Ajax.request({
					url : url,
					params:{IngrId:gIngrRowid,UserId:gUserId,ListDetail:ListDetail},
					method : 'POST',
					waitMsg : '处理中...',
					success : function(result, request) {
	
						var jsonData = Ext.util.JSON
							.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 刷新界面
							Msg.info("success", "验收成功!");
							// 7.显示入库单数据
				
							Query(gIngrRowid);
							GrMasterInfoStore.reload();

						} else {
							var ret=jsonData.info;
							
							Msg.info("error", "验收失败："+ret);
						}
					},
					scope : this
				});
		
	}
	// 清空按钮
	var clearBT = new Ext.Toolbar.Button({
				text : '清空',
				tooltip : '点击清空',
				iconCls : 'page_clearscreen',
				height:30,
				width:70,
				handler : function() {
					clearData();
				}
			});

	function clearData() {
		Ext.getCmp("InGrNo").setValue("");
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("PhaLoc").setValue(gLocId);
		Ext.getCmp("InvNo").setValue("");
		Ext.getCmp("StartDate").setValue(new Date());
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("AuditFlag").setValue("");
		GrMasterInfoGrid.store.removeAll();
		GrDetailInfoGrid.store.removeAll();
		gIngrRowid="";
	}

	// 3关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '关闭界面',
				iconCls : 'close',
				handler : function() {
					window.close();
				}
			});
	var PackGood = new Ext.grid.CheckColumn({
		header:'外包装完好',
		dataIndex:'PackGood',
		width : 70,
		sortable:true
	});
	var ProdCertif = new Ext.grid.CheckColumn({
		header:'有合格证',
		dataIndex:'ProdCertif',
		width : 70,
		sortable:true
	});
	var AcceptConStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['合格', '合格'], ['不合格', '不合格']]
	});
	var AcceptCon = new Ext.form.ComboBox({
		fieldLabel : '验收结论',
		id : 'AcceptCon',
		name : 'AcceptCon',
		anchor : '90%',
		store : AcceptConStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 160,
		forceSelection : true,
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
						var col = GetColIndex(GrDetailInfoGrid, 'CheckPort');
						GrDetailInfoGrid.startEditing(cell[0], col);
					}
				}
			}
		}
	});
	
	var CheckRepNo = new Ext.grid.CheckColumn({
		header : "检测报告",
		dataIndex : 'CheckRepNo',
		width : 90,
		align : 'center'
	});
	
	var Token = new Ext.grid.CheckColumn({
		header : '产品标识',
		dataIndex : 'Token',
		align : 'center'
	});
	
	var LocalToken = new Ext.grid.CheckColumn({
		header : '中文标识',
		dataIndex : 'LocalToken',
		align : 'center'
	});
	//选择需要复制或者清除的信息
	var CheckTypeData=[['有合格证','1']];
	
	var CheckTypeStore = new Ext.data.SimpleStore({
		fields: ['typedesc', 'typeid'],
		data : CheckTypeData
	});

	var CheckTypeCombo = new Ext.form.ComboBox({
		store: CheckTypeStore,
		displayField:'typedesc',
		mode: 'local', 
		anchor : '90%',
		emptyText:'',
		id:'CheckTypeCombo',
		fieldLabel : '选择默认全部的列',
		triggerAction:'all', //取消自动过滤
		valueField : 'typeid',
		listeners:{
			'select':function(cb)
				{
					
								
				}
		}
	});
	Ext.getCmp("CheckTypeCombo").setValue("1");
	var Checkall = new Ext.form.Checkbox({
			hideLabel:true,
			id : 'Checkall',
			name : 'Checkall',
			anchor : '90%',
			checked : false,
			listeners:{
				check:function(chk,bool){
					if(bool){
						checkall();
					}else{
						Cancelcheckall();
					}
				}
			}
		});
	function checkall(){
			var typeid=Ext.getCmp("CheckTypeCombo").getValue();
			var rowCount = GrDetailInfoGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = GrDetailInfoStore.getAt(i);	
				var CheckRepNo = rowData.get("CheckRepNo"); /// 检测报告
				var PackGood=rowData.get('PackGood'); ///外包装完好
				var Token = rowData.get("Token"); // 产品标识
				var LocalToken = rowData.get("LocalToken"); ///中文标识
				var ProdCertif=rowData.get("ProdCertif"); //有合格证
				if (typeid==1) {
					rowData.set("ProdCertif","Y");
				}
			}
	}
	function Cancelcheckall(){
			var typeid=Ext.getCmp("CheckTypeCombo").getValue();
			var rowCount = GrDetailInfoGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = GrDetailInfoStore.getAt(i);	
				var CheckRepNo = rowData.get("CheckRepNo"); /// 检测报告
				var PackGood=rowData.get('PackGood'); ///外包装完好
				var Token = rowData.get("Token"); // 产品标识
				var LocalToken = rowData.get("LocalToken"); ///中文标识
				var ProdCertif=rowData.get("ProdCertif"); //有合格证
				if (typeid==1) {
					rowData.set("ProdCertif","N");
				}
			}
	}
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
			"StkGrp","RpAmt","SpAmt","AcceptUser"];
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
				header : "入库单号",
				dataIndex : 'IngrNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'Vendor',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : '验收人',
				dataIndex : 'AcceptUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '到货日期',
				dataIndex : 'CreateDate',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : '采购员',
				dataIndex : 'PurchUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "完成标志",
				dataIndex : 'Complete',
				width : 70,
				align : 'left',
				sortable : true
			}]);
	GrMasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:GrMasterInfoStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var GrMasterInfoGrid = new Ext.ux.GridPanel({
				region: 'west',
				title: '入库单',
				collapsible: true,
				split: true,
				width: 225,
				minSize: 175,
				maxSize: 400,
				margins: '0 5 0 0',
				id : 'GrMasterInfoGrid',
				cm : GrMasterInfoCm,
				sm : new Ext.grid.RowSelectionModel({
					singleSelect : true,
					listeners : {
						rowselect : function(sm, rowIndex, r){
							gIngrRowid = r.get("IngrId");
							Query(gIngrRowid);
						}
					}
				}),
				store : GrMasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	function Query(Parref){
		GrDetailInfoStore.removeAll();
		GrDetailInfoStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',Parref:Parref}});
	}
	
	// 访问路径
	var DetailInfoUrl = DictUrl
					+ 'ingdrecaction.csp?actiontype=QueryDetail';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	// 指定列参数 	
	var fields = ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb",  "Margin", "RecQty",
			"Remarks", "IncCode", "IncDesc", "Spec", "InvNo", "Manf", "Rp", "RpAmt",
			"Sp", "SpAmt", "InvDate","QualityNo", "SxNo","Remark","MtDesc","PubDesc",
			"CheckPort","CheckRepNo",{name:'CheckRepDate',type:'date',dateFormat:DateFormat},"AdmNo",
			{name:'AdmExpdate',type:'date',dateFormat:DateFormat},"CheckPack","AOGTemp","PackGood","AcceptCon","SpecDesc",
			"Token","LocalToken","CheckRemarks","ProdCertif"];
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
	
	/*
	 * 资质判断添加Tip提示
	 */
	function ShowCreditTip(){
		return function(value, metaData, record, rowIndex, colIndex, store){
			var Ingri = record.get('Ingri');
			var AlarmDays = 0;
			var CheckInfo = tkMakeServerCall('web.DHCSTM.DHCINGdRecItm', 'CheckCredit', Ingri, AlarmDays);
			var StyleInfo = '';
			if(!Ext.isEmpty(CheckInfo)){
				StyleInfo='style="color:blue"';
			}
			return '<span '+StyleInfo+' ext:qtip="'+CheckInfo+'">'+value+'</span>';
		}
	}
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
				header : '物资代码',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资名称',
				dataIndex : 'IncDesc',
				width : 160,
				align : 'left',
				sortable : true,
				renderer : ShowCreditTip()
			}, {
				header : '规格',
				dataIndex : 'Spec',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "具体规格",
				dataIndex : 'SpecDesc',
				width : 80,
				align : 'left'
			}, {
				header : "生产厂商",
				dataIndex : 'Manf',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "批号",
				dataIndex : 'BatchNo',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "有效期",
				dataIndex : 'ExpDate',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "单位",
				dataIndex : 'IngrUom',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "数量",
				dataIndex : 'RecQty',
				width : 50,
				align : 'right',
				sortable : true
			}, PackGood,ProdCertif,{
				header : "到货温度",
				dataIndex : 'AOGTemp',
				width : 90,
				align : 'left',
				sortable : true,
				editor : new Ext.form.TextField({
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
								var index=GetColIndex(GrDetailInfoGrid,"AcceptCon");
								if(index>0){
									GrDetailInfoGrid.startEditing(cell[0], index);
								}
							}
						}
					}
				})
			}, {
				header : "验收结论",
				dataIndex : 'AcceptCon',
				width : 80,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(AcceptCon)
			}, {
				header : "检测口岸",
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
									var index=GetColIndex(GrDetailInfoGrid,"CheckRepDate");
									if(index>0){
										GrDetailInfoGrid.startEditing(cell[0], index);
									}
								}
							}
						}
					})
			}, CheckRepNo, {
					header : "报告日期",
					dataIndex : 'CheckRepDate',
					width : 100,
					align : 'center',
					sortable : true,	
					renderer : Ext.util.Format.dateRenderer(DateFormat),
					editor : new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									
									var cell = GrDetailInfoGrid.getSelectionModel()
											.getSelectedCell();
									var index=GetColIndex(GrDetailInfoGrid,"CheckRemarks");
									if(index>0){
										GrDetailInfoGrid.startEditing(cell[0], index);
									}
								}
							}
						}
					})
			}, Token, LocalToken, {
				header : '验收备注',
				dataIndex : 'CheckRemarks',
				editor : new Ext.form.TextField({
					selectOnFocus : true,
					allowBlank : true,
					maxLength : 100,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
								var col = GetColIndex(GrDetailInfoGrid, 'AdmNo');
								GrDetailInfoGrid.startEditing(cell[0], col);
							}
						}
					}
				})
			},{
				header : "注册证号",
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
					header : "注册证有效期",
					dataIndex : 'AdmExpdate',
					width : 100,
					align : 'center',
					sortable : true,	
					renderer : Ext.util.Format.dateRenderer(DateFormat),
					editor : new Ext.ux.DateField({
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
				header : "摘要",
				dataIndex : 'Remark',
				width : 90,
				align : 'left',
				sortable : true,
				editor : new Ext.form.TextField({
					listeners : {
						specialkey : function(field, e){
							if (e.getKey() == Ext.EventObject.ENTER) {
								var cell = GrDetailInfoGrid.getSelectionModel().getSelectedCell();
								var row = cell[0];
								if(row >= GrDetailInfoGrid.getStore().getCount()){
									return false;
								}
								var col = GetColIndex(GrDetailInfoGrid,"AOGTemp");
								GrDetailInfoGrid.startEditing(cell[0]+1, col);
							}
						}
					}
				})
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "发票号",
				dataIndex : 'InvNo',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "发票日期",
				dataIndex : 'InvDate',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "进价金额",
				dataIndex : 'RpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}]);
	GrDetailInfoCm.defaultSortable = true;
	var GrDetailInfoGrid = new Ext.ux.EditorGridPanel({
				region: 'center',
				id : 'GrDetailInfoGrid',
				title : '入库单明细',
				cm : GrDetailInfoCm,
				sm : new Ext.grid.CellSelectionModel({}),
				store : GrDetailInfoStore,
				trackMouseOver : true,
				tbar:new Ext.Toolbar({items:[CheckTypeCombo,"-",Checkall]}),
				plugins: [PackGood,CheckRepNo,Token,LocalToken,ProdCertif],
				viewConfig : {
					getRowClass : function(record,rowIndex,rowParams,store){
						var ExpDate = record.get("ExpDate");
						var ExpDateFlag = 0;	//1:过期, 2:30天警示
						if(!Ext.isEmpty(ExpDate)){
							var Today = new Date().format(DateFormat);		//和ExpDate统一格式(ExpDate为字符串,使用HIS日期格式)
							var DaysGap = DaysBetween(ExpDate, Today);
							if(DaysGap <= 0){
								ExpDateFlag = 1;
							}else if(DaysGap < 30){
								ExpDateFlag = 2;
							}
						}
						switch(ExpDateFlag){
							case 1:
								return 'my_row_Red';
								break;
							case 2:
								return 'my_row_Yellow';
								break;
							default:
								break;
						}
					}
				},
				listeners : {
					beforeedit : function(e){
						if(CommParObj.StopItmBussiness == 'Y'){
							var Ingri = e.record.get('Ingri');
							var AlarmDays = 0;
							var CheckInfo = tkMakeServerCall('web.DHCSTM.DHCINGdRecItm', 'CheckCredit', Ingri, AlarmDays);
							if(!Ext.isEmpty(CheckInfo)){
								return false;
							}
						}
					}
				}
			});

		var InfoForm= new Ext.form.FormPanel({
				region : 'north',
				autoHeight : true,
				frame : true,
				labelAlign : 'right',
				id : "InfoForm",
				title:'入库单查询与验收',
				layout: 'fit',
				tbar : [searchBT, '-', acceptBT, '-', clearBT],
				items:[{
					xtype:'fieldset',
					title:"查询条件",
					layout:'column',
					style:'padding:5px 0px 0px 0px;',
					autoHeight:true,
					defaults: {xtype: 'fieldset', border:false},
					items : [{
						columnWidth: 0.3,
						items: [PhaLoc,Vendor]
					},{
						columnWidth: 0.25,
						items: [StartDate,EndDate]
					},{
						columnWidth: 0.25,
						items: [InGrNo,InvNo,AuditFlag]
					},{
						columnWidth: 0.2,
						items: [AuditFlag]
					}]
				}]
			});
			
		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
				title : '入库单验收',
				layout : 'border',
				items : [InfoForm, GrMasterInfoGrid, GrDetailInfoGrid]
		});
})