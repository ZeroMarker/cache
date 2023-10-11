/**
 * @模块:     煎药流程定制维护
 * @编写日期: 2019-06-04
 * @编写人:   pushuangcai
 */
var HospId = session['LOGON.HOSPID'];
PHA_COM.App.ProCode = "DEC"
PHA_COM.App.ProDesc = "煎药室"
PHA_COM.App.Csp = "pha.dec.v2.parastate.csp"
PHA_COM.App.Name = "煎药流程定制维护"

$(function () {
	InitDict();
	InitGridParaState();
});

/**
 * 初始化组件
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
				"Description": $g("全部")
			}, {
				"RowId": "I",
				"Description": $g("住院")
			}, {
				"RowId": "O",
				"Description": $g("门急诊")
			}
		],
		onSelect: function (selData) {
			queryData();
		}
	});
	InitHospCombo();
}


/**
 * 初始化流程表格
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
				title: '煎药室名称',
				align: 'left',
				width: 200
			}, {
				field: 'sType',
				title: '类型',
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
								"text": "住院"
							}, {
								"id": "O",
								"text": "门诊"
							}
						]
					}
				},*/
				formatter: function (value, row, index) {
					if (value == "I") {
						return $g("住院");
					} else if (value == "O") {
						return $g("门急诊");
					}else{
						return value;
					}
				}
			}, {
				field: 'sProDictId',
				title: '流程id',
				align: 'left',
				hidden: true
			}, {
				field: 'sGId',
				title: '流程标识',
				hidden: true ,
				align: 'center'
			}, {
				field: 'sProDict',
				title: '流程名称',
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
									title: '流程标识',
									align: 'center'
								}, {
									field: 'Description',
									title: '流程名称',
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
				title: '是否使用',
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
				title: '自动执行下一流程',
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
				title: '顺序号',
				align: 'left',
				hidden: false
			}, {
				field: 'nextProSysFlag',
				title: '下一流程是否为系统流程',
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
            $("#gridParaState").datagrid("enableDnd"); // 不能再添加单元格编辑,有冲突
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
 * 新增一行数据
 * @method addNewRow
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
	var decType = $("#cmbType").combobox("getValue");
	if (decType == "") {
		PHA.Popover({
			msg: "新增时类型不能为全部，请先选类型",
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
 * 进入列编辑
 * @method editRow
 */
function editRow() {
	$('#gridParaState').datagrid('endEditing');
	var selRow = $('#gridParaState').datagrid('getSelected');
	if (!selRow) {
		PHA.Popover({
			msg: "请先选择要编辑的数据！",
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
 * 保存数据
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
			msg: "没有需要保存的数据！",
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
				msg: "保存成功！",
				type: 'success'
			});
			$('#gridParaState').datagrid('query');
		} else {
			PHA.Popover({
				msg: "保存失败！" + jsonData.errCode,
				type: 'alert',
				timeout:5000
			});
		}
	});
}
/**
 * 查询数据
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
