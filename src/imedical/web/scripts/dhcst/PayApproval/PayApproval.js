// 名称:付款审批
// 编写日期:2012-09-07
//=========================定义全局变量=================================

var gGroupId=session['LOGON.GROUPID'];
var UserId = session['LOGON.USERID'];
//var arr = window.status.split(":");
//var length = arr.length;
var URL = 'dhcst.payapprovalaction.csp';
var strParam = "";

var strParam1="";
var strParam2="";

var LocField = new Ext.ux.LocComboBox({
	id:'LocField',
	name:'LocField',
	fieldLabel:$g('科室'),
	listWidth:210,
	groupId:gGroupId,
	anchor:'90%'
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : $g('经营企业'),
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	emptyText : $g('经营企业...')
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	listWidth:120,
    allowBlank:true,
	fieldLabel:$g('起始日期'),
	anchor:'90%',
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	listWidth:120,
    allowBlank:true,
	fieldLabel:$g('截止日期'),
	anchor:'90%',
	value:new Date()
});

var INVNnmber = new Ext.form.TextField({
	id:'INVNnmber',
	fieldLabel:$g('发票号'),
	allowBlank:true,
	listWidth:150,
	emptyText:'',
	anchor:'90%',
	selectOnFocus:true
});

var onlyRequest = new Ext.form.Checkbox({
	id: 'onlyRequest',
	fieldLabel:$g('仅申请计划'),
	allowBlank:true
});

var InvoiceField = new Ext.form.Radio({ 
	id:'InvoiceField',
	name:'InvoiceCondition',
	boxLabel:$g('有发票' ) 
});
var noInvoiceField = new Ext.form.Radio({  
	id:'noInvoiceField',
	name:'InvoiceCondition',
	boxLabel:$g('无发票' ) 
});
var allInvoiceField = new Ext.form.Radio({ 
	id:'allInvoiceField',
	name:'InvoiceCondition',
	boxLabel:$g('全部'),
	checked:true
});
	
var Approvalflag = new Ext.form.Radio({ 
	id:'Approval',
	boxLabel:$g('已审批'),
	name:'AuditCondition'
});
var noApprovalflag = new Ext.form.Radio({  
	id:'noApproval',
	name:'AuditCondition',
	boxLabel:$g('未审批' )
});
var allApprovalflag = new Ext.form.Radio({ 
	id:'allApproval',
	name:'AuditCondition',
	boxLabel:$g('全部'),
	checked:true
});
	
var IncludeRet = new Ext.form.Checkbox({
	id: 'IncludeRet',
	fieldLabel:$g('包含退货'),
	anchor:'90%',
	allowBlank:true
});

var IncludeGift = new Ext.form.Checkbox({
	id:'IncludeGift',
	fieldLabel:$g('包含赠送'),
	anchor:'90%',
	allowBlank:true
});

var find = new Ext.Toolbar.Button({
	text:$g('查询'),
    tooltip:$g('查询'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(App_StkDateFormat);
		}else{
			Msg.info("error",$g("请选择起始日期!"));
			return false;
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(App_StkDateFormat);
		}else{
			Msg.info("error",$g("请选择截止日期!"));
			return false;
		}
			
		var locId = Ext.getCmp('LocField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error",$g("请选择申请部门!"));
			return false;
		}
		var vendorId = Ext.getCmp('Vendor').getValue();	
		var IncludeRetflag = (Ext.getCmp('IncludeRet').getValue()==true?'Y':'N');
		var IncludeGiftflag = (Ext.getCmp('IncludeGift').getValue()==true?'Y':'N');	
		var INVNnmber=Ext.getCmp('INVNnmber').getValue();
		//alert(INVNnmber)
		var Complete="";
		var Complete1 = Ext.getCmp('Approval').getValue();
		var Complete2 = Ext.getCmp('noApproval').getValue();
		complete = (Complete1==true?'Y':(Complete2==true?'N':''));
		var Inv="";
		var Inv1 = Ext.getCmp('InvoiceField').getValue();
		var Inv2 = Ext.getCmp('noInvoiceField').getValue();
		Inv = (Inv1==true?'Y':(Inv2==true?'N':''));
		
		
		strParam1 = locId+"^"+startDate+"^"+endDate+"^"+vendorId+"^"+IncludeRetflag+"^"+IncludeGiftflag+"^"+Inv+"^"+complete+"^"+INVNnmber;
	
		var pagesize=VendorPagingToolbar.pageSize;
		VendorGridDs.setBaseParam('strParam',strParam1);
		VendorGridDs.load({
			params:{start:0,limit:pagesize,sort:'RowId',dir:'desc',strParam:strParam1},
				callback : function(o,response,success) { 
					if (success == false){  
						Ext.MessageBox.alert($g("查询错误"),VendorGridDs.reader.jsonData.Error);  
					}
				}
			});
	}
});

