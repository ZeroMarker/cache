// 名称:退货单审核管理
// 编写日期:2012-07-18
var URL = 'dhcst.ingdretaction.csp';
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var groupId=session['LOGON.GROUPID'];
//var arr = window.status.split(":");
//var length = arr.length;

var ret = "";

//起始日期
var startDate = new Ext.form.DateField({
	id:'startDate',
	allowBlank:true,
	fieldLabel:'起始日期',
	anchor:'90%',
	value:DefaultStDate()
	//,
	//editable:false
});
//截止日期
var endDate = new Ext.form.DateField({
	id:'endDate',
	allowBlank:true,
	fieldLabel:'截止日期',
	anchor:'90%',
	value:DefaultEdDate()
	//,
	//editable:false
});

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:'退货科室',
	emptyText:'退货科室...',
	groupId:groupId
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor'
});

var includeAudited=new Ext.form.Checkbox({
  boxLabel:'仅已审核',
  id:'auditFlag'

});

//=========================退货单审核管理=================================
//配置数据源
var IngDretGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=selectOrder',method:'GET'});
var IngDretGridDs = new Ext.data.Store({
	proxy:IngDretGridProxy,
    reader:new Ext.data.JsonReader({
        totalProperty:'results',
        root:'rows'
    }, [
		{name:'ingrt'},
		{name:'vendor'},
		{name:'vendorName'},
		{name:'loc'},
		{name:'locDesc'},
		{name:'ingrtNo'},
		{name:'retDate'},
		{name:'retTime'},
		{name:'retUser'},
		{name:'retUserName'},
		{name:'auditDate'},
		{name:'auditTime'},
		{name:'auditUser'},
		{name:'auditUserName'},
		{name:'auditFlag'},
		{name:'completed'},
		{name:'adjCheque'},
		{name:'scg'},
		{name:'scgDesc'},
		{name:'rpAmt'},
		{name:'spAmt'},
		{name:'magIn'}	
	]),
    remoteSort:false
});

IngDretGridDs.on('beforeload',function(ds){ds.removeAll();});

//模型
var IngDretGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	 {
        header:"退货DR",
        dataIndex:'ingrt',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"退货单号",
        dataIndex:'ingrtNo',
        width:120,
        align:'left',
        sortable:true
    },{
        header:"供应商",
        dataIndex:'vendorName',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"制单人",
        dataIndex:'retUserName',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"制单日期",
        dataIndex:'retDate',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"完成标志",
        dataIndex:'completed',
        width:60,
        align:'center',
        renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },
    	{
        header:"制单时间",
        dataIndex:'retTime',
        width:80,
        align:'left',
        sortable:true
    },{
        header:'审核标志',
		dataIndex:'auditFlag',
        align:'center',
		width:60,
		sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:"审核人",
        dataIndex:'auditUserName',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"审核日期",
        dataIndex:'auditDate',
        width:80,
        align:'left',
        sortable:true
    },{
        header:"审核时间",
        dataIndex:'auditTime',
        width:80,
        align:'left',
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
        header:"进售差额",
        dataIndex:'magIn',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    }
]);

//初始化默认排序功能
IngDretGridCm.defaultSortable = true;

var findIngDret = new Ext.Toolbar.Button({
	text:'查询',
    tooltip:'查询',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
		query();
	}
});

function query(){
	var startDate = Ext.getCmp('startDate').getValue();
	if((startDate!="")&&(startDate!=null)){
		startDate = startDate.format(App_StkDateFormat);
	}else{
		Msg.info("error","请选择起始日期!");
		return false;
	}
	var endDate = Ext.getCmp('endDate').getValue();
	if((endDate!="")&&(endDate!=null)){
		endDate = endDate.format(App_StkDateFormat);
	}else{
		Msg.info("error","请选择截止日期!");
		return false;
	}
	
	var vorId = Ext.getCmp('Vendor').getValue();
	/*
	if((vorId=="")||(vorId==null)){
		Msg.info("error","请选择供应商!");
		return false;
	} */
	
	/*if((locId=="")||(locId==null)){
		Msg.info("error","请选择科室!");
		return false;
	}*/
	var rLocdr=Ext.getCmp('locField').getValue();
	//修改为取选择科室 wyx
	if((rLocdr=="")||(rLocdr==null)){
		Msg.info("error","请选择科室!");
		return false;
	}
	//审核标志
	if (Ext.getCmp('auditFlag').getValue()==true)
	{
		var auditFlag="Y";
	}
	else
	{
		var auditFlag="N";
	}
	var completeFlag="Y" ; //完成标志
	var strPar=startDate+"^"+endDate+"^"+rLocdr+"^"+vorId+"^"+auditFlag+"^"+completeFlag;
	IngDretGridDs.setBaseParam('strPar',strPar);
	IngDretGridDs.setBaseParam('sort','ingrt');
	IngDretGridDs.setBaseParam('dir','desc');
	IngDretDetailGrid.getStore().removeAll();
	IngDretGridDs.load({params:{start:0,limit:pagingToolbar.pageSize}});
}

