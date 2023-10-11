/**
 * ����: ҩƷ��Ϣ�����б�
 * 
 * ����: ҩƷ��Ϣ ��д�ߣ�yunhaibao ��д����: 2017.11.13
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
 * @param {}
 *            AllCatGrpFlag,���ڿ��ƽ��㶨λ����
 */
GetPhaOrderLookUp = function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag, QtyFlag, HospID, Fn,InputDetailGrid,AllCatGrpFlag) {
	var flg = false; // �滻�����ַ�
	AllCatGrpFlag=AllCatGrpFlag||"";
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0, Input.indexOf("*"));
	}
	var PhaOrderUrl = 'dhcst.drugutil.csp?actiontype=GetPhaOrderItemForDialog&Input=' + encodeURI(Input) + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType=' + StkGrpType + '&Locdr=' + Locdr + '&NotUseFlag=' + NotUseFlag + '&QtyFlag=' + QtyFlag + '&HospID=' + HospID + '&start=' + 0 + '&limit=' + 15+"&AllCatGrpFlag="+AllCatGrpFlag; // ͨ��AJAX��ʽ���ú�̨����
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
	PhaOrderStore.load({
		callback: function(r, options, success) {
			if (success == false) {
			} else {
				InciDescLookupGrid.getSelectionModel().selectFirstRow(); // ѡ�е�һ�в���ý���
				InciDescLookupGrid.getView().focusRow(0); 				 //����google,yunhaibao20151126
				row = InciDescLookupGrid.getView().getRow(0);
				var element = Ext.get(row);
				if (typeof(element) != "undefined" && element != null) {
					setTimeout(function(){element.focus();},1000);
				}
			}
		}
	});

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel({
		singleSelect: true
	}); 
	// the check column is created using a custom plugin
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
		header: $g('������'),
		dataIndex: 'NotUseFlag',
		width: 45,
		renderer: function(v, p, record) {
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col' + (((v == 'Y') || (v == true)) ? '-on': '') + ' x-grid3-cc-' + this.id + '">&#160;</div>';
		}
	});
	var PhaOrderCm = new Ext.grid.ColumnModel([ {
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
		header: $g("���"),
		dataIndex: 'Spec',
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: $g("����"),
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
		header: $g("�ۼ�(��ⵥλ)"),
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
		hidden:true
	},
	{
		header: $g("������λ"),
		dataIndex: 'BuomDesc',
		width: 80,
		align: 'left',
		sortable: true,
		hidden:true
	},
	{
		header: $g("�ۼ�(������λ)"),
		dataIndex: 'bSp',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:true
	},
	{
		header: $g("����(������λ)"),
		dataIndex: 'BuomQty',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:true
	},
	{
		header: $g("�Ƽ۵�λ"),
		dataIndex: 'BillUomDesc',
		width: 80,
		align: 'left',
		sortable: true,
		hidden:true
	},
	{
		header: $g("�ۼ�(�Ƽ۵�λ)"),
		dataIndex: 'BillSp',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:true
	},
	{
		header: $g("����(�Ƽ۵�λ)"),
		dataIndex: 'BillUomQty',
		width: 100,
		align: 'right',
		sortable: true,
		hidden:true
	},
	{
		header: $g("����"),
		dataIndex: 'PhcFormDesc',
		width: 60,
		align: 'left',
		sortable: true,
		hidden:true
	},
	{
		header: $g("��Ʒ��"),
		dataIndex: 'GoodName',
		width: 80,
		align: 'left',
		sortable: true,
		hidden:true
	},
	{
		header: $g("ͨ����"),
		dataIndex: 'GeneName',
		width: 80,
		align: 'left',
		sortable: true,
		hidden:true
	},
	ColumnNotUseFlag]);
	//PhaOrderCm.defaultSortable = true; 
	InciDescLookupGrid = new dhcst.icare.Lookup({
		lookupListComponetId: 1872,
		defaultWidth:1000,
		lookupPage:$g( "ҩƷѡ��"),
		lookupName: "M_InciDesc",
		listeners: { 'selectRow': Fn },
		pageSize: 30,
		isCombo: true,
		listFields:fields,
		listColumns:PhaOrderCm,
		listUrl:PhaOrderUrl,
		dataSet:PhaOrderStore
	});


}
