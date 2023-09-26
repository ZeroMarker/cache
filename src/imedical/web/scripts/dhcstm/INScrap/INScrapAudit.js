// 名称:库存报损单审核
// 编写日期:2012-08-22
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var mainRowId = "";
var needCompleted="Y";

//保存参数值的object
var InScrapParamObj = GetAppPropValue('DHCSTINSCRAPM');

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'供应科室',
	name:'locField',
	anchor:'90%',
	groupId:gGroupId
});

var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	allowBlank:false,
	fieldLabel:'开始日期',
	value:new Date(),
	anchor:'90%'
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	allowBlank:false,
	fieldLabel:'结束日期',
	value:new Date(),
	anchor:'90%'
});
var includeAuditedCK = new Ext.form.Checkbox({
	id: 'includeAuditedCK',
	fieldLabel:'已审核',
	anchor:'90%',
	allowBlank:true
});

var findINScrapAudit = new Ext.Toolbar.Button({
	text:'查询',
	tooltip:'查询',
	iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		mainRowId=""
		INScrapAuditDetailGridDs.removeAll();
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
		var includeAudited = (Ext.getCmp('includeAuditedCK').getValue()==true?'Y':'N');
		var strPar = startDate+"^"+endDate+"^"+locId+"^"+needCompleted+"^"+includeAudited;
		INScrapAuditGridDs.setBaseParam('strParam',strPar);
		INScrapAuditGridDs.load({params:{start:0,limit:InscrapAuditPagingToolbar.pageSize}});
	}
});

var auditINScrapAudit = new Ext.Toolbar.Button({
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
		if((mainRowId!="")&&(mainRowId!=null)){
			
			///检查高值材料标签录入情况
			if(CheckHighValueLabels("D",mainRowId)==false){
				return;
			}
			
			Ext.Ajax.request({
				url: INScrapAuditGridUrl+'?actiontype=audit&inscrap='+mainRowId+'&userId='+UserId+'&locId='+locId,
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
						var includeAudited = (Ext.getCmp('includeAuditedCK').getValue()==true?'Y':'N');
				
						var strPar = startDate+"^"+endDate+"^"+locId+"^"+needCompleted+"^"+includeAudited;
						
						INScrapAuditGridDs.reload();
						INScrapAuditDetailGridDs.removeAll();
					}else{
						if(jsonData.info==-1){
							Msg.info("error","主表rowid为空!");
						}else if(jsonData.info==-2){
							Msg.info("error","登录用户rowid为空!");
						}else if(jsonData.info==-3){
							Msg.info("error","已经审核!");
						}else if(jsonData.info==-102){
							Msg.info("error","库存处理出错!");
						}else if(jsonData.info==-103){
							Msg.info("error","插入台账数据出错!");
						}else if(jsonData.info==-104){
							Msg.info("error","批次库存不足,不能进行报损单审核!");
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
var canauditINScrapAudit = new Ext.Toolbar.Button({
	text:'作废审核',
	tooltip:'作废审核',
	iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error","请选择申请部门!");
			return false;
		}
		if((mainRowId!="")&&(mainRowId!=null)){
						
			Ext.Ajax.request({
				url: INScrapAuditGridUrl+'?actiontype=canaudit&inscrap='+mainRowId+'&userId='+UserId,
				failure: function(result, request) {
					Msg.info("error","请检查网络连接!");
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success","审核成功!");
						
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
						var includeAudited = (Ext.getCmp('includeAuditedCK').getValue()==true?'Y':'N');
				
						var strPar = startDate+"^"+endDate+"^"+locId+"^"+needCompleted+"^"+includeAudited;
						
						INScrapAuditGridDs.reload();
						INScrapAuditDetailGridDs.removeAll();
					}else{
						if(jsonData.info==-1){
							Msg.info("error","主表rowid为空!");
						}else if(jsonData.info==-2){
							Msg.info("error","登录用户rowid为空!");
						}else if(jsonData.info==-3){
							Msg.info("error","已经审核过!");
						}else if(jsonData.info==-4){
							Msg.info("error","已结作废!");
						}else if(jsonData.info==-5){
							Msg.info("error","已生成月报!");							
						}else{
							Msg.info("error","作废失败!"+jsonData.info);
						}
					}
				},
				scope: this
			});
		}
	}
});
var clearINScrapAudit = new Ext.Toolbar.Button({
	text:'清空',
	tooltip:'清空',
	iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		//Ext.getCmp('startDateField').setValue("");
		//Ext.getCmp('endDateField').setValue("");
		//Ext.getCmp('locField').setValue("");
		//Ext.getCmp('locField').setRawValue("");
		Ext.getCmp('includeAuditedCK').setValue(false);
		
		INScrapAuditGridDs.removeAll();
		INScrapAuditDetailGridDs.removeAll();
	}
});

var printINScrapAudit = new Ext.Toolbar.Button({
	text : '打印',
	tooltip : '打印报损单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=INScrapAuditGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "请选择需要打印的报损单!");
			return;
		}
		var inscrap = rowData.get("inscp");
		PrintINScrap(inscrap);
	}
});

var formPanel = new Ext.ux.FormPanel({
	title:'库存报损单审核',
	tbar:[findINScrapAudit,'-',auditINScrapAudit,'-',clearINScrapAudit,'-',printINScrapAudit,'-',canauditINScrapAudit],
	items : [{
		xtype : 'fieldset',
		title : '条件选项',
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
				items : [includeAuditedCK]
			}]
		}]

	}]
});

