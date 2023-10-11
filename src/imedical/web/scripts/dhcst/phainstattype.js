/** 
 * ģ��:	ͳ�Ʊ����������ά��
 * ��д����: 2019-01-22
 * ��д��:  zhaoxinlong
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId=session['LOGON.HOSPID'];
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

    /// δά��ҩƷ����
    $('#txtAlias').searchbox({
	    searcher:function(value,name){
	    QueryDetail();
	    },
	    width:400,
	    prompt:$g('��ѡ�����С�������������м���...')
	}); 
	$(".icon-help").popover({title:$g('��ʾ'),width:"400",content:$g("1.������ҵ��ܿأ�ֻ����ͳ�Ƶģ���������ά�����;<br> 2.û�з����׼�ģ�ҽԺ�Լ�����׼��ֻ����ͳ�Ƶģ�������ά��;")});
});

function InitHospCombo() {
    var hospComp = GenHospComp("PHAIN_StatType",'', { width: 300 });
    hospComp.options().onSelect = function (rowIndex, rowData) {
        PHA_COM.Session.HOSPID = rowData.HOSPRowId;
        PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
        Query();
    };
    var defHosp = $cm(
        {
            dataType: 'text',
            ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
            MethodName: 'GetDefHospIdByTableName',
            tableName: 'PHAIN_StatType',
            HospID: PHA_COM.Session.HOSPID
        },
        false
    );
    PHA_COM.Session.HOSPID = defHosp;
    PHA_COM.Session.ALL = [PHA_COM.Session.USERID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.HOSPID].join('^');
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
                halign: 'left',
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
                halign: 'left',
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
                halign: 'left',
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
            QueryName: "QueryStatType",
            page	: 1, 
        	rows	: 99999
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
    PHA.Grid("gridTypeLink", dataGridOption);
}

/// ����ͳ�Ʊ�������
function SaveTypeLink() {
    $('#gridTypeLink').datagrid('endEditing');
    var HospId = $('#_HospList').combogrid("getValue");
    if (CheckEditorVal('gridTypeLink', ['code', 'desc']) == false) {
	    return;
	}
	
    var gridChanges = $('#gridTypeLink').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
	    PHA.Popover({ showType: 'show', msg: $g('û����Ҫ���������'), type: 'alert' });
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var rowid = (iData.rowid || "");
        var code = (iData.code || "");
        var desc = (iData.desc || "");
        var remarks = (iData.remarks || "");
        var params = rowid + "^" + code + "^" + desc + "^" + remarks + "^" + HospId;
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "SaveStatType", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Popover({ showType: 'show', msg:saveInfo, type: 'alert' });
    }
    $('#gridTypeLink').datagrid("reload");
}

/// ɾ��ͳ�Ʊ�������
function DeleteType() {
    var gridSelect = $("#gridTypeLink").datagrid("getSelected");
    if (gridSelect == null) {
	    PHA.Popover({ showType: 'show', msg:"��ѡ����Ҫɾ���ļ�¼!", type: 'alert' });
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
                var delRetArr = delRet.split('^')
                if (delRetArr[0] == 0) {
                    $('#gridTypeLink').datagrid("reload");
                }
                else {
                    PHA.Popover({ showType: 'show', msg:delRetArr[1], type: 'alert' });
                     return;
                }
                
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
                halign: 'left',
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
                halign: 'left',
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
            page	: 1, 
        	rows	: 99999
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
    PHA.Grid("gridTypeCat", dataGridOption);
}

//��ʼ���ѷ���ҩƷ�б�
function InitStatInciDetail() {
    //����columns
    var columns = [
        [	      
                
        	{ field: "rowid", title: 'rowid',width: 100, hidden: true },
        	{ field: 'operate', title: '����', width: 60,halign: 'center',align: 'left',formatter: statusFormatter},
            { field: "code", title: '����',width: 100,halign: 'left',align: 'left'},
            { field: 'desc', title: '����', width: 240,halign: 'left',align: 'left'}
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCST.PHAINSTATTYPESET",
            QueryName: "QueryStatInci"
        },
        pagination: true,
        showRefresh: false,
        showPageList: false,
        afterPageText:'',
        beforePageText:'',
        displayMsg:'�� {total} ����¼',
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
    PHA.Grid("StatInciDetail", dataGridOption);
    
}
//��ʼ��δ����ҩƷ�б�
function InitInciDetail() {
    //����columns
    var columns = [
        [	
        	{ field: "rowid", title: 'rowid',width: 100, hidden: true },
        	{ field: 'operate', title: '����', width: 60,halign: 'center',align: 'center',formatter: statusFormatter},
            { field: "code", title: '����',width: 100,halign: 'left',align: 'left'},
            { field: 'desc', title: '����', width: 240,halign: 'left',align: 'left'}
            
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
        showRefresh: false,
        showPageList: false,
        afterPageText:'',
        beforePageText:'',
        displayMsg:'�� {total} ����¼',
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
    PHA.Grid("InciDetail", dataGridOption);
}
/// ���汨�����
function SaveTypeCat() {
    var gridPOLSelect = $('#gridTypeLink').datagrid('getSelected');
    if (gridPOLSelect == null) {
	    PHA.Popover({ showType: 'show', msg:"�����뱨������!", type: 'alert' });
        return;
    }
    var phaLocId = $('#_HospList').combobox("getValue")||"";
    var pinst = gridPOLSelect.rowid;
    if (pinst == "") {
	    PHA.Popover({ showType: 'show', msg:"�����뱨������", type: 'alert' });
        return;
    }
    $('#gridTypeCat').datagrid('endEditing');
    if (CheckEditorVal('gridTypeCat', ['code', 'desc']) == false) {
	    return;
	}
    var gridChanges = $('#gridTypeCat').datagrid('getChanges')
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == 0) {
	    PHA.Popover({ showType: 'show', msg:"û����Ҫ���������", type: 'alert' });
        return;
    }
    var paramsStr = "";
    for (var i = 0; i < gridChangeLen; i++) {
        var iData = gridChanges[i];
        var rowid = (iData.rowid|| "");
        var code = (iData.code|| "");
        var desc = (iData.desc || "");
        var params = pinst  + "^" + rowid + "^" + code + "^" + desc;
        paramsStr = (paramsStr == "") ? params : paramsStr + "!!" + params;
    }
    var saveRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "SaveStatTypeCat", paramsStr);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
	    PHA.Popover({ showType: 'show', msg:saveInfo, type: 'alert' });
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
        pinst: pinst,
        page	: 1, 
        rows	: 99999
    });
}

/// ɾ���������
function DeleteTypeCat() {
    var gridSelect = $("#gridTypeCat").datagrid("getSelected");
    if (gridSelect == null) {
	    PHA.Popover({ showType: 'show', msg:"��ѡ����Ҫɾ���ļ�¼!", type: 'alert' });
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
                var delRetArr = delRet.split('^')
                if (delRetArr[0] == 0) {
                    $('#gridTypeCat').datagrid("reload");
                }
                else {
                    PHA.Popover({ showType: 'show', msg:delRetArr[1], type: 'alert' });
                     return;
                }
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
	    PHA.Popover({ showType: 'show', msg:"����ѡ����Ҫ��������С��Ĵ��࣡", type: 'alert' });
        return "";
    }
    var pinst = gridSelect.rowid || "";
    if (pinst == "") {
	    PHA.Popover({ showType: 'show', msg:"���ȱ��������࣡", type: 'alert' });
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

function Query(){
	$('#gridTypeLink').datagrid('query', {
        inputStr: PHA_COM.Session.HOSPID,
        page	: 1, 
        rows	: 99999
    });
}


//��ѯδ����ҩƷ
function QueryDetail()
{
	var incAlias = $('#txtAlias').searchbox("getValue");
	var SelectrowData = $('#gridTypeCat').datagrid('getSelected');
	var pinsc = SelectrowData.rowid || "";
	if (pinsc=="") { 
		PHA.Popover({ showType: 'show', msg:"��ѡ�����С��", type: 'alert' });
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
    var IndexString = JSON.stringify(rowIndex)
    if (value == "0") {
        if (PHA_COM.IsLiteCss) {
            return "<span onclick='addInci("+ dataString +",+"+IndexString+")' class='icon-add'></span>";
        }
        else {
            return "<span onclick='addInci("+ dataString +",+"+IndexString+")' class='icon-add'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
        }
    }
    else {
        if (PHA_COM.IsLiteCss) {
            return "<span onclick='delInci("+ dataString +",+"+IndexString+")' class='icon-cancel'></span>";
        }
        else {
            return "<span onclick='delInci("+ dataString +",+"+IndexString+")' class='icon-cancel'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
        }
    }

   /* 
	if (value=="0" && PHA_COM.IsLiteCss){
		
		//return "<a href='#' onclick='addInci("+ dataString +",+"+IndexString+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_add.png' border=0/></a>";
		return "<span onclick='addInci("+ dataString +",+"+IndexString+")' class='icon-add'></span>";
	}else if(value=="0" && (!PHA_COM.IsLiteCss)){
        return "<span onclick='addInci("+ dataString +",+"+IndexString+")' class='icon-add'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
    }else if(value=='1' && PHA_COM.IsLiteCss){
		
		//return "<a href='#' onclick='delInci("+ dataString +",+"+IndexString+")'><img src='../scripts/dhcpha/jQuery/themes/icons/edit_remove.png' border=0/></a>";
		return "<span onclick='delInci("+ dataString +",+"+IndexString+")' class='icon-cancel'></span>";

	} else{
        return "<span onclick='delInci("+ dataString +",+"+IndexString+")' class='icon-cancel'>&nbsp;&nbsp;&nbsp;&nbsp;</span>";
    }
    */
}

