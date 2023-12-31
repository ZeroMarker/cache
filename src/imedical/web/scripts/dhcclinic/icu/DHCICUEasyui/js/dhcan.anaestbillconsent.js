var editIndex;
var selfPaidBillConsent = {
    DrugGrid: null,
    MaterialGrid: null,
    DrugData: null,
    MaterialData: null,
    Drugs: null,
    Materials: null,
    recordSheetID: null,
    operSchedule: null
}
$(function() {
    operDataManager.initFormData(loadApplicationData);
    selfPaidBillConsent.recordSheetID = session['RecordSheetID'];
    selfPaidBillConsent.DrugGrid = $('#selfPaidDrugGrid');
    selfPaidBillConsent.MaterialGrid = $('#selfPaidMaterialGrid');

    selfPaidBillConsent.DrugGrid.datagrid({
        title: '自费药品',
        fit: true,
        idField: 'RowId',
        headerCls: 'panel-header-gray',
        singleSelect: true,
        toolbar: [{
            iconCls: 'icon-add',
            text: '添加',
            disabled: !selfPaidBillConsent.recordSheetID,
            handler: function() {
                addDrugDataView.open();
            }
        }],
        columns: [
            [
                { title: 'RowId', field: 'RowId', width: 160, hidden: true },
                { title: '药品名称', field: 'DrugDesc', width: 160 },
                { title: '规格', field: 'Specification', width: 80, editor: { type: 'validatebox' } },
                { title: '单价', field: 'Price', width: 80, editor: { type: 'numberbox', options: { precision: 2 } } },
                { title: '数量', field: 'Qty', width: 80, editor: { type: 'numberbox' } },
                { title: '备注', field: 'Note', width: 120, editor: { type: 'validatebox' } },
                {
                    title: '操作',
                    field: 'Operator',
                    width: 40,
                    formatter: function(value, row, index) {
                        var html = '<a href="#" class="gridcell-button icon-remove btn-delete" onclick="javascript:deleteDrugData(' + row.RowId + ');" title="删除此行"' +
                            'data-rowid="' + row.RowId + '"</a>';
                        return html;
                    }
                }
            ]
        ]
    });

    selfPaidBillConsent.MaterialGrid.datagrid({
        title: '一次性自费诊疗项目',
        fit: true,
        idField: 'RowId',
        headerCls: 'panel-header-gray',
        singleSelect: true,
        toolbar: [{
            iconCls: 'icon-add',
            text: '添加',
            disabled: !selfPaidBillConsent.recordSheetID,
            handler: function() {
                addMaterialDataView.open();
            }
        }],
        columns: [
            [
                { title: '项目名称', field: 'MaterialDesc', width: 160 },
                { title: '单价', field: 'Price', width: 80, editor: { type: 'numberbox', options: { precision: 2 } } },
                { title: '数量', field: 'Qty', width: 80, editor: { type: 'numberbox' } },
                { title: '备注', field: 'Note', width: 120, editor: { type: 'validatebox' } },
                {
                    title: '操作',
                    field: 'Operator',
                    width: 40,
                    formatter: function(value, row, index) {
                        var html = '<a href="#" class="gridcell-button icon-remove btn-delete" onclick="javascript:deleteMaterialData(' + row.RowId + ');" title="删除此行"' +
                            'data-rowid="' + row.RowId + '"</a>';
                        return html;
                    }
                }
            ]
        ]
    })

    selfPaidBillConsent.DrugGrid.datagrid("enableCellEditing");
    selfPaidBillConsent.MaterialGrid.datagrid("enableCellEditing");

    addDrugDataView.init();
    loadDrugItem();

    addMaterialDataView.init();
    loadMaterialItem();

    loadDrugData();
    loadMaterialData();

    $("#btnPatSignature,#btnDocSignature").linkbutton({
        onClick: function() {
            var signCode = $(this).attr("data-signcode");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode
            });
            signView.initView();
            signView.open();
        }
    });

    $('#btnSave').click(function() {
        saveGrids();
    });

    $('#btnPrint').click(function() {
        print();
    })
});

/**
 * 根据手术申请数据，设置病人信息表单元素的值。
 * @param {object} operApplication 手术申请数据对象
 */
function loadApplicationData(operApplication) {
    selfPaidBillConsent.operSchedule = operApplication;
}

function getConfigData() {
    var result = null;
    $.ajaxSettings.async = false;
    $.getJSON("../service/dhcanop/data/anaestbillconsent.json?random=" + Math.random(), function(data) {
        result = data;
    }).error(function(message) {
        alert(message);
    });
    $.ajaxSettings.async = true;
    return result;
}

function loadDrugItem() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindSelfPaidDrug',
        Arg1: session['DeptID'],
        ArgCnt: 1
    }, 'json', true, function(data) {
        addDrugDataView.render(data);
    })
}

