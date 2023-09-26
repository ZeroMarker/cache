//描述:	库存请领-请求方审核

var url = 'dhcstm.inrequestaction.csp';
var CtLocId = session['LOGON.CTLOCID'];
var CompletedFlag='Y';
//初始化公共参数
if(gParam.length<1){
	GetParam(); 
}
//起始日期
var startDate = new Ext.ux.DateField({
	id:'startDate',
	//width:210,
	listWidth:210,
	allowBlank:true,
	fieldLabel:'起始日期',
	anchor:'95%',
	value:DefaultStDate()
});
//截止日期
var endDate = new Ext.ux.DateField({
	id:'endDate',
	//width:210,
	listWidth:210,
	allowBlank:true,
	fieldLabel:'截止日期',
	anchor:'95%',
	value:DefaultEdDate()
});

var Loc = new Ext.ux.LocComboBox({
	id:'Loc',
	anchor:'95%',
	fieldLabel:'请求部门',
	emptyText:'请求部门...',
	protype : INREQUEST_LOCTYPE,
	linkloc:CtLocId,
	groupId:session['LOGON.GROUPID']
});

/*
var SupplyLoc = new Ext.ux.LocComboBox({
	id:'SupplyLoc',
	fieldLabel:'供给部门',
	anchor:'95%',
	emptyText:'供给部门...',
	defaultLoc:{}
});
*/

//var SupplyLoc = new Ext.ux.ComboBox({
//	id:'SupplyLoc',
//	fieldLabel:'供给部门',
//	anchor:'95%',
//	store:frLocListStore,
//	displayField:'Description',
//	valueField:'RowId',
//	listWidth:210,
//	emptyText:'供给部门...',
//	//groupId:gGroupId,
//	params:{LocId:'Loc'}
//});


var TypeStore=new Ext.data.SimpleStore({
	fields:['RowId','Description'],
	data:[['O','临时请求'],['C','申领计划']]
})
var reqType=new Ext.form.ComboBox({
	id:'reqType',
	fieldLabel:'请求单类型',
	store:TypeStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'请求单类型...',
	triggerAction:'all',
	anchor:'95%',
	minChars:1,
	selectOnFocus:true,
	forceSelection:true,
	editable:true,
	mode:'local'
});

var RecLocAudited= new Ext.form.Checkbox({
	id: 'RecLocAudited',
	boxLabel:'已审核通过',
	hideLabel : true
});

var INRQPreFlag= new Ext.form.Checkbox({     
	id: 'INRQPreFlag',
	boxLabel:'仓库拒绝',
	hideLabel : true
});
var includeDefLoc=new Ext.form.Checkbox({
		id: 'includeDefLoc',
		fieldLabel:'包含支配科室',
		checked:true,
		allowBlank:true
});
var fB = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var startDate = Ext.getCmp('startDate').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","请选择起始日期!");
			return false;
		}
		var endDate = Ext.getCmp('endDate').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","请选择截止日期!");
			return false;
		}
		
		var toLocId = Ext.getCmp('Loc').getValue();
		if((toLocId=="")||(toLocId==null)){
			Msg.info("error","请选择请求部门!");
			return false;
		}
//		var frLocId = Ext.getCmp('SupplyLoc').getValue();
//		var frLocId=toLocId  //使用请求科室做供应科室 zhwh 2014-02-20
		var frLocId="";
		var comp=CompletedFlag;
		
		var isRecLocAudited = (Ext.getCmp('RecLocAudited').getValue()==true?'Y':'N');
		var isProvLocAudited = "";
		var isINRQPreFlag = (Ext.getCmp('INRQPreFlag').getValue()==true?'Y':'N');
		var noTrans = 1, partTrans = 1, allTrans = 0;
		var tranStatus = noTrans+"%"+partTrans+"%"+allTrans;
		var reqtype=Ext.getCmp('reqType').getValue();
		
		var includeDefLoc=(Ext.getCmp('includeDefLoc').getValue()==true?"Y":"");  //是否包含支配科室
		//alert(reqtype)
		var strPar = startDate+"^"+endDate+"^"+toLocId+"^"+frLocId+"^"+comp
				+"^"+tranStatus+"^"+isRecLocAudited+"^"+isProvLocAudited+"^"+reqtype+"^"+isINRQPreFlag+"^^^^^^"+includeDefLoc;
		OrderDs2.removeAll();
		OrderDs.removeAll();
		OrderDs.setBaseParam('sort','');
		OrderDs.setBaseParam('dir','desc');
		OrderDs.setBaseParam('strPar',strPar);
		OrderDs.load({params:{start:0,limit:pagingToolbar3.pageSize}});
	}
});

// 变换行颜色
function changeBgColor(row, color) {
	Grid.getView().getRow(row).style.backgroundColor = color;
}

var cB = new Ext.Toolbar.Button({
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		clearData();
	}
});

