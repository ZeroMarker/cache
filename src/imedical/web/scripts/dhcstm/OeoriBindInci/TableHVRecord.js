// /名称:	跟台高值清点记录(供护士或供应商跟台人员使用)
// /编写者：	wangjiabin
// /编写日期:	2016-11-14

var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var gIncId = '';
var actionUrl = DictUrl + 'matordstataction.csp';

var RecLoc = new Ext.ux.LocComboBox({
	id:'RecLoc',
	fieldLabel:'医嘱接收科室',
	anchor:'100%',
	groupId : gGroupId
});

// 起始日期
var StartDate = new Ext.ux.DateField({
	fieldLabel : '起始日期',
	id : 'StartDate',
	anchor:'100%',
	
	width : 100,
	value : new Date()
});

// 截止日期
var EndDate = new Ext.ux.DateField({
	fieldLabel : '截止日期',
	id : 'EndDate',
	anchor:'100%',
	
	width : 100,
	value : new Date()
});

var Regno = new Ext.form.TextField({
	fieldLabel : '登记号',
	id : 'Regno',
	anchor:'100%',
	enableKeyEvents:true,
	listeners:{
		keydown:function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				var regno=field.getValue();
				Ext.Ajax.request({
					url: 'dhcstm.matordstataction.csp?actiontype=Getpainfo',
					params : {regno :regno},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							var value = jsonData.info;
							var arr = value.split('^');
							//基础信息
							field.setValue(arr[0]);
							Ext.getCmp('RegnoDetail').setValue(arr.slice(1));
						}
					},
					scope: this
				});
			}
		},
		blur : function(field){
			if(field.getValue() == ''){
				Ext.getCmp('RegnoDetail').setValue('');
			}
		}
	}
});
var RegnoDetail = new Ext.form.TextField({
	fieldLabel : '登记号信息',
	id : 'RegnoDetail',
	disabled:true,
	anchor:'100%'
});

var Vendor = new Ext.ux.VendorComboBox({
	id : 'Vendor',
	anchor : '100%',
	//params : {ScgId : 'StkGrpType'},
	valueParams : {LocId : gLocId, UserId : gUserId}
});
var InciDesc = new Ext.form.TextField({
	fieldLabel : '物资名称',
	id : 'InciDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = '';
				GetPhaOrderInfo(field.getValue(), stktype);
			}
		}
	}
});

function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
	 GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "",getDrugList);
	}
}
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	gIncId = record.get("InciDr");
	var InciCode=record.get("InciCode");
	var InciDesc=record.get("InciDesc");
	Ext.getCmp("InciDesc").setValue(InciDesc);
	
	SearchBT.handler();
}
// 查询按钮
var SearchBT = new Ext.Toolbar.Button({
	id:'SearchBT',
	text : '查询',
	tooltip : '点击查询',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		DetailGrid.load();
	}
});

// 清空按钮
var ClearBT = new Ext.Toolbar.Button({
	id:'ClearBT',
	text : '清空',
	tooltip : '点击清空',
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		clearData();
	}
});

function clearData() {
	clearPanel(HisListTab);
	HisListTab.getForm().setValues({StartDate:new Date(),EndDate:new Date()});
	DetailGrid.removeAll();
}

var HisListTab = new Ext.form.FormPanel({
	region: 'north',
	autoHeight : true,
	labelAlign : 'right',
	frame : true,
	title:'跟台高值清点记录',
	bodyStyle : 'padding:0px 0px 0px 0px;',
	tbar : [SearchBT, '-', ClearBT],
	items:[{
		xtype:'fieldset',
		title:'查询条件',
		layout: 'column',
		style:'padding:5px 0px 0px 0px;',
		defaults: {width: 220, border:false},
		items : [
			{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [RecLoc,Vendor]
			},{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [StartDate, EndDate]
			},{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [RegnoDetail, Regno]
			},{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [InciDesc]
			}]
	}]
});

var SaveBT = new Ext.ux.Button({
	id:'SaveBT',
	text : '保存明细信息',
	iconCls : 'page_save',
	handler : function() {
		Save();
	}
});
	
