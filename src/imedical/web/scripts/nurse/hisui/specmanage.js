/**
 * @author SongChao
 * @version 20180619
 * @description 标本运送管理js
 */
var GV = {};
function searchBtnClick() {
    var tab = $('#specTabs').tabs('getSelected');
    GV.specTree.options().url = $URL + '?ClassName=Nur.HISUI.SpecManage&MethodName=getSpecTree&WardID=' + GV.wardID + '&StartDate=' + GV.startDate + '&StartTime=' + GV.startTime + '&EndDate=' + GV.endDate + '&EndTime=' + GV.endTime + '&TabID=' + tab.context.id;
    GV.specTree.reload();
}
/**
 * @description 采血时间更新按钮
 */
function updateBtnClick() {
    var LabEpisodeNo = $('#labNo').val();
    if (LabEpisodeNo !== "") {
        $('#labNoRead').val(LabEpisodeNo);
        var UserID = session['LOGON.USERID'];
        $cm({
            ClassName: "Nur.HISUI.SpecManage",
            MethodName: "updateCollDateTime",
            LabEpisodeNo: LabEpisodeNo,
            UserID: UserID,
        }, function (jsonData) {
            if (String(jsonData.success) === "0") {
                $("#retLabNo").val(jsonData.labNO)
                $("#retSpecName").val(jsonData.specName)
                $("#retBedCode").val(jsonData.bedCode)
                $("#retArcim").val(jsonData.arcim)
                $("#retPatName").val(jsonData.patName)
                $("#retCollDateTime").val(jsonData.collDateTime)
                $("#retRegNo").val(jsonData.regNo)
                var ifCarry = $('#switchCarry').switchbox('getValue');
                if (ifCarry) {
                    insertCarrySheet(LabEpisodeNo);
                    getCarrySheetSpecs(GV.CarryNo);
                }
            }
            else {
                $.messager.alert("错误提示", jsonData.errInfo, "info");
            }
        });
    }
}
/**
 * @description 采血时间更新追加到运送单开关
 */
function switchCarryChange(e, el) {
    if (el.value) {
        var userCode = session['LOGON.USERCODE'];
        var locID = session['LOGON.CTLOCID'];
        $cm({
            ClassName: "Nur.HISUI.SpecManage",
            MethodName: "getCarrySheet",
            LocID: locID,
            UserCode: userCode,
        }, function (jsonData) {
            GV.CarryNo = jsonData.CarryNo;
            var carryTitle = jsonData.CarryNo + ' ' + jsonData.CarryUserName + ' ' + jsonData.CarryDate + ' ' + jsonData.CarryTime
            $('#panelCarrySheet').panel('setTitle', carryTitle);
            $('#layoutCollDate').layout('expand', 'south');
            getCarrySheetSpecs(GV.CarryNo);
        });

    } else {
        $('#panelCarrySheet').panel('setTitle', "运送单");
        $('#gridCarrySpecs').datagrid({ data: [] });
        $('#layoutCollDate').layout('collapse', 'south');
    }
}
/**
 *@description 获取采取时间页签下运送单对应的标本填充grid
 * @param {*} carryNo 运送单号
 */
function getCarrySheetSpecs(carryNo) {
    var ifCarry = $('#switchCarry').switchbox('getValue');
    if (ifCarry) {
        $cm({
            ClassName: "Nur.HISUI.SpecManage",
            MethodName: "getCarrySheetSpecs",
            CarryNO: carryNo,
        }, function (jsonData) {
            $('#gridCarrySpecs').datagrid({ data: jsonData })
        })
    }
}
/**
 * @description 将标本插入运送单
 */
function insertCarrySheet(labNo) {
    if (GV.CarryNo != '') {
        var locID = session['LOGON.CTLOCID'];
        $cm({
            ClassName: "Nur.HISUI.SpecManage",
            MethodName: "specRelateCarrySheet",
            LabNo: labNo,
            CarryNo: GV.CarryNo,
            LocID: locID,
        }, function (jsonData) {
            if (String(jsonData.success) !== "0") {
                $.messager.show({
                    title: '建单消息',
                    msg: jsonData.errInfo,
                    timeout: 5000,
                    showType: 'slide'
                });
            }
        })
    }
}
/**
 * @description 标签页选中
 */
