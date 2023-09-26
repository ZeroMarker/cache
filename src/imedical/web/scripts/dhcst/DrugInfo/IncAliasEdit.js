/**
 * 查询界面
 */
function IncAliasEdit(dataStore, IncRowid) {
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
			// 保存库存项别名
			SaveAlias();			
		}
	});
	// 保存别名信息
	function SaveAlias() {
		// 保存库存项别名
		if(MasterInfoGrid.activeEditor != null){
			MasterInfoGrid.activeEditor.completeEdit();
		} 
		var StrData="";
		var rowCount = MasterInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {				
			var rowData = MasterInfoStore.getAt(i);
			if(rowData.data.newRecord || rowData.dirty)
			{
				var IncaRowid = rowData.get("INCARowid");
				var IncaText = rowData.get("INCAText");	
				if(StrData=="")
				{
					StrData=IncaRowid+"^"+IncaText;
				}
				else
				{
					StrData=StrData+xRowDelim()+IncaRowid+"^"+IncaText;
				}
			}
		}
		if (StrData==""){
			Msg.info("warning","没有需要保存的数据!");
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=SaveIncAlias";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params: {InciRowid: IncRowid,ListData:StrData},
					waitMsg : '处理中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							getIncAlias(IncRowid);
							Msg.info("success", "保存成功!");
							
						} else {
							Msg.info("error", "保存失败:"+jsonData.info);
						}
					},
					scope : this
				});
	
	}
		
	//2. 删除按钮
	var DeleteBT = new Ext.Toolbar.Button({
		id : "DeleteBT",
		text : '删除',
		tooltip : '点击删除',
		width : 70,
		height : 30,
		iconCls : 'page_delete',
		handler : function() {
			deleteData();
		}
	});

	function deleteData() {
		var cell = MasterInfoGrid.getSelectionModel().getSelectedCell();
		if(cell==null){
			Msg.info("warning","请选择要删除的别名！");
		}
		else {
			
			var record = MasterInfoGrid.getStore().getAt(cell[0]);
			var IncaRowid = record.get("INCARowid");
			if (IncaRowid == null || IncaRowid.length <= 0) {
				MasterInfoGrid.getStore().remove(record);
			} else {
				Ext.MessageBox.show({
							title : '提示',
							msg : '是否确定删除该别名信息',
							buttons : Ext.MessageBox.YESNO,
							fn : showResult,
							icon : Ext.MessageBox.QUESTION
						});
	
			}							
		}

	}	
	
	function showResult(btn) {
		if (btn == "yes") {
			var cell = MasterInfoGrid.getSelectionModel().getSelectedCell();
			var record = MasterInfoGrid.getStore().getAt(cell[0]);
			var IncaRowid = record.get("INCARowid");
	
			// 删除该行数据
			var url = DictUrl
					+ "druginfomaintainaction.csp?actiontype=DeleteIncAlias&IncaRowid="
					+ IncaRowid;
	
			Ext.Ajax.request({
						url : url,
						method : 'POST',
						waitMsg : '处理中...',
						success : function(result, request) {
							var jsonData = Ext.util.JSON
									.decode(result.responseText);
							if (jsonData.success == 'true') {
								Msg.info("success","删除成功!");
								MasterInfoGrid.getStore().remove(record);
								MasterInfoGrid.view.refresh();
							} else {
								Msg.info("error","删除失败!")
							}
						},
						scope : this
					});
		}
	}
		
	// 3关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '关闭界面',
				iconCls : 'page_close',
				height:30,
				width:70,
				handler : function() {
					window.close();
				}
			});
	
	// 显示库存项别名
	function getIncAlias(InciRowid) {
		if (InciRowid == null || InciRowid=="") {
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=GetIncAlias&InciRowid="
				+ InciRowid;

		MasterInfoStore.proxy = new Ext.data.HttpProxy({
					url : url
				});
		MasterInfoStore.load({callback : function(r, options, success) {
			if (success == true) {
				//增加一空行
				addNewRow();
			}
		}} );
	}  

	// 访问路径
	var MasterInfoUrl = "";
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["INCARowid", "INCAText"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "INCARowid",
				fields : fields
			});
	// 数据集
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "INCARowid",
				dataIndex : 'INCARowid',
				width : 10,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "别名",
				dataIndex : 'INCAText',
				width : 260,
				align : 'left',
				sortable : true,
				editor : new Ext.grid.GridEditor(new Ext.form.TextField({
				selectOnFocus : true,
				allowBlank : false,
				listeners : {
					specialkey : function(field, e) {
						if (e.getKey() == Ext.EventObject.ENTER) {
							
						var Alias = field.getValue();
						if (Alias == null || Alias.length <= 0) {
							Msg.info("warning", "别名不能为空!");
									return;
								}
								var cell = MasterInfoGrid.getSelectionModel()
										.getSelectedCell();
								MasterInfoGrid.startEditing(cell[0], 1);
							}
						}
					}
				}))
			}]);
	MasterInfoCm.defaultSortable = true;
	
	var MasterInfoGrid = new Ext.grid.EditorGridPanel({
				title : '',
				height : 170,
				cm : MasterInfoCm,
				sm : new Ext.grid.CellSelectionModel({}),
				store : MasterInfoStore,
				trackMouseOver : true,
				stripeRows : true,
				loadMask : true,
				clicksToEdit : 1
			});
	
	function addNewRow() {

			var record = Ext.data.Record.create([{
						name : 'INCARowid',
						type : 'string'
					}, {
						name : 'INCAText',
						type : 'string'
					}]);

			var NewRecord = new record({
						INCARowid : '',
						INCAText : ''
					});
			MasterInfoStore.add(NewRecord);
			MasterInfoGrid.getSelectionModel()
					.select(MasterInfoStore.getCount() - 1, 1);
			MasterInfoGrid.startEditing(MasterInfoStore.getCount() - 1, 1);

	};


	// 页签
	var panel= new Ext.TabPanel({
				activeTab : 0,
				height : 200,
				region : 'center',
				items : [{
							layout : 'fit',
							title : '别名',
							items : MasterInfoGrid
						}]
			});

	var window = new Ext.Window({
				title : '别名维护',
				width :300,
				height : 400,
				modal:true,
				layout : 'border',
				items : [panel],
				tbar : [SaveBT, '-', DeleteBT, '-', closeBT]
			});
	window.show();
	
	//自动显示库存项别名
	getIncAlias(IncRowid);
}