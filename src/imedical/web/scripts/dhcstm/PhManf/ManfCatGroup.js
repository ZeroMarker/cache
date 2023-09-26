// 名称:		厂商类组授权(双向维度)
// 编写日期:	2014-11-18

var ManfScgUrl = 'dhcstm.manfcatgroupaction.csp';

//>>>>>>>>>>>>>>>厂商--类组授权>>>>>>>>>>>>>>>
var CodeField = {
	id : 'CodeField',
	xtype : 'textfield',
	fieldLabel : '代码',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true,
	emptyText : '厂商代码...'
};
	
var NameField = {
	id:'NameField',
	xtype : 'textfield',
	fieldLabel:'名称',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true,
	emptyText : '厂商名称...'
};

var FindVenButton = {
	xtype : 'uxbutton',
	text : '查询',
	iconCls : 'page_find',
	handler : function(){
		ManfGrid.load();
	}
}

var ManfCm = [{
		dataIndex : 'RowId',
		header : 'RowId',
		hidden : true
	},{
		dataIndex : 'Code',
		header : '厂商代码',
		width : 150
	},{
		dataIndex : 'Name',
		header : '厂商名称',
		width : 260
	}
];

//厂商加载构造参数
function ManfParamsFn(){
	var Code = Ext.getCmp("CodeField").getValue();
	var Name = Ext.getCmp("NameField").getValue();
	var Status = "Y";
	var StrParam = Code + "^" + Name + "^" + Status;
	return {StrParam : StrParam};
}

//选中行进行操作(查询授权和未授权的类组)
function ManfRowSelFn(grid,rowIndex,r){
	var ManfId = r.get('RowId');
	var StrParam = ManfId;
	ManfScgGrid.load({params:{StrParam:StrParam}});
	UnManfScgGrid.load({params:{StrParam:StrParam}});
}

var ManfGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'ManfGrid',
	title : '厂商',
	editable : false,
	childGrid : ["ManfScgGrid", "UnManfScgGrid"],
	contentColumns : ManfCm,
	smType : "row",
	singleSelect : false,
	smRowSelFn : ManfRowSelFn,
	autoLoadStore : true,
	actionUrl : ManfScgUrl,
	queryAction : "GetAllManf",
	idProperty : "RowId",
	checkProperty : "",
	paramsFn : ManfParamsFn,
	showTBar : false,
	tbar : [CodeField, ' ', NameField, ' ', FindVenButton]
});

ManfGrid.getSelectionModel().on('rowdeselect',function(sm, rowIndex, r){
	ManfScgGrid.removeAll();
	UnManfScgGrid.removeAll();
});

//授权保存操作
var ManfScgUpdButton = {
	xtype : 'button',
	text : '保存',
	iconCls : 'page_save',
	height : 30,
	width : 70,
	handler : function(){
		SaveManfScg();
	}
}

var ManfScgCm = [{
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
		isPlugin : true,
		width : 60
	}
];

var ManfScgGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'ManfScgGrid',
	title : '已授权',
	region : 'west',
	width : 300,
	contentColumns : ManfScgCm,
	smType : "row",
	singleSelect : false,
	selectFirst : false,
	actionUrl : ManfScgUrl,
	queryAction : "GetManfScg",
	idProperty : "RowId",
	checkProperty : 'RowId',
	showTBar : false,
	tbar : [ManfScgUpdButton],
	paging : true,
	listeners : {
		rowdblclick : DelManfScg
	}
});

function SaveManfScg(){
	var ListData = "";
	var ManfScgMr = ManfScgGrid.getModifiedRecords();
	if(Ext.isEmpty(ManfScgMr)){
		Msg.info("warning","没有需要保存的信息!");
		return;
	}else{
		for(var i=0,len=ManfScgMr.length; i<len; i++){
			var RowId = ManfScgMr[i].get('RowId');
			var UseFlag = ManfScgMr[i].get('UseFlag');
			var ManfScgInfo = RowId + "^" + UseFlag;
			if(ListData == ""){
				ListData = ManfScgInfo;
			}else{
				ListData = ListData + RowDelim + ManfScgInfo;
			}
		}
	}
	Ext.Ajax.request({
		url : ManfScgUrl + '?actiontype=Update',
		params : {ListData : ListData},
		waitMsg:'保存中...',
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","保存成功!");
				RefreshManfScg();
			}else{
				Msg.info("error","保存失败!");
			}
		},
		scope: this
	});
}

function DelManfScg(){
	var ManfIdStr = "", ScgStr = "";
	var ManfSels = ManfGrid.getSelections();
	if(Ext.isEmpty(ManfSels)){
		Msg.info("warning","请选择需要取消授权的厂商!");
		return;
	}else{
		for(var i=0,len=ManfSels.length; i<len; i++){
			var ManfId = ManfSels[i].get('RowId');
			if(ManfIdStr==""){
				ManfIdStr = ManfId
			}else{
				ManfIdStr = ManfIdStr + "^" + ManfId;
			}
		}
	}
	var ScgSels = ManfScgGrid.getSelections();
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
		url : ManfScgUrl + '?actiontype=Delete',
		params : {ManfIdStr : ManfIdStr, ScgStr : ScgStr},
		waitMsg:'删除中...',
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","删除成功!");
				RefreshManfScg();
			}else{
				Msg.info("error","删除失败!");
			}
		},
		scope: this
	});
}

