// 名称:库存报损制单
// 编写日期:2012-08-14
var mainRowId="";
var reasonId = "";
var inscrapUrl='dhcstm.inscrapaction.csp';

//保存参数值的object
var InScrapParamObj = GetAppPropValue('DHCSTINSCRAPM');

//取高值管理参数
var UseItmTrack="";
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
}
//若使用高值跟踪,分一般报损和高值报损两个菜单,否则不需区分
UseItmTrack=UseItmTrack&&gHVInScrap;

var parrefRowId = "";
var UserId = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var CtLocId = session['LOGON.CTLOCID'];
var gGroupId=session['LOGON.GROUPID'];
var inciDr = "";

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'科室',
	//width:200,
	listWidth:210,
	emptyText:'科室...',
	groupId:gGroupId,
	anchor:'90%',
	stkGrpId:'groupField'
});

var dateField = new Ext.ux.DateField({
	id:'dateField',
	//width:200,
	listWidth:200,
    allowBlank:false,
	fieldLabel:'制单日期',
	anchor:'90%',
	value:new Date(),
	editable:false,
	disabled:true
});

var timeField = new Ext.form.TextField({
	id:'timeField',
	//width:200,
    allowBlank:false,
	fieldLabel:'制单时间',
	//format:'HH-MM-SS',
	anchor:'90%',
	//value:new Time(),
	disabled:true
});

var userField = new Ext.form.TextField({
	id:'adjUserField',
	fieldLabel:'制单人',
	width:200,
	anchor:'90%',
	disabled:true
});

var inscrapNumField = new Ext.form.TextField({
	id:'inscrapNumField',
	fieldLabel:'报损单号',
	allowBlank:true,
	//width:150,
	listWidth:150,
	emptyText:'报损单号...',
	anchor:'90%',
	selectOnFocus:true,
	disabled:true
});

// 物资类组
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	fieldLabel:'类组',
	//width:200,
	anchor:'90%',
	listWidth:200,
	StkType:App_StkTypeCode,     //标识类组类型
	LocId:CtLocId,
	UserId:UserId
});

