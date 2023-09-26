// 名称:高值材料跟踪查询退货
// 编写日期:2016-06-14
var impWindow = null;
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gLocId=session['LOGON.CTLOCID'];
var inciDr="";
var loadMask=null;
var colArr=[];

//取高值管理参数
var UseRet="";
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseRet=gItmTrackParam[4];
	if(UseRet=='Y'){
	}else{
		Msg.info("warning","此菜单不使用!");
	}
}
	
var inciDesc = new Ext.form.TextField({
	fieldLabel : '物资名称',
	id : 'inciDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var inputText=field.getValue();
				GetPhaOrderInfo(inputText,"");
			}
		}
	}
});
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
	inciDr = record.get("InciDr");
	var inciDesc=record.get("InciDesc");
	Ext.getCmp("inciDesc").setValue(inciDesc);
}

var label = new Ext.form.TextField({
	fieldLabel:'条码',
	id : 'label',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e){
			if(e.getKey() == Ext.EventObject.ENTER){
				Query();
			}
		}
	}
});

var originalCode = new Ext.form.TextField({
	fieldLabel:'自带条码',
	id : 'originalCode',
	anchor : '90%'
});

var Vendor = new Ext.ux.VendorComboBox({
	id : 'Vendor',
	anchor:'90%'
});

var StartDate = new Ext.ux.DateField({
	id:'StartDate',
	listWidth:100,
    allowBlank:false,
	fieldLabel:'开始日期',
	value:DefaultStDate()
});

var EndDate = new Ext.ux.DateField({
	id:'EndDate',
	listWidth:100,
    allowBlank:false,
	fieldLabel:'结束日期',
	value:DefaultEdDate()
});

var DateFlag = new Ext.form.Checkbox({
	boxLabel : '不按日期检索',
	id : 'DateFlag',
	anchor : '90%',
	checked : true
});

var CurrPhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '当前科室',
	id : 'CurrPhaLoc',
	anchor:'90%',
	width : 120,
	emptyText : '当前科室...',
	defaultLoc:{}
});

var StatusStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['Reg', '注册'], ['Enable', '可用'], ['Used', '已用'], ['Else', '其他']]
});
var CurStatus = new Ext.form.ComboBox({
	fieldLabel : '条码状态',
	id : 'CurStatus',
	anchor : '90%',
	store : StatusStore,
	valueField : 'RowId',
	displayField : 'Description',
	mode : 'local',
	allowBlank : true,
	triggerAction : 'all',
	selectOnFocus : true,
	listWidth : 150,
	forceSelection : true
});
var batno = new Ext.form.TextField({
	fieldLabel:'批号',
	id : 'batno',
		anchor : '90%'
});
var Regno = new Ext.form.TextField({
	fieldLabel : '登记号',
	id : 'Regno',
	anchor : '90%',
	enableKeyEvents : true,
	listeners : {
		keydown : function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				var regno = field.getValue();
				Ext.Ajax.request({
					url: 'dhcstm.matordstataction.csp?actiontype=Getpainfo',
					params : {regno : regno},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							var value = jsonData.info;
							var arr = value.split("^");
							//基础信息
							field.setValue(arr[0]);
							Ext.getCmp('RegnoDetail').setValue(arr.slice(1));
						}
					},
					scope: this
				});
			}
		}
	}
});
var RegnoDetail = new Ext.form.TextField({
	fieldLabel : '登记号信息',
	id : 'RegnoDetail',
	disabled:true,
	anchor : '90%'
});

//打印状态
var PrintStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['0', '全部'], ['1', '未打印'],
			['2', '已打印']]
});

// 保存按钮
var SaveBT = new Ext.Toolbar.Button({
	id : "SaveBT",
	text : '确认',
	tooltip : '点击确认',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		// 保存库存项规格
		Save();	
	}
});
	
var PrintStatus = new Ext.form.ComboBox({
	fieldLabel : '打印状态',
	id : 'PrintStatus',
	name : 'PrintStatus',
	anchor:'90%',
	width : 120,
	store : PrintStore,
	triggerAction : 'all',
	mode : 'local',
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : false,
	triggerAction : 'all',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	editable : true,
	valueNotFoundText : ''
});
Ext.getCmp("PrintStatus").setValue(0);

//多选打印
var print = new Ext.grid.CheckColumn({
	header:'打印',
	dataIndex:'print',
	width:60,
	hidden : true,
	sortable:true
});
//配置数据源
var ItmTrackUrl = 'dhcstm.itmtrackaction.csp';

