//==================���ҿ�涯����ѯ===================//
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var gUserName=session['LOGON.USERNAME']
var gInciId = "";

var PhaLoc=new Ext.ux.LocComboBox({
	fieldLabel : '<font color=blue>����</font>',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor : '90%',
	emptyText : '����...',
	groupId:gGroupId,
	stkGrpId : 'StkGrpType'
});

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

// ��������
var StkGrpType = new Ext.ux.StkGrpComboBox({
	id:'StkGrpType',
	fieldLabel:'����',
	StkType:App_StkTypeCode,     //��ʶ��������
	LocId:gLocId,
	UserId:gUserId,
	anchor : '90%'
});


var IncDesc = new Ext.form.TextField({
	fieldLabel : '��������',
	id : 'IncDesc',
	name : 'IncDesc',
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
var BeginNotZeroFlag=new Ext.form.Checkbox({
	fieldLabel:'��ʼ��Ϊ��',
	//hideLabel:true,
	//boxLabel:'��ʼ��治Ϊ��',
	id:'BeginNotZeroFlag',
	anchor : '90%',
	checked : false
})
var FianlNotZeroFlag=new Ext.form.Checkbox({
    fieldLabel:'��ֹ��Ϊ��',
    id:'FianlNotZeroFlag',
    anchor : '90%'
})
var NotZeroTransFlag=new Ext.form.Checkbox({
	fieldLabel:'����ҵ��',
	id:'NotZeroTransFlag'
})
var findINAdjBT = new Ext.Toolbar.Button({
	text:'ͳ��',
    tooltip:'ͳ��',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		ShowReport();
	}
});

var clearINAdjBT = new Ext.Toolbar.Button({
	text:'���',
    tooltip:'���',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		ClearData();
	}
});
//==================Events===============//
/**
 * �������ʴ��岢���ؽ��
 */
function GetPhaOrderInfo(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "",
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
	gInciId = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	Ext.getCmp("IncDesc").setValue(inciDesc);
}

/**
 * ���
 */
function ClearData()
{
	Ext.getCmp("PhaLoc").setValue(gLocId);
	Ext.getCmp("DateFrom").setValue(new Date());
	Ext.getCmp("DateTo").setValue(new Date());
	gInciId = "";
	Ext.getCmp("IncDesc").setValue('');
	Ext.getCmp("StkGrpType").getStore().load();
	Ext.getCmp("BeginNotZeroFlag").setValue('');
	Ext.getCmp("FianlNotZeroFlag").setValue('');
	Ext.getCmp("NotZeroTransFlag").setValue('');
	document.getElementById("frameReport").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";

}

/**
  * ͳ��
  */
function ShowReport(){
	var StartDate=Ext.getCmp("DateFrom").getValue();
	var EndDate=Ext.getCmp("DateTo").getValue();
	var LocId=Ext.getCmp("PhaLoc").getValue();
	var LocDesc = Ext.getCmp("PhaLoc").getRawValue();
	if(LocId==""){
		Msg.info("warning","���Ҳ���Ϊ��!");
		return;
	}
	if(StartDate!=""){
		StartDate = StartDate.format('Y-m-d').toString();
	}else{
		Msg.info("warning","��ʼ���ڲ���Ϊ��!");
		return;
	}
	if(EndDate!=""){
		EndDate = EndDate.format('Y-m-d').toString();
	}else{
		Msg.info("warning","��ֹ���ڲ���Ϊ��!");
		return;
	}
	var GrpType=Ext.getCmp("StkGrpType").getValue();			//����id
	var IncDesc=Ext.getCmp("IncDesc").getValue();
	if(Ext.isEmpty(IncDesc)){
		gInciId = "";
	}
    var BeginNotZeroFlag=(Ext.getCmp("BeginNotZeroFlag").getValue()==true?'Y':'N')
    var FianlNotZeroFlag=(Ext.getCmp("FianlNotZeroFlag").getValue()==true?'Y':'N')
    var NotZeroTransFlag=(Ext.getCmp("NotZeroTransFlag").getValue()==true?'Y':'N')
    var Others=BeginNotZeroFlag+"^"+FianlNotZeroFlag+"^"+NotZeroTransFlag
	var reportFrame=document.getElementById("frameReport");
	var p_URL="";
	p_URL ='dhccpmrunqianreport.csp?reportName=DHCSTM_LocItmStkMoveStatAll.raq'
			+'&StartDate='+StartDate+"&EndDate="+EndDate+"&StkType="+App_StkTypeCode+"&Loc="+LocId+"&ItmDr="+gInciId
			+"&StkGrpType="+GrpType+"&LocDesc="+LocDesc+"&ItmDesc="+IncDesc+"&gUserName="+gUserName+"&HospDesc="+App_LogonHospDesc
			+"&Others="+Others;
	reportFrame.src=p_URL;
}
/*����ģ��*/
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var formPanel = new Ext.ux.FormPanel({
		title:'���ҿ�涯����ѯ',
	    tbar:[findINAdjBT,'-',clearINAdjBT],
		items:[{
			xtype : 'fieldset',
			title : '��ѯ����',
			layout : 'column',	
			style : 'padding:5px 0px 0px 5px',
			defaults : {border:false,columnWidth:0.25,xtype:'fieldset'},
			items:[{
				items:[DateFrom,DateTo]
			},{
				items:[PhaLoc,StkGrpType]
			},{
				items:[IncDesc,BeginNotZeroFlag]
			},{
				items:[FianlNotZeroFlag,NotZeroTransFlag]
			}]
		}]
	});

	var reportPanel=new Ext.Panel({
		region:'center',
		layout:'fit',
		html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	})

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,reportPanel]
	});

});