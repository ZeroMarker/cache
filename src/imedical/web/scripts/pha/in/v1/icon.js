/*
 * 名称:	 药房公共 - 药品图标维护
 * 编写人:	 Huxt
 * 编写日期: 2021-05-06
 * csp:      pha.in.v1.icon.csp
 * js:       pha/in/v1/icon.js
 */

PHA_COM.VAR = {
	ImgType: ['png', 'jpg', 'gif', 'ico', 'svg']
};

$(function () {
	InitDict();
	InitGridIcon();
	InitEvents();
	QueryIcon();
});

// 初始化 - 表单
function InitDict() {
	$('#ActiveFlag').checkbox('setValue', true);
	$('#fileIcon').filebox({
		width: 230,
		prompt: $g('文件') + ': ' + GetImgTypeStr(),
		buttonText: '选择',
		buttonAlign: 'right',
		plain: true,
		onClickButton: function () {},
		onChange: function (nVal, oVal) {
			if (CheckImgType(nVal) == false) {
				Clear();
				return;
			}
			$('#iconCode').val(nVal);
			$('#iconName').val(nVal);
		}
	});
}

// 初始化 - 事件
function InitEvents() {
	$('#btnUpload').on('click', UploadIcon);
	$('#btnUpdate').on('click', UpdateIcon);
	$('#btnRefresh').on('click', function () {
		Clear();
		QueryIcon();
	});
}

// 初始化 - 表格
function InitGridIcon() {
	var columns = [[{
				field: "RowID",
				title: 'RowID',
				width: 200,
				hidden: true
			}, {
				field: 'iconPreview',
				title: '图标',
				width: 70,
				align: 'center',
				formatter: function (value, rowData, rowIndex) {
					return "<img src='" + (rowData.VirtualPath + "/" + rowData.Code) + "' title='" + (rowData.Tips) + "' class='pha-drugicon' />";
				}
			}, {
				field: 'Code',
				title: '代码',
				width: 120
			}, {
				field: "Name",
				title: '名称',
				width: 120
			}, {
				field: 'Tips',
				title: '说明',
				width: 200
			}, {
				field: 'ActiveFlag',
				title: '可用',
				width: 60,
				align: 'center',
				formatter: FmtYesNo
			}, {
				field: 'PhysicsPath',
				title: '保存路径(物理)',
				width: 300,
				hidden: true
			}, {
				field: 'VirtualPath',
				title: '保存路径(虚拟)',
				width: 300,
				hidden: true
			}, {
				field: 'UploadInfo',
				title: '上传时间',
				width: 230,
				formatter: function (value, rowData, rowIndex) {
					return rowData.UploadDate + " " + rowData.UploadTime + " / " + rowData.UploadUserName;
				}
			}, {
				field: 'UpdateInfo',
				title: '修改时间',
				width: 230,
				formatter: function (value, rowData, rowIndex) {
					return rowData.UpdateDate + " " + rowData.UpdateTime + " / " + rowData.UpdateUserName;
				}
			}
		]
	];
	var dataGridOption = {
		url: '',
		queryParams: {
			ClassName: 'PHA.IN.Icon.Query',
			QueryName: 'Icon'
		},
		fitColumns: true,
		border: false,
		rownumbers: true,
		columns: columns,
		pagination: true,
		singleSelect: true,
		toolbar: '#gridIconBar',
		onSelect: function (rowIndex, rowData) {
			ShowData(rowData);
		},
		onLoadSuccess: function () {
			PHA_COM.Drug.Tips();
		}
	};
	PHA.Grid("gridIcon", dataGridOption);
}

// 查询
function QueryIcon() {
	$('#gridIcon').datagrid('options').url = $URL;
	$('#gridIcon').datagrid('query', {
		QText: '',
		pJsonStr: ''
	});
}

// 选中时显示
function ShowData(rowData) {
	$('#fileIcon').filebox('clear');
	$('#iconCode').val(rowData.Code);
	$('#iconName').val(rowData.Name);
	$('#iconTips').val(rowData.Tips);
	$('#ActiveFlag').checkbox('setValue', (rowData.ActiveFlag == "Y") ? true : false);
}

