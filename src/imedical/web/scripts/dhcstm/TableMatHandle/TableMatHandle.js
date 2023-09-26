// 名称:低值跟台补录处理
// 编写日期:2016-12-07
// 编写着:wangjiabin
var gUserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gLocId=session['LOGON.CTLOCID'];
var gIncId = '';
var CURRENT_INGR = '', CURRENT_INIT = '';		//本次补录入库单rowidStr, 出库单rowidStr
var TableMatUrl = 'dhcstm.tablemathandleaction.csp';

var StkGrpType=new Ext.ux.StkGrpComboBox({
	id : 'StkGrpType',
	name : 'StkGrpType',
	StkType:App_StkTypeCode,	 //标识类组类型
	LocId:gLocId,
	UserId:gUserId,
	anchor:'90%'
});

var Vendor = new Ext.ux.VendorComboBox({
	id : 'Vendor',
	anchor:'90%',
	params : {ScgId : 'StkGrpType'},
	valueParams : {LocId : gLocId, UserId : gUserId}
});

var InciDesc = new Ext.form.TextField({
	fieldLabel : '物资名称',
	id : 'InciDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var stktype = Ext.getCmp("StkGrpType").getValue();
				GetPhaOrderInfo(field.getValue(), stktype);
			}
		}
	}
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
	gIncId = record.get("InciDr");
	var InciCode=record.get("InciCode");
	var InciDesc=record.get("InciDesc");
	Ext.getCmp("InciDesc").setValue(InciDesc);

	findhaveMatord.handler();
}

var reclocField = new Ext.ux.LocComboBox({
	id:'reclocField',
	fieldLabel:'入库科室',
	name:'reclocField',
	groupId:gGroupId,
	anchor:'90%'
});

var ordlocField = new Ext.ux.LocComboBox({
	id:'ordlocField',
	fieldLabel:'医嘱接收科室',
	anchor:'90%',
	defaultLoc:{},
	listeners : {
		select : function(combo, record, index){
			var OrdLocId = record.get(combo.valueField);
			var OrdLocDesc = record.get(combo.displayField);
			var MainLocInfo = tkMakeServerCall('web.DHCSTM.Common.UtilCommon', 'GetMainLocInfo', OrdLocId);
			if(MainLocInfo == '' || MainLocInfo.split('^')[0] == ''){
				MainLocId = OrdLocId;
				MainLocDesc = OrdLocDesc;
			}else{
				MainLocId = MainLocInfo.split('^')[0];
				MainLocDesc = MainLocInfo.split('^')[1];
			}
			addComboData(null, MainLocId, MainLocDesc, Ext.getCmp('RequestedLoc'));
			Ext.getCmp('RequestedLoc').setValue(MainLocId);
		}
	}
});

var RequestedLoc = new Ext.ux.LocComboBox({
	id:'RequestedLoc',
	fieldLabel:'补录接收科室',
	emptyText:'补录接收科室...',
	anchor:'90%',
	defaultLoc:{},
	disabled:true
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	listWidth:100,
	allowBlank:false,
	fieldLabel:'医嘱开始日期',
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	listWidth:100,
	allowBlank:false,
	fieldLabel:'医嘱结束日期',
	value:new Date()
});

var IngrFlag = new Ext.form.RadioGroup({
	id:'IngrFlag',
	columns:3,
	hideLabel : true,
	itemCls: 'x-check-group-alt',
	items:[
		{boxLabel:'全部',name:'IngrFlag',id:'AllFlag',inputValue:0},
		{boxLabel:'未补录',name:'IngrFlag',id:'NoIngrFlag',inputValue:1,checked:true},
		{boxLabel:'已补录',name:'IngrFlag',id:'IngredFlag',inputValue:2}
	]
});
// 金额总合计
var totalrp = new Ext.form.TextField({
	fieldLabel : '金额合计',
	id : 'totalrp',
	name : 'totalrp',
	anchor : '90%',
	readOnly : true
});
// 金额总合计
var invno = new Ext.form.TextField({
	fieldLabel : '发票号',
	id : 'invno',
	name : 'invno',
	anchor : '90%' ,
			listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					websys_setfocus("invdate")
				}
			}
		}
});
var invdate = new Ext.ux.DateField({
	fieldLabel : '发票日期',
	id : 'invdate',
	name : 'invdate',
	anchor : '90%'
});

