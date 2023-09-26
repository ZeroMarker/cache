// ����:����ά�޼�¼
// ��д����:2014-03-26
var gUserId = session['LOGON.USERID'];
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var parref="",gParrefStatus="";	//dhclm
var inciDr="";

var PhaLoc = new Ext.ux.LocComboBox({
	id:'PhaLoc',
	fieldLabel:'����',
	name:'locField',
	anchor:'90%',
	groupId:gGroupId
});

var inciDesc = new Ext.form.TextField({
	fieldLabel : '��������',
	id : 'inciDesc',
	name : 'inciDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var inputText=field.getValue();
				GetPhaOrderInfo(inputText,"");
			}
		}
	}
});

/**
* �������ʴ��岢���ؽ��
*/
function GetPhaOrderInfo(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "", getDrugList);
	}
}

/**
* ���ط���
*/
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	inciDr = record.get("InciDr");
	var inciDesc=record.get("InciDesc");
	Ext.getCmp("inciDesc").setValue(inciDesc);
}

var Barcode = new Ext.form.TextField({
	fieldLabel:'����',
	id : 'Barcode',
	name : 'Barcode',
	anchor : '90%'
});

var StartDate = new Ext.ux.DateField({
	id:'StartDate',
	allowBlank:false,
	fieldLabel:'��ʼ����',
	value:new Date().add(Date.DAY,-30)
});

var EndDate = new Ext.ux.DateField({
	id:'EndDate',
	allowBlank:false,
	fieldLabel:'��������',
	value:new Date()
});

var StatusStore = new Ext.data.SimpleStore({
	fields:['RowId','Description'],
	data : [['A','����'],['M','ά�ޱ���'],['S','ͣ��'],['D','����']]
});
var StatusField = new Ext.form.ComboBox({
	fieldLabel:'����״̬',
	id:'StatusField',
	anchor:'90%',
	allowBlank:true,
	store:StatusStore,
	value:'',
	valueField:'RowId',
	displayField:'Description',
	emptyText:'',
	triggerAction:'all',
	emptyText:'',
	mode:'local',
	selectOnFocus:true,
	forceSelection:true
});

var DateFlag = new Ext.form.Checkbox({
	boxLabel : '��������',
	id : 'DateFlag',
	name : 'DateFlag',
	checked : false
});

var LocGroupFlag = new Ext.form.Checkbox({
	boxLabel : '��������',
	id : 'LocGroupFlag',
	name : 'LocGroupFlag',
	checked : true
});

//��������Դ
var LocMainUrl = 'dhcstm.locmainaction.csp';

var MasterStore = new Ext.data.JsonStore({
	url : LocMainUrl+'?actiontype=Query',
	totalProperty : "results",
	root : 'rows',
	fields : ["dhclm","inci","inciCode","inciDesc","Barcode","status","Abbrev","Brand","spec","uomDesc","Rp","Sp",
				"currentLoc","CreateDate","CreateTime","CreateUser","RMCount","RMFeeCount","Remarks"],
	listeners : {
		load : function(store, records, options){
			if(records.length > 0){
				MasterGrid.getSelectionModel().selectFirstRow();
			}
		}
	}
});

//ģ��
var MasterGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header:"dhclm",
		dataIndex:'dhclm',
		hidden:true
	},{
		header:"inci",
		dataIndex:'inci',
		width:100,
		align:'left',
		hidden:true
	},{
		header:"���ʴ���",
		dataIndex:'inciCode',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"��������",
		dataIndex:'inciDesc',
		width:160,
		align:'left',
		sortable:true
	},{
		header:"����",
		dataIndex:'Barcode',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"״̬",
		dataIndex:'status',
		width:60,
		align:'center',
		renderer:StatusRenderer,
		sortable:true
	},{
		header:"���",
		dataIndex:'Abbrev',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"Ʒ��",
		dataIndex:'Brand',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"���",
		dataIndex:'spec',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"��λ",
		dataIndex:'uomDesc',
		width:60,
		align:'left',
		sortable:true
	},{
		header:"����",	//����
		dataIndex:'Rp',
		width:60,
		align:'right',
		sortable:true
	},{
		header:"ά�޴���",
		dataIndex:'RMCount',
		width:60,
		align:'right',
		sortable:true
	},{
		header:"ά�ޱ�������",
		dataIndex:'RMFeeCount',
		width:80,
		align:'right',
		sortable:true
	},{
		header:"��ǰ����",
		dataIndex:'currentLoc',
		width:120,
		align:'left',
		sortable:true
	},{
		header:"ע������",
		dataIndex:'CreateDate',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"ע��ʱ��",
		dataIndex:'CreateTime',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"ע����",
		dataIndex:'CreateUser',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"��ע",
		dataIndex:'Remarks',
		width:160,
		align:'left',
		sortable:true
	}
]);
//��ʼ��Ĭ��������
MasterGridCm.defaultSortable = true;

