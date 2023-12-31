var operListMenu, operRooms;
var station = {
    selectedRecord: null,
    banner: null
};

function initPage() {
    //initWS();
    initMenuGroup();
    initOperList();
    initQueryForm();
    initOperationInfo();
    initWorkbenchTitle();
    //$("html").niceScroll();
    //console.log(session);
}

var ws;

function initWS() {
    ws = new WebSocket("ws://" + window.location.host + "/dthealth/web/CIS.AN.SRV.Message.cls");
    ws.onopen = function() {
        ws.send("发送数据");
        console.log("数据发送中");
    };
    ws.onmessage = function(evt) {
        console.log("接收到数据：" + evt.data);
    };
    ws.onclose = function() {
        console.log("连接已关闭");
    }
}

function initWorkbenchTitle() {
    var menuCode = dhccl.getQueryString("menuCode");
    var west = $("body").layout("panel", "west");
    var title = "手术工作站";
    switch (menuCode) {
        case "ANWSMenu":
            title = "麻醉工作站";
            break;
    }
    west.panel("setTitle", title);
}

/**
 * 初始化手术信息，如果未选择手术记录，那么弹出手术列表界面让用户选择
 * @author chenchangqing 20190305
 */
function initOperationInfo() {
    var opsId = dhccl.getQueryString("opsId");
    if (opsId && opsId !== "") {
        initPatientBanner();
        initTabs();
        initPACUAdmissionView();
		initGroupSetting();
    } else {
        $("#operlistDialog").dialog("open");
    }
}

function initMenuGroup() {
    var menuCode = dhccl.getQueryString("menuCode");
    if (!menuCode && session.MenuCode) {
        menuCode = session.MenuCode;
    }
    var menuItems = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindMenuItemForGroup",
        Arg1: session.GroupID,
        Arg2: menuCode,
        ArgCnt: 2
    }, "json");
    if (menuItems && menuItems.length > 0) {
        var menuItemsGroups = dhccl.group(menuItems, "MainItemDesc");
        if (menuItemsGroups && menuItemsGroups.length > 0) {
            $("#menuGroupReg").accordion({
                border: false,
                multiple: true,
                fit: true,

            });
            for (var i = 0; i < menuItemsGroups.length; i++) {
                var htmlArr = [];
                var menuItemsGroup = menuItemsGroups[i];
                if (!menuItemsGroup.id || menuItemsGroup.data.length < 1) continue;
                var firstMenuItem = menuItemsGroup.data[0];

                htmlArr.push("<ul class='i-menugroup'>");
                for (var j = 0; j < menuItemsGroup.data.length; j++) {
                    var menuItem = menuItemsGroup.data[j];
                    htmlArr.push("<li><a id='" + menuItem.MenuItemCode + "' href='#' data-title='" + menuItem.DisplayName + "' data-url='" + menuItem.Url + "' data-modulecode='" + menuItem.ModuleCode + "' data-exp='" + menuItem.Exp + "'>" + menuItem.DisplayName + "</a></li>");
                }
                htmlArr.push("</ul></div>");
                var opts = {
                    title: firstMenuItem.MainItemDisplayName,
                    content: htmlArr.join(""),
                    collapsible: false,
                    collapsed: false,
                    bodyCls: "group-body",
                    border: false
                };
                if (i === 0) {
                    opts.tools = [{
                        iconCls: 'layout-button-left',
                        handler: function() {

                        }
                    }];
                }
                $("#menuGroupReg").accordion("add", opts);

            }
            //$("#menuGroupReg").append(htmlArr.join(""));

        }
    }
    var opsId = dhccl.getQueryString("opsId");
    var PatientID = dhccl.getQueryString("PatientID");
    var EpisodeID = dhccl.getQueryString("EpisodeID");
    var opaId = dhccl.getQueryString("opaId");
    var anaesthesiaID = dhccl.getQueryString("AnaesthesiaID");
    $("ul.i-menugroup>li>a").each(function(index, item) {
        if ($(item).hasClass("open-all") || $(item).hasClass("close-all")) return;
        var moduleCode = $(item).attr("data-modulecode");
        var dataUrl = $(item).attr("data-url") + "?PatientID=" + PatientID + "&EpisodeID=" + EpisodeID + "&opsId=" + opsId + "&moduleCode=" + moduleCode + "&opaId=" + opaId + "&AnaesthesiaID=" + anaesthesiaID;
        var dataTitle = $(item).attr("data-title");
        var dataExp = $(item).attr("data-exp");
        var target = $(item).attr("target");

        if (dataExp && dataExp !== "") {
            dataUrl += dataExp;
        }
        var menuIndex = parseInt($(item).attr("data-menuindex"));
        if (dataUrl && dataUrl !== "" && dataTitle && dataTitle !== "") {
            if (target === "_blank") {
                $(item).attr("href", dataUrl);
            } else {
                $(item).attr("href", "javascript:addTab('" + dataTitle + "','" + dataUrl + "')");
            }

        }

    });
}

