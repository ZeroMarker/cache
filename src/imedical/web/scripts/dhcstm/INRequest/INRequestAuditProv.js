// 名称:主管部门审核

var ctLocId = session['LOGON.CTLOCID'];
var UserId = session['LOGON.USERID'];
var url = 'dhcstm.inrequestaction.csp';
var jReq = "";
var CompletedFlag='Y';
var gGroupId=session['LOGON.GROUPID'];

//取参数配置
if(gParam==null ||gParam.length<1){
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
	value:new Date().add(Date.DAY, -7)
});

//截止日期
var endDate = new Ext.ux.DateField({
	id:'endDate',
	//width:210,
	listWidth:210,
	allowBlank:true,
	fieldLabel:'截止日期',
	anchor:'95%',
	value:new Date()
});

//类组
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	StkType:App_StkTypeCode,
	LocId:ctLocId,
	anchor:'90%',
	UserId:session['LOGON.USERID']
});

var linkLocStore=new Ext.data.Store({
	url:'dhcstm.orgutil.csp?actiontype=GetLinkLocations&start=0&limit=999&LocId='+ctLocId,
	reader:new Ext.data.JsonReader({
		totalProperty:'results',
		root:'rows'
	},['RowId','Description']),
	autoLoad:true
});
/*
linkLocStore.load({
			callback:function(r,options,success){
				if(success && r.length>0){
					var rec=linkLocStore.getAt(0);
					if(rec){
						var rowid=rec.get("RowId");		
						SupplyLoc.setValue(rowid);
					}
				}
			}
		});

var SupplyLoc = new Ext.ux.ComboBox({
	id:'SupplyLoc',
	anchor:'95%',
	fieldLabel:'供应部门',
	emptyText:'供应部门...',
	store:linkLocStore,
	displayField:'Description',
	filterName:'Desc',
	valueField:'RowId',
	triggerAction:'all'
});
*/
var SupplyLoc = new Ext.ux.LocComboBox({
	id:'SupplyLoc',
	anchor:'95%',
	fieldLabel:'供应部门',
	emptyText:'供应部门...',
	groupId:gGroupId,
	triggerAction:'all'
});
var Loc = new Ext.ux.LocComboBox({
	id:'Loc',
	fieldLabel:'请求部门',
	anchor:'95%',
	emptyText:'请求部门...',
	defaultLoc:{}
});

var Over = new Ext.form.Checkbox({
	id: 'Over',
	fieldLabel:'完成',
	checked:true,
	allowBlank:true
});

var ProvLocAudited= new Ext.form.Checkbox({
	id: 'ProvLocAudited',
	boxLabel:'已审核通过',
	hideLabel : true
});

var INRQPreFlag= new Ext.form.Checkbox({
	id: 'INRQPreFlag',
	boxLabel:'仓库拒绝',
	hideLabel : true
});

var fB = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		var scgStr=""   ///getScgStr();  ///类组串
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
		var frLocId = Ext.getCmp('SupplyLoc').getValue();
		if((frLocId=="")||(frLocId==null)){
			Msg.info("error","请选择供应部门!");
			return false;
		}
		var comp=CompletedFlag;
		
		var noTrans = 1, partTrans = 1, allTrans = 0;
		var tranStatus = noTrans+"%"+partTrans+"%"+allTrans;
		var isRecLocAudited='Y';	//固定为Y, 未设置请求方审核的已经自动审核(根据auditDate判断)
		var isProvLocAudited= (Ext.getCmp('ProvLocAudited').getValue()==true?'Y':'N');
		var isINRQPreFlag= (Ext.getCmp('INRQPreFlag').getValue()==true?'Y':'N');
		var reqType='';				//申领计划标志

		var strPar = startDate+"^"+endDate+"^"+toLocId+"^"+frLocId+"^"+comp
				+"^"+tranStatus+"^"+isRecLocAudited+"^"+isProvLocAudited+"^"+reqType+"^"+isINRQPreFlag
				+"^"+scgStr+"^"+UserId+"^"+ctLocId;
		OrderDs.setBaseParam('sort','');
		OrderDs.setBaseParam('dir','');
		OrderDs.setBaseParam('strPar',strPar);
		
		OrderDs2.removeAll();
		OrderDs.removeAll();
		OrderDs.load({
			params:{start:0,limit:pagingToolbar3.pageSize},
			callback:function(r,options,success){
				if(!success){
					Msg.info("warning","查询有误,请查看日志!");
					return;
				}else if(r.length>0){
					Grid.getSelectionModel().selectFirstRow();
					Grid.getView().focusRow(0);
				}
				var rowCount = Grid.getStore().getCount();
				for (var i = 0; i < rowCount; i++) {
					var rowData = OrderDs.getAt(i);
					var preFlag = rowData.get("preFlag");
					if (preFlag == "Y") {
						changeBgColor(i, "red");
					}
				}
			}
		});
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
	Ext.getCmp("Loc").setValue("");
	Ext.getCmp("startDate").setValue(new Date());
	Ext.getCmp("endDate").setValue(new Date());
	Ext.getCmp("ProvLocAudited").setValue(false);
	Ext.getCmp("INRQPreFlag").setValue(false);
	OrderDs.removeAll();
	OrderDs2.removeAll();
}

