var toxicAnestReg = {
    data: [],
    anestClaimList: [],
    regDialog: null,
    anestDialog: null,
    regForm: null,
    anestForm: null,
    regListContainer: null,
    anestClaimListContainer: null
}

$(document).ready(function() {
    toxicAnestReg.regDialog = $('#reg_dialog');
    toxicAnestReg.anestDialog = $('#anest_dialog');
    toxicAnestReg.regForm = $('#reg_form');
    toxicAnestReg.anestForm = $('#anest_form');
    toxicAnestReg.regListContainer = $('#reg_record_container');
    toxicAnestReg.anestClaimListContainer = $('#form_anest_container');
    toxicAnestReg.saveSuccessDialog = $('#saveSuccess_dialog');

    initQueryTools();
    initHistoryGrid();
    initClaimFlat();
    initDialogButtons();
    initForms();
    refreshPage();
});

/**
 * 初始化查询条件项和值
 */
function initQueryTools() {
    var url = ANCSP.DataQuery,
        param = {
            ClassName: 'DHCCL.BLL.Admission',
            QueryName: 'FindCareProvByLoc',
            Arg1: '',
            Arg2: session.DeptID,
            ArgCnt: 2
        },
        dataType = "json";
    var careprovList = dhccl.getDatas(url, param, dataType);

    $('#q_andoc,#q_history_andoc,#andoc').combobox('loadData', careprovList);

    $('#q_date,#q_history_startdate,#q_history_enddate').datebox('setValue', new Date().format(constant.dateFormat));

    $('#q_search').click(function() {
        refreshPage();
    });

    $('#q_history_search').click(function() {
        $('#historygrid').datagrid('reload');
    });
}

/**
 * 初始化历史记录表格
 */
function initHistoryGrid() {
    $('#historygrid').datagrid({
        fit: true,
        singleSelect: true,
        nowrap: false,
        rownumbers: true,
        pagination: true,
        pageSize: 200,
        pageList: [50, 100, 200],
        toolbar: '#historygrid_tool',
        url: ANCSP.DataQuery,
        remoteSort: false,
        checkbox: false,
        frozenColumns: [
            []
        ],
        columns: [
            [
                { field: 'RowId', title: 'ID', width: 80, hidden: true },
                { field: 'RegDate', title: '领取日期', width: 110 },
                { field: 'CareProvDesc', title: '麻醉医生', width: 70 },
                { field: 'ClaimDT', title: '领取时间', width: 110 },
                {
                    field: 'ClaimDetails',
                    title: '领取药品明细',
                    width: 150,
                    formatter: function(value, row, index) {
                        return '<span title="' + value + '" class="hisui-tooltip" data-options="position:\'top\'">' + value + '</span>';
                    }
                },
                { field: 'ClaimCheckUserName', title: '领取审核人', width: 90 },
                { field: 'ReturnDT', title: '退还时间', width: 70 },
                {
                    field: 'ReturnDetails',
                    title: '退还药品明细',
                    width: 150,
                    formatter: function(value, row, index) {
                        return '<span title="' + value + '" class="hisui-tooltip" data-options="position:\'top\'">' + value + '</span>';
                    }
                },
                { field: 'ReturnCheckUserName', title: '退还审核人', width: 90 }
            ]
        ],
        queryParams: {
            ClassName: ANCLS.BLL.ToxicAnestReg,
            QueryName: 'FindToxicAnestRegList',
            ArgCnt: 3
        },
        onBeforeLoad: function(param) {
            param.Arg1 = $('#q_history_andoc').combobox('getValue') || '';
            param.Arg2 = $('#q_history_startdate').datebox('getValue') || '';
            param.Arg3 = $('#q_history_enddate').datebox('getValue') || '';
        },
        onSelect: function(index, row) {

        },
        onLoadSuccess: function(data) {}
    });
}

/**
 * 初始化药品领取区域
 */
