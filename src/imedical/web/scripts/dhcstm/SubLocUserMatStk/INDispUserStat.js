// /名称: 发放数据统计
// /描述: 医生用于统计发放给自己物资信息(包含退回)
// /编写者：	wangjiabin
// /编写日期:2013-12-23
Ext.onReady(function() {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gIncId='';
	var gStrParam='';	//用于展开明细时的参数
	var gUserId = session['LOGON.USERID'];	
	var gLocId=session['LOGON.CTLOCID'];
	var gGroupId=session['LOGON.GROUPID'];
	
	ChartInfoAddFun();

	function ChartInfoAddFun() {
		var PhaLoc = new Ext.ux.LocComboBox({
			fieldLabel : '科室',
			id : 'PhaLoc',
			name : 'PhaLoc',
			anchor : '90%',
			groupId:gGroupId,
			stkGrpId : 'StkGrpType'
		});

		var StartDate = new Ext.ux.DateField({
			fieldLabel : '起始日期',
			id : 'StartDate',
			name : 'StartDate',
			anchor : '90%',
			
			value : new Date().add(Date.DAY,-30)
		});
		
		var EndDate = new Ext.ux.DateField({
			fieldLabel : '截止日期',
			id : 'EndDate',
			name : 'EndDate',
			anchor : '90%',
			
			value : new Date()
		});
		
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			anchor : '90%',
			LocId:gLocId,
			UserId:gUserId,
			childCombo : 'DHCStkCatGroup'
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

		var InciDesc = new Ext.form.TextField({
			fieldLabel : '物资名称',
			id : 'InciDesc',
			name : 'InciDesc',
			anchor : '90%',
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
		 * 调用物资窗体并返回结果
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
			Ext.getCmp("InciDesc").setValue(inciDesc);
		}
		
		var ChargeFlag = new Ext.form.RadioGroup({
			id: 'ChargeFlag',
			columns: 3,
			anchor : '90%',
			items:[
				{boxLabel:'全部',name:'ChargeFlag',id:'ChargeFlag_All',inputValue:'',checked:true},
				{boxLabel:'收费',name:'ChargeFlag',id:'ChargeFlag_Yes',inputValue:'Y'},
				{boxLabel:'不收费',name:'ChargeFlag',id:'ChargeFlag_No',inputValue:'N'}
			]
		});
		
		var IncludeRet = new Ext.form.Checkbox({
			fieldLabel : '包含退回',
			id : 'IncludeRet',
			name : 'IncludeRet',
			anchor : '90%',
			checked : true
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
				Msg.info("warning", "科室不能为空！");
				Ext.getCmp("PhaLoc").focus();
				return;
			}
			var LeadLoc = tkMakeServerCall("web.DHCSTM.Common.UtilCommon","GetLeadLoc",phaLoc);
			if (Ext.isEmpty(LeadLoc)) {
				Msg.info("warning", "支领科室不能为空！");
				return;
			}
			var StartDate = Ext.getCmp("StartDate").getValue();
			if(StartDate==""){
				Msg.info("warning","起始日期不可为空!");
				Ext.getCmp("StartDate").focus();
				return;
			}else{
				StartDate = StartDate.format(ARG_DATEFORMAT).toString();
			}
			var EndDate = Ext.getCmp("EndDate").getValue();
			if(EndDate==""){
				Msg.info("warning","截止日期不可为空!");
				Ext.getCmp("EndDate").focus();
				return;
			}else{
				EndDate = EndDate.format(ARG_DATEFORMAT).toString();
			}
			if(StartDate>EndDate){
				Msg.info("warning","起始日期大于截止日期!");
				return;
			}
			
			var StkGrpRowId = Ext.getCmp("StkGrpType").getValue();
			
//			if (StkGrpRowId == null || StkGrpRowId.length <= 0) {
//				Msg.info("warning", "类组不能为空！");
//				Ext.getCmp("StkGrpType").focus();
//				return;
//			}
			
			var DHCStkCatGroup = Ext.getCmp("DHCStkCatGroup").getValue();
			var InciDesc=Ext.getCmp("InciDesc").getValue();
			if(InciDesc==null || InciDesc==""){
				gIncId="";
			}
			var IncludeRet=Ext.getCmp("IncludeRet").getValue()?1:0;
			var LUG="";		//专业组
			var ToLoc = phaLoc;		//接收科室
			var ChargeFlag = Ext.getCmp('ChargeFlag').getValue().getGroupValue();
			//sd^ed^包含退回标志(0:不包含,1:包含)^loc^userID^管理组^inci^scg^stkcat
			var strParam = StartDate+"^"+EndDate+"^"+IncludeRet+"^"+LeadLoc+"^"+gUserId
						+"^"+LUG+"^"+gIncId+"^"+StkGrpRowId+"^"+DHCStkCatGroup+"^"+ToLoc
						+"^"+ChargeFlag;
			
			MasterStore.removeAll();
			DetailGrid.store.removeAll();
			MasterStore.setBaseParam("strPar",strParam);
			
			MasterStore.load({
				params:{start:0,limit:999},
				callback:function(r,options,success){
					if(!success){
						Msg.info("error","查询有误, 请查看日志!");
					}else if(r.length>0){
						gStrParam = StartDate+"^"+EndDate+"^"+LeadLoc+"^"+LUG+"^"+gUserId
							+"^^^"+IncludeRet+"^"+ToLoc;
						MasterGrid.getSelectionModel().selectFirstRow();
						MasterGrid.getView().focusRow(0);
					}
				}
			});
		}
				
		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
			text : '清空',
			tooltip : '点击清空',
			iconCls : 'page_clearscreen',
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
			Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY,-30));
			Ext.getCmp("EndDate").setValue(new Date());
			Ext.getCmp("InciDesc").setValue('');
			Ext.getCmp("DHCStkCatGroup").setValue('');
			gIncId="";
			Ext.getCmp("IncludeRet").setValue(true);
			MasterGrid.store.removeAll();
			//MasterGrid.store.baseParams="";
			//MasterGrid.getBottomToolbar().updateInfo();
			DetailGrid.store.removeAll();
			DetailGrid.store.baseParams="";
			DetailGrid.getBottomToolbar().updateInfo();
		}

		var nm = new Ext.grid.RowNumberer();
		var sm = new Ext.grid.RowSelectionModel({
			singleSelect:true,
			listeners:{
				rowselect : function(sm, rowIndex, r) {
					DetailStore.removeAll();
					var inci = MasterStore.getAt(rowIndex).get("inci");
					if(inci==null || inci==""){return;}
					var tmpArr = gStrParam.split("^");
					tmpArr[6] = inci;
					gStrParam = tmpArr.join("^");
					DetailStore.setBaseParam('strPar',gStrParam);
					var pageSize=DetailPagingBar.pageSize;
					DetailStore.load({
						params:{start:0,limit:pageSize},
						callback:function(r,options,success){
							if(!success){
								Msg.info("error","明细查询有误, 请查看日志!");
							}
						}
					});
				}
			}
		});
		var MasterCm = new Ext.grid.ColumnModel([nm,{
					header : "库存id",
					dataIndex : 'inci',
					width : 60,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : '物资代码',
					dataIndex : 'InciCode',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : "物资名称",
					dataIndex : 'InciDesc',
					width : 200,
					align : 'left',
					sortable : false
				}, {
					header : "简称",
					dataIndex : 'Abbrev',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : "规格",
					dataIndex : 'Spec',
					width : 100,
					align : 'left',
					sortable : false
				}, {
					header : '品牌',
					dataIndex : 'Brand',
					width : 80,
					align : 'left',
					sortable : false
				}, {
					header : "型号",
					dataIndex : 'Model',
					width : 120,
					align : 'left',
					sortable : false
				}, {
					header : '进价金额',
					dataIndex : 'RpAmt',
					width : 100,
					align : 'right',
					sortable : false
				}, {
					header : '发放数量',
					dataIndex : 'QtyUom',
					width : 120,
					align : 'left',
					sortable : false
				}, {
					header : '收费标记',
					dataIndex : 'ChargeFlag',
					xtype : 'checkcolumn',
					width : 80,
					align : 'center'
				}
		]);
		MasterCm.defaultSortable = true;

		// 访问路径
		var MasterUrl = DictUrl
					+ 'sublocmatstataction.csp?actiontype=INDispStat';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["inci","InciCode","InciDesc","Abbrev","Spec","Model","Brand","QtyUom","RpAmt","ChargeFlag"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "inci",
					fields : fields
				});
		// 数据集
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader,
					baseParams : {
						ExcludeAlloted : "",
						IncludeAllot : 1
					}
				});

		var MasterGrid = new Ext.ux.GridPanel({
			title: '发放(退回)数据统计',
					id:'MasterGrid',
					region : 'center',
					cm : MasterCm,
					store : MasterStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : sm,
					loadMask : true
				});
				
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : "业务类型",
					dataIndex : 'trType',
					width : 60,
					align : 'left',
					sortable : true,
					renderer:function(v){
						if(v=="C"){
							return "发放";
						}else if(v=="L"){
							return "退回";
						}else{
							return v;
						}
					}
				}, {
					header : "物资代码",
					dataIndex : 'inciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "物资名称",
					dataIndex : 'inciDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : "批号~效期",
					dataIndex : 'batInfo',
					width : 140,
					align : 'left',
					sortable : true
				}, {
					header : "厂商",
					dataIndex : 'manf',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : "数量",
					dataIndex : 'qty',
					width : 50,
					align : 'right',
					sortable : true
				}, {
					header : "单位",
					dataIndex : 'uomDesc',
					width : 60,
					align : 'left',
					sortable : true
				}, {
					header : "进价(包装单位)",
					dataIndex : 'rp',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : "进价金额",
					dataIndex : 'rpAmt',
					width : 80,
					align : 'right',
					sortable : true
				},{
					header : "发放单号",
					dataIndex : 'indsNo',
					width : 140,
					align : 'left',
					sortable : true
				}, {
					header : "发放日期",
					dataIndex : 'dispDate',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "发放时间",
					dataIndex : 'dispTime',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : "请领单号",
					dataIndex : 'dsrqNo',
					width : 140,
					align : 'left',
					sortable : true
				}
			]);
		DetailCm.defaultSortable = false;
		
		// 访问路径
		var DetailUrl = DictUrl
					+ 'sublocmatstataction.csp?actiontype=LocUserMatStat';
		// 通过AJAX方式调用后台数据
		var DetailProxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// 指定列参数
		var fieldsDetail = ["trType","inciCode","inciDesc","spec","manf","batInfo",
				{name:"qty",convert:Negative},
				"uomDesc","rp",
				{name:"rpAmt",convert:Negative},
				"dispDate","dispTime","receiver","indsNo","dsrqNo","dsrqDate"
			];
		// 支持分页显示的读取方式
		var DetailReader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "Inclb",
					fields : fieldsDetail
				});
		// 数据集
		var DetailStore = new Ext.data.Store({
					proxy : DetailProxy,
					reader : DetailReader
				});

		var DetailPagingBar = new Ext.PagingToolbar({
					store : DetailStore,
					pageSize : PageSize,
					displayInfo : true
				});
		var DetailGrid = new Ext.ux.GridPanel({
					title : '发放(退回)明细',
					id : 'DetailGrid',
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					sm : new Ext.grid.CheckboxSelectionModel(),
					loadMask : true,
					bbar : DetailPagingBar
				});
		
		function Negative(v,rec){
			return -parseFloat(v);
		}
		
		var HisListTab = new Ext.form.FormPanel({
			title: '发放数据统计',
			width : 300,
			labelAlign : 'right',
			frame : true,
			autoScroll : true,
			bodyStyle : 'padding:10px 0px 0px 0px;',
			tbar : [SearchBT, '-', ClearBT],
			items : [{
						title:'必选条件',
						xtype:'fieldset',
						style:'padding:10px 0px 0px 0px',
						items:[PhaLoc,StartDate,EndDate]
					},
					StkGrpType,
					DHCStkCatGroup,
					InciDesc,
					ChargeFlag,
					IncludeRet
			]
		});

		// 页面布局
		var mainPanel = new Ext.ux.Viewport({
					layout : 'border',
					items : [{
							region: 'west',
							split: true,
							width: 300,
							minSize: 200,
							maxSize: 350,
							collapsible: true,
							layout: 'fit',
							items: HisListTab
						}, {
							region: 'center',
							layout:'border',
							items:[{
								region:'center',
								layout: 'fit',
								items: MasterGrid
							},{
								region:'south',
								split:true,
								height:200,
								minSize:100,
								maxSize:300,
								layout:'fit',
								items:DetailGrid
							}]
						}
					],
					renderTo : 'mainPanel'
				});
	}
})