function clearData() {
	Ext.getCmp("reqType").setValue("");
	Ext.getCmp("startDate").setValue(DefaultStDate());
	Ext.getCmp("endDate").setValue(DefaultEdDate());
	Ext.getCmp("RecLocAudited").setValue(false);
	Ext.getCmp("INRQPreFlag").setValue(false);
	OrderDs.removeAll();
	OrderDs2.removeAll();
}

var recLocAuditB = new Ext.Toolbar.Button({
	iconCls:'page_gear',
	height:30,
	width:70,
	text:'审核通过',
	tooltip:'请求方审核通过',
	handler:function(){
		var rec=Grid.getSelectionModel().getSelected();
		if (!rec) return;
		var req=rec.get('req');
		reclocAudit(req);
	}
});
var recLocDeniedB = new Ext.Toolbar.Button({
	iconCls:'page_delete',
	height:30,
	width:70,
	text:'审核不通过',
	tooltip:'请求方审核不通过',
	handler:function(){
		var rec=Grid.getSelectionModel().getSelected();
		if (!rec) return;
		var req=rec.get('req');
		reclocDeny(req);
	}
});

var OrderProxy= new Ext.data.HttpProxy({url:url+'?actiontype=query',method:'GET'});
var OrderDs = new Ext.data.Store({
	proxy:OrderProxy,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	}, [
		{name:'req'},
		{name:'reqNo'},
		{name:'toLoc'},
		{name:'toLocDesc'},
		{name:'frLoc'},
		{name:'frLocDesc'},
		{name:'reqUser'},
		{name:'userName'},
		{name:'date'},
		{name:'time'},
		{name:'status'},
		{name:'comp'},
		{name:'RecLocAudited'},
		{name:'ProvLocAudited'},
		{name:'remark'},
		{name:'reqType'},
		{name:'scgDesc'},
		{name:'Auditdate'},
		{name:'preFlag'}
	]),
	remoteSort: false,
	listeners : {
		load : function(store,records,options){
			if (records.length > 0){
				Grid.getSelectionModel().selectFirstRow();
				Grid.getView().focusRow(0);
				for (var i = 0, rowCount = records.length; i < rowCount; i++) {
					var rowData = OrderDs.getAt(i);
					var preFlag = rowData.get("preFlag");
					if (preFlag == "Y") {
						changeBgColor(i, "red");
					}
				}
			}
		}
	}
});


var OrderCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: 'rowid',
		dataIndex: 'req',
		width: 100,
		hidden:true,
		align: 'left'
	},{
		header: '请求类型',
		dataIndex: 'reqType',
		width: 80,
		sortable:true,
		align: 'left',
		renderer:function(v){
			//alert(v);
			if (v=='O') {return "临时请求";}
			if (v=='C') {return '申领计划';}
			return '其他';
		}
	},{
		header: '请求单号',
		dataIndex: 'reqNo',
		width: 140,
		sortable:true,
		align: 'left'
	},{
		header: '请求部门',
		dataIndex: 'toLocDesc',
		width: 120,
		sortable:true,
		align: 'left'
	},{
		header: "供给部门",
		dataIndex: 'frLocDesc',
		width: 120,
		align: 'left',
		sortable: true
	},{
		header: "制单人",
		dataIndex: 'userName',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "日期",
		dataIndex: 'date',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "时间",
		dataIndex: 'time',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "转移状态",
		dataIndex: 'status',
		width: 80,
		align: 'left',
		renderer:function(value){
			var status="";
			if(value==0){
				status="未转移";
			}else if(value==1){
				status="部分转移";
			}else if(value==2){
				status="全部转移";
			}
			return status;
		},
		sortable: true
	},{
		header:'请求方审核',
		dataIndex:'RecLocAudited',
		align:'center',
		width:80,
		xtype : 'checkcolumn'
	},{
		header: "审核日期",
		dataIndex: 'Auditdate',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header:'供应方审核',
		dataIndex:'ProvLocAudited',
		align:'center',
		width:80,
		xtype : 'checkcolumn'
	},{
		header:'备注',
		dataIndex:'remark',
		width:130,
		align:'left'
	},{
		header:'仓库是否拒绝',
		dataIndex:'preFlag',
		width:80,
		align:'center',
		xtype : 'checkcolumn'
	}
]);

var pagingToolbar3 = new Ext.PagingToolbar({
	store:OrderDs,
	pageSize:20,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条'
});

var Grid = new Ext.grid.GridPanel({
	region:'center',
	store:OrderDs,
	cm:OrderCm,
	trackMouseOver: true,
	stripeRows: true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask: true,
	bbar:pagingToolbar3
});

var OrderProxy2= new Ext.data.HttpProxy({url:url+'?actiontype=queryDetail',method:'GET'});
var OrderDs2 = new Ext.data.Store({
	proxy:OrderProxy2,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	}, [
		{name:'rowid'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'qty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'spec'},
		{name:'manf'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'rp'},
		{name:'rpAmt'},		
		{name:'generic'},
		{name:'drugForm'},
		{name:'remark'}
	]),
	remoteSort: false
});

