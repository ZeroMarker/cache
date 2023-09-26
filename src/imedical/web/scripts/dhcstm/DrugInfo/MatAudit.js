// /名称: 物资信息审核
// /编写者：lihui
// /编写日期: 20190304

var userId = session['LOGON.USERID'];
var gLocId=session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];

Ext.onReady(function() {
		Ext.Ajax.timeout = 120000;	//响应时间改为2min
		Ext.QuickTips.init();
		Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

var DateFrom = new Ext.ux.DateField({
	fieldLabel : '开始日期',
	id : 'DateFrom',
	name : 'DateFrom',
	anchor : '90%'
});
var DateTo = new Ext.ux.DateField({
	fieldLabel : '截止日期',
	id : 'DateTo',
	name : 'DateTo',
	anchor : '90%'
	
});
// 物资编码
var M_InciCode = new Ext.form.TextField({
	fieldLabel : '物资编码',
	id : 'M_InciCode',
	name : 'M_InciCode',
	anchor : '90%',
	width : 150,
	valueNotFoundText : ''
});
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "", "0", "",getDrugList);
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
	var InciCode=record.get("InciCode");
	var InciDesc=record.get("InciDesc");
	Ext.getCmp("M_InciDesc").setValue(InciDesc);
	Ext.getCmp("M_InciCode").setValue(InciCode);
}		
// 物资名称
var M_InciDesc = new Ext.form.TextField({
	fieldLabel : '物资名称',
	id : 'M_InciDesc',
	name : 'M_InciDesc',
	anchor : '90%',
	width : 150,
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = Ext.getCmp("M_StkGrpType").getValue();
				GetPhaOrderInfo(field.getValue(), stktype);
			}
		}
	}
});
// 物资类组
var M_StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'M_StkGrpType',
	name : 'M_StkGrpType',
	StkType:App_StkTypeCode,     //标识类组类型
	anchor:'90%',
	LocId:gLocId,
	UserId:userId,
	DrugInfo:"Y",
	listWidth : 200,
	listeners:{
		change:function(field,newValue,oldValue){
			M_StkCat.setValue("");
		}
	}
}); 
// 库存分类
var M_StkCat = new Ext.ux.ComboBox({
	fieldLabel : '库存分类',
	id : 'M_StkCat',
	name : 'M_StkCat',
	store : StkCatStore,
	valueField : 'RowId',
	displayField : 'Description',
	filterName:'StkCatName',
	params:{StkGrpId:'M_StkGrpType'}
});
var Vendor=new Ext.ux.VendorComboBox({
	id : 'Vendor',
	name : 'Vendor',
	anchor:'90%'
});
var AuditFlag=new Ext.form.Checkbox({
	fieldLabel:'已审核',
	id:'AuditFlag',
	name:'AuditFlag',
	checked:false,
	anchor:'90%',
	width:100,
	handler: function() {
		changeButEnable();
		SearchBT.handler();
	}
});

//配置数据源
var MatAuditUrl = 'dhcstm.matauditaction.csp';
var proxy= new Ext.data.HttpProxy({url:MatAuditUrl+'?actiontype=GetMatAuditInfo',method:'POST'});


// 指定列参数
var fields = ["MALGitmRowId","Incid","ChangeType","LastauditFlag","LastDWALFlag","LastDWALDate","LastDWALTime","LastDWALUser","LastDWALLevel","update","uptime","upusername","AudIncicode", "AudIncidesc", "AudSpec","AudIncsc","AudBaseUOM","AudPuom", "AudNotUseFlag","Manf",
			"brand","vendor","vendorName","registerNo","registerNoExpDate","highpriceflag","chargeflag","implantationmat","model","Supervision","Origin","regCertDateOfIssue","regItmDesc","regCertNoFull","INCIBarCode","Mtdr","MT","Abbrev","ChargeType","Sterile",
			"SterCat","ReportingDays","ProlocDesc","ImportFlag","QualityLevel","ComFrom","Remark","MaxSp","InHosFlag","PbRp","PBLdesc","PbCarrier","BAflag","PBLevel","EndDate","ExpireLen","PrcFile","PrcFileD","BC","StandardCode",
			"NotUseReason","InsuCat","HighRiskFlag","PackUom","PackUomFactor","PackPicPath","MaxPurAmt","DistribFlag","Pbno","ChangeRate","MatQuality","ReqModeLimited","NoLocReq","SpeFlag","SterileDateLen","MedEqptCat","ZeroStk","SpecFlag","BidDate","FirstReqDept",
			"InsuPay","InsuPrice","MatCatOfficial","MatCatClinical","MatCatSpecial"];
// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id:'MALGitmRowId',
	pageSize:30,
	fields : fields
});
// 数据集
var MatAuditStore = new Ext.data.Store({
	proxy : proxy,
	reader : reader,
	remoteSort: true
});
var nm = new Ext.grid.RowNumberer();
var sm = new Ext.grid.CheckboxSelectionModel({});		
var MatAuditCm = new Ext.grid.ColumnModel([nm,sm, 
			{
				header : "MALGitmRowId",
				dataIndex : 'MALGitmRowId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			},{
				header : "库存项id",
				dataIndex : 'Incid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "审核状态",
				dataIndex : 'LastDWALFlag',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "最后审核日期",
				dataIndex : 'LastDWALDate',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "最后审核时间",
				dataIndex : 'LastDWALTime',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "最后审核人",
				dataIndex : 'LastDWALUser',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "操作状态",
				dataIndex : 'ChangeType',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "修改日期",
				dataIndex : 'update',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "修改时间",
				dataIndex : 'uptime',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "修改人",
				dataIndex : 'upusername',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "物资代码",
				dataIndex : 'AudIncicode',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : '物资名称',
				dataIndex : 'AudIncidesc',
				width : 200,
				align : 'left',
				renderer : InciPicRenderer('Incid'),
				sortable : true
			},{
				header : "规格",
				dataIndex : 'AudSpec',
				width : 100,
				align : 'left',
				sortable : true
			},{
				header : "型号",
				dataIndex : 'model',
				width : 50,
				align : 'left',
				sortable : true
			},{
				header : "品牌",
				dataIndex : 'brand',
				width : 60,
				align : 'left',
				sortable : true
			},{
				header : "厂商",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			},{
				header : "产地",
				dataIndex : 'Origin',
				width : 80
			},{
				header : '入库单位',
				dataIndex : 'AudPuom',
				width : 70,
				align : 'left',
				sortable : true
			},{
				header : "基本单位",
				dataIndex : 'AudBaseUOM',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header : "库存分类",
				dataIndex : 'AudIncsc',
				width : 150,
				align : 'left',
				sortable : true
			},{
				header : "不可用",
				dataIndex : 'AudNotUseFlag',
				width : 45,
				align : 'center',
				xtype:'checkcolumn',
				sortable : true
			},{
				header:'供应商',
				dataIndex:'vendorName',
				align:'left',
				width:150
			},{
				header:'注册证号',
				dataIndex:'registerNo',
				align:'left',
				width:150
			},{
				header:'注册证效期',
				dataIndex:'registerNoExpDate',
				align:'left',
				width:150
			},{
				header:'注册证名称',
				dataIndex:'regItmDesc',
				align:'left',
				width:150
			},{
				header:'高值标志',
				dataIndex:'highpriceflag',
				align:'left',
				xtype:'checkcolumn',
				width:80,
				sortable : true
			},{
				header : "植入标志",
				dataIndex :'implantationmat',
				xtype:'checkcolumn',
				width : 80,
				align : 'right',
				sortable : true
			}
		]);		
var StatuTabPagingToolbar = new Ext.PagingToolbar({
		store : MatAuditStore,
		pageSize : 30,
		displayInfo : true
	});
var MatAuditGrid = new Ext.ux.GridPanel({
		id:'MatAuditGrid',
		region:'center',
		cm:MatAuditCm,
		store:MatAuditStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm,
		loadMask : true,
		bbar:StatuTabPagingToolbar
	});
