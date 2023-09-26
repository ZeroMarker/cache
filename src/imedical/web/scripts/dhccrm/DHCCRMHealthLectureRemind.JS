// JS:DHCCRMBirthdayRemind.js
// 描述:生日提醒
// Creater：zl
// 日期:2010-04-29
Ext.onReady(function() {
			Ext.QuickTips.init(); // 初始化所有Tips

			var mainPanel = new Ext.Viewport({
						layout : 'border',
						items : [GridList, FindPanel]

					});
		});
var PersonListStore = new Ext.data.Store({

			url : 'dhccrmhealthlectureremind1.csp?actiontype=FindList',

			reader : new Ext.data.JsonReader({

						totalProperty : 'results',
						root : 'rows'

					}, [{
								name : 'PatRegNo'
							}, {
								name : 'PatName'
							}, {
								name : 'PatTelH'
							}, {
								name : 'PatSex'
							}, {
								name : 'PatAge'
							}, {
								name : 'PatDob'
							}, {
								name : 'Deceased'
							}, {
								name : 'PAPMIRowId'
							}])
		});


var sm = new Ext.grid.CheckboxSelectionModel();
var PersonListcm = new Ext.grid.ColumnModel([sm, {

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
			dataIndex : 'PatTelH'

		}, {

			header : '出生年月',
			dataIndex : 'PatDob'

		}, {

			header : '短信发送',
			dataIndex : 'MobileSend',

			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'
						+ (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id
						+ '">&#160;</div>';
			}

		}, {

			header : '邮件发送',
			dataIndex : 'EmailSend',
			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'
						+ (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id
						+ '">&#160;</div>';
			}

		}
		,{

			header : '死亡标识',
			dataIndex : 'Deceased',
			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'
						+ (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id
						+ '">&#160;</div>';
			}

		}]);
var BottomBar = new Ext.PagingToolbar({

			pageSize : 20,
			displayInfo : true,
			store : PersonListStore,
			displayMsg : '当前显示{0} - {1},共计{2}',

			emptyMsg : "没有数据"

		})
	var LocStore = new Ext.data.Store({

				url : 'dhccrmhealthlectureremind1.csp?actiontype=CTLocList',

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

		LocStore.proxy.conn.url = 'dhccrmhealthlectureremind1.csp?actiontype=CTLocList'
				+ '&CTLocDesc=' + Ext.getCmp('CTLoc').getRawValue();
	});
var GridList = new Ext.grid.GridPanel({
			region : 'south',
			height : 580,
			frame : true,
			store : PersonListStore,
			sm : sm,
			cm : PersonListcm,
			trackMouseOver : true,
			loadMask : true,
			stripeRows : true,
			bbar : BottomBar,
			viewConfig : {
				forceFit : true
			}

		});

