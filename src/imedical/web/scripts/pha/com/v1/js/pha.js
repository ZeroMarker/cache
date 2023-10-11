/**
 * 名称:   药房公共-初始化插件及部分方法
 * 编写人:  yunhaibao
 * 编写日期: 2019-03-12
 * 插件包含: HUI表格、HUI下拉框、HUI树、HUI树表格、HUI放大镜、HUI消息(msg,alert)
 * scripts/pha/com/v1/js/pha.js
 */
var PHA = {
    /**
     * HUI表格
     * @param {string} id 表格Id
     * @param {object} opts 表格属性,将覆盖默认
     * @param {object} mOpts 表格扩展属性
     */
    Grid: function (id, opts, mOpts) {
        if (!id) {
            return;
        }
        mOpts = mOpts || {};
        // 默认属性
        var dOpts = {
            enableDnd: false,
            exportXls: true,
            printOut: false,
            fit: true,
            border: false,
            singleSelect: true,
            loadMsg: $g('正在加载信息...'),
            pageSize: 100,
            pageList: [30, 50, 100, 300, 500], // 100起
            pagination: true,
            pageNumber: 0,
            toolbar: [],
            // onDblClickHeader: PHA.onDblClickHeader,
            onHeaderContextMenu: PHA.onHeaderContextMenu,
            onRowContextMenu: PHA.onRowContextMenu,
            onLoadError: function (response) {
                if (response.statusText == 'abort') {
                    return;
                }
                var resText = response.responseText;
                PHA.Alert($g('查询错误'), resText, 'error');
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
            },
            onBeforeEdit: function (rowIndex, rowData) {
                $(this).datagrid('initPrecision', rowIndex);
            }
        };
        var nOpts = $.extend({}, dOpts, opts);
        if (typeof PHA_SYS_SET == 'object') {
            PHA_SYS_SET.Grid.Init(id, nOpts, function (gridOpts) {
                $HUI.datagrid('#' + id, gridOpts);
            });
        } else {
            this.setEditorField(id, nOpts.columns, nOpts.frozenColumns);
            $HUI.datagrid('#' + id, nOpts);
        }
        if (nOpts.enableDnd == true) {
            setTimeout(function () {
                // $('#' + id).datagrid('enableDnd');
                // 有冲突,2019-03-14,yhb
                // $('#' + id).datagrid('columnMoving');
                // $('#' + id).datagrid("enableCellSelecting")
            }, 1000);
        }
        // 处理那表格toolbar作为查询条件区域的padding问题
        var $grid = $('#' + id)
        var toolbar = $grid.datagrid('options').toolbar;
        if(toolbar !== '' && typeof toolbar !== 'object'){
            if($grid.parent().prev('.datagrid-toolbar').find('.pha-con-table').length > 0){
                $grid.parent().prev('.datagrid-toolbar').css({'padding':0})
            }
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
     * @param {Object} _opts 对应属性
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
        _opts.placeholder = $g(_opts.placeholder);
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
        _opts.placeholder = $g(_opts.placeholder);
        var _defOpts = {
            onText: $g('开'),
            offText: $g('关'),
            onClass: 'primary',
            offClass: 'gray'
        };
        var _nOpts = $.extend({}, _defOpts, _opts);
        $HUI.switchbox('#' + _id, _nOpts);
    },
    FileBox: function () {},
    SearchBox: function (_id, _opts) {
        _opts.placeholder = $g(_opts.placeholder);
        $HUI.searchbox('#' + _id, _opts);
        if (_opts.placeholder) {
            $('#' + _id)
            .searchbox('textbox')
            .attr('placeholder', _opts.placeholder)
            .css('padding-left', '5px');
        }
    },
    /**
     * @param {String} _id id值
     * @param {Object} _opts 对象属性
     * @param {String} _select $(_id作为jq筛选直接计算),否则_id仅视为_id
     */
    NumberBox: function (_id, _opts, _select) {
        _opts.placeholder = $g(_opts.placeholder);
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
        _opts.placeholder = $g(_opts.placeholder);
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
     * HUI放大镜
     * @param {String} id 标签Id
     * @param {Object} opts 放大镜属性,将覆盖默认
     * @param {Object} mOpts 扩展属性，暂未用
     */
    LookUp: function (_id, _opts) {
        _opts.placeholder = $g(_opts.placeholder);
        var _defOpts = {
            mode: 'remote',
            url: $URL,
            pagination: true,
            onBeforeLoad: function (param) {
                param.QText = param.q;
            },
            onSelect: function (rowIndex, rowData) {
                // 注意此处的setValue不能少
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
        _opts.placeholder = $g(_opts.placeholder);
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
        /* 记录点击次数 start */
        if (typeof _opts.recordLog === 'object') {
            var _onSelect = _opts.onSelect || '';
            _nOpts.onSelect = function (data) {
                var recordCsp = _opts.recordLog.csp;
                var recordLabel = _opts.recordLog.label;
                tkMakeServerCall('PHA.SYS.SelectRecordLog.Save', 'Save', recordCsp, $(this)[0].id, recordLabel, data.RowId, data.Description);
                var newUrl = $(this).combobox('options').url + '&cspName=' + recordCsp + '&SRLSelectCode=' + recordLabel;
                $(this).combobox('reload', newUrl);
                if (typeof _onSelect === 'function') {
                    _onSelect(data);
                }
            };
            _nOpts.loadFilter = function (data) {
                if (data.length === 0) {
                    return data;
                }
                var ret = $.cm({
                    ClassName: 'PHA.STORE.Com',
                    MethodName: 'SortStoreByRecord',
                    dataArrStr: JSON.stringify(data),
                    cspName: _opts.recordLog.csp,
                    conName: $(this)[0].id,
                    ResultSetType: 'array'
                }, false);
                console.log(ret);
                return ret;
            };
        }
        /* 记录点击次数 end */
        $HUI.combobox('#' + _id, _nOpts);
        if (_opts.placeholder != undefined) {
            $('#' + _id)
            .next()
            .find('.combo-text')
            .attr('placeholder', _opts.placeholder);
        }
        /* 悬浮显示多选的内容 */
        if (_opts.hoverShow === true){
            $('#' + _id).next().hover(function(){
                try{
                    var text = $('#' + _id).combobox('getText') || '';
                    if (text !== ''){
                        text = text.replace(/,/g, '</br>')
                        $('#' + _id).next().tooltip({
                            content: text,
                            position: 'bottom',
                            showDelay: _opts.hoverShowDelay || 800,
                        }).tooltip('show'); 
                    }
                }catch(e){}   
            }, function(){
                try{
                    $('#' + _id).next().tooltip('destroy')
                }catch(e){}
            })
        }
    },
    ComboGrid: function (_id, _opts) {
        _opts.placeholder = $g(_opts.placeholder);
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
        _opts.placeholder = $g(_opts.placeholder);
        var _defOpts = {};
        var _nOpts = $.extend({}, _defOpts, _opts);
        $HUI.combotree('#' + _id, _nOpts);
    },
    /**
     * @param {String} _id id值
     * @param {Object} _opts 对象属性
     * @param {String} _select $(_id作为jq筛选直接计算),否则_id仅视为_id
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
        _opts.placeholder = $g(_opts.placeholder);
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
     * 提示消息框
     * @param {String} _title 标题
     * @param {String} _content 内容
     * @param {String} _type 类型(info,success,warning,error)或直接后台返回的负数字
     */
    Alert: function (_title, _content, _type, _callBack) {
        if (_title == '') {
            _title = '提示';
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
        _content = _content.toString().replace('上箭头', '^');
        $.messager.alert(_title, _content, _type, _callBack);
    },
    /**
     * 简单提示
     * @param {object} _opts
     *                 _opts.msg 显示内容
     *                 _opts.type 显示类型 (info,success,alert,error)
     *                 _opts.timeout 显示时间长度,0 不消失
     *                 _opts.showSpeed 显示速度 (fast,slow,normal)
     *                 _opts.showType 显示方式 (slide,fade,show)
     *                 _opts.style 窗体位置(top:1,left:1,right:1,bottom:1)
     */
    Popover: function (_opts) {
        if ($.messager && $.messager.phapopover) {
            return $.messager.phapopover(_opts); // extend.js定义
        }
        var _defOpts = {
            timeout: 1000
        };
        var _nOpts = $.extend({}, _defOpts, _opts);
        $.messager.popover(_nOpts);
    },
    Msg: function (_type, _Msg) {
        return PHA.Popover({
            type: _type,
            msg: _Msg
        });
    },
    /**
     * 确认消息框
     * @param {String} _title 标题
     * @param {String} _content 内容
     * @param {String} _callBack 回调
     */
    Confirm: function (_title, _content, _callBack) {
        if (_title == '') {
            _title = '确认提示';
        }
        $.messager.confirm(_title, _content, function (r) {
            if (r) {
                _callBack();
            } else {}
        });
    },
    /**
     * datagrid 双击列标题,用于加载表格设置
     * @param {object} e
     * @param {String} field
     * 与双击排序冲突,修改到右键弹出
     */
    onDblClickHeader: function (e, field) {
        var tdWidth = $(e.target).parent().width();
        if (tdWidth - e.offsetX < 3) {
            return;
        }
        var id = this.id;
        PHA_UTIL.LoadJS(['../scripts/pha/sys/v1/colset.win.js', '../scripts/pha/com/v1/js/grideditor.js'], function () {
            if (typeof PHA_SYS_SET == 'object') {
                PHA_SYS_SET.Grid.Open(id);
            }
        });
    },
    /**
     * datagrid 右键列标题,用于加载表格勾选显示列
     * @param {Object} e
     * @param {String} field
     */
    onHeaderContextMenu: function (e, field) {
        // return jq.each(function () {
        // 表格右键标题,可能转换为类声明
        e.preventDefault();
        var grid = $(this); /* grid本身 */
        var headerContextMenu = this.headerContextMenu; /* grid上的列头菜单对象 */
        if (!headerContextMenu) {
            // window 形式？
        }
        // var okCls = 'tree-checkbox1'; // 选中
        var okCls = 'icon-check'; // 选中
        var emptyCls = 'tree-checkbox0'; // 取消
        var setColCls = 'icon-set-col';
        if (!headerContextMenu) {
            var tmenu = $('<div class="GridHeaderContexMenu" style="width:200px;overflow:auto;height:400px;"></div>').appendTo('body');
            $('<div iconCls="icon-set-col"/>').html("更多列设置").appendTo(tmenu);
            var fields = grid.datagrid('getColumnFields', true).concat(grid.datagrid('getColumnFields'));
            for (var i = 0; i < fields.length; i++) {
                var fieldOption = grid.datagrid('getColumnOption', fields[i]);
                // checkbox 不显示, 1|true
                if (fieldOption.checkbox == 1) {
                    continue;
                }
                if (!fieldOption.hidden) {
                    $('<div iconCls="' + okCls + '" field="' + fields[i] + '"/>')
                    .html(fieldOption.title)
                    .appendTo(tmenu);
                } else {
                    $('<div iconCls="' + emptyCls + '" field="' + fields[i] + '"/>')
                    .html(fieldOption.title)
                    .appendTo(tmenu);
                }
            }
            headerContextMenu = tmenu.menu({
                onClick: function (item) {
                    var field = $(item.target).attr('field');
                    if (item.iconCls == setColCls) {
                        return PHA_UTIL.LoadJS(['../scripts/pha/sys/v1/colset.win.js', '../scripts/pha/com/v1/js/grideditor.js'], function () {
                            if (typeof PHA_SYS_SET == 'object') {
                                PHA_SYS_SET.Grid.Open(grid.attr('id'));
                            }
                        });
                    }
                    if (item.iconCls == okCls) {
                        // 判断是否全部不显示
                        var hiddeLen = 0;
                        var fields = grid.datagrid('getColumnFields', true).concat(grid.datagrid('getColumnFields'));
                        var fieldsLen = fields.length;
                        for (var i = 0; i < fieldsLen; i++) {
                            var fieldOption = grid.datagrid('getColumnOption', fields[i]);
                            if (fieldOption.hidden == true) {
                                hiddeLen++;
                            }
                        }
                        if (hiddeLen + 1 >= fieldsLen) {
                            $.messager.popover({
                                msg: '表格列无法全部设置为不显示',
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
                    grid.datagrid('resize')
                    headerContextMenu.menu('show');
                }
            });
        }
        headerContextMenu.menu('show', {
            left: e.pageX,
            top: e.pageY
        });
    },
    /**
     * @description 右键菜单,目前集成导出
     * @param {*} e
     * @param {*} rowIndex
     * @param {*} rowData
     */
    onRowContextMenu: function (e, rowIndex, rowData) {
        e.preventDefault();
        var menuId = 'PHA_GRID_' + 'onRowContextMenu';
        var gridId = this.id;
        if ($('#' + menuId).length > 0) {
            $('#' + menuId).remove();
        }
        $('body').append('<div id=' + menuId + ' class="hisui-menu" style=" display: none;"></div>');
        if ($(this).datagrid('options').exportXls == true) {
            $('#' + menuId).append('<div id=' + menuId + '_export' + ' data-options="' + "iconCls:'icon-excel'" + '">导出</div>');
            $('#' + menuId + '_export').on('click', function () {
                PHA_COM.ExportGrid(gridId);
            });
        }
        if ($(this).datagrid('options').printOut == true) {
            $('#' + menuId).append('<div id=' + menuId + '_print' + ' data-options="' + "iconCls:'icon-print'" + '">打印</div>');
            $('#' + menuId + '_print').on('click', function () {
                PHA_COM.PrintGrid(gridId);
            });
        }
        if ($('#' + menuId).children().length == 0) {
            return;
        }
        $('#' + menuId).menu();
        $('#' + menuId).menu('show', {
            left: e.pageX,
            top: e.pageY
        });
    },
    /**
     * 用于重新获取表格属性,datagrid初始化前调
     * @param {String} id 表格Id
     * @param {Object} columns 表格列属性
     */
    ReGetGrid: function (id, columns) {
        var rgOpts = $.cm({
            ClassName: 'PHA.SYS.Grid',
            MethodName: 'ReGetGrid'
        }, false);
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
     * @description 加载Loading动画
     * @param {Object} _method Show,Hide(空时视为加载界面)
     */
    Loading: function (_method) {
        var loadId = 'PHA_Loading_Id';
        var _height = document.documentElement.clientHeight;
        var _padTop = _height > 61 ? (_height - 61) / 2 : 0;
        var LoadingFun = {
            // 加载界面load
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
                // 此时dom还没有
                document.write(_html);
                document.onreadystatechange = function () {
                    if (document.readyState == 'complete') {
                        LoadingFun.Hide();
                    }
                };
            },
            Show: function () {
                var _html = '';
                // _html += '<div id=' + loadId + ' style="position:absolute;z-index:1000;top:0px;left:0px;width:100%;height:100%;background:#cccccc;text-align:center;padding-top:20%;opacity:0.3;">';
                // _html += '<img src="../scripts/pha/com/v1/css/gif/loading.gif" width="50px"></img>';
                // _html += '<font color="#15428B">加载中···</font>';
                _html += '<div id=' + loadId + '>'
                _html += '<div class="datagrid-mask" style="display:block"></div>'
                _html += '<div class="datagrid-mask-msg" style="display: block; left: 50%; height: 16px; margin-left: -66.5px; line-height: 16px;width:100px">正在处理中...</div>'
                _html += '</div>';
                $('body').append(_html);
            },
            Hide: function () {
                $('#' + loadId).remove();
                if (typeof PHA_SYS_SET == 'object') {
                    PHA_SYS_SET.Com.UnbindEvent();
                }
            }
        };
        LoadingFun[_method]();
    },
    /**
     * @description 批量操作值,此方式需要自定义属性到标签中
     * @param  {Array} gArr id数组
     * @param  {String} retType 默认空即Array(Json,Array)
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
            if ($('#' + gId).length == 0) {
                continue;
            }
            var lblText = $("label[for='" + gId + "']").text() || '';
            if (lblText != '') {
                lblText = lblText + ',';
            }
            var phaOpts = PHA.ChkPhaOpts(gId);
            if (typeof phaOpts == 'string') {
                PHA.Popover({
                    msg: lblText + phaOpts,
                    type: 'error'
                });
                return [];
            }
            var required = phaOpts.requied || phaOpts.required;
            var gVal = PHA.DoVal('get', phaOpts.class, gId);
            if (required == true) {
                if (gVal == '') {
                    PHA.Popover({
                        msg: lblText.replace(/(^\s*)|(\s*$)/g, '') + '不能为空', // 去除描述中空格(对齐使用的空格)
                        type: 'alert'
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
     * @description 批量给值
     * @return {Array} 数据格式[{id1:值1},{id2:值2}]
     */
    SetVals: function (gArr) {
        var gArrLen = gArr.length;
        for (var i = 0; i < gArrLen; i++) {
            var gObj = gArr[i];
            for (var gId in gObj) {
                if (gId.indexOf('?') >= 0 || ($('#' + gId).attr('data-pha') || '') === '') {
                    continue;
                }
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
                        type: 'error'
                    });
                }
                var gVal = gObj[gId];
                PHA.DoVal('set', phaOpts.class, gId, gVal);
            }
        }
    },
    /**
     * @description 批量清空值
     * @return {Array}
     */
    ClearVals: function (gArr) {
        var gArrLen = gArr.length;
        for (var i = 0; i < gArrLen; i++) {
            var gId = gArr[i];
            if ($('#' + gId).length == 0) {
                continue;
            }
            var phaOpts = PHA.ChkPhaOpts(gId);
            if (typeof phaOpts == 'string') {
                var lblText = $("label[for='" + gId + "']").text() || '';
                if (lblText != '') {
                    lblText = lblText + ',';
                }
                PHA.Popover({
                    msg: lblText + phaOpts,
                    type: 'error'
                });
            }
            PHA.DoVal('clear', phaOpts.class, gId);
        }
    },
    /**
     * 验证pha-options
     * @param {String} gId domId
     * @return 成功返回pha-options对象,失败返回String信息
     */
    ChkPhaOpts: function (gId) {
        if (gId == '') {
            return 'Id为空,无法处理';
        }
        var $_gId = $('#' + gId);
        var dataphaStr = $_gId.attr('data-pha') || '';
        if (dataphaStr == '') {
            return gId + ': data-pha属性为空';
        }
        dataphaStr = '{' + dataphaStr + '}';
        // 字符串转为函数体，eval也可以 eval("("+dataphaStr+"}")
        var datapha = new Function('return ' + dataphaStr)();
        var cls = datapha.class || '';
        if (cls == '') {
            return gId + ': data-pha.cls属性为空';
        }
        return datapha;
    },
    DoVal: function (sgcType, cls, domId, domVal) {
        var $_dom = $('#' + domId);
        var gVal = '';
        var realVal = '';
        switch (cls) {
        case 'hisui-combobox':
            var tmpOpts = $_dom.combobox('options');
            if (sgcType == 'get') {
                if (tmpOpts.multiple == true) {
                    gVal = ($_dom.combobox('getValues') || []).join(','); // Huxt 2021-07-30
                } else {
                    gVal = $_dom.combobox('getValue');
                    gVal = typeof gVal == 'undefined' || gVal == null ? '' : gVal;
                }
            } else if (sgcType == 'set') {
                var realVal = '',
                realValArr = [];
                // 多选赋值使用数组
                if (typeof domVal == 'object') {
                    var domValArr = [];
                    if (Object.prototype.toString.call(domVal) == '[object Object]') {
                        domValArr.push(domVal);
                    } else {
                        domValArr = domVal;
                    }
                    for (var domI = 0, domLen = domValArr.length; domI < domLen; domI++) {
                        var domRow = domValArr[domI];
                        if (Object.prototype.toString.call(domRow) == '[object Object]') {
                            var domValObj = domRow;
                            var domValID = domValObj[tmpOpts.valueField] || domValObj['RowId'];
                            var domText = domValObj[tmpOpts.textField] || domValObj['Description'];
                            var domSelect = domValObj.Select;
                            var comboData = $_dom.combobox('getData');
                            var exist = '';
                            for (var i = 0; i < comboData.length; i++) {
                                var rowId = comboData[i][tmpOpts.valueField] || comboData[i]['RowId'];
                                if (domValID == rowId) {
                                    exist = 1;
                                    break;
                                }
                            }
                            // 下拉无数据, 给值
                            if (exist == '') {
                                if (domValID != '' && domText != '') {
                                    comboData.push(domValObj);
                                }
                            }
                            if (tmpOpts.multiple == true) {
                                realValArr.push(domValID);
                            } else {
                                // 单选可能值传来为 {RowId:'1',Description:'11'}
                                realVal = domValID;
                            }
                        } else {
                            realValArr.push(domRow);
                        }
                    }
                    if (typeof comboData === 'object') {
                        $_dom.combobox('loadData', comboData);
                    }
                } else {
                    realVal = domVal;
                }
                if (tmpOpts.multiple == true) {
                    if ((realVal != "") && (typeof domVal != 'object')) {
                        $_dom.combobox('setValues', realVal.split(","));
                    } else {
                        $_dom.combobox('setValues', realValArr);
                    }
                } else {
                    $_dom.combobox('setValue', realVal);
                    // 主动触发select,call的第一个参数是this,增加参数控制
                    if (domSelect !== false && domSelect !== 'false') {
                        $_dom.combobox('options').onSelect.call($_dom, {
                            RowId: realVal
                        });
                    }
                }
            } else if (sgcType == 'clear') {
                //$_dom.combobox('clear');
                $_dom.combobox('reset');
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
                if (($_dom.eq(0).attr('class') || '').indexOf('hisui-validatebox') >= 0) {
                    $_dom.validatebox('validate');
                }
            } else if (sgcType == 'clear') {
                $_dom.val('');
                if (($_dom.eq(0).attr('class') || '').indexOf('hisui-validatebox') >= 0) {
                    $_dom.validatebox('validate');
                }
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
            var tmpOpts = $_dom.lookup('options');
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
                    var domText = domValObj[tmpOpts.textField] || domValObj['Description'];
                    var domVal = domValObj[tmpOpts.idField] || domValObj['RowId'];
                    $_dom.lookup('setText', domText);
                    $_dom.lookup('setValue', domVal);
                }
            } else if (sgcType == 'clear') {
                $_dom.lookup('setText', '');
                $_dom.lookup('setValue', '');
            }
            break;
        case 'hisui-combogrid':
            // Huxt 2021-07-30
            var tmpOpts = $_dom.combogrid('options');
            if (sgcType == 'get') {
                var gText = $_dom.combogrid('getText');
                if (gText == '') {
                    gVal = '';
                } else {
                    gVal = $_dom.combogrid('getValue');
                }
            } else if (sgcType == 'set') {
                if (typeof domVal == 'object') {
                    var domValObj = domVal;
                    var domText = domValObj[tmpOpts.textField] || domValObj['Description'];
                    var domVal = domValObj[tmpOpts.idField] || domValObj['RowId'];
                    var $cmg = $($_dom.combogrid('grid'));
                    $cmg.datagrid('loadData', {
                        total: 1,
                        rows: [domValObj]
                    });
                    $_dom.combogrid('setText', domText);
                    $_dom.combogrid('setValue', domVal);
                }
            } else if (sgcType == 'clear') {
                $_dom.combogrid('setText', '');
                $_dom.combogrid('setValue', '');
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
        case 'hisui-radio':
            if (sgcType == 'get') {
                gVal = $('input[name=' + domId + ']:checked').val() || '';
            } else if (sgcType == 'set') {
                if (domVal == '')
                    break;
                $HUI.radio('input[name=' + domId + '][value=' + domVal + ']').setValue(true);
            } else if (sgcType == 'clear') {
                // $HUI.radio("#" + domId).setValue(false);
                $('[name=' + domId + ']').radio('setValue', false);
            }
            break;
        case 'hisui-textarea':
            if (sgcType == 'get') {
                gVal = $_dom.val();
            } else if (sgcType == 'set') {
                gVal = $_dom.val(domVal);
            } else if (sgcType == 'clear') {
                gVal = $_dom.val('');
            }
            break;
        case 'text':
            if (sgcType == 'get') {
                gVal = $_dom.text();
            } else if (sgcType == 'set') {
                gVal = $_dom.text(domVal);
            } else if (sgcType == 'clear') {
                gVal = $_dom.text('');
            }
            break; 
        default:
            break;
        }
        return gVal;
    },
    /**
     * @description 执行标签下的给值\清空\赋值,以标签中data-pha属性为准
     * @param {String} _domId 标签Id,带#符号
     * @param {Object} _opts 操作方式
     *                  doType  query,save,clear
     *                  retType 返回值类型,默认为Array,可选Json
     *                  exclude 数组,操作不包含
     *                 _needId
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
         * @description 表格内下拉
         * @param {Object} _opts 默认属性
         * @param {Object} _lnkOpts 扩展属性,例如药品单位需要先获知药品Id
         *                          lnkField 关联表格内的列field
         *                          lnkGrid  表格Id
         *                          lnkQName 该字段对应后台的入参名
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
         * @description 表格内下拉表格
         * @param {Object} _opts 默认属性
         * @param {Object} _lnkOpts 扩展属性,例如药品单位需要先获知药品Id
         *                          lnkField 关联表格内的列field
         *                          lnkGrid  表格Id
         *                          lnkQName 该字段对应后台的入参名
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
     * 带验证码的确认消息框
     * @param {String} _title 标题
     * @param {String} _content 内容
     * @param {String} _callBack 回调
     * @param {String} _keyWord 操作需要的录入的验证信息, 空时由系统生成随机码, 建议不空
     */
    ConfirmPrompt: function (_title, _content, _callBack, _keyWord) {
        _keyWord = _keyWord || '';
        var randomStr = _keyWord !== '' ? _keyWord : PHA_UTIL.RandomStr(6);
        var _winDivId = 'PHA_ConfirmPrompt';
        var _winDiv = '';
        _winDiv += '<div id=' + _winDivId + ' style="padding:10px;padding-bottom:0;overflow:hidden;">';
        _winDiv += '    <div class="pha-row" style="margin-top:0;padding:10px;background:#FFFBE6;border:1px solid #FFE48F;color:#595959;border-radius: 4px;">' + _content + '</div>';
        _winDiv += '    <div class="pha-row">';
        _winDiv += '        <div style="display:inline">请输入或双击 ' + '<a class="js-alert-a-key"><b>' + randomStr + '</b></a>' + ' 以确认</div>';
        _winDiv += '        <div class="confirmWarn" style="display:inline;color:red;font-weight:bold;padding-left:10px;"></div>';
        _winDiv += '    </div>';
        _winDiv += '    <div class="pha-row" style="padding-right:8px;margin-bottom:0;"><input class="textbox" type="text" style="width:100%"></div>';
        _winDiv += '</div>';
        $('body').append(_winDiv);
        $('.js-alert-a-key')
        .unbind()
        .hover(function () {
            $(this).css({
                cursor: 'pointer'
            });
        })
        .dblclick(function (e) {
            $('#' + _winDivId + ' .textbox').val($(e.target).text());
        });

        $('#' + _winDivId)
        .dialog({
            title: _title || '提示',
            collapsible: false,
            resizable: false,
            maximizable: false,
            minimizable: false,
            closable: false,
            border: false,
            closed: true,
            modal: true,
            width: 300,
            height: 'auto',
            buttons: [{
                    text: $g('确定'),
                    handler: function () {
                        var validInput = $('#' + _winDivId + ' .textbox')
                            .val()
                            .trim();
                        if (validInput === '') {
                            $('.confirmWarn').text($g('请按提示输入'));
                        } else if (validInput === randomStr) {
                            _callBack();
                            $('#' + _winDivId).window('close');
                        } else {
                            $('.confirmWarn').text($g('输入错误'));
                        }
                    }
                }, {
                    text: $g('取消'),
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
    },
    /**
     * 更多和隐藏切换的按钮
     * huxiaotian 2020-08-22
     * @param {string} _id html中的domId
     * @param {string} _options.buttonTextArr,指定切换的内容, 例如: ['更多', '隐藏']
     * @param {string} _options.selectedText,指定初始化选中的内容, 例如: '更多'
     * @param {string} _options.onClick按钮点击时的回调函数, 例如: function(oldText, newText){// dosomething}
     * @return
     */
    ToggleButton: function (_id, _options) {
        if (!PHA.IsLoadToggleButtonCss) {
            var cssStr = '';
            cssStr += ' .pha-toggle-btn {';
            cssStr += '     color: #40A2DE;';
            cssStr += '     text-decoration: underline;';
            cssStr += '     padding-right: 13px;';
            cssStr += '     background: url(../images/fa-angle-double-down_40a2de_12.png) no-repeat center right;';
            cssStr += '     line-height: 13px;';
            cssStr += '     display: inline-block;';
            cssStr += '     border-bottom: 1px solid #40a2de;';
            cssStr += '     cursor: pointer;';
            cssStr += ' }';
            cssStr += ' .pha-toggle-expanded {';
            cssStr += '     background: url(../images/fa-angle-double-up_40a2de_12.png) no-repeat center right;';
            cssStr += ' }';
            var $HtmlHead = $(document).find('head').eq(0);
            var $HeadStyleLabel = $HtmlHead.find('style').eq(0);
            if ($HeadStyleLabel.length == 0) {
                $HtmlHead.append('<style></style>');
                $HeadStyleLabel = $HtmlHead.find('style').eq(0);
            }
            $HeadStyleLabel.append(cssStr);
            PHA.IsLoadToggleButtonCss = true;
        }
        var buttonTextArr = _options.buttonTextArr;
        for (var i = 0; i < buttonTextArr.length; i++) {
                buttonTextArr[i] = $g(buttonTextArr[i]);
        }
        var selectedText = $g(_options.selectedText);
        if (buttonTextArr.length != 2) {
            alert('buttonTextArr长度应为2!!!');
            return;
        }
        if (selectedText == '') {
            alert('selectedText为空!!!');
            return;
        }
        var selectedIndex = selectedText;
        if (isNaN(parseInt(selectedText))) {
            selectedIndex = buttonTextArr.indexOf(selectedText);
        }
        if (isNaN(parseInt(selectedIndex))) {
            selectedIndex = 0;
        }
        selectedText = buttonTextArr[selectedIndex];
        var selectedCls = selectedIndex == 0 ? 'pha-toggle-btn' : 'pha-toggle-btn pha-toggle-expanded';
        var $thisLabel = $('#' + _id);
        $thisLabel.addClass(selectedCls);
        $thisLabel.text(selectedText);
        $thisLabel.attr('selectedIndex', selectedIndex);
        $thisLabel.on('click', function () {
            var oldText = $(this).text();
            var oldIndex = $(this).attr('selectedIndex');
            var newText = '';
            var newIndex = '';
            if (parseInt(oldIndex) == 0) {
                newIndex = 1;
                $(this).addClass('pha-toggle-expanded');
            } else {
                newIndex = 0;
                $(this).removeClass('pha-toggle-expanded');
            }
            newText = buttonTextArr[newIndex];
            $(this).text(newText);
            $(this).attr('selectedIndex', newIndex);
            _options.onClick && _options.onClick(oldText, newText);
        });
    },
    Warn: function (level, msg, code) {
        level = parseInt(level);
        if (level <= -100 && level >= -199) {
            PHA.Popover({
                msg: msg,
                type: 'alert'
            });
            return;
        }
        var msgType = 'warning';
        if (level <= -200 && level >= -299) {
            msgType = 'info';
        } else if (level <= -300 && level >= -399) {
            msgType = 'warning';
        } else if (level >= -1000) {
            msgType = 'error';
        }
        var msgArr = [];
        msgArr.push('<div>');
        msgArr.push(msg);
        if (code !== '') {
            msgArr.push('<a class="pha-alert-tool-exp"> ...详情</a>');
        }
        msgArr.push('</div>');
        if (code !== '') {
            msgArr.push('<div class="pha-alert-code">');
            msgArr.push('   <div>错误代码: ' + level + '</div>');
            msgArr.push('   <div style="border-top:1px solid #ccc;margin-top:5px"></div>');
            msgArr.push('   <div style="padding:5px">' + code + '</div>');
            msgArr.push('</div>');
        }
        $.messager.alert('提示', msgArr.join(''), msgType);
        if (code !== '') {
            $('.pha-alert-tool-exp').hover(function () {
                $(this).css({
                    cursor: 'pointer'
                });
            });
            $('.pha-alert-tool-exp').click(function () {
                $('.pha-alert-code,.pha-alert-tool-exp').toggle();
            });
        }
    },
    /**
     * 绑定grid内图标或者按钮事件
     * @param {string} id 表格Id
     * @param {string} eventType 事件名称, click mousemove等对应on事件的
     * @param {array} classArr 表格内图标或按钮的class名称,通过此属性识别
     * @param {function} callBack 回调, 返回行号 行数据 对应class名称
     */
    GridEvent: function (gridID, eventType, classArr, callBack, callBack2) {
        eventType = eventType || 'click';
        $('#' + gridID)
        .parent()
        .find('.datagrid-body-inner, .datagrid-body')
        .on(eventType, function () {
            var $target = $(event.target);
            var className = $target.attr('class');
            if (classArr.indexOf(className) >= 0) {
                var rowIndex = $target.closest('tr[datagrid-row-index]').attr('datagrid-row-index');
                if (rowIndex) {
                    var rowData = $('#' + gridID).datagrid('getRows')[rowIndex];
                    if ($('#' + gridID).datagrid('options').view.type === 'scrollview') {
                        rowData = $('#' + gridID).datagrid('getData').firstRows[rowIndex];
                    }
                    callBack(rowIndex, rowData, className);
                }
            }
            else {
                var rowIndex = $target.closest('tr[datagrid-row-index]').attr('datagrid-row-index');
                if (rowIndex && callBack2) {
                    callBack2();
                } 
            }
        });
    },
    /**
     * 对combobox的赋制处理, 弥补DoVal中combobox赋值的缺点: (1)异步数据存在无法赋值的情况;(2)多选下拉无法赋值.
     * Huxt 2021-07-30
     * @param {string}  id 页面中hisui-combox的Id
     * @param {array}   valArr 值数组
     * @param {boolean} isReload 是否先刷新再赋值
     * 调用示例:
     *  PHA.SetComboVal('id', [{RowId:v1,Description:d1}, {RowId:v1,Description:d2}]);
     *  PHA.SetComboVal('id', {RowId:v1,Description:d1});
     *  PHA.SetComboVal('id', [v1, v2]);
     *  PHA.SetComboVal('id', v1);
     */
    SetComboVal: function (id, valArr, isReload) {
        var valArrType = Object.prototype.toString.call(valArr);
        if (valArrType == '[object Undefined]' || valArrType == '[object Null]') {
            return;
        }
        if (valArrType == '[object Object]') {
            valArr = [valArr];
        } else if (valArrType == '[object Number]') {
            valArr = '' + valArr;
        }
        if (valArr == '' || valArr.length == 0) {
            valArr = [];
        } else {
            valArr = valArrType == '[object String]' ? valArr.split(',') : valArr;
        }
        var $comb = id.substr(0, 1) == '#' ? $(id) : $('#' + id);
        if (isReload == true) {
            $comb.combobox('clear');
            $comb.combobox('reload');
        }
        var combOpts = $comb.combobox('options');
        var valueField = combOpts.valueField || combOpts.idField || 'id';
        var textField = combOpts.textField || 'text';
        var setValObj = null;
        var setValArr = [];
        for (var i = 0; i < valArr.length; i++) {
            var iValData = valArr[i];
            var iVal = '';
            var iTxt = '';
            if (typeof iValData == 'object') {
                iVal = iValData[valueField];
                iTxt = iValData[textField];
                iVal = typeof iVal == 'undefined' ? '' : iVal;
                iTxt = typeof iTxt == 'undefined' ? '' : iTxt;
            } else {
                iVal = iValData;
            }
            iVal = '' + iVal;
            if (iVal == '') {
                continue;
            }
            setValArr.push(iVal);
            if (iTxt != '') {
                setValObj = setValObj == null ? {}
                 : setValObj;
                setValObj[iVal] = iValData;
            }
        }
        if (combOpts._comb_task_opts && combOpts._comb_task_opts.isStart == true) {
            combOpts._comb_task_opts.valQueue.push({
                valArr: setValArr,
                valObj: setValObj
            });
            return;
        }
        combOpts._comb_task_opts = {
            valQueue: [{
                    valArr: setValArr,
                    valObj: setValObj
                }
            ],
            isStart: true,
            runTime: 0,
            runId: null
        };
        function _comb_task(_combOpts, _valQueue) {
            var _taskOpts = _combOpts._comb_task_opts;
            _taskOpts.runTime = 0;
            _taskOpts.runId = setInterval(function () {
                // console.log('id: ' + id + ', time: ' + _taskOpts.runTime);
                _taskOpts.runTime = _taskOpts.runTime + 1;
                if (_taskOpts.runTime > 300) {
                    clearInterval(_taskOpts.runId); // 超过30秒
                    _taskOpts.isStart = false;
                    if (_taskOpts.valQueue && _taskOpts.valQueue.length > 0) {
                        var _vQueue = _taskOpts.valQueue.shift();
                        _comb_task(_combOpts, _vQueue);
                    }
                    return;
                }
                var comboData = $comb.combobox('getData');
                if (comboData && comboData.length > 0) {
                    clearInterval(_taskOpts.runId); // 数据加载完成
                    var valArr = _valQueue.valArr;
                    var valObj = _valQueue.valObj;
                    var setVals = [];
                    for (var r = 0; r < comboData.length; r++) {
                        var rData = comboData[r];
                        var setVal = rData[valueField];
                        setVal = typeof setVal == 'undefined' ? rData['RowId'] : setVal;
                        var tSetVal = '' + setVal;
                        if (valArr.indexOf(tSetVal) >= 0) {
                            setVals.push(setVal);
                        }
                    }
                    if (valObj != null) {
                        var isDataChange = false;
                        for (var r = 0; r < valArr.length; r++) {
                            var iVal = valArr[r];
                            if (setVals.indexOf(iVal) >= 0) {
                                continue;
                            }
                            comboData.push(valObj[iVal]);
                            setVals.push(iVal);
                            isDataChange = true;
                        }
                        if (isDataChange == true) {
                            $comb.combobox('loadData', comboData);
                        }
                    }
                    if (setVals.length > 0) {
                        $comb.combobox('setValues', setVals);
                    } else {
                        $comb.combobox('clear');
                    }
                    _taskOpts.isStart = false;
                }
                if (_taskOpts.valQueue && _taskOpts.valQueue.length > 0) {
                    var _vQueue = _taskOpts.valQueue.shift();
                    _comb_task(_combOpts, _vQueue);
                }
            }, 100);
        }
        var _valQueue = combOpts._comb_task_opts.valQueue.shift();
        _comb_task(combOpts, _valQueue);
    },
    CM: function () {
        var args = arguments;
        args[0].pClassName = args[0].pClassName;
        args[0].pMethodName = args[0].pMethodName;
        args[0].ClassName = 'PHA.COM.Broker';
        args[0].MethodName = 'Invoke';
        for (var key in args[0]) {
            if (typeof args[0][key] === 'string') {
                if (args[0][key].indexOf('^') >= 0) {
                    PHA.Alert('系统提示', '系统不支持特殊符号 “^”', 'error')
                    PHA.Loading('Hide');
                    return false;
                }
            }
        }
        return $.cm.apply(this, args);
    },
    $URL: $URL + '?ClassName=PHA.COM.Broker&MethodName=Invoke',
    // 表格编辑器与字段对照关系
    setEditorField: function (gridID, cols, frozenCols) {
        if (cols && cols[0]) {
            for (var i = 0; i < cols[0].length; i++) {
                _doSet(gridID, cols[0][i]);
            }
        }
        if (frozenCols && frozenCols[0]) {
            for (var i = 0; i < frozenCols[0].length; i++) {
                _doSet(gridID, frozenCols[0][i]);
            }
        }
        function _doSet(gridID, iCol) {
            if (iCol.editor && iCol.editor.options) {
                iCol.editor.options.gridID = gridID;
                iCol.editor.options.field = iCol.field;
                iCol.editor.options.descField = iCol.descField;
            }
        }
    },
    // 统一处理后台返回值 (json串,json对象,前缀+描述等多种格式都支持)
    Ret: function (retJson) {
        if (typeof retJson == 'string') {
            try {
                retJson = JSON.parse(retJson);
            } catch (e) {
                if (typeof retJson == 'number') {
                    return showNumRet(retJson);
                } else {
                    return showStrRet(retJson)
                }
            }
        }
        if (typeof retJson == 'number') {
            return showNumRet(retJson);
        }
        if (retJson.code < 0) {
            /* 去掉前端的负数值 */
            var msgArr = retJson.msg.split("^")
                if ((msgArr.length > 1) && (parseInt(msgArr[0]) < 0)) {
                    msgArr.shift();
                    retJson.msg = msgArr.join("^")
                }
                PHA.Warn(retJson.code, retJson.msg, retJson.data);
            return false;
        }
        showSuccess(retJson.msg);
        return true;

        function showStrRet(retStr) {
            var retArr = retStr.split('^');
            if (retArr[0] >= 0) {
                return showSuccess(retArr[1]);
            } else {
                PHA.Warn(retArr[0], retArr[1], retStr);
                return false;
            }
        }
        function showNumRet(retNum) {
            if (retNum >= 0) {
                return showSuccess('success');
            } else {
                PHA.Warn(retNum, retNum, retNum);
                return false;
            }
        }
        function showSuccess(msg) {
            if (typeof msg == 'undefined' || msg == null || msg == '') {
                return true;
            }
            PHA.Popover({
                msg: msg,
                type: 'success'
            });
            return true;
        }
    },
    /**
     * 处理dom元素的data-pha属性值, data-pha的值为字符串, 本函数通过json的形式处理
     */
    DataPha: {
        /**
         * 取值
         * @param {*} domID
         * @param {*} field
         * @returns
         * @example PHA.DataPha.Get('loc', 'required')
         */
        Get: function (domID, field) {
            field = field || '';
            var dataphaOrigStr = $('#' + domID).attr('data-pha') || '';
            var dataphaOrigObj = new Function('return ' + '{' + dataphaOrigStr + '}')();
            return field === '' ? dataphaOrigObj : dataphaOrigObj[field];
        },
        /**
         * 给值
         * @param {*} domID
         * @param {*} options
         * @example PHA.DataPha.Set('loc', {'required': true})
         */
        Set: function (domID, options) {
            var $_dom = $('#' + domID);
            var dataphaOrigStr = $_dom.attr('data-pha') || '';
            var dataphaOrigObj = new Function('return ' + '{' + dataphaOrigStr + '}')();
            $.extend(dataphaOrigObj, options);
            var dataphaStr = JSON.stringify(dataphaOrigObj);
            $_dom.attr('data-pha', dataphaStr.substring(1, dataphaStr.length - 1));
        }
    },
    /**
     * 根据标签定义, 追加必填*符号
     * @param {*} $_dom
     * @example csp可参考 pha.in.v3.po.create.csp
     *          PHA.SetRequired($('#qCondition [data-pha]'));
     */
    SetRequired: function ($_dom) {
        $.each($_dom, function (index, element) {
            var domID = element.id;
            var datapha = $(element).attr('data-pha') || '';
            if (datapha) {
                var dataphaOptions = new Function('return ' + '{' + datapha + '}')();
                var required = dataphaOptions.required === true ? true : false;
                if (required === true) {
                    if ($('label[for = ' + domID + ']').children('.pha-field-required').length === 0) {
                        $('label[for = ' + domID + ']').prepend('<span class="pha-field-required">*</span>');
                    }
                } else if (required === false) {
                    $('label[for = ' + domID + ']').children('.pha-field-required').remove()
                }
            }
        });
    },
    /**
     * 将检测到的错误信息提示到grid中, 单元格背景色+tooltip
     * @param {string}  target          表格ID, #gridItm
     * @param {object}  options
     * @param {array}   options.rows    数据行
     * @param {boolean} options.tooltip true|false, true时将提示信息绑定到目标上
     * @example AppendWarn2Grid('#gridItm', {tooltip:true,rows:[{ type: 'alert', info: '数量: 多少不对了', index: 1, field: 'vendorDesc' }]})
     *  { type: '', info: '', index: '', field: '' }
     *      field+index 按单元格
     *      index 按行
     */

    AppendWarn2Grid: function (target, options) {
        if (PHA.Warn2Grid) {
            PHA.Warn2Grid(target, options)
            return
        }
        alert('请使用 WarnGrid, 注意入参变化')
        return
        var $target = $(target).parent();
        var rows = options.rows;
        var rowMsgs = {};
        var field;
        var fieldDesc;
        var index;
        var id;
        var info;
        var rowKey;
        // 抽取提醒信息到每一行合并
        for (var j = 0, jLen = rows.length; j < jLen; j++) {
            iterator = rows[j]
                field = iterator.field;
            index = iterator.index;
            id = iterator.id;
            info = iterator.info;
            fieldDesc = iterator.fieldDesc
                rowKey = 'index-' + index
                if (rowMsgs[rowKey] === undefined) {
                    rowMsgs[rowKey] = []
                }
                // fieldDesc不能为空
                rowMsgs[rowKey].push(fieldDesc + ": " + info)
        }
        // 绑定popover
        for (var i = 0, len = rows.length; i < len; i++) {
            iterator = rows[i]
                field = iterator.field;
            index = iterator.index;
            id = iterator.id;
            info = iterator.info;
            var $cell;
            if (id) {
                $cell = $('[for="' + id + '"]');
                $cell.addClass('pha-validate-label');
                $cell.tooltip({
                    content: iterator.info
                });
            } else if (field) {
                // 如果有field, 则代表是单元格
                $cell = $target.find('.datagrid-body [datagrid-row-index=' + index + '] td[field="' + field + '"]');
                $cell.addClass('pha-datagrid-validate-col');
                $cell
                .tooltip({
                    content: rowMsgs['index-' + index].join(', '),
                    position: 'top'
                })
                .show();
                //$cell.append('<div style="position:relative"><div class="pha-datagrid-validate-left-bottom">1</div></div>')
            } else {
                // 没有field, 有index则代表单元格
                $cell = $target.find('.datagrid-body [datagrid-row-index=' + index + ']');
                $cell.addClass('pha-datagrid-validate-row');
            }
            if (tip === true) {
                $cell
                .tooltip({
                    content: iterator.info,
                    position: 'top'
                })
                .show();
            }
        }
        // 不将提醒绑定到每一个单元格, 如果多个还得一一查看, 第一列绑定即可
    },
    /**
     * 结合AppendWArnGrid, 此方法为将信息展示到窗口
     * @param {object} options
     * @param {object} options.warn 对应后台验证的原始数据
     * {type:'string',rows:[{rowIndex:0,rowMsgs:[]}]}
     *
     */
    ShowWarn: function (options) {
        // var warnInfo = {
        //     type: 'terminate',
        //     rows: [
        //         {
        //             rowIndex: 1,
        //             rowMsgs: [
        //                 {
        //                     type: '',
        //                     info: '退货数量: 不能为小数"',
        //                     index: 2,
        //                     field: 'qty'
        //                 },
        //                 {
        //                     type: '',
        //                     info: '进价: 不能小于0 & 不能为空"',
        //                     index: 2,
        //                     field: 'qty'
        //                 }
        //             ]
        //         }
        //     ]
        // };
        try {
            var warnInfo = options.warnInfo || {};
            if (warnInfo === false) {
                return
            }
            console.log(warnInfo)
            var maxLen = 5; // 就显示五条
            var cntLen;
            var msgHtmlArr = [];
            var rows = warnInfo.rows || [];
            for (var i = 0, len = rows.length; i < len; i++) {
                var warnRow = rows[i]
                    cntLen = (cntLen === undefined) ? 0 : cntLen + 1;
                if (cntLen >= maxLen) {
                    break;
                }
                var msgRowHtmlArr = [];
                var rowIndex = warnRow.rowIndex;
                var rowMsgs = warnRow.rowMsgs;
                for (var j = 0, jLen = rowMsgs.length; j < jLen; j++) {
                    var rowMsg = rowMsgs[j]
                        var fieldDesc = rowMsg.fieldDesc || '';
                    if (fieldDesc !== '') {
                        msgRowHtmlArr.push("“" + fieldDesc + "”" + " " + rowMsg.info);
                    } else {
                        msgRowHtmlArr.push(rowMsg.info);
                    }
                }
                // @todo 消息提示, 应构建规范格式
                if (len > 1) {
                    msgHtmlArr.push('<li><b>第' + rowIndex + '行</b> ' + msgRowHtmlArr.join(', ') + '</li>');
                } else {
                    msgHtmlArr.push('第' + rowIndex + '行 ' + msgRowHtmlArr.join('</br> '));
                }
            }

            if (warnInfo.type === 'pop') {
                //var firstRow = rows[0];
                var canShowFlag = true;
                var $popovers = $('.messager-popover');
                for (var i = 0, length = $popovers.length; i < length; i++) {
                    if ($($popovers[i]).css('display') === 'block') {
                        canShowFlag = false;
                        break;
                    }
                }
                if (canShowFlag === true) {
                    PHA.Popover({
                        type: 'alert',
                        msg: msgHtmlArr.join(''),
                        timeout: 1500,
                        closeable: true
                        // msg: '第' + firstRow.rowIndex + '行记录</b>: ' + firstRow.rowMsgs[0].info
                    })
                    // 光标移入, 代表用户需要查看, 此时更新为不会自动关闭的Pop, 光标离开则再直接关闭
                    $('.messager-popover').hover(
                        function (e) {
                        PHA.Popover({
                            type: 'alert',
                            showType: 'fade',
                            showSpeed: 0,
                            msg: $(e.target).find('.content').html(),
                            timeout: 0
                        });
                        $(e.target).fadeOut();
                        $('.messager-popover').hover(
                            function (e) {},
                            function (e) {
                            $(e.target).slideUp(300);
                        });
                    });
                }
            } else {
                if (msgHtmlArr.join('') !== '') {
                    PHA.Alert('温馨提示', msgHtmlArr.join(''), 'info');
                }
            }
        } catch (error) {
            PHA.Alert('系统错误', 'PHA.ShowWarn</br>' + error.message, 'error');
        }
    },
    BindBtnEvent: function (domID) {
        var domArr = [];
        $(domID + ' [data-pha-event]').each(function () {
            var _id = this.id;
            if (_id) {
                var dataphaEventStr = $('#' + _id).attr('data-pha-event') || '';
                if (dataphaEventStr == '') {
                    return _id + ': data-pha-event属性为空';
                }
                var eventArr = dataphaEventStr.split(':');
                if (eventArr.length == 2) {
                    PHA_EVENT.Bind('#' + _id, eventArr[0], function () {
                        window[eventArr[1]]();
                    });
                }
            }
        });
    }
};
/**
 * 将提醒信息集成到表格, 并集成到popover上, 目的是将有问题的数据全部展示, 而不是每次改一个弹一个
 * @param {*} target 表格ID
 * @param {*} options  结合后台验证的基础数据, 可直接参考采购计划制单的validatesave
 * @todo 如下的popover可再优化, 事件触发时给值, 但数据不多, 暂时未做
 */
PHA.Warn2Grid = function (target, options) {
    try {
        var $targetParent = $(target).parent();
        var warnInfo = options.warnInfo || {};
        if (warnInfo === false) {
            return
        }
        var maxLen = 10; // 最多处理行数
        var rows = warnInfo.rows || '';
        var firstRowIndex;
        for (var i = 0, iLen = rows.length; i < iLen; i++) {
            var row = rows[i];
            var rowIndex = row.rowIndex;
            if (i >= maxLen) {
                break;
            }
            var rowMsgs = row.rowMsgs;
            var rowMsgArr = MergeRowMsg(rowMsgs);
            var rowMsgStr = rowMsgArr.join('</br>'); // 集成一行数据提醒
            var rowMsgTableHtml = Merge2Table4Display(rowMsgs);
            var warnType;
            warnType = 'row'; // 按行
            warnType = 'col'; // 按列
            // 只有按列时才要求按列绑定
            for (var j = 0, jLen = rowMsgs.length; j < jLen; j++) {
                var rowMsgsRow = rowMsgs[j];
                var field = rowMsgsRow.field;
                var index = rowMsgsRow.index;
                var $cell = $targetParent.find('.datagrid-body [datagrid-row-index=' + index + '] td[field="' + field + '"]');
                $cell.addClass('pha-datagrid-validate-col');
                var content = rowMsgsRow.info;
                if (rowMsgArr.length > 1) {
                    content = rowMsgTableHtml + '<div style="margin-top:5px;padding:5px;border-top:1px dashed #fff;text-align:center">' + rowMsgsRow.info + '</div>';
                }
                $cell.tooltip({
                    content: content,
                    position: 'top'
                });
                if (firstRowIndex === undefined) {
                    firstRowIndex = index;
                }
            }
            // 整行全显示
            $targetParent.find('.datagrid-body [datagrid-row-index] .tooltip-f').tooltip('hide');
            // 默认不弹显示, 比较难受
            // if (firstRowIndex) {
            //      $($targetParent.find('.datagrid-body [datagrid-row-index=' + firstRowIndex + '] .tooltip-f')[0]).tooltip('show');
            // }
        }
    } catch (error) {
        PHA.Alert('系统错误', 'PHA.Warn2Grid</br>' + error.message, 'error');
    }
    function GetWarnType() {
        // 按行还是按列改变单元格北京
    }
    function Merge2Table4Display(rows) {
        var retArr = [];
        for (var i = 0, length = rows.length; i < length; i++) {
            var row = rows[i];
            var info = row.info;
            var fieldDesc = row.fieldDesc;
            if (fieldDesc !== '') {
                retArr.push('<tr><td style="text-align:right;">' + fieldDesc + '</td><td>：</td><td>' + info + '</td></tr>');
            }
        }
        return '<div><table style="color:#fff;">' + retArr.join('') + '</table></div>';
    }
    //
    function MergeRowMsg(rows) {
        var retArr = [];
        for (var i = 0, length = rows.length; i < length; i++) {
            var row = rows[i];
            var info = row.info;
            var fieldDesc = row.fieldDesc;
            if (fieldDesc !== '') {
                retArr.push('<div style="width:8rem;float:left;">' + fieldDesc + ': </div><div style="float:left">' + info + '</div>');
            }
        }
        return retArr;
    }
};
/**
 * 针对业务操作提醒, 设计填写备注的, 建议用此
 * 入参为对象可以兼容下内容格式
 * @param {*} options
 */
PHA.BizPrompt = function (options, callback) {
    var btnText = $(window.event.target).text();
    var btnText = $(window.event.target).parent().find('.l-btn-text').text();
    if (btnText == ""){
        btnText = $(window.event.target).attr("title");
    }
    var defOptions = {
        title: '操作提醒',
        content: '<div style="line-height:28px"><div>正在操作<span style="font-weight:bold;color:#ee4f38;">【' + btnText + '】</span> </div><div>您可以录入一些简要信息</div></div>'
    };
    if (options.info) {
        defOptions.content = defOptions.content + '<div style="line-height:28px">' + options.info + '</div>'
    }
    $.messager.prompt(defOptions.title, defOptions.content, function (r) {
        if (callback) {
            callback(r);
        }
    });
    $('.messager-input').addClass('textbox');
    setTimeout(function () {
        $($('.messager-button a')[0]).focus()
    }, 0)
};
/**
 * 本地分页
 * scrollview 时不需要调用, 有冲突, 且scrollview内部有对应分页机制
 * @param {*} options
 */
PHA.LocalFilter = function (data) {
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
    var pageNumber = opts.pageNumber;
    if (pageNumber === 0) {
        pageNumber = 1;
    }
    var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
    var end = start + parseInt(opts.pageSize);
    data.rows = data.originalRows.slice(start, end);
    return data;
}
PHA.PageCheckHandler = function ($grid, checkFlag) {
    if ($grid.datagrid('options').checking == true) {
        return;
    }
    var opts = $grid.datagrid('getPager').pagination('options');
    var start = (opts.pageNumber - 1) * parseInt(opts.pageSize);
    var end = start + parseInt(opts.pageSize);
    PHA.LocalCheckPage($grid, checkFlag, start, end);
}
PHA.LocalCheckPage = function ($grid, checkFlag, start, end) {
    var origRows = $grid.datagrid('getData').originalRows;
    if (origRows) {
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
    }
}
PHA.DataAlert = function (msgJson, msgType) {
    msgType = msgType || 'warning';
    var msgHtmlArr = [];
    var messageArr = msgJson.message || [];
    for (var i = 0, length = messageArr.length; i < length; i++) {
        if (i === 5) {
            break;
        }
        var messageData = messageArr[i];
        var msg = '';
        if (typeof messageData === 'object') {
            msg = messageData.msg;
        } else {
            msg = messageData;
        }
        msg = msg.replace(/-\d*\^/g, '');
        msgHtmlArr.push('        <li style="padding-left:13px;padding-top:5px;">' + msg + '</li>');
    }
    var msg = '';
    msg += '<div style="line-height:32px">';
    msg += '    <span style="color:#757575;font-weight:bold">总记录:' + msgJson.totalCnt + '</span>';
    msg += '    <span style="padding-left:10px;color:#00B69C;font-weight:bold">成功:' + msgJson.successCnt + '</span>';
    msg += '    <span style="padding-left:10px;color:#FFA804;font-weight:bold">失败:' + msgJson.failureCnt + '</span>';
    msg += '</div>';
    msg += '<div style="border-top:1px solid #cccccc;margin-left:-40px;margin-top:10px"></div>';
    msg += '<div style="color:#757575;padding-top:10px;margin-left:-13px">';
    msg += '    <ul style="list-style-type:disc;">';
    msg += msgHtmlArr.join('');
    msg += '    </ul>';
    msg += '</div>';
    PHA.Alert('提示', msg, msgType);
}
PHA.HelpWindow = function (options) {
    options = options || {};
    var _options = $.extend({}, options);
    var winID = 'PHA_HelpWindow_' + parseInt(Math.random(100000) * 100000);
    var winHtmlArr = [];
    winHtmlArr.push('<div id="' + winID + '" style=""">');
    if (_options.info) {
        winHtmlArr.push('<div  style="line-height:28px;padding:10px;">' + _options.info + '</div>');
    }
    winHtmlArr.push('</div>');
    $('body').append(winHtmlArr.join(''));
    // _options.content = '<div style="line-height:28px;padding:10px;">' +  _options.content + '</div>';
    _options.info = '';
    var defaultOptions = {
        title: '帮助信息',
        iconCls: 'icon-w-paper',
        collapsible: false,
        border: false,
        closed: true,
        modal: true,
        maximizable: false,
        collapsible: false,
        minimizable: false,
        resizable: false,
        closable: true,
        // width: 600,
        // height: 400,
        onClose: function () {
            $(this).window('destroy');
        }
    }
    $('#' + winID).window($.extend(defaultOptions, _options)).window('open');
}
PHA.Loading('PageShow');
// 翻译方法
if (typeof $g == 'undefined') {
    var $g = function (v) {
        return v;
    };
}
