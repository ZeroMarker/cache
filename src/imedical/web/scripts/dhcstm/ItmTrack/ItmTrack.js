// 名称:高值材料跟踪查询
// 编写日期:2013-05-14
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var inciDr="";

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
var ORStartDate = new Ext.ux.DateField({
	id:'ORStartDate',
	listWidth:100,
    allowBlank:false,
	fieldLabel:'医嘱开始日期',
	value:new Date()
});

var OREndDate = new Ext.ux.DateField({
	id:'OREndDate',
	listWidth:100,
    allowBlank:false,
	fieldLabel:'医嘱结束日期',
	value:DefaultEdDate()
});
var DateFlag = new Ext.form.Checkbox({
	boxLabel : '不按注册日期',
	id : 'DateFlag',
	anchor : '90%',
	checked : true
});
var ORDateFlag = new Ext.form.Checkbox({
	boxLabel : '按医嘱日期',
	id : 'ORDateFlag',
	anchor : '100%',
	checked : false,
	listeners : {
		check : function(checkBox, checked){
			if(checked){
				Ext.getCmp('DateFlag').setValue(true);
			}
		}
	}
});
var CurrPhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '当前科室',
	id : 'CurrPhaLoc',
	anchor:'90%',
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
		
var PrintStatus = new Ext.form.ComboBox({
	fieldLabel : '打印状态',
	id : 'PrintStatus',
	name : 'PrintStatus',
	anchor:'90%',
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
	sortable:true
});

//呆滞标志
var SluggishFlag = new Ext.form.Checkbox({
	id : 'SluggishFlag',
	boxLabel : '天数',
	anchor : '90%',
	checked : false,
	listeners : {
		check : function(checkbox, checked){
			if(checked && SluggishGap.getValue()===''){
				SluggishGap.setValue(1);
			}
			if(CurStatus.getValue() != '' && CurStatus.getValue() != 'Enable'){
				CurStatus.setValue('Enable');
			}
		}
	}
});

//呆滞天数
var SluggishGap = new Ext.form.NumberField({
	id : 'SluggishGap',
	anchor : '90%',
	width : 50
});

var SluggishComp = new Ext.form.CompositeField({
	fieldLabel : '呆滞',
	anchor : '90%',
	items : [SluggishFlag,SluggishGap]
});

//配置数据源
var ItmTrackUrl = 'dhcstm.itmtrackaction.csp';

var MasterStore = new Ext.data.JsonStore({
	url : ItmTrackUrl+'?actiontype=Query',
	totalProperty : "results",
	root : 'rows',
	fields : ["rowid","inci","inciCode","inciDesc","label","status","incib","incibNo","spec","uomDesc",
				"currentLoc","vendor","date","time","user","OldOrginalBarCode","originalCode","expDate","manfId","manfName","RpPuruom","specDesc","PrintFlag",
				"VenMatManLic","ManfProPermit"]
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
		renderer : PrintRenderer
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
		header : "出厂自带条码",
		dataIndex : 'OldOrginalBarCode',
		hidden : true,		//不唯一自带条码(和下方的originalCode,根据项目需求使用一个就够了)
		width : 150
	}, {
		header : "自带条码",
		dataIndex : 'originalCode',
		hidden : false,
		width : 150
	}, {
		header : "状态",
		dataIndex : 'status',
		width : 60,
		align : 'center',
		sortable : true,
		renderer : statusRenderer
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
		header : "条码生成(注册)日期",
		dataIndex : 'date',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "条码生成(注册)时间",
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
	}, {
		header : "供应商经营许可",
		dataIndex : 'VenMatManLic',
		width : 150
	}, {
		header : "厂商生产许可",
		dataIndex : 'ManfProPermit',
		width : 150
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
					params:{start:0,limit:999,dir:'DESC'},
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
	bbar:MasterGridToolbar,
	listeners : {
		rowdblclick : function(grid, rowIndex, e){
			var record = this.getStore().getAt(rowIndex);
			var dhcit = record.get('rowid');
			if(Ext.isEmpty(dhcit)){
				return;
			}
			var BarCode = record.get('label');
			var IncDesc = record.get('inciDesc');
			var InfoStr = BarCode + ' : ' + IncDesc;
			BarCodePackItm(dhcit, InfoStr);
		}
	}
});