IngDretGridDs.on('load',function(ds){
	if (ds.getCount()>0)
	{
		IngDretGrid.getSelectionModel().selectFirstRow();
		IngDretGrid.getView().focusRow(0);
	}
	
});

var clearIngDret = new Ext.Toolbar.Button({
	text:'清屏',
    tooltip:'清屏',
    iconCls:'page_clearscreen',
	width : 70,
	height : 30,
	handler:function(){
		Ext.getCmp('Vendor').setValue('');
	 	Ext.getCmp('auditFlag').setValue('');
			
	 	IngDretGrid.getStore().removeAll();
	 	IngDretGrid.view.refresh();
	 	//IngDretGrid.getStore().setBaseParam('locId','');

	 	IngDretDetailGrid.getStore().removeAll();
	 	IngDretDetailGrid.view.refresh();
	}
});

var auditIngDret = new Ext.Toolbar.Button({
	text:'审核',
    tooltip:'审核',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
	
		var rowObj = IngDretGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var audited=rowObj[0].get('auditFlag');
			if (audited=='Y'){Msg.info('warning','已经审核');return;}
			
			Ext.MessageBox.confirm('提示','确定要审核选定的退货单?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:URL+'?actiontype=audit&ret='+rowObj[0].get("ingrt")+'&userId='+userId,
							failure: function(result, request) {
								Msg.info("error","请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success","审核成功!");
									query();
								}else{
									if(jsonData.info==-2){
										Msg.info("warning","退货单未完成,不能被审核!");
										return false;
									}else if(jsonData.info==-14){
										Msg.info("warning","退货单中存在物资的批次库存小于退货数量!");
										return false;
									}else{
										Msg.info("error","审核失败!　"+jsonData.info);
										return false;
									}
								}
							},
							scope: this
						});
					}
				}
			)
		}
	}
});

var cancelauditIngDret = new Ext.Toolbar.Button({
	text:'取消审核',
    tooltip:'取消审核,库存将返回!',
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){	
		var rowObj = IngDretGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要取消审核的退货单!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var audited=rowObj[0].get('auditFlag');
			if (audited!='Y'){Msg.info('warning','退货单尚未审核');return;}
			
			Ext.MessageBox.confirm('提示','取消审核将增加当前库存,请谨慎操作!是否继续?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:URL+'?actiontype=CancelAudit&ret='+rowObj[0].get("ingrt"),
							failure: function(result, request) {
								Msg.info("error","请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success","取消审核成功!请及时处理退货单!");
									query();
								}else{
									Msg.info("error",jsonData.info);
									return false;
								}
							},
							scope: this
						});
					}
				}
			)
		}
	}
});

var printBT = new Ext.Toolbar.Button({
	id : "printBT",
	text : '打印',
	tooltip : '打印退货单',
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=IngDretGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "请选择需要打印的退货单!");
			return;
		}
		var Ingrt = rowData.get("ingrt");
		PrintIngDret(Ingrt);
	}
});

var pagingToolbar = new Ext.PagingToolbar({
	store:IngDretGridDs,
	pageSize:20,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录"
});

//表格
var IngDretGrid = new Ext.grid.EditorGridPanel({
	store:IngDretGridDs,
	title:'退货单',
	cm:IngDretGridCm,
	trackMouseOver:true,
	height:170, //document.body.clientHeight*0.35, 
	stripeRows:true,
	clicksToEdit:0,
	region:'north',
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:pagingToolbar
});

