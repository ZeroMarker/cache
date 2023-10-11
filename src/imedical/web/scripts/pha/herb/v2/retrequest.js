/**
 * 模块:     草药退药申请
 * 编写日期: 2020-12-02
 * 编写人:   MaYuqiang
 * 其他:     
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var HospId = session['LOGON.HOSPID'];
var PatNoLen = DHCPHA_CONSTANT.DEFAULT.PATNOLEN;
var WinReason = '';
var AppPropData;	// 模块配置
var ComPropData;	// 公共配置
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
                // 修改病人姓名
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
    /// 药房列表
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
 * 给控件赋初始值
 * @method InitSetDefVal
 */
function InitSetDefVal() {
	// 公共设置
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
    //初始化病人树列表
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
                    //添加id和text 使给vue使用的数据符合his ui tree的格式
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
 * 患者列表, 勾选或者取消勾选时
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
// 已发药信息
function InitGridDisped() {
    var columns = [
        [
            {
                field: 'gridRequestSelect',
                checkbox: true
            },
            {
                field: 'recLocId',
                title: '发药科室Id',
                width: 120,
                hidden: true
            },
            {
                field: 'recLocDesc',
                title: '发药科室',
                width: 120
            },
            {
                field: 'oeoriSign',
                title: '组',
                width: 35,
                align: 'center',
                formatter: PHAHERB_COM.Formatter.OeoriSign
            },
            {
                field: 'incCode',
                title: '药品代码',
                width: 100,
                hidden: true
            },
            {
                field: 'incDesc',
                title: '药品名称',
                width: 250
            },
            {
                field: 'canRetQty',
                title: '可退数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'reqQty',
                title: '<span style="color:red">*</span>申请数量', // 草药不可编辑
                width: 80,
                align: 'right'
            },
            {
                field: 'reqReasonId',
                title: '申请退药原因',
                width: 160,
                editor: GridCmbRetReason,
                descField: 'reqReasonDesc',
                formatter: function (value, row, index) {
                    return row.reqReasonDesc;
                }
            },
            {
                field: 'reqReasonDesc',
                title: '退药原因描述',
                width: 160,
                hidden: true
            },
            {
                field: 'dspQty',
                title: '发药数量',
                width: 70,
                align: 'right'
            },
            {
                field: 'bUomDesc',
                title: '单位',
                width: 60
            },
            {
                field: 'doseDateTime',
                title: '用药时间',
                width: 150,
                align: 'left'
            },
            {
                field: 'reqHistory',
                title: '历次记录',
                width: 120,
                align: 'left'
            },
            {
                field: 'docLocDesc',
                title: '开单科室',
                width: 140
            },
            {
                field: 'encryptLevel',
                title: '病人密级',
                width: 70,
                hidden: true
            },
            {
                field: 'patLevel',
                title: '病人级别',
                width: 70,
                hidden: true
            },
            {
                field: 'dspId',
                title: '打包表Id',
                width: 60,
                hidden: true
            },
            {
                field: 'wardLocId',
                title: '病区科室Id',
                width: 120,
                hidden: true
            },
            {
                field: 'phbdicId',
                title: '草药业务孙表Id',
                width: 60,
                hidden: true
            },
            {
                field: 'dspSubRowId',
                title: '打包子表Id',
                width: 60,
                hidden: true
            },
            {
                field: 'inclb',
                title: '科室批次库存项Id',
                width: 60,
                hidden: true
            },
            {
                field: 'cantretreason',
                title: '不可退药原因',
                width: 100,
                align: 'left'
            },{
                field: 'prescNo',
                title: '处方号',
                width: 125,
                hidden: false
            },{
                field: 'canRetFlag',
                title: '是否可申请',
                width: 60,
                hidden: true
            },{
                field: 'mDspId',
                title: '主打包Id',
                width: 60,
                hidden: true
            },{
                field: 'phbdId',
                title: '草药业务主表id',
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

//关联医嘱选中
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

//关联医嘱取消选中
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

// 查询
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

// 获取参数
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
    websys_createWindow(lnk, '草药退药申请查询', 'height=85%,width=85%,menubar=no,status=no,toolbar=no,resizable=yes');
}


function SaveHandler() {
    WinReason = '';
    if (CheckNeedReason() === true) {
        ReqReasonWindow(Save);
    } else {
        Save();
    }
}
// 保存
function Save() {
    var paramsStr = GetSaveParams();
    var saveRet = tkMakeServerCall('PHA.HERB.Request.Save', 'SaveMulti', paramsStr, SessionUser);
    var saveRetArr = saveRet.split('^');
    if (saveRetArr[0] < 0) {
        $.messager.alert('提示', saveRetArr[1], 'warning');
        return;
    } else {
        $.messager.alert('提示', '生成成功' , 'info');
        Query();

    }
}
// 获取有效记录
function GetSaveParams() {
    $('#gridDisped').datagrid('endEditing');
    var gridChked = $('#gridDisped').datagrid('getChecked');
    var gridChkedLen = gridChked.length;
    if (gridChkedLen == 0) {
        $.messager.popover({
            msg: '请先勾选需要申请的记录',
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
            $.messager.alert('提示', '第' + (i + 1) + '行药品维护了不可退药原因,不能退药申请', 'warning');
            return '';
        }
        var chkRet = tkMakeServerCall('PHA.HERB.Request.Save', 'CheckBeforeSave', phbdicId);
        if (chkRet.split('^')[0] < 0) {
            $.messager.alert('提示', rowData.incDesc + ':' + chkRet.split('^')[1], 'warning');
            return '';
        }
        if (lastRecLocId != '' && lastRecLocId != recLocId) {
            $.messager.alert('提示', '请选择相同发药科室生成退药申请', 'warning');
            return '';
        }
        lastRecLocId = recLocId;
        var iParams = dspSubId + '^' + reqQty + '^' + reqReasonId + '^' + phbdicId + '^' + prescNo;
        paramsStr = paramsStr == '' ? iParams : paramsStr + ',' + iParams;
    }
    if (paramsStr == "") {
        PHA.Popover({
            msg: '没有需要保存的数据',
            type: 'alert'
        });
        return;
    }
    return paramsStr;
}

// 设置默认科室关联
function SetDefaultLoc() {
    var PhaLoc = $('#cmbPhaLoc').combobox('getValue') || '';
    var PhaLocDesc = $('#cmbPhaLoc').combobox('getText') || '';
    if (PhaLoc == '') {
        //$.messager.alert("提示", "请先选择发药科室", "warning");
        //return;
    }
    if (SessionLoc == '') {
        return;
    }
    var confirmText = $g("确认将")+"<span>" + PhaLocDesc +"</span>" + $g("设置成默认科室吗?");
    if (PhaLoc == '') {
        confirmText = '确认默认科室设置为空吗?';
    }
    $.messager.confirm('确认提示', confirmText, function (r) {
        if (r) {
            var saveRet = tkMakeServerCall('web.DHCSTRETREQUEST', 'SetDefaultPhaLoc', PhaLoc, SessionLoc);
            var saveArr = saveRet.split('^');
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal == 0) {
                $.messager.alert('提示', '设置成功', 'info');
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
                    title: '申请原因',
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
        title: '选择退药申请原因',
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