function reloadOperSchedule() {
    var opsId = dhccl.getQueryString("opsId");
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperScheduleList,
        QueryName: "FindOperScheduleList",
        Arg1: "",
        Arg2: "",
        Arg3: "",
        Arg4: opsId,
        ArgCnt: 4
    }, "json", true, function(appDatas) {
        if (appDatas && appDatas.length > 0) {
            station.banner.loadData(appDatas[0]);
            /*
            $("#btnOperList").linkbutton({
                onClick: function() {
                    $("#operlistDialog").dialog("open");
                }
            });

            $("#btnFullScreen").linkbutton({
                onClick: function() {

                }
            });*/

            setHeaderParam(appDatas[0]);
        }
    });
}

/**
 * 更新手术Banner关键事件时间
 */
function refreshKeyTimeline() {
    station.banner.refreshData();
}

function initPatientBanner() {
    var banner = operScheduleBanner.init('#patinfo_banner', {
        buttons: [{
            id: 'btnBatchPrint',
            text: '批量打印',
            class: 'oper-banner-button',
            hidden: false,
            onClick: function() {
                var opsId = dhccl.getQueryString("opsId");
				var frame = "<iframe scrolling='yes' frameborder='0' src='CIS.AN.BatchPrint.csp?opsId="+opsId+"' style='width:100%;height:100%'></iframe>";
				$("#batchPrintView").dialog({
					height: 650,
					width: 950,
					title: '批量打印',
					modal: true,
					closed: true,
					content: frame,
					iconCls: "icon-w-print"
				});
				$("#batchPrintView").dialog("open");
            }
        },{
            id: 'btnPACUAdmission',
            text: 'PACU准入',
            class: 'oper-banner-button',
            hidden: true,
            onClick: function() {
                openPACUAdmissionView();
            }
        }, {
            id: 'btnFullScreen',
            text: '全屏',
            class: 'oper-banner-button',
            onClick: function() {
                var mode = $(this).data('mode');
                if (mode == undefined || mode == 'on') {
                    $(this).data('mode', 'off')
                    fullScreen();
                    $(this).find('.l-btn-text').text('退出全屏');
                } else {
                    $(this).data('mode', 'on')
                    exitFullScree();
                    $(this).find('.l-btn-text').text('全屏');
                }
            }
        }, {
            id: 'btnOperList',
            text: '手术列表',
            class: 'oper-banner-button',
            onClick: function() {
                $("#operlistDialog").dialog("open");
				$("#operlistBox").datagrid("reload");
            }
        }],
        refresh: function(operSchedule, callback) {
            var opsId = operSchedule.RowId;
            dhccl.getDatas(ANCSP.MethodService, {
                ClassName: ANCLS.BLL.OperScheduleList,
                MethodName: 'GetProcedureTime',
                Arg1: opsId,
                ArgCnt: 1
            }, 'json', true, callback);
        }
    });
    station.banner = banner;

    var opsId = dhccl.getQueryString("opsId");
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.OperScheduleList,
        QueryName: "FindOperScheduleList",
        Arg1: "",
        Arg2: "",
        Arg3: "",
        Arg4: opsId,
        ArgCnt: 4
    }, "json", true, function(appDatas) {
        if (appDatas && appDatas.length > 0) {
            banner.loadData(appDatas[0]);
            /*
            $("#btnOperList").linkbutton({
                onClick: function() {
                    $("#operlistDialog").dialog("open");
                }
            });

            $("#btnFullScreen").linkbutton({
                onClick: function() {}
            });*/

            setHeaderParam(appDatas[0]);
        }
    });
}

