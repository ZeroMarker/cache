// 名称:库存调整单审核
// 编写日期:2012-08-28
var UserId = session['LOGON.USERID'];
var gGroupId=session['LOGON.GROUPID'];
//var arr = window.status.split(":");
//var length = arr.length;
var mainRowId = "";
//科室
var locField = new Ext.ux.LocComboBox({
	id:'locField',
	name:'locField',
	fieldLabel:'科室',
	anchor:'90%',
	groupId:gGroupId
	});

//=========================库存报损单审核=============================
var startDateField = new Ext.ux.DateField({
	id:'startDateField',
	//width:100,
	listWidth:100,
    allowBlank:false,
	fieldLabel:'开始日期',
	value:new Date(),
	anchor:'90%'
});

var endDateField = new Ext.ux.DateField({
	id:'endDateField',
	width:100,
	listWidth:100,
    allowBlank:false,
	fieldLabel:'结束日期',
	value:new Date(),
	anchor:'90%'
});

var AuditedCK = new Ext.form.Checkbox({
	id: 'AuditedCK',
	boxLabel:'已审核',
	anchor:'90%',
	allowBlank:true
});
var CancelAuditBT = new Ext.Toolbar.Button({
			id:'CancelAuditBT',
			text : '取消审核',
			tooltip : '点击取消库存调整审核确认',
			width : 70,
			height : 30,
			//disabled:true,
			iconCls : 'page_gear',
			handler : function() {
				CancelAudit();
			}
		});
//====================================================
//var InadjAuditGrid="";
//配置数据源
var InadjAuditGridUrl = 'dhcst.inadjaction.csp';
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
		{name:'spAmt'},
		{name:'rpAmt'},
		{name:'adjReason'},
		{name:'adjRemark'}
	]),
    remoteSort:false,
	listeners:{
		'beforeload':function(ds)
	    {
			var startDate = Ext.getCmp('startDateField').getValue().format(App_StkDateFormat);
			var endDate = Ext.getCmp('endDateField').getValue().format(App_StkDateFormat);
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
    },
	 {
        header:"调整单号",
        dataIndex:'no',
        width:200,
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
        header:"完成",
        dataIndex:'comp',
        width:60,
        align:'left',
        sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:"审核",
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
        header:"审核人",
        dataIndex:'chkUserName',
        width:100,
        align:'center',
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
        header:"进价金额",
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:"售价金额",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    },{
        header:"调整原因",
        dataIndex:'adjReason',
        width:100,
        align:'left'
    },{
        header:"备注",
        dataIndex:'adjRemark',
        width:100,
        align:'left'
    }
]);
//初始化默认排序功能
InadjAuditGridCm.defaultSortable = true;

