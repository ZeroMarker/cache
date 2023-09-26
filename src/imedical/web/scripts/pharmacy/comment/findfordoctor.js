/**
 * ģ��:     ����������ѯ(ҽ��)
 * ��д����: 2018-05-15
 * ��д��:   QianHuanjuan
 */

var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function() {
    InitGridOrdItm();
    InitGridCommentLog();
    DHCPHA_HUI_COM.ComboBox.Init({
        Id: 'cmbComResult',
        data: {
            data: [
                { RowId: 0, Description: "���ϸ�" },
                { RowId: 1, Description: "�ѽ���" },
                { RowId: 2, Description: "������" }
            ]
        }
    }, {
	    editable:false,
        placeholder: '�������...',
        onSelect:function(selData){
	    	Query();
	    }
    });
    $("#cmbComResult").combobox("setValue",0)
    $("#dateStart").datebox("setValue", DHCPHA_TOOLS.Today());
    $("#dateEnd").datebox("setValue", DHCPHA_TOOLS.Today());
    $("#btnFind").on("click", Query);
    $("#btnComplain").on("click", function() {
        MainTain("C");
    });
    $("#btnAccept").on("click", function() {
        MainTain("A");
    });
    window.resizeTo(screen.availWidth, screen.availHeight);
    //$("#txtDocNote").width($("#layoutEast").width()-8);
    setTimeout(Query,300);
});

function InitGridOrdItm() {
    var columns = [
        [
            { title: '����ʱ��', field: 'oeoriDateTime', width: 155 },
            { title: '��', field: 'oeoriSign', width: 30, align:'center',
            	formatter: DHCPHA_HUI_COM.Grid.Formatter.OeoriSign
            },
            { title: 'ҽ������', field: 'incDesc', width: 200 },
            { title: '����', field: 'qty', width: 50, align: 'right' },
            { title: '��λ', field: 'uomDesc', width: 50},
            { title: '����', field: 'dosage', width: 60},
            { title: '�÷�', field: 'instrucDesc', width: 60 },
            { title: 'Ƶ��', field: 'freqDesc', width: 60},
            { title: '�Ƴ�', field: 'duraDesc', width: 60},
            { title: '���', field: 'spec', width: 60 ,hidden: true},
            { title: '���ȼ�', field: 'priDesc', width: 60 },
            { title: 'ҽ��', field: 'docName', width: 60},
            { title: '��ע', field: 'remark', width: 100 },
            { title: 'mOeori', field: 'mOeori', width: 60, hidden: true }
        ]
    ];
    var dataGridOption = {
        url: "DHCST.METHOD.BROKER.csp?ClassName=web.DHCSTCNTS.FindForDoctor&MethodName=JsGetOrdDataForDoctor",
        queryParams: {},
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 300, 500],
        pagination: true,
        onSelect: function(rowIndex, rowData) {
            DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdItm',
                Field: 'mOeori',
                Check: true,
                Value: rowData.mOeori,
                Type: 'Select'
            });
        },
        onClickRow: function(rowIndex, rowData) {
            if (rowData) {
                QueryCommentLog();
            }
        },
        onUnselect: function(rowIndex, rowData) {
            $(this).datagrid("unselectAll");
        },
        onLoadSuccess: function() {
			$("#gridCommentLog").datagrid("clear");
        }
    }
    DHCPHA_HUI_COM.Grid.Init("gridOrdItm", dataGridOption);
}

