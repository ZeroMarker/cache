/*
 * 名称:     药房公共 - datagrid表格编辑一些公共方法
 * 编写人:   Huxt
 * 编写日期: 2020-08-15
 * this js:  scripts/pha/com/v1/js/grideditor.js
 * 依赖插件: scripts/pha/com/v1/js/extend.js
 *           scripts/pha/plugins/datagrid-cellediting/datagrid-cellediting.js
 * PHA_GridEditor.AutoUpd - 兼容以前的一些界面
 */
var PHA_GridEditor = {
    UsePlugin: false,
    AutoUpd: (typeof App_GridAutoUpd == 'undefined' ? false : App_GridAutoUpd),
    hasPanelArr: ['combobox', 'combogrid', 'combotree', 'datebox'],
    gridIdActive: '',
    gridIdArr: [],
    hasClickEventRows: [],
    curEidtCell: {},
    /*
     * 开始编辑,各种输入框统一入口 (单击或者双击datagrid的cell时)
     * PHA_GridEditor.Edit();
     */
    Edit: function (_options) {
        // 1. 获取参数
        var gridID = _options.gridID;
        var index = _options.index;
        var field = _options.field;
        var $GRID = $('#' + gridID);
        var gridOptions = $GRID.datagrid('options');
        if (this.gridIdArr.indexOf(gridID) < 0) {
            this.gridIdArr.push(gridID);
        }
        this.InitKeyEvent(gridID);
        // 2. 已结束自动跳转
        if (gridOptions.isEndEdit == true) {
            if (['blurError', 'addError', 'next', 'nextError', 'up', 'down', 'left', 'right'].indexOf(_options.actionType) >= 0) {
                return;
            }
        }
        gridOptions.isEndEdit = false;
        // 3. 上一个Cell验证不通过,未完成编辑
        if (_options.actionType && _options.actionType.indexOf('Error') >= 0) {
            var lastCell = gridOptions.curEidtCell;
            if (lastCell && lastCell['isActive'] == true &&
                _options.editorType == 'validatebox' &&
                !isSameCell(lastCell['index'], lastCell['field'], index, field)) {
                return;
            }
        }
        // 4. 使当前表格处于活动状态,其他表格停用
        gridOptions['isActive'] = true;
        for (var i = 0; i < this.gridIdArr.length; i++) {
            if (this.gridIdArr[i] == gridID) {
                this.gridIdActive = gridID;
                continue;
            }
            this.End(this.gridIdArr[i]);
        }
        var colOpts = $GRID.datagrid('getColumnOption', field);
        if (!colOpts.editor) {
            return;
        }
        PHA_GridEditor.t_edit = Date.now();
        // 5. 记录当前编辑的Cell信息
        if (!gridOptions.curEidtCell) {
            gridOptions.curEidtCell = {};
        }
        gridOptions.lastEditIndex = gridOptions.editIndex;
        gridOptions.lastEditField = gridOptions.curEidtCell['field'];
        gridOptions.editIndex = index;
        gridOptions.curEidtCell['index'] = index;
        gridOptions.curEidtCell['field'] = field;
        gridOptions.curEidtCell['isActive'] = true; // 控制当前cell编辑时,下一个cell不允许开始
        gridOptions.curEidtCell['isGoNext'] = false;
        gridOptions.cellData = gridOptions.cellData ? gridOptions.cellData : {};
        this.curEidtCell['index'] = index;
        this.curEidtCell['field'] = field;
        var edOpts = colOpts.editor.options || {};
        var gridRowData = $GRID.datagrid('getRows')[index];
        // 6. 开始编辑Cell
        setTimeout(function () {
            $GRID.datagrid('selectRow', index);
        }, 0);
        var ed = this.__beginEditCell($GRID, {
            index: index,
            field: field,
            forceEnd: _options.forceEnd
        });
        // 7. 编辑器绑定事件
        if (ed == null) {
            return;
        }
        if (ed.type == 'icheckbox') {
            this.__cellBlur(gridID, gridOptions.lastEditIndex, gridOptions.lastEditField);
            return;
        }
        var $target = $(ed.target);
        var $input = $target;
        if (['validatebox', 'numberbox'].indexOf(ed.type) >= 0) {
            // 获取原事件
            var pEvents = $._data($target[0], 'events');
            if (!pEvents.keydown) {
                $($target[0]).on('keydown', function () {});
            }
            if (!pEvents.blur) {
                $($target[0]).on('blur', function () {});
            }
            pEvents = $._data($target[0], 'events');
            // 绑定按键事件
            if (!pEvents.keydown[0].__handler) {
                pEvents.keydown[0].__handler = pEvents.keydown[0].handler;
            }
            pEvents.keydown[0].handler = function (e) {
                if (!(edOpts.keyPropagation === true)) {
                    e.stopPropagation();
                }
                pEvents.keydown[0].__handler.call(this, e); // 原事件
                if (edOpts.keyHandler && edOpts.keyHandler[e.keyCode]) {
                    edOpts.keyHandler[e.keyCode].call(this, e);
                } else if (edOpts.onEnter) {
                    if (e.keyCode == 13) {
                        edOpts.onEnter.call(this, e);
                    }
                }
            }
            // 绑定失去焦点事件
            if (!pEvents.blur[0].__handler) {
                pEvents.blur[0].__handler = pEvents.blur[0].handler;
            }
            pEvents.blur[0].handler = function (e) {
	            // 原事件
                pEvents.blur[0].__handler.call(this, e);
                // 控制重复调用(单元格完成会触发一次) Huxt 2022-10-11
                if ($GRID.datagrid('options').isEnd) {
	                $GRID.datagrid('options').isEnd = false;
	                return;
	            }
                if (edOpts.checkOnBlur) {
                    var _cellIdx = $(this).parentsUntil('.datagrid-row').parent().attr('datagrid-row-index');
                    var _cellVal = PHA_GridEditor.GetCellVal($GRID, _cellIdx, field);
                    colOpts.tmp_index = _cellIdx;
                    colOpts.tmp_value = _cellVal;
                    PHA_GridEditor.t_edit = 0;
                    var chkCell = PHA_GridEditor.CheckCellVal(colOpts, true);
                    if (chkCell == '') {
                        gridOptions.curEidtCell['isActive'] = false;
                    }
                }
                if (edOpts.onBlur) {
                    edOpts.onBlur.call(this, e, index);
                }
            }
        } else if (this.hasPanelArr.indexOf(ed.type) >= 0) {
            $input = $target.next().children().eq(0);
            // 是否自动展开Panel
            if (gridOptions.isAutoShowPanel == true && edOpts.autoExpand == true) {
                $target[ed.type]('showPanel');
                if (ed.type == 'combobox') {
                    if (!this.__isCellEdit(gridOptions)) {
                        if (edOpts.mode == 'remote') {
                            var edVal = $target[ed.type]('getValue');
                            var cmbRow = this.__getComboRow(gridRowData, colOpts);
                            if (edOpts.loadRemote == true || this.__isNullVal(edVal)) {
                                $target[ed.type]('reload');
                            } else if (cmbRow && !this.__isNullVal(edVal)) {
                                $target[ed.type]('loadData', [cmbRow]);
                            }
                        }
                    }
                    this.__initCmbClick(ed.target, colOpts, gridRowData);
                }
                if (['combogrid', 'lookup'].indexOf(ed.type) >= 0) {
                    var cmg = $.data($target[0], 'combogrid');
                    if (cmg) {
                        var rs = $(cmg.grid).datagrid('getRows');
                        if (rs.length == 1 && rs[0]._reload == true) {
                            $(cmg.grid).datagrid('options').isReload = true;
                            $(cmg.grid).datagrid('reload');
                        }
                    }
                }
            } else {
                if (['combobox', 'combogrid', 'lookup'].indexOf(ed.type) >= 0) {
                    var descField = colOpts.descField;
                    var cmg = null;
                    var tarVal = '';
                    var tarTxt = '';
                    if (ed.type == 'combogrid') {
                        cmg = $.data($target[0], 'combogrid');
                        if (cmg) {
                            var rs = $(cmg.grid).datagrid('getRows');
                            var sRow = gridOptions.cellData[index + '-' + field];
                            if (sRow) {
                                $(cmg.grid).datagrid('loadData', [sRow]);
                                tarVal = sRow[edOpts.idField],
                                tarTxt = sRow[edOpts.textField];
                            } else if (rs.length == 1) {
                                $(cmg.grid).datagrid('loadData', rs);
                                tarVal = rs[0][edOpts.idField],
                                tarTxt = rs[0][edOpts.textField];
                            } else {
                                tarVal = gridRowData[field],
                                tarTxt = gridRowData[descField];
                            }
                            if (!this.__isNullVal(tarVal) && !this.__isNullVal(tarTxt)) {
                                $(cmg.grid).datagrid('options')._action = 'setValue';
                            }
                        }
                    }
                    if (ed.type == 'combobox') {
                        var edVal = $target[ed.type]('getValue');
                        if (edOpts.mode == 'remote') {
                            var cmbRow = this.__getComboRow(gridRowData, colOpts);
                            if (edOpts.loadRemote == true || this.__isNullVal(edVal)) {
                                $target[ed.type]('reload');
                            } else if (cmbRow && !this.__isNullVal(edVal)) {
                                $target[ed.type]('loadData', [cmbRow]);
                            }
                        }
                        if (!this.__isNullVal(edVal)) {
                            tarVal = edVal;
                            tarTxt = $target[ed.type]('getText');
                        } else {
                            // tarVal = gridRowData[field];
                            // tarTxt = gridRowData[descField];
                        }
                        tarTxt = (typeof tarTxt == 'undefined') ? tarVal : tarTxt;
                    }
                    $target[ed.type]('setValue', tarVal);
                    $target[ed.type]('setText', tarTxt);
                    if (cmg) {
                        $(cmg.grid).datagrid('options')._action = '';
                    }
                }
            }
        }
        // 8. 非CellEdit的时候/修改输入框样式
        if (this.__isCellEdit(gridOptions)) {
            this.UpdInputCss(colOpts, $input);
        } else {
            this.InitRowEvent($GRID, index);
        }
        setTimeout(function () {
            if (!isSameCell(gridOptions.lastEditIndex, gridOptions.lastEditField, index, field)) {
                $input.focus().select();
            }
        }, 0);
        function isSameCell(i1, f1, i2, f2) {
            return (i1 == i2 && f1 == f2);
        }
    },
    /*
     * 新增一行
     * timeout 代表异步执行
     * PHA_GridEditor.Add();
     */
    Add: function (_options, timeout) {
        // 参数
        var gridID = _options.gridID;
        var field = _options.field || '';
        var rowData = _options.rowData || {};
        var checkRow = _options.checkRow;
        // 定义添加函数
        var addFn = function () {
            // 先完成编辑
            if (!PHA_GridEditor.__endEditing(gridID)) {
                return false;
            }
            // 验证上一行
            var $GRID = $('#' + gridID);
            var rowsData = $GRID.datagrid('getRows');
            var gridOptions = $GRID.datagrid('options');
            if (checkRow == true && gridOptions.curEidtCell) {
                var index = PHA_GridEditor.CurEditIndex(gridOptions.curEidtCell);
                var lastRowData = rowsData[index];
                if (lastRowData) {
                    var allCols = PHA_GridEditor.__getAllCols(gridOptions);
                    for (var c = 0; c < allCols.length; c++) {
                        var iCol = allCols[c];
                        var iField = iCol.field;
                        var iEditor = iCol.editor;
                        if (!iEditor || !lastRowData) {
                            continue;
                        }
                        var cellVal = lastRowData[iField] || '';
                        var _taskReEdit = function () {
                            setTimeout(function () {
                                PHA_GridEditor.Edit({
                                    gridID: gridID,
                                    index: index,
                                    field: iField,
                                    actionType: 'addError'
                                });
                            }, 100);
                        }
                        iCol.tmp_index = index;
                        iCol.tmp_value = cellVal;
                        var chkCell = PHA_GridEditor.CheckCellVal(iCol, true, _taskReEdit);
                        if (chkCell != '') {
                            return;
                        }
                    }
                }
            }
            // 添加一行数据
            var newRowIndex;
            if (_options.firstRow == true) {
                newRowIndex = 0;
                $GRID.datagrid('insertRow', {
                    index: newRowIndex,
                    row: rowData
                });
            } else {
                $GRID.datagrid('appendRow', rowData);
                var rowsData = $GRID.datagrid('getRows');
                newRowIndex = rowsData.length - 1;
            }
            // 是否开始编辑
            if (field != '') {
                PHA_GridEditor.Edit({
                    gridID: gridID,
                    index: newRowIndex,
                    field: field,
                    actionType: 'add'
                });
            }
        }
        // 执行添加函数
        if (timeout >= 0) {
            setTimeout(function () {
                addFn();
            }, timeout);
        } else {
            addFn();
        }
    },
    /*
     * 控制表格中的快捷按键(上下键/回车等)、自动化操作等
     * PHA_GridEditor.GridActive();
     */
    GridActive: function (_options) {
        return this.GridAtive(_options);
    },
    GridAtive: function (_options) {
        var gridID = _options.gridID;
        var $GRID = $('#' + gridID);
        var gridOptions = $GRID.datagrid('options');
        if (this.gridIdArr.indexOf(gridID) < 0) {
            this.gridIdArr.push(gridID);
        }
        gridOptions.gridEditType = _options.type;
        gridOptions.gridKeyEvent = _options.gridKeyEvent;
        gridOptions.allowEnd = (_options.allowEnd == false) ? false : true;
        this.InitKeyEvent(gridID);
        gridOptions.isActive = true;
        for (var i = 0; i < this.gridIdArr.length; i++) {
            if (this.gridIdArr[i] == gridID) {
                this.gridIdActive = gridID;
                continue;
            }
            var oGridId = this.gridIdArr[i];
            var oGridOptions = $('#' + oGridId).datagrid('options');
            oGridOptions.isActive = false;
        }
    },
    /*
     * 获取表格当前正在编辑的cell的值
     * PHA_GridEditor.GetValue();
     */
    GetValue: function (gridID) {
        gridID = this.__GetCurGridId(gridID);
        var $GRID = $('#' + gridID);
        var gridOptions = $GRID.datagrid('options');
        var index = PHA_GridEditor.CurEditIndex(gridOptions.curEidtCell);
        var field = PHA_GridEditor.CurEditField(gridOptions.curEidtCell);
        return this.GetCellVal($GRID, index, field);
    },
    /*
     * 设置表格当前编辑的行或者cell的值
     * PHA_GridEditor.SetValue();
     */
    SetValue: function (val, gridID) {
        gridID = this.__GetCurGridId(gridID);
        var $GRID = $('#' + gridID);
        var gridOptions = $GRID.datagrid('options');
        var index = PHA_GridEditor.CurEditIndex(gridOptions.curEidtCell);
        var field = PHA_GridEditor.CurEditField(gridOptions.curEidtCell);
        var updateData = {};
        var dataType = this.__DataType(val);
        if (dataType == '[object Object]') {
            updateData = val;
        } else {
            updateData[field] = val;
        }
        $GRID.datagrid('updateRowData', {
            index: index,
            row: updateData
        });
    },
    /*
     * 用于记录表格combo的panel的展开状态
     * PHA_GridEditor.Show();
     */
    Show: function (gridID) {
        this.UpdComboState(gridID, 'show');
    },
    Hide: function (gridID) {
        this.UpdComboState(gridID, 'hide');
    },
    UpdComboState: function (gridID, state) {
        gridID = this.__GetCurGridId(gridID);
        var $GRID = $('#' + gridID);
        var gridOptions = $GRID.datagrid('options');
        if (gridOptions.curEidtCell) {
            gridOptions.curEidtCell['state'] = state;
        }
    },
    /*
     * 自动获取并开始编辑下一个Cell, 根据editFieldSort配置的顺序来获取
     * (gridID - 表格ID; callFlag - 调用标志,兼容老版本界面)
     * PHA_GridEditor.Next();
     */
    Next: function (gridID, callFlag) {
        gridID = this.__GetCurGridId(gridID);
        var $GRID = $('#' + gridID);
        var gridOptions = $GRID.datagrid('options');
        var index = PHA_GridEditor.CurEditIndex(gridOptions.curEidtCell);
        var field = PHA_GridEditor.CurEditField(gridOptions.curEidtCell);
        var colOpts = $GRID.datagrid('getColumnOption', field);
        if (!colOpts) {
            return;
        }
        var edOpts = colOpts.editor || {};
        var cellVal = this.GetCellVal($GRID, index, field);
        var _taskReEdit = function () {
            setTimeout(function () {
                PHA_GridEditor.Edit({
                    gridID: gridID,
                    index: index,
                    field: field,
                    actionType: 'nextError',
                    editorType: edOpts.type
                });
            }, 100);
        }
        colOpts.tmp_index = index;
        colOpts.tmp_value = cellVal;
        var chkCell = this.CheckCellVal(colOpts, true, _taskReEdit);
        if (chkCell != '') {
            return;
        }
        var nextCell = this.GetNextCell(gridOptions.editFieldSort, index, field);
        if (nextCell == null) {
            return;
        }
        var isLastRow = PHA_GridEditor.IsLastRow(gridID);
        var isLastCol = nextCell.isEndCol;
        if (gridOptions.onNextCell) {
            gridOptions.onNextCell.call($GRID[0], index, field, cellVal, isLastRow, isLastCol, nextCell);
        } else if (isLastRow == true && isLastCol == true) {
            $GRID.datagrid('endEdit', index);
            return;
        }
        var rowsData = $GRID.datagrid('getRows');
        if (rowsData.length <= nextCell.index) {
            $GRID.datagrid('endEdit', index);
            return;
        }
        if (!this.__isCellEdit(gridOptions) && nextCell.index != index) {
            $GRID.datagrid('endEdit', index);
        }
        setTimeout(function () {
            PHA_GridEditor.GoTo($GRID, nextCell.index, nextCell.field, 'next', callFlag);
        }, 100);
    },
    GoTo: function ($GRID, index, field, actionType, callFlag) {
        if (callFlag == 1) {
            this.HidePanel($GRID);
        }
        var gridOptions = $GRID.datagrid('options');
        gridOptions.curEidtCell['isActive'] = false; // 当前cell完成编辑
        PHA_GridEditor.Edit({
            gridID: gridOptions.id,
            index: index,
            field: field,
            actionType: actionType
        });
    },
    HidePanel: function ($GRID) {
        var gridOptions = $GRID.datagrid('options');
        var index = PHA_GridEditor.CurEditIndex(gridOptions.curEidtCell);
        var field = PHA_GridEditor.CurEditField(gridOptions.curEidtCell);
        var ed = $GRID.datagrid('getEditor', {
            index: index,
            field: field
        });
        if (!ed) {
            return;
        }
        if (this.hasPanelArr.indexOf(ed.type) >= 0) {
            var $target = $(ed.target);
            $target[ed.type]('hidePanel');
        }
    },
    GetCellVal: function ($GRID, index, field) {
        if (!(index >= 0)) {
            return null;
        }
        var ed = $GRID.datagrid('getEditor', {
            index: index,
            field: field
        });
        if (ed) {
            var $target = $(ed.target);
            if (ed.type == 'validatebox' || ed.type == 'numberbox') {
                return $target.val();
            }
            if (ed.type == 'icheckbox') {
                return $target.checkbox('getValue');
            }
            return $target[ed.type]('getValue');
        }
        var rsData = $GRID.datagrid('getRows');
        if (rsData.length < index) {
            return null;
        }
        if (!rsData[index]) {
            return null;
        }
        return rsData[index][field];
    },
    CheckCellVal: function (colOpts, showTips, _taskReEdit) {
        var colField = colOpts.field || '';
        var colTitle = colOpts.title || '';
        var index = colOpts.tmp_index;
        var edVal = colOpts.tmp_value;
        var editor = colOpts.editor;
        if (!editor) {
            return '';
        }
        var edOpts = editor.options;
        if (!edOpts) {
	        return '';
	    }
        // 时间验证
        if (PHA_GridEditor.t_edit && Date.now() - PHA_GridEditor.t_edit < 100) {
            _taskReEdit && _taskReEdit();
            var pTips = '您编辑太快！';
            !!showTips && PHA_GridEditor.popoverTips(pTips);
            return pTips;
        }
        // 必填验证
        if (edOpts.required == true && edVal == '') {
            _taskReEdit && _taskReEdit();
            var pTips = '第' + (parseInt(index) + 1) + '行“' + colTitle + '”为必填项！';
            !!showTips && PHA_GridEditor.popoverTips(pTips);
            return pTips;
        }
        // 函数验证
        var checkRet = {};
        if (edOpts.checkValue && edOpts.checkValue(edVal, checkRet) == false) {
            _taskReEdit && _taskReEdit();
            var chkMsg = checkRet.msg || '验证不通过!';
            var pTips = '第' + (parseInt(index) + 1) + '行“' + colTitle + '”' + chkMsg;
            !!showTips && PHA_GridEditor.popoverTips(pTips);
            return pTips;
        }
        // 正则验证
        var regExp = edOpts.regExp || '';
        if (regExp != '' && regExp.test(edVal) == false) {
            _taskReEdit && _taskReEdit();
            var regTxt = edOpts.regTxt || '';
            regTxt = (regTxt == '') ? '验证不通过!' : regTxt;
            var pTips = '第' + (parseInt(index) + 1) + '行“' + colTitle + '”' + regTxt;
            !!showTips && PHA_GridEditor.popoverTips(pTips);
            return pTips;
        }
        return '';
    },
    GetNextCell: function (editFieldSort, curIndex, curField) {
        if (!editFieldSort || editFieldSort.length == 0) {
            return null;
        }
        if (editFieldSort.indexOf(curField) < 0) {
            return null;
        }
        var isEndCol = false;
        var nextRowIndex = curIndex;
        var nextField = editFieldSort[0];
        var currFieldIndex = editFieldSort.indexOf(curField);
        var nextFieldIndex = currFieldIndex + 1;
        if (nextFieldIndex > editFieldSort.length - 1) {
            nextRowIndex = nextRowIndex + 1;
            nextField = editFieldSort[0];
            isEndCol = true;
        } else {
            nextField = editFieldSort[nextFieldIndex];
        }
        return {
            index: nextRowIndex,
            field: nextField,
            isEndCol: isEndCol
        }
    },
    /*
     * 验证表格的数据是否重复 (独立的方法)
     * params: _options.gridID - 表格ID
     *         _options.fields - 验证重复的字段
     *         _options.isCheckNull - 字段为空时是否验证
     * return: 空-表示验证通过; 非空-表示验证不通过(并且该值为错误提示信息)
     * var chkRetStr = PHA_GridEditor.CheckDistinct({gridID:'', fields:['', '']});
     */
    CheckDistinct: function (_options) {
        var gridID = _options.gridID;
        var fields = _options.fields;
        var isCheckNull = _options.isCheckNull == false ? false : true;
        var $GRID = $('#' + gridID);
        var rowsData = $GRID.datagrid('getRows');
        var rowsUniqueVal = [];
        for (var i = 0; i < rowsData.length; i++) {
            var rowData = rowsData[i];
            var rowStr = '';
            for (var j = 0; j < fields.length; j++) {
                var cellVal = rowData[fields[j]] || '';
                if (cellVal == '' && !isCheckNull) {
                    continue;
                }
                rowStr = rowStr == '' ? cellVal : rowStr + ';' + cellVal;
            }
            if (rowStr == '' && !isCheckNull) {
                continue;
            }
            rowsUniqueVal.push(rowStr);
        }
        for (var i = 0; i < rowsUniqueVal.length; i++) {
            var cellVal1 = rowsUniqueVal[i];
            for (var j = i + 1; j < rowsUniqueVal.length; j++) {
                var cellVal2 = rowsUniqueVal[j];
                if (cellVal1 == cellVal2) {
                    return '第' + (i + 1) + '行与第' + (j + 1) + '行重复';
                }
            }
        }
        return '';
    },
    /*
     * 验证表格的数据是否重复 (独立的方法)
     * params: _options.gridID - 表格ID
     *         _options.fields - 验证重复的字段
     *         _options.isCheckNull - 字段为空时是否验证
     * return: false: 数据异常并给出了提示; true: 数据正常无提示
     * PHA_GridEditor.CheckDistinctMsg({gridID:'', fields:['', '']})
     */
    CheckDistinctMsg: function (_options) {
        var chkMsg = this.CheckDistinct(_options);
        if (chkMsg != '') {
            this.popoverTips(chkMsg);
            return false;
        }
        return true;
    },
    /*
     * 验证表格的数据是否正常 (独立的方法)
     * params: gridID - 表格ID
     *         inRowsData - 只验证指定的一行
     * return: 空-表示验证通过; 非空-表示验证不通过(并且该值为错误提示信息)
     * var chkRetStr = PHA_GridEditor.CheckValues('');
     */
    CheckValues: function (gridID, inRowsData) {
        $GRID = $('#' + gridID);
        var gridOpts = $GRID.datagrid('options');
        var allColumns = this.__getAllCols(gridOpts);
        // 解析对照
        var defaultRowData = {};
        var colObject = {};
        var colsLen = allColumns.length;
        for (var c = 0; c < colsLen; c++) {
            var iCol = allColumns[c];
            var iField = iCol.field;
            colObject[iField] = iCol;
            defaultRowData[iField] = '';
        }
        // 验证
        var rowsData = (inRowsData && inRowsData != '') ? inRowsData : $GRID.datagrid('getRows');
        for (var i = 0; i < rowsData.length; i++) {
            var rowData = rowsData[i];
            var rowIndex = $GRID.datagrid('getRowIndex', rowData);
            for (var d in defaultRowData) {
                if (typeof rowData[d] == 'undefined') {
                    rowData[d] = defaultRowData[d];
                }
            }
            for (var k in rowData) {
                var colOpts = colObject[k];
                if (typeof colOpts == 'undefined') {
                    continue;
                }
                var cellVal = this.GetCellVal($GRID, rowIndex, k);
                colOpts.tmp_index = i;
                colOpts.tmp_value = cellVal;
                var chkCell = this.CheckCellVal(colOpts, false);
                if (chkCell != '') {
                    return chkCell;
                }
            }
        }
        return '';
    },
    /*
     * 验证表格的数据是否正常 (独立的方法)
     * params: gridID - 表格ID
     *         inRowsData - 只验证指定的一行
     * return: false: 数据异常并给出了提示; true: 数据正常无提示
     * PHA_GridEditor.CheckValuesMsg('')
     */
    CheckValuesMsg: function (gridID, inRowsData) {
        var chkMsg = this.CheckValues(gridID, inRowsData);
        if (chkMsg != '') {
            this.popoverTips(chkMsg);
            return false;
        }
        return true;
    },
    /*
     * 主要用于结束表格中的快捷按键(上下键/回车等)、自动化操作等
     * 该方法与PHA_GridEditor.GridActive()作用相反
     * PHA_GridEditor.End();
     */
    End: function (gridID) {
        if (this.isWinEditor) {
            return false;
        }
        var $GRID = $('#' + gridID);
        if (!this.__endEditing(gridID)) {
            return false;
        }
        var gridOptions = $GRID.datagrid('options');
        gridOptions.curEidtCell = {};
        gridOptions.isEndEdit = true;
        gridOptions.isActive = false;
        gridOptions.lastEditIndex = undefined;
        gridOptions.editIndex = undefined;
        gridOptions.cellData = {};
        return true;
    },
    /*
     * 验证并完成表格编辑,如果不通过则提示并返回false;反之则返回true
     * PHA_GridEditor.EndCheck();
     */
    EndCheck: function (gridID) {
        if (!this.End(gridID)) {
            var gridOptions = $('#' + gridID).datagrid('options');
            var editIndex = gridOptions.editIndex;
            if (editIndex >= 0) {
                this.popoverTips('第' + (editIndex + 1) + '行, 有必填项未填写, 请先完成编辑！');
                return false;
            }
        }
        return true;
    },
    /*
     * 获取修改的数据(不包含删除的)
     * PHA_GridEditor.GetChanges('');
     */
    GetChanges: function (gridID) {
        var insertedData = $('#' + gridID).datagrid('getChanges', 'inserted');
        var updatedData = $('#' + gridID).datagrid('getChanges', 'updated');
        var r = [];
        r = r.concat(insertedData);
        r = r.concat(updatedData);
        return r;
    },
    /*
     * 上下键交换行数据
     * PHA_GridEditor.ExchangeRow();
     */
    ExchangeRow: function (_opts) {
        this.__UpAndDown_Exchange(_opts);
    },
    // 初始化表格键盘操作事件
    InitKeyEvent: function (gId) {
        if (PHA_GridEditor.InitGridId) {
            PHA_GridEditor.InitGridId = gId;
            return;
        }
        PHA_GridEditor.InitGridId = gId;
        // 点击表格之外的其他地方
        $(document.body).bind('click', function (e) {
            //e.stopPropagation();
            var gridID = PHA_GridEditor.InitGridId;
            var $GRID = $('#' + gridID);
            var gridOptions = $GRID.datagrid('options');
            var $target = $(e.target);
            var $dgBody = $target.closest('.datagrid-body');
            if ($dgBody.length > 0) {
                return;
            }
            // 表格之外的其他地方
            if (gridOptions.allowEnd == true) {
                PHA_GridEditor.End(gridID);
            }
        });
        // 绑定键盘事件
        $(document.body).on('keydown', function (e) {
            //e.stopPropagation();
            var gridID = PHA_GridEditor.InitGridId;
            var $GRID = $('#' + gridID);
            var gridOptions = $GRID.datagrid('options');
            // 1. 是否可用
            if (gridOptions.isActive != true) {
                return;
            }
            // 2. 上下键交换行
            var chkRet = true;
            var endEditFlag = (gridOptions.isEndEdit == true || typeof gridOptions.isEndEdit == 'undefined') ? true : false;
            if (gridOptions.gridEditType == 'exchange' && endEditFlag == true) {
                var ifUp = e.keyCode == 38 ? true : (e.keyCode == 40 ? false : null);
                if (ifUp != null) {
                    chkRet = PHA_GridEditor.__UpAndDown_Exchange({
                        gridID: gridID,
                        ifUp: ifUp
                    });
                }
                gridOptions.gridKeyEvent && gridOptions.gridKeyEvent.call($GRID[0], e, chkRet);
                return;
            }
            // 3. 上下键选择行(单选)
            if (gridOptions.gridEditType == 'select' && endEditFlag == true) {
                var ifUp = e.keyCode == 38 ? true : (e.keyCode == 40 ? false : null);
                if (ifUp != null) {
                    chkRet = PHA_GridEditor.__UpAndDown_Select({
                        gridID: gridID,
                        ifUp: ifUp
                    });
                }
                gridOptions.gridKeyEvent && gridOptions.gridKeyEvent.call($GRID[0], e, chkRet);
                return;
            }
            // 4. 定位Cell编辑器
            if (!gridOptions.curEidtCell) {
                gridOptions.gridKeyEvent && gridOptions.gridKeyEvent.call($GRID[0], e, false);
                return;
            }
            var index = PHA_GridEditor.CurEditIndex(gridOptions.curEidtCell);
            var field = PHA_GridEditor.CurEditField(gridOptions.curEidtCell);
            // 5. 获取Cell编辑器
            var ed = $GRID.datagrid('getEditor', {
                index: index,
                field: field
            });
            if (ed == null) {
                gridOptions.gridKeyEvent && gridOptions.gridKeyEvent.call($GRID[0], e, false);
                return;
            }
            // 6. checkbox操作监听
            if (ed.type == 'icheckbox') {
                var $target = $(ed.target);
                var edOpts = $target.checkbox('options');
                var _chkOnBeforeNext = function () {
                    if (PHA_GridEditor.t_edit && Date.now() - PHA_GridEditor.t_edit < 100) {
                        PHA_GridEditor.popoverTips('您编辑太快！');
                        return false;
                    }
                    var val = $target ? $target.checkbox('getValue') : '';
                    if (edOpts.onBeforeNext) {
                        var rowsData = $GRID.datagrid('getRows');
                        var curRowData = rowsData[index];
                        return edOpts.onBeforeNext.call(ed.target, val, curRowData, index);
                    }
                    return true;
                }
                switch (e.keyCode) {
                case 89:
                    // Y键
                    var chkVal = $target.checkbox('getValue');
                    if (chkVal != true) {
                        $target.next().eq(0).click();
                    }
                    if (_chkOnBeforeNext(ed) != false)
                        PHA_GridEditor.Next(gridID, 1);
                    break;
                case 78:
                    // N键
                    var chkVal = $target.checkbox('getValue');
                    if (chkVal != false) {
                        $target.next().eq(0).click();
                    }
                    if (_chkOnBeforeNext(ed) != false)
                        PHA_GridEditor.Next(gridID, 1);
                    break;
                default:
                    // 其他键
                    if (_chkOnBeforeNext(ed) != false)
                        if (edOpts.keyHandler && edOpts.keyHandler[e.keyCode]) {
                            edOpts.keyHandler[e.keyCode].call(ed.target, e);
                        } else if (e.keyCode == 13) {
                            PHA_GridEditor.Next(gridID, 1);
                        }
                    break;
                }
            }
            gridOptions.gridKeyEvent && gridOptions.gridKeyEvent.call($GRID[0], e, true);
        });
    },
    // 控制导航键不要太快
    CheckNavigationTime: function (edType) {
        var tm = (['combogrid', 'lookup'].indexOf(edType >= 0)) ? 150 : 100;
        if (PHA_GridEditor.t_edit && Date.now() - PHA_GridEditor.t_edit < tm) {
            PHA_GridEditor.popoverTips('您编辑太快！');
            return false;
        }
        return true;
    },
    // 行编辑模式初始化事件
    InitRowEvent: function ($GRID, index) {
        var gridOpts = $GRID.datagrid('options');
        var editors = $GRID.datagrid('getEditors', index);
        for (var ei = 0; ei < editors.length; ei++) {
            var ed = editors[ei];
            if (ed == null || ed.type == 'icheckbox') {
                continue;
            }
            var $target = $(ed.target);
            var $input = null;
            if (this.hasPanelArr.indexOf(ed.type) >= 0) {
                $input = $target.next().children().eq(0);
            } else {
                $input = $target;
            }
            var gId = $input.attr('pha_gridid');
            if (!this.__isNullVal(gId)) {
                continue;
            }
            var colOpts = $GRID.datagrid('getColumnOption', ed.field);
            this.UpdInputCss(colOpts, $input);
            $input.attr('pha_gridid', gridOpts.id);
            $input.attr('pha_index', index);
            $input.attr('pha_field', ed.field);
            $input.on('click', function (e) {
                e.stopPropagation();
                var g = $(this).attr('pha_gridid');
                var i = $(this).parentsUntil('.datagrid-row').parent().attr('datagrid-row-index');
                var f = $(this).attr('pha_field');
                PHA_GridEditor.Edit({
                    gridID: g,
                    index: parseInt(i),
                    field: f,
                    actionType: 'click'
                });
            });
            $input.next().on('click', function (e) {
                e.stopPropagation();
                var g = $(this).prev().attr('pha_gridid');
                var i = $(this).parentsUntil('.datagrid-row').parent().attr('datagrid-row-index');
                var f = $(this).prev().attr('pha_field');
                PHA_GridEditor.Edit({
                    gridID: g,
                    index: parseInt(i),
                    field: f,
                    actionType: 'click'
                });
            });
        }
    },
    // 修改样式(lookup,triggerbox)
    UpdInputCss: function (colOpts, $input) {
        if (colOpts.editor._lookup) {
            this.ToLookUp($input);
        }
        if (colOpts.editor._trigger) {
            this.ToTriggerBox($input, colOpts.editor._trigger, 30);
        }
    },
    ToLookUp: function ($input) {
        $input.next().children().eq(0).addClass('lookup').css('font-size', '0px');
    },
    ToTriggerBox: function ($input, _triggerCls, iconWidth) {
        $input.css('border', '0px');
        var tWidth = $input.width();
        $input.width(tWidth - iconWidth);
        var $iPar = $input.parent();
        var isLiteCss = this.__isLiteCss();
        $iPar.css({
            height: '28px',
            border: '1px solid ' + (isLiteCss ? '#ccc' : '#9ed2f2'),
            backgroundColor: '#fff',
            borderRadius: '2px'
        });
        $iPar.width(tWidth - 4);
        $iPar.append('<span><span class="triggerbox-button ' + _triggerCls + '" style="height:28px; font-family:Mw_mifonts; -webkit-font-smoothing:antialiased;"></span></span>');
        var $span = $input.next();
        $span.children().eq(0).css({
            lineHeight: '28px',
            textAlign: 'center'
        });
        $span.off('click');
        $span.on('click', function (e) {
            e.stopPropagation();
            var kde = jQuery.Event("keydown");
            kde.keyCode = 13;
            $input.trigger(kde);
        });
        $span.hover(function () {
            $(this).children().eq(0).css('color', '#339EFF');
        }, function () {
            $(this).children().eq(0).css('color', '#7E7E7E');
        });
        var _blue = 'rgb(244, 250, 255)';
        var _white = 'rgb(255, 255, 255)';
        var _updBgc = function (_c) {
            $span.children().eq(0).css('background-color', _c);
            $input.css('background-color', _c);
            if (isLiteCss) {
                if (_c == _white) {
                    $iPar.css('background-color', '#fff');
                    $iPar.css('border-color', '#ccc');
                } else {
                    $iPar.css('background-color', '#EFF9FF');
                    $iPar.css('border-color', '#339EFF');
                }
            }
        }
        $input.css('background-color', _white);
        $iPar.hover(function () {
            _updBgc(_blue);
        }, function () {
            _updBgc($input.is(":focus") ? _blue : _white);
        });
        $input.on('blur', function () {
            _updBgc(_white);
        });
        $input.on('focus', function () {
            _updBgc(_blue);
        });
    },
    /*
     * Huxt 2021-04-13
     * 以下定义一些常用的公共的表格编辑框
     * ===============================================
     * 1. 文本验证框
     * PHA_GridEditor.ValidateBox({})
     */
    ValidateBox: function (_opts, _trigger) {
        _opts = _opts || {};
        var _defOpts = {
            _trigger: _trigger,
            missingMessage: null,
            keyHandler: {
                38: function (e) {
                    PHA_GridEditor.__go(this, 'validatebox', 'up', e);
                },
                40: function (e) {
                    PHA_GridEditor.__go(this, 'validatebox', 'down', e);
                },
                37: function (e) {
                    PHA_GridEditor.__go(this, 'validatebox', 'left', e);
                },
                39: function (e) {
                    PHA_GridEditor.__go(this, 'validatebox', 'right', e);
                },
                13: function (e) {
                    PHA_GridEditor.__go(this, 'validatebox', 'enter', e); // onEnter() -> Next()
                }
            }
        };
        var _newOpts = $.extend({}, _defOpts, _opts);
        _newOpts.onEnter = function (gridRowData, _edOpts) {
            var thisGridId = _edOpts.gridID;
            var thisField = _edOpts.field;
            // 取值
            var $GRID = PHA_GridEditor.__GetJqGrid(thisGridId);
            var gridOptions = $GRID.datagrid('options');
            var index = gridOptions.editIndex;
            var field = PHA_GridEditor.CurEditField(gridOptions.curEidtCell);
            if (field != thisField) {
                return;
            }
            var ed = $GRID.datagrid('getEditor', {
                index: index,
                field: field
            });
            var $_vb = ed ? $(ed.target) : null;
            var val = $_vb ? $_vb.val() : '';
            var rowsData = $GRID.datagrid('getRows');
            var curRowData = rowsData[index];
            var tmpRowData = PHA_GridEditor.__deepCopy(curRowData);
            // 回车
            _opts.onEnter && _opts.onEnter.call(ed.target, val, tmpRowData, index);
            // 跳转
            var _updRowFn = function () {
                var updData = {};
                if (PHA_GridEditor.AutoUpd) {
                    for (var k in tmpRowData) {
                        if (tmpRowData[k] != curRowData[k]) {
                            updData[k] = tmpRowData[k];
                        }
                    }
                }
                if (typeof updData[thisField] == 'undefined') {
                    updData[thisField] = val;
                }
                $GRID.datagrid('updateRowData', {
                    index: index,
                    row: updData
                });
            }
            if (_opts.onBeforeNext && _opts.onBeforeNext.call(ed.target, val, tmpRowData, index) === false) {
                _updRowFn();
                return;
            }
            _updRowFn();
            PHA_GridEditor.Next(thisGridId, 1);
        }
        _newOpts.onBlur = function (e, index) {
            var $thisEditor = $(this);
            var edOpts = $thisEditor.validatebox('options');
            var thisGridId = edOpts.gridID;
            var thisField = edOpts.field;
            var $GRID = PHA_GridEditor.__GetJqGrid(thisGridId);
            var gridOptions = $GRID.datagrid('options');
            var ed = $GRID.datagrid('getEditor', {
                index: index,
                field: thisField
            });
            if (ed == null) {
                return;
            }
            var $_vb = ed ? $(ed.target) : null;
            var val = $_vb ? $_vb.val() : '';
            var rowsData = $GRID.datagrid('getRows');
            var curRowData = rowsData[index];
            var tmpRowData = PHA_GridEditor.__deepCopy(curRowData);
            _opts.onBlur && _opts.onBlur.call(ed.target, val, tmpRowData, index);
            var _updRowFn = function () {
                var updData = {};
                if (PHA_GridEditor.AutoUpd) {
                    for (var k in tmpRowData) {
                        if (tmpRowData[k] != curRowData[k]) {
                            updData[k] = tmpRowData[k];
                        }
                    }
                }
                if (typeof updData[thisField] == 'undefined') {
                    updData[thisField] = val;
                }
                $GRID.datagrid('updateRowData', {
                    index: index,
                    row: updData
                });
            }
            _updRowFn();
        }
        return {
            type: 'validatebox',
            _trigger: _trigger,
            options: _newOpts
        };
    },
    /*
     * 2. 数字框
     * PHA_GridEditor.NumberBox({})
     */
    NumberBox: function (_opts) {
        _opts = _opts || {};
        var _defOpts = {
            precision: 2,
            missingMessage: null,
            keyHandler: {
                38: function (e) {
                    PHA_GridEditor.__go(this, 'numberbox', 'up', e);
                },
                40: function (e) {
                    PHA_GridEditor.__go(this, 'numberbox', 'down', e);
                },
                37: function (e) {
                    PHA_GridEditor.__go(this, 'numberbox', 'left', e);
                },
                39: function (e) {
                    PHA_GridEditor.__go(this, 'numberbox', 'right', e);
                },
                13: function (e) {
                    PHA_GridEditor.__go(this, 'numberbox', 'enter', e); // onEnter() -> Next()
                }
            }
        }
        var _newOpts = $.extend({}, _defOpts, _opts);
        _newOpts.onEnter = function (gridRowData, _edOpts) {
            var thisGridId = _edOpts.gridID;
            var thisField = _edOpts.field;
            // 取值
            var $GRID = PHA_GridEditor.__GetJqGrid(thisGridId);
            var gridOptions = $GRID.datagrid('options');
            var index = gridOptions.editIndex;
            var field = PHA_GridEditor.CurEditField(gridOptions.curEidtCell);
            if (field != thisField) {
                return;
            }
            var ed = $GRID.datagrid('getEditor', {
                index: index,
                field: field
            });
            var $_nb = ed ? $(ed.target) : null;
            var val = $_nb ? $_nb.val() : '';
            if (val !== '') {
                if (_edOpts.gridPrecision !== undefined) {
                    if (_edOpts.gridPrecision !== '' && _edOpts.gridPrecision >= 0) {
                        val = Number(val).toFixed(_edOpts.gridPrecision);
                    }
                } else if (_edOpts.precision >= 0) {
                    val = Number(val).toFixed(_edOpts.precision);
                }
            }
            $_nb.val(val);
            var rowsData = $GRID.datagrid('getRows');
            var curRowData = rowsData[index];
            var tmpRowData = PHA_GridEditor.__deepCopy(curRowData);
            // 回车
            _opts.onEnter && _opts.onEnter.call(ed.target, val, tmpRowData, index);
            // 跳转
            var _updRowFn = function () {
                var updData = {};
                if (PHA_GridEditor.AutoUpd) {
                    for (var k in tmpRowData) {
                        if (tmpRowData[k] != curRowData[k]) {
                            updData[k] = tmpRowData[k];
                        }
                    }
                }
                if (typeof updData[thisGridId] == 'undefined') {
                    updData[thisGridId] = val;
                }
                $GRID.datagrid('updateRowData', {
                    index: index,
                    row: updData
                });
            }
            if (_opts.onBeforeNext && _opts.onBeforeNext.call(ed.target, val, tmpRowData, index) === false) {
                _updRowFn();
                return;
            }
            _updRowFn();
            PHA_GridEditor.Next(thisGridId, 1);
        }
        _newOpts.onBlur = function (e, index) {
            var $thisEditor = $(this);
            var edOpts = $thisEditor.numberbox('options');
            var thisGridId = edOpts.gridID;
            var thisField = edOpts.field;
            var $GRID = PHA_GridEditor.__GetJqGrid(thisGridId);
            var gridOptions = $GRID.datagrid('options');
            var ed = $GRID.datagrid('getEditor', {
                index: index,
                field: thisField
            });
            if (ed == null) {
                return;
            }
            var $_nb = ed ? $(ed.target) : null;
            var val = $_nb ? $_nb.val() : '';
            if (val !== '') {
                if (edOpts.gridPrecision !== undefined) {
                    if (edOpts.gridPrecision !== '' && edOpts.gridPrecision >= 0) {
                        val = Number(val).toFixed(edOpts.gridPrecision);
                    }
                } else if (edOpts.precision >= 0) {
                    val = Number(val).toFixed(edOpts.precision);
                }
            }
            $_nb.val(val);
            var rowsData = $GRID.datagrid('getRows');
            var curRowData = rowsData[index];
            var tmpRowData = PHA_GridEditor.__deepCopy(curRowData);
            _opts.onBlur && _opts.onBlur.call(ed.target, val, tmpRowData, index);
            var _updRowFn = function () {
                var updData = {};
                if (PHA_GridEditor.AutoUpd) {
                    for (var k in tmpRowData) {
                        if (tmpRowData[k] != curRowData[k]) {
                            updData[k] = tmpRowData[k];
                        }
                    }
                }
                if (typeof updData[thisField] == 'undefined') {
                    updData[thisField] = val;
                }
                $GRID.datagrid('updateRowData', {
                    index: index,
                    row: updData
                });
            }
            _updRowFn();
        }
        _newOpts.tmp_precision = _newOpts.precision;

        return {
            type: 'numberbox',
            options: _newOpts
        };
    },
    /*
     * 3. 下拉框
     * PHA_GridEditor.ComboBox({})
     */
    ComboBox: function (_opts) {
        _opts = _opts || {};
        var _onBeforeLoad = _opts.onBeforeLoad;
        delete _opts.onBeforeLoad;
        var defMode = _opts.data ? 'local' : 'remote';
        var _defOpts = {
            missingMessage: null,
            selectOnNavigation: false,
            valueField: 'RowId',
            textField: 'Description',
            mode: defMode,
            autoExpand: true,
            keyHandler: {
                up: function (e) {
                    try {
                        $.fn.combobox.defaults.keyHandler.up.call(this, e);
                        PHA_GridEditor.__go(this, 'combobox', 'up', e);
                    } catch (ex) {}
                },
                down: function (e) {
                    try {
                        $.fn.combobox.defaults.keyHandler.down.call(this, e);
                        PHA_GridEditor.__go(this, 'combobox', 'down', e);
                    } catch (ex) {}
                },
                left: function (e) {
                    PHA_GridEditor.__go(this, 'combobox', 'left', e);
                },
                right: function (e) {
                    PHA_GridEditor.__go(this, 'combobox', 'right', e);
                },
                enter: function (e) {
                    try {
                        $.fn.combobox.defaults.keyHandler.enter.call(this, e);
                        PHA_GridEditor.__go(this, 'combobox', 'enter', e); // onSelect() -> Next()
                    } catch (ex) {
                        console.log(ex);
                    }
                },
                query: function (e) {
                    try {
                        $.fn.combobox.defaults.keyHandler.query.call(this, e);
                    } catch (ex) {}
                }
            },
            onBeforeLoad: function (param) {
                param.QText = PHA_GridEditor.__isNullVal(param.q) ? '' : param.q;
                /* 获取Editor信息 */
                var $thisEditor = $(this);
                var edOpts = $thisEditor.combobox('options');
                var thisGridId = edOpts.gridID;
                var thisField = edOpts.field;
                var thisDescField = edOpts.descField;
                var $GRID = PHA_GridEditor.__GetJqGrid(thisGridId);
                var gridOptions = $GRID.datagrid('options');
                var index = gridOptions.editIndex;
                var gridRowData = $GRID.datagrid('getRows')[index];
                /* 刚进入编辑状态时加载数据 */
                var cmbVal = gridRowData[thisField];
                var cmbTextVal = gridRowData[thisDescField];
                var isInitComp = $thisEditor.attr('init');
                $thisEditor.attr('init', 'Y');
                if ((!(isInitComp == 'Y')) &&
                    (!(edOpts.loadRemote == true)) &&
                    (edOpts.mode == 'remote')) {
                    if (!PHA_GridEditor.__isNullVal(cmbVal) &&
                        !PHA_GridEditor.__isNullVal(cmbTextVal)) {
                        var rowData = {};
                        rowData[edOpts.valueField] = cmbVal;
                        rowData[edOpts.textField] = cmbTextVal;
                        if (rowData) {
                            $thisEditor.combobox('loadData', [rowData]);
                            return false;
                        }
                    }
                    if (edOpts.localOnInit) {
                        return false
                    }
                }
                /* 用户自定义 */
                if (_onBeforeLoad) {
                    return _onBeforeLoad.call(this, param, gridRowData);
                }
            },
            onLoadSuccess: function (data) {
                var edOpts = $(this).combobox('options');
                var thisGridId = edOpts.gridID;
                var thisField = edOpts.field;
                var $GRID = PHA_GridEditor.__GetJqGrid(thisGridId);
                var gridOptions = $GRID.datagrid('options');
                var index = gridOptions.editIndex;
                var gridRowData = $GRID.datagrid('getRows')[index];
                var colOpts = $GRID.datagrid('getColumnOption', thisField);
                PHA_GridEditor.__initCmbClick(this, colOpts, gridRowData);
            },
            // 重写loader方法,防止报错
            loader: PHA_GridEditor.__ComboBox_Loader
        }
        var _newOpts = $.extend({}, _defOpts, _opts);

        // 选中事件
        _newOpts.onSelect = function (record) {
            /* 获取Editor信息 */
            var $thisEditor = $(this);
            var edOpts = $thisEditor.combobox('options');
            var thisGridId = edOpts.gridID;
            var thisField = edOpts.field;
            var thisDescField = edOpts.descField;
            var $GRID = PHA_GridEditor.__GetJqGrid(thisGridId);
            var gridOptions = $GRID.datagrid('options');
            var index = PHA_GridEditor.CurEditIndex(gridOptions.curEidtCell);
            var field = PHA_GridEditor.CurEditField(gridOptions.curEidtCell);
            if (field != thisField) {
                return;
            }
            _opts.onSelect && _opts.onSelect.call(this, record);
            /* 更新后跳转下一个,combobox必须更新当前字段 */
            gridOptions.cellData[index + '-' + thisField] = record;
            var rowsData = $GRID.datagrid('getRows');
            var curRowData = rowsData[index];
            var tmpRowData = PHA_GridEditor.__deepCopy(curRowData);
            var _updRowFn = function () {
                var updData = {};
                if (PHA_GridEditor.AutoUpd) {
                    for (var k in tmpRowData) {
                        if (tmpRowData[k] != curRowData[k]) {
                            updData[k] = tmpRowData[k];
                        }
                    }
                }
                updData[field] = record[edOpts.valueField];
                var colOpts = $GRID.datagrid('getColumnOption', field);
                if (colOpts.descField) {
                    updData[colOpts.descField] = record[edOpts.textField];
                }
                $GRID.datagrid('updateRowData', {
                    index: index,
                    row: updData
                });
            }
            gridOptions.curEidtCell['isGoNext'] = true;
            if (_opts.onBeforeNext && _opts.onBeforeNext.call(this, record, tmpRowData, index) === false) {
                _updRowFn();
                return;
            }
            _updRowFn();
            PHA_GridEditor.Next(thisGridId, 1);
        }
        return {
            type: 'combobox',
            options: _newOpts
        };
    },
    /*
     * 4. 下拉表格
     * PHA_GridEditor.ComboGrid({})
     */
    ComboGrid: function (_opts, _lookup) {
        _opts = _opts || {};
        var _onBeforeLoad = _opts.onBeforeLoad;
        delete _opts.onBeforeLoad;
        var _defOpts = {
            _lookup: _lookup,
            missingMessage: null,
            qLen: 2,
            selectOnNavigation: false,
            panelWidth: 400,
            mode: 'remote',
            pagination: true,
            url: $URL,
            idField: 'RowId',
            textField: 'Description',
            autoExpand: true,
            isCombo: true,
            // delay: 200,
            keyHandler: {
                up: function (e) {
                    try {
                        $.fn.combogrid.defaults.keyHandler.up.call(this);
                        PHA_GridEditor.__go(this, 'combogrid', 'up', e);
                    } catch (ex) {}
                },
                down: function (e) {
                    try {
                        $.fn.combogrid.defaults.keyHandler.down.call(this);
                        PHA_GridEditor.__go(this, 'combogrid', 'down', e);
                    } catch (ex) {}
                },
                left: function (e) {
                    PHA_GridEditor.__go(this, 'combogrid', 'left', e);
                },
                right: function (e) {
                    PHA_GridEditor.__go(this, 'combogrid', 'right', e);
                },
                enter: function (e) {
                    try {
                        $.fn.combogrid.defaults.keyHandler.enter.call(this, e);
                        PHA_GridEditor.__go(this, 'combogrid', 'enter', e); // onSelect() -> Next()
                    } catch (ex) {
                        console.log(ex);
                    }
                },
                query: function (e) {
                    try {
                        $.fn.combogrid.defaults.keyHandler.query.call(this, e);
                    } catch (ex) {}
                }
            },
            columns: [[{
                        title: 'RowId',
                        field: 'RowId',
                        width: 80
                    }, {
                        title: 'Description',
                        field: 'Description',
                        width: 160
                    }
                ]
            ],
            onBeforeLoad: function (param) {
                param.QText = PHA_GridEditor.__isNullVal(param.q) ? '' : param.q;
                /* 获取Editor信息 */
                var $thisEditor = $(this);
                var edOpts = $thisEditor.datagrid('options');
                var thisGridId = edOpts.gridID;
                var thisField = edOpts.field;
                var thisDescField = edOpts.descField;
                var $GRID = PHA_GridEditor.__GetJqGrid(thisGridId);
                var gridOptions = $GRID.datagrid('options');
                var index = gridOptions.editIndex;
                var field = PHA_GridEditor.CurEditField(gridOptions.curEidtCell);
                var gridRowData = $GRID.datagrid('getRows')[index];
                /* 刚进入编辑状态时加载数据 */
                var idVal = gridRowData[thisField];
                var textVal = gridRowData[thisDescField];
                var isInitComp = $thisEditor.attr('init');
                $thisEditor.attr('init', 'Y');
                if ((!(isInitComp == 'Y')) &&
                    (!PHA_GridEditor.__isNullVal(idVal)) &&
                    (!PHA_GridEditor.__isNullVal(textVal))) {
                    var rowData = gridOptions.cellData[index + '-' + thisField];
                    if (rowData) {
                        $thisEditor.datagrid('loadData', [rowData]);
                        return false;
                    } else if (thisField !== field) {
                        /*
                        rowData = {};
                        rowData[edOpts.idField] = idVal;
                        rowData[edOpts.textField] = textVal;
                        rowData['_reload'] = true;
                        $thisEditor.datagrid('loadData', [rowData]); // 用setValue,但getEditor取不到
                        return false;
                         */
                    }
                    // yunhaibao, 2022-07-18, 不需要判断等于不等于, 初始化首次不掉后台
                    rowData = {};
                    rowData[edOpts.idField] = idVal;
                    rowData[edOpts.textField] = textVal;
                    rowData['_reload'] = true;
                    $thisEditor.datagrid('loadData', [rowData]); // 用setValue,但getEditor取不到
                    return false;
                }
                /* 检索文本参数 */
                if (typeof param.q == 'undefined') {
                    var ed = null;
                    try {
                        ed = $GRID.datagrid('getEditor', {
                            index: index,
                            field: thisField
                        });
                    } catch (e) {}
                    if (ed) {
                        var edText = $(ed.target)[ed.type]('getText');
                        param.QText = (param.QText == '') ? edText : '';
                    } else if (thisField == field) {
                        param.QText = (param.QText == '') ? textVal : '';
                    }
                    param.QText = PHA_GridEditor.__isNullVal(param.QText) ? '' : param.QText;
                }
                /* 最小字符数 */
                if (param.QText.length < edOpts.qLen) {
                    if (edOpts.isClear == true) {
                        edOpts.isClear = false;
                        return false;
                    }
                    edOpts.isClear = true;
                    $thisEditor.datagrid('loadData', []);
                    return false;
                }
                /* 其他参数 */
                var pFilter = {};
                $('#' + edOpts.cmgBarId).find('input[id]').each(function (index, item) {
                    var cls = $(item).prop("className") || '';
                    var clsFirst = cls.split(' ')[0];
                    var clsType = clsFirst.split('-')[0];
                    var id = $(item).prop("id") || '';
                    var idArr = id.split('_');
                    var name = idArr[idArr.length - 1];
                    if (clsType == 'validatebox' || clsType == 'textbox') {
                        param[name] = $(item).val();
                    } else {
                        param[name] = $(item)[clsType]('getValue');
                    }
                    pFilter[name] = param[name];
                });
                param.pFilterStr = JSON.stringify(pFilter);
                param.page = !param.page ? 1 : param.page;
                param.rows = !param.rows ? edOpts.pageSize : param.rows;
                /* 用户自定义 */
                if (_onBeforeLoad) {
                    return _onBeforeLoad.call(this, param, gridRowData);
                }
            },
            onShowPanel: function () {
                var cmg = $.data(this, 'combogrid');
                if (cmg) {
                    if ($(cmg.grid).attr('is_add_click') != 'Y') {
                        $(cmg.grid).attr('is_add_click', 'Y');
                        $(cmg.grid).parent().parent().on('click', function (e) {
                            e.stopPropagation();
                        });
                    }
                    PHA_GridEditor.__initCmgBar.call(this, cmg.grid);
                }
            },
            // 重写loader方法,防止报错
            loader: PHA_GridEditor.__ComboGrid_Loader
        }
        var _newOpts = $.extend({}, _defOpts, _opts);

        // 选中事件
        _newOpts.onSelect = function (rowIndex, rowData) {
            /* 获取Editor信息 */
            var $thisEditor = $(this);
            var edOpts = $thisEditor.datagrid('options');
            var thisGridId = edOpts.gridID;
            var thisField = edOpts.field;
            var thisDescField = edOpts.descField;
            var $GRID = PHA_GridEditor.__GetJqGrid(thisGridId);
            var gridOptions = $GRID.datagrid('options');
            var index = PHA_GridEditor.CurEditIndex(gridOptions.curEidtCell);
            var field = PHA_GridEditor.CurEditField(gridOptions.curEidtCell);
            if (field != thisField) {
                return;
            }
            if (edOpts._action == 'setValue') {
                edOpts._action = '';
                return;
            }
            _opts.onSelect && _opts.onSelect.call(this, rowIndex, rowData);
            /* 更新后跳转下一个,combogrid不更新当前字段 */
            gridOptions.cellData[index + '-' + field] = rowData;
            var rowsData = $GRID.datagrid('getRows');
            var curRowData = rowsData[index];
            var tmpRowData = PHA_GridEditor.__deepCopy(curRowData);
            var _updRowFn = function () {
                if (!PHA_GridEditor.AutoUpd) {
                    return;
                }
                var updData = {};
                for (var k in tmpRowData) {
                    if (k == thisField || k == thisDescField) {
                        continue;
                    }
                    if (tmpRowData[k] != curRowData[k]) {
                        updData[k] = tmpRowData[k];
                    }
                }
                $GRID.datagrid('updateRowData', {
                    index: index,
                    row: updData
                });
            }
            gridOptions.curEidtCell['isGoNext'] = true;
            if (_opts.onBeforeNext && _opts.onBeforeNext.call(this, rowData, tmpRowData, index) === false) {
                _updRowFn();
                return;
            }
            _updRowFn();
            PHA_GridEditor.Next(thisGridId, 1);
        }
        PHA_GridEditor.__addCmgBarId(_newOpts);
        return {
            type: 'combogrid',
            _lookup: _lookup,
            options: _newOpts
        };
    },
    LookUp: function (_opts) {
        return PHA_GridEditor.ComboGrid(_opts, 'lookup');
    },
    /*
     * 5. 日期框
     * PHA_GridEditor.DateBox({})
     */
    DateBox: function (_opts) {
        _opts = _opts || {};
        var _defOpts = {
            onBlur: $.fn.datebox.defaults.onBlur,
            missingMessage: null,
            autoExpand: true,
            keyHandler: {
                up: function (e) {
                    PHA_GridEditor.__go(this, 'datebox', 'up', e);
                },
                down: function (e) {
                    PHA_GridEditor.__go(this, 'datebox', 'down', e);
                },
                left: function (e) {
                    PHA_GridEditor.__go(this, 'datebox', 'left', e);
                },
                right: function (e) {
                    PHA_GridEditor.__go(this, 'datebox', 'right', e);
                },
                enter: function (e) {
                    try {
                        $.fn.datebox.defaults.keyHandler.enter.call(this, e);
                        PHA_GridEditor.__go(this, 'datebox', 'enter', e); // onSelect() -> Next()
                    } catch (ex) {
                        console.log(ex);
                    }
                },
                query: function (e) {
                    try {
                        $.fn.datebox.defaults.keyHandler.query.call(this, e);
                    } catch (ex) {}
                }
            },
            onShowPanel: function () {
                var r = $.data(this, 'datebox');
                if (r) {
                    if ($(r.calendar).attr('is_add_click') != 'Y') {
                        $(r.calendar).attr('is_add_click', 'Y');
                        $(r.calendar).parent().parent().on('click', function (e) {
                            e.stopPropagation();
                        });
                    }
                }
            }
        };
        var _newOpts = $.extend({}, _defOpts, _opts);
        // 选中事件
        _newOpts.onSelect = function (val) {
            var $thisEditor = $(this);
            var edOpts = $thisEditor.datebox('options');
            var thisGridId = edOpts.gridID;
            var thisField = edOpts.field;
            var val = (typeof val == 'string') ? val : $.fn.datebox.defaults.formatter(val);
            _opts.onSelect && _opts.onSelect.call(this, val);
            var $GRID = PHA_GridEditor.__GetJqGrid(thisGridId);
            var gridOptions = $GRID.datagrid('options');
            var index = PHA_GridEditor.CurEditIndex(gridOptions.curEidtCell);
            var field = PHA_GridEditor.CurEditField(gridOptions.curEidtCell);
            if (field != thisField) {
                return;
            }
            var rowsData = $GRID.datagrid('getRows');
            var curRowData = rowsData[index];
            var tmpRowData = PHA_GridEditor.__deepCopy(curRowData);
            var _updRowFn = function () {
                var updData = {};
                if (PHA_GridEditor.AutoUpd) {
                    for (var k in tmpRowData) {
                        if (tmpRowData[k] != curRowData[k]) {
                            updData[k] = tmpRowData[k];
                        }
                    }
                }
                if (typeof updData[thisField] == 'undefined') {
                    updData[thisField] = val;
                }
                $GRID.datagrid('updateRowData', {
                    index: index,
                    row: updData
                });
            }
            gridOptions.curEidtCell['isGoNext'] = true;
            if (_opts.onBeforeNext && _opts.onBeforeNext.call(this, val, tmpRowData, index) === false) {
                _updRowFn();
                return;
            }
            _updRowFn();
            PHA_GridEditor.Next(thisGridId, 1);
        }
        return {
            type: 'datebox',
            options: _newOpts
        };
    },
    /*
     * 6. 复选框 (可使用快捷键Y/N/Enter)
     * PHA_GridEditor.CheckBox({})
     */
    CheckBox: function (_opts) {
        _opts = _opts || {};
        var _defOpts = {
            on: 'Y',
            off: 'N',
            keyHandler: {
                38: function (e) {
                    PHA_GridEditor.__go(this, 'icheckbox', 'up', e);
                },
                40: function (e) {
                    PHA_GridEditor.__go(this, 'icheckbox', 'down', e);
                },
                37: function (e) {
                    PHA_GridEditor.__go(this, 'icheckbox', 'left', e);
                },
                39: function (e) {
                    PHA_GridEditor.__go(this, 'icheckbox', 'right', e);
                },
                13: function (e) {
                    PHA_GridEditor.__go(this, 'icheckbox', 'enter', e); // onSelect() -> Next()
                }
            }
        };
        var _newOpts = $.extend({}, _defOpts, _opts);
        _newOpts.onBeforeNext = function (val, curRowData, index) {
            var $thisEditor = $(this);
            var edOpts = $thisEditor.checkbox('options');
            var thisGridId = edOpts.gridID;
            var thisField = edOpts.field;
            var $GRID = PHA_GridEditor.__GetJqGrid(_opts.gridID);
            var gridOptions = $GRID.datagrid('options');
            var tmpRowData = PHA_GridEditor.__deepCopy(curRowData);
            if (_opts.onBeforeNext && _opts.onBeforeNext.call(this, val, tmpRowData, index) === false) {
                return false;
            }
            var _updRowFn = function () {
                var updData = {};
                if (PHA_GridEditor.AutoUpd) {
                    for (var k in tmpRowData) {
                        if (tmpRowData[k] != curRowData[k]) {
                            updData[k] = tmpRowData[k];
                        }
                    }
                }
                if (typeof updData[thisField] == 'undefined') {
                    updData[thisField] = val;
                }
                $GRID.datagrid('updateRowData', {
                    index: index,
                    row: updData
                });
            }
            _updRowFn();
        }
        return {
            type: 'icheckbox',
            options: _newOpts
        };
    },
    /*
     * 7. 弹窗, 弹窗主要操作如下:
     *  (1) [回车=保存=双击] -> 回调onClickSure + 关闭 + 回调onBeforeNext
     *  (2) [继续录入]       -> 回调onClickSure + 重新检索
     *  (3) [关闭]           -> 关闭 + 回调onBeforeNext
     * PHA_GridEditor.Window({})
     */
    Window: function (_opts, _trigger) {
        // 定义窗口操作方法
        var _win_on_close = function (_action) {};
        var _win_on_sure = function () {};
        var _win_on_continue = function () {};
        var _win = {
            open: function (_wOpts, _edOpts) {
                // 1. 获取主界面表格Cell的信息
                var $GRID = _wOpts.jqGrid;
                var gridOptions = $GRID.datagrid('options');
                var tGridID = gridOptions.id;
                var index = PHA_GridEditor.CurEditIndex(gridOptions.curEidtCell);
                var field = PHA_GridEditor.CurEditField(gridOptions.curEidtCell);
                var ed = $GRID.datagrid('getEditor', {
                    index: index,
                    field: field
                });
                if (!ed) {
                    return;
                }
                var cellVal = ed ? $(ed.target).val() : '';
                var colOpts = $GRID.datagrid('getColumnOption', field);
                colOpts.tmp_index = index;
                colOpts.tmp_value = cellVal;
                var chkCell = PHA_GridEditor.CheckCellVal(colOpts, true);
                if (chkCell != '') {
                    setTimeout(function () {
                        PHA_GridEditor.Edit({
                            gridID: tGridID,
                            index: index,
                            field: field,
                            actionType: 'win'
                        });
                    }, 0);
                    return;
                }
                $(ed.target).off('keydown').off('keypress').blur();
                var rowsData = $GRID.datagrid('getRows');
                var curRowData = rowsData[index];
                curRowData[field] = cellVal;
                // 2. 参数处理
                var winOptions = _wOpts.winOptions;
                var win = winOptions.win || {};
                var winId = win.id || 'PHA_GridEditor_Win';
                var grid = winOptions.grid;
                if (!grid.center) {
                    alert('grid必须包含center！！！');
                    return;
                }
                var panelCenterId = winId + '_' + 'pcenter';
                var gridCenterOpts = null,
                gridCenterId = winId + '_' + 'center';
                var gridOtherOpts = null,
                gridOtherId = '';
                // 3. 窗口布局
                var gridOtherHtmlStr = '';
                var gridCount = 0;
                for (var g in grid) {
                    gridCount++;
                    if (g == 'center') {
                        gridCenterOpts = grid[g];
                        continue;
                    }
                    gridOtherId = winId + '_' + g;
                    gridOtherOpts = grid[g];
                    gridOtherOpts.toolbar = '#' + gridOtherId + '_Bar';
                    gridOtherOpts.qTextId = gridOtherId + '_Text';
                    gridOtherOpts.fBtnId = gridOtherId + '_Find';
                    gridOtherHtmlStr = '';
                    gridOtherHtmlStr += '<div id="' + (gridOtherId + '_Bar') + '">';
                    gridOtherHtmlStr += '   <div style="margin-top:5px;margin-bottom:5px;">';
                    gridOtherHtmlStr += '       <div class="pha-col">';
                    gridOtherHtmlStr += '           <input id="' + gridOtherOpts.qTextId + '" class="hisui-searchbox"/>';
                    gridOtherHtmlStr += '       </div>';
                    gridOtherHtmlStr += '       <div class="pha-col" style="display:none;">';
                    gridOtherHtmlStr += '           <a id="' + gridOtherOpts.fBtnId + '" class="hisui-linkbutton" iconCls="icon-w-find">' + $g('查询') + '</a>';
                    gridOtherHtmlStr += '       </div>';
                    gridOtherHtmlStr += '   </div>';
                    gridOtherHtmlStr += '</div>';
                    gridOtherHtmlStr += '<div data-options="region:\'' + g + '\',width:' + (grid[g].width || 20) + ',height:' + (grid[g].height || 20) + ',border:false,split:true">';
                    gridOtherHtmlStr += '   <div class="hisui-panel" data-options="headerCls:\'panel-header-gray\',iconCls:\'icon-template\',fit:true" title="' + (grid[g].title || '') + '">';
                    gridOtherHtmlStr += '       <table id="' + gridOtherId + '"></table>';
                    gridOtherHtmlStr += '   </div>';
                    gridOtherHtmlStr += '</div>';
                }
                if (gridCount > 2) {
                    alert('开发者: grid最多只能包含两项！！！');
                    return;
                }
                var contentStr = '';
                contentStr += '<div class="hisui-layout" fit="true">';
                contentStr += ' <div data-options="region:\'center\',border:false" class="pha-body">';
                contentStr += '     <div class="hisui-layout" fit="true">';
                contentStr += '         ' + gridOtherHtmlStr;
                contentStr += '         <div data-options="region:\'center\',border:false,split:true">';
                contentStr += '             <div id="' + panelCenterId  + '" class="hisui-panel" data-options="headerCls:\'panel-header-gray\',iconCls:\'icon-template\',fit:true" title="' + (grid['center'].title || '') + '">';
                contentStr += '                 <table id="' + gridCenterId + '"></table>';
                contentStr += '             </div>';
                contentStr += '         </div>';
                contentStr += '     </div>';
                contentStr += ' </div>';
                contentStr += '</div>';
                // 4. 定义回调函数
                _win_on_close = function (_action) {
                    $('#' + winId).dialog('close');
                    if (PHA_GridEditor.isWinEditor === false) {
                        return;
                    }
                    PHA_GridEditor.isWinEditor = false;
                    var nSelData = null;
                    if (gridOtherId != '') {
                        nSelData = $('#' + gridOtherId).datagrid('getSelected');
                    }
                    var cSelData = $('#' + gridCenterId).datagrid('getSelected');
                    if (cSelData == null) {
                        PHA_GridEditor.Edit({
                            gridID: tGridID,
                            index: index,
                            field: field,
                            actionType: 'win'
                        });
                        return;
                    }
                    var winData = {
                        north: nSelData,
                        center: cSelData,
                        action: _action
                    };
                    var edGridId = _wOpts.gridID || tGridID;
                    if (edGridId) {
                        PHA_GridEditor.GridActive({
                            gridID: edGridId
                        });
                    }
                    var rowsData = $GRID.datagrid('getRows');
                    var curRowData = rowsData[index];
                    var tmpRowData = PHA_GridEditor.__deepCopy(curRowData);
                    _wOpts.onClose && _wOpts.onClose.call(ed.target, winData, tmpRowData, index);
                    var _updRowFn = function () {
                        var updData = {};
                        if (PHA_GridEditor.AutoUpd) {
                            for (var k in tmpRowData) {
                                if (tmpRowData[k] != curRowData[k]) {
                                    updData[k] = tmpRowData[k];
                                }
                            }
                        }
                        $GRID.datagrid('updateRowData', {
                            index: index,
                            row: updData
                        });
                    }
                    if (_wOpts.onBeforeNext && _wOpts.onBeforeNext.call(ed.target, winData, tmpRowData, index) === false) {
                        _updRowFn();
                        return;
                    }
                    _updRowFn();
                    PHA_GridEditor.Next(tGridID, 1);
                }
                _win_on_sure = function (_action) {
                    var nSelData = null;
                    var nRows = [];
                    if (gridOtherId != '') {
                        nSelData = $('#' + gridOtherId).datagrid('getSelected');
                    }
                    PHA_GridEditor.isWinEditor = false;
                    PHA_GridEditor.End(gridCenterId);
                    PHA_GridEditor.isWinEditor = true;
                    var cSelData = _win.getChanges(gridCenterId); // 获取修改的
                    var winData = {
                        north: nSelData,
                        center: cSelData,
                        action: _action
                    };
                    _wOpts.onClickSure && _wOpts.onClickSure.call(ed.target, winData);
                    if (_wOpts.reloadOnSure == true) {
                        _win.queryGrid(gridCenterId);
                    }
                }
                _win_on_continue = function () {
                    PHA_GridEditor.__endEditing(gridCenterId);
                    _win_on_sure('continue');
                    $('#' + gridOtherOpts.qTextId).searchbox('textbox', '');
                    $('#' + gridOtherOpts.qTextId).searchbox('textbox').focus();
                }
                // 5. 窗口初始化
                if ($('#' + winId).length == 0) {
                    $('<div id="' + winId + '"><div>').appendTo('body');
                    // 5.1 窗口
                    var winDef = {
                        width: 1050,
                        height: 680,
                        modal: true,
                        title: '请选择项目',
                        iconCls: 'icon-w-list',
                        content: contentStr,
                        closable: true
                    };
                    if (_wOpts.onClickSure) {
                        winDef.buttons = [{
                                text: '保存',
                                handler: function (e) {
                                    _win_on_sure('click');
                                    _win_on_close('click');
                                }
                            }, {
                                text: '继续录入(F2)',
                                handler: function (e) {
                                    _win_on_continue();
                                }
                            }, {
                                text: '关闭',
                                handler: function (e) {
                                    _win_on_close('close');
                                }
                            }
                        ]
                    }
                    var newWinOpts = $.extend({}, winDef, win);
                    $('#' + winId).dialog(newWinOpts);
                    // 5.2 其他表格(主表,可能没有)
                    var _gridDefOpts = {
                        url: '',
                        singleSelect: true,
                        pagination: true,
                        toolbar: [],
                        exportXls: false,
                        printOut: false,
                    };
                    if (gridOtherOpts) {
                        $('#' + winId).dialog('options').gridOtherId = gridOtherId;
                        gridOtherOpts.onSelect = function (rowIndex, rowData) {
                            var pJsonStr = JSON.stringify(rowData);
                            $('#' + gridCenterId).datagrid('options').queryParams.pJsonStr = pJsonStr;
                            _win.queryGrid(gridCenterId);
                        }
                        gridOtherOpts.onLoadSuccess = function (data) {
                            if (data.total > 0) {
                                $('#' + gridOtherId).datagrid('selectRow', 0); // 触发center查询
                            } else {
                                $('#' + gridCenterId).datagrid('clear');
                            }
                        }
                        var _newGridOpts = $.extend({}, _gridDefOpts, gridOtherOpts);
                        _win.initGrid(gridOtherId, _newGridOpts);
                        // 检索
                        gridCenterOpts.qTextId = gridOtherOpts.qTextId;
                        PHA.SearchBox(gridOtherOpts.qTextId, {
                            width: 280,
                            placeholder: '请输入药品代码、名称、别名检索...',
                            searcher: function () {
                                _win.queryGrid(gridOtherId);
                                _win.activeOther(gridOtherId, gridCenterId);
                                $(this).searchbox('setValue', '');
                            }
                        });
                        $('#' + gridOtherOpts.fBtnId).on('click', function (e) {
                            _win.queryGrid(gridOtherId);
                        });
                    } else {
                        gridCenterOpts.onSelect = function (rowIndex, rowData) {
                            _win.editCenter(gridCenterId, false); // 只有center的情况
                        }
                    }
                    // 5.3 中间表格(子表)
                    $('#' + winId).dialog('options').gridCenterId = gridCenterId;
                    gridCenterOpts.onDblClickRow = function (rowIndex, rowData) {
                        _win_on_sure('dblClick');
                        _win_on_close('dblClick');
                    }
                    gridCenterOpts.onLoadSuccess = function (data) {
                        if (data.total > 0) {
                            _win.editCenter(gridCenterId, false);
                            $(this).datagrid('selectRow', 0);
                        }
                    }
                    var _newGridOpts = $.extend({}, _gridDefOpts, gridCenterOpts);
                    _win.initGrid(gridCenterId, _newGridOpts);
                    // 5.3 中间表格(关键字查询). Huxt 2022-12-07
					if (gridCenterOpts.queryKeywords) {
						var $kw = $('<div style="position:absolute;top:-2px;right:2px;width:auto;"><div>').appendTo($('#' + panelCenterId).prev());
						$kw.keywords($.extend({
							singleSelect: false,
							onClick: function(vItem) {
								$('#' + gridCenterId).datagrid('options').$kw = $kw;
								_win.queryGrid(gridCenterId);
							}
						}, gridCenterOpts.queryKeywords));
						$('#' + gridCenterId).datagrid('options').$kw = $kw;
					}
                }
                // 6. 自动查询
                var gId = gridCenterId;
                if (gridOtherId != '') {
                    gId = gridOtherId;
                    var oParams = gridOtherOpts.queryParams || {};
                    oParams = $.extend({}, oParams, _wOpts.qParams);
                    oParams.QText = cellVal;
                    var goOpts = $('#' + gridOtherId).datagrid('options');
                    goOpts.Q_Text = cellVal;
                    goOpts.queryParams = oParams;
                    $('#' + goOpts.qTextId).val('');
                }
                var cParams = gridCenterOpts.queryParams || {};
                cParams = $.extend({}, cParams, _wOpts.qParams);
                cParams.QText = cellVal;
                var gcOpts = $('#' + gridCenterId).datagrid('options');
                gcOpts.Q_Text = cellVal;
                gcOpts.queryParams = cParams;
                _win.queryGrid(gId);
                _win.activeCenter(gridCenterId);
                _win.activeOther(gridOtherId, gridCenterId);
                // 7. 打开窗口
                $('#' + winId).dialog('open');
                PHA_GridEditor.isWinEditor = true;
            },
            initGrid: function (gId, gOpts) {
                gOpts.gridSave = false;
                gOpts.queryParams = gOpts.queryParams || {};
                delete gOpts['title'];
                PHA.Grid(gId, gOpts);
            },
            queryGrid: function (winGridID) {
                var dataGridOpts = $('#' + winGridID).datagrid('options');
                dataGridOpts.url = $URL;
                var qParams = dataGridOpts.queryParams || {};
                // QText
                var qText = dataGridOpts.qTextId ? $('#' + dataGridOpts.qTextId).searchbox('getValue') : '';
                if (!PHA_GridEditor.__isNullVal(qText)) {
                    qParams.QText = qText;
                } else {
                    qParams.QText = dataGridOpts.Q_Text;
                }
                // Keyword
				var kwStr = '';
				var $kw = dataGridOpts.$kw;
				if ($kw) {
					var sidArr = [];
					var selectedArr = $kw.keywords('getSelected') || [];
					for (var j = 0; j < selectedArr.length; j++) {
						sidArr.push(selectedArr[j].id);
					}
					kwStr = sidArr.join(',');
				}
				qParams.kwStr = kwStr;
				// Query
                $('#' + winGridID).datagrid('query', qParams);
            },
            activeOther: function (otherId, centerId) {
                if (otherId == '') {
                    return;
                }
                $('#' + centerId).datagrid('options').isEnter = false;
                PHA_GridEditor.GridActive({
                    gridID: otherId,
                    type: 'select',
                    gridKeyEvent: function (e) {
                        if (e.keyCode == 13) {
                            _win.editCenter(centerId, true);
                        }
                    }
                });
            },
            activeCenter: function (centerId) {
                PHA_GridEditor.GridActive({
                    gridID: centerId,
                    type: 'select',
                    gridKeyEvent: function (e) {
                        if (e.keyCode == 13) {
                            _win_on_sure('enter');
                            _win_on_close('enter');
                        }
                        if (e.keyCode == 113) {
                            _win_on_continue();
                        }
                    }
                });
            },
            editCenter: function(centerId, noCheck){
                var dgOpts = $('#' + centerId).datagrid('options');
                if (noCheck === false && dgOpts.isEnter !== true) {
                    return;
                }
                var efSort = dgOpts.editFieldSort;
                var stCol = (efSort && efSort.length > 0) ? efSort[0] : null;
                var colOpts = $('#' + centerId).datagrid('getColumnOption', stCol);
                if (colOpts && !colOpts.hidden) {
                    PHA_GridEditor.Edit({
                        gridID: centerId,
                        index: 0,
                        field: stCol
                    });
                }
                dgOpts.isEnter = true;
            },
            getChanges: function (gId) {
                var $_tdg = $('#' + gId);
                var tdgOpts = $_tdg.datagrid('options');
                if (tdgOpts.getDataWay) {
                    return $_tdg.datagrid('getChecked');
                }
                var efSort = tdgOpts.editFieldSort;
                var isInputData = function (rowData) {
                    if (!efSort || efSort.length <= 0) {
                        return true;
                    }
                    for (var f = 0; f < efSort.length; f++) {
                        var colOpts = $_tdg.datagrid('getColumnOption', efSort[f]);
                        if (colOpts) {
                            var colVal = rowData[efSort[f]];
                            /*if (parseFloat(colVal) == 0) {  //0也是有效数据，数值判断放到相关业务界面
                                continue;
                            }*/
                            if (!PHA_GridEditor.__isNullVal(colVal)) {
                                return true;
                            }
                        }
                    }
                    return false;
                }
                var cRetData = [];
                var cSelData = $_tdg.datagrid('getChanges');
                if (cSelData && cSelData.length > 0) {
                    for (var c = 0; c < cSelData.length; c++) {
                        if (isInputData(cSelData[c])) {
                            cRetData.push(cSelData[c]);
                        }
                    }
                }
                return cRetData;
            }
        };
        // 返回
        return PHA_GridEditor.ValidateBox({
            regExp: /\S/,
            regTxt: '请输入检索条件!',
            onBeforeNext: function (val, gridRowData, rowIndex) {
                var edOpts = $(this).validatebox('options');
                var $GRID = PHA_GridEditor.__GetJqGrid(edOpts.gridID);
                _opts.jqGrid = $GRID;
                _opts.qParams = {};
                if (_opts.onBeforeLoad && _opts.onBeforeLoad.call(this, _opts.qParams, gridRowData) === false) {
                    return false;
                }
                _win.open(_opts, edOpts);
                return false;
            }
        }, _trigger);
    },
    /*
     * checkbox的formatter函数
     * PHA_GridEditor.CheckBoxFormatter
     */
    CheckBoxFormatter: function (value, rowData, index) {
        if ((value == 'Y') || (value == 1)) {
            return PHA_COM.Fmt.Grid.Yes.Chinese;
        } else if ((value == 'N') || (value == 0)) {
            return PHA_COM.Fmt.Grid.No.Chinese;
        } else {
            return '';
        }
    },
    /*
     * 判断当前编辑的是否是最后一行
     * PHA_GridEditor.IsLastRow()
     */
    IsLastRow: function (gridID) {
        var $GRID = this.__GetJqGrid(gridID);
        var gridOptions = $GRID.datagrid('options');
        var index = this.CurEditIndex(gridOptions.curEidtCell);
        if (isNaN(index)) {
            return false;
        }
        var rowsData = $GRID.datagrid('getRows');
        if (rowsData.length - 1 == index) {
            return true;
        }
        return false;
    },
    /*
     * 获取当前编辑的行号
     * PHA_GridEditor.CurRowIndex()
     */
    CurRowIndex: function (gridID) {
        var $GRID = this.__GetJqGrid(gridID);
        var gridOptions = $GRID.datagrid('options');
        var rowsData = $GRID.datagrid('getRows');
        var curRowIndex = this.CurEditIndex(gridOptions.curEidtCell);
        if (rowsData.length < curRowIndex) {
            return undefined;
        }
        return curRowIndex;
    },
    /*
     * 获取当前编辑的行数据
     * PHA_GridEditor.CurRowData()
     */
    CurRowData: function (gridID) {
        gridID = this.__GetCurGridId(gridID);
        var curRowIndex = this.CurRowIndex(gridID);
        if (!(curRowIndex >= 0)) {
            return null;
        }
        var rowsData = $('#' + gridID).datagrid('getRows');
        return rowsData[curRowIndex];
    },
    CurEditIndex: function (curEidtCell) {
        var rIndex = parseInt(curEidtCell['index']); // == gridOptions.editIndex
        if (isNaN(rIndex)) {
            return parseInt(this.curEidtCell['index']);
        }
        return rIndex;
    },
    CurEditField: function (curEidtCell) {
        var rField = curEidtCell['field'];
        if (!rField) {
            return this.curEidtCell['field'];
        }
        return rField;
    },

    /*
     * 定义一些基础方法 - 不对外调用,在本js中调用
     */
    // 提示公共
    popoverTips: function (msg) {
        $.messager.popover({
            timeout: 1000,
            msg: msg,
            type: 'alert'
        });
    },
    // 获取数据类型
    __DataType: function (val) {
        return Object.prototype.toString.call(val);
    },
    // 上下键选择行
    __UpAndDown_Select: function (_opt) {
        var _gridID = _opt.gridID;
        var _ifUp = _opt.ifUp;
        // 获取选中的行
        var selectedData = $('#' + _gridID).datagrid('getSelected') || '';
        if (selectedData == '') {
            PHA_GridEditor.popoverTips('请先选择需要操作的行！');
            return false;
        }
        var rowsData = $('#' + _gridID).datagrid('getRows');
        var rowIndex = $('#' + _gridID).datagrid('getRowIndex', selectedData);
        // 验证
        if (_ifUp == true) {
            if (rowIndex == 0) {
                PHA_GridEditor.popoverTips('已到达第一行！');
                return false;
            } else {
                $('#' + _gridID).datagrid('selectRow', rowIndex - 1);
            }
        } else {
            if (rowIndex == rowsData.length - 1) {
                PHA_GridEditor.popoverTips('已到达最后一行！');
                return false;
            } else {
                $('#' + _gridID).datagrid('selectRow', rowIndex + 1);
            }
        }
        return true;
    },
    // 上下键交换行数据
    __UpAndDown_Exchange: function (_opt) {
        var _gridID = _opt.gridID;
        var _ifUp = _opt.ifUp;
        // 结束所有行编辑
        if (!this.__endEditing(_gridID)) {
            return false;
        }
        // 获取选中的行
        var selectedData = $('#' + _gridID).datagrid('getSelected') || '';
        if (selectedData == '') {
            PHA_GridEditor.popoverTips('请先选择需要操作的行！');
            return false;
        }
        var rowsData = $('#' + _gridID).datagrid('getRows');
        var rowIndex = $('#' + _gridID).datagrid('getRowIndex', selectedData);
        if (_ifUp == true) {
            if (rowIndex == 0) {
                PHA_GridEditor.popoverTips('已到达第一行！');
                return false;
            }
        } else {
            if (rowIndex == rowsData.length - 1) {
                PHA_GridEditor.popoverTips('已到达最后一行！');
                return false;
            }
        }
        var newSelectedData = this.__deepCopy(selectedData);
        // 交换行
        if (_ifUp == true) {
            $('#' + _gridID).datagrid('updateRow', {
                index: rowIndex,
                row: rowsData[rowIndex - 1]
            });
            $('#' + _gridID).datagrid('updateRow', {
                index: rowIndex - 1,
                row: newSelectedData
            });
            $('#' + _gridID).datagrid('selectRow', rowIndex - 1);
            _opt.onEnd && _opt.onEnd(rowIndex, rowIndex - 1); // 回调
        } else {
            $('#' + _gridID).datagrid('updateRow', {
                index: rowIndex,
                row: rowsData[rowIndex + 1]
            });
            $('#' + _gridID).datagrid('updateRow', {
                index: rowIndex + 1,
                row: newSelectedData
            });
            $('#' + _gridID).datagrid('selectRow', rowIndex + 1);
            _opt.onEnd && _opt.onEnd(rowIndex, rowIndex + 1); // 回调
        }
        return true;
    },
    // 拷贝对象
    __deepCopy: function (source) {
        var result = {};
        for (var key in source) {
            result[key] = typeof source[key] === 'object' ? this.__deepCopy(source[key]) : source[key];
        }
        return result;
    },
    // 兼容没有CellEditor - 调用此方法时下拉会开始加载数据
    __beginEditCell: function ($GRID, _options) {
        // 参数
        var index = _options.index;
        var field = _options.field;
        var gridOptions = $GRID.datagrid('options');
        // 使用CellEdit
        if (this.__isCellEdit(gridOptions)) {
            $GRID.datagrid('beginEditCell', {
                index: index,
                field: field
            });
            var ed = $GRID.datagrid('getEditor', {
                index: index,
                field: field
            });
            return ed;
        }
        // 行编辑 - 验证上一行
        if (gridOptions.curEidtCell) {
            var lastIndex = gridOptions.lastEditIndex;
            if (lastIndex >= 0 && index != lastIndex) {
                if (_options.forceEnd) {
                    $GRID.datagrid('forceEndEdit', lastIndex);
                } else {
                    if ($GRID.datagrid('validateRow', lastIndex) == false) {
                        gridOptions.editIndex = lastIndex;
                        gridOptions.lastEditIndex = lastIndex;
                        return null;
                    }
                    $GRID.datagrid('endEdit', lastIndex);
                }
            }
        }
        // 行编辑 - 开始下一行
        var ed = $GRID.datagrid('getEditor', {
            index: index,
            field: field
        });
        if (!ed) {
            $GRID.datagrid('beginEdit', index);
            ed = $GRID.datagrid('getEditor', {
                index: index,
                field: field
            });
        }
        if (!ed) {
            return null;
        }
        if (PHA_GridEditor.hasPanelArr.indexOf(ed.type) >= 0) {
            $(ed.target).next().eq(0).children().eq(0).focus();
        } else if (ed.type == 'icheckbox') {
            $(ed.target).next().eq(0).focus();
        } else {
            $(ed.target).focus();
        }
        return ed;
    },
    __endEditing: function (gridID) {
        var $GRID = $('#' + gridID);
        var gridOptions = $GRID.datagrid('options');
        if (this.__isCellEdit(gridOptions)) {
            var rowsData = $GRID.datagrid('getRows') || [];
            if (rowsData.length == 0) {
                return true;
            }
            gridOptions.isEnd = true;
            if (!$GRID.datagrid('endEditing')) {
                return false;
            }
            return true;
        }
        this.hasClickEventRows = [];
        var rowsData = $GRID.datagrid('getRows') || [];
        for (var i = 0; i < rowsData.length; i++) {
            var validateRow = $GRID.datagrid('validateRow', i);
            if (validateRow == false) {
                $GRID.datagrid('selectRow', i);
                return false;
            }
            $GRID.datagrid('endEdit', i);
        }
        return true;
    },
    __GetGridOpts: function (gridID) {
        var $GRID = this.__GetJqGrid(gridID);
        return $GRID.datagrid('options');
    },
    __GetJqGrid: function (gridID) {
        gridID = this.__GetCurGridId(gridID);
        return $('#' + gridID);
    },
    __GetCurGridId: function (gridID) {
        return (gridID == '' || typeof gridID == 'undefined') ? this.gridIdActive : gridID;
    },
    __ValidateRow: function ($GRID, gridOptions, index) {
        if (this.__isCellEdit(gridOptions)) {
            return true;
        }
        if (!$GRID.datagrid('validateRow', index)) {
            return false;
        }
        $GRID.datagrid('endEdit', index);
        return true;
    },
    __ComboBox_Loader: function (t, i, a) {
        var $cmb = $(this);
        var n = $cmb.combobox("options");
        if (!n.url) {
            return false;
        }
        $.ajax({
            type: n.method,
            url: n.url,
            data: t,
            dataType: "json",
            success: function (e) {
                var tmpCmb = $.data($cmb[0], "combobox");
                if (!tmpCmb) {
                    return;
                }
                i(e);
            },
            error: function () {
                a.apply(this, arguments);
            }
        });
    },
    __ComboGrid_Loader: function (e, t, i) {
        var $dg = $(this);
        if (!$.data($dg[0], "datagrid")) {
            return false;
        }
        var a = $dg.datagrid("options");
        if (!a.url) {
            return false;
        }
        if (a.singleRequest && a.currentAjax) {
            a.currentAjax.abort();
        }
        a.currentAjax = $.ajax({
            type: a.method,
            url: a.url,
            data: e,
            dataType: "json",
            success: function (e) {
                var pgr = $dg.datagrid("getPager");
                if (!pgr) {
                    return;
                }
                if ("undefined" !== typeof e.code) {
                    var i = e.data || {
                        total: 0,
                        rows: []
                    };
                    e.message = e.message || e.msg;
                    if (e.code != 200)
                        $.messager.alert(e.code, e.message, "error");
                    t(i);
                } else {
                    t(e);
                }
            },
            error: function () {
                var pgr = $dg.datagrid("getPager");
                if (!pgr) {
                    return;
                }
                i.apply(this, arguments);
            }
        });
    },
    __isNullVal: function (val) {
        if (val === '' || val === null || typeof val === 'undefined') {
            return true;
        }
        return false;
    },
    __getComboRecord: function (cData, cId, cField) {
        if (!cData) {
            return null;
        }
        var cl = cData.length;
        for (var r = 0; r < cl; r++) {
            if (cData[r][cField] == cId) {
                return cData[r];
            }
        }
        return null;
    },
    __getComboRow: function (gridRowData, colOpts) {
        if (!gridRowData)
            return null;
        var fVal = gridRowData[colOpts.field];
        var fTxt = gridRowData[colOpts.descField];
        if (!PHA_GridEditor.__isNullVal(fVal) &&
            !PHA_GridEditor.__isNullVal(fTxt)) {
            if (!colOpts.editor) {
                return null;
            }
            var edOpts = colOpts.editor.options;
            var cmbRow = {};
            cmbRow[edOpts.valueField] = fVal;
            cmbRow[edOpts.textField] = fTxt;
            return cmbRow;
        }
        return null;
    },
    __getAllCols: function (gridOpts) {
        var cols = gridOpts.columns[0];
        var frozenCols = gridOpts.frozenColumns ? gridOpts.frozenColumns[0] : undefined;
        if (typeof frozenCols !== 'undefined') {
            return frozenCols.concat(cols);
        } else {
            return cols;
        }
    },
    __cellBlur: function (gId, index, field) {
        if (field && index >= 0) {
            var ed = null;
            try {
                ed = $('#' + gId).datagrid('getEditor', {
                    index: index,
                    field: field
                });
            } catch (e) {}
            if (ed) {
                if (['validatebox', 'numberbox'].indexOf(ed.type) >= 0) {
                    $(ed.target).blur();
                }
                if (this.hasPanelArr.indexOf(ed.type) >= 0) {
                    $(ed.target).next().children().eq(0).blur();
                }
            }
        }
    },
    __isCellEdit: function (dgOpts) {
        return (dgOpts.isCellEdit === true);
    },
    __addCmgBarId: function (cmgOpts) {
        var toolbarItems = cmgOpts.toolbarItems;
        if (!toolbarItems || toolbarItems.length <= 0) {
            return;
        }
        if (!cmgOpts.toolbar) {
            cmgOpts.toolbar = [{
                    text: ''
                }
            ];
        } else {
            return;
        }
        this._cmgCount = !this._cmgCount ? 1 : this._cmgCount++;
        cmgOpts.cmgBarId = 'PHA_GridEditor_CmgBar' + this._cmgCount;
    },
    __initCmgBar: function (cmgDom) {
        var thisCmg = this;
        var cmgOpts = $(cmgDom).datagrid('options');
        if (!cmgOpts.cmgBarId) {
            return;
        }
        var $toolbar = $(cmgDom).parent().prev();
        var $cmgBarDiv = $toolbar.find('#' + cmgOpts.cmgBarId);
        if ($cmgBarDiv.length > 0) {
            return;
        }
        $toolbar.find('table').remove();
        if ($('#' + cmgOpts.cmgBarId).length > 0) {
            $('#' + cmgOpts.cmgBarId).remove();
        }
        var toolbarItems = cmgOpts.toolbarItems;
        var addHtml = '<div id="' + cmgOpts.cmgBarId + '" style="margin-top:5px;margin-bottom:5px;">';
        for (var t = 0; t < toolbarItems.length; t++) {
            var bId = cmgOpts.cmgBarId + '_' + toolbarItems[t].name;
            addHtml += '<div class="pha-col"'
            if (t == 0) {
                addHtml += ' style="margin-left:-6px;"';
            }
            addHtml += '><div><input id="' + bId + '" name="' + toolbarItems[t].name + '"/></div></div>';
        }
        addHtml += '</div>';
        $toolbar.append(addHtml);
        var _pha_ = {
            combobox: 'ComboBox',
            lookup: 'LookUp',
            validatebox: 'ValidateBox',
            numberbox: 'NumberBox',
            searchbox: 'ValidateBox', // 'SearchBox', 这不好使
            combogrid: 'ComboGrid',
            combotree: 'ComboTree',
            datebox: 'DateBox'
        }
        var notUseKey = [183, 91, 172, 144, 27, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 36, 35, 45, 46, 9, 20, 16, 255, 17, 91, 18];
        var thArr = [];
        var _loadCmg = function (ev) {
            ev.stopPropagation();
            if (notUseKey.indexOf(ev.keyCode) >= 0) {
                return;
            }
            for (var a = 0; a < thArr.length; a++) {
                clearTimeout(thArr[a]);
            }
            thArr = [];
            var tHandle = setTimeout(function () {
                var q = $(thisCmg).combogrid('getText');
                var dgOpts = $(cmgDom).datagrid('options');
                dgOpts.queryParams.q = q;
                $(cmgDom).datagrid('reload');
            }, 200);
            thArr.push(tHandle);
        }
        for (var t = 0; t < toolbarItems.length; t++) {
            var tbItem = toolbarItems[t];
            var bId = cmgOpts.cmgBarId + '_' + tbItem.name;
            PHA[_pha_[tbItem.type]](bId, tbItem);
            if (tbItem.type == 'validatebox' || tbItem.type == 'searchbox') {
                if (tbItem.width > 30) {
                    $('#' + bId).width(tbItem.width);
                }
            }
            if (tbItem.queryOnInput) {
                if (tbItem.type == 'searchbox') {
                    PHA_GridEditor.ToTriggerBox($('#' + bId), 'searchbox-button', 39);
                }
                if (tbItem.type == 'validatebox' || tbItem.type == 'searchbox') {
                    $('#' + bId).on('keydown', function (e) {
                        _loadCmg(e);
                    });
                }
            }
        }
    },
    __initCmbClick: function (edTarget, colOpts, gridRowData) {
        if (!colOpts) {
            return;
        }
        var edOpts = colOpts.editor.options;
        if (colOpts.editor.type != 'combobox') {
            return;
        }
        var $comp = $(edTarget).combobox('panel');
        var pEvents = $._data($comp[0], 'events');
        if (!pEvents.click) {
            return;
        }
        if (!pEvents.click[0].__handler) {
            pEvents.click[0].__handler = pEvents.click[0].handler;
        }
        pEvents.click[0].handler = function (e) {
            var itemSelected = $(e.target).closest('div.combobox-item').hasClass('combobox-item-selected');
            // 原函数
            pEvents.click[0].__handler.call($comp[0], e);
            e.stopPropagation();
            // 新增
            if (itemSelected) {
                var r = $.data(edTarget, 'combobox');
                var cmbRow = null;
                if (r) {
                    var val = $(edTarget).combobox('getValue');
                    cmbRow = PHA_GridEditor.__getComboRecord(r.data, val, edOpts.valueField);
                }
                if (cmbRow == null) {
                    cmbRow = PHA_GridEditor.__getComboRow(gridRowData, colOpts);
                }
                edOpts.onSelect.call(edTarget, cmbRow);
            }
        }
    },
    __isLiteCss: function () {
        if (typeof this.isLiteCss != 'undefined') {
            return this.isLiteCss;
        }
        this.isLiteCss = false;
        var linkArr = $('link');
        for (var l = 0; l < linkArr.length; l++) {
            var iLink = linkArr[l];
            if (iLink.href && iLink.href.indexOf('hisui.lite') > 0) {
                this.isLiteCss = true;
                break;
            }
        }
        return this.isLiteCss;
    },
    __go: function (target, type, nav, e) {
        // 相关参数
        var edOpts = {};
        if (type == 'icheckbox') {
            edOpts = $(target).checkbox('options');
        } else {
            edOpts = $(target)[type]('options');
        }
        if (!(edOpts.keyPropagation === true)) {
            e.stopPropagation();
        }
        var $GRID = $('#' + edOpts.gridID);
        var dgOpts = $GRID.datagrid('options');
        if (!dgOpts.curEidtCell) {
            return;
        }
        var index = PHA_GridEditor.CurEditIndex(dgOpts.curEidtCell);
        var field = PHA_GridEditor.CurEditField(dgOpts.curEidtCell);
        var gridRowData = $GRID.datagrid('getRows')[index];
        var panelState = 'hide';
        if (PHA_GridEditor.hasPanelArr.indexOf(type) >= 0) {
            var pDisplay = $(target)[type]('panel').parent().css('display');
            panelState = (pDisplay != 'none') ? 'show' : 'hide';
        }
        // 快捷操作
        switch (nav) {
        case 'up':
            _do_up();
            break;
        case 'down':
            _do_down();
            break;
        case 'left':
            _do_left()
            break;
        case 'right':
            _do_right();
            break;
        case 'enter':
            _do_enter();
            break;
        default:
            break;
        }
        // 定义操作函数
        function _do_up() {
            if (panelState == 'hide' && index > 0) {
                if (PHA_GridEditor.CheckNavigationTime(type) == true) {
                    if (PHA_GridEditor.__ValidateRow($GRID, dgOpts, index)) {
                        PHA_GridEditor.GoTo($GRID, index - 1, field, 'up', 1);
                    }
                }
            }
        }
        function _do_down() {
            var rowsData = $GRID.datagrid('getRows');
            if (panelState == 'hide' && index < rowsData.length - 1) {
                if (PHA_GridEditor.CheckNavigationTime(type) == true) {
                    if (PHA_GridEditor.__ValidateRow($GRID, dgOpts, index)) {
                        PHA_GridEditor.GoTo($GRID, index + 1, field, 'down', 1);
                    }
                }
            }
        }
        function _do_left() {
            var editFieldSort = dgOpts.editFieldSort;
            if (editFieldSort && editFieldSort.length > 0) {
                var currFieldIndex = editFieldSort.indexOf(field);
                if (currFieldIndex > 0) {
                    var nextField = editFieldSort[currFieldIndex - 1];
                    if (PHA_GridEditor.CheckNavigationTime(type) == true) {
                        PHA_GridEditor.GoTo($GRID, index, nextField, 'left', 1);
                    }
                }
            }
        }
        function _do_right() {
            var editFieldSort = dgOpts.editFieldSort;
            if (editFieldSort && editFieldSort.length > 0) {
                var currFieldIndex = editFieldSort.indexOf(field);
                if (currFieldIndex < editFieldSort.length - 1) {
                    var nextField = editFieldSort[currFieldIndex + 1];
                    if (PHA_GridEditor.CheckNavigationTime(type) == true) {
                        PHA_GridEditor.GoTo($GRID, index, nextField, 'right', 1);
                    }
                }
            }
        }
        function _do_enter() {
            if (['icheckbox'].indexOf(type) >= 0) {
                PHA_GridEditor.Next(edOpts.gridID, 1);
                return;
            }
            if (['validatebox', 'numberbox'].indexOf(type) >= 0) {
                _do_blur();
                edOpts.onEnter && edOpts.onEnter.call(target, gridRowData, edOpts); // Next()
                return;
            }
            // target has combo
            if (dgOpts.curEidtCell['isGoNext'] == true) {
                dgOpts.curEidtCell['isGoNext'] = false;
                return;
            }
            var val = $(target)[type]('getValue');
            if (['datebox'].indexOf(type) >= 0) {
                edOpts.onSelect.call(target, val); // Next()
                return;
            }
            if (['combobox'].indexOf(type) >= 0) {
                var r = $.data(target, "combobox");
                if (!r) {
                    return;
                }
                var cmbRow = PHA_GridEditor.__getComboRecord(r.data, val, edOpts.valueField);
                if (cmbRow == null) {
                    if (edOpts.onBeforeNext &&
                        edOpts.onBeforeNext.call(target, null, gridRowData, index) == false) {
                        return;
                    }
                    PHA_GridEditor.Next(edOpts.gridID, 1);
                    return;
                }
                edOpts.onSelect.call(target, cmbRow); // Next()
                return;
            }
            if (['combogrid', 'lookup'].indexOf(type) >= 0) {
                var cmg = $.data(target, type);
                if (!cmg) {
                    return;
                }
                var sRow = $(cmg.grid).datagrid('getSelected');
                var sIndex = $(cmg.grid).datagrid('getRowIndex', sRow);
                if (sRow == null) {
                    var rs = $(cmg.grid).datagrid('getRows');
                    if (rs.length == 1) {
                        sRow = gridOptions.cellData[index + '-' + field];
                    }
                    if (!sRow) {
                        if (edOpts.onBeforeNext &&
                            edOpts.onBeforeNext.call(cmg.grid, null, gridRowData, index) == false) {
                            return;
                        }
                        PHA_GridEditor.Next(edOpts.gridID, 1);
                        return;
                    }
                    sIndex = 0;
                }
                edOpts.onSelect.call(cmg.grid, sIndex, sRow); // Next()
                return;
            }
        }
        function _do_blur() {
            if (type == 'validatebox') {
                PHA_GridEditor.__cellBlur(edOpts.gridID, index, field);
            }
        }
        return;
    }
}

