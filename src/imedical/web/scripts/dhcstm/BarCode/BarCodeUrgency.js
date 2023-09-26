// 名称:		高值条码临时生成业务(节假日等时间供护士等角色使用)
// 编写人：	wangjiabin
// 编写日期:	2016-11-07
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var gHospId = session['LOGON.HOSPID'];
var inciDr = "";
var CURRENT_INGR = '', CURRENT_INIT = '';		//本次补录入库单rowidStr, 出库单rowidStr

//保存参数值的object
var ItmTrackParamObj = GetAppPropValue('DHCITMTRACKM');
var DEFA_RECLOC_DESC = ItmTrackParamObj.DefaRecLoc;
var DEFA_RECLOC_ID = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'LocToRowID', DEFA_RECLOC_DESC);
if(Ext.isEmpty(DEFA_RECLOC_ID)){
	DEFA_RECLOC_DESC = '';
	Msg.info('error', '请联系管理员设置入库科室!');
}

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
	var CurStartRow;		//记录本次录入的第一行
	records = [].concat(records);
	if (records == null || records == "") {
		return;
	}
	Ext.each(records,function(record,index,allItems){
		inciDr = record.get("InciDr");
		var inciCode = record.get("InciCode");
		var inciDesc = record.get("InciDesc");
		var Spec = record.get("Spec");
		var pbrp= record.get("PbRp");
		var PFac=record.get("PFac");
		var pSp=record.get("pSp");
		var CertNo=record.get("CertNo");
		var CertExpDate=toDate(record.get("CertExpDate"));

		var cell = BarCodeGrid.getSelectionModel().getSelectedCell();	// 选中行
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
		rowData.set('Qty', PFac);  //入库单位和基本单位不一致  默认打印条码数量为转换系数
		rowData.set('PbRp',pbrp);
		rowData.set('CerNo',CertNo);
		rowData.set('CerExpDate',CertExpDate);
		var Params=session['LOGON.GROUPID']+'^'+session['LOGON.CTLOCID']+'^'+gUserId;   //取其它物资信息
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
				rowData.set("BatNo", data[6]);
				rowData.set("ExpDate", toDate(data[7]));
				rowData.set("BUomId", data[10]);
				var Marginnow = '';
				if(Number(data[4]) > 0){
					Marginnow = accDiv(Number(data[5]), Number(data[4]));
				}
				rowData.set('Marginnow',Marginnow);
			}
			//核实资质信息
			var StrParam = '^' + inciDr + '^' + data[0];		//vendor^inci^manf
			var AlarmDays = 30;
			var CheckInfo = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'Check', StrParam, AlarmDays);
			if(!Ext.isEmpty(CheckInfo)){
				Msg.info("warning", inciDesc + ':' + CheckInfo);
			}
		}
		if(!CurStartRow){
			CurStartRow = row;
		}
		BarCodeGrid.addNewRow();
	});
	
	var col = GetColIndex(BarCodeGrid, 'Qty');
	if (!BarCodeGrid.getColumnModel().isHidden(col)){
		BarCodeGrid.startEditing(CurStartRow, col);
	}
}

//入库科室
var PhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '入库科室',
	id : 'PhaLoc',
	anchor : '90%',
	emptyText : '入库科室...',
	disabled : true,
	defaultLoc : {RowId : DEFA_RECLOC_ID, Description : DEFA_RECLOC_DESC}
});
//PhaLoc.setValue(DEFA_RECLOC_DESC)
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
var RegFlag = new Ext.form.Checkbox({
		hideLabel: true,
		boxLabel: "已入库",
		id: 'RegFlag',
		//anchor: '90%',
		checked: false
	});