function changeButEnable() {
	var AuditFlag = Ext.getCmp("AuditFlag").getValue(); 
	if (AuditFlag == true) {
		AuditNoBT.setDisabled(true);
		AuditYesBT.setDisabled(true);
	} else {
		AuditNoBT.setDisabled(false);
		AuditYesBT.setDisabled(false);
	}
}
// 查询按钮
var SearchBT = new Ext.Toolbar.Button({
	text : '查询',
	tooltip : '点击查询',
	iconCls : 'page_find',
	width : 70,
	height : 30,
	handler : function() {
		changeButEnable();
		var inciDesc = Ext.getCmp("M_InciDesc").getValue();
		var inciCode = Ext.getCmp("M_InciCode").getValue();
		var stkCatId = Ext.getCmp("M_StkCat").getValue();
		var StkGrpType = Ext.getCmp("M_StkGrpType").getValue();
		var StartDate=Ext.getCmp("DateFrom").getValue();
	    if(!Ext.isEmpty(StartDate)){StartDate=StartDate.format(ARG_DATEFORMAT).toString()}
		var EndDate=Ext.getCmp("DateTo").getValue();
		if(!Ext.isEmpty(EndDate)){EndDate=EndDate.format(ARG_DATEFORMAT).toString()}
		/*if ((StartDate == "")||(EndDate == "")) {
			Msg.info("warning", "请选择起止日期!");
			return false;
		}*/
		var AuditFlag=(Ext.getCmp("AuditFlag").getValue()==true?"Y":"N");
		var other=inciDesc+"^"+inciDesc+"^"+StkGrpType+"^"+stkCatId;
		MatAuditStore.setBaseParam('StartDate',StartDate);
		MatAuditStore.setBaseParam('EndDate',EndDate);
		MatAuditStore.setBaseParam('AuditFlag',AuditFlag);
		MatAuditStore.setBaseParam('other',other);
		MatAuditStore.setBaseParam('Sort','');
		MatAuditStore.setBaseParam('dir', 'ASC');
		MatAuditStore.removeAll();
		MatAuditStore.load({
			params:{start:0,limit:StatuTabPagingToolbar.pageSize},			
			callback : function(r,options, success) {
				if(!success){
					//Msg.info("error", "查询错误，请查看日志!");
					//return false;
				}
			}
		});
	}
});
// 清空按钮
var ClearBT = new Ext.Toolbar.Button({
	text : '清空',
	tooltip : '点击清空',
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		M_InciCode.setValue("");
		M_InciDesc.setValue("");
		M_StkGrpType.setValue("");
		M_StkGrpType.getStore().load();
		M_StkCat.setValue("");	
		DateFrom.setValue("");
		DateTo.setValue("");
		MatAuditGrid.getStore().removeAll();
		MatAuditGrid.getView().refresh();
		StatuTabPagingToolbar.getComponent(4).setValue(1);   //设置当前页码
		StatuTabPagingToolbar.getComponent(5).setText("页,共 1 页");//设置共几页
		StatuTabPagingToolbar.getComponent(12).setText("没有记录"); //设置记录条数
	}
});
// 审批按钮
var AuditYesBT = new Ext.Toolbar.Button({
	id : "AuditYesBT",
	text : '审核通过',
	tooltip : '点击审核通过',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
			Audit();
	}
});