var findInadjAudit = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		query()
	}
});
function query()
{
	var startDate = Ext.getCmp('startDateField').getValue();
		if((startDate!="")&&(startDate!=null)){
			startDate = startDate.format(App_StkDateFormat);
		}else{
			Msg.info("error","请选择起始日期!");
			return false;
		}
		var endDate = Ext.getCmp('endDateField').getValue();
		if((endDate!="")&&(endDate!=null)){
			endDate = endDate.format(App_StkDateFormat);
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
var auditInadjAudit = new Ext.Toolbar.Button({
	text:'审核',
    tooltip:'审核',
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
				url: InadjAuditGridUrl+'?actiontype=audit&adj='+mainRowId+'&userId='+UserId,
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
							startDate = startDate.format(App_StkDateFormat);
						}else{
							Msg.info("error","请选择起始日期!");
							return false;
						}
						var endDate = Ext.getCmp('endDateField').getValue();
						if((endDate!="")&&(endDate!=null)){
							endDate = endDate.format(App_StkDateFormat);
						}else{
							Msg.info("error","请选择截止日期!");
							return false;
						}
						var Audited = (Ext.getCmp('AuditedCK').getValue()==true?'Y':'N');
				
						var strPar = startDate+"^"+endDate+"^"+locId+"^"+Audited+"^N";
						
						InadjAuditGridDs.load();
						InadjAuditDetailGridDs.removeAll();
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
						Ext.Msg.show({
							title:'错误提示',
							msg:jsonData.info,
							buttons: Ext.Msg.OK,
							icon:Ext.MessageBox.ERROR
						});
						}
					}
				},
				scope: this
			});
		}
    }
});
function CancelAudit()
{
	var rowObj = InadjAuditGrid.getSelectionModel().getSelections(); 
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'注意',msg:'请选择需要取消审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		var audited=rowObj[0].get('chkFlag');
		if (audited!='Y'){Msg.info('warning','库存调整单尚未审核,无法取消!');return;}
		var inadj = rowObj[0].get("adj");
		if ((inadj==null)||(inadj=="")){Msg.info('warning','请选择需要取消审核的数据!');return;}
		Ext.MessageBox.confirm('提示','取消审核将处理当前库存,请谨慎操作!是否继续?',
			function(btn) {
				if(btn == 'yes'){
					Ext.Ajax.request({
						url: InadjAuditGridUrl+'?actiontype=CancelAudit&adj='+inadj,
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.MessageBox.confirm('提示','取消审核成功,是否删除库存调整单?',
									function(btn) {
										if(btn == 'yes'){
											Ext.Ajax.request({
												url: InadjAuditGridUrl+'?actiontype=delete&adj='+inadj,
												success: function(result, request) {
													var jsonData = Ext.util.JSON.decode( result.responseText );
													if (jsonData.success=='true') {
														Msg.info('success','删除成功!')
													}
													else{
														Msg.info('error',"删除失败!"+jsonData.info)
													}
												}
											})
	
										}
									}
								)
								query();
								
							}
							else{
								Msg.info('error',jsonData.info)
								return;
							
							}
						}
					})
	
				}
			}
		);
	}
}
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

var formPanel = new Ext.form.FormPanel({
	labelWidth : 60,
	labelAlign : 'right',
	autoScroll:true,
	autoHeight : true,
	frame : true,
	//layout : 'fit',
    tbar:[findInadjAudit,'-',auditInadjAudit,'-',CancelAuditBT,'-',printInadjAudit],
	items : [{	
		xtype : 'fieldset',
		title : '条件选项',		
		autoHeight : true,
		style:DHCSTFormStyle.FrmPaddingV,
		items : [{
			layout : 'column',
			items : [{	
            	xtype: 'fieldset',
            	columnWidth: 0.25, 
            	border: false,
				items : [locField]
			}, {
				xtype: 'fieldset',
				columnWidth : .2,
				border:false,
				items : [startDateField]
			}, {
				xtype: 'fieldset',
				columnWidth : .2,
				border:false,
				items : [endDateField]
			}, {
				xtype: 'fieldset',
				columnWidth : .25,
				border:false,
				labelWidth:10,
				items : [AuditedCK]
			}]
		}]
	}]
});

var InadjAuditPagingToolbar = new Ext.PagingToolbar({
	store:InadjAuditGridDs,
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
		B['strParam']=Ext.getCmp('startDateField').getValue().format(App_StkDateFormat)+"^"+Ext.getCmp('endDateField').getValue().format(App_StkDateFormat)+"^"+Ext.getCmp('locField').getValue()+"^"+(Ext.getCmp('AuditedCK').getValue()==true?'Y':'N')+"^N";
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
InadjAuditGrid = new Ext.grid.EditorGridPanel({
	store:InadjAuditGridDs,
	cm:InadjAuditGridCm,
	trackMouseOver:true,
	region:'north',
	stripeRows:true,
	sm : new Ext.grid.RowSelectionModel({singleSelect:true,
		listeners:{'rowselect':function(sm,rowIndex,rec){
			var adj = InadjAuditGridDs.data.items[rowIndex].data["adj"];
			if (adj!=''){
				mainRowId = adj;
				InadjAuditDetailGridDs.setBaseParam('adj',adj)
				InadjAuditDetailGridDs.load({params:{start:0,limit:InadjAuditItmPagingToolbar.pageSize}});
			}
		}}
		}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InadjAuditPagingToolbar
});
//=========================库存报损单审核=============================


//配置数据源
var InadjAuditDetailGridUrl = 'dhcst.inadjaction.csp';
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
		{name:'qty',type:'float'},
		{name:'uom'},
		{name:'uomDesc'},
		{name:'qtyBUOM'},
		{name:'rp',type:'float'},
		{name:'rpAmt',type:'float'},
		{name:'sp',type:'float'},
		{name:'spAmt',type:'float'},
		{name:'insti'}
	]),
    remoteSort:false
});


