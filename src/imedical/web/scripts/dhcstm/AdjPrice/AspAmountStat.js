// /����:�����������
// /����:�����������
// /��д�ߣ�zhangdongmei
// /��д����: 2013.01.10

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gInciDr="";
	gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];

	var ItmDesc = new Ext.form.TextField({
		fieldLabel : '��������',
		id : 'ItmDesc',
		name : 'ItmDesc',
		anchor : '95%',
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var item=field.getValue();
					if (item != null && item.length > 0) {
						GetPhaOrderWindow(item, "", App_StkTypeCode, "", "N", "0", "",getDrugList);
					}
				}
			}
		}
	});
			
	function getDrugList(record) {
		if (record == null || record == "") {
			return;
		}
		gInciDr = record.get("InciDr");
		var inciCode=record.get("InciCode");
		var inciDesc=record.get("InciDesc");
		
		Ext.getCmp("ItmDesc").setValue(inciDesc);		
	}
	// ���۵���
	var AdjSpNo = new Ext.form.TextField({
		fieldLabel : '���۵���',
		id : 'AdjSpNo',
		name : 'AdjSpNo',
		anchor : '90%',
		width : 100
	});

	// ��ʼ����
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '��ʼ����',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		width : 120,
		value : new Date().add(Date.DAY,-1)
	});

	// ��������
	var EndDate= new Ext.ux.DateField({
		fieldLabel : '��������',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		width : 120,
		value : new Date()
	});

	// ����
	var Loc=new Ext.ux.LocComboBox({
		fieldLabel : '����',
		id : 'Loc',
		name : 'Loc',
		anchor : '95%',
		width : 120,
		emptyText : '����...',
		groupId:gGroupId,
		defaultLoc:{}
	});
	SetLogInDept(Ext.getCmp("Loc").getStore(),"Loc");
	
	ReasonForAdjSpStore.load();
	var AspReason=new Ext.form.ComboBox({
		id:'AspReason',
		fieldLabel:'����ԭ��',
		name:'AspReason',
		width:100,
		emptyText:'����ԭ��',
		store:ReasonForAdjSpStore,
		valueField : 'RowId',
		displayField : 'Description'
	});
	
	var OptType=new Ext.form.RadioGroup({
		id:'OptType',
		columns:1,
		itemCls: 'x-check-group-alt',
		items:[
			{boxLabel:'ȫ��',name:'type',inputValue:0,checked:true},
			{boxLabel:'���Ϊ��',name:'type',inputValue:1},
			{boxLabel:'���Ϊ��',name:'type',inputValue:-1}
		]
	});
	
	var Vendor=new Ext.ux.VendorComboBox({
		id : 'Vendor',
		name : 'Vendor',
		anchor : '95%',
		params : {LocId : 'Loc'},
		width : 200
	});
	
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
		var StartDate=Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate=Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT).toString();;
		var LocId=Ext.getCmp("Loc").getValue();
		var InciDesc=Ext.getCmp("ItmDesc").getValue();
		if (InciDesc == null || InciDesc == "") {
			gInciDr = "";
		}
		if(gInciDr!=""&gInciDr!=null){
			InciDesc="";
		}
		var InciId=gInciDr;
		var AspNo=Ext.getCmp("AdjSpNo").getValue();				//���۵���
		var AspReasonId=Ext.getCmp("AspReason").getValue();		//����ԭ��id
		var OptType=Ext.getCmp("OptType").getValue().getGroupValue();				//�������
		var VenId=Ext.getCmp("Vendor").getValue();
		var StatFlag=Ext.getCmp("StatType").getValue().getGroupValue();
		
		var winWidth = document.body.clientWidth, winHeight = document.body.clientHeight;
		var winStyle = "top=20,left=20,width="+winWidth+",height="+winHeight+",scrollbars=1";
		//��Ʒ����
		if(StatFlag==1){
			var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^^"+InciDesc;
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_aspamountstat-inc.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&Others='+Others;
			var NewWin=(window.open(p_URL,"�������浥Ʒ����",winStyle));
		}
		//��Ʒ���һ���
		else if(StatFlag==2){
			var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^^"+InciDesc;
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_aspamountstat-incloc.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&Others='+Others;
			var NewWin=open(p_URL,"�������浥Ʒ���һ���",winStyle);
		}
		//��Ӧ�̻���
		else if(StatFlag==3){
			var Others=LocId+"^"+AspNo+"^"+AspReasonId+"^"+OptType+"^"+InciId+"^"+VenId+"^"+InciDesc;
			var p_URL = PmRunQianUrl+'?reportName=DHCSTM_aspamountstat-vendor.raq&StartDate='+
				StartDate +'&EndDate=' +EndDate +'&Others='+Others;
			var NewWin=open(p_URL,"�������湩Ӧ�̻���",winStyle);
		}
	}
		
	var FormPanel=new Ext.ux.FormPanel({
		title:'�����������',
		region:'north',
		height:200,
		tbar:[OkBT],
		items:[{
			layout:'column',
			xtype:'fieldset',
			title:'��ѯ����',
			labelAlign:'right',
			style:'padding:10px 0px 0px 10px',
			defaults:{border:false},
			items:[{
				columnWidth:0.3,
				xtype:'fieldset',
				defaults:{width:120},
				items:[StartDate,EndDate,AdjSpNo]
			},{
				columnWidth:0.4,
				xtype:'fieldset',
				defaults:{width:180},
				items:[Loc,ItmDesc,Vendor]
			},{
				columnWidth:0.3,
				xtype:'fieldset',
				items:[OptType]
			}]
		}]
	});
	
	var view=new Ext.ux.Viewport({
		layout:'border',
		items:[FormPanel,
			{
			region:'center',
			frame:true,
			items:[{
				title:'��������',		
				style:'padding:0px 0px 0px 10px',
				xtype:'fieldset',
				items:[{
				xtype:'radiogroup',
				id:'StatType',
				items:[{boxLabel:'��Ʒ����',name:'OptStat',inputValue:1,checked:true},
					{boxLabel:'��Ʒ���һ���',name:'OptStat',inputValue:2},
					{boxLabel:'��Ӧ�̻���',name:'OptStat',inputValue:3}]
				}]
			}]
		}]
	});
});