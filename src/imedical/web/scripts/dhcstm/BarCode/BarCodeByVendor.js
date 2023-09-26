// 名称:供应商通过小程序打印条码后的验收处理
// 编写人：徐超	2016-04-25改写,独立出js(望京)
// 编写日期:2013-09-17
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gHospId = session['LOGON.HOSPID'];
var DrugListFlag = 0;// 标志 用意判断是查询还是录入
var inciDr = "";
var BarcodeArr = [];

/**
 * 调用物资窗体并返回结果
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N",
				"0", "", getDrugList, "", "",
				"", "", "", "", "",
				"", "Y");
	}
}

/**
 * 返回方法
 */
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}

	inciDr = record.get("InciDr");
	var inciCode = record.get("InciCode");
	var inciDesc = record.get("InciDesc");
	var Spec = record.get("Spec");
	var pbrp= record.get("PbRp");
	var PFac=record.get("PFac");
	var pSp=record.get("pSp");
	var CertNo=record.get("CertNo");
	var CertExpDate=record.get("CertExpDate");

	if (DrugListFlag == 0) {
		Ext.getCmp("M_InciDesc").setValue(inciDesc);
		Ext.getCmp("M_InciCode").setValue(inciCode);
	} else {
		var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
		// 选中行
		var row = cell[0];
		var col = cell[1];
		var HVFlag = record.get("HVFlag");
		if (HVFlag == 'N') {
			Msg.info("warning", "该材料不是高值材料!");
			BarCodeGrid.startEditing(row, col);
			return;
		}
		var rowData = BarCodeGrid.getStore().getAt(row);
		rowData.set("IncId", inciDr);
		rowData.set("IncCode", inciCode);
		rowData.set("IncDesc", inciDesc);
		rowData.set('Spec', Spec);
		rowData.set('Qty', 1);
		rowData.set('PbRp',pbrp);
		//rowData.set('Sp',pSp);
		//rowData.set('Marginnow',Marginnow);
		rowData.set('CerNo',CertNo);
		rowData.set('CerExpDate',toDate(CertExpDate));
		var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;   
		//取其它物资信息
		var url = DictUrl + "ingdrecaction.csp?actiontype=GetItmInfo&IncId=" + inciDr+"&Params="+Params;
		var response=ExecuteDBSynAccess(url);
		var jsonData=Ext.util.JSON.decode(response);
		if(jsonData.success=='true'){
		var info=jsonData.info;
			if(info!=null || info!=''){
				var data=jsonData.info.split("^");
				addComboData(PhManufacturerStore, data[0], data[1]);
				rowData.set("ManfId", data[0]);
				rowData.set("PurUomId", data[2]);
				var ConFac = data[11];
				rowData.set("Rp",Number(data[23]));			//2016-01-21 按基本单位处理
				rowData.set("Sp", Number(data[24]));
				rowData.set("NewSp", Number(data[24]));
//				rowData.set("Rp",Number(data[4]));
//				rowData.set("Sp", Number(data[5]));
//				rowData.set("NewSp", Number(data[5]));
				rowData.set("BatNo", data[6]);
				rowData.set("ExpDate", toDate(data[7]));
				rowData.set("BUomId", data[10]);
				var Marginnow = '';
				if(Number(data[4]) > 0){
					Marginnow = accSub(accDiv(Number(data[5]), Number(data[4])), 1);
					Marginnow=Marginnow.toFixed(3)
				}
				rowData.set('Marginnow',Marginnow);
			}
		}
		var colIndex = GetColIndex(BarCodeGrid, 'Qty');
		BarCodeGrid.startEditing(row, colIndex);
	}
}

/**
 * 根据inci_rowid获取厂商,规格等明细信息
 * @param {} inciDr
 */
function getDrugListDetail(inciDr, rowData) {
	var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
	var row = cell[0];
	
	rowData.set("IncId", inciDr);
	
	var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;
	var info = tkMakeServerCall('web.DHCSTM.DHCINGdRec', 'GetItmInfo', inciDr, Params);
	if(Ext.isEmpty(info)){
		Msg.info('error', '条码信息获取错误!');
		return false;
	}else{
		var data=info.split("^");
		rowData.set("IncCode", data[26]);
		rowData.set("IncDesc", data[27]);
		addComboData(PhManufacturerStore, data[0], data[1]);
		rowData.set("ManfId", data[0]);
		rowData.set("PurUomId", data[2]);
		rowData.set('Qty', 1);
		rowData.set("Rp",Number(data[23]));			//2016-01-21 按基本单位处理
		rowData.set("Sp", Number(data[24]));
		rowData.set("NewSp", Number(data[24]));
		rowData.set('Spec', data[17]);
//		rowData.set("BatNo", data[6]);				//2017-06-15 通过条码引入
//		if(Ext.isEmpty(rowData.get('ExpDate'))){
//			rowData.set("ExpDate", toDate(data[7]));
//		}
		rowData.set("BUomId", data[10]);
		var Marginnow = '';
		if(Number(data[4]) > 0){
			Marginnow = accDiv(Number(data[5]), Number(data[4]));
		}
		rowData.set('Marginnow',Marginnow);
		rowData.set('CerNo', data[28]);
		rowData.set('CerExpDate',toDate(data[29]));
		var colIndex = GetColIndex(BarCodeGrid, 'Rp');
		BarCodeGrid.startEditing(row, colIndex);
	}
}

//入库科室
var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '科室',
			id : 'PhaLoc',
			anchor : '90%',
			emptyText : '科室...',
			groupId:session['LOGON.GROUPID']
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
					var phaloc=Ext.getCmp("PhaLoc").getValue();
					var info = tkMakeServerCall('web.DHCSTM.Common.UtilCommon','GetMainLoc',phaloc);
					var url="dhcstm.utilcommon.csp?actiontype=GetMainLoc&loc="+phaloc;
					var infoArr=info.split("^");
					var vituralLoc=infoArr[0],vituralLocDesc=infoArr[1];
					addComboData(Ext.getCmp("PhaLoc").getStore(),vituralLoc,vituralLocDesc);
					Ext.getCmp("PhaLoc").setValue(vituralLoc);
				}else{
					SetLogInDept(Ext.getCmp("PhaLoc").getStore(), "PhaLoc");
				}
			}
		}
	});
