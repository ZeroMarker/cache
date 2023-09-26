// 名称:高值条码生成管理
// 编写人：徐超
// 编写日期:2013-09-17
var gGroupId = session['LOGON.GROUPID'];
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gHospId = session['LOGON.HOSPID'];
var inciDr = "";
var BarcodeArr = [];
var colArr = [];
/**
 * 调用物资窗体并返回结果
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N",
			"0", gHospId, getDrugList, "", "",
			"", "", "", "", "Y",
			"", "Y");
	}
}

/**
 * 返回方法
 */
function getDrugList(records) {
	var CurStartRow; //记录本次录入的第一行
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	Ext.each(records, function (record, index, allItems) {
		var inciDr = record.get("InciDr");

		var cell = BarCodeGrid.getSelectionModel().getSelectedCell(); // 选中行
		var row = cell[0];
		var col = cell[1];
		var HVFlag = record.get("HVFlag");
		if (HVFlag == 'N') {
			Msg.info("warning", "该材料不是高值材料!");
			BarCodeGrid.startEditing(row, col);
			return;
		}
		var rowData = BarCodeGrid.getAt(row);
		rowData.set("IncId", inciDr);
		
		var Params = session['LOGON.GROUPID'] + '^' + session['LOGON.CTLOCID'] + '^' + gUserId; //取其它物资信息
		var url = DictUrl + "ingdrecaction.csp?actiontype=GetItmInfo&IncId=" + inciDr + "&Params=" + Params;
		var response = ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(response);
		if (jsonData.success == 'true') {
			var info = jsonData.info;
			if (info != null || info != '') {
				var data = jsonData.info.split("^");
				var inciCode = data[26], inciDesc = data[27];
				rowData.set("IncCode", inciCode);
				rowData.set("IncDesc", inciDesc);
				
				addComboData(PhManufacturerStore, data[0], data[1]);
				rowData.set("ManfId", data[0]);
				rowData.set("PurUomId", data[2]);
				var ConFac = data[11];
				rowData.set('Qty', ConFac);			//入库单位和基本单位不一致, 默认打印条码数量为转换系数
				rowData.set("PurUom", data[3]);
				rowData.set('Spec', data[17]);
				rowData.set("Rp", Number(data[23])); //2016-01-21 按基本单位处理
				rowData.set("Sp", Number(data[24]));
				rowData.set("NewSp", Number(data[24]));
				//rowData.set("BatNo", data[6]);			//这里不要给批号效期赋值了,和条码解析冲突,也没特殊意义,不打算做特别控制
				//rowData.set("ExpDate", toDate(data[7]));
				rowData.set("BUomId", data[10]);
				rowData.set("BUom", data[25]);
				rowData.set('CerNo', data[28]);
				rowData.set('CerExpDate', data[29]);
				rowData.set('BatchCodeFlag', data[32]);
				var Marginnow = '';
				if (Number(data[4]) > 0) {
					Marginnow = accSub(accDiv(Number(data[5]), Number(data[4])), 1);
				}
				rowData.set('Marginnow', Marginnow);
				if (row > 0 && (data[20] == null || data[20] == "")) {
					var vendorId = BarCodeGrid.getAt(row - 1).get('VendorId');
					rowData.set("VendorId", vendorId);
				} else {
					addComboData(Ext.getCmp("VendorField").getStore(), data[20], data[21]);
					rowData.set("VendorId", data[20]);
				}
			
				//核实资质信息
				var StrParam = '^' + inciDr + '^' + data[0]; //vendor^inci^manf
				var AlarmDays = 30;
				var CheckInfo = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'Check', StrParam, AlarmDays);
				if (!Ext.isEmpty(CheckInfo)) {
					Msg.info("warning", inciDesc + ':' + CheckInfo);
				}
			}
		}
		if (!CurStartRow) {
			CurStartRow = row;
		}
		if(index < allItems.length - 1){
			BarCodeGrid.addNewRow();
		}
	});
	
	if(setEnterSort(BarCodeGrid, colArr)){
		BarCodeGrid.addNewRow();
	}
}

//入库科室
var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '科室',
		id: 'PhaLoc',
		anchor: '90%',
		emptyText: '科室...',
		groupId: session['LOGON.GROUPID']
	});

var VirtualFlag = new Ext.form.Checkbox({
		hideLabel: true,
		boxLabel: G_VIRTUAL_STORE,
		id: 'VirtualFlag',
		anchor: '90%',
		checked: false,
		listeners: {
			check: function (chk, bool) {
				if (bool) {
					var phaloc = Ext.getCmp("PhaLoc").getValue();
					var info = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'GetMainLoc', phaloc);
					var url = "dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc=" + phaloc;
					var infoArr = info.split("^");
					var vituralLoc = infoArr[0],
					vituralLocDesc = infoArr[1];
					addComboData(Ext.getCmp("PhaLoc").getStore(), vituralLoc, vituralLocDesc);
					Ext.getCmp("PhaLoc").setValue(vituralLoc);
				} else {
					SetLogInDept(Ext.getCmp("PhaLoc").getStore(), "PhaLoc");
				}
			}
		}
	});

VirtualFlag.setValue(true);

var RegFlag = new Ext.form.Checkbox({
		hideLabel: true,
		boxLabel: "已入库",
		id: 'RegFlag',
		anchor: '90%',
		checked: false
	});
//入库供应商
var ImpVendor = new Ext.ux.VendorComboBox({
		fieldLabel: '入库供应商',
		id: 'ImpVendor',
		anchor: '90%'
	});
var INFOPbCarrier = new Ext.ux.ComboBox({
		fieldLabel: '配送商',
		id: 'INFOPbCarrier',
		name: 'INFOPbCarrier',
		store: CarrierStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'CADesc'
	});    
var SourceOfFund = new Ext.ux.ComboBox({
		fieldLabel: '资金来源',
		id: 'SourceOfFund',
		anchor: '90%',
		store: SourceOfFundStore
	});

var ToLoc = new Ext.ux.LocComboBox({
		fieldLabel: '接收科室',
		id: 'ToLoc',
		anchor: '90%',
		emptyText: '接收科室...',
		groupId: gGroupId,
		linkloc: gLocId,
		defaultLoc: {}
	});
	
var startDate = new Ext.ux.DateField({
		id: 'startDate',
		allowBlank: true,
		fieldLabel: '起始日期',
		anchor: '90%',
		value: DefaultStDate()
	});
// 截止日期
var endDate = new Ext.ux.DateField({
		id: 'endDate',
		allowBlank: true,
		fieldLabel: '截止日期',
		anchor: '90%',
		value: DefaultEdDate()
	});
// 类组
var StkGrpType = new Ext.ux.StkGrpComboBox({
		id: 'StkGrpType',
		fieldLabel: '<font color=red>*类组</font>',
		StkType: App_StkTypeCode, // 标识类组类型
		UserId: gUserId,
		LocId: gLocId,
		anchor: '90%'
	});

var BarCodeField = new Ext.form.TextField({
		id: 'BarCodeField',
		fieldLabel: '条形码',
		allowBlank: true,
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					findBarCode.handler()
				}
			}
		}
	});