/**
 * 下拉表格scrollview加判断防止报错
 */
if (typeof scrollview !== 'undefined') {
    if (!scrollview.scrollingBase) {
        scrollview.scrollingBase = scrollview.scrolling;
        scrollview.scrolling = function (target) {
            var state = $.data(target, 'datagrid');
            if (state) {
                return scrollview.scrollingBase.call(this, target);
            }
        }
    }
}

/**
 * 某单元格是否修改过
 * @param {*} target #gridID
 * @param {*} index  行号
 * @param {*} field  列field名
 * @returns true|false
 * @example PHA_GridEditor.IsCellChanged('#gridItm', 2, 'manf')
 */
PHA_GridEditor.IsCellChanged = function (target, index, field) {
    return $(target)
    .parent()
    .find('[datagrid-row-index="' + index + '"] td[field=' + field + ']')
    .hasClass('datagrid-value-changed');
};

/**
 * 获取可见列
 * @param {*} target #gridID
 * @param {*} options.max               获取的最大列数, 取前几个可见的
 * @param {*} options.fmt2DescField true|false 是否需要转换为descfield
 * @returns ['field1', 'field2', ...]
 * @example PHA_GridEditor.GetShowColumnFields('#gridItm', 3)
 */
PHA_GridEditor.GetShowColumnFields = function (target, options) {
    options = options || {};
    max = options.max || 999;
    var retArr = [];
    var $target = $(target);
    var frozenColumns = $target.datagrid('getColumnFields', true);
    var normalColumns = $target.datagrid('getColumnFields');
    var fullColumns = frozenColumns.concat(normalColumns);
    for (var i = 0, length = fullColumns.length; i < length; i++) {
        var colName = fullColumns[i];
        var colOptions = $target.datagrid('getColumnOption', colName);
        if (colOptions.hidden == true) {
            continue;
        }
        if (colOptions.checkbox == true) {
            continue;
        }
        var field = colOptions.field;
        if (options.fmt2DescField === true && colOptions.descField) {
            field = colOptions.descField;
        }
        retArr.push(field);
        if (retArr.length >= max) {
            break;
        }
    }
    return retArr;
};

