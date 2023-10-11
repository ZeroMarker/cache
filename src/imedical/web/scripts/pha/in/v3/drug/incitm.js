/**
 * @description ҩƷά��-�����
 */
var INCITM_RowId = '';
var INCITM_KeyWord = '';
var INCITM_Style = {
    ComboWidth: 237
};

function INCITM() {
    if (FORONE !== false) {
        $.parser.parse($('#lyINCItm').parent());
    }
    $.parser.parse($('#diagDHCItmStoreCond'));
    InitDictINCItm();
    InitGridINCItm();
    InitGridDHCIncilDispUom();
    InitGridDHCINCEasyConDesc();
    if (FORONE !== true) {
        InitKeyWordINCItm();
    }
    $('#btnCleanInci').on('click', ClrINCItm);
    $('#btnFindInci').on('click', QueryINCItm);
    $('#conInciAlias').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            QueryINCItm();
            $('#conInciAlias').focus().select();
        }
    });
    $('#btnMaxINCItm').on('click', function () {
        PHA_UX.MaxCode(
            {
                tblName: 'INC_Itm',
                codeName: 'INCI_Code',
                title: $g('��ѯ����������')
            },
            function (code) {
                $('#inciCode').val(code);
            }
        );
    });
    $('#btnAliasINCItm').on('click', AliasINCItm);
    $('#btnDHCItmStoreCond').on('click', DHCItmStoreCond);
    $('#btnAddINCItm').on('click', function () {
        PHA.Confirm($g('��ʾ'), $g('��ȷ��������?'), function () {
            AddINCItm();
            INCItmControler();
        });
    });
    $('#btnSaveINCItm').on('click', function () {
        if (PHA_COM.Param.App.SaveConfirm === 'Y') {
            PHA.ConfirmPrompt($g('������ʾ'), $g("��ȷ��<span style='font-weight:bold;'> ���� </span>�� ?"), function () {
                SaveINCItm('');
            });
        } else {
            var msgInfoArr = [];
            msgInfoArr.push($g('��ȷ�ϱ�����?'));
            if (INCITM_RowId !== '') {
                msgInfoArr.push('<div style="padding-top:5px;color:#F6704E;font-weight:bold;">ԭ�����ݽ�������</div>');
            }
            PHA.Confirm($g('������ʾ'), msgInfoArr.join(''), function () {
                SaveINCItm('');
            });
        }
    });
    $('#btnSaveAsINCItm').on('click', function () {
        PHA.Confirm($g('�����ʾ'), $g('��ȷ�������?'), function () {
            SaveINCItm('SaveAs');
        });
    });
    $('#btnUploadBook,#btnUploadImg').on('click', function (e) {
        if (INCITM_RowId == '') {
            PHA.Popover({
                msg: $g('����ѡ��ҩƷ,���Ϊ�����������ȱ���'),
                type: 'alert'
            });
            return;
        }
        var btnText = $(this).text();
        var type = btnText.indexOf($g('˵����')) >= 0 ? 'D' : 'P';
        var rowData = GetDHCItmDocStorage(INCITM_RowId, type);
        PHA_UPLOAD.Upload(
            {
                callBack: SaveDHCItmDocStorage,
                callBackKeyWord: SaveDHCItmDocStorageKeyWord,
                callBackDelete: DeleteDHCItmDocStorage,
                id: INCITM_RowId,
                type: type,
                keyWord: btnText.indexOf($g('˵����')) >= 0 ? $g('ҩƷ˵����') : $g('ҩƷͼƬ'),
                data: rowData
            },
            {
                title: btnText,
                width: 900,
                height: $(window).height() * 0.9
            }
        );
    });
    $('#btnPreviewBook').on('click', function () {
        if (INCITM_RowId == '') {
            PHA.Popover({
                msg: $g('����ѡ��ҩƷ'),
                type: 'alert'
            });
            return;
        }
        var rowsData = GetDHCItmDocStorage(INCITM_RowId);
        if (rowsData.rows.length == 0) {
            PHA.Popover({
                msg: $g('û�п�����ļ�'),
                type: 'alert'
            });
            return;
        }
        var btnText = $(this).text();
        PHA_UPLOAD.Preview(
            {
                data: rowsData
            },
            {
                title: btnText,
                width: $(window).width() * 0.9,
                height: $(window).height() * 0.9
            }
        );
    });
    if (PHA_COM.Param.App.ModDocInfoWayByInterface == 'Y') {
        $('#btnDHCItmRemark').on('click', DHCItmRemark);
        $('#inciRemark1').combobox('readonly', true);
        $('#inciRemark2').attr('readonly', true);
    } else {
        $('#btnDHCItmRemark').linkbutton('disable', true);
    }
    MakeToolTip();
}
/**
 * @description ����
 */
function ClrINCItm() {
    PHA.DomData('#gridINCItmBar', {
        doType: 'clear'
    });
    $('#conInciStat').combobox('setValue', 'ALL');
}

/**
 * @description ��ѯ���
 */
function QueryINCItm() {
    CleanINCItmDetail();
    var valsArr = PHA.DomData('#gridINCItmBar', {
        doType: 'query'
    });
    var valsStr = valsArr.join('^');
    $('#gridINCItm').datagrid('query', {
        InputStr: valsStr,
        IsNull: '',
        HospId: PHA_COM.Session.HOSPID
    });
}
/**
 * @description ��ʼ���ؼ���
 */
