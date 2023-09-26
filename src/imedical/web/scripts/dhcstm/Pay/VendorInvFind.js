//描述: 入库单发票组合制单查询
//编写日期: 2014.09.11
var invWindow = null;
function QueryVendorInv(LocRowId,Fn){
	var URL="dhcstm.vendorinvaction.csp";
	var UserId = session['LOGON.USERID'];
	var GroupId=session['LOGON.GROUPID']

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
	
	var FindVendor = new Ext.ux.VendorComboBox({
		fieldLabel : '供应商',
		id : 'FindVendor',
		name : 'FindVendor',
		anchor : '90%',
		emptyText : '供应商...',
		params : {ScgId : 'FindStkGrpType'},
		valueParams : {LocId : LocRowId}
	});
	
	// 类组
	var FindStkGrpType=new Ext.ux.StkGrpComboBox({ 
		id : 'FindStkGrpType',
		name : 'FindStkGrpType',
		anchor:'90%',
		StkType:App_StkTypeCode,     
		LocId:LocRowId,
		UserId:UserId
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
	
	// 确定按钮
	var selectBT = new Ext.Toolbar.Button({
		text : '确定',
		tooltip : '确定',
		width : 70,
		height : 30,
		iconCls : 'page_edit',
		handler : function() {
			returnData();
		}
	});
	
	var CancelBT = new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '点击退出本窗口',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function() {
			invWindow.close();
		}
	});
	
	/**
	 * 查询方法
	 */
	function Query() {
		if (LocRowId == null || LocRowId.length <= 0) {
			return;
		}
		var sd = Ext.getCmp('StartDate').getValue();
		var ed = Ext.getCmp('EndDate').getValue();
		var vendor = Ext.getCmp('FindVendor').getValue();
		var stkGrp = Ext.getCmp('FindStkGrpType').getValue();
		var completed = Ext.getCmp("invStatus").getValue().getGroupValue();
		if(sd!=""){
			sd = sd.format(ARG_DATEFORMAT);
		}
		if(ed!=""){
			ed = ed.format(ARG_DATEFORMAT);
		}
		if(stkGrp==""){
			Msg.info("warning", "请选择类组!");
			return;
		}
		if(sd==""||ed==""){
			Msg.info("warning", "请选择开始日期和截止日期!");
			return; 
		}
		var StrParam=sd+"^"+ed+"^"+LocRowId+"^"+vendor+"^"+completed+"^"+stkGrp+"^^^^";
		FindMasterGridDs.setBaseParam('StrParam',StrParam);
		FindMasterGridDs.removeAll();
		FindDetailGrid.removeAll();
		FindMasterGridDs.load({params:{start:0,limit:MastPagingToolbar.pageSize,sort:'inv',dir:'Desc'}});
		FindMasterGridDs.on('load',function(){
			if (FindMasterGridDs.getCount()>0){
				FindMasterGrid.getSelectionModel().selectFirstRow();
				FindMasterGrid.getView().focusRow(0);
			}
		});
	}
	
	/**
	 * 清空方法
	 */
	function clearData() {
		Ext.getCmp("FindVendor").setValue("");
		Ext.getCmp("FindStkGrpType").setValue("");
		Ext.getCmp("StartDate").setValue(new Date().add(Date.DAY, - 30));
		Ext.getCmp("EndDate").setValue(new Date());
		Ext.getCmp("invStatus").setValue("N");
		FindMasterGridDs.removeAll();
		FindDetailGrid.removeAll();
		MastPagingToolbar.getComponent(4).setValue(1);   //设置当前页码
		MastPagingToolbar.getComponent(5).setText("页,共 1 页");//设置共几页
		MastPagingToolbar.getComponent(12).setText("没有记录"); //设置记录条数
		this.ginvRowId="";
	}
	
	var invStatus = new Ext.form.RadioGroup({
		id : 'invStatus',
		columns : 3,
		items:[
			{boxLabel:'全部',name:'invStatus',inputValue:""},
			{boxLabel:'已完成',name:'invStatus',inputValue:"Y"},
			{boxLabel:'未完成',name:'invStatus',inputValue:"N",checked:true}
		]
	});
	var FindMasterGrid="";
	var FindMasterGridProxy= new Ext.data.HttpProxy({url:URL+'?actiontype=query',method:'GET'});
	var fields = ["inv","assemNo","loc","locDesc","vendor","vendorName","UserName",
				  "invDate","invTime","invComp","scgdr","scgDesc","rpamt","spamt","invNo"];
	var FindMasterGridDs = new Ext.data.Store({
		proxy:FindMasterGridProxy,
    	reader:new Ext.data.JsonReader({
	    	totalProperty : "results",
        	root:'rows',
   			id : "inv",
			fields : fields
		})
	});

	var FindMasterColumns = new Ext.grid.ColumnModel([
		 new Ext.grid.RowNumberer(),
		{
			header : "RowId",
			dataIndex : 'inv',
			hidden : true
		}, {
			header : "发票组合单号",
			dataIndex : 'assemNo',
			width : 120
		}, {
			header : "供应商",
			dataIndex : 'vendorName',
			width : 200
		}, {
			header : "制单日期",
			dataIndex : 'invDate',
			width : 90,
			align : 'center'
		}, {
			header : "制单时间",
			dataIndex : 'invTime',
			width : 90,
			align : 'center'
		}, {
			header : "制单人",
			dataIndex : 'UserName',
			width : 90
		}, {
			header : "组合进价金额",
			dataIndex : 'rpamt',
			xtype : 'numbercolumn',
			width : 90
		}, {
			header : "组合售价金额",
			dataIndex : 'spamt',
			xtype : 'numbercolumn',
			width : 90
		},{
			header : "完成标志",
			dataIndex : 'invComp',
			width :60,
			xtype : 'checkcolumn'
		}, {
			header : "入库退货科室",
			dataIndex : 'locDesc',
			width : 120,
			hidden:true
		}, {
			header : "类组",
			dataIndex : 'scgDesc',
			width : 120,
			hidden:true
		}
	]);
	
	var MastPagingToolbar = new Ext.PagingToolbar({
    	store:FindMasterGridDs,
		pageSize:PageSize,
    	displayInfo:true,
    	displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
    	emptyMsg:"没有记录"
	});

	var FindMasterGrid = new Ext.grid.EditorGridPanel({
		store:FindMasterGridDs,
		cm:FindMasterColumns,
		sm:new Ext.grid.RowSelectionModel({singleSelect : true}),
		trackMouseOver:true,
		height:220,
		stripeRows:true,
		loadMask:true,
		bbar:[MastPagingToolbar],
		listeners : {
			dblclick : function(){
				returnData();
			}
		}
	});
	
	FindMasterGrid.getSelectionModel().on('rowselect', function(sm, rowIndex, r)  {
		var ginvRowId = FindMasterGridDs.getAt(rowIndex).get("inv");
		FindDetailGrid.load({params:{parref:ginvRowId}}); 
	});

	var FindDetailColumns = [{
			header : "RowId",
			dataIndex : 'invi',
			hidden : true
		}, {
			header : "入库退货Id",
			dataIndex : 'ingridr',
			width : 80,
			hidden : true
		}, {
			header : "物资Id",
			dataIndex : 'IncId',
			width : 80,
			hidden : true
		}, {
			header : '物资代码',
			dataIndex : 'IncCode',
			width : 80
		}, {
			header : '物资名称',
			dataIndex : 'IncDesc',
			width : 180
		}, {
			header : "规格",
			dataIndex : 'spec',
			width : 80
		}, {
			header : "数量",
			dataIndex : 'RecQty',
			width : 80,
			align : 'right'
		}, {
			header : "单位",
			dataIndex : 'UomDesc',
			width : 80,
			align : 'left'
		}, {
			header : "进价",
			dataIndex : 'rp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "售价",
			dataIndex : 'sp',
			width : 60,
			xtype : 'numbercolumn'
		}, {
			header : "进价金额",
			dataIndex : 'rpAmt',
			xtype : 'numbercolumn'
		}, {
			header : "售价金额",
			dataIndex : 'spAmt',
			xtype : 'numbercolumn'
		}, {
			header : "类型",
			dataIndex : 'TransType',
			width : 70,
			align : 'left',
			sortable : true	
		}, {
			header : "厂商",
			dataIndex : 'manf',
			width : 150
		}];
	
	var FindDetailGrid = new Ext.dhcstm.EditorGridPanel({
		id : 'FindDetailGrid',
		editable : false,
		contentColumns : FindDetailColumns,
		smType : "row",
		autoLoadStore : false,
		actionUrl : URL,
		queryAction : "queryItem",
		idProperty : "invi",
		remoteSort : false,
		showTBar : false,
		paging : true
	});
	
	function returnData() {
		var ginvRowId = FindMasterGrid.getSelectionModel().getSelected().get("inv");
		if (ginvRowId!=""){
			Fn(ginvRowId); 
			invWindow.close();
		}else{
			Msg.info("warning","请选择要返回的发票组合单信息!");
		}
	}
	
	var HisListTab = new Ext.form.FormPanel({
		labelWidth : 80,
		labelAlign : 'right',
		frame : true,
		bodyStyle : 'padding-top:5px;',
		tbar : [SearchBT, '-', ClearBT,'-',selectBT,'-',CancelBT],
		layout: 'fit',
		items : [{
			xtype : 'fieldset',
			title : '查询条件',
			layout : 'column',
			autoHeight : true,
			defaults: {columnWidth: 0.33,layout:'form'},
			items : [
				{
					items: [StartDate,EndDate]
				},{
					items: [FindVendor,FindStkGrpType]  
				},{
					items: [invStatus]
				}
			]
		}]
	});
	
	var invWindow =  new Ext.Window({
		title : '发票组合单查询',
		width : 1000,
		height : 600,
		modal : true,
		layout : 'border',
		items : [
			{
				region: 'north',
				height: 130,
				layout: 'fit',
				items:HisListTab
			}, {
				region: 'center',
				title: '发票组合单',
				layout: 'fit',
				items: FindMasterGrid
			}, {
				region: 'south',
				split: true,
				height: 200,
				collapsible: true,
				title: '发票组合单明细',
				layout: 'fit',
				items: FindDetailGrid
			}
		]
	});
	invWindow.show();
}