function openPACUAdmissionView() {
    var view = window.PACUAdmissionView.instance;
    if (view) view.open();
}

function setHeaderParam(operSchedule) {
    var EpisodeID = operSchedule.EpisodeID;
    var PatientID = operSchedule.PatientID;
    var mradm = operSchedule.MRAdmID || '';
    var AnaesthesiaID = operSchedule.ExtAnaestID || '';

    var win = top.frames['eprmenu'];
    var frm;
    if (win)
        frm = win.document.forms['fEPRMENU'];
    else
        frm = dhcsys_getmenuform();

    if (frm) {
        frm.EpisodeID.value = EpisodeID;
        frm.PatientID.value = PatientID;
        frm.mradm.value = mradm;
        if (frm.AnaesthesiaID)
            frm.AnaesthesiaID.value = AnaesthesiaID;
    }
}

function initOperList() {

    $("#filterPatInfo").keyup(function(e) {
        if (e.keyCode === 13) {
            var text = $(this).val();
            if (text && text.length < 10) {
                var zeroArr = [];
                for (var i = 0; i < 10 - text.length; i++) {
                    zeroArr.push(0);
                }
                $(this).val(zeroArr.join("") + text);
            }
            $("#operlistBox").datagrid("reload");
        }
    });

    $("#operlistDialog").dialog({
        onBeforeClose: function() {
            let opsId = dhccl.getQueryString("opsId");
            if (!opsId) {
                $.messager.alert("提示", "请鼠标左键双击需要操作的手术记录。", "warning");
                return false;
            }
        },
        iconCls: "icon-w-list"
    });
    dhccl.parseDateFormat();
    var today = new Date();
    var todayStr = today.format("yyyy-MM-dd");
    var defQueryDate = dhccl.getQueryString("QueryDate");
    if (defQueryDate) {
        $("#filterOperDate").datebox("setValue", defQueryDate);
    } else {
        $("#filterOperDate").datebox("setValue", todayStr);
    }

    $("#operlistBox").datagrid({
        fit: true,
        toolbar: "#operlistTools",
        rownumbers: true,
        view: groupview,
        groupField: "RoomDesc",
        singleSelect: true,
        groupFormatter: function(value, rows) {
            if (!value) {
                return "未排";
            }
            return value;
        },
        columns: [
            [{
                    field: "StatusDesc",
                    title: "状态",
                    width: 50,
                    styler: function(value, row, index) {
              			return "background-color:" + row.StatusColor + ";color:white;text-align:center";
                    }
                },
                {
                    field: "SourceTypeDesc",
                    title: "类型",
                    width: 50,
                    styler: function(value, row, index) {
                        switch (row.SourceType) {
                			case "B":
                  			return "background-color:" + SourceTypeColors.Book + ";color:white;text-align:center";
                			case "E":
                  			return "background-color:" + SourceTypeColors.Emergency + ";color:white;text-align:center";
                			default:
                  			return "background-color:white;color:white;text-align:center";
                        }
                    }
                },
                { field: "RoomDesc", title: "术间", width: 80 },
                { field: "OperSeq", title: "台次", width: 50 },
                { field: "PatName", title: "患者姓名", width: 80 },
                { field: "PatGender", title: "性别", width: 50 },
                { field: "PatAge", title: "年龄", width: 50 },
                { field: "OperDesc", title: "手术名称", width: 300 },
                { field: "SurgeonDesc", title: "手术医生", width: 80 },
                { field: "AnesthesiologistDesc", title: "麻醉医生", width: 80 },
                { field: "ScrubNurseDesc", title: "器械护士", width: 80 },
                { field: "CircualNurseDesc", title: "巡回护士", width: 80 },
                { field: "OperDate", title: "手术时间", width: 100 }
            ]
        ],
        // rowStyler: function(index, row) {
        //     return "background-color:" + row.StatusColor + ";";
        // },
        url: ANCSP.DataQuery,
        queryParams: {
            ClassName: ANCLS.BLL.OperScheduleList,
            QueryName: "FindOperScheduleList",
            ArgCnt: 11
        },
        onBeforeLoad: function(param) {
            var selectedRoomId = $("#filterOperRoom").combobox("getValue");
            var selectedRoomDesc = $("#filterOperRoom").combobox("getText");
            if (!selectedRoomDesc || selectedRoomDesc === splitchar.empty) {
                selectedRoomId = splitchar.empty;
            }
            param.Arg1 = $("#filterOperDate").datebox("getValue");
            param.Arg2 = $("#filterOperDate").datebox("getValue");
            param.Arg3 = session.DeptID;
            param.Arg4 = "";
            param.Arg5 = "";
            param.Arg6 = "";
            // param.Arg7 = "Application^Audit^Arrange^RoomIn^RoomOut^PACUIn^Finish^AreaOut^Stop^Accept";
            param.Arg7 = "Arrange^RoomIn^RoomOut^PACUIn^Finish^AreaOut^Stop";
            param.Arg8 = selectedRoomId;
            param.Arg9 = $("#filterPatInfo").val();
            //param.Arg9 ="";
            param.Arg10 = "";
            param.Arg11 = "N";
        },
        onDblClickRow: function(rowIndex, rowData) {
            var queryDate = $("#filterOperDate").datebox("getValue");
            var menuCode = dhccl.getQueryString("menuCode");
            if (!menuCode && session.MenuCode) {
                menuCode = session.MenuCode;
            }
            window.location = "cis.an.workstation.csp?opsId=" + rowData.RowId + "&opaId=" + rowData.OPAID + "&PatientID=" + rowData.PatientID + "&EpisodeID=" + rowData.EpisodeID + "&AnaesthesiaID=" + rowData.ExtAnaestID + "&QueryDate=" + queryDate + "&menuCode=" + menuCode;
        },
        onSelect: function(rowIndex, rowData) {
            //$("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='" + rowIndex + "'] td").css({ "color": "#FFF", "background-color": "#0081c2" });
            selectPatient(rowData);
        },
        onUnselect: function(rowIndex, rowData) {
            $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='" + rowIndex + "'] td").css({ "color": "#000", "background-color": "#fff" });
            switch (rowData.SourceType) {
                case "B":
                    $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='" + rowIndex + "'] td[field='SourceTypeDesc']").css({ "color": "#000", "background-color": "yellow" });
                    break;
                case "E":
                    $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='" + rowIndex + "'] td[field='SourceTypeDesc']").css({ "color": "#000", "background-color": "red" });
                    break;
            }
            $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='" + rowIndex + "'] td[field='StatusDesc']").css({ "color": "#000", "background-color": "" + rowData.StatusColor + "" });
            // $("#operlistBox").parent(".datagrid-view").find("tr[datagrid-row-index='"+rowIndex+"'] .sourcetype-em").css("color","red");
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
            var returnRoomInMenuItem = operListMenu.menu("findItem", "重返术中");
            if (recoverMenuItem && rowData.StatusCode !== "Stop" && rowData.StatusCode !== "Cancel") {
                operListMenu.menu("disableItem", recoverMenuItem.target);
                operListMenu.menu("enableItem", stopMenuItem.target);
                operListMenu.menu("enableItem", arrangeMenuItem.target);
            }
            if (arrangeMenuItem && rowData.StatusCode === "RoomIn" || rowData.StatusCode === "RoomOut" || rowData.StatusCode === "PACUIn" || rowData.StatusCode === "AreaOut" || rowData.StatusCode === "Stop") {
                operListMenu.menu("disableItem", arrangeMenuItem.target);
            }
            // 对停止的手术，禁用停止手术菜单，启用恢复手术菜单。
            if (recoverMenuItem && (rowData.StatusCode === "Stop" || rowData.StatusCode === "Cancel")) {
                operListMenu.menu("disableItem", stopMenuItem.target);
                operListMenu.menu("disableItem", arrangeMenuItem.target);
                operListMenu.menu("enableItem", recoverMenuItem.target);
            }

            // 术毕和完成的手术可以重返术中
            if (returnRoomInMenuItem) {
                if (rowData.StatusCode === "RoomOut" || rowData.StatusCode === "Finish") {
                    operListMenu.menu("enableItem", returnRoomInMenuItem.target);
                } else {
                    operListMenu.menu("disableItem", returnRoomInMenuItem.target);
                }
            }
        }
    });

    $("#btnQuery").linkbutton({
        onClick: function() {
            $("#operlistBox").datagrid("reload");
        }
    })

    $("#filterPatInfo").keypress(function(e) {
        if (e.keyCode == 13) {
            if ($("#filterPatInfo").val() == "") {
                $.messager.alert("提示", "请输入正确信息！！", "error");
                return;
            }
            $("#operlistBox").datagrid("reload");

            var selectedRoomId = $("#filterOperRoom").combobox("getValue");
            var selectedRoomDesc = $("#filterOperRoom").combobox("getText");
            if (!selectedRoomDesc || selectedRoomDesc === splitchar.empty) {
                selectedRoomId = splitchar.empty;
            }

            var data = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: ANCLS.BLL.OperScheduleList,
                QueryName: 'FindOperScheduleList',
                Arg1: $("#filterOperDate").datebox("getValue"),
                Arg2: $("#filterOperDate").datebox("getValue"),
                Arg3: session.DeptID,
                Arg4: "",
                Arg5: "",
                Arg6: "",
                // param.Arg7 = "Application^Audit^Arrange^RoomIn^RoomOut^PACUIn^Finish^AreaOut^Stop^Accept";
                Arg7: "Arrange^RoomIn^RoomOut^PACUIn^Finish^AreaOut^Stop",
                Arg8: selectedRoomId,
                Arg9: $("#filterPatInfo").val(),
                //param.Arg9 ="";
                Arg10: "",
                Arg11: "N",
                ArgCnt: 11
            }, "json");
            var dataColumns = $("#operlistBox").datagrid("getRows");
            if (data.length < 1) {
                $.messager.alert("提示", "病人信息未能识别，请重新扫码！！", "error");
                return;
            }
            $("#operPatInfoConfig").dialog("open");;
            initoperPatInfoConfig(data[data.length-1]);
        }
    });

    $("#btnOK,#btnClose").linkbutton({
        onClick: function() {
            $("#operPatInfoConfig").dialog("close");
        }
    })
}