// 报损原因
var causeField = new Ext.form.ComboBox({
	id:'causeField',
	fieldLabel:'报损原因',
	//width:200,
	anchor:'90%',
	listWidth:200,
	allowBlank:true,
	store:ReasonForScrapStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'报损原因...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});

var AddDetailBT=new Ext.Button({
	text:'增加一条',
	tooltip:'',
	height : 30,
	width : 70,
	iconCls:'page_add',
	handler:function()
	{
		addDetailRow();
	}
});

var DelDetailBT=new Ext.Button({
	text:'删除一条',
	tooltip:'',
	height : 30,
	width : 70,
	iconCls:'page_delete',
	handler:function()
	{
		DeleteDetail();
	}
});


var remarkField = new Ext.form.TextArea({
	id:'remarkField',
	fieldLabel:'备注',
	allowBlank:true,
	//width:200,
	height:50,
	emptyText:'备注...',
	anchor:'90%',
	selectOnFocus:true
});

var finshCK = new Ext.form.Checkbox({
	id: 'finshCK',
	fieldLabel:'完成',
	disabled:true,
	allowBlank:true
});

var HVBarCodeEditor = new Ext.form.TextField({
	selectOnFocus : true,
	listeners : {
		specialkey : function(field, e) {
			var Barcode=field.getValue();
			if (Barcode!="" && e.getKey() == Ext.EventObject.ENTER){
				var row=INScrapMGrid.getSelectionModel().getSelectedCell()[0];
				var RowRecord = INScrapMGrid.store.getAt(row);
				var findHVIndex=INScrapMGridDs.findExact('HVBarCode',Barcode,0);
				if(findHVIndex>=0 && findHVIndex!=row){
					Msg.info("warning","不可重复录入!");
					field.setValue("");
					return;
				}
				Ext.Ajax.request({
					url : 'dhcstm.itmtrackaction.csp?actiontype=GetItmByBarcode',
					method : 'POST',
					params : {Barcode:Barcode},
					waitMsg : '查询中...',
					success : function(result, request){
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if(jsonData.success == 'true'){
							var itmArr=jsonData.info.split("^");
							var status=itmArr[0],type=itmArr[1],lastDetailAudit=itmArr[2],lastDetailOperNo=itmArr[3];
							var inclb=itmArr[4],inciDr=itmArr[5],inciCode=itmArr[6],inciDesc=itmArr[7],scgID=itmArr[8],scgDesc=itmArr[9];
							var OriginalStatus=itmArr[29]
							RowRecord.set('OriginalStatus',OriginalStatus);
							if(OriginalStatus=="NotUnique"){
								var LocId = Ext.getCmp("locField").getValue();
								inclb=tkMakeServerCall("web.DHCSTM.DHCItmTrack","GetInclbByInclb",LocId,inclb)  //获取正确的inclb
							}
							var groupField=Ext.getCmp("groupField").getValue();
							if(!CheckScgRelation(groupField,scgID)){
								Msg.info("warning","条码"+Barcode+"属于"+scgDesc+"类组,与当前不符!");
								RowRecord.set("HVBarCode","");
								return;
							}else if(inclb==""){
								Msg.info("warning","该高值材料没有相应库存记录,不能制单!");
								RowRecord.set("HVBarCode","");
								return;
							}else if(lastDetailAudit!="Y" && OriginalStatus!="NotUnique"){
								Msg.info("warning","该高值材料有未审核的"+lastDetailOperNo+",请核实!");
								RowRecord.set("HVBarCode","");
								return;
							}else if(type=="T" && OriginalStatus!="NotUnique"){
								Msg.info("warning","该高值材料已经出库,不可制单!");
								RowRecord.set("HVBarCode","");
								return;
							}else if(status!="Enable"){
								Msg.info("warning","该高值条码处于不可用状态,不可制单!");
								RowRecord.set("HVBarCode","");
								return;
							}
							var record = Ext.data.Record.create([{
									name : 'InciDr',
									type : 'string'
								}, {
									name : 'InciCode',
									type : 'string'
								}, {
									name : 'InciDesc',
									type : 'string'
								}]);
							var InciRecord = new record({
								InciDr : inciDr,
								InciCode : inciCode,
								InciDesc : inciDesc
							});
							var phaLoc = Ext.getCmp("locField").getValue();
							var phaLocRQ = "";
							var url = "dhcstm.drugutil.csp?actiontype=GetDrugBatInfo&IncId="+inciDr
								+"&ProLocId="+phaLoc+"&ReqLocId="+phaLocRQ+"&QtyFlag=1"+"&StkType="+App_StkTypeCode+"&Inclb="+inclb+"&start=0&limit=1";
							var LBResult=ExecuteDBSynAccess(url);
							var info=Ext.util.JSON.decode(LBResult);
							if(info.results=='0'){
								Msg.info("warning","该高值材料没有相应库存记录,不能制单!");
								RowRecord.set("HVBarCode","");
								return;
							}
							var inforows=info.rows[0];
							Ext.applyIf(InciRecord.data,inforows);
							returnInfo(InciRecord, RowRecord);
						}else{
							Msg.info("warning","该条码尚未注册!");
							RowRecord.set("HVBarCode","");
							return;
						}
					}
				});
			}
		}
	}
});

var INScrapMGrid="";
//配置数据源
var INScrapMGridUrl = 'dhcstm.inscrapaction.csp';
var INScrapMGridProxy= new Ext.data.HttpProxy({url:INScrapMGridUrl+'?actiontype=queryItem',method:'GET'});
var INScrapMGridDs = new Ext.data.Store({
	proxy:INScrapMGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
    }, [
		{name:'inspi'},
		{name:'inclb'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'manf'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'qty'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'pp'},
		{name:'ppAmt'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'inclbQty'},
		"OriginalStatus",
		"HVFlag","HVBarCode"
	]),
    remoteSort:false
});

