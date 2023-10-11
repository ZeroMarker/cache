/**
 * @ģ��:     ҩ������ά��
 * @��д����: 2020-10-16
 * @��д��:   MaYuqiang
 */
var HospId = session['LOGON.HOSPID'];
var GRIDID = 'gridProcess';

$(function () {
	InitDict();
	InitGridProcess();
	InitHospCombo();
});

/**
 * ��ʼ�����
 * @method InitDict
 */
function InitDict() {
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_STORE.Pharmacy().url,
		width: 160,
		onSelect: function (selData) {
			QueryData();
		}
	});
	PHA.ComboBox("cmbType", {
		width: 100,
		data: [{
				"RowId": "",
				"Description": $g("ȫ��")
			}, {
				"RowId": "I",
				"Description": $g("סԺ")
			}, {
				"RowId": "O",
				"Description": $g("�ż���")
			}
		],
		onSelect: function (selData) {
			QueryData();
		}
	});
}


/**
 * ��ʼ�����̱��
 * @method InitgridProcess
 */
function InitGridProcess() {
	var columns = [[{
				field: 'RowId',
				title: 'RowId',
				sortable: true,
				width: 100,
				hidden: false
			}, {
				field: 'PhaLocId',
				title: 'PhaLocId',
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
				field: 'PhaLocDesc',
				title: 'ҩ������',
				align: 'left',
				width: 200
			}, {
				field: 'Type',
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
								"text": $g("סԺ")
							}, {
								"id": "O",
								"text": $g("�ż���")
							}
						]
					}
				},
				formatter: function (value, row, index) {
					if (value == "I") {
						return  $g("סԺ");
					} else if (value == "O") {
						return  $g("�ż���");
					}else{
						return value;
					}
				}
			}, {
				field: 'ProDictId',
				title: '����id',
				align: 'left',
				hidden: false
			}, {
				field: 'ProDictDesc',
				title: '��������',
				align: 'left',
				width: 120,
				editor: {
					type: 'combogrid',
					options: {
						url: LINK_CSP + '?ClassName=PHA.SYS.Process.Query&MethodName=StkComDictionary&ScdType=' + 'Disp',
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
									field: 'Code',
									title: '���̴���',
									width: 150,
									align: 'center',
									hidden: true
								}, {
									field: 'Description',
									title: '��������',
									width: 150,
									align: 'center'
								}
							]],
						onSelect: function (rowIndex, rowData) {
							var selRow = $('#gridProcess').datagrid('getSelected');
							selRow.ProDictId = rowData.RowId;
							//selRow.sProDictCode = rowData.proCode;
						}
					}
				}
			}, {
				field: 'ActiveFlag',
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
				field: 'DispFlag',
				title: '������ʶ',
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
				field: 'SeqNo',
				title: '˳���',
				align: 'left',
				hidden: false
			}, 
		]];
	var dataGridOption = {
		toolbar: "#toolBarProcess",
		columns: columns,
		url: $URL,
		queryParams: {
			ClassName: "PHA.SYS.Process.Query",
			QueryName: "QueryProcess",
			Params:'',
			HospId: HospId
		},
		onDblClickRow: function (rowIndex) {
			EditRow();
		},
		onDrop:function(){
            var proIdStr="";
            var rows=$("#gridProcess").datagrid("getRows");
            var rowsLen=rows.length;
            for (var i=0;i<rowsLen;i++){
                var sRowId=rows[i].RowId;
                proIdStr=(proIdStr=="")?sRowId:proIdStr+"^"+sRowId;
            }
            var saveRet = $.cm({
                ClassName: 'PHA.SYS.Process.Save',
                MethodName: 'ReBuildSortCode',
                Params: proIdStr,
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
	            $('#gridProcess').datagrid('query');
	        }
        },
		onLoadSuccess: function () {
            $("#gridProcess").datagrid("enableDnd"); // ��������ӵ�Ԫ��༭,�г�ͻ
        },
        onRowContextMenu: function(){
			return false;	
		}
	};
	PHA.Grid("gridProcess", dataGridOption);
}
/**
 * ����һ������
 * @method addNewRow
 */
function AddNewRow() {
	var locId = $("#cmbPhaLoc").combobox("getValue");
	if (!locId) {
		PHA.Popover({
			msg: "����ѡ��ҩ�����ң�",
			type: 'alert'
		});
		return;
	}
	$("#gridProcess").datagrid('addNewRow', {
		editField: 'Type',
		defaultRow: {
			PhaLocId: $("#cmbPhaLoc").combobox("getValue"),
			PhaLocDesc: $("#cmbPhaLoc").combobox("getText"),
			Type: $("#cmbType").combobox("getValue"),
			ActiveFlag: 'Y',
			DispFlag: 'N'
		}
	});
}
/**
 * �����б༭
 * @method editRow
 */
