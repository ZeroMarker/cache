// /名称: 台帐查询
// /描述: 台帐查询
// /编写者：zhangdongmei
// /编写日期: 2012.08.09
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	//var LoginLocId = session['LOGON.COMMUNITYROWID'];   //DTHealth需要改一下
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	ChartInfoAddFun();

	function ChartInfoAddFun() {

		//统计科室
		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '科室',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor:'90%',
			groupId:gGroupId,
			stkGrpId : 'StkGrpType'
		});
			
		// 起始日期
		var StartDate = new Ext.ux.DateField({
			fieldLabel : '起始日期',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			width : 120,
			value : new Date()
		});

		// 结束日期
		var EndDate = new Ext.ux.DateField({
			fieldLabel : '结束日期',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			width : 120,
			value : new Date()
		});	
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			childCombo : 'DHCStkCatGroup'
		});
		
		var DHCStkCatGroup = new Ext.ux.ComboBox({
			fieldLabel : '库存分类',
			id : 'DHCStkCatGroup',
			name : 'DHCStkCatGroup',
			anchor : '90%',
			width : 120,
			store : StkCatStore,
			valueField : 'RowId',
			displayField : 'Description',
			params:{StkGrpId:'StkGrpType'}
		});

		var InciDr = new Ext.form.TextField({
			fieldLabel : '物资RowId',
			id : 'InciDr',
			name : 'InciDr',
			anchor : '90%',
			width : 140,
			valueNotFoundText : ''
		});

		var ItmDesc = new Ext.form.TextField({
			fieldLabel : '物资名称',
			id : 'ItmDesc',
			name : 'ItmDesc',
			anchor : '90%',
			width : 160,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var StkGrp= Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(),StkGrp);
					}
				}
			}
		});
					
		/**
		 * 调用物资窗体并返回结果
		 */
		function GetPhaOrderInfo(item, group) {
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, group, App_StkTypeCode, "", "", "", "",
						getDrugList);
			}
		}

		/**
		 * 返回方法
		*/
		function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var inciDr = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			Ext.getCmp("ItmDesc").setValue(inciDesc);
			Ext.getCmp('InciDr').setValue(inciDr);
		}
		
		var INFOSpec = new Ext.form.TextField({
			fieldLabel :'规格',
			id : 'INFOSpec',
			name : 'INFOSpec',
			anchor : '90%',
			width : 100,
			valueNotFoundText : ''
		});
		
		var GType = new Ext.form.Checkbox({
			boxLabel : '大于',
			id:'GType',
			name : 'GType',
			anchor : '90%',
			checked : false,
			listeners:{
				'check':function(chk){
					if (chk.getValue()) {
						Ext.getCmp("LType").setValue(!chk.getValue()); 
					}
				}
			}
		})
		
		var LType = new Ext.form.Checkbox({
			boxLabel : '小于',
			id:'LType',
			name : 'LType',
			anchor : '90%',
			checked : false,
			listeners:{
				'check':function(chk){
					if (chk.getValue()) {
						Ext.getCmp("GType").setValue(!chk.getValue()); 
					}
				}
			}
		})
		
		var INCIBRpPuruom = new Ext.ux.NumberField({
			formatType : 'FmtRP',
			fieldLabel:'进价',
			id : 'INCIBRpPuruom',
			name : 'INCIBRpPuruom',
			allowNegative : false,
			selectOnFocus : true
		});
		
		//重点关注标志
		var ManageDrug = new Ext.form.Checkbox({
			boxLabel : '重点关注标志',
			id : 'ManageDrug',
			name : 'ManageDrug',
			anchor : '90%',
			checked : false
		});
					
		var TypeStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['0', '全部'], ['1', '零消耗'], ['2', '非零消耗']]
		});
		//统计标志
		var QueryFlag = new Ext.form.ComboBox({
			fieldLabel : '统计标志',
			id : 'QueryFlag',
			name : 'QueryFlag',
			anchor : '90%',
			width : 100,
			store : TypeStore,
			valueField : 'RowId',
			displayField : 'Description',
			mode : 'local',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			listWidth : 150,
			forceSelection : true
		});
		Ext.getCmp("QueryFlag").setValue(0);

		var TypeStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['0', '全部'], ['1', '库存为零'], ['2', '库存为正'],
					['3', '库存为负'], ['4', '库存非零']]
		});
		var StockType = new Ext.form.ComboBox({
			fieldLabel : '库存类型',
			id : 'StockType',
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
		Ext.getCmp("StockType").setValue("0");
		
		
		// 查询按钮
		var searchBT = new Ext.Toolbar.Button({
			text : '查询',
			tooltip : '点击查询物资台帐',
			iconCls : 'page_find',
			height:30,
			width:70,
			handler : function() {
				searchMainData();
			}
		});
		function priceRender(val){
			var val = Ext.util.Format.number(val,'0.00');
			if(val<0){
				return '<span style="color:red;">'+val+'</span>';
			}else if(val>0){
				return '<span style="color:green;">'+val+'</span>';
			}
			return val;
		}
		function searchMainData() {
			var StartDate=Ext.getCmp("StartDate").getValue();
		    var EndDate=Ext.getCmp("EndDate").getValue();
		    if(StartDate==""||EndDate==""){
			    Msg.info("warning","开始日期或截止日期不能为空！");
			    return;
			    
		    }
			var StartDate = Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT)
					.toString();
			if(StartDate==null||StartDate.length <= 0) {
				Msg.info("warning", "开始日期不能为空！");
				return;
			}
			var EndDate = Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT)
					.toString();
			if(EndDate==null||EndDate.length <= 0) {
				Msg.info("warning", "截止日期不能为空！");
				return;
			}
			var PhaLoc = Ext.getCmp("PhaLoc").getValue();
			if(PhaLoc==null||PhaLoc.length <= 0) {
				Msg.info("warning", "科室不能为空！");
				return;
			}
			var StkGrp= Ext.getCmp("StkGrpType").getValue();
			var StkCat= Ext.getCmp("DHCStkCatGroup").getValue();
			var ItmDesc=Ext.getCmp("ItmDesc").getValue();
			if(ItmDesc == "" || ItmDesc == null){
				Ext.getCmp("InciDr").setValue("");
			}
			var ItmRowid=Ext.getCmp("InciDr").getValue();
			if(ItmRowid!=""&ItmRowid!=null){
				ItmDesc="";
			}
			var ManageFlag= Ext.getCmp("ManageDrug").getValue();
			if(ManageFlag==true){
				ManageFlag=1;
			}
			else{
				ManageFlag="";
			}
			var StateFlag= Ext.getCmp("QueryFlag").getValue();
			var INFOSpec= Ext.getCmp("INFOSpec").getValue();
			var StockType=Ext.getCmp("StockType").getValue();
			var Others=StkGrp+"^"+StkCat+"^"+ItmRowid+"^"+StockType+"^"+""
				+"^"+ManageFlag+"^"+StateFlag+"^"+INFOSpec+"^"+ItmDesc;
			MasterInfoStore.setBaseParam('startdate',StartDate);
			MasterInfoStore.setBaseParam('enddate',EndDate);
			MasterInfoStore.setBaseParam('phaloc',PhaLoc);
			MasterInfoStore.setBaseParam('others',Others);
			var size=StatuTabPagingToolbar.pageSize;
			MasterInfoStore.removeAll();
			DetailInfoGrid.store.removeAll();
			MasterInfoStore.load({
				params:{start:0,limit:size},
				callback : function(r,options, success){
					if(success==false){
						Msg.info("error", "查询错误，请查看日志!");
					}else{
						if(r.length>0){
							MasterInfoGrid.getSelectionModel().selectFirstRow();
						}
					}
				}
			});
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
			
			Ext.getCmp("StartDate").setValue(new Date());
			Ext.getCmp("EndDate").setValue(new Date());
			SetLogInDept(PhaLoc.getStore(), "PhaLoc");
			Ext.getCmp("StkGrpType").getStore().load();
			Ext.getCmp("INFOSpec").setValue('');
			Ext.getCmp("INCIBRpPuruom").setValue('');
			Ext.getCmp("StockType").setValue('0');
			Ext.getCmp("GType").setValue('');
			Ext.getCmp("LType").setValue('');
			Ext.getCmp("DHCStkCatGroup").setValue('');
			Ext.getCmp("QueryFlag").setValue('0');
			Ext.getCmp("ItmDesc").setValue('');
			Ext.getCmp("ManageDrug").setValue(false);
			MasterInfoGrid.store.removeAll();
			DetailInfoGrid.store.removeAll();
		}
					
		// 访问路径
		var MasterInfoUrl = DictUrl
						+ 'locitmstkaction.csp?actiontype=LocItmStkMoveSum&start=0&limit=20';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
			url : MasterInfoUrl,
			method : "POST"
		});
		// 指定列参数
		// INCIL^库存项代码^库存项名称^库存分类^入库单位^基本单位^期初数量(基本单位)
		// ^期初数量(带单位)^期初金额(进价)^期初金额(售价)^期末数量(基本单位)^期末数量(带单位)
		// ^期末金额(进价)^期末金额(售价)
		var fields = ["INCIL", "InciCode", "InciDesc","StkCat","PurUom","BUom","BegQty","BegQtyUom",
			"BegRpAmt","BegSpAmt","EndQty","EndQtyUom","EndRpAmt","EndSpAmt"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "INCIL",
			fields : fields
		});
		// 数据集
		var MasterInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader
		});
		var nm = new Ext.grid.RowNumberer();
		var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "INCIL",
				dataIndex : 'INCIL',
				width : 20,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "物资代码",
				dataIndex : 'InciCode',
				width : 160,
				align : 'left',
				renderer :Ext.util.Format.InciPicRenderer('INCIL'),
				useRenderExport : false,
				sortable : true
			}, {
				header : "物资名称",
				dataIndex : 'InciDesc',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : '库存分类',
				dataIndex : 'StkCat',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '入库单位',
				dataIndex : 'PurUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '基本单位',
				dataIndex : 'BUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '期初库存',
				dataIndex : 'BegQtyUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '期初金额(进价)',
				dataIndex : 'BegRpAmt',
				width : 100,
				align : 'right',
				renderer:priceRender,
				useRenderExport : false,
				sortable : true
			}, {
				header : '期初金额(售价)',
				dataIndex : 'BegSpAmt',
				width : 100,
				align : 'right',
				renderer:priceRender,
				useRenderExport : false,
				sortable : true
			}, {
				header : '期末库存',
				dataIndex : 'EndQtyUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : '期末金额(进价)',
				dataIndex : 'EndRpAmt',
				width : 100,
				align : 'right',
				renderer:priceRender,
				useRenderExport : false,
				sortable : true
			}, {
				header : '期末金额(售价)',
				dataIndex : 'EndSpAmt',
				width : 100,
				align : 'right',
				renderer:priceRender,
				useRenderExport : false,
				sortable : true
		}]);
		MasterInfoCm.defaultSortable = true;
		var StatuTabPagingToolbar = new Ext.PagingToolbar({
			store : MasterInfoStore,
			pageSize : PageSize,
			displayInfo : true
		});
		
		var sm = new Ext.grid.RowSelectionModel({
			singleSelect : true,
			listeners:{
				'rowselect': function(sm,rowIndex,r){
					var Incil = MasterInfoStore.getAt(rowIndex).get("INCIL");
					var StartDate = Ext.getCmp("StartDate").getValue().format(ARG_DATEFORMAT).toString();;
					var EndDate = Ext.getCmp("EndDate").getValue().format(ARG_DATEFORMAT).toString();
					var INCIBRpPuruom=Ext.getCmp("INCIBRpPuruom").getValue();
					var GType=(Ext.getCmp("GType").getValue()==true?'G':'');	//大于
					var LType=(Ext.getCmp("LType").getValue()==true?'L':'');	//小于
					var RpType=INCIBRpPuruom+"^"+GType+"^"+LType;
					var size=StatuTabPagingToolbar2.pageSize;
					DetailInfoStore.setBaseParam('incil',Incil);
					DetailInfoStore.setBaseParam('startdate',StartDate);
					DetailInfoStore.setBaseParam('enddate',EndDate);
					DetailInfoStore.setBaseParam('RpType',RpType);
					DetailInfoStore.removeAll();
					DetailInfoStore.load({
						params:{start:0,limit:size},
						callback:function(r,options,success){
							if(success==false){
								Msg.info("error","查询有误, 请查看日志!");
							}
						}
					});
				}
			}
		});
		
		var MasterInfoGrid = new Ext.ux.GridPanel({
			region: 'west',
			collapsible: true,
			split: true,
			width: 300,
			margins: '0 5 0 0',
			id : 'MasterInfoGrid',
			title : '台帐',
			cm : MasterInfoCm,
			sm : sm,
			store : MasterInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			bbar : StatuTabPagingToolbar
		});

		// 访问路径
		var DetailInfoUrl = DictUrl
						+ 'locitmstkaction.csp?actiontype=LocItmStkMoveDetail&start=0&limit=20';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
			url : DetailInfoUrl,
			method : "POST"
		});
		
		// 指定列参数
		//业务日期^批号^单位^售价^进价^结余数量(基本单位)^结余数量(带单位)^增减数量(基本单位)
		//^增减数量(带单位)^增减金额(进价)^增减金额(售价)^处理号^处理人^摘要
		//^期末金额(进价)^期末金额(售价)^供应商^厂商^操作人	
		var fields = ["TrId","TrDate", "BatExp", "PurUom", "Sp","Rp","EndQty","EndQtyUom",
			"TrQty", "TrQtyUom", "RpAmt", "SpAmt","TrNo","TrAdm","TrMsg",
			"EndRpAmt", "EndSpAmt", "Vendor", "Manf","OperateUser","HVBarCode"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
			root : 'rows',
			totalProperty : "results",
			id : "TrId",
			fields : fields
		});
		// 数据集
		var DetailInfoStore = new Ext.data.Store({
			proxy : proxy,
			reader : reader
		});
		var nm = new Ext.grid.RowNumberer();
		var DetailInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "TrId",
				dataIndex : 'TrId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "日期",
				dataIndex : 'TrDate',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : '批号效期',
				dataIndex : 'BatExp',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "单位",
				dataIndex : 'PurUom',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "高值条码",
				dataIndex : 'HVBarCode',
				width : 140
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 80,
				align : 'right'
			}, {
				header : "售价",
				dataIndex : 'Sp',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "结余数量",
				dataIndex : 'EndQtyUom',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "数量",
				dataIndex : 'TrQtyUom',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "进价金额",
				dataIndex : 'RpAmt',
				width : 120,
				renderer:priceRender,
				useRenderExport : false,
				align : 'right',
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'SpAmt',
				width : 120,
				renderer:priceRender,
				useRenderExport : false,
				align : 'right',
				sortable : true
			}, {
				header : "处理号",
				dataIndex : 'TrNo',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "处理人",
				dataIndex : 'TrAdm',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "摘要",
				dataIndex : 'TrMsg',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "结余金额(进价)",
				dataIndex : 'EndRpAmt',
				width : 120,
				renderer:priceRender,
				useRenderExport : false,
				align : 'right',
				sortable : true
			}, {
				header : "结余金额(售价)",
				dataIndex : 'EndSpAmt',
				width : 120,
				renderer:priceRender,
				useRenderExport : false,
				align : 'right',
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'Vendor',
				width : 160,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'Manf',
				width : 160,
				align : 'left',				
				sortable : true
			}, {
				header : "操作人",
				dataIndex : 'OperateUser',
				width : 100,
				align : 'left',				
				sortable : true
		}]);
		DetailInfoCm.defaultSortable = true;
		var StatuTabPagingToolbar2 = new Ext.PagingToolbar({
			store : DetailInfoStore,
			pageSize : 20,
			displayInfo : true
		});
		var DetailInfoGrid = new Ext.ux.GridPanel({
			region: 'center',
			id : 'DetailInfoGrid',
			title : '台帐明细',
			cm : DetailInfoCm,
			sm : new Ext.grid.RowSelectionModel({
					singleSelect : true
				}),
			store : DetailInfoStore,
			trackMouseOver : true,
			stripeRows : true,
			loadMask : true,
			bbar : StatuTabPagingToolbar2
		});

		var HisListTab = new Ext.ux.FormPanel({
			title:'台帐查询',
			tbar : [searchBT, '-', clearBT],
			layout : 'column',
			items:[{
					columnWidth:0.25,
					xtype: 'fieldset',
					title:'必选条件',
					style : 'padding:5px 0px 0px 5px',
					items : [PhaLoc,StartDate,EndDate]
				},{
					columnWidth:0.74,
					xtype: 'fieldset',
					title:'可选条件',
					style : 'padding:5px 0px 0px 5px',
					defaults : {border:false,xtype:'fieldset'},
					style:'margin-left:2px',
					layout : 'column',
					items : [{
						columnWidth:0.3,
						items : [StkGrpType,DHCStkCatGroup,QueryFlag]
					},{
						columnWidth:0.28,
						items : [ItmDesc,INFOSpec,ManageDrug]
					},{
						columnWidth:0.2,
						items : [INCIBRpPuruom,GType,LType]
					},{
						columnWidth:0.22,
						items : [StockType]
					}]
				}
			]
		});

		var mainPanel = new Ext.ux.Viewport({
			layout : 'border',
			items : [HisListTab, MasterInfoGrid, DetailInfoGrid]
		});
	}
});