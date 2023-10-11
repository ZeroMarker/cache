/**
 * 名称:	 药房公共-初始化参数
 * 编写人:	 yunhaibao
 * 编写日期: 2019-06-26
 * pha/sys/v1/initprops.js
 */

// 公共变量
var $URL = 'web.DHCST.Common.ActionURL.cls'
if (typeof PHA_COM == 'undefined') {
	var PHA_COM = {};
}
PHA_COM.VAR = {
	layoutRows: [],
	winId: 'win_info',
	winContentId: 'win_info' + '_' + 'content',
	logStr: '',
	logDivId: 'panel-initlog-txt'
};

// 字符串方法扩展
String.prototype.replaceAll = function (frStr, toStr) {
    return this.replace(new RegExp(frStr, 'gm'), toStr);
};

// 界面初始化
$(function () {
	InitLayout();
});

// 初始化布局
function InitLayout(){
	$.cm({
		ClassName: 'PHA.SYS.Init.Query',
		QueryName: 'InitList',
		InputStr: ''
	}, function(retJson){
		PHA_COM.VAR.layoutRows = retJson.rows;
		InitHtml("panel-initprop", {
			data: retJson.rows,
			onClick: onClickFn
		});
	});
}

// 点击调用
function onClickFn(rowIndex, rowData, text, isExport){
	if (isExport) {
		Export(rowData);
	} else {
		InputSurePwd(function(){
			Import(rowData);
		});
	}
}

// 导出(下载Excel模板)
function Export(rowData){
	var expClassName = rowData.ExpClassName || "";
	var expQueryName = rowData.ExpQueryName || "";
	if (expClassName == "" || expQueryName == "") {
		PHA.Alert('温馨提示', "未指定导出的Query名称", -2);
		return;
	}
	var params = {};
	for (var k in rowData) {
		params[k] = rowData[k];
	}
	params.ClassName = expClassName;
	params.QueryName = expQueryName;
	params.ResultSetType = 'Array';
	
	$.ajax({
		url: $URL,
		data: params,
		dataType: 'json',
		success: function(data){
			if (data.errCode < 0) {
				PHA.Alert('温馨提示', data.errMsg, -2);
				return;
			}
			if (data.success == 0) {
				PHA.Alert('温馨提示', data.msg, -2);
				return;
			}
			var rowsData = data;
			if (data.rows) {
				rowsData = data.rows;
			}
			if (rowsData.length == 0) {
				PHA.Alert('温馨提示', "没有可以导出的数据！", -2);
				return;
			}
			var title = {};
			for (var k in rowsData[0]) {
				title[k] = k;
			}
			var fileName = rowData.updateText + ".xlsx";
			PHA_COM.ExportFile(title, data, fileName);
		},
		error: function(xhr){
			PHA.Alert('温馨提示', xhr.responseText, -3);
		}
	});
}

// 导入
function Import(rowData){
	PHA_COM.ImportFile({
		charset: 'gbk2312',
		suffixReg: /^(.xls)|(.xlsx)$/
	}, function(data, file, workBook){
		if (/text+/.test(file.type)) {
			data = stringToObject(data);
		}
		if (data.length == 0) {
			PHA.Alert('温馨提示', '没有数据!', -2);
			return;
		}
		// 取excel第一行 (解决Excel里面列为空时列错位的问题)
		var iSheetData = workBook.Sheets[workBook.SheetNames[0]];
		var iSheetRef = iSheetData['!ref'];
		var iSheetRefArr = iSheetRef.split(':');
		var startCell = iSheetRefArr[0];
		var startRow = startCell.match(/\d+/g).join('');
		var startCol = startCell.replace(startRow, '');
		var endCell = iSheetRefArr[1] || '';
		var endRow = endCell.match(/\d+/g).join('');
		var endCol = endCell.replace(endRow, '');
		var colStr1 = 'A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z';
		var colStr2 = colStr1;
		var colArr1 = colStr1.split(',');
		var colArr2 = colStr2.split(',');
		var colArr = [];
		for (var c = 0; c < colArr1.length; c++) {
			colArr.push(colArr1[c]);
		}
		for (var c1 = 0; c1 < colArr1.length; c1++) {
			for (var c2 = 0; c2 < colArr2.length; c2++) {
				colArr.push(colArr1[c1] + '' + colArr2[c2]);
			}
		}
		var titleObj = {};
		var firstRowData = [];
		var startColIndex = colArr.indexOf(startCol);
		var endColIndex = colArr.indexOf(endCol);
		for (var c = startColIndex; c <= endColIndex; c++) {
			var colName = colArr[c];
			var cellName = colName + '' + startRow;
			var cellInfo = iSheetData[cellName];
			var cellVal = cellInfo.v || '';
			if (cellVal == '') {
				continue;
			}
			firstRowData.push(cellVal);
			titleObj[cellVal] = cellVal;
		}
		// 开始导入
		PHA.Confirm('温馨提示', '<b>' + rowData.updateText + '：</b><br/><label style="color:green;">' + file.name + '</label><br/>Excel数据已读取成功，是否确认执行导入程序?', function () {
			if (rowData.ParamType == '3') {
				ImportByPid({
					data: data,
					titleObj: titleObj,
					rowData: rowData
				});
			} else {
				ImportByStr({
					data: data,
					titleObj: titleObj,
					rowData: rowData
				});
			}
		});
	});
}