function tabSelected(title) {
    if (title == '采集时间') {
        initCollTab();
    }
    if (title == '标本运送') {
        initCarryTab();
    }
    searchBtnClick();
}
/**
 * @description 初始化运送单查询条件
 */
function initCarrySheetSearchCondition() {
    $('#sheetStartDateBox').datebox('setValue', formatDate("2011-01-01"));
    $('#sheetEndtDateBox').datebox('setValue', formatDate(new Date()));
}

/**
 * @description 查询运送单信息
 */
function findCarrySheet() {
    var locID = session['LOGON.CTLOCID'];
    var stDate = $('#sheetStartDateBox').datebox('getValue');
    var endDate = $('#sheetEndtDateBox').datebox('getValue');
    var status = $('#sheetStateBox').combobox('getValue');
    var filterStr = $('#sheetFilter').val();
    $cm({
        ClassName: "Nur.HISUI.SpecManage",
        MethodName: "findCarrySheet",
        StDate: stDate,
        EndDate: endDate,
        LocID: locID,
        Status: status,
        FilterStr: filterStr
    }, function (jsonData) {
        $('#gridCarrySheet').datagrid({ data: jsonData })
    });
}
/**
 * @description 运送单行操作按钮
 * @param {} val 
 * @param {*} row 
 * @param {*} index 
 */
function carrySheetRowOper(val, row, index) {
    if (row.Status == 'C') {
        btns = '<a href="#" class="outLocBtn" onclick="outLocBtnClick(\'' + String(row.CarryNo) + '\',\'' + String(row.TransCount) + '\')"></a>'
            + '<a href="#" class="delSheetBtn" onclick="delSheetBtnClick(\'' + String(row.CarryNo) + '\')"></a>'
            + '<a href="#" class="printSheetBtn" onclick="printSheetBtnClick(' + val + ',' + row + ',' + index + ')"></a>';
    }
    else {
        btns = '<a href="#" class="printSheetBtn" onclick="printSheetBtnClick(' + val + ',' + row + ',' + index + ')"></a>';
    }
    return btns;
}
/**
 *@description 初始化gridCarrySheet按钮操作及事件监听等
 *
 */
function initGridCarrySheet() {
    $('#gridCarrySheet').datagrid('getColumnOption', 'Operate').formatter = carrySheetRowOper;
    $('#gridCarrySheet').datagrid({
        onLoadSuccess: function () {
            $('.outLocBtn').linkbutton({ plain: true, iconCls: 'icon-arrow-right-top' });
            $('.delSheetBtn').linkbutton({ plain: true, iconCls: 'icon-remove' });
            $('.printSheetBtn').linkbutton({ plain: true, iconCls: 'icon-print' });
        },
        onDblClickRow: gridCarrySheetDblClickRow
    });
    $('#creatCarrySheetBtn').bind('click', creatCarrySheetBtnClick);
}
/**
 *@description 新建运送单按钮监听
 */
function creatCarrySheetBtnClick() {
    var locID = session['LOGON.CTLOCID'];
    var userCode = session['LOGON.USERCODE'];
    $cm({
        ClassName: "Nur.HISUI.SpecManage",
        MethodName: "createCarrySheet",
        LocID: locID,
        UserCode: userCode,
    }, function (jsonData) {
        if (String(jsonData.success) !== "0") {
            $.messager.show({
                title: '新建运送单消息',
                msg: jsonData.errInfo,
                timeout: 5000,
                showType: 'slide'
            });
        } else {
            findCarrySheet();
        }
    });
}
/**
 *@description 运送单出科
 */