function initoperPatInfoConfig(dataColumn) {
    $("#RoomDesc").val(dataColumn.ArrRoomDesc);
    $("#OperSeq").val(dataColumn.OperSeq);
    $("#opLoc").val(dataColumn.PatDeptDesc);
    $("#BedNo").val(dataColumn.PatBedCode);
    $("#PatName").val(dataColumn.PatName);
    $("#PatGender").val(dataColumn.PatGender);
    $("#MedcareNo").val(dataColumn.MedcareNo);
    $("#PatAge").val(dataColumn.PatAge);
    $("#RegNo").val(dataColumn.RegNo);
    $("#AnaMethodDesc").val(dataColumn.AnaestMethod);
    $("#OperDesc").val(dataColumn.OperDesc);
    $("#BodySiteDesc").val(dataColumn.BodySiteDesc);
}

function getDefOperRoomId() {
    try {
        //var lodop=getLodop();
        var ipAddress = session.ClientIP; //lodop.GET_SYSTEM_INFO("NetworkAdapter.1.IPAddress");
        var operRoomId = dhccl.runServerMethodNormal(ANCLS.BLL.Workstation, "GetOperRoomIdByIP", ipAddress);
        return operRoomId;
    } catch (error) {

    }
    return "";
}

function initQueryForm() {
    operRooms = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindOperRoom",
        Arg1: session.DeptID == 298 ? "" : session.DeptID, //麻醉科取全部术间 YL 20200610
        Arg2: "R",
        ArgCnt: 2
    }, "json");
    $("#filterOperRoom").combobox({
        valueField: "RowId",
        textField: "Description",
        data: operRooms
    });
    var defOperRoomId = getDefOperRoomId();
    $("#filterOperRoom").combobox("setValue", defOperRoomId);
}

