var workstation = {
    cardboard: null,
    banner: null,
    tabs: null,
    needRefreshContent: true
}
$(document).ready(function() {
    var today = (new Date()).format('yyyy-MM-dd');

    var menuItems = null;
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindOperRoom',
        Arg1: '',
        Arg2: 'R',
        ArgCnt: 2
    }, 'json', false, function(data) {
        menuItems = groupRooms(data);
    });

    workstation.tabs = $('#mainTabs');
    workstation.banner = operScheduleBanner.init('#patinfo_banner', {});
    workstation.cardboard = operScheduleCardboard.init($('#oper_cardboard'), {
        filterForm: {
            items: [{
                    id: 'filter_operdate',
                    valueField: 'OperDate',
                    textField: 'OperDate',
                    value: today,
                    label: '',
                    desc: '手术日期',
                    type: 'datebox',
                    prompt: '',
                    remote: true,
                    onChange: function() {
                        $('#filter_operroom').combobox('setValue', 'All');
                    }
                }, {
                    id: 'filter_operroom',
                    valueField: 'OperRoom',
                    textField: 'RoomDesc',
                    value: 'All',
                    text: '全部手术间',
                    label: '',
                    desc: '手术间',
                    type: 'combobox',
                    prompt: '',
                    sortable: true,
                    exact: true
                },
                {
                    id: 'filter_medcareno',
                    valueField: 'MedcareNo',
                    textField: 'MedcareNo',
                    extraFields: ['PatName'],
                    value: '',
                    text: '',
                    label: '',
                    desc: '住院号',
                    type: 'searchbox',
                    prompt: '请输入住院号或姓名'
                },
                [{
                    id: 'filter_emergency',
                    valueField: 'SourceType',
                    textField: 'SourceTypeDesc',
                    value: 'E',
                    label: '急诊',
                    desc: '',
                    type: 'checkbox',
                    checked: true,
                    prompt: ''
                }, {
                    id: 'filter_elective',
                    valueField: 'SourceType',
                    textField: 'SourceTypeDesc',
                    value: 'B',
                    label: '择期',
                    desc: '',
                    type: 'checkbox',
                    checked: true,
                    prompt: ''
                }, {
                    id: 'filter_andoc',
                    valueField: 'AnesthesiologistDesc',
                    textField: 'AnesthesiologistDesc',
                    float: 'right',
                    value: '',
                    label: '',
                    desc: '',
                    type: 'switchbox',
                    size: 'mini',
                    animated: true,
                    onText: '本人',
                    offText: '全部',
                    onValue: session.UserName,
                    offValue: 'All',
                    onClass: 'primary',
                    offClass: 'gray',
                    checked: false,
                    prompt: ''
                }]
            ]
        },
        operCard: {

        },
        menu: {
            items: [{
                text: '重新安排手术间',
                iconCls: '',
                items: menuItems,
                bindedData: { action: 'Rearrange' },
                activeStatuses: ['Application', 'Arrange', 'RoomIn']
            }, {
                text: '返回监护',
                iconCls: '',
                bindedData: { action: 'ReturnRoomIn' },
                activeStatuses: ['RoomOut']
            }],
            onClick: function(operCard, menuItemBindedData) {
                if (!menuItemBindedData || !operCard) return;
                if (menuItemBindedData.RowId) rearrangeRoom(operCard, menuItemBindedData)
                else if (menuItemBindedData.action === 'ReturnRoomIn') returnRoomIn(operCard)
            }
        },
        groupBy: {
            key: 'OperRoom',
            textField: 'RoomDesc',
            exceptedText: '未排'
        },
        sortBy: 'OperSeq',
        onSelectCard: function(card) {
            if (workstation.needRefreshContent) {
                refreshContent(card);
            } else {
                workstation.needRefreshContent = true;
            }
        },
        onQuery: loadOperSchedule,
        onMoveCard: function(changedCards) {
            var length = changedCards.length;
            var savingData = [];
            for (var i = 0; i < length; i++) {
                var card = changedCards[i];
                var operSchedule = card.bindedData;
                savingData.push({
                    ClassName: ANCLS.Model.OperSchedule,
                    RowId: operSchedule.RowId,
                    OperRoom: operSchedule.OperRoom,
                    OperSeq: operSchedule.OperSeq
                })
            }
            var jsonData = dhccl.formatObjects(savingData);
            dhccl.saveDatas(dhccl.csp.dataListService, {
                ClassName: ANCLS.BLL.OperArrange,
                MethodName: "SaveOperArrange",
                jsonData: jsonData
            }, function(data) {
                if (data.indexOf("S^") > -1) {
                    $('#saveSuccess_dialog').show();
                    $('#saveSuccess_dialog').css({ opacity: 1 });
                    setTimeout(function() {
                        $('#saveSuccess_dialog').animate({ opacity: 0 }, 3000, 'swing', function() {
                            $('#saveSuccess_dialog').hide();
                        });
                    }, 1000);
                    loadOperSchedule();
                } else {
                    dhccl.showMessage(data, "重新安排手术间失败", null, null, function() {});
                    loadOperSchedule();
                }
            });
        }
    });

    workstation.tabs.tabs('options').onSelect = function(title, index) {
        var tab = workstation.tabs.tabs('getTab', index);
        var tabOpts = tab.panel('options');
        if (tabOpts.content !== tabOpts.page) {
            tabOpts.content = tabOpts.page;
            tab.panel('refresh');
        }
    }

    loadModules();
    workstation.tabs.tabs('select', 0);

    loadOperSchedule();

    $('#filter_medcareno').siblings('.searchbox').find('.searchbox-button').click(function() {
        loadOperSchedule();
    });
    // 每分钟刷新一次当前选择病人的数据。
    //setInterval(loadOperSchedule, 60000);
});

