Ext.onReady(function() {
	var TMPFusId='';
	var TMPfusdid='';
	Ext.QuickTips.init();
	
	var fusicdstore = new Ext.data.Store({

				url : 'dhccrmbaseset1.csp?actiontype=icdlist&FUSRowId=',

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows',
							id : 'ICDRowId'

						}, [{
									name : 'ICDParRef'
								}, {
									name : 'ICDRowId'
								}, {
									name : 'ICDCode'
								}, {
									name : 'ICDDesc'
								}, {
									name : 'ICDDR'
								}])

			});
	var fusicdcm = new Ext.grid.ColumnModel([{

				header : '编码',
				dataIndex : 'ICDCode'

			}, {

				header : '名称',
				dataIndex : 'ICDDesc',
				width : 500

			}, {

				header : 'ICD',
				dataIndex : 'ICDDR'

			}]);
	var fusctstore = new Ext.data.Store({

				url : 'dhccrmbaseset1.csp?actiontype=ctlist&FUSRowId=',

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows',
							id : 'LocRowId'

						}, [{
									name : 'LocSub'
								},
							{
									name : 'LocParRef'
								}, {
									name : 'LocRowId'
								}, {
									name : 'LocCode'
								}, {
									name : 'Loc'
								}])
								//remoteSort: true,
						/*sortInfo:{field:'LocSub',direction:'desc'}*/
						
						
			});		
	var fusctcm = new Ext.grid.ColumnModel([
	       {	id:'LocSub',
				header : 'childRowId',
				dataIndex : 'LocSub',
				sortable:false

			},
		    {
				header : 'RowId',
				dataIndex : 'LocRowId'

			},{

				header : '科室编码',
				dataIndex : 'LocCode'
			},  {

				header : '科室名称',
				dataIndex : 'Loc',
				editor: new Ext.form.ComboBox({
							fieldLabel : '科室',
							id : 'CTLoc',
							name : 'CTLoc',
							width : 150,
							store : LocStore,
												triggerAction : 'all',
												minChars : 1,
												selectOnFocus : true,
												forceSelection : true,
												valueField : 'CTLocRowID',
												displayField : 'CTLocName'	
				})

			}]);
	var fusbstore = new Ext.data.Store({

				url : 'dhccrmbaseset1.csp?actiontype=list',

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows',
							id : 'FUSRowId'

						}, [{
									name : 'FUSRowId'
								}, {
									name : 'FUSCode'
								}, {
									name : 'FUSDesc'
								}, {
									name : 'FUSDateLimit'
								}, {
									name : 'FUSDateBegin'
								}, {
									name : 'FUSDateEnd'
								}, {
									name : 'FUSActive'
								}])

			});

	var fusdstore = new Ext.data.Store({

				url : 'dhccrmbaseset1.csp?actiontype=fusdlist&FUSRowId=',

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows',
							id : 'SDRowId'

						}, [{
									name : 'SDParRef'
								}, {
									name : 'SDRowId'
								}, {
									name : 'SDCode'
								}, {
									name : 'SDDesc'
								}, {
									name : 'SDType'
								}, {
									name : 'SDUnit'
								}, {
									name : 'SDExplain'
								}, {
									name : 'SDSex'
								}, {
									name : 'SDActive'
								}, {
									name : 'SDEffDate'
								}, {
									name : 'SDEffDateTo'
								}, {
									name : 'SDRequired'
								}, {
									name : 'SDSequence'
								}, {
									name : 'SDParentDR'
								}, {
									name : 'SDCascade'
								}, {
									name : 'SDSelectNum'
								}])

			});

	var sdsstore = new Ext.data.Store({

				url : 'dhccrmbaseset1.csp?actiontype=sdslist&SDRowId=',

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows',
							id : 'SDSRowId'

						}, [{
									name : 'SDSParRef'
								}, {
									name : 'SDSRowId'
								}, {
									name : 'SDSTextVal'
								}, {
									name : 'SDSUnit'
								}, {
									name : 'SDSDefaultValue'
								}, {
									name : 'SDSSequence'
								}, {
									name : 'SDSDesc'
								}])
			});

	var fusbcm = new Ext.grid.ColumnModel([{

				header : '编码',
				dataIndex : 'FUSCode'

			}, {

				header : '名称',
				dataIndex : 'FUSDesc',
				width : 300

			}, {

				header : '日期限制',
				dataIndex : 'FUSDateLimit',
				renderer : function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'
							+ (v == 'true' ? '-on' : '') + ' x-grid3-cc-'
							+ this.id + '">&#160;</div>';
				}

			}, {

				header : '开始日期',
				dataIndex : 'FUSDateBegin'

			}, {

				header : '结束日期',
				dataIndex : 'FUSDateEnd'

			}, {

				header : '发布',
				dataIndex : 'FUSActive',
				renderer : function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'
							+ (v == 'true' ? '-on' : '') + ' x-grid3-cc-'
							+ this.id + '">&#160;</div>';
				}

			}]);

	var fusdcm = new Ext.grid.ColumnModel([{

				header : '编码',
				dataIndex : 'SDCode'

			}, {

				header : '名称',
				dataIndex : 'SDDesc',
				width : 500

			}, {

				header : '类型',
				dataIndex : 'SDType'

			}, {

				header : '单位',
				dataIndex : 'SDUnit'

			}, {

				header : '说明',
				dataIndex : 'SDExplain'

			}, {

				header : '性别',
				dataIndex : 'SDSex'

			}, {

				header : '激活',
				dataIndex : 'SDActive',
				renderer : function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'
							+ (v == 'true' ? '-on' : '') + ' x-grid3-cc-'
							+ this.id + '">&#160;</div>';
				}

			}, {

				header : '有效日期',
				dataIndex : 'SDEffDate'

			}, {

				header : '有效日期截止',
				dataIndex : 'SDEffDateTo'

			}, {

				header : '是否必填项',
				dataIndex : 'SDRequired',
				renderer : function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'
							+ (v == 'true' ? '-on' : '') + ' x-grid3-cc-'
							+ this.id + '">&#160;</div>';
				}

			}, {

				header : '顺序号',
				dataIndex : 'SDSequence'

			}, {

				header : '父层ID',
				dataIndex : 'SDParentDR',
				hidden : true
			}, {

				header : '层次',
				dataIndex : 'SDCascade',
				hidden : true
			}, {

				header : '显示列数',
				dataIndex : 'SDSelectNum'

			}]);
	function StringIsNull(String) {
		if (String == null)
			return ""
		return String
	}
	function Import_click() {

		var kill = tkMakeServerCall("web.DHCCRM.SetPlan", "KillICDDataGlobal");
		try {

			var Template = "";
			var obj = document.getElementById("File")
			if (obj) {
				obj.click();
				Template = obj.value;
				obj.outerHTML = obj.outerHTML; // 清空选择文件名称
			}
			if (Template == "")
				return false;
			var extend = Template.substring(Template.lastIndexOf(".") + 1);
			if (!(extend == "xls" || extend == "xlsx")) {
				alert("请选择xls文件")
				return false;
			}

			xlApp = new ActiveXObject("Excel.Application"); // 固定
			xlBook = xlApp.Workbooks.Add(Template); // 固定
			xlsheet = xlBook.WorkSheets("Sheet1"); // Excel下标的名称

			i = 2

			while (Flag = 1) {
				IInString = ""
				StrValue = StringIsNull(xlsheet.cells(i, 1).Value);
				if (StrValue == "")
					break;
				IInString = StrValue;

				StrValue = StringIsNull(xlsheet.cells(i, 4).Value);
				IInString = IInString + "^" + StrValue;

				var ReturnValue = tkMakeServerCall("web.DHCCRM.SetPlan",
						"CreateICDDataGol", IInString);
				i = i + 1
			}

			xlApp.Quit();
			xlApp = null;
			xlsheet = null;

			var Return = tkMakeServerCall("web.DHCCRM.SetPlan",
					"ImportICDDataByGol")
			
			if (Return == 0) {
				alert("导入成功!");
				fusicdstore.load({
					params : {
						start : 0,
						limit : fusicdbbar.pageSize
					}
				});
			}
		} catch (e) {
			alert(e + "^" + e.message);
		}

	}
	function Import_ct() {
		
		var kill = tkMakeServerCall("web.DHCCRM.SetPlan", "KillLocDataGlobal");
		try {
			
			var Template = "";
			var obj = document.getElementById("File")
			if (obj) {
				obj.click();
				Template = obj.value;
				obj.outerHTML = obj.outerHTML; // 清空选择文件名称
			}
			if (Template == "")
				return false;
			var extend = Template.substring(Template.lastIndexOf(".") + 1);
			if (!(extend == "xls" || extend == "xlsx")) {
				alert("请选择xls文件")
				return false;
			}
			
			xlApp = new ActiveXObject("Excel.Application"); // 固定
			xlBook = xlApp.Workbooks.Add(Template); // 固定
			xlsheet = xlBook.WorkSheets("Sheet1"); // Excel下标的名称

			i = 2

			while (Flag = 1) {
				IInString = ""
				StrValue = StringIsNull(xlsheet.cells(i, 1).Value);
				if (StrValue == "")
					break;
				IInString = StrValue;

				StrValue = StringIsNull(xlsheet.cells(i, 4).Value);
				IInString = IInString + "^" + StrValue;

				
				var ReturnValue = tkMakeServerCall("web.DHCCRM.SetPlan",
						"CreateLocDataGol", IInString);
				i = i + 1
			}

			xlApp.Quit();
			xlApp = null;
			xlsheet = null;

			var Return = tkMakeServerCall("web.DHCCRM.SetPlan",
					"ImportLocDataByGol")
			if (Return == 0) {
				alert("导入成功!")
			}
		} catch (e) {
			alert(e + "^" + e.message);
		}
	
	}

	var sdscm = new Ext.grid.ColumnModel([{
				header : '文本值',
				dataIndex : 'SDSTextVal'
			}, {
				header : '单位',
				dataIndex : 'SDSUnit'
			}, {
				header : '默认值',
				dataIndex : 'SDSDefaultValue',
				renderer : function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'
							+ (v == 'true' ? '-on' : '') + ' x-grid3-cc-'
							+ this.id + '">&#160;</div>';
				}
			}, {
				header : '顺序号',
				dataIndex : 'SDSSequence'
			}, {
				header : '描述项',
				dataIndex : 'SDSDesc',
				renderer : function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'
							+ (v == 'true' ? '-on' : '') + ' x-grid3-cc-'
							+ this.id + '">&#160;</div>';
				}
			}]);

	var fusbtbar = new Ext.Toolbar({

		items : [{
					xtype : 'tbbutton',
					text : '添加',
					iconCls : 'add',
					handler : function() {
						var selectedrow = null;
						fusbevent(fusbstore, selectedrow, 'add');
					}
				}, {
					xtype : 'tbbutton',
					text : '修改',
					iconCls : 'option',
					id : 'fusbupdate',
					handler : function() {

						var rows = fusbgrid.getSelectionModel().getSelections();
						var selectedrow = fusbgrid.getSelectionModel()
								.getSelected();
						if (rows.length == 0) {
							Ext.Msg.show({
										title : '错误',
										msg : '请选择要修改的行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else if (rows.length > 1) {

							Ext.Msg.show({
										title : '错误',
										msg : '只允许选择一行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else {
							fusbevent(fusbstore, selectedrow, 'edit');
						}
					}
				}, {
					xtype : 'tbbutton',
					text : '删除',
					iconCls : 'remove',
					id : 'fusbdelete',
					handler : function() {
						var rows = fusbgrid.getSelectionModel().getSelections();
						if (rows.length == 0) {
							alert("请选择要删除的行")
							return;
							Ext.Msg.show({
										title : '错误',
										msg : '请选择要删除的行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						}
						if (!confirm("确定要删除吗？")) {
							return;
						}
						var selectedrow = fusbgrid.getSelectionModel()
								.getSelected();
						var fusbUrl = 'dhccrmbaseset1.csp?actiontype=' + 'del'
								+ '&FUSRowId=' + selectedrow.get('FUSRowId');

						Ext.Ajax.request({
									url : fusbUrl,
									waitMsg : '删除中...',
									failure : function(result, request) {
										Ext.Msg.show({
													title : '错误',
													msg : '请检查网络连接!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									},
									success : function(result, request) {
										var jsonData = Ext.util.JSON
												.decode(result.responseText);
										if (jsonData.success == 'true') {

											fusbstore.load({
														params : {
															start : 0,
															limit : 20
														}
													});

										} else {
											Ext.MessageBox.show({
														title : '错误',
														msg : jsonData.info,
														buttons : Ext.MessageBox.OK,
														icon : Ext.MessageBox.ERROR
													});
										}
									},
									scope : this
								});
					}
				}, {
					xtype : 'tbbutton',
					text : '查看',
					iconCls : 'find',
					id : 'fusbLook',
					handler : function() {

						var rows = fusbgrid.getSelectionModel().getSelections();
						var selectedrow = fusbgrid.getSelectionModel()
								.getSelected();
						if (rows.length == 0) {
							Ext.Msg.show({
										title : '错误',
										msg : '请选择要查看的行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else if (rows.length > 1) {

							Ext.Msg.show({
										title : '错误',
										msg : '只允许选择一行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else {
							fusbevent(fusbstore, selectedrow, 'Look');
						}
					}
				}]
	});

	var fusdtbar = new Ext.Toolbar({

		items : [{
			xtype : 'tbbutton',
			text : '添加',
			iconCls : 'add',
			handler : function() {
				var rows = fusbgrid.getSelectionModel().getSelections();
				var selectedfusbrow = fusbgrid.getSelectionModel()
						.getSelected();
				var selectedfusdrow = null;
				if (rows.length == 0) {
					Ext.Msg.show({
								title : '错误',
								msg : '请先选择一个主题!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				} else if (rows.length > 1) {

					Ext.Msg.show({
								title : '错误',
								msg : '只允许选择一行!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				} else {
					fusdevent(fusdstore, selectedfusbrow, selectedfusdrow,
							'fusdadd');
				}
			}
		}, {
			xtype : 'tbbutton',
			text : '修改',
			iconCls : 'option',
			id : 'fusdupdate',
			handler : function() {

				var rows = fusdgrid.getSelectionModel().getSelections();
				var selectedfusbrow = null;
				var selectedfusdrow = fusdgrid.getSelectionModel()
						.getSelected();
				if (rows.length == 0) {
					Ext.Msg.show({
								title : '错误',
								msg : '请选择要修改的行!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				} else if (rows.length > 1) {

					Ext.Msg.show({
								title : '错误',
								msg : '只允许选择一行!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				} else {
					fusdevent(fusdstore, selectedfusbrow, selectedfusdrow,
							'fusdedit');
				}
			}
		}, {
			xtype : 'tbbutton',
			text : '删除',
			iconCls : 'remove',
			id : 'fusddelete',
			handler : function() {
						var rows = fusdgrid.getSelectionModel().getSelections();
						
						if (rows.length == 0) {
							
							alert("请选择要删除的行")
							return;
							
							Ext.Msg.show({
										title : '错误',
										msg : '请选择要删除的行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						}
				if (!confirm("确定要删除吗？")) {
					return;
				}
				var selectedrow = fusdgrid.getSelectionModel().getSelected();

				var fusdUrl = 'dhccrmbaseset1.csp?actiontype=' + 'fusddel'
						+ '&SDRowId=' + selectedrow.get('SDRowId');
				var fusdUrl2 = 'dhccrmbaseset1.csp?actiontype=fusdlist&FUSRowId='
						+ selectedrow.get('SDRowId').split("||")[0];

				Ext.Ajax.request({

							url : fusdUrl,
							waitMsg : '删除中...',
							failure : function(result, request) {
								Ext.Msg.show({
											title : '错误',
											msg : '请检查网络连接!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {

									fusdstore.proxy.conn.url = fusdUrl2

									fusdstore.load({
												params : {
													start : 0,
													limit : 20
												}
											});

								} else {
									Ext.MessageBox.show({
												title : '错误',
												msg : jsonData.info,
												buttons : Ext.MessageBox.OK,
												icon : Ext.MessageBox.ERROR
											});
								}
							},
							scope : this
						});
			}
		}, {
			xtype : 'tbbutton',
			text : '查看',
			iconCls : 'find',
			id : 'fusdLook',
			handler : function() {

				var rows = fusdgrid.getSelectionModel().getSelections();
				var selectedfusbrow = null;
				var selectedfusdrow = fusdgrid.getSelectionModel()
						.getSelected();
				if (rows.length == 0) {
					Ext.Msg.show({
								title : '错误',
								msg : '请选择要查看的行!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				} else if (rows.length > 1) {

					Ext.Msg.show({
								title : '错误',
								msg : '只允许选择一行!',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				} else {
					fusdevent(fusdstore, selectedfusbrow, selectedfusdrow,
							'fusdlook');
				}
			}
		}]
	});

	var sdstbar = new Ext.Toolbar({

				items : [{
					xtype : 'tbbutton',
					text : '添加',
					iconCls : 'add',
					handler : function() {
						var rows = fusdgrid.getSelectionModel().getSelections();
						var selectedfusdrow = fusdgrid.getSelectionModel()
								.getSelected();
						var selectedsdsrow = null;
						if (rows.length == 0) {
							Ext.Msg.show({
										title : '错误',
										msg : '请先选择一个主题内容!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else if (rows.length > 1) {

							Ext.Msg.show({
										title : '错误',
										msg : '只允许选择一行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else {
							sdsevent(sdsstore, selectedfusdrow, selectedsdsrow,
									'sdsadd');
						}
					}
				}, {
					xtype : 'tbbutton',
					text : '修改',
					iconCls : 'option',
					id : 'sdsupdate',
					handler : function() {

						var rows = sdsgrid.getSelectionModel().getSelections();
						var selectedfusdrow = fusdgrid.getSelectionModel()
								.getSelected();
						var selectedsdsrow = sdsgrid.getSelectionModel()
								.getSelected();
						if (rows.length == 0) {
							Ext.Msg.show({
										title : '错误',
										msg : '请选择要修改的行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else if (rows.length > 1) {

							Ext.Msg.show({
										title : '错误',
										msg : '只允许选择一行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else {
							sdsevent(sdsstore, selectedfusdrow, selectedsdsrow,
									'sdsedit');
						}
					}
				}, {
					xtype : 'tbbutton',
					text : '删除',
					iconCls : 'remove',
					id : 'sdsdelete',
					handler : function() {
						var rows = sdsgrid.getSelectionModel().getSelections();
						
						if (rows.length == 0) {
							
							alert("请选择要删除的行")
							return;
							
							Ext.Msg.show({
										title : '错误',
										msg : '请选择要删除的行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						}
						if (!confirm("确定要删除吗？")) {
							return;
						}
						var selectedrow = sdsgrid.getSelectionModel()
								.getSelected();

						var sdsUrl = 'dhccrmbaseset1.csp?actiontype='
								+ 'sdsdel' + '&SDSRowId='
								+ selectedrow.get('SDSRowId');

						Ext.Ajax.request({
									url : sdsUrl,
									waitMsg : '删除中...',
									failure : function(result, request) {
										Ext.Msg.show({
													title : '错误',
													msg : '请检查网络连接!',
													buttons : Ext.Msg.OK,
													icon : Ext.MessageBox.ERROR
												});
									},
									success : function(result, request) {
										var jsonData = Ext.util.JSON
												.decode(result.responseText);
										if (jsonData.success == 'true') {

											sdsstore.load({
														params : {
															start : 0,
															limit : 20
														}
													});

										} else {
											Ext.MessageBox.show({
														title : '错误',
														msg : jsonData.info,
														buttons : Ext.MessageBox.OK,
														icon : Ext.MessageBox.ERROR
													});
										}
									}
								});
					}
				}, {
					xtype : 'tbbutton',
					text : '查看',
					iconCls : 'find',
					id : 'sdslook',
					handler : function() {

						var rows = sdsgrid.getSelectionModel().getSelections();
						var selectedfusdrow = null;
						var selectedsdsrow = sdsgrid.getSelectionModel()
								.getSelected();
						if (rows.length == 0) {
							Ext.Msg.show({
										title : '错误',
										msg : '请选择要查看的行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else if (rows.length > 1) {

							Ext.Msg.show({
										title : '错误',
										msg : '只允许选择一行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else {
							sdsevent(sdsstore, selectedfusdrow, selectedsdsrow,
									'sdslook');
						}
					}
				}]
			});

	var fusbbbar = new Ext.PagingToolbar({
				displayInfo : true,
				displayMsg : '当前显示{0} - {1},共计{2}',
				emptyMsg : "没有数据",
				pageSize : 20,
				store : fusbstore
			});

	var sdsbbar = new Ext.PagingToolbar({
				displayInfo : true,
				displayMsg : '当前显示{0} - {1},共计{2}',
				emptyMsg : "没有数据",
				pageSize : 20,
				store : sdsstore
			});

	var fusdbbar = new Ext.PagingToolbar({

				pageSize : 20,
				store : fusdstore,
				displayInfo : true,
				displayMsg : '当前显示{0} - {1},共计{2}',
				emptyMsg : "没有数据"

			});
	var fusicdbbar = new Ext.PagingToolbar({

				pageSize : 20,
				store : fusicdstore,
				displayInfo : true,
				displayMsg : '当前显示{0} - {1},共计{2}',
				emptyMsg : "没有数据"

			});
	var fusctbbar = new Ext.PagingToolbar({

				pageSize : 20,
				store : fusctstore,
				displayInfo : true,
				displayMsg : '当前显示{0} - {1},共计{2}',
				emptyMsg : "没有数据"

			});
		
	fusdstore.on('beforeload', function() {
				
				fusdstore.proxy.conn.url  = 'dhccrmbaseset1.csp?actiontype=fusdlist&FUSRowId='
						+ TMPFusId;
			})
	fusicdstore.on('beforeload', function() {
				
				fusicdstore.proxy.conn.url  = 'dhccrmbaseset1.csp?actiontype=icdlist&FUSRowId='
						+ TMPFusId;
			})
	fusctstore.on('beforeload', function() {
				
				fusctstore.proxy.conn.url  = 'dhccrmbaseset1.csp?actiontype=ctlist&FUSRowId='
						+ TMPFusId;
			})
	sdsstore.on('beforeload', function() {
		
				sdsstore.proxy.conn.url = 'dhccrmbaseset1.csp?actiontype=sdslist&SDRowId='
						+ TMPfusdid;
			})
	var fusbgrid = new Ext.grid.GridPanel({

				region : 'west',
				width : 300,
				title : '随访主题',
				collapsible : true,
				frame : true,
				viewConfig : {
					forceFit : true
				},
				store : fusbstore,
				cm : fusbcm,
				tbar : fusbtbar,
				bbar : fusbbbar

			});

	var fusdgrid = new Ext.grid.GridPanel({

				// region : 'center',
				frame : true,
				
				title : '主题内容',
				viewConfig : {
					forceFit : true
				},
				store : fusdstore,
				cm : fusdcm,
				tbar : fusdtbar,
				bbar : fusdbbar

			});

	var sdsgrid = new Ext.grid.GridPanel({

				region : 'east',
				width : 250,
				collapsible : true,
				frame : true,
				title : '内容选择',
				viewConfig : {
					forceFit : true
				},
				store : sdsstore,
				cm : sdscm,
				tbar : sdstbar,
				bbar : sdsbbar
			});

	fusbgrid.on('rowclick', function(grid, rowIndex, event) {

		var fusbrecord = fusbstore.getAt(rowIndex);
		var fusrowid = fusbrecord.get('FUSRowId');
		var fusactive = fusbrecord.get('FUSActive');
		TMPFusId=fusrowid;
		if (fusactive == 'true') {
			Ext.getCmp('fusbupdate').disable();
			Ext.getCmp('fusbdelete').disable();
			Ext.getCmp('fusdupdate').disable();
			Ext.getCmp('fusddelete').disable();
			Ext.getCmp('sdsupdate').disable();
			Ext.getCmp('sdsdelete').disable();
		} else {
			Ext.getCmp('fusbupdate').enable();
			Ext.getCmp('fusbdelete').enable();
			Ext.getCmp('fusdupdate').enable();
			Ext.getCmp('fusddelete').enable();
			Ext.getCmp('sdsupdate').enable();
			Ext.getCmp('sdsdelete').enable();
		}

		fusdstore.proxy.conn.url = 'dhccrmbaseset1.csp?actiontype=fusdlist&FUSRowId='
				+ fusrowid;
		fusdstore.load({
					params : {

						start : 0,
						limit : fusdbbar.pageSize
					}
				});
		fusicdstore.proxy.conn.url = 'dhccrmbaseset1.csp?actiontype=icdlist&FUSRowId='
				+ fusrowid;
		fusicdstore.load({
					params : {

						start : 0,
						limit : fusicdbbar.pageSize
					}
				});
		fusctstore.proxy.conn.url = 'dhccrmbaseset1.csp?actiontype=ctlist&FUSRowId='
				+ fusrowid;
		fusctstore.load({
					params : {
						start : 0,
						limit : fusctbbar.pageSize
					}
				});


	});
	fusdgrid.on('rowclick', function(grid, rowIndex, event) {

		var fusdrecord = fusdstore.getAt(rowIndex);
		var fusdrowid = fusdrecord.get('SDRowId');
		TMPfusdid=fusdrowid;
		sdsstore.proxy.conn.url = 'dhccrmbaseset1.csp?actiontype=sdslist&SDRowId='
				+ fusdrowid;
		sdsstore.load({
					params : {
						start : 0,
						limit : sdsbbar.pageSize
					}
				});

	});
	var fusicdtbar = new Ext.Toolbar({

		items : [{
					xtype : 'tbbutton',
					text : '导入',
					iconCls : 'upload',
					id : 'fusicdimport',
					handler : Import_click
				}, {
					xtype : 'tbbutton',
					text : '删除',
					iconCls : 'remove',
					id : 'fusicddelete',
					handler : function() {
						
						var rows = icdgrid.getSelectionModel().getSelections();
						
						if (rows.length == 0) {
							
							alert("请选择要删除的行")
							return;
							
							Ext.Msg.show({
										title : '错误',
										msg : '请选择要删除的行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						}
						
						if (!confirm("确定要删除吗？")) {
							return;
						}
						var selectedrow = icdgrid.getSelectionModel()
								.getSelected();

						var fusICDUrl = 'dhccrmbaseset1.csp?actiontype='
								+ 'icddel' + '&ICDRowId='
								+ selectedrow.get('ICDRowId');

						Ext.Ajax.request({
							url : fusICDUrl,
							waitMsg : '删除中...',
							failure : function(result, request) {
								Ext.Msg.show({
											title : '错误',
											msg : '请检查网络连接!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									var fusrowid = selectedrow.get('ICDRowId')
											.split('||')[0];
									fusicdstore.proxy.conn.url = 'dhccrmbaseset1.csp?actiontype=icdlist&FUSRowId='
											+ fusrowid;
									fusicdstore.load({
												params : {
													start : 0,
													limit : fusicdbbar.pageSize
												}
											});

								} else {
									Ext.MessageBox.show({
												title : '错误',
												msg : jsonData.info,
												buttons : Ext.MessageBox.OK,
												icon : Ext.MessageBox.ERROR
											});
								}
							},
							scope : this
						});
					}
				}]
	});
	
	var icdgrid = new Ext.grid.GridPanel({
				frame : true,
				title : '主题ICD',
				viewConfig : {
					forceFit : true
				},
				store : fusicdstore,
				cm : fusicdcm,
				tbar : fusicdtbar,
				bbar : fusicdbbar

			});
	var fuscttbar = new Ext.Toolbar({

		items : [{
		xtype : 'tbbutton',
			text : '导入',
			iconCls : 'upload',
			id : 'fusctimport',
			handler : Import_ct
		},{
					xtype : 'tbbutton',
					text : '添加',
					iconCls : 'add',
					handler : function() {
						var rows = fusbgrid.getSelectionModel().getSelections();
						var selectedfusbrow = fusbgrid.getSelectionModel()
								.getSelected();
						var selectedfusdrow = null;
						if (rows.length == 0) {
							Ext.Msg.show({
										title : '错误',
										msg : '请先选择一个主题!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else if (rows.length > 1) {

							Ext.Msg.show({
										title : '错误',
										msg : '只允许选择一行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						} else {
							fusctevent(fusctstore, selectedfusbrow,
									selectedfusdrow, 'fusctadd');
						}
					}
				},
				{
			xtype : 'tbbutton',
			text : '删除',
			iconCls : 'remove',
			id : 'fusctdelete',
			handler : function() {
				var rows = ctgrid.getSelectionModel().getSelections();
						
						if (rows.length == 0) {
							
							alert("请选择要删除的行")
							return;
							
							Ext.Msg.show({
										title : '错误',
										msg : '请选择要删除的行!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
						}
				if (!confirm("确定要删除吗？")) {
					return;
				}
				var selectedrow = ctgrid.getSelectionModel().getSelected();

				var fusCTUrl = 'dhccrmbaseset1.csp?actiontype=' + 'ctdel'
						+ '&LocRowId=' + selectedrow.get('LocRowId');

				Ext.Ajax.request({
					url : fusCTUrl,
					waitMsg : '删除中...',
					failure : function(result, request) {
						Ext.Msg.show({
									title : '错误',
									msg : '请检查网络连接!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});
					},
					success : function(result, request) {
						var jsonData = Ext.util.JSON
								.decode(result.responseText);
						if (jsonData.success == 'true') {
							var fusrowid = selectedrow.get('LocRowId').split('||')[0];
							fusctstore.proxy.conn.url = 'dhccrmbaseset1.csp?actiontype=ctlist&FUSRowId='
									+ fusrowid;
							fusctstore.load({
										params : {
											start : 0,
											limit : 20
										}
									});

						} else {
							Ext.MessageBox.show({
										title : '错误',
										msg : jsonData.info,
										buttons : Ext.MessageBox.OK,
										icon : Ext.MessageBox.ERROR
									});
						}
					},
					scope : this
				});
			}
		}]
	});	
	var LocStore = new Ext.data.Store({

				url : 'dhccrmreviewremindsend1.csp?actiontype=CTLocList',

				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : "rows",
							id : 'CTLocRowID'
						}, [{
									name : 'CTLocRowID'
								}, {
									name : 'CTLocName'
								}])

			});
	LocStore.on('beforeload', function() {

		LocStore.proxy.conn.url = 'dhccrmreviewremindsend1.csp?actiontype=CTLocList'
				+ '&CTLocDesc=' + Ext.getCmp('CTLoc').getRawValue();
	});		
			
	
	
	var ctgrid = new Ext.grid.EditorGridPanel({
		        id:'ctgrid',
				frame : true,
				title : '主题科室',
				viewConfig : {
					forceFit : true
				},
				clicksToEdit:2,
				store : fusctstore,
				sm:	new Ext.grid.CheckboxSelectionModel(),  
				cm : fusctcm,
				tbar : fuscttbar,
				bbar : fusctbbar

			});
	
			ctgrid.on('afteredit', function(e) {//这里就是你编辑完一格的数据后就执行的事件，
											
						var LocRowId = e.record.get("LocRowId");
						//参数都是String类型的
						var FUSRowId= LocRowId.split("||",1);
						//alert(FUSRowId);
						/*var LocCode = e.record.get("LocCode");
						if(LocCode == null){
							LocCode = "";
						};						
						var LocDesc = e.record.get("LocDesc");
						if(LocDesc == null){
							LocDesc = "";
						};*/
						/*if (rows.length == 0) {
							Ext.Msg.show({
										title : '错误',
										msg : '请选择随访主题!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
				        }*/
						var LocDR = e.record.get("Loc");
						if(LocDR == null||LocDR == ""){
							LocDR = "";
							Ext.Msg.show({
										title : '错误',
										msg : '请选择科室!',
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									})
						}else{

						if (LocRowId) {
						} else
							LocRowId = '';
						var Instring = ""+"^"+LocRowId + "^"  + LocDR 
						//alert(Instring)
						var ret = tkMakeServerCall("web.DHCCRM.CRMBaseSet",//这里调用的保存方法，这里并不是在填完时间才保存的，是编辑单元格完就保存的
								"SaveLoc", LocRowId, Instring);
			}
								

						//if (ret == 0)
							fusctstore.proxy.conn.url = 'dhccrmbaseset1.csp?actiontype=ctlist&FUSRowId='
									+ FUSRowId;
							fusctstore.load({
										params : {
											start : 0,
											limit : 20
										}
									});

					});



	var fusdpanel = new Ext.TabPanel({

				region : 'center',
				activeTab : fusdgrid,
				items : [fusdgrid, icdgrid,ctgrid]
			});
	var main = new Ext.Viewport({

				layout : 'border',
				collapsible : true,
				items : [fusbgrid, fusdpanel, sdsgrid]
			});

	fusbstore.load({

				params : {
					start : 0,
					limit : fusbbbar.pageSize
				}

			});
})
