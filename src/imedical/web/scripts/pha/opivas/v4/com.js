/**
 * 名称:   门诊配液系统公用
 * 编写人:  yunhaibao
 * 编写日期: 2019-03-15~
 */
PHA_OPIVAS_COM = {
    Broker: 'pha.opivas.v4.broker.csp',
    Delim: '|:|',
    DelimField: '^',
    Bind: {
        KeyDown: {
            PatNo: function (_id, _callBack) {
                var $id = $('#' + _id);
                $id.on('keypress', function (event) {
                    if (event.keyCode == '13') {
                        var patNo = $id.val().trim();
                        if (patNo == '') {
                            return;
                        }
                        patNo = PHA_COM.FullPatNo(patNo);
                        $id.val(patNo);
                        if (_callBack) {
                            _callBack();
                        }
                    }
                });
            },
            Event: function (_id, _callBack) {
                var $id = $('#' + _id);
                $id.on('keypress', function (event) {
                    if (event.keyCode == '13') {
                        _callBack();
                    }
                });
            }
        }
    },

    Kill: function (_gridId, _clsName, _methName) {
        var pid = $('#' + _gridId).datagrid('options').queryParams.Pid || '';
        if (pid) {
            $.cm(
                {
                    ClassName: _clsName,
                    MethodName: _methName,
                    Pid: pid,
                    dataType: 'text'
                },
                false
            );
        }
    },
    DomData: function (_domId, _opts) {
        _needId = _opts.needId || '';
        if (_needId != 'Y') {
            return PHA.DomData(_domId, _opts);
        } else {
            _opts.retType = 'Json';
            var valsArr = PHA.DomData(_domId, _opts);
            var jsonData = valsArr[0] || '';
            if (jsonData == '') {
                return '';
            }
            var retArr = [];
            for (var id in jsonData) {
                retArr.push(id + this.DelimField + jsonData[id]);
            }
            return retArr.join(this.Delim);
        }
    },
    Grid: {
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
                    // 登记号空,颜色同上一行
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
        Formatter: {
            DspShow: function () {},
            OeoriSign: function (value, row, index) {
                if (value == '│' || value == '0') {
                    return '<div class="oeori-sign-c"></div>';
                } else if (value == '┍' || value == '-1') {
                    return '<div class="oeori-sign-t"></div>';
                } else if (value == '┕' || value == '1') {
                    return '<div class="oeori-sign-b"></div>';
                } else {
                    return value;
                }
            },
            // formatter内调
            OrderDetail: function (value, row, index, field) {
                return '<a class="editcls" onclick="PHA_UX.OrderDetail({}, {Oeori:\'' + row[field] + '\'} )">' + value + '</a>';
                //'<a class="editcls" onclick="ipdoc.patord.view.ordDetailInfoShow(\'' + rec.OrderId + '\')">'+value+'</a>'
            },
            // formatter内调
            AdmDetail: function (value, row, index, field) {
                return '<a class="editcls" onclick="PHA_UX.AdmDetail({modal:true}, {Oeori:\'' + row[field] + '\'} )">' + value + '</a>';
                //'<a class="editcls" onclick="ipdoc.patord.view.ordDetailInfoShow(\'' + rec.OrderId + '\')">'+value+'</a>'
            },
            PSDetail: function (value, row, index, field) {
                var pObj = {
                    Params: value,
                    Field: field,
                    ClickField: field
                };
                // var pObjStr=JSON.stringify(pObj);
                return '<a class="editcls" onclick="PIVASTIMELINE.Init({Params:\'' + value + "',Field:'" + field + "',ClickField:'" + field + '\'} )">' + value + '</a>'; //'<a class="editcls" onclick="ipdoc.patord.view.ordDetailInfoShow(\'' + rec.OrderId + '\')">'+value+'</a>'
            },
            YesNo: function (value, row, index) {
                if (value === 'Y') {
                    return $g('是');
                }
                if (value === 'N') {
                    return $g('否');
                }
                return value;
            }
        },
        Styler: {
            Pack: function (value, row, index) {
                if (value == 'Y') {
                    return 'background-color:#449be2;color:#fff';
                } else {
                    return '';
                }
            },
            Warn: function (value, row, index) {
                if (value != '') {
                    return 'background:#F4868E;color:white;';
                } else {
                    return '';
                }
            },
            // 配伍审核状态
            PassStatus: function (value, row, index) {
                if (value != '') {
                    if (value.indexOf('取消') >= 0) {
                        return ''; //绿色
                    } else if (value.indexOf('接受') >= 0) {
                        return ''; //亮黄
                    } else if (value.indexOf('申诉') >= 0) {
                        return { class: 'pha-pivas-state-appleal' };
                    } else if (value.indexOf('拒绝') >= 0) {
                        return { class: 'pha-pivas-state-refuse' };
                    } else if (value.indexOf('通过') >= 0) {
                        return { class: 'pha-pivas-state-pass' };
                    }
                } else {
                    return '';
                }
            },
            // 配液状态
            PS: PIVAS.Grid.Styler.PivaState
        },
        LinkCheck: {
            Stat: '',
            Do: function (_options) {
                //_options.CurRowIndex:当前行
                //_options.GridId:表格Id
                //_options.Field: 列的Field值
                //_options.Check: true勾选,false不勾选
                //_options.Value: 键值
                //_options.Type:(Select-选择行,Check-勾选)
                if (this.Stat == '') {
                    this.Stat = 1;
                    var gridId = _options.GridId;
                    var field = _options.Field;
                    var check = _options.Check;
                    var value = _options.Value;
                    var type = _options.Type;
                    if (type == 'Select') {
                        // 清除所有选中
                        $('#' + gridId).datagrid('unselectAll');
                    }
                    var gridRowsData = $('#' + gridId).datagrid('getRows');
                    var gridRowsCount = gridRowsData.length;
                    // 向下
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
                    // 向上
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
        }
    },
    Ajax: {
        Json: function (jsonUrl) {
            if (jsonUrl.indexOf('/') < 0) {
                jsonUrl = '../scripts/pha/opivas/v4/' + jsonUrl;
            }
            var dataJ = $.ajax({
                type: 'GET',
                url: jsonUrl,
                data: 'data',
                dataType: 'json',
                async: false
            });
            return dataJ.responseJSON;
        }
    }
};

if (typeof $got === 'undefined') {
    function $got(pStr) {
        return pStr + '<!>';
    }
}