var clear = new Ext.Toolbar.Button({
	text:$g('清屏'),
    tooltip:$g('点击清屏'),
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		//Ext.getCmp('LocField').setValue("");
		SetLogInDept(PhaDeptStore, "LocField");
		Ext.getCmp('startDateField').setValue(new Date());
		Ext.getCmp('endDateField').setValue(new Date());
		Ext.getCmp('IncludeRet').setValue(false);
		Ext.getCmp('IncludeGift').setValue(false);
		Ext.getCmp('INVNnmber').setValue("");
		Ext.getCmp('Vendor').setValue("");
		
		Ext.getCmp('allApproval').setValue(true);
		Ext.getCmp('allInvoiceField').setValue(true);
		VendorGridDs.load({params:{start:0,limit:0}})
		Ext.getCmp("VendorGrid").getStore().removeAll();
		Ext.getCmp("VendorGrid").getView().refresh();
		RecRetGridDs.load({params:{start:0,limit:0}})
		RecRetDetailGridDs.load({params:{start:0,limit:0}})
		Ext.getCmp("RecRetGrid").getStore().removeAll();
		Ext.getCmp("RecRetGrid").getView().refresh();
		Ext.getCmp("RecRetDetailGrid").getStore().removeAll();
		Ext.getCmp("RecRetDetailGrid").getView().refresh();
		Ext.getCmp("RecRetGrid").getEl().select('div.x-grid3-hd-checker').removeClass('x-grid3-hd-checker');
	}
});

var Approval = new Ext.Toolbar.Button({
	text:$g('审批'),
    tooltip:$g('审批'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		saveApproval();
	}
});

function saveApproval(){
	var rowCount = RecRetGrid.getStore().getCount();
	var m=0
	for(var i=0;i<rowCount;i++){
	if(chkSm.isSelected(i)==false){	
	  m=m+1
	}
	
	}
	if(m==rowCount){Msg.info("warning",$g("请选择入库/退货单!"));
			return false;
		}
	for(var i=0;i<rowCount;i++){

		if(chkSm.isSelected(i)==true){
			var rowData = RecRetGridDs.getAt(i);	
			var IngrId=rowData.data["RowId"];
			var type=rowData.data["type"];
			var IngrNo=rowData.data["gdNo"];
			if((IngrId!="")&&(IngrId!=null)){
				var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
				Ext.Ajax.request({
					url: URL+'?actiontype=approval&InGrId='+IngrId+"&type="+type,
					failure: function(result, request) {
						 mask.hide();
						Msg.info("error",$g("请检查网络连接!"));
					},
					success: function(result, request) {
						var jsonData = Ext.util.JSON.decode( result.responseText );
						 mask.hide();
						if (jsonData.success=='true') {
							Msg.info("success",$g("审批成功!"));
							refreshRecList();
							
							
						}else{
							/*
							if(jsonData.info==-1){
								Msg.info("error",IngrNo+"不存在!");
							}else if(jsonData.info==-2){
								Msg.info("error",IngrNo+"未审核!");
							}else if(jsonData.info==-100){
								Msg.info("error",IngrNo+"已经审批过!");
							}else{
								Msg.info("error","审批失败!");
							}
							*/
							Msg.info("error",jsonData.info.split("^")[1]);
						}
					},
					scope: this
				});
			}
		}
	}
}

var noApproval = new Ext.Toolbar.Button({
	text:$g('取消审批'),
    tooltip:$g('取消审批'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		CancleAppr();
	}
});

