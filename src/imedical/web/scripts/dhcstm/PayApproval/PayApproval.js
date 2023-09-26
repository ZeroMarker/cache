// 名称:付款审批
// 编写日期:2012-09-07
//=========================定义全局变量=================================

var gGroupId=session['LOGON.GROUPID'];
var UserId = session['LOGON.USERID'];
var URL = 'dhcstm.payapprovalaction.csp';

//保存参数值的object
var PayParamObj = GetAppPropValue('DHCSTPAYM');

var LocField = new Ext.ux.LocComboBox({
	id:'LocField',
	name:'LocField',
	fieldLabel:'科室',
	listWidth:210,
	groupId:gGroupId,
	anchor:'90%',
	childCombo : 'Vendor'
});

var ordlocField = new Ext.ux.LocComboBox({
	id:'ordlocField',
	fieldLabel:'医嘱接收科室',
	anchor:'90%',
	defaultLoc:{}
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '供应商...',
	params : {LocId : 'LocField'}
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	listWidth:120,
	allowBlank:true,
	fieldLabel:'起始日期',
	
	anchor:'90%',
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	listWidth:120,
	allowBlank:true,
	fieldLabel:'截止日期',
	
	anchor:'90%',
	value:new Date()
});

var totalrp = new Ext.form.TextField({
	fieldLabel : '金额合计',
	width:200,
	id : 'totalrp',
	name : 'totalrp',
	anchor : '100%',
	readOnly : true
});

function getTotalrp(){   
	var selarr = RecRetGrid.getSelectionModel().getSelections();
	var totalrp=0
	var totalqty=0
	for (var i = 0; i < selarr.length; i++) {
		var rowData = selarr[i];
		var Rp = rowData.get("RpAmt");
		var Qty= rowData.get("QtyAmt");
		totalrp=accAdd(totalrp,Rp)
		totalqty=accAdd(totalqty,Qty)
	}
	Ext.getCmp("totalrp").setValue("数量:"+totalqty+" 金额合计:"+totalrp);
}

var INVNnmber = new Ext.form.TextField({
	id:'INVNnmber',
	fieldLabel:'发票号',
	allowBlank:true,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true
});

var onlyRequest = new Ext.form.Checkbox({
	id: 'onlyRequest',
	fieldLabel:'仅申请计划',
	allowBlank:true
});

var InvoiceField = new Ext.form.Radio({ 
	id:'InvoiceField',
	name:'InvoiceCondition',
	checked:true,
	boxLabel:'有发票'  
});

var noInvoiceField = new Ext.form.Radio({  
	id:'noInvoiceField',
	name:'InvoiceCondition',
	boxLabel:'无发票'  
});

var allInvoiceField = new Ext.form.Radio({ 
	id:'allInvoiceField',
	name:'InvoiceCondition',
	boxLabel:'全部'
});

var hvField = new Ext.form.Radio({ 
	id:'hvField',
	name:'hvCondition',
	boxLabel:'仅高值'  
});

var noHvField = new Ext.form.Radio({  
	id:'noHvField',
	name:'hvCondition',
	boxLabel:'仅低值'  
});

var allHvField = new Ext.form.Radio({ 
	id:'allHvField',
	name:'hvCondition',
	boxLabel:'全部',
	checked:true
});
	
var Approvalflag = new Ext.form.Radio({ 
	id:'Approval',
	boxLabel:'已审批',
	name:'AuditCondition'
});

var noApprovalflag = new Ext.form.Radio({  
	id:'noApproval',
	name:'AuditCondition',
	checked:true,
	boxLabel:'未审批' 
});

var allApprovalflag = new Ext.form.Radio({ 
	id:'allApproval',
	name:'AuditCondition',
	boxLabel:'全部',
	checked:true
});
	
var IncludeRet = new Ext.form.Checkbox({
	id: 'IncludeRet',
	boxLabel:'包含退货',
	anchor:'100%',
	allowBlank:true
});

var IncludeGift = new Ext.form.Checkbox({
	id:'IncludeGift',
	fieldLabel:'包含赠送',
	anchor:'90%',
	allowBlank:true
});

