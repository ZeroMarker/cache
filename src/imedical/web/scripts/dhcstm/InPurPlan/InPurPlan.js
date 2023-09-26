// 名称:采购计划单
// 编写日期:2012-06-19

var purId = planNnmber;
var PlanGridUrl = 'dhcstm.inpurplanaction.csp';
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var Msg_LostModified='数据已录入或修改，你当前的操作将丢失这些结果，是否继续?';

if(gParam.length<1){
	GetParam();
}

function getDrugList2(record) {
	if (record == null || record == "") {
		return false;
	}
	var inciDr = record.get("InciDr");
	var cell = PlanGrid.getSelectionModel().getSelectedCell();
	// 选中行
	var row = cell[0];
//	var findIndex=PlanGrid.store.findExact('IncId',inciDr,0);
//	if(findIndex>=0 && findIndex!=row){
//		Msg.info("warning","物资不可重复录入!");
//		var col=GetColIndex(PlanGrid,"IncDesc");
//		PlanGrid.startEditing(row, col);
//		return;
//	}
	var rowData = PlanGrid.getAt(row);
	
	//取其它物资信息
	var locId = Ext.getCmp('locField').getValue();
	if(locId==""){
		Msg.info("error", "请选择科室!");
		return;
	}
	var Params=session['LOGON.GROUPID']+'^'+locId+'^'+UserId;
	Ext.Ajax.request({
		url : 'dhcstm.inpurplanaction.csp?actiontype=GetItmInfo&lncId='+ inciDr+'&Params='+Params,
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
			if (jsonData.success == 'true') {
				var data=jsonData.info.split("^");
				
				//先判断资质信息, 再进行后续的赋值
				var VenId = data[0];
				var ManfId = data[2];
				var inciDesc = record.get("InciDesc");
				var DataList=VenId+"^"+inciDr+"^"+ManfId;
				var url = 'dhcstm.utilcommon.csp?actiontype=Check&DataList=' + DataList;
				var CheckResult = ExecuteDBSynAccess(url);
				var CheckJsonData = Ext.util.JSON.decode(CheckResult)
				if (CheckJsonData.success == 'true') {
					if(CheckJsonData.info != ""){
						Msg.info("warning", inciDesc + ':' + CheckJsonData.info);
						if(CommParObj.StopItmBussiness == 'Y'){
							return;
						}
					}
				}
				
				rowData.set("IncId",inciDr);
				rowData.set("IncCode",record.get("InciCode"));
				rowData.set("IncDesc",record.get("InciDesc"));
				var VenId = data[0];
				var Vendor = data[1];
				addComboData(Ext.getCmp("Vendor").getStore(),VenId,Vendor);
				rowData.set("VenId", VenId);    //供应商
				var ManfId = data[2];
				var Manf = data[3];
				addComboData(PhManufacturerStore,ManfId,Manf);
				rowData.set("ManfId", ManfId);    //生产商
				var CarrierId = data[4];
				var Carrier = data[5];
				addComboData(CarrierStore,CarrierId,Carrier);
				rowData.set("CarrierId", CarrierId);    //配送商
				var UomId=data[6];
				var Uom=data[7];
				addComboData(ItmUomStore,UomId,Uom);
				rowData.set("UomId", UomId);    //默认为大单位调价
				rowData.set("Rp", data[8]);
				rowData.set("StkQty", data[10]);
				rowData.set("MaxQty", data[11]);
				rowData.set("MinQty", data[12]);
				rowData.set("Spec", data[16]);
				rowData.set("BUomId", data[17]);
				rowData.set("ConFacPur", data[18]);
				
				var col=GetColIndex(PlanGrid,'Qty');
				PlanGrid.startEditing(PlanGrid.getCount() - 1, col);
			}
		},
		scope : this
	});
}

function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, group, App_StkTypeCode, "", "N", "0", HospId,getDrugList2);
	}
}

// 打印采购按钮
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '打印',
	tooltip : '点击打印采购单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		PrintInPur(purId);
	}
});

