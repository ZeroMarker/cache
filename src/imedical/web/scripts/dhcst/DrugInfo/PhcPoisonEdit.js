/**
 * ��ѯ����
 */
function PhcPoisonEdit(dataStore, IncRowid) {
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
			// �����Ч����
			SaveData();			
		}
	});
	// �����Ч����
	function SaveData() {
		// �����Ч����
		var StrData="";
		var rowCount = MasterInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {				
			var rowData = MasterInfoStore.getAt(i);
			if(rowData.data.newRecord || rowData.dirty)
			{
				var PoLinkRowid = rowData.get("PoLinkRowid");
				var PoDr = rowData.get("PoDr");
				var PoDesc = rowData.get("PoDesc");
				if(StrData=="")
				{
					StrData=PoLinkRowid+"^"+PoDr+"^"+PoDesc;
				}
				else
				{
					StrData=StrData+xRowDelim()+PoLinkRowid+"^"+PoDr+"^"+PoDesc;
				}
			}
		}
		if(StrData==""){
			Msg.info("warning","û����Ҫ���������!");
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=SavePhcPoison";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params: {InciRowid:IncRowid,ListData:StrData},
					waitMsg : '������...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							getPhcPoison(IncRowid);
							Msg.info("success", "����ɹ�!");
							
						} else {
							Msg.info("error", "����ʧ��:"+jsonData.info);
						}
					},
					scope : this
				});
	
	}
		
	//2. ɾ����ť
	var DeleteBT = new Ext.Toolbar.Button({
		id : "DeleteBT",
		text : 'ɾ��',
		tooltip : '���ɾ��',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function() {
			deleteData();
		}
	});

	function deleteData() {
		var cell = MasterInfoGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","��ѡ��Ҫɾ���Ĺ��Ʒ��࣡");
		}
		else {
			
			var record = MasterInfoGrid.getStore().getAt(cell[0]);
			var PoLinkRowid = record.get("PoLinkRowid");
			if (PoLinkRowid == null || PoLinkRowid.length <= 0) {
				MasterInfoGrid.getStore().remove(record);
			} else {
				Ext.MessageBox.show({
							title : '��ʾ',
							msg : '�Ƿ�ȷ��ɾ���ù��Ʒ�����Ϣ',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});
			}							
		}

	}	
	
	function showResult(btn) {
		if (btn == "yes") {
			var cell = MasterInfoGrid.getSelectionModel().getSelectedCell();
			var record = MasterInfoGrid.getStore().getAt(cell[0]);
			var PoLinkRowid = record.get("PoLinkRowid");
	
			// ɾ����������
			var url = DictUrl
					+ "druginfomaintainaction.csp?actiontype=DeletePhcPoison&PoLinkRowid="
					+ PoLinkRowid;
	
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success","ɾ���ɹ�!");
								MasterInfoGrid.getStore().remove(record);
								MasterInfoGrid.view.refresh();
							} else {
								Msg.info("error","ɾ��ʧ��!");
							}
						},
						scope : this
					});
		}
	}
		
	// 3�رհ�ť
	var closeBT = new Ext.Toolbar.Button({
				text : '�ر�',
				tooltip : '�رս���',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {
					window.close();
				}
			});
	
	// ��ʾ��Ч��λ��Ϣ
	function getPhcPoison(InciRowid) {
		if (InciRowid == null || InciRowid=="") {
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=GetPhcPoison&InciRowid="
				+ InciRowid;

		MasterInfoStore.proxy = new Ext.data.HttpProxy({
					url : url
				});
		MasterInfoStore.load({callback : function(r, options, success) {
			if (success == true) {
				//����һ����
				addNewRow();
			}
		}} );
	}  

	var PHPoisonDR = new Ext.ux.ComboBox({
	fieldLabel : '���Ʒ���',
	id : 'PHPoisonDR',
	name : 'PHPoisonDR',
	store : PhcPoisonStore,
	valueField : 'RowId',
	displayField : 'Description'
  });
	
	// ����·��
	var MasterInfoUrl = "";
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoLinkRowid", "PoDr","PoDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoLinkRowid",
				fields : fields
			});
	// ���ݼ�
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "PoLinkRowid",
				dataIndex : 'PoLinkRowid',
				width : 10,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "���Ʒ���",
					dataIndex : 'PoDr',
					width : 200,
					align : 'left',
					sortable : true,
					renderer : Ext.util.Format.comboRenderer2(PHPoisonDR,"PoDr","PoDesc"),
					editor : new Ext.grid.GridEditor(PHPoisonDR)
				}]);
	MasterInfoCm.defaultSortable = true;
	
	var MasterInfoGrid = new Ext.grid.EditorGridPanel({
				title : '',
				height : 170,
				cm : MasterInfoCm,
				sm : new Ext.grid.CellSelectionModel({}),
				store : MasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				clicksToEdit : 1
			});

	MasterInfoGrid.on('beforeedit',function(e){
		if(e.field=="EQUomRowid"){
			var uomid=e.record.get("EQUomRowid");
			var uom=e.record.get("EQUom");
			addComboData(CTUomStore,uomid,uom);
		}
	});
	function addNewRow() {

			var record = Ext.data.Record.create([{
						name : 'PoLinkRowid',
						type : 'string'
					}, {
						name : 'PoDr',
						type : 'string'
					}, {
						name : 'PoDesc',
						type : 'string'
					}]);

			var NewRecord = new record({
						PoLinkRowid : '',
						PoDr:'',
						PoDesc : ''
					});
			MasterInfoStore.add(NewRecord);
			MasterInfoGrid.getSelectionModel().select(MasterInfoStore.getCount() - 1, 1);
			MasterInfoGrid.startEditing(MasterInfoStore.getCount() - 1, 1);

	};


	// ҳǩ
	var panel= new Ext.TabPanel({
				activeTab : 0,
				height : 200,
				region : 'center',
				items : [{
							layout : 'fit',
							title : '���Ʒ���',
							items : MasterInfoGrid
						}]
			});

	var window = new Ext.Window({
				title : '���Ʒ���ά��',
				width :300,
				height : 400,
				modal:true,
				layout : 'border',
				items : [panel],
				tbar : [SaveBT, '-', DeleteBT, '-', closeBT]
			});
	window.show();
	
	//�Զ���ʾ��Ч��λ
	getPhcPoison(IncRowid);
}