var BatNo = new Ext.form.TextField({
		id: 'BatNo',
		fieldLabel: '批号',
		allowBlank: true,
		anchor: '90%',
		selectOnFocus: true,
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					findBarCode.handler()
				}
			}
		}
	});

var LocField = new Ext.ux.LocComboBox({
		fieldLabel: '生成科室',
		id: 'LocField',
		name: 'LocField',
		anchor: '90%',
		emptyText: '生成科室...',
		groupId: gGroupId,
		linkloc: gLocId,
		listeners: {
			'select': function (cb) {
				var requestLoc = cb.getValue();
				var defprovLocs = tkMakeServerCall("web.DHCSTM.DHCTransferLocConf", "GetDefLoc", requestLoc, gGroupId);
				var mainArr = defprovLocs.split("^");
				var defprovLoc = mainArr[0];
				var defprovLocdesc = mainArr[1];
			}
		},
		defaultLoc: {}
		//默认值为空
	});

// 物资编码
var M_InciCode = new Ext.form.TextField({
		fieldLabel: '物资编码',
		id: 'M_InciCode',
		name: 'M_InciCode',
		anchor: '90%',
		width: 150,
		disabled: true,
		valueNotFoundText: ''
	});

// 物资名称
var M_InciDesc = new Ext.form.TextField({
		fieldLabel: '物资名称',
		id: 'M_InciDesc',
		name: 'M_InciDesc',
		anchor: '90%',
		width: 150,
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = Ext.getCmp("StkGrpType").getValue();
					GetPhaOrderInfo2(field.getValue(), stktype);
				}
			},
			blur: function (field) {
				if (field.getValue() == "") {
					inciDr = "";
					Ext.getCmp("M_InciCode").setValue("");
				}
			}
		}
	});
function GetPhaOrderInfo2(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N",
			"0", gHospId, getDrugList2, "", "",
			"", "", "", "", "",
			"", "Y");
	}
}
function getDrugList2(record) {
	inciDr = record.get("InciDr");
	var inciCode = record.get("InciCode");
	var inciDesc = record.get("InciDesc");
	Ext.getCmp("M_InciDesc").setValue(inciDesc);
	Ext.getCmp("M_InciCode").setValue(inciCode);
}

var Vendor = new Ext.ux.VendorComboBox({
		id: 'Vendor',
		name: 'Vendor',
		anchor: '90%'
	});
var RequestPhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '请求部门',
		id: 'RequestPhaLoc',
		name: 'RequestPhaLoc',
		anchor: '90%',
		emptyText: '请求部门...',
		defaultLoc: {}
	});

var Specom = new Ext.form.ComboBox({
		fieldLabel: '具体规格',
		id: 'Specom',
		name: 'Specom',
		anchor: '90%',
		width: 120,
		listWidth: 210,
		store: SpecDescStore,
		valueField: 'Description',
		displayField: 'Description',
		triggerAction: 'all',
		emptyText: '具体规格...',
		selectOnFocus: true,
		forceSelection: true,
		minChars: 1,
		pageSize: 10,
		valueNotFoundText: '',
		listeners: ({
			'beforequery': function () {
				var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
				var record = BarCodeGrid.getStore().getAt(cell[0]);
				var IncRowid = record.get("IncId");
				var desc = this.getRawValue();
				this.store.removeAll(); //load之前remove原记录，否则容易出错
				this.store.setBaseParam('SpecItmRowId', IncRowid)
				this.store.setBaseParam('desc', desc)
				this.store.load({
					params: {
						start: 0,
						limit: this.pageSize
					}
				})
			},
			specialkey : function(field, e){
				if(e.getKey() == Ext.EventObject.ENTER){
					if(setEnterSort(BarCodeGrid, colArr)){
						BarCodeGrid.addNewRow();
					}
				}
			}
		})
	});

var Manf = new Ext.ux.ComboBox({
		fieldLabel: '厂商',
		id: 'Manf',
		store: PhManufacturerStore,
		emptyText: ' 厂商...',
		filterName: 'PHMNFName',
		params: {
			ScgId: 'StkGrpType'
		}
	});

var VendorField = new Ext.ux.VendorComboBox({
		id: 'VendorField',
		name: 'VendorField',
		allowBlank: gItmTrackParam[7] == "Y" ? false : true,
		anchor: '90%'
	});
