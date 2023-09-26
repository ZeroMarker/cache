// 批次台帐
function InclbTransQuery(Inclb,StkDate,InclbInfo) {

	function replaceAll(str, rgExp, replaceStr) {
		while (str.indexOf(rgExp) > -1) {
			str = str.replace(rgExp, replaceStr);
		}
		return str;
	}

	InclbInfo=replaceAll(InclbInfo," ","　"); //用全角空格代替半角空格，防止label展示的时候自动将半角空格过滤掉

	// 起始日期
	var StartDateInclb = new Ext.ux.DateField({
			fieldLabel : '起始日期',
			id : 'StartDateInclb',
			anchor : '90%',
			
			width : 120,
			value : StkDate
	});

	// 结束日期
	var EndDateInclb = new Ext.ux.DateField({
			fieldLabel : '结束日期',
			id : 'EndDateInclb',
			anchor : '90%',
			
			width : 120,
			value : StkDate
	});

    var InclbInfoLabel = new Ext.form.Label({
    	text:InclbInfo,
		align:'center',
		cls: 'classDiv1'
    })

	// 检索按钮
	var searchBT = new Ext.Toolbar.Button({
				text : '检索',
				tooltip : '点击检索物资台帐',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					searchDataIncb();
				}
			});

	/**
	 * 查询方法
	 */
	function searchDataIncb() {
		if (Ext.isEmpty(Inclb)) {
			return;
		}
		var StartDateInclb = Ext.getCmp("StartDateInclb").getValue();
		if(Ext.isEmpty(StartDateInclb)){
			Msg.info('warning', '起始日期不可为空!');
			return false;
		}else{
			StartDateInclb = StartDateInclb.format(ARG_DATEFORMAT).toString();
		}
		var EndDateInclb = Ext.getCmp("EndDateInclb").getValue();
		if(Ext.isEmpty(EndDateInclb)){
			Msg.info('warning', '结束日期不可为空!');
			return false;
		}else{
			EndDateInclb = EndDateInclb.format(ARG_DATEFORMAT).toString();
		}
		InclbTransStore.setBaseParam('incil', Inclb);
		InclbTransStore.setBaseParam('startdate', StartDateInclb);
		InclbTransStore.setBaseParam('enddate', EndDateInclb);
		var size=InclbTransPaging.pageSize;
		InclbTransStore.load({params:{start:0,limit:size}});
	}

	var InclbTransStore = new Ext.data.JsonStore({
		url : DictUrl + 'locitmstkaction.csp?actiontype=LocItmStkMoveDetail',
		root : 'rows',
		totalProperty : "results",
		fields : ["TrId","TrDate", "BatExp", "PurUom", "Sp","Rp","EndQty","EndQtyUom",
			"TrQty", "TrQtyUom", "RpAmt", "SpAmt","TrNo","TrAdm","TrMsg",
			"EndRpAmt", "EndSpAmt", "Vendor", "Manf","OperateUser", "HVBarCode", "EndQtyUomInclb", "TrPointer"]
	});
	var nm = new Ext.grid.RowNumberer();
	var InclbTransCm = new Ext.grid.ColumnModel([nm, {
				header : "TrId",
				dataIndex : 'TrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "业务RowId",
				dataIndex : 'TrPointer',
				hidden : true
			}, {
				header : "日期",
				dataIndex : 'TrDate',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : '批号效期',
				dataIndex : 'BatExp',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : "单位",
				dataIndex : 'PurUom',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : "高值条码",
				dataIndex : 'HVBarCode',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 60,
				align : 'right'
			}, {
				header : "结余数量",
				dataIndex : 'EndQtyUomInclb',		//批次结余数量
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "数量",
				dataIndex : 'TrQtyUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "进价金额",
				dataIndex : 'RpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "处理号",
				dataIndex : 'TrNo',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "处理人",
				dataIndex : 'TrAdm',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "摘要",
				dataIndex : 'TrMsg',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "结余金额(进价)",
				dataIndex : 'EndRpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "结余金额(售价)",
				dataIndex : 'EndSpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'Vendor',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'Manf',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : "操作人",
				dataIndex : 'OperateUser',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	var InclbTransPaging = new Ext.PagingToolbar({
			store : InclbTransStore,
			pageSize : PageSize
		});
	var InclbTransGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				region:'center',
				cm : InclbTransCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : InclbTransStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar : InclbTransPaging
			});

	var InclbTransPanel = new Ext.form.FormPanel({
			region : 'north',
			height : 140,
			labelAlign : 'right',
			frame : true,
			bodyStyle : 'padding:10px 0 0 0;',
			tbar : [searchBT],
			layout : 'table',
			layoutConfig: {columns:2},
		    items:[{
		    		xtype:'fieldset',
		    		border:false,
		    		items:[StartDateInclb]
		    	  },{
		    	  	xtype:'fieldset',
		    	  	border:false,
		    	  	items:[EndDateInclb]
		    	  },{
		    	  	colspan:2,
		    	 	items:[InclbInfoLabel]
		    	}
		    ]
		});

	var InclbTransMoveWin = new Ext.Window({
				title : '批次台帐信息',
				width : gWinWidth,
				height : gWinHeight,
				modal : true,
				layout:'border',
				items : [ InclbTransPanel, InclbTransGrid]
			});
	InclbTransMoveWin.show();
	searchBT.handler();
}