var MasterGridToolbar = new Ext.PagingToolbar({
	store:MasterStore,
	pageSize:20,
	displayInfo:true
});

var sm = new Ext.grid.RowSelectionModel({
	singleSelect:true,
	listeners:{
		'rowselect':function(sm,rowIndex,r){
			parref = MasterStore.data.items[rowIndex].data["dhclm"];
			gParrefStatus = MasterStore.data.items[rowIndex].data["status"];
			DetailStore.setBaseParam('Parref',parref);
			DetailStore.removeAll();
			DetailStore.load({
				params:{start:0,limit:999},
				callback:function(r,options,success){
					if(!success){
						Msg.info('error','��ѯ����,��鿴��־!');
						return;
					}
				}
			});
		}
	}
});

var MasterGrid = new Ext.ux.GridPanel({
	id:'MasterGrid',
	region:'center',
	title:'������Ϣ',
	store:MasterStore,
	cm:MasterGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : sm,
	loadMask:true,
	bbar:MasterGridToolbar,
	viewConfig:{
		getRowClass : function(record,rowIndex,rowParams,store){
			var RMCount=record.get("RMCount");
			RMCount=parseInt(RMCount);
			switch(RMCount){
			case 0:
				break;
			case 1:
				break;
			case 2:
				return 'classYellow';
				break;
			default:
				return 'classRed';
				break;
			}
		}
	}
});


var TypeStore = new Ext.data.SimpleStore({
	fields:['RowId','Description'],
	data : [['A','����'],['R','ά��'],['RO','ά�����'],['M','����'],['MO','�������'],['D','����']]
});
var TypeField = new Ext.form.ComboBox({
	id:'TypeField',
	width:200,
	allowBlank:true,
	store:TypeStore,
	value:'',
	valueField:'RowId',
	displayField:'Description',
	emptyText:'',
	triggerAction:'all',
	emptyText:'',
	mode:'local',
	selectOnFocus:true,
	forceSelection:true,
	listeners:{
		select:function(index,scrollIntoView){
			var count = DetailStore.getCount();
			var lastType="";
			if(count>=2){
				lastType = DetailStore.getAt(count-2).get('Type');
				if(lastType==this.getValue()){
					Msg.info("warning","��¼�����ظ�!");
					this.setValue("");
					return;
				}else if(lastType=='R' && this.getValue()!='RO'){
					Msg.info("warning","���뵱ǰ����ά��״̬,����ά��ά�����!");
					this.setValue("");
					return;
				}else if(lastType=='M' && this.getValue()!='MO'){
					Msg.info("warning","���뵱ǰ���ڱ���״̬,����ά���������!");
					this.setValue("");
					return;
				}
			}
			if(this.getValue()=='RO'){
				if(lastType!='R'){
					Msg.info("warning","��һ������ά�޼�¼,����ѡ��\"ά�����\"!");
					this.setValue("");
					return;
				}else{
					var lastVen = DetailStore.getAt(count-2).get('vendor');
					var lastVenDesc = DetailStore.getAt(count-2).get('VenDesc');
					addComboData(Ext.getCmp("Vendor").getStore(),lastVen,lastVenDesc);
					DetailStore.getAt(count-1).set('vendor',lastVen);
					var col = GetColIndex(DetailGrid,'Fee');
					DetailGrid.startEditing(count-1,col);
				}
			}else if(this.getValue()=='MO'){
				if(lastType!='M'){
					Msg.info("warning","��һ�����Ǳ�����¼,����ѡ��\"�������\"!");
					this.setValue("");
					return;
				}else{
					var lastVen = DetailStore.getAt(count-2).get('vendor');
					var lastVenDesc = DetailStore.getAt(count-2).get('VenDesc');
					addComboData(Ext.getCmp("Vendor").getStore(),lastVen,lastVenDesc);
					DetailStore.getAt(count-1).set('vendor',lastVen);
					var col = GetColIndex(DetailGrid,'Fee');
					DetailGrid.startEditing(count-1,col);
				}
			}
			var cell=DetailGrid.getSelectionModel().getSelectedCell();
			DetailStore.getAt(cell[0]).set('Type',this.getValue());
		}
	}
});

var UStore = new Ext.data.Store({
	proxy : new Ext.data.HttpProxy({
		url:'dhcstm.orgutil.csp?actiontype=StkLocUserCatGrp'
	}),
	reader : new Ext.data.JsonReader({
		totalProperty : "results",
		root : 'rows'
	}, ['Description', 'RowId'])
});

