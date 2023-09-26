// JS:DHCCRMLabResultSend.js
// 描述: 化验单结果传送
// Creater：zl
// 日期:2010-04-07
Ext.onReady(function() {
	Ext.QuickTips.init(); // 初始化所有Tips
	var PersonListStore = new Ext.data.Store({

				url : 'dhccrmlisresultsend1.csp?actiontype=FindList',

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows'

						}, [{
									name : 'PatRegNo'
								}, {
									name : 'PatName'
								}, {
									name : 'ARCItemDesc'
								}, {
									name : 'MobileSend'
								}, {
									name : 'EmailSend'
								}, {
									name : 'OEORItemID'
								}
								, {
									name : 'MobilePhone'
								}
								, {
									name : 'PAPMISex'
								}
								, {
									name : 'PAPMIAge'
								}])
			});
	var LabResultStore = new Ext.data.Store({

				url : 'dhccrmlisresultsend1.csp?actiontype=GetResultList',

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows'

						}, [{
									name : 'ResultStr'
								}])
			});
		
	var sm = new Ext.grid.CheckboxSelectionModel();
	var LabResultCm = new Ext.grid.ColumnModel([sm, {

				header : '选择',
				dataIndex : 'Select',
                width : 50
			}, {

				header : '登记号',
				dataIndex : 'PatRegNo'
                	
			}, {

				header : '姓名',
				dataIndex : 'PatName'

			},
			 {

				header : '性别',
				dataIndex : 'PAPMISex',
                 width : 50
			},
			 {

				header : '年龄',
				dataIndex : 'PAPMIAge',
				width : 50

			},
			{

				header : '手机',
				dataIndex : 'MobilePhone'

			},{

				header : '医嘱',
				dataIndex : 'ARCItemDesc'  , 
				width : 310


			}, {

				header : '短信发送',
				dataIndex : 'MobileSend',
             
				renderer : function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'
							+ (v == 'Y' ? '-on' : '') + ' x-grid3-cc-'
							+ this.id + '">&#160;</div>';
				}

			}, {

				header : '邮件发送',
				dataIndex : 'EmailSend',
				renderer : function(v, p, record) {
					p.css += ' x-grid3-check-col-td';
					return '<div class="x-grid3-check-col'
							+ (v == 'Y' ? '-on' : '') + ' x-grid3-cc-'
							+ this.id + '">&#160;</div>';
				}

			}]);
	var BottomBar = new Ext.PagingToolbar({

				pageSize : 20,
				displayInfo : true,
				store : PersonListStore,
				displayMsg : '当前显示{0} - {1},共计{2}',

				emptyMsg : "没有数据"

			})

	var LabResultMain = new Ext.grid.GridPanel({
				region : 'south',
				height : 500,
				//frame : true,
				store : PersonListStore,
				sm : sm,
				cm : LabResultCm,
				trackMouseOver : true,
				stripeRows : true,
				bbar : BottomBar,
				viewConfig : {
					forceFit : true
				}

			});

	var LocStore = new Ext.data.Store({

				url : 'dhccrmlisresultsend1.csp?actiontype=CTLocList',

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

		LocStore.proxy.conn.url = 'dhccrmlisresultsend1.csp?actiontype=CTLocList'
				+ '&CTLocDesc=' + Ext.getCmp('CTLoc').getRawValue();
	});
	var FindMain = new Ext.form.FormPanel({
		title : '化验结果单发送',
		frame : true,
		labelWidth : 80,
		region : 'center',
		items : [{
					layout : 'column',
					items : [{
								columnWidth : 0.3,
								layout : 'form',
								items : [{
											xtype : 'datefield',
											fieldLabel : '开始日期',
											id : 'DateFrom',
											name : 'DateFrom',
											allowBlank : true,
											width : 150
										}]
							}, {
								columnWidth : 0.7,
								layout : 'form',
								items : [{
											xtype : 'datefield',
											fieldLabel : '结束日期',
											id : 'DateTo',
											name : 'DateTo',
											auchor : '90%',
											allowBlank : true,
											width : 150
										}]
							}]

				}, {
					layout : 'column',
					items : [{
								columnWidth : 0.3,
								layout : 'form',
								items : [{
											xtype : 'numberfield',
											fieldLabel : '登记号',
											id : 'PatRegNo',
											name : 'PatRegNo',
											width : 150

										}]
							},
								{
								columnWidth : 0.7,
								layout : 'form',
							     items : [{
										xtype : 'textfield',
										fieldLabel : '姓名',
										id : 'PatName',
										name : 'PatName',
										width : 150
									}]
							}]
				}, {
					layout : 'column',
					items : [{
								columnWidth : 0.3,
								layout : 'form',
								items : [{
											xtype : 'combo',
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

										}]
							}, {

								columnWidth : 0.2,
								labelWidth : 50,
								layout : 'form',
								items : [{
											xtype : 'checkbox',
											fieldLabel : '已发送',
											id : 'SendFlag',
											name : 'SendFlag'

										}]
							}
				, {

								columnWidth : 0.1,
								layout : 'form',
								items : [{
									xtype : 'tbbutton',
									text : '查找',
									pressed : true,

									handler : function() {
										/*
										if (Ext.getCmp('DateFrom').getValue() == '') {
											Ext.Msg.show({
														title : '提示',
														msg : '开始日期不能为空!',
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.INFO
													});
										}
			                                */
										var startdate=''
										if (Ext.getCmp('DateFrom').getValue() != '') {
											startdate = Ext.getCmp('DateFrom')
													.getValue().format('Y-m-d')
													.toString();
										}

										var enddate = '';
										if (Ext.getCmp('DateTo').getValue() != '') {
											enddate = Ext.getCmp('DateTo')
													.getValue().format('Y-m-d')
													.toString();
										}

										PersonListStore.proxy.conn.url = 'dhccrmlisresultsend1.csp?actiontype=FindList'
												+ '&CTLocRowID='
												+ Ext.getCmp('CTLoc')
														.getValue()
												+ '&DateFrom='
												+ startdate
												+ '&DateTo='
												+ enddate
												+ '&SendFlag='
												+ Ext.getCmp('SendFlag')
														.getValue()
												+ '&PatRegNo='
												+ Ext.getCmp('PatRegNo')
														.getValue()
												+ '&PatName='
												+ Ext.getCmp('PatName')
														.getValue();
										alert(PersonListStore.proxy.conn.url)
										PersonListStore.load({

													params : {
														start : 0,
														limit : 20
													}
												});

									}

								}]
							},

							{
								columnWidth : 0.1,
								layout : 'form',
								items : [{
									xtype : 'tbbutton',
									text : '短信发送',
									id : 'SMSSend',
									name : 'SMSSend',
									pressed : true,

									handler : function() {

										var selectedRows = LabResultMain
												.getSelectionModel()
												.getSelections();
										if (selectedRows.length == 0) {
											Ext.Msg.alert("提示", "请选择要发送的行记录!");
											return;
										}
										var str = "";
										for (i = 0; i < selectedRows.length; i++) {
											var OEORDItem = selectedRows[i].data.OEORItemID
											var PatName = selectedRows[i].data.PatName
		                                    var ARCItemDesc = selectedRows[i].data.ARCItemDesc
									        var PAPMISex = selectedRows[i].data.PAPMISex
											LabResultStore.proxy.conn.url = 'dhccrmlisresultsend1.csp?actiontype=GetResultList'
													+ '&OEORDItem=' + OEORDItem;

											LabResultStore.load({

														params : {
															start : 0,
															limit : 20
														}
													})
	                                LabResultStore.on('load',function() 
				                {       
				                     var SendResultInfo = LabResultStore.getAt(0).get('ResultStr')
				                     if (PAPMISex=='女'){PatName=PatName+"女士"}
									 else {PatName=PatName+"先生"}
									 str="尊敬的"+PatName+":您好,您上次"+ARCItemDesc+"检查结果:"+SendResultInfo
									 alert(str)
									 Returnflag = "Success" // Fail

											SendURL = 'dhccrmlisresultsend1.csp?actiontype=SMSSend'
													+ '&OEORDItem='
													+ OEORDItem
													+ '&Returnflag='
													+ Returnflag;
													
													if (FindMain.getForm().isValid()) {
												Ext.Ajax.request({
													url : SendURL,
													waitMsg : '发送中...',
													failure : function(result,
															request) {
														Ext.Msg.show({
															title : '错误',
															msg : '请检查网络连接!',
															buttons : Ext.Msg.OK,
															icon : Ext.MessageBox.ERROR
														});
													},
													success : function(result,
															request) {
														var jsonData = Ext.util.JSON
																.decode(result.responseText);
														if (jsonData.success == 'true') { // success、true在类里定义的
															PersonListStore
																	.load({
																		params : {
																			start : 0,
																			limit : 20
																		}
																	});

														} else {
															Ext.MessageBox
																	.show({
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
		                                   });
		                          
											

									

										}

									}

								}]
							}, {
								columnWidth : 0.3,
								layout : 'form',
								items : [{
											xtype : 'tbbutton',
											text : '邮件发送 ',
											id : 'EmailSend',
											name : 'EmailSend',
											pressed : true

										}]
							}

					]
				}]

	});

	var mainPanel = new Ext.Viewport({
		layout : 'border',
		items : [LabResultMain, FindMain]
			// items: FindMain
		});
});
