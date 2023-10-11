var RET_QUICKMODIFY = function (linkGridID, components, com) {
    var linkGridTarget = '#' + linkGridID
    components('Reason', 'reason-quick');
    PHA_EVENT.Bind('#btnModify', 'click', function () {
        if ($(linkGridTarget).datagrid('getChecked').length === 0) {
            components('Pop', '请先勾选需要修改的记录');
            return;
        }
        $('#winRetQuickModify')
            .window({
                closable: false,
                collapsible: false,
                maximizable: false,
                minimizable: false
            })
            .window('open');
    });
    PHA_EVENT.Bind('#btnClose-quick', 'click', function () {
        $('#winRetQuickModify').window('close');
    });
    PHA_EVENT.Bind('#btnModifyAll-quick', 'click', function () {
        ExecuteModify('ModifyAll');
    });
    PHA_EVENT.Bind('#btnModify-quick', 'click', function () {
        ExecuteModify('Modify');
    });

    function ExecuteModify(type) {
        var modifyJson = GetQuickModifyJson();
        var rowArr = [];
        var rows = $(linkGridTarget).datagrid('getRows');
        var checkedRows = $(linkGridTarget).datagrid('getChecked')
        for (var i = 0, length = checkedRows.length; i < length; i++) {
            var checkedRowsRow = checkedRows[i];
            var rowIndex = rows.indexOf(checkedRowsRow);
            if (rowIndex >= 0) {
                var copyModifyJson = {};
                if (type === 'Modify') {
                    for (var key in modifyJson) {
                        if (checkedRowsRow[key] == '' || checkedRowsRow[key] === undefined) {
                            copyModifyJson[key] = modifyJson[key];
                        }
                    }
                } else {
                    copyModifyJson = $.extend({}, modifyJson);
                }
                rowArr.push({
                    index: rowIndex,
                    row: copyModifyJson
                });
            }
        }
        rowArr.forEach(function (ele) {
            $(linkGridTarget).datagrid('updateRowData', ele);
        });
    }
    function GetQuickModifyJson() {
        var retObj = {};
        if ($('[for = reason-quick]').checkbox('getValue') === true) {
            retObj.reason = $('#reason-quick').combobox('getValue') || '';
            retObj.reasonDesc = $('#reason-quick').combobox('getText') || '';
        }
        if ($('[for = invNo-quick]').checkbox('getValue') === true) {
            retObj.invNo = $('#invNo-quick').val() || '';
        }
        if ($('[for = invDate-quick]').checkbox('getValue') === true) {
            retObj.invDate = $('#invDate-quick').datebox('getValue') || '';
        }
        return retObj;
    }
    $('#winRetQuickModify').panel('resize', { width: $('#winRetQuickModify').width() + 42 });
};

