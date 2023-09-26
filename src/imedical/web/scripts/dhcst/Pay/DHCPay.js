///付款管理-付款单制单
var payRowId="";
var URL="dhcst.payaction.csp";
// /是否需要审批参数
var ApprovalFlag;
var gParam;
var gGroupId=session['LOGON.GROUPID'];
//付款单号
var payNoField = new Ext.form.TextField({
	id:"payNoField",
	fieldLabel:"付款单号",
	allowBlank:true,
	width:120,
	readOnly :true,
	//listWidth:120,
	//emptyText:"付款单号...",
	anchor:'90%',
	readOnly:true,
	selectOnFocus:true
});	
// 打印付款单按钮
var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '打印',
	tooltip : '点击打印付款单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
	PrintPay(payRowId);
   }
});	

var payDetailCM=new Ext.grid.ColumnModel([
  {
	  header:'付款明细RowId',
	  dataIndex:"payi",
	  hidden:true
  },
  {
	  header:"入库(退货)RowId",
	  dataIndex:"pointer",
	  hidden:true
  },
  {
	  header:"类型(入库/退货)",
	  dataIndex:"TransType",
	  width:100,
	  align:"left"
  },
  {
	  header:"inclb",
	  dataIndex:"inclb",
	  width:100,
	  align:"left",
	  hidden:true
  },
  {
	  header:"药品RowId",
	  dataIndex:"INCI",
	  hidden:true
  },
  {
	  header:"药品代码",
	  dataIndex:"inciCode",
	  width:120,
	  align:"left"
  },
  {
	  header:"药品名称",
	  dataIndex:"inciDesc",
	  width:250,
	  align:"left"
  },
  {
	  header:"规格",
	  dataIndex:"spec",
	  width:100,
	  align:"left"
  },
  {
	  header:"厂商",
	  dataIndex:"manf",
	  width:160,
	  align:"left"
  },
  {
	  header:"数量",
	  dataIndex:"qty",
	  width:100,
	  align:"right"
  },		  
  {
	  header:"单位",
	  dataIndex:"uomDesc",
	  width:100,
	  align:"left"
  },
    {
	  header:"入库金额",
	  dataIndex:"recAmt",
	  width:100,
	  align:"right"
  },	
 {
	  header:"付款金额",
	  dataIndex:"payAmt",
	  width:100,
	  align:"right"
  },	 
 {
	  header:"付款累计金额",
	  dataIndex:"sumPayAmt",
	  width:100,
	  align:"right"
  },	   
  {
	  header:"进价",
	  dataIndex:"rp",
	  width:100,
	  align:"right"
  },
  {
	  header:"进价金额",
	  dataIndex:"rpAmt",
	  width:100,
	  align:"right"
  },
  
    {
	  header:"售价",
	  dataIndex:"sp",
	  width:100,
	  align:"right"
  },
    {
	  header:"售价金额",
	  dataIndex:"spAmt",
	  width:100,
	  align:"right"
  },  
  {
	  header:"发票号",
	  dataIndex:"invNo",
	  width:100,
	  align:"center"
  },
  {
	  header:"发票日期",
	  dataIndex:"invDate",
	  type:"number",
	  width:100,
	  align:"center"
  },
{
	  header:"单号(入库/退货)",
	  dataIndex:"grNo",
	  width:120,
	  align:"left"
  },
  {
	  header:"随行单号",
	  dataIndex:"insxNo",
	  width:100,
	  align:"left"
  },
  {
	  header:"批号",
	  dataIndex:"batNo",
	  width:100,
	  align:"left"
  },
  {
	  header:"效期",
	  dataIndex:"expDate",
	  width:100,
	  align:"left"
  }
  ]);	

// 采购科室
var PhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '采购科室',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor : '90%',
	groupId:gGroupId
});

// 供应商
var Vendor = new Ext.ux.VendorComboBox({
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%'
});
			
//毒麻标志
var PoisonFlag = new Ext.form.Checkbox({
	fieldLabel : '毒麻标志',
	id : 'PoisonFlag',
	name : 'PoisonFlag',
	anchor : '90%',
	checked : false
});


