///����:����ά��ͳ�Ʊ���
///����:����ά��ͳ�Ʊ���
///��д��:wangjiabin
///��д����:2014-05-05
Ext.onReady(function() {
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var inciDr="";
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '����...',
		groupId:gGroupId,
		childCombo : 'PhManufacturer'
	});
	
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		
		value : new Date().add(Date.DAY,-30)
	});
	
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '��ֹ����',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		
		value : new Date()
	});
	
	var DateFlag = new Ext.form.Checkbox({
		boxLabel : '��������',
		id : 'DateFlag',
		name : 'DateFlag',
		anchor : '90%',
		checked : false
	});
	
	var LocGroupFlag = new Ext.form.Checkbox({
		boxLabel : '��������',
		id : 'LocGroupFlag',
		name : 'LocGroupFlag',
		anchor : '90%',
		checked : true
	});
	
	var Barcode = new Ext.form.TextField({
		fieldLabel:'����',
		id : 'Barcode',
		name : 'Barcode',
		anchor : '90%'
	});
	
	var inciDesc = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'inciDesc',
		name : 'inciDesc',
		anchor : '90%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var inputText=field.getValue();
					GetPhaOrderInfo(inputText,"");
				}
			}
		}
	});
	
	/**
	* �������ʴ��岢���ؽ��
	*/
	function GetPhaOrderInfo(item, group) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "", getDrugList);
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
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("inciDesc").setValue(inciDesc);
	}
	
	var StatusStore = new Ext.data.SimpleStore({
		fields:['RowId','Description'],
		data : [['A','����'],['M','ά������'],['R','ά����'],['S','ͣ��'],['D','����']]
	});
	var StatusField = new Ext.form.ComboBox({
		fieldLabel:'����״̬',
		id:'StatusField',
		anchor:'90%',
		allowBlank:true,
		store:StatusStore,
		value:'',
		valueField:'RowId',
		displayField:'Description',
		emptyText:'',
		triggerAction:'all',
		emptyText:'',
		mode:'local',
		selectOnFocus:true,
		forceSelection:true
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel : '����',
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName',
		params : {LocId : 'PhaLoc'}
	});
	
	//��ϸ
	var LocMainDetail = new Ext.form.Radio({
		boxLabel : '��Ʒ��ϸ',
		id : 'LocMainDetail',
		name : 'ReportType',
		anchor : '80%',
		checked : true
	});
	//��Ʒ����
	var LocMainItm = new Ext.form.Radio({
		boxLabel : '��Ʒ����',
		id : 'LocMainItm',
		name : 'ReportType',
		anchor : '80%'
	});
	//��Ʒ����
	var LocMainScgFlag = new Ext.form.Radio({
		boxLabel : '������ϸ',
		id : 'LocMainScgFlag',
		name : 'ReportType',
		anchor : '80%'
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
			
			SetLogInDept(PhaLoc.getStore(),'PhaLoc');
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-30));
			Ext.getCmp("EndDate").setValue(new Date());
			
			document.getElementById("frameReport").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
	});
	
	// ȷ����ť
	var OkBT = new Ext.Toolbar.Button({
		id : "OkBT",
		text : 'ͳ��',
		tooltip : '���ͳ��',
		width : 70,
		iconCls : 'page_find',
		height : 30,
		handler : function() {
			ShowReport();
		}
	});
	
	function ShowReport(){
		var PhaLoc=Ext.getCmp("PhaLoc").getValue();
		if(PhaLoc==""){
			Msg.info("warning","���Ҳ���Ϊ��!");
			return;
		}
		var DateFlag=Ext.getCmp("DateFlag").getValue()?1:0;
		var StartDate="",EndDate="";
		if(DateFlag!=1){
			StartDate=Ext.getCmp("StartDate").getValue();
			if(StartDate==""){
				Msg.info("warning","��ʼ���ڲ���Ϊ��!");
				return;
			}else{
				StartDate=StartDate.format(ARG_DATEFORMAT);
			}
			EndDate=Ext.getCmp("EndDate").getValue();
			if(EndDate==""){
				Msg.info("warning","��ֹ���ڲ���Ϊ��!");
				return;
			}else{
				EndDate=EndDate.format(ARG_DATEFORMAT);
			}
		}
		var Barcode=Ext.getCmp("Barcode").getValue();
		var inciDesc=Ext.getCmp("inciDesc").getValue();
		if(inciDesc==""){
			inciDr="";
		}
		
		var Time="";
		var LocGroupFlag=Ext.getCmp("LocGroupFlag").getValue()?1:0;
		var Status=Ext.getCmp("StatusField").getValue();
		var Manf=Ext.getCmp("PhManufacturer").getValue();
		var StrParam=StartDate+"^"+EndDate+"^"+inciDr+"^"+Barcode+"^"+DateFlag
				+"^"+Time+"^"+PhaLoc+"^"+LocGroupFlag+"^"+Status+"^"+Manf;
		
		var reportFrame=document.getElementById("frameReport");
		
		var LocMainDetailFlag=Ext.getCmp("LocMainDetail").getValue();
		var LocMainItmFlag=Ext.getCmp("LocMainItm").getValue();
		var LocMainScgFlag=Ext.getCmp("LocMainScgFlag").getValue();
		
		if(LocMainDetailFlag){
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_LocMainDetail.raq&Param='+StrParam;
		}else if(LocMainItmFlag){
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_LocMainItm.raq&Param='+StrParam;
		}else if(LocMainScgFlag){
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_LocMainScg.raq&Param='+StrParam;
		}else{
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_LocMainDetail.raq&Param='+StrParam;
		}
		reportFrame.src=p_URL;
	}
		
	var HisListTab = new Ext.form.FormPanel({
		id : 'HisListTab',
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5,0,5,0',
		tbar : [OkBT,'-',ClearBT],
		items : [{
				xtype : 'fieldset',
				title : '��ѯ����',
				items : [PhaLoc,StartDate,EndDate,DateFlag,LocGroupFlag,Barcode,inciDesc,StatusField,PhManufacturer]
			},{
				xtype : 'fieldset',
				title : '��������',
				items : [LocMainDetail,LocMainItm,LocMainScgFlag]
			}]
	});

	var reportPanel=new Ext.Panel({
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [{
			region:'west',
			title:"ά�޼�¼����",
			width:300,
			split:true,
			collapsible:true,
			minSize:250,
			maxSize:350,
			layout:'fit',
			items:HisListTab
		},{
			region:'center',
			layout:'fit',
			items:reportPanel
		}]
	});

});