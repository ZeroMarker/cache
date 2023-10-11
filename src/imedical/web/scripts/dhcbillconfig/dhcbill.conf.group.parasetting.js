/**
 * FileName: dhcbill.conf.group.parasetting.js
 * Author: ZhYW
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
	$("div[id^='switch-']").switchbox(options);
	
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

	if (+CV.GSCfgJson.ID > 0) {
		$("#switch-footFlag").switchbox("setValue", (CV.GSCfgJson.GSFootFlag == "Y"));     //是否有结算权限
		$("#switch-inv").switchbox("setValue", (CV.GSCfgJson.GSPrtINVFlag == "Y"));          //结算是否打印发票
		setValueById("prtXMLName", CV.GSCfgJson.GSPrtXMLName);                              //单据打印模板名称
		setValueById("useINVType", CV.GSCfgJson.GSUseINVType);                              //票据类型
		$("#switch-prtList").switchbox("setValue", (CV.GSCfgJson.GSPrtListFlag == "Y"));     //是否打印单据列表
		if (CV.GSCfgJson.GSPrtListFlag == "Y") {
			enableById("btn-prtList");
		}
		$("#switch-cardPayMFlag").switchbox("setValue", (CV.GSCfgJson.GSCardPayModeFlag == 1));     //卡支付是否弹出收费界面
		$("#switch-regBillFlag").switchbox("setValue", (CV.GSCfgJson.GSRegBillFlag == 1));      //挂号医嘱跟收费医嘱一起结算
		
		$("#switch-eInv").switchbox("setValue", (CV.GSCfgJson.GSPrtEINVFlag == 1));           //结算是否打印电子发票
		
		//集中打印发票设置
		setValueById("colPrtXMLName", CV.GSCfgJson.GSColPrtXMLName);                                //集中打印发票模板
		
		//门诊退费设置
		$("#switch-abort").switchbox("setValue", (CV.GSCfgJson.GSAbortFlag == "Y"));              //是否有作废权限
		$("#switch-refund").switchbox("setValue", (CV.GSCfgJson.GSRefundFlag == "Y"));             //是否有红冲权限
		
		//日结设置
		$("#switch-receiveFlag").switchbox("setValue", (CV.GSCfgJson.GSReceiveFlag == 1));       //是否需要接收
	}
});

/**
* 单据打印列表
*/
function prtListClick() {
	var url = "dhcbill.conf.group.prttasklist.csp?&GroupId=" + CV.GroupId + "&HospId=" + CV.HospId + "&TaskType=CP";
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
	$.messager.confirm("确认", "确认保存？", function(r) {
		if (!r) {
			return;
		}
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
		var myPrtEINVFlag = $("#switch-eInv").switchbox("getValue") ? 1 : 0;
		
		var myGSStr = myChargeFlag + "^" + myPrtINVFlag + "^" + myAbortFlag + "^" + myRefundFlag;
		myGSStr += "^" + myPrtXMLName + "^" + myColPrtXMLName + "^" + myUseINVType + "^" + myInputOrdFlag;
		myGSStr += "^" + myPrtListFlag + "^" + myColPrtListFlag + "^" + myCardPayMFlag + "^" + myReceiveFlag;
		myGSStr += "^" + myRegBillFlag + "^" + myPrtEINVFlag;
		
		$.m({
			ClassName: "BILL.CFG.COM.GroupAuth",
			MethodName: "UpdateGS",
			groupId: CV.GroupId,
			hospId: CV.HospId,
			gsStr: myGSStr
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: "保存成功", type: "success"});
				return;
			}
			$.messager.popover({msg: "保存失败：" + (myAry[1] || myAry[0]), type: "error"});
		});
	});
}