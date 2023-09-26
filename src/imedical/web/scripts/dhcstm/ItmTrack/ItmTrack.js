// ����:��ֵ���ϸ��ٲ�ѯ
// ��д����:2013-05-14
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var inciDr="";

var inciDesc = new Ext.form.TextField({
	fieldLabel : '��������',
	id : 'inciDesc',
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
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "",
				getDrugList);
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

var label = new Ext.form.TextField({
	fieldLabel:'����',
	id : 'label',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e){
			if(e.getKey() == Ext.EventObject.ENTER){
				Query();
			}
		}
	}
});

var originalCode = new Ext.form.TextField({
	fieldLabel:'�Դ�����',
	id : 'originalCode',
	anchor : '90%'
});

var Vendor = new Ext.ux.VendorComboBox({
	id : 'Vendor',
	anchor:'90%'
});

var StartDate = new Ext.ux.DateField({
	id:'StartDate',
	listWidth:100,
    allowBlank:false,
	fieldLabel:'��ʼ����',
	value:DefaultStDate()
});

var EndDate = new Ext.ux.DateField({
	id:'EndDate',
	listWidth:100,
    allowBlank:false,
	fieldLabel:'��������',
	value:DefaultEdDate()
});
var ORStartDate = new Ext.ux.DateField({
	id:'ORStartDate',
	listWidth:100,
    allowBlank:false,
	fieldLabel:'ҽ����ʼ����',
	value:new Date()
});

var OREndDate = new Ext.ux.DateField({
	id:'OREndDate',
	listWidth:100,
    allowBlank:false,
	fieldLabel:'ҽ����������',
	value:DefaultEdDate()
});
var DateFlag = new Ext.form.Checkbox({
	boxLabel : '����ע������',
	id : 'DateFlag',
	anchor : '90%',
	checked : true
});
var ORDateFlag = new Ext.form.Checkbox({
	boxLabel : '��ҽ������',
	id : 'ORDateFlag',
	anchor : '100%',
	checked : false,
	listeners : {
		check : function(checkBox, checked){
			if(checked){
				Ext.getCmp('DateFlag').setValue(true);
			}
		}
	}
});
var CurrPhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '��ǰ����',
	id : 'CurrPhaLoc',
	anchor:'90%',
	emptyText : '��ǰ����...',
	defaultLoc:{}
});

var StatusStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['Reg', 'ע��'], ['Enable', '����'], ['Used', '����'], ['Else', '����']]
});
var CurStatus = new Ext.form.ComboBox({
	fieldLabel : '����״̬',
	id : 'CurStatus',
	anchor : '90%',
	store : StatusStore,
	valueField : 'RowId',
	displayField : 'Description',
	mode : 'local',
	allowBlank : true,
	triggerAction : 'all',
	selectOnFocus : true,
	listWidth : 150,
	forceSelection : true
});
var batno = new Ext.form.TextField({
	fieldLabel:'����',
	id : 'batno',
	anchor : '90%'
});
var Regno = new Ext.form.TextField({
	fieldLabel : '�ǼǺ�',
	id : 'Regno',
	anchor : '90%',
	enableKeyEvents : true,
	listeners : {
		keydown : function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				var regno = field.getValue();
				Ext.Ajax.request({
					url: 'dhcstm.matordstataction.csp?actiontype=Getpainfo',
					params : {regno : regno},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							var value = jsonData.info;
							var arr = value.split("^");
							//������Ϣ
							field.setValue(arr[0]);
							Ext.getCmp('RegnoDetail').setValue(arr.slice(1));
						}
					},
					scope: this
				});
			}
		}
	}
});
var RegnoDetail = new Ext.form.TextField({
	fieldLabel : '�ǼǺ���Ϣ',
	id : 'RegnoDetail',
	disabled:true,
	anchor : '90%'
});

//��ӡ״̬
var PrintStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['0', 'ȫ��'], ['1', 'δ��ӡ'],
					['2', '�Ѵ�ӡ']]
		});
		