//模型
var INScrapMGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"rowid",
        dataIndex:'inspi',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"批次Id",
        dataIndex:'inclb',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"incirowid",
        dataIndex:'inci',
        width:150,
        align:'left',
        sortable : true,
		hidden : true
    },{
        header:"物资代码",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"物资名称",
        dataIndex:'desc',
        id:'desc',
        width:200,
        align:'left',
        sortable:true,
        editable:!UseItmTrack,
		editor:new Ext.form.TextField({
			id:'descField',
            allowBlank:false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						GetPhaOrderInfo2(Ext.getCmp('descField').getValue(),Ext.getCmp('groupField').getValue());
					}
				}
			}
        })
    },{
        header:"高值标志",
        dataIndex:'HVFlag',
        width:60,
        align:'center',
        sortable:true,
        hidden:true
    },{
    	header:"高值条码",
    	dataIndex:'HVBarCode',
    	id:'HVBarCode',
    	width:150,
    	align:'left',
        hidden:!UseItmTrack,
        editable:UseItmTrack,
    	editor:HVBarCodeEditor
    },{
        header:"批次~效期",
        dataIndex:'batNo',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"厂商",
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"批次库存",
        dataIndex:'inclbQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"报损数量",
        dataIndex:'qty',
        id:'adjQty',
        width:100,
        align:'right',
        sortable:true,
		editor:new Ext.form.NumberField({
			id:'qtyField',
            allowBlank:false,
            allowNegative :false,
			listeners:{
				specialKey:function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
						var rowData = INScrapMGridDs.getAt(cell[0]);
						if(field.getValue()>Number(rowData.get('inclbQty'))){
							var col=GetColIndex(INScrapMGrid,'qty');
							INScrapMGrid.startEditing(cell[0], col);
						}else{
							addNewRow();
						}
					}
				}
			}
        })
    },{
        header:"单位rowid",
        dataIndex:'uom',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"单位",
        dataIndex:'uomDesc',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"售价",
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"售价金额",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        summaryType:'sum'
    },{
        header:"进价",
        dataIndex:'rp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"进价金额",
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        summaryType:'sum'
    },{
        header:"批价",
        dataIndex:'pp',
        width:100,
        align:'right',
        hidden:true,
        sortable:true
    },{
        header:"批价金额",
        dataIndex:'ppAmt',
        width:100,
        align:'right',
        hidden:true,
        sortable:true,
        summaryType:'sum'
    }, {
		header : "条码类型",
		dataIndex : 'OriginalStatus',
		width : 100,
		align : 'left',
		sortable : true
	}
]);
//初始化默认排序功能
INScrapMGridCm.defaultSortable = true;

var addINScrapM = new Ext.Toolbar.Button({
	text:'新建',
    tooltip:'新建',
    iconCls:'page_add',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
			   		if (btn=='yes') {newInscrap();}
				}
			})		
		}else{
			newInscrap();
		}
	}
});
function newInscrap()
{
	mainRowId='';
	clearPage();
	addNewRow();
}
var findINScrapM = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged())
		{
			{
				Ext.Msg.show({
					title:'提示',
					msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
					buttons: Ext.Msg.YESNO,
					fn: function(btn){
				   		if (btn=='yes') {clearPage();find();}
				   }
				})
			}	
		}else{
			find();
		}
	}
});
function find()
{
	if (Ext.getCmp('scrapWinFind')) {
		Ext.getCmp('scrapWinFind').show();
	}else{
		FindINScrap(selectInscrap);
	}
}

var clearINScpM = new Ext.Toolbar.Button({
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		if (isDataChanged()){
			Ext.Msg.show({
				title:'提示',
				msg: '已经对该单数据做了修改，继续执行将丢失掉修改，继续吗？',
				buttons: Ext.Msg.YESNO,
				fn: function(btn){
					if (btn=='yes') {clearPage();SetFormOriginal(formPanel);}
				}
			})
		}else{
			clearPage();
			SetFormOriginal(formPanel);
		}
	}
});

var saveINScrapM = new Ext.ux.Button({
	text:'保存',
	tooltip:'保存',
	iconCls:'page_save',
	width : 70,
	height : 30,
	handler:function(){
		if(INScrapMGrid.activeEditor != null){
			INScrapMGrid.activeEditor.completeEdit();
		}
		if(CheckDataBeforeSave()==true){
			// 保存报损单
			save();
		}
	}
});