var UCG = new Ext.ux.ComboBox({
	id : 'UCG',
	name : 'UCG',
	store : UStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName : 'name',
	params:{locId:'PhaLoc'}
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '��Ӧ��',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '��Ӧ��...',
	listWidth : 250
});

var RecLoc = new Ext.ux.ComboBox({
	id:'RecLoc',
	fieldLabel:'���տ���',
	store:LocInSLGStore,
	displayField:'Description',
	valueField:'RowId',
	listWidth:210,
	emptyText:'���տ���...',
	params:{LocId:'PhaLoc'},
	filterName:'FilterDesc'
});

var DetailStore = new Ext.data.JsonStore({
	url : LocMainUrl+'?actiontype=QueryItem',
	root : 'rows',
	fields : ["dhclmi","Type","TypeName","ObliUserId","ObliUserName","vendor","VenDesc","Fee",
		"ToLocId","ToLocDesc","OperDate","OperTime","OperUser","Remark"],
	pruneModifiedRecords:true
});

//ģ��
var DetailGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header:"Rowid",
		dataIndex:'dhclmi',
		hidden:true
	},{
		header:"����",
		dataIndex:'Type',
		width:100,
		align:'left',
		editor:new Ext.grid.GridEditor(TypeField),
		renderer:TypeRenderer
		//renderer:Ext.util.Format.comboRenderer(TypeField)
	},{
		header : "������",
		dataIndex : 'ObliUserId',
		width : 120,
		align : 'left',
		sortable : true,
		editor : new Ext.grid.GridEditor(UCG),
		renderer :Ext.util.Format.comboRenderer2(UCG,"ObliUserId","ObliUserName")
	},{
		header:"��Ӧ��",
		dataIndex:'vendor',
		id:'VenId',
		width:250,
		align:'left',
		sortable:true,
		editor : new Ext.grid.GridEditor(Vendor),
		renderer : Ext.util.Format.comboRenderer2(Vendor,"vendor","VenDesc")
	},{
		header:"����",
		dataIndex:'Fee',
		width:80,
		align:'right',
		sortable:true,
		editor:new Ext.form.NumberField({
			selectOnFocus : true,
			allowBlank : false,
			allowNegative : false
		})
	},{
		header:"���տ���",
		dataIndex:'ToLocId',
		width:150,
		align:'left',
		sortable:true,
		editor : new Ext.grid.GridEditor(RecLoc),
		renderer : Ext.util.Format.comboRenderer2(RecLoc,"ToLocId","ToLocDesc")
	},{
		header:"����",
		dataIndex:'OperDate',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"ʱ��",
		dataIndex:'OperTime',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"������",
		dataIndex:'OperUser',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"��ע",
		dataIndex:'Remark',
		width:200,
		align:'left',
		sortable:true,
		editor:new Ext.form.TextField()
	}
]);
//��ʼ��Ĭ��������
DetailGridCm.defaultSortable = true;

var AddDetailButton = new Ext.Toolbar.Button({
	text:'������ϸ',
	tooltip:'������ϸ',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if(parref==""){
			Msg.info("warning","��ѡ����Ҫά���ı���");
			return;
		}else if(gParrefStatus=='D'){
			Msg.info("warning","�����ʱ����ѱ���!");
			return;
		}else if(gParrefStatus=='A'){
			Msg.info("warning","�����ʱ��봦������״̬!");
			return;
		}
		AddNewRowDetail();
	}
});

function AddNewRowDetail(){
	var rowCount = DetailStore.getCount();
	var col = GetColIndex(DetailGrid,'Type');
	if (rowCount > 0) {
		var rowData = DetailStore.data.items[rowCount - 1];
		var dhclmi = rowData.get("dhclmi");
		if (dhclmi == null || dhclmi.length <= 0) {
			DetailGrid.startEditing(DetailStore.getCount() - 1, col);
			return;
		}
	}
	var record = Ext.data.Record.create([
		{name : 'dhclmi',	type : 'string'},
		{name : 'Type',		type : 'string'},
		{name : 'TypeName',	type : 'string'},
		{name : 'ObliUserId',type : 'int'},
		{name : 'ObliUserName',type : 'string'},
		{name : 'vendor',	type : 'int'},
		{name : 'VenDesc',	type : 'string'},
		{name : 'Fee',		type : 'double'},
		{name : 'ToLocId',	type : 'int'},
		{name : 'ToLocDesc',type : 'string'},
		{name : 'OperDate',	type : 'string'},
		{name : 'OperTime',	type : 'string'},
		{name : 'OperUser',	type : 'string'},
		{name : 'Remark',	type : 'string'}
	]);

	var DetailRecord = new record({
		dhclmi:'',
		Type:'',
		TypeName:'',
		ObliUserId:'',
		ObliUserName:'',
		vendor:'',
		VenDesc:'',
		Fee:'',
		ToLocId:'',
		ToLocDesc:'',
		OperDate:'',
		OperTime:'',
		OperUser:'',
		Remark:''
	});

	DetailStore.add(DetailRecord);
	DetailGrid.startEditing(DetailStore.getCount() - 1, col);
}