var INScrapAuditGrid="";
//配置数据源
var INScrapAuditGridUrl = 'dhcstm.inscrapaction.csp';
var INScrapAuditGridProxy= new Ext.data.HttpProxy({url:INScrapAuditGridUrl+'?actiontype=query',method:'GET'});
var INScrapAuditGridDs = new Ext.data.Store({
	proxy:INScrapAuditGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'inscp'},
		{name:'no'},
		{name:'date'},
		{name:'time'},
		{name:'user'},
		{name:'userName'},
		{name:'loc'},
		{name:'locDesc'},
		{name:'chkDate'},
		{name:'chkTime'},
		{name:'chkUser'},
		{name:'chkUserName'},
		{name:'completed'},
		{name:'chkFlag'},
		{name:'stkType'},
		{name:'scg'},
		{name:'scgDesc'},
		{name:'reason'},
		{name:'reasonDesc'},
		{name:'RpAmt'},
		{name:'SpAmt'},
		{name:'canchkFlag'}
	]),
	remoteSort:false,
	listeners : {
		load : function(store,records,options){
			if(records.length>0){
				INScrapAuditGrid.getSelectionModel().selectFirstRow();
				INScrapAuditGrid.getView().focusRow(0);
			}
		}
	}
});

//模型
var INScrapAuditGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"主表RowId",
		dataIndex:'inscp',
		hidden:true
	},{
		header:"科室名称",
		dataIndex:'locDesc',
		width:120,
		align:'left',
		sortable:true
	},{
		 header:"报损单号",
		dataIndex:'no',
		width:100,
		align:'center',
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
		align:'left',
		sortable:true
	},{
		header:"制单时间",
		dataIndex:'time',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"完成标志",
		dataIndex:'completed',
		width:100,
		align:'left',
		sortable:true,
		xtype : 'checkcolumn'
	},{
		header:"审核标志",
		dataIndex:'chkFlag',
		width:100,
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
		align:'left',
		sortable:true,
		hidden:false
	},{
		header:"审核时间",
		dataIndex:'chkTime',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"进价合计",
		dataIndex:'RpAmt',
		width:100,
		align:'right',
		xtype:'numbercolumn'
	},{
		header:"售价合计",
		dataIndex:'SpAmt',
		width:100,
		align:'right',
		xtype:'numbercolumn'
	},{
		header:"作废审核标志",
		dataIndex:'canchkFlag',
		width:100,
		align:'left',
		sortable:true,
		xtype : 'checkcolumn'
	}
]);
//初始化默认排序功能
INScrapAuditGridCm.defaultSortable = true;

var InscrapAuditPagingToolbar = new Ext.PagingToolbar({
	store:INScrapAuditGridDs,
	pageSize:15,
	displayInfo:true
});

//表格
INScrapAuditGrid = new Ext.grid.EditorGridPanel({
	region:'center',
	store:INScrapAuditGridDs,
	cm:INScrapAuditGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InscrapAuditPagingToolbar
});

var INScrapAuditDetailGrid="";
//配置数据源
var INScrapAuditDetailGridUrl = 'dhcstm.inscrapaction.csp';
var INScrapAuditDetailGridProxy= new Ext.data.HttpProxy({url:INScrapAuditDetailGridUrl+'?actiontype=queryItem',method:'GET'});
var INScrapAuditDetailGridDs = new Ext.data.Store({
	proxy:INScrapAuditDetailGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'inspi'},
		{name:'inclb'},
		{name:'inci'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'manf'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'qty'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'pp'},
		{name:'ppAmt'},
		{name:'batNo'},
		{name:'expDate'}
	]),
	remoteSort:false
});

//模型
var INScrapAuditDetailGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
		header:"明细RowId",
		dataIndex:'inspi',
		width:100,
		align:'left',
		hidden:true,
		sortable:true
	},{
		header:"批次RowId",
		dataIndex:'inclb',
		width:100,
		align:'left',
		hidden:true,
		sortable:true
	},{
		header:"物资RowId",
		dataIndex:'inci',
		width:120,
		align:'left',
		hidden:true,
		sortable:true
	},{
		header:"物资代码",
		dataIndex:'code',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"物资名称",
		dataIndex:'desc',
		width:200,
		align:'left',
		sortable:true
	},{
		header:"规格",
		dataIndex:'spec',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"厂商",
		dataIndex:'manf',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"批号~效期",
		dataIndex:'batNo',
		width:100,
		align:'left',
		sortable:true
	},{
		header:"报损数量",
		dataIndex:'qty',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"单位",
		dataIndex:'uomDesc',
		width:100,
		align:'left'
	},{
		header:"进价",
		dataIndex:'rp',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"售价",
		dataIndex:'sp',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"进价金额",
		dataIndex:'rpAmt',
		width:100,
		align:'right',
		sortable:true
	},{
		header:"售价金额",
		dataIndex:'spAmt',
		width:100,
		align:'right',
		sortable:true
	}
]);
//初始化默认排序功能
INScrapAuditDetailGridCm.defaultSortable = true;

var InscrapAuditDetailPagingToolbar = new Ext.PagingToolbar({
	store:INScrapAuditDetailGridDs,
	pageSize:15,
	displayInfo:true
});
//表格
INScrapAuditDetailGrid = new Ext.grid.GridPanel({
	region:'south',
	height:240,
	store:INScrapAuditDetailGridDs,
	cm:INScrapAuditDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	bbar:InscrapAuditDetailPagingToolbar,
	clicksToEdit:1
});

INScrapAuditGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,r){
	var inscrap = INScrapAuditGridDs.data.items[rowIndex].data["inscp"];
	mainRowId = inscrap;
	INScrapAuditDetailGridDs.setBaseParam('inscrap',inscrap);
	INScrapAuditDetailGridDs.load({params:{start:0,limit:InscrapAuditDetailPagingToolbar.pageSize}});
});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,INScrapAuditGrid,INScrapAuditDetailGrid],
		renderTo:'mainPanel'
	});
	findINScrapAudit.handler();
});
