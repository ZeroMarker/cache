// 名称:供应商excel准备条码信息,医院验收处理(跟台高值-宁医大模式)

var impWindow = null;
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
					Marginnow = accDiv(Number(data[5]), Number(data[4]));
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

//入库供应商
var ImpVendor = new Ext.ux.VendorComboBox({
			fieldLabel : '<font color=red>*供应商</font>',
			id : 'ImpVendor',
			anchor : '90%'
		});

var startDate = new Ext.ux.DateField({
			id : 'startDate',
			allowBlank : true,
			fieldLabel : '起始日期',
			anchor : '90%',
			value : new Date()
		});
// 截止日期
var endDate = new Ext.ux.DateField({
			id : 'endDate',
			allowBlank : true,
			fieldLabel : '截止日期',
			anchor : '90%',
			value : new Date()
		});
// 类组
var StkGrpType = new Ext.ux.StkGrpComboBox({
			id : 'StkGrpType',
			fieldLabel : '类组',
			StkType : App_StkTypeCode, // 标识类组类型
			UserId : gUserId,
			LocId : gLocId,
			anchor : '90%'
		});

var BarCodeField = new Ext.form.TextField({
			id : 'BarCodeField',
			fieldLabel : '条形码',
			allowBlank : true,
			anchor : '90%',
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
			anchor : '90%',
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
			anchor : '90%',
			width : 150,
			disabled : true,
			valueNotFoundText : ''
		});

// 物资名称
var M_InciDesc = new Ext.form.TextField({
			fieldLabel : '物资名称',
			id : 'M_InciDesc',
			name : 'M_InciDesc',
			anchor : '90%',
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

var OriginalCode = new Ext.form.TextField({
	id : 'OriginalCode',
	fieldLabel : '自带条码',
	allowBlank : true,
	anchor : '90%',
	selectOnFocus : true,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				findBarCode.handler();
			}
		}
	}
});

var BatchCode = new Ext.form.TextField({
	id : 'BatchCode',
	fieldLabel : '批次码',
	allowBlank : true,
	anchor : '90%',
	selectOnFocus : true,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				findBarCode.handler();
			}
		}
	}
});

var RequestPhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '请求部门',
	id : 'RequestPhaLoc',
	name : 'RequestPhaLoc',
	anchor:'90%',
	emptyText : '请求部门...',
	defaultLoc:{},
	hidden : true
});

var StatusFlag = new Ext.form.RadioGroup({
	id : 'StatusFlag',
	hideLabel : true,
	items : [
		{boxLabel:'未使用',name:'StatusFlag',id:'StatusFlag_Temp',inputValue:'Temp',checked:true},
		{boxLabel:'已使用',name:'StatusFlag',id:'StatusFlag_Used',inputValue:'Used'}
	]
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
			editable : false,
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
			saveColIndex : 2
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
			hidden : true,
			width : 40
		}, {
			header : "删除",
			xtype:'checkcolumn',
			dataIndex : 'DeleteCheck',
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
			header : "批次码",
			dataIndex : 'BatchCode',
			saveColIndex : 17,
			allowBlank : false,
//			editable : true,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				listeners : {
					specialkey : function(field, e) {
//						if (e.getKey() == Ext.EventObject.ENTER) {
//							var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
//							var col = GetColIndex(BarCodeGrid, 'Rp');
//							BarCodeGrid.startEditing(row, col);
//						}
					}
				}
			}))
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
		}, {
			header : "条码类型",
			dataIndex : 'Stauts',
			saveColIndex : 18,
			defaultValue : 'Temp',
			hidden : true
		}
	];

function paramsFn(time){
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
	
	var reqloc = Ext.getCmp("RequestPhaLoc").getValue();
	var batno= Ext.getCmp("BatNo").getValue();
	var time = Ext.isEmpty(time)? '' : time;
	if (Ext.getCmp("M_InciDesc").getValue() == "") {
		inciDr = "";
	}
	var CreatLoc = '';
	var Status = Ext.getCmp('StatusFlag').getValue().getGroupValue();
	var OriginalCode = Ext.getCmp('OriginalCode').getValue();
	var OriginalStatus = 'Temp';
	var BatchCode = Ext.getCmp('BatchCode').getValue();
	var Param = BarCodeField + "^" + StkGrpType + "^" + inciDr + "^" + startDate + "^" + time
			+ "^" + endDate+"^"+vendor+"^"+reqloc+"^"+batno+"^"+gHospId
			+ "^" + "" + "^" + gLocId + "^" + CreatLoc + "^" + Status + '^' + OriginalCode
			+ '^' + BatchCode + '^' + OriginalStatus;
	return {'Param' : Param};
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
	//smRowSelFn : cellSelectFn,
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
	paging : false,
	listeners : {
		'beforeedit' : function(e) {
			if(e.field == 'BarCode'){
				if(e.record.get('IncId') != ''){
					e.cancel = true;
				}
			}
		}
	}
});
BarCodeGrid.AddNewRowButton.disable();


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
			text : '导入Excel',
			iconCls : 'page_add',
			width : 70,
			height : 30,
			handler : function() {
				ImportExcelFN();
			}
		});
