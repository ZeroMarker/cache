/**
 * @ģ��:     ��ҩ���̶���ά��
 * @��д����: 2019-06-04
 * @��д��:   pushuangcai
 */
$(function () {
	InitDict();
	InitGridParaState();
});

/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
	PHA.ComboBox("cmbDecLoc", {
		url: PHA_DEC_STORE.DecLoc().url,
		onSelect: function (selData) {
			queryData();
		}
	});
	PHA.ComboBox("cmbType", {
		width: 100,
		data: [{
				"RowId": "",
				"Description": "ȫ��"
			}, {
				"RowId": "I",
				"Description": "סԺ"
			}, {
				"RowId": "O",
				"Description": "����"
			}
		],
		onSelect: function (selData) {
			queryData();
		}
	});
}
/**
 * ��ʼ�����̱��
 * @method InitGridParaState
 */
function InitGridParaState() {
	var columns = [[{
				field: 'sRowId',
				title: 'sRowId',
				sortable: true,
				width: 100,
				hidden: true
			}, {
				field: 'sLocId',
				title: 'sLocId',
				align: 'center',
				width: 100,
				hidden: true,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'sLocDesc',
				title: '��ҩ������',
				align: 'left',
				width: 200
			}, {
				field: 'sType',
				title: '����',
				align: 'left',
				width: 100,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'id',
						textField: 'text',
						required: true,
						blurValidValue: true,
						data: [{
								"id": "I",
								"text": "סԺ"
							}, {
								"id": "O",
								"text": "����"
							}
						]
					}
				},
				formatter: function (value, row, index) {
					if (value == "I") {
						return "סԺ";
					} else if (value == "O") {
						return "����";
					}else{
						return value;
					}
				}
			}, {
				field: 'sProDictId',
				title: '����id',
				align: 'left',
				hidden: true
			}, {
				field: 'sGId',
				title: '���̱�ʶ',
				hidden: true ,
				align: 'center'
			}, {
				field: 'sProDict',
				title: '��������',
				align: 'left',
				width: 180,
				editor: {
					type: 'combogrid',
					options: {
						url: LINK_CSP + '?ClassName=PHA.DEC.Com.Store&MethodName=DecProDict&locId=' + gLocId,
						blurValidValue: true,
						required: true,
						idField: 'Description',
						textField: 'Description',
						method: 'get',
						columns: columns,
						fitColumns: true,
						columns: [[{
									field: 'RowId',
									title: 'RowId',
									hidden: true
								}, {
									field: 'gId',
									title: '���̱�ʶ',
									align: 'center'
								}, {
									field: 'Description',
									title: '��������',
									align: 'center'
								}
							]],
						onSelect: function (rowIndex, rowData) {
							var selRow = $('#gridParaState').datagrid('getSelected');
							selRow.sProDictId = rowData.RowId;
							selRow.sProDictCode = rowData.gId;
						}
					}
				}
			}, {
				field: 'sActiveFlag',
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
			, {
				field: 'sExeNextFlag',
				title: '�Զ�ִ����һ����',
				align: 'left',
				width: 140,
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
			}, {
				field: 'sSeqNo',
				title: '˳���',
				align: 'left',
				hidden: false
			}, 
		]];
	var dataGridOption = {
		toolbar: "#toolBarState",
		columns: columns,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.CfProSto.Query",
			QueryName: "QueryParaState",
			userId: gUserID
		},
		onDblClickRow: function (rowIndex) {
			editRow();
		},
		onDrop:function(){
            var stateIdStr="";
            var rows=$("#gridParaState").datagrid("getRows");
            var rowsLen=rows.length;
            for (var i=0;i<rowsLen;i++){
                var sRowId=rows[i].sRowId;
                stateIdStr=(stateIdStr=="")?sRowId:stateIdStr+"^"+sRowId;
            }
            var saveRet = $.cm({
                ClassName: 'PHA.DEC.CfProSto.OperTab',
                MethodName: 'ReBuildSortCode',
                DataStr: stateIdStr,
                dataType: 'text',
            }, false);
            var saveArr = saveRet.split('^');
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal < 0) {
                PHA.Popover({
                    msg: saveInfo,
                    type: 'alert'
                });
            }
            else{
	            $('#gridParaState').datagrid('query');
	        }
        },
		onLoadSuccess: function () {
            $("#gridParaState").datagrid("enableDnd"); // ��������ӵ�Ԫ��༭,�г�ͻ
        },
        onRowContextMenu: function(){
			return false;	
		}
	};
	PHA.Grid("gridParaState", dataGridOption);
}
/**
 * ����һ������
 * @method addNewRow
 */