var deleteINScrapM = new Ext.Toolbar.Button({
	text:'删除',
	tooltip:'删除',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		var rowid=mainRowId;
		if(rowid!=""){
			Ext.MessageBox.confirm('提示','确定要删除当前报损单?',function(btn) {
				if(btn == 'yes'){
					Ext.Ajax.request({
						url : 'dhcstm.inscrapaction.csp?actiontype=delete&inscrap='+mainRowId,
						waitMsg:'删除中...',
						failure: function(result, request) {
							Msg.info("error", "请检查网络连接!");
							return false;
						},
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "删除成功!");
								clearPage();
								//INScrapMGridDs.load({params:{inscrap:mainRowId}});
							}else{
								Msg.info("error", "删除失败!");
								return false;
							}
						},
						scope: this
					});
				}else{
					return false;
				}
			})
		}else{
			Msg.info('warning','没有报损单，请先查询。');
			return;
		}
	}
});

var finshScp = new Ext.Toolbar.Button({
	text:'完成',
	tooltip:'完成',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", "报损单为空!请先查询.");
			return false;
		}else{
			if (Ext.getCmp('finshCK').getValue()==true){return;}
			
			Ext.MessageBox.confirm('提示','确定要完成该报损单吗?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcstm.inscrapaction.csp?actiontype=finish&InscpId='+mainRowId,
							waitMsg:'更新中...',
							failure: function(result, request) {
								Msg.info("error", "请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "报损单完成!");
									selectInscrap(mainRowId);
								}else{
									if(jsonData.info==-1){
										Msg.info("error", "报损单已经完成!");
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
				})
		}
	}
});

