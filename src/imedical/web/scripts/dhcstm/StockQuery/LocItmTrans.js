// /����: ̨����Ϣ��ѯ������ѯ������ã�
// /����: ̨����Ϣ��ѯ������ѯ������ã�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.10

function TransQuery(Incil, StkDate, IncInfo) {

	function replaceAll(str, rgExp, replaceStr) {
		while (str.indexOf(rgExp) > -1) {
			str = str.replace(rgExp, replaceStr);
		}
		return str;
	}

	IncInfo = replaceAll(IncInfo, " ", "��"); //��ȫ�ǿո�����ǿո񣬷�ֹlabelչʾ��ʱ���Զ�����ǿո���˵�

	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
			fieldLabel: '��ʼ����',
			id: 'StartDate',
			anchor: '90%',
			value: StkDate
		});

	// ��������
	var EndDate = new Ext.ux.DateField({
			fieldLabel: '��������',
			id: 'EndDate',
			anchor: '90%',
			value: StkDate
		});

	var Inc = new Ext.form.Label({
			text: IncInfo,
			align: 'center',
			cls: 'classDiv1'
		})

		// ������ť
		var searchBT = new Ext.Toolbar.Button({
			text: '��ѯ',
			tooltip: '�����ѯ����̨��',
			iconCls: 'page_find',
			width: 70,
			height: 30,
			handler: function () {
				searchData();
			}
		});

	/**
	 * ��ѯ����
	 */
	function searchData() {
		// ��ѡ����
		if (Incil == null || Incil.length <= 0) {
			Msg.info("warning", "����������ѡ��ĳһ����¼�鿴��̨����Ϣ��");
			return;
		}

		var StartDate = Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT).toString(); ;
		var EndDate = Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT).toString();
		DetailInfoStore.setBaseParam('incil', Incil);
		DetailInfoStore.setBaseParam('startdate', StartDate);
		DetailInfoStore.setBaseParam('enddate', EndDate);
		var size = StatuTabPagingToolbar.pageSize;
		DetailInfoStore.load({
			params: {
				start: 0,
				limit: size
			}
		});
	}

	// ����·��
	var DetailInfoUrl = DictUrl
		 + 'locitmstkaction.csp?actiontype=LocItmStkMoveDetail&start=0&limit=20';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
			url: DetailInfoUrl,
			method: "POST"
		});

	// ָ���в���
	//ҵ������^����^��λ^�ۼ�^����^��������(������λ)^��������(����λ)^��������(������λ)
	//^��������(����λ)^�������(����)^�������(�ۼ�)^�����^������^ժҪ
	//^��ĩ���(����)^��ĩ���(�ۼ�)^��Ӧ��^����^������
	var fields = ["TrId", "TrDate", "BatExp", "PurUom", "Sp", "Rp", "EndQty", "EndQtyUom",
		"TrQty", "TrQtyUom", "RpAmt", "SpAmt", "TrNo", "TrAdm", "TrMsg",
		"EndRpAmt", "EndSpAmt", "Vendor", "Manf", "OperateUser", "TrPointer"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: "results",
			id: "TrId",
			fields: fields
		});
	// ���ݼ�
	var DetailInfoStore = new Ext.data.Store({
			proxy: proxy,
			reader: reader
		});
	var nm = new Ext.grid.RowNumberer();
	var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
					header: "TrId",
					dataIndex: 'TrId',
					width: 100,
					align: 'left',
					sortable: true,
					hidden: true
				}, {
					header: "ҵ��RowId",
					dataIndex: 'TrPointer',
					hidden: true
				}, {
					header: "����",
					dataIndex: 'TrDate',
					width: 180,
					align: 'left',
					sortable: true
				}, {
					header: '����Ч��',
					dataIndex: 'BatExp',
					width: 180,
					align: 'left',
					sortable: true
				}, {
					header: "��λ",
					dataIndex: 'PurUom',
					width: 180,
					align: 'left',
					sortable: true
				}, {
					header: "�ۼ�",
					dataIndex: 'Sp',
					width: 100,
					align: 'left',

					sortable: true
				}, {
					header: "����",
					dataIndex: 'Rp',
					width: 100,

					align: 'left'
				}, {
					header: "��������",
					dataIndex: 'EndQtyUom',
					width: 120,
					align: 'right',
					sortable: true
				}, {
					header: "����",
					dataIndex: 'TrQtyUom',
					width: 120,
					align: 'right',
					sortable: true
				}, {
					header: "���۽��",
					dataIndex: 'RpAmt',
					width: 120,
					align: 'left',

					sortable: true
				}, {
					header: "�ۼ۽��",
					dataIndex: 'SpAmt',
					width: 120,
					align: 'right',

					sortable: true
				}, {
					header: "�����",
					dataIndex: 'TrNo',
					width: 120,
					align: 'right',
					sortable: true
				}, {
					header: "������",
					dataIndex: 'TrAdm',
					width: 100,
					align: 'right',
					sortable: true
				}, {
					header: "ժҪ",
					dataIndex: 'TrMsg',
					width: 100,
					align: 'left',
					sortable: true
				}, {
					header: "������(����)",
					dataIndex: 'EndRpAmt',
					width: 120,
					align: 'right',

					sortable: true
				}, {
					header: "������(�ۼ�)",
					dataIndex: 'EndSpAmt',
					width: 120,
					align: 'right',

					sortable: true
				}, {
					header: "��Ӧ��",
					dataIndex: 'Vendor',
					width: 160,
					align: 'right',
					sortable: true
				}, {
					header: "����",
					dataIndex: 'Manf',
					width: 160,
					align: 'right',
					sortable: true
				}, {
					header: "������",
					dataIndex: 'OperateUser',
					width: 100,
					align: 'right',
					sortable: true
				}
			]);
	DetailInfoCm.defaultSortable = true;
	var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store: DetailInfoStore,
			pageSize: PageSize,
			displayInfo: true
		});
	var DetailInfoGrid = new Ext.grid.GridPanel({
			title: '',
			height: 170,
			region: 'center',
			cm: DetailInfoCm,
			sm: new Ext.grid.RowSelectionModel({
				singleSelect: true
			}),
			store: DetailInfoStore,
			trackMouseOver: true,
			stripeRows: true,
			loadMask: true,
			bbar: StatuTabPagingToolbar
		});

	var HisListTab = new Ext.ux.FormPanel({
			tbar: [searchBT],
			items: [{
				xtype:'fieldset',
				title:'��ѯ����',
				layout : 'column',
				style:'padding:5px 0px 0px 5px',
				defaults:{xtype:'fieldset',columnWidth : .33,border:false},
				items: [{
					items: [StartDate]
				}, {
					items: [EndDate]
				}]
			},{
				style:'padding:0px 0px 0px 30px',
				items: [Inc]
			}]
		});

	var window = new Ext.Window({
			title: '̨����Ϣ',
			width: gWinWidth,
			height: gWinHeight,
			modal: true,
			layout: 'border',
			items: [HisListTab, DetailInfoGrid]
		});
	window.show();
	searchBT.handler();
}
