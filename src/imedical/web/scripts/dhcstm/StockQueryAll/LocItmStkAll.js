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

		var DateTime = new Ext.ux.DateField({
					fieldLabel : '日期',
					id : 'DateTime',
					name : 'DateTime',
					anchor : '90%',
					
					value : new Date()
				});

		var StkGrpType = new Ext.ux.StkGrpComboBox({
					id : 'StkGrpType',
					name : 'StkGrpType',
					StkType : App_StkTypeCode, // 标识类组类型
					anchor : '90%',
					LocId : gLocId,
					UserId : gUserId
				});
		StkGrpType.on('change', function() {
					Ext.getCmp("DHCStkCatGroup").setValue('');
				});
		var DHCStkCatGroup = new Ext.ux.ComboBox({
					fieldLabel : '库存分类',
					id : 'DHCStkCatGroup',
					name : 'DHCStkCatGroup',
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params : {
						StkGrpId : 'StkGrpType'
					}
				});
		var TypeStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['0', '全部'], ['1', '库存为零'], ['2', '库存为正'],
							['3', '库存为负']]
				});
		var Type = new Ext.form.ComboBox({
					fieldLabel : '类型',
					id : 'Type',
					name : 'Type',
					anchor : '90%',
					store : TypeStore,
					triggerAction : 'all',
					mode : 'local',
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					editable : false,
					valueNotFoundText : ''
				});
		Ext.getCmp("Type").setValue("0");

		var InciDesc = new Ext.form.TextField({
					fieldLabel : '物资名称',
					id : 'InciDesc',
					name : 'InciDesc',
					anchor : '90%',
					width : 140,
					listeners : {
						specialkey : function(field, e) {
							var keyCode = e.getKey();
							if (keyCode == Ext.EventObject.ENTER) {
								var stkgrp = Ext.getCmp("StkGrpType").getValue();
								GetPhaOrderInfo(field.getValue(), stkgrp);
							}
						}
					}
				});

		/**
		 * 调用物资窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "", "0",
						"", getDrugList);
			}
		}

		/**
		 * 返回方法
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			gIncId = record.get("InciDr");
			var inciCode = record.get("InciCode");
			var inciDesc = record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(inciDesc);
		}

		var ImportStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['国产', '国产'], ['进口', '进口'], ['合资', '合资']]
				});
		var INFOImportFlag = new Ext.form.ComboBox({
					fieldLabel : '进口标志',
					id : 'INFOImportFlag',
					name : 'INFOImportFlag',
					anchor : '90%',
					store : ImportStore,
					valueField : 'RowId',
					displayField : 'Description',
					mode : 'local',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					listWidth : 150,
					forceSelection : true
				});

		var ARCItemCat = new Ext.ux.ComboBox({
					fieldLabel : '医嘱子类',
					id : 'ARCItemCat',
					name : 'ARCItemCat',
					store : ArcItemCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName : 'Desc'
				});

		var PhManufacturer = new Ext.ux.ComboBox({
					fieldLabel : '厂商',
					id : 'PhManufacturer',
					name : 'PhManufacturer',
					store : PhManufacturerStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName : 'PHMNFName',
					filterName : {ScgId : 'StkGrpType'}		//此界面不适合使用LocId?
				});
		//供应商		
		var Vendor=new Ext.ux.VendorComboBox({
					id : 'Vendor',
					name : 'Vendor',
					anchor : '90%',
					params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'}
				});	
		var PHCDOfficialType = new Ext.ux.ComboBox({
					fieldLabel : '医保类别',
					id : 'PHCDOfficialType',
					name : 'PHCDOfficialType',
					store : OfficeCodeStore,
					valueField : 'RowId',
					displayField : 'Description'
				});

		var ExcludeWarehouse = new Ext.form.Checkbox({
					boxLabel : '排除库房',
					id : 'ExcludeWarehouse',
					name : 'ExcludeWarehouse',
					anchor : '90%',
					checked : true
				});

		var UseFlag = new Ext.form.Checkbox({
					boxLabel : '仅在用品种',
					id : 'UseFlag',
					name : 'UseFlag',
					anchor : '90%',
					checked : false
				});

		var NotUseFlag = new Ext.form.Checkbox({
					boxLabel : '仅不可用品种',
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					anchor : '90%',
					checked : false
				});
		
		var HVFlag = new Ext.form.RadioGroup({
			id:'HVFlag',
			columns:3,
			anchor : '90%',
			items:[
				{boxLabel:'全部',name:'HVFlag',id:'HVFlag_All',inputValue:'',checked:true},
				{boxLabel:'高值',name:'HVFlag',id:'HVFlag_Yes',inputValue:'Y'},
				{boxLabel:'非高值',name:'HVFlag',id:'HVFlag_No',inputValue:'N'}
			]
		});
		
		var ManageFlag = new Ext.form.RadioGroup({
			id : 'ManageFlag',
			items : [
				{boxLabel:'全部',name:'ManageFlag',id:'ManageFlag_All',inputValue:'',checked:true},
				{boxLabel:'重点关注',name:'ManageFlag',id:'ManageFlag_Yes',inputValue:'Y'},
				{boxLabel:'非重点',name:'ManageFlag',id:'ManageFlag_No',inputValue:'N'}
			]
		});
		
		// 批次明细
		var FlagInclb = new Ext.form.Radio({
					boxLabel : '批次明细',
					id : 'FlagInclb',
					name : 'ReportType',
					anchor : '90%',
					checked : true
				});

		// 单品汇总
		var FlagInci = new Ext.form.Radio({
					boxLabel : '单品汇总',
					id : 'FlagInci',
					name : 'ReportType',
					anchor : '90%'
				});

		// 单品科室汇总
		var FlagIncil = new Ext.form.Radio({
					boxLabel : '单品科室汇总',
					id : 'FlagIncil',
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
		
		//科室单品汇总
		var FlagLocInciSum = new Ext.form.Radio({
					boxLabel : '科室单品汇总',
					id : 'FlagLocInciSum',
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
			var stkDate = Ext.getCmp("DateTime").getValue();
			if (stkDate == null || stkDate.length <= 0) {
				Msg.info("warning", "日期不能为空！");
				Ext.getCmp("DateTime").focus();
				return;
			} else {
				stkDate = stkDate.format(ARG_DATEFORMAT);
			}
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var StockType = Ext.getCmp("Type").getValue();
			if (StockType == null || StockType.length <= 0) {
				Msg.info("warning", "类型不能为空！");
				Ext.getCmp("Type").focus();
				return;
			}
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var ARCItemCat = Ext.getCmp("ARCItemCat").getValue();
			var PhManufacturer = Ext.getCmp("PhManufacturer").getValue();
			var PHCDOfficialType = Ext.getCmp("PHCDOfficialType").getValue();
			var ExcludeWarehouse = Ext.getCmp("ExcludeWarehouse").getValue() ? 'Y' : 'N';
			var UseFlag = (Ext.getCmp("UseFlag").getValue() == true ? 'Y' : 'N');
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue() == true ? 'Y' : 'N');
			var ImpFlag = Ext.getCmp("INFOImportFlag").getValue();
			var InciDesc = Ext.getCmp("InciDesc").getValue();
			if (InciDesc == null || InciDesc == "") {
				gIncId = "";
			}
			if(gIncId!=""&gIncId!=null){
				InciDesc="";
			}
			var Vendor = Ext.getCmp("Vendor").getValue();
			var HVFlag = Ext.getCmp("HVFlag").getValue().getGroupValue();
			var ManageFlag = Ext.getCmp("ManageFlag").getValue().getGroupValue();		//重点关注标记
			var strParam = phaLoc + "^" + stkDate + "^" + StockType + "^" + gIncId + "^" + StkGrpRowId
					+ "^" + DHCStkCatGroup + "^" + ImpFlag + "^" + ARCItemCat + "^" + PhManufacturer + "^" + PHCDOfficialType
					+ "^" + ExcludeWarehouse + "^" + UseFlag + "^" + NotUseFlag+"^"+Vendor + "^" + InciDesc
					+ "^" + HVFlag + "^" + ManageFlag + "^" + gLocId;
			
			var FlagInclb = Ext.getCmp("FlagInclb").getValue();
			var FlagInci = Ext.getCmp("FlagInci").getValue();
			var FlagIncil = Ext.getCmp("FlagIncil").getValue();
			var FlagLocSum = Ext.getCmp("FlagLocSum").getValue();
			var FlagLocInciSum = Ext.getCmp("FlagLocInciSum").getValue();
			var reportframe = document.getElementById("reportFrame")
			var p_URL = "";
			if(FlagInclb){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_LocItmStkAll_Inclb.raq&StrParam='
						+ strParam + '&UserName=' + gUserName + '&stkDate=' + stkDate;
			}else if(FlagInci){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_LocItmStkAll_Inci.raq&StrParam='
						+ strParam + '&UserName=' + gUserName+ '&stkDate=' + stkDate;
			}else if(FlagIncil){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_LocItmStkAll_Incil.raq&StrParam='
						+ strParam + '&UserName=' + gUserName + '&stkDate=' + stkDate;
			}else if(FlagLocSum){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_LocItmStkAll_LocSum.raq&StrParam='
						+ strParam + '&UserName=' + gUserName + '&stkDate=' + stkDate;
			}else if(FlagLocInciSum){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_LocItmStkAll_LocInciSum.raq&StrParam='
						+ strParam + '&UserName=' + gUserName + '&stkDate=' + stkDate;
			}else{
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_LocItmStkAll_Inci.raq&StrParam='
						+ strParam + '&UserName=' + gUserName+ '&stkDate=' + stkDate;
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
			HisListTab.getForm().setValues({"PhaLoc":"","DateTime":new Date(),"FlagInclb":true});
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
								items : [PhaLoc, DateTime, Type, StkGrpType, DHCStkCatGroup,
									InciDesc, INFOImportFlag, ARCItemCat, Vendor, PhManufacturer, PHCDOfficialType,
									ExcludeWarehouse, UseFlag, NotUseFlag, HVFlag, ManageFlag]
							}, {
								xtype : 'fieldset',
								title : '报表类型',
								items : [FlagInclb, FlagInci, FlagIncil, FlagLocSum, FlagLocInciSum]
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
								title : '全院库存查询',
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