function CancleAppr(){
	var rowCount = Ext.getCmp('RecRetGrid').getStore().getCount();
	var m=0
	for(var i=0;i<rowCount;i++){
	if(chkSm.isSelected(i)==false){	
	  m=m+1
	}
	
	}
	if(m==rowCount){Msg.info("warning",$g("请选择入库/退货单!"));
			return false;
		}				
	for(var i=0;i<rowCount;i++){
		var sm=RecRetGrid.getSelectionModel();
		if(sm.isSelected(i)==true){
			var rowData = Ext.getCmp('RecRetGrid').getStore().getAt(i);	
			var IngrId=rowData.data["RowId"];
			 
			var IngrNo=rowData.data["gdNo"];
			var type=rowData.data["type"];
			if((IngrId!="")&&(IngrId!=null)){
			var mask=ShowLoadMask(Ext.getBody(),$g("处理中请稍候..."));
			Ext.Ajax.request({
				url: URL+'?actiontype=noapproval&InGrId='+IngrId+"&type="+type,
				failure: function(result, request) {
					 mask.hide();
					Msg.info("error",$g("请检查网络连接!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					 mask.hide();
					if (jsonData.success=='true') {
						Msg.info("success",$g("取消审批成功!"));
						refreshRecList();
					}else{
						/*
						if(jsonData.info==1){
							Msg.info("warning",IngrNo+"该付款单未审批,不能取消审批!");
						}else{
						
						if(jsonData.info==-100){
							Msg.info("error",IngrNo+"已经生成付款单不能取消审批!");
						}else{
							Msg.info("error","取消审批失败!");
						}
					}*/
					Msg.info("error",jsonData.info.split("^")[1]);
					}
				},
				scope: this
			});
		}
		}
	}
}
//=========================经营企业主信息=================================
var sm = new Ext.grid.CheckboxSelectionModel(); 

//var VendorGrid="";
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
    remoteSort:true,
    listeners:{
    	'load':function(store,recs,o)   {
	    	//alert('ddd')	    
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
        header:$g("经营企业"),
        dataIndex:'vendorName',
        width:160,
        align:'left',
        sortable:true
    },{
        header:$g("入库进价金额"),
        dataIndex:'rpAmt',
        width:120,
        align:'right',
        sortable:true
    },{
        header:$g("应付款金额"),
        dataIndex:'toPayAmt',
        width:90,
        align:'right',
        sortable:true
    },{
        header:$g("已付款金额"),
        dataIndex:'payedAmt',
        width:90,
        align:'right',
        sortable:true
    }
    ,{
        header:$g("冲帐金额"),
        dataIndex:'toDashAmt',
        width:90,
        align:'right',
        sortable:true,
        hidden:true
    }
]);

//初始化默认排序功能
VendorGridCm.defaultSortable = true;

var VendorPagingToolbar = new Ext.PagingToolbar({
    store:VendorGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
    emptyMsg:$g("没有记录")
    /*,
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='RowId';
		B[A.dir]='desc';
		B['strParam']=strParam1;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}*/
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
//	autoScroll:true,	
	bbar:[VendorPagingToolbar]
});
//=========================入库/退货单主信息=================================

//=========================入库/退货单明细=============================
//var sm1 = new Ext.grid.CheckboxSelectionModel({
//	checkOnly:true
//});
//var RecRetGrid="";
//配置数据源
var RecRetGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=querygdrec',method:'GET'});
var RecRetFields=[
		{name:'RowId',mapping:'ingr'},
		{name:'gdNo',mapping:'gdNo'},
		{name:'RpAmt',mapping:'rpAmt'},
		{name:'ApprvFlag',mapping:'payAllowed'},
		{name:'CreateUser',mapping:'createUserName'},
		{name:'CreateDate',mapping:'createDate'},
		{name:'AuditUser',mapping:'gdAuditUserName'},
		{name:'AuditDate',mapping:'gdDate'},
		{name:'PayedFlag',mapping:'payOverFlag'},
		{name:'TypePointer',mapping:'typePointer'},
		'type'
	];
	
var RecRetGridDs = new Ext.data.Store({
	proxy:RecRetGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        id:'typePointer',
        fields:RecRetFields
    }),
    listeners:{
	    'load':function(store,recs,o)   {
			Ext.getCmp('RecRetDetailGrid').getStore().removeAll();
			Ext.getCmp('RecRetDetailGrid').getView().refresh();
			
	    }   
    },
    
   remoteSort:true
});