var FindPanel = new Ext.form.FormPanel({
		title : '健康讲座提醒',
		frame : true,
		region : 'center',
		labelWidth : 65,
		items : [{
					layout : 'column',
					items : [
						 {columnWidth : 0.3,
						  layout : 'form',
						  	items : [{
							xtype : 'datefield',
							fieldLabel : '出院日期',
							id : 'DateFrom',
							name : 'DateFrom',
							allowBlank : true,
							width : 120}]

						},{
								columnWidth : 0.7,
								layout : 'form',
								items : [{
											xtype : 'combo',
											fieldLabel : '诊断',
											id : 'Diagnosis',
											name : 'Diagnosis',
											width : 120,
											store : LocStore,
											loadMask : true,
											triggerAction : 'all',
											minChars : 1,
											selectOnFocus : true,
											forceSelection : true,
											valueField : 'DiagnosisRowID',
											displayField : 'DiagnosisName',
											pageSize : 14,
											minListWidth : 220

										}]
							}]},
			     {
					layout : 'column',
					items : [{
								columnWidth : 0.3,
								layout : 'form',
								items : [{
											xtype : 'combo',
											fieldLabel : '科室',
											id : 'CTLoc',
											name : 'CTLoc',
											width : 120,
											store : LocStore,
											loadMask : true,
											triggerAction : 'all',
											minChars : 1,
											selectOnFocus : true,
											forceSelection : true,
											valueField : 'CTLocRowID',
											displayField : 'CTLocName',
											pageSize : 14,
											minListWidth : 220

										}]
							}, {

								columnWidth : 0.7,
								layout : 'form',
								labelWidth : 50,
								buttonAlign : 'left',

								items : [{
											xtype : 'checkbox',
											fieldLabel : '已发送',
											id : 'SendFlag',
											name : 'SendFlag'

										}]
							}]
				},{layout : 'column',
					items : [ {

								columnWidth : 0.1,
								layout : 'form',
								items : [{
									xtype : 'button',
									text : '查找',
									labelAlign : 'right',
									pressed : true,
									// buttonAlign:'left',

									handler : function() {
										var startdate = '', enddate = '';
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

										PersonListStore.proxy.conn.url = 'dhccrmhealthlectureremind1.csp?actiontype=FindList'
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
									buttonAlign : 'center',
									handler : function() {

										var selectedRows = GridList
												.getSelectionModel()
												.getSelections();
										if (selectedRows.length == 0) {
											Ext.Msg.alert("提示", "请选择要发送的行记录!");
											return;
										}
										var NULLTelStr = ""
										var SendString = "";
										for (i = 0; i < selectedRows.length; i++) {

											var PAADMRowID = selectedRows[i].data.PAADMRowID

											var PatName = selectedRows[i].data.PatName

											var CTDsec = selectedRows[i].data.CTDsec
											var PAADMType = selectedRows[i].data.PAADMType
											var PatSex = selectedRows[i].data.PatSex
											var PAPERTelH = selectedRows[i].data.PAPERTelH
											var TelFlag = isMoveTel(PAPERTelH)

											if ((PAPERTelH == '')
													|| (TelFlag == 0)) {

												if (NULLTelStr == "") {
													NULLTelStr = PatName
												} else {

													if (NULLTelStr
															.indexOf(PatName) == -1) {
														NULLTelStr = NULLTelStr
																+ "、" + PatName
													} else {
														NULLTelStr = NULLTelStr
													}

												}

											} else {
												if (PatSex == '女') {
													var PatName = PatName
															+ "女士"
												} else {
													var PatName = PatName
															+ "先生"
												}
												if (PAADMType == 'H') {
													var SendString = "尊敬的"
															+ PatName
															+ ":您好,您距离上次体检的时间快一年，建议您来友谊医院体检中心复查。"
												} else {
													var SendString = "尊敬的"
															+ PatName
															+ ":您好,请您到友谊医院"
															+ CTDsec + "复查。"
												}
												Returnflag = "Success" // Fail
												alert(SendString)
												SendURL = 'dhccrmhealthlectureremind1.csp?actiontype=SMSSend'
														+ '&PAADMRowID='
														+ PAADMRowID
														+ '&Returnflag='
														+ Returnflag;

												if (FindPanel.getForm()
														.isValid()) {
													Ext.Ajax.request({
														url : SendURL,
														waitMsg : '发送中...',
														failure : function(
																result, request) {
															Ext.Msg.show({
																title : '错误',
																msg : '请检查网络连接!',
																buttons : Ext.Msg.OK,
																icon : Ext.MessageBox.ERROR
															});
														},
														success : function(
																result, request) {
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
										if (NULLTelStr != '') {
											Ext.Msg.show({
														title : '提示',
														msg : NULLTelStr
																+ '手机号码不正确!',
														buttons : Ext.Msg.OK,
														icon : Ext.MessageBox.INFO
													});

										}

									}

								}]
							}, {
								columnWidth : 0.1,
								layout : 'form',
								items : [{
											xtype : 'tbbutton',
											text : '邮件发送 ',
											id : 'EmailSend',
											name : 'EmailSend',
											pressed : true

										}]
							},
							 {
				xtype : 'panel',
				layout : 'form',
				columnWidth : 0.6,
				items : [{
							xtype : 'tbbutton',
							text : '拨号',
							id : 'Tel',
							name : 'Tel',
							pressed : true,
							buttonAlign : 'center'
						}]
			}]}]

	});
function isMoveTel(MobilePhone) {
	var pattern = /^0{0,1}13|15|18[0-9]{9}$/;
	if (pattern.test(MobilePhone)) {

		var TelFlag = 1
	} else {
		var TelFlag = 0

	}
	return TelFlag
}
