/**
 * 名称:   住院药房 - 发药
 * 编写人:  yunhaibao
 * 编写日期: 2020-05-06
 */
// PHA_SYS_SET = undefined;
PHA_COM.Val.CAModelCode = 'PHAIPDisp';
$(function () {
    var settings = PHA.CM(
        {
            pClassName: 'PHA.IP.Disp.Api',
            pMethodName: 'GetDispSettings',
            pJson: JSON.stringify({
                logonLoc: session['LOGON.CTLOCID'],
                logonUser: session['LOGON.USERID'],
                logonGroup: session['LOGON.GROUPID'],
                macAddr: PHAIP_COM.GetMac()
            })
        },
        false
    );
    if (JSON.stringify(settings) === '{}') {
        PHA.Alert('提示', '获取参数配置失败, 请先在【住院发药科室维护】中设置登录的药房科室', 'error');
        $('.messager-button').css('visibility', 'hidden');
        return;
    }
    if (settings.warnInfo !== '') {
        PHA.Alert('提示', '<div>' + settings.warnInfo.replace(/,/g, ', ') + '</div>', 'warning');
    }
    var PHA_IP_DISP = {
        WardFlag: session['LOGON.WARDID'] != '' ? 'Y' : 'N',
        DefaultData: [settings.defaultData],
        DISPCATARR: settings.dispCatArr,
        DISPCATDEFSELECT: settings.dispCatSelectArr,
        Config: settings.config,
        LocalConfig: settings.localConfig,
        HandleVars: {
            RefuseReason: '', // 拒绝发药原因
            DispUser: '', // 选择的发药人
            DispCollateUser: '', // 选择的核对人
            DispOperateUser: '', // 选择的配药人
            Pid: '',
            PhacIDArr: [],
            NeedPrint: true // 需要打印发药单
        },
        // 用于隐藏相同患者的信息, 使界面内容分组更清晰
        OrderSameRowsHanlder: PHAIP_COM.SameRows('gridOrder', '[field=patNo],[field=sex],[field=patName],[field=bedNo],[field=docLocDesc],[field=age]')
    };

    InitDict();
    InitTakeLoc();
    InitGridInci();

    InitGridOrder();
    InitRefuseReason();
    InitOperateUser();
    $('#btnFind').on('click', function () {
        var tabCode = $('#tabsTotal').tabs('getSelected').panel('options').code;
        QueryTakeLoc();
    });
    $('#btnFindDetail').on('click', function () {
        QueryDetail();
    });
    $('#btnRefresh,#btnRefresh-inci').on('click', function () {
        QueryDetail();
    });
    $('#btnAllSelect').on('click', function () {
        PHAIP_COM.LocalCheckPage($('#gridOrder'), 'Y', 0, 999999);
        $('#gridOrder').datagrid('checkAll');
    });
    $('#btnAllUnSelect').on('click', function () {
        PHAIP_COM.LocalCheckPage($('#gridOrder'), '', 0, 999999);
        $('#gridOrder').datagrid('uncheckAll');
    });
    PHA_EVENT.Bind('#btnRefuseDisp', 'click', HandleRefuse);
    PHA_EVENT.Bind('#btnClean', 'click', HandleClean);
    PHA_EVENT.Bind('#btnDisp', 'click', function () {
        PHA_IP_DISP.HandleVars.NeedPrint = false;
        PHAIP_COM.CACert('PHAIPDisp', HandleDisp);
    });
    // PHA_EVENT.Bind('#btnDispPrint', 'click', function () {
    //     PHA_IP_DISP.HandleVars.NeedPrint = true;
    //     PHAIP_COM.CACert('PHAIPDisp', HandleDisp);
    // });
    PHA.SetVals(PHA_IP_DISP.DefaultData);
    $('#tabsDetail').tabs({
        onSelect: function () {
            QueryDetail('tabSelect');
        }
    });
    $('#tabsTotal').tabs({
        tools: '#tabsTotalTools',
        onSelect: function () {
            var tabCode = $('#tabsTotal').tabs('getSelected').panel('options').code;
            if (tabCode === 'loc' || tabCode === 'base' || tabCode === 'out') {
                $('#takeLocBaseTab').parent().css('display', 'block');
            }
            ResetDateTime();
            QueryTakeLoc();
        }
    });
    setTimeout(function () {
        PHAIP_COM.ToggleMore('moreorless', '.js-pha-moreorless', { width: $($('.js-pha-moreorless .pha-con-table')[0]).outerWidth() });
        // $('#btnMoreCondition').popover({
        //     trigger: 'click',
        //     // placement: 'left',
        //     content: 'content',
        //     dismissible: false,
        //     width: $($('.js-pha-moreorless .pha-con-table')[0]).outerWidth(),
        //     padding: false,
        //     url: '.js-pha-moreorless'
        // });
        // PHAIP_COM.ToggleMore('btnMoreCondition', '.js-pha-moreorless', { width: $($('.pha-con-table')[1]).outerWidth() });
    }, 0);

    function InitOperateUser() {
        if (PHA_IP_DISP.Config.needInputDispUser === 'Y') {
            $('#dispUser').closest('tr').show();
        }
        if (PHA_IP_DISP.Config.needInputOperateUser === 'Y') {
            $('#dispOperateUser').closest('tr').show();
        }
        if (PHA_IP_DISP.Config.needInputCollateUser === 'Y') {
            $('#dispCollateUser').closest('tr').show();
        }
        // 选择发药人的窗口
        $('#winUserSelect').dialog({
            title: '操作人',
            collapsible: false,
            iconCls: 'icon-w-list',
            maximizable: false,
            minimizable: false,
            border: false,
            closable: false,
            closed: true,
            modal: true,
            onOpen: function () {
                $('#winUserSelect')
                    .window('resize', {
                        width: $('#winUserSelect .pha-con-table').width() + 10,
                        height: 'auto'
                    })
                    .window('center');
            },
            buttons: [
                {
                    text: '确定',
                    handler: function () {
                        PHA_IP_DISP.HandleVars.DispUser = $('#dispUser').combobox('getValue');
                        PHA_IP_DISP.HandleVars.DispCollateUser = $('#dispCollateUser').combobox('getValue');
                        PHA_IP_DISP.HandleVars.DispOperateUser = $('#dispOperateUser').combobox('getValue');
                        var selMsg = '';
                        if ($('#dispUser').closest('tr').css('display') !== 'none' && PHA_IP_DISP.HandleVars.DispUser === '') {
                            selMsg = '请先选择发药人';
                        }
                        if ($('#dispOperateUser').closest('tr').css('display') !== 'none' && PHA_IP_DISP.HandleVars.DispOperateUser === '') {
                            selMsg = '请先选择配药人';
                        }
                        if ($('#dispCollateUser').closest('tr').css('display') !== 'none' && PHA_IP_DISP.HandleVars.DispCollateUser === '') {
                            selMsg = '请先选择核对人';
                        }
                        if (selMsg !== '') {
                            PHA.Popover({
                                msg: selMsg,
                                type: 'info'
                            });
                            return;
                        }
                        $('#winUserSelect').window('close');
                        ExecuteDisp();
                    }
                },
                {
                    text: '取消',
                    handler: function () {
                        $('#winUserSelect').window('close');
                    }
                }
            ]
        });
        //        $('#winUserSelect').window('open')
    }
    function InitRefuseReason() {
        PHA.Grid('gridRefuseReason', {
            toolbar: null,
            url: $URL,
            queryParams: {
                ClassName: 'PHA.IP.COM.Store',
                QueryName: 'DispRefuseReason',
                pHosp: session['LOGON.HOSPID']
            },
            exportXls: false,
            pagination: false,
            fitColumns: true,
            rownumbers: true,
            headerCls: 'panel-header-gray',
            bodyCls: 'panel-body-gray',
            border: true,
            columns: [
                [
                    {
                        field: 'RowId',
                        title: 'RowId',
                        width: 100,
                        hidden: true
                    },
                    {
                        field: 'Description',
                        title: '原因',
                        width: 1000
                    }
                ]
            ],
            onDblClickRow: function () {
                $('#winReturnReason-ok').click();
            }
        });
        $('#winRefuseReason').dialog({
            title: '拒绝发药原因',
            collapsible: false,
            iconCls: 'icon-w-list',
            maximizable: false,
            minimizable: false,
            border: false,
            closable: true,
            closed: true,
            modal: true,
            width: 500,
            height: 500,
            buttons: [
                {
                    id: 'winReturnReason-ok',
                    text: '确定',
                    handler: function () {
                        var selData = $('#gridRefuseReason').datagrid('getSelected');
                        if (selData === null) {
                            PHA.Popover({ type: 'info', msg: '请先选择原因' });
                            return;
                        }
                        PHA_IP_DISP.HandleVars.RefuseReason = selData.RowId;
                        $('#winRefuseReason').window('close');
                        $('#gridRefuseReason').datagrid('reload');
                        ExecuteRefuse();
                    }
                },
                {
                    text: '取消',
                    handler: function () {
                        $('#winRefuseReason').window('close');
                        $('#gridRefuseReason').datagrid('reload');
                    }
                }
            ]
        });
    }
    function InitDict() {
        PHA.ComboBox('takeLoc', {
            url: PHA_STORE.CTLoc().url
        });
        PHA.ComboBox('locGrp', {
            url: PHA_STORE.LocGroup(session['LOGON.CTLOCID']).url
        });
        PHA.ComboBox('dispCat', {
            rowStyle: 'checkbox',
            editable: false,
            multiple: true,
            url: PHAIP_STORE.StkDrugGroup().url + '&loc=' + session['LOGON.CTLOCID']
        });
        PHA.ComboBox('dispCatSelect', {
            multiple: true,
            rowStyle: 'checkbox',
            editable: false,
            width: 340,
            placeholder: '按列全选/全消发药类别',
            url: PHAIP_STORE.StkDrugGroup().url + '&loc=' + session['LOGON.CTLOCID'],
            onHidePanel: function () {}
        });

        var opts = $.extend({}, PHA_STORE.INCItm('Y'), {
            onShowPanel: function () {
                $('#z-q-container').css('z-index', 9999);
            },
            panelWidth: 420,
            width: HISUIStyleCode !== 'lite' ? 159 : 153,
            fitColumns: true,
            autoSizeColumn: true
        });
        PHA.LookUp('inci', opts);
        PHA.ComboBox('dispUser', {
            url: PHA_STORE.SSUser(GetCurrentLoc()).url
        });
        PHA.ComboBox('dispOperateUser', {
            url: PHA_STORE.SSUser(GetCurrentLoc()).url
        });
        PHA.ComboBox('dispCollateUser', {
            url: PHA_STORE.SSUser(GetCurrentLoc()).url
        });
        PHA.ComboBox('packType', {
            data: [
                { RowId: 'pack', Description: '整包装' },
                { RowId: 'unpack', Description: '散包装' }
            ]
        });
        // 提醒信息
        $('#localConfigFlag')
            .next()
            .tooltip({
                content: function () {
                    var infoHtmlArr = [];
                    var infoJson = PHA_IP_DISP.LocalConfig;
                    for (var i = 0, length = infoJson.length; i < length; i++) {
                        var iData = infoJson[i];
                        if (iData.dispCatDescStr === '') {
                            continue;
                        }
                        infoHtmlArr.push('<div>' + iData.priorityDesc + '</div>');
                        infoHtmlArr.push('<div style="padding-left:2rem;">' + iData.dispCatDescStr + '</div>');
                    }
                    if (infoHtmlArr.length > 0) {
                        return infoHtmlArr.join('');
                    } else {
                        return '没有设置相关数据';
                    }
                },
                showDelay: 500
            });
        $('#resFlag')
            .next()
            .tooltip({
                content: function () {
                    return (
                        '<div style="width:300px">' +
                        '<div>发药后按病区冲减退药申请</div>' +
                        '<div>冲减开始日期：' +
                        PHA_IP_DISP.Config.reserveRetStartDate +
                        '</div>' +
                        '<div>冲减结束日期：' +
                        PHA_IP_DISP.Config.reserveRetEndDate +
                        '</div>' +
                        '</div>'
                    );
                },
                showDelay: 500
            });
        $('#autoRefreshFlag').next().tooltip({
            content: '间隔60秒刷新一次',
            showDelay: 500
        });

        $('#patNo').on('keypress', function (event) {
            if (window.event.keyCode == '13') {
                $(this).val(PHA_COM.FullPatNo($(this).val()));
                $('#btnFind').trigger('click');
            }
        });
        if (PHA_IP_DISP.Config.lsFlag === 'Y') {
            $('#longOrderFlag').checkbox('options').onChecked = function () {
                $('#shortOrderFlag').checkbox('setValue', false);
            };
            $('#shortOrderFlag').checkbox('options').onChecked = function () {
                $('#longOrderFlag').checkbox('setValue', false);
            };
        }
    }
    var TriggerFind = '';
    function InitTakeLoc() {
        var columns = [];
        var checkboxColumns = [];
        var dispCatArr = PHA_IP_DISP.DISPCATARR;
        var oneCatObj;
        for (var i = 0, length = dispCatArr.length; i < length; i++) {
            var dispCatObj = dispCatArr[i];
            var dispCatDesc = $g(dispCatObj.dispCatDesc);
            oneCatObj = {
                field: 'dispcat-' + dispCatObj.dispCatCode,
                title: dispCatDesc.split('').join('</br>'),
                width: 40,
                align: 'center',
                formatter: function (value, rowData, rowIndex) {
                    var chkHtml = '';
                    if (value === 'Y') {
                        chkHtml = $('#checkboxTemplate [name="checked"]').html();
                    } else if (value === 'N') {
                        chkHtml = $('#checkboxTemplate [name="uncheck"]').html();
                    } else {
                        // 反正也无法选择, 直接空得了
                        chkHtml = ''; //$('#checkboxTemplate [name="disable"]').html();
                    }
                    // 不清楚HISUI什么逻辑, 此处其实不应该有兼容
                    if (HISUIStyleCode === 'blue') {
                        return '<div style="padding-left:5px;">' + chkHtml + '</div>';
                    }
                    return chkHtml;
                }
            };
            columns.push(oneCatObj);
        }
        var dataGridOption = {
            url: '',
            toolbar: [], //'#gridTakeLocBar',
            // btoolbar:'#gridTakeLocBar-b',
            exportXls: false,
            frozenColumns: [
                [
                    {
                        checkbox: true,
                        field: 'gCheck'
                    },
                    {
                        field: 'takeLoc',
                        title: 'takeLoc',
                        width: 150,
                        hidden: true
                    },
                    {
                        field: 'takeLocDesc',
                        title: '取药科室',
                        width: 150,
                        formatter: function (value, rowData, rowIndex) {
                            var notifyOrderFlag = rowData.notifyOrdFlag;
                            if (notifyOrderFlag !== '') {
                                return '<div style="position:relative;">' + value + '<div class="pha-ip-takeloc-notify"><span class="icon pha-icon-blue icon-emergency"></span></div></div>';
                                // return '<span style="color:red">急</span>' + value
                                return '<div style="position:relative;">' + value + '<div class="pha-ip-takeloc-notify">急</div></div>';
                                return '<div><div style="color:red;padding-top:8px;position:relative;">' + value + '</div><div style="color:red;padding-top:8px;">存在加急医嘱</div></div>';
                            }
                            return value;
                        }
                    }
                ]
            ],
            columns: [columns],
            exportXls: false,
            pageList: [999999],
            pageSize: 999999,
            pagination: false,
            showPageList: false,
            showHeader: true,
            striped: false,
            singleSelect: false,
            queryOnSelect: true,
            checkOnSelect: true,
            selectOnCheck: true,
            dispCatCheck: false,
            onCheck: function () {
                if (NeedAutoFind() === true) {
                    QueryDetail();
                }
            },
            onUncheck: function (rowIndex) {
                if (NeedAutoFind() === true) {
                    QueryDetail();
                }
            },
            // 用于控制勾选发药类别的选中行
            onBeforeUnselect: function (rowIndex, rowData) {
                if ($(this).datagrid('options').dispCatCheck === true) {
                    if (NeedAutoFind() === true) {
                        QueryDetail();
                    }
                    return false;
                }
                return true;
            },
            onCheckAll: function () {
                if (NeedAutoFind() === true) {
                    QueryDetail();
                }
            },
            onUncheckAll: function () {
                if (NeedAutoFind() === true) {
                    QueryDetail();
                }
            },
            onClickCell: function (rowIndex, field) {
                //$('#btnFindDetail,#btnRefresh').phashake(1, 2, 200);
                $(this).datagrid('options').dispCatCheck = false;
                // 点击发药类别列的单元格,更新标志
                if (field.indexOf('dispcat') >= 0) {
                    $(this).datagrid('options').dispCatCheck = true;
                    var fieldValue = $(this).datagrid('getRows')[rowIndex][field];
                    if (fieldValue !== 'Y' && fieldValue !== 'N') {
                        $(this).datagrid('options').queryOnSelect = false;
                        return;
                    }
                    var newData = {};
                    newData[field] = fieldValue === 'Y' ? 'N' : 'Y';
                    $('#gridTakeLoc').datagrid('updateRow', {
                        index: rowIndex,
                        row: newData
                    });
                }
            },
            onLoadSuccess: function (data) {
                $('#gridInci, #gridOrder').datagrid('clear');
                if (data.msg) {
                    PHA.Alert('错误提示', data.msg, 'error');
                }
            }
        };
        PHA.Grid('gridTakeLoc', dataGridOption);
        return;
        // mouseleave经常丢事件触发不到
        $('#lyWest').mouseleave(function (event) {
            var conditionStr = GetTargetCondition('#gridOrder');
            var pJson = GetQueryDetailCondition();
            // 条件发生变化, 则触发刷新
            if (conditionStr !== JSON.stringify(pJson)) {
                $('#btnRefresh').click();
            }
        });
    }
    // 针对checkbox需要单独处理
    PHA.GridCheckBoxEvent = function (gridID, eventType, classArr, callBack) {
        eventType = eventType || 'click';
        $('#' + gridID)
            .parent()
            .find('.datagrid-body-inner, .datagrid-body ')
            .on(eventType, function () {
                var $target = $(event.target);
                var className = $target.closest('div').attr('class');
                if (classArr.indexOf(className) >= 0) {
                    var rowIndex = $target.closest('tr[datagrid-row-index]').attr('datagrid-row-index');
                    if (rowIndex) {
                        var rowData = $('#' + gridID).datagrid('getRows')[rowIndex];
                        if ($('#' + gridID).datagrid('options').view.type === 'scrollview') {
                            rowData = $('#' + gridID).datagrid('getData').firstRows[rowIndex];
                        }
                        callBack(rowIndex, rowData, className, field);
                    }
                }
            });
    };
    function InitGridInci() {
        var frozenColumns = [
            [
                {
                    checkbox: true,
                    field: 'gCheck',
                    hidden: true
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'inci',
                    title: 'inci',
                    hidden: true,
                    width: 150
                },
                {
                    field: 'warnInfo', // 背景色+showTip
                    title: '提醒',
                    width: 100,
                    styler: function (value) {
                        if (value !== '') {
                            return { class: 'phaip-datagrid-warn-normal' };
                        }
                    }
                },
                {
                    field: 'formDesc',
                    title: '剂型',
                    width: 100
                },
                {
                    field: 'inciCode',
                    title: '药品代码',
                    width: 100
                },
                {
                    field: 'inciDesc',
                    title: '药品名称',
                    width: 200,
                    showTip: true
                },
                {
                    field: 'qty',
                    title: '数量',
                    width: 50,
                    align: 'right'
                },
                {
                    field: 'uomDesc',
                    title: '单位',
                    width: 50,
                    align: 'center'
                },
                {
                    field: 'spec',
                    title: '规格',
                    width: 100
                },
                {
                    field: 'manfDesc', // 一般前几个字就够用了, 因此宽度100
                    title: '生产企业',
                    width: 100
                },
                {
                    field: 'bedNoStr',
                    title: '数量 / 床号',
                    width: 200,
                    showTip: true
                },
                {
                    field: 'sp',
                    title: '售价',
                    width: 100,
                    align: 'right'
                },
                {
                    field: 'spAmt',
                    title: '售价金额',
                    width: 100,
                    align: 'right'
                },
                {
                    field: 'insuCode',
                    title: '国家医保编码',
                    width: 100
                },
                {
                    field: 'insuDesc',
                    title: '国家医保名称',
                    width: 100
                },
                {
                    field: 'stkBinDesc',
                    title: '货位'
                },
                {
                    field: 'dspStr',
                    title: 'dspStr',
                    width: 100,
                    hidden: true
                }
            ]
        ];
        // todo 对于名称有必要修改下格式,不需要使用滚动条就能看全
        var dataGridOption = {
            url: null,
            exportXls: false,
            toolbar: '#gridInciBar',
            frozenColumns: frozenColumns,
            singleSelect: true,
            columns: columns,
            exportXls: false,
            pageList: [999999],
            pageSize: 999999,
            pagination: true,
            showPageList: false,
            rownumbers: true,
            onLoadSuccess: function (data) {
                if (data.rows.length > 0) {
                    $('#gridInciBar div').hide();
                } else {
                    $('#gridInciBar div').show();
                }
            }
        };
        PHA.Grid('gridInci', dataGridOption);
    }

    function InitGridOrder() {
        var frozenColumns = [
            [
                {
                    field: 'oeoreChk',
                    checkbox: true
                }
            ]
        ];
        var columns = [
            [
                {
                    field: 'warnInfo',
                    title: '提醒',
                    width: 100,
                    styler: function (value) {
                        if (value !== '') {
                            return { class: 'phaip-datagrid-warn-normal' };
                        }
                    }
                },
                {
                    field: 'dspStr',
                    title: 'dspStr',
                    width: 50,
                    hidden: true
                },

                {
                    field: 'docLocDesc',
                    title: '开单科室',
                    width: 100
                },
                {
                    field: 'bedNo',
                    title: '床号',
                    width: 60,
                    hidden: true
                },
                {
                    field: 'patNo',
                    title: '登记号',
                    width: 100,
                    hidden: true
                    //                    ,
                    //                    formatter: function (value, row, index) {
                    //                        return '<a class="pha-grid-a js-grid-patNo">' + value + '</a>';
                    //                    }
                },
                {
                    field: 'patName',
                    title: '姓名',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'age',
                    title: '年龄',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'sex',
                    title: '性别',
                    width: 50,
                    hidden: true
                },
                {
                    field: 'orderLinkSign',
                    title: '组',
                    width: 30,
                    formatter: function (value) {
                        return PHAIP_COM.OrderLinkSign(value);
                    }
                },
                {
                    field: 'inciDesc',
                    title: '药品名称',
                    width: 200,
                    formatter: function (value, rowData, rowIndex) {
                        var pre = '';
                        if (rowData.skinTestDesc !== '') {
                            if (rowData.skinTestValue == -1) {
                                pre = '<span style="color:red;padding-right:0.5rem;">' + rowData.skinTestDesc + '</span>';
                            } else {
                                pre = '<span style="padding-right:0.5rem;">' + rowData.skinTestDesc + '</span>';
                            }
                        }
                        return pre + value;
                    }
                },
                {
                    field: 'qty',
                    title: '数量',
                    width: 50,
                    align: 'right'
                },
                {
                    field: 'uomDesc',
                    title: '单位',
                    width: 50
                },
                {
                    field: 'dosage',
                    title: '剂量',
                    width: 100
                },
                {
                    field: 'doseDate',
                    title: '用药日期',
                    width: 70,
                    align: 'center'
                },
                {
                    field: 'doseTimeStr',
                    title: '用药时间',
                    width: 130
                },
                {
                    field: 'freqDesc',
                    title: '频次',
                    width: 75
                },
                {
                    field: 'priDesc',
                    title: '医嘱类型',
                    width: 75,
                    align: 'center'
                },
                {
                    field: 'oeoriRemark',
                    title: '医嘱备注',
                    width: 75,
                    showTip: true
                },
                {
                    field: 'instrucDesc',
                    title: '用法',
                    width: 75
                },
                {
                    field: 'duraDesc',
                    title: '疗程',
                    width: 75
                },
                {
                    field: 'oeoriStatDesc',
                    title: '医嘱状态',
                    width: 75
                },
                {
                    field: 'diagDesc',
                    title: '诊断',
                    width: 150,
                    showTip: true
                },

                {
                    field: 'oeoriDateTime',
                    title: '开单时间',
                    width: 155
                },
                {
                    field: 'manfDesc',
                    title: '生产企业',
                    width: 100
                },
                {
                    field: 'oeori',
                    title: '医嘱ID',
                    width: 100,
                    formatter: function (value, row, index) {
                        return '<a class="pha-grid-a">' + value + '</a>';
                    }
                },
                {
                    field: 'inciCode',
                    title: '药品代码',
                    width: 100,
                    formatter: function (value, row, index) {
                        return '<a class="pha-grid-a">' + value + '</a>';
                    }
                },
                {
                    field: 'sameFlag',
                    title: 'sameFlag',
                    width: 70,
                    hidden: true,
                    styler: function (value, row, index) {
                        if (value === 'Y') {
                            return {
                                class: 'pha-ip-person-toggle'
                            };
                        }
                    }
                },
                {
                    field: 'sortIndex',
                    title: 'sortIndex',
                    width: 100,
                    hidden: true
                }
            ]
        ];

        var dataGridOption = {
            toolbar: '#gridOrderBar',
            singleSelect: false,
            url: '',
            exportXls: false,
            pagination: true,
            frozenColumns: frozenColumns,
            loadFilter: PHAIP_COM.LocalFilterGroup,
            columns: columns,
            linkField: 'sortIndex',
            rownumbers: false,
            view: groupview,
            groupField: 'adm',
            groupFormatter: function (value, rows) {
                var rowData = rows[0];
                var divArr = [];
                divArr.push('<div class="pha-ip-disp-order-group">');
                divArr.push('   <div style="width:100px;" class="pha-tips-group">');
                if (rowData.oweInfo !== '') {
                    divArr.push('   <div class="pha-tips pha-tips-owe">欠费</div>');
                }
                divArr.push('   　</div>');
                divArr.push('   <div style="min-width:50px;">' + rowData.bedNo + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div class="pha-ip-disp-order-patNo"><a style="cursor:pointer;">' + rowData.patNo + '</a></div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div style="min-width:100px;">' + rowData.patName + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div style="min-width:20px;">' + rowData.sex + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div style="min-width:20px;">' + rowData.age + '</div>');
                divArr.push('   <div style="padding:0px 10px;"> / </div>');
                divArr.push('   <div style="text-overflow:ellipsis;max-width:1000px">' + rowData.admDiagDesc + '</div>');
                divArr.push('</div>');
                return divArr.join('');
            },
            onLoadSuccess: function (data) {
                $(this).datagrid('loaded');

                DestroyTooltip();
                var $grid = $(this);
                $grid.datagrid('options').checking = true;
                var row0Data = data.rows[0];
                if (row0Data) {
                    $grid.datagrid('uncheckAll');
                    var rows = $grid.datagrid('getRows');
                    var rowsLen = rows.length;
                    for (var index = rowsLen - 1; index >= 0; index--) {
                        var rowData = rows[index];
                        var check = rowData.check;
                        if (check === 'Y') {
                            $grid.datagrid('checkRow', index);
                        }
                    }
                } else {
                    $grid.datagrid('uncheckAll');
                }
                $grid.datagrid('scrollTo', 0);
                $grid.datagrid('options').checking = '';
                PHA_IP_DISP.OrderSameRowsHanlder.Hide();
                BindGridEvents();
                // $('#gridOrder').datagrid('clear');
            },
            onCheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                PHAIP_COM.DataGridLinkCheck($(this), 'checkRow', rowIndex, rowData, function (i, data) {
                    $('#gridOrder').datagrid('updateRow', {
                        index: i,
                        row: { check: 'Y' }
                    });
                    BindGridEvents();
                    if (data.sameFlag === 'Y') {
                        PHA_IP_DISP.OrderSameRowsHanlder.HideRow(i);
                    }
                });
            },
            onUncheck: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                PHAIP_COM.DataGridLinkCheck($(this), 'uncheckRow', rowIndex, rowData, function (i, data) {
                    $('#gridOrder').datagrid('updateRow', {
                        index: i,
                        row: { check: 'N' }
                    });
                    BindGridEvents();
                    if (data.sameFlag === 'Y') {
                        PHA_IP_DISP.OrderSameRowsHanlder.HideRow(i);
                    }
                });
            },
            onSelect: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                if (rowData.sameFlag === 'Y') {
                    PHA_IP_DISP.OrderSameRowsHanlder.HideRow(rowIndex);
                }
            },
            onUnselect: function (rowIndex, rowData) {
                if ($(this).datagrid('options').checking == true) {
                    return;
                }
                if (rowData.sameFlag === 'Y') {
                    PHA_IP_DISP.OrderSameRowsHanlder.HideRow(rowIndex);
                }
            },
            onCheckAll: function (rows) {
                PHAIP_COM.PageCheckHandler($(this), 'Y');
            },
            onUncheckAll: function (rows) {
                PHAIP_COM.PageCheckHandler($(this), 'N');
            },
            onClickCell: function (rowIndex, field, value) {
                if (field === 'patNo' && value !== '') {
                    DestroyTooltip();
                    PHA_UX.AdmDetail({ modal: true }, { AdmId: $(this).datagrid('getRows')[rowIndex].adm });
                }
                if (field === 'oeori') {
                    DestroyTooltip();
                    PHA_UX.OrderDetail({ modal: true }, { Oeori: $(this).datagrid('getRows')[rowIndex].oeori });
                }
                if (field === 'inciCode') {
                    DestroyTooltip();
                    PHA_UX.DrugDetail({ modal: true }, { inci: $(this).datagrid('getRows')[rowIndex].inci });
                }
            }
        };
        PHA.Grid('gridOrder', dataGridOption);

        function BindGridEvents() {
            $('.pha-ip-disp-order-patNo').unbind();
            $('.pha-ip-disp-order-patNo').on('click', function () {
                var rowIndex = $($(event.target).closest('.datagrid-group').next().find('.datagrid-row')[0]).attr('datagrid-row-index');
                var rowData = $('#gridOrder').datagrid('getRows')[rowIndex];
                var adm = rowData.adm || '';
                if (adm === '') {
                    return;
                }
                PHA_UX.AdmDetail({ modal: true }, { AdmId: adm });
            });
            //            $('.pha-ip-disp-order-patNo').hover(function (e) {
            //                try{
            //                    $(e.target).tooltip('options')
            //                }catch(error){
            //                    var rowIndex = $($(event.target).closest('.datagrid-group').next().find('.datagrid-row')[0]).attr('datagrid-row-index');
            //                    var rowData = $('#gridOrder').datagrid('getRows')[rowIndex];
            //                    var tableArr = [];
            //                    tableArr.push('<table class="gridOrderTooltip" style="color:#fff">');
            //                    tableArr.push('<tr><td>登记号:</td><td>' + rowData.patNo + '</td></tr>');
            //                    tableArr.push('<tr><td>姓名:</td><td>' + rowData.patName + '</td></tr>');
            //                    tableArr.push('<tr><td>性别:</td><td>' + rowData.sex + '</td></tr>');
            //                    tableArr.push('<tr><td>年龄:</td><td>' + rowData.age + '</td></tr>');
            //                    tableArr.push('<tr><td>诊断:</td><td>' + rowData.admDiagDesc || '' + '</td></tr>');
            //                    tableArr.push('</table>');
            //                    $(e.target).tooltip({
            //                        content: tableArr.join(''),
            //                        showDelay: 500
            //                    })
            //                }finally{
            //
            //                 $(e.target).tooltip('show');;
            //                }
            //            });
        }
    }
    /**
     * 移除界面遗留的无绑定的tip, 当表格行updaterow后, 事件会消失, 需要删除已经显示的提示层, 否则只能刷新界面
     */
    function DestroyTooltip() {
        $('.gridOrderTooltip').closest('.tooltip').remove();
    }
    function GetQueryDetailCondition() {
        var pJson = PHA_COM.Condition('.qCondition', 'get');
        pJson.locDispCatStr = GetTakeLocCheckedData().join(';');
        pJson.loc = session['LOGON.CTLOCID'];
        pJson.localConfig = $('#localConfigFlag').checkbox('getValue') === true ? PHA_IP_DISP.LocalConfig : '';
        var tabCode = $('#tabsTotal').tabs('getSelected').panel('options').code;
        pJson.outOrderFlag = '';
        pJson.dispWay = 'WARDDISP';
        if (tabCode === 'loc') {
            pJson.dispWay = 'WARDDISP';
        } else if (tabCode === 'base') {
            pJson.dispWay = 'BASEDISP';
        } else if (tabCode === 'out') {
            pJson.outOrderFlag = 'Y';
        }
        return pJson;
    }
    function QueryDetail(qType) {
        qType = qType || '';
        if (qType === '') {
            $('#tabsDetail').tabs('select', 0);
        }
        var conditionStr;
        var tabCode = $('#tabsDetail').tabs('getSelected').panel('options').code;
        var pJson = GetQueryDetailCondition();

        var pJsonStr;
        if (tabCode === 'inci') {
            pJson.dspArr = GetDataCheckedDsp().join(',').split(',');
            pJsonStr = JSON.stringify(pJson);
            conditionStr = GetTargetCondition('#gridInci');
            if (qType === 'tabSelect' && conditionStr !== '' && conditionStr == pJsonStr) {
                return;
            }
            $('#gridInci').datagrid('options').url = PHA.$URL;
            $('#gridInci').datagrid('query', {
                pClassName: 'PHA.IP.Disp.Query',
                pMethodName: 'GetDispInciData',
                pJson: pJsonStr
            });
            SetTargetCondition('#gridInci', pJsonStr);
        } else {
            pJsonStr = JSON.stringify(pJson);
            conditionStr = GetTargetCondition('#gridOrder');
            if (qType === 'tabSelect' && conditionStr !== '' && conditionStr == pJsonStr) {
                return;
            }
            PHA_COM.LoadData(
                'gridOrder',
                {
                    pClassName: 'PHA.IP.Disp.Query',
                    pMethodName: 'GetDispOrderData',
                    pJson: pJsonStr
                },
                function () {}
            );

            SetTargetCondition('#gridOrder', pJsonStr);
        }
        return;
    }

    function QueryTakeLoc() {
        PHA.Loading('Show');
        $('#gridInci, #gridOrder').datagrid('loadData', { total: 0, rows: [] });
        setTimeout(function () {
            var pJson = PHA_COM.Condition('.qCondition', 'get');
            pJson.loc = session['LOGON.CTLOCID'];
            pJson.localConfig = $('#localConfigFlag').checkbox('getValue') === true ? PHA_IP_DISP.LocalConfig : '';
            var tabCode = $('#tabsTotal').tabs('getSelected').panel('options').code;
            pJson.outOrderFlag = '';
            if (tabCode === 'loc') {
                pJson.dispWay = 'WARDDISP';
                pJson.outOrderFlag = 'N';
                // @todo 出院带药列
                // $('#gridTakeLoc').datagrid()
            } else if (tabCode === 'base') {
                pJson.dispWay = 'BASEDISP';
            } else if (tabCode === 'out') {
                pJson.outOrderFlag = 'Y';
                pJson.dispWay = 'WARDDISP';
            }
            $('#gridTakeLoc').datagrid('options').url = PHA.$URL;
            $('#gridTakeLoc').datagrid('query', {
                pClassName: 'PHA.IP.Disp.Query',
                pMethodName: 'GetDispTakeLocData',
                pJson: JSON.stringify(pJson)
            });
            ClearChecked4AllGrid();
            PHA.Loading('Hide');
        }, 500);
    }
    function QueryAdm() {}
    function ClearChecked4AllGrid() {
        $('#gridTakeLoc').datagrid('clearChecked');
        $('#gridInci').datagrid('clearChecked');
        $('#gridOrder').datagrid('clearChecked');
    }

    function GetTargetCondition(target) {
        return $.data($(target)[0], 'condition');
    }
    function SetTargetCondition(target, condition) {
        $.data($(target)[0], 'condition', condition);
    }
    function GetCurrentLoc() {
        return session['LOGON.CTLOCID'];
    }
    function HandleRefuse() {
        var dspArr = GetCheckedDsp();
        if (dspArr.length === 0) {
            PHA.Popover({
                msg: '请先勾选需要处理的数据',
                type: 'info'
            });
            return;
        }
        $('#winRefuseReason').dialog('open');
    }
    function ExecuteRefuse() {
        PHA.Loading('Show');
        var saveArr = [];
        var checkRows = $('#gridOrder').datagrid('getChecked');
        for (var i = 0, length = checkRows.length; i < length; i++) {
            var dspStr = checkRows[i].dspStr.toString();
            var dspArr = dspStr.split(',');
            for (var j = 0, jLength = dspArr.length; j < jLength; j++) {
                var dsp = dspArr[j];
                saveArr.push({
                    dsp: dsp,
                    logonUser: session['LOGON.USERID'],
                    reason: PHA_IP_DISP.HandleVars.RefuseReason
                });
            }
        }
        $.cm(
            {
                ClassName: 'PHA.IP.Data.Api',
                MethodName: 'HandleInAll',
                pClassName: 'PHA.IP.Refuse.Biz',
                pMethodName: 'HandleSave',
                pJsonStr: JSON.stringify(saveArr)
            },
            function (retJson) {
                PHA.Loading('Hide');
                retJson.success = retJson.successFlag;
                if (retJson.successFlag !== 'Y') {
                    var msg = PHAIP_COM.DataApi.Msg(retJson);
                    PHA.Alert('提示', msg, 'warning');
                }
                QueryDetail();
            },
            function (retData) {
                PHA.Loading('Hide');
                PHA.Alert('提示', '访问异常' + retData, 'error');
            }
        );
    }
    function HandleDisp() {
        // 选中改数据
        var dspArr = GetDataCheckedDsp();
        if (dspArr.length === 0) {
            PHA.Popover({
                msg: '请先勾选需要发药的数据',
                type: 'info'
            });
            return;
        }
        var oldOk = $.messager.defaults.ok;
        var oldNo = $.messager.defaults.no;
        $.messager.defaults.ok = '发药并打印';
        $.messager.defaults.no = '仅发药';
        var btns = $.messager
            .confirm3('提示', '您确认发药吗?', function (r) {
                if (true === r) {
                    PHA_IP_DISP.HandleVars.NeedPrint = true;
                    if (PHA_IP_DISP.Config.needInputDispUser === 'Y' || PHA_IP_DISP.Config.needInputOperateUser === 'Y' || PHA_IP_DISP.Config.needInputCollateUser === 'Y') {
                        $('#winUserSelect').dialog('open');
                    } else {
                        ExecuteDisp();
                    }
                } else if (false === r) {
                    PHA_IP_DISP.HandleVars.NeedPrint = false;
                    if (PHA_IP_DISP.Config.needInputDispUser === 'Y' || PHA_IP_DISP.Config.needInputOperateUser === 'Y' || PHA_IP_DISP.Config.needInputCollateUser === 'Y') {
                        $('#winUserSelect').dialog('open');
                    } else {
                        ExecuteDisp();
                    }
                } else {
                }
                $.messager.defaults.ok = oldOk;
                $.messager.defaults.no = oldNo;
            })
            .children('div.messager-button');
        btns.children('a:eq(0)').focus();
    }
    // 执行发药 ExecuteDisp
    function ExecuteDisp() {
        var dspArr = GetDataCheckedDsp();
        if (dspArr.length === 0) {
            PHA.Popover({
                msg: '请先勾选需要发药数据',
                type: 'info'
            });
            return;
        }
        var valCondition = ValidateCondition();
        if (valCondition !== true) {
            PHA.Popover({
                msg: valCondition,
                type: 'info'
            });
            return;
        }
        var pid = SetGlobal4DspData(dspArr);
        if (pid === '') {
            return;
        }
        PHA_IP_DISP.HandleVars.Pid = pid;
        // 按病区走
        var checkedData = GetTakeLocCheckedData();
        TakeLocDispHandler(checkedData).Disp();
    }

    /// 发药前将预发药数据暂存, 之后需要前台按病区发药显示发药进度
    function SetGlobal4DspData(dspArr) {
        var newDspArr = dspArr.join(',').split(',');
        var ret = PHA.CM(
            {
                pClassName: 'PHA.IP.Disp.Api',
                pMethodName: 'SetDspGlobal4Disp',
                pJson: JSON.stringify({
                    dspArr: newDspArr,
                    loc: session['LOGON.CTLOCID']
                })
            },
            false
        );
        if (ret.msg !== '') {
            PHA.Alert('提示', ret.msg, 'error');
            return '';
        }
        return ret.data;
    }

    function GetTakeLocCheckedData() {
        var retArr = [];
        var checkRows = $('#gridTakeLoc').datagrid('getChecked');
        for (var i = 0, length = checkRows.length; i < length; i++) {
            var rowData = checkRows[i];
            var dispCats = '',
                dispCat;
            for (var catField in rowData) {
                if (catField.indexOf('dispcat-') >= 0) {
                    dispCat = catField.replace('dispcat-', '');
                    if (rowData[catField] === 'Y') {
                        dispCats = dispCats === '' ? dispCat : dispCats + ',' + dispCat;
                    }
                }
            }
            retArr.push(rowData.takeLocID + ',' + rowData.takeLocDesc + ':' + dispCats);
        }
        console.log(retArr);
        return retArr;
    }
    // setTimeout(CopyAsCondition, 1000);
    // // 通过表格明细的宽度等因素复制一份勾选?
    // function CopyAsCondition() {
    //     var conTable = [];
    //     conTable.push('<table style="table-layout:fixed;width:350px"><tr>')
    //     var tds = $('#gridTakeLoc').parent().find('.gridTakeLoc-header-row0').find('td');
    //     for (var i = 0, length = tds.length; i < length; i++) {
    //         var iTD = tds[i];
    //         var $iID = $(iTD)
    //         conTable.push('<td style="width:'+$iID.width()+'px;text-align:center;"><input type="checkbox" class="hisui-checkbox"></td>')

    //     }
    //     conTable.push('</tr></table>')
    //     $('#gridTakeLocBar').html(conTable.join(''))
    //     $('#gridTakeLocBar input').checkbox({})
    //     // $($('#gridTakeLoc').parent().find('.gridTakeLoc-header-row0').find('td')[4]).width();
    //     // $($('#gridTakeLoc').parent().find('.gridTakeLoc-header-row0').find('td')[4]).attr('field');
    // }

    function MultiCheckDispCat(catsArr) {}

    function GetCheckedInci() {
        var retArr = [];
        var checkRows = $('#gridInci').datagrid('getChecked');
        for (var i = 0, length = checkRows.length; i < length; i++) {
            retArr.push(checkRows[i].inci);
        }
        return retArr;
    }
    function GetCheckedDsp() {
        var retArr = [];
        var checkRows = $('#gridOrder').datagrid('getChecked');
        for (var i = 0, length = checkRows.length; i < length; i++) {
            retArr.push(checkRows[i].dspStr);
        }
        return retArr;
    }
    function GetDataCheckedDsp() {
        var dspArr = [];
        checkRows = $('#gridOrder').datagrid('getData').originalRows;
        for (var j = 0, j_length = checkRows.length; j < j_length; j++) {
            var rowData = checkRows[j];
            if (rowData.check !== 'Y') {
                continue;
            }
            dspArr.push(rowData.dspStr);
        }
        return dspArr;
    }
    function ValidateCondition() {
        var tabCode = $('#tabsDetail').tabs('getSelected').panel('options').code;
        var pJsonStr = JSON.stringify(GetQueryDetailCondition());
        if (tabCode === 'inci') {
            if (GetTargetCondition('#gridInci') !== pJsonStr) {
                return '药品汇总数据与左侧查询条件不一致';
            }
        } else if (tabCode === 'order') {
            if (GetTargetCondition('#gridOrder') !== pJsonStr) {
                return '医嘱明细数据与左侧查询条件不一致';
            }
        }
        return true;
    }
    function GetLoc() {
        return session['LOGON.CTLOCID'];
    }
    function TakeLocDispHandler(rows) {
        var _rows = rows;
        var _rowsLen = _rows.length;
        var _currentIndex = 0;
        var _resultArr = [];
        function Disp() {
            if (_rowsLen === 0) {
                return;
            }
            var rowData = _rows[_currentIndex];
            var logonUser = session['LOGON.USERID'];
            var pJson = {
                takeLocData: rowData,
                loc: GetLoc(),
                logonUser: logonUser,
                dispWay: 'WARDDISP',
                collectUser: PHA_IP_DISP.HandleVars.DispUser || logonUser,
                collateUser: PHA_IP_DISP.HandleVars.DispCollateUser || logonUser,
                operateUser: PHA_IP_DISP.HandleVars.DispOperateUser || logonUser
            };
            var tabCode = $('#tabsTotal').tabs('getSelected').panel('options').code;
            if (tabCode === 'base') {
                pJson.dispWay = 'BASEDISP';
            }
            var takeLocInfo = rowData.split(':')[0].split(',')[1];
            $.messager.progress('close');
            $.messager.progress({
                title: '温馨提示',
                msg: '<div style="text-align:center;padding-bottom:15px;">' + takeLocInfo + '</div>',
                text: '处理发药中......'
            });
            PHA.CM(
                {
                    pClassName: 'PHA.IP.Disp.Api',
                    pMethodName: 'HandleDisp',
                    pid: PHA_IP_DISP.HandleVars.Pid,
                    pJson: JSON.stringify(pJson)
                },
                function (retData) {
                    _currentIndex++;
                    _resultArr.push({
                        condition: rowData,
                        result: retData
                    });

                    if (_currentIndex >= _rowsLen) {
                        $.messager.progress('close');
                        // 发药完成
                        AfterDispHandler(_resultArr);
                        return;
                    } else {
                        Disp();
                    }
                },
                function () {
                    _currentIndex++;
                    if (_currentIndex >= _rowsLen) {
                        $.messager.progress('close');
                        // 发药完成
                        AfterDispHandler(_resultArr);
                        return;
                    } else {
                        Disp();
                    }
                }
            );
        }
        return {
            Disp: Disp
        };
    }
    function AfterDispHandler(resultArr) {
        tkMakeServerCall('PHA.IP.Disp.Api', 'KillDspGlobal4Disp', PHA_IP_DISP.HandleVars.Pid);
        var phacIDArr = [];
        var msgArr = [];
        var msgStr;
        var data;
        for (var i = 0, length = resultArr.length; i < length; i++) {
            var iData = resultArr[i];
            var iDataResult = iData.result;
            if (iDataResult.success !== undefined && iDataResult.success === 0) {
                msgStr = iDataResult.msg;
                if (msgArr.indexOf(msgStr) < 0) {
                    msgArr.push(msgStr);
                }
            } else {
                data = iDataResult.data || '';
                if (data !== '') {
                    phacIDArr.push(data);
                }
                msgStr = iDataResult.msg || '';
                if (msgStr !== '') {
                    if (msgArr.indexOf(msgStr) < 0) {
                        msgArr.push(msgStr);
                    }
                }
            }
        }
        if (phacIDArr.length > 0) {
            phacIDArr = phacIDArr.join(',').split(','); // phacIDArr中一个元素可能是几个发药单
        }
        if (phacIDArr.length === 0) {
            var msgInfo = '没有发出药品';
            if (msgArr.length > 0) {
                msgInfo = '没有发出药品, 原因如下：</br>' + msgArr.join('</br>');
            }
            PHA.Alert('提示', msgInfo, 'warning');
        } else {
            var phacIDStr = phacIDArr.join(',');
            PHA_COM.SaveCACert({
                signVal: phacIDStr,
                type: 'P'
            });
            // 冲减
            ExecuteReserve(phacIDArr);
            // 打印
            if (PHA_IP_DISP.HandleVars.NeedPrint === true) {
                PrintReport(phacIDArr);
            }
            // 发药机
            Send2Machine(phacIDArr);
            if (msgArr.length > 0) {
                PHA.Alert('提示', '部分未发药，原因如下：</br>' + msgArr.join('</br>'), 'warning');
                $('#btnRefresh').click();
            } else {
                $('#btnFind').click();
            }
        }
    }
    // 调用发药
    function Send2Machine(phacIDArr) {
        if (PHA_IP_DISP.Config.sendMachineFlag !== 'Y') {
            return '';
        }
        PHA.Alert('提示', '包药机需要联调软件接口, 请协调相关开发人员调试', 'info');

        return '';
        var ret = PHA.CM(
            {
                pClassName: 'PHA.IP.Disp.Api',
                pMethodName: 'Send2Machine',
                pJson: JSON.stringify({
                    phacIDArr: phacIDArr
                })
            },
            false
        );
        return ret;
    }
    // 调用冲减
    function ExecuteReserve(phacIDArr) {
        var resFlag = $('#resFlag').checkbox('getValue') === true ? 'Y' : 'N';
        var ret = PHA.CM(
            {
                pClassName: 'PHA.IP.Disp.Api',
                pMethodName: 'ExecuteReserve',
                pJson: JSON.stringify({
                    phacIDArr: phacIDArr,
                    user: session['LOGON.USERID'],
                    resFlag: $('#resFlag').checkbox('getValue') === true ? 'Y' : 'N'
                })
            },
            false
        );
        return ret;
    }
    function PrintReport(phacIDArr) {
        IPPRINTCOM.Print({
            phacStr: phacIDArr.join('^'),
            otherStr: '',
            printType: '',
            reprintFlag: 'N',
            pid: '' // pid仅仅用于打印库存不足单据, 新版不在使用此逻辑, 库存不足存表
        });
    }
    function HandleClean() {
        PHA_COM.Condition('.qCondition', 'clear');
        $('#gridTakeLoc').datagrid('clear');
        $('#gridOrder').datagrid('clear');
        $('#gridInci').datagrid('clear');
        PHA.SetVals(PHA_IP_DISP.DefaultData);
    }
    function NeedAutoFind() {
        return $('#autoFindFlag').checkbox('getValue');
    }
    /**
     * 重置日期时间, 基数药的一般要求单独配置
     */
    function ResetDateTime() {
        var tabCode = $('#tabsTotal').tabs('getSelected').panel('options').code;
        var defaultData = PHA_IP_DISP.DefaultData[0];
        $('#startDate').datebox('setValue', tabCode !== 'base' ? defaultData.startDate : defaultData.baseStartDate);
        $('#endDate').datebox('setValue', tabCode !== 'base' ? defaultData.endDate : defaultData.baseEndDate);
        $('#startTime').timespinner('setValue', tabCode !== 'base' ? defaultData.startTime : defaultData.baseStartTime);
        $('#endTime').timespinner('setValue', tabCode !== 'base' ? defaultData.endTime : defaultData.baseEndTime);
    }
    setTimeout(function () {
        QueryTakeLoc();
    }, 110);
});