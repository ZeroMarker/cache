
// 描述: 重大疾病设置
// Creater：zl
// 日期:2010-04-07
Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL='../scripts/DHCCRM/Ext2/resources/images/default/s.gif';
	Ext.QuickTips.init(); // 初始化所有Tips

	
	var mainPanel = new Ext.Viewport({
		layout : 'border',
		items : [TopPanel, IllGrid]
			// items: FindMain
		});
});
var IllListStore = new Ext.data.Store({

				url : 'dhccrmimportantillset1.csp?actiontype=Load',

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows'

						}, [{
									name : 'ARCIMCode'
								}, {
									name : 'ARCIMDesc'
								}, {
									name : 'ARCIMDR'
								}, {
									name : 'IllFlag'
								}, {
									name : 'AERowId'
								},
									{name: 'AllFlag'
									}])
			});
	IllListStore.load({

				params : {
					start : 0,
					limit : 20
				}
			});
	// var sm = new Ext.grid.CheckboxSelectionModel();
	var cm = new Ext.grid.ColumnModel([
	         new Ext.grid.RowNumberer(),{

				header : '医嘱名称',
				dataIndex : 'ARCIMDesc'
				//editor:new Ext.grid.GridEditor(new Ext.form.TextField({allowBlank:false}))
				
			}, {

				header : '医嘱编码',
				dataIndex : 'ARCIMCode'

			}, {

				header : '重要疾病',
				dataIndex : 'IllFlag',
				renderer : function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'
							+ (v == 'true' ? '-on' : '') + ' x-grid3-cc-'
							+ this.id + '">&#160;</div>';
				},
				width : 50

			},
			{

				header : '全部发送',
				dataIndex : 'AllFlag',
				renderer : function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'
							+ (v == 'true' ? '-on' : '') + ' x-grid3-cc-'
							+ this.id + '">&#160;</div>';
				},
				width : 50

			}]);
	var BottomBar = new Ext.PagingToolbar({

				pageSize : 20,
				displayInfo : true,
				store : IllListStore,
				displayMsg : '当前显示{0} - {1},共计{2}',

				emptyMsg : "没有数据"

			})

	var IllGrid = new Ext.grid.GridPanel({
				region : 'south',
				height : 450,
				frame : true,
				store : IllListStore,
				// sm : sm,
				cm : cm,
				enableDragDrop:true,
				trackMouseOver : true,
				stripeRows : true,
				loadMask:true,
				bbar : BottomBar,
				viewConfig : {
					forceFit : true
				}

			});
	IllGrid.on('rowclick', function(g, row, e) {
				var record = IllListStore.getAt(row);
				TopPanel.getForm().loadRecord(record)
			})
	// if (IllFlag=='Y'){Ext.getCmp('IllFlag').setValue(true)}
	// else {Ext.getCmp('IllFlag').setValue(false)}})
	// })

	var topbar = new Ext.Toolbar({
		items : [{
			xtype : 'tbbutton',
			text : '查找 ',
			// id : 'Find',
			// name : 'Find',
			pressed : true,
			handler : function() {
				//alert(Ext.getCmp('ARCItmMast').getValue())
				IllListStore.proxy.conn.url = 'dhccrmimportantillset1.csp?actiontype=Find'

						+ '&ARCIMDR='
						+ Ext.getCmp('ARCItmMast').getValue()
						+ '&IllFlag=' + Ext.getCmp('IllFlag').getValue()
				IllListStore.load({

							params : {
								start : 0,
								limit : 20
							}
						});

			}

		}, {
			xtype : 'tbbutton',
			text : '添加 ',
			// id : 'Add',
			// name : 'Add',
			pressed : true,
			handler : function() {

				Addurl = 'dhccrmimportantillset1.csp?actiontype=Add'
						+ '&ARCIMDR=' + Ext.getCmp('ARCItmMast').getValue()
						+ '&IllFlag=' + Ext.getCmp('IllFlag').getValue()
						+ '&AllFlag=' + Ext.getCmp('AllFlag').getValue()
  
				if (TopPanel.getForm().isValid()) {
					Ext.Ajax.request({
						url : Addurl,
						waitMsg : '添加中...',
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
						 
							if (jsonData.success == 'true') { // success、true在类里定义的
								Ext.Msg.show({
											title : '提示',
											msg : '添加成功!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								IllListStore.proxy.conn.url = 'dhccrmimportantillset1.csp?actiontype=Load'
								// alert(IllListStore.proxy.conn.url)
								IllListStore.load({

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
				} else {
					Ext.Msg.show({
								title : '错误',
								msg : '请修正页面提示的错误后提交',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}

			}

		}, {

			xtype : 'tbbutton',
			text : '删除 ',
			// id : 'Delete',
			// name : 'Delete',
			pressed : true,
			handler : function() {
				var rows = IllGrid.getSelectionModel().getSelections();
				var selectedrow = IllGrid.getSelectionModel().getSelected();
				if (rows.length == 0) {
					Ext.Msg.alert("提示", "请选择要删除的行记录!");
					return;
				}
				var AERowId = selectedrow.data.AERowId

				Delurl = 'dhccrmimportantillset1.csp?actiontype=Del'
						+ '&AERowId=' + AERowId

				if (TopPanel.getForm().isValid()) {
					Ext.Ajax.request({
						url : Delurl,
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
							if (jsonData.success == 'true') { // success、true在类里定义的
								Ext.Msg.show({
											title : '提示',
											msg : '删除成功!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
								// TopPanel.getForm().loadRecord(null)
								Ext.getCmp('ARCItmMast').setValue('')
								IllListStore.proxy.conn.url = 'dhccrmimportantillset1.csp?actiontype=Load'

								IllListStore.load({

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
				} else {
					Ext.Msg.show({
								title : '错误',
								msg : '请修正页面提示的错误后提交',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}

			}

		}, {
			xtype : 'tbbutton',
			text : '修改',
			// id : 'Modify',
			// name : 'Modify',
			pressed : true,
			handler : function() {

				var rows = IllGrid.getSelectionModel().getSelections();
				var selectedrow = IllGrid.getSelectionModel().getSelected();
				if (rows.length == 0) {
					Ext.Msg.alert("提示", "请选择要修改的行记录!");
					return;
				}
				var AERowId = selectedrow.data.AERowId
				var IllFlag = Ext.getCmp('IllFlag').getValue()
				var AllFlag=Ext.getCmp('AllFlag').getValue()
		  
				Modifyurl = 'dhccrmimportantillset1.csp?actiontype=Modify'
						+ '&AERowId=' + AERowId + '&IllFlag=' + IllFlag+ '&AllFlag=' + AllFlag

				if (TopPanel.getForm().isValid()) {
					Ext.Ajax.request({
						url : Modifyurl,
						waitMsg : '修改中...',
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
							if (jsonData.success == 'true') { // success、true在类里定义的
								Ext.Msg.show({
											title : '提示',
											msg : '修改成功!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.INFO
										});
                                 Ext.getCmp('ARCItmMast').setValue('')
								IllListStore.proxy.conn.url = 'dhccrmimportantillset1.csp?actiontype=Load'
								IllListStore.load({

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
				} else {
					Ext.Msg.show({
								title : '错误',
								msg : '请修正页面提示的错误后提交',
								buttons : Ext.Msg.OK,
								icon : Ext.MessageBox.ERROR
							});
				}

			}

		}]
	})
	var ARCItmMastStore = new Ext.data.Store({

				url : 'dhccrmimportantillset1.csp?actiontype=GetItemMast',

				reader : new Ext.data.JsonReader({
							totalProperty : "results",
							root : "rows",
							id : 'ARCIMDR'
						}, [{
									name : 'ARCIMDesc'
								}, {
									name : 'ARCIMDR'
								}])

			});
	ARCItmMastStore.on('beforeload', function() {

		ARCItmMastStore.proxy.conn.url = 'dhccrmimportantillset1.csp?actiontype=GetItemMast'
				+ '&ItemDesc=' + Ext.getCmp('ARCItmMast').getRawValue();
	});

	var TopPanel = new Ext.form.FormPanel({
				title : '重大疾病医嘱设置',
				frame : true,
				labelWidth : 80,
				region : 'center',
				tbar : topbar,
			  height : 450,
				//layout : 'column',
                items : [{
					     
			
							columnWidth : 0.4,
							layout : 'form',
							xtype : 'combo',
							fieldLabel : '医嘱',
							id : 'ARCItmMast',
							name : 'ARCIMDesc',
							// width : 300,
							store : ARCItmMastStore,
							triggerAction : 'all',
							minChars : 1,
							selectOnFocus : true,
							forceSelection : true,
							valueField : 'ARCIMDR',
							displayField : 'ARCIMDesc',
							pageSize : 20,
							minListWidth:220
							

						},{
						  columnWidth : 0.2,
						  layout : 'form',
							xtype : 'checkbox',
							boxLabel : '重要疾病',
							labelSeparator : '',
							id : 'IllFlag',
							name : 'IllFlag'},
							 {
						
							columnWidth : 0.4,
							layout : 'form',
							xtype : 'checkbox',
							boxLabel : '发送全部',
							labelSeparator : '',
							id : 'AllFlag',
							name : 'AllFlag'
						}
							]
				
			

			});
	Ext.getCmp('IllFlag').setValue(true)
	/*
	if (Ext.getCmp('ARCItmMast').getRawValue()==""){
		alert("11")
	Ext.getCmp('ARCItmMast').setValue('')}
	*/