/**
 * ģ��:     ��ҩ��ҩ����
 * ��д����: 2020-12-02
 * ��д��:   MaYuqiang
 * ����:     
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var PatNoLen = DHCPHA_CONSTANT.DEFAULT.PATNOLEN;
var WinReason = '';
var AppPropData;	// ģ������
var ComPropData;	// ��������
var LogonInfo = gGroupId +"^"+ gLocId +"^"+ gUserID +"^"+ gHospID;
var DefPhaLocInfo = tkMakeServerCall('web.DHCSTKUTIL', 'GetDefaultPhaLoc', SessionLoc);
var DefPhaLocArr = DefPhaLocInfo.split('^');
DefPhaLocId = DefPhaLocArr[0] || '';
DefPhaLocDesc = DefPhaLocArr[1] || '';
var GridCmbRetReason;

DHCPHA_CONSTANT.VAR.SELECT = ""
DHCPHA_CONSTANT.VAR.UNSELECT = ""
$(function () {
    //InitTreePat();
    InitDict();
    InitSetDefVal();
    InitGridDict();
    InitGridDisped();
    $('#txtPatNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var patNo = $.trim($('#txtPatNo').val());
            if (patNo != '') {
                var newpatno=NumZeroPadding(patNo,DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
				$(this).val(newpatno);
                var admId = tkMakeServerCall('PHA.COM.Method', 'GetAdmByPatNo', newpatno, "I");
                var patInfo = tkMakeServerCall('web.DHCINPHA.Request', 'PatInfo', admId);
                $('#txtPatName').val(patInfo.split('^')[1] || '');
                // �޸Ĳ�������
                Query();
            }
        }
    });
    $('#btnDirReq').on('click', RequestQuery);
    $('#btnDefaultLoc').on('click', SetDefaultLoc);
    $('#btnFind').on('click', Query);
    /*
    if (LoadAdmId != '') {
        LoadPatInfo();
    }
    */
    $('#btnSave').on('click', SaveHandler);
    setTimeout(Query, 500);
});

function LoadPatInfo() {
    var patInfo = tkMakeServerCall('web.DHCINPHA.Request', 'PatInfo', LoadAdmId);
    $('#txtPatNo').val(patInfo.split('^')[0] || '');
    $('#txtPatName').val(patInfo.split('^')[1] || '');
}

function InitDict() {
    /// ҩ���б�
	PHA.ComboBox("cmbPhaLoc", {
		url: PHA_STORE.Pharmacy().url,
		onLoadSuccess: function(){

		},
		onSelect: function (selData) {
			Query();
		}
	});
}

/**
 * ���ؼ�����ʼֵ
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	// ��������
	ComPropData = $.cm({	
		ClassName: "PHA.HERB.Com.Method", 
		MethodName: "GetAppProp", 
		LogonInfo: LogonInfo, 
		SsaCode: "HERB.PC", 
		AppCode:""
		}, false)

    $("#cmbPhaLoc").combobox("setValue", ComPropData.DefaultLoc4Req);

}

function InitGridDict() {
    var retReaData = $.cm(
        {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'BLCReasonForRefund',
            hospId: HospId,
            ResultSetType: 'array'
        },
        false
    );
    GridCmbRetReason = DHCPHA_HUI_COM.GridComboBox.Init(
        {
            data: {
                data: retReaData
            }
        },
        {
            editable: true,
            mode: 'local'
        }
    );
}
function InitTreePat() {
    //��ʼ���������б�
    $HUI.tree('#treePat', {
        loader: function (param, success, error) {
            $cm(
                {
                    ClassName: 'Nur.CommonInterface.Ward',
                    MethodName: 'getWardPatients',
                    wardID: session['LOGON.WARDID'],
                    adm: LoadAdmId
                },
                function (data) {
                    //���id��text ʹ��vueʹ�õ����ݷ���his ui tree�ĸ�ʽ
                    data[0].label= $g(data[0].label);
                    var addIDAndText = function (node) {
                        node.id = node.ID;
                        node.text = node.label;
                        if (node.id === LoadAdmId) {
                            // node.checked = true;
                        }
                        if (node.children) {
                            node.children.forEach(addIDAndText);
                        }
                    };
                    data.forEach(addIDAndText);
                    success(data);
                }
            );
        },
        onLoadSuccess: function () {
            var node = $(this).tree('find', LoadAdmId);
            $(this).tree('select', node.target);
        },
        onClick: function (node) {
            LoadAdmId = node.ID;
            LoadPatInfo();
            Query();
        },
        lines: true,
        checkbox: false
    });
}
/**
 * �����б�, ��ѡ����ȡ����ѡʱ
 */
function patientTreeCheckChangeHandle() {
    LoadAdmId = EpisodeIDStr;
    LoadPatInfo();
    Query();
}

