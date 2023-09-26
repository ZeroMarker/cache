// /����: ����Ʒ������ѯ
// /����: ����Ʒ������ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.15
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gUserId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];	
	var gGroupId=session['LOGON.GROUPID'];
	//ͳ�ƿ���
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId
		});

		var StkGrpType = new Ext.ux.StkGrpComboBox({
				id: 'StkGrpType',
				name: 'StkGrpType',
				StkType: App_StkTypeCode, //��ʶ��������
				anchor: '90%',
				LocId: gLocId,
				UserId: gUserId
			});		
		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '��ʼ����',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					
					width : 120,
					value : new Date().add(Date.DAY, - 30)
				});
		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '��ֹ����',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					
					width : 120,
					value : new Date()
				});

		var GFlag = new Ext.form.Checkbox({
			fieldLabel : '���',
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

		//���﷢/��ҩ�ο�����
		var FQty =new Ext.form.NumberField({
			id : 'FQty',
			name : 'FQty',
			anchor : '90%',
			width : 50
		});	
		var TFlag = new Ext.form.Checkbox({
			fieldLabel : 'ת��',
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
			fieldLabel : 'ת��',
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
				Msg.info("warning", "���Ҳ���Ϊ�գ�");
				Ext.getCmp("PhaLoc").focus();
				return;
			}

			var StkGrpType = Ext.getCmp("StkGrpType").getValue();			
			var startDate = Ext.getCmp("StartDate").getValue();
			var endDate = Ext.getCmp("EndDate").getValue();
			if (startDate == undefined || startDate.length <= 0) {
				Msg.info("warning", "��ѡ��ʼ����!");
				return;
			}
			if (endDate == undefined || endDate.length <= 0) {
				Msg.info("warning", "��ѡ���ֹ����!");
				return;
			}
			startDate = startDate.format(ARG_DATEFORMAT);
			endDate = endDate.format(ARG_DATEFORMAT);
			var TransType=null;
			var TFlag=(Ext.getCmp("TFlag").getValue()==true?'T':'');    //ת��
			var TQty=Ext.getCmp("TQty").getValue();
			var KFlag=(Ext.getCmp("KFlag").getValue()==true?'K':'');	//ת��
			var KQty=Ext.getCmp("KQty").getValue();
			var GFlag=(Ext.getCmp("GFlag").getValue()==true?'G':''); 	//���
			var GQty=Ext.getCmp("GQty").getValue();
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
				Msg.info("warning", "��ѡ��ҵ������!");
				return;
			}
			
			gStrParam=phaLoc+"^"+startDate+"^"+endDate
			+"^"+TransType+"^"+StkGrpType;
			
			StockQtyStore.setBaseParam("Params",gStrParam);
			StockQtyStore.removeAll();
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize}});
		}
				
		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '������',
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
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("GFlag").setValue(false);
			Ext.getCmp("TFlag").setValue(false);
			Ext.getCmp("KFlag").setValue(false);
			Ext.getCmp("GQty").setValue('');
			Ext.getCmp("TQty").setValue('');
			Ext.getCmp("KQty").setValue('');
		
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, sm, {
					header : "inclb",
					dataIndex : 'inclb',
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
					header : "��������",
					dataIndex : 'desc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "���",
					dataIndex : 'spec',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "��λ",
					dataIndex : 'stkUom',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "���ÿ��",
					dataIndex : 'avaQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "���ο��",
					dataIndex : 'stkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "�ۼ�",
					dataIndex : 'sp',
					width : 60,
					align : 'right',					
					sortable : true
				}, {
					header : "����",
					dataIndex : 'batNo',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "Ч��",
					dataIndex : 'expDate',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "��Ӧ��",
					dataIndex : 'vendor',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "��λ",
					dataIndex : 'sbDesc',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "���һ���������",
					dataIndex : 'LastImpDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "���һ�γ�������",
					dataIndex : 'LastTrOutDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "���һ��ת������",
					dataIndex : 'LastTrInDate',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "���һ�η�ҩ����(סԺ)",
					dataIndex : 'LastIpDate',
					width : 150,
					align : 'left',
					hidden : true,
					sortable : true
				}, {
					header : "���һ�η�ҩ����(����)",
					dataIndex : 'LastOpDate',
					width : 150,
					align : 'left',
					hidden : true,
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
					emptyMsg : "û������"
				});

		var StockQtyGrid = new Ext.ux.GridPanel({
			id:'StockQtyGrid',
			region: 'center',
			title: '��ϸ',			               
			layout: 'fit',
			cm : StockQtyCm,
			store : StockQtyStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : sm,
			loadMask : true,
			bbar : StatuTabPagingToolbar
		});
		
	var HisListTab = new Ext.ux.FormPanel({
			title:"����Ʒ������ѯ",
			tbar : [SearchBT, '-', RefreshBT],
			items:[{
				xtype : 'fieldset',
				title : '��ѯ����',
				layout : 'column',	
				style : 'padding:5px 0px 0px 5px',
				defaults : {border:false,xtype:'fieldset'},
				items:[{
					columnWidth:0.4,
					items : [PhaLoc,StkGrpType,StartDate,EndDate]
				},{
					columnWidth:0.2,																	
					xtype: 'fieldset',
					title:'ҵ������',	
					style : 'padding:5px 0px 0px 5px;margin:0px 0px 5px 0px;',
					border:true,
					items:[
						{
							xtype: 'compositefield',
							items : [TFlag,TQty]
						},{
							xtype: 'compositefield',
							items : [KFlag,KQty]
						},{
							xtype: 'compositefield',								
							items : [GFlag,GQty]
					}]
				}]
			}]
			
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [ HisListTab,StockQtyGrid],
		renderTo : 'mainPanel'
	});
})