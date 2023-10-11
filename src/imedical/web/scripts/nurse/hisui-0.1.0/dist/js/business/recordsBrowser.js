/*
 * @author: yaojining
 * @discription: 护理病历图片浏览
 * @date: 2019-12-18
 */


var GV = {
	HospitalID: session['LOGON.HOSPID'],
	SwitchInfo: new Object(),
	ArrSort: new Object(),
	PatNode: new Object(),
	TempNodeState: new Object(),
	Steps: ['banner', 'patlist']
};

/**
* @description: 入口
*/
$(function () {
	if (typeof updateStyle == 'function') {
		updateStyle();
	}
	requestSwitch();
});

/**
 * @description: 获取开关配置数据
 */
function requestSwitch() {
	$cm({
		ClassName: 'NurMp.Service.Switch.Config',
		MethodName: 'GetSwitchValues',
		HospitalID: session['LOGON.HOSPID'],
		LocID: session['LOGON.CTLOCID'],
		GroupID: session['LOGON.GROUPID']
	}, function (switchInfo) {
		GV.SwitchInfo = switchInfo.Main;
		initLayout();
		if (typeof updatePatBanner == 'function') {
			updatePatBanner();
		} else {
			if (typeof updateStep == 'function') {
				updateStep('banner');
			}
		}
		if (typeof requestPatient == 'function') {
			requestPatient();
		} else {
			if (typeof updateStep == 'function') {
				updateStep('patlist');
			}
		}
		if (typeof initPicturedRecordsTree == 'function') {
			initPicturedRecordsTree();
		}
		listenEvents();
	});
}

/**
 * @description: 初始化布局
 */
function initLayout() {
	if ($('#patientTree').length > 0) {
		// 当选择了就诊记录后，进入界面自动收缩面板
		if ((GV.SwitchInfo.PatListExpandFlag == 'true') && (!!EpisodeID)) {
			setTimeout(function () {
				$('.main-layout').layout('collapse', 'west');
			}, 200);
		}
	}
}

/**
 * @description: 自定义数据装载
 * @param {*} data
 */
function beforeLoadData(data) {
	GV.ArrSort = data.ArrSort;
}

/**
 * @description: 自定义病人tree加载成功后的处理
 * @param {*} node
 * @param {*} data
 */
function customPatTreeLoadSuccess(node, data) {
	GV.PatNode = $('#patientTree').tree('getSelected');
}

/**
 * @description: 自定义点击病人列表事件
 * @param {object} node
 */
function customClickPatient(node) {
	GV.PatNode = node;
	if (typeof updatePatBanner == 'function') {
		updatePatBanner();
	}
	if (typeof refreshTempTree == 'function') {
		refreshTempTree();
	}
	// 当选择了就诊记录后，进入界面自动收缩面板
	if ((GV.SwitchInfo.PatListExpandFlag == 'true') && (!!EpisodeID)) {
		$('.main-layout').layout('collapse', 'west');
	}
	$('#imgBox').panel('setTitle', node.name);
	$HUI.tree('#picturedRecordsTree', 'reload');
	var iframe = document.getElementById('iframeContent');
	$(iframe).contents().find('body').html('');
}

/**
 * @description: 自定义模板tree加载成功后的处理
 * @param {*} node
 * @param {*} data
 */
function customTempTreeLoadSuccess(node, data) {
	var _this = this;
	if (!$.isEmptyObject(GV.TempNodeState)) {
		$.each(GV.TempNodeState, function (id, state) {
			var selRoot = $(_this).tree('find', id);
			if (selRoot) {
				if (state == 'open') {
					$(_this).tree('expand', selRoot.target);
				} else {
					$(_this).tree('collapse', selRoot.target);
				}
			}
		});
	}
}