var startDate = new Ext.ux.DateField({
	id : 'startDate',
	//disabled : true,
	fieldLabel : '起始日期',
	anchor : '95%',
	value : new Date()
});
// 截止日期
var endDate = new Ext.ux.DateField({
	id : 'endDate',
	//disabled : true,
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
				GetPhaOrderInfo2(field.getValue(), stktype);
			}
		},
		blur : function(field) {
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
function getDrugList2(record){
	inciDr = record.get("InciDr");
	var inciCode = record.get("InciCode");
	var inciDesc = record.get("InciDesc");
	Ext.getCmp("M_InciDesc").setValue(inciDesc);
	Ext.getCmp("M_InciCode").setValue(inciCode);
}
var Vendor=new Ext.ux.VendorComboBox({
	id : 'Vendor',
	name : 'Vendor',
	anchor:'95%'
});		
var UsePhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '接收科室',
	id : 'UsePhaLoc',
	anchor : '90%',
	emptyText : '接收科室...',
	listeners:{
		'select':function(cb){
			var OperLoc=cb.getValue();
			var IfAllowDo=tkMakeServerCall("web.DHCSTM.HVUsePermissonLoc","IfAllowDo",OperLoc,gUserId);
			if (IfAllowDo==-1)
			{
				Msg.info("warning","此接收科室当前没有操作高值入库权限!");
				return false;
			}
		}
	}
	//groupId : gGroupId
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
			width : 100,
			align : 'left',
			renderer :Ext.util.Format.InciPicRenderer('IncId'),
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
			width : 80,
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
			header : "物资条码",
			dataIndex : 'BarCode',
			width : 150,
			align : 'left',
			sortable : false,
			saveColIndex : 2,
			editable : false,		//2015-12-28 不可编辑
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
						if (e.getKey() == Ext.EventObject.ENTER) {							//自带条码经常分段,这里不跳转了
							return false;
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
		},{
			header : "平台子表id",
			dataIndex : 'OrderDetailSubId',
			width : 80,
			align : 'left',
			saveColIndex : 15,
			sortable : true,
			hidden:true
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
	var vendor = Ext.getCmp("Vendor").getValue();
	var reqloc = '';
	var batno= Ext.getCmp("BatNo").getValue();
	var time = "";
	if (Ext.getCmp("M_InciDesc").getValue() == "") {
		inciDr = "";
	}
	var Status = Ext.getCmp("RegFlag").getValue()==true? 'Enable' : '';		//条码状态
	var Param = BarCodeField + "^" + StkGrpType + "^" + inciDr + "^" + startDate + "^" + time
			 + "^" + endDate+"^"+vendor+"^"+reqloc+"^"+batno+"^"+gHospId
			 + "^" + gUserId+"^"+""+"^"+""+"^"+Status;
	return {'Param' : Param};
}

function beforeAddFn(){
	if(Ext.isEmpty(DEFA_RECLOC_ID)){
		Msg.info('error', '请联系管理员设置入库科室!');
		return false;
	}
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
	smRowSelFn : Ext.emptyFn,
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
		},
		'rowcontextmenu' : function(grid,rowindex,e){
			e.preventDefault();
			grid.getSelectionModel().select(rowindex,1);
			//仅对未保存的条码明细弹出右键菜单
			if(grid.getStore().getAt(rowindex).get('InctrackId')==''){
				rightClick.showAt(e.getXY());
			}
		},
		'rowdblclick' : function(grid, rowIndex, e){
			var record = grid.getStore().getAt(rowIndex)
			var dhcit = record.get('InctrackId');
			if(Ext.isEmpty(dhcit)){
				return;
			}
			var BarCode = record.get('BarCode');
			var IncDesc = record.get('IncDesc');
			var InfoStr = BarCode + ' : ' + IncDesc;
			BarCodePackItm(dhcit, InfoStr);
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

//>>>>>>>>>>入库单回显部分>>>>>>>>>>
var GrMasterInfoStore = new Ext.data.JsonStore({
	url : DictUrl	+ 'ingdrecaction.csp?actiontype=QueryIngrStr',
	totalProperty : "results",
	root : 'rows',
	fields : ["IngrId","IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
		"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
		"StkGrp","RpAmt","SpAmt","AcceptUser","InvAmt"],
	listeners : {
		load : function(store, records, option){
			if(records.length > 0){
				GrMasterInfoGrid.getSelectionModel().selectFirstRow();
				GrMasterInfoGrid.getView().focusRow(0);
			}
		}
	}
});

var GrMasterInfoCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "RowId",
		dataIndex : 'IngrId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true,
		hideable : false
	}, {
		header : "入库单号",
		dataIndex : 'IngrNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : '入库部门',
		dataIndex : 'RecLoc',
		width : 120,
		align : 'left',
		sortable : true
	},  {
		header : "供应商",
		dataIndex : 'Vendor',
		width : 200,
		align : 'left',
		sortable : true
	}, {
		dataIndex : "StkGrp",
		hidden : true,
		hideable : false
	}, {
		header : '采购员',
		dataIndex : 'PurchUser',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : "完成标志",
		dataIndex : 'Complete',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : "发票金额",
		dataIndex : 'InvAmt',
		width : 80,
		xtype:'numbercolumn',
		align : 'right'
	}, {
		header : "进价金额",
		dataIndex : 'RpAmt',
		width : 80,
		xtype:'numbercolumn',
		align : 'right'
	}, {
		header : "售价金额",
		dataIndex : 'SpAmt',
		xtype : 'numbercolumn',
		width : 80,
		align : 'right'
	}, {
		header : "备注",
		dataIndex : 'InGrRemarks',
		width : 160,
		align : 'left'
	}
]);