var nm=new Ext.grid.RowNumberer();
var chkSm=new Ext.grid.CheckboxSelectionModel();
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
        header:$g("单号"),
        dataIndex:'gdNo',
        width:140,
        align:'left',
        sortable:true
    },{
        header:$g("类型"),
        dataIndex:'type',
        width:40,
        align:'left',
        sortable:true,
        renderer:function(v, p, record){
			if (v=="G"){return $g("入库")}
			if (v=="R") {return $g("退货")}
		}
    },{
        header:$g("进价金额"),
        dataIndex:'RpAmt',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("审批标志"),
        dataIndex:'ApprvFlag',
        width:70,
        align:'left',
        sortable:true,
        renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
    },{
        header:$g("制单人"),
        dataIndex:'CreateUser',
        width:60,
        align:'left',
        sortable:true
    },{
        header:$g("制单日期"),
        dataIndex:'CreateDate',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("审核人"),
        dataIndex:'AuditUser',
        width:60,
        align:'left',
        sortable:true
    },{
        header:$g("审核日期"),
        dataIndex:'AuditDate',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("付清标志"),
        dataIndex:'PayedFlag',
        width:70,
        align:'left',
        sortable:true,
        renderer:function(v, p, record){
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
			}
    },{
        header:"TypePointer",
        dataIndex:'TypePointer',
        width:80,
        align:'left',
        sortable:true,
        hidden:true
    }
]);

//初始化默认排序功能
RecRetGridCm.defaultSortable = true;

var RecRetPagingToolbar = new Ext.PagingToolbar({
    store:RecRetGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
    emptyMsg:$g("没有记录")
});

//表格
var RecRetGrid = new Ext.grid.EditorGridPanel({
	id:'RecRetGrid',
	store:RecRetGridDs,
	autoScroll:true,
	cm:RecRetGridCm,
	trackMouseOver:true,
	height:220,
	stripeRows:true,
	sm:chkSm,
	loadMask:true,
	clicksToEdit:1,
	deferRowRender:false,
	bbar:[RecRetPagingToolbar],
	listeners:
	{
		'click':function(grid,rowIndex,e)
		{
			
			//var count= RecRetGrid.getStore().getCount();
			var rows=RecRetGrid.getSelectionModel().getSelections();
			var rowIDStr="",typeStr=""
			for(var i=0;i<rows.length;i++){
				if(rowIDStr=="")
				{
					rowIDStr=rows[i].get("RowId")
					typeStr=rows[i].get("type")
				}
				else{
					rowIDStr=rowIDStr+"#"+rows[i].get("RowId")
					typeStr=typeStr+"#"+rows[i].get("type")
				}
			}
			//RecRetDetailGridDs.proxy = new Ext.data.HttpProxy({url:URL+'?actiontype=queryItem',method:'GET'});

			var pagesize=RecRetDetailToolbar.pageSize;
			RecRetDetailGridDs.setBaseParam('sort','RowId');
			RecRetDetailGridDs.setBaseParam('dir','desc');
			RecRetDetailGridDs.setBaseParam('InGrId',rowIDStr);
			RecRetDetailGridDs.setBaseParam('type',typeStr);
			RecRetDetailGridDs.removeAll();	//sort:'RowId',dir:'desc',InGrId:parref,type:type
			RecRetDetailGridDs.load({
				params:{start:0,limit:pagesize},
				callback : function(o,response,success) { 
					if (success == false){  
						Ext.MessageBox.alert($g("查询错误"),RecRetDetailGridDs.reader.jsonData.Error);  
					}
				}
			});
		}
	}
});
//=========================入库/退货单明细=============================

/*
//-----------入库单与明细间的联动-------------
RecRetGrid.on('rowclick',function(grid,rowIndex,e){
	var selectedRow = RecRetGridDs.data.items[rowIndex];
	
	var rec=grid.getStore().getAt(rowIndex)
	parref=rec.get('IngrId');
	type=rec.get('type');
	
	alert(parref);
	//parref = selectedRow.rowData["Rowid"];
 //type=selectedRow.rowData["type"];
	
	RecRetDetailGridDs.proxy = new Ext.data.HttpProxy({url:URL+'?actiontype=queryItem',method:'GET'});
	RecRetDetailGridDs.load({params:{start:0,limit:25,sort:'RowId',dir:'desc',InGrId:'parref',type:'type'}});
});
*/



//配置数据源
var RecRetDetailGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=queryItem',method:'POST'});
var RecRetDetailFields=['RowId','IncId','IncCode','IncDesc','Spec','Manf',{name: 'Qty', type: 'float'},'Uom','BatchNo','ExpDate','Rp','RpAmt','Sp', 'SpAmt','InvNo','InvDate', 'InvMoney','SxNo','TypePointer'];
		
var RecRetDetailGridDs = new Ext.data.Store({
	proxy:RecRetDetailGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows',
        totalProperty:'results',
        id:'TypePointer',
        fields:RecRetDetailFields
    }),
    remoteSort:false
});


