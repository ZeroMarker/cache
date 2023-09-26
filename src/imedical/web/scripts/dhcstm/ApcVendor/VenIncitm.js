// 名称:		供应商物资双向授权维护
// 编写日期:	20190429
// 编写人：lihui

var VenInciUrl = 'dhcstm.venincitmaction.csp';
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];

//>>>>>>>>>>>>>>>供应商--物资授权>>>>>>>>>>>>>>>
var CodeField = {
	id : 'CodeField',
	xtype : 'textfield',
	fieldLabel : '代码',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true,
	emptyText : '供应商代码...'
};
	
var NameField = {
	id:'NameField',
	xtype : 'textfield',
	fieldLabel:'名称',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true,
	emptyText : '供应商名称...'
};

var FindVenButton = {
	xtype : 'uxbutton',
	text : '查询',
	iconCls : 'page_find',
	handler : function(){
		VendorGrid.load();
	}
}

var VendorCm = [{
		dataIndex : 'Venid',
		header : 'Venid',
		hidden : true
	},{
		dataIndex : 'Code',
		header : '供应商代码',
		width : 150
	},{
		dataIndex : 'Name',
		header : '供应商名称',
		width : 260
	}
];

function VendorParamsFn(){
	var Code = Ext.getCmp("CodeField").getValue();
	var Name = Ext.getCmp("NameField").getValue();
	var Status = "A";
	var StrParam = Code + "^" + Name + "^" + Status;
	return {StrParam : StrParam};
}

function VendorRowSelFn(grid,rowIndex,r){
	var VendorId = r.get('Venid');
	var StrParam = VendorId;
	VenInciGrid.load({params:{StrParam:StrParam}});
}

var VendorGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'VendorGrid',
	title : '供应商',
	editable : false,
	childGrid : ["VenInciGrid"],
	contentColumns : VendorCm,
	smType : "row",
	singleSelect : false,
	smRowSelFn : VendorRowSelFn,
	autoLoadStore : true,
	actionUrl : VenInciUrl,
	queryAction : "GetAllVendor",
	idProperty : "Venid",
	checkProperty : "",
	paramsFn : VendorParamsFn,
	showTBar : false,
	tbar : [CodeField, ' ', NameField, ' ', FindVenButton]
});

VendorGrid.getSelectionModel().on('rowdeselect',function(sm, rowIndex, r){
	VenInciGrid.removeAll();
});

var VenInciCm = [
	{
		header : 'RowId',
		dataIndex : 'RowId',
		hidden : true
	},{
		header : 'IncId',
		dataIndex : 'IncId',
		hidden : true
	},{
		header : '物资代码',
		dataIndex : 'Incicode',
		width : 100
	},{
		header : '物资名称',
		dataIndex : 'Incidesc',
		width : 200
	}
];
var AddUnApcInciButton = {
	xtype : 'uxbutton',
	text : '添加',
	iconCls : 'page_find',
	handler : function(){
		var rowdata=VendorGrid.getSelectionModel().getSelected();
		var venid=rowdata.get("Venid");
		if (Ext.isEmpty(venid)){Msg.info("warning","请在供应商列表选择一个供应商");return false;}
		SelectItmToApcInci(venid,RefreshVenInci);
	}
}
function StopApcInci(){
	var rowdata=VendorGrid.getSelectionModel().getSelected();
	var venid=rowdata.get("Venid");
	if (Ext.isEmpty(venid)){Msg.info("warning","请在供应商列表选择一个供应商");return false;}
	var apcinciRowData=VenInciGrid.getSelectionModel().getSelections();
	if (Ext.isEmpty(apcinciRowData)){Msg.info("warning","请选择供应商取消授权的物资");return false;}
	var RowIdStr="";
	for(var i=0;i<apcinciRowData.length;i++){
		var Rowid=apcinciRowData[i].get("RowId");
		if (RowIdStr==""){
			RowIdStr=Rowid;
		}else{
			RowIdStr=RowIdStr+"^"+Rowid;
		}
	}
	if (Ext.isEmpty(RowIdStr)){Msg.info("warning","请选择供应商取消授权的物资");return false;}
	Ext.Ajax.request({
		url:VenInciUrl + '?actiontype=StopInciVendor',
		params:{RowIdStr:RowIdStr},
		waitMsg:"处理中...",
		failure:function(result,request){
				Msg.info("error","请检查网络连接！");
			},
		success:function(result,request){
				var jsonData=Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=="true"){
					Msg.info("success","取消授权成功");
					RefreshVenInci();
				}else{
					Msg.info("error","取消授权失败"+jsonData.info);
				}
			},
		scope:this
	});
	
}
var StopApcInciButton = {
	xtype : 'uxbutton',
	text : '取消授权',
	iconCls : 'page_find',
	handler : function(){
		StopApcInci();
	}
}
var VenInciGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'VenInciGrid',
	title : '物资列表',
	region : 'center',
	contentColumns : VenInciCm,
	smType : "checkbox",
	singleSelect : false,
	selectFirst : false,
	actionUrl : VenInciUrl,
	queryAction : "GetVenInci",
	idProperty : "RowId",
	checkProperty : 'RowId',
	showTBar : false,
	paging : true,
	tbar : [AddUnApcInciButton,StopApcInciButton]
});


