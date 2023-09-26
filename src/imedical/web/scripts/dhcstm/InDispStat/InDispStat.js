// /����: ��������ͳ��
// /��д�ߣ��쳬
// /��д����: 2015.5.20
var IncRowid=""
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	var gUserId=session['LOGON.USERID'];
    // ����
var RecLoc= new Ext.ux.LocComboBox({
	fieldLabel : '<font color=blue>ͳ�ƿ���</font>',
	id : 'RecLoc',
	name : 'RecLoc',
	anchor:'90%',
	emptyText : 'ͳ�ƿ���...',
	stkGrpId : "StkGrpType",
	groupId:gGroupId
});

	var DateFrom = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ʼ����</font>',
		id : 'DateFrom',
		name : 'DateFrom',
		anchor : '90%',
		value :new Date
	});

	var DateTo = new Ext.ux.DateField({
		fieldLabel : '<font color=blue>��ֹ����</font>',
		id : 'DateTo',
		name : 'DateTo',
		anchor : '90%',
		value : new Date
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
				text : '���',
				tooltip : '������',
				width : 70,
				height : 30,
				iconCls : 'page_clearscreen',
				handler : function() {
					Ext.getCmp('HisListTab').getForm().items.each(function(f){ 
						f.setValue("");
					});
					
					SetLogInDept(RecLoc.getStore(),'RecLoc');
					Ext.getCmp("DateFrom").setValue(new Date());
					Ext.getCmp("DateTo").setValue(new Date());
					Ext.getCmp("StkGrpType").getStore().load();
					document.getElementById("reportFrame").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
				}
			});
	
			
	function ShowReport() {
		var StartDate=Ext.getCmp("DateFrom").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("DateTo").getValue().format(ARG_DATEFORMAT).toString();;
		var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
		var StkCatId=Ext.getCmp("DHCStkCatGroup").getValue();		//������id
		var InciDesc=Ext.getCmp("InciDesc").getValue();				//�����id
		if (InciDesc==null || InciDesc=="") {
			IncRowid = "";
		}
		var RecLocId=Ext.getCmp("RecLoc").getValue();			//
		if(RecLocId==""){
			Msg.info("warning","���Ҳ���Ϊ�գ�");
			return;
			}
		var hvFlag=(Ext.getCmp("hvFlag").getValue()==true?"Y":"N");
		var chargeFlag=(Ext.getCmp("chargeFlag").getValue()==true?"Y":"N");
		var Param=StartDate+"^"+EndDate+"^"+GrpType+"^"+StkCatId+"^"+IncRowid+"^"+RecLocId+"^"+hvFlag+"^"+chargeFlag;
		var reportframe=document.getElementById("reportFrame")
		var p_URL="";
		//ȡ����ѯ����
		var Conditions="";
		if(StartDate!=""){
			Conditions=Conditions+" ͳ��ʱ��: "+StartDate
		}
		if(EndDate!=""){
			Conditions=Conditions+"~ "+EndDate
		}
		
		if(GrpType!=""){
			Conditions=Conditions+" ����: "+Ext.getCmp("StkGrpType").getRawValue()
		}
		if(StkCatId!=""){
			Conditions=Conditions+" ������: "+Ext.getCmp("DHCStkCatGroup").getRawValue()
		}
		var RecLocDesc=Ext.getCmp("RecLoc").getRawValue();
		//ȡ����ѯ����
		
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_InDispStat.raq&Param='+
				Param+'&Conditions='+Conditions+'&RecLocDesc='+RecLocDesc;
		
		reportframe.src=p_URL;
	}

	var HisListTab = new Ext.ux.FormPanel({
		id : 'HisListTab',
		tbar : [OkBT, "-", ClearBT],
		items : [{
			xtype : 'fieldset',
			title : '��ѯ����',
			items : [RecLoc,DateFrom,DateTo,StkGrpType,DHCStkCatGroup,InciDesc,
				{
					xtype:'checkbox',
					boxLabel : '��ֵ��־',
					id : 'hvFlag',
					name : 'hvFlag',
					anchor : '90%',
					checked : false
				},{
					xtype:'checkbox',
					boxLabel : '�շѲ���',
					id : 'chargeFlag',
					name : 'chargeFlag',
					anchor : '90%',
					checked : false
				}
			]
		}]
	});

	var reportPanel=new Ext.Panel({
		autoScroll:true,
		frame:true,
		html:'<iframe id="reportFrame" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	})
	// ҳ�沼��
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [{
					region:'west',
					title:'������������',
					width:320,
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