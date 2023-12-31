var banner, operListMenu, operRooms;
var lodop;
$(document).ready(function() {
    // 初始化串口信息
    // CLCom.initOptions();
    //lodop=getLodop();
    operRooms = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindOperRoom",
        Arg1: session.DeptID,
        Arg2: "R",
        ArgCnt: 2
    }, "json");
    var todayStr = (new Date()).format("yyyy-MM-dd");
    banner = operScheduleBanner.init('#patinfo_banner', {});
    $("#filterDate").datebox("setValue", todayStr);
    $("#filterOPRoom").next("span").find("input").prop("placeholder", "手术间");
    $("#filterOPRoom").combobox({
        valueField: "RowId",
        textField: "Description",
        // url: ANCSP.DataQuery,
        // onBeforeLoad: function(param) {
        //     param.ClassName = ANCLS.BLL.ConfigQueries;
        //     param.QueryName = "FindOperRoom";
        //     param.Arg1 = session.DeptID;
        //     param.ArgCnt = 1;
        // },
        data: operRooms,
        onLoadSuccess: function(data) {
            // if(data && data.length>0){
            //     var firstRoom=data[0];
            //     $(this).combobox("setValue",firstRoom.RowId);
            //     // $("#operListBox").datagrid("reload");
            // }
        }
    });

    $("#operListBox").datagrid({
        fit: true,
        singleSelect: true,
        border: false,
        toolbar: "#operListTool",
        url: ANCSP.DataQuery,
        // pagination: true,
        // pageList: [12, 30],
        // pageSize: 12,
        showPageList: false,
        showRefresh: false,
        sortName: "RoomInfo,OperSeqInfo",
        sortOrder: "asc,asc",
        remoteSort: false,
        multiSort: true,
        // afterPageText: "页",
        // beforePageText: '',
        displayMsg: "",
        columns: [
            [
                { field: "RoomDesc", title: "术间", width: 60 },
                { field: "OperSeq", title: "台次", width: 40 },
                { field: "RoomInfo", title: "术间", width: 60, hidden: true },
                { field: "OperSeqInfo", title: "台次", width: 40, hidden: true },
                { field: "Patient", title: "患者", width: 110 }
            ]
        ],
        rowStyler: function(index, row) {
            return "background-color:" + row.StatusColor + ";";
        },
        queryParams: {
            ClassName: dhcan.bll.operSchedule,
            QueryName: "FindOperScheduleList",
            ArgCnt: 14
        },
        onBeforeLoad: function(param) {
            var selectedRoomId = $("#filterOPRoom").combobox("getValue");
            var selectedRoomDesc = $("#filterOPRoom").combobox("getText");
            if (!selectedRoomDesc || selectedRoomDesc === splitchar.empty) {
                selectedRoomId = splitchar.empty;
            }
            param.Arg1 = $("#filterDate").datebox("getValue");
            param.Arg2 = $("#filterDate").datebox("getValue");
            param.Arg3 = session.DeptID;
            param.Arg4 = "";
            param.Arg5 = "";
            param.Arg6 = "";
            param.Arg7 = "Application^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Stop^Cancel";
            param.Arg8 = selectedRoomId;
            param.Arg9 = "";
            param.Arg10 = "";
            param.Arg11 = "N";
            param.Arg12 = "N";
            param.Arg13 = "N";
            param.Arg14 = $("#filterPatName").val();
        },
        onSelect: function(rowIndex, rowData) {
            banner.loadData(rowData);
            var tabs = $("#mainTabs").tabs("tabs");
            var selectedTab = $("#mainTabs").tabs("getSelected");
            for (var i = 0; i < tabs.length; i++) {
                var tab = tabs[i];
                var tabOpts = tab.panel("options");
                var href = tabOpts.url + "&opsId=" + rowData.RowId;
                var content = "<iframe id='" + tabOpts.moduleCode + "' scrolling='yes' frameborder='0' src='" + href + "' style='width:100%;height:100%;'></iframe>";
                if (tab === selectedTab) {
                    $("#mainTabs").tabs("update", {
                        tab: tab,
                        options: {
                            page: content,
                            content: content
                        }
                    });
                } else {

                    $("#mainTabs").tabs("update", {
                        tab: tab,
                        options: {
                            page: content
                        }
                    });
                }

            }
        },
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length > 0) {
                var selectedRow = $(this).datagrid("getSelections");
                if (!selectedRow || selectedRow === null || selectedRow.length <= 0) {
                    $(this).datagrid("selectRow", 0);
                }

            }
        },
        onDblClickRow: function(rowIndex, rowData) {
            $("body").layout("collapse", "west");
        },
        onRowContextMenu: function(e, rowIndex, rowData) {
            e.preventDefault();
            if (!operListMenu) {
                createOperListMenu(rowData);
            }
            operListMenu.menu('show', {
                left: e.pageX,
                top: e.pageY
            });
            var opts = operListMenu.menu("options");
            opts.rowIndex = rowIndex;
            opts.rowData = rowData;

            // 对正常的手术，禁用恢复手术菜单，启用停止手术菜单。
            var recoverMenuItem = operListMenu.menu("findItem", "恢复手术");
            var stopMenuItem = operListMenu.menu("findItem", "停止手术");
            var arrangeMenuItem = operListMenu.menu("findItem", "安排手术间");
            if (recoverMenuItem && rowData.OperStatusCode !== "Stop" && rowData.OperStatusCode !== "Cancel") {
                operListMenu.menu("disableItem", recoverMenuItem.target);
                operListMenu.menu("enableItem", stopMenuItem.target);
                operListMenu.menu("enableItem", arrangeMenuItem.target);
            }
            // 对停止的手术，禁用停止手术菜单，启用恢复手术菜单。
            if (recoverMenuItem && (rowData.OperStatusCode === "Stop" || rowData.OperStatusCode === "Cancel")) {
                operListMenu.menu("disableItem", stopMenuItem.target);
                operListMenu.menu("disableItem", arrangeMenuItem.target);
                operListMenu.menu("enableItem", recoverMenuItem.target);
            }
        }
    });



    $("#btnQuery").linkbutton({
        onClick: function() {
            $("#operListBox").datagrid("reload");
        }
    });

    $("#btnRefresh").linkbutton({
        onClick: function() {
            $.messager.confirm("提示", "是否要刷新整个页面，如果页面有未保存的数据，请先保存再刷新。", function(result) {
                if (result) {
                    window.location.reload();
                }
            })
        }
    });

    $("#btnMoveUp,#btnMoveDown").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected($("#operListBox"), true)) {
                var selectedRow = $("#operListBox").datagrid("getSelected");
                var direction = ($(this).attr("id") === "btnMoveUp") ? "up" : "down";
                var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ChangeOperSeq", selectedRow.RowId, direction);
                if (ret.success) {
                    $("#operListBox").datagrid("reload");
                }
            }

        }
    });

    $("#mainTabs").tabs("options").onSelect = function(title, index) {
            var tab = $("#mainTabs").tabs("getTab", index);
            var tabOpts = tab.panel("options");
            if (tabOpts.content !== tabOpts.page) {
                tabOpts.content = tabOpts.page;
                tab.panel("refresh");
            }
            var tabs = $("#mainTabs").tabs("tabs");
            if (tabs && tabs.length) {
                for (var i = 0; i < tabs.length; i++) {
                    var curTab = tabs[i];
                    if (curTab !== tab && curTab.closeComm) {
                        curTab.closeComm();
                    }
                }
            }
        }
        // addTab("手术访视", "dhcan.operationvisitsxzl.csp?moduleCode=OperationVisit", false);
        // addTab("患者交接", "dhcan.patienthandoversxzl.csp?moduleCode=PatientHandOver", false);
        // addTab("安全核查", "dhcan.opersafetycheck.csp?moduleCode=OperSafetyCheck", false);
        // addTab("风险评估", "dhcan.operriskassessment.csp?moduleCode=OperRiskAssessment", false);
        // addTab("手术清点", "dhcan.opercountsxzl.csp?moduleCode=OperCount", false);
        // addTab("标本管理", "dhcan.specimenmanager.csp?moduleCode=SpecimenManager", false);
        // addTab("输血记录", "dhcan.bloodtransfusion.csp?moduleCode=BloodTransfusion", false);
        // addTab("术前麻醉访视", "dhcan.preanestheticvisit.sxzl.csp?moduleCode=PreAnaVisit", false);
        // addTab("术后麻醉访视", "dhcan.postanestheticvisit.sxzl.csp?moduleCode=PostAnaVisit", false);
        // addTab("麻醉记录", "dhcan.anaestrecord.csp?moduleCode=AnaestRecord", false);
        // addTab("术后麻醉随访", "dhcan.postpatientsflup.sxzl.csp?moduleCode=PostPatientsFlup", false);
    loadModules();
    $("#mainTabs").tabs("select", 0);

    // 每分钟刷新一次当前选择病人的数据。
    setInterval(loadOperSchedule, 60000);


});

