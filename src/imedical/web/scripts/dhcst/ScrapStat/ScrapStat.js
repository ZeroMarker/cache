///Description:库存报损统计
//==================UI===================//
var gUserId = session['LOGON.USERID'];	
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

var PhaLoc=new Ext.ux.LocComboBox({
	fieldLabel : '<font color=blue>'+$g('科室')+'</font>',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor : '90%',
	emptyText : $g('科室...'),
	groupId:gGroupId,
		listeners : {
			'select' : function(e) {
                  var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx 根据选择的科室动态加载类组
                  StkGrpField.getStore().removeAll();
                  StkGrpField.getStore().setBaseParam("locId",SelLocId)
                  StkGrpField.getStore().setBaseParam("userId",UserId)
                  StkGrpField.getStore().setBaseParam("type",App_StkTypeCode)
                  StkGrpField.getStore().load();
			}
	}
});

var DateFrom = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>'+$g('开始日期')+'</font>',
	id : 'DateFrom',
	name : 'DateFrom',
	anchor : '90%',
	value :new Date()
});
	
var DateTo = new Ext.ux.DateField({
	fieldLabel : '<font color=blue>'+$g('截止日期')+'</font>',
	id : 'DateTo',
	name : 'DateTo',
	anchor : '90%',
	value : new Date()
});

// 药品类组
var StkGrpField = new Ext.ux.StkGrpComboBox({
	id:'StkGrpType',
	fieldLabel:$g('类组'),
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:gLocId,
	UserId:gUserId,
	anchor : '90%'
});

// 调整原因
var ScrapReasonField = new Ext.form.ComboBox({
	id:'ScrapField',
	fieldLabel:$g('报损原因'),
	listWidth:200,
	allowBlank:true,
	store:ReasonForScrapurnStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:$g('报损原因...'),
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:200,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	anchor:'90%'
});

ReasonForAdjustMentStore.load();

var IncDesc = new Ext.form.TextField({
	fieldLabel : $g('药品名称'),
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
	fieldLabel : $g('药品RowId'),
	id : 'InciDr',
	name : 'InciDr',
	anchor : '90%',
	valueNotFoundText : ''
});
	
var findScrapBT = new Ext.Toolbar.Button({
	text:$g('查询'),
    tooltip:$g('查询'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		FindScrapStat();
	}
});

var printScrapBT = new Ext.Toolbar.Button({
	text:$g('打印'),
    tooltip:$g('打印'),
    iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(){
		Print();
	}
});

var exportScrapBT = new Ext.Toolbar.Button({
	text:$g('另存'),
    tooltip:$g('另存'),
    iconCls:'page_export',
	width : 70,
	height : 30,
	handler:function(){
		Export();
	}
});