function loadMaterialItem() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindSelfPaidMaterial',
        Arg1: session['DeptID'],
        ArgCnt: 1
    }, 'json', true, function(data) {
        addMaterialDataView.render(data);
    })
}

function loadDrugData() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: 'FindSelfPaidDrugData',
        Arg1: session['RecordSheetID'],
        ArgCnt: 1
    }, 'json', true, function(data) {
        selfPaidBillConsent.DrugData = data;
        selfPaidBillConsent.DrugGrid.datagrid('loadData', data);
        addDrugDataView.refreshStatus(data);
    })
}

function loadMaterialData() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.DataQueries,
        QueryName: 'FindSelfPaidMaterialData',
        Arg1: session['RecordSheetID'],
        ArgCnt: 1
    }, 'json', true, function(data) {
        selfPaidBillConsent.MaterialData = data;
        selfPaidBillConsent.MaterialGrid.datagrid('loadData', data);
        addMaterialDataView.refreshStatus(data);
    })
}

function deleteDrugData(rowId) {
    var rowIndex = selfPaidBillConsent.DrugGrid.datagrid('getRowIndex', rowId);
    var rows = selfPaidBillConsent.DrugGrid.datagrid('getRows');
    var record = rows[rowIndex];

    $.messager.confirm('删除确认', '确定删除此行：' +
        record.DrugDesc + ' ' +
        record.Specification + '...',
        function(confirmed) {
            if (confirmed) {
                var result = dhccl.removeData(ANCLS.Model.SelfPaidDrugData, rowId);
                if (result.indexOf("S^") === 0) {
                    loadDrugData();
                    $('#deleteSuccess_dialog').show();
                    $('#deleteSuccess_dialog').css({ opacity: 1 });
                    setTimeout(function() {
                        $('#deleteSuccess_dialog').animate({ opacity: 0 }, 3000, 'swing', function() {
                            $('#deleteSuccess_dialog').hide();
                        });
                    }, 1000);
                } else {
                    dhccl.showMessage(result, "删除自费药品");
                }
            }
        });
}

function deleteMaterialData(rowId) {
    var rowIndex = selfPaidBillConsent.MaterialGrid.datagrid('getRowIndex', rowId);
    var rows = selfPaidBillConsent.MaterialGrid.datagrid('getRows');
    var record = rows[rowIndex];

    $.messager.confirm('删除确认', '确定删除此行：' +
        record.MaterialDesc + '...',
        function(confirmed) {
            if (confirmed) {
                var result = dhccl.removeData(ANCLS.Model.SelfPaidMaterialData, rowId);
                if (result.indexOf("S^") === 0) {
                    loadMaterialData();
                    $('#deleteSuccess_dialog').show();
                    $('#deleteSuccess_dialog').css({ opacity: 1 });
                    setTimeout(function() {
                        $('#deleteSuccess_dialog').animate({ opacity: 0 }, 3000, 'swing', function() {
                            $('#deleteSuccess_dialog').hide();
                        });
                    }, 1000);
                } else {
                    dhccl.showMessage(result, "删除一次性自费项目");
                }
            }
        });
}

function saveGrids() {
    var userId = session['UserID'];
    var savingDatas = [];
    var rows = selfPaidBillConsent.DrugGrid.datagrid('getRows');
    var className = ANCLS.Model.SelfPaidDrugData;
    prepareSavingDatas(rows, className);

    var rows = selfPaidBillConsent.MaterialGrid.datagrid('getRows');
    var className = ANCLS.Model.SelfPaidMaterialData;
    prepareSavingDatas(rows, className);

    dhccl.saveDatas(ANCSP.DataListService, {
        ClassName: ANCLS.BLL.SelfPaidConsent,
        MethodName: "SaveData",
        jsonData: dhccl.formatObjects(savingDatas)
    }, function(result) {
        if (result.indexOf("S^") === 0) {
            loadDrugData();
            loadMaterialData();
            $('#saveSuccess_dialog').show();
            $('#saveSuccess_dialog').css({ opacity: 1 });
            setTimeout(function() {
                $('#saveSuccess_dialog').animate({ opacity: 0 }, 3000, 'swing', function() {
                    $('#saveSuccess_dialog').hide();
                });
            }, 1000);
        } else {
            dhccl.showMessage(result, "添加自费药品");
        }
    });

    function prepareSavingDatas(rows, className) {
        var length = rows.length;
        for (var i = 0; i < length; i++) {
            var row = rows[i];
            savingDatas.push($.extend(row, {
                UpdateUserID: userId,
                ClassName: className
            }));
        }
    }
}