function InitGridCommentLog() {
    var columns = [
        [
            { title: '���', field: 'comReaGrpNo', width: 40},
            { title: '����ԭ��', field: 'comReasonDesc', width: 260},
            { title: '��������', field: 'comDate', width: 100},
            { title: '����ʱ��', field: 'comTime', width: 100},
            { title: '������', field: 'comUserName', width: 80 },
            { title: '�������', field: 'comResult', width: 100},
            { title: '���ϸ�ʾֵ', field: 'comFactorDesc', width: 80, hidden: true},
            { title: 'ҩʦ����', field: 'comAdviceDesc', width: 150},
            { title: 'ҽ������', field: 'comDocAdviceDesc', width: 100, hidden: true},
            { title: 'ҩʦ��ע', field: 'comPhNotes', width: 200 },
            { title: 'ҽ����ע', field: 'comDocNotes', width: 200 },
            { title: '��Ч', field: 'comActive', width: 50},
            { title: 'logRowId', field: 'logRowId', width: 100, hidden: false }
        ]
    ];
    var dataGridOption = {
        url: "DHCST.METHOD.BROKER.csp?ClassName=web.DHCSTCNTS.FindForDoctor&MethodName=JsGetLogForDoctor",
        queryParams: {},
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: false,
        checkOnSelect: false,
        rownumbers: false,
        columns: columns,
        pageSize: 500,
        pageList: [500],
        pagination: false,
        onSelect: function(rowIndex, rowData) {
	        if (rowData.comActive!="Y"){
		    	$(this).datagrid("unselectAll");
		    }
            DHCPHA_HUI_COM.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridCommentLog',
                Field: 'logRowId',
                Check: true,
                Value: rowData.logRowId,
                Type: 'Select'
            });
        },
        onUnselect: function(rowIndex, rowData) {
            $(this).datagrid("unselectAll");
        },
        onLoadSuccess: function() {
			DHCPHA_HUI_COM.Grid.CellTip({ TipArr: ['comReasonDesc'] });
        },
		rowStyler:function(index,row){ 
			if (row.comActive!="Y"){
				return "background:#f5f6f5";	
			}
		} 
    }
    DHCPHA_HUI_COM.Grid.Init("gridCommentLog", dataGridOption);
}

// ��ȡ����
function QueryParams() {
    var stDate = $('#dateStart').datebox('getValue');
    var edDate = $('#dateEnd').datebox('getValue');
    var comResult=$('#cmbComResult').combobox('getValue')||'';
    return stDate + "^" + edDate + "^" + SessionUser+"^"+comResult;
}
// ��ѯ
function Query() {
    var params = QueryParams();
    $('#gridOrdItm').datagrid({
        queryParams: {
            inputStr: params
        }
    });

}
// ��ѯ����ԭ��
function QueryCommentLog() {
    var gridSelect = $('#gridOrdItm').datagrid('getSelected');
    if (gridSelect==null){
	    $('#gridCommentLog').datagrid('clear');	
	    return;
	}
    var mOeori = gridSelect.mOeori;
    $('#gridCommentLog').datagrid({
        queryParams: {
            inputStr: mOeori
        }
    });
}

//���߻��߽��ܲ�������
function MainTain(type) {
    var gridSelOrdItm = $('#gridOrdItm').datagrid('getSelected');
    if (gridSelOrdItm == null) {
        $.messager.alert("��ʾ", "����ѡ��ҽ����ϸ", "warning");
        return;
    }
    var gridSelComment = $('#gridCommentLog').datagrid('getSelected');
    if (gridSelComment == null) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ" + ((type == "A") ? "����" : "����") + "�ĵ���������ԭ���¼!", "warning");
        return;
    }
    var comActive = gridSelComment.comActive;
    if (comActive != "Y") {
        $.messager.alert("��ʾ", "��ѡ����Ч��ԭ���¼", "warning");
        return;
    }
    var logRowId = gridSelComment.logRowId;
    if (type == "C") {
        var docNote = $("#txtDocNote").val().trim(); // ҽ����ע	  
        if (docNote == "") {
            $.messager.alert("��ʾ", "�����·�ԭ��¼������д����ԭ��", "warning");
            return;
        }
    } else if (type == "A") {
        var docNote = "Accept"; 					// ҽ����ע	  
    }
    var params = logRowId + "^" + docNote;
    var saveRet = tkMakeServerCall("web.DHCSTCNTS.FindForDoctor","SaveDocAdvice", params);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
        return;
    }
    $("#txtDocNote").val("");
    Query();
    if(top && top.HideExecMsgWin) {
	    top.HideExecMsgWin();

	}

}