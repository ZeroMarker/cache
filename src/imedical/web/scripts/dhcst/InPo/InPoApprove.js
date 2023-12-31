// /名称: 订单验收
// /描述: 订单验收
// /编写者：zhangdongmei
// /编写日期: 2012.10.08

	var gGroupId = session['LOGON.GROUPID'];
	var userId = session['LOGON.USERID'];
	var PhaLoc = new Ext.ux.LocComboBox({
		fieldLabel : '科室',
		id : 'PhaLoc',
		name : 'PhaLoc',
		anchor : '90%',
		groupId : gGroupId
	});
	// 登录设置默认值
	SetLogInDept(PhaLoc.getStore(), "PhaLoc");
	var RequestPhaLoc = new Ext.ux.LocComboBox({
					fieldLabel : '请求部门',
					id : 'RequestPhaLoc',
					name : 'RequestPhaLoc',
					anchor:'90%',
					width : 120,
					emptyText : '请求部门...',
					defaultLoc:{}
		});	
	// 起始日期
	var StartDate = new Ext.ux.DateField({
		fieldLabel : '起始日期',
		id : 'StartDate',
		name : 'StartDate',
		anchor : '90%',
		
		value : new Date().add(Date.DAY, - 7)
	});
	// 截止日期
	var EndDate = new Ext.ux.DateField({
		fieldLabel : '截止日期',
		id : 'EndDate',
		name : 'EndDate',
		anchor : '90%',
		
		value : new Date()
	});

	var inpoNoField = new Ext.form.TextField({
		id:'inpoNoField2',
		fieldLabel:'订单号',
		allowBlank:true,
		emptyText:'订单号...',
		anchor:'90%',
		selectOnFocus:true
	});
	// 物资名称
	var InciDesc = new Ext.form.TextField({
		fieldLabel : '物资名称',
		id : 'InciDesc',
		name : 'InciDesc',
		anchor : '90%',
		width : 150,
		listeners : {
			specialkey : function(field, e) {
				if (e.getKey() == Ext.EventObject.ENTER) {
					var stktype = '';
					GetPhaOrderInfo(field.getValue(), stktype);
				}
			}
		}
	});
	var IncId = new Ext.form.TextField({
		fieldLabel : '物资名称',
		id : 'IncId',
		name : 'IncId',
		hidden:true
	});
		/**
	 * 调用物资窗体并返回结果
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
		Ext.getCmp("IncId").setValue(inciDr);
	}
	// 供应商
	var apcVendorField = new Ext.ux.VendorComboBox({
		fieldLabel : '供应商',
		id : 'apcVendorField',
		name : 'apcVendorField',
		anchor : '90%',
		emptyText : '供应商...'
	});

		var approveStore = new Ext.data.SimpleStore({
			fields : ['RowId', 'Description'],
			data : [['0', '全部'],['1', '验收完成'], ['2', '验收拒绝'],['3', '未验收']]
		});
		
		var approveflag = new Ext.form.ComboBox({
			fieldLabel : '验收状态',
			id : 'approveflag',
			name : 'approveflag',
			anchor:'90%',
			width : 120,
			store : approveStore,
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
	Ext.getCmp("approveflag").setValue("3");
	var includeDefLoc=new Ext.form.Checkbox({
			id: 'includeDefLoc',
			fieldLabel:'包含支配科室',
			anchor:'90%',
			width:150,
			checked:true,
			allowBlank:true
	});
	// 查询订单按钮
	var SearchBT = new Ext.Toolbar.Button({
		id : "SearchBT",
		text : '查询',
		tooltip : '点击查询订单',
		width : 70,
		height : 30,
		iconCls : 'page_find',
		handler : function() {
			Query();
		}
	});


	// 清空按钮
	var ClearBT = new Ext.Toolbar.Button({
		id : "ClearBT",
		text : '清空',
		tooltip : '点击清空',
		width : 70,
		height : 30,
		iconCls : 'page_clearscreen',
		handler : function() {
			clearData();
		}
	});
	
	var cancelBt=new Ext.Toolbar.Button({
		id : "cancelBT",
		text : '验收不通过',
		iconCls:'page_delete',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function() {
			approve("N")
		}
	})
	// 验收
	var ApproveBT = new Ext.Toolbar.Button({
				id : "ApproveBT",
				text : '验收',
				tooltip : '验收',
				width : 70,
				height : 30,
				iconCls : 'page_refresh',
				handler : function() {approve("Y")}
			});
	
     function approve(flag){

				var recarr=MasterGrid.getSelectionModel().getSelections();
				var count=recarr.length;
				if(count==0){Msg.info("warning","请选择处理的订单!");return};
				var poistr=""
				for (i=0;i<count;i++)
				{
					var rec=recarr[i];
					var poi=rec.get('PoId');
					var Approveed=rec.get('Approveed');
					if(Approveed!=""){Msg.info("warning","存在已经验收单据，不能重复验收!");return};
					if (poistr=="")
			 		{poistr=poi}
			 		else
			 		{poistr=poistr+','+poi}
				}
				
			    var url = DictUrl+ "inpoaction.csp?actiontype=Approve";
			    Ext.Ajax.request({
						url : url,
						params:{poistr:poistr,user:userId,flag:flag},
						method : 'POST',
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON.decode(result.responseText);
							if (jsonData.success == 'true') {
								// 刷新界面
								var ret=jsonData.info;
								Msg.info("success","成功!");	
								MasterStore.reload();
							}else{
								if(jsonData.info==-1){
									Msg.info("error","此单据没有完成，不能验收!");
								}else{
								   Msg.info("error",jsonData.info);
								}
									
							}
						},
						scope : this
					});
				}			
			
	
	/**
	 * 清空方法
	 */
	function clearData() {
		SetLogInDept(PhaLoc.getStore(), "PhaLoc");
		Ext.getCmp("apcVendorField").setValue("");
		Ext.getCmp("inpoNoField2").setValue("");
		Ext.getCmp("IncId").setValue("");
		Ext.getCmp("InciDesc").setValue("");
		Ext.getCmp('approveflag').setValue(false);
		Ext.getCmp('StartDate').setValue(new Date().add(Date.DAY, - 7));
		Ext.getCmp('EndDate').setValue(new Date());
		
		DetailGrid.store.removeAll();
		DetailGrid.getView().refresh();
		
		MasterGrid.store.removeAll();
		MasterGrid.getView().refresh();
		
	}

	// 显示订单数据
	function Query() {
		var phaLoc = Ext.getCmp("PhaLoc").getValue();
		if (phaLoc =='' || phaLoc.length <= 0) {
			Msg.info("warning", "请选择订购部门!");
			return;
		}
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
		var venDesc=Ext.getCmp("apcVendorField").getValue();
		if (venDesc==""){
			Ext.getCmp("apcVendorField").setValue("");
		}
		var Vendor = Ext.getCmp("apcVendorField").getValue();
		var PoNo = Ext.getCmp('inpoNoField2').getValue();
		var Status='';
		var AuditFlag = Ext.getCmp('approveflag').getValue();
		
		var inciDesc=Ext.getCmp("InciDesc").getValue();
		if (inciDesc==""){
			Ext.getCmp("IncId").setValue("");
		}
		var InciId=Ext.getCmp("IncId").getRawValue();
		var includeDefLoc=(Ext.getCmp('includeDefLoc').getValue()==true?1:0);  //是否包含支配科室
		var  RequestPhaLoc=Ext.getCmp("RequestPhaLoc").getValue();
		//开始日期^截止日期^订单号^供应商id^科室id^完成标志^审核标志^订单状态(未入库，部分入库，全部入库)^物资id
		var ListParam=startDate+'^'+endDate+'^'+PoNo+'^'+Vendor+'^'+phaLoc+'^'+''+'^'+AuditFlag+'^'+Status+'^'+InciId+'^'+includeDefLoc+'^'+RequestPhaLoc;
		
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('ParamStr',ListParam);
		MasterStore.load({params:{start:0, limit:Page}});
	}
	// 显示订单明细数据
	function getDetail(Parref) {
		if (Parref == null || Parref=='') {
			return;
		}
		DetailStore.load({params:{start:0,limit:999,Parref:Parref}});
	}
		
	function renderPoStatus(value){
		var PoStatus='';
		if(value=="Y"){
			PoStatus='验收成功';			
		}else if(value=="N"){
			PoStatus='验收拒绝';
		}else{
			PoStatus='未验收';
		}
		return PoStatus;
	}
	// 访问路径
	var MasterUrl = DictUrl	+ 'inpoaction.csp?actiontype=Query';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["PoId", "PoNo", "PoLoc", "Vendor","PoStatus", "PoDate","PurUserId","StkGrpId","VenId","CmpFlag","Approveed","ApproveedUser","ApproveedDate","ReqLocDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "PoId",
				fields : fields
			});
	// 数据集
	var MasterStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader,
				listeners:{
					'load':function(ds){
						DetailGrid.store.removeAll();
						DetailGrid.getView().refresh();
						
//						if (ds.getCount()>0)
//						{
//							MasterGrid.getSelectionModel().selectFirstRow();
//							MasterGrid.getView().focusRow(0);
//						}
					}
				
					
				}
			});
	var nm = new Ext.grid.RowNumberer();
	var sm1=new Ext.grid.CheckboxSelectionModel({})
	var MasterCm = new Ext.grid.ColumnModel([nm,sm1, {
		header : "RowId",
		dataIndex : 'PoId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "订单号",
		dataIndex : 'PoNo',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "订购科室",
		dataIndex : 'PoLoc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "请求科室",
		dataIndex : 'ReqLocDesc',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "供应商",
		dataIndex : 'Vendor',
		width : 120,
		align : 'left',
		sortable : true
	}, {
		header : "验收状态",
		dataIndex : 'Approveed',
		width : 90,
		align : 'left',
		sortable : true,
		renderer:renderPoStatus
	}, {
		header : "订单日期",
		dataIndex : 'PoDate',
		width : 80,
		align : 'right',
		sortable : true
	},{
	
		header : "验收人",
		dataIndex : 'ApproveedUser',
		width : 80,
		align : 'right',
		sortable : true
	},{
	
		header : "验收日期",
		dataIndex : 'ApproveedDate',
		width : 80,
		align : 'right',
		sortable : true
	}
	
	]);
	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
	var MasterGrid = new Ext.grid.GridPanel({
		cm : MasterCm,
		sm : sm1,
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:GridPagingToolbar
		
	});

	MasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, rec) {
		var PoId = rec.get("PoId");
		var Size=DetailPagingToolbar.pageSize;
		DetailStore.setBaseParam('Parref',PoId);
		DetailStore.load({params:{start:0,limit:Size}}); 
	});				
	// 订单明细
	// 访问路径
	var DetailUrl =DictUrl+
		'inpoaction.csp?actiontype=QueryDetail';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
		url : DetailUrl,
		method : "POST"
	});
	// 指定列参数
	//PoItmId^IncId^IncCode^IncDesc^PurUomId^PurUom^NotImpQty^Rp^PurQty^ImpQty
	var fields = ["PoItmId", "IncId", "IncCode","IncDesc","PurUomId", "PurUom", "NotImpQty", "Rp","PurQty","ImpQty","CerNo","CerExpDate","Cancleflag"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "PoItmId",
		fields : fields
	});
	var DetailStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var DetailPagingToolbar = new Ext.PagingToolbar({
		store:DetailStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});
		
	var nm = new Ext.grid.RowNumberer();
	var DetailCm = new Ext.grid.ColumnModel([nm, {
		header : "订单明细id",
		dataIndex : 'PoItmId',
		width : 100,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "物资RowId",
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
		width : 230,
		align : 'left',
		sortable : true
	}, {
		header : "注册证号",
		dataIndex : 'CerNo',
		width : 240,
		align : 'right',
		sortable : true
	}, {
		header : "注册证效期",
		dataIndex : 'CerExpDate',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "单位",
		dataIndex : 'PurUom',
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
		header : "订购数量",
		dataIndex : 'PurQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "到货数量",
		dataIndex : 'ImpQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "未到货数量",
		dataIndex : 'NotImpQty',
		width : 80,
		align : 'right',
		sortable : true
	}, {
		header : "是否撤销",
		dataIndex : 'Cancleflag',
		width : 80,
		align : 'left',
		sortable : true
	}]);
