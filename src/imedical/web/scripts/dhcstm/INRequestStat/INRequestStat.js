//==================�������ͳ��===================//
var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var gInciId = "";

var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel: '<font color=blue>��������</font>',
		id: 'PhaLoc',
		name: 'PhaLoc',
		anchor: '90%',
		emptyText: '����...',
		groupId: gGroupId,
		stkGrpId: 'StkGrpType'
	});

var DateFrom = new Ext.ux.DateField({
		fieldLabel: '<font color=blue>��ʼ����</font>',
		id: 'DateFrom',
		name: 'DateFrom',
		anchor: '90%',
		value: new Date()
	});

var DateTo = new Ext.ux.DateField({
		fieldLabel: '<font color=blue>��ֹ����</font>',
		id: 'DateTo',
		name: 'DateTo',
		anchor: '90%',
		value: new Date()
	});

// ��������
var StkGrpField = new Ext.ux.StkGrpComboBox({
		id: 'StkGrpType',
		fieldLabel: '����',
		StkType: App_StkTypeCode, //��ʶ��������
		LocId: gLocId,
		UserId: gUserId,
		anchor: '90%'
	});

var IncDesc = new Ext.form.TextField({
		fieldLabel: '��������',
		id: 'IncDesc',
		name: 'IncDesc',
		anchor: '90%',
		listeners: {
			specialkey: function (field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stkGrp = Ext.getCmp("StkGrpType").getValue();
					var inputText = field.getValue();
					GetPhaOrderInfo(inputText, stkGrp);
				}
			}
		}
	});

var InciDr = new Ext.form.TextField({
		fieldLabel: '����RowId',
		id: 'InciDr',
		name: 'InciDr',
		anchor: '90%',
		valueNotFoundText: ''
	});

var findScrapBT = new Ext.Toolbar.Button({
		text: 'ͳ��',
		tooltip: 'ͳ��',
		iconCls: 'page_find',
		width: 70,
		height: 30,
		handler: function () {
			ShowReport();
		}
	});

var clearScrapBT = new Ext.Toolbar.Button({
		text: '���',
		tooltip: '���',
		iconCls: 'page_clearscreen',
		width: 70,
		height: 30,
		handler: function () {
			ClearData();
		}
	});

var formPanel = new Ext.form.FormPanel({
		labelwidth: 30,
		labelAlign: 'right',
		autoScroll: true,
		autoHeight: true,
		frame: true,
		bodyStyle: 'padding:5px;',
		tbar: [findScrapBT, '-', clearScrapBT],
		items: [{
				xtype: 'fieldset',
				title: '��ѯ����',
				layout: 'column',
				style: 'padding:5px 0px 0px 0px',
				defaults: {
					border: false
				},
				items: [{
						columnWidth: 0.25,
						xtype: 'fieldset',
						defaults: {
							width: 200
						},
						items: [DateFrom, DateTo]
					}, {
						columnWidth: 0.25,
						xtype: 'fieldset',
						defaults: {
							width: 120
						},
						items: [PhaLoc, StkGrpField]
					}, {
						columnWidth: 0.25,
						xtype: 'fieldset',
						defaults: {
							width: 120
						},
						items: [IncDesc]
					}
				]
			}
		]
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
	var inciCode = record.get("InciCode");
	var inciDesc = record.get("InciDesc");
	Ext.getCmp("IncDesc").setValue(inciDesc);
}

/**
 * ���
 */
function ClearData() {
	Ext.getCmp("PhaLoc").setValue(gLocId);
	Ext.getCmp("DateFrom").setValue(new Date());
	Ext.getCmp("DateTo").setValue(new Date());
	gInciId = "";
	Ext.getCmp("IncDesc").setValue('');
	Ext.getCmp("StkGrpType").getStore().load();
	document.getElementById("frameReport").src = "../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
	document.getElementById("frameReportInrequestStatLoc").src = "../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
}

/**
 *��ѯ
 */
function ShowReport() {
	var StartDate = Ext.getCmp("DateFrom").getValue();
	var EndDate = Ext.getCmp("DateTo").getValue();
	var LocId = Ext.getCmp("PhaLoc").getValue();
	var LocDesc = Ext.getCmp("PhaLoc").getRawValue();
	if (LocId == null || LocId == "") {
		Msg.info("warning", "���Ҳ���Ϊ��!");
		return;
	}
	if (StartDate != "") {
		StartDate = StartDate.format(DateFormat).toString();
	} else {
		Msg.info("warning", "��ʼ���ڲ���Ϊ��!");
		return;
	}
	if (EndDate != "") {
		EndDate = EndDate.format(DateFormat).toString();
	} else {
		Msg.info("warning", "��ֹ���ڲ���Ϊ��!");
		return;
	}
	var GrpType = Ext.getCmp("StkGrpType").getValue(); //����id
	var IncDesc = Ext.getCmp("IncDesc").getValue();
	if (Ext.isEmpty(IncDesc)) {
		gInciId = "";
	}
	if (gInciId != "" & gInciId != null) {
		IncDesc = "";
	}
	var panel = Ext.getCmp("reportPanel").getActiveTab();
	var p_URL = "";
	if (panel.id == "ReportInrequestStatDetail") {
		var reportFrame = document.getElementById("frameReport");
		p_URL = PmRunQianUrl + '?reportName=DHCSTM_INRequestStat.raq&StartDate='
			+StartDate + "&EndDate=" + EndDate + "&Loc=" + LocId + "&ItmDr=" + gInciId
			 + "&StkGrpType=" + GrpType + "&LocDesc=" + LocDesc + "&ItmDesc=" + IncDesc;
		reportFrame.src = p_URL;
	} else if (panel.id == "ReportInrequestStatLoc") {
		var reportFrame = document.getElementById("frameReportInrequestStatLoc");
		p_URL = PmRunQianUrl + '?reportName=DHCSTM_INRequestStatLoc.raq&StartDate='
			+StartDate + "&EndDate=" + EndDate + "&Loc=" + LocId + "&ItmDr=" + gInciId
			 + "&StkGrpType=" + GrpType + "&LocDesc=" + LocDesc + "&ItmDesc=" + IncDesc;
		reportFrame.src = p_URL;
	}
}

//=============ҳ��ģ��==========================//
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var formPanel = new Ext.ux.FormPanel({
			title: '�������ͳ��',
			tbar: [findScrapBT, '-', clearScrapBT],
			items: [{
					xtype: 'fieldset',
					title: '��ѯ����',
					layout: 'column',
					style: 'padding:5px 0px 0px 5px',
					defaults: {
						border: false,
						xtype: 'fieldset'
					},
					items: [{
							columnWidth: 0.33,
							items: [DateFrom, DateTo]
						}, {
							columnWidth: 0.33,
							items: [PhaLoc, StkGrpField]
						}, {
							columnWidth: 0.33,
							items: [IncDesc]
						}
					]
				}
			]
		});

	var reportPanel = new Ext.TabPanel({
			region: 'center',
			id: 'reportPanel',
			activeTab: 0,
			items: [{
					title: '������ϸ',
					id: 'ReportInrequestStatDetail',
					html: '<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
				}, {
					title: '����������ϸ',
					id: 'ReportInrequestStatLoc',
					html: '<iframe id="frameReportInrequestStatLoc" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
				}
			]
		});

	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [formPanel, reportPanel]
		});

	reportPanel.addListener('tabchange', function (tabpanel, panel) {
		ShowReport();
	});
});
