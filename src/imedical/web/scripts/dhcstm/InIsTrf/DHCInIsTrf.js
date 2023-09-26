// 2015-06-09 ���ǩ��ȷ�ϵ���
// /����: ���ת���Ƶ�
// /����: ���ת���Ƶ�
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.18

	//ȡ��ֵ�������
	var UseItmTrack="";
	if(gItmTrackParam.length<1){
		GetItmTrackParam();
		UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
	}
	//��ʹ�ø�ֵ����,��һ�����͸�ֵ��������˵�,����������
	UseItmTrack=UseItmTrack&&gHVInIsTrf;

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gHospId=session['LOGON.HOSPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//ȡ��������
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	
	//2015-06-09 csp���ǩ�ֱ�־����(���Ƴ������,�����հ�ť�Ƿ�ɼ�,BCFlag����,�Ѿ���ѯ�������)
	gHVSignFlag = typeof(gHVSignFlag)=='undefined'? '' : gHVSignFlag;
	
	ChartInfoAddFun();

	function ChartInfoAddFun() {
		// ������
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '������',
					id : 'RequestPhaLoc',
					emptyText : '������...',
					defaultLoc:{},
					childCombo : 'ReqLocUser',
					listeners:{
						'beforeselect' : function(combo, record, index){
							var requestLoc = record.get(combo.valueField);
							var provLoc = Ext.getCmp('SupplyPhaLoc').getValue();
							return CheckMainLoc(provLoc, requestLoc);
						},
						'select':function(cb)
						{
							var requestLoc=cb.getValue();
							var provLoc=Ext.getCmp('SupplyPhaLoc').getValue();
							Ext.getCmp("StkGrpType").setFilterByLoc(provLoc,requestLoc);
						}
					}
		});
		/*
		var ReqLocUser = new Ext.ux.ComboBox({
			id : 'ReqLocUser',
			fieldLabel : '������',
			store : AllUserStore,
			filterName : 'Desc'
		});*/
		var ReqLocUser = new Ext.ux.ComboBox({
			id : 'ReqLocUser',
			fieldLabel : '������',
			store : DeptUserStore,
			filterName : 'Desc',
			listeners:{
				'beforequery':function(e){
					DeptUserStore.removeAll();
					var Loc=Ext.getCmp('RequestPhaLoc').getValue();
					DeptUserStore.setBaseParam('locId',Loc);
				}
			}
		});
		
		// ��������
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '��������',
					id : 'SupplyPhaLoc',
					emptyText : '��������...',
					groupId:gGroupId,
					listeners:{
						'beforeselect' : function(combo, record, index){
							var requestLoc = Ext.getCmp('RequestPhaLoc').getValue();
							var provLoc = record.get(combo.valueField);
							if(CheckMainLoc(provLoc, requestLoc) == false){
								Ext.getCmp('RequestPhaLoc').setValue('');
							}
						},
						'select':function(cb)
						{
							var provLoc=cb.getValue();
							var requestLoc=Ext.getCmp('RequestPhaLoc').getValue();
							Ext.getCmp("StkGrpType").setFilterByLoc(provLoc,requestLoc);
						}
					}
				});

		var VirtualFlag = new Ext.form.Checkbox({
			hideLabel:true,
			boxLabel : '���',
			id : 'VirtualFlag',
			name : 'VirtualFlag',
			anchor : '90%',
			checked : false,
			listeners:{
				check:function(chk,bool){
					if(bool){
						var phaloc=Ext.getCmp("SupplyPhaLoc").getValue();
						var url="dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc="+phaloc;
						var response=ExecuteDBSynAccess(url);
						var jsonData=Ext.util.JSON.decode(response);
						if(jsonData.success=='true'){
							var info=jsonData.info;
							var infoArr=info.split("^");
							var vituralLoc=infoArr[0],vituralLocDesc=infoArr[1];
							addComboData(Ext.getCmp("SupplyPhaLoc").getStore(),vituralLoc,vituralLocDesc);
							Ext.getCmp("SupplyPhaLoc").setValue(vituralLoc);
						}
					}else{
						SetLogInDept(Ext.getCmp("SupplyPhaLoc").getStore(), "SupplyPhaLoc");
					}
				}
			}
		});	
				
		// ��������
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			width : 200
		}); 

		// ��������
		var OperateOutType = new Ext.ux.ComboBox({
			fieldLabel : '��������',
			id : 'OperateOutType',
			name : 'OperateOutType',
			store : OperateOutTypeStore,
			valueField : 'RowId',
			displayField : 'Description'
		});
		
		// Ĭ��ѡ�е�һ������
		OperateOutTypeStore.load({
			callback:function(r,options,success){
				if(success && r.length>0){
					OperateOutType.setValue(r[0].get(OperateOutType.valueField));
				}
			}
		});

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
					fieldLabel : '���',
					id : 'InItFlag',
					name : 'InItFlag',
					anchor : '90%',
					width : 120,
					checked : false,
					disabled : true
				});
		//20180914
		var ExpressFlag=new Ext.form.Checkbox({
			id: 'ExpressFlag',
			fieldLabel:'�ͻ�',
			anchor:'100%',
			allowBlank:true
		});

		// ���ⱸע
		var Remark = new Ext.form.TextField({
					fieldLabel : '���ⱸע',
					id : 'Remark',
					name : 'Remark',
					anchor : '90%',
					width : 120,
					disabled : false
				});

		// ����ע
		var ReqRemark = new Ext.form.TextField({
					fieldLabel : '����ע',
					id : 'ReqRemark',
					name : 'ReqRemark',
					anchor : '90%',
					width : 120,
					disabled : true
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
				
		// ����ID
		var ReqNoID = new Ext.form.TextField({
					fieldLabel : '����ID',
					id : 'ReqNoID',
					name : 'ReqNoID',
					anchor : '90%',
					width : 120,
					hidden:true,
					disabled : true
				});
		
		var InitStatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['10', 'δ���'], ['11', '�����'],
					['20', '������˲�ͨ��'], ['21', '�������ͨ��'],
					['30','�ܾ�����'], ['31','������']]
		});
		
		var InitStatus = new Ext.form.ComboBox({
			fieldLabel : '����״̬',
			id : 'InitStatus',
			anchor:'90%',
			store : InitStatusStore,
			triggerAction : 'all',
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			editable : false,
			valueNotFoundText : '',
			disabled : true,
			hidden : gHVSignFlag!='Y'
		});
		Ext.getCmp("InitStatus").setValue('10');
		
		// ��ѯת�Ƶ���ť
		var SearchInItBT = new Ext.Toolbar.Button({
					id : "SearchInItBT",
					text : '��ѯ',
					tooltip : '�����ѯת�Ƶ�',
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						if(Ext.getCmp("SupplyPhaLoc").getValue()==""){
							Msg.info("warning","�������Ų���Ϊ��!");
							return;
						}
						StockTransferSearch(DetailStore,Query,gHVSignFlag);
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
				if (isDataChanged(panel,DetailGrid)){
					Ext.Msg.show({
						title:'��ʾ',
						msg: '�Ѿ��Ըõ����������޸ģ�����ִ�н���ʧ���޸ģ�������',
						buttons: Ext.Msg.YESNO,
						fn: function(btn){
							if (btn=='yes') {
								clearData();
								SetFormOriginal(panel);
							}
						}
					})
				}else{
					clearData(); 
					SetFormOriginal(panel);
				}
			}
		});
		/**
		 * ��շ���
		 */
		function clearData() {
			var InitStatus = Ext.getCmp('InitStatus').getValue();
			if(gHVSignFlag && gInitId!='' && InitStatus!=31){
				if(!confirm('��ǰ������δ��ȫ����, �Ƿ�������?')){
					return false;
				}
			}
			
			Ext.getCmp("ReqLocUser").setValue("");
			Ext.getCmp("RequestPhaLoc").setValue("");
			Ext.getCmp("InItNo").setValue("");
			Ext.getCmp("InItDate").setValue(new Date());
			Ext.getCmp("Remark").setValue("");
			Ext.getCmp("ReqRemark").setValue("");
			Ext.getCmp("InItFlag").setValue(0);
			Ext.getCmp("VirtualFlag").setValue(false);
			SetLogInDept(SupplyPhaLoc.getStore(),"SupplyPhaLoc");
			Ext.getCmp("SupplyPhaLoc").setDisabled(0);
			Ext.getCmp("RequestPhaLoc").setDisabled(0);
			Ext.getCmp("StkGrpType").setDisabled(0);
			Ext.getCmp("ReqNo").setValue("");
			Ext.getCmp("ReqNoID").setValue("");
			Ext.getCmp('InitStatus').setValue('10');
			Ext.getCmp('ExpressFlag').setValue(false);
			gInitId="";
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
			// �����ť�Ƿ����
			//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
			changeButtonEnable("1^1^1^0^0^0^0^0^0");
			//������ܴ���href����
			CheckLocationHref();
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
							Msg.info("warning", "��ѡ��������!");
							return;
						}
						var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
								.getValue();
						if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
							Msg.info("warning", "��ѡ��Ӧ����!");
							return;
						}
						if (requestphaLoc == supplyphaLoc) {
							Msg.info("warning", "�����ź͹�Ӧ���Ų�����ͬ!");
							return;
						}

						var operatetype = Ext.getCmp("OperateOutType")
								.getValue();
						if (InitParamObj.OutTypeNotNull == 'Y' && Ext.isEmpty(operatetype)) {
							Msg.info("warning", "��ѡ���������!");
							return;
						}
						var stkgrptype= Ext.getCmp("StkGrpType")
								.getValue();
						if (stkgrptype== null || stkgrptype.length <= 0) {
							Msg.info("warning", "����δѡ��,�������ʵ����!");
							//return;
						}
						// ����һ��
						addNewRow();
						//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
						changeButtonEnable("1^1^1^1^1^1^0^0^0");
					}
				});
		/**
		 * ����һ��
		 */
		function addNewRow() {
			var NewGridFlag = (DetailGrid.getStore().getCount() == 0);
			var inciIndex=GetColIndex(DetailGrid,"inciDesc");
			var barcodeIndex=GetColIndex(DetailGrid,"HVBarCode");
			var col=UseItmTrack?barcodeIndex:inciIndex;
			// �ж��Ƿ��Ѿ��������
			var rowCount = DetailGrid.getStore().getCount();
			if (rowCount > 0) {
				var rowData = DetailStore.data.items[rowCount - 1];
				var data = rowData.get("inci");	//initi --> inci
				if (data == null || data.length <= 0) {
					DetailGrid.startEditing(DetailStore.getCount() - 1, col);
					return;
				}
			}
			var NewRecord = CreateRecordInstance(DetailStore.fields);
			DetailStore.add(NewRecord);
			DetailGrid.startEditing(DetailStore.getCount() - 1, col);
			SupplyPhaLoc.setDisabled(true);
			RequestPhaLoc.setDisabled(true);
			if(!NewGridFlag){
				StkGrpType.setDisabled(true);
			}
		}

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
							changeButtonEnable("1^1^1^1^1^1^0^0^0");
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
				Msg.info("warning", "��ѡ��������!");
				return false;
			}
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc")
					.getValue();
			if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
				Msg.info("warning", "��ѡ��Ӧ����!");
				return false;
			}
			if (requestphaLoc == supplyphaLoc) {
				Msg.info("warning", "�����ź͹�Ӧ���Ų�����ͬ!");
				return false;
			}

			var operatetype = Ext.getCmp("OperateOutType")
					.getValue();
			if (InitParamObj.OutTypeNotNull == 'Y' && Ext.isEmpty(operatetype)) {
				Msg.info("warning", "��ѡ���������!");
				return false;
			}
			var reqid=Ext.getCmp("ReqNoID").getValue();
			var ifTrfbyReq=tkMakeServerCall("web.DHCSTM.DHCINIsTrf","GetReqStaus",reqid);
			var ReqNo=Ext.getCmp("ReqNo").getValue();
			if ((reqid!="")&&(ifTrfbyReq!="Y")) {
				Msg.info("warning", "����"+ReqNo+"״̬�ѷ����ı䣬������ѡȡ!");
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
							&& item_i == item_j && !(UseItmTrack && HVFlag=='Y')) {
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
				if ((item != undefined) && (qty == null || qty <= 0)) {
					Msg.info("warning", "ת����������С�ڻ����0!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
				}

				var avaQty = DetailStore.getAt(i).get("inclbAvaQty");
				var dirtyQty=DetailStore.getAt(i).get("dirtyQty");    //����ռ������
				if ((item != undefined) && ((qty - avaQty-dirtyQty) > 0)) {
					Msg.info("warning", "ת���������ܴ��ڿ��ÿ������!");
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					return false;
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
			var ReqLocUser = Ext.getCmp("ReqLocUser").getValue();
			var ExpressFlag=Ext.getCmp('ExpressFlag').getValue()?'Y':'N';//20180914
			var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^" + Complete
					+ "^" + Status + "^" + userId + "^"+StkGrpId+"^"+StkType+"^"+remark
					+ "^" + "" + "^" + ReqLocUser+"^"+ExpressFlag;
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
					var UomId = rowData.get("uom");
					var ReqItmId = rowData.get("inrqi");
					var Remark = rowData.get("remark");
					var BarCode = rowData.get("HVBarCode");
					var SpecDesc=rowData.get("SpecDesc");
					var str = Initi + "^" + Inclb + "^"	+ Qty + "^" + UomId + "^"
							+ ReqItmId + "^" + Remark + "^" + BarCode+"^^"+SpecDesc;	
					if(ListDetail==""){
						ListDetail=str;
					}
					else{
						ListDetail=ListDetail+xRowDelim()+str;
					}
				}
			}

			if(!IsFormChanged(HisListTab) && ListDetail==""){
				Msg.info("warning","û����Ҫ���������!");
				return false;
			}
			var ReqNo=Ext.getCmp("ReqNo").getValue();
			var initreqifallow=tkMakeServerCall("web.DHCSTM.DHCINIsTrfItm","IfAllowTrf",gInitId,ListDetail,MainInfo);
			if ((reqid!="")&&(initreqifallow!=0)){
				Msg.info("warning", "����"+ReqNo+"״̬�ѷ����ı䣬������ѡȡ!");
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
							loadMask.hide();
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
									PrintInIsTrf(InitRowid, 'Y');
								}
							} else {
								var ret=jsonData.info;								
								Msg.info("error", "���治�ɹ���"+ret);								
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
			var allowDelete = tkMakeServerCall('web.DHCSTM.DHCINIsTrf', 'AllowDel', gInitId);
			if(allowDelete < 0){
				Msg.info('error', '���������, ����ɾ��!');
			}
			var message = (allowDelete == 1)? '�����Ѵ�ӡ��������������Ϣ,���������ϴ���,�Ƿ����?' : '�Ƿ�ȷ��ɾ������ת�Ƶ�?'
			Ext.MessageBox.show({
						title : '��ʾ',
						msg : message,
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
									var TGridIndex = TGrid.getStore().findExact('init',gInitId);
									if(TGridIndex != -1){
										TGrid.getStore().removeAt(TGridIndex);
										TGrid.getView().refresh();
									}
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
									//��û��������ϸ��,���������쵥��,�ÿ�
									var inrqiIndex = DetailStore.find('inrqi', /^\d+\|\|\d+$/, 0);
									if(inrqiIndex == -1 && !Ext.isEmpty(Ext.getCmp('ReqNoID').getValue())){
										Ext.getCmp('ReqNoID').setValue('');
										Ext.getCmp('ReqNo').setValue('');
										Ext.getCmp('ReqRemark').setValue('');
									}
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
						if((InitParamObj.UseLocLimitAmt=="Y")||(GetAppPropValue('DHCSTINREQM').UseLocLimitQty=="Y")){
							if (CheckDataBeforeComplete()){Complete();}
						}else{Complete();}
					}
				});
		// ���ǰ�ض��ж���ʾ
		function CheckDataBeforeComplete() {
			var checkret=tkMakeServerCall("web.DHCSTM.LocLimitAmt","CheckIfExcess",gInitId); //������������
			var checqtykret=tkMakeServerCall("web.DHCSTM.LocLimitAmt","CheckIfExcessQty",gInitId);  ///��������������
			if ((checkret=="")&&(checqtykret=="")){return true;}
			var checkret="^"+checkret+"^";
			var rowCount = DetailGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				changeBgColor(i, "white");
			}
			var count=0;
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);
				var initi = rowData.get("initi");
				var chl=initi.split("||")[1];
				var tmpchl="^"+chl+"^";
				if (checkret.indexOf(tmpchl)>=0) {
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					count=count+1;
					continue;
				}
			}
			if (count>0){
				Msg.info("warning", "���»�����ϸ����ѳ��������޶����!");
				return false;
			}
			var checqtykret=","+checqtykret+",";
			for (var i = 0; i < rowCount; i++) {
				changeBgColor(i, "white");
			}
			var countqty=0;
			for (var i = 0; i < rowCount; i++) {
				var rowData = DetailStore.getAt(i);
				var initi = rowData.get("initi");
				var chl=initi.split("||")[1];
				var tmpchl=","+chl+",";
				if (checqtykret.indexOf(tmpchl)>=0) {
					DetailGrid.getSelectionModel().select(i, 1);
					changeBgColor(i, "yellow");
					countqty=countqty+1;
					continue;
				}
			}
			if (countqty>0){
				Msg.info("warning", "���»���ɫ�����ļ�¼�������������޶���������!");
				return false;
			}
			return true;
		}

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
			
			//Ԥ������ж�
			var HRPBudgResult = HRPBudg();
			if(HRPBudgResult === false){
				return;
			}
			
			var BCFlag = gHVSignFlag == 'Y'? 'N' : '';		//ǩ��ʱ,BCFlag��N
			var url = DictUrl
					+ 'dhcinistrfaction.csp?actiontype=MakeComplete&Rowid='
					+ gInitId+'&Status=11&Complete=Y&GroupId='+gGroupId+'&BCFlag='+BCFlag;

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
								Ext.getCmp("InitStatus").setValue('11');
								var TGridIndex = TGrid.getStore().findExact('init',gInitId);
								if(TGridIndex!=-1){
									TGrid.getStore().getAt(TGridIndex).set('comp', 'Y');
								}
								//��ɺ��Զ���ӡ �� ��ɺ��Զ�������ˣ�������˺��Զ���ӡ
								if((InitParamObj.AutoPrintAfterComp=='Y') || (InitParamObj.AutoAckOutAfterCompleted=='Y' && InitParamObj.AutoPrintAfterAckOut=='Y')){
									PrintInIsTrf(gInitId, 'Y');
								}
								
								//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
								changeButtonEnable("1^1^0^0^0^0^1^1^0");
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
								Ext.getCmp("InitStatus").setValue('10');
								var TGridIndex = TGrid.getStore().findExact('init',gInitId);
								if(TGridIndex!=-1){
									TGrid.getStore().getAt(TGridIndex).set('comp', 'N');
								}
								//��ѯ^���^�½�^����^ɾ��^���^ȡ�����
								changeButtonEnable("1^1^1^1^1^1^0^0^0");
								
							} else {
								Msg.info("error", "����ʧ��,���鵥��״̬��"+jsonData.info);
							}
						},
						scope : this
					});
		}

		// ������ť
		var AuditYesBT = new Ext.Toolbar.Button({
					id : "AuditYesBT",
					text : '���ͨ��',
					tooltip : '������ͨ��',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					disabled : true,
					handler : function() {
						var LocId = Ext.getCmp('SupplyPhaLoc').getValue();
						var UserCode = session['LOGON.USERCODE'];
						var StrParam = LocId + '^' + userId + '^' + UserCode;
						VerifyPassWord(StrParam, AuditOutYes);
					}
				});

		/**
		 * ����ת�Ƶ�����
		 */
		function AuditOutYes(OperUserId) {
			if (Ext.isEmpty(gInitId)) {
				Msg.info("warning", "��ѡ����˵�ת�Ƶ�!");
				return;
			}
			var inItFlag = Ext.getCmp("InItFlag").getValue();
			if (inItFlag == false) {
				Msg.info("warning", "ת�Ƶ���δ���!");
				return;
			}

			///����ֵ���ϱ�ǩ¼�����
			if(UseItmTrack && CheckHighValueLabels("T",gInitId)==false){
				return;
			}
			var BCFlag = gHVSignFlag == 'Y'? 'N' : '';		//ǩ��ʱ,BCFlag��N
			var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=Audit&Rowid="
					+ gInitId + "&User=" + OperUserId + "&BCFlag=" + BCFlag;		//2015-06-09 ����BCFlagΪN
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '��ѯ��...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								// ��˵���
								Msg.info("success", "������˳ɹ�!");
								Query(gInitId);
								//���ݲ�������, ��ӡ����
								if(gParam[4]=='Y'){
									PrintInIsTrf(Init, gHVSignFlag);
								}
							} else {
								var Ret=jsonData.info;
								if(Ret==-100){
									Msg.info("error", "���ⵥ���Ǵ����״̬!");
								}else if(Ret==-99){
									Msg.info("error", "����ʧ��!");
								}else if(Ret==-1){
									Msg.info("error", "���³��ⵥ״̬ʧ��!");
								}else if(Ret==-3){
									Msg.info("error", "������ʧ��!");
								}else if(Ret==-4){
									Msg.info("error", "����̨��ʧ��!");
								}else if(Ret==-5){
									Msg.info("error", "�����ӱ�״̬ʧ��!");
								}else if(Ret==-6){
									Msg.info("error", "����ռ������ʧ��!");
								}else if(Ret==-7){
									Msg.info("error", "�Զ����ճ��ⵥʧ�ܣ����ֶ�����!");
								}else{
									Msg.info("error", "���ʧ��:"+Ret);
								}
							}
						},
						scope : this
					});
		}
	
		var AuditInYesBT = new Ext.Toolbar.Button({
				id : "AuditInYesBT",
				text : '������',
				tooltip : '�������',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				disabled : true,
				handler : function() {
					var LocId = Ext.getCmp('RequestPhaLoc').getValue();
					var StrParam = LocId + '^^';
					VerifyPassWord(StrParam, AuditInYes);
				}
			});

		/**
		 * ����ת�Ƶ����
		 */
		function AuditInYes(OperUserId) {
			if (Ext.isEmpty(gInitId)) {
				Msg.info("warning", "��ѡ��Ҫ���յ�ת�Ƶ�!");
				return;
			}
			var InitStatus = Ext.getCmp('InitStatus').getValue();
			if (InitStatus != "21") {
				Msg.info("warning", "ת�Ƶ����Ǵ�����״̬�����ʵ!");
				return;
			}
		
			var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=AuditIn&Rowid="
				+ gInitId + "&User=" + OperUserId;
			Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '��ѯ��...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// ��˵���
							Msg.info("success", "���ճɹ�!");
							Query(gInitId);
							//���ݲ��������Զ���ӡ
							if(gParam[5]=='Y'){
								PrintInIsTrf(gInitId, 'Y');
							}
						} else {
							var Ret=jsonData.info;
							if(Ret==-100){
								Msg.info("error", "���ⵥ���Ǵ�����״̬!");
							}else if(Ret==-99){
								Msg.info("error", "����ʧ��!");
							}else if(Ret==-1 || Ret==-2){
								Msg.info("error", "���³��ⵥ״̬ʧ��!");
							}else if(Ret==-3){
								Msg.info("error", "������ʧ��!");
							}else if(Ret==-4){
								Msg.info("error", "����̨��ʧ��!");
							}else{
								Msg.info("error", "����ʧ��:"+Ret);
							}
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
	
		// ���󵥰�ť
		var SelReqBT = new Ext.Toolbar.Button({
				id : "SelReqBT",
				text : 'ѡȡ����',
				tooltip : '�����ѯ����',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					var FrLoc=Ext.getCmp("SupplyPhaLoc").getValue();
					if(FrLoc==null){
						Msg.info("warning","��ѡ��Ӧ����!")
						return;
					}
					SelReq(FrLoc,getlistReq,queryTrans);
				}
		});
		
		function getlistReq(datastr,strinfo){
			var list = datastr.split("^");
			var ReqNoID=Ext.getCmp("ReqNoID").getValue();
			if (ReqNoID==list[0]){
				Msg.info("warning","�����쵥�Ѵ���!")
				return;
			}
			if(ReqNoID!="" && ReqNoID!=list[0]){   //�µ����쵥�������
				clearData(); 
			}
			if (list.length > 0) {
				addComboData(Ext.getCmp('SupplyPhaLoc').getStore(),list[4],list[5])
				Ext.getCmp("SupplyPhaLoc").setValue(list[4]);
				addComboData(RequestPhaLoc.getStore(),list[2],list[3]);
				Ext.getCmp("RequestPhaLoc").setValue(list[2]);
				addComboData(null,list[12],list[13],StkGrpType);
				Ext.getCmp("StkGrpType").setValue(list[12]);
				Ext.getCmp("ReqRemark").setValue(handleMemo(list[10],xMemoDelim()));
				Ext.getCmp("ReqNo").setValue(list[1]);		
				Ext.getCmp("ReqNoID").setValue(list[0]);	
				Ext.getCmp("ExpressFlag").setValue(list[14]=='Y'?true:false)
				//��ѯ^���^����^����^ɾ��^���^ȡ�����
				changeButtonEnable("1^1^1^1^1^1^0");
				SupplyPhaLoc.setDisabled(true);
				RequestPhaLoc.setDisabled(true);
				StkGrpType.setDisabled(true);
				// ��ʾ������ϸ����
				getReqDetaill(strinfo)
			}		
		};
		//������ϸ����
		function getReqDetaill(strinfo){
			var url='dhcstm.dhcinistrfaction.csp?actiontype=GetInclbByReq&strinfo='+strinfo
			var responsetext=ExecuteDBSynAccess(url);
			var jsonData = Ext.util.JSON.decode(responsetext);
			if(jsonData.success=="true"){
				var info=jsonData.info;
				var infoArr=info.split(xRowDelim());   //��info�ָ�
				if(infoArr.length>0){
					for(i=0;i<infoArr.length;i++){
						var dataArr=infoArr[i]  
						var datainfo=dataArr.split("^");
						var InciDr = datainfo[0];  //inci
			            var Incicode = datainfo[1];   //��������
			            var Incidesc = datainfo[2]; //���������
			            var HVFlag = datainfo[3];     //ת������
			            var Inclb =datainfo[4];
			   
			            var batexp = datainfo[5];
			            var manf = datainfo[6];
			            var ProLocAllAvaQty = datainfo[7];
			            var Qty = datainfo[8];  
			            var UomDr = datainfo[9];   
			   
			            var Rp = datainfo[10]; 
			            var Sp = datainfo[11]; 
			            var RpAmt = datainfo[12]; 
			            var SpAmt = datainfo[13];
			            var ReqQty = datainfo[14]; 
			   
			            var stkbin = datainfo[16];
			            var reqPuomQty = datainfo[17];
						var stkQty= datainfo[18];
						var NewSp= datainfo[19];
						var spec= datainfo[20];
						
						var Fac= datainfo[21];
						var uom= datainfo[22];
						var Inrqi= datainfo[23];
						var BarCode= datainfo[24];
						var remark= datainfo[26];
						
						var SpecDesc= datainfo[27];
						var VendorName= datainfo[28];
				        var uomDesc=datainfo[29];
				        var defaData = {
					        inci:InciDr,
					        inciCode:Incicode,
					        inciDesc:Incidesc,
					        HVFlag:HVFlag,
					        inclb:Inclb,
					        batexp:batexp,   
					        manfName:manf,
					        inclbAvaQty:ProLocAllAvaQty,
					        qty:Qty,
					        rp:Rp,  
					        remark:remark,
					        reqLocStkQty:reqPuomQty,
					        sp:Sp,
					        rpAmt:RpAmt,
					        spAmt:SpAmt,
					        reqQty:ReqQty,
					        qtyApproved:Qty,
					        reqLocStkQty:reqPuomQty,
					        inclbQty:stkQty,
					        newSp:NewSp,
					        spec:spec,
					        ConFac:Fac,
					        inrqi:Inrqi,
					        BarCode:BarCode,
					        AllAvaQty:stkQty,
					        reqremark:remark,
					        SpecDesc:SpecDesc,
					        VendorName:VendorName
					     };
					     var DataRecord = CreateRecordInstance(DetailGrid.getStore().fields,defaData);
					     if(Qty>0){
						     DetailGrid.getStore().add(DataRecord)
						     var Rowcount=DetailGrid.getStore().getCount()
						     var rowData = DetailGrid.getStore().getAt(Rowcount-1);
						     addComboData(CTUomStore,uom,uomDesc);
						     rowData.set("uom",uom);
						     }
						}
					}
				}        	
		};
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
						if((gParam[13]=="N")&&(Ext.getCmp('InItFlag').getValue()==false)){
							Msg.info('warning','�������ӡδ��ɵ�ת�Ƶ�!');
							return;
						}
						PrintInIsTrf(gInitId);
					}
				});
		var CreateBarCode = new Ext.Toolbar.Button({
			text: '��������',
			iconCls: 'page_print',
			width: 70,
			height: 30,
			handler: function (button, e) {
				if (gInitId==""){Msg.info("warning","����δ���棬��������������");return false;}
				var count = DetailGrid.getStore().getCount();
				var initidstr="";
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var RowData = DetailGrid.getStore().getAt(rowIndex);
					var print = RowData.get('print');
					if (print != "Y") {
						continue;
					}
					var initmid=RowData.get('initi');
					if (initidstr==""){
						initidstr=initmid;
					}else{
						initidstr=initidstr+"^"+initmid;
					}
				}
				if (initidstr==""){Msg.info("warning","��ѡ����Ҫ�����������ϸ");return false;}
				var url = DictUrl
					+ "dhcinistrfaction.csp?actiontype=CreateBarCode";
				var loadMask=ShowLoadMask(Ext.getBody(),"������...");
				Ext.Ajax.request({
							url : url,
							params:{initidstr:initidstr},
							method : 'POST',
							waitMsg : '������...',
							success : function(result, request) {
								loadMask.hide();
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									var retinfo = jsonData.info;
									var infoArr=retinfo.split(",");
									var InitRowid=infoArr[0];
									var total=infoArr[1];
									var succount=infoArr[2];
									Msg.info("success", "��"+total+"����"+"����ɹ�"+succount+"��");
									Query(InitRowid);
								}
							},
							scope : this
						});
			}
		});
		var printBarCode = new Ext.Toolbar.Button({
			text: '��ӡ����',
			iconCls: 'page_print',
			width: 70,
			height: 30,
			handler: function (button, e) {
				DHCP_GetXMLConfig("DHCSTM_ILBBarcode");
				var count = DetailGrid.getStore().getCount();
				for (var rowIndex = 0; rowIndex < count; rowIndex++) {
					var RowData = DetailGrid.getStore().getAt(rowIndex);
					var print = RowData.get('print');
					if (print != "Y") {
						continue;
					}
					var inititmid=RowData.get('initi');
					var qty=RowData.get('qty');
					var BarCode = tkMakeServerCall("web.DHCSTM.DHCINIsTrf","GetBarCodeByInititmid",inititmid);
					if (Ext.isEmpty(BarCode)) {
						continue;
					}
					var inciDesc=RowData.get('inciDesc');
					var spec=RowData.get('spec');
					var MyPara = 'BarCode' + String.fromCharCode(2) + "*" + BarCode + "*"
					+ '^IncDesc' + String.fromCharCode(2) + inciDesc
					+ '^Spec' + String.fromCharCode(2) + spec;
					for (var i=0;i<qty;i++){
						DHCP_PrintFun(MyPara, "");
					}
				}
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
					var AllAvaQty=record.get("AllAvaQty");
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
						record.set("AllAvaQty",accMul(AllAvaQty,ConFac));
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
						record.set("AllAvaQty",accDiv(AllAvaQty,ConFac));
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
									//addComboData(PhaDeptStore,list[6],list[26]);
									addComboData(Ext.getCmp('SupplyPhaLoc').getStore(),list[6],list[26])
									Ext.getCmp("SupplyPhaLoc").setValue(list[6]);
									addComboData(RequestPhaLoc.getStore(),list[12],list[27]);
									Ext.getCmp("RequestPhaLoc").setValue(list[12]);
									Ext.getCmp("InitStatus").setValue(list[15]);
									addComboData(OperateOutType.getStore(),list[21],list[32]);
									Ext.getCmp("OperateOutType").setValue(list[21]);
									addComboData(null,list[24],list[36],StkGrpType);
									Ext.getCmp("StkGrpType").setValue(list[24]);
									Ext.getCmp("InItDate").setValue(list[29]);	
									Ext.getCmp("InItFlag").setValue(list[14]=='Y'?true:false);
									Ext.getCmp("Remark").setValue(list[9]);
									Ext.getCmp("ReqNo").setValue(list[28]);		
									Ext.getCmp("ReqNoID").setValue(list[30]);	
									Ext.getCmp("ReqRemark").setValue(handleMemo(list[35],xMemoDelim()));  //���󵥱�ע
									addComboData(ReqLocUser.getStore(), list[38], list[39]);
									Ext.getCmp("ReqLocUser").setValue(list[38]);
									Ext.getCmp("ExpressFlag").setValue(list[40]=='Y'?true:false)
									// �����ť�Ƿ����
									//��ѯ^���^����^����^ɾ��^���^ȡ�����
									var CompFlag =list[14];
									if(CompFlag=="Y"){
										var InitStatus = list[15];
										if(InitStatus == '21'){
											changeButtonEnable("1^1^0^0^0^0^0^0^1");
										}else if(InitStatus == '31'){
											changeButtonEnable("1^1^0^0^0^0^0^0^0");
										}else{
											changeButtonEnable("1^1^0^0^0^0^1^1^0");
										}
									}else{
										changeButtonEnable("1^1^1^1^1^1^0^0^0");
									}
									SupplyPhaLoc.setDisabled(true);
									RequestPhaLoc.setDisabled(true);
									StkGrpType.setDisabled(true);
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
			DetailStore.removeAll();
			DetailStore.load({params:{start:0,limit:999,Parref:InitRowid}});
			
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
				 "qty", "uom", "sp","status","remark","AllAvaQty",
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin", "pp", "spec","newSp",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty",
				"TrUomDesc","dirtyQty","HVFlag","HVBarCode","BarCode","reqremark","SpecDesc",
				"Vendor","VendorName","AllDirtyQty","qtyApproved","SterilizedBat",
				{name:"BatchNo",convert:function(v,rec){return rec.batexp.split('~')[0];}},
				{name:"ExpDate",convert:function(v,rec){return rec.batexp.split('~')[1];}},"inclbbarcode"
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
		var print = new Ext.grid.CheckColumn({
			header:'��ӡ/����',
			dataIndex:'print',
			width : 70,
			sortable:true
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
					renderer :Ext.util.Format.InciPicRenderer('inci'),
					sortable : true
				}, {
					header : '��������',
					dataIndex : 'inciDesc',
					width : 230,
					align : 'left',
					sortable : true,
					editable : !UseItmTrack,
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
					header : "��ֵ����",
					dataIndex : 'HVBarCode',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : !UseItmTrack,
					editable : UseItmTrack,
					editor : new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								var Barcode=field.getValue();
								if (Barcode!="" && e.getKey() == Ext.EventObject.ENTER){
									var row=DetailGrid.getSelectionModel().getSelectedCell()[0];
									var findHVIndex=DetailStore.findExact('HVBarCode',Barcode,0);
									if(findHVIndex>=0 && findHVIndex!=row){
										Msg.info("warning","�����ظ�¼��!");
										field.setValue("");
										return;
									}
									Ext.Ajax.request({
											url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode&Barcode='+Barcode,
											method : 'POST',
											waitMsg : '��ѯ��...',
											success : function(result, request){
												var jsonData = Ext.util.JSON
														.decode(result.responseText);
												if(jsonData.success == 'true'){
													var itmArr=jsonData.info.split("^");
													var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
													var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
													if(Ext.getCmp("StkGrpType").getValue()!=scgID){
														Msg.info("warning","����"+Barcode+"����"+scgDesc+"����,�뵱ǰ����!");
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}else if(inclb==""){
														Msg.info("warning","�ø�ֵ����û����Ӧ����¼,�����Ƶ�!");
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}else if(lastDetailAudit!="Y"){
														Msg.info("warning","�ø�ֵ������δ��˵�"+lastDetailOperNo+",���ʵ!");
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}else if(type=="T"){
														Msg.info("warning","�ø�ֵ�����Ѿ�����,�����Ƶ�!");
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}else if(status!="Enable"){
														Msg.info("warning","�ø�ֵ���봦�ڲ�����״̬,�����Ƶ�!");
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}
													var record = Ext.data.Record.create([{
																name : 'InciDr',
																type : 'string'
															}, {
																name : 'InciCode',
																type : 'string'
															}, {
																name : 'InciDesc',
																type : 'string'
															}]);
													var InciRecord = new record({
																InciDr : inciDr,
																InciCode : inciCode,
																InciDesc : inciDesc
															});
													var phaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
													var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
													var url = "dhcstm.drugutil.csp?actiontype=GetDrugBatInfo&IncId="+inciDr
														+"&ProLocId="+phaLoc+"&ReqLocId="+phaLocRQ+"&QtyFlag=1"+"&StkType="+App_StkTypeCode+"&Inclb="+inclb+"&start=0&limit=1";
													var LBResult=ExecuteDBSynAccess(url);
													var info=Ext.util.JSON.decode(LBResult);
													if(info.results=='0'){
														Msg.info("warning","�ø�ֵ����û����Ӧ����¼,�����Ƶ�!");
														DetailGrid.store.getAt(row).set("HVBarCode","");
														return;
													}
													var inforows=info.rows[0];
													
													Ext.applyIf(InciRecord.data,inforows);
													returnInfo(InciRecord);
												}else{
													Msg.info("warning","��������δע��!");
													DetailGrid.store.getAt(row).set("HVBarCode","");
													return;
												}
											}
									});
								}
							}
						}
					}))
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
					editor : new Ext.ux.NumberField({
						formatType : 'FmtQTY',
						selectOnFocus : true,
						allowBlank : false,
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
									var AvaQty = record.get("inclbAvaQty");
									var dirtyQty=record.get("dirtyQty");
									if (qty - AvaQty-dirtyQty > 0) {
										//Msg.info("warning", "ת���������ܴ��ڿ��ÿ������!");
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
					header : "���۽��",
					dataIndex : 'rpAmt',
					width : 100,
					align : 'right',
					sortable : true,
					summaryType : 'sum'
				}, {
					header : "�ۼ۽��",
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',
					sortable : true,
					summaryType : 'sum'
				}, {
					header : "��������",
					dataIndex : 'reqQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "��Ӧ����׼����",
					dataIndex : 'qtyApproved',
					width : 80,
					align : 'right',
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
					header : "������ռ������",
					dataIndex : 'inclbDirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "�����ۼ�",
					dataIndex : 'newSp',
					width : 100,
					align : 'right',
					hidden : true,
					sortable : true
				}, {
					header : "���",
					dataIndex : 'spec',
					width : 100,
					align : 'left',
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
				},{
					header : "����",
					dataIndex : 'BarCode',
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
									var Barcode=field.getValue();
									GetPhaOrderInfo2(Barcode, stkgrp);
								}
							}
						}
					})
				}, {
					header : "�������",
					dataIndex : 'AllAvaQty',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "���ռ������",
					dataIndex : 'AllDirtyQty',
					width : 90,
					align : 'right',
					sortable : true
				}, {
					header : "���ⱸע",
					dataIndex : 'remark',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : false,
					editor:new Ext.form.TextField({
									id:'remarkField',
									listeners:{
										specialKey:function(field, e) {
											if (e.getKey() == Ext.EventObject.ENTER) {
												var cell = DetailGrid.getSelectionModel().getSelectedCell();
												if(DetailStore.getAt(cell[0]).get('qty')==0){
													Msg.info("error","ת����������Ϊ0!");
													
													var colIndex=GetColIndex(DetailGrid,"qty");
													if (!DetailGrid.getColumnModel().isHidden(colIndex))
													{
														DetailGrid.startEditing(DetailStore.getCount() - 1, colIndex);
													}
													return false;
												}else{
													//����һ��
													addNewRow();
												}
											}
										}
									}
						  })
				}, {
					header : "����ע",
					dataIndex : 'reqremark',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : false
				},{
					header:"������",
					dataIndex:'SpecDesc',
					width:100,
					align:'left',
					sortable:true
				}, {
					header : "��Ӧ��",
					dataIndex : 'VendorName',
					width : 180,
					align : 'left',
					sortable : true
				},{
					  header:"�������",
					  dataIndex:'SterilizedBat',
					  width:100,
					  align:'left',
					  sortable:true
			    }, {
					header : "����",
					dataIndex : 'BatchNo',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "Ч��",
					dataIndex : 'ExpDate',
					width : 80,
					align : 'left',
					sortable : true
				}, print,{
					header : "��������",
					dataIndex : 'inclbbarcode',
					width : 100,
					align : 'left',
					sortable : true
				}
				]);
		var gridsumm=new Ext.grid.GridSummary();
		var DetailGrid = new Ext.grid.EditorGridPanel({
					id : 'DetailGrid',
					title:'���ת�Ƶ�',
					tbar:{items:[AddBT,'-',DeleteDetailBT,'-',{height:30,width:70,text:'������',iconCls:'page_gear',handler:function(){	GridColSet(DetailGrid,"DHCSTTRANSFERM");}}]},
					region : 'center',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					sm : new Ext.grid.CellSelectionModel({}),
					clicksToEdit : 1,
					plugins : [print,gridsumm],
					listeners:{
						'beforeedit' : function(e){
							if(Ext.getCmp("InItFlag").checked==true){
								return false;
							}
							if(e.field=="inciDesc" || e.field=="qty" || e.field=="uom"){
								if(e.record.get("HVBarCode")!=""){
									e.cancel=true;
								}
							}
							if(e.field=="HVBarCode" && e.record.get("inclb")!=""){
								e.cancel=true;
							}
						},
						'afteredit' : function(e){
							if(e.field == 'qty'){
								var qty = e.value;
								var AvaQty = e.record.get("inclbAvaQty");
								var dirtyQty = e.record.get("dirtyQty");
								if (qty - AvaQty - dirtyQty > 0) {
									Msg.info("warning", "ת���������ܴ��ڿ��ÿ������!");
									e.record.set('qty', e.originalValue);
									return false;
								}
								var spAmt = accMul(e.record.get("sp"),qty);
								e.record.set("spAmt", spAmt);
								var rpAmt = accMul(e.record.get("rp"),qty);
								e.record.set("rpAmt", rpAmt);
								
								// ����Ԥ�����
								var InciId = e.record.get('inci');
								HRPBudg(InciId);
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
			e.preventDefault();
			grid.getSelectionModel().select(rowindex,0);
			rightClick.showAt(e.getXY()); 
		}

		/*
		 * Ԥ�����,����HRPԤ��ӿ�
		 */
		function HRPBudg(CurrInciId){
			CurrInciId = typeof(CurrInciId) == 'undefined'? '' : CurrInciId;
			var LocId = Ext.getCmp('SupplyPhaLoc').getValue();
			if(Ext.isEmpty(LocId)){
				return;
			}
			var DataStr = '';
			var Count = DetailGrid.getStore().getCount();
			for(i = 0; i < Count; i++){
				var RowData = DetailGrid.getStore().getAt(i);
				var Initi = RowData.get('initi');
				var InciId = RowData.get('inci');
				var RpAmt = RowData.get('rpAmt');
				if ((InciId == '') || !(RpAmt > 0)){
					continue;
				}
				var Data = Initi + '^' + InciId + '^' + RpAmt;
				if(DataStr == ''){
					DataStr = Data;
				}else{
					DataStr = DataStr + RowDelim + Data;
				}
			}
			if(DataStr != ''){
				var Result = tkMakeServerCall('web.DHCSTM.ServiceForHerpBudg', 'InitBalance', CurrInciId, LocId, DataStr);
				if(!Ext.isEmpty(Result)){
					Msg.info('error', '��ǰ�ɹ�����Ԥ��,���ʵ�޸�:' + Result);
					return false;
				}
			}
			return true;
		}
		
		/**
		 * �������ʴ��岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			var phaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
			if (item != null && item.length > 0) {
				IncItmBatWindow(item, stkgrp, App_StkTypeCode, phaLoc, "N", "1", gHospId,phaLocRQ,
						returnInfo,"","","1","N");
			}
		}
		
		//���ݿ���������ȡ������Ϣ
		function GetPhaOrderInfo2(item, stkgrp) {
			var phaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var phaLocRQ = Ext.getCmp("RequestPhaLoc").getValue();
			if (item != null && item.length > 0) {
				IncItmBatByBarcodeWindow(item, stkgrp, App_StkTypeCode, phaLoc, "N", "1", gHospId,phaLocRQ,
						returnInfo);
			}
		}
		/**
		 * ����������Ϣ
		 */
		function returnInfo(records) {
			records = [].concat(records);
			if (records == null || records == "") {
				return;
			}
			Ext.each(records,function(record,index,allItems){
				var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var selectRow = cell[0];
				var rowData = DetailStore.getAt(selectRow);
				// ����ظ�����
				var INITIINCLBDR = record.get("Inclb");
				var HVFlag=record.get("HVFlag");
				if(!UseItmTrack || HVFlag!='Y'){
					var findIndex=DetailStore.findExact('inclb',INITIINCLBDR,0);
					if(findIndex>=0 && findIndex!=selectRow){
						Msg.info("warning", "���������ظ�������������!");
						return;
					}
				}
				
				var ItmTrack=gItmTrackParam[0]=='Y'?true:false;
				if(!(ItmTrack==gHVInIsTrf) && HVFlag=='Y'){
					Msg.info("warning","��ֵ����,���������¼��!");
					var index=GetColIndex(DetailGrid,"HVBarCode");
					rowData.set("InciDesc","");
					DetailGrid.startEditing(cell[0], index);
					return;
				}
				rowData.set("inci", record.get("InciDr"));
				rowData.set("inciCode", record.get("InciCode"));
				rowData.set("inciDesc", record.get("InciDesc"));
				rowData.set("inclb",record.get("Inclb"));
				rowData.set("batexp",record.get("BatExp"));
				var BatExp = record.get("BatExp");
				var BatchNo = BatExp.split('~')[0];
				var ExpDate = BatExp.split('~')[1];
				rowData.set("BatchNo", BatchNo);
				rowData.set("ExpDate", ExpDate);
				rowData.set("manfName",record.get("Manf"));
				rowData.set("VendorName",record.get("VendorName"));
				rowData.set("inclbQty",record.get("InclbQty"));
				rowData.set("AllAvaQty",record.get("SupplyAvaStockQty"));
				addComboData(CTUomStore,record.get("PurUomId"),record.get("PurUomDesc"));
				rowData.set("uom",record.get("PurUomId"));
				rowData.set("rp",record.get("Rp"));
				rowData.set("sp",record.get("Sp"));
				rowData.set("stkbin", record.get("StkBin"));
				rowData.set("reqLocStkQty",record.get("RequrstStockQty"));
				rowData.set("newSp",record.get("BatSp"));
				rowData.set("spec", record.get("Spec"));
				rowData.set("ConFac", record.get("ConFac"));
				rowData.set("BUomId",record.get("BUomId"));
				rowData.set("inclbDirtyQty", record.get("DirtyQty"));
				rowData.set("inclbAvaQty", record.get("AvaQty"));
				rowData.set("HVFlag", record.get("HVFlag"));
				rowData.set("qty", record.get("OperQty"));
				rowData.set("spAmt", accMul(record.get("Sp"),record.get("OperQty"))); 
				rowData.set("rpAmt", accMul(record.get("Rp"),record.get("OperQty"))); 
				if (Ext.getCmp("StkGrpType").getValue()==""){
				addComboData(null,record.get("GrpId"),record.get("GrpDesc"),StkGrpType);
				Ext.getCmp("StkGrpType").setValue(record.get("GrpId"));
				}
				rowData.set("SterilizedBat", record.get("SterilizedBat"));
				rowData.set("SpecDesc", record.get("SpecDesc"));
				var lastIndex = DetailStore.getCount()-1;
				if(DetailStore.getAt(lastIndex).get('inclb')!=""){
					addNewRow();
				}else{
					var col=GetColIndex(DetailGrid,'inciDesc')
					DetailGrid.startEditing(lastIndex,col);
				}
				
				//Ԥ������ж�
				var InciId = rowData.get("inci");
				HRPBudg(InciId);
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
			AuditYesBT.setDisabled(list[7]);
			AuditInYesBT.setDisabled(list[8]);
		}
		// ת����ϸ
	
		// ָ���в���
		var Tfields = ["init", "frLocDesc", "toLocDesc","initNo","reqNo","comp"];

		// ���ݼ�
		var TStore = new Ext.data.JsonStore({
			storeId: 'TStore',
			url : 'dhcstm.dhcinistrfaction.csp?actiontype=QueryTrans',
			root : 'rows',
			fields:Tfields
		});
		
		var nm = new Ext.grid.RowNumberer();
		var TCm = new Ext.grid.ColumnModel([nm, {
					header : "",
					dataIndex : 'init',
					width : 100,
					align : 'left',
					sortable : true,
					hidden:true
				},{
					header : "���",
					dataIndex : 'comp',
					width : 30,
					align : 'center',
					xtype : 'checkcolumn'
				},{
					header : "���ⵥ��",
					dataIndex : 'initNo',
					width : 120,
					align : 'left',
					sortable : true	
				},{
					header : "���󵥺�",
					dataIndex : 'reqNo',
					width : 120,
					align : 'left',
					sortable : true
				},{
					header : "�������",
					dataIndex : 'toLocDesc',
					width : 80,
					align : 'left',
					sortable : true	
				},{
					header : "�������",
					dataIndex : 'frLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}
			]);
		
		function queryTrans(InitStr){
			TStore.removeAll();
			TStore.load({
				params:{InitStr:InitStr},
				callback : function(r,options, success){
					if(success==false){
						Msg.info("error", "��ѯ������鿴��־!");
					}else{
						if(r.length>0){
							TGrid.getSelectionModel().selectFirstRow();
						}
					}
				}
			})
		}
		
		var sm1=new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{
				'rowselect':function(sm,index,r){
					var init=r.get('init');
					Query(init);
				}
			}
		});
		
		//��ʾ�����ɵ�ת�Ƶ�
		var TGrid = new Ext.ux.GridPanel({
			id : 'TGrid',
			title:'�������ɵ�ת�Ƶ�',
			cm:TCm,
			region : 'center',
			store : TStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			sm : sm1
		});
	
		var HisListTab = new Ext.form.FormPanel({
			id:'HisListTab',
			labelAlign : 'right',
			frame : true,
			region : 'west',
			labelWidth : 60,
			width:900,
			title:gHVSignFlag=='Y'?'���ת���Ƶ�(˫ǩ��)':'���ת���Ƶ�',
			autoScroll : false,
			bodyStyle : 'padding:5px 0px 0px 5px;',
			tbar : [SearchInItBT, '-',  ClearBT, '-', SaveBT, '-', DeleteBT, '-', CheckBT, '-', CancelCmpBT,
				gHVSignFlag=='Y'?'-':'', gHVSignFlag=='Y'?AuditYesBT:'', gHVSignFlag=='Y'?'-':'', gHVSignFlag=='Y'?AuditInYesBT:'',
				'-',PrintBT,!gHVInIsTrf?'-':"",!gHVInIsTrf?SelReqBT:"",CreateBarCode,printBarCode],
			items:[{
				xtype:'fieldset',
				title:'ת�Ƶ���Ϣ',
				layout: 'column',    // Specifies that the items will now be arranged in columns
				style:'padding: 5px 0px 0px 0px',
				defaults: {xtype: 'fieldset', border:false},
				items : [{
						columnWidth: 0.3,
						items: [SupplyPhaLoc,RequestPhaLoc,ReqLocUser,StkGrpType]
					},{
						labelWidth : 40,
						columnWidth: 0.15,
						items:[gHVInIsTrf?[VirtualFlag,InItFlag]:[InItFlag],ExpressFlag]
					},{
						columnWidth: 0.3,
						items: [InItNo,InItDate,OperateOutType,InitStatus]
					},{
						columnWidth: 0.25,
						items: [Remark,ReqNo,ReqRemark,ReqNoID]
					}]
			}]
		});
		var panel=new Ext.Panel({
			height : 220,
			region : 'north',
			layout : 'border',
			items : [HisListTab, TGrid]
		})
		
		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [panel, DetailGrid],
					renderTo : 'mainPanel'
				});
		RefreshGridColSet(DetailGrid,"DHCSTTRANSFERM");
		// ��¼����Ĭ��ֵ
		SetLogInDept(PhaDeptStore, "SupplyPhaLoc");		
		if(gInitId!=undefined && gInitId!='' && gFlag==1){
			Query(gInitId);
		}
		//�򿪿��ת���Ƶ�����ʱ����������ȷ���Ƿ����Զ���ʾ�����������
		if(gFlag!=1 && gParam[6]=='Y'){
			var FrLoc=Ext.getCmp("SupplyPhaLoc").getValue();
			if(FrLoc!=null && FrLoc!=""){
				//SelReq(FrLoc,queryTrans);
                SelReq(FrLoc,getlistReq,Query);
			}			
		}		
	}
})

window.onbeforeunload = function(){
	var InitStatus = Ext.getCmp('InitStatus').getValue();
	if(gHVSignFlag && gInitId!='' && InitStatus!=31){
		return '��ǰ������δ��ȫ����, �Ƿ��뿪?';
	}
};