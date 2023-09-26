/**
 * @description 药品维护-库存项
 */
var INCITM_RowId = '';
var INCITM_KeyWord = '';
var INCITM_Style = {
    ComboWidth: 237
};

function INCITM() {
    $.parser.parse($('#lyINCItm').parent());
    $.parser.parse($('#diagDHCItmStoreCond'));
    InitDictINCItm();
    InitGridINCItm();
    InitGridDHCIncilDispUom();
    InitGridDHCINCEasyConDesc();
    InitKeyWordINCItm();
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
                title: '查询库存项最大码'
            },
            function (code) {
                $('#inciCode').val(code);
            }
        );
    });
    $('#btnAliasINCItm').on('click', AliasINCItm);
    $('#btnDHCItmStoreCond').on('click', DHCItmStoreCond);
    $('#btnAddINCItm').on('click', function () {
        PHA.Confirm('提示', '您确认清屏吗?', function () {
            AddINCItm();
            INCItmControler();
        });
    });
    $('#btnSaveINCItm').on('click', function () {
        if (PHA_COM.Param.App.SaveConfirm === 'Y') {
            PHA.ConfirmPrompt('保存提示', "你确认<span style='font-weight:bold;'> 保存 </span>吗 ?", function () {
                SaveINCItm('');
            });
        } else {
            PHA.Confirm('提示', '您确认保存吗?', function () {
                SaveINCItm('');
            });
        }
    });
    $('#btnSaveAsINCItm').on('click', function () {
        PHA.Confirm('提示', '您确认另存吗?', function () {
            SaveINCItm('SaveAs');
        });
    });
    $('#btnUploadBook,#btnUploadImg').on('click', function (e) {
        if (INCITM_RowId == '') {
            PHA.Popover({
                msg: '请先选择药品,如果为【新增】请先保存',
                type: 'alert'
            });
            return;
        }
        var btnText = $(this).text();
        var type = btnText.indexOf('说明书') >= 0 ? 'D' : 'P';
        var rowData = GetDHCItmDocStorage(INCITM_RowId, type);
        PHA_UPLOAD.Upload(
            {
                callBack: SaveDHCItmDocStorage,
                callBackKeyWord: SaveDHCItmDocStorageKeyWord,
                callBackDelete: DeleteDHCItmDocStorage,
                id: INCITM_RowId,
                type: type,
                keyWord: btnText.indexOf('说明书') >= 0 ? '药品说明书' : '药品图片',
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
                msg: '请先选择药品',
                type: 'alert'
            });
            return;
        }
        var rowsData = GetDHCItmDocStorage(INCITM_RowId);
        if (rowsData.rows.length == 0) {
            PHA.Popover({
                msg: '没有可浏览文件',
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
 * @description 清屏
 */
function ClrINCItm() {
    PHA.DomData('#gridINCItmBar', {
        doType: 'clear'
    });
    $('#conInciStat').combobox('setValue', 'ALL');
}

/**
 * @description 查询表格
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
 * @description 初始化关键字
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
                text: '全部信息',
                id: 'kwINCItmAll',
                selected: true
            },
            {
                text: '基本信息',
                id: 'kwINCItmBase'
            },
            {
                text: '收费项信息',
                id: 'kwINCItmTar'
            },
            {
                text: '易混淆',
                id: 'kwINCEasyConDesc'
            },
            {
                text: '发药单位',
                id: 'kwINCItmDispUom'
            },
            {
                text: '招标信息',
                id: 'kwINCItmPb'
            }
        ]
    });
    $('#kwINCItm').keywords('select', 'kwINCItmAll');
}

/**
 * @description 初始化库存项相关字典
 */
function InitDictINCItm() {
    var opts = $.extend({}, PHA_STORE.ArcItmMast('Y'), {
        width: 493
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
        }
    });
    PHA.ComboBox('conInciStkCat', {
        // url: PHA_STORE.INCStkCat().url
    });
    PHA.ComboBox('conInciStat', {
        panelHeight: 'auto',
        data: [
            {
                RowId: 'ALL',
                Description: '全部'
            },
            {
                RowId: 'ACTIVE',
                Description: '仅可用'
            },
            {
                RowId: 'STOP',
                Description: '不可用'
            },
            {
                RowId: 'EDORD',
                Description: '医嘱截止'
            }
        ]
    });
    $('#conInciStat').combobox('setValue', 'ALL');
    // 选基本单位后,其他单位才能出现下拉数据
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
    // 基本单位不选择,其他单位就不能选
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
                RowId: '进口',
                Description: '进口'
            },
            {
                RowId: '国产',
                Description: '国产'
            },
            {
                RowId: '合资',
                Description: '合资'
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
    PHA.NumberBox('inciSp', {
        precision: 4,
        width: INCITM_Style.ComboWidth,
        disabled: PHA_COM.Param.App.AllowInputSp == 'Y' ? false : true
    });
    PHA.NumberBox('inciRp', {
        precision: 4,
        width: INCITM_Style.ComboWidth,
        disabled: PHA_COM.Param.App.AllowInputRp == 'Y' ? false : true
    });
    PHA.NumberBox('inciMaxSp', {
        precision: 4,
        width: INCITM_Style.ComboWidth
    });
    PHA.NumberBox('inciPbRp', {
        precision: 4,
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
        placeholder: '入库单位系数'
    });
    PHA.ComboBox('inciOrigin', {
        url: PHA_STORE.DHCSTOrigin().url,
        width: INCITM_Style.ComboWidth
    });
    // 定价规则计算,回车触发
    $('#inciRp').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
            var markType = $('#inciMarkType').combobox('getValue');
            var rp = $('#inciRp').numberbox('getValue');
            var rp = $('#inciRp').val().trim();
            if (rp != '' && markType != '') {
                var retSp = tkMakeServerCall('web.DHCST.Common.PriceCommon', 'GetMTSpByMTRp', rp, markType);
                if (retSp != '' && retSp != 0) {
                    $('#inciSp').numberbox('setValue', retSp);
                }
            }
        }
    });
}

