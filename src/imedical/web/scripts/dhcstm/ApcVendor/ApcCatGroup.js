// 名称:		供应商类组授权(双向维度)
// 编写日期:	2014-11-18

var ApcScgUrl = 'dhcstm.apccatgroupaction.csp';

//>>>>>>>>>>>>>>>供应商--类组授权>>>>>>>>>>>>>>>
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
		dataIndex : 'RowId',
		header : 'RowId',
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
	var VendorId = r.get('RowId');
	var StrParam = VendorId;
	ApcScgGrid.load({params:{StrParam:StrParam}});
	UnApcScgGrid.load({params:{StrParam:StrParam}});
}

var VendorGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'VendorGrid',
	title : '供应商',
	editable : false,
	childGrid : ["ApcScgGrid", "UnApcScgGrid"],
	contentColumns : VendorCm,
	smType : "row",
	singleSelect : false,
	smRowSelFn : VendorRowSelFn,
	autoLoadStore : true,
	actionUrl : ApcScgUrl,
	queryAction : "GetAllVendor",
	idProperty : "RowId",
	checkProperty : "",
	paramsFn : VendorParamsFn,
	showTBar : false,
	tbar : [CodeField, ' ', NameField, ' ', FindVenButton]
});

VendorGrid.getSelectionModel().on('rowdeselect',function(sm, rowIndex, r){
	ApcScgGrid.removeAll();
	UnApcScgGrid.removeAll();
});

var ApcScgUpdButton = {
	xtype : 'button',
	text : '保存',
	iconCls : 'page_save',
	height : 30,
	width : 70,
	handler : function(){
		SaveApcScg();
	}
}

var ApcScgCm = [{
		header : 'RowId',
		dataIndex : 'RowId',
		hidden : true
	},{
		header : '类组id',
		dataIndex : 'Scg',
		hidden : true
	},{
		header : '类组描述',
		dataIndex : 'ScgDesc',
		width : 200
	},{
		header : '是否可用',
		dataIndex : 'UseFlag',
		xtype : 'checkcolumn',
		width : 60
	}
];

var ApcScgGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'ApcScgGrid',
	title : '已授权',
	region : 'west',
	width : 300,
	contentColumns : ApcScgCm,
	smType : "row",
	singleSelect : false,
	selectFirst : false,
	actionUrl : ApcScgUrl,
	queryAction : "GetApcScg",
	idProperty : "RowId",
	checkProperty : 'RowId',
	showTBar : false,
	tbar : [ApcScgUpdButton],
	paging : true,
	listeners : {
		rowdblclick : DelApcScg
	}
});

function SaveApcScg(){
	var ListData = "";
	var ApcScgMr = ApcScgGrid.getModifiedRecords();
	if(Ext.isEmpty(ApcScgMr)){
		Msg.info("warning","没有需要保存的信息!");
		return;
	}else{
		for(var i=0,len=ApcScgMr.length; i<len; i++){
			var RowId = ApcScgMr[i].get('RowId');
			var UseFlag = ApcScgMr[i].get('UseFlag');
			var ApcScgInfo = RowId + "^" + UseFlag;
			if(ListData == ""){
				ListData = ApcScgInfo;
			}else{
				ListData = ListData + RowDelim + ApcScgInfo;
			}
		}
	}
	Ext.Ajax.request({
		url : ApcScgUrl + '?actiontype=Update',
		params : {ListData : ListData},
		waitMsg:'保存中...',
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","保存成功!");
				RefreshApcScg();
			}else{
				Msg.info("error","保存失败!");
			}
		},
		scope: this
	});
}

