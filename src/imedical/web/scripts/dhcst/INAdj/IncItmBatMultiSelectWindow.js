///名称: 选药品及相应批次窗口
///描述: 选药品及相应批次
///编写者：yunhaibao
///编写日期: 20150515
///库存调整可多选批次信息窗口
/**
 Input:药品别名录入值
 StkGrpRowId：类组id
 StkGrpType：类组类型，G：药品
 Locdr:科室id
 NotUseFlag：不可用标志
 QtyFlag：是否包含0库存项目
 HospID：医院id
 ReqLoc:请求科室id(请求科室id为空时，请求科室库存显示为空)
 Fn：回调函数
 *////yunhaibao20150501添加限制药品标志,区分毒麻信息      //,RestrictedFlag,gHospNoUse
IncItmBatMutiSelectWindow =function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag,
		QtyFlag, HospID, ReqLoc,Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;

	// 替换特殊字符
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0,Input.indexOf("*"));
	}

	/*药品窗口------------------------------*/
	var PhaOrderUrl = 'dhcst.drugutil.csp?actiontype=GetPhaOrderItemForDialog&Input='
			+ encodeURI(Input) + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType='
			+ StkGrpType + '&Locdr=' + Locdr + '&NotUseFlag=' + NotUseFlag
			+ '&QtyFlag=' + QtyFlag + '&HospID=' + HospID + '&start=' + 0
			+ '&limit=' + 15+'&ReqLocDr='+ReqLoc;        

	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : PhaOrderUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
			"ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDesc", "bRp",
			"bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty",
			"PhcFormDesc", "GoodName", "GeneName", {name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark", "PuomQtyO"];
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
				displayMsg : $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
				emptyMsg : "No results to display",
				prevText : $g("上一页"),
				nextText : $g("下一页"),
				refreshText : $g("刷新"),
				lastText : $g("最后页"),
				firstText : $g("第一页"),
				beforePageText : $g("当前页"),
				afterPageText :$g( "共{0}页"),
				emptyMsg : $g("没有数据")
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
					ItmLcBtStore.setBaseParam("ProLocId",Locdr);
					ItmLcBtStore.setBaseParam("ReqLocId",ReqLoc);
					ItmLcBtStore.setBaseParam("QtyFlag",QtyFlag);
					ItmLcBtStore.load({params:{start:0,limit:pagesize}});
				
			}
		}
	});
	
	
	// the check column is created using a custom plugin
	var ColumnNotUseFlag = new Ext.grid.CheckColumn({
   		header: $g('不可用'),
   		dataIndex: 'NotUseFlag',
   		width: 45
	});
	var PhaOrderCm = new Ext.grid.ColumnModel([nm, sm, {
				header : $g("代码"),
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g('名称'),
				dataIndex : 'InciDesc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : $g("规格"),
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("生产企业"),
				dataIndex : 'ManfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : $g('入库单位'),
				dataIndex : 'PuomDesc',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : $g("售价(入库单位)"),
				dataIndex : 'pSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("数量(入库单位)"),
				dataIndex : 'PuomQty',
				width : 120,
				align : 'right',
				sortable : true,
			}, {
				header : $g("基本单位"),
				dataIndex : 'BuomDesc',
				width : 80,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : $g("售价(基本单位)"),
				dataIndex : 'bSp',
				width : 100,
				align : 'right',
			
				sortable : true
			}, {
				header : $g("数量(基本单位)"),
				dataIndex : 'BuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("计价单位"),
				dataIndex : 'BillUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("售价(计价单位)"),
				dataIndex : 'BillSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("数量(计价单位)"),
				dataIndex : 'BillUomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("剂型"),
				dataIndex : 'PhcFormDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : $g("商品名"),
				dataIndex : 'GoodName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("处方通用名"),
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
			//ItmLcBtGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
			row = ItmLcBtGrid.getView().getRow(0);
			if (row){
				var element = Ext.get(row);
				if (typeof(element) != "undefined" && element != null) {
					element.focus();
					var colIndex=GetColIndex(ItmLcBtGrid,"ReqQty");
					ItmLcBtGrid.startEditing(0, colIndex);
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
			ItmLcBtStore.setBaseParam("ProLocId",Locdr);
			ItmLcBtStore.setBaseParam("ReqLocId",ReqLoc);
			ItmLcBtStore.load({params:{start:0,limit:pagesize},
			callback : function(r, options, success) {
			if (success == false) {
			 	Msg.info('warning',$g('没有任何记录！'));
			 	if(window){window.focus();}
			} else {
				//ItmLcBtGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
				row = ItmLcBtGrid.getView().getRow(0);
				if (row){
					var element = Ext.get(row);
					if (typeof(element) != "undefined" && element != null) {
						element.focus();
						var colIndex=GetColIndex(ItmLcBtGrid,"ReqQty");
						ItmLcBtGrid.startEditing(0, colIndex);
					}	
				}
			}
		}});
		}
	});
	PhaOrderStore.load({
		callback : function(r, options, success) {
			if (success == false) {
			 	Msg.info('warning',$g('没有任何符合的记录！'));
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
		url:DictUrl	+ 'drugutil.csp?actiontype=GetDrugBatInfo',
		root : 'rows',
		totalProperty : "results",	
		idProperty:"Inclb",
		fields :  ["Inclb","BatExp", "Manf", "InclbQty", "PurUomDesc", "Sp", "ReqQty",
			"BUomDesc", "Rp", "StkBin", "SupplyStockQty","RequrstStockQty", "IngrDate", 
			"PurUomId", "BUomId", "ConFac", "DirtyQty", "AvaQty","BatSp","InclbQtyO","SupplyStockQtyO"],
		baseParams:{
			IncId:'',
			ProLocId:'',
			ReqLocId:'',
			QtyFlag:''
		}
	});

	var ItmBatPagingToolbar = new Ext.PagingToolbar({
				store : ItmLcBtStore,
				pageSize : 15,
				displayInfo : true,
				displayMsg : $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
				emptyMsg : "No results to display",
				prevText : $g("上一页"),
				nextText : $g("下一页"),
				refreshText : $g("刷新"),
				lastText :$g( "最后页"),
				firstText : $g("第一页"),
				beforePageText : $g("当前页"),
				afterPageText : $g("共{0}页"),
				emptyMsg :$g( "没有数据")
			});

	var nm2 = new Ext.grid.RowNumberer();
	//var sm2 = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
    var sm2 =  new Ext.grid.CellSelectionModel({});
	var ItmLcBtCm = new Ext.grid.ColumnModel([nm2, {
				header : $g("批次RowID"),
				dataIndex : 'Inclb',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("批次/效期"),
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			} ,{
				header : $g("批次库存"),
				dataIndex : 'InclbQty',
				width : 90,
				align : 'right',
				sortable : true,
				hidden : true
				
			}, {
				header : $g("生产企业"),
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			},{
				header : $g("售价"),
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("批次可用库存"),
				dataIndex : 'AvaQty',
				width : 120,
				align : 'right',
				sortable : true
			}, {
				header : $g("调整数量"),
				dataIndex : 'ReqQty',
				width : 80,
				align : 'right',
				sortable : true,
				MaxLength:30,
				editor: new Ext.form.NumberField({
		            allowBlank:false,
		            selectOnFocus : true,
		            formatType:'FmtSQ',
		            //allowDecimals: false, // 允许小数点
					allowNegative: true, // 允许负数
		            listeners : {
						specialkey : function(field, e) {
							if(e.getKey()==Ext.EventObject.UP){
								///yunhaibao20150515,库存调整弹出界面上下输入数量
								var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
								var colIndex=GetColIndex(ItmLcBtGrid,"ReqQty");
								var row=cell[0]-1;
								if(row>=0){
									ItmLcBtGrid.getSelectionModel().select(row, colIndex);
									ItmLcBtGrid.startEditing(row, colIndex);
								}
							}
							if(e.getKey()==Ext.EventObject.DOWN){
								var rowCount=ItmLcBtGrid.getStore().getCount();
								var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
								var colIndex=GetColIndex(ItmLcBtGrid,"ReqQty");
								var row=cell[0]+1;
								if(row<rowCount){
									ItmLcBtGrid.getSelectionModel().select(row, colIndex);
									ItmLcBtGrid.startEditing(row, colIndex);
								}
							}
							if(e.getKey()==Ext.EventObject.ENTER){
								var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
								var colIndex=GetColIndex(ItmLcBtGrid,"ReqQty");
								ItmLcBtGrid.stopEditing(cell[0], colIndex);
								returnData();
							}
							
						}
					}

				})
			} ,{
				header : $g("单位"),
				dataIndex : 'PurUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : $g("基本单位RowId"),
				dataIndex : 'BUomId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : $g("基本单位"),
				dataIndex : 'BUomDesc',
				width : 80,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : $g("进价"),
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : $g("货位码"),
				dataIndex : 'StkBin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("入库日期"),
				dataIndex : 'IngrDate',
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : $g("转换率"),
				dataIndex : 'ConFac',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g("批次占用库存"),
				dataIndex : 'DirtyQty',
				width : 90,
				align : 'right',
				sortable : true
			}]);
	ItmLcBtCm.defaultSortable = true;
	var ItmLcBtGrid = new Ext.grid.EditorGridPanel({
		cm : ItmLcBtCm,
		store : ItmLcBtStore,
		trackMouseOver : true,
		stripeRows : true,
		//sm : sm2,	//new Ext.grid.CheckboxSelectionModel({singleSelect:true}),
		loadMask : true,
		bbar : ItmBatPagingToolbar,
		deferRowRender : false,
		clicksToEdit:1
	});
	// 回车事件
	/*ItmLcBtGrid.on('keydown', function(e) {
		if (e.getKey() == Ext.EventObject.ENTER) {
				returnData();
		}
	});*/
	// 双击事件
	ItmLcBtGrid.on('rowdblclick', function() {
				returnChoiceData();
	});		
	// 返回按钮
	var returnBT = new Ext.Toolbar.Button({
		text : $g('返回'),
		tooltip : $g('点击返回'),
		iconCls : 'page_goto',
		handler : function() {
			returnData();
		}
	});
			
	/**
	 * 返回数据
	 */
	function returnData() {
		var rowsModified=ItmLcBtGrid.getStore().getModifiedRecords();
		if (rowsModified.length==0){
			Msg.info("warning", $g("请输入调整数量!"));
		}else{
			flg = true;
			window.close();
		}
	}
	
	    // 返回数据
    function returnChoiceData() {
	    var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
        if (cell == null) {
            Msg.info("warning", $g("没有选中行!"));
            return;
        }
        else {
            flg = true;
            window.close();
        }
    }
	


	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text : $g('关闭'),
		tooltip : $g('点击关闭'),
		iconCls : 'page_delete',
		handler : function() {
			flg = false;
			window.close();
		}
	});

if(!window){
	var window = new Ext.Window({
			title : $g('科室库存项批次信息'),
			width : 1000,
			height : 600,
			layout : 'border',
			plain : true,
			tbar : [returnBT, '-', closeBT],
			modal : true,
			buttonAlign : 'center',
			autoScroll : true,
			items : [{
				region:'north',
				height:300,
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
		var itmRecord=PhaOrderGrid.getSelectionModel().getSelected();
		if(flg){
			var rowsModified=ItmLcBtGrid.getStore().getModifiedRecords();
			if (rowsModified.length==0){
				var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
		        if (cell == null) {
		            Fn("","")
		        }
		        // 选中行
		        var row = cell[0];
		        var rowsModified = ItmLcBtGrid.getStore().getAt(row);
				Fn([rowsModified],itmRecord)
			}	
			else {
				Fn(rowsModified,itmRecord)
			}
		}
		else {
			Fn("","")
		}
		
		
		/*
		///遍历编辑框
		var rowsModified=ItmLcBtGrid.getStore().getModifiedRecords();
		if (rowsModified.length==0){
			Fn("","")
		}else{
			if (flg){
				///返回记录
				var itmRecord=PhaOrderGrid.getSelectionModel().getSelected();
				Fn(rowsModified,itmRecord)	  //modify需要循环存,影响速度
				
			}else{
				
			}
		
		}
		Fn("","")
		*/

	});
}