var rightClick = new Ext.menu.Menu({
	id : 'rightClick',
	items: [
		{
			id : 'Pack',
			handler : PackLink,
			text : '包明细'
		}
	] 
});
function PackLink(item,e){
	var Record = DetailGrid.getSelectionModel().getSelected();
	var PackrowId=Record.get("IncId")
	PackLink(PackrowId)
	
}
	var DetailGrid = new Ext.ux.GridPanel({
		id : 'DetailGrid',
		region : 'center',
		cm : DetailCm,
		store : DetailStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		bbar:DetailPagingToolbar,
		listeners : {
		'rowcontextmenu' : function(grid,rowindex,e){
			e.preventDefault();
			grid.getSelectionModel().selectRow(rowindex);
			rightClick.showAt(e.getXY());
		}
	}
	});
	
	var HisListTab = new Ext.ux.FormPanel({
		    title:'订单验收',
			region:'north',
			tbar : [SearchBT, '-',ApproveBT,'-', ClearBT,'-',cancelBt],
			height: 160,
			items : [{
				xtype : 'fieldset',
				title : '查询信息',
				layout : 'column',					
				items : [{
					columnWidth : .2,
					layout : 'form',
					items : [PhaLoc,apcVendorField]
				}, {
					columnWidth : .2,
					layout : 'form',
					items : [StartDate,EndDate]
				}, {
					columnWidth : .2,
					layout : 'form',
					items : [inpoNoField,InciDesc]
				},{
					columnWidth : .2,
					layout : 'form',
					items : [approveflag,RequestPhaLoc]
				},{
					columnWidth : .2,
					layout : 'form',
					items : [includeDefLoc]
				}]
				
			}]		
						
		});
				
	
	// 页面布局
	var mainPanel = new Ext.form.FormPanel({
		region:'center',
		layout:'border',
		items : [{
			region:'west',		
			title:'订单',
			collapsible:true,
	        split:true,
			layout:'fit',
			width:550,
	        minSize:0,
	        maxSize:550,
			items:[MasterGrid]     			
		},{
			region:'center',
			layout:'fit',
			title:'订单明细',
			region:'center',
			items:[DetailGrid]    				
		}]

	});

Ext.onReady(function(){
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	new Ext.ux.Viewport({
		layout:'border',
		items:[HisListTab,mainPanel]
	});
});