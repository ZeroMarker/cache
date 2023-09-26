//==================科室库存动销查询===================//
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var gUserName=session['LOGON.USERNAME']
var gInciId = "";

var PhaLoc=new Ext.ux.LocComboBox({
	fieldLabel : '<font color=blue>科室</font>',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor : '90%',
	emptyText : '科室...',
	groupId:gGroupId,
	stkGrpId : 'StkGrpType'
});

var DateFrom = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>开始日期</font>',
	id : 'DateFrom',
	name : 'DateFrom',
	anchor : '90%',
	value :new Date()
});
	
var DateTo = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>截止日期</font>',
	id : 'DateTo',
	name : 'DateTo',
	anchor : '90%',
	value : new Date()
});

// 物资类组
var StkGrpType = new Ext.ux.StkGrpComboBox({
	id:'StkGrpType',
	fieldLabel:'类组',
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:gLocId,
	UserId:gUserId,
	anchor : '90%'
});


var IncDesc = new Ext.form.TextField({
	fieldLabel : '物资名称',
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
	fieldLabel:'初始不为零',
	//hideLabel:true,
	//boxLabel:'初始库存不为零',
	id:'BeginNotZeroFlag',
	anchor : '90%',
	checked : false
})
var FianlNotZeroFlag=new Ext.form.Checkbox({
    fieldLabel:'截止不为零',
    id:'FianlNotZeroFlag',
    anchor : '90%'
})
var NotZeroTransFlag=new Ext.form.Checkbox({
	fieldLabel:'非零业务',
	id:'NotZeroTransFlag'
})
var findINAdjBT = new Ext.Toolbar.Button({
	text:'统计',
    tooltip:'统计',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		ShowReport();
	}
});

var clearINAdjBT = new Ext.Toolbar.Button({
	text:'清空',
    tooltip:'清空',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		ClearData();
	}
});
//==================Events===============//
/**
 * 调用物资窗体并返回结果
 */
function GetPhaOrderInfo(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "", "",
				getDrugList);
	}
}
/**
 * 返回方法
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
 * 清空
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
  * 统计
  */
function ShowReport(){
	var StartDate=Ext.getCmp("DateFrom").getValue();
	var EndDate=Ext.getCmp("DateTo").getValue();
	var LocId=Ext.getCmp("PhaLoc").getValue();
	var LocDesc = Ext.getCmp("PhaLoc").getRawValue();
	if(LocId==""){
		Msg.info("warning","科室不能为空!");
		return;
	}
	if(StartDate!=""){
		StartDate = StartDate.format('Y-m-d').toString();
	}else{
		Msg.info("warning","开始日期不能为空!");
		return;
	}
	if(EndDate!=""){
		EndDate = EndDate.format('Y-m-d').toString();
	}else{
		Msg.info("warning","截止日期不能为空!");
		return;
	}
	var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
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
/*界面模块*/
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var formPanel = new Ext.ux.FormPanel({
		title:'科室库存动销查询',
	    tbar:[findINAdjBT,'-',clearINAdjBT],
		items:[{
			xtype : 'fieldset',
			title : '查询条件',
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