/// 判断自带条码是否存在
function  GetRepeatResult(store,colName,colValue,beginIndex,inciDesc,row){
	beginIndex=store.findExact(colName,colValue,beginIndex);
	return beginIndex;
}
var BarCodeGridCm = [{
		header: "dhcit",
		dataIndex: 'InctrackId',
		saveColIndex: 0,
		hidden: true
	}, {
		header: "IncId",
		dataIndex: 'IncId',
		saveColIndex: 1,
		hidden: true,
		hideable: false
	}, {
		header: "物资代码",
		dataIndex: 'IncCode',
		width: 150,
		align: 'left',
		renderer: Ext.util.Format.InciPicRenderer('IncId'),
		sortable: true
	}, {
		header: "物资名称",
		dataIndex: 'IncDesc',
		width: 200,
		align: 'left',
		sortable: true,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: false,
				allowBlank: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var row = BarCodeGrid.getSelectedCell()[0];
							var RowData = BarCodeGrid.getAt(row);
							
							var Input = field.getValue();
							var BarCodeObj = GetBarCodeSplitInfo(Input);
							var InciId = BarCodeObj['InciId'];
							var BatchNo = BarCodeObj['BatchNo'];
							var ExpDate = BarCodeObj['ExpDate'];
							if(!Ext.isEmpty(InciId)){
								if(!Ext.isEmpty(BatchNo) || !Ext.isEmpty(ExpDate)){
									field.setValue('');		//没有这句的话,物资名称set不上值
									RowData.set('OriginalCode', Input);
									//RowData.set('OldOriginalCode', Input);
									RowData.set('BatNo', BatchNo);
									RowData.set('ExpDate', ExpDate);
									var ExpDateStr = Ext.isEmpty(ExpDate) ? '' : ExpDate.format(DateFormat);
									Msg.info('warning', '自动填充了批号:' + BatchNo + ',有效期:' + ExpDateStr + ', 请注意核对!');
									
									//解析条码能获取到记录的,则直接进行数据set
									var record = Ext.data.Record.create([
										{
											name : 'InciDr',
											type : 'string'
										}
									]);
									var InciRecord = new record({
										InciDr : InciId
									});
									getDrugList(InciRecord);
								}else{
									if(Input.length > 22){
										Msg.info('warning', '批号效期无法解析, 请检查条码拆分规则!')
									}
									return false;
								}
							}else if(Input.length >= 22){
								Msg.info('warning', '疑似扫描条码但无法解析, 请维护条码拆分规则!')
							}else{
								var group = Ext.getCmp("StkGrpType").getValue();
								GetPhaOrderInfo(field.getValue(), group);
							}
						}
					}
				}
			}))
	}, {
		header: "规格",
		dataIndex: 'Spec'
	}, {
		header: "具体规格",
		dataIndex: 'SpecDesc',
		saveColIndex: 8,
		width: 100,
		align: 'left',
		sortable: true,
		editor: new Ext.grid.GridEditor(Specom),
		renderer : Ext.util.Format.comboRenderer2(Specom,"SpecDesc","SpecDesc")
	}, {
		header: "数量",
		dataIndex: 'Qty',
		width: 80,
		align: 'right',
		saveColIndex: 3,
		editor: new Ext.form.NumberField({
			selectOnFocus: true,
			allowBlank: false,
			allowNegative: false,
			allowDecimals: false,
			listeners: {
				specialkey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var qty = field.getValue();
						if (qty == null || qty.length <= 0) {
							Msg.info("warning", "数量不能为空!");
							return;
						}
						if(setEnterSort(BarCodeGrid, colArr)){
							BarCodeGrid.addNewRow();
						}
					}
				}
			}
		})
	}, {
		header: "物资条码",
		dataIndex: 'BarCode',
		width: 150,
		align: 'left',
		sortable: false,
		saveColIndex: 2,
		editable: false, //2015-12-28 不可编辑
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if(setEnterSort(BarCodeGrid, colArr)){
								BarCodeGrid.addNewRow();
							}
						}
					}
				}
			}))
	}, {
		header: "打印",
		xtype: 'checkcolumn',
		dataIndex: 'print',
		width: 40
	}, {
		header: "出厂自带条码",
		dataIndex: 'OldOriginalCode',
		width: 150,
		align: 'left',
		sortable: false,
		saveColIndex: 19,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
							var row = cell[0];
							
							var RowData = BarCodeGrid.getAt(row);
							var OriginalCode = field.getValue();
							if(!Ext.isEmpty(OriginalCode)){
								var BarCodeObj = GetBarCodeSplitInfo(OriginalCode);
								var BatchNo = BarCodeObj['BatchNo'], ExpDate = BarCodeObj['ExpDate'];
								if(!Ext.isEmpty(BatchNo) && !Ext.isEmpty(ExpDate)){
									var ExpDateStr = Ext.isEmpty(ExpDate) ? '' : ExpDate.format(DateFormat);
									Msg.info('warning', '自动填充了批号:' + BatchNo + ',有效期:' + ExpDateStr + ', 请注意核对!');
									RowData.set('BatNo', BatchNo);
									RowData.set('ExpDate', ExpDate);
								}
							}
							
							if(OriginalCode.length <= 22){
								//自带条码经常分段,太短说明分段了,这里不跳转
								return false;
							}else{
								if(setEnterSort(BarCodeGrid, colArr)){
									BarCodeGrid.addNewRow();
								}
							}
						}
					}
				}
			}))
	}, {
		header: "自带条码",
		dataIndex: 'OriginalCode',
		width: 150,
		align: 'left',
		sortable: false,
		saveColIndex: 4,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							//自带条码经常分段,这里不跳转了
							var oribarcode=field.getValue();
							if(!Ext.isEmpty(oribarcode)){
								var BarCodestore=BarCodeGrid.getStore();
								var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
								var row = cell[0];
								var RowData = BarCodeGrid.getAt(row);
								var retinfo=GetRepeatResult(BarCodestore,'OriginalCode',oribarcode,0,oribarcode,row);
								var ret=tkMakeServerCall("web.DHCSTM.DHCItmTrack","OriBarIfExit",oribarcode);
								if(ret==1){
									Msg.info("warning",oribarcode+"已经存在！");
									field.setValue("");
									return false;
								}
								if(retinfo!=-1){
									Msg.info("warning",oribarcode+"已经存在！");
									field.setValue("");
									return false;
								}
								
								//自动拆分批号效期
								var BarCodeObj = GetBarCodeSplitInfo(oribarcode);
								var BatchNo = BarCodeObj['BatchNo'], ExpDate = BarCodeObj['ExpDate'];
								if(!Ext.isEmpty(BatchNo) && !Ext.isEmpty(ExpDate)){
									var ExpDateStr = Ext.isEmpty(ExpDate) ? '' : ExpDate.format(DateFormat);
									Msg.info('warning', '自动填充了批号:' + BatchNo + ',有效期:' + ExpDateStr + ', 请注意核对!');
									RowData.set('BatNo', BatchNo);
									RowData.set('ExpDate', ExpDate);
								}
							}
							
							if(oribarcode.length <= 22){
								//自带条码经常分段,太短说明分段了,这里不跳转
								return false;
							}else{
								if(setEnterSort(BarCodeGrid, colArr)){
									BarCodeGrid.addNewRow();
								}
							}
						}
					}
				}
			}))
	}, {
		header: "生成(注册)人员",
		dataIndex: 'User'
	}, {
		header: "生成(注册)日期",
		dataIndex: 'Date'
	}, {
		header: "生成(注册)时间",
		dataIndex: 'Time'
	}, {
		header: "PoItmId",
		dataIndex: 'PoItmId',
		saveColIndex: 5,
		hidden: true
	}, {
		header: "请求单号",
		dataIndex: 'ReqNo',
		hidden: true
	}, {
		header: "品牌",
		dataIndex: 'Brand',
		hidden: true
	}, {
		header: "进价",
		dataIndex: 'Rp',
		width: 60,
		align: 'right',
		sortable: true,
		saveColIndex: 12,
		summaryType : 'sum',
		editor: new Ext.ux.NumberField({
			formatType: 'FmtRP',
			selectOnFocus: true,
			allowBlank: false,
			listeners: {
				specialkey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cost = field.getValue();
						if (cost == null || cost.length <= 0) {
							Msg.info("warning", "进价不能为空!");
							return;
						}
						if (cost <= 0) {
							Msg.info("warning", "进价不能小于或等于0!");
							return;
						}
						if(setEnterSort(BarCodeGrid, colArr)){
							BarCodeGrid.addNewRow();
						}
					}
				}
			}
		})
	}, {
		header: "批号",
		dataIndex: 'BatNo',
		width: 90,
		align: 'center',
		sortable: true,
		saveColIndex: 6,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							if(setEnterSort(BarCodeGrid, colArr)){
								BarCodeGrid.addNewRow();
							}
						}
					}
				}
			}))
	}, {
		header: "有效期",
		xtype: 'datecolumn',
		dataIndex: 'ExpDate',
		width: 100,
		align: 'center',
		sortable: true,
		saveColIndex: 7,
		editor: new Ext.ux.DateField({
			selectOnFocus: true,
			allowBlank: true,
			listeners: {
				specialkey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var expDate = field.getValue();
						if (expDate == null || expDate.length <= 0) {
							Msg.info("warning", "有效期不能为空!");
							return;
						}
						var nowdate = new Date();
						if (expDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT)) {
							Msg.info("warning", "有效期不能小于或等于当前日期!");
							return;
						}
						BarCodeGrid.addNewRow();
					}
				}
			}
		})
	}, {
		header: "当前售价",
		dataIndex: 'Sp',
		align: 'right'
	}, {
		header: "请求科室",
		dataIndex: 'ReqLocDesc'
	}, {
		header: "招标进价",
		dataIndex: 'PbRp'
	}, {
		header: "加成率",
		dataIndex: 'Marginnow',
		align: 'right'
	}, {
		header: "注册证号",
		dataIndex: 'CerNo',
		saveColIndex: 10,
		editor: new Ext.form.TextField({
			selectOnFocus: true,
			allowBlank: true
		})
	}, {
		header: "注册证效期",
		xtype: 'datecolumn',
		dataIndex: 'CerExpDate',
		saveColIndex: 11,
		sortable: true,
		editor: new Ext.ux.DateField({
			selectOnFocus: true,
			allowBlank: true
		})
	}, {
		header: "生产日期",
		xtype: 'datecolumn',
		dataIndex: 'ProduceDate',
		width: 100,
		align: 'center',
		sortable: true,
		saveColIndex: 9,
		editor: new Ext.ux.DateField({
			selectOnFocus: true,
			listeners: {
				specialkey: function (field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						if(setEnterSort(BarCodeGrid, colArr)){
							BarCodeGrid.addNewRow();
						}
					}
				}
			}
		})
	}, {
		header: "入库单位",
		dataIndex: 'PurUomId',
		width: 80,
		align: 'left',
		sortable: true,
		hidden: true
	}, {
		header: "基本单位",
		dataIndex: 'BUomId',
		width: 80,
		align: 'left',
		sortable: true,
		hidden: true
	}, {
		header: "基本单位描述",
		dataIndex: 'BUom',
		width: 80,
		align: 'left',
		sortable: true,
		hidden: true
	}, {
		header: "入库子表id",
		dataIndex: 'Ingri',
		width: 80,
		align: 'left',
		sortable: true,
		hidden: true
	}, {
		header: '厂商',
		dataIndex: 'ManfId',
		saveColIndex: 13,
		xtype: 'combocolumn',
		valueField: 'ManfId',
		displayField: 'ManfDesc',
		editor: Manf
	}, {
		header: "供应商",
		dataIndex: 'VendorId',
		saveColIndex: 14,
		xtype: 'combocolumn',
		valueField: 'VendorId',
		displayField: 'VendorDesc',
		editor: VendorField
	}, {
		header: "平台子表id",
		dataIndex: 'OrderDetailSubId',
		width: 80,
		align: 'left',
		saveColIndex: 15,
		sortable: true,
		hidden: true
	},{
		header : "随行单号",
		dataIndex : 'SxNo',
		width : 90,
		align : 'left',
		saveColIndex : 16,
		sortable : true,
		editor : new Ext.form.TextField({
			selectOnFocus : true,
			allowBlank : true
		})
	}, {
		header: "批号要求",
		dataIndex: 'BatchReq',
		hidden: true
	}, {
		header: "效期要求",
		dataIndex: 'ExpReq',
		hidden: true
	}, {
		header: "批次码",
		dataIndex: 'BatchCode',
		width: 150,
		align: 'left',
		sortable: false,
		saveColIndex : 17,
		editor: new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus: true,
				listeners: {
					specialkey: function (field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) { 
						        BarCodeGrid.startEditing(row + 1, col);
							
						}
					}
				}
			}))
	},{
		header : "批次码标志",
		dataIndex : 'BatchCodeFlag',
		hidden : false  //20190525
	}
];