VirtualFlag.setValue(true);

//入库供应商
var ImpVendor = new Ext.ux.VendorComboBox({
			fieldLabel : '入库供应商',
			id : 'ImpVendor',
			anchor : '90%'
		});

var SourceOfFund = new Ext.ux.ComboBox({
	fieldLabel : '资金来源',
	id : 'SourceOfFund',
	anchor : '90%',
	store : SourceOfFundStore
});

var startDate = new Ext.ux.DateField({
			id : 'startDate',
			allowBlank : true,
			fieldLabel : '起始日期',
			anchor : '95%',
			value : new Date()
		});
// 截止日期
var endDate = new Ext.ux.DateField({
			id : 'endDate',
			allowBlank : true,
			fieldLabel : '截止日期',
			anchor : '95%',
			value : new Date()
		});
// 类组
var StkGrpType = new Ext.ux.StkGrpComboBox({
			id : 'StkGrpType',
			fieldLabel : '<font color=red>*类组</font>',
			StkType : App_StkTypeCode, // 标识类组类型
			UserId : gUserId,
			LocId : gLocId,
			anchor : '95%'
		});

var BarCodeField = new Ext.form.TextField({
			id : 'BarCodeField',
			fieldLabel : '条形码',
			allowBlank : true,
			anchor : '95%',
			selectOnFocus : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					findBarCode.handler()	
					}
				}
			}			
		});
var BatNo = new Ext.form.TextField({
			id : 'BatNo',
			fieldLabel : '批号',
			allowBlank : true,
			anchor : '95%',
			selectOnFocus : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
					findBarCode.handler()	
					}
				}
			}		
		});
// 物资编码
var M_InciCode = new Ext.form.TextField({
			fieldLabel : '物资编码',
			id : 'M_InciCode',
			name : 'M_InciCode',
			anchor : '95%',
			width : 150,
			disabled : true,
			valueNotFoundText : ''
		});

// 物资名称
var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '物资名称',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '95%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				},
				focus : function(field) {
					DrugListFlag = 0;
				},
				blur : function(field) {
					if (field.getValue() == "") {
						inciDr = "";
						Ext.getCmp("M_InciCode").setValue("");
					}
				}
			}
		});
//var Vendor=new Ext.ux.VendorComboBox({
//		id : 'Vendor',
//		name : 'Vendor',
//		anchor:'95%'
//	});
var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '请求部门',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'95%',
					emptyText : '请求部门...',
					defaultLoc:{}
		});
	
var Specom = new Ext.form.ComboBox({
	fieldLabel : '具体规格',
	id : 'Specom',
	name : 'Specom',
	anchor : '90%',
	width : 120,
	listWidth :210,
	store : SpecDescStore,
	valueField : 'Description',
	displayField : 'Description',
	triggerAction : 'all',
	emptyText : '具体规格...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	valueNotFoundText : '',
	listeners:({
		'beforequery':function(){
				var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
				var record = BarCodeGrid.getStore().getAt(cell[0]);
				var IncRowid = record.get("IncId");	
				var desc=this.getRawValue();
				this.store.removeAll();    //load之前remove原记录，否则容易出错
				this.store.setBaseParam('SpecItmRowId',IncRowid)
				this.store.setBaseParam('desc',desc)
				this.store.load({params:{start:0,limit:this.pageSize}})
			} 
	})
});

var Manf = new Ext.ux.ComboBox({
	fieldLabel : '厂商',
	id : 'Manf',
	store : PhManufacturerStore,
	emptyText : ' 厂商...',
	filterName : 'PHMNFName',
	params : {ScgId : 'StkGrpType'}
});

