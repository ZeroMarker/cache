// /名称: 发票管理
// /编写者：gwj
// /编写日期: 2012.09.18
var invURL="dhcstm.invmanageaction.csp"
var gIncId="";
//var gTrType = "";			//当前选中单据的台帐类型(G\R)
var gGroupId=session['LOGON.GROUPID'];
var userId = session['LOGON.USERID'];
var CtLocId = session['LOGON.CTLOCID'];
var Userparams=gGroupId+"^"+CtLocId+"^"+userId;
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
// 打印按钮
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
				for(var i=0;i<selections.length;i++){
					var record=selections[i];
					var DhcIngr=record.get("RowId");
					var Type=record.get("TrType");
					if (Type=="R"){
					 PrintIngDret(DhcIngr);
					}else{
					PrintRec(DhcIngr);
					}
				}
			}
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

//入库单接收科室(ingr_reqloc_dr)
var RecReqLoc = new Ext.ux.LocComboBox({
	id : 'RecReqLoc',
	fieldLabel : '接收科室',
	anchor : '90%',
	defaultLoc : {}
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
// 保存按钮
var SaveBT = new Ext.Toolbar.Button({
	id : "SaveBT",
	text : '保存',
	tooltip : '点击保存',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		Save();
	}
});

// 已确认
var CompleteFlag = new Ext.form.Checkbox({
	fieldLabel : '已确认',
	id : 'CompleteFlag',
	name : 'CompleteFlag',
	anchor : '90%',
	width : 120,
	checked : false
});
// 确认
var CompleteBT = new Ext.Toolbar.Button({
	id : "CompleteBT",
	text : '确认',
	tooltip : '设置当前单据为<已确认>',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		if ((AllowAudit(Userparams))!=0){Msg.info("warning","您没有权限确认!");return;}
		Confirm();
		}
});
function Confirm(){
            var RcRtStr=""
			var rowDataArr = MasterGrid.getSelectionModel().getSelections();
			if (Ext.isEmpty(rowDataArr)) {
				Msg.info("warning", "请选择要确认的单据!");
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
			if(RcRtStr==""){Msg.info("warning", "没有可以确认的单据!");return}
			var url = "dhcstm.invauditaction.csp?actiontype=ConfirmStr";
			Ext.Ajax.request({
				url : url,
				params : {RcRtStr:RcRtStr,User:userId},
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
						Msg.info("success", "共"+total+"张单据,成功确认"+sucess+"单据!");
						Query();
					} 
				},
				scope : this
			});
}
// 取消确认
var CancleCompleteBT = new Ext.Toolbar.Button({
	id : "CancleCompleteBT",
	text : '取消确认',
	tooltip : '取消单据的<确认>标志',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		if ((AllowAudit(Userparams))!=0){Msg.info("warning","您没有权限取消!");return;}
		Ext.MessageBox.show({
			title : '提示',
			msg : '是否取消确认?',
			buttons : Ext.MessageBox.YESNO,
			fn: function(b,t,o){
				if (b=='yes'){
					CancleConfirm();
				}
			},
			icon : Ext.MessageBox.QUESTION
		});
	}
});
function CancleConfirm(){
			var rowData = MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "请选择要取消确认的单据!");
				return;
			}
			var RowId = rowData.get("RowId");
			var Type = rowData.get("TrType");
			var No = rowData.get("IngrNo");
			var url = "dhcstm.invauditaction.csp?actiontype=CancleConfirm";
			Ext.Ajax.request({
				url : url,
				params : {RowId:RowId,Type:Type},
				method : 'POST',
				waitMsg : '查询中...',
				success : function(result, request) {
					var jsonData = Ext.util.JSON
							.decode(result.responseText);
					if (jsonData.success == 'true') {
						Msg.info("success", "取消确认成功!");
						Query();
					}else{
					    var Ret=jsonData.info;
					    if (Ret==-2){
						    Msg.info("error", No+"单据还未确认!");
						}/*else if (Ret==-3){
						    Msg.info("error", No+"单据已审核,不能取消!");
						}*/else{
							Msg.info("error", "取消确认失败:"+Ret);
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
	MasterGrid.store.removeAll();
	MasterGrid.getView().refresh();
	DetailGrid.store.removeAll();
	DetailGrid.getView().refresh();
}

/**
 * 保存发票信息
 */
function Save() {
	var successNum = 0;
	var rowCount = DetailGrid.getStore().getCount();
	var mr = DetailStore.getModifiedRecords();
	var len=mr.length;
	if (rowCount<=0||len<=0){
	   Msg.info("waring","没有需要保存的明细!");
	}
	for (var i=0; i<len; i++){
		var rowData = mr[i];
		var RowId = rowData.get('RowId');
		var invNo = rowData.get("InvNo");
		var invAmt = rowData.get("InvMoney");
		var invDate = Ext.util.Format.date(rowData.get("InvDate"),ARG_DATEFORMAT);
		var sxNo=rowData.get("SxNo");
		var itmType= rowData.get("Type");
		var StrParam = itmType+"^"+RowId+"^"+invNo+"^"+invAmt+"^"+invDate
					+"^"+sxNo;
		var ret = tkMakeServerCall("web.DHCSTM.DHCINGdRecInv","UpdateINV",StrParam);
		if(ret != 0){
			var InciDesc = rowData.get('IncDesc');
			Msg.info("error", IncDesc+"发票信息保存失败!");
		}else if(++successNum == len){
			Msg.info("success","保存成功!");
			DetailStore.commitChanges();
	        DetailStore.reload();
		}
	}

}

//选择需要复制或者清除的信息
var CopyTypeData=[['发票号','1'],['随行单号','2'],['发票日期','3']];
	
		var CopyTypeStore = new Ext.data.SimpleStore({
			fields: ['typedesc', 'typeid'],
			data : CopyTypeData
		});

		var CopyTypeCombo = new Ext.form.ComboBox({
			store: CopyTypeStore,
			displayField:'typedesc',
			mode: 'local', 
			anchor : '90%',
			emptyText:'',
			id:'CopyTypeCombo',
			fieldLabel : '复制或清除内容',
			triggerAction:'all', //取消自动过滤
			valueField : 'typeid'
		});
		Ext.getCmp("CopyTypeCombo").setValue("1");

// 复制发票号随行单号
var CopyNo = new Ext.Toolbar.Button({
	id : "CopyINVNo",
	text : '复制单号',
	tooltip : '复制单号',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		Copy();
	}
});
function Copy(){
	var type=Ext.getCmp("CopyTypeCombo").getValue();
	var Rowcount=DetailGrid.getStore().getCount();
	//获取第一行的发票号
	var rowdata1=DetailGrid.getStore().getAt(0);
	var invno1=rowdata1.get("InvNo");
	var sxno1=rowdata1.get("SxNo");
	var InvDate1=rowdata1.get("InvDate");
	if ((type==1)&&((invno1=="")||(invno1==null))){
		Msg.info("warning","请先给第一行发票号赋值!");
		return false;
	}
	if ((type==2)&&((sxno1=="")||(sxno1==null))){
	Msg.info("warning","请先给第一行随行单号赋值!");
	return false;
	}
	if ((type==3)&&((InvDate1=="")||(InvDate1==null))){
	Msg.info("warning","请先给第一行发票日期赋值!");
	return false;
	} 
    for (i=1;i<Rowcount;i++)
      { 
        var Rowdata=DetailGrid.getStore().getAt(i);
        var invnotmp=Rowdata.get("InvNo");
        var sxnotmp=Rowdata.get("SxNo");
		var invdatetmp=Rowdata.get("InvDate");
        if ((type==1)&&((invnotmp=="")||(invnotmp==null))){
            Rowdata.set("InvNo",invno1);
            Rowdata.set("InvDate",InvDate1);
        }else if ((type==2)&&((sxnotmp=="")||(sxnotmp==null))){
            Rowdata.set("SxNo",sxno1);
        }else if ((type==3)&&((invdatetmp=="")||(invdatetmp==null))){
            Rowdata.set("InvDate",InvDate1);
        }else{return false;}
	  }
    }

// 清除发票号
var ClearNo = new Ext.Toolbar.Button({
	id : "ClearINVNo",
	text : '清除单号',
	tooltip : '清除单号',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		Clear();
	}
});

//清除发票信息
function Clear(){
	var type=Ext.getCmp("CopyTypeCombo").getValue();
	var Rowcount=DetailGrid.getStore().getCount();
    for (i=0;i<Rowcount;i++)
      { 
        var Rowdata=DetailGrid.getStore().getAt(i);
        if (type==1){
            Rowdata.set("InvNo","");
        }else if(type==2){
	        Rowdata.set("SxNo","");
	    }else if(type==3){
	        Rowdata.set("InvDate","");
	    }
	  }
    }

// 访问路径
var MasterUrl = invURL + '?actiontype=query';
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
			var inciid = gIncId;  //Ext.getCmp("InciDesc").getValue();
			var phaLoc=Ext.getCmp("locField").getValue();
			var RecReqLoc = Ext.getCmp('RecReqLoc').getValue();
			var CompleteFlag=(Ext.getCmp("CompleteFlag").getValue()?"Y":"N");  //已确认
			//科室id^开始日期^截止日期^供应商id^发票号^随行单号^物资id^发票状态^入库接收科室
			var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+vendor+'^'+invno+'^'+sxno+'^'+inciid+'^'+INVNoFlag+'^'+RecReqLoc+'^'+Userparams+'^'+CompleteFlag;
			//var Page=GridPagingToolbar.pageSize;
			ds.baseParams={start:0, limit:9999,strParam:ListParam};
			ds.removeAll();
		},
		load : function(store,records,options){
			if (records.length>0){
				MasterGrid.getSelectionModel().selectFirstRow();
			}
		}
	}
});
var sm =new Ext.grid.CheckboxSelectionModel({
		listeners:{
		selectionchange:function(ssm){
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
		hidden : true
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
		width : 60,
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
	bbar:GridPagingToolbar,
	viewConfig:{
		getRowClass : function(record,rowIndex,rowParams,store){ 
			var State=record.get("State");
			if(State=="1"){
				return 'classYellow';
			}					
		}
	}
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
// 转移明细
// 访问路径
var DetailUrl =  invURL + '?actiontype=queryItemAll';
// 通过AJAX方式调用后台数据
var dProxy = new Ext.data.HttpProxy({
	url : DetailUrl,
	method : "POST"
});
// 指定列参数
var dFields = ["RowId", "IncId", "IncCode", "IncDesc", "Spec",
			"Manf", "BatchNo", "ExpDate", "Qty", "Uom",
			"Rp", "Sp","RpAmt","SpAmt","InvNo",
			{name:'InvDate',type:'date',dateFormat:DateFormat}, "InvMoney", "SxNo","Type","InvCode"];
// 支持分页显示的读取方式
var dReader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "RowId",
	fields : dFields
});
// 数据集
var DetailStore = new Ext.data.Store({
	proxy : dProxy,
	reader : dReader
});

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
	}, {
		header : "厂商",
		dataIndex : 'Manf',
		width : 150,
		align : 'left',
		sortable : true
	}, {
		header : "批号",
		dataIndex : 'BatchNo',
		width : 100,
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
		sortable : true
	}, {
		header : "售价金额",
		dataIndex : 'SpAmt',
		width : 80,
		align : 'right',
		hidden : true,
		sortable : true
	}, {
		header : "发票号",
		dataIndex : 'InvNo',
		width : 100,
		align : 'left',
		sortable : true,
		editor:new Ext.form.TextField({
			listeners:{
				'blur':function(field){
					var invNo=field.getValue();
					var IngrRecord=MasterGrid.getSelectionModel().getSelected();
					var Ingr=IngrRecord.get('RowId');
					var flag=InvNoValidator(invNo,Ingr);
					if(flag==false){
						Msg.info("warning","发票号"+invNo+"存在于其他入库单中!");
						//field.setValue("");
					}
				}
			}
		})
	}, {
		header : "发票代码",
		dataIndex : 'InvCode',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "发票日期",
		dataIndex : 'InvDate',
		
		width : 100,
		align : 'center',
		sortable : true,
		renderer : Ext.util.Format.dateRenderer(DateFormat),
		editor:new Ext.ux.DateField({
		})
	}, {
		header : "发票金额",
		dataIndex : 'InvMoney',
		width : 80,
		align : 'right',
		sortable : true,
		editor:new Ext.form.NumberField({})
	}, {
		header : "随行单号",
		dataIndex : 'SxNo',
		width : 80,
		align : 'left',
		sortable : true,
		editor:new Ext.form.TextField({})
},{
		header : "Type",
		dataIndex : 'Type',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
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
	title: '单据明细',
	cm : DetailCm,
	clicksToEdit:1,
	store : DetailStore,
	trackMouseOver : true,
	stripeRows : true,
	tbar:new Ext.Toolbar({items:[CopyTypeCombo,CopyNo,ClearNo,"*根据下拉框选择的内容进行发票号或者随行单号的复制清除*"]}),
	//bbar:GridDetailPagingToolbar,
	loadMask : true
});