var DelDetailButton = new Ext.Toolbar.Button({
	text:'ɾ����ϸ',
	tooltip:'ɾ����ϸ',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var cell = DetailGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("error", "��ѡ������!");
			return false;
		}else{
			var record = DetailStore.getAt(cell[0]);
			var dhclmi = record.get('dhclmi');
			if(dhclmi!=""){
				Msg.info("warning","�ѱ������ݲ���ɾ��!");
				return;
			}else{
				DetailStore.remove(record);
				DetailGrid.getView().refresh();
			}
		}
	}
});

var DetailGrid = new Ext.ux.EditorGridPanel({
	id:'DetailGrid',
	region:'south',
	height:240,
	title:'ά�޼�¼��ϸ��Ϣ',
	collapsible : true,
	store:DetailStore,
	cm:DetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel(),
	loadMask:true,
	clicksToEdit:1,
	tbar : [AddDetailButton,'-',DelDetailButton],
	listeners:{
		beforeedit:function(e){
			if(e.record.get('dhclmi')!=''){
				e.cancel=true;
			}else if(e.record.get('Type')=='' && (e.field!='Type' && e.field!='Remark')){
				e.cancel=true;
			}else if(e.record.get('Type')=='A' && (e.field!='ToLocId' && e.field!='Remark')){
				e.cancel=true;
			}else if((e.record.get('Type')=='BO' || e.record.get('Type')=='D' || e.record.get('Type')=='S')
					&& (e.field!='ObliUserId' && e.field!='Remark')){
				e.cancel=true;
			}else if((e.record.get('Type')=='R' || e.record.get('Type')=='M') && (e.field!='vendor' && e.field!='Remark')){
				e.cancel=true;
			}else if((e.record.get('Type')=='RO' || e.record.get('Type')=='MO') && (e.field!='vendor' && e.field!='Fee' && e.field!='Remark')){
				e.cancel=true;
			}else if(e.record.get('Type')=='T' && (e.field!='ToLocId' && e.field!='Remark')){
				e.cancel=true;
			}
		}
	}
});

var queryBT = new Ext.Toolbar.Button({
	text:'��ѯ',
	tooltip:'��ѯ',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		Query();
	}
});

function Query(){
	var PhaLoc=Ext.getCmp("PhaLoc").getValue();
	if(PhaLoc==""){
		Msg.info("warning","���Ҳ���Ϊ��!");
		return;
	}

	var Barcode=Ext.getCmp("Barcode").getValue();
	var inciDesc=Ext.getCmp("inciDesc").getValue();
	if(inciDesc==""){
		inciDr="";
	}

	var StartDate=Ext.getCmp("StartDate").getValue();
	if(StartDate==""){
		Msg.info("warning","��ʼ���ڲ���Ϊ��!");
		return;
	}else{
		StartDate=StartDate.format(ARG_DATEFORMAT);
	}
	var EndDate=Ext.getCmp("EndDate").getValue();
	if(EndDate==""){
		Msg.info("warning","��ֹ���ڲ���Ϊ��!");
		return;
	}else{
		EndDate=EndDate.format(ARG_DATEFORMAT);
	}
	if(StartDate>EndDate){
		Msg.info("warning","��ʼ���ڲ��ô��ڽ�ֹ����!");
		return;
	}
	var DateFlag=Ext.getCmp("DateFlag").getValue()?1:0;
	var Time="";
	var LocGroupFlag=Ext.getCmp("LocGroupFlag").getValue()?1:0;
	var Status=Ext.getCmp("StatusField").getValue();
	var StrParam=StartDate+"^"+EndDate+"^"+inciDr+"^"+Barcode+"^"+DateFlag
			+"^"+Time+"^"+PhaLoc+"^"+LocGroupFlag+"^"+Status;

	MasterStore.setBaseParam('StrParam',StrParam);
	DetailStore.removeAll();
	MasterStore.removeAll();
	MasterStore.load({
		params:{start:0,limit:MasterGridToolbar.pageSize},
		callback : function(r,options, success){
			if(!success){
				Msg.info("error", "��ѯ������鿴��־!");
			}else{
				if(r.length>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			}
		}
	});
}

var clearBT = new Ext.Toolbar.Button({
	text:'���',
	tooltip:'���',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		SetLogInDept(Ext.getCmp('PhaLoc').getStore(),'PhaLoc');
		Ext.getCmp('StatusField').setValue('');

		Ext.getCmp('Barcode').setValue("");
		Ext.getCmp('inciDesc').setValue("");
		Ext.getCmp('StartDate').setValue(new Date().add(Date.DAY,-30));
		Ext.getCmp('EndDate').setValue(new Date());
		Ext.getCmp('DateFlag').setValue(false);
		Ext.getCmp('LocGroupFlag').setValue(true);

		DetailStore.removeAll();
		MasterStore.removeAll();
		Common_ClearPaging(MasterGridToolbar);
	}
});