function RefreshVenInci(){
	VenInciGrid.reload();
}

var VenInciPanel = new Ext.Panel({
	region : 'east',
	width : 650,
	layout : 'border',
	items:[VenInciGrid]
});

//<<<<<<<<<<<<<<<供应商--物资授权<<<<<<<<<<<<<<<

//>>>>>>>>>>>>>>>物资--供应商授权>>>>>>>>>>>>>>>
var IncidCm = [{
		dataIndex : 'InciRowid',
		header : 'InciRowid',
		hidden : true
	},{
		dataIndex : 'InciCode',
		header : '物资代码',
		width : 150
	},{
		dataIndex : 'InciDesc',
		header : '物资名称',
		width : 260
	}
];

function IncidRowSelFn(grid,rowIndex,r){
	var Incid = r.get('InciRowid');
	var StrParam = Incid+"^A";
	InciApcGrid.load({params:{StrParam:StrParam}});
	UnInciApcGrid.load({params:{StrParam:StrParam}});
}
var inciurl="dhcstm.druginfomaintainaction.csp";
var InciGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'InciGrid',
	title : '物资',
	editable : false,
	childGrid : ["InciApcGrid", "UnInciApcGrid"],
	contentColumns : IncidCm,
	smType : "row",
	singleSelect : false,
	smRowSelFn : IncidRowSelFn,
	autoLoadStore : true,
	actionUrl : inciurl,
	queryAction : "GetItm",
	idProperty : "InciRowid",
	checkProperty : "",
	showTBar : false
});

InciGrid.getSelectionModel().on('rowdeselect',function(sm, rowIndex, r){
	InciApcGrid.removeAll();
	UnInciApcGrid.removeAll();
});

var InciApcCm = [{
		header : 'RowId',
		dataIndex : 'RowId',
		hidden : true
	},{
		header : 'Vendor',
		dataIndex : 'Vendor',
		hidden : true
	},{
		header : '供应商名称',
		dataIndex : 'VendorDesc',
		width : 200
	}
];

var InciApcGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'InciApcGrid',
	title : '供应商列表',
	region : 'west',
	width : 300,
	contentColumns : InciApcCm,
	smType : "row",
	singleSelect : false,
	selectFirst : false,
	actionUrl : VenInciUrl,
	queryAction : "GetInciApc",
	idProperty : "RowId",
	checkProperty : 'RowId',
	showTBar : false,
	paging : true,
	remoteSort : true,
	listeners : {
		rowdblclick : StopInciVendor
	}
});
function StopInciVendor(){
	var RowIdStr = "";
	var RowData = InciApcGrid.getSelections();
	if(Ext.isEmpty(RowData)){
		Msg.info("warning","请选择需要取消授权的供应商!");
		return;
	}else{
		for(var i=0,len=RowData.length; i<len; i++){
			var RowId = RowData[i].get('RowId');
			if(RowIdStr==""){
				RowIdStr = RowId;
			}else{
				RowIdStr = RowIdStr + "^" + RowId;
			}
		}
	}
	Ext.Ajax.request({
		url : VenInciUrl + '?actiontype=StopInciVendor',
		params : {RowIdStr : RowIdStr},
		waitMsg:'处理中...',
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","取消授权成功!");
				RefreshScgApc();
			}else{
				Msg.info("error","取消授权失败!"+jsonData.info);
			}
		},
		scope: this
	});
}