/// ���ҩƷ haha--����
function addInci(rowData,Index) {
	 //alert(JSON.stringify(rowData))
	
    var selectRowData = $('#gridTypeCat').datagrid('getSelected');
    var pinsc = selectRowData.rowid || "";
    if (pinsc=="") {
	    PHA.Popover({ showType: 'show', msg:"��ѡ��һ��������С�࣡", type: 'alert' });
		return;
		}
	var inci=rowData.rowid || ""
	if (inci=="") {
		PHA.Popover({ showType: 'show', msg:"��ѡ��Ҫ��ӵ�ҩƷ��", type: 'alert' });
		return;
		}
    var saveRet = tkMakeServerCall("web.DHCST.PHAINSTATTYPESET", "addInci", pinsc,inci);
    var saveArr = saveRet.split("^");
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
	    PHA.Popover({ showType: 'show', msg:saveInfo, type: 'alert' });
    }
    $('#InciDetail').datagrid("deleteRow", Index);
    $('#InciDetail').datagrid("reload");
    $('#StatInciDetail').datagrid("reload");

    
}

/// ɾ��ҩƷ
function delInci(rowData,Index) {
    if (rowData == null) {
	    PHA.Popover({ showType: 'show', msg:"��ѡ����Ҫɾ���ļ�¼!", type: 'alert' });
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

// ��֤���༭���ֵ
// Huxt 2020-09-21
function CheckEditorVal(gridId, fieldsArr){
	var fieldTitle = GetFieldTitle(gridId);
	var $GRID = $('#' + gridId);
	var rowsData = $GRID.datagrid('getRows');
	var mRows = rowsData.length;
	for (var i = 0; i < mRows; i++) {
		var mRowData = rowsData[i];
		for (var j = 0; j < fieldsArr.length; j++) {
			var oneField = fieldsArr[j];
			var cellVal = mRowData[oneField] || "";
			var cellEdVal = "";
			var ed = $GRID.datagrid('getEditor', {index:i, field:oneField});
			if (ed != null && ed !== undefined) {
				cellEdVal = $(ed.target).val();
			}
			if (cellVal == "" && cellEdVal == "") {
				$.messager.popover({
					msg: "��" + (i + 1) + "��, " + fieldTitle[oneField] + "����Ϊ��!!!",
					type: 'alert',
					timeout: 1000
				});
				return false;
			}
		}
	}
	return true;
}

// ��ȡfield��title�Ķ���, ���ظ�ʽ: {field:title, field:title, ...}
function GetFieldTitle(gridId){
	var $GRID = $('#' + gridId);
	var gridOpts = $GRID.datagrid('options');
	if (gridOpts.FieldTitle) {
		return $GRID.datagrid('options').FieldTitle;
	}
	var mFieldTitle = {};
	var columns = gridOpts.columns;
	var sColumns = columns[0];
	for (var c = 0; c < sColumns.length; c++) {
		var oneCol = sColumns[c];
		mFieldTitle[oneCol.field] = oneCol.title;
	}
	gridOpts.FieldTitle = mFieldTitle;
	return mFieldTitle;
}

function OpenHelpWin()
{	
	//$(".icon-help").popover({trigger:'manual',placement:'bottom',title:'HUI����',content:'content'});
	//$(".icon-help").popover('show');
}