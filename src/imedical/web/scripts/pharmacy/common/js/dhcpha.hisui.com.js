/**
 * creator:		yunhaibao
 * createdate:	2018-05-22
 * description:	药房对应HISUI的一些插件,作为初始化使用
 */
var DHCPHA_HUI_COM = ({
    ComboBox: {
        //  _cOptions: 扩充内容
        //  _options : easyui 属性
        //  _ app:     产品表(PIVAS)
        Init: function (_cOptions, _options, _app) {
            if (_options.width == undefined) {
                _options.width = 154
            }
            var _id = _cOptions.Id;
            var _queryOpts;
            var _url = "";
            if (_cOptions.data != undefined) {
                _queryOpts = _cOptions.data;
            } else {
                if (_app == "PIVAS") {
                    _queryOpts = PIVAS.ComboBox[_cOptions.Type];
                } else if (_app == "DHCST") {
                    _queryOpts = DHCST.ComboBox[_cOptions.Type];
                }else if (_app == "DHCPHA") {
                    _queryOpts = DHCPHA.ComboBox[_cOptions.Type];
                } else {
                    _queryOpts = DHCPHA_STORE.ComboBox[_cOptions.Type];
                }
                if (_queryOpts.data) {
                    _url = "";
                } else {
                    for (var _qField in _queryOpts) {
                        var _qValue = _queryOpts[_qField];
                        _url += "&" + _qField + "=" + _qValue;
                    }
                }
            }
            var _options = $.extend({}, _options, _queryOpts);
            var _newOptions = $.extend({}, this.Default, _options);
            if (_newOptions.data) {
                _newOptions.url = "";
            } else if (_url != "") {
                _newOptions.url = this.Default.url + _url;
            }
            $HUI.combobox("#" + _id, _newOptions);
            if (_options.placeholder != undefined) {
                $('#' + _id).next().find(".combo-text").attr("placeholder", _options.placeholder);
            }
        },
        Default: {
            valueField: 'RowId',
            textField: 'Description',
            width: 'auto',
            url: "DHCST.QUERY.BROKER.csp?DataType=Array",
            mode: "remote",
            onBeforeLoad: function (param) {
                param.filterText = param.q;
				if (typeof HospId!=='undefined'){
					param.hosp=HospId;
				}
            },
            onHidePanel: function () {
                var valueField = $(this).combobox("options").valueField;
                var val = $(this).combobox("getValue");
                var allData = $(this).combobox("getData");
                var result = true;
                for (var i = 0; i < allData.length; i++) {
                    if (val == allData[i][valueField]) {
                        result = false;
                        break;
                    }
                }
                if (result) {
                    $(this).combobox("clear");
                }
            }
        }
    },
    // 下拉表格
    ComboGrid: {
        Init: function (_cOptions, _options, _app) {
            if (_options.width == undefined) {
                _options.width = 154;
            }
            var _id = _cOptions.Id;
            var _queryOpts;
            if (_app == "PIVAS") {
                _queryOpts = PIVAS.ComboGrid[_cOptions.Type];
            }else if (_app == "DHCST") {
                _queryOpts = DHCST.ComboGrid[_cOptions.Type];
            } else {
                _queryOpts = _options;
            }
            var _url = "";
            var _queryParamsOpts = _queryOpts.QueryParams;
            for (var _qField in _queryParamsOpts) {
                var _qValue = _queryParamsOpts[_qField];
                _url += "&" + _qField + "=" + _qValue;
            }
            var _newOptions = $.extend({}, _options, _queryOpts);
            _newOptions.url = this.Default.url + _url;
            $HUI.combogrid("#" + _id, $.extend(this.Default, _newOptions));
            if (_options.placeholder != undefined) {
                $('#' + _id).next().find(".combo-text").attr("placeholder", _options.placeholder);
            }
        },
        Default: {
            panelWidth: 500,
            idField: 'RowId',
            textField: 'Description',
            loadMsg: '正在加载...',
            fitColumns: true,
            mode: 'remote',
            url: $URL + "?",
            onBeforeLoad: function (param) {
                param.filterText = param.q;
            }
        }
    },
    Date: {
        // _options: 对应hisui options
        // _iOptions:对应组内使用options
        Init: function (_options, _iOptions) {

        }
    },
    Time: {
        Init: {

        }
    },
    Grid: {
        // _gridId: 表格Id
        Init: function (_gridId, _options) {
            var newOptions = $.extend({}, this.Default, _options);
            $HUI.datagrid("#" + _gridId, newOptions);
        },
        Default: {
            fit: true,
            border: false,
            singleSelect: true,
            loadMsg: '正在加载信息...',
            pageSize: 30, // 每页显示的记录条数
            pageList: [30, 50, 100, 300, 500], // 可以设置每页记录条数的列表
            pagination: true,
            pageNumber: 0,
            onEndEdit: function (rowIndex, rowData) {
                var editors = $(this).datagrid('getEditors', rowIndex);
                for (var ei = 0; ei < editors.length; ei++) {
                    var iEditor = editors[ei];
                    var iType = iEditor.type;
                    if (iType.indexOf("combo") >= 0) {
                        var descField = $(this).datagrid("getColumnOption", iEditor.field).descField;
                        if (descField) {
                            rowData[descField] = $(iEditor.target).combobox('getText');
                        }
                    }
                }
            },
            onRowContextMenu: function (e, rowIndex, rowData) {
                if ($(this).datagrid("options").exportXls == true) {
                    // 右键
                    var gridId = this.id;
                    e.preventDefault(); //阻止向上冒泡
                    if ($("#menuCommon").length > 0) {
                        $("#menuCommon").remove();
                    }
                    var menuHtml =
                        '<div id="menuCommon" class="hisui-menu" style="display: none;">' +
                        '<div id="menuCommonExport" data-options="' + "iconCls:'icon-export'" + '">导出</div>' +
                        '</div>'
                    $("body").append(menuHtml);
                    $('#menuCommon').menu()
                    $('#menuCommon').menu('show', {
                        left: e.pageX,
                        top: e.pageY
                    });
                    $("#menuCommonExport").on("click", function () {
                        HUIExportToExcel(gridId);
                    })
                }
            },
            onLoadError: function (response) {
                var resText = response.responseText;
                $.messager.alert('提示', resText, 'error');
            }
        },
        // 关联勾选(比如:关联医嘱)
        LinkCheck: {
            Stat: "",
            Init: function (_options) {
                //_options.CurRowIndex:当前行
                //_options.GridId:表格Id
                //_options.Field: 列的Field值
                //_options.Check: true勾选,false不勾选
                //_options.Value: 键值
                //_options.Type:(Select-选择行,Check-勾选)
                if (this.Stat == "") {
                    this.Stat = 1;
                    var gridId = _options.GridId;
                    var field = _options.Field;
                    var check = _options.Check;
                    var value = _options.Value;
                    var type = _options.Type;
                    if (type == "Select") {
                        // 清除所有选中
                        $('#' + gridId).datagrid("unselectAll");
                    }
                    var gridRowsData = $('#' + gridId).datagrid("getRows");
                    var gridRowsCount = gridRowsData.length;
                    // 向下
                    var i = _options.CurRowIndex;
                    for (i = _options.CurRowIndex; i < gridRowsCount; i++) {
                        var iColValue = gridRowsData[i][field];
                        if (iColValue == value) {
                            if (type == "Select") {
                                $('#' + gridId).datagrid("selectRow", i);
                            } else {
                                $('#' + gridId).datagrid((check == true) ? "checkRow" : "uncheckRow", i);
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
                            if (type == "Select") {
                                $('#' + gridId).datagrid("selectRow", i);
                            } else {
                                $('#' + gridId).datagrid((check == true) ? "checkRow" : "uncheckRow", i);
                            }
                        } else {
                            break;
                        }
                    }
                    this.Stat = "";
                }
            }
        },
        // 合并单元格
        //_options.GridId:      表格Id
        //_options.MergeFields: 需合并的数组 []
        //_options.Field:      参考值(此值相同合并)
        MergeCell: function (_options) {
            var gridId = _options.GridId;
            var $_grid = $('#' + gridId);
            var field = _options.Field;
            var mergeFields = _options.MergeFields;
            var mergeFieldsLen = mergeFields.length;
            var gridRowsLen = $_grid.datagrid("getRows").length;
            if (gridRowsLen < 1) {
                return;
            }
            var startRow = 0;
            var rowSpan = 1;
            var lastFieldVal = "";
            for (var i = 0; i < gridRowsLen; i++) {
                var rowData = $_grid.datagrid("getRows")[i];
                var fieldVal = rowData[field];
                if (fieldVal != lastFieldVal) {
                    startRow = i;
                    rowSpan = 1;
                } else {
                    rowSpan++;
                }
                lastFieldVal = fieldVal;
                for (var j = 0; j < mergeFieldsLen; j++) {
                    $_grid.datagrid("mergeCells", {
                        index: startRow,
                        field: mergeFields[j],
                        rowspan: rowSpan,
                        colspan: null
                    })
                }
            }
        },
        // Grid-不用
        Formatter: {
            ComboBox: function (combo, valueField, textField) {
                return function (value, row, index) {
                    return row[textField];
                    if (value == null || value == "") {
                        return '';
                    }
                    try {
                        // 首次加载,不循环
                        if (value == row[valueField]) {
                            var textData = row[textField] || "";
                            if (textData != "")
                                return row[textField];
                        }
                        // 在这循环格式化不好
                        for (var i = 0; i < combo.options.data.length; i++) {
                            if (combo.options.data[i].RowId == value) {
                                return combo.options.data[i].Description;
                            }
                        }
                    } catch (e) {}
                }
            },
            OeoriSign: function (value, row, index) {
                if ((value == "│") || (value == "0")) {
                    return '<div class="oeori-sign-c"></div>';
                } else if ((value == "┍") || (value == "-1")) {
                    return '<div class="oeori-sign-t"></div>';
                } else if ((value == "┕") || (value == "1")) {
                    return '<div class="oeori-sign-b"></div>';
                } else {
                    return value;
                }
            }
        },
        /// grid单元格划过提示,以后封装
        CellTip: function (_options) {
            //_options.TipArr:需要提示的列id,数组
            //_options.ClassName:需要调取后台的类(不常用,可优化)
            //_options.MethodName:需要调取后台的方法
            //_options.TdField:需要获取前台某列的单元格值的field
            if ($("#tipRemark").length < 1) {
                var html = '<div id="tipRemark" style="border-radius:3px; display:none; border:1px solid #017BCE; padding:10px;position: absolute; background-color: white;color:black;"></div>';
                $('body').append(html);
            }
            var findConds = ".datagrid-btable ";
            var tipsArr = _options.TipArr;
            var arrLen = tipsArr.length;
            var tdConds = "";
            for (var i = 0; i < arrLen; i++) {
                tdConds = (tdConds == "") ? "td[field='" + tipsArr[i] + "']" : tdConds + "," + "td[field='" + tipsArr[i] + "']";
            }
            findConds = findConds + tdConds;
            $(findConds).each(function () {
                if (this.textContent != "") {
                    $(this).on({
                        'mouseover': function () {
                            // 不用mousemove,如掉后台频繁访问服务器
                            var tipInfo = this.textContent;
                            if (_options.ClassName) {
                                var inputStr = $(this).parent().find("td[field=" + _options.TdField + "]").text()
                                tipInfo = tkMakeServerCall(_options.ClassName, _options.MethodName, inputStr)
                            } else if (_options.TdField) {
                                tipInfo = $(this).parent().find("td[field=" + _options.TdField + "]").text()
                            }
                            var tleft = (event.clientX + 20);
                            $("#tipRemark").css({
                                display: 'block',
                                bottom: (document.body.clientHeight - event.clientY) + 'px',
                                left: tleft + 'px',
                                'z-index': 9999,
                                opacity: 1
                            }).html(tipInfo);
                        },
                        'mouseleave': function () {
                            $("#tipRemark").css({
                                display: 'none'
                            });
                        }
                    })
                }
            })
        }

    },
    // 表格内下拉
    GridComboBox: {
        Init: function (_cOptions, _options, _app) {
            var _queryOpts;
            if (_cOptions.data != undefined) {
                _queryOpts = _cOptions.data;
            } else {
                if (_app == "PIVAS") {
                    _queryOpts = PIVAS.ComboBox[_cOptions.Type];
                } else if (_app == "DHCST") {
                    _queryOpts = DHCST.ComboBox[_cOptions.Type];
                } else {
                    _queryOpts = DHCPHA_STORE.ComboBox[_cOptions.Type];
                }
            }
            var _url = "";
            if (_queryOpts.data) {
                var _data = _queryOpts.data;
                _options.data = _data;
            } else {
                if (_cOptions.QueryParams) {
                    $.extend(_queryOpts, _cOptions.QueryParams);
                }
                for (var _qField in _queryOpts) {
                    var _qValue = _queryOpts[_qField];
                    _url += "&" + _qField + "=" + _qValue;
                }
                _url = "DHCST.QUERY.BROKER.csp?DataType=Array" + _url;
                _options.url = _url;
                _options.mode = "remote";
            }

            var _defOptions = $.extend({}, this.Default.options, _options);
            var _cbOptions = $.extend({}, this.Default, {
                options: _defOptions
            });
            return _cbOptions;
        },
        Default: {
            type: 'combobox',
            options: {
                selectOnNavigation: false,
                valueField: 'RowId',
                textField: 'Description',
                onBeforeLoad: function (param) {
                    param.filterText = param.q;
                }
            }
        }
    },
    // 表格内下拉
    GridComboGrid: {
        Init: function (_cOptions, _options, _app) {
            var _queryOpts;
            if (_app == "PIVAS") {
                _queryOpts = PIVAS.ComboGrid[_cOptions.Type];
            } else if (_app == "DHCST") {
                _queryOpts = DHCST.ComboGrid[_cOptions.Type];
            } else {
                _queryOpts = DHCPHA_STORE.ComboGrid[_cOptions.Type];
            }
            if (_cOptions.QueryParams) {
                $.extend(_queryOpts.QueryParams, _cOptions.QueryParams)
            }
            var _url = "";
            var _qpOptions = _queryOpts.QueryParams;
            for (var _qField in _qpOptions) {
                var _qValue = _qpOptions[_qField];
                _url += "&" + _qField + "=" + _qValue;
            }
            _url = $URL + "?" + _url;
            _options.url = _url;
            $.extend(_options, _queryOpts)
            var _defOptions = $.extend({}, this.Default.options, _options);
            var _cbOptions = $.extend({}, this.Default, {
                options: _defOptions
            });
            return _cbOptions;
        },
        Default: {
            type: 'combogrid',
            options: {
                selectOnNavigation: false,
                loadMsg: '正在加载...',
                fitColumns: true,
                mode: 'remote',
                onBeforeLoad: function (param) {
                    param.filterText = param.q;
                }
            }
        }
    },
    // 提示
    Msg: {
        popover: function (_options) {
            var _defOpts = {
                timeout: 1500,
                showType: 'slide'
            }
            $.messager.popover($.extend({}, _defOpts, _options))
        }
    }
})