// 后台类方法入参为PID
function ImportByPid(_options){
	// 参数
	var data = _options.data;
	var titleObj = _options.titleObj;
	var rowData = _options.rowData;
	// 上传并执行
	var pid = tkMakeServerCall('PHA.SYS.Init.Save', 'NewPid');
	try {
		// 数据分段上传 (100条传一次)
		var curRowIdx = 0;
		var dataArr = splitArray(data, 100);
		var mTimes = dataArr.length;
		for (var i = 0; i < mTimes; i++) {
			var oneDataStr = "";
			var oneData = dataArr[i];
			var oneDataRows = oneData.length;
			for (var j = 0; j < oneDataRows; j++) {
				var oneRow = oneData[j];
				var oneStr = objectToString(oneRow, "^", titleObj);
				if (oneDataStr == "") {
					oneDataStr = oneStr;
				} else {
					oneDataStr = oneDataStr + "|@|" + oneStr;
				}
			}
			var updRetStr = tkMakeServerCall('PHA.SYS.Init.Save', 'SetData', pid, oneDataStr);
			var updRetArr = updRetStr.split("^");
			if (updRetArr[0] < 0) {
				PHA.Alert('温馨提示', '上传数据失败:' + retArr[1], -3);
				tkMakeServerCall('PHA.SYS.Init.Save', 'ClearData', pid);
				return;
			}
		}
		// 上传后回调
		var updClassName = rowData.UpdClassName || "";
		var updMethodName = rowData.UpdMethodName || "";
		if (updClassName != "" && updMethodName != "") {
			$.ajax({
				url: $URL,
				type: 'post',
				dataType: 'text',
				data: {
					ClassName: updClassName,
					MethodName: updMethodName,
					pid: pid
				},
				success: function(retText){
					var extParams = {
						ParamType: rowData.ParamType,
						ExeType: rowData.ExeType,
						isError: false,
						pid: pid
					};
					ClearLog();
					AddLog(retText, extParams);
					if (extParams.isError) {
						return;
					}
					PHA.Popover({
						msg: '导入成功!',
						type: 'success'
					});
					tkMakeServerCall('PHA.SYS.Init.Save', 'ClearData', pid);
				},
				error: function(jqXHR, textStatus, errorThrown){
					PHA.Alert('温馨提示', "程序异常:\r\n" + errorThrown, -3);
				}
			});
		} else {
			// 直接提醒用户数据所在的位置
			PHA.Alert('温馨提示', '数据上传成功,Global名称: ^PHA.SYS.Init.Temp("DATA", ' + pid + ')', 0);
		}
	} catch(e) {
		PHA.Alert('温馨提示', e.message, -3);
		tkMakeServerCall('PHA.SYS.Init.Save', 'ClearData', pid);
	}
}