var MonthStore = new Ext.data.SimpleStore({
	fields : ['RowId', 'Description'],
	data : [['1', '1月'],['2', '2月'],['3', '3月'],['4', '4月'],['5', '5月'],['6', '6月'],['7', '7月'],['8', '8月'],['9', '9月'],['10', '10月'],['11', '11月'],['12', '12月']]
});
var Month = new Ext.form.ComboBox({
	fieldLabel : '凭证月份',
	id : 'Month',
	name : 'Month',
	anchor : '90%',
	store : MonthStore,
	valueField : 'RowId',
	displayField : 'Description',
	mode : 'local',
	allowBlank : true,
	triggerAction : 'all',
	selectOnFocus : true,
	listWidth : 150,
	forceSelection : true
});

function Types(value){
    if (value=="G"){
	    return  '入库' ;
	}else if (value=="R"){
		return  '退货' ;
	}
}

var find = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
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
			
		var locId = Ext.getCmp('LocField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","请选择申请部门!");
			return false;
		}
		var ordloc= Ext.getCmp('ordlocField').getValue();
	
		var vendorId = Ext.getCmp('Vendor').getValue();	
		var IncludeRetflag = (Ext.getCmp('IncludeRet').getValue()==true?'Y':'N');
		var IncludeGiftflag = (Ext.getCmp('IncludeGift').getValue()==true?'Y':'N');	
		var INVNnmber=Ext.getCmp('INVNnmber').getValue();
		var Complete="";
		var Complete1 = Ext.getCmp('Approval').getValue();
		var Complete2 = Ext.getCmp('noApproval').getValue();
		complete = (Complete1==true?'Y':(Complete2==true?'N':''));
		var Inv="";
		var Inv1 = Ext.getCmp('InvoiceField').getValue();
		var Inv2 = Ext.getCmp('noInvoiceField').getValue();
		Inv = (Inv1==true?'Y':(Inv2==true?'N':''));
		var Hv="";
		var Hv1 = Ext.getCmp('hvField').getValue();
		var Hv2 = Ext.getCmp('noHvField').getValue();
		Hv = (Hv1==true?'Y':(Hv2==true?'N':''));
		var strParam = locId+"^"+startDate+"^"+endDate+"^"+vendorId+"^"+IncludeRetflag
			+"^"+IncludeGiftflag+"^"+Inv+"^"+complete+"^"+INVNnmber+"^"+Hv+"^"+ordloc;
		RecRetGridDs.setBaseParam('sort', 'RowId');
		RecRetGridDs.setBaseParam('dir', 'desc');
		RecRetGridDs.setBaseParam('strParam', strParam);
		RecRetGridDs.removeAll();
		RecRetGridDs.load({params:{start:0,limit:RecRetPagingToolbar.pageSize}});
	}
});

var clear = new Ext.Toolbar.Button({
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp('IncludeRet').setValue(false);
		Ext.getCmp('IncludeGift').setValue(false);
		Ext.getCmp('INVNnmber').setValue("");
		Ext.getCmp('Vendor').setValue("");	
		Ext.getCmp("VendorGrid").getStore().removeAll();	
		Ext.getCmp("RecRetGrid").getStore().removeAll();
		Ext.getCmp("RecRetGrid").getView().refresh();		
		Ext.getCmp("RecRetDetailGrid").getStore().removeAll();
		Ext.getCmp("RecRetDetailGrid").getView().refresh();
		VendorGridDs.load({params:{start:0,limit:0}})
		RecRetGridDs.load({params:{start:0,limit:0}})
		RecRetDetailGridDs.load({params:{start:0,limit:0}});
	}
});

var Approval = new Ext.Toolbar.Button({
	text:'审核通过',
	tooltip:'审核通过',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		saveApproval();
	}
});

function saveApproval(){
	if(RecRetGrid.getSelectionModel().getCount()==0){
		Msg.info("warning","请选择入库/退货单!");
		return false;
	}
	var RecRetSels = RecRetGrid.getSelectionModel().getSelections();
	var ListDetail="";
	for(var i=0,len=RecRetSels.length;i<len;i++){
		var rowData = RecRetSels[i];
		var IngrId=rowData.data["RowId"];
		var type=rowData.data["type"];
		var str=IngrId+"^"+type
		if(ListDetail==""){
				ListDetail=str;
			}
			else{
				ListDetail=ListDetail+RowDelim+str;
			}
	}
	Audio(ListDetail)
}