//完成标志
var completedFlag = new Ext.form.Checkbox({
	fieldLabel : '完成标志',
	id : 'completedFlag',
	name : 'completedFlag',
	anchor : '90%',
	checked : false,
	disabled:true,
	listeners:{
	'check':function(a,b){
		//alert(a.getValue());
		
	}
	}
});

//制单人
var CreatUsr =new Ext.form.TextField({
	fieldLabel : '制单人',
	id : 'CreatUsr',
	disabled :true,
	name : 'CreatUsr',
	anchor : '90%'
});

//制单日期
var CreatDate =new Ext.form.TextField ({
	fieldLabel : '制单日期',
	id : 'CreatDate',
	name : 'CreatDate',
	disabled :true,
	anchor : '90%'
});

//制单时间
var CreatTim =new Ext.form.TextField({
	fieldLabel : '制单时间',
	id : 'CreatTim',
	name : 'CreatTim',
	anchor : '90%',
	disabled :true
});

//采购确认标志
var ack1lag = new Ext.form.Checkbox({
	fieldLabel : '采购确认',
	id : 'ack1lag',
	name : 'ack1lag',
	anchor : '90%',
	disabled:true,
	checked : false
});
//采购确认人
var Ack1Usr =new Ext.form.TextField({
	fieldLabel : '采购确认人',
	id : 'Ack1Usr',
	name : 'Ack1Usr',
	disabled:true,
	anchor : '90%'
});	

//采购确认日期
var Ack1Date =new Ext.ux.DateField({
	fieldLabel : '采购确认日期',
	id : 'Ack1Date',
	name : 'Ack1Date',
	disabled:true,
	anchor : '90%'
});	

//会计确认日期
var Ack2Date =new Ext.ux.DateField({
	fieldLabel : '会计确认日期',
	id : 'Ack2Date',
	name : 'Ack2Date',
	disabled:true,
	anchor : '90%'
});	



//会计确认标志
var ack2lag = new Ext.form.Checkbox({
	fieldLabel : '会计确认',
	id : 'ack2lag',
	name : 'ack2lag',
	anchor : '90%',
	checked : false,
	disabled:true
});

//会计确认人
var Ack2Usr =new Ext.form.TextField({
	fieldLabel : '会计确认人',
	id : 'Ack2Usr',
	name : 'Ack2Usr',
	anchor : '90%',
	disabled:true
});	


//入库单付款

// 查询按钮- 查找付款单
var createFromRec = new Ext.Toolbar.Button({
	text : '入库/退货单付款',
	tooltip : '入库/退货单付款',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		CreateFromRec();
	}
});



// 查询按钮- 查找付款单
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
	text : '清屏',
	tooltip : '点击清屏',
	width : 70,
	height : 30,
	iconCls : 'page_clearscreen',
	handler : function() {
		clearData();
	}
});


// 取消完成按钮(需要获得授权)
var CancleCompleteBT = new Ext.Toolbar.Button({
	id : "CancleCompleteBT",
	text : '取消完成',
	tooltip : '点击取消完成',
	width : 70,
	height : 30,
	iconCls : 'page_gear',
	handler : function() {
		CancleComplete();
	}
});


// 删除明细按钮(需要获得授权)
var DeletePayItmBT = new Ext.Toolbar.Button({
	id : "DeletePayItmBT",
	text : '删除一条明细记录',
	tooltip : '',
	width : 70,
	height : 30,
	iconCls : 'page_delete',
	handler : function() {
		DeletePayItm();
	}
});
var DeletePayBT = new Ext.Toolbar.Button({
	id : "DeletePayBT",
	text : '删除',
	tooltip : '',
	width : 70,
	height : 30,
	iconCls : 'page_delete',
	handler : function() {
		DeletePay();
	}
});
// 保存
var SetCompleteBT = new Ext.Toolbar.Button({
	id : "SavePay",
	text : '付款单完成',
	tooltip : '',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		SetComplete();
	}
});


