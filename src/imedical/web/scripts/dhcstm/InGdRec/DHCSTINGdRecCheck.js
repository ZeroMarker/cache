// /����: ��ⵥ����
// /����: ��ⵥ����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.18
		
Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId = session['LOGON.CTLOCID'];
	var gIngrRowid="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '��ⲿ��',
		id : 'PhaLoc',
		name : 'PhaLoc',
		width : 200,
		emptyText : '��ⲿ��...',
		groupId:gGroupId,
		childCombo : 'Vendor'
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		params : {LocId : 'PhaLoc'}
	});
		
	// ��ⵥ��
	var InGrNo = new Ext.form.TextField({
		fieldLabel : '��ⵥ��',
		id : 'InGrNo',
		name : 'InGrNo',
		anchor : '90%',
		width : 120,
		disabled : false
	});

	// ��Ʊ��
	var InvNo = new Ext.form.TextField({
				fieldLabel : '��Ʊ��',
				id : 'InvNo',
				name : 'InvNo',
				anchor : '90%',
				width : 120,
				disabled : false
			});
	
	// ��ʼ����
	var StartDate= new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		width : 120,
		value : DefaultStDate()
	});

	// ��������
	var EndDate= new Ext.ux.DateField({
		fieldLabel : '��������',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		width : 120,
		value : DefaultEdDate()
	});



	// ��˱�־
	var AuditFlag = new Ext.form.Checkbox({
		boxLabel : '���������',
		id : 'AuditFlag',
		name : 'AuditFlag',
		anchor : '90%',
		width : 150,
		checked : false,
		disabled:false
	});

	// ������ť
	var searchBT = new Ext.Toolbar.Button({
				text : '����',
				tooltip : '���������ⵥ��Ϣ',
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
			Msg.info("warning","��ʼ���ڻ��ֹ���ڲ���Ϊ�գ�");
			return;
		}
		var StartDate = StartDate.format(ARG_DATEFORMAT).toString();
		var EndDate = EndDate.format(ARG_DATEFORMAT).toString();
		var InGrNo = Ext.getCmp("InGrNo").getValue();
		var Vendor = Ext.getCmp("Vendor").getValue();
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "��ѡ����ⲿ��!");
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "��ѡ��ʼ���ںͽ�ֹ����!");
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

	// ѡȡ��ť
	var acceptBT = new Ext.Toolbar.Button({
				text : '����',
				tooltip : '�������',
				iconCls : 'page_goto',
				height:30,
				width:70,
				handler : function() {
					acceptData();
				}
			});

	/**
	 * ����������Ϣ
	 */
	function acceptData() {
		if(gIngrRowid==""){
			Msg.info("warning", "��ѡ����ⵥ!");
			return;
		}
		var ListDetail="";
		var rowCount = GrDetailInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = GrDetailInfoStore.getAt(i);	
			//���������ݷ����仯ʱִ����������
			if(rowData.data.newRecord || rowData.dirty){
				var Ingri=rowData.get("Ingri");
				var CheckPort = rowData.get("CheckPort");
				var CheckRepNo = rowData.get("CheckRepNo");
				var CheckRepDate =Ext.util.Format.date(rowData.get("CheckRepDate"),ARG_DATEFORMAT);
				var AdmNo = rowData.get("AdmNo");
				var AdmExpdate =Ext.util.Format.date(rowData.get("AdmExpdate"),ARG_DATEFORMAT);
				var Remark = rowData.get("Remark");				
				//20160606zhangxiao
				var AOGTemp = rowData.get("AOGTemp"); //�����¶�
				var PackGood=rowData.get('PackGood')
				var AcceptCon=rowData.get("AcceptCon");	//���ս���
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
			Msg.info("warning", "��ά��������Ϣ");
			return;
		}
		var url = DictUrl
				+ "ingdrecaction.csp?actiontype=SaveCheckInfo";
		Ext.Ajax.request({
					url : url,
					params:{IngrId:gIngrRowid,UserId:gUserId,ListDetail:ListDetail},
					method : 'POST',
					waitMsg : '������...',
					success : function(result, request) {
	
						var jsonData = Ext.util.JSON
							.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ˢ�½���
							Msg.info("success", "���ճɹ�!");
							// 7.��ʾ��ⵥ����
				
							Query(gIngrRowid);
							GrMasterInfoStore.reload();

						} else {
							var ret=jsonData.info;
							
							Msg.info("error", "����ʧ�ܣ�"+ret);
						}
					},
					scope : this
				});
		
	}
	// ��հ�ť
	var clearBT = new Ext.Toolbar.Button({
				text : '���',
				tooltip : '������',
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

	// 3�رհ�ť
	var closeBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'close',
				handler : function() {
					window.close();
				}
			});
	var PackGood = new Ext.grid.CheckColumn({
		header:'���װ���',
		dataIndex:'PackGood',
		width : 70,
		sortable:true
	});
	var ProdCertif = new Ext.grid.CheckColumn({
		header:'�кϸ�֤',
		dataIndex:'ProdCertif',
		width : 70,
		sortable:true
	});
	var AcceptConStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['�ϸ�', '�ϸ�'], ['���ϸ�', '���ϸ�']]
	});
	var AcceptCon = new Ext.form.ComboBox({
		fieldLabel : '���ս���',
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
		header : "��ⱨ��",
		dataIndex : 'CheckRepNo',
		width : 90,
		align : 'center'
	});
	
	var Token = new Ext.grid.CheckColumn({
		header : '��Ʒ��ʶ',
		dataIndex : 'Token',
		align : 'center'
	});
	
	var LocalToken = new Ext.grid.CheckColumn({
		header : '���ı�ʶ',
		dataIndex : 'LocalToken',
		align : 'center'
	});
	//ѡ����Ҫ���ƻ����������Ϣ
	var CheckTypeData=[['�кϸ�֤','1']];
	
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
		fieldLabel : 'ѡ��Ĭ��ȫ������',
		triggerAction:'all', //ȡ���Զ�����
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
				var CheckRepNo = rowData.get("CheckRepNo"); /// ��ⱨ��
				var PackGood=rowData.get('PackGood'); ///���װ���
				var Token = rowData.get("Token"); // ��Ʒ��ʶ
				var LocalToken = rowData.get("LocalToken"); ///���ı�ʶ
				var ProdCertif=rowData.get("ProdCertif"); //�кϸ�֤
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
				var CheckRepNo = rowData.get("CheckRepNo"); /// ��ⱨ��
				var PackGood=rowData.get('PackGood'); ///���װ���
				var Token = rowData.get("Token"); // ��Ʒ��ʶ
				var LocalToken = rowData.get("LocalToken"); ///���ı�ʶ
				var ProdCertif=rowData.get("ProdCertif"); //�кϸ�֤
				if (typeid==1) {
					rowData.set("ProdCertif","N");
				}
			}
	}
	// ����·��
	var MasterInfoUrl = DictUrl	+ 'ingdrecaction.csp?actiontype=Query';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "GET"
			});

	// ָ���в���
	var fields = ["IngrId","IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
			"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
			"StkGrp","RpAmt","SpAmt","AcceptUser"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "IngrId",
				fields : fields
			});
	// ���ݼ�
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
				header : "��ⵥ��",
				dataIndex : 'IngrNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : '������',
				dataIndex : 'AcceptUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'CreateDate',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : '�ɹ�Ա',
				dataIndex : 'PurchUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "��ɱ�־",
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
				title: '��ⵥ',
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
	
	// ����·��
	var DetailInfoUrl = DictUrl
					+ 'ingdrecaction.csp?actiontype=QueryDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	// ָ���в��� 	
	var fields = ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb",  "Margin", "RecQty",
			"Remarks", "IncCode", "IncDesc", "Spec", "InvNo", "Manf", "Rp", "RpAmt",
			"Sp", "SpAmt", "InvDate","QualityNo", "SxNo","Remark","MtDesc","PubDesc",
			"CheckPort","CheckRepNo",{name:'CheckRepDate',type:'date',dateFormat:DateFormat},"AdmNo",
			{name:'AdmExpdate',type:'date',dateFormat:DateFormat},"CheckPack","AOGTemp","PackGood","AcceptCon","SpecDesc",
			"Token","LocalToken","CheckRemarks","ProdCertif"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Ingri",
				fields : fields
			});
	// ���ݼ�
	var GrDetailInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	/*
	 * �����ж����Tip��ʾ
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
				header : '���ʴ���',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'IncDesc',
				width : 160,
				align : 'left',
				sortable : true,
				renderer : ShowCreditTip()
			}, {
				header : '���',
				dataIndex : 'Spec',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'SpecDesc',
				width : 80,
				align : 'left'
			}, {
				header : "��������",
				dataIndex : 'Manf',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'BatchNo',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "��Ч��",
				dataIndex : 'ExpDate',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "��λ",
				dataIndex : 'IngrUom',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'RecQty',
				width : 50,
				align : 'right',
				sortable : true
			}, PackGood,ProdCertif,{
				header : "�����¶�",
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
				header : "���ս���",
				dataIndex : 'AcceptCon',
				width : 80,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(AcceptCon)
			}, {
				header : "���ڰ�",
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
					header : "��������",
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
				header : '���ձ�ע',
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
				header : "ժҪ",
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
				header : "����",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "�ۼ�",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "��Ʊ��",
				dataIndex : 'InvNo',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "��Ʊ����",
				dataIndex : 'InvDate',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "���۽��",
				dataIndex : 'RpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}]);
	GrDetailInfoCm.defaultSortable = true;
	var GrDetailInfoGrid = new Ext.ux.EditorGridPanel({
				region: 'center',
				id : 'GrDetailInfoGrid',
				title : '��ⵥ��ϸ',
				cm : GrDetailInfoCm,
				sm : new Ext.grid.CellSelectionModel({}),
				store : GrDetailInfoStore,
				trackMouseOver : true,
				tbar:new Ext.Toolbar({items:[CheckTypeCombo,"-",Checkall]}),
				plugins: [PackGood,CheckRepNo,Token,LocalToken,ProdCertif],
				viewConfig : {
					getRowClass : function(record,rowIndex,rowParams,store){
						var ExpDate = record.get("ExpDate");
						var ExpDateFlag = 0;	//1:����, 2:30�쾯ʾ
						if(!Ext.isEmpty(ExpDate)){
							var Today = new Date().format(DateFormat);		//��ExpDateͳһ��ʽ(ExpDateΪ�ַ���,ʹ��HIS���ڸ�ʽ)
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
				title:'��ⵥ��ѯ������',
				layout: 'fit',
				tbar : [searchBT, '-', acceptBT, '-', clearBT],
				items:[{
					xtype:'fieldset',
					title:"��ѯ����",
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
			
		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
				title : '��ⵥ����',
				layout : 'border',
				items : [InfoForm, GrMasterInfoGrid, GrDetailInfoGrid]
		});
})