var PrintStatus = new Ext.form.ComboBox({
	fieldLabel : '��ӡ״̬',
	id : 'PrintStatus',
	name : 'PrintStatus',
	anchor:'90%',
	store : PrintStore,
	triggerAction : 'all',
	mode : 'local',
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	editable : true,
	valueNotFoundText : ''
});
Ext.getCmp("PrintStatus").setValue(0);

//��ѡ��ӡ
var print = new Ext.grid.CheckColumn({
	header:'��ӡ',
	dataIndex:'print',
	width:60,
	sortable:true
});

//���ͱ�־
var SluggishFlag = new Ext.form.Checkbox({
	id : 'SluggishFlag',
	boxLabel : '����',
	anchor : '90%',
	checked : false,
	listeners : {
		check : function(checkbox, checked){
			if(checked && SluggishGap.getValue()===''){
				SluggishGap.setValue(1);
			}
			if(CurStatus.getValue() != '' && CurStatus.getValue() != 'Enable'){
				CurStatus.setValue('Enable');
			}
		}
	}
});

//��������
var SluggishGap = new Ext.form.NumberField({
	id : 'SluggishGap',
	anchor : '90%',
	width : 50
});

var SluggishComp = new Ext.form.CompositeField({
	fieldLabel : '����',
	anchor : '90%',
	items : [SluggishFlag,SluggishGap]
});

//��������Դ
var ItmTrackUrl = 'dhcstm.itmtrackaction.csp';

var MasterStore = new Ext.data.JsonStore({
	url : ItmTrackUrl+'?actiontype=Query',
	totalProperty : "results",
	root : 'rows',
	fields : ["rowid","inci","inciCode","inciDesc","label","status","incib","incibNo","spec","uomDesc",
				"currentLoc","vendor","date","time","user","OldOrginalBarCode","originalCode","expDate","manfId","manfName","RpPuruom","specDesc","PrintFlag",
				"VenMatManLic","ManfProPermit"]
});

//ģ��
var MasterGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(), {
		header : "rowid",
		dataIndex : 'rowid',
		hidden : true
	}, {
		header : "inci",
		dataIndex : 'inci',
		width : 100,
		align : 'left',
		hidden : true
	},print, {
		header : "��ӡ���",
		dataIndex : 'PrintFlag',
		width : 100,
		align : 'left',
		sortable : false,
		renderer : PrintRenderer
	}, {
		header : "���ʴ���",
		dataIndex : 'inciCode',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "��������",
		dataIndex : 'inciDesc',
		width : 200,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'label',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "�����Դ�����",
		dataIndex : 'OldOrginalBarCode',
		hidden : true,		//��Ψһ�Դ�����(���·���originalCode,������Ŀ����ʹ��һ���͹���)
		width : 150
	}, {
		header : "�Դ�����",
		dataIndex : 'originalCode',
		hidden : false,
		width : 150
	}, {
		header : "״̬",
		dataIndex : 'status',
		width : 60,
		align : 'center',
		sortable : true,
		renderer : statusRenderer
	}, {
		header : "����id",
		dataIndex : 'incib',
		width : 150,
		align : 'left',
		hidden : true,
		sortable : true
	}, {
		header : "����~Ч��",
		dataIndex : 'incibNo',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "���",
		dataIndex : 'spec',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "������",
		dataIndex : 'specDesc',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "��λ",
		dataIndex : 'uomDesc',
		width : 60,
		align : 'left',
		sortable : true
	}, {
		header : "��Ӧ��",
		dataIndex : 'vendor',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "����",
		dataIndex : 'manfName',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "��ǰλ��",
		dataIndex : 'currentLoc',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "��������(ע��)����",
		dataIndex : 'date',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "��������(ע��)ʱ��",
		dataIndex : 'time',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "������",
		dataIndex : 'user',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "��Ӧ�̾�Ӫ���",
		dataIndex : 'VenMatManLic',
		width : 150
	}, {
		header : "�����������",
		dataIndex : 'ManfProPermit',
		width : 150
	}
]);
//��ʼ��Ĭ��������
MasterGridCm.defaultSortable = true;

