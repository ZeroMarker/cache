// /����: ��ⵥ����
// /����: ��ⵥ����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.18
		
Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gIngrRowid="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
    if(gParam.length<1){
		GetParam();  //��ʼ����������
	}	
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ�������������� wyx ��������ȡ��������gParamCommon[9]

	}
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '��ⲿ��',
		id : 'PhaLoc',
		name : 'PhaLoc',
		width : 200,
		emptyText : '��ⲿ��...',
		groupId:gGroupId
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		width : 200
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
		value : new Date()
	});

	// ��������
	var EndDate= new Ext.ux.DateField({
		fieldLabel : '��������',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		width : 120,
		value : new Date()
	});



	// ��˱�־
	var AuditFlag = new Ext.form.Checkbox({
		boxLabel : '�����',
		id : 'AuditFlag',
		name : 'AuditFlag',
		anchor : '90%',
		width : 150,
		checked : true,
		disabled:false
	});
	// ��ɱ�־
	var CompleteFlag = new Ext.form.Checkbox({
		boxLabel : '�����(δ���)',
		id : 'CompleteFlag',
		name : 'CompleteFlag',
		anchor : '90%',
		width : 150,
		checked : false,
		disabled:false
	});
	
	// ������ť
	var searchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ��ⵥ��Ϣ',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchDurgData();
				}
			});

	function searchDurgData() {
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
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
		var AuditFlag= Ext.getCmp("AuditFlag").getValue();
		if(AuditFlag==true){
			AuditFlag="Y";
		}else{
			AuditFlag="N";
		}
		var CompleteFlag= Ext.getCmp("CompleteFlag").getValue();
		if(CompleteFlag==true){
			CompleteFlag="Y";
		}else{
			CompleteFlag="N";
		}
		if (AuditFlag=="Y"){CompleteFlag=""}
		var InvNo= Ext.getCmp("InvNo").getValue();
		var ListParam=StartDate+'^'+EndDate+'^'+InGrNo+'^'+Vendor+'^'+PhaLoc+'^'+CompleteFlag+'^^'+AuditFlag+'^'+InvNo;
		var Page=GridPagingToolbar.pageSize;
		//GrMasterInfoStore.baseParams['ParamStr']=ListParam;
		//GrMasterInfoStore.baseParams={ParamStr:ListParam};
		GrMasterInfoStore.setBaseParam('ParamStr',ListParam);
		GrMasterInfoStore.load({params:{start:0, limit:Page}});
		
		GrDetailInfoGrid.store.removeAll();
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
	// ��ӡ��ť
		var PrintBT = new Ext.Toolbar.Button({
					id:'PrintBT',
					text : '��ӡ',
					tooltip : '�����ӡ',
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						var rowData=GrMasterInfoGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", "��ѡ����Ҫ��ӡ����ⵥ!");
							return;
						}
						var DhcIngr = rowData.get("IngrId");
						PrintRecCheck(DhcIngr,gParam[13]);
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
		if(rowCount=="0"){
			Msg.info("warning", "��ѡ����ⵥ!");
			return;
		}
		var rowData=GrMasterInfoGrid.getSelectionModel().getSelected();
		var AcceptUser=rowData.get("AcceptUser");
		var InGrFlag = (AcceptUser!=""?'Y':'N');
		if (InGrFlag == "Y") {
			Msg.info("warning", "��ⵥ������!");
			return;
		}
		for (var i = 0; i < rowCount; i++) {
			var rowData = GrDetailInfoStore.getAt(i);	
			//���������ݷ����仯ʱִ����������
			//if(rowData.data.newRecord || rowData.dirty){				
				var Ingri=rowData.get("Ingri");
				var CheckPort = rowData.get("CheckPort");
				var CheckRepNo = rowData.get("CheckRepNo");
				var CheckRepDate =Ext.util.Format.date(rowData.get("CheckRepDate"),App_StkDateFormat);
				var AdmNo = rowData.get("AdmNo");
				var AdmExpdate =Ext.util.Format.date(rowData.get("AdmExpdate"),App_StkDateFormat);
				var Remark = rowData.get("Remark");				
				
				var str = Ingri + "^" + CheckPort + "^"	+ CheckRepNo + "^" + CheckRepDate + "^"+ AdmNo + "^" + AdmExpdate + "^" + Remark;	
						
				if(ListDetail==""){
					ListDetail=str;
				}
				else{
					ListDetail=ListDetail+xRowDelim()+str;
				}
			//}
			
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
				text : '����',
				tooltip : '�������',
				iconCls : 'page_clearscreen',
				height:30,
				width:70,
				handler : function() {
					clearData();
				}
			});

	function clearData() {
		SetLogInDept(PhaLoc.getStore(),'PhaLoc');
		Ext.getCmp("AuditFlag").setValue("Y");
		Ext.getCmp("CompleteFlag").setValue("N");
		Ext.getCmp("InGrNo").setValue("");
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("InvNo").setValue("");
		Ext.getCmp("StartDate").setValue(new Date());
		Ext.getCmp("EndDate").setValue(new Date());
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
			"StkGrp","RpAmt","SpAmt","AcceptUser","AuditDate"];
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
				header : "��������",
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
				header : '�Ƶ�����',
				dataIndex : 'CreateDate',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : '�������',
				dataIndex : 'AuditDate',
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
		displayInfo:true,
		displayMsg:'�� {0} ���� {1}�� ��һ�� {2} ��',
		emptyMsg:"û�м�¼"
	});
	var GrMasterInfoGrid = new Ext.grid.GridPanel({
				id : 'GrMasterInfoGrid',
				title : '',
				height : 170,
				cm : GrMasterInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : GrMasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// ��ӱ�񵥻����¼�
	GrMasterInfoGrid.on('rowclick', function(grid, rowIndex, e) {
		var InGr = GrMasterInfoStore.getAt(rowIndex).get("IngrId");
		gIngrRowid=InGr;
		Query(InGr);
		
	});

	function Query(Parref){
		GrDetailInfoStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',Parref:Parref}});
	}
	
	// ����·��
	var DetailInfoUrl = DictUrl
					+ 'ingdrecaction.csp?actiontype=QueryIngrDetail';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	// ָ���в��� 	
	var fields = ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb",  "Margin", "RecQty",
			"Remarks", "IncCode", "IncDesc","InvNo", "Manf", "Rp", "RpAmt",
			"Sp", "SpAmt", "InvDate","QualityNo", "SxNo","Remark","MtDesc","PubDesc",
			"CheckPort","CheckRepNo",{name:'CheckRepDate',type:'date',dateFormat:App_StkDateFormat},"AdmNo",
			{name:'AdmExpdate',type:'date',dateFormat:App_StkDateFormat},"CheckPack","Spec"];
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
				header : 'ҩƷ����',
				dataIndex : 'IncCode',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : 'ҩƷ����',
				dataIndex : 'IncDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'BatchNo',
				width : 100,
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
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'RecQty',
				width : 80,
				align : 'right',
				sortable : true
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
									var index=GetColIndex(GrDetailInfoGrid,"CheckRepNo");
									if(index>0){
										GrDetailInfoGrid.startEditing(cell[0], index);
									}
								}
							}
						}
					})
			}, {
				header : "��ⱨ��",
				dataIndex : 'CheckRepNo',
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
			}, {
					header : "��������",
					dataIndex : 'CheckRepDate',
					width : 100,
					align : 'center',
					sortable : true,	
					renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
					editor : new Ext.form.DateField({
						selectOnFocus : true,
						allowBlank : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									
									var cell = GrDetailInfoGrid.getSelectionModel()
											.getSelectedCell();
									var index=GetColIndex(GrDetailInfoGrid,"AdmNo");
									if(index>0){
										GrDetailInfoGrid.startEditing(cell[0], index);
									}
								}
							}
						}
					})
					
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
					renderer : Ext.util.Format.dateRenderer(App_StkDateFormat),
					editor : new Ext.form.DateField({
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
				editor : new Ext.form.TextField()
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
				align : 'left',
				
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'left',
				
				sortable : true
			}, {
				header : "���",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				
				sortable : true
			}]);
	GrDetailInfoCm.defaultSortable = true;
	var GrDetailInfoGrid = new Ext.grid.EditorGridPanel({
				title : '',
				height : 170,
				cm : GrDetailInfoCm,
				sm : new Ext.grid.CellSelectionModel({}),
				store : GrDetailInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				clicksToEdit : 1
			});

		var InfoForm= new Ext.form.FormPanel({
				frame : true,
				labelAlign : 'right',
				id : "InfoForm",
				autoHeight:true,
				labelWidth: 60,	
				title:'��ⵥ��ѯ������',
				tbar : [searchBT, '-', clearBT, '-', acceptBT,'-',PrintBT],	//, '-', closeBT
				items:[{
					xtype:'fieldset',
					title:"��ѯ����",
					layout:'column',
					style:DHCSTFormStyle.FrmPaddingV,
					items : [{ 				
						columnWidth: 0.3,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [PhaLoc,Vendor]
					
					},{ 				
						columnWidth: 0.25,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [StartDate,EndDate]
					
					},{ 				
						columnWidth: 0.25,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [InGrNo,InvNo]
					
					},{ 				
						columnWidth: 0.2,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [AuditFlag,CompleteFlag]
					
					}]
				}]
			});
			
		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
				title : '��ⵥ����',
				layout : 'border',
				renderTo : 'mainPanel',
				items : [            // create instance immediately
		            {
		                region: 'north',
		                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
						width: 225,
		                layout: 'fit', // specify layout manager for items
		                items:InfoForm
		            }, {
		                region: 'west',
		                title: '��ⵥ',
		                collapsible: true,
		                split: true,
		                width:document.body.clientWidth*0.3,
		                minSize: 175,
		                maxSize: 400,
		                margins: '0 5 0 0',
		                layout: 'fit', // specify layout manager for items
		                items: GrMasterInfoGrid       
		               
		            }, {
		                region: 'center',
		                title: '��ⵥ��ϸ',
		                layout: 'fit', // specify layout manager for items
		                items: GrDetailInfoGrid       
		               
		            }
       			]			
		});
		
		RefreshGridColSet(GrMasterInfoGrid,"DHCSTIMPORT");   //�����Զ�������������������
		RefreshGridColSet(GrDetailInfoGrid,"DHCSTIMPORT");   //�����Զ�������������������
	
	
})