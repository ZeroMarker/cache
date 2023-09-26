/**
 * 零库存标志界面
 */
 function HospZeroStkEdit(dataStore, IncRowid,zeroObj) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
	// 保存按钮
	var SaveBT = new Ext.Toolbar.Button({
		id : "SaveBT",
		text : '保存',
		tooltip : '点击保存',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			Save();			
		}
	});
	// 保存零库存标志
	function Save() {
		if(MasterInfoGrid.activeEditor != null){
			MasterInfoGrid.activeEditor.completeEdit();
		} 
		var StrData="";
		var rowCount = MasterInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {				
			var rowData = MasterInfoStore.getAt(i);
			if(rowData.data.newRecord || rowData.dirty)
			{
				var HospCheck=rowData.get("HospCheck");
				var INCZeroId = rowData.get("INCZeroId");
				var HospId=rowData.get("HospId");
				var ZeroType = rowData.get("ZeroType");	
				if(ZeroType=="")
				{
					ZeroType="N"
				}
				if(StrData=="")
				{
					StrData=INCZeroId+"^"+HospId+"^"+ZeroType+"^"+HospCheck;
				}
				else
				{
					StrData=StrData+xRowDelim()+INCZeroId+"^"+HospId+"^"+ZeroType+"^"+HospCheck;
				}
			}
			
		}
		if (StrData==""){
			Msg.info("warning","没有需要保存的数据!");
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=SaveINCZero";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params: {InciRowid: IncRowid,ListData:StrData},
					waitMsg : '处理中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							getINCZero(IncRowid);
							Msg.info("success", "保存成功!");
							
						} else {
							Msg.info("error", "保存失败:"+jsonData.info);
						}
					},
					scope : this
				});
	
	}
	
    // 关闭按钮
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
	
	// 显示零库存标志
	function getINCZero(InciRowid) {
		
		if (InciRowid == null || InciRowid=="") {
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=GetINCZero&InciRowid="
				+ InciRowid;

		MasterInfoStore.proxy = new Ext.data.HttpProxy({
					url : url
				});
				MasterInfoStore.load();
	} 
	var HospCheck = new Ext.grid.CheckColumn({
	    header:'院区选择',
	    dataIndex:'HospCheck',
	    width:70,
	    sortable:true
    });	
	var ZeroType = new Ext.grid.CheckColumn({
	    header:'零库存标志',
	    dataIndex:'ZeroType',
	    width:70,
	    sortable:true
    });
	// 访问路径
	var MasterInfoUrl = "";
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["INCZeroId", "HospId","HospCode","HospDesc","HospCheck","ZeroType"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "INCZeroId",
				fields : fields
			});
	// 数据集
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "INCZeroId",
				dataIndex : 'INCZeroId',
				width : 50,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : "HospId",
				dataIndex : 'HospId',
				width : 50,
				align : 'left',
				sortable : true,
				hidden : true
			},{
				header : "院区代码",
				dataIndex : 'HospCode',
				width : 60,
				align : 'left',
				sortable : true
			},{
				header : "院区名称",
				dataIndex : 'HospDesc',
				width : 120,
				align : 'left',
				sortable : true
			},
			HospCheck,
			ZeroType
			]);
	
	MasterInfoCm.defaultSortable = true;
	
	var MasterInfoGrid = new Ext.grid.EditorGridPanel({
				title : '',
				height : 170,
				cm : MasterInfoCm,
				sm : new Ext.grid.CellSelectionModel({}),
				store : MasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				plugins:[HospCheck,ZeroType],
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
							title : '院区-零库存标志',
							items : MasterInfoGrid
						}]
			});

	var window = new Ext.Window({
				title : '院区零库存标志维护',
				width :370,
				height : 400,
				modal:true,
				layout : 'border',
				items : [panel],
				tbar : [SaveBT, '-', closeBT]
				,
				listeners:{
					'close':function(){	
						if (zeroObj){
							var zeroStr=tkMakeServerCall("web.DHCSTM.DHCIncHosp","GetHospZeroStr",IncRowid);
							zeroObj.setValue(zeroStr);
						}
					}
				}
			});
	window.show();
	
	//自动显示库存项别名
	getINCZero(IncRowid);
}