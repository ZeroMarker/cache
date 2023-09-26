/**
 * ��ѯ����
 */
function certEdit(inci,manf,selectFn) {
 
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// 3�رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		text : '�ر�',
		tooltip : '�رս���',
		iconCls : 'page_delete',
		height:30,
		width:70,
		handler : function() {
			window.close();
		}
	});

	var selectBT = new Ext.Toolbar.Button({
		text : 'ѡ��',
		tooltip : 'ѡ��һ����¼',
		iconCls : 'page_delete',
		height:30,
		width:70,
		hidden:true,
		handler : function() {
			var rec=inciCertListGrid.getSelectionModel().getSelected();
			if (rec)
			{
				var certNo=rec.get("certNo");
				var certExpDate=rec.get("certExpDate");
				selectFn(certNo,certExpDate);
				window.close();
			}
			
		}
	});
	
	// ��ʾ�����ע��֤
	function getInciCertList(InciRowid,Manf) {
		if (InciRowid == null || InciRowid=="") {
			return;
		}
		var url = DictUrl	+ "druginfomaintainaction.csp?actiontype=GetInciCertList&InciRowid="+ InciRowid +"&Manf="+Manf;
		inciCertListStore.proxy = new Ext.data.HttpProxy({url : url});
		inciCertListStore.load({callback : function(r, options, success) {
			if (success == true) {
			
			}
		}} );
	}  

	// ����·��
	var Url = "";
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
		url : Url,
		method : "POST"
	});
	// ָ���в���
	var fields = ["irv","certNo", "certExpDate","certDate","certTime"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "irv",
		fields : fields
	});
	// ���ݼ�
	var inciCertListStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var nm = new Ext.grid.RowNumberer();
	var inciCertListCm = new Ext.grid.ColumnModel([nm, {
		header : "irv",
		dataIndex : 'irv',
		width : 10,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "ע��֤��",
		dataIndex : 'certNo',
		width :280,
		align : 'left',
		sortable : true
	},{
		header : "ע��֤Ч��",
		dataIndex : 'certExpDate',
		width : 100,
		align : 'left',
		sortable : true			
	},{
		header : "��������",
		dataIndex : 'certDate',
		width : 100,
		align : 'left',
		sortable : true			
	},{
		header : "����ʱ��",
		dataIndex : 'certTime',
		width : 100,
		align : 'left'
	}]);
	inciCertListCm.defaultSortable = true;
	
	var inciCertListGrid = new Ext.grid.EditorGridPanel({
		title : '',
		height : 170,
		cm : inciCertListCm,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		store : inciCertListStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		clicksToEdit : 1
	});

	// ҳǩ
	var panel= new Ext.TabPanel({
		activeTab : 0,
		height : 200,
		region : 'center',
		items : [{
			layout : 'fit',
			title : 'ע��֤',
			items : inciCertListGrid
		}]
	});

	var window = new Ext.Window({
		title : 'ע��֤���',
		width :600,
		height : 300,
		modal:true,
		layout : 'border',
		items : [panel],
		tbar : [closeBT,selectBT],
		listeners:{
			'show':function(){
				//�Զ���ʾ�������
				getInciCertList(inci,manf);
				if (selectFn) {selectBT.setVisible(true);}
			}
		}
	});
	window.show();
	
	
}