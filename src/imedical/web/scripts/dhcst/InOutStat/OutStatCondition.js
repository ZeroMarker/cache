// /����: �������ͳ������¼��
// /����: �������ͳ������¼��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.11.12
var gNewCatId="";
Ext.onReady(function() {
	// function loadForm1(){

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var UserName=session['LOGON.USERNAME'];
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>�������</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : '����...',
		groupId:gGroupId,
		listeners : {
			'select' : function(e) {
                          var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx ����ѡ��Ŀ��Ҷ�̬��������
                          StkGrpType.getStore().removeAll();
                          StkGrpType.getStore().setBaseParam("locId",SelLocId)
                          StkGrpType.getStore().setBaseParam("userId",UserId)
                          StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
                          StkGrpType.getStore().load();
			}
	}
	});

	var RecLoc = new Ext.ux.LocComboBox({
		fieldLabel : '���տ���',
		id : 'RecLoc',
		name : 'RecLoc',
		emptyText : '���տ���...',
		anchor : '90%',
		defaultLoc:''
	});

	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ʼ����</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :DefaultStDate()
	});

	var StartTime=new Ext.form.TextField({
		fieldLabel : '��ʼʱ��',
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		//value :DefaultEdTime(),
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
		width : 120,
		//value :DefaultEdTime(),
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var item=field.getValue();
					if (item != null && item.length > 0) {
						var eTime=SetCorrectTimetype(item);
						Ext.getCmp("StartTime").setValue(eTime);
					}
				}
			}
		}
	});
	//--------------------add by myq 20140414 ����ͬ����ׯ




 //-----------------��ʱ���趨��ȷ�ĸ�ʽ add by myq 20140420 
	function SetCorrectTimetype(item) {
	 //���¼�����Ϣ�ں��С������� ������
	 if (item.indexOf(":") > 0)
	 {
	 return item ;
	 }
	 	
	 var datelength=item.length
	 var Hdate=item.substring(0,2) ;
	 var Mdate=item.substring(2,4) ;
	 var Sdate=item.substring(4,6) ;
	 
	 if (datelength<1)
	 {
	 	alert("������ʱ�䣡")
	 	return  ;
	 	}
		if (Hdate>24)
		{
			alert("�����Сʱ��ʽ����Ӧ��0~24֮��...")
			return ;
			}
		if (Hdate.length<2){
		  var Hdate="0"+Hdate
		}
		
		if (Mdate>60)
		{
			alert("����ķ��Ӹ�ʽ����Ӧ��0~60֮��...")
			return ;
			}
		if (Mdate.length<1){
		  var Mdate="00"
		}
		if ((Mdate.length<2)&&(Mdate.length>0)){
		  var Mdate=Mdate+"0"
		}
		
			if (Sdate>60)
		{
			alert("��������ʽ����Ӧ��0~60֮��...")
			return ;
			}
		if (Sdate.length<1){
		  var Sdate="00"
		}
		if ((Sdate.length<2)&&(Sdate.length>0)) {
			var Sdate=Sdate+"0"
			}
		
		var result= Hdate+":"+Mdate+":"+Sdate
		
		 return result ;
		
	}
	//-----------------��ʱ���趨��ȷ�ĸ�ʽ add by myq 20140420 	
	var EndTime=new Ext.form.TextField({
		fieldLabel : '��ֹʱ��',
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		//value :DefaultEdTime(),
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
		width : 120,
		//value :DefaultEdTime(),
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var item=field.getValue();
					if (item != null && item.length > 0) {
						var eTime=SetCorrectTimetype(item);
						Ext.getCmp("EndTime").setValue(eTime);
					}
				}
			}
		}
	});
	//--------------------add by myq 20140414 ����ͬ����ׯ
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ֹ����</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : DefaultEdDate()
	});
	
	// ҩƷ����
	var StkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'StkGrpType',
		name : 'StkGrpType',
		anchor : '90%',
		StkType:App_StkTypeCode,     //��ʶ��������
		LocId:gLocId,
		UserId:gUserId
	}); 

	var InciDr = new Ext.form.TextField({
		fieldLabel : 'ҩƷRowId',
		id : 'InciDr',
		name : 'InciDr',
		anchor : '90%',
		valueNotFoundText : ''
	});

	var InciCode = new Ext.form.TextField({
		fieldLabel : 'ҩƷ����',
		id : 'InciCode',
		name : 'InciCode',
		anchor : '90%',
		valueNotFoundText : ''
	});
	var InciDesc = new Ext.form.TextField({
		fieldLabel : 'ҩƷ����',
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
	 * ����ҩƷ���岢���ؽ��
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
		var inciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDr").setValue(inciDr);
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
		anchor : '90%'
	});
				
	// ҩѧ����
	var PhcCat = new Ext.ux.ComboBox({
		fieldLabel : 'ҩѧ����',
		id : 'PhcCat',
		name : 'PhcCat',
		store : PhcCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PhccDesc'
	});

	PhcCat.on('change', function(e) {
		Ext.getCmp('PhcSubCat').setValue("");
		Ext.getCmp('PhcMinCat').setValue("");
	});

	// ҩѧ����
	var PhcSubCat = new Ext.ux.ComboBox({
		fieldLabel : 'ҩѧ����',
		id : 'PhcSubCat',
		name : 'PhcSubCat',
		store : PhcSubCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{PhcCatId:'PhcCat'}
	});

	PhcSubCat.on('change', function(e) {
		Ext.getCmp('PhcMinCat').setValue("");
	});

	// ҩѧС��
	var PhcMinCat = new Ext.ux.ComboBox({
		fieldLabel : 'ҩѧС��',
		id : 'PhcMinCat',
		name : 'PhcMinCat',
		store : PhcMinCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{PhcSubCatId:'PhcSubCat'}
	});
	var PHCCATALL = new Ext.form.TextField({
	fieldLabel : 'ҩѧ����',
	id : 'PHCCATALL',
	name : 'PHCCATALL',
	width: 70,
	anchor : '90%',
	readOnly : true,
	valueNotFoundText : ''
});
//GetAllCatNew("kkk");
function GetAllCatNew(catdescstr,newcatid){
	//if ((catdescstr=="")&&(newcatid=="")) {return;}
	Ext.getCmp("PHCCATALL").setValue(catdescstr);
	gNewCatId=newcatid;
	
	
}