function Audio(ListDetail){
	if((ListDetail!="")&&(ListDetail!=null)){
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url: URL+'?actiontype=batapproval',
			params:{ListDetail:ListDetail,UserId:UserId},
			failure: function(result, request) {
				mask.hide();
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success","审核通过成功!");
					refreshRecList();
				}else{
						Msg.info("error","审批失败!");
				}
			},
			scope: this
		});
	}
}

var noApproval = new Ext.Toolbar.Button({
	text:'取消审核',
	tooltip:'取消审核',
	iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		CancleAppr();
	}
});

function CancleAppr(){
	var rowCount = Ext.getCmp('RecRetGrid').getStore().getCount();
	if(chkSm.getCount()==0){
		Msg.info("warning","请选择入库/退货单!");
		return false;
	}
	for(var i=0;i<rowCount;i++){
		var sm=RecRetGrid.getSelectionModel();
		if(sm.isSelected(i)==true){
			var rowData = Ext.getCmp('RecRetGrid').getStore().getAt(i);	
			CancelAudio(rowData);
		}
	}
}

function CancelAudio(rowData){
	var IngrId=rowData.data["RowId"];
	var IngrNo=rowData.data["gdNo"];
	var type=rowData.data["type"];
	if((IngrId!="")&&(IngrId!=null)){
		var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
		Ext.Ajax.request({
			url: URL+'?actiontype=noapproval&InGrId='+IngrId+"&type="+type,
			failure: function(result, request) {
				mask.hide();
				Msg.info("error","请检查网络连接!");
			},
			success: function(result, request) {
				var jsonData = Ext.util.JSON.decode( result.responseText );
				 mask.hide();
				if (jsonData.success=='true') {
					Msg.info("success","取消审核成功!");
					refreshRecList();
				}else{
					if(jsonData.info==1){
						Msg.info("warning",IngrNo+"该付款单未审批,不能取消审核!");
					}else if(jsonData.info==-100){
						Msg.info("error",IngrNo+"已经生成付款单不能取消审核!");
					}else if(jsonData.info==-101){
						Msg.info("error",IngrNo+"付款审批时间已生成月报数据!");
					}else{
						Msg.info("error","取消审核失败!");
					}
				}
			},
			scope: this
		});
	}
}

//20170207新增入库凭证
var ImportVoucher = new Ext.Toolbar.Button({
	text:'生成凭证',
    tooltip:'生成凭证',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		VoucherInsert();
	}
});

