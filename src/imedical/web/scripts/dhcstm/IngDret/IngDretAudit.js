// 名称:退货单审核管理
// 编写日期:2012-07-18
var URL = 'dhcstm.ingdretaction.csp';
var HospId=session['LOGON.HOSPID'];
var userId = session['LOGON.USERID'];
var locId = session['LOGON.CTLOCID'];
var groupId=session['LOGON.GROUPID'];
var ret = "";

//取高值管理参数
var UseItmTrack="";
if(gItmTrackParam.length<1){
	GetItmTrackParam();
	UseItmTrack=gItmTrackParam[0]=='Y'?true:false;
}

//起始日期
var startDate = new Ext.ux.DateField({
	id:'startDate',
	listWidth:180,
	allowBlank:true,
	fieldLabel:'起始日期',
	anchor:'90%',
	value:DefaultStDate()
	//,
	//editable:false
});
//截止日期
var endDate = new Ext.ux.DateField({
	id:'endDate',
	listWidth:180,
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
	anchor:'90%',
	emptyText:'退货科室...',
	groupId:groupId,
	childCombo : 'Vendor'
});

var Vendor = new Ext.ux.VendorComboBox({
	fieldLabel : '供应商',
	id : 'Vendor',
	anchor:'90%',
	params : {LocId : 'locField'}
});

var includeAudited=new Ext.form.Checkbox({
  fieldLabel:'仅已审核',
  anchor:'90%',
  id:'auditFlag'

});
var SendToSCMFlagData=[['全部','1'],['发送','2'],['未发送','3']];
var SendToSCMFlagStore = new Ext.data.SimpleStore({
	fields: ['STSCMdesc', 'STSCMid'],
	data : SendToSCMFlagData
});

