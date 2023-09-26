/**
 * �����־����
 */
 function HospZeroStkEdit(dataStore, IncRowid,zeroObj) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// ���水ť
	var SaveBT = new Ext.Toolbar.Button({
		id : "SaveBT",
		text : '����',
		tooltip : '�������',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			Save();			
		}
	});
	// ���������־
	function Save() {
		if(MasterInfoGrid.activeEditor != null){
			MasterInfoGrid.activeEditor.completeEdit();
		} 
		var StrData="";
		var rowCount = MasterInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {				
			var rowData = MasterInfoStore.getAt(i);
			if(rowData.data.newRecord || rowData.dirty)
			{
				var HospCheck=rowData.get("HospCheck");
				var INCZeroId = rowData.get("INCZeroId");
				var HospId=rowData.get("HospId");
				var ZeroType = rowData.get("ZeroType");	
				if(ZeroType=="")
				{
					ZeroType="N"
				}
				if(StrData=="")
				{
					StrData=INCZeroId+"^"+HospId+"^"+ZeroType+"^"+HospCheck;
				}
				else
				{
					StrData=StrData+xRowDelim()+INCZeroId+"^"+HospId+"^"+ZeroType+"^"+HospCheck;
				}
			}
			
		}
		if (StrData==""){
			Msg.info("warning","û����Ҫ���������!");
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=SaveINCZero";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params: {InciRowid: IncRowid,ListData:StrData},
					waitMsg : '������...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							getINCZero(IncRowid);
							Msg.info("success", "����ɹ�!");
							
						} else {
							Msg.info("error", "����ʧ��:"+jsonData.info);
						}
					},
					scope : this
				});
	
	}
	
    // �رհ�ť
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
	
	// ��ʾ�����־
	function getINCZero(InciRowid) {
		
		if (InciRowid == null || InciRowid=="") {
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=GetINCZero&InciRowid="
				+ InciRowid;

		MasterInfoStore.proxy = new Ext.data.HttpProxy({
					url : url
				});
				MasterInfoStore.load();
	} 
	var HospCheck = new Ext.grid.CheckColumn({
	    header:'Ժ��ѡ��',
	    dataIndex:'HospCheck',
	    width:70,
	    sortable:true
    });	
	var ZeroType = new Ext.grid.CheckColumn({
	    header:'�����־',
	    dataIndex:'ZeroType',
	    width:70,
	    sortable:true
    });
	// ����·��
	var MasterInfoUrl = "";
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["INCZeroId", "HospId","HospCode","HospDesc","HospCheck","ZeroType"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "INCZeroId",
				fields : fields
			});
	// ���ݼ�
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "INCZeroId",
				dataIndex : 'INCZeroId',
				width : 50,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : "HospId",
				dataIndex : 'HospId',
				width : 50,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : "Ժ������",
				dataIndex : 'HospCode',
				width : 60,
				align : 'left',
				sortable : true
			},{
				header : "Ժ������",
				dataIndex : 'HospDesc',
				width : 120,
				align : 'left',
				sortable : true
			},
			HospCheck,
			ZeroType
			]);
	
	MasterInfoCm.defaultSortable = true;
	
	var MasterInfoGrid = new Ext.grid.EditorGridPanel({
				title : '',
				height : 170,
				cm : MasterInfoCm,
				sm : new Ext.grid.CellSelectionModel({}),
				store : MasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				plugins:[HospCheck,ZeroType],
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
							title : 'Ժ��-�����־',
							items : MasterInfoGrid
						}]
			});

	var window = new Ext.Window({
				title : 'Ժ�������־ά��',
				width :370,
				height : 400,
				modal:true,
				layout : 'border',
				items : [panel],
				tbar : [SaveBT, '-', closeBT]
				,
				listeners:{
					'close':function(){	
						if (zeroObj){
							var zeroStr=tkMakeServerCall("web.DHCSTM.DHCIncHosp","GetHospZeroStr",IncRowid);
							zeroObj.setValue(zeroStr);
						}
					}
				}
			});
	window.show();
	
	//�Զ���ʾ��������
	getINCZero(IncRowid);
}