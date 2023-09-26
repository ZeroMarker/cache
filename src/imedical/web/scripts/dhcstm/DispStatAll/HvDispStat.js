// 名称: 全院库存查询
// 编写者： wangjiabin
// 编写日期: 2014.07.23
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId = session['LOGON.GROUPID'];
	var gLocId = session['LOGON.CTLOCID'];
	var gUserId = session['LOGON.USERID'];
	var gUserName = session['LOGON.USERNAME'];

	ChartInfoAddFun();
	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '科室',
					id : 'PhaLoc',
					name : 'PhaLoc',
					anchor : '90%',
					defaultLoc : {}
				});

		var StartDateField = new Ext.ux.DateField({
			fieldLabel: '开始日期',
			anchor: '90%',
			id: 'StartDateField',
			invalidText: '无效日期格式,正确格式是:日/月/年,如:15/02/2011',
			value: new Date
		});

	var EndDateField = new Ext.ux.DateField({
			fieldLabel: '截止日期',
			anchor: '90%',
			id: 'EndDateField',
			value: new Date
		});

		// 批次明细
		var FlagHvList = new Ext.form.Radio({
					boxLabel : '高值明细',
					id : 'FlagHvList',
					name : 'ReportType',
					anchor : '90%',
					checked : true
				});

		// 单品汇总
		var FlagHvStat = new Ext.form.Radio({
					boxLabel : '高值汇总',
					id : 'FlagHvStat',
					name : 'ReportType',
					anchor : '90%'
				});
		// 科室汇总
		var FlagLocSum = new Ext.form.Radio({
					boxLabel : '科室汇总',
					id : 'FlagLocSum',
					name : 'ReportType',
					anchor : '90%'
				});
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : '查询',
					tooltip : '点击查询',
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
				Msg.info("warning", "开始日期不能为空！");
				Ext.getCmp("StartDateField").focus();
				return;
			} else {
				stkDate = stkDate.format(ARG_DATEFORMAT);
			}
			var endDate = Ext.getCmp("EndDateField").getValue();
			if (endDate == null || endDate.length <= 0) {
				Msg.info("warning", "截止日期不能为空！");
				Ext.getCmp("EndDateField").focus();
				return;
			} else {
				endDate = endDate.format(ARG_DATEFORMAT);
			}
		
			
			//效期时间
			var strParam = phaLoc + "^" + stkDate + "^" + endDate 
			strParam = strParam.replace(/\^/g,',');
			var FlagHvList = Ext.getCmp("FlagHvList").getValue();
			var FlagHvStat = Ext.getCmp("FlagHvStat").getValue();
			var FlagLocSum = Ext.getCmp("FlagLocSum").getValue();
			var reportframe = document.getElementById("reportFrame")
			var p_URL = "";
			if(FlagHvList){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HvDispDetial.raq&StrParam='
						+ strParam;
			}else if(FlagHvStat){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HvDispStat.raq&StrParam='
						+ strParam ;
			}else if(FlagLocSum){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HvDispLocSum.raq&StrParam='
						+ strParam ;
			}else{
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_HvDispDetial.raq&StrParam='
						+ strParam;
			}
			reportframe.src = p_URL;
		}

		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * 清空方法
		 */
		function clearData() {
			gStrParam = '';
			gIncId = "";
			clearPanel(HisListTab);
			HisListTab.getForm().setValues({"PhaLoc":"","StartDateField":new Date(),"EndDateField":new Date(),"FlagHvList":true});
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
								title : '查询条件',
								xtype : 'fieldset',
								items : [PhaLoc, StartDateField, EndDateField]
							}, {
								xtype : 'fieldset',
								title : '报表类型',
								items : [FlagHvList, FlagHvStat, FlagLocSum]
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
								title : '高值消耗汇总',
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