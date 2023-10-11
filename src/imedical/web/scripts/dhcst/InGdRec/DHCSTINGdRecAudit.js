// /����:������
// /����: ������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.05

var APPName="DHCSTPURPLANAUDIT"
var PurPlanParam=PHA_COM.ParamProp(APPName)

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
			fieldLabel : $g('��ⲿ��'),
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '95%',
			width : 120,
			emptyText : $g('��ⲿ��...'),
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
					fieldLabel : $g('��ʼ����'),
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 100,
					value : DefaultStDate()
				});

		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
					fieldLabel : $g('��ֹ����'),
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					width : 100,
					value : DefaultEdDate()
				});

		// ����
		var InGrFlag = new Ext.form.Checkbox({
					fieldLabel : $g('����'),
					id : 'InGrFlag',
					name : 'InGrFlag',
					anchor : '90%',
					width : 120,
					checked : false
				});

		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					id:"SearchBT",
					text : $g('��ѯ'),
					tooltip : $g('�����ѯ'),
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
					text : $g('����'),
					tooltip : $g('�������'),
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
					text : $g('���ȷ��'),
					tooltip : $g('������ȷ��'),
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
					text : $g('��ӡ'),
					tooltip : $g('�����ӡ'),
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						var rowData=MasterGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", $g("��ѡ����Ҫ��ӡ����ⵥ!"));
							return;
						}
						var DhcIngr = rowData.get("IngrId");
						PrintRec(DhcIngr,gParam[13]);
					}
				});
		
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
		var returnBT = new Ext.Toolbar.Button({
			text : $g('ȷ��'),
			tooltip : $g('���ȷ��'),
			iconCls : 'page_goto',
			handler : function() {
				var selectradio = Ext.getCmp('GridSelectModel').getValue();
				if(selectradio){
					var selectModel =selectradio.inputValue;	
					if (selectModel=='1') {
						GridColSet(MasterGrid,"DHCSTIMPORT");
						
					}
					else {
						GridColSet(DetailGrid,"DHCSTIMPORT");   							
					}						
				}
				GridSelectWin.hide();
			}
		});

		// ȡ����ť
		var cancelBT = new Ext.Toolbar.Button({
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
			
			buttons:[returnBT,cancelBT]
   		})	
				
				
		/**
		 * ��ѯ����
		 */
		function Query() {
			var PhaLoc = Ext.getCmp("PhaLoc").getValue();
			var Vendor = Ext.getCmp("Vendor").getValue();
			if(PhaLoc==""){
				Msg.info("warning", $g("��ѡ����ⲿ��!"));
				return;
			}
			
			var StartDate = Ext.getCmp("StartDate").getValue();
			if(StartDate!=""){
				StartDate=StartDate.format(App_StkDateFormat);
			}else{
				Msg.info("warning",$g("��ѡ��ʼ����!"));
				return;
			}
			
			var EndDate = Ext.getCmp("EndDate").getValue()
			if(EndDate!=""){
				EndDate=EndDate.format(App_StkDateFormat);
			}else{
				Msg.info("warning",$g("��ѡ���ֹ����!"));
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
	     				Msg.info("error", $g("��ѯ������鿴��־!"));
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
				Msg.info("warning", $g("��ѡ����Ҫ��˵���ⵥ!"));
				return;
			}
			//var InGrFlag = Ext.getCmp("InGrFlag").getValue();
			var AuditDate=rowData.get("AuditDate");
			var InGrFlag = (AuditDate!=""?'Y':'N');
			if (InGrFlag == "Y") {
				Msg.info("warning", $g("��ⵥ�����!"));
				return;
			}
			
			var StrParam=gGroupId+"^"+gLocId
			var DhcIngr = rowData.get("IngrId");
			//����ҽ�������ϴ���Ժ�ж�
			var CanSengFlag=tkMakeServerCall("PHA.IN.HDCM.Client.DHCMClient","CheckIfSendHDCM",DhcIngr)
			if(CanSengFlag=="Y")
			{
				var ret=tkMakeServerCall("PHA.IN.HDCM.Client.DHCMClient","IngdItm",DhcIngr)
				if(ret==0)
				{
					Msg.info("success", $g("����ϴ�ҽ������Ժ�ɹ�!"));
				}
				else 
				{
					Msg.info("error", $g("��ⵥ�ϴ���Ժʧ�ܣ�")+ret);
					return;
				}
			}
			
			///���Ԥ����Ŀ
			var ret = SendBusiData(DhcIngr,"IMPORT","AUDIT")
			if(!ret) return;

			var loadMask=ShowLoadMask(document.body,$g("�����..."));
			var url = DictUrl
					+ "ingdrecaction.csp?actiontype=Audit&Rowid="
					+ DhcIngr + "&User=" + userId+"&StrParam="+StrParam;

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : $g('��ѯ��...'),
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							loadMask.hide();
							if (jsonData.success == 'true') {
								Msg.info("success", $g("��˳ɹ�!"));
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
											Ext.Msg.confirm($g('��ʾ'),$g('�Ƿ��ӡ��'),
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
									Msg.info("error", $g("��ⵥ������!"));
								}else if(Ret==-100){
									Msg.info("error", $g("����ʧ��!"));
								}else if(Ret==-102){
									Msg.info("error", $g("��ⵥ��δ��ɣ��������!"));
								}else if(Ret==-104){
									Msg.info("error", $g("�����������ʧ��!"));
								}else if(Ret==-110){
									Msg.info("error", $g("ҩƷ�Ϳ��Ҳ���Ϊ��!"));
								}else if(Ret==-111){
									Msg.info("error", $g("����������Ϣʧ��!"));
								}else if(Ret==-112){
									Msg.info("error", $g("�������θ�����Ϣʧ��!"));
								}else if(Ret==-113){
									Msg.info("error", $g("������ʧ��!"));
								}else if(Ret==-114){
									Msg.info("error", $g("����̨��ʧ��!"));
								}else if(Ret==-115){
									Msg.info("error", $g("���������ϸʧ��!"));
								}else if(Ret==-5){
									Msg.info("error", $g("�ۼ��뵱ǰ�۲�һ�£��ҵ���������Ч���ۼ�¼����ȷ��!"));
								}else if(Ret==-1){
									Msg.info("error", $g("�ۼ��뵱ǰ�۲�һ�£���ȷ��!"));
								}else if(Ret==-2||Ret==-3){
									Msg.info("error", $g("������ۼ�¼ʧ��!"));
								}else if(Ret==-4){
									Msg.info("error", $g("��˵��ۼ�¼ʧ��!"));
								}else if(Ret==-201){
									Msg.info("error", $g("�����ٹ�ҩƷʧ��!"));
								}else if(Ret==-202){
									Msg.info("error", $g('�����ٹ�Ԥ��Ȩ����ʧ�ܣ�����ҩƷ�Ѿ�ά��"��ֹ"�ܿؼ���������ҩ������ά��"����",���ʵ!'));
								}else{
									Msg.info("error", $g("���ʧ��:")+Ret);
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
					header : $g("����"),
					dataIndex : 'IngrNo',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : $g('��ⲿ��'),
					dataIndex : 'RecLoc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g('��Ӫ��ҵ'),
					dataIndex : 'Vendor',
					width : 170,
					align : 'left',
					sortable : true
				}, {
					header : $g("�������"),
					dataIndex : 'CreateDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("�Ƶ���"),
					dataIndex : 'CreateUser',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : $g("�������"),
					dataIndex : 'IngrType',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : $g("�����"),
					dataIndex : 'AuditUser',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : $g('�������'),
					dataIndex : 'AuditDate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("������"),
					dataIndex : 'PoNo',
					width : 110,
					align : 'left',
					sortable : true
				}, {
					header : $g("���۽��"),
					dataIndex : 'RpAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("�ۼ۽��"),
					dataIndex : 'SpAmt',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("�������"),
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
			displayMsg:$g('�� {0} ���� {1}�� ��һ�� {2} ��'),
			emptyMsg:$g("û�м�¼")
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
			DetailStore.load({params:{start:0,limit:9999,Parref:InGrRowId}});
                           
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
			"QualityNo", "SxNo","Remark","MtDesc","PubDesc","Spec","OriginDesc","InsuCode","InsuDesc"];
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
					header : $g("����"),
					dataIndex : 'IncCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g('����'),
					dataIndex : 'IncDesc',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : $g("������ҵ"),
					dataIndex : 'Manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("����"),
					dataIndex : 'OriginDesc',
					width : 100,
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
					header : $g('��λ'),
					dataIndex : 'IngrUom',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : $g("����"),
					dataIndex : 'RecQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("����"),
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("�ۼ�"),
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("��Ʊ��"),
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
					header : $g("��Ʊ����"),
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
					header : $g("���۽��"),
					dataIndex : 'RpAmt',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("�ۼ۽��"),
					dataIndex : 'SpAmt',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("�������"),
					dataIndex : 'Margin',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("���"),
					dataIndex : 'Spec',
					width : 80,
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
				}
				]);

		
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
					title:$g('��ⵥ���'),
					autoScroll : false,
					autoHeight:true,
					//bodyStyle : 'padding:0px 0px 0px 0px;',					
					tbar : [SearchBT, '-', ClearBT, '-', CheckBT,  '-', PrintBT, '-',GridColSetBT],
					items:[{
						xtype:'fieldset',
						title:$g('��ѯ����'),
						layout: 'column',    // Specifies that the items will now be arranged in columns
						style:DHCSTFormStyle.FrmPaddingV,
						items : [{ 				
							columnWidth: 0.2,
			            	xtype: 'fieldset',
			            	border:false,    // Default config options for child items
			            	border: false,
			            	items: [PhaLoc,InGrFlag]
						},{ 				
							columnWidth: 0.2,
			            	xtype: 'fieldset',
			            	border: false,
			            	items: [Vendor]
							
						},{ 				
							columnWidth: 0.15,
			            	xtype: 'fieldset',
			            	border: false,
			            	items: [StartDate]
							
						},{ 				
							columnWidth: 0.15,
			            	xtype: 'fieldset',
			            	border: false,
			            	items: [EndDate]
							
						},{ 				
							columnWidth: 0.2,
			            	xtype: 'fieldset',
			            	border: false,
			            	items: [BudgetProComb]
							
						}]
						
					}]
				});
	

		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                height: DHCSTFormStyle.FrmHeight(1)+40, // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: $g('��ⵥ'),			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid       
			               
			            }, {
			                region: 'south',
			                split: true,
                			height: 250,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: $g('��ⵥ��ϸ'),
			                layout: 'fit', // specify layout manager for items
			                items: DetailGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
				RefreshGridColSet(MasterGrid,"DHCSTIMPORT");
				RefreshGridColSet(DetailGrid,"DHCSTIMPORT");		
		Query();
		SetBudgetPro(Ext.getCmp("PhaLoc").getValue(),"IMPORT",[3],"InGrFlag") //����HRPԤ����Ŀ
	}
})
