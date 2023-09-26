var FindFlag = "N";
var mainView;
var panel;
// var RecordID = '';
var PAPMIID = '';
var PlayName = '';
var PlanID = '';
var adm = '';
var FUPRowId = '';
var findPatList;
var dynamicpanel;
var form;

function CreateMainPanel() {

	var ButtonText = "录音";
	var SaveDisabled = false;
	var RecordDisabled = false;

	if (FindFlag == "Y") {
		ButtonText = "播放";
		SaveDisabled = true;
		if (PlayName == "")
			RecordDisabled = true;
	}

	panel = new Ext.Panel({
				id : 'panel',
				autoScroll : true,
				// buttonAlign: 'center',
				buttons : [{
							xtype : 'button',
							text : '保存',
							disabled : SaveDisabled,
							handler : save_Click
						}]
			});
	
	var Title = cspRunServerMethod(getTitle, RecordID, PlanID);
	if (Title == "")
		return false;
	var TitleArr = Title.split("^");
	var l = TitleArr.length;
	for (var i = 0; i < l; i++) {
		var TitleInfo = TitleArr[i];
		var InfoArr = TitleInfo.split("&");
		var TitleID = InfoArr[0];
		var TitleCode = InfoArr[1];
		var TitleDesc = InfoArr[2];
		var Detail = cspRunServerMethod(getDetail, TitleID, RecordID, FUPRowId)
		if (Detail == "")
			continue;
		var DetailArr = Detail.split("^");
		var j = DetailArr.length;
		var tabpanel = new Ext.Panel({
					id : 'tabpanel',
					title : '一级随访',
					frame : true,
					autoHeight : true,
					border : false,
					collapsed : false,
					collapseFirst : true
				});
		var tabpanel2 = new Ext.Panel({
					id : 'tabpanel2',
					title : '二级随访',
					frame : true,
					autoHeight : true,
					border : false,
					collapsed : false,
					collapseFirst : true
				});
		var tabpanel3 = new Ext.Panel({
					id : 'tabpanel3',
					title : '三级随访',
					aframe : true,
					autoHeight : true,
					border : false,
					collapsed : false,
					collapseFirst : true
				});
		var TitlePanel = new Ext.TabPanel({
					frame : true,
					title : TitleDesc,
					autoHeight : true,
					border : false,
					activeTab : tabpanel,
					// layout : 'column',
					collapsed : false,
					items : [tabpanel, tabpanel2, tabpanel3],
					// collapsible: true,
					collapseFirst : true,
					id : TitleID
				});
		for (var k = 0; k < j; k++) {
			var DetailInfo = DetailArr[k];
			if (DetailInfo == "")
				continue;
			var DInfoArr = DetailInfo.split("&");
			
			var DetialID = DInfoArr[0];
			var DetailDesc = DInfoArr[2];
			var DetailType = DInfoArr[3];
			var DetailRequired = DInfoArr[6];
			var DetailUnit = DInfoArr[4];
			var DetailExplain = DInfoArr[5];
			var ElementNum = DInfoArr[8];
			var value = DInfoArr[7];
			
			var hidden = DInfoArr[9];
			var tvalue = DInfoArr[10];
			var parentdr = DInfoArr[11];
			if (hidden == 'Y')
				hidden = true;
			else
				hidden = false;

			if (ElementNum == 0) {
				var width = .25
			} else {
				var width = 1 / ElementNum
			}
			var Field, AddField = '', AddFieldBZ = '', UnitField = '', RequiredBoolean = true;
			if (DetailRequired == "Y")
				RequiredBoolean = false;
			var DetailFieldSets = new Ext.form.FieldSet({
						title : DetailDesc,
						layout : 'column',
						id : "FS" + DetialID,
						columnWidth : 1,
						border : false,
						frame : true,
						autoHeight : true,
						collapsed : false,
						// collapsible: true,
						collapseFirst : true
						//hidden : hidden

					});
			if(hidden) Ext.getCmp('FS' + DetialID).disable();
			var DetailUnitField = ''
			if (DetailType == 'T') {
				Field = new Ext.form.TextArea({
							allowBlank : RequiredBoolean,
							emptyText : '请输入内容...',
							fieldLabel : '',
							width : 300,
							height : 50,
							id : DetialID,
							value : value
						});
				var FieldPanel = new Ext.Panel({
							layout : 'form',
							items : Field,
							labelWidth : 400,
							id : "P" + DetialID,
							columnWidth : 1
						})
				DetailFieldSets.add(FieldPanel);

				if (parentdr == 1)
					tabpanel.add(DetailFieldSets);
				else if (parentdr == 2)
					tabpanel2.add(DetailFieldSets);
				else if (parentdr == 3)
					tabpanel3.add(DetailFieldSets);
				else
					tabpanel.add(DetailFieldSets);
				// TitlePanel.add(DetailFieldSets);
			}

			else if (DetailType == 'N') {

				if (DetailUnit != '') {
					DetailUnitField = new Ext.form.Label({
								text : DetailUnit
							});

				} else {
					DetailUnitField = ''
				}
				Field = new Ext.form.NumberField({
							allowBlank : RequiredBoolean,
							emptyText : '请输入数值...',
							fieldLabel : '',
							id : DetialID,
							value : value
						});
				var FieldPanel = new Ext.Panel({
							layout : 'form',
							items : Field,
							labelWidth : 450,
							id : "P" + DetialID,
							columnWidth : 1
						})
				if (DetailUnitField != '') {
					FieldPanel.add(DetailUnitField)

				}
				DetailFieldSets.add(FieldPanel);
				if (parentdr == 1)
					tabpanel.add(DetailFieldSets);
				else if (parentdr == 2)
					tabpanel2.add(DetailFieldSets);
				else if (parentdr == 3)
					tabpanel3.add(DetailFieldSets);
				else
					tabpanel.add(DetailFieldSets);
				// TitlePanel.add(FieldPanel);
			} else if (DetailType == 'D') {
				var Select = cspRunServerMethod(getSelect, DetialID, RecordID,FUPRowId);

				SelectArr = Select.split("^");
				var m = SelectArr.length;
				for (var n = 0; n < m; n++) {
					SelectInfo = SelectArr[n];
					if (SelectInfo == "")
						continue;
					SelectInfoArr = SelectInfo.split("&");
					SelectID = SelectInfoArr[0];
					SelectDesc = SelectInfoArr[1];
					SelectFlag = SelectInfoArr[2];
					AddDesc = SelectInfoArr[4];
					Dvalue = SelectInfoArr[5];
					if (SelectFlag == 'Y') {
						SelectFlag = true
					} else {
						SelectFlag = false
					}

					if (AddDesc == 'Y') {

						AddFieldBZ = new Ext.form.TextField({
									id : "ADB" + SelectID,
									width : 150,
									value : Dvalue
								});

					} else {
						AddFieldBZ = ''
					}

					Field = new Ext.form.Checkbox({
								id : SelectID,
								boxLabel : SelectDesc,
								checked : SelectFlag,
								hideLabel : true
							});
					var FieldPanel = new Ext.Panel({
								layout : 'column',
								items : Field,
								id : "P" + SelectID,
								columnWidth : width
							})

					if (AddFieldBZ != '') {
						FieldPanel.add(AddFieldBZ)

					}
					DetailFieldSets.add(FieldPanel);
				};

				DetailFieldSets.doLayout(true);
				panel.doLayout(true);
				if (parentdr == 1)
					tabpanel.add(DetailFieldSets);
				else if (parentdr == 2)
					tabpanel2.add(DetailFieldSets);
				else if (parentdr == 3)
					tabpanel3.add(DetailFieldSets);
				else
					tabpanel.add(DetailFieldSets);

				// TitlePanel.add(DetailFieldSets);
			} else if (DetailType == 'DT') {
				var Select = cspRunServerMethod(getSelect, DetialID, RecordID,FUPRowId);

				SelectArr = Select.split("^");

				var m = SelectArr.length;
				for (var n = 0; n < m; n++) {
					SelectInfo = SelectArr[n];
					if (SelectInfo == "")
						continue;
					SelectInfoArr = SelectInfo.split("&");
					SelectID = SelectInfoArr[0];
					SelectDesc = SelectInfoArr[1];
					SelectFlag = SelectInfoArr[2];
					AddDesc = SelectInfoArr[4];
					Dvalue = SelectInfoArr[5];
					if (SelectFlag == 'Y') {
						SelectFlag = true
					} else {
						SelectFlag = false
					}

					if (AddDesc == 'Y') {

						AddFieldBZ = new Ext.form.TextField({
									id : "ADB" + SelectID,
									width : 150,
									value : Dvalue
								});

					} else {
						AddFieldBZ = ''
					}

					Field = new Ext.form.TextField({
								id : SelectID,
								fieldLabel : SelectDesc,
								width : 150,
								value : Dvalue
							});
					var FieldPanel = new Ext.Panel({
								layout : 'form',
								items : Field,
								id : "P" + SelectID,
								columnWidth : width
							})

					if (AddFieldBZ != '') {
						FieldPanel.add(AddFieldBZ)

					}
					DetailFieldSets.add(FieldPanel);
				};

				DetailFieldSets.doLayout(true);
				panel.doLayout(true);
				if (parentdr == 1)
					tabpanel.add(DetailFieldSets);
				else if (parentdr == 2)
					tabpanel2.add(DetailFieldSets);
				else if (parentdr == 3)
					tabpanel3.add(DetailFieldSets);
				else
					tabpanel.add(DetailFieldSets);
				// TitlePanel.add(DetailFieldSets);
			} else if (DetailType == 'DN') {
				var Select = cspRunServerMethod(getSelect, DetialID, RecordID,FUPRowId);

				SelectArr = Select.split("^");

				var m = SelectArr.length;
				for (var n = 0; n < m; n++) {
					SelectInfo = SelectArr[n];
					if (SelectInfo == "")
						continue;
					SelectInfoArr = SelectInfo.split("&");
					SelectID = SelectInfoArr[0];
					SelectDesc = SelectInfoArr[1];
					SelectFlag = SelectInfoArr[2];
					AddDesc = SelectInfoArr[4];
					Dvalue = SelectInfoArr[5];
					if (SelectFlag == 'Y') {
						SelectFlag = true
					} else {
						SelectFlag = false
					}

					if (AddDesc == 'Y') {

						AddFieldBZ = new Ext.form.TextField({
									id : "ADB" + SelectID,
									width : 150,
									value : Dvalue
								});

					} else {
						AddFieldBZ = ''
					}

					Field = new Ext.form.NumberField({
								id : SelectID,
								fieldLabel : SelectDesc,
								width : 150,
								value : Dvalue
							});
					var FieldPanel = new Ext.Panel({
								layout : 'form',
								items : Field,
								id : "P" + SelectID,
								columnWidth : width
							})

					if (AddFieldBZ != '') {
						FieldPanel.add(AddFieldBZ)

					}
					DetailFieldSets.add(FieldPanel);
				};

				DetailFieldSets.doLayout(true);
				panel.doLayout(true);
				if (parentdr == 1)
					tabpanel.add(DetailFieldSets);
				else if (parentdr == 2)
					tabpanel2.add(DetailFieldSets);
				else if (parentdr == 3)
					tabpanel3.add(DetailFieldSets);
				else
					tabpanel.add(DetailFieldSets);
				// TitlePanel.add(DetailFieldSets);
			} else {
				var Select = cspRunServerMethod(getSelect, DetialID, RecordID,FUPRowId);
				SelectArr = Select.split("^");
				var m = SelectArr.length;
				for (var n = 0; n < m; n++) {
					SelectInfo = SelectArr[n];
					if (SelectInfo == "")
						continue;
					SelectInfoArr = SelectInfo.split("&");
					SelectID = SelectInfoArr[0];
					SelectDesc = SelectInfoArr[1];
					SelectFlag = SelectInfoArr[2];
					SelectUnit = SelectInfoArr[3];
					AddDesc = SelectInfoArr[4];
					Dvalue = SelectInfoArr[5];
					if (SelectFlag == 'Y') {
						SelectFlag = true
					} else {
						SelectFlag = false
					}

					if (AddDesc == 'Y') {
						value = tvalue.split('$')[n]

						AddField = new Ext.form.NumberField({
									id : "AD" + SelectID,
									width : 20,
									value : value
									//hidden : true
								});
						AddFieldBZ = new Ext.form.TextField({
									id : "ADB" + SelectID,
									width : 50,
									value : Dvalue
								});

					} else {
						AddField = ''
						AddFieldBZ = ''
					}

					if (SelectUnit != '') {
						UnitField = new Ext.form.Label({
									text : SelectUnit
								});

					} else {
						UnitField = ''
					}
					Field = new Ext.form.Radio({
								id : SelectID,
								name : DetialID,
								boxLabel : SelectDesc,
								checked : SelectFlag,
								hideLabel : true,
								listeners : {
									'check' : function(radio, checked) {

										var ret = tkMakeServerCall(
												"web.DHCCRM.PatInfo",
												"GetHiddenDetail", radio.id);

										var str = ret.split("^")
										if (str == "")
											return
									
										for (var i = 0; i < str.length; i++) {
										
											if (checked)
											{
												//Ext.getCmp('FS' + str[i]).show();
												Ext.getCmp('FS' + str[i]).enable();
											} else {
												//Ext.getCmp('FS' + str[i]).hide();
												Ext.getCmp('FS' + str[i]).disable();
											}
										}

									}
								}
							});
					var FieldPanel = new Ext.Panel({
								layout : 'column',
								items : Field,
								id : "P" + SelectID,
								columnWidth : width
							})

					if (AddField != '') {
						FieldPanel.add(AddField)

					}
					if (UnitField != '') {
						FieldPanel.add(UnitField)

					}
					if (AddFieldBZ != '') {
						FieldPanel.add(AddFieldBZ)

					}
					DetailFieldSets.add(FieldPanel);

				};
				DetailFieldSets.doLayout(true);
				panel.doLayout(true);
				if (parentdr == 1)
					tabpanel.add(DetailFieldSets);
				else if (parentdr == 2)
					tabpanel2.add(DetailFieldSets);
				else if (parentdr == 3)
					tabpanel3.add(DetailFieldSets);
				else
					tabpanel.add(DetailFieldSets);
				// TitlePanel.add(DetailFieldSets);
			}

		};
		panel.add(TitlePanel);
		TitlePanel.doLayout(true);
	};
	panel.doLayout(true);

}