var GridPagingToolbar = new Ext.PagingToolbar({
	store:GrMasterInfoStore,
	pageSize:PageSize,
	displayInfo:true
});
var GrMasterInfoGrid = new Ext.grid.GridPanel({
	id : 'GrMasterInfoGrid',
	title : '',
	//autoHeight: true,
	cm : GrMasterInfoCm,
	sm : new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var InGr = r.get("IngrId");
				GrDetailInfoStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',Parref:InGr}});
			}
		}
	}),
	store : GrMasterInfoStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	bbar:[GridPagingToolbar]
});

var GrDetailInfoStore = new Ext.data.JsonStore({
	url : DictUrl + 'ingdrecaction.csp?actiontype=QueryDetail',
	totalProperty : "results",
	root : 'rows',
	fields : ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb",  "Margin", "RecQty",
		"Remarks", "IncCode", "IncDesc","InvNo", "Manf", "Rp", "RpAmt",
		"Sp", "SpAmt", "InvDate","QualityNo", "SxNo","Remark","MtDesc","PubDesc",
		"CheckPort","CheckRepNo",{name:'CheckRepDate',type:'date',dateFormat:DateFormat},"AdmNo",
		{name:'AdmExpdate',type:'date',dateFormat:DateFormat},"CheckPack","InvMoney"]
});

var GrDetailInfoCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "Ingri",
		dataIndex : 'Ingri',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true,
		hideable : false
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
		header : "生产厂商",
		dataIndex : 'Manf',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "批号",
		dataIndex : 'BatchNo',
		width : 90,
		align : 'left',
		sortable : true
	}, {
		header : "有效期",
		dataIndex : 'ExpDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "单位",
		dataIndex : 'IngrUom',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "数量",
		dataIndex : 'RecQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "进价",
		dataIndex : 'Rp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "售价",
		dataIndex : 'Sp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "发票号",
		dataIndex : 'InvNo',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "发票日期",
		dataIndex : 'InvDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "发票金额",
		dataIndex : 'InvMoney',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "进价金额",
		dataIndex : 'RpAmt',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "售价金额",
		dataIndex : 'SpAmt',
		width : 100,
		align : 'left',
		sortable : true
	}
]);

var GrDetailInfoGrid = new Ext.grid.GridPanel({
	id : 'GrDetailInfoGrid',
	title : '',
	height : 170,
	cm : GrDetailInfoCm,
	store : GrDetailInfoStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true
});

var IngrInfoPanel = new Ext.Panel({
	layout : 'border',
	items : [{split:true,region:'north',layout:'fit',height:200,items:GrMasterInfoGrid}, 
			{split:true,region:'center',layout:'fit',items:GrDetailInfoGrid}]
});
//<<<<<<<<<<入库单回显部分<<<<<<<<<<

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
var saveBarCode = new Ext.ux.Button({
	text : '保存',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		save();
	}
});

