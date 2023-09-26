// /名称: 出库单查询
// /描述: 出库单查询
// /编写者：zhangdongmei
// /编写日期: 2012.07.24

Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
    var gGroupId=session['LOGON.GROUPID'];
    var gLocId=session['LOGON.CTLOCID'];
    var gInciRowId="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	ChartInfoAddFun();
	
	function ChartInfoAddFun() {
		// 请求部门
		var RequestPhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '请求部门',
			id : 'RequestPhaLoc',
			anchor:'90%',
			emptyText : '请求部门...',
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
	
		// 供给部门
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '供给部门',
			id : 'SupplyPhaLoc',
			anchor:'90%',
			emptyText : '供给部门...',
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

		// 起始日期
		var StartDate = new Ext.ux.DateField({
			fieldLabel : '起始日期',
			id : 'StartDate',
			anchor : '90%',
			value : DefaultStDate()
		});
		
		// 截止日期
		var EndDate = new Ext.ux.DateField({
			fieldLabel : '截止日期',
			id : 'EndDate',
			anchor : '90%',
			value : DefaultEdDate()
		});
		
		var DateType = new Ext.form.RadioGroup({
			id:'DateType',
			fieldLabel: '查询日期',
			columns: 2,
			anchor: '90%',
			items: [
				{boxLabel: '制单日期', name: 'radio', inputValue: '1', checked: true},
				{boxLabel: '审核日期', name: 'radio', inputValue: '2'}
			]
		});
		
		var FindTypeData=[['全部','1'],['已确认','2'],['未确认','3']];
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
			fieldLabel : '是否确认',
			triggerAction:'all',
			valueField : 'typeid'
		});
		Ext.getCmp("ConfirmFlag").setValue("1");
		
		var PrintTypeData=[['全部','1'],['已打印','2'],['未打印','3']];
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
			fieldLabel : '是否打印',
			triggerAction:'all',
			valueField : 'typeid'
		});
		Ext.getCmp("PrintFlag").setValue("1");
		
		var StatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['10', '未完成'], ['11', '已完成'],
					['20', '出库审核不通过'],['21', '出库审核通过'],['30', '拒绝接收'],['31', '已接收'],
					['10,11,20,30', '存在占用']]
		});
		
		var Status = new Ext.form.ComboBox({
			fieldLabel : '转移单状态',
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
				
		// 物资类组
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:gLocId,
			UserId:userId,
			anchor:'90%'
		}); 
		
		// 物资名称
		var InciDesc = new Ext.form.TextField({
			fieldLabel : '物资名称',
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
			gInciRowId=inciDr;
		}
		
		var CreateUser = new Ext.ux.ComboBox({
			id : 'CreateUser',
			fieldLabel : '制单人',
			store : UStore,
			params : {locId : 'SupplyPhaLoc'},
			filterName : 'name'
		});
		
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '点击查询',
			width : 70,
			height : 30,
			iconCls : 'page_find',
			handler : function() {
				Query();
			}
		});
		/**
		 * 查询方法
		 */
		function Query() {
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			if (supplyphaLoc == null || supplyphaLoc.length <= 0) {
				Msg.info("warning", "请选择供应部门!");
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
						Msg.info("error","查询有误, 请查看日志!");
					}
				}
			});
		}

		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
			text : '清空',
			tooltip : '点击清空',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				clearData();
			}
		});
		/**
		 * 清空方法
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
		
		// 打印按钮
		var PrintBT = new Ext.Toolbar.Button({
			text : '打印',
			tooltip : '点击打印',
			width : 70,
			height : 30,
			iconCls : 'page_print',
			handler : function() {
				var rowData=MasterGrid.getSelectionModel().getSelected();
				if (rowData ==null) {
					Msg.info("warning", "请选择需要打印的转移单!");
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
		
		// 打印按钮
		var PrintHVCol = new Ext.Toolbar.Button({
			text : '高值汇总打印',
			tooltip : '打印高值转移单票据',
			width : 70,
			height : 30,
			iconCls : 'page_print',
			handler : function() {
				var rowData=MasterGrid.getSelectionModel().getSelected();
				if (rowData ==null) {
					Msg.info("warning", "请选择需要打印的转移单!");
					return;
				}
				var init = rowData.get("init");
				var HVflag=GetCertDocHVFlag(init,"T");
				if (HVflag=="Y"){
					PrintInIsTrfHVCol(init);
				}else{
					Msg.info("warning","非高值单据使用打印按钮即可!");
					return;
				}
			}
		});
		
		// 库房确认按钮
		var ConfirmBT = new Ext.Toolbar.Button({
			text : '库房确认',
			tooltip : '点击确认',
			width : 70,
			height : 30,
			iconCls : 'page_find',
			handler : function() {
				Confirm();
			}
		});
		/**
		 * 库房确认方法
		 */
		function Confirm() {
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData == null) {
				Msg.info("warning", "请选择确认的转移单!");
				return;
			}
			var ConfirmFlag = rowData.get("confirmFlag");
			if (ConfirmFlag == "Y") {
				Msg.info("warning", "转移单已确认!");
				return;
			}
			var Init = rowData.get("init");
			var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=Confirm&Rowid="+ Init;
			Ext.Ajax.request({
				url : url,
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "库房确认成功!");
						Query();
					} else {
						var Ret=jsonData.info;
						if(Ret<0){
							Msg.info("error", "确认失败:"+Ret);
						}
					}
				},
				scope : this
			});
		}
		var printBarCode = new Ext.Toolbar.Button({
			text: '打印条码',
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
		 * 库房确认按钮是否可用
		 */
		function changeButtonEnable() {
		/*	if(userId==?||gGroupId==?||gLocId==?){	//根据人员或安全组或科室来决定是否可用
				ConfirmBT.setDisabled(false);
			}else{
				ConfirmBT.setDisabled(true);
			}*/
		}
		// 访问路径
		var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName",
		"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode","confirmFlag","OperType"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "init",
					fields : fields
				});
		// 数据集
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
				header : "转移单号",
				dataIndex : 'initNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : '请求单号',
				dataIndex : 'reqNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "请求部门",
				dataIndex : 'toLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "供给部门",
				dataIndex : 'frLocDesc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "转移日期",
				dataIndex : 'dd',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : "单据状态",
				dataIndex : 'StatusCode',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "制单人",
				dataIndex : 'userName',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "进价金额",
				dataIndex : 'RpAmt',
				width : 80,
				align : 'right',
				summaryType : 'sum',
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'SpAmt',
				width : 80,
				align : 'right',
				summaryType : 'sum',
				sortable : true
			}, {
				header : "进销差价",
				dataIndex : 'MarginAmt',
				width : 80,
				align : 'right',
				
				sortable : true
			}, {
				header : "备注",
				dataIndex : 'Remark',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "出库类型",
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
			title: '出库单',
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

		// 添加表格单击行事件
		MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var InIt = MasterStore.getAt(rowIndex).get("init");
			DetailStore.setBaseParam('Parref',InIt);
			DetailStore.removeAll();
			DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
		});

		// 转移明细
		// 访问路径
		var DetailUrl =  DictUrl
					+ 'dhcinistrfaction.csp?actiontype=QueryDetail';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["initi", "inrqi", "inci","inciCode",
				"inciDesc", "inclb", "batexp", "manf","manfName",
				 "qty", "uom", "sp","status","remark",
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin",
				"pp", "spec","newSp", "HVBarCode",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc","SterilizedBat","inclbbarcode"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "initi",
			fields : fields
		});
		// 数据集
		var DetailStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader
		});
		var print = new Ext.grid.CheckColumn({
			header:'打印/条码',
			dataIndex:'print',
			width : 70,
			sortable:true
		});
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "转移细项RowId",
				dataIndex : 'initi',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "物资Id",
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
				header : '高值条码',
				dataIndex : 'HVBarCode',
				width : 120,
				align : 'left'
			}, {
				header : "批次Id",
				dataIndex : 'inclb',
				width : 180,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "批次/效期",
				dataIndex : 'batexp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "生产厂商",
				dataIndex : 'manfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "批次库存",
				dataIndex : 'inclbQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "转移数量",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "转移单位",
				dataIndex : 'TrUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "进价",
				dataIndex : 'rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "请求数量",
				dataIndex : 'reqQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "货位码",
				dataIndex : 'stkbin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "请求方库存",
				dataIndex : 'reqLocStkQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "占用数量",
				dataIndex : 'inclbDirtyQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "可用数量",
				dataIndex : 'inclbAvaQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "批次售价",
				dataIndex : 'newSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'spec',
				width : 100,
				align : 'left',
				sortable : true
			},/*{
				header : "通用名",
				dataIndex : 'gene',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "剂型",
				dataIndex : 'form',
				width : 100,
				align : 'left',
				sortable : true
			},*/ {
				header : "售价金额",
				dataIndex : 'spAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "进价金额",
				dataIndex : 'rpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "灭菌批号",
				dataIndex : 'SterilizedBat',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "备注",
				dataIndex : 'remark',
				width : 100,
				align : 'right',
				sortable : true
			},print, {
				header : "批次条码",
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
			title: '出库单明细',
			cm : DetailCm,
			store : DetailStore,
			trackMouseOver : true,
			stripeRows : true,
			bbar:GridDetailPagingToolbar,
			plugins : [print],
			loadMask : true
		});

		var HisListTab = new Ext.ux.FormPanel({
			title:"出库单查询",
			tbar : [SearchBT, '-', ClearBT, '-', PrintBT, '-', PrintHVCol,'-', ConfirmBT,'-', printBarCode],
			layout: 'fit',
			items:[{
				xtype:'fieldset',
				layout:'column',
				style:'padding:5px 0px 0px 0px',
				defaults:{border:false, layout:'form'},
				title:'查询条件',
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

		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, MasterGrid, DetailGrid],
			renderTo : 'mainPanel'
		});
		changeButtonEnable();
	}
})