// /名称: 高值医嘱(医嘱包类型比如关节置换手术)绑定高值条码,消减库存
// /编写者：wangjiabin
// /编写日期: 2015.06.18

var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var actionUrl = DictUrl + 'oeoribindbarcodeaction.csp';

var RecLoc = new Ext.ux.LocComboBox({
	id:'RecLoc',
	fieldLabel:'医嘱接收科室',
	anchor:'90%',
	defaultLoc:{}
});
SetLogInDept(RecLoc.getStore(), 'RecLoc');

// 起始日期
var StartDate = new Ext.ux.DateField({
	fieldLabel : '起始日期',
	id : 'StartDate',
	anchor : '90%',
	
	width : 100,
	value : new Date()
});

// 截止日期
var EndDate = new Ext.ux.DateField({
	fieldLabel : '截止日期',
	id : 'EndDate',
	anchor : '90%',
	
	width : 100,
	value : new Date()
});
/*
 * 所有医嘱子类ComboBox
 */
var AllArcItemCatStore = new Ext.data.Store({
		proxy : new Ext.data.HttpProxy({
					url : 'dhcstm.drugutil.csp?actiontype=AllArcItemCat'
				}),
		reader : new Ext.data.JsonReader({
					totalProperty : "results",
					root : 'rows'
				}, ['Description', 'RowId'])
});
var ARCItemCat = new Ext.ux.ComboBox({
	fieldLabel : '医嘱子类',
	id : 'ARCItemCat',
	store : AllArcItemCatStore,
	filterName : 'Desc'
});

var Regno = new Ext.form.TextField({
	fieldLabel : '登记号',
	id : 'Regno',
	anchor : '90%',
	enableKeyEvents:true,
	listeners:{
		keydown:function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				var regno=field.getValue();
				Ext.Ajax.request({
					url: 'dhcstm.matordstataction.csp?actiontype=Getpainfo',
					params : {regno :regno},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							var value = jsonData.info;
							var arr = value.split('^');
							//基础信息
							field.setValue(arr[0]);
							Ext.getCmp('RegnoDetail').setValue(arr.slice(1));
						}
					},
					scope: this
				});
			}
		},
		blur : function(field){
			if(field.getValue() == ''){
				Ext.getCmp('RegnoDetail').setValue('');
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
var oeoriname = new Ext.form.TextField({
	fieldLabel : '医嘱名称',
	id : 'oeoriname',
	anchor : '90%'
});

// 查询按钮
var SearchBT = new Ext.Toolbar.Button({
	id:'SearchBT',
	text : '查询',
	tooltip : '点击查询',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		MasterGrid.load();
	}
});

// 清空按钮
var ClearBT = new Ext.Toolbar.Button({
	id:'ClearBT',
	text : '清空',
	tooltip : '点击清空',
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		clearData();
	}
});

function clearData() {
	clearPanel(HisListTab);
	HisListTab.getForm().setValues({StartDate:new Date(),EndDate:new Date()});
	MasterGrid.removeAll();
	DetailGrid.removeAll();
	BarCodeValidator.setValue('');
}

var SaveBT = new Ext.ux.Button({
	id:'SaveBT',
	text : '保存',
	tooltip : '保存高值条码信息',
	iconCls : 'page_save',
	handler : function() {
		Save();
	}
});