var findhaveMatord = new Ext.Toolbar.Button({
	text:'查询医嘱信息',
	tooltip:'查询医嘱信息',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var LocId = Ext.getCmp('reclocField').getValue();
		if(LocId == ''){
			Msg.info('warning', '请选择科室!');
			return false;
		}
		var ordlocField = Ext.getCmp('ordlocField').getValue();
		/*if(Ext.isEmpty(ordlocField)){
			Msg.info('warning', '请选择医嘱接收科室!');
			return false;
		}*/
		var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","请选择起始日期!");
			return false;
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","请选择截止日期!");
			return false;
		}
		var Vendor = Ext.getCmp('Vendor').getValue();
		var StkGrpType = Ext.getCmp('StkGrpType').getValue();
		var InciDesc = Ext.getCmp('InciDesc').getValue();
		if(InciDesc == ''){
			gIncId = '';
		}
		var IngrFlag = Ext.getCmp('IngrFlag').getValue().getGroupValue();
		var strPar = startDate+"^"+endDate+"^"+Vendor+"^"+StkGrpType+"^"+gIncId
			+"^"+LocId+"^"+IngrFlag+"^"+ordlocField;
		var ActiveTab=tabPanel.getActiveTab().getId();
		if (ActiveTab=="HVMatPanel"){
		MatordGridDs.setBaseParam('strPar',strPar);
		MatordGridDs.removeAll();
		MatordGridDs.load({
			params:{start:0,limit:9999},
			callback:function(r,options,success){
				if(success==false){
					Msg.info("error","查询有误, 请查看日志!");
				}
			}
		});
		}else if (ActiveTab=="MatordSumPanel"){
			MatordSumGridDs.setBaseParam('strPar',strPar);
			MatordSumGridDs.removeAll();
			MatordSumGridDs.load({
				params:{start:0,limit:9999},
				callback:function(r,options,success){
					if(success==false){
						Msg.info("error","查询有误, 请查看日志!");
					}
				}
			});
		}
	}
});

var clearMatord = new Ext.Toolbar.Button({
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		CURRENT_INGR = '';
		CURRENT_INIT = '';
		GrMasterInfoGrid.getStore().removeAll();
		GrDetailInfoGrid.getStore().removeAll();
		MatordGridDs.removeAll();
		clearPanel(formPanel);
		startDateField.setValue(new Date());
		endDateField.setValue(new Date());
		Ext.getCmp('NoIngrFlag').setValue(true)
	}
});

