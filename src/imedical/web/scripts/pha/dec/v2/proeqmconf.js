/**
 * ģ��:	 ��ҩ������
 * ��ģ��:	 ��ҩ�豸ά��
 * ��д��:	 guofa	 
 * ��д����: 2019-07-10
 */

var HospId = session['LOGON.HOSPID'];
PHA_COM.App.ProCode = "DEC"
PHA_COM.App.ProDesc = "��ҩ��"
PHA_COM.App.Csp = "pha.dec.v2.proeqmconf.csp"
PHA_COM.App.Name = "��ҩ�豸ά��"

$(function () {
	InitDict();
	InitGridEquipment();
	$("#equipCode").keydown(function(event){
		QueryEqm(event.keyCode);
	});
	$("#equipDesc").keydown(function(event){
		QueryEqm(event.keyCode);
	});
});
/**
* ��װ��ѯ����
* method QueryEqm
*/
function QueryEqm(e){
	if((e==undefined)||(e==13)){
		var status = $("#cmbEquipStatus").combobox("getValue");
		var locId = $("#cmbDecLoc").combobox("getValue");
		var eqmCode = $.trim($("#equipCode").val());
		var eqmDesc = $.trim($("#equipDesc").val());
		$('#gridEquipment').datagrid('query', {
			inputStr: locId + "^" + status + "^" + eqmCode + "^" + eqmDesc ,
			HospId: HospId
		});	
	}			
}
/**
 * ��ʼ�����
 * method InitDict
 */
function InitDict() {
	PHA.ComboBox("cmbDecLoc", {
		url: PHA_DEC_STORE.DecLoc().url,
		onSelect: function () {
			QueryEqm();
		}
	}); 
	PHA.ComboBox("cmbEquipStatus", {
		width: 100,
		data: [	{"RowId": "", "Description": "ȫ��"	},
				{"RowId": "R", "Description": "ά��" },
			   	{"RowId": "S", "Description": "����" },
			   	{"RowId": "T", "Description": "��ͣ" },
			   	{"RowId": "Y", "Description": "����" }],
		onSelect: function () {
			QueryEqm();
		}
	});	
	
	InitHospCombo();
}

function InitHospCombo() {
	var genHospObj=DEC.AddHospCom({tableName:'PHA_DECEquiMai'});
	if (typeof genHospObj ==='object'){
        genHospObj.options().onSelect =  function(index, record) {	
            var newHospId = record.HOSPRowId;
            if (newHospId != HospId) {
                HospId = newHospId;
                //$('#cmbDecLoc').combobox('loadData', {});
                $("#cmbDecLoc").combobox("setValue",'');
                $('#cmbDecLoc').combobox('options').url = $URL + "?ResultSetType=Array&" + "ClassName=PHA.DEC.Com.Store&QueryName=DecLoc&HospId="+HospId+"&UserId=" + gUserID
				$('#cmbDecLoc').combobox('reload');
                $('#gridEquipment').datagrid('options').queryParams.HospId =  HospId;
                $('#gridEquipment').datagrid('options').queryParams.inputStr =  '';
                $('#gridEquipment').datagrid('load');
            }
        }
    }
    
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'PHA_DECEquiMai',
            HospID: HospId
        },
        false
    );
    HospId = defHosp;
    $("#cmbDecLoc").combobox("setValue",'');
    $('#cmbDecLoc').combobox('options').url = $URL + "?ResultSetType=Array&" + "ClassName=PHA.DEC.Com.Store&QueryName=DecLoc&HospId="+HospId+"&UserId=" + gUserID
	$('#cmbDecLoc').combobox('reload');
}
/**
 * ��ʼ�����̱��
 * method InitGridEquipment
 */