function Save(){
	var MasterSel = MasterGrid.getSelected();
	if(Ext.isEmpty(MasterSel)){
		Msg.info('warning', '请选择需要保存的医嘱!');
		return false;
	}
	var Oeori = MasterSel.get('Oeori');
	var MainInfo = Oeori + '^' + gUserId;
	var ListDetail = DetailGrid.getModifiedInfo();
	if(ListDetail == ''){
		Msg.info('warning', '没有需要保存的内容');
		return false;
	}
	var AckFlag = DetailGrid.getAt(0).get('AckFlag');
	if(AckFlag == 'Y'){
		Msg.info('error', '该医嘱已经审核!');
		DetailGrid.reload();
		return false;
	}
	var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
	Ext.Ajax.request({
		url : actionUrl + '?actiontype=Save',
		params : {MainInfo : MainInfo, ListDetail : ListDetail},
		method : 'POST',
		waitMsg : '处理中...',
		//async:true ,
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				Msg.info('success', '保存成功!');
				//MasterGrid.reload();
				DetailGrid.reload();
			} else {
				var info=jsonData.info;
				var infoArr=info.split("^");
				if (infoArr[0]==-3){
					Msg.info('error', "条码"+infoArr[1]+"不存在科室"+LocDesc);
				}else{
				    Msg.info('error', '保存失败:'+info);
				}
			}
		},
		scope : this
	});
}

var AuditBT = new Ext.ux.Button({
	id:'AuditBT',
	text : '审核确认',
	tooltip : '点击审核确认',
	iconCls : 'page_gear',
	handler : function() {
			Ext.Msg.show({
				title:'提示',
				msg: '审核前请确认绑定条码无误',
				buttons: Ext.Msg.YESNO,
				fn: function(b,t,o){
					if (b=='yes'){Audit();}
				},
				icon: Ext.MessageBox.QUESTION
			});
	}
});

function Audit() {
	var MasterSel = MasterGrid.getSelected();
	if(Ext.isEmpty(MasterSel)){
		Msg.info('warning', '请选择需要审核的医嘱!');
		return false;
	}
	var DetailCount = DetailGrid.getStore().getTotalCount();
	if(DetailCount == 0){
		Msg.info('warning', '没有需要审核的明细!');
		return false;
	}
	var AckFlag = DetailGrid.getAt(0).get('AckFlag');
	if(AckFlag == 'Y'){
		Msg.info('error', '该医嘱已经审核!');
		return false;
	}
	var Oeori = MasterSel.get('Oeori');
	var loadMask=ShowLoadMask(document.body,'审核中...');
	Ext.Ajax.request({
		url : actionUrl + '?actiontype=Audit',
		params : {Oeori : Oeori, UserId : gUserId},
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				Msg.info('success', '审核成功!');
				DetailGrid.reload();
			} else {
				var Ret=jsonData.info;
				Msg.info('error', '审核失败:'+Ret);
			}
		},
		scope : this
	});
}

// 打印按钮
var PrintBT = new Ext.Toolbar.Button({
	id:'PrintBT',
	text : '打印',
	tooltip : '点击打印',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=MasterGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info('warning', '请选择需要打印的入库单!');
			return;
		}
		var DhcIngr = rowData.get('IngrId');
		PrintRec(DhcIngr);
	}
});

var HisListTab = new Ext.ux.FormPanel({
	title:'高值医嘱条码绑定',
	tbar : [SearchBT, '-', ClearBT, '-', SaveBT, '-', AuditBT],
	items:[{
		xtype:'fieldset',
		title:'查询条件',
		layout: 'column',
		style:'padding:5px 0px 0px 0px;',
		defaults: {width: 220, border:false},
		items : [{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [StartDate, EndDate]
			},{
				columnWidth: 0.25,
				xtype: 'fieldset',
				labelWidth : 85,
				items: [RecLoc, ARCItemCat]
			},{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [RegnoDetail, Regno]
			},{
				columnWidth: 0.25,
				xtype: 'fieldset',
				items: [oeoriname]
			}]
	}]
});

var MasterCm = [{
		header : 'Oeori',
		dataIndex : 'Oeori',
		width : 60,
		hidden : true
	}, {
		header : '医嘱项代码',
		dataIndex : 'ArcimCode',
		width : 120,
		sortable : true
	}, {
		header : '医嘱项名称',
		dataIndex : 'ArcimDesc',
		width : 120,
		sortable : true
	}, {
		header : '患者登记号',
		dataIndex : 'PaAdmNo',
		width : 100,
		sortable : true
	}, {
		header : '患者姓名',
		dataIndex : 'PaAdmName',
		width : 170
	}, {
		header : '接收科室id',
		dataIndex : 'RecLoc',
		hidden : true,
		width : 80
	},  {
		header : '接收科室',
		dataIndex : 'RecLocDesc',
		width : 140
	}, {
		header : '医嘱日期',
		dataIndex : 'OeoriDate',
		width : 80
/*	}, {
		header : '医嘱时间',
		dataIndex : 'OeoriTime',
		width : 80*/
	}, {
		header : '医嘱录入人',
		dataIndex : 'UserAddName',
		width : 100
	}
];