var DetailStore = new Ext.data.JsonStore({
	url : ItmTrackUrl+'?actiontype=QueryItem',
	root : 'rows',
	fields : ["RowId","Type","Pointer","OperNo","loc","specification","Date","Time","User","OperOrg","IntrFlag"]
});

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
		header : "台帐标记",
		dataIndex : 'IntrFlag',
		width : 80,
		xtype : 'checkcolumn'
	},{
		header : "处理号",
		dataIndex : 'OperNo',
		width : 200
	}, {
		header : "业务发生日期",
		dataIndex : 'Date',
		width : 100
	}, {
		header : "业务发生时间",
		dataIndex : 'Time',
		width : 100
	}, {
		header : "业务操作人",
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
	height:gGridHeight,
	split: true,
	collapsible:true,
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
	if(!Ext.isEmpty(inciDr)){
		inciDesc="";
	}
	var StartDate=Ext.getCmp("StartDate").getValue();
	var EndDate=Ext.getCmp("EndDate").getValue();
	if(StartDate>EndDate){
		Msg.info("warning","起始日期不得大于截止日期!");
		return;
	}
	if(StartDate!=""){
		StartDate = StartDate.format(ARG_DATEFORMAT);
	}
	if(EndDate!=""){
		EndDate = EndDate.format(ARG_DATEFORMAT);
	}
	var originalCode = Ext.getCmp("originalCode").getValue();
	var CurStatus = Ext.getCmp("CurStatus").getValue();
	var DateFlag = Ext.getCmp('DateFlag').getValue()?'Y':'N';
	var RegNo = Ext.getCmp("Regno").getValue();
	var CurrPhaLoc = Ext.getCmp("CurrPhaLoc").getValue();
	var batno=Ext.getCmp("batno").getValue();
	var ORDateFlag= Ext.getCmp('ORDateFlag').getValue()?'Y':'N';
	if(ORDateFlag=="Y"){
		var ORStartDate=Ext.getCmp("ORStartDate").getValue();
		var OREndDate=Ext.getCmp("OREndDate").getValue();
		if(ORStartDate!=""){
			ORStartDate = ORStartDate.format(ARG_DATEFORMAT);
		}
		if(OREndDate!=""){
			OREndDate = OREndDate.format(ARG_DATEFORMAT);
		}
	}else{
		ORStartDate="";
		OREndDate="";
	}
	var SluggishFlag = Ext.getCmp('SluggishFlag').getValue()?'Y':'N';
	var SluggishGap = Ext.getCmp('SluggishGap').getValue();
	var Others=Vendor+"^"+StartDate+"^"+EndDate+"^"+originalCode+"^"+CurStatus
			+"^"+DateFlag+"^"+RegNo+"^"+CurrPhaLoc+"^"+batno+"^"+printstau
			+"^"+inciDesc+"^"+ORStartDate+"^"+OREndDate+"^"+SluggishFlag
			+"^"+SluggishGap;
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
			var count = MasterGrid.getStore().getCount();
			for(var rowIndex=0;rowIndex<count;rowIndex++){
				var RowData = MasterGrid.getStore().getAt(rowIndex);
				var print = RowData.get('print');
				if(print!="Y"){
					continue;
				}
				var barcode = RowData.get("label");	
				var printflag = RowData.get("PrintFlag");
				if (printflag=="Y" && !confirm(barcode+"条码已经打印,是否继续打印？")){
					return;
				}
				PrintBarcode(barcode);
			}
		}
	});