var UnManfScgCm = [{
		header : '类组id',
		dataIndex : 'Scg',
		hidden : true
	},{
		header : '类组描述',
		dataIndex : 'ScgDesc',
		width : 200
	}
];

var UnManfScgGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'UnManfScgGrid',
	title : '未授权',
	region : 'east',
	width : 300,
	contentColumns : UnManfScgCm,
	smType : "row",
	singleSelect : false,
	selectFirst : false,
	actionUrl : ManfScgUrl,
	queryAction : "GetUnManfScg",
	idProperty : "RowId",
	checkProperty : 'RowId',
	showTBar : false,
	paging : true,
	listeners : {
		rowdblclick : AddManfStkGrp
	}
});

function AddManfStkGrp(){
	var ManfIdStr = "", ScgStr = "";
	var ManfSels = ManfGrid.getSelections();
	if(Ext.isEmpty(ManfSels)){
		Msg.info("warning","请选择需要授权的厂商!");
		return;
	}else{
		for(var i=0,len=ManfSels.length; i<len; i++){
			var VenorId = ManfSels[i].get('RowId');
			if(ManfIdStr==""){
				ManfIdStr = VenorId;
			}else{
				ManfIdStr = ManfIdStr + "^" + VenorId;
			}
		}
	}
	var ScgSels = UnManfScgGrid.getSelections();
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
		url: ManfScgUrl + '?actiontype=Save',
		params: {ScgStr:ScgStr, ManfIdStr:ManfIdStr},
		failure: function(result, request) {
			Msg.info("error", "请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success", "保存成功!");
				RefreshManfScg();
			}else{
				Msg.info("error", "保存失败!");
			}
		},
		scope: this
	});
}

function RefreshManfScg(){
	ManfScgGrid.reload();
	UnManfScgGrid.reload();
}

var AddSome = {
	xtype : 'uxbutton',
	//text : '<<',
	iconCls : 'tag_add',
	width : 45,
	handler : AddManfStkGrp
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
	handler : DelManfScg
}

var ManfScgButtonPanel = {
	xtype : 'panel',
	region : 'center',
	layout : 'vbox',
	layoutConfig : {
		align : 'center',
		pack : 'center'
	},
	items : [AddSome, ButtonSpace, DelSome]
};

var ManfScgPanel = new Ext.Panel({
	region : 'east',
	width : 650,
	layout : 'border',
	items:[ManfScgGrid, ManfScgButtonPanel, UnManfScgGrid]
});

//<<<<<<<<<<<<<<<厂商--类组授权<<<<<<<<<<<<<<<

//>>>>>>>>>>>>>>>类组--厂商授权>>>>>>>>>>>>>>>
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

function ScgParamsFn(){
	var StrParam = App_StkTypeCode;
	return {StrParam : StrParam};
}

function ScgRowSelFn(grid,rowIndex,r){
	var Scg = r.get('RowId');
	var StrParam = Scg;
	ScgManfGrid.load({params:{StrParam:StrParam}});
	UnScgManfGrid.load({params:{StrParam:StrParam}});
}

var ScgGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'ScgGrid',
	title : '类组',
	editable : false,
	childGrid : ["ScgManfGrid", "UnScgManfGrid"],
	contentColumns : ScgCm,
	smType : "row",
	singleSelect : false,
	smRowSelFn : ScgRowSelFn,
	autoLoadStore : true,
	actionUrl : ManfScgUrl,
	queryAction : "GetAllScg",
	idProperty : "RowId",
	checkProperty : "",
	paramsFn : ScgParamsFn,
	showTBar : false
});

ScgGrid.getSelectionModel().on('rowdeselect',function(sm, rowIndex, r){
	ScgManfGrid.removeAll();
	UnScgManfGrid.removeAll();
});

var ManfScgUpdButton = {
	xtype : 'button',
	text : '保存(是否可用)',
	iconCls : 'page_save',
	height : 30,
	width : 70,
	handler : SaveScgManf
}

var ScgManfCm = [{
		header : 'RowId',
		dataIndex : 'RowId',
		hidden : true
	},{
		header : '厂商rowid',
		dataIndex : 'Manf',
		hidden : true
	},{
		header : '厂商名称',
		dataIndex : 'ManfName',
		width : 200
	},{
		header : '是否可用',
		dataIndex : 'UseFlag',
		xtype : 'checkcolumn',
		isPlugin : true,
		width : 60
	}
];

var ScgManfGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'ScgManfGrid',
	title : '已授权',
	region : 'west',
	width : 300,
	contentColumns : ScgManfCm,
	smType : "row",
	singleSelect : false,
	selectFirst : false,
	actionUrl : ManfScgUrl,
	queryAction : "GetScgManf",
	idProperty : "RowId",
	checkProperty : 'RowId',
	showTBar : false,
	tbar : [ManfScgUpdButton],
	paging : true,
	listeners : {
		rowdblclick : DelScgManf
	}
});