function ClearDataVoucher()
{
	Ext.getCmp("RecRetGrid").getStore().removeAll();
	Ext.getCmp("RecRetGrid").getView().refresh();
		
	Ext.getCmp("RecRetDetailGrid").getStore().removeAll();
	Ext.getCmp("RecRetDetailGrid").getView().refresh();
}
function VoucherInsert(){
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
	var locId = Ext.getCmp('LocField').getValue();
	if((locId=="")||(locId==null)){
		Msg.info("error","请选择申请部门!");
		return false;
	}
	var MonthId = Ext.getCmp('Month').getValue();
	if((MonthId=="")||(MonthId==null))
	{
		Msg.info("error","请选择月份!");
		return false;
	}	
	var recrpamt=0,recspamt=0,retrpamt=0,retspamt=0;
	var rowCount = RecRetGrid.getStore().getCount();
	var recdetailinfo="",retdetailinfo="";
	var vendorId="",count=0
	for(var i=0;i<rowCount;i++){
		if(chkSm.isSelected(i)==true){	
		  	var rowData = RecRetGridDs.getAt(i);	
			var IngrId=rowData.data["RowId"];
			var type=rowData.data["type"];
			var vendor=rowData.data["vendor"];
			if(count!=0&&vendorId!=vendor){
				Msg.info("error","请选择同一供应商单据!");
		        return false;
			}
			else{vendorId=vendor;}
			var rp=rowData.data["RpAmt"];
			var sp=rowData.data["SpAmt"];
			if(type=="G"){
				if(recdetailinfo=="") recdetailinfo=IngrId;
				else recdetailinfo=recdetailinfo+"^"+IngrId;
				recrpamt=parseFloat(recrpamt)+parseFloat(rp);
				recspamt=parseFloat(recspamt)+parseFloat(sp);
			}
			else{
				if(retdetailinfo=="") retdetailinfo=IngrId;
				else retdetailinfo=retdetailinfo+"^"+IngrId;
				retrpamt=parseFloat(retrpamt)+parseFloat(rp);
				retspamt=parseFloat(retspamt)+parseFloat(sp);
			}
			count=count+1;
		}
	}
	if(recdetailinfo==""&&retdetailinfo=="")
	{
		Msg.info("warning","请选择单据!");
		return false;
	}
	var maininfo=locId+"^"+MonthId+"^"+UserId+"^"+startDate+"^"+endDate+"^"+vendorId+"^"+recrpamt+"^"+recspamt+"^"+retrpamt+"^"+retspamt;
	var mask=ShowLoadMask(Ext.getBody(),"处理中请稍候...");
	Ext.Ajax.request({
		url: 'dhcstm.payvoucheraction.csp?actiontype=InsertVoucher',
		params:{maininfo:maininfo,recdetailinfo:recdetailinfo,retdetailinfo:retdetailinfo},
		failure: function(result, request) {
			mask.hide();
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			mask.hide();
			if (jsonData.success=='true') {
				Msg.info("success","生成凭证成功!");	
				RecRetGridDs.removeAll();
	            RecRetGridDs.reload();     
				var svcrowidstr=jsonData.info;
                var recsvcrowid=svcrowidstr.split("^")[0]
				var retsvcrowid=svcrowidstr.split("^")[1]
	            if(recsvcrowid!=""){PrintPayVoucher(recsvcrowid);}
				if(retsvcrowid!=""){PrintPayVoucher(retsvcrowid);}
			}
			else
			{
				if(jsonData.info=='-1')
				{
					Msg.info("error","请选择凭证信息");
				}
				else if(jsonData.info=='-2')
				{
					Msg.info("error","请选择要生成凭证的单据信息");
				}
				else if(jsonData.info=='-31')
				{
					Msg.info("error","单据类型不明确");
				}
				else if(jsonData.info=='-34')
				{
					Msg.info("error","凭证主表生成失败");
				}
				else if(jsonData.info=='-36')
				{
					Msg.info("error","存在已生成凭证的单据");
				}
				else if(jsonData.info=='-37')
				{
					Msg.info("error","凭证子表生成失败");
				}
				else{
					Msg.info("error","生成凭证失败("+jsonData.info+")!");
				}
			}
		},
		scope: this
	});
}

//=========================供应商主信息=================================
var sm = new Ext.grid.CheckboxSelectionModel(); 
//配置数据源
var VendorGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryvendor'});
var VendorFields=['vendor','vendorName','rpAmt','toPayAmt','payedAmt','toDashAmt'];
var VendorGridDs = new Ext.data.Store({
	proxy:VendorGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty : "results",
		id : "vendor",
		fields:VendorFields
	}),
	remoteSort:false,
	listeners:{
		'load':function(store,recs,o)   {	
			Ext.getCmp('RecRetGrid').getStore().removeAll();
			Ext.getCmp('RecRetGrid').getView().refresh();
			
			Ext.getCmp('RecRetDetailGrid').getStore().removeAll();
			Ext.getCmp('RecRetDetailGrid').getView().refresh();
		}   
	}
});
//模型
var VendorGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
		header:"vendorid",
		dataIndex:'vendor',
		width:50,
		align:'left',
		sortable:true,
		hidden : true
	},{
		header:"供应商",
		dataIndex:'vendorName',
		width:160,
		align:'left',
		sortable:true
	},{
		header:"入库进价金额",
		dataIndex:'rpAmt',
		width:120,
		align:'right',
		sortable:true
	},{
		header:"应付款金额",
		dataIndex:'toPayAmt',
		width:90,
		align:'right',
		sortable:true
	},{
		header:"已付款金额",
		dataIndex:'payedAmt',
		width:90,
		align:'right',
		sortable:true
	},{
		header:"冲帐金额",
		dataIndex:'toDashAmt',
		width:90,
		align:'right',
		sortable:true
	}
]);

//初始化默认排序功能
VendorGridCm.defaultSortable = true;

var VendorPagingToolbar = new Ext.PagingToolbar({
	store:VendorGridDs,
	pageSize:20,
	displayInfo:true
});