function ImportExcelFN(){
	if (Ext.getCmp('ImpVendor').getValue()==''){
		Msg.info('error','请选择供应商!');
		Ext.getCmp('ImpVendor').focus();
		return;
	}
	
	impWindow = new ActiveXObject("MSComDlg.CommonDialog");
	impWindow.Filter = "Excel(*.xls;*xlsx)|*.xls;*.xlsx";
	impWindow.FilterIndex = 1;
	impWindow.MaxFileSize = 32767;
	impWindow.FileName = '';
	impWindow.ShowOpen();
	
	if (impWindow.Flags == 0){
		return;
	}
	var fileName = impWindow.FileName;
	if (fileName==''){
		Msg.info('error','请选择Excel文件!');
		return;
	}
	ReadFromExcel(fileName, impLine);
}

function ReadFromExcel(fileName, Fn){
	try{
		var xlsApp = new ActiveXObject("Excel.Application");
	}catch(e){
		Msg.info("warning","必须安装excel，同时浏览器允许执行ActiveX控件");
		return false;
	}

	try{
		var xlsBook = xlsApp.Workbooks.Open(fileName);
		var xlsSheet = xlsBook.Worksheets(1);		//ps: 使用第一个sheet
		ReadInfoFromExcel(xlsApp, xlsBook, xlsSheet, Fn);
	}catch(e){
		Msg.info('error', '读取Excel失败:' + e);
	}
	xlsApp.Quit();
	xlsApp = null;
	xlsBook = null;
	xlsSheet = null;
	return;
}

