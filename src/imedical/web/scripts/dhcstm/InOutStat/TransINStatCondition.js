// /����: �������ͳ������¼��
// /����: �������ͳ������¼��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.11.12

var InRequestParamObj = GetAppPropValue('DHCSTINREQM');
//��������ȫ�ֱ���
var LOCTYPE = '';
if(InRequestParamObj && InRequestParamObj.ReqLocUseLinkLoc){
	//����ʱʹ��"��������"��,ת������ѯҲһ��
	LOCTYPE = InRequestParamObj.ReqLocUseLinkLoc == 'Y'? 'L' : '';
}

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var IncRowid='';
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	
    // ������
	var RecLoc= new Ext.ux.LocComboBox({
		fieldLabel : '���ղ���',
		id : 'RecLoc',
		name : 'RecLoc',
		anchor:'90%',
		emptyText : '���ղ���...',
		groupId:gGroupId,
		protype : LOCTYPE,
		linkloc:gLocId,
		listeners:
		{
			'select':function(cb)
			{
				var requestLoc=cb.getValue();
				var defprovLocs=tkMakeServerCall("web.DHCSTM.DHCTransferLocConf","GetDefLoc",requestLoc,gGroupId)
				var mainArr=defprovLocs.split("^");
		                var defprovLoc=mainArr[0];
		                var defprovLocdesc=mainArr[1];
				addComboData(Ext.getCmp('PhaLoc').getStore(),defprovLoc,defprovLocdesc);
				Ext.getCmp("PhaLoc").setValue(defprovLoc);
				var provLoc=Ext.getCmp('PhaLoc').getValue();
				var provLoc=Ext.getCmp('PhaLoc').getValue();
				Ext.getCmp("StkGrpType").setFilterByLoc(requestLoc,provLoc);			
			}
		}
	});
	var PhaLoc = new Ext.ux.ComboBox({
		id:'PhaLoc',
		fieldLabel:'��������',
		anchor:'90%',
		store:frLocListStore,
		displayField:'Description',
		valueField:'RowId',
		listWidth:210,
		emptyText:'��������...',
		params:{LocId:'RecLoc'},
		filterName : 'FilterDesc',
		listeners:{
			'select':function(cb)
			{
				var provLoc=cb.getValue();
				var requestLoc=Ext.getCmp('RecLoc').getValue();
				Ext.getCmp("StkGrpType").setFilterByLoc(requestLoc,provLoc);			
			}
		}
	});

	PhaLoc.on("select",function(cmb,rec,id ){
	});
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ʼ����</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		
		value :DefaultStDate()
	});
	
	var TimeFrom = new Ext.form.TextField({
		fieldLabel : '��ʼʱ��',
		id : 'TimeFrom',
		name : 'TimeFrom',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss'
	});
		
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ֹ����</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		
		value : DefaultEdDate()
	});
	
	var TimeTo = new Ext.form.TextField({
		fieldLabel : '��ֹʱ��',
		id : 'TimeTo',
		name : 'TimeTo',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss'
	});
	
	// ��������
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor : '90%',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:gLocId,
		UserId:gUserId,
		childCombo : 'DHCStkCatGroup'
	}); 

	var InciDr = new Ext.form.TextField({
		fieldLabel : '����RowId',
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var InciCode = new Ext.form.TextField({
		fieldLabel : '���ʱ���',
		id : 'InciCode',
		name : 'InciCode',
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

	/**
	 * �������ʴ��岢���ؽ��
	 */
	function GetPhaOrderInfo(item, group) {
		if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
					getDrugList);
		}
	}
	
	/**
	 * ���ط���
	*/
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		IncRowid = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDr").setValue(InciDr);
		Ext.getCmp("InciCode").setValue(inciCode);
		Ext.getCmp("InciDesc").setValue(inciDesc);
	}
		
	var DHCStkCatGroup = new Ext.ux.ComboBox({
		fieldLabel : '������',
		id : 'DHCStkCatGroup',
		name : 'DHCStkCatGroup',
		store : StkCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{StkGrpId:'StkGrpType'}
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor : '90%',
		params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'}
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel : '����',
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName',
		params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'}
	});

	var PHCDOfficialType = new Ext.ux.ComboBox({
		fieldLabel : 'ҽ�����',
		id : 'PHCDOfficialType',
		name : 'PHCDOfficialType',
		anchor : '90%',
		store : OfficeCodeStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

	var PublicBiddingStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['1', '�б�'], ['0', '���б�']]
	});
	var PublicBidding = new Ext.form.ComboBox({
		fieldLabel : '�б�',
		id : 'PublicBidding',
		name : 'PublicBidding',
		anchor : '90%',
		store : PublicBiddingStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});

	var TransferFlagStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['0', 'ת��ת��'], ['1', 'ת��'], ['2', 'ת��']]
	});
	var TransferFlag = new Ext.form.ComboBox({
		fieldLabel : 'ͳ�Ʒ�ʽ',
		id : 'TransferFlag',
		name : 'TransferFlag',
		anchor : '90%',
		store : TransferFlagStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});
	Ext.getCmp("TransferFlag").setValue("2");

	var INFOPBLevel = new Ext.ux.ComboBox({
		fieldLabel : '�б꼶��',
		id : 'INFOPBLevel',
		name : 'INFOPBLevel',
		anchor : '90%',
		store : INFOPBLevelStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

	var SpFlag = new Ext.form.Checkbox({
		boxLabel : '�����ۼ۲������ۼ�',
		id : 'SpFlag',
		name : 'SpFlag',
		anchor : '90%',
		checked : false
	});
	MarkTypeStore.load();
	var INFOMT = new Ext.ux.ComboBox({
		fieldLabel : '��������',
		id : 'INFOMT',
		name : 'INFOMT',
		anchor : '90%',
		store : MarkTypeStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

	// �������
	var OperateOutType = new Ext.ux.ComboBox({
		fieldLabel : '��������',
		id : 'OperateOutType',
		name : 'OperateOutType',
		anchor : '90%',
		store : OperateOutTypeStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
	OperateInTypeStore.load();

	var MinSp = new Ext.ux.NumberField({
		id : 'MinSp',
		formatType : 'FmtSP',
		width : '70',
		valueNotFoundText : ''
	});
			
	var MaxSp = new Ext.ux.NumberField({
		id : 'MaxSp',
		formatType : 'FmtSP',
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
				
	var ImportStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['����', '����'], ['����', '����'], ['����', '����']]
	});
	var INFOImportFlag = new Ext.form.ComboBox({
		fieldLabel : '���ڱ�־',
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
    //��ֵ��־
    var hvFlag = new Ext.form.RadioGroup({
	    id : 'hvFlag',
	    items : [
		    {boxLabel:'ȫ��',name:'hv_Flag',id:'all',inputValue:'',checked:true},
		    {boxLabel:'��ֵ',name:'hv_Flag',id:'hv',inputValue:'Y'},
		    {boxLabel:'�Ǹ�ֵ',name:'hv_Flag',id:'nhv',inputValue:'N'}
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
			Ext.getCmp("MinSp").setValue("");
			Ext.getCmp("MaxSp").setValue("");
			Ext.getCmp("MinRp").setValue("");
			Ext.getCmp("MaxRp").setValue("");
			SetLogInDept(RecLoc.getStore(),'RecLoc');
			Ext.getCmp("DateFrom").setValue(DefaultStDate());
			Ext.getCmp("DateTo").setValue(DefaultEdDate());
			Ext.getCmp("StkGrpType").getStore().load();
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
		var LocId=Ext.getCmp("PhaLoc").getValue();
		if(LocId==""){
			//Msg.info("warning","�������Ų���Ϊ�գ�");
			//return;
		}	
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//������id
		var InciDesc=Ext.getCmp("InciDesc").getValue();				//�����id
		if (InciDesc==null || InciDesc=="") {
			IncRowid = "";
		}
		if(IncRowid!=""&IncRowid!=null){
			InciDesc="";
		}
		var MarkType=Ext.getCmp("INFOMT").getValue();				//��������
		var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//���ڱ�־
		var BatNo='';											//��������
		var PbFlag=Ext.getCmp("PublicBidding").getValue();		//�б��־
		var PbLevel=Ext.getCmp("INFOPBLevel").getValue();			//�б꼶��
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//��������id
		var InsuType=Ext.getCmp("PHCDOfficialType").getValue();		//ҽ������
		var VendorId=Ext.getCmp("Vendor").getValue();				//��Ӧ��id
		var OperateType=Ext.getCmp("OperateOutType").getValue();		//��������
		var MinSp=Ext.getCmp("MinSp").getValue();				//����ۼ�
		var MaxSp=Ext.getCmp("MaxSp").getValue();				//����ۼ�
		var MinRp=Ext.getCmp("MinRp").getValue();				//��ͽ���
		var MaxRp=Ext.getCmp("MaxRp").getValue();				//��߽���
		var RecLocId=Ext.getCmp("RecLoc").getValue();			//���տ���
		if(RecLocId==""){
			Msg.info("warning","���ղ��Ų���Ϊ�գ�");
			return;
		}
		var RecLocDesc=Ext.getCmp("RecLoc").getRawValue();			//���տ���
		var PhaLocDesc=Ext.getCmp("PhaLoc").getRawValue()
		var TransferFlag=Ext.getCmp("TransferFlag").getValue();				//ͳ�Ʒ�ʽ
		var hvFlag=Ext.getCmp("hvFlag").getValue().getGroupValue();
		var StartTime=Ext.getCmp("TimeFrom").getValue();
		var EndTime=Ext.getCmp("TimeTo").getValue();
		
		var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag+"^"+PbLevel+"^"+""+"^"+""
			+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp
			+"^"+MaxRp+"^"+LocId+"^"+hvFlag+"^"+StartTime+"^"+EndTime+"^"+InciDesc;
		var reportframe=document.getElementById("reportFrame")
		var p_URL="";
		//ȡ����ѯ����
		var Conditions="";
		if(LocId!=""){
			Conditions="�������: "+Ext.getCmp("PhaLoc").getRawValue()
		}
		if(StartDate!=""){
			var Sdate=Ext.getCmp("DateFrom").getValue().format(DateFormat).toString();
			Conditions=Conditions+" ͳ��ʱ��: "+Sdate+" "+StartTime
		}
		if(EndDate!=""){
			var Tdate=Ext.getCmp("DateTo").getValue().format(DateFormat).toString();
			Conditions=Conditions+"~ "+Tdate+" "+EndTime
		}
		if(TransferFlag!=""){
			Conditions=Conditions+" ͳ�Ʒ�ʽ: "+Ext.getCmp("TransferFlag").getRawValue()
		}
		if(GrpType!=""){
			Conditions=Conditions+" ����: "+Ext.getCmp("StkGrpType").getRawValue()
		}
		if(hvFlag=="Y"){
			Conditions=Conditions+" ��ֵ: ��"
		}else if(hvFlag=="N"){
			Conditions=Conditions+" ��ֵ: ��"			
		}else if(hvFlag==""){
			Conditions=Conditions+" ��ֵ: ȫ��"			
		}
		if(StkCatId!=""){
			Conditions=Conditions+" ������: "+Ext.getCmp("DHCStkCatGroup").getRawValue()
		}
		//ȡ����ѯ����
		p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferINStat-LocStkcat.raq&StartDate='+
			StartDate +'&EndDate=' +EndDate +'&LocId='+ RecLocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
			'&Conditions='+Conditions+'&RecLocDesc='+RecLocDesc;
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
			items : [RecLoc,PhaLoc,DateFrom,TimeFrom,DateTo,TimeTo,TransferFlag,StkGrpType,DHCStkCatGroup,
				PhManufacturer,InciDesc,PHCDOfficialType,INFOMT,OperateOutType,Vendor,
				PublicBidding,INFOPBLevel,INFOImportFlag,
				{xtype:'compositefield',fieldLabel:'�ۼ۷�Χ',items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
				{xtype:'compositefield',fieldLabel:'���۷�Χ',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
				hvFlag,
				{
					xtype:'checkbox',
					boxLabel : '��ʹ��',
					id : 'usedFlag',
					name : 'usedFlag',
					anchor : '90%',
					checked : false,
					hidden:true
				}
			]
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
			title:'ת��������',
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
			items:reportPanel
		}]
	});
});