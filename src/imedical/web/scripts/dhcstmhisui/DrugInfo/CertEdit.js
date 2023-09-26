/**
 * 查询界面
 */
function certEdit(inci,manf,selectFn) {
 
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// 3关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '关闭界面',
		iconCls : 'page_delete',
		height:30,
		width:70,
		handler : function() {
			window.close();
		}
	});

	var selectBT = new Ext.Toolbar.Button({
		text : '选择',
		tooltip : '选择一条记录',
		iconCls : 'page_delete',
		height:30,
		width:70,
		hidden:true,
		handler : function() {
			var rec=inciCertListGrid.getSelectionModel().getSelected();
			if (rec)
			{
				var certNo=rec.get("certNo");
				var certExpDate=rec.get("certExpDate");
				selectFn(certNo,certExpDate);
				window.close();
			}
			
		}
	});
	
	// 显示库存项注册证
	function getInciCertList(InciRowid,Manf) {
		if (InciRowid == null || InciRowid=="") {
			return;
		}
		var url = DictUrl	+ "druginfomaintainaction.csp?actiontype=GetInciCertList&InciRowid="+ InciRowid +"&Manf="+Manf;
		inciCertListStore.proxy = new Ext.data.HttpProxy({url : url});
		inciCertListStore.load({callback : function(r, options, success) {
			if (success == true) {
			
			}
		}} );
	}  

	// 访问路径
	var Url = "";
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
		url : Url,
		method : "POST"
	});
	// 指定列参数
	var fields = ["irv","certNo", "certExpDate","certDate","certTime"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "irv",
		fields : fields
	});
	// 数据集
	var inciCertListStore = new Ext.data.Store({
		proxy : proxy,
		reader : reader
	});
	var nm = new Ext.grid.RowNumberer();
	var inciCertListCm = new Ext.grid.ColumnModel([nm, {
		header : "irv",
		dataIndex : 'irv',
		width : 10,
		align : 'left',
		sortable : true,
		hidden : true
	}, {
		header : "注册证号",
		dataIndex : 'certNo',
		width :280,
		align : 'left',
		sortable : true
	},{
		header : "注册证效期",
		dataIndex : 'certExpDate',
		width : 100,
		align : 'left',
		sortable : true			
	},{
		header : "创建日期",
		dataIndex : 'certDate',
		width : 100,
		align : 'left',
		sortable : true			
	},{
		header : "创建时间",
		dataIndex : 'certTime',
		width : 100,
		align : 'left'
	}]);
	inciCertListCm.defaultSortable = true;
	
	var inciCertListGrid = new Ext.grid.EditorGridPanel({
		title : '',
		height : 170,
		cm : inciCertListCm,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		store : inciCertListStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		clicksToEdit : 1
	});

	// 页签
	var panel= new Ext.TabPanel({
		activeTab : 0,
		height : 200,
		region : 'center',
		items : [{
			layout : 'fit',
			title : '注册证',
			items : inciCertListGrid
		}]
	});

	var window = new Ext.Window({
		title : '注册证浏览',
		width :600,
		height : 300,
		modal:true,
		layout : 'border',
		items : [panel],
		tbar : [closeBT,selectBT],
		listeners:{
			'show':function(){
				//自动显示库存项规格
				getInciCertList(inci,manf);
				if (selectFn) {selectBT.setVisible(true);}
			}
		}
	});
	window.show();
	
	
}