var noFinshScp = new Ext.Toolbar.Button({
	id:'noFinshScp',
	text:'取消完成',
	tooltip:'取消完成',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		if((mainRowId=="")||(mainRowId==null)){
			Msg.info("error", "报损单为空!请先查询.");
			return false;
		}else{
			if (Ext.getCmp('finshCK').getValue()==false)	{	Msg.info("error", "该报损单尚未完成!");return;	}
			Ext.MessageBox.confirm('提示','确定要取消完成该报损单吗?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:'dhcstm.inscrapaction.csp?actiontype=noFinish&InscpId='+mainRowId,
							waitMsg:'处理中...',
							failure: function(result, request) {
								Msg.info("error", "请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success", "成功取消报损单完成状态!");
									selectInscrap(mainRowId);
									
								}else{
									if(jsonData.info==-1){
										Msg.info("error", "报损单尚未完成!");
										return false;
									}
									if(jsonData.info==-2){
										Msg.info("error", "报损单已经审核，不能取消完成!");
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
	}
});

var printScp = new Ext.Toolbar.Button({
	text : '打印',
	tooltip : '打印报损单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		if (mainRowId ==null || mainRowId=="") {
			Msg.info("warning", "没有需要打印的报损单!");
			return;
		}
		PrintINScrap(mainRowId);
	}
});

var formPanel = new Ext.ux.FormPanel({
	title:gHVInScrap?'库存报损制单(高值)':'库存报损制单',
	tbar:[addINScrapM,'-',findINScrapM,'-',saveINScrapM,'-',deleteINScrapM,'-',clearINScpM,'-',finshScp,'-',noFinshScp,'-',printScp],
	items : [{
		xtype : 'fieldset',
		title : '报损单信息',
		items : [{
			layout : 'column',
			defaults : {layout : 'form'},
			items : [{
				columnWidth : .25,
				items : [inscrapNumField,locField,causeField]
			}, {
				columnWidth : .25,
				items : [dateField,timeField,userField]
			}, {
				columnWidth : .25,
				items : [groupField,remarkField]
			}, {
				columnWidth : .2,
				items : [finshCK]
			}]
		}]
	}]
});

//表格
INScrapMGrid = new Ext.grid.EditorGridPanel({
	title:'明细记录',
	store:INScrapMGridDs,
	id:'INScrapMGrid',
	cm:INScrapMGridCm,
	trackMouseOver:true,
	region:'center',
	height:650,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	plugins : new Ext.grid.GridSummary(),
	tbar:{items:[AddDetailBT,'-',DelDetailBT,'-',{text:'列设置',iconCls:'page_gear',height:30,width:70,handler:function(){GridColSet(INScrapMGrid,"DHCSTINSCRAPM");}}]},
	clicksToEdit:1,
	listeners:{
		beforeedit:function(e){
			if(Ext.getCmp("finshCK").getValue()){
				return false;
			}
			if(e.field=="desc"|| e.field=="uom"){
				if(e.record.get("HVBarCode")!=""){
					e.cancel=true;
				}
			}
			if(e.field=="qty"){
				if(e.record.get("HVBarCode")!="" && e.record.get("OriginalStatus")!="NotUnique"){
					e.cancel=true;
				}
			}
			if(e.field=="HVBarCode" && e.record.get("inclb")!=""){
				e.cancel=true;
			}
		},
		afteredit:function(e){
			if(e.field=='qty'){
				if(e.value>Number(e.record.get('inclbQty'))){
					Msg.info("error","报损数量不能大于批次库存!");
					return;
				}else{
					e.record.set("spAmt",accMul(e.value,e.record.get('sp')));
					e.record.set("rpAmt",accMul(e.value,e.record.get('rp')));
				}
			}
		}
	}
});

/***
**添加右键菜单
**/
INScrapMGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
var rightClick = new Ext.menu.Menu({ 
	id:'rightClickCont', 
	items: [ 
		{ 
			id: 'mnuDelete', 
			handler: DeleteDetail, 
			text: '删除' 
		}
	] 
}); 
		
//右键菜单代码关键部分 
function rightClickFn(grid,rowindex,e){ 
	e.preventDefault(); 
	rightClick.showAt(e.getXY()); 
}

//=========================库存报损制单=============================	
function GetPhaOrderInfo2(item, group) {
	if (item != null && item.length > 0) {
		var phaLoc = Ext.getCmp("locField").getValue();
		IncItmBatWindow(item, group, App_StkTypeCode, phaLoc, "N", "1", HospId,"",	returnInfo);	
	}
}
		
function addNewRow() {
	var descIndex = GetColIndex(INScrapMGrid,"desc");
	var barcodeIndex = GetColIndex(INScrapMGrid,"HVBarCode");
	var colIndex = gHVInScrap?barcodeIndex:descIndex;
	var rowCount = INScrapMGrid.getStore().getCount();
	if(rowCount>0){
		var rowData = INScrapMGridDs.data.items[rowCount - 1];
		var data=rowData.get("inci")
		if(data=="" || data.length<=0){
			INScrapMGrid.startEditing(INScrapMGridDs.getCount() - 1, colIndex);
		    return;
		}
	}
	//判断类组是否已经
	if  (Ext.getCmp('groupField').getRawValue()==''){
		Ext.getCmp('groupField').setValue(null);
	}

	var scg = Ext.getCmp('groupField').getValue(); 
	if((scg=="")||(scg==null)){
		Msg.info("error", "请选择类组!");
		return ;
	}
	var NewRecord = CreateRecordInstance(INScrapMGridDs.fields);
	INScrapMGridDs.add(NewRecord);
	INScrapMGrid.getSelectionModel().select(INScrapMGridDs.getCount() - 1, colIndex);
	INScrapMGrid.startEditing(INScrapMGridDs.getCount() - 1, colIndex);
	
	setEditDisable();
}		

function clearPage()
{
	mainRowId="";
	//Ext.getCmp('locField').setValue("");
	//Ext.getCmp('locField').setRawValue("");
	Ext.getCmp('inscrapNumField').setValue("");
	Ext.getCmp('dateField').setValue("");
	Ext.getCmp('timeField').setValue("");
	Ext.getCmp('adjUserField').setValue("");
		
	Ext.getCmp('causeField').setValue("");
	Ext.getCmp('causeField').setRawValue("");
	Ext.getCmp('remarkField').setValue("");
	
	Ext.getCmp('finshCK').setValue("");
	
	INScrapMGridDs.removeAll();
	
	this.deleteINScrapM.enable();
	this.saveINScrapM.enable();
	
	setEditEnable();
}

//科室库存项批次信息窗口关闭时回调函数
function returnInfo(record, rowData) {
	if (Ext.isEmpty(record) || Ext.isEmpty(rowData)) {
		return;
	}
	var HVFlag=record.get("HVFlag");
	var inclb = record.get("Inclb");
	inciDr = record.get("InciDr");
	rowData.set("inci",inciDr);
	rowData.set("code",record.get("InciCode"));
	rowData.set("desc",record.get("InciDesc"));
	rowData.set("batNo",record.get("BatExp"));
	rowData.set("manf",record.get("Manf"));
	rowData.set("uom",record.get("PurUomId"));
	rowData.set("uomDesc",record.get("PurUomDesc"));
	rowData.set("sp",record.get("Sp"));
	rowData.set("rp",record.get("Rp"));
	rowData.set("inclbQty",record.get("InclbQty"));
	rowData.set("inclb",record.get("Inclb"));
	
	if(record.get("InclbQty")<1){
		Msg.info("warning","可用库存不足!");
		return;
	}else{
		rowData.set("qty", 1);
		rowData.set("rpAmt", record.get("Rp"));
		rowData.set("spAmt", record.get("Sp"));
		addNewRow();
	}
}

function CheckDataBeforeSave(){
	var user = UserId;
	var locId = Ext.getCmp('locField').getValue();
	if((locId=="")||(locId==null)){
		Msg.info("error","请选择供应科室!");
		return false;
	}
	var scg = Ext.getCmp('groupField').getValue();
	if((scg=="")||(scg==null)){
		Msg.info("error","请选择类组!");
		return false;
	}
	var scpReason = Ext.getCmp('causeField').getValue();
	if((scpReason=="")||(scpReason==null)){
		Msg.info("error","请选择报损原因!");
		return false;
	}
	
	//检查是否有明细(适用于新建的单据)
	if (mainRowId==''){
		var ListDetail="";
		var rowCnt=0;
		var rowCount = INScrapMGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = INScrapMGridDs.getAt(i);	
			//新增或数据发生变化时执行下述操作
			if(rowData.data.newRecord || rowData.dirty){					
				var Inspi=rowData.get("inspi");
				var inclb = rowData.get("inclb");
				if (inclb=='') break;
				var uom = rowData.get("uom");
				if (uom=='') break;
				var qty = rowData.get("qty");
				if (qty=='') {
					Msg.info("warning","第"+(i+1)+"行报损数量为空!");
					return;
				}
				var rpAmt = rowData.get("rpAmt");
				if (rpAmt=='') {
					Msg.info("warning","第"+(i+1)+"行进价金额为空!");
					return;
				}
				
				rowCnt++;
			}
		}
		if (rowCnt==0){Msg.info('warning','没有任何明细!禁止保存.');return false;}
	}
	
	return true;
}