var createMatord = new Ext.Toolbar.Button({
	text:'生成入库单',
	tooltip:'生成入库单',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
			var LocId = Ext.getCmp("reclocField").getValue();
			if(LocId == ''){
				Msg.info('warnging', '入库科室不可为空!');
			}
			var RequestedLoc = Ext.getCmp('RequestedLoc').getValue();
			var RequestedLocDesc = Ext.getCmp('RequestedLoc').getRawValue();
			/*if(Ext.isEmpty(RequestedLoc)){
				Msg.info('warning', '出库接收科室为空!');
				return false;
			}else if(confirm('出库接收科室为 ' + RequestedLocDesc + ', 是否继续?') == false){
				return false;
			}*/
			var SourceOfFund = '';
			var MainInfo = LocId+"^"+SourceOfFund+"^"+RequestedLoc;
			
			var ListDetail="";
			var sm = MatordGrid.getSelectionModel();
			var rowCount = MatordGrid.getStore().getCount();
			for (var i = 0; i < rowCount; i++) {
				if(sm.isSelected(i)){
					var rowData = MatordGrid.getStore().getAt(i);
					var IngrFlag = rowData.get('ingrFlag');
					if (IngrFlag=="Y"){
						Msg.info("warning", "第"+(i+1)+"行已生成入库单!");
						sm.deselectRow(i);
						return;
					}
					var InvNo = rowData.get("invno");
					if(InvNo==''){
						//Msg.info('error', '第'+(i+1)+'行没有录入发票号!');
						//return false;
					}
					var InvDate = Ext.util.Format.date(rowData.get("invdate"),ARG_DATEFORMAT);
					var InvAmt = rowData.get("invamt");
					var intr = rowData.get('intr');
					var str = intr + '^' + InvNo + '^' + InvDate  + '^' + InvAmt;
					if(ListDetail==""){
						ListDetail=str;
					}else{
						ListDetail=ListDetail+RowDelim+str;
					}
				}
			}

			if (ListDetail==""){
				Msg.info("error", "没有需要生成入库单的信息!");
				return;
			}
			var url = TableMatUrl + "?actiontype=Create";
			var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{MainInfo:MainInfo, ListDetail:ListDetail, user:gUserId},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							loadMask.hide();
							if (jsonData.success == 'true') {
								// 刷新界面
								Msg.info("success", "保存成功!");
								findhaveMatord.handler();
								var CurrentInfo = jsonData.info;
								var CurrentInfoArr = CurrentInfo.split(xRowDelim());
								CURRENT_INGR = CurrentInfoArr[0];
								CURRENT_INIT = CurrentInfoArr[1];
								if(CURRENT_INGR != ''){
									tabPanel.activate('CurrentIngrPanel');
								}
							} else {
								var ret=jsonData.info;
								loadMask.hide();
								if(ret==-99){
									Msg.info("error", "加锁失败,不能保存!");
								}else {
									Msg.info("error", "保存失败："+ret);
								}
							}
						},
						scope : this
					});
	}
});

var PrintIngrButton = new Ext.Toolbar.Button({
	text:'打印入库单',
	iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(){
		var rowData = GrMasterInfoGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", "请选择需要打印的入库单!");
			return;
		}
		var DhcIngr = rowData.get("IngrId");
		PrintRec(DhcIngr);
	}
});

var PrintInitButton = new Ext.Toolbar.Button({
	text:'打印出库单',
	iconCls:'page_print',
	width : 70,
	height : 30,
	handler:function(){
		var rowData = InitMasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", "请选择需要打印的出库单!");
			return;
		}
		var init = rowData.get("init");
		PrintInIsTrf(init);
	}
});
var CancelNorMatord = new Ext.Toolbar.Button({
		text: '撤销补录',
		tooltip: '撤销补录',
		iconCls: 'page_gear',
		width: 70,
		height: 30,
		handler: function () {
			var ParamInfo = tkMakeServerCall("web.DHCSTM.HVMatOrdItm", "GetParamProp", gGroupId, gLocId, gUserId);
			var paramarr = ParamInfo.split("^");
			var IfCanDoCancelOeRec = paramarr[1];
			if (IfCanDoCancelOeRec != "Y") {
				Msg.info("warning", "您没有权限撤销补录!");
				return false;
			}
			CancelNorMatRec();
		}
	});