var provlocAuditB = new Ext.Toolbar.Button({
	iconCls:'page_gear',
	height:30,
	width:70,
	text:'审核通过',
	tooltip:'主管部门审核通过',
	handler:function(){
		var sm=Grid.getSelectionModel();
		var records=sm.getSelections();		
		if (records.length==0)
		{
			Msg.info('erro','请选择请求单!');
			return;
		}
		for (var i=0;i<records.length;i++)
		{
//			var rec=Grid.getSelectionModel().getSelected();
			var rec=records[i];
			if (!rec) return;
			var req=rec.get('req');
			var provLocAudited=rec.get('ProvLocAudited');
			
			if ((provLocAudited==false)||(provLocAudited=="N"))
			{provlocAudit(req);	}
			/*保存批准数量修改*/
		}

	}
});

var provLocDeniedB = new Ext.Toolbar.Button({
	iconCls:'page_delete',
	height:30,
	width:70,
	text:'审核不通过',
	tooltip:'主管部门审核不通过',
	handler:function(){
		var rec=Grid.getSelectionModel().getSelected();
		if (!rec) return;
		var req=rec.get('req');
		provlocDeny(req);
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
		{name:'preFlag'}
	]),
	remoteSort: false
});


var sm=new Ext.grid.CheckboxSelectionModel({
//	checkOnly:true
});

var OrderCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),sm,
	{
		header: 'rowid',
		dataIndex: 'req',
		width: 100,
		hidden:true,
		align: 'left'
	},{
		header: '请求单号',
		dataIndex: 'reqNo',
		width: 100,
		sortable:true,
		align: 'left'
	},{
		header: '请求部门',
		dataIndex: 'toLocDesc',
		width: 100,
		sortable:true,
		align: 'left'
	},{
		header: "供应部门",
		dataIndex: 'frLocDesc',
		width: 100,
		align: 'left',
		sortable: true
		//hidden:true
	},{
		header:'制单人',
		dataIndex: 'userName',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header: "日期",
		dataIndex: 'date',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header: "时间",
		dataIndex: 'time',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header:'类组',
		dataIndex:'scgDesc',
		width:100,
		aligh:'left'	
	},{
		header: "其他状态",
		dataIndex: 'status',
		width: 100,
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
		header:'请求类型',
		dataIndex:'reqType',		
		renderer:function(v){
			//alert(v);
			if (v=='O') {return "临时请求";}
			if (v=='C') {return '申领计划';}
			return '其他';
		}
		
	},{
		header:'主管部门审核',
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
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录"
});