var printBarCode2 = new Ext.Toolbar.Button({
		text : '打印条码2次',
		iconCls : 'page_print',
		width : 70,
		height : 30,
		handler : function(button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var count = MasterGrid.getStore().getCount();
			for(var rowIndex=0;rowIndex<count;rowIndex++){
				var RowData = MasterGrid.getStore().getAt(rowIndex);
				var print = RowData.get('print');
				if(print!="Y"){
					continue;
				}
				var barcode = RowData.get("label");	
				var printflag = RowData.get("PrintFlag");
				if (printflag=="Y" && !confirm(barcode+"条码已经打印,是否继续打印？")){
					return;
				}
				PrintBarcode(barcode,2);
			}
		}
	});

var printBarCodeAll = new Ext.Toolbar.Button({
		text : '打印本页条码',
		iconCls : 'page_print',
		width : 70,
		height : 30,
		handler : function(button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var count = MasterGrid.getStore().getCount();
			for (var i = 0; i < count; i++) {
				var RowData = MasterGrid.getStore().getAt(i);
				var barcode = RowData.get('label');
				var printflag = RowData.get("PrintFlag");
				PrintBarcode(barcode);
			}
		}
	});
var printBarCodeAll2 = new Ext.Toolbar.Button({
		text : '打印本页条码2次',
		iconCls : 'page_print',
		width : 70,
		height : 30,
		handler : function(button, e) {
			DHCP_GetXMLConfig("DHCSTM_Barcode");
			var count = MasterGrid.getStore().getCount();
			for (var i = 0; i < count; i++) {
				var RowData = MasterGrid.getStore().getAt(i);
				var barcode = RowData.get('label');
				var printflag = RowData.get("PrintFlag");
				PrintBarcode(barcode,2);
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
	var TrackId=rowData.get("rowid")
	fileName="{DHCSTM_ItmTrack_Common.raq(TrackId="+TrackId+";HospDesc="+App_LogonHospDesc+")}";
	if(ItmTrackParamObj.IndirPrint!="N")
	{
		fileName=TranslateRQStr(fileName);
		DHCSTM_DHCCPM_RQPrint(fileName);
	}
	else{
		DHCCPM_RQDirectPrint(fileName);
	}
}
var UpPicBT = new Ext.Toolbar.Button({
		text : '上传图片',
		tooltip : '点击上传',
		width : 70,
		height : 30,
		handler : function() {
			UpPicture();
		}
	});
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
	title:'高值材料跟踪',
	labelWidth : 80,
	tbar:[queryBT,'-',clearBT,'-',printBarCode,'-',printBarCode2,'-',printBarCodeAll,'-',printBarCodeAll2,'-',PrintBT,'-',UpPicBT],
	items : [{
		xtype : 'fieldset',
		title : '查询条件',
		autoHeight : true,
		layout : 'column',
		items : [{
			columnWidth : .2,
			layout : 'form',
			items : [label,originalCode,inciDesc,PrintStatus]
		}, {
			columnWidth : .2,
			layout : 'form',
			items : [Vendor,RegnoDetail,Regno,SluggishComp]
		}, {
			columnWidth : .2,
			layout : 'form',
			items : [CurStatus,CurrPhaLoc,batno]
		}, {
			columnWidth : .2,
			layout : 'form',
			items : [StartDate, EndDate, DateFlag]
		}, {
			columnWidth : .2,
			layout : 'form',
			labelWidth : 100,
			items : [ORStartDate, OREndDate, ORDateFlag]
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

function UpPicture() {
	var rowData=MasterGrid.getSelectionModel().getSelected();
	if(rowData==null){
		Msg.info("warning!","请选择需要上传图片的高值信息!");
		return;
	}
	var TrackId=rowData.get("rowid")
	var dialog = new Ext.ux.UploadDialog.Dialog({
			width: 600,
			height: 400,
			url: 'dhcstm.barcodeaction.csp?actiontype=Upload&TrackId=' + TrackId,
			reset_on_hide: false,
			permitted_extensions: ['gif', 'jpeg', 'jpg', 'png', 'bmp'],
			allow_close_on_upload: true,
			upload_autostart: false,
			title: '上传高值图片'
		});
	dialog.show();
};