// 后台类方法入参为字符串 (json字符串或者上箭头分割的字符串)
function ImportByStr(_options){
	// 参数
	var data = _options.data;
	var titleObj = _options.titleObj;
	var rowData = _options.rowData;
	var updClassName = rowData.UpdClassName || "";
	var updMethodName = rowData.UpdMethodName || "";
	if (updClassName == "" || updMethodName == "") {
		return;
	}
	// 获取类方法参数名
	var paramName = getParamName(updClassName + ':' + updMethodName);
	if (paramName.split('^')[0] < 0 || paramName == '') {
		PHA.Alert('温馨提示', paramName, -3);
		return;
	}
	var paramNameArr = eval('(' + paramName + ')');
	var paramName0 = paramNameArr[0];
	
	// 上传并执行
	if (rowData.ExeType == '1') {
		// 逐行执行 - 循环参数并上传
		ClearLog();
		for (var i = 0; i < data.length; i++) {
			var iData = data[i];
			var oneStr = '';
			if (rowData.ParamType == '2') {
				oneStr = objectToString(iData, "^", titleObj);
			} else {
				iData.rowIndex = (i + 2); // 第一行为标题
				oneStr = JSON.stringify(iData);
			}
			var postData = {
				ClassName: updClassName,
				MethodName: updMethodName
			};
			postData[paramName0] = oneStr;
			// 执行一行
			ExeRowTask(postData, rowData.ParamType, rowData.ExeType);
		}
	} else {
		// 批量执行 - 获取所有参数
		var inputStr = '';
		if (rowData.ParamType == '2') {
			for (var i = 0; i < data.length; i++) {
				var iData = data[i];
				var oneStr = objectToString(iData, "^", titleObj);
				if (inputStr == '') {
					inputStr = oneStr;
				} else {
					inputStr = inputStr + '|@|' + oneStr;
				}
			}
		} else {
			inputStr = JSON.stringify(data);
		}
		// 请求参数
		var postData = {
			ClassName: updClassName,
			MethodName: updMethodName
		};
		postData[paramName0] = inputStr;
		// 上传请求
		$.ajax({
			url: $URL,
			type: 'post',
			dataType: 'text',
			data: postData,
			success: function(retText){
				ClearLog();
				AddLog(retText, {
					ParamType: rowData.ParamType,
					ExeType: rowData.ExeType
				});
			},
			error: function(jqXHR, textStatus, errorThrown){
				PHA.Alert('温馨提示', "程序异常:\r\n" + errorThrown, -3);
			}
		});
	}
}

// 执行一行
function ExeRowTask(postData, ParamType, ExeType){
	setTimeout(function(){
		$.ajax({
			url: $URL,
			type: 'post',
			dataType: 'text',
			data: postData,
			success: function(retText){
				AddLog(retText, {
					ParamType: ParamType,
					ExeType: ExeType
				});
			},
			error: function(jqXHR, textStatus, errorThrown){
				PHA.Alert('温馨提示', "程序异常:\r\n" + errorThrown, -3);
			}
		});
	}, 1);
}

// 添加日志
function AddLog(retText, extParams){
	// 获取logStr
	var tmpText = retText;
	tmpText = tmpText.replaceAll(String.fromCharCode(10), "");
	tmpText = tmpText.replaceAll(String.fromCharCode(13), "");
	var retJson = null;
	try {
		retJson = eval('(' + tmpText + ')');
	} catch(e){
		retJson = null;
	}
	var logStr = '';
	if (retJson == null) {
		logStr = retText;
	} else {
		if (retJson.success == 0) {
			logStr = retJson.msg;
		} else {
			var logArr = retJson.log || [""];
			logStr = logArr[0];
			var status = parseInt(retJson.status);
			if (status < 0 && extParams.ParamType == '3') {
				PHA.Confirm('温馨提示', '导入失败, pid=' + extParams.pid + ', 是否清除已上传的临时数据?', function () {
					tkMakeServerCall('PHA.SYS.Init.Save', 'ClearData', extParams.pid);
					PHA.Popover({
						msg: '清除成功!',
						type: 'success'
					});
				});
				extParams.isError = true;
			}
		}
	}
	
	// 保存
	PHA_COM.VAR.logStr = logStr.split("|@|").join("\r\n");
	var htmlLogStr = logStr.split("|@|").join("<br/>");
	htmlLogStr = htmlLogStr.split(String.fromCharCode(13) + String.fromCharCode(10)).join("<br/>");
	htmlLogStr = htmlLogStr.split("错误").join("<label style='color:red;'>错误</label>");
	htmlLogStr = htmlLogStr.split("失败").join("<label style='color:red;'>失败</label>");
	htmlLogStr = htmlLogStr.split("ERROR").join("<label style='color:red;'>ERROR</label>");
	htmlLogStr = htmlLogStr.split("error").join("<label style='color:red;'>error</label>");
	htmlLogStr = htmlLogStr.split("Error").join("<label style='color:red;'>Error</label>");
	$('#' + PHA_COM.VAR.logDivId).append(htmlLogStr);
}

// 清除日志
function ClearLog(){
	PHA_COM.VAR.logStr = '';
	$('#' + PHA_COM.VAR.logDivId).html('');
}

// 导出日志
function ExportLog(){
	var fileName = '导出日志_' + '.txt';
	if(!PHA_COM.VAR.logStr){
		PHA.Msg("alert", "导出信息为空，无需导出！")
		return;
	}
	PHA_COM.ExportFile("", PHA_COM.VAR.logStr, fileName);
}

