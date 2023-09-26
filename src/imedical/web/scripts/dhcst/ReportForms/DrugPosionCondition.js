// /����: dhcst.drugposioncondition.csp
// /����: ����ҩƷ�������Լ������ȼ�
// /��д�ߣ�Yanbl
// /��д����: 2019-10-18
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
	var gUserName=session['LOGON.USERNAME'];
	
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ʼ����</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :new Date()
	});
	
	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ֹ����</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : new Date()
	});
	
	var InciDr = new Ext.form.TextField({
				fieldLabel : 'ҩƷRowId',
				id : 'InciDr',
				name : 'InciDr',
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
							var inputText=field.getValue();
							GetPhaOrderInfo(inputText,"");
						}
					}
				}
			});
	//���Ʒ���
	var PHCDFPhcDoDR = new Ext.ux.ComboBox({
			fieldLabel : '���Ʒ���',
			id : 'PHCDFPhcDoDR',
			name : 'PHCDFPhcDoDR',
			store : PhcPoisonStore,
			valueField : 'RowId',
			displayField : 'Description'
			});
	// ��������
	var PoisonStat = new Ext.form.Radio({
				boxLabel : '��������(������)',
				id : 'PoisonStat',
				name : 'ReportType',
				anchor : '80%',
				checked : true
			});
	// ����ͳ��
	var PoisonDetail = new Ext.form.Radio({
				boxLabel : '����ͳ��(������)',
				id : 'PoisonDetail',
				name : 'ReportType',
				anchor : '80%',
				checked : false
			});
			
	// �������ҩ��ռ��
	var BasiOutStat = new Ext.form.Radio({
				boxLabel : '�������ҩ��ռ��',
				id : 'BasiOutStat',
				name : 'ReportType',
				anchor : '80%',
				checked : false
			});
	// סԺ����ҩ��ҩռ��
	var BasiInStat = new Ext.form.Radio({
				boxLabel : 'סԺ����ҩ��ռ��',
				id : 'BasiInStat',
				name : 'ReportType',
				anchor : '80%',
				checked : false
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
		var inciRowid = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDr").setValue(inciRowid);
		Ext.getCmp("InciDesc").setValue(inciDesc);
	}


		

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
					Ext.getCmp("DateFrom").setValue(new Date());
					Ext.getCmp("DateTo").setValue(new Date());
					Ext.getCmp("PoisonStat").setValue(true);
					document.getElementById("frameReport").src=DHCSTBlankBackGround;
				}
			});
		// ͳ�ư�ť
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
			var StartDate=Ext.getCmp("DateFrom").getValue()
			var EndDate=Ext.getCmp("DateTo").getValue()
			if(StartDate==""||EndDate=="")
			{
				Msg.info("warning", "��ʼ���ںͽ�ֹ���ڲ��ܿգ�");
				return;
			}
			var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();
			var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();
			var LocId=gLocId
			var LocDesc=App_LogonLocDesc
			var incidesc=Ext.getCmp("InciDesc").getValue();
			if ((incidesc==null)||(incidesc==""))
			{
				Ext.getCmp("InciDr").setValue("");
			}
		
			var IncRowid=Ext.getCmp("InciDr").getValue();				//�����id
			if (IncRowid == undefined) {
				IncRowid = "";
			}	
			var PoisonStat=Ext.getCmp("PoisonStat").getValue();
			var PoisonDetail=Ext.getCmp("PoisonDetail").getValue();
			var BasiOutStat=Ext.getCmp("BasiOutStat").getValue();
			var BasiInStat=Ext.getCmp("BasiInStat").getValue();
			var PHCDFPhcDoDR = Ext.getCmp("PHCDFPhcDoDR").getValue();
			var PoisonDesc=Ext.getCmp("PHCDFPhcDoDR").getRawValue();
			if((PoisonStat==true)&&(PHCDFPhcDoDR=="")){
				Msg.info("warning", "�������Ĺ��Ʒ��಻��Ϊ�գ�");
				Ext.getCmp("PHCDFPhcDoDR").focus();
				return;
				}
			if((PoisonDetail==true)&&(PHCDFPhcDoDR=="")){
				Msg.info("warning", "����ͳ�ƹ��Ʒ��಻��Ϊ�գ�");
				Ext.getCmp("PHCDFPhcDoDR").focus();
				return;
				}
			var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
			var reportFrame=document.getElementById("frameReport");
			var p_URL="";
			//ҵ��������ϸ�б�
			if(PoisonStat==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_PoisonStat_Total.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Poison='+PHCDFPhcDoDR+'&IncRowid='+IncRowid+'&HospDesc='+App_LogonHospDesc+'&UserName='+gUserName+
					'&LocDesc='+LocDesc+'&RQDTFormat='+RQDTFormat+'&PoisonDesc='+PoisonDesc;
			} 			
			else if(PoisonDetail==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_PoisonStat_Detail.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocId='+ LocId+'&Poison='+PHCDFPhcDoDR+'&IncRowid='+IncRowid+'&HospDesc='+App_LogonHospDesc+'&UserName='+gUserName+
					'&LocDesc='+LocDesc+'&RQDTFormat='+RQDTFormat+'&PoisonDesc='+PoisonDesc;
			}else if(BasiOutStat==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_BasiOutStat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&HospDesc='+App_LogonHospDesc+'&UserName='+gUserName+
					'&LocDesc='+LocDesc+'&RQDTFormat='+RQDTFormat;
			} else if(BasiInStat==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_BasiInStat.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&HospDesc='+App_LogonHospDesc+'&UserName='+gUserName+
					'&LocDesc='+LocDesc+'&RQDTFormat='+RQDTFormat;
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
						title : '��ѯ����',					
						items : [DateFrom,DateTo,PHCDFPhcDoDR,InciDesc]   //StkGrpType,
					}, {
						xtype : 'fieldset',
						title : '��������',
						items : [PoisonStat,PoisonDetail,BasiOutStat,BasiInStat]
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
						title:"����ҩƷ����ͳ��",
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