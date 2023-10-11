var PageLogicObj = {
    RowId: "",
    MethodID: "",
    InParamStr: "",
    m_LogListDataGrid: "",
}
$(function() {
    Init();
    InitEvent();
})

function Init() {
    $('#sStDateTime').datetimebox('setValue', ServerObj.PreDateTime);
    $('#sEndDateTime').datetimebox('setValue', ServerObj.LastDateTime);
    InitProductLine();
    InitLogListDataGrid();
    ReLoadLogListDataGrid();
}

function InitEvent() {
    $('#Find').click(ReLoadLogListDataGrid);
    $('#Clear').click(ClearClick);
    $('#debugBtn').click(DebugClick);
}

function InitLogListDataGrid() {
    var toolbar = [];
    var Columns = [
        [
            { field: 'ColOper', title: '�в���', width: 80,
                formatter: function(v, rec, index) {
                    var editBtn = '<a href="#this" class="editcls" onclick="EditRow(' + (rec.ID + ',' + index) + ')"></a>';
                    return editBtn;
                }
            },
            { field: 'ID', title: 'ID', width: 20, hidden: 'true', align: "center" },
            { field: 'LogCode', title: '��־����', width: 200, align: "center" },
            { field: 'LogDesc', title: '��־����', width: 200, align: "center" },
            { field: 'LogStatus', title: '��־״̬', width: 100, align: "center",
                formatter: function(v, rec, index) {
                    var LogFlag = (rec.LogStatus == "Y") ? "�ɹ�" : "ʧ��";
                    return LogFlag;
                },
                styler: function(v, rec, index){
					if (rec.LogStatus != "Y"){
						return 'background-color:#FFC1C1; color:red;';
					}
				}
            },
            { field: 'LogType', title: '��־����', width: 100, align: "center"},
            { field: 'InStr', title: '���', width: 250, align: "center", hidden:true },
            { field: 'OutStr', title: '����', width: 250, align: "center", hidden:true },
            { field: 'MClassName', title: '������', width: 200, align: "center" },
            { field: 'MMethodName', title: '������', width: 200, align: "center" },
            { field: 'MMethodType', title: '��������', width: 100, align: "center" },
            { field: 'IP', title: '����IP', width: 120, align: "center" },
            { field: 'SessionInfo', title: '�û���Ϣ', width: 250, align: "center" },
            { field: 'InsertDate', title: '��������', width: 100, align: "center" },
            { field: 'InsertTime', title: '����ʱ��', width: 100, align: "center" },
        ]
    ]
    var LogListDataGrid = $("#LogListTab").datagrid({
        fit: true,
        border: false,
        striped: true,
        singleSelect: true,
        fitColumns: false,
        autoRowHeight: false,
        rownumbers: true,
        pagination: true,
        rownumbers: true,
        pageSize: 20,
        pageList: [20, 100, 200],
        idField: 'id',
        columns: Columns,
        toolbar: toolbar,
        onLoadSuccess: function(data) {
	        ChangeButtonText($('.editcls'),"��ϸ","icon-report-eye");
        },
        onDblClickRow: function(index,row) {
	        EditRow(row.ID,index);
        }
    });
    PageLogicObj.m_LogListDataGrid = LogListDataGrid;
    return LogListDataGrid;
}

function ReLoadLogListDataGrid() {
	$("#LogListTab").datagrid('clearSelections');
    var StDateTime = $('#sStDateTime').datetimebox('getValue');
    var EndDateTime = $('#sEndDateTime').datetimebox('getValue');
    if (StDateTime == "") {
        $.messager.alert("��ʾ", "��ʼ���ڲ���Ϊ�գ�");
        $("#sStDateTime").focus();
    }
    if (EndDateTime == "") {
        $.messager.alert("��ʾ", "�������ڲ���Ϊ�գ�");
        $("#sStDateTime").focus();
    }
    var LogCode = $("#sLogCode").val();
    var LogDesc = $("#sLogDesc").val();
    var Status = $("#sStatus").combobox("getValue");
    var LogContent = $("#sLogContent").val();
    var LogType = $("#sLogType").combobox('getValue');
    var Input = LogCode + "^" + LogDesc + "^" + Status + "^" + LogContent + "^" + LogType;

    $.cm({
        ClassName: "web.DHCDocInterfaceLog",
        QueryName: "GetLogListData",
        StDateTime: StDateTime,
        EndDateTime: EndDateTime,
        Input: Input,
        rows:1000  //Ĭ��֮չʾ1000�����ݣ���������Ҫ����������
    }, function(GridData) {
        PageLogicObj.m_LogListDataGrid.datagrid({ loadFilter: DocToolsHUI.lib.pagerFilter }).datagrid('loadData', GridData);
    });
}

