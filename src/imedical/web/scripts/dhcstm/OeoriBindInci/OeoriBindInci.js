// /����: ��ֵҽ������շ�
// /��д�ߣ��쳬
// /��д����: 2015.08.1

var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var actionUrl = DictUrl + 'oeoribindinciaction.csp';

var RecLoc = new Ext.ux.LocComboBox({
	id:'RecLoc',
	fieldLabel:'ҽ�����տ���',
	anchor:'100%',
	defaultLoc:{}
});
SetLogInDept(RecLoc.getStore(), 'RecLoc');

// ��ʼ����
var StartDate = new Ext.ux.DateField({
	fieldLabel : '��ʼ����',
	id : 'StartDate',
	anchor:'100%',
	value : new Date()
});

// ��ֹ����
var EndDate = new Ext.ux.DateField({
	fieldLabel : '��ֹ����',
	id : 'EndDate',
	anchor:'100%',
	value : new Date()
});

var ARCItemCat = new Ext.ux.ComboBox({
	fieldLabel : 'ҽ������',
	anchor:'100%',
	id : 'ARCItemCat',
	store : ArcItemCatStore,
	filterName : 'Desc'
});
var Specom = new Ext.form.ComboBox({
	fieldLabel : '������',
	id : 'Specom',
	name : 'Specom',
	anchor : '90%',
	listWidth :210,
	store : SpecDescStore,
	valueField : 'Description',
	displayField : 'Description',
	triggerAction : 'all',
	emptyText : '������...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	valueNotFoundText : '',
	listeners:({
		'beforequery':function()
		
			{	var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var IncRowid = record.get("inci");	
				var desc=this.getRawValue();
				this.store.removeAll();    //load֮ǰremoveԭ��¼���������׳���
				this.store.setBaseParam('SpecItmRowId',IncRowid)
				this.store.setBaseParam('desc',desc)
				this.store.load({params:{start:0,limit:this.pageSize}})
			} 
	})
});

var Regno = new Ext.form.TextField({
	fieldLabel : '�ǼǺ�',
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
							//������Ϣ
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
	fieldLabel : '�ǼǺ���Ϣ',
	id : 'RegnoDetail',
	disabled:true,
	anchor:'100%'
});
var barcode = new Ext.form.TextField({
	fieldLabel : '����',
	id : 'barcode',
	anchor:'100%',
	listeners:{
		keydown:function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				SearchBT.handler
			}
		}
	}
});
// ��ѯ��ť
var SearchBT = new Ext.Toolbar.Button({
	id:'SearchBT',
	text : '��ѯ',
	tooltip : '�����ѯ',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		MasterGrid.load();
	}
});

// ��հ�ť
var ClearBT = new Ext.Toolbar.Button({
	id:'ClearBT',
	text : '���',
	tooltip : '������',
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		clearData();
	}
});
// ��ѯ��ť
var PurBT = new Ext.Toolbar.Button({
	id:'PurBT',
	text : '���ɹ�',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
	Ext.MessageBox.confirm('��ʾ','ȷ��Ҫ��¼ѡ����ҽ���ɹ���Ϣ?',
					function(btn) {
						if(btn == 'yes'){
	var selr=MasterGrid.getSelected();
	if(Ext.isEmpty(selr)){
		Msg.info("warning","��ѡ��Ҫ��¼������!!");
		return;}
	var oeori=selr.get("Oeori")
	var params=oeori+"^"+gUserId
	Ext.Ajax.request({
	url:actionUrl+'?actiontype=Pur',
	params: {params:params},
	failure:function(){Msg.info('error','��������!');return;
	},
	success:function(result,request){
		var jsonData = Ext.util.JSON.decode(result.responseText);
		if (jsonData.success == 'true') {
			Msg.info('success','��¼�ɹ���');
		}else{
			Msg.info("error", "��¼ʧ��!");
			return;
		}	
		
	}})
	}
	
});
	
	}
});
function clearData() {
	clearPanel(HisListTab);
	HisListTab.getForm().setValues({StartDate:new Date(),EndDate:new Date()});
	MasterGrid.removeAll();
	ItmGridDs.removeAll();
	DetailGrid.removeAll();
}

var SaveBT = new Ext.ux.Button({
	id:'SaveBT',
	text : '����',
	iconCls : 'page_save',
	handler : function() {
		if(DetailGrid.activeEditor != null){
			DetailGrid.activeEditor.completeEdit();
		}
		if(CheckDataBeforeSave()==true){
			Save();
		}
	}
});
function CheckDataBeforeSave() {
		
		// 1.�ж���������Ƿ�Ϊ��
		var rowCount = DetailGrid.getStore().getCount();
		// ��Ч����
		if (rowCount <= 0) {
			Msg.info("warning", "������ϸ!");
			return false;
		}
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailGrid.getStore().getAt(i);
			var BatchNo = rowData.get('batno');
				if (BatchNo=="") {
					Msg.info("warning", "���Ų���Ϊ��!");
					return false;
				}
		}
		
		return true;
	}
	
