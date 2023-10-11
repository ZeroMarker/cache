/**
 * ����:	 ҩ������-ϵͳ����-��Ʒ��ά��
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-19
 */
PHA_COM.App.Csp = "pha.sys.v1.pro.csp";
PHA_COM.App.Name = "SYS.PRO";
$(function () {
	InitGridPro();
	InitEvents();
});

// ���-��Ʒ��
function InitGridPro() {
	var columns = [
		[{
				field: "proId",
				title: '��Ʒ��Id',
				hidden: true,
				width: 100
			},
			{
				field: "proCode",
				title: '����',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: true,
						onEnter: function(){
							PHA_GridEditor.Next();
						}
					}
				}
			},
			{
				field: "proDesc",
				title: '����',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: true,
						onEnter: function(){
							PHA_GridEditor.Next();
						}
					}
				}
			},
			{
				field: "proActiveFlag",
				title: '����',
				width: 50,
				align: "center",
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: function (value, row, index) {
					if (value == "Y") {
						return PHA_COM.Fmt.Grid.Yes.Chinese;
					} else {
						return PHA_COM.Fmt.Grid.No.Chinese;
					}
				}
			}
		]
	];
	var dataGridOption = {
		// clickToEdit: false,
		// dblclickToEdit: true,
		url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.Pro.Query',
			QueryName: 'DHCStkSysPro'
		},
		pagination: false,
		columns: columns,
		shrinkToFit: true,
		toolbar: "#gridProBar",
		enableDnd: false,
		isAutoShowPanel: true,
		editFieldSort: ["proCode", "proDesc", "proActiveFlag"],
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
		},
		onDblClickCell: function (rowIndex, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridPro",
				index: rowIndex,
				field: field
			});
		}
	};
	PHA.Grid("gridPro", dataGridOption);
}

// ��ѯ
function Query(){
	$("#gridPro").datagrid("query",{})
}

// �¼�
function InitEvents() {
	$("#btnAddPro").on("click", function () {
		Add();
	})
	$("#btnSavePro").on("click", function () {
		Save();
	});
}

// ����-��Ʒ��
function Add(){
	// ��ֵ֤
	var chkRetStr = PHA_GridEditor.CheckValues('gridPro');
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	// ���
	PHA_GridEditor.Add({
		gridID: 'gridPro',
		field: 'proCode',
		rowData: {proActiveFlag:'Y'}
	});
}

// ����-��Ʒ��
function Save() {
	$('#gridPro').datagrid('endEditing');
	// ��ֵ֤
	var chkRetStr = PHA_GridEditor.CheckValues('gridPro');
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	// �ظ�����֤
	var chkRetStr = PHA_GridEditor.CheckDistinct({gridID:'gridPro', fields:['proCode']});
	if (chkRetStr != "") {
		PHA.Popover({msg: chkRetStr, type: "alert"});
		return;
	}
	// ��֤�Ƿ�ı�
	var gridChanges = $('#gridPro').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: "û����Ҫ��������ݣ�",
			type: 'alert'
		});
		return;
	}
	// �ַ���
	var inputStrArr = [];
	for (var i = 0; i < gridChangeLen; i++) {
		var iData = gridChanges[i];
		var params = (iData.proId || "") + "^" + (iData.proCode || "") + "^" + (iData.proDesc || "") + "^" + iData.proActiveFlag;
		inputStrArr.push(params)
	}
	var inputStr = inputStrArr.join("!!");
	var saveRet = $.cm({
		ClassName: 'PHA.SYS.Pro.Save',
		MethodName: 'SaveMulti',
		MultiDataStr: inputStr,
		dataType: 'text',
	}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, saveVal);
	} else {
		PHA.Popover({
			msg: '����ɹ�',
			type: 'success'
		});
	}
	$('#gridPro').datagrid("reload");
}