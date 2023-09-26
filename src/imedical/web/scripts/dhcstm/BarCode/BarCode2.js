// 名称:高值条码生成管理
// 编写人：徐超
// 编写日期:2013-09-17
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gHospId = session['LOGON.HOSPID'];
var DrugListFlag = 0;// 标志 用意判断是查询还是录入
var inciDr = ""
var BarcodeArr = [];

/**
 * 调用物资窗体并返回结果
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", gHospId,
				getDrugList);
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
	var pbrp= record.get("PbRp");
	var PFac=record.get("PFac");
	var pSp=record.get("pSp");
	var Marginnow=accDiv(pSp,pbrp)
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
		rowData.set('Qty', 1);
		rowData.set('PbRp',pbrp);
		rowData.set('Sp',pSp);
		rowData.set('Marginnow',Marginnow);
		var colIndex = GetColIndex(BarCodeGrid, 'Qty');
		BarCodeGrid.startEditing(row, colIndex);
	}
}

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
			name : 'StkGrpType',
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
			selectOnFocus : true
		});
var OldBarCodeField = new Ext.form.TextField({
			id : 'OldBarCodeField',
			fieldLabel : '原始条形码',
			allowBlank : true,
			anchor : '95%',
			selectOnFocus : true,
				listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var oldbarcode=field.getValue()
						save(oldbarcode)
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
		'beforequery':function()
		
			{	var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
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
var BarCodeGridCm = [{
			header : "dhcit",
			dataIndex : 'InctrackId',
			hidden : true,
			hideable : false
		}, {
			header : "IncId",
			dataIndex : 'IncId',
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
			sortable : true
		}, {
			header : "规格",
			dataIndex : 'Spec'
		}, {
			header : "数量",
			dataIndex : 'Qty',
			width : 80,
			align : 'right'
		}, {
			header : "物资新条码",
			dataIndex : 'BarCode',
			width : 150,
			align : 'left',
			sortable : false
		}, {
			header : "打印",
			xtype:'checkcolumn',
			dataIndex : 'print'
		}, {
			header : "自带条码",
			dataIndex : 'OriginalCode',
			width : 150,
			align : 'left',
			sortable : false
		}, {
			header : "注册人员",
			dataIndex : 'User'
		}, {
			header : "注册日期",
			dataIndex : 'Date'
		},{
			header : "PoItmId",
			dataIndex : 'PoItmId',
			hidden : true
		},{
			header : "请求单号",
			dataIndex : 'ReqNo'
		},{
			header : "品牌",
			dataIndex : 'Brand'
		}, {
			header : "批号",
			dataIndex : 'BatNo',
			width : 90,
			align : 'center',
			sortable : true
		}, {
			header : "有效期",
			xtype: 'datecolumn',
			dataIndex : 'ExpDate',
			width : 100,
			align : 'center',
			sortable : true
		},{
			header : "当前售价",
			dataIndex : 'Sp'
		},{
			header : "请求科室",
			dataIndex : 'ReqLocDesc'
		},{
			header : "招标进价",
			dataIndex : 'PbRp'
		},{
			header : "加成率",
			dataIndex : 'Marginnow'
		},{
        	header:"具体规格",
       		dataIndex:'SpecDesc',
        	width:100,
       		align:'left',
        	sortable:true
        }];
function paramsFn(){
	var BarCodeField = Ext.getCmp('BarCodeField').getValue();
	var StkGrpType = Ext.getCmp('StkGrpType').getValue();
	var startDate = Ext.getCmp("startDate").getValue();
	var endDate = Ext.getCmp("endDate").getValue();
	if(startDate!=""){
		startDate = startDate.format(ARG_DATEFORMAT);
	}
	if(endDate!=""){
		endDate = endDate.format(ARG_DATEFORMAT);
	}
	var time = "";
	if (Ext.getCmp("M_InciDesc").getValue() == "") {
		inciDr = "";
	}
	var Param = BarCodeField + "^" + StkGrpType + "^" + inciDr + "^" + startDate + "^" + time
			 + "^" + endDate;
	return {'Param' : Param};
}

function beforeAddFn(){
	var StkGrpType = Ext.getCmp("StkGrpType").getRawValue();
	if (StkGrpType == null || StkGrpType.length <= 0) {
		Msg.info("warning", "请选择类组!");
		return false;
	}
}
var DeleteDetailBT=new Ext.ux.Button({
	id:'DeleteDetailBT',
	text:'删除一条',
	iconCls:'page_delete',
	handler:function(){
		deleteDetail();
	}
});
function deleteDetail() {
	var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
	if (cell == null) {
		Msg.info("warning", "没有选中行!");
		return;
	}
	Ext.MessageBox.show({
			title : '提示',
			msg : '是否确定删除该条信息?',
			buttons : Ext.MessageBox.YESNO,
			fn : showResult,
			icon : Ext.MessageBox.QUESTION
		});
}
/**
 * 删除提示
 */
