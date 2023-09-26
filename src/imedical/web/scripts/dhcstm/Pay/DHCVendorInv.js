// 名称:入库单发票号输入前组合
// 编写日期:2014-09-10
var invRowId="";
var URL="dhcstm.vendorinvaction.csp"
var gGroupId=session['LOGON.GROUPID'];
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];

var invNoField = new Ext.form.TextField({
	id:"invNoField",
	fieldLabel:"发票组合单号",
	allowBlank:true,
	readOnly :true,
	anchor:'90%',
	readOnly:true,
	selectOnFocus:true
});		

var PrintBT = new Ext.Toolbar.Button({
	id : "PrintBT",
	text : '打印',
	tooltip : '点击打印',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		Printinv(invRowId);
	}
});	

var PhaLoc = new Ext.ux.LocComboBox({
	fieldLabel : '科室',
	id : 'PhaLoc',
	name : 'PhaLoc',
	anchor:'90%',
	emptyText : '入库退货科室...',
	groupId:gGroupId,
	stkGrpId : 'StkGrpType',
	childCombo : 'Vendor'
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : '供应商...',
	params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'}
});

//完成标志
var completedFlag = new Ext.form.Checkbox({
	fieldLabel : '完成标志',
	id : 'completedFlag',
	name : 'completedFlag',
	anchor : '90%',
	checked : false,
	disabled:true
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

// 类组
var StkGrpType=new Ext.ux.StkGrpComboBox({ 
	id : 'StkGrpType',
	name : 'StkGrpType',
	anchor:'90%',
	StkType:App_StkTypeCode,     
	LocId:CtLocId,
	UserId:UserId
});

var INVRpTotalAmt=new Ext.form.TextField({
	id : 'INVRpTotalAmt',
	fieldLabel:'组合进价总额',
	anchor : '90%',
	disabled:true
});

var INVSpTotalAmt=new Ext.form.TextField({
	id : 'INVSpTotalAmt',
	fieldLabel:'组合售价总额',
	anchor : '90%',
	disabled:true
});	
	
var createFromRec = new Ext.Toolbar.Button({
	text : '单据明细发票组合',
	tooltip : '入库单、退货单明细发票组合',
	width : 70,
	height : 30,
	iconCls : 'page_edit',
	handler : function() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "请选择入库科室!");
			return;
		}
		CreateFromRec(phaLoc,setinvInfo);
	}
});

var createFromRecRet = new Ext.Toolbar.Button({
	text : '主单据发票组合',
	tooltip : '入库单、退货单发票组合',
	width : 70,
	height : 30,
	iconCls : 'page_edit',
	handler : function() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "请选择入库科室!");
			return;
		}
		createFromRecRet(phaLoc,setinvInfo);
	}
});

var SearchBT = new Ext.Toolbar.Button({
	text : '查询',
	tooltip : '点击查询',
	width : 70,
	height : 30,
	iconCls : 'page_find',
	handler : function() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "请选择入库退货科室!");
			return;
		}
		QueryVendorInv(phaLoc,setinvInfo);
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

var CancleCompleteBT = new Ext.Toolbar.Button({
	id : "CancleCompleteBT",
	text : '取消完成',
	tooltip : '点击取消完成',
	width : 70,
	height : 30,
	iconCls : 'page_delete',
	handler : function() {
		CancleComplete();
	}
});
var DeleteBT = new Ext.Toolbar.Button({
	text:'删除',
	id:'DeleteBT',
    tooltip:'删除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		Delete();
	}
});
var DeleteinvItmBT = new Ext.Toolbar.Button({
	id : "DeleteinvItmBT",
	text : '删除一条',
	tooltip : '',
	width : 70,
	height : 30,
	iconCls : 'page_delete',
	handler : function() {
		DeleteinvItm();
	}
});

