// /����: ������ͳ������¼��
// /����:  ������ͳ������¼��
// /��д�ߣ�zhangdongmei
// /��д����: 2012.01.17
var gNewCatId="";
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var UserName=session['LOGON.USERNAME'];
	var PhaLoc=new Ext.ux.LocComboBox({
		fieldLabel : '<font color=blue>'+$g('����')+'</font>',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		emptyText : $g('����...'),
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
	
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>'+$g('��ʼ����')+'</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :DefaultStDate()
	});
	/*
	var StartTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>��ʼʱ��</font>',
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
		width : 120
	});
	*/
	var StartTime=new Ext.form.TextField({
		fieldLabel : $g('��ʼʱ��'),
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		//value :DefaultEdTime(),
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('ʱ���ʽ������ȷ��ʽhh:mm:ss'),
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
	 	alert($g("������ʱ�䣡"))
	 	return  ;
	 	}
		if (Hdate>24)
		{
			alert($g("�����Сʱ��ʽ����Ӧ��0~24֮��..."))
			return ;
			}
		if (Hdate.length<2){
		  var Hdate="0"+Hdate
		}
		
		if (Mdate>60)
		{
			alert($g("����ķ��Ӹ�ʽ����Ӧ��0~60֮��..."))
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
			alert($g("��������ʽ����Ӧ��0~60֮��..."))
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
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>'+$g('��ֹ����')+'</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : DefaultEdDate()
	});
	/*
	var EndTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>��ֹʱ��</font>',
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:'ʱ���ʽ������ȷ��ʽhh:mm:ss',
		width : 120
	});
	*/
	var EndTime=new Ext.form.TextField({
		fieldLabel : $g('��ֹʱ��'),
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		//value :DefaultEdTime(),
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('ʱ���ʽ������ȷ��ʽhh:mm:ss'),
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
				fieldLabel : $g('ҩƷRowId'),
				id : 'InciDr',
				name : 'InciDr',
				valueNotFoundText : ''
			});

	var InciCode = new Ext.form.TextField({
				fieldLabel : $g('ҩƷ����'),
				id : 'InciCode',
				name : 'InciCode',
				anchor : '90%',
				valueNotFoundText : ''
			});
	var InciDesc = new Ext.form.TextField({
				fieldLabel : $g('ҩƷ����'),
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
		fieldLabel : $g('������'),
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
		fieldLabel : $g('ҩѧ����'),
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
		fieldLabel : $g('ҩѧ����'),
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
		fieldLabel :$g( 'ҩѧС��'),
		id : 'PhcMinCat',
		name : 'PhcMinCat',
		store : PhcMinCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{PhcSubCatId:'PhcSubCat'}
	});
