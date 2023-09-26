// ����: ȫԺ���ת�ƻ���
// ��д�ߣ� zhangxiao
// ��д����: 2018.12.11
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId = session['LOGON.GROUPID'];
	var gLocId = session['LOGON.CTLOCID'];
	var gUserId = session['LOGON.USERID'];
	var gUserName = session['LOGON.USERNAME'];

	ChartInfoAddFun();
	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.ComboBox({
					fieldLabel : '�ⷿ',
					id : 'PhaLoc',
					name : 'PhaLoc',
					store:LocInfoStore,
					anchor : '90%',
					defaultLoc : {}
				});

		var StartDateField = new Ext.ux.DateField({
			fieldLabel: '��ʼ����',
			anchor: '90%',
			id: 'StartDateField',
			invalidText: '��Ч���ڸ�ʽ,��ȷ��ʽ��:��/��/��,��:15/02/2011',
			value: new Date
		});

	var EndDateField = new Ext.ux.DateField({
			fieldLabel: '��ֹ����',
			anchor: '90%',
			id: 'EndDateField',
			value: new Date
		});

	
		// ���һ���
		var FlagLocSum = new Ext.form.Radio({
					boxLabel : '���һ���',
					id : 'FlagLocSum',
					name : 'ReportType',
					checked : true,
					anchor : '90%'
				});
		// ��ѯ��ť
		var SearchBT = new Ext.Toolbar.Button({
					text : '��ѯ',
					tooltip : '�����ѯ',
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						ShowReport();
					}
				});

		function ShowReport() {
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			var stkDate = Ext.getCmp("StartDateField").getValue();
			if (stkDate == null || stkDate.length <= 0) {
				Msg.info("warning", "��ʼ���ڲ���Ϊ�գ�");
				Ext.getCmp("StartDateField").focus();
				return;
			} else {
				stkDate = stkDate.format(ARG_DATEFORMAT);
			}
			var endDate = Ext.getCmp("EndDateField").getValue();
			if (endDate == null || endDate.length <= 0) {
				Msg.info("warning", "��ֹ���ڲ���Ϊ�գ�");
				Ext.getCmp("EndDateField").focus();
				return;
			} else {
				endDate = endDate.format(ARG_DATEFORMAT);
			}
		
			
			//Ч��ʱ��
			var FlagLocSum = Ext.getCmp("FlagLocSum").getValue();
			var reportframe = document.getElementById("reportFrame")
			var p_URL = "";
			 if(FlagLocSum){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_DHCINIsTrfAllStat.raq&startDate='
						+ stkDate+'&endDate='+endDate +'&RowId='+phaLoc ;
			}else{
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_DHCINIsTrfAllStat.raq&startDate='
						+ stkDate+'&endDate='+endDate +'&RowId='+phaLoc ;
			}
			reportframe.src = p_URL;
		}

		// ��հ�ť
		var RefreshBT = new Ext.Toolbar.Button({
					text : '���',
					tooltip : '������',
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * ��շ���
		 */
		function clearData() {
			gStrParam = '';
			gIncId = "";
			clearPanel(HisListTab);
			HisListTab.getForm().setValues({"PhaLoc":"","StartDateField":new Date(),"EndDateField":new Date(),"FlagLocSum":true});
			document.getElementById("reportFrame").src = "../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}

		var HisListTab = new Ext.form.FormPanel({
					labelwidth : 30,
					width : 300,
					labelAlign : 'right',
					frame : true,
					autoScroll : true,
					bodyStyle : 'padding:10px 0px 0px 0px;',
					tbar : [SearchBT, '-', RefreshBT],
					items : [{
								title : '��ѯ����',
								xtype : 'fieldset',
								items : [PhaLoc, StartDateField, EndDateField]
							}, {
								xtype : 'fieldset',
								title : '��������',
								items : [FlagLocSum]
							}]
				});
		var reportPanel = new Ext.Panel({
			layout : 'fit',
			html : '<iframe id="reportFrame" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		})
		
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [{
								region : 'west',
								split : true,
								width : 300,
								minSize : 250,
								maxSize : 350,
								collapsible : true,
								title : 'ȫԺ���ת�ƻ���',
								layout : 'fit',
								items : HisListTab
							}, {
								region : 'center',
								layout : 'fit',
								items : reportPanel
							}],
					renderTo : 'mainPanel'
				});
	}

})