function initTabs() {
    // var opaId = dhccl.getQueryString("opaId");
    // addTab("手术申请记录", "CIS.AN.OperAppDetail.csp?opaId=" + opaId, false);
    var opsId = dhccl.getQueryString("opsId")
    addTab("手术概览", "CIS.AN.OperOverView.csp?opsId=" + opsId, false);
}

function selectTab(title) {
    var tabPanel = $("#tabsReg");
    if (tabPanel.tabs("exists", title)) {
        tabPanel.tabs("select", title);
    } else {
        var menuItem = $("#menuGroupReg").find('a[data-title="' + title + '"]');
        if (menuItem[0]) {
            if (!menuItem.find('span')[0]) menuItem.append('<span></span>');
            menuItem.find('span').click();
        }
    }
}

function addTab(title, href, closeable) {

    var tabPanel = $("#tabsReg"),
        canClose = true;
    if (closeable == false) {
        canClose = false;
    }
    if (tabPanel.tabs("exists", title)) {
        tabPanel.tabs("select", title);
    } else {
        var content = "未实现";
        if (href) {
            content = "<iframe scrolling='yes' frameborder='0' src='" + href + "' style='width:100%;height:100%'></iframe>";
        }
        tabPanel.tabs("add", {
            title: title,
            closable: canClose,
            content: content
                //href:content
        });
    }
}

