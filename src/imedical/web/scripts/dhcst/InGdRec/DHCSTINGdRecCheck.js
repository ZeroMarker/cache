// /����: ��ⵥ����
// /����: ��ⵥ����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.18
		
Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var HospId=session['LOGON.HOSPID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gParamNew = PHA_COM.ParamProp("DHCSTIMPORT")
	var PoisonDoubleSignFlag = false
	if (gParamNew.PoisonDoubleSign == "N" ) PoisonDoubleSignFlag = true
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
		fieldLabel : $g('��ⲿ��'),
		id : 'PhaLoc',
		name : 'PhaLoc',
		width : 200,
		emptyText : $g('��ⲿ��...'),
		groupId:gGroupId
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		width : 200
	});
		
	// ��ⵥ��
	var InGrNo = new Ext.form.TextField({
		fieldLabel : $g('��ⵥ��'),
		id : 'InGrNo',
		name : 'InGrNo',
		anchor : '90%',
		width : 120,
		disabled : false
	});

	// ��Ʊ��
	var InvNo = new Ext.form.TextField({
				fieldLabel : $g('��Ʊ��'),
				id : 'InvNo',
				name : 'InvNo',
				anchor : '90%',
				width : 120,
				disabled : false
			});
	
	// ��ʼ����
	var StartDate= new Ext.ux.DateField({
		fieldLabel : $g('��ʼ����'),
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		width : 60,
		value : new Date()
	});

	// ��������
	var EndDate= new Ext.ux.DateField({
		fieldLabel : $g('��������'),
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		width : 60,
		value : new Date()
	});



	// ��˱�־
	var AuditFlag = new Ext.form.Checkbox({
		boxLabel : $g('�����'),
		id : 'AuditFlag',
		name : 'AuditFlag',
		anchor : '90%',
		width : 150,
		checked : true,
		disabled:false
	});
	// ��ɱ�־
	var CompleteFlag = new Ext.form.Checkbox({
		boxLabel : $g('�����(δ���)'),
		id : 'CompleteFlag',
		name : 'CompleteFlag',
		anchor : '90%',
		width : 150,
		checked : false,
		disabled:false
	});
	
	// ��ɱ�־
	var PMZJYFlag = new Ext.form.Checkbox({
		boxLabel : $g('����һ'),
		id : 'PMZJYFlag',
		name : 'PMZJYFlag',
		anchor : '90%',
		width : 150,
		checked : false,
		disabled:false,
		hidden:PoisonDoubleSignFlag
		
	});
	
	// ������ť
	var searchBT = new Ext.Toolbar.Button({
				text : $g('��ѯ'),
				tooltip : $g('�����ѯ��ⵥ��Ϣ'),
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
			Msg.info("warning", $g("��ѡ����ⲿ��!"));
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", $g("��ѡ��ʼ���ںͽ�ֹ����!"));
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
		var MZJYFlag = Ext.getCmp("PMZJYFlag").getValue()  ? 'Y' : 'N';
		
		var ListParam = [StartDate, EndDate, InGrNo, Vendor, PhaLoc, CompleteFlag, "", AuditFlag, InvNo, MZJYFlag].join("^")
		var Page=GridPagingToolbar.pageSize;
		//GrMasterInfoStore.baseParams['ParamStr']=ListParam;
		//GrMasterInfoStore.baseParams={ParamStr:ListParam};
		GrMasterInfoStore.setBaseParam('ParamStr',ListParam);
		GrMasterInfoStore.load({params:{start:0, limit:Page}});
		
		GrDetailInfoGrid.store.removeAll();
	}

	// ѡȡ��ť
	var acceptBT = new Ext.Toolbar.Button({
				text : $g('����'),
				tooltip : $g('�������'),
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
					text : $g('��ӡ'),
					tooltip : $g('�����ӡ'),
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						var rowData=GrMasterInfoGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", $g("��ѡ����Ҫ��ӡ����ⵥ!"));
							return;
						}
						var DhcIngr = rowData.get("IngrId");
						PrintRecCheck(DhcIngr,gParam[13]);
					}
				});
				
		// ����һ���1
		var MZJYAudit1 = new Ext.Toolbar.Button({
					id:'MZJYAudit1',
					text : $g('�龫���1'),
					tooltip : $g('������'),
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					hidden:PoisonDoubleSignFlag,
					handler : function() {
						MZJYDoubleSign("MZJY1")
					}
				});
		// ����һ���2
		var MZJYAudit2 = new Ext.Toolbar.Button({
					id:'MZJYAudit2',
					text : $g('�龫���2'),
					tooltip : $g('������'),
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					hidden:PoisonDoubleSignFlag,
					handler : function() {
						MZJYDoubleSign("MZJY2");
					}
				});
	// ����һҩƷ˫ǩ
	function MZJYDoubleSign(Status){
		var rowData=GrMasterInfoGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", $g("��ѡ����Ҫ��˵���ⵥ!"));
			return;
		}
		var DhcIngr = rowData.get("IngrId");
		var Table = "User.DHCINGdRec"
		var Ret = tkMakeServerCall("web.DHCST.DHCINGdRec","SaveStatus",Table,DhcIngr,Status,gUserId,"","Y")
		var RetArr = Ret.split("^")
		if(RetArr[0]>0){
			Msg.info("success", $g("��˳ɹ�!"));
			Query(gIngrRowid);
			GrMasterInfoStore.reload();
			return;
		}
		else{
			Msg.info("warning", $g("���ʧ��:") + RetArr[1]);
			return;
		}
	}			
	
		
		/* �����ð�ť */
		var GridColSetBT = new Ext.Toolbar.Button({
			text:$g('������'),
			tooltip:$g('������'),
			iconCls:'page_gear',
			handler:function(){
				GridSelectWin.show();
			}
		});

		// ȷ����ť
		var returnColSetBT = new Ext.Toolbar.Button({
			text : $g('ȷ��'),
			tooltip : $g('���ȷ��'),
			iconCls : 'page_goto',
			handler : function() {
				var selectradio = Ext.getCmp('GridSelectModel').getValue();
				if(selectradio){
					var selectModel =selectradio.inputValue;	
					if (selectModel=='1') {
						GridColSet(GrMasterInfoGrid,"DHCSTIMPORT");						
					}
					else {
						GridColSet(GrDetailInfoGrid,"DHCSTIMPORT");   							
					}						
				}
				GridSelectWin.hide();
			}
		});

		// ȡ����ť
		var cancelColSetBT = new Ext.Toolbar.Button({
				text : $g('ȡ��'),
				tooltip : $g('���ȡ��'),
				iconCls : 'page_delete',
				handler : function() {
					GridSelectWin.hide();
				}
			});

		//ѡ��ť
		var GridSelectWin=new Ext.Window({
			title:$g('ѡ��'),
			width : 210,
			height : 110,
			labelWidth:100,
			closeAction:'hide' ,
			plain:true,
			modal:true,
			items:[{
				xtype:'radiogroup',
				id:'GridSelectModel',
				anchor: '95%',
				columns: 2,
				style: 'padding:10px 10px 10px 10px;',
				items : [{
						checked: true,				             
							boxLabel: $g('��ⵥ'),
							id: 'GridSelectModel1',
							name:'GridSelectModel',
							inputValue: '1' 							
						},{
						checked: false,				             
							boxLabel: $g('��ⵥ��ϸ'),
							id: 'GridSelectModel2',
							name:'GridSelectModel',
							inputValue: '2' 							
						}]
					}],
			
			buttons:[returnColSetBT,cancelColSetBT]
		})


	/**
	 * ����������Ϣ
	 */
	function acceptData() {
		if(gIngrRowid==""){
			Msg.info("warning", $g("��ѡ����ⵥ!"));
			return;
		}
		var ListDetail="";
		var rowCount = GrDetailInfoGrid.getStore().getCount();
		if(rowCount=="0"){
			Msg.info("warning", $g("��ѡ����ⵥ!"));
			return;
		}
		var rowData=GrMasterInfoGrid.getSelectionModel().getSelected();
		var AcceptUser=rowData.get("AcceptUser");
		var InGrFlag = (AcceptUser!=""?'Y':'N');
		if (InGrFlag == "Y") {
			Msg.info("warning", $g("��ⵥ������!"));
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
					waitMsg : $g('������...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ˢ�½���
							Msg.info("success", $g("���ճɹ�!"));
							// 7.��ʾ��ⵥ����
							Query(gIngrRowid);
							GrMasterInfoStore.reload();

						} else {
							var ret=jsonData.info;
							Msg.info("error", $g("����ʧ�ܣ�")+ret);								
						}
					},
					scope : this
				});
		
	}
	// ��հ�ť
	var clearBT = new Ext.Toolbar.Button({
				text : $g('����'),
				tooltip : $g('�������'),
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
		Ext.getCmp("PMZJYFlag").setValue("N");
		
		GrMasterInfoGrid.store.removeAll();
		GrDetailInfoGrid.store.removeAll();
		gIngrRowid="";
	}

	// 3�رհ�ť
	var closeBT = new Ext.Toolbar.Button({
				text : $g('�ر�'),
				tooltip : $g('�رս���'),
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
			"StkGrp","RpAmt","SpAmt","AcceptUser","AuditDate","MZJYAudit1","MZJYAudit2"];
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
				header : $g("��ⵥ��"),
				dataIndex : 'IngrNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("��Ӫ��ҵ"),
				dataIndex : 'Vendor',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : $g('������'),
				dataIndex : 'AcceptUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : $g('�Ƶ�����'),
				dataIndex : 'CreateDate',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : $g('�������'),
				dataIndex : 'AuditDate',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : $g('�ɹ�Ա'),
				dataIndex : 'PurchUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : $g("��ɱ�־"),
				dataIndex : 'Complete',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : $g("�龫���1"),
				dataIndex : 'MZJYAudit1',
				width : 90,
				align : 'left',
				sortable : true,
				hidden:PoisonDoubleSignFlag
			}, {
				header : $g("�龫���2"),
				dataIndex : 'MZJYAudit2',
				width : 90,
				align : 'left',
				sortable : true,
				hidden:PoisonDoubleSignFlag
			}
			
			
			]);
	GrMasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:GrMasterInfoStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
		emptyMsg:$g("û�м�¼")
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
		GrDetailInfoStore.load({params:{start:0,limit:9999,sort:'Rowid',dir:'Desc',Parref:Parref}});
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
			{name:'AdmExpdate',type:'date',dateFormat:App_StkDateFormat},"CheckPack","Spec","InsuCode","InsuDesc"];
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
				header : $g('ҩƷ����'),
				dataIndex : 'IncCode',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g('ҩƷ����'),
				dataIndex : 'IncDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : $g("������ҵ"),
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'BatchNo',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("��Ч��"),
				dataIndex : 'ExpDate',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("��λ"),
				dataIndex : 'IngrUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("����"),
				dataIndex : 'RecQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("���ڰ�"),
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
				header : $g("��ⱨ��"),
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
					header :$g( "��������"),
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
				header : $g("ע��֤��"),
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
					header : $g("ע��֤��Ч��"),
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
				header : $g("ժҪ"),
				dataIndex : 'Remark',
				width : 90,
				align : 'left',
				sortable : true,
				editor : new Ext.form.TextField()
			}, {
				header : $g("����"),
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
			
				sortable : true
			}, {
				header : $g("�ۼ�"),
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header :$g( "��Ʊ��"),
				dataIndex : 'InvNo',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("��Ʊ����"),
				dataIndex : 'InvDate',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("���۽��"),
				dataIndex : 'RpAmt',
				width : 100,
				align : 'left',
				
				sortable : true
			}, {
				header : $g("�ۼ۽��"),
				dataIndex : 'SpAmt',
				width : 100,
				align : 'left',
				
				sortable : true
			}, {
				header : $g("���"),
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("����ҽ������"),
				dataIndex : 'InsuCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("����ҽ������"),
				dataIndex : 'InsuDesc',
				width : 80,
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
				title:$g('��ⵥ��ѯ������'),
				tbar : [searchBT, '-', clearBT, '-', acceptBT,'-',PrintBT,'-',GridColSetBT,'-',MZJYAudit1,'-',MZJYAudit2],	//, '-', closeBT
				items:[{
					xtype:'fieldset',
					title:$g("��ѯ����"),
					layout:'column',
					style:DHCSTFormStyle.FrmPaddingV,
					items : [{ 				
						columnWidth: 0.25,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [PhaLoc,Vendor]
					
					},{ 				
						columnWidth: 0.15,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [StartDate,EndDate]
					
					},{ 				
						columnWidth: 0.2,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [InGrNo,InvNo]
					
					},{ 				
						columnWidth: 0.15,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [AuditFlag,CompleteFlag]
					
					}
					,{ 				
						columnWidth: 0.15,
		            	xtype: 'fieldset',
		            	border: false,
		            	items: [PMZJYFlag]
					
					}
					
					]
				}]
			});
			
		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
				title : $g('��ⵥ����'),
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
		                title: $g('��ⵥ'),
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
		                title: $g('��ⵥ��ϸ'),
		                layout: 'fit', // specify layout manager for items
		                items: GrDetailInfoGrid       
		               
		            }
       			]			
		});
		
		RefreshGridColSet(GrMasterInfoGrid,"DHCSTIMPORT");   //�����Զ�������������������
		RefreshGridColSet(GrDetailInfoGrid,"DHCSTIMPORT");   //�����Զ�������������������
	
	
})