function save_Click() {

	var Template = ""
	var saveInfo = '';
	var mainInfo = '';
	var user = session['LOGON.USERID'];
	var demo = "";

	var mainInfo = RecordID + "^" + FUPRowId + "^" + adm + "^" + PAPMIID + "^"
			+ user + "^" + demo;

	var pp = panel.findByType('textfield');
	var j = pp.length;
	for (var i = 0; i < j; i++) {

		if (!pp[i].isValid()) {
			Ext.MessageBox.show({
						title : '提示',
						msg : pp[i].fieldLabel + '不能为空',
						buttons : Ext.Msg.OK,
						fn : function() {
							pp[i].focus();
						}
					});
			return false;
		}
		Template = ""
		var id = pp[i].getId();

		if (id.split('||').length == 2)
			var value = pp[i].getValue();
		if (id.split('||').length == 3) {
			var value = pp[i].fieldLabel;
			Template = '@' + pp[i].getValue();
		}

		if (id.indexOf('AD') >= 0)
			continue;
		if (id.indexOf('ADB') >= 0)
			continue;

		if (saveInfo == "") {
			saveInfo = id + "^" + value + "^" + Template;
		} else {
			saveInfo = saveInfo + "&" + id + "^" + value + "^" + Template;
		}
	};
	var pp = panel.findByType('numberfield');
	var j = pp.length;
	for (var i = 0; i < j; i++) {
		if (!pp[i].isValid()) {
			Ext.MessageBox.show({
						title : '提示',
						msg : pp[i].fieldLabel + '不能为空',
						buttons : Ext.Msg.OK,
						fn : function() {
							pp[i].focus();
						}
					});
			return false;
		}
		Template = ""
		var id = pp[i].getId();

		if (id.split('||').length == 2)
			var value = pp[i].getValue();
		if (id.split('||').length == 3) {
			var value = pp[i].fieldLabel;
			Template = '@' + pp[i].getValue();
		}

		if (id.indexOf('AD') >= 0)
			continue;
		if (id.indexOf('ADB') >= 0)
			continue;
		/*
		 * if (saveInfo == "") { saveInfo = id + "^" + value + "^" + Template; }
		 * else { saveInfo = saveInfo + "&" + id + "^" + value + "^" + Template; }
		 */

	};
	var pp = panel.findByType('checkbox');
	var j = pp.length;
	for (var i = 0; i < j; i++) {

		var id = pp[i].getId();
		var value = pp[i].getValue();
		var addvalue = '';
		var addid = 'AD' + id;
		if (Ext.getCmp(addid)) {
			addvalue = Ext.getCmp(addid).getValue();

		}
		var addbzvalue = '';
		var addbzid = 'ADB' + id;
		if (Ext.getCmp(addbzid)) {
			addbzvalue = Ext.getCmp(addbzid).getValue();

		}
		var string = "";
		Template = ""
		if (value)
			string = pp[i].boxLabel;
		if (addvalue != '')
			Template = addvalue;
		if (addbzvalue != '')
			Template = Template + "@" + addbzvalue;
		if (saveInfo == "") {
			saveInfo = id + "^" + string + "^" + Template;
		} else {
			saveInfo = saveInfo + "&" + id + "^" + string + "^" + Template;
		}
	};
	saveInfo = mainInfo + "$" + saveInfo

	var result = cspRunServerMethod(saveClass, saveInfo);
	if (result > 0) {
		RecordID = result;
		// Ext.MessageBox.alert("恭喜", "保存成功");
		findPatList();
		if (dynamicpanel.getComponent('panel') != null) {
			dynamicpanel.remove(dynamicpanel.getComponent('panel'));
		};
		dynamicpanel.doLayout();
		form.getForm().reset();

	}else if(result==0){
		Ext.MessageBox.alert("很遗憾", "该病人对应的随访主题不存在，请联系管理员");
	} else {
		Ext.MessageBox.alert("很遗憾", "保存失败，请和管理员联系");
	}
}