var UnInciApcCm = [{
		header : 'Venid',
		dataIndex : 'Venid',
		hidden : true
	},{
		header : '供应商名称',
		dataIndex : 'Name',
		width : 200
	}
];

var UnInciApcGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'UnInciApcGrid',
	title : '未授权',
	region : 'east',
	width : 300,
	editable : false,
	contentColumns : UnInciApcCm,
	smType : "row",
	singleSelect : false,
	selectFirst : false,
	actionUrl : VenInciUrl,
	queryAction : "GetUnInciApc",
	idProperty : "venid",
	showTBar : false,
	paging : true,
	remoteSort : true,
	listeners : {
		rowdblclick : AddInciVendor
	}
});

function AddInciVendor(){
	var VendorIdStr = "";
	var RowData = UnInciApcGrid.getSelections();
	if(Ext.isEmpty(RowData)){
		Msg.info("warning","请选择需要授权的供应商!");
		return;
	}else{
		for(var i=0,len=RowData.length; i<len; i++){
			var VenorId = RowData[i].get('Venid');
			if(VendorIdStr==""){
				VendorIdStr = VenorId;
			}else{
				VendorIdStr = VendorIdStr + "^" + VenorId;
			}
		}
	}
	var RowData = InciGrid.getSelected();
	if(Ext.isEmpty(RowData)){
		Msg.info("warning","请选择需要授权物资!");
		return;
	}else{
		var Incid=RowData.get("InciRowid");
	}
	Ext.Ajax.request({
		url: VenInciUrl + '?actiontype=AddInciVendor',
		params: {Incid:Incid, VendorIdStr:VendorIdStr},
		failure: function(result, request) {
			Msg.info("error", "请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success", "保存成功!");
				RefreshScgApc();
			}else{
				var retinfo=jsonData.info;
				Msg.info("error", "保存失败!"+retinfo);
			}
		},
		scope: this
	});
}

function RefreshScgApc(){
	InciApcGrid.reload();
	UnInciApcGrid.reload();
}

var AddSomeVendor = {
	xtype : 'uxbutton',
	//text : '<<<',
	iconCls : 'tag_add',
	width : 45,
	handler : AddInciVendor
}

var ButtonSpaceScg = {
	xtype : 'spacer',
	height : 20
}

var StopSomeVendor = {
	xtype : 'uxbutton',
	//text : '>>',
	iconCls : 'tag_delete',
	width : 45,
	handler : StopInciVendor
}

var InciApcButtonPanel = {
	xtype : 'panel',
	region : 'center',
	layout : 'vbox',
	layoutConfig : {
		align : 'center',
		pack : 'center'
	},
	items : [AddSomeVendor, ButtonSpaceScg, StopSomeVendor]
};

var InciVenPanel = new Ext.Panel({
	region : 'east',
	width : 650,
	layout : 'border',
	items:[InciApcGrid, InciApcButtonPanel, UnInciApcGrid]
});
// 物资编码
var M_InciCode = new Ext.form.TextField({
	fieldLabel : '<font color=blue>物资编码</font>',
	id : 'M_InciCode',
	name : 'M_InciCode',
	anchor : '90%',
	valueNotFoundText : '',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				search();
			}
		}
	}
});

