// 名称:采购计划单----请求转移
// 编写日期:2012-06-27
//=========================定义全局变量=================================
var InRequestId = "";
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var arr = window.status.split(":");
var length = arr.length;
var URL = 'dhcst.inpurplanauxbyrequestaction.csp';
var strParam = "";

var LocField = new Ext.form.ComboBox({
	id:'LocField',
	fieldLabel:'科室',
	width:210,
	listWidth:210,
	allowBlank:true,
	store:GetGroupDeptStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'科室...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:999,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});
GetGroupDeptStore.load();
GetGroupDeptStore.on('load',function(ds,records,o){
	Ext.getCmp('LocField').setRawValue(arr[length-1]);
	Ext.getCmp('LocField').setValue(CtLocId);
});	

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	width:150,
	listWidth:150,
    allowBlank:true,
	fieldLabel:'起始日期',
	format:'Y-m-d',
	anchor:'90%',
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	width:150,
	listWidth:150,
    allowBlank:true,
	fieldLabel:'截止日期',
	format:'Y-m-d',
	anchor:'90%',
	value:new Date()
});

var planNnmber = new Ext.form.TextField({
	id:'planNnmber',
	fieldLabel:'计划单号',
	allowBlank:true,
	width:150,
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

var find = new Ext.Toolbar.Button({
	text:'查找',
    tooltip:'查找',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var locId = Ext.getCmp('LocField').getValue();
		var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format('Y-m-d');
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format('Y-m-d');
		}
		var requestType = (Ext.getCmp('onlyRequest').getValue()==true?'I':"");
		//strParam:供应科室RowId^起始日期^截止日期^请求单类型
		strParam = locId+"^"+startDate+"^"+endDate+"^"+requestType;
		InRequestGridDs.load({params:{start:0,limit:20,sort:'RowId',dir:'desc',strParam:strParam}});
	}
});

var clear = new Ext.Toolbar.Button({
	text:'清除',
    tooltip:'清除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp('LocField').setValue("");
		Ext.getCmp('startDateField').setValue("");
		Ext.getCmp('endDateField').setValue("");
		Ext.getCmp('onlyRequest').setValue(false);
		Ext.getCmp('planNnmber').setValue("");
	}
});

var edit = new Ext.Toolbar.Button({
	text:'生产采购计划',
    tooltip:'生产采购计划',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
		var locId = Ext.getCmp('LocField').getValue();
		var count = gridDs.getCount();
		var listReqId = "";
		for(var k=0;k<count;k++){
			if(listReqId==""){
				listReqId = gridDs.getAt(k).get('DetailIdStr');
			}else{
				listReqId = listReqId +"^"+ gridDs.getAt(k).get('DetailIdStr');
			}
		}
		
		Ext.Ajax.request({
			url:'dhcst.inpurplanauxbyrequestaction.csp?actiontype=create&userId='+UserId+'&locId='+locId+'&listReqId='+listReqId+'&stkGrpId=',
			method:'POST',
			waitMsg:'查询中...',
			success:function(result,request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if(jsonData.success=='true'){
					location.href="dhcst.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId;
				}else{
					if(jsonData.info==-1){
						Msg.info("error","科室或人员为空!");
					}else if(jsonData.info==-99){
						Msg.info("error","加锁失败!");
					}else if(jsonData.info==-2){
						Msg.info("error","生成计划单号失败!");
					}else if(jsonData.info==-3){
						Msg.info("error","生成计划单失败!");
					}else if(jsonData.info==-4){
						Msg.info("error","生成计划单明细失败!");
					}else{
						Msg.info("error","生成采购计划单失败!");
					}
				}
			},
			scope:this
		});
	}
});
//=========================定义全局变量=================================
//=========================请求单主信息=================================
var sm = new Ext.grid.CheckboxSelectionModel(); 