function Save(){
	var ListDetail = DetailGrid.getModifiedInfo();
	if(ListDetail === false){
		return false;
	}else if(ListDetail == ''){
		Msg.info('warning', '没有需要保存的内容');
		return false;
	}
	var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
	Ext.Ajax.request({
		url : actionUrl + '?actiontype=SaveHvmInfo',
		params : {ListDetail : ListDetail},
		method : 'POST',
		waitMsg : '处理中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				Msg.info('success', '保存成功!');
				DetailGrid.reload();
			}else if(jsonData.info == -10){
				Msg.info('error', '自带条码重复!');
			}else{
				var Ret=jsonData.info;
				Msg.info('error', '保存失败:'+Ret);
			}
		},
		scope : this
	});
}

var Specom = new Ext.form.ComboBox({
	fieldLabel : '具体规格',
	id : 'Specom',
	name : 'Specom',
	anchor : '90%',
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
	listeners:{
		'beforequery':function(){
			var cell = DetailGrid.getSelectionModel().getSelectedCell();
			var record = DetailGrid.getStore().getAt(cell[0]);
			var IncRowid = record.get("inci");
			var desc=this.getRawValue();
			this.store.removeAll();
			this.store.setBaseParam('SpecItmRowId',IncRowid);
			this.store.setBaseParam('desc',desc);
			this.store.load({params:{start:0,limit:this.pageSize}});
		}
	}
});

var MainLoc = new Ext.ux.ComboBox({
	store:frLocListStore,
	displayField:'Description',
	valueField:'RowId',
	params:{LocId:'RecLoc'},
	filterName: 'FilterDesc'
});

var IngrVendor = new Ext.ux.VendorComboBox({
	//params : {ScgId : 'StkGrpType'},
	valueParams: {
		LocId: gLocId,
		UserId: gUserId
	}
});

var DetailCm = [
	{
		header:"orirowid",
		dataIndex:'orirowid',
		width:90,
		saveColIndex:0,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"oeori",
		dataIndex:'oeori',
		width:90,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"inci",
		dataIndex:'inci',
		width:90,
		align:'left',
		hidden:true,
		sortable:true
	},{
		header:"物资代码",
		dataIndex:'code',
		width:90,
		align:'left',
		sortable:true,
		renderer : Ext.util.Format.InciPicRenderer('inci')
	},{
		header:"物资名称",
		dataIndex:'desc',
		width:140,
		align:'left',
		sortable:true
	},{
		header:"单位",
		dataIndex:'uomdesc',
		width:40,
		align:'left'
	},{
		header:"数量",
		dataIndex:'qty',
		width:50,
		align:'right',
		sortable:true,
		editor: new Ext.form.TextField({
			allowBlank:false,
			selectOnFocus:true
		})
	},{
		header:"批号",
		dataIndex:'batno',
		saveColIndex:2,
		width:80,
		align:'left',
		sortable:true,
		allowBlank : true,
		editor: new Ext.form.TextField({
			id:'batnoField',
			allowBlank:true,
			selectOnFocus:true
		})
	},{
		header:"有效期",
		dataIndex:'expdate',
		xtype:'datecolumn',
		width:80,
		saveColIndex:3,
		align:'left',
		sortable:true,
		allowBlank : true,
	//	renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor: new Ext.ux.DateField({
			allowBlank : true
		})
	},{
		header:"具体规格",
		dataIndex:'specdesc',
		width:80,
		saveColIndex:4,
		align:'right',
		sortable:true,
		editor : new Ext.grid.GridEditor(Specom),
		renderer : Ext.util.Format.comboRenderer2(Specom,"specdesc","specdesc")
	},{
		header:"自带条码",
		dataIndex:'originalcode',
		saveColIndex:5,
		width:100,
		align:'left',
		sortable:true,
		editor: new Ext.form.TextField({
			allowBlank:true,
			selectOnFocus:true
		})
	},{
		header:"条码id",
		dataIndex:'dhcit',
		saveColIndex:1,
		width:60,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"高值条码",
		dataIndex:'barcode',
		width:120,
		align:'left',
		sortable:true
	},{
		header:"补录标记",
		dataIndex:'IngrFlag',
		width:60,
		xtype : 'checkcolumn',
		isPlugin : false,
		align:'center',
		sortable:true
	},{
		header:"进价",
		dataIndex:'rp',
		width:80,
		align:'right',
		sortable:true,
		saveColIndex:6,
		//editable : false,
		editor: new Ext.form.TextField({
			id:'rpField',
			allowBlank:false,
			selectOnFocus:true,
			tabIndex:1
		})
	},{
		header:"售价",
		dataIndex:'sp',
		width:80,
		align:'right',
		sortable:true
	},{
		header:"供应商",
		xtype :'combocolumn',
		saveColIndex: 8,
		editor: IngrVendor,
		valueField: 'vendordr',
		displayField: 'vendor',
		width:200,
		align:'left',
		sortable:true
	},{
		header:"厂商",
		dataIndex:'manf',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"患者登记号",
		dataIndex:'pano',
		width:80
	},{
		header:"患者姓名",
		dataIndex:'paname',
		width:80
	},{
		header:"患者科室",
		dataIndex:'admloc',
		width:150
	},{
		header:"医生",
		dataIndex:'doctor',
		width:80
	},{
		header:"医嘱日期",
		dataIndex:'orddate',
		width:80
	},{
		header:"医嘱时间",
		dataIndex:'ordtime',
		width:80
	},{
		header:"补录入库科室",
		dataIndex:'mainLoc',
		allowBlank:false,
		saveColIndex:7,
		xtype:'combocolumn',
		editor:MainLoc,
		valueField:'mainLoc',
		displayField:'mainLocDesc',
		width:120
	}
];

