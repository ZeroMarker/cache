/**
 * ����:	 ��������-ҽ������
 * ��д��:	 MaYuqiang
 * ��д����: 2019-08-22
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
    // ��ʼ������״̬
    PHA.ComboBox('cmbComResult', {
        editable: false,
        width: 125,
        placeholder: '�������...',
        onSelect: function (selData) {
            QueryOrdInfo();
        },
        data: [
            { RowId: 0, Description: $g('������') },
            { RowId: 1, Description: $g('�ѽ���') },
            { RowId: 2, Description: $g('������') }
        ]
    });

    $('#cmbComResult').combobox('setValue', 0);
}

// ������Ϣ��ʼ��
function InitSetDefVal() {
    //��������
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
            { field: 'oeoriDateTime', title: '��ҽ��ʱ��', width: 155 },
            { field: 'oeoriSign', title: '��', width: 30 },
            { field: 'incDesc', title: 'ҽ������', width: 220 },
            { field: 'dosage', title: '����', width: 60 },
            { field: 'instrucDesc', title: '�÷�', width: 80 },
            { field: 'freqDesc', title: 'Ƶ��', width: 60 },
            { field: 'duraDesc', title: '�Ƴ�', width: 60 },
            { field: 'spec', title: '���', width: 60, hidden: true },
            { field: 'priDesc', title: '���ȼ�', width: 100 },
            { field: 'docName', title: 'ҽ��', width: 60 },
            { field: 'remark', title: '��ע', width: 100 },
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
            { field: 'comReaGrpNo', title: '���', width: 40 },
            {
                field: 'comReasonDesc',
                title: '����ԭ��',
                width: 260,
                formatter: function (v) {
                    return v.replace('������', '<span style="color:#999999">������</span>');
                }
            },
            { field: 'comDate', title: '��������', width: 100 },
            { field: 'comTime', title: '����ʱ��', width: 100 },
            { field: 'comUserName', title: '������', width: 80 },
            { field: 'comResult', title: '�������', width: 100 },
            { field: 'comFactorDesc', title: '������ʾֵ', width: 80, hidden: true },
            { field: 'comAdviceDesc', title: 'ҩʦ����', width: 150 },
            { field: 'comDocAdviceDesc', title: 'ҽ������', width: 100, hidden: true },
            { field: 'comPhNotes', title: 'ҩʦ��ע', width: 200 },
            { field: 'comDocNotes', title: 'ҽ����ע', width: 200 },
            { field: 'comActive', title: '��Ч', width: 50 },
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

/// ��ѯ������ҽ����Ϣ
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

/// ��ѯ������ҽ����Ϣ
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

//���߻��߽��ܲ�������
function Maintain(type) {
    var gridSelOrdItm = $('#gridOrdItm').datagrid('getSelected');
    if (gridSelOrdItm == null) {
        $.messager.alert('��ʾ', '����ѡ��ҽ����ϸ', 'warning');
        return;
    }
    var gridSelComment = $('#gridCommentLog').datagrid('getSelected');
    if (gridSelComment == null) {
        $.messager.alert('��ʾ', '����ѡ����Ҫ' + (type == 'A' ? '����' : '����') + '�ĵ���������ԭ���¼!', 'warning');
        return;
    }
    var comActive = gridSelComment.comActive;
    if (comActive != 'Y') {
        $.messager.alert('��ʾ', '��ѡ����Ч��ԭ���¼', 'warning');
        return;
    }
    var logRowId = gridSelComment.logRowId;
    if (type == 'C') {
        var docNote = $('#txtDocNote').val().trim(); // ҽ����ע
        if (docNote == '') {
            $.messager.alert('��ʾ', '�����·�ԭ��¼������д����ԭ��', 'warning');
            return;
        }
    } else if (type == 'A') {
        var docNote = 'Accept'; // ҽ����ע
    }
    var params = logRowId + '^' + docNote;
    var saveRet = tkMakeServerCall('PHA.PRC.Create.FindForDoctor', 'SaveDocAdvice', params);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert('��ʾ', saveInfo, 'warning');
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
