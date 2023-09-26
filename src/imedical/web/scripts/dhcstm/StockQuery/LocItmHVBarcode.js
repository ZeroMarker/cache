/**
 * ��ѯ����
 */
function HVBarcodeQuery(Incil,IncDesc) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		
	// 3�رհ�ť
	var HVBarCodecloseBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '�رս���',
				iconCls : 'page_delete',
				height:30,
				width:70,
				handler : function() {
					HVBarcodeWin.close();
				}
			});
	
	// ��ʾ������Ӧ�����ø�ֵ����
	function getHVBarcode(Incil) {
		if (Incil == null || Incil=="") {
			return;
		}
		HVBarCodeInfoStore.setBaseParam('incil',Incil);
		var pagingSize=HVBarCodePagingToolbar.pageSize;
		HVBarCodeInfoStore.load({params:{start:0,limit:pagingSize}})
	}

	// ����·��
	var MasterInfoUrl = DictUrl + "itmtrackaction.csp?actiontype=GetEnableBarcodes";
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["dhcit", "HVBarCode", "BatchNo", "ExpDate", "IngrDate",
		"InciCode", "InciDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "dhcit",
				fields : fields
			});
	// ���ݼ�
	var HVBarCodeInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var HVBarCodeInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "����ID",
				dataIndex : 'dhcit',
				width : 60,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����",
				dataIndex : 'HVBarCode',
				width : 220,
				align : 'left',
				sortable : true,
				editable : true,
				editor : new Ext.grid.GridEditor(new Ext.form.TextField())
			}, {
				header : "����",
				dataIndex : 'BatchNo',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "Ч��",
				dataIndex : 'ExpDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'IngrDate',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "���ʴ���",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'InciDesc',
				width : 80,
				align : 'left',
				sortable : true
			}
		]);
	HVBarCodeInfoCm.defaultSortable = true;
	
	var HVBarCodePagingToolbar = new Ext.PagingToolbar({
					store : HVBarCodeInfoStore,
					pageSize : 20,
					displayInfo : true
				});
	
	var HVBarCodeInfoGrid = new Ext.ux.EditorGridPanel({
				id : 'HVBarCodeInfoGrid',
				title : '',
				cm : HVBarCodeInfoCm,
				sm : new Ext.grid.RowSelectionModel(),
				store : HVBarCodeInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				clicksToEdit : 1,
				tbar : ['->',HVBarCodecloseBT],
				bbar : [HVBarCodePagingToolbar]
			});

	var HVBarcodeWin = new Ext.Window({
				title : IncDesc+'��ֵ����',
				width :600,
				height : 500,
				modal:true,
				layout : 'fit',
				items : [HVBarCodeInfoGrid]
			});
	HVBarcodeWin.show();
	
	//�Զ���ʾ��������
	getHVBarcode(Incil);
}