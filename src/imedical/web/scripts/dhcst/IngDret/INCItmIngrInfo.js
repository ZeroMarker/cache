// /名称: 退货单制单:可退货批次窗口
// /描述: 退货单制单:可退货批次窗口
// /编写者：zhangdongmei
// /编写日期: 2012.10.31
IngrBtInfo = function(InciDr, PhaLoc, Venid,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;

	var IngDretGrid="";
	//配置数据源
	//IngDretGridDs.load({params:{strPar:,start:0,limit:IngDretPagingToolbar.pageSize}});
	var strParam=PhaLoc+"^"+InciDr+"^"+Venid+"^Y";
	var IngDretGridProxy= new Ext.data.HttpProxy({url:'dhcst.ingdretaction.csp?actiontype=selectBatch&strPar='+strParam+
	'&start=0&limit=20',method:'GET'});
	var IngDretGridDs = new Ext.data.Store({
		proxy:IngDretGridProxy,
	    reader:new Ext.data.JsonReader({
	        totalProperty:'results',
	        root:'rows'
	    }, [
			{name:'INGRI'},
			{name:'code'},
			{name:'desc'},
			{name:'mnf'},
			{name:'batch'},
			{name:'expdate'},
			{name:'recqty'},
			{name:'stkqty'},
			{name:'uom'},
			{name:'uomDesc'},
			{name:'pp'},
			{name:'sven'},
			{name:'idate'},
			{name:'rp'},
			{name:'sp'},
			{name:'INCLB'},
			{name:'iniflag'},
			{name:'Drugform'},
			{name:'invNo'},
			{name:'invDate',type:'date',dateFormat:'Y-m-d'},
			{name:'invAmt'},
			{name:'venid'},
			{name:'buom'},
			{name:'confac'}
		]),
	    remoteSort:false,
	    autoLoad:false
	});
	
	//模型
	var IngDretGridCm = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		 {
	        header:"批次DR",
	        dataIndex:'INCLB',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:true
	    },{
	        header:"入库明细表rowid",
	        dataIndex:'INGRI',
	        width:100,
	        align:'left',
	        sortable:true,
			hidden:true
	    },{
	        header:"供应商",
	        dataIndex:'sven',
	        width:100,
	        align:'left',
	        sortable:true
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
	        header:"入库数量",
	        dataIndex:'recqty',
	        width:80,
	        align:'right',
	        sortable:true
	    },{
	        header:"入库单位",
	        dataIndex:'uomDesc',
	        width:80,
	        align:'left',
	        sortable:true
	    },{
	        header:"现库存数量",
	        dataIndex:'stkqty',
	        width:80,
	        align:'right',
	        sortable:true
	    },{
	        header:"批号",
	        dataIndex:'batch',
	        width:80,
	        align:'left',
	        sortable:true
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
	        header:"售价金额",
	        dataIndex:'spAmt',
	        width:100,
	        align:'right',
	        sortable:true
	    },{
	        header:"效期",
	        dataIndex:'expdate',
	        width:100,
	        align:'left',
	        sortable:true
	    },{
	        header:"入库日期",
	        dataIndex:'idate',
	        width:100,
	        align:'left',
	        sortable:true
	    },{
	        header:"剂型",
	        dataIndex:'Drugform',
	        width:80,
	        align:'left',
	        sortable:true
	    },{
	        header:"产地",
	        dataIndex:'mnf',
	        width:200,
	        align:'left',
	        sortable:true
	    }
	]);

	//初始化默认排序功能
	IngDretGridCm.defaultSortable = true;
	
	var IngDretPagingToolbar = new Ext.PagingToolbar({
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
			B['strPar']=PhaLoc+"^"+InciDr+"^"+Venid+"^Y";
			if(this.fireEvent("beforechange",this,B)!==false){
				this.store.load({params:B});
			}
		}
	});
	
	//表格
	IngDretGrid = new Ext.grid.GridPanel({
		store:IngDretGridDs,
		cm:IngDretGridCm,
		trackMouseOver:true,
		height:200,
		stripeRows:true,
		//clicksToEdit:0,
		region:'north',
		sm:new Ext.grid.RowSelectionModel({singleSelect:true}),
		loadMask:true,
		clicksToEdit:1,
		bbar:IngDretPagingToolbar
	});

	// 返回按钮
	var returnBT = new Ext.Toolbar.Button({
		text : '返回',
		tooltip : '点击返回',
		iconCls : 'page_goto',
		handler : function() {
			returnData();
		}
	});
	/**
	 * 返回数据
	 */
	function returnData() {
		var selectRow = IngDretGrid.getSelectionModel().getSelected();
		if (selectRow==null) {
			Msg.info("warning", "请选择一条批次信息！");
		} else {
			flg = true;
			window.close();
		}
	}

	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '点击关闭',
		iconCls : 'page_delete',
		handler : function() {
			flg = false;
			window.close();
		}
	});

	// 双击事件
	IngDretGrid.on('rowdblclick', function() {
				returnData();
	});
	// 回车事件
	IngDretGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			returnData();
		}
	});

	var window = new Ext.Window({
		title : '库存项入库批次信息',
		width : 700,
		height : 400,
		layout : 'fit',
		plain : true,
		modal : true,
		buttonAlign : 'center',
		autoScroll : true,
		items : IngDretGrid
	});

	window.show();

	window.on('close', function(panel) {
		var selectRow = IngDretGrid.getSelectionModel()
				.getSelected();
		if (selectRow == null) {
			Fn("");
		}  else {
			if (flg) {
				Fn(selectRow);
			} else {
				Fn("");
			}
		}
	});

	IngDretGridDs.load({
		callback : function(r, options, success) {
			if (success == false) {

			} else {
				IngDretGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
				row = IngDretGrid.getView().getRow(0);
				var element = Ext.get(row);
				if (typeof(element) != "undefined" && element != null) {
					element.focus();
				}
			}
		}
	});
}
