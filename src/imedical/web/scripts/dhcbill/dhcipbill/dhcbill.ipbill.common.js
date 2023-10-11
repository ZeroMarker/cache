/**
 * FileName: dhcbill.ipbill.common.js
 * Anchor: ZhYW
 */
 
/**
 * 刷新患者信息条
 */
function refreshBar(patientId, episodeId) {
	if(typeof InitPatInfoBanner == "function") {
		return InitPatInfoBanner(episodeId, patientId);
	}
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