function initClaimFlat() {
    $('#btnAddReg').click(function() {
        $('#claimdatetime').datetimebox('setValue', new Date().format(constant.dateTimeFormat));
        var dialog = toxicAnestReg.regDialog;
        dialog.dialog('setTitle', '新增毒麻药领取记录');
        dialog.dialog('open');
    });

    toxicAnestReg.regListContainer.delegate('.btn-reg-edit', 'click', function() {
        var regRecord = $(this).parent().data('data');
        var form = toxicAnestReg.regForm;
        form.data('data', regRecord);
        form.form('load', regRecord);

        var dialog = toxicAnestReg.regDialog;
        dialog.dialog('setTitle', '修改毒麻药领取记录');
        dialog.dialog('open');
    });

    toxicAnestReg.regListContainer.delegate('.btn-reg-remove', 'click', function() {
        var regRecord = $(this).parent().data('data');
        regRecord.ClassName = ANCLS.Model.ToxicAnestReg;

        $.extend(regRecord, {
            IsActive: 'N'
        });

        $.messager.confirm('删除确认', '您确定要删除此条领用登记记录？', function(confirmed) {
            if (confirmed) {
                dhccl.saveDatas(ANCSP.MethodService, {
                    ClassName: ANCLS.BLL.ToxicAnestReg,
                    MethodName: "SaveToxicAnestReg",
                    Arg1: dhccl.formatObjects(savingDatas),
                    Arg2: session.UserID,
                    ArgCnt: 2
                }, function(data) {
                    refreshPage();
                });
            }
        });
    });

    toxicAnestReg.anestClaimListContainer.delegate('.btn-anest-edit', 'click', function() {
        var anestClaim = $(this).parent().data('data');
        var form = toxicAnestReg.anestForm;
        form.data('data', anestClaim);
        form.form('load', anestClaim);

        $('btn_saveAnest').linkbutton({
            iconCls: 'icon-edit',
            text: '修改'
        })
        toxicAnestReg.anestDialog.dialog('open');
    });
    toxicAnestReg.anestClaimListContainer.delegate('.btn-anest-copy', 'click', function() {
        var anestClaim = $(this).parent().data('data');
        var newAnestClaim = $.extend({}, anestClaim, { RowId: '' });
        addAnestClaim(newAnestClaim);
    });
    toxicAnestReg.anestClaimListContainer.delegate('.btn-anest-remove', 'click', function() {
        var anestClaim = $(this).parent().data('data');
        anestClaim.isRemoved = true;
        refreshAnestClaim(anestClaim);
    });
    toxicAnestReg.anestClaimListContainer.delegate('.btn-anest-undo', 'click', function() {
        var anestClaim = $(this).parent().data('data');
        anestClaim.isRemoved = false;
        refreshAnestClaim(anestClaim);
    });
}

/**
 * 初始化弹出框按钮
 */
function initDialogButtons() {
    $('#btn_saveReg').linkbutton({
        onClick: function() {
            var regRecord = toxicAnestReg.regForm.data('data') || {};
            var claimDT = $('#claimdatetime').datetimebox('getValue');
            var datetimeArr = claimDT.split(' ');
            var claimDate = datetimeArr[0] || new Date().format(constant.dateFormat);
            var claimTime = datetimeArr[1] || new Date().format(constant.timeFormat);

            var guid = dhccl.guid();
            $.extend(regRecord, {
                CareProv: $('#andoc').combobox('getValue'),
                CareProvDesc: $('#andoc').combobox('getText'),
                RegDate: claimDate,
                ClaimDT: claimDT,
                ClaimDate: claimDate,
                ClaimTime: claimTime,
                ClaimCheckUser: session.UserID,
                ClaimCheckUserName: session.UserName,
                IsActive: 'Y',
                Guid: guid,
                ClassName: ANCLS.Model.ToxicAnestReg
            });

            var claimList = [];

            var anestClaimListContainer = toxicAnestReg.anestClaimListContainer;
            $.each(anestClaimListContainer.find('.form-anest'), function(index, e) {
                var anest = $(this).data('data');
                if (anest) {
                    claimList.push($.extend(anest, {
                        RegGuid: guid,
                        RegRecord: '',
                        ClassName: ANCLS.Model.ToxicAnestClaim
                    }));
                }
            });

            signAndSave(regRecord, claimList);
        }
    });
    $('#btn_cancelReg').linkbutton({
        onClick: function() {
            toxicAnestReg.regDialog.dialog('close');
        }
    });
    $('#btn_addAnest').click(function() {
        var form = toxicAnestReg.anestForm;
        form.data('data', null);
        var dialog = toxicAnestReg.anestDialog;
        dialog.dialog('open');
    });
    $('#btn_saveAnest').linkbutton({
        onClick: function() {
            var data = toxicAnestReg.anestForm.data('data');
            var qty = Number($('#anest_qty').numberbox('getValue'));
            if (data === null) {
                data = {
                    DataItem: $('#anest_dataItem').combobox('getValue'),
                    DataItemDesc: $('#anest_dataItem').combobox('getText'),
                    Batch: $('#anest_batch').val(),
                    ElectronicCode: $('#anest_electronicCode').val(),
                    Specification: $('#anest_specification').combobox('getValue'),
                    Dose: '',
                    DoseUnit: '',
                    QtyUnit: '',
                    Status: 'C',
                    StatusDesc: '已领取'
                };
                for (var i = 0; i < qty; i++) {
                    addAnestClaim($.extend({}, data));
                }
            } else {
                $.extend(data, {
                    DataItem: $('#anest_dataItem').combobox('getValue'),
                    DataItemDesc: $('#anest_dataItem').combobox('getText'),
                    Batch: $('#anest_batch').val(),
                    ElectronicCode: $('#anest_electronicCode').val(),
                    Specification: $('#anest_specification').combobox('getValue'),
                    Dose: '',
                    DoseUnit: '',
                    QtyUnit: '',
                    Status: 'C',
                    StatusDesc: '已领取'
                });
                refreshAnestClaim(data);
            }

            toxicAnestReg.anestDialog.dialog('close');
        }
    });
    $('#btn_cancelAnest').linkbutton({
        onClick: function() {
            toxicAnestReg.anestDialog.dialog('close');
        }
    });
}

