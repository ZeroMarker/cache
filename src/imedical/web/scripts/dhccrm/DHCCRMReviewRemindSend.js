// JS:DHCCRMReviewRemindSend.js
// 描述:复查提醒发送
// Creater：zl
// 日期:2010-04-015
Ext.onReady(function() {
	Ext.QuickTips.init(); // 初始化所有Tips
	var PersonListStore = new Ext.data.Store({

				url : 'dhccrmreviewremindsend1.csp.?actiontype=FindList',

				reader : new Ext.data.JsonReader({

							totalProperty : 'results',
							root : 'rows'

						}, [{
									name : 'PatRegNo'
								}, {
									name : 'PatName'
								}, {
									name : 'MobileSend'
								}, {
									name : 'EmailSend'
								}, {
									name : 'PAADMRowID'
								}, {
									name : 'PAPERTelH'
								}, {
									name : 'CTDsec'
								}, {
									name : 'PAADMAdmDate'
								}
								, {
									name : 'PAADMType'
								}
								, {
									name : 'PatSex'
								}
								, {
									name : 'PatAge'
								}])
			});
	var LabResultStore = new Ext.data.Store({

				url : 'dhccrmreviewremindsend1.csp?actiontype=GetResultList',

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

			}, {

				header : '性别',
				dataIndex : 'PatSex',
                width : 50
			}, {

				header : '年龄',
				dataIndex : 'PatAge',
				width : 50

			}, {

				header : '手机',
				dataIndex : 'PAPERTelH'

			}, {

				header : '科室',
				dataIndex : 'CTDsec'

			}, {

				header : '就诊时间',
				dataIndex : 'PAADMAdmDate'

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

	var GridList = new Ext.grid.GridPanel({
				region : 'south',
				height : 500,
				frame : true,
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
	var PAADMTypePanel = new Ext.Panel({
				//title : "类型",
				columnWidth : 0.5,
				layout : 'column',
				items : [{

							columnWidth : 0.3,
							layout : 'form',
							items : [{
										xtype : 'checkbox',
										boxLabel : '门诊',
										labelSeparator:'',
										id : 'Out',
										name : 'Out',
                                        itemCls :'Alignstyle',
                                        labvalue:'类型'
									}]
						},
						 {
							columnWidth : 0.7,
							layout : 'form',
							items : [{
										xtype : 'checkbox',
										boxLabel : '住院',
										labelSeparator:'',
										id : 'InHospital',
										name : 'InHospital'
										//hideLabel:true
                                        
									}]
						}

						, {

							columnWidth : 0.3,
							layout : 'form',
							items : [{
										xtype : 'checkbox',
										boxLabel : '急诊',
										labelSeparator:'',
										id : 'Emergency',
										name : 'Emergency',
                                        itemCls :'Alignstyle'
									}]
						}, {
							columnWidth : 0.7,
							layout : 'form',
							items : [{
										xtype : 'checkbox',
										boxLabel : '体检',
										labelSeparator:'',
										id : 'PE',
										name : 'PE'
                                        //hideLabel:true
									}]

						}]
			});
	var LeftPanel = new Ext.Panel({
                //autoHeight:true,
		        title:'',
				columnWidth : 0.5,
				layout : 'column',
				items : [{

							columnWidth : 0.5,
							layout : 'form',
							items : [{
										xtype : 'datefield',
										fieldLabel : '开始日期',
										id : 'DateFrom',
										name : 'DateFrom',
										allowBlank : true,
										width : 100
									}]
						}, {
							columnWidth : 0.5,
							layout : 'form',
							items : [{
										xtype : 'datefield',
										fieldLabel : '结束日期',
										id : 'DateTo',
										name : 'DateTo',
										//auchor : '90%',
										allowBlank : true,
										width : 100
									}]

						}, {

							columnWidth : 0.5,
							layout : 'form',
							items : [{
										xtype : 'numberfield',
										fieldLabel : '登记号',
										id : 'PatRegNo',
										name : 'PatRegNo',
										width : 100
									}]
						}, {
							columnWidth : 0.5,
							layout : 'form',
							items : [{
										xtype : 'textfield',
										fieldLabel : '姓名',
										id : 'PatName',
										name : 'PatName',
											width : 100
									}]

						}]

			});
	var FirstPanel = new Ext.Panel({
				layout : 'column',
				items : [LeftPanel, PAADMTypePanel]

			});

	var FindPanel = new Ext.form.FormPanel({
		title : '复查提醒',
		frame : true,
		//labelWidth : 80,
		region : 'center',
		items : [{
					layout : 'column',
					items : [{
								columnWidth : 1,
								layout : 'form',
								items : FirstPanel
							}]
				}, {
					layout : 'column',
					items : [{
								columnWidth : 0.25,
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

								columnWidth : 0.25,
								layout : 'form',
								labelWidth : 50,
								buttonAlign:'left',
								
								items : [{
											xtype : 'checkbox',
											fieldLabel : '已发送',
											id : 'SendFlag',
											name : 'SendFlag'
                                            
										}]
							}, {

								columnWidth : 0.1,
								layout : 'form',
								items : [{
									xtype : 'button',
									text : '查找',
									labelAlign :'right',
									pressed : true,
									//buttonAlign:'left',

									handler : function() {
										var startdate='',enddate = '';
										if (Ext.getCmp('DateFrom').getValue() != '') {
											startdate = Ext.getCmp('DateFrom')
													.getValue().format('Y-m-d')
													.toString();
										}

										
										if (Ext.getCmp('DateTo').getValue() != '') {
											enddate = Ext.getCmp('DateTo')
													.getValue().format('Y-m-d')
													.toString();
										}

										PersonListStore.proxy.conn.url = 'dhccrmreviewremindsend1.csp?actiontype=FindList'
												+ '&CTLocRowID='
												+ Ext.getCmp('CTLoc')
														.getValue()
												+ '&DateFrom='
												+ startdate
												+ '&DateTo='
												+ enddate
												+ '&Out='
												+ Ext.getCmp('Out').getValue()
												+ '&InHospital='
												+ Ext.getCmp('InHospital')
														.getValue()
												+ '&Emergency='
												+ Ext.getCmp('Emergency')
														.getValue()
												+ '&PE='
												+ Ext.getCmp('PE').getValue()
												+ '&PatRegNo='
												+ Ext.getCmp('PatRegNo')
														.getValue()
												+ '&PatName='
												+ Ext.getCmp('PatName')
														.getValue()
												+ '&SendFlag='
												+ Ext.getCmp('SendFlag')
														.getValue();
									    
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
                                    buttonAlign:'center',
									handler : function() {

										var selectedRows = GridList
												.getSelectionModel()
												.getSelections();
										if (selectedRows.length == 0) {
											Ext.Msg.alert("提示", "请选择要发送的行记录!");
											return;
										}
										var SendString = "";
										for (i = 0; i < selectedRows.length; i++) {
										
											var PAADMRowID = selectedRows[i].data.PAADMRowID
										
											var PatName = selectedRows[i].data.PatName
										
											var CTDsec= selectedRows[i].data.CTDsec
											var PAADMType=selectedRows[i].data.PAADMType
										    var PatSex=selectedRows[i].data.PatSex
									
										    if (PatSex=='女'){var PatName=PatName+"女士"}
										    else {var PatName=PatName+"先生"}
										    if (PAADMType=='H'){var SendString="尊敬的"+PatName+":您好,您距离上次体检的时间快一年，建议您来友谊医院体检中心复查。"}
											else {var SendString="尊敬的"+PatName+":您好,请您到友谊医院"+CTDsec+"复查。"}
											Returnflag = "Success" // Fail
                                            alert(SendString)
											SendURL = 'dhccrmreviewremindsend1.csp?actiontype=SMSSend'
													+ '&PAADMRowID='
													+ PAADMRowID
													+ '&Returnflag='
													+ Returnflag;
													
											if (FindPanel.getForm().isValid()) {
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
							}]
				}]

	});

	var mainPanel = new Ext.Viewport({
		layout : 'border',
		items : [GridList, FindPanel]
			// items: FindMain
		});
});