function DelApcScg(){
	var VendorIdStr = "", ScgStr = "";
	var VendorSels = VendorGrid.getSelections();
	if(Ext.isEmpty(VendorSels)){
		Msg.info("warning","请选择需要取消授权的供应商!");
		return;
	}else{
		for(var i=0,len=VendorSels.length; i<len; i++){
			var VenorId = VendorSels[i].get('RowId');
			if(VendorIdStr==""){
				VendorIdStr = VenorId;
			}else{
				VendorIdStr = VendorIdStr + "^" + VenorId;
			}
		}
	}
	var ScgSels = ApcScgGrid.getSelections();
	if(Ext.isEmpty(ScgSels)){
		Msg.info("warning","请选择需要取消授权的类组!");
		return;
	}else{
		for(var i=0,len=ScgSels.length; i<len; i++){
			var Scg = ScgSels[i].get('Scg');
			if(ScgStr==""){
				ScgStr = Scg;
			}else{
				ScgStr = ScgStr + "^" + Scg;
			}
		}
	}
	Ext.Ajax.request({
		url : ApcScgUrl + '?actiontype=Delete',
		params : {VendorIdStr : VendorIdStr, ScgStr : ScgStr},
		waitMsg:'删除中...',
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","删除成功!");
				RefreshApcScg();
			}else{
				Msg.info("error","删除失败!");
			}
		},
		scope: this
	});
}

var UnApcScgCm = [{
		header : '类组id',
		dataIndex : 'Scg',
		hidden : true
	},{
		header : '类组描述',
		dataIndex : 'ScgDesc',
		width : 200
	}
];

var UnApcScgGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'UnApcScgGrid',
	title : '未授权',
	region : 'east',
	width : 300,
	contentColumns : UnApcScgCm,
	smType : "row",
	singleSelect : false,
	selectFirst : false,
	actionUrl : ApcScgUrl,
	queryAction : "GetUnApcScg",
	idProperty : "RowId",
	checkProperty : 'RowId',
	showTBar : false,
	paging : true,
	listeners : {
		rowdblclick : AddApcStkGrp
	}
});

function AddApcStkGrp(){
	var VendorIdStr = "", ScgStr = "";
	var VendorSels = VendorGrid.getSelections();
	if(Ext.isEmpty(VendorSels)){
		Msg.info("warning","请选择需要授权的供应商!");
		return;
	}else{
		for(var i=0,len=VendorSels.length; i<len; i++){
			var VenorId = VendorSels[i].get('RowId');
			if(VendorIdStr==""){
				VendorIdStr = VenorId;
			}else{
				VendorIdStr = VendorIdStr + "^" + VenorId;
			}
		}
	}
	var ScgSels = UnApcScgGrid.getSelections();
	if(Ext.isEmpty(ScgSels)){
		Msg.info("warning","请选择需要授权类组!");
		return;
	}else{
		for(var i=0,len=ScgSels.length; i<len; i++){
			var Scg = ScgSels[i].get('Scg');
			if(ScgStr==""){
				ScgStr = Scg;
			}else{
				ScgStr = ScgStr + "^" + Scg;
			}
		}
	}
	Ext.Ajax.request({
		url: ApcScgUrl + '?actiontype=Save',
		params: {ScgStr:ScgStr, VendorIdStr:VendorIdStr},
		failure: function(result, request) {
			Msg.info("error", "请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success", "保存成功!");
				RefreshApcScg();
			}else{
				Msg.info("error", "保存失败!");
			}
		},
		scope: this
	});
}

function RefreshApcScg(){
	ApcScgGrid.reload();
	UnApcScgGrid.reload();
}

var AddSome = {
	xtype : 'uxbutton',
	//text : '<<',
	iconCls : 'tag_add',
	width : 45,
	handler : AddApcStkGrp
}

var ButtonSpace = {
	xtype : 'spacer',
	height : 20
}

var DelSome = {
	xtype : 'uxbutton',
	//text : '>>',
	iconCls : 'tag_delete',
	width : 45,
	handler : DelApcScg
}

var ApcScgButtonPanel = {
	xtype : 'panel',
	region : 'center',
	layout : 'vbox',
	layoutConfig : {
		align : 'center',
		pack : 'center'
	},
	items : [AddSome, ButtonSpace, DelSome]
};

var ApcScgPanel = new Ext.Panel({
	region : 'east',
	width : 650,
	layout : 'border',
	items:[ApcScgGrid, ApcScgButtonPanel, UnApcScgGrid]
});

//<<<<<<<<<<<<<<<供应商--类组授权<<<<<<<<<<<<<<<

//>>>>>>>>>>>>>>>类组--供应商授权>>>>>>>>>>>>>>>
var ScgCm = [{
		dataIndex : 'RowId',
		header : 'RowId',
		hidden : true
	},{
		dataIndex : 'ScgCode',
		header : '类组代码',
		width : 150
	},{
		dataIndex : 'ScgDesc',
		header : '类组名称',
		width : 260
	}
];