/**
 * 初始化表单
 */
function initForms() {
    toxicAnestReg.regForm.form({
        onLoadSuccess: function(data) {
            generateAnestClaims(data.anestClaimList);
        }
    });
    toxicAnestReg.anestForm.form({
        onLoadSuccess: function(data) {

        }
    });

    var url = ANCSP.DataQuery,
        param = {
            ClassName: ANCLS.BLL.CodeQueries,
            QueryName: 'FindDataItem',
            Arg1: '',
            Arg2: 'D',
            ArgCnt: 2
        },
        dataType = "json";
    dhccl.getDatas(url, param, dataType, true, function(data) {
        $('#anest_dataItem').combobox('loadData', data);
    });

    clearAnestForm();
}

/**
 * 清空登记表单
 */
function clearRegForm() {
    toxicAnestReg.regForm.form('clear');
    toxicAnestReg.regForm.data('data', null);
    toxicAnestReg.anestClaimListContainer.empty();
}

/**
 * 清空药品表单
 */
function clearAnestForm() {
    toxicAnestReg.anestForm.form('clear');
    $('#anest_qty').numberbox('setValue', 1);
}

/**
 * 刷新界面
 */
function refreshPage() {
    loadRegRecord();
}

/**
 * 加载登记数据
 */
function loadRegRecord() {
    var date = $('#q_date').datebox('getValue');
    var url = ANCSP.DataQuery,
        param = {
            ClassName: ANCLS.BLL.ToxicAnestReg,
            QueryName: 'FindToxicAnestRegList',
            Arg1: $('#q_andoc').combobox('getValue') || '',
            Arg2: date,
            Arg3: date,
            ArgCnt: 3
        },
        dataType = "json";
    dhccl.getDatas(url, param, dataType, true, function(data) {
        toxicAnestReg.data = data;
        loadAnestClaims();
    });
}

/**
 * 加载药品领取数据
 */
function loadAnestClaims() {
    var date = $('#q_date').datebox('getValue');
    var url = ANCSP.DataQuery,
        param = {
            ClassName: ANCLS.BLL.ToxicAnestReg,
            QueryName: 'FindToxicAnestClaimList',
            Arg1: $('#q_andoc').combobox('getValue') || '',
            Arg2: date,
            Arg3: date,
            ArgCnt: 3
        },
        dataType = "json";
    dhccl.getDatas(url, param, dataType, true, function(data) {
        toxicAnestReg.anestClaimList = data;
        proceedRegRecords();
        generateRegRecords();
    });
}

/**
 * 处理登记数据
 */