//表格
VendorGrid = new Ext.grid.EditorGridPanel({
	id:'VendorGrid',
	store:VendorGridDs,
	cm:VendorGridCm,
	trackMouseOver:true,
	height:233,
	sm : new Ext.grid.RowSelectionModel({
			singleSelect : true
	}),
	stripeRows:true,	
	loadMask:true,	
	bbar:[VendorPagingToolbar]
});
//=========================入库/退货单主信息=================================

//=========================入库/退货单明细=============================
//配置数据源
var RecRetGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=querygdrec',method:'GET'});
var RecRetFields=[
		{name:'RowId',mapping:'ingr'},
		{name:'gdNo',mapping:'gdNo'},
		{name:'RpAmt',mapping:'rpAmt'},
		{name:'SpAmt',mapping:'spAmt'},
		{name:'ApprvFlag',mapping:'payAllowed'},
		{name:'CreateUser',mapping:'createUserName'},
		{name:'CreateDate',mapping:'createDate'},
		{name:'AuditUser',mapping:'gdAuditUserName'},
		{name:'AuditDate',mapping:'gdDate'},
		{name:'PayedFlag',mapping:'payOverFlag'},
		'type','AllowUser','AllowDate','AllowTime','Scg',
		'ScgDesc','vendorName','ordlocdesc','QtyAmt',"vendor"
	];
	
var RecRetGridDs = new Ext.data.Store({
	proxy:RecRetGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results',
		id:'ingr'+'type',
		fields:RecRetFields
	}),
	listeners:{
		'load':function(store,recs,o) {
			Ext.getCmp('RecRetDetailGrid').getStore().removeAll();
			Ext.getCmp('RecRetDetailGrid').getView().refresh();
		}
	},
	remoteSort:true
});

var nm=new Ext.grid.RowNumberer();
var chkSm=new Ext.grid.CheckboxSelectionModel({
	listeners:{
		selectionchange:function(){
			getTotalrp()
		} 
	}
});
//模型
var RecRetGridCm = new Ext.grid.ColumnModel([nm,chkSm
	,{
		header:"RowId",
		dataIndex:'RowId',
		width:50,
		align:'left',
		sortable:true,
		hidden : true
	},{
		header:"供应商",
		dataIndex:'vendorName',
		width:300,
		align:'left',
		sortable:true
	},{
		header:"接收科室",
		dataIndex:'ordlocdesc',
		width:140,
		align:'left',
		sortable:true
	},{
		header:"单号",
		dataIndex:'gdNo',
		width:120,
		align:'left',
		sortable:true
	},{
		header:"类型",
		dataIndex:'type',
		width:40,
		align:'left',
		sortable:true,
		renderer:Types
	},{
		header:"类组",
		dataIndex:'ScgDesc',
		width:80,
		align:'left',
		sortable:true
	}
	,{
		header:"数量",
		dataIndex:'QtyAmt',
		width:70,
		align:'right',
		sortable:true
	},{
		header:"进价金额",
		dataIndex:'RpAmt',
		width:70,
		align:'right',
		sortable:true
	},{
		header:"审批标志",
		dataIndex:'ApprvFlag',
		width:70,
		align:'left',
		sortable:true,
		xtype : 'checkcolumn'
	},{
		header:"制单人",
		dataIndex:'CreateUser',
		width:60,
		align:'left',
		sortable:true
	},{
		header:"制单日期",
		dataIndex:'CreateDate',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"审核人",
		dataIndex:'AuditUser',
		width:60,
		align:'left',
		sortable:true
	},{
		header:"审核日期",
		dataIndex:'AuditDate',
		width:80,
		align:'left',
		sortable:true
	},{
		header:"付清标志",
		dataIndex:'PayedFlag',
		width:70,
		align:'left',
		sortable:true,
		xtype : 'checkcolumn'
	},{
		header:"审批人",
		dataIndex:'AllowUser',
		width:80,
		sortable:true
	},{
		header:"审批日期",
		dataIndex:'AllowDate',
		width:80,
		sortable:true
	},{
		header:"审批时间",
		dataIndex:'AllowTime',
		width:80,
		sortable:true
	},{
		header:"售价金额",
		dataIndex:'SpAmt',
		width:70,
		align:'right',
		sortable:true,
		hidden:true
	}
]);

var RecRetPagingToolbar = new Ext.PagingToolbar({
	store:RecRetGridDs,
	pageSize:20,
	displayInfo:true
});