function EditRow() {
	$('#gridProcess').datagrid('endEditing');
	var selRow = $('#gridProcess').datagrid('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: "����ѡ��Ҫ�༭�����ݣ�",
			type: 'alert'
		});
		return;
	}
	var processDesc = selRow.ProDictDesc;
	var proRowId = selRow.RowId;
	if (processDesc === $g("��ȡ����")&&(proRowId !== "")&&(typeof proRowId !== 'undefined')) {
		PHA.Popover({
			msg: "'��ȡ����'Ϊ�ƶ���ϵͳ���̣��������޸ģ�",
			type: 'alert'
		});
		return;
	}
	var rowIndex = $('#gridProcess').datagrid('getRowIndex', selRow);
	$('#gridProcess').datagrid('beginEditRow', {
		rowIndex: rowIndex,
	});
}
/**
 * ��������
 * @method saveParaState
 */
function SaveProcess() {
	//$('#gridProcess').datagrid('endEditing');
	if (!PHA_GridEditor.EndCheck(GRIDID)) return;
	var gridChanges = $('#gridProcess').datagrid('getChanges');
	var inputStr = "";
	for (var i in gridChanges) {
		var iData = gridChanges[i];
		var RowId = iData.RowId || "";
		var PhaLocId = iData.PhaLocId || "";
		var Type = iData.Type || "";
		if (Type == ""){
			PHA.Popover({msg: "���Ͳ���Ϊ��", type: 'alert'});
			return ;
		}
		var ProDictId = iData.ProDictId || "";
		if (ProDictId == ""){
			PHA.Popover({msg: "�������Ʋ���Ϊ��", type: 'alert'});
			return ;
		}
		var ActiveFlag = iData.ActiveFlag || "";
		var DispFlag = iData.DispFlag || "";
		var SeqNo=iData.SeqNo||"" ;
		
		//var rowNum = ($('#gridProcess').datagrid("getRowIndex",iData)+1)	
		var param = RowId + "^" + ProDictId + "^" + PhaLocId + "^" + DispFlag + "^" + ActiveFlag + "^" + Type ;
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
		ClassName: "PHA.SYS.Process.Save",
		MethodName: "SaveBatch",
		Params: inputStr,
		HospId: HospId
	},
	function (jsonData) {
		if (typeof(jsonData) == "String") {
			jsonData = JSON.parse(jsonData);
		}
		if (jsonData.retCode == '0') {
			PHA.Popover({
				msg: "����ɹ���",
				type: 'success'
				
			});
			$('#gridProcess').datagrid('query');
		} else {
			PHA.Popover({
				msg: "����ʧ�ܣ�" + jsonData.retMessage,
				type: 'alert',
				timeout:5000
			});
		}
	});
}
/**
 * ��ѯ����
 * @method queryData
 */
function QueryData(){
	var type = $("#cmbType").combobox("getValue");
	var locId = $("#cmbPhaLoc").combobox("getValue");
	$('#gridProcess').datagrid('query', {
		Params: locId + "^" + type,
		HospId: HospId
	});	
}


function InitHospCombo() {
	var genHospObj = HERB.AddHospCom({tableName:'CF_PHA_IN.Process'}, {width:308});
	if (typeof genHospObj ==='object'){
		genHospObj.options().onSelect =  function(index, record) {
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
				$("#cmbPhaLoc").combobox("setValue",'');
                $('#cmbPhaLoc').combobox('options').url = $URL + "?ResultSetType=Array&" + "ClassName=PHA.STORE.Org&QueryName=Pharmacy&HospId="+HospId+"&Type=" + ""
				$('#cmbPhaLoc').combobox('reload');
                $('#gridProcess').datagrid('query', {
					Params: "",
					HospId: newHospId
				});
            }
        };
    }
    var defHosp = $.cm(
		{
		    dataType: 'text',
		    ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
		    MethodName: 'GetDefHospIdByTableName',
		    tableName: 'CF_PHA_IN.Process',
		    HospID: HospId
		},
		false
	);
	HospId = defHosp; 
	/*
	$('#gridProcess').datagrid('query', {
		Params: "",
		HospId: HospId
	});
	*/
}


//��������
window.onload=function(){
	setTimeout("QueryData()", 500);
	
}
