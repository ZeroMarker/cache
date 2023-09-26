// /名称: 发票审核
// /编写者：lihui
// /编写日期: 20171124
var invauditURL="dhcstm.invauditaction.csp"
var gIncId="";
var gTrType = "";			//当前选中单据的台帐类型(G\R)
var gGroupId=session['LOGON.GROUPID'];
var userId = session['LOGON.USERID'];
var CtLocId = session['LOGON.CTLOCID'];
var parastr=gGroupId+"^"+CtLocId+"^"+userId;
var timer=null; ///定义全局变量定时器   防止全选的时候 执行多次查询的问题
// 采购科室
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	name:'locField',
	fieldLabel:'采购科室',
	listWidth:210,
	groupId:gGroupId,
	anchor:'90%',
	childCombo : 'Vendor'
});

var INVNo = new Ext.form.TextField({
	fieldLabel : '发票号',
	id : 'INVNo',
	name : 'INVNo',
	anchor : '90%'
});

var INVNocombo = new Ext.form.ComboBox({
	id:'INVNocombo',
	fieldLabel : '发票状态',
        typeAhead: true,
        triggerAction: 'all',
        lazyRender:true,
        anchor : '90%',
        mode: 'local',
        store: new Ext.data.ArrayStore({
             id: 0,
             fields: [
                'myId',
                'displayText'
              ],
             data: [[1, '全部'], [2, '已填写'],[3, '未填写']]
           }),
         valueField: 'myId',
         displayField: 'displayText'
});
Ext.getCmp("INVNocombo").setValue("1");


var SXNo = new Ext.form.TextField({
	fieldLabel : '随行单号',
	id : 'SXNo',
	name : 'SXNo',
	anchor : '90%'
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '供应商...',
	params : {LocId : 'locField'}
});
	
// 起始日期
var StartDate = new Ext.ux.DateField({
	fieldLabel : '起始日期',
	id : 'StartDate',
	name : 'StartDate',
	anchor : '90%',
	width : 120,
	value : new Date().add(Date.DAY, - 30)
});

// 截止日期
var EndDate = new Ext.ux.DateField({
	fieldLabel : '截止日期',
	id : 'EndDate',
	name : 'EndDate',
	anchor : '90%',
	value : new Date()
});

var InciDesc = new Ext.form.TextField({
	fieldLabel : '物资名称',
	id : 'InciDesc',
	name : 'InciDesc',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			var keyCode=e.getKey();
			if ( keyCode== Ext.EventObject.ENTER) {
				GetPhaOrderInfo(field.getValue(),'');
			}
		}
	}
});
/// 拒绝理由
var RefuseReason = new Ext.form.TextField({
	id:'RefuseReason',
	fieldLabel:'拒绝理由',
	anchor:'90%',
	height:30,
	selectOnFocus:true
});
/**
 * 调用物资窗体并返回结果
 */
function GetPhaOrderInfo(item, stktype) {
	if (item != null && item.length > 0) {
		GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
	}
}

/**
 * 返回方法
 */
function getDrugList(record) {
	if (record == null || record == "") {
		gIncId="";
		return;
	}
	gIncId = record.get("InciDr");
	var inciCode=record.get("InciCode");
	var inciDesc=record.get("InciDesc");
	Ext.getCmp("InciDesc").setValue(inciDesc);
}
// 已审核
var AuditFlag = new Ext.form.Checkbox({
	fieldLabel : '已审核',
	id : 'AuditFlag',
	name : 'AuditFlag',
	anchor : '90%',
	width : 120,
	checked : false
});
// 查询按钮
var SearchBT = new Ext.Toolbar.Button({
	text : '查询',
	tooltip : '点击查询',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		Query();
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
		clearData();
	}
});
var PrintBT = new Ext.Toolbar.Button({
			id:'PrintBT',
			text : '打印',
			tooltip : '点击打印',
			width : 70,
			height : 30,
			iconCls : 'page_print',
			handler : function() {
				var selections=MasterGrid.getSelectionModel().getSelections();
				if(selections.length<1){
					Msg.info("warning", "请选择需要打印的入库单!");
					return;
				}
				var IdStrs="";
				for(var i=0;i<selections.length;i++){
					var record=selections[i];
					var ReAudUser=record.get("ReAudUser");
					var IngrNo=record.get("IngrNo");
					if ((ReAudUser=="")||(ReAudUser==null))
					{
						Msg.info("warning",IngrNo+"单据主任还未审核，不允许打印！");
						return;
					}
					var TrType=record.get("TrType");
					var RowId=record.get("RowId");
					var idstr=RowId+"^"+TrType;
					if (IdStrs=""){
						IdStrs=idstr;
					}else{
						IdStrs=IdStrs+","+idstr;
					}
				}
			    if(IdStrs==""){Msg.info("warning","没有需要打印的单据!");return;}
			    var IdArr=GetRecRetIdStr(IdStrs).split(",");
			    alert(IdArr.length);
			    
			    
			}
		});
