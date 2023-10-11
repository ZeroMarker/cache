/**
 * @description 药品维护-药学分类
 */
function DHCPHCCAT() {
    $.parser.parse('#lyDHCPHCCat');
    InitTreeGridDHCPHCCat();
    $('#conPHCCatAlias').on('keypress', function (event) {
        if (window.event.keyCode == '13') {
	        QueryDHCPHCCAT()       
        }
    });
    $('#btnFindPHCCat').on('click', QueryDHCPHCCAT);
    $('#btnSaveDHCPHCCat').on('click', function () {
        PHA.Confirm($g('提示'), $g('您确认保存吗?'), function () {
            SaveDHCPHCCat('');
        });
    });
    $('#btnSaveDHCPHCCatS').on('click', function () {
        PHA.Confirm($g('提示'), $g('您确认保存为同级吗?'), function () {
            SaveDHCPHCCat('S');
        });
    });
    $('#btnSaveDHCPHCCatI').on('click', function () {
        PHA.Confirm($g('提示'), $g('您确认保存为下级吗?'), function () {
            SaveDHCPHCCat('I');
        });
    });
    $('#btnAddDHCPHCCat').on('click', function () {
        PHA.Confirm($g('提示'), $g('您确认清屏吗?'), function () {
            AddDHCPHCCat();
        });
    });
    $('#btnDelDHCPHCCat').on('click', function () {
        PHA.Confirm($g('提示'), $g('您确认删除吗?'), function () {
            DelDHCPHCCat();
        });
    });
    MakeToolTip();
}
function QueryDHCPHCCAT(){
    $('#treegridDHCPHCCat').treegrid('options').queryParams.InputStr = '^^' + $('#conPHCCatAlias').val();
    $('#treegridDHCPHCCat').treegrid('reload');
    $('#conPHCCatAlias').val('').focus();
    $('#treegridDHCPHCCat').treegrid('unselectAll'); 	
}

/**
 * @description 初始化药学分类树形表格
 */
function InitTreeGridDHCPHCCat() {
    var treeColumns = [
        [
            {
                field: 'phcCatDesc',
                title: $g('药学分类'),
                width: 700
            },
            {
                field: 'phcCatCode',
                title: $g('代码'),
                width: 200,
                hidden: false
            },
            {
                field: 'phcCatLevel',
                title: $g('级别'),
                width: 100,
                align: 'center',
                hidden: false
            },

            {
                field: 'phcCatId',
                title: 'phcCatId',
                hidden: true
            },
            {
                field: '_parentId',
                title: 'parentId',
                hidden: true
            },
            {
                field: 'phcCatParent',
                title: $g('父级Id'),
                hidden: true
            }
        ]
    ];
    var dataOptions = {
        idField: 'phcCatId',
        treeField: 'phcCatDesc',
        rownumbers: false, //行号
        columns: treeColumns,
        queryParams: {
            ClassName: 'PHA.IN.DHCPHCCat.Query',
            QueryName: 'DHCPHCCat',
            page: 1,
            rows: 9999
        },
        toolbar: '#treegridDHCPHCCatBar',
        onClickRow: function (rowId) {
            $.cm(
                {
                    ClassName: 'PHA.IN.DHCPHCCat.Query',
                    MethodName: 'SelectDHCPHCCat',
                    PHCCatId: rowId,
                    ResultSetType: 'Array'
                },
                function (arrData) {
                    PHA.SetVals(arrData);
                    $('#phcCatCode').focus();
                }
            );
        },
        onExpand: function () {
            // $(this).treegrid("reload",3)
        },
        onLoadSuccess: function () {
            PHA.DomData('#dataDHCPHCCat', {
                doType: 'clear'
            });
            $('#phcCatDescAll').val('');
            var selectNode = $(this).treegrid('getSelected');
            if (selectNode !== null) {
                $(this).treegrid('options').onClickRow.call(this, selectNode.phcCatId);
            }
        }
    };
    PHA.TreeGrid('treegridDHCPHCCat', dataOptions);
}

/**
 * @description 新增
 */
