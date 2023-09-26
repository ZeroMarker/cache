/**
 * ����:	 ҩ������-��ʼ����������ַ���
 * ��д��:	 yunhaibao
 * ��д����: 2019-03-12
 * �������: HUI���HUI������HUI����HUI�����HUI�Ŵ󾵡�HUI��Ϣ(msg,alert)
 */
var PHA = {
    /**
     * HUI���
     * @param {string} id ���Id
     * @param {object} opts �������,������Ĭ��
     * @param {object} mOpts �����չ����
     */
    Grid: function (id, opts, mOpts) {
        if (!id) {
            return;
        }
        mOpts = mOpts || {};
        // Ĭ������
        var dOpts = {
            enableDnd: false,
            exportXls: true,
            fit: true,
            border: false,
            singleSelect: true,
            loadMsg: '���ڼ�����Ϣ...',
            pageSize: 30,
            pageList: [30, 50, 100, 300, 500],
            pagination: true,
            pageNumber: 0,
            toolbar: [],
            onDblClickHeader: PHA.onDblClickHeader,
            onHeaderContextMenu: PHA.onHeaderContextMenu,
            onRowContextMenu: PHA.onRowContextMenu,
            onLoadError: function (response) {
                var resText = response.responseText;
                PHA.Alert('��ѯ����', resText, 'error');
            },
            onEndEdit: function (rowIndex, rowData) {
                var editors = $(this).datagrid('getEditors', rowIndex);
                for (var ei = 0; ei < editors.length; ei++) {
                    var iEditor = editors[ei];
                    var iType = iEditor.type;
                    if (iType.indexOf('combo') >= 0) {
                        var descField = $(this).datagrid('getColumnOption', iEditor.field).descField;
                        if (descField) {
                            rowData[descField] = $(iEditor.target).combobox('getText');
                        }
                    }
                }
            }
        };
        var nOpts = $.extend({}, dOpts, opts);
        $HUI.datagrid('#' + id, nOpts);
        if (nOpts.enableDnd == true) {
            setTimeout(function () {
                //$('#' + id).datagrid('enableDnd');
                // �г�ͻ,2019-03-14,yhb
                //$('#' + id).datagrid('columnMoving');
                //$('#' + id).datagrid("enableCellSelecting")
            }, 1000);
        }
    },
    TreeGrid: function (_id, _opts) {
        var _defOpts = {
            url: $URL,
            animate: true,
            border: false,
            fit: true,
            nowrap: true,
            fitColumns: true,
            singleSelect: true
        };
        var _nOpts = $.extend({}, _defOpts, _opts);
        $('#' + _id).treegrid(_nOpts);
    },
    /**
     *
     * @param {String} _id id
     * @param {Object} _opts ��Ӧ����
     */
    Tree: function (_id, _opts) {
        var _defOpts = {
            lines: true,
            autoNodeHeight: true
        };
        var _nOpts = $.extend({}, _defOpts, _opts);
        $('#' + _id).tree(_nOpts);
    },
    TriggerBox: function (_id, _opts) {
        $HUI.triggerbox('#' + _id, _opts);
        $('#' + _id)
            .next()
            .find('.triggerbox-text')
            .on('blur', function () {
                if ($('#' + _id).triggerbox('getValue') == '') {
                    $('#' + _id).triggerbox('setValueId', '');
                }
            });
    },

    CheckBox: function () {},
    Radio: function () {},
    SwitchBox: function (_id, _opts) {
        var _defOpts = {
            onText: '��',
            offText: '��',
            onClass: 'primary',
            offClass: 'gray'
        };
        var _nOpts = $.extend({}, _defOpts, _opts);
        $HUI.switchbox('#' + _id, _nOpts);
    },
    FileBox: function () {},
    SearchBox: function (_id, _opts) {
        $HUI.searchbox('#' + _id, _opts);
        if (_opts.placeholder) {
            $('#' + _id)
                .searchbox('textbox')
                .attr('placeholder', _opts.placeholder);
        }
    },
    /**
     * @param {String} _id idֵ
     * @param {Object} _opts ��������
     * @param {String} _select $(_id��Ϊjqɸѡֱ�Ӽ���),����_id����Ϊ_id
     */
    NumberBox: function (_id, _opts, _select) {
        _select = _select || '';
        if (_select == '$') {
            var $id = _id;
        } else {
            var $id = '#' + _id;
        }
        var _defOpts = {};
        var _nOpts = $.extend({}, _defOpts, _opts);
        $HUI.numberbox($id, _nOpts);
    },
    ValidateBox: function (_id, _opts, _select) {
        _select = _select || '';
        if (_select == '$') {
            var $id = _id;
        } else {
            var $id = '#' + _id;
        }
        var _defOpts = {};
        var _nOpts = $.extend({}, _defOpts, _opts);
        $HUI.validatebox($id, _nOpts);
    },
    KeyWords: function () {},
    /**
     * HUI�Ŵ�
     * @param {String} id ��ǩId
     * @param {Object} opts �Ŵ�����,������Ĭ��
     * @param {Object} mOpts ��չ���ԣ���δ��
     */
    LookUp: function (_id, _opts) {
        var _defOpts = {
            mode: 'remote',
            url: $URL,
            pagination: true,
            onBeforeLoad: function (param) {
                param.QText = param.q;
            },
            onSelect: function (rowIndex, rowData) {
                // ע��˴���setValue������
                var idField = $('#' + _id).lookup('options').idField;
                $('#' + _id).lookup('setValue', rowData[idField]);
            }
        };
        var _nOpts = $.extend({}, _defOpts, _opts);

        $('#' + _id).lookup(_nOpts);
        $('#' + _id).on('blur', function () {
            if ($('#' + _id).lookup('getText') == '') {
                $('#' + _id).lookup('setValue', '');
            }
        });
    },

    ComboBox: function (_id, _opts) {
        var _defOpts = {
            valueField: 'RowId',
            textField: 'Description',
            width: '160',
            defaultFilter: 4,
            onBeforeLoad: function (param) {
                param.QText = param.q;
            }
        };
        var _nOpts = $.extend({}, _defOpts, _opts);
        $HUI.combobox('#' + _id, _nOpts);
        if (_opts.placeholder != undefined) {
            $('#' + _id)
                .next()
                .find('.combo-text')
                .attr('placeholder', _opts.placeholder);
        }
    },
    ComboGrid: function (_id, _opts) {
        var _defOpts = {
            mode: 'remote',
            url: $URL,
            pagination: true,
            onBeforeLoad: function (param) {
                param.QText = param.q;
            }
        };
        var _nOpts = $.extend({}, _defOpts, _opts);
        $('#' + _id).combogrid(_nOpts);
    },

    ComboTree: function (_id, _opts) {
        _opts = _opts || {};
        var _defOpts = {};
        var _nOpts = $.extend({}, _defOpts, _opts);

        $HUI.combotree('#' + _id, _nOpts);
    },
    /**
     * @param {String} _id idֵ
     * @param {Object} _opts ��������
     * @param {String} _select $(_id��Ϊjqɸѡֱ�Ӽ���),����_id����Ϊ_id
     */
    DateBox: function (_id, _opts, _select) {
        _select = _select || '';
        if (_select == '$') {
            var $id = _id;
        } else {
            var $id = '#' + _id;
        }
        var _defOpts = {
            width: '160'
        };
        _opts = _opts || {};
        var _nOpts = $.extend({}, _defOpts, _opts);
        $($id).datebox(_nOpts);
        return;
        var _eleOpts = PHA_COM.ELE[_id] || {};
        var _hOpts = _eleOpts.options || {};
        var _nOpts = $.extend({}, _opts, _hOpts);
        $('#' + _id).datebox(_nOpts);
        if (_eleOpts.methods) {
            for (var _m in _eleOpts.methods) {
                $('#' + _id).datebox(_m, _eleOpts.methods[_m]);
            }
        }
    },
    Window: function () {},
    Dialog: function () {},
    /**
     * ��ʾ��Ϣ��
     * @param {String} _title ����
     * @param {String} _content ����
     * @param {String} _type ����(info,success,warning,error)��ֱ�Ӻ�̨���صĸ�����
     */
    Alert: function (_title, _content, _type, _callBack) {
        if (_title == '') {
            _title = '��ʾ';
        }
        var _typeLevel = parseInt(_type);
        if (isNaN(_typeLevel) == false) {
            if (_typeLevel == -1) {
                _type = 'info';
            } else if (_typeLevel == -2) {
                _type = 'warning';
            } else if (_typeLevel < -3) {
                _type = 'error';
            } else if (_typeLevel >= 0) {
                _type = 'success';
            }
        }
        $.messager.alert(_title, _content, _type, _callBack);
    },
    /**
     * ����ʾ
     * @param {object} _opts
     * 				   _opts.msg ��ʾ����
     *				   _opts.type ��ʾ���� (info,success,alert,error)
     *				   _opts.timeout ��ʾʱ�䳤��,0 ����ʧ
     *				   _opts.showSpeed ��ʾ�ٶ� (fast,slow,normal)
     *				   _opts.showType ��ʾ��ʽ (slide,fade,show)
     *				   _opts.style ����λ��(top:1,left:1,right:1,bottom:1)
     */
    Popover: function (_opts) {
        var _defOpts = {
            timeout: 1000
        };
        var _nOpts = $.extend({}, _defOpts, _opts);
        $.messager.popover(_nOpts);
    },
    /**
     * ȷ����Ϣ��
     * @param {String} _title ����
     * @param {String} _content ����
     * @param {String} _callBack �ص�
     */
    Confirm: function (_title, _content, _callBack) {
        if (_title == '') {
            _title = 'ȷ����ʾ';
        }
        $.messager.confirm(_title, _content, function (r) {
            if (r) {
                _callBack();
            } else {
            }
        });
    },
    /**
     * datagrid ˫���б���,���ڼ��ر������
     * @param {object} e
     * @param {String} field
     */
    onDblClickHeader: function (e, field) {
        var id = this.id;
        // sys/v1/grid.js��̬����
        $.getScript('../scripts/pha/sys/v1/grid.win.js', function () {
            PHA_GRID_WIN.Open(id);
        });
    },
    /**
     * datagrid �Ҽ��б���,���ڼ��ر��ѡ��ʾ��
     * @param {Object} e
     * @param {String} field
     */
    onHeaderContextMenu: function (e, field) {
        //return jq.each(function () {
        // ����Ҽ�����,����ת��Ϊ������
        e.preventDefault();
        var grid = $(this); /* grid���� */
        var headerContextMenu = this.headerContextMenu; /* grid�ϵ���ͷ�˵����� */
        if (!headerContextMenu) {
            // window ��ʽ��
        }
        var okCls = 'tree-checkbox1'; // ѡ��
        var emptyCls = 'tree-checkbox0'; // ȡ��
        if (!headerContextMenu) {
            var tmenu = $('<div class="GridHeaderContexMenu" style="width:150px;"></div>').appendTo('body');
            var fields = grid.datagrid('getColumnFields');
            for (var i = 0; i < fields.length; i++) {
                var fildOption = grid.datagrid('getColumnOption', fields[i]);
                //checkbox ����ʾ
                if (fildOption.checkbox === true) {
                    continue;
                }
                if (!fildOption.hidden) {
                    $('<div iconCls="' + okCls + '" field="' + fields[i] + '"/>')
                        .html(fildOption.title)
                        .appendTo(tmenu);
                } else {
                    $('<div iconCls="' + emptyCls + '" field="' + fields[i] + '"/>')
                        .html(fildOption.title)
                        .appendTo(tmenu);
                }
            }
            headerContextMenu = tmenu.menu({
                onClick: function (item) {
                    var field = $(item.target).attr('field');
                    if (item.iconCls == okCls) {
                        // �ж��Ƿ�ȫ������ʾ
                        var hiddeLen = 0;
                        var fields = grid.datagrid('getColumnFields');
                        var fieldsLen = fields.length;
                        for (var i = 0; i < fieldsLen; i++) {
                            var fieldOption = grid.datagrid('getColumnOption', fields[i]);
                            if (fieldOption.hidden == true) {
                                hiddeLen++;
                            }
                        }
                        if (hiddeLen + 1 >= fieldsLen) {
                            $.messager.popover({
                                msg: '������޷�ȫ������Ϊ����ʾ',
                                type: 'alert'
                            });
                            return;
                        }
                        grid.datagrid('hideColumn', field);
                        $(this).menu('setIcon', {
                            target: item.target,
                            iconCls: emptyCls
                        });
                    } else {
                        grid.datagrid('showColumn', field);
                        $(this).menu('setIcon', {
                            target: item.target,
                            iconCls: okCls
                        });
                    }
                }
            });
        }
        headerContextMenu.menu('show', {
            left: e.pageX,
            top: e.pageY
        });
        //});
    },
    /**
     * @description �Ҽ��˵�,Ŀǰ���ɵ���
     * @param {*} e
     * @param {*} rowIndex
     * @param {*} rowData
     */
    onRowContextMenu: function (e, rowIndex, rowData) {
        if ($(this).datagrid('options').exportXls == true) {
            // �Ҽ�
            var menuId = 'PHA_GRID_' + 'onRowContextMenu';
            var gridId = this.id;
            e.preventDefault(); //��ֹ����ð��
            if ($('#' + menuId).length > 0) {
                $('#' + menuId).remove();
            }
            var menuHtml =
                '<div id=' + menuId + ' class="hisui-menu" style=" display: none;">' + '<div id=' + menuId + '_export' + ' data-options="' + "iconCls:'icon-excel'" + '">����</div>' + '</div>';
            $('body').append(menuHtml);
            $('#' + menuId).menu();
            $('#' + menuId).menu('show', {
                left: e.pageX,
                top: e.pageY
            });
            $('#' + menuId + '_export').on('click', function () {
                PHA_COM.ExportGrid(gridId);
            });
        }
    },
    /**
     * �������»�ȡ�������,datagrid��ʼ��ǰ��
     * @param {String} id ���Id
     * @param {Object} columns ���������
     */
    ReGetGrid: function (id, columns) {
        var rgOpts = $.cm(
            {
                ClassName: 'PHA.SYS.Grid',
                MethodName: 'ReGetGrid'
            },
            false
        );

        return rgOpts;

        var _cm = $.extend({}, columns);
        var _columns = _cm[0].reverse();
        var _frozenColumns = '';
        return {
            columns: [_columns],
            frozenColumns: [_frozenColumns]
        };
    },
    ToolTip: function () {},
    CM: function () {},
    M: function () {},
    /**
     * @description ����Loading����
     * @param {Object} _method Show,Hide(��ʱ��Ϊ���ؽ���)
     */
    Loading: function (_method) {
        var loadId = 'PHA_Loading_Id';
        var _height = document.documentElement.clientHeight;
        var _padTop = _height > 61 ? (_height - 61) / 2 : 0;
        var LoadingFun = {
            // ���ؽ���load
            PageShow: function () {
                var _html = '';
                _html +=
                    '<div id=' +
                    loadId +
                    ' style="position:absolute;z-index:1000;top:0px;left:0px;width:100%;height:' +
                    _height +
                    'px;background:#fff;text-align:center;opacity:1;padding-top:' +
                    _padTop +
                    'px;filter:alpha(opacity=80);">';
                _html += '<img src="../scripts/bdp/Framework/icons/mkb/page_loading.gif"></img>';
                _html += '</div>';
                // ��ʱdom��û��
                document.write(_html);
                document.onreadystatechange = function () {
                    if (document.readyState == 'complete') {
                        LoadingFun.Hide();
                    }
                };
            },
            Show: function () {
                var _html = '';
                _html += '<div id=' + loadId + ' style="position:absolute;z-index:1000;top:0px;left:0px;width:100%;height:100%;background:#DDDDDB;text-align:center;padding-top:20%;opacity:0.8;">';
                // _html += '<font color="#15428B">�����С�����</font>';
                _html += '<img src="../scripts/pha/com/v1/css/gif/loading.gif" width="80px"></img>';
                _html += '</div>';
                $('body').append(_html);
            },
            Hide: function () {
                $('#' + loadId).remove();
            }
        };
        LoadingFun[_method]();
    },
    /**
     * @description ��������ֵ,�˷�ʽ��Ҫ�Զ������Ե���ǩ��
     * @param  {Array} gArr id����
     * @param  {String} retType Ĭ�Ͽռ�Array(Json,Array)
     * @return {Array}
     */
    GetVals: function (gArr, retType) {
        retType = retType || '';
        var valueArr = [];
        var valueObj = {};
        var gArrLen = gArr.length;
        if (gArrLen == 0) {
            return [];
        }
        for (var i = 0; i < gArrLen; i++) {
            var gId = gArr[i];
            var lblText = $("label[for='" + gId + "']").text() || '';
            if (lblText != '') {
                lblText = lblText + ',';
            }
            var phaOpts = PHA.ChkPhaOpts(gId);
            if (typeof phaOpts == 'string') {
                PHA.Popover({
                    msg: lblText + phaOpts,
                    type: 'error',
                    style: {
                        top: 20,
                        left: ''
                    }
                });
                return [];
            }
            var requied = phaOpts.requied;
            var gVal = PHA.DoVal('get', phaOpts.class, gId);
            if (requied == true) {
                if (gVal == '') {
                    PHA.Popover({
                        msg: lblText + '����Ϊ��',
                        type: 'alert',
                        style: {
                            top: 20,
                            left: ''
                        }
                    });
                    return [];
                }
            }
            if (retType == 'Json') {
                valueObj[gId] = gVal;
            } else {
                valueArr.push(gVal);
            }
        }
        if (retType == 'Json') {
            valueArr.push(valueObj);
        }
        return valueArr;
    },
    /**
     * @description ������ֵ
     * @return {Array} ���ݸ�ʽ[{id1:ֵ1},{id2:ֵ2}]
     */
    SetVals: function (gArr) {
        var gArrLen = gArr.length;
        for (var i = 0; i < gArrLen; i++) {
            var gObj = gArr[i];
            for (var gId in gObj) {
                var phaOpts = PHA.ChkPhaOpts(gId);
                if (typeof phaOpts == 'string') {
                    var lblText = $("label[for='" + gId + "']").text() || '';
                    if (lblText != '') {
                        lblText = lblText + ',';
                    } else {
                        lblText = gId + ',';
                    }
                    PHA.Popover({
                        msg: lblText + phaOpts,
                        type: 'error',
                        style: {
                            top: 20,
                            left: ''
                        }
                    });
                }
                var gVal = gObj[gId];
                PHA.DoVal('set', phaOpts.class, gId, gVal);
            }
        }
    },
    /**
     * @description �������ֵ
     * @return {Array}
     */
    ClearVals: function (gArr) {
        var gArrLen = gArr.length;
        for (var i = 0; i < gArrLen; i++) {
            var gId = gArr[i];
            var phaOpts = PHA.ChkPhaOpts(gId);
            if (typeof phaOpts == 'string') {
                var lblText = $("label[for='" + gId + "']").text() || '';
                if (lblText != '') {
                    lblText = lblText + ',';
                }
                PHA.Popover({
                    msg: lblText + phaOpts,
                    type: 'error',
                    style: {
                        top: 20,
                        left: ''
                    }
                });
            }
            PHA.DoVal('clear', phaOpts.class, gId);
        }
    },
    /**
     * ��֤pha-options
     * @param {String} gId domId
     * @return �ɹ�����pha-options����,ʧ�ܷ���String��Ϣ
     */
    ChkPhaOpts: function (gId) {
        if (gId == '') {
            return 'IdΪ��,�޷�����';
        }
        var $_gId = $('#' + gId);
        var dataphaStr = $_gId.attr('data-pha') || '';
        if (dataphaStr == '') {
            return 'data-pha����Ϊ��';
        }
        dataphaStr = '{' + dataphaStr + '}';
        // �ַ���תΪ�����壬evalҲ����  eval("("+dataphaStr+"}")
        var datapha = new Function('return ' + dataphaStr)();
        var cls = datapha.class || '';
        if (cls == '') {
            return 'data-pha.cls����Ϊ��';
        }
        return datapha;
    },
    DoVal: function (sgcType, cls, domId, domVal) {
        var $_dom = $('#' + domId);
        var gVal = '';
        switch (cls) {
            case 'hisui-combobox':
                if (sgcType == 'get') {
                    gVal = $_dom.combobox('getValue') || '';
                    if (gVal == 0) {
                        gVal = '';
                    }
                } else if (sgcType == 'set') {
                    if (typeof domVal == 'object') {
                        var domValObj = domVal;
                        var domVal = domValObj.RowId;
                        var domText = domValObj.Description;
                        var domSelect = domValObj.Select;
                        var comboData = $_dom.combobox('getData');
                        var exist = '';
                        for (var i = 0; i < comboData.length; i++) {
                            var rowId = comboData[i].RowId;
                            if (domVal == rowId) {
                                exist = 1;
                                break;
                            }
                        }
                        if (exist == '') {
                            if (domVal != '' && domText != '') {
                                comboData.push(domValObj);
                            }
                        }
                        $_dom.combobox('loadData', comboData);
                    }
                    $_dom.combobox('setValue', domVal);

                    // ��������select,call�ĵ�һ��������this,���Ӳ�������
                    if (domSelect !== false && domSelect !== 'false') {
                        $_dom.combobox('options').onSelect.call($_dom, {
                            RowId: domVal
                        });
                    }
                } else if (sgcType == 'clear') {
                    $_dom.combobox('clear');
                }
                break;
            case 'hisui-checkbox':
                if (sgcType == 'get') {
                    gVal = $_dom.checkbox('getValue');
                } else if (sgcType == 'set') {
                    var boolVal = domVal == 'Y' || domVal == '1';
                    $_dom.checkbox('setValue', boolVal);
                } else if (sgcType == 'clear') {
                    $_dom.checkbox('setValue', false);
                }
                break;
            case 'hisui-validatebox':
                if (sgcType == 'get') {
                    gVal = $_dom.val();
                } else if (sgcType == 'set') {
                    $_dom.val(domVal);
                } else if (sgcType == 'clear') {
                    $_dom.val('');
                }
                break;
            case 'hisui-datebox':
                if (sgcType == 'get') {
                    gVal = $_dom.datebox('getValue');
                } else if (sgcType == 'set') {
                    $_dom.datebox('setValue', domVal);
                } else if (sgcType == 'clear') {
                    $_dom.datebox('clear');
                }
                break;
            case 'hisui-timespinner':
                if (sgcType == 'get') {
                    gVal = $_dom.timespinner('getValue');
                } else if (sgcType == 'set') {
                    $_dom.timespinner('setValue', domVal);
                } else if (sgcType == 'clear') {
                    $_dom.timespinner('clear');
                }
                break;
            case 'hisui-numberbox':
                if (sgcType == 'get') {
                    gVal = $_dom.numberbox('getValue');
                } else if (sgcType == 'set') {
                    $_dom.numberbox('setValue', domVal);
                } else if (sgcType == 'clear') {
                    $_dom.numberbox('clear');
                }
                break;
            case 'hisui-lookup':
                if (sgcType == 'get') {
                    var gText = $_dom.lookup('getText');
                    if (gText == '') {
                        gVal = '';
                    } else {
                        gVal = $_dom.lookup('getValue');
                    }
                } else if (sgcType == 'set') {
                    if (typeof domVal == 'object') {
                        var domValObj = domVal;
                        var domText = domValObj.Description;
                        var domVal = domValObj.RowId;
                        $_dom.lookup('setText', domText);
                        $_dom.lookup('setValue', domVal);
                    }
                } else if (sgcType == 'clear') {
                    $_dom.lookup('setText', '');
                    $_dom.lookup('setValue', '');
                }
                break;
            case 'hisui-triggerbox':
                if (sgcType == 'get') {
                    var gText = $_dom.triggerbox('getValue');
                    if (gText == '') {
                        gVal = '';
                    } else {
                        gVal = $_dom.triggerbox('getValueId');
                    }
                } else if (sgcType == 'set') {
                    if (typeof domVal == 'object') {
                        var domValObj = domVal;
                        var domText = domValObj.Description;
                        var domVal = domValObj.RowId;
                        $_dom.triggerbox('setValue', domText);
                        $_dom.triggerbox('setValueId', domVal);
                    }
                } else if (sgcType == 'clear') {
                    $_dom.triggerbox('setValue', '');
                    $_dom.triggerbox('setValueId', '');
                }
                break;
            default:
                break;
        }
        return gVal;
    },
    /**
     * @description ִ�б�ǩ�µĸ�ֵ\���\��ֵ,�Ա�ǩ��data-pha����Ϊ׼
     * @param {String} _domId ��ǩId,��#����
     * @param {Object} _opts ������ʽ
     *					doType  query,save,clear
     * 					retType ����ֵ����,Ĭ��ΪArray,��ѡJson
     * 					exclude ����,����������
     * 					_needId
     */
    DomData: function (_domId, _opts) {
        var domArr = [];
        var doType = _opts.doType;
        $(_domId + ' [data-pha]').each(function () {
            var _id = this.id;
            var phaOpts = PHA.ChkPhaOpts(_id);
            var doTypeVal = phaOpts[doType];
            if (doTypeVal === undefined) {
                return true;
            }
            if (doTypeVal === true) {
                domArr.push(_id);
            } else if (isNaN(doTypeVal) == false) {
                domArr[doTypeVal] = _id;
            }
        });
        if (doType == 'clear') {
            PHA.ClearVals(domArr);
        } else {
            return PHA.GetVals(domArr, _opts.retType || '');
        }
        return [];
    },
    EditGrid: {
        /**
         * @description ���������
         * @param {Object} _opts Ĭ������
         * @param {Object} _lnkOpts ��չ����,����ҩƷ��λ��Ҫ�Ȼ�֪ҩƷId
         * 				   			lnkField ��������ڵ���field
         * 							lnkGrid  ���Id
         * 							lnkQName ���ֶζ�Ӧ��̨�������
         */
        ComboBox: function (_opts, _lnkOpts) {
            var _defOpts = {
                type: 'combobox'
            };
            var _defSubOpts = {
                selectOnNavigation: false,
                valueField: 'RowId',
                textField: 'Description',
                onBeforeLoad: function (param) {
                    param.QText = param.q;
                    if (_lnkOpts) {
                        if (_lnkOpts.lnkField) {
                            var _curRow = $('#' + _lnkOpts.lnkGrid).datagrid('getSelected');
                            var _lnkFieldVal = _curRow[_lnkOpts.lnkField];
                            param[_lnkOpts.lnkQName] = _lnkFieldVal;
                        }
                    }
                }
            };
            var _nSubOpts = $.extend({}, _defSubOpts, _opts);
            _defOpts.options = _nSubOpts;
            var _nOpts = $.extend({}, _defOpts);
            return _nOpts;
        },
        /**
         * @description ������������
         * @param {Object} _opts Ĭ������
         * @param {Object} _lnkOpts ��չ����,����ҩƷ��λ��Ҫ�Ȼ�֪ҩƷId
         * 				   			lnkField ��������ڵ���field
         * 							lnkGrid  ���Id
         * 							lnkQName ���ֶζ�Ӧ��̨�������
         */
        ComboGrid: function (_opts, _lnkOpts) {
            var _defOpts = {
                type: 'combogrid'
            };
            var _defSubOpts = {
                mode: 'remote',
                url: $URL,
                pagination: true,
                onBeforeLoad: function (param) {
                    param.QText = param.q;
                    if (_lnkOpts) {
                        if (_lnkOpts.lnkField) {
                            var _curRow = $('#' + _lnkOpts.lnkGrid).datagrid('getSelected');
                            var _lnkFieldVal = _curRow[_lnkOpts.lnkField];
                            param[_lnkOpts.lnkQName] = _lnkFieldVal;
                        }
                    }
                }
            };
            var _nSubOpts = $.extend({}, _defSubOpts, _opts);
            _defOpts.options = _nSubOpts;
            var _nOpts = $.extend({}, _defOpts);
            return _nOpts;
        }
    },
    /**
     * ����֤���ȷ����Ϣ��
     * @param {String} _title ����
     * @param {String} _content ����
     * @param {String} _callBack �ص�
     */
    ConfirmPrompt: function (_title, _content, _callBack) {
        var randomStr = PHA_UTIL.RandomStr(6);
        var _winDivId = 'PHA_ConfirmPrompt';
        var _winDiv = '';
        _winDiv += '<div id=' + _winDivId + ' style="padding:10px;overflow:hidden;">';
        _winDiv += '    <div class="pha-row" style="margin-top:0;padding:10px;background:#FFFBE6;border:1px solid #FFE48F;color:#595959;border-radius: 4px;">' + _content + '</div>';
        _winDiv += '    <div class="pha-row">';
        _winDiv += '        <div style="display:inline">������ ' + '<b>' + randomStr + '</b>' + ' ��ȷ��</div>';
        _winDiv += '        <div class="confirmWarn" style="display:inline;color:red;font-weight:bold;padding-left:10px;"></div>';
        _winDiv += '    </div>';
        _winDiv += '    <div class="pha-row" style="padding-right:8px"><input class="textbox" type="text" style="width:100%"></div>';
        _winDiv += '</div>';
        $('body').append(_winDiv);
        $('#' + _winDivId)
            .dialog({
                title: _title || '��ʾ',
                collapsible: false,
                resizable: false,
                maximizable: false,
                minimizable: false,
                closable: false,
                border: false,
                closed: true,
                modal: true,
                width: 300,
                height: 210,
                buttons: [
                    {
                        text: 'ȷ��',
                        handler: function () {
                            var validInput = $('#' + _winDivId + ' .textbox')
                                .val()
                                .trim();
                            if (validInput === '') {
                                $('.confirmWarn').text('�밴��ʾ����');
                            } else if (validInput === randomStr) {
                                _callBack();
                                $('#' + _winDivId).window('close');
                            } else {
                                $('.confirmWarn').text('�������');
                            }
                        }
                    },
                    {
                        text: 'ȡ��',
                        handler: function () {
                            $('#' + _winDivId).window('close');
                        }
                    }
                ],
                onClose: function () {
                    $('#' + _winDivId).window('destroy');
                }
            })
            .dialog('open');
    }
};
PHA.Loading('PageShow');