var dateField = new Ext.ux.DateField({
	id:'dateField',
	allowBlank:false,
	fieldLabel:'日期',
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var planNumField = new Ext.form.TextField({
	id:'planNum',
	fieldLabel:'计划单号',
	allowBlank:true,
	emptyText:'计划单号...',
	disabled:true,
	anchor:'90%',
	selectOnFocus:true
});
		
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'科室',
	anchor:'90%',
	listWidth:210,
	allowBlank:true,
	emptyText:'科室...',
	groupId:gGroupId,
	stkGrpId : 'groupField',
	childCombo : ['Vendor','PHMNFName']
});

// 物资类组
var groupField=new Ext.ux.StkGrpComboBox({
	id : 'groupField',
	name : 'groupField',
	StkType:App_StkTypeCode,     //标识类组类型
	anchor : '90%',
	LocId:CtLocId,
	UserId:UserId
});

var Complete=new Ext.form.Checkbox({
	fieldLabel : '完成',
	id : 'Complete',
	name : 'Complete',
	anchor : '90%',
	width : 150,
	checked : false,
	disabled:true,
	listeners:{
		check : function(checkbox,checked){
			PlanGrid.AddNewRowButton.setDisabled(checked);
			PlanGrid.DelRowButton.setDisabled(checked);			
			savePlan.setDisabled(checked);
			deletePlan.setDisabled(checked);
			finishPlan.setDisabled(checked);
		}
	}
});
var RemarkField = new Ext.form.TextField({
	id:'RemarkField',
	fieldLabel:'备注',
	allowBlank:true,
	width:200,
	listWidth:200,
	emptyText:'备注...',
	anchor:'90%',
	selectOnFocus:true
});
var Uom = new Ext.ux.ComboBox({
	fieldLabel : '单位',
	id : 'Uom',
	name : 'Uom',
	store : ItmUomStore,
	valueField : 'RowId',
	displayField : 'Description',
	listeners:{
		specialKey:function(field, e) {
			if (e.getKey() == Ext.EventObject.ENTER) {
				var cell=PlanGrid.getSelectedCell();
				var col=GetColIndex(PlanGrid,"Qty");
				PlanGrid.startEditing(cell[0], col);
			}
		}
	}
});

Uom.on('beforequery', function(combo) {
	var cell = PlanGrid.getSelectedCell();
	var ItmId = PlanGrid.getCell(cell[0],"IncId");
	ItmUomStore.removeAll();
	ItmUomStore.load({params:{ItmRowid:ItmId}});
});

Uom.on('select', function(combo) {
	var cell = PlanGrid.getSelectionModel().getSelectedCell();
	var rowData = PlanGrid.getStore().getAt(cell[0]);
	var qty = rowData.get('Qty');
	if((qty=="")||(qty==null)){
		qty = 0;
	}

	var seluom=combo.getValue();
	var rp = rowData.get("Rp"); //原进价
	var buom=rowData.get("BUomId");
	var confac=rowData.get("ConFacPur");
	var uom=rowData.get("UomId");
	if(seluom!=uom){
		if(seluom!=buom){     //原单位是基本单位，目前选择的是入库单位
			rowData.set("Rp", Number(rp).mul(confac)); 
			rowData.set("RpAmt", Number(rp).mul(confac).mul(qty)); //购入金额
		}else{					//目前选择的是基本单位，原单位是入库单位
			rowData.set("Rp", Number(rp).div(confac)); 
			rowData.set("RpAmt", Number(rp).div(confac).mul(qty)); //购入金额
		}
	}
	rowData.set("UomId", seluom);
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '供应商...',
	listWidth : 250,
	params : {LocId : 'locField',ScgId : 'groupField'},
	listeners:{
		beforequery : function(){
			var cell = PlanGrid.getSelectedCell();
			if (Ext.isEmpty(cell)) {
				return false;
			}
			var ItmId = PlanGrid.getCell(cell[0],"IncId");
			var ApcInciFilter=(Ext.isEmpty(CommParObj.ApcInciFilter)?"":CommParObj.ApcInciFilter);
			this.store.setBaseParam('Incid', ItmId);
			this.store.setBaseParam('ApcInciFilter', ApcInciFilter);
			this.store.removeAll();
			this.store.load();
		},
		specialkey:function(field,e){
			if (e.getKey() == Ext.EventObject.ENTER) {
				PlanGrid.addNewRow();
			}
		}
	}
});

