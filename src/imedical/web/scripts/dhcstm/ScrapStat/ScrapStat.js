//==================库存报损统计===================//	
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var gInciId = "";

var PhaLoc=new Ext.ux.LocComboBox({
	fieldLabel : '科室',
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
var StkGrpField = new Ext.ux.StkGrpComboBox({
	id:'StkGrpType',
	fieldLabel:'类组',
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:gLocId,
	UserId:gUserId,
	anchor : '90%'
});

// 报损原因
var ScrapReasonField = new Ext.form.ComboBox({
	id:'ScrapField',
	fieldLabel:'报损原因',
	listWidth:200,
	allowBlank:true,
	store:ReasonForScrapStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'报损原因...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:200,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	anchor:'90%'
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

var InciDr = new Ext.form.TextField({
	fieldLabel : '物资RowId',
	id : 'InciDr',
	name : 'InciDr',
	anchor : '90%',
	valueNotFoundText : ''
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

var formPanel = new Ext.form.FormPanel({
	labelwidth : 30,
	labelAlign : 'right',
	autoScroll:true,
	autoHeight : true,
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[findScrapBT,'-',clearScrapBT],
	items:[{
		xtype:'fieldset',
		title:'查询条件',
		layout:'column',
		style:'padding:5px 0px 0px 0px',
		defaults:{border:false},
		items:[{
			columnWidth:0.25,
			xtype:'fieldset',
			defaults:{width:200},
			items:[DateFrom,DateTo]
		},{
			columnWidth:0.25,
			xtype:'fieldset',
			defaults:{width:120},
			items:[PhaLoc,StkGrpField]
		},{
			columnWidth:0.25,
			xtype:'fieldset',
			defaults:{width:120},
			items:[ScrapReasonField,IncDesc]
		}]
	}]
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
	Ext.getCmp("ScrapField").setValue('');
	gInciId = "";
	Ext.getCmp("IncDesc").setValue('');
	Ext.getCmp("StkGrpType").getStore().load();
	document.getElementById("frameReport").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
		document.getElementById("frameReport1").src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg";
}

/**
  *查询
  */
function ShowReport()
{
	var StartDate=Ext.getCmp("DateFrom").getValue();
	var EndDate=Ext.getCmp("DateTo").getValue();
	var LocId=Ext.getCmp("PhaLoc").getValue();		
	var LocDesc = Ext.getCmp("PhaLoc").getRawValue();
	
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
	var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
	var ReasonDr=Ext.getCmp("ScrapField").getValue();			//报损原因
	var IncDesc=Ext.getCmp("IncDesc").getValue();
	if(Ext.isEmpty(IncDesc)){
		gInciId = "";
	}
	if(gInciId!=""&gInciId!=null){
		IncDesc="";
	}
    var p = Ext.getCmp("TblTabPanel").getActiveTab();
	var iframe = p.el.dom.getElementsByTagName("iframe")[0];
	if(p.id=="list"){
	iframe.src = PmRunQianUrl+'?reportName=DHCSTM_ScrapStat.raq&StartDate='
    +StartDate+"&EndDate="+EndDate+"&StkType="+"M"+"&Loc="+LocId+"&ItmDr="+gInciId
    +"&ReasonDr="+ReasonDr+"&StkGrpType="+GrpType+"&LocDesc="+LocDesc
    
	}else{
	iframe.src = PmRunQianUrl+'?reportName=DHCSTM_ScrapLocStat.raq&StartDate='
    +StartDate+"&EndDate="+EndDate+"&StkType="+"M"+"&Loc="+LocId+"&ItmDr="+gInciId
    +"&ReasonDr="+ReasonDr+"&StkGrpType="+GrpType+"&LocDesc="+LocDesc	
   
	}
	
}

//=============页面模块==========================//
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var QueryForm = new Ext.ux.FormPanel({
		title:'库存报损统计',
		tbar:[findScrapBT,'-',clearScrapBT],
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			layout : 'column',	
			style : 'padding:5px 0px 0px 5px',
			defaults : {border:false,xtype:'fieldset'},
			items : [{
					columnWidth : .26,
					items : [DateFrom,DateTo]
				},{
					columnWidth : .26,
					items : [PhaLoc,StkGrpField]
				},{
					columnWidth : .26,
					items : [ScrapReasonField,IncDesc]
			}]
		}]
	});		
	
    var QueryTabs = new Ext.TabPanel({
	    region: 'center',
	    id:'TblTabPanel',
	    margins:'3 3 3 0', 
	    activeTab: 0,
	    items:[{
	        title: '按照物资统计',
	        id:'list',    
			frameName: 'list',
			html:'<iframe id="frameReport" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
			
	    },{
	        title: '按照科室统计',
	        id:'listByLoc',    
			frameName: 'listByLoc',
			html:'<iframe id="frameReport1" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	
	    }],
	    listeners:{ 
			tabchange:function(tp,p){}
		}
	});
	
	var port = new Ext.ux.Viewport({
		layout : 'border',
		items : [QueryForm,QueryTabs]
	});
});