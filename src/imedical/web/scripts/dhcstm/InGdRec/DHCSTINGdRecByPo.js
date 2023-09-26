// /名称: 根据订单入库
// /描述: 根据订单入库
// /编写者：zhangdongmei
// /编写日期: 2012.07.31
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	if(gParam.length<1){
		GetParam();  //初始化参数配置
	}

	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '科室',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : '订购科室...',
				groupId:session['LOGON.GROUPID'],
				childCombo : 'Vendor'
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
	var SourceOfFund = new Ext.ux.ComboBox({
		fieldLabel : '资金来源',
		id : 'SourceOfFund',
		anchor : '90%',
		store : SourceOfFundStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : false
	});
	var NotImp = new Ext.form.Checkbox({
				fieldLabel : '未入库',
				id : 'NotImp',
				name : 'NotImp',
				anchor : '90%',
				width : 120,
				checked : true
			});
	var PartlyImp = new Ext.form.Checkbox({
		fieldLabel : '部分入库',
		id : 'PartlyImp',
		name : 'PartlyImp',
		anchor : '90%',
		width : 120,
		checked : true
	});
	/*
	var AllImp = new Ext.form.Checkbox({
		fieldLabel : '全部入库',
		id : 'AllImp',
		name : 'AllImp',
		anchor : '90%',
		width : 120,
		checked : false
	});
	*/
	// 供应商
	var Vendor = new Ext.ux.VendorComboBox({
			id : 'Vendor',
			name : 'Vendor',
			anchor : '90%',
			params : {LocId : 'PhaLoc'}
	});
		
	// 查询订单按钮
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '查询',
				tooltip : '点击查询订单',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
			});

	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : '清空',
				tooltip : '点击清空',
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
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("Vendor").setDisabled(0);
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 7));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("NotImp").setValue(true);
		Ext.getCmp("PartlyImp").setValue(true);
		
		MasterGrid.store.removeAll();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		
	}

	// 保存按钮
	var SaveBT = new Ext.ux.Button({
				id : "SaveBT",
				text : '保存',
				tooltip : '点击保存',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					if(DetailGrid.activeEditor != null){
						DetailGrid.activeEditor.completeEdit();
					}
					if(CheckDataBeforeSave()==true){
						save();
					}
				}
			});

	/**
	 * 保存入库单前数据检查
	 */		
	function CheckDataBeforeSave() {
		var nowdate = new Date();
		var record = MasterGrid.getSelectionModel().getSelected();
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
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "请选择入库部门!");
			return false;
		}
		
		// 1.判断入库物资是否为空
		var rowCount = DetailGrid.getStore().getCount();
		// 有效行数
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var item = DetailStore.getAt(i).get("IncId");
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
//				var item_i = DetailStore.getAt(i).get("IncId");;
//				var item_j = DetailStore.getAt(j).get("IncId");;
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
			var expDateValue = DetailStore.getAt(i).get("ExpDate");
			var item = DetailStore.getAt(i).get("IncId");
			var BatchReq = DetailStore.getAt(i).get("BatchReq");
			if(BatchReq=='R'){
				var BatchNo = DetailStore.getAt(i).get("BatNo");
				if ((item != "") && (BatchNo==null || BatchNo=="")) {
					Msg.info("warning", "第"+(i+1)+"行批号不能为空!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			var ExpReq = DetailStore.getAt(i).get("ExpReq");
			if(ExpReq=='R'){
				var ExpDate = new Date(Date.parse(expDateValue));
				if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
					Msg.info("warning", "有效期不能小于或等于当前日期!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			var qty = DetailStore.getAt(i).get("AvaQty");
			if ((item != "") && (qty == null || qty <= 0)) {
				Msg.info("warning", "入库数量不能小于或等于0!");
				var col=GetColIndex(DetailGrid,'AvaQty');
				DetailGrid.startEditing(i, col);
				changeBgColor(i, "yellow");
				return false;
			}
			var purqty=DetailStore.getAt(i).get("PurQty");
			var ImpQty=DetailStore.getAt(i).get("ImpQty");
			if((gParam[13]=="N"||gParam[13]=="")&&(qty>(purqty-ImpQty))){
				Msg.info("warning", "入库数量不能大于订购数量!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			
			var realPrice = DetailStore.getAt(i).get("Rp");
			if ((item != "")&& (Ext.isEmpty(realPrice) || realPrice < 0)) {
				Msg.info("warning", "入库进价不能小于0!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}else if((item != "") && (realPrice == 0)){
				if(confirm('第' + (i+1) + '行:' + DetailStore.getAt(i).get('IncDesc') + ' 进价为0, 是否继续?') == false){
					return false;
				}
			}
		}
		
		return true;
	}
	
	/**
	 * 保存入库单
	 */
	function save() {
		var selectRecords = MasterGrid.getSelectionModel().getSelections();
		var record = selectRecords[0];	
		var Ingr = '';
		var VenId = record.get("VenId");
		var Completed = 'N';
		var LocId = Ext.getCmp("PhaLoc").getValue();
		var CreateUser = userId;
		var ExchangeFlag ='N';
		var PresentFlag = 'N';
		var IngrTypeId = "";    //正常入库(2014-01-27:传参改为空,类中处理)
		var PurUserId = record.get("PurUserId");
		var StkGrpId = record.get("StkGrpId");
		var PoId=record.get("PoId");  //订单id
		var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
		var ReqLoc=record.get("ReqLoc");  //申购科室
		var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^" + ExchangeFlag
				+ "^" + IngrTypeId + "^" + PurUserId + "^"+StkGrpId+"^"+PoId+"^^"+SourceOfFund
				+"^"+ReqLoc;
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);
			var Ingri='';
			var IncId = rowData.get("IncId");
			var BatchNo = rowData.get("BatNo");
			var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
			var ManfId = rowData.get("ManfId");
			var IngrUomId = rowData.get("PurUomId");
			var RecQty = rowData.get("AvaQty");
			var Rp = rowData.get("Rp");
			var Sp =rowData.get("Sp");
			var NewSp = Sp;
			var SxNo ='';
			var InvNo ='';
			var InvDate ='';
			var PoItmId=rowData.get("PoItmId");
			var CerNo = rowData.get('CerNo')
			var CerExpDate = rowData.get('CerExpDate');
			CerExpDate = Ext.util.Format.date(CerExpDate,ARG_DATEFORMAT);
			var SpecDesc = rowData.get('SpecDesc');
			var str = Ingri + "^" + IncId + "^"	+ BatchNo + "^" + ExpDate + "^" + ManfId
					+ "^" + IngrUomId + "^" + RecQty+ "^" + Rp + "^" + NewSp + "^" + SxNo
					+ "^" + InvNo + "^" + InvDate + "^" + PoItmId + "^" + ""  + "^" + ""
					+ "^^^^^" + CerNo
					+ "^" + CerExpDate + "^^" + SpecDesc + "^^"
					+ "^" + Sp;
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
							window.location.href='dhcstm.ingdrec.csp?Rowid='+IngrRowid+'&QueryFlag=1';
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
	function deleteDetail() {
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "没有选中行!");
			return;
		}
		// 选中行
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);			
		DetailGrid.getStore().remove(record);
		DetailGrid.view.refresh();
	}
	

	// 单位
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : '单位',
				id : 'CTUom',
				name : 'CTUom',
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
	CTUom.on('expand', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("IncId");
				ItmUomStore.setBaseParam('ItmRowid',InciDr);
				ItmUomStore.removeAll();
				CTUom.store.load();
			});

	/**
	 * 单位变换事件
	 */
	CTUom.on('select', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				
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
				params : {LocId : 'PhaLoc'}
			});


	// 显示订单数据
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", "请选择订购部门!");
			return;
		}
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if(startDate!=""){
			startDate = startDate.format(ARG_DATEFORMAT);
		}
		if(endDate!=""){
			endDate = endDate.format(ARG_DATEFORMAT);
		}
		var notimp = (Ext.getCmp("NotImp").getValue()==true?0:'');
		var partlyimp = (Ext.getCmp("PartlyImp").getValue()==true?1:'');
		//var allimp = (Ext.getCmp("AllImp").getValue()==true?2:'');
		var Status=notimp+","+partlyimp;
		var Vendor = Ext.getCmp("Vendor").getValue();

		//开始日期^截止日期^订单号^供应商id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)^库存项id^是否包含支配科室
		//^请求科室^人员rowid^过滤无明细订单
		var ListParam=startDate+'^'+endDate+'^^'+Vendor+'^'+phaLoc+'^Y^1^'+Status+'^^'
			+'^^'+userId+'^Y^N';
		var Page=GridPagingToolbar.pageSize;
		MasterStore.removeAll();
		DetailGrid.store.removeAll();
		MasterStore.setBaseParam("ParamStr",ListParam);
		MasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
				if(success==false){
					Msg.info("error", "查询错误，请查看日志!");
				}else{
					if(r.length>0){
						MasterGrid.getSelectionModel().selectFirstRow();
						MasterGrid.getView().focusRow(0);
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
		DetailStore.load({params:{start:0,limit:999,Parref:Parref}});
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
	var MasterStore = new Ext.data.Store({
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
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	var MasterGrid = new Ext.ux.GridPanel({
				id : 'MasterGrid',
				region: 'west',
				title : '订单',    
				collapsible: true,
				split: true,
				width: 225,
				minSize: 175,
				maxSize: 400,
				margins: '0 5 0 0',
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
		var PoId = MasterStore.getAt(rowIndex).get("PoId");
		DetailStore.load({params:{start:0,limit:999,Parref:PoId}});
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
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","Spec", "PurUomId", "PurUom", "AvaQty", "Rp",
			 "ManfId", "Manf", "Sp","BatNo",{name:"ExpDate",type:"date",dateFormat:DateFormat}, "BUomId", "ConFac","PurQty","ImpQty",
			 "BatchReq","ExpReq","ImpQtyAudited","SpecDesc","CerNo",{name:'CerExpDate',type:'date',dateFormat:DateFormat}];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoItmId",
				fields : fields
			});
	// 数据集
	var DetailStore = new Ext.data.Store({
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
				header : '规格',
				dataIndex : 'Spec',
				width : 80,
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
				renderer : Ext.util.Format.comboRenderer2(CTUom,"PurUomId","PurUom"),
				editor : new Ext.grid.GridEditor(CTUom)
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
										
										var cell = DetailGrid.getSelectionModel().getSelectedCell();
										DetailGrid.startEditing(cell[0], 10);
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
								var cell = DetailGrid.getSelectionModel().getSelectedCell();
								var col=GetColIndex(DetailGrid,'BatNo');
								DetailGrid.startEditing(cell[0], col);
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
				header : "已入库数量",		//2015-09-16 单据状态根据入库审核计算,这里改为"已入库制单数量"
				dataIndex : 'ImpQtyAudited',
				width : 100,
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
			}, {
				header : "具体规格",
				dataIndex : 'SpecDesc',
				width : 80,
				align : 'left'
			}, {
				header : "注册证号",
				dataIndex : 'CerNo',
				width : 80,
				align : 'left'
			}, {
				header : "注册证号效期",
				dataIndex : 'CerExpDate',
				renderer : Ext.util.Format.dateRenderer(DateFormat),
				width : 80,
				align : 'left'
			}]);

	var DetailGrid = new Ext.ux.EditorGridPanel({
				id : 'DetailGrid',
				region : 'center',
				title: '订单明细',
				cm : DetailCm,
				store : DetailStore,
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
							var Inci = e.record.get('IncId');
							var flag=ExpDateValidator(expDate,Inci);
							if(flag==false){
								//Msg.info('warning','该物资距离失效期少于'+gParam[2]+'天!');
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
	DetailGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
		items: [ 
			{ 
				id: 'mnuDelete', 
				handler: deleteDetail, 
				text: '删除' 
			},{ 
				id: 'mnuSplit', 
				handler: splitDetail, 
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
	function splitDetail(item,e){
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "没有选中行!");
			return;
		}
		var row = cell[0];
		var record = DetailStore.getAt(row);
		var newRecord = new DetailStore.recordType(record.copy().data,++rowsAdd);
		DetailStore.insert(row+1,newRecord);
		DetailGrid.view.refresh();
	}

	// 变换行颜色
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}

	var HisListTab = new Ext.form.FormPanel({
		region : 'north',
		labelWidth : 60,
		title:'入库制单-依据订单',
		labelAlign : 'right',
		frame : true,
		autoHeight : true,
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT],
		layout : 'column',
		items : [{
			columnWidth : 0.7,
			layout: 'column',
			xtype:'fieldset',
			title:'查询条件',
			style : 'padding:5px 0px 0px 5px;',
			defaults: {border:false},
			items:[{
				columnWidth: 0.34,
				xtype: 'fieldset',
				items: [PhaLoc,Vendor]
			},{
				columnWidth: 0.33,
				xtype: 'fieldset',
				items: [StartDate,EndDate]
			},{
				columnWidth: 0.33,
				xtype: 'fieldset',
				items: [NotImp,PartlyImp]
			}]
		},{
			columnWidth : 0.3,
			layout: 'column',
			xtype:'fieldset',
			title:'入库选项',
			style : 'padding:5px 0px 0px 5px;',
			defaults: {border:false},
			items:[{
				columnWidth: 1,
				xtype: 'fieldset',
				items: [SourceOfFund]
			}]
		}]
	});

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
					items : [
					HisListTab, MasterGrid, DetailGrid
				],
				renderTo : 'mainPanel'
			});
	//页面加载完成后自动检索订单
	Query();
})