function printTask(iframeId, lodop) {
    var iframeObj = document.getElementById(iframeId);
    if (iframeObj && iframeObj.contentWindow.createPrintOnePage) {
        // iframeObj.contentWindow.createPrintOnePage(lodop,true);
    }
}

function closeComm(closeCallBack) {
    var selectedTab = $("#mainTabs").tabs("getSelected");
    if (selectedTab) {
        var tabOpts = selectedTab.panel("options");
        tabOpts.closeComm = closeCallBack;
    }
}

function loadModules() {
    var modulePermissions = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindModulePermission",
        Arg1: session.GroupID,
        Arg2: "Y",
        ArgCnt: 2
    }, "json", false);

    $.each(modulePermissions, function(index, dataItem) {
        if (!dataItem.ParentModule || dataItem.ParentModule == "null" || dataItem.ParentModule == "") {
            return;
        }
        addTab(dataItem.DataModuleDesc, dataItem.Url + "?moduleCode=" + dataItem.DataModuleCode, false, dataItem.DataModuleCode);
    });
}

function addTab(title, href, closeable, moduleCode) {
    var tabPanel = $("#mainTabs"),
        canClose = true;
    if (closeable == false) {
        canClose = false;
    }
    if (tabPanel.tabs("exists", title)) {
        tabPanel.tabs("select", title);
    } else {
        var content = "未实现";
        // if (href) {
        //     content = "<iframe scrolling='yes' frameborder='0' src='" + href + "' style='width:100%;height:100%'></iframe>";
        // }
        tabPanel.tabs("add", {
            title: title,
            closable: canClose,
            content: "",
            url: href,
            page: content,
            moduleCode: moduleCode
        });
    }
}

