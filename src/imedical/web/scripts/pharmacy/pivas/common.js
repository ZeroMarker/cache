/**
 * creator:     yunhaibao
 * createdate:  2017-12-01
 * description: �������jquery+easyUI��һЩ��������
 * pharmacy/pivas/common.js
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
    VAR: {
        MaxDrugCnt: 2
    },
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
        // _options.LocId   ��Һ����Id
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
            maximizable: false,
            minimizable: false,
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
        // _options.LocId   ��Һ����Id
        // _options.MDspField   �����Id������
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
                            updData.updateType = 'U';
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
        var winDiv = '<div id="RefuseReasonWindowDiv" style="padding:10px;"><div id="gridRefuseReason"></div></div>';
        $('body').append(winDiv);
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'web.DHCSTPIVAS.Dictionary',
                QueryName: 'PIVAOperReason',
                reasonType: 'R',
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
                        field: 'RowId',
                        title: 'RowId',
                        width: 80,
                        hidden: true
                    },
                    {
                        field: 'Description',
                        title: '��Һ�ܾ�ԭ��',
                        width: 300,
                        align: 'left'
                    }
                ]
            ],
            onClickRow: function (index, rowData) {
                // ����ܾ�
                if (_options.pogArr) {
                    $.cm(
                        {
                            ClassName: 'web.DHCSTPIVAS.Refuse',
                            MethodName: 'SaveData',
                            pogJsonStr: JSON.stringify(_options.pogArr),
                            user: _options.user,
                            reason: rowData.RowId,
                            exeType: 'R',
                            dataType: 'text'
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
                }
                // δ�����ܾ�
                if (_options.dataArr) {
                    $.cm(
                        {
                            ClassName: 'web.DHCSTPIVAS.Refuse',
                            MethodName: 'MultiSaveData4Dsp',
                            dataArrStr: JSON.stringify(_options.dataArr),
                            user: _options.user,
                            reason: rowData.RowId,
                            dataType: 'text'
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
                }
                // ����̨
                $('#RefuseReasonWindowDiv').window('close');
            }
        };
        DHCPHA_HUI_COM.Grid.Init('gridRefuseReason', dataGridOption);
        $('#RefuseReasonWindowDiv').window({
            title: '��Һ�ܾ�ԭ��',
            collapsible: false,
            iconCls: 'icon-w-list',
            minimizable: false,
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
        $('#RefuseReasonWindowDiv').children().eq(0).css('border-radius', '4px');
    },
    // ��������checkbox
    BatchNoCheckList: function (_options) {
        // _options.LocId: ����Id
        // _options.Id:    �󶨵�div��Id
        // _options.Check: Ĭ���Ƿ�ѡ(true,false<Ĭ��>)
        // _option.Pack:   �Ƿ���ʾ���
        $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.Common',
                MethodName: 'GetPivasLocBatJson',
                retType: 'String',
                pivasLoc: _options.LocId
            },
            function (retData) {
                if (retData == '') {
                    $('#' + _options.Id).html("<span style='color:#FF584C;font-weight:bold'>�����Ρ�Ϊ���ա��롡�����졡ά����</span>");
                    return;
                }
                var checkboxHtml = '';

                for (var i = 0; i < retData.length; i++) {
                    var rowData = retData[i];
                    var batId = rowData.batNoID;
                    var batDesc = rowData.batNoDesc;
                    var batInfo = rowData.info;
                    var checkHtml =
                        '<input class="hisui-checkbox" id="' +
                        batId +
                        '"  name="batbox" type="checkbox" value=' +
                        batId +
                        ' text=' +
                        batDesc +
                        ' label=' +
                        batDesc +
                        ' info="' +
                        batInfo +
                        '">' +
                        '</input>';
                    var spanHtml = '<span style="margin-left:' + (i == 0 ? 1 : 10) + 'px;">' + checkHtml + '</span>';
                    checkboxHtml += spanHtml;
                }
                $('#' + _options.Id).append(checkboxHtml);
                $HUI.checkbox('#' + _options.Id + ' .hisui-checkbox', {
                    checked: _options.Check == true ? true : false
                });

                // ��popover
                $('#' + _options.Id + ' span').tooltip({
                    content: function () {
                        // ֻ�ǳ�ʼ����ʱ�����
                        return $(event.target).parent().find('input').attr('info');
                    },
                    position: 'bottom',
                    showDelay: 1000
                });

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
                    Description: $g('ȫ��')
                },
                {
                    RowId: 1,
                    Description: $g('δ���')
                },
                {
                    RowId: 2,
                    Description: $g('�����')
                },
                {
                    RowId: 3,
                    Description: $g('������')
                }
            ],
            panelHeight: 'auto'
        },
        // ������˽��
        PassResult: {
            data: [
                {
                    RowId: '',
                    Description: $g('ȫ��')
                },
                {
                    RowId: 'SHTG',
                    Description: $g('���ͨ��')
                },
                {
                    RowId: 'SHJJ',
                    Description: $g('��˾ܾ�')
                }
            ],
            panelHeight: 'auto'
        },
        // ��ʿ���״̬
        NurseResult: {
            data: [
                {
                    RowId: '0',
                    Description: $g('δ���')
                },
                {
                    RowId: '1',
                    Description: $g('�����')
                }
            ],
            panelHeight: 'auto'
        },
        // ҽ��/ִ�м�¼״̬
        OrdStatus: {
            data: [
                {
                    RowId: '1',
                    Description: $g('����')
                },
                {
                    RowId: '2',
                    Description: $g('ֹͣ')
                }
            ],
            panelHeight: 'auto'
        },
        // ҽ��/ִ�м�¼״̬������ֹͣ״̬�Ƿ���ҩ��
        OrdStatusDetail: {
            data: [
                {
                    RowId: '1',
                    Description: $g('����')
                },
                {
                    RowId: '2',
                    Description: $g('ֹͣ(δ��ҩ)')
                },
                {
                    RowId: '3',
                    Description: $g('ֹͣ(����ҩ)')
                }
            ],
            panelHeight: 'auto'
        },
        // ɨ��״̬
        Scan: {
            data: [
                {
                    RowId: '1',
                    Description: $g('ȫ��')
                },
                {
                    RowId: '2',
                    Description: $g('��ɨ��')
                },
                {
                    RowId: '3',
                    Description: $g('δɨ��')
                }
            ],
            panelHeight: 'auto'
        },
        YesOrNo: {
            data: [
                {
                    RowId: 'Y',
                    Description: $g('��')
                },
                {
                    RowId: 'N',
                    Description: $g('��')
                }
            ],
            panelHeight: 'auto'
        },
        MoreOrLess: {
            data: [
                {
                    RowId: '>',
                    Description: $g('����')
                },
                {
                    RowId: '<',
                    Description: $g('С��')
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
                    Description: $g('�ܾ���Һ')
                }
            ]
            //data:[{"RowId":"C","Description":"ȡ��"},{"RowId":"R","Description":"�ܾ���Һ"},{"RowId":"P","Description":"��˾ܾ�"},{"RowId":"UNP","Description":"���������"}]
        },
        // ����ά������
        IOType: {
            data: [
                {
                    RowId: 'I',
                    Description: $g('סԺ')
                },
                {
                    RowId: 'O',
                    Description: $g('����')
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
                    Description: $g('��ǩ��ʶ')
                },
                {
                    RowId: 'PivasStoreCon',
                    Description: $g('��������')
                }
            ]
        },
        // ������ҩ
        MedicalType: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'StkComDictionaryAsCode',
            inputStr: 'MedicalType'
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
                    RowId: 'PY',
                    Description: $g('���')
                },
                {
                    RowId: 'N',
                    Description: $g('�Ǵ��')
                },
                {
                    RowId: 'Y',
                    Description: $g('��ʿ���')
                },
                {
                    RowId: 'P',
                    Description: $g('��Һ���')
                }
            ],
            panelHeight: 'auto',
            multiple: false,
            editable: true
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
                    Description: $g('ȫ��')
                },
                {
                    RowId: 'Y',
                    Description: $g('���')
                },
                {
                    RowId: 'N',
                    Description: $g('��Һ')
                }
            ]
        },
        // ����סԺ����
        SysType: {
            data: [
                {
                    RowId: 'A',
                    Description: $g('ȫ��')
                },
                {
                    RowId: 'I',
                    Description: $g('סԺ')
                },
                {
                    RowId: 'O',
                    Description: $g('����')
                }
            ]
        },
        // ����״̬
        BatUpdateStat: {
            data: [
                {
                    RowId: 'A',
                    Description: $g('ȫ��')
                },
                {
                    RowId: 'Y',
                    Description: $g('������')
                },
                {
                    RowId: 'N',
                    Description: $g('δ����')
                }
            ],
            panelHeight: 'auto'
        },
        // ��ǩ״̬
        PrtStat: {
            data: [
                {
                    RowId: 'A',
                    Description: $g('ȫ��')
                },
                {
                    RowId: 'Y',
                    Description: $g('�Ѵ�ǩ')
                },
                {
                    RowId: 'N',
                    Description: $g('δ��ǩ')
                }
            ],
            panelHeight: 'auto'
        },
        // ��λ�ֵ�
        DrugUom: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'DrugUom'
        },

        // ������ҵ,������ҵ
        PHManufacturer: {
            ClassName: 'PHA.STORE.Unit',
            QueryName: 'PHManufacturerForGird',
            mode: 'remote'
        },
        // ���е�λ
        CTUOMAll: {
            ClassName: 'PHA.STORE.Unit',
            QueryName: 'CTUOM',
            mode: 'remote'
        },
        //������Ա
        UserAll: {
            ClassName: 'PHA.STORE.Unit',
            QueryName: 'UserAll',
            mode: 'remote'
        },
        // ¥��
        Floor: {
            ClassName: 'web.DHCSTPIVAS.Dictionary',
            QueryName: 'BuildingFloor',
            hosp: session['LOGON.HOSPID'],
            mode: 'remote'
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
                hosp: session['LOGON.HOSPID'],
                loc: session['LOGON.CTLOCID']
            },
            panelWidth: 450,
            panelHeight: 300,
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
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'incDesc',
                        title: 'ҩƷ����',
                        width: 400,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'incSpec',
                        title: '���',
                        width: 100,
                        sortable: true,
                        hidden: true
                    },
                    {
                        field: 'inciInfo',
                        title: 'ҩƷ��Ϣ',
                        width: 200,
                        formatter: function (value, row, index) {
                            var retArr = [];
                            retArr.push('<div>');
                            retArr.push('    <div style="">');
                            retArr.push('        <div style="float:left;">' + row.incDesc + '</div>');
                            retArr.push('        <div style="float:right;">' + row.incCode + '</div>');
                            retArr.push('        <div style="clear:both;"></div>');
                            retArr.push('    </div>');
                            retArr.push('    <div style="padding-top:8px;font-style: italic;color:#666;">');
                            retArr.push('        <div style="float:left;">' + row.manfDesc + '</div>');
                            retArr.push('        <div style="float:right;">' + row.goodName + '</div>');
                            retArr.push('        <div style="clear:both;"></div>');
                            retArr.push('    </div>');
                            retArr.push('</div>');
                            return retArr.join('');
                        }
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
                    var btnHtml = '<div style="padding-top:10px;padding-left:10px;float:left"><a>' + btnDesc + '</a></div>';
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
                var html = '<div id="tipRemark" style="border-radius:3px; display:none; border:1px solid #017BCE; padding:5px;position: absolute; background-color: white;color:black;"></div>';
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
            BatchPack: 'color:#017BEC;font-weight:bold;', // �������
            BatchUp: 'font-style:italic;', // �ֹ��޸Ĺ�����
            BatchUpdated: 'background-color:rgb(64, 162, 222);', // ������
            CHNYes: '<font color="#21ba45">' + $g('��') + '</font>',
            CHNNo: '<font color="#f16e57">' + $g('��') + '</font>'
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
            },
            SignGroup: function (value, row, index) {
                var maxDrugCnt = PIVAS.VAR.MaxDrugCnt;
                var valJson = JSON.parse(value);
                var len = valJson.length;
                var rowHeight = 27;

                var visibleStyle = 'margin-left:-10px;';
                var signHeight = rowHeight * maxDrugCnt - 8 - 14;
                var maxHeight = rowHeight * len - 8 - 14;
                var moreHeight = signHeight - 10;
                var moreFlag = len > maxDrugCnt ? true : false;
                if (maxHeight < signHeight) {
                    signHeight = maxHeight;
                }
                var retHtmlArr = [];
                if (len === 1) {
                    retHtmlArr.push('<div class="pivas-single-sign"  style="' + visibleStyle + '">');
                } else {
                    retHtmlArr.push('<div class="pivas-ord-sign"  style="' + visibleStyle + '">');
                }
                retHtmlArr.push('   <div class="pivas-ord-toggle" style="height:' + signHeight + 'px;line-height:' + signHeight + 'px">');
                if (moreFlag === true) {
                    retHtmlArr.push('       <div class="pivas-ord-sign-more" style="height:' + moreHeight + 'px;"></div>');
                }
                retHtmlArr.push('   </div>');
                retHtmlArr.push('   <div class="pivas-ord-toggle" style="height:' + maxHeight + 'px;display:none">');
                retHtmlArr.push('   </div>');
                retHtmlArr.push('</div>');
                return retHtmlArr.join('');
            },
            GetGroup: function (rowArr, field) {
                var maxDrugCnt = PIVAS.VAR.MaxDrugCnt;
                var valJson = rowArr;
                var len = valJson.length;
                var retHtmlArr = [];
                for (var i = 0; i < len; i++) {
                    var valData = valJson[i];
                    if (i >= maxDrugCnt) {
                        retHtmlArr.push('<div class="pivas-ord-grp-row pivas-ord-toggle" style="display:none;;line-height:19px;">');
                    } else {
                        retHtmlArr.push('<div class="pivas-ord-grp-row" style="line-height:19px;">');
                    }
                    retHtmlArr.push(valData[field]);
                    retHtmlArr.push('</div>');
                }
                return retHtmlArr.join('');
            },
            DosageGroup: function (value, rowData, index) {
                return PIVAS.Grid.Formatter.GetGroup(JSON.parse(rowData.drugsArr), 'dosage');
            },
            QtyUomGroup: function (value, rowData, index) {
                return PIVAS.Grid.Formatter.GetGroup(JSON.parse(rowData.drugsArr), 'qtyUom');
            },
            OrdRemarkGroup: function (value, rowData, index) {
                return PIVAS.Grid.Formatter.GetGroup(JSON.parse(rowData.drugsArr), 'ordRemark');
            },
            InciGroup: function (value, rowData, index) {
                var maxDrugCnt = PIVAS.VAR.MaxDrugCnt;
                var valJson = JSON.parse(value);
                var len = valJson.length;
                var inciHtmlArr = [];
                for (var i = 0; i < len; i++) {
                    var valData = valJson[i];
                    if (i >= maxDrugCnt) {
                        inciHtmlArr.push('<div class="pivas-ord-grp-row pivas-ord-toggle" style="display:none;">');
                    } else {
                        inciHtmlArr.push('<div class="pivas-ord-grp-row" style="">');
                    }
                    var inciDesc = valData.inciDesc;
                    var omFlag = valData.omFlag;
                    var skinTest = valData.skinTest;
                    var moreFlag = valData.moreFlag;
                    var compFlag = valData.compFlag;

                    if (omFlag !== '') {
                        var omDesc = '';
                        if (omFlag === 'OM') {
                            omDesc = '[�Ա�]';
                        } else if (omFlag === 'ZT') {
                            omDesc = '[����]';
                        }
                        omFlag = '<span style="color:#F6A519;font-weight:bold;">' + omDesc + '</span>';
                        inciDesc = omFlag + ' ' + inciDesc;
                    }
                    if (skinTest !== '') {
                        if (skinTest.indexOf('+') >= 0) {
                            skinTest = '<span style="color:#F6704E;font-weight:bold;">' + skinTest + '</span>';
                        }
                        inciDesc = skinTest + ' ' + inciDesc;
                    }
                    var inciHtml = '<span style="white-space: nowrap;';
                    if (moreFlag === 'Y') {
                        inciHtml += 'font-weight:bold;';
                    }
                    if (compFlag === 'Y') {
                        inciHtml += 'text-decoration: underline;';
                    }
                    inciHtml += '">' + inciDesc + '</span>';
                    inciHtmlArr.push(inciHtml);
                    inciHtmlArr.push('</div>');
                }
                var inciGrpHtml = '<div style="margin-left:10px">' + inciHtmlArr.join('') + '</div>';
                var signHtml = PIVAS.Grid.Formatter.SignGroup(value, rowData, index);
                return '<div style="padding-left:10px;position:relative;line-height:19px;">' + signHtml + inciGrpHtml + '</div>';
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
                var className = '';
                switch (value) {
                    case '��ҽ��':
                        colorStyle = 'background: #ee4f38;color:white;';
                        break;
                    case '��ʿ���':
                        colorStyle = 'background:#f58800;color:white;';
                        break;
                    case '�������':
                        colorStyle = 'background:#f58800;color:white;';
                        break;
                    case '���ͨ��':
                        colorStyle = 'background:#f58800;color:white;';
                        break;
                    case '����':
                        colorStyle = 'background:#f1c516;color:white;';
                        break;
                    case '��ǩ':
                        className = 'pha-pivas-state-10';
                        break;
                    case '��ǩ':
                        className = 'pha-pivas-state-20';
                        break;
                    case '��ҩ':
                        className = 'pha-pivas-state-30';
                        break;
                    case '��ǩ':
                        className = 'pha-pivas-state-40';
                        break;
                    case '�˶�':
                        className = 'pha-pivas-state-50';
                        break;
                    case '����':
                        className = 'pha-pivas-state-60';
                        break;
                    case '����':
                        className = 'pha-pivas-state-70';
                        break;
                    case 'װ��':
                        className = 'pha-pivas-state-80';
                        break;
                    case '��������':
                        className = 'pha-pivas-state-90';
                        break;
                    case '����':
                        className = 'pha-pivas-state-90';
                        break;
                    case '��ʼ��Һ':
                        colorStyle = 'background:#d773b0;color:white;';
                        break;
                    case '������Һ':
                        colorStyle = 'background:#77656b;color:white;';
                        break;
                    default:
                        colorStyle = 'background:white;color:black;';
                        break;
                }

                if (className === '') {
                    var psNumber = row.psNumber || '';
                    if (psNumber !== '') {
                        className = 'pha-pivas-state-' + psNumber;
                    }
                }
                return {
                    class: className
                };
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
            },
            PersonAlt: function (index, rowData) {
                if (rowData.altFlag === 'Y') {
                    return {
                        class: 'datagrid-row-alt'
                    };
                }
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
            if (typeof PHA_OPIVAS_COM === 'object') {
                if ($.fn.pagination) {
                    $.fn.pagination.defaults.displayMsg = '��ʾ{from}��{to} ��{total}��';
                }
            }
        },
        // ���ѡ��
        ClearSelections: function (gridId) {
            $('#' + gridId)
                .prev()
                .find('.datagrid-row')
                .removeClass('datagrid-row-selected');
        },
        PageHandler: function ($grid) {
            if ($grid.datagrid('options').pageNumber == 0) {
                $grid.datagrid('options').pageNumber = 1;
            }
        },
        LoadFilter: function (data) {
            var $grid = $(this);
            var opts = $grid.datagrid('options');
            var pager = $grid.datagrid('getPager');
            pager.pagination({
                onSelectPage: function (pageNum, pageSize) {
                    opts.pageNumber = pageNum;
                    opts.pageSize = pageSize;
                    pager.pagination('refresh', {
                        pageNumber: pageNum,
                        pageSize: pageSize
                    });
                    $grid.datagrid('loading');
                    setTimeout(function () {
                        $grid.datagrid('loadData', data);
                    }, 100);
                }
            });
            if (!data.originalRows) {
                data.originalRows = data.rows;
            }
            var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
            var end = start + parseInt(opts.pageSize);
            data.rows = data.originalRows.slice(start, end);
            return data;
        },
        onCheckAll: function (rows) {
            PIVAS.Grid.PageCheckHandler($(this), 'Y');
        },
        onUncheckAll: function (rows) {
            PIVAS.Grid.PageCheckHandler($(this), 'N');
        },
        onCheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            UpdateRow(rowIndex, {
                check: 'Y'
            });
        },
        onUncheck: function (rowIndex, rowData) {
            if ($(this).datagrid('options').checking == true) {
                return;
            }
            UpdateRow(rowIndex, {
                check: 'N'
            });
        },
        CheckHandler: function ($grid, checkFlag) {},
        PageCheckHandler: function ($grid, checkFlag) {
            if ($grid.datagrid('options').checking == true) {
                return;
            }
            var opts = $grid.datagrid('getPager').pagination('options');
            var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
            var end = start + parseInt(opts.pageSize);
            PIVAS.Grid.LocalCheckPage($grid, checkFlag, start, end);
        },
        LocalCheckPage: function ($grid, checkFlag, start, end) {
            var origRows = $grid.datagrid('getData').originalRows;
            var len = origRows.length;
            for (var i = 0; i < len; i++) {
                if (i < start) {
                    continue;
                }
                if (i >= end) {
                    break;
                }
                origRows[i].check = checkFlag;
            }
        },
        SameRows: function (gridID, sameFields) {
            var _gridID = gridID;
            var _personSameFields = sameFields;
            return {
                Hide: function () {
                    $('#' + _gridID)
                        .closest('.datagrid-view')
                        .find('[datagrid-row-index=0] .pivas-person-toggle')
                        .removeClass('pivas-person-toggle');
                    var $person = $('.pivas-person-toggle').closest('tr').children(_personSameFields).children();
                    $person.hide();
                    $person.css('white-space', 'nowrap');
                },
                HideRow: function (rowIndex) {
                    this.GetEle(rowIndex).hide();
                },
                ShowRow: function (rowIndex) {
                    this.Hide();
                    this.GetEle(rowIndex).show();
                },
                GetStat: function (rowIndex) {
                    var stat = this.GetEle(rowIndex).css('display') || '';
                    if (stat === '') {
                        return '';
                    }
                    return stat === 'block' ? 'show' : 'hide';
                },
                GetEle: function (rowIndex) {
                    var $ele = $('#' + _gridID)
                        .closest('.datagrid-view')
                        .find('[datagrid-row-index=' + rowIndex + ']')
                        .children(_personSameFields)
                        .children();
                    return $ele;
                },
                UpdateRow: function (rowIndex, rowData) {
                    var stat = this.GetStat(rowIndex);
                    $('#' + _gridID).datagrid('updateRow', {
                        index: rowIndex,
                        row: rowData
                    });
                    if (stat === 'show') {
                        this.ShowRow(rowIndex);
                    }
                    if (stat === 'hide') {
                        this.HideRow(rowIndex);
                    }
                }
            };
        },
        Init: function (gridId, options) {
            DHCPHA_HUI_COM.Grid.Init(gridId, options);
            $('#' + gridId)
                .closest('.datagrid-view')
                .find('.datagrid-body')
                .on('click', '.pivas-ord-sign', function (e) {
                    $(e.target).closest('tr').find('.pivas-ord-toggle').toggle();
                });
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
        var winDiv = '<div id="PogsNoWindowDiv" style="padding:10px;overflow:hidden;"><div id="gridPogsNo"></div></div>';
        var gridPogsNoBar =
            '<div id="gridPogsNoBar" style="padding:1px">' +
            '<table cellspacing="8"><tr>' +
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
                editable: true,
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
            fitColumns: true,
            singleSelect: true,
            nowrap: false,
            striped: false,
            pagination: true,
            rownumbers: false,
            toolbar: '#gridPogsNoBar',
            columns: [
                [
                    {
                        field: 'psName',
                        title: '��Һ״̬',
                        width: 100,
                        align: 'left'
                    },
                    {
                        field: 'pogsNo',
                        title: '����',
                        width: 200,
                        align: 'left'
                    },
                    {
                        field: 'pogsDate',
                        title: '��������',
                        width: 100,
                        align: 'left'
                    },
                    {
                        field: 'pogsTime',
                        title: '����ʱ��',
                        width: 150,
                        align: 'left'
                    },
                    {
                        field: 'pogsUserName',
                        title: '������',
                        width: 125,
                        align: 'left'
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
            minimizable: false,
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
        var winDiv = '<div id="OrdLinkWindowDiv" style="padding:10px;overflow:hidden;"><div id="gridOrdLink"></div></div>';
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
            maximizable: false,
            minimizable: false,
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
    // �鿴�������Ĵ���
    BatUpdatedWindow: function (_options) {
        var Params = _options.Params;
        var ParamArr = Params.split('^');
        var pJson = {};
        pJson.loc = ParamArr[3];
        pJson.startDate = ParamArr[0];
        pJson.endDate = ParamArr[1];
        pJson.adm = ParamArr[2];
        pJson.wardStr = ParamArr[4];
        pJson.locGrp = ParamArr[5];
        pJson.pivaCat = ParamArr[6];
        pJson.workType = ParamArr[7];
        pJson.priority = ParamArr[8];
        pJson.inci = ParamArr[9];
        pJson.packFlag = ParamArr[10];
        pJson.batNoStr = ParamArr[11];
        pJson.updateStat = ParamArr[12]; // ����״̬
        pJson.prtStat = ParamArr[13];
        var rowsData = $.cm(
            {
                ClassName: 'web.DHCSTPIVAS.BatUpdate',
                QueryName: 'OrdExeData',
                pJsonStr: JSON.stringify(pJson),
                rows: 9999,
                page: 1
            },
            false
        );
        if (rowsData.rows.length == 0) {
            $.messager.alert($g('��ʾ'), $g('û����Ҫչʾ������ҽ����Ϣ'), 'warning');
            return;
        }
        var winDivId = 'BatUpdatedWindowDiv';
        var winDiv = '<div id="BatUpdatedWindowDiv" style="padding:10px;overflow:hidden;"><div id="gridBatUpdated"></div></div>';
        $('body').append(winDiv);
        var dataGridOption = {
            border: false,
            singleSelect: true,
            nowrap: false,
            striped: false,
            pagination: false,
            rownumbers: false,
            fitColumns: true,
            columns: [
                [
                    {
                        field: 'doseDateTime',
                        title: '��ҩ����',
                        width: 98
                    },

                    {
                        field: 'batNo',
                        title: '����',
                        width: 75,
                        formatter: function (value, rowData, index) {
                            var styleArr = [];
                            var updHtmlArr = [];
                            var retHtmlArr = [];
                            if (rowData.updateFlag === 'Y') {
                                // ������
                                updHtmlArr.push('<div class="pivas-bat-done"></div>');
                            }

                            if (rowData.packFlag !== '') {
                                styleArr.push(PIVAS.Grid.CSS.BatchPack);
                            }
                            if (rowData.updateType === 'U') {
                                // �û��޸ĵ�,б��
                                styleArr.push('font-style: italic;font-weight: bold');
                            } else if (rowData.updateType === 'N') {
                                // ��ʿ�ӳٵ�,��ɫб��
                                styleArr.push('font-style: italic;font-weight: bold;color: #FF0000');
                            }
                            if (rowData.canUpdate === 'Y') {
                                styleArr.push('text-decoration:underline');
                            }
                            retHtmlArr.push('<div style="' + styleArr.join(';') + '">' + value + '</div>');
                            return updHtmlArr.join('') + retHtmlArr.join('');
                        },
                        styler: function (value, row, index) {
                            return 'position:relative';
                        }
                    },

                    {
                        field: 'drugsArr',
                        title: 'ҩƷ��Ϣ',
                        width: 300,
                        formatter: PIVAS.Grid.Formatter.InciGroup
                    },
                    {
                        field: 'dosage',
                        title: '����',
                        width: 75,
                        align: 'right',
                        formatter: PIVAS.Grid.Formatter.DosageGroup
                    },
                    {
                        field: 'qtyUom',
                        title: '����',
                        width: 75,
                        align: 'right',
                        formatter: PIVAS.Grid.Formatter.QtyUomGroup
                    },
                    {
                        field: 'liquid',
                        title: 'Һ����',
                        width: 75,
                        align: 'right'
                    },
                    {
                        field: 'useInfoObj',
                        title: '�÷�',
                        width: 300,
                        // formatter: FmtUseInfoData,
                        hidden: true
                    },
                    {
                        field: 'instrucDesc',
                        title: '�÷�',
                        width: 75
                    },
                    {
                        field: 'freqDesc',
                        title: 'Ƶ��',
                        width: 75
                    },
                    {
                        field: 'priDesc',
                        title: 'ҽ�����ȼ�',
                        width: 85
                    }
                ]
            ],
            onLoadSuccess: function () {}
        };
        DHCPHA_HUI_COM.Grid.Init('gridBatUpdated', dataGridOption);
        $('#gridBatUpdated').datagrid('loadData', rowsData);

        $('#BatUpdatedWindowDiv').window({
            title: '������ҽ��',
            collapsible: false,
            iconCls: 'icon-w-inv',
            border: false,
            closed: true,
            modal: true,
            width: 1200,
            height: 400,
            minimizable: false,
            onBeforeClose: function () {
                $('#BatUpdatedWindowDiv').remove();
            }
        });
        $("#BatUpdatedWindowDiv [class='panel datagrid']").css({
            border: '#cccccc solid 1px',
            'border-radius': '4px'
        });
        $('#BatUpdatedWindowDiv').window('open');
    },
    // ������˼�¼
    AuditRecordWindow: function (_options) {
        var dateMOeori = _options.dateMOeori || '';
        if (dateMOeori == '') {
            return;
        }
        var winDivId = 'OeAuditWindowDiv';
        var winDiv = '<div id="OeAuditWindowDiv" style="padding:10px;overflow:hidden;"><div id="gridOeAuditRecord"></div></div>';
        $('body').append(winDiv);
        //������
        var columns = [
            [
                {
                    field: 'passResult',
                    title: '���״̬',
                    width: 100,
                    styler: function (value, row, index) {
                        var passResultFlag = row.passResultFlag;
                        if (row.cancelDateTime !== '') {
                            return { class: 'pha-pivas-state-cancel datagrid-cell-valign-middle' };
                        }
                        if (passResultFlag === 'Y') {
                            return { class: 'pha-pivas-state-pass datagrid-cell-valign-middle' };
                        }
                        if (passResultFlag === 'N' || passResultFlag === 'NY') {
                            return { class: 'pha-pivas-state-refuse datagrid-cell-valign-middle' };
                        }
                        if (passResultFlag === 'NA') {
                            return { class: 'pha-pivas-state-appleal datagrid-cell-valign-middle' };
                        }
                        if (passResultFlag === 'CANCEL') {
                            return { class: 'pha-pivas-state-cancel datagrid-cell-valign-middle' };
                        }
                    }
                },
                {
                    field: 'userName',
                    title: '������',
                    width: 90,
                    formatter: function (value, row, index) {
                        return '<div style="height:100%;">' + value + '</div>';
                    },
                    styler: function (value, row, index) {
                        return { class: 'datagrid-cell-valign-middle' };
                    }
                },
                {
                    field: 'dateTime',
                    title: '����ʱ��',
                    width: 155,
                    styler: function (value, row, index) {
                        return { class: 'datagrid-cell-valign-middle' };
                    }
                },
                {
                    field: 'reasonDesc',
                    title: '����ԭ��',
                    width: 250,
                    formatter: function (value, row, index) {
                        return '<div style="width=250px;word-break:break-all;word-wrap:break-word;white-space:pre-wrap;">' + value + '</div>';
                    },
                    styler: function (value, row, index) {
                        return { class: 'datagrid-cell-valign-middle' };
                    }
                },
                {
                    field: 'docAgree',
                    title: 'ҽ������',
                    width: 70,
                    styler: function (value, row, index) {
                        return { class: 'datagrid-cell-valign-middle' };
                    }
                },
                {
                    field: 'docNotes',
                    title: 'ҽ������',
                    width: 80,
                    styler: function (value, row, index) {
                        return { class: 'datagrid-cell-valign-middle' };
                    }
                },
                {
                    field: 'oeoriStat',
                    title: 'ҽ��״̬',
                    width: 70,
                    styler: function (value, row, index) {
                        return { class: 'datagrid-cell-valign-middle' };
                    }
                },
                {
                    field: 'cancelUserName',
                    title: 'ȡ����',
                    width: 90,
                    styler: function (value, row, index) {
                        return { class: 'datagrid-cell-valign-middle' };
                    }
                },
                {
                    field: 'cancelDateTime',
                    title: 'ȡ��ʱ��',
                    width: 155,
                    styler: function (value, row, index) {
                        return { class: 'datagrid-cell-valign-middle' };
                    }
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
            nowrap: true,
            autoRowHeight: true
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
            maximizable: false,
            minimizable: false,
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
        html += '<div id=' + winId + ' style="padding:20px;text-align:center;overflow:hidden;">';
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
                    if (_options.onClose) {
                        _options.onClose();
                    }
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
        var chartBookID = tkMakeServerCall('web.DHCSTPIVAS.Common', 'GetChartBookID');
        websys_showModal({
            id: 'PHA_PIVAS_COM_ViewEMRWindow',
            url: 'websys.chartbook.hisui.csp?FixedEpisodeID=' + _admId + '&ChartBookID=' + chartBookID,
            //url:'websys.chartbook.hisui.csp?EpisodeID='+_admId+'&ChartBookID=' + chartBookID + '&PatientListPanel=emr.browse.episodelist.csp&PatientListPage=emr.browse.patientlist.csp&SwitchSysPat=N',
            title: '�������',
            width: '85%',
            height: '85%',
            closable: true,
            iconCls: 'icon-w-list',
            onClose: function () {} // ����ȥ��,����Ĭ�����ٴ���
        });
        return;

        var winId = 'PIVAS_UX_ViewEMR';
        if (($('#' + winId).html() || '') == '') {
            var diagHtml = '';
            diagHtml += '<div id="' + winId + '" class="hisui-dialog"  title="�������">';
            diagHtml += '   <div class="hisui-layout" fit="true" border="false">';
            diagHtml += '       <div data-options=\'region:"center"\' border="false" class="dhcpha-hisui-container">';
            diagHtml += '           <div class="hisui-layout" fit="true" border="false">';
            diagHtml +=
                '               <div id="' +
                winId +
                '-lyWinCen' +
                '" data-options=\'region:"center",split:true,headerCls:"panel-header-gray",bodyCls:"panel-body-gray"\' border="true" style="border-radius: 4px;">';
            diagHtml += '                   <div class="hisui-tabs tabs-gray" fit="true" id="' + winId + '-tabsEMR" border="false">';
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
            var wHeight = document.body.clientHeight - 20;
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
                onClose: function () {
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

                    /* MaYuqiang 20220517 ��������Ϣ����ͷ�˵����������ý��洮���� */
                    var menuWin = websys_getMenuWin(); // ���ͷ�˵�Window����
                    if (menuWin) {
                        var frm = dhcsys_getmenuform(); //menuWin.document.forms['fEPRMENU'];
                        if (frm && frm.EpisodeID.value != admId) {
                            if (menuWin.MainClearEpisodeDetails) menuWin.MainClearEpisodeDetails(); //���ͷ�˵������в��������Ϣ
                            frm.EpisodeID.value = admId;
                            frm.PatientID.value = patId;
                        }
                    }

                    if (title == '�������') {
                        if ($('#' + winId + '-ifrmEMR').attr('src') == '') {
                            //$('#' + winId + '-ifrmEMR').attr('src', 'emr.browse.csp' + '?EpisodeID=' + admId);
                            $('#' + winId + '-ifrmEMR').attr('src', 'emr.browse.manage.csp' + '?EpisodeID=' + admId);
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
        $('#' + winId + '-ifrmEMR').attr('src', 'emr.browse.manage.csp' + '?EpisodeID=' + _admId);
    },
    // ����ҽԺ����
    AddHospCom: function (_options, _pluginOptions) {
        var tableName = _options.tableName || '';
        if (tableName === '') {
            $.messager.alert('��ʾ', '�������,δ����Ȩ���������', 'error');
            return;
        }
        var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
        if (hospAutFlag === 'Y') {
            if ($('#_HospList').length == 0) {
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
                        '           <label id="_HospListLabel" style="color:red;">' +
                        $g('ҽԺ') +
                        '</label>' +
                        '       </div>' +
                        '       <div class="pha-col">' +
                        '           <input id="_HospList" class="textbox"/>' +
                        '       </div>' +
                        '   </div>' +
                        '</div>'
                });
            }
            var defHosp = $.cm(
                {
                    dataType: 'text',
                    ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
                    MethodName: 'GetDefHospIdByTableName',
                    tableName: 'tableName',
                    HospID: session['LOGON.HOSPID']
                },
                false
            );
            HospId = defHosp;

            var genHospObj = GenHospComp(tableName, '', _pluginOptions || {});
            return genHospObj;
        } else {
            return '';
        }
    },
    // ���׷�������
    Notify: function () {
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
    },
    GetRowsTotal: function (rowsArr, field) {
        var len = rowsArr.length;
        var total = 0;
        var mainArr = [];
        for (var i = 0; i < len; i++) {
            var main = rowsArr[i][field];
            if (mainArr.indexOf(main) < 0) {
                mainArr.push(main);
                total = total + 1;
            }
        }
        return total;
    },
    CheckAll: function ($grid) {
        PIVAS.Grid.LocalCheckPage($grid, 'Y', 0, 99999);
        $grid.datagrid('checkAll');
    },
    UnCheckAll: function ($grid) {
        PIVAS.Grid.LocalCheckPage($grid, 'N', 0, 99999);
        $grid.datagrid('uncheckAll');
    },
    // ���׻�ɫ
    MixColor: {
        History: [],
        Mix: function (valArr) {
            if (valArr.length === 0) {
                return '';
            }
            var valKey = valArr.join(',');
            if (this.History[valKey]) {
                return this.History[valKey];
            }
            var len = valArr.length;
            var rVal = 0,
                gVal = 0,
                bVal = 0;
            var rMaxVal = '',
                gMaxVal = '',
                bMaxVal = '';
            for (var i = 0; i < len; i++) {
                var val = valArr[i].substr(1, 6);

                rVal = parseInt(val.substr(0, 2), 16);
                gVal = parseInt(val.substr(2, 2), 16);
                bVal = parseInt(val.substr(4, 2), 16);

                if (i === 0) {
                    rMaxVal = parseInt(val.substr(0, 2), 16);
                    gMaxVal = parseInt(val.substr(2, 2), 16);
                    bMaxVal = parseInt(val.substr(4, 2), 16);
                } else {
                    if (rVal < rMaxVal) {
                        rMaxVal = rVal;
                    }
                    if (gVal < gMaxVal) {
                        gMaxVal = gVal;
                    }
                    if (bVal < bMaxVal) {
                        bMaxVal = bVal;
                    }
                }
            }

            var rValx16 = rMaxVal.toString(16);
            var gValx16 = gMaxVal.toString(16);
            var bValx16 = bMaxVal.toString(16);

            var color = '#' + rValx16 + gValx16 + bValx16;
            this.History[valKey] = color;
            return color;
        }
    },
    /**
     * ȫ��
     */
    FullScreen: function () {
        // IE: ����frame�Ĵ�����Ϊtrue����
        window.top.document.getElementsByName('TRAK_main')[0].setAttribute('allowfullscreen', true);
        window.frameElement.setAttribute('allowfullscreen', true);
        var element = document.querySelector('body');
        ['requestFullscreen', 'mozRequestFullScreen', 'webkitRequestFullscreen', 'msRequestFullscreen'].every(function (value) {
            if (element[value]) {
                element[value]();
                return false;
            }
            return true;
        });
    },
    /**
     * �˳�ȫ��
     */
    ExitFull: function () {
        ['exitFullscreen', 'mozExitFullscreen', 'webkitExitFullscreen', 'msExitFullscreen'].every(function (value) {
            if (document[value]) {
                document[value]();
                return false;
            }
            return true;
        });
    },
    CACert: function (modelName, _callback) {
        var logonType = ''; //��¼���ͣ�UKEY|PHONE|FACE|SOUND|"" ��ʱ��������ǩ����ʽ
        var singleLogon = 0; //�Ƿ񵯳�����¼��ʽ: 0-������ҳǩǩ����1-����ǩ����ʽ
        var forceOpen = 0; //   ǿ�Ƶ���ǩ������(Ĭ��0:û�е�¼���򵯳�����¼���򲻵���;1:ǿ�Ƶ���ǩ������)

        dhcsys_getcacert({
            modelCode: modelName /*ǩ��ģ���д���*/,
            callback: function (cartn) {
                // ǩ�����ڹرպ�,���������
                if (cartn.IsSucc) {
                    if (cartn.ContainerName == '') {
                        _callback(); //CA  δ����
                    } else {
                        if ('object' == typeof cartn && cartn.ContainerName !== '') {
                            _callback(); // д�����ҵ�����
                        }
                    }
                } else {
                    alert('ǩ��ʧ�ܣ�');
                    return false;
                }
            }
            //isHeaderMenuOpen:true, //�Ƿ���ͷ�˵���ǩ������. Ĭ��true
            //SignUserCode:"YF01",   //����ǩ����HIS���ţ���У��֤���û���HIS����. Ĭ�Ͽ�
            //signUserType:"",   // Ĭ�Ͽգ���ʾǩ���û��뵱ǰHIS�û�һ�¡�ALLʱ����֤�û���֤��
            //notLoadCAJs:1,  //��¼�ɹ��󣬲���ͷ�˵�����CA
            //loc:deptDesc,   //����id��������Ĭ�ϵ�ǰ��¼����
            //groupDesc:groupDesc,  //��ȫ��������Ĭ�ϵ�ǰ��¼��ȫ��
            //caInSelfWindow:1  //�û���¼���л����ҹ��ܣ� ҵ���鲻��
        });
    },
    /**
     * ��ȡ�ͻ�������
     */
    GetDate: function (dateVal) {
        var dateVal = (dateVal || '').trim().toUpperCase();
        var _fn = {
            getDate: function (d) {
                return d.getFullYear();
            },
            getMon: function (d) {
                return (d.getMonth() + 1).toString().length < 2 ? '0' + (d.getMonth() + 1) : d.getMonth() + 1;
            },
            getDay: function (d) {
                return d.getDate().toString().length < 2 ? '0' + d.getDate() : d.getDate();
            }
        };
        var _format = function (_year, _month, _day) {
            if (typeof dtformat !== 'undefined') {
                if (dtseparator === '/') {
                    return [_day, _month, _year].join('/');
                }
            }
            return [_year, _month, _day].join('-');
        };
        var myDate = new Date();
        var year = _fn.getDate(myDate);
        var month = _fn.getMon(myDate);
        var day = _fn.getDay(myDate);
        if (dateVal == 'S') {
            return _format(year, month, '01');
        }
        if (dateVal == 'L') {
            return _format(year, month, this.GetLastDay(year, month));
        }
        if (dateVal.indexOf('+') >= 0) {
            var newDate = new Date(myDate.getTime() + 24 * 60 * 60 * 1000 * dateVal.split('+')[1]);
            return _format(_fn.getDate(newDate), _fn.getMon(newDate), _fn.getDay(newDate));
        }
        if (dateVal.indexOf('-') >= 0) {
            var newDate = new Date(myDate.getTime() - 24 * 60 * 60 * 1000 * dateVal.split('-')[1]);
            return _format(_fn.getDate(newDate), _fn.getMon(newDate), _fn.getDay(newDate));
        }
        return _format(year, month, day);
    },
    /**
     * ��ȡ�ͻ���ʱ��
     */
    GetTime: function (timeVal, showDate) {
        var _fn = {
            getTime: function (seconds) {
                var hours = Math.floor(seconds / 3600);
                hours = hours.toString().length == 1 ? '0' + hours : hours;
                var minutes = Math.floor((seconds % 3600) / 60);
                minutes = minutes.toString().length == 1 ? '0' + minutes : minutes;
                var rSeconds = (seconds % 3600) % 60;
                rSeconds = rSeconds.toString().length == 1 ? '0' + rSeconds : rSeconds;
                return hours + ':' + minutes + ':' + rSeconds;
            },
            addZero: function (v) {
                return v.toString().length < 2 ? '0' + v : v;
            }
        };
        var timeVal = (timeVal || '').trim().toUpperCase();
        var myDate = new Date();
        var hours = myDate.getHours(); // (0-23)
        var minutes = myDate.getMinutes(); // (0-59)
        var seconds = myDate.getSeconds(); // (0-59)
        var curTime = _fn.addZero(hours) + ':' + _fn.addZero(minutes) + ':' + _fn.addZero(seconds);
        if (timeVal == '' || timeVal == 'T') {
            return showDate == 'Y' ? this.GetDate('t') + ' ' + curTime : curTime;
        }
        if (timeVal == 'S') {
            return showDate == 'Y' ? this.GetDate('t') + ' ' + '00:00:00' : '00:00:00';
        }
        if (timeVal == 'L') {
            return showDate == 'Y' ? this.GetDate('t') + ' ' + '23:59:59' : '23:59:59';
        }
        var addDays = 0;
        seconds = hours * 60 * 60 + minutes * 60 + seconds;
        var remainSeconds = seconds;
        // ��������
        if (timeVal.indexOf('+') >= 0) {
            var newSeconds = seconds + parseInt(timeVal.split('+')[1]);
            var remainSeconds = newSeconds;
            if (newSeconds > 86399) {
                addDays = Math.floor(newSeconds / 86400);
                remainSeconds = newSeconds % 86400;
            }
            return showDate == 'Y' ? this.GetDate('t+' + addDays) + ' ' + _fn.getTime(remainSeconds) : _fn.getTime(remainSeconds);
        }
        // ��������
        if (timeVal.indexOf('-') >= 0) {
            var newSeconds = seconds + parseInt(timeVal.split('-')[1]);
            var remainSeconds = newSeconds;
            if (newSeconds > 86399) {
                addDays = Math.floor(newSeconds / 86400);
                remainSeconds = newSeconds % 86400;
            }
            return showDate == 'Y' ? this.GetDate('t-' + addDays) + ' ' + _fn.getTime(remainSeconds) : _fn.getTime(remainSeconds);
        }
        return showDate == 'Y' ? this.GetDate('t') + ' ' + curTime : curTime;
    },
    /**
     * ��ȡ�������ļ�������, Ŀǰ�����ڻ�ȡ��ӡģ��
     * @param {} fileName ���·�����ļ���ȫ��
     * PIVAS.GetFileContent('dhcpha.pivas.temp.wardbat.inci.csp')
     */
    GetFileContent: (function (fileName) {
        var file_arr = {};
        return function (fileName) {
            if (!file_arr[fileName]) {
                var data = $.ajax({
                    type: 'GET',
                    url: fileName,
                    data: 'data',
                    dataType: 'json',
                    async: false
                });
                file_arr[fileName] = data.responseText;
            }
            return file_arr[fileName];
        };
    })(),
    GetScrollBarWidth: function () {
        if ($('#PIVAS_GetScrollBarWidth').length === 0) {
            $('body').append('<div id="PIVAS_GetScrollBarWidth" style="width:100px;height:100px;overflow-y:auto;"><div style="width:100%;height:200px;"></div></div>');
        }
        return $('#PIVAS_GetScrollBarWidth')[0].offsetWidth - $('#PIVAS_GetScrollBarWidth')[0].scrollWidth;
    },
    TriggerBox: {
        Init: function (id, options) {
            $HUI.triggerbox('#' + id, options);
            $('#' + id)
                .next()
                .find('.triggerbox-text')
                .on('blur', function () {
                    if ($('#' + id).triggerbox('getValue') == '') {
                        $('#' + id).triggerbox('setValueId', '');
                    }
                });
        }
    },
    PhcCat: function (_id, _opts, _callBack) {
        var _winDivId = _id + '_PIVAS_DHCPHCCat';
        var _tgId = _id + '_PIVAS_DHCPHCCat_TG';
        var _winToolBarId = _id + '_PIVAS_DHCPHCCat_TG_BAR';
        var _barAliasId = _id + '_bar';
        if ($('#' + _winDivId).text() == '') {
            var _winDiv =
                '<div id=' +
                _winDivId +
                ' style="padding:10px;overflow:hidden;">' +
                '<div class="hisui-layout" fit="true"><div data-options="region:\'north\',border:false,split:true,height:50">' +
                '<div id=' +
                _winToolBarId +
                ' style="padding-bottom:10px;border-bottom:none;"><input id=' +
                _barAliasId +
                ' /></div></div>' +
                '<div data-options="region:\'center\',split:true" style="height:400px;border:1px solid black;border-radius:4px;border-color:#CCC ">' +
                '<div id=' +
                _tgId +
                ' style="padding-left:10px;">ee</div></div></div></div>';
            var _winToolBarDiv = ''; // '<div id=' + _winToolBarId + ' style="padding:10px;border-bottom:none;"><input id=' + _barAliasId + '></div>';
            $('body').append(_winDiv);
            //$('body').append(_winToolBarDiv);
            var _treeColumns = [
                [
                    {
                        field: 'phcCatDesc',
                        title: 'ҩѧ����',
                        width: 300
                    },
                    {
                        field: 'phcCatDescAll',
                        title: 'ҩѧ����ȫ��',
                        width: 300,
                        hidden: true
                    },
                    {
                        field: 'phcCatId',
                        title: 'phcCatId',
                        hidden: true
                    },
                    {
                        field: '_parentId',
                        title: 'parentId',
                        hidden: true
                    }
                ]
            ];
            $('#' + _tgId).treegrid({
                animate: true,
                border: false,
                fit: true,
                nowrap: true,
                fitColumns: true,
                singleSelect: true,
                idField: 'phcCatId',
                treeField: 'phcCatDesc',
                rownumbers: false, // �к�
                columns: _treeColumns,
                showHeader: false,
                url: $URL,
                queryParams: {
                    ClassName: 'PHA.STORE.Drug',
                    QueryName: 'DHCPHCCat',
                    page: 1,
                    rows: 9999
                },
                // toolbar:'', // '#' + _winToolBarId,
                onDblClickRow: function (rowIndex, rowData) {
                    $('#' + _winDivId).window('close');
                    _callBack(rowData);
                }
            });
        }
        $('#' + _winDivId)
            .window({
                title: 'ҩѧ����',
                collapsible: false,
                iconCls: 'icon-w-list',
                maximizable: false,
                minimizable: false,
                border: false,
                closed: true,
                modal: true,
                width: 600,
                height: 500,
                onBeforeClose: function () {
                    // $("#UpdateBatNoWindowDiv").remove()
                }
            })
            .window('open');
        $('#' + _barAliasId).searchbox({
            width: $('#' + _winToolBarId).width(),
            searcher: function (text) {
                $('#' + _tgId).treegrid('options').queryParams.InputStr = text;
                $('#' + _tgId).treegrid('reload');
                $('#' + _barAliasId).searchbox('clear');
                $('#' + _barAliasId)
                    .next()
                    .children()
                    .focus();
            }
        });
        $('#' + _barAliasId)
            .next()
            .find('.searchbox-text')
            .attr('placeholder', $g('����������س���ѯ') + '...');
        $('#' + _tgId)
            .prev()
            .find('.datagrid-header')
            .css('border', 0);
    }
};

if (typeof $got === 'undefined') {
    function $got(pStr) {
        return pStr + '<!>';
    }
}