function patientTreeLoadSuccessCallBack() {
    if (AutoQueryTimes > 1) {
        return;
    }
    AutoQueryTimes++;
    Query();
}
function ClearPatientTree() {
    if ($('#patientTree').tree('getSelected') !== null) {
        $('#patientTree').tree('select', $('#patientTree').tree('getSelected'));
        EpisodeIDStr = '';
    }
}
function GetPatientTreeSelectedAdm() {
    if ($('#patientTree').tree('getSelected') === null) {
        return '';
    }
    return EpisodeIDStr;
}
// �ѷ�ҩ��Ϣ
function InitGridDisped() {
    var columns = [
        [
            {
                field: 'gridRequestSelect',
                checkbox: true
            },
            {
                field: 'recLocId',
                title: '��ҩ����Id',
                width: 120,
                hidden: true
            },
            {
                field: 'recLocDesc',
                title: '��ҩ����',
                width: 120
            },
            {
                field: 'oeoriSign',
                title: '��',
                width: 35,
                align: 'center',
                formatter: PHAHERB_COM.Formatter.OeoriSign
            },
            {
                field: 'incCode',
                title: 'ҩƷ����',
                width: 100,
                hidden: true
            },
            {
                field: 'incDesc',
                title: 'ҩƷ����',
                width: 250
            },
            {
                field: 'canRetQty',
                title: '��������',
                width: 70,
                align: 'right'
            },
            {
                field: 'reqQty',
                title: '<span style="color:red">*</span>��������', // ��ҩ���ɱ༭
                width: 80,
                align: 'right'
            },
            {
                field: 'reqReasonId',
                title: '������ҩԭ��',
                width: 160,
                editor: GridCmbRetReason,
                descField: 'reqReasonDesc',
                formatter: function (value, row, index) {
                    return row.reqReasonDesc;
                }
            },
            {
                field: 'reqReasonDesc',
                title: '��ҩԭ������',
                width: 160,
                hidden: true
            },
            {
                field: 'dspQty',
                title: '��ҩ����',
                width: 70,
                align: 'right'
            },
            {
                field: 'bUomDesc',
                title: '��λ',
                width: 60
            },
            {
                field: 'doseDateTime',
                title: '��ҩʱ��',
                width: 150,
                align: 'left'
            },
            {
                field: 'reqHistory',
                title: '���μ�¼',
                width: 120,
                align: 'left'
            },
            {
                field: 'docLocDesc',
                title: '��������',
                width: 140
            },
            {
                field: 'encryptLevel',
                title: '�����ܼ�',
                width: 70,
                hidden: true
            },
            {
                field: 'patLevel',
                title: '���˼���',
                width: 70,
                hidden: true
            },
            {
                field: 'dspId',
                title: '�����Id',
                width: 60,
                hidden: true
            },
            {
                field: 'wardLocId',
                title: '��������Id',
                width: 120,
                hidden: true
            },
            {
                field: 'phbdicId',
                title: '��ҩҵ�����Id',
                width: 60,
                hidden: true
            },
            {
                field: 'dspSubRowId',
                title: '����ӱ�Id',
                width: 60,
                hidden: true
            },
            {
                field: 'inclb',
                title: '�������ο����Id',
                width: 60,
                hidden: true
            },
            {
                field: 'cantretreason',
                title: '������ҩԭ��',
                width: 100,
                align: 'left'
            },{
                field: 'prescNo',
                title: '������',
                width: 125,
                hidden: false
            },{
                field: 'canRetFlag',
                title: '�Ƿ������',
                width: 60,
                hidden: true
            },{
                field: 'mDspId',
                title: '�����Id',
                width: 60,
                hidden: true
            },{
                field: 'phbdId',
                title: '��ҩҵ������id',
                width: 60,
                hidden: true
            }
        ]
    ];
	
	var dataGridOption = {
        url: "",
        fit: true,
        border: false,
        singleSelect: false,
        selectOnCheck: true,
        checkOnSelect: true,
        nowrap:false ,
        rownumbers: false,
        columns: columns,
        pageSize: 500,
        pageList: [50, 100, 300, 500],
        pagination: true,
        toolbar: '#gridDispedBar',
        onCheck: function (rowIndex, rowData) {
            if (DHCPHA_CONSTANT.VAR.UNSELECT != "") {
                return;
            }
            DHCPHA_CONSTANT.VAR.UNSELECT = 1;
            SelectLinkOrder(rowIndex);
            DHCPHA_CONSTANT.VAR.UNSELECT = "";
        },
        onUncheck: function (rowIndex, rowData) {
			if (DHCPHA_CONSTANT.VAR.UNSELECT != "") {
                return;
            }
            DHCPHA_CONSTANT.VAR.UNSELECT = 1;
            UnSelectLinkOrder(rowIndex);
            DHCPHA_CONSTANT.VAR.UNSELECT = "";
        }/*,
		onClickRow: function (rowIndex, rowData) {
            alert("DHCPHA_CONSTANT.VAR.SELECT:"+DHCPHA_CONSTANT.VAR.SELECT)
			if (DHCPHA_CONSTANT.VAR.SELECT != "") {
                return;
            }
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex,
                editField: 'reqReasonId'
            });
           DHCPHA_CONSTANT.VAR.SELECT = 1;
           SelectLinkOrder(rowIndex);
           DHCPHA_CONSTANT.VAR.SELECT = "";
        }
        */
    }
	PHA.Grid("gridDisped", dataGridOption);
}

