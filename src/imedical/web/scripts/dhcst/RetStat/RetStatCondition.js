// /����: �˻�����ͳ������¼��
// /����:  �˻�����ͳ������¼��
// /��д�ߣ�wyx
// /��д����: 2013.12.12
Ext.onReady(function() {
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var gUserName=session['LOGON.USERNAME'];
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
	
	var StartTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>'+$g('��ʼʱ��')+'</font>',
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('ʱ���ʽ������ȷ��ʽhh:mm:ss'),
		width : 120
	});	
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>'+$g('��ֹ����')+'</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : DefaultEdDate()
	});
	var EndTime=new Ext.form.TextField({
		fieldLabel : '<font color=blue>'+$g('��ֹʱ��')+'</font>',
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('ʱ���ʽ������ȷ��ʽhh:mm:ss'),
		width : 120
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
		fieldLabel :$g( '������'),
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
		fieldLabel : $g('ҩѧС��'),
		id : 'PhcMinCat',
		name : 'PhcMinCat',
		store : PhcMinCatStore,
		valueField : 'RowId',
		displayField : 'Description',
		params:{PhcSubCatId:'PhcSubCat'}
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
	var RetReason = new Ext.ux.ComboBox({
		fieldLabel : $g('�˻�ԭ��'),
		id : 'RetReason',
		name : 'RetReason',
		store : ReasonForReturnStore,
		valueField : 'RowId',
		displayField : 'Description',
		filterName:'ReasonDesc'
	});

	var PHCDOfficialType = new Ext.ux.ComboBox({
		fieldLabel : $g('ҽ�����'),
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


		MarkTypeStore.load();
		var INFOMT = new Ext.ux.ComboBox({
					fieldLabel : $g('��������'),
					id : 'INFOMT',
					name : 'INFOMT',
					store : MarkTypeStore,
					valueField : 'RowId',
					displayField : 'Description'
		});

		// �˻�����ϸ�б�
		var FlagRetStatDetail = new Ext.form.Radio({
					boxLabel : $g('�˻�����ϸ'),
					id : 'FlagRetStatDetail',
					name : 'ReportType',
					anchor : '80%',
					checked : true
				});
		// �˻�������
		var FlagRetStat = new Ext.form.Radio({
					boxLabel : $g('�˻�������'),
					id : 'FlagRetStat',
					name : 'ReportType',
					anchor : '80%'
				});
		// �˻���Ʒ����
		var FlagRetStatInci = new Ext.form.Radio({
					boxLabel : $g('�˻���Ʒ����'),
					id : 'FlagRetStatInci',
					name : 'ReportType',
					anchor : '80%'
				});
		// ��Ӫ��ҵ����
		var FlagRetStatVendor = new Ext.form.Radio({
					boxLabel : $g('��Ӫ��ҵ����'),
					id : 'FlagRetStatVendor',
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
					SetLogInDept(PhaLoc.getStore(),'PhaLoc');
					Ext.getCmp("DateFrom").setValue(DefaultStDate());
					Ext.getCmp("DateTo").setValue(DefaultEdDate());
					Ext.getCmp("StkGrpType").getStore().load();
					//FlagImportDetail.setValue(true);
					document.getElementById("frameReport").src=BlankBackGroundImg;
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
			var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();;
			var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();;
		    var startTime=Ext.getCmp("StartTime").getRawValue();
			var endTime=Ext.getCmp("EndTime").getRawValue();
			var LocId=Ext.getCmp("PhaLoc").getValue();
			var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
			var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//������id
			var IncRowid=Ext.getCmp("InciDr").getValue();				//�����id
			var IncDesc=Ext.getCmp("InciDesc").getValue();
			if ((IncRowid == undefined)||(IncDesc=="")) {
				IncRowid = "";
			}
			var MarkType=Ext.getCmp("INFOMT").getValue();				//��������
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
			var FlagRetStatDetail=Ext.getCmp("FlagRetStatDetail").getValue();
			var FlagRetStat=Ext.getCmp("FlagRetStat").getValue();
			var FlagRetStatInci=Ext.getCmp("FlagRetStatInci").getValue();
			var FlagRetStatVendor=Ext.getCmp("FlagRetStatVendor").getValue(); //��Ӫ��ҵ��ϸ����
			var FlagRetReason=Ext.getCmp("RetReason").getValue();
			var FlagType=""
			if (FlagRetStatDetail==true) {FlagType="1"}
			if (FlagRetStat==true) {FlagType="2"}
			if (FlagRetStatInci==true) {FlagType="3"}
			if (FlagRetStatVendor==true) {FlagType="4"}
			var Others=GrpType+"^"+IncRowid+"^"+VendorId+"^"+FlagRetReason+"^"+FlagType;
			var LocDesc=Ext.getCmp("PhaLoc").getRawValue();
			var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
			var reportFrame=document.getElementById("frameReport");
			var p_URL="";
			//�˻�����ϸ�б�
			if(FlagRetStatDetail==true){				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_RetStat_Detail_Common.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+"&UserName="+gUserName+"&HospDesc="+App_LogonHospDesc+"&LocDesc="+LocDesc+'&RQDTFormat='+RQDTFormat;
			} 
			//�˻�������
			else if(FlagRetStat==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_RetStat_All_Common.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+"&UserName="+gUserName+"&HospDesc="+App_LogonHospDesc+"&LocDesc="+LocDesc+'&RQDTFormat='+RQDTFormat;
			}
			//�˻���Ʒ����
			else if(FlagRetStatInci==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_RetStat_Inci_Common.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+"&UserName="+gUserName+"&HospDesc="+App_LogonHospDesc+"&LocDesc="+LocDesc+'&RQDTFormat='+RQDTFormat;
			}
			//��Ӫ��ҵ����
			else if(FlagRetStatVendor==true){
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_RetStat_Vendor_Common.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+"&UserName="+gUserName+"&HospDesc="+App_LogonHospDesc+"&LocDesc="+LocDesc+'&RQDTFormat='+RQDTFormat;
			}
			reportFrame.src=p_URL;
	       
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
						items : [PhaLoc,DateFrom,StartTime,DateTo,EndTime,Vendor,StkGrpType,RetReason,InciDesc]
					}, {
						xtype : 'fieldset',
						title : $g('��������'),
						items : [FlagRetStatDetail,FlagRetStat,FlagRetStatInci,FlagRetStatVendor]
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
						title:$g("�˻�����"),
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