var BarCodeGridCm = [{
			header : "dhcit",
			dataIndex : 'InctrackId',
			saveColIndex : 0,
			hidden : true,
			hideable : false
		}, {
			header : "IncId",
			dataIndex : 'IncId',
			saveColIndex : 1,
			hidden : true,
			hideable : false
		}, {
			header : "物资代码",
			dataIndex : 'IncCode',
			width : 80,
			align : 'left',
			renderer : Ext.util.Format.InciPicRenderer('IncId'),
			sortable : true
		}, {
			header : "物资名称",
			dataIndex : 'IncDesc',
			width : 200,
			align : 'left',
			sortable : true,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									DrugListFlag = 1;
									var group = Ext.getCmp("StkGrpType").getValue();
									GetPhaOrderInfo(field.getValue(), group);
								}
							}
						}
					}))
		}, {
			header : "规格",
			dataIndex : 'Spec'
		}, {
			header : "数量",
			dataIndex : 'Qty',
			width : 40,
			align : 'right',
			saveColIndex : 3
		}, {
			header : "高值条码",
			dataIndex : 'BarCode',
			width : 220,
			align : 'left',
			sortable : false,
			saveColIndex : 2,
//			editable : false,		//2015-12-28 不可编辑
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var BarCode = this.getValue();
							if(Ext.isEmpty(BarCode)){
								return false;
							}
							var BarCodeArr = BarCode.split('-');
							var SerialNo = BarCodeArr[BarCodeArr.length - 1];
							if(SerialNo.length < 10){
								//流水号为yymmdd0001(年月日+4位), 长度为10
								Msg.info('warning', '流水号长度不符, 请核实录入是否正确!');
								return false;
							}
							BarCode = ToDBC(BarCode);
							field.setValue(BarCode);
							
							var ItmInfo = tkMakeServerCall('web.DHCSTM.DHCItmTrack', 'GetItmInfoByBarcode', BarCode);
							var InfoArr = ItmInfo.split('^');
							var Inci = InfoArr[0], VendorId = InfoArr[3], VendorDesc = InfoArr[4];
							if(Number(Inci) <= 0){
								Msg.info('error', '条码获取错误:' + ItmInfo);
								return;
							}
							var ExpDate = InfoArr[5], Scg = InfoArr[6], ScgDesc = InfoArr[7], BatchNo = InfoArr[8], SpecDesc = InfoArr[9];
							var ExpDate = Date.parseDate(ExpDate, 'ymd');
							var row = BarCodeGrid.getSelectedCell()[0];
							var rowData = BarCodeGrid.getAt(row);
							var ImpVendor = Ext.getCmp('ImpVendor').getValue();
							if(!Ext.isEmpty(ImpVendor) && (VendorId != ImpVendor)){
								Msg.info('warning', '该条码供应商和入库供应商不一致!');
								//这里是否做严格控制,再考虑
								//return false;
							}
							var StkGrpType = Ext.getCmp('StkGrpType').getValue();
							if(!Ext.isEmpty(StkGrpType) && (Scg != StkGrpType)){
								var count = BarCodeGrid.getStore().getCount();
								if(count == 1){
									addComboData('', Scg, ScgDesc, Ext.getCmp('StkGrpType'));
									Ext.getCmp('StkGrpType').setValue(Scg);
								}else{
									Msg.info('warning', '该条码类组和入库类组不符!');
									return false;
								}
							}
							rowData.set('VendorId', VendorId);
							rowData.set('VendorDesc', VendorDesc);
							if(ExpDate){
								rowData.set('ExpDate', ExpDate);
							}
							rowData.set('BatNo', BatchNo);
							addComboData(SpecDescStore, SpecDesc, SpecDesc);
							rowData.set('SpecDesc', SpecDesc);
							//为record set其他字段信息
							getDrugListDetail(Inci, rowData);
							addComboData(Ext.getCmp('ImpVendor').getStore(), VendorId, VendorDesc);
							Ext.getCmp('ImpVendor').setValue(VendorId);
						}
					}
				}
			}))
		}, {
			header : "供应商id",
			dataIndex : 'VendorId',
			hidden : true,
			saveColIndex : 14
		}, {
			header : "供应商",
			dataIndex : 'VendorDesc',
			width: 150
		}, {
			header : "打印",
			xtype:'checkcolumn',
			dataIndex : 'print',
			width : 40
		}, {
			header : "自带条码",
			dataIndex : 'OriginalCode',
			width : 150,
			align : 'left',
			sortable : false,
			saveColIndex : 4,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							//自带条码经常分段,这里不跳转了
							return false;
//							var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
//							var col = GetColIndex(BarCodeGrid, 'Rp')
//							BarCodeGrid.startEditing(row, col);
						}
					}
				}
			}))
		},{
			header : "PoItmId",
			dataIndex : 'PoItmId',
			saveColIndex : 5,
			hidden : true
		},{
			header : "请求单号",
			dataIndex : 'ReqNo',
			hidden : true
		},{
			header : "品牌",
			dataIndex : 'Brand',
			hidden : true
		},{
			header : "进价",
			dataIndex : 'Rp',
			width : 60,
			align : 'right',
			sortable : true,
			saveColIndex : 12,
			editor : new Ext.ux.NumberField({
						formatType : 'FmtRP',
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var cost = field.getValue();
									if (cost == null
											|| cost.length <= 0) {
										Msg.info("warning", "进价不能为空!");
										return;
									}
									if (cost <= 0) {
										Msg.info("warning",
												"进价不能小于或等于0!");
										return;
									}
									var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
									var col = GetColIndex(BarCodeGrid, 'BatNo');
									BarCodeGrid.startEditing(row, col);
								}
							}
						}
			})
		},{
			header : "批号",
			dataIndex : 'BatNo',
			width : 90,
			align : 'center',
			sortable : true,
			saveColIndex : 6,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
							var col = GetColIndex(BarCodeGrid, 'ExpDate')
							BarCodeGrid.startEditing(row, col);
						}
					}
				}
			}))
		}, {
			header : "有效期",
			xtype:'datecolumn',
			dataIndex : 'ExpDate',
			width : 100,
			align : 'center',
			sortable : true,	
			saveColIndex : 7,
			editor : new Ext.ux.DateField({
					selectOnFocus : true,
					allowBlank : false,
					listeners : {
						specialkey : function(field, e) {
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
//								var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
//								var col = GetColIndex(BarCodeGrid, 'BatNo')
//								if(row+1<BarCodeGrid.getCount()){
//									BarCodeGrid.startEditing(row+1, col);
//								}
							}
						}
					}
				})
		},{
			header : "当前售价",
			dataIndex : 'Sp',
			align : 'right'
		},{
			header : "请求科室",
			dataIndex : 'ReqLocDesc'
		},{
			header : "招标进价",
			dataIndex : 'PbRp'
		},{
			header : "加成率",
			dataIndex : 'Marginnow',
			align : 'right'
		},{
			header:"具体规格",
			dataIndex:'SpecDesc',
			saveColIndex:8,
			width:100,
			align:'left',
			sortable:true,
			editor : new Ext.grid.GridEditor(Specom),
			renderer : Ext.util.Format.comboRenderer2(Specom,"SpecDesc","SpecDesc")
		},{
			header : "注册证号",
			dataIndex : 'CerNo',
			saveColIndex:10,
			editor : new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : true
			})
		},{
			header : "注册证效期",
			xtype:'datecolumn',
			dataIndex : 'CerExpDate',
			saveColIndex:11,
			sortable : true,
			editor : new Ext.ux.DateField({
				selectOnFocus : true,
				allowBlank : true	
			})
		}, {
			header : "生产日期",
			xtype:'datecolumn',
			dataIndex : 'ProduceDate',
			width : 100,
			align : 'center',
			sortable : true,	
			saveColIndex : 9,
			editor : new Ext.ux.DateField({
					selectOnFocus : true,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
//								var ProduceDate = field.getValue();
//								if (ProduceDate == null || ProduceDate.length <= 0) {
//									Msg.info("warning", "生产日期不能为空!");
//									return;
//								}
								var col = GetColIndex(BarCodeGrid, 'BatNo')
								var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
								if(row+1<BarCodeGrid.getCount()){
									BarCodeGrid.startEditing(row+1, col);
								}
							}
						}
					}
				})
		}, {
			header : "入库单位",
			dataIndex : 'PurUomId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden:true
		}, {
			header : "基本单位",
			dataIndex : 'BUomId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden:true
		}, {
			header : "入库子表id",
			dataIndex : 'Ingri',
			width : 80,
			align : 'left',
			sortable : true,
			hidden:true
		}, {
			header : '厂商',
			dataIndex : 'ManfId',
			saveColIndex : 13,
			xtype : 'combocolumn',
			valueField : 'ManfId',
			displayField : 'ManfDesc',
			editor : Manf
		}, {
			header : "注册人员",
			dataIndex : 'User'
		}, {
			header : "注册日期",
			dataIndex : 'Date'
		}];

