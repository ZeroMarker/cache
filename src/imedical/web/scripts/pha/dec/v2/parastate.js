/**
 * @ģ��:     ��ҩ���̶���ά��
 * @��д����: 2019-06-04
 * @��д��:   pushuangcai
 */
var HospId = session['LOGON.HOSPID'];
PHA_COM.App.ProCode = "DEC"
PHA_COM.App.ProDesc = "��ҩ��"
PHA_COM.App.Csp = "pha.dec.v2.parastate.csp"
PHA_COM.App.Name = "��ҩ���̶���ά��"

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
			queryData();
		}
	});
	InitHospCombo();
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
				/*editor: {
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
				},*/
				formatter: function (value, row, index) {
					if (value == "I") {
						return $g("סԺ");
					} else if (value == "O") {
						return $g("�ż���");
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
			}, {
				field: 'nextProSysFlag',
				title: '��һ�����Ƿ�Ϊϵͳ����',
				align: 'left',
				hidden: true
			} 
		]];
	var dataGridOption = {
		toolbar: "#toolBarState",
		columns: columns,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.CfProSto.Query",
			QueryName: "QueryParaState",
			inputStr:'',
			userId: gUserID,
			HospId: HospId
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
                $('#gridParaState').datagrid('query');
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
		},
		onBeginEdit: function (rowIndex, rowData){
			if (rowData.nextProSysFlag === 'Y') {
			    var autoExe = $('#gridParaState').datagrid('getEditor', {
			        index: rowIndex,
			        field: 'sExeNextFlag'
			    });
			    $(autoExe.target).checkbox('disable');
			}
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
	var decType = $("#cmbType").combobox("getValue");
	if (decType == "") {
		PHA.Popover({
			msg: "����ʱ���Ͳ���Ϊȫ��������ѡ����",
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
			sActiveFlag: 'Y',
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
		params: inputStr,
		HospId: HospId
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
function queryData(){
	var type = $("#cmbType").combobox("getValue");
	var locId = $("#cmbDecLoc").combobox("getValue");
	$('#gridParaState').datagrid('query', {
		inputStr: locId + "^" + type,
		userId: gUserID,
		HospId: HospId
	});	
}

function InitHospCombo() {
	var genHospObj=DEC.AddHospCom({tableName:'PHA_DECProSto'});
	if (typeof genHospObj ==='object'){
        genHospObj.options().onSelect =  function(index, record) {	
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                //$('#cmbDecLoc').combobox('loadData', {});
                $("#cmbDecLoc").combobox("setValue",'');
                $('#cmbDecLoc').combobox('options').url = $URL + "?ResultSetType=Array&" + "ClassName=PHA.DEC.Com.Store&QueryName=DecLoc&HospId="+HospId+"&UserId=" + gUserID
				$('#cmbDecLoc').combobox('reload');
                $('#gridParaState').datagrid('options').queryParams.HospId =  HospId;
                $('#gridParaState').datagrid('options').queryParams.inputStr =  '';
                $('#gridParaState').datagrid('load');
            }
        }
    }
    
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'PHA_DECProSto',
            HospID: HospId
        },
        false
    );
    HospId = defHosp;
    $("#cmbDecLoc").combobox("setValue",'');
    $('#cmbDecLoc').combobox('options').url = $URL + "?ResultSetType=Array&" + "ClassName=PHA.DEC.Com.Store&QueryName=DecLoc&HospId="+HospId+"&UserId=" + gUserID
	$('#cmbDecLoc').combobox('reload');
    
}