/**
 * 重新安排手术间
 * @param {*} operCard 
 * @param {*} operRoom 
 */
function rearrangeRoom(operCard, operRoom) {
    if (!operRoom || !operCard) return;
    var operSchedule = operCard.bindedData;
    dhccl.saveDatas(dhccl.csp.methodService, {
        ClassName: ANCLS.BLL.OperArrange,
        MethodName: "ChangeOperRoom",
        Arg1: $('#filter_operdate').datebox('getValue'),
        Arg2: operSchedule.RowId,
        Arg3: operRoom.RowId,
        ArgCnt: 3
    }, function(data) {
        if (data.indexOf("S^") > -1) {
            $('#saveSuccess_dialog').css({ opacity: 1 });
            setTimeout(function() {
                $('#saveSuccess_dialog').animate({ opacity: 0 }, 3000, 'swing');
            }, 1000);
            loadOperSchedule();
        } else {
            dhccl.showMessage(data, "重新安排手术间失败", null, null, function() {});
            loadOperSchedule();
        }
    });
}

function returnRoomIn(operCard) {
    var operSchedule = operCard.bindedData;
    if (operSchedule.OperStatusCode === 'RoomOut') {
        var isPrinted = dhccl.getDatas(dhccl.csp.methodService, {
            ClassName: ANCLS.BLL.AnaestRecord,
            MethodName: "IsPrinted",
            Arg1: operSchedule.RowId,
            ArgCnt: 1
        }, "text", false);
        if (isPrinted === "Y") {
            var originalDefaults = $.extend({}, $.messager.defaults);
            $.extend($.messager.defaults, {
                ok: '取消',
                cancel: '继续'
            });
            $.messager.confirm("警告", "您已经打印此病人的麻醉记录单，返回监护会继续加载监护仪的数据！", function(confirmed) {
                if (!confirmed) {
                    doReturnRoomIn();
                }
            });
            $.extend($.messager.defaults, originalDefaults);
        } else {
            doReturnRoomIn();
        }

        function doReturnRoomIn() {
            dhccl.saveDatas(dhccl.csp.methodService, {
                ClassName: ANCLS.BLL.OperArrange,
                MethodName: "ReturnRoomIn",
                Arg1: operSchedule.RowId,
                ArgCnt: 1
            }, function(data) {
                if (data.indexOf("S^") > -1) {
                    operSchedule.OperStatusCode = 'RoomIn';
                    operCard.refreshStatus();
                } else {
                    dhccl.showMessage(data, "返回监护失败", null, null, function() {});
                }
            });
        }
    }
}

function loadModules() {
    var modulePermissions = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: 'FindModulePermission',
        Arg1: session.GroupID,
        Arg2: 'Y',
        ArgCnt: 2
    }, 'json', false);

    $.each(modulePermissions, function(index, dataItem) {
        if (!dataItem.ParentModule || dataItem.ParentModule == 'null' || dataItem.ParentModule == '') {
            return;
        }
        addTab(dataItem.DataModuleDesc, dataItem.Url + '?moduleCode=' + dataItem.DataModuleCode, false);
    });
}

