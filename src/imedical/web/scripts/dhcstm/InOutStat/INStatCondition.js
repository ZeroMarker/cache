// /����: ������ͳ������¼��
// /����:  ������ͳ������¼��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.01.17
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var inciDr=""
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>����</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '����...',
		groupId:gGroupId,
		stkGrpId : 'StkGrpType',
		childCombo : ['Vendor','PhManufacturer']
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
		StkType:sssStkGrpType,     //��ʶ��������
		LocId:gLocId,
		UserId:gUserId,
		childCombo : 'DHCStkCatGroup'
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
			GetPhaOrderWindow(item, group,App_StkTypeCode, "", "N", "0", "",
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
		inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDesc").setValue(inciDesc);
	}
	
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

	var INFOPBLevel = new Ext.ux.ComboBox({
		fieldLabel : '�б꼶��',
		id : 'INFOPBLevel',
		name : 'INFOPBLevel',
		store : INFOPBLevelStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
    var TransferFlagStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['0', '����˻�'], ['1', '�˻�'], ['2', '���']]
	});
	var RetFlag = new Ext.form.ComboBox({
		fieldLabel : 'ͳ�Ʒ�ʽ',
		id : 'RetFlag',
		name : 'RetFlag',
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
	Ext.getCmp("RetFlag").setValue("0");
		
	var SpFlag = new Ext.form.Checkbox({
		boxLabel : '�����ۼ۲������ۼ�',
		hideLabel : true,
		id : 'SpFlag',
		name : 'SpFlag',
		anchor : '90%',
		checked : false
	});
	
	var MonFlag = new Ext.form.Checkbox({
		boxLabel : '�¶Ȼ���',
		hideLabel : true,
		id : 'MonFlag',
		name : 'MonFlag',
		anchor : '90%',
		checked : false,
		listeners: {
			'check': function (checked) {
				if (checked.checked) {
					Ext.getCmp("DateFrom").setValue(BeginLastMon());
					Ext.getCmp("DateTo").setValue(EndLastMon());
					Ext.getCmp("TimeFrom").setValue("");
					Ext.getCmp("TimeTo").setValue("");
					Ext.getCmp("RetFlag").setValue("0");
					Ext.getCmp("Vendor").setValue("");
					Ext.getCmp("SourceOfFund").setValue("");
					Ext.getCmp("PhManufacturer").setValue("");
					Ext.getCmp("InciDesc").setValue("");
					Ext.getCmp("PHCDOfficialType").setValue("");
					Ext.getCmp("INFOMT").setValue("");
					Ext.getCmp("OperateInType").setValue("");
					Ext.getCmp("INFOImportFlag").setValue("");
					Ext.getCmp("PublicBidding").setValue("");
					Ext.getCmp("INFOPBLevel").setValue("");
					Ext.getCmp("InvNo").setValue("");
					Ext.getCmp("MinSp").setValue("");
					Ext.getCmp("MaxSp").setValue("");
					Ext.getCmp("MinRp").setValue("");
					Ext.getCmp("MaxRp").setValue("");
					Ext.getCmp("SpFlag").setValue("false");
					Ext.getCmp("hvFlag").setValue("");
					Ext.getCmp("M_ChargeFlag").setValue("");
					Ext.getCmp("FindTypeFlag").setValue("All");
					Ext.getCmp("StkGrpType").setValue("");
					Ext.getCmp("DHCStkCatGroup").setValue("");
				}
			}
		}
				
	});
/*
ȡ����Ĭ�Ͽ�ʼ��������
*/
function BeginLastMon(){
	var today=new Date();
	var days=today.getDate()
	var lastmon=today.add(Date.MONTH,-1);
	var lastmon=lastmon.add(Date.DAY, 1-days);
	return lastmon;
}

function EndLastMon(){
	var today=new Date();
	var days=today.getDate()
	var lastmon=today.add(Date.DAY, -days);
	return lastmon;
}
	// ��ֵ��־
	var hvFlag = new Ext.form.RadioGroup({
		id : 'hvFlag',
		hideLabel : true,
		items : [
			{boxLabel:'ȫ��',name:'hv_Flag',id:'all',inputValue:'',checked:true},
			{boxLabel:'��ֵ',name:'hv_Flag',id:'hv',inputValue:'Y'},
			{boxLabel:'�Ǹ�ֵ',name:'hv_Flag',id:'nhv',inputValue:'N'}
		]
	});
	// �շѱ�־
	var M_ChargeFlag = new Ext.form.RadioGroup({
		id : 'M_ChargeFlag',
		hideLabel : true,
		items : [
			{boxLabel:'ȫ��',name:'M_ChargeFlag',id:'onlySurplus',inputValue:'',checked:true},
			{boxLabel:'�շ�',name:'M_ChargeFlag',id:'onlyLoss',inputValue:'Y'},
			{boxLabel:'���շ�',name:'M_ChargeFlag',id:'onlyBalance',inputValue:'N'}
		]
	});		
	var FindTypeData=[['ȫ��','All'],['����','G'],['���ۻ�Ʊ','A']];
		var FindTypeStore = new Ext.data.SimpleStore({
			fields: ['typedesc', 'typeid'],
			data : FindTypeData
		});
	var FindTypeFlag = new Ext.form.ComboBox({
		store: FindTypeStore,
		displayField:'typedesc',
		mode: 'local', 
		anchor : '90%',
		emptyText:'',
		id:'FindTypeFlag',
		fieldLabel : '���ͻ���ۻ�Ʊ',
		triggerAction:'all',
		valueField : 'typeid'
	});
	Ext.getCmp("FindTypeFlag").setValue("All");		
	var usedFlag = new Ext.form.Checkbox({
		boxLabel : '��ʹ��',
		id : 'usedFlag',
		name : 'usedFlag',
		anchor : '90%',
		checked : false,
		hidden:true
	});
	
	MarkTypeStore.load();
	var INFOMT = new Ext.ux.ComboBox({
		fieldLabel : '��������',
		id : 'INFOMT',
		name : 'INFOMT',
		store : MarkTypeStore,
		valueField : 'RowId',
		displayField : 'Description'
	});

	// �������
	var OperateInType = new Ext.ux.ComboBox({
		fieldLabel : '�������',
		id : 'OperateInType',
		name : 'OperateInType',
		store : OperateInTypeStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
	OperateInTypeStore.load();

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
	var InvNo = new Ext.form.TextField({
		fieldLabel : '��Ʊ��',
		id : 'InvNo',
		name : 'InvNo',
		anchor : '90%',
		valueNotFoundText : ''
	});

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
	
	var SourceOfFund = new Ext.ux.ComboBox({
		fieldLabel : '�ʽ���Դ',
		id : 'SourceOfFund',
		name : 'SourceOfFund',
		anchor : '90%',
		store : SourceOfFundStore,
		valueField : 'RowId',
		filterName:'Desc',
		displayField : 'Description'
	});	
	//�ʽ���Դ
	var FlagSourceOfFundStat = new Ext.form.Radio({
		boxLabel : '�ʽ���Դ����',
		id : 'FlagSourceOfFundStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagSourceOfFundStat'
	});
	// ��ⵥ�б�
	var FlagImportDetail = new Ext.form.Radio({
		boxLabel : '��ⵥ��ϸ�б�',
		id : 'FlagImportDetail',
		name : 'ReportType',
		anchor : '90%',
		inputValue : 'FlagImportDetail',
		checked:'true'
	});
	// ��ⵥ�����б�
	var FlagImportGroupDetail = new Ext.form.Radio({
		boxLabel : '��ⵥ�����б�',
		id : 'FlagImportGroupDetail',
		name : 'ReportType',
		anchor : '90%',
		inputValue : 'FlagImportGroupDetail'
	});
	// ��Ʒ����
	var FlagItmStat = new Ext.form.Radio({
		boxLabel : '��Ʒ����',
		id : 'FlagItmStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagItmStat'
	});
	// ��Ʒ����(������)
	var FlagItmBatStat = new Ext.form.Radio({
		boxLabel : '��Ʒ���λ���',
		id : 'FlagItmBatStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagItmBatStat'
	});
	// ��Ӧ�̻���
	var FlagVendorStat = new Ext.form.Radio({
		boxLabel : '��Ӧ�̻���',
		id : 'FlagVendorStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagVendorStat'
	});
	// ��Ӧ����ϸ����
	var FlagVendorItmStat = new Ext.form.Radio({
		boxLabel : '��Ӧ����ϸ����',
		id : 'FlagVendorItmStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagVendorItmStat'
	});	
	// ��Ӧ�̿����ཻ�汨��(����)
	var FlagVendorStkcatCross = new Ext.form.Radio({
		boxLabel : '��Ӧ��/���������(����)',
		id : 'FlagVendorStkcatCross',
		name : 'ReportType',
		anchor : '100%',
		inputValue : 'FlagVendorStkcatCross'
	});
	// ��Ӧ�̷�Ʊ����(����)
	var FlagVendorInvList = new Ext.form.Radio({
		boxLabel : '��Ӧ�̷�Ʊ����(����)',
		id : 'FlagVendorInvList',
		name : 'ReportType',
		inputValue : 'FlagVendorInvList'
	});
	// �������
	var FlagStkGrpStat = new Ext.form.Radio({
		boxLabel : '�������',
		id : 'FlagStkGrpStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagStkGrpStat'
	});	
	// ���������
	var FlagStockStat = new Ext.form.Radio({
		boxLabel : '���������',
		id : 'FlagStockStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagStockStat'
	});				
   // ��ⵥ����
	var FlagRecItmSumStat = new Ext.form.Radio({
		boxLabel : '��ⵥ����',
		id : 'FlagRecItmSumStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagRecItmSumStat'
	});	
   // ��Ʒ����(����)
	var FlagRpItmSumStat = new Ext.form.Radio({
		boxLabel : '��Ʒ����(����)',
		id : 'FlagRpItmSumStat',
		name : 'ReportType',
		anchor : '80%',
		inputValue : 'FlagRpItmSumStat'
	});			
    // ��Ӧ�̷�Ʊ���ݻ���
	var FlagVendor2InvList = new Ext.form.Radio({
		boxLabel : '��Ӧ�̷�Ʊ���ݻ���',
		id : 'FlagVendor2InvList',
		name : 'ReportType',
		inputValue : 'FlagVendor2InvList'
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
			SetLogInDept(PhaLoc.getStore(),'PhaLoc');
			Ext.getCmp("DateFrom").setValue(DefaultStDate());
			Ext.getCmp("DateTo").setValue(DefaultEdDate());
			Ext.getCmp("StkGrpType").getStore().load();
			FlagImportDetail.setValue(true);
			document.getElementById("frameReport").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		}
	});
	//��ӡ��ť
	var PrintBT = new Ext.Toolbar.Button({
		text : '��ӡ',
		tooltip : '�����ӡ',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			Print();
		}
	});
	function Print(){
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();;
		var LocId=Ext.getCmp("PhaLoc").getValue();
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//������id
		var InciDesc=Ext.getCmp("InciDesc").getValue();				//�����id
		if (InciDesc==null || InciDesc=="") {
			inciDr = "";
		}
		var MarkType=Ext.getCmp("INFOMT").getValue();				//��������
		var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//���ڱ�־
		var BatNo='';											//��������
		var PbFlag=Ext.getCmp("PublicBidding").getValue();		//�б��־
		var PbLevel=Ext.getCmp("INFOPBLevel").getValue();			//�б꼶��
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//��������id
		var InsuType=Ext.getCmp("PHCDOfficialType").getValue();		//ҽ������
		var VendorId=Ext.getCmp("Vendor").getValue();				//��Ӧ��id
		var OperateType=Ext.getCmp("OperateInType").getValue();		//�������
		var MinSp=Ext.getCmp("MinSp").getValue();				//����ۼ�
		var MaxSp=Ext.getCmp("MaxSp").getValue();				//����ۼ�
		var MinRp=Ext.getCmp("MinRp").getValue();				//��ͽ���
		var MaxRp=Ext.getCmp("MaxRp").getValue();				//��߽���
		var InvNo=Ext.getCmp("InvNo").getValue();				//��Ʊ��
		var SpFlag=Ext.getCmp("SpFlag").getValue();				//�����ۼ۲������ۼ۱�־
		if(SpFlag==true){
			SpFlag=1;
		}
		else{
			SpFlag=0;
		}
		var hvFlag = Ext.getCmp("hvFlag").getValue().getGroupValue();
		var charge = Ext.getCmp("M_ChargeFlag").getValue().getGroupValue();
		var TimeFrom=Ext.getCmp("TimeFrom").getValue();
		var TimeTo=Ext.getCmp("TimeTo").getValue();
		var RetFlag=Ext.getCmp("RetFlag").getValue();		  //ͳ�Ʒ�ʽ
		
		var Others=GrpType+"^"+StkCatId+"^"+inciDr+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
		+"^"+PbLevel+"^"+""+"^"+""+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""
		+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+InvNo+"^"+SpFlag+"^"+hvFlag+"^"+TimeFrom+"^"+TimeTo+"^"+charge+"^"+sssStkGrpType+"^"+gUserId;
		//��ȡ��ѯ�����б�
		var Conditions=""
		if(LocId!=""){
			Conditions="�ⷿ: "+Ext.getCmp("PhaLoc").getRawValue()
		}
		if(Ext.getCmp("DateFrom").getValue()!=""){
			Conditions=Conditions+" ����: "+StartDate+" "+TimeFrom
		}
		if(Ext.getCmp("DateTo").getValue()!=""){
			Conditions=Conditions+"~ "+EndDate+" "+TimeTo
		} 
		var HospDesc=App_LogonHospDesc;
		fileName="{DHCSTM_importvendorpage.raq(StartDate="+StartDate+";HospDesc="+HospDesc+";EndDate="+EndDate+";LocId="+LocId+";Others="+Others+";Conditions="+Conditions+";RetFlag="+RetFlag+")}";
		DHCCPM_RQDirectPrint(fileName);
	}
		
	// ȷ����ť
	var OkBT = new Ext.Toolbar.Button({
		id : "OkBT",
		text : 'ͳ��',
		tooltip : '���ͳ��',
		width : 70,
		iconCls : 'page_find',
		height : 30,
		handler : function() {
			//ShowReport();
			var ReportType = Ext.getCmp("HisListTab").getForm().findField('ReportType').getGroupValue();
			var RadioObj = Ext.getCmp(ReportType);
			addtab(RadioObj);
		}
	});
	
	function ShowReport(){   
		var StartDate=Ext.getCmp("DateFrom").getValue();
		var EndDate=Ext.getCmp("DateTo").getValue();
		if(StartDate==""||EndDate==""){
			Msg.info("warning","��ʼ���ڻ��ֹ���ڲ���Ϊ�գ�");
			return;
		}
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();;
		var LocId=Ext.getCmp("PhaLoc").getValue();
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//������id
		if(StkCatId!=""&StkCatId!=null){
			StkCatId=","+StkCatId+",";
		}
		var InciDesc=Ext.getCmp("InciDesc").getValue();				//�����id
		if (InciDesc==null || InciDesc=="") {
			inciDr = "";
		}
		var MarkType=Ext.getCmp("INFOMT").getValue();				//��������
		var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//���ڱ�־
		var BatNo='';											//��������
		var PbFlag=Ext.getCmp("PublicBidding").getValue();		//�б��־
		var PbLevel=Ext.getCmp("INFOPBLevel").getValue();			//�б꼶��
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//��������id
		var InsuType=Ext.getCmp("PHCDOfficialType").getValue();		//ҽ������
		var VendorId=Ext.getCmp("Vendor").getValue();				//��Ӧ��id
		var OperateType=Ext.getCmp("OperateInType").getValue();		//�������
		var MinSp=Ext.getCmp("MinSp").getValue();				//����ۼ�
		var MaxSp=Ext.getCmp("MaxSp").getValue();				//����ۼ�
		var MinRp=Ext.getCmp("MinRp").getValue();				//��ͽ���
		var MaxRp=Ext.getCmp("MaxRp").getValue();				//��߽���
		var InvNo=Ext.getCmp("InvNo").getValue();				//��Ʊ��
		var SpFlag=Ext.getCmp("SpFlag").getValue();				//�����ۼ۲������ۼ۱�־
		if(SpFlag==true){
			SpFlag=1;
		}
		else{
			SpFlag=0;
		}
		var FlagImportDetail=Ext.getCmp("FlagImportDetail").getValue();
		var FlagImportGroupDetail=Ext.getCmp("FlagImportGroupDetail").getValue();
		var FlagItmStat=Ext.getCmp("FlagItmStat").getValue();
		var FlagItmBatStat=Ext.getCmp("FlagItmBatStat").getValue();
		var FlagVendorStat=Ext.getCmp("FlagVendorStat").getValue();
		var FlagVendorItmStat=Ext.getCmp("FlagVendorItmStat").getValue(); //��Ӧ����ϸ����
		var FlagVendorStkcatCross=Ext.getCmp("FlagVendorStkcatCross").getValue();  //��Ӧ�̿����ཻ��ͳ��
		var FlagStkGrpStat=Ext.getCmp("FlagStkGrpStat").getValue();        //�������
		var FlagStockStat=Ext.getCmp("FlagStockStat").getValue();       //���������
		var FlagRecItmSumStat=Ext.getCmp("FlagRecItmSumStat").getValue();       //��ⵥ����
		var FlagRpItmSumStat=Ext.getCmp("FlagRpItmSumStat").getValue();      //��ⵥ(����)���� 
		var FlagSourceOfFundStat=Ext.getCmp("FlagSourceOfFundStat").getValue();      //�ʽ���Դ���� 
		var FlagVendorInvList=Ext.getCmp("FlagVendorInvList").getValue();			//��Ӧ�̷�Ʊ�б�
		var FlagVendor2InvList=Ext.getCmp("FlagVendor2InvList").getValue();
		var hvFlag = Ext.getCmp("hvFlag").getValue().getGroupValue();
		var charge = Ext.getCmp("M_ChargeFlag").getValue().getGroupValue();
		var TimeFrom=Ext.getCmp("TimeFrom").getValue();
		var TimeTo=Ext.getCmp("TimeTo").getValue();
		var RetFlag=Ext.getCmp("RetFlag").getValue();		  //ͳ�Ʒ�ʽ
		var SourceOfFund=Ext.getCmp("SourceOfFund").getValue();
		var FindTypeFlag=Ext.getCmp("FindTypeFlag").getValue();  //���ۻ�Ʊ��������
		
		var Others=GrpType+"^"+StkCatId+"^"+inciDr+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
		+"^"+PbLevel+"^"+""+"^"+""+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""
		+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+InvNo+"^"+SpFlag
		+"^"+hvFlag+"^"+TimeFrom+"^"+TimeTo+"^"+InciDesc+"^"+SourceOfFund+"^"+charge+"^"+sssStkGrpType+"^"+FindTypeFlag+"^"+gUserId;
		var reportFrame=document.getElementById("frameReport");
		var p_URL="";
		//��ȡ��ѯ�����б�
		var Conditions=""
		if(LocId!=""){
			Conditions="����: "+Ext.getCmp("PhaLoc").getRawValue()
		}
		if(Ext.getCmp("DateFrom").getValue()!=""){
			var Sdate=Ext.getCmp("DateFrom").getValue().format(DateFormat).toString();
			Conditions=Conditions+" ͳ��ʱ��: "+Sdate+" "+TimeFrom
		}
		if(Ext.getCmp("DateTo").getValue()!=""){
			var Tdate=Ext.getCmp("DateTo").getValue().format(DateFormat).toString();
			Conditions=Conditions+"~ "+Tdate+" "+TimeTo
		} 
		if(VendorId!=""){
			Conditions=Conditions+" ��Ӧ��: "+Ext.getCmp("Vendor").getRawValue()
		}	
		if(GrpType!=""){
			Conditions=Conditions+" ����: "+Ext.getCmp("StkGrpType").getRawValue()
		}	
		if(StkCatId!=""){
			Conditions=Conditions+" ������: "+Ext.getCmp("DHCStkCatGroup").getRawValue()
		}
		if(ManfId!=""){
			Conditions=Conditions+" ����: "+Ext.getCmp("PhManufacturer").getRawValue()
		}	
		if(InciDesc!=""){
			Conditions=Conditions+" ����: "+InciDesc
		}
		if(InsuType!=""){
			Conditions=Conditions+" ҽ�����: "+Ext.getCmp("PHCDOfficialType").getRawValue()
		}
		if(MarkType!=""){
			Conditions=Conditions+" ��������: "+Ext.getCmp("INFOMT").getRawValue()
		}
		if(OperateType!=""){
			Conditions=Conditions+" �������: "+Ext.getCmp("OperateInType").getRawValue()
		}
		if(ImpFlag!=""){
			Conditions=Conditions+" ���ڱ�־: "+Ext.getCmp("INFOImportFlag").getRawValue()
		} 
		if(PbFlag!=""){
			Conditions=Conditions+" �б�: "+Ext.getCmp("PublicBidding").getRawValue()
		}
		if(PbLevel!=""){
			Conditions=Conditions+" �б꼶��: "+Ext.getCmp("INFOPBLevel").getRawValue()
		}
		if(InvNo!=""){
			Conditions=Conditions+" ��Ʊ��: "+InvNo
		}
		if(MinSp!=""||MaxSp!=""){
			Conditions=Conditions+" �ۼ۷�Χ: "+MinSp+" ~ "+MaxSp
		}
		if(MinRp!=""||MaxRp!=""){
			Conditions=Conditions+" ���۷�Χ: "+MinRp+" ~ "+MaxRp
		}
		if(SpFlag==1){
			Conditions=Conditions+" �����ۼ۲������ۼ�: ��"
		}	
		if(hvFlag=="Y"){
			Conditions=Conditions+" ��ֵ: ��"
		}else if(hvFlag=="N"){
			Conditions=Conditions+" ��ֵ: ��"			
		}else if(hvFlag==""){
			Conditions=Conditions+" ��ֵ: ȫ��"			
		}
		if(charge=="Y"){
			Conditions=Conditions+" �շ�: ��"
		}else if(charge=="N"){
			Conditions=Conditions+" �շ�: ��"			
		}else if(charge==""){
			Conditions=Conditions+" �շ�: ȫ��"			
		}
		if(RetFlag!=""){
			Conditions=Conditions+" ͳ�Ʒ�ʽ: "+Ext.getCmp("RetFlag").getRawValue()
		}
		if(SourceOfFund!=""){
			Conditions=Conditions+" �ʽ���Դ: "+Ext.getCmp("SourceOfFund").getRawValue();
		}
	//��ȡ��ѯ�����б�
		//��ⵥ�б�
		if(FlagImportDetail==true){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importdetail.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		else if(FlagImportGroupDetail==true){
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importgroupdetail.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//��Ʒ����
		else if(FlagItmStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importitmstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//��Ʒ����(������)
		else if(FlagItmBatStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importitmbatstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//��Ӧ�̻���
		else if(FlagVendorStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importvendorstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//��Ӧ����ϸ����
		else if(FlagVendorItmStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importvendoitmrstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//��Ӧ�̿����ཻ�汨��(����)
		else if(FlagVendorStkcatCross==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importvendorstkcatcross.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//�������
		else if(FlagStkGrpStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importstkgrpstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//���������
		else if(FlagStockStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importstockstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//��ⵥ����
		else if(FlagRecItmSumStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importrecitmsumstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//��Ʒ����(����)
		else if(FlagRpItmSumStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importrpitmsumstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//�ʽ���Դ����
		else if(FlagSourceOfFundStat==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_sourceoffundstat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}	
		//��Ӧ�̷�Ʊ�б�
		else if(FlagVendorInvList==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importVendorInvList.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//��Ӧ�̷�Ʊ���ݻ���
		else if(FlagVendor2InvList==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_VendorRecInvNoDetailStat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}
		//��ⵥ�б�
		else{
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_importdetail.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
		}		
		var ReportType = Ext.getCmp("HisListTab").getForm().findField('ReportType').getGroupValue();
			var reportFrame = document.getElementById("iframe_"+ReportType);
			reportFrame.src = p_URL;
	}
	var HisListTab = new Ext.form.FormPanel({
		id : 'HisListTab',
		labelWidth : 60,
		labelAlign : 'right',
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		tbar : [OkBT,'-',ClearBT,'-',MonFlag],
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',					
			items : [PhaLoc,DateFrom,TimeFrom,DateTo,TimeTo,RetFlag,Vendor,SourceOfFund,StkGrpType,DHCStkCatGroup,
				PhManufacturer,InciDesc,PHCDOfficialType,INFOMT,OperateInType,
				INFOImportFlag,PublicBidding,INFOPBLevel,InvNo,
				{xtype:'compositefield',fieldLabel:'�ۼ۷�Χ',items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
				{xtype:'compositefield',fieldLabel:'���۷�Χ',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
				SpFlag,hvFlag,usedFlag,M_ChargeFlag,FindTypeFlag]
		}, {
			xtype : 'fieldset',
			title : '��������',
			items : [FlagImportDetail,FlagImportGroupDetail,FlagItmStat,FlagRpItmSumStat,FlagItmBatStat,FlagVendorStat,FlagVendorItmStat,FlagVendorStkcatCross,
				FlagVendorInvList,FlagVendor2InvList,FlagStkGrpStat,FlagStockStat,FlagRecItmSumStat,
				FlagSourceOfFundStat]
		}]
	});
   
	var addtab = function(cmpobj){
			var tabs=Ext.getCmp('main-tabs');
			var id=cmpobj.id;
			var title=cmpobj.boxLabel;
			var tabId = "tab_"+id;
			var iframeId = "iframe_"+id;
			var obj = Ext.getCmp(tabId);
			if (!obj){
				//�ж�tab�Ƿ��Ѵ�
				var obj=tabs.add({
					id:tabId,
					title:title,
					html:"<iframe id='"+iframeId+"' frameborder='0' scrolling='auto' height='100%' width='100%' src='../scripts/dhcstm/ExtUX/images/logon_bg.jpg'></iframe>",
					closable:true
				});
				obj.show();	//��ʾtabҳ
			}else{
				tabs.fireEvent('tabchange', tabs, obj);
			}
		}
		
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
				}],
			listeners : {
				tabchange : function(tabpanel, tab){
					var radioId = tab.id.split('_')[1];
					if(!Ext.isEmpty(radioId) && !Ext.isEmpty(radioId)){
						Ext.getCmp(radioId).setValue(true);
						ShowReport();
					}
				}
			}
		});
	
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [{
			region:'west',
			title:"������",
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
			items:tabs
		}]
	});
});