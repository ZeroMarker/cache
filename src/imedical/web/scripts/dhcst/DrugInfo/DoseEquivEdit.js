/**
 * ��ѯ����
 */
function DoseEquivEdit(dataStore, IncRowid,Fn) {
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
				var EqRowid = rowData.get("EQRowid");
				var EqUomId = rowData.get("EQUomRowid");
				var EqQty = rowData.get("EQQty");
				var EqDefaultDose = rowData.get("EQDefaultDose");
				if ((EqQty=="")||(EqQty==0)||(EqUomId=="")){continue;}
				if(StrData=="")
				{
					StrData=EqRowid+"^"+EqUomId+"^"+EqQty+"^"+EqDefaultDose;
				}
				else
				{
					StrData=StrData+","+EqRowid+"^"+EqUomId+"^"+EqQty+"^"+EqDefaultDose;
				}
			}
		}
		if(StrData==""){
			Msg.info("warning","û����Ҫ���������!");
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=SaveDoseEquiv";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params: {InciRowid:IncRowid,ListData:StrData},
					waitMsg : '������...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							getDoseEquiv(IncRowid);
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
			Msg.info("warning","��ѡ��Ҫɾ���ĵ�Ч��λ��");
		}
		else {
			
			var record = MasterInfoGrid.getStore().getAt(cell[0]);
			var EqRowid = record.get("EQRowid");
			if (EqRowid == null || EqRowid.length <= 0) {
				MasterInfoGrid.getStore().remove(record);
			} else {
				Ext.MessageBox.show({
							title : '��ʾ',
							msg : '�Ƿ�ȷ��ɾ���õ�Ч��λ��Ϣ',
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
			var EqRowid = record.get("EQRowid");
	
			// ɾ����������
			var url = DictUrl
					+ "druginfomaintainaction.csp?actiontype=DeleteDoseEquiv&EqRowid="
					+ EqRowid;
	
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
				iconCls : 'page_close',
				handler : function() {
					window.close();
				}
			});
	
	// ��ʾ��Ч��λ��Ϣ
	function getDoseEquiv(InciRowid) {
		if (InciRowid == null || InciRowid=="") {
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=GetDoseEquiv&InciRowid="
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

			// ��λ
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : '��λ',
				id : 'CTUom',
				name : 'CTUom',
				anchor : '90%',
				width : 120,
				store : CTUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '��λ...',
				selectOnFocus : true,
				forceSelection : true,
				//typeAhead:true,
				minChars : 1,
				pageSize : 10,
				listWidth : 250,
				valueNotFoundText : '',
				listeners : {
					'beforequery' : function(e) {
						var desc=Ext.getCmp('CTUom').getRawValue();
						if(desc!=null || desc!=""){
							CTUomStore.removeAll();
							CTUomStore.setBaseParam("CTUomDesc",desc);
							CTUomStore.load()
							//CTUomStore.load({params:{CTUomDesc:desc,start:0,limit:10}});
						}
					}
				}
			});
	
	// ����·��
	var MasterInfoUrl = "";
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["EQRowid", "EQUomRowid","EQUom","EQQty","EQDefaultDose"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "EQRowid",
				fields : fields
			});
	// ���ݼ�
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "EQRowid",
				dataIndex : 'EQRowid',
				width : 10,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "��Ч��λ",
					dataIndex : 'EQUomRowid',
					width : 80,
					align : 'left',
					sortable : true,
					renderer : Ext.util.Format.comboRenderer2(CTUom,"EQUomRowid","EQUom"),
					editor : new Ext.grid.GridEditor(CTUom)
			}, {
					header : "��Ч����",
					dataIndex : 'EQQty',
					width : 80,
					align : 'right',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : false,
						decimalPrecision:4,
						allowNegative:false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var qty = field.getValue();
									if (qty == null || qty.length <= 0) {
										Msg.info("warning", "��Ч��������Ϊ��!");
										return;
									}
									if (qty <= 0) {
										Msg.info("warning", "��Ч��������С�ڻ����0!");
										return;
									}
									// �ж��Ƿ��Ѿ��������
									var rowCount = MasterInfoGrid.getStore()
											.getCount();
									if (rowCount > 0) {
										var rowData = MasterInfoStore.data.items[rowCount
												- 1];
										var data = rowData.get("EQUom");
										if (data == null || data.length <= 0) {
											return;
										}
									}
									// ����һ��
									addNewRow();
								}
							}
						}
					}))
				},{
					header : "ȱʡ����",
					dataIndex : 'EQDefaultDose',
					width : 80,
					align : 'right',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : true,
						decimalPrecision:4,
						allowNegative:false						
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

	MasterInfoGrid.on('beforeedit',function(e){
		if(e.field=="EQUomRowid"){
			var uomid=e.record.get("EQUomRowid");
			var uom=e.record.get("EQUom");
			addComboData(CTUomStore,uomid,uom);
		}
	});
	function addNewRow() {

			var record = Ext.data.Record.create([{
						name : 'EQRowid',
						type : 'string'
					}, {
						name : 'EQUomRowid',
						type : 'string'
					}, {
						name : 'EQUom',
						type : 'string'
					}, {
						name : 'EQQty',
						type : 'string'
					}, {
						name : 'EQDefaultDose',
						type : 'string'
					}]);

			var NewRecord = new record({
						EQRowid : '',
						EQUomRowid:'',
						EQUom : '',
						EQQty:'',
						EQDefaultDose:''
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
							title : '��Ч��λ',
							items : MasterInfoGrid
						}]
			});

	var window = new Ext.Window({
				title : '��Ч��λά��',
				width :300,
				height : 400,
				modal:true,
				layout : 'border',
				items : [panel],
				tbar : [SaveBT, '-', DeleteBT, '-', closeBT]
			});
	window.show();
	
	//�Զ���ʾ��Ч��λ
	getDoseEquiv(IncRowid);
	//�رմ����¼�
	window.on('close', function(panel) {
			Fn(IncRowid)
		});
}