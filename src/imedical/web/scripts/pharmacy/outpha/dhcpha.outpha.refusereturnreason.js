/*
ģ��:����ҩ��
��ģ��:����ҩ��-�ܾ���ҩԭ��ά��
createdate:2016-06-13
creator:yunhaibao
*/
var HospId = session['LOGON.HOSPID'];
var editRow = ''; //��ǰ�༭�к�
var url = 'dhcpha.outpha.returnrefusereason.action.csp';
var titleNotes = '<span style="font-weight:bold;font-size:14px;font-family:Mictosoft YaHei;color:#800000;"><'+$g("˫���м��ɱ༭")+'></span>';
$(function () {
    // ����columns
    var columns = [
        [
            { field: 'ID', title: 'ID', width: 90, align: 'center', hidden: true },
            { field: 'Code', title: $g("����"), width: 160, editor: texteditor },
            { field: 'Desc', title: $g("����"), width: 300, editor: texteditor }
        ]
    ];

    // ����datagrid
    $('#reasongrid').datagrid({
        title: $g("�ܾ���ҩԭ��ά��") + titleNotes,
        url: url + '?action=QueryReason&hosp=' + HospId,
        fit: true,
        striped: true,
        rownumbers: true,
        columns: columns,
        singleSelect: true,
        loadMsg: $g("���ڼ�����Ϣ")+"...",
        onDblClickRow: function (rowIndex, rowData) {
            //˫��ѡ���б༭
            if (editRow != '' || editRow == '0') {
                $('#reasongrid').datagrid('endEdit', editRow);
            }
            $('#reasongrid').datagrid('beginEdit', rowIndex);
            editRow = rowIndex;
        }
    });

    initScroll('#reasongrid'); //��ʼ����ʾ���������

    //��ť���¼�
    $('#insert').on('click', insertRow);
    $('#delete').on('click', deleteRow);
    $('#save').on('click', saveRow);
    $('#reasongrid').datagrid('reload');
	InitHospCombo();
});

// ��������
function insertRow() {
    var row = $('#reasongrid').datagrid('getData').rows[0];
    //if(row["ID"]==""){
    //	return ;
    //}
    if (editRow >= '0') {
        $('#reasongrid').datagrid('endEdit', editRow); //�����༭������֮ǰ�༭����
    }
    $('#reasongrid').datagrid('insertRow', {
        //��ָ����������ݣ�appendRow�������һ���������
        index: 0, // ������0��ʼ����
        row: { ID: '', Code: '', Desc: '' }
    });
    $('#reasongrid').datagrid('beginEdit', 0); //�����༭������Ҫ�༭����
    editRow = 0;
}

// ɾ��ѡ����
function deleteRow() {
    var rows = $('#reasongrid').datagrid('getSelections'); //ѡ��Ҫɾ������
    if (rows.length > 0) {
        $.messager.confirm($g("��ʾ"), $g("��ȷ��Ҫɾ����Щ������"), function (res) {
            //��ʾ�Ƿ�ɾ��
            if (res) {
                $.post(url + '?action=DeleteReason', { params: rows[0].ID, hosp:HospId }, function (data) {
                    $('#reasongrid').datagrid('reload'); //���¼���
                });
            }
        });
    } else {
        $.messager.alert($g("��ʾ"), $g("��ѡ��Ҫɾ������"), 'warning');
        return;
    }
}

// ����༭��
function saveRow() {
    if (editRow >= '0') {
        $('#reasongrid').datagrid('endEdit', editRow);
    }
    var rows = $('#reasongrid').datagrid('getChanges');
    if (rows.length <= 0) {
        $.messager.alert($g("��ʾ"), $g("û�д���������!"));
        return;
    }
    var dataList = [];
    for (var i = 0; i < rows.length; i++) {
        if (rows[i].Code == '' || rows[i].Desc == '') {
            $.messager.alert($g("��ʾ"), $g("�������������Ϊ��!"));
            return false;
        }
        var tmp = rows[i].ID + '^' + rows[i].Code + '^' + rows[i].Desc;
        var existret = tkMakeServerCall('PHA.OP.CfRefRes.Query', 'CheckRefuseReason', rows[i].ID, rows[i].Code, rows[i].Desc, HospId);
        if (existret == '-1') {
            $.messager.alert($g("��ʾ"), rows[i].Code + ','+$g("�����Ѵ���,����ά���ظ�����!"), 'info');
            return false;
        } else if (existret == '-2') {
            $.messager.alert($g("��ʾ"), rows[i].Desc + ','+$g("�����Ѵ���,����ά���ظ�����!"), 'info');
            return false;
        }
        dataList.push(tmp);
    }
    var rowstr = dataList.join('||');

    //��������
    $.post(url + '?action=SaveReason', { params: rowstr, hosp: HospId}, function (data) {
		debugger
        $('#reasongrid').datagrid('reload'); //���¼���
    });
}

// �༭��
var texteditor = {
    type: 'text', //���ñ༭��ʽ
    options: {
        required: true //���ñ༭��������
    }
};


function InitHospCombo(){
	var genHospObj=DHCSTEASYUI.GenHospComp({tableName:'PHR_RefuseReason'});
	if (typeof genHospObj ==='object'){
		$(genHospObj).combogrid('options').onSelect =  function(index, record) {
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;	
				$('#reasongrid').datagrid('options').queryParams.hosp=HospId;			
				$('#reasongrid').datagrid('reload');		
			}
        };
	}
}