/**
* @description: 初始化生成图片的病历列表
*/
function initPicturedRecordsTree() {
	$HUI.tree('#picturedRecordsTree', {
		loader: function (param, success, error) {
			$cm({
				ClassName: "NurMp.Service.Image.List",
				MethodName: "getPicturedRecords",
				EpisodeID: EpisodeID,
				SearchInfo: $HUI.searchbox('#picturedReocrdsSearchBox').getValue(),
				HospitalID: GV.HospitalID
			}, function (data) {
				success(data);
			});
		},
		formatter: function (node) {
			if (!node.imagePath) {
				return '<span class="tree-title" >' + node.text + '</span>';
			} else {
				return '<span title="' + node.imagePath + '" class="hisui-tooltip" >' + node.text + '</span>';
			}
		},
		lines: true,
		onClick: updatePicture
	});
}

/**
* @description: 加载图片
*/
function updatePicture(node) {
	var preNode = $('#picturedRecordsTree').tree('getSelected');
	var parentNode = $('#picturedRecordsTree').tree('getParent', $('#' + preNode.domId)[0]);
	var iframe = document.getElementById("iframeContent");
	$(iframe).contents().find("body").html("");
	if (node.viewType == "Html") {
		var hisURI = window.location.href.split("/csp/")[0];
		var printTemplateEmrCode = node.PrnCode;
		var RowIDs = "";
		var CAVerify = "1";
		var logAuxiliaryInfo = GetLogAuxiliaryInfo();
		var putHTML = function (object) {
			iframe.src = "about:blank";
			iframe.contentWindow.document.open();
			//				iframe.contentWindow.document.write(JSON.parse(object).msg);
			iframe.contentWindow.document.write(JSON.parse(object.rtn).msg);
			iframe.contentWindow.document.close();
		};
		$('#imgBox').panel('setTitle', '网页: ' + parentNode.text + '-' + node.pageNum + '/' + parentNode.total);
		//			$HUI.searchbox('#searchPageNo').setValue(node.pageNum);
		//			$.ajax({
		//                type: "POST",
		//                url: "/dhcmg/webmakepicture/Default.aspx?hisURI=" + hisURI + "&templateIndentity=" + printTemplateEmrCode + "&episodeID=" + EpisodeID + "&rowID=" + node.rowId  + "&pageNO=" + node.page + "&CAVerifyStr=" + CAVerify + "&type=GetOnePageHTML",
		//                success: function (result) {
		//                    putHTML(result);
		//                }
		//            });
		PrintProvider.MakeHTML(hisURI, printTemplateEmrCode, EpisodeID, node.rowId, node.page, CAVerify, logAuxiliaryInfo, putHTML);
	} else {
		if (!node.imagePath) {
			$.messager.popover({ msg: $g('请选择图片！'), type: 'alert' });
			return false;
		}
		$('#imgBox').panel('setTitle', '图片: ' + parentNode.text + '-' + node.pageNum + '/' + parentNode.total);
		$HUI.searchbox('#searchPageNo').setValue(node.pageNum);
		iframe.setAttribute("src", "nur.hisui.nurseImage.csp?ViewType=Html&HospitalID=" + GV.HospitalID + "&ImagePath=" + node.imagePath);
	}
}
/**
	* @description: 打印
*/
function printPic() {
	var iframe = document.getElementById('iframeContent')
	iframe.contentWindow.focus();
	iframe.contentWindow.print();
}

