/**
 * 查询界面
 * params: InOutFlag(转入转出标志:转入1,转出0), Fn
 */
function BCInIsTrfFind(InOutFlag,Fn) {
	var gGroupId=session['LOGON.GROUPID'];
	//取参数配置
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	// 转移单号
	var InItNo2 = new Ext.form.TextField({
				fieldLabel : '转移单号',
				id : 'InItNo2',
				name : 'InItNo2',
				anchor : '90%',
				width : 120
			});
		

	if(InOutFlag==1){
		//转移单frLoc
		var FromPhaLoc2 = new Ext.ux.LocComboBox({
					fieldLabel : '供给部门',
					id : 'FromPhaLoc2',
					name : 'FromPhaLoc2',
					anchor:'90%',
					emptyText : '供给部门...',
					defaultLoc:{}
			});
		// 转移单toLoc
		var ToPhaLoc2 = new Ext.ux.LocComboBox({
					fieldLabel : '接收部门',
					id : 'ToPhaLoc2',
					name : 'ToPhaLoc2',
					anchor:'90%',
					emptyText : '接收部门...',
					groupId:gGroupId
			});
		//单据状态
		var StatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['10', '未完成'], ['30','拒绝接收']]
		});
	}else if(InOutFlag==0){
		//转移单frLoc
		var FromPhaLoc2 = new Ext.ux.LocComboBox({
					fieldLabel : '供给部门',
					id : 'FromPhaLoc2',
					name : 'FromPhaLoc2',
					anchor:'90%',
					emptyText : '供给部门...',
					groupId:gGroupId
			});
		// 转移单toLoc
		var ToPhaLoc2 = new Ext.ux.LocComboBox({
					fieldLabel : '接收部门',
					id : 'ToPhaLoc2',
					name : 'ToPhaLoc2',
					anchor:'90%',
					emptyText : '接收部门...',
					defaultLoc:{}
			});
		//单据状态
		var StatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['10', '未完成'], ['11', '已完成'], ['20', '出库审核不通过']]
		});
	}

		
	// 起始日期
	var StartDate2 = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate2',
				name : 'StartDate2',
				anchor : '90%',
				width : 120,
				value : DefaultStDate()
			});

	// 结束日期
	var EndDate2 = new Ext.ux.DateField({
				fieldLabel : '结束日期',
				id : 'EndDate2',
				name : 'EndDate3',
				anchor : '90%',
				width : 120,
				value : DefaultEdDate()
			});

	// 请求单号
	var InRqNo2 = new Ext.form.TextField({
				fieldLabel : '请求单号',
				id : 'InRqNo2',
				name : 'InRqNo2',
				anchor : '90%',
				width : 120
			});
		
	var Status = new Ext.form.ComboBox({
		fieldLabel : '单据状态',
		id : 'Status',
		name : 'Status',
		anchor:'90%',
		width : 120,
		store : StatusStore,
		triggerAction : 'all',
		mode : 'local',
		valueField : 'RowId',
		displayField : 'Description',
		allowBlank : true,
		triggerAction : 'all',
		selectOnFocus : true,
		forceSelection : true,
		minChars : 1,
		editable : true,
		valueNotFoundText : ''
	});
	Ext.getCmp("Status").setValue(10);
	var InfoForm3 = new Ext.form.FormPanel({
		frame : true,
		labelAlign : 'right',
		labelWidth:60,
		id : "InfoForm3",
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			autoHeight : true,
			items : [{
				layout : 'column',
				items : [{
					columnWidth : .33,
					layout : 'form',
					items : [FromPhaLoc2,ToPhaLoc2]
				}, {
					columnWidth : .33,
					layout : 'form',
					items : [StartDate2,EndDate2]
				}, {
					columnWidth : .33,
					layout : 'form',
					items : [InItNo2,Status]
				}]
			}]
		}]
	});

	// 查询按钮
	var searchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询转移信息',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchDurgData();
				}
			});

	function searchDurgData() {
		var UserScgPar = '';		//个人专业组授权过滤用到的参数
		var ToPhaLoc2 = Ext.getCmp("ToPhaLoc2").getValue();
		var FromPhaLoc2 = Ext.getCmp("FromPhaLoc2").getValue();
		if(InOutFlag==1){
			if (ToPhaLoc2 == null || ToPhaLoc2.length <= 0) {
				Msg.info("warning", "接收部门不能为空！");
				return;
			}
			UserScgPar = ToPhaLoc2 + '%' + session['LOGON.USERID'];
		}else if(InOutFlag==0){
			if (FromPhaLoc2 == null || FromPhaLoc2.length <= 0) {
				Msg.info("warning", "供给部门不能为空！");
				return;
			}
			UserScgPar = FromPhaLoc2 + '%' + session['LOGON.USERID'];
		}

		var StartDate = Ext.getCmp("StartDate2").getValue();
		if((StartDate!="")&&(StartDate!=null)){
			StartDate = StartDate.format(ARG_DATEFORMAT);
		}
		if((StartDate=="")||(StartDate==null)){
			Msg.info("error","请选择起始日期!");
			return;
		}
		
		var EndDate = Ext.getCmp("EndDate2").getValue();
		if((EndDate!="")&&(EndDate!=null)){
			EndDate = EndDate.format(ARG_DATEFORMAT);
		}
		if((EndDate=="")||(EndDate==null)){
			Msg.info("error","请选择截止日期!");
			return;
		}
		
		var InRqNo = "";
		var InItNo = Ext.getCmp("InItNo2").getValue();
		var Status=Ext.getCmp("Status").getValue();
		if (Status==null || Status==""){
			Status='10,11,20';
		}
		var ListParam=StartDate+'^'+EndDate+'^'+FromPhaLoc2+'^'+ToPhaLoc2+'^'
			+'^'+Status+'^'+InItNo+'^'+InRqNo+'^^'
			+'^^^^'+UserScgPar;
		var Page=GridPagingToolbar.pageSize;
		ItMasterInfoStore.setBaseParam('ParamStr',ListParam);
		ItMasterInfoStore.removeAll();
		ItDetailInfoGrid.store.removeAll();
		ItMasterInfoStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
				if(success==false){
     				Msg.info("error", "查询错误，请查看日志!");
     			}else{
     				if(r.length>0){
	     				ItMasterInfoGrid.getSelectionModel().selectFirstRow();
	     				ItMasterInfoGrid.getView().focusRow(0);
     				}
     			}
			}
		});
	}

	// 返回按钮
	var returnBT = new Ext.Toolbar.Button({
				text : '返回',
				tooltip : '点击返回',
				iconCls : 'page_goto',
				height:30,
				width:70,
				handler : function() {
					returnData();
				}
			});

	function returnData() {
		var selectRows = ItMasterInfoGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "请选择要返回的转移单信息！");
			Fn("");
		} else {
			var InitRowId = selectRows[0].get("init");				
			Fn(InitRowId);	
		}
		FindWindow.close();
	}
			
	// 清空按钮
	var clearBT = new Ext.Toolbar.Button({
				text : '清空',
				tooltip : '点击清空',
				iconCls : 'page_clearscreen',
				height:30,
				width:70,
				handler : function() {
					clearData();
				}
			});

	function clearData() {
		Ext.getCmp("FromPhaLoc2").setValue("");
		Ext.getCmp("ToPhaLoc2").setValue("");
		if(InOutFlag==1){
			SetLogInDept(Ext.getCmp("ToPhaLoc2").getStore(),"ToPhaLoc2");
		}else{
			SetLogInDept(Ext.getCmp("FromPhaLoc2").getStore(),"FromPhaLoc2");
		}
		Ext.getCmp("StartDate2").setValue(DefaultStDate());
		Ext.getCmp("EndDate2").setValue(DefaultEdDate());
		Ext.getCmp("InItNo2").setValue("");
		Ext.getCmp("InRqNo2").setValue("");
		Ext.getCmp("Status").setValue("10");
		ItMasterInfoGrid.store.removeAll();
		ItDetailInfoGrid.store.removeAll();
	}

	// 3关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '关闭界面',
				iconCls : 'page_delete',
				height:30,
				width:70,
				handler : function() {
					FindWindow.close();
				}
			});

	// 访问路径
	var MasterInfoUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["init", "initNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName","status","StatusCode"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "init",
				fields : fields
			});
	// 数据集
	var ItMasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var ItMasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'init',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "转移单号",
				dataIndex : 'initNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "接收部门",
				dataIndex : 'toLocDesc',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "供给部门",
				dataIndex : 'frLocDesc',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : '完成状态',
				dataIndex : 'comp',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : '单据状态',
				dataIndex : 'StatusCode',
				width : 90,
				align : 'center',
				sortable : true
			}, {
				header : '日期',
				dataIndex : 'dd',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "时间",
				dataIndex : 'tt',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '制单人',
				dataIndex : 'userName',
				width : 100,
				align : 'left',
				sortable : true
			}]);
	ItMasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:ItMasterInfoStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	var ItMasterInfoGrid = new Ext.grid.GridPanel({
				id : 'ItMasterInfoGrid',
				title : '',
				height : 170,
				cm : ItMasterInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : ItMasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:GridPagingToolbar
			});

	// 添加表格单击行事件
	ItMasterInfoGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var InIt = ItMasterInfoStore.getAt(rowIndex).get("init");
		ItDetailInfoStore.setBaseParam('Parref',InIt);
		ItDetailInfoStore.removeAll();
		ItDetailInfoStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'',dir:'Desc'}});
	});

	// 访问路径
	var DetailInfoUrl =  DictUrl
					+ 'dhcinistrfaction.csp?actiontype=QueryDetail';;
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailInfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["initi", "inrqi", "inci","inciCode",
				"inciDesc", "inclb", "batexp", "manf","manfName",
				 "qty", "uom", "sp","status","remark",
				"reqQty", "inclbQty", "reqLocStkQty", "stkbin",
				"pp", "spec", "newSp",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", "inclbDirtyQty", "inclbAvaQty","TrUomDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "initi",
				fields : fields
			});
	// 数据集
	var ItDetailInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var ItDetailInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "转移细项RowId",
				dataIndex : 'initi',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '物资代码',
				dataIndex : 'inciCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资名称',
				dataIndex : 'inciDesc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "批次~效期",
				dataIndex : 'batexp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "生产厂商",
				dataIndex : 'manfName',
				width : 180,
				align : 'left'
			}, {
				header : "转移数量",
				dataIndex : 'qty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "转移单位",
				dataIndex : 'TrUomDesc',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "进价",
				dataIndex : 'rp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'sp',
				width : 60,
				align : 'right',
				
				sortable : true
			}, {
				header : "请求数量",
				dataIndex : 'reqQty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "货位码",
				dataIndex : 'stkbin',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "批次售价",
				dataIndex : 'newSp',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'spec',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'spAmt',
				width : 100,
				align : 'right',
				sortable : true
			}]);
	ItDetailInfoCm.defaultSortable = true;
	var GridDetailPagingToolbar = new Ext.PagingToolbar({
		store:ItDetailInfoStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	var ItDetailInfoGrid = new Ext.grid.GridPanel({
				title : '',
				height : 170,
				cm : ItDetailInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : ItDetailInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				bbar:GridDetailPagingToolbar,
				loadMask : true
			});

	// 双击事件
	ItMasterInfoGrid.on('rowdblclick', function() {
				returnData();
			});

	var FindWindow = new Ext.Window({
				title : '转移单查询',
				width : 1000,
				height : 550,
				modal : true,
				layout : 'border',
				items : [            // create instance immediately
		            {
		                region: 'north',
		                height: 110, // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:InfoForm3
		            }, {
		                region: 'west',
		                title: '入库单',
		                collapsible: true,
		                split: true,
		                width: 225, // give east and west regions a width
		                minSize: 175,
		                maxSize: 400,
		                margins: '0 5 0 0',
		                layout: 'fit', // specify layout manager for items
		                items: ItMasterInfoGrid       
		               
		            }, {
		                region: 'center',
		                title: '入库单明细',
		                layout: 'fit', // specify layout manager for items
		                items: ItDetailInfoGrid       
		               
		            }
       			],
				tbar : [searchBT, '-', returnBT, '-', clearBT, '-', closeBT]
			});
	FindWindow.show();
	searchDurgData();
}