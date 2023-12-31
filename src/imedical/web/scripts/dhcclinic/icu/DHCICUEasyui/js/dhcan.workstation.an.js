var operListMenu,operRooms;
function initPage(){
    initMenuGroup();
    initOperList();
    initQueryForm();
    initOperationInfo();
}

/**
 * 初始化手术信息，如果未选择手术记录，那么弹出手术列表界面让用户选择
 * @author chenchangqing 20190305
 */
function initOperationInfo(){
    var opsId=dhccl.getQueryString("opsId");
    if(opsId && opsId!==""){
        initPatientBanner();
        initTabs();
    }else{
        $("#operlistDialog").dialog("open");
    }
}

function initMenuGroup(){
    var opsId=dhccl.getQueryString("opsId");
    var PatientID=dhccl.getQueryString("PatientID");
    var EpisodeID=dhccl.getQueryString("EpisodeID");
    var AnaesthesiaID=dhccl.getQueryString("AnaesthesiaID");
    $("ul.i-menugroup>li>a").each(function(index,item){
        if($(item).hasClass("open-all") || $(item).hasClass("close-all")) return;
        var moduleCode=$(item).attr("data-modulecode");
        var dataUrl=$(item).attr("data-url")+"?PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&opsId="+opsId+"&moduleCode="+moduleCode+"&AnaesthesiaID="+AnaesthesiaID+"&random="+Math.random();
        var dataTitle=$(item).attr("data-title");
        var dataExp=$(item).attr("data-exp");
        var target=$(item).attr("target");
        
        if(dataExp && dataExp!==""){
            dataUrl+=dataExp;
        }
        var menuIndex=parseInt($(item).attr("data-menuindex"));
        if(dataUrl && dataUrl!=="" && dataTitle && dataTitle!==""){
            if(target==="_blank"){
                $(item).attr("href",dataUrl);
            }else{
                $(item).attr("href","javascript:addTabNew('"+dataTitle+"','"+dataUrl+"',"+menuIndex+")");
            }
            
        }
        
    });

    $(".open-all").click(function(){
        var menuGroup=$(this).attr("data-menugroup"),
        selector="ul."+menuGroup+">li>a";
        var firstIndex=0;
        $(selector).each(function(index,item){
            if($(item).hasClass("open-all") || $(item).hasClass("close-all")) return;
            var dataUrl=$(item).attr("data-url")+"?opsId="+opsId;
            var dataTitle=$(item).attr("data-title");
            var menuIndex=parseInt($(item).attr("data-menuindex"));
            if(dataUrl && dataUrl!=="" && dataTitle && dataTitle!==""){
                if(index===0) firstIndex=index
                addTabNew(dataTitle,dataUrl,menuIndex);
            }
        });
    });

    $(".close-all").click(function(){
        var menuGroup=$(this).attr("data-menugroup"),
        selector="ul."+menuGroup+">li>a";
        $(selector).each(function(index,item){
            if($(item).hasClass("open-all") || $(item).hasClass("close-all")) return;
            var dataUrl=$(item).attr("data-url")+"?opsId="+opsId;
            var dataTitle=$(item).attr("data-title");
            var menuIndex=parseInt($(item).attr("data-menuindex"));
            if(dataUrl && dataUrl!=="" && dataTitle && dataTitle!==""){
                $("#tabsReg").tabs("close",dataTitle);
            }
        });
    });
}

function initPatientBanner(){
    var banner=operScheduleBanner.init('#patinfo_banner', {});
    
    var opsId=dhccl.getQueryString("opsId");
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

            $("#btnOperList").linkbutton({
                onClick:function(){
                    $("#operlistDialog").dialog("open");
                }
            });
        }
    });

    
}

function initOperList(){
    var today=new Date();
    var todayStr=today.format("yyyy-MM-dd");
    var defQueryDate=dhccl.getQueryString("QueryDate");
    if(defQueryDate){
        $("#filterOperDate").datebox("setValue",defQueryDate);
    }else{
        $("#filterOperDate").datebox("setValue",todayStr);
    }
    $("#operlistBox").datagrid({
        fit:true,
        toolbar:"#operlistTools",
        columns:[[
            {field:"RoomDesc",title:"术间",width:80},
            {field:"OperSeq",title:"台次",width:60},
            {field:"PatName",title:"患者姓名",width:100},
            {field:"PatGender",title:"性别",width:60},
            {field:"PatAge",title:"年龄",width:80},
            {field:"OperDesc",title:"手术名称",width:300},
            {field:"SurgeonDesc",title:"手术医生",width:80}
        ]],
        rowStyler: function(index, row) {
            return "background-color:" + row.StatusColor + ";";
        },
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
            param.Arg7 = "Application^Arrange^RoomIn^RoomOut^PACUIn^PACUOut^AreaOut^Stop^Cancel";
            param.Arg8 = selectedRoomId;
            param.Arg9 = "";
            param.Arg10 = "";
            param.Arg11 = "N";
        },
        onSelect:function(rowIndex,rowData){
            selectPatient(rowData);
        },
        onDblClickRow:function(rowIndex,rowData){
            var queryDate=$("#filterOperDate").datebox("getValue");
            window.location="dhcan.workstation.an.csp?opsId="+rowData.RowId+"&PatientID="+rowData.PatientID+"&EpisodeID="+rowData.EpisodeID+"&EpisodeLocID="+rowData.PatDeptID+"&AnaesthesiaID="+rowData.ExtAnaestID+"&QueryDate="+queryDate;
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
        onClick:function(){
            $("#operlistBox").datagrid("reload");
        }
    })
}

function initQueryForm(){
    operRooms = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ConfigQueries,
        QueryName: "FindOperRoom",
        Arg1: "",
        Arg2: "R",
        ArgCnt: 2
    }, "json");
    $("#filterOperRoom").combobox({
        valueField: "RowId",
        textField: "Description",
        data: operRooms
    });
}

function initTabs(){
    // var opsId=dhccl.getQueryString("opsId");
    // addTab("信息总览","dhcan.totalview.csp?opsId="+opsId,false);
    // $("#tabsReg").tabs("options").onSelect=function(title,index){
    //         var tab=$(this).tabs("getTab",index);
    //         var opts=tab.panel("options");
    //         if(opts.refresh==="Y"){
    //             tab.panel("refresh");
    //         }
    //     }
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

function addTabNew(title, href, index,closeable,refresh) {
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
            index:index,
            refresh:refresh || ''
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
                var ret = dhccl.runServerMethod(ANCLS.BLL.OperArrange, "RecoverOperation", opts.rowData.RowId);
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
        //var eprmenu = window.parent.top.frames["eprmenu"];
        var isSet = false;
        // if (eprmenu) {
        var frm = window.parent.parent.document.forms['fEPRMENU'];
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
        //}
    }
}


$(document).ready(initPage);