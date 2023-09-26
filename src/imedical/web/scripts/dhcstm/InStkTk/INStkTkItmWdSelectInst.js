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
				fieldLabel : '科室',
				id : 'PhaLoc',
				name : 'PhaLoc',
				width : 140,
				emptyText : '科室...',
				groupId:gGroupId
			});
	
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				
				width : 80,
				value : new Date().add(Date.DAY, - 30)
			});

	// 结束日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '结束日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				
				width : 80,
				value : new Date()
			});
	
	// 查询按钮
	var QueryBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询',
				iconCls : 'page_find',
				width : 70,
				height : 30,
				handler : function() {
					Query();
				}
			});

	
	//查询盘点单
	function Query(){
	
		var StartDate = Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT).toString();;
		var EndDate = Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT).toString();
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "请选择盘点科室!");
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "请选择开始日期和截止日期!");
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
		text:'选取',
		tooltip:'点击选取',
		iconCls:'page_add',
		width:70,
		height:30,
		handler:function(){
			SelectHandler();
		}
	});
	
	function SelectHandler(){
		var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
		if(selectRow==null){
			Msg.info("warning","请选择盘点单!");
			return;
		}
		var InstId=selectRow.get('inst');
		var inputType=selectRow.get('InputType');
		if(InstId!=null){
			SelectModel(inputType,select);
		}else{
			Msg.info('warning','请选择盘点单!')
			return;
		}
	}
	
	//保存实盘数据
	function select(selectModel,instwWin){
		var selectRow=MasterInfoGrid.getSelectionModel().getSelected();
		var InstId=selectRow.get('inst');
		var PhaLoc = Ext.getCmp("PhaLoc").getValue();	
		if(PhaLoc==null || PhaLoc==""){
			Msg.info('warning','请选择科室!');
			return;
		}

		// 跳转到相应的录入界面
		if(selectModel==1){
			window.location.href='dhcstm.instktkitmwd.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==2){
			window.location.href='dhcstm.instktkitmwd2.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==3){
			window.location.href='dhcstm.instktkinput.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
		}else if(selectModel==4){
			window.location.href='dhcstm.instktkitmtrack.csp?Rowid='+InstId+'&LocId='+PhaLoc+'&InstwWin='+instwWin;
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
				hidden : true
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
			}, {
				header : '盘点人',
				dataIndex : 'userName',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '帐盘完成标志',
				dataIndex : 'comp',
				width : 50,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : '重点关注标志',
				dataIndex : 'manFlag',
				width : 50,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : "实盘默认单位",
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
				width : 50,
				align : 'center',
				renderer:renderYesNo,
				sortable : true
			}, {
				header : "仅不可用",
				dataIndex : 'onlyNotUse',
				renderer:renderYesNo,
				width : 50,
				align : 'center',
				sortable : true
			}, {
				header : "类组",
				dataIndex : 'scgDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "库存分类",
				dataIndex : 'scDesc',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "开始货位",
				dataIndex : 'frSb',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "截止货位",
				dataIndex : 'toSb',
				width : 100,
				align : 'right',
				sortable : true
			},{
				header : "实盘类型",
				dataIndex : 'InputType',
				width : 100,
				align : 'left',
				sortable : true,
				renderer:function(value){
					if(value=='1'){
						return "分批次";
					}else if(value=='2'){
						return "按品种";
					}else if(value=='3'){
						return "按高值条码";
					}else{
						return value;
					}
				}
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
	MasterInfoGrid.on('rowdblclick', function(grid,rowindex,e) {
		SelectHandler();
	});
	
	
		var form = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 400,
			labelAlign : 'right',
			frame : true,
			title:'选择盘点单',
			bodyStyle : 'padding:10px 0px 0px 0px;',
			style: 'padding:0 0 0 0;',
			tbar:[QueryBT,'-',SelectBT],
			items:[{
					xtype:'fieldset',
					//title:'查询条件',
					layout: 'column',
					bodyStyle: 'padding:0 0 0 0;',
					style: 'padding:5px 5px 5px 5px;',
					items : [{ 				
						columnWidth: 0.34,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	defaults: {width: 180, border:false},    // Default config options for child items
		            	//defaultType: 'textfield',
		            	autoHeight: true,
		            	boderStyle: 'padding:0 0 0 0;',
		            	style: 'padding:0 0 0 0;',
		            	border: false,
		            	//style: {
		                //	"margin-left": "10px", // when you add custom margin in IE 6...
		               	//	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0",  // you have to adjust for it somewhere else
		               	//	"margin-bottom": "10px"
		            	//},
		            	items: [PhaLoc]
						
					},{ 				
						columnWidth: 0.33,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	defaults: {width: 140, border:false},    // Default config options for child items
		            	defaultType: 'textfield',
		            	autoHeight: true,
		            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		            	border: false,
		            	style: 'padding:0 0 0 0;',
		            	//style: {
		                //	"margin-left": "10px", // when you add custom margin in IE 6...
		                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
		            	//},
		            	items: [StartDate]
						
					},{ 				
						columnWidth: 0.33,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	defaults: {width: 140, border:false},    // Default config options for child items
		            	defaultType: 'textfield',
		            	autoHeight: true,
		            	//bodyStyle: Ext.isIE ? 'padding:0 0 5px 15px;' : 'padding:10px 15px;',
		            	border: false,
		            	style: 'padding:0 0 0 0;',
		            	//style: {
		                //	"margin-left": "10px", // when you add custom margin in IE 6...
		                //	"margin-right": Ext.isIE6 ? (Ext.isStrict ? "-10px" : "-13px") : "0"  // you have to adjust for it somewhere else
		            	//},
		            	items: [EndDate]
						
					}]
				}]  	
		});
	
		// 5.2.页面布局
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [{
		                		region:'north',
		                		height:130,
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