var SetCompleteBT = new Ext.Toolbar.Button({
	id : "Saveinv",
	text : '完成',
	tooltip : '',
	width : 70,
	height : 30,
	iconCls : 'page_save',
	handler : function() {
		SetComplete();
	}
});

var invDetailUrl = URL	+ '?actiontype=queryItem';
var invDetailProxy= new Ext.data.HttpProxy({
			url : invDetailUrl,
			method : "POST"
});

var invItmFields = ["invi","ingridr","IncId","IncCode","IncDesc","spec","RecQty","UomDesc","manf","rp","sp","rpAmt","spAmt","TransType"]

// 支持分页显示的读取方式
var reader = new Ext.data.JsonReader({
	root : 'rows',
	totalProperty : "results",
	id : "invi",
	fields : invItmFields
});

var invDetailStore = new Ext.data.Store({
	proxy : invDetailProxy,
	reader : reader,
	listeners:{
		'beforeload':function(store){
			var psize=invDetailGridPagingToolbar.pageSize;
			store.baseParams={start:0,limit:psize,parref:invRowId};
		}
	}
});

var invDetailCM=new Ext.grid.ColumnModel([
  		{
			header : "RowId",
			dataIndex : 'invi',
			hidden : true
		}, {
			header : "入库退货Id",
			dataIndex : 'ingridr',
			width : 80,
			hidden : true
		}, {
			header : "物资Id",
			dataIndex : 'IncId',
			width : 80,
			hidden : true
		}, {
			header : '物资代码',
			dataIndex : 'IncCode',
			width : 80
		}, {
			header : '物资名称',
			dataIndex : 'IncDesc',
			width : 180
		}, {
			header : "规格",
			dataIndex : 'spec',
			width : 80
		}, {
			header : "数量",
			dataIndex : 'RecQty',
			width : 80,
			align : 'right'
		}, {
			header : "单位",
			dataIndex : 'UomDesc',
			width : 80,
			align : 'left'
		}, {
			header : "进价",
			dataIndex : 'rp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "售价",
			dataIndex : 'sp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "进价金额",
			dataIndex : 'rpAmt',
			xtype : 'numbercolumn'
		}, {
			header : "售价金额",
			dataIndex : 'spAmt',
			xtype : 'numbercolumn'
		}, {
			header : "类型",
			dataIndex : 'TransType',
			width : 70,
			align : 'left',
			sortable : true	
		}, {
			header : "厂商",
			dataIndex : 'manf',
			width : 150
		}
  ]);	

var invDetailGridPagingToolbar = new Ext.PagingToolbar({
	store:invDetailStore,
	pageSize:PageSize,
	displayInfo:true
});

var invDetailGrid = new Ext.grid.GridPanel({
	region: 'center',
	title: '发票组合单明细',
	cm : invDetailCM, 
	sm : new Ext.grid.RowSelectionModel({singleSelect : true}),
	store : invDetailStore,
	trackMouseOver : true,
	stripeRows : true,
	loadMask : true,
	tbar:[DeleteinvItmBT],
	bbar:[invDetailGridPagingToolbar]
});

var HisListTab = new Ext.ux.FormPanel({
    title:'入库单、退货单发票组合',
    tbar : [SearchBT, '-', ClearBT,'-', SetCompleteBT,'-',CancleCompleteBT,'-',DeleteBT,'-',createFromRec,'-', createFromRecRet,'-',PrintBT],
    items:{
    	xtype : 'fieldset',
    	title:'发票组合主信息',
    	autoHeight:true,
    	layout:'column',
    	defaults : {layout : 'form'},
		items:[{
			columnWidth: 0.25,
			items: [PhaLoc,Vendor]
		},{
			columnWidth: 0.2,
			labelWidth : 100,
			items: [invNoField,StkGrpType]
		},{
			columnWidth: 0.2,
			labelWidth : 100,
			items: [INVRpTotalAmt,CreatUsr]
		},{
			columnWidth: 0.2,
			items: [CreatDate,CreatTim]
		},{
			columnWidth: 0.15,
		    items: [completedFlag]
		}]
    }
});
//===========模块主页面=============================================
Ext.onReady(function(){
 	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
		layout : 'border', 
		items : [HisListTab, invDetailGrid],
		renderTo:"mainPanel"
	});	
});


