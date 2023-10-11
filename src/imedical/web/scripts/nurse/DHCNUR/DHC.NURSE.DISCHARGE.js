/*
 * author pengjunfu 2015-11-10
 * 新出院
 */

var BaseInfoLayOutInit = function() {

	Ext.QuickTips.init();

	Ext.BLANK_IMAGE_URL = '../scripts/ext/resources/images/default/s.gif';

	var EstimDischargeDate = new Ext.form.TextField({
		id: 'EstimDischargeDate',
		name: 'EstimDischargeDate',
		fieldLabel: '预计出院日期',
		disabled: true,
		width: 100
	});
	var EstimDischargeTime = new Ext.form.TextField({
		id: 'EstimDischargeTime',
		name: 'EstimDischargeTime',
		fieldLabel: '预计出院时间',
		disabled: true,
		width: 100
	});
	// var DischgDate = new Ext.form.TextField({
	// 	id: 'DischgDate',
	// 	name: 'DischgDate',
	// 	fieldLabel: '操作日期',
	// 	disabled: true,
	// 	width: 100
	// });
	// var DischgTime = new Ext.form.TextField({
	// 	id: 'DischgTime',
	// 	name: 'DischgTime',
	// 	fieldLabel: '操作时间',
	// 	disabled: true,
	// 	width: 100
	// });
	var PatInfo = new Ext.form.TextField({
		id: 'PatInfo',
		name: 'PatInfo',
		fieldLabel: '病人',
		disabled: true,
		width: 100
	});
	var PatRegNo = new Ext.form.TextField({
		id: 'PatRegNo',
		name: 'PatRegNo',
		fieldLabel: '登记号',
		disabled: true,
		width: 100
	});
	var PatAdminDateTime = new Ext.form.TextField({
		id: 'PatAdminDateTime',
		name: 'PatAdminDateTime',
		fieldLabel: '入院时间',
		disabled: true,
		width: 100
	});

	var EstimDischargeDoctor = new Ext.form.TextField({
		id: 'EstimDischargeDoctor',
		name: 'EstimDischargeDoctor',
		fieldLabel: '操作医生',
		disabled: true,
		width: 100
	});
	var DeceasedDate = new Ext.form.TextField({
		id: 'DeceasedDate',
		name: 'DeceasedDate',
		fieldLabel: '死亡日期',
		disabled: true,
		width: 100
	});
	var DeceasedTime = new Ext.form.TextField({
		id: 'DeceasedTime',
		name: 'DeceasedTime',
		fieldLabel: '死亡时间',
		disabled: true,
		width: 100
	});

	var DischCond = new Ext.form.TextField({
		id: 'DischCond',
		name: 'DischCond',
		fieldLabel: '出院条件',
		disabled: true,
		width: 100
	});
	var DischgDate = new Ext.form.TextField({
		id: 'DischgDate',
		name: 'DischgDate',
		fieldLabel: '出院日期',
		disabled: true,
		width: 100
	});
	var DischgTime = new Ext.form.TextField({
		id: 'DischgTime',
		name: 'DischgTime',
		fieldLabel: '出院时间',
		disabled: true,
		width: 100
	});

	var DischNurse = new Ext.form.TextField({
		id: 'DischNurse',
		name: 'DischNurse',
		fieldLabel: '操作护士',
		disabled: true,
		width: 100
	});


	var UserCode = new Ext.form.TextField({
		id: 'UserCode',
		name: 'UserCode',
		fieldLabel: '用户名',
		width: 100
	});

	var UserPassword = new Ext.form.TextField({
		id: 'UserPassword',
		name: 'UserPassword',
		inputType : 'password',
		fieldLabel: '密码',
		width: 100
	});



	var UpdateBtn = new Ext.Button({
		text: "更新",
		id: "Update",
		width: 110,
		icon:'../images/uiimages/filesave.png',
		style:"margin:0 0 0 80px"
	})



	var BaseInfoForm = new Ext.form.FormPanel({
		frame: true,
		width: 800,

		labelAlign: 'right',
		autoScroll: true,
		items: [{
			xtype: 'fieldset',
			title: '医生',
			autoHeight: true,
			items: [{
				layout: 'column',
				items: [{
					layout: 'form',
					columnWidth: .33,
					items: [EstimDischargeDate]
				}, {
					layout: 'form',
					columnWidth: .33,
					items: [DeceasedDate]
				}, {
					layout: 'form',
					columnWidth: .33,
					items: [PatInfo]
				}]
			}, {
				layout: 'column',
				items: [{
					layout: 'form',
					columnWidth: .33,
					items: [EstimDischargeTime]
				}, {
					layout: 'form',
					columnWidth: .33,
					items: [DeceasedTime]
				},{
					layout: 'form',
					columnWidth: .33,
					items: [PatRegNo]
					 
				}]
			}, {
				layout: 'column',
				items: [{
					layout: 'form',
					columnWidth: .33,
					items: [DischCond]
				}, {
					layout: 'form',
					columnWidth: .33,
					items: [EstimDischargeDoctor]
				},{
					layout: 'form',
					columnWidth: .33,
					items: [PatAdminDateTime]
					
				}]
			}]
		}, {
			xtype: 'fieldset',
			title: '护士',
			items: [{
				layout: 'column',
				items: [{
					layout: 'form',
					columnWidth: .33,
					items: [DischgDate]
				}, {
					layout: 'form',
					columnWidth: .33,
					items: [DischgTime]
				}, {
					layout: 'form',
					columnWidth: .33,
					items: [DischNurse]
				}]

			}]
		}, {
			xtype: 'fieldset',
			title: '更新',
			items: [{
				layout: 'column',
				items: [{
					layout: 'form',
					columnWidth: .33,
					items: [UserCode]
				}, {
					layout: 'form',
					columnWidth: .33,
					items: [UserPassword]
				}, {
					layout: 'form',
					columnWidth: .33,
					items: [UpdateBtn]
				}]
			}]
		}]
	});


	var panel = new Ext.Panel({
		layout: {
			type: 'vbox',
			pack: 'center',
			align: 'center'
		},
		id: "panel",
		items: [BaseInfoForm]
	});
	var viewPort = new Ext.Viewport({
		layout: "fit",
		id: "viewPort",
		defaults: {
			border: true,
			frame: true,
			bodyBorder: true
		},
		items: [panel]
	});
};
var BaseInfoInitValue = function() {

	var baseInfoStr = tkMakeServerCall("web.DHCDischargeHistory", "GetDischargeInfo", EpisodeID);
	var baseInfoArray = baseInfoStr.split("^");
	Ext.getCmp("EstimDischargeDate").setValue(baseInfoArray[0]);
	Ext.getCmp("EstimDischargeTime").setValue(baseInfoArray[1]);
	Ext.getCmp("DischgDate").setValue(baseInfoArray[2]);
	Ext.getCmp("DischgTime").setValue(baseInfoArray[3]);
	Ext.getCmp("EstimDischargeDoctor").setValue(baseInfoArray[4]);
	Ext.getCmp("DischNurse").setValue(baseInfoArray[5]);
	Ext.getCmp("DeceasedDate").setValue(baseInfoArray[6]);
	Ext.getCmp("DeceasedTime").setValue(baseInfoArray[7]);
	Ext.getCmp("DischCond").setValue(baseInfoArray[8]);

	Ext.getCmp("UserCode").setValue(session['LOGON.USERCODE']);

	var info = tkMakeServerCall("web.DHCNurIpComm", "NurPatInfo", EpisodeID);
	Ext.getCmp("PatInfo").setValue(info.split("^")[0]);
	Ext.getCmp("PatRegNo").setValue(info.split("^")[4]);
	Ext.getCmp("PatAdminDateTime").setValue(info.split("^")[5]);

	//UserPassword
	var UpdateBtn = Ext.getCmp("Update");


	while (true) {
		//护士召回
		if (type == "R") {
			GetInsuUpFlagByAdm();
			UpdateBtn.setText("召回");
			UpdateBtn.on("click", function(button, e) {
				var ret = ConfirmPassWord();
				if (ret.indexOf("^") > -1) {
					var userId = ret.split("^")[1];
					RecallPatient(userId)
				} else {
					Ext.Msg.alert("提示", ret);
				};
			})
			break;
		};
		//护士办理出院
		if (type == "F") {
			Ext.getCmp("DischgDate").enable();
			Ext.getCmp("DischgTime").enable();
			AlertAbnormalOrder();
			checkBabyByMother();
			UpdateBtn.setText("出院");
			UpdateBtn.on("click", function(button, e) {
				var ret = ConfirmPassWord();
				if (ret.indexOf("^") > -1) {
					var userId = ret.split("^")[1];
					NurseDischarge(userId)
				} else {
					Ext.Msg.alert("提示", ret);
				};
			})
			break;
		};
		//护士终止费用调整
		if (type == "T") {
			AlertAbnormalOrder();
			UpdateBtn.setText("结束费用调整");
			UpdateBtn.on("click", function(button, e) {
				var ret = ConfirmPassWord();
				if (ret.indexOf("^") > -1) {
					var userId = ret.split("^")[1];
					TerminalRecallPatientForBill(userId)
				} else {
					Ext.Msg.alert("提示", ret);
				};
			})
			break;
		};
		//护士费用调整
		if (type == "B") {

			GetInsuUpFlagByAdm();
			UpdateBtn.setText("费用调整");
			UpdateBtn.on("click", function(button, e) {
				var ret = ConfirmPassWord();
				if (ret.indexOf("^") > -1) {
					var userId = ret.split("^")[1];
					RecallPatientForBill(userId)
				} else {
					Ext.Msg.alert("提示", ret);
				};
			})
			break;
		};
		Ext.getCmp("Update").hide();
		break;
	}

};

