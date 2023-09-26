// /����: ��λ��ά��
// /����: ��λ��ά��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.20
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam='';
	var gGroupId=session['LOGON.GROUPID'];
	ChartInfoAddFun();
	
	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '����',
					id : 'PhaLoc',
					name : 'PhaLoc',
					width : 200,
					anchor:'30%',
					groupId:gGroupId
				});

		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					text : '��ѯ',
					tooltip : '�����ѯ',
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						searchData();
					}
				});

		/**
		 * ��ѯ����
		 */
		function searchData() {
			// ��ѡ����
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "���Ҳ���Ϊ�գ�");
				Ext.getCmp("PhaLoc").focus();
				return;
			}

			gStrParam=phaLoc;
			StkBinStore.load({params:{start:0,limit:999,LocId:gStrParam}});

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
			var cell = StkBinGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", "û��ѡ����!");
				return;
			}
			// ѡ����
			var row = cell[0];
			var record = StkBinGrid.getStore().getAt(row);
			var Rowid = record.get("sb");
			if (Rowid == null || Rowid.length <= 0) {
				StkBinGrid.getStore().remove(record);
			} else {
				Ext.MessageBox.show({
							title : '��ʾ',
							msg : '�Ƿ�ȷ��ɾ���û�λ��Ϣ',
							buttons : Ext.MessageBox.YESNO,
							parm:Rowid,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

			}

		}

		/**
		 * ɾ����λ��ʾ
		 */
		function showResult(btn,text,opt) {
			 
			if (btn == "yes") {
				
				var url = DictUrl
						+ "incstkbinaction.csp?actiontype=Delete&Rowid="
						+ opt.parm;
                var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '��ѯ��...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
										 mask.hide();
								if (jsonData.success == 'true') {
									// ɾ������
									Msg.info("success", "ɾ���ɹ�!");
									searchData();
								} else {
									var ret=jsonData.info;
									if(ret==-2){
										Msg.info("error", "�û�λ�Ѿ����ã�����ɾ����");
									}else{
										Msg.info("error", "ɾ��ʧ��:"+jsonData.info);
									}									
								}
							},
							scope : this
						});
			}
		}
		
		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '������',
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * ��շ���
		 */
		function clearData() {
			gStrParam='';
			PhaLoc.setValue("");
			StkBinGrid.store.removeAll();
			StkBinGrid.getView().refresh();
			SetLogInDept(PhaLoc.getStore(), "PhaLoc");
		}
// �½���ť
		var AddBT = new Ext.Toolbar.Button({
					id : "AddBT",
					text : '�½�',
					tooltip : '����½�',
					width : 70,
					height : 30,
					iconCls : 'page_add',
					handler : function() {

						// �ж��Ƿ��Ѿ��������
						var rowCount = StkBinGrid.getStore().getCount();
						if (rowCount > 0) {
							var rowData = StkBinStore.data.items[rowCount - 1];
							var data = rowData.get("sb");
							if (data == null || data.length <= 0) {
								Msg.info("warning", "�Ѵ����½���!");
								return;
							}
						}

						// ����һ��
						addNewRow();
					}
				});
		/**
		 * ����һ��
		 */
		function addNewRow() {
			var record = Ext.data.Record.create([{
						name : 'sb',
						type : 'string'
					}, {
						name : 'code',
						type : 'string'
					}, {
						name : 'desc',
						type : 'string'
					}]);
			var NewRecord = new record({
						sb : '',
						code : '',
						desc : ''
					});
			StkBinStore.add(NewRecord);
			StkBinGrid.getSelectionModel()
					.select(StkBinStore.getCount() - 1, 3);
			StkBinGrid.startEditing(StkBinStore.getCount() - 1, 3);
		};

		// ���水ť
		var SaveBT = new Ext.Toolbar.Button({
					id : "SaveBT",
					text : '����',
					tooltip : '�������',
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {

						// �����λ��						
						save();						
					}
				});
		function save(){
			PhaLocId=Ext.getCmp('PhaLoc').getValue();
			if(PhaLocId==null||PhaLocId.length<1){
				Msg.info("warning", "���Ҳ���Ϊ��!");
				return;
			}
			var ListDetail="";
			var rowCount = StkBinGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = StkBinStore.getAt(i);	
				//���������ݷ����仯ʱִ����������
				if(rowData.data.newRecord || rowData.dirty){
					var Rowid = rowData.get("sb");
					var Desc = rowData.get("desc");
				
					var str = Rowid + "^" + Desc ;	
					if(ListDetail==""){
						ListDetail=str;
					}
					else{
						ListDetail=ListDetail+xRowDelim()+str;
					}
				}
			}
			var url = DictUrl
					+ "incstkbinaction.csp?actiontype=Save";
			var mask=ShowLoadMask(Ext.getBody(),"���������Ժ�...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params: {LocId:PhaLocId,Detail:ListDetail},
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							 mask.hide();
							if (jsonData.success == 'true') {
								 
								Msg.info("success", "����ɹ�!");
								// ˢ�½���
								searchData();

							} else {
								var ret=jsonData.info;
								if(ret==-1){
									Msg.info("error", "����Ϊ��,���ܱ���!");
								}else if(ret==-2){
									Msg.info("error", "û����Ҫ���������!");
								}else if(ret==-4){
									Msg.info("error", "��λ�����ظ�!");
								}else {
									Msg.info("error", "������ϸ���治�ɹ���"+ret);
								}
								
							}
						},
						scope : this
					});

		}
		
		var nm = new Ext.grid.RowNumberer();
		var StkBinCm = new Ext.grid.ColumnModel([nm, {
					header : "rowid",
					dataIndex : 'sb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '����',
					dataIndex : 'code',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "��λ����",
					dataIndex : 'desc',
					width : 400,
					align : 'left',
					sortable : true,
					editor:new Ext.form.TextField({
						allowBlank : false,
						listeners:{
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									addNewRow();
								}
							}
						}
					})
				}]);
		StkBinCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
					+ 'incstkbinaction.csp?actiontype=Query&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["sb", "code", "desc"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "sb",
					fields : fields
				});
		// ���ݼ�
		var StkBinStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var StkBinGrid = new Ext.grid.EditorGridPanel({
					id:'StkBinGrid',
					region : 'center',
					cm : StkBinCm,
					store : StkBinStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					loadMask : true
				});
	
		var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			height : 110,
			labelAlign : 'right',
			title:'��λ��ά��',
			region: 'north',
			frame : true,
			//autoScroll : true,
			bodyStyle : 'padding:10px 10px 10px 10px;',
			tbar : [SearchBT, '-',AddBT,'-',SaveBT,'-',RefreshBT],		//'-', DeleteBT,		   						
			items : [PhaLoc	]		   	
		});

		// 5.2.ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [  HisListTab,
						{
			                 region: 'center',						                
						     title: '��λ��Ϣ',
						     layout: 'fit', // specify layout manager for items
						     items: StkBinGrid  			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
		
		// ��¼����Ĭ��ֵ
		SetLogInDept(PhaLoc.getStore(), "PhaLoc");
		searchData();
	}
})