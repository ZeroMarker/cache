/**
 * ����:	 ҩ��-ҩƷ��Ϣά��-���Ƴ�ʼ��
 * ��д��:	 yunhaibao
 * ��д����: 2019-05-09
 */
PHA_COM.App.Csp = 'pha.in.v3.drug.csp';
PHA_COM.App.Name = 'IN.DRUG';
PHA_COM.App.Load = '';
PHA_COM.ResizePhaColParam.auto = false;
PHA_COM.Param.App = $.cm(
    {
        ClassName: 'PHA.IN.Drug.Query',
        MethodName: 'GetParamProp',
        LogonStr: PHA_COM.Session.ALL,
        dataType: 'json'
    },
    false
);
DRUG_TOOLTIP = $.cm(
    {
        ClassName: 'PHA.COM.BDP',
        MethodName: 'ToolTip',
        Code: 'pha.in.v3.drug.csp',
        dataType: 'json'
    },
    false
);
DRUG_SwitchType = ''; // ����ҽ���������������ʱ�Ƿ�Ĭ��ѡ��
$(function () {
    InitHospCombo(); //����ҽԺ
    // tab�¼�
    $('#tabsDrug').tabs('options').onSelect = function (title, index) {
        if (title == 'ҩƷ��Ϣ') {
            return;
        }
        $("[name='divDrug']").hide();
        $('#panelDetail').panel('setTitle', title);
        if (title == 'ҽ����') {
            if ($('#divARCItmMast').text().trim() == '') {
                $('#divARCItmMast').append($('#scrArcItmMast').html());
                $('#divARCItmMast').show();
                // ��show�ٽ���,���򲼾����ҵ�
                ARCITMMAST();
            } else {
                $('#divARCItmMast').show();
            }
        } else if (title == '�����') {
            if ($('#divINCItm').text().trim() == '') {
                $('#divINCItm').append($('#scrINCItm').html());
                $('#divINCItm').show();
                INCITM();
            } else {
                $('#divINCItm').show();
            }
        } else if (title == '����ͨ����') {
            if ($('#divPHCGeneric').text().trim() == '') {
                $('#divPHCGeneric').append($('#scrPHCGeneric').html());
                $('#divPHCGeneric').show();
                PHCGENERIC();
            } else {
                $('#divPHCGeneric').show();
            }
        } else if (title == 'ҩѧ����') {
            if ($('#divDHCPHCCat').text().trim() == '') {
                $('#divDHCPHCCat').append($('#scrDHCPHCCat').html());
                $('#divDHCPHCCat').show();

                DHCPHCCAT();
            } else {
                $('#divDHCPHCCat').show();
            }
        } else if (title == 'Ʒ��ͨ����') {
            if ($('#divDHCPHChemical').text().trim() == '') {
                $('#divDHCPHChemical').append($('#scrDHCPHChemical').html());
                $('#divDHCPHChemical').show();
                DHCPHCHEMICAL();
            } else {
                $('#divDHCPHChemical').show();
            }
        } else if (title == 'ҩƷ�ֵ�') {
            if ($('#divDrug').text().trim() == '') {
                $('#divDrug').append($('#scrDrugDict').html());
                $('#divDrug').show();
                $.parser.parse($('#lyDrugDict').parent());

                InitDrug();
            } else {
                $('#divDrug').show();
            }
        }
    };
    $('#tabsDrug').tabs('disableTab', 0);

    var selTab = '�����';
    $.each($('#tabsDrug').tabs('tabs'), function (indexInArray, valueOfElement) {
        var title = valueOfElement.panel('options').title;
        if (title == PHA_COM.Param.App.DefaultTab) {
            selTab = title;
        }
    });
    if (FORONE === true) {
        selTab = 'ҩƷ�ֵ�';
    }
    $('#tabsDrug').tabs('select', selTab);
    $('.layout-split-east').unbind();
});