function save(){
	var scpUser = UserId;
	var scpNo = Ext.getCmp("inscrapNumField").getValue();
	var scpLoc = Ext.getCmp('locField').getValue();
	var scpComp = Ext.getCmp('finshCK').getValue()==true?'Y':'N';
	var scpReason = Ext.getCmp('causeField').getValue();
	var scpScg = Ext.getCmp('groupField').getValue();
	var remark = Ext.getCmp('remarkField').getValue();  //备注
	var inscrapno = Ext.getCmp('inscrapNumField').getValue();
	
	remark=remark.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
	
	var tmpData = scpUser+"^"+scpLoc+"^"+scpComp+"^"+scpReason+"^"+scpScg+"^"+remark+"^"+inscrapno;
	if(tmpData!=""){
		var ListDetail="";
		var rowCount = INScrapMGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {
			var rowData = INScrapMGridDs.getAt(i);	
			//新增或数据发生变化时执行下述操作
			if(rowData.data.newRecord || rowData.dirty){					
				var Inspi=rowData.get("inspi");
				var inclb = rowData.get("inclb");
				var uom = rowData.get("uom");
				var qty = rowData.get("qty");
				var inclbQty=rowData.get("inclbQty");
				if(qty>inclbQty){
					Msg.info("warning","报损数量不能大于批次库存");
					return;
				}
				if(qty<0){
					Msg.info("warning","报损数量不能小于0");
					return;
				}
				var Rp = rowData.get("rp");
				var rpAmt = rowData.get("rpAmt");
				var Sp = rowData.get("sp");
				var spAmt =rowData.get("spAmt");
				var Pp = rowData.get("pp");
				var ppAmt = rowData.get("ppAmt");
				var HVBarCode = rowData.get("HVBarCode");
				var rowStr = Inspi + "^" + inclb + "^"	+ uom + "^" + qty + "^"	+ Rp + "^" + rpAmt + "^"  + Pp + "^" + ppAmt + "^" + Sp+ "^" + spAmt
							+ "^" + HVBarCode;
				if(ListDetail==""){
					ListDetail=rowStr;
				}
				else{
					ListDetail=ListDetail+ xRowDelim() + rowStr;
				}
			}
		}
		
		Ext.Ajax.request({
			//url: INScrapMGridUrl+'?actiontype=save&inscrap='+mainRowId+'&MainInfo='+tmpData+'&ListDetail='+ListDetail,
			url: INScrapMGridUrl+'?actiontype=save',
			params: {inscrap:mainRowId,MainInfo:tmpData,ListDetail:ListDetail},
			method : 'POST',
			waitMsg : '处理中...',
			failure: function(result,request) {
				Msg.info("error","请检查网络连接!");
			},
			success: function(result,request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );			
				if (jsonData.success=='true') {
					Msg.info("success","保存成功!");
					mainRowId = jsonData.info;
					
					selectInscrap(mainRowId);
				}	
				if(jsonData.success=='false'){
					Msg.info("error","保存失败!");
				}
			},
			scope: this
		});
	}	
}

		
// 显示报损单明细数据
function getDetail(InscpRowid) {

	if (InscpRowid == null || InscpRowid.length <= 0 || InscpRowid <= 0) {
		return;
	}
	INScrapMGridDs.removeAll();
	INScrapMGridDs.load({params:{start:0,limit:999,inscrap:InscpRowid}});
	

	// 变更按钮是否可用
	//查询^清除^新增^保存^删除^完成^取消完成
	//var inGrFlag = Ext.getCmp("CompleteFlag").getValue();
	//if(inGrFlag==true){
		//Ext.getCmp("noFinshScp").setDisabled(false);
	//	changeButtonEnable("1^1^0^0^0^0^1");
	//}else{
		//Ext.getCmp("noFinshScp").setDisabled(true);
	//	changeButtonEnable("1^1^1^1^1^1^0");
	//}
}
		
		/**
		 * 删除选中行物资
		 */
