///名称:年度统计报表
///描述:年度统计报表
///编写者:wangjiabin
///编写日期:2014-05-05
Ext.onReady(function () {

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId = session['LOGON.GROUPID'];
	var gLocId = session['LOGON.CTLOCID'];
	var gUserId = session['LOGON.USERID'];

	var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel: '科室',
			id: 'PhaLoc',
			name: 'PhaLoc',
			anchor: '90%',
			emptyText: '科室...',
			groupId: gGroupId
		});

	var YearNum = new Ext.form.TextField({
			fieldLabel: '年份',
			id: 'YearNum',
			anchor: '90%',
			allowBlank: false,
			value: new Date().getFullYear(),
			regex: /^2\d{3}$/,
			regexText: '请输入正确的年份格式!'
		});

	var StMonth = new Ext.form.TextField({
			fieldLabel: '月份',
			id: 'StMonth',
			name: 'StMonth',
			anchor: '90%',
			width : '78',
			value: ((new Date().getMonth() - 10) <= 0 ? 1 : (new Date().getMonth() - 10))
		});

	var EdMonth = new Ext.form.TextField({
			fieldLabel: '',
			id: 'EdMonth',
			name: 'EdMonth',
			anchor: '90%',
			width : '78',
			value: (new Date().getMonth() + 1)
		});

	var ScgCatStat = new Ext.form.Radio({
			boxLabel: '类组分类汇总',
			id: 'ScgCatStat',
			name: 'ReportType',
			anchor: '80%',
			checked: true
		});

	var OutLocStat = new Ext.form.Radio({
			boxLabel: '出库汇总(按科室)',
			id: 'OutLocStat',
			name: 'ReportType',
			anchor: '80%',
			checked: false
		});

	var ClearBT = new Ext.Toolbar.Button({
			id: "ClearBT",
			text: '清空',
			tooltip: '点击清空',
			width: 70,
			height: 30,
			iconCls: 'page_clearscreen',
			handler: function () {
				SetLogInDept(PhaLoc.getStore(), 'PhaLoc');
				document.getElementById("frameReport").src = "../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
			}
		});

	// 确定按钮
	var OkBT = new Ext.Toolbar.Button({
			id: "OkBT",
			text: '统计',
			tooltip: '点击统计',
			width: 70,
			iconCls: 'page_find',
			height: 30,
			handler: function () {
				ShowReport();
			}
		});

	function ShowReport() {
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();
		if (PhaLoc == "") {
			Msg.info("warning", "科室不可为空!");
			return;
		}
		var YearNum = Ext.getCmp("YearNum").getValue();
		if (YearNum == "") {
			Msg.info("warning", "请选择年份!");
			return;
		}
		var StMonth = Ext.getCmp("StMonth").getValue();
		if (StMonth == "") {
			Msg.info("warning", "请选择月份范围!");
			return;
		}
		var EdMonth = Ext.getCmp("EdMonth").getValue();
		if (EdMonth == "") {
			Msg.info("warning", "请选择月份范围!");
			return;
		}
		var reportFrame = document.getElementById("frameReport");
		var ScgCatStatFlag = Ext.getCmp("ScgCatStat").getValue();
		var OutLocStatFlag = Ext.getCmp("OutLocStat").getValue();
		if (ScgCatStatFlag) {
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_YearStatByMonCatRep.raq'
				 + '&PhaLoc=' + PhaLoc + '&Year=' + YearNum + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		} else if (OutLocStatFlag) {
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_YearStatTKByMonCatRep_Loc.raq'
				 + '&PhaLoc=' + PhaLoc + '&Year=' + YearNum + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		} else {
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_YearStatByMonCatRep.raq'
				 + '&PhaLoc=' + PhaLoc + '&Year=' + YearNum + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		}
		reportFrame.src = p_URL;
	}

	var HisListTab = new Ext.form.FormPanel({
			id: 'HisListTab',
			labelWidth: 60,
			labelAlign: 'right',
			frame: true,
			autoScroll: true,
			bodyStyle: 'padding:5,0,5,0',
			tbar: [OkBT, '-', ClearBT],
			items: [{
					xtype: 'fieldset',
					title: '查询条件',
					items: [PhaLoc, YearNum, {
							xtype: 'compositefield',
							fieldLabel: '月份范围',
							items: [StMonth, {
									xtype: 'displayfield',
									value: '-'
								}, EdMonth]
						}
					]
				}, {
					xtype: 'fieldset',
					title: '报表类型',
					items: [ScgCatStat, OutLocStat]
				}
			]
		});

	var reportPanel = new Ext.Panel({
			autoScroll: true,
			layout: 'fit',
			html: '<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
		});

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
			layout: 'border',
			items: [{
					region: 'west',
					title: "年度统计",
					width: 300,
					split: true,
					collapsible: true,
					minSize: 260,
					maxSize: 350,
					layout: 'fit',
					items: HisListTab
				}, {
					region: 'center',
					layout: 'fit',
					items: reportPanel
				}
			]
		});

});
