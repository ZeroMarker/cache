// /名称: 选物资及相应批次窗口
// /描述: 选物资及相应批次
// /编写者：zhangdongmei
// /编写日期: 2013.01.22

/**
 Input:物资别名录入值
 StkGrpRowId：类组id
 StkGrpType：类组类型，G：物资
 Locdr:科室id
 NotUseFlag：不可用标志
 QtyFlag：是否包含0库存项目
 HospID：医院id
 ReqLoc:请求科室id(请求科室id为空时，请求科室库存显示为空)
 Fn：回调函数
 IntrType : 业务类型(相应台帐type) 2014-08-31添加
 StkCat : 库存分类id 2016-11-29添加
 QtyFlagBat:是否包含0库存批次
 HV:高值标志(Y:仅高值,N:仅低值,'':所有)
*/
var gIncItmBatWindow = null;
var gRecArr = [];			//获取选中的record数组
var gInput,gStkGrpRowId, gStkGrpType, gLocdr, gNotUseFlag,
	gQtyFlag, gHospID, gReqLoc, gFn, gIntrType, gStkCat,gQtyFlagBat,gHV;
var gSelColor = "#51AD9D";	//选中行染色
IncItmBatWindow = function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag,
		QtyFlag, HospID, ReqLoc, Fn, IntrType, StkCat,QtyFlagBat,HV) {
	Ext.QuickTips.init();
	gInput=Input, gStkGrpRowId=StkGrpRowId, gStkGrpType=StkGrpType, gLocdr=Locdr, gNotUseFlag=NotUseFlag;
	gQtyFlag=QtyFlag, gHospID=HospID, gReqLoc=ReqLoc, gFn=Fn, gIntrType=IntrType, gStkCat=StkCat,gHV=HV;
	if(QtyFlagBat==""||QtyFlagBat==null||QtyFlagBat==undefined){gQtyFlagBat=QtyFlag;}else{gQtyFlagBat=QtyFlagBat;}
	if(gHV==""||gHV==null||gHV==undefined){gHV="";}

	var gInciRecord = null, gInciRowIndex = '';
	
	if(gIncItmBatWindow){
		gIncItmBatWindow.show();
		return;
	}
	var AllowQtyNegative = gIntrType=="A"?true:false;	//是否允许业务数量录入负值
	gStkCat = typeof(gStkCat)=='undefined'?'':gStkCat;
	
	var PhaOrderStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url:DictUrl	+ 'drugutil.csp?actiontype=GetPhaOrderItemForDialog',
		root : 'rows',
		totalProperty : "results",	
		idProperty:"InciDr",
		fields : ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
			"ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDesc", "bRp",
			"bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty",
			{name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark","GrpId","GrpDesc"],
		listeners : {
			load : function(store,records,options){
				ItmLcBtStore.removeAll();
				if(records.length > 0){
					sm.selectFirstRow();
					PhaOrderGrid.getView().focusRow(0);
					Ext.each(records,function(item,index,allItems){
						ChangeGridBgColor(PhaOrderGrid,index);
					});
				}
			}
		}
	});
	
	var sm = new Ext.grid.CheckboxSelectionModel({
		singleSelect : true,
		checkOnly : false,
		listeners:{
			'rowselect':function(selmod,rowIndex,record){
				if(ItmLcBtGrid.activeEditor != null){
					ItmLcBtGrid.activeEditor.completeEdit();		//添加completeEdit,触发afteredit,防止数量为0的情况
				}
				gInciRowIndex = rowIndex;	//全局变量记录临时rowIndex
				gInciRecord = record;		//全局变量记录临时record
				var incid=record.get("InciDr");
				var pagesize=ItmBatPagingToolbar.pageSize;
				ItmLcBtStore.setBaseParam("IncId",incid);
				ItmLcBtStore.setBaseParam("ProLocId",gLocdr);
				ItmLcBtStore.setBaseParam("ReqLocId",gReqLoc);
				ItmLcBtStore.setBaseParam("QtyFlag",gQtyFlagBat);
				ItmLcBtStore.setBaseParam("StkType",App_StkTypeCode);
				ItmLcBtStore.removeAll();
				ItmLcBtStore.load({params:{start:0,limit:pagesize}});
			}
		}
	});
	var nm = new Ext.grid.RowNumberer();
	var PhaOrderCm = new Ext.grid.ColumnModel([nm, sm, {
				header : "代码",
				dataIndex : 'InciCode',
				width : 140,
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
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : '入库单位',
				dataIndex : 'PuomDesc',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : "进价(入库单位)",
				dataIndex : 'pRp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "售价(入库单位)",
				dataIndex : 'pSp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "数量(入库单位)",
				dataIndex : 'PuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "基本单位",
				dataIndex : 'BuomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "进价(基本单位)",
				dataIndex : 'bRp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "售价(基本单位)",
				dataIndex : 'bSp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "数量(基本单位)",
				dataIndex : 'BuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "计价单位",
				dataIndex : 'BillUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "进价(计价单位)",
				dataIndex : 'BillRp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "售价(计价单位)",
				dataIndex : 'BillSp',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "数量(计价单位)",
				dataIndex : 'BillUomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header: '不可用',
				dataIndex: 'NotUseFlag',
				xtype: 'checkcolumn',
				width: 45
			}]);
	PhaOrderCm.defaultSortable = true;
	
	var PhaOrderToolbar = new Ext.PagingToolbar({
		store : PhaOrderStore,
		pageSize : 10,
		displayInfo : true
	});
	
	var PhaOrderGrid = new Ext.grid.GridPanel({
		id : 'PhaOrderGrid',
		cm : PhaOrderCm,
		store : PhaOrderStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm,
		loadMask : true,
		bbar : PhaOrderToolbar,
		deferRowRender : false,
		listeners :{
			keydown : function(e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					if(ItmLcBtGrid.getStore().getCount()>0){
						ItmLcBtGrid.startEditing(0, gCol);
					}
				}
			}
		}
	});
	
	var ItmLcBtStore = new Ext.data.JsonStore({
		autoDestroy: true,
		url:DictUrl	+ 'drugutil.csp?actiontype=GetDrugBatInfo',
		root : 'rows',
		totalProperty : "results",	
		idProperty:"Inclb",
		fields :  ["Inclb","BatExp", "Manf", "InclbQty", "PurUomDesc", "Sp", "ReqQty",
			"BUomDesc", "Rp", "StkBin", "SupplyStockQty","RequrstStockQty", "IngrDate", 
			"PurUomId", "BUomId", "ConFac", "DirtyQty", "AvaQty","BatSp","HVFlag","SupplyAvaStockQty",
			{name:"OperQty",defaultValue:''},"RecallFlag", "Vendor", "VendorName","SterilizedBat","SpecDesc"],
		baseParams:{
			IncId:'',
			ProLocId:'',
			ReqLocId:'',
			QtyFlag:'',
			StkType:''
		},
		listeners :{
			load : function(store,records,options){
				Ext.each(records,function(item,index,allItems){
					Ext.each(gRecArr,function(rec,RecIndex,RecAllItems){
						if(rec.get('Inclb')==item.get('Inclb')){
							item.set('OperQty',rec.get('OperQty'));
						}
					});
				});
			}
		}
	});

	var ItmLcBtCm = new Ext.grid.ColumnModel([
			new Ext.grid.RowNumberer(), {
				header : "批次RowID",
				dataIndex : 'Inclb',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "批次~效期",
				dataIndex : 'BatExp',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "具体规格",
				dataIndex : 'SpecDesc',
				width : 100,
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
				header : "业务数量",
				dataIndex : 'OperQty',
				width : 90,
				align : 'right',
				hideable : false,
				editable : true,
				editor : new Ext.grid.GridEditor(
					new Ext.ux.NumberField({
						formatType : 'FmtQTY',
						selectOnFocus : true,
						allowBlank : true,
						allowNegative : AllowQtyNegative,
						listeners : {
							specialkey : function(field,e){
								if (e.getKey() == Ext.EventObject.ALT) {
									ItmLcBtGrid.activeEditor.completeEdit();
									sm.selectRow(gInciRowIndex + 1);
									PhaOrderGrid.getView().focusRow(gInciRowIndex + 1);
								}else if(e.getKey() == Ext.EventObject.ENTER){
									returnData();
								}
							}
						}
					}))
			}, {
				header : "供应商",
				dataIndex : 'VendorName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "单位",
				dataIndex : 'PurUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "批次售价",
				dataIndex : 'BatSp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "请求数量",
				dataIndex : 'ReqQty',
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
				sortable : true
			}, {
				header : "供应方库存",
				dataIndex : 'SupplyStockQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "供应方可用库存",
				dataIndex : 'SupplyAvaStockQty',
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
				sortable : true
			}, {
				header : "转换率",
				dataIndex : 'ConFac',
				width : 100,
				align : 'left',
				hidden : true,
				sortable : true
			}, {
				header : "批次占用库存",
				dataIndex : 'DirtyQty',
				width : 90,
				align : 'right',
				sortable : true
			}, {
				header : "高值标志",
				dataIndex : 'HVFlag',
				width : 60,
				align : 'center',
				sortable : true,
				hidden : true
			},{
				header : "锁定标志",
				dataIndex : 'RecallFlag',
				width : 60,
				align : 'center',
				sortable : true
			}, {
				header : "灭菌批号",
				dataIndex : 'SterilizedBat',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	ItmLcBtCm.defaultSortable = true;
	
	var ItmBatPagingToolbar = new Ext.PagingToolbar({
		store : ItmLcBtStore,
		pageSize : 15,
		displayInfo : true
	});
	
	var ItmLcBtGrid = new Ext.grid.EditorGridPanel({
		id : 'ItmLcBtGrid',
		title : '批次 -- Alt键返回库存项列表',
		cm : ItmLcBtCm,
		store : ItmLcBtStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : new Ext.ux.CellSelectionModel(),
		loadMask : true,
		bbar : ItmBatPagingToolbar,
		deferRowRender : false,
		clicksToEdit : 1,
		listeners : {
			keydown : function(e) {
				if (e.getKey() == Ext.EventObject.ALT) {
					sm.selectRow(gInciRowIndex + 1);
					PhaOrderGrid.getView().focusRow(gInciRowIndex + 1);
				}
			},
			afterrender : function(grid){
				gCol = GetColIndex(grid,'OperQty');
			},
			afteredit : function(e){
				if(e.field=='OperQty'){
					if(gIntrType=='A'){
						if(accAdd(e.value,e.record.get('AvaQty'))<0){
							//库存调整可录入负值, 添加控制
							Msg.info("warning","调整数量为负数时不能超过批次可用库存!");
							e.record.set('OperQty',e.originalValue);
							return;
						}
					}else if(gIntrType!="G" && e.value>e.record.get('AvaQty')){	//虚拟入库不控制数量
						Msg.info("warning","数量不可大于批次可用数量");
						e.record.set('OperQty',e.originalValue);
						return;
					}
					var inclb = e.record.get('Inclb');
					var InclbExistFlag = false;
					Ext.each(gRecArr,function(item,index,allItems){
						if(item.get('Inclb')==inclb){
							InclbExistFlag = true;
							if(e.value!="" && parseFloat(e.value)!=0){
								item.set('OperQty',e.value);
							}else{
								gRecArr.remove(item);
							}
							return false;
						}
					});
					if(!InclbExistFlag){
						Ext.applyIf(e.record.data,gInciRecord.data);
						gRecArr.push(e.record);
					}
					ChangeGridBgColor(PhaOrderGrid,gInciRowIndex);
				}
			},
			beforeedit:function(e){
				if(e.record.get('RecallFlag')=="Y")
				{
					Msg.info("warning","批次锁定 不可以使用!");
					return false;
				}
			},
			rowdblclick : function(){
				returnData();
			}
		}
	});
	
	function ChangeGridBgColor(grid, rowIndex){
		var InciExist = false;
		var InciId = grid.getStore().getAt(rowIndex).get('InciDr');
		Ext.each(gRecArr,function(rec,RecIndex,RecAllItems){
			if(rec.get('InciDr') == InciId){
				SetGridBgColor(grid,rowIndex,gSelColor);
				InciExist = true;
				return false;		//停止迭代
			}
		});
		if(!InciExist){
			SetGridBgColor(grid,rowIndex,'white');
		}
	}
	
	// 返回按钮
	var returnBT = {
		xtype : 'uxbutton',
		key : 'S',
		text : '返回批次数据',
		tooltip : '点击返回',
		iconCls : 'page_goto',
		height : 30,
		width : 70,
		handler : function() {
			returnData();
		}
	};
			
	/**
	 * 返回数据
	 */
	function returnData() {
		if(ItmLcBtGrid.activeEditor != null){
			ItmLcBtGrid.activeEditor.completeEdit();
		}
		var RecArrLen = gRecArr.length;
		if (RecArrLen == 0) {
			Msg.info("warning", "请选择批次，输入业务数量！");
		}else{
			gFn(gRecArr);
			window.hide();
		}
	}
	
	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '点击关闭',
		iconCls : 'page_delete',
		height : 30,
		width : 70,
		handler : function() {
			window.hide();		//keyMap处理之前,暂不使用hide
		}
	});
	
	var window = new Ext.Window({
		title : '科室库存项批次信息',
		width : 900,
		height : 600,
		layout : 'border',
		plain : true,
		tbar : [returnBT, '-', closeBT],
		modal : true,
		buttonAlign : 'center',
		closeAction : 'hide',	//keyMap处理之前,暂不使用close
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
		}],
		listeners:{
			show:function(win){
				gRecArr = [];
				gIncItmBatWindow = window;
				RefreshGrid();
			},
			hide : function(){
				PhaOrderStore.removeAll();
				ItmLcBtStore.removeAll();
			},
			close:function(){
				gIncItmBatWindow = null;
			}
		}
	});
	
	function RefreshGrid(){
		PhaOrderStore.setBaseParam('Input', gInput);
		PhaOrderStore.setBaseParam('StkGrpRowId', gStkGrpRowId);
		PhaOrderStore.setBaseParam('StkGrpType', gStkGrpType);
		PhaOrderStore.setBaseParam('Locdr', gLocdr);
		PhaOrderStore.setBaseParam('NotUseFlag', gNotUseFlag);
		PhaOrderStore.setBaseParam('QtyFlag', gQtyFlag);
		PhaOrderStore.setBaseParam('HospID', gHospID);
		PhaOrderStore.setBaseParam('StkCat', gStkCat);
		PhaOrderStore.setBaseParam('toLoc', gReqLoc);
		PhaOrderStore.setBaseParam('HV', gHV);
		PhaOrderStore.load({
			params : {start:0,limit:PhaOrderToolbar.pageSize},
			callback : function(r, options, success) {
				if (success == false) {
					Msg.info('warning','没有任何符合的记录！');
					if(window){window.hide();}
				}
			}
		});
	}
	
	window.show();
}