//表格
var RecRetGrid = new Ext.grid.EditorGridPanel({
	region:'center',
	title:'入库/退货单',
	id:'RecRetGrid',
	store:RecRetGridDs,
	cm:RecRetGridCm,
	tbar:['->','合计:','-',totalrp],
	trackMouseOver:true,
	stripeRows:true,
	sm:chkSm,
	loadMask:true,
	clicksToEdit:1,
	deferRowRender:false,
	bbar:RecRetPagingToolbar,
	listeners:{
		'rowclick':function(grid,rowIndex,e){
			var rec=grid.getStore().getAt(rowIndex)
			parref=rec.get('RowId');
			type=rec.get('type');
			var pagesize=RecRetDetailToolbar.pageSize;
			RecRetDetailGridDs.setBaseParam('sort','RowId');
			RecRetDetailGridDs.setBaseParam('dir','desc');
			RecRetDetailGridDs.setBaseParam('InGrId',parref);
			RecRetDetailGridDs.setBaseParam('type',type);
			RecRetDetailGridDs.removeAll();
			RecRetDetailGridDs.load({params:{start:0,limit:pagesize}});
		}
	}
});
//=========================入库/退货单明细=============================
//配置数据源
var RecRetDetailGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryItem',method:'GET'});
var RecRetDetailFields=['RowId','IncId','IncCode','IncDesc','Spec','Manf','Qty','Uom','BatchNo','ExpDate','Rp','RpAmt','Sp','SpAmt','InvNo','InvDate','InvMoney','SxNo'];

var RecRetDetailGridDs = new Ext.data.Store({
	proxy:RecRetDetailGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results',
		id:'RowId',
		fields:RecRetDetailFields
	}),
	remoteSort:false
});
function toFixedTwo(val){
 	if(val==0||val==null&&val==undefined){
  	return '<div style="text-align: right">0.00</div>';      
 	}else{
 	 var values = Number(val).toFixed(2);
   	 }
 	return "<div style='text-align: right'>" + values + "</div>";
};
//模型
var RecRetDetailGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header : "rowid",
		dataIndex : 'RowId',
		width : 60,
		align : 'left',
		sortable : true,
		hidden : true,
		hideable : false
	},{
		header:"物资Id",
		dataIndex:'IncId',
		width:180,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"代码",
		dataIndex:'IncCode',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"名称",
		dataIndex:'IncDesc',
		width:200,
		align:'left',
		sortable:true
	},{
		header : '厂商',
		dataIndex : 'Manf',
		width : 170,
		align : 'left',
		sortable : true
	}, {
		header : "批号",
		dataIndex : 'BatchNo',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : "有效期",
		dataIndex : 'ExpDate',
		width : 90,
		align : 'center',
		sortable : true
	}, {
		header : '单位',
		dataIndex : 'Uom',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : "数量",
		dataIndex : 'Qty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header:"进价",
		dataIndex:'Rp',
		width:100,
		align:'right',
		sortable:true,
		renderer:toFixedTwo
	}, {
		header:"进价金额",
		dataIndex:'RpAmt',
		width:100,
		align:'right',
		sortable:true,
		renderer:toFixedTwo
	}, {
		header : "售价",
		dataIndex : 'Sp',
		width : 80,
		align : 'right',
		sortable : true,
		renderer:toFixedTwo
	}, {
		header:"售价金额",
		dataIndex:'SpAmt',
		width:100,
		align:'right',
		sortable:true,
		renderer:toFixedTwo
	},{
		header : "发票号",
		dataIndex : 'InvNo',
		width : 80,
		align : 'left',
		sortable : true
	},{
		header : "发票日期",
		dataIndex : 'InvDate',
		width : 80,
		align : 'left',
		sortable : true
	},{
		header : "发票金额",
		dataIndex : 'InvMoney',
		width : 80,
		align : 'right',
		sortable : true,
		renderer:toFixedTwo
	},{
		header : "随行单号",
		dataIndex : 'SxNo',
		width : 80,
		align : 'left',
		sortable : true
	}
]);

//初始化默认排序功能
RecRetDetailGridCm.defaultSortable = true;

var RecRetDetailToolbar = new Ext.PagingToolbar({
	store:RecRetDetailGridDs,
	pageSize:20,
	displayInfo:true
});