/**
 * 直接删除一些可编辑列的编辑器
 * @param {*} target       目标元素
 * @param {array} banFields 需要ban的列数组
 * @example PHA_GridEditor.BanGridEditors('#gridItm', ['qty','rp'])
 */
PHA_GridEditor.BanGridEditors = function (target, banFields) {
    if (target.indexOf('#') < 0) {
        target = '#' + target;
    }
    var $grid = $(target);
    for (var i = 0, length = banFields.length; i < length; i++) {
        var field = banFields[i];
        delete $grid.datagrid('getColumnOption', field).editor;
    }
}
/**
 * 保存时编辑表格, 如果最后一行无效, 直接删除
 * @param {*} target dom目标
 * @param {array} fields  需要判断的field, 并列关系
 * @example PHA_GridEditor.GridFinalDone('#gridItm', 'inci')
 *          PHA_GridEditor.GridFinalDone('#gridItm', ['inci', 'itmId'])
 */
PHA_GridEditor.GridFinalDone = function (target, fields) {
    if (target.indexOf('#') < 0) {
        target = '#' + target;
    }
    if (typeof fields === 'string') {
        fields = [fields];
    }
    /* 完成编辑行的编辑状态 */
    var editIndex = $(target).datagrid('options').editIndex;
    if (editIndex || editIndex == 0) {
        $(target).datagrid('forceEndEdit', editIndex);
    }
    var rows = $(target).datagrid('getRows');
    var len = rows.length;
    if (len > 0) {
        var lastRow = rows[len - 1];
        for (var i = 0, length = fields.length; i < length; i++) {
            var field = fields[i];
            var lastRowFieldVal = lastRow[field] || '';
            if (lastRowFieldVal !== '') {
                return;
            }
        }
        $(target).datagrid('deleteRow', len - 1);
    }
};
/**
 * 获取可见的发生改变的行
 * @param {*} target 目标ID
 * @returns
 */
