/**
 * 查询界面
 */
function DoseEquivEdit(dataStore, IncRowid,Fn) {
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
			// 保存等效数量
			SaveData();			
		}
	});
	// 保存等效数量
	function SaveData() {
		// 保存等效数量
		var StrData="";
		var rowCount = MasterInfoGrid.getStore().getCount();
		for (var i = 0; i < rowCount; i++) {				
			var rowData = MasterInfoStore.getAt(i);
			if(rowData.data.newRecord || rowData.dirty)
			{
				var EqRowid = rowData.get("EQRowid");
				var EqUomId = rowData.get("EQUomRowid");
				var EqQty = rowData.get("EQQty");
				var EqDefaultDose = rowData.get("EQDefaultDose");
				if ((EqQty=="")||(EqQty==0)||(EqUomId=="")){continue;}
				if(StrData=="")
				{
					StrData=EqRowid+"^"+EqUomId+"^"+EqQty+"^"+EqDefaultDose;
				}
				else
				{
					StrData=StrData+","+EqRowid+"^"+EqUomId+"^"+EqQty+"^"+EqDefaultDose;
				}
			}
		}
		if(StrData==""){
			Msg.info("warning","没有需要保存的数据!");
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=SaveDoseEquiv";
		Ext.Ajax.request({
					url : url,
					method : 'POST',
					params: {InciRowid:IncRowid,ListData:StrData},
					waitMsg : '处理中...',
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							getDoseEquiv(IncRowid);
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
			Msg.info("warning","请选择要删除的等效单位！");
		}
		else {
			
			var record = MasterInfoGrid.getStore().getAt(cell[0]);
			var EqRowid = record.get("EQRowid");
			if (EqRowid == null || EqRowid.length <= 0) {
				MasterInfoGrid.getStore().remove(record);
			} else {
				Ext.MessageBox.show({
							title : '提示',
							msg : '是否确定删除该等效单位信息',
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
			var EqRowid = record.get("EQRowid");
	
			// 删除该行数据
			var url = DictUrl
					+ "druginfomaintainaction.csp?actiontype=DeleteDoseEquiv&EqRowid="
					+ EqRowid;
	
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
								Msg.info("error","删除失败!");
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
				width : 70,
				height : 30,
				iconCls : 'page_close',
				handler : function() {
					window.close();
				}
			});
	
	// 显示等效单位信息
	function getDoseEquiv(InciRowid) {
		if (InciRowid == null || InciRowid=="") {
			return;
		}
		var url = DictUrl
				+ "druginfomaintainaction.csp?actiontype=GetDoseEquiv&InciRowid="
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

			// 单位
	var CTUom = new Ext.form.ComboBox({
				fieldLabel : '单位',
				id : 'CTUom',
				name : 'CTUom',
				anchor : '90%',
				width : 120,
				store : CTUomStore,
				valueField : 'RowId',
				displayField : 'Description',
				allowBlank : false,
				triggerAction : 'all',
				emptyText : '单位...',
				selectOnFocus : true,
				forceSelection : true,
				//typeAhead:true,
				minChars : 1,
				pageSize : 10,
				listWidth : 250,
				valueNotFoundText : '',
				listeners : {
					'beforequery' : function(e) {
						var desc=Ext.getCmp('CTUom').getRawValue();
						if(desc!=null || desc!=""){
							CTUomStore.removeAll();
							CTUomStore.setBaseParam("CTUomDesc",desc);
							CTUomStore.load()
							//CTUomStore.load({params:{CTUomDesc:desc,start:0,limit:10}});
						}
					}
				}
			});
	
	// 访问路径
	var MasterInfoUrl = "";
	// 通过AJAX方式调用后台数据
	var proxy = new Ext.data.HttpProxy({
				url : MasterInfoUrl,
				method : "POST"
			});
	// 指定列参数
	var fields = ["EQRowid", "EQUomRowid","EQUom","EQQty","EQDefaultDose"];
	// 支持分页显示的读取方式
	var reader = new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : "results",
				id : "EQRowid",
				fields : fields
			});
	// 数据集
	var MasterInfoStore = new Ext.data.Store({
				proxy : proxy,
				reader : reader
			});
	var nm = new Ext.grid.RowNumberer();
	var MasterInfoCm = new Ext.grid.ColumnModel([nm, {
				header : "EQRowid",
				dataIndex : 'EQRowid',
				width : 10,
				align : 'left',
				sortable : true,
				hidden : true
			}, {
				header : "等效单位",
					dataIndex : 'EQUomRowid',
					width : 80,
					align : 'left',
					sortable : true,
					renderer : Ext.util.Format.comboRenderer2(CTUom,"EQUomRowid","EQUom"),
					editor : new Ext.grid.GridEditor(CTUom)
			}, {
					header : "等效数量",
					dataIndex : 'EQQty',
					width : 80,
					align : 'right',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : false,
						decimalPrecision:4,
						allowNegative:false,
						listeners : {
							specialkey : function(field, e) {
								if (e.getKey() == Ext.EventObject.ENTER) {
									var qty = field.getValue();
									if (qty == null || qty.length <= 0) {
										Msg.info("warning", "等效数量不能为空!");
										return;
									}
									if (qty <= 0) {
										Msg.info("warning", "等效数量不能小于或等于0!");
										return;
									}
									// 判断是否已经有添加行
									var rowCount = MasterInfoGrid.getStore()
											.getCount();
									if (rowCount > 0) {
										var rowData = MasterInfoStore.data.items[rowCount
												- 1];
										var data = rowData.get("EQUom");
										if (data == null || data.length <= 0) {
											return;
										}
									}
									// 新增一行
									addNewRow();
								}
							}
						}
					}))
				},{
					header : "缺省数量",
					dataIndex : 'EQDefaultDose',
					width : 80,
					align : 'right',
					sortable : true,
					editor : new Ext.grid.GridEditor(new Ext.form.NumberField({
						selectOnFocus : true,
						allowBlank : true,
						decimalPrecision:4,
						allowNegative:false						
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

	MasterInfoGrid.on('beforeedit',function(e){
		if(e.field=="EQUomRowid"){
			var uomid=e.record.get("EQUomRowid");
			var uom=e.record.get("EQUom");
			addComboData(CTUomStore,uomid,uom);
		}
	});
	function addNewRow() {

			var record = Ext.data.Record.create([{
						name : 'EQRowid',
						type : 'string'
					}, {
						name : 'EQUomRowid',
						type : 'string'
					}, {
						name : 'EQUom',
						type : 'string'
					}, {
						name : 'EQQty',
						type : 'string'
					}, {
						name : 'EQDefaultDose',
						type : 'string'
					}]);

			var NewRecord = new record({
						EQRowid : '',
						EQUomRowid:'',
						EQUom : '',
						EQQty:'',
						EQDefaultDose:''
					});
			MasterInfoStore.add(NewRecord);
			MasterInfoGrid.getSelectionModel().select(MasterInfoStore.getCount() - 1, 1);
			MasterInfoGrid.startEditing(MasterInfoStore.getCount() - 1, 1);

	};


	// 页签
	var panel= new Ext.TabPanel({
				activeTab : 0,
				height : 200,
				region : 'center',
				items : [{
							layout : 'fit',
							title : '等效单位',
							items : MasterInfoGrid
						}]
			});

	var window = new Ext.Window({
				title : '等效单位维护',
				width :300,
				height : 400,
				modal:true,
				layout : 'border',
				items : [panel],
				tbar : [SaveBT, '-', DeleteBT, '-', closeBT]
			});
	window.show();
	
	//自动显示等效单位
	getDoseEquiv(IncRowid);
	//关闭窗口事件
	window.on('close', function(panel) {
			Fn(IncRowid)
		});
}