// 审核
var AuditBT = new Ext.Toolbar.Button({
	id : "AuditBT",
	text : '审核',
	tooltip : '设置当前单据为<已审核>',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
			if ((AllowAudit(parastr))!=0){Msg.info("warning","您没有权限审核!");return;}
			Audit();
		}
});
function Audit(){
            var RcRtStr=""
			var rowDataArr = MasterGrid.getSelectionModel().getSelections();
			if (Ext.isEmpty(rowDataArr)) {
				Msg.info("warning", "请选择要审核的单据!");
				return;
			}
			for(i=0;i<rowDataArr.length;i++)
				{
				var rowData=rowDataArr[i];
				var RowId = rowData.get("RowId");
				var Type = rowData.get("TrType");
				var RcRtInfo=RowId+"#"+Type;
				if (RcRtStr=="")
				{
				RcRtStr=RcRtInfo;}
				else{
				RcRtStr=RcRtStr+"^"+RcRtInfo;
				}
				}
			var paramstr=gGroupId+"^"+CtLocId+"^"+userId;
			if(RcRtStr==""){Msg.info("warning", "没有可以审核的单据!");return}
			var url = invauditURL+"?actiontype=AuditStr";
			Ext.Ajax.request({
				url : url,
				params : {RcRtStr:RcRtStr,paramstr:paramstr},
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						var ret=jsonData.info;// 审核单据
						var retarr=ret.split(",");
						var total=retarr[0];
						var sucess=retarr[1];
						Msg.info("success", "共"+total+"张单据,成功审核"+sucess+"单据!");
						Query();
					} 
				},
				scope : this
			});
}

// 取消审核
var CancleAuditBT = new Ext.Toolbar.Button({
	id : "CancleAuditBT",
	text : '取消审核',
	tooltip : '取消单据的<审核>标志',
	width : 70,
	height : 30,
	iconCls : 'page_delete',
	handler : function() {
		if ((AllowAudit(parastr))!=0){Msg.info("warning","您没有权限取消审核!");return;}
		Ext.MessageBox.show({
			title : '提示',
			msg : '是否取消审核该单据?',
			buttons : Ext.MessageBox.YESNO,
			fn: function(b,t,o){
				if (b=='yes'){
					CancleAudit();
				}
			},
			icon : Ext.MessageBox.QUESTION
		});
	}
});
function CancleAudit(){
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "请选择要取消审核的单据!");
				return;
			}
			var paramstr=gGroupId+"^"+CtLocId+"^"+userId;
			var RowId = rowData.get("RowId");
			var No=rowData.get("IngrNo");
			var Type = rowData.get("TrType");
			var url = invauditURL+"?actiontype=CancleAudit";
			Ext.Ajax.request({
				url : url,
				params : {RowId:RowId,Type:Type,paramstr:paramstr},
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "取消审核成功!");
						Query();
					}else{
					    var Ret=jsonData.info;
					    if (Ret==-2){
						   Msg.info("error", No+"单据还未确认!");
						}else if (Ret==-3){
						   Msg.info("error", No+"单据还未审核!");
						}else if (Ret==-4){
						   Msg.info("error", No+"单据已复审!");
						}else if (Ret==-5){
						   Msg.info("error", No+"单据还未复审!");  //第三级审核的提示
						}else{
						   Msg.info("error", "取消审核失败:"+Ret);
						}
					    
					}
				},
				scope : this
			});
}
//拒绝
var AuditNoBT = new Ext.Toolbar.Button({
					id : "AuditNoBT",
					text : '审核拒绝',
					tooltip : '点击审核拒绝,打回到未确认',
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					handler : function() {
						    if ((AllowAudit(parastr))!=0){Msg.info("warning","您没有权限拒绝!");return;}
							Ext.MessageBox.show({
								title : '提示',
								msg : '是否拒绝该单据?',
								buttons : Ext.MessageBox.YESNO,
								fn: function(b,t,o){
									if (b=='yes'){
										AuditNo();
									}
								},
								icon : Ext.MessageBox.QUESTION
							});
					}
				});
