// /名称: 高值医嘱打包收费
// /编写者：徐超
// /编写日期: 2015.08.1

var gUserId = session['LOGON.USERID'];
var gLocId = session['LOGON.CTLOCID'];
var gGroupId = session['LOGON.GROUPID'];
var actionUrl = DictUrl + 'oeoribindinciaction.csp';

var RecLoc = new Ext.ux.LocComboBox({
	id:'RecLoc',
	fieldLabel:'医嘱接收科室',
	anchor:'100%',
	defaultLoc:{}
});
SetLogInDept(RecLoc.getStore(), 'RecLoc');

// 起始日期
var StartDate = new Ext.ux.DateField({
	fieldLabel : '起始日期',
	id : 'StartDate',
	anchor:'100%',
	value : new Date()
});

// 截止日期
var EndDate = new Ext.ux.DateField({
	fieldLabel : '截止日期',
	id : 'EndDate',
	anchor:'100%',
	value : new Date()
});

var ARCItemCat = new Ext.ux.ComboBox({
	fieldLabel : '医嘱子类',
	anchor:'100%',
	id : 'ARCItemCat',
	store : ArcItemCatStore,
	filterName : 'Desc'
});
var Specom = new Ext.form.ComboBox({
	fieldLabel : '具体规格',
	id : 'Specom',
	name : 'Specom',
	anchor : '90%',
	listWidth :210,
	store : SpecDescStore,
	valueField : 'Description',
	displayField : 'Description',
	triggerAction : 'all',
	emptyText : '具体规格...',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 10,
	valueNotFoundText : '',
	listeners:({
		'beforequery':function()
		
			{	var cell = DetailGrid.getSelectionModel().getSelectedCell();
				var record = DetailGrid.getStore().getAt(cell[0]);
				var IncRowid = record.get("inci");	
				var desc=this.getRawValue();
				this.store.removeAll();    //load之前remove原记录，否则容易出错
				this.store.setBaseParam('SpecItmRowId',IncRowid)
				this.store.setBaseParam('desc',desc)
				this.store.load({params:{start:0,limit:this.pageSize}})
			} 
	})
});

var Regno = new Ext.form.TextField({
	fieldLabel : '登记号',
	id : 'Regno',
	anchor:'100%',
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
	anchor:'100%'
});
var barcode = new Ext.form.TextField({
	fieldLabel : '条码',
	id : 'barcode',
	anchor:'100%',
	listeners:{
		keydown:function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				SearchBT.handler
			}
		}
	}
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
// 查询按钮
var PurBT = new Ext.Toolbar.Button({
	id:'PurBT',
	text : '补采购',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
	Ext.MessageBox.confirm('提示','确定要补录选定的医嘱采购信息?',
					function(btn) {
						if(btn == 'yes'){
	var selr=MasterGrid.getSelected();
	if(Ext.isEmpty(selr)){
		Msg.info("warning","请选择要补录的物资!!");
		return;}
	var oeori=selr.get("Oeori")
	var params=oeori+"^"+gUserId
	Ext.Ajax.request({
	url:actionUrl+'?actiontype=Pur',
	params: {params:params},
	failure:function(){Msg.info('error','请检查网络!');return;
	},
	success:function(result,request){
		var jsonData = Ext.util.JSON.decode(result.responseText);
		if (jsonData.success == 'true') {
			Msg.info('success','补录成功！');
		}else{
			Msg.info("error", "补录失败!");
			return;
		}	
		
	}})
	}
	
});
	
	}
});
function clearData() {
	clearPanel(HisListTab);
	HisListTab.getForm().setValues({StartDate:new Date(),EndDate:new Date()});
	MasterGrid.removeAll();
	ItmGridDs.removeAll();
	DetailGrid.removeAll();
}

var SaveBT = new Ext.ux.Button({
	id:'SaveBT',
	text : '保存',
	iconCls : 'page_save',
	handler : function() {
		if(DetailGrid.activeEditor != null){
			DetailGrid.activeEditor.completeEdit();
		}
		if(CheckDataBeforeSave()==true){
			Save();
		}
	}
});
function CheckDataBeforeSave() {
		
		// 1.判断入库物资是否为空
		var rowCount = DetailGrid.getStore().getCount();
		// 有效行数
		if (rowCount <= 0) {
			Msg.info("warning", "请检查明细!");
			return false;
		}
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailGrid.getStore().getAt(i);
			var BatchNo = rowData.get('batno');
				if (BatchNo=="") {
					Msg.info("warning", "批号不可为空!");
					return false;
				}
		}
		
		return true;
	}
	
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
	var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
	Ext.Ajax.request({
		url : actionUrl + '?actiontype=Save',
		params : {MainInfo : MainInfo, ListDetail : ListDetail},
		method : 'POST',
		waitMsg : '处理中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				Msg.info('success', '保存成功!');
				MasterGrid.reload();
			}else if(jsonData.info == -10){
				Msg.info('error', '自带条码重复!');
			}else{
				var Ret=jsonData.info;
				Msg.info('error', '保存失败:'+Ret);
			}
		},
		scope : this
	});
}