///根据条码获取物资信息和物资批次信息
// /名称: 根据条码获取物资信息和物资批次信息
// /描述: 选物资及相应批次
// /编写者zhangxiao
// /编写日期: 2013.12.05

/**
 Input:条码
 StkGrpRowId类组id
 StkGrpType类组类型G物资
 Locdr:科室id
 NotUseFlag不可用标志
 QtyFlag是否包含0库存项目
 HospID医院id
 ReqLoc:请求科室id(请求科室id为空时请求科室库存显示为空)
 Fn回调函数
 */
IncItmBatByBarcodeWindow =function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag,
		QtyFlag, HospID, ReqLoc,Fn,IntrType) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var flg = false;
	// 替换特殊字符
	while (Input.indexOf("*") >= 0) {
		//Input = Input.substring(0,Input.indexOf("*"));
	}
   var AllowQtyNegative = IntrType=="A"?true:false;	//是否允许业务数量录入负值
	/*物资窗口------------------------------*/
	var PhaOrderUrl = 'dhcstm.drugutil.csp?actiontype=GetPhaOrderItemByBarcode&Input='
			+ Input + '&StkGrpRowId=' + StkGrpRowId + '&StkGrpType='
			+ StkGrpType + '&Locdr=' + Locdr + '&NotUseFlag=' + NotUseFlag
			+ '&QtyFlag=' + QtyFlag + '&HospID=' + HospID + '&start=' + 0
			+ '&limit=' + 15;

	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : PhaOrderUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
			"ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDesc", "bRp",
			"bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty",
			{name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "InciItem",
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
				displayMsg : '当前记录 {0} -- {1} 条 共 {2} 条记录'
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
					ItmLcBtStore.setBaseParam("StkType",App_StkTypeCode);
					ItmLcBtStore.load({params:{start:0,limit:pagesize}});
				
			}
		}
	});
	
	var PhaOrderCm = new Ext.grid.ColumnModel([nm, sm, {
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
				header : "售价(入库单位)",
				dataIndex : 'pSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "数量(入库单位)",
				dataIndex : 'PuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "基本单位",
				dataIndex : 'BuomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "售价(基本单位)",
				dataIndex : 'bSp',
				width : 100,
				align : 'right',
			
				sortable : true
			}, {
				header : "数量(基本单位)",
				dataIndex : 'BuomQty',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "计价单位",
				dataIndex : 'BillUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "售价(计价单位)",
				dataIndex : 'BillSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "数量(计价单位)",
				dataIndex : 'BillUomQty',
				width : 100,
				align : 'right',
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
				header : "通用名",
				dataIndex : 'GeneName',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header: '不可用',
				dataIndex: 'NotUseFlag',
				xtype: 'checkcolumn',
				width: 45
			}]);
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
				}	
			}
		}
	}); 