function addNewRow() {
	var locId = $("#cmbDecLoc").combobox("getValue");
	if (!locId) {
		PHA.Popover({
			msg: "����ѡ���ҩ�ң�",
			type: 'alert'
		});
		return;
	}
	$("#gridParaState").datagrid('addNewRow', {
		editField: 'sType',
		defaultRow: {
			sLocId: $("#cmbDecLoc").combobox("getValue"),
			sLocDesc: $("#cmbDecLoc").combobox("getText"),
			sType: $("#cmbType").combobox("getValue"),
			sActiveFlag: 'N',
			sExeNextFlag: 'N'
		}
	});
}
/**
 * �����б༭
 * @method editRow
 */
function editRow() {
	$('#gridParaState').datagrid('endEditing');
	var selRow = $('#gridParaState').datagrid('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: "����ѡ��Ҫ�༭�����ݣ�",
			type: 'alert'
		});
		return;
	}
	var rowIndex = $('#gridParaState').datagrid('getRowIndex', selRow);
	$('#gridParaState').datagrid('beginEditRow', {
		rowIndex: rowIndex,
	});
}
/**
 * ��������
 * @method saveParaState
 */
function saveParaState() {
	$('#gridParaState').datagrid('endEditing');
	var gridChanges = $('#gridParaState').datagrid('getChanges');
	var inputStr = "";
	for (var i in gridChanges) {
		var iData = gridChanges[i];
		var sRowId = iData.sRowId || "";
		var locId = iData.sLocId || "";
		var type = iData.sType || "";
		var proDict = iData.sProDictId || "";
		var activeFlag = iData.sActiveFlag || "";
		var exeNextFlag = iData.sExeNextFlag || "";
		var rowNum = ($('#gridParaState').datagrid("getRowIndex",iData)+1)	
		var param = sRowId + "^" + locId + "^" + type + "^" + proDict + "^" + activeFlag + "^" + gUserID + "^" + exeNextFlag +"^"+rowNum;
		inputStr = inputStr == "" ? param : inputStr + "!!" + param;
	}
	if (inputStr == "") {
		PHA.Popover({
			msg: "û����Ҫ��������ݣ�",
			type: 'alert'
		});
		return;
	}
	$cm({
		ClassName: "PHA.DEC.CfProSto.OperTab",
		MethodName: "saveParaState",
		params: inputStr
	},
		function (jsonData) {
		if (typeof(jsonData) == "String") {
			jsonData = JSON.parse(jsonData);
		}
		if (jsonData.result == 'true') {
			PHA.Popover({
				msg: "����ɹ���",
				type: 'success'
			});
			$('#gridParaState').datagrid('query');
		} else {
			PHA.Popover({
				msg: "����ʧ�ܣ�" + jsonData.errCode,
				type: 'alert'
			});
		}
	});
}
/**
 * ��ѯ����
 * @method queryData
 */
function queryData(){
	var type = $("#cmbType").combobox("getValue");
	var locId = $("#cmbDecLoc").combobox("getValue");
	$('#gridParaState').datagrid('query', {
		inputStr: locId + "^" + type,
		userId: gUserID
	});	
}