function InitKeyWords() {}
function InitTreePHCCat() {
    PHA.Tree('treePHCCat', {});
    $.cm(
        {
            ClassName: 'PHA.STORE.Drug',
            MethodName: 'GetDHCPHCCatTree',
            ParentId: ''
        },
        function (data) {
            $('#treePHCCat').tree({
                data: data
            });
        }
    );
}

function MakeToolTip() {
    for (var forId in DRUG_TOOLTIP) {
        var tipInfo = DRUG_TOOLTIP[forId] || '';
        if (tipInfo == '') {
            continue;
        }
        $('[for=' + forId + ']').tooltip({
            content: tipInfo,
            position: 'left',
            showDelay: 500
        });
    }
}

function InitHospCombo() {
    var hospAutFlag = tkMakeServerCall('PHA.FACE.IN.Com', 'GetHospAut');
    if (hospAutFlag === 'Y') {
        if (FORONE !== true) {
            $('#lyMainView').layout('add', {
                region: 'north',
                border: false,
                title: '',
                height: '40',
                bodyCls: 'pha-ly-hosp',
                content:
                    '<div style="padding-left:10px;">' +
                    '   <div class="pha-row">' +
                    '       <div class="pha-col">' +
                    '           <label id="_HospListLabel" style="color:red;" class="r-label">ҽԺ</label>' +
                    '       </div>' +
                    '   	<div class="pha-col">' +
                    '       	<input id="_HospList" class="textbox"/>' +
                    '   	</div>' +
                    '	</div>' +
                    '</div>'
            });
        }

        var genObj = GenHospComp('ARC_ItmMast');
        //����ѡ���¼�
        $('#_HospList').combogrid('options').onSelect = function (index, record) {
            var newHospId = record.HOSPRowId;
            var oldHospId = PHA_COM.Session.HOSPID;
            if (newHospId != oldHospId) {
                PHA_COM.Session.HOSPID = newHospId;
                PHA_COM.Session.ALL = PHA_COM.Session.USERID + '^' + PHA_COM.Session.CTLOCID + '^' + PHA_COM.Session.GROUPID + '^' + PHA_COM.Session.HOSPID;
                $('#divARCItmMast').empty();
                $('#divINCItm').empty();
                $('#divDrug').empty();
                var selTab = $('#tabsDrug').tabs('getSelected');
                var title = selTab.panel('options').title;
                if (title == 'ҽ����') {
                    $('#divARCItmMast').append($('#scrArcItmMast').html());
                    $('#divARCItmMast').show();
                    ARCITMMAST();
                } else if (title == '�����') {
                    $('#divINCItm').append($('#scrINCItm').html());
                    $('#divINCItm').show();
                    INCITM();
                } else if (title == 'ҩƷ�ֵ�') {
                    $('#divDrug').append($('#scrDrugDict').html());
                    $('#divDrug').show();
                    $.parser.parse($('#lyDrugDict').parent());

                    InitDrug();
                }
            }
        };
        var defHosp = $cm(
            {
                dataType: 'text',
                ClassName: 'web.DHCBL.BDP.BDPMappingHOSP',
                MethodName: 'GetDefHospIdByTableName',
                tableName: 'ARC_ItmMast',
                HospID: PHA_COM.Session.HOSPID
            },
            false
        );
        PHA_COM.Session.HOSPID = defHosp;
        PHA_COM.Session.ALL = PHA_COM.Session.USERID + '^' + PHA_COM.Session.CTLOCID + '^' + PHA_COM.Session.GROUPID + '^' + PHA_COM.Session.HOSPID;
    }
}

function InitHospButton() {
    var btnObj = GenHospWinButton('ARC_ItmMast');
    if (!btnObj) {
        return;
    }
    btnObj.options().onClick = function () {
        var rowData = $('#gridARCItmMast').datagrid('getSelected');
        if (rowData === null) {
            return;
        }

        InitHospWin('ARC_ItmMast', rowData.arcimId, HospWinCallback, { singleSelect: false });
    };
    // ѡ�лص�
    function HospWinCallback() {}
}

