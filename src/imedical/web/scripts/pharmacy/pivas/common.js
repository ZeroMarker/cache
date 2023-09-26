/**
 * creator:		yunhaibao
 * createdate:	2017-12-01
 * description: �������jquery+easyUI��һЩ��������
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
    // CSP��ηָ��ַ�
    Split: '|@|',
    // �ǼǺų���
    PatNoLength: function () {
        var patNoLen = tkMakeServerCall('web.DHCSTPIVAS.Common', 'PatRegNoLen');
        return patNoLen;
    },
    FmtPatNo: function (_no) {
        // �ǼǺŴ���
        if (_no.trim() == '') {
            return '';
        }
        var _len = this.PatNoLength();
        var _noLen = _no.length;
        if (_noLen > _len) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: '�ǼǺŴ���',
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
    // ����
    PadZero: function (_no, _len) {
        if (_no.trim() == '') {
            return '';
        }
        var _noLen = _no.length;
        if (_noLen > _len) {
            DHCPHA_HUI_COM.Msg.popover({
                msg: '���ȴ����貹��ĳ���',
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
    // �޸����ε���,������,���ñ���_callback
    UpdateBatNoWindow: function (_options, _callBack) {
        // _options.LocId	��Һ����Id
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
                        title: '����',
                        width: 300,
                        align: 'left'
                    }
                ]
            ],
            onClickRow: function (index, rowData) {
                $('#UpdateBatNoWindowDiv').window('close');
                // �ص�
                if (_callBack) {
                    _callBack(rowData.Description);
                }
            }
        };
        DHCPHA_HUI_COM.Grid.Init('gridBatNo', dataGridOption);
        $('#UpdateBatNoWindowDiv').window({
            title: 'ѡ������',
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
    // ������޸����ι���
    UpdateBatNoCombo: function (_options) {
        // _options.LocId	��Һ����Id
        // _options.MDspField	�����Id������
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
                        $.messager.alert('��ʾ', updArr[1], 'warning');
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
    // ����Լ�ȡ�����
    UpdateOeDspPack: function (_options) {
        // _options.CurRowIndex (������)
        // _options.GridId
        // _options.Field
        // _options.MDsp
        // _options.PackFlag(P:���,��:ȡ�����)
        var mDsp = _options.MDsp;
        var packFlag = _options.PackFlag;
        if (mDsp == undefined || mDsp == '') {
            $.messager.alert('��ʾ', '���IdΪ��', 'warning');
            return;
        }
        if (packFlag != 'P' && packFlag != '') {
            $.messager.alert('��ʾ', '���״̬����,' + packFlag, 'warning');
            return;
        }
        var updRet = tkMakeServerCall('web.DHCSTPIVAS.DataHandler', 'UpdateOeDspToPack', mDsp, packFlag);
        var updArr = updRet.split('^');
        if (updArr[0] < 0) {
            $.messager.alert('��ʾ', updArr[1], 'warning');
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
    // ������޸Ĵ�ӡ��ʽ����
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
    // ��Һ�ܾ�ԭ�򴰿�
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
                        title: '��Һ�ܾ�ԭ��',
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
                            $.messager.alert('��ʾ', retArr[1], 'warning');
                        } else if (retArr[0] < -1) {
                            $.messager.alert('��ʾ', retArr[1], 'error');
                        }
                        _callBack();
                    }
                );
                // ����̨
                $('#RefuseReasonWindowDiv').window('close');
            }
        };
        DHCPHA_HUI_COM.Grid.Init('gridRefuseReason', dataGridOption);
        $('#RefuseReasonWindowDiv').window({
            title: '��Һ�ܾ�ԭ��',
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
    // ��������checkbox
    BatchNoCheckList: function (_options) {
        // _options.LocId: ����Id
        // _options.Id:	   �󶨵�div��Id
        // _options.Check: Ĭ���Ƿ�ѡ(true,false<Ĭ��>)
        // _option.Pack:   �Ƿ���ʾ���
        $.m(
            {
                ClassName: 'web.DHCSTPIVAS.Common',
                MethodName: 'PivasLocBatList',
                pivasLoc: _options.LocId
            },
            function (retData) {
                var chkHtml = '';
                if (retData == '') {
                    $('#' + _options.Id).html("<span style='color:#FF584C;font-weight:bold'>�����Ρ�Ϊ���ա��롡�����졡ά����</span>");
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
                }); // ������Ⱦ
                if (_options.Pack == true) {
                    var packHtml = '<span style="margin-left:10px;"><input class="hisui-checkbox" id="chkPivasPack" type="checkbox" label="���"></input></span>';
                    $('#' + _options.Id).append(packHtml);
                    $HUI.checkbox('#chkPivasPack', {
                        checked: false
                    });
                }
                var chkAllHtml = '<span style="margin-left:10px;"><input class="hisui-checkbox" id="chkBatNoAll" type="checkbox" label="ȫѡ"></input></span>';
                $('#' + _options.Id).append(chkAllHtml);
                $HUI.checkbox('#chkBatNoAll', {
                    checked: true,
                    onCheckChange: function (e, value) {
                        $('input[type=checkbox][name=batbox]').checkbox('setValue', value);
                        if (value == false) {
                            $('#chkBatNoAll').next().text('ȫ��');
                        } else {
                            $('#chkBatNoAll').next().text('ȫѡ');
                        }
                    }
                });
            }
        );
    },
    // �������������б�
    // dhcstgrideu:scripts/dhcst/EasyUI/Plugins/dhcst.plugins.js
    InitGridAdm: function (_gOptions, _options) {
        // _gOptions.Id:���Id
        // _options:grid options
        var columns = [
            [
                {
                    field: 'curWard',
                    title: '����',
                    width: 100
                },
                {
                    field: 'curBed',
                    title: '����',
                    width: 100
                },
                {
                    field: 'admDate',
                    title: '��������',
                    width: 100
                },
                {
                    field: 'admTime',
                    title: '����ʱ��',
                    width: 100
                },
                {
                    field: 'admLoc',
                    title: '�������',
                    width: 100
                },
                {
                    field: 'patNo',
                    title: '�ǼǺ�',
                    width: 90
                },
                {
                    field: 'curDoc',
                    title: 'ҽ��',
                    width: 100
                },
                {
                    field: 'curWardId',
                    title: '����ID',
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
    // ��ʼ��ҵ�������������б�
    // dhcstcomboeu:scripts/dhcst/EasyUI/Plugins/dhcst.plugins.js
    ComboBox: {
        Init: function (_cOptions, _options) {
            DHCPHA_HUI_COM.ComboBox.Init(_cOptions, _options, 'PIVAS');
        },
        // ����ѡ��ڼ�����¼
        Select: function (_options) {
            //_options.Id
            //_options.Num
            var _id = _options.Id;
            var data = $('#' + _id).combobox('getData');
            if (data.length > 0) {
                $('#' + _id).combobox('select', data[_options.Num].RowId);
            }
        },
        // ��Һ����
        PivaCat: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVAOrderLink',
            hosp: session['LOGON.HOSPID']
        },
        // ��ҺС��
        PHCPivaCat: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'DHCPHCPivaCat',
            hosp: session['LOGON.HOSPID']
        },
        // ��Һ����
        PivaLoc: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVALoc',
            inputParams: session['LOGON.CTLOCID']
        },
        // ����
        Ward: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PACWard',
            hosp: session['LOGON.HOSPID'],
            mode: 'remote'
        },
        // �÷�
        Instruc: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PHCInstruc',
            mode: 'remote'
        },
        // Ƶ��
        Freq: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PHCFreq',
            mode: 'remote'
        },
        // ��Һ����
        Batch: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVABatTime',
            inputParams: session['LOGON.CTLOCID']
        },
        // ��Һ����,batno
        PIVALocBatNo: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVALocBatNo',
            inputStr: session['LOGON.CTLOCID']
        },
        // ҽ�����ȼ�
        Priority: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'OECPriority',
            mode: 'remote'
        },
        // ������
        LocGrp: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'DHCStkLocGroup',
            inputStr: session['LOGON.CTLOCID']
        },
        // ��Һ״̬
        PIVAState: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVAState',
            inputStr: session['LOGON.CTLOCID']
        },
        // �������״̬
        PassStat: {
            data: [
                {
                    RowId: 0,
                    Description: 'ȫ��'
                },
                {
                    RowId: 1,
                    Description: 'δ���'
                },
                {
                    RowId: 2,
                    Description: '�����'
                }
            ],
            panelHeight: 'auto'
        },
        // ������˽��
        PassResult: {
            data: [
                {
                    RowId: '',
                    Description: 'ȫ��'
                },
                {
                    RowId: 'SHTG',
                    Description: '���ͨ��'
                },
                {
                    RowId: 'SHJJ',
                    Description: '��˾ܾ�'
                }
            ],
            panelHeight: 'auto'
        },
        // ��ʿ���״̬
        NurseResult: {
            data: [
                {
                    RowId: '0',
                    Description: 'δ���'
                },
                {
                    RowId: '1',
                    Description: '�����'
                }
            ],
            panelHeight: 'auto'
        },
        // ҽ��/ִ�м�¼״̬
        OrdStatus: {
            data: [
                {
                    RowId: '1',
                    Description: '����'
                },
                {
                    RowId: '2',
                    Description: 'ֹͣ'
                }
            ],
            panelHeight: 'auto'
        },
        // ɨ��״̬
        Scan: {
            data: [
                {
                    RowId: '1',
                    Description: 'ȫ��'
                },
                {
                    RowId: '2',
                    Description: '��ɨ��'
                },
                {
                    RowId: '3',
                    Description: 'δɨ��'
                }
            ],
            panelHeight: 'auto'
        },
        YesOrNo: {
            data: [
                {
                    RowId: 'Y',
                    Description: '��'
                },
                {
                    RowId: 'N',
                    Description: '��'
                }
            ],
            panelHeight: 'auto'
        },
        MoreOrLess: {
            data: [
                {
                    RowId: '>',
                    Description: '����'
                },
                {
                    RowId: '<',
                    Description: 'С��'
                }
            ],
            panelHeight: 'auto'
        },
        // ҽ������
        DocLoc: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'DocLoc',
            mode: 'remote',
            hosp: session['LOGON.HOSPID']
        },
        // ҩ������
        CTLoc: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'CTLoc',
            inputStr: session['LOGON.CTLOCID'] + '^' + 'D',
            mode: 'remote'
        },
        // ��������Ա
        LocUser: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'LocUser',
            inputStr: session['LOGON.CTLOCID'] + '^Y'
        },
        // ����--����
        StkCatGrp: {
            ClassName: 'web.DHCST.Util.DrugUtilQuery',
            QueryName: 'DHCStkCatGroup'
        },
        // ��������
        LocStkCatGrp: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'DHCStkLocCatGroup',
            inputStr: session['LOGON.CTLOCID']
        },
        // ������
        StkCat: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'INCSCStkGrp',
            mode: 'remote'
        },
        // �ɷ��ֵ�
        Ingredient: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PHCIngredient'
        },
        // �ܾ�ԭ��ά������
        ReasonType: {
            data: [
                {
                    RowId: 'R',
                    Description: '�ܾ���Һ'
                }
            ]
            //data:[{"RowId":"C","Description":"ȡ��"},{"RowId":"R","Description":"�ܾ���Һ"},{"RowId":"P","Description":"��˾ܾ�"},{"RowId":"UNP","Description":"���������"}]
        },
        // ����ά������
        IOType: {
            data: [
                {
                    RowId: 'I',
                    Description: 'סԺ'
                },
                {
                    RowId: 'O',
                    Description: '����'
                }
            ]
        },
        // ����̨
        PIVAConfigTable: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVAConfigTable',
            inputStr: session['LOGON.CTLOCID']
        },
        // ������
        PIVAWorkType: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVAWorkType',
            inputStr: session['LOGON.CTLOCID']
        },
        // ��ӡ��ʽ
        PIVAPrtWay: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVAPrtWay'
        },
        // �������
        PIVASchedulType: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVASchedulType'
        },
        // ����ֵ�
        PIVASchedul: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVASchedul'
        },
        // С�ֵ�����
        StkComDict: {
            data: [
                {
                    RowId: 'PivasLabelSign',
                    Description: '��ǩ��ʶ'
                },
                {
                    RowId: 'PivasStoreCon',
                    Description: '��������'
                }
            ]
        },
        // ������ҩ
        MedicalType: {
            data: [
                {
                    RowId: 'P',
                    Description: '������ҩ'
                },
                {
                    RowId: 'A',
                    Description: '������ҩ'
                }
            ]
        },
        // �������
        PIVALeaveType: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'PIVALeaveType'
        },
        // ��ҩԭ��
        RetReason: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'RetReason',
            hosp: session['LOGON.HOSPID']
        },
        // �������
        PackType: {
            data: [
                {
                    RowId: 'Y',
                    Description: '��ʿ���'
                },
                {
                    RowId: 'E',
                    Description: '������'
                },
                {
                    RowId: 'P',
                    Description: '��Һ���'
                },
                {
                    RowId: 'N',
                    Description: '�Ǵ��'
                }
            ],
            panelHeight: 'auto',
            multiple: true,
            editable: false
        },
        // ��λ�ֵ�
        CtUom: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'CtUom'
        },
        // ��Һ�շ����õ�����
        LinkOrdPack: {
            data: [
                {
                    RowId: 'A',
                    Description: 'ȫ��'
                },
                {
                    RowId: 'Y',
                    Description: '���'
                },
                {
                    RowId: 'N',
                    Description: '��Һ'
                }
            ]
        },
        // ����סԺ����
        SysType: {
            data: [
                {
                    RowId: 'A',
                    Description: 'ȫ��'
                },
                {
                    RowId: 'I',
                    Description: 'סԺ'
                },
                {
                    RowId: 'O',
                    Description: '����'
                }
            ]
        },
        // ����״̬
        BatUpdateStat: {
            data: [
                {
                    RowId: 'A',
                    Description: 'ȫ��'
                },
                {
                    RowId: 'Y',
                    Description: '������'
                },
                {
                    RowId: 'N',
                    Description: 'δ����'
                }
            ],
            panelHeight: 'auto'
        },
        // ��ǩ״̬
        PrtStat: {
            data: [
                {
                    RowId: 'A',
                    Description: 'ȫ��'
                },
                {
                    RowId: 'Y',
                    Description: '�Ѵ�ǩ'
                },
                {
                    RowId: 'N',
                    Description: 'δ��ǩ'
                }
            ],
            panelHeight: 'auto'
        },
        // ��λ�ֵ�
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
    // ��ʼ��ҵ������������Grid
    // dhcstcombogrideu:scripts/dhcst/EasyUI/Plugins/dhcst.plugins.js
    ComboGrid: {
        Init: function (_cOptions, _options) {
            DHCPHA_HUI_COM.ComboGrid.Init(_cOptions, _options, 'PIVAS');
        },
        // �����ҩƷ
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
                        title: 'ҩƷ����',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'incDesc',
                        title: 'ҩƷ����',
                        width: 400,
                        sortable: true
                    },
                    {
                        field: 'incSpec',
                        title: '���',
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
        // ҽ�����ҩƷ
        ArcItmMast: {
            QueryParams: {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                QueryName: 'ArcItmMast'
            },
            panelWidth: 750,
            pageSize: 30, // ÿҳ��ʾ�ļ�¼����
            pageList: [30, 50, 100, 300, 500], // ��������ÿҳ��¼�������б�
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
                        title: 'ҽ�������',
                        width: 100,
                        sortable: true
                    },
                    {
                        field: 'arcItmDesc',
                        title: 'ҽ��������',
                        width: 400,
                        sortable: true
                    }
                ]
            ],
            idField: 'arcItmId',
            textField: 'arcItmDesc',
            pagination: true
        },
        // �����ֵ�
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
                        title: '��ʶ��',
                        width: 100,
                        sortable: true,
                        align: 'center',
                        halign: 'center'
                    },
                    {
                        field: 'psName',
                        title: '��������',
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
    // ��ʼ������
    Date: {
        Init: function (_options) {
            //_options.Id:Ԫ��id
            //_options.DateT: t��ʽ������(tΪ����)
            var id = _options.Id;
            var dateT = _options.DateT;
            if (!dateT) {
                dateT = 't';
            }
            var retDate = tkMakeServerCall('web.DHCSTKUTIL', 'GetDate', '', '', dateT);
            $('#' + id).datebox('setValue', retDate);
        }
    },
    // ��Ǭ����
    RunQianBG: '../csp/dhcst.blank.backgroud.csp',
    // ƴ��html����ǰ̨��ʾ
    Html: {
        // ָ�깫ʽά��
        IngredientButtons: function (_options) {
            //_options.Id // ��ӵ�table��Id
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
        /// confirm,ƴ����ʾ����Ϊtable,���벼��
        ConfirmInfo: function (_options) {
            /// _options.Data ���ڷֽ��json����
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
        /// grid��Ԫ�񻮹���ʾ,�Ժ��װ
        CellTip: function (_options) {
            //_options.TipArr:��Ҫ��ʾ����id,����
            //_options.ClassName:��Ҫ��ȡ��̨����(������,���Ż�)
            //_options.MethodName:��Ҫ��ȡ��̨�ķ���
            //_options.TdField:��Ҫ��ȡǰ̨ĳ�еĵ�Ԫ��ֵ��field
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
                            // ����������
                            if (typeof PIVASTIPSTIMER != 'undefined') {
                                clearTimeout(PIVASTIPSTIMER);
                            }
                            var tipInfo = this.textContent;
                            var thisEle = this;
                            var eX = event.clientX + 20;
                            var eY = event.clientY;
                            // ����mousemove,mouseover,�ƶ�ʱ����̨��Ƶ�����ʷ�����
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
        // ������ѡ(����:����ҽ��)
        LinkCheck: {
            Stat: '',
            Init: function (_options) {
                //_options.CurRowIndex:��ǰ��
                //_options.GridId:���Id
                //_options.Field: �е�Fieldֵ
                //_options.Check: true��ѡ,false����ѡ
                //_options.Value: ��ֵ
                //_options.Type:(Select-ѡ����,Check-��ѡ)
                if (this.Stat == '') {
                    this.Stat = 1;
                    var gridId = _options.GridId;
                    var field = _options.Field;
                    var check = _options.Check;
                    var value = _options.Value;
                    var type = _options.Type;
                    if (type == 'Select') {
                        // �������ѡ��,����ʽ����
                        //$('#' + gridId).datagrid("unselectAll");
                        PIVAS.Grid.ClearSelections(gridId);
                    }
                    var gridRowsData = $('#' + gridId).datagrid('getRows');
                    var gridRowsCount = gridRowsData.length;
                    // ����
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
                    // ����
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
            SurgeryImg: '<img src="../images/webemr/������������ҽ���Ļ���).png" border=0 height="12px"/>',
            Yes: '<img src="../scripts/pharmacy/common/image/yes.png"></img>',
            //Yes: '<i class="fa fa-check" aria-hidden="true" style="color:#17A05D;font-size:18px"></i>',
            No: '<i class="fa fa-close" aria-hidden="true" style="color:#DD4F43;font-size:18px"></i>',
            PersonEven: 'background-color:#00A59D;', //509de1
            SignEven: 'color:red;',
            SignRowEven: 'background-color:#20BB44;',
            BatchPack: 'background-color:#17C3AC;', // �������
            BatchUp: 'font-style:italic;', // �ֹ��޸Ĺ�����
            BatchUpdated: 'background-color:rgb(64, 162, 222);', // ������
            CHNYes: "<font color='#21ba45'>��</font>",
            CHNNo: '<font color="#f16e57">��</font>'
        },
        Formatter: {
            OeoriSign: function (value, row, index) {
                if (value == '��' || value == '0') {
                    return '<div class="oeori-sign-c"></div>';
                } else if (value == '��' || value == '-1') {
                    return '<div class="oeori-sign-t"></div>';
                } else if (value == '��' || value == '1') {
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
            // grid��field:incDescStyle,json��̫�����,��һ��
            // ��治��(Y)!!��ý����װ(Y)!!����������װ(Y)
            IncDesc: function (value, row, index) {
                var incStyle = row.incDescStyle;
                if (incStyle) {
                    var incStyleArr = incStyle.split('!!');
                    var style = '';
                    if (incStyleArr[0] == 'Y') {
                        // ��治��
                        style += 'background-color:#17C3AC;';
                    }
                    if (incStyleArr[1] == 'Y') {
                        // ��ý����װ
                        style += 'font-weight:bold;';
                    }
                    if (incStyleArr[2] == 'Y') {
                        // ����������װ
                        style += 'border-bottom:1px solid black;';
                    }
                    return style;
                }
            },
            // ��Һ״̬��ɫ
            PivaState: function (value, row, index) {
                switch (value) {
                    case '��ҽ��':
                        colorStyle = 'background: #ee4f38;color:white;font-weight:bold;';
                        break;
                    case '��ʿ���':
                        colorStyle = 'background:#f58800;color:white;font-weight:bold;';
                        break;
                    case '�������':
                        colorStyle = 'background:#f58800;color:white;font-weight:bold;';
                        break;
                    case '���ͨ��':
                        colorStyle = 'background:#f58800;color:white;font-weight:bold;';
                        break;
                    case '����':
                        colorStyle = 'background:#f1c516;color:white;font-weight:bold;';
                        break;
                    case '��ǩ':
                        colorStyle = 'background:#a4c703;color:white;font-weight:bold;';
                        break;
                    case '��ǩ':
                        colorStyle = 'background:#51b80c;color:white;font-weight:bold;';
                        break;
                    case '��ҩ':
                        colorStyle = 'background:#4b991b;color:white;font-weight:bold;';
                        break;
                    case '��ǩ':
                        colorStyle = 'background:#03ceb4;color:white;font-weight:bold;';
                        break;
                    case '�˶�':
                        colorStyle = 'background:#10b2c8;color:white;font-weight:bold;';
                        break;
                    case '����':
                        colorStyle = 'background:#107cc8;color:white;font-weight:bold;';
                        break;
                    case '����':
                        colorStyle = 'background:#1044c8;color:white;font-weight:bold;';
                        break;
                    case 'װ��':
                        colorStyle = 'background:#6557d3;color:white;font-weight:bold;';
                        break;
                    case '��������':
                        colorStyle = 'background:#a849cb;color:white;font-weight:bold;';
                        break;
                    case '��ʼ��Һ':
                        colorStyle = 'background:#d773b0;color:white;font-weight:bold;';
                        break;
                    case '������Һ':
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
                    // �ǼǺſ�,��ɫͬ��һ��
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

        //������ֱ���ô˼���,��ʽ���޸�
        WarnInfo: function () {
            var msghtml = '<div id="msgboxbox" style="display:none;position: absolute;width:200px;height:100px">һ�������ڳ�ʱ��ǩ����</div>';
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
        // ����ϼ���ʾ����
        Pagination: function () {
            if ($.fn.pagination) {
                $.fn.pagination.defaults.displayMsg = '��ʾ{from}��{to} ��{total}��';
            }
        },
        // ���ѡ��
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
    // ���ֲ�,��ӡ\����\����
    Progress: {
        Show: function (_options) {
            var _text = '  ��  ��  ��  ��  ��  ';
            var _type = _options.type;
            if (_type) {
                if (_type == 'save') {
                    _text = '  ��  ��  ��  ��  ��';
                } else if (_type == 'print') {
                    _text = '  ��  ӡ  ��  ��  ��';
                } else if (_type == 'export') {
                    _text = '  ��  ��  ��  ��  ��';
                }
            }
            $.messager.progress({
                title: '�����ĵȴ�...',
                text: _text,
                interval: _options.interval ? _options.interval : 1000
            });
        },
        Close: function () {
            $.messager.progress('close');
        }
    },
    // ����,IE��֧��MP3
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
    // ѡ�񵥺Ŵ���
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
            '<td> <a class="hisui-linkbutton" plain="false" id="btnFindPogsNo" iconCls="icon-w-find">��ѯ</a></td>' +
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
                placeholder: '��Һ״̬...',
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
                        title: '��Һ״̬',
                        width: 100,
                        align: 'center'
                    },
                    {
                        field: 'pogsNo',
                        title: '����',
                        width: 200,
                        align: 'center'
                    },
                    {
                        field: 'pogsDate',
                        title: '��������',
                        width: 100,
                        align: 'center'
                    },
                    {
                        field: 'pogsTime',
                        title: '����ʱ��',
                        width: 150,
                        align: 'center'
                    },
                    {
                        field: 'pogsUserName',
                        title: '������',
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
            title: ' ���̵��ݼ�¼',
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
    // �鿴��ȡ�����÷ѵĴ���
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
                        title: 'ҽ������',
                        width: 250,
                        align: 'left'
                    },
                    {
                        field: 'qty',
                        title: '����',
                        width: 50,
                        align: 'right'
                    },
                    {
                        field: 'oeoriDateTime',
                        title: '����ʱ��',
                        width: 170
                    },
                    {
                        field: 'userName',
                        title: '������',
                        width: 80
                    },
                    {
                        field: 'oeoriStatDesc',
                        title: 'ҽ��״̬',
                        width: 80
                    }
                ]
            ],
            onLoadSuccess: function () {}
        };
        DHCPHA_HUI_COM.Grid.Init('gridOrdLink', dataGridOption);
        $('#gridOrdLink').datagrid('loadData', rowsData);

        $('#OrdLinkWindowDiv').window({
            title: '���÷���',
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
    // ������˼�¼
    AuditRecordWindow: function (_options) {
        var dateMOeori = _options.dateMOeori || '';
        if (dateMOeori == '') {
            return;
        }
        var winDivId = 'OeAuditWindowDiv';
        var winDiv = '<div id="OeAuditWindowDiv" style="padding:10px;"><div id="gridOeAuditRecord"></div></div>';
        $('body').append(winDiv);
        //������
        var columns = [
            [
                {
                    field: 'passResult',
                    title: '���״̬',
                    width: 100,
                    styler: function (value, row, index) {
                        var valueStr = value.toString();
                        if (valueStr.indexOf('���ͨ��') >= 0) {
                            return 'background-color:#019BC1;color:white;'; //��ɫ
                        } else if (valueStr.indexOf('��˾ܾ�') >= 0) {
                            return 'background-color:#C33A30;color:white;'; //��ɫ
                        } else if (valueStr.indexOf('ҽ������') >= 0) {
                            return 'background-color:#FFB63D;color:white;'; //ǳ��ɫ
                        }
                        if (valueStr.toString().indexOf('��ȡ��')) {
                            return 'background-color:#C33A30;color:white;';
                        }
                    }
                },
                {
                    field: 'userName',
                    title: '������',
                    width: 90
                },
                {
                    field: 'dateTime',
                    title: '����ʱ��',
                    width: 155
                },
                {
                    field: 'reasonDesc',
                    title: '����ԭ��',
                    width: 250,
                    formatter: function (value, row, index) {
                        return '<div style="width=250px;word-break:break-all;word-wrap:break-word;white-space:pre-wrap;">' + value + '</div>';
                    }
                },
                {
                    field: 'docAgree',
                    title: 'ҽ������',
                    width: 70
                },
                {
                    field: 'docNotes',
                    title: 'ҽ������',
                    width: 80
                },
                {
                    field: 'oeoriStat',
                    title: 'ҽ��״̬',
                    width: 70
                },
                {
                    field: 'cancelUserName',
                    title: 'ȡ����',
                    width: 90
                },
                {
                    field: 'cancelDateTime',
                    title: 'ȡ��ʱ��',
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
            title: ' ������˼�¼',
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
                title: ' ��ά��',
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
    // �����������
    ViewEMRWindow: function (_winOpts, _admId) {
        var winId = 'PIVAS_UX_ViewEMR';
        if (($('#' + winId).html() || '') == '') {
            var diagHtml = '';
            diagHtml += '<div id="' + winId + '" class="hisui-dialog"  title="�������">';
            diagHtml += '   <div class="hisui-layout" fit="true" border="false">';
            diagHtml += '       <div data-options=\'region:"center"\' border="false">';
            diagHtml += '           <div class="hisui-layout" fit="true" border="false">';
            diagHtml += '               <div id="' + winId + '-lyWinCen' + '" data-options=\'region:"center",split:true,headerCls:"panel-header-gray"\' border="false">';
            diagHtml += '                   <div class="hisui-tabs tabs-gray" fit="true" id="' + winId + '-tabsEMR">';
            diagHtml += '                       <div data-options=\'title:"�������"\'>';
            diagHtml += '                           <iframe id="' + winId + '-ifrmEMR" style="display:block;width:100%;"></iframe>';
            diagHtml += '                       </div>';
            diagHtml += '                       <div data-options=\'title:"������¼"\'>';
            diagHtml += '                           <iframe id="' + winId + '-ifrmAllergy" style="display:block;width:100%;"></iframe>';
            diagHtml += '                       </div>';
            diagHtml += '                       <div data-options=\'title:"����¼"\'>';
            diagHtml += '                           <iframe id="' + winId + '-ifrmRisQuery" style="display:block;width:100%;"></iframe>';
            diagHtml += '                       </div>';
            diagHtml += '                       <div data-options=\'title:"�����¼"\'>';
            diagHtml += '                           <iframe id="' + winId + '-ifrmLisQuery" style="display:block;width:100%;"></iframe>';
            diagHtml += '                       </div>';
            diagHtml += '                       <div data-options=\'title:"����ҽ��"\'>';
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
            // �¼���
            $('#' + winId + '-tabsEMR').tabs({
                onSelect: function (title) {
                    // �ⲻ����,ÿ��tk��û��
                    var admId = $('#' + winId).attr('admId');
                    var admData = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetAdmInfo', admId);
                    var patId = admData.toString().split('^')[0] || '';
                    if (title == '�������') {
                        if ($('#' + winId + '-ifrmEMR').attr('src') == '') {
                            $('#' + winId + '-ifrmEMR').attr('src', 'emr.browse.csp' + '?EpisodeID=' + admId);
                        }
                    } else if (title == '������¼') {
                        if ($('#' + winId + '-ifrmAllergy').attr('src') == '') {
                            $('#' + winId + '-ifrmAllergy').attr('src', 'dhcdoc.allergyenter.csp' + '?EpisodeID=' + admId + '&PatientID=' + patId + '&IsOnlyShowPAList=Y');
                        }
                    } else if (title == '����¼') {
                        if ($('#' + winId + '-ifrmRisQuery').attr('src') == '') {
                            $('#' + winId + '-ifrmRisQuery').attr('src', 'dhcapp.inspectrs.csp' + '?EpisodeID=' + admId + '&PatientID=' + patId);
                        }
                    } else if (title == '�����¼') {
                        if ($('#' + winId + '-ifrmLisQuery').attr('src') == '') {
                            $('#' + winId + '-ifrmLisQuery').attr('src', 'dhcapp.seepatlis.csp' + '?EpisodeID=' + admId + '&NoReaded=' + '1' + '&PatientID=' + patId);
                        }
                    } else if (title == '����ҽ��') {
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
        // Ĭ��tab
        $('#' + winId + ' iframe').attr('src', '');
        $('#' + winId + '-tabsEMR').tabs('select', '�������');
        $('#' + winId + '-ifrmEMR').attr('src', 'emr.browse.csp' + '?EpisodeID=' + _admId);
    },
    // ����ҽԺ����
    AddHospCom: function (_options) {
        var tableName = _options.tableName || '';
        if (tableName === '') {
            $.messager.alert('��ʾ', '�������,δ����Ȩ���������', 'error');
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
                    '           <label id="_HospListLabel" style="color:red;">ҽԺ</label>' +
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
	// ���׷�������
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
