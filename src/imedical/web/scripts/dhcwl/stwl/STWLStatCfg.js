(function() {
	Ext.ns("dhcwl.stwl.statcfg");
})();

dhcwl.stwl.statcfg = function() {
	var serviceUrl = "dhcwl/stwl/StatCfgService.csp";
	var outThis = this
	var choicegrpId = ""
	var choicesubgrpId = ""
	var choicedSearcheCond = ""
	var searcheValue = ""
	var choicesubgrpItemId = ""
	var HL = 650, WL = 650
	var Comboxsec = new Ext.form.ComboBox({
				width : 130,
				editable : true,
				mode : 'remote',
				triggerAction : 'all',
				emptyText : '请选择统计口径',
				displayField : 'Desc',
				valueField : 'Desc',
				store : new Ext.data.Store({
							proxy : new Ext.data.HttpProxy({
										url : serviceUrl + '?action=mulDFTInfo'
									}),
							reader : new Ext.data.ArrayReader({}, [{
												name : 'Code'
											}, {
												name : 'Desc'
											}])
						}),
				listeners : {
					'select' : function(combox) {
						Comboxsec.setValue(combox.getRawValue());
					}
				}
			});
	var ComboxsecGrp = new Ext.form.ComboBox({
				width : 130,
				editable : false,
				mode : 'remote',
				triggerAction : 'all',
				emptyText : '请选择统计口径',
				displayField : 'Desc',
				valueField : 'Desc',
				store : new Ext.data.Store({
							proxy : new Ext.data.HttpProxy({
										url : serviceUrl + '?action=mulDFTInfo'
									}),
							reader : new Ext.data.ArrayReader({}, [{
												name : 'Code'
											}, {
												name : 'Desc'
											}])
						}),
				listeners : {
					'select' : function(combox) {
						ComboxsecGrp.setValue(combox.getRawValue());
					}
				}
			});
	var ComboxsupGrp = new Ext.form.ComboBox({
				width : 130,
				editable : false,
				mode : 'remote',
				triggerAction : 'all',
				emptyText : '请选择统计口径',
				displayField : 'Desc',
				valueField : 'Desc',
				store : new Ext.data.Store({
							proxy : new Ext.data.HttpProxy({
										url : serviceUrl + '?action=mulDFTInfo'
									}),
							reader : new Ext.data.ArrayReader({}, [{
												name : 'Code'
											}, {
												name : 'Desc'
											}])
						}),
				listeners : {
					'select' : function(combox) {
						ComboxsecGrp.setValue(combox.getRawValue());
					}
				}
			});
	var columnModel = new Ext.grid.ColumnModel([{
				header : 'ID',
				dataIndex : 'GrpId',
				sortable : true,
				width : 30,
				sortable : true
			}, {
				header : '统计分类编码',
				dataIndex : 'GrpCode',
				sortable : true,
				width : 80,
				sortable : true
			}, {
				header : '统计分类描述',
				dataIndex : 'GrpDesc',
				width : 80,
				sortable : true
			}, {
				header : '住院口径',
				dataIndex : 'IDFTDesc',
				width : 60,
				sortable : true,
				editor : ComboxsecGrp
			}, {
				header : '门诊口径',
				dataIndex : 'ODFTDesc',
				width : 60,
				sortable : true,
				editor : ComboxsecGrp
			}, {
				header : '急诊口径',
				dataIndex : 'EDFTDesc',
				width : 60,
				sortable : true,
				editor : ComboxsecGrp
			}, {
				header : '体检口径',
				dataIndex : 'HDFTDesc',
				width : 60,
				sortable : true,
				editor : ComboxsecGrp
			}]);

	var store = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : serviceUrl + '?action=mulSearchGrp'
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'totalNum',
							root : 'root',
							fields : [{
										name : 'GrpId'
									}, {
										name : 'GrpCode'
									}, {
										name : 'GrpDesc'
									}, {
										name : 'IDFTDesc'
									}, {
										name : 'ODFTDesc'
									}, {
										name : 'EDFTDesc'
									}, {
										name : 'HDFTDesc'
									}]
						})
			});
	store.load();

	var stwlstatGrid = new Ext.grid.EditorGridPanel({
				id : stwlstatGrid,
				loadMask : true,
				stripeRows : false,
				frame : true,
				height : 180,
				store : store,
				enableColumnResize : true,
				cm : columnModel,
				clicksToEdit : 1,
				columnLines : true,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true,
							listeners : {
								rowselect : function(sm, row, rec) {
									var id = rec.get("ID");
								}
							}
						}),
				listeners : {
					'click' : function(ele, event) {
						var sm = stwlstatGrid.getSelectionModel();
						if (!sm)
							return;
						var record = sm.getSelected();
						if (!record)
							return;
						var grpId = record.get("GrpId");
						if (!grpId) {
							grpId = "";
							choicegrpId = grpId;
							return;
						}
						choicegrpId = grpId;

						storeStatItem.proxy.setUrl(encodeURI(serviceUrl
								+ '?action=list-statItem&GrpId=' + grpId));
						storeStatItem.load();
						stwlstatitemGrid.show();

						// /清空明细数据
						detailStore.removeAll();
						detailStore.reload();
						detailGrid.show();
					},
					'afteredit' : function(event) {
						GrpId = choicegrpId;
						originalValue = event.originalValue;
						value = event.value;
						field = event.field;
						if (!GrpId || GrpId == "") {
							alert("请选择选项！");
							return;
						}
						if (originalValue == value) {
							return;
						}
						dhcwl.mkpi.Util.ajaxExc(serviceUrl
								+ '?action=UpdateGrpRoute&GrpId=' + GrpId
								+ '&field=' + field + '&value=' + value);
					}
				}

			});
	var EditTextField = new Ext.form.TextField({
				allowBlank : true
			});
	var columnModelStatItem = new Ext.grid.ColumnModel([{
				header : 'ID',
				dataIndex : 'subGrpId',
				sortable : true,
				width : 30,
				sortable : true
			}, {
				header : '统计子类编码',
				dataIndex : 'subgrpCode',
				width : 80,
				sortable : true,
				editor : EditTextField
			}, {
				header : '统计子类描述',
				dataIndex : 'subgrpDesc',
				width : 80,
				sortable : true,
				editor : EditTextField
			}, {
				header : '住院口径',
				dataIndex : 'DFTI',
				width : 60,
				sortable : true,
				editor : ComboxsupGrp
			}, {
				header : '门诊口径',
				dataIndex : 'DFTO',
				width : 60,
				sortable : true,
				editor : ComboxsupGrp
			}, {
				header : '急诊口径',
				dataIndex : 'DFTE',
				width : 60,
				sortable : true,
				editor : ComboxsupGrp
			}, {
				header : '体检口径',
				dataIndex : 'DFTH',
				width : 60,
				sortable : true,
				editor : ComboxsupGrp
			}]);
	var storeStatItem = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : serviceUrl + '?action=list-statItem'
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'totalNums',
							root : 'root',
							fields : [{
										name : 'subGrpId'
									}, {
										name : 'subgrpCode'
									}, {
										name : 'subgrpDesc'
									}, {
										name : 'DFTI'
									}, {
										name : 'DFTO'
									}, {
										name : 'DFTE'
									}, {
										name : 'DFTH'
									}]
						})
			});
	storeStatItem.load();

	var stwlstatitemGrid = new Ext.grid.EditorGridPanel({
				id : 'statitemGrid',
				loadMask : true,
				stripeRows : false,
				frame : true,
				height : 400,
				enableColumnResize : true,
				clicksToEdit : 1,
				columnLines : true,
				store : storeStatItem,
				cm : columnModelStatItem,
				autoScroll : true,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true,
							listeners : {
								rowselect : function(sm, row, rec) {
									var id = rec.get("subGrpId");
								}
							}
						}),
				listeners : {
					'contextmenu' : function(event) {
						event.preventDefault();
					},
					'click' : function(ele, event) {
						var sm = stwlstatitemGrid.getSelectionModel();
						if (!sm)
							return;
						var record = sm.getSelected();
						if (!record)
							return;
						var subgrpId = record.get("subGrpId");
						if (!subgrpId) {
							subgrpId = "";
							choicesubgrpId = subgrpId;
							return;
						}
						choicesubgrpId = subgrpId;
						detailStore.proxy.setUrl(encodeURI(serviceUrl
								+ '?action=list-subGrpItem&GrpId='
								+ choicegrpId + '&subgrpId=' + choicesubgrpId));
						detailStore.load();
						detailGrid.show();
					},
					'afteredit' : function(event) {
						GrpId = choicegrpId;
						SubGrpId = choicesubgrpId;
						originalValue = event.originalValue;
						value = event.value;
						field = event.field;
						//alert(field);
						if(field!="subgrpCode")
						{
							alert("请先维护编码!");
							return;
						}
						if (!GrpId || GrpId == "") {
							alert("请选择选项！");
							return;
						}
						if (originalValue == value) {
							return;
						}
						dhcwl.mkpi.Util.ajaxExc(serviceUrl
								+ '?action=editSubGrp&GrpId=' + GrpId
								+ '&SubGrpId=' + SubGrpId + '&field=' + field
								+ '&value=' + value);
						storeStatItem.proxy.setUrl(encodeURI(serviceUrl
								+ '?action=list-statItem&GrpId=' + GrpId));
						storeStatItem.load();
						stwlstatitemGrid.show();

					}
				},
				tbar : new Ext.Toolbar([{
text: '<span style="line-Height:1">增加</span>',
icon   : '../images/uiimages/edit_add.png',
							handler : function() {
								var sm = stwlstatGrid.getSelectionModel();
								var ICDCaterecord = sm.getSelected();
								if (!sm || !ICDCaterecord) {
									Ext.Msg.alert("提示", "请选择要添加的分类!")
									return;
								}
								var initValue = {
									subGrpId : '',
									subgrpCode : '',
									subgrpDesc : '',
									DFTI : '',
									DFTO : '',
									DFTE : '',
									DFTH : ''
								};
								var p = new Ext.data.Record(initValue);
								stwlstatitemGrid.stopEditing();
								storeStatItem.insert(0, p);
								var sm = stwlstatitemGrid.getSelectionModel();
								sm.selectFirstRow();
							}
						}, '-', {
text: '<span style="line-Height:1">删除</span>',
icon   : '../images/uiimages/edit_remove.png',
							handler : function() {
								var sm = stwlstatitemGrid.getSelectionModel();
								var record = sm.getSelected();
								if (!sm || !record) {
									alert("请选择要删除的行！");
									return;
								}
								Ext.Msg.confirm('信息', '确定要删除？', function(btn) {
											if (btn == 'yes') {
												var ID = record.get("GrpId");
												storeStatItem.remove(record);
												dhcwl.mkpi.Util
														.ajaxExc(serviceUrl
																+ '?action=deleteSubGrp&GrpId='
																+ choicegrpId
																+ '&SubGrpId='
																+ choicesubgrpId);
												detailStore.removeAll();
												detailStore.reload();
												detailGrid.show();
											}
										});
							}
						}])
			});

	// / add 20141118 明细部分
	var columnModel = new Ext.grid.ColumnModel([{
				header : 'ID',
				dataIndex : 'GrpItemId',
				sortable : true,
				width : 30,
				sortable : true
			}, {
				header : '描述',
				dataIndex : 'ArcimDesc',
				sortable : true,
				width : 100,
				sortable : true
			}, {
				header : '住院口径',
				dataIndex : 'DFTI',
				sortable : true,
				width : 60,
				sortable : true,
				editor : Comboxsec
			}, {
				header : '门诊口径',
				dataIndex : 'DFTO',
				sortable : true,
				width : 60,
				sortable : true,
				editor : Comboxsec
			}, {
				header : '急诊口径',
				dataIndex : 'DFTE',
				sortable : true,
				width : 60,
				sortable : true,
				editor : Comboxsec
			}, {
				header : '体检口径',
				dataIndex : 'DFTH',
				sortable : true,
				width : 60,
				sortable : true,
				editor : Comboxsec
			}]);
	var detailStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : serviceUrl + '?action=list-subGrpItem&GrpId='
									+ choicegrpId + '&subgrpId='
									+ choicesubgrpId
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'totalNums',
							root : 'root',
							fields : [{
										name : 'GrpItemId'
									}, {
										name : 'ArcimDesc'
									}, {
										name : 'DFTI'
									}, {
										name : 'DFTO'
									}, {
										name : 'DFTE'
									}, {
										name : 'DFTH'
									}]
						})

			});
	detailStore.load();
	var detailGrid = new Ext.grid.EditorGridPanel({
				id : detailGrid,
				// stripeRows : true,
				loadMask : true,
				// height : 500,
				frame : true,
				store : detailStore,
				cm : columnModel,
				sm : new Ext.grid.RowSelectionModel(),
				clicksToEdit : 1,
				columnLines : true,
				layout : 'table',
				listeners : {
					'click' : function(ele, event) {
						var sm = detailGrid.getSelectionModel();
						if (!sm)
							return;
						var record = sm.getSelected();
						if (!record)
							return;
						var subgrpItemId = record.get("GrpItemId");
						if (!subgrpItemId) {
							subgrpItemId = "";
							choicesubgrpItemId = subgrpItemId;
							return;
						}
						choicesubgrpItemId = subgrpItemId;
					},
					'afteredit' : function(event) {
						GrpId = choicegrpId;
						SubGrpId = choicesubgrpId
						ItemId = choicesubgrpItemId
						originalValue = event.originalValue;
						value = event.value;
						field = event.field;
						if (!GrpId || GrpId == "" || !SubGrpId
								|| SubGrpId == "" || !ItemId || ItemId == "") {
							alert("请选择选项！");
							return;
						}
						if (originalValue == value) {
							return;
						}
						dhcwl.mkpi.Util.ajaxExc(serviceUrl
								+ '?action=UpdateItemDetails&GrpId=' + GrpId
								+ '&SubGrpId=' + SubGrpId + '&ItemId=' + ItemId
								+ '&field=' + field + '&value=' + value);

					}
				},
				tbar : new Ext.Toolbar([{
text: '<span style="line-Height:1">删除</span>',
icon   : '../images/uiimages/edit_remove.png',
					handler : function() {
						var sm = detailGrid.getSelectionModel();
						var record = sm.getSelected();
						if (!sm || !record) {
							alert("请选择要删除的行！");
							return;
						}
						Ext.Msg.confirm('信息', '确定要删除？', function(btn) {
									if (btn == 'yes') {
										var ID = record.get("GrpItemId");
										detailStore.remove(record);
										dhcwl.mkpi.Util
												.ajaxExc(serviceUrl
														+ '?action=DeleteSubGrpItem&ID='
														+ ID + '&SubGrp='
														+ choicesubgrpId
														+ '&Type=N');
										// this.refresh();
										// dhcwl_codecfg_showKpiWin.refreshCombo();
									}
								});
					}
				}, '-', {
					text: '<span style="line-Height:1">全部删除</span>',
icon   : '../images/uiimages/edit_remove.png',					
					handler : function() {
						subgrpId = choicesubgrpId
						grpId = choicegrpId
						if (!subgrpId || subgrpId == "") {
							Ext.Msg.show({
										title : '错误',
										msg : "请先选择要维护的子组！",
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							return;
						}
						Ext.Msg.confirm('信息', '确定要全部删除吗？', function(btn) {
									if (btn == 'yes') {
										detailStore.remove();
										dhcwl.mkpi.Util
												.ajaxExc(serviceUrl
														+ '?action=DeleteSubGrpItem&SubGrp='
														+ choicesubgrpId
														+ '&Type=A');
										detailStore.proxy
												.setUrl(encodeURI(serviceUrl
														+ '?action=list-subGrpItem&GrpId='
														+ grpId + '&subgrpId='
														+ subgrpId));
										detailStore.reload();
									}
								});
					}
				}, '-', {
text: '<span style="line-Height:1">检查</span>',
icon   : '../images/uiimages/search.png',
					handler : function() {
						grpId = choicegrpId;
						SubGrpId = choicesubgrpId;
						if (!grpId || grpId == "" || !SubGrpId
								|| SubGrpId == "") {
							Ext.Msg.show({
										title : '错误',
										msg : "请选择要检查的大组！",
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							return;
						}
						// dhcwl.mkpi.Util.ajaxExc(serviceUrl+'?action=addsubgrpitem&'+paraValues);
						allDetailStore.proxy.setUrl(encodeURI(serviceUrl
								+ '?action=all_detailsData&grpId=' + grpId
								+ '&searcheCond=' + choicedSearcheCond
								+ '&searcheValue=' + searcheValue
								+ '&checkData=Y'));
						allDetailStore.reload();
					}
				}])
			})

	// 显示所有要添加的项目明细

	var selectedKpiIds = [];
	var csm = new Ext.grid.CheckboxSelectionModel() // 新建复选框的对象，使用的时候直接写
	var alldetailsCM = new Ext.grid.ColumnModel([csm, {
				header : 'ID',
				dataIndex : 'ArcimId',
				sortable : true,
				width : 40,
				sortable : true
			}, {
				header : '代码',
				dataIndex : 'ArcimCode',
				sortable : true,
				width : 80,
				sortable : true
			}, {
				header : '描述',
				dataIndex : 'ArcimDesc',
				sortable : true,
				width : 120,
				sortable : true
			}, {
				header : '子类',
				dataIndex : 'SubGrp',
				sortable : true,
				width : 100,
				sortable : true
			}]);
	var grpId = 1;
	var allDetailStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : serviceUrl + '?action=all_detailsData'
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'totalNums',
							root : 'root',
							fields : [{
										name : 'ArcimId'
									}, {
										name : 'ArcimCode'
									}, {
										name : 'ArcimDesc'
									}, {
										name : 'SubGrp'
									}]
						})

			});
	allDetailStore.load();

	//
	var allDetailGrid = new Ext.grid.EditorGridPanel({
		id : allDetailGrid,
		// height : 500,
		frame : true,
		store : allDetailStore,
		cm : alldetailsCM,
		sm : csm, // new Ext.grid.RowSelectionModel(),
		clicksToEdit : 1,
		columnLines : true,
		tbar : new Ext.Toolbar({
					layout : 'hbox',
					// xtype : 'compositefield',
					items : [{
text: '<span style="line-Height:1">增加</span>',
icon   : '../images/uiimages/edit_add.png',
						handler : function() {
							var grpId = choicegrpId
							var subgrpId = choicesubgrpId
							if (!grpId || grpId == "") {
								Ext.Msg.show({
											title : '错误',
											msg : "请先选择要维护的大组！",
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
								return;
							}
							if (!subgrpId || subgrpId == "") {
								Ext.Msg.show({
											title : '错误',
											msg : "请先选择要维护的子组！",
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
								return;
							}
							var selectItemPara = "";
							var rowObj = allDetailGrid.getSelectionModel()
									.getSelections();
							var len = rowObj.length;
							if (len < 1) {
								Ext.Msg.show({
											title : '注意',
											msg : '请选择要添加的项目！',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.WARNING
										});
								return;
							} else {
								var idStr = "";
								for (var i = 0; i < len; i++) {
									ItemId = rowObj[i].get("ArcimId");
									if (idStr == "") {
										idStr = ItemId;
									} else {
										idStr = idStr + "-" + ItemId
									}

								}
								selectItemPara = idStr;
								// window.close();
							}
							paraValues = 'GrpId=' + grpId + '&SubGrpId='
									+ subgrpId + '&selectItemPara='
									+ selectItemPara;
							urlPara = serviceUrl
									+ '?action=list-subGrpItem&GrpId='
									+ choicegrpId + '&subgrpId='
									+ choicesubgrpId
							dhcwl.mkpi.Util.ajaxExc(serviceUrl
											+ '?action=addsubgrpitem&'
											+ paraValues, "", outThis.fch,
									outThis);
						}
					}, '-', '按条件搜索：', {
						id : 'searchCond',
						width : 80,
						xtype : 'combo',
						mode : 'local',
						emptyText : '请选择搜索类型',
						triggerAction : 'all',
						forceSelection : true,
						editable : false,
						displayField : 'value',
						valueField : 'name',
						store : new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data : [{
												name : 'Code',
												value : '代码'
											}, {
												name : 'Name',
												value : '描述'
											}, {
												name : 'ItemCat',
												value : '医嘱子分类'
											}]
								}),
						listeners : {
							'select' : function(combo) {
								// alert("combo="+combo.getValue()+"
								// "+combo.getRawValue())
								choicedSearcheCond = combo.getValue();// ele.getValue();
							}

						}
					}, {

						xtype : 'textfield',
						width : 120,
						flex : 1,
						id : 'searcheContValue',
						enableKeyEvents : true,
						allowBlank : true,
						listeners : {
							'keypress' : function(ele, event) {
								searcheValue = Ext.get("searcheContValue")
										.getValue();
								if ((event.getKey() == event.ENTER)) {
									allDetailStore.proxy
											.setUrl(encodeURI(serviceUrl
													+ '?action=all_detailsData&grpId='
													+ grpId + '&searcheCond='
													+ choicedSearcheCond
													+ '&searcheValue='
													+ searcheValue));
									allDetailStore.load();
								}
							}
						}
					}]
				})
	});
	var STWLStatForm = new Ext.Panel({
				// layout : 'form',
				// layout:'fit',
				items : [new Ext.Panel({
									columnWidth : .15,
									layout : 'form',
									border : false,
									labelWidth : 40,
									labelAlign : 'right',
									items : [stwlstatGrid]
								}), new Ext.Panel({
									columnWidth : .15,
									// layout : 'form',
									// border : false,
									layout : 'fit',
									labelWidth : 40,
									labelAlign : 'right',
									items : [stwlstatitemGrid]
								})]
			});
	var STWLStatItemForm = new Ext.Panel({
				id : 'STWLStatItemForm',
				frame : true,
				region : 'center',
				layout : 'fit',
				items : [detailGrid]
			});
	var STWLDetailForm = new Ext.Panel({
				id : 'STWLDetailForm',
				frame : true,
				region : 'center',
				layout : 'fit',
				items : [allDetailGrid]
			});

	var STWLStatPanel = new Ext.Panel({
				title : '统计项目维护',
				layout : 'column', // border
				layoutConfig : {
					columns : 3
				},
				items : [{
							layout : 'fit',
							items : STWLStatForm,
							height : HL,
							columnWidth : .33
						}, {
							height : HL,
							layout : 'fit',
							items : STWLStatItemForm,
							columnWidth : .33
						}, {
							layout : 'fit',
							items : STWLDetailForm,
							height : HL,
							columnWidth : .33
						}],
				listeners : {
					"resize" : function(win, width, height) {
						HL = height;
						WL = width;
						stwlstatitemGrid.setHeight(height - 180);// modify by
																	// wz.这个地方设置的不准确。
						// stwlstatitemGrid.setWidth(width);//
						detailGrid.setHeight(height);
						detailGrid.setWidth(width);
						allDetailGrid.setHeight(height);
						allDetailGrid.setWidth(width);
					}
				}
			});
	this.getSTWLStatPanel = function() {
		return STWLStatPanel;
	}
	this.fch = function() {
		detailStore.proxy.setUrl(encodeURI(urlPara));
		detailStore.reload();
		allDetailStore.proxy.setUrl(encodeURI(serviceUrl
				+ '?action=all_detailsData&grpId=' + choicegrpId
				+ '&searcheCond=' + choicedSearcheCond + '&searcheValue='
				+ searcheValue + '&checkData=N'));
		allDetailStore.reload();
		return;
	}
}
