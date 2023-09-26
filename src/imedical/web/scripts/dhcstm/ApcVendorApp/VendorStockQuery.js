
// /����: ��Ӧ�̿���ѯ
// /��д�ߣ�gwj
// /��д����: 2013.05.16

	var gStrParam='';
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	
var Vendor = new Ext.ux.UsrVendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	userId :gUserId,
	emptyText : '��Ӧ��...'
});

	//ͳ�ƿ���
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId
		});
	// ����
	var DateTime = new Ext.ux.DateField({
			fieldLabel : '����',
			id : 'DateTime',
			name : 'DateTime',
			anchor : '90%',
			value : new Date()
	});
	
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			anchor : '90%',
			LocId:gLocId,
			UserId:gUserId

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
			var vendr = Ext.getCmp("Vendor").getValue();
			if (vendr == null || vendr.length <= 0) {
				Msg.info("warning", "��Ӧ�̲���Ϊ�գ�");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			var stkDate = Ext.getCmp("DateTime").getValue();
			if (stkDate == undefined || stkDate.length <= 0) {
				Msg.info("warning", "��ѡ������!");
				return;
			}
			stkDate = stkDate.format(ARG_DATEFORMAT);
			var stkGrpId=Ext.getCmp("StkGrpType").getValue();
			gStrParam=vendr+"^"+phaLoc+"^"+stkDate+"^"+stkGrpId;
			BatchGrid.store.removeAll();
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize,Params:gStrParam}});
			StockQtyStore.on('load',function(){
				if (StockQtyStore.getCount()>0){
					StockQtyGrid.getSelectionModel().selectFirstRow();
					StockQtyGrid.getView().focusRow(0);
				}
			});
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
	//������ť
		var ExportBT = new Ext.Toolbar.Button({
			text : '����',
			tooltip : '�������',
			iconCls : 'page_save',
			width : 70,
			height : 30,
			handler : function() {
				ExportData();
			}
		});
		
		//��������
		function ExportData(){
			if (StockQtyGrid.getStore().getCount() > 0)
			{
				var strFileName="��Ӧ�̿���ѯ";
				var objExcelTool=Ext.dhcc.DataToExcelTool;
				objExcelTool.ExprotGrid(StockQtyGrid,strFileName);
			} else {
				Msg.info("warning", "��ѯ�б�����Ϊ��!");
				return;
			}
		}
		/**
		 * ��շ���
		 */
		function clearData() {
			gStrParam='';
			Ext.getCmp("DateTime").setValue(new Date());
			Ext.getCmp("PhaLoc").setValue('');
			Ext.getCmp("StkGrpType").setValue('');
					
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
			BatchGrid.store.removeAll();
		}

		var nm = new Ext.grid.RowNumberer();
		//var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
					header : "Pid",
					dataIndex : 'Pid',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				},{
					header : "INCIRowID",
					dataIndex : 'Inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				},{
					header : '����',
					dataIndex : 'InciCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : '���(��װ��λ)',
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'right',
					hidden:true,
					sortable : true
				}, {
					header : "��װ��λ",
					dataIndex : 'PurUomDesc',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : "���(������λ)",
					dataIndex : 'StockQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "������λ",
					dataIndex : 'BUomDesc',
					width : 40,
					align : 'left',
					sortable : false
				}, {
					header : "���(��λ)",
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "���ۼ�",
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					sortable : false
				}, {
					header : "���½���",
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					sortable : false
				}, {
					header : '�ۼ۽��',
					dataIndex : 'SpAmt',
					width : 120,
					align : 'right',
					sortable : false
				}, {
					header : '���۽��',
					dataIndex : 'RpAmt',
					width : 120,
					align : 'right',
					sortable : false
				}, {
					header : '���',
					dataIndex : 'Spec',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : '����',
					dataIndex : 'ManfDesc',
					width : 150,
					align : 'left',
					sortable : false
				}, {
					header : "ռ�ÿ��",
					dataIndex : 'DirtyQtyUom',
					width : 120,
					align : 'left',
					sortable : false
					
				}, {
					header : "���ÿ��",
					dataIndex : 'AvaQtyUom',
					width : 120,
					align : 'left',
					sortable : false
					
				}]);
		StockQtyCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl ='dhcstm.apcvendorstataction.csp?actiontype=VendorStk&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["Pid","Inci","InciCode","InciDesc","BUomDesc","BUomId","StockQty","StkQtyUom","PurUomDesc",
		             "PurUomId","PurStockQty","Spec","ManfDesc","Sp","SpAmt","Rp","RpAmt","DirtyQtyUom","AvaQtyUom"];
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
		
		
		// ����·��
		var BatchUrl = 'dhcstm.apcvendorstataction.csp?actiontype=VendorBan&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxyBatch = new Ext.data.HttpProxy({
					url : BatchUrl,
					method : "POST"
				});
		// ָ���в���
		var fieldsBatch = ["Locdesc","Inclb","StkBin","Btno","Expdate","BUomDesc","BUomId","StockQty","PurUomDesc","PurUomId","PurStockQty","DirtyQtyUom","AvaQtyUom"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var readerBatch = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inclb",
					fields : fieldsBatch
				});
		// ���ݼ�
		var BatchStore = new Ext.data.Store({
					proxy : proxyBatch,
					reader : readerBatch
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
						B[A.sort]='desc';
						B[A.dir]='ASC';
						
						B['Params']=gStrParam;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});
				
		var StatuTabPagingToolbarBatch = new Ext.PagingToolbar({
					store : BatchStore,
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
						B['Params']=gStrParamBatch;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
		});
		
		var StockQtyGrid = new Ext.ux.GridPanel({
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
	
	// ��ӱ�񵥻����¼�
		StockQtyGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var strPid = StockQtyStore.getAt(rowIndex).get("Pid");
			var strInci=StockQtyStore.getAt(rowIndex).get("Inci");			
			
			gStrParamBatch=strPid+"^"+strInci;
			var pageSize=StatuTabPagingToolbarBatch.pageSize;
			BatchStore.load({params:{start:0,limit:pageSize,Params:gStrParamBatch}});
			
		});
	
	var BatchCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
				{
					header : "���ڿ���",
					dataIndex : 'Locdesc',
					width : 150,
					align : 'left',
					sortable : true
					
				},{
					header : "INClbRowID",
					dataIndex : 'Inclb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				},{
					header : '����',
					dataIndex : 'Btno',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "Ч��",
					dataIndex : 'Expdate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "��λ",
					dataIndex : 'StkBin',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '���(��װ��λ)',
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'right',
					hidden:true,
					sortable : true
				}, {
					header : "��װ��λ",
					dataIndex : 'PurUomDesc',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : "���(������λ)",
					dataIndex : 'StockQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "������λ",
					dataIndex : 'BUomDesc',
					width : 40,
					align : 'left',
					sortable : false
				}, {
					header : "���(��λ)",
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "���ۼ�",
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					sortable : false
				}, {
					header : "���½���",
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					sortable : false
				}, {
					header : '�ۼ۽��',
					dataIndex : 'SpAmt',
					width : 120,
					align : 'right',
					sortable : false
				}, {
					header : '���۽��',
					dataIndex : 'RpAmt',
					width : 120,
					align : 'right',
					sortable : false
				}, {
					header : "ռ�ÿ��",
					dataIndex : 'DirtyQtyUom',
					width : 120,
					align : 'left',
					sortable : false
					
				}, {
					header : "���ÿ��",
					dataIndex : 'AvaQtyUom',
					width : 120,
					align : 'left',
					sortable : false
					
				}]);
		BatchCm.defaultSortable = true;	
		
	var BatchGrid = new Ext.grid.GridPanel({
			cm : BatchCm,
			store : BatchStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : new Ext.grid.CheckboxSelectionModel(),
			loadMask : true,
			bbar : StatuTabPagingToolbarBatch					
	});
		
	var HisListTab = new Ext.form.FormPanel({
			labelwidth : 20,
			region : 'north',
			title:"��Ӧ�̿���ѯ",
			height : 170,
			labelAlign : 'right',
			frame : true,
			bodyStyle : 'padding:10px 1px 1px 0px;',
			tbar : [SearchBT, '-', RefreshBT,'-',ExportBT],	
			items:[{
				layout : 'column',
			    defaults: { border:false},	
			    xtype: 'fieldset',
			    title:'��ѯ����',
			    
			    items:[{
					columnWidth:0.3,
					autoHeight : true,
					height:150,
					xtype: 'fieldset',									
					defaults: {width: 150, border:false},    // Default config options for child items
					items : [Vendor]
				  },{
					columnWidth:0.3,
					autoHeight : true,
					height:150,
					xtype: 'fieldset',									
					defaults: {width:150, border:false},    // Default config options for child items
					items : [PhaLoc]
				  },{
					columnWidth:0.2,
					autoHeight : true,
					height:150,
					xtype: 'fieldset',									
					defaults: {width:150, border:false},    // Default config options for child items
					items : [DateTime]
				  },{
					columnWidth:0.2,
					autoHeight : true,
					height:150,
					xtype: 'fieldset',									
					defaults: {width:120, border:false},    // Default config options for child items
					items : [StkGrpType]
				  }]	
			}]				
			
		});
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	

	// 5.2.ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [ HisListTab  			               
			        , {
			            region: 'center',
			            title: '��Ŀ��ϸ',			               
			            layout: 'fit', // specify layout manager for items
			            items: StockQtyGrid       
			        },{
			            region:'south',
			            title:'������Ϣ',
			            split:true,
			            height:150,
			            minSize:100,
			            maxSize:200,
			            collapsible:true,
			            layout:'fit',
			            items:BatchGrid			                
			        }],
		  renderTo : 'mainPanel'
	});
	
})