var clearScrapBT = new Ext.Toolbar.Button({
	text:$g('清屏'),
    tooltip:$g('清屏'),
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
	//autoHeight : true,
	frame : true,
	bodyStyle : 'padding:5px;',
    tbar:[findScrapBT,'-',clearScrapBT,'-',printScrapBT,'-',exportScrapBT],
	items:[{
		xtype:'fieldset',
		title:$g('查询条件'),
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

var DetailStore=new Ext.data.JsonStore({
	autoDestroy:true,
	url:DictUrl+"scrapstataction.csp?actiontype=ScrapStat",
	storeId:'DetailStore',
	remoteSort:true,
	idProperty:'',
	root:'rows',
	totalProperty:'results',
	fields:['InciCode','InciDesc','ScrapUom','ScrapQty',
	'Rp','RpAmt','Sp','SpAmt','Manf','Spec'],
	baseParams:{
		ParStr:''
	}
});

var nm=new Ext.grid.RowNumberer();
var DetailCm=new Ext.grid.ColumnModel([nm,
    {
		header:$g('药品代码'),
		dataIndex:'InciCode',
		width:100,
		sortable:false
	},{
		header:$g('药品名称'),
		dataIndex:'InciDesc',
		width:200,
		sortable:true
	},{
		header:$g('报损数量'),
		dataIndex:'ScrapQty',
		width:80,
		align:'right',
		sortable:false
	},{
		header:$g('单位'),
		dataIndex:'ScrapUom',
		width:80,
		align:'right',
		sortable:false
	},{
		header:$g('进价'),
		dataIndex:'Rp',
		width:60,
		align:'right',
		sortable:false
	},{
		header:$g('进价金额'),
		dataIndex:'RpAmt',
		width:100,
		align:'right',
		sortable:false
	},{
		header:$g('售价'),
		dataIndex:'Sp',
		width:60,
		align:'right',
		sortable:false
	},{
		header:$g('售价金额'),
		dataIndex:'SpAmt',
		width:100,
		align:'right',
		sortable:false
	},{
		header:$g('生产企业'),
		dataIndex:'Manf',
		width:200,
		sortable:false
	},{
		header:$g('规格'),
		dataIndex:'Spec',
		width:100,
		sortable:false
	}	
]);

var PagingToolBar=new Ext.PagingToolbar({
	id:'PagingToolBar',
	store:DetailStore,
	displayInfo:true,
	pageSize:PageSize,
	displayMsg:$g("当前记录{0}---{1}条  共{2}条记录"),
	emptyMsg:$g("没有数据"),
	firstText:$g('第一页'),
	lastText:$g('最后一页'),
	prevText:$g('上一页'),
	refreshText:$g('刷新'),
	nextText:$g('下一页')		
});
var GridColSetBT = new Ext.Toolbar.Button({
	text:$g('列设置'),
    tooltip:$g('列设置'),
    iconCls:'page_gear',
    //	width : 70,
    //	height : 30,
	handler:function(){
		GridColSet(DetailGrid,"DHCSTSCRAPSTAT");
	}
    });
	
var DetailGrid=new Ext.grid.EditorGridPanel({
	title:$g('明细'),
	id:'DetailGrid',
	height : 140,
	region:'center',
	store:DetailStore,
	stripeRows : true,
	loadMask:true,
	cm:DetailCm,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	takeMouseOver:true,
	bbar:PagingToolBar,
	tbar:[GridColSetBT]
});

//=======================================//

//==================Events===============//
/**
 * 调用药品窗体并返回结果
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
	var inciDr = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	
	Ext.getCmp("InciDr").setValue(inciDr);
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
	Ext.getCmp("InciDr").setValue('');
	Ext.getCmp("IncDesc").setValue('');
	Ext.getCmp("StkGrpType").getStore().load();
	DetailGrid.store.removeAll();
}

/**
  *查询
  */
function FindScrapStat()
{
	var StartDate=Ext.getCmp("DateFrom").getValue()
	var EndDate=Ext.getCmp("DateTo").getValue()
	if(StartDate==""||EndDate=="")
	{
		Msg.info("warning", $g("开始日期和截止日期不能空！"));
		return;
	}
	var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();
	var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();
	var LocId=Ext.getCmp("PhaLoc").getValue();		

	if(LocId==null || LocId==""){
		Msg.info("warning",$g("科室不能为空!"));
		return;
	}
	if(StartDate==null || StartDate==""){
		Msg.info("warning",$g("开始日期不能为空!"));
		return;
	}
	if(EndDate==null || EndDate==""){
		Msg.info("warning",$g("截止日期不能为空!"));
		return;
	}
	
	var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
	var ReasonDr=Ext.getCmp("ScrapField").getValue();			//类组id
	var IncDesc=Ext.getCmp("IncDesc").getValue();
	var IncRowid="";
	if(IncDesc!=null&IncDesc!=""){
		IncRowid=Ext.getCmp("InciDr").getValue();				//库存项id
		if (IncRowid == undefined) {
			IncRowid = "";
		}
	}
	
	var ParStr=StartDate+"^"+EndDate+"^"+"G"+"^"+LocId+"^"+IncRowid+"^"+ReasonDr+"^"+GrpType;
	var pageSize=PagingToolBar.pageSize;
	DetailStore.setBaseParam("ParStr",ParStr);
	DetailStore.load({params:{start:0,limit:pageSize}});
}

/**
 * 打印
 */
function Print()
{
    var str=getParaList();
    if (str==""){return;}
	PrintScrapStat(str);
}

/**
 * 导出
 */
function Export()
{
    var str=getParaList();
    if (str==""){return;}
	ExportScrapStat(str);
}


/**
 * 准备查询或打印条件
 */
function getParaList()
{
	var StartDate=Ext.getCmp("DateFrom").getValue().format(App_StkDateFormat).toString();;
	var EndDate=Ext.getCmp("DateTo").getValue().format(App_StkDateFormat).toString();;
	var LocId=Ext.getCmp("PhaLoc").getValue();
	var LocDesc=Ext.getCmp("PhaLoc").getRawValue();		
	
	if(LocId==null || LocId==""){
		Msg.info("warning",$g("科室不能为空!"));
		return;
	}
	if(StartDate==null || StartDate==""){
		Msg.info("warning",$g("开始日期不能为空!"));
		return;
	}
	if(EndDate==null || EndDate==""){
		Msg.info("warning",$g("截止日期不能为空!"));
		return;
	}

	var GrpType=Ext.getCmp("StkGrpType").getValue();			//类组id
	var ReasonDr=Ext.getCmp("ScrapField").getValue();			//类组id
	var IncDesc=Ext.getCmp("IncDesc").getValue();
	var IncRowid="";
	if(IncDesc!=null&IncDesc!=""){
		IncRowid=Ext.getCmp("InciDr").getValue();				//库存项id
		if (IncRowid == undefined) {
			IncRowid = "";
		}
	}
    var User=session['LOGON.USERNAME'];
	var ParStr=StartDate+"^"+EndDate+"^"+"G"+"^"+LocId+"^"+IncRowid+"^"+ReasonDr+"^"+GrpType+"^"+LocDesc+"^"+User;
	return ParStr;
}
//=======================================//

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	
	var panel = new Ext.Panel({
		title:$g('库存报损统计'),
		activeTab:0,
		layout:'fit',
		region:'north',
		height:170,
		items:[formPanel]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,DetailGrid],
		renderTo:'mainPanel'
	});
});