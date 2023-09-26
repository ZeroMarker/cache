// /名称: 盘点单查询
// /描述: 盘点单查询
// /编写者：zhangdongmei
// /编写日期: 2012.09.03

//保存参数值的object
var InStkTkParamObj = GetAppPropValue('DHCSTINSTKTKM')

Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId="";
	var url=DictUrl+'instktkaction.csp';
	var gGroupId=session["LOGON.GROUPID"];
	
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '科室',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				width : 140,
				emptyText : '科室...',
				groupId:gGroupId
			});
	
	var Complete=new Ext.form.Checkbox({
		fieldLabel:'账盘完成',
		id:'Complete',
		name:'Complete',
		width:80,
		disabled:false
	});
	
	var TkComplete=new Ext.form.Checkbox({
		fieldLabel:'实盘完成',
		id:'TkComplete',
		name:'TkComplete',
		width:80,
		disabled:false
	});
	
	var AdjComplete=new Ext.form.Checkbox({
		fieldLabel:'调整完成',
		id:'AdjComplete',
		name:'AdjComplete',
		width:80,
		disabled:false
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
		var CompFlag=(Ext.getCmp('Complete').getValue()==true?'Y':'');
		var TkComplete=(Ext.getCmp('TkComplete').getValue()==true?'Y':'');;  //实盘完成标志
		var AdjComplete=(Ext.getCmp('AdjComplete').getValue()==true?'Y':'');;	//调整完成标志
		var Page=GridPagingToolbar.pageSize;
		var StrParams=PhaLoc+'^'+StartDate+'^'+EndDate+'^'+CompFlag+'^'+TkComplete+'^'+AdjComplete;
		MasterInfoStore.setBaseParam('actiontype','Query');
		MasterInfoStore.setBaseParam('Params',StrParams);
		MasterInfoStore.load({params:{start:0, limit:Page,sort:'instNo',dir:'asc'}});
		InstDetailGrid.store.removeAll();
		InstDetailGrid.getView().refresh();
	}
	
	// 清空按钮
	var RefreshBT = new Ext.Toolbar.Button({
				text : '清空',
				tooltip : '点击清空',
				iconCls : 'page_clearscreen',
				width : 70,
				height : 30,
				handler : function() {
					clearData();
				}
	});
   // 打印盘点单按钮
		var PrintBT = new Ext.Toolbar.Button({
					id : "PrintBT",
					text : '打印',
					tooltip : '点击打印盘点单',
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
					var record=MasterInfoGrid.getSelectionModel().getSelected();
					if(record){
					var Rowid=record.get('inst');
					//0:全部,1:仅盘盈,2:仅盘亏,3:仅无损益,4:仅有损益
					var statFlag=0;
					if(Ext.getCmp("onlySurplus").getValue()==true){
						statFlag=1;
					}else if(Ext.getCmp("onlyLoss").getValue()==true){
						statFlag=2;
					}else if(Ext.getCmp("onlyBalance").getValue()==true){
						statFlag=3;
					}else if(Ext.getCmp("onlyNotBalance").getValue()==true){
						statFlag=4;
					}
					
					PrintINStkQuery(Rowid,statFlag);
					}
					}
				});
	/**
	 * 清空方法
	 */
	function clearData() {
		
		gStrParams='';
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("Complete").setValue(false);
		Ext.getCmp("TkComplete").setValue(false);
		Ext.getCmp("AdjComplete").setValue(false);
		Ext.getCmp("all").setValue(true);
		Ext.getCmp("InciDesc").setValue("");
		gIncId="";
		MasterInfoGrid.store.removeAll();
		InstDetailGrid.store.removeAll(); 
		InstDetailGrid.getView().refresh();
	}

	// 指定列参数
	var fields = ["inst","instNo", "date", "time","userName","status","locDesc", "comp", "stktkComp",
			"adjComp","adj","manFlag","freezeUom","includeNotUse","onlyNotUse","scgDesc","scDesc","frSb","toSb","HighValueFlag"];
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
				header : '帐盘完成标志',
				dataIndex : 'comp',
				width : 100,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : '实盘完成标志',
				dataIndex : 'stktkComp',
				width : 100,
				align : 'center',
				renderer:renderCompFlag,
				sortable : true
			}, {
				header : '调整完成标志',
				dataIndex : 'adjComp',
				width : 100,
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
				align : 'left',
				renderer:renderYesNo,
				sortable : true
			}, {
				header : "仅不可用",
				dataIndex : 'onlyNotUse',
				renderer:renderYesNo,
				width : 60,
				align : 'right',
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
			}, {
				header : "高值标志",
				dataIndex : 'HighValueFlag',
				width : 100,
				align : 'right',
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
					emptyMsg : "没有数据"
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
	
	MasterInfoGrid.on('rowclick',function(grid,rowindex,e){
		INStkTkFilter();
//		var selectRow=MasterInfoStore.getAt(rowindex);
//		var Rowid=selectRow.get('inst');
//		var size=StatuTabPagingToolbar.pageSize;
//		if(Ext.getCmp("InciDesc").getValue()==""){
//			gIncId="";
//		}
//		//0:全部,1:仅盘盈,2:仅盘亏,3:仅无损益,4:仅有损益
//		var statFlag=0;
//		if(Ext.getCmp("onlySurplus").getValue()==true){
//			statFlag=1;
//		}else if(Ext.getCmp("onlyLoss").getValue()==true){
//			statFlag=2;
//		}else if(Ext.getCmp("onlyBalance").getValue()==true){
//			statFlag=3;
//		}else if(Ext.getCmp("onlyNotBalance").getValue()==true){
//			statFlag=4;
//		}
//		InstDetailStore.setBaseParam('actiontype','QueryDetail');
//		InstDetailStore.setBaseParam('Parref',Rowid);
//		InstDetailStore.setBaseParam('Params',statFlag+"^"+gIncId);
//		InstDetailStore.load({params:{start:0,limit:size,sort:'desc',dir:'ASC'}});
	});
			
	var nm = new Ext.grid.RowNumberer();
	var InstDetailGridCm = new Ext.grid.ColumnModel([nm, {
				header : "rowid",
				dataIndex : 'rowid',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header:"inclb",
				dataIndex:'inclb',
				width:80,
				align:'left',
				sortable:true,
				hidden:true				
			},{
				header : '物资代码',
				dataIndex : 'code',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "物资名称",
				dataIndex : 'desc',
				width : 200,
				align : 'left',
				sortable : true
			}, {
				header : "规格",
				dataIndex : 'spec',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header:'批号',
				dataIndex:'batchNo',
				width:80,
				align:'left',
				sortable:true
			}, {
				header:'效期',
				dataIndex:'expDate',
				width:100,
				align:'left',
				sortable:true
			}, {
				header : "单位",
				dataIndex : 'uomDesc',
				width : 60,
				align : 'left',
				sortable : true
			}, {
				header : '冻结数量',
				dataIndex : 'freQty',
				width : 80,
				align : 'right',
				sortable : true
			},{
				header:'实盘数量',
				dataIndex:'countQty',
				width:80,
				align:'right',
				sortable:true				
			},{
				header : "厂商",
				dataIndex : 'manf',
				width : 100,
				align : 'left',
				sortable : true
			},{
				header:'账盘日期',
				dataIndex:'freDate',
				width:80,
				align:'left',
				sortable:true
			},{
				header:'账盘时间',
				dataIndex:'freTime',
				width:80,
				align:'left',
				sortable:true
			},{
				header:'实盘日期',
				dataIndex:'countDate',
				width:80,
				align:'left',
				sortable:true
			},{
				header : "实盘时间",
				dataIndex : 'countTime',
				width : 80,
				align : 'left',
				sortable : true
			},{
				header:'实盘人',
				dataIndex:'countPersonName',
				width:80,
				align:'left',
				sortable:true
			}]);
	InstDetailGridCm.defaultSortable = true;

	// 数据集
	var InstDetailStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
					url : url,
					method : "POST"
				}),
				reader :  new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "instw",
					fields : ["rowid","inclb", "inci", "code", "desc","spec", "manf", "batchNo", "expDate",
							"freQty", "uom", "uomDesc", "countQty","freDate","freTime",
							"countDate","countTime","countPersonName","variance","sp","rp","freezeSpAmt","freezeRpAmt","countSpAmt",
							"countRpAmt","varianceSpAmt","varianceRpAmt"]
				}),
				remoteSort:true,
				baseParams:{Parref:'',Params:''}
	});

	var StatuTabPagingToolbar = new Ext.PagingToolbar({
				store : InstDetailStore,
				pageSize : PageSize,
				displayInfo : true
			});
	
	var InciDesc = new Ext.form.TextField({
					fieldLabel : '物资名称',
					id : 'InciDesc',
					name : 'InciDesc',
					//anchor : '90%',
					width : 140,
					listeners : {
						specialkey : function(field, e) {
							var keyCode=e.getKey();
							if ( keyCode== Ext.EventObject.ENTER) {
								GetPhaOrderInfo(field.getValue(),'');
							}
						}
					}
				});

				/**
		 * 调用物资窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stktype, App_StkTypeCode, "", "N", "0", "",getDrugList);
			}
		}
		
		/**
		 * 返回方法
		 */
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			gIncId = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(inciDesc);		
		}
	
	var Filter = new Ext.Toolbar.Button({
		id:'Filter',
		name:'Filter',
		text:'筛选',
		iconCls:'page_find',
		handler:function(){
				INStkTkFilter();			
			}
	});
	
	function INStkTkFilter(){
		var record=MasterInfoGrid.getSelectionModel().getSelected();
		if(record){
			var Rowid=record.get('inst');
			var size=StatuTabPagingToolbar.pageSize;
			
			var inciDesc = Ext.getCmp("InciDesc").getValue();
			if (inciDesc == "" || inciDesc == null){
				gIncId="";
			}
			if(gIncId!=""&gIncId!=null){
				inciDesc="";
			}
			//0:全部,1:仅盘盈,2:仅盘亏,3:仅无损益,4:仅有损益
			var statFlag=0;
			if(Ext.getCmp("onlySurplus").getValue()==true){
				statFlag=1;
			}else if(Ext.getCmp("onlyLoss").getValue()==true){
				statFlag=2;
			}else if(Ext.getCmp("onlyBalance").getValue()==true){
				statFlag=3;
			}else if(Ext.getCmp("onlyNotBalance").getValue()==true){
				statFlag=4;
			}
			
			InstDetailStore.setBaseParam('actiontype','QueryDetail');
			InstDetailStore.setBaseParam('Parref',Rowid);
			InstDetailStore.setBaseParam('Params',statFlag+"^"+gIncId+"^"+inciDesc);
			InstDetailStore.setBaseParam('sort','desc');
			InstDetailStore.setBaseParam('dir','ASC');
			InstDetailStore.removeAll();
			InstDetailStore.load({params:{start:0,limit:size}});
			
			var qPar = '',Others = '';	//2016-06-16 不过滤明细
			var InstNo = record.get('instNo'), LocDesc = '', InstDate = record.get('date'), InstTime = record.get('time');
			p_URL = PmRunQianUrl+'?reportName=DHCSTM_INStkTk_GroupInci.raq'
				+"&Inst="+Rowid+"&qPar="+qPar+"&Others="+Others
				+"&InstNo="+InstNo+"&LocDesc="+LocDesc+"&InstDate="+InstDate+"&InstTime="+InstTime+"&HospDesc="+App_LogonHospDesc
			var reportFrame=document.getElementById("frameInstktkInciPanel");
			if(reportFrame){
				reportFrame.src=p_URL;
			}
		}
	}
	
	var InstDetailGrid = new Ext.ux.GridPanel({
				id:'InstDetailGrid',
				region : 'center',
				cm : InstDetailGridCm,
				store : InstDetailStore,
				trackMouseOver : true,
				stripeRows : true,
				title:'明细',
				sm : new Ext.grid.RowSelectionModel(),
				loadMask : true,
				bbar : StatuTabPagingToolbar,
				tbar:[
				{xtype:'radio',boxLabel:'仅盘盈',name:'loss',id:'onlySurplus',inputValue:1},
				{xtype:'radio',boxLabel:'仅盘亏',name:'loss',id:'onlyLoss',inputValue:2},
				{xtype:'radio',boxLabel:'仅无损益',name:'loss',id:'onlyBalance',inputValue:3},
				{xtype:'radio',boxLabel:'仅有损益',name:'loss',id:'onlyNotBalance',inputValue:4},
				{xtype:'radio',boxLabel:'全部',name:'loss',inputValue:0,id:'all',checked:true},
				{xtype:'displayfield',width:20},
				"物资名称:",InciDesc,
				Filter
				]
			});
	   
		var form = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 400,
			labelAlign : 'right',
			frame : true,
			//bodyStyle : 'padding:10px 0px 0px 0px;',
			style: 'padding:0 0 0 0;',
			tbar:[QueryBT,'-',RefreshBT,'-',PrintBT],
			items:[{
					xtype:'fieldset',
					title:'查询条件',
					style: 'padding:5px 0 0 0;',
					defaults:{width:160},
					items : [PhaLoc,StartDate,EndDate,Complete,TkComplete,AdjComplete]				
					
				}]  	
		});
		
		var InstktkInciPanel = new Ext.Panel({
			title : '按品种汇总',
			autoScroll:true,
			layout:'fit',
			html:'<iframe id="frameInstktkInciPanel" height="100%" width="100%" src="../scripts/dhcmed/img/logon_bg2.jpg"/>'
		});
		
		var InstkTab = new Ext.TabPanel({
			activeTab : 0,
			items : [InstDetailGrid, InstktkInciPanel],
			listeners : {
				'tabchange' : function(tabpanel,panel){
					INStkTkFilter();
				}
			}
		});
		
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [{
			                region: 'west',
			                split: true,
			                collapsible: true, 
			                title:'盘点单(损益)查询',
                			width: 300,  
                			minSize:250,
                			maxSize:400,              			
			                layout: 'border', // specify layout manager for items
			                items: [{
				                region: 'north',
				                split: false,
	                			height: 245,                			
				                layout: 'fit', // specify layout manager for items
				                items: form 				               
				            },{
			                	region:'center',
			                	layout:'fit',
			                	items:MasterInfoGrid 
			                }]
			            }, {
			                region: 'center',	              
		                	layout:'fit',
		                	items:[InstkTab]		                	
			            }
	       			],
					renderTo : 'mainPanel'
		});
		
})