function outLocBtnClick(CarryNo, TransCount) {
    if (TransCount > 0) {
        $('#outLocDialog').dialog({
            onClose: function () {
                $('#outLocDialogForm').form('clear');
            },
            buttons: [{
                text: '保存',
                handler: function () {
                    var transUserCode = $('#transUserCode').val();
                    var transUserPass = $('#transUserPass').val();
                    $cm({
                        ClassName: "Nur.HISUI.SpecManage",
                        MethodName: "passwordConfirm",
                        UserCode: transUserCode,
                        PassWord: transUserPass
                    }, function (jsonData) {
                        if (String(jsonData.result) !== '0') {
                            $.messager.show({
                                title: '用户验证消息',
                                msg: jsonData.result,
                                timeout: 5000,
                                showType: 'slide'
                            });
                        } else {
                            var transUserID = jsonData.userID;
                            var containerNo = $('#containerNoInput').val();
                            var userID = session['LOGON.USERID'];
                            var locID = session['LOGON.CTLOCID'];
                            $cm({
                                ClassName: "Nur.HISUI.SpecManage",
                                MethodName: "outLocCarrySheet",
                                CarryNO: CarryNo,
                                ContainerNo: containerNo,
                                TransUserID: transUserID,
                                UserID: userID,
                                UserLocID: locID
                            }, function (jsonData) {
                                if (String(jsonData.success) !== "0") {
                                    $.messager.show({
                                        title: '标本交接消息',
                                        msg: jsonData.errInfo,
                                        timeout: 5000,
                                        showType: 'slide'
                                    });
                                } else {
                                    $HUI.dialog('#outLocDialog').close();
                                    findCarrySheet();
                                }
                            });
                        }
                    });
                }
            }, {
                text: '关闭',
                handler: function () { $HUI.dialog('#outLocDialog').close(); }
            }]
        });
        $('#outLocDialog').dialog('open');
    } else {
        $.messager.show({
            title: '标本交接消息',
            msg: "空运送单无法出科,请填写标本信息!!",
            timeout: 5000,
            showType: 'slide'
        });
    }
}
/**
 * @description 删除标本运送单
 * @param {*} CarryNo
 */
function delSheetBtnClick(CarryNo) {
    var userID = session['LOGON.USERID'];
    $.messager.confirm("删除", "确定删除么", function (r) {
        if (r) {
            $cm({
                ClassName: "Nur.HISUI.SpecManage",
                MethodName: "deleteCarrySheet",
                CarryNO: CarryNo,
                UserID: userID
            }, function (jsonData) {
                if (String(jsonData.success) !== "0") {
                    $.messager.show({
                        title: '删除运送单消息',
                        msg: jsonData.errInfo,
                        timeout: 5000,
                        showType: 'slide'
                    });
                } else {
                    findCarrySheet();
                }
            })
        } else {
            return;
        }
    });
}
/** 
 *@description 从运送单中删除标本
*/
function deleteSpecBtnClick(labNo, CarryNo) {
    var locID = session['LOGON.CTLOCID'];
    $.messager.confirm("删除", "确定删除么", function (r) {
        if (r) {
            $cm({
                ClassName: "Nur.HISUI.SpecManage",
                MethodName: "specDelFromCarrySheet",
                LabNo: labNo,
                CarryNo: CarryNo,
            }, function (jsonData) {
                if (String(jsonData.success) !== "0") {
                    $.messager.show({
                        title: '删除标本消息',
                        msg: jsonData.errInfo,
                        timeout: 5000,
                        showType: 'slide'
                    });
                } else {
                    getCarrySheetDetailSpecs(CarryNo);
                    searchBtnClick();
                }
            })
        } else {
            return;
        }
    });
}
/**
 *@description 初始化GridCarrySheetDetail按钮操作及事件监听等
 *
 */