var InRequestGrid="";
//配置数据源
var InRequestGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=query',method:'GET'});
var InRequestGridDs = new Ext.data.Store({
	proxy:InRequestGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'ReqNo'},
		{name:'ReqLocId'},
		{name:'ReqLoc'},
		{name:'Date'},
		{name:'Time'},
		{name:'User'}
	]),
    remoteSort:false
});
//模型
var InRequestGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"请求单号",
        dataIndex:'ReqNo',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"请求部门",
        dataIndex:'ReqLoc',
        width:130,
        align:'left',
        sortable:true
    },{
        header:"制单日期",
        dataIndex:'Date',
        width:90,
        align:'left',
        sortable:true
    },{
        header:"制单时间",
        dataIndex:'Time',
        width:90,
        align:'left',
        sortable:true
    },{
        header:"制单人",
        dataIndex:'User',
        width:90,
        align:'left',
        sortable:true
    },sm
]);

//初始化默认排序功能
InRequestGridCm.defaultSortable = true;

var InRequestPagingToolbar = new Ext.PagingToolbar({
    store:InRequestGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='RowId';
		B[A.dir]='desc';
		B['strParam']=strParam;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
InRequestGrid = new Ext.grid.EditorGridPanel({
	store:InRequestGridDs,
	cm:InRequestGridCm,
	trackMouseOver:true,
	height:220,
	stripeRows:true,
	sm:sm,
	loadMask:true,
	bbar:[InRequestPagingToolbar]
});
//=========================请求单主信息=================================

//=========================请求单明细=============================
var sm1 = new Ext.grid.CheckboxSelectionModel();
var InRequestDetailGrid="";
//配置数据源
var InRequestDetailGridProxy= new Ext.data.HttpProxy({url:URL,method:'GET'});
var InRequestDetailGridDs = new Ext.data.Store({
	proxy:InRequestDetailGridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'RowId'},
		{name:'IncId'},
		{name:'IncCode'},
		{name:'IncDesc'},
		{name:'ReqQty'},
		{name:'ReqUomId'},
		{name:'ReqUom'}
	]),
    remoteSort:true
});

//模型
var InRequestDetailGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
        header:"代码",
        dataIndex:'IncCode',
        width:150,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'IncDesc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"单位",
        dataIndex:'ReqUom',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"数量",
        dataIndex:'ReqQty',
        width:100,
        align:'left',
        sortable:true
    },sm1
]);

//初始化默认排序功能
InRequestDetailGridCm.defaultSortable = true;

var InRequestDetailPagingToolbar = new Ext.PagingToolbar({
    store:InRequestDetailGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B[A.sort]='RowId';
		B[A.dir]='desc';
		B['parref']=InRequestId;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
InRequestDetailGrid = new Ext.grid.EditorGridPanel({
	store:InRequestDetailGridDs,
	cm:InRequestDetailGridCm,
	trackMouseOver:true,
	height:220,
	stripeRows:true,
	sm:sm1,
	loadMask:true,
	clicksToEdit:1,
	deferRowRender:false,
	bbar:[InRequestDetailPagingToolbar]
});
//=========================请求单明细=============================

//=========================采购明细===============================
function addNewMXRow() {
	var mxRecord = Ext.data.Record.create([
		{
			name : 'IncId',
			type : 'int'
		},{
			name : 'IncCode',
			type : 'string'
		}, {
			name : 'IncDesc',
			type : 'string'
		}, {
			name : 'UomId',
			type : 'int'
		}, {
			name : 'Uom',
			type : 'string'
		}, {
			name : 'Qty',
			type : 'int'
		}, {
			name : 'Rp',
			type : 'double'
		}, {
			name : 'VendorId',
			type : 'int'
		}, {
			name : 'Vendor',
			type : 'string'
		}, {
			name : 'DetailIdStr',
			type : 'string'
		}
	]);
					
	var MXRecord = new mxRecord({
		IncId:'',
		IncCode:'',
		IncDesc:'',
		UomId:'',
		Uom:'',
		Qty:'',
		Rp:'',
		VendorId:'',
		Vendor:'',
		DetailIdStr:''
	});
		
	gridDs.add(MXRecord);
	grid.getSelectionModel().selectRow(gridDs.getCount()-1,true); 
}

//配置数据源
var gridProxy= new Ext.data.HttpProxy({url:URL,method:'GET'});
var gridDs = new Ext.data.Store({
	proxy:gridProxy,
    reader:new Ext.data.JsonReader({
        root:'rows'
    }, [
		{name:'IncId'},
		{name:'IncCode'},
		{name:'IncDesc'},
		{name:'UomId'},
		{name:'Uom'},
		{name:'Qty'},
		{name:'Rp'},
		{name:'VendorId'},
		{name:'Vendor'},
		{name:'DetailIdStr'}
	]),
    remoteSort:false
});

//模型
var gridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
        header:"药品Id",
        dataIndex:'IncId',
        width:180,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"代码",
        dataIndex:'IncCode',
        width:180,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'IncDesc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"单位Id",
        dataIndex:'UomId',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"单位",
        dataIndex:'Uom',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"数量",
        dataIndex:'Qty',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"进价",
        dataIndex:'Rp',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"供应商Id",
        dataIndex:'VendorId',
        width:200,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"供应商",
        dataIndex:'Vendor',
        width:300,
        align:'left',
        sortable:true
    },{
        header:"请求明细rowId",
        dataIndex:'DetailIdStr',
        width:300,
        align:'left',
        sortable:true,
		hidden:true
    }
]);

