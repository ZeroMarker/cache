// 名称:采购计划单----请求转移
// 编写日期:2012-06-27
//=========================定义全局变量=================================
var InRequestId = "";
var CtLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var GroupId=session['LOGON.GROUPID']
var arr = window.status.split(":");
var length = arr.length;
var URL = 'dhcst.inpurplanaction.csp';
var strParam = "";
var scgflag=""
var stkGrpId=""
if(gParamCommon.length<1){
	GetParamCommon();  
}
var LocField = new Ext.ux.LocComboBox({
	id:'LocField',
	fieldLabel:'供应科室',
	anchor:'90%',
	listWidth:210,
	emptyText:'供应科室...',
	groupId:session['LOGON.GROUPID']
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	width:150,
	listWidth:150,
    allowBlank:true,
	fieldLabel:'起始日期',
	anchor:'90%',
	value:DefaultStDate()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	width:150,
	listWidth:150,
    allowBlank:true,
	fieldLabel:'截止日期',
	anchor:'90%',
	value:DefaultEdDate()
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
	checked:true,
	allowBlank:true
});

var onlyNoTrans = new Ext.form.Checkbox({
	id: 'onlyNoTrans',
	fieldLabel:'仅未转移药品',
	checked:true,
	allowBlank:true
});

var find = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		InRequestGridDs.removeAll();
		var locId = Ext.getCmp('LocField').getValue();
		if(locId==""){
			Msg.info("warning","请选择需要查询的供应科室!");
			return;
		}
		var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(App_StkDateFormat);
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(App_StkDateFormat);
		}
		var requestType = (Ext.getCmp('onlyRequest').getValue()==true?'C':"");
		//strParam:供应科室RowId^起始日期^截止日期^请求单类型
		strParam = locId+"^"+startDate+"^"+endDate+"^"+requestType+"^"+UserId;
		InRequestGridDs.setBaseParam('strParam',strParam);
		
		InRequestDetailGrid.store.removeAll();
		grid.store.removeAll();
		InRequestGridDs.removeAll();
		InRequestGridDs.load({params:{start:0,limit:InRequestPagingToolbar.pageSize,sort:'RowId',dir:'desc'}});
	}
});

var clear = new Ext.Toolbar.Button({
	text:'清屏',
    tooltip:'清屏',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		SetLogInDept(LocField.getStore(),"LocField")
		Ext.getCmp('startDateField').setValue(DefaultStDate());
		Ext.getCmp('endDateField').setValue(DefaultEdDate());
		Ext.getCmp('onlyRequest').setValue(true);
		Ext.getCmp('onlyNoTrans').setValue(true);
		Ext.getCmp('planNnmber').setValue("");		
		InRequestGrid.getStore().removeAll();
		InRequestGrid.getView().refresh();		
		InRequestDetailGrid.getStore().removeAll();
		InRequestDetailGrid.getView().refresh();
		grid.getStore().removeAll();
		grid.getView().refresh();
	}
});

var edit = new Ext.Toolbar.Button({
	text:'生成采购计划',
    tooltip:'生成采购计划',
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
		if(listReqId==""){
			Msg.info("warning","请选择需要生成采购计划的数据!");
			return;
		}
		var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
		Ext.Ajax.request({
			url:URL,
			method:'POST',
			params:{actiontype:'create',userId:UserId,locId:locId,listReqId:listReqId,stkGrpId:stkGrpId},
			success:function(result,request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if(jsonData.success=='true'){
					window.location.href="dhcst.inpurplan.csp?planNnmber="+jsonData.info+'&locId='+locId;
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
						Msg.info("error","生成计划单明细失败!"+jsonData.info);
					}else{
						Msg.info("error","生成采购计划单失败!"+jsonData.info);
					}
				}
				loadMask.hide();
			},
			scope:this
		});
	}
});
//=========================定义全局变量=================================
//=========================请求单主信息=================================
var sm = new Ext.grid.CheckboxSelectionModel({
	header:"",
	checkOnly:true,
	listeners:{
		beforerowselect:function(sm){if(sm.getCount()==0){scgflag=""}}
	}
}); 

var InRequestGrid="";
//配置数据源
var InRequestGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=INReqM',method:'GET'});
var InRequestGridDs = new Ext.data.Store({
	proxy:InRequestGridProxy,
	reader:new Ext.data.JsonReader({
		totalProperty : "results",
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'ReqNo'},
		{name:'ReqLocId'},
		{name:'ReqLoc'},
		{name:'StkGrpId'},
		{name:'StkGrp'},
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
        header:"类组",
        dataIndex:'StkGrp',
        width:70,
        align:'left',
        sortable:true
    },{
        header:"制单日期",
        dataIndex:'Date',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"制单时间",
        dataIndex:'Time',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"制单人",
        dataIndex:'User',
        width:60,
        align:'left',
        sortable:true
    }//,sm
]);

