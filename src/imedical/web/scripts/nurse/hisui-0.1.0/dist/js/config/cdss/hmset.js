var BWStr = ""
var GV = {
	_CALSSNAME: "NurMp.Service.CDSS.Main",
	CurId: "",
	DetailParentId: ""
};
var init = function () {
	initPageDom();
	initBindEvent();
}
$(init)
function initPageDom() {
	initCondition();
	initVteGrid();
	initVteDetail();

}
function initBindEvent() {
	$('#queryBtn').bind('click', vteGridReload);
	$('#addBtn').bind('click', saveVteData);
	$('#editBtn').bind('click', editVteData);
	$('#cancelBtn').bind('click', cancelVteBtnClick);
	$('#autoCreateBtn').bind('click', autoCreateClick);

	$('#addDetailBtn').bind('click', saveVteDetailData);
	$('#queryDetailBtn').bind('click', vteDetailReload);
	$('#cancelDetailBtn').bind('click', cancelVteDetailBtnClick);
	$('#editDetailBtn').bind('click', EditVteDetailData);

}
function autoCreateClick() {
	var CurType = $('#configType').combobox('getValue');
	if ((CurType == "")) {
		$.messager.alert("��ʾ", "��ѡ��汾����!", 'info');
		return;
	}
	var template = $("#templateCode").combobox('getValue');
	if ((template == "") && (CurType != 2)) {
		$.messager.alert("��ʾ", "��ѡ��ģ��!", 'info');
		return;
	}
	var HMCode = $("#HMCode").combobox('getValue');
	if (HMCode == "") {
		$.messager.alert("��ʾ", "��ѡ���¼������!", 'info');
		return;
	}
	var UserId = session['LOGON.USERID'];
	if ((CurType == 2)) template = "DHCNURTEM"
	var ret = tkMakeServerCall(GV._CALSSNAME, "autoCreateBatchData", CurType, template, HMCode, UserId, HospitalID);
	if (ret == "") {
		$.messager.alert("��ʾ", "����ɹ�!", 'info');
		vteGridReload();
	} else {
		$.messager.alert("��ʾ", ret, 'info');
	}
}
/*----------------------------------------------------------------------------------*/
/**
 * @description ��ʼ�������б�
 */
function initVteGrid() {
	var CurType = $('#configType').combobox('getValue');
	var template = $('#templateCode').combobox('getValue');
	var type = $('#type').combobox('getValue');
	var IfCancel = false;
	var defaultPageSize = 10;
	var defaultPageList = [10, 50, 100, 200, 500];

	$('#gridVTE').datagrid({
		url: $URL,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		pageSize: defaultPageSize,
		pageList: defaultPageList,
		nowrap: false,
		queryParams: {
			ClassName: GV._CALSSNAME,
			QueryName: "QueryVTEConfig",
			ConfigType: CurType,
			Template: template,
			TypeCode: type,
			IfCancel: IfCancel
		},
		columns: [[
			{ field: 'ConfigTypeDesc', title: '�汾����', width: 100 },
			{ field: 'EmrDesc', title: 'ģ��', width: 200 },
			{ field: 'Title', title: '������', width: 100 },
			{ field: 'EmrTypeDesc', title: '��¼������', width: 100 },
			{ field: 'id', title: 'id', width: 10 },
			{ field: 'Template', title: 'Template', width: 10, hidden: true },
			{ field: 'TitleCode', title: 'TitleCode', width: 10, hidden: true },
			{ field: 'EmrType', title: 'EmrType', width: 10, hidden: true },
			{ field: 'ConfigTypeId', title: 'ConfigTypeId', width: 10, hidden: true }
		]],
		idField: 'id',
		singleSelect: true,
		onClickRow: gridSheetClickRow,
		onSelect: function (index, row) {

			//			BWStr=BWIDs;
			//BestWishDetailReload(row.bwId);
			//GV.CurId=row.bwId
		},
		onUnselect: function (index, row) {
			//BWStr=BWIDs;
			//BestWishDetailReload(BWStr);
		},
		onDblClickRow: function (index, data) {
			initData(data);
		}
	});
}
/**
 *@description ���ñ����˫���¼�
 *
 */