//初始化默认排序功能
gridCm.defaultSortable = true;
//表格
grid = new Ext.grid.EditorGridPanel({
	store:gridDs,
	cm:gridCm,
	trackMouseOver:true,
	height:260,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel(),
	loadMask:true,
	clicksToEdit:1
});
//=========================采购明细===============================
//选择请求单明细
var singleSelectFun = function(record){
	//存在同一个明细的时候,不能允许再被添加
	var bool = false;
	//药品Id
	var IncId = record.get('IncId');
	var index = gridDs.findExact('IncId',IncId);
	//明细Id
	var rowId = record.get('RowId');
	if(gridDs.getCount()!=0){
		if(index>=0){
			var arr = gridDs.getAt(index).get('DetailIdStr').split("^");
			var length = arr.length;
			for(var j=0;j<length;j++){
				if(arr[j]==rowId){
					bool = true;
				}
			}
		}
	}
	if(bool==false){
		if(index>=0){
			var rowData = gridDs.getAt(index);
			rowData.set("Qty",parseInt(rowData.get('Qty'))+parseInt(record.get('ReqQty')));
			rowData.set("DetailIdStr",rowData.get('DetailIdStr')+"^"+rowId);
		}else{
			addNewMXRow();
			var rowData = grid.getStore().getAt(gridDs.getCount()-1);
			rowData.set("IncId",IncId);
			rowData.set("IncCode",record.get('IncCode'));
			rowData.set("IncDesc",record.get('IncDesc'));
			rowData.set("UomId",record.get('ReqUomId'));
			rowData.set("Uom",record.get('ReqUom'));
			rowData.set("Qty",record.get('ReqQty'));
			rowData.set("DetailIdStr",rowId);
			
			//发送请求获取
			var LocId = Ext.getCmp('LocField').getValue();
			if(LocId!=""){
				Ext.Ajax.request({
					url : 'dhcst.inpurplanaction.csp?actiontype=GetItmInfo&lncId='+ IncId+'&locId='+LocId,
					method : 'POST',
					waitMsg : '查询中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON.decode(result.responseText.replace(/\r/g,"").replace(/\n/g,""));
						if (jsonData.success == 'true') {
							var data=jsonData.info.split("^");
							rowData.set("Rp",data[8]);
							rowData.set("VendorId",data[0]);
							rowData.set("Vendor",data[1]);
						} 
					},
					scope : this
				});
			}else{
				Msg.info("error", "请选择科室!");
			}
		}
	}
};

