// /����: ������Ϣ���
// /��д�ߣ�lihui
// /��д����: 20190304

var userId = session['LOGON.USERID'];
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

Ext.onReady(function() {
		Ext.Ajax.timeout = 120000;	//��Ӧʱ���Ϊ2min
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

var DateFrom = new Ext.ux.DateField({
	fieldLabel : '��ʼ����',
	id : 'DateFrom',
	name : 'DateFrom',
	anchor : '90%'
});
var DateTo = new Ext.ux.DateField({
	fieldLabel : '��ֹ����',
	id : 'DateTo',
	name : 'DateTo',
	anchor : '90%'
	
});
// ���ʱ���
var M_InciCode = new Ext.form.TextField({
	fieldLabel : '���ʱ���',
	id : 'M_InciCode',
	name : 'M_InciCode',
	anchor : '90%',
	width : 150,
	valueNotFoundText : ''
});
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "",getDrugList);
	}
}

/**
 * ���ط���
 */
function getDrugList(record) {
	if (record == null || record == "") {
		return;
	}
	var inciDr = record.get("InciDr");
	var InciCode=record.get("InciCode");
	var InciDesc=record.get("InciDesc");
	Ext.getCmp("M_InciDesc").setValue(InciDesc);
	Ext.getCmp("M_InciCode").setValue(InciCode);
}		
// ��������
var M_InciDesc = new Ext.form.TextField({
	fieldLabel : '��������',
	id : 'M_InciDesc',
	name : 'M_InciDesc',
	anchor : '90%',
	width : 150,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = Ext.getCmp("M_StkGrpType").getValue();
				GetPhaOrderInfo(field.getValue(), stktype);
			}
		}
	}
});
// ��������
var M_StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'M_StkGrpType',
	name : 'M_StkGrpType',
	StkType:App_StkTypeCode,     //��ʶ��������
	anchor:'90%',
	LocId:gLocId,
	UserId:userId,
	DrugInfo:"Y",
	listWidth : 200,
	listeners:{
		change:function(field,newValue,oldValue){
			M_StkCat.setValue("");
		}
	}
}); 
// ������
var M_StkCat = new Ext.ux.ComboBox({
	fieldLabel : '������',
	id : 'M_StkCat',
	name : 'M_StkCat',
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'StkCatName',
	params:{StkGrpId:'M_StkGrpType'}
});
var Vendor=new Ext.ux.VendorComboBox({
	id : 'Vendor',
	name : 'Vendor',
	anchor:'90%'
});
var AuditFlag=new Ext.form.Checkbox({
	fieldLabel:'�����',
	id:'AuditFlag',
	name:'AuditFlag',
	checked:false,
	anchor:'90%',
	width:100,
	handler: function() {
		changeButEnable();
		SearchBT.handler();
	}
});

//��������Դ
var MatAuditUrl = 'dhcstm.matauditaction.csp';
var proxy= new Ext.data.HttpProxy({url:MatAuditUrl+'?actiontype=GetMatAuditInfo',method:'POST'});


// ָ���в���
var fields = ["MALGitmRowId","Incid","ChangeType","LastauditFlag","LastDWALFlag","LastDWALDate","LastDWALTime","LastDWALUser","LastDWALLevel","update","uptime","upusername","AudIncicode", "AudIncidesc", "AudSpec","AudIncsc","AudBaseUOM","AudPuom", "AudNotUseFlag","Manf",
			"brand","vendor","vendorName","registerNo","registerNoExpDate","highpriceflag","chargeflag","implantationmat","model","Supervision","Origin","regCertDateOfIssue","regItmDesc","regCertNoFull","INCIBarCode","Mtdr","MT","Abbrev","ChargeType","Sterile",
			"SterCat","ReportingDays","ProlocDesc","ImportFlag","QualityLevel","ComFrom","Remark","MaxSp","InHosFlag","PbRp","PBLdesc","PbCarrier","BAflag","PBLevel","EndDate","ExpireLen","PrcFile","PrcFileD","BC","StandardCode",
			"NotUseReason","InsuCat","HighRiskFlag","PackUom","PackUomFactor","PackPicPath","MaxPurAmt","DistribFlag","Pbno","ChangeRate","MatQuality","ReqModeLimited","NoLocReq","SpeFlag","SterileDateLen","MedEqptCat","ZeroStk","SpecFlag","BidDate","FirstReqDept",
			"InsuPay","InsuPrice","MatCatOfficial","MatCatClinical","MatCatSpecial"];
// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
var reader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id:'MALGitmRowId',
	pageSize:30,
	fields : fields
});
// ���ݼ�
var MatAuditStore = new Ext.data.Store({
	proxy : proxy,
	reader : reader,
	remoteSort: true
});
var nm = new Ext.grid.RowNumberer();
var sm = new Ext.grid.CheckboxSelectionModel({});		
var MatAuditCm = new Ext.grid.ColumnModel([nm,sm, 
			{
				header : "MALGitmRowId",
				dataIndex : 'MALGitmRowId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			},{
				header : "�����id",
				dataIndex : 'Incid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "���״̬",
				dataIndex : 'LastDWALFlag',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����������",
				dataIndex : 'LastDWALDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "������ʱ��",
				dataIndex : 'LastDWALTime',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "��������",
				dataIndex : 'LastDWALUser',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "����״̬",
				dataIndex : 'ChangeType',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�޸�����",
				dataIndex : 'update',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "�޸�ʱ��",
				dataIndex : 'uptime',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "�޸���",
				dataIndex : 'upusername',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "���ʴ���",
				dataIndex : 'AudIncicode',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : '��������',
				dataIndex : 'AudIncidesc',
				width : 200,
				align : 'left',
				renderer : InciPicRenderer('Incid'),
				sortable : true
			},{
				header : "���",
				dataIndex : 'AudSpec',
				width : 100,
				align : 'left',
				sortable : true
			},{
				header : "�ͺ�",
				dataIndex : 'model',
				width : 50,
				align : 'left',
				sortable : true
			},{
				header : "Ʒ��",
				dataIndex : 'brand',
				width : 60,
				align : 'left',
				sortable : true
			},{
				header : "����",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			},{
				header : "����",
				dataIndex : 'Origin',
				width : 80
			},{
				header : '��ⵥλ',
				dataIndex : 'AudPuom',
				width : 70,
				align : 'left',
				sortable : true
			},{
				header : "������λ",
				dataIndex : 'AudBaseUOM',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "������",
				dataIndex : 'AudIncsc',
				width : 150,
				align : 'left',
				sortable : true
			},{
				header : "������",
				dataIndex : 'AudNotUseFlag',
				width : 45,
				align : 'center',
				xtype:'checkcolumn',
				sortable : true
			},{
				header:'��Ӧ��',
				dataIndex:'vendorName',
				align:'left',
				width:150
			},{
				header:'ע��֤��',
				dataIndex:'registerNo',
				align:'left',
				width:150
			},{
				header:'ע��֤Ч��',
				dataIndex:'registerNoExpDate',
				align:'left',
				width:150
			},{
				header:'ע��֤����',
				dataIndex:'regItmDesc',
				align:'left',
				width:150
			},{
				header:'��ֵ��־',
				dataIndex:'highpriceflag',
				align:'left',
				xtype:'checkcolumn',
				width:80,
				sortable : true
			},{
				header : "ֲ���־",
				dataIndex :'implantationmat',
				xtype:'checkcolumn',
				width : 80,
				align : 'right',
				sortable : true
			}
		]);		
var StatuTabPagingToolbar = new Ext.PagingToolbar({
		store : MatAuditStore,
		pageSize : 30,
		displayInfo : true
	});
var MatAuditGrid = new Ext.ux.GridPanel({
		id:'MatAuditGrid',
		region:'center',
		cm:MatAuditCm,
		store:MatAuditStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm,
		loadMask : true,
		bbar:StatuTabPagingToolbar
	});