var RegBT = new Ext.Toolbar.Button({
	text:'ע�����',
	tooltip:'ע�����',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var PhaLoc=Ext.getCmp("PhaLoc").getValue();
		if(PhaLoc==""){
			Msg.info("warning","��ѡ�����!");
			return;
		}
		LocMainReg(PhaLoc);
	}
});

var SaveBT = new Ext.Toolbar.Button({
	text:'����',
	tooltip:'����',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if(parref==""){
			Msg.info("warning","��ѡ����Ҫ��������ʱ���!");
			return;
		}
		if(DetailGrid.activeEditor != null){
			DetailGrid.activeEditor.completeEdit();
		}
		SaveData();
	}
});

function SaveData(){
	var mr=DetailStore.getModifiedRecords();
	var ListDetail="";
	for(var i=0;i<mr.length;i++){
		var dhclmi = mr[i].data["dhclmi"];
		var Type = mr[i].get('Type');
		if(Type==""){
			break;
		}
		var ObliUserId = mr[i].data["ObliUserId"];
		var VendorId = mr[i].data["vendor"];
		var Fee = mr[i].data["Fee"];
		var ToLocId = mr[i].data["ToLocId"];
		var Remark = mr[i].data["Remark"];
		Remark = Remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());

		if(Type=='A' && ToLocId==""){
			Msg.info("warning","����״̬����ѡ��\"���տ���\"!");
			return;
		}else if((Type=='R' || Type=='M' || Type=='RO' || Type=='MO') && VendorId==""){
			Msg.info("warning","ά�ޱ���״̬����ѡ��\"��Ӧ��\"!");
			return;
		}

		///�жϸ������, �����ʵĸ�����ʾ
		var dataRow = dhclmi+"^"+Type+"^"+ObliUserId+"^"+VendorId+"^"+Fee+"^"+ToLocId+"^"+Remark;
		if(ListDetail==""){
			ListDetail = dataRow;
		}else{
			ListDetail = ListDetail+xRowDelim()+dataRow;
		}
	}
	if(ListDetail==""){
		Msg.info("warning","û����Ҫ�������ϸ��Ϣ!");
		return;
	}
	var url = DictUrl + "locmainaction.csp?actiontype=SaveItm";
	var loadMask=ShowLoadMask(Ext.getBody(),"������...");
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		params:{Parref:parref,ListDetail:ListDetail,UserId:gUserId},
		waitMsg : '������...',
		success : function(result, request) {
			loadMask.hide();
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "����ɹ�!");
				DetailStore.removeAll();
				MasterStore.reload({
					callback:function(r,options,success){
						var index = MasterStore.findExact('dhclm',parref);
						var selIndex = index>=0?index:0;
						if(MasterStore.getCount()>0){
							MasterGrid.getSelectionModel().fireEvent('rowselect',this,selIndex);
							MasterGrid.getView().focusRow(selIndex);
						}
					}
				});
			}
		},
		failure: function(result, request) {
			loadMask.hide();
			Msg.info("error","������������!");
		},
		scope : this
	});
}

var formPanel = new Ext.ux.FormPanel({
	title:'����ά�޼�¼',
	tbar:[queryBT,'-',clearBT,'-',RegBT,'-',SaveBT],
	items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		layout : 'column',
		style : 'padding:5px 0px 0px 5px',
		defaults : {border:false,columnWidth : .25,xtype:'fieldset'},
		items : [{
				items : [PhaLoc,Barcode]
			}, {
				items : [inciDesc,StatusField]
			}, {
				items : [StartDate, EndDate]
			}, {
				items : [DateFlag,LocGroupFlag]
			}
		]
	}]
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,MasterGrid,DetailGrid],
		renderTo:'mainPanel'
	});
});
