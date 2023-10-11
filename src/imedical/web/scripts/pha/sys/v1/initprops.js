/**
 * ����:	 ҩ������-��ʼ������
 * ��д��:	 yunhaibao
 * ��д����: 2019-06-26
 * pha/sys/v1/initprops.js
 */

// ��������
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

// �ַ���������չ
String.prototype.replaceAll = function (frStr, toStr) {
    return this.replace(new RegExp(frStr, 'gm'), toStr);
};

// �����ʼ��
$(function () {
	InitLayout();
});

// ��ʼ������
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

// �������
function onClickFn(rowIndex, rowData, text, isExport){
	if (isExport) {
		Export(rowData);
	} else {
		InputSurePwd(function(){
			Import(rowData);
		});
	}
}

// ����(����Excelģ��)
function Export(rowData){
	var expClassName = rowData.ExpClassName || "";
	var expQueryName = rowData.ExpQueryName || "";
	if (expClassName == "" || expQueryName == "") {
		PHA.Alert('��ܰ��ʾ', "δָ��������Query����", -2);
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
				PHA.Alert('��ܰ��ʾ', data.errMsg, -2);
				return;
			}
			if (data.success == 0) {
				PHA.Alert('��ܰ��ʾ', data.msg, -2);
				return;
			}
			var rowsData = data;
			if (data.rows) {
				rowsData = data.rows;
			}
			if (rowsData.length == 0) {
				PHA.Alert('��ܰ��ʾ', "û�п��Ե��������ݣ�", -2);
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
			PHA.Alert('��ܰ��ʾ', xhr.responseText, -3);
		}
	});
}

// ����
function Import(rowData){
	PHA_COM.ImportFile({
		charset: 'gbk2312',
		suffixReg: /^(.xls)|(.xlsx)$/
	}, function(data, file, workBook){
		if (/text+/.test(file.type)) {
			data = stringToObject(data);
		}
		if (data.length == 0) {
			PHA.Alert('��ܰ��ʾ', 'û������!', -2);
			return;
		}
		// ȡexcel��һ�� (���Excel������Ϊ��ʱ�д�λ������)
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
		// ��ʼ����
		PHA.Confirm('��ܰ��ʾ', '<b>' + rowData.updateText + '��</b><br/><label style="color:green;">' + file.name + '</label><br/>Excel�����Ѷ�ȡ�ɹ����Ƿ�ȷ��ִ�е������?', function () {
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

// ��̨�෽�����ΪPID
function ImportByPid(_options){
	// ����
	var data = _options.data;
	var titleObj = _options.titleObj;
	var rowData = _options.rowData;
	// �ϴ���ִ��
	var pid = tkMakeServerCall('PHA.SYS.Init.Save', 'NewPid');
	try {
		// ���ݷֶ��ϴ� (100����һ��)
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
				PHA.Alert('��ܰ��ʾ', '�ϴ�����ʧ��:' + retArr[1], -3);
				tkMakeServerCall('PHA.SYS.Init.Save', 'ClearData', pid);
				return;
			}
		}
		// �ϴ���ص�
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
						msg: '����ɹ�!',
						type: 'success'
					});
					tkMakeServerCall('PHA.SYS.Init.Save', 'ClearData', pid);
				},
				error: function(jqXHR, textStatus, errorThrown){
					PHA.Alert('��ܰ��ʾ', "�����쳣:\r\n" + errorThrown, -3);
				}
			});
		} else {
			// ֱ�������û��������ڵ�λ��
			PHA.Alert('��ܰ��ʾ', '�����ϴ��ɹ�,Global����: ^PHA.SYS.Init.Temp("DATA", ' + pid + ')', 0);
		}
	} catch(e) {
		PHA.Alert('��ܰ��ʾ', e.message, -3);
		tkMakeServerCall('PHA.SYS.Init.Save', 'ClearData', pid);
	}
}

// ��̨�෽�����Ϊ�ַ��� (json�ַ��������ϼ�ͷ�ָ���ַ���)
function ImportByStr(_options){
	// ����
	var data = _options.data;
	var titleObj = _options.titleObj;
	var rowData = _options.rowData;
	var updClassName = rowData.UpdClassName || "";
	var updMethodName = rowData.UpdMethodName || "";
	if (updClassName == "" || updMethodName == "") {
		return;
	}
	// ��ȡ�෽��������
	var paramName = getParamName(updClassName + ':' + updMethodName);
	if (paramName.split('^')[0] < 0 || paramName == '') {
		PHA.Alert('��ܰ��ʾ', paramName, -3);
		return;
	}
	var paramNameArr = eval('(' + paramName + ')');
	var paramName0 = paramNameArr[0];
	
	// �ϴ���ִ��
	if (rowData.ExeType == '1') {
		// ����ִ�� - ѭ���������ϴ�
		ClearLog();
		for (var i = 0; i < data.length; i++) {
			var iData = data[i];
			var oneStr = '';
			if (rowData.ParamType == '2') {
				oneStr = objectToString(iData, "^", titleObj);
			} else {
				iData.rowIndex = (i + 2); // ��һ��Ϊ����
				oneStr = JSON.stringify(iData);
			}
			var postData = {
				ClassName: updClassName,
				MethodName: updMethodName
			};
			postData[paramName0] = oneStr;
			// ִ��һ��
			ExeRowTask(postData, rowData.ParamType, rowData.ExeType);
		}
	} else {
		// ����ִ�� - ��ȡ���в���
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
		// �������
		var postData = {
			ClassName: updClassName,
			MethodName: updMethodName
		};
		postData[paramName0] = inputStr;
		// �ϴ�����
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
				PHA.Alert('��ܰ��ʾ', "�����쳣:\r\n" + errorThrown, -3);
			}
		});
	}
}