function showResult(btn) {
	if (btn == "yes") {
		var cell = BarCodeGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var record = BarCodeGrid.getStore().getAt(row);
		var RowId = record.get("InctrackId");
		// 删除该行数据
		var url =BarCodeGridUrl+"?actiontype=Delete&RowId="+RowId;
		Ext.Ajax.request({
			url : url,
			method : 'POST',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "删除成功!");
					BarCodeGrid.getStore().remove(record);
					BarCodeGrid.getView().refresh();
				} else {
						Msg.info("error", "删除失败!");
				}
			},
			scope : this
		});
	}
}


var BarCodeGridUrl = 'dhcstm.barcodeaction.csp';
// 表格
var BarCodeGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'BarCodeGrid',
	tbar:['原始条码:',OldBarCodeField,'-',DeleteDetailBT],
	contentColumns : BarCodeGridCm,
	smRowSelFn : Ext.emptyFn,
	singleSelect:false,
	selectFirst : false,
	actionUrl : BarCodeGridUrl,
	queryAction : "query",
	idProperty : "InctrackId",
	checkProperty : "IncId",
	paramsFn : paramsFn,
	beforeAddFn : beforeAddFn,
	//delRowAction : "Delete",
	//delRowParam : "RowId",
	showTBar:false,
	listeners : {
		'beforeedit' : function(e) {
			var InctrackId = BarCodeGrid.getCell(e.row,"InctrackId");
			if (!Ext.isEmpty(InctrackId) && e.field!='OriginalCode'&& e.field!='BatNo'&& e.field!='ExpDate'&& e.field!='SpecDesc') {
				return false;	// 控制修改 生成条码的不允许修改
			}
		}
		/*,
		'rowcontextmenu' : function(grid,rowindex,e){
			e.preventDefault();
			grid.getSelectionModel().select(rowindex,1);
			//仅对未保存的条码明细弹出右键菜单
			if(grid.getStore().getAt(rowindex).get('InctrackId')==''){
				rightClick.showAt(e.getXY());
			}
		}
		*/
	}
});
//BarCodeGrid.AddNewRowButton.hidden = true;		//隐藏用不到的"增加一行"按钮


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
			}
		});

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
			text : '清空',
			tooltip : '点击清空',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				inciDr = "";
				clearPanel(formPanel);
				BarCodeGrid.removeAll();
				BarCodeGrid.getBottomToolbar().updateInfo();
				formPanel.getForm().setValues({"startDate":new Date(),"endDate":new Date()});
				Ext.getCmp("OldBarCodeField").setValue("");
				clear.handler();
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
		
function save(barcode) {
	var CreateUser = gUserId;
	var MainInfo = barcode + "^" + CreateUser;
	var ret = tkMakeServerCall("web.DHCSTM.DHCItmTrack","NewBarcode",MainInfo);
	try{
		var ret = Ext.decode(ret);
		var NewRecord = CreateRecordInstance(BarCodeGrid.getStore().fields,ret);
		BarCodeGrid.getStore().insert(0,NewRecord);
		BarCodeGrid.getView().refresh();
	}catch(e){
		Msg.info('error', '生成失败:' + ret);
	}
}


var formPanel = new Ext.ux.FormPanel({
			title : '高值条码登记',
			trackResetOnLoad : true,
			tbar : [findBarCode, '-', addBarCode, '-', clearBarCode,'-', printBarCode, '-', printBarCodeTotal,'-',printBarCode2,'-',printBarCodeTotal2],
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
									items : [StkGrpType, endDate]
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
				items : [formPanel, BarCodeGrid],
				renderTo : 'mainPanel'
			});
});