/**
 * 完成付款单
 */
function SetComplete() {
	if (invRowId== null || invRowId.length <= 0) {
		Msg.info("warning", "没有需要完成的发票组合单!");
		return;
	}
	var RowData=invDetailStore.getAt(0);
	if(RowData==""||RowData==undefined){
		Msg.info("warning","没有需要完成的发票组合单明细!");
		return;
	}
	var INVRpTotalAmt = Ext.getCmp('INVRpTotalAmt').getValue();
	if(INVRpTotalAmt==0){
		Msg.info("warning","组合的入库单、退货单明细进价总额为零!");
		return;
	}
	var url = URL+ "?actiontype=SetComp&invid="+ invRowId;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '更新中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				Msg.info("success", "成功!");								
				setinvInfo(invRowId);
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "操作失败,发票组合单Id为空或发票组合单不存在!");
				}else if(Ret==-2){
					Msg.info("error", "发票组合单已经完成!");
				}else {
					Msg.info("error", "操作失败!");
				}
			}
		},
		scope : this
	});
}

function setinvInfo(xinvRowId)
{ 
	invRowId = xinvRowId;
	Ext.Ajax.request({
	    url: URL+'?actiontype=invMainInfo&invid='+invRowId,
	    method : 'POST',
	    success: function(result, request)
	    {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.results>0) 
			{
				var invId=jsonData.rows[0]['INV_RowId'];
				var vendor=jsonData.rows[0]['INV_APCVM_DR'];
				var vendorName=jsonData.rows[0]['vendorName'];
				var invLoc =jsonData.rows[0]['INV_CTLOC_DR'];
				var invDate=jsonData.rows[0]['INV_CreateDate'];
				var invTime=jsonData.rows[0]['INV_CreateTime'];
				var invUser=jsonData.rows[0]['INV_CreateUser'];
				var invUserName=jsonData.rows[0]['UserName'];
				var AssemNo=jsonData.rows[0]['INV_AssemNo'];
				var completedFlag=jsonData.rows[0]['INV_UserCompleted'];
				var scgdr=jsonData.rows[0]['INV_SCG_DR'];
				var scgDesc=jsonData.rows[0]['scgDesc'];
				var rpAmt=jsonData.rows[0]['INV_RpAmt'];

			 	Ext.getCmp('PhaLoc').setValue(invLoc);				 	
			 	Ext.getCmp('Vendor').setRawValue(vendorName);
			 	Ext.getCmp('Vendor').store.reload();
			 	Ext.getCmp('invNoField').setValue(AssemNo);
			 	
			 	Ext.getCmp('CreatDate').setValue(invDate);
			 	Ext.getCmp('CreatTim').setValue(invTime);
			 	Ext.getCmp('CreatUsr').setValue(invUserName);
				addComboData(null,scgdr,scgDesc,StkGrpType);
				Ext.getCmp('StkGrpType').setValue(scgdr);
				Ext.getCmp('INVRpTotalAmt').setValue(rpAmt);

			 	if (completedFlag=="Y"){
			 		Ext.getCmp('completedFlag').setValue(true);
			 		Ext.getCmp('CancleCompleteBT').setDisabled(false);
			 	}else{
			 		Ext.getCmp('completedFlag').setValue(false);
					Ext.getCmp('CancleCompleteBT').setDisabled(true);
				}
				invDetailStore.load();
			}
	    },
	    failure: function(){Msg.info("error","失败!");}

	});
}

/**
 * 取消完成入库单
 */