var HisListTab = new Ext.form.FormPanel({
	labelWidth : 30,
	labelAlign : 'right',
	frame : true,
	autoScroll : true,
	bodyStyle : 'padding:5px;',

    //tbar : [SearchBT, '-', ClearBT,'-','-', SetCompleteBT,'-',CancleCompleteBT,'-',createFromRec],
		
	layout: 'column',    // Specifies that the items will now be arranged in columns
	items : [{ 				
		columnWidth: 0.25,
		xtype: 'fieldset',
		labelWidth: 60,	
		defaults: {width: 220, border:false},    // Default config options for child items
		defaultType: 'textfield',
		autoHeight: true,
		//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		border: false,
		items: [PhaLoc,payNoField,ack1lag]		
		},{ 				
		columnWidth: 0.2,
		xtype: 'fieldset',
		labelWidth: 60,	
		defaults: {width: 140, border:false},    // Default config options for child items
		defaultType: 'textfield',
		autoHeight: true,
		//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		border: false,
		items: [Vendor,CreatUsr,Ack1Usr]		
		},{ 				
		columnWidth: 0.2,
		xtype: 'fieldset',
		labelWidth: 60,	
		defaults: {width: 140, border:false},    // Default config options for child items
		defaultType: 'textfield',
		autoHeight: true,
		//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		border: false,
		items: [CreatDate,ack2lag]		
		},{ 				
		columnWidth: 0.2,
		xtype: 'fieldset',
		labelWidth: 60,	
		defaults: {width: 140, border:false},    // Default config options for child items
		defaultType: 'textfield',
		autoHeight: true,
		//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		border: false,
		items: [CreatTim,Ack2Usr]
		},{ 				
		columnWidth: 0.15,
		xtype: 'fieldset',
		labelWidth: 60,	
		defaults: {width: 140, border:false},    // Default config options for child items
		defaultType: 'textfield',
		autoHeight: true,
		//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		border: false,
	    items: [PoisonFlag,completedFlag]			
	}]
	
});		


//
var PayDetailUrl = URL	+ '?actiontype=queryItem';
var payDetailProxy= new Ext.data.HttpProxy({
			url : PayDetailUrl,
			method : "POST"
});
// 指定列参数
//var fields = ["RowId", "IngrNo", "RpAmt", "ApprvFlag", "CreateUser", "CreateDate","AuditUser", "AuditDate","PayedFlag", "type"];

var payItmFields = ["payi","pointer","TransType","inclb","INCI","inciCode","inciDesc","spec","manf","qty","uomDesc","recAmt","payAmt","sumPayAmt","rp","rpAmt","sp","spAmt","invNo","invDate","grNo","insxNo","batNo",{name:'expDate',mapping:"ExpDate"}]

// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "payi",
	fields : payItmFields
});
	
		
var payDetailStore=new Ext.data.Store({
	proxy : payDetailProxy,
	reader : reader,
	listeners:{
		'beforeload':function(store)
			{	
				var psize=payDetailGridPagingToolbar.pageSize;			
				store.baseParams={start:0,limit:psize,parref:payRowId}
				}			
	}	
})

	
var payDetailGridPagingToolbar = new Ext.PagingToolbar({
	store:payDetailStore,
	pageSize:PageSize,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录"
});

//付款单明细 Grid
var PayDetailGrid = new Ext.grid.GridPanel({
	id:'PayDetailGrid',
	height : 170,
	cm : payDetailCM, 
	sm : new Ext.grid.RowSelectionModel({
				singleSelect : true
			}),
	store : payDetailStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	bbar:[payDetailGridPagingToolbar]
});