function paramsFn(){
	var BarCodeField = Ext.getCmp('BarCodeField').getValue();
	var StkGrpType = Ext.getCmp('StkGrpType').getValue();
	var startDate = Ext.getCmp("startDate").getValue();
	if(Ext.isEmpty(startDate)){
		Msg.info('warning', '起始日期不可为空!');
		return false;
	}
	startDate = startDate.format(ARG_DATEFORMAT);
	var endDate = Ext.getCmp("endDate").getValue();
	if(Ext.isEmpty(endDate)){
		Msg.info('warning', '截止日期不可为空!');
		return false;
	}
	endDate = endDate.format(ARG_DATEFORMAT);
	var vendor = Ext.getCmp("ImpVendor").getValue();
	if(Ext.isEmpty(vendor)){
		Msg.info('warning', '请选择入库供应商!');
		return false;
	}
	var reqloc = Ext.getCmp("RequestPhaLoc").getValue();
	var batno= Ext.getCmp("BatNo").getValue();
	var time = "";
	if (Ext.getCmp("M_InciDesc").getValue() == "") {
		inciDr = "";
	}
	var Param = BarCodeField + "^" + StkGrpType + "^" + inciDr + "^" + startDate + "^" + time
			 + "^" + endDate+"^"+vendor+"^"+reqloc+"^"+batno+"^"+gHospId;
	return {'Param' : Param};
}

function cellSelectFn(sm,rowIndex,colIndex){
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

function beforeAddFn(){
	var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();
	if (StkGrpType == null || StkGrpType.length <= 0) {
		Msg.info("warning", "请选择类组!");
		return false;
	}
}

var BarCodeGridUrl = 'dhcstm.barcodeaction.csp';
// 表格
var BarCodeGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'BarCodeGrid',
	contentColumns : BarCodeGridCm,
	smRowSelFn : cellSelectFn,
	firstFocusCell : 'BarCode',
	singleSelect:false,
	selectFirst : false,
	actionUrl : BarCodeGridUrl,
	queryAction : "query",
	idProperty : "InctrackId",
	checkProperty : "IncId",
	paramsFn : paramsFn,
	beforeAddFn : beforeAddFn,
	delRowAction : "Delete",
	delRowParam : "RowId",
	paging : false,		//2015-12-23 添加直接入库功能后,暂不使用翻页工具条
	listeners : {
		'beforeedit' : function(e) {
			var InctrackId = BarCodeGrid.getCell(e.row,"InctrackId");
			if (!Ext.isEmpty(InctrackId) && e.field!='OriginalCode'&& e.field!='BatNo'&& e.field!='ExpDate'&& e.field!='SpecDesc'&& e.field!='ProduceDate' && e.field!='Rp' && e.field!='ManfId' && e.field!='CerNo' && e.field!='CerExpDate') {
				return false;	// 控制修改 生成条码的不允许修改
			}
			if(e.field == 'BarCode'){
				if(e.record.get('IncId') != ''){
					e.cancel = true;
				}
			}
		},
		'rowcontextmenu' : function(grid,rowindex,e){
			e.preventDefault();
			grid.getSelectionModel().select(rowindex,1);
			//仅对未保存的条码明细弹出右键菜单
			if(grid.getStore().getAt(rowindex).get('InctrackId')==''){
				rightClick.showAt(e.getXY());
			}
		}
	}
});

var rightClick = new Ext.menu.Menu({
	id : 'rightClickCont',
	items: [
		{
			id : 'mnuDelete',
			handler : function(item,e){
				BarCodeGrid.deleteRow();
			},
			text : '删除'
		},{
			id : 'mnuSplit',
			handler : SplitDetail,
			text : '拆分明细'
		}
	] 
});

var rowsAdd = 1000;
function SplitDetail(item,e){
	var cell = BarCodeGrid.getSelectedCell();
	if (cell == null) {
		Msg.info("warning", "没有选中行!");
		return;
	}
	var row = cell[0];
	var record = BarCodeGrid.getStore().getAt(row);
	if(record.get('InctrackId')!=""){
		Msg.info('error','已保存条码不可拆分!');
		return;
	}
	var qty = record.get('Qty');
	var qty = (Ext.isEmpty(qty)||qty<=1)?2:record.get('Qty');
	record.set('Qty',1);
	var BarCodeStore = BarCodeGrid.getStore();
	for(var i=1;i<qty;i++){
		var newRecord = new BarCodeStore.recordType(record.copy().data, ++rowsAdd);
		BarCodeStore.insert(++row, newRecord);
	}
	BarCodeGrid.view.refresh();
}

