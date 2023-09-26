// /����: ���ת�Ƶ������Ƶ����������󷽿�������ޣ�
// /����: ���ת�Ƶ������Ƶ����������󷽿�������ޣ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.25

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// ������
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '������',
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',
				anchor : '90%',				
				emptyText : '������...',
				defaultLoc:''
			});

	// ��������
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '��������',
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',
				anchor : '90%',				
				emptyText : '��������...',
				groupId:session['LOGON.GROUPID']
			});
	
	// ������׼ȡ������
	var RepLevFac =new Ext.form.NumberField({
			fieldLabel : '������׼ȡ������',
			id : 'RepLevFac',
			name : 'RepLevFac',
			anchor : '90%',
			width : 120
	});

	// ��������
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:session['LOGON.CTLOCID'],
		UserId:userId,
		anchor : '90%'
	}); 
	
	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				text : '��ѯ',
				tooltip : '�����ѯ',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
			});
	/**
	 * ��ѯ����
	 */
	function Query() {
		var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		if (supplyphaLoc == undefined || supplyphaLoc.length <= 0) {
			Msg.info("warning", "��ѡ��Ӧ����!");
			return;
		}
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var fac =  Ext.getCmp("RepLevFac").getValue();
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		var ListParam=supplyphaLoc+'^'+requestphaLoc+'^'+fac+'^'+stkgrp;
		DetailStore.load({params:{start:0, limit:999,ParamStr:ListParam}});
	}

	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
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
		Ext.getCmp("RequestPhaLoc").setValue("");
		Ext.getCmp("SupplyPhaLoc").setValue("");
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	// ���水ť
	var SaveBT = new Ext.ux.Button({
				text : '����',
				tooltip : '�������',
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					save();
				}
			});
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
			/**
	 * ��λչ���¼�
	 */
	CTUom.on('expand', function(combo) {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var InciDr = record.get("inci");
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
				var ConFac = record.get("Fac");   //��λ��С��λ��ת����ϵ					
				var TrUom = record.get("pUom");    //Ŀǰ��ʾ�ĳ��ⵥλ
				var Sp = record.get("sp");
				var StkQty = record.get("stkQty");
				var ReqStkQty=record.get("curqty");
				var DirtyQty=record.get("ResQty");
				var AvaQty=record.get("AvaQty");
				var RepQty=record.get("repqty");
				var LevQty=record.get("levelQty");
				var MaxQty=record.get("maxQty");
				var MinQty=record.get("minQty");
				if (value == undefined || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
					record.set("sp", Sp/ConFac);
					record.set("stkQty", StkQty*ConFac);
					record.set("curqty", ReqStkQty*ConFac);
					record.set("ResQty", DirtyQty*ConFac);
					record.set("AvaQty", AvaQty*ConFac);
					record.set("repqty", RepQty*ConFac);
					record.set("levelQty", LevQty*ConFac);
					record.set("maxQty", MaxQty*ConFac);
					record.set("minQty", MinQty*ConFac);
				} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
					record.set("sp", Sp*ConFac);
					record.set("stkQty", StkQty/ConFac);
					record.set("curqty", ReqStkQty/ConFac);
					record.set("ResQty", DirtyQty/ConFac);
					record.set("AvaQty", AvaQty/ConFac);
					record.set("repqty", RepQty/ConFac);
					record.set("levelQty", LevQty/ConFac);
					record.set("maxQty", MaxQty*ConFac);
					record.set("minQty", MinQty*ConFac);
				}
				record.set("pUom", combo.getValue());
	});
	
	/**
	 * ����ת�Ƶ�
	 */
	function save() {
		//��Ӧ����RowId^�������RowId^���ת������RowId^��������RowId^��ɱ�־^����״̬^�Ƶ���RowId^����RowId^�������^��ע
		var inItNo = '';
		var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
		if(supplyPhaLoc==""){
			Msg.info("warning","��ѡ�񹩸�����!");
			return;
		}
		var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		if(requestPhaLoc==""){
			Msg.info("warning","��ѡ��������!");
			return;
		}
		var reqid='';
		var operatetype = '';	
		var Complete='N';
		var Status=10;
		var StkGrpId = Ext.getCmp("StkGrpType").getValue();
		var StkType = App_StkTypeCode;					
		var remark = '';
		
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
				+ Complete + "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark;
		//��ϸid^����id^����^��λ^������ϸid^��ע
		var ListDetail="";
		var rowCount = DetailGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);					
			var Initi = '';
			var Inclb = rowData.get("INCLB");
			var Qty = rowData.get("batTraQty");
			if(Qty==0){
				continue;
			}
			var UomId = rowData.get("pUom");
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
		if(ListDetail==""){
			Msg.info("warning","û����Ҫ���������!");
			return;
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
							window.location.href='dhcstm.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';

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
		
	}
	
	// ת����ϸ
	// ����·��
	var DetailUrl =  DictUrl
				+ 'dhcinistrfaction.csp?actiontype=QueryDetailForTransByLim';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = [ "inci","code","desc", "pUom", "pUomDesc", "batTraQty","manf",
			 "batNo", "expDate", "stkQty","INCLB","sp","sbDesc", "oritrqty", "ResQty", "AvaQty",
			 "curqty","repqty","levelQty","maxQty","minQty","BUomId","Fac"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "INCLB",
				fields : fields
			});
	
	// ���ݼ�
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "����Id",
				dataIndex : 'inci',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '���ʴ���',
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'desc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "����Id",
				dataIndex : 'INCLB',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����",
				dataIndex : 'batNo',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "Ч��",
				dataIndex : 'expDate',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "ת������",
				dataIndex : 'batTraQty',
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
				dataIndex : 'pUom',
				width : 80,
				align : 'left',
				sortable : true,
				renderer : Ext.util.Format.comboRenderer2(CTUom,"pUom", "pUomDesc"),
				editor : new Ext.grid.GridEditor(CTUom)
			}, {
				header : "�ۼ�",
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "��λ��",
				dataIndex : 'sbDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "���ο��",
				dataIndex : 'stkQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "ռ������",
				dataIndex : 'ResQty',
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
				header : "�����ܿ��",
				dataIndex : 'curqty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "���󷽱�׼���",
				dataIndex : 'repqty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "�ο����",
				dataIndex : 'levelQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'maxQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'minQty',
				width : 80,
				align : 'right',
				sortable : true
			}]);

	var DetailGrid = new Ext.grid.EditorGridPanel({
				region: 'center',
				title: '��������ϸ',
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				sm : new Ext.grid.CellSelectionModel({}),
				clicksToEdit : 1
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
		grid.getSelectionModel().select(rowindex,0);
		rightClick.showAt(e.getXY()); 
	}

	var HisListTab = new Ext.ux.FormPanel({
		title:'���ת��-�������󷽿��������',
		labelWidth: 60,	
		tbar : [SearchBT, '-', ClearBT,'-',SaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:'��ѯ����',
			style : 'padding:5px 0px 0px 5px',
			defaults: {border:false},    // Default config options for child items
			items:[{
				columnWidth: 0.34,
	        	xtype: 'fieldset',
	        	items: [SupplyPhaLoc,StkGrpType]				
			},{
				columnWidth: 0.33,
	        	xtype: 'fieldset',
	        	items: [RequestPhaLoc]
			},{
				columnWidth: 0.33,
	        	xtype: 'fieldset',
	        	items: [RepLevFac]
			}]
		}]
	});

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, DetailGrid],
				renderTo : 'mainPanel'
			});
})