// ִ��һ��
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
				PHA.Alert('��ܰ��ʾ', "�����쳣:\r\n" + errorThrown, -3);
			}
		});
	}, 1);
}

// �����־
function AddLog(retText, extParams){
	// ��ȡlogStr
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
				PHA.Confirm('��ܰ��ʾ', '����ʧ��, pid=' + extParams.pid + ', �Ƿ�������ϴ�����ʱ����?', function () {
					tkMakeServerCall('PHA.SYS.Init.Save', 'ClearData', extParams.pid);
					PHA.Popover({
						msg: '����ɹ�!',
						type: 'success'
					});
				});
				extParams.isError = true;
			}
		}
	}
	
	// ����
	PHA_COM.VAR.logStr = logStr.split("|@|").join("\r\n");
	var htmlLogStr = logStr.split("|@|").join("<br/>");
	htmlLogStr = htmlLogStr.split(String.fromCharCode(13) + String.fromCharCode(10)).join("<br/>");
	htmlLogStr = htmlLogStr.split("����").join("<label style='color:red;'>����</label>");
	htmlLogStr = htmlLogStr.split("ʧ��").join("<label style='color:red;'>ʧ��</label>");
	htmlLogStr = htmlLogStr.split("ERROR").join("<label style='color:red;'>ERROR</label>");
	htmlLogStr = htmlLogStr.split("error").join("<label style='color:red;'>error</label>");
	htmlLogStr = htmlLogStr.split("Error").join("<label style='color:red;'>Error</label>");
	$('#' + PHA_COM.VAR.logDivId).append(htmlLogStr);
}

// �����־
function ClearLog(){
	PHA_COM.VAR.logStr = '';
	$('#' + PHA_COM.VAR.logDivId).html('');
}

// ������־
function ExportLog(){
	var fileName = '������־_' + '.txt';
	if(!PHA_COM.VAR.logStr){
		PHA.Msg("alert", "������ϢΪ�գ����赼����")
		return;
	}
	PHA_COM.ExportFile("", PHA_COM.VAR.logStr, fileName);
}

/*
* һЩ���߷���
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
	// ������
	if (titleObj) {
		for (var tk in titleObj) {
			var oneVal = obj[tk] || "";
			oneVal = $.trim(oneVal); // ȥ�����˿հ�
			retArr.push(oneVal);
		}
		return retArr.join("^");
	}
	// ������
	for (var k in obj) {
		var oneVal = obj[k] || "";
		oneVal = $.trim(oneVal); // ȥ�����˿հ�
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
* ��̬����ҳ��
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
	rowHtml += '		<div style="width:187px;">' + $g(rowData.description) + ' <a style="cursor:pointer;text-decoration:underline" onclick=Edit(' + rowIndex + ')>[' + $g('ά��') + ']</a></div>';
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
* ����ά�����ִ���б�
*/
function Add(){
	OpenEditWin({
		isAdd: true,
		data: {
			exportText: $g('����Excelģ��'),
			updateText: $g('��������'),
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
			msg: '�෽�����ΪPIDʱ��[ִ�з�ʽ]ֻ��ά����[����ִ��]��',
			type: 'alert'
		});
		return;
	}
	var pJsonStr = JSON.stringify(pJson);
	var code = $('#' + winContentId).attr('code');
	
	var retStr = tkMakeServerCall('PHA.SYS.Init.Save', 'Save', code, pJsonStr);
	var retArr = retStr.split('^');
	if (retArr[0] < 0) {
		PHA.Alert('��ܰ��ʾ', retArr[1], retArr[0]);
		return;
	}
	$('#' + winId).dialog('close');
	PHA.Popover({
		msg: '����ɹ���',
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
		title: _opts.isAdd ? $g('����') : $g('�޸�'),
		iconCls: _opts.isAdd ? 'icon-w-add' : 'icon-w-edit',
		content: "<div id='" + winContentId + "' code='" + (_opts.data.code || '') + "'>" + GetAllInput() + "</div>",
		closable: true,
		buttons:[{
			text: $g('����'),
			handler: Save
		},{
			text: $g('�ر�'),
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
	contentHtmlStr += '<label style="color:red;text-align:center;margin-left:4px;">' + $g('�ؼ�����������������ȷ�ϣ�') + '</label>';
	contentHtmlStr += '<br/>';
	contentHtmlStr += '<input id="userPwd" class="hisui-validatebox" type="password" style="margin-top:15px;width:180px;" />';
	contentHtmlStr += '</div>';
	$('#' + winId).dialog({
		width: 226,
		height: 180,
		modal: true,
		title: '��ܰ��ʾ',
		iconCls: 'icon-w-edit',
		content: contentHtmlStr,
		closable: true,
		buttons:[{
			text: $g('ȷ��'),
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
			text: $g('ȡ��'),
			handler: function(){
				$('#' + winId).dialog('close');
			}
		}]
	});
	$('#' + winId).dialog('open');
	$('#userPwd').focus();
}