function ScgRowSelFn(grid,rowIndex,r){
	var Scg = r.get('RowId');
	var StrParam = Scg;
	ScgApcGrid.load({params:{StrParam:StrParam}});
	UnScgApcGrid.load({params:{StrParam:StrParam}});
}

var ScgGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'ScgGrid',
	title : '类组',
	editable : false,
	childGrid : ["ScgApcGrid", "UnScgApcGrid"],
	contentColumns : ScgCm,
	smType : "row",
	singleSelect : false,
	smRowSelFn : ScgRowSelFn,
	autoLoadStore : true,
	actionUrl : ApcScgUrl,
	queryAction : "GetAllScg",
	idProperty : "RowId",
	checkProperty : "",
	showTBar : false
});

ScgGrid.getSelectionModel().on('rowdeselect',function(sm, rowIndex, r){
	ScgApcGrid.removeAll();
	UnScgApcGrid.removeAll();
});

var ApcScgUpdButton = {
	xtype : 'button',
	text : '保存',
	iconCls : 'page_save',
	height : 30,
	width : 70,
	handler : SaveScgApc
}

var ScgApcCm = [{
		header : 'RowId',
		dataIndex : 'RowId',
		hidden : true
	},{
		header : '供应商rowid',
		dataIndex : 'Vendor',
		hidden : true
	},{
		header : '供应商名称',
		dataIndex : 'VendorName',
		width : 200
	},{
		header : '是否可用',
		dataIndex : 'UseFlag',
		xtype : 'checkcolumn',
		isPlugin : true,
		width : 60
	}
];

var ScgApcGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'ScgApcGrid',
	title : '已授权',
	region : 'west',
	width : 300,
	contentColumns : ScgApcCm,
	smType : "row",
	singleSelect : false,
	selectFirst : false,
	actionUrl : ApcScgUrl,
	queryAction : "GetScgApc",
	idProperty : "RowId",
	checkProperty : 'RowId',
	showTBar : false,
	tbar : [ApcScgUpdButton],
	paging : true,
	remoteSort : true,
	listeners : {
		rowdblclick : DelScgVendor
	}
});

function SaveScgApc(){
	var ListData = "";
	var ScgApcMr = ScgApcGrid.getModifiedRecords();
	if(Ext.isEmpty(ScgApcMr)){
		Msg.info("warning","没有需要保存的信息!");
		return;
	}else{
		for(var i=0,len=ScgApcMr.length; i<len; i++){
			var RowId = ScgApcMr[i].get('RowId');
			var UseFlag = ScgApcMr[i].get('UseFlag');
			var ApcScgInfo = RowId + "^" + UseFlag;
			if(ListData == ""){
				ListData = ApcScgInfo;
			}else{
				ListData = ListData + RowDelim + ApcScgInfo;
			}
		}
	}
	Ext.Ajax.request({
		url : ApcScgUrl + '?actiontype=Update',
		params : {ListData : ListData},
		waitMsg:'保存中...',
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","保存成功!");
				RefreshScgApc();
			}else{
				Msg.info("error","保存失败!");
			}
		},
		scope: this
	});
}

function DelScgVendor(){
	var VendorIdStr = "", ScgStr = "";
	var VendorSels = ScgApcGrid.getSelections();
	if(Ext.isEmpty(VendorSels)){
		Msg.info("warning","请选择需要取消授权的供应商!");
		return;
	}else{
		for(var i=0,len=VendorSels.length; i<len; i++){
			var VenorId = VendorSels[i].get('Vendor');
			if(VendorIdStr==""){
				VendorIdStr = VenorId;
			}else{
				VendorIdStr = VendorIdStr + "^" + VenorId;
			}
		}
	}
	var ScgSels = ScgGrid.getSelections();
	if(Ext.isEmpty(ScgSels)){
		Msg.info("warning","请选择需要取消授权的类组!");
		return;
	}else{
		for(var i=0,len=ScgSels.length; i<len; i++){
			var Scg = ScgSels[i].get('RowId');
			if(ScgStr==""){
				ScgStr = Scg;
			}else{
				ScgStr = ScgStr + "^" + Scg;
			}
		}
	}
	Ext.Ajax.request({
		url : ApcScgUrl + '?actiontype=Delete',
		params : {VendorIdStr : VendorIdStr, ScgStr : ScgStr},
		waitMsg:'删除中...',
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","删除成功!");
				RefreshScgApc();
			}else{
				Msg.info("error","删除失败!");
			}
		},
		scope: this
	});
}