IngDretGrid.getSelectionModel().on('rowselect',function(x,rowIndex,y){
	var ret = IngDretGridDs.data.items[rowIndex].data["ingrt"];
	IngDretDetailGridDs.setBaseParam('ret',ret);
	IngDretDetailGridDs.load({params:{start:0,limit:IngDretDetailPagingToolbar.pageSize,sort:'ingrti',dir:'desc',ret:ret}});
	
})
//=========================退货单审核管理=================================
var IngDretDetailGrid="";
//配置数据源
var IngDretDetailGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=select',method:'GET'});
var IngDretDetailGridDs = new Ext.data.Store({
	proxy:IngDretDetailGridProxy,
    reader:new Ext.data.JsonReader({
        totalProperty:'results',
        root:'rows'
    }, [
		{name:'ingrti'},
		{name:'ingri'},
		{name:'inclb'},
		{name:'code'},
		{name:'desc'},
		{name:'spec'},
		{name:'batNo'},
		{name:'expDate'},
		{name:'manf'},
		{name:'qty'},
		{name:'uomDesc'},
		{name:'rp'},
		{name:'rpAmt'},
		{name:'sp'},
		{name:'spAmt'},
		{name:'oldSp'},
		{name:'oldSpAmt'},
		{name:'invNo'},
		{name:'invDate'},
		{name:'invAmt'},
		{name:'sxNo'},
		{name:'retReason'}
	]),
    remoteSort:false
});


//模型
var IngDretDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
        header:"退货子表rowid",
        dataIndex:'ingrti',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:"代码",
        dataIndex:'code',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"名称",
        dataIndex:'desc',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"单位",
        dataIndex:'uomDesc',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"规格",
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"退货数量",
        dataIndex:'qty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"批号",
        dataIndex:'batNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"有效期",
        dataIndex:'expDate',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"厂商",
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:"退货原因",
        dataIndex:'retReason',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"退货进价",
        dataIndex:'rp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"进价金额",
        dataIndex:'rpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:"售价",
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"售价金额",
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    },{
        header:"批价",
        dataIndex:'oldSp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"批价金额",
        dataIndex:'oldSpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridPpAmount
    },{
        header:"入库售价",
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"发票金额",
        dataIndex:'invAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:"发票号",
        dataIndex:'invNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"发票日期",
        dataIndex:'invDate',
        width:100,
        align:'left',
        sortable:true
    }
]);

//初始化默认排序功能
IngDretDetailGridCm.defaultSortable = true;

var IngDretDetailPagingToolbar = new Ext.PagingToolbar({
    store:IngDretDetailGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    emptyMsg:"没有记录"
});

//表格
IngDretDetailGrid = new Ext.grid.EditorGridPanel({
	store:IngDretDetailGridDs,
	title:'退货单明细',
	cm:IngDretDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	region:'center',
	clicksToEdit:0,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:IngDretDetailPagingToolbar
});
//=============退货单主表与退货单明细二级联动===================
IngDretGrid.on('rowclick',function(grid,rowIndex,e){
	//ret = IngDretGridDs.data.items[rowIndex].data["ingrt"];
	//IngDretDetailGridDs.load({params:{start:0,limit:IngDretDetailPagingToolbar.pageSize,sort:'ingrti',dir:'desc',ret:ret}});
});
//=============退货单主表与退货单明细二级联动===================
var formPanel = new Ext.form.FormPanel({
		labelWidth : 60,
		labelAlign : 'right',
		region:'north',
		autoHeight:true,
		title:'退货单审核',
		frame:true,
		//bodyStyle : 'padding:0px 0px 0px 0px;',	
		tbar:[findIngDret,'-',clearIngDret,'-',auditIngDret,'-',cancelauditIngDret,'-',printBT],
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			autoHeight : true,
			layout : 'column',
			defaults: { border:false}, 
			style:DHCSTFormStyle.FrmPaddingV,
			items : [{
				columnWidth : .3,
				xtype : 'fieldset',
				items : [locField,startDate]
			},{
				columnWidth : .3,
				xtype : 'fieldset',
				//defaultType: 'textfield',
				items : [Vendor,endDate]
			},{
				columnWidth : .3,
				xtype : 'fieldset',
				listWidth:10,
				//defaultType: 'textfield',
				items : [includeAudited]
			}]
		}]
	});
//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}	
	var IngDretPanel = new Ext.Panel({
		layout:'border',
    	region:'center',
		
		activeTab: 0,
		items:[IngDretGrid,IngDretDetailGrid]                                 
	});
	
	var mainPanel = new Ext.Viewport({
		layout:'border',
		items:[{
            region: 'north',
            height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
            layout: 'fit', // specify layout manager for items
            items:formPanel
        },IngDretPanel],
		renderTo:'mainPanel'
	});
	query();
});
//===========模块主页面=================================================