var Refresh=function(){
	if(window.opener){
			//window.opener.location.reload();
			if(window.opener.parent.window.frames['TRAK_main']){
				window.opener.parent.window.frames['TRAK_main'].location.reload();
			}else{
				window.opener.location.reload();
			}
			window.close();
		}else{
			var lnk = "epr.default.csp";
			window.location = lnk;
		}
}
var RecallPatient = function(userId) {
	var coderet = tkMakeServerCall("web.DHCBillInterface","IGetCodingFlag",EpisodeID);
	if(coderet!="N"){
		Ext.Msg.alert("提示", "财务已经审核，请撤销后召回!");
		return ;
	}

	var ret = tkMakeServerCall("web.DHCDischargeHistory", "RecallPatient", EpisodeID, userId);
	if (ret != "0") {
		Ext.Msg.alert("提示", ret);
	} else {
		Ext.Msg.alert("提示", "操作成功!");
		Refresh()
	}
};
var NurseDischarge = function(userId) {
	var date = Ext.getCmp("DischgDate").getRawValue();
	var time = Ext.getCmp("DischgTime").getRawValue();
	var ret = tkMakeServerCall("web.DHCDischargeHistory", "NurseDischarge", EpisodeID, userId, date, time);
	if (ret != "0") {
		Ext.Msg.alert("提示", ret);
	} else {
		Ext.Msg.alert("提示", "操作成功!");
		Refresh()
		
		
	}
};
var RecallPatientForBill = function(userId) {
	var ret = tkMakeServerCall("web.DHCDischargeHistory", "RecallPatientForBill", EpisodeID, userId);
	if (ret != "0") {
		Ext.Msg.alert("提示", ret);
	} else {
		Ext.Msg.alert("提示", "操作成功!");
		Refresh()
	}
};