function InitKeyWordINCItm() {
    $('#kwINCItm').keywords({
        singleSelect: true,
        onClick: function (v) {
            if (v.id == 'kwINCItmAll') {
                $("[name='kwINCItmGrp']").show();
            } else {
                $("[name='kwINCItmGrp']").hide();
                $("[name='kwINCItmGrp']#" + v.id).show();
            }
            $('#gridDHCINCEasyConDesc').datagrid('resize', {
                width: 300,
                height: 300
            });
            $('#gridDHCIncilDispUom').datagrid('resize', {
                width: 300,
                height: 300
            });
        },
        items: [
            {
                text: $g('ȫ����Ϣ'),
                id: 'kwINCItmAll',
                selected: true
            },
            {
                text: $g('������Ϣ'),
                id: 'kwINCItmBase'
            },
            {
                text: $g('�շ�����Ϣ'),
                id: 'kwINCItmTar'
            },
            {
                text: $g('�׻���'),
                id: 'kwINCEasyConDesc'
            },
            {
                text: $g('ҩ����ҩ��λ'),
                id: 'kwINCItmDispUom'
            },
            {
                text: $g('�б���Ϣ'),
                id: 'kwINCItmPb'
            }
        ]
    });
    $('#kwINCItm').keywords('select', 'kwINCItmAll');
}

/**
 * @description ��ʼ�����������ֵ�
 */