function proceedRegRecords() {
    var anestClaimList = toxicAnestReg.anestClaimList;
    var length = anestClaimList.length;
    var regClaims = {};
    for (var i = 0; i < length; i++) {
        var claim = anestClaimList[i];
        if (regClaims[claim.RegRecord]) {
            regClaims[claim.RegRecord].push(claim);
        } else {
            regClaims[claim.RegRecord] = [claim];
        }
    }

    var regRecords = toxicAnestReg.data;
    var length = regRecords.length;
    for (var i = 0; i < length; i++) {
        var reg = regRecords[i];
        var anestClaimList = regClaims[reg.RowId] || [];
        reg.anestClaimList = anestClaimList

        var claimLength = anestClaimList.length;
        var qtyCounters = [],
            dataItemGroups = {};
        for (var j = 0; j < claimLength; j++) {
            var claim = anestClaimList[j];
            qtyCounters[claim.DataItem] = (qtyCounters[claim.DataItem] || 0) + 1;
            if (!dataItemGroups[claim.DataItem]) {
                dataItemGroups[claim.DataItem] = {
                    DataItem: claim.DataItem,
                    DataItemDesc: claim.DataItemDesc,
                    Qty: 1,
                }
            } else {
                dataItemGroups[claim.DataItem].Qty = qtyCounters[claim.DataItem];
            }
        }

        reg.claimGroups = dataItemGroups;
    }
}

/**
 * 渲染登记记录
 */
function generateRegRecords() {
    var container = toxicAnestReg.regListContainer;
    container.hide();
    container.empty();
    var regRecords = toxicAnestReg.data;
    var length = regRecords.length;
    for (var i = 0; i < length; i++) {
        var reg = regRecords[i];
        addRegRecords(container, reg);
    }
    container.show();
}

/**
 * 添加一条登记记录
 * @param {*} container 
 * @param {*} reg 
 */
function addRegRecords(container, reg) {
    var dom = $('<div class="reg-record"></div>');
    regRecordView.render(dom, reg);
    container.append(dom);
}

/**
 * 渲染药品记录
 */
function generateAnestClaims(anestClaimList) {
    var container = toxicAnestReg.anestClaimListContainer;
    container.hide();
    container.empty();
    var length = anestClaimList.length;
    for (var i = 0; i < length; i++) {
        var claim = anestClaimList[i];
        renderAnestClaim(container, claim);
    }
    container.show();
}

/**
 * 添加一条药品记录
 * @param {*} claim 
 */
function addAnestClaim(anestClaim) {
    var container = toxicAnestReg.anestClaimListContainer;
    renderAnestClaim(container, anestClaim);
}

/**
 * 渲染一条药品记录
 */
function renderAnestClaim(container, anestClaim) {
    var dom = $('<div class="form-anest"></div>');
    anestClaimView.render(dom, anestClaim);
    container.append(dom);
}

/**
 * 刷新渲染一条药品记录
 */
function refreshAnestClaim(anestClaim) {
    anestClaimView.render(anestClaim.target, anestClaim);
}

/**
 * CA签名/普通签名
 */
