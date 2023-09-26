// /名称: 库存查询
// /描述: 库存查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.06
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId = '';
	var gStrParam = '';
	var gStrParamBatch = '';
	var gUserId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];
	var gGroupId = session['LOGON.GROUPID'];

	ChartInfoAddFun();

	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel: '科室',
				id: 'PhaLoc',
				name: 'PhaLoc',
				anchor: '90%',
				groupId: gGroupId,
				stkGrpId: 'StkGrpType',
				childCombo: 'PhManufacturer'
			});

		var DateTime = new Ext.ux.DateField({
				fieldLabel: '日期',
				id: 'DateTime',
				name: 'DateTime',
				anchor: '90%',

				value: new Date()
			});

		var StkGrpType = new Ext.ux.StkGrpComboBox({
				id: 'StkGrpType',
				name: 'StkGrpType',
				StkType: App_StkTypeCode, //标识类组类型
				anchor: '90%',
				LocId: gLocId,
				UserId: gUserId,
				childCombo: 'DHCStkCatGroup'
			});

		var Vendor = new Ext.ux.VendorComboBox({
				id: 'Vendor',
				name: 'Vendor',
				fieldLabel: "最新入库供应商"
			});

		var TypeStore = new Ext.data.SimpleStore({
				fields: ['RowId', 'Description'],
				data: [['0', '全部'], ['1', '库存为零'], ['2', '库存为正'],
					['3', '库存为负'], ['4', '库存非零']]
			});
		var Type = new Ext.form.ComboBox({
				fieldLabel: '类型',
				id: 'Type',
				name: 'Type',
				anchor: '90%',
				store: TypeStore,
				triggerAction: 'all',
				mode: 'local',
				valueField: 'RowId',
				displayField: 'Description',
				allowBlank: true,
				triggerAction: 'all',
				selectOnFocus: true,
				forceSelection: true,
				minChars: 1,
				editable: false,
				valueNotFoundText: ''
			});
		Ext.getCmp("Type").setValue("0");

		var InciDesc = new Ext.form.TextField({
				fieldLabel: '物资名称',
				id: 'InciDesc',
				name: 'InciDesc',
				anchor: '90%',
				width: 140,
				listeners: {
					specialkey: function (field, e) {
						var keyCode = e.getKey();
						if (keyCode == Ext.EventObject.ENTER) {
							var stkgrp = Ext.getCmp("StkGrpType").getValue();
							GetPhaOrderInfo(field.getValue(), stkgrp);
						}
					},
					change: function (field, newValue, oldValue) {
						gIncId = "";
					}
				}
			});
		var InciAlias = new Ext.form.TextField({
				fieldLabel: '物资别名',
				id: 'InciAlias',
				name: 'InciAlias',
				anchor: '90%',
				width: 140
			});

		/**
		 * 调用物资窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "", "0", "", getDrugList);
			}
		}

		/**
		 * 返回方法
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			gIncId = record.get("InciDr");
			var inciCode = record.get("InciCode");
			var inciDesc = record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(inciDesc);
			searchData();
		}

		var ImportStore = new Ext.data.SimpleStore({
				fields: ['RowId', 'Description'],
				data: [['国产', '国产'], ['进口', '进口'], ['合资', '合资']]
			});
		var INFOImportFlag = new Ext.form.ComboBox({
				fieldLabel: '进口标志',
				id: 'INFOImportFlag',
				name: 'INFOImportFlag',
				anchor: '90%',
				store: ImportStore,
				valueField: 'RowId',
				displayField: 'Description',
				mode: 'local',
				allowBlank: true,
				triggerAction: 'all',
				selectOnFocus: true,
				listWidth: 150,
				forceSelection: true
			});

		var DHCStkCatGroup = new Ext.ux.ComboBox({
				fieldLabel: '库存分类',
				id: 'DHCStkCatGroup',
				name: 'DHCStkCatGroup',
				store: StkCatStore,
				valueField: 'RowId',
				displayField: 'Description',
				params: {
					StkGrpId: 'StkGrpType'
				}
			});

		var ARCItemCat = new Ext.ux.ComboBox({
				fieldLabel: '医嘱子类',
				id: 'ARCItemCat',
				name: 'ARCItemCat',
				store: ArcItemCatStore,
				valueField: 'RowId',
				displayField: 'Description',
				filterName: 'Desc'
			});

		var PhManufacturer = new Ext.ux.ComboBox({
				fieldLabel: '厂商',
				id: 'PhManufacturer',
				name: 'PhManufacturer',
				store: PhManufacturerStore,
				valueField: 'RowId',
				displayField: 'Description',
				filterName: 'PHMNFName',
				params: {
					LocId: 'PhaLoc',
					ScgId: 'StkGrpType'
				}
			});

		var LocManGrp = new Ext.ux.ComboBox({
				fieldLabel: '管理组',
				id: 'LocManGrp',
				name: 'LocManGrp',
				anchor: '90%',
				store: LocManGrpStore,
				valueField: 'RowId',
				displayField: 'Description',
				params: {
					locId: 'PhaLoc'
				}
			});
		var StkBin = new Ext.ux.ComboBox({
			fieldLabel : '货位',
			id : 'StkBin',
			name : 'StkBin',
			anchor : '90%',
			width : 140,
			store : LocStkBinStore,
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			pageSize : 20,
			listWidth : 250,
			valueNotFoundText : '',
			enableKeyEvents : true,
			listeners : {
				'beforequery' : function(e) {
					this.store.removeAll();
					var phaLoc = Ext.getCmp("PhaLoc").getValue();
					LocStkBinStore.setBaseParam('LocId',phaLoc);
					LocStkBinStore.setBaseParam('Desc',Ext.getCmp('StkBin').getRawValue());
					LocStkBinStore.load({params:{start:0,limit:20}});
				}
			}
		});
			
		var PHCDOfficialType = new Ext.ux.ComboBox({
				fieldLabel: '医保类别',
				id: 'PHCDOfficialType',
				name: 'PHCDOfficialType',
				store: OfficeCodeStore,
				valueField: 'RowId',
				displayField: 'Description'
			});

		var Supervision = new Ext.form.ComboBox({
				fieldLabel: '监管级别',
				id: 'Supervision',
				store: SupervisionStore,
				valueField: 'RowId',
				displayField: 'Description',
				anchor: '90%',
				mode: 'local',
				triggerAction: 'all'
			});

		var ManageDrug = new Ext.form.Checkbox({
				boxLabel: '重点关注标志',
				id: 'ManageDrug',
				name: 'ManageDrug',
				anchor: '90%',
				checked: false
			});

		var UseFlag = new Ext.form.Checkbox({
				boxLabel: '仅在用品种',
				id: 'UseFlag',
				name: 'UseFlag',
				anchor: '90%',
				checked: false
			});

		var NotUseFlag = new Ext.form.Checkbox({
				boxLabel: '仅不可用品种',
				id: 'NotUseFlag',
				name: 'NotUseFlag',
				anchor: '90%',
				checked: false
			});

		var HvFlag = new Ext.form.Checkbox({
				boxLabel: '高值标志',
				id: 'HvFlag',
				name: 'HvFlag',
				anchor: '90%',
				checked: false
			});
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
				text: '查询',
				tooltip: '点击查询',
				iconCls: 'page_find',
				width: 70,
				height: 30,
				handler: function () {
					searchData();
				}
			});
	   //是否收费
		var M_ChargeFlagdata = [['全部','1'],['收费','2'],['不收费','3']];
		var M_ChargeFlagStore = new Ext.data.SimpleStore({
			fields : ['ChargeDesc','ChargeId'],
			data :  M_ChargeFlagdata
		});
		var M_ChargeFlag = new Ext.form.ComboBox({
		    fieldLabel : '是否收费',
		    mode: 'local',
		    id : 'M_ChargeFlag',
		    name : 'M_ChargeFlag',
		    anchor : '90%',
		    emptyText : '',
		    store : M_ChargeFlagStore,
		    displayField : 'ChargeDesc',
		    valueField : 'ChargeId',
		    triggerAction :'all'
		});
		Ext.getCmp("M_ChargeFlag").setValue("1");
/*var M_ChargeFlag = new Ext.form.RadioGroup({
		id : 'M_ChargeFlag',
		//anchor : '90%',
		items : [
			{boxLabel:'全部',name:'M_ChargeFlag',id:'onlySurplus',inputValue:'',checked:true},
			{boxLabel:'收费',name:'M_ChargeFlag',id:'onlyLoss',inputValue:'Y'},
			{boxLabel:'不收费',name:'M_ChargeFlag',id:'onlyBalance',inputValue:'N'}
		]
	});*/		
		/**
		 * 查询方法
		 */
		function searchData() {
			// 必选条件
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "科室不能为空！");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var date = Ext.getCmp("DateTime").getValue()
				var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var StockType = Ext.getCmp("Type").getValue();
			if (date == null || date.length <= 0) {
				Msg.info("warning", "日期不能为空！");
				Ext.getCmp("DateTime").focus();
				return;
			} else {
				date = date.format(ARG_DATEFORMAT).toString();
			}
			if (StockType == null || StockType.length <= 0) {
				Msg.info("warning", "类型不能为空！");
				Ext.getCmp("Type").focus();
				return;
			}

			// 可选条件
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var LocManGrp = Ext.getCmp("LocManGrp").getValue();
			var StkBin = Ext.getCmp("StkBin").getValue();
			var ARCItemCat = Ext.getCmp("ARCItemCat").getValue();
			var PhManufacturer = Ext.getCmp("PhManufacturer").getValue();
			var PHCDOfficialType = Ext.getCmp("PHCDOfficialType").getValue();
			var ManageDrug = (Ext.getCmp("ManageDrug").getValue() == true ? '1' : '');
			var UseFlag = (Ext.getCmp("UseFlag").getValue() == true ? 'Y' : 'N');
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue() == true ? 'Y' : 'N');
			var ImpFlag = Ext.getCmp("INFOImportFlag").getValue();
			var InciDesc = Ext.getCmp("InciDesc").getValue();
			var Vendor = Ext.getCmp("Vendor").getValue();
			var HvFlag = (Ext.getCmp("HvFlag").getValue() == true ? 'Y' : '');
			if (gIncId != "" & gIncId != null) {
				InciDesc = "";
			}
			var Supervision = Ext.getCmp('Supervision').getValue();
			var InciAlias = Ext.getCmp("InciAlias").getValue();
			var charge = Ext.getCmp("M_ChargeFlag").getValue();
			var strParam = phaLoc + "^" + date + "^" + StkGrpRowId + "^" + StockType + "^" + gIncId
				 + "^" + ImpFlag + "^" + DHCStkCatGroup + "^" + LocManGrp + "^" + "" + "^" + ""
				 + "^" + ARCItemCat + "^" + "" + "^" + PhManufacturer + "^" + PHCDOfficialType + "^" + ""
				 + "^" + ManageDrug + "^" + UseFlag + "^" + NotUseFlag + "^" + InciDesc + "^" + Vendor
				 + "^" + HvFlag + "^" + Supervision + "^" + InciAlias+"^"+charge+"^"+StkBin ;

			BatchGrid.store.removeAll();
			StockQtyStore.setBaseParam("Params", strParam);
			StockQtyStore.removeAll();
			var pageSize = StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({
				params: {
					start: 0,
					limit: pageSize
				},
				callback: function (r, options, success) {
					if (!success) {
						Msg.info("error", "查询有误, 请查看日志!");
						return;
					} else if (r.length > 0) {
						StockQtyGrid.getSelectionModel().selectFirstRow();
						StockQtyGrid.getView().focusRow(0);
					}
				}
			});
		}

		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
				text: '清空',
				tooltip: '点击清空',
				iconCls: 'page_clearscreen',
				width: 70,
				height: 30,
				handler: function () {
					clearData();
				}
			});

		/**
		 * 清空方法
		 */
		function clearData() {
			gStrParam = '';
			SetLogInDept(PhaLoc.getStore(), "PhaLoc");
			Ext.getCmp("StkGrpType").getStore().load();
			Ext.getCmp("Type").setValue('0');
			Ext.getCmp("DateTime").setValue(new Date());
			Ext.getCmp("InciDesc").setValue('');
			Ext.getCmp("InciAlias").setValue('');
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("ARCItemCat").setValue('');
			Ext.getCmp("PhManufacturer").setValue('');
			Ext.getCmp("PHCDOfficialType").setValue('');
			Ext.getCmp("ManageDrug").setValue(false);
			Ext.getCmp("UseFlag").setValue(false);
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("INFOImportFlag").setValue('');
			Ext.getCmp("HvFlag").setValue('');
			Ext.getCmp("Supervision").setValue('');
			Ext.getCmp("LocManGrp").setValue('');
			Ext.getCmp("StkBin").setValue('');
			Ext.getCmp("M_ChargeFlag").setValue("1");
			Ext.getCmp("Vendor").setValue('');
			gIncId = "";
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
			BatchGrid.store.removeAll();
		}

		var PrintBT = new Ext.Toolbar.Button({
				text: '打印',
				tooltip: '点击打印库存数据',
				iconCls: 'page_print',
				width: 70,
				height: 30,
				handler: function () {
					PrintStockData();
				}
			});

		function PrintStockData() {
			var tmpParam = StockQtyStore.lastOptions;
			var ParamStr = '';
			if (tmpParam || tmpParam.params) {
				tmpParam.params['sort'] = '';
				tmpParam.params['dir'] = '';
				for (var Param in tmpParam.params) {
					if (Param == 'start' || Param == 'limit') {
						continue;
					}
					if (ParamStr == '') {
						ParamStr = Param + '=' + tmpParam.params[Param];
					} else {
						ParamStr = ParamStr + ';' + Param + '=' + tmpParam.params[Param];
					}
				}
			}
			if (ParamStr == '') {
				return;
			}
			var RaqName = 'DHCSTM_LocItmStk_Common.raq';
			var FileName = '{' + RaqName + '(' + ParamStr + ')}';
			var transfileName = TranslateRQStr(FileName);
			DHCSTM_DHCCPM_RQPrint(transfileName);
		}

		function manFlagRender(value) {
			if (value == "1") {
				return '重点关注';
			} else {
				return '非重点关注';
			}
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.RowSelectionModel({
				singleSelect: true
			});
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
						header: "INCILRowID",
						dataIndex: 'Incil',
						width: 80,
						align: 'left',
						sortable: true,
						hidden: true
					}, {
						header: '物资代码',
						dataIndex: 'InciCode',
						width: 100,
						align: 'left',
						renderer: Ext.util.Format.InciPicRenderer('Incil'),
						sortable: true
					}, {
						header: "物资名称",
						dataIndex: 'InciDesc',
						width: 200,
						align: 'left',
						sortable: true
					}, {
						header: "货位",
						dataIndex: 'StkBin',
						width: 90,
						align: 'left',
						sortable: true
					}, {
						header: '库存(包装单位)',
						dataIndex: 'PurStockQty',
						width: 120,
						align: 'right',
						hidden: true,
						sortable: true
					}, {
						header: "包装单位",
						dataIndex: 'PurUomDesc',
						width: 80,
						align: 'left',
						sortable: false
					}, {
						header: "库存(基本单位)",
						dataIndex: 'StockQty',
						width: 120,
						align: 'right',
						sortable: true
					}, {
						header: "基本单位",
						dataIndex: 'BUomDesc',
						width: 80,
						align: 'left',
						sortable: false
					}, {
						header: "库存(单位)",
						dataIndex: 'StkQtyUom',
						width: 100,
						align: 'right',
						sortable: true
					}, {
						header: "占用库存",
						dataIndex: 'DirtyQty',
						width: 100,
						align: 'right',
						sortable: true
					}, {
						header: "在途库存",
						dataIndex: 'ReservedQty',
						width: 100,
						align: 'right',
						sortable: true
					}, {
						header: "可用库存",
						dataIndex: 'AvaQty',
						width: 100,
						align: 'right',
						sortable: true
					}, {
						header: "零售价",
						dataIndex: 'Sp',
						width: 80,
						align: 'right',
						sortable: false
					}, {
						header: "最新进价",
						dataIndex: 'Rp',
						width: 80,
						align: 'right',
						sortable: false
					}, {
						header: '售价金额',
						dataIndex: 'SpAmt',
						width: 120,
						align: 'right',
						sortable: false
					}, {
						header: '进价金额',
						dataIndex: 'RpAmt',
						width: 120,
						align: 'right',
						summaryType: 'sum',
						sortable: false
					}, {
						header: "规格",
						dataIndex: 'Spec',
						width: 100,
						align: 'left',
						sortable: false
					}, {
						header: '厂商',
						dataIndex: 'ManfDesc',
						width: 150,
						align: 'left',
						sortable: false
					}, {
						header: "医保类别",
						dataIndex: 'OfficalCode',
						width: 80,
						align: 'left',
						sortable: false
					}, {
						header: "重点关注标志",
						dataIndex: 'ManFlag',
						width: 120,
						align: 'left',
						sortable: false,
						renderer: manFlagRender
					}, {
						header: "高值标志",
						dataIndex: 'HVFlag',
						width: 60,
						align: 'center',
						sortable: false
					}, {
						header: "招标供应商",
						dataIndex: 'VendorDesc',
						width: 160,
						sortable: false
					}, {
						header: "型号",
						dataIndex: 'Model',
						width: 100,
						align: 'left',
						sortable: false
					}, {
						header: "最新入库供应商",
						dataIndex: 'LastVenDesc',
						width: 160,
						sortable: false
					}
				]);
		StockQtyCm.defaultSortable = true;

		// 访问路径
		var DspPhaUrl = DictUrl
			 + 'locitmstkaction.csp?actiontype=LocItmStk&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
				url: DspPhaUrl,
				method: "POST"
			});
		// 指定列参数
		var fields = ["Incil", "Inci", "InciCode", "InciDesc",
			"StkBin", "PurUomDesc", "BUomDesc", "PurStockQty", "ReservedQty",
			"StockQty", "StkQtyUom", "Sp", "SpAmt",
			"Rp", "RpAmt", "Spec", "ManfDesc",
			"OfficalCode", "ManFlag", "DirtyQty", "AvaQty", "ReservedQty", "HVFlag", "VendorDesc", "Model", "LastVenDesc"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: "results",
				id: "Incil",
				fields: fields
			});
		// 数据集
		var StockQtyStore = new Ext.data.Store({
				proxy: proxy,
				reader: reader,
				remoteSort: true,
				baseParams: {
					Params: ''
				}
			});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store: StockQtyStore,
				pageSize: PageSize,
				displayInfo: true
			});

		var StockQtyGrid = new Ext.ux.GridPanel({
				title: '库存',
				id: 'StockQtyGrid',
				region: 'center',
				cm: StockQtyCm,
				store: StockQtyStore,
				trackMouseOver: true,
				stripeRows: true,
				sm: sm,
				loadMask: true,
				bbar: StatuTabPagingToolbar,
				plugins: new Ext.grid.GridSummary(),
				listeners: {
					rowcontextmenu: function (grid, rowindex, e) {
						e.preventDefault();
						grid.getSelectionModel().selectRow(rowindex);
						rightClick.showAt(e.getXY());
					}
				}
			});

		var rightClick = new Ext.menu.Menu({
				id: 'rightClickCont',
				items: [{
						id: 'mnuTrans',
						handler: TransShow,
						text: '台帐信息'
					}, {
						id: 'mnuHVBarcode',
						handler: HVBarcodeShow,
						text: '高值条码'
					}, {
						id: 'mnuSynIncil',
						handler: SynIncilData,
						text: '科室单品库存同步'
					}, {
						id: 'mnuClrResQtyLocInci',
						handler: ClrLocInciResQty,
						text: '清除科室在途数'
					}
				]
			});

		function TransShow() {
			var rows = StockQtyGrid.getSelectionModel().getSelections();
			if (rows.length == 0) {
				Ext.Msg.show({
					title: '错误',
					msg: '请选择要查看的物资！',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
			} else {
				var selectedRow = rows[0];
				var Incil = selectedRow.get("Incil");
				var Date = Ext.getCmp("DateTime").getValue();
				var IncDesc = selectedRow.get("InciDesc");
				var PurUom = selectedRow.get("PurUomDesc");
				var BUom = selectedRow.get("BUomDesc");
				var IncInfo = IncDesc + '         包装单位：' + PurUom + '     基本单位：' + BUom;
				TransQuery(Incil, Date, IncInfo);
			}
		}

		function HVBarcodeShow() {
			var rows = StockQtyGrid.getSelectionModel().getSelections();
			if (rows.length == 0) {
				Ext.Msg.show({
					title: '错误',
					msg: '请选择要查看的物资！',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
			} else if (rows[0].get('HVFlag') != "Y") {
				var IncDesc = rows[0].get("InciDesc");
				Msg.info("warning", IncDesc + "不是高值物资!");
				return;
			} else {
				var selectedRow = rows[0];
				var Incil = selectedRow.get("Incil");
				var Date = Ext.util.Format.date(Ext.getCmp("DateTime").getValue(), ARG_DATEFORMAT);
				var IncDesc = selectedRow.get("InciDesc");
				HVBarcodeQuery(Incil, IncDesc);
			}
		}

		function SynIncilData() {
			var rows = StockQtyGrid.getSelectionModel().getSelections();
			var selectedRow = rows[0];
			var Incil = selectedRow.get("Incil");
			var IncCode = selectedRow.get("InciCode");
			var IncDesc = selectedRow.get("InciDesc");
			Ext.Msg.show({
				title: '科室单品库存同步',
				msg: '确定同步"' + IncCode + ' ' + IncDesc + '"库存？',
				scope: this,
				buttons: Ext.Msg.YESNO,
				icon: Ext.MessageBox.QUESTION,
				fn: function (id) {
					if (id == 'yes') {
						SynIncilStkQty(Incil);
					}
				}
			});
		}

		function SynIncilStkQty(Incil) {
			var url = DictUrl + 'locitmstkaction.csp?actiontype=SynIncilStkQty';
			var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					Incil: Incil
				},
				waitMsg: '处理中...',
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "同步成功!");
					} else {
						Msg.info("error", "同步失败!");
					}
					loadMask.hide();
				},
				scope: this
			});
		}

		function ClrLocInciResQty() {
			var rows = StockQtyGrid.getSelectionModel().getSelections();
			var selectedRow = rows[0];
			var Incil = selectedRow.get("Incil");
			var url = DictUrl + 'locitmstkaction.csp?actiontype=ClrLocInciResQty';
			var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
			Ext.Ajax.request({
				url: url,
				method: 'POST',
				params: {
					Incil: Incil
				},
				waitMsg: '处理中...',
				success: function (result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "清除科室在途数成功!");
						searchData();
					} else {
						var ret=jsonData.info;
						Msg.info("error", "清除科室在途数失败!"+ret);
					}
					loadMask.hide();
				},
				scope: this
			});
		}
		// 添加表格单击行事件
		StockQtyGrid.getSelectionModel().on('rowselect', function (sm, rowIndex, r) {
			var Incil = StockQtyStore.getAt(rowIndex).get("Incil");
			var Date = Ext.util.Format.date(Ext.getCmp("DateTime").getValue(), ARG_DATEFORMAT);
			var Vendor = Ext.getCmp("Vendor").getValue();
			var InclbBatchNo = Ext.getCmp('InclbBatchNo').getValue();
			var InclbExpDate = Ext.util.Format.date(Ext.getCmp('InclbExpDate').getValue(), ARG_DATEFORMAT);
			var InclbNoZeroFlag = Ext.getCmp('InclbNoZeroFlag').getValue() ? 'Y' : 'N';
			gStrParamBatch = Incil + "^" + Date + "^" + Vendor + "^" + InclbBatchNo + "^" + InclbExpDate
				 + "^" + InclbNoZeroFlag;
			BatchStore.setBaseParam('Params', gStrParamBatch);
			var pageSize = StatuTabPagingToolbarBatch.pageSize;
			BatchStore.load({
				params: {
					start: 0,
					limit: pageSize
				}
			});
		});
		var recallflag = new Ext.grid.CheckColumn({
				header: '是否锁定',
				dataIndex: 'RecallFlag',
				sortable: true,
				width: 100
			});
		var nm = new Ext.grid.RowNumberer();
		var BatchCm = new Ext.grid.ColumnModel([nm, {
						header: "Inclb",
						dataIndex: 'Inclb',
						width: 80,
						align: 'left',
						sortable: true,
						hidden: true
					}, {
						header: '批号',
						dataIndex: 'BatNo',
						width: 180,
						align: 'left',
						sortable: true
					}, {
						header: "效期",
						dataIndex: 'ExpDate',
						width: 100,
						align: 'left',
						sortable: true
					}, {
						header: '具体规格',
						dataIndex: 'SpecDesc',
						width: 100,
						align: 'left',
						sortable: true
					}, {
						header: "批次库存",
						dataIndex: 'QtyUom',
						width: 90,
						align: 'left',
						sortable: true
					}, {
						header: "批次占用",
						dataIndex: 'DirtyQty',
						width: 70,
						align: 'left',
						sortable: true
					}, {
						header: "批次在途",
						dataIndex: 'ReservedQty',
						width: 70,
						align: 'left',
						sortable: true
					}, {
						header: "批次可用库存",
						dataIndex: 'AvaQty',
						width: 100,
						align: 'left',
						sortable: true
					}, {
						header: '进价(基本单位)',
						dataIndex: 'BRp',
						width: 120,
						align: 'right',
						sortable: true
					}, {
						header: "进价(包装单位)",
						dataIndex: 'PRp',
						width: 120,
						align: 'right',
						sortable: true
					}, {
						header: "售价(基本单位)",
						dataIndex: 'BSp',
						width: 120,
						align: 'right',
						hidden: BatSpFlag == 0,
						sortable: true
					}, {
						header: "售价(包装单位)",
						dataIndex: 'PSp',
						width: 120,
						align: 'right',
						hidden: BatSpFlag == 0,
						sortable: true
					}, {
						header: "供应商",
						dataIndex: 'Vendor',
						width: 180,
						sortable: true
					}, recallflag, {
						header : "入库日期",
						dataIndex : 'IngrDate',
						width : 100,
						sortable : true
					}, {
						header: '税额(基本单位)',
						dataIndex: 'BTax',
						width: 120,
						align: 'right',
						sortable: true
					}]);
		BatchCm.defaultSortable = false;

		// 访问路径
		var BatchUrl = DictUrl
			 + 'locitmstkaction.csp?actiontype=Batch&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxyBatch = new Ext.data.HttpProxy({
				url: BatchUrl,
				method: "POST"
			});
		// 指定列参数
		var fieldsBatch = ["BatNo", "ExpDate", "QtyUom", "BRp", "PRp",
			"Inclb", "DirtyQty", "AvaQty", "BSp", "PSp",
			"Vendor", "RecallFlag", "ReservedQty", "IngrDate", "SpecDesc","BTax"];
		// 支持分页显示的读取方式
		var readerBatch = new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: "results",
				id: "Inclb",
				fields: fieldsBatch
			});
		// 数据集
		var BatchStore = new Ext.data.Store({
				proxy: proxyBatch,
				reader: readerBatch
			});

		var StatuTabPagingToolbarBatch = new Ext.PagingToolbar({
				store: BatchStore,
				pageSize: PageSize,
				displayInfo: true
			});
		var InclbNoZeroFlag = new Ext.form.Checkbox({
				id: 'InclbNoZeroFlag',
				boxLabel: '非零',
				listeners: {
					check: function (checkbox, checked) {
						InclbFilterBtn.handler();
					}
				}
			});
		var InclbBatchNo = new Ext.form.TextField({
				id: 'InclbBatchNo',
				fieldLabel: '批号',
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							InclbFilterBtn.handler();
						}
					}
				}
			});
		var InclbExpDate = new Ext.ux.DateField({
				id: 'InclbExpDate',
				fieldLabel: '效期'
			});
		var InclbFilterBtn = new Ext.Button({
				text: '过滤',
				width: 70,
				height: 30,
				iconCls: 'page_gear',
				handler: function (b, e) {
					var sm = StockQtyGrid.getSelectionModel();
					var r = sm.getSelected();
					if (Ext.isEmpty(r)) {
						return false;
					}
					var rowIndex = StockQtyGrid.getStore().indexOf(r);
					sm.fireEvent('rowselect', sm, rowIndex, r);
				}
			});
		var BatchGrid = new Ext.ux.GridPanel({
				id : 'BatchGrid',
				region: 'south',
				title: '批次信息',
				split: true,
				height: 250,
				minSize: 100,
				maxSize: 400,
				collapsible: true,
				cm: BatchCm,
				store: BatchStore,
				trackMouseOver: true,
				stripeRows: true,
				sm: new Ext.grid.RowSelectionModel({
					singleSelect: true
				}),
				loadMask: true,
				tbar: ['批号:', InclbBatchNo, '-', '效期:', InclbExpDate, '-', InclbNoZeroFlag, '-', InclbFilterBtn],
				bbar: StatuTabPagingToolbarBatch,
				listeners: {
					rowcontextmenu: function (grid, rowindex, e) {
						grid.getSelectionModel().selectRow(rowindex);
						e.preventDefault();
						rightClickDirtyQty.showAt(e.getXY());
					}
				}
			});

		var rightClickDirtyQty = new Ext.menu.Menu({
				id: 'rightClickDirtyQty',
				items: [{
						id: 'mnuDirtyQty',
						handler: DirtyQtyShow,
						text: '查看占用单据'
					}, {
						id: 'mnuInclbHVBarcode',
						handler: InclbHVBarcodeShow,
						text: '高值条码'
					}, {
						id: 'mnuInclbTransMove',
						handler: InclbTransMove,
						text: '批次台帐信息'
					}
				]
			});

		//右键菜单代码关键部分
		function DirtyQtyShow() {
			var rows = BatchGrid.getSelectionModel().getSelections();
			if (rows.length == 0) {
				Ext.Msg.show({
					title: '错误',
					msg: '请选择要查看的物资批次！',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
			} else {
				selectedRow = rows[0];
				var Inclb = selectedRow.get("Inclb");
				var rowsInc = StockQtyGrid.getSelectionModel().getSelections();
				var selectedInc = rowsInc[0];
				var IncDesc = selectedInc.get("InciDesc");
				var PurUom = selectedInc.get("PurUomDesc");
				var BUom = selectedInc.get("BUomDesc");
				var IncInfo = IncDesc + '         包装单位：' + PurUom + '     基本单位：' + BUom;
				DirtyQtyQuery(Inclb, IncInfo);
			}
		}

		function InclbHVBarcodeShow() {
			var rows = StockQtyGrid.getSelectionModel().getSelections();
			if (rows.length == 0) {
				Ext.Msg.show({
					title: '错误',
					msg: '请选择要查看的物资！',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
			} else if (rows[0].get('HVFlag') != "Y") {
				var IncDesc = rows[0].get("InciDesc");
				Msg.info("warning", IncDesc + "不是高值物资!");
				return;
			} else {
				var selectedRow = rows[0];
				var IncDesc = selectedRow.get("InciDesc");

				var Inclb = BatchGrid.getSelectionModel().getSelected().get("Inclb");
				HVBarcodeQuery(Inclb, IncDesc);
			}
		}

		function InclbTransMove() {
			var rows = StockQtyGrid.getSelectionModel().getSelections();
			if (rows.length == 0) {
				Ext.Msg.show({
					title: '错误',
					msg: '请选择要查看的物资！',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
			} else {
				var selectedRow = rows[0];
				var Date = Ext.getCmp("DateTime").getValue();
				var IncDesc = selectedRow.get("InciDesc");
				var PurUom = selectedRow.get("PurUomDesc");
				var BUom = selectedRow.get("BUomDesc");
				var BatRowData = BatchGrid.getSelectionModel().getSelected();
				var Inclb = BatRowData.get("Inclb");
				var BatchNo = BatRowData.get('BatNo'),ExpDate = BatRowData.get('ExpDate');
				var InclbInfo = IncDesc + '      包装单位：' + PurUom + '      基本单位：' + BUom + '      批号:' + BatchNo + '      效期:' + ExpDate;
				InclbTransQuery(Inclb, Date, InclbInfo);
			}
		}

		var HisListTab = new Ext.form.FormPanel({
				labelwidth: 30,
				width: 300,
				labelAlign: 'right',
				frame: true,
				autoScroll: true,
				bodyStyle: 'padding:10px 0px 0px 0px;',
				tbar: [SearchBT, '-', RefreshBT, '-', PrintBT],
				items: [{
						title: '必选条件',
						xtype: 'fieldset',
						style: 'padding:10px 0px 0px 0px',
						items: [PhaLoc, DateTime, StkGrpType, Type]
					}, Vendor, InciDesc, InciAlias, INFOImportFlag, DHCStkCatGroup,
					ARCItemCat, PhManufacturer, LocManGrp, PHCDOfficialType,
					Supervision,M_ChargeFlag,StkBin, ManageDrug, UseFlag, NotUseFlag, HvFlag
				]
			});

		// 5.2.页面布局
		var mainPanel = new Ext.ux.Viewport({
				layout: 'border',
				items: [// create instance immediately
					{
						region: 'west',
						split: true,
						width: 300,
						minSize: 200,
						maxSize: 350,
						collapsible: true,
						title: '库存查询',
						layout: 'fit', // specify layout manager for items
						items: HisListTab
					}, {
						region: 'center',
						layout: 'border',
						items: [StockQtyGrid, BatchGrid]
					}
				],
				renderTo: 'mainPanel'
			});
	}
})
