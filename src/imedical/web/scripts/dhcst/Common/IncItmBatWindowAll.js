// /名称: 选药品及相应全部药品批次窗口
// /描述: 选药品及相应全部药品批次
// /编写者：wyx 
// /编写日期: 2014.03.19

/**
 Input:药品别名录入值
 StkGrpRowId：类组id
 StkGrpType：类组类型，G：药品
 NotUseFlag：不可用标志
 QtyFlag：是否包含0库存项目
 HospID：医院id
 Fn：回调函数
 */
IncItmBatWindowAll =function(Input, StkGrpRowId,LocId, StkGrpType, NotUseFlag,
		 HospID,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;

	// 替换特殊字符
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0,Input.indexOf("*"));
	}

	/*药品窗口------------------------------*/
	var PhaOrderUrl = 'dhcst.drugutil.csp?actiontype=GetPhaOrderItemForDialogAll&Input='
			+ Input + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType='
			+ StkGrpType + '&NotUseFlag=' + NotUseFlag
			+  '&HospID=' + HospID + '&start=' + 0
			+ '&limit=' + 15;

	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : PhaOrderUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
			"ManfName", "PuomDesc", "BuomDesc", "BillUomDesc",
			"PhcFormDesc", "GoodName", "GeneName", {name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "Remark"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "InciDr",
				fields : fields
			});
	// 数据集
	var PhaOrderStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});


	var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store : PhaOrderStore,
				pageSize : 15,
				displayInfo : true,
				displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
				emptyMsg : "No results to display",
				prevText : "上一页",
				nextText : "下一页",
				refreshText : "刷新",
				lastText : "最后页",
				firstText : "第一页",
				beforePageText : "当前页",
				afterPageText : "共{0}页",
				emptyMsg : "没有数据"
			});

	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel({
		singleSelect:true,
		listeners:{
			'rowselect':function(selmod,rowindex,record){
				
					var record=PhaOrderGrid.getStore().getAt(rowindex);
					var incid=record.get("InciDr");
					var pagesize=ItmBatPagingToolbar.pageSize;
					ItmLcBtStore.setBaseParam("IncId",incid);
					ItmLcBtStore.setBaseParam("LocId",LocId);
					ItmLcBtStore.load({params:{start:0,limit:pagesize}});
				
			}
		}
	});
	
	
	// the check column is created using a custom plugin
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
   		header: '不可用',
   		dataIndex: 'NotUseFlag',
   		width: 45
	});
	var PhaOrderCm = new Ext.grid.ColumnModel([nm,  {
				header : "代码",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '名称',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'ManfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '入库单位',
				dataIndex : 'PuomDesc',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "基本单位",
				dataIndex : 'BuomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "剂型",
				dataIndex : 'PhcFormDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "商品名",
				dataIndex : 'GoodName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "处方通用名",
				dataIndex : 'GeneName',
				width : 80,
				align : 'left',
				sortable : true
			}, ColumnNotUseFlag]);
	PhaOrderCm.defaultSortable = true;
	var PhaOrderGrid = new Ext.grid.GridPanel({
				cm : PhaOrderCm,
				store : PhaOrderStore,
				trackMouseOver : true,
				stripeRows : true,
				sm : sm,
				loadMask : true,
				bbar : StatuTabPagingToolbar,
				deferRowRender : false
			});
