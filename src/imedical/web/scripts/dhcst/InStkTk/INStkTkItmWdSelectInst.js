// /名称: 实盘：选取要实盘的盘点单
// /描述: 实盘：选取要实盘的盘点单
// /编写者：zhangdongmei
// /编写日期: 2012.09.04
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gStrParams='';
	var gGroupId=session["LOGON.GROUPID"];
	var url=DictUrl+'instktkaction.csp';
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('科室'),
				id : 'PhaLoc',
				name : 'PhaLoc',
				width : 140,
				emptyText : $g('科室...'),
				groupId:gGroupId
			});
	
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : $g('起始日期'),
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				width : 80,
				value : new Date().add(Date.DAY, - 30)
			});

	// 结束日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : $g('结束日期'),
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				width : 80,
				value : new Date()
			});
	
	// 查询按钮
	var QueryBT = new Ext.Toolbar.Button({
				text :$g( '查询'),
				tooltip : $g('点击查询'),
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
			});

	
	//查询盘点单
	function Query(){
	
		var StartDate = Ext.getCmp("StartDate").getValue().format(App_StkDateFormat).toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format(App_StkDateFormat).toString();
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", $g("请选择盘点科室!"));
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", $g("请选择开始日期和截止日期!"));
			return;
		}
		var CompFlag='Y';
		var TkComplete='N';  //实盘完成标志
		var AdjComplete='N';	//调整完成标志
		var Page=GridPagingToolbar.pageSize;
		gStrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
		
		MasterInfoStore.setBaseParam('actiontype','Query');
		MasterInfoStore.setBaseParam('sort','instNo');
		MasterInfoStore.setBaseParam('dir','asc');
		MasterInfoStore.setBaseParam('Params',gStrParams);
		MasterInfoStore.removeAll();
		MasterInfoStore.load({params:{start:0, limit:Page}});
	}
	


	var SelectBT=new Ext.Toolbar.Button({
		text:$g('选取'),
		tooltip:$g('点击选取'),
		iconCls:'page_goto',
		width:70,
		height:30,
		handler:function(){
			SelectHandler();
		}
	});
	
	function SelectHandler(){
		var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
		if(selectRow==null){
			Msg.info("warning",$g("请选择盘点单!"));
			return;
		}
		var InstId=selectRow.get('inst');
		var inputType=selectRow.get('InputType');
		if(InstId!=null){
			SelectModel(inputType,select);
		}else{
			Msg.info('warning',$g('请选择盘点单!'))
			return;
		}
	}
	
	//保存实盘数据
	function select(selectModel,instwWin){
		var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
		var InstId=selectRow.get('inst');
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==null || PhaLoc==""){
			Msg.info('warning',$g('请选择科室!'));
			return;
		}

		// 跳转到相应的录入界面
		if(selectModel==1){
			window.location.href='dhcst.instktkitmwd.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==2){
			window.location.href='dhcst.instktkitmwd2.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==3){
			window.location.href='dhcst.instktkinput.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}
		else if(selectModel==4){
			window.location.href='dhcst.instktkitmwd4.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}
		else if(selectModel==5||selectModel==6){
			// pda端录入方式仅更新盘点主表的盘点录入方式字段
			var ret=tkMakeServerCall("web.DHCST.INStkTk","UpdateInInStkInputType",InstId,selectModel)
			if(ret==0)
			{
				Msg.info("success", $g("保存移动端盘点方式成功"));
	            Query();
			}
			else if(ret==-1)
			{
				 Msg.info('error',$g("请选择一张盘点单！"));
				 return;
			}
			else if(ret==-2)
			{
				 Msg.info('error',$g("请选择一种移动端盘点录入方式！"));
				 return;
			}
			else if(ret==-3)
			{
				 Msg.info('error',$g("该盘点单已保存过盘点录入方式！"));
				 Query();
			}
			else 
			{
				 Msg.info('error',$g("更新盘点录入方式失败"));
				 return;
			}
		}
	}
	
	
	// 指定列参数
	var fields = ["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb","InputType"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "inst",
				fields : fields
			});
	// 数据集
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : url,
				method : "POST"
			});
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});	
	
	function renderCompFlag(value){
		if(value=='Y'){
			return $g('完成');
		}else{
			return $g('未完成')
		}	
	}
	function renderManaFlag(value){
		if(value=='Y'){
			return $g('管理药');
		}else{
			return $g('非管理药')
		}	
	}
	function renderYesNo(value){
		if(value=='Y'){
			return $g('是');
		}else{
			return $g('否')
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
				header : $g("盘点单号"),
				dataIndex : 'instNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : $g("盘点日期"),
				dataIndex : 'date',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g('盘点时间'),
				dataIndex : 'time',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : $g('盘点人'),
				dataIndex : 'userName',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : $g('账盘完成标志'),
				dataIndex : 'comp',
				width : 50,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : $g('管理药标志'),
				dataIndex : 'manFlag',
				width : 50,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : $g("实盘默认单位"),
				dataIndex : 'freezeUom',
				width : 80,
				align : 'left',
				renderer:function(value){
					if(value==1){
						return $g('入库单位');
					}else{
						return $g('基本单位');
					}
				},
				sortable : true
			}, {
				header : $g("包含不可用"),
				dataIndex : 'includeNotUse',
				width : 50,
				align : 'center',
				renderer:renderYesNo,
				sortable : true
			}, {
				header : $g("仅不可用"),
				dataIndex : 'onlyNotUse',
				renderer:renderYesNo,
				width : 50,
				align : 'center',
				sortable : true
			}, {
				header : $g("类组"),
				dataIndex : 'scgDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("库存分类"),
				dataIndex : 'scDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("开始货位"),
				dataIndex : 'frSb',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : $g("截止货位"),
				dataIndex : 'toSb',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : $g("实盘类型"),
				dataIndex : 'InputType',
				width : 100,
				align : 'right',
				sortable : true,
				renderer:function(value){
					if(value==1){
						return $g("分批次");
					}else if(value==2){
						return $g("按品种");
					}else if(value==5){
						return $g("<font color=blue>移动端:</font>按品种");
					}else if(value==6){
						return $g("<font color=blue>移动端:</font>按批次");
					}else{
						return "";
					}					
				}
			}]);
	MasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : MasterInfoStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : $g('当前记录 {0} -- {1} 条 共 {2} 条记录'),
					emptyMsg : "No results to display",
					prevText : $g("上一页"),
					nextText : $g("下一页"),
					refreshText : $g("刷新"),
					lastText : $g("最后页"),
					firstText : $g("第一页"),
					beforePageText :$g( "当前页"),
					afterPageText : $g("共{0}页"),
					emptyMsg : $g("没有数据")
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
	MasterInfoGrid.on('rowdblclick', function(grid,rowindex,e) {
		SelectHandler();
	});
	
	
		var form = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 400,
			labelAlign : 'right',
			frame : true,
			title:$g('选择盘点单'),
			autoScroll : false,
			bodyStyle : 'padding:5px 0px 0px 0px;',
			tbar:[QueryBT,'-',SelectBT],
			items:[{
					xtype:'fieldset',
					//title:'查询条件',
					layout: 'column',
					style: 'padding:10px 0px 5px 0px;',
					items : [{ 				
						columnWidth: 0.34,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	border: false,
		            	items: [PhaLoc]
						
					},{ 				
						columnWidth: 0.33,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	border: false,
		            	items: [StartDate]
						
					},{ 				
						columnWidth: 0.33,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	border: false,
		            	items: [EndDate]
						
					}]
				}]  	
		});
	
		// 5.2.页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [{
		                		region:'north',
		                		height:140,
		                		layout:'fit',
		                		items:[form ]
		                	},{
		                		region:'center',
		                		layout:'fit',
		                		items:[MasterInfoGrid]
		                	}],
					renderTo : 'mainPanel'
		});
		
	//自动加载盘点单
	Query();
})