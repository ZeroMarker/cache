// /����: ������ѯ
// /����: ������ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.10.08
Ext.onReady(function() {

	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//��ȡ����������ʼ������ STATR
	Ext.getUrlParam = function(param) {
		var params = Ext.urlDecode(location.search.substring(1));
		return param ? params[param] : params;
	};
	UsrFlag = Ext.getUrlParam('UsrFlag');

	//��������
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width:120,
		groupId:gGroupId,
		emptyText : '��������...',
		childCombo : 'apcVendorField'
	});
	// ��������
	var StkGrpType=new Ext.ux.StkGrpComboBox({
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:gLocId,
		UserId:userId,
		anchor:'90%',
		width : 120
	});
	// ������
	var RequestPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '������',
		id : 'RequestPhaLoc',
		name : 'RequestPhaLoc',
		anchor:'90%',
		width : 120,
		emptyText : '������...',
		defaultLoc:{}
	});
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		width : 120,
		value : new Date().add(Date.DAY, - 7)
	});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		width : 120,
		value : new Date()
	});
	var inpoNoField = new Ext.form.TextField({
		id:'inpoNoField',
		fieldLabel:'������',
		allowBlank:true,
		emptyText:'������...',
		anchor:'90%',
		selectOnFocus:true
	});

	// ��������
	var InciDesc = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'InciDesc',
		name : 'InciDesc',
		anchor : '90%',
		width : 150,
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = '';  //Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderInfo(field.getValue(), stktype);
				}
			}
		}
	});

	var IncId = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'IncId',
		name : 'IncId',
		hidden:true
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
		Ext.getCmp("IncId").setValue(inciDr);
	}
	var NotImp = new Ext.form.Checkbox({
		boxLabel : 'δ���',
		hideLabel : true,
		id : 'NotImp',
		name : 'NotImp',
		anchor : '90%',
		checked : true
	});
	var PartlyImp = new Ext.form.Checkbox({
		boxLabel : '�������',
		hideLabel : true,
		id : 'PartlyImp',
		name : 'PartlyImp',
		anchor : '90%',
		checked : true
	});

	var AllImp = new Ext.form.Checkbox({
		boxLabel : 'ȫ�����',
		hideLabel : true,
		id : 'AllImp',
		name : 'AllImp',
		anchor : '90%',
		checked : true
	});
	if (UsrFlag==1){
		var apcVendorField = new Ext.ux.UsrVendorComboBox({
			fieldLabel : '��Ӧ��',
			id : 'apcVendorField',
			name : 'apcVendorField',
			anchor : '90%',
			userId :gUserId,
			emptyText : '��Ӧ��...'
		});
	}else{
		// ��Ӧ��
		var apcVendorField=new Ext.ux.VendorComboBox({
			id : 'apcVendorField',
			name : 'apcVendorField',
			anchor:'90%',
			params : {LocId : 'PhaLoc'}
		});
	}
	var includeDefLoc=new Ext.form.Checkbox({
		id: 'defLocPP',
		boxLabel : '����֧�����',
		hideLabel : true,
		anchor:'90%',
		checked:true,
		allowBlank:true
	});
	var SmsFlag = new Ext.form.Checkbox({
		boxLabel : 'δ������',
		hideLabel : true,
		id : 'SmsFlag',
		name : 'SmsFlag',
		anchor : '90%'
	});

	var PlatFlag = new Ext.form.Checkbox({
		boxLabel : 'δ�ϴ�ƽ̨',
		hideLabel : true,
		id : 'PlatFlag',
		name : 'PlatFlag',
		anchor : '90%',
		checked : true
	});
	// ��ѯ������ť
	var SearchBT = new Ext.Toolbar.Button({
		id : "SearchBT",
		text : '��ѯ',
		tooltip : '�����ѯ����',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});

	var SaveMainBT = new Ext.Toolbar.Button({
		id : "SaveMainBT",
		text : '���',
		width : 70,
		height : 30,
		iconCls : 'page_excel',
		handler : function() {
			ExportAllToExcel(MasterGrid,new Date().format(ARG_DATEFORMAT));
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
		}
	});
	// ���Ͷ���
	var SmsBT = new Ext.Toolbar.Button({
		id : "SmsBT",
		text : '���Ͷ���',
		tooltip : '���Ͷ���',
		width : 70,
		height : 30,
		iconCls : 'page_goto',
		handler : function() {
			var recarr=MasterGrid.getSelectionModel().getSelections();
			var count=recarr.length;
			if(count==0){Msg.info("warning","��ѡ��!");return};
			var poistr=""
			for (i=0;i<count;i++)
			{
				var rec=recarr[i];
				var poi=rec.get('PoItmId');
				if (poistr=="")
				{poistr=poi}
				else
				{poistr=poistr+xRowDelim()+poi}
			}
			var url = DictUrl+ "inpoaction.csp?actiontype=Sms";
			Ext.Ajax.request({
				url : url,
				params:{poistr:poistr,user:userId},
				method : 'POST',
				waitMsg : '������...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
					var ret=jsonData.info;
					var arr=ret.split("^");
					var commitno=parseInt(arr[0]);
					var successno=parseInt(arr[1]);
					var defaultno=commitno-successno;
					if(commitno==successno){
						Msg.info("success","���ͳɹ�!");
					}else{
						Msg.info("warning","��"+commitno+"������  "+"�ɹ�"+successno+"����  "+"ʧ��"+defaultno+"����");
					}
					MasterStore.reload();
					}
				},
				scope : this
			});
		}
	});
	// ���Ͷ���
	var PurBT = new Ext.Toolbar.Button({
		id : "PurBT",
		text : '�ɹ�ƽ̨',
		tooltip : '�ɹ�ƽ̨',
		width : 70,
		height : 30,
		iconCls : 'page_uploadyun',
		handler : function() {
			Msg.info("warning", "������!");
		}
	});
	// �ܾ���ť
	var DeniedBT = new Ext.Toolbar.Button({
		id : "DeniedBT",
		text : '����һ��',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function() {
			DenyDetail();
		}
	});
	function DenyDetail() {
		var rowDataarr = MasterGrid.getSelectionModel().getSelections();
		if (rowDataarr ==null) {
			Msg.info("warning", "��ѡ��Ҫ�ܾ�����ϸ!");
			return;
		}
		var count=rowDataarr.length;
		if (count!=1){
			Msg.info("warning", "��ѡ��һ��Ҫ�ܾ�����ϸ!");
			return;
		}
		var inppistr=""
		for (i=0;i<count;i++) {
			var rowData=rowDataarr[i];
			var inppi=rowData.get('PoItmId');
			if (inppistr=="")
			{inppistr=inppi}
			else
			{inppistr=inppistr+","+inppi}
		}
		var url = DictUrl+ "inpoaction.csp?actiontype=DenyDetail";
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '��ѯ��...',
			params: {RowIdStr:inppistr},
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					var Ret=jsonData.info;
					if(Ret==0){
						Msg.info("success", "�����ɹ�!");
						MasterStore.reload();
					}
					if(Ret==-1){
						Msg.info("error","�����Ѿ���� ���ܳ���!");
					}else if(Ret==-2){
						Msg.info("error", "�ѳ���,�����ظ�����!");
					}
				}
			},
			scope : this
		});
	}
	/**
	 * ��շ���
	 */
	function clearData() {
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("apcVendorField").setValue("");
		Ext.getCmp("RequestPhaLoc").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 7));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("StkGrpType").setValue("");
		Ext.getCmp("StkGrpType").getStore().load();
		Ext.getCmp("inpoNoField").setValue("");
		Ext.getCmp("InciDesc").setValue("");
		Ext.getCmp("IncId").setValue("");
		Ext.getCmp("NotImp").setValue(true);
		Ext.getCmp("PartlyImp").setValue(true);
		Ext.getCmp("AllImp").setValue(true);
		Ext.getCmp("defLocPP").setValue(true);
		Ext.getCmp("SmsFlag").setValue(false);
		Ext.getCmp("PlatFlag").setValue(true);

		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
	}

	// ��ʾ��������
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", "��ѡ�񶩹�����!");
			return;
		}
		var reqloc=Ext.getCmp("RequestPhaLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		if(Ext.isEmpty(startDate)){
			Msg.info('warning', '��ʼ���ڲ���Ϊ��');
			return false;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		var endDate = Ext.getCmp("EndDate").getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '��ֹ���ڲ���Ϊ��');
			return false;
		}
		endDate = endDate.format(ARG_DATEFORMAT);
		var notimp = (Ext.getCmp("NotImp").getValue()==true?0:'');
		var partlyimp = (Ext.getCmp("PartlyImp").getValue()==true?1:'');
		var allimp = (Ext.getCmp("AllImp").getValue()==true?2:'');
		var Vendor = Ext.getCmp("apcVendorField").getValue();
		var PoNo = Ext.getCmp('inpoNoField').getValue();
		var Status=notimp+','+partlyimp+','+allimp;
		var includeDefLoc=(Ext.getCmp('defLocPP').getValue()==true?1:0);  //�Ƿ����֧�����
		var SmsFlag=(Ext.getCmp("SmsFlag").getValue()==true?'N':'');
		var PlatFlag=(Ext.getCmp("PlatFlag").getValue()==true?'N':'');
		var inciDesc=Ext.getCmp("InciDesc").getValue();
		if (inciDesc==""){
			Ext.getCmp("IncId").setValue("");
		}
		var InciId=Ext.getCmp("IncId").getRawValue();
		var StkGrp=Ext.getCmp("StkGrpType").getValue();
		//��ʼ����^��ֹ����^������^��Ӧ��id^����id^��ɱ�־^��˱�־^����״̬(δ��⣬������⣬ȫ�����)
		//���ȡ����־�����N��ʾֻ��ѯδȡ����
		var ListParam=startDate+'^'+endDate+'^'+PoNo+'^'+Vendor+'^'+phaLoc+'^Y^0^'+Status+'^'+InciId+'^'+includeDefLoc+"^"+SmsFlag+"^"+PlatFlag+"^"+reqloc+"^"+StkGrp+"^N";
		var Page=GridPagingToolbar.pageSize;
		MasterStore.removeAll();
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
	}

	function renderPoStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus='δ���';
		}else if(value==1){
			PoStatus='�������';
		}else if(value==2){
			PoStatus='ȫ�����';
		}
		return PoStatus;
	}
	// ����·��
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=QueryAll';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// ָ���в���
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","Email","ReqLocDesc",
				"PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "NotImpQty", "Rp","PurQty","ImpQty","Spec",
				"SMSSentFlag","PlatSentFlag","Mobile","SpecDesc","reqremark"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				fields : fields
			});
	// ���ݼ�
	var MasterStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader,
		listeners : {
			load : function(store,records,options){
				if(records.length>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			}
		}
	});
	var sm1=new Ext.grid.CheckboxSelectionModel({})
	var nm = new Ext.grid.RowNumberer();
	var MasterCm = new Ext.grid.ColumnModel([nm,sm1,{
			header : "RowId",
			dataIndex : 'PoId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "������",
			dataIndex : 'PoNo',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "��������",
			dataIndex : 'PoLoc',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "�������",
			dataIndex : 'ReqLocDesc',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "��Ӧ��",
			dataIndex : 'Vendor',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "����״̬",
			dataIndex : 'PoStatus',
			width : 90,
			align : 'left',
			sortable : true,
			renderer:renderPoStatus
		}, {
			header : "��������",
			dataIndex : 'PoDate',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "��Ӧ������",
			dataIndex : 'Email',
			width : 120,
			align : 'left',
			sortable : true
		},{
			header : "������ϸid",
			dataIndex : 'PoItmId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "����RowId",
			dataIndex : 'IncId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '���ʴ���',
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'IncDesc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			header : '���',
			dataIndex : 'Spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "��λ",
			dataIndex : 'PurUom',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "����",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : "��������",
			dataIndex : 'PurQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "��������",
			dataIndex : 'ImpQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "δ��������",
			dataIndex : 'NotImpQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "����Ա�ֻ�����",
			dataIndex : 'Mobile',
			width : 120,
			align : 'right',
			sortable : true
		}, {
			header : "��ϸ���",
			dataIndex : 'SpecDesc',
			width : 120,
			align : 'right',
			sortable : true
		},{
			header:"����ע",
			dataIndex:'reqremark',
			width:120,
			align:'left'
		}]);
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var MasterGrid = new Ext.ux.GridPanel({
		region:'center',
		title: '������ϸ',
		id:'MasterGrid',
		cm : MasterCm,
		sm : sm1,
		store : MasterStore,
		bbar:GridPagingToolbar
	});

	var HisListTab = new Ext.ux.FormPanel({
		labelWidth : 60,
		title: '�������������ѯ',
		tbar : [SearchBT,'-',ClearBT,'-',SaveMainBT,'-',SmsBT,'-',PurBT],		//2018-04-16 ��ʱע��,'-',DeniedBT
		items : [{
			xtype : 'fieldset',
			title : '��ѯ��Ϣ',
			layout : 'column',
			style:'padding:5px 0px 0px 5px',
			defaults : {xtype: 'fieldset',border : false},
			items : [{
				columnWidth: 0.25,
				items: [PhaLoc,apcVendorField,RequestPhaLoc]
			},{
				columnWidth: 0.2,
				items: [StartDate,EndDate,StkGrpType]
			},{
				columnWidth: 0.25,
				items: [inpoNoField,InciDesc]
			},{
				columnWidth: 0.15,
				items: [NotImp,PartlyImp,AllImp]
			},{
				columnWidth: 0.15,
				labelWidth : 100,
				items: [includeDefLoc,SmsFlag,PlatFlag]
			}]
		}]
	});

	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[HisListTab, MasterGrid]
	});
});