function CancelNorMatRec() {
	var CancelListDetail = "";
	var Cancelsm = MatordGrid.getSelectionModel();
	var Matordstore = MatordGrid.getStore();
	var rowCount = MatordGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++) {
		if (Cancelsm.isSelected(i)) {
			var rowData = MatordGridDs.getAt(i);
			var IngrFlag = rowData.get('ingrFlag');
			if (IngrFlag != "Y") {
				Msg.info("warning", "未生成入库单不可以撤销补录!");
				Cancelsm.deselectRow(i);
				return;
			}
			var intr = rowData.get('intr');
			if (CancelListDetail == "") {
				CancelListDetail = intr;
			} else {
				CancelListDetail = CancelListDetail + "^" + intr;
			}
		}
	}
	if (CancelListDetail == "") {
		Msg.info("error", "没有需要撤销补录的信息!");
		return false;
	};
	alert(CancelListDetail)
	var url = TableMatUrl+"?actiontype=CancelNorMatRecStr";
	var loadMask = ShowLoadMask(Ext.getBody(), "处理中...");
	Ext.Ajax.request({
		url: url,
		method: 'POST',
		params: {
			IntrStr: CancelListDetail,
			user: gUserId
		},
		waitMsg: '处理中...',
		success: function (result, request) {
			var jsonData = Ext.util.JSON
				.decode(result.responseText);
			loadMask.hide();
			if (jsonData.success == 'true') {
				// 刷新界面
				CURRENT_INGR = "";
				CURRENT_INIT = "";
				var retinfoarr=jsonData.info.split("^");
				var allcount=retinfoarr[0];
				var succount=retinfoarr[1];
				Msg.info("success", "共"+allcount+"条记录,成功撤销"+succount+"条记录!");
				findhaveMatord.handler();
			}
		},
		scope: this
	});
}
var formPanel = new Ext.form.FormPanel({
	title : '低值材料入库补录',
	labelAlign : 'right',
	region:'north',
	autoHeight : true,
	frame : true,
	tbar:[findhaveMatord,'-',createMatord,'-',clearMatord,'-',PrintIngrButton,'-',PrintInitButton,'-',CancelNorMatord],
	items : [{
		xtype : 'fieldset',
		title : '条件选项',
		layout : 'column',
		defaults : {layout : 'form', labelWidth : 60},
		items : [{
			columnWidth : .3,
			labelWidth : 100,
			items : [reclocField, RequestedLoc, ordlocField]
		}, {
			columnWidth : .2,
			labelWidth : 100,
			items : [startDateField, endDateField]
		}, {
			columnWidth : .25,
			items : [StkGrpType, InciDesc]
		}, {
			columnWidth : .25,
			items : [Vendor,IngrFlag]
		}]
	}]
});

var sm=new Ext.grid.CheckboxSelectionModel({
	checkOnly:true,
	listeners : {
		rowselect : function(sm, rowIndex) {
			var selectedRow = MatordGridDs.data.items[rowIndex];
			var IngrFlag = selectedRow.data["ingrFlag"];
			/*if (IngrFlag=="Y"){
				Msg.info("warning", "已生成入库单!");
				sm.deselectRow(rowIndex);
				return
			}
			else
				{
				var selarr=this.getSelections();
				var len=selarr.length
				if (len>1){
							var invno=selarr[len-2].data["invno"];
							var invnodate=selarr[len-2].data["invdate"];
							selectedRow.set("invno",invno);
							selectedRow.set("invdate",invnodate);
							}
			}*/
			var selarr=this.getSelections();
			var len=selarr.length
			if (len>1){
				var invno=selarr[len-2].data["invno"];
				var invnodate=selarr[len-2].data["invdate"];
				selectedRow.set("invno",invno);
				selectedRow.set("invdate",invnodate);
					}
		getTotalrp()
		},
	rowdeselect:function(sm,rowIndex,record) {
		record.set("invno","");
		record.set("invdate","");
		getTotalrp()
	}
	}
});


var MatordGridDs = new Ext.data.JsonStore({
	url : TableMatUrl+'?actiontype=query',
	root : 'rows',
	totalProperty : 'results',
	id : 'orirowid',
	fields : ['intr', 'vendordr', 'vendor', 'inci', 'code', 'desc', 'spec', 'specdesc', 'inclb', 'batno',
		{name:'expdate',type:'date',dateFormat:DateFormat}, 'uomdr', 'uomdesc', 'qty', 'rp', 'rpAmt', 'sp', 'spAmt', 'oeori', 'doctor',
			'pano', 'paname', 'ingrFlag', 'invno', {name:'invdate',type:'date',dateFormat:DateFormat}, 'invamt'
	],
	pruneModifiedRecords : true
});

var MatordGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 sm,{
		header:"intr",
		dataIndex:'intr',
		width:90,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"供应商",
		dataIndex:'vendor',
		width:200,
		align:'left',
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
		header:"规格",
		dataIndex:'spec',
		width:80,
		align:'left'
	},{
		header:"具体规格",
		dataIndex:'specdesc',
		width:80,
		align:'left'
	},{
		header:"补录标记",
		dataIndex:'ingrFlag',
		width:60,
		xtype : 'checkcolumn',
		isPlugin : false,
		align:'center'
	},{
		header:"inclb",
		dataIndex:'inclb',
		hidden : true
	},{
		header:"单位",
		dataIndex:'uomdesc',
		width:40,
		align:'left'
	},{
		header:"数量",
		dataIndex:'qty',
		width:50,
		align:'right'
	},{
		header:"批号",
		dataIndex:'batno',
		width:100,
		align:'left',
		editable : false,		//2015-06-16 不允许修改进价,批号,效期
		editor: new Ext.form.TextField({
			id:'batnoField',
			allowBlank:false,
			selectOnFocus:true
		})
	},{
		header:"有效期",
		dataIndex:'expdate',
		width:100,
		align:'left',
		renderer:Ext.util.Format.dateRenderer(DateFormat),
		editable : false,		//2015-06-16 不允许修改进价,批号,效期
		editor: new Ext.ux.DateField()
	},{
		header:"进价",
		dataIndex:'rp',
		width:80,
		align:'right',
		editable : false,		//2015-06-16 不允许修改进价,批号,效期
		editor: new Ext.form.TextField({
			allowBlank:false,
			selectOnFocus:true,
			tabIndex:1
		})
	},{
		header:"售价",
		dataIndex:'sp',
		width:80,
		align:'right'
	},{
		header:"<font color=blue>发票金额</font>",
		dataIndex:'invamt',
		width:80,
		align:'right',
		editor: new Ext.form.NumberField({
			allowBlank:false,
			selectOnFocus:true
		})
	},{
		header:"<font color=blue>发票号</font>",
		dataIndex:'invno',
		width:100,
		align:'left',
		editor: new Ext.form.TextField({
			id:'invnoField',
			allowBlank:false,
			selectOnFocus:true
		})
	},{
		header:"<font color=blue>发票日期</font>",
		dataIndex:'invdate',
		width:80,
		align:'left',
		renderer:Ext.util.Format.dateRenderer(DateFormat),
		editor: new Ext.ux.DateField()
	},{
		header:"患者登记号",
		dataIndex:'pano',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"患者姓名",
		dataIndex:'paname',
		width:80,
		align:'left'
	},{
		header:"医生",
		dataIndex:'doctor',
		width:60,
		align:'left'
	}
]);
function getTotalrp(){
	var selarr = MatordGrid.getSelectionModel().getSelections();
	var totalrp=0
	for (var i = 0; i < selarr.length; i++) {
		var rowData = selarr[i];
		var Rp = rowData.get("rp");
		totalrp=accAdd(totalrp,Rp)
	}
	Ext.getCmp("totalrp").setValue(totalrp);
}
var InvNoBT = new Ext.Toolbar.Button({
			text : '填写发票号和发票日期',
			tooltip : '点击填写发票号',
			height:30,
			width:70,
			iconCls : 'page_refresh',
			handler : function() {
				InvNoInput();
			}
		});

function InvNoInput() {
	var rs = sm.getSelections();
	var count=rs.length;
	if(count>0){
		var invno=Ext.getCmp('invno').getValue();
		var InvDate =Ext.getCmp('invdate').getValue();
		for (var i = 0; i < count; i++) {
			var rowData = rs[i];
			rowData.set('invno',invno);
			rowData.set('invdate',InvDate);
		}
		Msg.info('warning', '发票信息已录入表格,请保存!');
	}else{
		Msg.info('error', '请选择需要录入发票的记录!');
	}
}

var MatordGrid = new Ext.ux.EditorGridPanel({
	id : 'MatordGrid',
	store:MatordGridDs,
	tbar:['发票号:','-',invno,'-','发票日期:',invdate,'-',InvNoBT,'->','金额合计:','-',totalrp],
	cm:MatordGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : sm,
	loadMask:true,
	clicksToEdit:1,
	listeners:{
		beforeedit : function(e){
			var IngrFlag = e.record.get('ingrFlag');
			if(IngrFlag=="Y"){
				return false ;
			}
		},
		afteredit:function(e){
			if(e.field=='invno'){
				var invnoFlag=InvNoValidator(e.value,"");
				if(!invnoFlag){
					Msg.info("warning","发票号'"+e.value+"'已存在于其他入库单中!");
					//e.record.set('invno',e.originalValue);
				}
			}
		}
	}
});