// /描述: 付款单制单
// /编写者：gwj
// /编写日期: 2012.09.20
//===========模块主页面=============================================
Ext.onReady(function(){
 
	// 登录设置默认值
	SetLogInDept(GetGroupDeptStore, "PhaLoc");
	
	//取是否需要审批参数
	//GetParam();


	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//var gUserId = session['LOGON.USERID'];	

	// 页面布局
	var mainPanel = new Ext.Viewport({
		layout : 'border',  // create instance immediately
		items : [{
	            region: 'north',
	            title:'付款单制单',
				frame : true,
				//autoScroll : true,	            
 	            tbar : [SearchBT, '-', ClearBT,'-', SetCompleteBT,'-',CancleCompleteBT,'-',createFromRec,'-',PrintBT,'-',DeletePayBT],
	            height: 210, // give north and south regions a height
	            //layout: 'fit', // specify layout manager for items
	           // bodyStyle : 'padding:5px;',
	            items:{
	            	xtype : 'fieldset',
	            	title:'付款主信息', 
	            	autoHeight:true,
	            	layout:'column',
            		items:[{
	            			xtype : 'fieldset', 				
							columnWidth: 0.25,	
							defaults: {width: 220, border:false},
							border: false,
	            	        labelWidth:60,
							labelAlign:'right',	
							items: [PhaLoc,Vendor,PoisonFlag]		
						},{ 				
							columnWidth: 0.2,
							xtype : 'fieldset',
							defaults: {width: 140, border:false},   
							border: false,
	            	        labelWidth:70,
							labelAlign:'right',
							items: [payNoField,CreatUsr,completedFlag]		
						},{ 				
							columnWidth: 0.15,
							xtype : 'fieldset',
							defaults: {width: 140, border:false},    // Default config options for child items
							border: false,
	            	        labelWidth:60,
							labelAlign:'right',
							items: [CreatDate,CreatTim]		
						},{ 				
							columnWidth: 0.1,
							xtype : 'fieldset',
							defaults: {width: 140, border:false},    // Default config options for child items
							//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
							border: false,
	            	        labelWidth:70,
							labelAlign:'right',
							items: [ack1lag,ack2lag]
						},{ 				
							columnWidth: 0.15,
							xtype : 'fieldset',
							defaults: {width: 140, border:false},    // Default config options for child items
							//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
							border: false,
	            	        labelWidth:80,
							labelAlign:'right',
							items: [Ack1Usr,Ack2Usr]
						}] 
	            }
	        }
	        , {
	            region: 'center',
	            title: '付款明细',			               
	            layout: 'fit', // specify layout manager for items
	            items: PayDetailGrid,
	            tbar:[DeletePayItmBT]
	        } 
		],
		renderTo:"mainPanel"
		
	});
	
});

/**取参数设定*/
function GetParam(){
	var ssacode="DHCSTPAY"
	var ssapcode="APPROVALFLAG"
	var pftype="D"
	var url='dhcst.dhcpayaction.CSP?actiontype=GetParam&SSACode='+ssacode+'&SSAPCode='+ssapcode+'&PFType='+pftype;
	Ext.Ajax.request({
					url : url,
					method : 'POST',
	waitMsg : '更新中...',
	success : function(result, request) {
		var s=result.responseText;
		s=s.replace(/\r/g,"")
	s=s.replace(/\n/g,"")
	
	gParam=s.split('^');
	
	//scope : this
		}
	});
}
	
///查找入库记录制作付款单
function CreateFromRec()
{
 	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "请选择采购科室!");
		return;
	}
	PayFromRec(setPayInfo);
}

