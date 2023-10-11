/**
 * ����: ҩƷ��Ϣ����
 * 
 * ����: ҩƷ��Ϣ ��д�ߣ�zhangyong ��д����: 2011.11.04
 * 
 * @param {}
 *            Input ����ֵ
 * @param {}
 *            StkGrpCode �������
 * @param {}
 *            StkGrpType ����
 * @param {}
 *            Locdr ҩ��
 * @param {}
 *            NotUseFlag ������
 * @param {}
 *            QtyFlag ����
 * @param {}
 *            HospID Ժ��
 * @param {}
 *            Fn ���ý��淽����������ڷ�����ý���ķ���(����ѡ���е�����Record)
 * @param {}
 *            InputDetailGrid,���ڿ��ƽ��㶨λ����
 */
GetPhaOrderWindow = function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag, QtyFlag, HospID, Fn,InputDetailGrid) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if (InputDetailGrid!=undefined){
		InputDetailGrid.setDisabled(true);
		//InputDetailGrid.focus(false);
		}  //��������������㶨λ��׼	
	var flg = false; // �滻�����ַ�
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0, Input.indexOf("*"));
	}
	var PhaOrderUrl = 'dhcst.drugutil.csp?actiontype=GetPhaOrderItemForDialog&Input=' + encodeURI(Input) + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType=' + StkGrpType + '&Locdr=' + Locdr + '&NotUseFlag=' + NotUseFlag + '&QtyFlag=' + QtyFlag + '&HospID=' + HospID + '&start=' + 0 + '&limit=' + 15; // ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url: PhaOrderUrl,
		method: "POST"
	}); // ָ���в���
	var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec", "ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDesc", "bRp", "bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty", "PhcFormDesc", "GoodName", "GeneName", {name: 'NotUseFlag',type: 'bool'},
	"PuomDr", "PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark"]; // ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: "results",
		id: "InciDr",
		fields: fields
	}); 
	// ���ݼ�
	var PhaOrderStore = new Ext.data.Store({
		proxy: proxy,
		reader: reader
	});
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
		store: PhaOrderStore,
		pageSize: 15,
		displayInfo: true,
		displayMsg: $g('��ǰ��¼ {0} -- {1} �� �� {2} ����¼'),
		emptyMsg: "No results to display",
		prevText: $g("��һҳ"),
		nextText: $g("��һҳ"),
		refreshText: $g("ˢ��"),
		lastText: $g("���ҳ"),
		firstText: $g("��һҳ"),
		beforePageText: $g("��ǰҳ"),
		afterPageText: $g("��{0}ҳ"),
		emptyMsg: $g("û������")
	});
	var nm = new Ext.grid.RowNumberer({
		width: 20
	});
	/**var sm = new Ext.grid.CheckboxSelectionModel({
		singleSelect: true
	});**/ 
	// the check column is created using a custom plugin
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
		header: $g('������'),
		dataIndex: 'NotUseFlag',
		width: 60,
		renderer: function(v, p, record) {
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
		}
	});
	var PhaOrderCm = new Ext.grid.ColumnModel([nm, {
		header: $g("����"),
		dataIndex: 'InciCode',
		width: 80,
		align: 'left',
		sortable: true
	},
	{
		header: $g('����'),
		dataIndex: 'InciDesc',
		width: 200,
		align: 'left',
		sortable: true
	},
	{
		header:$g( "���"),
		dataIndex: 'Spec',
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: $g("������ҵ"),
		dataIndex: 'ManfName',
		width: 180,
		align: 'left',
		sortable: true
	},
	{
		header: $g('��ⵥλ'),
		dataIndex: 'PuomDesc',
		width: 70,
		align: 'left',
		sortable: true
	},
	{
		header:$g( "�ۼ�(��ⵥλ)"),
		dataIndex: 'pSp',
		width: 100,
		align: 'right',
		sortable: true
	},
	{
		header: $g("����(��ⵥλ)"),
		dataIndex: 'PuomQty',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:Locdr==""?true:false,
	},
	{
		header: $g("������λ"),
		dataIndex: 'BuomDesc',
		width: 80,
		align: 'left',
		sortable: true
	},
	{
		header: $g("�ۼ�(������λ)"),
		dataIndex: 'bSp',
		width: 100,
		align: 'right',
		sortable: true
	},
	{
		header: $g("����(������λ)"),
		dataIndex: 'BuomQty',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:Locdr==""?true:false,
	},
	{
		header: $g("�Ƽ۵�λ"),
		dataIndex: 'BillUomDesc',
		width: 80,
		align: 'left',
		sortable: true
	},
	{
		header: $g("�ۼ�(�Ƽ۵�λ)"),
		dataIndex: 'BillSp',
		width: 100,
		align: 'right',
		sortable: true
	},
	{
		header: $g("����(�Ƽ۵�λ)"),
		dataIndex: 'BillUomQty',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:Locdr==""?true:false,
	},
	{
		header: $g("����"),
		dataIndex: 'PhcFormDesc',
		width: 60,
		align: 'left',
		sortable: true
	},
	{
		header: $g("��Ʒ��"),
		dataIndex: 'GoodName',
		width: 80,
		align: 'left',
		sortable: true
	},
	{
		header: $g("����ͨ����"),
		dataIndex: 'GeneName',
		width: 160,
		align: 'left',
		sortable: true
	},
	ColumnNotUseFlag]);
	PhaOrderCm.defaultSortable = true; 
	// ���ذ�ť
	var returnBT = new Ext.Toolbar.Button({
		text:$g( 'ѡȡ'),
		tooltip: $g('���ѡȡ'),
		iconCls: 'page_goto',
		handler: function() {
			returnData();
		}
	});
	/**
	 * ��������
	 */
	function returnData() {
		var selectRows = PhaOrderGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", $g("��ѡ��Ҫ���ص�ҩƷ��Ϣ��"));
		} else if (selectRows.length > 1) {
			Msg.info("warning", $g("����ֻ����ѡ��һ����¼��"));
		} else {
			flg = true;
			window.close();
		}
	} 
	// �رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		text: $g('�ر�'),
		tooltip: $g('����ر�'),
		iconCls: 'page_close',
		handler: function() {
			flg = false;
			window.close();
		}
	});
	var PhaOrderGrid = new Ext.grid.GridPanel({
		cm: PhaOrderCm,
		store: PhaOrderStore,
		trackMouseOver: true,
		stripeRows: true,
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		//sm: sm,
		//new Ext.grid.CheckboxSelectionModel(),
		loadMask: true,
		tbar: [returnBT, '-', closeBT],
		bbar: StatuTabPagingToolbar,
		deferRowRender: false
	});
	if (!window) {
		var window = new Ext.Window({
			title:$g( 'ҩƷ��Ϣ'),
			width : document.body.clientWidth*0.6,
			height : document.body.clientHeight*0.75,
			layout: 'fit',
			plain: true,
			modal: true,
			buttonAlign: 'center',
			//autoScroll : true,
			items: PhaOrderGrid,
			listeners: {
				"show": function() {
					LoadPhaOrderStore(); //���ⵯ�����役�㶪ʧLiangQiang 2013-11-22
				}
			}
		});
	}
	window.show();
	window.on('close',
		function(panel) {
			if (InputDetailGrid!=undefined){InputDetailGrid.setDisabled(false);}  //��������������㶨λ��׼	
			var selectRows = PhaOrderGrid.getSelectionModel().getSelections();
			if (selectRows.length == 0) {
				Fn("");
			} else if (selectRows.length > 1) {
				Fn("");
			} else {
				if (flg) {
					Fn(selectRows[0]);
				} else {
					Fn("");
				}
			}
	}); // ˫���¼�
	PhaOrderGrid.on('rowdblclick',
		function() {
			returnData();
	}); 
	// �س��¼�
	PhaOrderGrid.on('keydown',
		function(e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				returnData();
			} 
			//------------ ʵ�����ּ�ѡ����
			if (e.getKey() == 48 || e.getKey() == 96) {
				GetDrugByNum(9)
			}
			if (e.getKey() == 49 || e.getKey() == 97) {
				GetDrugByNum(0)
			}
			if (e.getKey() == 50 || e.getKey() == 98) {
				GetDrugByNum(1)
			}
			if (e.getKey() == 51 || e.getKey() == 99) {
				GetDrugByNum(2)
			}
			if (e.getKey() == 52 || e.getKey() == 100) {
				GetDrugByNum(3)
			}
			if (e.getKey() == 53 || e.getKey() == 101) {
				GetDrugByNum(4)
			}
			if (e.getKey() == 54 || e.getKey() == 102) {
				GetDrugByNum(5)
			}
			if (e.getKey() == 55 || e.getKey() == 103) {
				GetDrugByNum(6)
			}
			if (e.getKey() == 56 || e.getKey() == 104) {
				GetDrugByNum(7)
			}
			if (e.getKey() == 57 || e.getKey() == 105) {
				GetDrugByNum(8)
			}
			if (e.getKey() == 58 || e.getKey() == 106) {
				GetDrugByNum(9)
			} 
			//------------ ʵ�����ּ�ѡ����
	}) 
	function GetDrugByNum(Num) {
		PhaOrderGrid.getSelectionModel().selectRow(Num); //add by myq ѡ�е� Num+1 ��
		PhaOrderGrid.getView().focusRow(Num);
	}
	function LoadPhaOrderStore() {
		PhaOrderStore.load({
			callback: function(r, options, success) {
				if (success == false) {
					Msg.info('warning', $g('û���κη��ϵļ�¼��'));
					if (window) {
						window.close();
					}
				} else {
					PhaOrderGrid.getSelectionModel().selectFirstRow(); // ѡ�е�һ�в���ý���
					PhaOrderGrid.getView().focusRow(0); //����google,yunhaibao20151126
					row = PhaOrderGrid.getView().getRow(0);
					var element = Ext.get(row);
					if (typeof(element) != "undefined" && element != null) {
						element.focus();
					}
					var rownum = PhaOrderGrid.getStore().getCount();
				    if (rownum == 1) {
						returnData();
					}
				}
			}
		});
	}
}