// 回车事件
	PhaOrderGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			ItmLcBtGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
			row = ItmLcBtGrid.getView().getRow(0);
			if (row){
				var element = Ext.get(row);
				if (typeof(element) != "undefined" && element != null) {
					element.focus();
					ItmLcBtGrid.getView().focusRow(0);
				}	
			}
		}
	}); 
	// 双击事件
	PhaOrderGrid.on('rowclick', function(grid,rowindex,e) {
		if(rowindex>0){
			var record=PhaOrderGrid.getStore().getAt(rowindex);
			var incid=record.get("InciDr");
			var pagesize=StatuTabPagingToolbar.pageSize;
			ItmLcBtStore.setBaseParam("IncId",incid);
			ItmLcBtStore.load({params:{start:0,limit:pagesize},
			callback : function(r, options, success) {
			if (success == false) {
			 	Msg.info('warning','没有任何记录！');
			 	if(window){window.focus();}
			} else {
				/*
				ItmLcBtGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
				row = ItmLcBtGrid.getView().getRow(0);
				if (row){
					var element = Ext.get(row);
					if (typeof(element) != "undefined" && element != null) {
						element.focus();
					}	
				}*/
			}
		}});
		}
	});
	PhaOrderStore.load({
		callback : function(r, options, success) {
			if (success == false) {
			 	Msg.info('warning','没有任何符合的记录！');
			 	        if(window){window.hide();}
			} else {
				PhaOrderGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
				row = PhaOrderGrid.getView().getRow(0);
				if (row){
					var element = Ext.get(row);
					if (typeof(element) != "undefined" && element != null) {
						element.focus();
						PhaOrderGrid.getView().focusRow(0);
					}	
				}
			}
		}
	});
	
	/*批次窗口------------------------------*/	
	// 指定列参数
	// 数据集
	var ItmLcBtStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url:DictUrl	+ 'drugutil.csp?actiontype=GetDrugBatInfoAll',
		root : 'rows',
		totalProperty : "results",	
		idProperty:"Incib",
		fields :  ["Incib","InciDr","InciCode","InciDesc","BatExp","PurUomId","PurUomDesc", "Rp", "Sp",
			"BUomId","BUomDesc"],
		baseParams:{
			IncId:'',
                     LocId:'' 
		}
	});

	var ItmBatPagingToolbar = new Ext.PagingToolbar({
				store : ItmLcBtStore,
				pageSize : 15,
				displayInfo : true,
				displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录',
				emptyMsg : "No results to display",
				prevText : "上一页",
				nextText : "下一页",
				refreshText : "刷新",
				lastText : "最后页",
				firstText : "第一页",
				beforePageText : "当前页",
				afterPageText : "共{0}页",
				emptyMsg : "没有数据"
			});

	var nm2 = new Ext.grid.RowNumberer();
	//var sm2 = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
    var sm2 = new Ext.grid.CheckboxSelectionModel({singleSelect:true});   
	var ItmLcBtCm = new Ext.grid.ColumnModel([nm2,  {
				header : "批次RowID",
				dataIndex : 'Incib',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : "InciDr",
				dataIndex : 'InciDr',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : "代码",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '名称',
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "批次/效期",
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "单位ID",
				dataIndex : 'PurUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "单位",
				dataIndex : 'PurUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "批次进价",
				dataIndex : 'Rp',
				width : 80,
				align : 'right',
				
				sortable : true
			}, {
				header : "批次售价",
				dataIndex : 'Sp',
				width : 80,
				align : 'right',
				
				sortable : true
			}, {
				header : "基本单位RowId",
				dataIndex : 'BUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "基本单位",
				dataIndex : 'BUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}]);
	ItmLcBtCm.defaultSortable = true;
	var ItmLcBtGrid = new Ext.grid.GridPanel({
		cm : ItmLcBtCm,
		store : ItmLcBtStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm2,	//new Ext.grid.CheckboxSelectionModel({singleSelect:true}),
		loadMask : true,
		bbar : ItmBatPagingToolbar,
		deferRowRender : false
	});
	// 回车事件
	ItmLcBtGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
			returnData();
		}
	});
	// 双击事件
	ItmLcBtGrid.on('rowdblclick', function() {
				returnData();
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
		var selectRows = ItmLcBtGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "请选择一条批次信息！");
		}else if(selectRows.length>1){
			Msg.info("warning", "只能选择一条批次信息！");
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

if(!window){
	var window = new Ext.Window({
			title : '科室库存项批次信息',
			width : document.body.clientWidth*0.7,
			height : document.body.clientHeight*0.9,
			layout : 'border',
			plain : true,
			tbar : [returnBT, '-', closeBT],
			modal : true,
			buttonAlign : 'center',
			autoScroll : true,
			items : [{
				region:'north',
				height:document.body.clientHeight*0.9*0.4,
				split:true,
				layout:'fit',
				items:PhaOrderGrid
			},{
				region:'center',
				layout:'fit',
				items:ItmLcBtGrid
			}]
	});
}

	window.show();
	
	window.on('close', function(panel) {
		var selectRows = ItmLcBtGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Fn("");
		}  else {
			if (flg) {
				var batRecord=selectRows[0];
				var itmRecord=PhaOrderGrid.getSelectionModel().getSelected();
				Ext.applyIf(batRecord.data,itmRecord.data);
				Fn(batRecord);
			} else {
				Fn("");
			}
		}
	});
}