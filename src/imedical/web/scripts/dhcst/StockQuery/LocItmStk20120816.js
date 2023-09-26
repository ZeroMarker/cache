// /����: ����ѯ
// /����: ����ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.06
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId='';
	var gStrParam='';
	ChartInfoAddFun();
	// ��¼����Ĭ��ֵ
	SetLogInDept(PhaDeptStore, "PhaLoc");
	
	function ChartInfoAddFun() {
		var PhaLoc = new Ext.form.ComboBox({
					fieldLabel : 'ҩ��',
					id : 'PhaLoc',
					name : 'PhaLoc',
					//anchor : '95%',
					width : 140,
					store : PhaDeptStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : false,
					triggerAction : 'all',
					emptyText : 'ҩ��...',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : ''
				});

		var DateTime = new Ext.form.DateField({
					fieldLabel : '����',
					id : 'DateTime',
					name : 'DateTime',
					//anchor : '95%',
					format : 'Y-m-d',
					width : 140,
					value : new Date()
				});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:"G",     //��ʶ��������
			width : 140
		}); 

		StkGrpType.on('select', function(e) {
			Ext.getCmp('DHCStkCatGroup').setValue("");
			StkCatStore.proxy = new Ext.data.HttpProxy({
				url : 'dhcst.drugutil.csp?actiontype=StkCat&StkGrpId='+ Ext.getCmp('StkGrpType').getValue()+ '&start=0&limit=999'
			});
			StkCatStore.reload();
		});
		
		var TypeStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['0', 'ȫ��'], ['1', '���Ϊ��'], ['2', '���Ϊ��'],
							['3', '���Ϊ��']]
				});
		var Type = new Ext.form.ComboBox({
					fieldLabel : '����',
					id : 'Type',
					name : 'Type',
					width : 140,
					store : TypeStore,
					triggerAction : 'all',
					mode : 'local',
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					editable : false,
					valueNotFoundText : ''
				});
		Ext.getCmp("Type").setValue("0");

		var InciDesc = new Ext.form.TextField({
					fieldLabel : 'ҩƷ����',
					id : 'InciDesc',
					name : 'InciDesc',
					//anchor : '90%',
					width : 140,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								GetPhaOrderInfo();
							}
						}
					}
				});

				/**
		 * ����ҩƷ���岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stktype, "G", "", "N", "0", "",getDrugList);
			}
		}
		
		/**
		 * ���ط���
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			gIncId = record.get("InciDr");
		}

		var ImportStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['����', '����'], ['����', '����'], ['����', '����']]
				});
		var INFOImportFlag = new Ext.form.ComboBox({
					fieldLabel : '���ڱ�־',
					id : 'INFOImportFlag',
					name : 'INFOImportFlag',
					anchor : '90%',
					width : 140,
					store : ImportStore,
					valueField : 'RowId',
					displayField : 'Description',
					mode : 'local',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					listWidth : 150,
					forceSelection : true
				});
		
		var DHCStkCatGroup = new Ext.form.ComboBox({
					fieldLabel : '������',
					id : 'DHCStkCatGroup',
					name : 'DHCStkCatGroup',
					anchor : '90%',
					width : 140,
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					valueNotFoundText : ''
				});

		// ҩѧ����
		var PhcCat = new Ext.form.ComboBox({
					fieldLabel : 'ҩѧ����',
					id : 'PhcCat',
					name : 'PhcCat',
					anchor : '90%',
					width : 140,
					store : PhcCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : '',
					enableKeyEvents : true,
					listeners : {
						'beforequery' : function(e) {
							refill(PhcCatStore, "PHCCat", Ext.getCmp('PhcCat')
											.getRawValue());
						}
					}
				});

		// ��������ֵ����
		function refill(store, type, filter) {
			var url = "";
			if (type == "PHCCat") {
				store.reload({
						params : {
							start : 0,
							limit : 20,
							PhccDesc:filter
						}
				});
			} else if (type == "PHCForm") {
					store.reload({
						params : {
							start : 0,
							limit : 20,
							PHCFDesc:filter
						}
					});
			} else if (type == "PhManufacturer") {
					store.reload({
						params : {
							start : 0,
							limit : 20,
							PHMNFName:filter
						}
					});
			}else if(type=="ArcItemCat"){
				store.reload({
						params : {
							start : 0,
							limit : 20,
							Desc:filter
						}
					});
			}
		}

		PhcCat.on('select', function(e) {
			Ext.getCmp('PhcSubCat').setValue("");
			Ext.getCmp('PhcMinCat').setValue("");
			PhcSubCatStore.proxy = new Ext.data.HttpProxy({
						url : DictUrl
								+ 'drugutil.csp?actiontype=PhcSubCat&PhcCatId='
								+ Ext.getCmp('PhcCat').getValue()
								+ '&start=0&limit=999'
					});
			PhcSubCatStore.reload();
		});

		// ҩѧ����
		var PhcSubCat = new Ext.form.ComboBox({
					fieldLabel : 'ҩѧ����',
					id : 'PhcSubCat',
					name : 'PhcSubCat',
					anchor : '90%',
					width : 140,
					store : PhcSubCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : ''
				});

		PhcSubCat.on('select', function(e) {
			Ext.getCmp('PhcMinCat').setValue("");
			PhcMinCatStore.proxy = new Ext.data.HttpProxy({
						url : DictUrl
								+ 'drugutil.csp?actiontype=PhcMinCat&PhcSubCatId='
								+ Ext.getCmp('PhcSubCat').getValue()
								+ '&start=0&limit=999'
					});
			PhcMinCatStore.reload();
		});

		// ҩѧС��
		var PhcMinCat = new Ext.form.ComboBox({
					fieldLabel : 'ҩѧС��',
					id : 'PhcMinCat',
					name : 'PhcMinCat',
					anchor : '90%',
					width : 140,
					store : PhcMinCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : ''
				});

		var ARCItemCat = new Ext.form.ComboBox({
					fieldLabel : 'ҽ������',
					id : 'ARCItemCat',
					name : 'ARCItemCat',
					anchor : '90%',
					width : 140,
					store : ArcItemCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					listWidth : 150,
					pageSize : 20,
					valueNotFoundText : '',
					listeners : {
						'beforequery' : function(e) {
							refill(ArcItemCatStore, "ArcItemCat", Ext.getCmp('ARCItemCat')
											.getRawValue());
						}
					}
				});

		var PHCDFPhcDoDR = new Ext.form.ComboBox({
					fieldLabel : '���Ʒ���',
					id : 'PHCDFPhcDoDR',
					name : 'PHCDFPhcDoDR',
					anchor : '90%',
					width : 140,
					store : PhcPoisonStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					valueNotFoundText : ''
				});

		var PhManufacturer = new Ext.form.ComboBox({
					fieldLabel : '��������',
					id : 'PhManufacturer',
					name : 'PhManufacturer',
					anchor : '90%',
					width : 140,
					store : PhManufacturerStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : '',
					enableKeyEvents : true,
					listeners : {
						'beforequery' : function(e) {
							refill(PhManufacturerStore, "PhManufacturer", Ext
											.getCmp('PhManufacturer')
											.getRawValue());
						}
					}
				});

		var PHCDOfficialType = new Ext.form.ComboBox({
					fieldLabel : 'ҽ�����',
					id : 'PHCDOfficialType',
					name : 'PHCDOfficialType',
					anchor : '90%',
					width : 140,
					store : OfficeCodeStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					valueNotFoundText : ''
				});

		var PHCForm = new Ext.form.ComboBox({
					fieldLabel : '����',
					id : 'PHCForm',
					name : 'PHCForm',
					anchor : '90%',
					width : 140,
					store : PhcFormStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : '',
					enableKeyEvents : true,
					listeners : {
						'beforequery' : function(e) {
							refill(PhcFormStore, "PHCForm", Ext
											.getCmp('PHCForm').getRawValue());
						}
					}
				});		

		var ManageDrug = new Ext.form.Checkbox({
					fieldLabel : '����ҩ',
					id : 'ManageDrug',
					name : 'ManageDrug',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false
				});


		var UseFlag = new Ext.form.Checkbox({
					fieldLabel : '������Ʒ��',
					id : 'UseFlag',
					name : 'UseFlag',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false
				});

		var NotUseFlag = new Ext.form.Checkbox({
					fieldLabel : '��������Ʒ��',
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false
				});


		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					text : '��ѯ',
					tooltip : '�����ѯ',
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						searchData();
					}
				});

		/**
		 * ��ѯ����
		 */
		function searchData() {
			// ��ѡ����
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "ҩ������Ϊ�գ�");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var date = Ext.getCmp("DateTime").getValue().format('Y-m-d')
					.toString();
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var StockType = Ext.getCmp("Type").getValue();
			if (date == null || date.length <= 0) {
				Msg.info("warning", "���ڲ���Ϊ�գ�");
				Ext.getCmp("DateTime").focus();
				return;
			}
			if (StkGrpRowId == null || StkGrpRowId.length <= 0) {
				Msg.info("warning", "���鲻��Ϊ�գ�");
				Ext.getCmp("StkGrpType").focus();
				return;
			}
			if (StockType == null || StockType.length <= 0) {
				Msg.info("warning", "���Ͳ���Ϊ�գ�");
				Ext.getCmp("Type").focus();
				return;
			}
			// ��ѡ����
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var PhcCatList = "";
			var PhcCat = Ext.getCmp("PhcCat").getValue();
			var PhcSubCat = Ext.getCmp("PhcSubCat").getValue();
			var PhcMinCat = Ext.getCmp("PhcMinCat").getValue();
			var ARCItemCat = Ext.getCmp("ARCItemCat").getValue();
			var PHCDFPhcDoDR = Ext.getCmp("PHCDFPhcDoDR").getValue();
			var PhManufacturer = Ext.getCmp("PhManufacturer").getValue();
			var PHCDOfficialType = Ext.getCmp("PHCDOfficialType").getValue();
			var PHCForm = Ext.getCmp("PHCForm").getValue();
			var ManageDrug = Ext.getCmp("ManageDrug").getValue();
			var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();
			
			gStrParam=phaLoc+"^"+date+"^"+StkGrpRowId+"^"+StockType+"^"+gIncId
			+"^"+ImpFlag+"^"+DHCStkCatGroup+"^"+PhcCat+"^"+PhcSubCat+"^"+PhcMinCat
			+"^"+ARCItemCat+"^"+PHCDFPhcDoDR+"^"+PhManufacturer+"^"+PHCDOfficialType
			+"^"+PHCForm+"^"+ManageDrug+"^"+UseFlag+"^"+NotUseFlag;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize,Params:gStrParam}});

		}

		function manFlagRender(value){
			if(value==1){
				return '����ҩ'	;		
			}else{
				return '�ǹ���ҩ';
			}
		}
				
		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '������',
					iconCls : 'page_refresh',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * ��շ���
		 */
		function clearData() {
			gStrParam='';
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("PhcCat").setValue('');
			Ext.getCmp("PhcSubCat").setValue('');
			Ext.getCmp("PhcMinCat").setValue('');
			Ext.getCmp("ARCItemCat").setValue('');
			Ext.getCmp("PHCDFPhcDoDR").setValue('');
			Ext.getCmp("PhManufacturer").setValue('');
			Ext.getCmp("PHCDOfficialType").setValue('');
			Ext.getCmp("PHCForm").setValue('');
			Ext.getCmp("ManageDrug").setValue(false);
			Ext.getCmp("UseFlag").setValue(false);
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("INFOImportFlag").setValue('');
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, sm, {
					header : "INCILRowID",
					dataIndex : 'Incil',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '����',
					dataIndex : 'InciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "��λ",
					dataIndex : 'StkBin',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : '���(��װ��λ)',
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "��װ��λ",
					dataIndex : 'PurUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "���(������λ)",
					dataIndex : 'StockQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "������λ",
					dataIndex : 'BUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "���(��λ)",
					dataIndex : 'StkQtyUom',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "���ۼ�",
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "���½���",
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : '�ۼ۽��',
					dataIndex : 'SpAmt',
					width : 120,
					align : 'right',
					
					sortable : true
				}, {
					header : '���۽��',
					dataIndex : 'RpAmt',
					width : 120,
					align : 'right',
					
					sortable : true
				}, {
					header : "���",
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : '����',
					dataIndex : 'ManfDesc',
					width : 50,
					align : 'left',
					sortable : true
				}, {
					header : "ͨ����",
					dataIndex : 'Gene',
					width : 50,
					align : 'left',
					sortable : true
				}, {
					header : "ҽ�����",
					dataIndex : 'OfficalCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'Form',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "�Ƿ����ҩ",
					dataIndex : 'ManFlag',
					width : 120,
					align : 'left',
					sortable : true,
					renderer:manFlagRender
				}]);
		StockQtyCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmStk&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["Incil", "Inci", "InciCode", "InciDesc",
				"StkBin", "PurUomDesc", "BUomDesc", "PurStockQty",
				"StockQty", "StkQtyUom", "Sp", "SpAmt",
				"Rp", "RpAmt", "Spec", "ManfDesc", "Gene",
				"OfficalCode", "Form", "ManFlag"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Incil",
					fields : fields
				});
		// ���ݼ�
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
					emptyMsg : "No results to display",
					prevText : "��һҳ",
					nextText : "��һҳ",
					refreshText : "ˢ��",
					lastText : "���ҳ",
					firstText : "��һҳ",
					beforePageText : "��ǰҳ",
					afterPageText : "��{0}ҳ",
					emptyMsg : "û������",
					doLoad:function(C){
						var B={},
						A=this.getParams();
						B[A.start]=C;
						B[A.limit]=this.pageSize;
						B[A.sort]='Rowid';
						B[A.dir]='desc';
						B['Params']=gStrParam;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});

		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : StatuTabPagingToolbar
				});
		function BatchShow() {
			var gridSelected =Ext.getCmp("StockQtyGrid"); 
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�鿴��ҩƷ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var Incil = selectedRow.get("Incil");
				var Date=Ext.util.Format.date(Ext.getCmp("DateTime").getValue(),'Y-m-d');
				var IncDesc=selectedRow.get("InciDesc");
				var PurUom=selectedRow.get("PurUomDesc");
				var BUom=selectedRow.get("BUomDesc");
				var IncInfo=IncDesc+'         ��װ��λ��'+PurUom+'     ������λ��'+BUom;
				BatchQuery(Incil, Date,IncInfo);								
			}
		}
		function TransShow() {
			var gridSelected =Ext.getCmp("StockQtyGrid"); 
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'����',msg:'��ѡ��Ҫ�鿴��ҩƷ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var Incil = selectedRow.get("Incil");
				var Date=Ext.util.Format.date(Ext.getCmp("DateTime").getValue(),'Y-m-d');
				var IncDesc=selectedRow.get("InciDesc");
				var PurUom=selectedRow.get("PurUomDesc");
				var BUom=selectedRow.get("BUomDesc");
				var IncInfo=IncDesc+'         ��װ��λ��'+PurUom+'     ������λ��'+BUom;
				TransQuery(Incil, Date,IncInfo);								
			}
		}		/***
		**����Ҽ��˵�,zdm,2012-01-04***
		**/
		//�Ҽ��˵�����ؼ����� 
		function rightClickFn(grid,rowindex,e){ 
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); 
		}
		StockQtyGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mnuBatch', 
					handler: BatchShow, 
					text: '������Ϣ' 
				},{ 
					id: 'mnuTrans', 
					handler: TransShow, 
					text: '̨����Ϣ' 
				}
			] 
		}); 
		
		var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			region : 'north',
			height : 250,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 1px 1px 5px;',
			tbar : [SearchBT, '-', RefreshBT],			
		    items:[{
						layout : 'column',	
						items : [{
									columnWidth:0.25,
									autoHeight : true,
									height:150,
									xtype: 'fieldset',
									title:'��ѡ����',	
									defaults: {width: 180, border:false},    // Default config options for child items
									items : [PhaLoc,DateTime,StkGrpType,Type]
								},{
									columnWidth:0.73,
									autoHeight : true,
									
											xtype: 'fieldset',
											title:'��ѡ����',	
											autoHeight : true,
											border:true,
											bodyStyle:'margin-left:20px',
											style:'margin-left:10px',
											layout : 'column',	
											items : [{
														columnWidth:0.34,
														autoHeight : true,
														xtype: 'fieldset',
														border:false,  
														items : [DHCStkCatGroup,PhcCat,PhcSubCat,PhcMinCat,UseFlag]
													},{
														columnWidth:0.33,
														autoHeight : true,
														xtype: 'fieldset',
														 border:false,  
														items : [INFOImportFlag,ARCItemCat,PHCDFPhcDoDR,PhManufacturer,NotUseFlag]
													},{
														columnWidth:0.33,
														autoHeight : true,
														xtype: 'fieldset',
														border:false,  
														items : [InciDesc,PHCForm,PHCDOfficialType,ManageDrug]
													}]
										
								}]
		    }]	
		});

		// 5.2.ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [HisListTab, StockQtyGrid],
					renderTo : 'mainPanel'
				});
	}
})