var drugView = {
    render: function(container, data) {
        container.empty();
        container.data('data', data);
        data.target = container;

        var isAdded = false;
        if (data.isAdded) {
            container.addClass('drug-item-added');
            container.attr('title', '此药品已添加');
            isAdded = true;
        } else {
            container.removeClass('drug-item-added');
            container.attr('title', '');
        }

        var id = 'd_f_r_i_' + data.RowId + '_c';
        var checkObj = $('<input id="' + id + '" type="checkbox">').appendTo(container);
        container.append('<label for="' + id + '"><span><span>' + data.Description + '</span><span>' +
            data.Specification + '</span></label>');
        checkObj.checkbox({
            id: id,
            checked: data.isChecked,
            disabled: isAdded,
            onChecked: function() {
                data.isChecked = true;
            },
            onUnchecked: function() {
                data.isChecked = false;
            }
        });
    }
}

var addDrugDataView = {
    init: function() {
        this.dom = $('<div></div>').appendTo('body');
        this.header = $('<div class="view-header"></div>').appendTo(this.dom);
        this.body = $('<div class="view-body"></div>').appendTo(this.dom);
        this.initDialog();
        this.initHeader();
        this.initBody();
        this.addedItemDic = {};
    },
    initDialog: function() {
        var _this = this;
        var buttons = $('<div></div>');
        var btn_ok = $('<a href="#"></a>').linkbutton({
            text: '确定',
            iconCls: 'icon-ok',
            onClick: function() {
                _this.save();
            }
        }).appendTo(buttons);
        var btn_cancel = $('<a href="#"></a>').linkbutton({
            text: '取消',
            iconCls: 'icon-cancel',
            onClick: function() {
                _this.close();
            }
        }).appendTo(buttons);

        this.dom.dialog({
            left: 300,
            top: 50,
            height: 400,
            width: 300,
            title: '添加自费药品',
            modal: true,
            closed: true,
            buttons: buttons,
            onOpen: function() {

            },
            onClose: function() {

            }
        });
    },
    initHeader: function() {
        var _this = this;
        this.Status = 'Available';
        this.filterForm = $('<form class="editform"></form>').form({}).appendTo(this.header);
        var row = $('<div class="editform-row"></div>').appendTo(this.filterForm);
        this.descFilter = $('<input type="text">').appendTo(row).searchbox({
            width: 290
        });
        var inputRect = this.descFilter.siblings('.searchbox');
        $(inputRect).find('input').keyup(function() {
            _this.FilterStr = $(this).val().toUpperCase();
            _this.filter();
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.filterForm);
        this.showAll = $('<input type="radio">').appendTo(row).radio({
            name: 'Status',
            value: 'All',
            label: '全部',
            onChecked: function() {
                _this.Status = 'All';
                _this.filter();
            }
        });
        this.showAdded = $('<input type="radio">').appendTo(row).radio({
            name: 'Status',
            value: 'Added',
            label: '已添加',
            onChecked: function() {
                _this.Status = 'Added';
                _this.filter();
            }
        });
        this.showAvailable = $('<input type="radio">').appendTo(row).radio({
            name: 'Status',
            value: 'Available',
            label: '未添加',
            checked: true,
            onChecked: function() {
                _this.Status = 'Available';
                _this.filter();
            }
        });
    },
    initBody: function() {
        this.itemContainer = $('<div class="container"></div>').appendTo(this.body);
        this.itemAddButton = $('<a class="item-button" href="javascript:;" title="创建自费药品项目" onclick="javascript:addDrug();">+</a>').appendTo(this.body);
    },
    render: function(data) {
        this.data = data;
        var length = data.length;
        var container = this.itemContainer;
        var addedItemDic = this.addedItemDic;
        container.hide();
        container.empty();
        for (var i = 0; i < length; i++) {
            var item = data[i];
            var row = $('<div class="drug-item"></div>').appendTo(container);
            row.data('data', item);
            if (addedItemDic[item.RowId]) item.isAdded = true;
            else item.isAdded = false;
            item.visible = true;
            item.isChecked = true;
            drugView.render(row, item);
        }
        this.filter();
        container.show();
    },
    filter: function() {
        var filter = {
            desc: this.FilterStr || '',
            status: this.Status || 'All'
        }

        var data = this.data;
        var length = data.length;
        for (var i = 0; i < length; i++) {
            var item = data[i];
            if ((
                    (item.Description.indexOf(filter.desc) > -1) ||
                    (item.Alias.indexOf(filter.desc) > -1)
                ) &&
                (
                    filter.status === 'All' ||
                    (item.isAdded && filter.status === 'Added') ||
                    (!item.isAdded && filter.status === 'Available')
                )) {
                item.visible = true;
                item.target.show();
            } else {
                item.visible = false;
                item.target.hide();
            }
        }
    },
    refreshStatus: function(addedDataList) {
        var length = addedDataList.length;
        var addedItemDic = {};
        for (var i = 0; i < length; i++) {
            var data = addedDataList[i];
            addedItemDic[data.SelfPaidDrug] = data;
        }
        this.addedItemDic = addedItemDic;

        var data = this.data;
        var length = data.length;
        for (var i = 0; i < length; i++) {
            var item = data[i];
            if (addedItemDic[item.RowId]) {
                item.isAdded = true;
                drugView.render(item.target, item);
            } else {
                item.isAdded = false;
                drugView.render(item.target, item);
            }
        }
        this.filter();
    },
    open: function() {
        this.body.height(this.dom.height() - this.header.height() - 45);
        this.dom.dialog('open');
    },
    close: function() {
        this.dom.dialog('close');
    },
    save: function() {
        var _this = this;
        var data = this.data;
        var length = data.length;
        var savingDatas = [];

        for (var i = 0; i < length; i++) {
            var row = data[i];
            if (!row.isAdded && row.visible && row.isChecked) {
                savingDatas.push({
                    ClassName: ANCLS.Model.SelfPaidDrugData,
                    RecordSheet: selfPaidBillConsent.recordSheetID,
                    SelfPaidDrug: row.RowId,
                    Specification: row.Specification,
                    Price: row.Price,
                    Qty: row.DefaultQty,
                    Note: row.Note,
                    UpdateUserID: session['UserID']
                })
            }
        }

        dhccl.saveDatas(ANCSP.DataListService, {
            ClassName: ANCLS.BLL.SelfPaidConsent,
            MethodName: "SaveData",
            jsonData: dhccl.formatObjects(savingDatas)
        }, function(result) {
            if (result.indexOf("S^") === 0) {
                loadDrugData();
                _this.close();
                $('#addSuccess_dialog').show();
                $('#addSuccess_dialog').css({ opacity: 1 });
                setTimeout(function() {
                    $('#addSuccess_dialog').animate({ opacity: 0 }, 3000, 'swing', function() {
                        $('#addSuccess_dialog').hide();
                    });
                }, 1000);
            } else {
                dhccl.showMessage(result, "添加自费药品");
            }
        });
    }
}

var materialView = {
    render: function(container, data) {
        container.empty();
        container.data('data', data);
        data.target = container;

        var isAdded = false;
        if (data.isAdded) {
            container.addClass('material-item-added');
            container.attr('title', '此一次性项目已添加');
            isAdded = true;
        } else {
            container.removeClass('material-item-added');
            container.attr('title', '');
        }

        var id = 'd_f_r_i_' + data.RowId + '_c';
        var checkObj = $('<input id="' + id + '" type="checkbox">').appendTo(container);
        container.append('<label for="' + id + '"><span>' + data.Description + '</span></label>');
        checkObj.checkbox({
            id: id,
            checked: data.isChecked,
            disabled: isAdded,
            onChecked: function() {
                data.isChecked = true;
            },
            onUnchecked: function() {
                data.isChecked = false;
            }
        });
    }
}

var addMaterialDataView = {
    init: function() {
        this.dom = $('<div></div>').appendTo('body');
        this.header = $('<div class="view-header"></div>').appendTo(this.dom);
        this.body = $('<div class="view-body"></div>').appendTo(this.dom);
        this.initDialog();
        this.initHeader();
        this.initBody();
        this.addedItemDic = {};
    },
    initDialog: function() {
        var _this = this;
        var buttons = $('<div></div>');
        var btn_ok = $('<a href="#"></a>').linkbutton({
            text: '确认',
            iconCls: 'icon-ok',
            onClick: function() {
                _this.save();
            }
        }).appendTo(buttons);
        var btn_cancel = $('<a href="#"></a>').linkbutton({
            text: '取消',
            iconCls: 'icon-cancel',
            onClick: function() {
                _this.close();
            }
        }).appendTo(buttons);

        this.dom.dialog({
            left: 600,
            top: 50,
            height: 400,
            width: 300,
            title: '添加一次性自费项目',
            modal: true,
            closed: true,
            buttons: buttons,
            onOpen: function() {

            },
            onClose: function() {

            }
        });
    },
    initHeader: function() {
        var _this = this;
        this.Status = 'Available';
        this.filterForm = $('<form class="editform"></form>').form({}).appendTo(this.header);
        var row = $('<div class="editform-row"></div>').appendTo(this.filterForm);
        this.descFilter = $('<input type="text">').appendTo(row).searchbox({
            width: 290
        });
        var inputRect = this.descFilter.siblings('.searchbox');
        $(inputRect).find('input').keyup(function() {
            _this.FilterStr = $(this).val().toUpperCase();
            _this.filter();
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.filterForm);
        this.showAll = $('<input type="radio">').appendTo(row).radio({
            name: 'Status',
            value: 'All',
            label: '全部',
            onChecked: function() {
                _this.Status = 'All';
                _this.filter();
            }
        });
        this.showAdded = $('<input type="radio">').appendTo(row).radio({
            name: 'Status',
            value: 'Added',
            label: '已添加',
            onChecked: function() {
                _this.Status = 'Added';
                _this.filter();
            }
        });
        this.showAvailable = $('<input type="radio">').appendTo(row).radio({
            name: 'Status',
            value: 'Available',
            label: '未添加',
            checked: true,
            onChecked: function() {
                _this.Status = 'Available';
                _this.filter();
            }
        });
    },
    initBody: function() {
        this.itemContainer = $('<div class="container"></div>').appendTo(this.body);
        this.itemAddButton = $('<a class="item-button" href="javascript:;" title="创建一次性自费项目" onclick="javascript:addMaterial();">+</a>').appendTo(this.body);
    },
    render: function(data) {
        this.data = data;
        var length = data.length;
        var container = this.itemContainer;
        var addedItemDic = this.addedItemDic;
        container.hide();
        container.empty();
        for (var i = 0; i < length; i++) {
            var item = data[i];
            var row = $('<div class="material-item"></div>').appendTo(container);
            row.data('data', item);
            if (addedItemDic[item.RowId]) item.isAdded = true;
            else item.isAdded = false;
            item.visible = true;
            item.isChecked = true;
            materialView.render(row, item);
        }
        this.filter();
        container.show();
    },
    filter: function() {
        var filter = {
            desc: this.FilterStr || '',
            status: this.Status || 'All'
        }

        var data = this.data;
        var length = data.length;
        for (var i = 0; i < length; i++) {
            var item = data[i];
            if ((
                    (item.Description.indexOf(filter.desc) > -1) ||
                    (item.Alias.indexOf(filter.desc) > -1)
                ) &&
                (
                    filter.status === 'All' ||
                    (item.isAdded && filter.status === 'Added') ||
                    (!item.isAdded && filter.status === 'Available')
                )) {
                item.visible = true;
                item.target.show();
            } else {
                item.visible = false;
                item.target.hide();
            }
        }
    },
    refreshStatus: function(addedDataList) {
        var length = addedDataList.length;
        var addedItemDic = {};
        for (var i = 0; i < length; i++) {
            var data = addedDataList[i];
            addedItemDic[data.SelfPaidMaterial] = data;
        }
        this.addedItemDic = addedItemDic;

        var data = this.data;
        var length = data.length;
        for (var i = 0; i < length; i++) {
            var item = data[i];
            if (addedItemDic[item.RowId]) {
                item.isAdded = true;
                materialView.render(item.target, item);
            } else {
                item.isAdded = false;
                materialView.render(item.target, item);
            }
        }
        this.filter();
    },
    open: function() {
        this.body.height(this.dom.height() - this.header.height() - 45);
        this.dom.dialog('open');
    },
    close: function() {
        this.dom.dialog('close');
    },
    save: function() {
        var _this = this;
        var data = this.data;
        var length = data.length;
        var savingDatas = [];

        for (var i = 0; i < length; i++) {
            var row = data[i];
            if (!row.isAdded && row.visible && row.isChecked) {
                savingDatas.push({
                    ClassName: ANCLS.Model.SelfPaidMaterialData,
                    RecordSheet: selfPaidBillConsent.recordSheetID,
                    SelfPaidMaterial: row.RowId,
                    Price: row.Price,
                    Qty: row.DefaultQty,
                    Note: row.Note,
                    UpdateUserID: session['UserID']
                })
            }
        }

        dhccl.saveDatas(ANCSP.DataListService, {
            ClassName: ANCLS.BLL.SelfPaidConsent,
            MethodName: "SaveData",
            jsonData: dhccl.formatObjects(savingDatas)
        }, function(result) {
            if (result.indexOf("S^") === 0) {
                loadMaterialData();
                _this.close();
                $('#addSuccess_dialog').show();
                $('#addSuccess_dialog').css({ opacity: 1 });
                setTimeout(function() {
                    $('#addSuccess_dialog').animate({ opacity: 0 }, 3000, 'swing', function() {
                        $('#addSuccess_dialog').hide();
                    });
                }, 1000);
            } else {
                dhccl.showMessage(result, "添加自费药品");
            }
        });
    }
}

function addDrug() {
    if (!addDrugView.isInitialized) {
        addDrugView.init();
    }
    addDrugView.open();
}

var addDrugView = {
    init: function() {
        var _this = this;
        this.dom = $('<div></div>').appendTo('body');
        this.initForm();

        var buttons = $('<div></div>');
        var btn_ok = $('<a href="#"></a>').linkbutton({
            text: '确认',
            iconCls: 'icon-ok',
            onClick: function() {
                _this.save();
            }
        }).appendTo(buttons);
        var btn_cancel = $('<a href="#"></a>').linkbutton({
            text: '取消',
            iconCls: 'icon-cancel',
            onClick: function() {
                _this.close();
            }
        }).appendTo(buttons);

        this.dom.dialog({
            left: 400,
            top: 40,
            height: 420,
            width: 300,
            title: '创建自费药品项目',
            modal: true,
            closed: true,
            buttons: buttons,
            onOpen: function() {
                _this.default();
            },
            onClose: function() {
                _this.clear();
            }
        });
        this.isInitialized = true;
    },
    initForm: function() {
        this.form = $('<form></form>').form({}).appendTo(this.dom);

        this.RowId = $('<input type="hidden" name="RowId">').appendTo(this.form);
        this.DeptID = $('<input type="hidden" name="DeptID">').appendTo(this.form);

        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">药品名称：</div>').appendTo(row);
        this.Description = $('<input type="text" class="textbox" name="Description">').appendTo(row);
        this.Description.validatebox({
            width: 260,
            required: true,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">简拼：</div>').appendTo(row);
        this.Alias = $('<input type="text" class="textbox" name="Alias">').appendTo(row);
        this.Alias.validatebox({
            width: 260,
            required: true,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">规格：</div>').appendTo(row);
        this.Specification = $('<input type="text" class="textbox" name="Specification">').appendTo(row);
        this.Specification.validatebox({
            width: 260,
            required: true,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">单价：</div>').appendTo(row);
        this.Price = $('<input type="text" class="textbox" name="Price">').appendTo(row);
        this.Price.numberbox({
            width: 187,
            required: true,
            precision: 2,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">默认数量：</div>').appendTo(row);
        this.DefaultQty = $('<input type="text" class="textbox" name="DefaultQty">').appendTo(row);
        this.DefaultQty.numberbox({
            width: 187,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">备注：</div>').appendTo(row);
        this.Note = $('<input type="text" class="textbox" name="Note">').appendTo(row);
        this.Note.validatebox({
            width: 260,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">生效时间：</div>').appendTo(row);
        this.StartDT = $('<input type="text" class="textbox" name="StartDT">').appendTo(row);
        this.StartDT.datetimebox({
            width: 187,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">停用时间：</div>').appendTo(row);
        this.EndDT = $('<input type="text" class="textbox" name="EndDT">').appendTo(row);
        this.EndDT.datetimebox({
            width: 187,
            label: label
        });
    },
    open: function() {
        this.dom.dialog('open');
    },
    close: function() {
        this.dom.dialog('close');
    },
    default: function() {
        this.StartDT.datetimebox('setValue', new Date().format(constant.dateFormat));
    },
    clear: function() {
        this.form.form('clear');
    },
    save: function() {
        var _this = this;
        var datetime = this.StartDT.datebox('getValue');
        var arr = datetime.split(' ');
        var startdate = arr[0] || '';
        var starttime = arr[1] || '';

        var datetime = this.EndDT.datebox('getValue');
        var arr = datetime.split(' ');
        var enddate = arr[0] || '';
        var endtime = arr[1] || '';

        var savingData = {
            ClassName: ANCLS.Config.SelfPaidDrug,
            RowId: '',
            DeptID: session['DeptID'],
            Description: this.Description.val(),
            Alias: this.Alias.val(),
            Specification: this.Specification.val(),
            Price: this.Price.numberbox('getValue'),
            DefaultQty: this.DefaultQty.numberbox('getValue'),
            Note: this.Note.val(),
            StartDate: startdate,
            StartTime: starttime,
            EndDate: enddate,
            EndTime: endtime
        }

        dhccl.saveDatas(ANCSP.DataListService, {
            ClassName: ANCLS.BLL.SelfPaidConsent,
            MethodName: "AddDrug",
            jsonData: dhccl.formatObject(savingData)
        }, function(result) {
            if (result.indexOf("S^") === 0) {
                loadDrugItem();
                _this.close();
            } else {
                dhccl.showMessage(result, "创建自费药品项目");
            }
        });
    }
}

function addMaterial() {
    if (!addMaterialView.isInitialized) {
        addMaterialView.init();
    }
    addMaterialView.open();
}

var addMaterialView = {
    init: function() {
        var _this = this;
        this.dom = $('<div></div>').appendTo('body');
        this.initForm();

        var buttons = $('<div></div>');
        var btn_ok = $('<a href="#"></a>').linkbutton({
            text: '确认',
            iconCls: 'icon-ok',
            onClick: function() {
                _this.save();
            }
        }).appendTo(buttons);
        var btn_cancel = $('<a href="#"></a>').linkbutton({
            text: '取消',
            iconCls: 'icon-cancel',
            onClick: function() {
                _this.close();
            }
        }).appendTo(buttons);

        this.dom.dialog({
            left: 700,
            top: 40,
            height: 420,
            width: 300,
            title: '创建一次性自费项目',
            modal: true,
            closed: true,
            buttons: buttons,
            onOpen: function() {
                _this.default();
            },
            onClose: function() {
                _this.clear();
            }
        });
        this.isInitialized = true;
    },
    initForm: function() {
        this.form = $('<form></form>').form({}).appendTo(this.dom);

        this.RowId = $('<input type="hidden" name="RowId">').appendTo(this.form);
        this.DeptID = $('<input type="hidden" name="DeptID">').appendTo(this.form);

        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">药品名称：</div>').appendTo(row);
        this.Description = $('<input type="text" class="textbox" name="Description">').appendTo(row);
        this.Description.validatebox({
            width: 260,
            required: true,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">简拼：</div>').appendTo(row);
        this.Alias = $('<input type="text" class="textbox" name="Alias">').appendTo(row);
        this.Alias.validatebox({
            width: 260,
            required: true,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">单价：</div>').appendTo(row);
        this.Price = $('<input type="text" class="textbox" name="Price">').appendTo(row);
        this.Price.numberbox({
            width: 187,
            required: true,
            precision: 2,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">默认数量：</div>').appendTo(row);
        this.DefaultQty = $('<input type="text" class="textbox" name="DefaultQty">').appendTo(row);
        this.DefaultQty.numberbox({
            width: 187,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">备注：</div>').appendTo(row);
        this.Note = $('<input type="text" class="textbox" name="Note">').appendTo(row);
        this.Note.validatebox({
            width: 260,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">生效时间：</div>').appendTo(row);
        this.StartDT = $('<input type="text" class="textbox" name="StartDT">').appendTo(row);
        this.StartDT.datetimebox({
            width: 187,
            label: label
        });
        var row = $('<div class="editform-row"></div>').appendTo(this.form);
        var label = $('<div class="label">停用时间：</div>').appendTo(row);
        this.EndDT = $('<input type="text" class="textbox" name="EndDT">').appendTo(row);
        this.EndDT.datetimebox({
            width: 187,
            label: label
        });
    },
    open: function() {
        this.dom.dialog('open');
    },
    close: function() {
        this.dom.dialog('close');
    },
    default: function() {
        this.StartDT.datetimebox('setValue', new Date().format(constant.dateFormat));
    },
    clear: function() {
        this.form.form('clear');
    },
    save: function() {
        var _this = this;
        var datetime = this.StartDT.datebox('getValue');
        var arr = datetime.split(' ');
        var startdate = arr[0] || '';
        var starttime = arr[1] || '';

        var datetime = this.EndDT.datebox('getValue');
        var arr = datetime.split(' ');
        var enddate = arr[0] || '';
        var endtime = arr[1] || '';

        var savingData = {
            ClassName: ANCLS.Config.SelfPaidMaterial,
            RowId: '',
            DeptID: session['DeptID'],
            Description: this.Description.val(),
            Alias: this.Alias.val(),
            Price: this.Price.numberbox('getValue'),
            DefaultQty: this.DefaultQty.numberbox('getValue'),
            Note: this.Note.val(),
            StartDate: startdate,
            StartTime: starttime,
            EndDate: enddate,
            EndTime: endtime
        }

        dhccl.saveDatas(ANCSP.DataListService, {
            ClassName: ANCLS.BLL.SelfPaidConsent,
            MethodName: "AddMaterial",
            jsonData: dhccl.formatObject(savingData)
        }, function(result) {
            if (result.indexOf("S^") === 0) {
                loadMaterialItem();
                _this.close();
            } else {
                dhccl.showMessage(result, "创建自费药品项目");
            }
        });
    }
}

function print() {
    var lodop = getLodop();
    var operSchedule = selfPaidBillConsent.operSchedule;
    createPrintOnePage(lodop, operSchedule);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1); //打印后自动关闭预览窗口
    lodop.PREVIEW();

}

function createPrintOnePage(lodop, operSchedule) {
    lodop.PRINT_INIT("打印麻醉自费知情同意签字单");
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    lodop.SET_PRINT_STYLE("FontName", "黑体");
    lodop.SET_PRINT_STYLE("FontSize", 9);
    //  lodop.SET_PRINT_STYLE("Alignment", 2);
    lodop.ADD_PRINT_TEXT(30, 240, 240, 30, "山西省肿瘤医院");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 21);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 3);

    lodop.ADD_PRINT_TEXT(60, 160, 480, 30, "麻醉科医保患者药品和诊疗项目自费同意书");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 18);

    lodop.ADD_PRINT_TEXT(110, 95, 650, 30, "根据医保规定，患者病情需要，经医患双方协商，" +
        "下列药品及诊疗项");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 15);
    lodop.ADD_PRINT_TEXT(140, 65, 650, 30, "目" +
        "由患者自费，患者或家属若同意请签字。");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 15);
    var linePaddingTop = 16,
        linePaddingRight = 5,
        textMarginLeft = 65;
    var width = 50,
        height = 30;
    var startPos = {
        x: textMarginLeft,
        y: 190
    }
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 300, 15, "姓名：");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);
    startPos.x += width;
    width = 170;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 300, 15, operSchedule.PatName);
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);

    startPos.x += width;
    width = 170;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 330, 15, "类别：省医保（  ）市医保（  ）");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);

    startPos.y += height;
    startPos.x = 65;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 120, 15, "科室：");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);

    startPos.x += width;
    width = 170;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 120, 15, operSchedule.PatDeptDesc);
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);

    startPos.x += width;
    width = 70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 150, 15, "住院号：");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);

    startPos.x += width;
    width = 130;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 150, 15, operSchedule.MedcareNo);
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);

    startPos.x += width;
    width = 50;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 90, 15, "日期：");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);
    startPos.x += width;
    width = 70;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 120, 15, operSchedule.OperDate);
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);

    var padding = {
        top: 20,
        left: 5
    }
    height = 50
    startPos.x = textMarginLeft;
    startPos.y += height;
    height = 80;

    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 120, 15, "自费药品");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);
    lodop.ADD_PRINT_TABLE(startPos.y + padding.top, startPos.x, 660, 205, "<table style='height: 200px;width: 660px' border='1 solid black' cellspacing='0'>" +
        "<tr style='height:50px '> " +
        "<th width='130'>药品名称</th> <th width='50'>规格</th> <th width='50'>单价（元）</th> <th width='50'>数量</th> <th width='50'>备注省市</th> " +
        "<th width='130'>药品名称</th> <th width='50'>规格</th> <th width='50'>单价（元）</th> <th width='50'>数量</th> <th width='50'>备注</th>" +
        " </tr>" +
        "<tr style='height: 30px'>" +
        "<td>丙帕他莫</td><td>2g</td><td>64.00</td><td></td><td>丙</td>" +
        "<td>磷酸肌酸钠</td><td>0.5g</td><td>61.75</td><td></td><td></td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td>盐酸甲氧明</td><td>10mg</td><td>44.64</td><td></td><td>丙</td>" +
        "<td></td><td></td><td></td><td></td><td></td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td>奥布卡因凝胶</td><td>10ml</td><td>36.00</td><td></td><td>丙</td>" +
        "<td></td><td></td><td></td><td></td><td></td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td></td><td></td><td></td><td></td><td></td>" +
        "<td></td><td></td><td></td><td></td><td></td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td></td><td></td><td></td><td></td><td></td>" +
        "<td></td><td></td><td></td><td></td><td></td>" +
        "</tr>" +
        "</table>");
    height = 280;
    startPos.y += height;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 200, 15, "一次性自费诊疗项目");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);
    lodop.ADD_PRINT_TABLE(startPos.y + padding.top, startPos.x, 660, 460, "<table style='height: 390px;width: 660px' border='1 solid black' cellspacing='0'>" +
        "<tr style='height:30px '> " +
        "<th width='130'>名称</th> <th width='70'>单价（元）</th> <th width='50'>数量</th> <th width='70'>备注</th> " +
        "<th width='130'>名称</th> <th width='70'>单价（元）</th> <th width='50'>数量</th> <th width='70'>备注</th> " +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td>加强管（驼人）</td><td>327.40</td><td></td>" +
        "<td>省乙市丙</td><td>BIS</td><td>497.20</td><td></td><td>省乙市丙</td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td>单腔管</td><td>23.90</td><td></td>" +
        "<td>省乙市丙</td><td>空气过滤器</td><td>438.20</td><td></td><td>省乙市丙</td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td>双腔管</td><td>930.10</td><td></td>" +
        "<td>省乙市丙</td><td>有创测压套件</td><td>397.10</td><td></td><td>省乙市丙</td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td>喉罩气管导管</td><td>594.00</td><td></td>" +
        "<td>省乙市丙</td><td>眼贴</td><td>16.70</td><td></td><td>省乙市丙</td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td>镇痛装置（艾）</td><td>294.80</td><td></td>" +
        "<td>省乙市丙</td><td>口咽通气道</td><td>45.80</td><td></td><td>省乙市丙</td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td>镇痛装置（驼）</td><td>288.60</td><td></td>" +
        "<td>省乙市丙</td><td>中心静脉导管</td><td>238.40</td><td></td><td>省乙市丙</td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td>电子泵</td><td>533.50</td><td></td>" +
        "<td>省乙市丙</td><td>动脉帖</td><td>192.50</td><td></td><td>省乙市丙</td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td>术中输注泵</td><td>427.9</td><td></td>" +
        "<td>省乙市丙</td><td>密吸管</td><td>252.5</td><td></td><td>省乙市丙</td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td>血氧饱和度探头</td><td>194</td><td></td>" +
        "<td>省乙市丙</td><td>医用升温毯</td><td>668.8</td><td></td><td>省丙市丙</td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td></td><td></td><td></td>" +
        "<td></td><td></td><td></td><td></td><td></td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td></td><td></td><td></td>" +
        "<td></td><td></td><td></td><td></td><td></td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td></td><td></td><td></td>" +
        "<td></td><td></td><td></td><td></td><td></td>" +
        "</tr>" +
        "<tr style='height: 30px'>" +
        "<td></td><td></td><td></td>" +
        "<td></td><td></td><td></td><td></td><td></td>" +
        "</tr>" +
        "</table>");
    height = 500;
    startPos.y += height;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 200, 15, "患者或者家属签名：");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 350, 120, 15, "医生签名：");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 14);
}