function clear_Click() {
	mainView.remove(panel)
	LoadPage();
}

function return_Click() {
	RecordID = '';
	PAPMIID = '';
	mainView.remove(panel)
	LoadPage();

}

function record_Click(e) {
	var RecordObj = new ActiveXObject("录音机.record");
	if (FindFlag == "Y") {
		if (PlayName == "") {
			Ext.MessageBox.alert('提示', '本调查没有录音');
			return false;
		}
		RecordObj.CRMClose();
		RecordObj.PlayName = PlayName;
		RecordObj.CRMPlay();
		return false;
	}
	var RTimeLabel = new Ext.form.Label({
				html : '<p><h1><br><FONT SIZE =6 color=red>已录音时间0秒</FONT></h1></p>'
			});
	var RecordWin = new Ext.Window({
				title : '调查录音',
				layout : 'form',
				width : 400,
				height : 300,
				items : [{
							xtype : 'label',
							html : '<p> <FONT SIZE =6>正在录音，请讲话...</FONT></p>'
						}, RTimeLabel],
				buttons : [{
							text : '保存',
							handler : Save_Record
						}]
			});
	RecordWin.on('show', Win_Show);
	RecordWin.on('close', Win_Close);
	RecordWin.show();
	var RTime = 0;
	var task = {
		run : function() {
			RTime = RTime + 1;
			RTimeLabel.destroy();
			RTimeLabel = new Ext.form.Label({
						html : '<p><h1><br><FONT SIZE =6 color=red>已录音时间'
								+ RTime + '秒</FONT></h1></p>'
					});
			RecordWin.add(RTimeLabel);
			RecordWin.doLayout(true);
		},
		interval : 1000
	}
	Ext.TaskMgr.start(task);
	function Save_Record() {
		var mainInfo = '';
		var planID = "";
		var adm = "";
		var user = session['LOGON.USERID'];
		var demo = "";
		var mainInfo = RecordID + "^" + planID + "^" + adm + "^" + PAPMIID
				+ "^" + user + "^" + demo;
		var resultStr = cspRunServerMethod(getRecord, mainInfo);
		var resultArr = resultStr.split("^");
		var resultFlag = resultArr[0];
		if (resultFlag > 0) {
			RecordID = resultFlag
		} else {
			Ext.MessageBox.alert('很遗憾', resultArr[1]);
			RecordWin.close()
			return false;
		}
		Ext.TaskMgr.stopAll();
		RecordObj.DirStr = resultArr[1];
		RecordObj.CreateDir();
		RecordObj.SaveStr = resultArr[1] + RecordID + '.wav';
		RecordObj.CRMSave();
		RecordWin.close();
	}
	function Win_Show(Win) {
		RecordObj.CRMRecord();
	}
	function Win_Close(Win) {
		Ext.TaskMgr.stopAll();
		RecordObj.CRMClose();
		RecordObj = null;
	}
}