var MasterGrid = new Ext.dhcstm.EditorGridPanel({
	region: 'center',
	title: '医嘱信息',
	id:'MasterGrid',
	childGrid : 'DetailGrid',
	editable : false,
	contentColumns : MasterCm,
	smType : 'row',
	singleSelect : true,
	smRowSelFn : rowSelFn,
	autoLoadStore : true,
	actionUrl : actionUrl,
	queryAction : 'QueryOeori',
	paramsFn : GetMasterParams,
	idProperty : 'IngrId',
	showTBar : false
});

function rowSelFn(sm, rowIndex, r) {
	var rowData = sm.grid.getAt(rowIndex);
	var Oeori = rowData.get('Oeori');
	var StrParam = Oeori;
	DetailGrid.load({params:{StrParam:StrParam}});
}
		
function GetMasterParams(){
	var RecLoc = Ext.getCmp('RecLoc').getValue();
	var StartDate = Ext.getCmp('StartDate').getValue();
	var EndDate = Ext.getCmp('EndDate').getValue();
	if(RecLoc==''){
		Msg.info('warning', '请选择医嘱接收科室!');
		return false;
	}
	if(StartDate==''){
		Msg.info('warning', '请选择开始日期!');
		return false;
	}else{
		StartDate=StartDate.format(ARG_DATEFORMAT).toString();
	}
	if(EndDate==''){
		Msg.info('warning', '请选择截止日期!');
		return false;
	}else{
		EndDate=EndDate.format(ARG_DATEFORMAT).toString();
	}
	var PaAdmNo = Ext.getCmp('Regno').getValue();
	var ARCItemCat = Ext.getCmp('ARCItemCat').getValue();
	var ExcludeInci = 'Y';
	var Oeoriname = Ext.getCmp('oeoriname').getValue();
	var StrParam = StartDate+'^'+EndDate+'^'+PaAdmNo+'^'+RecLoc+'^'+ARCItemCat
		+'^^'+ExcludeInci+'^^'+Oeoriname;
	
	return {'Sort' : '', 'Dir' : '','StrParam' : StrParam};
}

var DetailCm = [{
		header : 'RowId',
		dataIndex : 'RowId',
		saveColIndex : 0,
		width : 80,
		hidden : true
	}, {
		header : 'Dhcit',
		dataIndex : 'Dhcit',
		saveColIndex : 1,
		width : 70,
		hidden : true,
		sortable : true
	}, {
		header : '物资代码',
		dataIndex : 'InciCode',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : '物资名称',
		dataIndex : 'InciDesc',
		width : 150,
		sortable : true
	}, {
		header : '高值条码',
		dataIndex : 'BarCode',
		saveColIndex : 2,
		width : 120,
		sortable : true
	}, {
		header : '生产厂商',
		dataIndex : 'Manf',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : '批次Id',
		dataIndex : 'Inclb',
		width : 180,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : '批号~效期',
		dataIndex : 'BatExp',
		width : 140,
		align : 'left',
		sortable : true
	}, {
		header : '进价',
		dataIndex : 'Rp',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : '记录日期',
		dataIndex : 'OBBDate',
		width : 80,
		sortable : true
	}, {
		header : '记录时间',
		dataIndex : 'OBBTime',
		width : 80,
		sortable : true
	}, {
		header : '记录人',
		dataIndex : 'OBBUser',
		width : 80,
		sortable : true
	}, {
		header : '审核标志',
		dataIndex : 'AckFlag',
		width : 80,
		xtype : 'checkcolumn'
	}, {
		header : '审核日期',
		dataIndex : 'OBBAckDate',
		width : 80,
		sortable : true
	}, {
		header : '审核时间',
		dataIndex : 'OBBAckTime',
		width : 80,
		sortable : true
	}, {
		header : '审核人',
		dataIndex : 'OBBAckUser',
		width : 80,
		sortable : true
	}, {
		header : '取消审核日期',
		dataIndex : 'CancelDate',
		width : 80,
		sortable : true
	}, {
		header : '取消审核时间',
		dataIndex : 'CancelTime',
		width : 80,
		sortable : true
	}, {
		header : '取消审核人',
		dataIndex : 'CancelSSUSR',
		width : 80,
		sortable : true
	}
];