function DeleteDetail() {
	// 判断报损单是否已完成
	var CmpFlag = Ext.getCmp("finshCK").getValue();
	if (CmpFlag != null && CmpFlag != false) {
		Msg.info("warning", "报损单已完成,禁止删除明细记录!");
		return;
	}
	var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
	if (cell == null) {
		Msg.info("warning", "请选择数据!");
		return;
	}
	// 选中行
	var row = cell[0];
	var record = INScrapMGrid.getStore().getAt(row);
	var Inspi = record.get("inspi");
	if (Inspi == "" ) {
		INScrapMGrid.getStore().remove(record);
		INScrapMGrid.getView().refresh();
		if (INScrapMGrid.getStore().getCount()==0){
			setEditEnable();
		}			
	} else {
		Ext.MessageBox.show({
			title : '提示',
			msg : '是否确定删除该物资信息?',
			buttons : Ext.MessageBox.YESNO,
			fn : showResult,
			icon : Ext.MessageBox.QUESTION
		});		
	}

}
		/**
		 * 删除提示
		 */
function showResult(btn) {
	if (btn == "yes") {
		var cell = INScrapMGrid.getSelectionModel().getSelectedCell();
		var row = cell[0];
		var record = INScrapMGrid.getStore().getAt(row);
		var Inspi = record.get("inspi");

		// 删除该行数据
		var url = DictUrl+ "inscrapaction.csp?actiontype=deldetail&RowId=" + Inspi;

		Ext.Ajax.request({
			url : url,
			method : 'POST',
			waitMsg : '删除中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON
						.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "删除成功!");
					INScrapMGrid.getStore().remove(record);
					INScrapMGrid.getView().refresh();
				} else {
					var ret=jsonData.info;
					if(ret==-1){
						Msg.info("error", "报损单已经完成，不能删除!");
					}else if(ret==-2){
						Msg.info("error", "报损单已经审核，不能删除!");
					}else{
						Msg.info("error", "删除失败,请查看错误日志!");
					}
				}
				if (INScrapMGrid.getStore().getCount()==0){
					setEditEnable();
				}	
			},
			scope : this
		});
	}
}


