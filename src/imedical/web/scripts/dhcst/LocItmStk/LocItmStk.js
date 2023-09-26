// /名称: 库存查询
// /描述: 库存查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.06
Ext.onReady(function() {

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId='';
	var gStrParam='';
	var gStrParamBatch='';
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
		//wyx add参数配置 2013-11-13
	if(gParam.length<1){
		GetParam();  //初始化参数配置
		
	}
	ChartInfoAddFun();

   
	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '药房',
					id : 'PhaLoc',
					name : 'PhaLoc',
					anchor : '90%',
					groupId:gGroupId
				});

		var DateTime = new Ext.ux.DateField({
					fieldLabel : '日期',
					id : 'DateTime',
					name : 'DateTime',
					anchor : '90%',
					format : 'Y-m-d',
					value : new Date()
				});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			anchor : '90%',
			LocId:gLocId,
			UserId:gUserId
		});
		StkGrpType.on('change',function(){
			Ext.getCmp("DHCStkCatGroup").setValue('');
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
					anchor:'90%',
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
					anchor : '90%',
					width : 140,
					listeners : {
						specialkey : function(field, e) {
							var keyCode=e.getKey();
							if ( keyCode== Ext.EventObject.ENTER) {
								var stkgrp=Ext.getCmp("StkGrpType").getValue();
								GetPhaOrderInfo(field.getValue(),stkgrp);
							}
						}
					}
				});

				/**
		 * 调用药品窗体并返回结果
		 */
		function GetPhaOrderInfo(item, stkgrp) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "N", "0", "",getDrugList);
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
			;
			Ext.getCmp("InciDesc").setValue(inciDesc);
			//Ext.getCmp('InciDr').setValue(inciDr);			
			;			
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
		
		var DHCStkCatGroup = new Ext.ux.ComboBox({
					fieldLabel : '库存分类',
					id : 'DHCStkCatGroup',
					name : 'DHCStkCatGroup',
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{StkGrpId:'StkGrpType'}
				});
				
		// 药学大类
		var PhcCat = new Ext.ux.ComboBox({
					fieldLabel : '药学大类',
					id : 'PhcCat',
					name : 'PhcCat',				
					store : PhcCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PhccDesc'
				});
		PhcCat.on('change', function() {
			Ext.getCmp('PhcSubCat').setValue("");
			Ext.getCmp('PhcMinCat').setValue("");
		});

		// 药学子类
		var PhcSubCat = new Ext.ux.ComboBox({
					fieldLabel : '药学子类',
					id : 'PhcSubCat',
					name : 'PhcSubCat',			
					store : PhcSubCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{PhcCatId:'PhcCat'}
				});

		// 药学小类
		var PhcMinCat = new Ext.ux.ComboBox({
					fieldLabel : '药学小类',
					id : 'PhcMinCat',
					name : 'PhcMinCat',		
					store : PhcMinCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{PhcSubCatId:'PhcSubCat'}
				});

		var ARCItemCat = new Ext.ux.ComboBox({
					fieldLabel : '医嘱子类',
					id : 'ARCItemCat',
					name : 'ARCItemCat',
					store : ArcItemCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'Desc'
				});

		var PHCDFPhcDoDR = new Ext.ux.ComboBox({
					fieldLabel : '管制分类',
					id : 'PHCDFPhcDoDR',
					name : 'PHCDFPhcDoDR',
					store : PhcPoisonStore,
					valueField : 'RowId',
					displayField : 'Description'
				});

		var PhManufacturer = new Ext.ux.ComboBox({
					fieldLabel : '厂商',
					id : 'PhManufacturer',
					name : 'PhManufacturer',
					store : PhManufacturerStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PHMNFName'
				});

		var PHCDOfficialType = new Ext.ux.ComboBox({
					fieldLabel : '医保类别',
					id : 'PHCDOfficialType',
					name : 'PHCDOfficialType',
					store : OfficeCodeStore,
					valueField : 'RowId',
					displayField : 'Description'
				});

		var PHCForm = new Ext.ux.ComboBox({
					fieldLabel : '剂型',
					id : 'PHCForm',
					name : 'PHCForm',			
					store : PhcFormStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PHCFDesc'
				});		

		var ManageDrug = new Ext.form.Checkbox({
					fieldLabel : '管理药',
					id : 'ManageDrug',
					name : 'ManageDrug',
					anchor : '90%',				
					height : 10,
					checked : false
				});


		var UseFlag = new Ext.form.Checkbox({
					fieldLabel : '仅在用品种',
					id : 'UseFlag',
					name : 'UseFlag',
					anchor : '90%',					
					height : 10,
					checked : false
				});

		var NotUseFlag = new Ext.form.Checkbox({
					fieldLabel : '仅不可用品种',
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					anchor : '90%',					
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
			var ManageDrug = (Ext.getCmp("ManageDrug").getValue()==true?'Y':'N');
			var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			var ImpFlag=Ext.getCmp("INFOImportFlag").getValue();
			var InciDesc=Ext.getCmp("InciDesc").getValue();
			if(InciDesc==null || InciDesc==""){
				gIncId="";
			}
			//alert("PHCDOfficialType="+PHCDOfficialType)
			var strParam=phaLoc+"^"+date+"^"+StkGrpRowId+"^"+StockType+"^"+gIncId
			+"^"+ImpFlag+"^"+DHCStkCatGroup+"^"+PhcCat+"^"+PhcSubCat+"^"+PhcMinCat
			+"^"+ARCItemCat+"^"+PHCDFPhcDoDR+"^"+PhManufacturer+"^"+PHCDOfficialType
			+"^"+PHCForm+"^"+ManageDrug+"^"+UseFlag+"^"+NotUseFlag;
			
			BatchGrid.store.removeAll();
			StockQtyStore.setBaseParam("Params",strParam);
			StockQtyStore.removeAll();
			var pageSize=StatuTabPagingToolbar.pageSize;
			StockQtyStore.load({params:{start:0,limit:pageSize}});
			StockQtyStore.on('load',function(){
				if (StockQtyStore.getCount()>0){
					StockQtyGrid.getSelectionModel().selectFirstRow();
					StockQtyGrid.getView().focusRow(0);
				}
			});
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
			SetLogInDept(PhaLoc.getStore(),"PhaLoc");
			Ext.getCmp("StkGrpType").getStore().load();
			Ext.getCmp("Type").setValue('0');
			Ext.getCmp("DateTime").setValue(new Date());
			Ext.getCmp("InciDesc").setValue('');
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
			gIncId="";
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
			BatchGrid.store.removeAll();
		}

		// 另存按钮
		var SaveAsBT = new Ext.Toolbar.Button({
					text : '另存',
					tooltip : '另存为Excel',
					iconCls : 'page_save',
					width : 70,
					height : 30,
					handler : function() {
						gridSaveAsExcel(StockQtyGrid);
					}
				});
				
				
		
		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.RowSelectionModel({singleSelect:true});
		var StockQtyCm = new Ext.grid.ColumnModel([nm, {
					header : "INCILRowID",
					dataIndex : 'Incil',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '代码',
					dataIndex : 'InciCode',
					width : 100,
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
					hidden:true,
					sortable : true
				}, {
					header : "包装单位",
					dataIndex : 'PurUomDesc',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : "库存(基本单位)",
					dataIndex : 'StockQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "基本单位",
					dataIndex : 'BUomDesc',
					width : 60,
					align : 'left',
					sortable : false
				}, {
					header : "库存(单位)",
					dataIndex : 'StkQtyUom',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "占用库存",
					dataIndex : 'DirtyQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "可用库存",
					dataIndex : 'AvaQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "在途数",
					dataIndex : 'ReservedQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : "零售价",
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					sortable : false
				}, {
					header : "最新进价",
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					sortable : false
				}, {
					header : '售价金额',
					dataIndex : 'SpAmt',
					width : 120,
					align : 'right',
					sortable : false
				}, {
					header : '进价金额',
					dataIndex : 'RpAmt',
					width : 120,
					align : 'right',
					sortable : false
				}, {
					header : "规格",
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : '产地',
					dataIndex : 'ManfDesc',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : "通用名",
					dataIndex : 'Gene',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : "医保类别",
					dataIndex : 'OfficalCode',
					width : 80,
					align : 'left',
					sortable : false
				}, {
					header : "剂型",
					dataIndex : 'Form',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : "是否管理药",
					dataIndex : 'ManFlag',
					width : 120,
					align : 'left',
					sortable : false,
					renderer:manFlagRender
				}]);
		var GridColSetBT = new Ext.Toolbar.Button({
	      text:'列设置',
          tooltip:'列设置',
          iconCls:'page_gear',
          //	width : 70,
         //	height : 30,
	      handler:function(){
		    GridColSet(StockQtyGrid,"DHCSTLOCITMSTK");
	      }
        });
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
				"OfficalCode", "Form", "ManFlag","DirtyQty","AvaQty","ReservedQty","Gene"];
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
					reader : reader,
					remoteSort:true,
					baseParams:{
						Params:''
					}
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
					emptyMsg : "没有数据"
				});

		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockQtyStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : sm,
					loadMask : true,
					bbar : StatuTabPagingToolbar,
					tbar:[GridColSetBT]
				});
		// 添加表格单击行事件
		StockQtyGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var Incil = StockQtyStore.getAt(rowIndex).get("Incil");
			var Date=Ext.util.Format.date(Ext.getCmp("DateTime").getValue(),'Y-m-d');			
			
			gStrParamBatch=Incil+"^"+Date;
			var pageSize=StatuTabPagingToolbarBatch.pageSize;
			BatchStore.load({params:{start:0,limit:pageSize,Params:gStrParamBatch}});
			
		});
				
		var nm = new Ext.grid.RowNumberer();
		var BatchCm = new Ext.grid.ColumnModel([nm,{
					header : "Inclb",
					dataIndex : 'Inclb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '批号',
					dataIndex : 'BatNo',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "效期",
					dataIndex : 'ExpDate',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : "批次库存",
					dataIndex : 'QtyUom',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "批次占用库存",
					dataIndex : 'DirtyQty',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "批次可用库存",
					dataIndex : 'AvaQty',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : '进价(基本单位)',
					dataIndex : 'BRp',
					width : 100,
					align : 'right',
					//renderer : Ext.util.Format.usMoney,
					sortable : true
				}, {
					header : "进价(包装单位)",
					dataIndex : 'PRp',
					width : 80,
					align : 'right',
					//renderer : Ext.util.Format.usMoney,
					sortable : true
				}, {
					header : "批次供应商",
					dataIndex : 'PVenDesc',
					width : 80,
					align : 'right',
					//renderer : Ext.util.Format.usMoney,
					sortable : true
				}, {
					header : "批次厂商",
					dataIndex : 'PManf',
					width : 80,
					align : 'right',
					//renderer : Ext.util.Format.usMoney,
					sortable : true
				}]);
		BatchCm.defaultSortable = false;
		
		// 访问路径
		var BatchUrl = DictUrl
					+ 'locitmstkaction.csp?actiontype=Batch&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxyBatch = new Ext.data.HttpProxy({
					url : BatchUrl,
					method : "POST"
				});
		// 指定列参数
		var fieldsBatch = ["BatNo", "ExpDate", "QtyUom", "BRp","PRp", "Inclb","DirtyQty","AvaQty","PVenDesc","PManf"];
		// 支持分页显示的读取方式
		var readerBatch = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inclb",
					fields : fieldsBatch
				});
		// 数据集
		var BatchStore = new Ext.data.Store({
					proxy : proxyBatch,
					reader : readerBatch
				});

		var StatuTabPagingToolbarBatch = new Ext.PagingToolbar({
					store : BatchStore,
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
						B['Params']=gStrParamBatch;
						if(this.fireEvent("beforechange",this,B)!==false){
							this.store.load({params:B});
						}
					}
				});
			var BatchGrid = new Ext.grid.GridPanel({
					cm : BatchCm,
					store : BatchStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : StatuTabPagingToolbarBatch					
			});
		
		function TransShow() {
			var gridSelected =Ext.getCmp("StockQtyGrid"); 
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'错误',msg:'请选择要查看的药品！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				var selectedRow = rows[0];
				var Incil = selectedRow.get("Incil");
				var Date=Ext.util.Format.date(Ext.getCmp("DateTime").getValue(),'Y-m-d');
				var IncDesc=selectedRow.get("InciDesc");
				var PurUom=selectedRow.get("PurUomDesc");
				var BUom=selectedRow.get("BUomDesc");
				var IncInfo=IncDesc+'         包装单位：'+PurUom+'     基本单位：'+BUom;
				TransQuery(Incil, Date,IncInfo);								
			}
		}	
		function ClrResQtyAllShow(){		

         // 用户对话框，用一个回调函数处理结果:
                   Ext.Msg.show({
	                 title:'全院在途数清除',
	                 msg:'确定清除全院在途数？',
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    ClrResQtyAll(); 
		                     }
                        
	                     }

	                 });

		}
		function ClrResQtyLocShow(){		
                  var phaLoc = Ext.getCmp("PhaLoc").getValue();
         // 用户对话框，用一个回调函数处理结果:
                   Ext.Msg.show({
	                 title:'科室在途数清除',
	                 msg:'确定清除科室在途数？',
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    ClrResQtyLoc(phaLoc); 
		                     }
	                     }
	                 });

		}
	function ClrResQtyLocInciShow(){		
			var gridSelected =Ext.getCmp("StockQtyGrid"); 
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'错误',msg:'请选择要查看的药品！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				var selectedRow = rows[0];
				var incil = selectedRow.get("Incil");  
         // 用户对话框，用一个回调函数处理结果:
                   Ext.Msg.show({
	                 title:'科室单品在途数清除',
	                 msg:'确定清除科室单品在途数？',
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    ClrResQtyLocInci(incil); 
		                     }
	                     }
	                 });
			}

		}
		function SynInciLocShow(){		
                  var phaLoc = Ext.getCmp("PhaLoc").getValue();
         // 用户对话框，用一个回调函数处理结果:
                   Ext.Msg.show({
	                 title:'科室库存同步',
	                 msg:'确定同步科室库存？',
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    SynInciLoc(phaLoc); 
		                     }
	                     }
	                 });

		}
	function SynInciLocInciShow(){		
			var gridSelected =Ext.getCmp("StockQtyGrid"); 
			var rows=StockQtyGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'错误',msg:'请选择要查看的药品！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				var selectedRow = rows[0];
				var incil = selectedRow.get("Incil");  
         // 用户对话框，用一个回调函数处理结果:
                   Ext.Msg.show({
	                 title:'科室单品库存同步',
	                 msg:'确定同步科室单品库存？',
	                 scope: this,
	                 buttons: Ext.Msg.OKCANCEL,
	                 icon:Ext.MessageBox.QUESTION,
                     fn: function(id){
	                     if (id=='ok'){
		                    SynInciLocInci(incil); 
		                     }
	                     }
	                 });
			}

		}		
		//清除全院在途数函数 wyx 2013-11-12
		function ClrResQtyAll(){
		
		    var url = DictUrl
					+ 'locitmstkaction.csp?actiontype=ClrResQtyAll';
			var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						//params:{IngrNo:IngrNo,MainInfo:MainInfo,ListDetail:ListDetail},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
						
								Msg.info("success", "清除成功!");
								// 重新加载数据
								searchData()

							} else {
								//var ret=jsonData.info;
									Msg.info("error", "清除失败!");
							}
						},
						scope : this
					});
			loadMask.hide();		
		}
		//清除科室在途数函数 wyx 2013-11-12
		function ClrResQtyLoc(phaLoc){
		    var url = DictUrl
					+ 'locitmstkaction.csp?actiontype=ClrResQtyLoc';
			var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{PhaLoc:phaLoc},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "清除成功!");
								// 重新加载数据
								searchData()

							} else {
								//var ret=jsonData.info;
									Msg.info("error", "清除失败!");
							}
						},
						scope : this
					});
			loadMask.hide();		
		}	
		//清除科室单品在途数函数 wyx 2013-11-12
		function ClrResQtyLocInci(incil){
		
		    var url = DictUrl
					+ 'locitmstkaction.csp?actiontype=ClrResQtyLocInci';
			var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{Incil:incil},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "清除成功!");
								// 重新加载数据
								searchData()

							} else {
								//var ret=jsonData.info;
									Msg.info("error", "清除失败!");
							}
						},
						scope : this
					});
			loadMask.hide();		
		}
		//同步科室库存 wyx 2013-11-12
		function SynInciLoc(phaLoc){

		    var url = DictUrl
					+ 'locitmstkaction.csp?actiontype=SynInciLoc';
			var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{PhaLoc:phaLoc},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "同步成功!");
								// 重新加载数据
								//searchData()

							} else {
								//var ret=jsonData.info;
									Msg.info("error", "同步失败!");
							}
						},
						scope : this
					});
			loadMask.hide();		
		}	
		//同步科室单品库存 wyx 2013-11-12
		function SynInciLocInci(incil){
		    var url = DictUrl
					+ 'locitmstkaction.csp?actiontype=SynInciLocInci';
			var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						params:{Incil:incil},
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success", "同步成功!");
								// 重新加载数据
								//searchData()

							} else {
								//var ret=jsonData.info;
									Msg.info("error", "同步失败!");
							}
						},
						scope : this
					});
			loadMask.hide();		
		}
			/***
		**添加右键菜单,zdm,2012-01-04***
		**/
		//右键菜单代码关键部分 
		function rightClickFn(grid,rowindex,e){
			grid.getSelectionModel().selectRow(rowindex);
			e.preventDefault(); 
			rightClick.showAt(e.getXY()); //获取坐标
           
		}
		StockQtyGrid.addListener('rowcontextmenu', rightClickFn);//右键菜单代码关键部分 
		var rightClick = new Ext.menu.Menu({ 
			id:'rightClickCont', 
			items: [ 
				{ 
					id: 'mnuTrans', 
					handler: TransShow, 
					text: '台帐信息',
					click:true,
					hidden:(gParam[0]=='Y'?false:true)
					 
				},{ 
					id: 'mnuClrResQtyAll', 
					handler: ClrResQtyAllShow, 
					text: '全院在途数清除',
					click:true,
					hidden:(gParam[1]=='Y'?false:true)
				},{ 
					id: 'mnuClrResQtyLoc', 
					handler: ClrResQtyLocShow, 
					text: '科室在途数清除',
					click:true,
					hidden:(gParam[2]=='Y'?false:true)
				},{ 
					id: 'mnuClrResQtyLocInci', 
					handler: ClrResQtyLocInciShow, 
					text: '科室单品在途数清除',
					click:true,
					hidden:(gParam[3]=='Y'?false:true) 
				},{ 
					id: 'mnuSynInciLoc', 
					handler: SynInciLocShow, 
					text: '科室库存同步',
					click:true,
					hidden:(gParam[4]=='Y'?false:true)
				},{ 
					id: 'mnumnuSynInciLocInci', 
					handler: SynInciLocInciShow, 
					text: '科室单品库存同步',
					click:true,
					hidden:(gParam[5]=='Y'?false:true) 
				}
			] 
		}); 

		//右键菜单代码关键部分 
		function DirtyQtyShow() {
			var gridSelected =Ext.getCmp("BatchGrid"); 
			var rows=BatchGrid.getSelectionModel().getSelections() ; 
			if(rows.length==0){
				Ext.Msg.show({title:'错误',msg:'请选择要查看的药品批次！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			}else {
				selectedRow = rows[0];
				var Inclb = selectedRow.get("Inclb");
				var rowsInc=StockQtyGrid.getSelectionModel().getSelections() ; 
				var selectedInc = rowsInc[0];
				var IncDesc=selectedInc.get("InciDesc");
				var PurUom=selectedInc.get("PurUomDesc");
				var BUom=selectedInc.get("BUomDesc");
				var IncInfo=IncDesc+'         包装单位：'+PurUom+'     基本单位：'+BUom;
				DirtyQtyQuery(Inclb,IncInfo);								
			}
		}
		function rightClickDirtyQtyFn(grid,rowindex,e){
			grid.getSelectionModel().selectRow(rowindex);
			e.preventDefault(); 
			rightClickDirtyQty.showAt(e.getXY()); 
		}
		BatchGrid.addListener('rowcontextmenu', rightClickDirtyQtyFn);//右键菜单代码关键部分 
		var rightClickDirtyQty = new Ext.menu.Menu({ 
			id:'rightClickDirtyQty', 
			items: [ 
				{ 
					id: 'mnuDirtyQty', 
					handler: DirtyQtyShow, 
					text: '查看占用单据' 
				}
			] 
		}); 
		var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 300,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 0px 0px 0px;',
			tbar : [SearchBT, '-', RefreshBT, '-', SaveAsBT],			   						
			items : [{
						title:'必选条件',
						xtype:'fieldset',
						style:'padding:10px 0px 0px 0px',
						items:[PhaLoc,DateTime,StkGrpType,Type]
					},InciDesc,INFOImportFlag,DHCStkCatGroup,PhcCat,
				PhcSubCat,PhcMinCat,ARCItemCat,PHCDFPhcDoDR,PhManufacturer,PHCDOfficialType,PHCForm,
				ManageDrug,UseFlag,NotUseFlag
			]		   	
		});

		// 5.2.页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'west',
			                split: true,
                			width: 300,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: '库存查询',
			                layout: 'fit', // specify layout manager for items
			                items: HisListTab       
			               
			            }, {             
			                region: 'center',	
			                layout:'border',
			                items:[{
			                	region:'center',
			                	title: '库存',
			                	layout: 'fit', // specify layout manager for items
			                	items: StockQtyGrid    
			                },{
			                	region:'south',
			                	title:'批次信息',
			                	split:true,
			                	height:150,
			                	minSize:100,
			                	maxSize:200,
			                	collapsible:true,
			                	layout:'fit',
			                	items:BatchGrid			                
			                }]             	
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
	}
})