//初始化默认排序功能
InRequestGridCm.defaultSortable = true;

var InRequestPagingToolbar = new Ext.PagingToolbar({
    store:InRequestGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录"
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
	bbar:InRequestPagingToolbar
});
//=========================请求单主信息=================================

//=========================请求单明细=============================
var sm1 = new Ext.grid.CheckboxSelectionModel({
	checkOnly:true
});
var InRequestDetailGrid="";
//配置数据源
var InRequestDetailGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=INReqD',method:'GET'});
var InRequestDetailGridDs = new Ext.data.Store({
	proxy:InRequestDetailGridProxy,
	reader:new Ext.data.JsonReader({
		totalProperty : "results",
		root:'rows'
	}, [
		{name:'RowId'},
		{name:'IncId'},
		{name:'IncCode'},
		{name:'IncDesc'},
		{name:'Locqty'},
		{name:'ReqQty'},
		{name:'TransQty'},
		{name:'ReqUomId'},
		{name:'ReqUom'}
	]),
    remoteSort:true,
    pruneModifiedRecords:true
});

//模型
var InRequestDetailGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),{
        header:"代码",
        dataIndex:'IncCode',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'IncDesc',
        width:180,
        align:'left',
        sortable:true
    },{
        header:"单位",
        dataIndex:'ReqUom',
        width:80,
        align:'left',
        sortable:true
     },{
        header:"本科室数量",
        dataIndex:'Locqty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"请求数量",
        dataIndex:'ReqQty',
        width:80,
        align:'right',
        sortable:true
    },{
        header:"已转移数量",
        dataIndex:'TransQty',
        width:100,
        align:'right',
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
    emptyMsg:"没有记录"
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
	deferRowRender:false
	//不适合使用分页工具条
//	,
//	bbar:InRequestDetailPagingToolbar
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
		{name:'Locqty'},
		{name:'Qty'},
		{name:'Rp'},
		{name:'VendorId'},
		{name:'Vendor'},
		{name:'DetailIdStr'},
		{name:'ManfredId'},
		{name:'Manf'}
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
        header:"本科室数量",
        dataIndex:'Locqty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"请求数量",
        dataIndex:'Qty',
        width:100,
        align:'right',
        sortable:true
   },{
        header:"已转移数量",
        dataIndex:'TransQty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"进价",
        dataIndex:'Rp',
        width:100,
        align:'right',
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
        width:200,
        align:'left',
        sortable:true
    },{
        header:"请求明细rowId",
        dataIndex:'DetailIdStr',
        width:300,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"厂商Id",
        dataIndex:'ManfId',
        width:200,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"厂商",
        dataIndex:'Manf',
        width:200,
        align:'left',
        sortable:true
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
	if((Ext.getCmp('onlyNoTrans').getValue()==true)&&(record.get('TransQty')==record.get('ReqQty'))){return;}
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
	///类组不相符合时,不允许添加,yunhaibao20151012
	if (gridDs.getCount()>0){
		var tmpRowData = grid.getStore().getAt(gridDs.getCount()-1);
		var AddIncId=tmpRowData.get("IncId");
		var tmpscgdescstr=tkMakeServerCall("web.DHCST.Common.DrugInfoCommon","GetIncStkCatGrp",IncId)  //明细类组
		var tmpstkgrpdescstr=tkMakeServerCall("web.DHCST.Common.DrugInfoCommon","GetIncStkCatGrp",AddIncId)  //已加入列表类组
		if(gParamCommon[9]!="Y"){
			if (tmpstkgrpdescstr!=tmpscgdescstr){
				//Msg.info("warning", "请选择类组相同的生成采购计划单!");
				return;
			}
		}		
	}		
	if(bool==false){
		if(index>=0){
			var rowData = gridDs.getAt(index);
			rowData.set("Qty",accAdd(rowData.get('Qty'),record.get('ReqQty')));
			rowData.set("TransQty",accAdd(rowData.get('TransQty'),record.get('TransQty')));
			rowData.set("DetailIdStr",rowData.get('DetailIdStr')+"^"+rowId);
		}else{
			addNewMXRow();
			var rowData = grid.getStore().getAt(gridDs.getCount()-1);
			rowData.set("IncId",IncId);
			rowData.set("IncCode",record.get('IncCode'));
			rowData.set("IncDesc",record.get('IncDesc'));
			rowData.set("UomId",record.get('ReqUomId'));
			rowData.set("Uom",record.get('ReqUom'));
			rowData.set("Locqty",record.get('Locqty'));
			rowData.set("TransQty",record.get('TransQty'));
			rowData.set("Qty",record.get('ReqQty'));
			rowData.set("DetailIdStr",rowId);
			//发送请求获取
			var LocId = Ext.getCmp('LocField').getValue();
			
           var Params=GroupId+"^"+LocId+"^"+UserId
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
							rowData.set("ManfId",data[2]);
							rowData.set("Manf",data[3]);
							//==========供应商资质判断==========
							var vendor=data[0]
							var inci=rowData.get("IncId")
							var phmanf=data[2]
							var DataList=vendor+"^"+inci+"^"+phmanf
						 	Ext.Ajax.request({
						        url : 'dhcst.inpurplanaction.csp?actiontype=Check&DataList='+ DataList,
						        method : 'POST',
						        waitMsg : '查询中...',
						        success : function(result, request) {
							    var jsonData = Ext.util.JSON
									  .decode(result.responseText);
							    if (jsonData.success == 'true') {
								var ret=jsonData.info
								//alert("data="+data)
								if(ret==1)  
								{Msg.info("warning", "供应商工商执照将在30天内过期!");
										return;}
								if(ret==3)  
								{Msg.info("warning", "供应商税务登记号将在30天内过期!");
										return;}
							    if(ret==4)  
								{Msg.info("warning", "供应商药品经营许可证将在30天内过期!");
										return;}
										
								if(ret==5)  
								{Msg.info("warning", "供应商医疗器械经营许可证将在30天内过期!");
										return;}
								if(ret==6)  
								{Msg.info("warning", "供应商医疗器械注册证将在30天内过期!");
										return;}
								if(ret==7)  
								{Msg.info("warning", "供应商卫生许可证将在30天内过期!");
										return;}
								if(ret==8)  
								{Msg.info("warning", "供应商组织机构代码将在30天内过期!");
										return;}
								if(ret==9)  
								{Msg.info("warning", "供应商GSP认证将在30天内过期!");
										return;}
								if(ret==10)  
								{Msg.info("warning", "供应商医疗器械生产许可证将在30天内过期!");
										return;}
								if(ret==11)  
								{Msg.info("warning", "供应商生产制造认可表将在30天内过期!");
										return;}
								if(ret==12)  
								{Msg.info("warning", "供应商进口医疗器械注册证将在30天内过期!");
										return;}
								if(ret==13)  
								{Msg.info("warning", "供应商进口注册登记表将在30天内过期!");
										return;}
								if(ret==14)  
								{Msg.info("warning", "供应商代理销售授权书将在30天内过期!");
										return;}
								if(ret==15)  
								{Msg.info("warning", "供应商质量承诺书将在30天内过期!");
										return;}
								if(ret==16)  
								{Msg.info("warning", "供应商业务员授权书将在30天内过期!");
										return;}
								if(ret==19)  
								{Msg.info("warning", "厂商药品生产许可证将在30天内过期!");
										return;}
								if(ret==20)  
								{Msg.info("warning", "厂商物资生产许可证将在30天内过期!");
										return;}
								if(ret==21)  
								{Msg.info("warning", "厂商工商执照在30天内过期!");
										return;}
								if(ret==22)  
								{Msg.info("warning", "厂商工商注册号将在30天内过期!");
										return;}
								if(ret==23)  
								{Msg.info("warning", "厂商组织机构代码将在30天内过期!");
										return;}																																							
								if(ret==24)		
								{Msg.info("warning", "厂商器械经营许可证将在30天内过期!");
										return;}
								if(ret==26)		
								{Msg.info("warning", "物资批准文号将在30天内过期!");
										return;}
							    if(ret==27)		
								{Msg.info("warning", "物资进口注册证将在30天内过期!");
										return;}
							} 
						},
						scope : this
					});  
							//==========供应商资质判断==========
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
		var qty = accAdd(rowData.get('Qty'),-record.get('ReqQty'));
		var TransQty = accAdd(rowData.get('TransQty'),-record.get('TransQty'));
		if(qty==0){
			gridDs.remove(rowData);
		}else{
			rowData.set("Qty",qty);
			rowData.set("TransQty",TransQty);
		
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
	
	///if(sm.getCount()==0){scgflag="";};
	var selectedRow = InRequestGridDs.data.items[rowIndex];
	InRequestId = selectedRow.data["RowId"];
	var scgdesc=selectedRow.data["StkGrp"];	
	///类组不相符合时,不允许添加,yunhaibao20151012
	if (gridDs.getCount()>0){
		var tmpRowData = gridDs.getAt(gridDs.getCount()-1);
		var AddIncId=tmpRowData.get("IncId");
		var tmpstkgrpdescstr=tkMakeServerCall("web.DHCST.Common.DrugInfoCommon","GetIncStkCatGrp",AddIncId)  //已加入列表类组
		if (tmpstkgrpdescstr.indexOf(scgdesc)<0){
			Msg.info("warning", "请选择类组相同的生成采购计划单!");
			return;
		}		
	}
	if (scgflag==""||scgflag==scgdesc){
		stkGrpId=selectedRow.data["StkGrpId"];
		InRequestDetailGridDs.proxy = new Ext.data.HttpProxy({url:URL+'?actiontype=INReqD',method:'GET'});
		InRequestDetailGridDs.setBaseParam('parref',InRequestId);
		var LocId = Ext.getCmp('LocField').getValue();
		InRequestDetailGridDs.setBaseParam('locId',LocId);
		InRequestDetailGridDs.setBaseParam('start',0);
		//InRequestDetailGridDs.setBaseParam('limit',InRequestDetailPagingToolbar.pageSize);
		InRequestDetailGridDs.setBaseParam('limit',999);
		InRequestDetailGridDs.setBaseParam('sort','RowId');
		InRequestDetailGridDs.setBaseParam('dir','desc')
		
		if(columnIndex==7){
			if(sm.isSelected(rowIndex)==true){
				InRequestDetailGridDs.load({
					callback:function(){
						sm1.selectAll();
					}
				})
			}else{
				InRequestDetailGridDs.load({
					callback:function(){
						var end=InRequestDetailGridDs.getCount();
						sm1.deselectRange(0,end);
					}
				});
			}
		}else{
			InRequestDetailGridDs.load({
					callback:function(){
						if(Ext.getCmp('onlyNoTrans').getValue()==true){
							sm1.selectAll();
						}
					}
				});
		}
	}else{
		Msg.info("warning", "请选择类组相同的生成采购计划单!");
		sm.deselectRow(rowIndex);
	}
});

//=============请求单明细与采购明细二级联动===================
InRequestDetailGrid.getSelectionModel().on("rowselect",function(sm1,rowIndex,record){
	singleSelectFun(record);
});
InRequestDetailGrid.getSelectionModel().on("rowdeselect",function(sm1,rowIndex,record){
	singleDeSelectFun(record);
});
//=============请求单明细与采购明细二级联动===================

//===========模块主页面===========================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var formPanel = new Ext.form.FormPanel({
		labelWidth : 90,
		labelAlign : 'right',
		autoHeight:true,
		frame : true,
		title:'采购计划-依据请求单',
		//bodyStyle : 'padding:5px;',
		tbar:[find,'-',clear,'-',edit],
		items : [{
			layout : 'column',
			xtype:'fieldset',
			title:'查询条件',
			defaults:{border:false},
			style:DHCSTFormStyle.FrmPaddingV,
			items : [{
						columnWidth : .2,
						xtype:'fieldset',
						items : [LocField]
					},{
						columnWidth : .2,
						xtype:'fieldset',
						items : [startDateField]
					},{
						columnWidth : .2,
						xtype:'fieldset',
						items : [endDateField]
					
					},{
						columnWidth : .1,
						xtype:'fieldset',
						items : [onlyRequest]
					},{
						columnWidth : .12,
						xtype:'fieldset',
						items : [onlyNoTrans]
					}]
		}]
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[{
			region:'north',
			height:DHCSTFormStyle.FrmHeight(1),
			layout:'fit',
			items:[formPanel]
		},{
			region:'west',
			title:'请求单信息----<font color=blue>请选择相同类组生成一个采购计划单</font>',
			width:650,
			minSize:150,
			maxSize:300,
			split:true,
			collapsible:true,
			layout:'fit',
			items:[InRequestGrid]
		},{
			region:'center',
			title:'请求单明细信息',
			layout:'fit',
			items:[InRequestDetailGrid]
		},{
			region:'south',
			title:'采购计划单明细信息',
			height:250,
			minSize:200,
			maxSize:350,
			split:true,
			layout:'fit',
			items:[grid]
		}]
	});
});
//===========模块主页面===========================================