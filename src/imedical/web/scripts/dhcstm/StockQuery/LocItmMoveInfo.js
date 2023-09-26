// /����:��涯����ѯ
// /����: ��涯����ѯ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.08.16
Ext.onReady(function () {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParam = '';
	var gGroupId = session['LOGON.GROUPID'];
	var gUserId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];
	//ͳ�ƿ���
	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel: '����',
			id: 'PhaLoc',
			name: 'PhaLoc',
			anchor: '90%',
			groupId: gGroupId,
			stkGrpId: 'StkGrpType'
		});
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
			fieldLabel: '��ʼ����',
			id: 'StartDate',
			name: 'StartDate',
			anchor: '90%',

			width: 120,
			value: new Date().add(Date.DAY,  - 30)
		});
	var StartTime = new Ext.form.TextField({
			fieldLabel: '��ʼʱ��',
			id: 'StartTime',
			name: 'StartTime',
			anchor: '90%',
			regex: /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
			regexText: 'ʱ���ʽ������ȷ��ʽhh:mm:ss',
			width: 120
		});
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
			fieldLabel: '��ֹ����',
			id: 'EndDate',
			name: 'EndDate',
			anchor: '90%',

			width: 120,
			value: new Date()
		});
	var EndTime = new Ext.form.TextField({
			fieldLabel: '��ֹʱ��',
			id: 'EndTime',
			name: 'EndTime',
			anchor: '90%',
			regex: /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
			regexText: 'ʱ���ʽ������ȷ��ʽhh:mm:ss',
			width: 120
		});
	var StkGrpType = new Ext.ux.StkGrpComboBox({
			id: 'StkGrpType',
			name: 'StkGrpType',
			StkType: App_StkTypeCode, //��ʶ��������
			anchor: '90%',
			UserId: gUserId,
			LocId: gLocId,
			childCombo: 'DHCStkCatGroup'
		});

	var DHCStkCatGroup = new Ext.ux.ComboBox({
			fieldLabel: '������',
			id: 'DHCStkCatGroup',
			name: 'DHCStkCatGroup',
			anchor: '90%',
			width: 140,
			store: StkCatStore,
			valueField: 'RowId',
			displayField: 'Description',
			params: {
				StkGrpId: 'StkGrpType'
			}
		});
	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
			text: '��ѯ',
			tooltip: '�����ѯ',
			iconCls: 'page_find',
			width: 70,
			height: 30,
			handler: function () {
				ShowReport();
			}
		});

	/**
	 * ��ѯ����
	 */
	function searchData() {
		// ��ѡ����
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "���Ҳ���Ϊ�գ�");
			Ext.getCmp("PhaLoc").focus();
			return;
		}
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if (startDate == undefined || startDate.length <= 0) {
			Msg.info("warning", "��ѡ��ʼ����!");
			return;
		}
		if (endDate == undefined || endDate.length <= 0) {
			Msg.info("warning", "��ѡ���ֹ����!");
			return;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		endDate = endDate.format(ARG_DATEFORMAT);
		var startTime = Ext.getCmp("StartTime").getRawValue();
		var endTime = Ext.getCmp("EndTime").getRawValue();
		var stkGrpId = Ext.getCmp("StkGrpType").getValue();
		var stkCatId = Ext.getCmp("DHCStkCatGroup").getValue();

		gStrParam = phaLoc + "^" + startDate + "^" + startTime + "^" + endDate + "^" + endTime
			 + "^" + stkGrpId + "^" + stkCatId;

		StockQtyStore.setBaseParam("Params", gStrParam);
		StockQtyStore.removeAll();
		var pageSize = StatuTabPagingToolbar.pageSize;
		StockQtyStore.load({
			params: {
				start: 0,
				limit: pageSize
			}
		});

	}

	// ��հ�ť
	var RefreshBT = new Ext.Toolbar.Button({
			text: '���',
			tooltip: '������',
			iconCls: 'page_clearscreen',
			width: 70,
			height: 30,
			handler: function () {
				clearData();
			}
		});

	/**
	 * ��շ���
	 */
	function clearData() {
		gStrParam = '';
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,  - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("StartTime").setValue('');
		Ext.getCmp("EndTime").setValue('');
		Ext.getCmp("StkGrpType").setValue('');
		Ext.getCmp("DHCStkCatGroup").setValue('');

		StockQtyGrid.store.removeAll();
		StockQtyGrid.getView().refresh();
	}

	var PrintBT = new Ext.Toolbar.Button({
			text: '��ӡ',
			tooltip: '�����ӡ�������',
			iconCls: 'page_print',
			width: 70,
			height: 30,
			handler: function () {
				PrintStockData();
			}
		});

	function PrintStockData() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "���Ҳ���Ϊ�գ�");
			Ext.getCmp("PhaLoc").focus();
			return;
		}
		var startDate = Ext.getCmp("StartDate").getValue();
		var endDate = Ext.getCmp("EndDate").getValue();
		if (startDate == undefined || startDate.length <= 0) {
			Msg.info("warning", "��ѡ��ʼ����!");
			return;
		}
		if (endDate == undefined || endDate.length <= 0) {
			Msg.info("warning", "��ѡ���ֹ����!");
			return;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		endDate = endDate.format(ARG_DATEFORMAT);
		var startTime = Ext.getCmp("StartTime").getRawValue();
		var endTime = Ext.getCmp("EndTime").getRawValue();
		var stkGrpId = Ext.getCmp("StkGrpType").getValue();
		var stkCatId = Ext.getCmp("DHCStkCatGroup").getValue();
		var ParamStr = "phaLoc="+phaLoc+";startDate="+startDate+";startTime="+startTime+
			";endDate="+endDate+";endTime="+endTime+";stkGrpId="+stkGrpId+";stkCatId="+stkCatId;
		if (ParamStr == '') {
			return;
		}
		var RaqName = 'DHCSTM_LocItmMoveInfo_Common.raq';
		var FileName = '{' + RaqName + '(' + ParamStr + ')}';
		var transfileName = TranslateRQStr(FileName);
		DHCSTM_DHCCPM_RQPrint(transfileName);
	}

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel();
	var StockQtyCm = new Ext.grid.ColumnModel([nm, sm, {
					header: "incil",
					dataIndex: 'incil',
					width: 80,
					align: 'left',
					sortable: true,
					hidden: true
				}, {
					header: '���ʴ���',
					dataIndex: 'code',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: "��������",
					dataIndex: 'desc',
					width: 200,
					align: 'left',
					sortable: true
				}, {
					header: "���",
					dataIndex: 'spec',
					width: 90,
					align: 'left',
					sortable: true
				}, {
					header: "��λ",
					dataIndex: 'pUomDesc',
					width: 80,
					align: 'left',
					sortable: true
				}, {
					header: "�����",
					dataIndex: 'currStkQty',
					width: 100,
					align: 'right',
					sortable: true
				}, {
					header: "������",
					dataIndex: 'OutQty',
					width: 100,
					align: 'right',
					sortable: true
				}, {
					header: "������",
					dataIndex: 'InQty',
					width: 100,
					align: 'right',
					sortable: true
				}, {
					header: "�����",
					dataIndex: 'sumOutAmt',
					width: 60,
					align: 'right',

					sortable: true
				}, {
					header: "�����۽��",
					dataIndex: 'sumOutRpAmt',
					width: 60,
					align: 'right',

					sortable: true
				}, {
					header: "����",
					dataIndex: 'sumInAmt',
					width: 100,
					align: 'right',

					sortable: true
				}, {
					header: "����۽��",
					dataIndex: 'sumInRpAmt',
					width: 100,
					align: 'right',

					sortable: true
				}, {
					header: "����",
					dataIndex: 'manf',
					width: 150,
					align: 'left',
					sortable: true
				}, {
					header: "��λ",
					dataIndex: 'sbDesc',
					width: 150,
					align: 'left',
					sortable: true
				}
			]);
	StockQtyCm.defaultSortable = true;

	// ����·��
	var DspPhaUrl = DictUrl
		 + 'locitmstkaction.csp?actiontype=jsLocItmMoveInfo&start=&limit=';
	// ͨ��AJAX��ʽ���ú�̨����
	var proxy = new Ext.data.HttpProxy({
			url: DspPhaUrl,
			method: "POST"
		});
	// ָ���в���
	var fields = ["incil", "code", "desc", "spec", "manf", "OutQty", "pUomDesc", "sumOutAmt", "sumOutRpAmt",
		"InQty", "sumInAmt", "sumInRpAmt", "sbDesc", "currStkQty"];
	// ֧�ַ�ҳ��ʾ�Ķ�ȡ��ʽ
	var reader = new Ext.data.JsonReader({
			root: 'rows',
			totalProperty: "results",
			id: "incil",
			fields: fields
		});
	// ���ݼ�
	var StockQtyStore = new Ext.data.Store({
			proxy: proxy,
			reader: reader
		});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store: StockQtyStore,
			pageSize: PageSize,
			displayInfo: true,
			displayMsg: '��ǰ��¼ {0} -- {1} �� �� {2} ����¼',
			emptyMsg: "No results to display",
			prevText: "��һҳ",
			nextText: "��һҳ",
			refreshText: "ˢ��",
			lastText: "���ҳ",
			firstText: "��һҳ",
			beforePageText: "��ǰҳ",
			afterPageText: "��{0}ҳ",
			emptyMsg: "û������"
		});

	var StockQtyGrid = new Ext.ux.GridPanel({
			id: 'StockQtyGrid',
			title: '��ϸ',
			layout: 'fit',
			region: 'center',
			cm: StockQtyCm,
			store: StockQtyStore,
			trackMouseOver: true,
			stripeRows: true,
			sm: sm,
			loadMask: true,
			bbar: StatuTabPagingToolbar
		});

	var HisListTab = new Ext.ux.FormPanel({
			title: "��涯����ѯ",
			tbar: [SearchBT, '-', RefreshBT, '-', PrintBT],
			items: [{
					xtype: 'fieldset',
					title: '��ѯ����',
					layout: 'column',
					style: 'padding:5px 0px 0px 5px',
					defaults: {
						border: false,
						columnWidth: 0.33,
						xtype: 'fieldset'
					},
					items: [{
							items: [PhaLoc, StkGrpType, DHCStkCatGroup]
						}, {
							items: [StartDate, StartTime]
						}, {
							items: [EndDate, EndTime]
						}
					]
				}
			]

		});
	//Tabs����
	var QueryTabPanel = new Ext.TabPanel({
			region: 'center',
			id: 'QueryTabPanel',
			margins: '3 3 3 0',
			activeTab: 0,
			items: [{
					title: '������ϸ',
					id: 'StockQtyItmPanel',
					layout:"fit",
					items:StockQtyGrid
				}, {
					title: '��������',
					id: 'LocItmMoveStatPanel',
					layout:"fit",
					html: '<iframe id="LocItmMoveStat" width=100% height=100% src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg" ></iframe>'
				}
			],
			listeners:{
					tabchange:function(tabpanel,panel){
						var p_URL="";
						var panl = Ext.getCmp("QueryTabPanel").getActiveTab();
						var iframe = panl.el.dom.getElementsByTagName("iframe")[0];
						var tabId = QueryTabPanel.getActiveTab().id;
						// ��ѡ����
						var phaLoc = Ext.getCmp("PhaLoc").getValue();
						if (phaLoc == null || phaLoc.length <= 0) {
							Msg.info("warning", "���Ҳ���Ϊ�գ�");
							Ext.getCmp("PhaLoc").focus();
							return;
						}
						var startDate = Ext.getCmp("StartDate").getValue();
						var endDate = Ext.getCmp("EndDate").getValue();
						if (startDate == undefined || startDate.length <= 0) {
							Msg.info("warning", "��ѡ��ʼ����!");
							return;
						}
						if (endDate == undefined || endDate.length <= 0) {
							Msg.info("warning", "��ѡ���ֹ����!");
							return;
						}
						startDate = startDate.format(ARG_DATEFORMAT);
						endDate = endDate.format(ARG_DATEFORMAT);
						var startTime = Ext.getCmp("StartTime").getRawValue();
						var endTime = Ext.getCmp("EndTime").getRawValue();
						var stkGrpId = Ext.getCmp("StkGrpType").getValue();
						var stkCatId = Ext.getCmp("DHCStkCatGroup").getValue();

						var HospDesc=App_LogonHospDesc;
						if (panel.id=="StockQtyItmPanel"){
								searchData();
						}else if (panel.id=="LocItmMoveStatPanel"){
							    p_URL =PmRunQianUrl+"?reportName=DHCSTM_LocItmMoveInfo_Stat.raq&phaLoc="+phaLoc+";HospDesc="+HospDesc
							    +";startDate="+startDate+";startTime="+startTime+";endDate="+endDate+";endTime="+endTime+";stkGrpId="+stkGrpId
							    +";stkCatId="+stkCatId;
							    var ReportFrame=document.getElementById("LocItmMoveStat");
								ReportFrame.src=p_URL;
						}
					}
			}
		});
	/**
	  *��ѯ
	  */
	function ShowReport()
	{
		QueryTabPanel.fireEvent('tabchange',QueryTabPanel,QueryTabPanel.getActiveTab());
	}
	// 5.2.ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [HisListTab, QueryTabPanel],
			renderTo: 'mainPanel'
		});

})