/**
* 审核
*/
function Audit() {
	var IdStr=""
	var rowDataArr = MatAuditGrid.getSelectionModel().getSelections();
	if (Ext.isEmpty(rowDataArr)) {
		Msg.info("warning", "请选择审核的记录!");
		return;
	}
	for(i=0;i<rowDataArr.length;i++){
		var rowData=rowDataArr[i];
		var LastauditFlag = rowData.get("LastauditFlag");
		if (LastauditFlag == "Y") {
			//Msg.info("warning", "记录已审核，请核实!");
			continue ;
		}
		var MALGitmRowId = rowData.get("MALGitmRowId");
		var Incid = rowData.get("Incid");
		if (IdStr=="")
		{
			IdStr=Incid+"@"+MALGitmRowId;
		}else{
			IdStr=IdStr+"^"+Incid+"@"+MALGitmRowId;
		}
	}

	if(IdStr==""){Msg.info("warning", "没有可以审核的记录!");return}
	var url = MatAuditUrl+"?actiontype=AuditStr&IdStr="+ IdStr;
	var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			loadMask.hide();
			var retinfo=jsonData.info;
			var retarr=retinfo.split("^");
			var Ret=retarr[0];
			var total=retarr[1];
			var sucess=retarr[2];
			if (jsonData.success == 'true') {
				Msg.info("success", "共"+total+"条记录,成功审核"+sucess+"条记录!");
				SearchBT.handler();
			} else {
				if(Ret==-1){
					Msg.info("error", "无登录信息，请重新登录!");
				}else if(Ret==-2){
					Msg.info("error", "您没有审核权限，请去库房管理维护下维护!");
				}else if(Ret==-3){
					Msg.info("error", "更新审核状态失败!");
				}else{
					Msg.info("error", "审核失败:"+Ret);
				}
			}
			
		},
		scope : this
	});
}
// 审批按钮
var AuditNoBT = new Ext.Toolbar.Button({
	id : "AuditNoBT",
	text : '审核不通过',
	tooltip : '点击审核不通过',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
			AuditNo();
	}
});

/**
* 审核
*/
function AuditNo() {
	var IdStr=""
	var rowDataArr = MatAuditGrid.getSelectionModel().getSelections();
	if (Ext.isEmpty(rowDataArr)) {
		Msg.info("warning", "请选择审核的记录!");
		return;
	}
	for(i=0;i<rowDataArr.length;i++){
		var rowData=rowDataArr[i];
		var LastauditFlag = rowData.get("LastauditFlag");
		if (LastauditFlag == "Y") {
			//Msg.info("warning", "记录已审核，请核实!");
			continue ;
		}
		var MALGitmRowId = rowData.get("MALGitmRowId");
		var Incid = rowData.get("Incid");
		if (IdStr=="")
		{
			IdStr=Incid+"@"+MALGitmRowId;
		}else{
			IdStr=IdStr+"^"+Incid+"@"+MALGitmRowId;
		}
	}

	if(IdStr==""){Msg.info("warning", "没有可以审核的记录!");return}
	var url = MatAuditUrl+"?actiontype=AuditNoStr&IdStr="+ IdStr;
	var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			loadMask.hide();
			var retinfo=jsonData.info;
			var retarr=retinfo.split("^");
			var Ret=retarr[0];
			var total=retarr[1];
			var sucess=retarr[2];
			if (jsonData.success == 'true') {
				Msg.info("success", "共"+total+"条记录,成功审核"+sucess+"条记录!");
				SearchBT.handler();
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "无登录信息，请重新登录!");
				}else if(Ret==-2){
					Msg.info("error", "您没有审核权限，请去库房管理维护下维护!");
				}else if(Ret==-3){
					Msg.info("error", "更新审核状态失败!");
				}else if(Ret==-4){
					Msg.info("error", "还原修改信息失败!");
				}else{
					Msg.info("error", "审核失败:"+Ret);
				}
			}
			
		},
		scope : this
	});
}
var HisListTab = new Ext.ux.FormPanel({
	labelWidth: 60,
	title:'物资审核信息查询',
	tbar : [SearchBT, '-', ClearBT, '-', AuditYesBT, '-', AuditNoBT],
	items:[{
		xtype:'fieldset',
		title:'查询条件',
		layout: 'column',    
		defaults : {xtype: 'fieldset', border : false},
		style:'padding:0px 0px 0px 5px',
		items : [{
			columnWidth: 0.25,
			items: [M_InciCode,M_InciDesc,DateFrom]
		}, {
			columnWidth: 0.25,
			items : [M_StkGrpType,M_StkCat,DateTo]
		}, {
			columnWidth: 0.25,
			items : [AuditFlag]
		}/*, {
			columnWidth: 0.25,
			items : [M_HighPrice,M_ChargeFlag,M_ImplantationMat,Spec,Brand,Vendor]
		}*/]
	}]
});
var viewport = new Ext.ux.Viewport({
            layout: 'border',           
            title: '物资审核',
            items: [HisListTab, MatAuditGrid]
        });
})