function GetDetailParams(){
	var RecLoc = Ext.getCmp('RecLoc').getValue();
	var StartDate = Ext.getCmp('StartDate').getValue();
	var EndDate = Ext.getCmp('EndDate').getValue();
	if(RecLoc==''){
		Msg.info('warning', '请选择医嘱接收科室!');
		return false;
	}
	if(StartDate==''){
		Msg.info('warning', '请选择开始日期!');
		return false;
	}else{
		StartDate=StartDate.format(ARG_DATEFORMAT).toString();
	}
	if(EndDate==''){
		Msg.info('warning', '请选择截止日期!');
		return false;
	}else{
		EndDate=EndDate.format(ARG_DATEFORMAT).toString();
	}
	var Vendor = Ext.getCmp('Vendor').getValue();
	var Scg = '', LocId = RecLoc;
	var IngrFlag = '1';		//仅统计未补录部分
	var PaAdmNo = Ext.getCmp('Regno').getValue();
	var PackFlag = 'Y';
	if(Ext.isEmpty(Ext.getCmp('InciDesc').getValue())){
		gIncId = '';
	}
	var TableFlag = 'Y';		//跟台标记
	var StrParam = StartDate+'^'+EndDate+'^'+Vendor+'^'+Scg+'^'+gIncId
			+'^'+LocId+'^'+IngrFlag+'^'+RecLoc+'^^'
			+'^'+PaAdmNo+'^^'+TableFlag;
	return {'Sort' : '', 'Dir' : '', 'strPar' : StrParam};
}

var DetailGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	title : '跟台高值明细信息',
	id : 'DetailGrid',
	smType : 'cell',
	contentColumns : DetailCm,
	actionUrl : DictUrl + 'matordstataction.csp',
	queryAction : 'query',
	paramsFn : GetDetailParams,
	selectFirst : false,
	idProperty : 'orirowid',
	checkProperty : 'inci',
	paging : false,
	showTBar : false,
	tbar : [SaveBT],
	listeners : {
		beforeedit : function(e){
			if(e.field == 'qty'){
				if(!Ext.isEmpty(e.record.get('orirowid'))){
					e.cancel = true;
				}
			}
		}
	}
});

Ext.onReady(function() {
	Ext.QuickTips.init();
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, DetailGrid]
	});
});