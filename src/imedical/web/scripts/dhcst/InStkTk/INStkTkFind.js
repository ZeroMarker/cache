// /名称: 查询界面
// /描述: 查询界面
// /编写者：zhangdongmei
// /编写日期: 2012.08.29

function InStkTkSearch(Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gGroupId=session['LOGON.GROUPID'];
	var gStrParamS='';
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
				fieldLabel : '结束日期',
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
					style:"padding:5px 0px 5px 0px",
					items : [{ 				
						columnWidth: 0.3,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	border: false,
		            	items: [PhaLocS]
						
					},{ 				
						columnWidth: 0.2,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	border: false,
		            	items: [StartDateS]
						
					},{ 				
						columnWidth: 0.2,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	border: false,
		            	items: [EndDateS]
						
					},{ 				
						columnWidth: 0.3,
		            	xtype: 'fieldset',
		            	labelWidth: 60,	
		            	border: false,
		            	items: [CompleteS]
						
					}]
				}]
				   // Specifies that the items will now be arranged in columns
				
			});

	// 检索按钮
	var searchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询盘点单信息',
				iconCls : 'page_find',
				height:30,
				width:70,
				handler : function() {
					searchData();
				}
			});

	function searchData() {
		var StartDate = Ext.getCmp("StartDateS").getValue().format(App_StkDateFormat)
				.toString();;
		var EndDate = Ext.getCmp("EndDateS").getValue().format(App_StkDateFormat)
				.toString();
		var PhaLoc = Ext.getCmp("PhaLocS").getValue();	
		if(PhaLoc==""){
			Msg.info("warning", "请选择盘点科室!");
			return;
		}
		if(StartDate==""||EndDate==""){
			Msg.info("warning", "请选择开始日期和截止日期!");
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
		gStrParamS=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
		MasterInfoStore.removeAll();
		MasterInfoStore.load({params:{start:0, limit:Page,sort:'instNo',dir:'asc',Params:gStrParamS}});
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
				text : '清屏',
				tooltip : '点击清屏',
				iconCls : 'page_clearscreen',
				height:30,
				width:70,
				handler : function() {
					clearData();
				}
			});

	function clearData() {
		//Ext.getCmp("PhaLocS").setValue("");
		Ext.getCmp("StartDateS").setValue(new Date());
		Ext.getCmp("EndDateS").setValue(new Date());
		Ext.getCmp("CompleteS").setValue(false);
		MasterInfoGrid.store.removeAll();
		SetLogInDept(Ext.getCmp("PhaLocS").getStore(), 'PhaLocS');
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
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb"];
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
			return '管理药';
		}else{
			return '非管理药'
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
			}, {
				header : '盘点人',
				dataIndex : 'userName',
				width : 70,
				align : 'left',
				sortable : true
			}, {
				header : '账盘完成标志',
				dataIndex : 'comp',
				width : 80,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : '管理药标志',
				dataIndex : 'manFlag',
				width : 80,
				align : 'left',
				renderer:renderManaFlag,
				sortable : true
			}, {
				header : "账盘单位",
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
			}]);
	MasterInfoCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
					store : MasterInfoStore,
					pageSize : PageSize,
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
					emptyMsg : "没有数据",
					doLoad:function(C){
						var B={},
						A=this.getParams();
						B[A.start]=C;
						B[A.limit]=this.pageSize;
						B[A.sort]='Rowid';
						B[A.dir]='desc';
						B['Params']=gStrParamS;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
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
				width : document.body.clientWidth*0.88,
				height : document.body.clientHeight*0.88,
				layout : 'border',
				items : [            // create instance immediately
		            {
		                region: 'north',
		                height: 80, // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:InfoFormS
		            }, {
		                region: 'center',
		                layout: 'fit', // specify layout manager for items
		                items: MasterInfoGrid        
		               
		            }
       			],
				tbar : [searchBT, '-', clearBT, '-', returnBT, '-', closeBT]
			});
	window.show();
	
	window.on('close', function(panel) {
			var selectRows = MasterInfoGrid.getSelectionModel().getSelections();
			if (selectRows.length == 0) {
				//Fn("");
			} else {
				var RowId = selectRows[0].get("inst");				
				Fn(RowId);				
			}
		});

	function returnData() {
		var selectRows = MasterInfoGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning","请选择要返回的盘点单信息！");
		} else {
			
			//getInGrInfoByInGrRowId(InGrRowId, selectRows[0]);
			window.close();
		}
	}
}