var findBarCode = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				clear.handler();
				BarCodeGrid.load();
			}
		});

var addBarCode = new Ext.Toolbar.Button({
			text : '新建',
			iconCls : 'page_add',
			width : 70,
			height : 30,
			handler : function() {
				BarCodeGrid.removeAll();
				BarCodeGrid.addNewRow();
			}
		});
var impByPo= new Ext.Toolbar.Button({
			text : '导入订单',
			iconCls : 'page_add',
			width : 70,
			height : 30,
			handler : function() {
				
				ImportByPo(getlist);
			}
		});
function getlist(records)
		{
		records = [].concat(records);
		
		if (records == null || records == "") {
				return;
		}
		
		var count=BarCodeGrid.getCount();
		Ext.each(records,function(record,index,allItems){
			var IncId=record.get("IncId");
			var IncCode=record.get("IncCode");
			var IncDesc=record.get("IncDesc");
			var Qty=record.get("AvaBarcodeQty");
			var Spec=record.get("Spec");
			var SpecDesc=record.get("SpecDesc");
			var PoItmId=record.get("PoItmId");
			var CerNo=record.get("CerNo");
			var CerExpDate=record.get("CerExpDate");
		var defaData = {
						IncId : IncId,
						IncCode :IncCode ,
						IncDesc : IncDesc,
						Qty : Qty,
						Spec:Spec,
						SpecDesc:SpecDesc,
						PoItmId:PoItmId,
						CerNo:CerNo,
						CerExpDate:CerExpDate
					};
		var DataRecord = CreateRecordInstance(BarCodeGrid.getStore().fields,defaData);
	    if(Qty>0){BarCodeGrid.getStore().add(DataRecord);}
	});
	
		}
// 保存按钮
var saveBarCode = new Ext.ux.Button({
			text : '保存',
			width : 70,
			height : 30,
			iconCls : 'page_save',
			handler : function() {
				save();
			}
		});

var printBarCode = new Ext.Toolbar.Button({
			text : '打印条码',
			iconCls : 'page_print',
			width : 70,
			height : 30,
			handler : function(button, e) {
				DHCP_GetXMLConfig("DHCSTM_Barcode");
				var count=BarCodeGrid.getCount();
				
				for(var rowIndex=0;rowIndex<count;rowIndex++){
					
					var print=BarCodeGrid.getAt(rowIndex).get('print');
					if(print!="Y"){continue}
					//var rowIndex=BarCodeGrid.getStore().findExact("BarCode",barcode,0);
					var barcode=BarCodeGrid.getAt(rowIndex).get('BarCode');
					var IncDesc=BarCodeGrid.getAt(rowIndex).get('IncDesc');
					var Spec=BarCodeGrid.getAt(rowIndex).get('SpecDesc');
					var ReqNo=BarCodeGrid.getAt(rowIndex).get('ReqNo');
					var Brand=BarCodeGrid.getAt(rowIndex).get('Brand');
					var ReqLocDesc=BarCodeGrid.getAt(rowIndex).get('ReqLocDesc');
					var Sp=BarCodeGrid.getAt(rowIndex).get('Sp');
					var BatNo=BarCodeGrid.getAt(rowIndex).get('BatNo');
					var ExpDate=BarCodeGrid.getAt(rowIndex).get('ExpDate')
					if(Ext.isEmpty(ExpDate)){ExpDate="";}
					else{ExpDate=ExpDate.format(ARG_DATEFORMAT);}
					
					var MyPara='BarCode'+String.fromCharCode(2)+"*"+barcode+"*"
							+'^IncDesc'+String.fromCharCode(2)+IncDesc
							+'^ReqNo'+String.fromCharCode(2)+ReqNo
							+'^Brand'+String.fromCharCode(2)+Brand
							+'^Spec'+String.fromCharCode(2)+Spec
							+'^ReqLocDesc'+String.fromCharCode(2)+ReqLocDesc
							+'^Sp'+String.fromCharCode(2)+Sp
							+'^BatNo'+String.fromCharCode(2)+BatNo
							+'^ExpDate'+String.fromCharCode(2)+ExpDate;
					DHCP_PrintFun(MyPara,"");
				}
				/*
				var rowCount = BarCodeGrid.getCount();
				for (var i = 0; i < rowCount; i++) {
					var rowData = BarCodeGrid.getAt(i);
					// 新增或数据发生变化时执行下述操作
					var BarCode = rowData.get("BarCode");
					var IncDesc = rowData.get("IncDesc");
					
					fileName = "{DHCSTM_BarCodePrint.raq(BarCode=" + BarCode
							+ ";IncDesc=" + IncDesc + ";HospDesc=" + App_LogonHospDesc + ")}";
					DHCCPM_RQDirectPrint(fileName);
					
				}
				*/
			}
		});
