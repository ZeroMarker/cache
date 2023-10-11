/**
 * FileName: dhcbill.opbill.common.js
 * Author: ZhYW
 */

/**
 * Creator: ZhYW
 * CreatDate: 2017-12-19
 * Description: 门诊收费结算失败提示
 */
function chargeErrorTip(flag, rtnValue) {
	var rtnAry = rtnValue.split(String.fromCharCode(3));
	var errAry = rtnAry[0].split("^");   //错误代码^失败消息
	var pid = rtnAry[1] || "";
	
	var msg = "";
	switch (flag) {
	case "preChargeError":
		msg = $g("预结算失败: ");
		break;
	case "completeError":
		msg = $g("确认完成失败: ");
		break;
	case "refundError":
		msg = $g("退费失败: ");
		break;
	case "restoreError":
		msg = $g("欠费补回失败: ");
		break;
	default:
	}
	msg += $g(String(errAry.slice(1)) || errAry[0]);
	
	if ((pid > 0) && ($.inArray(errAry[0], ["101", "102"]) != -1)) {
		$.messager.confirm("确认", (msg + ("，是否查看明细？")), function(r) {
			if (!r){
				return;
			}
			var url = "dhcbill.opbill.charge.errAnalyze.csp?job=" + pid;
			websys_showModal({
				url: url,
				title: $g("收费失败") + errAry[0] + $g("分析"),
				iconCls: "icon-w-list"
			});
		});
		return;
	}
	$.messager.alert("提示", msg, "error");
}

/**
 * 刷新患者信息条
 */
function refreshBar(patientId, episodeId) {
	if(typeof InitPatInfoBanner == "function") {
		return InitPatInfoBanner(episodeId, patientId);
	}
	//兼容9.0以前的老项目
	$.m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: episodeId,
		PatientID: patientId
	}, function (html) {
		if (html != "") {
			$(".patientbar").data("patinfo", html);
            if ("function" == typeof initPatInfoHover) {
                initPatInfoHover();
            } else {
                $(".PatInfoItem").html(reservedToHtml(html));
            }
            $(".PatInfoItem").find("img").eq(0).css("top", 0);
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
* 重写dhcdoc.patinfo.banner.csp中的showPatListWin()
*/
function showPatListWin() {
    if(!$("#PatListWin").length) {
	    return;
    }
	var bodyHeight = $("body").innerHeight();
	var bodyWidth = $("body").innerWidth();
    var winHeight = bodyHeight - 50;
    var winWidth = ((bodyWidth - 10) > 1200) ? 1200 : bodyWidth;
    $("#PatListWin").window({
        maximizable: false,
        closable: true,
        width: winWidth,
        height: winHeight,
        isTopZindex: true
    }).window("open").window("move", {top: 40, left: (bodyWidth - winWidth - 10)});
}

/**
* banner提示信息
*/
function showBannerTip() {
	$(".pat-info-container").html("<div style=\"background:url(" + ("../images/" + ((HISUIStyleCode == "lite") ? "unman_lite.png" : "unman.png")) + ") no-repeat;background-size:cover;position:absolute;left:10px;width:30px;height:30px;border-radius:30px;margin-top:5px;\"></div><div style=\"margin-left:45px;color:#666666;\">" + $g("请先查询患者") + "</div>");
	$(".pat-info-over").remove();
}

/**
* 清除banner信息
*/
function clearBanner() {
	$(".pat-info-container").empty().popover("destroy");
	$(".pat-info-over").remove();
}

function getSessionPara() {
	var myStr = "";
	myStr += "^";			//IP
	myStr += session['LOGON.USERID'] + "^";
	myStr += session['LOGON.CTLOCID'] + "^";
	myStr += session['LOGON.GROUPID'] + "^";
	myStr += "^";
	myStr += session['LOGON.SITECODE'] + "^";
	
	return myStr;
}

/**
* ZhYW
* 2023-02-08
* 获取门诊预交金账户ID
*/
function getPatAccMRowId(cardNo, cardTypeId, patientId) {
	return $.m({ClassName: "web.UDHCAccManageCLS", MethodName: "GetPatAccMRowID", cardNo: cardNo, cardTypeId: cardTypeId, patientId: patientId, hospId: session['LOGON.HOSPID']}, false);
}