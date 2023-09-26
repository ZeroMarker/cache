// JS:DHCCRMBirthdayRemind.js
// 描述:生日提醒
// Creater：zl
// 日期:2010-04-29

Ext.onReady(function() {
	Ext.BLANK_IMAGE_URL = '../scripts/DHCCRM/Ext2/resources/images/default/s.gif';
	Ext.QuickTips.init(); // 初始化所有Tips

	var mainPanel = new Ext.Viewport({
				layout : 'border',
				items : [GridList, FindPanel]

			});
});
/*
 * var DateFrom = new Ext.form.DateField({ id:'DateFrom', name:'DateFrom',
 * fieldLable:'输入日期', allowBlank:true, value:new
 * Date().format('Y-m-d').toString(),//默认选择当天 width:90 });
 * 
 * var DateTo = new Ext.form.DateField({ id:'DateTo', name:'DateTo',
 * fieldLable:'结束日期', allowBlank:true, width:120 }); var SendFlag = new
 * Ext.form.Checkbox({ //xtype : 'checkbox', boxLabel : '已发送', labelSeparator :
 * '', id : 'SendFlag', name : 'SendFlag', hideLabel : true
 * 
 * 
 * }); var startdate = '', enddate = ''; if (Ext.getCmp('DateFrom').getValue() ==
 * '') { Ext.Msg.show({ title : '提示', msg : '开始时间不能为空!', buttons : Ext.Msg.OK,
 * icon : Ext.MessageBox.ERROR });
 *  } startdate = Ext.getCmp('DateFrom').getValue() .format('Y-m-d').toString();
 * if (Ext.getCmp('DateTo').getValue() != '') { enddate =
 * Ext.getCmp('DateTo').getValue() .format('Y-m-d').toString(); }
 */