var Carrier = new Ext.ux.ComboBox({
	fieldLabel : '配送商',
	id : 'Carrier',
	name : 'Carrier',
	store : CarrierStore,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : '配送商...',
	filterName:'CADesc'
});

var SpecDesc = new Ext.form.ComboBox({
	fieldLabel : '具体规格',
	id : 'SpecDesc',
	store : SpecDescStore,
	valueField : 'Description',
	displayField : 'Description',
	emptyText : '具体规格...',
	listWidth : 250,
	pageSize : 20,
	listeners : {
		beforequery : function(){
			var cell = PlanGrid.getSelectedCell();
			if (Ext.isEmpty(cell)) {
				return false;
			}
			var ItmId = PlanGrid.getCell(cell[0],"IncId");
			this.store.setBaseParam('SpecItmRowId', ItmId);
			this.store.setBaseParam('desc', this.getRawValue());
			this.store.removeAll();
			this.store.load({params : {start:0,limit:this.pageSize}});
		}
	}
});

var Manf = new Ext.ux.ComboBox({
	fieldLabel : '厂商',
	id : 'Manf',
	name : 'Manf',
	store : PhManufacturerStore,
	valueField : 'RowId',
	displayField : 'Description',
	emptyText : ' 厂商...',
	filterName:'PHMNFName',
	params : {LocId : 'locField',ScgId : 'groupField'}
});		

var ReqLoc = new Ext.ux.LocComboBox({
	fieldLabel : '申购科室',
	id : 'ReqLoc',
	name : 'ReqLoc',
	defaultLoc:''
});

