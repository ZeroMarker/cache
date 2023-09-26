// 名称:主管部门审核并拆分为计划或者进行出库

var guserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var gLocId=session['LOGON.CTLOCID'];
var url = 'dhcstm.inrequestaction.csp';

//取参数配置
if(gParam==null ||gParam.length<1){
	GetParam();
}

//起始日期
var startDate = new Ext.ux.DateField({
	id:'startDate',
	fieldLabel:'起始日期',
	value:DefaultStDate()
});

//截止日期
var endDate = new Ext.ux.DateField({
	id:'endDate',
	fieldLabel:'截止日期',
	value:DefaultEdDate()
});

//类组
var groupField = new Ext.ux.StkGrpComboBox({
	id:'groupField',
	StkType:App_StkTypeCode,
	LocId:gLocId,
	UserId:guserId
});

var SupplyLoc = new Ext.ux.LocComboBox({
			fieldLabel : '供应部门',
			id : 'SupplyLoc',
			name : 'SupplyLoc',
			emptyText : '供应部门...',
			groupId : gGroupId
		});
var Loc = new Ext.ux.LocComboBox({
			id : 'Loc',
			fieldLabel : '请求部门',
			emptyText : '请求部门...',
			defaultLoc : {}
		});
var ProvLocAudited= new Ext.form.Checkbox({
	id: 'ProvLocAudited',
	fieldLabel:'已审核',
	allowBlank:true
});
var Type = new Ext.grid.CheckColumn({
	header:'采购标志',
	dataIndex:'Type',
	sortable:true,
	width:60
});
var fB = new Ext.ux.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	handler:function(){
		var scgStr=getScgStr();  ///类组串
		var startDate = Ext.getCmp('startDate').getValue();
		if(!Ext.isEmpty(startDate)){
			startDate = startDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","请选择起始日期!");
			return false;
		}
		var endDate = Ext.getCmp('endDate').getValue();
		if(!Ext.isEmpty(endDate)){
			endDate = endDate.format(ARG_DATEFORMAT);
		}else{
			Msg.info("error","请选择截止日期!");
			return false;
		}
		var toLocId = Ext.getCmp('Loc').getValue();
		var frLocId = Ext.getCmp('SupplyLoc').getValue();
		if(Ext.isEmpty(frLocId)){
			Msg.info("error","请选择供应部门!");
			return false;
		}
		var isProvLocAudited= (Ext.getCmp('ProvLocAudited').getValue()==true?'Y':'N');
		var strPar = startDate+"^"+endDate+"^"+toLocId+"^"+frLocId+"^"+isProvLocAudited+"^"+scgStr;
	    OrderDs.setBaseParam('strPar',strPar);
		OrderDs.removeAll();
		OrderDs.load({
			params:{start:0,limit:9999},
			callback:function(r,options,success){
				if(!success){
					Msg.info("warning","查询有误,请查看日志!");
					return;
				}
			}
		});
	}
});
// 拒绝申请按钮
	var refDetailBT = new Ext.Toolbar.Button({
				text : '拒绝一条明细',
				tooltip : '点击拒绝转移信息',
				iconCls : 'page_gear',
				height:30,
				width:70,
				handler : function() {
					refDetail();
				}
			});	
	/////拒绝申请明细
	function refDetail(){		
		var selectRow=Grid.getSelectionModel().getSelected();
		if (Ext.isEmpty(selectRow)){
			  Msg.info("warning", "请选择要拒绝的明细记录!");
			  return;
		}
		var reqi=selectRow.get("reqi");
		var url=DictUrl+"inrequestaction.csp?actiontype=refuse&reqi="+reqi;
		var responsetext=ExecuteDBSynAccess(url);
		var jsonData = Ext.util.JSON.decode(responsetext);
	
		if (jsonData.success == 'true') {
			// 刷新界面
          Msg.info("success", "拒绝申请单明细成功!");
			Grid.getStore().reload()

		} else {
			Msg.info("error", "拒绝申请单失败!");
		
		}	
	 }
// 变换行颜色
function changeBgColor(row, color) {
	Grid.getView().getRow(row).style.backgroundColor = color;
}
var cB = new Ext.ux.Button({
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	handler:function(){
		clearData();
	}
});
function clearData() {
	Ext.getCmp("Loc").setValue("");
	Ext.getCmp("ProvLocAudited").setValue(false);
	OrderDs.removeAll();
}

var provlocAuditB = new Ext.ux.Button({
	iconCls:'page_delete',
	text:'审核分流',
	handler:function(){
		var ds=Grid.getStore();
		var count=ds.getCount();
		var loc=SupplyLoc.getValue()
		if(Ext.isEmpty(loc)){Msg.info("warning","供给科室不能为空!"); return}
		var StrParam=loc+"^"+gGroupId+"^"+guserId
		var Cstr=""  ///计划串
		var Ostr=""	 ///出库串
		for (var i=0;i<count;i++)
		{	
			var rec=ds.getAt(i)
		    var provLocAudited=rec.get('ProvLocAudited');
		    var Type=rec.get('Type');
		    var reqi=rec.get('reqi');
			if (provLocAudited=="Y"){continue}
			if (Type=="Y")
				{
					if(Cstr==""){Cstr=reqi} 
					else{Cstr=Cstr+"^"+reqi}
				}
			else
				{
				if(Ostr==""){Ostr=reqi} 
				else{Ostr=Ostr+"^"+reqi}	
				}
			
			
			
		}
	
		if(Cstr==""&&Ostr==""){Msg.info("warning","没有需要审核处理的数据!"); return}
		provlocAudit(Cstr,Ostr,StrParam);	
	}
});