function Save(){
	var MasterSel = MasterGrid.getSelected();
	if(Ext.isEmpty(MasterSel)){
		Msg.info('warning', '��ѡ����Ҫ�����ҽ��!');
		return false;
	}
	var Oeori = MasterSel.get('Oeori');
	var MainInfo = Oeori + '^' + gUserId;
	var ListDetail = DetailGrid.getModifiedInfo();
	if(ListDetail == ''){
		Msg.info('warning', 'û����Ҫ���������');
		return false;
	}
	var loadMask = ShowLoadMask(Ext.getBody(), "������...");
	Ext.Ajax.request({
		url : actionUrl + '?actiontype=Save',
		params : {MainInfo : MainInfo, ListDetail : ListDetail},
		method : 'POST',
		waitMsg : '������...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				Msg.info('success', '����ɹ�!');
				MasterGrid.reload();
			}else if(jsonData.info == -10){
				Msg.info('error', '�Դ������ظ�!');
			}else{
				var Ret=jsonData.info;
				Msg.info('error', '����ʧ��:'+Ret);
			}
		},
		scope : this
	});
}

var HisListTab = new Ext.form.FormPanel({
	region: 'north',
	height : 170,
	labelAlign : 'right',
	labelWidth : 80,
	frame : true,
	title:'����շѰ�',
	bodyStyle : 'padding:5px 0px 0px 0px;',
	tbar : [SearchBT, '-', ClearBT],
	items:[{
		xtype:'fieldset',
		title:'��ѯ����',
		layout: 'column',
		style:'padding:5px 0px 0px 0px;',
		defaults: {xtype: 'fieldset', border:false},
		items : [
			{
				columnWidth: 0.25,
				items: [barcode]
			},{
				columnWidth: 0.25,
				items: [StartDate, EndDate]
			},{
				columnWidth: 0.25,
				labelWidth : 100,
				items: [RecLoc, ARCItemCat]
			},{
				columnWidth: 0.25,
				items: [RegnoDetail, Regno]
			}]
	}]
});

var MasterCm = [{
		header : 'Oeori',
		dataIndex : 'Oeori',
		width : 60,
		hidden : true
	}, {
		header : 'ҽ�������',
		dataIndex : 'ArcimCode',
		width : 120,
		sortable : true
	}, {
		header : 'ҽ��������',
		dataIndex : 'ArcimDesc',
		width : 120,
		sortable : true
	}, {
		header : '���ߵǼǺ�',
		dataIndex : 'PaAdmNo',
		width : 100,
		sortable : true
	}, {
		header : '��������',
		dataIndex : 'PaAdmName',
		width : 170
	}, {
		header : '���տ���id',
		dataIndex : 'RecLoc',
		hidden : true,
		width : 80
	},  {
		header : '���տ���',
		dataIndex : 'RecLocDesc',
		width : 140
	}, {
		header : 'ҽ������',
		dataIndex : 'OeoriDate',
		width : 80
	}, {
		header : 'ҽ��ʱ��',
		dataIndex : 'OeoriDate',
		width : 80
	}, {
		header : 'ҽ��¼����',
		dataIndex : 'UserAddName',
		width : 100
	}, {
		header : '����',
		dataIndex : 'BarCode',
		width : 120
	}, {
		header : 'Inci',
		dataIndex : 'Inci',
		hidden : true,
		width : 120
	}
];

var MasterGrid = new Ext.dhcstm.EditorGridPanel({
	region: 'center',
	title: 'ҽ����Ϣ',
	id:'MasterGrid',
	childGrid : 'DetailGrid',
	editable : false,
	contentColumns : MasterCm,
	smType : 'row',
	singleSelect : true,
	smRowSelFn : rowSelFn,
	actionUrl : actionUrl,
	queryAction : 'QueryOeori',
	paramsFn : GetMasterParams,
	idProperty : 'Oeori',
	showTBar : false
});

function rowSelFn(sm, rowIndex, r) {
	var rowData = sm.grid.getAt(rowIndex);
	var Oeori = rowData.get('Oeori');
	var inci = r.get("Inci");
	ItmGridDs.setBaseParam("Pack",inci)
	ItmGridDs.load()
	var StrParam = Oeori;
	DetailGrid.load({params:{StrParam:StrParam}});
}
	