//模型
var PlanGridCm = [
	{
		header:"RowId",
		dataIndex:'RowId',
		saveColIndex : 0,
		hidden:true,
		hideable:false,
		sortable:true
	}, {
		header:"IncId",
		dataIndex:'IncId',
		saveColIndex : 1,
		hidden:true,
		hideable:false
	}, {
		header:"物资代码",
		dataIndex:'IncCode',
		width:100,
		align:'left',
		renderer :Ext.util.Format.InciPicRenderer('IncId'),
		sortable:true
	},{
		header:"物资名称",
		dataIndex:'IncDesc',
		id:'IncDesc',
		width:250,
		align:'left',
		sortable:true,
		editor:new Ext.form.TextField({
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo2(field.getValue(),Ext.getCmp("groupField").getValue());
					}
				}
			}
		})
	},{
		header:"规格",
		dataIndex:'Spec',
		width:120,
		align:'left'
	},{
		header:"具体规格",
		dataIndex : "SpecDesc",
		xtype:'combocolumn',
		saveColIndex : 9,
		valueField: "SpecDesc",
		displayField: "SpecDesc",
		editor:SpecDesc
	},{
		header:"单位",
		dataIndex : "UomId",
		xtype:'combocolumn',
		saveColIndex : 3,
		valueField: "UomId",
		displayField: "Uom",
		editor:Uom
	}, {
		header : "建议采购量",
		dataIndex : 'ProPurQty',
		width : 80,
		align : 'right',
		sortable : true
	},{
		header:"采购数量",
		dataIndex:'Qty',
		saveColIndex : 2,
		allowBlank : false,
		width:80,
		align:'right',
		sortable:true,
		editor: new Ext.form.NumberField({
			id:'qtyField',
			allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var col=GetColIndex(PlanGrid,"VenId")
						var cell=PlanGrid.getSelectionModel().getSelectedCell();
						PlanGrid.startEditing(cell[0], col);	
					}
				}
			}
		})
	},{
		header:"进价",
		dataIndex:'Rp',
		align : 'right',
		saveColIndex : 5,
		width:80,
		sortable:true,
		editor:new Ext.ux.NumberField({
			formatType : 'FmtRP',
			selectOnFocus : true,
			//allowBlank : false,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cost = field.getValue();
						if ((cost == null || cost=="")&(gParam[0]=="Y")) {
							Msg.info("warning", "进价不能为空!");
							return;
						}
						if (cost < 0) {
							Msg.info("warning", "进价不能小于0!");
							return;
						}
						// 新增一行
						var col=GetColIndex(PlanGrid,"VenId");
						var cell=PlanGrid.getSelectedCell();
						PlanGrid.startEditing(cell[0], col);
					}
				}
			}
		})
	},{
		header:"供应商",
		dataIndex:'VenId',
		saveColIndex : 4,
		width:250,
		xtype:'combocolumn',
		valueField: "VenId",
		displayField: "Vendor",
		editor:Vendor
	},{
		header:"配送商",
		dataIndex:'CarrierId',
		saveColIndex : 7,
		width:200,
		xtype:'combocolumn',
		valueField: "CarrierId",
		displayField: "Carrier",
		editor:Carrier
	},{
		header:"厂商",
		dataIndex : "ManfId",
		saveColIndex : 6,
		width:200,
		xtype:'combocolumn',
		valueField: "ManfId",
		displayField: "Manf",
		editor:Manf
	},{
		header:"申购科室",
		saveColIndex : 8,
		width:150,
		xtype:'combocolumn',
		valueField: "ReqLocId",
		displayField: "ReqLoc",
		editor:ReqLoc
	},{
		header:"库存下限",
		dataIndex:'MinQty',
		width:100,
		align:'right'
	},{
		header:"库存上限",
		dataIndex:'MaxQty',
		width:100,
		align:'right'
	},{
		header:"购入金额",
		dataIndex:'RpAmt',
		width:120,
		align : 'right'
	},{
		header:"本科室数量",
		dataIndex:'LocQty',
		width:100,
		align:'right'
	},{
		header:"本科室可用数量",
		dataIndex:'LocAvaQty',
		width:120,
		align : 'right'
	},{
		header:"请求数量",
		dataIndex:'ReqQty',
		width:120,
		align : 'right'
	},{
		header:"已转移数量",
		dataIndex:'TrfQty',
		width:120,
		align : 'right'
	},{
		header:"基本单位Id",
		dataIndex:'BUomId',
		width:60,
		hidden : true
	},{
		header:"单位转换系数",
		dataIndex:'ConFacPur',
		width:60,
		hidden : true
	}, {
		header : "要求送货日期",
		dataIndex : 'DemandDate',
		xtype: 'datecolumn',
		width : 100,
		align : 'center',
		sortable : true,
		saveColIndex : 10,
		//renderer : Ext.util.Format.dateRenderer(ARG_DATEFORMAT),
		editor : new Ext.ux.DateField({
			selectOnFocus : true,
			allowBlank : true,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var completeFlag=Ext.getCmp('Complete').getValue();
						if (completeFlag != null && completeFlag != false) {
							Msg.info("warning", "单据已完成!");
							return;
						}
					}
				}
			}
		})
	},{
		header:"采购备注",
		dataIndex:'remark',
		id:'remark',
		width:250,
		align:'left',
		saveColIndex : 11,
		sortable:true,
		editor:new Ext.form.TextField({
			allowBlank:false
		})
	}];
	
var findPlan = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		FindPlan(Select);
	}
});

