/**
 * ģ��:	 ��ҩ������
 * ��ģ��:	 ��ҩ�����ֵ�ά��
 * ��д��:	 hulihua
 * ��д����: 2019-06-18
 */

$(function () {
	InitGridProDict();
});

// ���-�����ֵ�
function InitGridProDict() {
	var columns = [
		[{
				field: "TDictId",
				title: '�����ֵ�Id',
				hidden: true,
				width: 100
			}, {
				field: "TDictCode",
				title: '����',
				width: 250,
				align: "left",
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: "TDictDesc",
				title: '����',
				width: 400,
				align: "left",
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: "TDictNumber",
				title: '��ʶ��',
				width: 250,
				hidden: true ,
				align: "left",
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: 'TSysFlag',
				title: 'ϵͳ����',
				align: 'left',
				width: 250,
				disable: true ,
				/*
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N',
						required: true
					}
				},*/
				formatter: function (value, row, index) {
					if (value == "Y") {
						return '<input type="checkbox"  class="checkbox-f" style="display: none;"><label class="checkbox disabled checked"></label>'
						
					} else {
						return '<input type="checkbox"  class="checkbox-f" style="display: none;"><label class="checkbox disabled"></label>'
					}
				}
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.DEC.CfProDict.Query',
			QueryName: 'QueryProDict'
		},
		pagination: false,
		columns: columns,
		shrinkToFit: true,
		exportXls: false,
		toolbar: "#gridProDictBar",
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
		},
		onDblClickRow: function (rowIndex) {
			$('#gridProDict').datagrid('beginEditRow', {
				rowIndex: rowIndex
			});
		},
		onLoadSuccess:function(){

		}
	};
	PHA.Grid("gridProDict", dataGridOption);
}

// ����
function Add() {
	$("#gridProDict").datagrid('addNewRow', {});
}

// �޸�
function Update(){
	$('#gridProDict').datagrid('endEditing');
	var selRow = $('#gridProDict').datagrid('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: "����ѡ��Ҫ�޸ĵ����ݣ�",
			type: 'alert'
		});
		return;
	}
	var rowIndex = $('#gridProDict').datagrid('getRowIndex', selRow);
	$('#gridProDict').datagrid('beginEditRow', {
		rowIndex: rowIndex,
	});
}

// ����
function Save() {
	$('#gridProDict').datagrid('endEditing');
	var gridChanges = $('#gridProDict').datagrid('getChanges');
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
		var params = $.trim(iData.TDictId || "") + "^" + $.trim(iData.TDictCode || "") + "^" + $.trim(iData.TDictDesc || "") + "^" + $.trim(iData.TDictNumber) + "^" + $.trim(iData.TSysFlag);
		//alert("params:"+params)
		inputStrArr.push(params)
	}
	
	var inputStr = inputStrArr.join("!!");
	
	var saveRet = $.cm({
			ClassName: 'PHA.DEC.CfProDict.OperTab',
			MethodName: 'SaveBatch',
			MultiDataStr: inputStr,
			dataType: 'text',
		}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, "-4");
		return;
	} else {
		PHA.Popover({
			msg: '����ɹ�',
			type: 'success'
		});
	}
	$('#gridProDict').datagrid("reload");
}
