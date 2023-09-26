
/**
 * 根据转移接收的单子,进行科室内消耗的发放
 * @param {} subLoc
 * @param {} toLoc 添加接受科室
 * @param {} Fn
 */
function LoadInitIn(subLoc,toLoc, Fn){
	var gUserId = session['LOGON.USERID'];
	
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '供给部门',
		id : 'SupplyPhaLoc',
		anchor : '90%',
		emptyText : '供给部门...',
		defaultLoc : {}
	});
	
	var InitStartDate = new Ext.ux.DateField({
		fieldLabel : '起始日期',
		id : 'InitStartDate',
		anchor : '90%',
		value : new Date().add(Date.DAY, -7)
	});

	var InitEndDate = new Ext.ux.DateField({
		fieldLabel : '截止日期',
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
		boxLabel : '专业组',
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
		boxLabel:'个人&nbsp;&nbsp;&nbsp;',
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
		fieldLabel : '发放方式',
		items : [InitByUser, InitByUserGrp]
	});
	
	var InitSearchBtn = new Ext.Button({
		text : '查询',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function(){
			InitMasterGrid.load();
		}
	});
	
	var SaveByInitBtn = new Ext.ux.Button({
		text : '发放制单',
		iconCls : 'page_save',
		handler : function(){
			SaveByInitIn();
		}
	});
	
	function SaveByInitIn(){
		var MasterSel = InitMasterGrid.getSelected();
		if(Ext.isEmpty(MasterSel)){
			Msg.info('warning', '请选择已接收的库存转移单!');
			return false;
		}
		var indsScg = MasterSel.get('scg');
		var indsComp = 'N';
		var indsState = 'N';
		var indsReason = '';
		var remark = '';
		var dispMode = DispByInitForm.getForm().findField('InitIndsMode').getGroupValue();
		if(Ext.isEmpty(dispMode)){
			Msg.info('warning', '请选择发放方式!');
			return false;
		}
	    var InitUser = Ext.getCmp('InitUser').getValue();
	    var InitUserGrp = Ext.getCmp('InitUserGrp').getValue();
	    if(InitByUserGrp.getValue()==true && InitUserGrp==''){
	    	Msg.info('warning','请选择专业组!');
	    	return;
	    }
		if(InitByUser.getValue()==true && InitUser==''){
			Msg.info('warning','请选择领用人!');
			return;
		}
		var mainData = subLoc+'^'+gUserId+'^'+indsReason+'^'+indsScg+'^'+App_StkTypeCode
			+'^^'+indsComp+'^'+indsState+'^'+remark+'^'+InitUserGrp
			+'^'+InitUser+'^'+dispMode+'^^'+toLoc;

		//明细数据
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
			Msg.info('warning', '没有需要保存的明细!');
			return false;
		}
		Ext.Ajax.request({
			url:'dhcstm.indispaction.csp?actiontype=SaveDisp',
			params:{inds:'', mainData:mainData, detailData:detailData},
			success:function(result,request){
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true') {
					Msg.info("success","保存成功!");
					mainRowId=jsonData.info;
					Fn(mainRowId);
					if (INDispByInitInWin){
						INDispByInitInWin.close();
					}
				}else{
					Msg.info("error","保存失败:"+jsonData.info);
				}
			},
			failure:function(){
				Msg.info("failure","保存失败!");
			}
		});
	}
	
	var InitCloseBtn = new Ext.Button({
		text : '关闭',
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
				title : '查询条件',
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
				title : '发放选项',
				labelWidth : 80,
				autoHeight : true,
				layout : 'column',
				items : [{
					columnWidth : 0.8,
					layout : 'form',
					items : [{
						fieldLabel : '发放方式',
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
				header : '转移单号',
				dataIndex : 'initNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '供给部门',
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '类组id',
				dataIndex : 'scg',
				width :60,
				align : 'center',
				hidden : true
			}, {
				header : '类组',
				dataIndex : 'scgDesc',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : '转移日期',
				dataIndex : 'dd',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : '单据状态',
				dataIndex : 'StatusCode',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '制单人',
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : '入库确认日期',
				dataIndex : 'inAckDate',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : '入库确认时间',
				dataIndex : 'inAckTime',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : '入库确认人',
				dataIndex : 'inAckUser',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '进价金额',
				dataIndex : 'RpAmt',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : '售价金额',
				dataIndex : 'SpAmt',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : '进销差价',
				dataIndex : 'MarginAmt',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : '备注',
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
			Msg.info('warning', '起始日期不可为空!');
		}else{
			startDate = startDate.format(ARG_DATEFORMAT).toString();
		}
		var endDate = Ext.getCmp('InitEndDate').getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '截止日期不可为空!');
		}else{
			endDate = endDate.format(ARG_DATEFORMAT).toString();
		}
		var statue =  '31';		//仅统计已接收的单据
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
			header : '转移细项RowId',
			dataIndex : 'initi',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '物资Id',
			dataIndex : 'inci',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '物资代码',
			dataIndex : 'inciCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '物资名称',
			dataIndex : 'inciDesc',
			width : 180,
			align : 'left',
			sortable : true
		}, {
			header : '规格',
			dataIndex : 'spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : '批次Id',
			dataIndex : 'inclb',
			width : 180,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '批次/效期',
			dataIndex : 'batexp',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			header : '转移数量',
			dataIndex : 'qty',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '单位id',
			dataIndex : 'uom',
			width : 60,
			align : 'left',
			hidden : 'true'
		}, {
			header : '单位',
			dataIndex : 'TrUomDesc',
			width : 60,
			align : 'left',
			sortable : true
		}, {
			header : '进价',
			dataIndex : 'rp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '售价',
			dataIndex : 'sp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '发放数量',
			dataIndex : 'DispQty',
			width : 60,
			align : 'right',
			editor : new Ext.form.TextField()
		}, {
			header : '批次可用数量',
			dataIndex : 'inclbAvaQty',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : '进价金额',
			dataIndex : 'rpAmt',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '售价金额',
			dataIndex : 'spAmt',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : '生产厂商',
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
			Msg.info('warning', '可用数量不足!');
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
		title : '已接收的库存转移单',
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