// alert(Ext.getCmp("DateFrom").getValue().toString()+"aaaaaas")
var date = "";
var FindPanel = new Ext.form.FormPanel({
	id : 'FindPanel',
	title : '生日提醒',
	frame : true,
	region : 'center',
	// layout : 'column',
	labelWidth : 65,
	items : [new Ext.Toolbar({
		hidden : true,
		items : [{
			xtype : 'tbbutton',
			pressed : true,
			text : '登录',
			handler : function() {
				var loginform = new Ext.form.FormPanel({
							frame : true,
							labelWidth : 80,
							autoHeight : true,
							items : [{
										layout : 'column',
										items : [{
													columnWidth : 1,
													layout : 'form',
													items : [{
																xtype : 'textfield',
																fieldLabel : '分机号码',
																id : 'ExtNumber',
																name : 'ExtNumber',
																auchor : '90%',
																allowBlank : false
															}]
												}]
									}, {
										layout : 'column',
										items : [{
													columnWidth : 1,
													layout : 'form',
													items : [{
																xtype : 'textfield',
																fieldLabel : '座席组号',
																id : 'GroupID',
																name : 'GroupID',
																auchor : '90%',
																allowBlank : false
															}]
												}]
									}, {
										layout : 'column',
										items : [{
													columnWidth : 1,
													layout : 'form',
													items : [{
																xtype : 'textfield',
																fieldLabel : '座席号',
																id : 'AgentID',
																name : 'AgentID',
																auchor : '90%',
																allowBlank : false
															}]
												}]
									}, {
										layout : 'column',
										items : [{
													columnWidth : 1,
													layout : 'form',
													items : [{
																xtype : 'textfield',
																fieldLabel : '座席名称',
																id : 'AgentName',
																name : 'AgentName',
																auchor : '90%',
																allowBlank : false
															}]
												}]
									}]
						});

				var window = new Ext.Window({
							id : 'window',
							title : '登录',
							width : 300,
							height : 200,
							layout : 'fit',
							plain : true,
							modal : true,
							buttonAlign : 'center',
							items : loginform,
							buttons : [{
								xtype : 'tbbutton',
								text : '确定',
								handler : function() {
									var extnumber = Ext.getCmp('ExtNumber')
											.getValue();
									var groupid = Ext.getCmp('GroupID')
											.getValue();
									var agentid = Ext.getCmp('AgentID')
											.getValue();
									var agentname = Ext.getCmp('AgentName')
											.getValue();
									Login(extnumber, groupid, agentid,
											agentname);
									window.close();
								}
							}]
						});

				window.show();
			}

		}, {

			xtype : 'tbbutton',
			pressed : true,
			text : '退出',
			handler : function() {
				DoLogout();
			}

		}, {

			xtype : 'hidden',
			pressed : true,
			text : '示闲',
			handler : function() {
				DoSetIdle();
			}

		}, {

			xtype : 'tbbutton',
			pressed : true,
			text : '挂断',
			handler : function() {
				DoHangupCall();
			}
		}]
	}), {
		layout : 'column',
		items : [{
					columnWidth : 0.2,
					layout : 'form',
					items : [{
								xtype : 'datefield',
								fieldLabel : '输入日期',
								id : 'DateFrom',
								name : 'DateFrom',
								allowBlank : true,
								format : 'Y-m-d',// 默认显示格式
								value : new Date().format('Y-m-d').toString(),// 默认选择当天
								width : 90
							}]

				}, {
					columnWidth : 0.5,
					layout : 'form',

					items : [{
								xtype : 'checkbox',
								boxLabel : '已发送',
								labelSeparator : '',
								id : 'SendFlag',
								name : 'SendFlag',
								hideLabel : true

							}]
				}]
	}, {
		layout : 'column',
		items : [{

			columnWidth : 0.2,
			layout : 'form',
			items : [{
				xtype : 'tbbutton',
				text : '查找',
				// labelAlign : 'right',
				pressed : true,
				handler : function() {
					var startdate = '', enddate = '';
					if (Ext.getCmp('DateFrom').getValue() == '') {
						Ext.Msg.show({
									title : '提示',
									msg : '输入日期不能为空!',
									buttons : Ext.Msg.OK,
									icon : Ext.MessageBox.ERROR
								});

					}
					startdate = Ext.getCmp('DateFrom').getValue()
							.format('Y-m-d').toString();
					// alert(startdate+","+enddate+","+SendFlag)
					PersonListStore.proxy.conn.url = 'dhccrmbirthdayremind1.csp?actiontype=FindList'
							+ '&DateFrom='// 改这里
							+ startdate
							+ '&SendFlag='
							+ Ext.getCmp('SendFlag').getValue();
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
			columnWidth : 0.2,
			layout : 'form',
			items : [{
				xtype : 'tbbutton',
				text : '短信发送',
				id : 'SMSSend',
				name : 'SMSSend',
				// pressed : true,
				buttonAlign : 'center',
				handler : function() {

					var selectedRows = GridList.getSelectionModel()
							.getSelections();
					if (selectedRows.length == 0) {
						Ext.Msg.alert("提示", "请选择要发送的行记录!");
						return;
					}
					var NULLTelStr = ""
					var SendString = "";
					for (i = 0; i < selectedRows.length; i++) {

						var PAPMIRowId = selectedRows[i].data.PAPMIRowId

						var PatName = selectedRows[i].data.PatName

						var CTDsec = selectedRows[i].data.CTDsec
						var PAADMType = selectedRows[i].data.PAADMType
						var PatSex = selectedRows[i].data.PatSex
						var PatTelH = selectedRows[i].data.PatTelH

						var TelFlag = isMoveTel(PatTelH)

						if ((PatTelH == '') || (TelFlag == 0)) {

							if (NULLTelStr == "") {
								NULLTelStr = PatName
							} else {

								if (NULLTelStr.indexOf(PatName) == -1) {
									NULLTelStr = NULLTelStr + "、" + PatName
								} else {
									NULLTelStr = NULLTelStr
								}

							}

						} else {
							if (PatSex == '女') {
								var PatName = PatName + "女士"
							} else {
								var PatName = PatName + "先生"
							}

							var SendString = "尊敬的" + PatName + ":祝您生日快乐！友谊医院。"

							Returnflag = "Success" // Fail
							alert(SendString)
							SendURL = 'dhccrmbirthdayremind1.csp?actiontype=SMSSend'
									+ '&PAPMIRowId='
									+ PAPMIRowId
									+ '&Returnflag=' + Returnflag;

							if (FindPanel.getForm().isValid()) {
								Ext.Ajax.request({
									url : SendURL,
									waitMsg : '发送中...',
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
											PersonListStore.load({
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
					}
					if (NULLTelStr != '') {
						Ext.Msg.show({
									title : '提示',
									msg : NULLTelStr + '手机号码不正确!',
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
						text : '邮件发送',
						id : 'EmailSend',
						name : 'EmailSend',
						// pressed : true,
						buttonAlign : 'center'
					}]
		}, {
			xtype : 'panel',
			layout : 'form',
			hidden : true,
			columnWidth : 0.5,
			items : [{
						xtype : 'tbbutton',
						text : '拨号',
						id : 'Tel',
						name : 'Tel',
						// pressed : true,
						buttonAlign : 'center',
						handler : function() {
							var telnumber = Ext.getCmp('MRORGTEL').getValue();
							DoMakeCall(telnumber);
						}
					}]
		}]
	}]

});

var PersonListStore = new Ext.data.Store({

			url : 'dhccrmbirthdayremind1.csp?actiontype=FindList',

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
							}, {
								name : 'MobileSend'
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

		}, {

			header : '死亡标识',
			dataIndex : 'Deceased',
			renderer : function(v, p, record) {
				p.css += ' x-grid3-check-col-td';
				return '<div class="x-grid3-check-col'
						+ (v == 'Y' ? '-on' : '') + ' x-grid3-cc-' + this.id
						+ '">&#160;</div>';
			}

		}]);
/*
 * var oParams = new Object(); oParams["start"] = 0; oParams["limit"] = 5;
 * oParams["DateFrom"] = Ext.getCmp("DateFrom").getValue().toString();
 * oParams["SendFlag"] = Ext.getCmp("SendFlag").getValue();
 */

var BottomBar = new Ext.PagingToolbar({
			pageSize : 20,
			displayInfo : true,
			store : PersonListStore,
			atLoad : true,
			displayMsg : '当前显示{0} - {1},共计{2}',
			emptyMsg : "没有数据",
			doLoad : function(start) {// 这里是点击下一页触发的函数，默认的方法是调用store.load()f方法，此方法只有两个参数start,limit。
				var dateStr = Ext.getCmp('DateFrom').getValue().format('Y-m-d')
						.toString();

				var tmpUrl = 'dhccrmbirthdayremind1.csp?actiontype=FindList'
						+ '&DateFrom='// 改这里
						+ dateStr + '&SendFlag='
						+ Ext.getCmp('SendFlag').getValue();

				// alert(tmpUrl);
				// alert(startdate+","+enddate+","+SendFlag)
				PersonListStore.proxy.conn.url = tmpUrl;
				PersonListStore.load({
							params : {
								start : start,
								limit : 20
							}
						});
			}

		})

var GridList = new Ext.grid.GridPanel({
			region : 'south',
			height : 480,
			frame : true,
			store : PersonListStore,// 工具条跟grid没有必然联系，是通过store
									// 联系起来的，点击下一页的时候是加载这个
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
PersonListStore.load({
			parms : {
				start : 0,
				limit : BottomBar.pageSize
			}
		});// 在这里控制，这里就是一进入页面就加载数据的方法，前台不传入时间参数，在后台直接获取

/*
 * PersonListStore.on('beforeload', function (PersonListStore, options) { var
 * new_params = { DateFrom:
 * Ext.getCmp('DateFrom').getValue().format('Y-m-d').toString() };
 * Ext.apply(PersonListStore.proxy.extraParams, new_params); //
 * alert('beforeload'); });
 */
function isMoveTel(PAPERTelH) {
	var pattern = /^0{0,1}13|15|18[0-9]{9}$/;
	if (pattern.test(PAPERTelH)) {

		var TelFlag = 1
	} else {
		var TelFlag = 0

	}
	return TelFlag
}
