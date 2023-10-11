/**
 * 名称:	 处方点评-医生申诉
 * 编写人:	 MaYuqiang
 * 编写日期: 2019-08-22
 */
PHA_COM.App.Csp = 'pha.prc.v2.create.findfordoctor.csp';
PHA_COM.App.Name = 'PRC.Create.FindForDoctor';
PHA_COM.App.Load = '';
var logonLocId = session['LOGON.CTLOCID'];
var logonUserId = session['LOGON.USERID'];
var logonGrpId = session['LOGON.GROUPID'];
var logonInfo = logonGrpId + '^' + logonLocId + '^' + logonUserId;
PCntItmLogID = PCntItmLogID.trim();

$(function () {
    InitDict();
    InitSetDefVal();
    InitGridOrdItm();
    InitGridCommentLog();
    
    $('#btnFind').on('click', function () {
        QueryOrdInfo();
    });
    $('#btnComplain').on('click', function () {
        Maintain('C');
    });
    $('#btnAccept').on('click', function () {
        Maintain('A');
    });
});

function InitDict() {
    PHA.DateBox('conStartDate', { width: 125 });
    PHA.DateBox('conEndDate', { width: 125 });
    // 初始化点评状态
    PHA.ComboBox('cmbComResult', {
        editable: false,
        width: 125,
        placeholder: '点评结果...',
        onSelect: function (selData) {
            QueryOrdInfo();
        },
        data: [
            { RowId: 0, Description: $g('不合理') },
            { RowId: 1, Description: $g('已接受') },
            { RowId: 2, Description: $g('已申诉') }
        ]
    });

    $('#cmbComResult').combobox('setValue', 0);
}

// 界面信息初始化
function InitSetDefVal() {
    //界面配置
    $.cm({
            ClassName: 'PHA.PRC.Com.Util',
            MethodName: 'GetAppProp',
            UserId: logonUserId,
            LocId: logonLocId,
            SsaCode: 'PRC.COMMON'
        },
        function (jsonColData) {
            $('#conStartDate').datebox('setValue', jsonColData.ComStartDate);
            $('#conEndDate').datebox('setValue', jsonColData.ComEndDate);
        }
    );
}

function InitGridOrdItm() {
    var columns = [
        [
            { field: 'oeoriDateTime', title: '下医嘱时间', width: 155 },
            { field: 'oeoriSign', title: '组', width: 30 },
            { field: 'incDesc', title: '医嘱名称', width: 220 },
            { field: 'dosage', title: '剂量', width: 60 },
            { field: 'instrucDesc', title: '用法', width: 80 },
            { field: 'freqDesc', title: '频率', width: 60 },
            { field: 'duraDesc', title: '疗程', width: 60 },
            { field: 'spec', title: '规格', width: 60, hidden: true },
            { field: 'priDesc', title: '优先级', width: 100 },
            { field: 'docName', title: '医生', width: 60 },
            { field: 'remark', title: '备注', width: 100 },
            { field: 'logId', title: 'logId', width: 60, hidden: true },
            { field: 'mOeori', title: 'mOeori', width: 60, hidden: true }
        ]
    ];
    
    var startDate = $('#conStartDate').datebox('getValue') || '';
    var endDate = $('#conEndDate').datebox('getValue') || '';
    var state = $('#cmbComResult').combobox('getValue') || '';    
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.FindForDoctor',
            QueryName: 'SelectOrdDataForDoctor',
            startDate: startDate,
            endDate: endDate,
            inputStr: logonUserId + '^'+ state,
            logonInfo: logonInfo
        },
        columns: columns,
        toolbar: '#gridOrdItmBar',
        onSelect: function (rowIndex, rowData) {
            if (rowData) {
                QueryCommentLog();
            }
        },
        onLoadSuccess: function(data){
	        console.log(data)
	    	if(data.rows.length > 0){
		    	$(this).datagrid('selectRow', 0);
		    }
	    }
    };
    PHA.Grid('gridOrdItm', dataGridOption);
}

