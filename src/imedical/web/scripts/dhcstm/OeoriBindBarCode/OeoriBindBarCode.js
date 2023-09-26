// /����: ��ֵҽ��(ҽ�������ͱ���ؽ��û�����)�󶨸�ֵ����,�������
// /��д�ߣ�wangjiabin
// /��д����: 2015.06.18

var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var actionUrl = DictUrl + 'oeoribindbarcodeaction.csp';

var RecLoc = new Ext.ux.LocComboBox({
	id:'RecLoc',
	fieldLabel:'ҽ�����տ���',
	anchor:'90%',
	defaultLoc:{}
});
SetLogInDept(RecLoc.getStore(), 'RecLoc');

// ��ʼ����
var StartDate = new Ext.ux.DateField({
	fieldLabel : '��ʼ����',
	id : 'StartDate',
	anchor : '90%',
	
	width : 100,
	value : new Date()
});

// ��ֹ����
var EndDate = new Ext.ux.DateField({
	fieldLabel : '��ֹ����',
	id : 'EndDate',
	anchor : '90%',
	
	width : 100,
	value : new Date()
});
/*
 * ����ҽ������ComboBox
 */
var AllArcItemCatStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : 'dhcstm.drugutil.csp?actiontype=AllArcItemCat'
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId'])
});
var ARCItemCat = new Ext.ux.ComboBox({
	fieldLabel : 'ҽ������',
	id : 'ARCItemCat',
	store : AllArcItemCatStore,
	filterName : 'Desc'
});

var Regno = new Ext.form.TextField({
	fieldLabel : '�ǼǺ�',
	id : 'Regno',
	anchor : '90%',
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
	anchor : '90%'
});
var oeoriname = new Ext.form.TextField({
	fieldLabel : 'ҽ������',
	id : 'oeoriname',
	anchor : '90%'
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

function clearData() {
	clearPanel(HisListTab);
	HisListTab.getForm().setValues({StartDate:new Date(),EndDate:new Date()});
	MasterGrid.removeAll();
	DetailGrid.removeAll();
	BarCodeValidator.setValue('');
}

var SaveBT = new Ext.ux.Button({
	id:'SaveBT',
	text : '����',
	tooltip : '�����ֵ������Ϣ',
	iconCls : 'page_save',
	handler : function() {
		Save();
	}
});

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
	var AckFlag = DetailGrid.getAt(0).get('AckFlag');
	if(AckFlag == 'Y'){
		Msg.info('error', '��ҽ���Ѿ����!');
		DetailGrid.reload();
		return false;
	}
	var loadMask = ShowLoadMask(Ext.getBody(), "������...");
	Ext.Ajax.request({
		url : actionUrl + '?actiontype=Save',
		params : {MainInfo : MainInfo, ListDetail : ListDetail},
		method : 'POST',
		waitMsg : '������...',
		//async:true ,
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				Msg.info('success', '����ɹ�!');
				//MasterGrid.reload();
				DetailGrid.reload();
			} else {
				var info=jsonData.info;
				var infoArr=info.split("^");
				if (infoArr[0]==-3){
					Msg.info('error', "����"+infoArr[1]+"�����ڿ���"+LocDesc);
				}else{
				    Msg.info('error', '����ʧ��:'+info);
				}
			}
		},
		scope : this
	});
}

var AuditBT = new Ext.ux.Button({
	id:'AuditBT',
	text : '���ȷ��',
	tooltip : '������ȷ��',
	iconCls : 'page_gear',
	handler : function() {
			Ext.Msg.show({
				title:'��ʾ',
				msg: '���ǰ��ȷ�ϰ���������',
				buttons: Ext.Msg.YESNO,
				fn: function(b,t,o){
					if (b=='yes'){Audit();}
				},
				icon: Ext.MessageBox.QUESTION
			});
	}
});

