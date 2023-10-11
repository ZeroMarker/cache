// /名称: 转移入库单据查询		
// /编写者：zhangdongmei
// /编写日期: 2012.07.24
// /2013-07-17 根据转移出库查询修改
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
    var gGroupId=session['LOGON.GROUPID'];
    var gLocId=session['LOGON.CTLOCID'];
    var gInciRowId="";
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var gParamNew = PHA_COM.ParamProp("DHCSTTRANSFER")
	var PoisonDoubleSignFlag = gParamNew.InPoisonDoubleSign == "Y" ? false : true;
	ChartInfoAddFun();
	// 登录设置默认值
	SetLogInDept(PhaDeptStore, "RequestPhaLoc");
	//取参数配置
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}
	function ChartInfoAddFun() {
		// 请求部门
		var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : $g('接收部门'),
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : $g('接收部门...'),
					groupId:gGroupId
					
		});
		
		// 供给部门
		var SupplyPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : $g('供给部门'),
					id : 'SupplyPhaLoc',
					name : 'SupplyPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : $g('供给部门...'),
					defaultLoc:{}
				});


		// 起始日期
		var StartDate = new Ext.ux.DateField({
					fieldLabel : $g('起始日期'),
					id : 'StartDate',
					name : 'StartDate',
					anchor : '90%',
					width : 120,
					value : DefaultStDate()
				});
		// 截止日期
		var EndDate = new Ext.ux.DateField({
					fieldLabel : $g('截止日期'),
					id : 'EndDate',
					name : 'EndDate',
					anchor : '90%',
					width : 120,
					value : DefaultEdDate()
				});
				
		// 麻醉精一
	var PMZJYFlag = new Ext.form.Checkbox({
		fieldLabel : $g('麻醉精一'),
		id : 'PMZJYFlag',
		name : 'PMZJYFlag',
		anchor : '90%',
		width : 150,
		checked : false,
		disabled:false,
		hidden:PoisonDoubleSignFlag
		
	});
	

		var StatusStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['10', $g('未完成')], ['11', $g('已完成')],['20', $g('出库审核不通过')],['21', $g('出库审核通过')],['30', $g('拒绝接收')],['31', $g('已接收')],['32', $g('部分接收')],['40', $g('重转作废')]]
		});
		
		var Status = new Ext.form.ComboBox({
			fieldLabel : $g('转移单状态'),
			id : 'Status',
			name : 'Status',
			anchor:'90%',
			width : 100,
			store : StatusStore,
			triggerAction : 'all',
			mode : 'local',
			valueField : 'RowId',
			displayField : 'Description',
			allowBlank : true,
			triggerAction : 'all',
			selectOnFocus : true,
			forceSelection : true,
			minChars : 1,
			editable : true,
			valueNotFoundText : ''
		});
		
		// 药品类组
		var StkGrpType=new Ext.ux.StkGrpComboBox({   //StkGrpType.store.reload();
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			width : 200
		}); 
		// 药品名称
		var InciDesc = new Ext.form.TextField({
			fieldLabel : $g('药品名称'),
			id : 'InciDesc',
			name : 'InciDesc',
			anchor : '90%',
			width : 150,
			listeners : {
				specialkey : function(field, e) {
					if (e.getKey() == Ext.EventObject.ENTER) {
						var stktype = Ext.getCmp("StkGrpType").getValue();
						GetPhaOrderInfo(field.getValue(), stktype);
					}
				}
			}
		});

			/**
		 * 调用药品窗体并返回结果
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
			var inciDr = record.get("InciDr");
			var InciDesc=record.get("InciDesc");
			Ext.getCmp("InciDesc").setValue(InciDesc);
			gInciRowId=inciDr;
		}
		
		// 查询按钮
		var SearchBT = new Ext.Toolbar.Button({
					text : $g('查询'),
					tooltip : $g('点击查询'),
					width : 70,
					height : 30,
					iconCls : 'page_find',
					handler : function() {
						Query();
					}
				});
		/**
		 * 查询方法
		 */
		function Query() {
			var supplyphaLoc = Ext.getCmp("SupplyPhaLoc").getValue();
			var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
			if (requestphaLoc == null || requestphaLoc.length <= 0) {
				Msg.info("warning", $g("请选择请求部门!"));
				return;
			}
			var startDate = Ext.getCmp("StartDate").getRawValue();
			var endDate = Ext.getCmp("EndDate").getRawValue();
			var statue =  Ext.getCmp("Status").getValue();
			var stkgrpid=Ext.getCmp("StkGrpType").getValue();
			var inci=gInciRowId;
			if(Ext.getCmp("InciDesc").getValue()==""){
				inci="";
			}
			var MZJYFlag = Ext.getCmp("PMZJYFlag").getValue()  ? 'Y' : 'N';
		
			var ListParam = [startDate,endDate,supplyphaLoc,requestphaLoc,"",statue,"","",stkgrpid,inci,"",MZJYFlag].join("^")
			//var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^^'+statue+'^^^'+stkgrpid+"^"+inci;
			var Page=GridPagingToolbar.pageSize;
			MasterStore.setBaseParam('ParamStr',ListParam);
			MasterStore.load({params:{start:0, limit:Page}});
			DetailGrid.store.removeAll();
			MasterStore.removeAll();
			MasterStore.on('load',function(){
				if (MasterStore.getCount()>0){
					MasterGrid.getSelectionModel().selectFirstRow();
					MasterGrid.getView().focusRow(0);
				}
	        });
		}

		// 清空按钮
		var ClearBT = new Ext.Toolbar.Button({
					text : $g('清屏'),
					tooltip : $g('点击清屏'),
					width : 70,
					height : 30,
					iconCls : 'page_clearscreen',
					handler : function() {
						clearData();
					}
				});
		/**
		 * 清空方法
		 */
		function clearData() {
			SetLogInDept(PhaDeptStore, "RequestPhaLoc");
			
			Ext.getCmp("SupplyPhaLoc").setValue("");
			Ext.getCmp("Status").setValue("");
			//Ext.getCmp("StkGrpType").setValue("");
			StkGrpType.store.reload();
			Ext.getCmp("InciDesc").setValue("");
			Ext.getCmp("StartDate").setValue(DefaultStDate());
			Ext.getCmp("EndDate").setValue(DefaultEdDate());
			Ext.getCmp("PMZJYFlag").setValue(false);
			MasterGrid.store.removeAll();
			MasterGrid.getView().refresh();
			DetailGrid.store.removeAll();
			DetailGrid.getView().refresh();
		}
		
		// 打印按钮
		var PrintBT = new Ext.Toolbar.Button({
					text : $g('打印'),
					tooltip : $g('点击打印'),
					width : 70,
					height : 30,
					iconCls : 'page_print',
					handler : function() {
						var rowData=MasterGrid.getSelectionModel().getSelected();
						if (rowData ==null) {
							Msg.info("warning", $g("请选择需要打印的转移单!"));
							return;
						}
						var init = rowData.get("init");
						PrintInIsTrf(init,gParam[8]);
					}
				});
				
				
					// 麻醉精一审核1
		var MZJYAudit1 = new Ext.Toolbar.Button({
					id:'MZJYAudit1',
					text : $g('麻精审核1'),
					tooltip : $g('点击审核'),
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					hidden:PoisonDoubleSignFlag,
					handler : function() {
						MZJYDoubleSign("InMZJY1")
					}
				});
		// 麻醉精一审核2
		var MZJYAudit2 = new Ext.Toolbar.Button({
					id:'MZJYAudit2',
					text : $g('麻精审核2'),
					tooltip : $g('点击审核'),
					width : 70,
					height : 30,
					iconCls : 'page_gear',
					hidden:PoisonDoubleSignFlag,
					handler : function() {
						MZJYDoubleSign("InMZJY2");
					}
				});
		// 麻醉精一药品双签
		function MZJYDoubleSign(Status){
			var rowData=MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", $g("请选择一张转移单!"));
				return;
			}
			var init = rowData.get("init");
			var Table = "User.DHCInIsTrf"
			var Ret = tkMakeServerCall("web.DHCST.DHCINIsTrf","SaveStatus",Table,init,Status,userId,"","Y","31")
			var RetArr = Ret.split("^")
			if(RetArr[0]>0){
				Msg.info("success", $g("审核成功!"));
				Query();
				return;
			}
			else{
				Msg.info("warning", $g("审核失败:") + RetArr[1]);
				return;
			}
		}

			
		/* 列设置按钮 */
		var GridColSetBT = new Ext.Toolbar.Button({
			text:$g('列设置'),
			tooltip:$g('列设置'),
			iconCls:'page_gear',
			handler:function(){
				GridSelectWin.show();
			}
		});

		// 确定按钮
		var returnColSetBT = new Ext.Toolbar.Button({
			text : $g('确定'),
			tooltip : $g('点击确定'),
			iconCls : 'page_goto',
			handler : function() {
				var selectradio = Ext.getCmp('GridSelectModel').getValue();
				if(selectradio){
					var selectModel =selectradio.inputValue;	
					if (selectModel=='1') {
						GridColSet(MasterGrid,"DHCSTTRANSFER");						
					}
					else {
						GridColSet(DetailGrid,"DHCSTTRANSFER");   							
					}						
				}
				GridSelectWin.hide();
			}
		});

		// 取消按钮
		var cancelColSetBT = new Ext.Toolbar.Button({
				text : $g('取消'),
				tooltip : $g('点击取消'),
				iconCls : 'page_delete',
				handler : function() {
					GridSelectWin.hide();
				}
			});

		//选择按钮
		var GridSelectWin=new Ext.Window({
			title:$g('选择'),
			width : 210,
			height : 110,
			labelWidth:100,
			closeAction:'hide' ,
			plain:true,
			modal:true,
			items:[{
				xtype:'radiogroup',
				id:'GridSelectModel',
				anchor: '95%',
				columns: 2,
				style: 'padding:10px 10px 10px 10px;',
				items : [{
						checked: true,				             
							boxLabel: $g('出库单'),
							id: 'GridSelectModel1',
							name:'GridSelectModel',
							inputValue: '1' 							
						},{
						checked: false,				             
							boxLabel: $g('出库单明细'),
							id: 'GridSelectModel2',
							name:'GridSelectModel',
							inputValue: '2' 							
						}]
					}],
			
			buttons:[returnColSetBT,cancelColSetBT]
		})



		
		// 访问路径
		var MasterUrl = DictUrl	+ 'dhcinistrfaction.csp?actiontype=Query';
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : MasterUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["init", "initNo", "reqNo", "toLocDesc", "frLocDesc", "dd","tt", "comp", "userName",
		"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode","inAckDate","inAckTime","inAckUser","InMZJYAudit1","InMZJYAudit2"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "init",
					fields : fields
				});
		// 数据集
		var MasterStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var MasterCm = new Ext.grid.ColumnModel([nm, {
					header : "RowId",
					dataIndex : 'init',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g("转移单号"),
					dataIndex : 'initNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g('请求单号'),
					dataIndex : 'reqNo',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("请求部门"),
					dataIndex : 'toLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("供给部门"),
					dataIndex : 'frLocDesc',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("转移日期"),
					dataIndex : 'dd',
					width : 90,
					align : 'center',
					sortable : true
				}, {
					header : $g("单据状态"),
					dataIndex : 'StatusCode',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("制单人"),
					dataIndex : 'userName',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("入库确认日期"),
					dataIndex : 'inAckDate',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("入库确认时间"),
					dataIndex : 'inAckTime',
					width : 90,
					align : 'left',
					sortable : true
				}, {
					header : $g("入库确认人"),
					dataIndex : 'inAckUser',
					width : 70,
					align : 'left',
					sortable : true
				}, {
					header : $g("进价金额"),
					dataIndex : 'RpAmt',
					width : 80,
					align : 'right',					
					sortable : true,
					renderer:FormatGridRpAmount
				}, {
					header : $g("售价金额"),
					dataIndex : 'SpAmt',
					width : 80,
					align : 'right',					
					sortable : true,
					renderer:FormatGridSpAmount
				}, {
					header : $g("进销差价"),
					dataIndex : 'MarginAmt',
					width : 80,
					align : 'right',					
					sortable : true,
					renderer:FormatGridRpAmount
				}, {
					header : $g("备注"),
					dataIndex : 'Remark',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("麻精审核1"),
					dataIndex : 'InMZJYAudit1',
					width : 90,
					align : 'left',
					sortable : true,
					hidden:PoisonDoubleSignFlag
				}, {
					header : $g("麻精审核2"),
					dataIndex : 'InMZJYAudit2',
					width : 90,
					align : 'left',
					sortable : true,
					hidden:PoisonDoubleSignFlag
				}]);
		MasterCm.defaultSortable = true;
		var GridPagingToolbar = new Ext.PagingToolbar({
			store:MasterStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:$g('第 {0} 条到 {1}条, 一共 {2} 条'),
			emptyMsg:$g("没有记录")
		});
		var MasterGrid = new Ext.grid.GridPanel({
					title : '',
					height : 170,
					cm : MasterCm,
					sm : new Ext.grid.RowSelectionModel({
								singleSelect : true
							}),
					store : MasterStore,
					trackMouseOver : true,
					stripeRows : true,
					loadMask : true,
					bbar:GridPagingToolbar
				});

		// 添加表格单击行事件
		MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
			var InIt = MasterStore.getAt(rowIndex).get("init");
			var status =  Ext.getCmp("Status").getValue();
			DetailStore.setBaseParam('Parref',InIt+"^"+status)
			DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
		});

		// 转移明细
		// 访问路径
		var DetailUrl =  DictUrl
					+ 'dhcinistrfaction.csp?actiontype=QueryDetail';;;
		// 通过AJAX方式调用后台数据
		var proxy = new Ext.data.HttpProxy({
					url : DetailUrl,
					method : "POST"
				});
		// 指定列参数
		var fields = ["initi", "inrqi", "inci","inciCode",
				"inciDesc", "inclb", "batexp", "manf","manfName",
				 "qty", "uom", "sp","status","remark",
				"reqQty", "inclbQty", "reqLocStkQty", "reqstkbin",
				"pp", "spec", "gene", "formDesc","newSp",
				"spAmt", "rp","rpAmt", "ConFac", "BUomId", 
				"inclbDirtyQty", "inclbAvaQty","TrUomDesc","InsuCode","InsuDesc"];
		// 支持分页显示的读取方式
		var reader = new Ext.data.JsonReader({
					root : 'rows',
					totalProperty : "results",
					id : "initi",
					fields : fields
				});
		// 数据集
		var DetailStore = new Ext.data.Store({
					proxy : proxy,
					reader : reader
				});
		var nm = new Ext.grid.RowNumberer();
		var DetailCm = new Ext.grid.ColumnModel([nm, {
					header : $g("转移细项RowId"),
					dataIndex : 'initi',
					width : 100,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g("药品Id"),
					dataIndex : 'inci',
					width : 80,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g('药品代码'),
					dataIndex : 'inciCode',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g('药品名称'),
					dataIndex : 'inciDesc',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : $g("批次Id"),
					dataIndex : 'inclb',
					width : 180,
					align : 'left',
					sortable : true,
					hidden : true
				}, {
					header : $g("批次/效期"),
					dataIndex : 'batexp',
					width : 150,
					align : 'left',
					sortable : true
				}, {
					header : $g("生产企业"),
					dataIndex : 'manfName',
					width : 180,
					align : 'left',
					sortable : true
				}, {
					header : $g("批次库存"),
					dataIndex : 'inclbQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("转移数量"),
					dataIndex : 'qty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("转移单位"),
					dataIndex : 'TrUomDesc',
					width : 80,
					align : 'left',
					sortable : true
				}, {
					header : $g("进价"),
					dataIndex : 'rp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("售价"),
					dataIndex : 'sp',
					width : 60,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("请求数量"),
					dataIndex : 'reqQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("货位码"),
					dataIndex : 'reqstkbin',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("请求方库存"),
					dataIndex : 'reqLocStkQty',
					width : 100,
					align : 'right',
					sortable : true
				}, {
					header : $g("占用数量"),
					dataIndex : 'inclbDirtyQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("可用数量"),
					dataIndex : 'inclbAvaQty',
					width : 80,
					align : 'right',
					sortable : true
				}, {
					header : $g("批次售价"),
					dataIndex : 'newSp',
					width : 100,
					align : 'right',
					
					sortable : true
				}, {
					header : $g("规格"),
					dataIndex : 'spec',
					width : 100,
					align : 'left',
					sortable : true
				},{
					header : $g("处方通用名"),
					dataIndex : 'gene',
					width : 120,
					align : 'left',
					sortable : true
				}, {
					header : $g("剂型"),
					dataIndex : 'formDesc',
					width : 100,
					align : 'left',
					sortable : true
				}, {
					header : $g("售价金额"),
					dataIndex : 'spAmt',
					width : 100,
					align : 'right',					
					sortable : true,
					renderer:FormatGridSpAmount
				}, {
					header : $g("进价金额"),
					dataIndex : 'rpAmt',
					width : 100,
					align : 'right',					
					sortable : true,
					renderer:FormatGridRpAmount
				}, {
					header : $g("国家医保编码"),
					dataIndex : 'InsuCode',
					width : 100,
					align : 'right',					
					sortable : true,
				}, {
					header : $g("国家医保名称"),
					dataIndex : 'InsuDesc',
					width : 100,
					align : 'right',					
					sortable : true,
				}]);
       var GridDetailPagingToolbar = new Ext.PagingToolbar({
			store:DetailStore,
			pageSize:PageSize,
			displayInfo:true,
			displayMsg:$g('第 {0} 条到 {1}条, 一共 {2} 条'),
			emptyMsg:$g("没有记录")
		});
		var DetailGrid = new Ext.grid.GridPanel({
					title : '',
					height : 200,
					cm : DetailCm,
					store : DetailStore,
					trackMouseOver : true,
					stripeRows : true,
					bbar:GridDetailPagingToolbar,
					loadMask : true
				});

		var HisListTab = new Ext.form.FormPanel({
			labelWidth : 60,
			labelAlign : 'right',
			title:$g("转移入库查询"),
			frame : true,
			autoHeight:true,
			//autoScroll : true,
			tbar : [SearchBT, '-', ClearBT, '-', PrintBT,'-',GridColSetBT,'-',MZJYAudit1,'-',MZJYAudit2],
			items:[{
				xtype:'fieldset',
				layout:'column',
				defaults:{border:false},
				title:$g('查询条件'),
				style:DHCSTFormStyle.FrmPaddingV,
				items : [{ 				
					columnWidth: 0.2,
					xtype:'fieldset',
	            	items: [RequestPhaLoc,SupplyPhaLoc]
					
				},{ 				
					columnWidth: 0.15,
					xtype:'fieldset',	            	
					items: [StartDate,EndDate]
					
				},{ 				
					columnWidth: 0.23,
					xtype:'fieldset',
	            	items: [StkGrpType,InciDesc]
					
				},{ 				
					columnWidth: 0.23,
					xtype:'fieldset',
					labelWidth:80,
	            	items: [Status,PMZJYFlag]
					
				}]
			}]
		});

		// 页面布局
		var mainPanel = new Ext.Viewport({
					layout : 'border',
					items : [            // create instance immediately
			            {
			                region: 'north',
			                height: DHCSTFormStyle.FrmHeight(2), // give north and south regions a height
			                layout: 'fit', // specify layout manager for items
			                items:HisListTab
			            }, {
			                region: 'center',
			                title: $g('出库单'),			               
			                layout: 'fit', // specify layout manager for items
			                items: MasterGrid       
			               
			            }, {
			                region: 'south',
			                split: true,
                			height: 250,
                			minSize: 200,
                			maxSize: 350,
                			collapsible: true,
			                title: $g('出库单明细'),
			                layout: 'fit', // specify layout manager for items
			                items: DetailGrid       
			               
			            }
	       			],
					renderTo : 'mainPanel'
				});
		RefreshGridColSet(MasterGrid,"DHCSTTRANSFER");   
		RefreshGridColSet(DetailGrid,"DHCSTTRANSFER"); 
	}

})