function InitGridCommentLog() {
    var columns = [
        [
            { field: 'comReaGrpNo', title: '组号', width: 40 },
            {
                field: 'comReasonDesc',
                title: '点评原因',
                width: 260,
                formatter: function (v) {
                    return v.replace('└──', '<span style="color:#999999">└──</span>');
                }
            },
            { field: 'comDate', title: '点评日期', width: 100 },
            { field: 'comTime', title: '点评时间', width: 100 },
            { field: 'comUserName', title: '点评人', width: 80 },
            { field: 'comResult', title: '点评结果', width: 100 },
            { field: 'comFactorDesc', title: '不合理警示值', width: 80, hidden: true },
            { field: 'comAdviceDesc', title: '药师建议', width: 150 },
            { field: 'comDocAdviceDesc', title: '医生反馈', width: 100, hidden: true },
            { field: 'comPhNotes', title: '药师备注', width: 200 },
            { field: 'comDocNotes', title: '医生备注', width: 200 },
            { field: 'comActive', title: '有效', width: 50 },
            { field: 'logRowId', title: 'logRowId', width: 100, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.PRC.Create.FindForDoctor',
            QueryName: 'SelectLogForDoctor',
            inputStr: ''
        },
        columns: columns,
        toolbar: [],
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
            }
        }
    };
    PHA.Grid('gridCommentLog', dataGridOption);
    
    $('#panelCommentLog').css('border-bottom', '');
    $('#panelCommentLog').parent().css('border-bottom', '1px solid #e2e2e2');
}

/// 查询不合理医嘱信息
function QueryOrdInfo() {
    var stDate = $('#conStartDate').datebox('getValue') || '';
    var endDate = $('#conEndDate').datebox('getValue') || '';
    var state = $('#cmbComResult').combobox('getValue') || '';
    var parStr = logonUserId + '^' + state;

    $('#gridOrdItm').datagrid('query', {
        startDate: stDate,
        endDate: endDate,
        inputStr: parStr
    });
}

/// 查询不合理医嘱信息
function QueryCommentLog() {
    var gridSelect = $('#gridOrdItm').datagrid('getSelected');
    if (gridSelect == null) {
        $('#gridCommentLog').datagrid('clear');
        return;
    }
    var mOeori = gridSelect.mOeori;
    var logRowId = gridSelect.logRowId;
    var parStr = mOeori + '^' + logRowId;

    $('#gridCommentLog').datagrid('query', {
        inputStr: parStr
    });
}

//申诉或者接受不合理处方
function Maintain(type) {
    var gridSelOrdItm = $('#gridOrdItm').datagrid('getSelected');
    if (gridSelOrdItm == null) {
        $.messager.alert('提示', '请先选中医嘱明细', 'warning');
        return;
    }
    var gridSelComment = $('#gridCommentLog').datagrid('getSelected');
    if (gridSelComment == null) {
        $.messager.alert('提示', '请先选中需要' + (type == 'A' ? '接受' : '申诉') + '的点评不合理原因记录!', 'warning');
        return;
    }
    var comActive = gridSelComment.comActive;
    if (comActive != 'Y') {
        $.messager.alert('提示', '请选择有效的原因记录', 'warning');
        return;
    }
    var logRowId = gridSelComment.logRowId;
    if (type == 'C') {
        var docNote = $('#txtDocNote').val().trim(); // 医生备注
        if (docNote == '') {
            $.messager.alert('提示', '请在下方原因录入中填写申诉原因', 'warning');
            return;
        }
    } else if (type == 'A') {
        var docNote = 'Accept'; // 医生备注
    }
    var params = logRowId + '^' + docNote;
    var saveRet = tkMakeServerCall('PHA.PRC.Create.FindForDoctor', 'SaveDocAdvice', params);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('提示', saveInfo, 'warning');
        return;
    }
    $('#txtDocNote').val('');
    QueryOrdInfo();
    ClearLogGrid();
}

function ClearLogGrid() {
    $('#gridCommentLog').datagrid('query', {
        inputStr: ''
    });
}
