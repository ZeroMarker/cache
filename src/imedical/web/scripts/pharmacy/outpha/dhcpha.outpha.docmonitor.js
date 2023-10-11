/**
 * 模块:     药师审核查询
 * 编写日期: 2018-05-22
 * 编写人:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var PatNoLen = DHCPHA_STORE.Constant.PatNoLen;
$(function () {
    InitGridPhaOrd();
    InitGridReason();
    $('#dateStart').datebox('setValue', DHCPHA_TOOLS.Today());
    $('#dateEnd').datebox('setValue', DHCPHA_TOOLS.Today());
    $('#txtPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var patNo = $.trim($('#txtPatNo').val());
            if (patNo != '') {
                var newPatNo = DHCPHA_TOOLS.PadZero(patNo, PatNoLen);
                $(this).val(newPatNo);
                Query();
            }
        }
    });
    $('#btnFind').on('click', Query);
    $('#btnAgree').on('click', Agree);
    $('#btnAppeal').on('click', Appeal);
    $('#txtPatNo').val(LoadPatNo);
    if (LoadIfDoctor != 'Y') {
        $('#layoutNorth').panel('close');
        $('#layoutCenter').panel('maximize');
        $('#layoutCenter').panel('setTitle', $g("用药审核不通过"));
        setTimeout(Query, 300);
    } else {
        setTimeout(Query, 300);
    }

    DHCPHA_HUI_COM.ComboBox.Init(
        {
            Id: 'cmbStat',
            data: {
                data: [
                    {
                        RowId: 0,
                        Description: $g("未处理")
                    },
                    {
                        RowId: 1,
                        Description: $g("已申诉")
                    },
                    {
                        RowId: 2,
                        Description: $g("已接受")
                    }
                ]
            }
        },
        {
            editable: false,
            panelHeight: 'auto',
            onSelect: function () {
                Query();
            }
        }
    );
    $('#cmbStat').combobox('setValue', 0);
    InitParams()
});
function InitParams(){
	var retVal=tkMakeServerCall("PHA.COM.Method","GetOrdItmInfoForTipMess",LoadOrdItmId);
    if(retVal!="{}"){
	    var retJson=JSON.parse(retVal);
		var ordDate=retJson.ordDate;
		$('#dateStart').datebox('setValue', ordDate);
	}

}
// 医嘱审核明细列表
function InitGridPhaOrd() {
    var columns = [
        [
            { field: 'phaOrdId', title:("审核Id"), width: 100, hidden: true },
            { field: 'patNo', title:("登记号"), width: 100 },
            { field: 'patName', title:("姓名"), width: 80 },
            { field: 'incDesc', title: ("药品"), width: 250 },
            { field: 'dosage', title: ("剂量"), width: 75 },
            { field: 'freqDesc', title: ("频次"), width: 75 },
            { field: 'instrucDesc', title: ("用法"), width: 75 },
            { field: 'qtyDesc', title: ("数量"), width: 100, halign: 'left', align: 'left' },
            { field: 'reasonDesc', title: ("拒绝原因"), width: 200 },
            {
                field: 'phNotes',
                title: ("药师备注"),
                width: 200,
                formatter: function (value, row, index) {
                    return '<div style="width=200px;word-break:break-all;word-wrap:break-word;white-space:pre-wrap;">' + value + '</div>';
                }
            },
            { field: 'userName', title: ("审核人"), width: 80 },
            { field: 'opDateTime', title: ("审核时间"), width: 100 },
            { field: 'passWay', title: ("审核方式"), width: 85 },
            { field: 'doseDate', title: ("用药日期"), width: 100, halign: 'left', hidden: true },
            { field: 'doctorName', title: ("医生"), width: 80, hidden: false },
            { field: 'orderStoped', title: ("医嘱全部作废"), width: 80, hidden: false }
        ]
    ];
    var dataGridOption = {
        url: 'DHCST.METHOD.BROKER.csp?ClassName=web.DHCOUTPHA.DocMonitor&MethodName=JsGetRefuseMonitor',
        queryParams: {},
        toolbar: LoadIfDoctor == 'Y' ? '#gridPhaOrdBar' : '',
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columns,
        nowrap: false,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        onSelect: function (rowIndex, rowData) {
            DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridPhaOrd',
                Field: 'phaOrdId',
                Check: true,
                Value: rowData.phaOrdId,
                Type: 'Select'
            });
        },
        onUnselect: function (rowIndex, rowData) {
            $(this).datagrid('unselectAll');
        },
        onLoadSuccess: function () {
            DHCPHA_HUI_COM.Grid.MergeCell({
                GridId: 'gridPhaOrd',
                Field: 'phaOrdId',
                MergeFields: ['patNo', 'patName', 'userName', 'opDateTime', 'passWay', 'doseDate', 'phNotes']
            });
            DHCPHA_HUI_COM.Grid.CellTip({ TipArr: ['phNotes'] });
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridPhaOrd', dataGridOption);
}

// 原因列表
function InitGridReason() {
    var columns = [
        [
            { field: 'incDesc', title: ("药品"), width: 250, halign: 'left' },
            { field: 'reasonDesc', title: ("审核原因"), width: 250, halign: 'left' }
        ]
    ];
    var dataGridOption = {
        url: '',
        fit: true,
        fitColumns: true,
        border: false,
        rownumbers: false,
        columns: columns,
        pagination: false
    };
    DHCPHA_HUI_COM.Grid.Init('gridReason', dataGridOption);
}
// 获取参数
function QueryParams() {
    var stDate = $('#dateStart').datebox('getValue');
    var edDate = $('#dateEnd').datebox('getValue');
    var recLocId = '';
    var patNo = $('#txtPatNo').val();
    var doctorId = SessionUser;
    if (LoadIfDoctor != 'Y') {
        doctorId = '';
    }
    var admId = typeof LoadAdmId == 'undefined' ? '' : LoadAdmId;
    if (patNo != '') {
        admId = '';
    }
    var stat = $('#cmbStat').combobox('getValue');
    return stDate + '^' + edDate + '^' + recLocId + '^' + patNo + '^' + doctorId + '^' + admId + '^' + stat;
}
// 查询
function Query() {
    var params = QueryParams();
    $('#gridPhaOrd').datagrid({
        queryParams: {
            inputStr: params
        }
    });
}
// 获取选中的行记录
function GetGridSelected() {
    var gridSelected = $('#gridPhaOrd').datagrid('getSelected');
    if (gridSelected == null) {
        $.messager.alert($g("提示"), $g("请选择记录"), 'warning');
        return '';
    }
    return gridSelected.phaOrdId;
}
// 同意
function Agree() {
    var phaOrdId = GetGridSelected();
    if (phaOrdId == '') {
        return;
    }

    if ($('#cmbStat').combobox('getValue') !== '0') {
        $.messager.alert($g("提示"), $g("已处理的数据不能再次处理"), 'warning');
        return;
    }

    // 已发药不能操作
    var agreeRet = tkMakeServerCall('web.DHCOUTPHA.DocMonitor', 'Agree', phaOrdId, SessionUser, SessionLoc);
    var agreeArr = agreeRet.split('^');
    if (agreeArr[0] < 0) {
        $.messager.alert($g("提示"), retArr[1], 'warning');
        return;
    } else {
        if (top && top.HideExecMsgWin) {
            top.HideExecMsgWin();
        }
        $('#gridPhaOrd').datagrid('reload');
    }
}
// 申诉窗口
function Appeal() {
    var gridSelections = $('#gridPhaOrd').datagrid('getSelections');
    var selLen = gridSelections.length;
    if (selLen == 0) {
        $.messager.alert($g("提示"), $g("请选择记录"), 'warning');
        return '';
    }
    if ($('#cmbStat').combobox('getValue') !== '0') {
        $.messager.alert($g("提示"), $g("已处理的数据不能再次处理"), 'warning');
        return;
    }
    var reasonArr = [];
    var phNotes = '';
    for (var selI = 0; selI < selLen; selI++) {
        var selData = gridSelections[selI];
        if (selData.orderStoped === 'Y') {
            $.messager.alert($g("提示"), $g("医嘱已全部作废或取消,无法申诉"), 'warning');
            return;
        }
        var incDesc = selData.incDesc;
        var reasonDesc = selData.reasonDesc;
        var phNotes = selData.phNotes;
        var reasonObj = { incDesc: incDesc, reasonDesc: reasonDesc };
        reasonArr.push(reasonObj);
    }
    $('#gridReason').datagrid('loadData', reasonArr);
    $('#txtNotes').text(phNotes);
    $('#appealWin').dialog('open');
    $('#txtAppeal').val('');
    $('#txtAppeal').focus();
    $('#appealWin').find('.panel-body').eq(3).css('border-radius', '4px');
    $('#appealWin').find('.dialog-button').css('padding-top', window.HISUIStyleCode == 'lite' ? '1px' : '0px');
}

function SaveAppeal() {
    var phaOrdId = GetGridSelected();
    if (phaOrdId == '') {
        return;
    }
    var appealText = $('#txtAppeal').val();
    if (appealText == '') {
        $.messager.alert($g("提示"), $g("请填写申诉内容"), 'warning');
        return;
    }
    $('#appealWin').dialog('close');
    var appealRet = tkMakeServerCall('web.DHCOUTPHA.DocMonitor', 'Appeal', phaOrdId, appealText, SessionUser, SessionLoc);
    var appealArr = appealRet.split('^');
    if (appealArr[0] < 0) {
        $.messager.alert($g("提示"), appealArr[1], 'warning');
        return;
    } else {
        if (top && top.HideExecMsgWin) {
            top.HideExecMsgWin();
        }
        $('#gridPhaOrd').datagrid('reload');
    }
}
