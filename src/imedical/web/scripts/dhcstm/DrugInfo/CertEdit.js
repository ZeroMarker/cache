/**
 * 查询界面
 */
function certEdit(inci,manf,selectFn,manfName) {
 
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	// 3关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		text : '关闭',
		tooltip : '关闭界面',
		iconCls : 'page_gear',
		height:30,
		width:70,
		handler : function() {
			window.close();
		}
	});

	var selectBT = new Ext.Toolbar.Button({
		text : '选择',
		tooltip : '选择一条记录',
		iconCls : 'page_goto',
		height:30,
		width:70,
		hidden:true,
		handler : function() {
			var tab=certPanel.getActiveTab();
			var certNo,certExpDate;
			var ItmCertDesc, RegCertDateOfIssue, ImportFlag, OriginId, Origin;
			if (tab.getId()=='inciCertList') 
			{
				var rec=inciCertListGrid.getSelectionModel().getSelected();
				if (rec)
				{
					var certNo=rec.get("certNo");
					var certExpDate=rec.get("certExpDate");
				}
				else
				{Msg.info("warning","没有选择记录");return;}
			}
			else if (tab.getId()=='manfCertList') 
			{
				var rec=manfCertListGrid.getSelectionModel().getSelected();
				if (rec)
				{
					var certNo=rec.get("certNo");
					var certExpDate=rec.get("certExpDate");
					var ItmCertDesc = rec.get('ItmCertDesc');
					var RegCertDateOfIssue = rec.get('RegCertDateOfIssue');
					var ImportFlag = rec.get('ImportFlag');
					var OriginId = rec.get('OriginId');
					var Origin = rec.get('Origin');
				}
			}
			else
			{Msg.info("warning","没有选择记录");return;}
			
			if (!Ext.isEmpty(certNo))
			{
				var ss=Ext.Msg.show({
				   title:'提示',
				   msg: '是否采用该注册证？',
				   buttons: Ext.Msg.OKCANCEL,
				   fn: function(b,t,o){if (b=='ok') {
							selectFn(certNo,certExpDate,ItmCertDesc, RegCertDateOfIssue, ImportFlag, OriginId, Origin);
							window.close();
						}
				   },
				   icon: Ext.MessageBox.QUESTION
				});	
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

	//	20170817
	var mUrl= DictUrl+'druginfomaintainaction.csp?actiontype=GetManfCertList&Manf='+manf;
	var mProxy=new Ext.data.HttpProxy({
		url :mUrl,
		method : "POST"
	});
	var mReader=new Ext.data.JsonReader({
		root : 'rows',
		totalProperty : "results",
		id : "mc",
		fields : ["certNo", "certExpDate","certDate","certTime","mc",
			'ItmCertDesc', 'RegCertDateOfIssue', 'ImportFlag', 'OriginId', 'Origin'
		]
	});
	var manfCertListStore = new Ext.data.Store({
		proxy : mProxy,
		reader :mReader 
	});

	//	20170817
	var manfCertListCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
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
	},{
		header : "注册证名称",
		dataIndex : 'ItmCertDesc',
		width : 100,
		align : 'left'
	},{
		header : "发证日期",
		dataIndex : 'RegCertDateOfIssue',
		width : 100,
		align : 'left'
	},{
		header : "进口标记",
		dataIndex : 'ImportFlag',
		width : 60,
		align : 'left'
	},{
		header : "产地",
		dataIndex : 'Origin',
		width : 60,
		align : 'left'
	}]);
	
	//厂家所有注册证 20170817
	var manfCertListGrid = new Ext.grid.GridPanel({
		height : 170,
		cm : manfCertListCm,
		sm : new Ext.grid.RowSelectionModel({singleSelect:true}),
		store : manfCertListStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true
	});
	// 页签
	var certPanel= new Ext.TabPanel({
		activeTab : 0,
		height : 200,
		region : 'center',
		items : [{
			layout : 'fit',
			id:'inciCertList',
			title : '该物资历史注册证列表',
			items : inciCertListGrid
		},{
			layout : 'fit',
			title : '厂家注册证列表',
			id:'manfCertList',
			items : manfCertListGrid
		}]
		
	});

	var window = new Ext.Window({
		title : '注册证浏览'+' < 厂家： '+manfName+' >',
		width :800,
		height : 400,
		modal:true,
		layout : 'border',
		items : [certPanel],
		tbar : [closeBT,selectBT],
		listeners:{
			'show':function(){
				//自动显示库存项规格
				getInciCertList(inci,manf);
				manfCertListStore.load();
				if (selectFn) {selectBT.setVisible(true);}
				var tab=Ext.getCmp('inciCertList');
				
				if (inci=='') { tab.setDisabled(true);certPanel.setActiveTab('manfCertList');}
				else {tab.setDisabled(false); }
			}
		}
	});
	window.show();
	
}