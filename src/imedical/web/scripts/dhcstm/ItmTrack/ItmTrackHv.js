// ����:��ֵ���ϸ��ٲ�ѯ�˻�
// ��д����:2016-06-14
var impWindow = null;
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gLocId=session['LOGON.CTLOCID'];
var inciDr="";
var loadMask=null;
var colArr=[];

//ȡ��ֵ�������
var UseRet="";
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseRet=gItmTrackParam[4];
	if(UseRet=='Y'){
	}else{
		Msg.info("warning","�˲˵���ʹ��!");
	}
}
	
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

var DateFlag = new Ext.form.Checkbox({
	boxLabel : '�������ڼ���',
	id : 'DateFlag',
	anchor : '90%',
	checked : true
});

var CurrPhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '��ǰ����',
	id : 'CurrPhaLoc',
	anchor:'90%',
	width : 120,
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

// ���水ť
var SaveBT = new Ext.Toolbar.Button({
	id : "SaveBT",
	text : 'ȷ��',
	tooltip : '���ȷ��',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		// ����������
		Save();	
	}
});
	
var PrintStatus = new Ext.form.ComboBox({
	fieldLabel : '��ӡ״̬',
	id : 'PrintStatus',
	name : 'PrintStatus',
	anchor:'90%',
	width : 120,
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
	hidden : true,
	sortable:true
});
//��������Դ
var ItmTrackUrl = 'dhcstm.itmtrackaction.csp';

var MasterStore = new Ext.data.JsonStore({
	url : ItmTrackUrl+'?actiontype=Query',
	totalProperty : "results",
	root : 'rows',
	fields : ["rowid","inci","inciCode","inciDesc","label","status","incib","incibNo","spec","uomDesc",
				"currentLoc","vendor","date","time","user","originalCode","expDate","manfId","manfName","RpPuruom","specDesc","PrintFlag","retoriflag"]
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
		hidden : true,
		renderer : PrintRenderer
	},{
		header : "�ⷿȷ��",
		dataIndex : 'retoriflag',
		width : 100,
		align : 'left',
		sortable : true
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
		header : "�Դ�����",
		dataIndex : 'originalCode',
		width : 150
	}, {
		header : "״̬",
		dataIndex : 'status',
		renderer : statusRenderer,
		width : 60,
		align : 'center',
		sortable : true
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
		header : "����",
		dataIndex : 'date',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "ʱ��",
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
					params:{start:0,limit:999,dir:'ASC'},
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
	bbar:MasterGridToolbar
});


var DetailStore = new Ext.data.JsonStore({
	url : ItmTrackUrl+'?actiontype=QueryItem',
	root : 'rows',
	fields : ["RowId","Type","Pointer","OperNo","loc","specification","Date","Time","User","OperOrg"]
});