function loadOperSchedule() {
    if (dhccl.hasRowSelected($("#operListBox"), false)) {
        var selectedRow = $("#operListBox").datagrid("getSelected");
        // 同步病理数据
        dhccl.runServerMethodAsync(ANCLS.BLL.Pathology, "SyncPathData", selectedRow.EpisodeID);
        // 获取最新的手术数据
        dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.BLL.OperSchedule,
            QueryName: "FindOperScheduleList",
            Arg1: "",
            Arg2: "",
            Arg3: "",
            Arg4: selectedRow.RowId,
            ArgCnt: 4
        }, "json", true, function(appDatas) {
            if (appDatas && appDatas.length > 0) {
                var selectedIndex = $("#operListBox").datagrid("getRowIndex", selectedRow);
                $("#operListBox").datagrid("updateRow", {
                    index: selectedIndex,
                    row: appDatas[0]
                });
                banner.loadData(appDatas[0]);
                var appData = appDatas[0];
                // if(appData.PathResult && appData.PathResult!="" && lodop){
                //     lodop.FORMAT("VOICE:-1;70","有新的病理诊断结果！");
                // }
            }
        });

    }
}

/**
 * 创建手术列表上下文菜单
 */
function createOperListMenu(rowData) {
    operListMenu = $("<div id='operListMenu'></div>").appendTo("body");
    operListMenu.menu({

    });

    // 手术间菜单分为1~5,6~10,11~15,16~20,21~25
    var operRoomItems = [];
    if (operRooms && operRooms.length > 0) {
        var itemRoomCount = 5;
        for (var i = 0; i < operRooms.length; i++) {
            if (i % itemRoomCount === 0) {
                var itemText = (operRoomItems.length * itemRoomCount + 1) + "~" + (operRoomItems.length * itemRoomCount + itemRoomCount);
                operRoomItems.push({
                    text: itemText,
                    items: []
                });
            }
            if (operRoomItems.length > 0) {
                var lastRoomItem = operRoomItems[operRoomItems.length - 1];
                var operRoom = operRooms[i];
                lastRoomItem.items.push({
                    id: operRoom.RowId,
                    text: operRoom.Description,
                    dataItem: operRoom
                });
            }
        }
    }
    operListMenu.menu("appendItem", {
        text: "安排手术间",
        name: "ArrangeOperRoom"
    });
    var arrangeOperRoomItem = operListMenu.menu("findItem", "安排手术间");
    if (operRoomItems && operRoomItems.length > 0 && arrangeOperRoomItem) {
        for (var i = 0; i < operRoomItems.length; i++) {
            var roomItem = operRoomItems[i];
            operListMenu.menu("appendItem", {
                text: roomItem.text,
                parent: arrangeOperRoomItem.target
            });
            var roomItemMenu = operListMenu.menu("findItem", roomItem.text);
            if (roomItemMenu && roomItem.items && roomItem.items.length > 0) {
                for (var j = 0; j < roomItem.items.length; j++) {
                    var roomDetailItem = roomItem.items[j];
                    operListMenu.menu("appendItem", {
                        id: roomDetailItem.id,
                        text: roomDetailItem.text,
                        dataItem: roomDetailItem.dataItem,
                        parent: roomItemMenu.target,
                        onclick: arrangeOperRoom
                    });
                }
            }
        }
    }

    operListMenu.menu("appendItem", {
        text: "台次上移",
        name: "MoveUp",
        onclick: moveUp
    });

    operListMenu.menu("appendItem", {
        text: "台次下移",
        name: "MoveDown",
        onclick: moveDown
    });

    // operListMenu.menu("appendItem",{
    //     text:"通知接患者",
    //     name:"CallPatShift",
    //     onclick:callPatShift 
    // });

    // operListMenu.menu("appendItem",{
    //     text:"通知取血",
    //     name:"CallBloodShift",
    //     onclick:callBloodShift 
    // });

    // operListMenu.menu("appendItem",{
    //     text:"通知送冰冻",
    //     name:"CallSpecimenIceShift",
    //     onclick:callSpecimenIceShift 
    // });
    // operListMenu.menu("appendItem",{
    //     text:"通知送病理",
    //     name:"CallSpecimenShift",
    //     onclick:callSpecimenShift 
    // });

    operListMenu.menu("appendItem", {
        text: "恢复手术",
        name: "RecoverOperation",
        onclick: recoverOperation
    });

    operListMenu.menu("appendItem", {
        text: "停止手术",
        name: "StopOperation",
        onclick: stopOperation
    });

    operListMenu.menu("appendItem", {
        text: "二次手术",
        name: "SecondOperation",
        onclick: secondOperation
    });
}