var OrderCm2 = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: '代码',
		dataIndex: 'code',
		width: 72,
		sortable:true,
		align: 'left'
	},{
		header: '名称',
		dataIndex: 'desc',
		width: 140,
		sortable:true,
		align: 'left'
	},{
		header:'规格',
		dataIndex:'spec',
		align:'left',
		width:80,
		sortable:true
	},{
		header: "厂商",
		dataIndex: 'manf',
		width: 80,
		align: 'left',
		sortable: true
	},{
		header: "请求数量",
		dataIndex: 'qty',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header: "单位",
		dataIndex: 'uomDesc',
		width: 72,
		align: 'left',
		sortable: true
	},{
		header:'售价',
		dataIndex:'sp',
		xtype:'numbercolumn',
		align:'right',
		width:80,
		sortable:true
	},{
		header: "售价金额",
		dataIndex: 'spAmt',
		xtype:'numbercolumn',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header:'进价',
		dataIndex:'rp',
		xtype:'numbercolumn',
		align:'right',
		width:80,
		sortable:true
	},{
		header: "进价金额",
		dataIndex: 'rpAmt',
		xtype:'numbercolumn',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header:'备注',
		dataIndex:'remark',
		align:'left',
		width:80,
		sortable:true
	}
]);
var pagingToolbar4=new Ext.PagingToolbar({
				store:OrderDs2,
				pageSize:20,
				displayInfo:true,
				displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条'
		});

var Grid2 = new Ext.grid.GridPanel({
	region:'south',
	height:240,
	store:OrderDs2,
	cm:OrderCm2,
	trackMouseOver: true,
	stripeRows: true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	loadMask: true,
	bbar:pagingToolbar4
});

Grid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
	OrderDs2.removeAll();
	var jReq =  OrderDs.data.items[rowIndex].data["req"];
	OrderDs2.setBaseParam('req',jReq);
	OrderDs2.setBaseParam('sort','rowid');
	OrderDs2.setBaseParam('dir','desc');
	OrderDs2.setBaseParam('canceled','N');
	OrderDs2.load({params:{start:0,limit:pagingToolbar4.pageSize}});
});

var conPanel = new Ext.ux.FormPanel({
	tbar:[fB,'-',cB,'-',recLocAuditB,'-',recLocDeniedB],
	title:'请求单审核(请求部门)',
	bodyStyle:'padding:5px 0 0 0',
	labelWidth: 100,
	items:[{
		xtype:'fieldset',
		title:'查询条件',
		bodyStyle:'padding:5px 0 0 5px;',
		layout:'column',
		items:[
			{columnWidth:.2,layout:'form',items:[startDate,endDate]},
			{columnWidth:.3,layout:'form',items:[Loc,reqType]},
			{columnWidth:.1,layout:'form',items:[RecLocAudited,INRQPreFlag]},
			{columnWidth:.3,layout:'form',items:[includeDefLoc]}
		]
	}]
});

function reclocAudit(req)
{
	Ext.Ajax.request({
		url:url+"?actiontype=ReqSideAudit&req="+req,
		success:function(result, request){
			var jsonData = Ext.util.JSON.decode(result.responseText);
			if (jsonData.success=='true'){
				Msg.info('success','审核通过成功!');
				OrderDs2.removeAll();
				Grid.getStore().reload();
			}else{
				var info=jsonData.info;
				switch (info)
				{
					case '-1':{
						Msg.info('error','该单已经审核！');break;
					}
					case '-2':{
						Msg.info('error','审核失败!');break;
					}
					case '-9':{
						Msg.info('error','生成子表失败!');break;
					}
					default:{
						Msg.info('error','审核失败!');break;
					}
				}
			 }
		},
		failure:function(){Msg.info('failure','审核失败!');}
	})
}
/*拒绝*/
function reclocDeny(req)
{
	Ext.Ajax.request({
		url:url+"?actiontype=ReqSideDeny&req="+req,
		success:function(result, request){
			 var jsonData = Ext.util.JSON.decode(result.responseText);
			 if (jsonData.success=='true')
			 {
			 	Msg.info('success','审核不通过成功!');
			 	OrderDs2.removeAll();
			 	Grid.getStore().reload();
			}else{
				var info=jsonData.info;
				switch (info){
					case '-1':
						Msg.info('error','该单已经审核！');
						break;
					case '-99':
						Msg.info('error','审核失败!');
						break;
			 		default:
			 			Msg.info('error','审核失败!');
			 			break;
				}
			}
		},
		failure:function(){Msg.info('failure','审核失败!');}
	})
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[conPanel, Grid, Grid2],
		renderTo:'mainPanel'
	});
});	
	
