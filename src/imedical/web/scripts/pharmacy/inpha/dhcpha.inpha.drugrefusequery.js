/**
 * 模块:住院药房
 * 子模块:住院药房药房-拒发药品查询
 * createdate:2016-12-13
 * creator:xueshuaiyi
 */
var SessionWard = session['LOGON.WARDID'] || '';
$(function () {
    /* 初始化插件 start*/
    var daterangeoptions = {
        singleDatePicker: true
    };
    $('#date-start').dhcphaDateRange(daterangeoptions);
    $('#date-end').dhcphaDateRange(daterangeoptions);
    //屏蔽所有回车事件
    $('input[type=text]').on('keypress', function (e) {
        if (window.event.keyCode == '13') {
            return false;
        }
    });
    InitPhaLoc();
    InitWard();
    InitDocLoc();
    InitRefuseList();
    //登记号回车事件
    $('#txt-patno').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var patno = $.trim($('#txt-patno').val());
            if (patno != '') {
                var newpatno = NumZeroPadding(patno, DHCPHA_CONSTANT.DEFAULT.PATNOLEN);
                $(this).val(newpatno);
                if (newpatno != '') {
                    Query();
                }
            }
        }
    });
    /* 绑定按钮事件 start*/
    $('#btn-find').on('click', Query);
    $('#btn-cancelrefuse').on('click', BCancelRefuseHandler);
    /* 绑定按钮事件 end*/
    if (FromIconProfile == 1) {
        window.resizeTo(window.screen.availWidth * 0.85, window.screen.availHeight * 0.75);
        setTimeout(function () {
            var iTop = (window.screen.availHeight - $(window).height()) / 2;
            var iLeft = (window.screen.availWidth - $(window).width()) / 2;
            window.moveTo(iTop, iLeft);
            setTimeout(function () {
                ResizeRefuseQuery();
                Query();
            }, 500);
        }, 500);
    } else {
        ResizeRefuseQuery();
    }
});
window.onload = function () {
    if (EpisodeID != '') {
        var patinfo = tkMakeServerCall('web.DHCSTPharmacyCommon', 'GetPatInfoByAdm', EpisodeID);
        patinfo = JSON.parse(patinfo);
        patinfo = patinfo[0];
        $('#txt-patno').val(patinfo.PatNo);
        $('#txt-name').val(patinfo.PatName);
        $('#btn-cancelrefuse').css('display', 'none');
    }
    //Query();
};
//初始化科室
function InitPhaLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetStockPhlocDs&style=select2&groupId=' + DHCPHA_CONSTANT.SESSION.GROUP_ROWID,
        allowClear: true,
        placeholder: '药房...'
    };
    $('#sel-phaloc').dhcphaSelect(selectoption);
    if (DHCPHA_CONSTANT.DEFAULT.LOC.type == 'D') {
        var select2option = '<option value=' + "'" + DHCPHA_CONSTANT.DEFAULT.LOC.id + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>';
        $('#sel-phaloc').append(select2option);
    }
}
//初始化病区
function InitWard() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_INPHA_URL + '?action=GetWardLocDs&style=select2',
        allowClear: true,
        width: 200,
        placeholder: '病区...'
    };
    $('#sel-ward').dhcphaSelect(selectoption);
    if (DHCPHA_CONSTANT.DEFAULT.LOC.type == 'W') {
        if (SessionWard != '') {
            var select2option = '<option value=' + "'" + SessionWard + "'" + 'selected>' + DHCPHA_CONSTANT.DEFAULT.LOC.text + '</option>';
            $('#sel-ward').append(select2option);
        }
    }
}
// 初始化医生科室
function InitDocLoc() {
    var selectoption = {
        url: DHCPHA_CONSTANT.URL.COMMON_PHA_URL + '?action=GetCtLocDs&style=select2&custtype=DocLoc',
        allowClear: true,
        placeholder: '医生科室...'
    };
    $('#sel-docloc').dhcphaSelect(selectoption);
    $('#sel-docloc').on('select2:select', function (event) {
        //alert(event)
    });
}
//初始化拒发药列表
function InitRefuseList() {
    //定义columns
    var columns = [
        [
            {
                field: 'TSelect',
                checkbox: true,
                title: ''
            },
            {
                field: 'TRegNo',
                title: '登记号',
                width: 100,
                sortable: true
            },
            {
                field: 'TPaName',
                title: '病人姓名',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TRecLocDesc',
                title: '发药科室',
                width: 120,
                align: 'left',
                sortable: true
            },
            {
                field: 'TWard',
                title: '病区/医生科室',
                width: 120,
                align: 'left',
                sortable: true
            },
            {
                field: 'TBed',
                title: '床号',
                width: 80,
                align: 'left',
                sortable: true
            },
            {
                field: 'TCode',
                title: '代码',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TDesc',
                title: '名称',
                width: 180,
                align: 'left',
                sortable: true
            },
            {
                field: 'TQty',
                title: '数量',
                width: 80,
                align: 'right',
                sortable: true
            },
            {
                field: 'TUom',
                title: '单位',
                width: 80,
                align: 'center',
                sortable: true
            },
            {
                field: 'TUser',
                title: '拒绝人',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TDate',
                title: '拒绝日期',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TTime',
                title: '拒绝时间',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TPriDesc',
                title: '医嘱类型',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TOrdStatus',
                title: '医嘱当前状态',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TRefuseReason',
                title: '拒绝原因',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TPrescno',
                title: '处方号',
                width: 110,
                align: 'left',
                sortable: true
            },
            {
                field: 'Toeori',
                title: '医嘱ID',
                width: 100,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TSttDate',
                title: '医嘱开始日期',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TSttTime',
                title: '医嘱开始时间',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TDateDosing',
                title: '用药日期',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TTimeDosing',
                title: '用药时间',
                width: 100,
                align: 'left',
                sortable: true
            },
            {
                field: 'TEncryptLevel',
                title: '病人密级',
                width: 100,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TPatLevel',
                title: '病人级别',
                width: 100,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TGeneric',
                title: '通用名',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TBarcode',
                title: '规格',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TForm',
                title: '剂型',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TManf',
                title: '厂家',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TPrice',
                title: '单价',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TAmt',
                title: '金额',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TOrdStatusCode',
                title: 'TOrdStatusCode',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'Toedis',
                title: 'Toedis',
                width: 80,
                align: 'left',
                sortable: true,
                hidden: true
            },
            {
                field: 'TRecLocId',
                title: 'TRecLocId',
                width: 180,
                align: 'left',
                sortable: true,
                hidden: true
            }
        ]
    ];

    var dataGridOption = {
        url: DHCPHA_CONSTANT.URL.EASYUI_QUERY_URL,
        columns: columns,
        fitColumns: false,
        singleSelect: false,
        datatype: 'local'
    };
    //定义datagrid
    $('#grid-disprefuse').dhcphaEasyUIGrid(dataGridOption);
}
///拒发药品查询
function Query() {
    var startdate = $('#date-start').val();
    var enddate = $('#date-end').val();
    var phaloc = $('#sel-phaloc').val();
    if (phaloc == null) {
        phaloc = '';
    }
    if (SessionWard == '' && phaloc == '') {
        dhcphaMsgBox.alert('请先选择药房');
        return;
    }
    var ward = $('#sel-ward').val() || '';

    var docLoc = $('#sel-docloc').val() || '';
    var patNo = $('#txt-patno').val();
    var patName = $('#txt-name').val();
    var tmpSplit = DHCPHA_CONSTANT.VAR.SPLIT;
    var params = startdate + tmpSplit + enddate + tmpSplit + phaloc + tmpSplit + ward + tmpSplit + patNo + tmpSplit + patName + tmpSplit + '' + tmpSplit + '' + tmpSplit + docLoc;
    $('#grid-disprefuse').datagrid({
        datatype: 'json',
        queryParams: {
            ClassName: 'web.DHCSTDRUGREFUSE',
            QueryName: 'DrugRefuse',
            Params: params //此处params参数分隔,最后从拆分个数以及顺序同对应query
        }
    });
}
//取消拒发药
function BCancelRefuseHandler() {
    var gridChecked = $('#grid-disprefuse').datagrid('getChecked');
    if (gridChecked == '') {
        dhcphaMsgBox.alert('请先选择记录');
        return;
    }
    dhcphaMsgBox.confirm('是否取消拒绝发药?', function (retValue) {
        if (retValue == true) {
            var cLen = gridChecked.length;
            for (var cI = 0; cI < cLen; cI++) {
                var ordStatusCode = gridChecked[cI].TOrdStatusCode;
                if (ordStatusCode) {
                    var dspId = gridChecked[cI].Toedis;
                    if (dspId != '') {
                        if (deleteRefuse(dspId) == false) {
                            return;
                        }
                    }
                }
            }
            Query();
        }
    });
}

function deleteRefuse(oedis) {
    var cancelRet = tkMakeServerCall('web.DHCSTDRUGREFUSE', 'DeleteRefuse', '', '', oedis, DHCPHA_CONSTANT.SESSION.GCTLOC_ROWID);
    if (cancelRet == '-2') {
        dhcphaMsgBox.alert('该记录已经撤销执行或停止执行，不能取消拒绝！');
        return false;
    } else if (cancelRet == '-3') {
        dhcphaMsgBox.alert('您无法撤销拒绝,请联系拒绝发药的药房!');
        return false;
    } else if (cancelRet < 0) {
        dhcphaMsgBox.alert('取消拒绝失败!');
        return false;
    } else {
    }
    return true;
}
window.onresize = ResizeRefuseQuery;

function ResizeRefuseQuery() {
    $('#grid-disprefuse').closest('.panel-body').height(GridCanUseHeight(1));
    $('#grid-disprefuse').datagrid('resize');
}
