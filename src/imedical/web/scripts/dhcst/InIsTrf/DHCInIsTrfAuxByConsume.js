// /����: ���ת�Ƶ������Ƶ��������������ģ�
// /����: ���ת�Ƶ������Ƶ��������������ģ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.26

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var locId = session['LOGON.CTLOCID'];
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// ������
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('������'),
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',
				anchor : '90%',				
				emptyText : $g('������...'),
				listWidth : 250,
				defaultLoc:""
			});

	// ��������
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('��������'),
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',
				anchor : '90%',				
				emptyText : $g('��������...'),
				listWidth : 250,
				groupId:session['LOGON.GROUPID'],
				listeners : {
					'select' : function(e) {
						var SelLocId=Ext.getCmp('SupplyPhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
						StkGrpType.getStore().removeAll();
						StkGrpType.getStore().setBaseParam("locId",SelLocId)
						StkGrpType.getStore().setBaseParam("userId",userId)
						StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
						StkGrpType.getStore().load();
						GetParam(e.value);	//�޸Ĺ������Һ�,�Թ�����������Ϊ׼
					}
				}
			});
	
	var PhaWin = new Ext.ux.ComboBox({
				fieldLabel : $g('��ҩ����'),
				id : 'PhaWin',
				name : 'PhaWin',
				anchor : '90%',
				width : 120,
				store : PhaWindowStore,
				valueField : 'RowId',
				displayField : 'Description',
				params:{LocId:'RequestPhaLoc'}
			});
			
	var DispUser = new Ext.form.ComboBox({
				fieldLabel : $g('��ҩ��'),
				id : 'DispUser',
				name : 'DispUser',
				anchor : '90%',
				width : 120,
				store : DeptUserStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : true,
				triggerAction : 'all',
				emptyText : $g('��ҩ��...'),
				selectOnFocus : true,
				forceSelection : true,
				minChars : 1,
				pageSize : 20,
				listWidth : 250,
				valueNotFoundText : '',
				listeners : {
					'beforequery' : function(e) {
						DeptUserStore.removeAll();
						var filter=Ext.getCmp('DispUser').getRawValue();
						var Loc=Ext.getCmp('RequestPhaLoc').getValue();
						DeptUserStore.setBaseParam('locId',Loc);
						DeptUserStore.setBaseParam('Desc',filter);
						DeptUserStore.load({params:{start : 0,limit : 20}});
					}
				}
			});
			
			// ��ʼ����
	var StartDate = new Ext.ux.DateField({
				fieldLabel : $g('��ʼ����'),
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 120,
				value : DefaultStDate()
			});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
				fieldLabel : $g('��ֹ����'),
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 120,
				value : DefaultEdDate()
			});
			
	var UseDays =new Ext.form.NumberField({
			fieldLabel : $g('��ҩ����'),
			id : 'UseDays',
			name : 'UseDays',
			anchor : '90%',
			width : 120
	});

	var IntFac =new Ext.form.NumberField({
		fieldLabel :$g( 'ȡ��ϵ��'),
		id : 'IntFac',
		name : 'IntFac',
		anchor : '90%',
		width : 120
	});
	
	var ManageFlag = new Ext.form.Checkbox({
		//fieldLabel : '�Ƿ����ҩ',
		hideLabel:true,
		boxLabel : $g('�Ƿ����ҩ'),
		id : 'ManageFlag',
		name : 'ManageFlag',
		anchor : '90%',
		width : 120,
		checked : false
	});
	
	// ҩƷ����
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:locId,
		UserId:userId,
		anchor : '90%',
		width : 200
	}); 
	
	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
				text : $g('��ѯ'),
				tooltip : $g('�����ѯ'),
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
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var UseDays = Ext.getCmp("UseDays").getValue();
		if (supplyphaLoc == undefined || supplyphaLoc.length <= 0) {
			Msg.info("warning", $g("��ѡ��Ӧ����!"));
			return;
		}
		if (requestphaLoc == undefined || requestphaLoc.length <= 0) {
			Msg.info("warning", $g("��ѡ��������!"));
			return;
		}
		if(supplyphaLoc==requestphaLoc){
			Msg.info("warning", $g("ѡ��Ĺ������ź�������һ�£�������ѡ��!"));
			return;
		}
		if (startDate == undefined || startDate.length <= 0) {
			Msg.info("warning", $g("��ѡ��ʼ����!"));
			return;
		}
		if (endDate == undefined || endDate.length <= 0) {
			Msg.info("warning", $g("��ѡ���ֹ����!"));
			return;
		}
		if (UseDays == undefined || UseDays.length <= 0) {
			Msg.info("warning", $g("����д��ҩ����!"));
			return;
		}
		var fac =  Ext.getCmp("IntFac").getValue();
		var stkgrp=Ext.getCmp("StkGrpType").getValue();
		var PhaWin=Ext.getCmp("PhaWin").getValue();
		var DispUser=Ext.getCmp("DispUser").getValue();
		var ManFlag=Ext.getCmp("ManageFlag").getValue();
		if(ManFlag==true){var ManFlag=1 }
		else{var ManFlag=0}
		var ListParam=supplyphaLoc+'^'+requestphaLoc+'^'+startDate+'^'+endDate+'^'+UseDays+'^'+stkgrp+'^'+fac+'^'+ManFlag+'^'+PhaWin+'^'+DispUser;
		DetailStore.load({params:{start:0, limit:999,ParamStr:ListParam}});
	}

	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
				text :$g( '����'),
				tooltip : $g('�������'),
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
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		Ext.getCmp("RequestPhaLoc").setValue("");
		Ext.getCmp("SupplyPhaLoc").setValue("");
		Ext.getCmp("UseDays").setValue("");
		Ext.getCmp("IntFac").setValue("");
		Ext.getCmp("PhaWin").setValue("");
		Ext.getCmp("DispUser").setValue("");
		Ext.getCmp("ManageFlag").setValue(false);
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	// ���水ť
	var SaveBT = new Ext.Toolbar.Button({
				text : $g('����'),
				tooltip : $g('�������'),
				width : 70,
				height : 30,
				iconCls : 'page_save',
				handler : function() {
					save();
				}
			});
			// ��λ
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : $g('��λ'),
				id : 'CTUom',
				name : 'CTUom',
				anchor : '90%',
				width : 120,
				store : CTUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : $g('��λ...'),
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
				var DirtyQty=record.get("ResQty");
				var AvaQty=record.get("AvaQty");
				var PurQty=record.get("purQty");
				
				if (value == undefined || value.length <= 0) {
					return;
				} else if (TrUom == value) {
					return;
				} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
					record.set("sp", Sp/ConFac);
					record.set("stkQty", StkQty*ConFac);
					record.set("ResQty", DirtyQty*ConFac);
					record.set("AvaQty", AvaQty*ConFac);
					record.set("purQty", PurQty*ConFac);
				} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
					record.set("sp", Sp*ConFac);
					record.set("stkQty", StkQty/ConFac);
					record.set("ResQty", DirtyQty/ConFac);
					record.set("AvaQty", AvaQty/ConFac);
					record.set("purQty", PurQty/ConFac);
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
			Msg.info("warning",$g("��ѡ�񹩸�����!"));
			return;
		}
		var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		if(requestPhaLoc==""){
			Msg.info("warning",$g("��ѡ��������!"));
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
			var Qty = rowData.get("tranQty");
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
			Msg.info("warning",$g("û����Ҫ���������!"));
			return;
		}
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=Save";
		Ext.Ajax.request({
					url : url,
					params:{Rowid:'',MainInfo:MainInfo,ListDetail:ListDetail},
					method : 'POST',
					waitMsg : $g('������...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ˢ�½���
							var InitRowid = jsonData.info;
							Msg.info("success", $g("����ɹ�!"));
							// ��ת�������Ƶ�����
							window.location.href='dhcst.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';

						} else {
							var ret=jsonData.info;
							if(ret==-99){
								Msg.info("error", $g("����ʧ��,���ܱ���!"));
							}else if(ret==-2){
								Msg.info("error", $g("���ɳ��ⵥ��ʧ��,���ܱ���!"));
							}else if(ret==-1){
								Msg.info("error", $g("������ⵥʧ��!"));
							}else if(ret==-5){
								Msg.info("error", $g("������ⵥ��ϸʧ��!"));
							}else if(ret.indexOf("-10:")>=0){
								Msg.info("error", $g("û�п��Ա������ϸ�������Ƿ��в�����ҩƷ!")+ret);
							}else {
								Msg.info("error", $g("������ϸ���治�ɹ���")+ret);
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
		
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", $g("û��ѡ����!"));
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
				+ 'dhcinistrfaction.csp?actiontype=QueryDetailForTransByConsume';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = [ "INCI","code","desc", "pUom", "pUomDesc", "tranQty","manf",
			 "batNo", "expDate", "stkQty","INCLB","sp","stkbin", "purQty", "ResQty", "AvaQty","BUomId","Fac"];
			
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
				header : $g("ҩƷId"),
				dataIndex : 'INCI',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g('ҩƷ����'),
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g('ҩƷ����'),
				dataIndex : 'desc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g("����Id"),
				dataIndex : 'INCLB',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("����"),
				dataIndex : 'batNo',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : $g("Ч��"),
				dataIndex : 'expDate',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : $g("������ҵ"),
				dataIndex : 'manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g("ת������"),
				dataIndex : 'tranQty',
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
									Msg.info("warning", $g("ת����������Ϊ��!"));
									return;
								}
								if (qty <= 0) {
									Msg.info("warning", $g("ת����������С�ڻ����0!"));
									return;
								}
								var cell = DetailGrid.getSelectionModel()
										.getSelectedCell();
								var record = DetailGrid.getStore()
										.getAt(cell[0]);									
								var AvaQty = record.get("AvaQty");
								if (qty > AvaQty) {
									Msg.info("warning", $g("ת���������ܴ��ڿ��ÿ������!"));
									return;
								}
							}
						}
					}
				})
			}, {
				header : $g("ת�Ƶ�λ"),
				dataIndex : 'pUom',
				width : 80,
				align : 'left',
				sortable : true,
				renderer : Ext.util.Format.comboRenderer(CTUom), // pass combo instance to reusable renderer					
				editor : new Ext.grid.GridEditor(CTUom)
			}, {
				header : $g("�ۼ�"),
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("��λ��"),
				dataIndex : 'stkbin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("���ο��"),
				dataIndex : 'stkQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("ռ������"),
				dataIndex : 'ResQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header :$g( "��������"),
				dataIndex : 'AvaQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : $g("��������"),
				dataIndex : 'purQty',
				width : 80,
				align : 'right',
				sortable : true
			}]);

	var DetailGrid = new Ext.grid.EditorGridPanel({
				title : '',
				height : 200,
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
				text: $g('ɾ��') 
			}
		] 
	}); 
	
	//�Ҽ��˵�����ؼ����� 
	function rightClickFn(grid,rowindex,e){ 
		e.preventDefault(); 
		rightClick.showAt(e.getXY()); 
	}

	var HisListTab = new Ext.form.FormPanel({
		//labelWidth: 60,	
		labelAlign : 'right',
		frame : true,		
		tbar : [SearchBT, '-', ClearBT,'-',SaveBT],
		items : [{
			layout: 'column',    // Specifies that the items will now be arranged in columns
			xtype:'fieldset',
			title:$g('��ѯ����'),
			style:DHCSTFormStyle.FrmPaddingV,
			defaults: {width: 220, border:false},    // Default config options for child items
			items:[{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',     	
	        	items: [SupplyPhaLoc,RequestPhaLoc,StkGrpType]
				
			},{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',
	        	items: [StartDate,EndDate,UseDays]				
			},{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',
	        	items: [PhaWin,DispUser,IntFac]				
			},{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',
	        	items: [ManageFlag]				
			}]
		}]
		
	});

	// ҳ�沼��
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [            // create instance immediately
		            {   title:$g('���ת��-������������'),
		                region: 'north',
		                height: DHCSTFormStyle.FrmHeight(3), // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'center',
		                title: $g('��������ϸ'),			               
		                layout: 'fit', // specify layout manager for items
		                items: DetailGrid       
		               
		            }
       			],
				renderTo : 'mainPanel'
			});


})