var TerminalRecallPatientForBill = function(userId) {

	var ret = tkMakeServerCall("web.DHCDischargeHistory", "TerminalRecallPatientForBill", EpisodeID, userId);
	if (ret != "0") {
		Ext.Msg.alert("提示", ret);
	} else {
		Ext.Msg.alert("提示", "操作成功!");
		Refresh()
	}
};

var ConfirmPassWord = function() {
	var UserCode = Ext.getCmp("UserCode").getValue();
	var UserPassword = Ext.getCmp("UserPassword").getValue();
	var ret = tkMakeServerCall("web.DHCLCNUREXCUTE", "ConfirmPassWord", UserCode, UserPassword);
	return ret;
};

var GetInsuUpFlagByAdm = function() {
	var retStr = tkMakeServerCall("web.DHCINSUPort", "GetInsuUpFlagByAdm", EpisodeID, "")
	if (retStr > 0) {
		Ext.Msg.alert("提示", "医保已经结算或上传,不能办理该操作");
		Ext.getCmp("Update").hide();
	};
}
var checkBabyByMother=function(){
	var ifBabyBillAM = tkMakeServerCall("Nur.DHCADTDischarge", "getBabyBillConf");
	if(ifBabyBillAM=="Y"){
		var ret = tkMakeServerCall("Nur.DHCADTDischarge", "checkBabyByMother", EpisodeID);
		if(ret!=0){
			Ext.Msg.alert("提示", "其婴儿："+ret);
			Ext.getCmp("Update").hide();
			return;
		}
	}
}
var AlertAbnormalOrder = function() {
	var retStr = tkMakeServerCall("web.DHCDischargeHistory", "nurSettlementCheck", EpisodeID)
	if (retStr != 0) {
		Ext.Msg.alert("提示", "患者住院费用核查未通过,原因:"+retStr);
		Ext.getCmp("Update").hide();
		return;
	}
	retStr = tkMakeServerCall("web.DHCCAbFeeCheck", "GetCheckFeeFinal", EpisodeID, "")
	if (retStr != "") {
		Ext.Msg.alert("提示", retStr);
		Ext.getCmp("Update").hide();
		return;

	}
	var retStr = tkMakeServerCall("Nur.DHCADTDischarge", "getUnExcuteConsult", EpisodeID)
	if (retStr != 0) {
		Ext.Msg.alert("提示", "该病人有"+retStr+"的会诊没执行,请先执行");
		Ext.getCmp("Update").hide();
		return;

	}
	retStr = tkMakeServerCall("Nur.DHCADTDischarge", "getAbnormalOrder", EpisodeID, "Disch")
	if (retStr == "") {
		return;
	}
	var retStrArrat = retStr.split("^");
	var ifCanTrans = retStrArrat[0];
	if (ifCanTrans != "Y" && retStrArrat.length > 1) {
		Ext.getCmp("Update").hide();
	}
	for (var i = 1; i < retStrArrat.length; i++) {
		var alertStr = retStrArrat[i];
		alert(alertStr);
	}
}
Ext.onReady(function() {
	BaseInfoLayOutInit();
	BaseInfoInitValue()

});