function callPatShift() {
    if (dhccl.hasRowSelected($("#operListBox"), true)) {
        var selectedRow = $("#operListBox").datagrid("getSelected");
        var ret = dhccl.runServerMethod(ANCLS.BLL.TransMessage, "SaveMessage", selectedRow.RowId, session.UserID, "", "通知接患者");
        if (ret.success) {
            $.messager.alert("提示", "消息发送成功。", "info");
        } else {
            $.messager.alert("提示", "消息发送失败。原因：" + ret.result, "info");
        }
    }
}

function callSpecimenIceShift() {
    if (dhccl.hasRowSelected($("#operListBox"), true)) {
        var selectedRow = $("#operListBox").datagrid("getSelected");
        var ret = dhccl.runServerMethod(ANCLS.BLL.TransMessage, "SaveMessage", selectedRow.RowId, session.UserID, "", "通知送冰冻");
        if (ret.success) {
            $.messager.alert("提示", "消息发送成功。", "info");
        } else {
            $.messager.alert("提示", "消息发送失败。原因：" + ret.result, "info");
        }
    }
}

function callSpecimenShift() {
    if (dhccl.hasRowSelected($("#operListBox"), true)) {
        var selectedRow = $("#operListBox").datagrid("getSelected");
        var ret = dhccl.runServerMethod(ANCLS.BLL.TransMessage, "SaveMessage", selectedRow.RowId, session.UserID, "", "通知送病理");
        if (ret.success) {
            $.messager.alert("提示", "消息发送成功。", "info");
        } else {
            $.messager.alert("提示", "消息发送失败。原因：" + ret.result, "info");
        }
    }
}