/*
* 一些工具方法
*/
function splitArray(arr, len){
	if(arr.length==0 || len==0){
		return [arr];
	}else if(arr.length==len){
		return [arr];
	}else{
		var maxIndex = Math.ceil(arr.length/len) - 1;
	}
	var retArr = [];
	for(var i=0; i<=maxIndex; i++){
		var stIndex = i*len;
		if(i<maxIndex){
			var endIndex = stIndex + (len-1);
		}else{
			var endIndex = arr.length - 1;
		}
		var curLen = endIndex - stIndex;
		var tmpArr = [];
		for(var j=0; j<=curLen; j++){
			tmpArr[j] = arr[stIndex+j];
		}
		retArr[i] = tmpArr;
	}
	return retArr;
}
function objectToString(obj, sp, titleObj){
	var retArr = [];
	// 按标题
	if (titleObj) {
		for (var tk in titleObj) {
			var oneVal = obj[tk] || "";
			oneVal = $.trim(oneVal); // 去除两端空白
			retArr.push(oneVal);
		}
		return retArr.join("^");
	}
	// 按数据
	for (var k in obj) {
		var oneVal = obj[k] || "";
		oneVal = $.trim(oneVal); // 去除两端空白
		retArr.push(oneVal);
	}
	return retArr.join("^");
}
function stringToObject(data){
	var retDataArr = [];
	var dataArr = data.split(String.fromCharCode(10));
	if (dataArr.length == 0) {
		return [];
	}
	var titleRowStr = dataArr[0];
	titleRowStr = titleRowStr.substring(0,titleRowStr.lastIndexOf(String.fromCharCode(13)));
	var titleRowArr = titleRowStr.split(String.fromCharCode(9));
	var rows = dataArr.length;
	for (var i = 0; i < rows; i++) {
		var oneRowObj = {};
		var oneRowStr = dataArr[i];
		oneRowStr = oneRowStr.substring(0,oneRowStr.lastIndexOf(String.fromCharCode(13)));
		if (oneRowStr == "") {
			continue;
		}
		var oneRowArr = oneRowStr.split(String.fromCharCode(9));
		var oneRowLen = oneRowArr.length;
		for (var j = 0; j < oneRowArr.length; j++) {
			var k = titleRowArr[j];
			var v = oneRowArr[j];
			oneRowObj[k] = v;
		}
		retDataArr.push(oneRowObj);
	}
	return retDataArr;
}
function trim(s) {
	var str = s.replace(/(^\s*)|(\s*$)/g, "");
	return str;
}
function getParamName(inputStr){
	return tkMakeServerCall('PHA.SYS.Init.Save', 'GetMethodParam', inputStr);;
}


/*
* 动态生成页面
*/
function InitHtml(_id, _options){
	_options.id = _id;
	var $mBody = $('#' + _id).panel('body');
	$mBody.children().remove();
	var htmlStr = getAllHtml(_options);
	$mBody.append(htmlStr);
	$.parser.parse('#' + _id);
}

function getAllHtml(_options){
	var data = _options.data;
	var dataLen = data.length;
	for (var i = 0; i < dataLen; i++) {
		getRowHtml({
			rowData: data[i],
			rowIndex: i
		}, _options);
	}
	return;
}

function getRowHtml(_rowOptions, _options){
	var _id = _options.id;
	var rowData = _rowOptions.rowData;
	var rowIndex = _rowOptions.rowIndex;
	if (rowIndex == 0) {
		// $('#' + _id).panel('body').append('<div class="pha-line"></div>');
	}
	var rowHtml = "";
	rowHtml += '<div class="pha-row">';
	rowHtml += '	<div class="pha-col">';
	rowHtml += '		<div class="col-btn-big">';
	rowHtml += '			<a class="hisui-linkbutton big" plain="true" iconCls="icon-big-refresh" name="' +  rowData.name + '" id="upd-' + rowData.name + '" style="margin-right:10px;">' + rowData.updateText + '</a>';
	rowHtml += '		</div>';
	rowHtml += '	</div>';
	rowHtml += '	<div class="pha-col">';
	rowHtml += '		<div class="col-btn-big">';
	rowHtml += '			<a class="hisui-linkbutton big" plain="true" iconCls="icon-big-insert-table" name="' +  rowData.name + '" id="exp-' + rowData.name + '" style="margin-right:10px;">' + rowData.exportText + '</a>';
	rowHtml += '		</div>';
	rowHtml += '	</div>';
	rowHtml += '	<div class="pha-col">';
	rowHtml += '		<div style="width:187px;">' + $g(rowData.description) + ' <a style="cursor:pointer;text-decoration:underline" onclick=Edit(' + rowIndex + ')>[' + $g('维护') + ']</a></div>';
	rowHtml += '	</div>';
	rowHtml += '</div>';
	rowHtml += '<div class="pha-line"></div>';
	$('#' + _id).panel('body').append(rowHtml);
	$('#upd-' + rowData.name).on('click', function(){
		_options.onClick && _options.onClick(rowIndex, rowData, rowData.updateText, false);
	});
	$('#exp-' + rowData.name).on('click', function(){
		_options.onClick && _options.onClick(rowIndex, rowData, rowData.exportText, true);
	});
	return;
}

