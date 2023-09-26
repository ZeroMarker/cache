/** 
 * ģ��: 	 ������Һ����
 * ��д����: 2018-03-05
 * ��д��:   yunhaibao
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var ConfirmMsgInfoArr = [];
var GridCmbBatNo;
var NeedScroll="Y"; // �Ƿ���Ҫ������0��
$(function() {
    PIVAS.Grid.Pagination();
    InitDict();
    InitGridWard();
    InitGridAdm();
    InitGridOrdExe();
    $('#btnFind').on("click", Query);
    $('#btnFindDetail').on("click", QueryDetail);
    $('#btnSave').on("click", SaveData);
    $('#btnPack').on('click', function() {
        PackSelectDsp('P');
    });
    $('#btnUnPack').on('click', function() {
        PackSelectDsp('');
    });
    $('#btnUnSave').on('click', DelBatUpdate);
    $('#btnUpdBat').on('click', ConfirmUpdBatUpdate);
    $('#txtPatNo').on('keypress', function(event) {
        if (event.keyCode == "13") {
            GetPatAdmList(); //���ò�ѯ
        }
    });
    $("#btnSelectAll").on("click", function () {
		CheckRowsGlobal("", "Y", "Y");
	});
	$("#btnUnSelectAll").on("click", function () {
		CheckRowsGlobal("", "N", "Y");
	});
    InitPivasSettings();
	$(".dhcpha-win-mask").remove();
});

function InitDict() {
    // ��Һ����
    PIVAS.ComboBox.Init({ Id: 'cmbPivaCat', Type: 'PivaCat' }, { width: 120 });
    // ������
    PIVAS.ComboBox.Init({ Id: 'cmbLocGrp', Type: 'LocGrp' }, {});
    // ����
    PIVAS.ComboBox.Init({ Id: 'cmbWard', Type: 'Ward' }, {});
    // ҽ�����ȼ�
    PIVAS.ComboBox.Init({ Id: 'cmbPriority', Type: 'Priority' }, { width: 120, });
    // ������
    PIVAS.ComboBox.Init({ Id: 'cmbWorkType', Type: 'PIVAWorkType' }, { width: 120 });
    // ҩƷ
    PIVAS.ComboGrid.Init({ Id: 'cmgIncItm', Type: 'IncItm' }, { width: 311 });
    // ���
    PIVAS.ComboBox.Init({ Id: 'cmbPack', Type: 'PackType' }, {
        width: 120
    });
    // ����״̬
    PIVAS.ComboBox.Init({ Id: 'cmbUpdated', Type: 'BatUpdateStat' }, {
        editable: false,
        width: 120,
        onSelect: function() {
            Query();
        }
    });
    $("#cmbUpdated").combobox("setValue", "N");
    // ��ǩ״̬
    PIVAS.ComboBox.Init({ Id: 'cmbPrt', Type: 'PrtStat' }, {
        editable: false,
        width: 120,
        onSelect: function() {
            Query();
        }
    });
    $("#cmbPrt").combobox("setValue", "N");
    // ����
    PIVAS.BatchNoCheckList({ Id: "DivBatNo", LocId: SessionLoc, Check: true, Pack: false });
    GridCmbBatNo = PIVAS.UpdateBatNoCombo({
        LocId: SessionLoc,
        GridId: "gridOrdExe",
        Field: "batNo",
        BatUp: "batUp",
        MDspField: "mDsp"
    },function(){
	    NeedScroll="";
		$('#gridOrdExe').datagrid("reload"); 
	});
}

//��ʼ�������б�
function InitGridWard() {
    //����columns
    var columns = [
        [
        	{ field: 'select', checkbox: true},
            { field: "wardId", title: 'wardId', hidden: true },
            { field: 'wardDesc', title: '����', width: 200 }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: "web.DHCSTPIVAS.BatUpdate",
            QueryName: "BatUpdateWard"
        },
        pagination: false,
        fitColumns: true,
        fit: true,
        rownumbers: false,
        columns: columns,
        queryOnSelect: false,
        onClickRow: function(rowIndex, rowData) {
            QueryDetail();
        },
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        onLoadSuccess: function() {
            $("#gridOrdExe").datagrid("clear");
        },
        onSelect: function (rowIndex, rowData) {
            if ($(this).datagrid("options").queryOnSelect==true){
                $(this).datagrid("options").queryOnSelect = false;
                QueryDetail();
            }
        },
        onUnselect: function (rowIndex, rowData) {
            if ($(this).datagrid("options").queryOnSelect==true){
                $(this).datagrid("options").queryOnSelect = false;
                QueryDetail();
            }
        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridWard", dataGridOption);
}

function InitGridAdm() {
    var options = {
        toolbar: '#gridAdmBar',
        onClickRow: function(rowIndex, rowData) {
            QueryDetail();
        }
    };
    PIVAS.InitGridAdm({ Id: 'gridAdm' }, options);
}

//��ʼ����ϸ�б�
function InitGridOrdExe() {
    var columns = [
        [
            { field: 'gridCheck', checkbox: true },
            { field: 'warnInfo', title: '����', width: 75,
                styler: function(value, row, index) {
                    if (value != "") {
                        return "background-color:#ffba42;"
                    } 
                    return "";
                }
            
            },
            { field: 'pid', title: 'pid', width: 100, hidden: true },
            { field: 'ordRemark', title: '��ע', width: 75 },
            { field: 'doseDateTime', title: '��ҩʱ��', width: 100 },
            { field: 'wardDesc', title: '����', width: 125 },
            { field: 'bedNo', title: '����', width: 75 },
            { field: 'patNo', title: '�ǼǺ�', width: 100 },
            { field: 'patName', title: '����', width: 100 },
            {
                field: 'batNo',
                title: '����',
                width: 75,
                editor: GridCmbBatNo,
                styler: function(value, row, index) {
	                var colorStyle='';
                    if (row.packFlag != "") {
                        colorStyle += PIVAS.Grid.CSS.BatchPack;
                    }
                    if (row.batUp == "Y") {	// �û��޸ĵ�,б��
                        colorStyle += PIVAS.Grid.CSS.BatchUp;
                    }
                    if (row.canUpdate=="Y"){
	                	colorStyle+='text-decoration:underline;';
	                }
                    return colorStyle;
                }
            },
            {
                field: 'oeoriSign',
                title: '��',
                width: 35,
                halign: 'left',
                align: 'center',
                formatter: PIVAS.Grid.Formatter.OeoriSign,
                styler: function(value, row, index) {
                   	if (row.batUpdated=="Y"){
	                	return PIVAS.Grid.CSS.BatchUpdated;
	                }
                }
            },
            { field: 'incDesc', title: 'ҩƷ', width: 250, styler: PIVAS.Grid.Styler.IncDesc},
            { field: 'incSpec', title: '���', width: 100 },
            { field: 'dosage', title: '����', width: 75 },
            { field: 'qty', title: '����', width: 50 },
            { field: 'freqDesc', title: 'Ƶ��', width: 75 },
            { field: 'instrucDesc', title: '�÷�', width: 80 },
            { field: 'bUomDesc', title: '��λ', width: 50 },
            { field: 'docName', title: 'ҽ��', width: 75, hidden:true},
            { field: "passResultDesc", title: '��˽��', width: 85 },
            { field: 'priDesc', title: '���ȼ�', width: 75 },
            { field: 'workTypeDesc', title: '������', width: 75 },
            { field: "packFlag", title: '���', width: 85, hidden: true },
            { field: "mDsp", title: 'mDsp', width: 70, hidden: true },
            { field: 'batUp', title: '�û��޸�', width: 50, hidden: true },	// ��ָ����ǰ���޸�
            { field: 'canUpdate', title: '�Ƿ���޸�', width: 50, hidden: true },
            { field: 'batUpdated', title: '�Ƿ�������', width: 50, hidden: true },
            { field: 'check', title: 'check', width: 50, hidden: true}

        ]
    ];
    var dataGridOption = {
        url: PIVAS.URL.COMMON + '?action=JsGetBatUpdateDetail',
        fit: true,
        toolbar: '#gridOrdExeBar',
        rownumbers: false,
        columns: columns,
        pageSize: 50,
        pageList: [50, 100, 200],
        pagination: true,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        rowStyler: function(index, rowData) {
			return PIVAS.Grid.RowStyler.Person(index,rowData,"patNo");
        },
        onClickRow: function(rowIndex, rowData) {
	        if (rowData.canUpdate!="Y"){
	        	$(this).datagrid('unselectRow', rowIndex);
	        }
	        //console.log("onClickRow")
        },
        onClickCell: function(rowIndex, field, value) {
	        var rowData=$(this).datagrid("getRows")[rowIndex];
	        var canUpdate=rowData.canUpdate||"";
	        if (canUpdate!="Y"){
		    	return;
		    }
            if ((field == "batNo") && (value != "")) {
	            $(this).datagrid('beginEditRow', {
                    rowIndex: rowIndex,
                    editField: 'batNo'
                })
                setTimeout(function(){
	                $("#gridOrdExe").datagrid("checkRow",rowIndex);
                },100)
            } else {
                $(this).datagrid('endEditing');
            }
        },
        onCheck: function(rowIndex, rowData) {
	        if ($(this).datagrid("options").checking == true) {
				return;
			}
			$(this).datagrid("options").checking = true;
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: true,
                Value: rowData.mDsp
            });
            CheckRowsGlobal(rowData.mDsp, "Y");
            $(this).datagrid("options").checking = "";
        },
        onUncheck: function(rowIndex, rowData) {
	        if ($(this).datagrid("options").checking == true) {
				return;
			}
			$(this).datagrid("options").checking = true;
            PIVAS.Grid.LinkCheck.Init({
                CurRowIndex: rowIndex,
                GridId: 'gridOrdExe',
                Field: 'mDsp',
                Check: false,
                Value: rowData.mDsp
            });
            CheckRowsGlobal(rowData.mDsp, "N");
            $(this).datagrid("options").checking = "";
        },
		onCheckAll: function (rows) {
			if ($(this).datagrid("options").checking==true){
				return;
			}
			UnBindChk();
			CheckPage(rows, "Y");
		},
		onUncheckAll: function (rows) {
			if ($(this).datagrid("options").checking==true){
				return;
			}
			UnBindChk();
			CheckPage(rows, "N");
		},
        onLoadSuccess: function(data) {
	        $(this).datagrid("options").checking = true;
	        var row0Data = data.rows[0];
            if (row0Data) {
	            $(this).datagrid("checkAll");
                var pid = row0Data.pid;
                $('#gridOrdExe').datagrid("options").queryParams.pid = pid;
				var rows = $(this).datagrid("getRows");
				var rowsLen = rows.length;
				for (var index = (rowsLen - 1); index >= 0; index--) {
					var rowData = rows[index];
					var check = rowData.check;
					if (check!="Y"){
						$(this).datagrid("uncheckRow", index);
					}
				}
                CalcuSumBat(pid,$('#gridOrdExe').datagrid("options").queryParams.params);	// ����ϼ�
            }else {
				$(this).datagrid("uncheckAll");
			}
			if (NeedScroll=="Y"){
            	$(this).datagrid("scrollTo", 0); 
            	NeedScroll="Y";
            }  
            $(this).datagrid("options").checking = "";
            PIVAS.Grid.CellTip({ TipArr: ['ordRemark', 'incDesc'] });
            UnBindChk();

        }
    };
    DHCPHA_HUI_COM.Grid.Init("gridOrdExe", dataGridOption);
}
function UnBindChk(){
	var rows=$("#gridOrdExe").datagrid("getRows");
	$.each(rows, function (index, row) {
		var canUpdate = row.canUpdate;	
		if (canUpdate!="Y") {
			//$(".datagrid-row[datagrid-row-index=" + index + "] .datagrid-cell-check")
			// ͨ���Ƴ���ʽ,ʹselectoncheck���¼���������
			var $row=$("#gridOrdExe").prev().find(".datagrid-row[datagrid-row-index=" + index + "]");			
			$row.removeClass("datagrid-row-selected datagrid-row-checked")
			var $chk=$row.find("input:checkbox[name='gridCheck']")[0]
			$chk.disabled =true
			$chk.checked =false
		}
	});
}

///���ǼǺŲ�ѯ�����б�
function GetPatAdmList() {
    var patNo = $('#txtPatNo').val();
	patNo=PIVAS.FmtPatNo(patNo);
    $('#txtPatNo').val(patNo);
    var params = patNo + '^' + session['LOGON.HOSPID'];
    $('#gridAdm').datagrid('query', {
        inputParams: params,
        rows:9999
    });
}

///��ѯ
function Query() {
    ClearTmpGlobal();
    var params = QueryParams("Query");
    if (params == "") {
        return;
    }
    $('#gridWard').datagrid('query', {
        inputStr: params,
        rows:9999
    });
}

// ��ѯҽ��
function QueryDetail() {
    ClearTmpGlobal();
    var params = QueryParams("QueryDetail");
    if (params == "") {
        return;
    }   
    $('#gridOrdExe').datagrid("load",{
        page: 1,
        params: params,
        pid: ''
    });
}

// ��ȡ��ѯ����
// flag==Query   flag==QueryDetail
function QueryParams(flag) {
    var startDate = $('#dateStart').datebox('getValue'); // ��ʼ����
    var endDate = $('#dateEnd').datebox('getValue'); // ��ֹ����
    var locGrpId = $('#cmbLocGrp').combobox("getValue") || ''; // ������
    var wardIdStr = $("#cmbWard").combobox("getValue") || ''; // ����	
    var pivaCat = $("#cmbPivaCat").combobox("getValue") || ''; // ��Һ����
    var workType = $("#cmbWorkType").combobox("getValue") || ''; // ��������
    var priority = $("#cmbPriority").combobox("getValue") || ''; // ҽ�����ȼ�
    var incId = $("#cmgIncItm").combobox("getValue") || ''; // ҩƷ
    var packFlag = $("#cmbPack").combobox("getValues") || ''; // �������
    var batNoStr = "";
    $("input[type=checkbox][name=batbox]").each(function() {
        if ($('#' + this.id).is(':checked')) {
            if (batNoStr == "") {
                batNoStr = this.value;
            } else {
                batNoStr = batNoStr + "," + this.value;
            }
        }
    });
    var admId = "";
    // ���Ϊ��ѯ��ϸ,��wardIdȡѡ���Id
    var tabTitle = $('#tabsOne').tabs('getSelected').panel('options').title;
    if (flag == "QueryDetail") {
        if (tabTitle == "�����б�") {
            var wardChecked = $('#gridWard').datagrid('getChecked');
            if (wardChecked == "") {
                return "";
            }
            for (var i = 0; i < wardChecked.length; i++) {
                if (wardIdStr == "") {
                    wardIdStr = wardChecked[i].wardId;
                } else {
                    wardIdStr = wardIdStr + "," + wardChecked[i].wardId;
                }
            }
        } else if (tabTitle == "���ǼǺ�") {
            var admSelected = $('#gridAdm').datagrid("getSelected");
            if (admSelected == null) {
                $.messager.alert('��ʾ', '��ѡ������¼', 'warning');
                return "";
            }
            wardIdStr = "";
            admId = admSelected.admId;
        }
    }
    var updatedFlag = $("#cmbUpdated").combobox("getValue") || ''; // ����״̬
    var prtStat= $("#cmbPrt").combobox("getValue") || ''; // ��ǩ״̬
    var params = SessionLoc + "^" + wardIdStr + "^" + admId + "^" + startDate + "^" + endDate + "^" +
        locGrpId + "^" + pivaCat + "^" + workType + "^" + priority + "^" + incId + "^" +
        packFlag + "^" + batNoStr + "^" + updatedFlag+ "^"+prtStat;
    return params;
}
// ȷ������
function SaveData() {
    var rowsData = $("#gridOrdExe").datagrid("getRows");
    if (rowsData == "") {
        $.messager.alert('��ʾ', '��ϸ������', 'warning');
        return;
    }
    var pid = rowsData[0].pid;
    if (pid == "") {
        $.messager.alert('��ʾ', '��ȡ����PID', 'warning');
        return;
    }
    if ($("#cmbUpdated").combobox('getValue') == "Y") {
        $.messager.alert('��ʾ', 'ҽ����ϸ����Ϊ����������', 'warning');
        return;
    }
    //var mDspIdStr=GetCheckMDspStr();
    $.messager.confirm('��ʾ', "��ȷ��������?", function(r) {
        if (r) {
            PIVAS.Progress.Show({ type: 'save', interval: 1000 });
            $.m({
                ClassName: "web.DHCSTPIVAS.BatUpdate",
                MethodName: "SaveData",
                pid: pid,
                userId: SessionUser
            }, function(retData) {
                PIVAS.Progress.Close();
                var retArr = retData.split("^");
                if (retArr[0] == -1) {
                    $.messager.alert('��ʾ', retArr[1], 'warning');
                    return;
                } else if (retArr[0] < -1) {
                    $.messager.alert('��ʾ', retArr[1], 'error');
                    return;
                }
                QueryDetail();
            });
        }
    });
}

// �������
function PackSelectDsp(packFlag) {
    $.messager.confirm('��ʾ', "��ȷ��" + ((packFlag == "P") ? "���" : "ȡ�����") + "��?", function(r) {
        if (r) {
            var mDspStr = GetMainDspStr();
            if (mDspStr == "") {
                $.messager.alert('��ʾ', '�빴ѡ��Ҫ' + ((packFlag == "P") ? "���" : "ȡ�����") + '�ļ�¼', 'warning');
                return;
            }
            var retData = tkMakeServerCall("web.DHCSTPIVAS.DataHandler", "UpdateOeDspToPackMulti", mDspStr, packFlag)
            var retArr = retData.split("^");
            if (retArr[0] == -1) {
                $.messager.alert('��ʾ', retArr[1], 'warning');
                return;
            } else if (retArr[0] < -1) {
                $.messager.alert('��ʾ', retArr[1], 'error');
                return;
            }
            DHCPHA_HUI_COM.Msg.popover({
                msg: ((packFlag == "P") ? "���" : "ȡ�����") + '�ɹ�',
                type: 'success'
            });
            NeedScroll="";
            $('#gridOrdExe').datagrid('reload');
        }
    })
}

// ȡ������
function DelBatUpdate() {
    if ($("#cmbUpdated").combobox('getValue') == 'N') {
        $.messager.alert('��ʾ', 'δ���������޷�ȡ��', 'warning');
        return;
    }
    $.messager.confirm('��ʾ', "��ȷ��ȡ��������?", function(r) {
        if (r) {
            var mDspStr = GetMainDspStr();
            if (mDspStr == "") {
                $.messager.alert('��ʾ', '�빴ѡ��Ҫȡ�������ļ�¼', 'warning');
                return;
            }
            var retData = tkMakeServerCall("web.DHCSTPIVAS.BatUpdate", "DeleteBatUpdateMulti", mDspStr, SessionUser)
            var retArr = retData.split("^");
            if (retArr[0] == -1) {
                if (retArr[2] >0) {
                	$.messager.alert('��ʾ', "ȡ�������ɹ�</br>�����ּ�¼"+retArr[1], 'warning');
                	QueryDetail();
                }else{
	            	$.messager.alert('��ʾ', retArr[1], 'warning');
	            }
                return;
            } else if (retArr[0] < -1) {
                if (retArr[2] >0) {
                	$.messager.alert('��ʾ', "ȡ�������ɹ�</br>�����ּ�¼"+retArr[1], 'error');
                	QueryDetail();
                }else{
	            	$.messager.alert('��ʾ', retArr[1], 'error');
	            }
                return;
            }
            DHCPHA_HUI_COM.Msg.popover({
                msg: "ȡ�������ɹ�",
                type: 'success'
            });
            // ȡ��������,��̨�����ж�,ֱ�����²�ѯ,�漰���¼����ݻ�
            QueryDetail();
        }
    })
}

// ȷ��-�����޸�����
function ConfirmUpdBatUpdate() {
    var mDspStr = GetMainDspStr();
    if (mDspStr == "") {
        $.messager.alert('��ʾ', '�빴ѡ��Ҫ�޸����εļ�¼', 'warning');
        return;
    }
    // ����Ŀ�Ƿ���Ҫ�����ʾ��
    //$.messager.confirm('��ʾ', "��ȷ�������޸�������?", function(r) {
    //    if (r) {
    PIVAS.UpdateBatNoWindow({ LocId: SessionLoc }, UpdBatUpdate);
    //    }
    //});
}
// �����޸�����
function UpdBatUpdate(batNo) {
    var mDspStr = GetMainDspStr();
    var retData = tkMakeServerCall("web.DHCSTPIVAS.BatUpdate", "UpdateBatchMulti", mDspStr, batNo, SessionUser);
    var retArr = retData.split("^");
    if (retArr[0] == -1) {
        $.messager.alert('��ʾ', retArr[1], 'warning');
    } else if (retArr[0] < -1) {
        $.messager.alert('��ʾ', retArr[1], 'error');
    } else {
        DHCPHA_HUI_COM.Msg.popover({
            msg: "�޸����γɹ�",
            type: 'success'
        });
    }
    NeedScroll="";
    $('#gridOrdExe').datagrid('reload');
}


// ��ȡѡ�м�¼��mdspId��
function GetMainDspStr() {
    var mDspArr = [];
    var gridOrdExeChecked = $('#gridOrdExe').datagrid('getChecked');
    for (var i = 0; i < gridOrdExeChecked.length; i++) {
        var checkedData = gridOrdExeChecked[i];
        var mDsp = checkedData.mDsp;
        if (mDspArr.indexOf(mDsp) < 0) {
            mDspArr.push(mDsp);
        }
    }
    return mDspArr.join("^");
}
// ����������漰��������ʱglobal
function ClearTmpGlobal() {
	var pid = $("#gridOrdExe").datagrid("options").queryParams.pid || "";
    tkMakeServerCall("web.DHCSTPIVAS.BatUpdate", "KillBatUpdate", pid);
    $(".pivas-toolbar-context").html("");
}
// ����ϼ�
function CalcuSumBat(pid,inputStr) {
    if ((pid == "")||(inputStr =="")) {
        return;
    }
    $.m({
        ClassName: "web.DHCSTPIVAS.BatUpdate",
        MethodName: "SumDetailBatch",
        pid: pid,
        inputStr:inputStr
    }, function(retData) {
        if (retData != "") {
            $(".pivas-toolbar-context").html(retData);
        }
    })
}



/// ��ʼ��Ĭ������
function InitPivasSettings() {
    $.cm({
        ClassName: "web.DHCSTPIVAS.Settings",
        MethodName: "GetAppProp",
        userId: session['LOGON.USERID'],
        locId: session['LOGON.CTLOCID'],
        appCode: "BatUpdate"
    }, function(jsonData) {
        $("#dateStart").datebox("setValue", jsonData.OrdStDate);
        $("#dateEnd").datebox("setValue", jsonData.OrdEdDate);
        PIVAS.VAR.PASS = jsonData.Pass;
    });
}

function CheckPage(rows, flag) {
	if (rows == "") {
		return;
	}
	var mDspArr = [];
	var mDsp= "";
	for (var i in rows) {
		mDsp = rows[i].mDsp;
		if (mDsp == "") {
			continue;
		}
		if (mDspArr.indexOf(mDsp) >= 0) {
			continue;
		}
		mDspArr.push(mDsp);
	}
	var mDspStr = mDspArr.join("^");
	if (mDspStr == "") {
		return;
	}
	CheckRowsGlobal(mDspStr, flag)
}

function CheckRowsGlobal(mDspIdStr, flag, all) {
	$.cm({
		ClassName: 'web.DHCSTPIVAS.BatUpdate',
		MethodName: 'CheckRows',
		MDspIdStr: mDspIdStr,
		Flag: flag,
		Pid: $("#gridOrdExe").datagrid("options").queryParams.pid || "",
		All: all || "",
		dataType: "text"
	}, false);
	if (all == "Y") {
		NeedScroll="";
		$("#gridOrdExe").datagrid("reload");
	}
}

function GetCheckMDspStr(allFlag) {
	var mDspIdStr = $.cm({
		ClassName: 'web.DHCSTPIVAS.BatUpdate',
		MethodName: 'GetSaveDspStr',
		Pid: $("#gridOrdExe").datagrid("options").queryParams.pid || "",
		dataType: "text"
	}, false);
	return mDspIdStr;
}
window.onbeforeunload = function() {
    ClearTmpGlobal();
};
