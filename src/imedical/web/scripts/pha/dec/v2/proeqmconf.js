/**
 * 模块:	 煎药室配置
 * 子模块:	 煎药设备维护
 * 编写人:	 guofa	 
 * 编写日期: 2019-07-10
 */

var HospId = session['LOGON.HOSPID'];
PHA_COM.App.ProCode = "DEC"
PHA_COM.App.ProDesc = "煎药室"
PHA_COM.App.Csp = "pha.dec.v2.proeqmconf.csp"
PHA_COM.App.Name = "煎药设备维护"

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
* 封装查询代码
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
 * 初始化组件
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
		data: [	{"RowId": "", "Description": "全部"	},
				{"RowId": "R", "Description": "维修" },
			   	{"RowId": "S", "Description": "报废" },
			   	{"RowId": "T", "Description": "暂停" },
			   	{"RowId": "Y", "Description": "正常" }],
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
 * 初始化流程表格
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
				title: '煎药室',
				align: 'left',
				width: 180
			}, {
				field: 'sEqmCode',
				title: '设备代码',
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
				title: '设备描述',
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
				title: '设备状态',
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
								"text": "维修"
							}, {
								"id": "S",
								"text": "报废"
							}, {
								"id": "T",
								"text": "暂停"
							},{
								"id": "Y",
								"text": "正常"
							}
						]
					}
				},
				formatter: function (value, row, index) {
					if(value==""){return;}
					if (value == "R") {
						row.sActiveFlag="N";
						return "维修";
					} else if (value == "S") {
						row.sActiveFlag="N";
						return "报废";
					} else if (value == "T"){
						row.sActiveFlag="N";
						return "暂停"
					}else{
						row.sActiveFlag="Y";
						return "正常"
					}
				}
			},  {
				field: 'sActiveFlag',
				title: '是否使用',
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
						return "是";		//PHA_COM.Fmt.Grid.Yes.Icon;
					} else {
						row.sActiveFlag="N";
						return "否";		//PHA_COM.Fmt.Grid.No.Icon;
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
 * 新增一行数据
 * method addNewRow
 */
function addNewRow() {
	var locId = $("#cmbDecLoc").combobox("getValue");
	if (!locId) {
		PHA.Popover({
			msg: "请先选择煎药室！",
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
 * 进入列编辑
 * method editRow
 */
function editRow() {
	$('#gridEquipment').datagrid('endEditing');
	var selRow = $('#gridEquipment').datagrid('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: "请先选择要编辑的数据！",
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
 * 保存数据
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
			msg: "没有需要保存的数据！",
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
				msg: "保存成功！",
				type: 'success'
			});
			$('#gridEquipment').datagrid('query');
		} else {
			PHA.Popover({
				msg: "保存失败！" + jsonData.errCode,
				type: 'alert'
			});
		}
	});
}