var printBarCode2 = new Ext.Toolbar.Button({
			text : '打印条码2次',
			iconCls : 'page_print',
			width : 70,
			height : 30,
			handler : function(button, e) {
				DHCP_GetXMLConfig("DHCSTM_Barcode");
				var count=BarCodeGrid.getCount();
				
				for(var rowIndex=0;rowIndex<count;rowIndex++){
					
					var print=BarCodeGrid.getAt(rowIndex).get('print');
					if(print!="Y"){continue}
					//var rowIndex=BarCodeGrid.getStore().findExact("BarCode",barcode,0);
					var barcode=BarCodeGrid.getAt(rowIndex).get('BarCode');
					var IncDesc=BarCodeGrid.getAt(rowIndex).get('IncDesc');
					var Spec=BarCodeGrid.getAt(rowIndex).get('SpecDesc');
					var ReqNo=BarCodeGrid.getAt(rowIndex).get('ReqNo');
					var Brand=BarCodeGrid.getAt(rowIndex).get('Brand');
					var ReqLocDesc=BarCodeGrid.getAt(rowIndex).get('ReqLocDesc');
					var Sp=BarCodeGrid.getAt(rowIndex).get('Sp');
					var BatNo=BarCodeGrid.getAt(rowIndex).get('BatNo');
					var ExpDate=BarCodeGrid.getAt(rowIndex).get('ExpDate')
					if(Ext.isEmpty(ExpDate)){ExpDate="";}
					else{ExpDate=ExpDate.format(ARG_DATEFORMAT);}
					
					var MyPara='BarCode'+String.fromCharCode(2)+"*"+barcode+"*"
							+'^IncDesc'+String.fromCharCode(2)+IncDesc
							+'^ReqNo'+String.fromCharCode(2)+ReqNo
							+'^Brand'+String.fromCharCode(2)+Brand
							+'^Spec'+String.fromCharCode(2)+Spec
							+'^ReqLocDesc'+String.fromCharCode(2)+ReqLocDesc
							+'^Sp'+String.fromCharCode(2)+Sp
							+'^BatNo'+String.fromCharCode(2)+BatNo
							+'^ExpDate'+String.fromCharCode(2)+ExpDate;
					DHCP_PrintFun(MyPara,"");
					DHCP_PrintFun(MyPara,"");
				}
			
				/*
				var rowCount = BarCodeGrid.getCount();
				for (var i = 0; i < rowCount; i++) {
					var rowData = BarCodeGrid.getAt(i);
					// 新增或数据发生变化时执行下述操作
					var BarCode = rowData.get("BarCode");
					var IncDesc = rowData.get("IncDesc");
					
					fileName = "{DHCSTM_BarCodePrint.raq(BarCode=" + BarCode
							+ ";IncDesc=" + IncDesc + ";HospDesc=" + App_LogonHospDesc + ")}";
					DHCCPM_RQDirectPrint(fileName);
					
				}
				*/
			}
		});
var printBarCodeTotal = new Ext.Toolbar.Button({
	text:'打印本页条码',
    iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(button,e){
		DHCP_GetXMLConfig("DHCSTM_Barcode");
		var rowsCount=BarCodeGrid.getCount();
		var BarcodeTotalArr=[];
		for(var n=0;n<rowsCount;n++){
			var rowBarcode=BarCodeGrid.getAt(n).get('BarCode');
			BarcodeTotalArr[n]=rowBarcode;
		}
		
		for(var i=0;i<BarcodeTotalArr.length;i++){
			if(!(i in BarcodeTotalArr)){continue;}
			var barcode=BarcodeTotalArr[i];
			
			var rowIndex=BarCodeGrid.getStore().findExact("BarCode",barcode,0);
			var IncDesc=BarCodeGrid.getAt(rowIndex).get('IncDesc');
			var Spec=BarCodeGrid.getAt(rowIndex).get('SpecDesc');
			var ReqNo=BarCodeGrid.getAt(rowIndex).get('ReqNo');
			var Brand=BarCodeGrid.getAt(rowIndex).get('Brand');
			var ReqLocDesc=BarCodeGrid.getAt(rowIndex).get('ReqLocDesc');
			var Sp=BarCodeGrid.getAt(rowIndex).get('Sp');
			var BatNo=BarCodeGrid.getAt(rowIndex).get('BatNo');
			var ExpDate=BarCodeGrid.getAt(rowIndex).get('ExpDate');
			if(Ext.isEmpty(ExpDate)){ExpDate="";}
			else{ExpDate=ExpDate.format(ARG_DATEFORMAT);}
			var MyPara='BarCode'+String.fromCharCode(2)+"*"+barcode+"*"
					+'^IncDesc'+String.fromCharCode(2)+IncDesc
					+'^ReqNo'+String.fromCharCode(2)+ReqNo
					+'^Brand'+String.fromCharCode(2)+Brand
					+'^Spec'+String.fromCharCode(2)+Spec
					+'^ReqLocDesc'+String.fromCharCode(2)+ReqLocDesc
					+'^Sp'+String.fromCharCode(2)+Sp
					+'^BatNo'+String.fromCharCode(2)+BatNo
					+'^ExpDate'+String.fromCharCode(2)+ExpDate;
			DHCP_PrintFun(MyPara,"");
		}
	}
});
var printBarCodeTotal2 = new Ext.Toolbar.Button({
	text:'打印本页条码2次',
    iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(button,e){
		DHCP_GetXMLConfig("DHCSTM_Barcode");
		var rowsCount=BarCodeGrid.getCount();
		var BarcodeTotalArr=[];
		for(var n=0;n<rowsCount;n++){
			var rowBarcode=BarCodeGrid.getAt(n).get('BarCode');
			BarcodeTotalArr[n]=rowBarcode;
		}
		
		for(var i=0;i<BarcodeTotalArr.length;i++){
			if(!(i in BarcodeTotalArr)){continue;}
			var barcode=BarcodeTotalArr[i];
			
			var rowIndex=BarCodeGrid.getStore().findExact("BarCode",barcode,0);
			var IncDesc=BarCodeGrid.getAt(rowIndex).get('IncDesc');
			var Spec=BarCodeGrid.getAt(rowIndex).get('SpecDesc');
			var ReqNo=BarCodeGrid.getAt(rowIndex).get('ReqNo');
			var Brand=BarCodeGrid.getAt(rowIndex).get('Brand');
			var ReqLocDesc=BarCodeGrid.getAt(rowIndex).get('ReqLocDesc');
			var Sp=BarCodeGrid.getAt(rowIndex).get('Sp');
			var BatNo=BarCodeGrid.getAt(rowIndex).get('BatNo');
			var ExpDate=BarCodeGrid.getAt(rowIndex).get('ExpDate');
			if(Ext.isEmpty(ExpDate)){ExpDate="";}
			else{ExpDate=ExpDate.format(ARG_DATEFORMAT);}
			var MyPara='BarCode'+String.fromCharCode(2)+"*"+barcode+"*"
					+'^IncDesc'+String.fromCharCode(2)+IncDesc
					+'^ReqNo'+String.fromCharCode(2)+ReqNo
					+'^Brand'+String.fromCharCode(2)+Brand
					+'^Spec'+String.fromCharCode(2)+Spec
					+'^ReqLocDesc'+String.fromCharCode(2)+ReqLocDesc
					+'^Sp'+String.fromCharCode(2)+Sp
					+'^BatNo'+String.fromCharCode(2)+BatNo
					+'^ExpDate'+String.fromCharCode(2)+ExpDate;
			DHCP_PrintFun(MyPara,"");
			DHCP_PrintFun(MyPara,"");
		}
	}
});		
// 清空按钮
var clearBarCode = new Ext.Toolbar.Button({
			text : '清空',
			tooltip : '点击清空',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				inciDr = "";
				clearPanel(formPanel);
				BarCodeGrid.removeAll();
				formPanel.getForm().setValues({"startDate":new Date(),"endDate":new Date()});
			}
		});
		
