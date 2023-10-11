// /名称: 转移入库审核
// /描述: 转移入库审核
// /编写者：zhangdongmei
// /编写日期: 2012.07.27
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var gGroupId=session['LOGON.GROUPID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	//取参数配置
	if(gParam==null ||gParam.length<1){			
		GetParam();		
	}
	if(gParamCommon.length<1){
		GetParamCommon();  //初始化公共参数配置
	}
		// 请求部门
	var RequestPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('请求部门'),
				id : 'RequestPhaLoc',
				name : 'RequestPhaLoc',					
				anchor: '90%',
				emptyText:$g('请求部门'),
				groupId:gGroupId
				//defaultLoc:''
			});

	// 供给部门
	var SupplyPhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : $g('供给部门'),
				id : 'SupplyPhaLoc',
				name : 'SupplyPhaLoc',	
				emptyText:$g('供给部门'),
				anchor : '90%',
				//groupId:gGroupId
				defaultLoc:''
			});

	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : $g('起始日期'),
				id : 'StartDate',
				name : 'StartDate',
				anchor : '80%',
				width : 120,
				value : DefaultStDate()
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel :$g( '截止日期'),
				id : 'EndDate',
				name : 'EndDate',
				anchor : '80%',
				width : 120,
				value : DefaultEdDate()
			});

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
		var requestphaLoc = Ext.getCmp("RequestPhaLoc").getValue();
		var startDate = Ext.getCmp("StartDate").getRawValue();
		var endDate = Ext.getCmp("EndDate").getRawValue();
		var statue = "21";
		
		var ListParam=startDate+'^'+endDate+'^'+supplyphaLoc+'^'+requestphaLoc+'^Y^'+statue+'^^';
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		MasterStore.removeAll();
		MasterStore.load({params:{start:0, limit:Page}});
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
		Ext.getCmp("StartDate").setValue(DefaultStDate());
		Ext.getCmp("EndDate").setValue(DefaultEdDate());
		SetLogInDept(PhaDeptStore, "RequestPhaLoc");
		Ext.getCmp("SupplyPhaLoc").setValue("");
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}

	// 审批按钮
	var CheckBT = new Ext.Toolbar.Button({
				id : "CheckBT",
				text :$g( '接收'),
				tooltip : $g('点击接收'),
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					AuditPart();
				}
			});

	/**
	 * 审批转移单入库
	 */
	 ///部分接收
	function AuditPart(){
		var j=0
		var strrowid=""
		var sm = DetailGrid.getSelectionModel();
		var store = DetailGrid.getStore();
		var rowCount = DetailGrid.getStore().getCount();
		//sm.selectAll() 
		for (var i = 0; i < rowCount; i++) {			
			      
				//循环每条选择的数据
				if(sm.isSelected(i)==false){
					var record = store.getAt(i);
					var detailId = record.get('initi');
					j=j+1
					if(j==1){strrowid=detailId}
					else{strrowid=strrowid + "!" + detailId}
				}
		}
		if(j>0){
			if(rowCount>j){
			   Ext.Msg.show({
				   title:$g('提示'),
				   msg: $g("有") + j +$g( "条明细下次接收，确定吗"),
				   buttons: Ext.Msg.YESNO,
				   fn: function(b,t,o){
				   	if (b=='yes'){AuditEx(strrowid);}
				   },
				   icon: Ext.MessageBox.QUESTION
			   });
			}else if(rowCount==j){
			     Msg.info("warning", $g("请勾选需要接收的明细!"));
			}
		}else {
			AuditEx(strrowid);
		}
	}
	function AuditEx(strrowid) {		
		// 判断转移单是否已审核
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", $g("请选择要接收的转移单!"));
			return;
		}
		var INITState = rowData.get("status");
		if (INITState != "21" && INITState != "32") {
			Msg.info("warning", $g("转移单不是待接收状态，请核实!"));
			return;
		}
		
		var Init = rowData.get("init");