var savePlan = new Ext.ux.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		var mod=Modified();
		if (mod==false){
			Msg.info('warning','没有需要保存的数据!')
			return;
		}
		var purNo = Ext.getCmp('planNum').getValue();
		var locId = Ext.getCmp('locField').getValue();
		var stkGrpId = Ext.getCmp('groupField').getValue();
		var Remark=Ext.getCmp("RemarkField").getValue();
		var userId = UserId;
		if(locId==null || locId==""){
			Msg.info("warning","科室不可为空!");
			return;
		}
		if(stkGrpId==null || stkGrpId==""){
			Msg.info("warning","类组不可为空!");
			return;
		}
		var data = PlanGrid.getModifiedInfo();
		if(data===false){
			return;
			
		}
	
		var Count=PlanGrid.getCount()
		for(i=0;i<Count;i++){
			var rowData=PlanGrid.getAt(i)
			var UomId=rowData.get("UomId");
			var IncId=rowData.get("IncId");
			var VenId=rowData.get("VenId");
			if ((UomId=="")&&(IncId!="")){
				Msg.info("warning","第"+(i+1)+"行单位为空");
				PlanGrid.getSelectionModel().select(i, 1);
				changeBgColor(i, "yellow");
				return false;
			}
			if(IncId!=""&&VenId==""&&gParam[4]!="N"){
				Msg.info('error','第'+(i+1)+'行供应商不能为空！');
				return;
			}
		}
		if ((data=="")&& (mod==false) ){
			Msg.info("warning","没有需要保存的数据!");
			return;
		}else{
			Ext.Ajax.request({
				url: PlanGridUrl+'?actiontype=save',
				params:{purNo:purNo,locId:locId,stkGrpId:stkGrpId,userId:userId,data:data,Remark:Remark},
				failure: function(result, request) {
					Msg.info("error","请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success","保存成功!");
						//新单重新加载, 否则reload
						if(Ext.isEmpty(purId)){
							purId=jsonData.info;
							Select(purId);
						}else{
							PlanGrid.reload();
						}
					}else{
						if(jsonData.info==-1){
							Msg.info("error","科室或人员为空!");
						}else if(jsonData.info==-99){
							Msg.info("error","加锁失败!");
						}else if(jsonData.info==-2){
							Msg.info("error","生成计划单号失败!");
						}else if(jsonData.info==-3){
							Msg.info("error","保存计划单失败!");
						}else if(jsonData.info==-4){
							Msg.info("error","未找到需更新的计划单!");
						}else if(jsonData.info==-5){
							Msg.info("error","保存计划单明细失败,不能生成计划单!");
						}else if(jsonData.info==-7){
							Msg.info("error","失败物资：部分明细保存不成功，提示不成功的物资!");
						}else{
							Msg.info("error","保存失败!");
						}
					}
				},
				scope: this
			});
		}
	}
});
// 变换行颜色
function changeBgColor(row, color) {
	PlanGrid.getView().getRow(row).style.backgroundColor = color;
}
var deletePlan = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		if(purId==null || purId==""){
			Msg.info("warning","请选择要删除的计划单!");
			return;
		}
		var compFlag=Ext.getCmp('Complete').getValue();
		var mod=Modified();
		if ( (mod) &&(!compFlag) ) {
			Ext.Msg.show({
				title:'提示',
				msg: Msg_LostModified,
				buttons: Ext.Msg.YESNO,
				fn: function(b,t,o){
					if (b=='yes'){Delete();}
				},
				icon: Ext.MessageBox.QUESTION
			});
		}else{
			Delete();
		}	
	}
});

function Delete(){
	Ext.MessageBox.confirm('提示','确定要删除该记录?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:PlanGridUrl+'?actiontype=delete&rowid='+purId,
					waitMsg:'删除中...',
					failure: function(result, request) {
						Msg.info("error", "请检查网络连接!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Msg.info("success", "删除成功!");
							clearData();
						}else{
							if(jsonData.info==-1){
								Msg.info("error", "订单已经完成，不能删除!");
								return false;
							}
							if(jsonData.info==-2){
								Msg.info("error", "订单已经审核，不能删除!");
								return false;
							}
							if(jsonData.info==-3){
								Msg.info("error", "删除计划单主表失败!");
								return false;
							}
							if(jsonData.info==-4){
								Msg.info("error", "删除计划单明细失败!");
								return false;
							}
						}
					},
					scope: this
				});
			}else{
				return false;
			}
		}
	)
}