//表格
RecRetDetailGrid = new Ext.grid.EditorGridPanel({
	title:'入库/退货明细信息',
	region:'south',
	height:170,
	id:'RecRetDetailGrid',
	store:RecRetDetailGridDs,
	cm:RecRetDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel(),
	loadMask:true,
	clicksToEdit:1,
	split : true,
	bbar:RecRetDetailToolbar,
	viewConfig:{
		getRowClass : function(record,rowIndex,rowParams,store){ 
			var InvDate=record.get("InvDate");
			var dt=new Date().add(Date.DAY,-365).format(ARG_DATEFORMAT)
			if(dt>InvDate){
				return 'classRed';
			}
		}
	}
});

//-----------供应商与入库单间的联动-------------
VendorGrid.on('rowclick',function(grid,rowIndex,e){
	RecRetGridDs.removeAll();
	var selectedRow = VendorGridDs.data.items[rowIndex];
	vendorId = selectedRow.data["vendor"];

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
		
	var locId = Ext.getCmp('LocField').getValue();
	if((locId=="")||(locId==null)){
		Msg.info("error","请选择申请部门!");
		return false;
	}
	var IncludeRetflag = (Ext.getCmp('IncludeRet').getValue()==true?'Y':'N');
	var IncludeGiftflag = (Ext.getCmp('IncludeGift').getValue()==true?'Y':'N');	
	var Complete="";
	var Complete1 = Ext.getCmp('Approval').getValue();
	var Complete2 = Ext.getCmp('noApproval').getValue();
	complete = (Complete1==true?'Y':(Complete2==true?'N':''));
	var INVNnmber=Ext.getCmp('INVNnmber').getValue(); //发票号
	
	var Inv="";
	var Inv1 = Ext.getCmp('InvoiceField').getValue();
	var Inv2 = Ext.getCmp('noInvoiceField').getValue();
	Inv = (Inv1==true?'Y':(Inv2==true?'N':''));
	var strParam = locId+"^"+startDate+"^"+endDate+"^"+vendorId+"^"+IncludeRetflag
			+"^"+IncludeGiftflag+"^"+Inv+"^"+complete+"^"+INVNnmber;
	RecRetGridDs.setBaseParam('sort', 'RowId');
	RecRetGridDs.setBaseParam('dir', 'desc');
	RecRetGridDs.setBaseParam('strParam', strParam);
	RecRetGridDs.removeAll();
	RecRetGridDs.load({params:{start:0,limit:RecRetPagingToolbar.pageSize}});
});

function refreshRecList()
{
	RecRetGridDs.removeAll();
	RecRetGridDs.reload();
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var col5={
		columnWidth: 0.15,
		xtype: 'fieldset',
		defaultType: 'textfield',
		autoHeight: true,
		border: false,
		items:[IncludeRet,IncludeGift]
	};
	
	var MainPanel = new Ext.ux.FormPanel({
		title:'付款审批',
		tbar:[find,'-',ImportVoucher,'-',Approval,'-',noApproval,'-',clear],
		layout: 'fit',
		items : [{
			xtype:'fieldset',
			title:'查询条件',
			autoHeight:true,
			layout:'column',
			items:[{layout:'form',columnWidth:'0.25',items:[LocField,Vendor,INVNnmber]},  ///,IncludeGift]},
					{layout:'form',columnWidth:'0.25',items:[startDateField,endDateField,ordlocField],labelWidth:100},
					{layout:'form',columnWidth:'0.1',labelWidth:15,items:[allApprovalflag,Approvalflag,noApprovalflag]},
					{layout:'form',columnWidth:'0.1',labelWidth:15,items:[allInvoiceField,InvoiceField,noInvoiceField]},
					{layout:'form',columnWidth:'0.1',labelWidth:15,items:[allHvField,hvField,noHvField]},
					{layout:'form',columnWidth:'0.2',items:[IncludeRet,Month]}
				]
		}]
	});

	var VendorPanel = new Ext.Panel({
		title:'供应商信息',
		region:'west',
		width:590,
		collapsible: true,
		split: true,
		minSize: 0,
		maxSize: 500,
		layout:'fit',
		items:[VendorGrid]
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[MainPanel,RecRetGrid,RecRetDetailGrid],
		renderTo:'mainPanel'
	});
});
