/**
 * ģ��:	 ��ҩ������
 * ��ģ��:	 Ƶ�ζ���ά��
 * ��д��:	 MaYuqiang
 * ��д����: 2021-01-03
 */

$(function () {
	InitDict();
	InitGridFreq();
});

/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
	/*
	PHA.ComboBox("cmbFreq", {
		url: PHA_STORE.PHCFreq().url,
		onSelect: function (selData) {
			queryData();
		}
	});
	*/
}

// ���-�����ֵ�
function InitGridFreq() {
	var columns = [
		[{
				field: "TPIFId",
				title: 'Ƶ�ζ���Id',
				hidden: true,
				width: 100
			},{
				field: "TFreqId",
				title: 'Ƶ��Id',
				hidden: true,
				width: 100
			}, {
				field: "TFreqCode",
				title: 'Ƶ�δ���',
				width: 250,
				align: "left"
			}, {
				field: "TFreqDesc",
				title: 'Ƶ������',
				width: 300,
				align: "left",
				editor: {
					type: 'combogrid',
					options: {
						url: LINK_CSP + '?ClassName=PHA.DEC.Com.Store&MethodName=GetFreqStore&QText=' + '' ,	//this.value
						blurValidValue: true,
						required: true,
						idField: 'freqDesc',
						textField: 'freqDesc',
						method: 'get',
						columns: columns,
						fitColumns: true,
						columns: [[{
									field: 'freqId',
									title: 'freqId',
									hidden: true
								}, {
									field: 'freqCode',
									title: 'Ƶ�δ���',
									align: 'center'
								}, {
									field: 'freqDesc',
									title: 'Ƶ������',
									align: 'center'
								}
							]],
						onSelect: function (rowIndex, rowData) {
							var selRow = $('#gridFreq').datagrid('getSelected');
							selRow.TFreqId = rowData.freqId;
							selRow.TFreqCode = rowData.freqCode;
						}
					}
				}
			},{
				field: "TFactor",
				title: 'ϵ��',
				hidden: false,
				width: 100,
				editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
			},{
				field: 'TActive',
				title: '�Ƿ�ʹ��',
				align: 'left',
				width: 100,
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N',
						required: true
					}
				},
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
			ClassName: 'PHA.DEC.CfFreq.Query',
			QueryName: 'QueryPIFFreq'
		},
		pagination: false,
		columns: columns,
		shrinkToFit: true,
		exportXls: false,
		toolbar: "#gridFreqBar",
		enableDnd: false,
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('endEditing');
		},
		onDblClickRow: function (rowIndex) {
			$('#gridFreq').datagrid('beginEditRow', {
				rowIndex: rowIndex
			});
		},
		onLoadSuccess:function(){

		}
	};
	PHA.Grid("gridFreq", dataGridOption);
}

// ����
function Add() {
	$("#gridFreq").datagrid('addNewRow', {
		defaultRow : {
			TPIFId : '',
			TFreqId : '',
			TFreqCode : '',
			TFreqDesc : '',
			TFactor : '',
			TActive : 'Y'
		}
	});
}

// ����
function Save() {
	$('#gridFreq').datagrid('endEditing');
	var gridChanges = $('#gridFreq').datagrid('getChanges');
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
		var params = $.trim(iData.TPIFId || "") + "^" + $.trim(iData.TFreqId || "") + "^" + $.trim(iData.TFactor || "") + "^" + $.trim(iData.TActive);
		inputStrArr.push(params)
	}
	
	var inputStr = inputStrArr.join("!!");
	var saveRet = $.cm({
			ClassName: 'PHA.DEC.CfFreq.OperTab',
			MethodName: 'SaveBatch',
			params: inputStr,
			dataType: 'text',
		}, false);
	var saveArr = saveRet.split('^');
	var saveVal = saveArr[0];
	var saveInfo = saveArr[1];
	if (saveVal < 0) {
		PHA.Alert('��ʾ', saveInfo, "-4");
		return ;
	} else {
		PHA.Popover({
			msg: '����ɹ�',
			type: 'success'
		});
	}
	$('#gridFreq').datagrid("reload");
}

// ����
function Delete() {
	var gridSelect = $('#gridFreq').datagrid('getSelected') || "";
	if (gridSelect == "") {
		PHA.Popover({
			msg: "����ѡ����Ҫɾ���Ķ�����Ϣ",
			type: "alert"
		});
		return;
	}
	
	var delInfo = "��ȷ��ɾ����?"
	PHA.Confirm("ɾ����ʾ", delInfo, function () {
		var pifId = gridSelect.TPIFId ;
		if (pifId == undefined) {
			var index=$('#gridFreq').datagrid('getRowIndex',gridSelect);
			$('#gridFreq').datagrid('deleteRow', index);
		}
		else {
			var deleteRet = $.cm({
				ClassName: 'PHA.DEC.CfFreq.OperTab',
				MethodName: 'Delete',
				pifId: pifId,
				dataType: 'text'
			}, false);
			var deleteArr = deleteRet.split('^');
			var deleteVal = deleteArr[0];
			var deleteInfo = deleteArr[1];
				
			if (deleteVal < 0) {
				PHA.Alert('��ʾ', deleteInfo, 'warning');
				return ;
			} else {
				PHA.Alert('��ʾ',"ɾ���ɹ�", 'success');
				
			}
			$('#gridFreq').datagrid("reload");
		}
	})
}


/**
 * ��ѯ����
 * @method queryData
 */
function queryData(){
	var freqDesc = $('#txtFreq').val();
	$('#gridFreq').datagrid('query', {
		inputStr: freqDesc
	});	
}