function GetMasterParams(){
	var RecLoc = Ext.getCmp('RecLoc').getValue();
	var StartDate = Ext.getCmp('StartDate').getValue();
	var EndDate = Ext.getCmp('EndDate').getValue();
	if(RecLoc==''){
		//Msg.info('warning', '��ѡ��ҽ�����տ���!');
		//return false;
	}
	if(StartDate==''){
		Msg.info('warning', '��ѡ��ʼ����!');
		return false;
	}else{
		StartDate=StartDate.format(ARG_DATEFORMAT).toString();
	}
	if(EndDate==''){
		Msg.info('warning', '��ѡ���ֹ����!');
		return false;
	}else{
		EndDate=EndDate.format(ARG_DATEFORMAT).toString();
	}
	var barcode=Ext.getCmp('barcode').getValue();
	var PaAdmNo = Ext.getCmp('Regno').getValue();
	var ARCItemCat = Ext.getCmp('ARCItemCat').getValue();
	var PackFlag = 'Y';
	var StrParam = StartDate+'^'+EndDate+'^'+PaAdmNo+'^'+RecLoc+'^'+ARCItemCat
			+'^'+barcode+'^^'+PackFlag;
	
	return {'Sort' : '', 'Dir' : '','StrParam' : StrParam};
}

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
        saveColIndex:1,
        width:90,
        align:'left',
         hidden:true,
        sortable:true
    },{
        header:"���ʴ���",
        dataIndex:'code',
        width:90,
        align:'left',
        sortable:true
    },{
        header:"��������",
        dataIndex:'desc',
        width:140,
        align:'left',
        sortable:true
	},{
        header:"��λ",
        dataIndex:'uomdesc',
        width:40,
        align:'left'
    },{
        header:"����",
        dataIndex:'qty',
        saveColIndex:2,
        width:50,
        align:'right',
        sortable:true,
        editor: new Ext.form.TextField({
            allowBlank:false,
            selectOnFocus:true
        })
    },{
        header:"����",
        dataIndex:'batno',
        saveColIndex:3,
        width:80,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
			id:'batnoField',
            allowBlank:false,
            selectOnFocus:true
        })
   },{
        header:"��Ч��",
        dataIndex:'expdate',
        xtype:'datecolumn',
        width:80,
        saveColIndex:4,
        align:'left',
        sortable:true,
    //    renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor: new Ext.ux.DateField({
			id:'expdateField'
        })
   },{
        header:"�Դ�����",
        dataIndex:'originalcode',
        saveColIndex:6,
        width:100,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            allowBlank:false,
            selectOnFocus:true
        })
   },{
        header:"������",
        dataIndex:'specdesc',
        width:80,
        saveColIndex:5,
        align:'right',
        sortable:true,
        editor : new Ext.grid.GridEditor(Specom),
        renderer : Ext.util.Format.comboRenderer2(Specom,"specdesc","specdesc")
	},{
        header:"����id",
        dataIndex:'dhcit',
        width:60,
        align:'left',
        sortable:true,
        hidden:true
	},{
        header:"��ֵ����",
        dataIndex:'barcode',
        width:120,
        align:'left',
        sortable:true
	},{
        header:"��¼���",
        dataIndex:'IngrFlag',
        width:60,
        xtype : 'checkcolumn',
        isPlugin : false,
        align:'center',
        sortable:true
	},{
        header:"����",
        dataIndex:'rp',
        width:80,
        align:'right',
        sortable:true,
        editable : false,		//2015-06-16 �������޸Ľ���,����,Ч��
        editor: new Ext.form.TextField({
			id:'rpField',
            allowBlank:false,
            selectOnFocus:true,
            tabIndex:1
        })
	},{
        header:"�ۼ�",
        dataIndex:'sp',
        width:80,
        align:'right',
        sortable:true
	},{
        header:"<font color=blue>��Ʊ���</font>",
        dataIndex:'invamt',
        width:80,
        align:'right',
        sortable:true
    },{
        header:"<font color=blue>��Ʊ��</font>",
        dataIndex:'invno',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"<font color=blue>��Ʊ����</font>",
        dataIndex:'invdate',
        width:80,
        align:'left',
        sortable:true,
        renderer:Ext.util.Format.dateRenderer(DateFormat)
	},{
        header:"����״̬",
        dataIndex:'feestatus',
        width:40,
        align:'left',
        sortable:true
	},{
        header:"�����ܶ�",
        dataIndex:'feeamt',
        width:80,
        align:'right',
        sortable:true
	},{
        header:"��������",
        dataIndex:'dateofmanu',
        width:80,
        align:'left',
        sortable:true
	},{
        header:"��Ӧ��",
        dataIndex:'vendor',
        width:200,
        align:'left',
        sortable:true
	},{
        header:"����",
        dataIndex:'manf',
        width:80,
        align:'left',
        sortable:true
	}
];

