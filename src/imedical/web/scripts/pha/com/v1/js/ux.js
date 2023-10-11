/**
 * 名称:   药房公共窗体
 * 编写人:  yunhaibao
 * 编写日期: 2019-05-06
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
                        title: '药学分类',
                        width: 300
                    }, {
                        field: 'phcCatDescAll',
                        title: '药学分类全称',
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
                rownumbers: false, // 行号
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
            title: '药学分类',
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
        .attr('placeholder', $g("请输入别名回车查询")+'...');
        $('#' + _tgId)
        .prev()
        .find('.datagrid-header')
        .css('border', 0);
    },
    /**
     * 通用最大码窗体
     * @param {Object}  _opts
     *                      tblName 表名
     *                      codeName 计算码值字段名
     *                      title 窗体名称
     * @param {Function} _callBack 回调函数
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
        _winDiv += '            <div>' + $g('建议同类代码长度一致, 如XY000001、XY000002') + '</div>'
        _winDiv += '            <div>' + $g('首次产生新的代码, 直接在最大码文本框中录入即可') + '</div>'
        _winDiv += '            <div>' + $g('录入前缀码后，回车即可生成最大码') + '</div>'
        _winDiv += '        </div>';
        _winDiv += '    </div>';
        _winDiv += '</div>';
//        _winDiv += '<div class="pha-row">';
//        _winDiv += '<div class="pha-col">';
//        _winDiv += '<div class="pha-tip-info" style="width:230px">　' + $g('MEDIWAY+5 代表后缀5位数字') + '</div>';
//        _winDiv += '</div>';
//        _winDiv += '</div>';
        _winDiv += '<div class="pha-row">';
        _winDiv += '<div class="pha-col">';
        _winDiv += '<label>' + $g('前缀码') + '</label>';
        _winDiv += '<div class="pha-col">';
        _winDiv += '<input id=' + _preCodeId + ' class="hisui-validatebox" style="width:325px;" placeholder="' + $g('录入后请回车...') + '">';
        _winDiv += '</div>';
        _winDiv += '</div>';
        _winDiv += '</div>';
        _winDiv += '<div class="pha-row">';
        _winDiv += '<div class="pha-col">';
        _winDiv += '<label>' + $g("最大码") + '</label>';
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
                    text: '确定',
                    handler: function () {
                        var maxCode = $('#' + _maxCodeId).val();
                        _callBack(maxCode);
                        $('#' + _winDivId).window('close');
                    }
                }, {
                    text: '取消',
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
                        PHA.Alert('提示', '您录入的前缀需要在系统中存在</br>如果为全新规则,首次请录入', 'warning');
                    }
                    $('#' + _maxCodeId).val(text);
                });
            }
        });
    },
    /**
     * 别名窗体，窗体格式统一，内容不同
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
        _winToolBarDiv += '<a class="hisui-linkbutton" plain="true" iconCls="icon-add" id=' + btnAddId + ' >新增</a>';
        _winToolBarDiv += '<a class="hisui-linkbutton" plain="true" iconCls="icon-save" id=' + btnSaveId + '>保存</a>';
        _winToolBarDiv += '<a class="hisui-linkbutton" plain="true" iconCls="icon-remove" id=' + btnDelId + '>删除</a>';
        _winToolBarDiv += '</div>';
        _winToolBarDiv += '</div>';
        $('body').append(_winDiv);
        $('body').append(_winToolBarDiv);
        $.parser.parse($('#' + _winDivId));
        $.parser.parse($('#' + _winToolBarId));
        var columns = [
            [{
                    field: 'aliasId',
                    title: '别名Id',
                    hidden: true,
                    width: 100
                }, {
                    field: 'aliasText',
                    title: '别名',
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
        // 按钮事件
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
                    msg: '没有需要保存的数据',
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
                PHA.Alert('提示', saveInfo, saveVal);
            } else {
                PHA.Popover({
                    msg: '保存成功',
                    type: 'success',
                    timeout: 1000
                });
                // 别名这种,成功直接刷新
                $_grid.datagrid('reload');
            }
        });
        $('#' + btnDelId).on('click', function () {
            var $_grid = $('#' + _gridId);
            var gridSelect = $_grid.datagrid('getSelected') || '';
            if (gridSelect == '') {
                PHA.Popover({
                    msg: '请先选择需要删除的数据',
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
            $_grid.datagrid('deleteRow', rowIndex);
        });
    },
    /**
     * 读卡或卡类型封装
     * @param {*} _opts
     *                  cardTypeId  卡类型domid
     *                  cardNoId    卡号domid
     *                  patNoId     登记号domid
     *                  readCardId  读卡按钮domid
     * @param {*} _callBackOpts
     *                  两个回调同时传或者不传
     *                  ReadHandler 读卡事件,不写走公用
     *                  AfterHandler读卡写值后事件
     */
    DHCCardTypeDef: function (_opts, _callBackOpts) {
        _callBackOpts = _callBackOpts || {};
        if (typeof _opts == 'object') {
            // 初始化
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
        // 读卡
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
                    $.messager.alert('提示', '卡无效', 'info', function () {
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
        // 卡号补零
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
     * 就诊信息窗体
     * @param {object} _opts 窗体大小参数
     * @param {*} _qOpts     query入参(AdmId,Ooeri)
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
        //定义表格
        var columns = [
            [{
                    field: 'group',
                    hidden: true
                }, {
                    field: 'field1',
                    title: '属性',
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
                    title: '值',
                    width: 300,
                    styler: function (value, row, index) {
                        if (row.field1 ==  $g('特殊人群')) {
                            if (value != '') {
                                return 'background:#d472ae;color:#fff;';
                            }
                        }
                    }
                }, {
                    field: 'field2',
                    title: '属性',
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
                    title: '值',
                    width: 300,
                    styler: function (value, row, index) {
                        if (row.field2 == $g('患者状态')) {
                            if ([ $g('病重'),  $g('病危')].indexOf(value) >= 0) {
                                return 'background:#ee4f38;color:#fff;';
                            }
                        } else if (row.field2 ==  $g('出院时间')) {
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
                    // 合并列
                    for (var i = 0; i < rowsData.length; i++) {
                        var rowData = rowsData[i];
                        if (rowData.field1 ==  $g('诊断') || rowData.field1 ==  $g('特殊人群')) {
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
            title: ' 患者就诊信息',
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
     * 显示信息信息的公共窗体
     * huxiaotian 2020-08-21
     * @param {string} _options.id 窗体ID
     * @param {string} _options.title 窗体标题
     * @param {string} _options.width 窗体宽度
     * @param {string} _options.height 窗体高度
     * @param {string} _options.labelWidth 标签宽度
     * @param {string} _options.data 显示的数据,格式：[{title:'',code:'',data:[{labelText:'',content:''},{},...]}, {title:'',code:'',data:[]}]
     * @param {object} _options.queryParams 查询数据的类方法,类方法应该返回与data格式相似的数据
     * @return
     */
    DetailWin: function (_options) {
        var winId = _options.id || 'PHA_WIN_INFO';
        var contentId = winId + '_Detail';
        var $win = $('#' + winId);
        if ($win.length == 0) {
            $('<div id="' + winId + '"></div>').appendTo('body');
            var winDefaultOpts = {
                title: '详细信息',
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
                        text: '关闭',
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
        // 样式修改
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
        // 添加内容
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
                alert('请在console控制台查看错误信息');
            }
        });
        /*
         * @定义一个内部方法
         */
        function AddCard(dialogBody, _cardOptions) {
            // 卡片初始化
            var _cardId = _cardOptions.id || _cardOptions.code || '';
            if (_cardId == '') {
                alert('card未指定id属性');
                return;
            }
            var _containerId = _cardId + '-' + 'container';
            var _title = _cardOptions.title || '卡片' + _cardId;
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
            // 添加卡片内容
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
                title: ' 医嘱时间轴',
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
                title: '业务状态时间轴',
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
     * 医嘱信息窗体
     * @param {object} _opts  窗体大小参数
     * @param {*} _qOpts  query入参(Oeori,Oeore,DspId)
     */
    OrderDetail: function (_opts, _qOpts) {
        var winId = 'PHA_UX_OrderDetail';
        var gridId = winId + '_Grid';
        var winDiv = '<div id=' + winId + ' style="padding:10px;overflow:hidden;"><div id=' + gridId + '></div></div>';
        $('body').append(winDiv);
        //定义表格
        var columns = [
            [{
                    field: 'group',
                    hidden: true
                }, {
                    field: 'field1',
                    title: '属性',
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
                    title: '值',
                    width: 300
                }, {
                    field: 'field2',
                    title: '属性',
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
                    title: '值',
                    width: 300,
                    styler: function (value, row, index) {
                        if (row.field2 == '医嘱状态') {
                            if (['停止', '作废'].indexOf(value) >= 0) {
                                return 'background:#ffe3e3';
                            }
                        } else if (row.field2 == '皮试结果') {
                            if (['未做', '阳性'].indexOf(value) >= 0) {
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
                // 这比较尴尬啊
                setTimeout(function () {
                    // $('#' + winId + " .datagrid-header").css("display", "none");
                }, 10);
            },
            gridSave: false
        };
        PHA.Grid(gridId, dataGridOption);
        $('#' + winId).window({
            title: ' 医嘱信息',
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
     * 药品信息窗体
     * @param {object} _opts : 窗体大小参数
     * @param {*} _qOpts : query入参(inci,arcim,phcdf)
     * PHA_UX.DrugDetail();
     */
    DrugDetail: function (_opts, _qOpts) {
        var winId = 'PHA_UX_DrugDetail';
        var gridId = winId + '_Grid';
        var winDiv = '<div id=' + winId + ' style="padding:10px;overflow:hidden;"><div id=' + gridId + '></div></div>';
        $('body').append(winDiv);
        //定义表格
        var columns = [
            [{
                    field: 'group',
                    hidden: true
                }, {
                    field: 'field1',
                    title: '属性',
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
                    title: '值',
                    width: 300
                }, {
                    field: 'field2',
                    title: '属性',
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
                    title: '值',
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
                        if (rowData.field1 == $g('药学分类')) {
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
            title: ' 药品详细信息',
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
     * 常用表单组件公共 - 药品信息表格列信息
     * PHA_UX.DrugColumns
     */
    DrugColumns: [
        [{
                title: "inci",
                field: "inci",
                width: 100,
                hidden: true
            }, {
                title: "药品代码",
                field: "inciCode",
                width: 160,
            }, {
                title: "药品名称",
                field: "inciDesc",
                width: 200
            }, {
                title: "药品规格",
                field: "inciSpec",
                width: 100
            }, {
                title: "pUomId",
                field: "pUomId",
                width: 100,
                hidden: true
            }, {
                title: "入库单位",
                field: "pUomDesc",
                width: 80,
                align: 'center'
            }, {
                title: "库存(入库)",
                field: "pQty",
                width: 90,
                align: 'right'
            }, {
                title: "进价(入库)",
                field: "pRp",
                width: 90,
                align: 'right'
            }, {
                title: "售价(入库)",
                field: "pSp",
                width: 90,
                align: 'right'
            }, {
                title: "bUomId",
                field: "bUomId",
                width: 100,
                hidden: true
            }, {
                title: "基本单位",
                field: "bUomDesc",
                width: 80,
                align: 'center'
            }, {
                title: "库存(基本)",
                field: "bQty",
                width: 90,
                align: 'right'
            }, {
                title: "进价(基本)",
                field: "bRp",
                width: 90,
                align: 'right'
            }, {
                title: "售价(基本)",
                field: "bSp",
                width: 90,
                align: 'right'
            }, {
                title: "生产企业",
                field: "manfName",
                width: 160
            }, {
                title: "货位",
                field: "stkBin",
                width: 100
            }, {
                title: "剂型",
                field: "phcFormDesc",
                width: 100
            }, {
                title: "商品名",
                field: "goodName",
                width: 130
            }, {
                title: "处方通用名",
                field: "geneName",
                width: 130
            }, {
                title: "pFac",
                field: "pFac",
                width: 100,
                hidden: true
            }, {
                title: "不可用",
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
                title: "贵重药",
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
                title: "请求科室库存",
                field: "reqLocQty",
                width: 100
            }, {
                title: "国家医保编码",
                field: "insuCode",
                width: 100
            }, {
                title: "国家医保名称",
                field: "insuName",
                width: 100
            }, {
                title: "国家医保名称",
                field: "insuDesc",
                width: 100,
                hidden: true
            }
        ]
    ],
    /**
     * 常用表单组件公共 - 药品批次信息表格列信息
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
                title: "批号",
                field: "batNo",
                width: 110,
            }, {
                title: "效期",
                field: "expDate",
                width: 100
            }, {
                title: "生产企业",
                field: "manfName",
                width: 180
            }, {
                title: "经营企业",
                field: "vendorName",
                width: 180
            }, {
                title: "数量",
                field: "inputQty",
                width: 70,
                hidden: true
            }, {
                title: "调后数量",   
                field: "resultQty",
                width: 70,
                hidden: true
            }, {
                title: "入库单位",
                field: "pUomDesc",
                width: 70,
                align: 'center'
            }, {
                title: "库存(入库)",
                field: "inclbQty",
                width: 100,
                align: 'right'
            }, {
                title: "售价(入库)",
                field: "pSp",
                width: 90,
                align: 'right'
            }, {
                title: "进价(入库)",
                field: "pRp",
                width: 90,
                align: 'right'
            }, /*{
                title: "批价(入库)",
                field: "pPp",
                width: 90,
                align: 'right'
            }, */{
                title: "供给方库存",
                field: "supplyStockQty",
                width: 90,
                align: 'right'
            }, {
                title: "请求方库存",
                field: "reqStockQty",
                width: 90,
                align: 'right'
            }, {
                title: "货位",
                field: "stkBin",
                width: 100
            }, {
                title: "最近入库",
                field: "ingrDate",
                width: 100,
                align: 'center'
            }, {
                title: "pFac",
                field: "pFac",
                width: 100,
                hidden: true
            }, {
                title: "占用库存",
                field: "dirtyQty",
                width: 90,
                align: 'right'
            }, {
                title: "可用库存",
                field: "avaQty",
                width: 90,
                align: 'right'
            }, {
                title: "贵重药",
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
                title: "预警标志",
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
                        return '<label >' + $g('药品批次过期')  + '</label>';
                    }
                    if (value == '2') {
                        return '<label >' + $g('药品批次不可用')  + '</label>';
                    }
                    return value;
                }
            }
        ]
    ],
    /*
     * 常用表单组件公共 - 动态获取参数
     */
    Get: function (domId, defVal) {
        return {
            _type: 'domId',
            domId: domId,
            defVal: (typeof defVal == 'undefined' ? '' : defVal)
        };
    },
    /*
     * 常用表单组件公共 - 设置默认值
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
            onSelect && onSelect.call(t, data[0]); // 更多级的联动
            return;
        }
        for (var i = 0; i < data.length; i++) {
            var iData = data[i];
            if (iData[findField] == findValue) {
                $(t).combobox('setValue', iData[valueField]);
                cmbOpts.hasDefVal = true;
                var onSelect = $(t).combobox('options').onSelect;
                onSelect && onSelect.call(t, iData); // 更多级的联动
                break;
            }
        }
    },
    /*
     * 常用表单组件公共 - 参数合并
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
     * 常用表单组件公共 - 解析参数
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
        // 关联的联动ID
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
     * 常用表单组件公共 - 根据domId获取参数值
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
     * 常用表单组件公共 - 联动刷新 (刷新下一级)
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
                        $_dom.combogrid('clear'); // 也会调后台 TODO...
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
     * 常用表单组件公共 - 下拉树加载
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
     * 表单相关常用组件 - 下拉框
     * Huxt 2022-03-19
     */
    ComboBox: {
        // 科室: PHA_UX.ComboBox.Loc(id);
        Loc: function (_id, _opts) {
            // 参数
            _opts = _opts || {};
            _opts.qParams = PHA_UX._ExtendParam({}, _opts.qParams);
            _opts.defValue = (typeof _opts.defValue == 'undefined') ? session['LOGON.CTLOCID'] : _opts.defValue;
            _opts.relType = _opts.qParams.relType;
            // 简单的
            if (_opts.simple) {
                var _defOpts = {
                    placeholder: '科室...',
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
            // 复杂的
            var _defOpts = {
                placeholder: '科室...',
                url: '',
                mode: 'remote',
                onBeforeLoad: function (param) {
                    param.QText = param.q || '';
                    param.hospId = session['LOGON.HOSPID'];
                    var cOpts = $(this).combobox('options');
                    var _relType = cOpts.relType;
                    if (_relType == 'T' || _relType == 'R') {
                        // 根据供给科室获取请领科室
                        cOpts.url = PHA_STORE.RelLocByPro().url;
                    } else if (_relType == 'TR' || _relType == 'RF') {
                        // 根据请领科室获取供给科室
                        cOpts.qParams.relType = (_relType == 'TR') ? '' : 'R';
                        cOpts.url = PHA_STORE.RelLocByRec().url;
                    } else {
                        // 安全组库存授权的科室
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
        // 类组: PHA_UX.ComboBox.StkCatGrp(id);
        StkCatGrp: function (_id, _opts) {
            // 参数
            _opts = _opts || {};
            _opts.qParams = PHA_UX._ExtendParam({}, _opts.qParams);
            // 简单的
            if (_opts.simple) {
                var _defOpts = {
                    placeholder: '类组...',
                    mode: 'remote',
                    url: PHA_STORE.DHCStkCatGroup().url
                }
                PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
                return;
            }
            // 复杂的
            var _defOpts = {
                placeholder: '类组...',
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
                    setTimeout(function(){PHA_UX._RelaRefresh(_id);}, 500);   // 延迟执行，防止联动组件初始化事件和联动事件打架
                }
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // 库存分类: PHA_UX.ComboBox.StkCat(id);
        StkCat: function (_id, _opts) {
            var _defOpts = {
                placeholder: '库存分类...',
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
        // 经营企业: PHA_UX.ComboBox.Vendor(id);
        Vendor: function (_id, _opts) {
            var _defOpts = {
                placeholder: '经营企业...',
                mode: 'remote',
                url: PHA_STORE.APCVendor().url
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // 生产企业: PHA_UX.ComboBox.Manf(id);
        Manf: function (_id, _opts) {
            var _defOpts = {
                placeholder: '生产企业...',
                mode: 'remote',
                url: PHA_STORE.PHManufacturer().url
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // 单位: PHA_UX.ComboBox.Uom(id);
        Uom: function (_id, _opts) {
            var _defOpts = {
                placeholder: '单位...',
                mode: 'remote',
                url: PHA_STORE.CTUOM().url
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // 管制分类: PHA_UX.ComboBox.Poison(id);
        Poison: function (_id, _opts) {
            var _defOpts = {
                placeholder: '管制分类...',
                mode: 'remote',
                url: PHA_STORE.PHCPoison().url
            }
            PHA.ComboBox(_id, $.extend({}, _defOpts, _opts));
        },
        // 库存项: PHA_UX.ComboBox.INCItm(id);
        INCItm: function (_id, _opts) {
            var _defOpts = PHA_STORE.INCItm('Y');
            _defOpts.valueField = _defOpts.idField;
            _defOpts.placeholder = '药品...';
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
        // 科室货位下拉框: PHA_UX.ComboBox.StkBinComb(id);
        StkBinComb: function (_id, _opts) {
            var _defOpts = {
                placeholder: '货位码...',
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
        // 科室货位(货架)下拉框: PHA_UX.ComboBox.StkBinRacks(id);
        StkBinRacks: function (_id, _opts) {
            var _defOpts = {
                placeholder: '货架码...',
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
        // 科室盘点组: PHA_UX.ComboBox.StkTkGrp(id);
        StkTkGrp: function (_id, _opts) {
            var _defOpts = {
                placeholder: '盘点组...',
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
     * 表单相关常用组件 - 下拉数
     * yangsj 2022-07-25
     */
    ComboTree: {
        stkBin: function (_id, _opts) {
            _opts = _opts || {};
            _opts.placeholder = $g(_opts.placeholder);
            var _defOpts = {
                url: PHA_IN_STORE.StkBinTree().url,
                placeholder: '货位...',
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
     * 表单相关常用组件 - 下拉表格
     * Huxt 2022-03-19
     */
    ComboGrid: {
        // 库存项下拉表格: PHA_UX.ComboGrid.INCItm(id);
        INCItm: function (_id, _opts) {
            // 参数
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
            // 简单的
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
            // 复杂的
            /* 删除不用列 */
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
        // 库存批次下拉表格: PHA_UX.ComboGrid.INCItmBat(id);
        INCItmBat: function (_id, _opts) {
            // 参数
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
            // 默认配置
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
     * 表格编辑相关常用组件
     * Huxt 2022-03-19
     */
    Grid: {
        // 药品下拉表格
        INCItm: function (iOpts) {
            /* 过滤类型 */
            var cmbOpData = [];
            var gOperators = $.fn.datagrid.defaults.operators;
            if (!gOperators) {
                gOperators = {
                    nofilter: {
                        text: $g('无')
                    },
                    contains: {
                        text: $g('包含')
                    },
                    equal: {
                        text: $g('等于')
                    },
                    notequal: {
                        text: $g('不等于')
                    },
                    beginwith: {
                        text: $g('前匹配')
                    },
                    endwith: {
                        text: $g('后匹配')
                    },
                    less: {
                        text: $g('小于')
                    },
                    lessorequal: {
                        text: $g('小于等于')
                    },
                    greater: {
                        text: $g('大于')
                    },
                    greaterorequal: {
                        text: $g('大于等于')
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
            /* 过滤字段 */
            var cmbFieldData = [{
                    RowId: 'any',
                    Description: '任意列'
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
            /* 下拉表格配置 */
            var _view = (typeof scrollview == 'undefined' ? undefined : scrollview);
            /* 删除不用列 */
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
                regTxt: '不能为空!',
                panelWidth: 800,
                panelHeight: 280,
                pageSize: 50,
                view: _view,
                rownumbers: true,
                novalidate: true, // for lookup
                clickDelay: 0, // lookup没有用
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
                        placeholder: '过滤字段...'
                    }, {
                        type: 'combobox',
                        name: 'op',
                        data: cmbOpData,
                        value: 'contains',
                        placeholder: '过滤操作...'
                    }, {
                        type: 'searchbox',
                        name: 'value',
                        placeholder: '输入过滤内容...',
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
        // 药品弹窗
        INCItmWin: function (iOpts) {
            iOpts = iOpts || {};
            var _defOpts = {
                winOptions: {
                    win: {
                        id: 'Drug_Detail_Win',
                        title: '请选择药品'
                    },
                    grid: {
                        center: {
                            title: '药品信息 - 双击行或按回车键返回',
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
        // 药品批次弹窗
        INCItmBatWin: function (iOpts, otherIOpts) {
            iOpts = iOpts || {};
            otherIOpts = otherIOpts || {};
            //var inputField = 'inputQty';   
            var inputFieldArr = ['inputQty'];
            var batTitle = "药品批次信息 - 录入数量后，双击行或按回车键返回"
            if(otherIOpts.inputType == "ADJ") {
                inputFieldArr.push('resultQty');  //如果是库存调整使用。则新增调后数量编辑列
                batTitle = "药品批次信息 - 录入数量/调后数量后，双击行或按回车键返回"
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
                        title: '请选择药品批次'
                    },
                    grid: {
                        north: {
                            title: '药品信息',
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
                                    {id:'0', text:'仅可用', selected: true},
                                    {id:'1', text:'仅有库存' , selected: true}
                                ]
                            }
                        }
                    }
                }
            }
            return PHA_GridEditor.Window($.extend({}, _defOpts, iOpts), 'icon-card');
        },
        // 单位
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
        // 药品入库弹窗
        INCItmRecWin: function (iOpts, gridOptions) {
            iOpts = iOpts || {};
            var _defOpts = {
                winOptions: {
                    win: {
                        id: 'DrugBatRec_Detail_Win',
                        title: '请选择药品入库记录'
                    },
                    grid: {
                        north: {
                            title: '药品信息',
                            height: 280,
                            rownumbers: true,
                            queryParams: {
                                ClassName: 'PHA.STORE.Drug',
                                QueryName: 'DrugDetail'
                            },
                            columns: PHA_UX.DrugColumns
                        },
                        center: {
                            title: '药品批次信息 - 录入数量后双击行或按回车键返回',
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
                                        title: '提醒',
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
                                        title: "入库日期",
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
                                        title: "批号",
                                        field: "batNo",
                                        width: 110,
                                    }, {
                                        title: "效期",
                                        field: "expDate",
                                        width: 100
                                    }, {
                                        title: "数量",
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
                                        title: "可用库存",
                                        field: "inclbAvaQty",
                                        width: 100,
                                        align: 'right',
                                        styler: function () {
                                            return 'font-weight:bold;'
                                        }
                                    }, {
                                        title: "入库时数量",
                                        field: "recQty",
                                        width: 80,
                                        align: 'right'
                                    }, {
                                        title: "入库时单位",
                                        field: "recUomDesc",
                                        width: 80,
                                        align: 'left'
                                    }, {
                                        title: "生产企业",
                                        field: "manfDesc",
                                        width: 180
                                    }, {
                                        title: "入库售价",
                                        field: "sp",
                                        width: 90,
                                        align: 'right' //,
                                        // formatter:function(value, rowData){
                                        //     return value + '/' + rowData.recUomDesc
                                        // }
                                    }, {
                                        title: "入库进价",
                                        field: "rp",
                                        width: 90,
                                        align: 'right'
                                    },{
                                        title: "当前售价",
                                        field: "curSp",
                                        width: 90,
                                        align: 'right',
                                        styler: function(value, row, index){
											var sp = row.sp;
											if(sp != value) return 'background:#f1c516;color:white;';
										}
                                    }, {
                                        title: "当前进价",
                                        field: "curRp",
                                        width: 90,
                                        align: 'right',
                                        styler: function(value, row, index){
											var rp = row.rp;
											if(rp != value) return 'background:#f1c516;color:white;';
										}
                                    },{
                                        title: "贵重药",
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
            // 关闭事件的处理
            return PHA_GridEditor.Window($.extend({}, _defOpts, iOpts), 'icon-w-other');
        }
    },
    /**
     * 公共组件 常用工具方法(可直接调用)
     * Huxt 2022-04-04
     */
    Util: {
        // 动态获取小数位数
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
        // 获取药品对应单位的数据 (切换单位事件调用)
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
     * 公共组件,业务流程时间轴
     *      _opts       窗口属性
     *      _qOpts
     *                  busiCode：业务代码
     *                  locId：科室id,
     *                  pointer：业务id
     *      operType    窗口开关
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
                title: $g('业务操作时间轴') + no,
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
     * 判断是否极简UI样式
     */
    IsLiteCss: (function(){
        return (typeof HISUIStyleCode == 'string' && HISUIStyleCode == 'lite');
    })(),
        /**
     * yangsj 2022-10-19
     * 公共组件,全院库存查询弹框
     *      _opts       窗口属性
     *      _qOpts
     *                  inci：库存项ID
     *                  inclb：科室库存批次项ID
     *                  inciDesc : 库存项名称
     *      operType    窗口开关
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
        //定义表格
        var columns = [
            [   
                { field: 'locDesc', title: '科室', width: 200, align: 'left'}, 
                { field: 'qty',     title: '库存', width: 100, align: 'right'}
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
            title: $g('全院库存信息:') + inciDesc ,
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
     * 公共组件,科室库存查询选择弹框
     *      _opts       窗口属性
     *      _qOpts
     *                  inci：库存项ID
     *                  proLocId ：供给科室ID
     *                  reqLocId ：请求科室ID
     *      operType    窗口开关
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
            PHA.Msg('info', '请选择供给科室');
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
        // 新增检索框
        var barId = winId + '_Bar';
        var qTextName = winId + '_QText';
        var qOnlyReqLocName = winId + '_OnlyReqLoc';
        var barDiv =  '<div id=' + barId + '> '
            + '<table id="qCondition" class="pha-con-table">'
            + ' <tr>'
            + '     <td class="r-label"><label for=' + qTextName + '>' + $g('模糊检索') + '</label></td>'
            + '     <td><input id=' + qTextName + ' class="hisui-validatebox Text-width" data-pha=\'class:"hisui-validatebox",clear:true,query:true\'/></td>'
            + '     <td><label for=' + qOnlyReqLocName + '>' + $g('仅请求科室') + '</label></td>'
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
        
        //定义表格
        var columns = [
            [   
                { field: 'inci', title: 'inci',  hidden: true}, 
                { field: 'operate',     title: '操作',            
                    formatter: function(val, rowData, rowIndex){
                    return '<span class="pha-grid-a icon icon-triangle-gray-left" title="选择填充">&ensp;</span>';
                }
            }, 
                { field: 'inciCode',    title: '药品代码',      width: 150,     align: 'left'}, 
                { field: 'inciDesc',    title: '药品名称',      width: 250,     align: 'left'}, 
                { field: 'proQty',      title: '供给方库存',     width: 100,     align: 'right'},
                { field: 'reqQty',      title: '请求方库存',     width: 100,     align: 'right'},
                { field: 'pUomId',      title: 'pUomId',        hidden: true    }, 
                { field: 'pUomDesc',    title: '单位',            width: 100,     align: 'left'}
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
            title: $g('科室药品选择'),
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
     * 公共组件,药品历史入库记录
     *      _opts       窗口属性
     *      _qOpts
     *                  inci:库存项ID
     *                  inciDesc : 库存项名称
     *      operType    窗口开关
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
        //定义表格
        var columns = [
            [   
                { field: 'createDate',  title: '日期',        width: 120, align: 'left'}, 
                { field: 'rp',          title: '进价',        width: 100, align: 'right'},
                { field: 'batNo',       title: '批号',        width: 100, align: 'left'}, 
                { field: 'expDate',     title: '效期',        width: 120, align: 'left'}, 
                { field: 'VendorName',  title: '经营企业',  width: 200, align: 'left'}, 
                { field: 'manfName',    title: '生产企业',  width: 200, align: 'left'}, 
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
            title: $g('入库记录:') + inciDesc ,
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
 * HISUI表格数据翻译, 需要调用翻译的界面内增加按钮, 按参数调用即可
 * @author yunhaibao
 * @date 2022-11-30
 * @param {*} options.buttonID 按钮ID
 * @param {*} options.gridID 表格ID
 * @param {*} options.idField 数据ID对应的前台表格Field
 * @param {*} options.sqlTableName 表名还是类名好, 表结构登记中的表名
 */
 PHA_UX.Translate = function (options) {
    // if (options.buttonID === undefined) {
    //     var buttonID = options.gridID + '_' + 'translate'
    //     $('#' + options.gridID).datagrid('addToolbar', [
    //         {
    //             text: '翻译',
    //             iconCls: 'icon-translate-word'
    //         }
    //     ]);
    //     options.buttonID = buttonID
    // }
    // 一个页面只保留一个
    // 将属性绑在窗口
    var layoutType = 'col'; // 'row|col', row时按行排列
    $('#' + options.buttonID).on('click', function () {
        CreateBaseDom();
        $('#pha_ux_translate_win').data('translate', options);
        // 动态绑定
        var gridSelect = $('#' + options.gridID).datagrid('getSelected');
        if (gridSelect === null) {
            $.messager.popover({
                msg: '请先选中需要翻译的记录',
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
                msg: '表结构未登记或没有需要翻译的字段',
                type: 'info',
                showType: 'slide'
            });
            return;
        }
        var jsonData = eval('(' + tableData + ')'); // 不推荐使用此方法, 但调用这个接口只能先这么用
        if (jsonData.success == 'false' || jsonData.success == false || jsonData.success == 0) {
            $('#pha_ux_translate_win').window('close');
            $.messager.popover({
                msg: (jsonData.msg || jsonData.info || '表结构未登记或没有需要翻译的字段'),
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
     * 构建基础表格, 一个页面留一个即可
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
        htmlArr.push('              <td class="r-label" style="white-space: nowrap;">' + $g('翻译语言') + '</td>');
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
            title: '翻译',
            width: 'auto',
            modal: true,
            closed: true,
            buttons: [
                {
                    text: '保存',
                    handler: function () {
                        var langOptions = $('#pha_ux_translate_win').data('translate');
                        var langCode = $('#pha_ux_translate_win_lang').combobox('getValue') || '';
                        if (langCode === '') {
                            $.messager.popover({
                                msg: '请先选择翻译语言',
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
                                msg: '没有需要保存的数据',
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
                        var data = eval('(' + retData + ')'); // 不推荐使用此方法, 但调用这个接口只能先这么用
                        if (data.success == 'true') {
                            $.messager.popover({ msg: '保存成功', type: 'success' });
                            $('#pha_ux_translate_win').window('close');
                        } else {
                            var errorMsg = '保存失败';
                            if (data.errorinfo) {
                                errorMsg = errorMsg + '</br>错误信息:' + data.errorinfo;
                            }
                            $.messager.alert('提示', errorMsg, 'error');
                        }
                    }
                },
                {
                    text: '关闭',
                    handler: function () {
                        $('#pha_ux_translate_win').window('close');
                    }
                }
            ]
        });
    }
};

/**
 * 基础平台 - 医嘱闭环状态显示
 * @author yunhaibao
 * @date 2022-12-05
 * @param {*} orderKey 医嘱ID || 执行记录ID
 * @todo orderKey 如果是执行记录也先传执行记录, 目前平台只能按医嘱查, 为方便后续变化, 执行记录也先传执行记录ID
 */
 PHA_UX.OrderView = function (orderKey, options) {
    var dataArr = orderKey.split('||');
    var tmpUrl = 'dhc.orderview.csp?hideSensitiveInfo=1';
    if (dataArr.length > 2){
        tmpUrl += '&ordViewType=DRUGEXEC&&ordViewBizId=' + orderKey;
        websys_showModal({
            url: tmpUrl,
            title: $g('医嘱查看'),
            width: screen.availWidth - 40,
            height: 265
        });
    }else{
        tmpUrl += '&ord=' + dataArr[0] + '||' + dataArr[1];
        websys_showModal({
            url: tmpUrl,
            title: $g('医嘱查看'),
            width: screen.availWidth - 200,
            height: screen.availHeight - 200
        });
    }

    return;
    // 如果没有如上, 项目可用如下
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
 * 基础平台 - 医嘱详细信息
 * @author yunhaibao
 * @date 2022-12-05
 * @param {*} oeori 医嘱ID
 */
PHA_UX.OrderDetailInfoShow = function (oeori, options) {
    websys_showModal({
        url: 'dhc.orderdetailview.csp?ord=' + oeori,
        title: $g('医嘱明细'),
        width: 400,
        height: screen.availHeight - 200,
        iconCls: 'icon-w-list'
    });
};

/**
 * 基础平台 - 病历浏览
 * @author yunhaibao
 * @date 2022-12-05
 * @param {*} adm 就诊ID
 */
PHA_UX.EMRView = function (adm, options) {
    var chartBookID = tkMakeServerCall('PHA.COM.Method', 'GetChartBookID');
    websys_showModal({
        url: 'websys.chartbook.hisui.csp?FixedEpisodeID=' + adm + '&ChartBookID=' + chartBookID,
        title: $g('病历浏览'),
        width: screen.availWidth - 200,
        height: screen.availHeight - 200,
        iconCls: 'icon-w-list'
    });
};