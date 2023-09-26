// /����: ��Ӧ������ͳ��
// /��д��: tsr
// /��д����: 20160627
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];

	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ʼ����</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		
		value:new Date().add(Date.DAY, parseInt(-30))
	});

	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ֹ����</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		
		value:new Date()
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor : '90%'
	});
	
	var EvalueIndexStore = new Ext.data.Store({
	    proxy : new Ext.data.HttpProxy({
	        url : 'dhcstm.vendorindexaction.csp?actiontype=EvalueIndex'
	    }),
	    reader : new Ext.data.JsonReader({
	            totalProperty : "results",
	            root : 'rows'
	        }, ['Description', 'RowId'])
	});
	EvalueIndexStore.load();
	var IndexList = new Ext.form.ComboBox({	
		fieldLabel : '����ָ��',
		id : 'IndexList',
		name : 'IndexList',
		anchor : '90%',
		store : EvalueIndexStore,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all',
		emptyText : '����ָ��...',
		selectOnFocus : true,
	    forceSelection : true,
		listWidth : 200,
		valueNotFoundText : ''
	})
	
	var OkBT = new Ext.Toolbar.Button({
		id : "OkBT",
		text : 'ͳ��',
		tooltip : '���ͳ��',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			ShowReport();
		}
	});
	
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '���',
		tooltip : '������',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			Ext.getCmp('HisListTab').getForm().items.each(function(f){ 
				f.setValue("");
			});
			Ext.getCmp("DateFrom").setValue(new Date().add(Date.DAY, parseInt(-30)));
			Ext.getCmp("DateTo").setValue(new Date());
			FlagVendorIndexScore.setValue(true);
			document.getElementById("reportFrame").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
	});

	var FlagVendorIndexScore = new Ext.form.Radio({
		boxLabel : '��Ӧ��ָ�����',
		id : 'FlagVendorIndexScore',
		name : 'ReportType',
		checked : true
	});
			
	function ShowReport() {
		var StartDate=Ext.getCmp("DateFrom").getValue();
		var EndDate=Ext.getCmp("DateTo").getValue();
		if(StartDate==""||EndDate==""){
			Msg.info("warning","��ʼ���ڻ��ֹ���ڲ���Ϊ�գ�");
			return;
		}
		var FlagVendorIndexScore=Ext.getCmp("FlagVendorIndexScore").getValue();
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();	
		var Vendor=Ext.getCmp("Vendor").getValue();
		var IndexList=Ext.getCmp("IndexList").getValue();
		var Others=IndexList;
		var reportframe=document.getElementById("reportFrame")
		var p_URL="";
		
		if(FlagVendorIndexScore==true){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_VendorIndexStat_Score.raq&StartDate='+
				StartDate+'&EndDate='+EndDate+'&Vendor='+Vendor+'&Others='+Others;
		}
		else{
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_VendorIndexStat_Score.raq&StartDate='+
				StartDate+'&EndDate='+EndDate+'&Vendor='+Vendor+'&Others='+Others;
		}
		reportframe.src=p_URL;
	}

	var HisListTab = new Ext.form.FormPanel({
		id : 'HisListTab',
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		tbar : [OkBT, "-", ClearBT],
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			items : [DateFrom,DateTo,Vendor,IndexList]
		}, {
			xtype : 'fieldset',
			title : '��������',
			labelWidth : 40,
			items : [FlagVendorIndexScore]
		}]
	});

	var reportPanel=new Ext.Panel({
		frame:true,
		html:'<iframe id="reportFrame" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	})
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [{
			region:'west',
			title:'��Ӧ������ͳ��',
			width:270,
			minSize:250,
			maxSize:350,
			split:true,
			collapsible:true,
			layout:'fit',
			items:HisListTab
		},{
			region:'center',
			layout:'fit',
			items:reportPanel
		}]
	});
});