// 名称:库存发放单审核
// 编写日期:2012-08-28
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];

//保存参数值的object
var InDispParamObj = GetAppPropValue('DHCSTINDISPM');

//科室
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	name:'locField',
	fieldLabel:'科室',
	anchor:'90%',
	groupId:gGroupId
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	allowBlank:false,
	fieldLabel:'开始日期',
	value:new Date().add(Date.DAY,-30)
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	allowBlank:false,
	fieldLabel:'结束日期',
	value:new Date()
});

var AuditedCK = new Ext.form.Checkbox({
	id: 'AuditedCK',
	boxLabel : '已审核',
	allowBlank:true
});

var findIndsAudit = new Ext.Toolbar.Button({
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
			
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","请选择申请部门!");
			return false;
		}
		
		IndsAuditDetailGrid.store.removeAll();
		IndsAuditGridDs.load({
			params : {start:0, limit:IndsAuditPagingToolbar.pageSize}
		});
	}
});

var auditIndsAudit = new Ext.Toolbar.Button({
	text:'审核通过',
	tooltip:'点击审核通过',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var SelReocrds = IndsAuditGrid.getSelectionModel().getSelections();
		if(SelReocrds==null || SelReocrds==undefined){
			Msg.info("warning","请选择需要审核的发放单!");
			return;
		}
		Ext.each(SelReocrds,function(selectedRec){
			Audit(selectedRec);
		});
	}
});

function Audit(selectedRec){
	var mainRowId = selectedRec.get("inds");
	var ACKFlag = selectedRec.get("chkFlag");
	if (ACKFlag=="Y"){
		Msg.info('error','该单据已经审核！');
		return;
	}
	Ext.Ajax.request({
		url: IndsAuditGridUrl+'?actiontype=audit&disp='+mainRowId+'&userId='+UserId,
		failure: function(result, request) {
			Msg.info("error","请检查网络连接!");
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			if (jsonData.success=='true') {
				Msg.info("success","审核通过成功!");
						
				//审核成功就刷新页面
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
				var locId=Ext.getCmp('locField').getValue();
				var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
					
				var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^N";
				
				IndsAuditDetailGridDs.removeAll();
				IndsAuditGridDs.reload();
			}else{
				if(jsonData.info==-1){
					Msg.info("error","已审核!");
				}else if(jsonData.info==-2){
					Msg.info("error","登录用户rowid为空!");
				}else if(jsonData.info==-102){
					Msg.info("error","库存处理出错!");
				}else if(jsonData.info==-103){
					Msg.info("error","插入台账数据出错!");
				}else{
					Msg.info("error","审核失败!"+jsonData.info);
				}
			}
		},
		scope: this
	});
}

var printIndsAudit = new Ext.Toolbar.Button({
	id : "printIndsAudit",
	text : '打印',
	tooltip : '打印发放单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var SelReocrds = IndsAuditGrid.getSelectionModel().getSelections();
		if(SelReocrds==null || SelReocrds==undefined){
			Msg.info("warning","请选择需要打印的发放单!");
			return;
		}
		Ext.each(SelReocrds,function(selectedRec){
			var Inds = selectedRec.get("inds");
			PrintInDisp(Inds);
		});
	}
});

var formPanel = new Ext.ux.FormPanel({
	title:'发放单审核',
	tbar:[findIndsAudit,'-',auditIndsAudit,'-',printIndsAudit],
	items : [{
		xtype : 'fieldset',
		title : '查询条件',
		layout : 'column',	
		style : 'padding:5px 0px 0px 5px',
		defaults:{border:false,xtype:'fieldset'},
		items : [{
				columnWidth : .25,
				items : [locField]
			}, {
				columnWidth : .2,
				items : [startDateField]
			}, {
				columnWidth : .2,
				items : [endDateField]
			}, {
				columnWidth : .25,
				items : [AuditedCK]
		}]
	}]
});

//配置数据源
var IndsAuditGridUrl = 'dhcstm.indispaction.csp';
var IndsAuditGridProxy= new Ext.data.HttpProxy({url:IndsAuditGridUrl+'?actiontype=query',method:'GET'});
var IndsAuditGridDs = new Ext.data.Store({
	proxy:IndsAuditGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'inds'},
		{name:'no'},
		{name:'loc'},
		{name:'locDesc'},
		{name:'date'},
		{name:'time'},
		{name:'user'},
		{name:'userName'},
		{name:'chkDate'},
		{name:'chkTime'},
		{name:'chkUser'},
		{name:'chkUserName'},
		{name:'scg'},
		{name:'scgDesc'},
		{name:'comp'},
		{name:'state'},
		{name:'chkFlag'},
		{name:'stkType'},
		{name:'dispmode'},
		{name:'recUser'},
		{name:'recUserName'},
		{name:'grp'},
		{name:'grpDesc'},
		'dsrqNo','indsToLoc'
	]),
	remoteSort:false,
	listeners:{
		'beforeload':function(ds){
			var startDate = Ext.getCmp('startDateField').getValue().format(ARG_DATEFORMAT);
			var endDate = Ext.getCmp('endDateField').getValue().format(ARG_DATEFORMAT);
			var locId = Ext.getCmp('locField').getValue();
			var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
			var completedFlag="Y"  //要求是已经完成的
			var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^"+completedFlag;
			ds.setBaseParam('sort','NO');
			ds.setBaseParam('dir','desc');
			ds.setBaseParam('strParam', strPar);
		},
		'load':function(ds){
			if (ds.getCount()>0){
				//IndsAuditGrid.getSelectionModel().selectFirstRow();
				//IndsAuditGrid.getView().focusRow(0);
			}
		}
	}
});

