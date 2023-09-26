// /����: �����ѽ���ת�Ƶ�����
// /��д�ߣ�wangjiabin
// /��д����: 2016.07.27

	var gUserId = session['LOGON.USERID'];
	
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		anchor : '90%',
		emptyText : '����...',
		listWidth : 250,
		groupId : session['LOGON.GROUPID']
	});
	
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '��������',
		id : 'SupplyPhaLoc',
		anchor : '90%',
		emptyText : '��������...',
		defaultLoc : {}
		,width : 150
	});
	
	var InitStartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'InitStartDate',
		anchor : '90%',
		value : DefaultStDate()
	});

	var InitEndDate = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'InitEndDate',
		anchor : '90%',
		value : DefaultEdDate()
	});

	var RequestPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '������',
		id : 'RequestPhaLoc',
		anchor : '90%',
		emptyText : '������...',
		listWidth : 250,
		defaultLoc:''
	});

	var InitSearchBtn = new Ext.Button({
		text : '��ѯ',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function(){
			InitMasterGrid.load();
		}
	});
	
	var SaveByInitBtn = new Ext.ux.Button({
		text : '����',
		iconCls : 'page_save',
		handler : function(){
			SaveByInitIn();
		}
	});
	
	function SaveByInitIn(){
		var record = InitMasterGrid.getSelected();
		if(Ext.isEmpty(record)){
			Msg.info('warning', '��ѡ���ѽ��յĿ��ת�Ƶ�!');
			return false;
		}
		var supplyPhaLoc = record.get('toLoc');
		var requestPhaLoc = Ext.getCmp('RequestPhaLoc').getValue();
		if(Ext.isEmpty(requestPhaLoc)){
			Msg.info("warning", "��ѡ���������!");
			return;
		}
		var ingrid='';
		var reqid='';
		var operatetype = '';
		var Complete='N';
		var Status = '10';
		var StkGrpId = record.get('scg');
		var StkType = App_StkTypeCode;
		var remark = '';
		
		var MainInfo = supplyPhaLoc + "^" + requestPhaLoc + "^" + reqid + "^" + operatetype + "^" + Complete
				+ "^" + Status + "^" + gUserId + "^"+StkGrpId+"^"+StkType+"^"+remark+"^"+ingrid;

		//��ϸid^����id^����^��λ^������ϸid^��ע
		var ListDetail = "";
		var DetailSelections = InitDetailGrid.getSelections();
		for(var i = 0, len = DetailSelections.length; i < len; i++){
			var rowData = DetailSelections[i];
			var Initi = '';
			var inclb = rowData.get('inclb');
			var qty = rowData.get('OperQty');
			
			if((qty<0)||(qty==0)||(qty=="")||(qty=="defined")){
				desc=rowData.get('inciDesc');
				Msg.info("warning","����ȷ��д"+desc+"������");
				return;
			}
			var uom = rowData.get('uom');
			var ReqItmId = '';
			var Remark = '';
			var HVBarCode = '';
			var str = Initi +'^'+ inclb +'^'+ qty +'^' +uom+'^'+ReqItmId
				+'^'+Remark+'^'+HVBarCode+'^^^';
			if(ListDetail == ""){
				ListDetail = str;
			}else{
				ListDetail = ListDetail + xRowDelim() + str;
			}
		}
		if(Ext.isEmpty(ListDetail)){
			Msg.info('warning', '�빴ѡ����Ҫ�������ϸ!');
			return false;
		}
		Ext.Ajax.request({
			url : DictUrl + "dhcinistrfaction.csp?actiontype=Save",
			params : {Rowid:'', MainInfo:MainInfo, ListDetail:ListDetail},
			method : 'POST',
			waitMsg : '������...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					// ˢ�½���
					var InitRowid = jsonData.info;
					Msg.info("success", "����ɹ�!");
					// ��ת�������Ƶ�����
					var HVInIsTrfFlag = false;
					if(HVInIsTrfFlag){
						window.location.href='dhcstm.dhcinistrfhv.csp?Rowid='+InitRowid+'&QueryFlag=1';
					}else{
						window.location.href='dhcstm.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';
					}
				} else {
					var ret=jsonData.info;
					if(ret==-99){
						Msg.info("error", "����ʧ��,���ܱ���!");
					}else if(ret==-2){
						Msg.info("error", "���ɳ��ⵥ��ʧ��,���ܱ���!");
					}else if(ret==-1){
						Msg.info("error", "������ⵥʧ��!");
					}else if(ret==-5){
						Msg.info("error", "������ⵥ��ϸʧ��!");
					}else {
						Msg.info("error", "������ϸ���治�ɹ���"+ret);
					}
				}
			},
			scope : this
		});			
	}
	
	var InitClearBtn = new Ext.Button({
		text : '���',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function(){
			ClearData();
		}
	});
	
	function ClearData(){
		clearPanel(DispByInitForm);
		DispByInitForm.getForm().setValues({InitStartDate : new Date().add(Date.DAY, - 7), InitEndDate : new Date()});
		InitMasterGrid.removeAll();
		InitMasterGrid.getView().refresh();
		InitDetailGrid.removeAll();
		InitDetailGrid.getView().refresh();
	}
	
	var DispByInitForm = new Ext.ux.FormPanel({
		title : '���ת��(�����ѽ���ת�Ƶ�)',
		labelWidth : 100,
		tbar : [InitSearchBtn, '-', SaveByInitBtn, '-', InitClearBtn],
		layout : 'column',
		bodyStyle : 'padding:5px 0 0 0',
		items : [{
				columnWidth : 0.65,
				xtype : 'fieldset',
				title : '��ѯ����',
				layout : 'column',
				defaults : {xtype : 'fieldset', border : false},
				items : [
						{columnWidth:.4,items:[PhaLoc, SupplyPhaLoc]},
						{columnWidth:.5,items:[InitStartDate, InitEndDate]}
				]
			},{
				columnWidth : 0.35,
				xtype : 'fieldset',
				title : '����ѡ��',
				layout : 'column',
				defaults : {xtype : 'fieldset', border : false},
				items : [
						{columnWidth:.8,items:[RequestPhaLoc]}
			]}
		]
	});

	var InitMasterCm = [{
				header : 'RowId',
				dataIndex : 'init',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : 'ת�Ƶ���',
				dataIndex : 'initNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '��������',
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '���տ���rowid',
				dataIndex : 'toLoc',
				width : 60,
				hidden : true
			}, {
				header : '����id',
				dataIndex : 'scg',
				width :60,
				align : 'center',
				hidden : true
			}, {
				header : '����',
				dataIndex : 'scgDesc',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : 'ת������',
				dataIndex : 'dd',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : '����״̬',
				dataIndex : 'StatusCode',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '�Ƶ���',
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : '���ȷ������',
				dataIndex : 'inAckDate',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : '���ȷ��ʱ��',
				dataIndex : 'inAckTime',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : '���ȷ����',
				dataIndex : 'inAckUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '���۽��',
				dataIndex : 'RpAmt',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : '�ۼ۽��',
				dataIndex : 'SpAmt',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : '�������',
				dataIndex : 'MarginAmt',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : '��ע',
				dataIndex : 'Remark',
				width : 100,
				align : 'left',
				sortable : true
			}];

	var InitMasterGrid = new Ext.dhcstm.EditorGridPanel({
		id : 'InitMasterGrid',
		childGrid : 'InitDetailGrid',
		region : 'center',
		editable : false,
		contentColumns : InitMasterCm,
		smType : 'row',
		singleSelect : true,
		autoLoadStore : true,
		smRowSelFn : rowSelFn,
		actionUrl : DictUrl + 'dhcinistrfaction.csp',
		queryAction : 'Query',
		paramsFn : GetMasterParams,
		idProperty : 'init',
		showTBar : true
	});

	function GetMasterParams(){
		var PhaLoc = Ext.getCmp('PhaLoc').getValue();
		if(Ext.isEmpty(PhaLoc)){
			Msg.info('warning', '���Ҳ���Ϊ��!');
			return false;
		}
		var supplyphaLoc = Ext.getCmp('SupplyPhaLoc').getValue();
		var startDate = Ext.getCmp('InitStartDate').getValue();
		if(Ext.isEmpty(startDate)){
			Msg.info('warning', '��ʼ���ڲ���Ϊ��!');
		}else{
			startDate = startDate.format(ARG_DATEFORMAT).toString();
		}
		var endDate = Ext.getCmp('InitEndDate').getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '��ֹ���ڲ���Ϊ��!');
		}else{
			endDate = endDate.format(ARG_DATEFORMAT).toString();
		}
		var statue =  '31';		//��ͳ���ѽ��յĵ���
		var stkgrpid = '';
		var inci = '', inciDesc = '';
		
		var UserScgPar = PhaLoc + '%' + gUserId;
		var ParamStr = startDate+'^'+endDate+'^'+supplyphaLoc+'^'+PhaLoc+'^'
			+'^'+statue+'^^^'+stkgrpid+'^'+inci
			+'^^'+inciDesc+'^^'+UserScgPar;
		return {'Sort' : '', 'Dir' : '','ParamStr' : ParamStr};
	}

	function rowSelFn(sm, rowIndex, r){
		var rowData = sm.grid.getAt(rowIndex);
		var InitId = rowData.get('init');
		InitDetailGrid.load({params : {sort : 'Rowid', dir : 'asc', Parref : InitId}});
	}
	
	var InitDetailCm = [{
			header : 'ת��ϸ��RowId',
			dataIndex : 'initi',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '����Id',
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
			header : '���',
			dataIndex : 'spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '����Id',
			dataIndex : 'inclb',
			width : 180,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '����/Ч��',
			dataIndex : 'batexp',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			header : 'ת������',
			dataIndex : 'qty',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '��λid',
			dataIndex : 'uom',
			width : 60,
			align : 'left',
			hidden : 'true'
		}, {
			header : '��λ',
			dataIndex : 'TrUomDesc',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : '����',
			dataIndex : 'rp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '�ۼ�',
			dataIndex : 'sp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : 'ҵ������',
			dataIndex : 'OperQty',
			width : 60,
			align : 'right',
			editor : new Ext.form.TextField()
		}, {
			header : '���ο�������',
			dataIndex : 'inclbAvaQty',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '���۽��',
			dataIndex : 'rpAmt',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '�ۼ۽��',
			dataIndex : 'spAmt',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '��������',
			dataIndex : 'manfName',
			width : 120,
			align : 'left',
			sortable : true
		}];

	var InitDetailGrid = new Ext.dhcstm.EditorGridPanel({
		id : 'InitDetailGrid',
		region : 'south',
		height : 260,
		editable : true,
		contentColumns : InitDetailCm,
		smType : 'checkbox',
		singleSelect : false,
		selectFirst : false,
		showTBar : false,
		autoLoadStore : false,
		actionUrl : DictUrl + 'dhcinistrfaction.csp',
		queryAction : 'InitToLocDetail',
		idProperty : 'initi',
		paging : false
	});
	InitDetailGrid.getSelectionModel().on('beforerowselect', function(sm,rowIndex,keepExisting,rec){
		var qty = Number(rec.get('qty'));
		var avaQty = Number(rec.get('inclbAvaQty'));
		var OperQty = Math.min(qty, avaQty);
		if(OperQty <= 0){
			Msg.info('warning', '������������!');
			return false;
		}
	});
	InitDetailGrid.getSelectionModel().on('rowselect', function(sm,index,rec){
		var qty = Number(rec.get('qty'));
		var avaQty = Number(rec.get('inclbAvaQty'));
		var OperQty = Math.min(qty, avaQty);
		rec.set('OperQty',OperQty);
	});
	InitDetailGrid.getSelectionModel().on('rowdeselect', function(sm,ind,rec){	
		rec.set('OperQty','');
	});
	
	Ext.onReady(function() {
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
		// ҳ�沼��
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [DispByInitForm, InitMasterGrid, InitDetailGrid]
		});
	});