function paramsFn() {
	var BarCodeField = Ext.getCmp('BarCodeField').getValue();
	var StkGrpType = Ext.getCmp('StkGrpType').getValue();
	var startDate = Ext.getCmp("startDate").getValue();
	if(startDate==""){
		startDate=(new Date())
		}
	if (Ext.isEmpty(startDate)) {
		Msg.info('warning', '起始日期不可为空!');
		return false;
	}
	startDate = startDate.format(ARG_DATEFORMAT);
	var endDate = Ext.getCmp("endDate").getValue();
	if(endDate==""){
		endDate=(new Date())
		}
	if (Ext.isEmpty(endDate)) {
		Msg.info('warning', '截止日期不可为空!');
		return false;
	}
	endDate = endDate.format(ARG_DATEFORMAT);
	var vendor = Ext.getCmp("Vendor").getValue();
	var reqloc = Ext.getCmp("RequestPhaLoc").getValue();
	var batno = Ext.getCmp("BatNo").getValue();
	var time = "";
	if (Ext.getCmp("M_InciDesc").getValue() == "") {
		inciDr = "";
	}
	var CreatLoc = Ext.getCmp("LocField").getValue();
	
	var Status = Ext.getCmp("RegFlag").getValue()==true? 'Enable' : '';
	var Param = BarCodeField + "^" + StkGrpType + "^" + inciDr + "^" + startDate + "^" + time
		 + "^" + endDate + "^" + vendor + "^" + reqloc + "^" + batno + "^" + gHospId
		 + "^" + "" + "^" + gLocId + "^" + CreatLoc+"^"+Status;
	return {
		'Param': Param
	};
}

function cellSelectFn(sm, rowIndex, colIndex) {
	/*
	var InctrackId = BarCodeGrid.getCell(rowIndex,BarCodeGrid.idProperty);
	//如果可编辑, 就不再执行该方法了, 否则界面响应变慢
	var ColumnHeader = sm.grid.getColumnModel().getDataIndex(colIndex);
	if (!Ext.isEmpty(InctrackId) && (ColumnHeader=='OriginalCode' || ColumnHeader=='Rp' || ColumnHeader=='BatNo' || ColumnHeader=='ExpDate' || ColumnHeader=='SpecDesc' || ColumnHeader=='ProduceDate')) {
	return false;
	}

	var rowData = BarCodeGrid.getAt(rowIndex);
	var BarCode = rowData.get("BarCode");
	if(BarCode!=""){
	$("#SaveBarCodeDiv").barcode(BarCode, "code39",{barWidth:1, barHeight:40,showHRI:true,fontSize:20}); ///先存到一个div
	//将内容复制到另一个div
	var addBarCode=Ext.get("SaveBarCodeDiv").dom.innerHTML;
	var totalBarcode=Ext.get("ShowBarCodeDiv").dom.innerHTML
	var index=totalBarcode.indexOf(addBarCode);
	var len=addBarCode.length;
	if(index>=0){
	var str1=totalBarcode.slice(0,index);
	var str2=totalBarcode.slice(index+len);
	Ext.get("ShowBarCodeDiv").dom.innerHTML=str1.concat(str2);
	BarcodeArr.remove(BarCode);
	}else{
	Ext.get("ShowBarCodeDiv").dom.innerHTML=Ext.get("ShowBarCodeDiv").dom.innerHTML+addBarCode;
	BarcodeArr.push(BarCode);
	}
	}
	 */
}

function beforeAddFn() {
	var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();
	if (StkGrpType == null || StkGrpType.length <= 0) {
		Msg.info("warning", "请选择类组!");
		return false;
	}
	colArr = sortColoumByEnterSort(BarCodeGrid);
}