function FinishPurPlan(){
	var completeFlag=Ext.getCmp('Complete').getValue();
	if (completeFlag==true) {
		Msg.info('error','当前采购计划单已经完成!')
		return;
	}
	
	var Count=PlanGrid.getCount()
	for(i=0;i<Count;i++){
		var rowData=PlanGrid.getAt(i)
		var Rp=Number(rowData.get("Rp"))
		if(Rp==0 && confirm('第'+(i+1)+'行进价为0,是否继续?') == false){
			return;
		}
	}
	
	//预算结余判断
	var HRPBudgResult = HRPBudg();
	if(HRPBudgResult === false){
		return;
	}
	
	Ext.MessageBox.confirm('提示','确定要完成该计划单吗?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:PlanGridUrl+'?actiontype=finsh&rowid='+purId,
					waitMsg:'处理中...',
					failure: function(result, request) {
						Msg.info("error", "请检查网络连接!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Msg.info("success", "计划单完成!");
							Ext.getCmp("Complete").setValue(true);
						}else{
							if(jsonData.info==-1){
								Msg.info("error", "计划单已经完成!");
								return false;
							}else if(jsonData.info==-4){
								Msg.info("error", "自动审批失败!");
								return false;
							}else if(jsonData.info==-11){
								Msg.info("error", "存在供应商为空的记录,不能完成计划单!");
								return false;
							}else if(jsonData.info==-12){
								Msg.info("error", "存在进价小于0的记录,不能完成计划单!");
								return false;
							}else{
								Msg.info("error", "操作失败:"+jsonData.info);
								return false;
							}
						}
					},
					scope: this
				});
			}else{
				return false;
			}
		}
	)
}
var finishPlan = new Ext.Toolbar.Button({
	text:'完成',
	tooltip:'完成',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((purId=="")||(purId==null)){
			Msg.info("error", "计划单为空!");
			return false;
		}else{
			var mod=Modified();
			if (mod) {
				Ext.Msg.show({
					title:'提示',
					msg: Msg_LostModified,
					buttons: Ext.Msg.YESNO,
					fn: function(b,t,o){
						if (b=='yes'){FinishPurPlan();}
					},
					icon: Ext.MessageBox.QUESTION
				});
			}else{
				FinishPurPlan();
			}
		}
	}
});

function CancelFinish(){
	var completeFlag=Ext.getCmp('Complete').getValue();
	if(completeFlag==false){
		Msg.info('error','当前采购计划单尚未完成!')
		return;
	}
	Ext.MessageBox.confirm('提示','确定要取消完成该计划单吗?',
		function(btn) {
			if(btn == 'yes'){
				Ext.Ajax.request({
					url:PlanGridUrl+'?actiontype=noFinsh&rowid='+purId,
					waitMsg:'处理中...',
					failure: function(result, request) {
						Msg.info("error", "请检查网络连接!");
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Msg.info("success", "成功取消计划单完成状态!");
							Ext.getCmp('Complete').setValue(false);
						}else{
							if(jsonData.info==-1){
								Msg.info("error", "计划单尚未完成!");
								return false;
							}
							if(jsonData.info==-2){
								Msg.info("error", "订单已经审核，不能取消完成!");
								return false;
							}
							if(jsonData.info==-3){
								Msg.info("error", "操作失败!");
								return false;
							}
						}
					},
					scope: this
				});
			}else{
				return false;
			}
		}
	)
}

var noFinshPlan = new Ext.Toolbar.Button({
	text:'取消完成',
	tooltip:'取消完成',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((purId=="")||(purId==null)){
			Msg.info("error", "计划单为空!");
			return false;
		}else{
			var mod=Modified();
			if (mod) {
				Ext.Msg.show({
					title:'提示',
					msg: Msg_LostModified,
					buttons: Ext.Msg.YESNO,
					fn: function(b,t,o){
						if (b=='yes'){CancelFinish();}
					},
					icon: Ext.MessageBox.QUESTION
				});
			}else{
				CancelFinish();
			}
		}
	}
});

// 清空按钮
var ClearBT = new Ext.Toolbar.Button({
			id : "ClearBT",
			text : '清空',
			tooltip : '点击清空',
			width : 70,
			height : 30,
			iconCls : 'page_clearscreen',
			handler : function() {
				var compFlag = Ext.getCmp('Complete').getValue();
				var mod = Modified();
				if (mod && (!compFlag)) {
					Ext.Msg.show({
								title : '提示',
								msg : Msg_LostModified,
								buttons : Ext.Msg.YESNO,
								fn : function(b, t, o) {
									if (b == 'yes') {
										clearData();
									}
								},
								icon : Ext.MessageBox.QUESTION
							});
				} else {
					clearData();
				}
			}
		});