var MasterGridToolbar = new Ext.PagingToolbar({
	store:MasterStore,
	pageSize:20,
	displayInfo:true
});

//Master���
var MasterGrid = new Ext.ux.GridPanel({
	region:'center',
	id:'MasterGrid',
	title:'������Ϣ',
	store:MasterStore,
	cm:MasterGridCm,
	trackMouseOver:true,
	stripeRows:true,
	plugins:print,
	sm : new Ext.grid.RowSelectionModel({
		singleSelect:true,
		listeners:{
			'rowselect':function(sm,rowIndex,r){
				var parref = MasterStore.data.items[rowIndex].data["rowid"];
				DetailStore.setBaseParam('Parref',parref);
				DetailStore.removeAll();
				DetailStore.load({
					params:{start:0,limit:999,dir:'DESC'},
					callback:function(r,options,success){
						if(success==false){
							Msg.info('error','��ѯ����,��鿴��־!');
							return;
						}
					}
				});
			}
		}
	}),
	loadMask:true,
	bbar:MasterGridToolbar,
	listeners : {
		rowdblclick : function(grid, rowIndex, e){
			var record = this.getStore().getAt(rowIndex);
			var dhcit = record.get('rowid');
			if(Ext.isEmpty(dhcit)){
				return;
			}
			var BarCode = record.get('label');
			var IncDesc = record.get('inciDesc');
			var InfoStr = BarCode + ' : ' + IncDesc;
			BarCodePackItm(dhcit, InfoStr);
		}
	}
});


var DetailStore = new Ext.data.JsonStore({
	url : ItmTrackUrl+'?actiontype=QueryItem',
	root : 'rows',
	fields : ["RowId","Type","Pointer","OperNo","loc","specification","Date","Time","User","OperOrg","IntrFlag"]
});

//ģ��
var DetailGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(), {
		header : "detailRowid",
		dataIndex : 'RowId',
		hidden : true
	}, {
		header : "����",
		dataIndex : 'Type',
		width : 100,
		align : 'left',
		renderer : TypeRenderer
	}, {
		header : "Pointer",
		dataIndex : 'Pointer',
		width : 100,
		hidden : true
	}, {
		header : "̨�ʱ��",
		dataIndex : 'IntrFlag',
		width : 80,
		xtype : 'checkcolumn'
	},{
		header : "�����",
		dataIndex : 'OperNo',
		width : 200
	}, {
		header : "ҵ��������",
		dataIndex : 'Date',
		width : 100
	}, {
		header : "ҵ����ʱ��",
		dataIndex : 'Time',
		width : 100
	}, {
		header : "ҵ�������",
		dataIndex : 'User',
		width : 100
	}, {
		header : "λ����Ϣ",
		dataIndex : 'OperOrg',
		width : 200
	}]);