function TypeRenderer(value){
	var TypeDesc=value;
	if(value=="G"){
		TypeDesc="���";
	}else if(value=="R"){
		TypeDesc="�˻�";
	}else if(value=="T"){
		TypeDesc="ת�Ƴ���";
	}else if(value=="K"){
		TypeDesc="ת�ƽ���";
	}else if(value=="P"){
		TypeDesc="סԺҽ��";
	}else if(value=="Y"){
		TypeDesc="ҽ��ȡ��(�ϳ�)";
	}else if(value=="A"){
		TypeDesc="������";
	}else if(value=="D"){
		TypeDesc="��汨��";
	}else if(value=="F"){
		TypeDesc="���﷢��";
	}else if(value=="H"){
		TypeDesc="�����˻�";
	}else if(value=="RD"){
		TypeDesc="����";
	}
	else if(value=="PD"){
		TypeDesc="�ɹ�";
	}
	else if(value=="POD"){
		TypeDesc="����";
	}
	else if(value=="SG"){
		TypeDesc="��ⲹ¼";
	}
	else if(value=="ST"){
		TypeDesc="ת�Ƴ��ⲹ¼";
	}
	else if(value=="SK"){
		TypeDesc="ת�ƽ��ղ�¼";
	}
	else if(value=="SR"){
		TypeDesc="�˻���¼";
	}
	return TypeDesc;
}
function PrintRenderer(value){
	var printFlag=value;
	if (value=="Y"){
	   printFlag="�Ѵ�ӡ";
	}
	return printFlag;
}
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
		header : "�����",
		dataIndex : 'OperNo',
		width : 200
	}, {
		header : "����",
		dataIndex : 'Date',
		width : 100
	}, {
		header : "ʱ��",
		dataIndex : 'Time',
		width : 100
	}, {
		header : "������",
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
	height:250,
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
	var StartDate=Ext.getCmp("StartDate").getValue();
	var EndDate=Ext.getCmp("EndDate").getValue();
	if(StartDate!=""){
		StartDate = StartDate.format(ARG_DATEFORMAT);
	}
	if(EndDate!=""){
		EndDate = EndDate.format(ARG_DATEFORMAT);
	}
	if(StartDate>EndDate){
		Msg.info("warning","��ʼ���ڲ��ô��ڽ�ֹ����!");
		return;
	}	
	var originalCode = Ext.getCmp("originalCode").getValue();
	var CurStatus = Ext.getCmp("CurStatus").getValue();
	var DateFlag = Ext.getCmp('DateFlag').getValue()?'Y':'N';
	var RegNo = Ext.getCmp("Regno").getValue();
	var RegNo=""
	var CurrPhaLoc = Ext.getCmp("CurrPhaLoc").getValue();
	var batno=Ext.getCmp("batno").getValue();
	var batno=""
	var Others=Vendor+"^"+StartDate+"^"+EndDate+"^"+originalCode+"^"+CurStatus
			+"^"+DateFlag+"^"+RegNo+"^"+CurrPhaLoc+"^"+batno+"^"+printstau;
	//alert(Others)
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
function Save(){
	//var label=Ext.getCmp("label").getValue();
	var rowData=MasterGrid.getSelectionModel().getSelected();
	if(rowData==null){
		Msg.info("warning!","��ѡ����Ҫȷ�ϵĸ�ֵ��Ϣ!");
		return;
	}
	var label=rowData.get("label")
	var retoriflag=rowData.get("retoriflag")
	if(retoriflag=="Y"){
	    Msg.info("warning!","��ȷ��!");
		return;
	}
	var url =  "dhcstm.itmtrackaction.csp?actiontype=SaveHv&LAbel="+label;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '������...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "ȷ�ϳɹ�!");
                Query();					
			} else {
				Msg.info("error", "ȷ��ʧ��:"+jsonData.info);
			}
		},
		scope : this
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
		var count=MasterGrid.getStore().getCount();
		for(var rowIndex=0;rowIndex<count;rowIndex++){	
		var print=MasterGrid.getStore().getAt(rowIndex).get('print');
		if(print!="Y"){continue}
		var barcode=MasterGrid.getStore().getAt(rowIndex).get("label");	
		var IncDesc=MasterGrid.getStore().getAt(rowIndex).get("inciDesc");
		var Spec=MasterGrid.getStore().getAt(rowIndex).get("spec");	
		var printflag=MasterGrid.getStore().getAt(rowIndex).get("PrintFlag");
		var MyPara='BarCode'+String.fromCharCode(2)+"*"+barcode+"*"
				+'^IncDesc'+String.fromCharCode(2)+IncDesc
				+'^Spec'+String.fromCharCode(2)+Spec;
		if (printflag=="Y"){
			var ret=confirm(barcode+"�����Ѿ���ӡ,�Ƿ������ӡ��");
			var printflag="�Ѵ�ӡ";
			if(ret==true){
			var MyPara=MyPara+'^PrintFlag'+String.fromCharCode(2)+printflag;
			DHCP_PrintFun(MyPara,"");
			}else{
			return;
			}
		}else{
			DHCP_PrintFun(MyPara,"");
			var PrintFlag="Y"
			SavePrintFlag(PrintFlag,barcode);
		}
			
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
	var label=rowData.get("label")
	var MainData=GetData(label)
	var mainArr=mainData.split("^");
	var incidesc=mainArr[0]
	var manfdesc=mainArr[1]
	var BusinessRegNo=mainArr[2]
	var vendordec=mainArr[3]
	var inforemark=mainArr[4]
	var batno=mainArr[5]
	var expdate=mainArr[6]
	var spec=mainArr[7]
	var sp=mainArr[8]
	
	fileName="{DHCSTM_ItmTrack_Common.raq(incidesc="+incidesc+";manfdesc="+manfdesc+";BusinessRegNo="+BusinessRegNo+";vendordec="+vendordec+";inforemark="+inforemark+";batno="+batno+";expdate="+expdate+";spec="+spec+";sp="+sp+")}";
	DHCCPM_RQDirectPrint(fileName);
}	
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
	title:'��ֵ�˿�ⷿȷ��',
	tbar:[queryBT,'-',clearBT,'-',SaveBT],
	layout:'fit',
	items : [{
		xtype : 'fieldset',
		title : '��ѯ����',
		autoHeight : true,
		items : [{
			layout : 'column',
			items : [{
				columnWidth : .20,
				layout : 'form',
				items : [label,originalCode]
			}, {
				columnWidth : .20,
				layout : 'form',
				items : [StartDate, EndDate]
			}, {
				columnWidth : .20,
				layout : 'form',
				items : [DateFlag]
			}]
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

function SavePrintFlag(PrintFlag,Barecode){
	  tkMakeServerCall("web.DHCSTM.DHCItmTrack","SavePrintFlag",PrintFlag,Barecode);
}