function initGridCarrySheetDetail() {
    $('#gridCarrySheetDetail').datagrid('getColumnOption', 'DetailOperate').formatter = function (val, row, index) {
        return '<a href="#" class="deleteSpecBtn" onclick="deleteSpecBtnClick(\'' + row.LabNo + '\',\'' + GV.CarryNo + '\')"></a>';
    };
    $('#gridCarrySheetDetail').datagrid({
        onLoadSuccess: function () {
            $('.deleteSpecBtn').linkbutton({ plain: true, iconCls: 'icon-remove' });
        },
        onDblClickRow: gridCarrySheetDblClickRow
    });
    $('#insertCarrySheetDetailBtn').bind('click', insertCarrySheetDetailBtnClick);
    $('#detailLabNOInput').bind('keydown', function (e) {
        if (e.keyCode == 13) {
            insertCarrySheetDetailBtnClick();
        }
    });
    $('#outLocCarrySheetDetailBtn').bind('click', outLocCarrySheetDetailBtnClick);
}
/**
 * @description 运送单详情页增加标本按钮监听
 */
function insertCarrySheetDetailBtnClick() {
    var labNO = $('#detailLabNOInput').val();
    insertCarrySheet(labNO);
    getCarrySheetDetailSpecs(GV.CarryNo);
    searchBtnClick();
}
/**
 * @description 运送单详情页增加标本按钮监听
 */
function outLocCarrySheetDetailBtnClick() {
    var transCount = $('#gridCarrySheetDetail').datagrid('getRows').length;
    outLocBtnClick(GV.CarryNo, transCount)
}
/**
 *@description 运送单数据表格行双击事件
 *
 */
function gridCarrySheetDblClickRow(rowIndex, rowData) {
    var carryTitle = '运送单：' + rowData.CarryNo + ' ' + rowData.CarryUserName + ' ' + rowData.CarryDate + ' ' + rowData.CarryTime
    $('#panelCarrySheetDetail').panel('setTitle', carryTitle);
    GV.CarryNo = rowData.CarryNo;
    getCarrySheetDetailSpecs(GV.CarryNo);
    $('#layoutCarry').layout('collapse', 'west');
    if (rowData.Status != "C") {
        $('#tableCarrySheetDetailToolBar > span ').hide()
        $('#tableCarrySheetDetailToolBar > input').hide()
        $('#tableCarrySheetDetailToolBar > a').hide()
    } else {
        $('#tableCarrySheetDetailToolBar > span ').show()
        $('#tableCarrySheetDetailToolBar > input').show()
        $('#tableCarrySheetDetailToolBar > a').show()
    }
}
/**
 *@description 获取采取时间页签下运送单对应的标本填充grid
 * @param {*} carryNo 运送单号
 */
function getCarrySheetDetailSpecs(carryNo) {
    if (carryNo) {
        $cm({
            ClassName: "Nur.HISUI.SpecManage",
            MethodName: "getCarrySheetSpecs",
            CarryNO: carryNo,
        }, function (jsonData) {
            $('#gridCarrySheetDetail').datagrid({ data: jsonData })
        })
    }
}
/**
 * @description 初始化标本查询时间条件
 */
function initSpecSearchCondition() {
    $('#startDate').datebox('setValue', formatDate("2011-01-01"));
    $('#startTime').timespinner('setValue', '00:00');
    $('#endDate').datebox('setValue', formatDate(new Date()));
    $('#endTime').timespinner('setValue', '23:59');
    GV.wardID = session['LOGON.WARDID'];
    GV.startDate = $('#startDate').datebox('getValue');
    GV.startTime = $('#startTime').timespinner('getValue');
    GV.endDate = $('#endDate').datebox('getValue');
    GV.endTime = $('#endTime').timespinner('getValue');
}
function onSelectStartDate(date) {
    GV.startDate = formatDate(date);
}
function onSelectStartTime(time) {
    GV.startTime = time;
}
function onSelectEndDate(date) {
    GV.endDate = formatDate(date)
}
function onSelectEndTime(time) {
    GV.endTime = time;
}
/**
 *@description 树菜单-置采血时间-添加监听
 */
