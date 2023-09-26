
var ShowScrapWin=function(Status,HVFlag,Paramstr,DeskStore) {
	var userId = session['LOGON.USERID'];
	
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
		id : "closeBT",
		text : '关闭',
		tooltip : '关闭界面',
		iconCls : 'page_delete',
		width : 70,
		height : 30,
		handler : function() {
			DeskStore.reload()
			findWin.close();
		}
	});
	
	// 完成按钮
	var CompleteBT = new Ext.Toolbar.Button({
		id : "CompleteBT",
		text : '完成',
		tooltip : '只能选择一条进行完成',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
			Complete();
		}
	});
	
	// 审核按钮
	var AuditBT = new Ext.ux.Button({
		id : "AuditBT",
		text : '审核',
		tooltip : '只能选择一条进行审核',
		width : 70,
		height : 30,
		iconCls : 'page_gear',
		handler : function() {
			Audit();
		}
	});
	
	function Complete(){
		var selectRows = MasterGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "请选择单据进行操作");
			return;
		}
		var RowId = selectRows[0].get("RowId");
		Ext.Ajax.request({
			url : 'dhcstm.inscrapaction.csp?actiontype=finish&InscpId='+RowId,
			method : 'POST',
			waitMsg : '查询中...',
			success : function(result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success == 'true') {
					Msg.info("success", "设置成功!");
					Query();
				}else{
					Msg.info("error", "设置失败!");
					return false;
				}
			},
			failure:function(){Msg.info('failure','设置失败!');}
		});
	}
	
	function Audit(){
		var gUserId = session['LOGON.USERID'];
		var gLocId=session['LOGON.CTLOCID'];
		var selectRows = MasterGrid.getSelectionModel().getSelections();
		if (selectRows.length == 0) {
			Msg.info("warning", "请选择单据进行操作");
			return;
		}
		var RowId = selectRows[0].get("RowId");
		Ext.Ajax.request({
			url:"dhcstm.inscrapaction.csp?actiontype=audit&inscrap="
				+ RowId + "&userId=" + gUserId +"&locId=" + gLocId,
			success:function(result, request){
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.success=='true'){
					Msg.info('success','审核成功!');
					Query();
				}else{
					if(jsonData.info==-1){
						Msg.info("error","主表rowid为空!");
					}else if(jsonData.info==-2){
						Msg.info("error","登录用户rowid为空!");
					}else if(jsonData.info==-3){
						Msg.info("error","已经审核!");
					}else if(jsonData.info==-102){
						Msg.info("error","库存处理出错!");
					}else if(jsonData.info==-103){
						Msg.info("error","插入台账数据出错!");
					}else if(jsonData.info==-104){
						Msg.info("error","批次库存不足,不能进行报损单审核!");
					}else{
						Msg.info("error","审核失败!"+jsonData.info);
					}
				}
			 },
			failure:function(){Msg.info('failure','审核失败!');}
		})
	}
	
	function setBTStatus(Status){
		var StatusArr=Status.split("^");
		var compstatus=StatusArr[0];
		var auditstatus=StatusArr[1];
		
		if(compstatus=="Y"){Ext.getCmp("CompleteBT").enable();}
		else{Ext.getCmp("CompleteBT").disable();}
		
		if(auditstatus=="Y"){Ext.getCmp("AuditBT").enable();}
		else{Ext.getCmp("AuditBT").disable();}
	}
	// 显示请求单数据
	function Query() {
		if(Status=="NoComp"){
			setBTStatus("Y^N")
		}else{
			setBTStatus("N^Y")
		}
		var MainInfo=Status+"^"+HVFlag;
		var Page=GridPagingToolbar.pageSize;
		MasterStore.setBaseParam('MainStr',MainInfo);
		MasterStore.setBaseParam('ParamStr',Paramstr);
		MasterStore.removeAll();
		MasterStore.load({
			params:{start:0, limit:Page},
			callback : function(r,options, success){
				if(success==false){
					Msg.info("error", "查询错误，请查看日志!");
				}else{
					if(r.length>0){
						MasterGrid.getSelectionModel().selectFirstRow();
						MasterGrid.getView().focusRow(0);
					}
				}
			}
		});
	}
	
	// 访问路径
	var MasterUrl = 'dhcstm.deskaction.csp?actiontype=QueryScrap';
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
		url : MasterUrl,
		method : "POST"
	});
	// 指定列参数
	var fields = ["RowId","No","LocDesc","UserName","Date","Time","CompFlag","AuditFlag","ScgDesc"];
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
	var	sm=new Ext.grid.RowSelectionModel({
		singleSelect : true
	});
	var MasterCm = new Ext.grid.ColumnModel([nm,{
			header : "RowId",
			dataIndex : 'RowId',
			width : 80,
			align : 'left',
			sortable : true,
			hidden : true
		}, {
			header : "单号",
			dataIndex : 'No',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			header : "报损部门",
			dataIndex : 'LocDesc',
			width : 150,
			align : 'left',
			sortable : true
		}, {
			header : "类组",
			dataIndex : 'ScgDesc',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "制单人",
			dataIndex : 'UserName',
			width : 80,
			align : 'left',
			sortable : true
		}, {
			header : "日期",
			dataIndex : 'Date',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "时间",
			dataIndex : 'Time',
			width : 100,
			align : 'left',
			sortable : true
		}, {
			header : "完成标志",
			dataIndex : 'CompFlag',
			width : 80,
			align : 'left'
		}, {
			header : "审核标志",
			dataIndex : 'AuditFlag',
			width : 80,
			align : 'left'
		}]);
	MasterCm.defaultSortable = true;

	var GridPagingToolbar = new Ext.PagingToolbar({
		store:MasterStore,
		pageSize:PageSize,
		displayInfo:true,
		displayMsg:'第 {0} 条到 {1}条 ，一共 {2} 条',
		emptyMsg:"没有记录"
	});

	var MasterGrid = new Ext.grid.GridPanel({
		id:'MasterGrid',
		region: 'center',
		split: true,
		height: 250,
		margins: '0 5 0 0',
		layout: 'fit',
		cm : MasterCm,
		sm: sm,
		store : MasterStore,
		trackMouseOver : true,
		stripeRows : true,
		loadMask : true,
		bbar:GridPagingToolbar
	});
	
	var findWin = new Ext.Window({
		title:'处理单据',
		id:'findWin',
		width:gWinWidth,
		height:gWinHeight,
		plain:true,
		modal:true,
		layout : 'border',
		items : [MasterGrid],
		tbar : [CompleteBT,'-',AuditBT,'-',closeBT]
		
	});
	
	//显示窗口
	findWin.show();
	Query();
}