PHA_GridEditor.GetChangedRows = function (target) {
    if (target.indexOf('#') < 0) {
        target = '#' + target;
    }
    var $grid = $(target);
    var retRows = [];
    var rows = $grid.datagrid('getRows');
    var changedRows = $grid.datagrid('getChanges');
    var retRows = rows.filter(function (ele, index) {
        return changedRows.indexOf(ele) >= 0;
    });
    return retRows;
};
/**
 * 表格是否处于编辑状态, 体现为界面有可编辑元素
 * @param {*} target 目标ID
 * @returns
 */
PHA_GridEditor.IsGridEditing = function (gridID) {
    var curRowIndex = PHA_GridEditor.CurRowIndex(gridID);
    if (isNaN(curRowIndex)) {
        return false;
    }
    var editors = $('#' + gridID).datagrid('getEditors', curRowIndex);
    return editors.length > 0 ? true : false;
};
/**
 * 通过loaddata的形式加载数据,并置脏数据
 * @param {} target
 * @param {*} data 表格数据
 * @example PHA_GridEditor.LoadChangedRows('#gridItm',{ total: rows.length, rows: rows })
 */
PHA_GridEditor.LoadChangedRows = function (target, data) {
    if (target.indexOf('#') < 0) {
        target = '#' + target;
    }
    $(target).datagrid('loadData', data)
    $.data($(target)[0], 'datagrid').updatedRows = data.rows;
    $(target).parent().find('.datagrid-body [datagrid-row-index]').find('[field="qty"]').addClass('datagrid-value-changed');
};
/**
 * 某行是否修改过
 * @param {*} target #gridID
 * @param {*} index  行号
 * @param {*} field  列field名
 * @returns true|false
 * @example PHA_GridEditor.IsRowChanged('#gridItm', 2)
 */
PHA_GridEditor.IsRowChanged = function (target, index) {
    return $(target)
    .parent()
    .find('[datagrid-row-index="' + index + '"] td')
    .hasClass('datagrid-value-changed');
};
/**
 * 删除无用行, 如果指定的fields同时为空, 则直接删除行数据, 一般用于新增行后直接点击保存时
 * @param {*} target #gridID
 * @param {*} index  行号
 * @param {*} field  列field名
 * @returns true|false
 * @example PHA_GridEditor.DeleteNullRow('#gridItm', ['inciCode'])
 */
PHA_GridEditor.DeleteNullRow = function (target, fields) {
    if (target.indexOf('#') < 0) {
        target = '#' + target;
    }
    if (typeof fields === 'string') {
        fields = [fields];
    }
    var rows = $(target).datagrid('getRows');
    var len = rows.length;
    if (len > 0) {
        var lastRow = rows[len - 1];
        for (var i = 0, length = fields.length; i < length; i++) {
            var field = fields[i];
            var lastRowFieldVal = lastRow[field] || '';
            if (lastRowFieldVal !== '') {
                return;
            }
        }
        $(target).datagrid('deleteRow', len - 1);
    }
};
