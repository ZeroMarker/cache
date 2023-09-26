// /����: ��汨��-��������
// /����:  ��汨��-��������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.14
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId=session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	
	//ͳ�ƿ���
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '����',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId,
			stkGrpId : 'StkGrpType'
		});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			anchor:'90%',
			width : 140,
			LocId:gLocId,
			UserId:gUserId,
			childCombo : 'DHCStkCatGroup'
		}); 
		
		var DHCStkCatGroup = new Ext.ux.ComboBox({
					fieldLabel : '������',
					id : 'DHCStkCatGroup',
					name : 'DHCStkCatGroup',
					anchor : '90%',
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{StkGrpId:'StkGrpType'}
				});

		var UseFlag = new Ext.form.Checkbox({
					hideLabel : true,
					boxLabel : '������Ʒ��',
					id : 'UseFlag',
					name : 'UseFlag',
					anchor : '90%',
					checked : false
				});

		var StkBin = new Ext.ux.ComboBox({
					fieldLabel : '��λ��',
					id : 'StkBin',
					name : 'StkBin',
					anchor : '90%',
					width : 140,
					//store : StkBinStore,
					store : LocStkBinStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{LocId:'PhaLoc'},
					filterName:'Desc'
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
	
			// ��ѡ����
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
			var StkBin=Ext.getCmp("StkBin").getValue();
		
			gStrParam=phaLoc+"^"+StkGrpRowId+"^"+DHCStkCatGroup
			+"^"+StkBin+"^"+UseFlag;
			
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
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("UseFlag").setValue(false);
			Ext.getCmp("StkBin").setValue('');
			
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
					header : "�������",
					dataIndex : 'maxQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "�������",
					dataIndex : 'minQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "��׼���",
					dataIndex : 'repQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "����",
					dataIndex : 'manf',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : '������',
					dataIndex : 'incscDesc',
					width : 150,
					align : 'left',
					sortable : true
				}]);
		StockQtyCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=jsLocItmStkQtyLimitWarn&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["incil", "inci", "code", "desc","spec", "manf", "maxQty", "minQty",
				"repQty", "avaQty", "incscDesc", "stkUom"];
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
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
			//		sm : new Ext.grid.CheckboxSelectionModel(),
					sm:sm,
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
			items : [{
						columnWidth:0.3,
						items : [PhaLoc,StkBin]
					},{
						columnWidth:0.25,
						items : [StkGrpType,DHCStkCatGroup]
					},{
						columnWidth:0.15,
						items : [UseFlag]
					},{
						columnWidth:0.3,
						defaultType: 'textfield',
						labelWidth : 110,
						defaults: {width: 50, border:false},
						items : [{
							fieldLabel:'�������������',
							cls: 'my-background-Red'
						},{
							fieldLabel:'�������������',							
							cls: 'my-background-GrassGreen'
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