function Audit() {
	var MasterSel = MasterGrid.getSelected();
	if(Ext.isEmpty(MasterSel)){
		Msg.info('warning', '��ѡ����Ҫ��˵�ҽ��!');
		return false;
	}
	var DetailCount = DetailGrid.getStore().getTotalCount();
	if(DetailCount == 0){
		Msg.info('warning', 'û����Ҫ��˵���ϸ!');
		return false;
	}
	var AckFlag = DetailGrid.getAt(0).get('AckFlag');
	if(AckFlag == 'Y'){
		Msg.info('error', '��ҽ���Ѿ����!');
		return false;
	}
	var Oeori = MasterSel.get('Oeori');
	var loadMask=ShowLoadMask(document.body,'�����...');
	Ext.Ajax.request({
		url : actionUrl + '?actiontype=Audit',
		params : {Oeori : Oeori, UserId : gUserId},
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				Msg.info('success', '��˳ɹ�!');
				DetailGrid.reload();
			} else {
				var Ret=jsonData.info;
				Msg.info('error', '���ʧ��:'+Ret);
			}
		},
		scope : this
	});
}

// ��ӡ��ť
var PrintBT = new Ext.Toolbar.Button({
	id:'PrintBT',
	text : '��ӡ',
	tooltip : '�����ӡ',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=MasterGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info('warning', '��ѡ����Ҫ��ӡ����ⵥ!');
			return;
		}
		var DhcIngr = rowData.get('IngrId');
		PrintRec(DhcIngr);
	}
});