function AuditNo(){
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "请选择要拒绝的单据!");
				return;
			}
			var RefuseReason = Ext.getCmp('RefuseReason').getValue();
			if ((RefuseReason ==null)||(RefuseReason=="")) {
				Msg.info("warning", "没写拒绝理由,不能拒绝呢!");
				return;
			}
			//RefuseReason=RefuseReason.replace(/\r/g,'').replace(/\n/g,xMemoDelim());
			var paramstr=gGroupId+"^"+CtLocId+"^"+userId;
			var RowId = rowData.get("RowId");
			var Type = rowData.get("TrType");
			var No=rowData.get("IngrNo");
			var url = invauditURL+"?actiontype=AuditNo";
			Ext.Ajax.request({
				url : url,
				params : {RowId:RowId,Type:Type,paramstr:paramstr,RefuseReason:RefuseReason},
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "拒绝审核成功!");
						Query();
					}else{
					    var Ret=jsonData.info;
					    if (Ret==-2){
						   Msg.info("error", No+"单据还未确认!");
						}else if (Ret==-3){
						   Msg.info("error", No+"单据已复审!");
						}else if (Ret==-4){
						   Msg.info("error", No+"单据已审核!");
						}else if (Ret==-5){
						   Msg.info("error", No+"单据未审核!");  //第三级审核的提示
						}else{
						   Msg.info("error", "拒绝审核失败:"+Ret);
						}
					}
				},
				scope : this
			});
}
/**
 * 查询方法
 */
function Query() {
	var phaLoc = Ext.getCmp("locField").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "请选择采购科室!");
		return;
	}
	DetailGrid.store.removeAll();
	DetailGrid.getView().refresh();
	MasterStore.load();
}

/**
 * 清空方法
 */
function clearData() {
	SetLogInDept(locField.getStore(),"locField");
	Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
	Ext.getCmp("EndDate").setValue(new Date());
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("INVNo").setValue("");
	Ext.getCmp("SXNo").setValue("");
	Ext.getCmp("InciDesc").setValue("");
	Ext.getCmp("AuditFlag").setValue(false);
	Ext.getCmp("RefuseReason").setValue("");
	MasterGrid.store.removeAll();
	MasterGrid.getView().refresh();
	DetailGrid.store.removeAll();
	DetailGrid.getView().refresh();
}
var RcRttotalrp = new Ext.form.TextField({
	fieldLabel : '金额合计',
	width:200,
	id : 'RcRttotalrp',
	name : 'RcRttotalrp',
	anchor : '100%',
	readOnly : true
});
function getRcRttotalrp(){   
	var selarr = MasterGrid.getSelectionModel().getSelections();
	var totalrp=0
	var totalqty=0
	for (var i = 0; i < selarr.length; i++) {
		var rowData = selarr[i];
		var Rp = rowData.get("RpAmt");
		//var Qty= rowData.get("QtyAmt");
		totalrp=accAdd(totalrp,Rp)
		//totalqty=accAdd(totalqty,Qty)
	}
	Ext.getCmp("RcRttotalrp").setValue(" 金额合计:"+totalrp);
}
// 访问路径
var MasterUrl = 'dhcstm.invmanageaction.csp?actiontype=query';
// 通过AJAX方式调用后台数据
var mProxy = new Ext.data.HttpProxy({
	url : MasterUrl,
	method : "POST"
});

// 指定列参数
var mFields = ['RowId', 'VendorName', 'PhaLoc', 'IngrNo', 'CreateDate',
		'CreateUser', 'AuditDate', 'AuditUser', 'RpAmt', 'PayedAmt',
		'PayOverFlag', 'TrType', 'State', 'ComDate', 'ComTime',
		'ComUser', 'AudDate', 'AudTime', 'AudUser', 'ReAudDate', 'ReAudTime', 'ReAudUser','RefuseReason'];