var MatordSumGridDs = new Ext.data.JsonStore({
	url : TableMatUrl+'?actiontype=QuerySum',
	root : 'rows',
	totalProperty : 'results',
	id : 'orirowid',
	fields : ['vendordr', 'vendor', 'inci', 'code', 'desc', 'spec','uomdr', 'uomdesc', 'qty','rpAmt','spAmt'
	]
});
var smsum=new Ext.grid.RowSelectionModel({
							singleSelect : true
						})
var MatordSumGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header:"供应商",
		dataIndex:'vendor',
		width:200,
		align:'left',
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
		header:"规格",
		dataIndex:'spec',
		width:80,
		align:'left'
	},{
		header:"单位",
		dataIndex:'uomdesc',
		width:40,
		align:'left'
	},{
		header:"数量",
		dataIndex:'qty',
		width:50,
		align:'right'
	},{
		header:"进价金额",
		dataIndex:'rpAmt',
		width:50,
		align:'right'
	},{
		header:"售价金额",
		dataIndex:'spAmt',
		width:50,
		align:'right'
	}
]);
var MatordSumGrid = new Ext.ux.EditorGridPanel({
	id : 'MatordSumGrid',
	store:MatordSumGridDs,
	cm:MatordSumGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : smsum,
	loadMask:true,
	clicksToEdit:1
});
//>>>>>>>>>>入库单回显部分>>>>>>>>>>
var GrMasterInfoStore = new Ext.data.JsonStore({
	url : DictUrl	+ 'ingdrecaction.csp?actiontype=QueryIngrStr',
	totalProperty : "results",
	root : 'rows',
	fields : ["IngrId","IngrNo", "Vendor", "RecLoc", "IngrType", "PurchUser",
		"PoNo", "CreateUser", "CreateDate", "Complete", "ReqLoc",
		"StkGrp","RpAmt","SpAmt","AcceptUser","InvAmt"],
	listeners : {
		load : function(store, records, option){
			if(records.length > 0){
				GrMasterInfoGrid.getSelectionModel().selectFirstRow();
				GrMasterInfoGrid.getView().focusRow(0);
			}
		}
	}
});

var GrMasterInfoCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "RowId",
		dataIndex : 'IngrId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true,
		hideable : false
	}, {
		header : "入库单号",
		dataIndex : 'IngrNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : '入库部门',
		dataIndex : 'RecLoc',
		width : 120,
		align : 'left',
		sortable : true
	},  {
		header : "供应商",
		dataIndex : 'Vendor',
		width : 200,
		align : 'left',
		sortable : true
	}, {
		dataIndex : "StkGrp",
		hidden : true,
		hideable : false
	}, {
		header : '采购员',
		dataIndex : 'PurchUser',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : "完成标志",
		dataIndex : 'Complete',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : "发票金额",
		dataIndex : 'InvAmt',
		width : 80,
		xtype:'numbercolumn',
		align : 'right'
	}, {
		header : "进价金额",
		dataIndex : 'RpAmt',
		width : 80,
		xtype:'numbercolumn',
		align : 'right'
	}, {
		header : "售价金额",
		dataIndex : 'SpAmt',
		xtype : 'numbercolumn',
		width : 80,
		align : 'right'
	}, {
		header : "备注",
		dataIndex : 'InGrRemarks',
		width : 160,
		align : 'left'
	}
]);

var GridPagingToolbar = new Ext.PagingToolbar({
	store:GrMasterInfoStore,
	pageSize:PageSize,
	displayInfo:true
});
var GrMasterInfoGrid = new Ext.grid.GridPanel({
	id : 'GrMasterInfoGrid',
	title : '',
	cm : GrMasterInfoCm,
	sm : new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var InGr = r.get("IngrId");
				GrDetailInfoStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',Parref:InGr}});
			}
		}
	}),
	store : GrMasterInfoStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	bbar:[GridPagingToolbar]
});

