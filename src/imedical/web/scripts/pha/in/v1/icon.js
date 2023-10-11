/*
 * ����:	 ҩ������ - ҩƷͼ��ά��
 * ��д��:	 Huxt
 * ��д����: 2021-05-06
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

// ��ʼ�� - ��
function InitDict() {
	$('#ActiveFlag').checkbox('setValue', true);
	$('#fileIcon').filebox({
		width: 230,
		prompt: $g('�ļ�') + ': ' + GetImgTypeStr(),
		buttonText: 'ѡ��',
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

// ��ʼ�� - �¼�
function InitEvents() {
	$('#btnUpload').on('click', UploadIcon);
	$('#btnUpdate').on('click', UpdateIcon);
	$('#btnRefresh').on('click', function () {
		Clear();
		QueryIcon();
	});
}

// ��ʼ�� - ���
function InitGridIcon() {
	var columns = [[{
				field: "RowID",
				title: 'RowID',
				width: 200,
				hidden: true
			}, {
				field: 'iconPreview',
				title: 'ͼ��',
				width: 70,
				align: 'center',
				formatter: function (value, rowData, rowIndex) {
					return "<img src='" + (rowData.VirtualPath + "/" + rowData.Code) + "' title='" + (rowData.Tips) + "' class='pha-drugicon' />";
				}
			}, {
				field: 'Code',
				title: '����',
				width: 120
			}, {
				field: "Name",
				title: '����',
				width: 120
			}, {
				field: 'Tips',
				title: '˵��',
				width: 200
			}, {
				field: 'ActiveFlag',
				title: '����',
				width: 60,
				align: 'center',
				formatter: FmtYesNo
			}, {
				field: 'PhysicsPath',
				title: '����·��(����)',
				width: 300,
				hidden: true
			}, {
				field: 'VirtualPath',
				title: '����·��(����)',
				width: 300,
				hidden: true
			}, {
				field: 'UploadInfo',
				title: '�ϴ�ʱ��',
				width: 230,
				formatter: function (value, rowData, rowIndex) {
					return rowData.UploadDate + " " + rowData.UploadTime + " / " + rowData.UploadUserName;
				}
			}, {
				field: 'UpdateInfo',
				title: '�޸�ʱ��',
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

// ��ѯ
function QueryIcon() {
	$('#gridIcon').datagrid('options').url = $URL;
	$('#gridIcon').datagrid('query', {
		QText: '',
		pJsonStr: ''
	});
}

// ѡ��ʱ��ʾ
function ShowData(rowData) {
	$('#fileIcon').filebox('clear');
	$('#iconCode').val(rowData.Code);
	$('#iconName').val(rowData.Name);
	$('#iconTips').val(rowData.Tips);
	$('#ActiveFlag').checkbox('setValue', (rowData.ActiveFlag == "Y") ? true : false);
}

// �ϴ�
function UploadIcon() {
	var formData = GetFormData();
	var files = $('#fileIcon').filebox('files');
	var fileLen = files.length;
	if (fileLen == 0) {
		PHA.Popover({
			msg: '����ѡ��ͼ���ļ���',
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
	// ��֤ͼƬ�ļ�
	var file = _opts.File;
	var fileName = file.name;
	if (/image+/.test(file.type) == false) {
		PHA.Popover({
			msg: 'ֻ���ϴ�ͼƬ�ļ���',
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

	// �����ϴ�����
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
				PHA.Alert("��ʾ", retArr[1], retArr[0]);
				return;
			}
			PHA.Popover({
				msg: '�ϴ��ɹ���',
				type: 'success'
			});
			Clear();
			QueryIcon();
		}
		reader.readAsDataURL(file);
	}

	// ��ʼ�ϴ�
	var Code = _opts.Code;
	var rowID = tkMakeServerCall('PHA.IN.Icon.Save', 'ExistImg', Code);
	if (rowID != '') {
		// �û�ȷ�Ϻ��ϴ�
		var tipsContent = "";
		tipsContent += "�����Ե����ȷ�ϡ���ť�������ϴ���������ԭ��ͼƬ�ļ���<br/>";
		tipsContent += "Ҳ���Ե����ȡ������ť���޸��ļ����ƺ����ϴ����ߵ�����޸ġ���ť��";
		PHA.Confirm('��ܰ��ʾ', tipsContent, function () {
			_uploafFn(rowID);
		});
	} else {
		// ֱ���ϴ�
		_uploafFn('');
	}
}

// ������Ϣ
function UpdateIcon() {
	var selRow = $('#gridIcon').datagrid('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: '��ѡ��һ�����ݣ�',
			type: 'alert'
		});
		return;
	}
	var rowID = selRow.RowID || "";
	if (rowID == "") {
		PHA.Popover({
			msg: 'rowID������,�޷��޸ģ�',
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

	PHA.Confirm('��ܰ��ʾ', "�Ƿ�ȷ�Ͻ��޸���Ϣ,������ͼƬ��", function () {
		var retStr = tkMakeServerCall("PHA.IN.Icon.Save", "UpdateImg", rowID, pJsonStr);
		var retArr = retStr.split("^");
		if (parseFloat(retArr[0]) < 0) {
			PHA.Alert("��ʾ", retArr[1], retArr[0]);
			return;
		}
		PHA.Popover({
			msg: '�޸ĳɹ���',
			type: 'success'
		});
		Clear();
		QueryIcon();
	});
}

// ����
function Clear() {
	$('#fileIcon').filebox('clear');
	$('#iconCode').val('');
	$('#iconName').val('');
	$('#iconTips').val('');
	$('#ActiveFlag').checkbox('setValue', true);
}

// ��ȡ������
function GetFormData() {
	return {
		Code: $('#iconCode').val() || "",
		Name: $('#iconName').val() || "",
		Tips: $('#iconTips').val() || "",
		ActiveFlag: $('#ActiveFlag').checkbox('getValue') == true ? "Y" : "N"
	}
}

// ��ʽ������
function FmtYesNo(value, rowData, rowIndex){
	if (value == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	}
	return PHA_COM.Fmt.Grid.No.Chinese;
}

// ��֤ͼƬ�ļ�����
function CheckImgType(fName) {
	fName = fName || "";
	if (fName == "") {
		PHA.Popover({
			msg: '�ļ����Ʋ���Ϊ�գ�',
			type: 'alert'
		});
		return false;
	}
	var fNameArr = fName.split('.');
	var imgSuffix = fNameArr[fNameArr.length - 1];
	if (PHA_COM.VAR.ImgType.indexOf(imgSuffix) < 0) {
		PHA.Popover({
			msg: '�ļ�����ѡ��: ' + GetImgTypeStr(),
			type: 'alert'
		});
		return false;
	}
	return true;
}

// ��ȡͼƬ�ļ�����
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
