// 名称:退货单审核管理
// 编写日期:2012-07-18
var URL = 'dhcstm.ingdretauditaction.csp';
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var arr = window.status.split(":");
var length = arr.length;
var IngDretGrid;
var ret = "";

//起始日期
var startDate = new Ext.ux.DateField({
	id:'startDate',
	width:210,
	listWidth:210,
	allowBlank:true,
	fieldLabel:'起始日期',
	anchor:'90%',
	value:new Date(),
	editable:false
});
//截止日期
var endDate = new Ext.ux.DateField({
	id:'endDate',
	width:210,
	listWidth:210,
	allowBlank:true,
	fieldLabel:'截止日期',
	anchor:'90%',
	value:new Date(),
	editable:false
});

var locField = new Ext.form.ComboBox({
	id:'locField',
	fieldLabel:'退货科室',
	width:210,
	listWidth:210,
	allowBlank:true,
	store:GetGroupDeptStore,
	valueField:'RowId',
	displayField:'Description',
	emptyText:'退货科室...',
	triggerAction:'all',
	emptyText:'',
	minChars:1,
	pageSize:999,
	selectOnFocus:true,
	forceSelection:true,
	editable:true
});
GetGroupDeptStore.load();
GetGroupDeptStore.on('load',function(ds,records,o){
	Ext.getCmp('locField').setRawValue(arr[length-1]);
	Ext.getCmp('locField').setValue(locId);
});	

var Vendor = new Ext.form.ComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	name : 'Vendor',
	anchor : '90%',
	width : 210,
	store : APCVendorStore,
	valueField : 'RowId',
	displayField : 'Description',
	allowBlank : true,
	triggerAction : 'all',
	emptyText : '',
	selectOnFocus : true,
	forceSelection : true,
	minChars : 1,
	pageSize : 999,
	listWidth : 210,
	valueNotFoundText : ''
});
//=========================退货单审核管理=================================
var IngDretGrid="";
//配置数据源
var IngDretGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=selectBatch',method:'GET'});
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
		{name:'scgDesc'}
	]),
    remoteSort:false
});
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
        width:100,
        align:'left',
        sortable:true
    },{
        header:"制单日期",
        dataIndex:'retDate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"制单时间",
        dataIndex:'retTime',
        width:100,
        align:'left',
        sortable:true
    },{
        header:'审核标志',
		dataIndex:'auditFlag',
        align:'center',
		width:120,
		sortable:true,
		renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },{
        header:"审核人",
        dataIndex:'auditUserName',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"审核日期",
        dataIndex:'auditDate',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"审核时间",
        dataIndex:'auditTime',
        width:100,
        align:'left',
        sortable:true
    }/*,{
        header:"进价金额",
        dataIndex:'expdate',
        width:100,
        align:'right',
        sortable:true
    },{
        header:"入库售价金额",
        dataIndex:'recqty',
        width:100,
        align:'right',
        sortable:true
    }*/
]);

//初始化默认排序功能
IngDretGridCm.defaultSortable = true;

var findIngDret = new Ext.Toolbar.Button({
	text:'查找',
    tooltip:'查找',
    iconCls:'page_find',
	width : 70,
	height : 30,
	handler:function(){
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
		var vorId = Ext.getCmp('Vendor').getValue();
		if((vorId=="")||(vorId==null)){
			Msg.info("error","请选择供应商!");
			return false;
		}
		if((locId=="")||(locId==null)){
			Msg.info("error","请选择科室!");
			return false;
		}
		IngDretGridDs.load({params:{start:0,limit:pagingToolbar.pageSize,sort:'ingrt',dir:'desc',strPar:startDate+"^"+endDate+"^"+locId+"^"+vorId}});
	}
});


IngDretGridDs.addListener('load',function(){
	IngDretGrid.getSelectionModel().selectFirstRow();
});

var clearIngDret = new Ext.Toolbar.Button({
	text:'清除',
    tooltip:'清除',
    iconCls:'page_delete',
	width : 70,
	height : 30,
	handler:function(){
		IngDretGridDs.removeAll();
		IngDretDetailGridDs.removeAll();
	}
});

