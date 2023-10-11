// 名称:库存报损单审核
// 编写日期:2012-08-22
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
//var arr = window.status.split(":");
//var length = arr.length;
var mainRowId = "";
var needCompleted="Y";
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:$g('科室'),
	name:'locField',
	anchor:'90%',
	groupId:gGroupId
});

//=========================库存报损单审核=============================
var startDateField = new Ext.ux.DateField({
	id:'startDateField',
//	width:100,
	listWidth:100,
    allowBlank:false,
	fieldLabel:$g('开始日期'),
	value:new Date(),
	anchor:'90%'
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	//width:100,
	listWidth:100,
    allowBlank:false,
	fieldLabel:$g('结束日期'),
	value:new Date(),
	anchor:'90%'
});
var includeAuditedCK = new Ext.form.Checkbox({
	id: 'includeAuditedCK',
	boxLabel:$g('已审核'),
	anchor:'90%',
	allowBlank:true
});
//====================================================
var INScrapAuditGrid="";
//配置数据源
var INScrapAuditGridUrl = 'dhcst.inscrapaction.csp';
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
		{name:'spAmt'},
		{name:'rpAmt'}
	]),
    remoteSort:false
});

//模型
var INScrapAuditGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:$g("主表RowId"),
        dataIndex:'inscp',
        hidden:true
    },/*{
        header:"科室RowId",
        dataIndex:'loc',
        width:100,
        align:'left',
        sortable:true
    },*/{
        header:$g("科室名称"),
        dataIndex:'locDesc',
        width:120,
        align:'left',
        sortable:true
    },{
    	 header:$g("报损单号"),
        dataIndex:'no',
        width:150,
        align:'center',
        sortable:true   
    }
    /*,{
        header:"制单人rowid",
        dataIndex:'user',
        width:100,
        align:'left',
        sortable:true
    }*/,{
        header:$g("制单人"),
        dataIndex:'userName',
        width:100,
        align:'left',
        sortable:true
    },	{
        header:$g("制单日期"),
        dataIndex:'date',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("制单时间"),
        dataIndex:'time',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("完成标志"),
        dataIndex:'completed',
        width:60,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:$g("审核标志"),
        dataIndex:'chkFlag',
        width:60,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    }/*,{
        header:"审核人rowid",
        dataIndex:'chkUser',
        width:100,
        align:'left',
        sortable:true
    }*/,{
        header:$g("审核人"),
        dataIndex:'chkUserName',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("审核日期"),
        dataIndex:'chkDate',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("审核时间"),
        dataIndex:'chkTime',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("进价金额"),
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:$g("售价金额"),
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    }
]);
//初始化默认排序功能
INScrapAuditGridCm.defaultSortable = true;

var findINScrapAudit = new Ext.Toolbar.Button({
	text:$g('查询'),
    tooltip:$g('查询'),
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
	query()
		
	}
});

function query(){
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
			
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error",$g("请选择申请部门!"));
			return false;
		}
			
		var includeAudited = (Ext.getCmp('includeAuditedCK').getValue()==true?'Y':'N');
		
		var strPar = startDate+"^"+endDate+"^"+locId+"^"+needCompleted+"^"+includeAudited
		INScrapAuditGridDs.setBaseParam('strParam',strPar);
		INScrapAuditDetailGridDs.removeAll();
		INScrapAuditGridDs.load({params:{start:0,limit:InscrapAuditPagingToolbar.pageSize,sort:'NO',dir:'desc',strParam:strPar},
		callback : function(r,options, success){
			if(success==false){
				Msg.info("error",$g("查询错误!"));}
				else{
					if(r.length>=1){
						INScrapAuditGrid.getSelectionModel().selectFirstRow();
						INScrapAuditGrid.fireEvent('rowclick',this,0);}
						//=========
						INScrapAuditGrid.getView().focusRow(0);
						//=========
					}
			}
			});
	
	
	}
var auditINScrapAudit = new Ext.Toolbar.Button({
	text:$g('审核'),
    tooltip:$g('审核'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
		var locId = Ext.getCmp('locField').getValue();
		if((locId=="")||(locId==null)){
			Msg.info("error",$g("请选择申请部门!"));
			return false;
		}
		if((mainRowId!="")&&(mainRowId!=null)){
			Ext.Ajax.request({
				url: INScrapAuditGridUrl+'?actiontype=audit&inscrap='+mainRowId+'&userId='+UserId+'&locId='+locId,
				failure: function(result, request) {
					Msg.info("error",$g("请检查网络连接!"));
				},
				success: function(result, request) {
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true') {
						Msg.info("success",$g("审核成功!"));
						
						//审核成功就刷新页面
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
						var includeAudited = (Ext.getCmp('includeAuditedCK').getValue()==true?'Y':'N');
				
						var strPar = startDate+"^"+endDate+"^"+locId+"^"+needCompleted+"^"+includeAudited;
						
						INScrapAuditGridDs.load({params:{start:0,limit:InscrapAuditPagingToolbar.pageSize,sort:'NO',dir:'desc',strParam:strPar}});
						INScrapAuditDetailGridDs.removeAll();
					}else{
						if(jsonData.info==-1){
							Msg.info("error",$g("主表rowid为空!"));
						}else if(jsonData.info==-2){
							Msg.info("error",$g("登录用户rowid为空!"));
						}else if(jsonData.info==-3){
							Msg.info("error",$g("已经审核过!"));
						}else if(jsonData.info==-102){
							Msg.info("error",$g("库存处理出错!"));
						}else if(jsonData.info==-103){
							Msg.info("error",$g("插入台账数据出错!"));
						}else{
							Msg.info("error",$g("审核失败!"));
						}
					}
				},
				scope: this
			});
		}
		else {Msg.info("warning",$g("没有单据需要审核!"));return false;}
    }
});

