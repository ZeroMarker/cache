// ����̨��
function InclbTransQuery(Inclb,StkDate,InclbInfo) {

	function replaceAll(str, rgExp, replaceStr) {
		while (str.indexOf(rgExp) > -1) {
			str = str.replace(rgExp, replaceStr);
		}
		return str;
	}

	InclbInfo=replaceAll(InclbInfo," ","��"); //��ȫ�ǿո�����ǿո񣬷�ֹlabelչʾ��ʱ���Զ�����ǿո���˵�

	// ��ʼ����
	var StartDateInclb = new Ext.ux.DateField({
			fieldLabel : '��ʼ����',
			id : 'StartDateInclb',
			anchor : '90%',
			
			width : 120,
			value : StkDate
	});

	// ��������
	var EndDateInclb = new Ext.ux.DateField({
			fieldLabel : '��������',
			id : 'EndDateInclb',
			anchor : '90%',
			
			width : 120,
			value : StkDate
	});

    var InclbInfoLabel = new Ext.form.Label({
    	text:InclbInfo,
		align:'center',
		cls: 'classDiv1'
    })

	// ������ť
	var searchBT = new Ext.Toolbar.Button({
				text : '����',
				tooltip : '�����������̨��',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					searchDataIncb();
				}
			});

	/**
	 * ��ѯ����
	 */
	function searchDataIncb() {
		if (Ext.isEmpty(Inclb)) {
			return;
		}
		var StartDateInclb = Ext.getCmp("StartDateInclb").getValue();
		if(Ext.isEmpty(StartDateInclb)){
			Msg.info('warning', '��ʼ���ڲ���Ϊ��!');
			return false;
		}else{
			StartDateInclb = StartDateInclb.format(ARG_DATEFORMAT).toString();
		}
		var EndDateInclb = Ext.getCmp("EndDateInclb").getValue();
		if(Ext.isEmpty(EndDateInclb)){
			Msg.info('warning', '�������ڲ���Ϊ��!');
			return false;
		}else{
			EndDateInclb = EndDateInclb.format(ARG_DATEFORMAT).toString();
		}
		InclbTransStore.setBaseParam('incil', Inclb);
		InclbTransStore.setBaseParam('startdate', StartDateInclb);
		InclbTransStore.setBaseParam('enddate', EndDateInclb);
		var size=InclbTransPaging.pageSize;
		InclbTransStore.load({params:{start:0,limit:size}});
	}

	var InclbTransStore = new Ext.data.JsonStore({
		url : DictUrl + 'locitmstkaction.csp?actiontype=LocItmStkMoveDetail',
		root : 'rows',
		totalProperty : "results",
		fields : ["TrId","TrDate", "BatExp", "PurUom", "Sp","Rp","EndQty","EndQtyUom",
			"TrQty", "TrQtyUom", "RpAmt", "SpAmt","TrNo","TrAdm","TrMsg",
			"EndRpAmt", "EndSpAmt", "Vendor", "Manf","OperateUser", "HVBarCode", "EndQtyUomInclb", "TrPointer"]
	});
	var nm = new Ext.grid.RowNumberer();
	var InclbTransCm = new Ext.grid.ColumnModel([nm, {
				header : "TrId",
				dataIndex : 'TrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ҵ��RowId",
				dataIndex : 'TrPointer',
				hidden : true
			}, {
				header : "����",
				dataIndex : 'TrDate',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : '����Ч��',
				dataIndex : 'BatExp',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : "��λ",
				dataIndex : 'PurUom',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "��ֵ����",
				dataIndex : 'HVBarCode',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�ۼ�",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Rp',
				width : 60,
				align : 'right'
			}, {
				header : "��������",
				dataIndex : 'EndQtyUomInclb',		//���ν�������
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'TrQtyUom',
				width : 80,
				align : 'left',
				sortable : true
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
				header : "�����",
				dataIndex : 'TrNo',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'TrAdm',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "ժҪ",
				dataIndex : 'TrMsg',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "������(����)",
				dataIndex : 'EndRpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "������(�ۼ�)",
				dataIndex : 'EndSpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "��Ӧ��",
				dataIndex : 'Vendor',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'Manf',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'OperateUser',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	var InclbTransPaging = new Ext.PagingToolbar({
			store : InclbTransStore,
			pageSize : PageSize
		});
	var InclbTransGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				region:'center',
				cm : InclbTransCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : InclbTransStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar : InclbTransPaging
			});

	var InclbTransPanel = new Ext.form.FormPanel({
			region : 'north',
			height : 140,
			labelAlign : 'right',
			frame : true,
			bodyStyle : 'padding:10px 0 0 0;',
			tbar : [searchBT],
			layout : 'table',
			layoutConfig: {columns:2},
		    items:[{
		    		xtype:'fieldset',
		    		border:false,
		    		items:[StartDateInclb]
		    	  },{
		    	  	xtype:'fieldset',
		    	  	border:false,
		    	  	items:[EndDateInclb]
		    	  },{
		    	  	colspan:2,
		    	 	items:[InclbInfoLabel]
		    	}
		    ]
		});

	var InclbTransMoveWin = new Ext.Window({
				title : '����̨����Ϣ',
				width : gWinWidth,
				height : gWinHeight,
				modal : true,
				layout:'border',
				items : [ InclbTransPanel, InclbTransGrid]
			});
	InclbTransMoveWin.show();
	searchBT.handler();
}