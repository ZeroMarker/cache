//==================��ֵ����ʹ�û���===================//	
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var gInciId = "";

var PhaLoc=new Ext.ux.LocComboBox({
	fieldLabel : '<font color=blue>���տ���</font>',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor : '90%',
	emptyText : '����...',
	//groupId:gGroupId,
	stkGrpId : 'StkGrpType'
});

var DateFrom = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>��ʼ����</font>',
	id : 'DateFrom',
	name : 'DateFrom',
	anchor : '90%',
	
	value :new Date()
});
	
var DateTo = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>��ֹ����</font>',
	id : 'DateTo',
	name : 'DateTo',
	anchor : '90%',
	
	value : new Date()
});

// ��������
var StkGrpField = new Ext.ux.StkGrpComboBox({
	id:'StkGrpType',
	fieldLabel:'����',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:gLocId,
	UserId:gUserId,
	anchor : '90%'
});

var IncDesc = new Ext.form.TextField({
	fieldLabel : '��������',
	id : 'IncDesc',
	name : 'IncDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				//var stkGrp=Ext.getCmp("StkGrpType").getValue();
				var inputText=field.getValue();
				GetPhaOrderInfo(inputText,"");
			}
		}
	}
});

var InciDr = new Ext.form.TextField({
	fieldLabel : '����RowId',
	id : 'InciDr',
	name : 'InciDr',
	anchor : '90%',
	valueNotFoundText : ''
});
var label = new Ext.form.TextField({
	fieldLabel:'����',
	id : 'label',
	anchor : '90%'
});
var originalCode = new Ext.form.TextField({
	fieldLabel:'�Դ�����',
	id : 'originalCode',
	anchor : '90%'
});
var PamNo = new Ext.form.TextField({
	fieldLabel:'�ǼǺ�',
	id : 'PamNo',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e){
			if(e.getKey() == e.ENTER){
				var NewValue = String.leftPad (field.getValue(), 10, '0');
				field.setValue(NewValue);
			}
		}
	}
});	
var Vendor = new Ext.ux.VendorComboBox({
	id : 'Vendor',
	anchor:'90%'
});
var findScrapBT = new Ext.Toolbar.Button({
	text:'ͳ��',
    tooltip:'ͳ��',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		ShowReport();
	}
});

var clearScrapBT = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		ClearData();
	}
});

//==================Events===============//
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
	gInciId = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	Ext.getCmp("IncDesc").setValue(inciDesc);
}

/**
 * ���
 */
function ClearData()
{
	Ext.getCmp("PhaLoc").setValue(gLocId);
	Ext.getCmp("DateFrom").setValue(new Date());
	Ext.getCmp("DateTo").setValue(new Date());
	gInciId = "";
	Ext.getCmp("IncDesc").setValue('');
	Ext.getCmp("StkGrpType").getStore().load();
	document.getElementById("frameReport").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
}

//Tabs����
var QueryTabs = new Ext.TabPanel({
		region: 'center',
		id: 'TblTabPanel',
		margins: '3 3 3 0',
		activeTab: 0,
		items: [{
				title: '���и�ֵ�������',
				id: 'ItmTrackStat',
				frameName: 'ItmTrackStat',
				html: '<iframe id="Statlist" width=100% height=100% src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg" ></iframe>'
			}, {
				title: 'ʹ���������',
				id: 'HvMatStat',
				frameName: 'HvMatStat',
				html: '<iframe id="Statlist" width=100% height=100% src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg" ></iframe>'
			}
		]
	});
/**
  *��ѯ
  */
function ShowReport()
{
	var StartDate=Ext.getCmp("DateFrom").getValue();
	var EndDate=Ext.getCmp("DateTo").getValue();
	var LocId=Ext.getCmp("PhaLoc").getValue();		
	var LocDesc = Ext.getCmp("PhaLoc").getRawValue();
	
	if(StartDate!=""){
		var sd=StartDate.format(DateFormat);
		StartDate = StartDate.format(ARG_DATEFORMAT);
	}
	if(EndDate!=""){
		var ed=EndDate.format(DateFormat);
		EndDate = EndDate.format(ARG_DATEFORMAT);
	}
	var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
	var IncDesc=Ext.getCmp("IncDesc").getValue();
	if(Ext.isEmpty(IncDesc)){
		gInciId = "";
	}
	if(gInciId!=""&gInciId!=null){
		IncDesc="";
	}
	
	var label=Ext.getCmp("label").getValue();
	
	var originalCode = Ext.getCmp("originalCode").getValue();
	var pamno=Ext.getCmp("PamNo").getValue();
	
	var Vendor=Ext.getCmp("Vendor").getValue();
	var Vendordesc=Ext.getCmp("Vendor").getRawValue();
	var p_URL="";
	var panl = Ext.getCmp("TblTabPanel").getActiveTab();
	var iframe = panl.el.dom.getElementsByTagName("iframe")[0];
	var tabId = QueryTabs.getActiveTab().id;
	var Conditions=""
		if(LocId!=""){
			Conditions="����: "+LocDesc;
		}
		if(StartDate!=""){
			Conditions=Conditions+"   ����: "+sd;
		}
		if(EndDate!=""){
			Conditions=Conditions+"~ "+ed;
		}
		if(Vendordesc!=""){
			Conditions=Conditions+"    ��Ӧ��: "+Vendordesc;
		}
	if (tabId=="ItmTrackStat"){
			var others=Vendor+"^"+StartDate+"^"+EndDate+"^"+originalCode+"^"+LocId+"^"+pamno
    p_URL =PmRunQianUrl+'?reportName=DHCSTM_ItmTrackStat.raq&inci='
		    +gInciId+"&label="+label+"&others="+others+"&Conditions="+Conditions;
			iframe.src=p_URL;
	}else if (tabId=="HvMatStat"){
	        var others=Vendor+"^"+StartDate+"^"+EndDate+"^^"+LocId+"^"+pamno+"^"+gInciId+"^"+label+"^"+IncDesc;
		    p_URL =PmRunQianUrl+"?reportName=DHCSTM_HvMatStat.raq&others="+others+"&Conditions="+Conditions;
			iframe.src=p_URL;
	}
}

//=============ҳ��ģ��==========================//
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	
	var formPanel = new Ext.ux.FormPanel({
		title:'��ֵ����ʹ�û���',
		tbar:[findScrapBT,'-',clearScrapBT],
		items:[{
			xtype:'fieldset',
			title:'��ѯ����',
			layout:'column',
			style:'padding:5px 0px 0px 0px',
			defaults:{border:false},
			items:[{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[DateFrom,DateTo]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[PhaLoc,Vendor]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[IncDesc,PamNo]
			},{
				columnWidth:0.25,
				xtype:'fieldset',
				items:[label,originalCode]
			}]
		}]
	});
	var reportPanel=new Ext.Panel({
		region:'center',
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	})
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel, QueryTabs]
	});
});