var UnScgApcCm = [{
		header : '供应商rowid',
		dataIndex : 'Vendor',
		hidden : true
	},{
		header : '供应商名称',
		dataIndex : 'VendorName',
		width : 200
	}
];

var UnScgApcGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'UnScgApcGrid',
	title : '未授权',
	region : 'east',
	width : 300,
	editable : false,
	contentColumns : UnScgApcCm,
	smType : "row",
	singleSelect : false,
	selectFirst : false,
	actionUrl : ApcScgUrl,
	queryAction : "GetUnScgApc",
	idProperty : "Vendor",
	showTBar : false,
	paging : true,
	remoteSort : true,
	listeners : {
		rowdblclick : AddScgVendor
	}
});

function AddScgVendor(){
	var VendorIdStr = "", ScgStr = "";
	var VendorSels = UnScgApcGrid.getSelections();
	if(Ext.isEmpty(VendorSels)){
		Msg.info("warning","请选择需要授权的供应商!");
		return;
	}else{
		for(var i=0,len=VendorSels.length; i<len; i++){
			var VenorId = VendorSels[i].get('Vendor');
			if(VendorIdStr==""){
				VendorIdStr = VenorId;
			}else{
				VendorIdStr = VendorIdStr + "^" + VenorId;
			}
		}
	}
	var ScgSels = ScgGrid.getSelections();
	if(Ext.isEmpty(ScgSels)){
		Msg.info("warning","请选择需要授权类组!");
		return;
	}else{
		for(var i=0,len=ScgSels.length; i<len; i++){
			var Scg = ScgSels[i].get('RowId');
			if(ScgStr==""){
				ScgStr = Scg;
			}else{
				ScgStr = ScgStr + "^" + Scg;
			}
		}
	}
	Ext.Ajax.request({
		url: ApcScgUrl + '?actiontype=Save',
		params: {ScgStr:ScgStr, VendorIdStr:VendorIdStr},
		failure: function(result, request) {
			Msg.info("error", "请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success", "保存成功!");
				RefreshScgApc();
			}else{
				Msg.info("error", "保存失败!");
			}
		},
		scope: this
	});
}

function RefreshScgApc(){
	ScgApcGrid.reload();
	UnScgApcGrid.reload();
}

var AddSomeVendor = {
	xtype : 'uxbutton',
	//text : '<<<',
	iconCls : 'tag_add',
	width : 45,
	handler : AddScgVendor
}

var ButtonSpaceScg = {
	xtype : 'spacer',
	height : 20
}

var DelSomeVendor = {
	xtype : 'uxbutton',
	//text : '>>',
	iconCls : 'tag_delete',
	width : 45,
	handler : DelScgVendor
}

var ScgApcButtonPanel = {
	xtype : 'panel',
	region : 'center',
	layout : 'vbox',
	layoutConfig : {
		align : 'center',
		pack : 'center'
	},
	items : [AddSomeVendor, ButtonSpaceScg, DelSomeVendor]
};

var ScgApcPanel = new Ext.Panel({
	region : 'east',
	width : 650,
	layout : 'border',
	items:[ScgApcGrid, ScgApcButtonPanel, UnScgApcGrid]
});

//<<<<<<<<<<<<<<<类组--供应商授权<<<<<<<<<<<<<<<

var CatScgTab = new Ext.TabPanel({
	region : 'center',
	activeTab : 0,
	items : [{
			title : '供应商--类组',
			id : 'ItmDetail',
			layout : 'border',
			items:[VendorGrid, ApcScgPanel]
		},{
			title:'类组--供应商',
			id:'BatDetail',
			layout:'border',
			items:[ScgGrid, ScgApcPanel]
		}]
})

Ext.onReady(function(){
	Ext.QuickTips.init();
	
	var mainPanel = new Ext.ux.Viewport({
		layout : 'fit',
		items : [CatScgTab],
		renderTo:'mainPanel'
	});
});