var BarCodeValidator = new Ext.form.TextField({
	fieldLabel : '高值条码',
	width : 200,
	listeners : {
		specialkey : function(field, e){
			var Barcode=field.getValue();
			if (Barcode!="" && e.getKey() == Ext.EventObject.ENTER){
				var findHVIndex = DetailGrid.getStore().findExact('BarCode',Barcode,0);
				if(findHVIndex >= 0){
					Msg.info("warning","不可重复录入!");
					field.setValue("");
					return;
				}
				var MasterSel = MasterGrid.getSelected();
				if(Ext.isEmpty(MasterSel)){
					Msg.info('warning', '请选择需要保存的医嘱!');
					return false;
				}
				var RecLoc = MasterSel.get('RecLoc');
				Ext.Ajax.request({
					url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode',
					params : {'Barcode' : Barcode},
					method : 'POST',
					waitMsg : '查询中...',
					success : function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if(jsonData.success == 'true'){
							var itmArr=jsonData.info.split("^");
							var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
							var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
							if(inclb==""){
								Msg.info("warning", Barcode+" 没有相应库存记录,不能制单!");
								field.setValue('');
								return;
							}else if(lastDetailAudit!="Y"){
								Msg.info("warning", Barcode+" 高值材料有未审核的"+lastDetailOperNo+",请核实!");
								field.setValue('');
								return;
							}else if(type=="T"){
								Msg.info("warning", Barcode+" 高值材料已经出库,不可制单!");
								field.setValue('');
								return;
							}else if(status!="Enable"){
								Msg.info("warning", Barcode+" 高值条码处于不可用状态,不可制单!");
								field.setValue('');
								return;
							}else if(RecLoc!=itmArr[28]){
								Msg.info("warning", Barcode+" 高值条码接收科室和使用科室不一致,不可制单!");
								field.setValue('');
								return;
							}
							var url = "dhcstm.itmtrackaction.csp?actiontype=Select&label=" + Barcode;
							var jsonData = ExecuteDBSynAccess(url);
							var info = Ext.util.JSON.decode(jsonData).info;
							var infoArr = info.split('^');
							var Dhcit = infoArr[11], InciCode = infoArr[10], InciDesc = infoArr[0], Manf = infoArr[1], Inclb = infoArr[12],
								BatchNo = infoArr[5], ExpDate =infoArr[6], Rp = infoArr[9];
							var BatExp = BatchNo + '~' + ExpDate;
							var Values = {Dhcit : Dhcit, InciCode : InciCode, InciDesc : InciDesc, BarCode : Barcode, Manf : Manf,
									Inclb : Inclb, BatExp : BatExp, Rp : Rp};
							var NewRecord = CreateRecordInstance(DetailGrid.getStore().fields, Values);
							DetailGrid.add(NewRecord);
							field.setValue('');
						}else{
							Msg.info("warning","该条码尚未注册!");
							field.setValue('');
							return;
						}
					}
				});
			}
		}
	}
});