var BarCodeGridUrl = 'dhcstm.barcodeaction.csp';
// 表格
var BarCodeGrid = new Ext.dhcstm.EditorGridPanel({
		region: 'center',
		id: 'BarCodeGrid',
		contentColumns: BarCodeGridCm,
		smRowSelFn: cellSelectFn,
		singleSelect: false,
		selectFirst: false,
		actionUrl: BarCodeGridUrl,
		queryAction: "query",
		idProperty: "InctrackId",
		checkProperty: "IncId",
		paramsFn: paramsFn,
		beforeAddFn: beforeAddFn,
		delRowAction: "Delete",
		delRowParam: "RowId",
		//plugins : new Ext.grid.GridSummary(),
		paging: false, //2015-12-23 添加直接入库功能后,暂不使用翻页工具条
		listeners: {
			'beforeedit': function (e) {
				var InctrackId = BarCodeGrid.getCell(e.row, "InctrackId");
				var BatchCodeFlag=BarCodeGrid.getCell(e.row, "BatchCodeFlag");
				if (!Ext.isEmpty(InctrackId) && e.field != 'OriginalCode' && e.field != 'OldOriginalCode' && e.field != 'BatNo' && e.field != 'ExpDate' && e.field != 'SpecDesc' && e.field != 'ProduceDate' && e.field != 'Rp' && e.field != 'ManfId' && e.field != 'CerNo' && e.field != 'CerExpDate' && e.field != 'VendorId'&& e.field != 'BatchCode'&&(e.field != 'Qty')) {
					return false; // 控制修改 生成条码的不允许修改
				}
				if (!Ext.isEmpty(InctrackId)&&(e.field == 'Qty')&&(BatchCodeFlag!="Y")){
				   return false;
				}
				
			},
			'rowcontextmenu': function (grid, rowindex, e) {
				e.preventDefault();
				grid.getSelectionModel().select(rowindex, 1);
				//仅对未保存的条码明细弹出右键菜单
				if (grid.getStore().getAt(rowindex).get('InctrackId') == '') {
					rightClick.showAt(e.getXY());
				}
			},
			'rowdblclick': function (grid, rowIndex, e) {
				var record = grid.getStore().getAt(rowIndex)
					var dhcit = record.get('InctrackId');
				if (Ext.isEmpty(dhcit)) {
					return;
				}
				var BarCode = record.get('BarCode');
				var IncDesc = record.get('IncDesc');
				var InfoStr = BarCode + ' : ' + IncDesc;
				BarCodePackItm(dhcit, InfoStr);
			},
			'afteredit': function (e) {
				if (e.field == 'Rp') {
					var cost = e.value;
					if (Ext.isEmpty(cost)) {
						Msg.info("warning", "进价不能为空!");
						e.record.set('Rp', e.originalValue);
						return;
					} else if (cost < 0) {
						//2016-09-26进价可为0
						Msg.info("warning", "进价不能小于0!");
						e.record.set('Rp', e.originalValue);
						return;
					}
					//批次售价或者入库调价根据进价重新计算售价
					var AllowAspWhileReceive=GetRecAdjspFlag();
					if (BatSpFlag == 1||AllowAspWhileReceive=="Y") {
						var IncId = e.record.get('IncId');
						var UomId = e.record.get('BUomId');
						var Rp = e.value;
						var url = 'dhcstm.ingdrecaction.csp?actiontype=GetMtSp&IncId=' + IncId + '&UomId=' + UomId + '&Rp=' + Rp;
						var responseText = ExecuteDBSynAccess(url);
						var jsonData = Ext.util.JSON.decode(responseText);
						if (jsonData.success == 'true') {
							var MtSp = jsonData.info;
							e.record.set("Sp", MtSp);
						}
					}
				}else if(e.field == 'Qty'){
					if (!Ext.isNumber(e.value) || e.value > 1000) {
						Msg.info("warning", "数量不能超过1000!");
						e.record.set('Qty',e.originalValue);
						return;
					}
				}
			}
		}
	});

var rightClick = new Ext.menu.Menu({
		id: 'rightClickCont',
		items: [{
				id: 'mnuDelete',
				handler: function (item, e) {
					BarCodeGrid.deleteRow();
				},
				text: '删除'
			}, {
				id: 'mnuSplit',
				handler: SplitDetail,
				text: '拆分明细'
			}
		]
	});

var rowsAdd = 1000;
function SplitDetail(item, e) {
	var cell = BarCodeGrid.getSelectedCell();
	if (cell == null) {
		Msg.info("warning", "没有选中行!");
		return;
	}
	var row = cell[0];
	var record = BarCodeGrid.getStore().getAt(row);
	if (record.get('InctrackId') != "") {
		Msg.info('error', '已保存条码不可拆分!');
		return;
	}
	var qty = record.get('Qty');
	var qty = (Ext.isEmpty(qty) || qty <= 1) ? 2 : record.get('Qty');
	record.set('Qty', 1);
	var BarCodeStore = BarCodeGrid.getStore();
	for (var i = 1; i < qty; i++) {
		var newRecord = new BarCodeStore.recordType(record.copy().data, ++rowsAdd);
		BarCodeStore.insert(++row, newRecord);
	}
	BarCodeGrid.view.refresh();
}

var findBarCode = new Ext.Toolbar.Button({
		text: '查询',
		tooltip: '查询',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			clear.handler();
			BarCodeGrid.load();
		}
	});

var addBarCode = new Ext.Toolbar.Button({
		text: '新建',
		iconCls: 'page_add',
		width: 70,
		height: 30,
		handler: function () {
			BarCodeGrid.removeAll();
			BarCodeGrid.addNewRow();
		}
	});

var ImportButton = new Ext.SplitButton({
		text: '导入',
		width: 70,
		height: 30,
		iconCls: 'page_add',
		tooltip: '下拉导入按钮',
		menu: {
			items: [{
					text: '<b>导入订单</b>',
					handler: ImpByPoFN
				}, {
					text: '<b>导入云平台订单</b>',
					handler: ImpBySciPoFN
				}
			]
		}
	})

function ImpByPoFN() {
	ImportByPo(getlist);
}
/*
function ImpBySciPoFN() {
	ImportBySciPo(getlist2);
}*/
//保存条码后查询 lihui
function ImpBySciPoFN() {
	ImportBySciPo(QueryForSciPo);
}