// 支持分页显示的读取方式
var mReader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId"+"TrType",
	fields : mFields
});
// 数据集
var MasterStore = new Ext.data.Store({
	proxy : mProxy,
	reader : mReader,
	listeners:{
		'beforeload':function(ds){
			var vendor = Ext.getCmp("Vendor").getValue();
			var startDate = Ext.getCmp("StartDate").getValue();
			var endDate = Ext.getCmp("EndDate").getValue();
			if(startDate!=""){
				startDate = startDate.format(ARG_DATEFORMAT);
			}
			if(endDate!=""){
				endDate = endDate.format(ARG_DATEFORMAT);
			}
			var invno = Ext.getCmp("INVNo").getValue();
			var sxno = Ext.getCmp("SXNo").getValue();
                        var INVNoFlag=Ext.getCmp("INVNocombo").getValue();
			if (Ext.getCmp('InciDesc').getValue()==''){
				gIncId='';
			}
			var inciid = gIncId;  
			var phaLoc=Ext.getCmp("locField").getValue();
			var AuditFlag=(Ext.getCmp("AuditFlag").getValue()?"Y":"N");
			//科室id^开始日期^截止日期^供应商id^发票号^随行单号^物资id
			var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+vendor+'^'+invno+'^'+sxno+'^'+inciid+'^'+INVNoFlag+'^'+gGroupId+'^'+CtLocId+'^'+userId+'^'+AuditFlag;
			ds.baseParams={start:0, limit:9999,strParam:ListParam};
			ds.removeAll();
		},
		load : function(store,records,options){
			if (records.length>0){
				MasterGrid.getSelectionModel().selectFirstRow();
			}
			var rowCount = MasterStore.getCount();
			for (var i = 0; i < rowCount; i++) {
				var rowData = MasterStore.getAt(i);
				var State = rowData.get("State");
				if(State==1){
					MasterGrid.getView().getRow(i).style.backgroundColor = "yellow";
				}	
			}
		}
	}
});
var sm =new Ext.grid.CheckboxSelectionModel({
	listeners:{
		selectionchange:function(ssm){
			getRcRttotalrp();
			clearTimeout(timer)
			timer=change.defer(100,this,[ssm])
		} 
	}
});
	function change(ssm){
		var recarr=ssm.getSelections();
		var count=recarr.length;
		var parstr=""
		for (i=0;i<count;i++)
		{
			var rec=recarr[i];
			var reqid=rec.get('RowId');
			var type=rec.get('TrType');
			if (parstr=="")
			 {parstr=reqid+"^"+type}
			 else
			 {parstr=parstr+","+reqid+"^"+type}
		}
	DetailStore.setBaseParam('parstr',parstr);
	DetailStore.removeAll();
	DetailStore.load({params:{start:0,limit:99999}});
	}
var MasterCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),sm,
	{
		header : '类型',
		dataIndex : 'TrType',
		width : 60,
		renderer : function(value){
			var TrName = value;
			if(value == 'G'){
				TrName = '入库单';
			}else if (value == 'R'){
				TrName = '退货单';
			}
			return TrName;
		}
	},{
		header : "RowId",
		dataIndex : 'RowId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : false
	},{
		header : "供应商",
		dataIndex : 'VendorName',
		width : 240,
		align : 'left',
		sortable : true
	}, {
		header : "采购科室",
		dataIndex : 'PhaLoc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "单据号",
		dataIndex : 'IngrNo',
		width : 160,
		align : 'left',
		sortable : true
	}, {
		header : "制单日期",
		dataIndex : 'CreateDate',
		width : 90,
		align : 'center',
		sortable : true
	}, {
		header : "制单人",
		dataIndex : 'CreateUser',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "审核日期",
		dataIndex : 'AuditDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "审核人",
		dataIndex : 'AuditUser',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "确认日期",
		dataIndex : 'ComDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "确认人",
		dataIndex : 'ComUser',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "采购审核日期",
		dataIndex : 'AudDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "采购审核人",
		dataIndex : 'AudUser',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "主任审核日期",
		dataIndex : 'ReAudDate',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "主任审核人",
		dataIndex : 'ReAudUser',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "拒绝理由",
		dataIndex : 'RefuseReason',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "进价金额",
		dataIndex : 'RpAmt',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "已付金额",
		dataIndex : 'PayedAmt',
		width : 100,
		align : 'right',
		sortable : true
	}, {
		header : "结清标志",
		dataIndex : 'PayOverFlag',
		width : 60,
		align : 'center',
		sortable : true
	}]);
	
MasterCm.defaultSortable = true;
var GridPagingToolbar = new Ext.PagingToolbar({
	store:MasterStore,
	pageSize:PageSize,
	displayInfo:true
});