function InitHospWin(objectName, objectId, callback, opt) {
    if ($('#_HospListWin').length == 0) {
        $('<div id="_HospListWin" />').prependTo('body');
    }
    var singleSelect = false;
    if (opt) {
        singleSelect = opt.singleSelect || false;
    }
    var gridObj = '';
    var obj = $HUI.dialog('#_HospListWin', {
        width: 550,
        modal: true,
        height: 350,
        title: 'ҽԺȨ�޷���',
        content: '<table id="_HospListGrid"></table>',
        buttons: [
            {
                text: 'ȷ��',
                handler: function () {
                    var HospIDs = '';
                    var rows = gridObj.getData().rows;
                    var checkRow = gridObj.getChecked();
                    if (rows.length > 0) {
                        for (var i = 0; i < rows.length; i++) {
                            if ($.hisui.indexOfArray(checkRow, 'HOSPRowId', rows[i]['HOSPRowId']) == -1) {
                                HospIDs += '^' + rows[i]['HOSPRowId'] + '$N';
                            } else {
                                HospIDs += '^' + rows[i]['HOSPRowId'] + '$Y';
                            }
                        }
                    }
                    //����ҽԺ����
                    $cm({
                        ClassName: 'PHA.IN.Drug.Save',
                        MethodName: 'SaveHospMulti',
                        arcim: objectId,
                        hospStr: HospIDs
                    });
                    if ('function' == typeof callback) callback(checkRow);
                    $HUI.dialog('#_HospListWin').close();
                }
            },
            {
                text: 'ȡ��',
                handler: function () {
                    $HUI.dialog('#_HospListWin').close();
                }
            }
        ],
        onOpen: function () {
            gridObj = $HUI.datagrid('#_HospListGrid', {
                mode: 'remote',
                fit: true,
                border: false,
                pagination: false,
                showPageList: false,
                showRefresh: false,
                singleSelect: singleSelect,
                queryParams: { ClassName: 'web.DHCBL.BDP.BDPMappingHOSP', QueryName: 'GetHospDataForCloud', tablename: objectName, dataid: objectId },
                url: $URL,
                columns: [
                    [
                        { field: 'LinkFlag', title: '��Ȩ���', align: 'center', width: 100, checkbox: true },
                        { field: 'HOSPRowId', title: 'HOSPRowId', align: 'left', hidden: true, width: 100 },
                        { field: 'HOSPDesc', title: 'ҽԺ����', align: 'left', width: 300 },
                        { field: 'MappingID', title: 'ObjectId', align: 'left', hidden: true, width: 100 }
                    ]
                ],
                onLoadSuccess: function (row) {
                    var rowData = row.rows;
                    $.each(rowData, function (idx, val) {
                        if (val.LinkFlag == 'Y') {
                            $('#_HospListGrid').datagrid('selectRow', idx);
                        }
                    });
                }
            });
        }
    });
}