function SaveScgManf(){
	var ListData = "";
	var ScgManfMr = ScgManfGrid.getModifiedRecords();
	if(Ext.isEmpty(ScgManfMr)){
		Msg.info("warning","没有需要保存的信息!");
		return;
	}else{
		for(var i=0,len=ScgManfMr.length; i<len; i++){
			var RowId = ScgManfMr[i].get('RowId');
			var UseFlag = ScgManfMr[i].get('UseFlag');
			var ManfScgInfo = RowId + "^" + UseFlag;
			if(ListData == ""){
				ListData = ManfScgInfo;
			}else{
				ListData = ListData + RowDelim + ManfScgInfo;
			}
		}
	}
	Ext.Ajax.request({
		url : ManfScgUrl + '?actiontype=Update',
		params : {ListData : ListData},
		waitMsg:'保存中...',
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","保存成功!");
				RefreshScgManf();
			}else{
				Msg.info("error","保存失败!");
			}
		},
		scope: this
	});
}

//删除已授权类组
function DelScgManf(){
	var ManfIdStr = "", ScgStr = "";
	var ManfSels = ScgManfGrid.getSelections();
	if(Ext.isEmpty(ManfSels)){
		Msg.info("warning","请选择需要取消授权的厂商!");
		return;
	}else{
		for(var i=0,len=ManfSels.length; i<len; i++){
			var VenorId = ManfSels[i].get('Manf');
			if(ManfIdStr==""){
				ManfIdStr = VenorId;
			}else{
				ManfIdStr = ManfIdStr + "^" + VenorId;
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
		url : ManfScgUrl + '?actiontype=Delete',
		params : {ManfIdStr : ManfIdStr, ScgStr : ScgStr},
		waitMsg:'删除中...',
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","删除成功!");
				RefreshScgManf();
			}else{
				Msg.info("error","删除失败!");
			}
		},
		scope: this
	});
}

var UnScgManfCm = [{
		header : '厂商rowid',
		dataIndex : 'Manf',
		hidden : true
	},{
		header : '厂商名称',
		dataIndex : 'ManfName',
		width : 200
	}
];

var UnScgManfGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'UnScgManfGrid',
	title : '未授权',
	region : 'east',
	width : 300,
	editable : false,
	contentColumns : UnScgManfCm,
	smType : "row",
	singleSelect : false,
	selectFirst : false,
	actionUrl : ManfScgUrl,
	queryAction : "GetUnScgManf",
	idProperty : "Manf",
	showTBar : false,
	paging : true,
	listeners : {
		rowdblclick : AddScgManf
	}
});

function AddScgManf(){
	var ManfIdStr = "", ScgStr = "";
	var ManfSels = UnScgManfGrid.getSelections();
	if(Ext.isEmpty(ManfSels)){
		Msg.info("warning","请选择需要授权的厂商!");
		return;
	}else{
		for(var i=0,len=ManfSels.length; i<len; i++){
			var ManfId = ManfSels[i].get('Manf');
			if(ManfIdStr==""){
				ManfIdStr = ManfId;
			}else{
				ManfIdStr = ManfIdStr + "^" + ManfId;
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
		url: ManfScgUrl + '?actiontype=Save',
		params: {ScgStr:ScgStr, ManfIdStr:ManfIdStr},
		failure: function(result, request) {
			Msg.info("error", "请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success", "保存成功!");
				RefreshScgManf();
			}else{
				Msg.info("error", "保存失败!");
			}
		},
		scope: this
	});
}

function RefreshScgManf(){
	ScgManfGrid.reload();
	UnScgManfGrid.reload();
}

var AddSomeManf = {
	xtype : 'uxbutton',
	//text : '<<',
	iconCls : 'tag_add',
	width : 45,
	handler : AddScgManf
}

var ButtonSpaceScg = {
	xtype : 'spacer',
	height : 20
}

var DelSomeManf = {
	xtype : 'uxbutton',
	//text : '>>',
	iconCls : 'tag_delete',
	width : 45,
	handler : DelScgManf
}

var ScgManfButtonPanel = {
	xtype : 'panel',
	region : 'center',
	layout : 'vbox',
	layoutConfig : {
		align : 'center',
		pack : 'center'
	},
	items : [AddSomeManf, ButtonSpaceScg, DelSomeManf]
};

var ScgManfPanel = new Ext.Panel({
	region : 'east',
	width : 650,
	layout : 'border',
	items:[ScgManfGrid, ScgManfButtonPanel, UnScgManfGrid]
});

//<<<<<<<<<<<<<<<类组--厂商授权<<<<<<<<<<<<<<<

var CatScgTab = new Ext.TabPanel({
	region : 'center',
	activeTab : 0,
	items : [{
			title : '厂商--类组',
			id : 'ItmDetail',
			layout : 'border',
			items:[ManfGrid, ManfScgPanel]
		},{
			title:'类组--厂商',
			id:'BatDetail',
			layout:'border',
			items:[ScgGrid, ScgManfPanel]
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
