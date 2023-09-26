// /名称: 入库单制单
// /描述: 入库单制单
// /编写者：zhangdongmei
// /编写日期: 2012.06.27

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gHospId=session['LOGON.HOSPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var loadMask=null;
	if(gParam.length<1){
		GetParam();  //初始化参数配置
	}

	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '入库部门',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor:'90%',
		emptyText : '入库部门...',
		groupId:gGroupId
	});
	
	var VirtualFlag = new Ext.form.Checkbox({
		hideLabel:true,
		boxLabel : G_VIRTUAL_STORE,
		id : 'VirtualFlag',
		name : 'VirtualFlag',
		anchor : '90%',
		checked : false,
		listeners:{
			check:function(chk,bool){
				if(bool){
					var phaloc=Ext.getCmp("PhaLoc").getValue();
					var url="dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc="+phaloc;
					var response=ExecuteDBSynAccess(url);
					var jsonData=Ext.util.JSON.decode(response);
					if(jsonData.success=='true'){
						var info=jsonData.info;
						var infoArr=info.split("^");
						var vituralLoc=infoArr[0],vituralLocDesc=infoArr[1];
						addComboData(Ext.getCmp("PhaLoc").getStore(),vituralLoc,vituralLocDesc);
						Ext.getCmp("PhaLoc").setValue(vituralLoc);
					}
				}else{
					SetLogInDept(Ext.getCmp("PhaLoc").getStore(), "PhaLoc");
				}
			}
		}
	});
	
	// 入库类型
	var OperateInType = new Ext.form.ComboBox({
		fieldLabel : '入库类型',
		id : 'OperateInType',
		name : 'OperateInType',
		anchor : '90%',
		store : OperateInTypeStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		valueNotFoundText : ''
	});
	// 默认选中第一行数据
	OperateInTypeStore.load({
		callback:function(r,options,success){
			if(success && r.length>0){
				OperateInType.setValue(r[0].get(OperateInType.valueField));
			}
		}
	});
	// 采购人员
	var PurchaseUser = new Ext.ux.ComboBox({
		fieldLabel : '采购人员',
		anchor : '90%',
		id : 'PurchaseUser',
		store : PurchaseUserStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

	// 备注
	var InGrRemarks = new Ext.form.TextArea({
		id:'InGrRemarks',
		fieldLabel:'备注',
		allowBlank:true,
		height:50,
		emptyText:'备注...',
		anchor:'90%',
		selectOnFocus:true
	});
	
	// 赠药入库标志
	var PresentFlag = new Ext.form.Checkbox({
		boxLabel : '捐赠',
		id : 'PresentFlag',
		name : 'PresentFlag',
		anchor : '90%',
		checked : false
	});

	// 调价换票标志
	var ExchangeFlag = new Ext.form.Checkbox({		
		id : 'ExchangeFlag',
		name : 'ExchangeFlag',
		anchor : '90%',
		checked : false,
		boxLabel:'调价换票'
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

	// 打印入库单按钮
	var PrintBT = new Ext.Toolbar.Button({
		id : "PrintBT",
		text : '打印',
		tooltip : '点击打印入库单',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			var seled=GrMasterInfoGrid.getSelectionModel().getSelected();
			if (Ext.isEmpty(seled)) {
			Msg.info("warning", "没有需要打印的入库单!");
			return;
			}
			var ingr=seled.get("Ingr")
			if (Ext.isEmpty(ingr)) {
			Msg.info("warning", "没有需要打印的入库单!");
			return;
		}
			PrintRec(ingr);
		}
	});

      // 打印入库单按钮
	var PrintHVCol= new Ext.Toolbar.Button({
		id : "PrintHVCol",
		text : '高值汇总打印',
		tooltip : '打印高值入库单票据',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			var seled=GrMasterInfoGrid.getSelectionModel().getSelected();
			if (Ext.isEmpty(seled)) {
			Msg.info("warning", "没有需要打印的入库单!");
			return;
			}
			var ingr=seled.get("Ingr")
			if (Ext.isEmpty(ingr)) {
			Msg.info("warning", "没有需要打印的入库单!");
			return;
		}
			PrintRecHVCol(ingr);
		}
	});
			
	// 查询入库单按钮
	var SearchInGrBT = new Ext.Toolbar.Button({
		id : "SearchInGrBT",
		text : '查询',
		tooltip : '点击查询入库单',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			DrugImportGrSearch(DetailStore,Query);
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
	// 完成按钮
	var CompleteBT = new Ext.Toolbar.Button({
		id : "CompleteBT",
		text : '完成',
		tooltip : '点击完成',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
		  Complete();
		}
	});
			
	/**
	 * 清空方法
	 */
	function clearData() {
		clearPanel(HisListTab);
		OperateInTypeStore.load({
			callback:function(r,options,success){
				if(success && r.length>0){
					OperateInType.setValue(r[0].get(OperateInType.valueField));
				}
			}
		});
		GrMasterInfoGrid.store.removeAll();
		GrMasterInfoGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}
	
	// 增加按钮
	var AddBT = new Ext.Toolbar.Button({
		id : "AddBT",
		text : '增加一条',
		tooltip : '点击增加',
		width : 70,
		height : 30,
		iconCls : 'page_add',
		handler : function() {
			// 判断是否选择入库部门和供货厂商
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "请选择入库部门!");
				return;
			}
			var operateInType = Ext.getCmp("OperateInType")
					.getValue();
			if ((gParam[8]=="Y")&(operateInType == null || operateInType.length <= 0)) {
				Msg.info("warning", "请选择入库类型!");
				return;
			}
			// 新增一行
			addNewRow();
			// 变更按钮是否可用
			//查询^清除^新增^保存^删除^完成^取消完成
			
		}
	});
	
	/**
	 * 新增一行
	 */
	function addNewRow() {
		if(DetailGrid.activeEditor != null){
				DetailGrid.activeEditor.completeEdit();
			}
		var col=GetColIndex(DetailGrid,"HVBarCode");
		var lastInvNo="";
		// 判断是否已经有添加行
		var rowCount = DetailGrid.getStore().getCount();
		if (rowCount > 0) {
			var rowData = DetailStore.data.items[0];
			var data = rowData.get("IncId");
			if (data == null || data.length <= 0) {
				DetailGrid.startEditing(0, col);
				return;
			}
			if(gParam[14]=='Y'){
				lastInvNo=rowData.get('InvNo');
			}
		}
		var defaData = {InvNo : lastInvNo};
		var NewRecord = CreateRecordInstance(DetailStore.fields,defaData);
		DetailStore.insert(0,NewRecord);	
		DetailGrid.getView().refresh()
		DetailGrid.startEditing(0, col);
	}

	/**
	 * 保存入库单前数据检查
	 */		
	function CheckDataBeforeSave(rowIndex) {
		var nowdate = new Date();
		// 判断入库部门和供货商是否为空
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "请选择入库部门!");
			return false;
		}
		var IngrTypeId = Ext.getCmp("OperateInType").getValue();
		var PurUserId = Ext.getCmp("PurchaseUser").getValue();
		if((PurUserId==null || PurUserId=="")&(gParam[7]=='Y')){
			Msg.info("warning", "采购员不能为空!");
			return false;
		}
		if((IngrTypeId==null || IngrTypeId=="")&(gParam[8]=='Y')){
			Msg.info("warning", "入库类型不能为空!");
			return false;
		}
		var rowData = DetailStore.getAt(rowIndex);
		var item = rowData.get("IncId");
		if(item == ''){
			Msg.info("warning", "请输入入库明细!");
			return false;
		}
		
		var expDateValue = rowData.get("ExpDate");
		var ExpReq = rowData.get('ExpReq');
		if(ExpReq=='R'){
			var ExpDate = new Date(Date.parse(expDateValue));
			if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
				Msg.info("warning", "有效期不能小于或等于当前日期!");
				DetailGrid.getSelectionModel().select(rowIndex, 1);
				changeBgColor(rowIndex, "yellow");
				return false;
			}
		}
		var BatchNo = rowData.get('BatchNo');
		var BatchReq = rowData.get('BatchReq');
		if(BatchReq=='R'){
			if ((item != "") && (BatchNo=="")) {
				Msg.info("warning", "批号不可为空!");
				DetailGrid.getSelectionModel().select(rowIndex, 1);
				changeBgColor(rowIndex, "yellow");
				return false;
			}
		}
		var qty = rowData.get("RecQty");
		if ((item != "") && (qty == null || qty <= 0)) {
			Msg.info("warning", "入库数量不能小于或等于0!");
			DetailGrid.getSelectionModel().select(rowIndex, 1);
			changeBgColor(rowIndex, "yellow");
			return false;
		}
		var inpoqty=rowData.get("InPoQty");
		if((gParam[13]=="N"||gParam[13]=="")&&(qty>inpoqty)&&(inpoqty!="")){
			Msg.info("warning", "入库数量不能大于订购数量!");
			var cell = DetailGrid.getSelectionModel()
				.getSelectedCell();
			DetailGrid.getSelectionModel().select(cell[0], 1);
			changeBgColor(rowIndex, "yellow");
			return false;
		}
		
		var realPrice = rowData.get("Rp");
		if ((item != "")&& (realPrice == null || realPrice <= 0)) {
			Msg.info("warning", "入库进价不能小于或等于0!");
			DetailGrid.getSelectionModel().select(rowIndex, 1);
			changeBgColor(rowIndex, "yellow");
			return false;
		}
		var Sp = rowData.get("Sp");