var SendToSCMFlagCombo = new Ext.form.ComboBox({
	store: SendToSCMFlagStore,
	displayField:'STSCMdesc',
	mode: 'local', 
	anchor : '90%',
	emptyText:'',
	id:'SendToSCMFlagCombo',
	fieldLabel : '是否发送',
	triggerAction:'all', //取消自动过滤
	valueField : 'STSCMid'
});
Ext.getCmp("SendToSCMFlagCombo").setValue("1");
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
		{name:'scgDesc'}
	]),
	remoteSort:false,
	listeners : {
		'load' : function(ds){
			if (ds.getCount()>0){
				IngDretGrid.getSelectionModel().selectFirstRow();
				IngDretGrid.getView().focusRow(0);
			}
		}
	}
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
        header:"完成标志",
        dataIndex:'completed',
        width:80,
        align:'center',
        renderer:function(v, p, record){
			p.css += ' x-grid3-check-col-td';
			return '<div class="x-grid3-check-col'+(((v=='Y')||(v==true))?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
		}
    },
    	{
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
	/*
	if((vorId=="")||(vorId==null)){
		Msg.info("error","请选择供应商!");
		return false;
	} */
	var locId=Ext.getCmp("locField").getValue();
	if((locId=="")||(locId==null)){
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
	var SendFlag=Ext.getCmp("SendToSCMFlagCombo").getValue();
	var strPar=startDate+"^"+endDate+"^"+locId+"^"+vorId+"^"+auditFlag+"^"+completeFlag+"^"+SendFlag;
	IngDretGridDs.setBaseParam('strPar',strPar);
	IngDretGridDs.setBaseParam('sort','ingrt');
	IngDretGridDs.setBaseParam('dir','desc');
	IngDretDetailGrid.getStore().removeAll();
	IngDretGridDs.load({params:{start:0,limit:pagingToolbar.pageSize}});
}

var clearIngDret = new Ext.Toolbar.Button({
	text:'清空',
    tooltip:'清空',
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
	text:'审核通过',
    tooltip:'点击审核通过',
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
			if (audited=='Y'){Msg.info('error','已经审核');return;}
			
			var ingrt=rowObj[0].get("ingrt");
			
			///检查高值材料标签录入情况
			if(UseItmTrack && CheckHighValueLabels("R",ingrt)==false){
				return;
			}
			
			Ext.MessageBox.confirm('提示','确定要审核选定的退货单?',
				function(btn) {
					if(btn == 'yes'){
						var Ingrt = rowObj[0].get("ingrt");
						Ext.Ajax.request({
							url:URL+'?actiontype=audit&ret='+Ingrt+'&userId='+userId,
							failure: function(result, request) {
								Msg.info("error","请检查网络连接!");
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Msg.info("success","审核通过成功!");
									if(gParam[4] == 'Y'){
										var HVflag=GetCertDocHVFlag(Ingrt,"R");
										if (HVflag=="Y"){
										 PrintIngDretHVCol.defer(300,this,[Ingrt, 'Y']);
										}else{
										PrintIngDret.defer(300,this,[Ingrt, 'Y']);
										}
									}
									query();
								}else{
									if(jsonData.info==-2){
										Msg.info("error","退货单未完成,不能被审核!");
										return false;
									}else if(jsonData.info==-14){
										Msg.info("error","退货单中存在物资的批次库存小于退货数量!");
										return false;
									}else{
										Msg.info("error","审核失败!"+jsonData.info);
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

/*
var auditIngDret = new Ext.Toolbar.Button({
	text:'审核',
    tooltip:'审核',
    iconCls:'page_edit',
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
			if (audited=='Y'){Msg.info('error','已经审核');return;}
			
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
*/

///发送退货单到平台
var SendIngRetBT = new Ext.Toolbar.Button({
			id : "SendIngRetBT",
			text : '发送退货单到云平台',
			width : 70,
			height : 30,
			iconCls : 'page_find',
			handler : function() {
				    var rowData=IngDretGrid.getSelectionModel().getSelected();
					if (rowData ==null) {
						Msg.info("warning", "请选择需要发送的退货单!");
						return;
					}
					var IngRet = rowData.get("ingrt");
					SendIngRet(IngRet);
			}
});
function SendIngRet(IngRet){
	 var url = URL+ "?actiontype=SendIngRet";
        var loadMask=ShowLoadMask(Ext.getBody(),"发送退货单中...");
        Ext.Ajax.request({
                    url : url,
                    method : 'POST',
                    params:{IngRet:IngRet},
                    waitMsg : '处理中...',
                    success : function(result, request) {
                        var jsonData = Ext.util.JSON.decode(result.responseText);
                        if (jsonData.success == 'true') {
                            // 刷新界面
                            var IngrRowid = jsonData.info;
                            Msg.info("success", "发送成功!");
                            query();
                        } else {
                            var ret=jsonData.info;
                            if (ret==-2){
	                            Msg.info("error","该退货单已发送,不能被发送!");
								return false;
	                        }else{
                                Msg.info("error", jsonData.info);
                                return false;
	                        }
                        }
                    },
                    scope : this
                });
        loadMask.hide();
}
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
		var HVflag=GetCertDocHVFlag(Ingrt,"R");
		if (HVflag=="Y"){
		 PrintIngDretHVCol(Ingrt);
		}else{
		PrintIngDret(Ingrt);
		}
	}
});

var PrintHVCol = new Ext.Toolbar.Button({
	id : "PrintHVCol",
	text : '高值汇总打印',
	tooltip : '打印高值退货单',
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
		var HVflag=GetCertDocHVFlag(Ingrt,"R");
		if (HVflag=="Y"){
			PrintIngDretHVCol(Ingrt);
		}else{
			Msg.info("warning","非高值单据使用打印按钮即可!");
			return;
		}
	}
});

var pagingToolbar = new Ext.PagingToolbar({
	store:IngDretGridDs,
	pageSize:20,
	displayInfo:true,
	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
	emptyMsg:"没有记录"
//	,
//	doLoad:function(C){
//		var B={},
//		A=this.getParams();
//		B[A.start]=C;
//		B[A.limit]=this.pageSize;
//		B['sort']='ingrt';
//		B['dir']='desc';
//		B['strPar']=Ext.getCmp('startDate').getValue().format(ARG_DATEFORMAT)+"^"+Ext.getCmp('endDate').getValue().format(ARG_DATEFORMAT)+"^"+locId+"^"+Ext.getCmp('Vendor').getValue();
//		if(this.fireEvent("beforechange",this,B)!==false){
//			this.store.load({params:B});
//		}
//	}
});

//表格
var IngDretGrid = new Ext.grid.EditorGridPanel({
	region:'center',
	store:IngDretGridDs,
	title:'退货单',
	cm:IngDretGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:pagingToolbar
});

IngDretGrid.getSelectionModel().on('rowselect',function(x,rowIndex,y){
	ret = IngDretGridDs.data.items[rowIndex].data["ingrt"];
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
		{name:'inci'},
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
		{name:'Remark'},
		{name:'SpecDesc'}
		
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
        header:"inci",
        dataIndex:'inci',
        width:100,
        align:'left',
        sortable:true,
        hidden:true
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
        align:'right',
        sortable:true
    },{
        header:"发票金额",
        dataIndex:'invAmt',
        width:100,
        align:'right',
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
    },{
		header:"备注",
		dataIndex:'Remark',
		width:100,
		align:'left'
		
	},{
    	header:"具体规格",
   		dataIndex:'SpecDesc',
    	width:100,
   		align:'left'
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
	region:'south',
	height: 240,
	store:IngDretDetailGridDs,
	title:'退货单明细',
	cm:IngDretDetailGridCm,
	trackMouseOver:true,
	stripeRows:true,
	sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
	loadMask:true,
	clicksToEdit:1,
	bbar:IngDretDetailPagingToolbar
});

var formPanel = new Ext.ux.FormPanel({
		title:'退货单审核',
		tbar:[findIngDret,'-',clearIngDret,'-',auditIngDret,'-',printBT,'-',PrintHVCol,'-',SendIngRetBT],
		bodyStyle : 'padding:0px;',
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			autoHeight : true,
			items : [{
				layout : 'column',
				items : [{
					columnWidth : .4,
					layout : 'form',
					items : [locField,startDate]
				},{
					columnWidth : .4,
					layout : 'form',
					items : [Vendor,endDate]
				},{
					columnWidth : .2,
					layout : 'form',
					items : [includeAudited,SendToSCMFlagCombo]
				}]
			}]
		
		}]
	});
//===========模块主页面=================================================
Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	var mainPanel = new Ext.ux.Viewport({
		layout:'border',
		items:[formPanel,IngDretGrid,IngDretDetailGrid],
		renderTo:'mainPanel'
	});
	query();
});
//===========模块主页面=================================================