var HisListTab = new Ext.form.FormPanel({
	region: 'north',
	height : 170,
	labelAlign : 'right',
	labelWidth : 80,
	frame : true,
	title:'打包收费绑定',
	bodyStyle : 'padding:5px 0px 0px 0px;',
	tbar : [SearchBT, '-', ClearBT],
	items:[{
		xtype:'fieldset',
		title:'查询条件',
		layout: 'column',
		style:'padding:5px 0px 0px 0px;',
		defaults: {xtype: 'fieldset', border:false},
		items : [
			{
				columnWidth: 0.25,
				items: [barcode]
			},{
				columnWidth: 0.25,
				items: [StartDate, EndDate]
			},{
				columnWidth: 0.25,
				labelWidth : 100,
				items: [RecLoc, ARCItemCat]
			},{
				columnWidth: 0.25,
				items: [RegnoDetail, Regno]
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
	}, {
		header : '医嘱时间',
		dataIndex : 'OeoriDate',
		width : 80
	}, {
		header : '医嘱录入人',
		dataIndex : 'UserAddName',
		width : 100
	}, {
		header : '条码',
		dataIndex : 'BarCode',
		width : 120
	}, {
		header : 'Inci',
		dataIndex : 'Inci',
		hidden : true,
		width : 120
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
	actionUrl : actionUrl,
	queryAction : 'QueryOeori',
	paramsFn : GetMasterParams,
	idProperty : 'Oeori',
	showTBar : false
});

function rowSelFn(sm, rowIndex, r) {
	var rowData = sm.grid.getAt(rowIndex);
	var Oeori = rowData.get('Oeori');
	var inci = r.get("Inci");
	ItmGridDs.setBaseParam("Pack",inci)
	ItmGridDs.load()
	var StrParam = Oeori;
	DetailGrid.load({params:{StrParam:StrParam}});
}
	
function GetMasterParams(){
	var RecLoc = Ext.getCmp('RecLoc').getValue();
	var StartDate = Ext.getCmp('StartDate').getValue();
	var EndDate = Ext.getCmp('EndDate').getValue();
	if(RecLoc==''){
		//Msg.info('warning', '请选择医嘱接收科室!');
		//return false;
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
	var barcode=Ext.getCmp('barcode').getValue();
	var PaAdmNo = Ext.getCmp('Regno').getValue();
	var ARCItemCat = Ext.getCmp('ARCItemCat').getValue();
	var PackFlag = 'Y';
	var StrParam = StartDate+'^'+EndDate+'^'+PaAdmNo+'^'+RecLoc+'^'+ARCItemCat
			+'^'+barcode+'^^'+PackFlag;
	
	return {'Sort' : '', 'Dir' : '','StrParam' : StrParam};
}

var DetailCm = [
	{
        header:"orirowid",
        dataIndex:'orirowid',
        width:90,
        saveColIndex:0,
        align:'left',
        sortable:true,
        hidden:true
    },{
        header:"oeori",
        dataIndex:'oeori',
        width:90,
        align:'left',
        sortable:true,
        hidden:true
    },{
        header:"inci",
        dataIndex:'inci',
        saveColIndex:1,
        width:90,
        align:'left',
         hidden:true,
        sortable:true
    },{
        header:"物资代码",
        dataIndex:'code',
        width:90,
        align:'left',
        sortable:true
    },{
        header:"物资名称",
        dataIndex:'desc',
        width:140,
        align:'left',
        sortable:true
	},{
        header:"单位",
        dataIndex:'uomdesc',
        width:40,
        align:'left'
    },{
        header:"数量",
        dataIndex:'qty',
        saveColIndex:2,
        width:50,
        align:'right',
        sortable:true,
        editor: new Ext.form.TextField({
            allowBlank:false,
            selectOnFocus:true
        })
    },{
        header:"批号",
        dataIndex:'batno',
        saveColIndex:3,
        width:80,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
			id:'batnoField',
            allowBlank:false,
            selectOnFocus:true
        })
   },{
        header:"有效期",
        dataIndex:'expdate',
        xtype:'datecolumn',
        width:80,
        saveColIndex:4,
        align:'left',
        sortable:true,
    //    renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor: new Ext.ux.DateField({
			id:'expdateField'
        })
   },{
        header:"自带条码",
        dataIndex:'originalcode',
        saveColIndex:6,
        width:100,
        align:'left',
        sortable:true,
        editor: new Ext.form.TextField({
            allowBlank:false,
            selectOnFocus:true
        })
   },{
        header:"具体规格",
        dataIndex:'specdesc',
        width:80,
        saveColIndex:5,
        align:'right',
        sortable:true,
        editor : new Ext.grid.GridEditor(Specom),
        renderer : Ext.util.Format.comboRenderer2(Specom,"specdesc","specdesc")
	},{
        header:"条码id",
        dataIndex:'dhcit',
        width:60,
        align:'left',
        sortable:true,
        hidden:true
	},{
        header:"高值条码",
        dataIndex:'barcode',
        width:120,
        align:'left',
        sortable:true
	},{
        header:"补录标记",
        dataIndex:'IngrFlag',
        width:60,
        xtype : 'checkcolumn',
        isPlugin : false,
        align:'center',
        sortable:true
	},{
        header:"进价",
        dataIndex:'rp',
        width:80,
        align:'right',
        sortable:true,
        editable : false,		//2015-06-16 不允许修改进价,批号,效期
        editor: new Ext.form.TextField({
			id:'rpField',
            allowBlank:false,
            selectOnFocus:true,
            tabIndex:1
        })
	},{
        header:"售价",
        dataIndex:'sp',
        width:80,
        align:'right',
        sortable:true
	},{
        header:"<font color=blue>发票金额</font>",
        dataIndex:'invamt',
        width:80,
        align:'right',
        sortable:true
    },{
        header:"<font color=blue>发票号</font>",
        dataIndex:'invno',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"<font color=blue>发票日期</font>",
        dataIndex:'invdate',
        width:80,
        align:'left',
        sortable:true,
        renderer:Ext.util.Format.dateRenderer(DateFormat)
	},{
        header:"费用状态",
        dataIndex:'feestatus',
        width:40,
        align:'left',
        sortable:true
	},{
        header:"费用总额",
        dataIndex:'feeamt',
        width:80,
        align:'right',
        sortable:true
	},{
        header:"生成日期",
        dataIndex:'dateofmanu',
        width:80,
        align:'left',
        sortable:true
	},{
        header:"供应商",
        dataIndex:'vendor',
        width:200,
        align:'left',
        sortable:true
	},{
        header:"厂商",
        dataIndex:'manf',
        width:80,
        align:'left',
        sortable:true
	}
];

var DeleteButton = new Ext.ux.Button({
	id : 'DeleteButton',
	text : '删除一条',
	iconCls : 'page_delete',
	handler : function(){
		var selectcell=DetailGrid.getSelectedCell()
		if (Ext.isEmpty(selectcell)){Msg.info('warning', '请选择需要删除的明细!');return false;}
		var SelRecord = DetailGrid.getAt(selectcell[0]);
		if(SelRecord == null){
			Msg.info('warning', '请选择需要删除的明细!');
			return false;
		}
		var RowId = SelRecord.get(DetailGrid.idProperty);
		var IngrFlag=SelRecord.get("IngrFlag")
		if(IngrFlag=="Y"){
			Msg.info('warning', '已经生成入库单,不可以删除!');
			return false;}
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
	smType : 'cell',
	contentColumns : DetailCm,
	actionUrl : actionUrl,
	queryAction : 'QueryItem',
	selectFirst : false,
	idProperty : 'orirowid',
	checkProperty : 'inci',
	paging : false,
	showTBar : false,
	tbar : [ SaveBT,'-', DeleteButton],
	listeners : {
		beforeedit : function(e){
			if(e.field == 'originalcode' || e.field == 'qty'){
				if(!Ext.isEmpty(e.record.get('orirowid'))){
					e.cancel = true;
				}
			}else if(e.field == 'batno' || e.field == 'expdate' || e.field =='specdesc'){
				if(e.record.get('IngrFlag') == 'Y'){
					e.cancel = true;
				}
			}
		}
	}
});

var ItmGridDs = new Ext.data.JsonStore({
	url :'dhcstm.packchargelinkaction.csp?actiontype=GetDetail',
	totalProperty : "results",
	root : 'rows',
	fields : ["PCL","Inci","InciCode","InciDesc","Spec","PbRp"]
});

var ItmLinkGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
		header : 'PCL',
		dataIndex : 'PCL',
		hidden : true
	},{
		header : 'Inci',
		dataIndex : 'Inci',
		hidden : true
	},{
		header : '物资代码',
		dataIndex : 'InciCode',
		width : 100
	},{
		header : '物资名称',
		dataIndex : 'InciDesc',
		width : 200
	},{
		header : '规格',
		dataIndex : 'Spec',
		width : 100
	},{
		header : '进价',
		dataIndex : 'PbRp',
		width : 100
	}
]);

var ItmLinkGrid = new Ext.ux.GridPanel({
	region: 'east',
	width:300,
	title: '关联物资',
	id : 'ItmLinkGrid',
	store : ItmGridDs,
	cm : ItmLinkGridCm,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	listeners : {
		'rowdblclick' : function(grid,rowIndex,e){
			var r = grid.store.getAt(rowIndex);
			var inci= r.get("Inci");
			var incicode=r.get("InciCode")
        	var inciDesc=r.get("InciDesc");
        	var defaData = {inci:inci,desc:inciDesc,qty:1,code:incicode};
			var NewRecord = CreateRecordInstance(DetailGrid.getStore().fields,defaData);
			DetailGrid.getStore().insert(0,NewRecord);	
			DetailGrid.getView().refresh()
		}
	}
}
);
Ext.onReady(function() {
	Ext.QuickTips.init();
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [{
						region: 'center',
						layout : 'border',
						items : [HisListTab, MasterGrid]
					}, DetailGrid, ItmLinkGrid
				]
			
			});
});