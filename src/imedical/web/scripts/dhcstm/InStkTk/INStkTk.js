// /����: ������
// /����: ������
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.24

//�������ֵ��object
var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM')

	Ext.onReady(function () {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

		var gRowid = '';
		var url = DictUrl + 'instktkaction.csp';
		var gGroupId = session["LOGON.GROUPID"];
		var gLocId = session["LOGON.CTLOCID"];
		var gUserId = session["LOGON.USERID"];

		//ȡ��ֵ�������
		var UseItmTrack = '';
		if (gItmTrackParam.length < 1) {
			GetItmTrackParam();
			UseItmTrack = gItmTrackParam[0] == 'Y' ? true : false;
		}

		var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel: '����',
				id: 'PhaLoc',
				name: 'PhaLoc',
				anchor: '85%',
				emptyText: '����...',
				groupId: gGroupId,
				stkGrpId: 'StkGrpType'
			});
		PhaLoc.addListener('change', function (field, newValue, oldValue) {
			LoadLocManGrp();
		});

		var TkDate = new Ext.ux.DateField({
				fieldLabel: '����',
				id: 'TkDate',
				name: 'TkDate',
				anchor: '85%',

				width: 140,
				disabled: true,
				value: new Date()
			});
		var TkTime = new Ext.form.TextField({
				fieldLabel: 'ʱ��',
				id: 'TkTime',
				name: 'TkTime',
				anchor: '85%',
				width: 140,
				disabled: true
			});
		// ��ӡ�̵㵥��ť
		var PrintBT1 = new Ext.Toolbar.Button({
				id: "PrintBT1",
				text: '�����δ�ӡ',
				tooltip: '�����ӡ�̵㵥',
				width: 70,
				height: 30,
				iconCls: 'page_print',
				handler: function () {
					var ret = tkMakeServerCall("web.DHCSTM.INStkTk", "UpPrintFlag", gRowid);
					var type = 1;
					PrintINStk(gRowid, type);
				}
			});
		// ��ӡ�̵㵥��ť
		var PrintBT2 = new Ext.Toolbar.Button({
				id: "PrintBT2",
				text: '��Ʒ�ִ�ӡ',
				tooltip: '�����ӡ�̵㵥',
				width: 70,
				height: 30,
				iconCls: 'page_print',
				handler: function () {
					var type = 2;
					PrintINStk(gRowid, type);
				}
			});

		var InstNo = new Ext.form.TextField({
				fieldLabel: '�̵㵥��',
				id: 'InstNo',
				name: 'InstNo',
				anchor: '85%',
				width: 140,
				disabled: true
			});

		// ��ע
		var TkRemarks = new Ext.form.TextField({
				fieldLabel: '��ע',
				id: 'TkRemarks',
				name: 'TkRemarks',
				anchor: '85%',
				width: 120,
				disabled: false
			});

		var Complete = new Ext.form.Checkbox({
				fieldLabel: '���',
				id: 'Complete',
				name: 'Complete',
				width: 80,
				disabled: true
			});

		var TkUomStore = new Ext.data.SimpleStore({
				fields: ['RowId', 'Description'],
				data: [[0, '������λ'], [1, '��ⵥλ']]
			});

		var TkUom = new Ext.form.ComboBox({
				fieldLabel: 'Ĭ��ʵ�̵�λ',
				id: 'TkUom',
				name: 'TkUom',
				anchor: '85%',
				width: 140,
				store: TkUomStore,
				valueField: 'RowId',
				displayField: 'Description',
				allowBlank: false,
				triggerAction: 'all',
				emptyText: 'Ĭ��ʵ�̵�λ...',
				selectOnFocus: true,
				forceSelection: true,
				minChars: 1,
				valueNotFoundText: '',
				mode: 'local'
			});
		Ext.getCmp("TkUom").setValue(0);

		var Vendor = new Ext.ux.VendorComboBox({
				id: 'Vendor',
				name: 'Vendor'
			});

		var StkGrpType = new Ext.ux.StkGrpComboBox({
				id: 'StkGrpType',
				name: 'StkGrpType',
				StkType: App_StkTypeCode, //��ʶ��������
				LocId: gLocId,
				UserId: gUserId,
				anchor: '90%',
				width: 140
			});
		StkGrpType.on('change', function () {
			Ext.getCmp("DHCStkCatGroup").setValue("");
		});
		var DHCStkCatGroup = new Ext.ux.ComboBox({
				fieldLabel: '������',
				id: 'DHCStkCatGroup',
				name: 'DHCStkCatGroup',
				store: StkCatStore,
				valueField: 'RowId',
				displayField: 'Description',
				params: {
					StkGrpId: 'StkGrpType'
				}
			});

		var StStkBin = new Ext.form.ComboBox({
				fieldLabel: '��ʼ��λ',
				id: 'StStkBin',
				name: 'StStkBin',
				anchor: '90%',
				width: 140,
				store: LocStkBinStore,
				valueField: 'RowId',
				displayField: 'Description',
				allowBlank: true,
				triggerAction: 'all',
				selectOnFocus: true,
				forceSelection: true,
				minChars: 1,
				pageSize: 20,
				listWidth: 250,
				valueNotFoundText: '',
				enableKeyEvents: true,
				listeners: {
					'beforequery': function (e) {
						this.store.removeAll();
						this.store.setBaseParam('LocId', Ext.getCmp("PhaLoc").getValue());
						this.store.setBaseParam('Desc', this.getRawValue());
						this.store.load({
							params: {
								start: 0,
								limit: 20
							}
						});
					}
				}
			});

		var EdStkBin = new Ext.form.ComboBox({
				fieldLabel: '��ֹ��λ',
				id: 'EdStkBin',
				name: 'EdStkBin',
				anchor: '90%',
				width: 140,
				store: LocStkBinStore,
				valueField: 'RowId',
				displayField: 'Description',
				allowBlank: true,
				triggerAction: 'all',
				selectOnFocus: true,
				forceSelection: true,
				minChars: 1,
				pageSize: 20,
				listWidth: 250,
				valueNotFoundText: '',
				enableKeyEvents: true,
				listeners: {
					'beforequery': function (e) {
						this.store.removeAll();
						this.store.setBaseParam('LocId', Ext.getCmp("PhaLoc").getValue());
						this.store.setBaseParam('Desc', this.getRawValue());
						this.store.load({
							params: {
								start: 0,
								limit: 20
							}
						});
					}
				}
			});

		//ͨ��UseItmTrack�������ƿ������,�ߵ�ֵ���������̵�
		var HVFlag = new Ext.form.RadioGroup({
				id: 'HVFlag',
				//fieldLabel : '��ֵ��־',
				columns: 3,
				itemCls: 'x-check-group-alt',
				hideLabel: false,
				items: [{
						boxLabel: '��ֵ',
						name: 'HVFlag',
						id: 'IsHVFlag',
						inputValue: 1,
						checked: UseItmTrack
					}, {
						boxLabel: '�Ǹ�ֵ',
						name: 'HVFlag',
						id: 'NotHVFlag',
						inputValue: 2
					}, {
						boxLabel: 'ȫ��',
						name: 'HVFlag',
						id: 'AllFlag',
						inputValue: 0,
						checked: !UseItmTrack,
						disabled: UseItmTrack,
						hidden: UseItmTrack
					}
				]
			});

		//��ͽ���
		var MinRp = new Ext.ux.NumberField({
				id: 'MinRp',
				width: 70,
				anchor: '90%',
				allowNegative: false
			});

		//��߽���
		var MaxRp = new Ext.ux.NumberField({
				id: 'MaxRp',
				width: 70,
				anchor: '90%',
				allowNegative: false
			});

		//�����(�����ο���)
		var RandomNum = new Ext.form.NumberField({
				id: 'RandomNum',
				fieldLabel: '�������',
				anchor: '90%',
				allowNegative: false,
				allowDecimals: false
			});

		var ManageDrug = new Ext.form.Checkbox({
				fieldLabel: '���ص��ע',
				id: 'ManageDrug',
				name: 'ManageDrug',
				anchor: '90%',
				width: 100,
				height: 10,
				checked: false
			});

		var IncludeNotUse = new Ext.form.Checkbox({
				fieldLabel: '����������Ʒ��',
				id: 'IncludeNotUse',
				name: 'IncludeNotUse',
				anchor: '90%',
				width: 100,
				height: 10,
				checked: false
			});

		var NotUseFlag = new Ext.form.Checkbox({
				fieldLabel: '��������Ʒ��',
				id: 'NotUseFlag',
				name: 'NotUseFlag',
				anchor: '90%',
				width: 100,
				height: 10,
				checked: false
			});
		var num = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var LocManGrpCm = new Ext.grid.ColumnModel([sm, num, {
						header: "Rowid",
						dataIndex: 'Rowid',
						width: 80,
						align: 'left',
						sortable: true,
						hidden: true
					}, {
						header: "����",
						dataIndex: 'Desc',
						width: 200,
						align: 'left',
						sortable: true
					}
				]);
		LocManGrpCm.defaultSortable = true;

		// ����·��
		var LocManGrpUrl = DictUrl
			 + 'locmangrpaction.csp?actiontype=Query&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
				url: LocManGrpUrl,
				method: "POST"
			});
		// ָ���в���
		// ���ݼ�
		var LocManGrpStore = new Ext.data.Store({
				proxy: proxy,
				reader: new Ext.data.JsonReader({
					root: 'rows',
					totalProperty: "results",
					id: "Rowid",
					fields: ["Rowid", "Desc"]
				})
			});
		var LocManGrpGrid = new Ext.grid.GridPanel({
				id: 'LocManGrpGrid',
				cm: LocManGrpCm,
				store: LocManGrpStore,
				trackMouseOver: true,
				stripeRows: true,
				title: '������',
				sm: sm,
				clicksToEdit: 1,
				loadMask: true,
				height: 150
			});

		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
				text: '��ѯ',
				tooltip: '�����ѯ',
				iconCls: 'page_find',
				width: 70,
				height: 30,
				handler: function () {
					InStkTkSearch(Query);
				}
			});

		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
				text: '���',
				tooltip: '������',
				iconCls: 'page_clearscreen',
				width: 70,
				height: 30,
				handler: function () {
					clearData();
				}
			});

		/**
		 * ��շ���
		 */
		function clearData() {
			gRowid = '';
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("StStkBin").setValue('');
			Ext.getCmp("EdStkBin").setValue('');
			Ext.getCmp("InstNo").setValue('');
			Ext.getCmp("TkDate").setValue(new Date());
			Ext.getCmp("TkTime").setValue('');
			Ext.getCmp("TkRemarks").setValue('');
			SetLogInDept(Ext.getCmp("PhaLoc").getStore(), 'PhaLoc');
			Ext.getCmp("Complete").setValue(false);
			Ext.getCmp("ManageDrug").setValue(false);
			Ext.getCmp("TkUom").setValue(1);
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("StkGrpType").getStore().load();
			Ext.getCmp("StStkBin").setValue('');
			Ext.getCmp("EdStkBin").setValue('');
			Ext.getCmp("IncludeNotUse").setValue(false);
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp('MinRp').setValue('');
			Ext.getCmp('MaxRp').setValue('');
			Ext.getCmp('RandomNum').setValue('');
			LoadLocManGrp();
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}

		var CreateBT = new Ext.Toolbar.Button({
				text: '�����̵㵥',
				tooltip: '��������̵㵥',
				iconCls: 'page_add',
				width: 70,
				height: 30,
				handler: function () {
					StockQtyGrid.store.removeAll();
					save();
				}
			});

		function save() {
			var PhaLocId = Ext.getCmp("PhaLoc").getValue();
			if (PhaLocId == "") {
				Msg.info("warning", "��ѡȡ����!");
				return;
			}
			var UserId = session['LOGON.USERID'];
			var UomType = Ext.getCmp("TkUom").getValue();
			var SelectRows = LocManGrpGrid.getSelectionModel().getSelections();
			var LocManGrp = '';
			if (SelectRows != null) {
				for (i = 0; i < SelectRows.length; i++) {
					if (LocManGrp == '') {
						LocManGrp = SelectRows[i].get("Rowid");
					} else {
						LocManGrp = LocManGrp + "," + SelectRows[i].get("Rowid");
					}
				}
			}
			var Vendor = Ext.getCmp('Vendor').getValue();
			var StkGrpId = Ext.getCmp('StkGrpType').getValue();
			var StkCatId = Ext.getCmp('DHCStkCatGroup').getValue();
			var ManageDrug = (Ext.getCmp('ManageDrug').getValue() == true ? 'Y' : 'N');
			var IncludeNotUseFlag = (Ext.getCmp('IncludeNotUse').getValue() == true ? 'Y' : 'N');
			var NotUseFlag = (Ext.getCmp('NotUseFlag').getValue() == true ? 'Y' : 'N');
			var StStkBin = Ext.getCmp('StStkBin').getValue();
			var EdStkBin = Ext.getCmp('EdStkBin').getValue();
			var TkRemarks = Ext.getCmp('TkRemarks').getValue();
			var HVFlag = Ext.getCmp('HVFlag').getValue().getGroupValue();
			if (UseItmTrack && (HVFlag == 0)) {
				Msg.info('warning', '�����ָ�ֵ,��ֵ��־!');
				return false;
			}
			var MinRp = Ext.getCmp('MinRp').getValue();
			var MaxRp = Ext.getCmp('MaxRp').getValue();
			var RandomNum = Ext.getCmp('RandomNum').getValue();
			
			var CheckParam = PhaLocId;
			var CheckRet = tkMakeServerCall('web.DHCSTM.INStkTk', 'CheckBeforeInstk', CheckParam);
			if(!Ext.isEmpty(CheckRet)){
				Msg.info('warning', CheckRet);
				return;
			}
			
			var params = PhaLocId + '^' + UserId + '^' + UomType + '^' + LocManGrp + '^' + StkGrpId
				 + '^' + StkCatId + '^' + ManageDrug + '^' + IncludeNotUseFlag + '^' + NotUseFlag + '^' + StStkBin
				 + '^' + EdStkBin + '^' + TkRemarks + '^' + gGroupId + '^' + HVFlag + '^' + MinRp
				 + '^' + MaxRp + '^' + RandomNum + '^' + Vendor;
			var mask = ShowLoadMask(Ext.getBody(), "������...");
			Ext.Ajax.request({
				url: url,
				params: {
					actiontype: 'Create',
					Params: params
				},
				success: function (response, opt) {
					var jsonData = Ext.util.JSON.decode(response.responseText);
					if (jsonData.success == 'true') {
						var InstId = jsonData.info;
						Msg.info("success", "�����̵㵥�ɹ�!");
						Query(InstId);
						// reLoadLocManGrp();
						//LoadLocManGrp()
					} else {
						var ret = jsonData.info;
						if (ret == -1) {
							Msg.info("error", "�̵���Ҳ���Ϊ��!");
						} else if (ret == -2) {
							Msg.info("error", "�̵��˲���Ϊ��!");
						} else if (ret == -3) {
							Msg.info("error", "�����̵���Ϣʧ��!");
						} else if (ret == -4) {
							Msg.info("error", "�����̵㵥��ʧ��!");
						} else if (ret == -5) {
							Msg.info("error", "�������¼����ʧ��!");
						} else if (ret == -6) {
							Msg.info("error", "�����̵���ϸʧ��!");
						} else if (ret == -7) {
							Msg.info("error", "û�з����������̵���ϸ!");
						} else {
							Msg.info("error", "�����̵㵥ʧ��");
						}
					}
					mask.hide();
				}

			});
		}

		//�����̵㵥����ϸ��Ϣ
		function Query(inst) {
			if (inst == null || inst.length < 1) {
				Msg.info("warning", "�̵�id����Ϊ��!");
			}

			var sucflag = 0
				gRowid = inst;
			//��ѯ�̵㵥����Ϣ
			Ext.Ajax.request({
				url: url,
				method: 'post',
				params: {
					actiontype: 'Select',
					Rowid: inst
				},
				success: function (reponse, opt) {
					var jsonData = Ext.util.JSON.decode(reponse.responseText);
					if (jsonData.success == 'true') {
						var data = jsonData.info;
						if (data != "") {
							var detail = data.split("^");

							var instNo = detail[0];
							var locId = detail[5];
							var locDesc = detail[6];
							var userId = detail[3];
							var userName = detail[4];
							var tkDate = detail[1];
							var tkTime = detail[2];
							var compFlag = (detail[9] == 'Y' ? true : false);
							var manaFlag = (detail[13] == 'Y' ? true : false);
							var tkUom = detail[14];
							var includeNotUse = (detail[15] == 'Y' ? true : false);
							var onlyNotUse = (detail[16] == 'Y' ? true : false);
							var stkgrpid = detail[17];
							var stkcatid = detail[18];
							var stkCatDesc = detail[19];
							var frStkBin = detail[20];
							var frStkBinDesc = detail[21];
							var toStkBin = detail[22];
							var toStkBinDesc = detail[23];
							var TkRemarks = detail[8];
							var HVFlag = detail[24];
							var MinRp = detail[25];
							var MaxRp = detail[26];
							var RandomNum = detail[27];
							var StkGrpDesc = detail[28];

							Ext.getCmp("TkRemarks").setValue(TkRemarks);
							Ext.getCmp("InstNo").setValue(instNo);
							Ext.getCmp("TkDate").setValue(tkDate);
							Ext.getCmp("TkTime").setValue(tkTime);
							//addComboData(PhaDeptStore,locId,locDesc);
							addComboData(Ext.getCmp("PhaLoc").getStore(), locId, locDesc);

							Ext.getCmp("PhaLoc").setValue(locId);
							Ext.getCmp("Complete").setValue(compFlag);
							Ext.getCmp("ManageDrug").setValue(manaFlag);
							Ext.getCmp("TkUom").setValue(tkUom);
							addComboData(StkCatStore, stkcatid, stkCatDesc);
							Ext.getCmp("DHCStkCatGroup").setValue(stkcatid);
							addComboData(null, stkgrpid, StkGrpDesc, StkGrpType);
							Ext.getCmp("StkGrpType").setValue(stkgrpid);
							addComboData(LocStkBinStore, frStkBin, frStkBinDesc);
							Ext.getCmp("StStkBin").setValue(frStkBin);
							addComboData(LocStkBinStore, toStkBin, toStkBinDesc);
							Ext.getCmp("EdStkBin").setValue(toStkBin);
							Ext.getCmp("IncludeNotUse").setValue(includeNotUse);
							Ext.getCmp("NotUseFlag").setValue(onlyNotUse);
							Ext.getCmp('HVFlag').setValue(HVFlag);
							Ext.getCmp('MinRp').setValue(MinRp);
							Ext.getCmp('MaxRp').setValue(MaxRp);
							Ext.getCmp('RandomNum').setValue(RandomNum);
							if (compFlag == true) {
								CompleteBT.setDisabled(true);
								UnCompleteBT.setDisabled(false);
								DeleteBT.setDisabled(true);
							} else {
								CompleteBT.setDisabled(false);
								UnCompleteBT.setDisabled(true);
								DeleteBT.setDisabled(false);
							}
						}
					}
				},
				failure: function (response, opts) {
					console.log('server-side failure with status code ' + response.status);
				}

			});

			//��ѯ�̵㵥��ϸ
			var size = StatuTabPagingToolbar.pageSize;
			StockQtyStore.setBaseParam('sort', 'desc');
			StockQtyStore.setBaseParam('dir', 'ASC');
			StockQtyStore.setBaseParam('Parref', inst);
			StockQtyStore.load({
				params: {
					start: 0,
					limit: size
				}
			});

			//��ѯ���ҹ�����
			/*
			Ext.Ajax.request({
			url:url,
			params:{actiontype:'GetStkManGrp',Rowid:inst},
			method:'post',
			success:function(response,opt){
			var jsonData=Ext.util.JSON.decode(response.responseText);
			var data=jsonData.info;
			var lmgArr=new Array();
			if(data!=null || data.length>0){
			var lmgArr=new Array();
			//var detail=data.split(",");
			for(var i=0;i<detail.length;i++){
			var rowdata=detail[i];
			var lmg=rowdata.split("^")[0];

			var rowcount=LocManGrpGrid.getStore().getCount();
			for(var j=0;j<rowcount;j++){
			var record=LocManGrpStore.getAt(j);
			if(lmg==record.get("Rowid")){
			lmgArr[i]=j;
			break;
			}
			}
			}

			LocManGrpGrid.getSelectionModel().selectRows(lmgArr);
			}
			}
			});
			 */
			Ext.Ajax.request({
				url: url,
				params: {
					actiontype: 'GetLocStkManGrp',
					Rowid: inst
				},
				method: 'post',
				success: function (response, opt) {
					var jsonData = Ext.util.JSON.decode(response.responseText);
					var Loc = jsonData.info;
					reLoadLocManGrp(Loc);
				}
			});

		}

		var CompleteBT = new Ext.Toolbar.Button({
				text: 'ȷ�����',
				tooltip: '���ȷ�����',
				iconCls: 'page_gear',
				width: 70,
				height: 30,
				handler: function () {
					InstComplete();
				}
			});

		//ȷ�����
		function InstComplete() {
			if (gRowid == "" || gRowid == null) {
				Msg.info("warning", "û����Ҫ��ɵ��̵㵥!");
				return;
			}
			Ext.Ajax.request({
				url: url,
				params: {
					actiontype: 'Complete',
					Rowid: gRowid
				},
				method: 'post',
				waitMsg: '������...',
				success: function (response, opt) {
					var jsonData = Ext.util.JSON.decode(response.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "�����ɹ�!");
						Ext.getCmp('Complete').setValue(true);
						//���^ȡ�����^ɾ��
						CompleteBT.setDisabled(true);
						UnCompleteBT.setDisabled(false);
						DeleteBT.setDisabled(true);
					} else {
						var ret = jsonData.info;
						if (ret == -99) {
							Msg.info("error", "����ʧ��!");
						} else if (ret == -2) {
							Msg.info("error", "�̵㵥�Ѿ����!");
						} else {
							Msg.info("error", "����ʧ��!");
						}
					}
				}
			});
		}

		var UnCompleteBT = new Ext.Toolbar.Button({
				text: 'ȡ�����',
				tooltip: '���ȡ�����',
				iconCls: 'page_gear',
				width: 70,
				height: 30,
				handler: function () {
					InstUnComplete();
				}
			});

		//ȷ�����
		function InstUnComplete() {
			if (gRowid == "" || gRowid == null) {
				Msg.info("warning", "��ѡ���̵㵥!");
				return;
			}
			Ext.Ajax.request({
				url: url,
				params: {
					actiontype: 'UnComplete',
					Rowid: gRowid
				},
				method: 'post',
				waitMsg: '������...',
				success: function (response, opt) {
					var jsonData = Ext.util.JSON.decode(response.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "ȡ����ɳɹ�!");
						CompleteBT.setDisabled(false);
						UnCompleteBT.setDisabled(true);
						DeleteBT.setDisabled(false);
					} else {
						var ret = jsonData.info;
						if (ret == -3) {
							Msg.info("error", "ʵ������ɲ���ȡ�����!");
						} else if (ret == -4) {
							Msg.info("error", "���̵㵥��ȡ��!");
						} else {
							Msg.info("error", "����ʧ��!");
						}
					}
				}
			});
		}

		var DeleteBT = new Ext.Toolbar.Button({
				text: 'ɾ��',
				tooltip: '���ɾ��',
				iconCls: 'page_gear',
				width: 70,
				height: 30,
				handler: function () {
					Delete();
				}
			});

		//ɾ��
		function Delete() {
			if (gRowid == "" || gRowid == null) {
				Msg.info("warning", "û����Ҫɾ�����̵㵥!");
				return;
			}
			Ext.Ajax.request({
				url: url,
				params: {
					actiontype: 'Delete',
					Rowid: gRowid
				},
				method: 'post',
				waitMsg: '������...',
				success: function (response, opt) {
					var jsonData = Ext.util.JSON.decode(response.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "�����ɹ�!");
						clearData();
					} else {
						var ret = jsonData.info;
						if (ret == -99) {
							Msg.info("error", "����ʧ��!");
						} else if (ret == -100) {
							Msg.info("error", "�̵㵥�Ѿ���ɣ�������ɾ��!");
						} else {
							Msg.info("error", "����ʧ��!");
						}
					}
				}
			});
		}

		function LoadLocManGrp() {
			var locId = Ext.getCmp("PhaLoc").getValue();
			if (locId == null || locId.length < 0) {
				locId = session['LOGON.CTLOCID'];
			}
			LocManGrpStore.removeAll();
			LocManGrpStore.load({
				params: {
					LocId: locId
				}
			});
		}
		function reLoadLocManGrp(LocId) {

			LocManGrpStore.removeAll();
			LocManGrpStore.load({
				params: {
					LocId: LocId
				}
			});
		}
		var nm = new Ext.grid.RowNumberer();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
						header: "rowid",
						dataIndex: 'rowid',
						width: 80,
						align: 'left',
						sortable: true,
						hidden: true
					}, {
						header: "inclb",
						dataIndex: 'inclb',
						width: 80,
						align: 'left',
						sortable: true,
						hidden: true
					}, {
						header: '���ʴ���',
						dataIndex: 'code',
						width: 80,
						align: 'left',
						sortable: true
					}, {
						header: "��������",
						dataIndex: 'desc',
						width: 200,
						align: 'left',
						sortable: true
					}, {
						header: "���",
						dataIndex: 'spec',
						width: 90,
						align: 'left',
						sortable: true
					}, {
						header: "��λ",
						dataIndex: 'uomDesc',
						width: 80,
						align: 'left',
						sortable: true
					}, {
						header: "����",
						dataIndex: 'rp',
						width: 80,
						align: 'left',
						sortable: true
					}, {
						header: '��������',
						dataIndex: 'freQty',
						width: 100,
						align: 'right',
						sortable: true
					}, {
						header: '��������',
						dataIndex: 'freDate',
						width: 80,
						align: 'left',
						sortable: true
					}, {
						header: '����ʱ��',
						dataIndex: 'freTime',
						width: 80,
						align: 'left',
						sortable: true
					}, {
						header: "����",
						dataIndex: 'manf',
						width: 100,
						align: 'left',
						sortable: true
					}, {
						header: '����',
						dataIndex: 'batchNo',
						width: 100,
						align: 'left',
						sortable: true
					}, {
						header: 'Ч��',
						dataIndex: 'expDate',
						width: 100,
						align: 'left',
						sortable: true
					}, {
						header: '��λ',
						dataIndex: 'sbDesc',
						width: 100,
						align: 'left',
						sortable: true
					}, {
						header: "����",
						dataIndex: 'barcode',
						width: 80,
						align: 'left',
						sortable: true
					}, {
						header: "��ע",
						dataIndex: 'remark',
						width: 80,
						align: 'left',
						sortable: true
					}, {
						header: "״̬",
						dataIndex: 'status',
						width: 80,
						align: 'left',
						sortable: true
					}, {
						header: "����",
						dataIndex: 'scgDesc',
						width: 80,
						align: 'left',
						sortable: true
					}, {
						header: "��Ӧ��",
						dataIndex: 'vendor',
						width: 80,
						align: 'left',
						sortable: true
					}, {
						header: "������",
						dataIndex: 'incscdesc',
						width: 80,
						align: 'left',
						sortable: true
					}, {
						header: "������",
						dataIndex: 'specdesc',
						width: 80,
						align: 'left',
						sortable: true
					}
				]);
		StockQtyCm.defaultSortable = true;

		// ����·��
		var DspPhaUrl = DictUrl
			 + 'instktkaction.csp?actiontype=QueryDetail&start=&limit=';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
				url: DspPhaUrl,
				method: "POST"
			});
		// ָ���в���
		//adjFlag:%String,:%String,inadi:%String
		var fields = ["rowid", "inclb", "code", "desc", "spec", "manf", "barcode", "freQty",
			"freDate", "freTime", "remark", "status", "uom", "uomDesc", "batchNo", "expDate", "sbDesc", "rp", "scgDesc", "vendor", "incscdesc", "specdesc"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: "results",
				id: "rowid",
				fields: fields
			});
		// ���ݼ�
		var StockQtyStore = new Ext.data.Store({
				proxy: proxy,
				reader: reader
			});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store: StockQtyStore,
				pageSize: PageSize,
				displayInfo: true
			});

		var StockQtyGrid = new Ext.ux.GridPanel({
				id: 'StockQtyGrid',
				region: 'center',
				cm: StockQtyCm,
				store: StockQtyStore,
				trackMouseOver: true,
				stripeRows: true,
				sm: new Ext.grid.RowSelectionModel({
					singleSelect: true
				}),
				loadMask: true,
				bbar: StatuTabPagingToolbar
			});
			

		var form = new Ext.form.FormPanel({
				labelwidth: 30,
				width: 400,
				labelAlign: 'right',
				frame: true,
				autoScroll: true,
				bodyStyle: 'padding:10px 0px 0px 0px;',
				items: [InstNo, PhaLoc, TkDate, TkTime, TkUom, TkRemarks, Complete,{
							html: "<font size=2 color=blue>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"+"���鰴�ջ�����λ�����̵�,������</font>"
						},{
						title: '�޶���Χ',
						xtype: 'fieldset',
						items: [Vendor, StkGrpType, DHCStkCatGroup, StStkBin, EdStkBin, HVFlag, ManageDrug, {
								xtype: 'compositefield',
								fieldLabel: '���۷�Χ',
								items: [MinRp, {
										xtype: 'displayfield',
										value: '-'
									}, MaxRp]
							},
							RandomNum,
							IncludeNotUse, NotUseFlag, LocManGrpGrid
						]
					}
				]
			});
		var myToolBar = new Ext.Toolbar({
				items: [SearchBT, '-', CreateBT, '-', CompleteBT, '-', UnCompleteBT, '-', DeleteBT, '-', RefreshBT, '-', PrintBT1, '-', PrintBT2]
			});

		// 5.2.ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
				layout: 'border',
				items: [// create instance immediately
					{
						region: 'north',
						height: 70,
						layout: 'fit', // specify layout manager for items
						title: '�̵�-����',
						items: myToolBar
					}, {
						region: 'west',
						split: true,
						width: 350,
						minSize: 200,
						maxSize: 380,
						collapsible: true,
						layout: 'fit', // specify layout manager for items
						items: form
					}, {
						region: 'center',
						region: 'center',
						layout: 'fit', // specify layout manager for items
						items: StockQtyGrid
					}
				],
				renderTo: 'mainPanel'
			});

		LoadLocManGrp();
		// �����ť�Ƿ����
		CompleteBT.setDisabled(false);
		UnCompleteBT.setDisabled(true);
		DeleteBT.setDisabled(false);
	})
