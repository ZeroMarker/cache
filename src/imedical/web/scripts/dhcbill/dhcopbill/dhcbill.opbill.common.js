/**
 * FileName: dhcbill.opbill.common.js
 * Anchor: ZhYW
 */
 
/**
 * Creator: ZhYW
 * CreatDate: 2017-12-19
 * Description: 门诊收费结算失败提示
 */
function chargeErrorTip(flag, errCode, job) {
	var errMsg = "";
	switch (flag) {
		case "preChargeError":
			errMsg = "预结算失败 ";
			break;
		case "completeError":
			errMsg = "确认完成失败 ";
			break;
		case "refundError":
			errMsg = "退费失败 ";
			break;
		default:
	}
	switch (+errCode) {
		case 101:
			$.messager.confirm("确认", "门诊结算没有数据：" + errCode + "，是否查看明细？", function(r){
				if (r){
					var url = "dhcbill.opbill.charge.errAnalyze.csp?job=" + job;
					websys_showModal({
						url: url,
						title: "收费失败" + errCode + "分析",
						iconCls: "icon-w-list"
					});
				}
			});
			break;
		case 102:
			$.messager.confirm("确认", "患者的支付金额不符：" + errCode + "，是否查看明细？", function(r){
				if (r){
					var url = "dhcbill.opbill.charge.errAnalyze.csp?job=" + job;
					websys_showModal({
						url: url,
						title: "收费失败" + errCode + "分析",
						iconCls: "icon-w-list"
					});
				}
			});
			break;
		case 103:
			$.messager.alert("提示", "门诊收费重新生成账单错误：" + errCode, "error");
			break;
		case 104:
			$.messager.alert("提示", "门诊收费取配置信息有误：" + errCode, "error");
			break;
		case 105:
			$.messager.alert("提示", "门诊收费支付方式输入为空：" + errCode, "error");
			break;
		case 107:
			$.messager.alert("提示", "门诊收费院内账户不存在：" + errCode, "error");
			break;
		case 109:
			$.messager.alert("提示", "门诊收费员没有可用票据：" + errCode, "error");
			break;
		case 110:
			$.messager.alert("提示", "发药科室为空，请检查医嘱接收科室或发药窗口：" + errCode, "error");
			break;
		case 112:
			$.messager.alert("提示", "门诊收费四舍五入舍入金额过大，请分批结算：" + errCode, "error");
			break;
		case 113:
			$.messager.alert("提示", "门诊收费院内账户与患者身份不符：" + errCode, "error");
			break;
		case 114:
			$.messager.alert("提示", "医嘱被执行，不能退费：" + errCode, "error");
			break;
		case 120:
			$.messager.alert("提示", "门诊收费有异常收费记录需要处理：" + errCode, "error");
			break;
		case 123:
			$.messager.alert("提示", "门诊收费欠费结算异常：" + errCode, "error");
			break;
		case 125:
			$.messager.alert("提示", "账户余额不足：" + errCode, "error");
			break;
		case 129:
			$.messager.alert("提示", "门诊收费减材料库存失败：" + errCode, "error");
			break;
		case 130:
			$.messager.alert("提示", "请选择全部的挂号相关费用进行结算：" + errCode, "error");
			break;
		case 131:
			$.messager.alert("提示", "门诊收费患者结算需要附加条件：" + errCode, "error");
			break;
		case 132:
			$.messager.alert("提示", "门诊收费同一个处方被拆分：" + errCode, "error");
			break;
		case 133:
			$.messager.alert("提示", "门诊收费账单表金额不平：" + errCode, "error");
			break;
		case 134:
			$.messager.alert("提示", "门诊收费发票表与账单表金额不平：" + errCode, "error");
			break;
		case 135:
			$.messager.alert("提示", "门诊收费发票表自负金额与支付方式金额不平：" + errCode, "error");
			break;
		default:
			$.messager.alert("提示", errMsg + ": " + errCode, "error");
	}
}

/**
 * 刷新患者信息条
 */
function refreshBar(papmi, adm) {
	$.m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: adm,
		PatientID: papmi
	}, function (html) {
		if (html != "") {
			$(".PatInfoItem").html(reservedToHtml(html));
		} else {
			$(".PatInfoItem").html("获取患者信息失败，请检查【患者信息展示】配置。");
		}
	});
}

function reservedToHtml(str) {
	var replacements = {
		"&lt;": "<",
		"&#60;": "<",
		"&gt;": ">",
		"&#62;": ">",
		"&quot;": "\"",
		"&#34;": "\"",
		"&apos;": "'",
		"&#39;": "'",
		"&amp;": "&",
		"&#38;": "&"
	};
	return str.replace(/(&lt;)|(&gt;)|(&quot;)|(&apos;)|(&amp;)|(&#60;)|(&#62;)|(&#34;)|(&#39;)|(&#38;)/g, function (v) {
		return replacements[v];
	});
}

/**
* banner提示信息
*/
function showBannerTip() {
	$(".PatInfoItem").html("<div class='unman'></div><div class='tip-txt'>请先查询患者</div>");
}
	
function getSessionPara() {
	var mystr = "";
	mystr += "^";			//IP
	mystr += session['LOGON.USERID'] + "^";
	mystr += session['LOGON.CTLOCID'] + "^";
	mystr += session['LOGON.GROUPID'] + "^";
	mystr += "^";
	mystr += session['LOGON.SITECODE'] + "^";
	
	return mystr;
}
