// 名称:科室退回单审核
// 编写日期:2012-08-28
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
var mainRowId = "";

//保存参数值的object
var InDispReqRetParamObj = GetAppPropValue('DHCSTINDISPRETM');

//科室
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	name:'locField',
	fieldLabel:'科室',
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
	boxLabel : '已审核'
});

//配置数据源
var DsrAuditGridUrl = 'dhcstm.indispretaction.csp';
var DsrAuditGridProxy= new Ext.data.HttpProxy({url:DsrAuditGridUrl+'?actiontype=query',method:'GET'});
var DsrAuditGridDs = new Ext.data.Store({
	proxy:DsrAuditGridProxy,
	reader:new Ext.data.JsonReader({
		root:'rows',
		totalProperty:'results'
	}, [
		{name:'dsr'},
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
		{name:'grpDesc'}
	]),
	remoteSort:false,
	listeners:{
		'beforeload':function(ds){
			var startDate = Ext.getCmp('startDateField').getValue().format(ARG_DATEFORMAT);
			var endDate = Ext.getCmp('endDateField').getValue().format(ARG_DATEFORMAT);
			//var locId = Ext.getCmp('locField').getValue();
			var locId = '';
			var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
			var completedFlag="Y";	//要求是已经完成的
			var RetToLoc = Ext.getCmp('locField').getValue();
			var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^"+completedFlag+"^"+RetToLoc;
			
			ds.baseParams={start:0,limit:DsrAuditPagingToolbar.pageSize,sort:'NO',dir:'desc',strParam:strPar};
		},
		'load':function(ds){
			if (ds.getCount()>0){
				DsrAuditGrid.getSelectionModel().selectFirstRow();
				DsrAuditGrid.getView().focusRow(0);
			}
		}
	}
});

//模型
var DsrAuditGridCm = new Ext.grid.ColumnModel([
	new Ext.grid.RowNumberer(),
	{
        header:"dsr",
        dataIndex:'dsr',
        width:100,
        align:'left',
        sortable:true,
        hidden:true
    },{
        header:"退回单号",
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
        width:80,
        align:'left',
       // sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:"审核标志",
        dataIndex:'chkFlag',
        width:60,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
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
DsrAuditGridCm.defaultSortable = true;

var findDsrAudit = new Ext.Toolbar.Button({
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

		DsrAuditDetailGrid.store.removeAll();
		DsrAuditGridDs.load();
	}
});

var auditDsrAudit = new Ext.Toolbar.Button({
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
			Ext.Ajax.request({
				url: DsrAuditGridUrl+'?actiontype=audit&dsr='+mainRowId+'&userId='+UserId,
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
						
						DsrAuditGridDs.load();
						DsrAuditDetailGridDs.removeAll();
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
							Msg.info("error","审核失败!");
						}
					}
				},
				scope: this
			});
		}
    }
});

var printDsrAudit = new Ext.Toolbar.Button({
	id : "printDsrAudit",
	text : '打印',
	tooltip : '打印退回单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=DsrAuditGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "请选择需要打印的退回单!");
			return;
		}
		var dsr = rowData.get("dsr");
		PrintDsr(dsr);
	}
});

var DsrAuditPagingToolbar = new Ext.PagingToolbar({
	store:DsrAuditGridDs,
	pageSize:15,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['sort']='NO';
		B['dir']='desc';
		B['strParam']=Ext.getCmp('startDateField').getValue().format(ARG_DATEFORMAT)+"^"+Ext.getCmp('endDateField').getValue().format(ARG_DATEFORMAT)+"^"+Ext.getCmp('locField').getValue()+"^"+(Ext.getCmp('AuditedCK').getValue()==true?'Y':'N')+"^N";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
var DsrAuditGrid = new Ext.ux.EditorGridPanel({
	title: '退回单',
	region:'center',
	id : 'DsrAuditGrid',
	store:DsrAuditGridDs,
	cm:DsrAuditGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true,
		listeners:{'rowselect':function(sm,rowIndex,rec){
			var dsr = DsrAuditGridDs.data.items[rowIndex].data["dsr"];
			if (dsr!=''){
				mainRowId = dsr;
				DsrAuditDetailGridDs.setBaseParam('dsr',dsr)
				DsrAuditDetailGridDs.load({params:{start:0,limit:DsrAuditItmPagingToolbar.pageSize}});
			}
		}}
	}),
	loadMask:true,
	clicksToEdit:1,
	bbar:DsrAuditPagingToolbar
});

//配置数据源
var DsrAuditDetailGridUrl = 'dhcstm.indispretaction.csp';
var DsrAuditDetailGridProxy= new Ext.data.HttpProxy({url:DsrAuditDetailGridUrl+'?actiontype=queryItem',method:'GET'});
var DsrAuditDetailGridDs = new Ext.data.Store({
	proxy:DsrAuditDetailGridProxy,
	reader:new Ext.data.JsonReader({
        root:'rows',
		totalProperty:'results'
	}, [
		{name:'dsritm'},
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
		"Brand","Model","Abbrev","indsNo","dsrqNo"
	]),
	remoteSort:false
});

//模型
var DsrAuditDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),{
			header: '明细rowid',
			dataIndex: 'dsritm',
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
			header:'简称',
			dataIndex:'Abbrev',
			align:'left',
			width:100,
			sortable:true
		},{
			header:'品牌',
			dataIndex:'Brand',
			align:'left',
			width:100,
			sortable:true
		},{
			header:'型号',
			dataIndex:'Model',
			align:'left',
			width:100,
			sortable:true
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
			header: "退回数量",
			dataIndex: 'qty',
			width: 100,
			align: 'right',
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
			hidden:true,
			sortable:true
		},{
			header:'售价金额',
			dataIndex:'spAmt',
			align:'right',
			width:100,
			hidden:true,
			sortable:true
		},{
			header : '发放单号',
			dataIndex : 'indsNo',
			width : 150
		},{
			header : '请领单号',
			dataIndex : 'dsrqNo',
			width : 150
		}
]);
//初始化默认排序功能
DsrAuditDetailGridCm.defaultSortable = true;

var DsrAuditItmPagingToolbar = new Ext.PagingToolbar({
	store:DsrAuditDetailGridDs,
	pageSize:15,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录"
});

//表格
var DsrAuditDetailGrid = new Ext.ux.EditorGridPanel({
	title : '退回单明细',
	region : 'south',
	height : 240,
	id : 'DsrAuditDetailGrid',
	collapsible : true,
	store:DsrAuditDetailGridDs,
	cm:DsrAuditDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:DsrAuditItmPagingToolbar
});

var formPanel = new Ext.ux.FormPanel({
	title:'退回单审核',
    tbar:[findDsrAudit,'-',auditDsrAudit,'-',printDsrAudit],
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

//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,DsrAuditGrid,DsrAuditDetailGrid],
		renderTo:'mainPanel'
	});
	findDsrAudit.handler();
});
//===========模块主页面=============================================