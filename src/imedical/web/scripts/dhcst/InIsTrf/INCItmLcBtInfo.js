/**
 * 名称: 科室库存项批次
 * 
 * 描述: 科室库存项批次 编写者：zhangyong 编写日期: 2012.1.11
 * 最后更新:yunhaibao,20151202,修改界面以及数据,供依据请求出库右键修改批次用
 */
INCItmLcBtInfo = function(InciDr, PhaLoc, PhaLocRQ, Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;

	var ItmLcBtUrl = DictUrl
			+ 'dhcinistrfaction.csp?actiontype=GetDrugInvInfo&IncId='
			+ InciDr + '&ProLocId=' + PhaLoc + '&ReqLocId=' + PhaLocRQ
			+ '&start=' + 0 + '&limit=' + 15;;

	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : ItmLcBtUrl,
				method : "POST"
			});
	
	// 指定列参数
	var fields = ["Inclb", "IncRowId", "IncCode", "IncName",
			"BatExp", "Manf", "InclbQty", "InitQty",
			"PurUomDesc", "Sp", "Transfer", "ReqQty",
			"BUomDesc", "Rp", "StkBin", "SupplyStockQty",
			"RequrstStockQty", "IngrDate", "Sepc", "GeneDesc", "FormDesc",
			"PurUomId", "BUomId", "ConFac", "DirtyQty", "AvaQty",
			"BatSp","InclbWarnFlag"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "Inclb",
				fields : fields
			});
	// 数据集
	var ItmLcBtStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
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

	var nm = new Ext.grid.RowNumberer();
	//var sm = new Ext.grid.CheckboxSelectionModel();
    var sm =  new Ext.grid.CellSelectionModel({});
	var ItmLcBtCm = new Ext.grid.ColumnModel([nm, {
				header : "批次RowID",
				dataIndex : 'Inclb',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "药品编号RowId",
				dataIndex : 'IncRowId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '药品代码',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true,
				hidden:true
			}, {
				header : '药品名称',
				dataIndex : 'IncName',
				width : 230,
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
				header : "批次库存",
				dataIndex : 'InclbQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "批次可用库存",
				dataIndex : 'AvaQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "转移数量",
				dataIndex : 'InitQty',
				width : 80,
				align : 'right',
				sortable : true,
				renderer:BiggerRender,
				editor: new Ext.form.NumberField({
		            allowBlank:false,
		            selectOnFocus : true,
		            listeners : {
						specialkey : function(field, e) {
							if(e.getKey()==Ext.EventObject.UP){
								if(event.preventDefault){event.preventDefault();}
								else {event.keyCode=38;} 
								var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
								var colIndex=GetColIndex(ItmLcBtGrid,"InitQty");
								ItmLcBtGrid.stopEditing(cell[0], colIndex);
								var row=cell[0]-1;
								if(row>=0){
									ItmLcBtGrid.getSelectionModel().select(row, colIndex);
									ItmLcBtGrid.startEditing(row, colIndex);
								}
							}
							if(e.getKey()==Ext.EventObject.DOWN){
								if(event.preventDefault){event.preventDefault();}
								else {event.keyCode=40;}
								var rowCount=ItmLcBtGrid.getStore().getCount();
								var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
								var colIndex=GetColIndex(ItmLcBtGrid,"InitQty");
								ItmLcBtGrid.stopEditing(cell[0], colIndex);
								var row=cell[0]+1;
								if(row<rowCount){
									ItmLcBtGrid.getSelectionModel().select(row, colIndex);
									ItmLcBtGrid.startEditing(row, colIndex);
								}
							}
							if(e.getKey()==Ext.EventObject.ENTER){
								var cell = ItmLcBtGrid.getSelectionModel().getSelectedCell();
								var colIndex=GetColIndex(ItmLcBtGrid,"InitQty");
								ItmLcBtGrid.stopEditing(cell[0], colIndex);
								returnData();
							}
							
						}
					}

				})
			}, {
				header : "生产厂商",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "单位RowId",
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
				sortable : true,
				hidden : true
			}, {
				header : "售价",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',				
				sortable : true
			}, {
				header : "批次售价",
				dataIndex : 'BatSp',
				width : 60,
				align : 'right',				
				sortable : true
			}, {
				header : "类型",
				dataIndex : 'Transfer',
				width : 80,
				align : 'center',
				sortable : true,
				hidden : true
			}, {
				header : "请求数量",
				dataIndex : 'ReqQty',
				width : 80,
				align : 'right',
				sortable : true,
				hidden : true
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
				sortable : true,
				hidden : true
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',				
				sortable : true
			}, {
				header : "货位码",
				dataIndex : 'StkBin',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "供应方库存",
				dataIndex : 'SupplyStockQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "请求方库存",
				dataIndex : 'RequrstStockQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "入库日期",
				dataIndex : 'IngrDate',
				width : 80,
				align : 'center',
				sortable : true,
				hidden : true
			}, {
				header : "规格",
				dataIndex : 'Sepc',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "处方通用名",
				dataIndex : 'GeneDesc',
				width : 120,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "剂型",
				dataIndex : 'FormDesc',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "转换率",
				dataIndex : 'ConFac',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "批次占用库存",
				dataIndex : 'DirtyQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "警示级别",
				dataIndex : 'InclbWarnFlag',
				width : 90,
				align : 'right',
				sortable : true,
				hidden:true
			}]);
	ItmLcBtCm.defaultSortable = true;
	function BiggerRender(val){
			return '<span style="font-size:13px;font-weight:bold">'+val+'</span>';

	}
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
		var rowsModified=ItmLcBtGrid.getStore().getModifiedRecords();
		if (rowsModified.length==0){
			Msg.info("warning", "请输入转移数量!");
		}else{
			var rowslen=0
			var modifylen=rowsModified.length;
			var inclbwarnflag=""
			for (rowslen=0;rowslen<modifylen;rowslen++)
			{
				 inclbwarnflag=rowsModified[rowslen].data["InclbWarnFlag"]
				 var expbatinfo=rowsModified[rowslen].data["BatExp"]
				 if (inclbwarnflag=="1"){
					 if (confirm(expbatinfo+"为过期药品,是否继续?")){continue;}
					 else{return}
				 }
				 else if (inclbwarnflag=="2"){
					 if (confirm(expbatinfo+"为批次不可用,是否继续?")){continue}
					 else{return}
				 }
			}
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

	var ItmLcBtGrid = new Ext.grid.EditorGridPanel({
				cm : ItmLcBtCm,
				store : ItmLcBtStore,
				trackMouseOver : true,
				region:'center',
				stripeRows : true,
				loadMask : true,
				tbar : [returnBT, '-', closeBT],
				bbar : StatuTabPagingToolbar,
				deferRowRender : false,
				clicksToEdit:1,
				viewConfig:{
			    	getRowClass : function(record,rowIndex,rowParams,store){ 
						var InciWarnFlag=record.get("InclbWarnFlag");
						switch(InciWarnFlag){
							case "1":
								return 'classOrange';
								break;
							case "2":
								return 'classSalmon';
								break;
						}
					}
		        }
			});
	ItmLcBtGrid.on('afteredit',function(e){
		if(e.field=="InitQty"){
			if (e.value==0){
				e.record.dirty=false
				e.record.commit(); 
			}
		}
	})
	// 双击事件
	ItmLcBtGrid.on('rowdblclick', function() {
					//验证是否包含过期或停用
				returnData();
			});
	// 回车事件
	ItmLcBtGrid.on('keydown', function(e) {
				if (e.getKey() == Ext.EventObject.ENTER) {

					returnData();
				}
			});

	var IncInfo=new Ext.form.Label({
		id:'IncInfo',
		align:'center',
		cls: 'classImportant'
    })

	var HisItmLcBtTab = new Ext.form.FormPanel({
			labelwidth : 30,
			region : 'north',
			height : 50,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			layout : 'fit', 
		    items:[IncInfo] 
		});
	var window = new Ext.Window({
				title : '药品批次库存信息',
				width : document.body.clientWidth*0.65,
				height : document.body.clientHeight*0.75,
				layout : 'border',
				plain : true,
				modal : true,
				buttonAlign : 'center',
				autoScroll : true,
				items : [HisItmLcBtTab,ItmLcBtGrid]
			});
	window.show();

	window.on('close', function(panel) {
			var rowsModified=ItmLcBtGrid.getStore().getModifiedRecords();
			if (rowsModified.length==0){
				Fn("")
			}else{
				if (flg){

					Fn(rowsModified)
				}else{
					Fn("")
				}
		
			}

		});
	ItmLcBtGrid.getView().on('refresh',function(Grid){
		 if (ItmLcBtGrid.getStore().getCount()>0)
		 {
			var ItmLcBtRowData = ItmLcBtStore.getAt(0);
			var IncCode = ItmLcBtRowData.get("IncCode"); 
			var IncDesc=ItmLcBtRowData.get("IncName"); 
			var IncSpec=ItmLcBtRowData.get("Sepc"); 
			var IncPuomDesc=ItmLcBtRowData.get("PurUomDesc"); 
			var IncBuomDesc=ItmLcBtRowData.get("BUomDesc"); 
			var IncInfoMain='药品代码:'+IncCode+'　　药品名称:'+IncDesc;
			var IncInfoOther="规格:"+IncSpec+"　　入库单位:"+IncPuomDesc+"　　基本单位:"+IncBuomDesc;
	   	 	var IncInfoStr=IncInfoMain+'　　　'+IncInfoOther;
	   	 	
		 }
		 else
		 {
			var IncInfoStr="该药品没有有效批次信息!"
		 }
		 Ext.getCmp("IncInfo").setText(IncInfoStr,false);
	})
	ItmLcBtStore.load({
				callback : function(r, options, success) {
					if (success == false) {

					} else {
							var colIndex=GetColIndex(ItmLcBtGrid,"InitQty");
							ItmLcBtGrid.startEditing(0, colIndex);
					}
				}
			});
}