function ReadInfoFromExcel(xlsApp, xlsBook, xlsSheet, Fn){
	var rowsLen = xlsSheet.UsedRange.Rows.Count;
	var colsLen = xlsSheet.UsedRange.Columns.Count;
	
	var StartRow = 1;		//第2行开始
	for(var i = StartRow; i < rowsLen; i++){
		var rowData = '';
		for(var j = 0; j < colsLen; j++){
			var CellContent = xlsSheet.Cells((i + 1), (j + 1)).value;
			CellContent = typeof(CellContent)=='undefined'? '' : CellContent;
			if(!Ext.isEmpty(CellContent) && typeof(CellContent) == 'date'){
				CellContent = new Date(CellContent).format(ARG_DATEFORMAT);
			}
			if(j == 0){
				rowData = CellContent;
			}else{
				rowData = rowData + '\t' + CellContent;
			}
		}
		Fn(rowData, i+1);
	}
}
///根据行数据导入一条记录
function impLine(Str, rowNumber){
	var RowData = Str.split('\t');
	try {
		//物资代码,物资名称,规格,自带条码,批次码,批号,效期
		var InciCode = RowData[0];
		var InciDesc = RowData[1];
		var Spec = RowData[2];
		var OriginalCode = RowData[3];
		var BatchCode = RowData[4];
		var BatchNo = RowData[5];
		var ExpDate = RowData[6];
		if(ExpDate != ''){
			ExpDate = Date.parseDate(ExpDate, "Y-n-j");
		}
		var HospId = session["LOGON.HOSPID"];
		if(Ext.isEmpty(InciCode)){
			return false;
		}
		var url="dhcstm.drugutil.csp?actiontype=GetItmInfoByCode&ItmCode="+InciCode+"&HospId="+HospId ;	
		var responseText = ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(responseText);
		if (jsonData.success == 'true') {
			var list = jsonData.info.split("^");
			if(list.length < 16 || Ext.isEmpty(list[15])){
				Msg.info('error', '第'+rowNumber+'行信息有误!');
				return;
			}
			var InciId = list[15];
			var InciCode = list[0];
			var InciDesc = list[1];
			var BUomId = list[6], BUomDesc = list[7];
			var Spec = list[16];
			var Sp = list[11];
			var ManfId = list[17], Manf = list[18];
			var IngrUomId = list[8], IngrUom = list[9];
			var BUomId = list[6];
			var NotUseFlag = list[19];
			var BatchReq = list[20];
			var ExpReq = list[21];
			var BRp = list[22], BSp = list[23];
			if(NotUseFlag=='Y'){
				Msg.info('warning', '第'+rowNumber+'行: '+InciCode+' 为"不可用"状态!');
				return;
			}
			var VendorId = Ext.getCmp('ImpVendor').getValue();
			var VendorDesc = Ext.getCmp('ImpVendor').getRawValue();
//			colArr = sortColoumByEnterSort(BarCodeGrid); //将回车的调整顺序初始化好
			// 新增一行
			BarCodeGrid.addNewRow();
			addComboData(PhManufacturerStore,ManfId,Manf);
			var row = BarCodeGrid.getStore().getCount();
			var rec = BarCodeGrid.getStore().getAt(row-1);
			
			rec.set('OriginalCode', OriginalCode);
			rec.set('BatchCode', BatchCode);
			rec.set('IncId', InciId);
			rec.set('IncCode', InciCode);
			rec.set('IncDesc', InciDesc);
			rec.set('Spec', Spec);
			rec.set('Qty', 1);
			rec.set('Rp',BRp);
			rec.set('Sp', BSp);
			rec.set('BatNo', BatchNo);
			rec.set('ExpDate', ExpDate);
			rec.set('ManfId', ManfId);
			rec.set('IngrUomId',IngrUomId);
			rec.set('BUomId', BUomId);
			rec.set('BatchReq', BatchReq);
			rec.set('ExpReq', ExpReq);
			rec.set('VendorId', VendorId);
			rec.set('VendorDesc', VendorDesc);
		}else{
			Msg.info('error','第'+rowNumber+'行读取错误!');
			return false ;
		}
		return true;
	}catch(e){
		Msg.info('error','读取数据错误:' + e);
		return false;
	}
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

var DeleteButton = new Ext.ux.Button({
	text : '删除条码',
	iconCls : 'page_delete',
	width : 70,
	height : 30,
	handler : function(button, e) {
		var DelRowIdStr = '';
		var count = BarCodeGrid.getCount();
		for(var rowIndex = count - 1; rowIndex >= 0; rowIndex--){
			var RowData = BarCodeGrid.getAt(rowIndex);
			var DeleteFlag = RowData.get('DeleteCheck');
			if(DeleteFlag != "Y"){
				continue;
			}
			var RowId = RowData.get('InctrackId');
			if(Ext.isEmpty(RowId)){
				BarCodeGrid.remove(RowData);
			}else{
				if(DelRowIdStr == ''){
					DelRowIdStr = RowId;
				}else{
					DelRowIdStr = DelRowIdStr + '^' + RowId;
				}
			}
		}
		if(DelRowIdStr != ''){
			if(confirm('您将要删除已经保存的条码信息,是否继续?')){
				var Ret = tkMakeServerCall('web.DHCSTM.DHCItmTrack', 'DeleteLabel', DelRowIdStr);
				if(Ret != ''){
					Msg.info('error', '删除失败: ' + Ret);
				}else{
					BarCodeGrid.reload();
				}
			}
		}else{
			BarCodeGrid.getView().refresh();
		}
	}
});
var DelSelectAllBtn = new Ext.Button({
	text : '删除全选',
	iconCls : 'page_gear',
	width : 70,
	height : 30,
	handler : function(button, e) {
		var count = BarCodeGrid.getCount();
		if(count > 0){
			var YesNo = BarCodeGrid.getAt(0).get('DeleteCheck') == 'Y'? 'N' : 'Y';
		}
		for(var rowIndex = 0; rowIndex < count; rowIndex++){
			var RowData = BarCodeGrid.getAt(rowIndex);
			RowData.set('DeleteCheck', YesNo);
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
				Ext.getCmp('StatusFlag').setValue('Temp');
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
	var MainInfo = CreateUser + "^" + StkGrpId + '^' + gLocId;
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
						var ParamObj = paramsFn(time);
						var Param = ParamObj['Param'];
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

var DownLoadBT = new Ext.Button({
	text : '下载模板',
	height : 30,
	width : 70,
	iconCls : 'page_excel',
	handler : function(){
		window.open("../scripts/dhcstm/BarCode/跟台高值耗材信息导入模板.xls", "_blank");
	}
});
	
var formPanel = new Ext.ux.FormPanel({
			title : '供应商高值条码验收',
			labelWidth : 60,
			trackResetOnLoad : true,
			tbar : [findBarCode, '-', clearBarCode, '-', saveBarCode, '-',impByPo, '-', DeleteButton,
				DelSelectAllBtn,
				'->', DownLoadBT
				// '-', addBarCode
			],
			layout : 'column',
			items : [{
					columnWidth : 1,
					xtype : 'fieldset',
					title : '查询条件',
					layout : 'column',
					items : [{
								columnWidth : .25,
								layout : 'form',
								items : [startDate, endDate, OriginalCode]
							}, {
								columnWidth : .25,
								layout : 'form',
								items : [BarCodeField,BatNo, BatchCode]
							}, {
								columnWidth : .25,
								layout : 'form',
								items : [RequestPhaLoc, StkGrpType, ImpVendor, StatusFlag]
							}, {
								columnWidth : .25,
								layout : 'form',
								items : [M_InciCode, M_InciDesc]
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