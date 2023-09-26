// 名称: 高值条码生成管理(供应商用户使用)(安贞)
// 2016-05-22
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var DrugListFlag = 0;// 标志 用意判断是查询还是录入
var inciDr = ""
var BarcodeArr = [];

/**
 * 调用物资窗体并返回结果
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",
				getDrugList,VENDORID);
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
	var Manf = record.get("ManfName");
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
		rowData.set("Spec", Spec);
		rowData.set("Manf", Manf);
		rowData.set('Qty', 1);
		var colIndex = GetColIndex(BarCodeGrid, 'SpecDesc');
		BarCodeGrid.startEditing(row, colIndex);
	}
}

var startDate = new Ext.ux.DateField({
			id : 'startDate',
			allowBlank : true,
			fieldLabel : '日期',
			anchor : '95%',
			value : new Date()
		});

var BarCodeField = new Ext.form.TextField({
			id : 'BarCodeField',
			fieldLabel : '条形码',
			allowBlank : true,
			anchor : '95%',
			selectOnFocus : true
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
						GetPhaOrderInfo(field.getValue(), '');
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

var BarCodeGridCm = [{
			header : "dhcit",
			dataIndex : 'InctrackId',
			saveColIndex : 0,
			hidden : true
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
									GetPhaOrderInfo(field.getValue(), '');
								}
							}
						}
					}))
		}, {
			header : "厂商",
			dataIndex : 'Manf'
		}, {
			header : "规格",
			dataIndex : 'Spec'
		}, {
			header : "具体规格",
			dataIndex : 'SpecDesc',
			saveColIndex : 8,
			allowBlank : false,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank : false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var SpecDesc = field.getValue();
									if (SpecDesc.length < 4) {
										Msg.info("warning", "具体规格长度不符!");
										return;
									}
									var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
									var col = GetColIndex(BarCodeGrid, 'Qty')
									BarCodeGrid.startEditing(row, col);
								}
							}
						}
					}))
		}, {
			header : "数量",
			dataIndex : 'Qty',
			width : 60,
			align : 'right',
			saveColIndex : 3,
			editor : new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : false,
						allowNegative : false,
						allowDecimals :false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var qty = field.getValue();
									if (qty == null || qty.length <= 0) {
										Msg.info("warning", "数量不能为空!");
										return;
									}
									var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
									var col = GetColIndex(BarCodeGrid, 'OriginalCode')
									BarCodeGrid.startEditing(row, col);
								}
							}
						}
					})
		}, {
			header : "打印",
			xtype:'checkcolumn',
			dataIndex : 'print',
			width : 40
		}, {
			header : "物资条码",
			dataIndex : 'BarCode',
			width : 200,
			align : 'left',
			sortable : false,
			saveColIndex : 2,
			editable : false, // 2015-05-01 rem
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus : true,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
									var col = GetColIndex(BarCodeGrid, 'OriginalCode')
									BarCodeGrid.startEditing(row, col);
								}
							}
						}
					}))
		}, {
			header : "自带条码",
			dataIndex : 'OriginalCode',
			width : 150,
			align : 'left',
			sortable : false,
			saveColIndex : 4,
			allowBlank : false,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
						selectOnFocus : true,
						allowBlank:false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var row = BarCodeGrid.getSelectionModel().getSelectedCell()[0];
									var col = GetColIndex(BarCodeGrid, 'BatNo')
									BarCodeGrid.startEditing(row, col);
								}
							}
						}
					}))
		}, {
			header : "批号",
			dataIndex : 'BatNo',
			width : 90,
			align : 'center',
			sortable : true,
			saveColIndex : 6,
			allowBlank : false,
			editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank:false,
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
			allowBlank : false,
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
								if (expDate.format("Y-m-d") <= nowdate.format("Y-m-d")) {
									Msg.info("warning", "有效期不能小于或等于当前日期!");
									return;
								}
								BarCodeGrid.addNewRow();
							}
						}
					}
				})
		}, {
			header : "注册人员",
			dataIndex : 'User'
		}, {
			header : "注册日期",
			dataIndex : 'Date'
		}, {
			header : "供应商ID",
			dataIndex : 'Vendor',
			saveColIndex : 14,
			hidden : true,
			hideable : false
		}];

function paramsFn(){
	var BarCodeField = Ext.getCmp('BarCodeField').getValue();
	var StkGrpType = '';
	var startDate = Ext.getCmp("startDate").getValue();
	if(Ext.isEmpty(startDate)){
		Msg.info('warning', '日期不可为空!');
		return false;
	}
	startDate = startDate.format(ARG_DATEFORMAT);
	var endDate = startDate;
	var time = "";
	if (Ext.getCmp("M_InciDesc").getValue() == "") {
		inciDr = "";
	}
	var Param = BarCodeField + "^" + StkGrpType + "^" + inciDr + "^" + startDate + "^" + time
			 + "^" + endDate + "^" + VENDORID;
	return {'Param' : Param};
}

function cellSelectFn(sm,rowIndex,colIndex){
	/*
	var InctrackId = BarCodeGrid.getCell(rowIndex,BarCodeGrid.idProperty);
	//BarCodeGrid.DelRowButton.setDisabled(!Ext.isEmpty(InctrackId));	//2015-05-01 启用删除
	*/
}