function InitDictINCItm() {
    var opts = $.extend({}, PHA_STORE.ArcItmMast('Y'), {
        width: 419
    });
    PHA.LookUp('conInciArcim', opts);
    var opts = $.extend({}, PHA_STORE.ArcItmMast('Y'), {
        width: 588
    });
    PHA.LookUp('inciArcim', opts);
    PHA.ComboBox('conInciCatGrp', {
        panelHeight: 'auto',
        url: PHA_STORE.DHCStkCatGroup().url,
        onSelect: function (data) {
            $('#conInciStkCat').combobox('reload', PHA_STORE.INCStkCat().url + '&CatGrpId=' + data.RowId || '');
            $('#conInciStkCat').combobox('clear');
        },
        onChange: function (newVal, oldVal) {
            newVal = newVal || '';
            if (newVal === '') {
                $('#conInciStkCat').combobox('reload', PHA_STORE.INCStkCat().url + '&CatGrpId=""');
                $('#conInciStkCat').combobox('clear');
            }
        }
    });
    PHA.ComboBox('conInciStkCat', {
        width: 182,
        url: PHA_STORE.INCStkCat().url + '&CatGrpId=""'
    });
    PHA.ComboBox('conInciStat', {
        panelHeight: 'auto',
        width: 182,
        data: [
            {
                RowId: 'ALL',
                Description: $g('ȫ��')
            },
            {
                RowId: 'ACTIVE',
                Description: $g('������')
            },
            {
                RowId: 'STOP',
                Description: $g('������')
            },
            {
                RowId: 'EDORD',
                Description: $g('ҽ����ֹ')
            }
        ]
    });
    $('#conInciStat').combobox('setValue', 'ALL');
    // ѡ������λ��,������λ���ܳ�����������
    PHA.ComboBox('inciBUom', {
        url: PHA_STORE.CTUOM().url,
        width: INCITM_Style.ComboWidth,
        onSelect: function (data) {
            var newUrl = PHA_STORE.CTUOM().url + '&ToUomId=' + data.RowId;
            $('#inciPUom').combobox('reload', newUrl).combobox('clear');
            $('#inciOutUom').combobox('reload', newUrl).combobox('clear');
            $('#inciInUom').combobox('reload', newUrl).combobox('clear');
        }
    });
    // ������λ��ѡ��,������λ�Ͳ���ѡ
    PHA.ComboBox('inciPUom', {
        // url: PHA_STORE.CTUOM().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciOutUom', {
        // url: PHA_STORE.CTUOM().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciInUom', {
        // url: PHA_STORE.CTUOM().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciStkCat', {
        url: PHA_STORE.INCStkCat().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciMarkType', {
        url: PHA_STORE.DHCMarkType().url,
        width: INCITM_Style.ComboWidth,
        panelHeight: 'auto'
    });
    PHA.ComboBox('inciImport', {
        data: [
            {
                RowId: $g('����'),
                Description: $g('����')
            },
            {
                RowId: $g('����'),
                Description: $g('����')
            },
            {
                RowId: $g('����'),
                Description: $g('����')
            }
        ],
        width: INCITM_Style.ComboWidth,
        panelHeight: 'auto'
    });
    PHA.ComboBox('inciQualityLev', {
        url: PHA_STORE.DHCItmQualityLevel().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciRRReason', {
        url: PHA_STORE.DHCStkRefuseRetReason().url,
        width: INCITM_Style.ComboWidth
    });

    PHA.ComboBox('inciRemark1', {
        url: PHA_STORE.DHCSTOFFICODE('Gp').url,
        width: INCITM_Style.ComboWidth,
        panelHeight: 'auto'
    });

    PHA.DateBox('inciPriceDate', {
        width: INCITM_Style.ComboWidth
    });
    PHA.DateBox('inciPrcFileDate', {
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciNotUseRea', {
        url: PHA_STORE.DHCItmNotUseReason().url,
        width: 170
    });
    PHA.ComboBox('tarMCCateNew', {
        url: PHA_STORE.DHCTarMCCateNew().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('tarMCCate', {
        url: PHA_STORE.DHCTarMCCate().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('tarOutpatCate', {
        url: PHA_STORE.DHCTarOutpatCate().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('tarInpatCate', {
        url: PHA_STORE.DHCTarInpatCate().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('tarEMCCate', {
        url: PHA_STORE.DHCTarEMCCate().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('tarAcctCate', {
        url: PHA_STORE.DHCTarAcctCate().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('tarSubCate', {
        url: PHA_STORE.DHCTarSubCate().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ValidateBox('inciSp', {
        width: INCITM_Style.ComboWidth,
        validType: 'price',
        tipPosition: 'bottom',
        disabled: PHA_COM.Param.App.AllowInputSp == 'Y' ? false : true
    });
    PHA.ValidateBox('inciRp', {
        width: INCITM_Style.ComboWidth,
        validType: 'price',
        tipPosition: 'bottom',
        disabled: PHA_COM.Param.App.AllowInputRp == 'Y' ? false : true
    });
    PHA.ValidateBox('inciMaxSp', {
        validType: 'price',
        tipPosition: 'bottom',
        width: INCITM_Style.ComboWidth
    });
    PHA.ValidateBox('inciPbRp', {
        validType: 'price',
        tipPosition: 'bottom',
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciPbVendor', {
        url: PHA_STORE.APCVendor().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciPbManf', {
        url: PHA_STORE.PHManufacturer().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciManf', {
        url: PHA_STORE.PHManufacturer().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciPbCarrier', {
        url: PHA_STORE.DHCCarrier().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciPbList', {
        url: PHA_STORE.DHCPublicBiddingList().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciPbLevel', {
        url: PHA_STORE.DHCItmPBLevel().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciBookCat', {
        url: PHA_STORE.DHCSTBookCat().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciPackUom', {
        url: PHA_STORE.CTUOM().url,
        width: 120
    });
    PHA.NumberBox('inciPackUomFac', {
        width: 112,
        min: 0,
        placeholder: $g('��ⵥλϵ��')
    });
    PHA.ComboBox('inciOrigin', {
        url: PHA_STORE.DHCSTOrigin().url,
        width: INCITM_Style.ComboWidth
    });
    PHA.ComboBox('inciExpReq', {
        panelHeight: 'auto',
        width: INCITM_Style.ComboWidth,
        editable: false,
        data: [
            {
                RowId: 'R',
                Description: $g('Ҫ��')
            },
            {
                RowId: 'N',
                Description: $g('��Ҫ��')
            }
        ]
    });
    $('#inciExpReq').combobox('setValue', 'R');
    PHA.NumberBox('inciExpLen', {
        width: INCITM_Style.ComboWidth,
        min: 0,
        placeholder: ''
    });
    // ���۹������,�س�����
    $('#inciRp').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            if ($('#inciRp').validatebox('isValid') === false) {
                return;
            }
            var markType = $('#inciMarkType').combobox('getValue');
            var rp = $('#inciRp').val().trim();
            if (rp != '' && markType != '') {
                var retSp = tkMakeServerCall('web.DHCST.Common.PriceCommon', 'GetMTSpByMTRp', rp, markType);
                if (retSp != '' && retSp != 0) {
                    $('#inciSp').val(retSp);
                }
            }
        }
    });
}

/**
 * @description ��ʼ���������
 */
function InitGridINCItm() {
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
                title: $g('����'),
                width: 150
            },
            {
                field: 'inciDesc',
                title: $g('����'),
                width: 300
            },
            {
                field: 'inciSpec',
                title: $g('��װ���'),
                width: 100
            },
            {
                field: 'manfDesc',
                title: $g('������ҵ'),
                width: 150
            },
            {
                field: 'inciRemark',
                title: $g('��׼�ĺ�'),
                width: 150
            },
            {
                field: 'notUseFlag',
                title: $g('������'),
                align: 'center',
                width: 65,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return '<font color="#f16e57">' + $g('��') + '</font>';
                    } else {
                        return '<font color="#21ba45">' + $g('��') + '</font>';
                    }
                }
            },
            {
                field: 'catDesc',
                title: $g('������'),
                width: 100
            },
            {
                field: 'catGrpDesc',
                title: $g('����'),
                width: 100
            },
            {
                field: 'arcimDesc',
                title: $g('ҽ��������'),
                width: 300
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.INCItm.Query',
            QueryName: 'INCItm',
            IsNull: 'Y',
            HospId: PHA_COM.Session.HOSPID
        },
        pagination: true,
        columns: columns,
        fitColumns: false,
        toolbar: '#gridINCItmBar',
        enableDnd: false,
        onSelect: function (rowIndex, rowData) {
            INCITM_RowId = rowData.inciId;
            QueryINCItmDetail();
        },
        onDblClickRow: function (rowIndex, rowData) {
            SwitchFromINCItm(rowData.inciId, '');
        },
        onLoadSuccess: function (data) {
            if (DRUG_SwitchType == '') {
                var pageSize = $('#gridINCItm').datagrid('getPager').data('pagination').options.pageSize;
                var total = data.total;
                if (data.curPage > 0 && total > 0 && total <= pageSize) {
                    $('#gridINCItm').datagrid('selectRow', 0);
                }
            } else {
                DRUG_SwitchType = '';
            }
        }
    };
    PHA.Grid('gridINCItm', dataGridOption);
}
/**
 * @description ��ѯ�Ҳ���ϸ
 */
function QueryINCItmDetail() {
    INCItmControler();
    $.cm(
        {
            ClassName: 'PHA.IN.INCItm.Query',
            MethodName: 'SelectINCItm',
            InciId: INCITM_RowId,
            SessionStr: [PHA_COM.Session.HOSPID, PHA_COM.Session.CTLOCID, PHA_COM.Session.GROUPID, PHA_COM.Session.USERID].join('^'),
            ResultSetType: 'Array'
        },
        function (arrData) {
            PHA.DomData('.js-data-INCItm', {
                doType: 'clear'
            });
            if (arrData.msg) {
                PHA.Alert($g('������ʾ'), arrData.msg, 'error');
            } else {
                PHA.SetVals(arrData);
                $('#gridDHCIncilDispUom').datagrid('query', {
                    InciId: INCITM_RowId
                });
                $('#gridDHCINCEasyConDesc').datagrid('query', {
                    InciId: INCITM_RowId
                });
            }
        },
        function () {}
    );
}

/**
 * @description �洢����ά��
 */
function DHCItmStoreCond() {
    if (INCITM_RowId == '') {
        PHA.Popover({
            msg: $g('����ѡ������,��������������ȱ���'),
            type: 'alert'
        });
        return;
    }
    $('#diagDHCItmStoreCond')
        .dialog({
            iconCls: 'icon-w-edit',
            modal: true,
            buttons: [
                {
                    text: $g('����'),
                    handler: function () {
                        var valsArr = PHA.DomData('#diagDHCItmStoreCond', {
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
                                ClassName: 'PHA.IN.DHCItmStoreCond.Save',
                                MethodName: 'Save',
                                InciId: INCITM_RowId,
                                JsonDataStr: jsonDataStr,
                                dataType: 'text'
                            },
                            false
                        );
                        var saveArr = saveRet.split('^');
                        var saveVal = saveArr[0];
                        var saveInfo = saveArr[1];
                        if (saveVal < 0) {
                            PHA.Alert($g('��ʾ'), saveInfo, 'warning');
                            return;
                        } else {
                            PHA.Popover({
                                msg: $g('����ɹ�'),
                                type: 'success'
                            });
                        }
                        $('#diagDHCItmStoreCond').window('close');
                    }
                },
                {
                    text: $g('�ر�'),
                    handler: function () {
                        $('#diagDHCItmStoreCond').window('close');
                    }
                }
            ],
            onBeforeClose: function () {
                $.cm(
                    {
                        ClassName: 'PHA.IN.DHCItmStoreCond.Query',
                        MethodName: 'GetISCDataByInci',
                        InciId: INCITM_RowId,
                        dataType: 'text'
                    },
                    function (text) {
                        $('#inciISCData').val(text);
                    }
                );
            }
        })
        .dialog('open');

    PHA.DomData('#diagDHCItmStoreCond', {
        doType: 'clear'
    });
    $.cm(
        {
            ClassName: 'PHA.IN.DHCItmStoreCond.Query',
            MethodName: 'Select',
            InciId: INCITM_RowId,
            ResultSetType: 'Array'
        },
        function (arrData) {
            if (arrData.msg) {
                PHA.Alert($g('������ʾ'), arrData.msg, 'error');
            } else {
                PHA.SetVals(arrData);
            }
        }
    );
}

/**
 * @description ���Ҳ���ϸ
 */
function CleanINCItmDetail() {
    PHA.DomData('.js-data-INCItm', {
        doType: 'clear'
    });

    $('#gridDHCIncilDispUom').datagrid('clear');
    $('#gridDHCINCEasyConDesc').datagrid('clear');
    INCITM_RowId = '';
}
/**
 * @description ����ά��
 */
function AliasINCItm() {
    if (INCITM_RowId == '') {
        PHA.Popover({
            msg: $g('û��ѡ��ҩƷ,�����������,���ȱ���'),
            type: 'alert'
        });
        return;
    }
    PHA_UX.Alias(
        {
            title: $g('��������'),
            queryParams: {
                ClassName: 'PHA.IN.INCALIAS.Query',
                QueryName: 'INCALIAS',
                InciId: INCITM_RowId
            },
            saveParams: {
                ClassName: 'PHA.IN.INCALIAS.Save',
                MethodName: 'SaveMulti',
                InciId: INCITM_RowId
            },
            deleteParams: {
                ClassName: 'PHA.IN.INCALIAS.Save',
                MethodName: 'Delete'
            }
        },
        function (text) {
            $.cm(
                {
                    ClassName: 'PHA.IN.INCALIAS.Query',
                    MethodName: 'GetInciAliasStr',
                    InciId: INCITM_RowId,
                    dataType: 'text'
                },
                function (text) {
                    $('#inciAliasData').val(text);
                }
            );
        }
    );
}
/**
 * ��ҩ��λ
 */
function InitGridDHCIncilDispUom() {
    var ilduLoc = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: 'top',
        url: PHA_STORE.Pharmacy().url
    });
    var ilduUom = PHA.EditGrid.ComboBox({
        required: true,
        tipPosition: 'top',
        url: PHA_STORE.Url + 'ClassName=PHA.IN.DHCIncilDispUom.Query&QueryName=InciUOM',
        onBeforeLoad: function (param) {
            param.QText = param.q;
            param.InciId = INCITM_RowId;
        }
    });
    var columns = [
        [
            {
                field: 'ilduId',
                title: 'ilduId',
                width: 50,
                hidden: true
            },
            {
                field: 'ilduLoc',
                title: $g('ҩ��'),
                width: 200,
                descField: 'ilduLocDesc',
                editor: ilduLoc,
                formatter: function (value, row, index) {
                    return row.ilduLocDesc;
                }
            },
            {
                field: 'ilduLocDesc',
                title: $g('ҩ������'),
                width: 200,
                hidden: true
            },
            {
                field: 'ilduUom',
                title: $g('��λ'),
                width: 100,
                descField: 'ilduUomDesc',
                editor: ilduUom,
                formatter: function (value, row, index) {
                    return row.ilduUomDesc;
                }
            },
            {
                field: 'ilduActive',
                title: $g('����'),
                align: 'center',
                width: 50,
                editor: {
                    type: 'icheckbox',
                    options: {
                        on: 'Y',
                        off: 'N'
                    }
                },
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            },
            {
                field: 'ilduStDate',
                title: $g('��ʼ����'),
                width: 125,
                editor: {
                    type: 'datebox'
                }
            },
            {
                field: 'ilduEdDate',
                title: $g('��������'),
                width: 125,
                editor: {
                    type: 'datebox'
                }
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DHCIncilDispUom.Query',
            QueryName: 'DHCIncilDispUom'
        },
        pagination: false,
        columns: columns,
        fitColumns: false,
        autoRowHeight: true,
        toolbar: [
            {
                iconCls: 'icon-add',
                text: $g('����'),
                handler: function () {
                    if (INCITM_RowId == '') {
                        PHA.Popover({
                            msg: $g('û��ѡ��ҩƷ,�����������,���ȱ���'),
                            type: 'alert'
                        });
                        return;
                    }

                    $('#gridDHCIncilDispUom').datagrid('addNewRow', {
                        editField: 'ilduLoc',
                        defaultRow: {
                            ilduActive: 'Y'
                        }
                    });
                }
            },
            {
                iconCls: 'icon-save',
                text: $g('����'),
                handler: function () {
                    var $grid = $('#gridDHCIncilDispUom');
                    if ($grid.datagrid('endEditing') == false) {
                        PHA.Popover({
                            msg: $g('������ɱ�����'),
                            type: 'alert'
                        });
                        return;
                    }
                    var gridChanges = $grid.datagrid('getChanges');
                    var gridChangeLen = gridChanges.length;
                    if (gridChangeLen == 0) {
                        PHA.Popover({
                            msg: $g('û����Ҫ���������'),
                            type: 'alert'
                        });
                        return;
                    }
                    var inputStrArr = [];
                    for (var i = 0; i < gridChangeLen; i++) {
                        var iData = gridChanges[i];
                        if ($grid.datagrid('getRowIndex', iData) < 0) {
                            continue;
                        }
                        var params =
                            (iData.ilduId || '') +
                            '^' +
                            (iData.ilduLoc || '') +
                            '^' +
                            (iData.ilduUom || '') +
                            '^' +
                            (iData.ilduActive || '') +
                            '^' +
                            (iData.ilduStDate || '') +
                            '^' +
                            (iData.ilduEdDate || '');
                        inputStrArr.push(params);
                    }
                    var inputStr = inputStrArr.join('!!');
                    var saveRet = $.cm(
                        {
                            ClassName: 'PHA.IN.DHCIncilDispUom.Save',
                            MethodName: 'SaveMulti',
                            InciId: INCITM_RowId,
                            MultiDataStr: inputStr,
                            dataType: 'text'
                        },
                        false
                    );
                    var saveArr = saveRet.split('^');
                    var saveVal = saveArr[0];
                    var saveInfo = saveArr[1];
                    if (saveVal < 0) {
                        PHA.Alert($g('��ʾ'), saveInfo, saveVal);
                    } else {
                        PHA.Popover({
                            msg: $g('����ɹ�'),
                            type: 'success',
                            timeout: 1000
                        });
                        $grid.datagrid('reload');
                    }
                }
            },
            {
                iconCls: 'icon-cancel',
                text: $g('ɾ��'),
                handler: function () {
                    var $grid = $('#gridDHCIncilDispUom');
                    var gridSelect = $grid.datagrid('getSelected') || '';
                    if (gridSelect == '') {
                        PHA.Popover({
                            msg: $g('����ѡ����Ҫɾ���ļ�¼'),
                            type: 'alert'
                        });
                        return;
                    }
                    PHA.Confirm($g('ɾ����ʾ'), $g('��ȷ��ɾ����?'), function () {
                        var ilduId = gridSelect.ilduId || '';
                        var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
                        if (ilduId != '') {
                            var saveRet = $.cm(
                                {
                                    ClassName: 'PHA.IN.DHCIncilDispUom.Save',
                                    MethodName: 'Delete',
                                    IlduId: ilduId,
                                    dataType: 'text'
                                },
                                false
                            );
                            var saveArr = saveRet.split('^');
                            var saveVal = saveArr[0];
                            var saveInfo = saveArr[1];
                            if (saveVal < 0) {
                                PHA.Alert($g('��ʾ'), saveInfo, saveVal);
                                return;
                            } else {
                                PHA.Popover({
                                    msg: $g('ɾ���ɹ�'),
                                    type: 'success',
                                    timeout: 1000
                                });
                            }
                        }
                        $grid.datagrid('deleteRow', rowIndex);
                    });
                }
            }
        ],
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
        },
        onDblClickCell: function (rowIndex, field, value) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex
            });
        }
    };
    PHA.Grid('gridDHCIncilDispUom', dataGridOption);
}

/**
 * @description ����
 */
function AddINCItm() {
    if (FORONE !== true) {
        $('#gridINCItm').datagrid('clearSelections');
    }
    CleanINCItmDetail();
    if (FORONE !== true) {
        $('#inciArcim').focus();
    }
    INCITM_RowId = '';
    if (PHA_COM.Param.App.SetInitStatusNotUse == 'Y') {
        $('#inciNotUse').checkbox('setValue', true);
    }
}
/**
 * @description ����
 * @param {String} saveType
 */
function SaveINCItm(saveType) {
    var valsArr = PHA.DomData('.js-data-INCItm', {
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
            ClassName: 'PHA.IN.INCItm.Save',
            MethodName: 'SaveInciTar',
            InciId: saveType == '' ? INCITM_RowId : '',
            JsonDataStr: jsonDataStr,
            LogonStr: PHA_COM.Session.ALL,
            dataType: 'text'
        },
        false
    );
    if (saveRet.indexOf('msg') >= 0) {
        PHA.Alert($g('��ʾ'), saveRet, 'error');
        return;
    }
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert($g('��ʾ'), saveInfo, saveVal);
        return;
    } else {
        PHA.Popover({
            msg: saveType == '' ? $g('����ɹ�') : $g('���ɹ�'),
            type: 'success'
        });
        INCITM_RowId = saveVal;
        QueryINCItmDetail();
    }
}
/**
 * @description ���ƿɱ༭
 */
function INCItmControler() {
    var controlJson = $.cm(
        {
            ClassName: 'PHA.IN.INCItm.Query',
            MethodName: 'Controller',
            InciId: INCITM_RowId,
            dataType: 'json'
        },
        false
    );
    if (controlJson.CheckUsed == 'Y') {
        $('#inciBUom').combobox('readonly', true);
        $('#inciPUom').combobox('readonly', true);
        //$("#inciOutUom").combobox("readonly", true);
        //$("#inciInUom").combobox("readonly", true);
        $('#inciPriceDate').datebox('readonly', true);
        $('#inciRp').attr('readonly', true);
        $('#inciSp').attr('readonly', true);
        $('#inciManf').combobox('readonly', true);
    } else {
        $('#inciBUom').combobox('readonly', false);
        $('#inciPUom').combobox('readonly', false);
        //$("#inciOutUom").combobox("readonly", false);
        //$("#inciInUom").combobox("readonly", false);
        $('#inciPriceDate').datebox('readonly', false);
        $('#inciRp').attr('readonly', false);
        $('#inciSp').attr('readonly', false);
        $('#inciManf').combobox('readonly', false);
    }
    if (INCITM_RowId != '') {
        $('#inciRp').attr('readonly', true);
        $('#inciSp').attr('readonly', true);
        $('#inciPriceDate').datebox('readonly', true);
    } else {
        $('#inciRp').attr('readonly', false);
        $('#inciSp').attr('readonly', false);
        $('#inciPriceDate').datebox('readonly', false);
    }
    /* ҽ����Ϣȡֵ��ʽΪ����ҽ���ӿڻ�ȡҽ������ʱ��ҽ����������ƽ�����ѯ */
    var InsuInfoSource = tkMakeServerCall("PHA.FACE.IN.Com","GetInsuSourceByHospId", PHA_COM.Session.HOSPID, "DHC_TarItem")
    if (InsuInfoSource == "INSU"){
        $('#tarInsuCode').attr('readonly', true);
        $('#tarInsuDesc').attr('readonly', true);
    }

}

/**
 * @description �׻���
 */
function InitGridDHCINCEasyConDesc() {
    var options = {
        panelWidth: '500',
        required: false
    };
    options = $.extend({}, PHA_STORE.INCItm('Y'), options);
    options.queryParams.Hosp = PHA_COM.Session.HOSPID;
    DHCINCEasyConDesc_ConInci = PHA.EditGrid.ComboGrid(options);

    DHCINCEasyConDesc_Type = PHA.EditGrid.ComboBox({
        required: true,
        editable: false,
        panelHeight: 'auto',
        tipPosition: 'top',
        url: PHA_STORE.DHCINCEasyConDescType().url
    });
    var columns = [
        [
            {
                field: 'iecId',
                title: 'iecId',
                width: 50,
                hidden: true
            },
            {
                field: 'iecType',
                title: $g('�׻�������'),
                width: 100,
                descField: 'iecTypeDesc',
                editor: DHCINCEasyConDesc_Type,
                formatter: function (value, row, index) {
                    return row.iecTypeDesc;
                }
            },
            {
                field: 'iecTypeDesc',
                title: $g('�׻�����������'),
                width: 100,
                hidden: true
            },
            {
                field: 'iecConInci',
                title: $g('�׻���ҩƷ'),
                width: 300,
                hidden: false,
                descField: 'iecConInciDesc',
                editor: DHCINCEasyConDesc_ConInci,
                formatter: function (value, row, index) {
                    return row.iecConInciDesc;
                }
            },
            {
                field: 'iecConInciDesc',
                title: $g('�׻���ҩƷ����'),
                width: 300,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DHCINCEasyConDesc.Query',
            QueryName: 'DHCINCEasyConDesc'
        },
        pagination: false,
        columns: columns,
        fitColumns: true,
        toolbar: [
            {
                iconCls: 'icon-add',
                text: $g('����'),
                handler: function () {
                    if (INCITM_RowId == '') {
                        PHA.Popover({
                            msg: $g('û��ѡ��ҩƷ,�����������,���ȱ���'),
                            type: 'alert'
                        });
                        return;
                    }
                    $('#gridDHCINCEasyConDesc').datagrid('addNewRow', {
                        editField: 'iecType'
                    });
                }
            },
            {
                iconCls: 'icon-save',
                text: $g('����'),
                handler: function () {
                    var $grid = $('#gridDHCINCEasyConDesc');
                    if ($grid.datagrid('endEditing') == false) {
                        PHA.Popover({
                            msg: $g('������ɱ�����'),
                            type: 'alert'
                        });
                        return;
                    }
                    var gridChanges = $grid.datagrid('getChanges');
                    var gridChangeLen = gridChanges.length;
                    if (gridChangeLen == 0) {
                        PHA.Popover({
                            msg: $g('û����Ҫ���������'),
                            type: 'alert'
                        });
                        return;
                    }
                    var inputStrArr = [];
                    for (var i = 0; i < gridChangeLen; i++) {
                        var iData = gridChanges[i];
                        if ($grid.datagrid('getRowIndex', iData) < 0) {
                            continue;
                        }
                        var params = (iData.iecId || '') + '^' + (iData.iecType || '') + '^' + (iData.iecConInci || '');
                        inputStrArr.push(params);
                    }
                    var inputStr = inputStrArr.join('!!');
                    var saveRet = $.cm(
                        {
                            ClassName: 'PHA.IN.DHCINCEasyConDesc.Save',
                            MethodName: 'SaveMulti',
                            InciId: INCITM_RowId,
                            MultiDataStr: inputStr,
                            dataType: 'text'
                        },
                        false
                    );
                    var saveArr = saveRet.split('^');
                    var saveVal = saveArr[0];
                    var saveInfo = saveArr[1];
                    if (saveVal < 0) {
                        PHA.Alert($g('��ʾ'), saveInfo, saveVal);
                    } else {
                        // ��������,�ɹ�ֱ��ˢ��
                        $grid.datagrid('reload');
                    }
                }
            },
            {
                iconCls: 'icon-cancel',
                text: $g('ɾ��'),
                handler: function () {
                    var gridSelect = $('#gridDHCINCEasyConDesc').datagrid('getSelected') || '';
                    if (gridSelect == '') {
                        PHA.Popover({
                            msg: $g('����ѡ����Ҫɾ���ļ�¼'),
                            type: 'alert'
                        });
                        return;
                    }
                    PHA.Confirm($g('ɾ����ʾ'), $g('��ȷ��ɾ����?'), function () {
                        var iecId = gridSelect.iecId || '';
                        var rowIndex = $('#gridDHCINCEasyConDesc').datagrid('getRowIndex', gridSelect);
                        if (iecId != '') {
                            var saveRet = $.cm(
                                {
                                    ClassName: 'PHA.IN.DHCINCEasyConDesc.Save',
                                    MethodName: 'Delete',
                                    IECId: iecId,
                                    dataType: 'text'
                                },
                                false
                            );
                            var saveArr = saveRet.split('^');
                            var saveVal = saveArr[0];
                            var saveInfo = saveArr[1];
                            if (saveVal < 0) {
                                PHA.Alert($g('��ʾ'), saveInfo, saveVal);
                                return;
                            }
                        }
                        $('#gridDHCINCEasyConDesc').datagrid('deleteRow', rowIndex);
                    });
                }
            }
        ],
        enableDnd: false,
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
        }
    };
    PHA.Grid('gridDHCINCEasyConDesc', dataGridOption);
}

/**
 * @description �л�ҳǩ
 * @param {String} inciId �����Id
 * @param {String} type �л���ʽ(��)
 */
function SwitchFromINCItm(inciId, type) {
    var arcimLoaded = $('#lyArcItmMast').text().trim();
    
    $('#tabsDrug').tabs('select', $('#tabsDrug').tabs('getTabIndex', $('#tabsDrug').tabs('getTabByOpt', { key: 'id', val: 'tabArcim' })));
    if (arcimLoaded != '') {
        QueryARCItmMast(inciId);
    } else {
        setTimeout(function () {
            QueryARCItmMast(inciId);
        }, 1000);
    }
}

/// �ϴ��ɹ��󱣴��ֶ�
function SaveDHCItmDocStorage(inciId, name, type, keyWord, fileName) {
    var saveRet = $.cm(
        {
            ClassName: 'PHA.IN.DHCItmDocStorage.Save',
            MethodName: 'Save',
            Inci: inciId,
            Name: name,
            Type: type,
            KeyWord: keyWord,
            FileName: fileName,
            dataType: 'text'
        },
        false
    );
    if (saveRet.indexOf('msg') >= 0) {
        PHA.Alert($g('��ʾ'), saveRet, 'error');
        return;
    }
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert($g('��ʾ'), saveInfo, 'warning');
        return;
    } else {
        return saveRet;
    }
}