var HisListTab = new Ext.ux.FormPanel({
	title:'��ֵҽ�������',
	tbar : [SearchBT, '-', ClearBT, '-', SaveBT, '-', AuditBT],
	items:[{
		xtype:'fieldset',
		title:'��ѯ����',
		layout: 'column',
		style:'padding:5px 0px 0px 0px;',
		defaults: {width: 220, border:false},
		items : [{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [StartDate, EndDate]
			},{
				columnWidth: 0.25,
				xtype: 'fieldset',
				labelWidth : 85,
				items: [RecLoc, ARCItemCat]
			},{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [RegnoDetail, Regno]
			},{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [oeoriname]
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
/*	}, {
		header : 'ҽ��ʱ��',
		dataIndex : 'OeoriTime',
		width : 80*/
	}, {
		header : 'ҽ��¼����',
		dataIndex : 'UserAddName',
		width : 100
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
	autoLoadStore : true,
	actionUrl : actionUrl,
	queryAction : 'QueryOeori',
	paramsFn : GetMasterParams,
	idProperty : 'IngrId',
	showTBar : false
});

function rowSelFn(sm, rowIndex, r) {
	var rowData = sm.grid.getAt(rowIndex);
	var Oeori = rowData.get('Oeori');
	var StrParam = Oeori;
	DetailGrid.load({params:{StrParam:StrParam}});
}
		
function GetMasterParams(){
	var RecLoc = Ext.getCmp('RecLoc').getValue();
	var StartDate = Ext.getCmp('StartDate').getValue();
	var EndDate = Ext.getCmp('EndDate').getValue();
	if(RecLoc==''){
		Msg.info('warning', '��ѡ��ҽ�����տ���!');
		return false;
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
	var PaAdmNo = Ext.getCmp('Regno').getValue();
	var ARCItemCat = Ext.getCmp('ARCItemCat').getValue();
	var ExcludeInci = 'Y';
	var Oeoriname = Ext.getCmp('oeoriname').getValue();
	var StrParam = StartDate+'^'+EndDate+'^'+PaAdmNo+'^'+RecLoc+'^'+ARCItemCat
		+'^^'+ExcludeInci+'^^'+Oeoriname;
	
	return {'Sort' : '', 'Dir' : '','StrParam' : StrParam};
}

var DetailCm = [{
		header : 'RowId',
		dataIndex : 'RowId',
		saveColIndex : 0,
		width : 80,
		hidden : true
	}, {
		header : 'Dhcit',
		dataIndex : 'Dhcit',
		saveColIndex : 1,
		width : 70,
		hidden : true,
		sortable : true
	}, {
		header : '���ʴ���',
		dataIndex : 'InciCode',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : '��������',
		dataIndex : 'InciDesc',
		width : 150,
		sortable : true
	}, {
		header : '��ֵ����',
		dataIndex : 'BarCode',
		saveColIndex : 2,
		width : 120,
		sortable : true
	}, {
		header : '��������',
		dataIndex : 'Manf',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : '����Id',
		dataIndex : 'Inclb',
		width : 180,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : '����~Ч��',
		dataIndex : 'BatExp',
		width : 140,
		align : 'left',
		sortable : true
	}, {
		header : '����',
		dataIndex : 'Rp',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : '��¼����',
		dataIndex : 'OBBDate',
		width : 80,
		sortable : true
	}, {
		header : '��¼ʱ��',
		dataIndex : 'OBBTime',
		width : 80,
		sortable : true
	}, {
		header : '��¼��',
		dataIndex : 'OBBUser',
		width : 80,
		sortable : true
	}, {
		header : '��˱�־',
		dataIndex : 'AckFlag',
		width : 80,
		xtype : 'checkcolumn'
	}, {
		header : '�������',
		dataIndex : 'OBBAckDate',
		width : 80,
		sortable : true
	}, {
		header : '���ʱ��',
		dataIndex : 'OBBAckTime',
		width : 80,
		sortable : true
	}, {
		header : '�����',
		dataIndex : 'OBBAckUser',
		width : 80,
		sortable : true
	}, {
		header : 'ȡ���������',
		dataIndex : 'CancelDate',
		width : 80,
		sortable : true
	}, {
		header : 'ȡ�����ʱ��',
		dataIndex : 'CancelTime',
		width : 80,
		sortable : true
	}, {
		header : 'ȡ�������',
		dataIndex : 'CancelSSUSR',
		width : 80,
		sortable : true
	}
];

var BarCodeValidator = new Ext.form.TextField({
	fieldLabel : '��ֵ����',
	width : 200,
	listeners : {
		specialkey : function(field, e){
			var Barcode=field.getValue();
			if (Barcode!="" && e.getKey() == Ext.EventObject.ENTER){
				var findHVIndex = DetailGrid.getStore().findExact('BarCode',Barcode,0);
				if(findHVIndex >= 0){
					Msg.info("warning","�����ظ�¼��!");
					field.setValue("");
					return;
				}
				var MasterSel = MasterGrid.getSelected();
				if(Ext.isEmpty(MasterSel)){
					Msg.info('warning', '��ѡ����Ҫ�����ҽ��!');
					return false;
				}
				var RecLoc = MasterSel.get('RecLoc');
				Ext.Ajax.request({
					url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode',
					params : {'Barcode' : Barcode},
					method : 'POST',
					waitMsg : '��ѯ��...',
					success : function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if(jsonData.success == 'true'){
							var itmArr=jsonData.info.split("^");
							var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
							var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
							if(inclb==""){
								Msg.info("warning", Barcode+" û����Ӧ����¼,�����Ƶ�!");
								field.setValue('');
								return;
							}else if(lastDetailAudit!="Y"){
								Msg.info("warning", Barcode+" ��ֵ������δ��˵�"+lastDetailOperNo+",���ʵ!");
								field.setValue('');
								return;
							}else if(type=="T"){
								Msg.info("warning", Barcode+" ��ֵ�����Ѿ�����,�����Ƶ�!");
								field.setValue('');
								return;
							}else if(status!="Enable"){
								Msg.info("warning", Barcode+" ��ֵ���봦�ڲ�����״̬,�����Ƶ�!");
								field.setValue('');
								return;
							}else if(RecLoc!=itmArr[28]){
								Msg.info("warning", Barcode+" ��ֵ������տ��Һ�ʹ�ÿ��Ҳ�һ��,�����Ƶ�!");
								field.setValue('');
								return;
							}
							var url = "dhcstm.itmtrackaction.csp?actiontype=Select&label=" + Barcode;
							var jsonData = ExecuteDBSynAccess(url);
							var info = Ext.util.JSON.decode(jsonData).info;
							var infoArr = info.split('^');
							var Dhcit = infoArr[11], InciCode = infoArr[10], InciDesc = infoArr[0], Manf = infoArr[1], Inclb = infoArr[12],
								BatchNo = infoArr[5], ExpDate =infoArr[6], Rp = infoArr[9];
							var BatExp = BatchNo + '~' + ExpDate;
							var Values = {Dhcit : Dhcit, InciCode : InciCode, InciDesc : InciDesc, BarCode : Barcode, Manf : Manf,
									Inclb : Inclb, BatExp : BatExp, Rp : Rp};
							var NewRecord = CreateRecordInstance(DetailGrid.getStore().fields, Values);
							DetailGrid.add(NewRecord);
							field.setValue('');
						}else{
							Msg.info("warning","��������δע��!");
							field.setValue('');
							return;
						}
					}
				});
			}
		}
	}
});

var DeleteButton = new Ext.ux.Button({
	id : 'DeleteButton',
	text : 'ɾ��һ��',
	iconCls : 'page_delete',
	handler : function(){
		var SelRecord = DetailGrid.getSelected();
		if(SelRecord == null){
			Msg.info('warning', '��ѡ����Ҫɾ������ϸ!');
			return false;
		}
		var RowId = SelRecord.get(DetailGrid.idProperty);
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
	smType : 'row',
	contentColumns : DetailCm,
	actionUrl : actionUrl,
	queryAction : 'QueryDetail',
	selectFirst : false,
	idProperty : 'RowId',
	checkProperty : 'Dhcit',
	editable : false,
	paging : false,
	showTBar : false,
	tbar : ['��ֵ����:',BarCodeValidator, '-', DeleteButton]
});
function cancelresult(btn){
	if(btn=="yes"){
	var rows=DetailGrid.getSelectionModel().getSelections();
	var selectedRow = rows[0];
	var DHCOBBRowId=selectedRow.get("RowId");
	var url=actionUrl+"?actiontype=CancelAudit&DHCOBBRowId="+DHCOBBRowId+"&UserId="+gUserId;
	Ext.Ajax.request({
		url:url,
		method:'POST',
		waitMsg:'��ѯ��...',
		success: function(result,request){
			   var jsonData=Ext.util.JSON.decode(result.responseText);
			   if (jsonData.success=="true"){
				   Msg.info("success","ȡ����˳ɹ�!");
	   	           DetailGrid.reload(); 
			   }else{
			       var ret=jsonData.info;
			       if (ret==-2){
				       Msg.info("error","��ȡ����˻��߻�δ��ˣ�");
				   }else if (ret==-3){
					   Msg.info("error","���ڹ�ȡ����˼�¼���������ٴ�ȡ����");
				   }else{
					   Msg.info("error","�������ʧ�ܣ�"+ret);
				   }
			   }
			},
		scope:this
	});
	}
}
function CancelAudit(){
	var rows=DetailGrid.getSelectionModel().getSelections();
	if (rows.length == 0){Msg.info("warning","û��ѡ�е���!"); return false;}
	var selectedRow = rows[0];
	var DHCOBBRowId=selectedRow.get("RowId");
	if (DHCOBBRowId==""){
	   	DetailGrid.getView().refresh();
	}else{
	    Ext.MessageBox.show({
		   title:'��ʾ',
		   msg:'�Ƿ�ȷ��ȡ�����?',
		   buttons:Ext.MessageBox.YESNO,
		   fn:cancelresult,
		   icon:Ext.MessageBox.QUESTION
	    });	
	}
}
//����Ҽ�ȡ�����
function rightClickFn(grid,rowindex,e){
	   e.preventDefault();
	   grid.getSelectionModel().selectRow(rowindex);
	   rightClick.showAt(e.getXY());
	}
var rightClick = new Ext.menu.Menu({
	   id : 'rightclickM',
	   items : [{
		     id : 'cancelmenu',
		     handler : CancelAudit,
		     text : 'ȡ�����'
		   }]
	});
DetailGrid.addListener('rowcontextmenu',rightClickFn);

Ext.onReady(function() {
	Ext.QuickTips.init();
	
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, MasterGrid, DetailGrid],
				renderTo : 'mainPanel'
			});
});