// ����:		����������Ȩ(˫��ά��)
// ��д����:	2014-11-18

var ManfScgUrl = 'dhcstm.manfcatgroupaction.csp';

//>>>>>>>>>>>>>>>����--������Ȩ>>>>>>>>>>>>>>>
var CodeField = {
	id : 'CodeField',
	xtype : 'textfield',
	fieldLabel : '����',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true,
	emptyText : '���̴���...'
};
	
var NameField = {
	id:'NameField',
	xtype : 'textfield',
	fieldLabel:'����',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true,
	emptyText : '��������...'
};

var FindVenButton = {
	xtype : 'uxbutton',
	text : '��ѯ',
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
		header : '���̴���',
		width : 150
	},{
		dataIndex : 'Name',
		header : '��������',
		width : 260
	}
];

//���̼��ع������
function ManfParamsFn(){
	var Code = Ext.getCmp("CodeField").getValue();
	var Name = Ext.getCmp("NameField").getValue();
	var Status = "Y";
	var StrParam = Code + "^" + Name + "^" + Status;
	return {StrParam : StrParam};
}

//ѡ���н��в���(��ѯ��Ȩ��δ��Ȩ������)
function ManfRowSelFn(grid,rowIndex,r){
	var ManfId = r.get('RowId');
	var StrParam = ManfId;
	ManfScgGrid.load({params:{StrParam:StrParam}});
	UnManfScgGrid.load({params:{StrParam:StrParam}});
}

var ManfGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'ManfGrid',
	title : '����',
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

//��Ȩ�������
var ManfScgUpdButton = {
	xtype : 'button',
	text : '����',
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
		header : '����id',
		dataIndex : 'Scg',
		hidden : true
	},{
		header : '��������',
		dataIndex : 'ScgDesc',
		width : 200
	},{
		header : '�Ƿ����',
		dataIndex : 'UseFlag',
		xtype : 'checkcolumn',
		isPlugin : true,
		width : 60
	}
];

var ManfScgGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'ManfScgGrid',
	title : '����Ȩ',
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
		Msg.info("warning","û����Ҫ�������Ϣ!");
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
		waitMsg:'������...',
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","����ɹ�!");
				RefreshManfScg();
			}else{
				Msg.info("error","����ʧ��!");
			}
		},
		scope: this
	});
}

function DelManfScg(){
	var ManfIdStr = "", ScgStr = "";
	var ManfSels = ManfGrid.getSelections();
	if(Ext.isEmpty(ManfSels)){
		Msg.info("warning","��ѡ����Ҫȡ����Ȩ�ĳ���!");
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
		Msg.info("warning","��ѡ����Ҫȡ����Ȩ������!");
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
		waitMsg:'ɾ����...',
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","ɾ���ɹ�!");
				RefreshManfScg();
			}else{
				Msg.info("error","ɾ��ʧ��!");
			}
		},
		scope: this
	});
}

var UnManfScgCm = [{
		header : '����id',
		dataIndex : 'Scg',
		hidden : true
	},{
		header : '��������',
		dataIndex : 'ScgDesc',
		width : 200
	}
];

var UnManfScgGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'UnManfScgGrid',
	title : 'δ��Ȩ',
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
		Msg.info("warning","��ѡ����Ҫ��Ȩ�ĳ���!");
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
		Msg.info("warning","��ѡ����Ҫ��Ȩ����!");
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
			Msg.info("error", "������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success", "����ɹ�!");
				RefreshManfScg();
			}else{
				Msg.info("error", "����ʧ��!");
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

//<<<<<<<<<<<<<<<����--������Ȩ<<<<<<<<<<<<<<<

//>>>>>>>>>>>>>>>����--������Ȩ>>>>>>>>>>>>>>>
var ScgCm = [{
		dataIndex : 'RowId',
		header : 'RowId',
		hidden : true
	},{
		dataIndex : 'ScgCode',
		header : '�������',
		width : 150
	},{
		dataIndex : 'ScgDesc',
		header : '��������',
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
	title : '����',
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
	text : '����(�Ƿ����)',
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
		header : '����rowid',
		dataIndex : 'Manf',
		hidden : true
	},{
		header : '��������',
		dataIndex : 'ManfName',
		width : 200
	},{
		header : '�Ƿ����',
		dataIndex : 'UseFlag',
		xtype : 'checkcolumn',
		isPlugin : true,
		width : 60
	}
];

var ScgManfGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'ScgManfGrid',
	title : '����Ȩ',
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
		Msg.info("warning","û����Ҫ�������Ϣ!");
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
		waitMsg:'������...',
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","����ɹ�!");
				RefreshScgManf();
			}else{
				Msg.info("error","����ʧ��!");
			}
		},
		scope: this
	});
}

//ɾ������Ȩ����
function DelScgManf(){
	var ManfIdStr = "", ScgStr = "";
	var ManfSels = ScgManfGrid.getSelections();
	if(Ext.isEmpty(ManfSels)){
		Msg.info("warning","��ѡ����Ҫȡ����Ȩ�ĳ���!");
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
		Msg.info("warning","��ѡ����Ҫȡ����Ȩ������!");
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
		waitMsg:'ɾ����...',
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","ɾ���ɹ�!");
				RefreshScgManf();
			}else{
				Msg.info("error","ɾ��ʧ��!");
			}
		},
		scope: this
	});
}

var UnScgManfCm = [{
		header : '����rowid',
		dataIndex : 'Manf',
		hidden : true
	},{
		header : '��������',
		dataIndex : 'ManfName',
		width : 200
	}
];

var UnScgManfGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'UnScgManfGrid',
	title : 'δ��Ȩ',
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
		Msg.info("warning","��ѡ����Ҫ��Ȩ�ĳ���!");
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
		Msg.info("warning","��ѡ����Ҫ��Ȩ����!");
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
			Msg.info("error", "������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success", "����ɹ�!");
				RefreshScgManf();
			}else{
				Msg.info("error", "����ʧ��!");
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

//<<<<<<<<<<<<<<<����--������Ȩ<<<<<<<<<<<<<<<

var CatScgTab = new Ext.TabPanel({
	region : 'center',
	activeTab : 0,
	items : [{
			title : '����--����',
			id : 'ItmDetail',
			layout : 'border',
			items:[ManfGrid, ManfScgPanel]
		},{
			title:'����--����',
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