var MasterStore = new Ext.data.JsonStore({
	url : ItmTrackUrl+'?actiontype=Query',
	totalProperty : "results",
	root : 'rows',
	fields : ["rowid","inci","inciCode","inciDesc","label","status","incib","incibNo","spec","uomDesc",
				"currentLoc","vendor","date","time","user","originalCode","expDate","manfId","manfName","RpPuruom","specDesc","PrintFlag","retoriflag"]
});

//模型
var MasterGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(), {
		header : "rowid",
		dataIndex : 'rowid',
		hidden : true
	}, {
		header : "inci",
		dataIndex : 'inci',
		width : 100,
		align : 'left',
		hidden : true
	},print, {
		header : "打印标记",
		dataIndex : 'PrintFlag',
		width : 100,
		align : 'left',
		sortable : false,
		hidden : true,
		renderer : PrintRenderer
	},{
		header : "库房确认",
		dataIndex : 'retoriflag',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "物资代码",
		dataIndex : 'inciCode',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "物资名称",
		dataIndex : 'inciDesc',
		width : 200,
		align : 'left',
		sortable : true
	}, {
		header : "条码",
		dataIndex : 'label',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "自带条码",
		dataIndex : 'originalCode',
		width : 150
	}, {
		header : "状态",
		dataIndex : 'status',
		renderer : statusRenderer,
		width : 60,
		align : 'center',
		sortable : true
	}, {
		header : "批号id",
		dataIndex : 'incib',
		width : 150,
		align : 'left',
		hidden : true,
		sortable : true
	}, {
		header : "批号~效期",
		dataIndex : 'incibNo',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "规格",
		dataIndex : 'spec',
		width : 100,
		align : 'left',
		sortable : true
	},{
		header : "具体规格",
		dataIndex : 'specDesc',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "单位",
		dataIndex : 'uomDesc',
		width : 60,
		align : 'left',
		sortable : true
	}, {
		header : "供应商",
		dataIndex : 'vendor',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "厂商",
		dataIndex : 'manfName',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "当前位置",
		dataIndex : 'currentLoc',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "日期",
		dataIndex : 'date',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "时间",
		dataIndex : 'time',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "操作人",
		dataIndex : 'user',
		width : 100,
		align : 'left',
		sortable : true
	}
]);
//初始化默认排序功能
MasterGridCm.defaultSortable = true;

var MasterGridToolbar = new Ext.PagingToolbar({
	store:MasterStore,
	pageSize:20,
	displayInfo:true
});

//Master表格
var MasterGrid = new Ext.ux.GridPanel({
	region:'center',
	id:'MasterGrid',
	title:'材料信息',
	store:MasterStore,
	cm:MasterGridCm,
	trackMouseOver:true,
	stripeRows:true,
	plugins:print,
	sm : new Ext.grid.RowSelectionModel({
		singleSelect:true,
		listeners:{
			'rowselect':function(sm,rowIndex,r){
				var parref = MasterStore.data.items[rowIndex].data["rowid"];
				DetailStore.setBaseParam('Parref',parref);
				DetailStore.removeAll();
				DetailStore.load({
					params:{start:0,limit:999,dir:'ASC'},
					callback:function(r,options,success){
						if(success==false){
							Msg.info('error','查询有误,请查看日志!');
							return;
						}
					}
				});
			}
		}
	}),
	loadMask:true,
	bbar:MasterGridToolbar
});


var DetailStore = new Ext.data.JsonStore({
	url : ItmTrackUrl+'?actiontype=QueryItem',
	root : 'rows',
	fields : ["RowId","Type","Pointer","OperNo","loc","specification","Date","Time","User","OperOrg"]
});

