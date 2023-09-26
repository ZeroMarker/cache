// /����: ���ⵥ��ѯ
// /����: ���ⵥ��ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.07.24

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
    var gGroupId=session['LOGON.GROUPID'];
    var gLocId=session['LOGON.CTLOCID'];
    var gInciRowId="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	ChartInfoAddFun();
	
	function ChartInfoAddFun() {
		// ������
		var RequestPhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '������',
			id : 'RequestPhaLoc',
			anchor:'90%',
			emptyText : '������...',
			defaultLoc:{},
			listeners:{
				'select':function(cb)
				{
					var requestLoc=cb.getValue();
					var provLoc=Ext.getCmp('SupplyPhaLoc').getValue();
					Ext.getCmp("StkGrpType").setFilterByLoc(provLoc,requestLoc);
				}
			}
		});
	
		// ��������
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '��������',
			id : 'SupplyPhaLoc',
			anchor:'90%',
			emptyText : '��������...',
			groupId:gGroupId,
			listeners:{
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
			boxLabel : G_VIRTUAL_STORE,
			id : 'VirtualFlag',
			anchor : '90%',
			checked : false,
			listeners:{
				check:function(chk,bool){
					if(bool){
						var phaloc=Ext.getCmp("SupplyPhaLoc").getValue();
						var info = tkMakeServerCall('web.DHCSTM.Common.UtilCommon','GetMainLoc',phaloc);
						var url="dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc="+phaloc;
						var infoArr=info.split("^");
						var vituralLoc=infoArr[0],vituralLocDesc=infoArr[1];
						addComboData(Ext.getCmp("SupplyPhaLoc").getStore(),vituralLoc,vituralLocDesc);
						Ext.getCmp("SupplyPhaLoc").setValue(vituralLoc);
					}else{
						SetLogInDept(Ext.getCmp("SupplyPhaLoc").getStore(), "SupplyPhaLoc");
					}
				}
			}
		});

		// ��ʼ����
		var StartDate = new Ext.ux.DateField({
			fieldLabel : '��ʼ����',
			id : 'StartDate',
			anchor : '90%',
			value : DefaultStDate()
		});
		
		// ��ֹ����
		var EndDate = new Ext.ux.DateField({
			fieldLabel : '��ֹ����',
			id : 'EndDate',
			anchor : '90%',
			value : DefaultEdDate()
		});
		
		var DateType = new Ext.form.RadioGroup({
			id:'DateType',
			fieldLabel: '��ѯ����',
			columns: 2,
			anchor: '90%',
			items: [
				{boxLabel: '�Ƶ�����', name: 'radio', inputValue: '1', checked: true},
				{boxLabel: '�������', name: 'radio', inputValue: '2'}
			]
		});
		
		var FindTypeData=[['ȫ��','1'],['��ȷ��','2'],['δȷ��','3']];
		var FindTypeStore = new Ext.data.SimpleStore({
			fields: ['typedesc', 'typeid'],
			data : FindTypeData
		});
		var ConfirmFlag = new Ext.form.ComboBox({
			store: FindTypeStore,
			displayField:'typedesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'ConfirmFlag',
			fieldLabel : '�Ƿ�ȷ��',
			triggerAction:'all',
			valueField : 'typeid'
		});
		Ext.getCmp("ConfirmFlag").setValue("1");
		
		var PrintTypeData=[['ȫ��','1'],['�Ѵ�ӡ','2'],['δ��ӡ','3']];
		var PrintTypeStore = new Ext.data.SimpleStore({
			fields: ['typedesc', 'typeid'],
			data : PrintTypeData
		});
		var PrintFlag = new Ext.form.ComboBox({
			store: PrintTypeStore,
			displayField:'typedesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'PrintFlag',
			fieldLabel : '�Ƿ��ӡ',
			triggerAction:'all',
			valueField : 'typeid'
		});
		Ext.getCmp("PrintFlag").setValue("1");
		
		var StatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['10', 'δ���'], ['11', '�����'],
					['20', '������˲�ͨ��'],['21', '�������ͨ��'],['30', '�ܾ�����'],['31', '�ѽ���'],
					['10,11,20,30', '����ռ��']]
		});
		
		var Status = new Ext.form.ComboBox({
			fieldLabel : 'ת�Ƶ�״̬',
			id : 'Status',
			name : 'Status',
			anchor:'90%',
			width : 100,
			store : StatusStore,
			triggerAction : 'all',
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			editable : true,
			valueNotFoundText : ''
		});
				
		// ��������
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			StkType:App_StkTypeCode,     //��ʶ��������
			LocId:gLocId,
			UserId:userId,
			anchor:'90%'
		}); 
		
		// ��������
		var InciDesc = new Ext.form.TextField({
			fieldLabel : '��������',
			id : 'InciDesc',
			anchor : '90%',
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});

		/**
		 * �������ʴ��岢���ؽ��
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
			}
		}
		
		/**
		 * ���ط���
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(InciDesc);
			gInciRowId=inciDr;
		}
		
		var CreateUser = new Ext.ux.ComboBox({
			id : 'CreateUser',
			fieldLabel : '�Ƶ���',
			store : UStore,
			params : {locId : 'SupplyPhaLoc'},
			filterName : 'name'
		});
		
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
			text : '��ѯ',
			tooltip : '�����ѯ',
			width : 70,
			height : 30,
			iconCls : 'page_find',
			handler : function() {
				Query();
			}
		});
		/**
		 * ��ѯ����
		 */
		function Query() {
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
				Msg.info("warning", "��ѡ��Ӧ����!");
				return;
			}
			var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
			var startDate = Ext.getCmp("StartDate").getValue();
			var endDate = Ext.getCmp("EndDate").getValue();
			if(startDate!=""){
				startDate = startDate.format(ARG_DATEFORMAT);
			}
			if(endDate!=""){
				endDate = endDate.format(ARG_DATEFORMAT);
			}
			var dateType = Ext.getCmp("DateType").getValue().getGroupValue();
			var statue =  Ext.getCmp("Status").getValue();
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var ConfirmFlag = Ext.getCmp("ConfirmFlag").getValue();
			var PrintFlag = Ext.getCmp("PrintFlag").getValue();
			var inci=gInciRowId;
			var inciDesc="";
			if(Ext.getCmp("InciDesc").getValue()==""){
				inci="";
				gInciRowId="";
			}
			if(inci==""){
				inciDesc=Ext.getCmp("InciDesc").getValue();
			}
			var CreateUser = Ext.getCmp('CreateUser').getValue();
			var UserScgPar = supplyphaLoc + '%' + userId;
			var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^'
				+'^'+statue+'^^^'+stkgrpid+"^"+inci
				+"^"+ConfirmFlag+"^"+inciDesc+'^'+CreateUser+'^'+UserScgPar+'^'+PrintFlag
				+"^"+dateType;
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam('ParamStr',ListParam);
			DetailGrid.store.removeAll();
			MasterStore.removeAll();
			MasterStore.load({
				params:{start:0, limit:Page},
				callback:function(r,options,success){
					if(!success){
						Msg.info("error","��ѯ����, ��鿴��־!");
					}
				}
			});
		}

		// ��հ�ť
		var ClearBT = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '������',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				clearData();
			}
		});
		/**
		 * ��շ���
		 */
		function clearData() {
			SetLogInDept(PhaDeptStore, "SupplyPhaLoc");
			Ext.getCmp("RequestPhaLoc").setValue("");
			Ext.getCmp("Status").setValue("");
			Ext.getCmp("StkGrpType").setValue("");
			Ext.getCmp("InciDesc").setValue("");
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 7));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("CreateUser").setValue("");
			Ext.getCmp("ConfirmFlag").setValue("1");
			Ext.getCmp("PrintFlag").setValue("1");
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}
		
		// ��ӡ��ť
		var PrintBT = new Ext.Toolbar.Button({
			text : '��ӡ',
			tooltip : '�����ӡ',
			width : 70,
			height : 30,
			iconCls : 'page_print',
			handler : function() {
				var rowData=MasterGrid.getSelectionModel().getSelected();
				if (rowData ==null) {
					Msg.info("warning", "��ѡ����Ҫ��ӡ��ת�Ƶ�!");
					return;
				}
				var init = rowData.get("init");
				var HVflag=GetCertDocHVFlag(init,"T");
				if (HVflag=="Y"){
					PrintInIsTrfHVCol(init);
				}else{
				PrintInIsTrf(init);
				}
			}
		});
		
		// ��ӡ��ť
		var PrintHVCol = new Ext.Toolbar.Button({
			text : '��ֵ���ܴ�ӡ',
			tooltip : '��ӡ��ֵת�Ƶ�Ʊ��',
			width : 70,
			height : 30,
			iconCls : 'page_print',
			handler : function() {
				var rowData=MasterGrid.getSelectionModel().getSelected();
				if (rowData ==null) {
					Msg.info("warning", "��ѡ����Ҫ��ӡ��ת�Ƶ�!");
					return;
				}
				var init = rowData.get("init");
				var HVflag=GetCertDocHVFlag(init,"T");
				if (HVflag=="Y"){
					PrintInIsTrfHVCol(init);
				}else{
					Msg.info("warning","�Ǹ�ֵ����ʹ�ô�ӡ��ť����!");
					return;
				}
			}
		});
		
		// �ⷿȷ�ϰ�ť
		var ConfirmBT = new Ext.Toolbar.Button({
			text : '�ⷿȷ��',
			tooltip : '���ȷ��',
			width : 70,
			height : 30,
			iconCls : 'page_find',
			handler : function() {
				Confirm();
			}
		});
		/**
		 * �ⷿȷ�Ϸ���
		 */
		function Confirm() {
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData == null) {
				Msg.info("warning", "��ѡ��ȷ�ϵ�ת�Ƶ�!");
				return;
			}
			var ConfirmFlag = rowData.get("confirmFlag");
			if (ConfirmFlag == "Y") {
				Msg.info("warning", "ת�Ƶ���ȷ��!");
				return;
			}
			var Init = rowData.get("init");
			var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=Confirm&Rowid="+ Init;
			Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '��ѯ��...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "�ⷿȷ�ϳɹ�!");
						Query();
					} else {
						var Ret=jsonData.info;
						if(Ret<0){
							Msg.info("error", "ȷ��ʧ��:"+Ret);
						}
					}
				},
				scope : this
			});
		}
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
		/**
		 * �ⷿȷ�ϰ�ť�Ƿ����
		 */
		function changeButtonEnable() {
		/*	if(userId==?||gGroupId==?||gLocId==?){	//������Ա��ȫ�������������Ƿ����
				ConfirmBT.setDisabled(false);
			}else{
				ConfirmBT.setDisabled(true);
			}*/
		}
		// ����·��
		var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
		// ͨ��AJAX��ʽ���ú�̨����
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// ָ���в���
		var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName",
		"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode","confirmFlag","OperType"];
		// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "init",
					fields : fields
				});
		// ���ݼ�
		var MasterStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader,
			listeners:{
				load:function(store,records,options){
					if(records.length>0){
						MasterGrid.getSelectionModel().selectFirstRow();
					}
				}
			}
		});
		var nm = new Ext.grid.RowNumberer();
		var MasterCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'init',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "ת�Ƶ���",
				dataIndex : 'initNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '���󵥺�',
				dataIndex : 'reqNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "������",
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "ת������",
				dataIndex : 'dd',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "����״̬",
				dataIndex : 'StatusCode',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�Ƶ���",
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "���۽��",
				dataIndex : 'RpAmt',
				width : 80,
				align : 'right',
				summaryType : 'sum',
				sortable : true
			}, {
				header : "�ۼ۽��",
				dataIndex : 'SpAmt',
				width : 80,
				align : 'right',
				summaryType : 'sum',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'MarginAmt',
				width : 80,
				align : 'right',
				
				sortable : true
			}, {
				header : "��ע",
				dataIndex : 'Remark',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'OperType',
				width : 100,
				align : 'left'
			}]);
		MasterCm.defaultSortable = true;
		var GridPagingToolbar = new Ext.PagingToolbar({
			store:MasterStore,
			pageSize:PageSize,
			displayInfo:true
		});
		var MasterGrid = new Ext.ux.GridPanel({
			region: 'center',
			title: '���ⵥ',
			id : 'MasterGrid',
			cm : MasterCm,
			sm : new Ext.grid.RowSelectionModel({
						singleSelect : true
					}),
			store : MasterStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			bbar:GridPagingToolbar,
			plugins : new Ext.grid.GridSummary()
		});

		// ��ӱ�񵥻����¼�
		MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var InIt = MasterStore.getAt(rowIndex).get("init");
			DetailStore.setBaseParam('Parref',InIt);
			DetailStore.removeAll();
			DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
		});

		// ת����ϸ
		// ����·��
		var DetailUrl =  DictUrl
					+ 'dhcinistrfaction.csp?actiontype=QueryDetail';
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
				"pp", "spec","newSp", "HVBarCode",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc","SterilizedBat","inclbbarcode"];
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
				header : "����Id",
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
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '��ֵ����',
				dataIndex : 'HVBarCode',
				width : 120,
				align : 'left'
			}, {
				header : "����Id",
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
				header : "���ο��",
				dataIndex : 'inclbQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "ת������",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "ת�Ƶ�λ",
				dataIndex : 'TrUomDesc',
				width : 80,
				align : 'left',
				sortable : true
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
				header : "ռ������",
				dataIndex : 'inclbDirtyQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'inclbAvaQty',
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
			},/*{
				header : "ͨ����",
				dataIndex : 'gene',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "����",
				dataIndex : 'form',
				width : 100,
				align : 'left',
				sortable : true
			},*/ {
				header : "�ۼ۽��",
				dataIndex : 'spAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "���۽��",
				dataIndex : 'rpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "�������",
				dataIndex : 'SterilizedBat',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "��ע",
				dataIndex : 'remark',
				width : 100,
				align : 'right',
				sortable : true
			},print, {
				header : "��������",
				dataIndex : 'inclbbarcode',
				width : 100,
				align : 'left',
				sortable : true
			}]);
       var GridDetailPagingToolbar = new Ext.PagingToolbar({
			store:DetailStore,
			pageSize:PageSize,
			displayInfo:true
		});
		var DetailGrid = new Ext.grid.GridPanel({
			region: 'south',
			split: true,
			//height: gGridHeight,
			height:170,
			minSize: 100,
			maxSize: 350,
			collapsible: true,
			title: '���ⵥ��ϸ',
			cm : DetailCm,
			store : DetailStore,
			trackMouseOver : true,
			stripeRows : true,
			bbar:GridDetailPagingToolbar,
			plugins : [print],
			loadMask : true
		});

		var HisListTab = new Ext.ux.FormPanel({
			title:"���ⵥ��ѯ",
			tbar : [SearchBT, '-', ClearBT, '-', PrintBT, '-', PrintHVCol,'-', ConfirmBT,'-', printBarCode],
			layout: 'fit',
			items:[{
				xtype:'fieldset',
				layout:'column',
				style:'padding:5px 0px 0px 0px',
				defaults:{border:false, layout:'form'},
				title:'��ѯ����',
				autoHeight:true,
				labelWidth: 70,
				items : [{
					columnWidth: 0.26,
					labelWidth: 100,
					items: [SupplyPhaLoc,RequestPhaLoc,Status]
				},{
					columnWidth: 0.05,
					items: [VirtualFlag]
				},{
					columnWidth: 0.29,
					items: [DateType,StartDate,EndDate]
				},{
					columnWidth: 0.25,
					items: [StkGrpType,InciDesc,CreateUser]
				},{
					columnWidth: 0.15,
					items: [ConfirmFlag,PrintFlag]
				}]
			}]
		});

		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, MasterGrid, DetailGrid],
			renderTo : 'mainPanel'
		});
		changeButtonEnable();
	}
})