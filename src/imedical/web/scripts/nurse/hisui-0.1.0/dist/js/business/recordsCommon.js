/**
* @description չʾ���˱�����Ϣ
* @param {EpisodeID} ���߾���� 
*/
function setPatientInfo(EpisodeID) {
	if ((!EpisodeID) || (EpisodeID == 'undefined')) {
		$(".PatInfoItem").html('��ѡ���ˣ�');
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
			$(".PatInfoItem").html("��ȡ������Ϣʧ�ܡ����顾������Ϣչʾ�����á�");
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
* @description ��������
*/
function updateEmr(callbackFun) {
	$m({
		ClassName: 'NurMp.Service.Editor.Update',
		MethodName: 'getStatus',
	}, function (isUpdated) {
		if (isUpdated == 0) {
			$.messager.progress({
				title: "��ʾ",
				msg: '���ڸ�����س������Ժ�...',
				text: '������....'
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
* @description ��ͷ�˵����ݲ�����Ϣ
*/
function passPatientToMenu(node) {
	var frm = dhcsys_getmenuform();
	// 8.5������˹涨����Ҫȥ���ڷ���Ҫ�����л�������ͷ�˵����ݾ�����Ϣ�Ĺ��ܣ�������ҽ���������¼��ҽ��ʱ����Ϣ�ķ��ա�
	// �����޸�PassToMenuFlagĬ��ֵ��PassToMenuFlag-1:���ݣ���1:�����ݣ�Ĭ�ϲ����ݡ�
	if ((frm) && (PassToMenuFlag == 1)) {
		frm.EpisodeID.value = node.episodeID;
		frm.PatientID.value = node.patientID;
	}
}
/**
* @description ���url
* @param {url} ģ�����ӵ�ַ
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
* @description  �б���չ�Զ���չ���
* @param {flag} ������չ��־ 
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
 * @description: ��ȡ��־������Ϣ
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
 * @description: ��ȡ��Ժʱ��
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
 * @description: ��ȡ������ʱ��
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
 * @description: �жϾ�����Ƿ���Ч
 */
 function isValidAdm(episodeID) {
	if ((!episodeID) || (episodeID == 'undefined')) {
		return false;
	}
	return true;
}