function InitGridEquipment() {
	var columns = [[{
				field: 'eqmRowId',
				title: 'eqmRowId',
				sortable: true,
				width: 100,
				hidden: true
			}, {
				field: 'sLocId',
				title: 'sLocId',
				align: 'center',
				width: 200,
				hidden: true,
				editor: {
					type: 'validatebox',
					options: {
						required: true
					}
				}
			}, {
				field: 'sLocDesc',
				title: '��ҩ��',
				align: 'left',
				width: 180
			}, {
				field: 'sEqmCode',
				title: '�豸����',
				align: 'left',
				width: 180,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: 'sEqmDesc',
				title: '�豸����',
				align: 'left',
				width: 180,
				editor: {
					type: 'validatebox',
					options: {
						required: false
					}
				}
			}, {
				field: 'sEqmStatus',
				title: '�豸״̬',
				align: 'left',
				width: 180,
				editor: {
					type: 'combobox',
					options: {
						valueField: 'id',
						textField: 'text',
						required: false,
						blurValidValue: true,
						data: [{
								"id": "R",
								"text": "ά��"
							}, {
								"id": "S",
								"text": "����"
							}, {
								"id": "T",
								"text": "��ͣ"
							},{
								"id": "Y",
								"text": "����"
							}
						]
					}
				},
				formatter: function (value, row, index) {
					if(value==""){return;}
					if (value == "R") {
						row.sActiveFlag="N";
						return "ά��";
					} else if (value == "S") {
						row.sActiveFlag="N";
						return "����";
					} else if (value == "T"){
						row.sActiveFlag="N";
						return "��ͣ"
					}else{
						row.sActiveFlag="Y";
						return "����"
					}
				}
			},  {
				field: 'sActiveFlag',
				title: '�Ƿ�ʹ��',
				align: 'left',
				width: 100,
				editor: {
					type: 'icheckbox',
					options: {
						on: 'Y',
						off: 'N',
						required: true,
						disabled: true
					}
				},
				formatter: function (value, row, index) {
					if (row.sEqmStatus=="Y") {
						row.sActiveFlag="Y";
						return "��";		//PHA_COM.Fmt.Grid.Yes.Icon;
					} else {
						row.sActiveFlag="N";
						return "��";		//PHA_COM.Fmt.Grid.No.Icon;
					}
				}
			}
		]];
	var dataGridOption = {
		toolbar: "#toolBarState",
		columns: columns,
		url: $URL,
		queryParams: {
			ClassName: "PHA.DEC.CfEqMai.Query",
			QueryName: "QueryEquipment",
			inputStr: "^^^",
			HospId: HospId
		},
		onDblClickRow: function (rowIndex) {
			editRow();
		},
        onRowContextMenu: function(){
			return false;	
		}
	};
	PHA.Grid("gridEquipment", dataGridOption);
}
/**
 * ����һ������
 * method addNewRow
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
	$("#gridEquipment").datagrid('addNewRow', {
		editField: 'sEqmStatus',
		defaultRow: {
			sLocId: $("#cmbDecLoc").combobox("getValue"),
			sLocDesc: $("#cmbDecLoc").combobox("getText"),
			//sStatusId: $("#cmbEquipStatus").combobox("getValue"),
			sEqmStatus: $("#cmbEquipStatus").combobox("getValue"),	//$("#cmbEquipStatus").combobox("getText"),
			sEqmCode: $.trim($("#equipCode").val()), 
		    sEqmDesc: $.trim($("#equipDesc").val()),
			sActiveFlag: 'N'
		}
	});
}
/**
 * �����б༭
 * method editRow
 */
function editRow() {
	$('#gridEquipment').datagrid('endEditing');
	var selRow = $('#gridEquipment').datagrid('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: "����ѡ��Ҫ�༭�����ݣ�",
			type: 'alert'
		});
		return;
	}
	var rowIndex = $('#gridEquipment').datagrid('getRowIndex', selRow);
	$('#gridEquipment').datagrid('beginEditRow', {
		rowIndex: rowIndex,
	});
}
/**
 * ��������
 * method saveEquip
 */
function saveEquip() {
	$('#gridEquipment').datagrid('endEditing');
	var gridChanges = $('#gridEquipment').datagrid('getChanges')
	var inputStr = "";
	for(var i in gridChanges){
		var iData = gridChanges[i];
		var eqmRowId = iData.eqmRowId || "";
		var locId = iData.sLocId || "";
		var sEqmCode = iData.sEqmCode || "";
		var sEqmDesc = iData.sEqmDesc || "";
		var sEqmStatus = iData.sEqmStatus || "";
		var activeFlag = iData.sActiveFlag || "";
		var Number = ($('#gridEquipment').datagrid("getRowIndex",iData)+1)	
		var param = eqmRowId + "^" + locId + "^" + sEqmCode + "^" + sEqmDesc + "^" + sEqmStatus + "^" + activeFlag +"^"+ Number;
		inputStr = inputStr==""?param : inputStr + "!!" + param;
	}
	if (inputStr=="") {
		PHA.Popover({
			msg: "û����Ҫ��������ݣ�",
			type: 'alert'
		});
		return;
	}
	$cm({
		ClassName: "PHA.DEC.CfEqMai.OperTab",
		MethodName: "saveEquip",
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
			$('#gridEquipment').datagrid('query');
		} else {
			PHA.Popover({
				msg: "����ʧ�ܣ�" + jsonData.errCode,
				type: 'alert'
			});
		}
	});
}
