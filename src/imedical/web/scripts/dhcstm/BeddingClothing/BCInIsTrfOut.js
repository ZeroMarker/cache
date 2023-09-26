// /����: ������ת���Ƶ�
// /����: ������ת���Ƶ�
// /��д�ߣ�wangjiabin
// /��д����: 2013-12-30

//�������ֵ��object
var BCInIsTrfOutParamObj = GetAppPropValue('DHCSTBCM');

Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gHospId = session['LOGON.HOSPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gInclbFlag = true;		//����������Ϣ����
	//ȡ��������
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	
	ChartInfoAddFun();

	function ChartInfoAddFun() {
		// ���ղ���
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '���ղ���',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '���ղ���...',
					defaultLoc:{}
		});
	
		// ��������
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '��������',
					id : 'SupplyPhaLoc',
					name : 'SupplyPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '��������...',
					groupId:gGroupId,
					listeners : {
						select : function(){
							QueryInclbInfo();
						}
					}
				});

		// ��������
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			LocId:gLocId,
			UserId:gUserId,
			anchor:'90%',
			width : 200,
			listeners : {
				select : function(){
					QueryInclbInfo();
				}
			}
		});
		StkGrpType.getStore().on('load',function(){
			QueryInclbInfo();
		})
		
		// ��������
		var OperateOutType = new Ext.ux.ComboBox({
			fieldLabel : '��������',
			id : 'OperateOutType',
			name : 'OperateOutType',
			store : OperateOutTypeStore,
			valueField : 'RowId',
			displayField : 'Description'
		});
		SetDefaultType();
		
		function SetDefaultType(){
			// Ĭ��ѡ�е�һ������
			OperateOutTypeStore.load({
				callback:function(r,options,success){
					if(success && r.length>0){
						OperateOutType.setValue(r[0].get(OperateOutType.valueField));
					}
				}
			});
		}

		// ת�Ƶ���
		var InItNo = new Ext.form.TextField({
					fieldLabel : 'ת�Ƶ���',
					id : 'InItNo',
					name : 'InItNo',
					anchor : '90%',
					width : 120,
					disabled : true
				});

		// ����
		var InItDate = new Ext.ux.DateField({
					fieldLabel : '����',
					id : 'InItDate',
					name : 'InItDate',
					anchor : '90%',
					width : 120,
					value : new Date(),
					disabled : true
				});

		// ���
		var InItFlag = new Ext.form.Checkbox({
					id : 'InItFlag',
					boxLabel : '���',
					anchor : '90%',
					width : 120,
					checked : false,
					disabled : true
				});

		// ��ע
		var Remark = new Ext.form.TextField({
					fieldLabel : '��ע',
					id : 'Remark',
					name : 'Remark',
					anchor : '90%',
					width : 120,
					disabled : false
				});

		//���󵥺�
		var ReqNo = new Ext.form.TextField({
					fieldLabel : '���󵥺�',
					id : 'ReqNo',
					name : 'ReqNo',
					anchor : '90%',
					width : 120,
					disabled : true
				});
				
				//���󵥺�
		var ReqNoID = new Ext.form.TextField({
					fieldLabel : '���󵥺�ID',
					id : 'ReqNoID',
					name : 'ReqNoID',
					anchor : '90%',
					width : 120,
					hidden:true,
					disabled : true
				});
				
		// ��ѯת�Ƶ���ť
		var SearchInItBT = new Ext.Toolbar.Button({
					id : "SearchInItBT",
					text : '��ѯ',
					tooltip : '�����ѯת�Ƶ�',
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
//						if(Ext.getCmp("SupplyPhaLoc").getValue()==""){
//							Msg.info("warning","�������Ų���Ϊ��!");
//							return;
//						}
						BCInIsTrfFind(0,Query);
					}
				});
		
		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
					id : "ClearBT",
					text : '���',
					tooltip : '������',
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
						SetFormOriginal(HisListTab);
					}
				});
		/**
		 * ��շ���
		 */
		function clearData() {
			SetLogInDept(Ext.getCmp("SupplyPhaLoc").getStore(),"SupplyPhaLoc");
			Ext.getCmp("RequestPhaLoc").setValue("");
			Ext.getCmp("InItNo").setValue("");
			Ext.getCmp("InItDate").setValue(new Date());
			Ext.getCmp("Remark").setValue("");
			Ext.getCmp("InItFlag").setValue(0);
			Ext.getCmp("ReqNo").setValue("");
			Ext.getCmp("ReqNoID").setValue("");
			gInitId="";
			gInclbFlag=true;
			Ext.getCmp('SupplyPhaLoc').setDisabled(false);
			Ext.getCmp('StkGrpType').setDisabled(false);
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			// �����ť�Ƿ����
			//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
			changeButtonEnable("1^1^1^1^0^0^0");
			Ext.getCmp("StkGrpType").getStore().load();		//ע��load�¼�����QueryInclbInfo
			SetDefaultType();
		}

		// �½���ť
		var AddBT = new Ext.Toolbar.Button({
					id : "AddBT",
					text : '����һ��',
					tooltip : '�������',
					width : 70,
					height : 30,
					iconCls : 'page_add',
					handler : function() {
						if(gParam[7]=='Y'){
							Msg.info("warning","ֻ�ܸ�������ת���Ƶ�,����������¼!");
							return;
						}
						// �ж�ת�Ƶ��Ƿ�������
						var initFlag = Ext.getCmp("InItFlag").getValue();
						if (gInitId!="" && initFlag != null && initFlag != 0) {
							Msg.info("warning", "ת�Ƶ�����ɲ���������ϸ!");
							return;
						}

						var requestphaLoc = Ext.getCmp("RequestPhaLoc")
								.getValue();
						if (requestphaLoc == null || requestphaLoc.length <= 0) {
							Msg.info("warning", "��ѡ����ղ���!");
							return;
						}
						var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
								.getValue();
						if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
							Msg.info("warning", "��ѡ��Ӧ����!");
							return;
						}
						if (requestphaLoc == supplyphaLoc) {
							Msg.info("warning", "���ղ��ź͹�Ӧ���Ų�����ͬ!");
							return;
						}

						var operatetype = Ext.getCmp("OperateOutType")
								.getValue();
						if (operatetype == null || operatetype.length <= 0) {
							Msg.info("warning", "��ѡ���������!");
							return;
						}
						if(gInclbFlag===true){
							DetailStore.removeAll();
							gInclbFlag = false;
						}
						// ����һ��
						addNewRow();
						//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
						changeButtonEnable("1^1^1^1^1^1^0");
					}
				});
		/**
		 * ����һ��
		 */
		function addNewRow() {
			var col=GetColIndex(DetailGrid,"inciDesc");
			// �ж��Ƿ��Ѿ��������
			var rowCount = DetailGrid.getStore().getCount();
			if (rowCount > 0) {
				var rowData = DetailStore.data.items[rowCount - 1];
				var data = rowData.get("inci");
				if (data == null || data.length <= 0) {
					
					DetailGrid.startEditing(DetailStore.getCount() - 1, col);
					return;
				}
			}
			
			var NewRecord = CreateRecordInstance(DetailStore.fields);
			DetailStore.add(NewRecord);
			DetailGrid.startEditing(DetailStore.getCount() - 1, col);
			SupplyPhaLoc.setDisabled(true);
		};

		// ���水ť
		var SaveBT = new Ext.ux.Button({
					id : "SaveBT",
					text : '����',
					tooltip : '�������',
					width : 70,
					height : 30,
					iconCls : 'page_save',
					handler : function() {
						if(gParam[7]=='Y'){
							Msg.info("warning","ֻ�ܸ�������ת���Ƶ�,���ɱ����¼�¼!");
							return;
						}
						if(DetailGrid.activeEditor != null){
							DetailGrid.activeEditor.completeEdit();
						}
						// ����ת�Ƶ�
						if(CheckDataBeforeSave()==true){
							saveOrder();
							// �����ť�Ƿ����
							//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
							//changeButtonEnable("1^1^1^1^1^1^0");
						}
					}
				});
				
		/**
		 * ������ⵥǰ���ݼ��
		 */		
		function CheckDataBeforeSave() {
					
			// �ж�ת�Ƶ��Ƿ������
			var initFlag = Ext.getCmp("InItFlag").getValue();
			if (initFlag != null && initFlag != 0) {
				Msg.info("warning", "ת�Ƶ�����ɲ����޸�!");
				return false;
			}

			var requestphaLoc = Ext.getCmp("RequestPhaLoc")
					.getValue();
			if (requestphaLoc == null || requestphaLoc.length <= 0) {
				Msg.info("warning", "��ѡ����ղ���!");
				return false;
			}
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
					.getValue();
			if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
				Msg.info("warning", "��ѡ��Ӧ����!");
				return false;
			}
			if (requestphaLoc == supplyphaLoc) {
				Msg.info("warning", "���ղ��ź͹�Ӧ���Ų�����ͬ!");
				return false;
			}

			var operatetype = Ext.getCmp("OperateOutType")
					.getValue();
			if (operatetype == null || operatetype.length <= 0) {
				Msg.info("warning", "��ѡ���������!");
				return false;
			}
			// 1.�ж�ת�������Ƿ�Ϊ��
			var rowCount = DetailGrid.getStore().getCount();
			// ��Ч����
			var count = 0;
			for (var i = 0; i < rowCount; i++) {
				var item = DetailStore.getAt(i).get("inci");
				if (item != undefined && item !='') {
					count++;
				}
			}
			if (rowCount <= 0 || count <= 0) {
				Msg.info("warning", "������ת����ϸ!");
				return false;
			}
			// 2.������䱳��
			for (var i = 0; i < rowCount; i++) {
				changeBgColor(i, "white");
			}
			// 3.�ж��ظ��������ο������--���ڸ�ֵ����,���ж��Ƿ��ظ�
			for (var i = 0; i < rowCount - 1; i++) {
				for (var j = i + 1; j < rowCount; j++) {
					var item_i = DetailStore.getAt(i).get("inclb");
					var HVFlag = DetailStore.getAt(i).get("HVFlag");
					var item_j = DetailStore.getAt(j).get("inclb");
					if (item_i != undefined && item_j != undefined
							&& item_i == item_j) {
						changeBgColor(i, "yellow");
						changeBgColor(j, "yellow");
						Msg.info("warning", "���������ظ�������������!");
						return false;
					}
				}
			}
			// 4.������Ϣ�������
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);
				var code = rowData.get("inciCode");
				if (code == null || code.length == 0) {
					continue;
				}
				var item = rowData.get("inci");
				if (item == undefined) {
					Msg.info("warning", "������Ϣ�������!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}
				var qty = DetailStore.getAt(i).get("qty");
				if ((item != undefined) && (qty != '')) {
					//��д�����Ĳ��ж�, ������ÿ��Ϊ��ֵʱ����ʾ���
					var avaQty = DetailStore.getAt(i).get("inclbAvaQty");
					var dirtyQty=DetailStore.getAt(i).get("dirtyQty");    //����ռ������
					if ((item != undefined) && ((qty - avaQty-dirtyQty) > 0)) {
						Msg.info("warning", "ת���������ܴ��ڿ��ÿ������!");
						DetailGrid.getSelectionModel().select(i, 1);
						changeBgColor(i, "yellow");
						return false;
					}else if(qty%1 != 0){
						//����ʾ,������
						Msg.info('warning', '��' + (i+1) + '������ΪС��, �����ʵ!');
					}
				}
			}
			
			return true;
		}
		

		/**
		 * ����ת�Ƶ�
		 */
		function saveOrder() {
			//��Ӧ����RowId^�������RowId^���ת������RowId^��������RowId^��ɱ�־^����״̬^�Ƶ���RowId^����RowId^�������^��ע
			var inItNo = Ext.getCmp("InItNo").getValue();
			var supplyPhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var requestPhaLoc = Ext.getCmp("RequestPhaLoc").getValue();
			var reqid=Ext.getCmp("ReqNoID").getValue();
			//alert(reqid)
			var operatetype = Ext.getCmp("OperateOutType").getValue();	
			var Complete='N';
			var Status=10;
			var StkGrpId = Ext.getCmp("StkGrpType").getValue();
			var StkType = App_StkTypeCode;					
			var remark = Ext.getCmp("Remark").getValue();
			
			var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^"
					+ Complete + "^" + Status + "^" + gUserId + "^"+StkGrpId+"^"+StkType+"^"+remark;
			//��ϸid^����id^����^��λ^������ϸid^��ע
			var ListDetail="";
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);	
				//���������ݷ����仯ʱִ����������
				if(rowData.data.newRecord || rowData.dirty){
					var Initi = rowData.get("initi");
					var Inclb = rowData.get("inclb");
					if(Inclb==null || Inclb==""){continue;}
					var Qty = rowData.get("qty");
					if(Qty==0){continue;}
					var UomId = rowData.get("uom");
					var ReqItmId = rowData.get("inrqi");
					var Remark = rowData.get("remark");
					var BarCode = rowData.get("HVBarCode");
					
					var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^"
							+ ReqItmId + "^" + Remark + "^" + BarCode;	
					if(ListDetail==""){
						ListDetail=str;
					}else{
						ListDetail=ListDetail+xRowDelim()+str;
					}
				}
			}
			if((gInitId=="")&&(ListDetail=="")){
				Msg.info("warning","û����Ҫ�������ϸ����!");
				return;
			}
			if(!IsFormChanged(HisListTab) && ListDetail==""){
				Msg.info("warning","û����Ҫ���������!");
				return false;
			}
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=Save";
			var loadMask=ShowLoadMask(Ext.getBody(),"������...");
			Ext.Ajax.request({
						url : url,
						params:{Rowid:gInitId,MainInfo:MainInfo,ListDetail:ListDetail},
						method : 'POST',
						waitMsg : '������...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ˢ�½���
								var InitRowid = jsonData.info;
								Msg.info("success", "����ɹ�!");
								// 7.��ʾ���ⵥ����
								Query(InitRowid);
								//���ݲ��������Զ���ӡ
								if(gParam[3]=='Y'){
									PrintInIsTrf(InitRowid);
								}
							} else {
								var ret=jsonData.info;								
								Msg.info("error", "���治�ɹ���"+ret);								
							}
						},
						scope : this
					});
			loadMask.hide();
		}

		// ɾ����ť
		var DeleteBT = new Ext.Toolbar.Button({
					id : "DeleteBT",
					text : 'ɾ��',
					tooltip : '���ɾ��',
					width : 70,
					height : 30,
					iconCls : 'page_delete',
					disabled : true,
					handler : function() {
						deleteData();
					}
				});

		function deleteData() {
			// �ж�ת�Ƶ��Ƿ������
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 0) {
				Msg.info("warning", "ת�Ƶ�����ɲ���ɾ��!");
				return;
			}

			var inItNo = Ext.getCmp("InItNo").getValue();
			if (inItNo == null || inItNo.length <= 0) {
				Msg.info("warning", "û����Ҫɾ����ת�Ƶ�!");
				return;
			}

			Ext.MessageBox.show({
						title : '��ʾ',
						msg : '�Ƿ�ȷ��ɾ������ת�Ƶ�?',
						buttons : Ext.MessageBox.YESNO,
						fn : showDeleteIt,
						icon : Ext.MessageBox.QUESTION
					});

		}

		/**
		 * ɾ��ת�Ƶ���ʾ
		 */
		function showDeleteIt(btn) {
			if (btn == "yes") {
				var inItNo = Ext.getCmp("InItNo").getValue();
				var url = DictUrl
						+ "dhcinistrfaction.csp?actiontype=Delete&Rowid="
						+ gInitId;

				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '��ѯ��...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									// ɾ������
									Msg.info("success", "ת�Ƶ�ɾ���ɹ�!");
									clearData();
								} else {
									Msg.info("error", "ת�Ƶ�ɾ��ʧ��:"+jsonData.info);
								}
							},
							scope : this
						});
			}
		}

		/**
		 * ɾ��ѡ��������
		 */
		function deleteDetail() {
			// �ж�ת�Ƶ��Ƿ������
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 0) {
				Msg.info("warning", "ת�Ƶ�����ɲ���ɾ��!");
				return;
			}
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			if (cell == null) {
				Msg.info("warning", "û��ѡ����!");
				return;
			}
			// ѡ����
			var row = cell[0];
			var record = DetailGrid.getStore().getAt(row);
			var InItIRowId = record.get("initi");
			if (InItIRowId == null || InItIRowId.length <= 0) {
				DetailGrid.getStore().remove(record);
				DetailGrid.getView().refresh();
			} else {
				Ext.MessageBox.show({
							title : '��ʾ',
							msg : '�Ƿ�ȷ��ɾ����������Ϣ?',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});

			}
		}
		/**
		 * ɾ����ʾ
		 */
		function showResult(btn) {
			if (btn == "yes") {
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var row = cell[0];
				var record = DetailGrid.getStore().getAt(row);
				var InItIRowId = record.get("initi");
				
				// ɾ����������
				var url = DictUrl
						+ "dhcinistrfaction.csp?actiontype=DeleteDetail&RowId="
						+ InItIRowId ;

				Ext.Ajax.request({
							url : url,
							method : 'POST',
							waitMsg : '��ѯ��...',
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Msg.info("success", "ɾ���ɹ�!");
									DetailGrid.getStore().remove(record);
									DetailGrid.getView().refresh();
								} else {
									Msg.info("error", "ɾ��ʧ��!");
								}
							},
							scope : this
						});
			}
		}

		// ��ɰ�ť
		var CheckBT = new Ext.Toolbar.Button({
					id : "CheckBT",
					text : '���',
					tooltip : '������',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					disabled : true,
					handler : function() {
						Complete();
					}
				});

		/**
		 * ���ת�Ƶ�
		 */
		function Complete() {
			// �ж�ת�Ƶ��Ƿ������
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 0) {
				Msg.info("warning", "ת�Ƶ������!");
				return;
			}
			
			if (gInitId=='') {
				Msg.info("warning", "û����Ҫ��ɵ�ת�Ƶ�!");
				return;
			}
			var url = DictUrl
					+ 'dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='
					+ gInitId+'&Status=11&Complete=Y';

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '��ѯ��...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ��˵���
								Msg.info("success", "�ɹ�!");
								Ext.getCmp("InItFlag").setValue(1);
								
								//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
								changeButtonEnable("1^1^0^0^0^0^1");
							} else {
								Msg.info("error", "ʧ��:"+jsonData.info);
							}
						},
						scope : this
					});
		}

		// ȡ����ɰ�ť
		var CancelCmpBT = new Ext.Toolbar.Button({
					id : "CancelCmpBT",
					text : 'ȡ�����',
					tooltip : '���ȡ�����',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					disabled : true,
					handler : function() {
						CancelComplete();
					}
				});
		/**
		 * ȡ�����ת�Ƶ�
		 */
		function CancelComplete() {
			// �ж�ת�Ƶ��Ƿ������
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag != null && inItFlag != 1) {
				Msg.info("warning", "ת�Ƶ���δ���!");
				return;
			}
			
			if (gInitId=='') {
				Msg.info("warning", "û����Ҫȡ����ɵ�ת�Ƶ�!");
				return;
			}
			var url = DictUrl
					+ 'dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='
					+ gInitId+'&Status=10&Complete=N';

			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '��ѯ��...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ��˵���
								Msg.info("success", "�ɹ�!");
								Ext.getCmp("InItFlag").setValue(0);
								
								//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
								changeButtonEnable("1^1^1^1^1^1^0");
								
							} else {
								Msg.info("error", "ʧ�ܣ�"+jsonData.info);
							}
						},
						scope : this
					});
		}

		// ɾ����ϸ
		var DeleteDetailBT = new Ext.Toolbar.Button({
					id : "DeleteDetailBT",
					text : 'ɾ��һ��',
					tooltip : '���ɾ��',
					width : 70,
					height : 30,
					iconCls : 'page_delete',
					//disabled : true,
					handler : function() {
						deleteDetail();
					}
		});
		
		// ����ת�뵥��������, ��ѯת�뵽�����ҵĵ���
		var SelTransBT = new Ext.Toolbar.Button({
				id : "SelTransBT",
				text : 'ѡȡת�뵥',
				tooltip : '�����ѯת�뵥',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					var FrLoc=Ext.getCmp("SupplyPhaLoc").getValue();
					if(FrLoc==null){
						Msg.info("warning","��ѡ��Ӧ����!")
						return;
					}
					SelInIsTrfIn(FrLoc,Query);
				}
		});
		
		// ��ӡ��ť
		var PrintBT = new Ext.Toolbar.Button({
					text : '��ӡ',
					tooltip : '�����ӡ',
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						if (gInitId ==null || gInitId=="") {
							Msg.info("warning", "û����Ҫ��ӡ��ת�Ƶ�!");
							return;
						}
						PrintInIsTrf(gInitId);
					}
				});
				
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
					minChars : 1,
					pageSize : 10,
					listWidth : 250,
					valueNotFoundText : ''
				});
		/**
		 * ��λչ���¼�
		 */
		CTUom.on('beforequery', function(combo) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					var InciDr = record.get("inci");
					var url = DictUrl
							+ 'drugutil.csp?actiontype=INCIUom&ItmRowid='
							+ InciDr;
					CTUomStore.proxy = new Ext.data.HttpProxy({
								url : url
							});
					CTUom.store.removeAll();
					CTUom.store.load();
				});

		/**
		 * ��λ�任�¼�
		 */
		CTUom.on('select', function(combo) {
					var cell = DetailGrid.getSelectionModel().getSelectedCell();
					var record = DetailGrid.getStore().getAt(cell[0]);
					
					var value = combo.getValue();        //Ŀǰѡ��ĵ�λid
					var BUom = record.get("BUomId");
					var ConFac = record.get("ConFac");   //��λ��С��λ��ת����ϵ					
					var TrUom = record.get("uom");    //Ŀǰ��ʾ�ĳ��ⵥλ
					var Sp = record.get("sp");
					var Rp = record.get("rp");
					var NewSp = record.get("newSp");
					var InclbQty=record.get("inclbQty");
					var ReqStkQty=record.get("reqLocStkQty");
					var inclbDirtyQty=record.get("inclbDirtyQty");
					var AvaQty=record.get("inclbAvaQty");
					var ReqQty=record.get("reqQty");
					var TrQty=record.get("qty");
					var dirtyQty=record.get("dirtyQty");
					if (value == null || value.length <= 0) {
						return;
					} else if (TrUom == value) {
						return;
					} else if (value==BUom) {     //��ѡ��ĵ�λΪ������λ��ԭ��ʾ�ĵ�λΪ��λ
						record.set("sp", accDiv(Sp,ConFac));
						record.set("newSp", accDiv(NewSp,ConFac));
						record.set("rp", accDiv(Rp,ConFac));
						record.set("inclbQty", accMul(InclbQty,ConFac));
						record.set("reqLocStkQty", accMul(ReqStkQty,ConFac));
						record.set("inclbDirtyQty", accMul(inclbDirtyQty,ConFac));
						record.set("inclbAvaQty", accMul(AvaQty,ConFac));
						record.set("reqQty", accMul(ReqQty,ConFac));
						record.set("dirtyQty",accMul(dirtyQty,ConFac));
					} else{  //��ѡ��ĵ�λΪ��λ��ԭ���ǵ�λΪС��λ
						record.set("sp", accMul(Sp,ConFac));
						record.set("newSp", accMul(NewSp,ConFac));
						record.set("rp", accMul(Rp,ConFac));
						record.set("inclbQty", accDiv(InclbQty,ConFac));
						record.set("reqLocStkQty", accDiv(ReqStkQty,ConFac));
						record.set("inclbDirtyQty", accDiv(inclbDirtyQty,ConFac));
						record.set("inclbAvaQty", accDiv(AvaQty,ConFac));
						record.set("reqQty", accDiv(ReqQty,ConFac));
						record.set("dirtyQty",accDiv(dirtyQty,ConFac));
					}
					record.set("uom", combo.getValue());
		});
		
		// ��ʾ���ⵥ����
		function Query(InitRowid) {
			if (InitRowid == null || InitRowid =='') {
				return;
			}
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=Select&Rowid="
					+ InitRowid;
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '��ѯ��...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								var list = jsonData.info.split("^");
								if (list.length > 0) {
									gInitId=InitRowid;
									Ext.getCmp("InItNo").setValue(list[8]);
									addComboData(Ext.getCmp("SupplyPhaLoc").getStore(),list[6],list[26]);
									Ext.getCmp("SupplyPhaLoc").setValue(list[6]);
									addComboData(RequestPhaLoc.getStore(),list[12],list[27]);
									Ext.getCmp("RequestPhaLoc").setValue(list[12]);
									//OperateOutTypeStore.load();
									addComboData(OperateOutType.getStore(),list[21],list[32]);
									Ext.getCmp("OperateOutType").setValue(list[21]);
									addComboData(null,list[24],list[36],StkGrpType);
									Ext.getCmp("StkGrpType").setValue(list[24]);
									Ext.getCmp("InItDate").setValue(list[29]);	
									Ext.getCmp("InItFlag").setValue(list[14]=='Y'?true:false);
									Ext.getCmp("Remark").setValue(list[9]);
									Ext.getCmp("ReqNo").setValue(list[28]);		
									Ext.getCmp("ReqNoID").setValue(list[30]);	
										
									// �����ť�Ƿ����
									//��ѯ^���^����^����^ɾ��^���^ȡ�����
									var CompFlag =list[14];
									if(CompFlag=="Y"){
										changeButtonEnable("1^1^0^0^0^0^1");
									}else{
										changeButtonEnable("1^1^1^1^1^1^0");
									}
									// ��ʾ��ⵥ��ϸ����
									getDetail(InitRowid);
								}
							} else {
								Msg.info("warning", jsonData.info);
							}
							SetFormOriginal(HisListTab);
						},
						scope : this
					});				
		}
		// ��ʾ��ⵥ��ϸ����
		function getDetail(InitRowid) {
			if (InitRowid == null || InitRowid=='') {
				return;
			}
			var DetailUrl =DictUrl+
				'dhcinistrfaction.csp?actiontype=QueryDetail&Parref=&start=0&limit=999';
			DetailStore.proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
			DetailStore.removeAll();
			DetailStore.load({
				params:{start:0,limit:999,Parref:InitRowid},
				callback : function(r,options,success){
					gInclbFlag = false;
					Ext.getCmp('SupplyPhaLoc').setDisabled(true);
					Ext.getCmp('StkGrpType').setDisabled(true);
				}
			});
		}
		
		// ת����ϸ
		// ����·��
		var DetailUrl =DictUrl+
			'dhcinistrfaction.csp?actiontype=QueryDetail&Parref=&start=0&limit=999';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		
		// ָ���в���
		var fields = ["initi", "inrqi", "inci","inciCode",
				"inciDesc", "inclb", "batexp", "manf","manfName",
				"qty", "uom", "sp","status","remark",
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin",
				"pp", "spec","newSp", "spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty",
				"inclbAvaQty","TrUomDesc","dirtyQty","HVFlag","HVBarCode"
			];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "initi",
					fields : fields
				});
		// ���ݼ�
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : "ת��ϸ��RowId",
					dataIndex : 'initi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "����RowId",
					dataIndex : 'inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '���ʴ���',
					dataIndex : 'inciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : '��������',
					dataIndex : 'inciDesc',
					width : 230,
					align : 'left',
					sortable : true,
					editor : new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									// �ж�ת�Ƶ��Ƿ������
									var initFlag = Ext.getCmp("InItFlag")
											.getValue();
									if (initFlag != null && initFlag != 0) {
										Msg.info("warning", "ת�Ƶ�����ɲ����޸�!");
										return;
									}

									var stkgrp = Ext.getCmp("StkGrpType")
											.getValue();
									GetPhaOrderInfo(field.getValue(), stkgrp);
								}
							}
						}
					})
				}, {
					header : "��ֵ��־",
					dataIndex : 'HVFlag',
					width : 80,
					align : 'center',
					sortable : true,
					hidden : true
				}, {
					header : "����RowId",
					dataIndex : 'inclb',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "����/Ч��",
					dataIndex : 'batexp',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'manfName',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'inclbAvaQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "ת������",
					dataIndex : 'qty',
					width : 80,
					align : 'right',
					sortable : true,
					renderer : function(value, metadata, record, rowIndex, colIndex, store){
						if(value % 1 != 0){
							metadata.attr = 'style="color:red;"';
						}
						return value;
					},
					editor : new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									// �ж�ת�Ƶ��Ƿ������
									var inItFlag = Ext.getCmp("InItFlag").getValue();
									if (inItFlag != null && inItFlag != 0) {
										Msg.info("warning", "ת�Ƶ�����ɲ����޸�!");
										return;
									}
									var qty = field.getValue();
									if (qty == null || qty.length <= 0) {
										Msg.info("warning", "ת����������Ϊ��!");
										return;
									}
									if (qty <= 0) {
										Msg.info("warning", "ת����������С�ڻ����0!");
										return;
									}
									var cell = DetailGrid.getSelectionModel().getSelectedCell();
									var record = DetailGrid.getStore().getAt(cell[0]);
									var salePriceAMT = record.get("sp")* qty;
									record.set("spAmt",	salePriceAMT);
									var AvaQty = record.get("inclbAvaQty");
									if (qty > AvaQty) {
										Msg.info("warning", "ת���������ܴ��ڿ��ÿ������!");
										return;
									}

									// ����һ��
									addNewRow();
								}
							}
						}
					})
				}, {
					header : "ת�Ƶ�λ",
					dataIndex : 'uom',
					width : 80,
					align : 'left',
					sortable : true,
					renderer : Ext.util.Format.comboRenderer2(CTUom,"uom","TrUomDesc"), // pass combo instance to reusable renderer					
					editor : new Ext.grid.GridEditor(CTUom)
				}, {
					header : "����",
					dataIndex : 'rp',
					width : 60,
					align : 'right',
					sortable : true
				}, {
					header : "�ۼ�",
					dataIndex : 'sp',
					width : 60,
					align : 'right',
					sortable : true
				}, {
					header : "��������",
					dataIndex : 'reqQty',
					width : 80,
					align : 'right',
					hidden : true,
					sortable : true
				}, {
					header : "��λ��",
					dataIndex : 'stkbin',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "���󷽿��",
					dataIndex : 'reqLocStkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "���ο��",
					dataIndex : 'inclbQty',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "����ռ������",
					dataIndex : 'dirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "ռ������",
					dataIndex : 'inclbDirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "�����ۼ�",
					dataIndex : 'newSp',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "���",
					dataIndex : 'spec',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "�ۼ۽��",
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : "ת����",
					dataIndex : 'ConFac',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "������λ",
					dataIndex : 'BUomId',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "ת�������ӱ�RowId",
					dataIndex : 'inrqi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}]);

		var DetailGrid = new Ext.grid.EditorGridPanel({
					id : 'DetailGrid',
					title:'���ת�Ƶ�',
					tbar:[AddBT,'-',DeleteDetailBT],
					region : 'center',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					listeners:{
						'beforeedit' : function(e){
							if(Ext.getCmp("InItFlag").checked==true){
								return false;
							}
						}
					}
				});
		
		/***
		**����Ҽ��˵�
		**/		
		DetailGrid.addListener('rowcontextmenu', rightClickFn);//�Ҽ��˵�����ؼ����� 
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mnuDelete', 
					handler: deleteDetail, 
					text: 'ɾ��' 
				}
			] 
		}); 
		
		//�Ҽ��˵�����ؼ����� 
		function rightClickFn(grid,rowindex,e){
			grid.getSelectionModel().select(rowindex,0);
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); 
		}

		/**
		 * �������ʴ��岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			var phaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
			if (item != null && item.length > 0) {
				IncItmBatWindow(item, stkgrp, App_StkTypeCode, phaLoc, "N", "1", gHospId,phaLocRQ,
						returnInfo);
			}
		}
		
		/**
		 * ����������Ϣ
		 */
		function returnInfo(records) {
			if (records == null || records == "") {
				return;
			}
			Ext.each(records,function(record,index,allItems){
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var selectRow = cell[0];
				var rowData = DetailStore.getAt(selectRow);
				// ����ظ�����
				var INITIINCLBDR = record.get("Inclb");
				var findIndex=DetailStore.findExact('inclb',INITIINCLBDR,0);
				if(findIndex>=0 && findIndex!=selectRow){
					Msg.info("warning", "���������ظ�������������!");
					return;
				}
				rowData.set("inci", record.get("InciDr"));
				rowData.set("inciCode", record.get("InciCode"));
				rowData.set("inciDesc", record.get("InciDesc"));
				rowData.set("inclb",record.get("Inclb"));
				rowData.set("batexp",record.get("BatExp"));
				rowData.set("manfName",record.get("Manf"));
				rowData.set("inclbQty",record.get("InclbQty"));
				addComboData(CTUomStore,record.get("PurUomId"),record.get("PurUomDesc"));
				rowData.set("uom",record.get("PurUomId"));
				rowData.set("rp",record.get("Rp"));
				rowData.set("sp",record.get("Sp"));
				//rowData.set("reqQty", record.get("ReqQty"));
				rowData.set("stkbin", record.get("StkBin"));
				rowData.set("reqLocStkQty",record.get("RequrstStockQty"));
				rowData.set("newSp",record.get("BatSp"));
				rowData.set("spec", record.get("Sepc"));
				rowData.set("ConFac", record.get("ConFac"));
				rowData.set("BUomId",record.get("BUomId"));
				rowData.set("inclbDirtyQty", record.get("DirtyQty"));
				rowData.set("inclbAvaQty", record.get("AvaQty"));
				rowData.set("HVFlag", record.get("HVFlag"));
				rowData.set("qty", record.get("OperQty"));
				rowData.set("spAmt", accMul(record.get("Sp"),record.get("OperQty")));
				var lastIndex = DetailStore.getCount()-1;
				if(DetailStore.getAt(lastIndex).get('inclb')!=""){
					addNewRow();
				}else{
					var col=GetColIndex(DetailGrid,'inciDesc')
					DetailGrid.startEditing(lastIndex,col);
				}
			});
		}
		
		// �任����ɫ
		function changeBgColor(row, color) {
			DetailGrid.getView().getRow(row).style.backgroundColor = color;
		}

		// �����ť�Ƿ����
		function changeButtonEnable(str) {
			var list = str.split("^");
			for (var i = 0; i < list.length; i++) {
				if (list[i] == "1") {
					list[i] = false;
				} else {
					list[i] = true;
				}
			}
			//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
			SearchInItBT.setDisabled(list[0]);
			ClearBT.setDisabled(list[1]);
			//AddBT.setDisabled(list[2]);
			SaveBT.setDisabled(list[3]);
			DeleteBT.setDisabled(list[4]);			
			CheckBT.setDisabled(list[5]);
			CancelCmpBT.setDisabled(list[6]);
		}

		var HisListTab = new Ext.ux.FormPanel({
			title:'������ת��',
			tbar : [SearchInItBT, '-', ClearBT, '-', SaveBT, '-', DeleteBT, '-', CancelCmpBT, '-', CheckBT,'-',PrintBT,'-',SelTransBT],
			items:[{
				xtype : 'fieldset',
				title : 'ת�Ƶ���Ϣ',
				layout : 'column',	
				style : 'padding:5px 0px 0px 5px',
				defaults:{border:false,columnWidth : .33,xtype:'fieldset'},
				items : [{
					items: [SupplyPhaLoc,RequestPhaLoc,StkGrpType]
				},{
					items: [InItNo,InItDate,OperateOutType]
				},{
					items: [Remark,InItFlag,ReqNoID]
				}]
			}]
		});

		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, DetailGrid],
			renderTo : 'mainPanel'
		});
		
		// ��¼����Ĭ��ֵ
		SetLogInDept(Ext.getCmp("SupplyPhaLoc").getStore(), "SupplyPhaLoc");
		
		if(gInitId!=undefined && gInitId!='' && gFlag==1){
			Query(gInitId);
		}
		
		//��������ص��첽����, ��������.store��load�¼���
		function QueryInclbInfo(){
			if(!gInclbFlag){
				return false;
			}
			DetailStore.removeAll();
			var PhaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			if(PhaLoc==""){
				return;
			}
			var Scg = Ext.getCmp("StkGrpType").getValue();
			var NotUseFlag = "N", QtyFlag="1";
			var StrParam = PhaLoc+"^"+Scg+"^"+NotUseFlag+"^"+QtyFlag+"^"+gUserId;
			var DetailUrl = DictUrl+ 'dhcinistrfaction.csp?actiontype=QueryInclbDetail&StrParam='+StrParam;
			DetailStore.proxy = new Ext.data.HttpProxy({
					url:DetailUrl,
					method:'GET'
				});
			DetailStore.load({params:{start:0,limit:999}})
		}
	}
})