//		var url = DictUrl
//				+ "dhcinistrfaction.csp?actiontype=AuditInPart&Rowid="
//				+ Init + "&User=" + userId + "&Strrowid=" + strrowid;
				
		Ext.Ajax.request({
					//url : url,
					url : DictUrl + "dhcinistrfaction.csp?actiontype=AuditInPart",
					params:{Rowid:Init ,User: userId,Strrowid: strrowid} ,
					
					method : 'POST',
					waitMsg : $g('查询中...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 审核单据
							Msg.info("success", $g("接收成功!"));
							Query();
							//根据参数设置自动打印
							if(gParam[5]=='Y'){
								PrintInIsTrf.defer(300,this,[Init,gParam[8]]);
							}
						} else {
							var Ret=jsonData.info;
							if(Ret==-100){
								Msg.info("error", $g("出库单不是待接收状态!"));
							}else if(Ret==-99){
								Msg.info("error",$g( "加锁失败!"));
							}else if(Ret==-1 || Ret==-2){
								Msg.info("error", $g("更新出库单状态失败!"));
							}else if(Ret==-3){
								Msg.info("error", $g("处理库存失败!"));
							}else if(Ret==-4){
								Msg.info("error", $g("插入台帐失败!"));
							}else{
								Msg.info("error", $g("接收失败:")+Ret);
							}
						}
					},
					scope : this
				});
	}
	function Audit() {
		
		
		// 判断转移单是否已审核
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning",$g( "请选择要接收的转移单!"));
			return;
		}
		var INITState = rowData.get("status");
		if (INITState != "21") {
			Msg.info("warning",$g( "转移单不是待接收状态，请核实!"));
			return;
		}
		var Init = rowData.get("init");
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=AuditIn&Rowid="
				+ Init + "&User=" + userId;
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : $g('查询中...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 审核单据
							Msg.info("success", $g("接收成功!"));
							Query();
							//根据参数设置自动打印
							if(gParam[5]=='Y'){
								PrintInIsTrf(Init,gParam[8]);
							}
						} else {
							var Ret=jsonData.info;
							if(Ret==-100){
								Msg.info("error", $g("出库单不是待接收状态!"));
							}else if(Ret==-99){
								Msg.info("error", $g("加锁失败!"));
							}else if(Ret==-1 || Ret==-2){
								Msg.info("error", $g("更新出库单状态失败!"));
							}else if(Ret==-3){
								Msg.info("error", $g("处理库存失败!"));
							}else if(Ret==-4){
								Msg.info("error", $g("插入台帐失败!"));
							}else if(Ret==-5){
								Msg.info("error", $g("插入转移入库损益失败!"));
							}else{
								Msg.info("error", $g("接收失败:")+Ret);
							}
						}
					},
					scope : this
				});
	}

	// 入库审核拒绝按钮
	var AuditNoBT = new Ext.Toolbar.Button({
				id : "AuditNoBT",
				text : $g('拒绝接收'),
				tooltip : $g('点击拒绝接收'),
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					AuditNo();
				}
			});
	/**
	 * 入库单审核不通过
	*/
	function AuditNo() {
		// 判断转移单是否已审核
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData == null) {
			Msg.info("warning", $g("请选择需要拒绝的转移单!"));
			return;
		}
		var INITState = rowData.get("status");
		if (INITState != "21") {
			Msg.info("warning",$g( "转移单不是待接收状态，请核实!"));
			return;
		}
		var Init = rowData.get("init");
		var url = DictUrl
				+ "dhcinistrfaction.csp?actiontype=AuditInNo&Rowid="
				+ Init + "&User=" + userId;
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : $g('查询中...'),
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 审核单据
							Msg.info("success", $g("成功!"));
							Query();
						} else {
							var Ret=jsonData.info;
							if(Ret==-100){
								Msg.info("error", $g("出库单不是待接收状态!"));
							}else if(Ret==-99){
								Msg.info("error", $g("加锁失败!"));
							}else if(Ret==-1){
								Msg.info("error", $g("更新出库单状态失败!"));
							}else if(Ret==-3){
								Msg.info("error", $g("恢复库存，处理台帐失败!"));
							}else if(Ret==-4){
								Msg.info("error", $g("恢复占用数量失败!"));
							}else if(Ret==-5){
								Msg.info("error", $g("更新出库明细状态失败!"));
							}else if(Ret==-6){
								Msg.info("error", $g("审核后价格变化，拒绝入库插入调价损益表错误"));
							}else if(Ret==-7){
								Msg.info("error", $g("科室月结配置:跨月禁止拒绝接收!"));
							}else if(Ret==-201){
								Msg.info("error", $g("出库科室已经月结，不允许拒绝入库！"));
							}else if(Ret==-202){
								Msg.info("error", $g("该出库单已经做了部分接收，不允许再拒绝接收！"));
							}else{
								Msg.info("error", $g("失败:"+Ret));
							}
						}
					},
					scope : this
				});
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
	"status","RpAmt","SpAmt","MarginAmt","Remark","StatusCode"];
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
			}]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
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
		DetailStore.setBaseParam('Parref',InIt+"^21")
		DetailStore.load({params:{start:0,limit:GridDetailPagingToolbar.pageSize,sort:'Rowid',dir:'Desc'}});
	});
	// 访问路径
	var DetailUrl =  DictUrl
				+ 'dhcinistrfaction.csp?actiontype=QueryInIsTrfDetail';
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
	// hulihua 2016-01-06 增加部分接收选择的功能！		
	DetailStore.addListener('load', function(st, rds, opts) {
    	var sm = DetailGrid.getSelectionModel();
		var store = DetailGrid.getStore();
		var rowCount = DetailGrid.getStore().getCount();
		sm.selectAll() 
    });
       
	// 转移明细的选择框
	var detailSM = new Ext.grid.CheckboxSelectionModel(); 
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm,detailSM, {
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
			},{
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
			}, {
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
		pageSize:999,
		displayInfo:true,
		displayMsg:$g('第 {0} 条到 {1}条 ，一共 {2} 条'),
		emptyMsg:$g("没有记录")
	});
	var DetailGrid = new Ext.grid.GridPanel({
				title : '',
				height : 200,
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				sm :detailSM,
				bbar:GridDetailPagingToolbar,
				loadMask : true
			});

	var HisListTab = new Ext.form.FormPanel({
		labelWidth: 60,	
		labelAlign : 'right',
		frame : true,
		autoHeight:true,
		tbar : [SearchBT, '-', ClearBT, '-', CheckBT,'-',AuditNoBT,'-',GridColSetBT],
		items:[{
			xtype:'fieldset',
			title:$g('查询条件'),
			style:DHCSTFormStyle.FrmPaddingV,
			defaults: {border:false,width: 220},    // Default config options for child items
			layout: 'column',    // Specifies that the items will now be arranged in columns
			items : [{ 				
				columnWidth: 0.25,
            	xtype: 'fieldset',
            	items: [SupplyPhaLoc]
				
			},{ 				
				columnWidth: 0.25,
            	xtype: 'fieldset',
            	items: [RequestPhaLoc]
				
			},{ 				
				columnWidth: 0.25,
            	xtype: 'fieldset',
            	items: [StartDate]
				
			},{ 				
				columnWidth: 0.25,
            	xtype: 'fieldset',
            	items: [EndDate]
				
			}]
		}]			
	});

	// 页面布局
	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [            // create instance immediately
		            {
		            	title:$g('转移入库接收'),
		                region: 'north',
		                height: DHCSTFormStyle.FrmHeight(1), // give north and south regions a height
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
            			height: 300,
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
	Query();
	

})
