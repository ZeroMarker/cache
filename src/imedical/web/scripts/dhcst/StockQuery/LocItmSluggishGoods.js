// /����: ����Ʒ������ѯ
// /����: ����Ʒ������ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.15
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
	//ͳ�ƿ���
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : $g('����'),
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId
		});
		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
					fieldLabel : $g('��ʼ����'),
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 120,
					value : new Date().add(Date.DAY, - 30)
				});
		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
					fieldLabel : $g('��ֹ����'),
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					width : 120,
					value : new Date()
				});
		var PFlag = new Ext.form.Checkbox({
			fieldLabel : $g('סԺ��/��ҩ'),
			id : 'PFlag',
			name : 'PFlag',
			anchor : '90%',
			//width : 80,
			checked : false
		});
		//סԺ��/��ҩ�ο�����
		var PQty =new Ext.form.NumberField({
			id : 'PQty',
			name : 'PQty',
			anchor : '90%',
			width : 50
		});
		var GFlag = new Ext.form.Checkbox({
			fieldLabel : $g('���'),
			id : 'GFlag',
			name : 'GFlag',
			anchor : '90%',
			//width : 80,
			checked : false
		});
		//���ο�����
		var GQty =new Ext.form.NumberField({
			id : 'GQty',
			name : 'GQty',
			anchor : '90%',
			width : 50
		});
		var FFlag = new Ext.form.Checkbox({
			fieldLabel : $g('���﷢/��ҩ'),
			id : 'FFlag',
			name : 'FFlag',
			anchor : '90%',
			//width : 80,
			checked : false
		});
		//���﷢/��ҩ�ο�����
		var FQty =new Ext.form.NumberField({
			id : 'FQty',
			name : 'FQty',
			anchor : '90%',
			width : 50
		});	
		var TFlag = new Ext.form.Checkbox({
			fieldLabel : $g('ת��'),
			id : 'TFlag',
			name : 'TFlag',
			anchor : '90%',
			//width : 80,
			checked : false
		});
		//ת���ο�����
		var TQty =new Ext.form.NumberField({
			id : 'TQty',
			name : 'TQty',
			anchor : '90%',
			width : 50
		});	
		var KFlag = new Ext.form.Checkbox({
			fieldLabel : $g('ת��'),
			id : 'KFlag',
			name : 'KFlag',
			anchor : '90%',
			//width : 80,
			checked : false
		});
		//ת��ο�����
		var KQty =new Ext.form.NumberField({
			id : 'KQty',
			name : 'KQty',
			anchor : '90%',
			width : 50
		});					
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					text : $g('��ѯ'),
					tooltip : $g('�����ѯ'),
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
				Msg.info("warning", $g("���Ҳ���Ϊ�գ�"));
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			if (startDate == undefined || startDate.length <= 0) {
				Msg.info("warning", $g("��ѡ��ʼ����!"));
				return;
			}
			if (endDate == undefined || endDate.length <= 0) {
				Msg.info("warning", $g("��ѡ���ֹ����!"));
				return;
			}
			var TransType=null;
			var PFlag=(Ext.getCmp("PFlag").getValue()==true?'P':'');    // סԺ��/��ҩ
			var PQty=Ext.getCmp("PQty").getValue();
			var FFlag=(Ext.getCmp("FFlag").getValue()==true?'F':'');	//���﷢/��ҩ
			var FQty=Ext.getCmp("FQty").getValue();
			var TFlag=(Ext.getCmp("TFlag").getValue()==true?'T':'');    //ת��
			var TQty=Ext.getCmp("TQty").getValue();
			var KFlag=(Ext.getCmp("KFlag").getValue()==true?'K':'');	//ת��
			var KQty=Ext.getCmp("KQty").getValue();
			var GFlag=(Ext.getCmp("GFlag").getValue()==true?'G':''); 	//���
			var GQty=Ext.getCmp("GQty").getValue();
			if(PFlag!=''){
				if(TransType!=null){
					TransType=TransType+','+PFlag+'$'+PQty+',Y$'+PQty;
				}else{
					TransType=PFlag+'$'+PQty+',Y$'+PQty;
				}
			}
			if(FFlag!=''){
				if(TransType!=null){
					TransType=TransType+','+FFlag+'$'+FQty+',H$'+FQty;
				}else{
					TransType=FFlag+'$'+FQty+',H$'+FQty;
				}
			}
			if(GFlag!=''){
				if(TransType!=null){
					TransType=TransType+','+GFlag+'$'+GQty;
				}else{
					TransType=GFlag+'$'+GQty;
				}
			}
			if(TFlag!=''){
				if(TransType!=null){
					TransType=TransType+','+TFlag+'$'+TQty;
				}else{
					TransType=TFlag+'$'+TQty;
				}
			}
			if(KFlag!=''){
				if(TransType!=null){
					TransType=TransType+','+KFlag+'$'+KQty;
				}else{
					TransType=KFlag+'$'+KQty;
				}
			}
			if (TransType == null || TransType.length <= 0) {
				Msg.info("warning", $g("��ѡ��ҵ������!"));
				return;
			}
			
			gStrParam=phaLoc+"^"+startDate+"^"+endDate
			+"^"+TransType;
			StockQtyStore.setBaseParam("Params",gStrParam);
			StockQtyStore.removeAll();
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize},
				callback : function(o,response,success) { 
					if (success == false){  
						Ext.MessageBox.alert($g("��ѯ����"),StockQtyStore.reader.jsonData.Error);  
					}
				}
			});

		}
				
		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : $g('����'),
					tooltip : $g('�������'),
					iconCls : 'page_clearscreen',
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
			SetLogInDept(PhaLoc.getStore(),'PhaLoc');
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("PFlag").setValue(false);
			Ext.getCmp("FFlag").setValue(false);
			Ext.getCmp("GFlag").setValue(false);
			Ext.getCmp("TFlag").setValue(false);
			Ext.getCmp("KFlag").setValue(false);
			Ext.getCmp("PQty").setValue('');
			Ext.getCmp("FQty").setValue('');
			Ext.getCmp("GQty").setValue('');
			Ext.getCmp("TQty").setValue('');
			Ext.getCmp("KQty").setValue('');
		
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}
		// ��水ť
		var SaveAsBT = new Ext.Toolbar.Button({
					text : $g('���'),
					tooltip : $g('���ΪExcel'),
					iconCls : 'page_export',
					width : 70,
					height : 30,
					handler : function() {
						ExportAllToExcel(StockQtyGrid);
						//gridSaveAsExcel(StockQtyGrid);
					}
				});
		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
					header : "inclb",
					dataIndex : 'inclb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g('����'),
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("����"),
					dataIndex : 'desc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : $g("���"),
					dataIndex : 'spec',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("��λ"),
					dataIndex : 'stkUom',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("���ÿ��"),
					dataIndex : 'avaQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : $g("���ο��"),
					dataIndex : 'stkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : $g("�ۼ�"),
					dataIndex : 'sp',
					width : 60,
					align : 'right',					
					sortable : true
				}, {
					header : $g("����"),
					dataIndex : 'batNo',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("Ч��"),
					dataIndex : 'expDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("������ҵ"),
					dataIndex : 'manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("��Ӫ��ҵ"),
					dataIndex : 'vendor',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("��λ"),
					dataIndex : 'sbDesc',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("���һ���������"),
					dataIndex : 'LastImpDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("���һ�γ�������"),
					dataIndex : 'LastTrOutDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("���һ��ת������"),
					dataIndex : 'LastTrInDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header :$g( "���һ�η�ҩ����(סԺ)"),
					dataIndex : 'LastIpDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("���һ�η�ҩ����(����)"),
					dataIndex : 'LastOpDate',
					width : 150,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmSluggishGoods&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["inclb","code", "desc","spec", "manf", "batNo","expDate","vendor","stkUom",
				"stkQty", "avaQty", "sp", "sbDesc","LastImpDate","LastTrOutDate","LastTrInDate","LastIpDate","LastOpDate"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "inclb",
					fields : fields
				});
		// ���ݼ�
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					remoteSort:true,
					baseParams:{
						Params:''
					}
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
					emptyMsg : "No results to display",
					prevText : $g("��һҳ"),
					nextText : $g("��һҳ"),
					refreshText : $g("ˢ��"),
					lastText : $g("���ҳ"),
					firstText : $g("��һҳ"),
					beforePageText : $g("��ǰҳ"),
					afterPageText : $g("��{0}ҳ"),
					emptyMsg : $g("û������")
				});

		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : sm,
					loadMask : true,
					bbar : StatuTabPagingToolbar
            	
		});
		
	var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
			region : 'north',
			title:$g("����Ʒ������ѯ"),
			autoHeight : true,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			tbar : [SearchBT, '-', RefreshBT,'-',SaveAsBT],	
			items:[{
				layout : 'column',
				defaults: { border:false},	
				title:$g('��ѯ����'),
				xtype: 'fieldset',
				style:'padding-top:5px;padding-bottom:5px',	
					items:[{
						columnWidth:0.3,
						xtype: 'fieldset',
						//style:'padding-top:10px;padding-bottom:10px',									
						defaults: {width: 250, border:false},    // Default config options for child items
						items : [PhaLoc,StartDate,EndDate]
					  },{
						columnWidth:0.55,																	
						xtype: 'fieldset',
						title:$g('ҵ������<ҵ����������¼����(��ⵥλ)�϶�Ϊ����Ʒ>'),	
						//style:'padding-top:5px;padding-bottom:5px',		
						border:true,
						hideLabels:false,
						labelWidth:80,
						//style:'margin-left:10px',
						layout: 'column',  
						items:[{ 				
								columnWidth: 0.25,
				            	xtype: 'fieldset',
				            	//labelWidth: 50,	
				            	//defaults: {width: 80, border:false},    // Default config options for child items
				            	defaultType: 'textfield',
				            	border: false,
				            	style:'padding-top:3px;padding-bottom:3px',	          
				            	items: [{
											xtype: 'compositefield',								
											items : [PFlag,PQty]
										},{
											xtype: 'compositefield',								
											items : [FFlag,FQty]
										}]
							
							},{ 				
								columnWidth: 0.25,
				            	xtype: 'fieldset',
				            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
				            	border: false,
				            	style:'padding-top:3px;padding-bottom:3px',	
				            	items: [{
											xtype: 'compositefield',								
											items : [TFlag,TQty]
										},{
											xtype: 'compositefield',								
											items : [KFlag,KQty]
										}]
							
							},{ 				
								columnWidth: 0.25,
				            	xtype: 'fieldset',
				            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
				            	border: false,
				            	style:'padding-top:3px;padding-bottom:3px',	
				            	items: [{
											xtype: 'compositefield',								
											items : [GFlag,GQty]
										}]
							
							}]			
				
					}]
			}]	
			
		});

		// 5.2.ҳ�沼��
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [ 
						{
			                region: 'north',
			                height: 195, // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: $g('��ϸ'),			               
			                layout: 'fit', // specify layout manager for items
			                items: StockQtyGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
	
})