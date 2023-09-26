// /名称: 订单查询
// /描述: 订单查询
// /编写者：zhangdongmei
// /编写日期: 2012.10.08
Ext.onReady(function() {

	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId = session['LOGON.USERID'];
	var gLocId=session['LOGON.CTLOCID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//获取参数，并初始化数据 STATR
	Ext.getUrlParam = function(param) {
		var params = Ext.urlDecode(location.search.substring(1));
		return param ? params[param] : params;
	};
	UsrFlag = Ext.getUrlParam('UsrFlag');

	//订购科室
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		width:120,
		groupId:gGroupId,
		emptyText : '订购科室...',
		childCombo : 'apcVendorField'
	});
	// 物资类组
	var StkGrpType=new Ext.ux.StkGrpComboBox({
		id : 'StkGrpType',
		name : 'StkGrpType',
		StkType:App_StkTypeCode,     //标识类组类型
		LocId:gLocId,
		UserId:userId,
		anchor:'90%',
		width : 120
	});
	// 请求部门
	var RequestPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '请求部门',
		id : 'RequestPhaLoc',
		name : 'RequestPhaLoc',
		anchor:'90%',
		width : 120,
		emptyText : '请求部门...',
		defaultLoc:{}
	});
	// 起始日期
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '起始日期',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		width : 120,
		value : new Date().add(Date.DAY, - 7)
	});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '截止日期',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		width : 120,
		value : new Date()
	});
	var inpoNoField = new Ext.form.TextField({
		id:'inpoNoField',
		fieldLabel:'订单号',
		allowBlank:true,
		emptyText:'订单号...',
		anchor:'90%',
		selectOnFocus:true
	});

	// 物资名称
	var InciDesc = new Ext.form.TextField({
		fieldLabel : '物资名称',
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
		fieldLabel : '物资名称',
		id : 'IncId',
		name : 'IncId',
		hidden:true
	});

		/**
	 * 调用物资窗体并返回结果
	 */
	function GetPhaOrderInfo(item, stktype) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
		}
	}

	/**
	 * 返回方法
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
		boxLabel : '未入库',
		hideLabel : true,
		id : 'NotImp',
		name : 'NotImp',
		anchor : '90%',
		checked : true
	});
	var PartlyImp = new Ext.form.Checkbox({
		boxLabel : '部分入库',
		hideLabel : true,
		id : 'PartlyImp',
		name : 'PartlyImp',
		anchor : '90%',
		checked : true
	});

	var AllImp = new Ext.form.Checkbox({
		boxLabel : '全部入库',
		hideLabel : true,
		id : 'AllImp',
		name : 'AllImp',
		anchor : '90%',
		checked : true
	});
	if (UsrFlag==1){
		var apcVendorField = new Ext.ux.UsrVendorComboBox({
			fieldLabel : '供应商',
			id : 'apcVendorField',
			name : 'apcVendorField',
			anchor : '90%',
			userId :gUserId,
			emptyText : '供应商...'
		});
	}else{
		// 供应商
		var apcVendorField=new Ext.ux.VendorComboBox({
			id : 'apcVendorField',
			name : 'apcVendorField',
			anchor:'90%',
			params : {LocId : 'PhaLoc'}
		});
	}
	var includeDefLoc=new Ext.form.Checkbox({
		id: 'defLocPP',
		boxLabel : '包含支配科室',
		hideLabel : true,
		anchor:'90%',
		checked:true,
		allowBlank:true
	});
	var SmsFlag = new Ext.form.Checkbox({
		boxLabel : '未发短信',
		hideLabel : true,
		id : 'SmsFlag',
		name : 'SmsFlag',
		anchor : '90%'
	});

	var PlatFlag = new Ext.form.Checkbox({
		boxLabel : '未上传平台',
		hideLabel : true,
		id : 'PlatFlag',
		name : 'PlatFlag',
		anchor : '90%',
		checked : true
	});
	// 查询订单按钮
	var SearchBT = new Ext.Toolbar.Button({
		id : "SearchBT",
		text : '查询',
		tooltip : '点击查询订单',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});

	var SaveMainBT = new Ext.Toolbar.Button({
		id : "SaveMainBT",
		text : '另存',
		width : 70,
		height : 30,
		iconCls : 'page_excel',
		handler : function() {
			ExportAllToExcel(MasterGrid,new Date().format(ARG_DATEFORMAT));
		}
	});
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '清空',
		tooltip : '点击清空',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearData();
		}
	});
	// 发送短信
	var SmsBT = new Ext.Toolbar.Button({
		id : "SmsBT",
		text : '发送短信',
		tooltip : '发送短信',
		width : 70,
		height : 30,
		iconCls : 'page_goto',
		handler : function() {
			var recarr=MasterGrid.getSelectionModel().getSelections();
			var count=recarr.length;
			if(count==0){Msg.info("warning","请选择!");return};
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
				waitMsg : '处理中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
					var ret=jsonData.info;
					var arr=ret.split("^");
					var commitno=parseInt(arr[0]);
					var successno=parseInt(arr[1]);
					var defaultno=commitno-successno;
					if(commitno==successno){
						Msg.info("success","发送成功!");
					}else{
						Msg.info("warning","共"+commitno+"条数据  "+"成功"+successno+"数据  "+"失败"+defaultno+"数据");
					}
					MasterStore.reload();
					}
				},
				scope : this
			});
		}
	});
	// 发送短信
	var PurBT = new Ext.Toolbar.Button({
		id : "PurBT",
		text : '采购平台',
		tooltip : '采购平台',
		width : 70,
		height : 30,
		iconCls : 'page_uploadyun',
		handler : function() {
			Msg.info("warning", "处理中!");
		}
	});
	// 拒绝按钮
	var DeniedBT = new Ext.Toolbar.Button({
		id : "DeniedBT",
		text : '撤销一条',
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
			Msg.info("warning", "请选择要拒绝的明细!");
			return;
		}
		var count=rowDataarr.length;
		if (count!=1){
			Msg.info("warning", "请选择一条要拒绝的明细!");
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
			waitMsg : '查询中...',
			params: {RowIdStr:inppistr},
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					var Ret=jsonData.info;
					if(Ret==0){
						Msg.info("success", "撤销成功!");
						MasterStore.reload();
					}
					if(Ret==-1){
						Msg.info("error","单据已经入库 不能撤销!");
					}else if(Ret==-2){
						Msg.info("error", "已撤销,不能重复撤销!");
					}
				}
			},
			scope : this
		});
	}
	/**
	 * 清空方法
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

	// 显示订单数据
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", "请选择订购部门!");
			return;
		}
		var reqloc=Ext.getCmp("RequestPhaLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		if(Ext.isEmpty(startDate)){
			Msg.info('warning', '起始日期不可为空');
			return false;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		var endDate = Ext.getCmp("EndDate").getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '截止日期不可为空');
			return false;
		}
		endDate = endDate.format(ARG_DATEFORMAT);
		var notimp = (Ext.getCmp("NotImp").getValue()==true?0:'');
		var partlyimp = (Ext.getCmp("PartlyImp").getValue()==true?1:'');
		var allimp = (Ext.getCmp("AllImp").getValue()==true?2:'');
		var Vendor = Ext.getCmp("apcVendorField").getValue();
		var PoNo = Ext.getCmp('inpoNoField').getValue();
		var Status=notimp+','+partlyimp+','+allimp;
		var includeDefLoc=(Ext.getCmp('defLocPP').getValue()==true?1:0);  //是否包含支配科室
		var SmsFlag=(Ext.getCmp("SmsFlag").getValue()==true?'N':'');
		var PlatFlag=(Ext.getCmp("PlatFlag").getValue()==true?'N':'');
		var inciDesc=Ext.getCmp("InciDesc").getValue();
		if (inciDesc==""){
			Ext.getCmp("IncId").setValue("");
		}
		var InciId=Ext.getCmp("IncId").getRawValue();
		var StkGrp=Ext.getCmp("StkGrpType").getValue();
		//开始日期^截止日期^订单号^供应商id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)
		//添加取消标志，如果N表示只查询未取消的
		var ListParam=startDate+'^'+endDate+'^'+PoNo+'^'+Vendor+'^'+phaLoc+'^Y^0^'+Status+'^'+InciId+'^'+includeDefLoc+"^"+SmsFlag+"^"+PlatFlag+"^"+reqloc+"^"+StkGrp+"^N";
		var Page=GridPagingToolbar.pageSize;
		MasterStore.removeAll();
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
	}

	function renderPoStatus(value){
		var PoStatus='';
		if(value==0){
			PoStatus='未入库';
		}else if(value==1){
			PoStatus='部分入库';
		}else if(value==2){
			PoStatus='全部入库';
		}
		return PoStatus;
	}
	// 访问路径
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=QueryAll';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","Email","ReqLocDesc",
				"PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "NotImpQty", "Rp","PurQty","ImpQty","Spec",
				"SMSSentFlag","PlatSentFlag","Mobile","SpecDesc","reqremark"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				fields : fields
			});
	// 数据集
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
			header : "订单号",
			dataIndex : 'PoNo',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "订购科室",
			dataIndex : 'PoLoc',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "申请科室",
			dataIndex : 'ReqLocDesc',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "供应商",
			dataIndex : 'Vendor',
			width : 120,
			align : 'left',
			sortable : true
		}, {
			header : "订单状态",
			dataIndex : 'PoStatus',
			width : 90,
			align : 'left',
			sortable : true,
			renderer:renderPoStatus
		}, {
			header : "订单日期",
			dataIndex : 'PoDate',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "供应商邮箱",
			dataIndex : 'Email',
			width : 120,
			align : 'left',
			sortable : true
		},{
			header : "订单明细id",
			dataIndex : 'PoItmId',
			width : 100,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "物资RowId",
			dataIndex : 'IncId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : '物资代码',
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : '物资名称',
			dataIndex : 'IncDesc',
			width : 230,
			align : 'left',
			sortable : true
		}, {
			header : '规格',
			dataIndex : 'Spec',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "单位",
			dataIndex : 'PurUom',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "进价",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true
		}, {
			header : "订购数量",
			dataIndex : 'PurQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "到货数量",
			dataIndex : 'ImpQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "未到货数量",
			dataIndex : 'NotImpQty',
			width : 80,
			align : 'right',
			sortable : true
		}, {
			header : "配送员手机号码",
			dataIndex : 'Mobile',
			width : 120,
			align : 'right',
			sortable : true
		}, {
			header : "详细规格",
			dataIndex : 'SpecDesc',
			width : 120,
			align : 'right',
			sortable : true
		},{
			header:"请求备注",
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
		title: '订单明细',
		id:'MasterGrid',
		cm : MasterCm,
		sm : sm1,
		store : MasterStore,
		bbar:GridPagingToolbar
	});

	var HisListTab = new Ext.ux.FormPanel({
		labelWidth : 60,
		title: '订单到货情况查询',
		tbar : [SearchBT,'-',ClearBT,'-',SaveMainBT,'-',SmsBT,'-',PurBT],		//2018-04-16 暂时注释,'-',DeniedBT
		items : [{
			xtype : 'fieldset',
			title : '查询信息',
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

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[HisListTab, MasterGrid]
	});
});