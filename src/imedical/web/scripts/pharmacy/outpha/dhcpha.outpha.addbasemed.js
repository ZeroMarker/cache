/**
 * ģ��:����ҩ��
 * ��ģ��:����ҩ��-��ҳ-��˵�-�������ҩƷά��
 * createdate:2016-06-23
 * creator:yunhaibao
 */
var HospId=session['LOGON.HOSPID'];
var commonOutPhaUrl = "DHCST.OUTPHA.ACTION.csp";
var gLocId = session['LOGON.CTLOCID'];
var gUserId = session['LOGON.USERID'];
var gGroupId = session['LOGON.GROUPID'];
$(function () {
	InitHospCombo();
    /// ��ʼ��ҽ������
    var options = {
        url: commonOutPhaUrl + '?action=GetCtLocDs&HospId='+HospId
    }
    $('#docLoc').dhcphaEasyUICombo(options);
    /// ��ʼ��ʹ�ÿ���
    var options = {
        url: commonOutPhaUrl + '?action=GetCtLocDs&HospId='+HospId
    }
    $('#useLoc').dhcphaEasyUICombo(options);
    /// ��ʼ���÷�
    var options = {
        url: commonOutPhaUrl + '?action=GetInstuDs'
    }
    $('#instu').dhcphaEasyUICombo(options);
    /// ��ʼ��ҩƷ
    InitCmgArcItm();

    InitBaseMedGrid();
    $('#basemedgrid').datagrid('reload');
    $('#btnDelete').bind('click', btnDeleteHandler);
    $('#btnClear').bind('click', btnClearHandler);
    $('#btnAdd').bind('click', btnAddHandler);
    $('#btnUpdate').bind('click', btnUpdateHandler);
    $("[name=baseType]").on("click", Query);
});

