/*
 * @Descripttion: ������ҵ����泣�õķ���
 * @Author: yaojining
 */

/**
* @description չʾ���˱�����Ϣ
* @param {EpisodeID} ���߾���� 
*/
function setPatientInfo(EpisodeID) {
	if (typeof InitPatInfoBanner == 'function') {
		InitPatInfoBanner(EpisodeID);
		updateStep('banner');
	} else {
		if ($('.PatInfoItem').length == 0) {
			if (typeof updateStep == 'function') {
				updateStep('banner');
			}
			return;
		}
		if ((!EpisodeID) || (EpisodeID == 'undefined')) {
			$('.PatInfoItem').html('<div style="left:0 !important;"><p style="font-size:14px;">' + $g('��ѡ���߾����¼��') + '</p><div>');
			if (typeof updateStep == 'function') {
				updateStep('banner');
			}
			return;
		}
		$m({
			ClassName: 'web.DHCDoc.OP.AjaxInterface',
			MethodName: 'GetOPInfoBar',
			CONTEXT: '',
			EpisodeID: EpisodeID
		}, function (html) {
			if (html != '') {
				$('.patientbar').data('patinfo', html);
				if ('function' == typeof InitPatInfoHover) {
					InitPatInfoHover();
				} else {
					$('.PatInfoItem').html(reservedToHtml(html));
				}
				$('.PatInfoItem').find('img').eq(0).css('top', 0);
			} else {
				$('.PatInfoItem').html($g('��ȡ������Ϣʧ�ܡ����顾������Ϣչʾ�����á�'));
			}
			if (typeof updateStep == 'function') {
				updateStep('banner');
			}
		});
	}
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
 * @description: ��������
 */
function updateEmr(callBackFun) {
	updateLoadingWords($g('���ڼ��汾����������������...'));
	$m({
		ClassName: 'NurMp.Service.Editor.Update',
		MethodName: 'updateEmr'
	}, callBackFun);
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
function getServerDateTime(format) {
	var dateTime = $cm({
		ClassName: 'NurMp.Common.Tools.Utils',
		MethodName: 'GetServerDateTime',
		Format: format
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

/**
 * @description: �ؽ�csp����
 * @param {string} cspName
 */
function buildCspName(cspName) {
    if ((cspName.toLowerCase().indexOf('nur.emr.') > -1) && (cspName.toLowerCase().indexOf('.csp') > -1)){
        return cspName.toLowerCase();
    }
    if (cspName.toLowerCase().indexOf('nur.emr.') < 0) {
        cspName = 'nur.emr.' + cspName.toLowerCase();
    }
    if (cspName.indexOf('.csp') < 0) {
        cspName = cspName.toLowerCase() + '.csp';
    }
    return cspName;
}

/**
 * @description: ���²��˻�����Ϣ��
 */
function updatePatBanner() {
	setPatientInfo(EpisodeID);
}

/**
 * @description: ���½�������ʾ
 * @param {string} step
 */
function updateLoadingWords(step) {
	if ((GV.Steps) && (GV.Steps.length > 0)) {
		// $.hisui.removeArrayItem(GV.Steps, step);
		var index = GV.Steps.indexOf(step);
		if (index > -1) {
			GV.Steps.splice(index, 1);
		}
	}
	if ($('#loading > .loading_words').length > 0) {
		$('#loading > .loading_words').text(currentStep(step));
	}
}

/**
 * @description: �ж��Ƿ�����������ģ��
 * @return {*}
 */
function isLoadComplete() {
	if (GV.Steps.length == 0) {
		return true;
	} else {
		return false;
	}
}

/**
 * @description: �رս�����ʾ
 */
function closeLoading() {
	if ($('#loading').length > 0) {
		$('#loading').hide();
	}
}

/**
 * @description: ��ȡ��ǰ�������
 * @param {string} step
 * @return {strign} step����
 */
function currentStep(step) {
	switch(step) {
		case 'banner' : return $g('���߻�����Ϣ��ʼ�����...'); break;
		case 'patlist' : return $g('�����б�׼�����...'); break; 
		case 'templist' : return $g('ģ���б�׼�����...'); break; 
		case 'recordtab' : return $g('������ҳǩ��ʼ�����...'); break;
		case 'dialog' : return $g('����ģ���ʼ�����...'); break;
		default: return ''; break;
	};
}

/**
 * @description: ���½�������ʾ
 * @param {string} part
 */
function updateStep(step) {
	updateLoadingWords(step);
	if (isLoadComplete()) {
		closeLoading();
	}
}

/**
 * @description: ���ںϸ���
 * @return {bool} true/false
 */
function extendScreenPatient() {
	if (typeof websys_emit == 'function') {
		if ((GV.PatNode) && (!!GV.PatNode.patientID)) {
			websys_emit("onSelectIPPatient",{ EpisodeID:EpisodeID, PatientID:GV.PatNode.patientID });
		} else {
			websys_emit("onSelectIPPatient",{ EpisodeID:EpisodeID });
		}
	}
}
