var toxicAnestReg = {
    regList: [],
    anestClaimList: [],
    returnSuccessDialog: null,
    returnDialog: null,
    returnForm: null,
    regListContainer: null,
    anestClaimListContainer: null
}

$(document).ready(function() {
    toxicAnestReg.returnSuccessDialog = $('#returnSuccess_dialog');
    toxicAnestReg.undoReturnSuccessDialog = $('#undoReturnSuccess_dialog');
    toxicAnestReg.returnDialog = $('#return_dialog');
    toxicAnestReg.returnForm = $('#return_form');
    toxicAnestReg.regListContainer = $('#reg_record_container');
    toxicAnestReg.anestClaimListContainer = $('#form_anest_container');

    initQueryTools();
    initHistoryGrid();
    initReturnFlat();
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
                { field: 'ReturnDT', title: '退还时间', width: 70 },
                {
                    field: 'ReturnDetails',
                    title: '退还药品明细',
                    width: 150,
                    formatter: function(value, row, index) {
                        return '<span title="' + value + '" class="hisui-tooltip" data-options="position:\'top\'">' + value + '</span>';
                    }
                },
                { field: 'ReturnCheckUserName', title: '退还审核人', width: 90 },
                { field: 'ClaimDT', title: '领取时间', width: 110 },
                {
                    field: 'ClaimDetails',
                    title: '领取药品明细',
                    width: 150,
                    formatter: function(value, row, index) {
                        return '<span title="' + value + '" class="hisui-tooltip" data-options="position:\'top\'">' + value + '</span>';
                    }
                },
                { field: 'ClaimCheckUserName', title: '领取审核人', width: 90 }
            ]
        ],
        queryParams: {
            ClassName: ANCLS.BLL.ToxicAnestReg,
            QueryName: 'FindToxicAnestRegList',
            ArgCnt: 3
        },
        onBeforeLoad: function(param) {
            param.Arg1 = $('#q_history_andoc').combobox('getValue') || '';
            param.Arg2 = $('#q_history_startdate').datebox('getValue');
            param.Arg3 = $('#q_history_enddate').datebox('getValue');
        },
        onSelect: function(index, row) {

        },
        onLoadSuccess: function(data) {}
    });
}

function initReturnFlat() {
    toxicAnestReg.regListContainer.delegate('.btn-reg-return', 'click', function() {
        var regRecord = $(this).parent().data('data');
        var form = toxicAnestReg.returnForm;
        form.data('data', regRecord);
        form.form('load', regRecord);

        $('#returndatetime').datetimebox('setValue', new Date().format(constant.dateTimeFormat));

        var dialog = toxicAnestReg.returnDialog;
        dialog.dialog('open');
    });

    toxicAnestReg.regListContainer.delegate('.btn-reg-undo', 'click', function() {
        var regRecord = $(this).parent().data('data');
        var form = toxicAnestReg.returnForm;
        form.data('data', regRecord);
        form.form('load', regRecord);

        var guid = dhccl.guid();
        $.extend(regRecord, {
            ReturnDT: '',
            ReturnDate: '',
            ReturnTime: '',
            ReturnCheckUser: session.UserID,
            ReturnCheckUserName: session.UserName,
            Guid: guid,
            ClassName: ANCLS.Model.ToxicAnestReg
        });

        var savingDatas = [regRecord];

        $.each(regRecord.anestClaimList, function(index, anestClaim) {
            if (anestClaim) {
                if (anestClaim.Status === 'U' && !anestClaim.RelatedOper) {
                    $.extend(anestClaim, {
                        Status: 'C',
                        StatusDesc: '已领取',
                        ReturnDT: '',
                        ReturnDate: '',
                        ReturnTime: '',
                        UseDT: '',
                        UseDate: '',
                        UseTime: ''
                    });
                }
                if (anestClaim.Status === 'R') {
                    $.extend(anestClaim, {
                        Status: 'C',
                        StatusDesc: '已领取',
                        ReturnDT: '',
                        ReturnDate: '',
                        ReturnTime: '',
                        UseDT: '',
                        UseDate: '',
                        UseTime: ''
                    });
                }
                savingDatas.push($.extend(anestClaim, {
                    RegGuid: guid,
                    RegRecord: '',
                    ClassName: ANCLS.Model.ToxicAnestClaim
                }));
            }
        });

        dhccl.saveDatas(ANCSP.MethodService, {
            ClassName: ANCLS.BLL.ToxicAnestReg,
            MethodName: "SaveToxicAnestReg",
            Arg1: dhccl.formatObjects(savingDatas),
            Arg2: session.UserID,
            ArgCnt: 2
        }, function(data) {
            refreshPage();
        });

        toxicAnestReg.undoReturnSuccessDialog.dialog('open');
        setTimeout(function() {
            toxicAnestReg.undoReturnSuccessDialog.dialog('close');
        }, 1500);
    });

    toxicAnestReg.anestClaimListContainer.delegate('.btn-anest-use', 'click', function() {
        var anestClaim = $(this).parent().data('data');
        anestClaim.isUsed = true;
        anestClaim.isUndone = false;
        refreshAnestClaim(anestClaim);
    });

    toxicAnestReg.anestClaimListContainer.delegate('.btn-anest-undo', 'click', function() {
        var anestClaim = $(this).parent().data('data');
        anestClaim.isUsed = false;
        anestClaim.isUndone = true;
        refreshAnestClaim(anestClaim);
    });
}