function gridSheetClickRow(rowIndex, rowData) {
	var carryTitle = '��ϸ���ã�<span style="color: red;font-weight:bold">' + rowData.EmrDesc + ' ' + rowData.Title + ' ' + '</span>'
	$('#panelSheetDetail').panel('setTitle', carryTitle);
	$('#MethodType').combobox('clear');
	$('#resultInput').val('');
	GV.DetailParentId = rowData.id
	vteDetailReload();
}
function initData(data) {
	$HUI.combobox('#configType').setValue(data.ConfigTypeId)
	$HUI.combobox('#templateCode').setValue(data.Template)
	$HUI.combobox('#type').setValue(data.TitleCode)
	$HUI.combobox('#HMCode').setValue(data.EmrType)
	GV.CurId = data.id
}
/*----------------------------------------------------------------------------------*/
/**
 * @description ��ʼ����ϸ�б�
 */
function initVteDetail() {
	var defaultPageSize = 10;
	var defaultPageList = [10, 50, 100, 200, 500];
	var ifExced = false;
	$('#vteDetail').datagrid({
		url: $URL,
		pagination: true, //���Ϊtrue, ����DataGrid�ؼ��ײ���ʾ��ҳ������
		pageSize: defaultPageSize,
		pageList: defaultPageList,
		singleSelect: true,  //ֻ�ܵ�ѡ
		nowrap: false,
		queryParams: {
			ClassName: GV._CALSSNAME,
			QueryName: "QueryVTEDetail",
			ParentId: "",
			IfCancel: ifExced
		},
		columns: [[
			{ field: 'MethodTypeDesc', title: '��������', width: 100, },
			{ field: 'CalcResult', title: '������', width: 500 },
			{ field: 'id', title: 'id', width: 10 },
			{ field: 'MethodTypeId', title: 'MethodTypeId', width: 10, hidden: true },
		]],
		idField: 'id',
		onSelect: function (index, row) {

		},
		onUnselect: function (index, row) {
		},
		onDblClickRow: function (index, data) {
			initDetailData(data);
		}

	});
	LoadMethodType();
}
function initDetailData(data) {

	$HUI.combobox('#MethodType').setValue(data.MethodTypeId)
	$('#resultInput').val(data.CalcResult)
}
/**
 * @description ��ʼ����ѯ������
 */