function InitCmgArcItm() {
    var tmpOptions = {
        url: "DHCST.QUERY.JSON.csp?Plugin=EasyUI.DataGrid&" +
            "ClassName=web.DHCST.ARCITMMAST&QueryName=GetArcItmMast" +
            "&StrParams=" + "|@|" + "|@|" + HospId,
        columns: [
            [{
                field: 'arcItmRowId',
                title: 'arcItmRowId',
                width: 100,
                sortable: true,
                hidden: true
            }, {
                field: 'arcItmCode',
                title: 'ҩƷ����',
                width: 100,
                sortable: true
            }, {
                field: 'arcItmDesc',
                title: 'ҩƷ����',
                width: 300,
                sortable: true
            }]
        ],
        idField: 'arcItmRowId',
        textField: 'arcItmDesc',
        mode: "remote",
        pageSize: 30,
        pageList: [30, 50, 100],
        pagination: true,
        panelWidth: 500,
        delay: 500,
        onBeforeLoad: function (param) {
	        param.q = param.q + "|@|" + "|@|" + HospId;
            param.StrParams = param.q;
        }
        /*
        ,
        onLoadSuccess: function (data) {
        	
        	LoadTimes=LoadTimes+1;
        	if (LoadTimes==1){
        	if (arcItmRowId!=""){
        	$("#cmbLinkDict").combogrid("setValue",arcItmRowId);
        	}else{
        	$("#cmbLinkDict").combogrid("clear");
        	}
        	}
        	 
        }*/
    }
    $("#cmgArcItm").combogrid(tmpOptions);
}
//��ʼ������ҩƷgrid
function InitBaseMedGrid() {
    //����columns
    var columns = [
        [{
            field: 'Tarcitm',
            title: 'ҩƷ����',
            width: 275
        }, {
            field: 'Tinst',
            title: '�÷�',
            width: 190
        }, {
            field: 'Tdocloc',
            title: '��������',
            width: 220
        }, {
            field: 'Tuseloc',
            title: 'ʹ�ÿ���',
            width: 220
        }, {
            field: 'Tnote',
            title: '��ע',
            width: 200
        }, {
            field: 'Tphbr',
            title: 'Tphbr',
            width: 150,
            hidden: true
        }, {
            field: 'Tinstrowid',
            title: 'Tinstrowid',
            width: 150,
            hidden: true
        }, {
            field: 'Tdoclocdr',
            title: 'Tdoclocdr',
            width: 150,
            hidden: true
        }, {
            field: 'Tuselocdr',
            title: 'Tuselocdr',
            width: 150,
            hidden: true
        }, {
            field: 'Tarcdr',
            title: 'Tarcdr',
            width: 150,
            hidden: true
        }, {
            field: 'Tinci',
            title: 'Tinci',
            width: 150,
            hidden: true
        }]
    ];

    //����datagrid
    $('#basemedgrid').datagrid({
        url: "websys.Broker.cls" + '?ClassName=PHA.OP.CfBase.Query&QueryName=LocBaseMed',
        queryParams: {
            InputStr: $("[name=baseType]:checked").val(),
            HospId: HospId
        },
        fit: true,
        striped: true,
        border: false,
        toolbar: '#btnbar',
        singleSelect: true,
        rownumbers: false,
        columns: columns,
        pageSize: 50, // ÿҳ��ʾ�ļ�¼����
        pageList: [50, 100, 300], // ��������ÿҳ��¼�������б�
        singleSelect: true,
        loadMsg: '���ڼ�����Ϣ...',
        fitColumns: false,
        pagination: true,
        onClickRow: function (rowIndex, rowData) {
            if (rowData) {
                var RowId = rowData['TRowId'];
                $("#remark").val(rowData["Tnote"]);
                $("#cmgArcItm").combogrid("setValue", rowData["Tarcdr"]);
                $("#cmgArcItm").combogrid("setText", rowData["Tarcitm"]);
                $("#instu").combobox('setValue', rowData["Tinstrowid"]);
                //$("#docLoc").combobox('setValue', rowData["Tdoclocdr"]);
                //$("#useLoc").combobox('setValue', rowData["Tuselocdr"]);
				
				var docLocdr=rowData["Tdoclocdr"]
				var docLoc=rowData["Tdocloc"]
				
				var datas = $("#docLoc").combobox("getData");
	            var exitFlag=0
		        for (var i = 0; i < datas.length; i++) {
		            if (datas[i].RowId == docLocdr) {
			            exitFlag=1
		            }
		        }
		        if(exitFlag==0){
			        data = [];
			        data.push({ "RowId": docLocdr, "Desc": docLoc });
		        	$("#docLoc").combobox("loadData", data);
		        	$("#docLoc").combobox("setValue", docLocdr);
		        }else{
			    	$("#docLoc").combobox("setValue", docLocdr);
			    }
			    
			    
				var uselocdr=rowData["Tuselocdr"]
				var useloc=rowData["Tuseloc"]
				
				var datas = $("#useLoc").combobox("getData");
	            var exitFlag=0
		        for (var i = 0; i < datas.length; i++) {
		            if (datas[i].RowId == uselocdr) {
			            exitFlag=1
		            }
		        }
		        if(exitFlag==0){
			        data = [];
			        data.push({ "RowId": uselocdr, "Desc": useloc });
		        	$("#useLoc").combobox("loadData", data);
		        	$("#useLoc").combobox("setValue", uselocdr);
		        }else{
			    	$("#useLoc").combobox("setValue", uselocdr);
			    }
				
				
            }
        }
    });
}

///����
function btnAddHandler() {
	var basetype = $("[name=baseType]:checked").val();
    var remark = $("#remark").val();
    var arcim = $("#cmgArcItm").combogrid("getValue") || "";
    if (arcim == "") {
        $.messager.alert('��ʾ', "��¼��ҩƷ����!", "info");
        return;
    }
    var instu = $("#instu").combobox('getValue');
    if ($.trim($("#instu").combobox('getText')) == "") {
        instu = "";
    }
    var docloc = $("#docLoc").combobox('getValue');
    if ($.trim($("#docLoc").combobox('getText')) == "") {
        docloc = "";
    }
    if (docloc == "") {
        $.messager.alert('��ʾ', "��ѡ�񿪵�����!", "info");
        return;
    }
    var useloc = $("#useLoc").combobox('getValue');
    if ($.trim($("#useLoc").combobox('getText')) == "") {
        useloc = "";
    }
    if (useloc == "") {
        $.messager.alert('��ʾ', "��ѡ��ʹ�ÿ���!", "info");
        return;
    }
    var returnValue = tkMakeServerCall("PHA.OP.CfBase.OperTab", "AddBaseMed", arcim, instu, docloc, useloc, remark,basetype);
    if (returnValue == 0) {
        $.messager.alert('��ʾ', "����������ظ�����!", "info");
        return;
    } else if (returnValue > 0) {
        $('#basemedgrid').datagrid('reload');
        btnClearHandler();
    }
}