function callBloodShift() {
    if (dhccl.hasRowSelected($("#operListBox"), true)) {
        var selectedRow = $("#operListBox").datagrid("getSelected");
        var ret = dhccl.runServerMethod(ANCLS.BLL.TransMessage, "SaveMessage", selectedRow.RowId, session.UserID, "", "通知取血");
        if (ret.success) {
            $.messager.alert("提示", "消息发送成功。", "info");
        } else {
            $.messager.alert("提示", "消息发送失败。原因：" + ret.result, "info");
        }
    }
}

function moveUp() {
    if (dhccl.hasRowSelected($("#operListBox"), true)) {
        var selectedRow = $("#operListBox").datagrid("getSelected");
        var direction = "up";
        var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ChangeOperSeq", selectedRow.RowId, direction);
        if (ret.success) {
            $("#operListBox").datagrid("reload");
        }
    }
}

function moveDown() {
    if (dhccl.hasRowSelected($("#operListBox"), true)) {
        var selectedRow = $("#operListBox").datagrid("getSelected");
        var direction = "down";
        var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ChangeOperSeq", selectedRow.RowId, direction);
        if (ret.success) {
            $("#operListBox").datagrid("reload");
        }
    }
}

function arrangeOperRoom(menuItem) {
    var menuItem = $("#operListMenu").menu("getItem", this);
    var roomId = menuItem.id;
    var opts = $("#operListMenu").menu("options");
    if (opts.rowData && roomId) {
        var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ChangeOperRoom", opts.rowData.OperDate, opts.rowData.RowId, roomId);
        if (ret.success) {
            $("#operListBox").datagrid("reload");
        } else {
            $.messager.alert("提示", ret.result, "error");
        }
    }

}

function stopOperation() {
    var opts = $("#operListMenu").menu("options");
    if (opts && opts.rowData && opts.rowData.RowId) {
        $.messager.confirm("提示", "是否要停止患者" + opts.rowData.PatName + "的手术？", function(result) {
            if (result) {
                var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "StopOperation", opts.rowData.RowId, session.UserID, "");
                if (ret.success) {
                    $("#operListBox").datagrid("reload");
                } else {
                    $.messager.alert("提示", ret.result, "error");
                }
            }
        });
    }
}

function recoverOperation() {
    var opts = $("#operListMenu").menu("options");
    if (opts && opts.rowData && opts.rowData.RowId) {
        $.messager.confirm("提示", "是否要恢复患者" + opts.rowData.PatName + "的手术？", function(result) {
            if (result) {
                var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "RecoverOperation", opts.rowData.RowId);
                if (ret.success) {
                    $("#operListBox").datagrid("reload");
                } else {
                    $.messager.alert("提示", ret.result, "error");
                }
            }
        });
    }
}

function secondOperation() {
    var opts = $("#operListMenu").menu("options");
    if (opts && opts.rowData && opts.rowData.RowId) {
        $.messager.confirm("提示", "是否要创建患者" + opts.rowData.PatName + "的二次手术？该功能只针对局麻患者的二次手术，请谨慎操作！", function(result) {
            if (result) {
                var ret = dhccl.runServerMethod(ANCLS.BLL.OperSchedule, "CopyOperSchedule", opts.rowData.RowId);
                if (ret.success) {
                    $("#operListBox").datagrid("reload");
                } else {
                    $.messager.alert("提示", ret.result, "error");
                }
            }
        });
    }
}