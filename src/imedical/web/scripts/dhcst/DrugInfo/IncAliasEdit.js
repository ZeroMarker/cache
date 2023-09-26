/**
 * ��ѯ����
 */
function IncAliasEdit(dataStore, IncRowid) {
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
			// �����������
			SaveAlias();			
		}
	});
	// ���������Ϣ
	function SaveAlias() {
		// �����������
		if(MasterInfoGrid.activeEditor != null){
			MasterInfoGrid.activeEditor.completeEdit();
		} 
		var StrData="";
		var rowCount = MasterInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {				
			var rowData = MasterInfoStore.getAt(i);
			if(rowData.data.newRecord || rowData.dirty)
			{
				var IncaRowid = rowData.get("INCARowid");
				var IncaText = rowData.get("INCAText");	
				if(StrData=="")
				{
					StrData=IncaRowid+"^"+IncaText;
				}
				else
				{
					StrData=StrData+xRowDelim()+IncaRowid+"^"+IncaText;
				}
			}
		}
		if (StrData==""){
			Msg.info("warning","û����Ҫ���������!");
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=SaveIncAlias";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params: {InciRowid: IncRowid,ListData:StrData},
					waitMsg : '������...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							getIncAlias(IncRowid);
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
			Msg.info("warning","��ѡ��Ҫɾ���ı�����");
		}
		else {
			
			var record = MasterInfoGrid.getStore().getAt(cell[0]);
			var IncaRowid = record.get("INCARowid");
			if (IncaRowid == null || IncaRowid.length <= 0) {
				MasterInfoGrid.getStore().remove(record);
			} else {
				Ext.MessageBox.show({
							title : '��ʾ',
							msg : '�Ƿ�ȷ��ɾ���ñ�����Ϣ',
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
			var IncaRowid = record.get("INCARowid");
	
			// ɾ����������
			var url = DictUrl
					+ "druginfomaintainaction.csp?actiontype=DeleteIncAlias&IncaRowid="
					+ IncaRowid;
	
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
								Msg.info("error","ɾ��ʧ��!")
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
				iconCls : 'page_close',
				height:30,
				width:70,
				handler : function() {
					window.close();
				}
			});
	
	// ��ʾ��������
	function getIncAlias(InciRowid) {
		if (InciRowid == null || InciRowid=="") {
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=GetIncAlias&InciRowid="
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

	// ����·��
	var MasterInfoUrl = "";
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["INCARowid", "INCAText"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "INCARowid",
				fields : fields
			});
	// ���ݼ�
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "INCARowid",
				dataIndex : 'INCARowid',
				width : 10,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "����",
				dataIndex : 'INCAText',
				width : 260,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							
						var Alias = field.getValue();
						if (Alias == null || Alias.length <= 0) {
							Msg.info("warning", "��������Ϊ��!");
									return;
								}
								var cell = MasterInfoGrid.getSelectionModel()
										.getSelectedCell();
								MasterInfoGrid.startEditing(cell[0], 1);
							}
						}
					}
				}))
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
	
	function addNewRow() {

			var record = Ext.data.Record.create([{
						name : 'INCARowid',
						type : 'string'
					}, {
						name : 'INCAText',
						type : 'string'
					}]);

			var NewRecord = new record({
						INCARowid : '',
						INCAText : ''
					});
			MasterInfoStore.add(NewRecord);
			MasterInfoGrid.getSelectionModel()
					.select(MasterInfoStore.getCount() - 1, 1);
			MasterInfoGrid.startEditing(MasterInfoStore.getCount() - 1, 1);

	};


	// ҳǩ
	var panel= new Ext.TabPanel({
				activeTab : 0,
				height : 200,
				region : 'center',
				items : [{
							layout : 'fit',
							title : '����',
							items : MasterInfoGrid
						}]
			});

	var window = new Ext.Window({
				title : '����ά��',
				width :300,
				height : 400,
				modal:true,
				layout : 'border',
				items : [panel],
				tbar : [SaveBT, '-', DeleteBT, '-', closeBT]
			});
	window.show();
	
	//�Զ���ʾ��������
	getIncAlias(IncRowid);
}