function GetRecordPrtStr(record){
	var barcode=record.get('BarCode');
	var IncDesc=record.get('IncDesc');
	var Spec=record.get('SpecDesc');
	var ReqNo=record.get('ReqNo');
	var Brand=record.get('Brand');
	var ReqLocDesc=record.get('ReqLocDesc');
	var Sp=record.get('Sp');
	var BatNo=record.get('BatNo');
	var ExpDate=record.get('ExpDate')
	if(Ext.isEmpty(ExpDate)){
		ExpDate="";
	}else{
		ExpDate=ExpDate.format(ARG_DATEFORMAT);
	}
	
	var MyPara='BarCode'+String.fromCharCode(2)+"*"+barcode+"*"
			+'^IncDesc'+String.fromCharCode(2)+IncDesc
			+'^ReqNo'+String.fromCharCode(2)+ReqNo
			+'^Brand'+String.fromCharCode(2)+Brand
			+'^Spec'+String.fromCharCode(2)+Spec
			+'^ReqLocDesc'+String.fromCharCode(2)+ReqLocDesc
			+'^Sp'+String.fromCharCode(2)+Sp
			+'^BatNo'+String.fromCharCode(2)+BatNo
			+'^ExpDate'+String.fromCharCode(2)+ExpDate;
	return MyPara;
}

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
			var barcode = BarCodeGrid.getAt(rowIndex).get('BarCode');
			var MyPara = GetRecordPrtStr(BarCodeGrid.getAt(rowIndex));
			DHCP_PrintFun(MyPara,"");
			var PrintFlag="Y";
			SavePrintFlag(PrintFlag,barcode);
		}
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
			var barcode = BarCodeGrid.getAt(rowIndex).get('BarCode');
			var MyPara=GetRecordPrtStr(BarCodeGrid.getAt(rowIndex));
			DHCP_PrintFun(MyPara,"");
			DHCP_PrintFun(MyPara,"");
			var PrintFlag="Y";
			SavePrintFlag(PrintFlag,barcode);
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
		for(var rowIndex=0; rowIndex<rowsCount; rowIndex++){
			var barcode = BarCodeGrid.getAt(rowIndex).get('BarCode');
			var MyPara=GetRecordPrtStr(BarCodeGrid.getAt(rowIndex));
			DHCP_PrintFun(MyPara,"");
			var PrintFlag="Y";
			SavePrintFlag(PrintFlag,barcode);
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
		for(var rowIndex=0; rowIndex<rowsCount; rowIndex++){
			var barcode = BarCodeGrid.getAt(rowIndex).get('BarCode');
			var MyPara=GetRecordPrtStr(BarCodeGrid.getAt(rowIndex));
			DHCP_PrintFun(MyPara,"");
			DHCP_PrintFun(MyPara,"");
			var PrintFlag="Y";
			SavePrintFlag(PrintFlag,barcode);
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
		clearData();
	}
});
/**
 * 清空方法
 */
function clearData() {
	CURRENT_INGR = '', CURRENT_INIT = '';
	inciDr = "";
	Ext.getCmp("ImpVendor").setValue("");
	Ext.getCmp("SourceOfFund").setValue("");
	Ext.getCmp("UsePhaLoc").setValue("");
	clearPanel(formPanel);
	GrMasterInfoGrid.getStore().removeAll();
	GrDetailInfoGrid.getStore().removeAll();
	BarCodeGrid.removeAll();
	formPanel.getForm().setValues({"startDate":new Date(),"endDate":new Date()});	
}
	
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
	tooltip : '复制上一行的批号和效期',
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
		var expDateValue = BarCodeGrid.getStore().getAt(i).get("ExpDate");
		var item = BarCodeGrid.getStore().getAt(i).get("IncId");
		var ExpDate = new Date(Date.parse(expDateValue));
		if ((item != "") && (ExpDate.format(ARG_DATEFORMAT) <= nowdate.format(ARG_DATEFORMAT))) {
			Msg.info("warning", "有效期不能小于或等于当前日期!");
			var cell = BarCodeGrid.getSelectionModel()
					.getSelectedCell();
			 
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		var qty = BarCodeGrid.getStore().getAt(i).get("Qty");
		if ((item != "") && (qty == null || qty <= 0)) {
			Msg.info("warning", "入库数量不能小于或等于0!");
			var cell = BarCodeGrid.getSelectionModel()
					.getSelectedCell();
			
			SetGridBgColor(BarCodeGrid, i, "yellow");
			return false;
		}
		var realPrice = BarCodeGrid.getAt(i).get("Rp");
		if ((item != "")&& (realPrice == null || realPrice <= 0)) {
			Msg.info("warning", "入库进价不能小于或等于0!");
			var cell = BarCodeGrid.getSelectionModel()
					.getSelectedCell();
			
			SetGridBgColor(BarCodeGrid, i, "yellow");
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
	var LocId = Ext.getCmp("PhaLoc").getValue();
	var CreateUser = gUserId;
	var ExchangeFlag ='N';
	var PresentFlag = 'N';
	var IngrTypeId = "";    //正常入库		
	var PurUserId =""
	var StkGrpId = Ext.getCmp("StkGrpType").getValue();
	var PoId="";  //订单id
	var SourceOfFund = Ext.getCmp('SourceOfFund').getValue();
	var UsePhaLoc = Ext.getCmp('UsePhaLoc').getValue();
	if(Ext.isEmpty(UsePhaLoc)){
		Msg.info('error', '未录入接收科室!');
		return false;
	}
	var AllowFlag=tkMakeServerCall("web.DHCSTM.HVUsePermissonLoc","IfAllowDo",UsePhaLoc,gUserId);
	if (AllowFlag==-1) {
		Msg.info("warning", "此接收科室当前没有操作高值入库权限!");
		return false;
	}
	if (AllowFlag==-2) {
		Msg.info("warning", "当前登陆人员没有操作高值入库权限!");
		return false;
	}
	var MainInfo = VenId + "^" + LocId + "^" + CreateUser + "^" + PresentFlag + "^" + ExchangeFlag 
			+ "^" + IngrTypeId + "^" + PurUserId + "^"+ StkGrpId +"^"+ PoId + '^' + ''
			+ '^' + SourceOfFund + '^' + UsePhaLoc;
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
	var ret = tkMakeServerCall('web.DHCSTM.DHCINGdRec', 'CreateUrgencyIngr', Ingr, MainInfo, ListDetail);
	if(ret.split('^').length > 1){
		Msg.info('success', '保存成功!');
		//findBarCode.handler();
		BarCodeGrid.removeAll();
		CURRENT_INGR = ret.split('^')[0];
		CURRENT_INIT = ret.split('^')[1];
		if(CURRENT_INGR != ''){
			tabPanel.activate('CurrentIngrPanel');
		}
	}else{
		Msg.info('error', '处理失败:' + ret);
	}
}

var PrintSplitButton = new Ext.SplitButton({
	text: '打印选项',
	width : 70,
	height : 30,
	iconCls : 'page_add',
	tooltip: '下拉导入按钮',
	menu : {
		items: [{
			text: '<b>打印条码</b>', handler: printBarCode.handler
		},{
			text: '<b>打印本页条码</b>', handler: printBarCodeTotal.handler
		},{
			text: '<b>打印条码(2次)</b>', handler: printBarCode2.handler
		},{
			text: '<b>打印本页条码(2次)</b>', handler: printBarCodeTotal2.handler
		}]
	}
});

var PrintIngrButton = new Ext.Toolbar.Button({
	text:'打印入库单',
	iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(){
		var rowData = GrMasterInfoGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", "请选择需要打印的入库单!");
			return;
		}
		var DhcIngr = rowData.get("IngrId");
		PrintRec(DhcIngr);
	}
});

