
var xxxInput="";
var xxxStkGrpRowId="";
var xxxStkGrpType="";
var xxxLocdr="";
var xxxNotUseFlag="";
var xxxQtyFlag="";
var xxxHospID="";
var xxxPhaOrderWin;
var xxxFn;
var xxxVendor;
GetPhaOrderWindow = function(Input, StkGrpRowId, StkGrpType, Locdr, NotUseFlag,
		QtyFlag, HospID, Fn, Vendor) {
	xxxInput=Input;
	xxxStkGrpRowId=StkGrpRowId;
	xxxStkGrpType=StkGrpType;
	xxxLocdr=Locdr;
	xxxNotUseFlag=NotUseFlag;
	xxxQtyFlag=QtyFlag;
	xxxHospID=HospID;
	xxxFn=Fn;
	xxxVendor=Vendor;
	var gPhaOrderWindowFlag = typeof(gPhaOrderWindowFlag)=='undefined'?false:gPhaOrderWindowFlag;
	
	if (xxxPhaOrderWin){
		xxxPhaOrderWin.show();
		return;
	}
	if(gPhaOrderWindowFlag){
		return;
	}
	var PhaOrderUrl = 'dhcstm.vendoruseraction.csp?actiontype=GetPhaOrderItemForDialog';

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
			"PFac", "Manfdr", "MaxQty", "MinQty", "StockQty", "Remark", "HVFlag","provLoc","remarks","WarrentNo","WnoDate"];
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
                		if(e.getKey()==e.ENTER){
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
                		if(e.getKey()==e.ENTER){
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
                		if(e.getKey()==e.ENTER){
                			FilterBT.handler();
                		}
                	}
                }
            });
	    
	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
	
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
			}]);
	PhaOrderCm.defaultSortable = true;
    var FilterBT = new Ext.Toolbar.Button({
				text : '筛选',
				tooltip : '筛选',
				iconCls : 'page_find',
				handler : function() {
				refreshGrid(1)   ///通过筛选按钮调用1
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
		if (selectRows.length == 0) {
			Msg.info("warning", "请选择要返回的物资信息！");
		} else if (selectRows.length > 1) {
			Msg.info("warning", "返回只允许选择一条记录！");
		} else {
			xxxFn(selectRows[0]);
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

	var PhaOrderGrid = new Ext.grid.GridPanel({
		cm : PhaOrderCm,
		store : PhaOrderStore,
		trackMouseOver : true,
		stripeRows : true,
		sm : sm,
		loadMask : true,
		tbar : [returnBT, '-', closeBT,'-',Spec,'-',Rp,'-',Brand,'-',FilterBT],
		bbar : StatuTabPagingToolbar,
		deferRowRender : false,
		listeners : {
			'rowdblclick' : function() {
				returnData();
			},
			'keydown' : function(e) {	// 回车事件
				if (e.getKey() == Ext.EventObject.ENTER) {
					returnData();
				}
			}
		}
	});
	
	var window = new Ext.Window({
		title : '物资信息',
		id:'sss',
		width : 1000,
		height : 500,
		layout:'border',
		plain : true,
		modal : true,
		buttonAlign : 'center',
		items : [
			{region:'center',layout:'fit',width:500,split:true,items:PhaOrderGrid}
		],
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
		PhaOrderStore.setBaseParam("Input",xxxInput);
		PhaOrderStore.setBaseParam("StkGrpRowId",xxxStkGrpRowId);
		PhaOrderStore.setBaseParam("StkGrpType",xxxStkGrpType);
		PhaOrderStore.setBaseParam("Locdr",xxxLocdr);
		PhaOrderStore.setBaseParam("NotUseFlag",xxxNotUseFlag);
		PhaOrderStore.setBaseParam("QtyFlag",xxxQtyFlag);
		PhaOrderStore.setBaseParam("HospID",xxxHospID);
		PhaOrderStore.setBaseParam("StkCat","");
		PhaOrderStore.setBaseParam('Spec',spec);
		PhaOrderStore.setBaseParam('Rp',rp);
	    PhaOrderStore.setBaseParam('Brand',brand);
	    PhaOrderStore.setBaseParam('Vendor',xxxVendor);
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