//		if (Sp<=0){
//			Msg.info("warning","第"+(rowIndex+1)+"行售价不能为小于或等于0");
//			DetailGrid.getSelectionModel().select(rowIndex, 1);
//			changeBgColor(rowIndex, "yellow");
//			return false;
//		}
		
		return true;
	}
	
	/**
	 * 保存入库单
	 */
	function saveOrder(rowIndex) {
		var rowData = DetailStore.getAt(rowIndex);
		var VenId=rowData.get("Vendor")
		var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
		var ingr=""
		if(Ext.isEmpty(VenId)){
			Msg.info("error", "供应商不能为空!")
			if(loadMask){loadMask.hide();}
			return false;
		}
		var Grstore=GrMasterInfoGrid.getStore()
		var Grindex=Grstore.findExact("Vendor",VenId)
		if (Grindex!=-1){
			var GrrowData = Grstore.getAt(Grindex);
			ingr=GrrowData.get("Ingr")
			var LocId = Ext.getCmp("PhaLoc").getValue();
			var CreateUser = gUserId;
			var MainInfo = VenId + "^" + LocId + "^" + CreateUser
		}else{
			var IngrNo =""
			var LocId = Ext.getCmp("PhaLoc").getValue();
			var CreateUser = gUserId;
			var ExchangeFlag =(Ext.getCmp("ExchangeFlag").getValue()==true?'Y':'N');
			var PresentFlag = (Ext.getCmp("PresentFlag").getValue()==true?'Y':'N');
			var IngrTypeId = Ext.getCmp("OperateInType").getValue();
			var PurUserId = Ext.getCmp("PurchaseUser").getValue();
			var StkGrpId =""
			var InGrRemarks = Ext.getCmp("InGrRemarks").getValue();
			InGrRemarks=InGrRemarks.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
			var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^"
					+ ExchangeFlag + "^" + IngrTypeId + "^" + PurUserId + "^"+StkGrpId+"^"+""+"^"+InGrRemarks+"^"+SourceOfFund;
			ingr=tkMakeServerCall("web.DHCSTM.DHCINGdRec","Insert",MainInfo);
			var mytrn=tkMakeServerCall("web.DHCSTM.DHCINGdRec","Select",ingr);
			var mytrnarr=mytrn.split("^");
			var ingrno=mytrnarr[0],vendor=mytrnarr[1],vendordesc=mytrnarr[2],complete=mytrnarr[9];
			var defaData = {Ingr:ingr,IngrNo:ingrno,Vendor:vendor,VendorDesc:vendordesc,Complete:complete};
			var NewRecord = CreateRecordInstance(Grstore.fields,defaData);
			Grstore.add(NewRecord);	
		}
		
		var ListDetail="";
		var Ingri=rowData.get("Ingri");
		var IncId = rowData.get("IncId");
		var Sp=rowData.get("Sp");
		var BatchNo = rowData.get("BatchNo");
		var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
		var ManfId = rowData.get("ManfId");
		var IngrUomId = rowData.get("IngrUomId");
		var RecQty = rowData.get("RecQty");
		var Rp = rowData.get("Rp");
		var NewSp =rowData.get("NewSp");
		var SxNo = rowData.get("SxNo");
		var InvNo = rowData.get("InvNo");
		var InvDate =Ext.util.Format.date(rowData.get("InvDate"),ARG_DATEFORMAT);
		var Remark=rowData.get("Remark");
		var Remarks=rowData.get("Remarks");
		var QualityNo=rowData.get("QualityNo");
		var MtDesc=rowData.get("MtDesc");
		var MtDr=rowData.get("MtDr");
		var BarCode=rowData.get("HVBarCode");
		var SterilizedNo=rowData.get("SterilizedNo");
		var AdmNo = rowData.get("AdmNo");
		var AdmExpDate =Ext.util.Format.date(rowData.get("AdmExpdate"),ARG_DATEFORMAT);
		var PoI=rowData.get("PoI");
		var ListDetail = Ingri + "^" + IncId + "^"	+ BatchNo + "^" + ExpDate + "^" + ManfId 
				+ "^" + IngrUomId + "^" + RecQty+ "^" + Rp + "^" + NewSp + "^" + SxNo
				+ "^" + InvNo + "^" + InvDate+ "^" +PoI+"^"+Remark+ "^" +Remarks
				+"^" + QualityNo+"^"+MtDr+"^"+BarCode+"^"+SterilizedNo+"^"+AdmNo
				+"^"+AdmExpDate + "^^^^"
				+ "^" + Sp;
		
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=InsertDetail";
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{Ingr:ingr,MainInfo:MainInfo,ListDetail:ListDetail},
			waitMsg : '处理中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "保存成功!");
					rowData.commit();
					if(loadMask){loadMask.hide();}
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
					if(loadMask){loadMask.hide();}
				}
			},
			scope : this
		});
	}
	
	
	// 入库明细
	// 访问路径
	var DetailUrl =DictUrl+
		'ingdrecaction.csp?actiontype=QueryDetail&Parref=&start=0&limit=999';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
		url : DetailUrl,
		method : "POST"
	});
	
	// 指定列参数
	var fields = ["Ingri", "IncId", "IncCode", "IncDesc","ManfId","Manf","BatchNo", {name:'ExpDate',type:'date',dateFormat:DateFormat},
		"IngrUomId","IngrUom","RecQty","Rp", "Marginnow", "Sp","NewSp","InvNo","InvMoney", {name:'InvDate',type:'date',dateFormat:DateFormat},"RpAmt", "SpAmt", "NewSpAmt",
		"QualityNo","SxNo","Remark","Remarks","MtDesc","PubDesc","BUomId","ConFacPur","MtDr","HVFlag","HVBarCode","Spec","SterilizedNo","InPoQty","BatchReq","ExpReq","BarCode","AdmNo",{name:'AdmExpdate',type:'date',dateFormat:DateFormat}];
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

	/**
	 * 完成入库单
	 */
	function Complete() {
		// 判断入库单是否已完成
		var seled=GrMasterInfoGrid.getSelectionModel().getSelected();
		if (Ext.isEmpty(seled)) {
			Msg.info("warning", "没有需要完成的入库单!");
			return;
		}
		var ingr=seled.get("Ingr")
		if (Ext.isEmpty(ingr)) {
			Msg.info("warning", "没有需要完成的入库单!");
			return;
		}
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=MakeComplete";
		Ext.Ajax.request({
			url : url,
			params : {Rowid:ingr,User:gUserId,GroupId:gGroupId},
			method : 'POST',
			waitMsg : '查询中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					// 审核单据
					Msg.info("success", "成功!");
					GrMasterInfoGrid.getStore().remove(seled);
				} else {
					var Ret=jsonData.info;
					if(Ret==-1){
						Msg.info("error", "操作失败,入库单Id为空或入库单不存在!");
					}else if(Ret==-2){
						Msg.info("error", "入库单已经完成!");
					}else {
						Msg.info("error", "操作失败!");
					}
				}
			},
			scope : this
		});
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

	// 生产厂商
	var Phmnf = new Ext.ux.ComboBox({
		fieldLabel : '厂商',
		id : 'Phmnf',
		name : 'Phmnf',
		anchor : '90%',
		width : 100,
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName',
		params : {LocId : 'PhaLoc'},
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var col=GetColIndex(DetailGrid,'BatchNo');
					DetailGrid.startEditing(cell[0], col);
				}
			}
		}
	});

	var ExpDateEditor = new Ext.ux.DateField({
		selectOnFocus : true,
		allowBlank : false,
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var col=GetColIndex(DetailGrid,'Rp');
					DetailGrid.startEditing(cell[0], col);
				}
			}
		}
	});
				
	var InvNoEditor=new Ext.form.TextField({
		selectOnFocus : true,
		allowBlank : true,
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					col=GetColIndex(DetailGrid,"InvDate");
					DetailGrid.startEditing(cell[0], col);
				}
			}
		}
	})

	var RpEditor=new Ext.ux.NumberField({
		formatType : 'FmtRP',
		selectOnFocus : true,
		allowBlank : false,
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					// 新增一行
					addNewRow();
				}
			}
		}
	})

	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
			header : "rowid",
			dataIndex : 'Ingri',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "IncRowid",
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
			header : "高值标志",
			dataIndex : 'HVFlag',
			width : 80,
			align : 'center',
			sortable : true,
			hidden : true
		}, {
			header : "高值条码",
			dataIndex : 'HVBarCode',
			width : 180,
			align : 'left',
			sortable : true,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (field.getValue()!="" && e.getKey() == Ext.EventObject.ENTER){
							var Barcode=field.getValue();
							var row=DetailGrid.getSelectionModel().getSelectedCell()[0];
							var findHVIndex=DetailStore.findExact('HVBarCode',Barcode,0);
							if(findHVIndex>=0 && findHVIndex!=row){
								Msg.info("warning","不可重复录入!");
								field.setValue("");
								field.focus();
								return;
							}
							Ext.Ajax.request({
								url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode',
								method : 'POST',
								params : {Barcode:Barcode},
								waitMsg : '查询中...',
								success : function(result, request){
									var jsonData = Ext.util.JSON
											.decode(result.responseText);
									if(jsonData.success == 'true'){
										var itmArr=jsonData.info.split("^");
										var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
										var inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
										var poi=itmArr[15],batchno=itmArr[16],expdate=itmArr[17]
										var certNo=itmArr[22];
										var certExpDate=itmArr[23];
										if((type!="Reg" && type!="G")||(type=="G" && lastDetailAudit=="Y")){
											Msg.info("warning","该条码已办理入库!");
											DetailGrid.store.getAt(row).set("HVBarCode","");
											return;
										}else if(type=="G" && lastDetailAudit!="Y"){
											Msg.info("warning","有未完成或未审核的"+lastDetailOperNo);
											DetailGrid.store.getAt(row).set("HVBarCode","");
											return;
										}
										
										var record = Ext.data.Record.create([{
												name : 'InciDr',
												type : 'string'
											}, {
												name : 'InciCode',
												type : 'string'
											}, {
												name : 'InciDesc',
												type : 'string'
											},{
												name : 'PoI',
												type : 'string'
											}, {
												name : 'BatchNo',
												type : 'string'
											}, {
												name : 'ExpDate',
												type : 'string'
											},
											{
												name : 'CertNo',
												type : 'string'
											},
											{	
												name : 'CertExpDate',
												type : 'string'
											}
											]);
										var InciRecord = new record({
											InciDr : inciDr,
											InciCode : inciCode,
											InciDesc : inciDesc,
											PoI:poi,
											BatchNo:batchno,
											ExpDate:expdate,
											HVFlag : 'Y',
											CertNo:certNo,
											CertExpDate:certExpDate
										});
										getDrugList(InciRecord)
									}else{
										Msg.info("error","该条码尚未注册!");
										DetailGrid.store.getAt(row).set("HVBarCode","");
										return;
									}
								}
							});
						}
					}
				}
			}))
		}, {
			header : "确认",
			dataIndex :'confirm',
			width : 180,
			align : 'left',
			sortable : true,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var rowIndex = DetailGrid.getSelectionModel().getSelectedCell()[0];
							if(DetailGrid.activeEditor != null){
								DetailGrid.activeEditor.completeEdit();
							}
							loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
							if(CheckDataBeforeSave(rowIndex)==true){
								// 保存入库单
								saveOrder(rowIndex);
								addNewRow();
							}else{
								loadMask.hide();
							}
						}
					}
				}
			}))
		},{
			header : "厂商",
			dataIndex : 'ManfId',
			width : 180,
			align : 'left',
			sortable : true,
			editor : new Ext.grid.GridEditor(Phmnf),
			renderer :Ext.util.Format.comboRenderer2(Phmnf,"ManfId","Manf")	 
		}, {
			header : "批号",
			dataIndex : 'BatchNo',
			width : 90,
			align : 'left',
			sortable : true,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = DetailGrid.getSelectionModel().getSelectedCell();
							var batchNo = field.getValue();
							if (batchNo == null || batchNo.length <= 0) {
								Msg.info("warning", "批号不能为空!");
								var col = GetColIndex(DetailGrid,"BatchNo")
								DetailGrid.startEditing(cell[0], col);
								return;
							}
							var ExpReq = DetailStore.getAt(cell[0]).get('ExpReq');
							var col = ExpReq=='R'?GetColIndex(DetailGrid,"ExpDate"):GetColIndex(DetailGrid,"RecQty");
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
			editor : ExpDateEditor
		}, {
			header : "单位",
			dataIndex : 'IngrUomId',
			width : 80,
			align : 'left',
			sortable : true,
			renderer :Ext.util.Format.comboRenderer2(CTUom,"IngrUomId","IngrUom"),								
			editor : new Ext.grid.GridEditor(CTUom)
		}, {
			header : "数量",
			dataIndex : 'RecQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "进价",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true,
			editor : RpEditor
		}, {
			header : "售价",
			dataIndex : 'Sp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : "当前加成",
			dataIndex : 'Marginnow',
			width : 60,
			align : 'right',
			sortable : true	
		}, {
			header : "入库售价",
			dataIndex : 'NewSp',
			width : 60,
			align : 'right',
			sortable : true,
			editor : new Ext.ux.NumberField({
				formatType : 'FmtSP',
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cost = field.getValue();
							if (cost == null
									|| cost.length <= 0) {
								Msg.info("warning", "入库售价不能为空!");
								return;
							}
//							if (cost <= 0) {
//								Msg.info("warning",
//										"入库售价不能小于或等于0!");
//								return;
//							}
							// 计算指定行的售价金额
							var cell = DetailGrid.getSelectionModel().getSelectedCell();
							var record = DetailGrid.getStore().getAt(cell[0]);
							var NewSpAmt = accMul(record.get("RecQty"),cost);
							record.set("NewSpAmt",NewSpAmt);
							var ColIndex=GetColIndex(DetailGrid,'InvNo');
							DetailGrid.startEditing(cell[0], ColIndex);
						}
					}
				}
			})
		}, {
			header : "发票号",
			dataIndex : 'InvNo',
			width : 80,
			align : 'left',
			sortable : true,
			editor : InvNoEditor
		}, {
			header :"发票金额",
			dataIndex :'InvMoney',
			width :80,
			align :'right',
			editable : false,
			summaryType : 'sum',
			editor : new Ext.ux.NumberField({
				formatType : 'FmtRA',
				selectOnFocus : true,
				allowNegative : false
			})
		}, {
			header : "发票日期",
			dataIndex : 'InvDate',
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
							var invDate = field.getValue();
							if (invDate == null || invDate.length <= 0) {
								// Msg.info("warning", "发票日期不能为空!");
								return;
							}
							addNewRow();
						}
					}
				}
			})
		},{
			header : "质检单号",
			dataIndex : 'QualityNo',
			width : 90,
			align : 'left',
			sortable : true,
			editor : new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false
			})
		},{
			header : "随行单号",
			dataIndex : 'SxNo',
			width : 90,
			align : 'left',
			sortable : true,
			editor : new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false
			})
		}, {
			header : "进货金额",
			dataIndex : 'RpAmt',
			width : 100,
			align : 'right',
			sortable : true,
			summaryType : 'sum',
			editable:(gParam[6]=='Y'?true:false),
			editor:new Ext.ux.NumberField({
				formatType : 'FmtRA',
				selectOnFocus : true,
				allowNegative:false,
				allowBlank : false
			})
		}, {
			header : "入库售价金额",
			dataIndex : 'NewSpAmt',
			width : 100,
			align : 'right',
			
			sortable : true
		},{
			header : "定价类型",
			dataIndex : 'MtDesc',
			width : 180,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "招标轮次",
			dataIndex : 'PubDesc',
			width : 180,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "摘要",
			dataIndex : 'Remark',
			width : 90,
			align : 'left',
			sortable : true,
			editor : new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false
			})
		},{
			header : "备注",
			dataIndex : 'Remarks',
			width : 90,
			align : 'left',
			sortable : true,
			editor : new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false
			})
		},{
			header : "BUomId",
			dataIndex : 'BUomId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "ConFacPur",
			dataIndex : 'ConFacPur',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "MtDr",
			dataIndex : 'MtDr',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "MtDr2",
			dataIndex : 'MtDr2',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "灭菌批号",
			dataIndex : 'SterilizedNo',
			width : 90,
			align : 'left',
			sortable : true,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = DetailGrid.getSelectionModel()
									.getSelectedCell();
//							DetailGrid.startEditing(cell[0], 7);
						}
					}
				}
			}))
		}, {
			header : '订购数量',
			dataIndex : 'InPoQty',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "批号要求",
			dataIndex : 'BatchReq',
			width : 80,
			align : 'center',
			hidden : true
		},{
			header : "有效期要求",
			dataIndex : 'ExpReq',
			width : 80,
			align : 'center',
			hidden : true
		}, {
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
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var index=GetColIndex(DetailGrid,"AdmExpdate");
									DetailGrid.startEditing(cell[0], index);
//									if(setEnterSort(DetailGrid,colArr)){
//										addNewRow();
//									}
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
									var col = GetColIndex(DetailGrid,"InvNo");
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									DetailGrid.startEditing(cell[0], col);
//									if(setEnterSort(DetailGrid,colArr)){
//										addNewRow();
//									}
								}
							}
						}
					})
			},{
			header : "PoI",
			dataIndex : 'PoI',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "Vendor",
			dataIndex : 'Vendor',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}
		,{
			header : "供应商",
			dataIndex : 'VendorDesc',
			width : 100,
			align : 'left',
			sortable : true
		}
	]);

	var DetailGrid = new Ext.grid.EditorGridPanel({
		id : 'DetailGrid',
		title:'入库单明细',
		region : 'center',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm : new Ext.grid.CellSelectionModel({}),
		tbar:[AddBT,'-',{height:30,width:70,text:'列设置',iconCls:'page_gear',handler:function(){GridColSet(DetailGrid,"DHCSTIMPORTM");}}],
		clicksToEdit : 1,
		plugins : new Ext.grid.GridSummary(),
		listeners:{
			'beforeedit' : function(e){
				if(e.record.get("HVBarCode")!=""&&!e.record.dirty){
						e.cancel=true;
						return
					}
				if(e.field=="RecQty" || e.field=="IncDesc" || e.field=="IngrUomId"){
					if(e.record.get("HVBarCode")!="" && e.record.get("HVFlag")=="Y"){
						e.cancel=true;
					}
				}
				if(e.field=="ExpDate" && e.record.get('ExpReq')=='N'){
					e.cancel=true;
				}
				if(e.field=="BatchNo" && e.record.get('BatchReq')=='N'){
					e.cancel=true;
				}
			},
			'afteredit' : function(e){
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
				}else if(e.field=='BatchNo'){
					if(e.record.get('BatchReq')!='R'){
						return;
					}
					var BatchNo = e.value;
					if(BatchNo==null || BatchNo==""){
						Msg.info("warning","批号不可为空!");
						e.record.set('BatchNo',e.originalValue);
						return;
					}
				}else if(e.field=='Rp'){
					var cost = e.value;
					if (Ext.isEmpty(cost)) {
						Msg.info("warning", "进价不能为空!");
						e.record.set('Rp',e.originalValue);
						return;
					}else if (cost <= 0) {
						//Msg.info("warning", "进价不能小于或等于0!");
						//e.record.set('Rp',e.originalValue);
						//return;
					}
					//批次售价根据进价重新计算售价
					if(gParam[21]==1 || BatSpFlag==1){
						var IncId=e.record.get('IncId')
						var UomId=e.record.get('IngrUomId')
						var Rp=e.value
						var url='dhcstm.ingdrecaction.csp?actiontype=GetMtSp&IncId='+IncId+'&UomId='+UomId+'&Rp='+Rp;
						var responseText=ExecuteDBSynAccess(url);
						var jsonData=Ext.util.JSON.decode(responseText);
						if(jsonData.success=='true'){
							var MtSp=jsonData.info;
							e.record.set("Sp",MtSp);
						}
					}
					//验证加成率
					var sp = e.record.get("Sp");
					var margin=0
					if(cost!=0){
						margin = accDiv(sp, cost);
						if((gParam[5]!=0) && (margin>gParam[5] || margin<1)){
							Msg.info("warning",	"加成率超出限定范围!");
							e.record.set('Rp',e.originalValue);
							return false;
						}
					}
					// 计算指定行的进货金额
					var RealTotal = accMul(e.record.get("RecQty"), cost);
					e.record.set("RpAmt",RealTotal);
					e.record.set("InvMoney",RealTotal);
					e.record.set("Marginnow",margin.toFixed(3));
				}else if(e.field=='RecQty'){
					var RealTotal = accMul(e.record.get("Rp"), e.value);
					e.record.set("RpAmt",RealTotal);
					e.record.set("InvMoney",RealTotal);
				}else if(e.field=='InvNo'){
					var VenId = e.record.get("Vendor");
					var Ingr = '';
					if(!Ext.isEmpty(VenId)){
						var Grstore = GrMasterInfoGrid.getStore();
						var Grindex = Grstore.findExact("Vendor",VenId);
						if(Grindex != -1){
							var GrrowData = Grstore.getAt(Grindex);
							Ingr = GrrowData.get("Ingr");
						}
					}
					var flag=InvNoValidator(e.value, Ingr);
					if(flag==false){
						Msg.info("warning","该发票号已存在于别的入库单");
						e.record.set('InvNo',e.originalValue);
					}
				}
			}
		}
	});

	
	/**
	 * 调用物资窗体并返回结果
	 */
	function GetPhaOrderInfo(item, group) {					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", gHospId,
					getDrugList);
		}
	}
	
	//根据条码获取物资信息
	function GetPhaOrderInfo2(item, group) {
		if (item != null && item.length > 0) {
			GetPhaOrderByBarcodeWindow(item, group, App_StkTypeCode, "", "N", "0", gHospId,
					getDrugList);
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
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		var HVFlag=record.get("HVFlag");
		var PoI=record.get("PoI");
		var BatchNo=record.get("BatchNo");
		var ExpDate=record.get("ExpDate");
		var certNo=record.get("CertNo");
		var certExpDate=record.get("CertExpDate");
		// 选中行
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var rowCount=DetailStore.getCount();
		for (var i = 0; i < rowCount; i++) {
			changeBgColor(i, "white");
		}
		var rowData = DetailGrid.getStore().getAt(row);
		rowData.set("IncId",inciDr);
		rowData.set("IncCode",inciCode);
		rowData.set("IncDesc",inciDesc);
		rowData.set("BatchNo",BatchNo);

		rowData.set("ExpDate",toDate(ExpDate));
		rowData.set("PoI",PoI);
		rowData.set("AdmNo",certNo);
		rowData.set("AdmExpdate",toDate(certExpDate));
		var LocId=Ext.getCmp("PhaLoc").getValue();
		var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;
		//取其它物资信息
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=GetItmInfo&IncId="
			+ inciDr+"&Params="+Params;
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '查询中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					var data=jsonData.info.split("^");
					addComboData(PhManufacturerStore,data[0],data[1]);
					var BatchReq = data[15],ExpReq = data[16];
					rowData.set("ManfId", data[0]);
					//alert("jsonData.info="+jsonData.info)
					addComboData(ItmUomStore,data[2],data[3]);
					rowData.set("IngrUomId", data[2]);
					rowData.set("Rp", Number(data[4]));
					rowData.set("Sp", Number(data[5]));
					var margin=0
					if(Number(data[4])!=0){
					 margin = accDiv(Number(data[5]), Number(data[4]));
					}
					rowData.set("Marginnow",margin.toFixed(3));
					rowData.set("NewSp", Number(data[5]));
					//rowData.set("BatchNo", data[6]);
					//rowData.set("ExpDate", toDate(data[7]));
					rowData.set("MtDesc", data[8]);
					rowData.set("PubDesc", data[9]);
					rowData.set("BUomId", data[10]);
					rowData.set("ConFacPur", data[11]);
					rowData.set("MtDr", data[12]);
					rowData.set("HVFlag",data[14]);
					rowData.set("BatchReq",BatchReq);
					rowData.set("ExpReq",ExpReq);
					rowData.set("Spec",data[17]);
					rowData.set("Vendor",data[20]);
					rowData.set("VendorDesc",data[21]);
					//对比最高售价
					if(gParam[9]=="Y" & data[13]!=""){
						if(Number(data[5])>Number(data[13])){
							Msg.info("error","当前售价高于最高售价!");
						}
					}
					
					rowData.set('RecQty',1);
					rowData.set("RpAmt",Number(data[4]));
					rowData.set("InvMoney",Number(data[4]));
					rowData.set("NewSpAmt",Number(data[5]));
					var colDataIndex = BatchReq=='R'?'BatchNo':ExpReq=='R'?'ExpDate':'Rp';
					var colIndex=GetColIndex(DetailGrid,"confirm");
					DetailGrid.startEditing(row, colIndex);
				} 
			},
			scope : this
		});		
	}

	/**
	 * 单位展开事件
	 */
	CTUom.on('expand', function(combo) {
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var record = DetailGrid.getStore().getAt(cell[0]);
		var InciDr = record.get("IncId");
		ItmUomStore.removeAll();
		ItmUomStore.load({params:{ItmRowid:InciDr}});
	});

	/**
	 * 单位变换事件
	 */
	CTUom.on('select', function(combo) {
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var record = DetailGrid.getStore().getAt(cell[0]);
		
		var value = combo.getValue();        //目前选择的单位id
		var BUom = record.get("BUomId");
		var ConFac = record.get("ConFacPur");   //大单位到小单位的转换关系
		var IngrUom = record.get("IngrUomId");    //目前显示的入库单位
		var Sp = Number(record.get("Sp"));
		var Rp = Number(record.get("Rp"));
		var NewSp = Number(record.get("NewSp"));
		
		if (value == null || value.length <= 0) {
			return;
		} else if (IngrUom == value) {
			return;
		} else if (value==BUom) {     //新选择的单位为基本单位，原显示的单位为大单位
			record.set("Sp", Sp.div(ConFac));
			record.set("NewSp", NewSp.div(ConFac));
			record.set("Rp", Rp.div(ConFac));
		} else{  //新选择的单位为大单位，原先是单位为小单位
			record.set("Sp", Sp.mul(ConFac));
			record.set("NewSp", NewSp.mul(ConFac));
			record.set("Rp", Rp.mul(ConFac));
		}
		var RpAmt=Number(record.get("Rp")).mul(record.get("RecQty"));
		var SpAmt=Number(record.get("Sp")).mul(record.get("RecQty"));
		var NewSpAmt=Number(record.get("NewSp")).mul(record.get("RecQty"));
		record.set("RpAmt",RpAmt);
		record.set("InvMoney",RpAmt);
		record.set("SpAmt",SpAmt);
		record.set("NewSpAmt",NewSpAmt);
		record.set("IngrUomId", combo.getValue());
	});
	
	// 变换行颜色
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}
	// 访问路径
