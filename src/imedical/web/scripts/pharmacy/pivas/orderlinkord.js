/**
 * ģ��:	��Һ��������շ���
 * ��д����:2018-03-13
 * ��д��:  yunhaibao
 */
var HospId=session["LOGON.HOSPID"];
var SessionLoc = session["LOGON.CTLOCID"];
var SessionUser = session["LOGON.USERID"];
var ConfirmMsgInfoArr = [];
var GridCmgArc;
var GridCmbLinkOrdPack;
var GridCmbSeqFlag;
$(function() {
	InitHospCombo();
    InitGridDict();
    InitGridOrderLink();
    InitGridOrdLinkOrd();
    InitGridFeeRule();
    //�շ�����
    $("#btnAddPolo").on("click", AddNewRow);
    $("#btnSavePolo").on("click", SaveOrdLinkOrd);
    $("#btnDelPolo").on("click", DeletelPolo);
    // �����շѹ���
    $("#btnSaveFeeRule").on("click", SaveFeeRule);
	$('.dhcpha-win-mask').remove();
});

function InitGridDict() {
    GridCmgArc = PIVAS.GridComboGrid.Init(
        {
            Type: "ArcItmMast"
        },
        {
            required: true,
            idField: "arcItmId",
            textField: "arcItmDesc",
	    	onBeforeLoad: function(param){
				param.HospId = HospId;
				param.filterText=param.q;
				
			}
        }
    );
    GridCmbLinkOrdPack = PIVAS.GridComboBox.Init(
        {
            Type: "LinkOrdPack"
        },
        {
            panelHeight: "auto",
            editable: false
            //required: true
        }
    );
    GridCmbSeqFlag = PIVAS.GridComboBox.Init(
        {
            data: {
                data: [
                    {
                        RowId: "A",
                        Description: "ȫ��"
                    },
                    {
                        RowId: "Y",
                        Description: "����ҽ��"
                    },
                    {
                        RowId: "N",
                        Description: "�ǹ���ҽ��"
                    }
                ]
            }
        },
        {
            panelHeight: "auto",
            editable: false
            //required: true
        }
    );
}

/// ��ʼ����Һ������
function InitGridOrderLink() {
    var columns = [
        [
            {
                field: "polId",
                title: "polId",
                hidden: true,
                align: "center"
            },
            {
                field: "polDesc",
                title: "��Һ����",
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.OrderLink",
            QueryName: "QueryOrderLink"
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        toolbar: [],
        onClickRow: function(rowIndex, rowData) {
            if (rowData) {
                QueryGridOrdLinkOrd();
                QueryGridFeeRule();
            }
        },
        onLoadSuccess: function() {
            $("#gridOrdLinkOrd").datagrid("clear");
            $("#gridFeeRule").datagrid("clear");
        },
    	onBeforeLoad: function(param){
			param.HospId = HospId
		}
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrderLink", dataGridOption);
    $("#gridOrderLink class[name=datagrid-header]").css("display", "none");
}

/// ��ʼ��ҽ������
function InitGridOrdLinkOrd() {
    var columns = [
        [
            {
                field: "poloId",
                title: "poloId",
                hidden: true
            },
            {
                field: "arcItmDesc",
                title: "ҽ��������",
                hidden: true
            },
            {
                field: "arcItmCode",
                title: "ҽ�������",
                width: 100
            },
            {
                field: "arcItmId",
                title: "ҽ��������",
                width: 200,
                editor: GridCmgArc,
                descField: "arcItmDesc",
                formatter: function(value, row, index) {
                    return row.arcItmDesc;
                }
            },
            {
                field: "arcItmQty",
                title: "����",
                width: 50,
                align: "center",
                editor: {
                    type: "numberbox",
                    options: {
                        required: true
                    }
                }
            },
            {
                field: "linkOrdPackDesc",
                title: "��������",
                width: 200,
                hidden: true
            },
            {
                field: "linkOrdPack",
                title: "����",
                width: 75,
                align: "center",
                editor: GridCmbLinkOrdPack,
                descField: "linkOrdPackDesc",
                formatter: function(value, row, index) {
                    return row.linkOrdPackDesc;
                }
            },
            {
                field: "linkOrdSeqDesc",
                title: "����ҽ������",
                width: 200,
                hidden: true
            },
            {
                field: "linkOrdSeq",
                title: "����ҽ��",
                width: 75,
                align: "center",
                editor: GridCmbSeqFlag,
                descField: "linkOrdSeqDesc",
                formatter: function(value, row, index) {
                    return row.linkOrdSeqDesc;
                }
            },
            {
                field: "batNo",
                title: "����",
                width: 50,
                halign: "center",
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.OrderLink",
            QueryName: "QueryOrdLinkOrd"
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        nowrap: false,
        toolbar: "#gridOrdLinkOrdBar",
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid("endEditing");
        },
        onLoadSuccess: function() {}
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdLinkOrd", dataGridOption);
}

/// ����һ��
function AddNewRow() {
    var polId = GetSelectPolId();
    if (polId == "") {
        return;
    }
    $("#gridOrdLinkOrd").datagrid("addNewRow", {
        editField: "arcItmId"
    });
}

/// ����ҽ����
function SaveOrdLinkOrd() {
    var polId = GetSelectPolId();
    if (polId == "") {
        return;
    }
    $("#gridOrdLinkOrd").datagrid("endEditing");
    var gridChanges = $("#gridOrdLinkOrd").datagrid("getChanges");
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "û����Ҫ���������",
            type: "alert"
        });
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params = polId + "^" + (iData.arcItmId || "") + "^" + (iData.arcItmQty || "") + "^" + (iData.linkOrdPack || "") + "^" + (iData.linkOrdSeq || "");
        paramsStr = paramsStr == "" ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCSTPIVAS.OrderLink", "SaveOrdLinkOrdMulti", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $("#gridOrdLinkOrd").datagrid("query", {});
}

/// ��ȡҽ�����б�
function QueryGridOrdLinkOrd() {
    var gridPOLSelect = $("#gridOrderLink").datagrid("getSelected");
    var polId = gridPOLSelect.polId || "";
    $("#gridOrdLinkOrd").datagrid("query", {
        inputStr: polId
    });
}

function QueryGridFeeRule() {
    var gridPOLSelect = $("#gridOrderLink").datagrid("getSelected");
    var polId = gridPOLSelect.polId || "";
    $("#gridFeeRule").datagrid("query", {
        POLIID: polId,
		HospId:HospId
    });
}
/// ɾ��ҽ����
function DeletelPolo() {
    var gridSelect = $("#gridOrdLinkOrd").datagrid("getSelected");
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "��ѡ����Ҫɾ���ļ�¼",
            type: "alert"
        });

        return;
    }
    $.messager.confirm("ȷ�϶Ի���", "��ȷ��ɾ����", function(r) {
        if (r) {
            var poloId = gridSelect.poloId || "";
            if (poloId == "") {
                var rowIndex = $("#gridOrdLinkOrd").datagrid("getRowIndex", gridSelect);
                $("#gridOrdLinkOrd").datagrid("deleteRow", rowIndex);
            } else {
                var delRet = tkMakeServerCall("web.DHCSTPIVAS.OrderLink", "DeletePIVAOrderLinkOrder", poloId);
                $("#gridOrdLinkOrd").datagrid("query", {});
            }
        }
    });
}

