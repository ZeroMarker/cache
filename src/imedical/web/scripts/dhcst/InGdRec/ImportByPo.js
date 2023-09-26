// /名称: 订单
function ImportByPo(Fn) {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	if(gParam.length<1){
		GetParam();  //初始化参数配置
	}

	var PoPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '科室',
				id : 'PoPhaLoc',
				name : 'PoPhaLoc',
				anchor : '90%',
				emptyText : '订购科室...',
				groupId:gGroupId,
				childCombo : 'PoVendor'
			});
	// 起始日期
	var StartDatex = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDatex',
				name : 'StartDatex',
				anchor : '90%',
				width : 120,
				value : new Date().add(Date.DAY, - 7)
			});
	// 截止日期
	var EndDatex = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDatex',
				name : 'EndDatex',
				anchor : '90%',
				width : 120,
				value : new Date()
			});
	var PoNotImp = new Ext.form.Checkbox({
				fieldLabel : '未入库',
				id : 'PoNotImp',
				name : 'PoNotImp',
				anchor : '90%',
				checked : true
			});
	var PoPartlyImp = new Ext.form.Checkbox({
		fieldLabel : '部分入库',
		id : 'PoPartlyImp',
		name : 'PoPartlyImp',
		anchor : '90%',
		checked : true
	});
	// 供应商
	var PoVendor = new Ext.ux.VendorComboBox({
			id : 'PoVendor',
			name : 'PoVendor',
			anchor : '90%',
			params : {LocId : 'PoPhaLoc'}
	});
	// 入库单号
	var PoNo = new Ext.form.TextField({
		fieldLabel : '订单号',
		id : 'PoNo',
		name : 'PoNo',
		anchor : '90%',
		listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					PoQuery();	
					}
				}
			}
	});
	
		
	// 查询订单按钮
	var PoSearchBT = new Ext.Toolbar.Button({
				id : "PoSearchBT",
				text : '查询',
				tooltip : '点击查询订单',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					PoQuery();
				}
			});


	// 清空按钮
	var PoClearBT = new Ext.Toolbar.Button({
				id : "PoClearBT",
				text : '清空',
				tooltip : '点击清空',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					PoclearData();
				}
			});
	/**
	 * 清空方法
	 */
	function PoclearData() {
		SetLogInDept(Ext.getCmp("PoPhaLoc").getStore(),"PoPhaLoc");
		Ext.getCmp("PoVendor").setDisabled(0);
		Ext.getCmp("PoNotImp").setValue(true);
		Ext.getCmp("PoPartlyImp").setValue(true);
		
		PoMasterGrid.store.removeAll();
		PoDetailGrid.store.removeAll();
		PoDetailGrid.getView().refresh();
		
	}

	// 保存按钮
	var PoSaveBT = new Ext.Toolbar.Button({
				id : "PoSaveBT",
				text : '保存',
				tooltip : '点击保存',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					if(PoDetailGrid.activeEditor != null){
						PoDetailGrid.activeEditor.completeEdit();
					}
					if(PoCheckDataBeforeSave()==true){
						Posave();						
					}
				}
			});

	/**
	 * 保存入库单前数据检查
	 */		
	function PoCheckDataBeforeSave() {
		var nowdate = new Date();
		var record = PoMasterGrid.getSelectionModel().getSelected();
		if(record==null){
			Msg.info("warning", "没有需要保存的数据!");				
			return false;
		}
		
		var Status = record.get("PoStatus");				
		if (Status ==2) {
			Msg.info("warning", "该订单已经全部入库，不能再入库!");				
			return false;
		}			
		
		// 判断入库部门和供货商是否为空
		var PoPhaLoc = Ext.getCmp("PoPhaLoc").getValue();
		if (PoPhaLoc == null || PoPhaLoc.length <= 0) {
			Msg.info("warning", "请选择入库部门!");
			return false;
		}
		
		// 1.判断入库物资是否为空
		var rowCount = PoDetailGrid.getStore().getCount();
		// 有效行数
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var item = PoDetailStore.getAt(i).get("IncId");
			if (item != "") {
				count++;
			}
		}
		if (rowCount <= 0 || count <= 0) {
			Msg.info("warning", "请输入入库明细!");
			return false;
		}
		// 2.重新填充背景
		for (var i = 0; i < rowCount; i++) {
			changeBgColor(i, "white");
		}
		// 3.判断重复输入物资