/**
 * @description 初始化库存项表格
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
                title: '代码',
                width: 150
            },
            {
                field: 'inciDesc',
                title: '名称',
                width: 300
            },
            {
                field: 'inciSpec',
                title: '包装规格',
                width: 100
            },
            {
                field: 'inciRemark',
                title: '批准文号',
                width: 150
            },
            {
                field: 'notUseFlag',
                title: '不可用',
                align: 'center',
                width: 65,
                formatter: function (value, row, index) {
                    if (value == 'Y') {
                        return '<font color="#f16e57">是</font>';
                    } else {
                        return '<font color="#21ba45">否</font>';
                    }
                }
            },
            {
                field: 'arcimDesc',
                title: '医嘱项名称',
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
 * @description 查询右侧明细
 */
function QueryINCItmDetail() {
    INCItmControler();
    $.cm(
        {
            ClassName: 'PHA.IN.INCItm.Query',
            MethodName: 'SelectINCItm',
            InciId: INCITM_RowId,
            ResultSetType: 'Array'
        },
        function (arrData) {
            PHA.DomData('#dataINCItm', {
                doType: 'clear'
            });
            if (arrData.msg) {
                PHA.Alert('错误提示', arrData.msg, 'error');
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
 * @description 存储条件维护
 */
function DHCItmStoreCond() {
    if (INCITM_RowId == '') {
        PHA.Popover({
            msg: '请先选择库存项,如果正在新增请先保存',
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
                    text: '保存',
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
                            PHA.Alert('提示', saveInfo, 'warning');
                            return;
                        } else {
                            PHA.Popover({
                                msg: '保存成功',
                                type: 'success'
                            });
                        }
                        $('#diagDHCItmStoreCond').window('close');
                    }
                },
                {
                    text: '关闭',
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
                PHA.Alert('错误提示', arrData.msg, 'error');
            } else {
                PHA.SetVals(arrData);
            }
        }
    );
}

/**
 * @description 清右侧明细
 */
function CleanINCItmDetail() {
    PHA.DomData('#dataINCItm', {
        doType: 'clear'
    });

    $('#gridDHCIncilDispUom').datagrid('clear');
    $('#gridDHCINCEasyConDesc').datagrid('clear');
    INCITM_RowId = '';
}
/**
 * @description 别名维护
 */
function AliasINCItm() {
    if (INCITM_RowId == '') {
        PHA.Popover({
            msg: '没有选中药品,如果正在新增,请先保存',
            type: 'alert'
        });
        return;
    }
    PHA_UX.Alias(
        {
            title: '库存项别名',
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
 * 发药单位
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
                title: '药房',
                width: 200,
                descField: 'ilduLocDesc',
                editor: ilduLoc,
                formatter: function (value, row, index) {
                    return row.ilduLocDesc;
                }
            },
            {
                field: 'ilduLocDesc',
                title: '药房描述',
                width: 200,
                hidden: true
            },
            {
                field: 'ilduUom',
                title: '单位',
                width: 100,
                descField: 'ilduUomDesc',
                editor: ilduUom,
                formatter: function (value, row, index) {
                    return row.ilduUomDesc;
                }
            },
            {
                field: 'ilduActive',
                title: '启用',
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
                title: '开始日期',
                width: 125,
                editor: {
                    type: 'datebox'
                }
            },
            {
                field: 'ilduEdDate',
                title: '结束日期',
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
                text: '新增',
                handler: function () {
                    if (INCITM_RowId == '') {
                        PHA.Popover({
                            msg: '没有选中药品,如果正在新增,请先保存',
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
                text: '保存',
                handler: function () {
                    var $grid = $('#gridDHCIncilDispUom');
                    if ($grid.datagrid('endEditing') == false) {
                        PHA.Popover({
                            msg: '请先完成必填项',
                            type: 'alert'
                        });
                        return;
                    }
                    var gridChanges = $grid.datagrid('getChanges');
                    var gridChangeLen = gridChanges.length;
                    if (gridChangeLen == 0) {
                        PHA.Popover({
                            msg: '没有需要保存的数据',
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
                        PHA.Alert('提示', saveInfo, saveVal);
                    } else {
                        PHA.Popover({
                            msg: '保存成功',
                            type: 'success',
                            timeout: 1000
                        });
                        $grid.datagrid('reload');
                    }
                }
            },
            {
                iconCls: 'icon-remove',
                text: '删除',
                handler: function () {
                    var $grid = $('#gridDHCIncilDispUom');
                    var gridSelect = $grid.datagrid('getSelected') || '';
                    if (gridSelect == '') {
                        PHA.Popover({
                            msg: '请先选择需要删除的记录',
                            type: 'alert'
                        });
                        return;
                    }
                    PHA.Confirm('删除提示', '您确认删除吗?', function () {
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
                                PHA.Alert('提示', saveInfo, saveVal);
                                return;
                            } else {
                                PHA.Popover({
                                    msg: '删除成功',
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
 * @description 新增
 */
function AddINCItm() {
    $('#gridINCItm').datagrid('clearSelections');
    CleanINCItmDetail();
    $('#inciArcim').focus();
    INCITM_RowId = '';
    if (PHA_COM.Param.App.SetInitStatusNotUse == 'Y') {
        $('#inciNotUse').checkbox('setValue', true);
    }
}
/**
 * @description 保存
 * @param {String} saveType
 */
function SaveINCItm(saveType) {
    var valsArr = PHA.DomData('#dataINCItm', {
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
        PHA.Alert('提示', saveRet, 'error');
        return;
    }
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert('提示', saveInfo, saveVal);
        return;
    } else {
        PHA.Popover({
            msg: saveType == '' ? '保存成功' : '另存成功',
            type: 'success'
        });
        INCITM_RowId = saveVal;
        QueryINCItmDetail();
    }
}
/**
 * @description 控制可编辑
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
    } else {
        $('#inciBUom').combobox('readonly', false);
        $('#inciPUom').combobox('readonly', false);
        //$("#inciOutUom").combobox("readonly", false);
        //$("#inciInUom").combobox("readonly", false);
        $('#inciPriceDate').datebox('readonly', false);
        $('#inciRp').attr('readonly', false);
        $('#inciSp').attr('readonly', false);
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
}

/**
 * @description 易混淆
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
                title: '易混淆类型',
                width: 100,
                descField: 'iecTypeDesc',
                editor: DHCINCEasyConDesc_Type,
                formatter: function (value, row, index) {
                    return row.iecTypeDesc;
                }
            },
            {
                field: 'iecTypeDesc',
                title: '易混淆类型描述',
                width: 100,
                hidden: true
            },
            {
                field: 'iecConInci',
                title: '易混淆药品',
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
                title: '易混淆药品名称',
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
                text: '新增',
                handler: function () {
                    if (INCITM_RowId == '') {
                        PHA.Popover({
                            msg: '没有选中药品,如果正在新增,请先保存',
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
                text: '保存',
                handler: function () {
                    var $grid = $('#gridDHCINCEasyConDesc');
                    if ($grid.datagrid('endEditing') == false) {
                        PHA.Popover({
                            msg: '请先完成必填项',
                            type: 'alert'
                        });
                        return;
                    }
                    var gridChanges = $grid.datagrid('getChanges');
                    var gridChangeLen = gridChanges.length;
                    if (gridChangeLen == 0) {
                        PHA.Popover({
                            msg: '没有需要保存的数据',
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
                        PHA.Alert('提示', saveInfo, saveVal);
                    } else {
                        // 别名这种,成功直接刷新
                        $grid.datagrid('reload');
                    }
                }
            },
            {
                iconCls: 'icon-remove',
                text: '删除',
                handler: function () {
                    var gridSelect = $('#gridDHCINCEasyConDesc').datagrid('getSelected') || '';
                    if (gridSelect == '') {
                        PHA.Popover({
                            msg: '请先选择需要删除的记录',
                            type: 'alert'
                        });
                        return;
                    }
                    PHA.Confirm('删除提示', '您确认删除吗?', function () {
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
                                PHA.Alert('提示', saveInfo, saveVal);
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
 * @description 切换页签
 * @param {String} inciId 库存项Id
 * @param {String} type 切换方式(空)
 */
function SwitchFromINCItm(inciId, type) {
    var arcimLoaded = $('#lyArcItmMast').text().trim();
    $('#tabsDrug').tabs('select', '医嘱项');
    if (arcimLoaded != '') {
        QueryARCItmMast(inciId);
    } else {
        setTimeout(function () {
            QueryARCItmMast(inciId);
        }, 1000);
    }
}

/// 上传成功后保存字段
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
        PHA.Alert('提示', saveRet, 'error');
        return;
    }
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert('提示', saveInfo, 'warning');
        return;
    } else {
        return saveRet;
    }
}

// 获取需预览数据
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
// 保存关键字
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
        msg: '保存成功',
        type: 'success'
    });
}
/// 删除
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
        PHA.Alert('提示', saveRet, 'error');
        return false;
    }
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert('提示', saveInfo, 'warning');
        return false;
    } else {
        return true;
    }
}
function DHCItmRemark() {
    if (INCITM_RowId == '') {
        if (INCITM_RowId == '') {
            PHA.Popover({
                msg: '没有选中药品,如果正在新增,请先保存',
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

    // 初始化下拉
    var irManf = PHA.EditGrid.ComboBox({
        tipPosition: 'top',
        url: PHA_STORE.PHManufacturer().url
    });
    var irCertificat = PHA.EditGrid.ComboBox({
        data: [
            {
                RowId: 'GMP',
                Description: 'GMP'
            },
            {
                RowId: '非GMP',
                Description: '非GMP'
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
                title: '原批准文号',
                width: 200,
                editor: {
                    type: 'validatebox'
                }
            },
            {
                field: 'irNewText',
                title: '批准文号',
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
                title: '批文有效期',
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
                title: '生产企业',
                width: 200,
                editor: irManf,
                descField: 'irManfDesc',
                formatter: function (value, row, index) {
                    return row.irManfDesc;
                }
            },
            {
                field: 'irManfDesc',
                title: '生产企业描述',
                width: 150,
                hidden: true
            },
            {
                field: 'irLabel',
                title: '注册商标',
                width: 100,
                editor: {
                    type: 'validatebox'
                }
            },
            {
                field: 'irRegCertNo',
                title: '进口注册证',
                width: 150,
                editor: {
                    type: 'validatebox'
                }
            },
            {
                field: 'irRegCertNoDate',
                title: '进口注册证效期',
                width: 115,
                editor: {
                    type: 'datebox'
                }
            },
            {
                field: 'irCertificat',
                title: '认证情况',
                width: 100,
                editor: irCertificat
            },
            {
                field: 'irUpdateUser',
                title: '修改人',
                width: 75
            },
            {
                field: 'irUpdateDate',
                title: '修改日期',
                width: 100
            },
            {
                field: 'irUpdateTime',
                title: '修改时间',
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
                text: '新增',
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
                text: '保存',
                handler: function () {
                    var $grid = $('#gridDHCItmRemark');
                    if ($grid.datagrid('endEditing') == false) {
                        PHA.Popover({
                            msg: '请先完成必填项',
                            type: 'alert'
                        });
                        return;
                    }
                    var gridChanges = $grid.datagrid('getChanges');
                    var gridChangeLen = gridChanges.length;
                    if (gridChangeLen == 0) {
                        PHA.Popover({
                            msg: '没有需要保存的数据',
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
                        PHA.Alert('提示', saveInfo, saveVal);
                    } else {
                        PHA.Popover({
                            msg: '保存成功',
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
                text: '删除',
                handler: function () {
                    var $grid = $('#gridDHCItmRemark');
                    var gridSelect = $grid.datagrid('getSelected') || '';
                    if (gridSelect == '') {
                        PHA.Popover({
                            msg: '请先选择需要删除的记录',
                            type: 'alert'
                        });
                        return;
                    }
                    PHA.Confirm('删除提示', '您确认删除吗?', function () {
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
                                PHA.Alert('提示', saveInfo, saveVal);
                                return;
                            } else {
                                PHA.Popover({
                                    msg: '删除成功',
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