var OrderDs = new Ext.data.JsonStore({
	url:url+'?actiontype=QuerySplitDetail',
	root:'rows', 
	fields:[
		{name:'reqi'},
		{name:'reqNo'},
		{name:'recLocDesc'},
		{name:'reqUserName'},
		{name:'reqDate'},
		{name:'reqInci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'reqUomDesc'},
		{name:'reqQty'},
		{name:'qty'},
		{name:'QtyApproved'},
		{name:'SpecList'},
		{name:'Type'},
		{name:'manf'},
		{name:'ProvLocAudited'},
		{name:'Vendor'},
		{name:'remark'}
		
	],
	remoteSort: false
});
var OrderCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header: 'rowid',
		dataIndex: 'reqi',
		width: 100,
		hidden:true,
		align: 'left'
	},{
		header: '请求单号',
		dataIndex: 'reqNo',
		width: 120,
		sortable:true,
		align: 'left'
	},{
		header: '请求部门',
		dataIndex: 'recLocDesc',
		width: 100,
		sortable:true,
		align: 'left'
	},{
		header:'请求人',
		dataIndex: 'reqUserName',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header: "请求日期",
		dataIndex: 'reqDate',
		width: 100,
		align: 'left',
		sortable: true
	},{
		header:'已审核',
		dataIndex:'ProvLocAudited',
		align:'center',
		width:80,
		xtype : 'checkcolumn'
	},{
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
		header: "单位",
		dataIndex: 'reqUomDesc',
		width: 72,
		align: 'left',
		sortable: true
	},{
		header: "请求数量",
		dataIndex: 'reqQty',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header: "库存数量",
		dataIndex: 'qty',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header: "批准数量",
		dataIndex: 'QtyApproved',
		width: 80,
		align: 'right',
		editor:new Ext.form.NumberField({selectOnFocus:true})
	},Type,
	{
		header: "具体规格",
		dataIndex: 'SpecList',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header: "供应商",
		dataIndex: 'Vendor',
		width: 80,
		align: 'right',
		sortable: true
	},{
		header: "备注",
		dataIndex: 'remark',
		width: 80,
		align: 'right',
		sortable: true
	}
]);

var Grid = new Ext.ux.EditorGridPanel({
	id:'Grid',
	title:'待分流请求单明细',
	region:'center',
	store:OrderDs,
	cm:OrderCm,
	trackMouseOver: true,
	stripeRows: true,
	plugins:Type,
	sm:new Ext.grid.RowSelectionModel({}),
	loadMask: true,
	viewConfig:{
			getRowClass : function(record,rowIndex,rowParams,store){ 
				var qty=parseInt(record.get("qty"));
				var reqQty=parseInt(record.get("reqQty"));
				var ProvLocAudited=Ext.getCmp("ProvLocAudited").getValue();
				if(!ProvLocAudited){
					if(qty<reqQty){
						return 'classRed';
					}
				}
			}
		},
	listeners:{
		'beforeedit':function(e){
			
			if(e.record.get('ProvLocAudited')=='Y'){
				e.cancel = true;
			}
		},
		'afteredit':function(e){
			if(e.field=="QtyApproved"){
				var QtyApproved=e.value
				var reqi=e.record.get('reqi')
				var ret=tkMakeServerCall("web.DHCSTM.INRequestSplit","UpdateQtyApproved",reqi,QtyApproved)
				if(ret==0){e.record.commit();}
			}
		}
		}
	
});

var conPanel = new Ext.ux.FormPanel({
	region:'north',
	title:'请求单审核分流',
	height:180,
	tbar:[fB,'-',cB,'-',provlocAuditB,'-',refDetailBT],
	items:[{
		xtype:'fieldset',
		title:'查询条件',
		frame:true,
		items:[{
			layout:'column',
			items:[
				{columnWidth:.3,layout:'form',items:[startDate,endDate]}
				,
				{columnWidth:.3,layout:'form',items:[SupplyLoc,Loc]}
				,
				{columnWidth:.4,layout:'form',items:[ProvLocAudited]}		
			]
		}]
	}]
});

function provlocAudit(Cstr,Ostr,StrParam)
{
	Ext.Ajax.request({
		url:url+"?actiontype=SplitDetail",
		method : 'POST',
		params:{Cstr:Cstr,Ostr:Ostr,StrParam:StrParam},
		success:function(result, request){
			 var jsonData = Ext.util.JSON.decode(result.responseText);
			 if (jsonData.success=='true')
			 {
			 	Msg.info('success','审核成功!');
			 	Grid.getStore().reload();
			 }
			 else
			 {
			 	Msg.info('error','审核失败!');
			 }			 
		}
	})
}
/*取登录者的授权类组串*/
function getScgStr()
{
	var str="";
	var st=groupField.getStore();
	var c=st.getCount();
	for (var i=0;i<c;i++)
	{
		var rec=st.getAt(i)
		var scg=rec.get('RowId');
		if (str=="") str=scg
		else
		 str=str+","+scg
	}
	return str
}
	
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[conPanel,Grid]
	});
});