function changeButEnable() {
	var AuditFlag = Ext.getCmp("AuditFlag").getValue(); 
	if (AuditFlag == true) {
		AuditNoBT.setDisabled(true);
		AuditYesBT.setDisabled(true);
	} else {
		AuditNoBT.setDisabled(false);
		AuditYesBT.setDisabled(false);
	}
}
// ��ѯ��ť
var SearchBT = new Ext.Toolbar.Button({
	text : '��ѯ',
	tooltip : '�����ѯ',
	iconCls : 'page_find',
	width : 70,
	height : 30,
	handler : function() {
		changeButEnable();
		var inciDesc = Ext.getCmp("M_InciDesc").getValue();
		var inciCode = Ext.getCmp("M_InciCode").getValue();
		var stkCatId = Ext.getCmp("M_StkCat").getValue();
		var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
		var StartDate=Ext.getCmp("DateFrom").getValue();
	    if(!Ext.isEmpty(StartDate)){StartDate=StartDate.format(ARG_DATEFORMAT).toString()}
		var EndDate=Ext.getCmp("DateTo").getValue();
		if(!Ext.isEmpty(EndDate)){EndDate=EndDate.format(ARG_DATEFORMAT).toString()}
		/*if ((StartDate == "")||(EndDate == "")) {
			Msg.info("warning", "��ѡ����ֹ����!");
			return false;
		}*/
		var AuditFlag=(Ext.getCmp("AuditFlag").getValue()==true?"Y":"N");
		var other=inciDesc+"^"+inciDesc+"^"+StkGrpType+"^"+stkCatId;
		MatAuditStore.setBaseParam('StartDate',StartDate);
		MatAuditStore.setBaseParam('EndDate',EndDate);
		MatAuditStore.setBaseParam('AuditFlag',AuditFlag);
		MatAuditStore.setBaseParam('other',other);
		MatAuditStore.setBaseParam('Sort','');
		MatAuditStore.setBaseParam('dir', 'ASC');
		MatAuditStore.removeAll();
		MatAuditStore.load({
			params:{start:0,limit:StatuTabPagingToolbar.pageSize},			
			callback : function(r,options, success) {
				if(!success){
					//Msg.info("error", "��ѯ������鿴��־!");
					//return false;
				}
			}
		});
	}
});
// ��հ�ť
var ClearBT = new Ext.Toolbar.Button({
	text : '���',
	tooltip : '������',
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		M_InciCode.setValue("");
		M_InciDesc.setValue("");
		M_StkGrpType.setValue("");
		M_StkGrpType.getStore().load();
		M_StkCat.setValue("");	
		DateFrom.setValue("");
		DateTo.setValue("");
		MatAuditGrid.getStore().removeAll();
		MatAuditGrid.getView().refresh();
		StatuTabPagingToolbar.getComponent(4).setValue(1);   //���õ�ǰҳ��
		StatuTabPagingToolbar.getComponent(5).setText("ҳ,�� 1 ҳ");//���ù���ҳ
		StatuTabPagingToolbar.getComponent(12).setText("û�м�¼"); //���ü�¼����
	}
});
// ������ť
var AuditYesBT = new Ext.Toolbar.Button({
	id : "AuditYesBT",
	text : '���ͨ��',
	tooltip : '������ͨ��',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
			Audit();
	}
});

/**
* ���
*/
function Audit() {
	var IdStr=""
	var rowDataArr = MatAuditGrid.getSelectionModel().getSelections();
	if (Ext.isEmpty(rowDataArr)) {
		Msg.info("warning", "��ѡ����˵ļ�¼!");
		return;
	}
	for(i=0;i<rowDataArr.length;i++){
		var rowData=rowDataArr[i];
		var LastauditFlag = rowData.get("LastauditFlag");
		if (LastauditFlag == "Y") {
			//Msg.info("warning", "��¼����ˣ����ʵ!");
			continue ;
		}
		var MALGitmRowId = rowData.get("MALGitmRowId");
		var Incid = rowData.get("Incid");
		if (IdStr=="")
		{
			IdStr=Incid+"@"+MALGitmRowId;
		}else{
			IdStr=IdStr+"^"+Incid+"@"+MALGitmRowId;
		}
	}

	if(IdStr==""){Msg.info("warning", "û�п�����˵ļ�¼!");return}
	var url = MatAuditUrl+"?actiontype=AuditStr&IdStr="+ IdStr;
	var loadMask=ShowLoadMask(Ext.getBody(),"������...");
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			loadMask.hide();
			var retinfo=jsonData.info;
			var retarr=retinfo.split("^");
			var Ret=retarr[0];
			var total=retarr[1];
			var sucess=retarr[2];
			if (jsonData.success == 'true') {
				Msg.info("success", "��"+total+"����¼,�ɹ����"+sucess+"����¼!");
				SearchBT.handler();
			} else {
				if(Ret==-1){
					Msg.info("error", "�޵�¼��Ϣ�������µ�¼!");
				}else if(Ret==-2){
					Msg.info("error", "��û�����Ȩ�ޣ���ȥ�ⷿ����ά����ά��!");
				}else if(Ret==-3){
					Msg.info("error", "�������״̬ʧ��!");
				}else{
					Msg.info("error", "���ʧ��:"+Ret);
				}
			}
			
		},
		scope : this
	});
}
// ������ť
var AuditNoBT = new Ext.Toolbar.Button({
	id : "AuditNoBT",
	text : '��˲�ͨ��',
	tooltip : '�����˲�ͨ��',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
			AuditNo();
	}
});

