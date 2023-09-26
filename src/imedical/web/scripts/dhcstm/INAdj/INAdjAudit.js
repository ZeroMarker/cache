// 名称:库存调整单审核
// 编写日期:2012-08-28
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var mainRowId = "";

//保存参数值的object
var InAdjParamObj = GetAppPropValue('DHCSTSTOCKADJM');

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
	value:new Date()
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	allowBlank:false,
	fieldLabel:'结束日期',
	value:new Date()
});

var AuditedCK = new Ext.form.Checkbox({
	id: 'AuditedCK',
	fieldLabel:'已审核',
	anchor:'100%',
	allowBlank:true
});

var findInadjAudit = new Ext.Toolbar.Button({
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

		InadjAuditDetailGrid.store.removeAll();
		InadjAuditGridDs.load();
	}
});

var auditInadjAudit = new Ext.Toolbar.Button({
	text:'审核通过',
	tooltip:'点击审核通过',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","请选择申请部门!");
			return false;
		}
		//alert(mainRowId);
		if((mainRowId!="")&&(mainRowId!=null)){
			
			///检查高值材料标签录入情况
			if(CheckHighValueLabels("A",mainRowId)==false){
				return;
			}
			
			Ext.Ajax.request({
				url: InadjAuditGridUrl+'?actiontype=audit&adj='+mainRowId+'&userId='+UserId,
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
						var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
				
						var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^N";
						
						InadjAuditGridDs.reload();
						InadjAuditDetailGridDs.removeAll();
					}else{
						if(jsonData.info==-1){
							Msg.info("error","已审核!");
						}else if(jsonData.info==-2){
							Msg.info("error","登录用户rowid为空!");
						}else if(jsonData.info==-5){
							Msg.info("error","批次库存不足，不能进行审核!");
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
    }
});

var printInadjAudit = new Ext.Toolbar.Button({
	id : "printInadjAudit",
	text : '打印',
	tooltip : '打印调整单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=InadjAuditGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "请选择需要打印的调整单!");
			return;
		}
		var inadj = rowData.get("adj");
		PrintInAdj(inadj);
	}
});

var formPanel = new Ext.ux.FormPanel({
	title : '库存调整单审核',
	tbar:[findInadjAudit,'-',auditInadjAudit,'-',printInadjAudit],
	layout:'fit',
	items : [{
		xtype : 'fieldset',
		title : '条件选项',
		//width:1330,
		autoHeight : true,
		items : [{
			layout : 'column',
			items : [{
				columnWidth : .25,
				layout : 'form',
				items : [locField]
			}, {
				columnWidth : .2,
				layout : 'form',
				items : [startDateField]
			}, {
				columnWidth : .2,
				layout : 'form',
				items : [endDateField]
			}, {
				columnWidth : .25,
				layout : 'form',
				items : [AuditedCK]
			}]
		}]
	}]
});

//配置数据源
var InadjAuditGridUrl = 'dhcstm.inadjaction.csp';
var InadjAuditGridProxy= new Ext.data.HttpProxy({url:InadjAuditGridUrl+'?actiontype=query',method:'GET'});
var InadjAuditGridDs = new Ext.data.Store({
	proxy:InadjAuditGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'adj'},
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
		{name:'remarks'},
		{name:'RpAmt'},
		{name:'SpAmt'}
	]),
	remoteSort:false,
	listeners:{
		'beforeload':function(ds)
		{
			var startDate = Ext.getCmp('startDateField').getValue().format(ARG_DATEFORMAT);
			var endDate = Ext.getCmp('endDateField').getValue().format(ARG_DATEFORMAT);
			var locId = Ext.getCmp('locField').getValue();
		
			var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
			var completedFlag="Y"  //要求是已经完成的
			var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^"+completedFlag;

			ds.baseParams={start:0,limit:InadjAuditPagingToolbar.pageSize,sort:'NO',dir:'desc',strParam:strPar};
		},
		'load':function(ds)
		{
			if (ds.getCount()>0){
				InadjAuditGrid.getSelectionModel().selectFirstRow();
				InadjAuditGrid.getView().focusRow(0);
			}
		}
	}
});