function getlist(records) {
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	var count = BarCodeGrid.getCount();
	Ext.each(records, function (record, index, allItems) {
		var IncId = record.get("IncId");
		var IncCode = record.get("IncCode");
		var IncDesc = record.get("IncDesc");
		var Qty = record.get("AvaBarcodeQty");
		var Spec = record.get("Spec");
		var SpecDesc = record.get("SpecDesc");
		var PoItmId = record.get("PoItmId");
		var CerNo = record.get("CerNo");
		var CerExpDate = toDate(record.get("CerExpDate"));
		var defaData = {
			IncId: IncId,
			IncCode: IncCode,
			IncDesc: IncDesc,
			Qty: Qty,
			Spec: Spec,
			PoItmId: PoItmId,
			CerNo: CerNo,
			CerExpDate: CerExpDate

		};
		var DataRecord = CreateRecordInstance(BarCodeGrid.getStore().fields, defaData);
		if (Qty > 0) {
			BarCodeGrid.getStore().add(DataRecord)
			var Rowcount = BarCodeGrid.getStore().getCount();
			var rowData = BarCodeGrid.getStore().getAt(Rowcount - 1);
			addComboData(SpecDescStore, SpecDesc, SpecDesc);
			rowData.set("SpecDesc", SpecDesc);
		}
	});
}
function getlist2(records,sxno) {
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	var count = BarCodeGrid.getCount();
	Ext.each(records, function (record, index, allItems) {
		var IncId = record.get("IncId");
		var IncCode = record.get("IncCode");
		var IncDesc = record.get("IncDesc");
		var Qty = record.get("AvaBarcodeQty");
		var Spec = record.get("Spec");
		var SpecDesc = record.get("SpecDesc");
		var PoItmId = record.get("PoItmId");
		var CerNo = record.get("CerNo");
		var CerExpDate = record.get("CerExpDate");
		var BarCode = record.get("BarCode");
		var BatNo = record.get("BatNo");
		var ExpDate = record.get("ExpDate");
		var ProduceDate = record.get("ProduceDate");
		var OrderDetailSubId = record.get("OrderDetailSubId");
		var defaData = {
			IncId: IncId,
			IncCode: IncCode,
			IncDesc: IncDesc,
			Qty: Qty,
			Spec: Spec,
			PoItmId: PoItmId,
			CerNo: CerNo,
			CerExpDate: CerExpDate,
			BarCode: BarCode,
			BatNo: BatNo,
			ExpDate: Date.parseDate(ExpDate, ARG_DATEFORMAT),
			ProduceDate: ProduceDate,
			OrderDetailSubId:OrderDetailSubId,
			SxNo : sxno
		};
		var DataRecord = CreateRecordInstance(BarCodeGrid.getStore().fields, defaData);
		if (Qty > 0) {
			BarCodeGrid.getStore().add(DataRecord)
			var Rowcount = BarCodeGrid.getStore().getCount();
			var rowData = BarCodeGrid.getStore().getAt(Rowcount - 1);
			addComboData(SpecDescStore, SpecDesc, SpecDesc);
			rowData.set("SpecDesc", SpecDesc);
		}
	});
}
function QueryForSciPo(DateTime,SCIPoVendorId,SCIPoVendorDesc)
{
	if (DateTime == null || DateTime =='') 
	{return;}	
	var startDate = DateTime.split("^")[0];
	var time = DateTime.split("^")[1];
	var endDate = startDate;
	addComboData(Ext.getCmp("ImpVendor").getStore(),SCIPoVendorId,SCIPoVendorDesc);
	Ext.getCmp("ImpVendor").setValue(SCIPoVendorId);
	BarCodeGrid.removeAll();
	clear.handler();
	var Param = "" + "^" + "" + "^" + "" + "^" + startDate + "^" + time
		 + "^" + endDate + "^^^^" + gHospId;
	BarCodeGrid.store.setBaseParam('Param', Param);
	BarCodeGrid.load({
		params: {
			'Param': Param
		}
	});
}
// 保存按钮
var saveBarCode = new Ext.ux.Button({
		text: '保存',
		width: 70,
		height: 30,
		iconCls: 'page_save',
		handler: function () {
			var AllowAspWhileReceive=GetRecAdjspFlag();
			if(BatSpFlag != '1' && AllowAspWhileReceive == 'Y'){
				var rowCount = BarCodeGrid.getStore().getCount();
				AdjPriceShow(0, rowCount-1);
			}else{
				save();
			}
		}
	});
///生成调价单
function AdjPriceShow(ind,rowCount){
	try{
		var record = BarCodeGrid.getStore().getAt(ind);
		var IncRowid=record.get("IncId");
	}catch(e){}
	if(Ext.isEmpty(IncRowid)){
		//检索完所有非空行
		save();
		return;
	}
	var AdjSpUomId=record.get("BUomId");  //进价默认基本单位,因此调价单位默认基本单位
	var uomdesc=record.get("BUom");
	var ResultSp= record.get("Sp"); 
	var ResultRp=record.get("Rp");
	var incicode=record.get("IncCode");
	var incidesc=record.get("IncDesc");
	var StkGrpType = Ext.getCmp("StkGrpType").getValue();
	var strParam=gGroupId+"^"+gLocId+"^"+gUserId;
	var url=DictUrl + "ingdrecaction.csp?actiontype=GetPrice&InciId="+IncRowid+"&UomId="+AdjSpUomId+"&StrParam="+strParam;
	var pricestr=ExecuteDBSynAccess(url);
	var priceArr=pricestr.split("^");
	var PriorRp=priceArr[0];
	var PriorSp=priceArr[1];
	var data = IncRowid + "^" + AdjSpUomId + "^" + PriorSp + "^" + ResultRp + "^" + gUserId
			+ "^" +PriorRp+"^"+ResultSp+"^"+StkGrpType+"^"+gLocId+ "^" +incicode
			+ "^" +incidesc+ "^" +uomdesc;
	var adjspFlag=tkMakeServerCall("web.DHCSTM.INAdjSalePrice","CheckItmAdjSp",IncRowid,"");
	if((IncRowid!="")&&(Number(PriorSp)!=Number(ResultSp))&&(adjspFlag!=1)){
		var ret=confirm(incidesc+"价格发生变化，是否生成调价单?");
		if (ret==true){
			SetAdjPrice(data,ind,rowCount,AdjPriceShow);	//循环调用
		}else{
			if(ind >= rowCount){
				save();
			}else{
				AdjPriceShow(++ind,rowCount);}
		}
	}else{
		if(ind >= rowCount){
			save();
		}else{
			AdjPriceShow(++ind,rowCount);}
	}
}

var printBarCode = new Ext.Toolbar.Button({
		text: '打印条码',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function (button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var count = BarCodeGrid.getCount();
			for (var rowIndex = 0; rowIndex < count; rowIndex++) {
				var RowData = BarCodeGrid.getAt(rowIndex);
				var print = RowData.get('print');
				if (print != "Y") {
					continue;
				}
				var BarCode = RowData.get('BarCode');
				PrintBarcode(BarCode);
			}
		}
	});
var printBarCode2 = new Ext.Toolbar.Button({
		text: '打印条码2次',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function (button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var count = BarCodeGrid.getCount();
			for (var rowIndex = 0; rowIndex < count; rowIndex++) {
				var RowData = BarCodeGrid.getAt(rowIndex);
				var print = RowData.get('print');
				if (print != "Y") {
					continue;
				}
				var BarCode = RowData.get('BarCode');
				PrintBarcode(BarCode,2);
			}
		}
	});
var printBarCodeTotal = new Ext.Toolbar.Button({
		text: '打印本页条码',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function (button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var rowsCount = BarCodeGrid.getCount();
			for (var n = 0; n < rowsCount; n++) {
				var RowData = BarCodeGrid.getAt(n);
				var BarCode = RowData.get('BarCode');
				PrintBarcode(BarCode);
			}
		}
	});
var printBarCodeTotal2 = new Ext.Toolbar.Button({
		text: '打印本页条码2次',
		iconCls: 'page_print',
		width: 70,
		height: 30,
		handler: function (button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var rowsCount = BarCodeGrid.getCount();
			for (var n = 0; n < rowsCount; n++) {
				var RowData = BarCodeGrid.getAt(n);
				var BarCode = RowData.get('BarCode');
				PrintBarcode(BarCode,2);
			}
		}
	});

