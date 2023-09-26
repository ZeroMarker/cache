// /����: ��ⵥ�Ƶ�
// /����: ��ⵥ�Ƶ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.06.27

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
		GetParam();  //��ʼ����������
	}

	//ȡ��ֵ�������
	var UseItmTrack="";
	if(gItmTrackParam.length<1){
		GetItmTrackParam();
		UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
	}
	
	var isBarcodeEdit=true,isIncdescEdit=true;
	if(!UseItmTrack){
		if(gHVINGdRec){
			isIncdescEdit=false;
			Msg.info("warning","�˲˵���ʹ��!");
		}else{
			isBarcodeEdit=false;
		}
	}else{
		if(gHVINGdRec){	//��ֵ�˵�
			isIncdescEdit=false;
		}else{			//�Ǹ�ֵ�˵�
			isBarcodeEdit=false;
		}
	}
	
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '��ⲿ��',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor:'90%',
		emptyText : '��ⲿ��...',
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

	// ��������
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:gLocId,
		UserId:gUserId,
		anchor:'90%'
	}); 
	
	// �������
	var OperateInType = new Ext.form.ComboBox({
		fieldLabel : '�������',
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
	// Ĭ��ѡ�е�һ������
	OperateInTypeStore.load({
		callback:function(r,options,success){
			if(success && r.length>0){
				OperateInType.setValue(r[0].get(OperateInType.valueField));
			}
		}
	});

	// ��ⵥ��
	var InGrNo = new Ext.form.TextField({
		fieldLabel : '��ⵥ��',
		id : 'InGrNo',
		name : 'InGrNo',
		anchor : '90%',
		disabled : true
	});
	
	// �������
	var InGrDate = new Ext.ux.DateField({
		fieldLabel : '�������',
		id : 'InGrDate',
		name : 'InGrDate',
		anchor : '90%',
		value : new Date(),
		disabled : true
	});
	// ������
	var RequestLoc = new Ext.ux.LocComboBox({
				fieldLabel : '���տ���',
				id : 'RequestLoc',
				name : 'RequestLoc',
				anchor:'90%',
				width : 120,
				emptyText : '���տ���...',
				defaultLoc:{}
	});
	// �ɹ���Ա
	var PurchaseUser = new Ext.ux.ComboBox({
		fieldLabel : '�ɹ���Ա',
		id : 'PurchaseUser',
		store : PurchaseUserStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

	// ��ע
	var InGrRemarks = new Ext.form.TextArea({
		id:'InGrRemarks',
		fieldLabel:'��ע',
		allowBlank:true,
		height:50,
		emptyText:'��ע...',
		anchor:'90%',
		selectOnFocus:true
	});
			
	// ��ɱ�־
	var CompleteFlag = new Ext.form.Checkbox({
		boxLabel : '���',
		id : 'CompleteFlag',
		name : 'CompleteFlag',
		anchor : '90%',
		checked : false,
		disabled:true
	});
	
	// ��ҩ����־
	var PresentFlag = new Ext.form.Checkbox({
		boxLabel : '����',
		id : 'PresentFlag',
		name : 'PresentFlag',
		anchor : '90%',
		checked : false
	});

	// ���ۻ�Ʊ��־
	var ExchangeFlag = new Ext.form.Checkbox({		
		id : 'ExchangeFlag',
		name : 'ExchangeFlag',
		anchor : '100%',
		checked : false,
		boxLabel:'���ۻ�Ʊ'
	});

	var SourceOfFund = new Ext.ux.ComboBox({
		fieldLabel : '�ʽ���Դ',
		id : 'SourceOfFund',
		anchor : '90%',
		store : SourceOfFundStore
	});
	
	// ��ӡ��ⵥ��ť
	var PrintBT = new Ext.Toolbar.Button({
		id : "PrintBT",
		text : '��ӡ',
		tooltip : '�����ӡ��ⵥ',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			PrintRec(gIngrRowid);
		}
	});
	
	// ��ӡ��ⵥ��ť
	var PrintHVCol = new Ext.Toolbar.Button({
		id : "PrintHVCol",
		text : '��ֵ���ܴ�ӡ',
		tooltip : '��ӡ��ֵ��ⵥƱ��',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			PrintRecHVCol(gIngrRowid);
		}
	});
			
	// ��ѯ��ⵥ��ť
	var SearchInGrBT = new Ext.Toolbar.Button({
		id : "SearchInGrBT",
		text : '��ѯ',
		tooltip : '�����ѯ��ⵥ',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			DrugImportGrSearch(DetailStore,Query);
		}
	});

	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '���',
		tooltip : '������',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			if (isDataChanged(HisListTab,DetailGrid)){
				Ext.Msg.show({
					title:'��ʾ',
					msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
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
	// ��ɰ�ť
	var CompleteBT = new Ext.Toolbar.Button({
		id : "CompleteBT",
		text : '���',
		tooltip : '������',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
			// �ж���ⵥ�Ƿ������
			var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
			if (CompleteFlag != null && CompleteFlag != 0) {
				Msg.info("warning", "��ⵥ�����!");
				return;
			}		
			if (gIngrRowid == null || gIngrRowid=="") {
				Msg.info("warning", "û����Ҫ��ɵ���ⵥ!");
				return;
			}
			var rowData = DetailStore.getAt(0);
			if(rowData==""||rowData==undefined){
				Msg.info("warning","û����Ҫ��ɵ�������ϸ!");
				return;
			}
			
			//Ԥ������ж�
			var HRPBudgResult = HRPBudg();
			if(HRPBudgResult === false){
				return;
			}
			
			var mainData=GetIngrMainData(gIngrRowid);
			var mainArr=mainData.split("^");
			var phaLocDesc=mainArr[11];
			if(gHVINGdRec){
				Ext.Msg.show({
					title:'��ʾ',
					msg: '��ǰ������Ϊ"'+phaLocDesc+'", �Ƿ������',
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

	// ȡ����ɰ�ť
	var CancleCompleteBT = new Ext.Toolbar.Button({
		id : "CancleCompleteBT",
		text : 'ȡ�����',
		tooltip : '���ȡ�����',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
			CancleComplete();
		}
	});
	// ɾ����ť
	var DeleteBT = new Ext.Toolbar.Button({
		id : "DeleteBT",
		text : 'ɾ��',
		tooltip : '���ɾ��',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function() {
			deleteData();
		}
	});

			
	/**
	 * ��շ���
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
		
		//��ѯ^���^����^����^ɾ��^���^ȡ�����
		changeButtonEnable("1^1^1^0^0^0^0");
		SetFieldDisabled(false);
		//������ܴ���href����
		CheckLocationHref();
	}
	
	var DeleteDetailBT=new Ext.Toolbar.Button({
		id:'DeleteDetailBT',
		text:'ɾ��һ��',
		tooltip:'���ɾ��',
		width:70,
		height:30,
		iconCls:'page_delete',
		handler:function(){
			deleteDetail();
		}
	});
	// ���Ӱ�ť
	var AddBT = new Ext.Toolbar.Button({
		id : "AddBT",
		text : '����һ��',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_add',
		handler : function() {
			// �ж���ⵥ�Ƿ�������
			var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
			if (CmpFlag != null && CmpFlag != 0) {
				Msg.info("warning", "��ⵥ����ɲ����޸�!");
				return;
			}
			// �ж��Ƿ�ѡ����ⲿ�ź͹�������
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "��ѡ����ⲿ��!");
				return;
			}
			var vendor = Ext.getCmp("Vendor").getValue();
			if (vendor == null || vendor.length <= 0) {
				Msg.info("warning", "��ѡ��Ӧ��!");
				return;
			}
			if (Ext.getCmp('StkGrpType').getValue()==''){
				Msg.info("warning","��ѡ������!");
				return;
			}
			var operateInType = Ext.getCmp("OperateInType")
					.getValue();
			if ((gParam[8]=="Y")&(operateInType == null || operateInType.length <= 0)) {
				Msg.info("warning", "��ѡ���������!");
				return;
			}
			colArr=sortColoumByEnterSort(DetailGrid); //���س��ĵ���˳���ʼ����
			// ����һ��
			addNewRow();
			// �����ť�Ƿ����
			//��ѯ^���^����^����^ɾ��^���^ȡ�����
			changeButtonEnable("0^1^1^1^1^1^0");
			SetFieldDisabled(true);
		}
	});
	
	function SetFieldDisabled(bool){
		Ext.getCmp("Vendor").setDisabled(bool);
		Ext.getCmp("StkGrpType").setDisabled(bool);
	}
	
	/**
	 * ����һ��
	 */
	function addNewRow() {
		var inciIndex=GetColIndex(DetailGrid,"IncDesc");
		var barcodeIndex=GetColIndex(DetailGrid,"HVBarCode");
		var col=gHVINGdRec?barcodeIndex:inciIndex;
		if(colArr && colArr[0]){
			col = GetColIndex(DetailGrid, colArr[0].dataIndex);
		}
		var lastInvNo="";
		// �ж��Ƿ��Ѿ��������
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

	// ���水ť
	var SaveBT = new Ext.ux.Button({
		id : "SaveBT",
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			if(DetailGrid.activeEditor != null){
				DetailGrid.activeEditor.completeEdit();
			}
			loadMask=ShowLoadMask(Ext.getBody(),"������...");
			if(CheckDataBeforeSave()==true){
				// ������ⵥ
				saveOrder();
			}else{
				loadMask.hide();
			}
		}
	});

	/**
	 * ������ⵥǰ���ݼ��
	 */		
	function CheckDataBeforeSave() {
		var nowdate = new Date();
		// �ж���ⵥ�Ƿ�������
		var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
		if (CmpFlag != null && CmpFlag != 0) {
			Msg.info("warning", "��ⵥ����ɲ����޸�!");
			return false;
		}
		// �ж���ⲿ�ź͹������Ƿ�Ϊ��
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ����ⲿ��!");
			return false;
		}
		var vendor = Ext.getCmp("Vendor").getValue();
		if (vendor == null || vendor.length <= 0) {
			Msg.info("warning", "��ѡ��Ӧ��!");
			return false;
		}
		
		var IngrTypeId = Ext.getCmp("OperateInType").getValue();
		var PurUserId = Ext.getCmp("PurchaseUser").getValue();
		if((PurUserId==null || PurUserId=="")&(gParam[7]=='Y')){
			Msg.info("warning", "�ɹ�Ա����Ϊ��!");
			return false;
		}
		if((IngrTypeId==null || IngrTypeId=="")&(gParam[8]=='Y')){
			Msg.info("warning", "������Ͳ���Ϊ��!");
			return false;
		}
		
		// 1.�ж���������Ƿ�Ϊ��
		var rowCount = DetailGrid.getStore().getCount();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var item = DetailStore.getAt(i).get("IncId");
			if (item != "") {
				count++;
			}
		}
		if (rowCount <= 0 || count <= 0) {
			Msg.info("warning", "�����������ϸ!");
			return false;
		}
		// 2.������䱳��
		for (var i = 0; i < rowCount; i++) {
			changeBgColor(i, "white");
		}
//			// 3.�ж��ظ���������
//			for (var i = 0; i < rowCount - 1; i++) {
//				for (var j = i + 1; j < rowCount; j++) {
//					var item_i = DetailStore.getAt(i).get("IncId");
//					var HVFlag = DetailStore.getAt(i).get("HVFlag");
//					var item_j = DetailStore.getAt(j).get("IncId");
//					//���ڸ�ֵ����, ר�Ź���(UseItmTrak==true)ʱ���ж��Ƿ��ظ�, ͨ��¼������ʱ�ж������Ƿ��ظ�
//					if(!(UseItmTrack && HVFlag=='Y')){
//						if (item_i != "" && item_j != ""
//								&& item_i == item_j) {
//							DetailGrid.getSelectionModel().select(i, 1);
//							changeBgColor(i, "yellow");
//							changeBgColor(j, "yellow");
//							Msg.info("warning", "�����ظ�������������!");
//							return false;
//						}
//					}
//				}
//			}
		// 4.������Ϣ�������
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
					Msg.info("warning", "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			var BatchNo = rowData.get('BatchNo');
			var BatchReq = rowData.get('BatchReq');
			if(BatchReq=='R'){
				if ((item != "") && (BatchNo=="")) {
					Msg.info("warning", "���Ų���Ϊ��!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			var qty = rowData.get("RecQty");
			if ((item != "") && (qty == null || qty <= 0)) {
				Msg.info("warning", "�����������С�ڻ����0!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			var inpoqty=rowData.get("InPoQty");
			if((gParam[13]=="N"||gParam[13]=="")&&(qty>inpoqty)&&(inpoqty!="")){
				Msg.info("warning", "����������ܴ��ڶ�������!");
				var cell = DetailGrid.getSelectionModel()
					.getSelectedCell();
				DetailGrid.getSelectionModel().select(cell[0], 1);
				changeBgColor(i, "yellow");
				return false;
			}
			
			var realPrice = rowData.get("Rp");
			if ((item != "")&& (realPrice == null || realPrice <= 0)) {
				Msg.info("warning", "�����۲���С�ڻ����0!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			var Sp = rowData.get("Sp");
			if (Sp<=0){
				Msg.info("warning","��"+(i+1)+"���ۼ۲���ΪС�ڻ����0");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
		}
		
		return true;
	}
	
	/**
	 * ������ⵥ
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
			//���������ݷ����仯ʱִ����������
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
			Msg.info("error", "û��������Ҫ����!");
			loadMask.hide();
			return false;
		}
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=Save";
		//var loadMask=ShowLoadMask(Ext.getBody(),"������...");
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			params:{Ingr:gIngrRowid,MainInfo:MainInfo,ListDetail:ListDetail},
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					// ˢ�½���
					var IngrRowid = jsonData.info;
					Msg.info("success", "����ɹ�!");
					DetailStore.commitChanges();
					// 7.��ʾ��ⵥ����
					gIngrRowid=IngrRowid;
					Query(IngrRowid);
					if(gParam[3]=='Y'){
						PrintRec(IngrRowid, 'Y');
					}
				} else {
					var ret=jsonData.info;
					if(ret==-99){
						Msg.info("error", "����ʧ��,���ܱ���!");
					}else if(ret==-2){
						Msg.info("error", "������ⵥ��ʧ��,���ܱ���!");
					}else if(ret==-3){
						Msg.info("error", "������ⵥʧ��!");
					}else if(ret==-4){
						Msg.info("error", "δ�ҵ�����µ���ⵥ,���ܱ���!");
					}else if(ret==-5){
						Msg.info("error", "������ⵥ��ϸʧ��!");
					}else {
						Msg.info("error", "������ϸ���治�ɹ���"+ret);
					}
					loadMask.hide();
				}
			},
			scope : this
		});
	}
	// ��ʾ��ⵥ����
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
			waitMsg : '��ѯ��...',
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
						//�ݴ�⹴ѡҪ�ڿ���combo��ֵ֮ǰ
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
						// ��ʾ��ⵥ��ϸ����
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
	
	// �����ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'ingdrecaction.csp?actiontype=QueryDetail&Parref=&start=0&limit=999';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url : DetailUrl,
		method : "POST"
	});
	
	// ָ���в���
	var fields = ["Ingri", "IncId", "IncCode", "IncDesc","ManfId","Manf","BatchNo", {name:'ExpDate',type:'date',dateFormat:DateFormat},
		"IngrUomId","IngrUom","RecQty","Rp", "Marginnow", "Sp","NewSp","InvNo","InvMoney", {name:'InvDate',type:'date',dateFormat:DateFormat},"RpAmt", "SpAmt", "NewSpAmt",
		"QualityNo","SxNo","Remark","Remarks","MtDesc","PubDesc","BUomId","ConFacPur","MtDr","HVFlag","HVBarCode","Spec","SterilizedNo","InPoQty","BatchReq","ExpReq","BarCode","AdmNo",{name:'AdmExpdate',type:'date',dateFormat:DateFormat},
		"dhcit","reqLocId","reqLocDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "Ingri",
		fields : fields
	});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	// ��ʾ��ⵥ��ϸ����
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
		// �����ť�Ƿ����
		//��ѯ^���^����^����^ɾ��^���^ȡ�����
		var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
		if(inGrFlag==true){
			changeButtonEnable("1^1^0^0^0^0^1");
		}else{
			changeButtonEnable("1^1^1^1^1^1^0");
		}
		
	}
	
	// �����ť�Ƿ����
	function changeButtonEnable(str) {
		var list = str.split("^");
		for (var i = 0; i < list.length; i++) {
			if (list[i] == "1") {
				list[i] = false;
			} else {
				list[i] = true;
			}
		}
		//��ѯ^���^����^����^ɾ��^���^ȡ�����
		SearchInGrBT.setDisabled(list[0]);
		ClearBT.setDisabled(list[1]);
		AddBT.setDisabled(list[2]);
		SaveBT.setDisabled(list[3]);
		DeleteBT.setDisabled(list[4]);
		CompleteBT.setDisabled(list[5]);
		CancleCompleteBT.setDisabled(list[6]);
	}
	
	function deleteData() {
		// �ж���ⵥ�Ƿ�������
		var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
		if (inGrFlag != null && inGrFlag != 0) {
			Msg.info("warning", "��ⵥ����ɲ���ɾ��!");
			return;
		}
		if (gIngrRowid == "") {
			Msg.info("warning", "û����Ҫɾ������ⵥ!");
			return;
		}

		Ext.MessageBox.show({
			title : '��ʾ',
			msg : '�Ƿ�ȷ��ɾ��������ⵥ?',
			buttons : Ext.MessageBox.YESNO,
			fn : showDeleteGr,
			icon : Ext.MessageBox.QUESTION
		});
	}

	/**
	 * ɾ����ⵥ��ʾ
	 */
	function showDeleteGr(btn) {
		if (btn == "yes") {
			var url = DictUrl
				+ "ingdrecaction.csp?actiontype=Delete&IngrRowid="
				+ gIngrRowid;

			Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						// ɾ������
						Msg.info("success", "��ⵥɾ���ɹ�!");
						clearData();
					} else {
						var ret=jsonData.info;
						if(ret==-1){
							Msg.info("error", "��ⵥ�Ѿ���ɣ�����ɾ��!");
						}else if(ret==-2){
							Msg.info("error", "��ⵥ�Ѿ���ˣ�����ɾ��!");
						}else if(ret==-3){
							Msg.info("error", "��ⵥ������ϸ�Ѿ���ˣ�����ɾ��!");
						}else{
							Msg.info("error", "ɾ��ʧ��,��鿴������־!");
						}
					}
				},
				scope : this
			});
		}
	}

	/**
	 * ɾ��ѡ��������
	 */
	function deleteDetail() {
		// �ж���ⵥ�Ƿ������
		var CmpFlag = Ext.getCmp("CompleteFlag").getValue();
		if (CmpFlag != null && CmpFlag != false) {
			Msg.info("warning", "��ⵥ����ɲ���ɾ��!");
			return;
		}
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);
		var Ingri = record.get("Ingri");
		if (Ingri == "" ) {
			DetailGrid.getStore().remove(record);
			DetailGrid.getView().refresh();
		} else {
			Ext.MessageBox.show({
				title : '��ʾ',
				msg : '�Ƿ�ȷ��ɾ����������Ϣ?',
				buttons : Ext.MessageBox.YESNO,
				fn : showResult,
				icon : Ext.MessageBox.QUESTION
			});
		}
	}
	/**
	 * ɾ����ʾ
	 */
	function showResult(btn) {
		if (btn == "yes") {
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var row = cell[0];
			var record = DetailGrid.getStore().getAt(row);
			var Ingri = record.get("Ingri");

			// ɾ����������
			var url = DictUrl
				+ "ingdrecaction.csp?actiontype=DeleteDetail&Rowid="
				+ Ingri;

			Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "ɾ���ɹ�!");
						DetailGrid.getStore().remove(record);
						DetailGrid.getView().refresh();
					} else {
						var ret=jsonData.info;
						if(ret==-1){
							Msg.info("error", "��ⵥ�Ѿ���ɣ�����ɾ��!");
						}else if(ret==-2){
							Msg.info("error", "��ⵥ�Ѿ���ˣ�����ɾ��!");
						}else if(ret==-4){
							Msg.info("error", "����ϸ�����Ѿ���ˣ�����ɾ��!");
						}else{
							Msg.info("error", "ɾ��ʧ��,��鿴������־!");
						}
					}
				},
				scope : this
			});
		}
	}

	/**
	 * �����ⵥ
	 */
	function Complete() {
		// �ж���ⵥ�Ƿ������
		var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
		if (CompleteFlag != null && CompleteFlag != 0) {
			Msg.info("warning", "��ⵥ�����!");
			return;
		}
		var InGrNo = Ext.getCmp("InGrNo").getValue();
		if (InGrNo == null || InGrNo.length <= 0) {
			Msg.info("warning", "û����Ҫ��ɵ���ⵥ!");
			return;
		}
		//===========================
		var rowData = DetailStore.getAt(0);
		if(rowData==""||rowData==undefined){
			Msg.info("warning","û����Ҫ��ɵ�������ϸ!");
			return;
		}
		var Count = DetailGrid.getStore().getCount();
		for (var i = 0; i < Count; i++) {
			var rowData = DetailStore.getAt(i);
			var Sp = Number(rowData.get("Sp"));
			if(Sp==0){
				Msg.info("warning","��"+(i+1)+"���ۼ۲���Ϊ0!");
				return;
			}
		}
		
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=MakeComplete";
		Ext.Ajax.request({
			url : url,
			params : {Rowid:gIngrRowid,User:gUserId,GroupId:gGroupId},
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					// ��˵���
					Msg.info("success", "�ɹ�!");
					// ��ʾ��ⵥ����
					Query(gIngrRowid);
					//��ѯ^���^����^����^ɾ��^���^ȡ�����
					changeButtonEnable("1^1^0^0^0^0^1");
					var AuditAfterComp=gParam[12];	//��ɺ��Զ���˲���
					var PrintAfterAudit=gParam[4];	//��˺��Զ���ӡ����
					if(AuditAfterComp=='Y' && PrintAfterAudit=='Y'){
						PrintRec(gIngrRowid, 'Y');
					}
				} else {
					var Ret=jsonData.info;
					if(Ret==-1){
						Msg.info("error", "����ʧ��,��ⵥIdΪ�ջ���ⵥ������!");
					}else if(Ret==-2){
						Msg.info("error", "��ⵥ�Ѿ����!");
					}else {
						Msg.info("error", "����ʧ��!");
					}
				}
			},
			scope : this
		});
	}

	/**
	 * ȡ�������ⵥ
	 */
	function CancleComplete() {
		
		var InGrNo = Ext.getCmp("InGrNo").getValue();
		if (InGrNo == null || InGrNo.length <= 0) {
			Msg.info("warning", "û����Ҫȡ����ɵ���ⵥ!");
			return;
		}
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=CancleComplete&Rowid="
				+ gIngrRowid + "&User=" + gUserId;
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					// ��˵���
					Msg.info("success", "ȡ���ɹ�!");
					// ��ʾ��ⵥ����
					Query(gIngrRowid);
					//��ѯ^���^����^����^ɾ��^���^ȡ�����
					changeButtonEnable("1^1^1^1^1^1^0");
				} else {
					var Ret=jsonData.info;
					if(Ret==-1){
						Msg.info("error", "��ⵥIdΪ�ջ���ⵥ������!");
					}else if(Ret==-2){
						Msg.info("error", "��ⵥ��δ���!");
					}else if(Ret==-4){
						Msg.info("error", "��ⵥ�Ѿ����!");
					}else{
						Msg.info("error", "����ʧ��!");
					}
				}
			},
			scope : this
		});
	}
	
	// ��λ
	var CTUom = new Ext.form.ComboBox({
		fieldLabel : '��λ',
		id : 'CTUom',
		name : 'CTUom',
		anchor : '90%',
		width : 120,
		store : ItmUomStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : false,
		triggerAction : 'all',
		emptyText : '��λ...',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		pageSize : 10,
		listWidth : 250,
		valueNotFoundText : ''
	});

	// ��������
	var Phmnf = new Ext.ux.ComboBox({
		fieldLabel : '����',
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
					// ����һ��
					addNewRow();
				}
			}
		}
	})
	var reqLoc = new Ext.ux.LocComboBox({
				fieldLabel : '���տ���',
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
			header : '���ʴ���',
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
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
							// �ж���ⵥ�Ƿ������																		
							var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
							if (CompleteFlag != null && CompleteFlag != false) {
								Msg.info("warning", "��ⵥ�����!");
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
			header : '���',
			dataIndex : 'Spec',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "��ֵ��־",
			dataIndex : 'HVFlag',
			width : 80,
			align : 'center',
			sortable : true,
			hidden : true
		}, {
			header : "��ֵ����",
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
								Msg.info("warning","�����ظ�¼��!");
								field.setValue("");
								field.focus();
								return;
							}
							Ext.Ajax.request({
								url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode',
								method : 'POST',
								params : {Barcode:Barcode},
								waitMsg : '��ѯ��...',
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
											Msg.info("warning","����"+Barcode+"����"+scgDesc+"����,�뵱ǰ����!");
											RowRecord.set("HVBarCode","");
											return;
										}else if((type!="Reg" && type!="G")||(type=="G" && lastDetailAudit=="Y")){
											Msg.info("warning","�������Ѱ������!");
											RowRecord.set("HVBarCode","");
											return;
										}else if(type=="G" && lastDetailAudit!="Y"){
											Msg.info("warning","��δ��ɻ�δ��˵�"+lastDetailOperNo);
											RowRecord.set("HVBarCode","");
											return;
										}else if(!Ext.isEmpty(dhcitlocid) && gLocId!=dhcitlocid){
											Msg.info("warning","������Ǳ�����!!");
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
										Msg.info("error","��������δע��!");
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
			header : "����",
			dataIndex : 'ManfId',
			width : 180,
			align : 'left',
			sortable : true,
			editor : new Ext.grid.GridEditor(Phmnf),
			renderer :Ext.util.Format.comboRenderer2(Phmnf,"ManfId","Manf")	 
		}, {
			header : "����",
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
			header : "��Ч��",
			dataIndex : 'ExpDate',
			width : 100,
			align : 'center',
			sortable : true,
			renderer : Ext.util.Format.dateRenderer(DateFormat),
			editor : ExpDateEditor
		}, {
			header : "��λ",
			dataIndex : 'IngrUomId',
			width : 80,
			align : 'left',
			sortable : true,
			renderer :Ext.util.Format.comboRenderer2(CTUom,"IngrUomId","IngrUom"),								
			editor : new Ext.grid.GridEditor(CTUom)
		}, {
			header : "����",
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
							// �ж���ⵥ�Ƿ������																		
							var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
							if (CompleteFlag != null && CompleteFlag != false) {
								Msg.info("warning", "��ⵥ�����!");
								return;
							}
							var qty = field.getValue();
							if (qty == null || qty.length <= 0) {
								Msg.info("warning", "�����������Ϊ��!");
								return;
							}
							if (qty <= 0) {
								Msg.info("warning", "�����������С�ڻ����0!");
								return;
							}

							// ����ָ���еĽ�����������ۼ�
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
			header : "����",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true,
			editor : RpEditor
		}, {
			header : "�ۼ�",
			dataIndex : 'Sp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : "��ǰ�ӳ�",
			dataIndex : 'Marginnow',
			width : 60,
			align : 'right',
			sortable : true	
		}, {
			header : "����ۼ�",
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
								Msg.info("warning", "����ۼ۲���Ϊ��!");
								return;
							}
							if (cost <= 0) {
								Msg.info("warning",
										"����ۼ۲���С�ڻ����0!");
								return;
							}
							// ����ָ���е��ۼ۽��
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
			header : "��Ʊ��",
			dataIndex : 'InvNo',
			width : 80,
			align : 'left',
			sortable : true,
			editor : InvNoEditor
		}, {
			header :"��Ʊ���",
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
			header : "��Ʊ����",
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
							// �ж���ⵥ�Ƿ������
							var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
							if (CompleteFlag != null && CompleteFlag != false) {
								Msg.info("warning", "��ⵥ�����!");
								return;
							}
							var invDate = field.getValue();
							if (invDate == null || invDate.length <= 0) {
								// Msg.info("warning", "��Ʊ���ڲ���Ϊ��!");
								return;
							}
							addNewRow();
						}
					}
				}
			})
		},{
			header : "�ʼ쵥��",
			dataIndex : 'QualityNo',
			width : 90,
			align : 'left',
			sortable : true,
			editor : new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false
			})
		},{
			header : "���е���",
			dataIndex : 'SxNo',
			width : 90,
			align : 'left',
			sortable : true,
			editor : new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false
			})
		}, {
			header : "�������",
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
			header : "����ۼ۽��",
			dataIndex : 'NewSpAmt',
			width : 100,
			align : 'right',
			
			sortable : true
		},{
			header : "��������",
			dataIndex : 'MtDesc',
			width : 180,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "�б��ִ�",
			dataIndex : 'PubDesc',
			width : 180,
			align : 'left',
			sortable : true,
			hidden : true
		},{
			header : "ժҪ",
			dataIndex : 'Remark',
			width : 90,
			align : 'left',
			sortable : true,
			editor : new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false
			})
		},{
			header : "��ע",
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
			header : "�������",
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
							// �ж���ⵥ�Ƿ������
							var CompleteFlag = Ext.getCmp("CompleteFlag").getValue();
							if (CompleteFlag != null && CompleteFlag != false) {
								Msg.info("warning", "��ⵥ�����!");
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
			header : '��������',
			dataIndex : 'InPoQty',
			width : 80,
			align : 'left',
			hidden:true,
			sortable : true
		},{
			header : "����Ҫ��",
			dataIndex : 'BatchReq',
			width : 80,
			align : 'center',
			hidden : true
		},{
			header : "��Ч��Ҫ��",
			dataIndex : 'ExpReq',
			width : 80,
			align : 'center',
			hidden : true
		}, {
			header : "����",
			dataIndex : 'BarCode',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			header : "ע��֤��",
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
			header : "ע��֤��Ч��",
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
			header : "������",
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
		title:'��ⵥ��ϸ',
		region : 'center',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm : new Ext.grid.CellSelectionModel({}),
		tbar:{items:[AddBT,'-',DeleteDetailBT,'-',{height:30,width:70,text:'������',iconCls:'page_gear',handler:function(){GridColSet(DetailGrid,"DHCSTIMPORTM");}}]},
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
						Msg.info("warning","��Ч�ڲ���Ϊ��!");
						e.record.set('ExpDate',e.originalValue);
						return;
					}else{
						expDate=expDate.format(ARG_DATEFORMAT);
					}
					var Inci = e.record.get('IncId');
					var flag=ExpDateValidator(expDate,Inci);
					if(flag==false){
						//Msg.info('warning','�����ʾ���ʧЧ������'+gParam[2]+'��!');
						e.record.set('ExpDate',e.originalValue);
						return;
					}
				}else if(e.field=='BatchNo'){
					if(e.record.get('BatchReq')!='R'){
						return;
					}
					var BatchNo = e.value;
					if(BatchNo==null || BatchNo==""){
						Msg.info("warning","���Ų���Ϊ��!");
						e.record.set('BatchNo',e.originalValue);
						return;
					}
				}else if(e.field=='Rp'){
					var cost = e.value;
					if (Ext.isEmpty(cost)) {
						Msg.info("warning", "���۲���Ϊ��!");
						e.record.set('Rp',e.originalValue);
						return;
					}else if (cost <= 0) {
						Msg.info("warning", "���۲���С�ڻ����0!");
						e.record.set('Rp',e.originalValue);
						return;
					}
					//�����ۼ۸��ݽ������¼����ۼ�
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
					//��֤�ӳ���
					var sp = e.record.get("Sp");
					var margin=0
					if(cost!=0){
						margin = accSub(accDiv(sp, cost), 1);
						if((gParam[5]!=0) && (margin>gParam[5] || margin<0)){
							Msg.info("warning",	"�ӳ��ʳ����޶���Χ!");
							e.record.set('Rp',e.originalValue);
							return false;
						}
					}
					// ����ָ���еĽ������
					var RealTotal = accMul(e.record.get("RecQty"), cost);
					e.record.set("RpAmt",RealTotal);
					e.record.set("InvMoney",RealTotal);
					e.record.set("Marginnow",margin.toFixed(3));
					
					//Ԥ������ж�
					var InciId = e.record.get('IncId');
					var RpAmt = Number(e.record.get('RpAmt'));
					if(!Ext.isEmpty(InciId) && !(Number <= 0)){
						HRPBudg(InciId);
					}
				}else if(e.field=='RecQty'){
					var RealTotal = accMul(e.record.get("Rp"), e.value);
					e.record.set("RpAmt",RealTotal);
					e.record.set("InvMoney",RealTotal);
				
					//Ԥ������ж�
					var InciId = e.record.get('IncId');
					var RpAmt = Number(e.record.get('RpAmt'));
					if(!Ext.isEmpty(InciId) && !(Number <= 0)){
						HRPBudg(InciId);
					}
				}else if(e.field=='InvNo'){
					var flag=InvNoValidator(e.value, gIngrRowid);
					if(flag==false){
						Msg.info("warning","��Ʊ��" + e.value + "�Ѵ����ڱ����ⵥ!");
					}
				}
			},
			//�Ҽ��˵�
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
				text: 'ɾ��'
			}
		]
	});
	
	//�Ҽ��˵�����ؼ����� 
	function rightClickFn(grid,rowindex,e){
		e.preventDefault();
		grid.getSelectionModel().select(rowindex,0);
		rightClick.showAt(e.getXY());
	}
	
	/*
	 * Ԥ�����,����HRPԤ��ӿ�
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
				Msg.info('error', '��ǰ�ɹ�����Ԥ��,���ʵ�޸�:' + Result);
				return false;
			}
		}
		return true;
	}
	
	//�жϿ�����ظ���(�Ǹ�ֵ����)
	function  GetRepeatResult(store,colName,colValue,beginIndex,inciDesc,row){
		beginIndex=store.findExact(colName,colValue,beginIndex);
		if(beginIndex!=-1){
			changeBgColor(row, "yellow");
			Msg.info("warning","���� "+inciDesc+" �Ѵ����ڵ�"+(beginIndex+1)+"��!");
			changeBgColor(beginIndex, "yellow");
			GetRepeatResult(store,colName,colValue,beginIndex+1,inciDesc,row);
		}
	}
	
	/**
	 * �������ʴ��岢���ؽ��
	 */
	function GetPhaOrderInfo(item, group) {					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", gHospId,
					getDrugList);
		}
	}
	
	/**
	 * ���ط���
	 * 2017-05-22 ��ӵ�2������,������Ҫ��ֵ��record
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
		//ȡ����������Ϣ
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
			addComboData(ItmUomStore,data[10],data[25]);		//2016-01-21 ʹ�û�����λ
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
			//�Ա�����ۼ�
			if(gParam[9]=="Y" & data[13]!=""){
				if(Number(data[5])>Number(data[13])){
					Msg.info("error","��ǰ�ۼ۸�������ۼ�!");
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
			
			//�ӳ���
			var cost = rowData.get('Rp');
			var sp = rowData.get("Sp");
			var margin=0
			if(cost!=0){
				margin = accSub(accDiv(sp, cost), 1);
				rowData.set('Marginnow', margin);
			}
			
			//=====================�ж�����====================
			var vendor = Ext.getCmp("Vendor").getValue();
			var inci=record.get("InciDr");
			var DataList=vendor+"^"+inci+"^"+data[0];
			Ext.Ajax.request({
				url : 'dhcstm.utilcommon.csp?actiontype=Check',
				params : {DataList : DataList},
				method : 'POST',
				waitMsg : '��ѯ��...',
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
	 * ��λչ���¼�
	 */
	CTUom.on('expand', function(combo) {
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var record = DetailGrid.getStore().getAt(cell[0]);
		var InciDr = record.get("IncId");
		ItmUomStore.removeAll();
		ItmUomStore.load({params:{ItmRowid:InciDr}});
	});

	/**
	 * ��λ�任�¼�
	 */
	CTUom.on('select', function(combo) {
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		var record = DetailGrid.getStore().getAt(cell[0]);
		
		var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
		var BUom = record.get("BUomId");
		var ConFac = record.get("ConFacPur");   //��λ��С��λ��ת����ϵ
		var IngrUom = record.get("IngrUomId");    //Ŀǰ��ʾ����ⵥλ
		var Sp = Number(record.get("Sp"));
		var Rp = Number(record.get("Rp"));
		var NewSp = Number(record.get("NewSp"));
		
		if (value == null || value.length <= 0) {
			return;
		} else if (IngrUom == value) {
			return;
		} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
			record.set("Sp", Sp.div(ConFac));
			record.set("NewSp", NewSp.div(ConFac));
			record.set("Rp", Rp.div(ConFac));
		} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
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
	
	// �任����ɫ
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}
	
	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		region : 'north',
		autoHeight : true,
		labelAlign : 'right',
		title:gHVINGdRec==true?'��ⵥ�Ƶ�(��ֵ)':'��ⵥ�Ƶ�',
		frame : true,
		autoScroll : false,
		tbar : [SearchInGrBT, '-', SaveBT, '-',ClearBT, '-', 
				DeleteBT, '-', CompleteBT,'-',CancleCompleteBT,'-',PrintBT,'-',PrintHVCol],
		items:[{
			xtype:'fieldset',
			title:'�����Ϣ',
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

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, DetailGrid],
		renderTo : 'mainPanel'
	});
			
	RefreshGridColSet(DetailGrid,"DHCSTIMPORTM");   //�����Զ�������������������
	if(gIngrRowid!=null && gIngrRowid!='' && gFlag==1){
		Query(gIngrRowid);
	}
})