// 上传
function UploadIcon() {
	var formData = GetFormData();
	var files = $('#fileIcon').filebox('files');
	var fileLen = files.length;
	if (fileLen == 0) {
		PHA.Popover({
			msg: '请先选择图标文件！',
			type: 'alert'
		});
		return;
	}
	var fileTotal = fileLen;
	for (var i = 0; i < fileLen; i++) {
		var file = files[i];
		UploadOneIcon({
			File: file,
			Code: formData.Code,
			Name: formData.Name,
			Tips: formData.Tips,
			ActiveFlag: formData.ActiveFlag,
			UploadUserDR: session['LOGON.USERID'],
			UpdateUserDR: session['LOGON.USERID']
		});
	}
}
function UploadOneIcon(_opts) {
	// 验证图片文件
	var file = _opts.File;
	var fileName = file.name;
	if (/image+/.test(file.type) == false) {
		PHA.Popover({
			msg: '只能上传图片文件！',
			type: 'alert'
		});
		return;
	}
	var pJson = {};
	for (var k in _opts) {
		if (k == 'File') {
			continue;
		}
		pJson[k] = _opts[k];
	}
	var pJsonStr = JSON.stringify(pJson);

	// 定义上传函数
	var _uploafFn = function (rowID) {
		var reader = new FileReader();
		reader.onload = function () {
			var base64Str = this.result;
			base64Str = base64Str.replace("data:image/gif;base64,", "");
			base64Str = base64Str.replace("data:image/jpeg;base64,", "");
			base64Str = base64Str.replace("data:image/png;base64,", "");
			base64Str = base64Str.replace("data:image/x-icon;base64,", "");
			base64Str = base64Str.replace("data:image/svg+xml;base64,", "");
			var retStr = tkMakeServerCall("PHA.IN.Icon.Save", "UploadImg", rowID, pJsonStr, base64Str);
			var retArr = retStr.split("^");
			if (parseFloat(retArr[0]) < 0) {
				PHA.Alert("提示", retArr[1], retArr[0]);
				return;
			}
			PHA.Popover({
				msg: '上传成功！',
				type: 'success'
			});
			Clear();
			QueryIcon();
		}
		reader.readAsDataURL(file);
	}

	// 开始上传
	var Code = _opts.Code;
	var rowID = tkMakeServerCall('PHA.IN.Icon.Save', 'ExistImg', Code);
	if (rowID != '') {
		// 用户确认后上传
		var tipsContent = "";
		tipsContent += "您可以点击“确认”按钮，继续上传，将覆盖原来图片文件；<br/>";
		tipsContent += "也可以点击“取消”按钮，修改文件名称后再上传或者点击“修改”按钮。";
		PHA.Confirm('温馨提示', tipsContent, function () {
			_uploafFn(rowID);
		});
	} else {
		// 直接上传
		_uploafFn('');
	}
}

// 更新信息
function UpdateIcon() {
	var selRow = $('#gridIcon').datagrid('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: '请选择一条数据！',
			type: 'alert'
		});
		return;
	}
	var rowID = selRow.RowID || "";
	if (rowID == "") {
		PHA.Popover({
			msg: 'rowID不存在,无法修改！',
			type: 'alert'
		});
		return;
	}
	var formData = GetFormData();
	var saveRow = {};
	for (var k in selRow) {
		saveRow[k] = selRow[k];
		if (typeof formData[k] != "undefined") {
			saveRow[k] = formData[k];
		}
	}
	saveRow.UpdateUserDR = session['LOGON.USERID'];
	var pJsonStr = JSON.stringify(saveRow);

	PHA.Confirm('温馨提示', "是否确认仅修改信息,不更新图片？", function () {
		var retStr = tkMakeServerCall("PHA.IN.Icon.Save", "UpdateImg", rowID, pJsonStr);
		var retArr = retStr.split("^");
		if (parseFloat(retArr[0]) < 0) {
			PHA.Alert("提示", retArr[1], retArr[0]);
			return;
		}
		PHA.Popover({
			msg: '修改成功！',
			type: 'success'
		});
		Clear();
		QueryIcon();
	});
}

// 清屏
function Clear() {
	$('#fileIcon').filebox('clear');
	$('#iconCode').val('');
	$('#iconName').val('');
	$('#iconTips').val('');
	$('#ActiveFlag').checkbox('setValue', true);
}

// 获取表单数据
function GetFormData() {
	return {
		Code: $('#iconCode').val() || "",
		Name: $('#iconName').val() || "",
		Tips: $('#iconTips').val() || "",
		ActiveFlag: $('#ActiveFlag').checkbox('getValue') == true ? "Y" : "N"
	}
}

// 格式化函数
function FmtYesNo(value, rowData, rowIndex){
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	}
	return PHA_COM.Fmt.Grid.No.Chinese;
}

// 验证图片文件类型
function CheckImgType(fName) {
	fName = fName || "";
	if (fName == "") {
		PHA.Popover({
			msg: '文件名称不能为空！',
			type: 'alert'
		});
		return false;
	}
	var fNameArr = fName.split('.');
	var imgSuffix = fNameArr[fNameArr.length - 1];
	if (PHA_COM.VAR.ImgType.indexOf(imgSuffix) < 0) {
		PHA.Popover({
			msg: '文件类型选择: ' + GetImgTypeStr(),
			type: 'alert'
		});
		return false;
	}
	return true;
}

// 获取图片文件类型
function GetImgTypeStr() {
	var tStr = "";
	for (var i = 0; i < PHA_COM.VAR.ImgType.length; i++) {
		if (tStr == "") {
			tStr = "*." + PHA_COM.VAR.ImgType[i];
		} else {
			tStr += ",*." + PHA_COM.VAR.ImgType[i];
		}
	}
	return tStr;
}