function addTab(title, href, closeable) {
    var tabPanel = workstation.tabs,
        canClose = true;
    if (closeable == false) {
        canClose = false;
    }
    if (tabPanel.tabs('exists', title)) {
        tabPanel.tabs('select', title);
    } else {
        var content = '未实现';
        if (href) {
            content = '<iframe scrolling="yes" frameborder="0" src="' + href + '" style="width:100%;height:100%"></iframe>';
        }
        tabPanel.tabs('add', {
            selected: false,
            title: title,
            closable: canClose,
            content: '',
            url: href,
            page: content
        });
    }
}

function selectTab(title) {
    var tabPanel = $("#mainTabs");
    if (tabPanel.tabs("exists", title)) {
        tabPanel.tabs("select", title);
    }
}

function refreshContent(card) {
    workstation.banner.loadData(card.bindedData);
    var tabs = workstation.tabs.tabs("tabs");
    var selectedTab = workstation.tabs.tabs("getSelected");
    for (var i = 0; i < tabs.length; i++) {
        var tab = tabs[i];
        var tabOpts = tab.panel("options");
        var href = tabOpts.url + "&opsId=" + card.bindedData.RowId;
        var content = "<iframe scrolling='yes' frameborder='0' src='" + href + "' style='width:100%;height:100%;'></iframe>";
        if (tab === selectedTab) {
            workstation.tabs.tabs("update", {
                tab: tab,
                options: {
                    page: content,
                    content: content
                }
            });
        } else {
            workstation.tabs.tabs("update", {
                tab: tab,
                options: {
                    page: content
                }
            });
        }
    }
}

function reloadOperSchedule() {
    workstation.needRefreshContent = false;
    workstation.needReselect = true;
    loadOperSchedule();
}

function loadOperSchedule() {
    // 同步病理数据
    //dhccl.runServerMethod(ANCLS.BLL.Pathology, 'SyncPathData', selectedRow.Episode);
    var date = $('#filter_operdate').datebox('getValue');
    // 获取最新的手术数据
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperSchedule,
        QueryName: 'FindOperScheduleList',
        Arg1: date,
        Arg2: date,
        Arg3: session.DeptID,
        Arg4: '',
        Arg5: '',
        Arg6: '',
        Arg7: 'Application^Arrange^RoomIn^RoomOut^PACUIn^Finish^Stop^Cancel',
        ArgCnt: 7
    }, 'json', true, function(data) {
        if (data) {
            workstation.cardboard.loadData(data);
            if (workstation.needReselect) {
                var rowId = workstation.banner.operSchedule.RowId;
                workstation.cardboard.selectCard(rowId);
                workstation.needReselect = false;
            }
        }
    });
}

function groupRooms(data) {
    var groupCapacity = 5;
    var numReg = new RegExp('\\d+');
    var length = data.length;
    var groups = {},
        other = [],
        menuItems = [];

    for (var i = 0; i < length; i++) {
        var room = data[i];
        var exec = numReg.exec(room.Description);
        var num = 0,
            index = 0;
        if (exec) {
            num = Number(exec[0]);
            index = Math.ceil(num / groupCapacity);
            if (!groups[index]) groups[index] = {};
            groups[index][num] = room;
        } else {
            other.push(room);
        }
    }

    for (var i in groups) {
        menuItem = {
            text: '',
            items: []
        }
        var last = 0,
            text = '';
        for (var j in groups[i]) {
            if (!text) text = j;
            menuItem.items.push({
                text: groups[i][j].Description,
                bindedData: groups[i][j]
            });
            last = j;
        }
        last = last > 9 ? last : '0' + last;
        text = text > 9 ? text : '0' + text;
        menuItem.text = (last != text) ? (text + '-' + last) : text;
        menuItems.push(menuItem);
    }

    var length = other.length;
    if (length > 0) {
        var menuItem = {
            text: '其他',
            items: []
        }
        for (var i = 0; i < length; i++) {
            menuItem.items.push({
                text: other[i].Description,
                bindedData: other[i]
            })
        }
        menuItems.push(menuItem);
    }

    return menuItems;
}

function closeCurrentTab() {
    var selectedTab = $("#mainTabs").tabs("getSelected"),
        selectedIndex = $("#mainTabs").tabs("getTabIndex", selectedTab);
    $("#mainTabs").tabs("close", selectedIndex);
}