/*
	// 双击事件
	PhaOrderGrid.on('rowclick', function(grid,rowindex,e) {
		if(rowindex>0){
			var record=PhaOrderGrid.getStore().getAt(rowindex);
			var incid=record.get("InciDr");
			var pagesize=StatuTabPagingToolbar.pageSize;
			ItmLcBtStore.setBaseParam("IncId",incid);
			ItmLcBtStore.setBaseParam("ProLocId",Locdr);
			ItmLcBtStore.setBaseParam("ReqLocId",ReqLoc);
			ItmLcBtStore.load({params:{start:0,limit:pagesize}});
		}
	}); */
	PhaOrderStore.load({
		callback : function(r, options, success) {
			if (success == false) {
			 	Msg.info('warning','没有任何符合的记录');
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
			"PurUomId", "BUomId", "ConFac", "DirtyQty", "AvaQty","BatSp","HVFlag",
			{name:"OperQty",defaultValue:''},"RecallFlag", "Vendor", "VendorName"],
		baseParams:{
			IncId:'',
			ProLocId:'',
			ReqLocId:'',
			QtyFlag:'',
			StkType:''
		}
	});

	var ItmBatPagingToolbar = new Ext.PagingToolbar({
				store : ItmLcBtStore,
				pageSize : 15,
				displayInfo : true,
				displayMsg : '当前记录 {0} -- {1} 条, 共 {2} 条记录'
			});

	var nm2 = new Ext.grid.RowNumberer();
	var sm2 = new Ext.grid.CheckboxSelectionModel({singleSelect:true});

	var ItmLcBtCm = new Ext.grid.ColumnModel([nm2, sm2, {
				header : "批次RowID",
				dataIndex : 'Inclb',
				width : 100,
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
				header : "单位",
				dataIndex : 'PurUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "批次售价",
				dataIndex : 'BatSp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'VendorName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'Manf',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "请求数量",
				dataIndex : 'ReqQty',
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
				sortable : true
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
				sortable : true
			}, {
				header : "转换率",
				dataIndex : 'ConFac',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "批次占用库存",
				dataIndex : 'DirtyQty',
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
				header : "高值标志",
				dataIndex : 'HVFlag',
				width : 60,
				align : 'center',
				sortable : true,
				hidden : true
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
			Msg.info("warning", "请选择一条批次信息");
		}else if(selectRows.length>1){
			Msg.info("warning", "只能选择一条批次信息");
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
			width : 700,
			height : 600,
			layout : 'border',
			plain : true,
			tbar : [returnBT, '-', closeBT],
			modal : true,
			buttonAlign : 'center',
			autoScroll : true,
			items : [{
				region:'north',
				height:350,
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