function ClearClick(){
	$("#sLogCode,#sLogDesc,#sLogContent").val("");
	$("#sLogType,#sStatus").combobox('select', "ALL");
	$('#sStDateTime').datetimebox('setValue', ServerObj.PreDateTime);
    $('#sEndDateTime').datetimebox('setValue', ServerObj.LastDateTime);
	ReLoadLogListDataGrid();
}

function EditRow(ID, Index) {
    PageLogicObj.RowId = ID;
    $("#LogListTab").datagrid('selectRow', Index);

    var ParamsStr = $.m({
        ClassName: "web.DHCDocInterfaceLog",
        MethodName: "GetLogListDetail",
        RowID: ID
    }, false);
    $("#debugBtn").show();
    var ParamsArr = ParamsStr.split(String.fromCharCode(29));
    if (ParamsArr[0] == "") $("#debugBtn").hide();
    PageLogicObj.MethodID = ParamsArr[0];
    //$("#MethodDetail").val(ParamsArr[1]);
    var NewLine=new RegExp(String.fromCharCode(28),"g");
    var LogInvokeInfo = ParamsArr[2].replace(NewLine, "\n");
    $("#LogInvokeInfo").val(LogInvokeInfo);
    PageLogicObj.InParamStr = ParamsArr[3];
    if (ParamsArr[3] != "") {
        var LogInParams = "";
        var InArr = ParamsArr[3].split(String.fromCharCode(28));
        for (var i = 0; i < InArr.length; i++) {
            LogInParams += (i == 0) ? '"' + InArr[i] + '"' : ',"' + InArr[i] + '"';
        }
        $("#LogInParams").val(LogInParams);
    }
    $("#LogOutParams").val(ParamsArr[4]);
    var MethodType=ParamsArr[5];
    var ClassName=ParamsArr[6];
    var MethodName=ParamsArr[7];
    var MethodDetail="";
    if (ClassName!=""){
	    var LogInParams=$("#LogInParams").val();
	    if (MethodType=="ClassMethod"){
			MethodDetail='ClassMethod:  w ##class('+ClassName+').'+MethodName+'('+LogInParams+')';
		}else{
			MethodDetail='Query:  d ##class(%ResultSet).RunQuery("'+ClassName+'","'+MethodName+'",'+LogInParams+')';
		}
    }
    $("#MethodDetail").val(MethodDetail);
    $("#LogDetail").window('open');  
}

function DebugClick() {
    var MethodID = PageLogicObj.MethodID || "";
    if (MethodID == "") {
        $.messager.alert("��ʾ", "��־����û��ע��ҽ��վ�ӿ�ע�᷽�������ܵ��ԣ�");
        return false;
    }
    $("#LogOutParams").val("");
    var OutParams = $.m({
        ClassName: "web.DHCDocInterfaceMethod",
        MethodName: "DebugInterfaceMethod",
        RowID: MethodID,
        ParamStr: PageLogicObj.InParamStr
    }, false);
    $("#LogOutParams").val(OutParams);
    ReLoadLogListDataGrid();
}

function InitProductLine() {
    $HUI.combobox("#sProductLine", {
        url: $URL + "?ClassName=DHCDoc.DHCDocConfig.LocalConfig&QueryName=QryProductLine&ResultSetType=array",
        valueField: 'code',
        textField: 'name',
        rowStyle: 'checkbox',
        multiple: true,
        editable: false
    });
}

function ChangeButtonText(element,desc,icon){
	$(element).linkbutton({iconCls: icon, plain: true});
	$(element).popover({content: desc, placement: 'top-right', trigger: 'hover'});
}
