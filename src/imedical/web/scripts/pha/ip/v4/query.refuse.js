/**
 * 住院药房 - 拒发药查询
 * creator:    yunhaibao
 * createDate: 2022-08-24
 */
// PHA_SYS_SET=undefined;
$(function () {
    PHA_COM.App.Csp = 'pha.ip.v4.query.refuse.csp';
    var SessionWardID = session['LOGON.WARDID'] || '';
    var PHA_IP_QUERY_REFUSE = {
        WardFlag: SessionWardID != '' ? 'Y' : 'N',
        DefaultData: [
            {
                startDate: 't-1',
                endDate: 't',
                phaLoc: SessionWardID === '' ? session['LOGON.CTLOCID'] : '',
                takeLoc: SessionWardID === '' ? '' : session['LOGON.CTLOCID']
            }
        ]
    };
    if (PHA_IP_QUERY_REFUSE.WardFlag !== 'Y' && URL_PHA_EpisodeID !== '') {
        // 不是药房菜单 & 不是护士进入, 允许查看所有
        PHA_IP_QUERY_REFUSE.DefaultData[0].phaLoc = '';
        PHA_IP_QUERY_REFUSE.DefaultData[0].takeLoc = '';
    }

    if (URL_PHA_EpisodeID !== '') {
        var admJson = PHA.CM(
            {
                pClassName: 'PHA.IP.COM.Data',
                pMethodName: 'GetAdmData',
                adm: URL_PHA_EpisodeID
            },
            false
        );
        PHA_IP_QUERY_REFUSE.DefaultData[0].patNo = admJson.patNo;
    }

    PHA_COM.SetPanel('#pha_ip_v4_query_refuse', $('#pha_ip_v4_query_refuse').panel('options').title);
    PHA.ComboBox('phaLoc', {
        panelWidth: 200,
        url: PHA_STORE.Pharmacy('IP').url,
        onLoadSuccess: function (data) {
            for (var i = 0; i < data.length; i++) {
                if (data[i].RowId == session['LOGON.CTLOCID']) {
                    $(this).combobox('setValue', data[i].RowId);
                    break;
                }
            }
        },
        onSelect: function (data) {}
    });
    PHA.ComboBox('takeLoc', {
        // panelWidth:'auto',
        url: PHA_STORE.CTLoc().url
    });
    setTimeout(function () {
        PHA.SetVals(PHA_IP_QUERY_REFUSE.DefaultData);
        $('#btnFind').click();
    }, 500);

    InitGridRefuse();
    $('#patNo').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            $(this).val(PHA_COM.FullPatNo($(this).val()));
            Query();
        }
    });
    PHA_EVENT.Bind('#btnFind', 'click', function () {
        Query();
    });
    PHA_EVENT.Bind('#btnUndo', 'click', function () {
        HandleCancel();
    });
    PHA_EVENT.Bind('#btnClean', 'click', function () {
        PHA_COM.Condition('.qCondition', 'clear');
        $('#gridRefuse').datagrid('clear');
        PHA.SetVals(PHA_IP_QUERY_REFUSE.DefaultData);
    });
    function InitGridRefuse() {
        var frozenColumns = [
            [
                {
                    checkbox: true,
                    field: 'gCheck'
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'refuseID',
                    title: 'refuseID',
                    hidden: true,
                    width: 100
                },
                {
                    field: 'refuseReasonDesc',
                    title: '拒绝原因',
                    width: 150,
                    showTip: true
                },
                {
                    field: 'refuseDate',
                    title: '拒绝日期',
                    width: 100
                },
                {
                    field: 'refuseTime',
                    title: '拒绝时间',
                    width: 80
                },
                {
                    field: 'refuseUserName',
                    title: '拒绝人',
                    width: 100
                },
                {
                    field: 'refuseLocDesc',
                    title: '发药科室',
                    width: 100
                },
                {
                    field: 'takeLocDesc',
                    title: '取药科室',
                    width: 100
                },
                {
                    field: 'bedNo',
                    title: '床号',
                    width: 100
                },
                {
                    field: 'patName',
                    title: '姓名',
                    width: 100
                },
                {
                    field: 'patNo',
                    title: '登记号',
                    width: 100
                },
                {
                    field: 'orderDesc',
                    title: '医嘱名称',
                    width: 200
                },
                {
                    field: 'doseDateTime',
                    title: '用药时间',
                    width: 100
                },
                {
                    field: 'dosage',
                    title: '剂量',
                    width: 100
                },
                {
                    field: 'oeoriStatusDesc',
                    title: '医嘱状态',
                    width: 100
                },
                {
                    field: 'oeoriStatusDesc',
                    title: '医嘱状态',
                    width: 100
                },
                {
                    field: 'seeTypeDesc',
                    title: '护士医嘱处理',
                    width: 100
                },
                {
                    field: 'oeoreStatusDesc',
                    title: '执行记录状态',
                    width: 100
                },
                {
                    field: 'prescNo',
                    title: '处方号',
                    width: 120
                },
                {
                    field: 'oeore',
                    title: '执行记录ID',
                    width: 100
                }
            ]
        ];
        var dataGridOption = {
            pagination: true,
            pageSize: 9999,
            pageList: [9999],
            frozenColumns: frozenColumns,
            columns: columns,
            rownumbers: true,
            toolbar: '#gridRefuseBar',
            enableDnd: false,
            singleSelect: false,
            onLoadSuccess: function () {
                $(this).datagrid('clearChecked');
            },
            onCheck: function(rowIndex, rowData){
	            if ($(this).datagrid('options').checking == true) {
		            return;
		        }
		        $(this).datagrid('options').checking = true;
	            var rows = $(this).datagrid('getRows');
	            for (var i = 0; i < rows.length; i++) {
		            if (i == rowIndex) {
			            continue;
			        }
		            if (rows[i].prescNo == rowData.prescNo) {
			            $(this).datagrid('checkRow', i);
			        }
		        }
		        $(this).datagrid('options').checking = false;
	        },
	        onUncheck: function(rowIndex, rowData){
		        if ($(this).datagrid('options').checking == true) {
		            return;
		        }
		        $(this).datagrid('options').checking = true;
		        var rows = $(this).datagrid('getRows');
	            for (var i = 0; i < rows.length; i++) {
		            if (i == rowIndex) {
			            continue;
			        }
		            if (rows[i].prescNo == rowData.prescNo) {
			            $(this).datagrid('uncheckRow', i);
			        }
		        }
		        $(this).datagrid('options').checking = false;
		    }
        };
        PHA.Grid('gridRefuse', dataGridOption);
        //$($('#gridRefuse').parent().parent().find('.datagrid-pager>table')[0]).hide();
    }

    function Query() {
        var pJson = PHA_COM.Condition('.qCondition', 'get');
        if (pJson === undefined) {
            return;
        }
        $('#gridRefuse').datagrid('options').url = $URL;
        $('#gridRefuse').datagrid('query', {
            ClassName: 'PHA.IP.Refuse.Query',
            QueryName: 'DispRefuse',
            pJsonStr: JSON.stringify(pJson)
        });
    }
    function HandleCancel() {
        var checkedData = GetCheckedData();
        if (checkedData.length === 0) {
            PHA.Popover({ type: 'info', msg: '请先勾选记录' });
            return;
        }
        PHA.Confirm('温馨提示', '您正在操作【取消】，继续请点击【确定】，返回请点击【取消】', function () {
            PHA.Loading('Show');
            $.cm(
                {
                    ClassName: 'PHA.IP.Data.Api',
                    MethodName: 'HandleInOne',
                    pClassName: 'PHA.IP.Refuse.Biz',
                    pMethodName: 'HandleCancel',
                    pJsonStr: JSON.stringify(checkedData)
                },
                function (retJson) {
                    PHA.Loading('Hide');
                    retJson.success = retJson.successFlag;
                    if (retJson.successFlag !== 'Y') {
                        var msg = PHAIP_COM.DataApi.Msg(retJson);
                        PHA.Alert('提示', msg, 'warning');
                    }
                    Query();
                },
                function (retData) {
                    PHA.Loading('Hide');
                    PHA.Alert('提示', '访问异常' + retData, 'error');
                }
            );

            return;
            PHA.CM(
                {
                    pClassName: 'PHA.IP.Refuse.Biz',
                    pMethodName: 'HandleCancel',
                    pJson: JSON.stringify({ idRows: idArr })
                },
                function (retData) {
                    PHA.Loading('Hide');
                    Query();
                },
                function (retData) {
                    PHA.Loading('Hide');

                    PHA.Alert('提示', '访问异常' + retData, 'error');
                }
            );
        });
    }
    function GetCheckedData() {
        var retArr = [];
        var checkRows = $('#gridRefuse').datagrid('getChecked');
        for (var i = 0, length = checkRows.length; i < length; i++) {
            var iData = checkRows[i];
            retArr.push({ refuseID: iData.refuseID });
        }
        return retArr;
    }
    if (PHA_IP_QUERY_REFUSE.WardFlag === 'Y') {
        $('#btnUndo').remove();
        $('#takeLoc').combobox('disable');
    }else{
        if (URL_PHA_EpisodeID == '') {
            $('#phaLoc').combobox('disable');
        }
    }
    if (URL_PHA_FromIconProfile !== '') {
        $('#btnUndo').remove();
    }

});