var sm = new Ext.grid.CheckboxSelectionModel({
	singleSelect:false,
	checkOnly:true,
	listeners:{
		'rowselect':function(sm,rowIndex,rec){
			var inds = IndsAuditGridDs.data.items[rowIndex].data["inds"];
			if (inds!=''){
				mainRowId = inds;
				ACKFlag=IndsAuditGridDs.data.items[rowIndex].data["chkFlag"];
				IndsAuditDetailGridDs.setBaseParam('disp',inds);
				IndsAuditDetailGridDs.load({params:{start:0,limit:IndsAuditItmPagingToolbar.pageSize}});
			}
		}
	}
});

//模型
var IndsAuditGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	sm,
	{
		header:"rowid",
		dataIndex:'inds',
		width:100,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"发放单号",
		dataIndex:'no',
		width:140,
		align:'left',
		sortable:true
	},{
		header:"科室名称",
		dataIndex:'locDesc',
		width:120,
		align:'left',
		sortable:true
	},{
		header:"请领单号",
		dataIndex:'dsrqNo',
		width:140,
		align:'left'
	},{
		header:"接收科室",
		dataIndex:'indsToLoc',
		width:140,
		align:'left'
	},{
		header:"制单人",
		dataIndex:'userName',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"制单日期",
		dataIndex:'date',
		width:100,
		align:'center',
		sortable:true
	},{
		header:"制单时间",
		dataIndex:'time',
		width:100,
		align:'center',
		sortable:true
	},{
		header:"完成标志",
		dataIndex:'comp',
		width:80,
		align:'left',
		xtype : 'checkcolumn'
	},{
		header:'领用人',
		dataIndex:'recUserName',
		width:60
	},{
		header:'专业组',
		dataIndex:'grpDesc',
		width:120
	},{
		header:"审核标志",
		dataIndex:'chkFlag',
		width:60,
		align:'left',
		sortable:true,
		xtype : 'checkcolumn'
	},{
		header:"审核人",
		dataIndex:'chkUserName',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"审核日期",
		dataIndex:'chkDate',
		width:100,
		align:'center',
		sortable:true
	},{
		header:"审核时间",
		dataIndex:'chkTime',
		width:100,
		align:'center',
		sortable:true
	}
]);
//初始化默认排序功能
IndsAuditGridCm.defaultSortable = true;

var IndsAuditPagingToolbar = new Ext.PagingToolbar({
	store:IndsAuditGridDs,
	pageSize:15,
	displayInfo:true
});

//表格
IndsAuditGrid = new Ext.ux.GridPanel({
	title : '发放单信息',
	id : 'IndsAuditGrid',
	region : 'center',
	store:IndsAuditGridDs,
	cm:IndsAuditGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : sm,
	loadMask:true,
	clicksToEdit:1,
	bbar:IndsAuditPagingToolbar
});

//配置数据源
var IndsAuditDetailGridUrl = 'dhcstm.indispaction.csp';
var IndsAuditDetailGridProxy= new Ext.data.HttpProxy({url:IndsAuditDetailGridUrl+'?actiontype=queryItem',method:'GET'});
var IndsAuditDetailGridDs = new Ext.data.Store({
	proxy:IndsAuditDetailGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'indsitm'},
		{name:'inclb'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'manf'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'qty'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		'AvaQty'
	]),
	remoteSort:false
});

//模型
var IndsAuditDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),{
			header: '明细rowid',
			dataIndex: 'indsitm',
			width: 72,
			sortable:true,
			align: 'left',
			hidden:true
		},{
			header: '批次rowid',
			dataIndex: 'inclb',
			width: 72,
			sortable:true,
			hidden:true,
			align: 'left'
		},{
			header: '物资rowid',
			dataIndex: 'inci',
			width: 72,
			sortable:true,
			hidden:true,
			align: 'left'
		},{
			header: '物资代码',
			dataIndex: 'code',
			width: 100,
			sortable:true,
			align: 'left'
		},{
			header: '物资名称',
			dataIndex: 'desc',
			width: 200,
			sortable:true,
			align: 'left'
		},{
			header:'规格',
			dataIndex:'spec',
			align:'left',
			width:100,
			sortable:true
		},{
			header: "厂商",
			dataIndex: 'manf',
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "批次~效期",
			dataIndex: 'batNo',
			width: 140,
			align: 'left',
			sortable: true
		},{
			header: "发放数量",
			dataIndex: 'qty',
			width: 100,
			align: 'right',
			sortable: true
		},{
			header:'单位',
			dataIndex:'uomDesc',
			align:'left',
			width:80,
			sortable:true
		},{
			header:'进价',
			dataIndex:'rp',
			align:'right',
			width:100,
			sortable:true
		},{
			header:'进价金额',
			dataIndex:'rpAmt',
			align:'right',
			width:100,
			sortable:true
		},{
			header:'售价',
			dataIndex:'sp',
			align:'right',
			width:100,
			sortable:true,
			hidden:true,
			hideable:false
		},{
			header:'售价金额',
			dataIndex:'spAmt',
			align:'right',
			width:100,
			sortable:true,
			hidden:true,
			hideable:false
		}
]);
//初始化默认排序功能
IndsAuditDetailGridCm.defaultSortable = true;

var IndsAuditItmPagingToolbar = new Ext.PagingToolbar({
	store:IndsAuditDetailGridDs,
	pageSize:15,
	displayInfo:true
});

//表格
IndsAuditDetailGrid = new Ext.ux.GridPanel({
	title : '发放单明细',
	id: 'IndsAuditDetailGrid',
	region:'south',
	height:240,
	store:IndsAuditDetailGridDs,
	cm:IndsAuditDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:IndsAuditItmPagingToolbar
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,IndsAuditGrid,IndsAuditDetailGrid],
		renderTo:'mainPanel'
	});
	findIndsAudit.handler();
});