// 清空按钮
var clearBarCode = new Ext.Toolbar.Button({
		text: '清空',
		tooltip: '点击清空',
		width: 70,
		height: 30,
		iconCls: 'page_clearscreen',
		handler: function () {
			inciDr = "";
			clearPanel(formPanel);
			Ext.getCmp("StkGrpType").getStore().load();
			Ext.getCmp('startDate').setValue(new Date().add(Date.DAY,-30));
			Ext.getCmp('endDate').setValue(new Date());
			Ext.getCmp("LocField").setValue("");
			
			BarCodeGrid.removeAll();
			
		}
	});

// 清空按钮条码
var clear = new Ext.Toolbar.Button({
		text: '清空条码信息',
		tooltip: '点击清空',
		width: 70,
		height: 30,
		iconCls: 'page_delete',
		handler: function () {
			BarcodeArr = [];
		}
	});

function save() {
	var CreateUser = gUserId;
	var StkGrpId = Ext.getCmp("StkGrpType").getValue();
	var MainInfo = CreateUser + "^" + StkGrpId + "^" + gLocId;
	var ListDetail = BarCodeGrid.getModifiedInfo();
	if (ListDetail == "") {
		Msg.info("warning", "没有需要保存的内容!");
		return;
	}
	if (BarCodeGrid.activeEditor != null) {
		this.activeEditor.completeEdit();
	}
	var mr = BarCodeGrid.getModifiedRecords();
	for (var i = 0, mrLen = mr.length; i < mrLen; i++) {
		var record = mr[i];
		var inci = record.get('IncId');
		if ((inci == "") || (inci == null)) {
			continue;
		}
		var Code = record.get('IncCode');
		var ProduceDate = record.get('ProduceDate');
		var CerDate = record.get("CerExpDate");
		if (!Ext.isEmpty(ProduceDate) && !Ext.isEmpty(CerDate) && (CerDate <= ProduceDate)) {
			Msg.info("warning", "物资代码为" + Code + "生产日期超过注册证效期!请修正后重新保存");
			return false;
		}
		var vendorId = record.get("VendorId");
		if (gItmTrackParam[7] == "Y" && vendorId == "") {
			Msg.info("warning", "物资代码为" + Code + "的供应商未填,不能保存!");
			return false;
		}
		var qty = record.get("Qty");
		if (qty > 1000) {
			Msg.info("warning", "数量不能超过1000!");
			return false;
		}
	}
	var url = DictUrl + "barcodeaction.csp?actiontype=save";
	var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
	Ext.Ajax.timeout=120000;
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		params: {
			MainInfo: MainInfo,
			ListDetail: ListDetail
		},
		waitMsg: '处理中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 刷新界面
				var datetime = jsonData.info;
				var startDate = datetime.split("^")[0];
				var time = datetime.split("^")[1];
				var endDate = startDate;
				Msg.info("success", "保存成功!");
				clear.handler();
				var Param = "" + "^" + "" + "^" + "" + "^" + startDate + "^" + time
					 + "^" + endDate + "^^^^" + gHospId;
				BarCodeGrid.store.setBaseParam('Param', Param);
				BarCodeGrid.load({
					params: {
						'Param': Param
					}
				});
			} else {
				Msg.info("error", "保存失败!" + jsonData.info);
			}
			loadMask.hide();
		},
		scope: this
	});
}
// 保存按钮
var copybutton = new Ext.Button({
		text: '复制批号效期',
		width: 70,
		height: 30,
		iconCls: 'page_save',
		handler: function () {
			try {
				var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
				var batno = BarCodeGrid.getAt(row - 1).get('BatNo');
				var expdate = BarCodeGrid.getAt(row - 1).get('ExpDate');
				BarCodeGrid.getAt(row).set("BatNo", batno);
				BarCodeGrid.getAt(row).set("ExpDate", expdate);
				var col = GetColIndex(BarCodeGrid, 'BatNo');
				if (row + 1 < BarCodeGrid.getCount()) {
					BarCodeGrid.startEditing(row + 1, col);
				}
			} catch (e) {}
		}
	});

var saveImp = new Ext.ux.Button({
		id: "saveImp",
		text: '保存入库单',
		tooltip: '点击保存',
		iconCls: 'page_save',
		handler: function () {
			if (CheckDataBeforeSave() == true) {
				CheckVendor();
			}
		}
	});