var MasterGrid = new Ext.grid.GridPanel({
	region: 'center',
	title: '入库单(退货单)',
	cm : MasterCm,
	sm : sm,
	store : MasterStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	tbar:['->','合计:','-',RcRttotalrp],
	bbar:GridPagingToolbar
});
/*
// 添加表格单击行事件
MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
	gTrType = MasterStore.getAt(rowIndex).get("TrType");
	var parref = MasterStore.getAt(rowIndex).get("RowId");
	DetailStore.setBaseParam('TrType',gTrType);
	DetailStore.setBaseParam('parref',parref);
	DetailStore.removeAll();
	DetailStore.load({params:{start:0,limit:99999}});
});
*/
///明细过滤
var SearchData=[['全部','ALL'],['名称','DESC'],['规格','SPEC'],['型号','MODEL'],['批号','BATCHNO']];
var SearchStore = new Ext.data.SimpleStore({
	fields: ['searchdesc', 'searchid'],
	data : SearchData
});
var SearchCombo = new Ext.form.ComboBox({
	store: SearchStore,
	mode: 'local', 
	anchor : '90%',
	emptyText:'',
	id:'SearchCombo',
	fieldLabel : '过滤方式',
	triggerAction:'all', //取消自动过滤
	displayField:'searchdesc',
	valueField : 'searchid'
});
Ext.getCmp("SearchCombo").setValue("ALL");
function SearchDetails(){
	var Searchtype=Ext.getCmp("SearchCombo").getValue(); //过滤方式
	var SearchText=Ext.getCmp("SearchText").getValue();  //过滤内容
	var SearchData=Searchtype+"^"+SearchText;
	var RcRtidstr="";
	var rowDataArr = MasterGrid.getSelectionModel().getSelections();
	if (Ext.isEmpty(rowDataArr)) {
		Msg.info("warning", "没有需要过滤的单据!");
		return;
	}
	for(i=0;i<rowDataArr.length;i++){
		var rowData=rowDataArr[i];
			var RcRtid=rowData.get('RowId');
			var type=rowData.get('TrType');
			if (RcRtidstr=="")
			 {RcRtidstr=RcRtid+"^"+type;}
			else
			 {RcRtidstr=RcRtidstr+","+RcRtid+"^"+type;}
		}
	DetailStore.setBaseParam('parstr',RcRtidstr);
	DetailStore.setBaseParam('SearchData',SearchData);
	DetailStore.removeAll();
	DetailStore.load({params:{start:0,limit:99999}});
 }
var SearchDetail = new Ext.Toolbar.Button({
	id : "SearchDetail",
	text : '过滤',
	tooltip : '过滤',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		SearchDetails();
	}
});
var SearchText = new Ext.form.TextField({
	id : 'SearchText',
	name : 'SearchText',
	anchor : '90%',
	listeners : {
		specialkey : function(field, e) {
			var keyCode=e.getKey();
			if ( keyCode== Ext.EventObject.ENTER) {
				SearchDetails();
			}
		}
	}
});
// 转移明细
// 访问路径
var DetailUrl =  'dhcstm.invmanageaction.csp?actiontype=queryItemAll';
// 通过AJAX方式调用后台数据
var dProxy = new Ext.data.HttpProxy({
	url : DetailUrl,
	method : "POST"
});
// 指定列参数
var dFields = ["RowId", "IncId", "IncCode", "IncDesc", "Spec",
			"Manf", "BatchNo", "ExpDate", "Qty", "Uom",
			"Rp", "Sp","RpAmt","SpAmt","InvNo",
			{name:'InvDate',type:'date',dateFormat:DateFormat}, "InvMoney", "SxNo","Model","InciCodeBatNo"];
