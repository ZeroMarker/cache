// /名称: 采购计划审批
// /描述: 采购计划审批
// /编写者：zhangdongmei
// /编写日期: 2012.07.30
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];
	var gLocId=session['LOGON.CTLOCID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	// 采购科室
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '采购部门',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor : '90%',
				emptyText : '采购部门...',
				groupId:session['LOGON.GROUPID'],
				childCombo : 'Vendor'
			});

	var PurNo = new Ext.form.TextField({
				fieldLabel : '采购单号',
				id : 'PurNo',
				name : 'PurNo',
				anchor : '90%',
				width : 120
			});
	// 物资类组
		var StkGrpType=new Ext.ux.StkGrpComboBox({ 
			id : 'StkGrpType',
			name : 'StkGrpType',
			StkType:App_StkTypeCode,     //标识类组类型
			LocId:gLocId,
			UserId:userId,
			anchor:'90%',
			width : 200
		}); 		
	var includeDefLoc=new Ext.form.Checkbox({
			id: 'defLocPP',
			fieldLabel:'包含支配科室',
			anchor:'90%',
			width:150,
			checked:true,
			allowBlank:true
	});
	
	// 供应商
	var Vendor = new Ext.ux.VendorComboBox({
			fieldLabel : '供应商',
			id : 'Vendor',
			name : 'Vendor',
			anchor : '90%',
			emptyText : '供应商...',
			params : {LocId : 'PhaLoc'}
	});
		
	// 起始日期
	var StartDate = new Ext.ux.DateField({
				fieldLabel : '起始日期',
				id : 'StartDate',
				name : 'StartDate',
				anchor : '90%',
				
				width : 120,
				value : new Date().add(Date.DAY, - 30)
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDate',
				name : 'EndDate',
				anchor : '90%',
				
				width : 120,
				value : new Date()
			});

	// 查询按钮
	var SearchBT = new Ext.Toolbar.Button({
				text : '查询',
				tooltip : '点击查询',
				width : 70,
				height : 30,
				iconCls : 'page_find',
				handler : function() {
					Query();
				}
			});
	function filterRepeatStr(str){ 
var ar2 = str.split("^"); 
var array = new Array(); 
var j=0 
for(var i=0;i<ar2.length;i++){ 
if((array == "" || array.toString().match(new RegExp(ar2[i],"g")) == null)&&ar2[i]!=""){ 
array[j] =ar2[i]; 
array.sort(); 
j++; 
} 
} 
return array.toString(); 
}
	/**
	 * 查询方法
	 */
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc == null || phaLoc.length <= 0) {
			Msg.info("warning", "请选择采购部门!");
			return;
		}
		var vendor = Ext.getCmp("Vendor").getValue();
		var startDate = Ext.getCmp("StartDate").getValue();
		if(Ext.isEmpty(startDate)){
			Msg.info('warning', '起始日期不可为空');
			return false;
		}
		startDate = startDate.format(ARG_DATEFORMAT);
		var endDate = Ext.getCmp("EndDate").getValue();
		if(Ext.isEmpty(endDate)){
			Msg.info('warning', '截止日期不可为空');
			return false;
		}
		endDate = endDate.format(ARG_DATEFORMAT);
		var purno = Ext.getCmp("PurNo").getValue();
		var CmpFlag = "Y";
		
		var includeDefLoc=(Ext.getCmp('defLocPP').getValue()==true?1:0);  //是否包含支配科室
		var StkGrp=Ext.getCmp("StkGrpType").getValue();
		//科室id^开始日期^截止日期^计划单号^类组id^供应商id^物资id^完成标志^审核标志
		var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+purno+'^'+StkGrp+'^'+vendor+'^^'+CmpFlag+'^N'+"^"+includeDefLoc;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('strParam',ListParam);
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options,success){
				if(!success){
					Msg.info("error","查询有误,请查看日志!");
				}
			}
		});
	}

	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
				text : '清空',
				tooltip : '点击清空',
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
		SetLogInDept(Ext.getCmp("PhaLoc").getStore(),"PhaLoc");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("Vendor").setValue("");
		Ext.getCmp("PurNo").setValue("");
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
	}

	// 审批按钮
	var CheckBT = new Ext.ux.Button({
				id : "CheckBT",
				text : '审批',
				tooltip : '点击审批',
				width : 70,
				height : 30,
				iconCls : 'page_gear',
				handler : function() {
					Audit();
				}
			});
	// 拒绝按钮
	var DeniedBT = new Ext.Toolbar.Button({
				id : "DeniedBT",
				text : '拒绝一条',
				tooltip : '点击拒绝',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {
					DenyDetail();								
				}
			});
	/**
	 * 审批采购计划单
	 */
	function Audit() {
		
		var rowDataarr = MasterGrid.getSelectionModel().getSelections();
		if (Ext.isEmpty(rowDataarr)) {
			Msg.info("warning", "请选择要审批的采购单!");
			return;
		}
		var count=rowDataarr.length;
		var inppstr=""
		for (i=0;i<count;i++)
		{
			var rowData=rowDataarr[i];
			var inppid=rowData.get('Parref');
			if (inppstr=="")
			 {inppstr=inppid}
			 else
			 {inppstr=inppstr+"^"+inppid}
				
		}
		
		inppstr=filterRepeatStr(inppstr)  ///去除重复
		var url = DictUrl
				+ "inpurplanaction.csp?actiontype=AuditStr";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params: {rowid:inppstr,userId:userId,groupId:groupId},
					waitMsg : '查询中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							// 审核单据
							Msg.info("success", "审批成功!");
							Query();
						} else {
							var Ret=jsonData.info;
							if(Ret==-10){
								Msg.info("warning","采购物资中存在供应商为空的记录，不能生成订单!");
							}
							else if(Ret==-2){
								Msg.info("error", "更新计划单审批标志失败!");
							}else if(Ret==-3){
								Msg.info("error", "保存订单主表信息失败!");
							}else if(Ret==-4){
								Msg.info("error", "保存订单明细失败!");
							}else if(Ret==-5){
								Msg.info("error", "计划单已经审批!");
							}else if(Ret==-101){
								Msg.info("error", "您没有审批权限!");
							}else if(Ret==-103){
								Msg.info("error", "您的安全组已经审批完成!");
							}else if(Ret==-104){
								Msg.info("error", "上一级审批未完成!");
							}else if(Ret==-102){
								Msg.info("error", "保存审批记录失败!");
							}else{
								Msg.info("error", "审批失败:"+Ret);
							}
						}
					},
					scope : this
				});
	}
	/**
	 * 拒绝采购计划单
	 */
	function DenyDetail() {
		var rowDataarr = MasterGrid.getSelectionModel().getSelections();
		if (rowDataarr ==null) {
			Msg.info("warning", "请选择要拒绝的明细!");
			return;
		}
		var count=rowDataarr.length;
		if (count!=1){
			Msg.info("warning", "请选择一条要拒绝的明细!");
			return;}
		var inppistr=""
		for (i=0;i<count;i++)
		{
			var rowData=rowDataarr[i];
			var inppi=rowData.get('RowId');
			if (inppistr=="")
			 {inppistr=inppi}
			 else
			 {inppistr=inppistr+","+inppi}
				
		}

		var url = DictUrl
				+ "inpurplanaction.csp?actiontype=DenyDetail";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '查询中...',
					params: {RowIdStr:inppistr,userId:userId},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							Msg.info("success", "拒绝成功!");
							Query();
						}else {
							var Ret=jsonData.info;
							if(Ret==-1){
								Msg.info("error","您无审批权限,不能拒绝!");
							}else if(Ret==-2){
								Msg.info("error", "已审批,不能拒绝!");
							}else {
								Msg.info("error", "拒绝失败:"+Ret);
							}
						}
					},
					scope : this
				});
	}
	function rendorPoFlag(value){
        return value=='Y'? '是': '否';
    }
    function rendorCmpFlag(value){
        return value=='Y'? '完成': '未完成';
    }
	

	// 访问路径
	var MasterUrl = DictUrl	+ 'inpurplanaction.csp?actiontype=querydetail';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["Parref","RowId", "PurNo", "LocId", "Loc", "Date", "User","PoFlag", "CmpFlag",
				"StkGrpId", "StkGrp", "DHCPlanStatus", "DHCPlanStatusDesc",
				 "IncId","IncCode","IncDesc", "Spec","SpecDesc", "Manf", "Qty","UomId",
			 	"Uom", "Rp", "Sp","RpAmt","SpAmt","Vendor", "Carrier", "Gene", "GoodName",
				"Form", "ReqLoc", "StkQty", "MaxQty","MinQty","Mobile","reqremark"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "RowId",
				fields : fields
			});
	// 数据集
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var sm=new Ext.grid.CheckboxSelectionModel()
	var MasterCm = new Ext.grid.ColumnModel([nm,sm,{
				header : "RowId",
				dataIndex : 'RowId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "电话",
				dataIndex : 'Mobile',
				width : 100,
				align : 'left',
				sortable : true
			},{
				header : "采购计划单号",
				dataIndex : 'PurNo',
				width : 140,
				align : 'left',
				sortable : true
			}, {
				header : "采购部门",
				dataIndex : 'Loc',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "制单日期",
				dataIndex : 'Date',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "制单人",
				dataIndex : 'User',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : "是否已生成订单",
				dataIndex : 'PoFlag',
				width : 40,
				align : 'center',
				sortable : true,
				renderer:rendorPoFlag
			}, {
				header : "完成标志",
				dataIndex : 'CmpFlag',
				width : 40,
				align : 'center',
				sortable : true,
				renderer:rendorCmpFlag
			}, {
				header : "类组",
				dataIndex : 'StkGrp',
				width : 80,
				align : 'left',
				sortable : true
			},{
	            header:"审核状态",
                dataIndex:'DHCPlanStatusDesc',
                width:80,
                align:'left',
                sortable:true
			}, {
				header : "物资Id",
				dataIndex : 'IncId',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : '物资代码',
				dataIndex : 'IncCode',
				width : 80,
				align : 'left',
				sortable : true
			}, {
				header : '物资名称',
				dataIndex : 'IncDesc',
				width : 180,
				align : 'left',
				sortable : true
			},{
				header : "具体列表",
				dataIndex : 'SpecDesc',
				width : 180,
				align : 'left',
				sortable : true
			}, {
				header : "厂商",
				dataIndex : 'Manf',
				width : 150,
				align : 'left',
				sortable : true
			}, {
				header : "采购数量",
				dataIndex : 'Qty',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "单位",
				dataIndex : 'Uom',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "进价",
				dataIndex : 'Rp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "售价",
				dataIndex : 'Sp',
				width : 60,
				align : 'right',
				sortable : true
			}, {
				header : "进价金额",
				dataIndex : 'RpAmt',
				width : 100,
				align : 'right',
				
				sortable : true
			}, {
				header : "售价金额",
				dataIndex : 'SpAmt',
				width : 100,
				align : 'right',
				sortable : true
			}, {
				header : "供应商",
				dataIndex : 'Vendor',
				width : 80,
				align : 'right',
				sortable : true
			}, {
				header : "配送商",
				dataIndex : 'Carrier',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "请求科室",
				dataIndex : 'ReqLoc',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "库存",
				dataIndex : 'StkQty',
				width : 120,
				align : 'left',
				sortable : true
			}, {
				header : "库存上限",
				dataIndex : 'MaxQty',
				width : 100,
				align : 'left',
				sortable : true
			}, {
				header : "库存下限",
				dataIndex : 'MinQty',
				width : 100,
				align : 'left',
				sortable : true
			},{
				header:"请求备注",
				dataIndex:'reqremark',
				width:120,
				align:'left'
		}
	]);
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:1000,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	var MasterGrid = new Ext.ux.GridPanel({
				title : '',
				cm : MasterCm,
				sm :sm,
				store : MasterStore,
				bbar:GridPagingToolbar
			});

	
	
	

	var HisListTab = new Ext.form.FormPanel({
		labelWidth: 100,	
		labelAlign : 'right',
		frame : true,
		tbar : [SearchBT, '-', ClearBT, '-', CheckBT, '-',DeniedBT],
		items : [{
			xtype:'fieldset',
			title:'查询条件',
			layout: 'column',    // Specifies that the items will now be arranged in columns
			defaults: {width: 220, border:false},    // Default config options for child items
			style : 'padding:5px 0px 0px 5px',
			items:[{ 				
				columnWidth: 0.3,
	        	xtype: 'fieldset',        	
	        	items: [PhaLoc,Vendor]				
			},{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',	        	
	        	items: [StartDate,EndDate]				
			},{ 				
				columnWidth: 0.25,
	        	xtype: 'fieldset',	      
	        	items: [PurNo,StkGrpType]
			},{ 				
				columnWidth: 0.2,
	        	xtype: 'fieldset',	      
	        	items: [includeDefLoc]
			}]
		}]
		
	});

	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [            // create instance immediately
		            {
		                region: 'north',
		                title:'采购计划审批',
		                height: 160, // give north and south regions a height
		                layout: 'fit', // specify layout manager for items
		                items:HisListTab
		            }, {
		                region: 'center',
		                title: '采购单明细',
		                layout: 'fit', // specify layout manager for items
		                items: MasterGrid
		            }
       			],
				renderTo : 'mainPanel'
			});
})