var DeleteButton = new Ext.ux.Button({
	id : 'DeleteButton',
	text : 'ɾ��һ��',
	iconCls : 'page_delete',
	handler : function(){
		var selectcell=DetailGrid.getSelectedCell()
		if (Ext.isEmpty(selectcell)){Msg.info('warning', '��ѡ����Ҫɾ������ϸ!');return false;}
		var SelRecord = DetailGrid.getAt(selectcell[0]);
		if(SelRecord == null){
			Msg.info('warning', '��ѡ����Ҫɾ������ϸ!');
			return false;
		}
		var RowId = SelRecord.get(DetailGrid.idProperty);
		var IngrFlag=SelRecord.get("IngrFlag")
		if(IngrFlag=="Y"){
			Msg.info('warning', '�Ѿ�������ⵥ,������ɾ��!');
			return false;}
		if(RowId != ''){
			Ext.MessageBox.confirm('��ʾ','ȷ��Ҫɾ���ü�¼?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url : actionUrl,
							params : {actiontype : 'Delete', RowId : RowId},
							waitMsg:'ɾ����...',
							failure: function(result, request) {
								Msg.info('error', '������������!');
								return false;
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									DetailGrid.reload();
								}else{
									Msg.info("error", 'ɾ��ʧ��:' + jsonData.info);
									return false;
								}
							},
							scope: this
						});
					}
				}
			)
		}else{
			DetailGrid.remove(SelRecord);
			DetailGrid.getView().refresh();
		}
	}
});

var DetailGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'south',
	split: true,
	height: 250,
	minSize: 200,
	maxSize: 350,
	collapsible: true,
	title: '�󶨸�ֵ������ϸ��Ϣ',
	id : 'DetailGrid',
	smType : 'cell',
	contentColumns : DetailCm,
	actionUrl : actionUrl,
	queryAction : 'QueryItem',
	selectFirst : false,
	idProperty : 'orirowid',
	checkProperty : 'inci',
	paging : false,
	showTBar : false,
	tbar : [ SaveBT,'-', DeleteButton],
	listeners : {
		beforeedit : function(e){
			if(e.field == 'originalcode' || e.field == 'qty'){
				if(!Ext.isEmpty(e.record.get('orirowid'))){
					e.cancel = true;
				}
			}else if(e.field == 'batno' || e.field == 'expdate' || e.field =='specdesc'){
				if(e.record.get('IngrFlag') == 'Y'){
					e.cancel = true;
				}
			}
		}
	}
});

var ItmGridDs = new Ext.data.JsonStore({
	url :'dhcstm.packchargelinkaction.csp?actiontype=GetDetail',
	totalProperty : "results",
	root : 'rows',
	fields : ["PCL","Inci","InciCode","InciDesc","Spec","PbRp"]
});

var ItmLinkGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : 'PCL',
		dataIndex : 'PCL',
		hidden : true
	},{
		header : 'Inci',
		dataIndex : 'Inci',
		hidden : true
	},{
		header : '���ʴ���',
		dataIndex : 'InciCode',
		width : 100
	},{
		header : '��������',
		dataIndex : 'InciDesc',
		width : 200
	},{
		header : '���',
		dataIndex : 'Spec',
		width : 100
	},{
		header : '����',
		dataIndex : 'PbRp',
		width : 100
	}
]);

var ItmLinkGrid = new Ext.ux.GridPanel({
	region: 'east',
	width:300,
	title: '��������',
	id : 'ItmLinkGrid',
	store : ItmGridDs,
	cm : ItmLinkGridCm,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	listeners : {
		'rowdblclick' : function(grid,rowIndex,e){
			var r = grid.store.getAt(rowIndex);
			var inci= r.get("Inci");
			var incicode=r.get("InciCode")
        	var inciDesc=r.get("InciDesc");
        	var defaData = {inci:inci,desc:inciDesc,qty:1,code:incicode};
			var NewRecord = CreateRecordInstance(DetailGrid.getStore().fields,defaData);
			DetailGrid.getStore().insert(0,NewRecord);	
			DetailGrid.getView().refresh()
		}
	}
}
);
Ext.onReady(function() {
	Ext.QuickTips.init();
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [{
						region: 'center',
						layout : 'border',
						items : [HisListTab, MasterGrid]
					}, DetailGrid, ItmLinkGrid
				]
			
			});
});