function GetSelectPolId() {
    var gridSelect = $("#gridOrderLink").datagrid("getSelected");
    if (gridSelect == null) {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "����ѡ����Ҫ���ӹ������Һ�����¼",
            type: "alert"
        });
        return "";
    }
    var polId = gridSelect.polId || "";
    if (polId == "") {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "����ѡ����Ҫ���ӹ������Һ�����¼",
            type: "alert"
        });
        return "";
    }
    return polId;
}

/// ��ʼ���շѹ�����
function InitGridFeeRule() {
    var columns = [
        [
            {
                field: "ruleID",
                title: "ruleID",
                hidden: true,
                align: "center"
            },
            {
                field: "ruleChk",
                checkbox: true
            },
            {
                field: "ruleDesc",
                title: "�շѹ���",
                width: 100
            },
            {
                field: "ruleItmData",
                title: "������ϵ",
                width: 200
            },
            {
                field: "ruleLinkData",
                title: "�շ�ҽ����",
                width: 200
            },
            {
                field: "linked",
                title: "�ѹ���",
                width: 200,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.OrderLink",
            QueryName: "OrderLinkFeeRule"
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        singleSelect: false,
        toolbar: "#gridFeeRuleBar",
        nowrap: false,
        onLoadSuccess: function(data) {
            $(this).datagrid("uncheckAll");
            var row0Data = data.rows[0];
            if (row0Data) {
                var rows = $(this).datagrid("getRows");
                var rowsLen = rows.length;
                for (var index = rowsLen - 1; index >= 0; index--) {
                    var rowData = rows[index];
                    var linked = rowData.linked;
                    if (linked == "Y") {
                        $(this).datagrid("checkRow", index);
                    }
                }
            }
        },
    	onBeforeLoad: function(param){
			param.HospId = HospId
		}
    };
    DHCPHA_HUI_COM.Grid.Init("gridFeeRule", dataGridOption);
}
function SaveFeeRule() {
    var rows = $("#gridFeeRule").datagrid("getChecked");
    var rowsLen = rows.length;
    var ruleIDArr = [];
    for (var index = 0; index < rowsLen; index++) {
        var rowData = rows[index];
        var ruleID = rowData.ruleID;
        ruleIDArr.push(ruleID);
    }
    var poliID = GetSelectPolId();
    if (poliID == "") {
        return;
    }
    var ruleIDStr = ruleIDArr.join(",");
    var saveRet = $.cm(
        {
            ClassName: "web.DHCSTPIVAS.OrderLink",
            MethodName: "SaveOrderFeeRule",
            POLIID: poliID,
            FeeRuleIDStr: ruleIDStr,
            dataType: "text"
        },
        false
    );
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $("#gridFeeRule").datagrid("reload");
}
function InitHospCombo(){
	var genHospObj=PIVAS.AddHospCom({tableName:'PIVA_OrderLink'});
	if (typeof genHospObj ==='object'){
		//����ѡ���¼�
		genHospObj.options().onSelect =  function(index, record) {	
			var newHospId=record.HOSPRowId;		
			if(newHospId!=HospId){
				HospId=newHospId;
				$('#gridOrderLink').datagrid('load');
			}
		};
    }
}