// 清空按钮条码
var clear = new Ext.Toolbar.Button({
			text : '清空条码信息',
			tooltip : '点击清空',
			width : 70,
			height : 30,
			iconCls : 'page_delete',
			handler : function() {
				BarcodeArr=[];
			}
		});
		
function save() {
	var CreateUser = gUserId;
	var StkGrpId = Ext.getCmp("StkGrpType").getValue();
	var MainInfo = CreateUser + "^" + StkGrpId;
	var ListDetail = BarCodeGrid.getModifiedInfo();
	if (ListDetail == "") {
		Msg.info("warning", "没有需要保存的内容!");
		return;
	}
	
	if(BarCodeGrid.activeEditor!=null){this.activeEditor.completeEdit();}
	var mr = BarCodeGrid.getModifiedRecords();
	for(var i=0,mrLen=mr.length; i<mrLen; i++){
		var record = mr[i]
		var Code=record.get('IncCode')
		var ProduceDate = record.get('ProduceDate')
		var CerDate=record.get("CerExpDate");
		if (!Ext.isEmpty(ProduceDate)&&(CerDate<= ProduceDate.format(ARG_DATEFORMAT))) {
			Msg.info("warning", "物资代码为"+Code+"生产日期超过注册证效期!请修正后重新保存");
			return false;
		}
	}
	var url = DictUrl + "barcodeaction.csp?actiontype=save";
	var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
	Ext.Ajax.request({
				url : url,
				method : 'POST',
				params : {
					MainInfo : MainInfo,
					ListDetail : ListDetail
				},
				waitMsg : '处理中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON.decode(result.responseText);
					if (jsonData.success == 'true') {
						// 刷新界面
						var datetime = jsonData.info;
						var startDate = datetime.split("^")[0];
						var time = datetime.split("^")[1];
						var endDate = startDate;
						Msg.info("success", "保存成功!");
						clear.handler();
						var Param = "" + "^" + "" + "^" + "" + "^" + startDate
								+ "^" + time + "^" + endDate
						BarCodeGrid.store.setBaseParam('Param', Param);
						BarCodeGrid.load({params : {'Param': Param}});
					} else {
						Msg.info("error", "保存失败!" + jsonData.info);
					}
					loadMask.hide();
				},
				scope : this
			});
}
// 保存按钮
var copybutton = new Ext.Button({
			text : '复制批号效期',
			width : 70,
			height : 30,
			iconCls : 'page_save',
			handler : function() {
				try{
					var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
					var batno=BarCodeGrid.getAt(row-1).get('BatNo');
					var expdate=BarCodeGrid.getAt(row-1).get('ExpDate');
					BarCodeGrid.getAt(row).set("BatNo",batno);
					BarCodeGrid.getAt(row).set("ExpDate",expdate);
					var col = GetColIndex(BarCodeGrid, 'BatNo');
					if(row+1<BarCodeGrid.getCount()){
						BarCodeGrid.startEditing(row+1, col);
					}
				}catch(e){}
			}
		});

