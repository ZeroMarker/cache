//SkinTestArc.js
//wwl 20160307 皮试医嘱关联
function SkinTestArc(ArcRowid)
{
	var User=session['LOGON.USERID'];
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	
		// 访问路径
	var MasterInfoUrl = "";
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["SkinRowid","InciDr","InciCode", "InciDesc"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "SkinRowid",
				fields : fields
			});
	// 数据集
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "SkinRowid",
				dataIndex : 'SkinRowid',
				width : 10,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "InciDr",
				dataIndex : 'InciDr',
				width : 10,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "药品代码",
				dataIndex : 'InciCode',
				width : 80,
				align : 'left',
				sortable : true,
				hidden : false
			}, {
					header : '药品名称',
					dataIndex : 'InciDesc',
					width : 170,
					align : 'left',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.TextField({
								selectOnFocus : true,
								allowBlank : false,
								listeners : {
									specialkey : function(field, e) {
										if (e.getKey() == Ext.EventObject.ENTER) {
											

											GetPhaOrderInfo(field.getValue(),
													"");
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
			
	var SaveBT = new Ext.Toolbar.Button({
		id:"SaveBT",
		text:'保存',
		tooltip:'点击保存',
		width : 70,
		height : 30,
		iconCls : 'page_save',
		handler : function() {
			
			SaveData();			
		}		
		});
		
		// 保存信息
	function SaveData() {
		
		if(MasterInfoGrid.activeEditor != null){
			MasterInfoGrid.activeEditor.completeEdit();
		} 
		var StrData="";
		var rowCount = MasterInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {				
			var rowData = MasterInfoStore.getAt(i);
			if(rowData.data.newRecord || rowData.dirty)
			{
				var InciDr = rowData.get("InciDr");
				var SkinRowid = rowData.get("SkinRowid");
				var InciCode = rowData.get("InciCode");	
				var InciDesc = rowData.get("InciDesc");	
				
				if(StrData=="")
				{
					StrData=SkinRowid+"^"+InciDr;
				}
				else
				{
					StrData=StrData+xRowDelim()+SkinRowid+"^"+InciDr;
				}
			}
		}
		if (StrData==""){
			Msg.info("warning","没有需要保存的数据!");
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=SaveSkinInfo";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params: {ArcRowid:ArcRowid,ListData:StrData},
					waitMsg : '处理中...',
					success : function(result, request) {						
						var jsonData = Ext.util.JSON.decode(result.responseText);
						if (jsonData.success == 'true') {
							getSkinInfo(ArcRowid);
							Msg.info("success", "保存成功!");
							
						} else {
							Msg.info("error", "保存失败:"+jsonData.info);
						}
					},
					scope : this
				});
	
	}
	// 删除按钮
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
			Msg.info("warning","请选择要删除的记录！");
		}
		else {
			
			var record = MasterInfoGrid.getStore().getAt(cell[0]);
			var SkinRowid = record.get("SkinRowid");
			if (SkinRowid == null || SkinRowid.length <= 0) {
				MasterInfoGrid.getStore().remove(record);
			} else {
				Ext.MessageBox.show({
							title : '提示',
							msg : '是否确定删除该记录',
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
			var SkinRowid = record.get("SkinRowid");
	
			// 删除该行数据
			var url = DictUrl
					+ "druginfomaintainaction.csp?actiontype=DeleteSkinInfo&SkinRowid="
					+ SkinRowid;
	
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
	
		// 显示皮试医嘱关联
	function getSkinInfo(Arc) {
		if (Arc == null || Arc=="") {
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=GetSkinInfo&ArcRowid="
				+ Arc;

		MasterInfoStore.proxy = new Ext.data.HttpProxy({
					url : url
				});
		MasterInfoStore.load({callback : function(r, options, success) {
			//alert(success)
			if (success == true) {
				//增加一空行
				addNewRow();
			}
		}} );
	};  

	// 关闭按钮
	var closeBT = new Ext.Toolbar.Button({
				text : '关闭',
				tooltip : '关闭界面',
				width : 70,
				height : 30,
				iconCls : 'page_close',
				handler : function() {
					window.close();
				}
			});
			
	
	function GetPhaOrderInfo(item, group) {
						
			if (item != null && item.length > 0) {
				GetPhaOrderWindow(item, "","G", "", "N", "0", User,
						getDrugList);
			}
		}
			
	 function getDrugList(record) {
			if (record == null || record == "") {
				return;
			}
			var InciDr = record.get("InciDr");
			var inciCode=record.get("InciCode");
			var inciDesc=record.get("InciDesc");
			
			var cell = MasterInfoGrid.getSelectionModel().getSelectedCell();
			var row = cell[0];
			var rowData = MasterInfoGrid.getStore().getAt(row);
			rowData.set("InciDr",InciDr);
			rowData.set("InciCode",inciCode);
			rowData.set("InciDesc",inciDesc);
	 }
	 
	 
	function addNewRow() {
			var record = Ext.data.Record.create([{
						name : 'SkinRowid',
						type : 'string'
					}, {
						name : 'InciDr',
						type : 'string'
					}, {
						name : 'InciCode',
						type : 'string'
					}, {
						name : 'InciDesc',
						type : 'string'
					}]);



			var NewRecord = new record({
				        SkinRowid :'',
						InciDr : '',
						InciCode : '',
						InciDesc:''
					});
			MasterInfoStore.add(NewRecord);
			MasterInfoGrid.getSelectionModel().select(MasterInfoStore.getCount() - 1, 1);
			MasterInfoGrid.startEditing(MasterInfoStore.getCount() - 1, 1);

	}		
		// 页签
	var panel= new Ext.TabPanel({
				activeTab : 0,
				height : 200,
				region : 'center',
				items : [{
							layout : 'fit',
							title : '皮试关联',
							items : MasterInfoGrid
						}]
			});

	var window = new Ext.Window({
				title : '皮试关联维护',
				width :300,
				height : 400,
				modal:true,
				layout : 'border',
				items : [panel],
				tbar : [SaveBT, '-', DeleteBT, '-', closeBT]
			});
			
	window.show();	
		
    getSkinInfo(ArcRowid);
    
	}