//模型
var InadjAuditDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 /*{
			header: '明细rowid',
			dataIndex: 'adjitm',
			width: 72,
			sortable:true,
			align: 'center'
		},{
			header: '批次rowid',
			dataIndex: 'inclb',
			width: 72,
			sortable:true,
			align: 'center'
		},{
			header: '药品rowid',
			dataIndex: 'inci',
			width: 72,
			sortable:true,
			align: 'center'
		},*/{
			header: '代码',
			dataIndex: 'code',
			width: 100,
			//sortable:true,
			align: 'center'
		},{
			header: '名称',
			dataIndex: 'desc',
			width: 200,
			//sortable:true,
			align: 'left'
		},{
			header:'规格',
			dataIndex:'spec',
			align:'left',
			width:100,
			//sortable:true
		},{
			header: "厂商",
			dataIndex: 'manf',
			width: 100,
			align: 'left',
			//sortable: true
		},{
			header: "批次~效期",
			dataIndex: 'batNo',
			width: 200,
			align: 'left',
			//sortable: true
		},{
			header: "调整数量",
			dataIndex: 'qty',
			width: 100,
			align: 'right',
			//sortable: true
		},{
			header:'单位',
			dataIndex:'uomDesc',
			align:'right',
			width:80,
			//sortable:true
		}/*,{
			header:'单价',
			dataIndex:'rp',
			align:'right',
			width:80,
			sortable:true
		}*/,{
			header:'进价',
			dataIndex:'rp',
			align:'right',
			width:80,
			//sortable:true
		},{
			header:'进价金额',
			dataIndex:'rpAmt',
			align:'right',
			width:100,
			//sortable:true,
			renderer:FormatGridRpAmount
		},{
			header:'售价',
			dataIndex:'sp',
			align:'right',
			width:80,
			//sortable:true
		},{
			header:'售价金额',
			dataIndex:'spAmt',
			align:'right',
			width:100,
			//sortable:true,
			renderer:FormatGridSpAmount
		}
]);
//初始化默认排序功能
InadjAuditDetailGridCm.defaultSortable = true;

var InadjAuditItmPagingToolbar = new Ext.PagingToolbar({
	store:InadjAuditDetailGridDs,
	pageSize:15,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录"
});

//表格
InadjAuditDetailGrid = new Ext.grid.EditorGridPanel({
	store:InadjAuditDetailGridDs,
	cm:InadjAuditDetailGridCm,
	trackMouseOver:true,
	region:'center',
	height:300,
	stripeRows:true,
	sm : new Ext.grid.CellSelectionModel({}),
	loadMask:true,
	clicksToEdit:1,
	bbar:InadjAuditItmPagingToolbar
});

InadjAuditGrid.on('rowclick',function(grid,rowIndex,e){
	//if  ( rowIndex>=0)
	//{
	//	var adj = InadjAuditGridDs.data.items[rowIndex].data["adj"];
	//	mainRowId = adj;
	//	InadjAuditDetailGridDs.load({params:{adj:adj}});
	//}
});
//===========模块主页面=============================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}	
	var panel = new Ext.Panel({
		title:'库存调整单审核',
		activeTab:0,
		region:'north',
		height:DHCSTFormStyle.FrmHeight(1),
		layout:'fit',
		items:[formPanel]                                 
	});
	
	var panel2 = new Ext.Panel({
		activeTab:0,
		region:'center',
		//height:document.body.clientHeight*0.34,
		layout:'fit',
		items:[InadjAuditGrid]                                 
	});
	var panel3= new Ext.Panel({
		activeTab:0,
		region:'south',
		height:document.body.clientHeight*0.45,
		layout:'fit',
		items:[InadjAuditDetailGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[panel,panel2,panel3],
		renderTo:'mainPanel'
	});
	query()
});
//===========模块主页面=============================================