var saveImp = new Ext.ux.Button({
			id : "saveImp",
			text : '保存入库单',
			tooltip : '点击保存',
			iconCls : 'page_save',
			handler : function() {
				if(CheckDataBeforeSave() == true){
					SaveImp();
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
	if(Ext.isEmpty(StkGrpType)){
		Msg.info("warning", "类组不能为空!");
		return false;
	}
	var SourceOfFund = Ext.getCmp("SourceOfFund").getValue();
	if(Ext.isEmpty(SourceOfFund)){
		//Msg.info("warning", "资金来源不能为空!");
		//return false;
	}
	// 1.判断入库物资是否为空
	var rowCount = BarCodeGrid.getStore().getCount();
	// 有效行数
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
	// 2.重新填充背景
	for (var i = 0; i < rowCount; i++) {
		SetGridBgColor(BarCodeGrid, i, "white");
	}
	// 4.物资信息输入错误
	for (var i = 0; i < rowCount; i++) {
		var RowData = BarCodeGrid.getAt(i);
		var BarCode = RowData.get('BarCode');
		var expDateValue = RowData.get("ExpDate");
		var item = RowData.get("IncId");
		var ExpDate = new Date(Date.parse(expDateValue));
		if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
			Msg.info("warning", "有效期不能小于或等于当前日期!");
			var cell = BarCodeGrid.getSelectionModel()
					.getSelectedCell();
			 
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		var qty = RowData.get("Qty");
		if ((item != "") && (qty == null || qty <= 0)) {
			Msg.info("warning", "入库数量不能小于或等于0!");
			var cell = BarCodeGrid.getSelectionModel()
					.getSelectedCell();
			
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		var realPrice = RowData.get("Rp");
		if ((item != "")&& (realPrice == null || realPrice <= 0)) {
			Msg.info("warning", "入库进价不能小于或等于0!");
			var cell = BarCodeGrid.getSelectionModel()
					.getSelectedCell();
			
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		var VendorId = RowData.get('VendorId');
		if(VendorId != VenId){
			Msg.info('error', '条码 ' + BarCode + ' 供应商不符!');
			return false;
		}
	}
	
	return true;
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
	var ExchangeFlag ='N';
	var PresentFlag = 'N';
	var IngrTypeId = "";    //正常入库		
	var PurUserId =""
	var StkGrpId = Ext.getCmp("StkGrpType").getValue();
	var PoId="";  //订单id
	var SourceOfFund = Ext.getCmp('SourceOfFund').getValue();
	
	var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^" + ExchangeFlag 
			+ "^" + IngrTypeId + "^" + PurUserId + "^"+ StkGrpId +"^"+ PoId + '^' + ''
			+ '^' + SourceOfFund;
	var ListDetail="";
	var rowCount = BarCodeGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		var rowData = BarCodeGrid.getStore().getAt(i);
		var Ingri = rowData.get('Ingri');
		if(!Ext.isEmpty(Ingri)){
			continue;	//已经入库的,过滤
		}
		var IncId = rowData.get("IncId");
		if(Ext.isEmpty(IncId)){
			continue;
		}
		var BatchNo = rowData.get("BatNo");
		var ExpDate =Ext.util.Format.date(rowData.get("ExpDate"),ARG_DATEFORMAT);
		var ManfId = rowData.get("ManfId");
		var IngrUomId = rowData.get("BUomId");
		if(Ext.isEmpty(IngrUomId)){
			Msg.info('error', '未取到单位信息,请核实!');
			return;
		}
		var RecQty = rowData.get("Qty");
		var Rp = rowData.get("Rp");
		var Sp = rowData.get("Sp");
		var NewSp = Sp;
		var SxNo ='';
		var InvNo ='';
		var InvDate ='';
		var PoItmId="";
		var BarCode=rowData.get("BarCode");
		var dhcit = rowData.get('InctrackId');
		if(Ext.isEmpty(dhcit)){
			Msg.info('warning', '第' + (i+1) + '行条码未注册!');
			return;
		}
		var CerNo = rowData.get("CerNo");
		var CerExpDate = Ext.util.Format.date(rowData.get("CerExpDate"),ARG_DATEFORMAT);
		var SpecDesc = rowData.get("SpecDesc");
		var str = Ingri + "^" + IncId + "^"	+ BatchNo + "^" + ExpDate + "^" + ManfId
				+ "^" + IngrUomId + "^" + RecQty+ "^" + Rp + "^" + NewSp + "^" + SxNo 
				+ "^" + InvNo + "^" + InvDate + "^^^"
				+ "^^^" + BarCode + "^^" + CerNo
				+ "^" + CerExpDate + "^^" + SpecDesc + "^^"
				+ "^" + Sp;
		if(ListDetail == ""){
			ListDetail = str;
		}else{
			ListDetail = ListDetail + RowDelim + str;
		}
	}
	var url = DictUrl
			+ "ingdrecaction.csp?actiontype=Save";
	Ext.Ajax.request({
				url : url,
				method : 'POST',
				params : {Ingr:Ingr, MainInfo:MainInfo, ListDetail:ListDetail},
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						// 刷新界面
						var IngrRowid = jsonData.info;
						Msg.info("success", "保存成功!");
						// 7.显示入库单数据
						// 跳转到入库制单界面
						window.location.href='dhcstm.ingdrechv.csp?Rowid='+IngrRowid+'&QueryFlag=1';

					} else {
						var ret=jsonData.info;
						if(ret==-99){
							Msg.info("error", "加锁失败,不能保存!");
						}else if(ret==-2){
							Msg.info("error", "生成入库单号失败,不能保存!");
						}else if(ret==-3){
							Msg.info("error", "保存入库单失败!");
						}else if(ret==-4){
							Msg.info("error", "未找到需更新的入库单,不能保存!");
						}else if(ret==-5){
							Msg.info("error", "保存入库单明细失败!");
						}else {
							Msg.info("error", "部分明细保存不成功："+ret);
						}
						
					}
				},
				scope : this
			});
}
	
var formPanel = new Ext.ux.FormPanel({
			title : '供应商高值条码验收',
			labelWidth : 60,
			trackResetOnLoad : true,
			tbar : [findBarCode, '-', addBarCode, '-', clearBarCode, '-', saveBarCode,		//'-',impByPo,
				'-', printBarCode, '-', printBarCodeTotal,'-',printBarCode2,'-',printBarCodeTotal2,'-',copybutton,
				'-', saveImp],
			layout : 'column',
			items : [{
					columnWidth : .7,
					xtype : 'fieldset',
					title : '查询条件',
					layout : 'column',
					items : [{
								columnWidth : .33,
								layout : 'form',
								items : [BarCodeField, startDate, endDate]
							}, {
								columnWidth : .33,
								layout : 'form',
								items : [StkGrpType, M_InciCode, M_InciDesc]
							}, {
								columnWidth : .33,
								layout : 'form',
								items : [RequestPhaLoc, BatNo]
							}]
				}, {
					columnWidth : .3,
					xtype : 'fieldset',
					title : '入库选项',
					layout : 'column',
					labelWidth : 100,
					items : [{
								columnWidth : .75,
								layout : 'form',
								items : [PhaLoc, ImpVendor, SourceOfFund]
							}, {
								columnWidth : .25,
								layout : 'form',
								items : [VirtualFlag]
							}]
				}]
		});

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [formPanel, BarCodeGrid],		//reportPanel
				renderTo : 'mainPanel'
			});
});