function initCondition() {
	var userID = session['LOGON.USERID'];
	var hospID = session['LOGON.HOSPID'];
	LoadConfigType();
	LoadTemplate();
	LoadType();
	LoadHMCode();
}
function LoadHMCode() {
	$.cm({
		ClassName: GV._CALSSNAME,
		QueryName: "findHMCode",
		desc: "",
		rows: 99999
	}, function (GridData) {
		var cbox = $HUI.combobox("#HMCode", {
			valueField: 'id',
			textField: 'Desc',
			editable: true,
			data: GridData["rows"],
			filter: function (q, row) {
				return (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) || (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onSelect: function (rec) {
				//LoadResult(); 

			},
			onChange: function (newValue, oldValue) {
				if (newValue == "") {
					//LoadResult();
				}
			}
		});
	});
}
function LoadType() {
	$.cm({
		ClassName: GV._CALSSNAME,
		QueryName: "findTypeInfo",
		desc: "",
		rows: 99999
	}, function (GridData) {
		var cbox = $HUI.combobox("#type", {
			valueField: 'Code',
			textField: 'typeDesc',
			editable: true,
			data: GridData["rows"],
			filter: function (q, row) {
				return (row["typeDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) || (row["typeDesc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onSelect: function (rec) {
				//LoadResult(); 

			},
			onChange: function (newValue, oldValue) {
				if (newValue == "") {
					//LoadResult();
				}
			}
		});
	});
}
function LoadConfigType() {
	$.cm({
		ClassName: GV._CALSSNAME,
		QueryName: "findVersion",
		desc: "",
		rows: 99999
	}, function (GridData) {
		var cbox = $HUI.combobox("#configType", {
			valueField: 'id',
			textField: 'Desc',
			editable: true,
			data: GridData["rows"],
			filter: function (q, row) {
				return (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) || (row["Desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onSelect: function (rec) {
				LoadTemplate();

			},
			onChange: function (newValue, oldValue) {
				if (newValue != "") {
					LoadTemplate();
				}
			}
		});
	});
}
function LoadTemplate() {
	var Version = $('#configType').combobox('getValue');
	$.cm({
		ClassName: GV._CALSSNAME,
		QueryName: "getTemplate",
		Version: Version,
		HospitalID: HospitalID,
		rows: 99999
	}, function (GridData) {
		var cbox = $HUI.combobox("#templateCode", {
			valueField: 'Code',
			textField: 'CodeName',
			editable: true,
			data: GridData["rows"],
			filter: function (q, row) {
				return (row["CodeName"].toUpperCase().indexOf(q.toUpperCase()) >= 0) || (row["CodeName"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onLoadSuccess: function () {

			}
		});
	});
}
function LoadMethodType() {
	$.cm({
		ClassName: GV._CALSSNAME,
		QueryName: "getMethodType",
		desc: "",
		rows: 99999
	}, function (GridData) {
		var cbox = $HUI.combobox("#MethodType", {
			valueField: 'rw',
			textField: 'desc',
			editable: true,
			data: GridData["rows"],
			filter: function (q, row) {
				return (row["desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0) || (row["desc"].toUpperCase().indexOf(q.toUpperCase()) >= 0);
			},
			onLoadSuccess: function () {

			}
		});
	});
}
/**
 * @description �����б�ˢ��
 */
function vteGridReload() {
	var CurType = $('#configType').combobox('getValue');
	var template = $('#templateCode').combobox('getValue');
	var type = $('#type').combobox('getValue');
	var IfCancel = false;
	$('#gridVTE').datagrid('reload',
		{
			ClassName: GV._CALSSNAME,
			QueryName: "QueryVTEConfig",
			ConfigType: CurType,
			Template: template,
			TypeCode: type,
			IfCancel: IfCancel,
			HospDr: HospitalID
		});
}
/**
 * @description ��ѯ��Ϣ
 */
function vteDetailReload() {

	var ifExced = false;
	$("#vteDetail").datagrid('reload',
		{
			ClassName: GV._CALSSNAME,
			QueryName: "QueryVTEDetail",
			ParentId: GV.DetailParentId,
			IfCancel: ifExced
		});
}
/**
 * @description ִ�а�ť����
 */
function cancelVteBtnClick() {
	var rowsData = $HUI.datagrid('#gridVTE').getSelections();
	var BWIDs = "";
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		if (BWIDs == "") {
			BWIDs = rowData["id"];
		} else {
			BWIDs = BWIDs + "^" + rowData["id"];
		}
	}
	var UserId = session['LOGON.USERID'];
	if (BWIDs != "") {
		$.messager.confirm("ɾ��", "ȷ�����ϴ���Ŀ?", function (r) {
			if (r) {
				var ret = tkMakeServerCall(GV._CALSSNAME, "CancelVTEData", BWIDs, UserId);
				if (ret != 0) {
					$.messager.alert("��ʾ", ret, 'info');
				} else {
					$.messager.alert("��ʾ", "���ϳɹ�!", 'info');
					vteGridReload();
					GV.CurId = "";
				}
			}
		});
	} else {
		$.messager.popover({ msg: '��ѡ����Ŀ!', type: 'alert', timeout: 2000 });
	}
}
/**
 * @description ��������
 */
function saveVteData() {
	var CurType = $('#configType').combobox('getValue');
	if ((CurType == "")) {
		$.messager.alert("��ʾ", "��ѡ��汾����!", 'info');
		return;
	}
	var template = $("#templateCode").combobox('getValue');
	if ((template == "") && (CurType != 2)) {
		$.messager.alert("��ʾ", "��ѡ��ģ��!", 'info');
		return;
	}
	var typCode = $("#type").combobox('getValue');
	if (typCode == "") {
		$.messager.alert("��ʾ", "��ѡ��������!", 'info');
		return;
	}
	var HMCode = $("#HMCode").combobox('getValue');
	if (HMCode == "") {
		$.messager.alert("��ʾ", "��ѡ���¼������!", 'info');
		return;
	}
	var UserId = session['LOGON.USERID'];
	if ((CurType == 2)) template = "DHCNURTEM"
	var ret = tkMakeServerCall(GV._CALSSNAME, "SaveVTEConfigData", CurType, template, typCode, HMCode, UserId, "",HospitalID);
	if (ret == 0) {
		$.messager.alert("��ʾ", "����ɹ�!", 'info');
		vteGridReload();
	} else {
		$.messager.alert("��ʾ", ret, 'info');
	}
}
/**
 * @description �޸�����
 */
function editVteData() {
	if (GV.CurId == "") {
		$.messager.alert("��ʾ", "��˫��ĳ����¼������޸Ĳ���!", 'info');
		return;
	}
	var CurType = $('#configType').combobox('getValue');
	if ((CurType == "")) {
		$.messager.alert("��ʾ", "��ѡ��汾����!", 'info');
		return;
	}
	var template = $("#templateCode").combobox('getValue');
	if ((template == "") && (CurType != 2)) {
		$.messager.alert("��ʾ", "��ѡ��ģ��!", 'info');
		return;
	}
	var typCode = $("#type").combobox('getValue');
	if (typCode == "") {
		$.messager.alert("��ʾ", "��ѡ��������!", 'info');
		return;
	}
	var HMCode = $("#HMCode").combobox('getValue');
	if (HMCode == "") {
		$.messager.alert("��ʾ", "��ѡ���¼������!", 'info');
		return;
	}
	var UserId = session['LOGON.USERID'];
	if ((CurType == 2)) template = "DHCNURTEM"

	var ret = tkMakeServerCall(GV._CALSSNAME, "SaveVTEConfigData", CurType, template, typCode, HMCode, UserId, GV.CurId, HospitalID);
	if (ret == 0) {
		$.messager.alert("��ʾ", "����ɹ�!", 'info');
		vteGridReload();
		GV.CurId = "";
	} else {
		$.messager.alert("��ʾ", ret, 'info');
	}
}
/**
 * @description ����������ϸ
 */
function saveVteDetailData() {
	var resultInput = $("#resultInput").val();
	var MethodType = $("#MethodType").combobox('getValue');
	if (MethodType == "") {
		$.messager.alert("��ʾ", "�������Ͳ���Ϊ��!", 'info');
		return;
	}

	var UserId = session['LOGON.USERID'];

	var ret = tkMakeServerCall(GV._CALSSNAME, "SaveVTEDetailData", GV.DetailParentId, resultInput, MethodType, UserId, "");
	if (ret == 0) {
		$.messager.alert("��ʾ", "����ɹ�!", 'info');
		vteDetailReload();
	} else {
		$.messager.alert("��ʾ", ret, 'info');
	}
}
/**
 * @description ִ�а�ť����
 */
function cancelVteDetailBtnClick() {
	var rowsData = $HUI.datagrid('#vteDetail').getSelections();
	var BWIDs = "";
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		if (BWIDs == "") {
			BWIDs = rowData["id"];
		} else {
			BWIDs = BWIDs + "^" + rowData["id"];
		}
	}
	var UserId = session['LOGON.USERID'];
	if (BWIDs != "") {
		$.messager.confirm("ɾ��", "ȷ�����ϴ���Ŀ?", function (r) {
			if (r) {
				var ret = tkMakeServerCall(GV._CALSSNAME, "CancelVTEDetailData", BWIDs, UserId);
				if (ret != 0) {
					$.messager.alert("��ʾ", ret, 'info');
				} else {
					$.messager.alert("��ʾ", "���ϳɹ�!", 'info');
					vteDetailReload();
				}
			}
		});
	} else {
		$.messager.popover({ msg: '��ѡ����Ŀ!', type: 'alert', timeout: 2000 });
	}
}
/**
 * @description ִ�а�ť����
 */
function EditVteDetailData() {
	var rowsData = $HUI.datagrid('#vteDetail').getSelections();
	var BWIDs = "";
	for (var i = 0; i < rowsData.length; i++) {
		var rowData = rowsData[i];
		if (BWIDs == "") {
			BWIDs = rowData["id"];
		} else {
			BWIDs = BWIDs + "^" + rowData["id"];
		}
	}
	if (BWIDs == "") {
		$.messager.alert("��ʾ", "��ѡ���¼!", 'info');
		return;
	}
	var resultInput = $("#resultInput").val();
	var MethodType = $("#MethodType").combobox('getValue');
	if (MethodType == "") {
		$.messager.alert("��ʾ", "�������Ͳ���Ϊ��!", 'info');
		return;
	}

	var UserId = session['LOGON.USERID'];
	var ret = tkMakeServerCall(GV._CALSSNAME, "SaveVTEDetailData", GV.DetailParentId, resultInput, MethodType, UserId, BWIDs);
	if (ret == 0) {
		$.messager.alert("��ʾ", "�޸ĳɹ�!", 'info');
		vteDetailReload();
	} else {
		$.messager.alert("��ʾ", ret, 'info');
	}
}