var DeleteButton = new Ext.ux.Button({
	id : 'DeleteButton',
	text : '删除一条',
	iconCls : 'page_delete',
	handler : function(){
		var SelRecord = DetailGrid.getSelected();
		if(SelRecord == null){
			Msg.info('warning', '请选择需要删除的明细!');
			return false;
		}
		var RowId = SelRecord.get(DetailGrid.idProperty);
		if(RowId != ''){
			Ext.MessageBox.confirm('提示','确定要删除该记录?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url : actionUrl,
							params : {actiontype : 'Delete', RowId : RowId},
							waitMsg:'删除中...',
							failure: function(result, request) {
								Msg.info('error', '请检查网络连接!');
								return false;
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON.decode(result.responseText);
								if (jsonData.success == 'true') {
									DetailGrid.reload();
								}else{
									Msg.info("error", '删除失败:' + jsonData.info);
									return false;
								}
							},
							scope: this
						});
					}
				}
			)
		}else{
			DetailGrid.remove(SelRecord);
			DetailGrid.getView().refresh();
		}
	}
});

var DetailGrid = new Ext.dhcstm.EditorGridPanel({
	region : 'south',
	split: true,
	height: 250,
	minSize: 200,
	maxSize: 350,
	collapsible: true,
	title: '绑定高值条码明细信息',
	id : 'DetailGrid',
	smType : 'row',
	contentColumns : DetailCm,
	actionUrl : actionUrl,
	queryAction : 'QueryDetail',
	selectFirst : false,
	idProperty : 'RowId',
	checkProperty : 'Dhcit',
	editable : false,
	paging : false,
	showTBar : false,
	tbar : ['高值条码:',BarCodeValidator, '-', DeleteButton]
});
function cancelresult(btn){
	if(btn=="yes"){
	var rows=DetailGrid.getSelectionModel().getSelections();
	var selectedRow = rows[0];
	var DHCOBBRowId=selectedRow.get("RowId");
	var url=actionUrl+"?actiontype=CancelAudit&DHCOBBRowId="+DHCOBBRowId+"&UserId="+gUserId;
	Ext.Ajax.request({
		url:url,
		method:'POST',
		waitMsg:'查询中...',
		success: function(result,request){
			   var jsonData=Ext.util.JSON.decode(result.responseText);
			   if (jsonData.success=="true"){
				   Msg.info("success","取消审核成功!");
	   	           DetailGrid.reload(); 
			   }else{
			       var ret=jsonData.info;
			       if (ret==-2){
				       Msg.info("error","已取消审核或者还未审核！");
				   }else if (ret==-3){
					   Msg.info("error","存在过取消审核记录，不允许再次取消！");
				   }else{
					   Msg.info("error","撤销审核失败！"+ret);
				   }
			   }
			},
		scope:this
	});
	}
}
function CancelAudit(){
	var rows=DetailGrid.getSelectionModel().getSelections();
	if (rows.length == 0){Msg.info("warning","没有选中的行!"); return false;}
	var selectedRow = rows[0];
	var DHCOBBRowId=selectedRow.get("RowId");
	if (DHCOBBRowId==""){
	   	DetailGrid.getView().refresh();
	}else{
	    Ext.MessageBox.show({
		   title:'提示',
		   msg:'是否确定取消审核?',
		   buttons:Ext.MessageBox.YESNO,
		   fn:cancelresult,
		   icon:Ext.MessageBox.QUESTION
	    });	
	}
}
//点击右键取消审核
function rightClickFn(grid,rowindex,e){
	   e.preventDefault();
	   grid.getSelectionModel().selectRow(rowindex);
	   rightClick.showAt(e.getXY());
	}
var rightClick = new Ext.menu.Menu({
	   id : 'rightclickM',
	   items : [{
		     id : 'cancelmenu',
		     handler : CancelAudit,
		     text : '取消审核'
		   }]
	});
DetailGrid.addListener('rowcontextmenu',rightClickFn);

Ext.onReady(function() {
	Ext.QuickTips.init();
	
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, MasterGrid, DetailGrid],
				renderTo : 'mainPanel'
			});
});