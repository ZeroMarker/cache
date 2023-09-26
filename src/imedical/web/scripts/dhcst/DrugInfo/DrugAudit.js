//功能：三大项审核
//描述：三大项审核
//作者：赵志端
//日期:2014-11-24
var Url = 'dhcst.drugauditaction.csp';
var inciDr = "";
Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];
	var HospId = session['LOGON.HOSPID'];
	var gGroupId = session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL; 
	//==========函数==========================
	/**
		 * 调用药品窗体并返回结果
		 */
	function GetPhaOrderInfo(item, stktype) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "", getDrugList);
		}
	}
	/**
		 * 返回方法
		 */
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		inciDr = record.get("InciDr"); 
		var InciDesc = record.get("InciDesc");
		Ext.getCmp("M_InciDesc").setValue(InciDesc);
	} 
	// 起始日期
	var StartDate = new Ext.ux.DateField({
		fieldLabel: '起始日期',
		id: 'StartDate',
		name: 'StartDate',
		anchor: '90%',
		width: 80,
		value: new Date
	}); 
	// 截止日期
	var EndDate = new Ext.ux.DateField({
		fieldLabel: '截止日期',
		id: 'EndDate',
		name: 'EndDate',
		anchor: '90%',
		width: 80,
		value: new Date
	});
	 // 药品类组
	var M_StkGrpType = new Ext.ux.StkGrpComboBox({
		fieldLabel : '类　　组', 
		id: 'M_StkGrpType',
		name: 'M_StkGrpType',
		StkType: App_StkTypeCode,
		//标识类组类型
		anchor: '90%',
		//LocId: gLocId,
		UserId: gUserId
	}); 
	// 药品名称
	var M_InciDesc = new Ext.form.TextField({
		fieldLabel: '药品名称',
		id: 'M_InciDesc',
		name: 'M_InciDesc',
		anchor: '90%',
		width: 150,
		listeners: {
			specialkey: function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = Ext.getCmp("M_StkGrpType").getValue();
					GetPhaOrderInfo(field.getValue(), stktype);
				}
			}
		}
	}); 
	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
		id: "SearchBT",
		text: '查询',
		tooltip: '点击查询',
		width: 70,
		height: 30,
		iconCls: 'page_find',
		handler: function() {
			Query();
		}
	}); 
	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
		id: 'ClearBT',
		text: '清屏',
		tooltip: '点击清屏',
		width: 70,
		height: 30,
		iconCls: 'page_clearscreen',
		handler: function() {
			clearData();
		}
	}); 
	// 审核确认按钮
	var AuditBT = new Ext.Toolbar.Button({
		id: 'AuditBT',
		text: '审核确认',
		tooltip: '点击审核确认',
		width: 70,
		height: 30,
		iconCls: 'page_gear',
		//disabled : true,
		handler: function() {
			Audit("Y");
		}
	});
	var RefuseBT = new Ext.Toolbar.Button({
		id: 'RefuseBT',
		text: '审核不通过',
		tooltip: '审核不通过',
		width: 70,
		height: 30,
		iconCls: 'page_gear',
		//disabled : true,
		//hidden:true,
		handler: function() {
			Audit("N");
		}
	});
	 // 完成标志
	var QuditAuditFlag = new Ext.form.Checkbox({
		boxLabel: '查询审核记录',
		id: 'QuditAuditFlag',
		name: 'QuditAuditFlag',
		anchor: '90%',
		checked: false,
		handler: function() {
			changeButEnable();
			Query()
		}
	});
	function changeButEnable() {
		var flag = Ext.getCmp("QuditAuditFlag").getValue(); 
		if (flag == true) {
			RefuseBT.setDisabled(true);
			AuditBT.setDisabled(true);
		} else {
			RefuseBT.setDisabled(false);
			AuditBT.setDisabled(false);
		}
	}
	function Query() {
		var StartDate = Ext.getCmp("StartDate").getValue().format('Y-m-d').toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format('Y-m-d').toString();
		var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
		var inciDesc = Ext.getCmp("M_InciDesc").getValue();
		if (inciDesc == null || inciDesc == "") {
			inciDr = "";
		} 
		stktype = "G"
		var queryflag = (Ext.getCmp("QuditAuditFlag").getValue() == true ? 'Y': 'N');
		var other = stktype + "^" + gUserId + "^" + queryflag + "^" + inciDesc;
		PHCDrgFormGrid.store.removeAll();
		PHCDrgFormStore.load({
			params: {
				Start: 0,
				Limit: 999,
				StDate: StartDate,
				EndDate: EndDate,
				Grp: StkGrpType,
				inci: inciDr,
				Other: other
			},
			callback : function(o,response,success) { 
				if (success == false){  
					Ext.MessageBox.alert("查询错误",PHCDrgFormStore.reader.jsonData.Error);  
				}
			}
		});
	}
	function clearData() {
		inciDr=""		
		M_InciDesc.setValue("");
		M_StkGrpType.setValue("");
		Ext.getCmp("StartDate").setValue(new Date());
		Ext.getCmp("EndDate").setValue(new Date());
		PHCDrgFormGrid.store.removeAll();
		Ext.getCmp("QuditAuditFlag").setValue("N");
		Ext.getCmp("AuditFlag").setValue("N");
	}
	function Audit(flag) {
		var activeTab = tabPanel.getActiveTab();
		var incistr = ""
		if (activeTab.id == "DrgForm") {
			var rowCount = PHCDrgFormGrid.getStore().getCount();
			var selectRows = PHCDrgFormGrid.getSelectionModel().getSelections();
			if (selectRows.length == 0) {
				Msg.info("warning", "没有需要审核的药品信息！");
				return;
			}
			if (rowCount == 0) {
				Msg.info("warning", "没有需要审核的药品信息！");
				return;
			} 
			for (var i = 0; i < selectRows.length; i++) { 
				var rowData = selectRows[i];
				var inci = rowData.get("tmpinci");
				var rowid = rowData.get("Rowid");
				if (incistr == "") {
					incistr = inci + "^" + rowid;
				} else {
					incistr = incistr + "@" + inci + "^" + rowid;
				}
			}
		}
		var url = Url + '?actiontype=DrugAudit';
		var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
		Ext.Ajax.request({
			url: url,
			method: 'POST',
			params: {
				InciStr: incistr,
				User: gUserId,
				Flag: flag
			},
			waitMsg: '处理中...',
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info('success','审核成功！');
					Query()
				}
				else{
					if (jsonData.info=="-1001")
					{
						Msg.info("warning", "尚未维护审核级别权限,请在库房管理模块维护!");
						return false;
					}
					else if (jsonData.info=="-1002")
					{
						Msg.info("warning", "该用户无审核权限,请在库房管理模块维护!");
						return false;
					}
					else if (jsonData.info=="-1000")
					{
						Msg.info("warning", "获取不到用户,请重新登录后重试!");
						return false;
					}	
					else if (jsonData.info=="-1003")
					{
						Msg.info("warning", "已经审核!");
						return false;
					}
					else if (jsonData.info=="-1005")
					{
						Msg.info("warning", "该用户权限为未启用状态!");
						return false;
					}
					else
					{
						Msg.info("error", jsonData.info);
						return false;
					}	
				}
			},
			scope: this
		});
		loadMask.hide();
	}
	var PHCDrgFormStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url: Url + '?actiontype=QueryPHCDrgForm&Start=0&Limit=999',
		totalProperty: 'results',
		root: 'rows',
		fields: ["tmpinci", "phcd", "Name","AuditUser","AuditDate","AuditTime", "Date", "Time", "ChangeType", "Code", "Desc", "SubCat", "MinorSubCat", "Generic", "ManfDesc", "Offcode", "Ctuom", "Form", "Freq", "Instr", "Poison", "Own", "Priority", "BillSubCat", "OeMsg", "BillCtuom", "EFfDate", "EFfDateTo", "ItemCat", "Buom", "Puruom", "StkCatDesc", "Spec", "Rowid", "AuditFlag", "NoUseFlag"]
	});
	var sm = new Ext.grid.CheckboxSelectionModel({
		singleSelect: false,
		listeners:{'rowselect': function(sm, rowIndex,record ) {    
            var selectedRow = PHCDrgFormStore.data.items[rowIndex];
		    var auditrowid = selectedRow.data['Rowid'];
		    var count = PHCDrgFormGrid.getStore().getTotalCount();
			for (var i = 0; i < count; i++) { 
				var rowData = PHCDrgFormGrid.getStore().getAt(i);
				var rowid = rowData.get("Rowid");
				if(auditrowid==rowid){
					PHCDrgFormGrid.getSelectionModel().selectRow(i,true);;
			    }
			}            
        },'rowdeselect':function(sm, rowIndex,record ) {  
            var deselectedRow = PHCDrgFormStore.data.items[rowIndex];
		    var auditrowid = deselectedRow.data['Rowid'];
		    var count = PHCDrgFormGrid.getStore().getTotalCount();
			for (var i = 0; i < count; i++) { 
				var rowData = PHCDrgFormGrid.getStore().getAt(i);
				var rowid = rowData.get("Rowid");
				if(auditrowid==rowid){
					if(sm.isSelected(i)==true){
					   PHCDrgFormGrid.getSelectionModel().deselectRow(i);
					}
			    }
			}           
        }
	    }
	});
	var nm = new Ext.grid.RowNumberer();
	var PHCDrgFormCm = new Ext.grid.ColumnModel([nm, sm, {
		header: "tmpinci",
		dataIndex: 'tmpinci',
		width: 100,
		align: 'left',
		sortable: true,
		hidden: true
	},
	{
		header: "Rowid",
		dataIndex: 'Rowid',
		width: 100,
		align: 'left',
		sortable: true,
		hidden: true
	},
	{
		header: "phcd",
		dataIndex: 'phcd',
		width: 100,
		align: 'left',
		sortable: true,
		hidden: true
	},
	{
		header: "审核状态",
		dataIndex: 'AuditFlag',
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: "审核人",
		dataIndex: 'AuditUser',
		width: 75,
		align: 'left',
		sortable: true
	},
	{
		header: "最后审核日期",
		dataIndex: 'AuditDate',
		width: 90,
		align: 'center',
		sortable: true
	},
	{
		header: "最后审核时间",
		dataIndex: 'AuditTime',
		width: 90,
		align: 'center',
		sortable: true
	},
	{
		header: '修改人',
		dataIndex: 'Name',
		width: 75,
		align: 'left',
		sortable: true,
		renderer: cellMerge
	},
	{
		header: "修改日期",
		dataIndex: 'Date',
		width: 80,
		align: 'left',
		sortable: true,
		renderer: cellMerge
	},
	{
		header: "修改时间",
		dataIndex: 'Time',
		width: 80,
		align: 'left',
		sortable: true,
		renderer: cellMerge
	},
	{
		header: "时机",
		dataIndex: 'ChangeType',
		width: 60,
		align: 'center',
		sortable: true
	},
	{
		header: "药品代码",
		dataIndex: 'Code',
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: "药品名称",
		dataIndex: 'Desc',
		width: 200,
		align: 'left',
		sortable: true
	},
	{
		header: "不可用",
		dataIndex: 'NoUseFlag',
		width: 100,
		align: 'center',
		sortable: true
	},
	{
		header: "药学子类",
		dataIndex: 'SubCat',
		width: 120,
		align: 'center',
		sortable: true,
		hidden:true
	},
	{
		header: "药学小类",
		dataIndex: 'MinorSubCat',
		width: 120,
		align: 'center',
		sortable: true,
		hidden:true
	},
	{
		header: "同类名",
		dataIndex: 'Generic',
		width: 150,
		align: 'center',
		sortable: true
	},
	{
		header: "产地",
		dataIndex: 'ManfDesc',
		width: 200,
		align: 'center',
		sortable: true
	},
	{
		header: "医保费别",
		dataIndex: 'Offcode',
		width: 80,
		align: 'center',
		sortable: true,
		hidden:true
	},
	{
		header: "基本单位",
		dataIndex: 'Ctuom',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "剂型",
		dataIndex: 'Form',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "频率",
		dataIndex: 'Freq',
		width: 100,
		align: 'center',
		sortable: true
	},
	{
		header: "用法",
		dataIndex: 'Instr',
		width: 100,
		align: 'center',
		sortable: true
	},
	{
		header: "管制分类",
		dataIndex: 'Poison',
		width: 150,
		align: 'center',
		sortable: true
	},
	{
		header: "生效日期",
		dataIndex: 'EFfDate',
		width: 120,
		align: 'center',
		sortable: true
	},
	{
		header: "截止日期",
		dataIndex: 'EFfDateTo',
		width: 120,
		align: 'center',
		sortable: true
	},
	{
		header: "医嘱子类",
		dataIndex: 'ItemCat',
		width: 150,
		align: 'center',
		sortable: true
	},
	{
		header: "费用子类",
		dataIndex: 'BillSubCat',
		width: 200,
		align: 'center',
		sortable: true
	},
	{
		header: "计价单位",
		dataIndex: 'BillCtuom',
		width: 150,
		align: 'center',
		sortable: true
	},
	{
		header: "医嘱优先级",
		dataIndex: 'Priority',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "独立医嘱",
		dataIndex: 'Own',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "医嘱提示框",
		dataIndex: 'OeMsg',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "规格",
		dataIndex: 'Spec',
		width: 200,
		align: 'left',
		sortable: true
	},
	{
		header: "基本单位",
		dataIndex: 'Buom',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "入库单位",
		dataIndex: 'Puruom',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "库存分类",
		dataIndex: 'StkCatDesc',
		width: 100,
		align: 'center',
		sortable: true
	}]);
	var PHCDrgFormGrid = new Ext.grid.GridPanel({
		id: 'PHCDrgFormGrid',
		region: 'center',
		autoScroll: true,
		cm: PHCDrgFormCm,
		store: PHCDrgFormStore,
		trackMouseOver: true,
		stripeRows: true,
		sm: sm
	});
	var ArcItmStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url: Url + '?actiontype=QueryArcItm&Start=0&Limit=999',
		totalProperty: 'results',
		root: 'rows',
		fields: ["tmpinci", "arcrowid", "Date", "Time", "Name", "ChangeType", "Code", "Desc", "Own", "Priority", "BillSubCat", "OeMsg", "BillCtuom", "EFfDate", "EFfDateTo", "ItemCat"]
	});
	PHCDrgFormGrid.on('rowdblclick',function(grid,rowIndex,e){
		return;//先屏蔽
		var selectedRow = PHCDrgFormStore.data.items[rowIndex];
		var auditinci = selectedRow.data['tmpinci'];
		showModalDialog('dhcst.druginfo.csp?ListVisible=false&AuditInciRowid='+auditinci,'','dialogHeight:600px;dialogWidth:800px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
	});
	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		items: [{
			title: '药品信息',
			id: 'DrgForm',
			layout: 'fit',
			items: [PHCDrgFormGrid]
		}
		]
	}) 
	var HisListTab = new Ext.form.FormPanel({
		autoHeight:true,
		labelWidth: 60,
		labelAlign: 'right',
		frame: true,
		title: '药品信息审核',
		autoScroll: false,
		tbar: [SearchBT, '-', ClearBT, '-', AuditBT, '-', RefuseBT],
		items: [{
			xtype: 'fieldset',
			title: '查询条件',
			layout: 'column',
			style:'padding-top:5px;padding-bottom:5px',	
			defaults: {border: false},
			items: [{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [StartDate,EndDate]
			},
			{
				columnWidth: 0.3,
				xtype: 'fieldset',
				items: [M_StkGrpType,M_InciDesc]
			},
			{
				columnWidth: 0.15,
				xtype: 'fieldset',
				labelWidth:20,
				items: [QuditAuditFlag]
			}]
		}]
	}) 
	// 页面布局
	var DrugAudit = new Ext.Viewport({
		layout: 'border',
		items: [{
			region: 'north',
			height: 170,
			layout: 'fit',
			items: HisListTab
		},
		{
			region: 'center',
			layout: 'fit',
			items: tabPanel
		}]
	})
})