function setPayInfo(xpayRowId)
{
 //调出付款单信息
	 //1.主信息
	Ext.Ajax.request({
	    url: 'dhcst.payqueryaction.csp?actiontype=payMainInfo&pay='+xpayRowId,
	    success: function(result, request)
	    {
	    	//alert(result.responseText);
			var jsonData = Ext.util.JSON.decode(result.responseText );
			//alert(jsonData);		
			
			if (jsonData.results>0) 
			{
				var payId=jsonData.rows[0]['PAY_Rowid'];
				var vendor=jsonData.rows[0]['PAY_APCVM_DR'];
				var vendorName=jsonData.rows[0]['vendorName'];
				var payLoc =jsonData.rows[0]['PAY_CTLOC_DR'];
				var payDate=jsonData.rows[0]['PAY_Date'];
				var payTime=jsonData.rows[0]['PAY_Time'];
				var payUser=jsonData.rows[0]['PAY_SSUSR_DR'];
				var payUserName=jsonData.rows[0]['userName'];	
				var payNo=jsonData.rows[0]['PAY_No'];
				var poisonFlag=jsonData.rows[0]['PAY_PoisonFlag']=='Y'?true:false;
				Ext.getCmp('PoisonFlag').setValue(poisonFlag);
				
				var completedFlag=jsonData.rows[0]['PAY_Completed'];
				//alert(completedFlag);
				var ack1Flag=jsonData.rows[0]['PAY_Ack1']=='Y'?true:false;
				var ack1Date=jsonData.rows[0]['PAY_Date_Ack1'];
				var ack1User=jsonData.rows[0]['ack1UserName'];
				
				var ack2Flag=jsonData.rows[0]['PAY_Ack2']=='Y'?true:false;
				var ack2Date=jsonData.rows[0]['PAY_Date_Ack2'];
				var ack2User=jsonData.rows[0]['ack2UserName'];					
				var chqNo=jsonData.rows[0]['PAY_CheckNo'];
				var chqAmt=jsonData.rows[0]['PAY_CheckAmt'];
				var chqDate=jsonData.rows[0]['PAY_CheckDate'];

			 	Ext.getCmp('PhaLoc').setValue(payLoc);				 	
			 	//refill(Ext.getCmp('Vendor').store, vendorName,"Vendor");
			 	
			 	Ext.getCmp('Vendor').setRawValue(vendorName);
			 	Ext.getCmp('Vendor').store.reload();
			 	
			 	Ext.getCmp('payNoField').setValue(payNo);
			 	
			 	Ext.getCmp('CreatDate').setValue(payDate);
			 	Ext.getCmp('CreatTim').setValue(payTime);
			 	Ext.getCmp('CreatUsr').setValue(payUserName);				 	
				Ext.getCmp('ack1lag').setValue(ack1Flag);
				Ext.getCmp('Ack1Usr').setValue(ack1User);
				Ext.getCmp('Ack1Date').setValue(ack1Date);
				
			 	Ext.getCmp('ack2lag').setValue(ack2Flag);			 				 	
			 	Ext.getCmp('Ack2Usr').setValue(ack2User);				 	
			 	Ext.getCmp('Ack2Date').setValue(ack2Date);			 	
			 	
			 	if (completedFlag=="Y"){
			 		//alert(completedFlag);
			 		Ext.getCmp('completedFlag').setValue(true);
			 		Ext.getCmp('CancleCompleteBT').setDisabled(false);	
			 	}else{
				 	Ext.getCmp('completedFlag').setValue(false);
			 		Ext.getCmp('CancleCompleteBT').setDisabled(true);
			 	}
				PayDetailGrid.store.load();
			}
	    },
	    failure: function(){Msg.info("error","失败!");}

	});

}
/**
* 查询方法
*/
function Query() {	
	var phaLoc = Ext.getCmp("PhaLoc").getValue();
	if (phaLoc == null || phaLoc.length <= 0) {
		Msg.info("warning", "请选择采购科室!");
		return;
	}
	var completed="N"; //未完成的
	PaySearch(setPayInfo);	
}

/**
 * 完成付款单
 */

function SetComplete() {	
	if (payRowId== null || payRowId.length <= 0) {
		Msg.info("warning", "没有需要完成的付款单!");
		return;
	}
	var url = URL+ "?actiontype=SetComp&payid="+ payRowId ;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '更新中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON
					.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 完成单据
				Msg.info("success", "成功!");								
				setPayInfo(payRowId);

			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "操作失败,付款单Id为空或付款单不存在!");
				}else if(Ret==-2){
					Msg.info("error", "付款单已经完成!");
				}else {
					Msg.info("error", "操作失败!");
				}
				
			}
		},
		scope : this
	});
}


/**
 * 取消完成入库单
 */
function CancleComplete() {
	
	//var payNo = Ext.getCmp("payNoField").getValue();			
	//if (payNo == null || payNo.length <= 0) {
	//	Msg.info("warning", "没有需要完成的付款单!");
	//	return;
	//}
	//alert(payRowId);
	if (payRowId== null || payRowId.length <= 0) {
		Msg.info("warning", "没有需要取消完成的付款单!");
		return;
	}
	var url = URL+ "?actiontype=CnlComp&payid="+ payRowId ;
	//alert(url);
	
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '更新中...',
		success : function(result, request) {
			//alert(result.responseText);
			var jsonData = Ext.util.JSON.decode(result.responseText);
			//alert(jsonData.info);
			if (jsonData.success == 'true') {
				// 完成单据
				Msg.info("success", "成功!");			
				setPayInfo(payRowId);
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "操作失败,付款单Id为空或付款单不存在!");
				}else if(Ret==-2){
					Msg.info("error", "付款单已经确认!");
				}else {
					Msg.info("error", "操作失败!");
				}
				
			}
		},
		failure:function()
		{Msg.info("error","失败!");},
		
		scope : this
	});
}
	