///ɾ��
function btnDeleteHandler() {
    var seletcted = $("#basemedgrid").datagrid("getSelected");
    if (seletcted == null) {
        $.messager.alert('��ʾ', "����ѡ����Ҫɾ���ļ�¼!", "info");
        return;
    }
    var phbr = seletcted["Tphbr"];
    $.messager.confirm('��ʾ', "ȷ��ɾ����", function (r) {
        if (r) {
            var retValue = tkMakeServerCall("PHA.OP.CfBase.OperTab", "DelBaseMed", phbr);
            if (retValue == 0) {
                $('#basemedgrid').datagrid('reload');
                btnClearHandler();
            } else {
                $.messager.alert('��ʾ', "ɾ��ʧ��,�������:" + retValue, "error");
            }
        }
    });
}
///�޸�
function btnUpdateHandler() {
    var seletcted = $("#basemedgrid").datagrid("getSelected");
    if (seletcted == null) {
        $.messager.alert('��ʾ', "����ѡ����Ҫ�޸ĵļ�¼!", "info");
        return;
    }
    var basetype = $("[name=baseType]:checked").val();
    var remark = $("#remark").val();
    var arcim = $("#cmgArcItm").combogrid("getValue") || "";
    if (arcim == "") {
        $.messager.alert('��ʾ', "��¼��ҩƷ����!", "info");
        return;
    }
    var instu = $("#instu").combobox('getValue');
    if ($.trim($("#instu").combobox('getText')) == "") {
        instu = "";
    }
    var docloc = $("#docLoc").combobox('getValue');
    if ($.trim($("#docLoc").combobox('getText')) == "") {
        docloc = "";
    }
    if (docloc == "") {
        $.messager.alert('��ʾ', "��ѡ�񿪵�����!", "info");
        return;
    }
    var useloc = $("#useLoc").combobox('getValue');
    if ($.trim($("#useLoc").combobox('getText')) == "") {
        useloc = "";
    }
    if (useloc == "") {
        $.messager.alert('��ʾ', "��ѡ��ʹ�ÿ���!", "info");
        return;
    }
    var phbr = seletcted["Tphbr"];
    var returnValue = tkMakeServerCall("PHA.OP.CfBase.OperTab", "UpdBaseMed", phbr, arcim, instu, docloc, useloc, remark,basetype);
    if (returnValue == 0) {
        $('#basemedgrid').datagrid('reload');
        btnClearHandler();
    } else if (returnValue == -2) {
        $.messager.alert('��ʾ', "�޸ĺ�ļ�¼�Ѵ���!", "info");
    } else {
        $.messager.alert('��ʾ', "�޸�ʧ��,�������:" + returnValue, "error");
    }
}
///���
function btnClearHandler() {
    $("input[name=txtCondition]").val("");
    $("#docLoc").combobox('setValue', "");
    $("#useLoc").combobox('setValue', "");
    $("#instu").combobox('setValue', "");
    $("#cmgArcItm").combogrid("clear");
    $("#cmgArcItm").combogrid("grid").datagrid("options").queryParams.q = "";
    $("#cmgArcItm").combogrid("grid").datagrid("reload");
    Query();
}

function Query() {
    $('#basemedgrid').datagrid("load", {
        InputStr: $("[name=baseType]:checked").val(),
        HospId: HospId
    });
}

function InitHospCombo(){
	var genHospObj =DHCSTEASYUI.GenHospComp({tableName:'PHA-COM-BasicDrug'}); //����ҽԺ
	if (typeof genHospObj === 'object') {
		//����ѡ���¼�
		$('#_HospList').combogrid("options").onSelect=function(index,record){
			NewHospId=record.HOSPRowId;
			if(NewHospId!=HospId){
				HospId=NewHospId;
				$('#docLoc').combobox('options').url=commonOutPhaUrl + '?action=GetCtLocDs&HospId='+HospId;	
				$('#docLoc').combobox('reload');	
				$('#useLoc').combobox('options').url=commonOutPhaUrl + '?action=GetCtLocDs&HospId='+HospId
				$('#useLoc').combobox('reload');
				btnClearHandler(); //����			
			}
		};
	}
}