/**
 * ��ѯ�ɹ���ϸ�޸Ľ���
 */
function ChangeDetailQuery(InpiId){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// 3�رհ�ť
	var PlanChangeDetailCloseBT = new Ext.Toolbar.Button({
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
	function GetChange(InpiId) {
		if (InpiId == null || InpiId=="") {
			return;
		}
		PlanChangeDetailStore.setBaseParam('InpiId',InpiId);
		var pagingSize=PlanChangeDetailPagingToolbar.pageSize;
		PlanChangeDetailStore.load({params:{start:0,limit:pagingSize}})
	}

	// ����·��
	var MasterInfoUrl = DictUrl + "inpurplanaction.csp?actiontype=GetChangeDetail";
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["DhcPaiId", "UserName", "ResultQty", "PriorQty", "UomDesc",
		"InciCode", "InciDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "dhcit",
				fields : fields
			});
	// ���ݼ�
	var PlanChangeDetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var PlanChangeDetailCm = new Ext.grid.ColumnModel([nm, {
				header : "Id",
				dataIndex : 'DhcPaiId',
				width : 60,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "�޸���",
				dataIndex : 'UserName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "��ǰ����",
				dataIndex : 'PriorQty',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "�ĺ�����",
				dataIndex : 'ResultQty',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "��λ",
				dataIndex : 'UomDesc',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "���ʴ���",
				dataIndex : 'InciCode',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'InciDesc',
				width : 90,
				align : 'left',
				sortable : true
			}
		]);
	PlanChangeDetailCm.defaultSortable = true;		
	var PlanChangeDetailPagingToolbar = new Ext.PagingToolbar({
					store : PlanChangeDetailStore,
					pageSize : 20,
					displayInfo : true
				});		
	var PlanChangeDetailGrid = new Ext.ux.EditorGridPanel({
				id : 'PlanChangeDetailGrid',
				title : '',
				cm : PlanChangeDetailCm,
				sm : new Ext.grid.RowSelectionModel(),
				store : PlanChangeDetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				clicksToEdit : 1,
				tbar : ['->',PlanChangeDetailCloseBT],
				bbar : [PlanChangeDetailPagingToolbar]
			});
     
	var PlanChangeDetailWin = new Ext.Window({
				title : '�޸ļ�¼',
				width :600,
				height : 500,
				modal:true,
				layout : 'fit',
				items : [PlanChangeDetailGrid]
			});
	PlanChangeDetailWin.show();
	
	//�Զ���ʾ��������
	GetChange(InpiId)		
	
	}