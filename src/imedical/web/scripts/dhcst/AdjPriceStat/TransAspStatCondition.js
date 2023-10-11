// /����: ��Ӻ��ҵ�����������ͳ��
// /����: ��Ӻ��ҵ�����������ͳ��
// /��д�ߣ�yunhaibao
// /��д����: 2015-11-30
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
	
	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>'+$g('��ʼ����')+'</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :new Date()
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
		value : new Date()
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
	var TransTypeStore = new Ext.data.SimpleStore({
				fields : ['RowId', 'Description'],
				data : [['G', $g('���')], ['R', $g('�˻�')], ['K', $g('ת�����')], ['H', $g('������ҩ')],['Y', $g('סԺ��ҩ')],
					    ['F', $g('���﷢ҩ')],['P', $g('סԺ��ҩ')],['M', $g('�Ƽ����')]]
			});
	var TransTypeFlag = new Ext.form.ComboBox({
				fieldLabel : $g('ҵ������'),
				id : 'TransTypeFlag',
				name : 'TransTypeFlag',
				anchor : '90%',					
				store : TransTypeStore,
				valueField : 'RowId',
				displayField : 'Description',
				mode : 'local',
				allowBlank : true,
				triggerAction : 'all',
				selectOnFocus : true,
				listWidth : 150,
				forceSelection : true
			});
		
	var InciDr = new Ext.form.TextField({
				fieldLabel : $g('ҩƷRowId'),
				id : 'InciDr',
				name : 'InciDr',
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
		var inciRowid = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDr").setValue(inciRowid);
		Ext.getCmp("InciDesc").setValue(inciDesc);
	}
	// �˻�����ϸ�б�
		var FlagTransAspStatDetail = new Ext.form.Radio({
					boxLabel : $g('ҵ��������ϸ'),
					id : 'FlagTransAspStatDetail',
					name : 'ReportType',
					anchor : '80%',
					checked : true
				});
		
	var ClearBT = new Ext.Toolbar.Button({
				id : "ClearBT",
				text : $g('���'),
				tooltip : $g('������'),
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					Ext.getCmp('HisListTab').getForm().items.each(function(f){ 
						f.setValue("");
					});
					SetLogInDept(PhaLoc.getStore(),'PhaLoc');
					Ext.getCmp("DateFrom").setValue(new Date());
					Ext.getCmp("DateTo").setValue(new Date());
					Ext.getCmp("StkGrpType").getStore().load();
					document.getElementById("frameReport").src="../scripts/dhcmed/img/logon_bg2.jpg";
				}
			});
		// ͳ�ư�ť
		var OkBT = new Ext.Toolbar.Button({
					id : "OkBT",
					text :$g( 'ͳ��'),
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
				Msg.info("warning", $g("��ʼ���ںͽ�ֹ���ڲ��ܿգ�"));
				return;
			}
			var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();
			var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();
		    var startTime=Ext.getCmp("StartTime").getRawValue();
			var endTime=Ext.getCmp("EndTime").getRawValue();
			if(StartDate==EndDate && startTime>endTime){
				Msg.info("warning", $g("��ʼʱ����ڽ�ֹʱ�䣡"));
				return;
			}
			var LocId=Ext.getCmp("PhaLoc").getValue();
			var LocDesc=Ext.getCmp("PhaLoc").getRawValue();
			if (LocDesc==""){LocDesc=$g("ȫ��")}
			var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
			var GrpTypeDesc=Ext.getCmp("StkGrpType").getRawValue();
			if (GrpTypeDesc=="") {GrpTypeDesc=$g("ȫ��")}
			var incidesc=Ext.getCmp("InciDesc").getValue();
			if ((incidesc==null)||(incidesc==""))
			{
				Ext.getCmp("InciDr").setValue("");
			}
		
			var IncRowid=Ext.getCmp("InciDr").getValue();				//�����id
			if (IncRowid == undefined) {
				IncRowid = "";
			}
			var TransType=Ext.getCmp("TransTypeFlag").getValue();			//����id
			var TransTypeDesc=Ext.getCmp("TransTypeFlag").getRawValue();	
			var FlagTransAspStatDetail=Ext.getCmp("FlagTransAspStatDetail").getValue();
			var FlagType=""
			var Others=IncRowid+"^"+TransType+"^"+GrpType
			if (FlagTransAspStatDetail==true) {FlagType="1"};
			var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
			var reportFrame=document.getElementById("frameReport");
			var p_URL="";
			//ҵ��������ϸ�б�
			if(FlagTransAspStatDetail==true){
				
				p_URL = 'dhccpmrunqianreport.csp?reportName=DHCST_TransAspAmount_Detail.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&LocRowid='+ LocId+'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&HospDesc='+App_LogonHospDesc+'&UserName='+gUserName+
					'&LocDesc='+LocDesc+'&GrpTypeDesc='+GrpTypeDesc+'&TransTypeDesc='+TransTypeDesc+'&RQDTFormat='+RQDTFormat;
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
						items : [PhaLoc,DateFrom,StartTime,DateTo,EndTime,TransTypeFlag,StkGrpType,InciDesc]
					}, {
						xtype : 'fieldset',
						title : $g('��������'),
						items : [FlagTransAspStatDetail]
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
						title:$g("ҵ���������"),
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