/*删除付款明细记录*/
function DeletePayItm()
{

	var rec=this.PayDetailGrid.getSelectionModel().getSelected();
	if (rec==undefined)	{return;}
	var payi=rec.get('payi') ;
	if (payi=="") return;
	var compFlag=Ext.getCmp("completedFlag").getValue();
	if(compFlag==true){
		Msg.info("warning","付款单已经完成,不能删除明细!");
		return;
	}
	var ack1Flag=Ext.getCmp("ack1lag").getValue();
	if(ack1Flag==true){
		Msg.info("warning","付款单已采购确认,不能删除明细!");
		return;
	}
	var ack2Flag=Ext.getCmp("ack2lag").getValue();
	if(ack2Flag==true){
		Msg.info("warning","付款单已会计确认,不能删除明细!");
		return;
	}
	
	Ext.Msg.show({
		title:'提示',
		msg:'是否确定删除？',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='no')	{return;}
			else {					
				Ext.Ajax.request({
					url:URL+'?actiontype=DelPayItm&RowId='+payi,
					method:"POST",
					success:function(result,request)
					{
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true')
						{		
							Msg.info("success", "删除成功!");
							this.PayDetailGrid.store.reload();	
						}else if (jsonData.success=='false')
						{
							if (jsonData.info=='-99') 	Msg.info("error","加锁失败！")
							
						    if (jsonData.info=='-100') 	Msg.info("error","不允许删除！")
						}
					}
				
				})
					
				
			}
		}
	});
	
	
}
//删除付款单
function DeletePay(){
	if (payRowId=="") return;
	var compFlag=Ext.getCmp("completedFlag").getValue();
	if(compFlag==true){
		Msg.info("warning","付款单已经完成,不能删除!");
		return;
	}
	var ack1Flag=Ext.getCmp("ack1lag").getValue();
	if(ack1Flag==true){
		Msg.info("warning","付款单已采购确认,不能删除!");
		return;
	}
	var ack2Flag=Ext.getCmp("ack2lag").getValue();
	if(ack2Flag==true){
		Msg.info("warning","付款单已会计确认,不能删除!");
		return;
	}
	
	Ext.Msg.show({
		title:'提示',
		msg:'是否确定删除？',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='no') {return;}
			else {
				var mytrn=tkMakeServerCall("web.DHCSTM.DHCPay","Delete",payRowId);
				if(mytrn==0){Msg.info("sucess","删除成功!");clearData();}
				else{Msg.info("error","删除失败!");}
			}
		}
	});
}


/**
 * 清空方法
 */
function clearData() {
	
	payRowId="";
	//Ext.getCmp("PhaLoc").setValue("");
	Ext.getCmp("Vendor").setValue("");
	Ext.getCmp("payNoField").setValue("");	
	Ext.getCmp("CreatUsr").setValue("");	
	Ext.getCmp("CreatDate").setValue("");	
	Ext.getCmp("CreatTim").setValue("");			 
	Ext.getCmp('ack1lag').setValue("");
	Ext.getCmp('Ack1Usr').setValue("");
	Ext.getCmp('Ack1Date').setValue("");	
 	Ext.getCmp('ack2lag').setValue("");			 				 	
 	Ext.getCmp('Ack2Usr').setValue("");				 	
 	Ext.getCmp('Ack2Date').setValue("");			 	 
 	Ext.getCmp('PoisonFlag').setValue("");
 	Ext.getCmp('Vendor').setValue("");
 	Ext.getCmp('completedFlag').setValue("");		
	payDetailStore.removeAll();
	payRowId=0;
	payDetailStore.load({params:{start:0,limit:0}})
	PayDetailGrid.getView().refresh();	
}		
function rendorPoFlag(value){
    return value=='Y'? '是': '否';
}

function rendorCmpFlag(value){
    return value=='Y'? '完成': '未完成';
}


	