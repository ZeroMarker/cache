// 名称:退货单审核管理
// 编写日期:2012-07-18
var URL = 'dhcst.ingdretaction.csp';
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var groupId=session['LOGON.GROUPID'];
var APPName="DHCSTPURPLANAUDIT"
var PurPlanParam=PHA_COM.ParamProp(APPName)

//var arr = window.status.split(":");
//var length = arr.length;

var ret = "";

//起始日期
var startDate = new Ext.form.DateField({
	id:'startDate',
	allowBlank:true,
	fieldLabel:$g('起始日期'),
	anchor:'90%',
	value:DefaultStDate()
	//,
	//editable:false
});
//截止日期
var endDate = new Ext.form.DateField({
	id:'endDate',
	allowBlank:true,
	fieldLabel:$g('截止日期'),
	anchor:'90%',
	value:DefaultEdDate()
	//,
	//editable:false
});

var locField = new Ext.ux.LocComboBox({
	id:'locField',
	fieldLabel:$g('退货科室'),
	emptyText:$g('退货科室...'),
	groupId:groupId
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : $g('经营企业'),
	id : 'Vendor',
	name : 'Vendor'
});

var includeAudited=new Ext.form.Checkbox({
  boxLabel:$g('仅已审核'),
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
        header:$g("退货DR"),
        dataIndex:'ingrt',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("退货单号"),
        dataIndex:'ingrtNo',
        width:120,
        align:'left',
        sortable:true
    },{
        header:$g("经营企业"),
        dataIndex:'vendorName',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("制单人"),
        dataIndex:'retUserName',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("制单日期"),
        dataIndex:'retDate',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("完成标志"),
        dataIndex:'completed',
        width:60,
        align:'center',
        renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },
    	{
        header:$g("制单时间"),
        dataIndex:'retTime',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g('审核标志'),
		dataIndex:'auditFlag',
        align:'center',
		width:60,
		sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:$g("审核人"),
        dataIndex:'auditUserName',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("审核日期"),
        dataIndex:'auditDate',
        width:80,
        align:'left',
        sortable:true
    },{
        header:$g("审核时间"),
        dataIndex:'auditTime',
        width:80,
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
    },{
        header:$g("进售差额"),
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
	text:$g('查询'),
    tooltip:$g('查询'),
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
		Msg.info("error",$g("请选择起始日期!"));
		return false;
	}
	var endDate = Ext.getCmp('endDate').getValue();
	if((endDate!="")&&(endDate!=null)){
		endDate = endDate.format(App_StkDateFormat);
	}else{
		Msg.info("error",$g("请选择截止日期!"));
		return false;
	}
	
	var vorId = Ext.getCmp('Vendor').getValue();
	/*
	if((vorId=="")||(vorId==null)){
		Msg.info("error","请选择经营企业!");
		return false;
	} */
	
	/*if((locId=="")||(locId==null)){
		Msg.info("error","请选择科室!");
		return false;
	}*/
	var rLocdr=Ext.getCmp('locField').getValue();
	//修改为取选择科室 wyx
	if((rLocdr=="")||(rLocdr==null)){
		Msg.info("error",$g("请选择科室!"));
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
	text:$g('清屏'),
    tooltip:$g('清屏'),
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
	id:"auditIngDret",
	text:$g('审核'),
    tooltip:$g('审核'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){
	
		var rowObj = IngDretGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:$g('注意'),msg:$g('请选择需要审核的数据!'),buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var audited=rowObj[0].get('auditFlag');
			if (audited=='Y'){Msg.info('warning',$g('已经审核'));return;}
			
			Ext.MessageBox.confirm($g('提示'),$g('确定要审核选定的退货单?'),
				function(btn) {
					if(btn == 'yes'){
						///检查预算项目
						var ret = SendBusiData(rowObj[0].get("ingrt"),"RETURN","AUDIT")
						if(!ret) return;

						Ext.Ajax.request({
							url:URL+'?actiontype=audit&ret='+rowObj[0].get("ingrt")+'&userId='+userId,
							failure: function(result, request) {
								Msg.info("error",$g("请检查网络连接!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success",$g("审核成功!"));
									query();
								}else{
									if(jsonData.info==-2){
										Msg.info("warning",$g("退货单未完成,不能被审核!"));
										return false;
									}else if(jsonData.info==-14){
										Msg.info("warning",$g("退货单中存在物资的批次库存小于退货数量!"));
										return false;
									}else{
										Msg.info("error",$g("审核失败!")+jsonData.info);
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
	text:$g('取消审核'),
    tooltip:$g('取消审核,库存将返回!'),
    iconCls:'page_gear',
	width : 70,
	height : 30,
	handler:function(){	
		var rowObj = IngDretGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:$g('注意'),msg:$g('请选择需要取消审核的退货单!'),buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			var audited=rowObj[0].get('auditFlag');
			if (audited!='Y'){Msg.info('warning',$g('退货单尚未审核'));return;}
			
			Ext.MessageBox.confirm($g('提示'),$g('取消审核将增加当前库存,请谨慎操作!是否继续?'),
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:URL+'?actiontype=CancelAudit&ret='+rowObj[0].get("ingrt"),
							failure: function(result, request) {
								Msg.info("error",$g("请检查网络连接!"));
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success",$g("取消审核成功!请及时处理退货单!"));
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
	text : $g('打印'),
	tooltip : $g('打印退货单'),
	width : 70,
	height : 30,
	iconCls : 'page_print',
	handler : function() {
		var rowData=IngDretGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", $g("请选择需要打印的退货单!"));
			return;
		}
		var Ingrt = rowData.get("ingrt");
		PrintIngDret(Ingrt);
	}
});


/* 列设置按钮 */
var GridColSetBT = new Ext.Toolbar.Button({
	text:$g('列设置'),
	tooltip:$g('列设置'),
	iconCls:'page_gear',
	handler:function(){
		GridSelectWin.show();
	}
});

// 确定按钮
var returnColSetBT = new Ext.Toolbar.Button({
	text : $g('确定'),
	tooltip : $g('点击确定'),
	iconCls : 'page_goto',
	handler : function() {
		var selectradio = Ext.getCmp('GridSelectModel').getValue();
		if(selectradio){
			var selectModel =selectradio.inputValue;	
			if (selectModel=='1') {
				GridColSet(IngDretGrid,"DHCSTRETURN");	
			}
			else {
				GridColSet(IngDretDetailGrid,"DHCSTRETURN");   							
			}						
		}
		GridSelectWin.hide();
	}
});

// 取消按钮
var cancelColSetBT = new Ext.Toolbar.Button({
		text : $g('取消'),
		tooltip : $g('点击取消'),
		iconCls : 'page_delete',
		handler : function() {
			GridSelectWin.hide();
		}
	});

//选择按钮
var GridSelectWin=new Ext.Window({
	title:$g('选择'),
	width : 210,
	height : 110,
	labelWidth:100,
	closeAction:'hide' ,
	plain:true,
	modal:true,
	items:[{
		xtype:'radiogroup',
		id:'GridSelectModel',
		anchor: '95%',
		columns: 2,
		style: 'padding:10px 10px 10px 10px;',
		items : [{
				checked: true,				             
					boxLabel: $g('退货单'),
					id: 'GridSelectModel1',
					name:'GridSelectModel',
					inputValue: '1' 							
				},{
				checked: false,				             
					boxLabel: $g('退货单明细'),
					id: 'GridSelectModel2',
					name:'GridSelectModel',
					inputValue: '2' 							
				}]
			}],
	
	buttons:[returnColSetBT,cancelColSetBT]
   })



var pagingToolbar = new Ext.PagingToolbar({
	store:IngDretGridDs,
	pageSize:20,
	displayInfo:true,
	displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
	emptyMsg:$g("没有记录")
});

//表格
var IngDretGrid = new Ext.grid.EditorGridPanel({
	store:IngDretGridDs,
	title:$g('退货单'),
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
		{name:'retReason'},
		{name:'InsuCode'},
		{name:'InsuDesc'}
	]),
    remoteSort:false
});


//模型
var IngDretDetailGridCm = new Ext.grid.ColumnModel([
	 new Ext.grid.RowNumberer(),
	{
        header:$g("退货子表rowid"),
        dataIndex:'ingrti',
        width:100,
        align:'left',
        sortable:true,
		hidden:true
    },{
        header:$g("代码"),
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
        header:$g("单位"),
        dataIndex:'uomDesc',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("规格"),
        dataIndex:'spec',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("退货数量"),
        dataIndex:'qty',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("批号"),
        dataIndex:'batNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("有效期"),
        dataIndex:'expDate',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("生产企业"),
        dataIndex:'manf',
        width:200,
        align:'left',
        sortable:true
    },{
        header:$g("退货原因"),
        dataIndex:'retReason',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("退货进价"),
        dataIndex:'rp',
        width:100,
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
        header:$g("售价"),
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("售价金额"),
        dataIndex:'spAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridSpAmount
    },{
        header:$g("批价"),
        dataIndex:'oldSp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("批价金额"),
        dataIndex:'oldSpAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridPpAmount
    },{
        header:$g("入库售价"),
        dataIndex:'sp',
        width:100,
        align:'right',
        sortable:true
    },{
        header:$g("发票金额"),
        dataIndex:'invAmt',
        width:100,
        align:'right',
        sortable:true,
        renderer:FormatGridRpAmount
    },{
        header:$g("发票号"),
        dataIndex:'invNo',
        width:100,
        align:'left',
        sortable:true
    },{
        header:$g("发票日期"),
        dataIndex:'invDate',
        width:100,
        align:'left',
        sortable:true
    },{
		header : "国家医保编码",
		dataIndex : 'InsuCode',
		width : 100,
		align : ''
	},{
		header : "国家医保名称",
		dataIndex : 'InsuDesc',
		width : 100,
		align : ''
	}
]);

//初始化默认排序功能
IngDretDetailGridCm.defaultSortable = true;

var IngDretDetailPagingToolbar = new Ext.PagingToolbar({
    store:IngDretDetailGridDs,
	pageSize:20,
    displayInfo:true,
    displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
    emptyMsg:$g("没有记录")
});

//表格
IngDretDetailGrid = new Ext.grid.EditorGridPanel({
	store:IngDretDetailGridDs,
	title:$g('退货单明细'),
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
		title:$g('退货单审核'),
		frame:true,
		//bodyStyle : 'padding:0px 0px 0px 0px;',	
		tbar:[findIngDret,'-',clearIngDret,'-',auditIngDret,'-',cancelauditIngDret,'-',printBT,'-',GridColSetBT],
		items : [{
			xtype : 'fieldset',
			title : $g('查询条件'),
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
				items : [includeAudited,BudgetProComb]
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
	RefreshGridColSet(IngDretGrid,"DHCSTRETURN");   
	RefreshGridColSet(IngDretDetailGrid,"DHCSTRETURN"); 
	query();
	SetBudgetPro(Ext.getCmp("locField").getValue(),"RETURN",[3],"auditIngDret") //加载HRP预算项目
});
//===========模块主页面=================================================