function clearData(){
	clearPanel(formPanel);
	formPanel.getForm().setValues({dateField:new Date()});
	
	PlanGrid.AddNewRowButton.setDisabled(false);
	PlanGrid.removeAll();
	purId='';
	purNo='';
	finishPlan.setDisabled(false);   //完成
	savePlan.setDisabled(false);
	deletePlan.setDisabled(false);
	setEditDisabled(false);
	//清除可能存在href变量
	CheckLocationHref();
}

var formPanel = new Ext.form.FormPanel({
	id:'MainForm',
	title:'采购计划制单',
	autoHeight : true,
	region:'north',
	labelAlign : 'right',
	frame : true,
	trackResetOnLoad : true,
	bodyStyle : 'padding:5px 0px 0px 0px;',
	tbar:[findPlan,'-',savePlan,'-',deletePlan,'-',finishPlan,'-',noFinshPlan,'-',ClearBT,'-',PrintBT],
	items : [{
			style:'padding:5px 0px 0px 0px',
			layout : 'column',
			xtype : 'fieldset',
			title : '采购信息',
			defaults:{border:false},
			items : [{
					columnWidth : .25,
					xtype : 'fieldset',
					items : [locField,dateField]
				}, {
					columnWidth : .25,
					xtype : 'fieldset',
					items : [planNumField,RemarkField]
				},{
					columnWidth : .25,
					xtype : 'fieldset',
					items : [groupField]
				}, {
					columnWidth : .25,
					xtype : 'fieldset',
					items : [Complete]
			}]			
		}]
});

//表格
PlanGrid = new Ext.dhcstm.EditorGridPanel({
	id : 'PlanGrid',
	title:'采购计划单明细',
	contentColumns : PlanGridCm,
	actionUrl : "dhcstm.inpurplanaction.csp",
	queryAction : "queryItem",
	selectFirst : false,
	delRowAction : "deleteItem",
	delRowParam : "rowid",
	idProperty : 'RowId',
	checkProperty : 'IncId',
	beforeAddFn : beforeAddFn,
	afterAddFn : setEditDisabled,
	paging : false,
	region:'center',
	listeners : {
		beforeedit : function(e){
			if(Ext.getCmp("Complete").getValue()){
				return false;
			}
			if(e.field=="UomId"){
				var inci=e.record.get("IncId");
				if(inci==null || inci==""){
					Msg.info("warning","请先录入物资!");
					e.cancel=true;
				}
			}
		},
		afteredit : function(e){
			var InciId = e.record.get('IncId');
			if(e.field=='Qty'){
				var qty = e.value;
				e.record.set("RpAmt", accMul(e.record.get('Rp'),qty)); //购入金额
				HRPBudg(InciId);
			}else if(e.field=='Rp'){
				e.record.set("RpAmt", accMul(e.value,e.record.get('Qty'))); //购入金额
				HRPBudg(InciId);
			}
		}
	}
});

/*
 * 预算结余,调用HRP预算接口
 */
function HRPBudg(CurrInciId){
	CurrInciId = typeof(CurrInciId) == 'undefined'? '' : CurrInciId;
	var LocId = Ext.getCmp('locField').getValue();
	if(Ext.isEmpty(LocId)){
		return;
	}
	var DataStr = '';
	var Count = PlanGrid.getCount();
	for(i = 0; i < Count; i++){
		var RowData = PlanGrid.getAt(i);
		var Inppi = RowData.get('RowId');
		var UomId = RowData.get('UomId');
		var IncId = RowData.get('IncId');
		var RpAmt = RowData.get('RpAmt');
		if ((UomId == '') || (IncId == '') || !(RpAmt > 0)){
			continue;
		}
		var Data = Inppi + '^' + IncId + '^' + RpAmt;
		if(DataStr == ''){
			DataStr = Data;
		}else{
			DataStr = DataStr + RowDelim + Data;
		}
	}
	if(DataStr != ''){
		var Result = tkMakeServerCall('web.DHCSTM.ServiceForHerpBudg', 'InppBalance', CurrInciId, LocId, DataStr);
		if(!Ext.isEmpty(Result)){
			Msg.info('error', '当前采购超出预算,请核实修改:' + Result);
			return false;
		}
	}
	return true;
}

