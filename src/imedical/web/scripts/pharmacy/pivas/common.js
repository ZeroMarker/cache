/**
 * creator:		yunhaibao
 * createdate:	2017-12-01
 * description: 静配给予jquery+easyUI的一些公共方法
 * common.js
 */

var PIVASTIPSTIMER = '';
var PIVAS = {
    Session: {
        More: function (_locId) {
            $.cm(
                {
                    ClassName: 'web.DHCSTPIVAS.Settings',
                    MethodName: 'LogonData',
                    locId: _locId
                },
                function (jsonData) {
                    PIVAS.Session.HOSPDESC = jsonData.HOSPDESC;
                    PIVAS.Session.CTLOCDESC = jsonData.CTLOCDESC;
                }
            );
        },
        HOSPDESC: '',
        CTLOCDESC: ''
    },
    VAR: {},
    URL: {
        COMMON: 'DHCST.PIVAS.ACTION.csp',
        MAINTAIN: 'DHCST.PIVAS.MAINTAIN.ACTION.csp'
    },
    // CSP入参分割字符
    Split: '|@|',
    // 登记号长度
    PatNoLength: function () {
        var patNoLen = tkMakeServerCall('web.DHCSTPIVAS.Common', 'PatRegNoLen');
        return patNoLen;
    },
    FmtPatNo: function (_no) {
        // 登记号处理
        if (_no.trim() == '') {
            return '';
        }
        var _len = this.PatNoLength();
        var _noLen = _no.length;
        if (_noLen > _len) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: '登记号错误',
                type: 'alert'
            });
            return _no;
        }
        var needLen = _len - _noLen;
        for (var i = 1; i <= needLen; i++) {
            _no = '0' + _no;
        }
        return _no;
    },
    // 补零
    PadZero: function (_no, _len) {
        if (_no.trim() == '') {
            return '';
        }
        var _noLen = _no.length;
        if (_noLen > _len) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: '长度大于需补齐的长度',
                type: 'alert'
            });
            return _no;
        }
        var needLen = _len - _noLen;
        for (var i = 1; i <= needLen; i++) {
            _no = '0' + _no;
        }
        return _no;
    },
    // 修改批次弹窗,仅弹窗,调用保存_callback
    UpdateBatNoWindow: function (_options, _callBack) {
        // _options.LocId	配液中心Id
        var winDivId = 'UpdateBatNoWindowDiv';
        var winDiv = '<div id="UpdateBatNoWindowDiv" style="padding:10px"><div id="gridBatNo"></div></div>';
        $('body').append(winDiv);
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                QueryName: 'PIVABatTime',
                inputParams: _options.LocId
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
                        title: '批次',
                        width: 300,
                        align: 'left'
                    }
                ]
            ],
            onClickRow: function (index, rowData) {
                $('#UpdateBatNoWindowDiv').window('close');
                // 回调
                if (_callBack) {
                    _callBack(rowData.Description);
                }
            }
        };
        DHCPHA_HUI_COM.Grid.Init('gridBatNo', dataGridOption);
        $('#UpdateBatNoWindowDiv').window({
            title: '选择批次',
            collapsible: false,
            iconCls: 'icon-w-list',
            border: false,
            closed: true,
            modal: true,
            width: 300,
            height: 400,
            onBeforeClose: function () {
                $('#UpdateBatNoWindowDiv').remove();
            }
        });
        $('#UpdateBatNoWindowDiv .datagrid-header').css('display', 'none');
        $("#UpdateBatNoWindowDiv [class='panel datagrid']").css({
            border: '#cccccc solid 1px',
            'border-radius': '4px'
        });
        $('#UpdateBatNoWindowDiv').window('open');
    },
    // 表格内修改批次公共
    UpdateBatNoCombo: function (_options) {
        // _options.LocId	配液中心Id
        // _options.MDspField	主打包Id所在列
        // _options.CurRowIndex
        // _options.GridId
        // _options.Field
        // _options.BatUp
        var batData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                QueryName: 'PIVALocBatNo',
                inputStr: _options.LocId,
                ResultSetType: 'array'
            },
            false
        );
        var gridCmbBatNo = {
            type: 'combobox',
            options: {
                valueField: 'batNo',
                textField: 'batNo',
                required: true,
                editable: false,
                data: batData,
                onLoadSuccess: function () {
                    $(this).combobox('showPanel');
                },
                onSelect: function (selData) {
                    var $_grid = $('#' + _options.GridId);
                    var batNo = selData.batNo;
                    var editIndex = $_grid.datagrid('options').editIndex;
                    var mDsp = $_grid.datagrid('getRows')[editIndex][_options.MDspField];
                    var updRet = tkMakeServerCall('web.DHCSTPIVAS.BatUpdate', 'UpdateBatch', mDsp, batNo, session['LOGON.USERID']);
                    var updArr = updRet.split('^');
                    if (updArr[0] < 0) {
                        $.messager.alert('提示', updArr[1], 'warning');
                        $_grid.datagrid('cancelEditRow', editIndex);
                        return;
                    }
                    setTimeout(function () {
                        $_grid.datagrid('endEdit', editIndex);
                        var updData = {};
                        var batUpField = _options.BatUp;
                        if (batUpField) {
                            updData.batUp = 'Y';
                        }
                        $_grid.datagrid('updateRow', {
                            index: editIndex,
                            row: updData
                        });
                    }, 100);
                }
            }
        };
        return gridCmbBatNo;
    },
    // 打包以及取消打包
    UpdateOeDspPack: function (_options) {
        // _options.CurRowIndex (不用了)
        // _options.GridId
        // _options.Field
        // _options.MDsp
        // _options.PackFlag(P:打包,空:取消打包)
        var mDsp = _options.MDsp;
        var packFlag = _options.PackFlag;
        if (mDsp == undefined || mDsp == '') {
            $.messager.alert('提示', '打包Id为空', 'warning');
            return;
        }
        if (packFlag != 'P' && packFlag != '') {
            $.messager.alert('提示', '打包状态错误,' + packFlag, 'warning');
            return;
        }
        var updRet = tkMakeServerCall('web.DHCSTPIVAS.DataHandler', 'UpdateOeDspToPack', mDsp, packFlag);
        var updArr = updRet.split('^');
        if (updArr[0] < 0) {
            $.messager.alert('提示', updArr[1], 'warning');
            return;
        }
        var $gridId = $('#' + _options.GridId);
        var gridSelections = $gridId.datagrid('getSelections');
        var rowIndex = $gridId.datagrid('getRowIndex', gridSelections[0]);
        $gridId.datagrid('updateRow', {
            index: rowIndex,
            row: {
                packFlag: packFlag
            }
        });
    },
    // 表格内修改打印方式公共
    PrtWayCombo: function (_options) {
        // _options.GridId
        // _options.Field
        var batData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                QueryName: 'PIVAPrtWay',
                ResultSetType: 'array'
            },
            false
        );
        var gridCmbPrtWay = {
            type: 'combobox',
            options: {
                valueField: 'RowId',
                textField: 'Description',
                required: true,
                editable: false,
                data: batData,
                onLoadSuccess: function () {
                    $(this).combobox('showPanel');
                },
                onSelect: function (selData) {
                    var $_grid = $('#' + _options.GridId);
                    var editIndex = $_grid.datagrid('options').editIndex;
                    setTimeout(function () {
                        $_grid.datagrid('endEditing');
                        $('#' + _options.GridId).datagrid('updateRow', {
                            index: editIndex,
                            row: {
                                prtWayId: selData.RowId,
                                prtWayDesc: selData.Description
                            }
                        });
                        $_grid.datagrid('checkRow', editIndex);
                    }, 100);
                }
            }
        };
        return gridCmbPrtWay;
    },
    // 配液拒绝原因窗口
    RefuseReasonWindow: function (_options, _callBack) {
        var winDivId = 'RefuseReasonWindowDiv';
        var winDiv = '<div id="RefuseReasonWindowDiv" style="padding:10px"><div id="gridRefuseReason"></div></div>';
        $('body').append(winDiv);
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'web.DHCSTPIVAS.OperReason',
                QueryName: 'GetOperReason',
                inputStr: 'Y',
                hosp: session['LOGON.HOSPID']
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
                        field: 'reasonId',
                        title: 'reasonId',
                        width: 80,
                        hidden: true
                    },
                    {
                        field: 'reasonDesc',
                        title: '配液拒绝原因',
                        width: 300,
                        align: 'left'
                    }
                ]
            ],
            onClickRow: function (index, rowData) {
                $.m(
                    {
                        ClassName: 'web.DHCSTPIVAS.Refuse',
                        MethodName: 'SaveData',
                        pogIdStr: _options.pogIdStr,
                        userId: _options.userId,
                        reasonId: rowData.reasonId,
                        exeType: 'R'
                    },
                    function (retData) {
                        var retArr = retData.split('^');
                        if (retArr[0] == -1) {
                            $.messager.alert('提示', retArr[1], 'warning');
                        } else if (retArr[0] < -1) {
                            $.messager.alert('提示', retArr[1], 'error');
                        }
                        _callBack();
                    }
                );
                // 掉后台
                $('#RefuseReasonWindowDiv').window('close');
            }
        };
        DHCPHA_HUI_COM.Grid.Init('gridRefuseReason', dataGridOption);
        $('#RefuseReasonWindowDiv').window({
            title: '配液拒绝原因',
            collapsible: false,
            iconCls: 'icon-w-list',
            border: false,
            closed: true,
            modal: true,
            width: 600,
            height: 400,
            onBeforeClose: function () {
                $('#RefuseReasonWindowDiv').remove();
            }
        });
        $('#RefuseReasonWindowDiv .datagrid-header').css('display', 'none');
        $("#RefuseReasonWindowDiv [class='panel datagrid']").css('border', '#cccccc solid 1px');
        $('#RefuseReasonWindowDiv').window('open');
    },
    // 创建批次checkbox
    BatchNoCheckList: function (_options) {
        // _options.LocId: 科室Id
        // _options.Id:	   绑定的div的Id
        // _options.Check: 默认是否勾选(true,false<默认>)
        // _option.Pack:   是否显示打包
        $.m(
            {
                ClassName: 'web.DHCSTPIVAS.Common',
                MethodName: 'PivasLocBatList',
                pivasLoc: _options.LocId
            },
            function (retData) {
                var chkHtml = '';
                if (retData == '') {
                    $('#' + _options.Id).html("<span style='color:#FF584C;font-weight:bold'>批　次　为　空　请　尽　快　维　护</span>");
                    return;
                }
                var retDataArr = retData.split('^');
                for (var i = 1; i <= retDataArr.length; i++) {
                    var batNoArr = retDataArr[i - 1].split(',');
                    var batId = batNoArr[0];
                    var batDesc = batNoArr[1];
                    var tmpHtml =
                        '<span style="margin-left:' +
                        (i == 1 ? 2 : 10) +
                        'px;"><input class="hisui-checkbox" id="' +
                        batId +
                        '"  name="batbox" type="checkbox" value=' +
                        batId +
                        ' text=' +
                        batDesc +
                        ' label=' +
                        batDesc +
                        '>' +
                        '</input></span>';
                    if (chkHtml == '') {
                        chkHtml = tmpHtml;
                    } else {
                        chkHtml = chkHtml + tmpHtml;
                    }
                }
                $('#' + _options.Id).append(chkHtml);
                $HUI.checkbox('#' + _options.Id + ' .hisui-checkbox', {
                    checked: _options.Check == true ? true : false
                }); // 重新渲染
                if (_options.Pack == true) {
                    var packHtml = '<span style="margin-left:10px;"><input class="hisui-checkbox" id="chkPivasPack" type="checkbox" label="打包"></input></span>';
                    $('#' + _options.Id).append(packHtml);
                    $HUI.checkbox('#chkPivasPack', {
                        checked: false
                    });
                }
                var chkAllHtml = '<span style="margin-left:10px;"><input class="hisui-checkbox" id="chkBatNoAll" type="checkbox" label="全选"></input></span>';
                $('#' + _options.Id).append(chkAllHtml);
                $HUI.checkbox('#chkBatNoAll', {
                    checked: true,
                    onCheckChange: function (e, value) {
                        $('input[type=checkbox][name=batbox]').checkbox('setValue', value);
                        if (value == false) {
                            $('#chkBatNoAll').next().text('全消');
                        } else {
                            $('#chkBatNoAll').next().text('全选');
                        }
                    }
                });
            }
        );
    },
    // 创建公共就诊列表
    // dhcstgrideu:scripts/dhcst/EasyUI/Plugins/dhcst.plugins.js
    InitGridAdm: function (_gOptions, _options) {
        // _gOptions.Id:表格Id
        // _options:grid options
        var columns = [
            [
                {
                    field: 'curWard',
                    title: '病区',
                    width: 100
                },
                {
                    field: 'curBed',
                    title: '床号',
                    width: 100
                },
                {
                    field: 'admDate',
                    title: '就诊日期',
                    width: 100
                },
                {
                    field: 'admTime',
                    title: '就诊时间',
                    width: 100
                },
                {
                    field: 'admLoc',
                    title: '就诊科室',
                    width: 100
                },
                {
                    field: 'patNo',
                    title: '登记号',
                    width: 90
                },
                {
                    field: 'curDoc',
                    title: '医生',
                    width: 100
                },
                {
                    field: 'curWardId',
                    title: '病区ID',
                    width: 100,
                    hidden: true
                },
                {
                    field: 'admId',
                    title: 'admId',
                    width: 60,
                    hidden: true
                }
            ]
        ];
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                QueryName: 'PaAdmByPatNo'
            },
            rownumbers: false,
            columns: columns,
            pagination: false,
            singleSelect: true
        };
        var pivaGridOptions = $.extend({}, dataGridOption, _options);
        DHCPHA_HUI_COM.Grid.Init(_gOptions.Id, pivaGridOptions);
    },
    // 初始化业务界面各种下拉列表
    // dhcstcomboeu:scripts/dhcst/EasyUI/Plugins/dhcst.plugins.js
    ComboBox: {
        Init: function (_cOptions, _options) {
            DHCPHA_HUI_COM.ComboBox.Init(_cOptions, _options, 'PIVAS');
        },
        // 设置选择第几条记录
        Select: function (_options) {
            //_options.Id
            //_options.Num
            var _id = _options.Id;
            var data = $('#' + _id).combobox('getData');
            if (data.length > 0) {
                $('#' + _id).combobox('select', data[_options.Num].RowId);
            }
        },
        // 配液大类
        PivaCat: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVAOrderLink',
            hosp: session['LOGON.HOSPID']
        },
        // 配液小类
        PHCPivaCat: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'DHCPHCPivaCat',
            hosp: session['LOGON.HOSPID']
        },
        // 配液科室
        PivaLoc: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVALoc',
            inputParams: session['LOGON.CTLOCID']
        },
        // 病区
        Ward: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PACWard',
            hosp: session['LOGON.HOSPID'],
            mode: 'remote'
        },
        // 用法
        Instruc: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PHCInstruc',
            mode: 'remote'
        },
        // 频次
        Freq: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PHCFreq',
            mode: 'remote'
        },
        // 配液批次
        Batch: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVABatTime',
            inputParams: session['LOGON.CTLOCID']
        },
        // 配液批次,batno
        PIVALocBatNo: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVALocBatNo',
            inputStr: session['LOGON.CTLOCID']
        },
        // 医嘱优先级
        Priority: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'OECPriority',
            mode: 'remote'
        },
        // 科室组
        LocGrp: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'DHCStkLocGroup',
            inputStr: session['LOGON.CTLOCID']
        },
        // 配液状态
        PIVAState: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVAState',
            inputStr: session['LOGON.CTLOCID']
        },
        // 配伍审核状态
        PassStat: {
            data: [
                {
                    RowId: 0,
                    Description: '全部'
                },
                {
                    RowId: 1,
                    Description: '未审核'
                },
                {
                    RowId: 2,
                    Description: '已审核'
                }
            ],
            panelHeight: 'auto'
        },
        // 配伍审核结果
        PassResult: {
            data: [
                {
                    RowId: '',
                    Description: '全部'
                },
                {
                    RowId: 'SHTG',
                    Description: '审核通过'
                },
                {
                    RowId: 'SHJJ',
                    Description: '审核拒绝'
                }
            ],
            panelHeight: 'auto'
        },
        // 护士审核状态
        NurseResult: {
            data: [
                {
                    RowId: '0',
                    Description: '未审核'
                },
                {
                    RowId: '1',
                    Description: '已审核'
                }
            ],
            panelHeight: 'auto'
        },
        // 医嘱/执行记录状态
        OrdStatus: {
            data: [
                {
                    RowId: '1',
                    Description: '正常'
                },
                {
                    RowId: '2',
                    Description: '停止'
                }
            ],
            panelHeight: 'auto'
        },
        // 扫描状态
        Scan: {
            data: [
                {
                    RowId: '1',
                    Description: '全部'
                },
                {
                    RowId: '2',
                    Description: '已扫描'
                },
                {
                    RowId: '3',
                    Description: '未扫描'
                }
            ],
            panelHeight: 'auto'
        },
        YesOrNo: {
            data: [
                {
                    RowId: 'Y',
                    Description: '是'
                },
                {
                    RowId: 'N',
                    Description: '否'
                }
            ],
            panelHeight: 'auto'
        },
        MoreOrLess: {
            data: [
                {
                    RowId: '>',
                    Description: '大于'
                },
                {
                    RowId: '<',
                    Description: '小于'
                }
            ],
            panelHeight: 'auto'
        },
        // 医生科室
        DocLoc: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'DocLoc',
            mode: 'remote',
            hosp: session['LOGON.HOSPID']
        },
        // 药房科室
        CTLoc: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'CTLoc',
            inputStr: session['LOGON.CTLOCID'] + '^' + 'D',
            mode: 'remote'
        },
        // 本科室人员
        LocUser: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'LocUser',
            inputStr: session['LOGON.CTLOCID'] + '^Y'
        },
        // 类组--不用
        StkCatGrp: {
            ClassName: 'web.DHCST.Util.DrugUtilQuery',
            QueryName: 'DHCStkCatGroup'
        },
        // 科室类组
        LocStkCatGrp: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'DHCStkLocCatGroup',
            inputStr: session['LOGON.CTLOCID']
        },
        // 库存分类
        StkCat: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'INCSCStkGrp',
            mode: 'remote'
        },
        // 成分字典
        Ingredient: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PHCIngredient'
        },
        // 拒绝原因维护类型
        ReasonType: {
            data: [
                {
                    RowId: 'R',
                    Description: '拒绝配液'
                }
            ]
            //data:[{"RowId":"C","Description":"取消"},{"RowId":"R","Description":"拒绝配液"},{"RowId":"P","Description":"审核拒绝"},{"RowId":"UNP","Description":"非正常打包"}]
        },
        // 流程维护类型
        IOType: {
            data: [
                {
                    RowId: 'I',
                    Description: '住院'
                },
                {
                    RowId: 'O',
                    Description: '门诊'
                }
            ]
        },
        // 配置台
        PIVAConfigTable: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVAConfigTable',
            inputStr: session['LOGON.CTLOCID']
        },
        // 工作组
        PIVAWorkType: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVAWorkType',
            inputStr: session['LOGON.CTLOCID']
        },
        // 打印方式
        PIVAPrtWay: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVAPrtWay'
        },
        // 班次类型
        PIVASchedulType: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVASchedulType'
        },
        // 班次字典
        PIVASchedul: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVASchedul'
        },
        // 小字典类型
        StkComDict: {
            data: [
                {
                    RowId: 'PivasLabelSign',
                    Description: '标签标识'
                },
                {
                    RowId: 'PivasStoreCon',
                    Description: '储存条件'
                }
            ]
        },
        // 主辅用药
        MedicalType: {
            data: [
                {
                    RowId: 'P',
                    Description: '主治用药'
                },
                {
                    RowId: 'A',
                    Description: '辅助用药'
                }
            ]
        },
        // 请假类型
        PIVALeaveType: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVALeaveType'
        },
        // 退药原因
        RetReason: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'RetReason',
            hosp: session['LOGON.HOSPID']
        },
        // 打包类型
        PackType: {
            data: [
                {
                    RowId: 'Y',
                    Description: '护士打包'
                },
                {
                    RowId: 'E',
                    Description: '补充打包'
                },
                {
                    RowId: 'P',
                    Description: '配液打包'
                },
                {
                    RowId: 'N',
                    Description: '非打包'
                }
            ],
            panelHeight: 'auto',
            multiple: true,
            editable: false
        },
        // 单位字典
        CtUom: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'CtUom'
        },
        // 配液收费设置的类型
        LinkOrdPack: {
            data: [
                {
                    RowId: 'A',
                    Description: '全部'
                },
                {
                    RowId: 'Y',
                    Description: '打包'
                },
                {
                    RowId: 'N',
                    Description: '配液'
                }
            ]
        },
        // 门诊住院类型
        SysType: {
            data: [
                {
                    RowId: 'A',
                    Description: '全部'
                },
                {
                    RowId: 'I',
                    Description: '住院'
                },
                {
                    RowId: 'O',
                    Description: '门诊'
                }
            ]
        },
        // 排批状态
        BatUpdateStat: {
            data: [
                {
                    RowId: 'A',
                    Description: '全部'
                },
                {
                    RowId: 'Y',
                    Description: '已排批'
                },
                {
                    RowId: 'N',
                    Description: '未排批'
                }
            ],
            panelHeight: 'auto'
        },
        // 打签状态
        PrtStat: {
            data: [
                {
                    RowId: 'A',
                    Description: '全部'
                },
                {
                    RowId: 'Y',
                    Description: '已打签'
                },
                {
                    RowId: 'N',
                    Description: '未打签'
                }
            ],
            panelHeight: 'auto'
        },
        // 单位字典
        DrugUom: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'DrugUom'
        }
    },
    GridComboBox: {
        Init: function (_cOptions, _options) {
            return DHCPHA_HUI_COM.GridComboBox.Init(_cOptions, _options, 'PIVAS');
        }
    },
    GridComboGrid: {
        Init: function (_cOptions, _options) {
            return DHCPHA_HUI_COM.GridComboGrid.Init(_cOptions, _options, 'PIVAS');
        }
    },
    // 初始化业务界面各种下拉Grid
    // dhcstcombogrideu:scripts/dhcst/EasyUI/Plugins/dhcst.plugins.js
    ComboGrid: {
        Init: function (_cOptions, _options) {
            DHCPHA_HUI_COM.ComboGrid.Init(_cOptions, _options, 'PIVAS');
        },
        // 库存项药品
        IncItm: {
            QueryParams: {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                QueryName: 'IncItm',
                inputParams: '',
                hosp: session['LOGON.HOSPID']
            },
            panelWidth: 750,
            columns: [
                [
                    {
                        field: 'incRowId',
                        title: 'incItmRowId',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'incCode',
                        title: '药品代码',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'incDesc',
                        title: '药品名称',
                        width: 400,
                        sortable: true
                    },
                    {
                        field: 'incSpec',
                        title: '规格',
                        width: 100,
                        sortable: true
                    }
                ]
            ],
            idField: 'incRowId',
            textField: 'incDesc',
            pageSize: 30,
            pageList: [30, 50, 100, 300, 500],
            pagination: true
        },
        // 医嘱项非药品
        ArcItmMast: {
            QueryParams: {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                QueryName: 'ArcItmMast'
            },
            panelWidth: 750,
            pageSize: 30, // 每页显示的记录条数
            pageList: [30, 50, 100, 300, 500], // 可以设置每页记录条数的列表
            columns: [
                [
                    {
                        field: 'arcItmId',
                        title: 'arcItmId',
                        width: 100,
                        sortable: true,
                        hidden: false
                    },
                    {
                        field: 'arcItmCode',
                        title: '医嘱项代码',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'arcItmDesc',
                        title: '医嘱项名称',
                        width: 400,
                        sortable: true
                    }
                ]
            ],
            idField: 'arcItmId',
            textField: 'arcItmDesc',
            pagination: true
        },
        // 流程字典
        PIVAStateNumber: {
            QueryParams: {
                ClassName: 'web.DHCSTPIVAS.ParaState',
                QueryName: 'StateNum'
            },
            panelWidth: 200,
            columns: [
                [
                    {
                        field: 'psRowId',
                        title: 'psRowId',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'psNumber',
                        title: '标识号',
                        width: 100,
                        sortable: true,
                        align: 'center',
                        halign: 'center'
                    },
                    {
                        field: 'psName',
                        title: '流程名称',
                        width: 100,
                        sortable: true,
                        align: 'center',
                        halign: 'center'
                    }
                ]
            ],
            idField: 'psNumber',
            textField: 'psName'
        }
    },
    // 初始化日期
    Date: {
        Init: function (_options) {
            //_options.Id:元素id
            //_options.DateT: t格式的日期(t为当日)
            var id = _options.Id;
            var dateT = _options.DateT;
            if (!dateT) {
                dateT = 't';
            }
            var retDate = tkMakeServerCall('web.DHCSTKUTIL', 'GetDate', '', '', dateT);
            $('#' + id).datebox('setValue', retDate);
        }
    },
    // 润乾背景
    RunQianBG: '../csp/dhcst.blank.backgroud.csp',
    // 拼接html用于前台显示
    Html: {
        // 指标公式维护
        IngredientButtons: function (_options) {
            //_options.Id // 添加到table的Id
            var HospId = _options.HospId || '';
            var btnsHtml = tkMakeServerCall('web.DHCSTPIVAS.Dictionary', 'PHCIngredientButtons', HospId);
            if (btnsHtml != '') {
                var btnsHtmlArr = btnsHtml.split('^');
                var btnsHtmlLen = btnsHtmlArr.length;
                var cacuTableHtml = '';
                for (var btnsI = 0; btnsI < btnsHtmlLen; btnsI++) {
                    var btnDesc = btnsHtmlArr[btnsI];
                    var btnHtml = '<div style="padding-top:5px;padding-left:5px;float:left"><a>' + btnDesc + '</a></div>';
                    cacuTableHtml = cacuTableHtml + btnHtml;
                }
                $('#' + _options.Id).empty();
                $('#' + _options.Id).append(cacuTableHtml);
                $('#' + _options.Id + ' a').linkbutton();
            }
        },
        /// confirm,拼接显示内容为table,整齐布局
        ConfirmInfo: function (_options) {
            /// _options.Data 用于分解的json数组
            var dataArr = _options.Data;
            var _confirmHtml = '<table>';
            for (var cI = 0; cI < dataArr.length; cI++) {
                var cData = dataArr[cI];
                var cHtml =
                    '<tr>' + '<td style="text-align:right;width:70px;border-left:2px solid #40A2DE;">' + cData.title + '</td>' + '<td style="font-weight:bold">' + cData.data + '</td>' + '</tr>';
                _confirmHtml = _confirmHtml + cHtml;
            }
            _confirmHtml = _confirmHtml + '</table>';
            return _confirmHtml;
        }
    },
    Grid: {
        /// grid单元格划过提示,以后封装
        CellTip: function (_options) {
            //_options.TipArr:需要提示的列id,数组
            //_options.ClassName:需要调取后台的类(不常用,可优化)
            //_options.MethodName:需要调取后台的方法
            //_options.TdField:需要获取前台某列的单元格值的field
            if ($('#tipRemark').length < 1) {
                var html = '<div id="tipRemark" style="border-radius:3px; display:none; border:1px solid #017BCE; padding:10px;position: absolute; background-color: white;color:black;"></div>';
                $('body').append(html);
            }
            var findConds = '.datagrid-btable ';
            var tipsArr = _options.TipArr;
            var arrLen = tipsArr.length;
            var tdConds = '';
            for (var i = 0; i < arrLen; i++) {
                tdConds = tdConds == '' ? "td[field='" + tipsArr[i] + "']" : tdConds + ',' + "td[field='" + tipsArr[i] + "']";
            }
            findConds = findConds + tdConds;
            $(findConds).each(function () {
                if (this.textContent != '') {
                    $(this).on({
                        mouseenter: function () {
                            // 连进有问题
                            if (typeof PIVASTIPSTIMER != 'undefined') {
                                clearTimeout(PIVASTIPSTIMER);
                            }
                            var tipInfo = this.textContent;
                            var thisEle = this;
                            var eX = event.clientX + 20;
                            var eY = event.clientY;
                            // 不用mousemove,mouseover,移动时调后台会频繁访问服务器
                            PIVASTIPSTIMER = setTimeout(function () {
                                if (_options.ClassName) {
                                    var inputStr = $(thisEle)
                                        .parent()
                                        .find('td[field=' + _options.TdField + ']')
                                        .text();
                                    tipInfo = tkMakeServerCall(_options.ClassName, _options.MethodName, inputStr);
                                } else if (_options.TdField) {
                                    tipInfo = $(thisEle)
                                        .parent()
                                        .find('td[field=' + _options.TdField + ']')
                                        .text();
                                }
                                if (tipInfo == '') {
                                    return;
                                }
                                $('#tipRemark')
                                    .css({
                                        display: 'block',
                                        bottom: document.body.clientHeight - eY + 'px',
                                        left: eX + 'px',
                                        'z-index': 9999,
                                        opacity: 1
                                    })
                                    .html(tipInfo);
                            }, 350);
                        },
                        mouseleave: function () {
                            if (typeof PIVASTIPSTIMER != 'undefined') {
                                clearTimeout(PIVASTIPSTIMER);
                            }
                            $('#tipRemark').css({
                                display: 'none'
                            });
                        }
                    });
                }
            });
        },
        // 关联勾选(比如:关联医嘱)
        LinkCheck: {
            Stat: '',
            Init: function (_options) {
                //_options.CurRowIndex:当前行
                //_options.GridId:表格Id
                //_options.Field: 列的Field值
                //_options.Check: true勾选,false不勾选
                //_options.Value: 键值
                //_options.Type:(Select-选择行,Check-勾选)
                if (this.Stat == '') {
                    this.Stat = 1;
                    var gridId = _options.GridId;
                    var field = _options.Field;
                    var check = _options.Check;
                    var value = _options.Value;
                    var type = _options.Type;
                    if (type == 'Select') {
                        // 清除所有选中,走样式处理
                        //$('#' + gridId).datagrid("unselectAll");
                        PIVAS.Grid.ClearSelections(gridId);
                    }
                    var gridRowsData = $('#' + gridId).datagrid('getRows');
                    var gridRowsCount = gridRowsData.length;
                    // 向下
                    var i = _options.CurRowIndex;
                    var tmpRowsCnt = i + 50;
                    for (i = _options.CurRowIndex; i < tmpRowsCnt; i++) {
                        var rowData = gridRowsData[i];
                        if (!rowData) {
                            break;
                        }
                        var iColValue = rowData[field];
                        if (iColValue == value) {
                            if (type == 'Select') {
                                $('#' + gridId).datagrid('selectRow', i);
                            } else {
                                $('#' + gridId).datagrid(check == true ? 'checkRow' : 'uncheckRow', i);
                            }
                        } else {
                            break;
                        }
                    }
                    // 向上
                    var i = _options.CurRowIndex;
                    for (i = _options.CurRowIndex; i >= 0; i--) {
                        var iColValue = gridRowsData[i][field];
                        if (iColValue == value) {
                            if (type == 'Select') {
                                $('#' + gridId).datagrid('selectRow', i);
                            } else {
                                $('#' + gridId).datagrid(check == true ? 'checkRow' : 'uncheckRow', i);
                            }
                        } else {
                            break;
                        }
                    }
                    this.Stat = '';
                }
            }
        },
        CSS: {
            NoStock: 'background-color:#8FC320;',
            SurgeryImg: '<img src="../images/webemr/手术（有手术医嘱的患者).png" border=0 height="12px"/>',
            Yes: '<img src="../scripts/pharmacy/common/image/yes.png"></img>',
            //Yes: '<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>',
            No: '<i class="fa fa-close" aria-hidden="true" style="color:#DD4F43;font-size:18px"></i>',
            PersonEven: 'background-color:#00A59D;', //509de1
            SignEven: 'color:red;',
            SignRowEven: 'background-color:#20BB44;',
            BatchPack: 'background-color:#17C3AC;', // 打包批次
            BatchUp: 'font-style:italic;', // 手工修改过批次
            BatchUpdated: 'background-color:rgb(64, 162, 222);', // 已排批
            CHNYes: "<font color='#21ba45'>是</font>",
            CHNNo: '<font color="#f16e57">否</font>'
        },
        Formatter: {
            OeoriSign: function (value, row, index) {
                if (value == '│' || value == '0') {
                    return '<div class="oeori-sign-c"></div>';
                } else if (value == '┍' || value == '-1') {
                    return '<div class="oeori-sign-t"></div>';
                } else if (value == '┕' || value == '1') {
                    return '<div class="oeori-sign-b"></div>';
                } else {
                    return value;
                }
            },
            DateTime: function (value, row, index) {
                if (value.indexOf('-') >= 0) {
                    var year = str.substring(0, 5);
                    return value.replace(year, '');
                } else if (value.indexOf('-') >= 0) {
                    var year = str.substring(5, 10);
                    return value.replace(year, '');
                } else {
                    return value;
                }
            }
        },
        Styler: {
            // grid中field:incDescStyle,json列太多会慢,合一起
            // 库存不足(Y)!!溶媒超包装(Y)!!剂量非整包装(Y)
            IncDesc: function (value, row, index) {
                var incStyle = row.incDescStyle;
                if (incStyle) {
                    var incStyleArr = incStyle.split('!!');
                    var style = '';
                    if (incStyleArr[0] == 'Y') {
                        // 库存不足
                        style += 'background-color:#17C3AC;';
                    }
                    if (incStyleArr[1] == 'Y') {
                        // 溶媒超包装
                        style += 'font-weight:bold;';
                    }
                    if (incStyleArr[2] == 'Y') {
                        // 剂量非整包装
                        style += 'border-bottom:1px solid black;';
                    }
                    return style;
                }
            },
            // 配液状态颜色
            PivaState: function (value, row, index) {
                switch (value) {
                    case '开医嘱':
                        colorStyle = 'background: #ee4f38;color:white;font-weight:bold;';
                        break;
                    case '护士审核':
                        colorStyle = 'background:#f58800;color:white;font-weight:bold;';
                        break;
                    case '配伍审核':
                        colorStyle = 'background:#f58800;color:white;font-weight:bold;';
                        break;
                    case '审核通过':
                        colorStyle = 'background:#f58800;color:white;font-weight:bold;';
                        break;
                    case '排批':
                        colorStyle = 'background:#f1c516;color:white;font-weight:bold;';
                        break;
                    case '打签':
                        colorStyle = 'background:#a4c703;color:white;font-weight:bold;';
                        break;
                    case '分签':
                        colorStyle = 'background:#51b80c;color:white;font-weight:bold;';
                        break;
                    case '排药':
                        colorStyle = 'background:#4b991b;color:white;font-weight:bold;';
                        break;
                    case '贴签':
                        colorStyle = 'background:#03ceb4;color:white;font-weight:bold;';
                        break;
                    case '核对':
                        colorStyle = 'background:#10b2c8;color:white;font-weight:bold;';
                        break;
                    case '配置':
                        colorStyle = 'background:#107cc8;color:white;font-weight:bold;';
                        break;
                    case '复核':
                        colorStyle = 'background:#1044c8;color:white;font-weight:bold;';
                        break;
                    case '装车':
                        colorStyle = 'background:#6557d3;color:white;font-weight:bold;';
                        break;
                    case '病区接收':
                        colorStyle = 'background:#a849cb;color:white;font-weight:bold;';
                        break;
                    case '开始输液':
                        colorStyle = 'background:#d773b0;color:white;font-weight:bold;';
                        break;
                    case '结束输液':
                        colorStyle = 'background:#77656b;color:white;font-weight:bold;';
                        break;
                    default:
                        colorStyle = 'background:white;color:black;font-weight:bold;';
                        break;
                }
                return colorStyle;
            }
        },
        RowStyler: {
            Person: function (index, rowData, field) {
                if (index == 0) {
                    PERSON_ALT = {
                        LastVal: '',
                        Cnt: 0,
                        Cls: {}
                    };
                }
                var fieldVal = rowData[field];
                if (fieldVal == '') {
                    // 登记号空,颜色同上一行
                    return PERSON_ALT.Cls;
                }
                if (fieldVal != PERSON_ALT.LastVal) {
                    PERSON_ALT.Cnt++;
                    if (PERSON_ALT.Cnt % 2 == 0) {
                        PERSON_ALT.Cls = {
                            class: 'datagrid-row-alt'
                        };
                    } else {
                        PERSON_ALT.Cls = {};
                    }
                }
                PERSON_ALT.LastVal = fieldVal;
                return PERSON_ALT.Cls;
            }
        },

        //不复杂直接用此即可,样式待修改
        WarnInfo: function () {
            var msghtml = '<div id="msgboxbox" style="display:none;position: absolute;width:200px;height:100px">一病房存在超时打签数据</div>';
            $('body').append(msghtml);
            $('#msgboxbox').css({
                background: '#3cbd88',
                color: 'white',
                display: 'block',
                bottom: '50px',
                right: '10px',
                'z-index': 9999,
                opacity: 0.8,
                transform: 'translateY(20%)',
                transition: 'all 1s'
            });
            setTimeout(function () {
                $('#msgboxbox').remove();
            }, 3000);
        },
        // 静配合计显示组数
        Pagination: function () {
            if ($.fn.pagination) {
                $.fn.pagination.defaults.displayMsg = '显示{from}到{to} 共{total}组';
            }
        },
        // 清除选择
        ClearSelections: function (gridId) {
            $('#' + gridId)
                .prev()
                .find('.datagrid-row')
                .removeClass('datagrid-row-selected');
            //			var $grid=$('#'+gridId);
            //			var rows=$grid.datagrid("getRows");
            //			$.each(rows, function (index, row) {
            //				var $row=$grid.prev().find(".datagrid-row[datagrid-row-index=" + index + "]");
            //				$row.removeClass("datagrid-row-selected")
            //			});
        }
    },
    FullScreen: function (ele) {
        if (!!window.ActiveXObject || 'ActiveXObject' in window) {
            if (window.screenTop != 0) {
                var WsShell = new ActiveXObject('WScript.Shell');
                WsShell.SendKeys('{F11}');
            }
        } else {
        }
    },
    // 遮罩层,打印\保存\导出
    Progress: {
        Show: function (_options) {
            var _text = '  数  据  处  理  中  ';
            var _type = _options.type;
            if (_type) {
                if (_type == 'save') {
                    _text = '  保  存  数  据  中';
                } else if (_type == 'print') {
                    _text = '  打  印  数  据  中';
                } else if (_type == 'export') {
                    _text = '  另  存  数  据  中';
                }
            }
            $.messager.progress({
                title: '请耐心等待...',
                text: _text,
                interval: _options.interval ? _options.interval : 1000
            });
        },
        Close: function () {
            $.messager.progress('close');
        }
    },
    // 声音,IE仅支持MP3
    Media: {
        Play: function (_msgType) {
            if (window.HTMLAudioElement) {
                audio = new Audio();
                if (_msgType != '') {
                    audio.src = '../scripts/pharmacy/common/audio/' + _msgType + '.mp3';
                } else {
                    audio.src = '';
                }
                audio.play();
            }
        },
        Stop: function () {}
    },
    // 选择单号窗体
    // _options.TargetId
    // _options.PivaLocId
    // _options.PsNumber
    PogsNoWindow: function (_options) {
        var winDivId = 'PogsNoWindowDiv';
        var winDiv = '<div id="PogsNoWindowDiv" style="padding:10px;"><div id="gridPogsNo"></div></div>';
        var gridPogsNoBar =
            '<div id="gridPogsNoBar">' +
            '<table><tr>' +
            '<td> <input id="datePogsNo" class="hisui-datebox" type="text" /></td>' +
            '<td> <input id="cmbPogsNoPsStat" type="text" /></td>' +
            '<td> <a class="hisui-linkbutton" plain="false" id="btnFindPogsNo" iconCls="icon-w-find">查询</a></td>' +
            '</tr></table>' +
            '</div>';
        $('body').append(winDiv);
        $('body').append(gridPogsNoBar);
        $('#btnFindPogsNo').linkbutton();
        $('#datePogsNo').datebox();
        $('#cmbPogsNoPsStat').combobox();
        this.Date.Init({
            Id: 'datePogsNo',
            LocId: '',
            Type: 'Start',
            QueryType: 'Query'
        });
        this.ComboBox.Init(
            {
                Id: 'cmbPogsNoPsStat',
                Type: 'PIVAState'
            },
            {
                editable: false,
                placeholder: '配液状态...',
                onLoadSuccess: function () {
                    $(this).combobox('setValue', _options.PsNumber);
                },
                onBeforeLoad: function (param) {
                    param.inputStr = _options.PivaLocId;
                    param.filterText = param.q;
                }
            }
        );
        $('#btnFindPogsNo').on('click', function () {
            var params = _options.PivaLocId + '^' + $('#cmbPogsNoPsStat').combobox('getValue') + '^' + $('#datePogsNo').datebox('getValue');
            $('#gridPogsNo').datagrid('query', {
                strParams: params
            });
        });
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                QueryName: 'PIVAOrdGrpState'
            },
            title: '',
            border: false,
            fitColumns: false,
            singleSelect: true,
            nowrap: false,
            striped: true,
            pagination: true,
            rownumbers: false,
            toolbar: '#gridPogsNoBar',
            columns: [
                [
                    {
                        field: 'psName',
                        title: '配液状态',
                        width: 100,
                        align: 'center'
                    },
                    {
                        field: 'pogsNo',
                        title: '单号',
                        width: 200,
                        align: 'center'
                    },
                    {
                        field: 'pogsDate',
                        title: '操作日期',
                        width: 100,
                        align: 'center'
                    },
                    {
                        field: 'pogsTime',
                        title: '操作时间',
                        width: 150,
                        align: 'center'
                    },
                    {
                        field: 'pogsUserName',
                        title: '操作人',
                        width: 125,
                        align: 'center'
                    }
                ]
            ],
            onDblClickRow: function (rowIndex, rowData) {
                $('#' + _options.TargetId).searchbox('setValue', rowData.pogsNo);
                $('#PogsNoWindowDiv').window('close');
            }
        };
        DHCPHA_HUI_COM.Grid.Init('gridPogsNo', dataGridOption);
        $('#PogsNoWindowDiv').window({
            title: ' 流程单据记录',
            collapsible: false,
            iconCls: 'icon-w-find',
            border: false,
            closed: true,
            modal: true,
            width: 900,
            height: 400,
            onBeforeClose: function () {
                $('#PogsNoWindowDiv').remove();
                $('#gridPogsNoBar').remove();
            }
        });

        $('#PogsNoWindowDiv').window('open');
        $("#PogsNoWindowDiv [class='panel datagrid']").css({
            border: '#cccccc solid 1px',
            'border-radius': '4px'
        });
    },
    // 查看收取的配置费的窗口
    OrdLinkWindow: function (_options) {
        var rowsData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.FeeQuery',
                QueryName: 'OrdGrpOrder',
                PogId: _options.Params
            },
            false
        );
        if (rowsData.rows.length == 0) {
            return;
        }
        var winDivId = 'OrdLinkWindowDiv';
        var winDiv = '<div id="OrdLinkWindowDiv" style="padding:10px"><div id="gridOrdLink"></div></div>';
        $('body').append(winDiv);
        var dataGridOption = {
            border: false,
            singleSelect: true,
            nowrap: false,
            striped: false,
            pagination: false,
            rownumbers: false,
            columns: [
                [
                    {
                        field: 'oeori',
                        title: 'oeori',
                        width: 80,
                        hidden: true
                    },
                    {
                        field: 'arcimDesc',
                        title: '医嘱名称',
                        width: 250,
                        align: 'left'
                    },
                    {
                        field: 'qty',
                        title: '数量',
                        width: 50,
                        align: 'right'
                    },
                    {
                        field: 'oeoriDateTime',
                        title: '操作时间',
                        width: 170
                    },
                    {
                        field: 'userName',
                        title: '操作人',
                        width: 80
                    },
                    {
                        field: 'oeoriStatDesc',
                        title: '医嘱状态',
                        width: 80
                    }
                ]
            ],
            onLoadSuccess: function () {}
        };
        DHCPHA_HUI_COM.Grid.Init('gridOrdLink', dataGridOption);
        $('#gridOrdLink').datagrid('loadData', rowsData);

        $('#OrdLinkWindowDiv').window({
            title: '配置费用',
            collapsible: false,
            iconCls: 'icon-w-inv',
            border: false,
            closed: true,
            modal: true,
            width: 670,
            height: 400,
            onBeforeClose: function () {
                $('#OrdLinkWindowDiv').remove();
            }
        });
        $("#OrdLinkWindowDiv [class='panel datagrid']").css({
            border: '#cccccc solid 1px',
            'border-radius': '4px'
        });
        $('#OrdLinkWindowDiv').window('open');
    },
    // 配伍审核记录
    AuditRecordWindow: function (_options) {
        var dateMOeori = _options.dateMOeori || '';
        if (dateMOeori == '') {
            return;
        }
        var winDivId = 'OeAuditWindowDiv';
        var winDiv = '<div id="OeAuditWindowDiv" style="padding:10px;"><div id="gridOeAuditRecord"></div></div>';
        $('body').append(winDiv);
        //定义表格
        var columns = [
            [
                {
                    field: 'passResult',
                    title: '审核状态',
                    width: 100,
                    styler: function (value, row, index) {
                        var valueStr = value.toString();
                        if (valueStr.indexOf('审核通过') >= 0) {
                            return 'background-color:#019BC1;color:white;'; //绿色
                        } else if (valueStr.indexOf('审核拒绝') >= 0) {
                            return 'background-color:#C33A30;color:white;'; //红色
                        } else if (valueStr.indexOf('医生申诉') >= 0) {
                            return 'background-color:#FFB63D;color:white;'; //浅黄色
                        }
                        if (valueStr.toString().indexOf('已取消')) {
                            return 'background-color:#C33A30;color:white;';
                        }
                    }
                },
                {
                    field: 'userName',
                    title: '操作人',
                    width: 90
                },
                {
                    field: 'dateTime',
                    title: '操作时间',
                    width: 155
                },
                {
                    field: 'reasonDesc',
                    title: '处理原因',
                    width: 250,
                    formatter: function (value, row, index) {
                        return '<div style="width=250px;word-break:break-all;word-wrap:break-word;white-space:pre-wrap;">' + value + '</div>';
                    }
                },
                {
                    field: 'docAgree',
                    title: '医生接受',
                    width: 70
                },
                {
                    field: 'docNotes',
                    title: '医生申诉',
                    width: 80
                },
                {
                    field: 'oeoriStat',
                    title: '医嘱状态',
                    width: 70
                },
                {
                    field: 'cancelUserName',
                    title: '取消人',
                    width: 90
                },
                {
                    field: 'cancelDateTime',
                    title: '取消时间',
                    width: 155
                }
            ]
        ];
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'web.DHCSTPIVAS.OeAudit',
                QueryName: 'OeAuditRecord',
                dateMOeori: dateMOeori
            },
            fit: true,
            rownumbers: false,
            columns: columns,
            pagination: false,
            singleSelect: true,
            nowrap: false
        };
        DHCPHA_HUI_COM.Grid.Init('gridOeAuditRecord', dataGridOption);
        $('#OeAuditWindowDiv').window({
            title: ' 配伍审核记录',
            collapsible: false,
            iconCls: 'icon-w-paper',
            border: false,
            closed: true,
            modal: true,
            width: 1100,
            height: 500,
            onBeforeClose: function () {
                $('#OeAuditWindowDiv').remove();
            }
        });
        $('#OeAuditWindowDiv').window('open');
        $("#OeAuditWindowDiv [class='panel datagrid']").css({
            border: '#cccccc solid 1px',
            'border-radius': '4px'
        });
    },
    GeneQRCodeWindow: function (_options) {
        var barCode = _options.barCode;
        var winId = 'PIVAS_UX_BarCode';
        var html = '';
        html += '<div id=' + winId + ' style="padding:20px;text-align:center">';
        html += '<div id="PIVAS_UX_BarCode_QR" style="padding-left:30px"></div>';
        html += '<div style="position:absolute;bottom:5px;"><div style="width:260px;text-align:center;font-weight:bold;">' + barCode + '</div></div>';
        html += '</div>';
        $('body').append(html);
        $('#' + winId)
            .window({
                title: ' 二维码',
                collapsible: false,
                iconCls: 'icon-gen-barcode',
                border: false,
                closed: false,
                modal: true,
                width: 300,
                height: 300,
                minimizable: false,
                maximizable: false,
                onClose: function () {
                    $(this).window('destroy');
                }
            })
            .window('open');

        var qrcode = new QRCode(document.getElementById('PIVAS_UX_BarCode_QR'), {
            text: barCode,
            width: 200,
            height: 200,
            colorDark: '#000000',
            colorLight: '#ffffff',
            correctLevel: QRCode.CorrectLevel.H
        });
    },
    // 病历浏览窗口
    ViewEMRWindow: function (_winOpts, _admId) {
        var winId = 'PIVAS_UX_ViewEMR';
        if (($('#' + winId).html() || '') == '') {
            var diagHtml = '';
            diagHtml += '<div id="' + winId + '" class="hisui-dialog"  title="病历浏览">';
            diagHtml += '   <div class="hisui-layout" fit="true" border="false">';
            diagHtml += '       <div data-options=\'region:"center"\' border="false">';
            diagHtml += '           <div class="hisui-layout" fit="true" border="false">';
            diagHtml += '               <div id="' + winId + '-lyWinCen' + '" data-options=\'region:"center",split:true,headerCls:"panel-header-gray"\' border="false">';
            diagHtml += '                   <div class="hisui-tabs tabs-gray" fit="true" id="' + winId + '-tabsEMR">';
            diagHtml += '                       <div data-options=\'title:"病历浏览"\'>';
            diagHtml += '                           <iframe id="' + winId + '-ifrmEMR" style="display:block;width:100%;"></iframe>';
            diagHtml += '                       </div>';
            diagHtml += '                       <div data-options=\'title:"过敏记录"\'>';
            diagHtml += '                           <iframe id="' + winId + '-ifrmAllergy" style="display:block;width:100%;"></iframe>';
            diagHtml += '                       </div>';
            diagHtml += '                       <div data-options=\'title:"检查记录"\'>';
            diagHtml += '                           <iframe id="' + winId + '-ifrmRisQuery" style="display:block;width:100%;"></iframe>';
            diagHtml += '                       </div>';
            diagHtml += '                       <div data-options=\'title:"检验记录"\'>';
            diagHtml += '                           <iframe id="' + winId + '-ifrmLisQuery" style="display:block;width:100%;"></iframe>';
            diagHtml += '                       </div>';
            diagHtml += '                       <div data-options=\'title:"本次医嘱"\'>';
            diagHtml += '                           <iframe id="' + winId + '-ifrmOrdQuery" style="display:block;width:100%;"></iframe>';
            diagHtml += '                       </div>';
            diagHtml += '                   </div>';
            diagHtml += '               </div>';
            diagHtml += '           </div>';
            diagHtml += '       </div>';
            diagHtml += '   </div>';
            diagHtml += '</div>';
            $('body').append(diagHtml);

            $.parser.parse($('#' + winId));
            var wWidth = document.body.clientWidth * 0.9;
            var wHeight = document.body.clientHeight * 0.9;
            $('#' + winId).dialog({
                closable: true,
                modal: true,
                closed: true,
                collapsible: false,
                resizable: true,
                cache: false,
                iconCls: 'icon-w-list',
                width: wWidth,
                height: wHeight,
                onBeforeClose: function () {
                    $(this).window('destroy');
                }
            });
            $('#' + winId).attr('admId', _admId);
            // 事件绑定
            $('#' + winId + '-tabsEMR').tabs({
                onSelect: function (title) {
                    // 这不常用,每次tk下没事
                    var admId = $('#' + winId).attr('admId');
                    var admData = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetAdmInfo', admId);
                    var patId = admData.toString().split('^')[0] || '';
                    if (title == '病历浏览') {
                        if ($('#' + winId + '-ifrmEMR').attr('src') == '') {
                            $('#' + winId + '-ifrmEMR').attr('src', 'emr.browse.csp' + '?EpisodeID=' + admId);
                        }
                    } else if (title == '过敏记录') {
                        if ($('#' + winId + '-ifrmAllergy').attr('src') == '') {
                            $('#' + winId + '-ifrmAllergy').attr('src', 'dhcdoc.allergyenter.csp' + '?EpisodeID=' + admId + '&PatientID=' + patId + '&IsOnlyShowPAList=Y');
                        }
                    } else if (title == '检查记录') {
                        if ($('#' + winId + '-ifrmRisQuery').attr('src') == '') {
                            $('#' + winId + '-ifrmRisQuery').attr('src', 'dhcapp.inspectrs.csp' + '?EpisodeID=' + admId + '&PatientID=' + patId);
                        }
                    } else if (title == '检验记录') {
                        if ($('#' + winId + '-ifrmLisQuery').attr('src') == '') {
                            $('#' + winId + '-ifrmLisQuery').attr('src', 'dhcapp.seepatlis.csp' + '?EpisodeID=' + admId + '&NoReaded=' + '1' + '&PatientID=' + patId);
                        }
                    } else if (title == '本次医嘱') {
                        if ($('#' + winId + '-ifrmOrdQuery').attr('src') == '') {
                            $('#' + winId + '-ifrmOrdQuery').attr('src', 'ipdoc.patorderview.csp' + '?EpisodeID=' + admId + '&PageShowFromWay=ShowFromEmrList&DefaultOrderPriorType=ALL');
                        }
                    }
                }
            });
        } else {
            $('#' + winId).attr('admId', _admId);
        }

        $('#' + winId).dialog('open');
        // 默认tab
        $('#' + winId + ' iframe').attr('src', '');
        $('#' + winId + '-tabsEMR').tabs('select', '病历浏览');
        $('#' + winId + '-ifrmEMR').attr('src', 'emr.browse.csp' + '?EpisodeID=' + _admId);
    },
    // 静配医院窗体
    AddHospCom: function (_options) {
        var tableName = _options.tableName || '';
        if (tableName === '') {
            $.messager.alert('提示', '程序错误,未传授权表名或代码', 'error');
            return;
        }
        var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
        if (hospAutFlag === 'Y') {
            $($('body>.hisui-layout')[0]).layout('add', {
                region: 'north',
                border: false,
                height: 40,
                split: false,
                bodyCls: 'pha-ly-hosp',
                content:
                    '<div style="padding-left:10px;">' +
                    '   <div class="pha-row">' +
                    '       <div class="pha-col">' +
                    '           <label id="_HospListLabel" style="color:red;">医院</label>' +
                    '       </div>' +
                    '   	<div class="pha-col">' +
                    '       	<input id="_HospList" class="textbox"/>' +
                    '   	</div>' +
                    '	</div>' +
                    '</div>'
            });
            var genHospObj = GenHospComp(tableName);
            return genHospObj;
        } else {
            return '';
        }
    },
	// 简易发布订阅
	Notify : function () {
		var notifyList = [];
		return {
			listen: function (fn) {
				notifyList.push(fn);
			},
			trigger: function () {
				for (var i = 0; i < notifyList.length; i++) {
					var fn = notifyList[i];
					fn.apply(this, arguments);
				}
			}
		};
	}
};
