// /����: �������ͳ������¼��
// /����: �������ͳ������¼��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.11.12

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var IncRowid='';
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	
	/*
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>����</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '����...',
		groupId:gGroupId,
		stkGrpId : 'StkGrpType',
		childCombo : ['vendor','PhManufacturer']
	});
	*/
	
	var PhaLoc = new Ext.ux.form.LovCombo({
		id : 'PhaLoc',
		fieldLabel : '<font color=blue>�������</font>',
		listWidth : 400,
		anchor: '90%',
		separator:',',	//����id��","����
		store : GetGroupDeptStore,
		valueField : 'RowId',
		displayField : 'Description',
		triggerAction : 'all'
	});
	// ��¼����Ĭ��ֵ
	SetLogInDept(PhaLoc.getStore(), "PhaLoc");
	
	var RecLoc = new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>ҽ������</font>',
		id : 'RecLoc',
		name : 'RecLoc',
		emptyText : 'ҽ������...',
		anchor : '90%',
		defaultLoc:''
	});

	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ʼ����</font>',
		id : 'DateFrom',
		anchor : '90%',
		
		value : new Date()
	});
	
	var TimeFrom = new Ext.form.TextField({
		fieldLabel : '��ʼʱ��',
		id : 'TimeFrom',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss'
	});
		
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ֹ����</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		
		value : new Date()
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
		data : [['0', 'ȫ��'], ['1', 'ת��ת��̨��'], ['2', 'ҽ��̨��'], ['3', 'ȫ��(���ڳ�������)']]
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
	Ext.getCmp("TransferFlag").setValue("3");

	/*
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
	*/
	
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

	// ȷ����ť
	var OkBT = new Ext.Toolbar.Button({
				id : "OkBT",
				text : 'ͳ��',
				tooltip : '���ͳ��',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					//ShowReport();
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
					Ext.getCmp("DateFrom").setValue(new Date());
					Ext.getCmp("DateTo").setValue(new Date());
					Ext.getCmp("TransferFlag").setValue('3');
					Ext.getCmp("StkGrpType").getStore().load();
					FlagSum.setValue(true);
					document.getElementById("reportFrame").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
				}
			});
	
	// ��Ʒ����
	var FlagSum = new Ext.form.Radio({
				boxLabel : '��Ʒ����',
				id : 'FlagSum',
				inputValue : 'FlagSum',
				name : 'ReportType',
				checked : true
			});
	// ��Ʒ����(������)
	var FlagSpecDescSum = new Ext.form.Radio({
				boxLabel : '��Ʒ����(������)',
				id : 'FlagSpecDescSum',
				inputValue : 'FlagSpecDescSum',
				name : 'ReportType'
			});
	var FlagStkCatInci = new Ext.form.Radio({
				boxLabel : '�����൥Ʒ����',
				id : 'FlagStkCatInci',
				inputValue : 'FlagStkCatInci',
				name : 'ReportType'
			});
	// ������ϸ
	var FlagDetail = new Ext.form.Radio({
				boxLabel : '��Ʒ��ϸ',
				id : 'FlagDetail',
				inputValue : 'FlagDetail',
				name : 'ReportType'
			});
	// ������ϸ(̨�������)
	var FlagDetailZeroIntr = new Ext.form.Radio({
				boxLabel : '��Ʒ��ϸ(�����)',
				id : 'FlagDetailZeroIntr',
				inputValue : 'FlagDetailZeroIntr',
				name : 'ReportType'
			});
	var FlagDetailNotZeroIntr = new Ext.form.Radio({
				boxLabel : '��Ʒ��ϸ(�������)',
				id : 'FlagDetailNotZeroIntr',
				inputValue : 'FlagDetailNotZeroIntr',
				name : 'ReportType'
			});
	// ������
	var FlagType = new Ext.form.Radio({
				boxLabel : '���������',
				id : 'FlagType',
				inputValue : 'FlagType',
				name : 'ReportType'
			});
			
		function ShowReport() {
			var RecLocId=Ext.getCmp("RecLoc").getValue();
			if(RecLocId == ''){
				Msg.info('warning', '��ѡ��ҽ������!');
				return false;
			}
			var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();
			var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();
			var LocId=Ext.getCmp("PhaLoc").getValue();
			
			var FlagDetail=Ext.getCmp("FlagDetail").getValue();
			var FlagDetailZeroIntr=Ext.getCmp("FlagDetailZeroIntr").getValue();
			var FlagDetailNotZeroIntr=Ext.getCmp("FlagDetailNotZeroIntr").getValue();
			var FlagStkCatInci=Ext.getCmp("FlagStkCatInci").getValue();
			var FlagType=Ext.getCmp("FlagType").getValue();
			var FlagSum=Ext.getCmp("FlagSum").getValue();
			var FlagSpecDescSum=Ext.getCmp("FlagSpecDescSum").getValue();
			
			var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
			var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//������id
			var InciDesc=Ext.getCmp("InciDesc").getValue();				//�����id
			if (InciDesc==null || InciDesc=="") {
				IncRowid = "";
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
			var TransferFlag=Ext.getCmp("TransferFlag").getValue();				//ͳ�Ʒ�ʽ
			var hvFlag=Ext.getCmp("hvFlag").getValue()==true?'Y':'';
			var StartTime=Ext.getCmp("TimeFrom").getValue();
			var EndTime=Ext.getCmp("TimeTo").getValue();
			var TransRange='';
			
			var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
			+"^"+PbLevel+"^"+""+"^"+""+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""
			+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+RecLocId+"^"+hvFlag
			+"^"+StartTime+"^"+EndTime+"^"+TransRange;
			
			var reportframe=document.getElementById("reportFrame")
			var p_URL="";
			//ȡ����ѯ����
			var Conditions=""
			/*
			if(LocId!=""){
				Conditions="�������: "+Ext.getCmp("PhaLoc").getRawValue()
				}
			if(StartDate!=""){
				Conditions=Conditions+" ͳ��ʱ��: "+StartDate+" "+StartTime
				}
		    if(EndDate!=""){
			    Conditions=Conditions+"~ "+EndDate+" "+EndTime
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
				Conditions=Conditions+" ��������: "+InciDesc
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
			if(hvFlag==1){
				Conditions=Conditions+" ��ֵ: �� "
				}
			*/
			//��Ʒ����
			if(FlagSum==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_Sum.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions;
			}
			//��Ʒ����(������)
			else if(FlagSpecDescSum==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_SpecDescSum.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions;
			}
			//�����൥Ʒ����
			else if(FlagStkCatInci==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_StkCatInci.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions;
			}
			//��Ʒ��ϸ
			else if(FlagDetail==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_InciDetail.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions;
			}
			//��Ʒ��ϸ(̨�������) 2018-05-23 ����
			else if(FlagDetailZeroIntr==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_InciDetail_ZeroIntr.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions + '&IntrStatFlag=1';
			}
			//��Ʒ��ϸ(̨�ʷ������) ����
			else if(FlagDetailNotZeroIntr==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_InciDetail_NotZeroIntr.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions + '&IntrStatFlag=2';
			}
			//������
			else if(FlagType==true){
				p_URL = PmRunQianUrl+'?reportName=DHCSTM_TKPYStat_StkCat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+
					'&Conditions='+Conditions;
			}else {
				return false;
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
			tbar : [OkBT, "-", ClearBT],
			items : [{
				xtype : 'fieldset',
				title : '��ѯ����',
				items : [PhaLoc,RecLoc,DateFrom,TimeFrom,DateTo,TimeTo,TransferFlag,StkGrpType,DHCStkCatGroup,
					PhManufacturer,InciDesc,PHCDOfficialType,INFOMT,OperateOutType,Vendor,
					PublicBidding,INFOPBLevel,INFOImportFlag,
					{xtype:'compositefield',fieldLabel:'�ۼ۷�Χ',items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
					{xtype:'compositefield',fieldLabel:'���۷�Χ',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
					{
						xtype:'checkbox',
						boxLabel : '��ֵ��־',
						id : 'hvFlag',
						name : 'hvFlag',
						anchor : '90%',
						checked : false
					},{
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
				items : [FlagSum,FlagSpecDescSum,FlagStkCatInci,FlagDetail,FlagDetailZeroIntr,FlagDetailNotZeroIntr,FlagType]
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
						title:'����&ҽ��̨��ͳ��',
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