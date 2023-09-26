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
				emptyText : '��ѡ��ͳ�ƿھ�',
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
				emptyText : '��ѡ��ͳ�ƿھ�',
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
				emptyText : '��ѡ��ͳ�ƿھ�',
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
				header : 'ͳ�Ʒ������',
				dataIndex : 'GrpCode',
				sortable : true,
				width : 80,
				sortable : true
			}, {
				header : 'ͳ�Ʒ�������',
				dataIndex : 'GrpDesc',
				width : 80,
				sortable : true
			}, {
				header : 'סԺ�ھ�',
				dataIndex : 'IDFTDesc',
				width : 60,
				sortable : true,
				editor : ComboxsecGrp
			}, {
				header : '����ھ�',
				dataIndex : 'ODFTDesc',
				width : 60,
				sortable : true,
				editor : ComboxsecGrp
			}, {
				header : '����ھ�',
				dataIndex : 'EDFTDesc',
				width : 60,
				sortable : true,
				editor : ComboxsecGrp
			}, {
				header : '���ھ�',
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

						// /�����ϸ����
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
							alert("��ѡ��ѡ�");
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
				header : 'ͳ���������',
				dataIndex : 'subgrpCode',
				width : 80,
				sortable : true,
				editor : EditTextField
			}, {
				header : 'ͳ����������',
				dataIndex : 'subgrpDesc',
				width : 80,
				sortable : true,
				editor : EditTextField
			}, {
				header : 'סԺ�ھ�',
				dataIndex : 'DFTI',
				width : 60,
				sortable : true,
				editor : ComboxsupGrp
			}, {
				header : '����ھ�',
				dataIndex : 'DFTO',
				width : 60,
				sortable : true,
				editor : ComboxsupGrp
			}, {
				header : '����ھ�',
				dataIndex : 'DFTE',
				width : 60,
				sortable : true,
				editor : ComboxsupGrp
			}, {
				header : '���ھ�',
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
							alert("����ά������!");
							return;
						}
						if (!GrpId || GrpId == "") {
							alert("��ѡ��ѡ�");
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
text: '<span style="line-Height:1">����</span>',
icon   : '../images/uiimages/edit_add.png',
							handler : function() {
								var sm = stwlstatGrid.getSelectionModel();
								var ICDCaterecord = sm.getSelected();
								if (!sm || !ICDCaterecord) {
									Ext.Msg.alert("��ʾ", "��ѡ��Ҫ��ӵķ���!")
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
text: '<span style="line-Height:1">ɾ��</span>',
icon   : '../images/uiimages/edit_remove.png',
							handler : function() {
								var sm = stwlstatitemGrid.getSelectionModel();
								var record = sm.getSelected();
								if (!sm || !record) {
									alert("��ѡ��Ҫɾ�����У�");
									return;
								}
								Ext.Msg.confirm('��Ϣ', 'ȷ��Ҫɾ����', function(btn) {
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

	// / add 20141118 ��ϸ����
	var columnModel = new Ext.grid.ColumnModel([{
				header : 'ID',
				dataIndex : 'GrpItemId',
				sortable : true,
				width : 30,
				sortable : true
			}, {
				header : '����',
				dataIndex : 'ArcimDesc',
				sortable : true,
				width : 100,
				sortable : true
			}, {
				header : 'סԺ�ھ�',
				dataIndex : 'DFTI',
				sortable : true,
				width : 60,
				sortable : true,
				editor : Comboxsec
			}, {
				header : '����ھ�',
				dataIndex : 'DFTO',
				sortable : true,
				width : 60,
				sortable : true,
				editor : Comboxsec
			}, {
				header : '����ھ�',
				dataIndex : 'DFTE',
				sortable : true,
				width : 60,
				sortable : true,
				editor : Comboxsec
			}, {
				header : '���ھ�',
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
							alert("��ѡ��ѡ�");
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
text: '<span style="line-Height:1">ɾ��</span>',
icon   : '../images/uiimages/edit_remove.png',
					handler : function() {
						var sm = detailGrid.getSelectionModel();
						var record = sm.getSelected();
						if (!sm || !record) {
							alert("��ѡ��Ҫɾ�����У�");
							return;
						}
						Ext.Msg.confirm('��Ϣ', 'ȷ��Ҫɾ����', function(btn) {
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
					text: '<span style="line-Height:1">ȫ��ɾ��</span>',
icon   : '../images/uiimages/edit_remove.png',					
					handler : function() {
						subgrpId = choicesubgrpId
						grpId = choicegrpId
						if (!subgrpId || subgrpId == "") {
							Ext.Msg.show({
										title : '����',
										msg : "����ѡ��Ҫά�������飡",
										buttons : Ext.Msg.OK,
										icon : Ext.MessageBox.ERROR
									});
							return;
						}
						Ext.Msg.confirm('��Ϣ', 'ȷ��Ҫȫ��ɾ����', function(btn) {
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
text: '<span style="line-Height:1">���</span>',
icon   : '../images/uiimages/search.png',
					handler : function() {
						grpId = choicegrpId;
						SubGrpId = choicesubgrpId;
						if (!grpId || grpId == "" || !SubGrpId
								|| SubGrpId == "") {
							Ext.Msg.show({
										title : '����',
										msg : "��ѡ��Ҫ���Ĵ��飡",
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

	// ��ʾ����Ҫ��ӵ���Ŀ��ϸ

	var selectedKpiIds = [];
	var csm = new Ext.grid.CheckboxSelectionModel() // �½���ѡ��Ķ���ʹ�õ�ʱ��ֱ��д
	var alldetailsCM = new Ext.grid.ColumnModel([csm, {
				header : 'ID',
				dataIndex : 'ArcimId',
				sortable : true,
				width : 40,
				sortable : true
			}, {
				header : '����',
				dataIndex : 'ArcimCode',
				sortable : true,
				width : 80,
				sortable : true
			}, {
				header : '����',
				dataIndex : 'ArcimDesc',
				sortable : true,
				width : 120,
				sortable : true
			}, {
				header : '����',
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
text: '<span style="line-Height:1">����</span>',
icon   : '../images/uiimages/edit_add.png',
						handler : function() {
							var grpId = choicegrpId
							var subgrpId = choicesubgrpId
							if (!grpId || grpId == "") {
								Ext.Msg.show({
											title : '����',
											msg : "����ѡ��Ҫά���Ĵ��飡",
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
								return;
							}
							if (!subgrpId || subgrpId == "") {
								Ext.Msg.show({
											title : '����',
											msg : "����ѡ��Ҫά�������飡",
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
											title : 'ע��',
											msg : '��ѡ��Ҫ��ӵ���Ŀ��',
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
					}, '-', '������������', {
						id : 'searchCond',
						width : 80,
						xtype : 'combo',
						mode : 'local',
						emptyText : '��ѡ����������',
						triggerAction : 'all',
						forceSelection : true,
						editable : false,
						displayField : 'value',
						valueField : 'name',
						store : new Ext.data.JsonStore({
									fields : ['name', 'value'],
									data : [{
												name : 'Code',
												value : '����'
											}, {
												name : 'Name',
												value : '����'
											}, {
												name : 'ItemCat',
												value : 'ҽ���ӷ���'
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
				title : 'ͳ����Ŀά��',
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
																	// wz.����ط����õĲ�׼ȷ��
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
