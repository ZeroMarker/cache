// /名称: 查询界面
// /描述: 查询界面
// /编写者：zhangdongmei
// /编写日期: 2012.08.29

function InStkTkSearch(Fn) {
	var gGroupId=session['LOGON.GROUPID'];
	var gUserId=session["LOGON.USERID"];
	var gStrParamS='';
	var gLocId=session["LOGON.CTLOCID"];
	var PhaLocS = new Ext.ux.LocComboBox({
				fieldLabel : '科室',
				id : 'PhaLocS',
				name : 'PhaLocS',
				anchor : '95%',
				groupId:gGroupId,
				width : 140
			});
	
	// 起始日期
	var StartDateS = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDateS',
				name : 'StartDateS',
				anchor : '90%',
				
				width : 120,
				value : new Date()
			});

	// 结束日期
	var EndDateS = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDateS',
				name : 'EndDateS',
				anchor : '90%',
				
				width : 120,
				value : new Date()
			});
	var CompleteS=new Ext.form.Checkbox({
		fieldLabel:'包含完成',
		id:'CompleteS',
		name:'CompleteS',
		width : 100,
		height : 10,
		checked:false
	});

	var InfoFormS = new Ext.form.FormPanel({
				frame : true,
				labelAlign : 'right',
				id : "InfoFormS",
				items:[{
					xtype:'fieldset',
					title:'查询条件',
					layout: 'column',
					bodyStyle: 'padding:0 0 0 0;',
					style: 'padding:0 0 0 0;',
					defaults : {border : false, style: 'padding:0 0 0 0;'},
					items : [{
						columnWidth: 0.34,
						xtype: 'fieldset',
						labelWidth: 60,
						items: [PhaLocS]
					},{
						columnWidth: 0.33,
						xtype: 'fieldset',
						labelWidth: 60,
						items: [StartDateS]
					},{
						columnWidth: 0.33,
						xtype: 'fieldset',
						labelWidth: 60,
						items: [EndDateS,CompleteS]
					}]
				}]
			});

	// 检索按钮
	var searchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击检索盘点单信息',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchData();
				}
			});

	function searchData() {
		var StartDate = Ext.getCmp("StartDateS").getValue()
		if(Ext.isEmpty(StartDate)){
			Msg.info('warning', '请选择起始日期!');
			return false;
		}else{
			StartDate = StartDate.format(ARG_DATEFORMAT).toString();
		}
		var EndDate = Ext.getCmp("EndDateS").getValue()
		if(Ext.isEmpty(EndDate)){
			Msg.info('warning', '请选择截止日期!');
			return false;
		}else{
			EndDate = EndDate.format(ARG_DATEFORMAT).toString();
		}
		var PhaLoc = Ext.getCmp("PhaLocS").getValue();
		if(PhaLoc==""){
			Msg.info("warning", "请选择盘点科室!");
			return;
		}
		var CompFlag='N';
		var IncludeComp=Ext.getCmp("CompleteS").getValue();
		if(IncludeComp==true){
			CompFlag='';
		}
		var TkComplete='N';  //实盘完成标志
		var AdjComplete='N';	//调整完成标志
		var Page=GridPagingToolbar.pageSize;
		gStrParamS=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete+'^'+gUserId;
		MasterInfoStore.removeAll();
		MasterInfoStore.setBaseParam('sort', 'instNo');
		MasterInfoStore.setBaseParam('dir', 'asc');
		MasterInfoStore.setBaseParam('Params', gStrParamS);
		MasterInfoStore.load({params:{start:0, limit:Page}});
	}

	// 选取按钮
	var returnBT = new Ext.Toolbar.Button({
				text : '选取',
				tooltip : '点击选取',
				iconCls : 'page_goto',
				height:30,
				width:70,
				handler : function() {
					returnData();
				}
			});

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
		Ext.getCmp("PhaLocS").setValue(gLocId);
		Ext.getCmp("StartDateS").setValue(new Date());
		Ext.getCmp("EndDateS").setValue(new Date());
		Ext.getCmp("Complete").setValue(false);
		Ext.getCmp("CompleteS").setValue("");
		MasterInfoGrid.store.removeAll();
		//DetailInfoGrid.store.removeAll();
	}

	// 3关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '关闭界面',
				iconCls : 'page_delete',
				height:30,
				width:70,
				handler : function() {
					window.close();
				}
			});

	// 访问路径
	var MasterInfoUrl = DictUrl	+ 'instktkaction.csp?actiontype=Query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});

	// 指定列参数
	var fields = ["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb","printflag",
			"MinRp","MaxRp","RandomNum"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "inst",
				fields : fields
			});
	// 数据集
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
			
	function renderCompFlag(value){
		if(value=='Y'){
			return '完成';
		}else{
			return '未完成'
		}	
	}
	function renderManaFlag(value){
		if(value=='Y'){
			return '重点关注';
		}else{
			return '非重点关注'
		}	
	}
	function renderYesNo(value){
		if(value=='Y'){
			return '是';
		}else{
			return '否'
		}	
	}
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'inst',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true,
				hideable : false
			}, {
				header : "盘点单号",
				dataIndex : 'instNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "盘点日期",
				dataIndex : 'date',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '盘点时间',
				dataIndex : 'time',
				width : 100,
				align : 'left',
				sortable : true
			},{
				header : '是否打印',
				dataIndex : 'printflag',
				width : 70,
				align : 'left',
				renderer:renderYesNo,
				sortable : true
			}, {
				header : '盘点人',
				dataIndex : 'userName',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '帐盘完成标志',
				dataIndex : 'comp',
				width : 80,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : '重点关注标志',
				dataIndex : 'manFlag',
				width : 80,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : "帐盘单位",
				dataIndex : 'freezeUom',
				width : 80,
				align : 'left',
				renderer:function(value){
					if(value==1){
						return '入库单位';
					}else{
						return '基本单位';
					}
				},
				sortable : true
			}, {
				header : "包含不可用",
				dataIndex : 'includeNotUse',
				width : 80,
				align : 'center',
				renderer:renderYesNo,
				sortable : true
			}, {
				header : "仅不可用",
				dataIndex : 'onlyNotUse',
				renderer:renderYesNo,
				width : 80,
				align : 'center',
				sortable : true
			}, {
				header : "类组",
				dataIndex : 'scgDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "库存分类",
				dataIndex : 'scDesc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "开始货位",
				dataIndex : 'frSb',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "截止货位",
				dataIndex : 'toSb',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "最低进价",
				dataIndex : 'MinRp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "最高进价",
				dataIndex : 'MaxRp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "随机数",
				dataIndex : 'RandomNum',
				width : 60,
				align : 'right',
				sortable : true
			}]);
	MasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : MasterInfoStore,
					pageSize : PageSize,
					displayInfo : true
				});
	var MasterInfoGrid = new Ext.grid.GridPanel({
				id : 'MasterInfoGrid',
				title : '',
				height : 170,
				cm : MasterInfoCm,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true
						}),
				store : MasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// 双击事件
	MasterInfoGrid.on('rowdblclick', function() {
				returnData();
			});

	
	var window = new Ext.Window({
				title : '盘点单',
				width : 900,
				height : 600,
				modal : true,
				layout : 'border',
				items : [
					{
						region: 'north',
						height: 100, // give north and south regions a height
						layout: 'fit', // specify layout manager for items
						items:InfoFormS
					}, {
						region: 'center',
						layout: 'fit', // specify layout manager for items
						items: MasterInfoGrid
					}
				],
				tbar : [searchBT, '-', returnBT, '-', clearBT, '-', closeBT],
				listeners : {
					show : function(){
						searchBT.handler();
					},
					close : function(panel) {
						var selectRows = MasterInfoGrid.getSelectionModel().getSelections();
						if (selectRows.length > 0) {
							var RowId = selectRows[0].get("inst");
							Fn(RowId);
						}
					}
				}
			});
	window.show();

	function returnData() {
		var selectRows = MasterInfoGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning","请选择要返回的盘点单信息！");
		} else {
			window.close();
		}
	}
}