function updateCollDateMenuClick() {
    var nodes = $('#specTree').tree('getChecked');
    if (nodes.length > 0) {
        var msgInfo = "";
        nodes.forEach(function (node) {
            if (node.labNo && node.labNo !== "") {
                var UserID = session['LOGON.USERID'];
                var jsonData = $cm({
                    ClassName: "Nur.HISUI.SpecManage",
                    MethodName: "updateCollDateTime",
                    LabEpisodeNo: node.labNo,
                    UserID: UserID,
                }, false);
                if (String(jsonData.success) !== "0") {
                    $.messager.alert("错误提示", jsonData.errInfo, "info");
                    msgInfo += jsonData.labNO + "失败,原因:" + jsonData.errInfo + "<br>";
                } else {
                    msgInfo += jsonData.labNO + " 成功<br>";
                }
            }
        });
        $.messager.show({
            title: '置采集时间消息',
            msg: msgInfo,
            timeout: 5000,
            showType: 'slide'
        })
        searchBtnClick();
    } else {
        $.messager.alert("提示", "请选择标本!", "info");
    }
}
/**
 * @description 初始化采集时间页签
 */
function initCollTab() {
    $('#switchCarry').on('switch-change', switchCarryChange);
    $('#specTreeMenu').menu('removeItem', '#addCarrySheetMenu');
    $('#specTreeMenu').menu('appendItem', {
        id: 'updateCollDateMenu',
        text: '置采血时间',
        iconCls: 'icon-update',
        onclick: updateCollDateMenuClick
    });
    $('#searchBtn').bind('click', searchBtnClick);
    $('#updateBtn').bind('click', updateBtnClick);
    $('#labNo').bind('keydown', function (e) {
        if (e.keyCode == 13) {
            updateBtnClick();
        }
    });
}
/**
 *@description 树菜单-加入运送单添加监听
 */
function addCarrySheetMenuClick() {
    $('#layoutCarry').layout('collapse', 'west');
    var nodes = $('#specTree').tree('getChecked');
    if (nodes.length > 0) {
        nodes.forEach(function (node) {
            if (node.labNo && node.labNo !== "") {
                insertCarrySheet(node.labNo);
            }
        });
        getCarrySheetDetailSpecs(GV.CarryNo);
        searchBtnClick();
    } else {
        $.messager.alert("提示", "请选择标本!", "info");
    }

}
/**
 *@description 标本树节点双击
 */
function specTreeNodeDblClick(node) {
    $('#layoutCarry').layout('collapse', 'west');
    var tab = $('#specTabs').tabs('getSelected');
    if (tab.context.id == "carryTab") {
        insertCarrySheet(node.labNo);
        getCarrySheetDetailSpecs(GV.CarryNo);
        searchBtnClick();
    }
}
/**
 * @description 初始化标本运送页签
 */
function initCarryTab() {
    initCarrySheetSearchCondition();
    $('#specTreeMenu').menu('removeItem', '#updateCollDateMenu');
    $('#specTreeMenu').menu('appendItem', {
        id: 'addCarrySheetMenu',
        text: '加入运送单',
        iconCls: 'icon-add',
        onclick: addCarrySheetMenuClick
    });
    $('#findCarrySheetBtn').bind('click', findCarrySheet);
    initGridCarrySheet();
    findCarrySheet();
    initGridCarrySheetDetail();
}

var init = function () {
    initSpecSearchCondition();
    var tab = $('#specTabs').tabs('getSelected');
    GV.specTree = $HUI.tree('#specTree', {
        url: $URL + '?ClassName=Nur.HISUI.SpecManage&MethodName=getSpecTree&WardID=' + GV.wardID + '&StartDate=' + GV.startDate + '&StartTime=' + GV.startTime + '&EndDate=' + GV.endDate + '&EndTime=' + GV.endTime + '&TabID=' + tab.context.id,
        checkbox: true,
        onContextMenu: function (e, node) {
            e.preventDefault();
            $(this).tree('select', node.target);
            $('#specTreeMenu').menu('show', {
                left: e.pageX,
                top: e.pageY
            });
        },
        onDblClick: specTreeNodeDblClick
    });
    $('#specTabs').tabs({ onSelect: tabSelected });
    initCollTab();
}
$(init)
