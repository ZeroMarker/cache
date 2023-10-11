/**
 * FileName: dhcbill/dhcopbill/modifypaymode.js
 * Author: tangzf
 * Date: 2021-03-18
 * Description: ����֧����ʽ�޸�
 */

$(function () {
	initQueryMenu();
    initInvList();
    initPayMList();
    
    if (CV.PageID == "") {
        $.messager.alert('��ʾ', '�����ã�ModifyPayMode֧����ʽ�޸Ķ���', 'info');
    }
});

function initQueryMenu() {
	$('.datebox-f').datebox('setValue', CV.DefDate);
	
	$HUI.linkbutton("#btnFind", {
		onClick: function () {
			loadInvList();
		}
	});
	
	$HUI.linkbutton("#btnClear", {
		onClick: function () {
			clearClick();
		}
	});
	
	$('#InvNo').keyup(function (e) {
        if (e.keyCode == 13) {
            loadInvList();
        }
    });
    
    $('#RegNo').keyup(function (e) {
        if (e.keyCode == 13) {
            var RegNo = tkMakeServerCall("web.UDHCJFBaseCommon", "regnocon", getValueById("RegNo"));
            setValueById('RegNo', RegNo);
            loadInvList();
        }
    });
    
    $HUI.combobox('#NewINVPayModeID', {
        valueField: 'CTRowID',
        textField: 'PayModeDesc',
        url: $URL + '?ClassName=BILL.COM.ModifyINVPayMode&QueryName=FindPayMode&ResultSetType=array',
   		defaultFilter: 5
    });
    
	//����
	$('#btnSave').bind('click', function () {
	    Update();
	});

	//�޸�
	$('#btnUpdate').bind('click', function () {
	    BeginEdit();
	});

	//ˢ��
	$('#btnRefresh').bind('click', function () {
	    loadPayMList();
	});
}

function loadInvList() {
    var queryParams = {
        ClassName: 'BILL.COM.ModifyINVPayMode',
        QueryName: 'FindInvPayModeInfo',
        StDate: getValueById('StartDate'),
        EndDate: getValueById('EndDate'),
        InvNo: getValueById('InvNo'),
        Type: CV.AdmType,
        PatientNo: getValueById('RegNo'),
        SessionStr: getSessionStr()
    }
    loadDataGridStore('invList', queryParams);
}

function loadPayMList() {
    var row = $('#invList').datagrid('getSelected');
	var prtRowId = row ? (row.PrtRowID || "") : "";
    var queryParams = {
        ClassName: 'BILL.COM.ModifyINVPayMode',
        QueryName: 'FindPayModeByRowID',
        RowID: prtRowId,
        Type: CV.AdmType,
        LangId: PUBLIC_CONSTANT.SESSION.LANGID
    }
    loadDataGridStore('paymList', queryParams);
}

//ȷ�ϲ���������
function Update() {
    var dg = $('#invList').datagrid('getSelected');
    if (dg && dg.HandFlag) {
        $.messager.popover({msg: '�ս�������ݲ������޸�', type: 'info'});
        return;
    }
    if (!checkRepeatPayMode()) {
        return;
    }
    var rows = $('#paymList').datagrid('getRows');
    for (var i = 0; i < rows.length; i++) {
        $('#paymList').datagrid('endEdit', i);
    }
    var ChangesRows = $('#paymList').datagrid('getChanges');
    if (ChangesRows.length == 0) {
        $.messager.popover({msg: 'û��Ҫ�ύ������', type: 'info'});
        return;
    }
    var BalanceAmt = getValueById('BalanceAmt');
    if (BalanceAmt != 0) {
        $.messager.popover({msg: 'ƽ���Ϊ0���������ύ', type: 'info'});
        return;
    }
    var insertStr = '';
    for (var i = 0; i < ChangesRows.length; i++) {
        var tmpInsertStr = ChangesRows[i].PayMDR + '&' + ChangesRows[i].PayMAmt + '&' + ChangesRows[i].PayMSubRowID+"&"+ChangesRows[i].UnitDR;
        if (insertStr == "") {
            insertStr = tmpInsertStr;
        } else {
            insertStr = insertStr + '^' + tmpInsertStr;
        }
    }
    var ParentId = dg.PrtRowID;
    $.messager.confirm('��ʾ', '�Ƿ�����ύ�޸���Ϣ��', function (r) {
        if (!r) {
            return;
        }
        var rtn = tkMakeServerCall("BILL.COM.ModifyINVPayMode", "InsertPayMode", insertStr, PUBLIC_CONSTANT.SESSION.USERID, CV.AdmType, ParentId);
        if (rtn == 0) {
            $.messager.popover({msg: '�ύ�ɹ�', type: 'success'});
        } else {
            $.messager.popover({msg: '�ύʧ��', type: 'error'});
        }
        loadPayMList();
    });
}

