// /����: �������ͳ������¼��
// /����: �������ͳ������¼��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.11.12
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var IncRowid='';
	var Inclb='';
	var obj='';
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	
	var PhaLoc = new Ext.ux.form.LovCombo({
		id : 'PhaLoc',
		fieldLabel : '<font color=blue>�������</font>',
		listWidth : 400,
		anchor: '90%',
		separator:',',	//����id��","����
		store : GetGroupDeptStore,
		filterName : 'locDesc',
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	// ��¼����Ĭ��ֵ
	SetLogInDept(PhaLoc.getStore(), "PhaLoc");
	
	/*
	var RecLoc = new Ext.ux.LocComboBox({
		fieldLabel : '���տ���',
		id : 'RecLoc',
		name : 'RecLoc',
		emptyText : '���տ���...',
		anchor : '90%',
		defaultLoc:''
	});
	*/
	
	var RecLoc = new Ext.ux.form.LovCombo({
		fieldLabel : '���տ���',
		id : 'RecLoc',
		emptyText : '���տ���...',
		separator : ',',	//����id��","����
		store : DeptLocStore,
		filterName : 'locDesc',
		valueField : 'RowId',
		displayField : 'Description',
		pageSize : 9999,
		anchor : '90%'
	});

	var SlgG = new Ext.ux.ComboBox({
		id:'SlgG',
		fieldLabel:'������',
		anchor:'90%',
		listWidth:220,
		allowBlank:true,
		store:StkLocGrpStore,
		valueField:'RowId',
		displayField:'Description',
		emptyText:'������...',
		filterName:'str'
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
	
	var SCGSet = new Ext.form.ComboBox({
		id:'SCGSet',
		fieldLabel : '���鼯��',
		anchor : '90%',
		store: SCGSetStore,
		mode : 'local',
		valueField : 'RowId',
		displayField : 'Description',
		valueNotFoundText : ''
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
	
	var InclbFlag = new Ext.form.Checkbox({
		fieldLabel : '�����β�',
		id : 'InclbFlag',
		name : 'InclbFlag',
		anchor : '90%',
		width : 120,
		checked : false,
		listeners:{
			'check':function(){
				Ext.getCmp("InciDesc").setValue("");
			}
		}
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
		var LocId=Ext.getCmp("PhaLoc").getValue();
		var InclbFlag = (Ext.getCmp("InclbFlag").getValue()==true?'Y':'N');
		if (item != null && item.length > 0) {
			if(InclbFlag=="Y"){
				GetPhaOrderWindowInclb(item, group, App_StkTypeCode, LocId, "N", "0", "",
					getDrugListInclb);
			}else{
				GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", "",
					getDrugList);
			}
		}
	}
	
	/**
	 * ���ط���
	*/
	function getDrugListInclb(record,record1) {
		if (record == null || record == "") {
			return;
		}
		Inclb = record1.get("Inclb");
		IncRowid = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciCode").setValue(inciCode);
		Ext.getCmp("InciDesc").setValue(inciDesc);
	}
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
var INFOPbCarrier = new Ext.ux.ComboBox({
		fieldLabel: '������',
		id: 'INFOPbCarrier',
		name: 'INFOPbCarrier',
		store: CarrierStore,
		valueField: 'RowId',
		displayField: 'Description',
		filterName: 'CADesc'
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

	var SourceOfFund = new Ext.ux.ComboBox({
		fieldLabel : '�ʽ���Դ',
		id : 'SourceOfFund',
		anchor : '90%',
		store : SourceOfFundStore
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
		data : [['0', 'ת��ת��'], ['1', 'ת��'], ['2', 'ת��'], ['3', '��ֵת�벹¼']]
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
	Ext.getCmp("TransferFlag").setValue("0");

	var TransRangeStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [['0', 'ȫ������'], ['1', '�������ڲ�'], ['2', '�������ⲿ']]
	});
	var TransRange = new Ext.form.ComboBox({
		fieldLabel : '���ҷ�Χ',
		id : 'TransRange',
		anchor : '90%',
		store : TransRangeStore,
		valueField : 'RowId',
		displayField : 'Description',
		mode : 'local',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		listWidth : 150,
		forceSelection : true
	});
	Ext.getCmp("TransRange").setValue("0");
	
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
					Ext.getCmp("TransferFlag").setValue("0");
					Ext.getCmp("TransRange").setValue("0");
					Ext.getCmp("RecLoc").setValue("");
					Ext.getCmp("SlgG").setValue("");
					Ext.getCmp("PhManufacturer").setValue("");
					Ext.getCmp("InclbFlag").setValue("false");
					Ext.getCmp("SourceOfFund").setValue("");
					Ext.getCmp("InciDesc").setValue("");
					Ext.getCmp("PHCDOfficialType").setValue("");
					Ext.getCmp("INFOMT").setValue("");
					Ext.getCmp("OperateOutType").setValue("");
					Ext.getCmp("Vendor").setValue("");
					Ext.getCmp("INFOImportFlag").setValue("");
					Ext.getCmp("PublicBidding").setValue("");
					Ext.getCmp("INFOPBLevel").setValue("");
					Ext.getCmp("MinSp").setValue("");
					Ext.getCmp("MaxSp").setValue("");
					Ext.getCmp("MinRp").setValue("");
					Ext.getCmp("MaxRp").setValue("");
					Ext.getCmp("SpFlag").setValue("false");
					Ext.getCmp("hvFlag").setValue("");
					Ext.getCmp("M_ChargeFlag").setValue("");
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
		//anchor : '90%',
		items : [
			{boxLabel:'ȫ��',name:'hv_Flag',id:'all',inputValue:'',checked:true},
			{boxLabel:'��ֵ',name:'hv_Flag',id:'hv',inputValue:'Y'},
			{boxLabel:'�Ǹ�ֵ',name:'hv_Flag',id:'nhv',inputValue:'N'}
		]
	});
	// �շѱ�־
	var M_ChargeFlag = new Ext.form.RadioGroup({
		id : 'M_ChargeFlag',
		//anchor : '90%',
		items : [
			{boxLabel:'ȫ��',name:'M_ChargeFlag',id:'onlySurplus',inputValue:'',checked:true},
			{boxLabel:'�շ�',name:'M_ChargeFlag',id:'onlyLoss',inputValue:'Y'},
			{boxLabel:'���շ�',name:'M_ChargeFlag',id:'onlyBalance',inputValue:'N'}
		]
	});
	var ManageFlag = new Ext.form.RadioGroup({
		id : 'ManageFlag',
		items : [
			{boxLabel:'ȫ��',name:'ManageFlag',id:'ManageFlag_All',inputValue:'',checked:true},
			{boxLabel:'�ص��ע',name:'ManageFlag',id:'ManageFlag_Yes',inputValue:'Y'},
			{boxLabel:'���ص�',name:'ManageFlag',id:'ManageFlag_No',inputValue:'N'}
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
				var ReportType = Ext.getCmp("HisListTab").getForm().findField('ReportType').getGroupValue();
					var RadioObj = Ext.getCmp(ReportType);
					addtab(RadioObj);
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
					
					SetLogInDept(PhaLoc.getStore(),'PhaLoc');
					Ext.getCmp("DateFrom").setValue(DefaultStDate());
					Ext.getCmp("DateTo").setValue(DefaultEdDate());
					Ext.getCmp("StkGrpType").getStore().load();
					FlagLocStkcat.setValue(true);
					document.getElementById("reportFrame").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
				}
			});
	// ���ҿ�����
	var FlagLocStkcat = new Ext.form.Radio({
				boxLabel : '����/������',
				id : 'FlagLocStkcat',
				name : 'ReportType',
				inputValue : 'FlagLocStkcat',
				checked:'true'
			});
	// ���ҿ����ཻ�汨��(����)
	var FlagLocStkcatCross = new Ext.form.Radio({
				boxLabel : '����/�����ཻ�汨��(����)',
				id : 'FlagLocStkcatCross',
				name : 'ReportType',
				inputValue : 'FlagLocStkcatCross'
			});
	var FlagLocScgCross = new Ext.form.Radio({
				boxLabel : '����/���齻�汨��(����)',
				id : 'FlagLocScgCross',
				name : 'ReportType',
				inputValue : 'FlagLocScgCross'
			});
	// ���ҽ��
	var FlagLoc = new Ext.form.Radio({
				boxLabel : '���ҽ��',
				id : 'FlagLoc',
				name : 'ReportType',
				inputValue : 'FlagLoc'
			});
	// ���ҽ��/������
	var FlagLocGrp = new Ext.form.Radio({
				boxLabel : '���ҽ��/������',
				id : 'FlagLocGrp',
				name : 'ReportType',
				inputValue : 'FlagLocGrp'
			});
	// ��Ʒ����
	var FlagSum = new Ext.form.Radio({
				boxLabel : '��Ʒ����',
				id : 'FlagSum',
				name : 'ReportType',
				inputValue : 'FlagSum'
			});
	// ���ҵ�Ʒ����
	var FlagLocSum = new Ext.form.Radio({
				boxLabel : '���ҵ�Ʒ����',
				id : 'FlagLocSum',
				name : 'ReportType',
				inputValue : 'FlagLocSum'
			});
	// ������ϸ
	var FlagDetail = new Ext.form.Radio({
				boxLabel : '������ϸ',
				id : 'FlagDetail',
				name : 'ReportType',
				inputValue : 'FlagDetail'
			});
	// ���ⵥ����
	var FlagTrf = new Ext.form.Radio({
				boxLabel : '���ⵥ����',
				id : 'FlagTrf',
				name : 'ReportType',
				inputValue : 'FlagTrf'
			});
	// ������
	var FlagType = new Ext.form.Radio({
				boxLabel : '������',
				id : 'FlagType',
				name : 'ReportType',
			inputValue : 'FlagType'
			});
	// �������
	var FlagScg = new Ext.form.Radio({
				boxLabel : '�������',
				id : 'FlagScg',
				name : 'ReportType',
				inputValue : 'FlagScg'
			});
	// ��Ӧ�̻��ܽ��汨��
	var FlagVendor = new Ext.form.Radio({
				boxLabel : '��Ӧ�̿�����',
				id : 'FlagVendor',
				name : 'ReportType',
				inputValue : 'FlagVendor'
			});
	// ��Ӧ����ϸ���ܱ���
	var FlagVendorItm = new Ext.form.Radio({
				boxLabel : '��Ӧ����ϸ����',
				id : 'FlagVendorItm',
				name : 'ReportType',
				inputValue : 'FlagVendorItm'
			});
	// ��������ϸ���ܱ���
	var FlagCarridItm = new Ext.form.Radio({
				boxLabel : '��������ϸ����',
				id : 'FlagCarridItm',
				name : 'ReportType',
				inputValue : 'FlagCarridItm'
			});
	// �շ�/���շѻ���
	var FlagChargeSum = new Ext.form.Radio({
				boxLabel : '�շ�/���շѻ���',
				id : 'FlagChargeSum',
				name : 'ReportType',
				inputValue : 'FlagChargeSum'
			});
	// �˲��������
	var FlagBookCatSum = new Ext.form.Radio({
				boxLabel : '�˲��������',
				id : 'FlagBookCatSum',
				name : 'ReportType',
				inputValue : 'FlagBookCatSum'
			});
	// ��Ʒ���ǰʮ
	var FlagDetailTop = new Ext.form.Radio({
				boxLabel : '��Ʒ���ǰʮ',
				id : 'FlagDetailTop',
				name : 'ReportType',
				inputValue : 'FlagDetailTop'
			});

	function ShowReport() {
		var StartDate=Ext.getCmp("DateFrom").getValue();
		var EndDate=Ext.getCmp("DateTo").getValue();
		if(StartDate==""||EndDate==""){
			Msg.info("warning","��ʼ���ڻ��ֹ���ڲ���Ϊ�գ�");
			return;
		}
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();
		var LocId=Ext.getCmp("PhaLoc").getValue();
		
		var FlagLocStkcat=Ext.getCmp("FlagLocStkcat").getValue();
		var FlagLocStkcatCross=Ext.getCmp("FlagLocStkcatCross").getValue();
		var FlagLocScgCross=Ext.getCmp("FlagLocScgCross").getValue();
		var FlagLoc=Ext.getCmp("FlagLoc").getValue();
		var FlagDetail=Ext.getCmp("FlagDetail").getValue();
		var FlagLocGrp=Ext.getCmp("FlagLocGrp").getValue();
		var FlagTrf=Ext.getCmp("FlagTrf").getValue();
		var FlagType=Ext.getCmp("FlagType").getValue();
		var FlagScg=Ext.getCmp("FlagScg").getValue();
		var FlagLocSum=Ext.getCmp("FlagLocSum").getValue();
		var FlagSum=Ext.getCmp("FlagSum").getValue();
		var FlagVendor=Ext.getCmp("FlagVendor").getValue();
		var FlagVendorItm=Ext.getCmp("FlagVendorItm").getValue();
		var FlagChargeSum = Ext.getCmp("FlagChargeSum").getValue();
		var FlagBookCatSum = Ext.getCmp("FlagBookCatSum").getValue();
		var FlagDetailTop = Ext.getCmp("FlagDetailTop").getValue();
		var FlagCarridItm= Ext.getCmp("FlagCarridItm").getValue();
		var SCGSet=Ext.getCmp('SCGSet').getRawValue();
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//������id
		if(StkCatId!=""&StkCatId!=null){
			StkCatId=","+StkCatId+",";
		}
		var InciDesc=Ext.getCmp("InciDesc").getValue();				//�����id
		if (InciDesc==null || InciDesc=="") {
			IncRowid = "";
			Inclb="";
		}
		if(IncRowid!="" & IncRowid!=null){
			InciDesc=""
		}
		var MarkType=Ext.getCmp("INFOMT").getValue();				//��������
		var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//���ڱ�־
		var BatNo='';											//��������
		var PbFlag=Ext.getCmp("PublicBidding").getValue();		//�б��־
		var PbLevel=Ext.getCmp("INFOPBLevel").getValue();			//�б꼶��
		var ManageFlag=Ext.getCmp("ManageFlag").getValue().getGroupValue();		//�ص��ע���
		var ManfId=Ext.getCmp("PhManufacturer").getValue();			//��������id
		var InsuType=Ext.getCmp("PHCDOfficialType").getValue();		//ҽ������
		var VendorId=Ext.getCmp("Vendor").getValue();				//��Ӧ��id
		var OperateType=Ext.getCmp("OperateOutType").getValue();		//��������
		var MinSp=Ext.getCmp("MinSp").getValue();				//����ۼ�
		var MaxSp=Ext.getCmp("MaxSp").getValue();				//����ۼ�
		var MinRp=Ext.getCmp("MinRp").getValue();				//��ͽ���
		var MaxRp=Ext.getCmp("MaxRp").getValue();				//��߽���
		var RecLocId=Ext.getCmp("RecLoc").getValue();			//���տ���
		var TransferFlag=Ext.getCmp("TransferFlag").getValue();				//ͳ�Ʒ�ʽ
		var hvFlag = Ext.getCmp("hvFlag").getValue().getGroupValue();
		var charge = Ext.getCmp("M_ChargeFlag").getValue().getGroupValue();
		var StartTime=Ext.getCmp("TimeFrom").getValue();
		var EndTime=Ext.getCmp("TimeTo").getValue();
		var SourceOfFund=Ext.getCmp("SourceOfFund").getValue();
		var TransRange=Ext.getCmp("TransRange").getValue();		//���ҷ�Χ
		var SlgG = Ext.getCmp('SlgG').getRawValue();				//������
		var Carrid=Ext.getCmp('INFOPbCarrier').getValue(); //������
		var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag+"^"+PbLevel+"^"+ManageFlag+"^"+""
			+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp
			+"^"+MaxRp+"^"+RecLocId+"^"+hvFlag+"^"+StartTime+"^"+EndTime+"^"+InciDesc+"^"+SourceOfFund+"^"+charge+"^"+sssStkGrpType+"^"+Inclb
			+"^"+TransRange+"^"+SlgG+"^"+gUserId+"^"+SCGSet+"^"+Carrid;
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
		if(TransRange!=""){
			Conditions=Conditions+" ���ҷ�Χ: "+Ext.getCmp("TransRange").getRawValue()
		}
		if(RecLocId!=""){
			Conditions=Conditions+" ���տ���: "+Ext.getCmp("RecLoc").getRawValue()
		}
		if(SlgG!=""){
			Conditions=Conditions+" ������: "+SlgG
		}
		if(SCGSet!=""){
			Conditions=Conditions+" ���鼯��: "+Ext.getCmp("SCGSet").getRawValue()
		}
		if(GrpType!=""){
			Conditions=Conditions+" ����: "+Ext.getCmp("StkGrpType").getRawValue()
		}
		if(StkCatId!=""){
			Conditions=Conditions+" ������: "+Ext.getCmp("DHCStkCatGroup").getRawValue()
		}
		if(ManfId!=""){
			Conditions=Conditions+" ����: "+Ext.getCmp("PhManufacturer").getRawValue()
		}if(Carrid!=""){
			Conditions=Conditions+" ������: "+Ext.getCmp("INFOPbCarrier").getRawValue()
			}
		if(InciDesc!=""){
			Conditions=Conditions+" ��������: "+InciDesc
		}
		if(SourceOfFund!=""){
			Conditions=Conditions+" �ʽ���Դ: "+Ext.getCmp("SourceOfFund").getRawValue()
		}
		if(InsuType!=""){
			Conditions=Conditions+" ҽ�����: "+Ext.getCmp("PHCDOfficialType").getRawValue()
		}
		if(MarkType!=""){
			Conditions=Conditions+" ��������: "+Ext.getCmp("INFOMT").getRawValue()
		}
		if(OperateType!=""){
			Conditions=Conditions+" ��������: "+Ext.getCmp("OperateOutType").getRawValue()
		}
		if(VendorId!=""){
			Conditions=Conditions+" ��Ӧ��: "+Ext.getCmp("Vendor").getRawValue()
		}
		if(PbFlag!=""){
			Conditions=Conditions+" �б�: "+Ext.getCmp("PublicBidding").getRawValue()
		}
		if(PbLevel!=""){
			Conditions=Conditions+" �б꼶��: "+Ext.getCmp("INFOPBLevel").getRawValue()
		}
		if(ImpFlag!=""){
			Conditions=Conditions+" ���ڱ�־: "+Ext.getCmp("INFOImportFlag").getRawValue()
		}
		if(MinSp!=""||MaxSp!=""){
			Conditions=Conditions+" �ۼ۷�Χ: "+MinSp+" ~ "+MaxSp
		}
		if(MinRp!=""||MaxRp!=""){
			Conditions=Conditions+" ���۷�Χ: "+MinRp+" ~ "+MaxRp
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
		if(ManageFlag == 'Y'){
			Conditions = Conditions+" �ص��ע: ��"
		}else if(ManageFlag == 'N'){
			Conditions = Conditions+" �ص��ע: ��"
		}
		//ȡ����ѯ����
		//���ҿ�����
	
		if(FlagLocStkcat==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-LocStkcat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//���ҿ����ཻ�汨��(����)
		else if(FlagLocStkcatCross==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-LocStkcatCross.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//�������齻�汨��(����)
		else if(FlagLocScgCross==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-LocScgCross.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//���ҽ��
		else if(FlagLoc==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Loc.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//������
		else if(FlagLocGrp==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-LocGrp.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//��Ʒ����
		else if(FlagSum==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Sum.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//���ҵ�Ʒ����
		else if(FlagLocSum==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-LocSum.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//������ϸ
		else if(FlagDetail==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Detail.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//���ⵥ����
		else if(FlagTrf==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Trf.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//������
		else if(FlagType==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Type.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//��Ӧ�̿�����
		else if(FlagVendor==true){

			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Vendor.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//��Ӧ����ϸ����
		else if(FlagVendorItm==true){
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-VendorItm.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//�������
		else if(FlagScg==true){
			
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-Scg.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		else if(FlagChargeSum==true){
			//�շѻ���
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat_ChargeSum.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		else if(FlagBookCatSum==true){
			//�˲��������
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat_BookCatSum.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		else if(FlagDetailTop==true){
			//��Ʒ���ǰʮ
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat_DetailTop.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}else if(FlagCarridItm==true){
			//������
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferCarii_Detail.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		}
		//���ҿ�����
		else{
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_TransferOutStat-LocStkcat.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
				'&Conditions='+Conditions;
		
			//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
			//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			//var NewWin=open(p_URL,"�������-����/������","top=20,left=20,width=930,height=660,scrollbars=1");
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
		tbar : [OkBT, "-", ClearBT,'-',MonFlag],
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			items : [PhaLoc,DateFrom,TimeFrom,DateTo,TimeTo,TransferFlag,TransRange,RecLoc,SlgG,SCGSet,StkGrpType,DHCStkCatGroup,
				PhManufacturer,InclbFlag,InciDesc,SourceOfFund,PHCDOfficialType,INFOMT,OperateOutType,Vendor,INFOPbCarrier,
				PublicBidding,INFOPBLevel,INFOImportFlag,
				{xtype:'compositefield',fieldLabel:'�ۼ۷�Χ',items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
				{xtype:'compositefield',fieldLabel:'���۷�Χ',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
				hvFlag,M_ChargeFlag,ManageFlag,
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
		}, {
			xtype : 'fieldset',
			title : '��������',
			labelWidth : 40,
			items : [FlagLocStkcat,FlagLocStkcatCross,FlagLocScgCross,FlagLoc,FlagLocGrp,FlagSum,
					FlagLocSum,FlagDetail,FlagTrf,FlagType,FlagScg,
					FlagVendor,FlagVendorItm,FlagChargeSum,FlagBookCatSum,FlagDetailTop,FlagCarridItm]
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
					title:'�������',
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