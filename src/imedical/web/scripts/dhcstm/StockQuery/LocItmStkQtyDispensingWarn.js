// /����: ��汨��-��������
// /����:  ��汨��-��������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.15
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
		//ͳ�ƿ���
		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId
		});

		var NotUseFlag = new Ext.form.Checkbox({
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					anchor : '90%',
					boxLabel:'����������Ʒ��',
					checked : false
				});

			// ��ʼ����
		var StartDate = new Ext.ux.DateField({
					fieldLabel : '',
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					
					width : 120,
					hideLabel:true,
					value : new Date().add(Date.DAY, - 30)
				});
		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
					fieldLabel : '��',
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					
					width : 120,
					value : new Date()
				});
		//��ҩ����
		var UseDays=new Ext.form.NumberField({
					id : 'UseDays',
					name : 'UseDays',
					anchor : '90%',
					fieldLabel:'��ҩ����',
					value:30
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
			var startDate = Ext.getCmp("StartDate").getValue();
			var endDate = Ext.getCmp("EndDate").getValue();			
			var UseDays = Ext.getCmp("UseDays").getValue();
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
			if (UseDays == undefined || UseDays.length <= 0) {
				Msg.info("warning", "����д��ҩ����!");
				return;
			}
			// ��ѡ����
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			
			gStrParam=phaLoc+"^"+startDate+"^"+endDate
			+"^"+UseDays+"^"+NotUseFlag;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize,Params:gStrParam}});

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
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("UseDays").setValue(30);
			
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, sm, {
					header : "incil",
					dataIndex : 'incil',
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
					header : "��������",
					dataIndex : 'oneDspQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "������",
					dataIndex : 'reqQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'manf',
					width : 150,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmStkQtyDispensingWarn&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["incil", "inci", "code", "desc","spec", "manf", 
				"reqQty", "avaQty", "oneDspQty", "stkUom"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "incil",
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
						B[A.sort]='desc';
						B[A.dir]='ASC';
						
						B['Params']=gStrParam;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
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
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : StatuTabPagingToolbar,
					viewConfig:{getRowClass : function(record,rowIndex,rowParams,store){ 
						var StkQty=record.get("avaQty");
						var MaxQty=record.get("maxQty");
						var MinQty=record.get("minQty");
						if(parseFloat(StkQty)>MaxQty){
							return 'classRed';
						}else if(parseFloat(StkQty)<MinQty){
							return 'classGrassGreen';
						}					
                    }
            	}
		});
		
	var HisListTab = new Ext.ux.FormPanel({
			title:"��汨��-��������",
			tbar : [SearchBT, '-', RefreshBT],				
			items:[{
				xtype : 'fieldset',
				title : '��ѯ����',
				layout : 'column',	
				style : 'padding:5px 0px 0px 5px',
				defaults : {border:false,xtype:'fieldset'},
				items:[{
					columnWidth:0.3,
					items : [PhaLoc,NotUseFlag]
				  },{
					columnWidth:0.45,
					title:'�ο��·ݷ�Χ����ҩʱ��',	
					border:true,
					style : 'padding:5px 0px 0px 5px;margin:0px 0px 5px 5px;',
					hideLabels:true,
					items : [{
						xtype: 'compositefield',								
						items : [
							StartDate,
							{ xtype: 'displayfield', value: '--'},
							EndDate,
							UseDays,
							{ xtype: 'displayfield', value: '��'}
						]
					}]
				
				}]	
			}]
		});

		// 5.2.ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [ HisListTab, StockQtyGrid ],
			renderTo : 'mainPanel'
		});
	
})