var PHCCATALL = new Ext.form.TextField({
	fieldLabel : $g('ҩѧ����'),
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
	text :$g( 'ҩѧ����ά��'),
	handler : function() {	
       PhcCatNewSelect(gNewCatId,GetAllCatNew)

    }
});
	var PHCDFPhcDoDR = new Ext.ux.ComboBox({
		fieldLabel : $g('���Ʒ���'),
		id : 'PHCDFPhcDoDR',
		name : 'PHCDFPhcDoDR',
		store : PhcPoisonStore,
		valueField : 'Description',
		displayField : 'Description'
	});

	var PhManufacturer = new Ext.ux.ComboBox({
		fieldLabel : $g('������ҵ'),
		id : 'PhManufacturer',
		name : 'PhManufacturer',
		store : PhManufacturerStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'PHMNFName'
	});

	var PHCDOfficialType = new Ext.ux.ComboBox({
		fieldLabel :$g( 'ҽ�����'),
		id : 'PHCDOfficialType',
		name : 'PHCDOfficialType',
		store : OfficeCodeStore,
		valueField : 'Description',
		displayField : 'Description'
	});

	var PHCForm = new Ext.ux.ComboBox({
		fieldLabel : $g('����'),
		id : 'PHCForm',
		name : 'PHCForm',
		store : PhcFormStore,
		valueField : 'Description',
		displayField : 'Description',
		filterName:'PHCFDesc'
	});

	var PublicBiddingStore = new Ext.data.SimpleStore({
				fields : ['RowId', 'Description'],
				data : [['1', $g('�б�')], ['0', $g('���б�')]]
			});
	var PublicBidding = new Ext.form.ComboBox({
				fieldLabel : $g('�б�'),
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
					fieldLabel : $g('�б꼶��'),
					id : 'INFOPBLevel',
					name : 'INFOPBLevel',
					store : INFOPBLevelStore,
					valueField : 'RowId',
					displayField : 'Description'
				});

		var RetFlag = new Ext.form.Checkbox({
					boxLabel : $g('�Ƿ�����˻�'),
					id : 'RetFlag',
					name : 'RetFlag',
					anchor : '90%',
					checked : true
				});
		var SpFlag = new Ext.form.Checkbox({
					boxLabel : $g('�����ۼ۲������ۼ�'),
					id : 'SpFlag',
					name : 'SpFlag',
					anchor : '90%',
					checked : false
				});
              var INFOBasicDrug = new Ext.form.Checkbox({
			           boxLabel : $g('����ҩ���־'),
		                  id : 'INFOBasicDrug',
		                  name : 'INFOBasicDrug',
		                  anchor : '90%',
			           checked : false
		                });
		MarkTypeStore.load();
		var INFOMT = new Ext.ux.ComboBox({
					fieldLabel : $g('��������'),
					id : 'INFOMT',
					name : 'INFOMT',
					store : MarkTypeStore,
					valueField : 'RowId',
					displayField : 'Description'
		});
		
				// �������
		var OperateInType = new Ext.ux.ComboBox({
					fieldLabel : $g('�������'),
					id : 'OperateInType',
					name : 'OperateInType',
					store : OperateInTypeStore,
					valueField : 'RowId',
					displayField : 'Description'
				});
		OperateInTypeStore.load();
		
	var ImportStore = new Ext.data.SimpleStore({
		fields : ['RowId', 'Description'],
		data : [[$g('����'), $g('����')], [$g('����'), $g('����')], [$g('����'), $g('����')]]
	});
	var INFOImportFlag = new Ext.form.ComboBox({
			fieldLabel : $g('���ڱ�־'),
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
				fieldLabel : $g('��Ʊ��'),
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
					boxLabel : $g('��ⵥ�б�'),
					id : 'FlagImportDetail',
					name : 'ReportType',
					anchor : '80%',
					checked : true
				});
		// ��Ʒ����
		var FlagItmStat = new Ext.form.Radio({
					boxLabel : $g('��Ʒ����'),
					id : 'FlagItmStat',
					name : 'ReportType',
					anchor : '80%'
				});
		// ��Ӫ��ҵ����
		var FlagVendorStat = new Ext.form.Radio({
					boxLabel : $g('��Ӫ��ҵ����'),
					id : 'FlagVendorStat',
					name : 'ReportType',
					anchor : '80%'
				});
		// ��Ӫ��ҵ��ϸ����
		var FlagVendorItmStat = new Ext.form.Radio({
					boxLabel : $g('��Ӫ��ҵ��ϸ����'),
					id : 'FlagVendorItmStat',
					name : 'ReportType',
					anchor : '80%'
				});	
		// ��Ӫ��ҵ�������
		var FlagVendorStkGrpStat = new Ext.form.Radio({
					boxLabel : $g('��Ӫ��ҵ�������'),
					id : 'FlagVendorStkGrpStat',
					name : 'ReportType',
					anchor : '80%'
				});
		// �������
		var FlagStkGrpStat = new Ext.form.Radio({
					boxLabel : $g('�������'),
					id : 'FlagStkGrpStat',
					name : 'ReportType',
					anchor : '80%'
				});	
		// ���������
		var FlagStockStat = new Ext.form.Radio({
					boxLabel : $g('���������'),
					id : 'FlagStockStat',
					name : 'ReportType',
					anchor : '80%'
				});				
	   // ��ⵥ����
		var FlagRecItmSumStat = new Ext.form.Radio({
					boxLabel : $g('��ⵥ����'),
					id : 'FlagRecItmSumStat',
					name : 'ReportType',
					anchor : '80%'
				});	
	   // ��ⵥ(����)����
		var FlagRpItmSumStat = new Ext.form.Radio({
					boxLabel : $g('��ⵥ(����)����'),
					id : 'FlagRpItmSumStat',
					name : 'ReportType',
					anchor : '80%'
				});	
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : $g('����'),
				tooltip : $g('�������'),
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
					FlagImportDetail.setValue(true);
					RetFlag.setValue(true);
					document.getElementById("frameReport").src=BlankBackGroundImg;
					gNewCatId=""
					Ext.getCmp("PHCCATALL").setValue("");
				}
			});
		// ͳ�ư�ť
		var OkBT = new Ext.Toolbar.Button({
					id : "OkBT",
					text : $g('ͳ��'),
					tooltip : $g('���ͳ��'),
					width : 70,
					iconCls : 'page_find',
					height : 30,
					handler : function() {
						
						ShowReport();
					}
				}); 

		function ShowReport()
		{
			var StartDate=Ext.getCmp("DateFrom").getValue()
			var EndDate=Ext.getCmp("DateTo").getValue()
			if(StartDate==""||EndDate=="")
			{
				Msg.info("warning",$g( "��ʼ���ںͽ�ֹ���ڲ��ܿգ�"));
				return;
			}
			var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();;
			var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();;
		    var startTime=Ext.getCmp("StartTime").getRawValue();
			var endTime=Ext.getCmp("EndTime").getRawValue();
			if(StartDate==EndDate && startTime>endTime){
				Msg.info("warning", $g("��ʼʱ����ڽ�ֹʱ�䣡"));
				return;
			}
			var LocId=Ext.getCmp("PhaLoc").getValue();
			var RetFlag=Ext.getCmp("RetFlag").getValue();
			if(RetFlag==true){
				RetFlag=1;
			}
			else{
				RetFlag=0;
			}
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
			var ManfId=Ext.getCmp("PhManufacturer").getValue();			//������ҵid
			var Form=Ext.getCmp("PHCForm").getValue();					//����
			var InsuType=Ext.getCmp("PHCDOfficialType").getValue();		//ҽ������
			var PosionCat=Ext.getCmp("PHCDFPhcDoDR").getValue();		//���Ʒ���
			var VendorId=Ext.getCmp("Vendor").getValue();				//��Ӫ��ҵid
			var OperateType=Ext.getCmp("OperateInType").getValue();		//�������
			var MinSp=Ext.getCmp("MinSp").getValue();				//����ۼ�
			var MaxSp=Ext.getCmp("MaxSp").getValue();				//����ۼ�
			var MinRp=Ext.getCmp("MinRp").getValue();				//��ͽ���
			var MaxRp=Ext.getCmp("MaxRp").getValue();				//��߽���
			var InvNo=Ext.getCmp("InvNo").getValue();				//��Ʊ��
			
			var SpFlag=0 //Ext.getCmp("SpFlag").getValue();				//�����ۼ۲������ۼ۱�־
			/*if(SpFlag==true){
				SpFlag=1;
			}
			else{
				SpFlag=0;
			}*/
			var INFOBasicDrug=Ext.getCmp("INFOBasicDrug").getValue();				//�����ۼ۲������ۼ۱�־
			if(INFOBasicDrug==true){
				INFOBasicDrug=1;
			}
			else{
				INFOBasicDrug=0;
			}
			
			var FlagImportDetail=Ext.getCmp("FlagImportDetail").getValue();
			var FlagItmStat=Ext.getCmp("FlagItmStat").getValue();
			var FlagVendorStat=Ext.getCmp("FlagVendorStat").getValue();
			var FlagVendorItmStat=Ext.getCmp("FlagVendorItmStat").getValue(); //��Ӫ��ҵ��ϸ����
			var FlagStkGrpStat=Ext.getCmp("FlagStkGrpStat").getValue();        //�������
			var FlagStockStat=Ext.getCmp("FlagStockStat").getValue();       //���������
			var FlagRecItmSumStat=Ext.getCmp("FlagRecItmSumStat").getValue();       //��ⵥ����
			var FlagRpItmSumStat=Ext.getCmp("FlagRpItmSumStat").getValue();      //��ⵥ(����)���� 
			var FlagVendorStkGrpStat=Ext.getCmp("FlagVendorStkGrpStat").getValue(); //��Ӫ��ҵ���� 
			var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
			var Others=GrpType+"^"+StkCatId+"^"+IncRowid+"^"+MarkType+"^"+ImpFlag+"^"+BatNo+"^"+PbFlag
			+"^"+PbLevel+"^"+PhcCatId+"^"+PhcSubCatId+"^"+PhcMinCatId+"^"+ManfId+"^"+Form+"^"+InsuType+"^"+PosionCat
			+"^"+VendorId+"^"+OperateType+"^"+MinSp+"^"+MaxSp+"^"+MinRp+"^"+MaxRp+"^"+InvNo+"^"+SpFlag+"^"+INFOBasicDrug+"^"+gNewCatId;
			var reportFrame=document.getElementById("frameReport");
			var p_URL="";
			//��ⵥ�б�
			if(FlagImportDetail==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=importdetail.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;

				//var lnk="websys.default.csp?WEBSYS.TCOMPONENT=udhcOPHandin.INVDetail&sUser="+sUser+"&uName="+escape(uName)+"&EndDate="+Enddate+"&EndTime="+EndTime+"&StDate="+StDate +"&StartTime=" +StTime;
				//websys_createWindow(p_URL,1,"width=330,height=160,top=20,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
				//var NewWin=open(p_URL,"��ⵥ�б�","top=20,left=20,width=930,height=660,scrollbars=1");
			} 
			//��Ʒ����
			else if(FlagItmStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importitmstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//��Ӫ��ҵ����
			else if(FlagVendorStat==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=importvendorstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//��Ӫ��ҵ��ϸ����
			else if(FlagVendorItmStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importvendoitmrstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//�������
			else if(FlagStkGrpStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importstkgrpstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//���������
			else if(FlagStockStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importstockstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//��ⵥ����
			else if(FlagRecItmSumStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importrecitmsumstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//��ⵥƷ(����)����
			else if(FlagRpItmSumStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importrpitmsumstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
			}
			//��Ӫ��ҵ�������
			else if(FlagVendorStkGrpStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=importvendorstkgrpstat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&RetFlag='+RetFlag+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+UserName+'&RQDTFormat='+RQDTFormat;
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
			tbar : [OkBT,'-',ClearBT],
			items : [{
						xtype : 'fieldset',
						title : $g('��ѯ����'),					
						items : [PhaLoc,DateFrom,StartTime,DateTo,EndTime,Vendor,StkGrpType,DHCStkCatGroup,{xtype:'compositefield',items:[PHCCATALL,PHCCATALLButton]},
							PhManufacturer,PHCForm,PHCDFPhcDoDR,InciDesc,INFOMT,OperateInType,
							INFOImportFlag,PublicBidding,INFOPBLevel,InvNo,
							{xtype:'compositefield',fieldLabel:$g('�ۼ۷�Χ'),items:[MinSp,{xtype:'displayfield',value:'-'},MaxSp]},
							{xtype:'compositefield',fieldLabel:$g('���۷�Χ'),items:[MinRp,{xtype:'displayfield',value:'-'},MaxRp]},
							RetFlag,INFOBasicDrug]  //,SpFlag
					}, {
						xtype : 'fieldset',
						title : $g('��������'),
						items : [FlagImportDetail,FlagItmStat,FlagVendorStat,FlagVendorItmStat,FlagVendorStkGrpStat,FlagStkGrpStat,FlagStockStat,FlagRecItmSumStat,FlagRpItmSumStat]
					}]
		});

	var reportPanel=new Ext.Panel({
		//autoScroll:true,
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" style="border:none" src='+DHCSTBlankBackGround+'>'
	})
	// ҳ�沼��
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [{
					region:'west',
					title:$g("������"),
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