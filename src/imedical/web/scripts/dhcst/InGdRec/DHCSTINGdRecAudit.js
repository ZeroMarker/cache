// /����:������
// /����: ������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.05

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParam.length<1){
		GetParam();  //��ʼ����������
	}
	ChartInfoAddFun();
	
	function ChartInfoAddFun() {
		// ��ⲿ��
		var PhaLoc=new Ext.ux.LocComboBox({
			fieldLabel : '��ⲿ��',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '95%',
			width : 120,
			emptyText : '��ⲿ��...',
			groupId:gGroupId
		});
	
		var Vendor=new Ext.ux.VendorComboBox({
			id : 'Vendor',
			name : 'Vendor',
			anchor : '95%',
			width : 140
		});
		
		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '��ʼ����',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 100,
					value : DefaultStDate()
				});

		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '��ֹ����',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					width : 100,
					value : DefaultEdDate()
				});

		// ����
		var InGrFlag = new Ext.form.Checkbox({
					fieldLabel : '����',
					id : 'InGrFlag',
					name : 'InGrFlag',
					anchor : '90%',
					width : 120,
					checked : false
				});

		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					id:"SearchBT",
					text : '��ѯ',
					tooltip : '�����ѯ',
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						Query();
					}
				});
		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
					id:'ClearBT',
					text : '����',
					tooltip : '�������',
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
					}
				});
		// ���ȷ�ϰ�ť
		var CheckBT = new Ext.Toolbar.Button({
					id:'CheckBT',
					text : '���ȷ��',
					tooltip : '������ȷ��',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					disabled : true,
					handler : function() {
						Audit();
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
						var rowData=MasterGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", "��ѡ����Ҫ��ӡ����ⵥ!");
							return;
						}
						var DhcIngr = rowData.get("IngrId");
						PrintRec(DhcIngr,gParam[13]);
					}
				});
				
		/**
		 * ��ѯ����
		 */
		function Query() {
			var PhaLoc = Ext.getCmp("PhaLoc").getValue();
			var Vendor = Ext.getCmp("Vendor").getValue();
			if(PhaLoc==""){
				Msg.info("warning", "��ѡ����ⲿ��!");
				return;
			}
			
			var StartDate = Ext.getCmp("StartDate").getValue();
			if(StartDate!=""){
				StartDate=StartDate.format(App_StkDateFormat);
			}else{
				Msg.info("warning","��ѡ��ʼ����!");
				return;
			}
			
			var EndDate = Ext.getCmp("EndDate").getValue()
			if(EndDate!=""){
				EndDate=EndDate.format(App_StkDateFormat);
			}else{
				Msg.info("warning","��ѡ���ֹ����!");
				return;
			}

			var InGrFlag = (Ext.getCmp("InGrFlag").getValue()==true?'Y':'N');
			var ListParam=StartDate+'^'+EndDate+'^'+''+'^'+Vendor+'^'+PhaLoc+'^Y^^'+InGrFlag;
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam("ParamStr",ListParam);
			MasterStore.removeAll();
			DetailGrid.store.removeAll();
			MasterStore.load({
				params:{start:0, limit:Page},
				callback:function(r,options, success){
					if(success==false){
	     				Msg.info("error", "��ѯ������鿴��־!");
	     			}else{
	     				if(r.length>0){
		     				MasterGrid.getSelectionModel().selectFirstRow();
		     				MasterGrid.getSelectionModel().fireEvent('rowselect',this,0);
		     				MasterGrid.getView().focusRow(0);
	     				}
	     			}
				}
			});
			

		}

		/**
		 * ��շ���
		 */
		function clearData() {
			SetLogInDept(PhaLoc.getStore(),'PhaLoc');
			Ext.getCmp("Vendor").setValue("");
			Ext.getCmp("InGrFlag").setValue(0);
			Ext.getCmp("StartDate").setValue(DefaultStDate());
			Ext.getCmp("EndDate").setValue(DefaultEdDate());
			MasterGrid.store.removeAll();
			DetailGrid.store.removeAll();
			CheckBT.setDisabled(true);
			
			PrintBT.setDisabled(true);
		}

		/**
		 * ��˷���
		 */
		function Audit() {
			var rowData=MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "��ѡ����Ҫ��˵���ⵥ!");
				return;
			}
			//var InGrFlag = Ext.getCmp("InGrFlag").getValue();
			var AuditDate=rowData.get("AuditDate");
			var InGrFlag = (AuditDate!=""?'Y':'N');
			if (InGrFlag == "Y") {
				Msg.info("warning", "��ⵥ�����!");
				return;
			}
			var loadMask=ShowLoadMask(document.body,"�����...");
			var StrParam=gGroupId+"^"+gLocId
			var DhcIngr = rowData.get("IngrId");
			var url = DictUrl
					+ "ingdrecaction.csp?actiontype=Audit&Rowid="
					+ DhcIngr + "&User=" + userId+"&StrParam="+StrParam;

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '��ѯ��...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							loadMask.hide();
							if (jsonData.success == 'true') {
								Msg.info("success", "��˳ɹ�!");
								DetailGrid.store.removeAll();
								MasterStore.reload({
									callback:function(){
										//���ݲ��������Զ���ӡ
										if(gParam[4]=='1'){
											/*
											 * 20190903,yunhaibao,masterstore������,������Ǭ��ӡ,����reload.callbackһֱ�ڻص�
											 * �·�confirmҲ��һ������,query��ɺ�,����ʱ�ص�
											 */
											PrintRec.defer(500,this,[DhcIngr,gParam[13]]);
										}else if(gParam[4]=='2'){
											Ext.Msg.confirm('��ʾ','�Ƿ��ӡ��',
										      function(btn){
										        if(btn=='yes'){
										          PrintRec.defer(500,this,[DhcIngr,gParam[13]]);					
										        }else{
		          
										        }
										      },this);
										}									
									}
								});
							} else {
								var Ret=jsonData.info;
								if(Ret==-101){
									Msg.info("error", "��ⵥ������!");
								}else if(Ret==-100){
									Msg.info("error", "����ʧ��!");
								}else if(Ret==-102){
									Msg.info("error", "��ⵥ��δ��ɣ��������!");
								}else if(Ret==-104){
									Msg.info("error", "�����������ʧ��!");
								}else if(Ret==-110){
									Msg.info("error", "ҩƷ�Ϳ��Ҳ���Ϊ��!");
								}else if(Ret==-111){
									Msg.info("error", "����������Ϣʧ��!");
								}else if(Ret==-112){
									Msg.info("error", "�������θ�����Ϣʧ��!");
								}else if(Ret==-113){
									Msg.info("error", "������ʧ��!");
								}else if(Ret==-114){
									Msg.info("error", "����̨��ʧ��!");
								}else if(Ret==-115){
									Msg.info("error", "���������ϸʧ��!");
								}else if(Ret==-5){
									Msg.info("error", "�ۼ��뵱ǰ�۲�һ�£��ҵ���������Ч���ۼ�¼����ȷ��!");
								}else if(Ret==-1){
									Msg.info("error", "�ۼ��뵱ǰ�۲�һ�£���ȷ��!");
								}else if(Ret==-2||Ret==-3){
									Msg.info("error", "������ۼ�¼ʧ��!");
								}else if(Ret==-4){
									Msg.info("error", "��˵��ۼ�¼ʧ��!");
								}else{
									Msg.info("error", "���ʧ��:"+Ret);
								}
								
							}
						},
						scope : this
					});
		}

		// ��Ϣ�б�
		// ����·��
		var MasterUrl = DictUrl	+ 'ingdrecaction.csp?actiontype=Query';;
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["IngrId","IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
			"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
			"StkGrp","RpAmt","SpAmt","AuditDate","AuditUser","Margin"];
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
					reader : reader,
					baseParams:{ParamStr:''}
				});
		
		var nm = new Ext.grid.RowNumberer();
		var MasterCm = new Ext.grid.ColumnModel([nm, {
					header : "rowid",
					dataIndex : 'IngrId',
					width : 60,
					align : 'right',
					sortable : true,
					hidden : true/*,
					hideable : false*/
				}, {
					header : "����",
					dataIndex : 'IngrNo',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : '��ⲿ��',
					dataIndex : 'RecLoc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : '������',
					dataIndex : 'Vendor',
					width : 170,
					align : 'left',
					sortable : true
				}, {
					header : "�������",
					dataIndex : 'CreateDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "�Ƶ���",
					dataIndex : 'CreateUser',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : "�������",
					dataIndex : 'IngrType',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : "�����",
					dataIndex : 'AuditUser',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : '�������',
					dataIndex : 'AuditDate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "������",
					dataIndex : 'PoNo',
					width : 110,
					align : 'left',
					sortable : true
				}, {
					header : "���۽��",
					dataIndex : 'RpAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "�ۼ۽��",
					dataIndex : 'SpAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "�������",
					dataIndex : 'Margin',
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
			region : 'center',
			title : '',
			height : 170,
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
			var rowData = MasterStore.data.items[rowIndex];
			var InGrRowId = rowData.get("IngrId");
			DetailStore.removeAll();
			DetailStore.load({params:{start:0,limit:999,Parref:InGrRowId}});
                           
           var AuditDate = rowData.get("AuditDate");
           var InGrFlag = (AuditDate!=""?'Y':'N');
			//var InGrFlag = Ext.getCmp("InGrFlag").getValue();
			if (InGrFlag == "Y") {
				CheckBT.setDisabled(true);
				
				PrintBT.setDisabled(false);
			} else {
				CheckBT.setDisabled(false);
				
				PrintBT.setDisabled(true);
			}
		});

		// ��Ϣ��ϸ
		// ����·��
		var DetailUrl = DictUrl+ 'ingdrecaction.csp?actiontype=QueryIngrDetail';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// ָ���в���	
		var fields = ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb", "Margin", "RecQty",
			"Remarks", "IncCode", "IncDesc","InvNo", "Manf", "Rp", "RpAmt",
			"Sp", "SpAmt", {name:'InvDate',type:'date',dateFormat:App_StkDateFormat},
			"QualityNo", "SxNo","Remark","MtDesc","PubDesc","Spec","OriginDesc"];
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
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : "Ingri",
					dataIndex : 'Ingri',
					width : 80,
					align : 'right',
					sortable : true,
					hidden : true,
					hideable : false
				}, {
					header : "����",
					dataIndex : 'IncCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : '����',
					dataIndex : 'IncDesc',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'Manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'OriginDesc',
					width : 100,
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
					header : '��λ',
					dataIndex : 'IngrUom',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'RecQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "�ۼ�",
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "��Ʊ��",
					dataIndex : 'InvNo',
					width : 80,
					align : 'left',
					sortable : true
						/*,
					editor : new Ext.form.TextField({
								selectOnFocus : true,
								allowBlank : false,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											var invNo = field.getValue();
											if (invNo == null
													|| invNo.length <= 0) {
												Msg.info("warning", "��Ʊ�Ų���Ϊ��!");												
												return;
											}

											var cell = DetailGrid
													.getSelectionModel()
													.getSelectedCell();
											DetailGrid
													.startEditing(cell[0], 12);
										}
									}
								}
							})
							*/
				}, {
					header : "��Ʊ����",
					dataIndex : 'InvDate',
					width : 90,
					align : 'left',
					sortable : true,
					renderer :Ext.util.Format.dateRenderer(App_StkDateFormat)
						/*,
					editor : new Ext.ux.DateField({
						selectOnFocus : true,
						allowBlank : false,
						format : 'Y-m-d',
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var invDate = field.getValue();
									if (invDate == null || invDate.length <= 0) {
										Msg.info("warning", "��Ʊ���ڲ���Ϊ��!");											
										return;
									}
								}
							}
						}
					})
					*/
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
				}, {
					header : "�������",
					dataIndex : 'Margin',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "���",
					dataIndex : 'Spec',
					width : 80,
					align : 'left',
					
					sortable : true
				}]);

		
		var DetailGrid = new Ext.grid.EditorGridPanel({
					region : 'south',
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
		var HisListTab = new Ext.form.FormPanel({
					labelWidth : 60,
					labelAlign : 'right',
					frame : true,
					title:'��ⵥ���',
					autoScroll : false,
					autoHeight:true,
					//bodyStyle : 'padding:0px 0px 0px 0px;',					
					tbar : [SearchBT, '-', ClearBT, '-', CheckBT,  '-', PrintBT],
					items:[{
						xtype:'fieldset',
						title:'��ѯ����',
						layout: 'column',    // Specifies that the items will now be arranged in columns
						style:DHCSTFormStyle.FrmPaddingV,
						items : [{ 				
							columnWidth: 0.2,
			            	xtype: 'fieldset',
			            	defaults: {width: 220, border:false},    // Default config options for child items
			            	border: false,
			            	//style: {
			                //	"margin-left": "10px", // when you add custom margin in IE 6...
			               	//	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0",  // you have to adjust for it somewhere else
			               	//	"margin-bottom": "10px"
			            	//},
			            	items: [PhaLoc]
							
						},{ 				
							columnWidth: 0.3,
			            	xtype: 'fieldset',
			            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
			            	border: false,
			            	//style: {
			                //	"margin-left": "10px", // when you add custom margin in IE 6...
			                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
			            	//},
			            	items: [Vendor]
							
						},{ 				
							columnWidth: 0.18,
			            	xtype: 'fieldset',
			            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
			            	border: false,
			            	//style: {
			                //	"margin-left": "10px", // when you add custom margin in IE 6...
			                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
			            	//},
			            	items: [StartDate]
							
						},{ 				
							columnWidth: 0.18,
			            	xtype: 'fieldset',
			            	border: false,
			            	items: [EndDate]
							
						},{ 				
							columnWidth: 0.1,
			            	xtype: 'fieldset',
			            	border: false,
			            	items: [InGrFlag]
							
						}]
						
					}]
				});
	

		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                height: DHCSTFormStyle.FrmHeight(1), // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: '��ⵥ',			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid       
			               
			            }, {
			                region: 'south',
			                split: true,
                			height: 250,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: '��ⵥ��ϸ',
			                layout: 'fit', // specify layout manager for items
			                items: DetailGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
				
		Query();
	}
})