var clearINScrapAudit = new Ext.Toolbar.Button({
	text:$g('清空'),
    tooltip:$g('清空'),
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp('includeAuditedCK').setValue(false);
		INScrapAuditGridDs.load({params:{start:0,limit:0}})
		INScrapAuditDetailGridDs.load({params:{start:0,limit:0}})
		INScrapAuditGridDs.removeAll();
		INScrapAuditDetailGridDs.removeAll();
		mainRowId=""
		SetLogInDept(locField.getStore(),'locField');
		Ext.getCmp("startDateField").setValue(new Date());
		Ext.getCmp("endDateField").setValue(new Date());
	}
});

var printINScrapAudit = new Ext.Toolbar.Button({
	text : $g('打印'),
	tooltip : $g('打印报损单'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=INScrapAuditGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", $g("请选择需要打印的报损单!"));
			return;
		}
		var inscrap = rowData.get("inscp");
		PrintINScrap(inscrap);
	}
});

var formPanel = new Ext.form.FormPanel({
	labelWidth : 60,
	autoScroll:true,
	labelAlign : 'right',
	autoHeight:true,
	region:'north',
	frame : true,
    tbar:[findINScrapAudit,'-',clearINScrapAudit,'-',auditINScrapAudit,'-',printINScrapAudit],
	items : [{
		xtype : 'fieldset',
		title : $g('条件选项'),
		layout : 'column',
		style:DHCSTFormStyle.FrmPaddingV,
		items : [{
			xtype : 'fieldset',
			columnWidth : .25,
        	border: false,
			items : [locField]
		}, {
			xtype : 'fieldset',
			columnWidth : .25,
        	border: false,
			items : [startDateField]
		}, {
			xtype : 'fieldset',
			columnWidth : .25,
        	border: false,
			items : [endDateField]
		}, {
			xtype : 'fieldset',
			columnWidth : .2,
        	border: false,
        	labelWidth:10,
			items : [includeAuditedCK]
		}]

	}]
});

var InscrapAuditPagingToolbar = new Ext.PagingToolbar({
	store:INScrapAuditGridDs,
	pageSize:15,
	displayInfo:true,
	displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
	emptyMsg:$g("没有记录")
});

//表格
INScrapAuditGrid = new Ext.grid.EditorGridPanel({
	store:INScrapAuditGridDs,
	cm:INScrapAuditGridCm,
	trackMouseOver:true,
	region:'north',
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InscrapAuditPagingToolbar
});
//=========================库存报损单审核=============================

var INScrapAuditDetailGrid="";
//配置数据源
var INScrapAuditDetailGridUrl = 'dhcst.inscrapaction.csp';
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
	 /*{
        header:"明细RowId",
        dataIndex:'inspi',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"批次RowId",
        dataIndex:'inclb',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"药品RowId",
        dataIndex:'inci',
        width:120,
        align:'left',
        sortable:true
    },*/{
        header:$g("药品代码"),
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("名称"),
        dataIndex:'desc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("规格"),
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("生产企业"),
        dataIndex:'manf',
        width:150,
        align:'left',
        sortable:true
    },{
        header:$g("批号~效期"),
        dataIndex:'batNo',
        width:180,
        align:'left',
        sortable:true
    },{
        header:$g("报损数量"),
        dataIndex:'qty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("单位"),
        dataIndex:'uomDesc',
        width:75,
        align:'left'
    },{
        header:$g("进价"),
        dataIndex:'rp',
        width:75,
        align:'right',
        sortable:true
    },{
        header:$g("售价"),
        dataIndex:'sp',
        width:75,
        align:'right',
        sortable:true
    },{
        header:$g("进价金额"),
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:$g("售价金额"),
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    }
]);
//初始化默认排序功能
INScrapAuditDetailGridCm.defaultSortable = true;

var InscrapAuditDetailPagingToolbar = new Ext.PagingToolbar({
	store:INScrapAuditDetailGridDs,
	pageSize:15,
	displayInfo:true,
	displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
	emptyMsg:$g("没有记录")
});
//表格
INScrapAuditDetailGrid = new Ext.grid.EditorGridPanel({
	store:INScrapAuditDetailGridDs,
	cm:INScrapAuditDetailGridCm,
	trackMouseOver:true,
	region:'center',
	height:300,
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	bbar:InscrapAuditDetailPagingToolbar,
	clicksToEdit:1
});

INScrapAuditGrid.getSelectionModel().on('rowselect',function(sm,rowIndex,r){
	var inscrap = INScrapAuditGridDs.data.items[rowIndex].data["inscp"];
	mainRowId = inscrap;
	INScrapAuditDetailGridDs.setBaseParam('inscrap',inscrap)
	INScrapAuditDetailGridDs.load({params:{start:0,limit:InscrapAuditDetailPagingToolbar.pageSize}});
});
//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}	
	var panel = new Ext.Panel({
		title:$g('库存报损单审核'),
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(1),
		layout:'fit',
		items:[formPanel]                                 
	});
	var panel2 = new Ext.Panel({		
		//activeTab:0,
		region:'center',
		///height:100,
		layout:'fit',
		items:[INScrapAuditGrid]                                 
	});
	var panel3 = new Ext.Panel({		
		activeTab:0,
		region:'south',
		height:document.body.clientHeight*0.45,
		layout:'fit',
		items:[INScrapAuditDetailGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,panel2,panel3],
		renderTo:'mainPanel'
	});
	query()
});
//===========模块主页面=============================================