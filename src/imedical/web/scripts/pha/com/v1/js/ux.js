/**
 * ����:   ҩ����������
 * ��д��:  yunhaibao
 * ��д����: 2019-05-06
 * scripts/pha/com/v1/js/ux.js
 */
var PHA_UX = {
    DHCPHCCat: function (_id, _opts, _callBack) {
        var _winDivId = _id + '_PHA_UX_DHCPHCCat';
        var _tgId = _id + '_PHA_UX_DHCPHCCat_TG';
        var _winToolBarId = _id + '_PHA_UX_DHCPHCCat_TG_BAR';
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
                [{
                        field: 'phcCatDesc',
                        title: 'ҩѧ����',
                        width: 300
                    }, {
                        field: 'phcCatDescAll',
                        title: 'ҩѧ����ȫ��',
                        width: 300,
                        hidden: true
                    }, {
                        field: 'phcCatId',
                        title: 'phcCatId',
                        hidden: true
                    }, {
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
        .attr('placeholder', $g("����������س���ѯ")+'...');
        $('#' + _tgId)
        .prev()
        .find('.datagrid-header')
        .css('border', 0);
    },
    /**
     * ͨ������봰��
     * @param {Object}  _opts
     *                      tblName ����
     *                      codeName ������ֵ�ֶ���
     *                      title ��������
     * @param {Function} _callBack �ص�����
     */
     MaxCode: function (_opts, _callBack) {
        var _winDivId = 'PHA_UX_MaxCode';
        var _preCodeId = 'preCode_PHA_UX_MaxCode';
        var _maxCodeId = 'maxCode_PHA_UX_MaxCode';
        // if ($("#" + _winDivId).text() == "") {
        var _winDiv = '';
        _winDiv += '<div id=' + _winDivId + ' style="overflow:hidden;width:400px;height:290px;">';
        _winDiv += '<div class="pha-row">';
        _winDiv += '    <div style="padding:0px 10px;">'
        _winDiv += '        <div style="width:width:100%;line-height:28px;padding:10px;background:#e3f7ff;color: #1278b8;border: 1px solid #c0e2f7;border-radius: 4px;">' ;
        _winDiv += '            <div>' + $g('����ͬ����볤��һ��, ��XY000001��XY000002') + '</div>'
        _winDiv += '            <div>' + $g('�״β����µĴ���, ֱ����������ı�����¼�뼴��') + '</div>'
        _winDiv += '            <div>' + $g('¼��ǰ׺��󣬻س��������������') + '</div>'
        _winDiv += '        </div>';
        _winDiv += '    </div>';
        _winDiv += '</div>';
//        _winDiv += '<div class="pha-row">';
//        _winDiv += '<div class="pha-col">';
//        _winDiv += '<div class="pha-tip-info" style="width:230px">��' + $g('MEDIWAY+5 �����׺5λ����') + '</div>';
//        _winDiv += '</div>';
//        _winDiv += '</div>';
        _winDiv += '<div class="pha-row">';
        _winDiv += '<div class="pha-col">';
        _winDiv += '<label>' + $g('ǰ׺��') + '</label>';
        _winDiv += '<div class="pha-col">';
        _winDiv += '<input id=' + _preCodeId + ' class="hisui-validatebox" style="width:325px;" placeholder="' + $g('¼�����س�...') + '">';
        _winDiv += '</div>';
        _winDiv += '</div>';
        _winDiv += '</div>';
        _winDiv += '<div class="pha-row">';
        _winDiv += '<div class="pha-col">';
        _winDiv += '<label>' + $g("�����") + '</label>';
        _winDiv += '<div class="pha-col">';
        _winDiv += '<input id=' + _maxCodeId + ' class="hisui-validatebox" style="width:325px;">';
        _winDiv += '</div>';
        _winDiv += '</div>';
        _winDiv += '</div>';
        _winDiv += '</div>';
        $('body').append(_winDiv);
        $.parser.parse($('#PHA_UX_MaxCode'));
        // }
        $('#' + _winDivId)
        .dialog({
            title: _opts.title,
            collapsible: false,
            iconCls: 'icon-w-find',
            resizable: false,
            maximizable: false,
            minimizable: false,
            closable: false,
            border: false,
            closed: true,
            modal: true,
            buttons: [{
                    text: 'ȷ��',
                    handler: function () {
                        var maxCode = $('#' + _maxCodeId).val();
                        _callBack(maxCode);
                        $('#' + _winDivId).window('close');
                    }
                }, {
                    text: 'ȡ��',
                    handler: function () {
                        $('#' + _winDivId).window('close');
                    }
                }
            ],
            onBeforeClose: function () {
                $('#' + _winDivId).remove();
            }
        })
        .dialog('open');
        $('#' + _preCodeId).on('keypress', function (event) {
            if (window.event.keyCode == '13') {
                $.cm({
                    ClassName: 'PHA.COM.MaxCode',
                    MethodName: 'Generate',
                    TblName: _opts.tblName,
                    CodeName: _opts.codeName,
                    PrefixData: $('#' + _preCodeId).val(),
                    dataType: 'text'
                }, function (text) {
                    if (text == '') {
                        PHA.Alert('��ʾ', '��¼���ǰ׺��Ҫ��ϵͳ�д���</br>���Ϊȫ�¹���,�״���¼��', 'warning');
                    }
                    $('#' + _maxCodeId).val(text);
                });
            }
        });
    },
    /**
     * �������壬�����ʽͳһ�����ݲ�ͬ
     */
    Alias: function (_opts, _callBack) {
        var _preId = 'PHA_UX_Alias_' + Math.floor(Math.random() * 10000 + 1);
        var _winDivId = _preId;
        var _gridId = 'grid_' + _preId;
        var _winToolBarId = 'gridBar_' + _preId;
        var btnAddId = 'btnAdd' + _preId;
        var btnSaveId = 'btnSave' + _preId;
        var btnDelId = 'btnDel' + _preId;
        var _winDiv =
            '<div id=' +
            _winDivId +
            ' style="padding:10px;overflow:hidden;"><div style="border:1px solid #e2e2e2;width:100%;height:100%;border-radius: 4px;"><div id=' +
            _gridId +
            '></div></div></div>';
        var _winToolBarDiv = '<div id=' + _winToolBarId + '>';
        _winToolBarDiv += '<div>';
        _winToolBarDiv += '<a class="hisui-linkbutton" plain="true" iconCls="icon-add" id=' + btnAddId + ' >����</a>';
        _winToolBarDiv += '<a class="hisui-linkbutton" plain="true" iconCls="icon-save" id=' + btnSaveId + '>����</a>';
        _winToolBarDiv += '<a class="hisui-linkbutton" plain="true" iconCls="icon-remove" id=' + btnDelId + '>ɾ��</a>';
        _winToolBarDiv += '</div>';
        _winToolBarDiv += '</div>';
        $('body').append(_winDiv);
        $('body').append(_winToolBarDiv);
        $.parser.parse($('#' + _winDivId));
        $.parser.parse($('#' + _winToolBarId));
        var columns = [
            [{
                    field: 'aliasId',
                    title: '����Id',
                    hidden: true,
                    width: 100
                }, {
                    field: 'aliasText',
                    title: '����',
                    width: 200,
                    editor: {
                        type: 'validatebox',
                        options: {
                            required: true
                        }
                    }
                }
            ]
        ];
        var dataGridOption = {
            url: $URL,
            queryParams: _opts.queryParams,
            pagination: false,
            columns: columns,
            fitColumns: true,
            toolbar: '#' + _winToolBarId,
            enableDnd: false,
            onClickRow: function (rowIndex, rowData) {
                $(this).datagrid('endEditing');
                // $("[datagrid-row-index="+rowIndex+"]").css("background","red")
            },
            onDblClickCell: function (rowIndex, field, value) {
                $(this).datagrid('beginEditCell', {
                    index: rowIndex,
                    field: field
                });
            },
            gridSave: false
        };
        PHA.Grid(_gridId, dataGridOption);
        $('#' + _winDivId)
        .window({
            title: _opts.title,
            collapsible: false,
            iconCls: 'icon-w-edit',
            resizable: false,
            maximizable: false,
            minimizable: false,
            border: false,
            closed: true,
            modal: true,
            width: 400,
            height: 400,
            onBeforeClose: function () {
                $('#' + _winToolBarId).remove();
                $('#' + _winDivId).remove();
                _callBack();
            }
        })
        .window('open');
        // ��ť�¼�
        $('#' + btnAddId).on('click', function () {
            $('#' + _gridId).datagrid('addNewRow', {});
        });
        $('#' + btnSaveId).on('click', function () {
            var $_grid = $('#' + _gridId);
            $_grid.datagrid('endEditing');
            var gridChanges = $_grid.datagrid('getChanges');
            var gridChangeLen = gridChanges.length;
            if (gridChangeLen == 0) {
                PHA.Popover({
                    msg: 'û����Ҫ���������',
                    type: 'alert'
                });
                return;
            }
            var inputStrArr = [];
            for (var i = 0; i < gridChangeLen; i++) {
                var iData = gridChanges[i];
                if ($_grid.datagrid('getRowIndex', iData) < 0) {
                    continue;
                }
                var params = (iData.aliasId || '') + '^' + (iData.aliasText || '');
                inputStrArr.push(params);
            }
            var inputStr = inputStrArr.join('!!');
            var saveOpt = $.extend({}, {
                dataType: 'text',
                MultiDataStr: inputStr
            },
                    _opts.saveParams);
            var saveRet = $.cm(saveOpt, false);
            var saveArr = saveRet.split('^');
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal < 0) {
                PHA.Alert('��ʾ', saveInfo, saveVal);
            } else {
                PHA.Popover({
                    msg: '����ɹ�',
                    type: 'success',
                    timeout: 1000
                });
                // ��������,�ɹ�ֱ��ˢ��
                $_grid.datagrid('reload');
            }
        });
        $('#' + btnDelId).on('click', function () {
            var $_grid = $('#' + _gridId);
            var gridSelect = $_grid.datagrid('getSelected') || '';
            if (gridSelect == '') {
                PHA.Popover({
                    msg: '����ѡ����Ҫɾ��������',
                    type: 'alert'
                });
                return;
            }
            var aliasId = gridSelect.aliasId || '';
            var rowIndex = $_grid.datagrid('getRowIndex', gridSelect);
            if (aliasId != '') {
                var saveOpt = $.extend({}, {
                    dataType: 'text',
                    AliasId: aliasId
                }, _opts.deleteParams);
                var saveRet = $.cm(saveOpt, false);
                var saveArr = saveRet.split('^');
                var saveVal = saveArr[0];
                var saveInfo = saveArr[1];
                if (saveVal < 0) {
                    PHA.Alert('��ʾ', saveInfo, saveVal);
                    return;
                } else {
                    PHA.Popover({
                        msg: 'ɾ���ɹ�',
                        type: 'success',
                        timeout: 1000
                    });
                }
            }
            $_grid.datagrid('deleteRow', rowIndex);
        });
    },
    /**
     * ���������ͷ�װ
     * @param {*} _opts
     *                  cardTypeId  ������domid
     *                  cardNoId    ����domid
     *                  patNoId     �ǼǺ�domid
     *                  readCardId  ������ťdomid
     * @param {*} _callBackOpts
     *                  �����ص�ͬʱ�����߲���
     *                  ReadHandler �����¼�,��д�߹���
     *                  AfterHandler����дֵ���¼�
     */
    DHCCardTypeDef: function (_opts, _callBackOpts) {
        _callBackOpts = _callBackOpts || {};
        if (typeof _opts == 'object') {
            // ��ʼ��
            var cardNoId = _opts.cardNoId || '';
            var readCardId = _opts.readCardId || '';
            var cardTypeId = _opts.cardTypeId || '';
            var patNoId = _opts.patNoId || '';
            PHA.ComboBox(cardTypeId, {
                editable: false,
                width: 100,
                url: PHA_STORE.DHCCardTypeDef().url,
                panelHeight: 'auto',
                onLoadSuccess: function (data) {
                    for (var i = 0; i < data.length; index++) {
                        var iData = data[i];
                        var iVal = iData.RowId;
                        var iDesc = iData.Description;
                        var iDef = iData.Default;
                        if (iDef == 'true') {
                            $(this).combobox('select', iVal);
                            break;
                        }
                    }
                },
                onSelect: function (data) {
                    var cardTypeAry = data.RowId.split('^');
                    var readCardMode = cardTypeAry[16];
                    if (readCardMode == 'Handle') {
                        if (readCardId) {
                            $('#' + readCardId).linkbutton('disable');
                        }
                        if (cardNoId) {
                            $('#' + cardNoId).attr('readOnly', false);
                        }
                    } else {
                        if (readCardId) {
                            $('#' + readCardId).linkbutton('enable');
                        }
                        if (cardNoId) {
                            $('#' + cardNoId).attr('readOnly', true);
                            $('#' + cardNoId).val('');
                        }
                    }
                }
            });
            if (readCardId) {
                $('#' + readCardId).on('click', function (e) {
                    if ($(this).linkbutton('options').disabled != true) {
                        if (_callBackOpts.ReadHandler) {
                            _callBackOpts.ReadHandler();
                        } else {
                            ReadCard();
                        }
                    }
                });
            }
            if (cardNoId) {
                $('#' + cardNoId).keydown(function (e) {
                    if (e.keyCode == 13) {
                        ReadCard('handle');
                    }
                });
            }
        } else {}
        // ����
        function ReadCard(readType) {
            try {
                var cardType = $('#' + cardTypeId).combobox('getValue');
                var cardTypeDR = cardType.split('^')[0];
                var myRtn = '';
                if (readType == '') {
                    if (cardTypeDR == '') {
                        myRtn = DHCACC_GetAccInfo();
                    } else {
                        myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
                    }
                } else {
                    var cardNo = '';
                    if (cardNoId) {
                        cardNo = $('#' + cardNoId).val();
                    }
                    cardNo = FullCardNo(cardNo, cardType);
                    myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, '', 'PatInfo');
                }
                var myAry = myRtn.toString().split('^');
                var rtn = myAry[0];
                switch (rtn) {
                case '0':
                    if (cardNoId) {
                        $('#' + cardNoId).val(myAry[1]);
                    }
                    if (patNoId) {
                        $('#' + patNoId).val(myAry[5]);
                    }
                    if (_callBackOpts.AfterHandler) {
                        _callBackOpts.AfterHandler();
                    }
                    break;
                case '-200':
                    $.messager.alert('��ʾ', '����Ч', 'info', function () {
                        if (readCardId) {
                            $('#' + readCardId).focus();
                        }
                    });
                    break;
                case '-201':
                    if (cardNoId) {
                        $('#' + cardNoId).val(myAry[1]);
                    }
                    if (patNoId) {
                        $('#' + patNoId).val(myAry[5]);
                    }
                    if (_callBackOpts.AfterHandler) {
                        _callBackOpts.AfterHandler();
                    }
                    break;
                default:
                    break;
                }
            } catch (e) {}
        }
        // ���Ų���
        function FullCardNo(cardNo, cardType) {
            var cardNoLen = cardType.split('^')[17];
            if (cardNoLen != 0 && cardNo.length < cardNoLen) {
                var defLen = cardNoLen - cardNo.length - 1;
                for (var i = defLen; i >= 0; i--) {
                    cardNo = '0' + cardNo;
                }
            }
            return cardNo;
        }
    },
    /**
     * ������Ϣ����
     * @param {object} _opts �����С����
     * @param {*} _qOpts     query���(AdmId,Ooeri)
     */
    AdmDetail: function (_opts, _qOpts) {
        var winId = 'PHA_UX_AdmDetail';
        var gridId = winId + '_Grid';
        var existHtml = $('#PHA_UX_AdmDetail').html() || '';
        if (existHtml !== '') {
            $('#' + gridId).datagrid('query', {
                ClassName: 'PHA.COM.Query',
                QueryName: 'AdmDetailGrp',
                Oeori: _qOpts.Oeori || '',
                AdmId: _qOpts.AdmId || ''
            });
            $('#' + winId).window('open');
            return;
        }
        var winDiv = '<div id=' + winId + ' style="padding:10px;overflow:hidden;"><div id=' + gridId + '></div></div>';
        $('body').append(winDiv);
        //������
        var columns = [
            [{
                    field: 'group',
                    hidden: true
                }, {
                    field: 'field1',
                    title: '����',
                    width: 100,
                    align: 'right',
                    formatter: function (value, row, index) {
                        return $g(value)
                    },
                    styler: function (value, row, index) {
                        if (!PHA_UX.IsLiteCss) {
                            return 'background:#f4f6f5;';
                        }else{
                            return 'background:rgb(248,248,248)'
                        }
                    }
                }, {
                    field: 'value1',
                    title: 'ֵ',
                    width: 300,
                    styler: function (value, row, index) {
                        if (row.field1 ==  $g('������Ⱥ')) {
                            if (value != '') {
                                return 'background:#d472ae;color:#fff;';
                            }
                        }
                    }
                }, {
                    field: 'field2',
                    title: '����',
                    width: 100,
                    align: 'right',
                    formatter: function (value, row, index) {
                        return $g(value)
                    },
                    styler: function (value, row, index) {
                        if (!PHA_UX.IsLiteCss) {
                            return 'background:#f4f6f5;';
                        }else{
                            return 'background:rgb(248,248,248)'
                        }
                    }
                }, {
                    field: 'value2',
                    title: 'ֵ',
                    width: 300,
                    styler: function (value, row, index) {
                        if (row.field2 == $g('����״̬')) {
                            if ([ $g('����'),  $g('��Σ')].indexOf(value) >= 0) {
                                return 'background:#ee4f38;color:#fff;';
                            }
                        } else if (row.field2 ==  $g('��Ժʱ��')) {
                            if (value.trim() != '') {
                                return 'background:#03ceb4;color:#fff;';
                            }
                        }
                    }
                }
            ]
        ];
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'PHA.COM.Query',
                QueryName: 'AdmDetailGrp',
                Oeori: _qOpts.Oeori || '',
                AdmId: _qOpts.AdmId || ''
            },
            fit: true,
            fitColumns: true,
            showHeader: false,
            // showGroup: true,
            bodyCls: PHA_UX.IsLiteCss ? 'table-splitline' : '',
            scrollbarSize: -1,
            rownumbers: false,
            columns: columns,
            pageSize: 9999,
            pagination: false,
            singleSelect: true,
            nowrap: false,
            toolbar: null,
            border: false,
            onLoadSuccess: function (data) {
                if (data.rows) {
                    var rowsData = data.rows;
                    // �ϲ���
                    for (var i = 0; i < rowsData.length; i++) {
                        var rowData = rowsData[i];
                        if (rowData.field1 ==  $g('���') || rowData.field1 ==  $g('������Ⱥ')) {
                            $(this).datagrid('mergeCells', {
                                index: i,
                                field: 'value1',
                                rowspan: null,
                                colspan: 3
                            });
                        }
                    }
                }
                $('#' + winId + ' td.datagrid-td-merged > div').css({'line-height':'28px','position':'relative','top':'-5px'})
            }
        };
        $('#' + gridId).datagrid(dataGridOption);
        var winOpts = {
            title: ' ���߾�����Ϣ',
            collapsible: false,
            iconCls: 'icon-w-list',
            border: false,
            resizable: true,
            minimizable: false,
            maximizable: false,
            closed: true,
            modal: true,
            width: 800,
            height: PHA_UX.IsLiteCss ? 420 : 472,
            toolbar: null,
            onBeforeClose: function () {
                //$('#' + winId).remove();
            }
        };
        $('#' + winId).window($.extend({}, winOpts, _opts));
        $('#' + winId + " [class='datagrid-header']").css('border', 'none');
        $('#' + winId + " [class='panel datagrid']").css('border', '#e2e2e2 solid 1px');
        $('#' + winId + " [class='panel datagrid']").css('border-radius', '4px');
        $('#' + winId + " [class='datagrid-body']").css('overflow', 'hidden');
        $('#' + winId).window('open');
    },
    /**
     * ��ʾ��Ϣ��Ϣ�Ĺ�������
     * huxiaotian 2020-08-21
     * @param {string} _options.id ����ID
     * @param {string} _options.title �������
     * @param {string} _options.width ������
     * @param {string} _options.height ����߶�
     * @param {string} _options.labelWidth ��ǩ���
     * @param {string} _options.data ��ʾ������,��ʽ��[{title:'',code:'',data:[{labelText:'',content:''},{},...]}, {title:'',code:'',data:[]}]
     * @param {object} _options.queryParams ��ѯ���ݵ��෽��,�෽��Ӧ�÷�����data��ʽ���Ƶ�����
     * @return
     */
    DetailWin: function (_options) {
        var winId = _options.id || 'PHA_WIN_INFO';
        var contentId = winId + '_Detail';
        var $win = $('#' + winId);
        if ($win.length == 0) {
            $('<div id="' + winId + '"></div>').appendTo('body');
            var winDefaultOpts = {
                title: '��ϸ��Ϣ',
                collapsible: false,
                minimizable: false,
                iconCls: 'icon-w-list',
                content: "<div id='" + contentId + "'></div>",
                border: false,
                closed: true,
                modal: true,
                width: 600,
                height: 560,
                buttons: [{
                        text: '�ر�',
                        handler: function () {
                            $('#' + winId).dialog('close');
                        }
                    }
                ]
            };
            delete _options.id;
            var winOpts = $.extend({}, winDefaultOpts, _options);
            $('#' + winId).dialog(winOpts);
            
        }
        $('#' + winId).dialog('open');
        $('#' + contentId)
        .children()
        .remove();
        // ��ʽ�޸�
        $('#' + winId)
        .children()
        .eq(1)
        .css({
            'border-top': '1px solid #d1d6da',
            'box-shadow': '0 -1px 30px #ccc'
        });
        var dialogBody = $('#' + winId)
            .dialog('body')
            .children()
            .eq(0)
            .children()
            .eq(0)
            .children()
            .eq(0);
        dialogBody.parent().addClass('pha-scrollbar-hidden');
        dialogBody.addClass('pha-panel-body-content');
        dialogBody.addClass('pha-scrollbar-hidden-chl');
        if ($win.length == 0) {
            if (PHA_UX.IsLiteCss){
                $('#' + contentId).width($('#' + winId).dialog('body').children().eq(0).width() - 12);
                $('#' + winId).dialog('body').children().eq(0).children().eq(0).css({
                    "padding-right": 20, 
                    "overflow-x": "hidden"
                });
            }
        }
        // �������
        dialogBody.html('');
        if (_options.data) {
            var data = _options.data;
            var dataLen = data.length;
            for (var i = 0; i < dataLen; i++) {
                AddCard(dialogBody, data[i]);
            }
            return;
        }
        $.ajax({
            url: 'websys.Broker.cls',
            type: 'post',
            async: false,
            dataType: 'json',
            data: _options.queryParams || {},
            success: function (data) {
                var dataLen = data.length;
                for (var i = 0; i < dataLen; i++) {
                    AddCard(dialogBody, data[i]);
                }
            },
            error: function (XMLHR) {
                console.log(XMLHR);
                alert('����console����̨�鿴������Ϣ');
            }
        });
        /*
         * @����һ���ڲ�����
         */
        function AddCard(dialogBody, _cardOptions) {
            // ��Ƭ��ʼ��
            var _cardId = _cardOptions.id || _cardOptions.code || '';
            if (_cardId == '') {
                alert('cardδָ��id����');
                return;
            }
            var _containerId = _cardId + '-' + 'container';
            var _title = _cardOptions.title || '��Ƭ' + _cardId;
            dialogBody.append("<div id='" + _cardId + "'><div class='hisui-panel' title='" + _title + "' data-options=\"height:50,headerCls:'panel-header-card-gray'\"" + '></div></div>');
            $.parser.parse('#' + _cardId);
            var cardBody = $('#' + _cardId)
                .children()
                .eq(0)
                .children()
                .eq(1);
            var cardBodyWidth = cardBody.css('width');
            cardBody.addClass('pha-body-panel-content');
            if (!PHA_UX.IsLiteCss){
                cardBody.css('border-radius', 4);
                cardBody.css('width', parseInt(cardBodyWidth) - 2);
            }
            cardBody.css('margin-bottom', 10);
            // ��ӿ�Ƭ����
            var htmlStr = "<table id='" + _containerId + "'style='width:100%;margin-top:10px;'>";
            var cardData = _cardOptions.data;
            for (var i = 0; i < cardData.length; i++) {
                var oneCardData = cardData[i];
                var labelTextStyle = 'width:' + (_options.labelWidth || 120) + 'px; text-align:right; border-bottom:0px dashed #CCCCCC; border-right: 0px dashed #CCCCCC; padding:5px;';
                var contentStyle = 'border-bottom:0px dashed #CCCCCC; padding:5px;';
                if (i == 0) {
                    labelTextStyle += '; border-top:0px dashed #CCCCCC;';
                    contentStyle += '; border-top:0px dashed #CCCCCC;';
                }
                htmlStr += '<tr>';
                htmlStr += '<td style="' + labelTextStyle + '" valign="top">';
                htmlStr += "<label style='color:#666666'>" + oneCardData.labelText + ' : </label>';
                htmlStr += '</td>';
                htmlStr += '<td style="' + contentStyle + '" valign="top">';
                htmlStr += oneCardData.content;
                htmlStr += '</td>';
                htmlStr += '</tr>';
            }
            htmlStr += '</table>';
            cardBody.append(htmlStr);
            $.parser.parse('#' + _containerId);
            if ($('#' + _containerId).length > 0) {
                var ch = $('#' + _containerId)[0].clientHeight;
                cardBody.css('height', ch + 15);
            }
        }
    },
    TimeLine: function (_opts, _qOpts) {
        PHA_UX.OrderView(_qOpts.oeore || _qOpts.oeori || '')
        return;
        var winId = 'PHA_UX_TimeLine';
        var lineId = winId + '_Line';
        var existHtml = $('#' + winId).html() || '';
        if (existHtml === '') {
            var winDiv = '<div id=' + winId + ' style="padding:10px"><div id=' + lineId + '></div></div>';
            $('body').append(winDiv);
            var winOpts = {
                title: ' ҽ��ʱ����',
                collapsible: false,
                iconCls: 'icon-w-clock',
                border: false,
                resizable: true,
                minimizable: false,
                maximizable: false,
                closed: true,
                modal: true,
                width: $('body').width() - 40,
                height: 150,
                top: 20,
                left: 20,
                toolbar: null,
                onBeforeClose: function () {}
            };

            $('#' + winId).window($.extend({}, winOpts, _opts));
            $('#' + winId).window('setModalable');
        }
        $('#' + winId).window('open');
        var retData = $.cm({
            ClassName: 'PHA.COM.Query',
            QueryName: 'TimeLine',
            oeore: _qOpts.oeore
        }, false);
        var itemsArr = [];
        var rowsData = retData.rows;
        for (var i = 0; i < rowsData.length; i++) {
            var rowData = rowsData[i];
            var contextArr = [];
            contextArr.push('<div style="font-weight:normal;color:black;">');
            contextArr.push(rowData.date + ' ' + rowData.time);
            contextArr.push('</div>');
            contextArr.push('<div style="font-weight:normal;color:black;">');
            contextArr.push(rowData.userName);
            if (rowData.moreInfo !== '') {
                contextArr.push('  <span class="pha-tag pha-tag-success">' + rowData.moreInfo + '</span>');
            }
            contextArr.push('</div>');
            var item = {};
            item.title = rowData.type;
            item.context = contextArr.join('');
            itemsArr.push(item);
        }
        $('.hstep').children().remove();
        $('#' + lineId).hstep({
            showNumber: false,
            stepWidth: 200,
            currentInd: rowsData.length,
            items: itemsArr
        });
    },
    /*
    ComStatusTimeLine: function (_opts, _qOpts) {
        var winId = 'PHA_UX_ComStatusTimeLine';
        var lineId = winId + '_Line';
        var existHtml = $('#' + winId).html() || '';
        if (existHtml === '') {
            var winDiv = '<div id=' + winId + ' style="padding:10px"><div id=' + lineId + '></div></div>';
            $('body').append(winDiv);
            var winOpts = {
                title: 'ҵ��״̬ʱ����',
                collapsible: false,
                iconCls: 'icon-w-clock',
                border: false,
                resizable: true,
                minimizable: false,
                maximizable: false,
                closed: true,
                modal: true,
                width: $('body').width() - 40,
                height: 150,
                toolbar: null,
                onBeforeClose: function () {}
            };
            $('#' + winId).window($.extend({}, winOpts, _opts));
            $('#' + winId).window('setModalable');
        }
        $('#' + winId).window('open');
        var retData = $.cm({
            ClassName: 'PHA.COM.Query',
            QueryName: 'ComStatusTimeLine',
            busiCode: _qOpts.busiCode,
            busiPointer: _qOpts.busiPointer
        }, false);
        var itemsArr = [];
        var rowsData = retData.rows;
        for (var i = 0; i < rowsData.length; i++) {
            var rowData = rowsData[i];
            var contextArr = [];
            contextArr.push('<div>');
            contextArr.push(rowData.date + ' ' + rowData.time);
            contextArr.push('</div>');
            contextArr.push('<div>');
            contextArr.push(rowData.userName);
            if (rowData.moreInfo !== '') {
                contextArr.push('  <span class="pha-tag pha-tag-success">' + rowData.moreInfo + '</span>');
            }
            contextArr.push('</div>');
            var item = {};
            item.title = rowData.type;
            item.context = contextArr.join('');
            itemsArr.push(item);
        }
        $('.hstep').children().remove();
        $('#' + lineId).hstep({
            showNumber: false,
            stepWidth: 200,
            currentInd: rowsData.length,
            items: itemsArr
        });
    },
    */
    /**
     * ҽ����Ϣ����
     * @param {object} _opts  �����С����
     * @param {*} _qOpts  query���(Oeori,Oeore,DspId)
     */
    OrderDetail: function (_opts, _qOpts) {
        var winId = 'PHA_UX_OrderDetail';
        var gridId = winId + '_Grid';
        var winDiv = '<div id=' + winId + ' style="padding:10px;overflow:hidden;"><div id=' + gridId + '></div></div>';
        $('body').append(winDiv);
        //������
        var columns = [
            [{
                    field: 'group',
                    hidden: true
                }, {
                    field: 'field1',
                    title: '����',
                    width: 100,
                    align: 'right',
                    formatter: function (value, row, index) {
                        return $g(value)
                    },
                    styler: function (value, row, index) {
                        if (!PHA_UX.IsLiteCss) {
                            return 'background:#f4f6f5;';
                        }
                    }
                }, {
                    field: 'value1',
                    title: 'ֵ',
                    width: 300
                }, {
                    field: 'field2',
                    title: '����',
                    align: 'right',
                    width: 100,
                    formatter: function (value, row, index) {
                        return $g(value)
                    },
                    styler: function (value, row, index) {
                        if (!PHA_UX.IsLiteCss) {
                            return 'background:#f4f6f5;';
                        }
                    }
                }, {
                    field: 'value2',
                    title: 'ֵ',
                    width: 300,
                    styler: function (value, row, index) {
                        if (row.field2 == 'ҽ��״̬') {
                            if (['ֹͣ', '����'].indexOf(value) >= 0) {
                                return 'background:#ffe3e3';
                            }
                        } else if (row.field2 == 'Ƥ�Խ��') {
                            if (['δ��', '����'].indexOf(value) >= 0) {
                                return 'background:#ffe3e3';
                            }
                        }
                    }
                }
            ]
        ];
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'PHA.COM.Query',
                QueryName: 'OrderDetailGrp',
                Oeori: _qOpts.Oeori
            },
            fit: true,
            fitColumns: true,
            showGroup: true,
            rownumbers: false,
            columns: columns,
            pageSize: 9999,
            pagination: false,
            singleSelect: true,
            nowrap: false,
            toolbar: null,
            border: false,
            groupField: 'group',
            view: groupview,
            bodyCls: PHA_UX.IsLiteCss ? 'table-splitline' : '',
            groupFormatter: function (value, rows) {
                return $g(value);
                var retHtml = '';
                retHtml += '<div style="font-weight:bold;font-size:14x;">' + value + '</div>';
                return retHtml;
            },
            onLoadSuccess: function () {
                // ��Ƚ����ΰ�
                setTimeout(function () {
                    // $('#' + winId + " .datagrid-header").css("display", "none");
                }, 10);
            },
            gridSave: false
        };
        PHA.Grid(gridId, dataGridOption);
        $('#' + winId).window({
            title: ' ҽ����Ϣ',
            collapsible: false,
            iconCls: 'icon-w-list',
            border: false,
            resizable: true,
            minimizable: false,
            maximizable: false,
            closed: true,
            modal: true,
            width: 1000,
            height: 500,
            toolbar: null,
            onBeforeClose: function () {
                $('#' + winId).remove();
            }
        });
        $('#' + winId + " [class='panel datagrid']").css('border', '#e2e2e2 solid 1px');
        $('#' + winId + " [class='panel datagrid']").css('border-radius', '4px');
        $('#' + winId).window('open');
    },
    /**
     * ҩƷ��Ϣ����
     * @param {object} _opts : �����С����
     * @param {*} _qOpts : query���(inci,arcim,phcdf)
     * PHA_UX.DrugDetail();
     */
    DrugDetail: function (_opts, _qOpts) {
        var winId = 'PHA_UX_DrugDetail';
        var gridId = winId + '_Grid';
        var winDiv = '<div id=' + winId + ' style="padding:10px;overflow:hidden;"><div id=' + gridId + '></div></div>';
        $('body').append(winDiv);
        //������
        var columns = [
            [{
                    field: 'group',
                    hidden: true
                }, {
                    field: 'field1',
                    title: '����',
                    width: 100,
                    align: 'right',
                    styler: function (value, row, index) {
                        if (!PHA_UX.IsLiteCss) {
                            return 'background:#f4f6f5;';
                        }else{
                            return 'background:rgb(248,248,248)'
                        }
                    }
                }, {
                    field: 'value1',
                    title: 'ֵ',
                    width: 300
                }, {
                    field: 'field2',
                    title: '����',
                    align: 'right',
                    width: 100,
                    styler: function (value, row, index) {
                        if (!PHA_UX.IsLiteCss) {
                            return 'background:#f4f6f5;';
                        }else{
                            return 'background:rgb(248,248,248)'
                        }
                    }
                }, {
                    field: 'value2',
                    title: 'ֵ',
                    width: 300,
                    styler: function (value, row, index) {}
                }
            ]
        ];
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'PHA.COM.Query',
                QueryName: 'DrugDetailGrp',
                inci: _qOpts.inci,
                arcim: _qOpts.arcim,
                phcdf: _qOpts.phcdf,
                hospId: session['LOGON.HOSPID']
            },
            fit: true,
            fitColumns: true,
            showGroup: true,
            rownumbers: false,
            columns: columns,
            pageSize: 9999,
            pagination: false,
            singleSelect: true,
            nowrap: false,
            toolbar: null,
            border: false,
            groupField: 'group',
            view: groupview,
            bodyCls: PHA_UX.IsLiteCss ? 'table-splitline' : '',
            groupFormatter: function (value, rows) {
                return value;
                var retHtml = '';
                retHtml += '<div style="font-weight:bold;font-size:14x;">' + value + '</div>';
                return retHtml;
            },
            onLoadSuccess: function (data) {
                if (data.rows) {
                    var rowsData = data.rows;
                    for (var i = 0; i < rowsData.length; i++) {
                        var rowData = rowsData[i];
                        if (rowData.field1 == $g('ҩѧ����')) {
                            $(this).datagrid('mergeCells', {
                                index: i,
                                field: 'value1',
                                rowspan: null,
                                colspan: 3
                            });
                        }
                    }
                }
            },
            gridSave: false
        };
        PHA.Grid(gridId, dataGridOption);
        $('#' + winId).window({
            title: ' ҩƷ��ϸ��Ϣ',
            collapsible: false,
            iconCls: 'icon-w-list',
            border: false,
            resizable: true,
            minimizable: false,
            maximizable: false,
            closed: true,
            modal: true,
            width: 1000,
            height: 500,
            toolbar: null,
            onBeforeClose: function () {
                $('#' + winId).remove();
            }
        });
        $('#' + winId + " [class='panel datagrid']").css('border', '#e2e2e2 solid 1px');
        $('#' + winId + " [class='panel datagrid']").css('border-radius', '4px');
        $('#' + winId).window('open');
    },

    /**
     * ���ñ�������� - ҩƷ��Ϣ�������Ϣ
     * PHA_UX.DrugColumns
     */
    DrugColumns: [
        [{
                title: "inci",
                field: "inci",
                width: 100,
                hidden: true
            }, {
                title: "ҩƷ����",
                field: "inciCode",
                width: 160,
            }, {
                title: "ҩƷ����",
                field: "inciDesc",
                width: 200
            }, {
                title: "ҩƷ���",
                field: "inciSpec",
                width: 100
            }, {
                title: "pUomId",
                field: "pUomId",
                width: 100,
                hidden: true
            }, {
                title: "��ⵥλ",
                field: "pUomDesc",
                width: 80,
                align: 'center'
            }, {
                title: "���(���)",
                field: "pQty",
                width: 90,
                align: 'right'
            }, {
                title: "����(���)",
                field: "pRp",
                width: 90,
                align: 'right'
            }, {
                title: "�ۼ�(���)",
                field: "pSp",
                width: 90,
                align: 'right'
            }, {
                title: "bUomId",
                field: "bUomId",
                width: 100,
                hidden: true
            }, {
                title: "������λ",
                field: "bUomDesc",
                width: 80,
                align: 'center'
            }, {
                title: "���(����)",
                field: "bQty",
                width: 90,
                align: 'right'
            }, {
                title: "����(����)",
                field: "bRp",
                width: 90,
                align: 'right'
            }, {
                title: "�ۼ�(����)",
                field: "bSp",
                width: 90,
                align: 'right'
            }, {
                title: "������ҵ",
                field: "manfName",
                width: 160
            }, {
                title: "��λ",
                field: "stkBin",
                width: 100
            }, {
                title: "����",
                field: "phcFormDesc",
                width: 100
            }, {
                title: "��Ʒ��",
                field: "goodName",
                width: 130
            }, {
                title: "����ͨ����",
                field: "geneName",
                width: 130
            }, {
                title: "pFac",
                field: "pFac",
                width: 100,
                hidden: true
            }, {
                title: "������",
                field: "notUseFlag",
                width: 70,
                align: 'center',
                formatter: function (value, rowData, index) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            }, {
                title: "����ҩ",
                field: "highValueFlag",
                width: 70,
                align: 'center',
                formatter: function (value, rowData, index) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            }, {
                title: "������ҿ��",
                field: "reqLocQty",
                width: 100
            }, {
                title: "����ҽ������",
                field: "insuCode",
                width: 100
            }, {
                title: "����ҽ������",
                field: "insuName",
                width: 100
            }, {
                title: "����ҽ������",
                field: "insuDesc",
                width: 100,
                hidden: true
            }
        ]
    ],
    /**
     * ���ñ�������� - ҩƷ������Ϣ�������Ϣ
     * PHA_UX.BatColumns
     */
    BatColumns: [
        [{
                title: "inclb",
                field: "inclb",
                width: 100,
                hidden: true
            }, {
                title: "incib",
                field: "incib",
                width: 100,
                hidden: true
            }, {
                title: "����",
                field: "batNo",
                width: 110,
            }, {
                title: "Ч��",
                field: "expDate",
                width: 100
            }, {
                title: "������ҵ",
                field: "manfName",
                width: 180
            }, {
                title: "��Ӫ��ҵ",
                field: "vendorName",
                width: 180
            }, {
                title: "����",
                field: "inputQty",
                width: 70,
                hidden: true
            }, {
                title: "��������",   
                field: "resultQty",
                width: 70,
                hidden: true
            }, {
                title: "��ⵥλ",
                field: "pUomDesc",
                width: 70,
                align: 'center'
            }, {
                title: "���(���)",
                field: "inclbQty",
                width: 100,
                align: 'right'
            }, {
                title: "�ۼ�(���)",
                field: "pSp",
                width: 90,
                align: 'right'
            }, {
                title: "����(���)",
                field: "pRp",
                width: 90,
                align: 'right'
            }, /*{
                title: "����(���)",
                field: "pPp",
                width: 90,
                align: 'right'
            }, */{
                title: "���������",
                field: "supplyStockQty",
                width: 90,
                align: 'right'
            }, {
                title: "���󷽿��",
                field: "reqStockQty",
                width: 90,
                align: 'right'
            }, {
                title: "��λ",
                field: "stkBin",
                width: 100
            }, {
                title: "������",
                field: "ingrDate",
                width: 100,
                align: 'center'
            }, {
                title: "pFac",
                field: "pFac",
                width: 100,
                hidden: true
            }, {
                title: "ռ�ÿ��",
                field: "dirtyQty",
                width: 90,
                align: 'right'
            }, {
                title: "���ÿ��",
                field: "avaQty",
                width: 90,
                align: 'right'
            }, {
                title: "����ҩ",
                field: "highValueFlag",
                width: 80,
                align: 'center',
                formatter: function (value, rowData, index) {
                    if (value == 'Y') {
                        return PHA_COM.Fmt.Grid.Yes.Chinese;
                    } else {
                        return PHA_COM.Fmt.Grid.No.Chinese;
                    }
                }
            }, {
                title: "Ԥ����־",
                field: "inclbWarnFlag",
                width: 90,
                align: 'center',
                styler: function (value, row, index) {
                    if (value == '1') {
                        return 'background:yellow;';
                    }
                    if (value == '2') {
                        return 'background:red;';
                    }
                    return '';
                },
                formatter: function (value, row, index) {
                    if (value == '1') {
                        return '<label >' + $g('ҩƷ���ι���')  + '</label>';
                    }
                    if (value == '2') {
                        return '<label >' + $g('ҩƷ���β�����')  + '</label>';
                    }
                    return value;
                }
            }
        ]
    ],
    /*
     * ���ñ�������� - ��̬��ȡ����
     */
    Get: function (domId, defVal) {
        return {
            _type: 'domId',
            domId: domId,
            defVal: (typeof defVal == 'undefined' ? '' : defVal)
        };
    },
    /*
     * ���ñ�������� - ����Ĭ��ֵ
     */
    _SetComboVal: function (t, data, defVal, findDef) {
        var cmbOpts = $(t).combobox('options');
        if (cmbOpts.hasDefVal) {
            return;
        }
        $(t).combobox('setValues', []);
        $(t).combobox('setText', '');
        var valueField = cmbOpts.valueField;
        var findField = valueField;
        var findValue = defVal;
        if (findDef) {
            findField = findDef.field;
            findValue = findDef.value;
        }
        if (data && data.length == 1 && cmbOpts.selectIfOne !== false) {
            $(t).combobox('setValue', data[0][valueField]);
            cmbOpts.hasDefVal = true;
            var onSelect = $(t).combobox('options').onSelect;
            onSelect && onSelect.call(t, data[0]); // ���༶������
            return;
        }
        for (var i = 0; i < data.length; i++) {
            var iData = data[i];
            if (iData[findField] == findValue) {
                $(t).combobox('setValue', iData[valueField]);
                cmbOpts.hasDefVal = true;
                var onSelect = $(t).combobox('options').onSelect;
                onSelect && onSelect.call(t, iData); // ���༶������
                break;
            }
        }
    },
    /*
     * ���ñ�������� - �����ϲ�
     */
    _ExtendParam: function (retData, tData) {
        for (var k in tData) {
            var v = tData[k];
            if (typeof v == 'object') {
                if (v._type == 'domId') {
                    retData[k] = v;
                } else {
                    retData[k] = retData[k] ? retData[k] : {};
                    for (var j in v) {
                        retData[k][j] = v[j];
                    }
                }
            } else {
                retData[k] = v;
            }
        }
        return retData;
    },
    /*
     * ���ñ�������� - ��������
     */
    _FormatParam: function (_param, _relaId) {
        var _tJson = {};
        for (var pKey in _param) {
            var pVal = _param[pKey];
            if ((typeof pVal == 'object') && (pVal._type == 'domId')) {
                _tJson[pKey] = this._GetDomParam(pVal.domId, pVal.defVal);
                setRela(pVal.domId, _relaId);
            } else if (typeof pVal == 'object') {
                var pJson = {};
                for (var jKey in pVal) {
                    var jVal = pVal[jKey];
                    if ((typeof jVal == 'object') && (jVal._type == 'domId')) {
                        pJson[jKey] = this._GetDomParam(jVal.domId, jVal.defVal);
                        setRela(jVal.domId, _relaId);
                    } else {
                        pJson[jKey] = jVal;
                    }
                }
                _tJson[pKey] = JSON.stringify(pJson);
            } else {
                _tJson[pKey] = pVal;
            }
        }
        return _tJson;
        // ����������ID
        function setRela(domId, relaId) {
            if (!PHA_UX.rela) {
                PHA_UX.rela = {};
            }
            if (!PHA_UX.rela[domId]) {
                PHA_UX.rela[domId] = []
            }
            if (PHA_UX.rela[domId].indexOf(relaId) < 0) {
                PHA_UX.rela[domId].push(relaId);
            }
        }
    },
    /*
     * ���ñ�������� - ����domId��ȡ����ֵ
     */
    _GetDomParam: function (domId, defVal) {
        defVal = (typeof defVal == 'undefined' || defVal == null) ? '' : defVal;
        var clsStr = $('#' + domId).attr('class');
        if (!clsStr) {
            return defVal;
        }
        if (clsStr.indexOf('combogrid') >= 0) {
            return ($('#' + domId).combogrid('getValue') || defVal);
        }
        if (clsStr.indexOf('combobox') >= 0) {
            if ($('#' + domId).combobox('options').multiple) {
                return ($('#' + domId).combobox('getValues').join(",") || defVal);
            } else {
                return ($('#' + domId).combobox('getValue') || defVal);
            }
        }
        if (clsStr.indexOf('validatebox') >= 0) {
            return ($('#' + domId).val() || defVal);
        }
        return defVal;
    },
    /*
     * ���ñ�������� - ����ˢ�� (ˢ����һ��)
     */
    _RelaRefresh: function (_id) {
        var rela = PHA_UX.rela;
        if (rela == null || typeof rela == 'undefined') {
            return;
        }
        var relaArr = rela[_id];
        if (relaArr && relaArr.length > 0) {
            for (var i = 0; i < relaArr.length; i++) {
                var iRelaId = relaArr[i];
                var $_dom = $('#' + iRelaId);
                var clsStr = $_dom.attr('class');
                if (clsStr) {
                    if (clsStr.indexOf('combogrid') >= 0) {
                        $_dom.combogrid('clear'); // Ҳ�����̨ TODO...
                        var $_grid = $_dom.combogrid('grid');
                        $_grid.datagrid('reload');
                    } else if (clsStr.indexOf('combotree') >= 0) {
                        PHA_UX._LoadTree(iRelaId);
                    } else if (clsStr.indexOf('combobox') >= 0) {
                        $_dom.combobox('options').hasDefVal = false;
                        $_dom.combobox('setValue', '');
                        $_dom.combobox('setText', '');
                        $_dom.combobox('reload');
                    }
                }
            }
        }
    },
    /*
     * ���ñ�������� - ����������
     */
    _LoadTree: function (_id) {
        $('#' + _id).combotree('setValue', '');
        $('#' + _id).combotree('setText', '');
        var treeOpts = $('#' + _id).combotree('options');
        var nParams = PHA_UX._FormatParam(treeOpts.qParams, _id);
        nParams.QText = '';
        nParams.hospId = session['LOGON.HOSPID'];
        var pArr = [];
        for (var k in nParams) {
            pArr.push(k + '=' + nParams[k]);
        }
        if (!treeOpts._url) {
            treeOpts._url = treeOpts.url;
        }
        var loadUrl = treeOpts._url + '&' + pArr.join('&');
        $('#' + _id).combotree('reload', loadUrl);
    },
    /**
     * ����س������ - ������
     * Huxt 2022-03-19
     */
    ComboBox: {
        // ����: PHA_UX.ComboBox.Loc(id);
        Loc: function (_id, _opts) {
            // ����
            _opts = _opts || {};
            _opts.qParams = PHA_UX._ExtendParam({}, _opts.qParams);
            _opts.defValue = (typeof _opts.defValue == 'undefined') ? session['LOGON.CTLOCID'] : _opts.defValue;
            _opts.relType = _opts.qParams.relType;
            // �򵥵�
            if (_opts.simple) {
                var _defOpts = {
                    placeholder: '����...',
                    url: PHA_STORE.CTLoc().url,
                    mode: 'remote',
                    onBeforeLoad: function (param) {
                        param.QText = param.q || '';
                        param.hospId = session['LOGON.HOSPID'];
                        var cOpts = $(this).combobox('options');
                        var nParam = PHA_UX._FormatParam(cOpts.qParams, _id);
                        $.extend(param, nParam);
                    },
                    onLoadSuccess: function (data) {
                        var _defValue = _opts.defValue || session['LOGON.CTLOCID'];
                        PHA_UX._SetComboVal(this, data, _defValue);
                    }
                };
                PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
                return;
            }
            // ���ӵ�
            var _defOpts = {
                placeholder: '����...',
                url: '',
                mode: 'remote',
                onBeforeLoad: function (param) {
                    param.QText = param.q || '';
                    param.hospId = session['LOGON.HOSPID'];
                    var cOpts = $(this).combobox('options');
                    var _relType = cOpts.relType;
                    if (_relType == 'T' || _relType == 'R') {
                        // ���ݹ������һ�ȡ�������
                        cOpts.url = PHA_STORE.RelLocByPro().url;
                    } else if (_relType == 'TR' || _relType == 'RF') {
                        // ����������һ�ȡ��������
                        cOpts.qParams.relType = (_relType == 'TR') ? '' : 'R';
                        cOpts.url = PHA_STORE.RelLocByRec().url;
                    } else {
                        // ��ȫ������Ȩ�Ŀ���
                        cOpts.url = PHA_STORE.GetGroupDept().url;
                    }
                    var nParam = PHA_UX._FormatParam(cOpts.qParams, _id);
                    $.extend(param, nParam);
                },
                onLoadSuccess: function (data) {
                    var cOpts = $(this).combobox('options');
                    PHA_UX._SetComboVal(this, data, cOpts.defValue);
                },
                onSelect: function (record) {
                    PHA_UX._RelaRefresh(_id);
                },
                onChange: function (record) {
                    PHA_UX._RelaRefresh(_id);
                }
            };
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // ����: PHA_UX.ComboBox.StkCatGrp(id);
        StkCatGrp: function (_id, _opts) {
            // ����
            _opts = _opts || {};
            _opts.qParams = PHA_UX._ExtendParam({}, _opts.qParams);
            // �򵥵�
            if (_opts.simple) {
                var _defOpts = {
                    placeholder: '����...',
                    mode: 'remote',
                    url: PHA_STORE.DHCStkCatGroup().url
                }
                PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
                return;
            }
            // ���ӵ�
            var _defOpts = {
                placeholder: '����...',
                mode: 'remote',
                url: PHA_STORE.LocStkCatGroup().url,
                onBeforeLoad: function (param) {
                    param.QText = param.q || '';
                    param.hospId = session['LOGON.HOSPID'];
                    var cOpts = $(this).combobox('options');
                    var nParam = PHA_UX._FormatParam(cOpts.qParams, _id);
                    $.extend(param, nParam);
                },
                onLoadSuccess: function (data) {
                    PHA_UX._SetComboVal(this, data, null, {
                        field: 'Default',
                        value: 'Y'
                    });
                },
                /*onSelect: function (record) {
                    PHA_UX._RelaRefresh(_id);
                },*/
                onChange: function (record) {
                    PHA_UX._RelaRefresh(_id);
                    setTimeout(function(){PHA_UX._RelaRefresh(_id);}, 500);   // �ӳ�ִ�У���ֹ���������ʼ���¼��������¼����
                }
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // ������: PHA_UX.ComboBox.StkCat(id);
        StkCat: function (_id, _opts) {
            var _defOpts = {
                placeholder: '������...',
                mode: 'remote',
                url: PHA_STORE.INCStkCat().url,
                onBeforeLoad: function (param) {
                    param.QText = param.q || '';
                    param.NeedScgFlag = 'Y';
                    var cOpts = $(this).combobox('options');
                    var nParam = PHA_UX._FormatParam(cOpts.qParams, _id);
                    $.extend(param, nParam);
                },
                onLoadSuccess: function (data) {
                    $(this).combobox('setValues', []);
                }
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // ��Ӫ��ҵ: PHA_UX.ComboBox.Vendor(id);
        Vendor: function (_id, _opts) {
            var _defOpts = {
                placeholder: '��Ӫ��ҵ...',
                mode: 'remote',
                url: PHA_STORE.APCVendor().url
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // ������ҵ: PHA_UX.ComboBox.Manf(id);
        Manf: function (_id, _opts) {
            var _defOpts = {
                placeholder: '������ҵ...',
                mode: 'remote',
                url: PHA_STORE.PHManufacturer().url
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // ��λ: PHA_UX.ComboBox.Uom(id);
        Uom: function (_id, _opts) {
            var _defOpts = {
                placeholder: '��λ...',
                mode: 'remote',
                url: PHA_STORE.CTUOM().url
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // ���Ʒ���: PHA_UX.ComboBox.Poison(id);
        Poison: function (_id, _opts) {
            var _defOpts = {
                placeholder: '���Ʒ���...',
                mode: 'remote',
                url: PHA_STORE.PHCPoison().url
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // �����: PHA_UX.ComboBox.INCItm(id);
        INCItm: function (_id, _opts) {
            var _defOpts = PHA_STORE.INCItm('Y');
            _defOpts.valueField = _defOpts.idField;
            _defOpts.placeholder = 'ҩƷ...';
            _defOpts.mode = 'remote';
            _defOpts.onBeforeLoad = function (param) {
                param.QText = param.q;
            }
            var _newOpts = $.extend({}, _defOpts, _opts);
            if (!_newOpts.url) {
                _newOpts.url = $URL + '?ResultSetType=Array';
                for (var k in _defOpts.queryParams) {
                    _newOpts.url += '&' + k + '=' + _defOpts.queryParams[k];
                }
            }
            PHA.ComboBox(_id, _newOpts);
        },
        // ���һ�λ������: PHA_UX.ComboBox.StkBinComb(id);
        StkBinComb: function (_id, _opts) {
            var _defOpts = {
                placeholder: '��λ��...',
                mode: 'remote',
                selectIfOne: false,
                url: PHA_IN_STORE.StkBinComb('').url,
                onBeforeLoad: function (param) {
                    param.QText = param.q || '';
                    var cOpts = $(this).combobox('options');
                    var nParam = PHA_UX._FormatParam(cOpts.qParams, _id);
                    $.extend(param, nParam);
                },
                onLoadSuccess: function (data) {
                    PHA_UX._SetComboVal(this, data, '');
                }
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // ���һ�λ(����)������: PHA_UX.ComboBox.StkBinRacks(id);
        StkBinRacks: function (_id, _opts) {
            var _defOpts = {
                placeholder: '������...',
                mode: 'remote',
                selectIfOne: false,
                url: PHA_IN_STORE.StkBinRacks('').url,
                onBeforeLoad: function (param) {
                    param.QText = param.q || '';
                    var cOpts = $(this).combobox('options');
                    var nParam = PHA_UX._FormatParam(cOpts.qParams, _id);
                    $.extend(param, nParam);
                },
                onLoadSuccess: function (data) {
                    PHA_UX._SetComboVal(this, data, '');
                }
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // �����̵���: PHA_UX.ComboBox.StkTkGrp(id);
        StkTkGrp: function (_id, _opts) {
            var _defOpts = {
                placeholder: '�̵���...',
                mode: 'remote',
                selectIfOne: false,
                url: PHA_STORE.LocManGrp('').url,
                onBeforeLoad: function (param) {
                    param.QText = param.q || '';
                    var cOpts = $(this).combobox('options');
                    var nParam = PHA_UX._FormatParam(cOpts.qParams, _id);
                    $.extend(param, nParam);
                },
                onLoadSuccess: function (data) {
                    PHA_UX._SetComboVal(this, data, '');
                }
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        }
    },
    /**
     * ����س������ - ������
     * yangsj 2022-07-25
     */
    ComboTree: {
        stkBin: function (_id, _opts) {
            _opts = _opts || {};
            _opts.placeholder = $g(_opts.placeholder);
            var _defOpts = {
                url: PHA_IN_STORE.StkBinTree().url,
                placeholder: '��λ...',
                mode: 'remote',
                onSelect: function (record) {
                    PHA_UX._RelaRefresh(_id);
                }
            }
            var _nOpts = $.extend({}, _defOpts, _opts);
            $('#' + _id).combotree(_nOpts);
            PHA_UX._LoadTree(_id);
        }
    },
    /**
     * ����س������ - �������
     * Huxt 2022-03-19
     */
    ComboGrid: {
        // ������������: PHA_UX.ComboGrid.INCItm(id);
        INCItm: function (_id, _opts) {
            // ����
            _opts = _opts || {};
            _opts.qParams = PHA_UX._ExtendParam({
                pJsonStr: {
                    scgId: '',
                    stkType: 'G',
                    userId: session['LOGON.USERID'],
                    locId: session['LOGON.CTLOCID'],
                    reqLocId: '',
                    notUseFlag: '',
                    qtyFlag: ''
                }
            }, _opts.qParams);
            var _view = (typeof scrollview == 'undefined' ? undefined : scrollview);
            // �򵥵�
            if (_opts.simple) {
                var _defOpts = PHA_STORE.INCItm('Y');
                _defOpts.fitColumns = true;
                _defOpts.pageSize = 30;
                _defOpts.rownumbers = true;
                _defOpts.view = _view;
                if (_defOpts.view) {
                    _defOpts.pagination = false;
                }
                PHA.ComboGrid(_id, $.extend({}, _defOpts, _opts));
                return;
            }
            // ���ӵ�
            /* ɾ�������� */
            var columns0 = PHA_UX.DrugColumns[0];
            var deleteFieldArr = ['reqLocQty'];
            var lenColu = columns0.length;
            for (var ii = (lenColu - 1); ii >= 0; ii--) {
                var obj = columns0[ii];
                if (deleteFieldArr.indexOf(obj.field) >= 0){
                    columns0.splice(ii, 1); 
                }
            }
            var _defOpts = {
                panelWidth: 800,
                panelHeight: 240,
                pageSize: 30,
                view: _view,
                url: $URL,
                rownumbers: true,
                idField: 'inci',
                textField: 'inciDesc',
                queryParams: {
                    ClassName: 'PHA.STORE.Drug',
                    QueryName: 'DrugDetail'
                },
                columns: [columns0],
                onBeforeLoad: function (param) {
                    param.QText = param.q || '';
                    param.hospId = session['LOGON.HOSPID'];
                    var cOpts = $(this).datagrid('options');
                    var nParam = PHA_UX._FormatParam(cOpts.qParams, _id);
                    $.extend(param, nParam);
                    if (typeof nParam === 'object') {
                        param.pJsonStr = JSON.stringify($.extend(JSON.parse(param.pJsonStr), nParam))
                    }
                },
                onSelect: function (record) {
                    PHA_UX._RelaRefresh(_id);
                }
            }
            if (_defOpts.view) {
                _defOpts.pagination = false;
            }
            PHA.ComboGrid(_id, $.extend({}, _defOpts, _opts));

        },
        // ��������������: PHA_UX.ComboGrid.INCItmBat(id);
        INCItmBat: function (_id, _opts) {
            // ����
            _opts = _opts || {};
            _opts.qParams = PHA_UX._ExtendParam({
                pJsonStr: {
                    stkType: 'G',
                    locId: session['LOGON.CTLOCID'],
                    inci: '',
                    qtyFlag: '',
                    reqLocId: ''
                }
            }, _opts.qParams);
            var _view = (typeof scrollview == 'undefined' ? undefined : scrollview);
            // Ĭ������
            var _defOpts = {
                panelWidth: 660,
                panelHeight: 240,
                pageSize: 30,
                view: _view,
                rownumbers: true,
                url: $URL,
                idField: 'inclb',
                textField: 'inciDesc',
                queryParams: {
                    ClassName: 'PHA.STORE.Drug',
                    QueryName: 'BatDetail',
                    hospId: session['LOGON.HOSPID']
                },
                columns: PHA_UX.BatColumns,
                onBeforeLoad: function (param) {
                    param.QText = param.q || '';
                    param.hospId = session['LOGON.HOSPID'];
                    var cOpts = $(this).datagrid('options');
                    var nParam = PHA_UX._FormatParam(cOpts.qParams, _id);
                    $.extend(param, nParam);
                },
                onSelect: function (record) {
                    PHA_UX._RelaRefresh(_id);
                }
            };
            if (_defOpts.view) {
                _defOpts.pagination = false;
            }
            PHA.ComboGrid(_id, $.extend({}, _defOpts, _opts));
        }
    },
    /**
     * ���༭��س������
     * Huxt 2022-03-19
     */
    Grid: {
        // ҩƷ�������
        INCItm: function (iOpts) {
            /* �������� */
            var cmbOpData = [];
            var gOperators = $.fn.datagrid.defaults.operators;
            if (!gOperators) {
                gOperators = {
                    nofilter: {
                        text: $g('��')
                    },
                    contains: {
                        text: $g('����')
                    },
                    equal: {
                        text: $g('����')
                    },
                    notequal: {
                        text: $g('������')
                    },
                    beginwith: {
                        text: $g('ǰƥ��')
                    },
                    endwith: {
                        text: $g('��ƥ��')
                    },
                    less: {
                        text: $g('С��')
                    },
                    lessorequal: {
                        text: $g('С�ڵ���')
                    },
                    greater: {
                        text: $g('����')
                    },
                    greaterorequal: {
                        text: $g('���ڵ���')
                    }
                }
            }
            for (var k in gOperators) {
                if (k == 'nofilter') {
                    continue;
                }
                cmbOpData.push({
                    RowId: k,
                    Description: gOperators[k].text
                });
            }
            /* �����ֶ� */
            var cmbFieldData = [{
                    RowId: 'any',
                    Description: '������'
                }
            ];
            var dCols = PHA_UX.DrugColumns[0];
            for (var c = 0; c < dCols.length; c++) {
                if (!dCols[c].hidden) {
                    cmbFieldData.push({
                        RowId: dCols[c].field,
                        Description: dCols[c].title
                    });
                }
            }
            /* ����������� */
            var _view = (typeof scrollview == 'undefined' ? undefined : scrollview);
            /* ɾ�������� */
            var columns0 = PHA_UX.DrugColumns[0];
            var deleteFieldArr = ['reqLocQty'];
            var lenColu = columns0.length;
            for (var ii = (lenColu - 1); ii >= 0; ii--) {
                var obj = columns0[ii];
                if (deleteFieldArr.indexOf(obj.field) >= 0){
                    columns0.splice(ii, 1); 
                }
            }
            var _defOpts = {
                type: 'lookup',
                regExp: /\S/,
                regTxt: '����Ϊ��!',
                panelWidth: 800,
                panelHeight: 280,
                pageSize: 50,
                view: _view,
                rownumbers: true,
                novalidate: true, // for lookup
                clickDelay: 0, // lookupû����
                url: $URL,
                queryParams: {
                    ClassName: 'PHA.STORE.Drug',
                    QueryName: 'DrugDetail'
                },
                idField: 'inci',
                textField: 'inciDesc',
                columns: [columns0],
                toolbarItems: [{
                        type: 'combobox',
                        name: 'field',
                        data: cmbFieldData,
                        value: 'any',
                        placeholder: '�����ֶ�...'
                    }, {
                        type: 'combobox',
                        name: 'op',
                        data: cmbOpData,
                        value: 'contains',
                        placeholder: '���˲���...'
                    }, {
                        type: 'searchbox',
                        name: 'value',
                        placeholder: '�����������...',
                        queryOnInput: true,
                        width: 200
                    }
                ]
            };
            if (_defOpts.view) {
                _defOpts.pagination = false;
            }
            var nOpts = $.extend({}, _defOpts, iOpts);
            return PHA_GridEditor.ComboGrid(nOpts, nOpts.type);
        },
        // ҩƷ����
        INCItmWin: function (iOpts) {
            iOpts = iOpts || {};
            var _defOpts = {
                winOptions: {
                    win: {
                        id: 'Drug_Detail_Win',
                        title: '��ѡ��ҩƷ'
                    },
                    grid: {
                        center: {
                            title: 'ҩƷ��Ϣ - ˫���л򰴻س�������',
                            height: 280,
                            rownumbers: true,
                            queryParams: {
                                ClassName: 'PHA.STORE.Drug',
                                QueryName: 'DrugDetail'
                            },
                            columns: PHA_UX.DrugColumns
                        }
                    }
                }
            }
            return PHA_GridEditor.Window($.extend({}, _defOpts, iOpts), 'icon-card');
        },
        // ҩƷ���ε���
        INCItmBatWin: function (iOpts, otherIOpts) {
            iOpts = iOpts || {};
            otherIOpts = otherIOpts || {};
            //var inputField = 'inputQty';   
            var inputFieldArr = ['inputQty'];
            var batTitle = "ҩƷ������Ϣ - ¼��������˫���л򰴻س�������"
            if(otherIOpts.inputType == "ADJ") {
                inputFieldArr.push('resultQty');  //����ǿ�����ʹ�á����������������༭��
                batTitle = "ҩƷ������Ϣ - ¼������/����������˫���л򰴻س�������"
            }
            if((otherIOpts.inputType == "ADJ")||(otherIOpts.inputType == "SCRAP")) {
                var batCols = PHA_UX.BatColumns[0]; 
                for (var c = 0; c < batCols.length; c++) {
                    if ((batCols[c].field == "reqStockQty")||(batCols[c].field == "supplyStockQty")) {
                        batCols[c].hidden = true;
                    }
                }
                var drugCols = PHA_UX.DrugColumns[0]; 
                for (var c = 0; c < drugCols.length; c++) {
                    if (drugCols[c].field== "reqLocQty") {
                        drugCols[c].hidden = true;
                    }
                }
            }
            
            
            if (iOpts.onClickSure) {
                var bCols = PHA_UX.BatColumns[0];
                for (var c = 0; c < bCols.length; c++) {
                    //if (bCols[c].field == inputField) {  
                    if (inputFieldArr.indexOf(bCols[c].field) >= 0) {
                        
                        bCols[c].editor = PHA_GridEditor.NumberBox({
                            keyPropagation: true
                        });
                        bCols[c].hidden = false;
                        //break;  
                    }
                }
            }
            var _defOpts = {
                winOptions: {
                    win: {
                        id: 'DrugBat_Detail_Win',
                        title: '��ѡ��ҩƷ����'
                    },
                    grid: {
                        north: {
                            title: 'ҩƷ��Ϣ',
                            height: 280,
                            rownumbers: true,
                            queryParams: {
                                ClassName: 'PHA.STORE.Drug',
                                QueryName: 'DrugDetail'
                            },
                            columns: PHA_UX.DrugColumns,
                            onLoadSuccess: function (data) {
                                /*
                                var pJsonStr = JSON.parse($(this).datagrid('options').queryParams.pJsonStr);
                                var reqLocId = pJsonStr.reqLocId;
                                if((reqLocId=="")||(reqLocId == undefined)){
                                    $(this).datagrid('hideColumn','reqLocQty');
                                }
                                $(this).datagrid('hideColumn','reqLocQty') ;
                                */
                            }
                        },
                        center: {
                            title: batTitle,
                            pagination: false,
                            rownumbers: true,
                            queryParams: {
                                ClassName: 'PHA.STORE.Drug',
                                QueryName: 'BatDetail'
                            },
                            columns: PHA_UX.BatColumns,
                            onClickCell: function (index, field, value) {
                                //if (field == inputField) {  
                                if (inputFieldArr.indexOf(field) >= 0){
                                    var gOpts = $(this).datagrid('options');
                                    PHA_GridEditor.Edit({
                                        gridID: gOpts.id,
                                        index: index,
                                        field: field
                                    });
                                }
                            },
                            ///editFieldSort: [inputField],  
                            editFieldSort: inputFieldArr,
                            queryKeywords: {
                                items: [
                                    {id:'0', text:'������', selected: true},
                                    {id:'1', text:'���п��' , selected: true}
                                ]
                            }
                        }
                    }
                }
            }
            return PHA_GridEditor.Window($.extend({}, _defOpts, iOpts), 'icon-card');
        },
        // ��λ
        INCItmUom: function (iOpts) {
            var _defOpts = {
                panelHeight: 'auto',
                url: $URL + '?ResultSetType=Array&ClassName=PHA.STORE.Drug&QueryName=INCIUom',
                onBeforeLoad: function (param, gridRowData) {
                    param.hospId = session['LOGON.HOSPID'];
                    param.inci = gridRowData.inci || '';
                }
            };
            return PHA_GridEditor.ComboBox($.extend({}, _defOpts, iOpts));
        },
        // ҩƷ��ⵯ��
        INCItmRecWin: function (iOpts, gridOptions) {
            iOpts = iOpts || {};
            var _defOpts = {
                winOptions: {
                    win: {
                        id: 'DrugBatRec_Detail_Win',
                        title: '��ѡ��ҩƷ����¼'
                    },
                    grid: {
                        north: {
                            title: 'ҩƷ��Ϣ',
                            height: 280,
                            rownumbers: true,
                            queryParams: {
                                ClassName: 'PHA.STORE.Drug',
                                QueryName: 'DrugDetail'
                            },
                            columns: PHA_UX.DrugColumns
                        },
                        center: {
                            title: 'ҩƷ������Ϣ - ¼��������˫���л򰴻س�������',
                            pagination: false,
                            rownumbers: true,
                            url: PHA.$URL,
                            queryParams: {
                                // ClassName: 'PHA.COM.Broker',
                                // MethodName: 'Invoke',
                                pClassName: 'PHA.IN.REC.Face',
                                pMethodName: 'GetRecInclbRows4Ret',
                                pPlug: 'datagrid',
                                sort: 'recDate',
                                order: 'desc'
                            },
                            onBeforeLoad: function (params) {
                                $(this).datagrid('options').url =
                                    'websys.Broker.cls?ClassName=PHA.COM.Broker&MethodName=Invoke'
                            },
                            frozenColumns: [[{
                                        field: 'gCheck',
                                        checkbox: true,
                                        hidden: true
                                    }, {
                                        field: 'warnInfo',
                                        title: '����',
                                        width: 100,
                                        styler: function (value) {
                                            value = value || '';
                                            if (value !== '') {
                                                return 'background:red;color:#fff;';
                                            }
                                        }
                                    }
                                ]
                            ],
                            columns: [
                                [{
                                        title: "recItmID",
                                        field: "recItmID",
                                        width: 100,
                                        hidden: true
                                    }, {
                                        field: "recDate",
                                        title: "�������",
                                        width: 100,
                                        sortable: true
                                    }, {
                                        title: "inclb",
                                        field: "inclb",
                                        width: 100,
                                        hidden: true
                                    }, {
                                        title: "incib",
                                        field: "incib",
                                        width: 100,
                                        hidden: true
                                    }, {
                                        title: "����",
                                        field: "batNo",
                                        width: 110,
                                    }, {
                                        title: "Ч��",
                                        field: "expDate",
                                        width: 100
                                    }, {
                                        title: "����",
                                        field: "inputQty",
                                        width: 70,
                                        editor: PHA_GridEditor.NumberBox({
                                            keyPropagation: true
                                        }),
                                        styler: function (val, rowData, rowIndex) {
                                            if (val === undefined || val === '') {
                                                return ''
                                            }
                                            var diffQty = _.safecalc('add', val, -1 * rowData.inclbAvaQty);
                                            if (diffQty > 0) {
                                                return {
                                                    class: 'pha-datagrid-validate-col'
                                                }
                                            }
                                        }
                                    }, {
                                        title: "���ÿ��",
                                        field: "inclbAvaQty",
                                        width: 100,
                                        align: 'right',
                                        styler: function () {
                                            return 'font-weight:bold;'
                                        }
                                    }, {
                                        title: "���ʱ����",
                                        field: "recQty",
                                        width: 80,
                                        align: 'right'
                                    }, {
                                        title: "���ʱ��λ",
                                        field: "recUomDesc",
                                        width: 80,
                                        align: 'left'
                                    }, {
                                        title: "������ҵ",
                                        field: "manfDesc",
                                        width: 180
                                    }, {
                                        title: "����ۼ�",
                                        field: "sp",
                                        width: 90,
                                        align: 'right' //,
                                        // formatter:function(value, rowData){
                                        //     return value + '/' + rowData.recUomDesc
                                        // }
                                    }, {
                                        title: "������",
                                        field: "rp",
                                        width: 90,
                                        align: 'right'
                                    },{
                                        title: "��ǰ�ۼ�",
                                        field: "curSp",
                                        width: 90,
                                        align: 'right',
                                        styler: function(value, row, index){
											var sp = row.sp;
											if(sp != value) return 'background:#f1c516;color:white;';
										}
                                    }, {
                                        title: "��ǰ����",
                                        field: "curRp",
                                        width: 90,
                                        align: 'right',
                                        styler: function(value, row, index){
											var rp = row.rp;
											if(rp != value) return 'background:#f1c516;color:white;';
										}
                                    },{
                                        title: "����ҩ",
                                        field: "highValueFlag",
                                        width: 80,
                                        align: 'center',
                                        formatter: function (value, rowData, index) {
                                            if (value == 'Y') {
                                                return PHA_COM.Fmt.Grid.Yes.Chinese;
                                            } else {
                                                return PHA_COM.Fmt.Grid.No.Chinese;
                                            }
                                        }
                                    }
                                ]
                            ],
                            onClickCell: function (index, field, value) {
                                var gOpts = $(this).datagrid('options');
                                var rowData = $(this).datagrid('getRows')[index]
                                    if (rowData.banFlag === true) {
                                        return
                                    }
                                    PHA_GridEditor.Edit({
                                    gridID: gOpts.id,
                                    index: index,
                                    field: field
                                });
                            },
                            editFieldSort: ['inputQty'],
                            singleSelect: true,
                            onLoadSuccess: function () {
                                $(this).datagrid('clearChecked')
                            },
                            onAfterEdit: function (rowIndex, rowData, changes) {
                                // var originalRowData = $.data($(this)[0], 'datagrid').originalRows[rowIndex]
                                // var originalInputQty = originalRowData.inputQty
                                // if (originalInputQty === undefined){
                                //      originalInputQty = ''
                                // }
                                // if (rowData.inputQty === originalInputQty){
                                //     $(this).datagrid('uncheckRow', rowIndex)
                                // }
                            }
                        }
                    }
                }
            }
            $.extend(_defOpts.winOptions.grid.north, gridOptions.north)
            $.extend(_defOpts.winOptions.grid.center, gridOptions.center)
            // �ر��¼��Ĵ���
            return PHA_GridEditor.Window($.extend({}, _defOpts, iOpts), 'icon-w-other');
        }
    },
    /**
     * ������� ���ù��߷���(��ֱ�ӵ���)
     * Huxt 2022-04-04
     */
    Util: {
        // ��̬��ȡС��λ��
        GetNumPrecision: function (inci, uom) {
            if (!uom || !inci)
                return {};
            var pJson = {
                inci: inci,
                uom: uom,
                hospId: session['LOGON.HOSPID']
            }
            return PHA.CM({
                pClassName: 'PHA.STORE.Com',
                pMethodName: 'GetNumPrecision',
                pJsonStr: JSON.stringify(pJson)
            }, false);
        },
        // ��ȡҩƷ��Ӧ��λ������ (�л���λ�¼�����)
        GetInciUomData: function (inci, uom, proLocId, recLocId) {
            if (!uom || !inci)
                return {};
            var pJson = {
                inci: inci,
                uomId: uom,
                proLocId: proLocId || '',
                recLocId: recLocId || '',
                hospId: session['LOGON.HOSPID']
            }
            return PHA.CM({
                pClassName: 'PHA.STORE.Com',
                pMethodName: 'GetInciUomData',
                pJson: JSON.stringify(pJson)
            }, false);
        },
        GetInclbUomData: function (inclb, uomId) {
            if (!uomId || !inclb)
                return {};
            var pJson = {
                inclb: inclb,
                uomId: uomId,
                hospId: session['LOGON.HOSPID']
            }
            return PHA.CM({
                pClassName: 'PHA.STORE.Com',
                pMethodName: 'GetInclbUomData',
                pJson: JSON.stringify(pJson)
            }, false);
        }
    },
    /**
     * zhaozhiduan 2022-07-05
     * �������,ҵ������ʱ����
     *      _opts       ��������
     *      _qOpts
     *                  busiCode��ҵ�����
     *                  locId������id,
     *                  pointer��ҵ��id
     *      operType    ���ڿ���
     */
    BusiTimeLine: function (_opts, _qOpts, operType) {
        if (operType == '' || operType == undefined) {
            operType = 'open';
        } else {
            operType = 'close';
        }
        var no = _qOpts.No || '';
        var winId = 'PHA_Busi_TimeLine';
        if (operType == 'close') {
            $('#' + winId).window('close');
            return;
        }
        var lineId = winId + '_Line';
        var existHtml = $('#' + winId).html() || '';
        var pointer = _qOpts.pointer;
        if ($('#' + winId).css('display') == 'none') {
            return;
        }
        if (existHtml === '') {
            var winDiv = '<div id=' + winId + ' style="padding:10px"><div id=' + lineId + '></div></div>';
            $('body').append(winDiv);
            if (window.event) {
                var targetLeft = $(window.event.target).position().left + $(window.event.target).closest('td').width();
            }
            var winOpts = {
                title: $g('ҵ�����ʱ����') + no,
                collapsible: true,
                iconCls: 'icon-w-clock',
                border: false,
                resizable: false,
                minimizable: false,
                maximizable: false,
                collapsible: false,
                closed: true,
                modal: false,
                width: 400,
                //width: $('body').width() - 40,
                height: $('body').height() - 40,
                //top: 20,
                left: $('body').width() - 420,
                //left: targetLeft,
                toolbar: null,
                onBeforeClose: function () {}
            };

            $('#' + winId).window($.extend({}, winOpts, _opts));
            $('#' + winId).window('setModalable');
        }
        $('#' + winId).window('open');
        var cmData = $.cm({
            ClassName: 'PHA.COM.Query',
            QueryName: 'BusiStatusTimeLine',
            busiCode: _qOpts.busiCode,
            busiPointer: pointer
        }, false);
        rowsData = cmData.rows;
        var itemsArr = [];
        var curId = 0;
        for (var i = 0; i < rowsData.length; i++) {
            var rowData = rowsData[i];
            var contextArr = [];
            if(HISUIStyleCode == 'lite'){
                contextArr.push('<div style="font-weight:normal">')
            }else{
                contextArr.push('<div style="font-weight:normal;color:#000000">')
            };
            contextArr.push(rowData.date + ' ' + rowData.time + ' ' + rowData.userName);
            contextArr.push('</div>');
            contextArr.push('<div class="pha-vstep-content-more">');
            contextArr.push(rowData.moreInfo);
            contextArr.push('</div>');
            if (rowData.userName != '') {
                curId = curId + 1;
            }
            var item = {};
            item.title = '' + rowData.processDesc + '';
            item.context = contextArr.join('');
            itemsArr.push(item);
        }
        $('.vstep').children().remove();
        $('#' + lineId).vstep({
            showNumber: false,
            stepHeight: 75,
            currentInd: curId,
            items: itemsArr
        });
    },
    /**
     * �ж��Ƿ񼫼�UI��ʽ
     */
    IsLiteCss: (function(){
        return (typeof HISUIStyleCode == 'string' && HISUIStyleCode == 'lite');
    })(),
        /**
     * yangsj 2022-10-19
     * �������,ȫԺ����ѯ����
     *      _opts       ��������
     *      _qOpts
     *                  inci�������ID
     *                  inclb�����ҿ��������ID
     *                  inciDesc : ���������
     *      operType    ���ڿ���
     */
    HospInciStock: function (_opts, _qOpts, operType) {
        if (operType == '' || operType == undefined) {
            operType = 'open';
        } else {
            operType = 'close';
        }
        var inci = _qOpts.inci || "";
        var inclb = _qOpts.inclb || "";
        var inciDesc = _qOpts.inciDesc || "";
        if(inciDesc.length > 12)  inciDesc = inciDesc.slice(0,11)+"..."
        
        var winId = 'PHA_UX_HospInciStock';
        var gridId = winId + '_Grid';
        if (operType == 'close') {
            $('#' + winId).window('close');
            return;
        }
        if ($('#' + winId).css('display') == 'none') {
            return;
        }
        var winDiv = '<div id=' + winId + ' style="padding:10px"><div id=' + gridId + '></div></div>';
        $('body').append(winDiv);
        //������
        var columns = [
            [   
                { field: 'locDesc', title: '����', width: 200, align: 'left'}, 
                { field: 'qty',     title: '���', width: 100, align: 'right'}
            ]
        ];
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'PHA.COM.Query',
                QueryName: 'DrugHospStock', 
                inci: inci,
                inclb: inclb,
                hospId: session['LOGON.HOSPID']
            },
            fit: true,
            fitColumns: true,
            showGroup: true,
            rownumbers: false,
            columns: columns,
            pageSize: 9999,
            pagination: false,
            singleSelect: true,
            nowrap: false,
            toolbar: null,
            border: false,
            gridSave: false
        };
        PHA.Grid(gridId, dataGridOption);

        $('#' + winId).window({
            title: $g('ȫԺ�����Ϣ:') + inciDesc ,
            collapsible: true,
            iconCls: 'icon-w-list',
            border: false,
            resizable: false,
            minimizable: false,
            maximizable: false,
            closed: true,
            modal: false,
            width: 400,
            height: $('body').height() - 40,
            left: $('body').width() - 420,
            toolbar: null,
            onBeforeClose: function () {
                $('#' + winId).remove();
            }
        });
        $('#' + winId).window('setModalable');
        $('#' + winId + " [class='panel datagrid']").css('border', '#E2E2E2 solid 1px');
        $('#' + winId + " [class='panel datagrid']").css('border-radius', '4px');
        $('#' + winId).window('open');
    },
    /**
     * yangsj 2022-11-2
     * �������,���ҿ���ѯѡ�񵯿�
     *      _opts       ��������
     *      _qOpts
     *                  inci�������ID
     *                  proLocId ����������ID
     *                  reqLocId ���������ID
     *      operType    ���ڿ���
     */
    IncilQtySelect: function (_opts, _qOpts, operType, callback) {
        if (operType == '' || operType == undefined) {
            operType = 'open';
        } else {
            operType = 'close';
        }
        var proLocId = _qOpts.proLocId || "";
        var reqLocId = _qOpts.reqLocId || "";
        if(proLocId == "")
        {   
            PHA.Msg('info', '��ѡ�񹩸�����');
            return;
        }
        
        var winId = 'PHA_UX_IncilQtySelect';
        var gridId = winId + '_Grid';
        if (operType == 'close') {
            $('#' + winId).window('close');
            return;
        }
        if ($('#' + winId).css('display') == 'none') {
            return;
        }
        var winDiv = '<div id=' + winId + ' style="padding:10px"><div id=' + gridId + '></div></div>';
        $('body').append(winDiv);
        // ����������
        var barId = winId + '_Bar';
        var qTextName = winId + '_QText';
        var qOnlyReqLocName = winId + '_OnlyReqLoc';
        var barDiv =  '<div id=' + barId + '> '
            + '<table id="qCondition" class="pha-con-table">'
            + ' <tr>'
            + '     <td class="r-label"><label for=' + qTextName + '>' + $g('ģ������') + '</label></td>'
            + '     <td><input id=' + qTextName + ' class="hisui-validatebox Text-width" data-pha=\'class:"hisui-validatebox",clear:true,query:true\'/></td>'
            + '     <td><label for=' + qOnlyReqLocName + '>' + $g('���������') + '</label></td>'
            + '     <td class="r-label"><input id=' + qOnlyReqLocName + ' type="checkbox" class="hisui-checkbox" data-pha=\'class:"hisui-checkbox",clear:true,query:true\'></td>'            
            + ' </tr>'
            + '</table>'
            + '</div>'
        $('body').append(barDiv);
        $.parser.parse('#' + barId);
        
        $("#" + qTextName).on('keyup',function(e){
            if (e.keyCode==13) {
                QueryIncilQtySelect();
            }
        });

        $("#" + qOnlyReqLocName).on('click',function(e){
           QueryIncilQtySelect();
        });
        
        function QueryIncilQtySelect(){
	        var pJson = PHA.DomData('#' + barId, {
                doType: 'query',
                retType: 'Json'
            })[0];
            pJson['qText'] = pJson[qTextName];
            pJson['qOnlyReqLoc'] = pJson[qOnlyReqLocName];
            pJson['proLocId'] = proLocId;
            pJson['reqLocId'] = reqLocId;
            $('#' + gridId).datagrid('query', {
                pJsonStr: JSON.stringify(pJson),
                //rows   : 99999
            });
        }
        
        //������
        var columns = [
            [   
                { field: 'inci', title: 'inci',  hidden: true}, 
                { field: 'operate',     title: '����',            
                    formatter: function(val, rowData, rowIndex){
                    return '<span class="pha-grid-a icon icon-triangle-gray-left" title="ѡ�����">&ensp;</span>';
                }
            }, 
                { field: 'inciCode',    title: 'ҩƷ����',      width: 150,     align: 'left'}, 
                { field: 'inciDesc',    title: 'ҩƷ����',      width: 250,     align: 'left'}, 
                { field: 'proQty',      title: '���������',     width: 100,     align: 'right'},
                { field: 'reqQty',      title: '���󷽿��',     width: 100,     align: 'right'},
                { field: 'pUomId',      title: 'pUomId',        hidden: true    }, 
                { field: 'pUomDesc',    title: '��λ',            width: 100,     align: 'left'}
            ]
        ];
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'PHA.COM.Query',
                QueryName: 'IncilQtySelect', 
                pJsonStr: JSON.stringify({proLocId:proLocId,reqLocId:reqLocId}),
                //page   : 1, 
                //rows   : 99999
            },
            fit: true,
            fitColumns: true,
            showGroup: true,
            rownumbers: false,
            columns: columns,
            
            pagination: true,
            singleSelect: true,
            nowrap: false,
            toolbar: '#' + barId,
            border: false,
            gridSave: false,
            
        };
        PHA.Grid(gridId, dataGridOption);
        //$('#'+ gridId).datagrid('enableFilterAll');
        
        var eventClassArr = ['pha-grid-a icon icon-triangle-gray-left'];
        PHA.GridEvent(gridId, 'click', eventClassArr, function(rowIndex, rowData, className){
            if (callback){
                callback(rowIndex, rowData, className);
            }
        })

        $('#' + winId).window({
            title: $g('����ҩƷѡ��'),
            collapsible: true,
            iconCls: 'icon-w-list',
            border: false,
            resizable: false,
            minimizable: false,
            maximizable: false,
            closed: true,
            modal: false,
            width: 580,
            height: $('body').height() - 40,
            left: $('body').width() - 600,
            toolbar: null,
            onBeforeClose: function () {
                $('#' + winId).remove();
            }
        });
        $('#' + winId).window('setModalable');
        $('#' + winId + " [class='panel datagrid']").css('border', '#cccccc solid 1px');
        $('#' + winId + " [class='panel datagrid']").css('border-radius', '4px');
        $('#' + winId).window('open');
    },
     /**
     * yangsj 2023-2-22
     * �������,ҩƷ��ʷ����¼
     *      _opts       ��������
     *      _qOpts
     *                  inci:�����ID
     *                  inciDesc : ���������
     *      operType    ���ڿ���
     */
    InciRecList: function (_opts, _qOpts, operType) {
        if (operType == '' || operType == undefined) {
            operType = 'open';
        } else {
            operType = 'close';
        }
        var inci = _qOpts.inci || "";
        var hospId = _qOpts.hospId || "";
        var inciDesc = _qOpts.inciDesc || "";
        if(inciDesc.length > 12)  inciDesc = inciDesc.slice(0,11)+"..."
        
        var winId = 'PHA_UX_InciRecList';
        var gridId = winId + '_Grid';
        if (operType == 'close') {
            $('#' + winId).window('close');
            return;
        }
        if ($('#' + winId).css('display') == 'none') {
            return;
        }
        var winDiv = '<div id=' + winId + ' style="padding:10px"><div id=' + gridId + '></div></div>';
        $('body').append(winDiv);
        //������
        var columns = [
            [   
                { field: 'createDate',  title: '����',        width: 120, align: 'left'}, 
                { field: 'rp',          title: '����',        width: 100, align: 'right'},
                { field: 'batNo',       title: '����',        width: 100, align: 'left'}, 
                { field: 'expDate',     title: 'Ч��',        width: 120, align: 'left'}, 
                { field: 'VendorName',  title: '��Ӫ��ҵ',  width: 200, align: 'left'}, 
                { field: 'manfName',    title: '������ҵ',  width: 200, align: 'left'}, 
            ]
        ];
        var dataGridOption = {
            url: $URL,
            queryParams: {
                ClassName: 'PHA.COM.Query',
                QueryName: 'InciRecList', 
                inci: inci,
                hospId: session['LOGON.HOSPID']
            },
            fit: true,
            fitColumns: true,
            showGroup: true,
            rownumbers: false,
            columns: columns,
            pageSize: 9999,
            pagination: false,
            singleSelect: true,
            nowrap: false,
            toolbar: null,
            border: false,
            gridSave: false
        };
        PHA.Grid(gridId, dataGridOption);

        $('#' + winId).window({
            title: $g('����¼:') + inciDesc ,
            collapsible: true,
            iconCls: 'icon-w-list',
            border: false,
            resizable: false,
            minimizable: false,
            maximizable: false,
            closed: true,
            modal: false,
            width: 750,
            height: $('body').height() - 40,
            left: $('body').width() - 750,
            toolbar: null,
            onBeforeClose: function () {
                $('#' + winId).remove();
            }
        });
        $('#' + winId).window('setModalable');
        $('#' + winId + " [class='panel datagrid']").css('border', '#cccccc solid 1px');
        $('#' + winId + " [class='panel datagrid']").css('border-radius', '4px');
        $('#' + winId).window('open');
    }


};

/**
 * HISUI������ݷ���, ��Ҫ���÷���Ľ��������Ӱ�ť, ���������ü���
 * @author yunhaibao
 * @date 2022-11-30
 * @param {*} options.buttonID ��ťID
 * @param {*} options.gridID ���ID
 * @param {*} options.idField ����ID��Ӧ��ǰ̨���Field
 * @param {*} options.sqlTableName ��������������, ��ṹ�Ǽ��еı���
 */
 PHA_UX.Translate = function (options) {
    // if (options.buttonID === undefined) {
    //     var buttonID = options.gridID + '_' + 'translate'
    //     $('#' + options.gridID).datagrid('addToolbar', [
    //         {
    //             text: '����',
    //             iconCls: 'icon-translate-word'
    //         }
    //     ]);
    //     options.buttonID = buttonID
    // }
    // һ��ҳ��ֻ����һ��
    // �����԰��ڴ���
    var layoutType = 'col'; // 'row|col', rowʱ��������
    $('#' + options.buttonID).on('click', function () {
        CreateBaseDom();
        $('#pha_ux_translate_win').data('translate', options);
        // ��̬��
        var gridSelect = $('#' + options.gridID).datagrid('getSelected');
        if (gridSelect === null) {
            $.messager.popover({
                msg: '����ѡ����Ҫ����ļ�¼',
                type: 'info',
                showType: 'slide' //show,fade,slide
            });
            return;
        }
        Rebuild();
        $('#pha_ux_translate_win')
            .window('open')
            // .window('resize', { width: $('#pha_ux_translate_win table').width() + 10 })
            // .window('center');
    });
    function Rebuild() {
        $('#pha_ux_translate_win_lang').combobox({
            url: $URL + '?ClassName=web.DHCBL.CT.SSLanguage&QueryName=GetList&ResultSetType=array',
            valueField: 'CTLANCode',
            textField: 'CTLANDesc',
            editable: false,
            width: 257,
            onLoadSuccess: function () {
                var languagecode = $(this).combobox('getData')[0].CTLANCode;
                $(this).combobox('select', languagecode);
            },
            onSelect: function (data) {
                Load2Table(GetTransData(data.CTLANCode));
            }
        });
    }
    function GetTransData(langCode) {
        var tableData = $.m(
            {
                ClassName: 'web.DHCBL.BDP.BDPTranslation',
                MethodName: 'OpenData',
                TableName: options.sqlTableName,
                Languages: langCode,
                rowid: $('#' + options.gridID).datagrid('getSelected')[options.idField]
            },
            false
        );
        if (tableData == '{}' || tableData == '' || tableData == null || typeof tableData == 'undefined') {
            $('#pha_ux_translate_win').window('close');
            $.messager.popover({
                msg: '��ṹδ�Ǽǻ�û����Ҫ������ֶ�',
                type: 'info',
                showType: 'slide'
            });
            return;
        }
        var jsonData = eval('(' + tableData + ')'); // ���Ƽ�ʹ�ô˷���, ����������ӿ�ֻ������ô��
        if (jsonData.success == 'false' || jsonData.success == false || jsonData.success == 0) {
            $('#pha_ux_translate_win').window('close');
            $.messager.popover({
                msg: (jsonData.msg || jsonData.info || '��ṹδ�Ǽǻ�û����Ҫ������ֶ�'),
                type: 'info',
                showType: 'slide'
            });
            return;
        }
        return jsonData;
    }
    function Load2Table(data) {
        if (!data) {
            return;
        }
        $('#pha_ux_translate_win .data-tr').remove();
        var trHtmlArr = [];
        var rows = data.data;
        for (var i = 0, length = rows.length; i < length; i++) {
            var rowData = rows[i];
            if (layoutType === 'col') {
                trHtmlArr.push('<tr class="data-tr">');
                trHtmlArr.push('    <td class="r-label" style="white-space: nowrap;"><div>' + rowData.TitleDesc + '</div></td>');
                trHtmlArr.push(
                    '    <td class="r-label"><input class="hisui-validatebox data-trans-desc" style="width:250px;" value="' + rowData.BTTransDesc + '" name="' + rowData.BTFieldName + '"/></td>'
                );
                trHtmlArr.push(
                    '    <td class="r-label"><input class="hisui-validatebox data-field-desc" style="width:250px;" readonly value="' +
                        rowData.BTFieldDesc +
                        '" name="' +
                        rowData.BTFieldName +
                        '"/></td>'
                );
                trHtmlArr.push('</tr>');
            }
            if (layoutType === 'row') {
                trHtmlArr.push('<tr class="data-tr">');
                trHtmlArr.push('    <td class="r-label" style="vertical-align: top;line-height: 30px;">' + rowData.TitleDesc + '</td>');
                trHtmlArr.push(
                    '    <td class="r-label">' +
                        '<div><input class="hisui-validatebox data-trans-desc" style="width:400px" value="' +
                        rowData.BTTransDesc +
                        '" name="' +
                        rowData.BTFieldName +
                        '"/></div>' +
                        '<div style="padding-top:10px;"><input class="hisui-validatebox data-field-desc" style="width:400px" readonly value="' +
                        rowData.BTFieldDesc +
                        '" name="' +
                        rowData.BTFieldName +
                        '"/></div>' +
                        '</td>'
                );

                trHtmlArr.push('</tr>');
            }
        }
        $('#pha_ux_translate_win table').append(trHtmlArr.join(''));
        $('#pha_ux_translate_win .hisui-validatebox').validatebox({});
        $('#pha_ux_translate_win').window('resize', { width: $('#pha_ux_translate_win table').width() + 10 })
        .window('center').window('resize');
    }
    /**
     * �����������, һ��ҳ����һ������
     */
    function CreateBaseDom() {
        if ($('#pha_ux_translate_win').length > 0) {
            return;
        }
        var htmlArr = [];
        htmlArr.push('<div id="pha_ux_translate_win">');
        htmlArr.push('  <div style="1000px;">');
        htmlArr.push('      <table class="pha-con-table" >');
        htmlArr.push('          <tr>');
        htmlArr.push('              <td class="r-label" style="white-space: nowrap;">' + $g('��������') + '</td>');
        htmlArr.push('              <td ><input class="hisui-combobox" id="pha_ux_translate_win_lang"/></td>');
        htmlArr.push('              <td class="r-label"></td>');
        htmlArr.push('          </tr>');
        htmlArr.push('      </table>');
        htmlArr.push('  </div>');
        htmlArr.push('</div">');
        $('body').append(htmlArr.join(''));

        $('#pha_ux_translate_win').dialog({
            iconCls: 'icon-w-switch',
            resizable: true,
            title: '����',
            width: 'auto',
            modal: true,
            closed: true,
            buttons: [
                {
                    text: '����',
                    handler: function () {
                        var langOptions = $('#pha_ux_translate_win').data('translate');
                        var langCode = $('#pha_ux_translate_win_lang').combobox('getValue') || '';
                        if (langCode === '') {
                            $.messager.popover({
                                msg: '����ѡ��������',
                                type: 'info',
                                showType: 'slide'
                            });
                            return;
                        }
                        var data4save = [];
                        $('#pha_ux_translate_win table tr').each(function (index, ele) {
                            var fieldName = $(ele).find('.data-field-desc').attr('name') || '';
                            if (fieldName !== '') {
                                var fieldDesc = $(ele).find('.data-field-desc').val();
                                var transDesc = $(ele).find('.data-trans-desc').val();
                                data4save.push(fieldName + '^' + transDesc);
                            }
                        });
                        if (data4save.length === 0) {
                            $.messager.popover({
                                msg: 'û����Ҫ���������',
                                type: 'info',
                                showType: 'slide'
                            });
                            return;
                        }
                        var retData = $.m(
                            {
                                ClassName: 'web.DHCBL.BDP.BDPTranslation',
                                MethodName: 'SaveData',
                                TableName: langOptions.sqlTableName,
                                Languages: langCode,
                                rowid: $('#' + langOptions.gridID).datagrid('getSelected')[langOptions.idField],
                                args: data4save.join('&#')
                            },
                            false
                        );
                        var data = eval('(' + retData + ')'); // ���Ƽ�ʹ�ô˷���, ����������ӿ�ֻ������ô��
                        if (data.success == 'true') {
                            $.messager.popover({ msg: '����ɹ�', type: 'success' });
                            $('#pha_ux_translate_win').window('close');
                        } else {
                            var errorMsg = '����ʧ��';
                            if (data.errorinfo) {
                                errorMsg = errorMsg + '</br>������Ϣ:' + data.errorinfo;
                            }
                            $.messager.alert('��ʾ', errorMsg, 'error');
                        }
                    }
                },
                {
                    text: '�ر�',
                    handler: function () {
                        $('#pha_ux_translate_win').window('close');
                    }
                }
            ]
        });
    }
};

/**
 * ����ƽ̨ - ҽ���ջ�״̬��ʾ
 * @author yunhaibao
 * @date 2022-12-05
 * @param {*} orderKey ҽ��ID || ִ�м�¼ID
 * @todo orderKey �����ִ�м�¼Ҳ�ȴ�ִ�м�¼, Ŀǰƽֻ̨�ܰ�ҽ����, Ϊ��������仯, ִ�м�¼Ҳ�ȴ�ִ�м�¼ID
 */
 PHA_UX.OrderView = function (orderKey, options) {
    var dataArr = orderKey.split('||');
    var tmpUrl = 'dhc.orderview.csp?hideSensitiveInfo=1';
    if (dataArr.length > 2){
        tmpUrl += '&ordViewType=DRUGEXEC&&ordViewBizId=' + orderKey;
        websys_showModal({
            url: tmpUrl,
            title: $g('ҽ���鿴'),
            width: screen.availWidth - 40,
            height: 265
        });
    }else{
        tmpUrl += '&ord=' + dataArr[0] + '||' + dataArr[1];
        websys_showModal({
            url: tmpUrl,
            title: $g('ҽ���鿴'),
            width: screen.availWidth - 200,
            height: screen.availHeight - 200
        });
    }

    return;
    // ���û������, ��Ŀ��������
    PHA_UX.TimeLine(
        {
            modal: true,
            top: null,
            modalable: true
        },
        { oeore: orderKey }
    );
};
/**
 * ����ƽ̨ - ҽ����ϸ��Ϣ
 * @author yunhaibao
 * @date 2022-12-05
 * @param {*} oeori ҽ��ID
 */
PHA_UX.OrderDetailInfoShow = function (oeori, options) {
    websys_showModal({
        url: 'dhc.orderdetailview.csp?ord=' + oeori,
        title: $g('ҽ����ϸ'),
        width: 400,
        height: screen.availHeight - 200,
        iconCls: 'icon-w-list'
    });
};

/**
 * ����ƽ̨ - �������
 * @author yunhaibao
 * @date 2022-12-05
 * @param {*} adm ����ID
 */
PHA_UX.EMRView = function (adm, options) {
    var chartBookID = tkMakeServerCall('PHA.COM.Method', 'GetChartBookID');
    websys_showModal({
        url: 'websys.chartbook.hisui.csp?FixedEpisodeID=' + adm + '&ChartBookID=' + chartBookID,
        title: $g('�������'),
        width: screen.availWidth - 200,
        height: screen.availHeight - 200,
        iconCls: 'icon-w-list'
    });
};