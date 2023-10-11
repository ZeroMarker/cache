/*
 * @Descripttion: 护理病历业务界面常用的方法
 * @Author: yaojining
 */

/**
* @description 展示病人标题信息
* @param {EpisodeID} 患者就诊号 
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
			$('.PatInfoItem').html('<div style="left:0 !important;"><p style="font-size:14px;">' + $g('请选择患者就诊记录！') + '</p><div>');
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
				$('.PatInfoItem').html($g('获取病人信息失败。请检查【患者信息展示】配置。'));
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
 * @description: 启动升级
 */
function updateEmr(callBackFun) {
	updateLoadingWords($g('正在检查版本并升级护理病历程序...'));
	$m({
		ClassName: 'NurMp.Service.Editor.Update',
		MethodName: 'updateEmr'
	}, callBackFun);
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
function getServerDateTime(format) {
	var dateTime = $cm({
		ClassName: 'NurMp.Common.Tools.Utils',
		MethodName: 'GetServerDateTime',
		Format: format
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

/**
 * @description: 重建csp名称
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
 * @description: 更新病人基本信息条
 */
function updatePatBanner() {
	setPatientInfo(EpisodeID);
}

/**
 * @description: 更新进度条提示
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
 * @description: 判断是否加载完成所有模块
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
 * @description: 关闭进度提示
 */
function closeLoading() {
	if ($('#loading').length > 0) {
		$('#loading').hide();
	}
}

/**
 * @description: 获取当前步骤对照
 * @param {string} step
 * @return {strign} step描述
 */
function currentStep(step) {
	switch(step) {
		case 'banner' : return $g('患者基本信息初始化完成...'); break;
		case 'patlist' : return $g('患者列表准备完成...'); break; 
		case 'templist' : return $g('模板列表准备完成...'); break; 
		case 'recordtab' : return $g('病历表单页签初始化完成...'); break;
		case 'dialog' : return $g('引用模块初始化完成...'); break;
		default: return ''; break;
	};
}

/**
 * @description: 更新进度条提示
 * @param {string} part
 */
function updateStep(step) {
	updateLoadingWords(step);
	if (isLoadComplete()) {
		closeLoading();
	}
}

/**
 * @description: 超融合改造
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