function addTabNew(title, href, index, closeable) {
    var tabPanel = $("#tabsReg"),
        canClose = true;
    if (closeable == false) {
        canClose = false;
    }
    if (tabPanel.tabs("exists", title)) {
        tabPanel.tabs("select", title);
    } else {
        var content = "未实现";
        if (href) {
            content = "<iframe scrolling='yes' frameborder='0' src='" + href + "' style='width:100%;height:100%'></iframe>";
        }
        tabPanel.tabs("add", {
            title: title,
            closable: canClose,
            content: content,
            index: index
                //href:content
        });
    }
}

function closeCurrentTab() {
    var selectedTab = $("#tabsReg").tabs("getSelected"),
        selectedIndex = $("#tabsReg").tabs("getTabIndex", selectedTab);
    $("#tabsReg").tabs("close", selectedIndex);
}

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

    operListMenu.menu("appendItem", {
        text: "重返术中",
        name: "ReturnRoomIn",
        onclick: returnRoomIn
    });

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
}

function moveUp() {
    if (dhccl.hasRowSelected($("#operlistBox"), true)) {
        var selectedRow = $("#operlistBox").datagrid("getSelected");
        var direction = "up";
        var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ChangeOperSeq", selectedRow.RowId, direction);
        if (ret.success) {
            $("#operlistBox").datagrid("reload");
        }
    }
}

function moveDown() {
    if (dhccl.hasRowSelected($("#operlistBox"), true)) {
        var selectedRow = $("#operlistBox").datagrid("getSelected");
        var direction = "down";
        var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ChangeOperSeq", selectedRow.RowId, direction);
        if (ret.success) {
            $("#operlistBox").datagrid("reload");
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
            $("#operlistBox").datagrid("reload");
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
                    $("#operlistBox").datagrid("reload");
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
                var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "RecoverOperation", opts.rowData.RowId, session.UserID);
                if (ret.success) {
                    $("#operlistBox").datagrid("reload");
                } else {
                    $.messager.alert("提示", ret.result, "error");
                }
            }
        });
    }
}

function returnRoomIn() {
    var opts = $("#operListMenu").menu("options");
    if (opts && opts.rowData && opts.rowData.RowId) {
        $.messager.confirm("提示", "是否要将患者" + opts.rowData.PatName + "的手术返回至术中继续监护？", function(result) {
            if (result) {
                var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "ReturnRoomIn", opts.rowData.RowId);
                if (ret.success) {
                    $("#operlistBox").datagrid("reload");
                } else {
                    $.messager.alert("提示", ret.result, "error");
                }
            }
        });
    }
}