/**
	* @description: 事件监听
*/
function listenEvents() {
	$('#picturedReocrdsSearchBox').searchbox({
		searcher: function (value) {
			$HUI.tree('#picturedRecordsTree', 'reload');
		}
	});
	$('#btnPageStart').bind('click', function () {
		var preNode = $('#picturedRecordsTree').tree('getSelected');
		var preNodeID = preNode.id;
		var preNodeArr = preNodeID.split('^');
		var nextNodeID = '1^' + preNodeArr[1] + '^' + preNodeArr[2];
		var node = $('#picturedRecordsTree').tree('find', nextNodeID);
		if (node == null) {
			$.messager.popover({ msg: $g('请检查图片首页是否缺失！'), type: 'alert', timeout: 1000 });
			return false;
		}
		$('#picturedRecordsTree').tree('select', node.target);
		updatePicture(node);
	});
	$('#btnPageUp').bind('click', function () {
		var preNode = $('#picturedRecordsTree').tree('getSelected');
		var preNodeID = preNode.id;
		var preNodeArr = preNodeID.split('^');
		var prePageNo = parseInt(preNode.pageNum);
		var nextPageNo = parseInt(prePageNo) - 1;
		var nextNodeID = nextPageNo + '^' + preNodeArr[1] + '^' + preNodeArr[2];
		var node = $('#picturedRecordsTree').tree('find', nextNodeID);
		if (node == null) {
			$.messager.popover({ msg: $g('到顶了！'), type: 'alert', timeout: 1000 });
			return false;
		}
		$('#picturedRecordsTree').tree('select', node.target);
		updatePicture(node);
	});
	$('#btnPageDown').bind('click', function () {
		var preNode = $('#picturedRecordsTree').tree('getSelected');
		var preNodeID = preNode.id;
		var preNodeArr = preNodeID.split('^');
		var prePageNo = parseInt(preNode.pageNum);
		var nextPageNo = parseInt(prePageNo) + 1;
		var nextNodeID = nextPageNo + '^' + preNodeArr[1] + '^' + preNodeArr[2];
		var node = $('#picturedRecordsTree').tree('find', nextNodeID);
		if (node == null) {
			$.messager.popover({ msg: $g('到底了！'), type: 'alert', timeout: 1000 });
			return false;
		}
		$('#picturedRecordsTree').tree('select', node.target);
		updatePicture(node);
	});
	$('#btnPageEnd').bind('click', function () {
		var preNode = $('#picturedRecordsTree').tree('getSelected');
		var preNodeID = preNode.id;
		var preNodeArr = preNodeID.split('^');
		var parentNode = $('#picturedRecordsTree').tree('getParent', $('#' + preNode.domId)[0]);
		var totalPage = parentNode.total;
		var nextNodeID = totalPage + '^' + preNodeArr[1] + '^' + preNodeArr[2];
		var node = $('#picturedRecordsTree').tree('find', nextNodeID);
		if (node == null) {
			$.messager.popover({ msg: $g('请检查图片尾页是否缺失！'), type: 'alert', timeout: 1000 });
			return false;
		}
		$('#picturedRecordsTree').tree('select', node.target);
		updatePicture(node);
	});
	$('#searchPageNo').searchbox({
		searcher: function (value) {
			var preNode = $('#picturedRecordsTree').tree('getSelected');
			var preNodeID = preNode.id;
			var preNodeArr = preNodeID.split('^');
			if (value % 1 == 0) {
				var nextNodeID = value + '^' + preNodeArr[1] + '^' + preNodeArr[2];
				var node = $('#picturedRecordsTree').tree('find', nextNodeID);
				if (node == null) {
					$.messager.popover({ msg: $g('请输入正确的页码！'), type: 'alert', timeout: 1000 });
					return false;
				}
				$('#picturedRecordsTree').tree('select', node.target);
				updatePicture(node);
			} else {
				$.messager.popover({ msg: $g('请输入正确的页码！'), type: 'error', timeout: 1000 });
				return false;
			}
		}
	});
	$('#btnPageGo').bind('click', function () {
		var preNode = $('#picturedRecordsTree').tree('getSelected');
		var preNodeID = preNode.id;
		var preNodeArr = preNodeID.split('^');
		var goPageNo = $HUI.searchbox('#searchPageNo').getValue();
		if (goPageNo % 1 == 0) {
			var nextNodeID = goPageNo + '^' + preNodeArr[1] + '^' + preNodeArr[2];
			var node = $('#picturedRecordsTree').tree('find', nextNodeID);
			if (node == null) {
				$.messager.popover({ msg: $g('请输入正确的页码！'), type: 'alert', timeout: 1000 });
				return false;
			}
			$('#picturedRecordsTree').tree('select', node.target);
			updatePicture(node);
		} else {
			$.messager.popover({ msg: $g('请输入正确的页码！'), type: 'error', timeout: 1000 });
			return false;
		}
	});
	$('#btnPrint').bind('click', printPic);
}