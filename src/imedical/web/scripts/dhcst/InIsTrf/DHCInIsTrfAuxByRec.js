// /����: ������ⵥ����
// /����: ������ⵥ����
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.27
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gInitId='';
	Ext.QuickTips.init();
	var ProType=GetRecTransType();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	
	
	// ��������
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '��������',
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',
				anchor : '80%',
				emptyText : '��������...',
				listWidth : 250,
				groupId : session['LOGON.GROUPID']
			});
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '��ʼ����',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '80%',
				width : 120,
				value : DefaultStDate()
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '��ֹ����',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '80%',
				width : 120,
				value : DefaultEdDate()
			});
	
	var TransStatus = new Ext.form.Checkbox({
				fieldLabel : '������ת��',
				id : 'TransStatus',
				name : 'TransStatus',
				anchor : '90%',
				width : 120,
				checked : false,
				disabled : false
			});
	// ��������
	var Vendor = new Ext.ux.VendorComboBox({
			fieldLabel : '��Ӧ��',
			id : 'Vendor',
			name : 'Vendor',
			anchor : '80%',			
			listWidth : 250
		});
		
	// ��ѯת�Ƶ���ť
	var SearchBT = new Ext.Toolbar.Button({
				id : "SearchBT",
				text : '��ѯ',
				tooltip : '�����ѯ��ⵥ',
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
				text : '����',
				tooltip : '�������',
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
		Ext.getCmp("SupplyPhaLoc").setDisabled(0);
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		Ext.getCmp("TransStatus").setValue(false);
		MasterGrid.store.removeAll();
		DetailGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		
	}

	// ���水ť
	var SaveBT = new Ext.Toolbar.Button({
				id : "SaveBT",
				text : '����',
				tooltip : '�������',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {						
						getReqLoc();						
				}
			});
    /**
	 * ѡȡ�����Ų�����
	 */
	function getReqLoc() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '������',
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',
				anchor : '80%',
				emptyText : '������...',
				listWidth : 250,
				defaultLoc:'',
				relid:Ext.getCmp("SupplyPhaLoc").getValue(),
				protype:ProType,
				params : {relid:'SupplyPhaLoc'}
		});
		var ConfirmBT = new Ext.Button({
			id:'ConfirmBT',
			name:'ConfirmBT',
			iconCls:'page_save',
			text:'ȷ��',
			handler:function(){
				var requestPhaLoc=Ext.getCmp("RequestPhaLoc").getValue();
			    if(requestPhaLoc==null || requestPhaLoc.length<1){
					Msg.info("warning", "��ѡ���������!");
					return;
				}
				save(requestPhaLoc);
				RequestPhaLocWin.close();
				
			}
		});
		var panel = new Ext.form.FormPanel({
			id:'panel',
			region:'center',
			layout:'form',
			labelWidth:60,
			frame:true,
			labelAlign:'right',
			bodyStyle:'padding:10px;',
			items:[RequestPhaLoc]
		});
		
		var RequestPhaLocWin = new Ext.Window({
			title : '������',
			width :350,
			height : 130,
			modal:true,
			layout : 'border',
			bodyStyle:'padding:10px;',
			items : [panel],
			buttons:[ConfirmBT],
			buttonAlign : 'center'
		});
		RequestPhaLocWin.show();
	}
	/**
	 * ����ת�Ƶ�
	 */
	function save(requestPhaLoc) {
		var selectRecords = MasterGrid.getSelectionModel().getSelections();
		if(selectRecords=="" || selectRecords=='undefined'){
			Msg.info("warning","û��ѡ�е���ⵥ!");
			return;
		}
		var record = selectRecords[0];
		var Status = record.get("Status");				
		if (Status =="��ת��") {
			Msg.info("warning", "����ⵥ�Ѿ����⣬�����ٳ���!");
			
			return;
		}			
		
		//��Ӧ����RowId^�������RowId^���ת������RowId^��������RowId^��ɱ�־^����״̬^�Ƶ���RowId^����RowId^�������^��ע
		var inItNo = '';
		var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		var ingrid=record.get("IngrId");
		var reqid='';
		var operatetype = '';	
		var Complete='N';
		var Status=10;
		var StkGrpId =record.get("StkGrpId");	
		var StkType = App_StkTypeCode;					
		var remark = '';
		
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
				+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark+"^"+ingrid;
		//��ϸid^����id^����^��λ^������ϸid^��ע
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);					
			var Initi = '';
			var Inclb = rowData.get("Inclb");
			var Qty = rowData.get("TrQty");
			if(Qty==0){
				continue;
			}
			var UomId = rowData.get("TrUomId");
			var ReqItmId = '';
			var Remark ='';
			
			var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^"
					+ ReqItmId + "^" + Remark;	
			if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+xRowDelim()+str;
			}				
		}
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					params:{Rowid:'',MainInfo:MainInfo,ListDetail:ListDetail},
					method : 'POST',
					waitMsg : '������...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ˢ�½���
							var InitRowid = jsonData.info;
							Msg.info("success", "����ɹ�!");
							// ��ת�������Ƶ�����
							window.location.href='dhcst.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';

						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info("error", "����ʧ��,���ܱ���!");
							}else if(ret==-2){
								Msg.info("error", "���ɳ��ⵥ��ʧ��,���ܱ���!");
							}else if(ret==-1){
								Msg.info("error", "������ⵥʧ��!");
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
	 * ɾ��ѡ����ҩƷ
	 */
	function deleteDetail() {
		// �ж�ת�Ƶ��Ƿ������
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "û��ѡ����!");
			return;
		}
		// ѡ����
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);			
		DetailGrid.getStore().remove(record);
	
	}
	

	// ��λ
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : '��λ',
				id : 'CTUom',
				name : 'CTUom',
				anchor : '90%',
				width : 120,
				store : CTUomStore,
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

	// ��ʾ��ⵥ����
	function Query() {
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		if (supplyphaLoc =='' || supplyphaLoc.length <= 0) {
			Msg.info("warning", "��ѡ�񹩸�����!");
			return;
		}
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var status = (Ext.getCmp("TransStatus").getValue()==true?1:0);
		var Vendor = Ext.getCmp("Vendor").getValue();
		
		var ListParam=startDate+'^'+endDate+'^^'+Vendor+'^'+supplyphaLoc+'^'+status;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam("ParamStr",ListParam);
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options, success){
				if(success==false){
     				Msg.info("error", "��ѯ������鿴��־!");
     			}else{
     				if(r.length>=1){
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
	
	// ����·��
	var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryImport';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["IngrId", "IngrNo", "RecLoc", "ReqLoc", "Vendor","CreateUser", "CreateDate","Status","StkGrpId","StkGrpDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "IngrId",
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
				dataIndex : 'IngrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "��ⵥ��",
				dataIndex : 'IngrNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'ReqLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'RecLoc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'CreateDate',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�����",
				dataIndex : 'CreateUser',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "ת��״̬",
				dataIndex : 'Status',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'StkGrpDesc',
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
	var MasterGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : MasterCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true,
							listeners:{
								rowselect:function(sm,rowIndex,rec){
									var IngrId = rec.get("IngrId");
									DetailStore.load({params:{start:0,limit:999,Parref:IngrId}});
								}
							}
						}),
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// ��ӱ�񵥻����¼�
//	MasterGrid.on('rowclick', function(grid, rowIndex, e) {
//		var IngrId = MasterStore.getAt(rowIndex).get("IngrId");
//		DetailStore.load({params:{start:0,limit:999,Parref:IngrId}});
//	});
	
	// ת����ϸ
	// ����·��
	var DetailUrl =DictUrl+
		'dhcinistrfaction.csp?actiontype=QueryImportDetail&Parref=&start=0&limit=999';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	
	// ָ���в���
	var fields = ["Ingri", "BatchNo", "TrUomId","TrUom","ExpDate", "Inclb", "TrQty", "IncId",
			 "IncCode", "IncDesc", "Manf","Rp","RpAmt", "Sp", "SpAmt", "BUomId",
			 "ConFacPur", "StkQty", "DirtyQty","AvaQty","BatExp"
			];
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
	 * ��ʾ��ϸǰ��װ�ر�Ҫ��combox
	 */
	DetailStore.on('beforeload',function(store,options){
		//װ�����е�λ
		var url = DictUrl
						+ 'drugutil.csp?actiontype=CTUom&CTUomDesc=&start=0&limit=9999';
		CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
		CTUomStore.load();
	});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "�����ϸid",
				dataIndex : 'Ingri',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ҩƷRowId",
				dataIndex : 'IncId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : 'ҩƷ����',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : 'ҩƷ����',
				dataIndex : 'IncDesc',
				width : 230,
				align : 'left',
				sortable : true
			}, {
				header : "����RowId",
				dataIndex : 'Inclb',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����/Ч��",
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "���ο��",
				dataIndex : 'StkQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "ת������",
				dataIndex : 'TrQty',
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
									Msg.info("warning", "ת����������Ϊ��!");
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", "ת����������С�ڻ����0!");
									return;
								}
								var cell = DetailGrid.getSelectionModel()
										.getSelectedCell();
								var record = DetailGrid.getStore()
										.getAt(cell[0]);
								var salePriceAMT = record
										.get("Sp")
										* qty;
								record.set("SpAmt",
										salePriceAMT);
								var AvaQty = record.get("AvaQty");
								if (qty > AvaQty) {
									Msg.info("warning", "ת���������ܴ��ڿ��ÿ������!");
									return;
								}
							}
						}
					}
				})
			}, {
				header : "ת�Ƶ�λ",
				dataIndex : 'TrUomId',
				width : 80,
				align : 'left',
				sortable : true,
				renderer : Ext.util.Format.comboRenderer(CTUom), // pass combo instance to reusable renderer					
				editor : new Ext.grid.GridEditor(CTUom)
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
				header : "ռ������",
				dataIndex : 'DirtyQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'AvaQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "ת����",
				dataIndex : 'ConFacPur',
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
			}]);

	var DetailGrid = new Ext.grid.EditorGridPanel({
				id : 'DetailGrid',
				region : 'center',
				title : '',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1
			});

	DetailGrid.on('beforeedit',function(e){
		if(e.field=="TrQty"){
			var rowData=MasterGrid.getSelectionModel().getSelected();
			if(rowData!=null && rowData!=""){
				if(rowData.get('Status')=='��ת��'){
					e.cancel=true;	//��ת�Ƶĵ���,�����޸�ת������
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
			}
		] 
	}); 
	
	//�Ҽ��˵�����ؼ����� 
	function rightClickFn(grid,rowindex,e){ 
		e.preventDefault(); 
		rightClick.showAt(e.getXY()); 
	}

	/**
	 * ��λչ���¼�
	 */
	CTUom.on('expand', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("IncId");
				var url = DictUrl
						+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
						+ InciDr;
				CTUomStore.proxy = new Ext.data.HttpProxy({
							url : url
						});
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
				var ConFac = record.get("ConFacPur");   //��λ��С��λ��ת����ϵ					
				var TrUom = record.get("TrUomId");    //Ŀǰ��ʾ�ĳ��ⵥλ
				var Sp = record.get("Sp");
				var Rp = record.get("Rp");
				var InclbQty=record.get("StkQty");
				var DirtyQty=record.get("DirtyQty");
				var AvaQty=record.get("AvaQty");
			
				if (value == null || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
					record.set("Sp", Sp/ConFac);
					record.set("Rp", Rp/ConFac);
					record.set("StkQty", InclbQty*ConFac);
					record.set("DirtyQty", DirtyQty*ConFac);
					record.set("AvaQty", AvaQty*ConFac);						
				} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
					record.set("Sp", Sp*ConFac);
					record.set("Rp", Rp*ConFac);
					record.set("StkQty", InclbQty/ConFac);
					record.set("DirtyQty", DirtyQty/ConFac);
					record.set("AvaQty", AvaQty/ConFac);
				}
				record.set("TrUomId", combo.getValue());
	});

	// �任����ɫ
	function changeBgColor(row, color) {
		DetailGrid.getView().getRow(row).style.backgroundColor = color;
	}

	var HisListTab = new Ext.form.FormPanel({
		//labelWidth: 60,	
		labelAlign : 'right',
		frame : true,		
		tbar : [SearchBT, '-',  ClearBT, '-', SaveBT],		
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'��ѯ����',
			style : 'padding:5px 0px 0px 5px',
			defaults: {width: 220, border:false},    // Default config options for child items
			items:[{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',	        
	        	items: [SupplyPhaLoc,Vendor]				
			},{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',	        	
	        	items: [StartDate,EndDate]				
			},{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',	        	
	        	items: [TransStatus]				
			}]
		}]
	});

	// ҳ�沼��
	var mainPanel = new Ext.Viewport({
				layout : 'border',
					items : [            // create instance immediately
		            {
		            	title:'���ת��-������ⵥ',
		                region: 'north',
		                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'west',
		                title: '��ⵥ',
		                collapsible: true,
		                split: true,
		                width: document.body.clientWidth*0.3, // give east and west regions a width
		                minSize: document.body.clientWidth*0.1,
		                maxSize: document.body.clientWidth*0.6,
		                margins: '0 5 0 0',
		                layout: 'fit', // specify layout manager for items
		                items: MasterGrid       
		               
		            }, {
		                region: 'center',
		                title: '��ⵥ��ϸ',
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});
	
})