// һ��һģʽ
function InitDrug() {
    InitKeyWordDrugDict();

    ARCITMMAST();
    INCITM();
    $('.newScroll').mCustomScrollbar({
        theme: 'inset-2-dark',
        scrollInertia: 100,
        autoHideScrollbar: false,
        alwaysShowScrollbar: 1
    });

    var opts = $.extend({}, PHA_STORE.INCItm(''), {
        width: 300
    });
    PHA.LookUp('conInci', opts);
    $('#btnFindInci').unbind().on('click', QueryDrug);
    $('#btnAddDrug')
        .unbind()
        .on('click', function () {
            PHA.Confirm('��ʾ', '��ȷ��������?', function () {
                AddARCItmMast();
                AddINCItm();
                ARCItmMastControler();
                INCItmControler();
            });
        });
    $('#btnSaveDrug')
        .unbind()
        .on('click', function () {
            PHA.Confirm('��ʾ', '��ȷ�ϱ�����?', function () {
                SaveDrug('');
            });
        });
    $('#btnSaveAsDrug')
        .unbind()
        .on('click', function () {
            PHA.Confirm('��ʾ', '��ȷ�ϱ�����?', function () {
                SaveDrug('SaveAs');
            });
        });
    var cWidth = $('#js-layout-center').width();
    var pWidth = (cWidth - 40) / 2;
    var cell2Width = $('#arcimDesc').closest('.pha-drug-arc-text').position().left - $('#arcimCode').closest('.pha-drug-arc-text').position().left + 230;

    $('#phcPHCCat, #arcimOEMsg').width(cell2Width);
    $('#arcimAliasData, #inciAliasData, #inciISCData').width(cell2Width - 64);
    $('#inciRemark2').width(cell2Width - 240 - 64);
    $('#inciNotUseRea').combobox({ width: 237 });

    InitGridDrug();
}
function QueryDrug() {
    var inci = $('#conInci').lookup('getValue');
    var inciCode = $('#conInciCode').val();

    $.cm(
        {
            ClassName: 'PHA.IN.Drug.Query',
            MethodName: 'GetDrugID',
            pInci: inci,
            pInciCode: inciCode,
            pHosp: PHA_COM.Session.HOSPID
        },
        function (retData) {
            var inci = retData.inci || '';
            var arcim = retData.arcim || '';
            ARCITMMAST_RowId = arcim;
            INCITM_RowId = inci;
            if (inci !== '') {
                QueryARCItmMastDetail();
                QueryINCItmDetail();
            } else {
                // AddARCItmMast();
                //  AddINCItm();
                // ARCItmMastControler();
                //INCItmControler();
            }
        }
    );
}
function InitKeyWordDrugDict() {
    $('#kwDrugDict').keywords({
        singleSelect: true,
        onClick: function (v) {
            var vId = v.id;
            if (ARCITMMAST_RowId == '') {
                if (vId == 'kwARCItmMastLimit' || vId == 'kwARCItmMastSkinLink') {
                    PHA.Popover({
                        msg: 'û��ѡ��ҩƷ,�����������,���ȱ���',
                        type: 'alert'
                    });
                    // $("#kwARCItmMast").keywords("select", vId);
                }
            }
            if (vId === 'js-kw-all') {
                $("[class*='js-kw-']").show();
            } else {
                $("[class*='js-kw-']").hide();
                $('.' + vId).show();
                $('.pha-drug-chk-row').show();
            }

            //            $('#gridDHCArcItemAut').datagrid('resize', {
            //                width: 300,
            //                height: 300
            //            });
            //            $('#gridARCSKTINFO').datagrid('resize', {
            //                width: 300,
            //                height: 300
            //            });
            ARCITMMAST_KeyWord = vId;
        },
        items: [
            {
                text: 'ȫ����Ϣ',
                id: 'js-kw-all'
            },
            {
                text: 'ҽ�������Ϣ',
                id: 'js-kw-arc'
            },
            {
                text: 'ҩѧ�����Ϣ',
                id: 'js-kw-phc'
            },
            {
                text: '��������Ϣ',
                id: 'js-kw-inc'
            },
            {
                text: '�շ������Ϣ',
                id: 'js-kw-tar'
            },
            {
                text: '�׻���',
                id: 'js-kw-easyCon'
            },
            {
                text: 'ҩ����ҩ��λ',
                id: 'js-kw-dispUom'
            },
            {
                text: '�б���Ϣ',
                id: 'js-kw-pb'
            }
        ]
    });
    $('#kwDrugDict').keywords('select', 'js-kw-all');
}
function InitGridDrug() {
    var columns = [
        [
            {
                field: 'inciId',
                title: 'Id',
                width: 100,
                hidden: true
            },
            {
                field: 'inciCode',
                title: '����',
                width: 150
            },
            {
                field: 'inciDesc',
                title: '����',
                width: 300,
                formatter: function (value, row, index) {
                    return '<div style="overflow:hidden;white-space: normal;">' + value + '</div>';
                }
            },
            {
                field: 'inciSpec',
                title: '��װ���',
                width: 100
            },
            {
                field: 'inciRemark',
                title: '��׼�ĺ�',
                width: 150
            },
            {
                field: 'notUseFlag',
                title: '������',
                align: 'center',
                width: 65,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return '<font color="#f16e57">��</font>';
                    } else {
                        return '<font color="#21ba45">��</font>';
                    }
                }
            },
            {
                field: 'arcimDesc',
                title: 'ҽ��������',
                width: 300
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.INCItm.Query',
            QueryName: 'INCItm',
            IsNull: 'Y'
        },
        pagination: true,
        columns: columns,
        fitColumns: false,
        toolbar: '#gridDrugBar',
        enableDnd: false,
        onDblClickRow: function (rowIndex, rowData) {
            $('#conInci').lookup('setValue', rowData.inciId);
            $('#conInci').lookup('setText', rowData.inciDesc);
            QueryDrug();
        },
        onLoadSuccess: function (data) {
            // if (DRUG_SwitchType == "") {
            //     var pageSize = $("#gridINCItm")
            //         .datagrid("getPager")
            //         .data("pagination").options.pageSize;
            //     var total = data.total;
            //     if (data.curPage > 0 && total > 0 && total <= pageSize) {
            //         $("#gridINCItm").datagrid("selectRow", 0);
            //     }
            // } else {
            //     DRUG_SwitchType = "";
            // }
        }
    };
    PHA.Grid('gridDrug', dataGridOption);

    $("#diagDrugCon [class='panel datagrid']").css({
        border: '#cccccc solid 1px',
        'border-radius': '4px'
    });

    PHA.SearchBox('conInciAlias', {
        searcher: function (text) {
            var valsArr = PHA.DomData('#gridDrugBar', {
                doType: 'query'
            });
            valsArr[3] = $('#conInciAlias').searchbox('getValue');
            var valsStr = valsArr.join('^');
            $('#gridDrug').datagrid('query', {
                InputStr: valsStr,
                IsNull: '',
                HospId: PHA_COM.Session.HOSPID
            });
        },
        placeholder: ''
    });

    $('#btnInciMore').on('click', function () {
        $('#diagDrugCon').window('open');
    });

    $('#arcimCode').on('blur', function () {
        $('#inciCode, #tarCode').val($('#arcimCode').val());
    });
    $('#arcimDesc').on('blur', function () {
        $('#inciDesc, #tarDesc').val($('#arcimDesc').val());
    });
}