//取消请求单明细
var singleDeSelectFun = function(record){
	//获取药品的Id的Index
	var index = gridDs.findExact('IncId',record.get('IncId'));
	if(index>=0){
		var rowData = grid.getStore().getAt(index);
		var qty = parseInt(rowData.get('Qty'))-parseInt(record.get('ReqQty'));
		if(qty==0){
			gridDs.remove(rowData);
		}else{
			rowData.set("Qty",qty);
			var rowId = record.get('RowId');
			var arr = rowData.get('DetailIdStr').split("^");
			var length = arr.length;
			var newDetailId = "";
			for(var i=0;i<length;i++){
				detailId = arr[i];
				if(detailId!=rowId){
					if(newDetailId==""){
						newDetailId = detailId;
					}else{
						newDetailId = newDetailId+"^"+detailId;
					}
				}
			}
			rowData.set("DetailIdStr",newDetailId);
		}
	}
};
//=============请求单主信息与请求单明细二级联动===================
InRequestGrid.on('cellclick',function(grid, rowIndex, columnIndex, e) {
	var selectedRow = InRequestGridDs.data.items[rowIndex];
	InRequestId = selectedRow.data["RowId"];
	InRequestDetailGridDs.proxy = new Ext.data.HttpProxy({url:URL+'?actiontype=queryDetail&parref='+InRequestId,method:'GET'});
	InRequestDetailGridDs.load({params:{start:0,limit:20,sort:'RowId',dir:'desc'}});
	
	if(columnIndex==6){
		if(sm.isSelected(rowIndex)==true){
			InRequestDetailGridDs.addListener('load',function(){
				var records=[];
				var count = InRequestDetailGridDs.getCount();
				for(var i=0;i<count;i++){
					records.push(InRequestDetailGridDs.getAt(i));
				}
				sm1.selectRecords(records);
			});
		}else{
			InRequestDetailGridDs.addListener('load',function(){
				sm1.selectRecords([]);
			});
		}
	}else{
		InRequestDetailGridDs.addListener('load',function(){
			sm1.selectRecords([]);
		});
		sm.selectRecords([]);
	}
});
//=============请求单主信息与请求单明细二级联动===================
//=============请求单明细与采购明细二级联动===================
InRequestDetailGrid.getSelectionModel().on("rowselect",function(sm1,rowIndex,record){
	singleSelectFun(record);
});
InRequestDetailGrid.getSelectionModel().on("rowdeselect",function(sm1,rowIndex,record){
	singleDeSelectFun(record);
});
InRequestGrid.getSelectionModel().on("rowdeselect",function(sm,rowIndex,record){
	InRequestDetailGridDs.addListener('load',function(){
		sm1.selectRecords([]);
	});
});
//=============请求单明细与采购明细二级联动===================

//===========模块主页面===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var formPanel = new Ext.form.FormPanel({
		labelwidth : 30,
		autoScroll:true,
		region:'north',
		labelAlign : 'right',
		height:123,
		frame : true,
		autoScroll : true,
		bodyStyle : 'padding:5px;',
		tbar:[find,'-',clear,'-',edit],
		items : [{
			autoHeight : true,
			layout : 'column',
			items : [{
				xtype : 'fieldset',
				title : '条件选项',
				width:1330,
				autoHeight : true,
				items : [{
					layout : 'column',
					items : [{
						columnWidth : .25,
						layout : 'form',
						items : [LocField]
					},{
						columnWidth : .2,
						layout : 'form',
						items : [startDateField]
					},{
						columnWidth : .2,
						layout : 'form',
						items : [endDateField]
					},{
						columnWidth : .2,
						layout : 'form',
						items : [planNnmber]
					},{
						columnWidth : .15,
						layout : 'form',
						items : [onlyRequest]
					}]
				}]
			}]
		}]
	});
	
	var InRequestPanel = new Ext.Panel({
		deferredRender : true,
		title:'请求单主信息',
		activeTab: 0,
		region:'west',
		height:300,
		width:700,
		collapsible: true,
        split: true,
		minSize: 0,
        maxSize: 700,
		items:[InRequestGrid]                                 
	});
	
	var InRequestDetailPanel = new Ext.Panel({
		deferredRender : true,
		title:'请求单明细信息',
		activeTab: 0,
		region:'center',
		height:300,
		width:1200,
		items:[InRequestDetailGrid]                                 
	});
	
	var gridPanel = new Ext.Panel({
		deferredRender : true,
		title:'采购明细',
		activeTab: 0,
		region:'south',
		height:287,
		items:[grid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[formPanel,InRequestPanel,InRequestDetailPanel,gridPanel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面===========================================