function signAndSave(regRecord, claimList) {
    var data = [];
    data.push({
        CareProv: regRecord.CareProv,
        CareProvDesc: regRecord.CareProvDesc,
        RegDate: regRecord.RegDate,
        ClaimDate: regRecord.ClaimDate,
        ClaimTime: regRecord.ClaimTime,
        IsActive: regRecord.IsActive
    });

    var length = claimList.length;
    var claim = null;
    for (var i = 0; i < length; i++) {
        claim = claimList[i];
        data.push({
            DataItem: claim.DataItem,
            DataItemDesc: claim.DataItemDesc,
            Batch: claim.Batch,
            ElectronicCode: claim.ElectronicCode,
            Specification: claim.Specification,
            Dose: '',
            DoseUnit: '',
            QtyUnit: '',
            Status: 'C',
            StatusDesc: '已领取'
        })
    }

    var signCode = 'ClaimCheckUser';
    var originalData = JSON.stringify(data);
    var signView = new SignView({
        container: "#signContainer",
        originalData: originalData,
        signCode: signCode,
        saveCallBack: function(signInfo) {
            if (regRecord.ClaimCheckCertID) {
                regRecord.ClaimCheckSignTimeStamp = signInfo.SignTimeStamp;
            } else if (!regRecord.ClaimCheckSignTimeStamp) {
                regRecord.ClaimCheckSignTimeStamp = signInfo.SignTimeStamp;
            }
            $.extend(regRecord, {
                ClaimCheckCertID: signInfo.CertID,
                ClaimCheckUserCertID: signInfo.UserCertID,
                ClaimCheckSignData: signInfo.SignData,
                ClaimCheckUser: signInfo.SignUser
            });
            var savingDatas = [regRecord].concat(claimList);
            dhccl.saveDatas(ANCSP.MethodService, {
                ClassName: ANCLS.BLL.ToxicAnestReg,
                MethodName: "SaveToxicAnestReg",
                Arg1: dhccl.formatObjects(savingDatas),
                Arg2: session.UserID,
                ArgCnt: 2
            }, function(data) {
                refreshPage();
            });

            toxicAnestReg.regDialog.dialog('close');
            toxicAnestReg.saveSuccessDialog.dialog('open');
            setTimeout(function() {
                toxicAnestReg.saveSuccessDialog.dialog('close');
            }, 1000);
        }
    });
    signView.initView();
    signView.open();
}

/**
 * 登记信息显示
 */
var regRecordView = {
    render: function(container, data) {
        container.empty();
        container.data('data', data);
        data.target = container;

        $('<a href="javascript:;" class="btn-reg-edit btn-flat btn-flat-right-2 icon-edit" title="修改此条记录"></a>').appendTo(container);
        $('<a href="javascript:;" class="btn-reg-remove btn-flat btn-flat-right-1 icon-cancel" title="删除此条记录"></a>').appendTo(container);
        var row = $('<div class="reg-record-row"></div>').appendTo(container);
        row.append('<span class="reg-record-label">麻醉医生：</span>');
        $('<span class="reg-record-info reg-record-andoc"></span>')
            .text(data.CareProvDesc)
            .appendTo(row);
        row.append('<span class="reg-record-label">领取时间：</span>');
        $('<span class="reg-record-info reg-record-time"></span>')
            .text(data.ClaimDT)
            .appendTo(row);

        var row = $('<div class="reg-record-row"></div>').appendTo(container);
        row.append('<span class="reg-record-label reg-record-anest-label">药品数量：</span>');
        var anestGroupListContainer = $('<span class="reg-record-info reg-record-anest-container"></span>').appendTo(row);

        $.each(data.claimGroups, function(index, e) {
            $('<div class="reg-record-anest"></div>')
                .text(e.DataItemDesc)
                .append($('<span class="reg-record-anest-separation">共</span>')
                    .append('<span class="reg-record-anest-qty">' + e.Qty + '</span>')
                    .append('<span class="reg-record-anest-unit">支</span>'))
                .appendTo(anestGroupListContainer);
        });
    }
}

/**
 * 新增药品领取信息显示
 */
var anestClaimView = {
    render: function(container, data) {
        container.empty();
        container.data('data', data);
        data.target = container;

        var isRemoved = false;
        if (typeof data.isRemoved === 'boolean' && data.isRemoved) {
            container.addClass('form-anest-removed');
            isRemoved = true;
        } else {
            container.removeClass('form-anest-removed');
        }

        container.append('<a href="javascript:;" title="修改" class="btn-anest-edit btn-flat btn-flat-right-3 icon-edit"></a>')
            .append('<a href="javascript:;" title="再加1支' + data.DataItemDesc + '" class="btn-anest-copy btn-flat btn-flat-right-2 icon-copy-drug"></a>')
            .append('<a href="javascript:;" title="删除" class="btn-anest-remove btn-flat btn-flat-right-1 icon-cancel" ' + (isRemoved ? 'style="display:none;"' : '') + '></a>')
            .append('<a href="javascript:;" title="撤销删除" class="btn-anest-undo btn-flat btn-flat-right-1 icon-undo" ' + (isRemoved ? '' : 'style="display:none;"') + '></a>')
            .append('<span>' + data.DataItemDesc + '</span>')
            .append('<span>' + data.Specification + '</span>')
            .append('<span>1</span><span>支</span>')
    }
}