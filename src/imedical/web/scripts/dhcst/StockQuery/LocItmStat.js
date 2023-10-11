// /名称: 库存统计
// /描述: 库存统计
// /编写者：gwj
// /编写日期: 2013.03.26
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId='';
	var gStrParam='';
	var gStrParamBatch='';
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}
	ChartInfoAddFun();
	// 登录设置默认值
	SetLogInDept(PhaDeptStore, "PhaLoc");
	
	
	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : $g('科室') ,
					id : 'PhaLoc',
					name : 'PhaLoc',
					anchor : '90%',
					//width : 140,
					groupId:gGroupId,
                    listeners : {
	                    'select' : function(e) {SetDefaultSCG();}
					}
				});
	function SetDefaultSCG()
	{
		 Ext.getCmp("StkGrpType").setValue("");
		 var SelLocId=Ext.getCmp('PhaLoc').getValue();//add wyx 根据选择的科室动态加载类组
         StkGrpType.getStore().removeAll();
         StkGrpType.getStore().setBaseParam("locId",SelLocId)
         StkGrpType.getStore().setBaseParam("userId",UserId)
         StkGrpType.getStore().setBaseParam("type",App_StkTypeCode)
         StkGrpType.getStore().load();
         Ext.getCmp("StkCat").setValue("");
	}
    
		var DateTime = new Ext.ux.DateField({
					fieldLabel : $g('日期') ,
					id : 'DateTime',
					name : 'DateTime',
					anchor : '90%',
					//width : 140,
					value : new Date()
				});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			//width : 140,
			anchor:'90%',
			LocId:gLocId,
			UserId:gUserId,
			fieldLabel : $g('类组') 
		}); 

		StkGrpType.on('select', function() {
			Ext.getCmp("StkCat").setValue("");
		});

		var StkCat = new Ext.ux.ComboBox({
					fieldLabel : $g('库存分类') ,
					id : 'StkCat',
					name : 'StkCat',
					anchor : '90%',
					//listWidth : 250,
					store : StkCatStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{StkGrpId:'StkGrpType'}
		});


		var PhManufacturer = new Ext.ux.ComboBox({
					fieldLabel : $g('生产企业') ,
					id : 'PhManufacturer',
					name : 'PhManufacturer',
					anchor : '90%',
					//width : 140,
					store : PhManufacturerStore,
					valueField : 'RowId',
					displayField : 'Description',
					filterName:'PHMNFName'
		});
	
				
		var LocManGrp=new Ext.ux.ComboBox({
		        fieldLabel :$g( '管理组') ,
		        id : 'LocManGrp',
		        name : 'LocManGrp',
		        anchor : '90%',
		        store : LocManGrpStore,
		        valueField : 'RowId',
		        displayField : 'Description',
		        params:{locId:'PhaLoc'}
    	});
    
		var StkBin = new Ext.ux.ComboBox({
					fieldLabel : $g('货位码') ,
					id : 'StkBin',
					name : 'StkBin',
					anchor : '90%',
					//width : 140,
					store : LocStkBinStore,
					valueField : 'RowId',
					displayField : 'Description',
					params:{LocId:'PhaLoc'},
					filterName:'Desc'
		});

		var ManageDrug = new Ext.form.Checkbox({
					fieldLabel : $g('管理药') ,
					id : 'ManageDrug',
					name : 'ManageDrug',
					anchor : '90%',				
					height : 10,
					checked : false
		});

		//包括零库存
		var UseFlag = new Ext.form.Checkbox({
					//fieldLabel : '包括零库存',
					boxLabel:$g('包括') ,
					hideLabel:true,
					labelWidth:30,
					id : 'UseFlag',
					name : 'UseFlag',
					anchor : '90%',					
					height : 10,
					checked : false
		});
		
		//排除非零库存
		var NotUseFlag = new Ext.form.Checkbox({
					//fieldLabel : '排除非零库存',
					boxLabel:$g('排除') ,
					hideLabel:true,
					id : 'NotUseFlag',
					name : 'NotUseFlag',
					anchor : '90%',					
					height : 10,
					checked : false
		});
				
		var UseTime = new Ext.form.TextField({
				fieldLabel : '',
				id : 'UseTime',
				name : 'UseTime',
				anchor : '80%',
				width : 40,
				hideLabel : true, 
				value : '6'
		});
		
			
		var NotUseTime = new Ext.form.TextField({
				fieldLabel : '',
				id : 'NotUseTime',
				name : 'NotUseTime',
				anchor : '80%',
				width : 40,
				hideLabel : true, 
				value : '6'
		});
    
    // 清空按钮
		var RefreshBT = new Ext.Toolbar.Button({
					text : $g('清屏') ,
					tooltip : $g('点击清屏') ,
					iconCls : 'page_clearscreen',
					width : 70,
					height : 30,
					handler : function() {
						clearData();
					}
				});

		
		 //清空方法
		 
		function clearData() {
			gStrParam='';
			Ext.getCmp("DateTime").setValue(new Date());			
			Ext.getCmp("ManageDrug").setValue(false);
			Ext.getCmp("UseFlag").setValue(false);
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("StkCat").setValue('');
			SetLogInDept(PhaLoc.getStore(), "PhaLoc");
			SetDefaultSCG();
			Ext.getCmp("PhManufacturer").setValue('');
			Ext.getCmp("LocManGrp").setValue('');
			Ext.getCmp("StkBin").setValue('');
			gIncId="";
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
			BatQtyGrid.store.removeAll();
			BatQtyGrid.getView().refresh();
		}
		
		


		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : $g('查询') ,
					tooltip : $g('点击查询') ,
					iconCls : 'page_find',
					width : 70,
					height : 30,
					handler : function() {
						StockQtyGrid.getStore().removeAll();
						searchData();
					}
				});
    
		// 查询方法
		 
		function searchData() {
			
			// 必选条件
			var sphaLoc = Ext.getCmp("PhaLoc").getValue();
			var sphaLocdesc = Ext.getCmp("PhaLoc").getRawValue();
			//wyx add 2014-01-15
			if (sphaLocdesc ==""||sphaLocdesc == null || sphaLoc.length <= 0) {
				Msg.info("warning", $g("科室不能为空！") );
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			if (sphaLoc == null || sphaLoc.length <= 0) {
				Msg.info("warning", $g("科室不能为空！") );
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var datetmp=Ext.getCmp("DateTime").getValue()
			if (datetmp=="") {
				Msg.info("warning", $g("日期不能为空！")) ;
				Ext.getCmp("DateTime").focus();
				return;
				}
			var date = Ext.getCmp("DateTime").getValue().format(App_StkDateFormat).toString();
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			//var StockType = Ext.getCmp("Type").getValue();
			
			if (date == null || date.length <= 0) {
				Msg.info("warning", $g("日期不能为空！")) ;
				Ext.getCmp("DateTime").focus();
				return;
			}
			if ((StkGrpRowId == null || StkGrpRowId.length <= 0)&(gParamCommon[9]=="N")) {
				Msg.info("warning", $g("类组不能为空！")) ;
				Ext.getCmp("StkGrpType").focus();
				return;
			}
			
			
			// 可选条件
			var StkCat = Ext.getCmp("StkCat").getValue();
			var PhcCatList = "";
			//var PhcCat = Ext.getCmp("PhcCat").getValue();
			var ManageDrug = (Ext.getCmp("ManageDrug").getValue()==true?'Y':'N');
			var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			var Phmanid=Ext.getCmp("PhManufacturer").getValue();
			var ManGrpId=Ext.getCmp("LocManGrp").getValue();
			var SBid=Ext.getCmp("StkBin").getValue();
			var MoveMon=Ext.getCmp('UseTime').getValue();
			var NotMoveNon=Ext.getCmp('NotUseTime').getValue();
		
/// 科室id^日期^类组id^厂家id^管理组id^
/// 库位id^是否管理药^零库存^6个月有进出^排除零库存^6个月无进出^
			
			var strParam=sphaLoc+"^"+date+"^"+StkGrpRowId+"^"+Phmanid+"^"+ManGrpId+"^"+SBid+"^"+ManageDrug+"^"+UseFlag+"^"+MoveMon+"^"+NotUseFlag+"^"+NotMoveNon+"^"+StkCat;
			
			StockStatStore.setBaseParam("Params",strParam);
		
			var pageSize=StatuTabPagingToolbar.pageSize;
			
			
			var activeTab=tabPanel.getActiveTab();
			
			if(activeTab.id=="ItmDetail"){
				StockStatStore.load({params:{start:0,limit:pageSize,Sort:'',Dir:'',Params:strParam}});
			}
			else{
				BatStatStore.load({params:{start:0,limit:pageSize,Sort:'',Dir:'',Params:strParam}});
			}
		}

		// 另存按钮
		var SaveAsBT = new Ext.Toolbar.Button({
					text : $g('另存') ,
					tooltip : $g('另存为Excel') ,
					iconCls : 'page_excel',
					width : 70,
					height : 30,
					handler : function() {
						var activeTab=tabPanel.getActiveTab();
						if(activeTab.id=="ItmDetail"){
							ExportAllToExcel(StockQtyGrid);
						}else{
							ExportAllToExcel(BatQtyGrid);
						}
					}
		});
		
		function manFlagRender(value){
			if(value==="1"){
				return $g('管理药') 	;		
			}else if(value==="0"){
				return $g('非管理药') ;
			}else return ""
		}
				
		

		var nm = new Ext.grid.RowNumberer({width:30});
		var sm = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
		var StockQtyCm = new Ext.grid.ColumnModel([{
					header : "INCIRowID",
					dataIndex : 'Inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header :$g( '代码') ,
					dataIndex : 'InciCode',
					width : 100,
					align : 'left',
					sortable : true
					//,
					//renderer:cellMerge
				}, {
					header : $g("名称") ,
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true
					//,
					//renderer:cellMerge
				}, {
					header : $g("货位") ,
					dataIndex : 'StkBin',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g('库存(包装单位)') ,
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'right',
					//hidden:true,
					sortable : true,
					renderer:SetNumber
				}, {
					header :$g( "包装单位") ,
					dataIndex : 'PurUomDesc',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : $g("库存(基本单位)") ,
					dataIndex : 'StockQty',
					width : 100,
					align : 'right',
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("基本单位") ,
					dataIndex : 'BUomDesc',
					width : 40,
					align : 'left',
					sortable : false
				}, /*{
					header : $g("库存(单位)") ,
					dataIndex : 'StkQtyUom',
					width : 100,
					align : 'left',
					sortable : true
				}, */{
					header : $g("零售价") ,
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					sortable : false,
				}, {
					header :$g( "最新进价") ,
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					sortable : false
				}, {
					header : $g('售价金额') ,
					dataIndex : 'SpAmt',
					width : 120,
					align : 'right',
					sortable : false,
				}, {
					header : $g('进价金额') ,
					dataIndex : 'RpAmt',
					width : 120,
					align : 'right',
					sortable : false,
				}, {
					header :$g( "规格") ,
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : $g('生产企业') ,
					dataIndex : 'ManfDesc',
					width : 50,
					align : 'left',
					sortable : false
				},{
					header : $g("是否管理药") ,
					dataIndex : 'ManFlag',
					width : 120,
					align : 'left',
					sortable : false,
					renderer:manFlagRender
				}]);
		StockQtyCm.defaultSortable = true;
    	var myBigTimeout = 900000;  
		// 访问路径
		var DspPhaUrl = DictUrl
					+ 'locitmstataction.csp?actiontype=LocItmStat';
		
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DspPhaUrl,
					method : "POST",
					timeout: myBigTimeout
				});
		// 指定列参数
		var fields = ["Inci","InciCode","InciDesc","BUomDesc","BUomId","StockQty",
		"StkQtyUom","StkBin","PurUomDesc","PurUomId",
	  "PurStockQty","Spec","ManfDesc","Sp","SpAmt","Rp","RpAmt","ManFlag"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inci",
					fields : fields
				});
		
		// 数据集
		var StockStatStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					remoteSort:true,
					baseParams:{
						Params:''
					}
					
				});
				
	  var nmbat = new Ext.grid.RowNumberer({width:30});
		var smbat = new Ext.grid.CheckboxSelectionModel({singleSelect:true});
		var BatQtyCm = new Ext.grid.ColumnModel([{
					header : "Inclb",
					dataIndex : 'Inclb',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : "INCIRowID",
					dataIndex : 'Inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				},{
					header : $g('代码') ,
					dataIndex : 'InciCode',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("名称") ,
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : true
				}, {
					header : $g("货位") ,
					dataIndex : 'StkBin',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("批号") ,
					dataIndex : 'Btno',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : $g("有效期") ,
					dataIndex : 'Expdate',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : $g('库存(包装单位)') ,
					dataIndex : 'PurStockQty',
					width : 100,
					align : 'right',
					//hidden:true,
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("包装单位"), 
					dataIndex : 'PurUomDesc',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : $g("库存(基本单位)") ,
					dataIndex : 'StockQty',
					width : 100,
					align : 'right',
					sortable : true,
					renderer:SetNumber
				}, {
					header : $g("基本单位") ,
					dataIndex : 'BUomDesc',
					width : 40,
					align : 'left',
					sortable : false
				}, /*{
					header :$g( "库存(单位)",
					dataIndex : 'StkQtyUom',
					width : 100,
					align : 'left',
					sortable : true
				},*/ {
					header : $g("零售价") ,
					dataIndex : 'Sp',
					width : 80,
					align : 'right',
					sortable : false,
				}, {
					header : $g("最新进价") ,
					dataIndex : 'Rp',
					width : 80,
					align : 'right',
					sortable : false,
				}, {
					header : $g('售价金额') ,
					dataIndex : 'SpAmt',
					width : 120,
					align : 'right',
					sortable : false
				}, {
					header : $g('进价金额') ,
					dataIndex : 'RpAmt',
					width : 120,
					align : 'right',
					sortable : false,
				}, {
					header : $g('规格') ,
					dataIndex : 'Spec',
					width : 50,
					align : 'left',
					sortable : false
				}, {
					header : $g('生产企业') ,
					dataIndex : 'ManfDesc',
					width : 50,
					align : 'left',
					sortable : false
				},{
					header : $g("批次经营企业") ,
					dataIndex : 'PVenDesc',
					width : 150,
					align : 'left',
					//renderer : Ext.util.Format.usMoney,
					sortable : true
				},  {
					header : $g("是否管理药") ,
					dataIndex : 'ManFlag',
					width : 120,
					align : 'left',
					sortable : false,
					renderer:manFlagRender
				}]);
		BatQtyCm.defaultSortable = true;
				
		// 访问路径
		var BatQtystatUrl = DictUrl
					+ 'locitmstataction.csp?actiontype=LocBatStat&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxybat = new Ext.data.HttpProxy({
					url : BatQtystatUrl,
					method : "POST"
				});
		// 指定列参数
		var batfields = ["Inclb","Inci","InciCode","InciDesc","BUomDesc","BUomId","StockQty",
		"StkQtyUom","StkBin","Btno","Expdate","PurUomDesc","PurUomId",
	  "PurStockQty","Spec","ManfDesc","Sp","SpAmt","Rp","RpAmt","PVenDesc","ManFlag"];
		// 支持分页显示的读取方式
		var readerbat = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inclb",
					fields : batfields
				});		
				
		var BatStatStore = new Ext.data.Store({
					proxy : proxybat,
					reader : readerbat,
					remoteSort:true,
					baseParams:{
						Params:''
					}
					
				});
    
		var StatuTabPagingToolbar = new Ext.PagingToolbar({
					store : StockStatStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : $g('当前记录 {0} -- {1} 条 共 {2} 条记录') ,
					emptyMsg : "No results to display",
					prevText : $g("上一页") ,
					nextText : $g("下一页") ,
					refreshText : $g("刷新") ,
					lastText : $g("最后页") ,
					firstText : $g("第一页") ,
					beforePageText : $g("当前页") ,
					afterPageText :$g( "共{0}页") ,
					emptyMsg : $g("没有数据") 
		});
		
		var StatuTabPagingToolbar2 = new Ext.PagingToolbar({
					store : BatStatStore,
					pageSize : PageSize,
					displayInfo : true,
					displayMsg : $g('当前记录 {0} -- {1} 条 共 {2} 条记录') ,
					emptyMsg : "No results to display",
					prevText : $g("上一页") ,
					nextText :$g( "下一页") ,
					refreshText : $g("刷新") ,
					lastText :$g( "最后页") ,
					firstText :$g( "第一页") ,
					beforePageText : $g("当前页") ,
					afterPageText : $g("共{0}页") ,
					emptyMsg : $g("没有数据") 
		});
    
		var StockQtyGrid = new Ext.grid.GridPanel({
					id:'StockQtyGrid',
					region : 'center',
					cm : StockQtyCm,
					store : StockStatStore,
					trackMouseOver : true,
					stripeRows : true,
					//sm : sm, //new Ext.grid.CheckboxSelectionModel(),
					loadMask : true
					//,
					//bbar : StatuTabPagingToolbar
		});
		
		var BatQtyGrid = new Ext.grid.GridPanel({
					id:'BatQtyGrid',
					region : 'center',
					cm : BatQtyCm,
					store : BatStatStore,
					trackMouseOver : true,
					stripeRows : true,
					//sm : sm, //new Ext.grid.CheckboxSelectionModel(),
					loadMask : true
					//,
					//bbar : StatuTabPagingToolbar2
		});
		
		//合并DetailGridLB中相同的药品信息