//����ҽ��ѡ��
function SelectLinkOrder(id) {
    var rows = $("#gridDisped").datagrid("getRows");
    if (rows.length == 0) {
        return;
    }
    var prescNo = rows[id].prescNo;
    for (var i = 0; i < rows.length; i++) {
        if (id == i) {
            continue;
        }
        var tmpPrescNo = rows[i].prescNo;
        if (tmpPrescNo == prescNo) {
            $("#gridDisped").datagrid("selectRow", i);
        }
    }
    DHCPHA_CONSTANT.VAR.SELECT = "";
}

//����ҽ��ȡ��ѡ��
function UnSelectLinkOrder(sRowIndex) {
    var rows = $("#gridDisped").datagrid("getRows");
    if (rows.length == 0) {
        return;
    }
    var prescNo = rows[sRowIndex].prescNo;
    for (var num = 0; num < rows.length; num++) {
        if (sRowIndex === num) {
            continue;
        }
        var tmpPrescNo = rows[num].prescNo;
        if (tmpPrescNo == prescNo) {
        	$("#gridDisped").datagrid("unselectRow", num);
        }
    }
    DHCPHA_CONSTANT.VAR.UNSELECT = "";
    
}

// ��ѯ
function Query() {
    var pJson = GetQueryParamsJson();
	if (pJson == "") {
		return;
	}
	
    $('#gridDisped').datagrid({
        url: $URL,
        queryParams: {
            ClassName: 'PHA.HERB.Request.Query',
            QueryName: 'GetIPDispedList',
            pJsonStr: JSON.stringify(pJson)
        }
    });
}

// ��ȡ����
function GetQueryParamsJson(){
	return {
		patNo: $('#txtPatNo').val(),
        admId: LoadAdmId,
        recLocId: $('#cmbPhaLoc').combobox('getValue'),
        logonLocId: SessionLoc
    };
	

}

function RequestQuery() {
    var lnk = 'pha.herb.v2.queryretrequest.csp?EpisodeID=' + LoadAdmId;
    websys_createWindow(lnk, '��ҩ��ҩ�����ѯ', 'height=85%,width=85%,menubar=no,status=no,toolbar=no,resizable=yes');
}


function SaveHandler() {
    WinReason = '';
    if (CheckNeedReason() === true) {
        ReqReasonWindow(Save);
    } else {
        Save();
    }
}
// ����
function Save() {
    var paramsStr = GetSaveParams();
    var saveRet = tkMakeServerCall('PHA.HERB.Request.Save', 'SaveMulti', paramsStr, SessionUser);
    var saveRetArr = saveRet.split('^');
    if (saveRetArr[0] < 0) {
        $.messager.alert('��ʾ', saveRetArr[1], 'warning');
        return;
    } else {
        $.messager.alert('��ʾ', '���ɳɹ�' , 'info');
        Query();

    }
}
// ��ȡ��Ч��¼
function GetSaveParams() {
    $('#gridDisped').datagrid('endEditing');
    var gridChked = $('#gridDisped').datagrid('getChecked');
    var gridChkedLen = gridChked.length;
    if (gridChkedLen == 0) {
        $.messager.popover({
            msg: '���ȹ�ѡ��Ҫ����ļ�¼',
            type: 'alert'
        });
        return '';
    }

    var paramsStr = "";
    var lastRecLocId = '';
    for (var i = 0; i < gridChkedLen; i++) {
        var rowData = gridChked[i];
        var reqReasonId = rowData.reqReasonId || '';
        if (reqReasonId == ""){
            var reqReasonId = WinReason
        }
        var reqQty = rowData.reqQty || '';
        var prescNo = rowData.prescNo;
        var recLocId = rowData.recLocId || '';
        var cantretreason = rowData.cantretreason || '';
        var dspSubId = rowData.dspSubRowId || '';
        var phbdicId = rowData.phbdicId || '';
        if (cantretreason != '') {
            $.messager.alert('��ʾ', '��' + (i + 1) + '��ҩƷά���˲�����ҩԭ��,������ҩ����', 'warning');
            return '';
        }
        var chkRet = tkMakeServerCall('PHA.HERB.Request.Save', 'CheckBeforeSave', phbdicId);
        if (chkRet.split('^')[0] < 0) {
            $.messager.alert('��ʾ', rowData.incDesc + ':' + chkRet.split('^')[1], 'warning');
            return '';
        }
        if (lastRecLocId != '' && lastRecLocId != recLocId) {
            $.messager.alert('��ʾ', '��ѡ����ͬ��ҩ����������ҩ����', 'warning');
            return '';
        }
        lastRecLocId = recLocId;
        var iParams = dspSubId + '^' + reqQty + '^' + reqReasonId + '^' + phbdicId + '^' + prescNo;
        paramsStr = paramsStr == '' ? iParams : paramsStr + ',' + iParams;
    }
    if (paramsStr == "") {
        PHA.Popover({
            msg: 'û����Ҫ���������',
            type: 'alert'
        });
        return;
    }
    return paramsStr;
}