var formPanel = new Ext.form.FormPanel({
	columnWidth : .65,
	labelWidth : 60,
	labelAlign : 'right',
	frame : true,
	trackResetOnLoad : true,
	tbar : [findBarCode, '-', addBarCode, '-', clearBarCode, '-', saveBarCode, '-', PrintSplitButton, '-', copybutton],
	items : [{
			xtype : 'fieldset',
			title : '查询条件',
			layout : 'column',
			items : [{
						columnWidth : .4,
						layout : 'form',
						items : [BarCodeField, startDate, endDate, Vendor]
					}, {
						columnWidth : .4,
						layout : 'form',
						items : [StkGrpType, M_InciCode, M_InciDesc, BatNo]
					}, {
						columnWidth : .2,
						layout : 'form',
						items : [RegFlag]
					}]
		}]
});

var RecPanel = new Ext.form.FormPanel({
	columnWidth : .35,
	labelWidth : 60,
	labelAlign : 'right',
	frame : true,
	trackResetOnLoad : true,
	tbar : [saveImp, '-', PrintIngrButton],
	items : [{
		xtype : 'fieldset',
		title : '入库选项',
		labelWidth : 100,
		layout : 'form',
		items : [PhaLoc, ImpVendor, SourceOfFund, UsePhaLoc]
	}]
});

var tabPanel = new Ext.TabPanel({
	region : 'center',
	split:true,
	activeTab: 0,
	items:[
		{title: '高值条码信息',id:'HVMatPanel',layout:'fit',items:BarCodeGrid},
		{title: '本次补录入库信息',id:'CurrentIngrPanel',layout:'fit',items:IngrInfoPanel}
//		,
//		{title: '本次补录出库信息',id:'CurrentInitPanel',layout:'fit',items:InitInfoPanel}
	],
	listeners:{
		'tabchange' : function(t,p){
			if (p.getId()=='CurrentIngrPanel'){
				if (CURRENT_INGR!=""){
					GrMasterInfoGrid.getStore().load({params:{IngrStr:CURRENT_INGR}});
				}
			}else if (p.getId()=='CurrentInitPanel'){
				if (CURRENT_INIT!=""){
					InitMasterGrid.getStore().load({params:{InitStr:CURRENT_INIT}});
				}
			}
		}
	}
});

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var panel = new Ext.Panel({
		title : '高值条码生成(紧急业务)',
		region : 'north',
		autoHeight : true,
		layout : 'column',
		items : [formPanel, RecPanel]
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [panel, tabPanel],
		renderTo : 'mainPanel'
	});
	
});
function SavePrintFlag(PrintFlag,Barecode){
	tkMakeServerCall("web.DHCSTM.DHCItmTrack","SavePrintFlag",PrintFlag,Barecode);
}