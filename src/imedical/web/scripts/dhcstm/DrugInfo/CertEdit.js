/**
 * ��ѯ����
 */
function certEdit(inci,manf,selectFn,manfName) {
 
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// 3�رհ�ť
	var closeBT = new Ext.Toolbar.Button({
		text : '�ر�',
		tooltip : '�رս���',
		iconCls : 'page_gear',
		height:30,
		width:70,
		handler : function() {
			window.close();
		}
	});

	var selectBT = new Ext.Toolbar.Button({
		text : 'ѡ��',
		tooltip : 'ѡ��һ����¼',
		iconCls : 'page_goto',
		height:30,
		width:70,
		hidden:true,
		handler : function() {
			var tab=certPanel.getActiveTab();
			var certNo,certExpDate;
			var ItmCertDesc, RegCertDateOfIssue, ImportFlag, OriginId, Origin;
			if (tab.getId()=='inciCertList') 
			{
				var rec=inciCertListGrid.getSelectionModel().getSelected();
				if (rec)
				{
					var certNo=rec.get("certNo");
					var certExpDate=rec.get("certExpDate");
				}
				else
				{Msg.info("warning","û��ѡ���¼");return;}
			}
			else if (tab.getId()=='manfCertList') 
			{
				var rec=manfCertListGrid.getSelectionModel().getSelected();
				if (rec)
				{
					var certNo=rec.get("certNo");
					var certExpDate=rec.get("certExpDate");
					var ItmCertDesc = rec.get('ItmCertDesc');
					var RegCertDateOfIssue = rec.get('RegCertDateOfIssue');
					var ImportFlag = rec.get('ImportFlag');
					var OriginId = rec.get('OriginId');
					var Origin = rec.get('Origin');
				}
			}
			else
			{Msg.info("warning","û��ѡ���¼");return;}
			
			if (!Ext.isEmpty(certNo))
			{
				var ss=Ext.Msg.show({
				   title:'��ʾ',
				   msg: '�Ƿ���ø�ע��֤��',
				   buttons: Ext.Msg.OKCANCEL,
				   fn: function(b,t,o){if (b=='ok') {
							selectFn(certNo,certExpDate,ItmCertDesc, RegCertDateOfIssue, ImportFlag, OriginId, Origin);
							window.close();
						}
				   },
				   icon: Ext.MessageBox.QUESTION
				});	
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

	//	20170817
	var mUrl= DictUrl+'druginfomaintainaction.csp?actiontype=GetManfCertList&Manf='+manf;
	var mProxy=new Ext.data.HttpProxy({
		url :mUrl,
		method : "POST"
	});
	var mReader=new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "mc",
		fields : ["certNo", "certExpDate","certDate","certTime","mc",
			'ItmCertDesc', 'RegCertDateOfIssue', 'ImportFlag', 'OriginId', 'Origin'
		]
	});
	var manfCertListStore = new Ext.data.Store({
		proxy : mProxy,
		reader :mReader 
	});

	//	20170817
	var manfCertListCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
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
	},{
		header : "ע��֤����",
		dataIndex : 'ItmCertDesc',
		width : 100,
		align : 'left'
	},{
		header : "��֤����",
		dataIndex : 'RegCertDateOfIssue',
		width : 100,
		align : 'left'
	},{
		header : "���ڱ��",
		dataIndex : 'ImportFlag',
		width : 60,
		align : 'left'
	},{
		header : "����",
		dataIndex : 'Origin',
		width : 60,
		align : 'left'
	}]);
	
	//��������ע��֤ 20170817
	var manfCertListGrid = new Ext.grid.GridPanel({
		height : 170,
		cm : manfCertListCm,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		store : manfCertListStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true
	});
	// ҳǩ
	var certPanel= new Ext.TabPanel({
		activeTab : 0,
		height : 200,
		region : 'center',
		items : [{
			layout : 'fit',
			id:'inciCertList',
			title : '��������ʷע��֤�б�',
			items : inciCertListGrid
		},{
			layout : 'fit',
			title : '����ע��֤�б�',
			id:'manfCertList',
			items : manfCertListGrid
		}]
		
	});

	var window = new Ext.Window({
		title : 'ע��֤���'+' < ���ң� '+manfName+' >',
		width :800,
		height : 400,
		modal:true,
		layout : 'border',
		items : [certPanel],
		tbar : [closeBT,selectBT],
		listeners:{
			'show':function(){
				//�Զ���ʾ�������
				getInciCertList(inci,manf);
				manfCertListStore.load();
				if (selectFn) {selectBT.setVisible(true);}
				var tab=Ext.getCmp('inciCertList');
				
				if (inci=='') { tab.setDisabled(true);certPanel.setActiveTab('manfCertList');}
				else {tab.setDisabled(false); }
			}
		}
	});
	window.show();
	
}