//"RowId^IncId^IncCode^IncDesc^Spec^Manf^Qty^Uom^BatchNo^ExpDate^Rp^RpAmt^Sp^SpAmt^InvNo^InvDate^InvMoney^SxNo"


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
        header:$g("药品Id"),
        dataIndex:'IncId',
        width:180,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("代码"),
        dataIndex:'IncCode',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("名称"),
        dataIndex:'IncDesc',
        width:200,
        align:'left',
        sortable:true
    },{
		header : $g('生产企业'),
		dataIndex : 'Manf',
		width : 170,
		align : 'left',
		sortable : true
	}, {
		header :$g( "批号"),
		dataIndex : 'BatchNo',
		width : 80,
		align : 'left',
		sortable : true
	}, {
		header : $g("有效期"),
		dataIndex : 'ExpDate',
		width : 90,
		align : 'center',
		sortable : true
	}, {
		header : $g('单位'),
		dataIndex : 'Uom',
		width : 70,
		align : 'left',
		sortable : true
	}, {
		header : $g("数量"),
		dataIndex : 'Qty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
        header:$g("进价"),
        dataIndex:'Rp',
        width:100,
        align:'right',
        sortable:true
    }, {
        header:$g("进价金额"),
        dataIndex:'RpAmt',
        width:100,
        align:'right',
        sortable:true
    }, {
		header :$g( "售价"),
		dataIndex : 'Sp',
		width : 80,
		align : 'right',
		
		sortable : true
	}, {
        header:$g("售价金额"),
        dataIndex:'SpAmt',
        width:100,
        align:'right',
        sortable:true
    },{
		header :$g( "发票号"),
		dataIndex : 'InvNo',
		width : 80,
		align : 'left',
		sortable : true
	},{
		header : $g("发票日期"),
		dataIndex : 'InvDate',
		width : 80,
		align : 'left',
		sortable : true
	},{
		header : $g("发票金额"),
		dataIndex : 'InvMoney',
		width : 80,
		align : 'right',
		sortable : true
	},{
		header : $g("随行单号"),
		dataIndex : 'SxNo',
		width : 80,
		align : 'left',
		sortable : true
	},{
		header : "TypePointer",
		dataIndex : 'TypePointer',
		width : 200,
		align : 'left',
		sortable : true,
		hidden:true
	}
]);

//初始化默认排序功能
RecRetDetailGridCm.defaultSortable = true;

var RecRetDetailToolbar = new Ext.PagingToolbar({
    store:RecRetDetailGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
    emptyMsg:$g("没有记录")
});

//表格
RecRetDetailGrid = new Ext.grid.EditorGridPanel({
	id:'RecRetDetailGrid',
	store:RecRetDetailGridDs,
	cm:RecRetDetailGridCm,
	trackMouseOver:true,
	height:260,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel(),
	loadMask:true,
	clicksToEdit:1,
	bbar:RecRetDetailToolbar
});