function SaveDrug(saveType) {
    var valsArr = PHA.DomData('.js-data-ARCItmMast', {
        doType: 'save',
        retType: 'Json'
    });
    var valsStr = valsArr.join('^');
    if (valsStr == '') {
        return;
    }

    var jsonDataStr = JSON.stringify(valsArr[0]);
    var saveRet = $.cm(
        {
            ClassName: 'PHA.IN.Drug.Save',
            MethodName: 'SaveDrug',
            pInci: saveType == '' ? INCITM_RowId : '',
            pArcim: saveType == '' ? ARCITMMAST_RowId : '',
            pArcimJsonStr: jsonDataStr,
            pInciJsonStr: jsonDataStr,
            pLogonStr: PHA_COM.Session.ALL,
            dataType: 'text'
        },
        false
    );
    if (saveRet.indexOf('msg') >= 0) {
        PHA.Alert('��ʾ', saveRet, 'error');
        return;
    }
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert('��ʾ', saveInfo, saveVal);
        return;
    } else {
        PHA.Popover({
            msg: saveType == '' ? '����ɹ�' : '���ɹ�',
            type: 'success'
        });
        $.cm(
            {
                ClassName: 'PHA.IN.Drug.Query',
                MethodName: 'GetDrugID',
                pInci: saveVal,
                pInciCode: '',
                pHosp: PHA_COM.Session.HOSPID
            },
            function (retData) {
                $('#conInci').lookup('setValue', retData.inci);
                $('#conInci').lookup('setText', retData.inciDesc);
                QueryDrug();
            }
        );
    }
}

