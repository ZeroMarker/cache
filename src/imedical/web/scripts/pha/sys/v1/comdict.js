/**
 * ����:	 ҩ������-ϵͳ����-���������ֵ�ά��
 * ��д��:	 yunhaibao
 * ��д����: 2019-08-16
 */
PHA_COM.App.Csp = "pha.sys.v1.comdict.csp";
PHA_COM.App.Name = "SYS.COMDICT";
$(function () {
	PHA.SearchBox("conQText", {
		width: parseInt($("#treegridDHCPHCCatBar").width()) - 20,
		searcher: function (text) {
			$("#gridComDict").datagrid("query", {
				QText: text.trim()
			});
			$(this).searchbox("clear");
			$(this).next().children().focus();
		},
		placeholder: " ģ������..."
	});
	InitGridComDict();
	InitEvents();
});

// ���-��Ʒ��
function InitGridComDict() {
	var columns = [
		[{
				field: "scdiId",
				title: 'scdiId',
				hidden: true,
				width: 100
			},
			{
				field: "scdiCode",
				title: '����ֵ',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			},
			{
				field: "scdiDesc",
				title: '����ֵ����',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: "scdiType",
				title: '���ʹ���',
				width: 200,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: "scdiTypeDesc",
				title: '��������',
				width: 400,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.SYS.ComDict.Query',
			QueryName: 'DHCStkComDictionary'
		},
		columns: columns,
		shrinkToFit: true,
		toolbar: "#gridComDictBar",
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
			// $("[datagrid-row-index="+rowIndex+"]").css("background","red")
		},
		onDblClickCell: function (rowIndex, field, value) {
			$(this).datagrid('beginEditCell', {
				index: rowIndex,
				field: field
			});
		}
	};
	PHA.Grid("gridComDict", dataGridOption);
}


// �¼�
function InitEvents() {
	$("#btnAdd").on("click", function () {
		$("#gridComDict").datagrid('addNewRow', {});
	})
	$("#btnSave").on("click", function () {
		Save();
	});
	$("#btnDelete").on("click", Delete);
}

// ����
function Save() {
	$('#gridComDict').datagrid('endEditing');
	var gridChanges = $('#gridComDict').datagrid('getChanges');
	var gridDelChanges= $('#gridComDict').datagrid('getChanges','deleted');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		PHA.Popover({
			msg: "û����Ҫ���������",
			type: 'alert'
		});
		return;
	}
	var inputStrArr = [];
	for (var i = 0; i < gridChangeLen; i++) {
		var iData = gridChanges[i];
		if (gridDelChanges.indexOf(iData)>=0){
			continue;
		}
		var params = (iData.scdiId || "") + "^" + (iData.scdiCode||"") + "^" + (iData.scdiDesc||"") + "^" + (iData.scdiType||"") + "^" + (iData.scdiTypeDesc||"");
		inputStrArr.push(params)
	}
	var inputStr = inputStrArr.join("!!");
	var saveRet = $.cm({
		ClassName: 'PHA.SYS.ComDict.Save',
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
		$('#gridComDict').datagrid("reload");
	}
}
// ɾ��
function Delete() {
	var gridSelect = $('#gridComDict').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "����ѡ����Ҫɾ���ļ�¼",
			type: "alert",
			timeout: 1000
		});
		return;
	}
	PHA.Confirm("ɾ����ʾ", "��ȷ��ɾ����?</br>���ݿ����ѱ�ʹ��,���������!", function () {
		var scdiId = gridSelect.scdiId || "";
		var rowIndex = $('#gridComDict').datagrid('getRowIndex', gridSelect);
		if (scdiId != "") {
			var saveRet = $.cm({
				ClassName: 'PHA.SYS.ComDict.Save',
				MethodName: 'Delete',
				Id: scdiId,
				dataType: 'text'
			}, false);
			var saveArr = saveRet.split('^');
			var saveVal = saveArr[0];
			var saveInfo = saveArr[1];
			if (saveVal < 0) {
				PHA.Alert('��ʾ', saveInfo, 'warning');
				return;
			} else {
				PHA.Popover({
					msg: 'ɾ���ɹ�',
					type: 'success'
				});
			}
		}
		$('#gridComDict').datagrid("deleteRow", rowIndex);
	});
}