//-----------经营企业与入库单间的联动-------------
VendorGrid.on('rowclick',function(grid,rowIndex,e){
	RecRetGridDs.removeAll();
	var selectedRow = VendorGridDs.data.items[rowIndex];
	vendorId = selectedRow.data["vendor"];

	var startDate = Ext.getCmp('startDateField').getValue();
	if((startDate!="")&&(startDate!=null)){
		startDate = startDate.format(App_StkDateFormat);
	}else{
		Msg.info("error",$g("请选择起始日期!"));
		return false;
	}
	var endDate = Ext.getCmp('endDateField').getValue();
	if((endDate!="")&&(endDate!=null)){
		endDate = endDate.format(App_StkDateFormat);
	}else{
		Msg.info("error",$g("请选择截止日期!"));
		return false;
	}
		
	var locId = Ext.getCmp('LocField').getValue();
	if((locId=="")||(locId==null)){
		Msg.info("error",$g("请选择申请部门!"));
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
	strParam2 = locId+"^"+startDate+"^"+endDate+"^"+vendorId+"^"+IncludeRetflag+"^"+IncludeGiftflag+"^"+Inv+"^"+complete+"^"+INVNnmber;
	RecRetGridDs.setBaseParam('strParam',strParam2)
	RecRetGridDs.load({
		params:{start:0,limit:20,sort:'RowId',dir:'desc',strParam:strParam2},
		callback : function(o,response,success) { 
			if (success == false){  
				Ext.MessageBox.alert($g("查询错误"),RecRetGridDs.reader.jsonData.Error);  
			}
		}
	});
});
	
function refreshRecList()
{
	RecRetGridDs.removeAll();
	RecRetGridDs.reload();
}



//===========模块主页面===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var col1={ 				
		//columnWidth: 0.25,
        xtype: 'fieldset',
        //labelWidth: 60,	
        defaults: {width: 140, border:false},    // Default config options for child items
        defaultType: 'textfield',
        autoHeight: true,
        border: false,
        items: [startDateField,endDateField,INVNnmber]
				
	};
	var col2={ 				
		//columnWidth: 0.3,
        xtype: 'fieldset',
       // labelWidth: 60,	
        defaults: {width: 250, border:false},    // Default config options for child items
        defaultType: 'textfield',
        autoHeight: true,
        border: false,
        items: [LocField,Vendor]
				
	};
	var col5={
		columnWidth: 0.15,
        xtype: 'fieldset',
       // labelWidth: 60,	
        //defaults: {width: 100, border:false},    // Default config options for child items
        defaultType: 'textfield',
        autoHeight: true,
        border: false,
		items:[IncludeRet,IncludeGift]
	};
	var col3={ 		
		title:$g('审批情况'),	
		//frame : false,
		//columnWidth: 0.15,
		autoHeight:true,
		height:120,
        xtype: 'fieldset',
        layout:'form',
       // labelWidth: 60,	
       // defaults: {width: 120, border:false},    // Default config options for child items
        defaultType: 'textfield',
        border: true,
        style : 'padding-top:5px;padding-bottom:5px;',
        items: [allApprovalflag,Approvalflag,noApprovalflag]
				
	};
	var col4={ 	
		title:$g('发票情况'),	
		//frame : false,			
		autoHeight:true,
		height:100,
		//columnWidth:  0.15,
        xtype: 'fieldset',
       // labelWidth:100,	
       // defaults: {width: 120, border:false},    // Default config options for child items
        defaultType: 'textfield',
        border: true,
        style : 'padding-top:5px;padding-bottom:5px;',
        items: [allInvoiceField,InvoiceField,noInvoiceField]
				
	};
	
	var MainPanel = new Ext.form.FormPanel({
		title:$g('付款审批'),
		region:'north',
		labelAlign : 'right',
		height:DHCSTFormStyle.FrmHeight(3)+28,
		frame : true,
		tbar:[find,'-',clear,'-',Approval,'-',noApproval],
		layout: 'fit',    // Specifies that the items will now be arranged in columns
		items : [{
			xtype:'fieldset',
			//anchor:'95%',
			title:$g('查询条件'),
			//autoHeight:true,
			style:DHCSTFormStyle.FrmPaddingV,
			layout:'column',
			items:[
				{layout:'form',columnWidth:'0.3',labelWidth:60,bodyStyle : 'padding-top:15px;',items:[LocField,Vendor,INVNnmber]}, //,IncludeGift]},
				{layout:'form',columnWidth:'0.25',labelWidth:60,bodyStyle : 'padding-top:15px;',items:[startDateField,endDateField,IncludeRet]},
				{layout:'form',columnWidth:'0.15',labelWidth:15,items:col3}, // [allApprovalflag,Approvalflag,noApprovalflag]
				{layout:'form',columnWidth:'0.15',bodyStyle : 'padding-left:10px;',labelWidth:15,items:col4}
			]
		}] // [allInvoiceField,InvoiceField,noInvoiceField]
	});
	
 
	var VendorPanel = new Ext.Panel({
		deferredRender : true,
		title:$g('经营企业信息'),
		activeTab: 0,
		region:'west',
		height:300,
		width:590,
		collapsible: true,
        split: true,
		minSize: 0,
        maxSize: 500,
        autoScroll:false,
        layout:'fit',
		items:[VendorGrid]                                 
	});

	
	var InGdRecRetPanel = new Ext.Panel({
		deferredRender : true,
		autoScroll:false,
		title:$g('入库/退货单'),
		activeTab: 0,
		region:'center',
		height:300,
		width:1200,
		layout:'fit',
		items:[RecRetGrid]                                 
	});
	
	var RecRetDetailPanel = new Ext.Panel({
		deferredRender : true,
		title:$g('入库/退货明细信息'),
		activeTab: 0,
		region:'south',
		height:170,
		autoScroll:false,
		layout:'fit',
		items:[RecRetDetailGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[MainPanel,VendorPanel,InGdRecRetPanel,RecRetDetailPanel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面===========================================