var GrDetailInfoStore = new Ext.data.JsonStore({
	url : DictUrl + 'ingdrecaction.csp?actiontype=QueryDetail',
	totalProperty : "results",
	root : 'rows',
	fields : ["Ingri", "BatchNo", "IngrUom","ExpDate", "Inclb",  "Margin", "RecQty",
		"Remarks", "IncCode", "IncDesc","InvNo", "Manf", "Rp", "RpAmt",
		"Sp", "SpAmt", "InvDate","QualityNo", "SxNo","Remark","MtDesc","PubDesc",
		"CheckPort","CheckRepNo",{name:'CheckRepDate',type:'date',dateFormat:DateFormat},"AdmNo",
		{name:'AdmExpdate',type:'date',dateFormat:DateFormat},"CheckPack","InvMoney"]
});

var GrDetailInfoCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "Ingri",
		dataIndex : 'Ingri',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true,
		hideable : false
	}, {
		header : '物资代码',
		dataIndex : 'IncCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : '物资名称',
		dataIndex : 'IncDesc',
		width : 230,
		align : 'left',
		sortable : true
	}, {
		header : "生产厂商",
		dataIndex : 'Manf',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "批号",
		dataIndex : 'BatchNo',
		width : 90,
		align : 'left',
		sortable : true
	}, {
		header : "有效期",
		dataIndex : 'ExpDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "单位",
		dataIndex : 'IngrUom',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "数量",
		dataIndex : 'RecQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "进价",
		dataIndex : 'Rp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "售价",
		dataIndex : 'Sp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "发票号",
		dataIndex : 'InvNo',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "发票日期",
		dataIndex : 'InvDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "发票金额",
		dataIndex : 'InvMoney',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "进价金额",
		dataIndex : 'RpAmt',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "售价金额",
		dataIndex : 'SpAmt',
		width : 100,
		align : 'left',
		sortable : true
	}
]);

var GrDetailInfoGrid = new Ext.grid.GridPanel({
	id : 'GrDetailInfoGrid',
	title : '',
	height : 170,
	cm : GrDetailInfoCm,
	store : GrDetailInfoStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true
});

var IngrInfoPanel = new Ext.Panel({
	layout : 'border',
	items : [{region:'north',layout:'fit',height:200,items:GrMasterInfoGrid},
			{region:'center',layout:'fit',items:GrDetailInfoGrid}]
});
//<<<<<<<<<<入库单回显部分<<<<<<<<<<

//>>>>>>>>>>出库单回显部分>>>>>>>>>>
var InitMasterStore = new Ext.data.JsonStore({
	url : DictUrl	+ 'dhcinistrfaction.csp?actiontype=QueryTrans',
	totalProperty : "results",
	root : 'rows',
	fields : ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName",
			"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode","confirmFlag"],
	listeners:{
		load:function(store,records,options){
			if(records.length>0){
				InitMasterGrid.getSelectionModel().selectFirstRow();
				InitMasterGrid.getView().focusRow(0);
			}
		}
	}
});

var InitMasterCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "RowId",
		dataIndex : 'init',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "转移单号",
		dataIndex : 'initNo',
		width : 160,
		align : 'left',
		sortable : true
	}, {
		header : "请求部门",
		dataIndex : 'toLocDesc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "供给部门",
		dataIndex : 'frLocDesc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "转移日期",
		dataIndex : 'dd',
		width : 90,
		align : 'center',
		sortable : true
	}, {
		header : "制单人",
		dataIndex : 'userName',
		width : 90,
		align : 'left',
		sortable : true
	}, {
		header : "进价金额",
		dataIndex : 'RpAmt',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "售价金额",
		dataIndex : 'SpAmt',
		width : 80,
		align : 'right',
		sortable : true
	}
]);

var InitMasterPagingToolbar = new Ext.PagingToolbar({
	store:InitMasterStore,
	pageSize:PageSize,
	displayInfo:true
});
var InitMasterGrid = new Ext.grid.GridPanel({
	title : '',
	height : 170,
	cm : InitMasterCm,
	sm : new Ext.grid.RowSelectionModel({
		singleSelect : true,
		listeners : {
			rowselect : function(sm, rowIndex, r){
				var InIt = r.get("init");
				InitDetailStore.setBaseParam('Parref',InIt);
				InitDetailStore.removeAll();
				InitDetailStore.load({params:{start:0,limit:InitDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}})
			}
		}
	}),
	store : InitMasterStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	bbar : InitMasterPagingToolbar
});