function CheckDataBeforeSave() {
	var nowdate = new Date();
	// 判断入库部门和供货商是否为空
	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "请选择入库部门!");
		return false;
	}
	var VenId = Ext.getCmp("ImpVendor").getValue();
	if (VenId == null || VenId.length <= 0) {
		Msg.info("warning", "请选择供应商!");
		return false;
	}
	var StkGrpType = Ext.getCmp("StkGrpType").getValue();
	if (Ext.isEmpty(StkGrpType)) {
		Msg.info("warning", "类组不能为空!");
		return false;
	}
	var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
	if (Ext.isEmpty(SourceOfFund)) {
		//Msg.info("warning", "资金来源不能为空!");
		//return false;
	}
	var rowCount = BarCodeGrid.getStore().getCount();
	var count = 0;
	for (var i = 0; i < rowCount; i++) {
		var item = BarCodeGrid.getStore().getAt(i).get("IncId");
		if (item != "") {
			count++;
		}
	}
	if (rowCount <= 0 || count <= 0) {
		Msg.info("warning", "请输入入库明细!");
		return false;
	}
	for (var i = 0; i < rowCount; i++) {
		SetGridBgColor(BarCodeGrid, i, "white");
	}
	
	for (var i = 0; i < rowCount; i++) {
		var rowData = BarCodeGrid.getStore().getAt(i);
		
		var ExpReq = rowData.get('ExpReq');
		var item = rowData.get("IncId");
		var expDateValue = rowData.get("ExpDate");
		var ExpDate = new Date(Date.parse(expDateValue));
		if ((ExpReq == 'R') && (item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
			Msg.info("warning", "第"+(i+1)+"行有效期不能小于或等于当前日期!");
			var col = GetColIndex(BarCodeGrid, 'ExpDate');
			BarCodeGrid.startEditing(i, col);
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		
		var BatchReq = rowData.get('BatchReq');
		var BatchNo = rowData.get('BatNo');
		if ((BatchReq == 'R') && (item != "") && (BatchNo == '')) {
			Msg.info("warning", "第"+(i+1)+"行批号不可为空!");
			var col = GetColIndex(BarCodeGrid, 'BatNo');
			BarCodeGrid.startEditing(i, col);
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		
		var qty = BarCodeGrid.getStore().getAt(i).get("Qty");
		if ((item != "") && (qty == null || qty <= 0)) {
			Msg.info("warning", "第"+(i+1)+"行入库数量不能小于或等于0!");
			var col = GetColIndex(BarCodeGrid, 'Qty');
			BarCodeGrid.startEditing(i, col);
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		var realPrice = BarCodeGrid.getAt(i).get("Rp");
		if ((item != "") && (realPrice == null || realPrice <= 0)) {
			Msg.info("warning", "入库进价不能小于或等于0!");
			var col = GetColIndex(BarCodeGrid, 'Rp');
			BarCodeGrid.startEditing(i, col);
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
	}
	return true;
}

function CheckVendor() {
	var VenId = Ext.getCmp("ImpVendor").getValue();
	var rowCount = BarCodeGrid.getStore().getCount();
	var count = 0;
	for (var i = 0; i < rowCount; i++) {
		var vendor = BarCodeGrid.getStore().getAt(i).get("VendorId");
		if (vendor != "" && vendor != VenId) {
			count++;
		}
	}
	if (count > 0) {
		Ext.MessageBox.show({
			title: '提示',
			msg: "存在不同供应商,是否继续保存?",
			buttons: Ext.MessageBox.YESNO,
			fn: function (btn) {
				if (btn == 'yes') {
					SaveImp();
				}
			}
		});
	} else {
		SaveImp();
	}
}

/**
 * 保存入库单
 */
function SaveImp() {
	var Ingr = '';
	var VenId = Ext.getCmp("ImpVendor").getValue();
	var Completed = 'N';
	var LocId = Ext.getCmp("PhaLoc").getValue();
	var CreateUser = gUserId;
	var ExchangeFlag = 'N';
	var PresentFlag = 'N';
	var IngrTypeId = ""; //正常入库
	var PurUserId = "";
	var StkGrpId = Ext.getCmp("StkGrpType").getValue();
	var PoId = ""; //订单id
	var SourceOfFund = Ext.getCmp('SourceOfFund').getValue();
	var ToLoc = Ext.getCmp('ToLoc').getValue();
	var Carrid=Ext.getCmp('INFOPbCarrier').getValue();
	var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^" + ExchangeFlag
		 + "^" + IngrTypeId + "^" + PurUserId + "^" + StkGrpId + "^" + PoId + '^' + ''
		 + '^' + SourceOfFund + '^' + ToLoc+"^^^^^^"+Carrid;
	var ListDetail = "";
	var rowCount = BarCodeGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = BarCodeGrid.getStore().getAt(i);
		var Ingri = rowData.get('Ingri');
		if (!Ext.isEmpty(Ingri)) {
			continue; //已经入库的,过滤
		}
		var IncId = rowData.get("IncId");
		if (Ext.isEmpty(IncId)) {
			continue;
		}
		var BatchNo = rowData.get("BatNo");
		var ExpDate = Ext.util.Format.date(rowData.get("ExpDate"), ARG_DATEFORMAT);
		var ManfId = rowData.get("ManfId");
		var IngrUomId = rowData.get("BUomId");
		if (Ext.isEmpty(IngrUomId)) {
			Msg.info('error', '未取到单位信息,请核实!');
			return;
		}
		var RecQty = rowData.get("Qty");
		var Rp = rowData.get("Rp");
		var Sp = rowData.get("Sp");
		var NewSp = Sp;
		var SxNo = rowData.get('SxNo');
		var InvNo = '';
		var InvDate = '';
		var PoItmId = rowData.get("PoItmId");
		var BarCode = rowData.get("BarCode");
		var dhcit = rowData.get('InctrackId');
		if (Ext.isEmpty(dhcit)) {
			Msg.info('warning', '第' + (i + 1) + '行条码未注册!');
			return;
		}
		var CerNo = rowData.get("CerNo");
		var CerExpDate = Ext.util.Format.date(rowData.get("CerExpDate"), ARG_DATEFORMAT);
		var SpecDesc = rowData.get('SpecDesc');
		var OrderDetailSubId=rowData.get('OrderDetailSubId');
		var str = Ingri + "^" + IncId + "^" + BatchNo + "^" + ExpDate + "^" + ManfId
			+ "^" + IngrUomId + "^" + RecQty + "^" + Rp + "^" + NewSp + "^" + SxNo
			+ "^" + InvNo + "^" + InvDate + "^"+PoItmId + "^^"
			+ "^^^" + BarCode + "^^" + CerNo
			+ "^" + CerExpDate + "^^" + SpecDesc + "^"+OrderDetailSubId+"^"
			+ "^" + Sp;
		if (ListDetail == "") {
			ListDetail = str;
		} else {
			ListDetail = ListDetail + RowDelim + str;
		}
	}
	if (ListDetail==""){
		Msg.info("warning","没有需要入库的条码!");
		return;
	}
	var url = DictUrl
		 + "ingdrecaction.csp?actiontype=Save";
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		params: {
			Ingr: Ingr,
			MainInfo: MainInfo,
			ListDetail: ListDetail
		},
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 刷新界面
				var IngrRowid = jsonData.info;
				Msg.info("success", "保存成功!");
				// 跳转到入库制单界面
				window.location.href = 'dhcstm.ingdrechv.csp?Rowid=' + IngrRowid + '&QueryFlag=1';
			} else {
				var ret = jsonData.info;
				if (ret == -99) {
					Msg.info("error", "加锁失败,不能保存!");
				} else if (ret == -2) {
					Msg.info("error", "生成入库单号失败,不能保存!");
				} else if (ret == -3) {
					Msg.info("error", "保存入库单失败!");
				} else if (ret == -4) {
					Msg.info("error", "未找到需更新的入库单,不能保存!");
				} else if (ret == -5) {
					Msg.info("error", "保存入库单明细失败!");
				} else {
					Msg.info("error", "部分明细保存不成功：" + ret);
				}
			}
		},
		scope: this
	});
}

var formPanel = new Ext.ux.FormPanel({
		title: '高值条码生成(注册)',
		trackResetOnLoad: true,
		tbar: [findBarCode, '-', addBarCode, '-', clearBarCode, '-', saveBarCode, '-', ImportButton,
			'-', printBarCode, '-', printBarCodeTotal, '-', printBarCode2, '-', printBarCodeTotal2, '-', copybutton,
			'-', saveImp],
		items: [{
				layout: 'column',
				items: [{
						columnWidth: .7,
						xtype: 'fieldset',
						title: '查询条件',
						layout: 'column',
						style: 'padding:5px 0px 0px 5px',
						defaults: {
							border: false,
							columnWidth: .33,
							xtype: 'fieldset'
						},
						items: [{
								items: [BarCodeField, startDate, endDate,LocField]
							}, {
								items: [StkGrpType, M_InciCode, M_InciDesc,RegFlag]
							}, {
								items: [Vendor, RequestPhaLoc, BatNo]
							}
						]
					}, {
						columnWidth: .3,
						xtype: 'fieldset',
						title: '入库选项',
						layout: 'column',
						style: 'padding:5px 0px 0px 5px;margin:0px 0px 0px 5px;',
						defaults: {
							border: false,
							xtype: 'fieldset'
						},
						items: [{
								columnWidth: .75,
								items: [PhaLoc, ImpVendor, SourceOfFund, ToLoc,INFOPbCarrier]
							}, {
								columnWidth: .25,
								items: [VirtualFlag]
							}
						]
					}
				]
			}
		]
	});

Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, BarCodeGrid],
			renderTo: 'mainPanel'
		});
	RefreshGridColSet(BarCodeGrid, "DHCSTCOMMONM"); //根据自定义列设置重新配置列
});

function GetRecAdjspFlag() {
	var RecParams=tkMakeServerCall("web.DHCSTM.DHCINGdRec","GetParamProp",gGroupId,gLocId,gUserId);
	var AllowAspWhileReceive=RecParams.split("^")[17];
	return AllowAspWhileReceive;
}