var Grid = new Ext.grid.GridPanel({
	region:'center',
	store:OrderDs,
	cm:OrderCm,
	trackMouseOver: true,
	stripeRows: true,
	sm:sm,
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
		{name:'remark'},
		{name:"qtyApproved"}
	]),
	remoteSort: false,
	listeners:{
		'update':function(ds,rec,updresult){
			var record=Grid.getSelectionModel().getSelected();
			var provLocAudited=record.get('ProvLocAudited');
			if ((provLocAudited==true)||(provLocAudited=="Y")){
				Msg.info('error','已审核,不能修改');
				ds.reload();
				return;
			}
			//执行更新
			var inrqi=rec.get("rowid");
			var qtyApproved=rec.get("qtyApproved");
			if(qtyApproved<0){Msg.info('error','数量不能小于0');;return;}
			Ext.Ajax.request({
				url:url+'?actiontype=ModifyQtyApproved&inrqi='+inrqi+'&qtyApproved='+qtyApproved,
				success:function(){
					Msg.info('success','修改成功');
					ds.reload();
				},
				failure:function(){
					Msg.info('error','修改失败');
				}
			})
		},
		'load':function(ds){
			var r=Grid.getSelectionModel().getSelected();
			var cnt=ds.getCount();
			for ( var i=0;i<cnt;i++)
			{
				var rec=ds.getAt(i);
				if  (rec.get('qty')!=rec.get('qtyApproved')){
					Grid2.getView().getRow(i).style.backgroundColor = '#FFFF00';
				}
			}
		}
	}
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
		header: "批准数量",
		dataIndex: 'qtyApproved',
		id:'qtyApproved',
		width: 80,
		align: 'right',
		editor:new Ext.form.NumberField({selectOnFocus:true})
	},{
		header: "单位",
		dataIndex: 'uomDesc',
		width: 72,
		align: 'left',
		sortable: true
	},{
		header:'售价',
		dataIndex:'sp',
		align:'right',
		width:80,
		sortable:true
	},{
		header: "售价金额",
		dataIndex: 'spAmt',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header:'进价',
		dataIndex:'rp',
		align:'right',
		width:80,
		sortable:true
	},{
		header: "进价金额",
		dataIndex: 'rpAmt',
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
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
});

var Grid2 = new Ext.grid.EditorGridPanel({
	region:'south',
	height:240,
	store:OrderDs2,
	cm:OrderCm2,
	trackMouseOver: true,
	stripeRows: true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
	loadMask: true,
	bbar:pagingToolbar4,
	clicksToEdit:true,
	listeners : {
		beforeedit : function(e){
			if(e.field=='qtyApproved' && e.record.get('ProvLocAudited')=='Y'){
				e.cancel = true;
			}
		}
	}
});

Grid.getSelectionModel().on('rowselect',function(sm,rowIndex,rec){
	OrderDs2.removeAll();
	jReq =  OrderDs.data.items[rowIndex].data["req"];
	jReq = jReq;
	OrderDs2.setBaseParam('req',jReq);
	OrderDs2.setBaseParam('sort','');
	OrderDs2.setBaseParam('dir','');
	OrderDs2.setBaseParam('canceled','N');
	if(IsSplit()=="Y"){
		OrderDs2.setBaseParam('handletype','0');
		}
	
	OrderDs2.load({params:{start:0,limit:pagingToolbar4.pageSize}});
});

var conPanel = new Ext.ux.FormPanel({
	title:'请求单审核(主管部门)',
	tbar:[fB,'-',cB,'-',provlocAuditB,'-',provLocDeniedB],
	items:[{
		xtype:'fieldset',
		title:'查询条件',
		style : 'padding:5px 0px 0px 5px',
		layout:'column',
		items:[
			{columnWidth:.2,layout:'form',items:[startDate,endDate]},
			{columnWidth:.3,layout:'form',items:[SupplyLoc,Loc]},
			{columnWidth:.4,layout:'form',items:[ProvLocAudited,INRQPreFlag]}			
		]
	}]
});

function provlocAudit(req)
{
	Ext.Ajax.request({
		url:url+"?actiontype=ProvSideAudit&req="+req,
		success:function(result, request){
			 var jsonData = Ext.util.JSON.decode(result.responseText);
			 if (jsonData.success=='true')
			 {
			 	Msg.info('success','审核通过成功!');
			 	OrderDs2.removeAll();
			 	Grid.getStore().reload();
			 }
			 else
			 {
			 	Msg.info('error','审核通过失败!');
			 }			 
		},
		failure:function(){Msg.info('error','审核通过失败!');}
	})
}
/*审核不通过*/
function provlocDeny(req)
{
	Ext.Ajax.request({
		url:url+"?actiontype=ProvSideDeny&req="+req,
		success:function(result, request){
			 var jsonData = Ext.util.JSON.decode(result.responseText);
			 if (jsonData.success=='true')
			 {
			 	Msg.info('success','审核不通过成功!');
			 	OrderDs2.removeAll();
			 	Grid.getStore().reload();
			 }
			 else
			 {
			 	Msg.info('error','审核不通过失败!');
			 }
			 
		},
		failure:function(){Msg.info('error','审核不通过失败!');}
	})
}

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		collapsible:true,
		split: true,
		items:[conPanel,Grid,Grid2],
		renderTo:'mainPanel'
	});
});