var InitDetailStore = new Ext.data.JsonStore({
	url : DictUrl + 'dhcinistrfaction.csp?actiontype=QueryDetail',
	totalProperty : "results",
	root : 'rows',
	fields : ["initi", "inrqi", "inci","inciCode",
		"inciDesc", "inclb", "batexp", "manf","manfName",
		 "qty", "uom", "sp","status","remark",
		"reqQty", "inclbQty", "reqLocStkQty", "stkbin", "pp", "spec","newSp",
		"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc"]
});

var InitDetailCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "转移细项RowId",
		dataIndex : 'initi',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "物资Id",
		dataIndex : 'inci',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : '物资代码',
		dataIndex : 'inciCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : '物资名称',
		dataIndex : 'inciDesc',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "批次Id",
		dataIndex : 'inclb',
		width : 180,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "批次/效期",
		dataIndex : 'batexp',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "生产厂商",
		dataIndex : 'manfName',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "批次库存",
		dataIndex : 'inclbQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "转移数量",
		dataIndex : 'qty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "转移单位",
		dataIndex : 'TrUomDesc',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "进价",
		dataIndex : 'rp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "售价",
		dataIndex : 'sp',
		width : 60,
		align : 'right',
		sortable : true
	}, {
		header : "请求数量",
		dataIndex : 'reqQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "货位码",
		dataIndex : 'stkbin',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "请求方库存",
		dataIndex : 'reqLocStkQty',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "占用数量",
		dataIndex : 'inclbDirtyQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "可用数量",
		dataIndex : 'inclbAvaQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "批次售价",
		dataIndex : 'newSp',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "规格",
		dataIndex : 'spec',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "售价金额",
		dataIndex : 'spAmt',
		width : 100,
		align : 'right',

		sortable : true
	}, {
		header : "进价金额",
		dataIndex : 'rpAmt',
		width : 100,
		align : 'right',
		sortable : true
	}
]);

var InitDetailPagingToolbar = new Ext.PagingToolbar({
	store:InitDetailStore,
	pageSize:PageSize,
	displayInfo:true
});

var InitDetailGrid = new Ext.grid.GridPanel({
	title : '',
	height : 200,
	cm : InitDetailCm,
	store : InitDetailStore,
	trackMouseOver : true,
	stripeRows : true,
	bbar:InitDetailPagingToolbar,
	loadMask : true
});

var InitInfoPanel = new Ext.Panel({
	layout : 'border',
	items : [{region:'north',layout:'fit',height:200,items:InitMasterGrid},
			{region:'center',layout:'fit',items:InitDetailGrid}]
});
//<<<<<<<<<<出库单回显部分<<<<<<<<<<

var tabPanel = new Ext.TabPanel({
	region : 'center',
	activeTab: 0,
	items:[
		{title: '跟台低值医嘱信息',id:'HVMatPanel',layout:'fit',items:MatordGrid},
		{title: '低值医嘱汇总信息',id:'MatordSumPanel',layout:'fit',items:MatordSumGrid},
		{title: '本次补录入库信息',id:'CurrentIngrPanel',layout:'fit',items:IngrInfoPanel},
		{title: '本次补录出库信息',id:'CurrentInitPanel',layout:'fit',items:InitInfoPanel}
	],
	listeners:{
		'tabchange' : function(t,p){
			if (p.getId()=='CurrentIngrPanel'){
				if (CURRENT_INGR!=""){
					GrMasterInfoGrid.getStore().load({params:{IngrStr:CURRENT_INGR}});
				}
			}else if (p.getId()=='CurrentInitPanel'){
				if (CURRENT_INIT!=""){
					InitMasterGrid.getStore().load({params:{InitStr:CURRENT_INIT}});
				}
			}
		}
	}
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel, tabPanel]
	});
});