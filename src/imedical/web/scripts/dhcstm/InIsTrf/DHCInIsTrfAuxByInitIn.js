// /名称: 根据已接收转移单出库
// /编写者：wangjiabin
// /编写日期: 2016.07.27

	var gUserId = session['LOGON.USERID'];
	
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'PhaLoc',
		anchor : '90%',
		emptyText : '科室...',
		listWidth : 250,
		groupId : session['LOGON.GROUPID']
	});
	
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '供给部门',
		id : 'SupplyPhaLoc',
		anchor : '90%',
		emptyText : '供给部门...',
		defaultLoc : {}
		,width : 150
	});
	
	var InitStartDate = new Ext.ux.DateField({
		fieldLabel : '起始日期',
		id : 'InitStartDate',
		anchor : '90%',
		value : DefaultStDate()
	});

	var InitEndDate = new Ext.ux.DateField({
		fieldLabel : '截止日期',
		id : 'InitEndDate',
		anchor : '90%',
		value : DefaultEdDate()
	});

	var RequestPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '请求部门',
		id : 'RequestPhaLoc',
		anchor : '90%',
		emptyText : '请求部门...',
		listWidth : 250,
		defaultLoc:''
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
		text : '保存',
		iconCls : 'page_save',
		handler : function(){
			SaveByInitIn();
		}
	});
	
	function SaveByInitIn(){
		var record = InitMasterGrid.getSelected();
		if(Ext.isEmpty(record)){
			Msg.info('warning', '请选择已接收的库存转移单!');
			return false;
		}
		var supplyPhaLoc = record.get('toLoc');
		var requestPhaLoc = Ext.getCmp('RequestPhaLoc').getValue();
		if(Ext.isEmpty(requestPhaLoc)){
			Msg.info("warning", "请选择请求科室!");
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

		//明细id^批次id^数量^单位^请求明细id^备注
		var ListDetail = "";
		var DetailSelections = InitDetailGrid.getSelections();
		for(var i = 0, len = DetailSelections.length; i < len; i++){
			var rowData = DetailSelections[i];
			var Initi = '';
			var inclb = rowData.get('inclb');
			var qty = rowData.get('OperQty');
			
			if((qty<0)||(qty==0)||(qty=="")||(qty=="defined")){
				desc=rowData.get('inciDesc');
				Msg.info("warning","请正确填写"+desc+"的数量");
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
			Msg.info('warning', '请勾选所需要保存的明细!');
			return false;
		}
		Ext.Ajax.request({
			url : DictUrl + "dhcinistrfaction.csp?actiontype=Save",
			params : {Rowid:'', MainInfo:MainInfo, ListDetail:ListDetail},
			method : 'POST',
			waitMsg : '处理中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					// 刷新界面
					var InitRowid = jsonData.info;
					Msg.info("success", "保存成功!");
					// 跳转到出库制单界面
					var HVInIsTrfFlag = false;
					if(HVInIsTrfFlag){
						window.location.href='dhcstm.dhcinistrfhv.csp?Rowid='+InitRowid+'&QueryFlag=1';
					}else{
						window.location.href='dhcstm.dhcinistrf.csp?Rowid='+InitRowid+'&QueryFlag=1';
					}
				} else {
					var ret=jsonData.info;
					if(ret==-99){
						Msg.info("error", "加锁失败,不能保存!");
					}else if(ret==-2){
						Msg.info("error", "生成出库单号失败,不能保存!");
					}else if(ret==-1){
						Msg.info("error", "保存出库单失败!");
					}else if(ret==-5){
						Msg.info("error", "保存出库单明细失败!");
					}else {
						Msg.info("error", "部分明细保存不成功："+ret);
					}
				}
			},
			scope : this
		});			
	}
	
	var InitClearBtn = new Ext.Button({
		text : '清空',
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
		title : '库存转移(依据已接收转移单)',
		labelWidth : 100,
		tbar : [InitSearchBtn, '-', SaveByInitBtn, '-', InitClearBtn],
		layout : 'column',
		bodyStyle : 'padding:5px 0 0 0',
		items : [{
				columnWidth : 0.65,
				xtype : 'fieldset',
				title : '查询条件',
				layout : 'column',
				defaults : {xtype : 'fieldset', border : false},
				items : [
						{columnWidth:.4,items:[PhaLoc, SupplyPhaLoc]},
						{columnWidth:.5,items:[InitStartDate, InitEndDate]}
				]
			},{
				columnWidth : 0.35,
				xtype : 'fieldset',
				title : '出库选项',
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
				header : '接收科室rowid',
				dataIndex : 'toLoc',
				width : 60,
				hidden : true
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
		var PhaLoc = Ext.getCmp('PhaLoc').getValue();
		if(Ext.isEmpty(PhaLoc)){
			Msg.info('warning', '科室不可为空!');
			return false;
		}
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
			header : '业务数量',
			dataIndex : 'OperQty',
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
			Msg.info('warning', '可用数量不足!');
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
		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [DispByInitForm, InitMasterGrid, InitDetailGrid]
		});
	});