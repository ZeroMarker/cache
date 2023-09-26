/**
 * 名称: 物资信息窗口
 * 
 * 描述: 物资信息 编写者：zhangyong 编写日期: 2011.11.04
 * 
 * @param {}
 *            Input 输入值
 * @param {}
 *            StkGrpCode 类组编码
 * @param {}
 *            StkGrpType 类组
 * @param {}
 *            Locdr 药房
 * @param {}
 *            NotUseFlag 不启用
 * @param {}
 *            QtyFlag 数量
 * @param {}
 *            HospID 院区
 * @param {}
 *            Fn 调用界面方法句柄，用于反射调用界面的方法(传递选中行的数据Record)
 * @param {}
 *            mulselect 是否支持多选  Y支持   其他不支持
 */

var xxxInput="";
var xxxStkGrpRowId="";
var xxxStkGrpType="";
var xxxLocdr="";
var xxxNotUseFlag="";
var xxxQtyFlag="";
var xxxHospID="";
var xxxPhaOrderWin;
var xxxFn;
var xxxHV="";		//高值标志(Y:仅高值,N:仅低值,'':所有)
GetPhaOrderWindowInclb = function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag,
		QtyFlag, HospID, Fn, toLoc, tree,
		loc1,loc2,ReqModeLimited,NoLocReq,mulselect,
		vendor,HV,RequestNoStock) {
			
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	if (Input=="") {tree=1;} 
	xxxInput=Input;
	xxxStkGrpRowId=StkGrpRowId;
	xxxStkGrpType=StkGrpType;
	xxxLocdr=Locdr;
	xxxNotUseFlag=NotUseFlag;
	xxxQtyFlag=QtyFlag;
	xxxHospID=HospID;
	xxxFn=Fn;
	xxxReqModeLimited=ReqModeLimited;
	xxxNoLocReq=NoLocReq;
	xxxmulselect=mulselect;
	xxxvendor=vendor;
	xxxHV=HV;
	xxxRequestNoStock=RequestNoStock;
	var gPhaOrderWindowFlag = typeof(gPhaOrderWindowFlag)=='undefined'?false:gPhaOrderWindowFlag;
	if (toLoc==undefined) toLoc='';
	if ((tree==undefined)||(tree==null)) tree=0;
	
	if (xxxPhaOrderWin){
		xxxPhaOrderWin.show();
		return;
	}
	
	if(gPhaOrderWindowFlag){
		return;
	}
	
	// 替换特殊字符
	while (Input.indexOf("*") >= 0) {
		Input = Input.substring(0,Input.indexOf("*"));
	}
	 var myView = new Ext.ux.grid.livegrid.GridView({
        nearLimit : 50,
        loadMask  : {
            msg :  '加载中.....'
        }
    });
	var PhaOrderUrl = 'dhcstm.drugutil.csp?actiontype=GetPhaOrderItemForDialog';

	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : PhaOrderUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["InciDr", "InciItem", "InciCode", "InciDesc", "Spec",
			"ManfName", "PuomDesc", "pRp", "pSp", "PuomQty", "BuomDr", "BuomDesc", "bRp",
			"bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty",
			{name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark", "HVFlag",
			"provLoc","remarks","WarrentNo","WnoDate","ARCDesc",
			"ZeroStkFlag","PbRp","CertNo","CertExpDate","reqPuomQty","Brand","Model"];
	// 支持分页显示的读取方式
	var reader = new Ext.ux.grid.livegrid.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "InciItem",
				fields : fields
			});
	// 数据集
	var PhaOrderStore = new Ext.ux.grid.livegrid.Store({
				bufferSize : 100,
				view: myView,
				proxy : proxy,
				reader : reader,
				listeners : {
					load : function(store, records, options){
						if(records.length > 0){
							sm.selectFirstRow();
							this.view.focusRow(0);
						}
					}
				}
			});

	var StatuTabPagingToolbar = new Ext.ux.grid.livegrid.Toolbar({
				store : PhaOrderStore,
				view : myView,
				//pageSize :9999,
				displayInfo : true,
				displayMsg : '当前记录 {0} -- {1} 条, 共 {2} 条记录'
			});
	// 规格
	var Spec = new Ext.form.TextField({
				fieldLabel : '规格',
				id : 'Spec',
				width : 150,
				emptyText:'规格',
				listeners : {
					specialkey : function(field, e){
						if(e.getKey() == e.ENTER){
							FilterBT.handler();
						}
					}
				}
			});
	// 价格
	var Rp = new Ext.form.TextField({
				fieldLabel : '进价',
				id : 'Rp',
				width : 150,
				emptyText:'进价',
				listeners : {
					specialkey : function(field, e){
						if(e.getKey() == e.ENTER){
							FilterBT.handler();
						}
					}
				}
			});
	// 品牌
	var Brand = new Ext.form.TextField({
				fieldLabel : '品牌',
				id : 'Brand',
				width : 150,
				emptyText:'品牌',
				listeners : {
					specialkey : function(field, e){
						if(e.getKey() == e.ENTER){
							FilterBT.handler();
						}
					}
				}
			});
	    
	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.ux.grid.livegrid.CheckboxSelectionModel({
		singleSelect : (xxxmulselect=="Y")		
	});
	sm.on('rowselect',function(selmod,rowIndex,record){
				var record=PhaOrderGrid.getStore().getAt(rowIndex);
				var incid=record.get("InciDr");
				var pagesize=ItmBatPagingToolbar.pageSize;
				ItmLcBtStore.setBaseParam("IncId",incid);
				ItmLcBtStore.setBaseParam("ProLocId",Locdr);
				ItmLcBtStore.setBaseParam("ReqLocId",toLoc);
				ItmLcBtStore.setBaseParam("QtyFlag",QtyFlag);
				ItmLcBtStore.setBaseParam("StkType",App_StkTypeCode);
				ItmLcBtStore.load({params:{start:0,limit:pagesize}});	
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
			},{
				header : "型号",
				dataIndex : 'Model',
				width : 100,
				align : 'left',
				sortable : true
			},  {
				header : "厂商",
				dataIndex : 'ManfName',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : '入库单位',
				dataIndex : 'PuomDesc',
				width : 60,
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
				width : 60,
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
				width : 60,
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
				xtype : 'checkcolumn',
				width: 45
			}, {
				header : "高值标志",
				dataIndex : 'HVFlag',
				width : 60,
				align : 'center',
				sortable : true,
				hidden : true
			}, {
				header:'供货科室',
				dataIndex : 'provLoc',
			 	width : 100
			}, {
				header:'备注',
				dataIndex : 'remarks',
			 	width : 100
			}, {
				header:'医嘱名称',
				dataIndex : 'ARCDesc',
			 	width : 100
			},{
				header : "零库存标志",
				dataIndex : 'ZeroStkFlag',
				width : 60,
				align : 'center'
				
			},{
				header : "招标进价",
				dataIndex : 'PbRp',
				width : 60,
				align : 'center'
				
			},
			{
				header : "注册证号",
				dataIndex : 'CertNo',
				width : 60,
				align : 'left'	
			},
			{
				header : "注册证效期",
				dataIndex : 'CertExpDate',
				width : 60,
				align : 'center'	
			},
			{
				header : "品牌",
				dataIndex : 'Brand',
				width : 60,
				align : 'center'	
			}
			]);
	PhaOrderCm.defaultSortable = true;
	var FilterBT = new Ext.Toolbar.Button({
				text : '筛选',
				tooltip : '筛选',
				iconCls : 'page_find',
				handler : function() {
					refreshGrid(1);   ///通过筛选按钮调用1
				}
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
		var selectRows = PhaOrderGrid.getSelectionModel().getSelections();
		var selectRows1 = ItmLcBtGrid.getSelectionModel().getSelections();
		if (selectRows1.length == 0) {
			Msg.info("warning", "请选择要返回的物资批次信息！");
		} else {
			xxxFn(selectRows[0],selectRows1[0]);
			window.hide();
		}
	}
	
	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '点击关闭',
		iconCls : 'page_delete',
		handler : function() {
			if (Ext.getCmp('sss')){
				Ext.getCmp('sss').close();
			}
		}
	});

	var PhaOrderGrid = new Ext.ux.grid.livegrid.GridPanel({
		id:'PhaOrderGrid',
		cm : PhaOrderCm,
		store : PhaOrderStore,
		view: myView,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm,
		loadMask : true,
		tbar : [returnBT, '-', closeBT,'-',Spec,'-',Rp,'-',Brand,'-',FilterBT],
		bbar : StatuTabPagingToolbar,
		deferRowRender : false,
		listeners : {
			'keydown' : function(e) {	// 回车事件
				if (e.getKey() == Ext.EventObject.ENTER) {
					returnData();
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
				header : "单位",
				dataIndex : 'PurUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "批次售价",
				dataIndex : 'BatSp',
				width : 80,
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
				header : "入库日期",
				dataIndex : 'IngrDate',
				width : 80,
				align : 'center',
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
		deferRowRender : false,
		listeners :{
			'rowdblclick' : function() {
				returnData();
			}
		}
	});
	
	var stkcatPanel=new Ext.tree.TreePanel({
		useArrows: true,
		autoScroll: true,
		width:240,
		collapsed:(tree==0?true:false),
		enableDD: true,
		split : true,
		containerScroll: true,
		border: false,
		loader: null,
		lines:true,
		root: {
			nodeType: 'async',
			text: '分类',
			draggable: false,
			id: 'AllSCG',
			expanded:true
		},
		listeners:{
			'click' : treeClick,
			'beforeload' : function(node){
				if((loc1==undefined )||(loc1=="")){
					loc1=session['LOGON.CTLOCID'];
				}
				if (loc2==undefined) loc2="";
				// 定义子节点的Loader
				stkcatPanel.loader.dataUrl = 'dhcstm.stkcataction.csp?actiontype=incsc&id='
					+ node.id+"&loc="+loc1+'&user='+session['LOGON.USERID']+'&scg='+StkGrpRowId +"&loc2="+loc2;
			}
		}
	});
	
	if (tree==1) {
		stkcatPanel.getRootNode().expand(true);
	}
	
	function treeClick(node, e){
		if (node.isLeaf()) {
			e.stopEvent();
			var id=node.id;
			var stkcats=id.split("-")
			stkcat=stkcats[1];
			//检索库存分类对应项目
			PhaOrderStore.setBaseParam("Input",xxxInput);
			PhaOrderStore.setBaseParam("StkGrpRowId",xxxStkGrpRowId);
			PhaOrderStore.setBaseParam("StkGrpType",xxxStkGrpType);
			PhaOrderStore.setBaseParam("Locdr",xxxLocdr);
			PhaOrderStore.setBaseParam("NotUseFlag",xxxNotUseFlag);
			PhaOrderStore.setBaseParam("QtyFlag",xxxQtyFlag);
			PhaOrderStore.setBaseParam("HospID",xxxHospID);
			PhaOrderStore.setBaseParam("start",0);
			PhaOrderStore.setBaseParam("limit",StatuTabPagingToolbar.pageSize);
			PhaOrderStore.setBaseParam("StkCat",stkcat);
			PhaOrderStore.setBaseParam("ReqModeLimited",xxxReqModeLimited);
			PhaOrderStore.setBaseParam("NoLocReq",xxxNoLocReq);
			PhaOrderStore.setBaseParam('HV',xxxHV);
			PhaOrderStore.setBaseParam('RequestNoStock',xxxRequestNoStock);
			ItmLcBtStore.removeAll();
			PhaOrderStore.load();
		}
	}
	
	var window = new Ext.Window({
		title : '物资信息',
		id:'sss',
		width : 1000,
		height : 500,
		layout:'border',
		plain : true,
		modal : true,
		buttonAlign : 'center',
		items : [{region:'west',width:200,layout:'fit',collapsible:true,collapsed:(tree==0?true:false),hidden:(tree==0?true:false),split:true,items:stkcatPanel},
			{region:'north',layout:'fit',height:300,width:500,split:true,items:PhaOrderGrid},
			{region:'center',layout:'fit',items:ItmLcBtGrid}],
		listeners:{
			'show':function(){
				gPhaOrderWindowFlag=true;	//通过全局变量控制多个window显示的问题,close时置为false
				refreshGrid(0);
			},
			'close' : function(panel) {
				xxxPhaOrderWin=null;
				gPhaOrderWindowFlag=false;
			},
			'hide' : function(panel) {
				Ext.getCmp('Spec').setValue("");
				Ext.getCmp('Rp').setValue("");
				Ext.getCmp('Brand').setValue("");
				xxxPhaOrderWin=window;
				gPhaOrderWindowFlag=false;
			}
		}
	});
	window.show();
	
	function refreshGrid(Filter){
		if (xxxInput.trim()=="") return;
		var spec=Ext.getCmp('Spec').getValue();
		var rp=Ext.getCmp('Rp').getValue();
		var brand=Ext.getCmp('Brand').getValue();
		PhaOrderStore.removeAll();
		ItmLcBtStore.removeAll();
		PhaOrderStore.setBaseParam("Input",xxxInput);
		PhaOrderStore.setBaseParam("StkGrpRowId",xxxStkGrpRowId);
		PhaOrderStore.setBaseParam("StkGrpType",xxxStkGrpType);
		PhaOrderStore.setBaseParam("Locdr",xxxLocdr);
		PhaOrderStore.setBaseParam("NotUseFlag",xxxNotUseFlag);
		PhaOrderStore.setBaseParam("QtyFlag",xxxQtyFlag);
		PhaOrderStore.setBaseParam("HospID",xxxHospID);
		PhaOrderStore.setBaseParam("StkCat","");
		PhaOrderStore.setBaseParam("toLoc",toLoc);
		PhaOrderStore.setBaseParam("ReqModeLimited",xxxReqModeLimited);  
		PhaOrderStore.setBaseParam("NoLocReq",xxxNoLocReq);
		PhaOrderStore.setBaseParam('Spec',spec);
		PhaOrderStore.setBaseParam('Rp',rp);
		PhaOrderStore.setBaseParam('Brand',brand);
		PhaOrderStore.setBaseParam('Vendor',xxxvendor);
		PhaOrderStore.setBaseParam('HV',xxxHV);
		PhaOrderStore.setBaseParam('RequestNoStock',xxxRequestNoStock);
		PhaOrderStore.load({
			params:{start:0, limit:StatuTabPagingToolbar.pageSize},
			callback:function(r, options, success){
				if (!success || r.length==0) {
					Msg.info('warning','没有任何符合的记录！');
					if(window&&Filter==0){
						window.hide();
					}
				} else if(r.length>0) {
					PhaOrderGrid.getSelectionModel().selectFirstRow();// 选中第一行并获得焦点
					PhaOrderGrid.getView().focusRow(0);
				}
			}
		});
	}
}

//根据库存项条码获取物资信息
//2013-12-05
//zhangxiao
//wangjiabin 2014-06-05 store加载后直接通过Fn返回信息,不再展示
GetPhaOrderByBarcodeWindow = function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag,
		QtyFlag, HospID, Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
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
			"ManfName", "PuomDesc", "pRp", "pSp", "PuomQty","BuomDr","BuomDesc", "bRp",
			"bSp", "BuomQty", "BillUomDesc", "BillSp", "BillRp", "BillUomQty",
			{name:'NotUseFlag',type: 'bool'}, "PuomDr",
			"PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark", "HVFlag"];
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
	
	PhaOrderStore.load({
		callback : function(r, options, success) {
			if (success == false) {
				Msg.info('error','查询有误,请查看日志!');
			}else if(r.length==0){
				Msg.info('warning','没有任何符合的记录!');
			}else{
				Fn(r[0])
			}
		}
	});
}