//		for (var i = 0; i < rowCount - 1; i++) {
//			for (var j = i + 1; j < rowCount; j++) {
//				var item_i = PoDetailStore.getAt(i).get("IncId");;
//				var item_j = PoDetailStore.getAt(j).get("IncId");;
//				if (item_i != "" && item_j != ""
//						&& item_i == item_j) {
//					changeBgColor(i, "yellow");
//					changeBgColor(j, "yellow");
//					Msg.info("warning", "物资重复，请重新输入!");
//					return false;
//				}
//			}
//		}
		// 4.物资信息输入错误
		for (var i = 0; i < rowCount; i++) {
			var expDateValue = PoDetailStore.getAt(i).get("ExpDate");
			var item = PoDetailStore.getAt(i).get("IncId");
			var BatchReq = PoDetailStore.getAt(i).get("BatchReq");
			if(BatchReq=='R'){
				var BatchNo = PoDetailStore.getAt(i).get("BatNo");
				if ((item != "") && (BatchNo==null || BatchNo=="")) {
					Msg.info("warning", "第"+(i+1)+"行批号不能为空!");
					PoDetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			var ExpReq = PoDetailStore.getAt(i).get("ExpReq");
			if(ExpReq=='R'){
				var ExpDate = new Date(Date.parse(expDateValue));
				if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
					Msg.info("warning", "有效期不能小于或等于当前日期!");
					PoDetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			var qty = PoDetailStore.getAt(i).get("AvaQty");
			if ((item != "") && (qty == null || qty <= 0)) {
				Msg.info("warning", "入库数量不能小于或等于0!");
				var col=GetColIndex(PoDetailGrid,'AvaQty');
				PoDetailGrid.startEditing(i, col);
				changeBgColor(i, "yellow");
				return false;
			}
			var purqty=PoDetailStore.getAt(i).get("PurQty");
			var ImpQty=PoDetailStore.getAt(i).get("ImpQty");
			if((gParam[13]=="N"||gParam[13]=="")&&(qty>(purqty-ImpQty))){
				Msg.info("warning", "入库数量不能大于订购数量!");
				PoDetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			
			var realPrice = PoDetailStore.getAt(i).get("Rp");
			if ((item != "")&& (realPrice == null || realPrice <= 0)) {
				Msg.info("warning", "入库进价不能小于或等于0!");
				PoDetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
		}
		
		return true;
	}
	
	/**
	 * 保存入库单
	 */
	function Posave() {
		var selectRecords = PoMasterGrid.getSelectionModel().getSelections();
		var record = selectRecords[0];	
		var Ingr = '';
		var VenId = record.get("VenId");
		var Completed = 'N';
		var LocId = Ext.getCmp("PoPhaLoc").getValue();
		var CreateUser = gUserId;
		var ExchangeFlag ='N';
		var PresentFlag = 'N';
		var IngrTypeId = "";    //正常入库(2014-01-27:传参改为空,类中处理)
		var PurUserId = record.get("PurUserId");
		var StkGrpId = record.get("StkGrpId");
		var PoId=record.get("PoId");  //订单id
		var ReqLoc=record.get("ReqLoc");  //申购科室
		
		var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^"
				+ ExchangeFlag + "^" + IngrTypeId + "^" + PurUserId + "^"+StkGrpId+"^"+PoId+"^^^"+ReqLoc;
		var ListDetail="";
		var rowCount = PoDetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = PoDetailStore.getAt(i);					
								
			var Ingri='';
			var IncId = rowData.get("IncId");
			var BatchNo = rowData.get("BatNo");
			var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
			var ManfId = rowData.get("ManfId");
			var IngrUomId = rowData.get("PurUomId");
			var RecQty = rowData.get("AvaQty");
			var Rp = rowData.get("Rp");
			var NewSp =rowData.get("Sp");
			var SxNo ='';
			var InvNo ='';
			var InvDate ='';
			var PoItmId=rowData.get("PoItmId");
			
			var str = Ingri + "^" + IncId + "^"	+ BatchNo + "^" + ExpDate + "^"
					+ ManfId + "^" + IngrUomId + "^" + RecQty+ "^" + Rp + "^" + NewSp + "^"
					+ SxNo + "^" + InvNo + "^" + InvDate+"^"+PoItmId;	
			if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+RowDelim+str;
			}
			
		}
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params : {Ingr:Ingr,MainInfo:MainInfo,ListDetail:ListDetail},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 刷新界面
							var IngrRowid = jsonData.info;
							Msg.info("success", "保存成功!");
							// 7.显示入库单数据
							// 跳转到入库制单界面
							Fn(IngrRowid);
							Powin.close();
						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info("error", "加锁失败,不能保存!");
							}else if(ret==-2){
								Msg.info("error", "生成入库单号失败,不能保存!");
							}else if(ret==-3){
								Msg.info("error", "保存入库单失败!");
							}else if(ret==-4){
								Msg.info("error", "未找到需更新的入库单,不能保存!");
							}else if(ret==-5){
								Msg.info("error", "保存入库单明细失败!");
							}else {
								Msg.info("error", "部分明细保存不成功："+ret);
							}
							
						}
					},
					scope : this
				});
		
	}

	/**
	 * 删除选中行物资
	 */
	function PodeleteDetail() {
		var cell = PoDetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "没有选中行!");
			return;
		}
		// 选中行
		var row = cell[0];
		var record = PoDetailGrid.getStore().getAt(row);			
		PoDetailGrid.getStore().remove(record);
		PoDetailGrid.view.refresh();
	}
	

	// 单位
	var PoCTUom = new Ext.form.ComboBox({
				fieldLabel : '单位',
				id : 'PoCTUom',
				name : 'PoCTUom',
				anchor : '90%',
				width : 120,
				store : ItmUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '单位...',
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 10,
				listWidth : 250,
				valueNotFoundText : ''
			});
			
	/**
	 * 单位展开事件
	 */
	PoCTUom.on('expand', function(combo) {
				var cell = PoDetailGrid.getSelectionModel().getSelectedCell();
				var record = PoDetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("IncId");
				ItmUomStore.setBaseParam('ItmRowid',InciDr);
				ItmUomStore.removeAll();
				PoCTUom.store.load();
			});

	/**
	 * 单位变换事件
	 */
	PoCTUom.on('select', function(combo) {
				var cell = PoDetailGrid.getSelectionModel().getSelectedCell();
				var record = PoDetailGrid.getStore().getAt(cell[0]);
				
				var value = combo.getValue();        //目前选择的单位id
				var BUom = record.get("BUomId");
				var ConFac = Number(record.get("ConFac"));   //大单位到小单位的转换关系					
				var PurUom = record.get("PurUomId");    //目前显示的入库单位
				var Sp = Number(record.get("Sp"));
				var Rp = Number(record.get("Rp"));
				
				if (value == null || value.length <= 0) {
					return;
				} else if (PurUom == value) {
					return;
				} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
					record.set("Sp", Sp.div(ConFac));
					record.set("Rp", Rp.div(ConFac));
				} else{  //新选择的单位为大单位，原先是单位为小单位
					record.set("Sp", Sp.mul(ConFac));
					record.set("Rp", Rp.mul(ConFac));
				}
				record.set("PurUomId", combo.getValue());
	});
	
	// 生产厂商
	var Phmnf = new Ext.ux.ComboBox({
				fieldLabel : '厂商',
				id : 'Phmnf',
				name : 'Phmnf',
				store : PhManufacturerStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '厂商...',
				filterName : 'PHMNFName',
				params : {LocId : 'PoPhaLoc'}
			});


	// 显示订单数据
	function PoQuery() {
		var PoPhaLoc = Ext.getCmp("PoPhaLoc").getValue();
		if (PoPhaLoc =='' || PoPhaLoc.length <= 0) {
			Msg.info("warning", "请选择订购部门!");
			return;
		}
		var startDate = Ext.getCmp("StartDatex").getValue();
		var endDate = Ext.getCmp("EndDatex").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var PoNotImp = (Ext.getCmp("PoNotImp").getValue()==true?0:'');
		var PoPartlyImp = (Ext.getCmp("PoPartlyImp").getValue()==true?1:'');
		//var allimp = (Ext.getCmp("AllImp").getValue()==true?2:'');
		var Status=PoNotImp+","+PoPartlyImp;
		var PoVendor = Ext.getCmp("PoVendor").getValue();
		
		var PoNo = Ext.getCmp("PoNo").getValue();
		//开始日期^截止日期^订单号^供应商id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)^库存项id^是否包含支配科室
		//^请求科室^人员rowid^过滤无明细订单
		var ListParam=startDate+'^'+endDate+'^'+PoNo+'^'+PoVendor+'^'+PoPhaLoc+'^Y^1^'+Status+'^^^^^Y';
		var Page=PoGridPagingToolbar.pageSize;
		PoMasterStore.removeAll();
		PoDetailGrid.store.removeAll();
		PoMasterStore.setBaseParam("ParamStr",ListParam);
		PoMasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
				if(r.length==0){
     				Msg.info("warning", "未找到符合的单据!");
     			}else{
     				if(r.length>0){
	     				PoMasterGrid.getSelectionModel().selectFirstRow();
	     				PoMasterGrid.getSelectionModel().fireEvent('rowselect',this,0);
	     				PoMasterGrid.getView().focusRow(0);
     				}
     			}
     		}
		});

	}
	// 显示入库单明细数据
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		PoDetailStore.load({params:{start:0,limit:999,Parref:Parref}});
	}
	
	function renderPoStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus='未入库';			
		}else if(value==1){
			PoStatus='部分入库';
		}else if(value==2){
			PoStatus='全部入库';
		}
		return PoStatus;
	}
	// 访问路径
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=Query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","ReqLocDesc","ReqLoc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
				fields : fields
			});
	// 数据集
	var PoMasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'PoId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "订单号",
				dataIndex : 'PoNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "申购科室",
				dataIndex : 'ReqLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "订购科室",
				dataIndex : 'PoLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "订单状态",
				dataIndex : 'PoStatus',
				width : 90,
				align : 'left',
				sortable : true,
				renderer:renderPoStatus
			}, {
				header : "订单日期",
				dataIndex : 'PoDate',
				width : 80,
				align : 'right',
				sortable : true
			}]);
	MasterCm.defaultSortable = true;
	var PoGridPagingToolbar = new Ext.PagingToolbar({
		store:PoMasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	var PoMasterGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : MasterCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : PoMasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:PoGridPagingToolbar
			});

	// 添加表格单击行事件
	PoMasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var PoId = PoMasterStore.getAt(rowIndex).get("PoId");
		PoDetailStore.load({params:{start:0,limit:999,Parref:PoId}});
	});
	
	// 订单明细
	// 访问路径
	var DetailUrl =DictUrl+
		'ingdrecaction.csp?actiontype=QueryPoDetailForRec&Parref=&start=0&limit=999';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "AvaQty", "Rp",
			 "ManfId", "Manf", "Sp","BatNo",{name:"ExpDate",type:"date",dateFormat:ARG_DATEFORMAT}, "BUomId", "ConFac","PurQty","ImpQty",
			 "BatchReq","ExpReq","ImpQtyAudited"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoItmId",
				fields : fields
			});
	// 数据集
	var PoDetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				pruneModifiedRecords:true
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "订单明细id",
				dataIndex : 'PoItmId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "物资RowId",
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
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "数量",
				dataIndex : 'AvaQty',
				width : 80,
				align : 'right',
				sortable : true,
				editor : new Ext.form.NumberField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								
								var qty = field.getValue();
								if (qty == null || qty.length <= 0) {
									Msg.info("warning", "数量不能为空!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "数量不能小于或等于0!");
									return;
								}									
							}
						}
					}
				})
			}, {
				header : "单位",
				dataIndex : 'PurUomId',
				width : 80,
				align : 'left',
				sortable : true,
				renderer : Ext.util.Format.comboRenderer2(PoCTUom,"PurUomId","PurUom"),
				editor : new Ext.grid.GridEditor(PoCTUom)
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				sortable : true,
				editor : new Ext.ux.NumberField({
							formatType : 'FmtRP',
							selectOnFocus : true,
							allowBlank : false,
							listeners : {
								specialkey : function(field, e) {
									if (e.getKey() == Ext.EventObject.ENTER) {
										var cost = field.getValue();
										if (cost == null
												|| cost.length <= 0) {
											Msg.info("warning", "进价不能为空!");
											return;
										}
										if (cost <= 0) {
											Msg.info("warning",
													"进价不能小于或等于0!");
											return;
										}
										
										var cell = PoDetailGrid.getSelectionModel().getSelectedCell();
										PoDetailGrid.startEditing(cell[0], 10);
									}
								}
							}
				})
			}, {
				header : "售价",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				
				sortable : true
			},{
				header : "生产厂商",
				dataIndex : 'ManfId',
				width : 180,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(Phmnf),
				renderer : Ext.util.Format.comboRenderer2(Phmnf,"ManfId","Manf")
			}, {
				header : "批号",
				dataIndex : 'BatNo',
				width : 90,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(new Ext.form.TextField({
					selectOnFocus : true,
					allowBlank : true,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								
								var batchNo = field.getValue();
								if (batchNo == null || batchNo.length <= 0) {
									Msg.info("warning", "批号不能为空!");
									return;
								}
								var cell = PoDetailGrid.getSelectionModel().getSelectedCell();
								var col=GetColIndex(PoDetailGrid,'BatNo');
								PoDetailGrid.startEditing(cell[0], col);
							}
						}
					}
				}))
			}, {
				header : "有效期",
				dataIndex : 'ExpDate',
				width : 100,
				align : 'center',
				sortable : true,
				renderer : Ext.util.Format.dateRenderer(DateFormat),
				editor : new Ext.ux.DateField({
					selectOnFocus : true,
					allowBlank : false,
					
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								var expDate = field.getValue();
								if (expDate == null || expDate.length <= 0) {
									Msg.info("warning", "有效期不能为空!");
									return;
								}
								var nowdate = new Date();
								if (expDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT)) {
									Msg.info("warning", "有效期不能小于或等于当前日期!");
									return;
								}								
							}
						}
					}
				})
			}, {
				header : "订购数量",
				dataIndex : 'PurQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "已入库数量",
				dataIndex : 'ImpQtyAudited',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "已入库制单数量",		//2015-09-16 单据状态根据入库审核计算,这里改为"已入库制单数量"
				dataIndex : 'ImpQty',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "转换率",
				dataIndex : 'ConFac',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "基本单位",
				dataIndex : 'BUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "批号要求",
				dataIndex : 'BatchReq',
				width : 80,
				align : 'center',
				hidden : true
			}, {
				header : "有效期要求",
				dataIndex : 'ExpReq',
				width : 80,
				align : 'center',
				hidden : true
			}]);

	var PoDetailGrid = new Ext.grid.EditorGridPanel({
				id : 'PoDetailGrid',
				region : 'center',
				title : '',
				cm : DetailCm,
				store : PoDetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1,
				listeners : {
					beforeedit:function(e){
						if(e.field=='ExpDate' && e.record.get('ExpReq')=='N'){
							e.cancel=true;
						}
						if(e.field=='BatNo' && e.record.get('BatchReq')=='N'){
							e.cancel=true;
						}
					},
					afteredit : function(e){
						if(e.field=='ExpDate'){
							if(e.record.get('ExpReq')!='R'){
								return;
							}
							var expDate = e.value;
							if(expDate==null || expDate==""){
								Msg.info("warning","有效期不可为空!");
								e.record.set('ExpDate',e.originalValue);
								return;
							}else{
								expDate=expDate.format(ARG_DATEFORMAT);
							}
							var flag=ExpDateValidator(expDate);
							if(flag==false){
								Msg.info('warning','该物资距离失效期少于'+gParam[2]+'天!');
								e.record.set('ExpDate',e.originalValue);
								return;
							}
						}else if(e.field=='BatNo'){
							if(e.record.get('BatchReq')!='R'){
								return;
							}
							var BatchNo = e.value;
							if(BatchNo==null || BatchNo==""){
								Msg.info("warning","批号不可为空!");
								e.record.set('BatNo',e.originalValue);
								return;
							}
						}
					}
				}
			});
			
	/***
	**添加右键菜单
	**/		
	PoDetailGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
		items: [ 
			{ 
				id: 'mnuDelete', 
				handler: PodeleteDetail, 
				text: '删除' 
			},{ 
				id: 'mnuSplit', 
				handler: PosplitDetail, 
				text: '拆分明细' 
			}
		] 
	}); 
	
	//右键菜单代码关键部分 
	function rightClickFn(grid,rowindex,e){
		e.preventDefault();
		grid.getSelectionModel().select(rowindex,1);
		rightClick.showAt(e.getXY()); 
	}

	var rowsAdd = 1000;
	function PosplitDetail(item,e){
		var cell = PoDetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "没有选中行!");
			return;
		}
		var row = cell[0];
		var record = PoDetailStore.getAt(row);
		var newRecord = new PoDetailStore.recordType(record.copy().data,++rowsAdd);
		PoDetailStore.insert(row+1,newRecord);
		PoDetailGrid.view.refresh();
	}

	// 变换行颜色
	function changeBgColor(row, color) {
		PoDetailGrid.getView().getRow(row).style.backgroundColor = color;
	}

	var PoHisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		title:'入库制单-依据订单条码',
		labelAlign : 'right',
		frame : true,
		tbar : [PoSearchBT, '-',PoClearBT, '-',PoSaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'查询条件',
			style : 'padding:5px 0px 0px 5px;',
			defaults: {border:false},    // Default config options for child itemsPoNo
			items:[{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [PoNo,StartDatex]
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [PoPhaLoc,EndDatex]
			},{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',
	        	items: [PoVendor]
			},{ 				
				columnWidth: 0.15,
	        	xtype: 'fieldset',
	        	items: [PoNotImp]
			},{ 				
				columnWidth: 0.15,
				xtype: 'fieldset',
	        	items: [PoPartlyImp]
				
			}]
		}]
	});

	// 页面布局
	var Powin = new Ext.Window({
				width : 1000,
				height : 600,
				layout : 'border',
					items : [            // create instance immediately
		            {
		                region: 'north',
		                height: 170, // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:PoHisListTab
		            }, {
		                region: 'center',
		                title: '订单',		   		  
		                layout: 'fit', // specify layout manager for items
		                items: PoMasterGrid
		            }, {
		                region: 'south',
		                title: '订单明细',
		                height: 270, 
		                layout: 'fit', // specify layout manager for items
		                items: PoDetailGrid
		            }
       			]
			});
	//页面加载完成后自动检索订单
	Powin.show()
	PoNo.focus(true,100)
	
}