function initInvList() {
    $('#invList').datagrid({
        fit: true,
     	border: false,
        singleSelect: true,
        pageSize: 20,
        pagination: true,
        className: "BILL.COM.ModifyINVPayMode",
		queryName: "FindInvPayModeInfo",
        onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["PrtDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["PrtFlag"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "PrtTime") {
					cm[i].formatter = function (value, row, index) {
						return row.PrtDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["PrtTime"]) != -1) {
						cm[i].width = 155;
					}
				}
			}
		},
        onLoadSuccess: function(data) {
	        $("#paymList").datagrid('loadData', {total: 0, rows: []});
	    },
        onSelect: function (rowIndex, rowData) {
            loadPayMList();
        }
    });
}

function initPayMList() {
    $HUI.datagrid('#paymList', {
        fit: true,
        border: false,
        fitColumns: true,
        singleSelect: true,
        pageSize: 99999,
        pagination: false,
        toolbar: '#dg',
        columns: [[{
                    field: 'PayMSubRowID',
                    title: 'PayMSubRowID',
                    width: 100,
                    hidden: true
                }, {
                    field: 'PayMDesc',
                    title: 'PayMDesc',
                    width: 100,
                    hidden: true
                }, {
                    field: 'PayMDR',
                    title: '֧����ʽ',
                    width: 150,
                    editor: {
                        type: 'combobox',
                        options: {
                            valueField: 'RowId',
                            textField: 'Desc',
                            url: $URL,
                            mode: 'remote',
                            editable: false,
                            defaultFilter: 5,
                            onBeforeLoad: function (param) {
                                if (CV.PageID == "") {
                                    return;
                                }
                                if (GV.BeforePayMID == "") {
                                    return true;
                                }
                                param.ClassName = 'web.DHCBillPageConf';
                                param.QueryName = 'FindModifyPayModeCon';
                          	    param.ResultSetType = 'array';
                                param.pageId = CV.PageID;
                                param.site = 'HOSPITAL';
                                param.code = GV.BeforePayMID;
                                param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
                                param.langId = PUBLIC_CONSTANT.SESSION.LANGID;
                                return true;
                            },
                            onLoadSuccess:function(data){
	                            if(data.length != 0) {
	                            	$(this).combobox('select', $('#paymList').datagrid('getSelected').PayMDR);
	                            }
	                        },
                            onSelect:function(row){
								var IndexRow=$('#paymList').datagrid('getSelected');
	                            var Index=$('#paymList').datagrid('getRowIndex',IndexRow);
	                            var editor = $('#paymList').datagrid('getEditor', {
							      		index: Index,
							      		field: 'UnitDR'
								});
	                            if(row.Code == "CCP"){  //����
	                            	editor.target.combobox({disabled: false});
		                            editor.target.combobox('select', $('#paymList').datagrid('getSelected').UnitDR);
	                            } else {
									editor.target.combobox({disabled: true});
									editor.target.combobox('setValue', '');
		                        }
                            }
                        }
                    },
                    formatter: function (value) {
                        return tkMakeServerCall("BILL.COM.ModifyINVPayMode", "GetPayModeDescByID", value, PUBLIC_CONSTANT.SESSION.LANGID);
                    }
                }, {
                    field: 'PayMAmt',
                    title: '���',
                    width: 150,
                    align: 'right' //,
                    /* editor: {
                        type: 'numberbox',
                        options: {
                            value: 0,
                            precision: 2
                        }
                    } */
                },
                {
                    field: 'UnitDR',
                    title: '��ͬ��λ',
                    width: 150,
                    align: 'right',
					editor:{
						type: 'combobox',
						options: {
							defaultFilter: 5,
							valueField: 'id',
							textField: 'text',
							url: $URL,
							mode: 'remote',
							onBeforeLoad:function(param) {
								param.ClassName = 'web.DHCBillOtherLB';
						      	param.QueryName = 'QryHCPList';
						      	param.patientId = '',
						      	param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID,
						      	param.ResultSetType = 'array';
						      	return true;
							}
						}
					},
					formatter:function(val){
						return tkMakeServerCall("BILL.COM.ModifyINVPayMode", "GetHCPDescByID", val);	
					}
                }
            ]],
        onSelect: function (index, row) {
            GV.EditIndex = index;
            GV.BeforePayMID = row.PayMDR;
        },
        onDblClickRow: function (index, row) {
            GV.EditIndex = index;
            GV.BeforePayMID = row.PayMDR;
            BeginEdit();
        },
        onLoadSuccess: function () {
            GV.EditIndex = undefined;
            GV.BeforePayMID = "";
            checkBalance();
        },
        onAfterEdit: function (index, row, changeData) {
            GV.EditIndex = undefined;
            GV.BeforePayMID = "";
            if (row.PayMDR == "") {
                $(this).datagrid('deleteRow', index);
            }
            checkBalance();
        },
        onBeginEdit: function (index, row) {
	        GV.EditIndex = index;
            GV.BeforePayMID = row.PayMDR;
            checkRepeatPayMode();
            var ed = $('#paymList').datagrid('getEditor', {index: index, field: "PayMDR"});
			if (ed) {
				$(ed.target).combobox("setValue", row.PayMDesc);
			}
        }
    });
}

