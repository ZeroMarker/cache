(function() {
	Ext.ns("dhcwl.docappcfg.DocKpiDef");
})();

Ext.onReady(function() {
	var serviceUrl = "dhcwl/docappcfg/getdockpidef.csp";
	var serviceUrls = "dhcwl/docappcfg/savedockpidef.csp";
	var kpiObj = null;
	// 复选框
	var selectedKpiIds = [];
	var csm = new Ext.grid.CheckboxSelectionModel({
				listeners : {
					rowselect : function(sm, row, rec) {
						var rd = rec; // sm.getSelected();
						var ID = rec.get("ID");
						consForm.getForm().loadRecord(rec);
					},
					'rowdeselect' : function(sm, row, rec) {
						var consId = rec.get("consId"), len = selectedKpiIds.length;
						for (var i = 0; i < len; i++) {
							if (selectedKpiIds[i] == consId) {
								for (var j = i; j < len; j++) {
									selectedKpiIds[j] = selectedKpiIds[j + 1]
								}
								selectedKpiIds.length = len - 1;
								break;
							}
						}
					}
				}
			});
	// 定义列
	var columnModel = new Ext.grid.ColumnModel([
			// new Ext.grid.RowNumberer(),csm,
			{
		header : 'ID',
		dataIndex : 'ID',
		sortable : true,
		width : 50,
		sortable : true
	}, {
		header : '医生指标代码',
		dataIndex : 'MDocKPIDefCode',
		width : 100,
		sortable : true
	}, {
		header : '医生指标描述',
		dataIndex : 'MDocKPIDefDesc',
		width : 100,
		sortable : true
	}, {
		header : '创建日期',
		dataIndex : 'MDocKPIUpdateDate',
		width : 130,
		sortable : true
	}, {
		header : '医生指标分类',
		dataIndex : 'MDocKPIDefClass',
		width : 130,
		sortable : true
	}, {
		header : '医生指标类别',
		dataIndex : 'MDocKPIDefCategory',
		width : 130,
		sortable : true
	}, {
		header : '医生指标归类',
		dataIndex : 'MDocKPIDefType',
		width : 130,
		sortable : true
	}]);
	// 定义指标的存储模型
	var store = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : serviceUrl + '?action=mulSearch&onePage=1'
						}),
				reader : new Ext.data.JsonReader({
							totalProperty : 'totalNum',
							root : 'root',
							fields : [{
										name : 'ID'
									}, {
										name : 'MDocKPIDefCode'
									}, {
										name : 'MDocKPIDefDesc'
									}, {
										name : 'MDocKPIUpdateDate'
									}, {
										name : 'MDocKPIDefClass'
									}, {
										name : 'MDocKPIDefCategory'
									}, {
										name : 'MDocKPIDefType'
									}]
						})
			});
	// start
	var record = Ext.data.Record.create([{
				name : 'ID',
				type : 'int'
			}, {
				name : 'MDocKPIDefCode',
				type : 'string'
			}, {
				name : 'MDocKPIDefDesc',
				type : 'string'
			}, {
				name : 'MDocKPIUpdateDate',
				type : 'string'
			}, {
				name : 'MDocKPIDefClass',
				type : 'string'
			}, {
				name : 'MDocKPIDefCategory',
				type : 'string'
			}, {
				name : 'MDocKPIDefType',
				type : 'string'
			}]);

	// end
	// 分页控件
	var pageTool = new Ext.PagingToolbar({
		pageSize : 22,
		store : store,
		displayInfo : true,
		displayMsg : '显示第 {0} 条到 {1} 条记录，一共 {2} 条',
		emptyMsg : "没有记录",
		listeners : {
			'change' : function(pt, page) {
				var id = "", j = 0, found = false, storeLen = selectedKpiIds.length;
				for (var i = store.getCount() - 1; i > -1; i--) {
					id = store.getAt(i).get("ID");
					found = false;
					for (j = storeLen - 1; j > -1; j--) {
						if (selectedKpiIds[j] == id)
							found = true;
					}
					if (found) {
						// csm.selectRow(i,true,false);
					}
				}
			}
		}
	});

	// 列表
	var grid = new Ext.grid.GridPanel({
				stripeRows : true,
				loadMask : true,
				height : 470,
				store : store,
				id : "consTables",
				sm : csm,
				resizeAble : true,
				enableColumnResize : true,
				// title: '列表标题',
				// tbar: [tbtn], //顶部工具栏
				bbar : pageTool, // 底部工具栏
				// colModel: columnModel
				cm : columnModel,
				listeners : {
					'contextmenu' : function(event) {
						event.preventDefault();
						var sm = this.getSelectionModel();
						var record = sm.getSelected();
						if (record) {
							var record = sm.getSelected();
						}
					}
				}
			});

	var typeFlagCombo = new Ext.form.ComboBox({
				width : 130,
				editable : false,
				xtype : 'combo',
				mode : 'local',
				triggerAction : 'all',
				fieldLabel : '医生指标类型',
				value : '',
				name : 'typeFlagCombo',
				id : 'MDocKPIDefClass',
				displayField : 'isValid',
				valueField : 'isValidV',
				tpl : '<tpl for=".">'
						+ '<div class="x-combo-list-item" style="height:16px;">'
						+ '{isValid}' + '</div>' + '</tpl>',
				store : new Ext.data.JsonStore({
							fields : ['isValid', 'isValidV'],
							data : [{
										isValid : '',
										isValidV : ''
									}, {
										isValid : '医生',
										isValidV : 'DOC'
									}, {
										isValid : '科主任',
										isValidV : 'HEAD'
									}]
						}),
				listeners : {
					'select' : function(combox) {
						typeFlagCombo.setValue(combox.getValue());
					}
				}
			});
	var categorybox = new Ext.form.ComboBox({
				width : 130,
				editable : false,
				xtype : 'combo',
				mode : 'local',
				triggerAction : 'all',
				fieldLabel : '医生指标类别',
				value : '',
				name : 'categorybox',
				id : 'MDocKPIDefCategory',
				displayField : 'isValid',
				valueField : 'isValidV',
				tpl : '<tpl for=".">'
						+ '<div class="x-combo-list-item" style="height:16px;">'
						+ '{isValid}' + '</div>' + '</tpl>',
				store : new Ext.data.JsonStore({
							fields : ['isValid', 'isValidV'],
							data : [{
										isValid : '',
										isValidV : ''
									}, {
										isValid : '普通指标',
										isValidV : 'ordinary'
									}, {
										isValid : '计算类指标',
										isValidV : 'calculate'
									}]
						}),
				listeners : {
					'select' : function(combox) {
						categorybox.setValue(combox.getValue());
					}
				}
			});

	// 医生指标归类combox
	var docFieldStore = new Ext.data.Store({
				proxy : new Ext.data.HttpProxy({
							url : 'dhcwl/docappcfg/getdefservice.csp?action=classfield'
						}),
				reader : new Ext.data.ArrayReader({}, [{
									name : 'value'
								}, {
									name : 'text'
								}])
			});
	docFieldStore.load();
	var docField = new Ext.form.ComboBox({
				width : 130,
				fieldLabel : '医生指标归类',
				store : docFieldStore,
				emptyText : '请选择',
				id : 'MDocKPIDefType',
				mode : 'remote',
				triggerAction : 'all',
				valueField : 'value',
				displayField : 'text',
				listeners : {
					'select' : function(combox) {
						docField.setValue(combox.getValue());
					}
				}
			});
	// 表单
	var consForm = new Ext.FormPanel({
		
		bodyStyle: 'padding:5px;',
		frame : true,
		height : 110,
		labelAlign : 'right',
		labelWidth : 100,
		/*
		style : {
			// "margin-left": "10px", // when you add custom margin in IE 6...
			"margin-right" : Ext.isIE6
					? (Ext.isStrict ? "-10px" : "-13px")
					: "0"
		},
		*/
		items : [{
					layout : 'column',
					items : [{ // row1 col1
						columnWidth : .25,
						layout : 'form',
						defaultType : 'textfield',
						defaults : {
							width : 100
						},
						items : [{
									fieldLabel : 'ID',
									id : 'ID',
									disabled : true
								}, typeFlagCombo]
					}, {
						columnWidth : .25,
						layout : 'form',
						// defaultType : 'textfield',
						defaults : {
							width : 100
						},
						items : [{
									fieldLabel : '医生指标代码',
									xtype : 'textfield',
									id : 'MDocKPIDefCode'
								}, {
									id : 'MDocKPIUpdateDate',
									xtype : 'datefield',
									fieldLabel : '创建/更新日期'//,
									//format : 'Y-m-d'

								}]
					}, {
						columnWidth : .25,
						layout : 'form',
						defaults : {
							width : 100
						},
						items : [{
									xtype : 'textfield',
									fieldLabel : '医生指标描述',
									id : 'MDocKPIDefDesc'
								}, docField]
					}, {
						columnWidth : .25,
						layout : 'form',
						defaults : {
							width : 100
						},
						items : [categorybox]
					}]

				}],
		tbar : new Ext.Toolbar([{
					text : '<span style="line-Height:1">新增</span>',
					icon   : '../images/uiimages/edit_add.png',
					
					handler : function() {
						var date = dhcwl.mkpi.Util.nowDate();
						var initValue = {
							ID : '',
							MDocKPIDefCode : '',
							MDocKPIDefDesc : '',
							MDocKPIDefType : '',
							MDocKPIUpdateDate : date,
							MDocKPIDefClass : '',
							MDocKPIDefCategory : '',
							MDocKPIDefType : ''
						};
						var p = new record(initValue);
						store.insert(0, p);
						var sm = grid.getSelectionModel();
						sm.selectFirstRow();
					}
				}, '-', {
					text : '<span style="line-Height:1">删除</span>',
					icon   : '../images/uiimages/edit_remove.png',
					
					handler : function() {
						var sm = grid.getSelectionModel();
						var record = sm.getSelected();
						if (!sm || !record) {
							alert("请选择要删除的医生指标");
							return;
						}
						Ext.Msg.confirm('信息', '确定要删除?', function(btn) {
									if (btn == 'yes') {
										var ID = record.get("ID");

										dhcwl.mkpi.Util.ajaxExc(serviceUrls
												+ '?action=delete&ID=' + ID);
										store.remove(record);
										store.reset();

									}
								});
						var form = consForm.getForm();
						form.reset();
					}

				}, '-', {
					cls : 'align:right',
					icon   : '../images/uiimages/filesave.png',
					text : '<span style="line-Height:1">保存</span>',
					handler : function() {
						var cursor = Math
								.ceil((pageTool.cursor + pageTool.pageSize)
										/ pageTool.pageSize);
						var paraValues; // =form.getValues(true);此方法会出现乱码
						var sm = grid.getSelectionModel();
						var record = sm.getSelected();
						if (!sm || !record) {
							alert("请选择要保存的医生指标");
							return;
						}
						var ID = record.get("ID");
						var MDocKPIDefCode = Ext.get('MDocKPIDefCode')
								.getValue();
						var MDocKPIDefDesc = Ext.get('MDocKPIDefDesc')
								.getValue();
						var MDocKPIDefType = docField.getValue();
						var MDocKPIDefCategory = Ext.get('MDocKPIDefCategory')
								.getValue();
						var MDocKPIDefClass = Ext.get('MDocKPIDefClass')
								.getValue();
						// var number = 0
						// var consValue = ""

						// for(var i = 0; i < xqCheck.length; i++){
						// if(xqCheck.get(i).checked){
						// consValue = consValue+xqCheck.get(i).inputValue+",";
						// number = number +1
						// }
						// }
						/*
						 * if(number == xqCheck.length){ consValue = "ALL" }else {
						 */
						// consValue =
						// consValue.substring(0,consValue.length-1);
						// }
						// alert(consValue);
						// alert(MDocKPIDefClass);
						/*
						 * if(!MDocKPIDefType) MDocKPIDefType='';
						 * if(MDocKPIDefType=""){ alert("请选择要保存的指标类型"); return; }
						 */
						// if(!MDocKPIDefType) MDocKPIDefType='';
						// else if(MDocKPIDefType=='门诊'||MDocKPIDefType=='O')
						// MDocKPIDefType='O';
						// else if(MDocKPIDefType=='住院'||MDocKPIDefType=='I')
						// MDocKPIDefType='I';
						// else MDocKPIDefType='';
						var MDocKPIUpdateDate = Ext.get('MDocKPIUpdateDate')
								.getValue();
						// var consReMark=Ext.get('consReMark').getValue();
						var reg = /[\$\#\@\&\%\!\*\^\~||]/;
						var reg2 = /^\d/;
						if (reg.test(MDocKPIDefCode)
								|| (reg2.test(MDocKPIDefCode))) {
							alert("医生指标代码不能包括$,#,@,&,%,*,^,!,~,||等特殊字符?并且不能以数字开头");
							Ext.get("MDocKPIDefCode").focus(); // 控制光标的焦点
							return;
						}
						if (MDocKPIDefCode)
							MDocKPIDefCode = MDocKPIDefCode.trim(); // 截掉医生指标代码左右空格
						if (!MDocKPIDefCode || !MDocKPIDefDesc) {
							alert("医生指标代码或描述不能为空!");
							return;
						}
						if (!MDocKPIDefType || !MDocKPIDefCategory
								|| !MDocKPIDefClass) {
							alert("医生类别,类型或归类不能为空!");
							return;
						}

						paraValues = 'ID=' + ID + '&MDocKPIDefCode='
								+ MDocKPIDefCode + '&MDocKPIDefDesc='
								+ MDocKPIDefDesc + '&MDocKPIDefType='
								+ MDocKPIDefType; //
						paraValues += '&MDocKPIUpdateDate=' + MDocKPIUpdateDate
								+ '&MDocKPIDefClass=' + MDocKPIDefClass
								+ '&MDocKPIDefCategory=' + MDocKPIDefCategory; // +'&consReMark='+consReMark
						record.set("MDocKPIDefCode", MDocKPIDefCode), record
								.set("MDocKPIDefDesc", MDocKPIDefDesc), record
								.set("MDocKPIDefType", MDocKPIDefType); //
						record.set("MDocKPIUpdateDate", MDocKPIUpdateDate), record
								.set("MDocKPIDefClass", MDocKPIDefClass), record
								.set("MDocKPIDefCategory", MDocKPIDefCategory); // ,record.set("consReMark",consReMark)
						dhcwl.mkpi.Util.ajaxExc(serviceUrls + '?action=add&'
								+ paraValues);
						store.proxy.setUrl(encodeURI(serviceUrl
								+ '?action=mulSearch')); // &start="+cursor+"&limit="+20));
						store.load();
						// kpiGrid.show();
						// alert(cursor);
						pageTool.cursor = 0;
						pageTool.doLoad(pageTool.pageSize * (cursor - 1));
						grid.getStore().reload();
					}
				}, '-', {
					text : '<span style="line-Height:1">清空</span>',
					icon   : '../images/uiimages/clearscreen.png',
					cls : 'align:right',
					handler : function() {
						var form = consForm.getForm();
						form.setValues({
									ID : '',
									MDocKPIDefCode : '',
									MDocKPIDefDesc : '',
									MDocKPIDefType : '',
									MDocKPIUpdateDate : '',
									MDocKPIDefClass : '',
									MDocKPIDefCategory : ''
								});
					}
				}, '-', {
					text : '<span style="line-Height:1">查询</span>',
					icon   : '../images/uiimages/search.png',
					
					cls : 'align:right',
					handler : function() {
						var ID = Ext.get('ID').getValue();
						var MDocKPIDefCode = Ext.get('MDocKPIDefCode')
								.getValue();
						var MDocKPIDefDesc = Ext.get('MDocKPIDefDesc')
								.getValue();
						var MDocKPIDefClass = Ext.get('MDocKPIDefClass')
								.getValue();
						var MDocKPIDefType = docField.getValue();
						/*
						 * var xqCheck = Ext.getCmp('MDocKPIDefClass').items;
						 * var consValue = "" for(var i = 0; i < xqCheck.length;
						 * i++){ if(xqCheck.get(i).checked){ consValue =
						 * consValue+xqCheck.get(i).inputValue+","; } }
						 * consValue =
						 * consValue.substring(0,consValue.length-1);
						 * if(!MDocKPIDefType) MDocKPIDefType=''; else
						 * if(MDocKPIDefType=='门诊'||MDocKPIDefType=='O')
						 * MDocKPIDefType='O'; else
						 * if(MDocKPIDefType=='住院'||MDocKPIDefType=='I')
						 * MDocKPIDefType='I'; else MDocKPIDefType='';
						 */
						var MDocKPIUpdateDate = Ext.get('MDocKPIUpdateDate')
								.getValue();
						var MDocKPIDefCategory = Ext.get('MDocKPIDefCategory')
								.getValue();
						// var consReMark=Ext.get('consReMark').getValue();
						paraValues = 'ID=' + ID + '&MDocKPIDefCode='
								+ MDocKPIDefCode + '&MDocKPIDefDesc='
								+ MDocKPIDefDesc + '&MDocKPIDefType='
								+ MDocKPIDefType + '&MDocKPIDefCategory='
								+ MDocKPIDefCategory; //
						paraValues += '&MDocKPIUpdateDate=' + MDocKPIUpdateDate
								+ '&MDocKPIDefClass=' + MDocKPIDefClass; // +'&consReMark='+consReMark
						store.proxy.setUrl(encodeURI(serviceUrl
								+ '?action=mulSearch&' + paraValues
								+ '&onePage=1'));
						// alert(paraValues);
						store.on("beforeload",function(){
						    store.baseParams = {MDocKPIDefCode:MDocKPIDefCode,MDocKPIDefDesc:MDocKPIDefDesc,MDocKPIDefType:MDocKPIDefType,MDocKPIDefCategory:MDocKPIDefCategory,MDocKPIDefClass:MDocKPIDefClass};
						    });
						store.load();
						grid.show();

					}
				}])
	});

	var mcShowWin = new Ext.Panel({
				title : '医生应用指标定义',
				// layout:'auto',
				layout : 'border',
				items : [{
							region : 'north',
							height : 120,
							layout:'fit',
							//autoScroll : true,
							items : consForm
						}, {
							region : 'center',
							//autoScroll : true,
							layout:'fit',
							items : grid
						}]
						/*,
						listeners : {
							"resize" : function(win, width, height) {
								grid.setHeight(height - 150);
								grid.setWidth(width - 15);
							}
						}
						*/
			});

	store.load({
				params : {
					start : 0,
					limit : 22,
					onePage : 1
				}
			});

	this.getStore = function() {
		return store;
	}
	this.getColumnModel = function() {
		return columnModel;
	}
	this.getMcShowWin = function() {
		// kpiGrid.setHeight(kpiShowWin.getHeight()-158);
		return mcShowWin;
	}
	this.getConsForm = function() {
		return consForm;
	}
	this.getMcGrid = function() {
		return grid;
	}
	this.getRecord = function() {
		return record;
	}

	this.mainWin = new Ext.Viewport({
				id : 'maintainMsgsMain',
				// renderTo:Ext.getBody(),
				autoShow : true,
				expandOnShow : true,
				resizable : true,
				layout : 'fit',
				// width:1000,
				// heitht:800,
				items : [mcShowWin]
			});

	this.getDocKpiDefPanel = function() {
		return mcShowWin;
	}
}

)

/*
 * dhcwl.leadermsg.ShowMcWin.prototype.refresh=function(){
 * this.getStore().proxy.setUrl(encodeURI("dhcwlMsg/msg/getDocKpiDef.csp?action=mulSearch&onePage=1"));
 * this.getStore().load(); this.getMcGrid().show(); }
 */
