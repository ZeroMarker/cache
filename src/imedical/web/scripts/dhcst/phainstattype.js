/** 
 * ģ��:	ͳ�Ʊ����������ά��
 * ��д����: 2019-01-22
 * ��д��:  zhaoxinlong
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId=""
$(function() {
	InitHospCombo(); //����ҽԺ
    InitGridDict();
    InitStatType();
    InitTypeCat();
    InitStatInciDetail()
    InitInciDetail()
    //��������
    $("#btnAdd").on("click", AddTypeLink);
    $("#btnSave").on("click", SaveTypeLink);
    $("#btnDelete").on("click", DeleteType);
    //�������
    $("#btnAddPoli").on("click", AddTypeCat);
    $("#btnSavePoli").on("click", SaveTypeCat);
    $("#btnDelPoli").on("click", DeleteTypeCat);
    //����
	$('#txtAlias').on('keypress', function(event) {
    if (event.keyCode == "13") {
            QueryDetail();
        }
    });
});

function InitHospCombo() {
    var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
    if (hospAutFlag === 'Y') {
        $('#lyMainView').layout('add', {
            region: 'north',
            border: false,
            title: '',
            height: '40',
            bodyCls: 'pha-ly-hosp',
            content:
                '<div style="padding-left:10px;">' +
                '   <div class="pha-row">' +
                '       <div class="pha-col">' +
                '           <label id="_HospListLabel" style="color:red;" class="r-label">ҽԺ</label>' +
                '       </div>' +
                '   	<div class="pha-col">' +
                '       	<input id="_HospList" class="textbox"/>' +
                '   	</div>' +
                '	</div>' +
                '</div>'
        });

        var genObj = GenHospComp('PHAIN_StatType');
        //����ѡ���¼�
        $('#_HospList').combogrid('options').onSelect = function (index, record) {
            HospId= record.HOSPRowId;
				    $('#gridTypeLink').datagrid('query', {
				        inputStr: HospId
				    });
            
            	
           
        };
    }
}


function InitGridDict() {
}

/// ��ʼ��ͳ�Ʊ�������
function InitStatType() {
    var columns = [
        [
            { field: "rowid", title: 'rowid', hidden: true, align: 'center' },
            {
                field: 'code',
                title: '����',
                width: 200,
                halign: 'center',
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },            {
                field: 'desc',
                title: '����',
                width: 200,
                halign: 'center',
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },            {
                field: 'remarks',
                title: '��ע',
                width: 200,
                halign: 'center',
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: false
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCST.PHAINSTATTYPESET",
            QueryName: "QueryStatType"
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: true,
        columns: columns,
        toolbar: "#gridTypeLinkBar",
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
            if ($(this).datagrid('options').editIndex == undefined) {
                QueryTypeCat();
            }
        },
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'desc'
            });
        },
        onLoadSuccess: function() {
            QueryTypeCat();
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridTypeLink", dataGridOption);
}

/// ����ͳ�Ʊ�������
function SaveTypeLink() {
    $('#gridTypeLink').datagrid('endEditing');
    var HospId=$('#_HospList').combogrid("getValue");
    
    var gridChanges = $('#gridTypeLink').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("��ʾ", "û����Ҫ���������", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params = (iData.rowid || "") + "^" + (iData.code || "")+"^" + (iData.desc || "")+"^" + (iData.remarks || "")+"^"+HospId;
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "SaveStatType", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#gridTypeLink').datagrid("reload");
}

/// ɾ��ͳ�Ʊ�������
function DeleteType() {
    var gridSelect = $("#gridTypeLink").datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "��ѡ����Ҫɾ���ļ�¼!", "warning");
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function(r) {
        if (r) {
            var pinst = gridSelect.rowid || "";
            if (pinst == "") {
                var rowIndex = $('#gridTypeLink').datagrid('getRowIndex', gridSelect);
                $('#gridTypeLink').datagrid("deleteRow", rowIndex);
            } else {
                var delRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "DeleteType", pinst);
                $('#gridTypeLink').datagrid("reload");
            }
        }
    })
}

/// ��ʼ���������
function InitTypeCat() {
    var columns = [
        [
            { field: "rowid", title: 'rowid', hidden: true },
            {
                field: 'code',
                title: '����',
                width: 200,
                halign: 'center',
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            },{
                field: 'desc',
                title: '����',
                width: 200,
                halign: 'center',
                align: 'left',
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true
                    }
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCST.PHAINSTATTYPESET",
            QueryName: "QueryStatTypeCat",
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: true,
        columns: columns,
        toolbar: "#gridTypeCatBar",
        onClickRow: function(rowIndex, rowData) {
            $(this).datagrid('endEditing');
            
            QueryStatInciDetail(rowData);
            QueryInciDetail(rowData);
            
        },
        onDblClickRow: function(rowIndex, rowData) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'desc'
            });
        },
        onLoadSuccess: function() {
            $("#StatInciDetail").datagrid("clear");
            $("#InciDetail").datagrid("clear");
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridTypeCat", dataGridOption);
}

//��ʼ���ѷ���ҩƷ�б�
function InitStatInciDetail() {
    //����columns
    var columns = [
        [	      
                
        	{ field: "rowid", title: 'rowid',width: 100, hidden: true },
            { field: "code", title: '����',width: 100,halign: 'center',align: 'left'},
            { field: 'desc', title: '����', width: 240,halign: 'center',align: 'left'},
            { field: 'operate', title: '����', width: 60,halign: 'center',align: 'center',formatter: statusFormatter}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCST.PHAINSTATTYPESET",
            QueryName: "QueryStatInci"
        },
        pagination: true,
        fitColumns: true,
        fit: true,
        rownumbers: true,
        columns: columns,
        toolbar:[],
        onClickRow: function(rowIndex, rowData) {
            
        },
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function() {
        }
    };
    DHCPHA_HUI_COM.Grid.Init("StatInciDetail", dataGridOption);
    
}
//��ʼ��δ����ҩƷ�б�
function InitInciDetail() {
    //����columns
    var columns = [
        [	
        	{ field: "rowid", title: 'rowid',width: 100, hidden: true },
            { field: "code", title: '����',width: 100,halign: 'center',align: 'left'},
            { field: 'desc', title: '����', width: 240,halign: 'center',align: 'left'},
            { field: 'operate', title: '����', width: 60,halign: 'center',align: 'center',formatter: statusFormatter}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCST.PHAINSTATTYPESET",
            QueryName: "QueryInci"
        },
        toolbar:"#toolbar",  //���ֲ��ı�߶�
        pagination: true,
        fitColumns: true,
        fit: true,
        rownumbers: true,
        columns: columns,
        toolbar:"#InciDetailBar",
        onClickRow: function(rowIndex, rowData) {
        
        },
        singleSelect: true,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function() {
        }
    };
    DHCPHA_HUI_COM.Grid.Init("InciDetail", dataGridOption);
}
/// ���汨�����
function SaveTypeCat() {
    var gridPOLSelect = $('#gridTypeLink').datagrid('getSelected');
    var phaLocId=$('#_HospList').combobox("getValue")||"";
    var pinst = gridPOLSelect.rowid;
    if (pinst == "") {
        $.messager.alert("��ʾ", "�����뱨������", "warning");
        return;
    }
    $('#gridTypeCat').datagrid('endEditing');
    var gridChanges = $('#gridTypeCat').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
        $.messager.alert("��ʾ", "û����Ҫ���������", "warning");
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var params =pinst  + "^" +(iData.rowid|| "")+ "^" +(iData.code|| "")+"^"+ (iData.desc || "");
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "SaveStatTypeCat", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#gridTypeCat').datagrid("reload");
}
//��ȡ�������
function QueryTypeCat() {
    var gridSelect = $('#gridTypeLink').datagrid('getSelected');
    var pinst = "";
    if (gridSelect){
        pinst=gridSelect.rowid || "";
    }
    $('#gridTypeCat').datagrid('query', {
        pinst: pinst
    });
}

/// ɾ���������
function DeleteTypeCat() {
    var gridSelect = $("#gridTypeCat").datagrid("getSelected");
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "��ѡ����Ҫɾ���ļ�¼!", "warning");
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function(r) {
        if (r) {
            var pinsc = gridSelect.rowid || "";
            if (pinsc == "") {
                var rowIndex = $('#gridTypeCat').datagrid('getRowIndex', gridSelect);
                $('#gridTypeCat').datagrid("deleteRow", rowIndex);
            } else {
                var delRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "DeleteTypeCat", pinsc);
                $('#gridTypeCat').datagrid("reload");
            }
        }
    })
}

/// ������������
function AddTypeLink() {
    $("#gridTypeLink").datagrid('addNewRow', {
        editField: 'code'
    });
    $("#gridTypeCat").datagrid("clear");
}

/// �����������
function AddTypeCat() {
    var pinst = GetSelectrowid();
    if (pinst == "") {
        return;
    }
    $("#gridTypeCat").datagrid('addNewRow', {
        editField: 'code'
    });
}
function GetSelectrowid() {
    var gridSelect = $('#gridTypeLink').datagrid('getSelected');
    if (gridSelect == null) {
        $.messager.alert("��ʾ", "����ѡ����Ҫ���ӷ���ı�������", "warning");
        return "";
    }
    var pinst = gridSelect.rowid || "";
    if (pinst == "") {
        $.messager.alert("��ʾ", "���ȱ��汨������", "warning");
        return "";
    }
    return pinst;
}
//��ѯ�ѷ���ҩƷ
function QueryStatInciDetail(SelectrowData) {
    var pinsc = SelectrowData.rowid || "";
    $('#StatInciDetail').datagrid('query', {
        pinsc: pinsc
    });
}
//��ѯδ����ҩƷ,������¼���Ϊ��ȷ
function QueryInciDetail(SelectrowData) {
	var incAlias = $("#txtAlias").val().trim();
    var pinsc = SelectrowData.rowid || "";
    var param=pinsc+"!!"+incAlias+"!!"+HospId;
    $('#InciDetail').datagrid('query', {
        inputStr: param
    });
}
//��ѯδ����ҩƷ
function QueryDetail()
{
	var incAlias = $("#txtAlias").val().trim();
	var SelectrowData = $('#gridTypeCat').datagrid('getSelected');
	var pinsc = SelectrowData.rowid || "";
	if (pinsc=="") { 
		$.messager.alert("��ʾ", "��ѡ�񱨱����", "warning");
        return ;
        }
	var param=pinsc+"!!"+incAlias+"!!"+HospId;
    $('#InciDetail').datagrid('query', {
        inputStr: param
    });
	
	
	}
function statusFormatter(value, rowData, rowIndex){
	//������󴫲���ȥ,ת���ַ����ʹ���ȥ��,��Ӧ��������ȡֵ�ֳ��˶���
	var dataString=JSON.stringify(rowData)
	var IndexString=JSON.stringify(rowIndex)
	if (value=="0"){
		
		//return "<a href='#' onclick='addInci("+ dataString +",+"+IndexString+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_add.png' border=0/></a>";
		return "<a href='#' onclick='addInci("+ dataString +",+"+IndexString+")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/add.png' border=0/></a>";
	}else{
		
		//return "<a href='#' onclick='delInci("+ dataString +",+"+IndexString+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
		return "<a href='#' onclick='delInci("+ dataString +",+"+IndexString+")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/edit_remove.png' border=0/></a>";

	}  
}

/// ���ҩƷ haha--����
function addInci(rowData,Index) {
	 //alert(JSON.stringify(rowData))
	
    var selectRowData = $('#gridTypeCat').datagrid('getSelected');
    var pinsc = selectRowData.rowid || "";
    if (pinsc=="") {
		$.messager.alert("��ʾ", "��ѡ�񱨱����򱣴���ѡ����", "warning");
		return;
		}
	var inci=rowData.rowid || ""
	if (inci=="") {
		$.messager.alert("��ʾ", "��ѡ��Ҫ��ӵ�ҩƷ", "warning");
		return;
		}
    var saveRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "addInci", pinsc,inci);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        $.messager.alert("��ʾ", saveInfo, "warning");
    }
    $('#InciDetail').datagrid("deleteRow", Index);
    $('#InciDetail').datagrid("reload");
    $('#StatInciDetail').datagrid("reload");

    
}

/// ɾ��ҩƷ
function delInci(rowData,Index) {
    if (rowData == null) {
        $.messager.alert("��ʾ", "��ѡ����Ҫɾ���ļ�¼!", "warning");
        return;
    }
    $.messager.confirm('ȷ�϶Ի���', 'ȷ��ɾ����', function(r) {
        if (r) {
            var pinsd = rowData.rowid || "";
            if (pinsd == "") {
                $('#StatInciDetail').datagrid("deleteRow", Index);
            } else {
                var Ret = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "delInci", pinsd);
                $('#InciDetail').datagrid("reload");
                $('#StatInciDetail').datagrid("reload");
            }
        }
    })
}