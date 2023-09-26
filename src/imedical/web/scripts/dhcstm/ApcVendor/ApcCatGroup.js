// ����:		��Ӧ��������Ȩ(˫��ά��)
// ��д����:	2014-11-18

var ApcScgUrl = 'dhcstm.apccatgroupaction.csp';

//>>>>>>>>>>>>>>>��Ӧ��--������Ȩ>>>>>>>>>>>>>>>
var CodeField = {
	id : 'CodeField',
	xtype : 'textfield',
	fieldLabel : '����',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true,
	emptyText : '��Ӧ�̴���...'
};
	
var NameField = {
	id:'NameField',
	xtype : 'textfield',
	fieldLabel:'����',
	allowBlank:true,
	anchor:'90%',
	selectOnFocus:true,
	emptyText : '��Ӧ������...'
};

var FindVenButton = {
	xtype : 'uxbutton',
	text : '��ѯ',
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
		header : '��Ӧ�̴���',
		width : 150
	},{
		dataIndex : 'Name',
		header : '��Ӧ������',
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
	title : '��Ӧ��',
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
	text : '����',
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
		width : 60
	}
];

var ApcScgGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'ApcScgGrid',
	title : '����Ȩ',
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
		Msg.info("warning","û����Ҫ�������Ϣ!");
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
		waitMsg:'������...',
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","����ɹ�!");
				RefreshApcScg();
			}else{
				Msg.info("error","����ʧ��!");
			}
		},
		scope: this
	});
}

function DelApcScg(){
	var VendorIdStr = "", ScgStr = "";
	var VendorSels = VendorGrid.getSelections();
	if(Ext.isEmpty(VendorSels)){
		Msg.info("warning","��ѡ����Ҫȡ����Ȩ�Ĺ�Ӧ��!");
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
		url : ApcScgUrl + '?actiontype=Delete',
		params : {VendorIdStr : VendorIdStr, ScgStr : ScgStr},
		waitMsg:'ɾ����...',
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","ɾ���ɹ�!");
				RefreshApcScg();
			}else{
				Msg.info("error","ɾ��ʧ��!");
			}
		},
		scope: this
	});
}

var UnApcScgCm = [{
		header : '����id',
		dataIndex : 'Scg',
		hidden : true
	},{
		header : '��������',
		dataIndex : 'ScgDesc',
		width : 200
	}
];

var UnApcScgGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'UnApcScgGrid',
	title : 'δ��Ȩ',
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
		Msg.info("warning","��ѡ����Ҫ��Ȩ�Ĺ�Ӧ��!");
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
		url: ApcScgUrl + '?actiontype=Save',
		params: {ScgStr:ScgStr, VendorIdStr:VendorIdStr},
		failure: function(result, request) {
			Msg.info("error", "������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success", "����ɹ�!");
				RefreshApcScg();
			}else{
				Msg.info("error", "����ʧ��!");
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

//<<<<<<<<<<<<<<<��Ӧ��--������Ȩ<<<<<<<<<<<<<<<

//>>>>>>>>>>>>>>>����--��Ӧ����Ȩ>>>>>>>>>>>>>>>
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

function ScgRowSelFn(grid,rowIndex,r){
	var Scg = r.get('RowId');
	var StrParam = Scg;
	ScgApcGrid.load({params:{StrParam:StrParam}});
	UnScgApcGrid.load({params:{StrParam:StrParam}});
}

var ScgGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'center',
	id : 'ScgGrid',
	title : '����',
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
	text : '����',
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
		header : '��Ӧ��rowid',
		dataIndex : 'Vendor',
		hidden : true
	},{
		header : '��Ӧ������',
		dataIndex : 'VendorName',
		width : 200
	},{
		header : '�Ƿ����',
		dataIndex : 'UseFlag',
		xtype : 'checkcolumn',
		isPlugin : true,
		width : 60
	}
];

var ScgApcGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'ScgApcGrid',
	title : '����Ȩ',
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
		Msg.info("warning","û����Ҫ�������Ϣ!");
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
		waitMsg:'������...',
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","����ɹ�!");
				RefreshScgApc();
			}else{
				Msg.info("error","����ʧ��!");
			}
		},
		scope: this
	});
}

function DelScgVendor(){
	var VendorIdStr = "", ScgStr = "";
	var VendorSels = ScgApcGrid.getSelections();
	if(Ext.isEmpty(VendorSels)){
		Msg.info("warning","��ѡ����Ҫȡ����Ȩ�Ĺ�Ӧ��!");
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
		url : ApcScgUrl + '?actiontype=Delete',
		params : {VendorIdStr : VendorIdStr, ScgStr : ScgStr},
		waitMsg:'ɾ����...',
		failure: function(result, request) {
			Msg.info("error","������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","ɾ���ɹ�!");
				RefreshScgApc();
			}else{
				Msg.info("error","ɾ��ʧ��!");
			}
		},
		scope: this
	});
}

var UnScgApcCm = [{
		header : '��Ӧ��rowid',
		dataIndex : 'Vendor',
		hidden : true
	},{
		header : '��Ӧ������',
		dataIndex : 'VendorName',
		width : 200
	}
];

var UnScgApcGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'UnScgApcGrid',
	title : 'δ��Ȩ',
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
		Msg.info("warning","��ѡ����Ҫ��Ȩ�Ĺ�Ӧ��!");
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
		url: ApcScgUrl + '?actiontype=Save',
		params: {ScgStr:ScgStr, VendorIdStr:VendorIdStr},
		failure: function(result, request) {
			Msg.info("error", "������������!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success", "����ɹ�!");
				RefreshScgApc();
			}else{
				Msg.info("error", "����ʧ��!");
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

//<<<<<<<<<<<<<<<����--��Ӧ����Ȩ<<<<<<<<<<<<<<<

var CatScgTab = new Ext.TabPanel({
	region : 'center',
	activeTab : 0,
	items : [{
			title : '��Ӧ��--����',
			id : 'ItmDetail',
			layout : 'border',
			items:[VendorGrid, ApcScgPanel]
		},{
			title:'����--��Ӧ��',
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
