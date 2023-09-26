// /����: ����
function ImportByPo(Fn) {
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	if(gParam.length<1){
		GetParam();  //��ʼ����������
	}

	var PoPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '����',
				id : 'PoPhaLoc',
				name : 'PoPhaLoc',
				anchor : '90%',
				emptyText : '��������...',
				groupId:gGroupId,
				childCombo : 'PoVendor'
			});
	// ��ʼ����
	var StartDatex = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDatex',
				name : 'StartDatex',
				anchor : '90%',
				width : 120,
				value : new Date().add(Date.DAY, - 7)
			});
	// ��ֹ����
	var EndDatex = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDatex',
				name : 'EndDatex',
				anchor : '90%',
				width : 120,
				value : new Date()
			});
	var PoNotImp = new Ext.form.Checkbox({
				fieldLabel : 'δ���',
				id : 'PoNotImp',
				name : 'PoNotImp',
				anchor : '90%',
				checked : true
			});
	var PoPartlyImp = new Ext.form.Checkbox({
		fieldLabel : '�������',
		id : 'PoPartlyImp',
		name : 'PoPartlyImp',
		anchor : '90%',
		checked : true
	});
	// ��Ӧ��
	var PoVendor = new Ext.ux.VendorComboBox({
			id : 'PoVendor',
			name : 'PoVendor',
			anchor : '90%',
			params : {LocId : 'PoPhaLoc'}
	});
	// ��ⵥ��
	var PoNo = new Ext.form.TextField({
		fieldLabel : '������',
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
	
		
	// ��ѯ������ť
	var PoSearchBT = new Ext.Toolbar.Button({
				id : "PoSearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ����',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					PoQuery();
				}
			});


	// ��հ�ť
	var PoClearBT = new Ext.Toolbar.Button({
				id : "PoClearBT",
				text : '���',
				tooltip : '������',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					PoclearData();
				}
			});
	/**
	 * ��շ���
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

	// ���水ť
	var PoSaveBT = new Ext.Toolbar.Button({
				id : "PoSaveBT",
				text : '����',
				tooltip : '�������',
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
	 * ������ⵥǰ���ݼ��
	 */		
	function PoCheckDataBeforeSave() {
		var nowdate = new Date();
		var record = PoMasterGrid.getSelectionModel().getSelected();
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
		var PoPhaLoc = Ext.getCmp("PoPhaLoc").getValue();
		if (PoPhaLoc == null || PoPhaLoc.length <= 0) {
			Msg.info("warning", "��ѡ����ⲿ��!");
			return false;
		}
		
		// 1.�ж���������Ƿ�Ϊ��
		var rowCount = PoDetailGrid.getStore().getCount();
		// ��Ч����
		var count = 0;
		for (var i = 0; i < rowCount; i++) {
			var item = PoDetailStore.getAt(i).get("IncId");
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
//				var item_i = PoDetailStore.getAt(i).get("IncId");;
//				var item_j = PoDetailStore.getAt(j).get("IncId");;
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
			var expDateValue = PoDetailStore.getAt(i).get("ExpDate");
			var item = PoDetailStore.getAt(i).get("IncId");
			var BatchReq = PoDetailStore.getAt(i).get("BatchReq");
			if(BatchReq=='R'){
				var BatchNo = PoDetailStore.getAt(i).get("BatNo");
				if ((item != "") && (BatchNo==null || BatchNo=="")) {
					Msg.info("warning", "��"+(i+1)+"�����Ų���Ϊ��!");
					PoDetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			var ExpReq = PoDetailStore.getAt(i).get("ExpReq");
			if(ExpReq=='R'){
				var ExpDate = new Date(Date.parse(expDateValue));
				if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
					Msg.info("warning", "��Ч�ڲ���С�ڻ���ڵ�ǰ����!");
					PoDetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
			}
			var qty = PoDetailStore.getAt(i).get("AvaQty");
			if ((item != "") && (qty == null || qty <= 0)) {
				Msg.info("warning", "�����������С�ڻ����0!");
				var col=GetColIndex(PoDetailGrid,'AvaQty');
				PoDetailGrid.startEditing(i, col);
				changeBgColor(i, "yellow");
				return false;
			}
			var purqty=PoDetailStore.getAt(i).get("PurQty");
			var ImpQty=PoDetailStore.getAt(i).get("ImpQty");
			if((gParam[13]=="N"||gParam[13]=="")&&(qty>(purqty-ImpQty))){
				Msg.info("warning", "����������ܴ��ڶ�������!");
				PoDetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			
			var realPrice = PoDetailStore.getAt(i).get("Rp");
			if ((item != "")&& (realPrice == null || realPrice <= 0)) {
				Msg.info("warning", "�����۲���С�ڻ����0!");
				PoDetailGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
		}
		
		return true;
	}
	
	/**
	 * ������ⵥ
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
		var IngrTypeId = "";    //�������(2014-01-27:���θ�Ϊ��,���д���)
		var PurUserId = record.get("PurUserId");
		var StkGrpId = record.get("StkGrpId");
		var PoId=record.get("PoId");  //����id
		var ReqLoc=record.get("ReqLoc");  //�깺����
		
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
							// ˢ�½���
							var IngrRowid = jsonData.info;
							Msg.info("success", "����ɹ�!");
							// 7.��ʾ��ⵥ����
							// ��ת������Ƶ�����
							Fn(IngrRowid);
							Powin.close();
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
	function PodeleteDetail() {
		var cell = PoDetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = PoDetailGrid.getStore().getAt(row);			
		PoDetailGrid.getStore().remove(record);
		PoDetailGrid.view.refresh();
	}
	

	// ��λ
	var PoCTUom = new Ext.form.ComboBox({
				fieldLabel : '��λ',
				id : 'PoCTUom',
				name : 'PoCTUom',
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
	PoCTUom.on('expand', function(combo) {
				var cell = PoDetailGrid.getSelectionModel().getSelectedCell();
				var record = PoDetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("IncId");
				ItmUomStore.setBaseParam('ItmRowid',InciDr);
				ItmUomStore.removeAll();
				PoCTUom.store.load();
			});

	/**
	 * ��λ�任�¼�
	 */
	PoCTUom.on('select', function(combo) {
				var cell = PoDetailGrid.getSelectionModel().getSelectedCell();
				var record = PoDetailGrid.getStore().getAt(cell[0]);
				
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
				params : {LocId : 'PoPhaLoc'}
			});


	// ��ʾ��������
	function PoQuery() {
		var PoPhaLoc = Ext.getCmp("PoPhaLoc").getValue();
		if (PoPhaLoc =='' || PoPhaLoc.length <= 0) {
			Msg.info("warning", "��ѡ�񶩹�����!");
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
		//��ʼ����^��ֹ����^������^��Ӧ��id^����id^��ɱ�־^��˱�־^����״̬(δ��⣬������⣬ȫ�����)^�����id^�Ƿ����֧�����
		//^�������^��Աrowid^��������ϸ����
		var ListParam=startDate+'^'+endDate+'^'+PoNo+'^'+PoVendor+'^'+PoPhaLoc+'^Y^1^'+Status+'^^^^^Y';
		var Page=PoGridPagingToolbar.pageSize;
		PoMasterStore.removeAll();
		PoDetailGrid.store.removeAll();
		PoMasterStore.setBaseParam("ParamStr",ListParam);
		PoMasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
				if(r.length==0){
     				Msg.info("warning", "δ�ҵ����ϵĵ���!");
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
	// ��ʾ��ⵥ��ϸ����
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		PoDetailStore.load({params:{start:0,limit:999,Parref:Parref}});
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
	var PoGridPagingToolbar = new Ext.PagingToolbar({
		store:PoMasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
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

	// ��ӱ�񵥻����¼�
	PoMasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var PoId = PoMasterStore.getAt(rowIndex).get("PoId");
		PoDetailStore.load({params:{start:0,limit:999,Parref:PoId}});
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
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "AvaQty", "Rp",
			 "ManfId", "Manf", "Sp","BatNo",{name:"ExpDate",type:"date",dateFormat:ARG_DATEFORMAT}, "BUomId", "ConFac","PurQty","ImpQty",
			 "BatchReq","ExpReq","ImpQtyAudited"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoItmId",
				fields : fields
			});
	// ���ݼ�
	var PoDetailStore = new Ext.data.Store({
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
				renderer : Ext.util.Format.comboRenderer2(PoCTUom,"PurUomId","PurUom"),
				editor : new Ext.grid.GridEditor(PoCTUom)
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
										
										var cell = PoDetailGrid.getSelectionModel().getSelectedCell();
										PoDetailGrid.startEditing(cell[0], 10);
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
								var cell = PoDetailGrid.getSelectionModel().getSelectedCell();
								var col=GetColIndex(PoDetailGrid,'BatNo');
								PoDetailGrid.startEditing(cell[0], col);
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
				header : "���������",
				dataIndex : 'ImpQtyAudited',
				width : 80,
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
								Msg.info("warning","��Ч�ڲ���Ϊ��!");
								e.record.set('ExpDate',e.originalValue);
								return;
							}else{
								expDate=expDate.format(ARG_DATEFORMAT);
							}
							var flag=ExpDateValidator(expDate);
							if(flag==false){
								Msg.info('warning','�����ʾ���ʧЧ������'+gParam[2]+'��!');
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
	PoDetailGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
		items: [ 
			{ 
				id: 'mnuDelete', 
				handler: PodeleteDetail, 
				text: 'ɾ��' 
			},{ 
				id: 'mnuSplit', 
				handler: PosplitDetail, 
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
	function PosplitDetail(item,e){
		var cell = PoDetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		var row = cell[0];
		var record = PoDetailStore.getAt(row);
		var newRecord = new PoDetailStore.recordType(record.copy().data,++rowsAdd);
		PoDetailStore.insert(row+1,newRecord);
		PoDetailGrid.view.refresh();
	}

	// �任����ɫ
	function changeBgColor(row, color) {
		PoDetailGrid.getView().getRow(row).style.backgroundColor = color;
	}

	var PoHisListTab = new Ext.form.FormPanel({
		labelWidth : 60,
		title:'����Ƶ�-���ݶ�������',
		labelAlign : 'right',
		frame : true,
		tbar : [PoSearchBT, '-',PoClearBT, '-',PoSaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'��ѯ����',
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

	// ҳ�沼��
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
		                title: '����',		   		  
		                layout: 'fit', // specify layout manager for items
		                items: PoMasterGrid
		            }, {
		                region: 'south',
		                title: '������ϸ',
		                height: 270, 
		                layout: 'fit', // specify layout manager for items
		                items: PoDetailGrid
		            }
       			]
			});
	//ҳ�������ɺ��Զ���������
	Powin.show()
	PoNo.focus(true,100)
	
}