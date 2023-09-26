(function() {
	Ext.ns("DHCMRTJ.ICD");
})();

DHCMRTJ.ICD.ShowWin = function() {
	var serviceUrl = "dhcwl/mrcfg/mrtjservice.csp";
	var outThis = this;
	var choiceICDCateId="";
	var choiceICDCateDetailsId="";

	var columnModel = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
				header : 'Id',
				dataIndex : 'ICDCId',
				align : 'center',
				width : 50,
				sortable : true
			}, {
				header : 'Code',
				dataIndex : 'ICDCCode',
				align : 'center',
				width : 70,
				sortable : true
			}, {
				header : '名称',
				dataIndex : 'ICDCDesc',
				align : 'center',
				width : 120,
				sortable : true
			}, {
				header : '分类',
				dataIndex : 'ICDCCate',
				align : 'center',
				width : 60,
				sortable : true
			}, {
				header : '备注',
				dataIndex : 'ICDCRemark',
				align : 'center',
				width : 80,
				sortable : true
			}]);
	var store = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : serviceUrl + '?action=getMRICDCate'
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'totalNums',
							root : 'root',
							fields : [{
										name : 'ICDCId'
									}, {
										name : 'ICDCCode'
									}, {
										name : 'ICDCDesc'
									}, {
										name : 'ICDCCate'
									}, {
										name : 'ICDCRemark'
									}]
						})
			});
	store.load();

	var IsActiveCombox = new Ext.form.ComboBox({
		anchor : '95%'	,
				//width : 130,
				editable : false,
				xtype : 'combo',
				mode : 'local',
				triggerAction : 'all',
				fieldLabel : '分类',
				value : '',
				name : 'IsActiveCombox',
				id : 'ICDCCate',
				displayField : 'isValid',
				valueField : 'isValidV',
				store : new Ext.data.JsonStore({
							fields : ['isValid', 'isValidV'],
							data : [{
										isValid : '诊断',
										isValidV : 'D'
									}, {
										isValid : '手术',
										isValidV : 'O'
									}]
						}),
				listeners : {
					'select' : function(combox) {
						IsActiveCombox.setValue(combox.getValue());
					}
				}
			});

	var ICDCateGridPanel = new Ext.grid.GridPanel({
				id : 'ICDCateGridPanel',
				loadMask : true,
				height : 500,
				store : store,
				enableColumnResize : true,
				cm : columnModel,
				sm : new Ext.grid.RowSelectionModel({
							singleSelect : true,
							listeners : {
								rowselect : function(sm, row, rec) {
									var id = rec.get("ICDCId");
									var form = ICDCateFormPanel.getForm();
									form.loadRecord(rec);
									form.setValues({
												ID : id
											});
								}
							}
						}),
				listeners : {
					'contextmenu' : function(event) {
						event.preventDefault();
					},
					'click' : function(ele, event) {
						var sm = ICDCateGridPanel.getSelectionModel();
						if (!sm)
							return;
						var record = sm.getSelected();
						if (!record)
							return;
						var ICDCId = record.get("ICDCId");
						if (!ICDCId) {
							return;
						}
						ICDCateDetailsDatastore.proxy
								.setUrl(encodeURI(serviceUrl
										+ '?action=GetICDCateDetails&ICDCId='
										+ ICDCId));
						ICDCateDetailsDatastore.load();
						ICDCateDetailsGridPanel.show();
					}
				}
			});

	var ICDCateFormPanel = new Ext.FormPanel({
				autoScroll : true,
				frame : true,
				//height : 110,
				labelAlign : 'right',
				labelWidth : 65,
				bodyStyle : 'padding:5px',
				style : {
					"margin-right" : Ext.isIE6 ? (Ext.isStrict
							? "-10px"
							: "-13px") : "0"
				},
				
				layout : 'column',
				items:[
				{
					columnWidth : .5,
					layout : 'form',
					defaultType : 'textfield',
					items : [{
						fieldLabel : '编码',
						xtype : 'textfield',
						name : 'ICDCCode',
						id : 'ICDCCode',
						anchor : '95%'					
					},IsActiveCombox]
				},{
					columnWidth : .5,
					layout : 'form',
					defaultType : 'textfield',
					items : [{
						fieldLabel : '名称',
						xtype : 'textfield',
						name : 'ICDCDesc',
						id : 'ICDCDesc',
						anchor : '95%'				
					},{
						fieldLabel : '备注',
						xtype : 'textfield',
						name : 'ICDCRemark',
						id : 'ICDCRemark',
						anchor : '95%'				
					}]
				}],				
				
						
						
				tbar : new Ext.Toolbar([{
text: '<span style="line-Height:1">保存</span>',
					icon   : '../images/uiimages/filesave.png',
					handler : function() {
						var sm = ICDCateGridPanel.getSelectionModel();
						var record = sm.getSelected();
						var ICDCCode = "";
						if (sm && record) {
							var ICDCCode = record.get("ICDCCode");
						}
						var Code = Ext.get('ICDCCode').getValue();
						var Desc = Ext.get('ICDCDesc').getValue();
						var Cate = Ext.get('ICDCCate').getValue();
						var Remark = Ext.get('ICDCRemark').getValue();
						if ((Code == "")||(Desc=="")||(Cate=="")) {
							Ext.Msg.alert("提示", "维护信息不全! ");
							return;
						}
						if (ICDCCode != "" && ICDCCode != Code) {
							Ext.Msg.alert("提示", "分类的编码不允许修改! ");
							return;
						}
						var ICDCInfo = Code + "^" + Desc + "^" + Cate + "^"
								+ Remark
						dhcwl.mkpi.Util.ajaxExc(serviceUrl
								+ '?action=addMRICDCate&ICDCInfo=' + ICDCInfo);
						store.proxy.setUrl(encodeURI(serviceUrl
								+ '?action=getMRICDCate'));
						store.reload();
						ICDCateFormPanel.show();
					}
				}, '-', {
text: '<span style="line-Height:1">删除</span>',
					icon   : '../images/uiimages/edit_remove.png',
					handler : function() {
						var sm = ICDCateGridPanel.getSelectionModel();
						var record = sm.getSelected();
						if (!sm || !record) {
							Ext.Msg.alert("提示", "请选择要删除的记录！");
							return;
						}
						Ext.Msg.confirm('信息', '确定要删除？', function(btn) {
									if (btn == 'yes') {
										var ICDCId = record.get("ICDCId");
										store.remove(ICDCId);
										dhcwl.mkpi.Util
												.ajaxExc(serviceUrl
														+ '?action=DelMRICDDate&ICDCId='
														+ ICDCId);
										var form = ICDCateFormPanel.getForm();
										form.setValues({
													ICDCId : '',
													ICDCCode : '',
													ICDCDesc : '',
													ICDCCate : '',
													ICDCRemark : ''
												});
										store.proxy.setUrl(encodeURI(serviceUrl
												+ '?action=getMRICDCate'));
										store.reload();
										ICDCateFormPanel.show();
										ICDCateDetailsDatastore.reload();
										ICDCateDetailsGridPanel.show();
									}
								});
					}
				}, '-', {
text: '<span style="line-Height:1">清空</span>',				
icon   : '../images/uiimages/clearscreen.png',
					handler : function() {
						var form = ICDCateFormPanel.getForm();
						form.setValues({
									ICDCId : '',
									ICDCCode : '',
									ICDCDesc : '',
									ICDCCate : '',
									ICDCRemark : ''
								});
					}
				}, '-', {
text: '<span style="line-Height:1">查询</span>',
					icon   : '../images/uiimages/search.png',	
					handler : function() {
						var ICDCCode = Ext.get('ICDCCode').getValue();
						var ICDCDesc = Ext.get('ICDCDesc').getValue();
						var ICDCCate = Ext.get('ICDCCate').getValue();
						var ICDCRemark = Ext.get('ICDCRemark').getValue();
						var filterCode = ICDCCode + "^" + ICDCDesc + "^"
								+ ICDCCate + "^" + ICDCRemark
						store.proxy.setUrl(encodeURI(serviceUrl
								+ '?action=getMRICDCate&filterRule='
								+ filterCode));
						store.load();
						ICDCateFormPanel.show();
					}
				}])

			});
	var EditTextField = new Ext.form.TextField({
				allowBlank : true
			});
	// / ICD明细数据维护
	var ICDCateDetailscolumnModel = new Ext.grid.ColumnModel([{
				header : 'Id',
				dataIndex : 'ICDCDId',
				width : 60,
				align : 'center',
				sortable : false
			}, {
				header : '描述',
				dataIndex : 'ICDCDDesc',
				width : 150,
				align : 'left',
				sortable : false,
				renderer:function(value)
				{
					return value.replace(/\ /g,'&nbsp;&nbsp;')
				},
				editor : EditTextField
			}, {
				header : 'ICD值',
				dataIndex : 'ICDCDICD',
				width : 300,
				align : 'left',
				sortable : false,
				editor : EditTextField
			}, {
				header : '顺序',
				dataIndex : 'ICDCDSort',
				width : 60,
				align : 'center',
				sortable : false
			}]);
	var ICDCateDetailsDatastore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : serviceUrl + '?action=GetICDCateDetails'
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'totalNums',
							root : 'root',
							fields : [{
										name : 'ICDCDId'
									}, {
										name : 'ICDCDDesc'
									}, {
										name : 'ICDCDICD'
									}, {
										name : 'ICDCDSort'
									}]
						})

			});
	ICDCateDetailsDatastore.load();

	var ICDCateDetailsGridPanel = new Ext.grid.EditorGridPanel({
		id : 'ICDCateDetailsGridPanel',
		stripeRows : true,
		loadMask : true,
		frame : true,
		renderTo : Ext.getBody(),
		store : ICDCateDetailsDatastore,
		cm : ICDCateDetailscolumnModel,
		enableColumnResize : true,
		draggable : false,     //Grid不让拖动
		enableDragDrop : true, // 拖动排序用的属性
		dropConfig : { // 拖动排序用的属性
			appendOnly : true
		},
		ddGroup : 'GridDD',
		sm : new Ext.grid.RowSelectionModel(),
		clicksToEdit : 1,
		columnLines : true,
		layout : 'table',
		listeners : {
			'contextmenu' : function(event) {
				event.preventDefault();
			},
			'click':function(ele, event){
				var ICDsm = ICDCateGridPanel.getSelectionModel();
				var ICDCaterecord = ICDsm.getSelected();
				if (!ICDCaterecord) return;
				choiceICDCateId = ICDCaterecord.get("ICDCId");
				var sm = ICDCateDetailsGridPanel.getSelectionModel();
				var record = sm.getSelected();
				choiceICDCateDetailsId = record.get("ICDCDId");
			},
			'afteredit' : function(event) {
				//var ICDsm = ICDCateGridPanel.getSelectionModel();
				//var ICDCaterecord = ICDsm.getSelected();
				/// 原来的写好存在问题，点击其他的行获取的不是原来的行数据而是新的行数据
				var ICDCId = choiceICDCateId;
				//var sm = ICDCateDetailsGridPanel.getSelectionModel();
				//var record = sm.getSelected();
				var ICDCDId = choiceICDCateDetailsId;
				if (ICDCId == "") {
					Ext.Msg.alert("提示", "请选择要编辑的ICD分类!")
					return;
				}
				originalValue = event.originalValue;
				value = event.value;
				field = event.field;
				if (originalValue == value) {
					return;
				}
				var editStr = ICDCId + "^" + ICDCDId + "^" + field + "^"
						+ value;
				dhcwl.mkpi.Util.ajaxExc(serviceUrl
						+ '?action=editICDCateDetails&editStr=' + editStr);
				ICDCateDetailsDatastore.proxy.setUrl(encodeURI(serviceUrl
						+ '?action=GetICDCateDetails&ICDCId=' + ICDCId));
				ICDCateDetailsDatastore.load();
				ICDCateDetailsGridPanel.show();

			}
		},
		tbar : new Ext.Toolbar([{
text: '<span style="line-Height:1">增加</span>',
icon   : '../images/uiimages/edit_add.png',
					handler : function() {
						var ICDsm = ICDCateGridPanel.getSelectionModel();
						var ICDCaterecord = ICDsm.getSelected();
						if (!ICDsm || !ICDCaterecord) {
							Ext.Msg.alert("提示", "请选择要添加的分类!")
							return;
						}
						var initValue = {
							ICDCDId : '',
							ICDCDDesc : '',
							ICDCDICD : '',
							ICDCDSort : ''

						};
						var p = new Ext.data.Record(initValue);
						ICDCateDetailsGridPanel.stopEditing();
						ICDCateDetailsDatastore.insert(0, p);
						var sm = ICDCateDetailsGridPanel.getSelectionModel();
						sm.selectFirstRow();
					}
				}, '-', {
text: '<span style="line-Height:1">删除</span>',
					icon   : '../images/uiimages/edit_remove.png',
					handler : function() {
						var ICDsm = ICDCateGridPanel.getSelectionModel();
						var ICDCaterecord = ICDsm.getSelected();
						if (!ICDsm || !ICDCaterecord) {
							Ext.Msg.alert("提示", "请选择要删除的分类!")
							return;
						}
						var ICDCId = ICDCaterecord.get("ICDCId");
						var sm = ICDCateDetailsGridPanel.getSelectionModel();
						var record = sm.getSelected();
						if (!sm || !record) {
							Ext.Msg.alert("提示", "请选择要删除的ICD明细！");
							return;
						}
						var ICDCDId = record.get("ICDCDId");
						if (!ICDCDId) {
							Ext.Msg.alert("提示", "请选择要删除的ICD明细！");
							return;
						}
						Ext.Msg.confirm('信息', '确定要删除？', function(btn) {
							if (btn == 'yes') {
								ICDCateDetailsDatastore.remove(record);
								dhcwl.mkpi.Util.ajaxExc(serviceUrl
										+ '?action=DelMRICDCDetails&ICDCId='
										+ ICDCId + '&ICDCDId=' + ICDCDId);
								ICDCateDetailsDatastore.proxy
										.setUrl(encodeURI(serviceUrl
												+ '?action=GetICDCateDetails&ICDCId='
												+ ICDCId));
								ICDCateDetailsDatastore.load();
								ICDCateDetailsGridPanel.show();
							}
						});
					}
				}, '-', {
					text: '<span style="line-Height:1">全部删除</span>',
					icon   : '../images/uiimages/edit_remove.png',
					handler : function() {
						var sm = ICDCateGridPanel.getSelectionModel();
						var record = sm.getSelected();
						if (!sm || !record) {
							Ext.Msg.alert("提示", "请选择要删除的分类!")
							return;
						}
						var ICDCId = record.get("ICDCId");

						Ext.Msg.confirm('信息', '确定要全部删除吗？', function(btn) {
							if (btn == 'yes') {
								dhcwl.mkpi.Util.ajaxExc(serviceUrl
										+ '?action=DelMRICDCDetails&ICDCId='
										+ ICDCId + '&ICDCDId=A');
								ICDCateDetailsDatastore.proxy
										.setUrl(encodeURI(serviceUrl
												+ '?action=GetICDCateDetails&ICDCId='
												+ ICDCId));
								ICDCateDetailsDatastore.load();
								ICDCateDetailsGridPanel.show();
							}
						});
					}
				}, '-', {
					text: '<span style="line-Height:1">保存顺序</span>',
					icon   : '../images/uiimages/filesave.png',
					handler : function() {
						var sm = ICDCateGridPanel.getSelectionModel();
						var record = sm.getSelected();
						if (!sm || !record) {
							Ext.Msg.alert("提示", "请先选择要排序的分类!")
							return;
						}
						var ICDCId = record.get("ICDCId")

						var len = ICDCateDetailsDatastore.getTotalCount();

						var idStr = "";
						for (var i = 0; i < len; i++) {
							MKCDId = ICDCateDetailsDatastore.getAt(i)
									.get('ICDCDId');
							if (idStr == "") {
								idStr = MKCDId
							} else {
								idStr = idStr + "-" + MKCDId
							}
						}
						if (idStr == "") {
							Ext.Msg.alert("提示", "没有可供保存的内容!")
							return;
						}
						dhcwl.mkpi.Util.ajaxExc(serviceUrl
								+ '?action=UpDateICDCateDetailsSort&ICDCId='
								+ ICDCId + '&idStr=' + idStr);
						ICDCateDetailsDatastore.proxy
								.setUrl(encodeURI(serviceUrl
										+ '?action=GetICDCateDetails&ICDCId='
										+ ICDCId));
						ICDCateDetailsDatastore.load();
						ICDCateDetailsGridPanel.show();
					}
				}])
	})

	var getpartone = new Ext.Panel({
				id : 'getpartone',
				frame : true,
				region : 'center',
				// autoHeight : true,
				items : [{
						height:140,
						layout:'fit',
						items:ICDCateFormPanel
					}, {
						layout:'fit',
						items:ICDCateGridPanel
						
					}]

			});
	var getparttwo = new Ext.Panel({
				id : 'getparttwo',
				frame : true,
				region : 'center',
				layout : 'fit',
				items : [ICDCateDetailsGridPanel]
			});

	var getMRICDPanel = new Ext.Panel({
				title : 'ICD配置',
				layout : 'column',
				layoutConfig : {
					columns : 2
				},
				items : [{
							items : getpartone,
							height : 700,
							columnWidth : .4
						}, {
							height : 700,
							layout : 'fit',
							items : getparttwo,
							columnWidth : .6
						}]
			});

	this.getMRICDPanel = function() {
		return getMRICDPanel;
	}

	// 拖动排序的代码
	var ddrow = new Ext.dd.DropTarget(
			ICDCateDetailsGridPanel.getView().scroller.dom, {
				ddGroup : 'GridDD',
				copy : false,// 拖动是否带复制属性
				notifyDrop : function(dd, e, data) { // 对应的函数处理拖放事件
					// 选中了多少行
					var rows = data.selections;
					// 拖动到第几行
					var index = dd.getDragData(e).rowIndex;
					if (typeof(index) == "undefined") {
						return;
					}
					// 修改store
					for (i = 0; i < rows.length; i++) {
						var rowData = rows[i];
						if (!this.copy)
							ICDCateDetailsDatastore.remove(rowData);
						ICDCateDetailsDatastore.insert(index, rowData);
					}
					ICDCateDetailsGridPanel.getView().refresh();
				}

			});

}