//Detail���
var DetailGrid = new Ext.ux.GridPanel({
	id:'DetailGrid',
	region:'south',
	height:gGridHeight,
	split: true,
	collapsible:true,
	title:'������ϸ��Ϣ',
	store:DetailStore,
	cm:DetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true
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
	var inciDesc=Ext.getCmp("inciDesc").getValue();
	var label=Ext.getCmp("label").getValue();
	var Vendor=Ext.getCmp("Vendor").getValue();
	var printstau=Ext.getCmp("PrintStatus").getValue();
	if(inciDesc==""){
		inciDr="";
	}
	if(!Ext.isEmpty(inciDr)){
		inciDesc="";
	}
	var StartDate=Ext.getCmp("StartDate").getValue();
	var EndDate=Ext.getCmp("EndDate").getValue();
	if(StartDate>EndDate){
		Msg.info("warning","��ʼ���ڲ��ô��ڽ�ֹ����!");
		return;
	}
	if(StartDate!=""){
		StartDate = StartDate.format(ARG_DATEFORMAT);
	}
	if(EndDate!=""){
		EndDate = EndDate.format(ARG_DATEFORMAT);
	}
	var originalCode = Ext.getCmp("originalCode").getValue();
	var CurStatus = Ext.getCmp("CurStatus").getValue();
	var DateFlag = Ext.getCmp('DateFlag').getValue()?'Y':'N';
	var RegNo = Ext.getCmp("Regno").getValue();
	var CurrPhaLoc = Ext.getCmp("CurrPhaLoc").getValue();
	var batno=Ext.getCmp("batno").getValue();
	var ORDateFlag= Ext.getCmp('ORDateFlag').getValue()?'Y':'N';
	if(ORDateFlag=="Y"){
		var ORStartDate=Ext.getCmp("ORStartDate").getValue();
		var OREndDate=Ext.getCmp("OREndDate").getValue();
		if(ORStartDate!=""){
			ORStartDate = ORStartDate.format(ARG_DATEFORMAT);
		}
		if(OREndDate!=""){
			OREndDate = OREndDate.format(ARG_DATEFORMAT);
		}
	}else{
		ORStartDate="";
		OREndDate="";
	}
	var SluggishFlag = Ext.getCmp('SluggishFlag').getValue()?'Y':'N';
	var SluggishGap = Ext.getCmp('SluggishGap').getValue();
	var Others=Vendor+"^"+StartDate+"^"+EndDate+"^"+originalCode+"^"+CurStatus
			+"^"+DateFlag+"^"+RegNo+"^"+CurrPhaLoc+"^"+batno+"^"+printstau
			+"^"+inciDesc+"^"+ORStartDate+"^"+OREndDate+"^"+SluggishFlag
			+"^"+SluggishGap;
	MasterStore.setBaseParam('inci',inciDr);
	MasterStore.setBaseParam('label',label);
	MasterStore.setBaseParam('others',Others);
	DetailStore.removeAll();
	MasterStore.removeAll();
	MasterStore.load({
		params:{start:0,limit:MasterGridToolbar.pageSize},
		callback : function(r,options, success){
			if(success==false){
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
		clearPanel(formPanel);
		Ext.getCmp('DateFlag').setValue(true);
		Ext.getCmp('StartDate').setValue(new Date().add(Date.DAY,-30));
		Ext.getCmp('EndDate').setValue(new Date());
		Ext.getCmp("PrintStatus").setValue(0);
		DetailStore.removeAll();
		MasterStore.removeAll();
	}
});
var printBarCode = new Ext.Toolbar.Button({
		text : '��ӡ����',
		iconCls : 'page_print',
		width : 70,
		height : 30,
		handler : function(button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var count = MasterGrid.getStore().getCount();
			for(var rowIndex=0;rowIndex<count;rowIndex++){
				var RowData = MasterGrid.getStore().getAt(rowIndex);
				var print = RowData.get('print');
				if(print!="Y"){
					continue;
				}
				var barcode = RowData.get("label");	
				var printflag = RowData.get("PrintFlag");
				if (printflag=="Y" && !confirm(barcode+"�����Ѿ���ӡ,�Ƿ������ӡ��")){
					return;
				}
				PrintBarcode(barcode);
			}
		}
	});

var printBarCode2 = new Ext.Toolbar.Button({
		text : '��ӡ����2��',
		iconCls : 'page_print',
		width : 70,
		height : 30,
		handler : function(button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var count = MasterGrid.getStore().getCount();
			for(var rowIndex=0;rowIndex<count;rowIndex++){
				var RowData = MasterGrid.getStore().getAt(rowIndex);
				var print = RowData.get('print');
				if(print!="Y"){
					continue;
				}
				var barcode = RowData.get("label");	
				var printflag = RowData.get("PrintFlag");
				if (printflag=="Y" && !confirm(barcode+"�����Ѿ���ӡ,�Ƿ������ӡ��")){
					return;
				}
				PrintBarcode(barcode,2);
			}
		}
	});

var printBarCodeAll = new Ext.Toolbar.Button({
		text : '��ӡ��ҳ����',
		iconCls : 'page_print',
		width : 70,
		height : 30,
		handler : function(button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var count = MasterGrid.getStore().getCount();
			for (var i = 0; i < count; i++) {
				var RowData = MasterGrid.getStore().getAt(i);
				var barcode = RowData.get('label');
				var printflag = RowData.get("PrintFlag");
				PrintBarcode(barcode);
			}
		}
	});
var printBarCodeAll2 = new Ext.Toolbar.Button({
		text : '��ӡ��ҳ����2��',
		iconCls : 'page_print',
		width : 70,
		height : 30,
		handler : function(button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var count = MasterGrid.getStore().getCount();
			for (var i = 0; i < count; i++) {
				var RowData = MasterGrid.getStore().getAt(i);
				var barcode = RowData.get('label');
				var printflag = RowData.get("PrintFlag");
				PrintBarcode(barcode,2);
			}
		}
	});
//��ӡ��ť
var PrintBT = new Ext.Toolbar.Button({
		text : '��ӡ',
		tooltip : '�����ӡ',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
				Print();
		}
	});	
function Print(){
	var rowData=MasterGrid.getSelectionModel().getSelected();
	if(rowData==null){
		Msg.info("warning!","��ѡ����Ҫ��ӡ�ĸ�ֵ��Ϣ!");
		return;
		}
	var TrackId=rowData.get("rowid")
	fileName="{DHCSTM_ItmTrack_Common.raq(TrackId="+TrackId+";HospDesc="+App_LogonHospDesc+")}";
	if(ItmTrackParamObj.IndirPrint!="N")
	{
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
}
var UpPicBT = new Ext.Toolbar.Button({
		text : '�ϴ�ͼƬ',
		tooltip : '����ϴ�',
		width : 70,
		height : 30,
		handler : function() {
			UpPicture();
		}
	});
function GetData(label){
	if(label==null||label==""){
		return;
		}
	var url='dhcstm.itmtrackaction.csp?actiontype=Select&label='+label;	
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	return mainData;
}

var formPanel = new Ext.ux.FormPanel({
	title:'��ֵ���ϸ���',
	labelWidth : 80,
	tbar:[queryBT,'-',clearBT,'-',printBarCode,'-',printBarCode2,'-',printBarCodeAll,'-',printBarCodeAll2,'-',PrintBT,'-',UpPicBT],
	items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		autoHeight : true,
		layout : 'column',
		items : [{
			columnWidth : .2,
			layout : 'form',
			items : [label,originalCode,inciDesc,PrintStatus]
		}, {
			columnWidth : .2,
			layout : 'form',
			items : [Vendor,RegnoDetail,Regno,SluggishComp]
		}, {
			columnWidth : .2,
			layout : 'form',
			items : [CurStatus,CurrPhaLoc,batno]
		}, {
			columnWidth : .2,
			layout : 'form',
			items : [StartDate, EndDate, DateFlag]
		}, {
			columnWidth : .2,
			layout : 'form',
			labelWidth : 100,
			items : [ORStartDate, OREndDate, ORDateFlag]
		}]
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

function UpPicture() {
	var rowData=MasterGrid.getSelectionModel().getSelected();
	if(rowData==null){
		Msg.info("warning!","��ѡ����Ҫ�ϴ�ͼƬ�ĸ�ֵ��Ϣ!");
		return;
	}
	var TrackId=rowData.get("rowid")
	var dialog = new Ext.ux.UploadDialog.Dialog({
			width: 600,
			height: 400,
			url: 'dhcstm.barcodeaction.csp?actiontype=Upload&TrackId=' + TrackId,
			reset_on_hide: false,
			permitted_extensions: ['gif', 'jpeg', 'jpg', 'png', 'bmp'],
			allow_close_on_upload: true,
			upload_autostart: false,
			title: '�ϴ���ֵͼƬ'
		});
	dialog.show();
};