function cellMerge(value, meta, record, rowIndex, colIndex, store) {
	var lastRowCode="",lastRowDesc="",lastRowSpec="",lastRowUom="";
	if(rowIndex>0){
		lastRowCode=store.getAt(rowIndex - 1).get("incicode"),lastRowDesc=store.getAt(rowIndex - 1).get("incidesc"),
		lastRowSpec=store.getAt(rowIndex - 1).get("spec"),lastRowUom=store.getAt(rowIndex - 1).get("puomdesc");
	}
	var thisRowCode=store.getAt(rowIndex).get("incicode"),thisRowDesc=store.getAt(rowIndex).get("incidesc"),
	thisRowSpec=store.getAt(rowIndex).get("spec"),thisRowUom=store.getAt(rowIndex).get("puomdesc");
	var nextRowCode="",nextRowDesc="",nextRowSpec="",nextRowUom="";
	if(rowIndex<store.getCount()-1){
		nextRowCode=store.getAt(rowIndex+1).get("incicode"),nextRowDesc=store.getAt(rowIndex+1).get("incidesc"),
		nextRowSpec=store.getAt(rowIndex+1).get("spec"),nextRowUom=store.getAt(rowIndex+1).get("puomdesc");
	}
	
    var first = !rowIndex || (thisRowCode !==lastRowCode)||(thisRowDesc!==lastRowDesc)||(thisRowSpec!==lastRowSpec)||(thisRowUom!==lastRowUom),
    last = rowIndex >= store.getCount() - 1 || (thisRowCode !==nextRowCode)||(thisRowDesc!==nextRowDesc)||(thisRowSpec!==nextRowSpec)||(thisRowUom!==nextRowUom);
    meta.css += 'row-span' + (first ? ' row-span-first' : '') +  (last ? ' row-span-last' : '');
    if (first) {
        var i = rowIndex + 1;
        while (i < store.getCount() && thisRowCode == store.getAt(i).get("incicode")
        &&thisRowDesc==store.getAt(i).get("incidesc")&&thisRowSpec==store.getAt(i).get("spec")&&thisRowUom==store.getAt(i).get("puomdesc")) {
            i++;
        }
        var rowHeight = 25, padding = 6,
            height = (rowHeight * (i - rowIndex) - padding) + 'px';
        meta.attr = 'style="height:' + height + ';line-height:' + height + ';"';
    }
    return first ? value : '';
}
		
		
		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 70,
			width : 300,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 0px 0px 0px;',
			tbar : [SearchBT, '-', RefreshBT, '-', SaveAsBT],
			items : [{
						title:$g('必选条件') ,
						xtype:'fieldset',
						style:'padding:10px 0px 0px 0px',
						items:[PhaLoc,DateTime,StkGrpType]
					},
					StkCat,
					PhManufacturer,
					LocManGrp,StkBin,
				  ManageDrug,
				  {xtype: 'compositefield',align:'middle',items:[UseFlag,UseTime,{xtype:'tbtext',style:'padding-top:3px',text:'个月有进出零库存'}]},
				  {xtype: 'compositefield',items:[NotUseFlag,NotUseTime,{xtype:'tbtext',style:'padding-top:3px',text:'个月无进出非零库存'}]}
//				  {
//				  	items : [{
//							items : [
//							        {xtype: 'compositefield',
//							        	items:[UseFlag,UseTime,{xtype:'tbtext',text:'个月有进出'}]},
//							        {xtype: 'compositefield',items:[NotUseFlag,NotUseTime,{xtype:'tbtext',text:'个月无进出'}]}
//							        ]
//						}]
//				  }
//				  {
//				  	layout : 'column',
//				  	items : [{
//					    	columnWidth : .5,
//							xtype : 'fieldset',
//							items : [UseFlag,NotUseFlag]
//						},{
//							columnWidth : .5,
//							//xtype: 'fieldset',
//							items : [
//							        {xtype: 'compositefield',
//							        	items:[UseTime,{xtype:'tbtext',text:'个月有进出'}]},
//							        {xtype: 'compositefield',items:[NotUseTime,{xtype:'tbtext',text:'个月无进出'}]}
//							        ]
//						}]
//				  }
			 ]  	
		});
		
		var tabPanel=new Ext.TabPanel({
   		activeTab:1,
   		items:[{
   			title:$g('项目明细') ,
   			id:'ItmDetail',
   			layout:'fit',
   			items:[StockQtyGrid]
   		},{
   			title:$g('批次明细') ,
   			id:'BatDetail',
   			layout:'fit',
   			items:[BatQtyGrid]
   		}]
   })
tabPanel.on("afterrender",function(tab){tab.activate(0)})
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
			                title: $g('科室') ,
			                layout: 'fit', // specify layout manager for items
			                items: HisListTab   
			             },{ 
			                	region:'center',
			                	title: $g('库存') ,
			                	layout: 'fit', // specify layout manager for items
			                	items: tabPanel
			            }
	       			],
					renderTo : 'mainPanel'
		});
		
	}
	
})