function TypeRenderer(value){
	var TypeDesc=value;
	if(value=="G"){
		TypeDesc="入库";
	}else if(value=="R"){
		TypeDesc="退货";
	}else if(value=="T"){
		TypeDesc="转移出库";
	}else if(value=="K"){
		TypeDesc="转移接收";
	}else if(value=="P"){
		TypeDesc="住院医嘱";
	}else if(value=="Y"){
		TypeDesc="医嘱取消(废除)";
	}else if(value=="A"){
		TypeDesc="库存调整";
	}else if(value=="D"){
		TypeDesc="库存报损";
	}else if(value=="F"){
		TypeDesc="门诊发放";
	}else if(value=="H"){
		TypeDesc="门诊退回";
	}else if(value=="RD"){
		TypeDesc="请求";
	}
	else if(value=="PD"){
		TypeDesc="采购";
	}
	else if(value=="POD"){
		TypeDesc="订单";
	}
	else if(value=="SG"){
		TypeDesc="入库补录";
	}
	else if(value=="ST"){
		TypeDesc="转移出库补录";
	}
	else if(value=="SK"){
		TypeDesc="转移接收补录";
	}
	else if(value=="SR"){
		TypeDesc="退货补录";
	}
	return TypeDesc;
}
function PrintRenderer(value){
	var printFlag=value;
	if (value=="Y"){
	   printFlag="已打印";
	}
	return printFlag;
}
//模型
var DetailGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(), {
		header : "detailRowid",
		dataIndex : 'RowId',
		hidden : true
	}, {
		header : "类型",
		dataIndex : 'Type',
		width : 100,
		align : 'left',
		renderer : TypeRenderer
	}, {
		header : "Pointer",
		dataIndex : 'Pointer',
		width : 100,
		hidden : true
	}, {
		header : "处理号",
		dataIndex : 'OperNo',
		width : 200
	}, {
		header : "日期",
		dataIndex : 'Date',
		width : 100
	}, {
		header : "时间",
		dataIndex : 'Time',
		width : 100
	}, {
		header : "操作人",
		dataIndex : 'User',
		width : 100
	}, {
		header : "位置信息",
		dataIndex : 'OperOrg',
		width : 200
	}]);

//Detail表格
var DetailGrid = new Ext.ux.GridPanel({
	id:'DetailGrid',
	region:'south',
	height:250,
	title:'材料明细信息',
	store:DetailStore,
	cm:DetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true
});

var queryBT = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		Query();
	}
});