//右键菜单  bianshuai 2014-04-24
	function rightClickFn(grid,rowindex,e){
		grid.getSelectionModel().select(rowindex,0);
		//grid.getSelectionModel().selectRow(rowindex);
		e.preventDefault(); 
		rightClick.showAt(e.getXY()); 
	}
	var rightClick = new Ext.menu.Menu({ 
		id:'rightClickCont', 
		items: [ 
		{ 
			id: 'mnumodTransBat',   //批次修改增加 bianshuai 2014-04-23
			handler: mQueryBusDetail, 
			text: '进销历史' 
		}
		] 
	});
	PlanGrid.addListener('rowcontextmenu', rightClickFn);  //增加右键事件 bianshuai 2014-04-24
	//药品历史进销 bianshuai 2014-04-24
	function mQueryBusDetail()
	{
		var cell = PlanGrid.getSelectionModel().getSelectedCell();
		if (cell == null) {
			Msg.info("warning", "没有选中行!");
			return;
		}
		// 选中行
		var row = cell[0];
		var record = PlanGrid.getStore().getAt(row);
		var desc = record.get("IncDesc"); //药品名称
		var inci = record.get("IncId");      //库存ID
		var purlocid=Ext.getCmp("locField").getValue(); //采购科室
		BusInvoDetailWin(inci,desc,purlocid);
	}

//zdm,2013-03-1,查询采购单主信息
function Select(purid){
	Ext.Ajax.request({
		url : 'dhcstm.inpurplanaction.csp?actiontype=select&purId='+purid,
		method : 'POST',
		waitMsg : '查询中...',
		success : function(result,request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			formPanel.getForm().setValues(jsonData);
		},
		scope : this
	});
	PlanGrid.load({params:{parref:purid}});
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,PlanGrid],
		renderTo:'mainPanel'
	});
	//根据计划单号purId查询相关信息
	if((purId!="")&&(purId!=null)&&(purId!=0)){
		Select.defer(500,this,[purId]); //与默认设置类组冲突问题 默认设置类组后执行问题  延时处理
	}
});

/*看是否修改*/
function Modified(){
	if(PlanGrid.activeEditor!=null){
		PlanGrid.activeEditor.completeEdit();
	}
	var detailCnt=0
	var rowCount=PlanGrid.getStore().getCount();
	for (var i = 0; i < rowCount; i++){
		var item = PlanGrid.getStore().getAt(i).get("IncId");
		if (item != "") {
			detailCnt++;
		}
	}
	var result=false;
	//若为新单(purId="")，看子表是否有插入
	if ((purId<=0)||(purId==''))
	{
		if (detailCnt==0) {
			result=false;
		} else{
			result= true;
		}		
	}else{  //若不为新单，看主表或子表	
		var mod=Ext.getCmp('MainForm').getForm().isDirty();
		var modGrid=false;
		var rowsModified=PlanGrid.getStore().getModifiedRecords();
		if (rowsModified.length>0) modGrid=true
		if  (mod||modGrid) {
			result = true
		}else {
			result = false
		}
	}
	return result;
}

//设置可编辑组件的disabled属性
function setEditDisabled(bool){
	var bool = typeof(bool)=='undefined'?true:false;
	Ext.getCmp('groupField').setDisabled(bool);
	Ext.getCmp('locField').setDisabled(bool);
}

function beforeAddFn(){
	var defaData = {};
	var LocId = Ext.getCmp('locField').getValue();
	if((LocId=="")||(LocId==null)){
		Msg.info("error","请选择科室!");
		return false;
	}
	if(Ext.getCmp('groupField').getValue()==""){
		Msg.info("warning","请选择类组!");
		return false;
	}
}