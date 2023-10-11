// /����:�����������
// /����:�����������
// /��д�ߣ�zhangdongmei
// /��д����: 2013.01.10

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  //��ʼ��������������
	}
	var gGroupId=session['LOGON.GROUPID'];
	var gUserName=session['LOGON.USERNAME'];
	var InciDr = new Ext.form.TextField({
				fieldLabel : $g('ҩƷRowId'),
				id : 'InciDr',
				name : 'InciDr',
				anchor : '90%',
				width : 120,
				valueNotFoundText : '',
				value:''
			});

	var ItmDesc = new Ext.form.TextField({
				fieldLabel : $g('ҩƷ����'),
				id : 'ItmDesc',
				name : 'ItmDesc',
				anchor : '90%',
				width : 120,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							var item=field.getValue();
							if (item != null && item.length > 0) {
			GetPhaOrderWindow(item, "", App_StkTypeCode, "", "N", "0", "",
					getDrugList);
							}
						}
					}
				}
			});

	/**
	 * ���ط���
	*/
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		var inciRowid = record.get("InciDr");
		//var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		Ext.getCmp("InciDr").setValue(inciRowid);
		//Ext.getCmp("InciCode").setValue(inciCode);
		Ext.getCmp("ItmDesc").setValue(inciDesc);
	}
	// ���۵���
	var AdjSpNo = new Ext.form.TextField({
				fieldLabel : $g('���۵���'),
				id : 'AdjSpNo',
				name : 'AdjSpNo',
				anchor : '90%',
				width : 120
			});

	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
			fieldLabel : '<font color=blue>'+$g('��ʼ����')+'</font>',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			width : 120,
			value : new Date().add(Date.DAY,-1)
		});

	// ��������
	var EndDate= new Ext.ux.DateField({
			fieldLabel : '<font color=blue>'+$g('��������')+'</font>',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			width : 120,
			value : new Date()
		});
		
	var StartTime=new Ext.form.TextField({
		fieldLabel : $g('��ʼʱ��'),
		id : 'StartTime',
		name : 'StartTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('ʱ���ʽ������ȷ��ʽhh:mm:ss'),
		width : 120
	});	

	var EndTime=new Ext.form.TextField({
		fieldLabel : $g('��ֹʱ��'),
		id : 'EndTime',
		name : 'EndTime',
		anchor : '90%',
		regex : /^(0\d{1}|1\d{1}|2[0-3]):[0-5]\d{1}:([0-5]\d{1})$/,
		regexText:$g('ʱ���ʽ������ȷ��ʽhh:mm:ss'),
		width : 120
	});
	
	// ����
	var Loc=new Ext.ux.LocComboBox({
		fieldLabel : $g('����'),
		id : 'Loc',
		name : 'Loc',
		anchor : '90%',
		width : 120,
		emptyText : $g('����...'),
		groupId:gGroupId
	});
	
	ReasonForAdjSpStore.load();
	var AspReason=new Ext.form.ComboBox({
		id:'AspReason',
		fieldLabel:$g('����ԭ��'),
		name:'AspReason',
		width:100,
		emptyText:$g('����ԭ��'),
		store:ReasonForAdjSpStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
	
	var OptType=new Ext.form.RadioGroup({
		id:'OptType',
		columns:1,
		itemCls: 'x-check-group-alt',
		items:[
			{boxLabel:$g('ȫ��'),name:'type',inputValue:0,checked:true},
			{boxLabel:$g('���Ϊ��'),name:'type',inputValue:1},
			{boxLabel:$g('���Ϊ��'),name:'type',inputValue:-1}
		]
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor : '90%',
		width : 120
	});
	
	// ȷ����ť
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
		var InciDesc=Ext.getCmp("ItmDesc").getValue();
		if(InciDesc==null || InciDesc==""){
			Ext.getCmp("InciDr").setValue("");
		}
		var StartDate=Ext.getCmp("StartDate").getValue()
		var EndDate=Ext.getCmp("EndDate").getValue()
		if(StartDate==""||EndDate=="")
		{
			Msg.info("warning", $g("��ʼ���ںͽ�ֹ���ڲ��ܿգ�"));
			return;
		}
		
		var StartDate=Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
		var EndDate=Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();;
		var startTime=Ext.getCmp("StartTime").getRawValue();
	    var endTime=Ext.getCmp("EndTime").getRawValue();
	    if(StartDate==EndDate && startTime>endTime){
				Msg.info("warning", $g("��ʼʱ����ڽ�ֹʱ�䣡"));
				return;
		}
		var LocId=Ext.getCmp("Loc").getValue();
		var InciId=Ext.getCmp("InciDr").getValue();
		var AspNo=Ext.getCmp("AdjSpNo").getValue();				//���۵���
		var AspReasonId=Ext.getCmp("AspReason").getValue();		//����ԭ��id
		var OptType=Ext.getCmp("OptType").getValue().getGroupValue();				//�������
		var VenId=Ext.getCmp("Vendor").getValue();
		var StatFlag=Ext.getCmp("StatType").getValue().getGroupValue();
		var RQDTFormat=App_StkRQDateFormat+" "+App_StkRQTimeFormat;
		var p_URL = '';
		//��Ʒ����
		if(StatFlag==1){
			var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^"+""+"^"+VenId+"^"+"1";
			if (gParamCommon[7]==3){ //���μ�
				p_URL='dhccpmrunqianreport.csp?reportName=aspamountstat-inc-batch.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;
			}else{
				p_URL='dhccpmrunqianreport.csp?reportName=aspamountstat-inc.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;
			}
			var NewWin=(window.open(p_URL,$g("�������浥Ʒ����"),"top=100,left=20,width="+document.body.clientWidth*0.8+",height="+(document.body.clientHeight-50)+",scrollbars=1,resizable=yes"));
		} 
		//��Ʒ���һ���
		else if(StatFlag==2){
			var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^"+""+"^"+VenId+"^"+"2";;
			if (gParamCommon[7]==3){ //���μ�
				p_URL = 'dhccpmrunqianreport.csp?reportName=aspamountstat-incloc-batch.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;
			}else{
				p_URL = 'dhccpmrunqianreport.csp?reportName=aspamountstat-incloc.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;
			}
			var NewWin=open(p_URL,$g("�������浥Ʒ���һ���"),"top=100,left=20,width="+document.body.clientWidth*0.8+",height="+(document.body.clientHeight-50)+",scrollbars=1");
		}
		//��Ӫ��ҵ����
		else if(StatFlag==3){
			if (gParamCommon[7]==3){ //���μ�
				var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^"+"^"+VenId;
				p_URL = 'dhccpmrunqianreport.csp?reportName=aspamountstat-vendor-batch.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;

			}else{
				var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^"+VenId;
				p_URL = 'dhccpmrunqianreport.csp?reportName=aspamountstat-vendor.raq&StartDate='+
					StartDate +'&EndDate=' +EndDate +'&Others='+Others+'&StartTime='+startTime+'&EndTime='+endTime+'&UserName='+gUserName+'&HospDesc='+App_LogonHospDesc+'&RQDTFormat='+RQDTFormat;
			}
			var NewWin=open(p_URL,$g("�������澭Ӫ��ҵ����"),"top=100,left=20,width="+document.body.clientWidth*0.8+",height="+(document.body.clientHeight-50)+",scrollbars=1");
		}
	}
		
	var FormPanel=new Ext.FormPanel({
		title:$g('�����������'),
		frame:true,
		tbar:[OkBT],
		items:[{
			layout:'column',
			xtype:'fieldset',
			title:$g('��ѯ����'),
			style:'padding:10px 10px 10px 10px',
			defaults:{border:false},
			items:[{
				columnWidth:0.3,
				xtype:'fieldset',
				defaults:{width:120},
				items:[StartDate,StartTime,EndDate,EndTime]
			},{
				columnWidth:0.3,
				xtype:'fieldset',
				defaults:{width:120},
				items:[Loc,AdjSpNo,ItmDesc,Vendor]
			},{
				columnWidth:0.4,
				xtype:'fieldset',
				items:[OptType]
			}]
		}]
	});
	
	var view=new Ext.Viewport({
		layout:'border',
		items:[{
			region:'north',
			height:250,
			layout:'fit',
			items:FormPanel
		},{
			region:'center',
			frame:true,
			items:[{
				title:$g('��������'),		
				style:'padding:10px',
				xtype:'fieldset',
				items:[{
				xtype:'radiogroup',
				id:'StatType',
				items:[{boxLabel:$g('��Ʒ����'),name:'OptStat',inputValue:1,checked:true},
					{boxLabel:$g('��Ʒ���һ���'),name:'OptStat',inputValue:2},
					{boxLabel:$g('��Ӫ��ҵ����'),name:'OptStat',inputValue:3}]
				}]
			}]
		}]
	});
	
});