function CreateMainWindow() {
	panel = new Ext.Window({
				region : 'center',
				layout : 'form',
				items : [{
							xtype : 'textfield',
							fieldLabel : '就诊卡号',
							emptyText : '请输入就诊卡号...',
							enableKeyEvents : true
						}, {
							xtype : 'textfield',
							disabled : true,
							fieldLabel : '姓名'
						}, {
							xtype : 'textfield',
							disabled : true,
							fieldLabel : '证件号码'
						}],
				buttons : [{
							id : 'DCButton',
							text : '进入调查',
							handler : DC_Click
						}],
				width : 250,
				height : 150,
				closable : false
			})
	panel.items.item(0).on('change', RegNo_Change);
	panel.items.item(0).on('keydown', RegNo_KeyDown);
	function RegNo_Change(obj, newValue, oldValue) {
		if (newValue == '') {
			PAPMIID = '';
			return false;
		}
		var RegNo = RegNoMask(newValue);
		var patientInfo = cspRunServerMethod(getPatientInfo, RegNo);
		var patienArr = patientInfo.split("^");
		PAPMIID = patienArr[0];
		if (PAPMIID == '') {
			Ext.Msg.alert("提醒", "请输入正确的就诊卡号");
			return false;
		}
		obj.setValue(patienArr[1]);
		panel.items.item(1).setValue(patienArr[2]);
		panel.items.item(2).setValue(patienArr[3]);
		Ext.Msg.alert("提醒", "请确认信息后点击'进入调查'按钮");
	}
	function RegNo_KeyDown(obj, e) {
		if (e.getKey() == e.ENTER) {
			RegNo_Change(obj, obj.getValue(), '');
		}
	}
	function DC_Click() {
		if (PAPMIID == '') {
			Ext.Msg.alert("提醒", "请输入正确的就诊卡号");
			return false;
		}
		panel.destroy();
		CreateMainPanel();
		View();
	}
}

function RegNoMask(RegNo) {
	var length = 10;
	var ZeroStr = '0000000000000000000'.substr(1, length);
	RegNo = ZeroStr.substr(1, length - RegNo.length) + RegNo;
	return RegNo;
}
