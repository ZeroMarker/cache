// /����: ���ݶ������
// /����: ���ݶ������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.31
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	if(gParam.length<1){
		GetParam();  //��ʼ����������
	}

	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '����',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : '��������...',
				groupId:session['LOGON.GROUPID'],
				childCombo : 'Vendor'
			});
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : new Date().add(Date.DAY, - 7)
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 120,
				value : new Date()
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
	var NotImp = new Ext.form.Checkbox({
				fieldLabel : 'δ���',
				id : 'NotImp',
				name : 'NotImp',
				anchor : '90%',
				width : 120,
				checked : true
			});
	var PartlyImp = new Ext.form.Checkbox({
		fieldLabel : '�������',
		id : 'PartlyImp',
		name : 'PartlyImp',
		anchor : '90%',
		width : 120,
		checked : true
	});
	/*
	var AllImp = new Ext.form.Checkbox({
		fieldLabel : 'ȫ�����',
		id : 'AllImp',
		name : 'AllImp',
		anchor : '90%',
		width : 120,
		checked : false
	});
	*/
	// ��Ӧ��
	var Vendor = new Ext.ux.VendorComboBox({
			id : 'Vendor',
			name : 'Vendor',
			anchor : '90%',
			params : {LocId : 'PhaLoc'}
	});
		
	// ��ѯ������ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ����',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
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
	/**
	 * ��շ���
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
					if(CheckDataBeforeSave()==true){
						save();
					}
				}
			});

	/**
	 * ������ⵥǰ���ݼ��
	 */		
	function CheckDataBeforeSave() {
		var nowdate = new Date();
		var record = MasterGrid.getSelectionModel().getSelected();
		if(record==null){
			Msg.info("warning", "û����Ҫ���������!");
			return false;
		}
		
		var Status = record.get("PoStatus");
		if (Status ==2) {
			Msg.info("warning", "�ö����Ѿ�ȫ����⣬���������!");
			return false;
		}			
		
		// �ж���ⲿ�ź͹������Ƿ�Ϊ��
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ����ⲿ��!");
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
		// 3.�ж��ظ���������
//		for (var i = 0; i < rowCount - 1; i++) {
//			for (var j = i + 1; j < rowCount; j++) {
//				var item_i = DetailStore.getAt(i).get("IncId");;
//				var item_j = DetailStore.getAt(j).get("IncId");;
//				if (item_i != "" && item_j != ""
//						&& item_i == item_j) {
//					changeBgColor(i, "yellow");
//					changeBgColor(j, "yellow");
//					Msg.info("warning", "�����ظ�������������!");
//					return false;
//				}
//			}
//		}
		// 4.������Ϣ�������
		for (var i = 0; i < rowCount; i++) {
			var expDateValue = DetailStore.getAt(i).get("ExpDate");
			var item = DetailStore.getAt(i).get("IncId");
			var BatchReq = DetailStore.getAt(i).get("BatchReq");
			if(BatchReq=='R'){
				var BatchNo = DetailStore.getAt(i).get("BatNo");
				if ((item != "") && (BatchNo==null || BatchNo=="")) {
					Msg.info("warning", "��"+(i+1)+"�����Ų���Ϊ��!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			var ExpReq = DetailStore.getAt(i).get("ExpReq");
			if(ExpReq=='R'){
				var ExpDate = new Date(Date.parse(expDateValue));
				if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
					Msg.info("warning", "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			var qty = DetailStore.getAt(i).get("AvaQty");
			if ((item != "") && (qty == null || qty <= 0)) {
				Msg.info("warning", "�����������С�ڻ����0!");
				var col=GetColIndex(DetailGrid,'AvaQty');
				DetailGrid.startEditing(i, col);
				changeBgColor(i, "yellow");
				return false;
			}
			var purqty=DetailStore.getAt(i).get("PurQty");
			var ImpQty=DetailStore.getAt(i).get("ImpQty");
			if((gParam[13]=="N"||gParam[13]=="")&&(qty>(purqty-ImpQty))){
				Msg.info("warning", "����������ܴ��ڶ�������!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			
			var realPrice = DetailStore.getAt(i).get("Rp");
			if ((item != "")&& (Ext.isEmpty(realPrice) || realPrice < 0)) {
				Msg.info("warning", "�����۲���С��0!");
				DetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}else if((item != "") && (realPrice == 0)){
				if(confirm('��' + (i+1) + '��:' + DetailStore.getAt(i).get('IncDesc') + ' ����Ϊ0, �Ƿ����?') == false){
					return false;
				}
			}
		}
		
		return true;
	}
	
	/**
	 * ������ⵥ
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
		var IngrTypeId = "";    //�������(2014-01-27:���θ�Ϊ��,���д���)
		var PurUserId = record.get("PurUserId");
		var StkGrpId = record.get("StkGrpId");
		var PoId=record.get("PoId");  //����id
		var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
		var ReqLoc=record.get("ReqLoc");  //�깺����
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
							// ˢ�½���
							var IngrRowid = jsonData.info;
							Msg.info("success", "����ɹ�!");
							// 7.��ʾ��ⵥ����
							// ��ת������Ƶ�����
							window.location.href='dhcstm.ingdrec.csp?Rowid='+IngrRowid+'&QueryFlag=1';
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
							
						}
					},
					scope : this
				});
		
	}

	/**
	 * ɾ��ѡ��������
	 */
	function deleteDetail() {
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);			
		DetailGrid.getStore().remove(record);
		DetailGrid.view.refresh();
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
			
	/**
	 * ��λչ���¼�
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
	 * ��λ�任�¼�
	 */
	CTUom.on('select', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				
				var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
				var BUom = record.get("BUomId");
				var ConFac = Number(record.get("ConFac"));   //��λ��С��λ��ת����ϵ					
				var PurUom = record.get("PurUomId");    //Ŀǰ��ʾ����ⵥλ
				var Sp = Number(record.get("Sp"));
				var Rp = Number(record.get("Rp"));
				
				if (value == null || value.length <= 0) {
					return;
				} else if (PurUom == value) {
					return;
				} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
					record.set("Sp", Sp.div(ConFac));
					record.set("Rp", Rp.div(ConFac));
				} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
					record.set("Sp", Sp.mul(ConFac));
					record.set("Rp", Rp.mul(ConFac));
				}
				record.set("PurUomId", combo.getValue());
	});
	
	// ��������
	var Phmnf = new Ext.ux.ComboBox({
				fieldLabel : '����',
				id : 'Phmnf',
				name : 'Phmnf',
				store : PhManufacturerStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '����...',
				filterName : 'PHMNFName',
				params : {LocId : 'PhaLoc'}
			});


	// ��ʾ��������
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ�񶩹�����!");
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

		//��ʼ����^��ֹ����^������^��Ӧ��id^����id^��ɱ�־^��˱�־^����״̬(δ��⣬������⣬ȫ�����)^�����id^�Ƿ����֧�����
		//^�������^��Աrowid^��������ϸ����
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
					Msg.info("error", "��ѯ������鿴��־!");
				}else{
					if(r.length>0){
						MasterGrid.getSelectionModel().selectFirstRow();
						MasterGrid.getView().focusRow(0);
					}
				}
			}
		});

	}
	// ��ʾ��ⵥ��ϸ����
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		DetailStore.load({params:{start:0,limit:999,Parref:Parref}});
	}
	
	function renderPoStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus='δ���';			
		}else if(value==1){
			PoStatus='�������';
		}else if(value==2){
			PoStatus='ȫ�����';
		}
		return PoStatus;
	}
	// ����·��
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","ReqLocDesc","ReqLoc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
				fields : fields
			});
	// ���ݼ�
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
				header : "������",
				dataIndex : 'PoNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�깺����",
				dataIndex : 'ReqLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'PoLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "����״̬",
				dataIndex : 'PoStatus',
				width : 90,
				align : 'left',
				sortable : true,
				renderer:renderPoStatus
			}, {
				header : "��������",
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
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	var MasterGrid = new Ext.ux.GridPanel({
				id : 'MasterGrid',
				region: 'west',
				title : '����',    
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

	// ��ӱ�񵥻����¼�
	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var PoId = MasterStore.getAt(rowIndex).get("PoId");
		DetailStore.load({params:{start:0,limit:999,Parref:PoId}});
	});
	
	// ������ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'ingdrecaction.csp?actiontype=QueryPoDetailForRec&Parref=&start=0&limit=999';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","Spec", "PurUomId", "PurUom", "AvaQty", "Rp",
			 "ManfId", "Manf", "Sp","BatNo",{name:"ExpDate",type:"date",dateFormat:DateFormat}, "BUomId", "ConFac","PurQty","ImpQty",
			 "BatchReq","ExpReq","ImpQtyAudited","SpecDesc","CerNo",{name:'CerExpDate',type:'date',dateFormat:DateFormat}];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoItmId",
				fields : fields
			});
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				pruneModifiedRecords:true
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "������ϸid",
				dataIndex : 'PoItmId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����RowId",
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
				header : "����",
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
									Msg.info("warning", "��������Ϊ��!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "��������С�ڻ����0!");
									return;
								}									
							}
						}
					}
				})
			}, {
				header : "��λ",
				dataIndex : 'PurUomId',
				width : 80,
				align : 'left',
				sortable : true,
				renderer : Ext.util.Format.comboRenderer2(CTUom,"PurUomId","PurUom"),
				editor : new Ext.grid.GridEditor(CTUom)
			}, {
				header : "����",
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
											Msg.info("warning", "���۲���Ϊ��!");
											return;
										}
										if (cost <= 0) {
											Msg.info("warning",
													"���۲���С�ڻ����0!");
											return;
										}
										
										var cell = DetailGrid.getSelectionModel().getSelectedCell();
										DetailGrid.startEditing(cell[0], 10);
									}
								}
							}
				})
			}, {
				header : "�ۼ�",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				
				sortable : true
			},{
				header : "��������",
				dataIndex : 'ManfId',
				width : 180,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(Phmnf),
				renderer : Ext.util.Format.comboRenderer2(Phmnf,"ManfId","Manf")
			}, {
				header : "����",
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
									Msg.info("warning", "���Ų���Ϊ��!");
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
				header : "��Ч��",
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
									Msg.info("warning", "��Ч�ڲ���Ϊ��!");
									return;
								}
								var nowdate = new Date();
								if (expDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT)) {
									Msg.info("warning", "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
									return;
								}								
							}
						}
					}
				})
			}, {
				header : "��������",
				dataIndex : 'PurQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "���������",		//2015-09-16 ����״̬���������˼���,�����Ϊ"������Ƶ�����"
				dataIndex : 'ImpQtyAudited',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "������Ƶ�����",		//2015-09-16 ����״̬���������˼���,�����Ϊ"������Ƶ�����"
				dataIndex : 'ImpQty',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "ת����",
				dataIndex : 'ConFac',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "������λ",
				dataIndex : 'BUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����Ҫ��",
				dataIndex : 'BatchReq',
				width : 80,
				align : 'center',
				hidden : true
			}, {
				header : "��Ч��Ҫ��",
				dataIndex : 'ExpReq',
				width : 80,
				align : 'center',
				hidden : true
			}, {
				header : "������",
				dataIndex : 'SpecDesc',
				width : 80,
				align : 'left'
			}, {
				header : "ע��֤��",
				dataIndex : 'CerNo',
				width : 80,
				align : 'left'
			}, {
				header : "ע��֤��Ч��",
				dataIndex : 'CerExpDate',
				renderer : Ext.util.Format.dateRenderer(DateFormat),
				width : 80,
				align : 'left'
			}]);

	var DetailGrid = new Ext.ux.EditorGridPanel({
				id : 'DetailGrid',
				region : 'center',
				title: '������ϸ',
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
						}else if(e.field=='BatNo'){
							if(e.record.get('BatchReq')!='R'){
								return;
							}
							var BatchNo = e.value;
							if(BatchNo==null || BatchNo==""){
								Msg.info("warning","���Ų���Ϊ��!");
								e.record.set('BatNo',e.originalValue);
								return;
							}
						}
					}
				}
			});
			
	/***
	**����Ҽ��˵�
	**/		
	DetailGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
		items: [ 
			{ 
				id: 'mnuDelete', 
				handler: deleteDetail, 
				text: 'ɾ��' 
			},{ 
				id: 'mnuSplit', 
				handler: splitDetail, 
				text: '�����ϸ' 
			}
		] 
	}); 
	
	//�Ҽ��˵�����ؼ����� 
	function rightClickFn(grid,rowindex,e){
		e.preventDefault();
		grid.getSelectionModel().select(rowindex,1);
		rightClick.showAt(e.getXY()); 
	}

	var rowsAdd = 1000;
	function splitDetail(item,e){
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		var row = cell[0];
		var record = DetailStore.getAt(row);
		var newRecord = new DetailStore.recordType(record.copy().data,++rowsAdd);
		DetailStore.insert(row+1,newRecord);
		DetailGrid.view.refresh();
	}

	// �任����ɫ
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}

	var HisListTab = new Ext.form.FormPanel({
		region : 'north',
		labelWidth : 60,
		title:'����Ƶ�-���ݶ���',
		labelAlign : 'right',
		frame : true,
		autoHeight : true,
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT],
		layout : 'column',
		items : [{
			columnWidth : 0.7,
			layout: 'column',
			xtype:'fieldset',
			title:'��ѯ����',
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
			title:'���ѡ��',
			style : 'padding:5px 0px 0px 5px;',
			defaults: {border:false},
			items:[{
				columnWidth: 1,
				xtype: 'fieldset',
				items: [SourceOfFund]
			}]
		}]
	});

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
					items : [
					HisListTab, MasterGrid, DetailGrid
				],
				renderTo : 'mainPanel'
			});
	//ҳ�������ɺ��Զ���������
	Query();
})