var MasterInfoUrl = DictUrl	+ 'ingdrecaction.csp?actiontype=Query';
// 通过AJAX方式调用后台数据
var proxy = new Ext.data.HttpProxy({
			url : MasterInfoUrl,
			method : "POST"
		});

// 指定列参数
var fields = ["Ingr","IngrNo","Vendor","VendorDesc","CreateUser", "Complete"];
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			fields : fields
		});
// 数据集
var GrMasterInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader
		});
var nm = new Ext.grid.RowNumberer();
var GrMasterInfoCm = new Ext.grid.ColumnModel([nm, {
			header : "RowId",
			dataIndex : 'Ingr',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "入库单号",
			dataIndex : 'IngrNo',
			width : 160,
			align : 'left',
			sortable : true
		},{
			header : "供应商rowid",
			dataIndex : 'Vendor',
			width : 250,
			align : 'left',
			hidden : true,
			sortable : true
		}, {
			header : "供应商",
			dataIndex : 'VendorDesc',
			width : 250,
			align : 'left',
			sortable : true
		},{
			header : "完成标志",
			dataIndex : 'Complete',
			width : 70,
			align : 'left',
			sortable : true
		}]);
var GrMasterInfoGrid = new Ext.grid.GridPanel({
			id : 'GrMasterInfoGrid',
			region : 'center',
			title : '入库单',
			cm : GrMasterInfoCm,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			store : GrMasterInfoStore,
			trackMouseOver : true,
			stripeRows : true
			
		});

	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		region : 'west',
		width : 750,
		labelAlign : 'right',
		title:'入库单制单(高值方式二)',
		frame : true,
		autoScroll : false,
		tbar : [ClearBT, '-',CompleteBT,'-',PrintBT,'-',PrintHVCol],
		items:[{
			xtype:'fieldset',
			title:'入库信息',
			style:'padding:1px 0px 0px 10px',
			layout: 'column',    // Specifies that the items will now be arranged in columns
			defaults: {border:false},
			items : [{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [PhaLoc,PurchaseUser,SourceOfFund]
			},{
				columnWidth:0.15,
				labelWidth : 10,
				items:[VirtualFlag]
			},{
				columnWidth: 0.3,
				xtype: 'fieldset',
				labelWidth: 60,
				defaultType: 'textfield',
				autoHeight: true,
				items: [OperateInType,InGrRemarks]
			},{
				columnWidth: 0.25,
				xtype: 'fieldset',
				labelWidth: 60,
				defaultType: 'textfield',
				autoHeight: true,
				items: [PresentFlag,ExchangeFlag]
			}]
		}]
	});
    var panel=new Ext.Panel({
    	region : 'north',
    	layout : 'border',
    	height:200,
		items : [HisListTab, GrMasterInfoGrid]
    })
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [panel, DetailGrid]
	});
			
	RefreshGridColSet(DetailGrid,"DHCSTIMPORTM");   //根据自定义列设置重新配置列
})