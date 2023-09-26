//==================订单统计===================//
var gUserId = session['LOGON.USERID'];
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

var PhaLoc=new Ext.ux.LocComboBox({
	fieldLabel : '<font color=blue>封面科室</font>',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor : '90%',
	emptyText : '科室...',
	groupId:gGroupId
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


var findScrapBT = new Ext.Toolbar.Button({
	text:'统计',
    tooltip:'统计',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		ShowReport();
	}
});

var clearScrapBT = new Ext.Toolbar.Button({
	text:'清空',
    tooltip:'清空',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		ClearData();
	}
});


/**
 * 清空
 */
function ClearData()
{
	Ext.getCmp("PhaLoc").setValue(gLocId);
	Ext.getCmp("DateFrom").setValue(new Date());
	Ext.getCmp("DateTo").setValue(new Date());
	document.getElementById("frameReport").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
}

function ShowReport()
{
	var StartDate=Ext.getCmp("DateFrom").getValue();
	var EndDate=Ext.getCmp("DateTo").getValue();
	var LocId=Ext.getCmp("PhaLoc").getValue();
	var LocDesc = Ext.getCmp("PhaLoc").getRawValue();
	if(LocId==null || LocId==""){
		Msg.info("warning","科室不能为空!");
		return;
	}
	if(StartDate!=""){
		StartDate = StartDate.format(ARG_DATEFORMAT).toString();
	}else{
		Msg.info("warning","开始日期不能为空!");
		return;
	}
	if(EndDate!=""){
		EndDate = EndDate.format(ARG_DATEFORMAT).toString();
	}else{
		Msg.info("warning","截止日期不能为空!");
		return;
	}
	
	var reportFrame=document.getElementById("frameReport");
	var p_URL="";
    p_URL =PmRunQianUrl+'?reportName=DHCSTM_PayCoverStat.raq&StartDate='
    +StartDate+"&EndDate="+EndDate+"&Loc="+LocId+"&LocDesc="+LocDesc+"&HospDesc="+App_LogonHospDesc;
	reportFrame.src=p_URL;
}

//=============页面模块==========================//
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var formPanel = new Ext.ux.FormPanel({
		title : '付款封面统计',
		tbar:[findScrapBT,'-',clearScrapBT],
		items:[{
			xtype:'fieldset',
			title:'查询条件',
			layout:'column',
			style:'padding:5px 0px 0px 5px',
			defaults:{xtype:'fieldset',border:false},
			items:[{
				columnWidth:0.25,
				items:[PhaLoc]
			},{
				columnWidth:0.33,
				items:[DateFrom]
			},{
				columnWidth:0.33,
				items:[DateTo]
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