var BarCodeGridUrl = 'dhcstm.barcodeaction.csp';
// 表格
var BarCodeGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'BarCodeGrid',
	contentColumns : BarCodeGridCm,
	smRowSelFn : cellSelectFn,
	selectFirst : false,
	actionUrl : BarCodeGridUrl,
	queryAction : "query",
	idProperty : "InctrackId",
	checkProperty : "IncId",
	paramsFn : paramsFn,
	beforeAddFn : Ext.emptyFn,		//beforeAddFn
	delRowAction : "Delete",
	delRowParam : "RowId",
	paging : false,
	createHeadMenu : Ext.emptyFn,	//置空
	listeners : {
		'beforeedit' : function(e) {
			var InctrackId = BarCodeGrid.getCell(e.row,"InctrackId");
			if (!Ext.isEmpty(InctrackId) && e.field!='OriginalCode' && e.field!='BatNo' && e.field!='ExpDate') {
				return false;	// 控制修改 生成条码的不允许修改
			}
		},
		'afteredit': function (e) {
			if(e.field == 'Qty'){
				if (!Ext.isNumber(e.value) || e.value > 1000) {
					Msg.info("warning", "数量不能超过1000!");
					e.record.set('Qty',e.originalValue);
					return;
				}
			}
		}
	}
});

var findBarCode = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '查询',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
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

// 保存按钮
var saveBarCode = new Ext.Toolbar.Button({
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
					if(print!="Y"){
						continue;
					}
					var barcode=BarCodeGrid.getAt(rowIndex).get('BarCode');
					PrintBarcode(barcode);
				}
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
		for(var n=0;n<rowsCount;n++){
			var barcode=BarCodeGrid.getAt(n).get('BarCode');
			PrintBarcode(barcode);
		}
	}
});
		
// 清空按钮
var clearBarCode = new Ext.Toolbar.Button({
			text : '清空',
			tooltip : '点击清空',
			width : 70,
			height : 30,
			iconCls : 'page_refresh',
			handler : function() {
				inciDr = "";
				clearPanel(formPanel);
				BarCodeGrid.removeAll();
				BarCodeGrid.getBottomToolbar().updateInfo();
				formPanel.getForm().setValues({"startDate":new Date()});
				Ext.get("SaveBarCodeDiv").dom.innerHTML="";
			}
		});
		
function save() {
	var CreateUser = gUserId;
	var StkGrpId = '';
	var MainInfo = CreateUser + "^" + StkGrpId;
	var ListDetail = BarCodeGrid.getModifiedInfo();
	if (ListDetail == "") {
		Msg.info("warning", "没有需要保存的内容!");
		return;
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

var VenItmList = new Ext.Button({
	text : '供货列表',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function(){
		VenItmListWindow();
	}
});

var ChangePswdButton = new Ext.Button({
	text : '修改密码',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	anchor : '90%',
	handler : function(){
		ChangePswd();
	}
});

var formPanel = new Ext.form.FormPanel({
			labelwidth : 30,
			labelAlign : 'right',
			frame : true,
			bodyStyle : 'padding:5px;',
			trackResetOnLoad : true,
			tbar : [findBarCode, '-', addBarCode, '-', clearBarCode, '-', saveBarCode, '-', printBarCode,
				'-', printBarCodeTotal, '-', VenItmList, '-', ChangePswdButton],
			items : [{
						xtype : 'fieldset',
						title : '查询条件',
						layout : 'column',
						items : [{
									columnWidth : .25,
									layout : 'form',
									items : [BarCodeField, startDate]
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
	
	var panel = new Ext.Panel({
				title : '高值条码注册(供应商)' + ':  ' + VENDOR_DESC,
				region : 'north',
				height : 180,
				layout : 'fit',
				items : [formPanel]
			});
	
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [panel, BarCodeGrid],
				renderTo : 'mainPanel'
			});
});