// ����Ĭ�Ͽ��ҹ���
function SetDefaultLoc() {
    var PhaLoc = $('#cmbPhaLoc').combobox('getValue') || '';
    var PhaLocDesc = $('#cmbPhaLoc').combobox('getText') || '';
    if (PhaLoc == '') {
        //$.messager.alert("��ʾ", "����ѡ��ҩ����", "warning");
        //return;
    }
    if (SessionLoc == '') {
        return;
    }
    var confirmText = $g("ȷ�Ͻ�")+"<span>" + PhaLocDesc +"</span>" + $g("���ó�Ĭ�Ͽ�����?");
    if (PhaLoc == '') {
        confirmText = 'ȷ��Ĭ�Ͽ�������Ϊ����?';
    }
    $.messager.confirm('ȷ����ʾ', confirmText, function (r) {
        if (r) {
            var saveRet = tkMakeServerCall('web.DHCSTRETREQUEST', 'SetDefaultPhaLoc', PhaLoc, SessionLoc);
            var saveArr = saveRet.split('^');
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal == 0) {
                $.messager.alert('��ʾ', '���óɹ�', 'info');
                return;
            }
        }
    });
}

function ReqReasonWindow(callBack) {
    WinReason = '';
    var winDivId = 'ReqReasonWindowDiv';
    var winDiv = '<div id="' + winDivId + '" style="padding:10px"><div id="gridReqReason"></div></div>';
    $('body').append(winDiv);
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'web.DHCINPHA.Request',
            QueryName: 'BLCReasonForRefund',
            hospId: HospId
        },
        border: false,
        fitColumns: true,
        singleSelect: true,
        nowrap: false,
        striped: false,
        pagination: false,
        rownumbers: false,
        columns: [
            [
                {
                    field: 'RowId',
                    title: 'RowId',
                    width: 80,
                    hidden: true
                },
                {
                    field: 'Description',
                    title: '����ԭ��',
                    width: 300,
                    align: 'left'
                }
            ]
        ],
        onClickRow: function (index, rowData) {
            WinReason = rowData.RowId;
            callBack(WinReason);
            $('#ReqReasonWindowDiv').window('close');
        }
    };
    DHCPHA_HUI_COM.Grid.Init('gridReqReason', dataGridOption);
    $('#ReqReasonWindowDiv').window({
        title: 'ѡ����ҩ����ԭ��',
        collapsible: false,
        iconCls: 'icon-w-list',
        border: false,
        closed: true,
        modal: true,
        width: 600,
        height: 400,
        maximizable: false,
        onClose: function () {
            $('#ReqReasonWindowDiv').window('destroy');
        }
    });
    $('#ReqReasonWindowDiv .datagrid-header').css('display', 'none');
    $("#ReqReasonWindowDiv [class='panel datagrid']").css('border', '#cccccc solid 1px');
    $('#ReqReasonWindowDiv').window('open');
}

function CheckNeedReason() {
    var ret = false;
    $('#gridDisped').datagrid('endEditing');
    var gridChked = $('#gridDisped').datagrid('getChecked');
    var gridChkedLen = gridChked.length;
    var mDspArr = [];
    for (var i = 0; i < gridChkedLen; i++) {
        var rowData = gridChked[i];
        var needGrpRet = rowData.needGrpRet;
        var mDspId = rowData.mDspId;
        var reqReasonId = rowData.reqReasonId || '';
        if (mDspArr.indexOf(mDspId) >= 0) {
            continue;
        }
        if (reqReasonId === '') {
            return true;
        }
        mDspArr.push(mDspId);
    }
    return ret;
}
