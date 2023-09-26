//SkinTestArc.js
//wwl 20160307 Ƥ��ҽ������
function SkinTestArc(ArcRowid)
{
	var User=session['LOGON.USERID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
		// ����·��
	var MasterInfoUrl = "";
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["SkinRowid","InciDr","InciCode", "InciDesc"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "SkinRowid",
				fields : fields
			});
	// ���ݼ�
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "SkinRowid",
				dataIndex : 'SkinRowid',
				width : 10,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "InciDr",
				dataIndex : 'InciDr',
				width : 10,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ҩƷ����",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : false
			}, {
					header : 'ҩƷ����',
					dataIndex : 'InciDesc',
					width : 170,
					align : 'left',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.TextField({
								selectOnFocus : true,
								allowBlank : false,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											

											GetPhaOrderInfo(field.getValue(),
													"");
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
			
	var SaveBT = new Ext.Toolbar.Button({
		id:"SaveBT",
		text:'����',
		tooltip:'�������',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			
			SaveData();			
		}		
		});
		
		// ������Ϣ
	function SaveData() {
		
		if(MasterInfoGrid.activeEditor != null){
			MasterInfoGrid.activeEditor.completeEdit();
		} 
		var StrData="";
		var rowCount = MasterInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {				
			var rowData = MasterInfoStore.getAt(i);
			if(rowData.data.newRecord || rowData.dirty)
			{
				var InciDr = rowData.get("InciDr");
				var SkinRowid = rowData.get("SkinRowid");
				var InciCode = rowData.get("InciCode");	
				var InciDesc = rowData.get("InciDesc");	
				
				if(StrData=="")
				{
					StrData=SkinRowid+"^"+InciDr;
				}
				else
				{
					StrData=StrData+xRowDelim()+SkinRowid+"^"+InciDr;
				}
			}
		}
		if (StrData==""){
			Msg.info("warning","û����Ҫ���������!");
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=SaveSkinInfo";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params: {ArcRowid:ArcRowid,ListData:StrData},
					waitMsg : '������...',
					success : function(result, request) {						
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							getSkinInfo(ArcRowid);
							Msg.info("success", "����ɹ�!");
							
						} else {
							Msg.info("error", "����ʧ��:"+jsonData.info);
						}
					},
					scope : this
				});
	
	}
	// ɾ����ť
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
			Msg.info("warning","��ѡ��Ҫɾ���ļ�¼��");
		}
		else {
			
			var record = MasterInfoGrid.getStore().getAt(cell[0]);
			var SkinRowid = record.get("SkinRowid");
			if (SkinRowid == null || SkinRowid.length <= 0) {
				MasterInfoGrid.getStore().remove(record);
			} else {
				Ext.MessageBox.show({
							title : '��ʾ',
							msg : '�Ƿ�ȷ��ɾ���ü�¼',
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
			var SkinRowid = record.get("SkinRowid");
	
			// ɾ����������
			var url = DictUrl
					+ "druginfomaintainaction.csp?actiontype=DeleteSkinInfo&SkinRowid="
					+ SkinRowid;
	
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
	
		// ��ʾƤ��ҽ������
	function getSkinInfo(Arc) {
		if (Arc == null || Arc=="") {
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=GetSkinInfo&ArcRowid="
				+ Arc;

		MasterInfoStore.proxy = new Ext.data.HttpProxy({
					url : url
				});
		MasterInfoStore.load({callback : function(r, options, success) {
			//alert(success)
			if (success == true) {
				//����һ����
				addNewRow();
			}
		}} );
	};  

	// �رհ�ť
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
			
	
	function GetPhaOrderInfo(item, group) {
						
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, "","G", "", "N", "0", User,
						getDrugList);
			}
		}
			
	 function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var InciDr = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			
			var cell = MasterInfoGrid.getSelectionModel().getSelectedCell();
			var row = cell[0];
			var rowData = MasterInfoGrid.getStore().getAt(row);
			rowData.set("InciDr",InciDr);
			rowData.set("InciCode",inciCode);
			rowData.set("InciDesc",inciDesc);
	 }
	 
	 
	function addNewRow() {
			var record = Ext.data.Record.create([{
						name : 'SkinRowid',
						type : 'string'
					}, {
						name : 'InciDr',
						type : 'string'
					}, {
						name : 'InciCode',
						type : 'string'
					}, {
						name : 'InciDesc',
						type : 'string'
					}]);



			var NewRecord = new record({
				        SkinRowid :'',
						InciDr : '',
						InciCode : '',
						InciDesc:''
					});
			MasterInfoStore.add(NewRecord);
			MasterInfoGrid.getSelectionModel().select(MasterInfoStore.getCount() - 1, 1);
			MasterInfoGrid.startEditing(MasterInfoStore.getCount() - 1, 1);

	}		
		// ҳǩ
	var panel= new Ext.TabPanel({
				activeTab : 0,
				height : 200,
				region : 'center',
				items : [{
							layout : 'fit',
							title : 'Ƥ�Թ���',
							items : MasterInfoGrid
						}]
			});

	var window = new Ext.Window({
				title : 'Ƥ�Թ���ά��',
				width :300,
				height : 400,
				modal:true,
				layout : 'border',
				items : [panel],
				tbar : [SaveBT, '-', DeleteBT, '-', closeBT]
			});
			
	window.show();	
		
    getSkinInfo(ArcRowid);
    
	}