// 物资名称
var M_InciDesc = new Ext.form.TextField({
	fieldLabel : '<font color=blue>物资名称</font>',
	id : 'M_InciDesc',
	name : 'M_InciDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = Ext.getCmp("M_StkGrpType").getValue();
				GetPhaOrderInfo(field.getValue(), stktype);
			}
		}
	}
});
// 物资别名
var M_GeneName = new Ext.form.TextField({
	fieldLabel : '<font color=blue>物资别名</font>',
	id : 'M_GeneName',
	name : 'M_GeneName',
	anchor : '90%',
	valueNotFoundText : '',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				search();
			}
		}
	}
});
// 物资类组
var M_StkGrpType=new Ext.ux.StkGrpComboBox({ 
	fieldLabel:'<font color=blue>类组</font>',
	id : 'M_StkGrpType',
	name : 'M_StkGrpType',
	StkType:App_StkTypeCode,     //标识类组类型
	UserId:gUserId,
	LocId:gLocId,
	DrugInfo:"Y",
	anchor : '90%',
	//listWidth : 200,
	listeners:{
		'select':function(){
			Ext.getCmp("M_StkCat").setValue('');
		}
	}
});

// 库存分类
var M_StkCat = new Ext.ux.ComboBox({
	fieldLabel : '<font color=blue>库存分类</font>',
	id : 'M_StkCat',
	name : 'M_StkCat',
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'StkCatName',
	params:{StkGrpId:'M_StkGrpType'}
});
var SearchBT = new Ext.Toolbar.Button({
	text : '查询',
	tooltip : '点击查询',
	iconCls : 'page_find',
	width : 70,
	height : 30,
	handler : function() {
		search();
	}
});
function search(){
	InciGrid.getStore().removeAll();
	InciGrid.getView().refresh();
	var inciDesc = Ext.getCmp("M_InciDesc").getValue();
	var inciCode = Ext.getCmp("M_InciCode").getValue();
	var alias = Ext.getCmp("M_GeneName").getValue();
	var stkCatId = Ext.getCmp("M_StkCat").getValue();
	var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
	if ((inciDesc == "")&&(inciCode == "")&& (alias =="")&& (stkCatId == "")&&(StkGrpType=="")) {
		Msg.info("error", "请选择查询条件!");
		return false;
	}
	var allFlag=2;
	var Createday= "";
	var Updateday= "";
	//药学大类id^药学子类id^药学更小分类id^类组id^^^^^^^建档时间^更新时间
	var others = "^^^"+StkGrpType+"^^^^^^^"+Createday+"^"+Updateday;
	// 分页加载数据
	InciGrid.getStore().setBaseParam('InciDesc',inciDesc);
	InciGrid.getStore().setBaseParam('InciCode',inciCode);
	InciGrid.getStore().setBaseParam('Alias',alias);
	InciGrid.getStore().setBaseParam('StkCatId',stkCatId);
	InciGrid.getStore().setBaseParam('AllFlag',allFlag);
	InciGrid.getStore().setBaseParam('Others',others);
	InciGrid.getStore().load();
}
var HisListTab = new Ext.ux.FormPanel({
	//labelWidth: 60,
	tbar : [SearchBT],
	items:[{
		xtype:'fieldset',
		title:'查询条件',
		layout: 'column',				
		style : 'padding:5px 0px 0px 5px',
		defaults : {border:false,xtype:'fieldset'},
		items : [{
			columnWidth: 0.5,
			items: [M_InciCode,M_InciDesc,M_GeneName]
		}, {
			columnWidth: 0.5,
			items : [M_StkGrpType,M_StkCat]
		}]
	}]
});
//<<<<<<<<<<<<<<<物资--供应商授权<<<<<<<<<<<<<<<

var VenInciTab = new Ext.TabPanel({
	region : 'center',
	activeTab : 0,
	items : [{
			title : '供应商--物资',
			id : 'VenInciDetail',
			layout : 'border',
			items:[VendorGrid, VenInciPanel]
		},{
			title:'物资--供应商',
			id:'InciVenDetail',
			layout:'border',
			items:[HisListTab,InciGrid, InciVenPanel]
		}]
})

Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var mainPanel = new Ext.ux.Viewport({
		layout : 'fit',
		items : [VenInciTab],
		renderTo:'mainPanel'
	});
});
