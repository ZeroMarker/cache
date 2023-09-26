// /名称: 采购计划审批
// /描述: 采购计划审批
// /编写者：zhangdongmei
// /编写日期: 2012.07.30

//保存参数值的object
var InPurPlanParamObj = GetAppPropValue('DHCSTPURPLANAUDITM');
var timer=null;
Ext.Ajax.timeout=12000;
Ext.onReady(function() {
	var userId = session['LOGON.USERID'];
	var groupId=session['LOGON.GROUPID'];

	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	// 采购科室
	var PhaLoc = new Ext.ux.LocComboBox({
				fieldLabel : '采购部门',
				id : 'PhaLoc',
				name : 'PhaLoc',
				anchor :'90%',
				emptyText : '采购部门...',
				groupId:session['LOGON.GROUPID'],
				childCombo : 'Vendor'
			});

	var PurNo = new Ext.form.TextField({
				fieldLabel : '采购单号',
				id : 'PurNo',
				name : 'PurNo'
			});
			
	var includeDefLoc=new Ext.form.Checkbox({
			id: 'defLocPP',
			fieldLabel:'包含支配科室',
			allowBlank:true
	});
	var Auditted=new Ext.form.Checkbox({
			id: 'Auditted',
			fieldLabel:'仅包含已审核',
			allowBlank:true,
			handler: function() {
				changeButEnable();
			}
	});
	function changeButEnable() {
		var AuditFlag = Ext.getCmp("Auditted").getValue(); 
		if (AuditFlag == true) {
			CheckBT.setDisabled(true);
			DeniedBT.setDisabled(true);
		} else {
			CheckBT.setDisabled(false);
			DeniedBT.setDisabled(false);
		}
	}
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
				width : 120,
				value : DefaultStDate()
			});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
				fieldLabel : '截止日期',
				id : 'EndDate',
				name : 'EndDate',
				
				width : 120,
				value : DefaultEdDate()
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
	/**
	 * 查询方法
	 */
	function Query() {
		changeButEnable();
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
		var Auditted=Ext.getCmp('Auditted').getValue();  //仅包含已审核(自己级别审核)
		///审核级别参数(0:过滤已审核[任一级别],仅查询未审核, 1:缺省(审核中尚未审核完成), 2:仅查询完全审核), 3:不控制,4：本安全组级别已审核 5：该本级别审核
		var AuditLevel='';
		if(Auditted){
			AuditLevel=4
		}else{
			AuditLevel=5		
		}
		
		//科室id^开始日期^截止日期^计划单号^类组id^供应商id^物资id^完成标志^审核标志
		var ListParam=phaLoc+'^'+startDate+'^'+endDate+'^'+purno+'^^'+vendor+'^^'+CmpFlag+'^'+''+"^"+includeDefLoc+"^"+AuditLevel+'^^^^^'+groupId;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('strParam',ListParam);
		MasterStore.removeAll();
		DetailGrid.store.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback:function(r,options,success){
				if(!success){
					Msg.info("error","查询有误,请查看日志!");
				}else if(r.length>0){
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
		Ext.getCmp("defLocPP").setValue(false);
		Ext.getCmp("Auditted").setValue(false);
		
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
	}
	var PrintBT = new Ext.Toolbar.Button({
		id : "PrintBT",
		text : '打印',
		tooltip : '点击打印采购单',
		width : 70,
		height : 30,
		iconCls : 'page_print',
		handler : function() {
			var rowData=MasterGrid.getSelectionModel().getSelected();
			if (rowData ==null) {
				Msg.info("warning", "请选择需要打印的采购计划单!");
				return;
			}
			var purId = rowData.get("RowId");
			PrintInPur(purId);
		}
	});
	// 审批按钮
	var CheckBT = new Ext.Toolbar.Button({
				id : "CheckBT",
				text : '审核通过',
				tooltip : '点击审核通过',
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
				text : '审批不通过',
				tooltip : '点击审批不通过',
				width : 70,
				height : 30,
				iconCls : 'page_delete',
				handler : function() {
					Deny();								
				}
			});
	/**
	 * 审批采购计划单
	 */
	function Audit() {
		var PuridStr="";
		var rowData = MasterGrid.getSelectionModel().getSelections();
		if (Ext.isEmpty(rowData)) {
			Msg.info("warning", "请选择要审批的采购单!");
			return false;
		}
		for (var i=0;i<rowData.length;i++)
		{
			var record=rowData[i];
			var PurId = record.get("RowId");
			if (PuridStr=="")
			{
				PuridStr= PurId;
			}else{
				PuridStr= PuridStr+"^"+PurId;
			} 
		}
		if (Ext.isEmpty(PuridStr)) {
			Msg.info("warning", "请选择要审批的采购单!");
			return false;
		}
		//获取修改明细20191022
		var rowCount = DetailGrid.getStore().getCount();
		var ListDetail="";
		for (var i = 0; i < rowCount; i++) {
			var rowData = DetailStore.getAt(i);	
			if(rowData.dirty){
				var RowId = rowData.get("RowId");
				var Qty = rowData.get("Qty");
				var str =RowId+"^"+Qty
				if(ListDetail==""){
					ListDetail=str
					}
				else {
					ListDetail=ListDetail+xRowDelim()+str;
					}	
			}	
		}
		var url = DictUrl
				+ "inpurplanaction.csp?actiontype=AuditStr&rowid="
				+ PuridStr + "&userId=" + userId +"&groupId=" + groupId
				+"&ListDetail=" +ListDetail;
		var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					waitMsg : '查询中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						loadMask.hide();
						if (jsonData.success == 'true') {
							// 审核单据
							
							var infoarr=jsonData.info.split("^");
							var allcount=infoarr[0];
							var succount=infoarr[1];
							Msg.info("success", "共"+allcount+"条记录,成功审核"+succount+"条记录！");
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
	function Deny() {
		var rowData = MasterGrid.getSelectionModel().getSelected();
		if (rowData ==null) {
			Msg.info("warning", "请选择审批不通过的采购单!");
			return;
		}
		var PurId = rowData.get("RowId");
		var RefuseCase=rowData.get("RefuseCase");
		if(Ext.isEmpty(RefuseCase)){
			Msg.info('error', '请填写拒绝原因!');
			return false;
		}
		var url = DictUrl
				+ "inpurplanaction.csp?actiontype=Deny&rowid="
				+ PurId + "&userId=" + userId +"&groupId=" + groupId;
		var loadMask=ShowLoadMask(Ext.getBody(),"处理中...");
		Ext.Ajax.request({
					url : url,
					params : {RefuseCase:RefuseCase},
					method : 'POST',
					waitMsg : '查询中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						loadMask.hide();
						if (jsonData.success == 'true') {
							Msg.info("success", "审批不通过成功!");
							Query();
						}else {
							var Ret=jsonData.info;
							if(Ret==-1){
								Msg.info("error","您无审批权限,不能拒绝!");
							}else if(Ret==-2){
								Msg.info("error", "已审批,不能拒绝!");
							}else if(Ret==-10){
								Msg.info("error", "上一级未审批")
							}else {
								Msg.info("error", "审核失败:"+Ret);
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
	var MasterUrl = DictUrl	+ 'inpurplanaction.csp?actiontype=query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["RowId", "PurNo", "LocId", "Loc", "Date", "User","PoFlag", "CmpFlag","StkGrpId", "StkGrp", "DHCPlanStatus", "DHCPlanStatusDesc","RefuseCase"];
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
	function querysum(){
		tabpanel.fireEvent('tabchange',tabpanel,tabpanel.getActiveTab());
	
	}
	var nm = new Ext.grid.RowNumberer();
	var sm = new Ext.grid.CheckboxSelectionModel({
		listeners:{
			selectionchange:function (dsm){
				clearTimeout(timer)
				timer=querysum.defer(100,this)
			}
		}
	});
	var MasterCm = new Ext.grid.ColumnModel([nm,sm, {
				header : "RowId",
				dataIndex : 'RowId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "采购计划单号",
				dataIndex : 'PurNo',
				width : 120,
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
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "制单人",
				dataIndex : 'User',
				width : 90,
				align : 'left',
				sortable : true
			}, {
				header : "是否已生成订单",
				dataIndex : 'PoFlag',
				width : 100,
				align : 'center',
				sortable : true,
				renderer:rendorPoFlag
			}, {
				header : "完成标志",
				dataIndex : 'CmpFlag',
				width : 100,
				align : 'center',
				sortable : true,
				renderer:rendorCmpFlag
			}, {
				header : "类组",
				dataIndex : 'StkGrp',
				width : 100,
				align : 'left',
				sortable : true
			},{
	            header:"审核状态",
                dataIndex:'DHCPlanStatusDesc',
                width:250,
                align:'left',
                sortable:true
			},{
	            header:"拒绝原因",
                dataIndex:'RefuseCase',
                width:250,
                align:'left',
                sortable:true,
                editor:new Ext.form.TextField()
			}
	]);
	MasterCm.defaultSortable = true;
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true
	});
	var MasterGrid = new Ext.grid.EditorGridPanel({
				region : 'center',
				title: '采购单',
				cm : MasterCm,
				sm : sm,
				store : MasterStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				bbar:[GridPagingToolbar]
			});

	// 添加表格单击行事件
	/*MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r) {
		var PurId = MasterStore.getAt(rowIndex).get("RowId");
		DetailStore.removeAll();
		DetailStore.setBaseParam('sort','Rowid');
		DetailStore.setBaseParam('dir','Desc');
		DetailStore.setBaseParam('parref',PurId);
		DetailStore.load({params:{start:0,limit:20,sort:'Rowid',dir:'Desc',parref:PurId}});
	});*/

	// 转移明细
	// 访问路径
	var DetailUrl =  DictUrl
				+ 'inpurplanaction.csp?actiontype=queryItem';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : DetailUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["RowId", "IncId","IncCode","IncDesc", "Spec","SpecDesc", "Manf", "Qty","UomId",
			 "Uom", "Rp", "Sp","RpAmt","SpAmt","Vendor", "Carrier", "Gene", "GoodName",
			"Form", "ReqLoc", "StkQty", "MaxQty","MinQty"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "RowId",
				fields : fields
			});
	// 数据集
	var DetailStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
				header : "RowId",
				dataIndex : 'RowId',
				width : 100,
				align : 'left',
				sortable : true,
				hidden : true
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
			}, {
				header : "规格",
				dataIndex : 'Spec',
				width : 180,
				align : 'left',
				sortable : true
			} ,{
				header : "具体规格",
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
				sortable : true,
				editor:new Ext.form.NumberField({selectOnFocus:true})
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
			}]);
	var DetailGridPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:20,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	
	var DetailGrid = new Ext.grid.EditorGridPanel({
				minSize: 200,
				maxSize: 350,
				collapsible: true,
				cm : DetailCm,
				store : DetailStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				//bbar:DetailGridPagingToolbar,
				sm : new Ext.grid.CellSelectionModel({}),
	            clicksToEdit:1
			});
	DetailGrid.addListener("rowcontextmenu",function(grid,rowindex,e){
		e.preventDefault();
		menu.showAt(e.getXY());		
	});
	var menu=new Ext.menu.Menu({
		id:'rightMenu',
		height:30,
		items:[{
			id:'ChangeDetail',
			text:'修改记录',
			handler:GetChangeDetail
		}]
	});
   function GetChangeDetail(){
	   var cell = DetailGrid.getSelectionModel().getSelectedCell();
	   if (cell == null) {
			Msg.info("warning", "没有选中行!");
			return;
		}
		var row = cell[0];
		var record = DetailGrid.getStore().getAt(row);
		var RowId = record.get("RowId");
	   ChangeDetailQuery(RowId)
	   }
	var HisListTab = new Ext.form.FormPanel({
		region : 'north',
		autoHeight : true,
		title:'采购计划审批',
		labelWidth: 100,	
		labelAlign : 'right',
		frame : true,
		tbar : [SearchBT, '-', ClearBT, '-', CheckBT, '-',DeniedBT, '-',PrintBT],
		items : [{
			xtype:'fieldset',
			title:'查询条件',
			layout: 'column',    // Specifies that the items will now be arranged in columns
			defaults: {border:false},    // Default config options for child items
			style : 'padding:5px 0px 0px 5px',
			items:[{ 				
				columnWidth: 0.34,
	        	xtype: 'fieldset',
	        	items: [PhaLoc,Vendor]
			},{
				columnWidth: 0.2,
	        	xtype: 'fieldset',
	        	items: [StartDate,EndDate]
			},{
				columnWidth: 0.33,
	        	xtype: 'fieldset',
	        	items: [PurNo,includeDefLoc]
			},{
				columnWidth: 0.13,
	        	xtype: 'fieldset',
	        	items: [Auditted]
			}]
		}]
		
	});
	var PurPlanitmPanel=new Ext.Panel({
			title:"采购计划明细",
			id:"PurPlanitmPanel",
			layout:"fit",
			items:DetailGrid
	});
	var PurPlanitmStatPanel=new Ext.Panel({
			title:"采购计划汇总",
			id:"PurPlanitmStatPanel",
			layout:"fit",
			html:'<iframe id="framePurPlanitmStat" height="100%" width="100%" src="../scripts/dhcstm/ExtUX/images/logon_bg.jpg"/>'
	});
	var tabpanel=new Ext.TabPanel({
			region:"south",
			activeTab:0,
			height: gGridHeight,
			items:[PurPlanitmPanel,PurPlanitmStatPanel],
			listeners:{
					tabchange:function(tabpanel,panel){
							var PuridStr="";
							var rowData = MasterGrid.getSelectionModel().getSelections();
							for (var i=0;i<rowData.length;i++)
							{
								var record=rowData[i];
								var PurId = record.get("RowId");
								if (PuridStr=="")
								{
									PuridStr= PurId;
								}else{
									PuridStr= PuridStr+","+PurId;
								} 
							}
							if (panel.id=="PurPlanitmPanel"){
								DetailStore.removeAll();
								DetailStore.setBaseParam('sort','Rowid');
								DetailStore.setBaseParam('dir','Desc');
								//DetailStore.setBaseParam('parref',PuridStr);
								DetailStore.load({params:{start:0,limit:999,sort:'Rowid',dir:'Desc',parref:PuridStr}});
	
							}else if (panel.id=="PurPlanitmStatPanel"){
								var p_Url=PmRunQianUrl+'?reportName=DHCSTM_INPURPLAN_Stat.raq'+
								'&Parref='+PuridStr;
								var ReportFrame=document.getElementById("framePurPlanitmStat");
								ReportFrame.src=p_Url;
							}
						}	
				}
			
	});
	// 页面布局
	var mainPanel = new Ext.ux.Viewport({
				layout : 'border',
				items : [HisListTab, MasterGrid, tabpanel]
			});
			
	Query();
})