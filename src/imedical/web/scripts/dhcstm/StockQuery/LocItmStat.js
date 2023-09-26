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
	
	ChartInfoAddFun();
	// 登录设置默认值
	SetLogInDept(PhaDeptStore, "PhaLoc");

	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '科室',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '90%',
			groupId:gGroupId,
			stkGrpId : 'StkGrpType',
			childCombo : 'PhManufacturer'
		});
    
		var DateTime = new Ext.ux.DateField({
			fieldLabel : '日期',
			id : 'DateTime',
			name : 'DateTime',
			anchor : '90%',
			
			value : new Date()
		});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,
			anchor:'90%',
			LocId:gLocId,
			UserId:gUserId,
			childCombo : 'StkCat'
		});

		var StkCat = new Ext.ux.ComboBox({
			fieldLabel : '库存分类',
			id : 'StkCat',
			name : 'StkCat',
			anchor : '90%',
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'StkGrpType'}
		});
		
		var TypeStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['0', '全部'], ['1', '库存为零'], ['2', '库存为正'],
					['3', '库存为负'], ['4', '库存非零']]
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
			fieldLabel : '物资名称',
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
		
		var PhManufacturer = new Ext.ux.ComboBox({
			fieldLabel : '厂商',
			id : 'PhManufacturer',
			name : 'PhManufacturer',
			anchor : '90%',
			store : PhManufacturerStore,
			valueField : 'RowId',
			displayField : 'Description',
			filterName:'PHMNFName',
			params : {LocId : 'PhaLoc',ScgId : 'StkGrpType'}
		});
		var Vendor=new Ext.ux.VendorComboBox({
			id : 'Vendor',
			name : 'Vendor'
		});
		var LocManGrp=new Ext.ux.ComboBox({
	        fieldLabel : '管理组',
	        id : 'LocManGrp',
	        name : 'LocManGrp',
	        anchor : '90%',
	        store : LocManGrpStore,
	        valueField : 'RowId',
	        displayField : 'Description',
	        params:{locId:'PhaLoc'}
    	});
    
		var StkBin = new Ext.ux.ComboBox({
			fieldLabel : '货位码',
			id : 'StkBin',
			name : 'StkBin',
			anchor : '90%',
			store : LocStkBinStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{LocId:'PhaLoc'},
			filterName:'Desc'
		});

		var HVFlag = new Ext.form.Checkbox({
			boxLabel : '高值标志',
			hideLabel : true,
			id : 'HVFlag',
			anchor : '90%',
			checked : false
		});
		
		var ManageDrug = new Ext.form.Checkbox({
			boxLabel:'重点关注',
			hideLabel:true,
			id : 'ManageDrug',
			name : 'ManageDrug',
			anchor : '90%',	
			checked : false
		});

		//包括零库存
		var UseFlag = new Ext.form.Checkbox({
			boxLabel:'包括',
			hideLabel:true,
			id : 'UseFlag',
			name : 'UseFlag',
			anchor : '90%',
			checked : true
		});
		
		//排除非零库存
		var NotUseFlag = new Ext.form.Checkbox({
			boxLabel:'排除',
			hideLabel:true,
			id : 'NotUseFlag',
			name : 'NotUseFlag',
			anchor : '90%',	
			checked : false
		});
	
		var UseTime = new Ext.form.TextField({
			id : 'UseTime',
			name : 'UseTime',
			anchor : '80%',
			width : 40,
			hideLabel : true, 
			value : '6'
		});

		var NotUseTime = new Ext.form.TextField({
			id : 'NotUseTime',
			name : 'NotUseTime',
			anchor : '80%',
			width : 40,
			hideLabel : true, 
			value : '6'
		});
		
		function GetPhaOrderInfo(item, stkgrp) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, stkgrp, App_StkTypeCode, "", "", "0", "",getDrugList);
			}
		}
		
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			gIncId = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(inciDesc);
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
		
		 //清空方法
		function clearData() {
			gStrParam='';
			Ext.getCmp("DateTime").setValue(new Date());			
			Ext.getCmp("ManageDrug").setValue(false);
			Ext.getCmp("UseFlag").setValue(false);
			Ext.getCmp("NotUseFlag").setValue(false);
			Ext.getCmp("StkCat").setValue('');
			Ext.getCmp("PhManufacturer").setValue('');
			Ext.getCmp("LocManGrp").setValue('');
			Ext.getCmp("StkBin").setValue('');
			Ext.getCmp("Vendor").setValue('');
			Ext.getCmp("HVFlag").setValue(false);
			gIncId="";
			StockQtyGrid.store.removeAll();
			StockQtyGrid.getView().refresh();
			BatQtyGrid.store.removeAll();
			BatQtyGrid.getView().refresh();
			StockRpQtyGrid.removeAll();
		}

		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '点击查询',
			iconCls : 'page_find',
			width : 70,
			height : 30,
			handler : function() {
				StockQtyGrid.getStore().removeAll();
				ShowReport();
			}
		});
    
		// 查询方法
		function searchData() {
			var sphaLoc = Ext.getCmp("PhaLoc").getValue();
			if (sphaLoc == null || sphaLoc.length <= 0) {
				Msg.info("warning", "科室不能为空！");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var date = Ext.getCmp("DateTime").getValue().format(ARG_DATEFORMAT).toString();
			if (date == null || date.length <= 0) {
				Msg.info("warning", "日期不能为空！");
				Ext.getCmp("DateTime").focus();
				return;
			}
			// 可选条件
			var StockType = Ext.getCmp("Type").getValue();
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var StkCat = Ext.getCmp("StkCat").getValue();
			var InciDesc=Ext.getCmp("InciDesc").getValue();
			var ManageDrug = (Ext.getCmp("ManageDrug").getValue()==true?'Y':'N');
			var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			var Phmanid=Ext.getCmp("PhManufacturer").getValue();
			var ManGrpId=Ext.getCmp("LocManGrp").getValue();
			var SBid=Ext.getCmp("StkBin").getValue();
			var MoveMon=Ext.getCmp('UseTime').getValue();
			var NotMoveNon=Ext.getCmp('NotUseTime').getValue();
			var Ven=Ext.getCmp('Vendor').getValue();
			if(InciDesc==null || InciDesc==""){
				gIncId="";
			}
			if(gIncId!=""&gIncId!=null){
				InciDesc="";
			}
			var HVFlag = Ext.getCmp('HVFlag').getValue()?'Y':'';
			/// 科室id^日期^类组id^厂家id^管理组id^
			/// 库位id^是否关注^零库存^6个月有进出^排除零库存^6个月无进出^			
			var strParam=sphaLoc+"^"+date+"^"+StkGrpRowId+"^"+Phmanid+"^"+ManGrpId
				+"^"+SBid+"^"+ManageDrug+"^"+UseFlag+"^"+MoveMon+"^"+NotUseFlag
				+"^"+NotMoveNon+"^"+StkCat+"^"+Ven+"^"+StockType+"^"+gIncId
				+"^"+InciDesc+"^"+HVFlag;
			var pageSize=StatuTabPagingToolbar.pageSize;
			var activeTab=tabPanel.getActiveTab();
			if(activeTab.id=="ItmDetail"){
				StockStatStore.load({
					params:{start:0,limit:pageSize,sort:'InciDesc',Dir:'',Params:strParam},
					callback:function(r,options,success){
						if(success==false){
							Msg.info("error","查询有误, 请查看日志!");
						}
					}
				});	
			}
			else if (activeTab.id=="BatDetail"){
				BatStatStore.load({
					params:{start:0,limit:pageSize,sort:'InciDesc',Dir:'',Params:strParam},
					callback:function(r,options,success){
						if(success==false){
							Msg.info("error","查询有误, 请查看日志!");
						}
					}
				});
			}else{
				StockRpStatStore.load({
					params:{start:0,limit:pageSize,sort:'InciDesc',Dir:'',Params:strParam},
					callback:function(r,options,success){
						if(success==false){
							Msg.info("error","查询有误, 请查看日志!");
						}
					}
				});	
			}
		}

		// 另存按钮
		var SaveAsBT = new Ext.Toolbar.Button({
			text : '另存',
			tooltip : '另存为Excel',
			iconCls : 'page_save',
			width : 70,
			height : 30,
			handler : function() {
				var activeTab=tabPanel.getActiveTab();
				if(activeTab.id=="ItmDetail"){
					gridSaveAsExcel(StockQtyGrid);
				}else if(activeTab.id=="BatDetail"){
					gridSaveAsExcel(BatQtyGrid);
				}else{
					gridSaveAsExcel(StockRpQtyGrid);
				}
			}
		});

		// 打印
		var PrintBT= new Ext.Toolbar.Button({
		      id : "PrintBT",
		      text : '打印',
		      tooltip : '打印明细',
		      width : 70,
		      height : 30,
		      iconCls : 'page_print',
		      handler : function(){
		      	PrintDetail();
		      }
		});
		function PrintDetail() {
			// 必选条件
			var sphaLoc = Ext.getCmp("PhaLoc").getValue();
			if (sphaLoc == null || sphaLoc.length <= 0) {
				Msg.info("warning", "科室不能为空！");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var date = Ext.getCmp("DateTime").getValue().format(ARG_DATEFORMAT).toString();
			if (date == null || date.length <= 0) {
				Msg.info("warning", "日期不能为空！");
				Ext.getCmp("DateTime").focus();
				return;
			}
			// 可选条件
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			var StkCat = Ext.getCmp("StkCat").getValue();
			var ManageDrug = (Ext.getCmp("ManageDrug").getValue()==true?'Y':'N');
			var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
			var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
			var Phmanid=Ext.getCmp("PhManufacturer").getValue();
			var ManGrpId=Ext.getCmp("LocManGrp").getValue();
			var SBid=Ext.getCmp("StkBin").getValue();
			var MoveMon=Ext.getCmp('UseTime').getValue();
			var NotMoveNon=Ext.getCmp('NotUseTime').getValue();
			var Ven=Ext.getCmp('Vendor').getValue();
			
			var StockType = Ext.getCmp("Type").getValue();
			var InciDesc=Ext.getCmp("InciDesc").getValue();
			if(InciDesc==null || InciDesc==""){
				gIncId="";
			}
			if(gIncId!=""&gIncId!=null){
				InciDesc="";
			}
			var HVFlag = Ext.getCmp('HVFlag').getValue()?'Y':'';
			/// 科室id^日期^类组id^厂家id^管理组id^
			/// 库位id^是否关注^零库存^6个月有进出^排除零库存^6个月无进出^
			
			var strParam=sphaLoc+"^"+date+"^"+StkGrpRowId+"^"+Phmanid+"^"+ManGrpId
			+"^"+SBid+"^"+ManageDrug+"^"+UseFlag+"^"+MoveMon+"^"+NotUseFlag
			+"^"+NotMoveNon+"^"+StkCat+"^"+Ven
			+"^"+StockType+"^"+gIncId+"^"+InciDesc+"^"+HVFlag;
			StockStatStore.setBaseParam("strParam",strParam);
			var pageSize=StatuTabPagingToolbar.pageSize;
			var activeTab=tabPanel.getActiveTab();
			var reportFrame=document.getElementById("frameReport");
			//获取查询条件列表
			var Conditions=""
			if(sphaLoc!=""){
				Conditions="科室: "+Ext.getCmp("PhaLoc").getRawValue()
				}
		   
			if(StkGrpRowId!=""){
				Conditions=Conditions+" 类组: "+Ext.getCmp("StkGrpType").getRawValue()
				}	
			if(StkCat!=""){
				Conditions=Conditions+" 库存分类: "+Ext.getCmp("StkCat").getRawValue()
				}
			if(Phmanid!=""){
				Conditions=Conditions+" 厂商: "+Ext.getCmp("PhManufacturer").getRawValue()
				}	
		
			if(ManGrpId!=""){
				Conditions=Conditions+" 管理组:"+Ext.getCmp("LocManGrp").getRawValue()
				}
			if(SBid!=""){
				Conditions=Conditions+" 货位码: "+Ext.getCmp("StkBin").getRawValue()
				}
		   
				
			if(activeTab.id=="ItmDetail"){
				fileName="{DHCSTM_ItmLocStk.raq(strParam="+strParam+";Conditions="+Conditions+")}";
		        //alert(Conditions)
		        DHCCPM_RQDirectPrint(fileName);
			}else{
			    fileName="{DHCSTM_ItmLocStkItm.raq(strParam="+strParam+";Conditions="+Conditions+")}";
		        
		        DHCCPM_RQDirectPrint(fileName);
			}
			
		}
		
		function manFlagRender(value){
			if(value==1){
				return '是'	;		
			}else if(value==0){
				return '否';
			}
		}
		var nm = new Ext.grid.RowNumberer({width:30});
		var sm = new Ext.grid.CheckboxSelectionModel({/*checkOnly:'true'*/});
		var StockQtyCm = new Ext.grid.ColumnModel([nm, sm, {
				header : "INCIRowID",
				dataIndex : 'Inci',
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
				header : "规格",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : false
			},{
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
				width : 40,
				align : 'left',
				sortable : false
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
			},  {
				header : '厂商',
				dataIndex : 'ManfDesc',
				width : 150,
				align : 'left',
				sortable : false
			}, {
				header : '供应商',
				dataIndex : 'Vendor',
				width :150,
				align : 'left',
				sortable : false
			}, {
				header : "是否重点关注",
				dataIndex : 'ManFlag',
				width : 100,
				align : 'left',
				sortable : false,
				renderer:manFlagRender
		}]);
		StockQtyCm.defaultSortable = true;
    	var myBigTimeout = 900000;  
		// 访问路径
		var DspPhaUrl = DictUrl+ 'locitmstataction.csp?actiontype=LocItmStat';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
			url : DspPhaUrl,
			method : "POST",
			timeout: myBigTimeout
		});
		// 指定列参数
		var fields = ["Inci","InciCode","InciDesc","BUomDesc","BUomId","StockQty",
			"StkQtyUom","StkBin","PurUomDesc","PurUomId","PurStockQty","Spec",
			"ManfDesc","Sp","SpAmt","Rp","RpAmt","ManFlag","Vendor"];
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
			baseParams:{
				Params:''
			}
		});
				
	  	var nmbat = new Ext.grid.RowNumberer({width:30});
		var smbat = new Ext.grid.CheckboxSelectionModel({/*checkOnly:'true'*/});
		var BatQtyCm = new Ext.grid.ColumnModel([nmbat, smbat, {
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
				header : '规格',
				dataIndex : 'Spec',
				width : 50,
				align : 'left',
				sortable : false
			},{
				header : "货位",
				dataIndex : 'StkBin',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "批号",
				dataIndex : 'Btno',
				width : 100,
				align : 'left',
				sortable : false
			}, {
				header : "有效期",
				dataIndex : 'Expdate',
				width : 100,
				align : 'left',
				sortable : false
			}, {
				header : '库存(包装单位)',
				dataIndex : 'PurStockQty',
				width : 100,
				align : 'right',
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
				width : 40,
				align : 'left',
				sortable : false
			}, {
				header : "批次进价",
				dataIndex : 'inclbRp',
				width : 60,
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
			},  {
				header : '厂商',
				dataIndex : 'ManfDesc',
				width : 150,
				align : 'left',
				sortable : false
			}, {
				header : '供应商',
				dataIndex : 'Vendor',
				width : 150,
				align : 'left',
				sortable : false
			}, {
				header : "是否重点关注",
				dataIndex : 'ManFlag',
				width : 100,
				align : 'left',
				sortable : false,
				renderer:manFlagRender
		}]);
		BatQtyCm.defaultSortable = true;
		// 访问路径
		var BatQtystatUrl = DictUrl+ 'locitmstataction.csp?actiontype=LocBatStat&start=&limit=';
		// 通过AJAX方式调用后台数据
		var proxybat = new Ext.data.HttpProxy({
			url : BatQtystatUrl,
			method : "POST"
		});
		// 指定列参数
		var batfields = ["Inclb","Inci","InciCode","InciDesc","BUomDesc","BUomId","StockQty",
			"StkQtyUom","StkBin","Btno","Expdate","PurUomDesc","PurUomId","PurStockQty",
			"Spec","ManfDesc","Sp","SpAmt","Rp","RpAmt","ManFlag","inclbRp","Vendor"];
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
			displayInfo : true
		});
		
		var StatuTabPagingToolbar2 = new Ext.PagingToolbar({
			store : BatStatStore,
			pageSize : PageSize,
			displayInfo : true
		});
    
		var StockQtyGrid = new Ext.grid.GridPanel({
			id:'StockQtyGrid',
			region : 'center',
			cm : StockQtyCm,
			store : StockStatStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : sm,
			loadMask : true
		});
		
		var BatQtyGrid = new Ext.grid.GridPanel({
			id:'BatQtyGrid',
			region : 'center',
			cm : BatQtyCm,
			store : BatStatStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : smbat,
			loadMask : true
		});
		
		var nmRp = new Ext.grid.RowNumberer({width:30});
		var smRp = new Ext.grid.CheckboxSelectionModel({/*checkOnly:'true'*/});
		var StockRpQtyCm = new Ext.grid.ColumnModel([nmRp, smRp, {
				header : "inclb",
				dataIndex : 'inclb',
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
				header : "规格",
				dataIndex : 'Spec',
				width : 100,
				align : 'left',
				sortable : false
			},{
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
				width : 80,
				align : 'left',
				sortable : false
			}, {
				header : "零售价",
				dataIndex : 'Sp',
				width : 80,
				align : 'right',
				sortable : false
			}, {
				header : "进价",
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
			},  {
				header : '厂商',
				dataIndex : 'ManfDesc',
				width : 150,
				align : 'left',
				sortable : false
			}, {
				header : '供应商',
				dataIndex : 'Vendor',
				width :150,
				align : 'left',
				sortable : false
			}, {
				header : "是否重点关注",
				dataIndex : 'ManFlag',
				width : 100,
				align : 'left',
				sortable : false,
				renderer:manFlagRender
		}]);
		StockRpQtyCm.defaultSortable = true;
    	// 访问路径
		var DspPhaRpUrl = DictUrl+ 'locitmstataction.csp?actiontype=LocItmRpStat';
		// 通过AJAX方式调用后台数据
		var proxyRp = new Ext.data.HttpProxy({
			url : DspPhaRpUrl,
			method : "POST",
			timeout: myBigTimeout
		});
		// 指定列参数
		var fieldsRp = ["inclb","Inci","InciCode","InciDesc","BUomDesc","BUomId","StockQty",
			"StkQtyUom","StkBin","PurUomDesc","PurUomId","PurStockQty","Spec",
			"ManfDesc","Sp","SpAmt","Rp","RpAmt","ManFlag","Vendor"];
		// 支持分页显示的读取方式
		var readerRp = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "inclb",
			fields : fieldsRp
		});
		
		// 数据集
		var StockRpStatStore = new Ext.data.Store({
			proxy : proxyRp,
			reader : readerRp,
			baseParams:{
				Params:''
			}
		});
		
		var StockRpQtyGrid = new Ext.grid.GridPanel({
			id:'StockRpQtyGrid',
			region : 'center',
			cm : StockRpQtyCm,
			store : StockRpStatStore,
			trackMouseOver : true,
			stripeRows : true,
			sm : smRp,
			loadMask : true
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
		        while (i < store.getCount() && thisRowCode == store.getAt(i).get("incicode")&&thisRowDesc==store.getAt(i).get("incidesc")&&thisRowSpec==store.getAt(i).get("spec")&&thisRowUom==store.getAt(i).get("puomdesc")) {
					i++;
		        }
		        var rowHeight = 25, padding = 6,
		        height = (rowHeight * (i - rowIndex) - padding) + 'px';
		        meta.attr = 'style="height:' + height + ';line-height:' + height + ';"';
		    }
		    return first ? value : '';
		}

		var HisListTab = new Ext.form.FormPanel({
			labelwidth : 30,
			width : 330,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 0px 0px 0px;',
			tbar : [SearchBT, '-', RefreshBT, '-', SaveAsBT,'-',PrintBT],
			items : [{
					xtype : 'fieldset',
					title : '必选条件',
					style : 'padding:5px 0px 0px 5px',
					items:[PhaLoc,DateTime]
				},
				Type,
				StkGrpType,
				StkCat,
				InciDesc,
				Vendor,
				PhManufacturer,
				LocManGrp,StkBin,
				{style : 'margin:5px 0px 0px 40px',items:[ManageDrug,HVFlag]},
				{xtype: 'compositefield',style : 'margin:5px 0px 0px 40px',hideLabel :true,items:[UseFlag,UseTime,{xtype:'tbtext',text:'个月有进出零库存'}]},
				{xtype: 'compositefield',style : 'margin:5px 0px 0px 40px',hideLabel :true,items:[NotUseFlag,NotUseTime,{xtype:'tbtext',text:'个月无进出非零库存'}]}
			 ]  	
		});
		
		var tabPanel=new Ext.TabPanel({
			id: 'tabPanel',
			region: 'border',
			activeTab: 0,
			items:[{
				title:'项目明细',
				id:'ItmDetail',
				layout:'fit',
				items:[StockQtyGrid]
			},{
				title:'批次明细',
				id:'BatDetail',
				layout:'fit',
				items:[BatQtyGrid]
			},{
				title:'项目价格明细',
				id:'ItmRpDetail',
				layout:'fit',
				items:[StockRpQtyGrid]
			},{
				title: '库存分类统计',
				id: 'stkcats',
				frameName: 'stkcat',
				layout:'fit',
				html: '<iframe id="stkcat" width=100% height=100% src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg" ></iframe>'
			}],
			listeners:{
					tabchange:function(tabpanel,panel){
						var p_URL="";
						var panl = Ext.getCmp("tabPanel").getActiveTab();
						var iframe = panl.el.dom.getElementsByTagName("iframe")[0];
						var tabId = tabPanel.getActiveTab().id;
						
						// 必选条件
						var sphaLoc = Ext.getCmp("PhaLoc").getValue();
						if (sphaLoc == null || sphaLoc.length <= 0) {
							Msg.info("warning", "科室不能为空！");
							Ext.getCmp("PhaLoc").focus();
							return;
						}
						var date = Ext.getCmp("DateTime").getValue().format(ARG_DATEFORMAT).toString();
						if (date == null || date.length <= 0) {
							Msg.info("warning", "日期不能为空！");
							Ext.getCmp("DateTime").focus();
							return;
						}
			            			// 可选条件
						var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
						var StkCat = Ext.getCmp("StkCat").getValue();
						var ManageDrug = (Ext.getCmp("ManageDrug").getValue()==true?'Y':'N');
						var UseFlag = (Ext.getCmp("UseFlag").getValue()==true?'Y':'N');
						var NotUseFlag = (Ext.getCmp("NotUseFlag").getValue()==true?'Y':'N');
						var Phmanid=Ext.getCmp("PhManufacturer").getValue();
						var ManGrpId=Ext.getCmp("LocManGrp").getValue();
						var SBid=Ext.getCmp("StkBin").getValue();
						var MoveMon=Ext.getCmp('UseTime').getValue();
						var NotMoveNon=Ext.getCmp('NotUseTime').getValue();
						var Ven=Ext.getCmp('Vendor').getValue();
			
						var StockType = Ext.getCmp("Type").getValue();
						var InciDesc=Ext.getCmp("InciDesc").getValue();
						if(InciDesc==null || InciDesc==""){
							gIncId="";
						}
						if(gIncId!=""&gIncId!=null){
							InciDesc="";
						}
						var HVFlag = Ext.getCmp('HVFlag').getValue()?'Y':'';
						/// 科室id^日期^类组id^厂家id^管理组id^
						/// 库位id^是否关注^零库存^6个月有进出^排除零库存^6个月无进出^
			
						var strParam=sphaLoc+"^"+date+"^"+StkGrpRowId+"^"+Phmanid+"^"+ManGrpId
						+"^"+SBid+"^"+ManageDrug+"^"+UseFlag+"^"+MoveMon+"^"+NotUseFlag
						+"^"+NotMoveNon+"^"+StkCat+"^"+Ven
						+"^"+StockType+"^"+gIncId+"^"+InciDesc+"^"+HVFlag;
						StockStatStore.setBaseParam("strParam",strParam);
						var pageSize=StatuTabPagingToolbar.pageSize;
						var activeTab=tabPanel.getActiveTab();
						var reportFrame=document.getElementById("frameReport");
						//获取查询条件列表
						var Conditions=""
						if(sphaLoc!=""){
							Conditions="科室: "+Ext.getCmp("PhaLoc").getRawValue()
							}
		   
						if(StkGrpRowId!=""){
							Conditions=Conditions+" 类组: "+Ext.getCmp("StkGrpType").getRawValue()
						}	
						if(StkCat!=""){
							Conditions=Conditions+" 库存分类: "+Ext.getCmp("StkCat").getRawValue()
							}
						if(Phmanid!=""){
							Conditions=Conditions+" 厂商: "+Ext.getCmp("PhManufacturer").getRawValue()
							}	
		
						if(ManGrpId!=""){
							Conditions=Conditions+" 管理组:"+Ext.getCmp("LocManGrp").getRawValue()
							}
						if(SBid!=""){
							Conditions=Conditions+" 货位码: "+Ext.getCmp("StkBin").getRawValue()
							}
						if (activeTab.id=="stkcats"){
								p_URL =PmRunQianUrl+"?reportName=DHCSTM_ItmLocByStkcat.raq&strParam="+strParam+";Conditions="+Conditions;
							    var ReportFrame=document.getElementById("stkcat");
							    alert(p_URL)
								ReportFrame.src=p_URL;
						}else {
							searchData()
						}
					}
			}
		});
function ShowReport()
	{
		tabPanel.fireEvent('tabchange',tabPanel,tabPanel.getActiveTab());
	}
		// 5.2.页面布局
		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [
				{
					region: 'west',
					split: true,
					width: 330,
					collapsible: true,
					title: '科室库存统计(批次)',
					layout: 'fit',
					items: HisListTab   
				 },{
					region:'center',
					title: '库存信息',
					layout: 'fit',
					items: tabPanel
				}
			],
			renderTo : 'mainPanel'
		});
	}
})