//模型
var InadjAuditGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"rowid",
		dataIndex:'adj',
		width:100,
		align:'left',
		sortable:true,
		hidden:true
	},{
		header:"调整单号",
		dataIndex:'no',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"科室名称",
		dataIndex:'locDesc',
		width:120,
		align:'left',
		sortable:true
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
		width:60,
		align:'left',
		sortable:true,
		xtype : 'checkcolumn'
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
	},{
		header:"备注",
		dataIndex:'remarks',
		width:140,
		align:'left',
		sortable:true
	},{
		header:"进价合计",
		dataIndex:'RpAmt',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"售价合计",
		dataIndex:'SpAmt',
		width:100,
		align:'right',
		sortable:true
	}
]);
//初始化默认排序功能
InadjAuditGridCm.defaultSortable = true;

var InadjAuditPagingToolbar = new Ext.PagingToolbar({
	store:InadjAuditGridDs,
	pageSize:15,
	displayInfo:true
});

//表格
InadjAuditGrid = new Ext.grid.GridPanel({
	region : 'center',
	store:InadjAuditGridDs,
	cm:InadjAuditGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true,
		listeners:{
			'rowselect':function(sm,rowIndex,rec){
				var adj = InadjAuditGridDs.data.items[rowIndex].data["adj"];
				if (adj!=''){
					mainRowId = adj;
					InadjAuditDetailGridDs.setBaseParam('adj',adj);
					InadjAuditDetailGridDs.load({params:{start:0,limit:InadjAuditItmPagingToolbar.pageSize}});
				}
			}
		}
	}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InadjAuditPagingToolbar
});

//配置数据源
var InadjAuditDetailGridUrl = 'dhcstm.inadjaction.csp';
var InadjAuditDetailGridProxy= new Ext.data.HttpProxy({url:InadjAuditDetailGridUrl+'?actiontype=queryItem',method:'GET'});
var InadjAuditDetailGridDs = new Ext.data.Store({
	proxy:InadjAuditDetailGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'adjitm'},
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
		{name:'qtyBUOM'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'insti'},'HVBarCode'
	]),
	remoteSort:false
});

//模型
var InadjAuditDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),{
			header: '明细rowid',
			dataIndex: 'adjitm',
			width: 72,
			sortable:true,
			align: 'center',
			hidden:true
		},{
			header: '批次rowid',
			dataIndex: 'inclb',
			width: 72,
			sortable:true,
			hidden:true,
			align: 'center'
		},{
			header: '物资rowid',
			dataIndex: 'inci',
			width: 72,
			sortable:true,
			hidden:true,
			align: 'center'
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
			width: 100,
			align: 'left',
			sortable: true
		},{
			header: "调整数量",
			dataIndex: 'qty',
			width: 100,
			align: 'right',
			sortable: true
		},{
			header: "高值条码",
			dataIndex: 'HVBarCode',
			width: 150,
			align: 'left',
			sortable: true
		},{
			header:'单位',
			dataIndex:'uomDesc',
			align:'right',
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
			sortable:true
		},{
			header:'售价金额',
			dataIndex:'spAmt',
			align:'right',
			width:100,
			sortable:true
		}
]);
//初始化默认排序功能
InadjAuditDetailGridCm.defaultSortable = true;

var InadjAuditItmPagingToolbar = new Ext.PagingToolbar({
	store:InadjAuditDetailGridDs,
	pageSize:15,
	displayInfo:true
});

//表格
InadjAuditDetailGrid = new Ext.grid.GridPanel({
	region:'south',
	height:240,
	store:InadjAuditDetailGridDs,
	cm:InadjAuditDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InadjAuditItmPagingToolbar
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,InadjAuditGrid,InadjAuditDetailGrid],
		renderTo:'mainPanel'
	});
	findInadjAudit.handler();
});