var PHCCATALLButton = new Ext.Button({
	id:'PHCCATALLButton',
	text : 'ҩѧ����ά��',
	handler : function() {	
       PhcCatNewSelect(gNewCatId,GetAllCatNew)

    }
});

	var PHCDFPhcDoDR = new Ext.ux.ComboBox({
		fieldLabel : '���Ʒ���',
		id : 'PHCDFPhcDoDR',
		name : 'PHCDFPhcDoDR',
		store : PhcPoisonStore,
		valueField : 'Description',
		displayField : 'Description'
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel : '��������',
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName'
	});

	/*var PHCDOfficialType = new Ext.ux.ComboBox({
		fieldLabel : 'ҽ�����',
		id : 'PHCDOfficialType',
		name : 'PHCDOfficialType',
		anchor : '90%',
		store : OfficeCodeStore,
		valueField : 'RowId',
		displayField : 'Description'
	});*/

	var PHCForm = new Ext.ux.ComboBox({
		fieldLabel : '����',
		id : 'PHCForm',
		name : 'PHCForm',
		store : PhcFormStore,
		valueField : 'Description',
		displayField : 'Description',
		filterName:'PHCFDesc'
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
	Ext.getCmp("TransferFlag").setValue("0");

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

					ShowReport();
				}
			});
	
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : '����',
				tooltip : '�������',
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
					Ext.getCmp("PHCCATALL").setValue("");
					SetLogInDept(PhaLoc.getStore(),'PhaLoc');
					Ext.getCmp("DateFrom").setValue(DefaultStDate());
					Ext.getCmp("DateTo").setValue(DefaultEdDate());
					Ext.getCmp("StkGrpType").getStore().load();
					FlagLocStkcat.setValue(true);
					document.getElementById("reportFrame").src=BlankBackGroundImg;
					gNewCatId=""
					Ext.getCmp("PHCCATALL").setValue("");
				}
			});
	// ���ҿ�����
	var FlagLocStkcat = new Ext.form.Radio({
				boxLabel : '����/������',
				id : 'FlagLocStkcat',
				name : 'ReportType',
				anchor : '70%',
				checked : true
			});
	// ���ҽ��
	var FlagLoc = new Ext.form.Radio({
				boxLabel : '���ҽ��',
				id : 'FlagLoc',
				name : 'ReportType',
				anchor : '70%'
			});
	// ���ҽ��/����ͳ��
	var FlagLocGrp = new Ext.form.Radio({
				boxLabel : '���ҽ��/������',
				id : 'FlagLocGrp',
				name : 'ReportType',
				anchor : '70%'
			});
	// ��Ʒ����
	var FlagSum = new Ext.form.Radio({
				boxLabel : '��Ʒ����',
				id : 'FlagSum',
				name : 'ReportType',
				anchor : '70%'
			});
	// ���ҵ�Ʒ����
	var FlagLocSum = new Ext.form.Radio({
				boxLabel : '���ҵ�Ʒ����',
				id : 'FlagLocSum',
				name : 'ReportType',
				anchor : '70%'
			});
	// ������ϸ
	var FlagDetail = new Ext.form.Radio({
				boxLabel : '������ϸ',
				id : 'FlagDetail',
				name : 'ReportType',
				anchor : '70%'
			});
  // ���ⵥ����
	var FlagTrf = new Ext.form.Radio({
				boxLabel : '���ⵥ����',
				id : 'FlagTrf',
				name : 'ReportType',
				anchor : '70%'
			});
	// ������
	var FlagType = new Ext.form.Radio({
				boxLabel : '������',
				id : 'FlagType',
				name : 'ReportType',
				anchor : '70%'
			});		

		function ShowReport() {
			var StartDate=Ext.getCmp("DateFrom").getValue()
			var EndDate=Ext.getCmp("DateTo").getValue()
			if(StartDate==""||EndDate=="")
			{
				Msg.info("warning", "��ʼ���ںͽ�ֹ���ڲ��ܿգ�");
				return;
			}
			var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();;
			var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();;
		    var startTime=Ext.getCmp("StartTime").getRawValue();
			var endTime=Ext.getCmp("EndTime").getRawValue();
			if(StartDate==EndDate && startTime>endTime){
				Msg.info("warning", "��ʼʱ����ڽ�ֹʱ�䣡");
				return;
			}
			var LocId=Ext.getCmp("PhaLoc").getValue();
			
			var FlagLocStkcat=Ext.getCmp("FlagLocStkcat").getValue();
			var FlagLoc=Ext.getCmp("FlagLoc").getValue();
			var FlagLocGrp=Ext.getCmp("FlagLocGrp").getValue();
			var FlagDetail=Ext.getCmp("FlagDetail").getValue();
			var FlagTrf=Ext.getCmp("FlagTrf").getValue();
			var FlagType=Ext.getCmp("FlagType").getValue();
			var FlagLocSum=Ext.getCmp("FlagLocSum").getValue();
			var FlagSum=Ext.getCmp("FlagSum").getValue();
			
			var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
			var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//������id
			var IncRowid=Ext.getCmp("InciDr").getValue();				//�����id
			if (IncRowid == undefined) {
				IncRowid = "";
			}
			var InciDesc=Ext.getCmp("InciDesc").getValue();
			if(InciDesc==null || InciDesc==""){
				IncRowid="";
			}
			var MarkType=Ext.getCmp("INFOMT").getValue();				//��������
			var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();		//���ڱ�־
			var BatNo='';											//��������
			var PbFlag=Ext.getCmp("PublicBidding").getValue();		//�б��־
			var PbLevel=Ext.getCmp("INFOPBLevel").getValue();			//�б꼶��
			var PhcCatId=Ext.getCmp("PhcCat").getValue();				//ҩѧ����id
			var PhcSubCatId=Ext.getCmp("PhcSubCat").getValue();			//ҩѧ����id
			var PhcMinCatId=Ext.getCmp("PhcMinCat").getValue();			//ҩѧС��id
			var ManfId=Ext.getCmp("PhManufacturer").getValue();			//��������id
			var Form=Ext.getCmp("PHCForm").getValue();					//����
			var InsuType="" //Ext.getCmp("PHCDOfficialType").getValue();		//ҽ������
			var PosionCat=Ext.getCmp("PHCDFPhcDoDR").getValue();		//���Ʒ���
			var VendorId=Ext.getCmp("Vendor").getValue();				//��Ӧ��id
			var OperateType=Ext.getCmp("OperateOutType").getValue();		//��������
			var MinSp=Ext.getCmp("MinSp").getValue();				//����ۼ�
			var MaxSp=Ext.getCmp("MaxSp").getValue();				//����ۼ�
			var MinRp=Ext.getCmp("MinRp").getValue();				//��ͽ���
			var MaxRp=Ext.getCmp("MaxRp").getValue();				//��߽���
			var RecLocId=Ext.getCmp("RecLoc").getValue();			//���տ���
			var TransferFlag=Ext.getCmp("TransferFlag").getValue();				//ͳ�Ʒ�ʽ
			
			var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
			+"^"+PbLevel+"^"+PhcCatId+"^"+PhcSubCatId+"^"+PhcMinCatId+"^"+ManfId+"^"+Form+"^"+InsuType+"^"+PosionCat
			+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+RecLocId+"^"+gNewCatId;
			var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
			var reportframe=document.getElementById("reportFrame")
			var p_URL="";
			
			//���ҿ�����
			if(FlagLocStkcat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-LocStkcat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			
				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"�������-����/������","top=20,left=20,width=930,height=660,scrollbars=1");
			} 
			//���ҽ��
			else if(FlagLoc==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-Loc.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
						}
			//������
			else if(FlagLocGrp==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-LocGrp.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//��Ʒ����
			else if(FlagSum==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-Sum.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//���ҵ�Ʒ����
			else if(FlagLocSum==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-LocSum.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//������ϸ
			else if(FlagDetail==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-Detail.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//���ⵥ����
			else if(FlagTrf==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-Trf.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//������
			else if(FlagType==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransferOutStat-Type.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&TransferFlag='+TransferFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
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
				items : [PhaLoc,DateFrom,StartTime,DateTo,EndTime,TransferFlag,RecLoc,StkGrpType,DHCStkCatGroup,{xtype:'compositefield',items:[PHCCATALL,PHCCATALLButton]},
				PhManufacturer,PHCForm,PHCDFPhcDoDR,InciDesc,INFOMT,OperateOutType,Vendor,
				PublicBidding,INFOPBLevel,INFOImportFlag,
				{xtype:'compositefield',fieldLabel:'�ۼ۷�Χ',items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
				{xtype:'compositefield',fieldLabel:'���۷�Χ',items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]}]
											
			}, {
				xtype : 'fieldset',
				title : '��������',
				labelWidth : 40,
				items : [FlagLocStkcat,FlagLoc,FlagLocGrp,FlagSum,FlagLocSum,FlagDetail,FlagTrf,FlagType]
			}]
		});

		var reportPanel=new Ext.Panel({
			//autoScroll:true,
			//frame:true,
			html:'<iframe id="reportFrame" height="100%" width="100%" style="border:none" src='+DHCSTBlankBackGround+'>'

		})
		// ҳ�沼��
		var mainPanel = new Ext.Viewport({
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
						items:reportPanel
					}]
				});

	
});