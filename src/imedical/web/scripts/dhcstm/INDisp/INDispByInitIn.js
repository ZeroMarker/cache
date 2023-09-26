
/**
 * ����ת�ƽ��յĵ���,���п��������ĵķ���
 * @param {} subLoc
 * @param {} toLoc ��ӽ��ܿ���
 * @param {} Fn
 */
function LoadInitIn(subLoc,toLoc, Fn){
	var gUserId = session['LOGON.USERID'];
	
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '��������',
		id : 'SupplyPhaLoc',
		anchor : '90%',
		emptyText : '��������...',
		defaultLoc : {}
	});
	
	var InitStartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'InitStartDate',
		anchor : '90%',
		value : new Date().add(Date.DAY, -7)
	});

	var InitEndDate = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'InitEndDate',
		anchor : '90%',
		value : new Date()
	});
	
	var InitUserGrp = new Ext.ux.ComboBox({
		id : 'InitUserGrp',
		anchor : '90%',
		disabled : true,
		store : UserGroupStore,
		valueField : 'RowId',
		displayField : 'Description',
		valueParams : {SubLoc : toLoc}
	});
	
	var InitUser = new Ext.ux.ComboBox({
		id : 'InitUser',
		anchor : '90%',
		disabled : true,
		store:UStore,
		valueField:'RowId',
		displayField:'Description',
		filterName:'name',
		valueParams : {locId : toLoc}
	});
	
	var InitByUserGrp = new Ext.form.Radio({
		name : 'InitIndsMode',
		boxLabel : 'רҵ��',
		inputValue : 0,
		anchor : '90%',
		listeners : {
			'check':function(b){
				if (b.getValue()==1){
					Ext.getCmp('InitUserGrp').setDisabled(false);
				}else{
					Ext.getCmp('InitUserGrp').setValue('');
					Ext.getCmp('InitUserGrp').setDisabled(true);
				}
			}
		}
	});
	
	var InitByUser = new Ext.form.Radio({
		name:'InitIndsMode',
		boxLabel:'����&nbsp;&nbsp;&nbsp;',
		inputValue:1,
		listeners:{
			'check':function(b){
				if (b.getValue()==1){
					Ext.getCmp('InitUser').setDisabled(false);
					Ext.getCmp('InitUser').getStore().load();	
				}else{
					Ext.getCmp('InitUser').setValue('');
					Ext.getCmp('InitUser').setDisabled(true);
				}			
			}
		}
	});
	
	var InitIndsMode = new Ext.form.RadioGroup({
		fieldLabel : '���ŷ�ʽ',
		items : [InitByUser, InitByUserGrp]
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
		text : '�����Ƶ�',
		iconCls : 'page_save',
		handler : function(){
			SaveByInitIn();
		}
	});
	
	function SaveByInitIn(){
		var MasterSel = InitMasterGrid.getSelected();
		if(Ext.isEmpty(MasterSel)){
			Msg.info('warning', '��ѡ���ѽ��յĿ��ת�Ƶ�!');
			return false;
		}
		var indsScg = MasterSel.get('scg');
		var indsComp = 'N';
		var indsState = 'N';
		var indsReason = '';
		var remark = '';
		var dispMode = DispByInitForm.getForm().findField('InitIndsMode').getGroupValue();
		if(Ext.isEmpty(dispMode)){
			Msg.info('warning', '��ѡ�񷢷ŷ�ʽ!');
			return false;
		}
	    var InitUser = Ext.getCmp('InitUser').getValue();
	    var InitUserGrp = Ext.getCmp('InitUserGrp').getValue();
	    if(InitByUserGrp.getValue()==true && InitUserGrp==''){
	    	Msg.info('warning','��ѡ��רҵ��!');
	    	return;
	    }
		if(InitByUser.getValue()==true && InitUser==''){
			Msg.info('warning','��ѡ��������!');
			return;
		}
		var mainData = subLoc+'^'+gUserId+'^'+indsReason+'^'+indsScg+'^'+App_StkTypeCode
			+'^^'+indsComp+'^'+indsState+'^'+remark+'^'+InitUserGrp
			+'^'+InitUser+'^'+dispMode+'^^'+toLoc;

		//��ϸ����
		var detailData = '';
		var DetailSelections = InitDetailGrid.getSelections();
		for(var i = 0, len = DetailSelections.length; i < len; i++){
			var rowData = DetailSelections[i];
			var indsitm = '';
			var inclb = rowData.get('inclb');
			var qty = rowData.get('DispQty');
			var uom = rowData.get('uom');
			var rp = rowData.get('rp');
			var sp = rowData.get('sp');
			var rpAmt = rowData.get('rpAmt');
			var spAmt = rowData.get('rpAmt');
			var Indsrqi = '';
			var IndsiRemarks = '';
			var data = indsitm +'^'+ inclb +'^'+ qty +'^' +uom+'^'+rp
				+'^'+sp+'^'+rpAmt+'^'+spAmt+'^'+Indsrqi+'^'+IndsiRemarks;
			if(detailData != ''){
				detailData = detailData + xRowDelim() + data;
			}else{
				detailData = data;
			}
		}
		if(Ext.isEmpty(detailData)){
			Msg.info('warning', 'û����Ҫ�������ϸ!');
			return false;
		}
		Ext.Ajax.request({
			url:'dhcstm.indispaction.csp?actiontype=SaveDisp',
			params:{inds:'', mainData:mainData, detailData:detailData},
			success:function(result,request){
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true') {
					Msg.info("success","����ɹ�!");
					mainRowId=jsonData.info;
					Fn(mainRowId);
					if (INDispByInitInWin){
						INDispByInitInWin.close();
					}
				}else{
					Msg.info("error","����ʧ��:"+jsonData.info);
				}
			},
			failure:function(){
				Msg.info("failure","����ʧ��!");
			}
		});
	}
	
	var InitCloseBtn = new Ext.Button({
		text : '�ر�',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function(){
			INDispByInitInWin.close();
		}
	});
	
	var DispByInitForm = new Ext.ux.FormPanel({
		labelWidth : 60,
		tbar:[InitSearchBtn, '-', SaveByInitBtn, '-', InitCloseBtn],
		layout : 'column',
		items : [{
				columnWidth : 0.6,
				xtype : 'fieldset',
				title : '��ѯ����',
				autoHeight : true,
				items : [{
					layout : 'column',
					items : [	
						{columnWidth:.5,layout:'form',items:[InitStartDate, InitEndDate]},
						{columnWidth:.5,layout:'form',items:[SupplyPhaLoc]}
					]
				}]
			},{
				columnWidth : 0.4,
				xtype : 'fieldset',
				title : '����ѡ��',
				labelWidth : 80,
				autoHeight : true,
				layout : 'column',
				items : [{
					columnWidth : 0.8,
					layout : 'form',
					items : [{
						fieldLabel : '���ŷ�ʽ',
						layout : 'column',
						items : [{columnWidth:0.3,layout:'fit',items:InitByUser},
							{columnWidth:0.7,layout:'fit',items:InitUser}]
					}, {
						fieldLabel : ' ',
						layout : 'column',
						items : [{columnWidth:0.3,layout:'fit',items:InitByUserGrp},
							{columnWidth:0.7,layout:'fit',items:InitUserGrp}]
					}]
				}
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
		var UserScgPar = subLoc + '%' + gUserId;
		var ParamStr = startDate+'^'+endDate+'^'+supplyphaLoc+'^'+subLoc+'^'
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
			header : '��������',
			dataIndex : 'DispQty',
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
		height : gGridHeight,
		editable : true,
		contentColumns : InitDetailCm,
		smType : 'checkbox',
		singleSelect : false,
		selectFirst : false,
		autoLoadStore : false,
		actionUrl : DictUrl + 'dhcinistrfaction.csp',
		queryAction : 'InitToLocDetail',
		idProperty : 'initi',
		showTBar : false,
		paging : false
	});
	InitDetailGrid.getSelectionModel().on('beforerowselect', function(sm,rowIndex,keepExisting,rec){
		var qty = Number(rec.get('qty'));
		var avaQty = Number(rec.get('inclbAvaQty'));
		var DispQty = Math.min(qty, avaQty);
		if(DispQty <= 0){
			Msg.info('warning', '������������!');
			return false;
		}
	});
	InitDetailGrid.getSelectionModel().on('rowselect', function(sm,index,rec){
		var qty = Number(rec.get('qty'));
		var avaQty = Number(rec.get('inclbAvaQty'));
		var DispQty = Math.min(qty, avaQty);
		rec.set('DispQty',DispQty);
	});
	InitDetailGrid.getSelectionModel().on('rowdeselect', function(sm,ind,rec){	
		rec.set('DispQty','');
	});
	
	var INDispByInitInWin = new Ext.Window({
		title : '�ѽ��յĿ��ת�Ƶ�',
		width : gWinWidth,
		height : gWinHeight,
		layout : 'border',
		plain : true,
		modal : true,
		buttonAlign : 'center',
		items : [DispByInitForm, InitMasterGrid, InitDetailGrid]
	});

	INDispByInitInWin.show();
}