/**
* ���
*/
function AuditNo() {
	var IdStr=""
	var rowDataArr = MatAuditGrid.getSelectionModel().getSelections();
	if (Ext.isEmpty(rowDataArr)) {
		Msg.info("warning", "��ѡ����˵ļ�¼!");
		return;
	}
	for(i=0;i<rowDataArr.length;i++){
		var rowData=rowDataArr[i];
		var LastauditFlag = rowData.get("LastauditFlag");
		if (LastauditFlag == "Y") {
			//Msg.info("warning", "��¼����ˣ����ʵ!");
			continue ;
		}
		var MALGitmRowId = rowData.get("MALGitmRowId");
		var Incid = rowData.get("Incid");
		if (IdStr=="")
		{
			IdStr=Incid+"@"+MALGitmRowId;
		}else{
			IdStr=IdStr+"^"+Incid+"@"+MALGitmRowId;
		}
	}

	if(IdStr==""){Msg.info("warning", "û�п�����˵ļ�¼!");return}
	var url = MatAuditUrl+"?actiontype=AuditNoStr&IdStr="+ IdStr;
	var loadMask=ShowLoadMask(Ext.getBody(),"������...");
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '��ѯ��...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			loadMask.hide();
			var retinfo=jsonData.info;
			var retarr=retinfo.split("^");
			var Ret=retarr[0];
			var total=retarr[1];
			var sucess=retarr[2];
			if (jsonData.success == 'true') {
				Msg.info("success", "��"+total+"����¼,�ɹ����"+sucess+"����¼!");
				SearchBT.handler();
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "�޵�¼��Ϣ�������µ�¼!");
				}else if(Ret==-2){
					Msg.info("error", "��û�����Ȩ�ޣ���ȥ�ⷿ����ά����ά��!");
				}else if(Ret==-3){
					Msg.info("error", "�������״̬ʧ��!");
				}else if(Ret==-4){
					Msg.info("error", "��ԭ�޸���Ϣʧ��!");
				}else{
					Msg.info("error", "���ʧ��:"+Ret);
				}
			}
			
		},
		scope : this
	});
}
var HisListTab = new Ext.ux.FormPanel({
	labelWidth: 60,
	title:'���������Ϣ��ѯ',
	tbar : [SearchBT, '-', ClearBT, '-', AuditYesBT, '-', AuditNoBT],
	items:[{
		xtype:'fieldset',
		title:'��ѯ����',
		layout: 'column',    
		defaults : {xtype: 'fieldset', border : false},
		style:'padding:0px 0px 0px 5px',
		items : [{
			columnWidth: 0.25,
			items: [M_InciCode,M_InciDesc,DateFrom]
		}, {
			columnWidth: 0.25,
			items : [M_StkGrpType,M_StkCat,DateTo]
		}, {
			columnWidth: 0.25,
			items : [AuditFlag]
		}/*, {
			columnWidth: 0.25,
			items : [M_HighPrice,M_ChargeFlag,M_ImplantationMat,Spec,Brand,Vendor]
		}*/]
	}]
});
var viewport = new Ext.ux.Viewport({
            layout: 'border',           
            title: '�������',
            items: [HisListTab, MatAuditGrid]
        });
})