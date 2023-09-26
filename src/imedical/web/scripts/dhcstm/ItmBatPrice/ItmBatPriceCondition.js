// /����: �������μ۸�ͳ��
// /����: �������μ۸�ͳ��
// /��д�ߣ�lxt
// /��д����: 2017.09.26
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
		value :DefaultStDate()
	});
		
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ֹ����</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : DefaultEdDate()
	});
	
	// ��������
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor : '90%',
		StkType:sssStkGrpType,     //��ʶ��������
		LocId:gLocId,
		UserId:gUserId,
		childCombo : 'DHCStkCatGroup'
	}); 
	
	var DHCStkCatGroup = new Ext.ux.form.LovCombo({
		fieldLabel : '������',
		id : 'DHCStkCatGroup',
		listWidth : 200,
		anchor: '90%',
		separator:',',	//������id��,����
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'},
		triggerAction : 'all'
	});
	
	var InciDr = new Ext.form.TextField({
		fieldLabel : '����RowId',
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		valueNotFoundText : ''
	});
	
	var InciDesc = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'InciDesc',
		name : 'InciDesc',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stkGrp=Ext.getCmp("StkGrpType").getValue();
					var inputText=field.getValue();
					GetPhaOrderInfo(inputText,stkGrp);
				}
			}
		}
	});
	
	function GetPhaOrderInfo(item, group) {			
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group,App_StkTypeCode, "", "N", "0", "",
				getDrugList);
		}
	}

	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDesc").setValue(inciDesc);
		Ext.getCmp("InciDr").setValue(inciDr);
	}
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor : '90%',
		params : {ScgId : 'StkGrpType'}
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel : '����',
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName',
		params : {ScgId : 'StkGrpType'}
	});
	
	var BatNo = new Ext.ux.TextField({
		id : 'BatNo',
		fieldLabel : '����',
		formatType : 'BatNo',
		width : '70',
		valueNotFoundText : ''
	});
	
	var MaxRp = new Ext.ux.NumberField({
		id : 'MaxRp',
		formatType : 'FmtRP',
		width : '70',
		valueNotFoundText : ''
	});
	var MinRp = new Ext.ux.NumberField({
		id : 'MinRp',
		formatType : 'FmtRP',
		width : '70',
		valueNotFoundText : ''
	});
	
	// ��ֵ��־
	var hvFlag = new Ext.form.RadioGroup({
		id : 'hvFlag',
		items : [
			{boxLabel:'ȫ��',name:'hv_Flag',id:'all',inputValue:'',checked:true},
			{boxLabel:'��ֵ',name:'hv_Flag',id:'hv',inputValue:'Y'},
			{boxLabel:'�Ǹ�ֵ',name:'hv_Flag',id:'nhv',inputValue:'N'}
		]
	});
	
	// �շѱ�־
	var M_ChargeFlag = new Ext.form.RadioGroup({
		id : 'M_ChargeFlag',
		items : [
			{boxLabel:'ȫ��',name:'M_ChargeFlag',id:'onlySurplus',inputValue:'',checked:true},
			{boxLabel:'�շ�',name:'M_ChargeFlag',id:'onlyLoss',inputValue:'Y'},
			{boxLabel:'���շ�',name:'M_ChargeFlag',id:'onlyBalance',inputValue:'N'}
		]
	});	
	
	// ȷ����ť
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
					Ext.getCmp("DateFrom").setValue(DefaultStDate());
					Ext.getCmp("DateTo").setValue(DefaultEdDate());
					Ext.getCmp("StkGrpType").getStore().load();
					Ext.getCmp("Vendor").getStore().load();
					Ext.getCmp("PhManufacturer").getStore().load();
					Ext.getCmp("MinRp").setValue("");
					Ext.getCmp("MaxRp").setValue("");
					Ext.getCmp("BatNo").setValue("");
					FlagItmBatRp.setValue(true);
					document.getElementById("reportFrame").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
				}
			});

    function ShowReport() {
		
		var StartDate=Ext.getCmp("DateFrom").getValue();
		var EndDate=Ext.getCmp("DateTo").getValue();
		if(StartDate==""||EndDate==""){
			Msg.info("warning","��ʼ���ڻ��ֹ���ڲ���Ϊ�գ�");
			return;
		}
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();;
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//������id
		if(StkCatId!=""&StkCatId!=null){
			StkCatId=","+StkCatId+",";
		}
		
		var VendorId=Ext.getCmp("Vendor").getValue();				//��Ӧ��id
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//��������id
		var MinRp=Ext.getCmp("MinRp").getValue();				//��ͽ���
		var MaxRp=Ext.getCmp("MaxRp").getValue();				//��߽���
		var BatNo=Ext.getCmp("BatNo").getValue();				//��߽���
		var hvFlag = Ext.getCmp("hvFlag").getValue().getGroupValue();
		var charge = Ext.getCmp("M_ChargeFlag").getValue().getGroupValue();
		
		var inciDr=Ext.getCmp("InciDr").getValue();	
		var InciDesc=Ext.getCmp("InciDesc").getValue();	
		if (InciDesc==null || InciDesc=="") {
			inciDr = "";
		}
		
		var Others=inciDr+"^"+BatNo+"^"+ManfId+"^"+VendorId+"^"+MinRp
			+"^"+MaxRp+"^"+hvFlag+"^"+charge;

		//ȡ����ѯ����
		var Conditions="";
		if(StartDate!=""){
			Conditions=Conditions+" ͳ��ʱ��: "+StartDate
		}
		if(EndDate!=""){
			Conditions=Conditions+"~ "+EndDate
		}
		if(GrpType!=""){
			Conditions=Conditions+" ����: "+Ext.getCmp("StkGrpType").getRawValue()
		}
		if(StkCatId!=""){
			Conditions=Conditions+" ������: "+Ext.getCmp("DHCStkCatGroup").getRawValue()
		}
		if(MinRp!=""||MaxRp!=""){
			Conditions=Conditions+" ���۷�Χ: "+MinRp+" ~ "+MaxRp
		}
		//ȡ����ѯ����
		var p = Ext.getCmp("main-tabs").getActiveTab();
		var iframe = p.el.dom.getElementsByTagName("iframe")[0];
		iframe.src = PmRunQianUrl+'?reportName=DHCSTM_ItmBatRp.raq&StartDate='+
			StartDate +'&EndDate=' +EndDate +'&GrpType=' +GrpType +
			'&StkCatId='+StkCatId+'&Conditions='+Conditions+'&Others='+Others;
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
			items : [DateFrom,DateTo,StkGrpType,DHCStkCatGroup,InciDesc,Vendor,PhManufacturer,BatNo,
			{xtype:'compositefield',fieldLabel:'���۷�Χ',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
			hvFlag,M_ChargeFlag]
		}]
	});
	
	var tabs=new Ext.TabPanel({
			id:'main-tabs',
			activeTab:0,
			region:'center',
			enableTabScroll:true,
			resizeTabs: true,
			tabWidth:130,
			minTabWidth:120,
			resizeTabs:true,
			plugins: new Ext.ux.TabCloseMenu(), //�Ҽ��رղ˵�
			items:[{
				title:'����',	
					html:'<iframe id="reportFrame" height="100%" width="100%" scrolling="auto" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
				}]
		});
	
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [{
					region:'west',
					title:'���μ۸�䶯ͳ��',
					width:300,
					minSize:250,
					maxSize:350,
					split:true,
					collapsible:true,
					layout:'fit',
					items:HisListTab
				},{
					region:'center',
					layout:'fit',
					items:tabs
				}]
			});
});