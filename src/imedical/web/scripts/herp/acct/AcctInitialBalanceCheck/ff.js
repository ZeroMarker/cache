// /����: ������ͳ������¼��
// /����:  ������ͳ������¼��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.01.17
Ext.onReady(function() {
//function loadForm1(){
	
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
		format : 'Y-m-d',
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
		format : 'Y-m-d',
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
/*		
	var InciDr = new Ext.form.TextField({
				fieldLabel : '����RowId',
				id : 'InciDr',
				name : 'InciDr',
				valueNotFoundText : ''
			});

	var InciCode = new Ext.form.TextField({
				fieldLabel : '���ʱ���',
				id : 'InciCode',
				name : 'InciCode',
				anchor : '90%',
				valueNotFoundText : ''
			}); */
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
		
		//Ext.getCmp("InciDr").setValue(InciDr);
		//Ext.getCmp("InciCode").setValue(inciCode);
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
					id : 'SpFlag',
					name : 'SpFlag',
					anchor : '90%',
					checked : false
				});
				
		var hvFlag = new Ext.form.Checkbox({
					boxLabel : '��ֵ��־',
					id : 'hvFlag',
					name : 'hvFlag',
					anchor : '90%',
					checked : false
				});		
		
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
				
	var MinSp = new Ext.form.NumberField({
		id : 'MinSp',
		name : 'MinSp',
		width : '70',
		valueNotFoundText : ''
	});
			
	var MaxSp = new Ext.form.NumberField({
		id : 'MaxSp',
		name : 'MaxSp',
		width : '70',
		valueNotFoundText : ''
	});
	var MaxRp = new Ext.form.NumberField({
		id : 'MaxRp',
		name : 'MaxRp',
		width : '70',
		valueNotFoundText : ''
	});
	var MinRp = new Ext.form.NumberField({
		id : 'MinRp',
		name : 'MinRp',
		width : '70',
		valueNotFoundText : ''
	});
	
	// ��ⵥ�б�
	var FlagImportDetail = new Ext.form.Radio({
				boxLabel : '��ⵥ�б�',
				id : 'FlagImportDetail',
				name : 'ReportType',
				anchor : '80%',
				checked : true
			});
	// ��Ʒ����
	var FlagItmStat = new Ext.form.Radio({
				boxLabel : '��Ʒ����',
				id : 'FlagItmStat',
				name : 'ReportType',
				anchor : '80%'
			});
	// ��Ӧ�̻���
	var FlagVendorStat = new Ext.form.Radio({
				boxLabel : '��Ӧ�̻���',
				id : 'FlagVendorStat',
				name : 'ReportType',
				anchor : '80%'
			});
	// ��Ӧ����ϸ����
	var FlagVendorItmStat = new Ext.form.Radio({
				boxLabel : '��Ӧ����ϸ����',
				id : 'FlagVendorItmStat',
				name : 'ReportType',
				anchor : '80%'
			});	
	// ��Ӧ�̿����ཻ�汨��(����)
	var FlagVendorStkcatCross = new Ext.form.Radio({
				boxLabel : '��Ӧ��/�����ཻ�汨��(����)',
				id : 'FlagVendorStkcatCross',
				name : 'ReportType'
			});		
	// �������
	var FlagStkGrpStat = new Ext.form.Radio({
				boxLabel : '�������',
				id : 'FlagStkGrpStat',
				name : 'ReportType',
				anchor : '80%'
			});	
	// ���������
	var FlagStockStat = new Ext.form.Radio({
				boxLabel : '���������',
				id : 'FlagStockStat',
				name : 'ReportType',
				anchor : '80%'
			});				
   // ��ⵥ����
	var FlagRecItmSumStat = new Ext.form.Radio({
				boxLabel : '��ⵥ����',
				id : 'FlagRecItmSumStat',
				name : 'ReportType',
				anchor : '80%'
			});	
   // ��ⵥ(����)����
	var FlagRpItmSumStat = new Ext.form.Radio({
				boxLabel : '��ⵥ(����)����',
				id : 'FlagRpItmSumStat',
				name : 'ReportType',
				anchor : '80%'
			});			
	
	var ClearBT = new Ext.Toolbar.Button({
			id : "ClearBT",
			text : '���',
			tooltip : '������',
			width : 70,
			height : 30,
			iconCls : 'page_refresh',
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
			var StartDate=Ext.getCmp("DateFrom").getValue().format('Y-m-d').toString();;
			var EndDate=Ext.getCmp("DateTo").getValue().format('Y-m-d').toString();;
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
			var FlagImportDetail=Ext.getCmp("FlagImportDetail").getValue();
			var FlagItmStat=Ext.getCmp("FlagItmStat").getValue();
			var FlagVendorStat=Ext.getCmp("FlagVendorStat").getValue();
			var FlagVendorItmStat=Ext.getCmp("FlagVendorItmStat").getValue(); //��Ӧ����ϸ����
			var FlagVendorStkcatCross=Ext.getCmp("FlagVendorStkcatCross").getValue(); //��Ӧ�̿����ཻ��ͳ��
			var FlagStkGrpStat=Ext.getCmp("FlagStkGrpStat").getValue();        //�������
			var FlagStockStat=Ext.getCmp("FlagStockStat").getValue();       //���������
			var FlagRecItmSumStat=Ext.getCmp("FlagRecItmSumStat").getValue();       //��ⵥ����
			var FlagRpItmSumStat=Ext.getCmp("FlagRpItmSumStat").getValue();      //��ⵥ(����)���� 
			
			var hvFlag=(Ext.getCmp("hvFlag").getValue()==true?1:0);  //��ֵ��־
			var TimeFrom=Ext.getCmp("TimeFrom").getValue();
			var TimeTo=Ext.getCmp("TimeTo").getValue();
			var RetFlag=Ext.getCmp("RetFlag").getValue();		  //ͳ�Ʒ�ʽ
            
			var Others=GrpType+"^"+StkCatId+"^"+inciDr+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
			+"^"+PbLevel+"^"+""+"^"+""+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""
			+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+InvNo+"^"+SpFlag+"^"+hvFlag+"^"+TimeFrom+"^"+TimeTo;
			//��ȡ��ѯ�����б�
			var Conditions=""
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
						
						ShowReport();
					}
				}); 

		function ShowReport()
		{   
			var StartDate=Ext.getCmp("DateFrom").getValue().format('Y-m-d').toString();;
			var EndDate=Ext.getCmp("DateTo").getValue().format('Y-m-d').toString();;
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
			var FlagImportDetail=Ext.getCmp("FlagImportDetail").getValue();
			var FlagItmStat=Ext.getCmp("FlagItmStat").getValue();
			var FlagVendorStat=Ext.getCmp("FlagVendorStat").getValue();
			var FlagVendorItmStat=Ext.getCmp("FlagVendorItmStat").getValue(); //��Ӧ����ϸ����
			var FlagVendorStkcatCross=Ext.getCmp("FlagVendorStkcatCross").getValue();  //��Ӧ�̿����ཻ��ͳ��
			var FlagStkGrpStat=Ext.getCmp("FlagStkGrpStat").getValue();        //�������
			var FlagStockStat=Ext.getCmp("FlagStockStat").getValue();       //���������
			var FlagRecItmSumStat=Ext.getCmp("FlagRecItmSumStat").getValue();       //��ⵥ����
			var FlagRpItmSumStat=Ext.getCmp("FlagRpItmSumStat").getValue();      //��ⵥ(����)���� 
			
			var hvFlag=(Ext.getCmp("hvFlag").getValue()==true?1:0);  //��ֵ��־
			var TimeFrom=Ext.getCmp("TimeFrom").getValue();
			var TimeTo=Ext.getCmp("TimeTo").getValue();
			var RetFlag=Ext.getCmp("RetFlag").getValue();		  //ͳ�Ʒ�ʽ
 
			var Others=GrpType+"^"+StkCatId+"^"+inciDr+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
			+"^"+PbLevel+"^"+""+"^"+""+"^"+""+"^"+ManfId+"^"+""+"^"+InsuType+"^"+""
			+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+InvNo+"^"+SpFlag+"^"+hvFlag+"^"+TimeFrom+"^"+TimeTo;
			
			var reportFrame=document.getElementById("frameReport");
			var p_URL="";
			//��ȡ��ѯ�����б�
			var Conditions=""
			if(LocId!=""){
				Conditions="����: "+Ext.getCmp("PhaLoc").getRawValue()
				}
		    if(Ext.getCmp("DateFrom").getValue()!=""){
			     Conditions=Conditions+" ͳ��ʱ��: "+StartDate+" "+TimeFrom
			     }
			if(Ext.getCmp("DateTo").getValue()!=""){
				Conditions=Conditions+"~ "+EndDate+" "+TimeTo
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
			if(inciDr!=""){
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
			if(hvFlag==1){
				Conditions=Conditions+" ��ֵ: ��"
				}
			if(RetFlag!=""){
			    Conditions=Conditions+" ͳ�Ʒ�ʽ: "+Ext.getCmp("RetFlag").getRawValue()
	        	}							  			  
			//��ȡ��ѯ�����б�
			//��ⵥ�б�
			if(FlagImportDetail==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCSTM_importdetail.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
				
				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"��ⵥ�б�","top=20,left=20,width=930,height=660,scrollbars=1");
			} 
			//��Ʒ����
			else if(FlagItmStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCSTM_importitmstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
			
				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"��Ʒ����","top=20,left=20,width=930,height=660,scrollbars=1");
			}
			//��Ӧ�̻���
			else if(FlagVendorStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCSTM_importvendorstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
			
				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"��Ӧ�̻���","top=20,left=20,width=930,height=660,scrollbars=1");
			}
			//��Ӧ����ϸ����
			else if(FlagVendorItmStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCSTM_importvendoitmrstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
			
				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"��Ӧ�̻���","top=20,left=20,width=930,height=660,scrollbars=1");
			}
			//��Ӧ�̿����ཻ�汨��(����)
			else if(FlagVendorStkcatCross==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCSTM_importvendorstkcatcross.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
			
				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"��Ӧ�̻���","top=20,left=20,width=930,height=660,scrollbars=1");
			}
			//�������
			else if(FlagStkGrpStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCSTM_importstkgrpstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
			
				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"��Ӧ�̻���","top=20,left=20,width=930,height=660,scrollbars=1");
			}
			//���������
			else if(FlagStockStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCSTM_importstockstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
			
				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"��Ӧ�̻���","top=20,left=20,width=930,height=660,scrollbars=1");
			}
			//��ⵥ����
			else if(FlagRecItmSumStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCSTM_importrecitmsumstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
			
				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"��Ӧ�̻���","top=20,left=20,width=930,height=660,scrollbars=1");
			}
			//��ⵥƷ(����)����
			else if(FlagRpItmSumStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCSTM_importrpitmsumstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
			
				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"��Ӧ�̻���","top=20,left=20,width=930,height=660,scrollbars=1");
			}
			//��ⵥ�б�
			else{
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCSTM_importdetail.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&Conditions='+Conditions+'&RetFlag='+RetFlag;
			
				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"��ⵥ�б�","top=20,left=20,width=930,height=660,scrollbars=1");
			}
			
			reportFrame.src=p_URL;
			
			//window.open (p_URL, 'newwindow', 'height=100, width=400, top=0, left=0, toolbar=no, menubar=no, scrollbars=no,resizable=no,location=no, status=no'); 
		}
		var HisListTab = new Ext.form.FormPanel({
			id : 'HisListTab',
			labelWidth : 60,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:5px;',
			tbar : [OkBT,'-',ClearBT,'-',PrintBT],
			items : [{
						xtype : 'fieldset',
						title : '��ѯ����',					
						items : [PhaLoc,DateFrom,TimeFrom,DateTo,TimeTo,RetFlag,Vendor,StkGrpType,DHCStkCatGroup,
							PhManufacturer,InciDesc,PHCDOfficialType,INFOMT,OperateInType,
							INFOImportFlag,PublicBidding,INFOPBLevel,InvNo,
							{xtype:'compositefield',fieldLabel:'�ۼ۷�Χ',items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
							{xtype:'compositefield',fieldLabel:'���۷�Χ',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
							SpFlag,hvFlag,usedFlag]
					}, {
						xtype : 'fieldset',
						title : '��������',
						items : [FlagImportDetail,FlagItmStat,FlagVendorStat,FlagVendorItmStat,FlagVendorStkcatCross,FlagStkGrpStat,FlagStockStat,FlagRecItmSumStat,FlagRpItmSumStat]
					}]
		});

	var reportPanel=new Ext.Panel({
		autoScroll:true,
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	})
		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
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
						items:reportPanel
					}]
				});
				
	/*
	 obj.pnDisplay = new Ext.Panel({
region : 'center'
,autoScroll : true
,layout : 'fit'
,html : '<iframe id="iframeResult" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg" />'
});

obj.WinControl = new Ext.Viewport({
id: 'WinControl'
,layout : 'border'
,items: [
obj.pnDisplay
,obj.ConditionPanel
]
});

obj.btnQuery_click = function()
{
var objIFrame = document.getElementById("iframeResult");
//var strUrl = "./dhccpmrunqianreport.csp?reportName=DHCMed.NINF.INFControlSta.raq" +
var strUrl = "./dhccpmrunqianreportgroup.csp?reportName=DHCMed.NINF.INFControlSta.rpg" + //Modifed By LiYang 2012-12-09 ����������
"&FromDate=" + obj.dfDateFrom.getRawValue() +
"&ToDate=" + obj.dfDateTo.getRawValue() +
"&LocList=" + obj.cboLoc.getValue() +
"&WardList=" + obj.cboWard.getValue();
if(obj.radioAdmitDate.getValue())
strUrl += "&DateType=1";
if(obj.radioDisDate.getValue())
strUrl += "&DateType=2";
if(obj.radioInHospital.getValue())
strUrl += "&DateType=3";
if(obj.radioDepTypeD.getValue())
strUrl += "&DepType=1";
if(obj.radioDepTypeW.getValue())
strUrl += "&DepType=2";
objIFrame.src = strUrl;
}

	 * */

	
});