function AddDHCPHCCat() {
    var tgSelect = $('#treegridDHCPHCCat').treegrid('getSelected') || '';
    if (tgSelect == '') {
        PHA.Popover({
            msg: $g('请先选中需要保存的药学分类'),
            type: 'alert'
        });
        return;
    }
    PHA.DomData('#dataDHCPHCCat', {
        doType: 'clear'
    });
    $('#phcCatCode').focus();
}

/**
 * @description 保存
 * @param {String} saveType 保存方式(S:保存为同级,I:保存为下级,"":保存当前)
 */
function SaveDHCPHCCat(saveType) {
    var tgSelect = $('#treegridDHCPHCCat').treegrid('getSelected') || '';
    if (tgSelect == '') {
        PHA.Popover({
            msg: $g('请先选中需要保存的药学分类'),
            type: 'alert'
        });
        return;
    }
    var phcCatPar = '';
    var phcCatId = '';
    if (saveType == '') {
        phcCatId = tgSelect.phcCatId;
        phcCatPar = tgSelect.phcCatParent;
    } else if (saveType == 'S') {
        // 保存为同级
        phcCatPar = tgSelect.phcCatParent;
    } else if (saveType == 'I') {
        // 保存为下级
        phcCatPar = tgSelect.phcCatId;
    }
    var valsArr = PHA.DomData('#dataDHCPHCCat', {
        doType: 'save'
    });
    var valsStr = valsArr.join('^');
    if (valsStr == '') {
        return;
    }
    var saveRet = $.cm(
        {
            ClassName: 'PHA.IN.DHCPHCCat.Save',
            MethodName: 'Save',
            PHCCatId: phcCatId,
            DataStr: phcCatPar + '^' + valsStr,
            dataType: 'text'
        },
        false
    );
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert($g('提示'), saveInfo, 'warning');
        return;
    } else {
        PHA.Popover({
            msg: $g('保存成功'),
            type: 'success'
        });
        ReloadPhcCatTreeById(tgSelect.phcCatId);
    }
}

/**
 * @description 删除
 */
function DelDHCPHCCat() {
    var tgSelect = $('#treegridDHCPHCCat').treegrid('getSelected') || '';
    if (tgSelect == '') {
        PHA.Popover({
            msg: $g('请先选中需要删除的药学分类'),
            type: 'alert'
        });
        return;
    }
    var phcCatId = tgSelect.phcCatId;
    var saveRet = $.cm(
        {
            ClassName: 'PHA.IN.DHCPHCCat.Save',
            MethodName: 'Delete',
            PHCCatId: phcCatId,
            dataType: 'text'
        },
        false
    );
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Alert($g('提示'), saveInfo, 'warning');
        return;
    } else {
        PHA.Popover({
            msg: $g('删除成功'),
            type: 'success'
        });
        $('#treegridDHCPHCCat').treegrid('reload');
        $('#treegridDHCPHCCat').treegrid('unselectAll');
        PHA.DomData('#dataDHCPHCCat', {
            doType: 'clear'
        });
        $('#phcCatDescAll').val('');
    }
}

/**
 * 根据选中的药学Id,重新加载刷新
 */
function ReloadPhcCatTreeById(phcCatId) {
    if (phcCatId != undefined && phcCatId != '') {
        var parentObj = $('#treegridDHCPHCCat').treegrid('getParent', phcCatId);
        if (parentObj == null) {
            $('#treegridDHCPHCCat').treegrid('reload');
        } else {
            needLoadId = parentObj.phcCatId;
            if (needLoadId) {
                $('#treegridDHCPHCCat').treegrid('reload', needLoadId);
            }
        }
        return;
    }
    var selectNode = $('#treegridDHCPHCCat').treegrid('getSelected');
    if (selectNode == null) {
        $('#treegridDHCPHCCat').treegrid('reload');
        return;
    }
    var selectId = selectNode.phcCatId;
    var needLoadId = selectId;
    var childLen = $('#treegridDHCPHCCat').treegrid('getChildren', selectId).length;
    if (childLen == 0) {
        needLoadId = $('#treegridDHCPHCCat').treegrid('getParent', selectId).phcCatRowId;
    }
    $('#treegridDHCPHCCat').treegrid('reload', needLoadId);
}