/**
 * 初始化对话框按钮
 */
function initDialogButtons() {
    $('#btn_saveReg').linkbutton({
        onClick: function() {
            var regRecord = toxicAnestReg.returnForm.data('data') || {};
            var returnDT = $('#returndatetime').datetimebox('getValue');
            var datetimeArr = returnDT.split(' ');
            var returnDate = datetimeArr[0] || new Date().format(constant.dateFormat);
            var returnTime = datetimeArr[1] || new Date().format(constant.timeFormat);

            var guid = dhccl.guid();
            $.extend(regRecord, {
                ReturnDT: returnDT,
                ReturnDate: returnDate,
                ReturnTime: returnTime,
                ReturnCheckUser: session.UserID,
                ReturnCheckUserName: session.UserName,
                Guid: guid,
                ClassName: ANCLS.Model.ToxicAnestReg
            });

            var claimList = [];

            var anestClaimListContainer = toxicAnestReg.anestClaimListContainer;
            $.each(anestClaimListContainer.find('.form-anest'), function(index, e) {
                var anestClaim = $(this).data('data');
                if (anestClaim) {
                    if (anestClaim.Status === 'C' && anestClaim.checked) {
                        $.extend(anestClaim, {
                            Status: 'R',
                            StatusDesc: '已退还',
                            ReturnDT: returnDT,
                            ReturnDate: returnDate,
                            ReturnTime: returnTime
                        });
                    }
                    if (anestClaim.Status === 'C' && anestClaim.isUsed) {
                        $.extend(anestClaim, {
                            Status: 'U',
                            StatusDesc: '已使用',
                            UseDT: returnDT,
                            UseDate: returnDate,
                            UseTime: returnTime
                        });
                    }
                    if (anestClaim.isUndone) {
                        $.extend(anestClaim, {
                            Status: 'U',
                            StatusDesc: '已使用',
                            UseDT: '',
                            UseDate: '',
                            UseTime: '',
                            ReturnDT: '',
                            ReturnDate: '',
                            ReturnTime: ''
                        });
                    }
                    claimList.push($.extend(anestClaim, {
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
            toxicAnestReg.returnDialog.dialog('close');
            //refreshPage();
        }
    });
}

/**
 * 初始化表单
 */
function initForms() {
    toxicAnestReg.returnForm.form({
        onLoadSuccess: function(data) {
            generateAnestClaims(data.anestClaimList);
        }
    });
}

function clearReturnForm() {
    toxicAnestReg.returnForm.form('clear');
    toxicAnestReg.anestClaimListContainer.empty();
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
                    UsedQty: 0,
                    NeedReturnQty: 0,
                    ReturnedQty: 0
                }
            } else {
                dataItemGroups[claim.DataItem].Qty = qtyCounters[claim.DataItem];
            }

            if (claim.Status === 'C') {
                dataItemGroups[claim.DataItem].NeedReturnQty = dataItemGroups[claim.DataItem].NeedReturnQty + 1;
            }

            if (claim.Status === 'U') {
                dataItemGroups[claim.DataItem].UsedQty = dataItemGroups[claim.DataItem].UsedQty + 1;
            }

            if (claim.Status === 'R') {
                dataItemGroups[claim.DataItem].ReturnedQty = dataItemGroups[claim.DataItem].ReturnedQty + 1;
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
    container.append(dom);
    anestClaimView.render(dom, anestClaim);
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
        ReturnDate: regRecord.ReturnDate,
        ReturnTime: regRecord.ReturnTime,
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
            Status: claim.Status,
            StatusDesc: claim.StatusDesc
        })
    }

    var signCode = 'ReturnCheckUser';
    var originalData = JSON.stringify(data);
    var signView = new SignView({
        container: "#signContainer",
        originalData: originalData,
        signCode: signCode,
        saveCallBack: function(signInfo) {
            if (regRecord.ReturnCheckCertID) {
                regRecord.ReturnCheckSignTimeStamp = signInfo.SignTimeStamp;
            } else if (!regRecord.ClaimCheckSignTimeStamp) {
                regRecord.ReturnCheckSignTimeStamp = signInfo.SignTimeStamp;
            }
            $.extend(regRecord, {
                ReturnCheckCertID: signInfo.CertID,
                ReturnCheckUserCertID: signInfo.UserCertID,
                ReturnCheckSignData: signInfo.SignData,
                ReturnCheckUser: signInfo.SignUser
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

            toxicAnestReg.returnDialog.dialog('close');
            toxicAnestReg.returnSuccessDialog.dialog('open');
            setTimeout(function() {
                toxicAnestReg.returnSuccessDialog.dialog('close');
                //toxicAnestReg.returnSuccessDialog.data('window').window.animate({ opacity: 0 });
            }, 1000);
        }
    });
    signView.initView();
    signView.open();
}


var regRecordView = {
    render: function(container, data) {
        container.empty();
        container.data('data', data);
        data.target = container;

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
        row.append('<span class="reg-record-label">审核人：</span>');
        $('<span class="reg-record-info reg-record-andoc"></span>')
            .text(data.ReturnCheckUserName)
            .appendTo(row);
        row.append('<span class="reg-record-label">退还时间：</span>');
        $('<span class="reg-record-info reg-record-time"></span>')
            .text(data.ReturnDT)
            .appendTo(row);

        var row = $('<div class="reg-record-row"></div>').appendTo(container);
        row.append('<span class="reg-record-label reg-record-anest-label">药品数量：</span>');
        var anestGroupListContainer = $('<span class="reg-record-info reg-record-anest-container"></span>').appendTo(row);

        var haveAllReturned = true;
        $.each(data.claimGroups, function(index, e) {
            var anest = $('<div class="reg-record-anest"></div>')
                .text(e.DataItemDesc)
                .append($('<span class="reg-record-anest-separation">共</span>')
                    .append('<span class="reg-record-anest-qty">' + e.Qty + '</span>')
                    .append('<span class="reg-record-anest-unit">支</span>'))
                .append($('<span class="reg-record-anest-separation">已使用</span>')
                    .append('<span class="reg-record-anest-qty">' + e.UsedQty + '</span>')
                    .append('<span class="reg-record-anest-unit">支</span>'))
                .appendTo(anestGroupListContainer);
            if (data.ReturnDT && e.ReturnedQty > 0) {
                anest.append($('<span class="reg-record-anest-separation">已退还</span>')
                    .append('<span class="reg-record-anest-qty">' + e.ReturnedQty + '</span>')
                    .append('<span class="reg-record-anest-unit">支</span>'))
            }
            if (e.NeedReturnQty > 0) {
                haveAllReturned = false;
                anest.append($('<span class="reg-record-anest-separation">需退还</span>')
                    .append('<span class="reg-record-anest-qty reg-record-unproceed">' + e.NeedReturnQty + '</span>')
                    .append('<span class="reg-record-anest-unit">支</span>'))
            } else {
                anest.append('<span class="reg-record-tag-completed icon-ok"></span>');
            }
        });

        if (haveAllReturned) {
            container.addClass('reg-record-completed');
            container.prepend('<a href="javascript:;" class="btn-reg-undo btn-flat btn-flat-right-1 icon-undo" title="撤销退还"></a>');
        } else {
            container.prepend('<a href="javascript:;" class="btn-reg-return btn-flat btn-flat-right-1 icon-redo" title="' + (data.ReturnDT ? '继续退还' : '退还') + '"></a>');
        }
    }
}

var anestClaimView = {
    render: function(container, data) {
        container.empty();
        container.data('data', data);
        data.target = container;

        var isUsed = false;
        var isReturned = false;
        var checkAll = true;
        if ((data.Status === 'U' || data.isUsed) && !data.isUndone) {
            container.addClass('form-anest-used');
            container.attr('title', '此药品已使用' +
                (data.RelatedOper ? '于' + data.UsedDT + '，手术病人 ' + data.RelatedOperPatName : ''));
            isUsed = true;
        } else if (data.Status === 'R' && !data.isUndone) {
            container.addClass('form-anest-returned');
            container.attr('title', '此药品已退还');
        } else {
            container.removeClass('form-anest-used');
            container.removeClass('form-anest-returned');
            container.attr('title', '');
        }


        data.checked = isUsed ? false : checkAll;

        container.append('<a href="javascript:;" title="使用" class="btn-anest-use btn-flat btn-flat-right-1 icon-check-reg" ' +
            (isUsed ? 'style="display:none;"' : '') + '></a>');
        if (!data.RelatedOper) //仅当此药品的使用未关联到对应手术时才可以撤销使用
            container.append('<a href="javascript:;" title="撤销' + (isUsed ? '使用' : '') +
            '" class="btn-anest-undo btn-flat btn-flat-right-1 icon-undo" ' +
            ((isUsed || isReturned) ? '' : 'style="display:none;"') + '></a>');

        var id = 'f_r_i_' + data.RowId + '_c';
        var checkObj = $('<input id="' + id + '" type="checkbox">').appendTo(container);
        container.append('<label for="' + id + '"><span><span>' + data.DataItemDesc + '</span><span>' +
            data.Specification + '</span><span>1</span><span>支</span></span></label>');
        checkObj.checkbox({
            id: id,
            checked: data.checked,
            disabled: (isUsed || isReturned) ? true : false,
            onChecked: function() {
                var data = $(this).parent().parent().data('data');
                data.checked = true;
            },
            onUnchecked: function() {
                var data = $(this).parent().parent().data('data');
                data.checked = false;
            }
        });
    }
}