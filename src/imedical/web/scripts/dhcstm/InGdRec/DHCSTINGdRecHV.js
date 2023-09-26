// /名称: 入库单制单
// /描述: 入库单制单
// /编写者：zhangdongmei
// /编写日期: 2012.06.27

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gHospId=session['LOGON.HOSPID'];
	//alert(gIngrRowid);
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var colArr=[];
	var loadMask=null;
	if(gParam.length<1){
		GetParam();  //初始化参数配置
	}

	//取高值管理参数
	var UseItmTrack="";
	if(gItmTrackParam.length<1){
		GetItmTrackParam();
		UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
	}
	
	var isBarcodeEdit=true,isIncdescEdit=true;
	if(!UseItmTrack){
		if(gHVINGdRec){
			isIncdescEdit=false;
			Msg.info("warning","此菜单不使用!");
		}else{
			isBarcodeEdit=false;
		}
	}else{
		if(gHVINGdRec){	//高值菜单
			isIncdescEdit=false;
		}else{			//非高值菜单
			isBarcodeEdit=false;
		}
	}
	
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '入库部门',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor:'90%',
		emptyText : '入库部门...',
		groupId:gGroupId,
		stkGrpId : "StkGrpType",
		childCombo : 'Vendor'
	});
	
	var VirtualFlag = new Ext.form.Checkbox({
		boxLabel : G_VIRTUAL_STORE,
		hideLabel :true,
		id : 'VirtualFlag',
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
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor:'90%',
		params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'},
		listeners : {
			select : function(){
				if(DetailGrid.getStore().getCount() == 0){
					AddBT.handler();
				}
			}
		}
	});

	// 物资类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:gLocId,
		UserId:gUserId,
		anchor:'90%'
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

	// 入库单号
	var InGrNo = new Ext.form.TextField({
		fieldLabel : '入库单号',
		id : 'InGrNo',
		name : 'InGrNo',
		anchor : '90%',
		disabled : true
	});
	
	// 入库日期
	var InGrDate = new Ext.ux.DateField({
		fieldLabel : '入库日期',
		id : 'InGrDate',
		name : 'InGrDate',
		anchor : '90%',
		value : new Date(),
		disabled : true
	});
	// 请求部门
	var RequestLoc = new Ext.ux.LocComboBox({
				fieldLabel : '接收科室',
				id : 'RequestLoc',
				name : 'RequestLoc',
				anchor:'90%',
				width : 120,
				emptyText : '接收科室...',
				defaultLoc:{}
	});
	// 采购人员
	var PurchaseUser = new Ext.ux.ComboBox({
		fieldLabel : '采购人员',
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
			
	// 完成标志
	var CompleteFlag = new Ext.form.Checkbox({
		boxLabel : '完成',
		id : 'CompleteFlag',
		name : 'CompleteFlag',
		anchor : '90%',
		checked : false,
		disabled:true
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
		anchor : '100%',
		checked : false,
		boxLabel:'调价换票'
	});

	var SourceOfFund = new Ext.ux.ComboBox({
		fieldLabel : '资金来源',
		id : 'SourceOfFund',
		anchor : '90%',
		store : SourceOfFundStore
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
			PrintRec(gIngrRowid);
		}
	});
	
	// 打印入库单按钮
	var PrintHVCol = new Ext.Toolbar.Button({
		id : "PrintHVCol",
		text : '高值汇总打印',
		tooltip : '打印高值入库单票据',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			PrintRecHVCol(gIngrRowid);
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
			if (isDataChanged(HisListTab,DetailGrid)){
				Ext.Msg.show({
					title:'提示',
					msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
					buttons: Ext.Msg.YESNO,
					fn: function(btn){
						if (btn=='yes') {
							clearData();
							SetFormOriginal(HisListTab);
						}
					}
				})
			}else{
				clearData(); 
				SetFormOriginal(HisListTab);
			}
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
			// 判断入库单是否已完成
			var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
			if (CompleteFlag != null && CompleteFlag != 0) {
				Msg.info("warning", "入库单已完成!");
				return;
			}		
			if (gIngrRowid == null || gIngrRowid=="") {
				Msg.info("warning", "没有需要完成的入库单!");
				return;
			}
			var rowData = DetailStore.getAt(0);
			if(rowData==""||rowData==undefined){
				Msg.info("warning","没有需要完成的数据明细!");
				return;
			}
			
			//预算结余判断
			var HRPBudgResult = HRPBudg();
			if(HRPBudgResult === false){
				return;
			}
			
			var mainData=GetIngrMainData(gIngrRowid);
			var mainArr=mainData.split("^");
			var phaLocDesc=mainArr[11];
			if(gHVINGdRec){
				Ext.Msg.show({
					title:'提示',
					msg: '当前入库科室为"'+phaLocDesc+'", 是否继续？',
					buttons: Ext.Msg.YESNO,
					fn: function(b,t,o){
						if (b=='yes'){
							Complete();
						}
					},
					icon: Ext.MessageBox.QUESTION
				});
			}else{
				Complete();
			}
		}
	});

	// 取消完成按钮
	var CancleCompleteBT = new Ext.Toolbar.Button({
		id : "CancleCompleteBT",
		text : '取消完成',
		tooltip : '点击取消完成',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
			CancleComplete();
		}
	});
	// 删除按钮
	var DeleteBT = new Ext.Toolbar.Button({
		id : "DeleteBT",
		text : '删除',
		tooltip : '点击删除',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function() {
			deleteData();
		}
	});

			
	/**
	 * 清空方法
	 */
	function clearData() {
		gIngrRowid="";
		// Ext.getCmp("PhaLoc").setValue("");
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("StkGrpType").setValue("");
		Ext.getCmp("StkGrpType").getStore().load();
		Ext.getCmp("InGrNo").setValue("");
		Ext.getCmp("InGrDate").setValue(new Date());
		Ext.getCmp("PurchaseUser").setValue("");
		Ext.getCmp("CompleteFlag").setValue(false);
		Ext.getCmp("PresentFlag").setValue(false);
		Ext.getCmp("ExchangeFlag").setValue(false);
		Ext.getCmp("InGrRemarks").setValue("");
		Ext.getCmp("VirtualFlag").setValue(false);
		Ext.getCmp("SourceOfFund").setValue("");
		SetLogInDept(PhaLoc.getStore(),"PhaLoc");
		Ext.getCmp("RequestLoc").setValue("");
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		
		//查询^清除^新增^保存^删除^完成^取消完成
		changeButtonEnable("1^1^1^0^0^0^0");
		SetFieldDisabled(false);
		//清除可能存在href变量
		CheckLocationHref();
	}
	
	var DeleteDetailBT=new Ext.Toolbar.Button({
		id:'DeleteDetailBT',
		text:'删除一条',
		tooltip:'点击删除',
		width:70,
		height:30,
		iconCls:'page_delete',
		handler:function(){
			deleteDetail();
		}
	});
	// 增加按钮
	var AddBT = new Ext.Toolbar.Button({
		id : "AddBT",
		text : '增加一条',
		tooltip : '点击增加',
		width : 70,
		height : 30,
		iconCls : 'page_add',
		handler : function() {
			// 判断入库单是否已审批
			var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
			if (CmpFlag != null && CmpFlag != 0) {
				Msg.info("warning", "入库单已完成不可修改!");
				return;
			}
			// 判断是否选择入库部门和供货厂商
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "请选择入库部门!");
				return;
			}
			var vendor = Ext.getCmp("Vendor").getValue();
			if (vendor == null || vendor.length <= 0) {
				Msg.info("warning", "请选择供应商!");
				return;
			}
			if (Ext.getCmp('StkGrpType').getValue()==''){
				Msg.info("warning","请选择类组!");
				return;
			}
			var operateInType = Ext.getCmp("OperateInType")
					.getValue();
			if ((gParam[8]=="Y")&(operateInType == null || operateInType.length <= 0)) {
				Msg.info("warning", "请选择入库类型!");
				return;
			}
			colArr=sortColoumByEnterSort(DetailGrid); //将回车的调整顺序初始化好
			// 新增一行
			addNewRow();
			// 变更按钮是否可用
			//查询^清除^新增^保存^删除^完成^取消完成
			changeButtonEnable("0^1^1^1^1^1^0");
			SetFieldDisabled(true);
		}
	});
	
	function SetFieldDisabled(bool){
		Ext.getCmp("Vendor").setDisabled(bool);
		Ext.getCmp("StkGrpType").setDisabled(bool);
	}
	
	/**
	 * 新增一行
	 */
	function addNewRow() {
		var inciIndex=GetColIndex(DetailGrid,"IncDesc");
		var barcodeIndex=GetColIndex(DetailGrid,"HVBarCode");
		var col=gHVINGdRec?barcodeIndex:inciIndex;
		if(colArr && colArr[0]){
			col = GetColIndex(DetailGrid, colArr[0].dataIndex);
		}
		var lastInvNo="";
		// 判断是否已经有添加行
		var rowCount = DetailGrid.getStore().getCount();
		if (rowCount > 0) {
			var rowData = DetailStore.data.items[rowCount - 1];
			var data = rowData.get("IncId");
			if (data == null || data.length <= 0) {
				DetailGrid.startEditing(DetailStore.getCount() - 1, col);
				return;
			}
			if(gParam[14]=='Y'){
				lastInvNo=rowData.get('InvNo');
			}
		}
		var defaData = {InvNo : lastInvNo};
		var NewRecord = CreateRecordInstance(DetailStore.fields,defaData);
		DetailStore.add(NewRecord);
		DetailGrid.startEditing(DetailStore.getCount() - 1, col);
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
			loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			if(CheckDataBeforeSave()==true){
				// 保存入库单
				saveOrder();
			}else{
				loadMask.hide();
			}
		}
	});

	/**
	 * 保存入库单前数据检查
	 */		
	function CheckDataBeforeSave() {
		var nowdate = new Date();
		// 判断入库单是否已审批
		var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
		if (CmpFlag != null && CmpFlag != 0) {
			Msg.info("warning", "入库单已完成不可修改!");
			return false;
		}
		// 判断入库部门和供货商是否为空
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "请选择入库部门!");
			return false;
		}
		var vendor = Ext.getCmp("Vendor").getValue();
		if (vendor == null || vendor.length <= 0) {
			Msg.info("warning", "请选择供应商!");
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
//			// 3.判断重复输入物资
//			for (var i = 0; i < rowCount - 1; i++) {
//				for (var j = i + 1; j < rowCount; j++) {
//					var item_i = DetailStore.getAt(i).get("IncId");
//					var HVFlag = DetailStore.getAt(i).get("HVFlag");
//					var item_j = DetailStore.getAt(j).get("IncId");
//					//对于高值材料, 专门管理(UseItmTrak==true)时不判断是否重复, 通过录入条码时判断条码是否重复
//					if(!(UseItmTrack && HVFlag=='Y')){
//						if (item_i != "" && item_j != ""
//								&& item_i == item_j) {
//							DetailGrid.getSelectionModel().select(i, 1);
//							changeBgColor(i, "yellow");
//							changeBgColor(j, "yellow");
//							Msg.info("warning", "物资重复，请重新输入!");
//							return false;
//						}
//					}
//				}
//			}
		// 4.物资信息输入错误
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);
			var expDateValue = rowData.get("ExpDate");
			var item = rowData.get("IncId");
			if(item==null || item==""){
				break;
			}
			var ExpReq = rowData.get('ExpReq');
			if(ExpReq=='R'){
				var ExpDate = new Date(Date.parse(expDateValue));
				if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
					Msg.info("warning", "有效期不能小于或等于当前日期!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			var BatchNo = rowData.get('BatchNo');
			var BatchReq = rowData.get('BatchReq');
			if(BatchReq=='R'){
				if ((item != "") && (BatchNo=="")) {
					Msg.info("warning", "批号不可为空!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			var qty = rowData.get("RecQty");
			if ((item != "") && (qty == null || qty <= 0)) {
				Msg.info("warning", "入库数量不能小于或等于0!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			var inpoqty=rowData.get("InPoQty");
			if((gParam[13]=="N"||gParam[13]=="")&&(qty>inpoqty)&&(inpoqty!="")){
				Msg.info("warning", "入库数量不能大于订购数量!");
				var cell = DetailGrid.getSelectionModel()
					.getSelectedCell();
				DetailGrid.getSelectionModel().select(cell[0], 1);
				changeBgColor(i, "yellow");
				return false;
			}
			
			var realPrice = rowData.get("Rp");
			if ((item != "")&& (realPrice == null || realPrice <= 0)) {
				Msg.info("warning", "入库进价不能小于或等于0!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			var Sp = rowData.get("Sp");
			if (Sp<=0){
				Msg.info("warning","第"+(i+1)+"行售价不能为小于或等于0");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
		}
		
		return true;
	}
	
	/**
	 * 保存入库单
	 */
	function saveOrder() {
		var IngrNo = Ext.getCmp("InGrNo").getValue();
		var VenId = Ext.getCmp("Vendor").getValue();
		var Completed = (Ext.getCmp("CompleteFlag").getValue()==true?'Y':'N');
		var LocId = Ext.getCmp("PhaLoc").getValue();
		var CreateUser = gUserId;
		var ExchangeFlag =(Ext.getCmp("ExchangeFlag").getValue()==true?'Y':'N');
		var PresentFlag = (Ext.getCmp("PresentFlag").getValue()==true?'Y':'N');
		var IngrTypeId = Ext.getCmp("OperateInType").getValue();
		var PurUserId = Ext.getCmp("PurchaseUser").getValue();
		var StkGrpId = Ext.getCmp("StkGrpType").getValue();
		var InGrRemarks = Ext.getCmp("InGrRemarks").getValue();
		InGrRemarks=InGrRemarks.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
		var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();	
		var RequestLoc = Ext.getCmp("RequestLoc").getValue();
		var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^"
				+ ExchangeFlag + "^" + IngrTypeId + "^" + PurUserId + "^"+StkGrpId+"^"+""+"^"+InGrRemarks+"^"+SourceOfFund+"^"+RequestLoc;
		
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);
			//新增或数据发生变化时执行下述操作
			if(rowData.data.newRecord || rowData.dirty){	
				var Ingri=rowData.get("Ingri");
				var IncId = rowData.get("IncId");
				if(IncId==null || IncId==""){continue;}
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
				var reqLoc = rowData.get("reqLocId");
				var str = Ingri + "^" + IncId + "^"	+ BatchNo + "^" + ExpDate + "^" + ManfId
						+ "^" + IngrUomId + "^" + RecQty+ "^" + Rp + "^" + NewSp + "^" + SxNo
						+ "^" + InvNo + "^" + InvDate+ "^" +PoI+"^"+Remark+ "^" +Remarks
						+ "^" + QualityNo+"^"+MtDr+"^"+BarCode+"^"+SterilizedNo+"^"+AdmNo
						+ "^" + AdmExpDate + "^^^^" + reqLoc
						+ "^" + Sp;
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+RowDelim+str;
				}
			}
		}
		if(!IsFormChanged(HisListTab) && ListDetail==""){
			Msg.info("error", "没有内容需要保存!");
			loadMask.hide();
			return false;
		}
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=Save";
		//var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{Ingr:gIngrRowid,MainInfo:MainInfo,ListDetail:ListDetail},
			waitMsg : '处理中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					// 刷新界面
					var IngrRowid = jsonData.info;
					Msg.info("success", "保存成功!");
					DetailStore.commitChanges();
					// 7.显示入库单数据
					gIngrRowid=IngrRowid;
					Query(IngrRowid);
					if(gParam[3]=='Y'){
						PrintRec(IngrRowid, 'Y');
					}
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
					loadMask.hide();
				}
			},
			scope : this
		});
	}
	// 显示入库单数据
	function Query(IngrRowid) {
		if (IngrRowid == null || IngrRowid.length <= 0 || IngrRowid <= 0) {
			return;
		}
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=Select&IngrRowid="
			+ IngrRowid;
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '查询中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					var list = jsonData.info.split("^")
					if (list.length > 0) {
						gIngrRowid=IngrRowid;
						Ext.getCmp("InGrNo").setValue(list[0]);
						addComboData(Ext.getCmp("Vendor").getStore(),list[1],list[2]);
						Ext.getCmp("Vendor").setValue(list[1]);
						
						var VirtualFlag = tkMakeServerCall('web.DHCSTM.Common.UtilCommon','GetMainLocInfo',list[10]);
						//暂存库勾选要在科室combo赋值之前
						Ext.getCmp('VirtualFlag').setValue(VirtualFlag != '');
						
						addComboData(Ext.getCmp("PhaLoc").getStore(),list[10],list[11]);
						Ext.getCmp("PhaLoc").setValue(list[10]);
						addComboData(OperateInTypeStore,list[17],list[18]);
						Ext.getCmp("OperateInType").setValue(list[17]);
						addComboData(Ext.getCmp("PurchaseUser").getStore(),list[19],list[20]);
						Ext.getCmp("PurchaseUser").setValue(list[19]);
						Ext.getCmp("InGrDate").setValue(list[12]);
						Ext.getCmp("CompleteFlag").setValue(list[9]=='Y'?true:false);
						Ext.getCmp("PresentFlag").setValue(list[30]=='Y'?true:false);
						Ext.getCmp("ExchangeFlag").setValue(list[31]=='Y'?true:false);
						addComboData(null,list[27],list[28],StkGrpType);
						Ext.getCmp("StkGrpType").setValue(list[27]);
						var InGrRemarks=handleMemo(list[32],xMemoDelim());
						Ext.getCmp("InGrRemarks").setValue(InGrRemarks);
						addComboData(SourceOfFundStore,list[33],list[34]);
						Ext.getCmp("SourceOfFund").setValue(list[33]);
						addComboData(Ext.getCmp("RequestLoc").getStore(),list[21],list[22]);
						Ext.getCmp("RequestLoc").setValue(list[21]);
						// 显示入库单明细数据
						getDetail(IngrRowid);
						SetFieldDisabled(true);
					}
					SetFormOriginal(HisListTab);
				} else {
					if(loadMask){loadMask.hide();}
					Msg.info("warning", jsonData.info);
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
		"QualityNo","SxNo","Remark","Remarks","MtDesc","PubDesc","BUomId","ConFacPur","MtDr","HVFlag","HVBarCode","Spec","SterilizedNo","InPoQty","BatchReq","ExpReq","BarCode","AdmNo",{name:'AdmExpdate',type:'date',dateFormat:DateFormat},
		"dhcit","reqLocId","reqLocDesc"];
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
	// 显示入库单明细数据
	function getDetail(IngrRowid) {
		if (IngrRowid == null || IngrRowid.length <= 0 || IngrRowid <= 0) {
			return;
		}
		DetailStore.load({
			params:{start:0,limit:999,Parref:IngrRowid},
			callback:function(r,success,options){
				if(loadMask){loadMask.hide();}
			}
		});
		// 变更按钮是否可用
		//查询^清除^新增^保存^删除^完成^取消完成
		var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
		if(inGrFlag==true){
			changeButtonEnable("1^1^0^0^0^0^1");
		}else{
			changeButtonEnable("1^1^1^1^1^1^0");
		}
		
	}
	
	// 变更按钮是否可用
	function changeButtonEnable(str) {
		var list = str.split("^");
		for (var i = 0; i < list.length; i++) {
			if (list[i] == "1") {
				list[i] = false;
			} else {
				list[i] = true;
			}
		}
		//查询^清除^新增^保存^删除^完成^取消完成
		SearchInGrBT.setDisabled(list[0]);
		ClearBT.setDisabled(list[1]);
		AddBT.setDisabled(list[2]);
		SaveBT.setDisabled(list[3]);
		DeleteBT.setDisabled(list[4]);
		CompleteBT.setDisabled(list[5]);
		CancleCompleteBT.setDisabled(list[6]);
	}
	
	function deleteData() {
		// 判断入库单是否已审批
		var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
		if (inGrFlag != null && inGrFlag != 0) {
			Msg.info("warning", "入库单已完成不可删除!");
			return;
		}
		if (gIngrRowid == "") {
			Msg.info("warning", "没有需要删除的入库单!");
			return;
		}

		Ext.MessageBox.show({
			title : '提示',
			msg : '是否确定删除整张入库单?',
			buttons : Ext.MessageBox.YESNO,
			fn : showDeleteGr,
			icon : Ext.MessageBox.QUESTION
		});
	}

	/**
	 * 删除入库单提示
	 */
	function showDeleteGr(btn) {
		if (btn == "yes") {
			var url = DictUrl
				+ "ingdrecaction.csp?actiontype=Delete&IngrRowid="
				+ gIngrRowid;

			Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						// 删除单据
						Msg.info("success", "入库单删除成功!");
						clearData();
					} else {
						var ret=jsonData.info;
						if(ret==-1){
							Msg.info("error", "入库单已经完成，不能删除!");
						}else if(ret==-2){
							Msg.info("error", "入库单已经审核，不能删除!");
						}else if(ret==-3){
							Msg.info("error", "入库单部分明细已经审核，不能删除!");
						}else{
							Msg.info("error", "删除失败,请查看错误日志!");
						}
					}
				},
				scope : this
			});
		}
	}

	/**
	 * 删除选中行物资
	 */
	function deleteDetail() {
		// 判断入库单是否已完成
		var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
		if (CmpFlag != null && CmpFlag != false) {
			Msg.info("warning", "入库单已完成不能删除!");
			return;
		}
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "没有选中行!");
			return;
		}
		// 选中行
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);
		var Ingri = record.get("Ingri");
		if (Ingri == "" ) {
			DetailGrid.getStore().remove(record);
			DetailGrid.getView().refresh();
		} else {
			Ext.MessageBox.show({
				title : '提示',
				msg : '是否确定删除该物资信息?',
				buttons : Ext.MessageBox.YESNO,
				fn : showResult,
				icon : Ext.MessageBox.QUESTION
			});
		}
	}
	/**
	 * 删除提示
	 */
	function showResult(btn) {
		if (btn == "yes") {
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var row = cell[0];
			var record = DetailGrid.getStore().getAt(row);
			var Ingri = record.get("Ingri");

			// 删除该行数据
			var url = DictUrl
				+ "ingdrecaction.csp?actiontype=DeleteDetail&Rowid="
				+ Ingri;

			Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "删除成功!");
						DetailGrid.getStore().remove(record);
						DetailGrid.getView().refresh();
					} else {
						var ret=jsonData.info;
						if(ret==-1){
							Msg.info("error", "入库单已经完成，不能删除!");
						}else if(ret==-2){
							Msg.info("error", "入库单已经审核，不能删除!");
						}else if(ret==-4){
							Msg.info("error", "该明细数据已经审核，不能删除!");
						}else{
							Msg.info("error", "删除失败,请查看错误日志!");
						}
					}
				},
				scope : this
			});
		}
	}

	/**
	 * 完成入库单
	 */
	function Complete() {
		// 判断入库单是否已完成
		var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
		if (CompleteFlag != null && CompleteFlag != 0) {
			Msg.info("warning", "入库单已完成!");
			return;
		}
		var InGrNo = Ext.getCmp("InGrNo").getValue();
		if (InGrNo == null || InGrNo.length <= 0) {
			Msg.info("warning", "没有需要完成的入库单!");
			return;
		}
		//===========================
		var rowData = DetailStore.getAt(0);
		if(rowData==""||rowData==undefined){
			Msg.info("warning","没有需要完成的数据明细!");
			return;
		}
		var Count = DetailGrid.getStore().getCount();
		for (var i = 0; i < Count; i++) {
			var rowData = DetailStore.getAt(i);
			var Sp = Number(rowData.get("Sp"));
			if(Sp==0){
				Msg.info("warning","第"+(i+1)+"行售价不能为0!");
				return;
			}
		}
		
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=MakeComplete";
		Ext.Ajax.request({
			url : url,
			params : {Rowid:gIngrRowid,User:gUserId,GroupId:gGroupId},
			method : 'POST',
			waitMsg : '查询中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					// 审核单据
					Msg.info("success", "成功!");
					// 显示入库单数据
					Query(gIngrRowid);
					//查询^清除^新增^保存^删除^完成^取消完成
					changeButtonEnable("1^1^0^0^0^0^1");
					var AuditAfterComp=gParam[12];	//完成后自动审核参数
					var PrintAfterAudit=gParam[4];	//审核后自动打印参数
					if(AuditAfterComp=='Y' && PrintAfterAudit=='Y'){
						PrintRec(gIngrRowid, 'Y');
					}
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

	/**
	 * 取消完成入库单
	 */
	function CancleComplete() {
		
		var InGrNo = Ext.getCmp("InGrNo").getValue();
		if (InGrNo == null || InGrNo.length <= 0) {
			Msg.info("warning", "没有需要取消完成的入库单!");
			return;
		}
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=CancleComplete&Rowid="
				+ gIngrRowid + "&User=" + gUserId;
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '查询中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					// 审核单据
					Msg.info("success", "取消成功!");
					// 显示入库单数据
					Query(gIngrRowid);
					//查询^清除^新增^保存^删除^完成^取消完成
					changeButtonEnable("1^1^1^1^1^1^0");
				} else {
					var Ret=jsonData.info;
					if(Ret==-1){
						Msg.info("error", "入库单Id为空或入库单不存在!");
					}else if(Ret==-2){
						Msg.info("error", "入库单尚未完成!");
					}else if(Ret==-4){
						Msg.info("error", "入库单已经审核!");
					}else{
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
		params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'},
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if(setEnterSort(DetailGrid,colArr)){
						addNewRow();
					}
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
					if(setEnterSort(DetailGrid,colArr)){
						addNewRow();
					}
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
					if(setEnterSort(DetailGrid,colArr)){
						addNewRow();
					}
				}
			}
		}
	});

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
	var reqLoc = new Ext.ux.LocComboBox({
				fieldLabel : '接收科室',
				id : 'reqLoc',
				name : 'reqLoc',
				anchor:'90%',
				width : 120
	});
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
			sortable : true,
			editable : isIncdescEdit,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							// 判断入库单是否已完成																		
							var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
							if (CompleteFlag != null && CompleteFlag != false) {
								Msg.info("warning", "入库单已完成!");
								return;
							}
							var group = Ext
									.getCmp("StkGrpType")
									.getValue();
							GetPhaOrderInfo(field.getValue(),
									group);
						}
						
					}
				}
			}))
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
			hidden : !isBarcodeEdit,
			editable : isBarcodeEdit,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (field.getValue()!="" && e.getKey() == Ext.EventObject.ENTER){
							var Barcode=field.getValue();
							var row=DetailGrid.getSelectionModel().getSelectedCell()[0];
							var RowRecord = DetailGrid.store.getAt(row);
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
										var poi=itmArr[15],batchno=itmArr[16],expdate=itmArr[17];
										var certNo=itmArr[22];
										var certExpDate=itmArr[23],bRp=itmArr[25];
										var dhcit=itmArr[26];
										var dhcitlocid=itmArr[27];
										var StkGrpType=Ext.getCmp("StkGrpType").getValue();
										if(!CheckScgRelation(StkGrpType, scgID)){
											Msg.info("warning","条码"+Barcode+"属于"+scgDesc+"类组,与当前不符!");
											RowRecord.set("HVBarCode","");
											return;
										}else if((type!="Reg" && type!="G")||(type=="G" && lastDetailAudit=="Y")){
											Msg.info("warning","该条码已办理入库!");
											RowRecord.set("HVBarCode","");
											return;
										}else if(type=="G" && lastDetailAudit!="Y"){
											Msg.info("warning","有未完成或未审核的"+lastDetailOperNo);
											RowRecord.set("HVBarCode","");
											return;
										}else if(!Ext.isEmpty(dhcitlocid) && gLocId!=dhcitlocid){
											Msg.info("warning","此条码非本科室!!");
											return
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
											},{
												name : 'CertNo',
												type : 'string'
											},{	
												name : 'CertExpDate',
												type : 'string'
											},{	
												name : 'Rp',
												type : 'string'
											},{	
												name : 'dhcit',
												type : 'string'
											}]);
										var InciRecord = new record({
											InciDr : inciDr,
											InciCode : inciCode,
											InciDesc : inciDesc,
											PoI:poi,
											BatchNo:batchno,
											ExpDate:expdate,
											HVFlag : 'Y',
											CertNo:certNo,
											CertExpDate:certExpDate,
											Rp : bRp,
											dhcit : dhcit
										});
										getDrugList(InciRecord, RowRecord);
									}else{
										Msg.info("error","该条码尚未注册!");
										RowRecord.set("HVBarCode","");
										return;
									}
								}
							});
						}
					}
				}
			}))
		}, {
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
							if(setEnterSort(DetailGrid,colArr)){
								addNewRow();
							}
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
			sortable : true,
			editor : new Ext.form.NumberField({
				selectOnFocus : true,
				allowBlank : false,
				allowNegative : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							// 判断入库单是否已完成																		
							var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
							if (CompleteFlag != null && CompleteFlag != false) {
								Msg.info("warning", "入库单已完成!");
								return;
							}
							var qty = field.getValue();
							if (qty == null || qty.length <= 0) {
								Msg.info("warning", "入库数量不能为空!");
								return;
							}
							if (qty <= 0) {
								Msg.info("warning", "入库数量不能小于或等于0!");
								return;
							}

							// 计算指定行的进货金额和入库售价
							var cell = DetailGrid.getSelectionModel()
									.getSelectedCell();
							var record = DetailGrid.getStore()
									.getAt(cell[0]);
							var RealTotal = Number(record.get("Rp")).mul(qty);
							var SaleTotal = Number(record.get("Sp")).mul(qty);
							var NewSpAmt = Number(record.get("NewSp")).mul(qty);
							record.set("RpAmt", RealTotal);
							record.set("SpAmt", SaleTotal);
							record.set("NewSpAmt", NewSpAmt);
							record.set("InvMoney",RealTotal);
							
							if(setEnterSort(DetailGrid,colArr)){
								addNewRow();
							}
						}
					}
				}
			})
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
							if (cost <= 0) {
								Msg.info("warning",
										"入库售价不能小于或等于0!");
								return;
							}
							// 计算指定行的售价金额
							var cell = DetailGrid.getSelectionModel().getSelectedCell();
							var record = DetailGrid.getStore().getAt(cell[0]);
							var NewSpAmt = accMul(record.get("RecQty"),cost);
							record.set("NewSpAmt",NewSpAmt);
							if(setEnterSort(DetailGrid,colArr)){
								addNewRow();
							}
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
							// 判断入库单是否已完成
							var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
							if (CompleteFlag != null && CompleteFlag != false) {
								Msg.info("warning", "入库单已完成!");
								return;
							}
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
							// 判断入库单是否已完成
							var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
							if (CompleteFlag != null && CompleteFlag != false) {
								Msg.info("warning", "入库单已完成!");
								return;
							}
							if(setEnterSort(DetailGrid,colArr)){
								addNewRow();
							}
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
			header : "条码",
			dataIndex : 'BarCode',
			width : 180,
			align : 'left',
			sortable : true
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
								if(setEnterSort(DetailGrid,colArr)){
									addNewRow();
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
							if(setEnterSort(DetailGrid,colArr)){
								addNewRow();
							}
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
			header : "请求部门",
			dataIndex : 'reqLocId',
			width : 80,
			align : 'left',
			sortable : true,
			renderer :Ext.util.Format.comboRenderer2(reqLoc,"reqLocId","reqLocDesc"),								
			editor : reqLoc
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
		tbar:{items:[AddBT,'-',DeleteDetailBT,'-',{height:30,width:70,text:'列设置',iconCls:'page_gear',handler:function(){GridColSet(DetailGrid,"DHCSTIMPORTM");}}]},
		clicksToEdit : 1,
		plugins : new Ext.grid.GridSummary(),
		listeners:{
			'beforeedit' : function(e){
				if(Ext.getCmp("CompleteFlag").getValue()==true){
					return false;
				}
				if(e.field=="HVBarCode"){
					if(!UseItmTrack || e.record.get("HVFlag")=='N' ||(e.record.get("Ingri")!="" && e.record.get("HVBarCode")!="")){
						e.cancel=true;
					}
				}
				if(e.field=="RecQty" || e.field=="IncDesc" || e.field=="IngrUomId" || e.field=="HVBarCode"){
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
						Msg.info("warning", "进价不能小于或等于0!");
						e.record.set('Rp',e.originalValue);
						return;
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
						margin = accSub(accDiv(sp, cost), 1);
						if((gParam[5]!=0) && (margin>gParam[5] || margin<0)){
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
					
					//预算结余判断
					var InciId = e.record.get('IncId');
					var RpAmt = Number(e.record.get('RpAmt'));
					if(!Ext.isEmpty(InciId) && !(Number <= 0)){
						HRPBudg(InciId);
					}
				}else if(e.field=='RecQty'){
					var RealTotal = accMul(e.record.get("Rp"), e.value);
					e.record.set("RpAmt",RealTotal);
					e.record.set("InvMoney",RealTotal);
				
					//预算结余判断
					var InciId = e.record.get('IncId');
					var RpAmt = Number(e.record.get('RpAmt'));
					if(!Ext.isEmpty(InciId) && !(Number <= 0)){
						HRPBudg(InciId);
					}
				}else if(e.field=='InvNo'){
					var flag=InvNoValidator(e.value, gIngrRowid);
					if(flag==false){
						Msg.info("warning","发票号" + e.value + "已存在于别的入库单!");
					}
				}
			},
			//右键菜单
			'rowcontextmenu' : rightClickFn,
			'rowdblclick' : function(grid, rowIndex, e){
				var rowData = this.getStore().getAt(rowIndex);
				var dhcit = rowData.get('dhcit');
				var InciDesc = rowData.get('IncDesc');
				var HVBarCode = rowData.get('HVBarCode');
				var InfoStr = InciDesc + ':' + HVBarCode;
				BarCodePackItm(dhcit, InfoStr);
			}
		}
	});

	var rightClick = new Ext.menu.Menu({
		id:'rightClickCont',
		items: [
			{
				id: 'mnuDelete',
				handler: deleteDetail,
				text: '删除'
			}
		]
	});
	
	//右键菜单代码关键部分 
	function rightClickFn(grid,rowindex,e){
		e.preventDefault();
		grid.getSelectionModel().select(rowindex,0);
		rightClick.showAt(e.getXY());
	}
	
	/*
	 * 预算结余,调用HRP预算接口
	 */
	function HRPBudg(CurrInciId){
		CurrInciId = typeof(CurrInciId) == 'undefined'? '' : CurrInciId;
		var LocId = Ext.getCmp('PhaLoc').getValue();
		if(Ext.isEmpty(LocId)){
			return;
		}
		var DataStr = '';
		var Count = DetailGrid.getStore().getCount();
		for(i = 0; i < Count; i++){
			var RowData = DetailGrid.getStore().getAt(i);
			var Ingri = RowData.get('Ingri');
			var IncId = RowData.get('IncId');
			var RpAmt = RowData.get('RpAmt');
			if ((IncId == '') || !(RpAmt > 0)){
				continue;
			}
			var Data = Ingri + '^' + IncId + '^' + RpAmt;
			if(DataStr == ''){
				DataStr = Data;
			}else{
				DataStr = DataStr + RowDelim + Data;
			}
		}
		if(DataStr != ''){
			var Result = tkMakeServerCall('web.DHCSTM.ServiceForHerpBudg', 'IngrBalance', CurrInciId, LocId, DataStr);
			if(!Ext.isEmpty(Result)){
				Msg.info('error', '当前采购超出预算,请核实修改:' + Result);
				return false;
			}
		}
		return true;
	}
	
	//判断库存项重复行(非高值材料)
	function  GetRepeatResult(store,colName,colValue,beginIndex,inciDesc,row){
		beginIndex=store.findExact(colName,colValue,beginIndex);
		if(beginIndex!=-1){
			changeBgColor(row, "yellow");
			Msg.info("warning","物资 "+inciDesc+" 已存在于第"+(beginIndex+1)+"行!");
			changeBgColor(beginIndex, "yellow");
			GetRepeatResult(store,colName,colValue,beginIndex+1,inciDesc,row);
		}
	}
	
	/**
	 * 调用物资窗体并返回结果
	 */
	function GetPhaOrderInfo(item, group) {					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", gHospId,
					getDrugList);
		}
	}
	
	/**
	 * 返回方法
	 * 2017-05-22 添加第2个参数,传入需要赋值的record
	*/
	function getDrugList(record, rowData) {
		if (Ext.isEmpty(record) || Ext.isEmpty(rowData)) {
			return;
		}
		var row = DetailStore.indexOf(rowData);
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		var HVFlag=record.get("HVFlag");
		var PoI=record.get("PoI");
		var BatchNo=record.get("BatchNo");
		var ExpDate=record.get("ExpDate");
		var certNo=record.get("CertNo");
		var certExpDate=record.get("CertExpDate");
		var bRp=record.get('Rp');
		var dhcit=record.get('dhcit');
		
		rowData.set("IncId",inciDr);
		rowData.set("IncCode",inciCode);
		rowData.set("IncDesc",inciDesc);
		rowData.set("BatchNo",BatchNo);
		rowData.set("ExpDate",toDate(ExpDate));
		rowData.set("PoI",PoI);
		rowData.set('Rp',bRp);
		rowData.set("AdmNo",certNo);
		rowData.set("AdmExpdate",toDate(certExpDate));
		rowData.set("dhcit",dhcit);
		var LocId=Ext.getCmp("PhaLoc").getValue();
		var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;
		//取其它物资信息
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=GetItmInfo&IncId="
			+ inciDr+"&Params="+Params;
		var result = ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(result);
		if (jsonData.success == 'true') {
			var data=jsonData.info.split("^");
			addComboData(PhManufacturerStore,data[0],data[1]);
			var BatchReq = data[15],ExpReq = data[16];
			rowData.set("ManfId", data[0]);
			//alert("jsonData.info="+jsonData.info)
			addComboData(ItmUomStore,data[10],data[25]);		//2016-01-21 使用基本单位
			rowData.set("IngrUomId", data[10]);
			var RequestLoc = Ext.getCmp("RequestLoc").getValue();
			var RequestLocdisplaytext = Ext.getCmp("RequestLoc").getRawValue()
			addComboData(Ext.getCmp("reqLoc").getStore(),RequestLoc,RequestLocdisplaytext);
			rowData.set("reqLocId", RequestLoc);
			if(rowData.get('Rp')==0){
				rowData.set("Rp", Number(data[23]));
			}
			rowData.set("Sp", Number(data[24]));
			rowData.set("NewSp", Number(data[24]));
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
			//对比最高售价
			if(gParam[9]=="Y" & data[13]!=""){
				if(Number(data[5])>Number(data[13])){
					Msg.info("error","当前售价高于最高售价!");
				}
			}
			if(UseItmTrack && data[14]=="Y"){
				rowData.set('RecQty',1);
				rowData.set('RpAmt', rowData.get('Rp'));
				rowData.set('InvMoney', rowData.get('Rp'));
				rowData.set('SpAmt', rowData.get('Sp'));
				rowData.set('NewSpAmt', rowData.get('NewSp'));
				//var colDataIndex = BatchReq=='R'?'BatchNo':ExpReq=='R'?'ExpDate':'Rp';
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}else{
				//var colDataIndex = BatchReq=='R'?'BatchNo':ExpReq=='R'?'ExpDate':'RecQty';
				//var colIndex=GetColIndex(DetailGrid,colDataIndex);
				if(setEnterSort(DetailGrid,colArr)){
					addNewRow();
				}
			}
			
			//加成率
			var cost = rowData.get('Rp');
			var sp = rowData.get("Sp");
			var margin=0
			if(cost!=0){
				margin = accSub(accDiv(sp, cost), 1);
				rowData.set('Marginnow', margin);
			}
			
			//=====================判断资质====================
			var vendor = Ext.getCmp("Vendor").getValue();
			var inci=record.get("InciDr");
			var DataList=vendor+"^"+inci+"^"+data[0];
			Ext.Ajax.request({
				url : 'dhcstm.utilcommon.csp?actiontype=Check',
				params : {DataList : DataList},
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						if(jsonData.info!=""){
							Msg.info("warning",jsonData.info);
						}
					}
				},
				scope : this
			});
		}
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
	
	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		region : 'north',
		autoHeight : true,
		labelAlign : 'right',
		title:gHVINGdRec==true?'入库单制单(高值)':'入库单制单',
		frame : true,
		autoScroll : false,
		tbar : [SearchInGrBT, '-', SaveBT, '-',ClearBT, '-', 
				DeleteBT, '-', CompleteBT,'-',CancleCompleteBT,'-',PrintBT,'-',PrintHVCol],
		items:[{
			xtype:'fieldset',
			title:'入库信息',
			style:'padding:1px 0px 0px 10px',
			layout: 'column',
			defaults: {xtype: 'fieldset', border:false},
			items : [{
				columnWidth: 0.25,
				items: [PhaLoc,Vendor,StkGrpType,SourceOfFund]
			},{
				columnWidth:0.1,
				items:[VirtualFlag]
			},{
				columnWidth: 0.25,
				items: [InGrNo,InGrDate,OperateInType,RequestLoc]
			},{
				columnWidth: 0.2,
				items: [PurchaseUser,InGrRemarks]
			},{
				columnWidth: 0.2,
				items: [CompleteFlag,PresentFlag,ExchangeFlag]
			}]
		}]
	});

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, DetailGrid],
		renderTo : 'mainPanel'
	});
			
	RefreshGridColSet(DetailGrid,"DHCSTIMPORTM");   //根据自定义列设置重新配置列
	if(gIngrRowid!=null && gIngrRowid!='' && gFlag==1){
		Query(gIngrRowid);
	}
})