// ��ȡ��Ԥ������
function GetDHCItmDocStorage(inciId, type) {
    var saveRet = $.cm(
        {
            ClassName: 'PHA.IN.DHCItmDocStorage.Query',
            QueryName: 'DHCItmDocStorage',
            Inci: inciId,
            Type: type
        },
        false
    );
    return saveRet;
}
// ����ؼ���
function SaveDHCItmDocStorageKeyWord(dataStr) {
    var saveRet = $.cm(
        {
            ClassName: 'PHA.IN.DHCItmDocStorage.Save',
            MethodName: 'SaveKeyWord',
            DataStr: dataStr,
            dataType: 'text'
        },
        false
    );
    PHA.Popover({
        msg: '����ɹ�',
        type: 'success'
    });
}
/// ɾ��
function DeleteDHCItmDocStorage(id) {
    var saveRet = $.cm(
        {
            ClassName: 'PHA.IN.DHCItmDocStorage.Save',
            MethodName: 'Delete',
            DocId: id,
            dataType: 'text'
        },
        false
    );
    if (saveRet.indexOf('msg') >= 0) {
        PHA.Alert($g('��ʾ'), saveRet, 'error');
        return false;
    }
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert($g('��ʾ'), saveInfo, 'warning');
        return false;
    } else {
        return true;
    }
}
function DHCItmRemark() {
    if (INCITM_RowId == '') {
        if (INCITM_RowId == '') {
            PHA.Popover({
                msg: $g('û��ѡ��ҩƷ,�����������,���ȱ���'),
                type: 'alert'
            });
            return;
        }
    }
    if ($('#diagDHCItmRemark').window('options').loaded == 'Y') {
        $('#diagDHCItmRemark').window('open');
        $('#gridDHCItmRemark').datagrid('query', {
            Inci: INCITM_RowId
        });
        return;
    }
    $('#diagDHCItmRemark').window('open');

    // ��ʼ������
    var irManf = PHA.EditGrid.ComboBox({
        tipPosition: 'top',
        mode: 'remote',
        url: PHA_STORE.PHManufacturer().url
    });
    var irCertificat = PHA.EditGrid.ComboBox({
        data: [
            {
                RowId: 'GMP',
                Description: 'GMP'
            },
            {
                RowId: '��GMP',
                Description: '��GMP'
            }
        ],
        panelHeight: 'auto'
    });
    var columns = [
        [
            {
                field: 'irID',
                title: 'Id',
                width: 100,
                hidden: true
            },
            {
                field: 'irLastText',
                title: $g('ԭ��׼�ĺ�'),
                width: 200,
                editor: {
                    type: 'validatebox'
                }
            },
            {
                field: 'irNewText',
                title: $g('��׼�ĺ�'),
                width: 200,
                editor: {
                    type: 'validatebox',
                    options: {
                        required: true,
                        tipPosition: 'bottom'
                    }
                }
            },
            {
                field: 'irNewTextDate',
                title: $g('������Ч��'),
                width: 125,
                editor: {
                    type: 'datebox',
                    options: {
                        required: true,
                        tipPosition: 'bottom'
                    }
                }
            },
            {
                field: 'irManf',
                title: $g('������ҵ'),
                width: 200,
                editor: irManf,
                descField: 'irManfDesc',
                formatter: function (value, row, index) {
                    return row.irManfDesc;
                }
            },
            {
                field: 'irManfDesc',
                title: $g('������ҵ����'),
                width: 150,
                hidden: true
            },
            {
                field: 'irLabel',
                title: $g('ע���̱�'),
                width: 100,
                editor: {
                    type: 'validatebox'
                }
            },
            {
                field: 'irRegCertNo',
                title: $g('����ע��֤'),
                width: 150,
                editor: {
                    type: 'validatebox'
                }
            },
            {
                field: 'irRegCertNoDate',
                title: $g('����ע��֤Ч��'),
                width: 115,
                editor: {
                    type: 'datebox'
                }
            },
            {
                field: 'irCertificat',
                title: $g('��֤���'),
                width: 100,
                editor: irCertificat
            },
            {
                field: 'irUpdateUser',
                title: $g('�޸���'),
                width: 75
            },
            {
                field: 'irUpdateDate',
                title: $g('�޸�����'),
                width: 100
            },
            {
                field: 'irUpdateTime',
                title: $g('�޸�ʱ��'),
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.IN.DHCItmRemark.Query',
            QueryName: 'DHCItmRemark',
            Inci: INCITM_RowId
        },
        pagination: false,
        columns: columns,
        fitColumns: false,
        enableDnd: false,
        border: true,
        bodyCls: 'panel-body-gray',
        onLoadSuccess: function (data) {
            $(this).datagrid('options').editIndex = undefined;
        },
        onClickRow: function (rowIndex, rowData) {
            $(this).datagrid('endEditing');
        },
        onDblClickCell: function (rowIndex, field, value) {
            $(this).datagrid('beginEditRow', {
                rowIndex: rowIndex
            });
        },
        toolbar: [
            {
                iconCls: 'icon-add',
                text: $g('����'),
                handler: function () {
                    if ($('#gridDHCItmRemark').datagrid('endEditing')) {
                        var rows = $('#gridDHCItmRemark').datagrid('getRows');
                        var irLastNewText = '';
                        if (rows.length > 0) {
                            irLastNewText = rows[rows.length - 1].irNewText;
                        }
                        $('#gridDHCItmRemark').datagrid('addNewRow', {
                            editField: 'irLastText',
                            defaultRow: {
                                irLastText: irLastNewText
                            }
                        });
                    }
                }
            },
            {
                iconCls: 'icon-save',
                text: $g('����'),
                handler: function () {
                    var $grid = $('#gridDHCItmRemark');
                    if ($grid.datagrid('endEditing') == false) {
                        PHA.Popover({
                            msg: $g('������ɱ�����'),
                            type: 'alert'
                        });
                        return;
                    }
                    var gridChanges = $grid.datagrid('getChanges');
                    var gridChangeLen = gridChanges.length;
                    if (gridChangeLen == 0) {
                        PHA.Popover({
                            msg: $g('û����Ҫ���������'),
                            type: 'alert'
                        });
                        return;
                    }
                    var inputStrArr = [];
                    for (var i = 0; i < gridChangeLen; i++) {
                        var iData = gridChanges[i];
                        if ($grid.datagrid('getRowIndex', iData) < 0) {
                            continue;
                        }
                        inputStrArr.push(iData);
                    }
                    var inputStrObj = {
                        rows: inputStrArr
                    };
                    var saveRet = $.cm(
                        {
                            ClassName: 'PHA.IN.DHCItmRemark.Save',
                            MethodName: 'SaveMulti',
                            Inci: INCITM_RowId,
                            RowsJsonStr: JSON.stringify(inputStrObj),
                            dataType: 'text'
                        },
                        false
                    );
                    var saveArr = saveRet.split('^');
                    var saveVal = saveArr[0];
                    var saveInfo = saveArr[1];
                    if (saveVal < 0) {
                        PHA.Alert($g('��ʾ'), saveInfo, saveVal);
                    } else {
                        PHA.Popover({
                            msg: $g('����ɹ�'),
                            type: 'success',
                            timeout: 1000
                        });
                        $grid.datagrid('reload');
                    }
                    ReGetItmRemark();
                }
            },
            {
                iconCls: 'icon-remove',
                text: $g('ɾ��'),
                handler: function () {
                    var $grid = $('#gridDHCItmRemark');
                    var gridSelect = $grid.datagrid('getSelected') || '';
                    if (gridSelect == '') {
                        PHA.Popover({
                            msg: $g('����ѡ����Ҫɾ���ļ�¼'),
                            type: 'alert'
                        });
                        return;
                    }
                    PHA.Confirm($g('ɾ����ʾ'), $g('��ȷ��ɾ����?'), function () {
                        var rowID = gridSelect.irID || '';
                        var rowIndex = $grid.datagrid('getRowIndex', gridSelect);
                        if (rowID != '') {
                            var saveRet = $.cm(
                                {
                                    ClassName: 'PHA.IN.DHCItmRemark.Save',
                                    MethodName: 'Delete',
                                    RowID: rowID,
                                    dataType: 'text'
                                },
                                false
                            );
                            var saveArr = saveRet.split('^');
                            var saveVal = saveArr[0];
                            var saveInfo = saveArr[1];
                            if (saveVal < 0) {
                                PHA.Alert($g('��ʾ'), saveInfo, saveVal);
                                return;
                            } else {
                                PHA.Popover({
                                    msg: $g('ɾ���ɹ�'),
                                    type: 'success',
                                    timeout: 1000
                                });
                            }
                            ReGetItmRemark();
                        }
                        $grid.datagrid('deleteRow', rowIndex);
                    });
                }
            }
        ]
    };
    PHA.Grid('gridDHCItmRemark', dataGridOption);
    function ReGetItmRemark() {
        $.cm(
            {
                ClassName: 'PHA.IN.DHCItmRemark.Query',
                MethodName: 'SelectItmAddionInfoRemark',
                Inci: INCITM_RowId
            },
            function (data) {
                $('#inciRemark1').combobox('setValue', data.remark1).combobox('setText', data.remark1);
                $('#inciRemark2').val(data.remark2);
            }
        );
    }
}