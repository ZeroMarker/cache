/**
* @description 展示病人标题信息
* @param {EpisodeID} 患者就诊号 
*/
function setPatientInfo(EpisodeID) {
	if ((!EpisodeID) || (EpisodeID == 'undefined')) {
		$(".PatInfoItem").html('请选择病人！');
		return;
	}
	$m({
		ClassName: "web.DHCDoc.OP.AjaxInterface",
		MethodName: "GetOPInfoBar",
		CONTEXT: "",
		EpisodeID: EpisodeID
	}, function (html) {
		if (html != "") {
			$(".patientbar").data("patinfo", html);
			if ("function" == typeof InitPatInfoHover) {
				InitPatInfoHover();
			} else {
				$(".PatInfoItem").html(reservedToHtml(html));
			}
			$(".PatInfoItem").find("img").eq(0).css("top", 0);
		} else {
			$(".PatInfoItem").html("获取病人信息失败。请检查【患者信息展示】配置。");
		}
	});
}
function InitPatInfoHover() {
	var btnsWidth = 50;
	if (patientListPage != "") btnsWidth = 150;
	var html = $(".patientbar").data("patinfo");
	$(".PatInfoItem").html(reservedToHtml(html)).css({ height: 30, overflow: 'hidden', paddingRight: 10 });
	$(".PatInfoItem").css('width', $(".patientbar").width() - btnsWidth);
	$(".PatInfoItem").popover('destroy');
	setTimeout(function () {
		var html = $(".patientbar").data("patinfo");
		if (($(".PatInfoItem")[0].offsetHeight + 13) < $(".PatInfoItem")[0].scrollHeight) {
			$(".PatInfoItem").popover({
				width: $(".PatInfoItem").width() + 16, trigger: 'hover',
				arrow: false, style: 'patinfo',
				content: "<div class='patinfo-hover-content'>" + reservedToHtml(html) + "</div>"
			});
			$(".PatInfoItem").append('<div style="position:absolute;top:0px;right:0px;">...</div>')
		}
	}, 500);
};
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
* @description 升级程序
*/
function updateEmr(callbackFun) {
	$m({
		ClassName: 'NurMp.Service.Editor.Update',
		MethodName: 'getStatus',
	}, function (isUpdated) {
		if (isUpdated == 0) {
			$.messager.progress({
				title: "提示",
				msg: '正在更新相关程序，请稍后...',
				text: '进行中....'
			});
			$m({
				ClassName: 'NurMp.Service.Editor.Update',
				MethodName: 'updateEmr',
				HospitalID: session['LOGON.HOSPID']
			}, function (result) {
				setTimeout(function () {
					$.messager.progress("close");
					if ($.type(callbackFun) === "function") {
						callbackFun();
					}
				}, 4000);
			});
		} else {
			callbackFun();
		}
	});
}
/**
* @description 往头菜单传递病人信息
*/
function passPatientToMenu(node) {
	var frm = dhcsys_getmenuform();
	// 8.5标版做了规定：需要去掉在非主要界面切换病人往头菜单传递就诊信息的功能，避免在医嘱管理界面录入医嘱时串信息的风险。
	// 所以修改PassToMenuFlag默认值，PassToMenuFlag-1:传递，非1:不传递，默认不传递。
	if ((frm) && (PassToMenuFlag == 1)) {
		frm.EpisodeID.value = node.episodeID;
		frm.PatientID.value = node.patientID;
	}
}
/**
* @description 拆解url
* @param {url} 模板链接地址
*/
function serilizeURL(url) {
	var rs = url.split("?")[1];
	var arr = rs.split("&");
	var json = {};
	json["csp"] = url.split("?")[0].split(".csp")[0];
	var arrCsp = json["csp"].split(".");
	json["emrcode"] = arrCsp[arrCsp.length - 1];
	for (var i = 0; i < arr.length; i++) {
		if (arr[i].indexOf("=") != -1) {
			json[arr[i].split("=")[0]] = arr[i].split("=")[1];
		}
		else {
			json[arr[i]] = "undefined";
		}
	}
	return json;
}
/**
* @description  列表收展自动扩展表格
* @param {flag} 收缩扩展标志 
*/
function autoResizeTable(flag) {
	var tabs = $('#recordTabs').tabs('tabs');
	for (var i = 0; i < tabs.length; i++) {
		var tab = tabs[i];
		var id = tab[0].children[0].id;
		var ifFunc = $.isFunction($('#' + id)[0].contentWindow.HisuiTableAutoAdaption);
		if (ifFunc) {
			$('#' + id)[0].contentWindow.HisuiTableAutoAdaption();
		}
	}
}
/**
 * @description: 获取日志辅助信息
 */
function getLogAuxiliaryInfo() {
	var logAuxiliaryInfo = {};
	logAuxiliaryInfo["LOGON.CTLOCID"] = session['LOGON.CTLOCID'];
	logAuxiliaryInfo["LOGON.WARDID"] = session['LOGON.WARDID'];
	logAuxiliaryInfo["LOGON.GROUPDESC"] = session['LOGON.GROUPDESC'];
	logAuxiliaryInfo["LOGON.USERID"] = session['LOGON.USERID'];
	logAuxiliaryInfo["LOGON.SSUSERLOGINID"] = session['LOGON.SSUSERLOGINID'];
	logAuxiliaryInfo["SubjectionTemplateGuid"] = $('#cbtreeModel').combobox('getValue');
	return JSON.stringify(logAuxiliaryInfo);
}
/**
 * @description: 获取入院时间
 * @param {episodeID} 
 * @return: inDate
 */
function getInHospDateTime(episodeID) {
	var inDate = $m({
		ClassName: 'NurMp.Common.Base.Patient',
		MethodName: 'GetInHospDateTime',
		EpisodeID: episodeID
	}, false);
	inDate = inDate.split(' ')[0];
	if (!inDate) {
		serverDateTime = getServerDateTime(episodeID);
		inDate = serverDateTime.date;
	}
	return inDate;
}
/**
 * @description: 获取服务器时间
 * @return: serverDateTime
 */
 function getServerDateTime(episodeID) {
	var dateTime = $cm({
		ClassName: 'NurMp.Common.Tools.Utils',
		MethodName: 'GetServerDateTime',
	}, false);
	return dateTime;
}
/**
 * @description: 判断就诊号是否有效
 */
 function isValidAdm(episodeID) {
	if ((!episodeID) || (episodeID == 'undefined')) {
		return false;
	}
	return true;
}