/*
* 以下维护左侧执行列表
*/
function Add(){
	OpenEditWin({
		isAdd: true,
		data: {
			exportText: $g('下载Excel模板'),
			updateText: $g('导入数据'),
			ParamType: '1',
			ExeType: '2'
		}
	});
}

function Edit(rowIndex){
	var rowData = PHA_COM.VAR.layoutRows[rowIndex];
	OpenEditWin({
		isAdd: false,
		data: rowData
	});
}

function Save(){
	var winId = PHA_COM.VAR.winId;
	var winContentId = PHA_COM.VAR.winContentId;
	var dataArr = PHA.DomData('#' + winContentId, {
		doType: 'save',
		retType: 'Json'
	});
	if (dataArr.length == 0) {
		return;
	}
	var pJson = dataArr[0];
	if (pJson.ParamType == '3' && pJson.ExeType != '2') {
		PHA.Popover({
			msg: '类方法入参为PID时，[执行方式]只能维护成[批量执行]！',
			type: 'alert'
		});
		return;
	}
	var pJsonStr = JSON.stringify(pJson);
	var code = $('#' + winContentId).attr('code');
	
	var retStr = tkMakeServerCall('PHA.SYS.Init.Save', 'Save', code, pJsonStr);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert('温馨提示', retArr[1], retArr[0]);
		return;
	}
	$('#' + winId).dialog('close');
	PHA.Popover({
		msg: '保存成功！',
		type: 'success'
	});
	InitLayout();
}

function OpenEditWin(_opts){
	var winId = PHA_COM.VAR.winId;
	var winContentId = PHA_COM.VAR.winContentId;
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
	}
	$('#' + winId).dialog({
		width: 380,
		height: 540,
		modal: true,
		title: _opts.isAdd ? $g('新增') : $g('修改'),
		iconCls: _opts.isAdd ? 'icon-w-add' : 'icon-w-edit',
		content: "<div id='" + winContentId + "' code='" + (_opts.data.code || '') + "'>" + GetAllInput() + "</div>",
		closable: true,
		buttons:[{
			text: $g('保存'),
			handler: Save
		},{
			text: $g('关闭'),
			handler: function(){
				$('#' + winId).dialog('close');
			}
		}]
	});
	$('#' + winId).dialog('open');
	PHA.SetVals([_opts.data]);
}

function GetAllInput(){
	var inputsHtml = tkMakeServerCall('PHA.SYS.Init.Query', 'GetInputsHtml');
	return inputsHtml;
}

function InputSurePwd(_successFn){
	var winId = 'win_info_pwd';
	var winContentId = winId + '_' + 'content';
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
	}
	var contentHtmlStr = '';
	contentHtmlStr += '<div id="' + winContentId + '" style="margin:20px 20px 0px 20px;">';
	contentHtmlStr += '<label style="color:red;text-align:center;margin-left:4px;">' + $g('关键操作，请输入密码确认！') + '</label>';
	contentHtmlStr += '<br/>';
	contentHtmlStr += '<input id="userPwd" class="hisui-validatebox" type="password" style="margin-top:15px;width:180px;" />';
	contentHtmlStr += '</div>';
	$('#' + winId).dialog({
		width: 226,
		height: 180,
		modal: true,
		title: '温馨提示',
		iconCls: 'icon-w-edit',
		content: contentHtmlStr,
		closable: true,
		buttons:[{
			text: $g('确认'),
			handler: function(){
				var userPwd = $('#userPwd').val();
				var userCode = session['LOGON.USERCODE'];
				var retStr = tkMakeServerCall('PHA.SYS.Init.Save', 'GetUserId', userCode, userPwd);
				var retArr = retStr.split('^');
				if (retArr[0] <= 0) {
					PHA.Popover({
						msg: retArr[1],
						type: 'alert'
					});
					return;
				}
				$('#' + winId).dialog('close');
				_successFn && _successFn();
			}
		},{
			text: $g('取消'),
			handler: function(){
				$('#' + winId).dialog('close');
			}
		}]
	});
	$('#' + winId).dialog('open');
	$('#userPwd').focus();
}