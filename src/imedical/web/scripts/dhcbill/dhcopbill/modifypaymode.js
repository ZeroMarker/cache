/**
 * FileName: dhcbill/dhcopbill/modifypaymode.js
 * Author: tangzf
 * Date: 2021-03-18
 * Description: 门诊支付方式修改
 */

$(function () {
	initQueryMenu();
    initInvList();
    initPayMList();
    
    if (CV.PageID == "") {
        $.messager.alert('提示', '请配置：ModifyPayMode支付方式修改对照', 'info');
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
    
	//保存
	$('#btnSave').bind('click', function () {
	    Update();
	});

	//修改
	$('#btnUpdate').bind('click', function () {
	    BeginEdit();
	});

	//刷新
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

//确认并保存数据
function Update() {
    var dg = $('#invList').datagrid('getSelected');
    if (dg && dg.HandFlag) {
        $.messager.popover({msg: '日结过的数据不允许修改', type: 'info'});
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
        $.messager.popover({msg: '没有要提交的数据', type: 'info'});
        return;
    }
    var BalanceAmt = getValueById('BalanceAmt');
    if (BalanceAmt != 0) {
        $.messager.popover({msg: '平衡金额不为0，不允许提交', type: 'info'});
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
    $.messager.confirm('提示', '是否继续提交修改信息？', function (r) {
        if (!r) {
            return;
        }
        var rtn = tkMakeServerCall("BILL.COM.ModifyINVPayMode", "InsertPayMode", insertStr, PUBLIC_CONSTANT.SESSION.USERID, CV.AdmType, ParentId);
        if (rtn == 0) {
            $.messager.popover({msg: '提交成功', type: 'success'});
        } else {
            $.messager.popover({msg: '提交失败', type: 'error'});
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
                    title: '支付方式',
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
	                            if(row.Code == "CCP"){  //记账
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
                    title: '金额',
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
                    title: '合同单位',
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

// 支付方式编辑
function BeginEdit() {
    var selectRow = $('#paymList').datagrid('getSelected');
    if (!selectRow) {
        $.messager.popover({msg: '请选择要修改的支付方式', type: 'info'});
        return;
    }
    var dg = $('#invList').datagrid('getSelected');
    if (dg.HandFlag != '') {
        $.messager.popover({msg: '日结过的数据不允许修改', type: 'info'});
        return;
    }
    //暂时不判断有效截止日期，类方法默认只查有效配置
    var ChangerComPay=tkMakeServerCall("BILL.CFG.COM.GeneralCfg","CheckCfgRelaDataExist","OPCHRG.PayModModi.KBJDZFFS","",selectRow.PayMDR,"COM");
    if(ChangerComPay&&ChangerComPay.indexOf("^")>0)
    {
	    if(ChangerComPay.split("^")[0]==0)
	    {
            //WangXQ 20230328 判断对应院区配置
            var ChangerPay=tkMakeServerCall("BILL.CFG.COM.GeneralCfg","CheckCfgRelaDataExist","OPCHRG.PayModModi.KBJDZFFS","",selectRow.PayMDR,PUBLIC_CONSTANT.SESSION.HOSPID);
            if(ChangerPay&&ChangerPay.indexOf("^")>0)
            {
                if(ChangerPay.split("^")[0]==0)
                {
                    $.messager.popover({msg: '此支付方式不在配置中，不可修改。', type: 'info'});
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

// 支付方式重复校验
function checkRepeatPayMode() {
    var rows = $('#paymList').datagrid('getRows');
    if (rows.length == 0) {
        return;
    }
    var myArray = new Array(); // 重复校验
    for (var i = 0; i < rows.length; i++) {
        if (myArray.indexOf(rows[i].PayMDR) > -1) {
            $.messager.popover({msg: '支付方式重复', type: 'info'});
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