var HisListTab = new Ext.ux.FormPanel({
	title:'发票管理',
	tbar : [SearchBT, '-', ClearBT, '-', SaveBT,'-',CompleteBT,'-',CancleCompleteBT,'-',PrintBT],
	layout: 'column',
	items : [{
		xtype:'fieldset',
		title:"查询条件",
		columnWidth : 1,
		layout:'column',
		style:'padding:5px 0px 0px 0px;',
		defaults : {xtype: 'fieldset', border: false},
		labelWidth: 60,
		items : [{
			columnWidth: 0.2,
			items: [locField,Vendor]
		},{
			columnWidth: 0.2,
			items: [StartDate,EndDate]
		},{
			columnWidth: 0.2,
			items: [INVNo,SXNo]
		},{
			columnWidth: 0.2,
			items: [InciDesc,INVNocombo]
		},{
			columnWidth: 0.2,
			items: [RecReqLoc,CompleteFlag]
		}]
	}]
});
function AllowAudit(paramstr)
{
    	var ifallowedaudit=tkMakeServerCall("web.DHCSTM.DHCIngRcRtInv","IFAllowedAudit",paramstr);
        return ifallowedaudit;
}
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var CtLocId = session['LOGON.CTLOCID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border',
		items : [HisListTab, MasterGrid, DetailGrid],
		renderTo : 'mainPanel'
	});
})