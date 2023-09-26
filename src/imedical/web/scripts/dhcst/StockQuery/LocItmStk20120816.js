// /名称: 库存查询
// /描述: 库存查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.06
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId='';
	var gStrParam='';
	ChartInfoAddFun();
	// 登录设置默认值
	SetLogInDept(PhaDeptStore, "PhaLoc");
	
	function ChartInfoAddFun() {
		var PhaLoc = new Ext.form.ComboBox({
					fieldLabel : '药房',
					id : 'PhaLoc',
					name : 'PhaLoc',
					//anchor : '95%',
					width : 140,
					store : PhaDeptStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : false,
					triggerAction : 'all',
					emptyText : '药房...',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : ''
				});

		var DateTime = new Ext.form.DateField({
					fieldLabel : '日期',
					id : 'DateTime',
					name : 'DateTime',
					//anchor : '95%',
					format : 'Y-m-d',
					width : 140,
					value : new Date()
				});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:"G",     //标识类组类型
			width : 140
		}); 

		StkGrpType.on('select', function(e) {
			Ext.getCmp('DHCStkCatGroup').setValue("");
			StkCatStore.proxy = new Ext.data.HttpProxy({
				url : 'dhcst.drugutil.csp?actiontype=StkCat&StkGrpId='+ Ext.getCmp('StkGrpType').getValue()+ '&start=0&limit=999'
			});
			StkCatStore.reload();
		});
		
		var TypeStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['0', '全部'], ['1', '库存为零'], ['2', '库存为正'],
							['3', '库存为负']]
				});
		var Type = new Ext.form.ComboBox({
					fieldLabel : '类型',
					id : 'Type',
					name : 'Type',
					width : 140,
					store : TypeStore,
					triggerAction : 'all',
					mode : 'local',
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					editable : false,
					valueNotFoundText : ''
				});
		Ext.getCmp("Type").setValue("0");

		var InciDesc = new Ext.form.TextField({
					fieldLabel : '药品名称',
					id : 'InciDesc',
					name : 'InciDesc',
					//anchor : '90%',
					width : 140,
					listeners : {
						specialkey : function(field, e) {
							if (e.getKey() == Ext.EventObject.ENTER) {
								GetPhaOrderInfo();
							}
						}
					}
				});

				/**
		 * 调用药品窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stktype) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stktype, "G", "", "N", "0", "",getDrugList);
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
		}

		var ImportStore = new Ext.data.SimpleStore({
					fields : ['RowId', 'Description'],
					data : [['国产', '国产'], ['进口', '进口'], ['合资', '合资']]
				});
		var INFOImportFlag = new Ext.form.ComboBox({
					fieldLabel : '进口标志',
					id : 'INFOImportFlag',
					name : 'INFOImportFlag',
					anchor : '90%',
					width : 140,
					store : ImportStore,
					valueField : 'RowId',
					displayField : 'Description',
					mode : 'local',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					listWidth : 150,
					forceSelection : true
				});
		
		var DHCStkCatGroup = new Ext.form.ComboBox({
					fieldLabel : '库存分类',
					id : 'DHCStkCatGroup',
					name : 'DHCStkCatGroup',
					anchor : '90%',
					width : 140,
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					valueNotFoundText : ''
				});

		// 药学大类
		var PhcCat = new Ext.form.ComboBox({
					fieldLabel : '药学大类',
					id : 'PhcCat',
					name : 'PhcCat',
					anchor : '90%',
					width : 140,
					store : PhcCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : '',
					enableKeyEvents : true,
					listeners : {
						'beforequery' : function(e) {
							refill(PhcCatStore, "PHCCat", Ext.getCmp('PhcCat')
											.getRawValue());
						}
					}
				});

		// 根据输入值过滤
		function refill(store, type, filter) {
			var url = "";
			if (type == "PHCCat") {
				store.reload({
						params : {
							start : 0,
							limit : 20,
							PhccDesc:filter
						}
				});
			} else if (type == "PHCForm") {
					store.reload({
						params : {
							start : 0,
							limit : 20,
							PHCFDesc:filter
						}
					});
			} else if (type == "PhManufacturer") {
					store.reload({
						params : {
							start : 0,
							limit : 20,
							PHMNFName:filter
						}
					});
			}else if(type=="ArcItemCat"){
				store.reload({
						params : {
							start : 0,
							limit : 20,
							Desc:filter
						}
					});
			}
		}

		PhcCat.on('select', function(e) {
			Ext.getCmp('PhcSubCat').setValue("");
			Ext.getCmp('PhcMinCat').setValue("");
			PhcSubCatStore.proxy = new Ext.data.HttpProxy({
						url : DictUrl
								+ 'drugutil.csp?actiontype=PhcSubCat&PhcCatId='
								+ Ext.getCmp('PhcCat').getValue()
								+ '&start=0&limit=999'
					});
			PhcSubCatStore.reload();
		});

		// 药学子类
		var PhcSubCat = new Ext.form.ComboBox({
					fieldLabel : '药学子类',
					id : 'PhcSubCat',
					name : 'PhcSubCat',
					anchor : '90%',
					width : 140,
					store : PhcSubCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : ''
				});

		PhcSubCat.on('select', function(e) {
			Ext.getCmp('PhcMinCat').setValue("");
			PhcMinCatStore.proxy = new Ext.data.HttpProxy({
						url : DictUrl
								+ 'drugutil.csp?actiontype=PhcMinCat&PhcSubCatId='
								+ Ext.getCmp('PhcSubCat').getValue()
								+ '&start=0&limit=999'
					});
			PhcMinCatStore.reload();
		});

		// 药学小类
		var PhcMinCat = new Ext.form.ComboBox({
					fieldLabel : '药学小类',
					id : 'PhcMinCat',
					name : 'PhcMinCat',
					anchor : '90%',
					width : 140,
					store : PhcMinCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : ''
				});

		var ARCItemCat = new Ext.form.ComboBox({
					fieldLabel : '医嘱子类',
					id : 'ARCItemCat',
					name : 'ARCItemCat',
					anchor : '90%',
					width : 140,
					store : ArcItemCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					listWidth : 150,
					pageSize : 20,
					valueNotFoundText : '',
					listeners : {
						'beforequery' : function(e) {
							refill(ArcItemCatStore, "ArcItemCat", Ext.getCmp('ARCItemCat')
											.getRawValue());
						}
					}
				});

		var PHCDFPhcDoDR = new Ext.form.ComboBox({
					fieldLabel : '管制分类',
					id : 'PHCDFPhcDoDR',
					name : 'PHCDFPhcDoDR',
					anchor : '90%',
					width : 140,
					store : PhcPoisonStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					valueNotFoundText : ''
				});

		var PhManufacturer = new Ext.form.ComboBox({
					fieldLabel : '生产厂商',
					id : 'PhManufacturer',
					name : 'PhManufacturer',
					anchor : '90%',
					width : 140,
					store : PhManufacturerStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : '',
					enableKeyEvents : true,
					listeners : {
						'beforequery' : function(e) {
							refill(PhManufacturerStore, "PhManufacturer", Ext
											.getCmp('PhManufacturer')
											.getRawValue());
						}
					}
				});

		var PHCDOfficialType = new Ext.form.ComboBox({
					fieldLabel : '医保类别',
					id : 'PHCDOfficialType',
					name : 'PHCDOfficialType',
					anchor : '90%',
					width : 140,
					store : OfficeCodeStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					valueNotFoundText : ''
				});

		var PHCForm = new Ext.form.ComboBox({
					fieldLabel : '剂型',
					id : 'PHCForm',
					name : 'PHCForm',
					anchor : '90%',
					width : 140,
					store : PhcFormStore,
					valueField : 'RowId',
					displayField : 'Description',
					allowBlank : true,
					triggerAction : 'all',
					selectOnFocus : true,
					forceSelection : true,
					minChars : 1,
					pageSize : 20,
					listWidth : 250,
					valueNotFoundText : '',
					enableKeyEvents : true,
					listeners : {
						'beforequery' : function(e) {
							refill(PhcFormStore, "PHCForm", Ext
											.getCmp('PHCForm').getRawValue());
						}
					}
				});		

		var ManageDrug = new Ext.form.Checkbox({
					fieldLabel : '管理药',
					id : 'ManageDrug',
					name : 'ManageDrug',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false
				});


		var UseFlag = new Ext.form.Checkbox({
					fieldLabel : '仅在用品种',
					id : 'UseFlag',
					name : 'UseFlag',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false
				});

		var NotUseFlag = new Ext.form.Checkbox({
					fieldLabel : '仅不可用品种',
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					anchor : '90%',
					width : 100,
					height : 10,
					checked : false
				});


		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : '查询',
					tooltip : '点击查询',
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						searchData();
					}
				});

		/**
		 * 查询方法
		 */
		function searchData() {
			// 必选条件
			var phaLoc = Ext.getCmp("PhaLoc").getValue();
			if (phaLoc == null || phaLoc.length <= 0) {
				Msg.info("warning", "药房不能为空！");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var date = Ext.getCmp("DateTime").getValue().format('Y-m-d')
					.toString();
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var StockType = Ext.getCmp("Type").getValue();
			if (date == null || date.length <= 0) {
				Msg.info("warning", "日期不能为空！");
				Ext.getCmp("DateTime").focus();
				return;
			}
			if (StkGrpRowId == null || StkGrpRowId.length <= 0) {
				Msg.info("warning", "类组不能为空！");
				Ext.getCmp("StkGrpType").focus();
				return;
			}
			if (StockType == null || StockType.length <= 0) {
				Msg.info("warning", "类型不能为空！");
				Ext.getCmp("Type").focus();
				return;
			}
			// 可选条件
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var PhcCatList = "";
			var PhcCat = Ext.getCmp("PhcCat").getValue();
			var PhcSubCat = Ext.getCmp("PhcSubCat").getValue();
			var PhcMinCat = Ext.getCmp("PhcMinCat").getValue();
			var ARCItemCat = Ext.getCmp("ARCItemCat").getValue();
			var PHCDFPhcDoDR = Ext.getCmp("PHCDFPhcDoDR").getValue();
			var PhManufacturer = Ext.getCmp("PhManufacturer").getValue();
			var PHCDOfficialType = Ext.getCmp("PHCDOfficialType").getValue();
			var PHCForm = Ext.getCmp("PHCForm").getValue();
			var ManageDrug = Ext.getCmp("ManageDrug").getValue();
			var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();
			
			gStrParam=phaLoc+"^"+date+"^"+StkGrpRowId+"^"+StockType+"^"+gIncId
			+"^"+ImpFlag+"^"+DHCStkCatGroup+"^"+PhcCat+"^"+PhcSubCat+"^"+PhcMinCat
			+"^"+ARCItemCat+"^"+PHCDFPhcDoDR+"^"+PhManufacturer+"^"+PHCDOfficialType
			+"^"+PHCForm+"^"+ManageDrug+"^"+UseFlag+"^"+NotUseFlag;
			
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize,Params:gStrParam}});

		}

		function manFlagRender(value){
			if(value==1){
				return '管理药'	;		
			}else{
				return '非管理药';
			}
		}
				
		// 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : '清空',
					tooltip : '点击清空',
					iconCls : 'page_refresh',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		/**
		 * 清空方法
		 */
		function clearData() {
			gStrParam='';
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("PhcCat").setValue('');
			Ext.getCmp("PhcSubCat").setValue('');
			Ext.getCmp("PhcMinCat").setValue('');
			Ext.getCmp("ARCItemCat").setValue('');
			Ext.getCmp("PHCDFPhcDoDR").setValue('');
			Ext.getCmp("PhManufacturer").setValue('');
			Ext.getCmp("PHCDOfficialType").setValue('');
			Ext.getCmp("PHCForm").setValue('');
			Ext.getCmp("ManageDrug").setValue(false);
			Ext.getCmp("UseFlag").setValue(false);
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("INFOImportFlag").setValue('');
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.CheckboxSelectionModel();
		var StockQtyCm = new Ext.grid.ColumnModel([nm, sm, {
					header : "INCILRowID",
					dataIndex : 'Incil',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '代码',
					dataIndex : 'InciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "名称",
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "货位",
					dataIndex : 'StkBin',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : '库存(包装单位)',
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "包装单位",
					dataIndex : 'PurUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "库存(基本单位)",
					dataIndex : 'StockQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "基本单位",
					dataIndex : 'BUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "库存(单位)",
					dataIndex : 'StkQtyUom',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "零售价",
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : "最新进价",
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					
					sortable : true
				}, {
					header : '售价金额',
					dataIndex : 'SpAmt',
					width : 120,
					align : 'right',
					
					sortable : true
				}, {
					header : '进价金额',
					dataIndex : 'RpAmt',
					width : 120,
					align : 'right',
					
					sortable : true
				}, {
					header : "规格",
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : '产地',
					dataIndex : 'ManfDesc',
					width : 50,
					align : 'left',
					sortable : true
				}, {
					header : "通用名",
					dataIndex : 'Gene',
					width : 50,
					align : 'left',
					sortable : true
				}, {
					header : "医保类别",
					dataIndex : 'OfficalCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "剂型",
					dataIndex : 'Form',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "是否管理药",
					dataIndex : 'ManFlag',
					width : 120,
					align : 'left',
					sortable : true,
					renderer:manFlagRender
				}]);
		StockQtyCm.defaultSortable = true;

		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=LocItmStk&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["Incil", "Inci", "InciCode", "InciDesc",
				"StkBin", "PurUomDesc", "BUomDesc", "PurStockQty",
				"StockQty", "StkQtyUom", "Sp", "SpAmt",
				"Rp", "RpAmt", "Spec", "ManfDesc", "Gene",
				"OfficalCode", "Form", "ManFlag"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Incil",
					fields : fields
				});
		// 数据集
		var StockQtyStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});

		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockQtyStore,
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
						B['Params']=gStrParam;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});

		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : StatuTabPagingToolbar
				});
		function BatchShow() {
			var gridSelected =Ext.getCmp("StockQtyGrid"); 
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'错误',msg:'请选择要查看的药品！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var Incil = selectedRow.get("Incil");
				var Date=Ext.util.Format.date(Ext.getCmp("DateTime").getValue(),'Y-m-d');
				var IncDesc=selectedRow.get("InciDesc");
				var PurUom=selectedRow.get("PurUomDesc");
				var BUom=selectedRow.get("BUomDesc");
				var IncInfo=IncDesc+'         包装单位：'+PurUom+'     基本单位：'+BUom;
				BatchQuery(Incil, Date,IncInfo);								
			}
		}
		function TransShow() {
			var gridSelected =Ext.getCmp("StockQtyGrid"); 
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'错误',msg:'请选择要查看的药品！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var Incil = selectedRow.get("Incil");
				var Date=Ext.util.Format.date(Ext.getCmp("DateTime").getValue(),'Y-m-d');
				var IncDesc=selectedRow.get("InciDesc");
				var PurUom=selectedRow.get("PurUomDesc");
				var BUom=selectedRow.get("BUomDesc");
				var IncInfo=IncDesc+'         包装单位：'+PurUom+'     基本单位：'+BUom;
				TransQuery(Incil, Date,IncInfo);								
			}
		}		/***
		**添加右键菜单,zdm,2012-01-04***
		**/
		//右键菜单代码关键部分 
		function rightClickFn(grid,rowindex,e){ 
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); 
		}
		StockQtyGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mnuBatch', 
					handler: BatchShow, 
					text: '批次信息' 
				},{ 
					id: 'mnuTrans', 
					handler: TransShow, 
					text: '台帐信息' 
				}
			] 
		}); 
		
		var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			region : 'north',
			height : 250,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 1px 1px 5px;',
			tbar : [SearchBT, '-', RefreshBT],			
		    items:[{
						layout : 'column',	
						items : [{
									columnWidth:0.25,
									autoHeight : true,
									height:150,
									xtype: 'fieldset',
									title:'必选条件',	
									defaults: {width: 180, border:false},    // Default config options for child items
									items : [PhaLoc,DateTime,StkGrpType,Type]
								},{
									columnWidth:0.73,
									autoHeight : true,
									
											xtype: 'fieldset',
											title:'可选条件',	
											autoHeight : true,
											border:true,
											bodyStyle:'margin-left:20px',
											style:'margin-left:10px',
											layout : 'column',	
											items : [{
														columnWidth:0.34,
														autoHeight : true,
														xtype: 'fieldset',
														border:false,  
														items : [DHCStkCatGroup,PhcCat,PhcSubCat,PhcMinCat,UseFlag]
													},{
														columnWidth:0.33,
														autoHeight : true,
														xtype: 'fieldset',
														 border:false,  
														items : [INFOImportFlag,ARCItemCat,PHCDFPhcDoDR,PhManufacturer,NotUseFlag]
													},{
														columnWidth:0.33,
														autoHeight : true,
														xtype: 'fieldset',
														border:false,  
														items : [InciDesc,PHCForm,PHCDOfficialType,ManageDrug]
													}]
										
								}]
		    }]	
		});

		// 5.2.页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [HisListTab, StockQtyGrid],
					renderTo : 'mainPanel'
				});
	}
})