function CancleComplete() {
	if (invRowId== null || invRowId.length <= 0) {
		Msg.info("warning", "没有需要完成的发票组合单!");
		return;
	}
	var url = URL+ "?actiontype=CnlComp&invid="+ invRowId ;
	Ext.Ajax.request({
		url : url,
		method : 'POST',
		waitMsg : '更新中...',
		success : function(result, request) {
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success == 'true') {
				// 完成单据
				Msg.info("success", "成功!");			
				setinvInfo(invRowId);
			} else {
				var Ret=jsonData.info;
				if(Ret==-1){
					Msg.info("error", "操作失败,发票组合单Id为空或发票组合单不存在!");
				}else if(Ret==-2){
					Msg.info("error", "发票组合单已输入发票号!");
				}else {
					Msg.info("error", "操作失败!");
				}
			}
		},
		failure:function(){
			Msg.info("error","失败!");
		},
		scope : this
	});
}
	
/*删除付款明细记录*/
function DeleteinvItm(){
	var rec=this.invDetailGrid.getSelectionModel().getSelected();
	if (rec==undefined)	{return;}
	var invi=rec.get('invi') ;
	if (invi=="") {return;}
	var compFlag=Ext.getCmp("completedFlag").getValue();
	if(compFlag==true){
		Msg.info("warning","发票组合单已经完成,不能删除明细!");
		return;
	}
	Ext.Msg.show({
		title:'提示',
		msg:'是否确定删除此条明细？',
		buttons:Ext.Msg.YESNO,
		icon: Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if (b=='no') {return;}
			else {
				Ext.Ajax.request({
					url:URL+'?actiontype=DelinvItm&RowId='+invi,
					method:"POST",
					success:function(result,request)
					{
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success=='true')
						{		
							Msg.info("success", "删除成功!");
							setinvInfo(invRowId);								
						}else if (jsonData.success=='false'){
							if (jsonData.info=='-99') 	Msg.info("error","加锁失败！")
						    if (jsonData.info=='-2') 	Msg.info("error","已填写发票号！")
						    if (jsonData.info=='-3') 	Msg.info("error","发票组合单已完成！")
							if (jsonData.info=='-4') 	Msg.info("error","删除后,发票组合金额小于0！")
						}else{
							Msg.info("error", "删除失败!");
						}
					}
				})
			}
		}
	});
}
/**
 * 删除组合单方法
 */
function Delete(){
	if (invRowId== null || invRowId.length <= 0) {
		Msg.info("warning", "没有需要删除的发票组合单!");
		return;
	}
	var compFlag=Ext.getCmp("completedFlag").getValue();
	if(compFlag==true){
		Msg.info("warning","发票组合单已经完成,不能删除明细!");
		return;
	}
	Ext.Msg.show({
		title:'提示',
		msg:'是否确定删除？',
		buttons:Ext.Msg.YESNO,
		icon:Ext.MessageBox.QUESTION,
		fn:function(b,txt){
			if(b=='no'){return;}
			else{
				Ext.Ajax.request({
					url:URL+'?actiontype=Delete',
					method:'POST',
					params:{invRowId:invRowId},
					success:function(response,opts){
						var jsonData=Ext.util.JSON.decode(response.responseText)
						if(jsonData.success=='true'){
							Msg.info("success","删除成功!");
							clearData()
						}else{
							Msg.info("error","删除失败!")
							}
							
						},
						failure:function(response,opts){
						Msg.info("error","server-side failure with status code："+response.status);
					}
					
					});
				}
			}
		
		});
	
	}
/**
 * 清空方法
 */
function clearData() {
	
	invRowId="";
	Ext.getCmp("invNoField").setValue("");
	Ext.getCmp("CreatUsr").setValue("");	
	Ext.getCmp("CreatDate").setValue("");	
	Ext.getCmp("CreatTim").setValue("");		
 	Ext.getCmp('Vendor').setValue("");
 	Ext.getCmp('completedFlag').setValue("false");	
	invDetailGrid.store.removeAll();
	invDetailGrid.getView().refresh();
	
}