// ֧����ʽ�༭
function BeginEdit() {
    var selectRow = $('#paymList').datagrid('getSelected');
    if (!selectRow) {
        $.messager.popover({msg: '��ѡ��Ҫ�޸ĵ�֧����ʽ', type: 'info'});
        return;
    }
    var dg = $('#invList').datagrid('getSelected');
    if (dg.HandFlag != '') {
        $.messager.popover({msg: '�ս�������ݲ������޸�', type: 'info'});
        return;
    }
    //��ʱ���ж���Ч��ֹ���ڣ��෽��Ĭ��ֻ����Ч����
    var ChangerComPay=tkMakeServerCall("BILL.CFG.COM.GeneralCfg","CheckCfgRelaDataExist","OPCHRG.PayModModi.KBJDZFFS","",selectRow.PayMDR,"COM");
    if(ChangerComPay&&ChangerComPay.indexOf("^")>0)
    {
	    if(ChangerComPay.split("^")[0]==0)
	    {
            //WangXQ 20230328 �ж϶�ӦԺ������
            var ChangerPay=tkMakeServerCall("BILL.CFG.COM.GeneralCfg","CheckCfgRelaDataExist","OPCHRG.PayModModi.KBJDZFFS","",selectRow.PayMDR,PUBLIC_CONSTANT.SESSION.HOSPID);
            if(ChangerPay&&ChangerPay.indexOf("^")>0)
            {
                if(ChangerPay.split("^")[0]==0)
                {
                    $.messager.popover({msg: '��֧����ʽ���������У������޸ġ�', type: 'info'});
                    return;
                }
            }
		}
	}
    /*
    var SelectIndex = $("#paymList").datagrid("getEditingIndex");
    if (SelectIndex) {
        $('#paymList').datagrid('endEdit', SelectIndex);
    }
    */
    var selectedIndex = $('#paymList').datagrid('getRowIndex', selectRow);
    $('#paymList').datagrid('beginEdit', selectedIndex);
}

function checkBalance() {
    var rows = $('#paymList').datagrid('getRows');
    if (rows.length == 0) {
        return;
    }
    var selectInv = $('#invList').datagrid('getSelected');
    if (!selectInv) {
        return;
    }
    var totalAmt = Number(selectInv.PatShareAmt);
    var payModeAmt = 0;
    for (var i = 0; i < rows.length; i++) {
        var tmpAmt = Number(rows[i].PayMAmt);
        if (isNaN(tmpAmt)) {
            tmpAmt = 0;
        }
        payModeAmt = payModeAmt + tmpAmt;
    }
    setValueById('BalanceAmt', parseFloat(totalAmt - payModeAmt).toFixed(2));
}

// ֧����ʽ�ظ�У��
function checkRepeatPayMode() {
    var rows = $('#paymList').datagrid('getRows');
    if (rows.length == 0) {
        return;
    }
    var myArray = new Array(); // �ظ�У��
    for (var i = 0; i < rows.length; i++) {
        if (myArray.indexOf(rows[i].PayMDR) > -1) {
            $.messager.popover({msg: '֧����ʽ�ظ�', type: 'info'});
            $('#paymList').datagrid('beginEdit', i);
            return false;
        }
        myArray.push(rows[i].PayMDR);
    }
    return true;
}

function clearClick() {
    $(":text:not(.pagination-num)").val("");
	$(".datebox-f").datebox('setValue', CV.DefDate);
	$(".datagrid-f").datagrid("loadData", {total: 0, rows: []});
}