function Query(){
	var inciDesc=Ext.getCmp("inciDesc").getValue();
	var label=Ext.getCmp("label").getValue();
	var Vendor=Ext.getCmp("Vendor").getValue();
	var printstau=Ext.getCmp("PrintStatus").getValue();
	if(inciDesc==""){
		inciDr="";
	}
	var StartDate=Ext.getCmp("StartDate").getValue();
	var EndDate=Ext.getCmp("EndDate").getValue();
	if(StartDate!=""){
		StartDate = StartDate.format(ARG_DATEFORMAT);
	}
	if(EndDate!=""){
		EndDate = EndDate.format(ARG_DATEFORMAT);
	}
	if(StartDate>EndDate){
		Msg.info("warning","起始日期不得大于截止日期!");
		return;
	}	
	var originalCode = Ext.getCmp("originalCode").getValue();
	var CurStatus = Ext.getCmp("CurStatus").getValue();
	var DateFlag = Ext.getCmp('DateFlag').getValue()?'Y':'N';
	var RegNo = Ext.getCmp("Regno").getValue();
	var RegNo=""
	var CurrPhaLoc = Ext.getCmp("CurrPhaLoc").getValue();
	var batno=Ext.getCmp("batno").getValue();
	var batno=""
	var Others=Vendor+"^"+StartDate+"^"+EndDate+"^"+originalCode+"^"+CurStatus
			+"^"+DateFlag+"^"+RegNo+"^"+CurrPhaLoc+"^"+batno+"^"+printstau;
	//alert(Others)
	MasterStore.setBaseParam('inci',inciDr);
	MasterStore.setBaseParam('label',label);
	MasterStore.setBaseParam('others',Others);
	DetailStore.removeAll();
	MasterStore.removeAll();
	MasterStore.load({
		params:{start:0,limit:MasterGridToolbar.pageSize},
		callback : function(r,options, success){
			if(success==false){
				Msg.info("error", "查询错误，请查看日志!");
			}else{
				if(r.length>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
			}
		}
	});
}
function Save(){
	//var label=Ext.getCmp("label").getValue();
	var rowData=MasterGrid.getSelectionModel().getSelected();
	if(rowData==null){
		Msg.info("warning!","请选择需要确认的高值信息!");
		return;
	}
	var label=rowData.get("label")
	var retoriflag=rowData.get("retoriflag")
	if(retoriflag=="Y"){
	    Msg.info("warning!","已确认!");
		return;
	}
	var url =  "dhcstm.itmtrackaction.csp?actiontype=SaveHv&LAbel="+label;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '处理中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "确认成功!");
                Query();					
			} else {
				Msg.info("error", "确认失败:"+jsonData.info);
			}
		},
		scope : this
	});
}
var clearBT = new Ext.Toolbar.Button({
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		clearPanel(formPanel);
		Ext.getCmp('DateFlag').setValue(true);
		Ext.getCmp('StartDate').setValue(new Date().add(Date.DAY,-30));
		Ext.getCmp('EndDate').setValue(new Date());
		Ext.getCmp("PrintStatus").setValue(0);
		DetailStore.removeAll();
		MasterStore.removeAll();
	}
});
var printBarCode = new Ext.Toolbar.Button({
	text : '打印条码',
	iconCls : 'page_print',
	width : 70,
	height : 30,
	handler : function(button, e) {
		DHCP_GetXMLConfig("DHCSTM_Barcode");
		var count=MasterGrid.getStore().getCount();
		for(var rowIndex=0;rowIndex<count;rowIndex++){	
		var print=MasterGrid.getStore().getAt(rowIndex).get('print');
		if(print!="Y"){continue}
		var barcode=MasterGrid.getStore().getAt(rowIndex).get("label");	
		var IncDesc=MasterGrid.getStore().getAt(rowIndex).get("inciDesc");
		var Spec=MasterGrid.getStore().getAt(rowIndex).get("spec");	
		var printflag=MasterGrid.getStore().getAt(rowIndex).get("PrintFlag");
		var MyPara='BarCode'+String.fromCharCode(2)+"*"+barcode+"*"
				+'^IncDesc'+String.fromCharCode(2)+IncDesc
				+'^Spec'+String.fromCharCode(2)+Spec;
		if (printflag=="Y"){
			var ret=confirm(barcode+"条码已经打印,是否继续打印？");
			var printflag="已打印";
			if(ret==true){
			var MyPara=MyPara+'^PrintFlag'+String.fromCharCode(2)+printflag;
			DHCP_PrintFun(MyPara,"");
			}else{
			return;
			}
		}else{
			DHCP_PrintFun(MyPara,"");
			var PrintFlag="Y"
			SavePrintFlag(PrintFlag,barcode);
		}
			
	  }
	}
});
//打印按钮
var PrintBT = new Ext.Toolbar.Button({
	text : '打印',
	tooltip : '点击打印',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
			Print();
	}
});	
function Print(){
	var rowData=MasterGrid.getSelectionModel().getSelected();
	if(rowData==null){
		Msg.info("warning!","请选择需要打印的高值信息!");
		return;
	}
	var label=rowData.get("label")
	var MainData=GetData(label)
	var mainArr=mainData.split("^");
	var incidesc=mainArr[0]
	var manfdesc=mainArr[1]
	var BusinessRegNo=mainArr[2]
	var vendordec=mainArr[3]
	var inforemark=mainArr[4]
	var batno=mainArr[5]
	var expdate=mainArr[6]
	var spec=mainArr[7]
	var sp=mainArr[8]
	
	fileName="{DHCSTM_ItmTrack_Common.raq(incidesc="+incidesc+";manfdesc="+manfdesc+";BusinessRegNo="+BusinessRegNo+";vendordec="+vendordec+";inforemark="+inforemark+";batno="+batno+";expdate="+expdate+";spec="+spec+";sp="+sp+")}";
	DHCCPM_RQDirectPrint(fileName);
}	
function GetData(label){
	if(label==null||label==""){
		return;
	}
	var url='dhcstm.itmtrackaction.csp?actiontype=Select&label='+label;	
	var responseText=ExecuteDBSynAccess(url);
	var jsonData=Ext.util.JSON.decode(responseText);
	if(jsonData.success=='true'){
		mainData=jsonData.info;
	}
	return mainData;
}		
var formPanel = new Ext.ux.FormPanel({
	title:'高值退库库房确认',
	tbar:[queryBT,'-',clearBT,'-',SaveBT],
	layout:'fit',
	items : [{
		xtype : 'fieldset',
		title : '查询条件',
		autoHeight : true,
		items : [{
			layout : 'column',
			items : [{
				columnWidth : .20,
				layout : 'form',
				items : [label,originalCode]
			}, {
				columnWidth : .20,
				layout : 'form',
				items : [StartDate, EndDate]
			}, {
				columnWidth : .20,
				layout : 'form',
				items : [DateFlag]
			}]
		}]
	}]
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,MasterGrid,DetailGrid],
		renderTo:'mainPanel'
	});
});

function SavePrintFlag(PrintFlag,Barecode){
	  tkMakeServerCall("web.DHCSTM.DHCItmTrack","SavePrintFlag",PrintFlag,Barecode);
}
