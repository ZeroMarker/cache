/**
 * FileName: dhcbill.conf.group.parasetting.js
 * Anchor: ZhYW
 * Date: 2019-10-23
 * Description: 参数设置
 */

$(function() {
	$("#btn-save").linkbutton({
		onClick: function() {
			saveClick();
		}
	});
	
	$("#btn-prtList").linkbutton({
		onClick: function() {
			prtListClick();
		}
	});
	
	$("#btn-prtList").popover({
		trigger: 'hover',
		content: '单据打印列表'
	});
	
	var options = {
		onText: '是',
		offText: '否',
		size: 'small',
		onClass: 'primary',
		offClass: 'gray',
		checked: false
	};
	$("#switch-footFlag, #switch-inv, #switch-regBillFlag, #switch-cardPayMFlag, #switch-prtList").switchbox(options);
	$("#switch-abort, #switch-refund").switchbox(options);
	$("#switch-receiveFlag").switchbox(options);
	
	$.extend($("#switch-prtList").switchbox('options'), {
		onSwitchChange: function(e, obj) {
			$("#btn-prtList").linkbutton({disabled: !obj.value});
		}
	});
	
	//票据类型
	$HUI.combobox("#useINVType", {
		panelHeight: 150,
		url: $URL + "?ClassName=BILL.CFG.COM.GroupAuth&QueryName=InitListObjectValue&ResultSetType=array&ClsName=User.DHCOPGroupSettings&PropName=GSUseINVType",
		method: 'GET',
		valueField: 'ValueList',
		textField: 'DisplayValue'
	});

	if (+GV.GSCfgJson.ID > 0) {
		$("#switch-footFlag").switchbox("setValue", (GV.GSCfgJson.GSFootFlag == "Y"));     //是否有结算权限
		$("#switch-inv").switchbox("setValue", (GV.GSCfgJson.GSPrtINVFlag == "Y"));          //结算是否打印发票
		setValueById("prtXMLName", GV.GSCfgJson.GSPrtXMLName);                              //单据打印模板名称
		setValueById("useINVType", GV.GSCfgJson.GSUseINVType);                              //票据类型
		$("#switch-prtList").switchbox("setValue", (GV.GSCfgJson.GSPrtListFlag == "Y"));     //是否打印单据列表
		if (GV.GSCfgJson.GSPrtListFlag == "Y") {
			enableById("btn-prtList");
		}
		$("#switch-cardPayMFlag").switchbox("setValue", (GV.GSCfgJson.GSCardPayModeFlag == "1"));     //卡支付是否弹出收费界面
		$("#switch-regBillFlag").switchbox("setValue", (GV.GSCfgJson.GSRegBillFlag == "1"));      //挂号医嘱跟收费医嘱一起结算
		
		//集中打印发票设置
		setValueById("colPrtXMLName", GV.GSCfgJson.GSColPrtXMLName);                                //集中打印发票模板
		
		//门诊退费设置
		$("#switch-abort").switchbox("setValue", (GV.GSCfgJson.GSAbortFlag == "Y"));              //是否有作废权限
		$("#switch-refund").switchbox("setValue", (GV.GSCfgJson.GSRefundFlag == "Y"));             //是否有红冲权限
		
		//日结设置
		$("#switch-receiveFlag").switchbox("setValue", (GV.GSCfgJson.GSReceiveFlag == "1"));       //是否需要接收
	}
});

/**
* 单据打印列表
*/
function prtListClick() {
	var url = "dhcbill.conf.group.prttasklist.csp?&GroupId=" + GV.GroupId + "&HospId=" + GV.HospId + "&TaskType=CP";
	websys_showModal({
		url: url,
		title: '单据打印列表',
		iconCls: 'icon-w-list',
		width: '75%'
	});
}

/**
* 保存
*/
function saveClick() {
	var myChargeFlag = $("#switch-footFlag").switchbox("getValue") ? "Y" : "N";
	var myPrtINVFlag = $("#switch-inv").switchbox("getValue") ? "Y" : "N";
	var myPrtListFlag = $("#switch-prtList").switchbox("getValue") ? "Y" : "N";
	var myColPrtListFlag = "N";
	var myUseINVType = getValueById("useINVType") || "";
	var myInputOrdFlag = "";
	var myCardPayMFlag = $("#switch-cardPayMFlag").switchbox("getValue") ? 1 : 0;
	var myRegBillFlag = $("#switch-regBillFlag").switchbox("getValue") ? 1 : 0;
	var myPrtXMLName = getValueById("prtXMLName");
	var myColPrtXMLName = getValueById("colPrtXMLName");
	var myAbortFlag = $("#switch-abort").switchbox("getValue") ? "Y" : "N";
	var myRefundFlag = $("#switch-refund").switchbox("getValue") ? "Y" : "N";
	var myReceiveFlag= $("#switch-receiveFlag").switchbox("getValue") ? 1 : 0;
	
	var myGSStr = myChargeFlag + "^" + myPrtINVFlag + "^" + myAbortFlag + "^" + myRefundFlag;
	myGSStr += "^" + myPrtXMLName + "^" + myColPrtXMLName + "^" + myUseINVType + "^" + myInputOrdFlag;
	myGSStr += "^" + myPrtListFlag + "^" + myColPrtListFlag + "^" + myCardPayMFlag + "^" + myReceiveFlag;
	myGSStr += "^" + myRegBillFlag;
	
	$.m({
		ClassName: "BILL.CFG.COM.GroupAuth",
		MethodName: "UpdateGS",
		groupId: GV.GroupId,
		hospId: GV.HospId,
		gsStr: myGSStr
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] == "0") {
			$.messager.popover({msg: "保存成功", type: "success"});
		}else {
			$.messager.popover({msg: "保存失败：" + myAry[0], type: "error"});
		}
	});
}