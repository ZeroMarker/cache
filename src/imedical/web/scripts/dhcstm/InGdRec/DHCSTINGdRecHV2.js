// /����: ��ⵥ�Ƶ�
// /����: ��ⵥ�Ƶ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.06.27

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gHospId=session['LOGON.HOSPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var loadMask=null;
	if(gParam.length<1){
		GetParam();  //��ʼ����������
	}

	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '��ⲿ��',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor:'90%',
		emptyText : '��ⲿ��...',
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
	// �ɹ���Ա
	var PurchaseUser = new Ext.ux.ComboBox({
		fieldLabel : '�ɹ���Ա',
		anchor : '90%',
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
		anchor : '90%',
		checked : false,
		boxLabel:'���ۻ�Ʊ'
	});
	var SourceOfFund = new Ext.ux.ComboBox({
		fieldLabel : '�ʽ���Դ',
		id : 'SourceOfFund',
		anchor : '90%',
		store : SourceOfFundStore,
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : false
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
			var seled=GrMasterInfoGrid.getSelectionModel().getSelected();
			if (Ext.isEmpty(seled)) {
			Msg.info("warning", "û����Ҫ��ӡ����ⵥ!");
			return;
			}
			var ingr=seled.get("Ingr")
			if (Ext.isEmpty(ingr)) {
			Msg.info("warning", "û����Ҫ��ӡ����ⵥ!");
			return;
		}
			PrintRec(ingr);
		}
	});

      // ��ӡ��ⵥ��ť
	var PrintHVCol= new Ext.Toolbar.Button({
		id : "PrintHVCol",
		text : '��ֵ���ܴ�ӡ',
		tooltip : '��ӡ��ֵ��ⵥƱ��',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			var seled=GrMasterInfoGrid.getSelectionModel().getSelected();
			if (Ext.isEmpty(seled)) {
			Msg.info("warning", "û����Ҫ��ӡ����ⵥ!");
			return;
			}
			var ingr=seled.get("Ingr")
			if (Ext.isEmpty(ingr)) {
			Msg.info("warning", "û����Ҫ��ӡ����ⵥ!");
			return;
		}
			PrintRecHVCol(ingr);
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
			clearData();
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
		  Complete();
		}
	});
			
	/**
	 * ��շ���
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
	
	// ���Ӱ�ť
	var AddBT = new Ext.Toolbar.Button({
		id : "AddBT",
		text : '����һ��',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_add',
		handler : function() {
			// �ж��Ƿ�ѡ����ⲿ�ź͹�������
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "��ѡ����ⲿ��!");
				return;
			}
			var operateInType = Ext.getCmp("OperateInType")
					.getValue();
			if ((gParam[8]=="Y")&(operateInType == null || operateInType.length <= 0)) {
				Msg.info("warning", "��ѡ���������!");
				return;
			}
			// ����һ��
			addNewRow();
			// �����ť�Ƿ����
			//��ѯ^���^����^����^ɾ��^���^ȡ�����
			
		}
	});
	
	/**
	 * ����һ��
	 */
	function addNewRow() {
		if(DetailGrid.activeEditor != null){
				DetailGrid.activeEditor.completeEdit();
			}
		var col=GetColIndex(DetailGrid,"HVBarCode");
		var lastInvNo="";
		// �ж��Ƿ��Ѿ��������
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
	 * ������ⵥǰ���ݼ��
	 */		
	function CheckDataBeforeSave(rowIndex) {
		var nowdate = new Date();
		// �ж���ⲿ�ź͹������Ƿ�Ϊ��
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ����ⲿ��!");
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
		var rowData = DetailStore.getAt(rowIndex);
		var item = rowData.get("IncId");
		if(item == ''){
			Msg.info("warning", "�����������ϸ!");
			return false;
		}
		
		var expDateValue = rowData.get("ExpDate");
		var ExpReq = rowData.get('ExpReq');
		if(ExpReq=='R'){
			var ExpDate = new Date(Date.parse(expDateValue));
			if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
				Msg.info("warning", "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
				DetailGrid.getSelectionModel().select(rowIndex, 1);
				changeBgColor(rowIndex, "yellow");
				return false;
			}
		}
		var BatchNo = rowData.get('BatchNo');
		var BatchReq = rowData.get('BatchReq');
		if(BatchReq=='R'){
			if ((item != "") && (BatchNo=="")) {
				Msg.info("warning", "���Ų���Ϊ��!");
				DetailGrid.getSelectionModel().select(rowIndex, 1);
				changeBgColor(rowIndex, "yellow");
				return false;
			}
		}
		var qty = rowData.get("RecQty");
		if ((item != "") && (qty == null || qty <= 0)) {
			Msg.info("warning", "�����������С�ڻ����0!");
			DetailGrid.getSelectionModel().select(rowIndex, 1);
			changeBgColor(rowIndex, "yellow");
			return false;
		}
		var inpoqty=rowData.get("InPoQty");
		if((gParam[13]=="N"||gParam[13]=="")&&(qty>inpoqty)&&(inpoqty!="")){
			Msg.info("warning", "����������ܴ��ڶ�������!");
			var cell = DetailGrid.getSelectionModel()
				.getSelectedCell();
			DetailGrid.getSelectionModel().select(cell[0], 1);
			changeBgColor(rowIndex, "yellow");
			return false;
		}
		
		var realPrice = rowData.get("Rp");
		if ((item != "")&& (realPrice == null || realPrice <= 0)) {
			Msg.info("warning", "�����۲���С�ڻ����0!");
			DetailGrid.getSelectionModel().select(rowIndex, 1);
			changeBgColor(rowIndex, "yellow");
			return false;
		}
		var Sp = rowData.get("Sp");
//		if (Sp<=0){
//			Msg.info("warning","��"+(rowIndex+1)+"���ۼ۲���ΪС�ڻ����0");
//			DetailGrid.getSelectionModel().select(rowIndex, 1);
//			changeBgColor(rowIndex, "yellow");
//			return false;
//		}
		
		return true;
	}
	
	/**
	 * ������ⵥ
	 */
	function saveOrder(rowIndex) {
		var rowData = DetailStore.getAt(rowIndex);
		var VenId=rowData.get("Vendor")
		var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
		var ingr=""
		if(Ext.isEmpty(VenId)){
			Msg.info("error", "��Ӧ�̲���Ϊ��!")
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
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "����ɹ�!");
					rowData.commit();
					if(loadMask){loadMask.hide();}
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
					if(loadMask){loadMask.hide();}
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
		"QualityNo","SxNo","Remark","Remarks","MtDesc","PubDesc","BUomId","ConFacPur","MtDr","HVFlag","HVBarCode","Spec","SterilizedNo","InPoQty","BatchReq","ExpReq","BarCode","AdmNo",{name:'AdmExpdate',type:'date',dateFormat:DateFormat}];
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

	/**
	 * �����ⵥ
	 */
	function Complete() {
		// �ж���ⵥ�Ƿ������
		var seled=GrMasterInfoGrid.getSelectionModel().getSelected();
		if (Ext.isEmpty(seled)) {
			Msg.info("warning", "û����Ҫ��ɵ���ⵥ!");
			return;
		}
		var ingr=seled.get("Ingr")
		if (Ext.isEmpty(ingr)) {
			Msg.info("warning", "û����Ҫ��ɵ���ⵥ!");
			return;
		}
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=MakeComplete";
		Ext.Ajax.request({
			url : url,
			params : {Rowid:ingr,User:gUserId,GroupId:gGroupId},
			method : 'POST',
			waitMsg : '��ѯ��...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					// ��˵���
					Msg.info("success", "�ɹ�!");
					GrMasterInfoGrid.getStore().remove(seled);
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
					// ����һ��
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
			sortable : true
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
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (field.getValue()!="" && e.getKey() == Ext.EventObject.ENTER){
							var Barcode=field.getValue();
							var row=DetailGrid.getSelectionModel().getSelectedCell()[0];
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
										var poi=itmArr[15],batchno=itmArr[16],expdate=itmArr[17]
										var certNo=itmArr[22];
										var certExpDate=itmArr[23];
										if((type!="Reg" && type!="G")||(type=="G" && lastDetailAudit=="Y")){
											Msg.info("warning","�������Ѱ������!");
											DetailGrid.store.getAt(row).set("HVBarCode","");
											return;
										}else if(type=="G" && lastDetailAudit!="Y"){
											Msg.info("warning","��δ��ɻ�δ��˵�"+lastDetailOperNo);
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
										Msg.info("error","��������δע��!");
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
			header : "ȷ��",
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
							loadMask=ShowLoadMask(Ext.getBody(),"������...");
							if(CheckDataBeforeSave(rowIndex)==true){
								// ������ⵥ
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
							var cell = DetailGrid.getSelectionModel().getSelectedCell();
							var batchNo = field.getValue();
							if (batchNo == null || batchNo.length <= 0) {
								Msg.info("warning", "���Ų���Ϊ��!");
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
			sortable : true
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
//							if (cost <= 0) {
//								Msg.info("warning",
//										"����ۼ۲���С�ڻ����0!");
//								return;
//							}
							// ����ָ���е��ۼ۽��
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
							var cell = DetailGrid.getSelectionModel()
									.getSelectedCell();
//							DetailGrid.startEditing(cell[0], 7);
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
			header : "��Ӧ��",
			dataIndex : 'VendorDesc',
			width : 100,
			align : 'left',
			sortable : true
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
		tbar:[AddBT,'-',{height:30,width:70,text:'������',iconCls:'page_gear',handler:function(){GridColSet(DetailGrid,"DHCSTIMPORTM");}}],
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
						//Msg.info("warning", "���۲���С�ڻ����0!");
						//e.record.set('Rp',e.originalValue);
						//return;
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
						margin = accDiv(sp, cost);
						if((gParam[5]!=0) && (margin>gParam[5] || margin<1)){
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
						Msg.info("warning","�÷�Ʊ���Ѵ����ڱ����ⵥ");
						e.record.set('InvNo',e.originalValue);
					}
				}
			}
		}
	});

	
	/**
	 * �������ʴ��岢���ؽ��
	 */
	function GetPhaOrderInfo(item, group) {					
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", gHospId,
					getDrugList);
		}
	}
	
	//���������ȡ������Ϣ
	function GetPhaOrderInfo2(item, group) {
		if (item != null && item.length > 0) {
			GetPhaOrderByBarcodeWindow(item, group, App_StkTypeCode, "", "N", "0", gHospId,
					getDrugList);
		}
	}
	/**
	 * ���ط���
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
		// ѡ����
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
		//ȡ����������Ϣ
		var url = DictUrl
			+ "ingdrecaction.csp?actiontype=GetItmInfo&IncId="
			+ inciDr+"&Params="+Params;
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '��ѯ��...',
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
					//�Ա�����ۼ�
					if(gParam[9]=="Y" & data[13]!=""){
						if(Number(data[5])>Number(data[13])){
							Msg.info("error","��ǰ�ۼ۸�������ۼ�!");
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
	// ����·��
var MasterInfoUrl = DictUrl	+ 'ingdrecaction.csp?actiontype=Query';
// ͨ��AJAX��ʽ���ú�̨����
var proxy = new Ext.data.HttpProxy({
			url : MasterInfoUrl,
			method : "POST"
		});

// ָ���в���
var fields = ["Ingr","IngrNo","Vendor","VendorDesc","CreateUser", "Complete"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			fields : fields
		});
// ���ݼ�
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
			header : "��ⵥ��",
			dataIndex : 'IngrNo',
			width : 160,
			align : 'left',
			sortable : true
		},{
			header : "��Ӧ��rowid",
			dataIndex : 'Vendor',
			width : 250,
			align : 'left',
			hidden : true,
			sortable : true
		}, {
			header : "��Ӧ��",
			dataIndex : 'VendorDesc',
			width : 250,
			align : 'left',
			sortable : true
		},{
			header : "��ɱ�־",
			dataIndex : 'Complete',
			width : 70,
			align : 'left',
			sortable : true
		}]);
var GrMasterInfoGrid = new Ext.grid.GridPanel({
			id : 'GrMasterInfoGrid',
			region : 'center',
			title : '��ⵥ',
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
		title:'��ⵥ�Ƶ�(��ֵ��ʽ��)',
		frame : true,
		autoScroll : false,
		tbar : [ClearBT, '-',CompleteBT,'-',PrintBT,'-',PrintHVCol],
		items:[{
			xtype:'fieldset',
			title:'�����Ϣ',
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
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [panel, DetailGrid]
	});
			
	RefreshGridColSet(DetailGrid,"DHCSTIMPORTM");   //�����Զ�������������������
})