var auditIngDret = new Ext.Toolbar.Button({
	text:'审核',
    tooltip:'审核',
    iconCls:'page_edit',
	width : 70,
	height : 30,
	handler:function(){
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
		var vorId = Ext.getCmp('Vendor').getValue();
		if((vorId=="")||(vorId==null)){
			Msg.info("error","请选择供应商!");
			return false;
		}
		if((locId=="")||(locId==null)){
			Msg.info("error","请选择科室!");
			return false;
		}
	
		var rowObj = IngDretGrid.getSelectionModel().getSelections(); 
		var len = rowObj.length;
		if(len < 1){
			Ext.Msg.show({title:'注意',msg:'请选择需要审核的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			return false;
		}else{
			Ext.MessageBox.confirm('提示','确定要审核选定的行?',
				function(btn) {
					if(btn == 'yes'){
						Ext.Ajax.request({
							url:URL+'?actiontype=audit&ret='+rowObj[0].get("ingrt")+'&userId='+userId,
							waitMsg:'删除中...',
							failure: function(result, request) {
								Msg.info("error","请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success","审核成功!");
									IngDretGridDs.load({params:{start:0,limit:pagingToolbar.pageSize,sort:'ingrt',dir:'desc',strPar:startDate+"^"+endDate+"^"+locId+"^"+vorId}});
								}else{
									if(jsonData.info==-2){
										Msg.info("error","退货单未完成,不能被审核!");
										return false;
									}else{
										Msg.info("error","审核失败!");
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

var pagingToolbar = new Ext.PagingToolbar({
	store:IngDretGridDs,
	pageSize:20,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['sort']='ingrt';
		B['dir']='desc';
		B['strPar']=Ext.getCmp('startDate').getValue().format(ARG_DATEFORMAT)+"^"+Ext.getCmp('endDate').getValue().format(ARG_DATEFORMAT)+"^"+locId+"^"+Ext.getCmp('Vendor').getValue();
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
IngDretGrid = new Ext.grid.EditorGridPanel({
	store:IngDretGridDs,
	cm:IngDretGridCm,
	trackMouseOver:true,
	height:250,
	stripeRows:true,
	clicksToEdit:0,
	region:'north',
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:pagingToolbar
});
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
		{name:'uom'},
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
        dataIndex:'uom',
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
        header:"产地",
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
        sortable:true
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
        sortable:true
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
        sortable:true
    },{
        header:"入库售价",
        dataIndex:'sp',
        width:100,
        align:'left',
        sortable:true
    },{
        header:"入库售价金额",
        dataIndex:'invAmt',
        width:100,
        align:'left',
        sortable:true
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
    emptyMsg:"没有记录",
	doLoad:function(C){
		var B={},
		A=this.getParams();
		B[A.start]=C;
		B[A.limit]=this.pageSize;
		B['sort']='ingrti';
		B['dir']='desc';
		B['ret']=ret;
		if(this.fireEvent("beforechange",this,B)!==false){
			this.store.load({params:B});
		}
	}
});

//表格
IngDretDetailGrid = new Ext.grid.EditorGridPanel({
	store:IngDretDetailGridDs,
	cm:IngDretDetailGridCm,
	trackMouseOver:true,
	height:350,
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
	ret = IngDretGridDs.data.items[rowIndex].data["ingrt"];
	IngDretDetailGridDs.load({params:{start:0,limit:IngDretDetailPagingToolbar.pageSize,sort:'ingrti',dir:'desc',ret:ret}});
});
//=============退货单主表与退货单明细二级联动===================
var formPanel = new Ext.form.FormPanel({
		labelwidth : 30,
		autoScroll:true,
		labelAlign : 'right',
		region:'north',
		height:113,
		frame:true,
		tbar:[findIngDret,'-',clearIngDret,'-',auditIngDret],
		autoScroll : true,
		bodyStyle : 'padding:0px;',
		items : [{
			autoHeight : true,
			layout : 'column',
			items : [{
				xtype : 'fieldset',
				title : '选项',
				width:1340,
				autoHeight : true,
				items : [{
					layout : 'column',
					items : [{
						columnWidth : .25,
						layout : 'form',
						items : [locField]
					},{
						columnWidth : .25,
						layout : 'form',
						items : [startDate]
					},{
						columnWidth : .25,
						layout : 'form',
						items : [endDate]
					},{
						columnWidth : .25,
						layout : 'form',
						items : [Vendor]
					}]
				}]
			}]
		}]
	});
//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var IngDretPanel = new Ext.Panel({
		layout:'border',
    	region:'center',
		title:'退货单审核管理',
		activeTab: 0,
		items:[IngDretGrid,IngDretDetailGrid]                                 
	});
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,IngDretPanel],
		renderTo:'mainPanel'
	});
});
//===========模块主页面=================================================