//增加一条(明细)
function addDetailRow(){
	if ((mainRowId!="")&&(Ext.getCmp('finshCK').getValue()==true)){
		Msg.info('warning','当前调整单已完成,禁止增加明细记录!');
		return;
	}
	addNewRow();
}
//取出报损单主表的数据，并填充到组件上
function selectInscrap(rowid)
{
	mainRowId=rowid;
	Ext.Ajax.request({
		url:inscrapUrl+'?actiontype=Select'+'&InscpId='+rowid,
		failure:function(){},
		success:function(result,request){
			
			var jsonData = Ext.util.JSON.decode(result.responseText );
			if (jsonData.results>0) {
				data=jsonData.rows  ;
				var loc=data[0]['INSCP_CTLOC_DR'];
				var locDesc=data[0]['locDesc'];
				var scg=data[0]['INSCP_SCG_DR'];
				var scgDesc=data[0]['scgDesc'];
				var reason=data[0]['INSCP_Reason'];
				var reasonDesc=data[0]['reason'];
				var inscrapNo=data[0]['INSCP_NO'];
				var adjDate=data[0]['INSCP_Date'];
				var adjTime=data[0]['INSCP_Time'];
				var completeFlag=data[0]['INSCP_Completed'];
				var auditFlag=data[0]['INSCP_ChkFlag'];
				var remark=data[0]['INSCP_Remarks'];
				var userName=data[0]['userName'] ;
				var auditUserName=data[0]['INSCP_ChkUser_DR'];
				var chkDate=data[0]['INSCP_ChkDate'];
				var chkTime=data[0]['INSCP_ChkTime'];
			
				inscrapNumField.setValue(inscrapNo);
				locField.setValue(loc);
				locField.setRawValue(locDesc);
				dateField.setValue(adjDate);
				timeField.setValue(adjTime);
				userField.setValue(userName);
				
				if(completeFlag=='Y'){
					finshCK.setValue(true);
					saveINScrapM.disable();
					deleteINScrapM.disable();
					finshScp.disable();
				}else{
					finshCK.setValue(false);
					saveINScrapM.enable();
					deleteINScrapM.enable();
					finshScp.enable();
				}
				
				causeField.setValue(reason);
				causeField.setRawValue(reasonDesc);
				remark=handleMemo(remark,xMemoDelim());
				remarkField.setValue(remark);
				addComboData(null,scg,scgDesc,groupField);
				groupField.setValue(scg);
				SetFormOriginal(formPanel);
			
				//检索明细
				getDetail(mainRowId);
			}	
		
			if (mainRowId>0)
			{
				setEditDisable();
			}
		}
	})
}

//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,INScrapMGrid],
		renderTo:'mainPanel'
	});
	RefreshGridColSet(INScrapMGrid,"DHCSTINSCRAPM");   //根据自定义列设置重新配置列
});
//===========模块主页面=============================================


 //设置可编辑组件的disabled属性
function setEditDisable()
{
	Ext.getCmp('groupField').setDisabled(true);
	Ext.getCmp('locField').setDisabled(true);
}
 //放开可编辑组件的disabled属性
function setEditEnable()
{
	Ext.getCmp('groupField').setDisabled(false);
	Ext.getCmp('locField').setDisabled(false);
}

//查看请求单数据是否有修改
function isDataChanged()
{
	var changed=false;
	var count1= INScrapMGrid.getStore().getCount();
	//看主表数据是否有修改
	//修改为主表有修改且子表有数据时进行提示
	if((IsFormChanged(formPanel))&&(count1!=0))
	{
		changed = true;	
	};
	if (changed) return changed;
	//看明细数据是否有修改
	var count= INScrapMGrid.getStore().getCount();
	for(var index=0;index<count;index++){
		var rec = INScrapMGrid.getStore().getAt(index);	
				//新增或数据发生变化时执行下述操作
	    if(rec.data.newRecord || rec.dirty){
			changed = true;
		}
	}
	return changed;
}	