// 支持分页显示的读取方式
var dReader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId",
	fields : dFields
});
// 数据集
var DetailStore = new Ext.data.GroupingStore({
	sortInfo:{field:'InciCodeBatNo',direction:'ASC'},
	//groupOnSort:true,
	groupField:'InciCodeBatNo',
	proxy : dProxy,
	reader : dReader
});
 Ext.ux.grid.GroupSummary.Calculations['TotalAmt'] = function(v, record, field){
        return Number(v) + Number(record.data[field]);
};
var DetailCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(),
	{
		header : "RowId",
		dataIndex : 'RowId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "物资Id",
		dataIndex : 'IncId',
		width : 80,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : '物资代码批号',
		dataIndex : 'InciCodeBatNo',
		width : 80,
		align : 'left',
		summaryRenderer: function(v, params, data){
                    return "小计：";
                },
		sortable : true
	}, {
		header : '物资代码',
		dataIndex : 'IncCode',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : '物资名称',
		dataIndex : 'IncDesc',
		width : 180,
		align : 'left',
		sortable : true
	}, {
		header : "规格",
		dataIndex : 'Spec',
		width : 80,
		align : 'left',
		sortable : true
	},{
		header : "型号",
		dataIndex : 'Model'
	}, {
		header : "厂商",
		dataIndex : 'Manf',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "批号",
		dataIndex : 'BatchNo',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "效期",
		dataIndex : 'ExpDate',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "数量",
		dataIndex : 'Qty',
		width : 80,
		align : 'right',
		summaryType: 'TotalAmt',
		sortable : true
	}, {
		header : "单位",
		dataIndex : 'Uom',
		width : 60,
		align : 'left',
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
		header : "进价金额",
		dataIndex : 'RpAmt',
		width : 80,
		align : 'right',
		hidden : true,
		summaryType: 'TotalAmt',
		sortable : true
	}, {
		header : "售价金额",
		dataIndex : 'SpAmt',
		width : 80,
		align : 'right',
		hidden : true,
		summaryType: 'TotalAmt',
		sortable : true
	}, {
		header : "发票号",
		dataIndex : 'InvNo',
		width : 100,
		align : 'left',
		sortable : true
	}, {
		header : "发票日期",
		dataIndex : 'InvDate',
		
		width : 100,
		align : 'center',
		sortable : true
	}, {
		header : "发票金额",
		dataIndex : 'InvMoney',
		width : 80,
		align : 'right',
		summaryType: 'TotalAmt',
		sortable : true
	}, {
		header : "随行单号",
		dataIndex : 'SxNo',
		width : 80,
		align : 'left',
		sortable : true
}]);
	
var GridDetailPagingToolbar = new Ext.PagingToolbar({
	store:DetailStore,
	pageSize:PageSize,
	displayInfo:true
});

var DetailGrid = new Ext.grid.EditorGridPanel({
	region: 'south',
	split: true,
	height: 240,
	minSize: 200,
	maxSize: 350,
	plugins: new Ext.ux.grid.GroupSummary(),
	title: '单据明细',
	cm : DetailCm,
	clicksToEdit:1,
	store : DetailStore,
	trackMouseOver : true,
	stripeRows : true,
	tbar:new Ext.Toolbar({items:["过滤方式:",SearchCombo,SearchText,SearchDetail]}),
	loadMask : true,
	view: new Ext.grid.GroupingView({
	    forceFit: true,
		headersDisabled :false,
		hideGroupedColumn :false,
        groupTextTpl: '{text} 名称：{[values.rs[0].data.IncDesc]} 规格：{[values.rs[0].data.Spec]}型号： {[values.rs[0].data.Model]} 批号： {[values.rs[0].data.BatchNo]}({[values.rs.length]} {[values.rs.length > 1 ? "条" : "条"]})'
    
	})
});

var HisListTab = new Ext.ux.FormPanel({
	title:'发票审核',
	tbar : [SearchBT,'-',ClearBT,'-',AuditBT,'-',AuditNoBT,'-',CancleAuditBT,'-',PrintBT],
	layout: 'column',
	items : [{
		xtype:'fieldset',
		title:"查询条件",		
		columnWidth : 1,
		layout:'column',
		style:'padding:5px 0px 0px 0px;',
		items : [{
			columnWidth: 0.34,
			xtype: 'fieldset',
			labelWidth: 60,
			defaults: {width: 220, border:false},
			autoHeight: true,
			border: false,
			items: [locField,Vendor,StartDate]
		},{
			columnWidth: 0.22,
			xtype: 'fieldset',
			labelWidth: 60,
			defaults: {width: 140, border:false},
			autoHeight: true,
			border: false,
			items: [INVNo,SXNo,EndDate]
		},{
			columnWidth: 0.22,
			xtype: 'fieldset',
			labelWidth: 60,	
			defaults: {width: 140, border:false},
			autoHeight: true,
			border: false,
			items: [InciDesc,INVNocombo,AuditFlag]
		},{
			columnWidth: 0.22,
			xtype: 'fieldset',
			labelWidth: 60,
			autoHeight: true,
			border: false,
			items: [RefuseReason]  ///RefuseReason
		}]
	}]
});
function AllowAudit(paramstr)
{
    	var ifallowedaudit=tkMakeServerCall("web.DHCSTM.DHCIngRcRtInv","IFAllowedAudit",paramstr);
        return ifallowedaudit;
}
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, MasterGrid, DetailGrid],
		renderTo : 'mainPanel'
	});
})