function selectPatient(patOperData) {
    if (patOperData) {
        var eprmenu = window.top.frames["eprmenu"];
        var isSet = false;
        if (eprmenu) {
            var frm = window.top.document.forms['fEPRMENU'];
            if (frm) {
                frm.PatientID.value = patOperData.PatientID;
                frm.EpisodeID.value = patOperData.EpisodeID;
                frm.mradm.value = patOperData.MRAdmID;
                if (frm.AnaesthesiaID)
                    frm.AnaesthesiaID.value = patOperData.ExtAnaestID;
                isSet = true;
            }
            if (isSet == false) {
                var frm = dhcsys_getmenuform();
                if (frm) {
                    frm.PatientID.value = patOperData.PatientID;
                    frm.EpisodeID.value = patOperData.EpisodeID;
                    frm.mradm.value = patOperData.MRAdmID;
                    if (frm.AnaesthesiaID)
                        frm.AnaesthesiaID.value = patOperData.ExtAnaestID;
                }
            }
        }
    }
}

function fullScreen() {
    var explorer = dhccl.getExplorerVersion();
    var el = document.documentElement;
    if (explorer.indexOf('IE') > -1) {
        ieFullScreen();
    } else {
        var rfs = el.requestFullScreen || el.webkitRequestFullScreen || el.mozRequestFullScreen || el.msRequestFullscreen;
        if (typeof rfs != "undefined" && rfs) {
            rfs.call(el);
        };
    }
}

function exitFullScree() {
    var explorer = dhccl.getExplorerVersion();
    if (explorer.indexOf('IE') > -1) {
        // if (document.msExitFullscreen) {
        //document.msExitFullscreen();
        //} else {
        ieFullScreen();
        //}
    } else {
        if (document.exitFullscreen) {
            document.exitFullscreen();
        } else if (document.mozCancelFullScreen) {
            document.mozCancelFullScreen();
        } else if (document.webkitCancelFullScreen) {
            document.webkitCancelFullScreen();
        } else if (document.msExitFullscreen) {
            document.msExitFullscreen();
        }
        if (typeof cfs != "undefined" && cfs) {
            cfs.call(el);
        }
    }
}

function ieFullScreen() {
    var el = document.documentElement;
    var rfs = el.msRequestFullScreen;
    //if (typeof window.ActiveXObject != "undefined") {
    //这的方法 模拟f11键，使浏览器全屏
    var wscript = new ActiveXObject("WScript.Shell");
    if (wscript != null) {
        wscript.SendKeys("{F11}");
    }
    //}
}
function initGroupSetting() {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindGroupSetting",
        Arg1: session.GroupID,
        ArgCnt: 1
    }, 'json', true, function(data) {
        if (data.length > 0 && data[0].PACUAdministrator == 'Y') {
            station.banner.showButton('btnPACUAdmission');
        }
    });
}

function initPACUAdmissionView() {
    var view = window.PACUAdmissionView.instance;
    if (!view) {
        view = window.PACUAdmissionView.init({
            searchHandler: refreshPACUAdmissionView,
            readHandler: readPACUAdmission,
            respondHandler: respondPACUAdmission,
            confirmHandler: confirmPACUAdmission
        });
    }
    refreshPACUAdmissionView({});
}

function refreshPACUAdmissionView(params) {
    dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.PACUAdmission,
        QueryName: 'FindPACUList',
        Arg1: session.UserID,
        Arg2: session.GroupID,
        Arg3: session.DeptID,
        Arg4: params.startDate || '',
        Arg5: params.endDate || '',
        Arg6: params.status || 'Unconfirmed',
        ArgCnt: 6
    }, 'json', true, function(data) {
        var view = window.PACUAdmissionView.instance;
        if (view) {
            view.loadData(data);
            if (data.length > 0) view.open();
        }
    });
}

function readPACUAdmission(params) {
    dhccl.getDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.PACUAdmission,
        MethodName: 'ReadMessage',
        Arg1: params.rowId,
        Arg2: session.UserID,
        ArgCnt: 2
    }, 'text', true, function(data) {});
}

function respondPACUAdmission(params) {
    dhccl.getDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.PACUAdmission,
        MethodName: 'Respond',
        Arg1: params.rowId,
        Arg2: session.UserID,
        ArgCnt: 2
    }, 'text', true, function(data) {});
}

function confirmPACUAdmission(params) {
    dhccl.getDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.PACUAdmission,
        MethodName: 'Confirm',
        Arg1: params.rowId,
        Arg2: session.UserID,
        ArgCnt: 2
    }, 'text', true, function(data) {});
}

$(document).ready(initPage);