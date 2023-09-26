//���ܣ����������
//���������������
//���ߣ���־��
//����:2014-11-24
var Url = 'dhcst.drugauditaction.csp';
var inciDr = "";
Ext.onReady(function() {
	var gUserId = session['LOGON.USERID'];
	var gLocId = session['LOGON.CTLOCID'];
	var HospId = session['LOGON.HOSPID'];
	var gGroupId = session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL; 
	//==========����==========================
	/**
		 * ����ҩƷ���岢���ؽ��
		 */
	function GetPhaOrderInfo(item, stktype) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "", getDrugList);
		}
	}
	/**
		 * ���ط���
		 */
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		inciDr = record.get("InciDr"); 
		var InciDesc = record.get("InciDesc");
		Ext.getCmp("M_InciDesc").setValue(InciDesc);
	} 
	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
		fieldLabel: '��ʼ����',
		id: 'StartDate',
		name: 'StartDate',
		anchor: '90%',
		width: 80,
		value: new Date
	}); 
	// ��ֹ����
	var EndDate = new Ext.ux.DateField({
		fieldLabel: '��ֹ����',
		id: 'EndDate',
		name: 'EndDate',
		anchor: '90%',
		width: 80,
		value: new Date
	});
	 // ҩƷ����
	var M_StkGrpType = new Ext.ux.StkGrpComboBox({
		fieldLabel : '�ࡡ����', 
		id: 'M_StkGrpType',
		name: 'M_StkGrpType',
		StkType: App_StkTypeCode,
		//��ʶ��������
		anchor: '90%',
		//LocId: gLocId,
		UserId: gUserId
	}); 
	// ҩƷ����
	var M_InciDesc = new Ext.form.TextField({
		fieldLabel: 'ҩƷ����',
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
	// ��ѯ��ť
	var SearchBT = new Ext.Toolbar.Button({
		id: "SearchBT",
		text: '��ѯ',
		tooltip: '�����ѯ',
		width: 70,
		height: 30,
		iconCls: 'page_find',
		handler: function() {
			Query();
		}
	}); 
	// ��հ�ť
	var ClearBT = new Ext.Toolbar.Button({
		id: 'ClearBT',
		text: '����',
		tooltip: '�������',
		width: 70,
		height: 30,
		iconCls: 'page_clearscreen',
		handler: function() {
			clearData();
		}
	}); 
	// ���ȷ�ϰ�ť
	var AuditBT = new Ext.Toolbar.Button({
		id: 'AuditBT',
		text: '���ȷ��',
		tooltip: '������ȷ��',
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
		text: '��˲�ͨ��',
		tooltip: '��˲�ͨ��',
		width: 70,
		height: 30,
		iconCls: 'page_gear',
		//disabled : true,
		//hidden:true,
		handler: function() {
			Audit("N");
		}
	});
	 // ��ɱ�־
	var QuditAuditFlag = new Ext.form.Checkbox({
		boxLabel: '��ѯ��˼�¼',
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
					Ext.MessageBox.alert("��ѯ����",PHCDrgFormStore.reader.jsonData.Error);  
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
				Msg.info("warning", "û����Ҫ��˵�ҩƷ��Ϣ��");
				return;
			}
			if (rowCount == 0) {
				Msg.info("warning", "û����Ҫ��˵�ҩƷ��Ϣ��");
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
		var loadMask = ShowLoadMask(Ext.getBody(), "������...");
		Ext.Ajax.request({
			url: url,
			method: 'POST',
			params: {
				InciStr: incistr,
				User: gUserId,
				Flag: flag
			},
			waitMsg: '������...',
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info('success','��˳ɹ���');
					Query()
				}
				else{
					if (jsonData.info=="-1001")
					{
						Msg.info("warning", "��δά����˼���Ȩ��,���ڿⷿ����ģ��ά��!");
						return false;
					}
					else if (jsonData.info=="-1002")
					{
						Msg.info("warning", "���û������Ȩ��,���ڿⷿ����ģ��ά��!");
						return false;
					}
					else if (jsonData.info=="-1000")
					{
						Msg.info("warning", "��ȡ�����û�,�����µ�¼������!");
						return false;
					}	
					else if (jsonData.info=="-1003")
					{
						Msg.info("warning", "�Ѿ����!");
						return false;
					}
					else if (jsonData.info=="-1005")
					{
						Msg.info("warning", "���û�Ȩ��Ϊδ����״̬!");
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
		header: "���״̬",
		dataIndex: 'AuditFlag',
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: "�����",
		dataIndex: 'AuditUser',
		width: 75,
		align: 'left',
		sortable: true
	},
	{
		header: "����������",
		dataIndex: 'AuditDate',
		width: 90,
		align: 'center',
		sortable: true
	},
	{
		header: "������ʱ��",
		dataIndex: 'AuditTime',
		width: 90,
		align: 'center',
		sortable: true
	},
	{
		header: '�޸���',
		dataIndex: 'Name',
		width: 75,
		align: 'left',
		sortable: true,
		renderer: cellMerge
	},
	{
		header: "�޸�����",
		dataIndex: 'Date',
		width: 80,
		align: 'left',
		sortable: true,
		renderer: cellMerge
	},
	{
		header: "�޸�ʱ��",
		dataIndex: 'Time',
		width: 80,
		align: 'left',
		sortable: true,
		renderer: cellMerge
	},
	{
		header: "ʱ��",
		dataIndex: 'ChangeType',
		width: 60,
		align: 'center',
		sortable: true
	},
	{
		header: "ҩƷ����",
		dataIndex: 'Code',
		width: 100,
		align: 'left',
		sortable: true
	},
	{
		header: "ҩƷ����",
		dataIndex: 'Desc',
		width: 200,
		align: 'left',
		sortable: true
	},
	{
		header: "������",
		dataIndex: 'NoUseFlag',
		width: 100,
		align: 'center',
		sortable: true
	},
	{
		header: "ҩѧ����",
		dataIndex: 'SubCat',
		width: 120,
		align: 'center',
		sortable: true,
		hidden:true
	},
	{
		header: "ҩѧС��",
		dataIndex: 'MinorSubCat',
		width: 120,
		align: 'center',
		sortable: true,
		hidden:true
	},
	{
		header: "ͬ����",
		dataIndex: 'Generic',
		width: 150,
		align: 'center',
		sortable: true
	},
	{
		header: "����",
		dataIndex: 'ManfDesc',
		width: 200,
		align: 'center',
		sortable: true
	},
	{
		header: "ҽ���ѱ�",
		dataIndex: 'Offcode',
		width: 80,
		align: 'center',
		sortable: true,
		hidden:true
	},
	{
		header: "������λ",
		dataIndex: 'Ctuom',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "����",
		dataIndex: 'Form',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "Ƶ��",
		dataIndex: 'Freq',
		width: 100,
		align: 'center',
		sortable: true
	},
	{
		header: "�÷�",
		dataIndex: 'Instr',
		width: 100,
		align: 'center',
		sortable: true
	},
	{
		header: "���Ʒ���",
		dataIndex: 'Poison',
		width: 150,
		align: 'center',
		sortable: true
	},
	{
		header: "��Ч����",
		dataIndex: 'EFfDate',
		width: 120,
		align: 'center',
		sortable: true
	},
	{
		header: "��ֹ����",
		dataIndex: 'EFfDateTo',
		width: 120,
		align: 'center',
		sortable: true
	},
	{
		header: "ҽ������",
		dataIndex: 'ItemCat',
		width: 150,
		align: 'center',
		sortable: true
	},
	{
		header: "��������",
		dataIndex: 'BillSubCat',
		width: 200,
		align: 'center',
		sortable: true
	},
	{
		header: "�Ƽ۵�λ",
		dataIndex: 'BillCtuom',
		width: 150,
		align: 'center',
		sortable: true
	},
	{
		header: "ҽ�����ȼ�",
		dataIndex: 'Priority',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "����ҽ��",
		dataIndex: 'Own',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "ҽ����ʾ��",
		dataIndex: 'OeMsg',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "���",
		dataIndex: 'Spec',
		width: 200,
		align: 'left',
		sortable: true
	},
	{
		header: "������λ",
		dataIndex: 'Buom',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "��ⵥλ",
		dataIndex: 'Puruom',
		width: 80,
		align: 'center',
		sortable: true
	},
	{
		header: "������",
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
		return;//������
		var selectedRow = PHCDrgFormStore.data.items[rowIndex];
		var auditinci = selectedRow.data['tmpinci'];
		showModalDialog('dhcst.druginfo.csp?ListVisible=false&AuditInciRowid='+auditinci,'','dialogHeight:600px;dialogWidth:800px;center:yes;help:no;resizable:no;status:no;scroll:no;menubar=no;toolbar=no;location=no')
	});
	var tabPanel = new Ext.TabPanel({
		activeTab: 0,
		items: [{
			title: 'ҩƷ��Ϣ',
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
		title: 'ҩƷ��Ϣ���',
		autoScroll: false,
		tbar: [SearchBT, '-', ClearBT, '-', AuditBT, '-', RefuseBT],
		items: [{
			xtype: 'fieldset',
			title: '��ѯ����',
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
	// ҳ�沼��
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
