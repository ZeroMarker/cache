/**
 * Desc:    用户/科室/安全组关联处方配药类型 维护
 * Creator: Huxt 2019-09-11
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
    PHA.SearchBox("conAuthAlias", {
        searcher: QueryAuth,
        placeholder: "请输入简拼或名称回车查询"
    });
    PHA.SearchBox("conMenuAlias", {
        searcher: QueryMenu,
        placeholder: "请输入简拼或名称回车查询,双击授权"
    });
    InitKeyWords();
    InitGridAuth();
    InitGridMenu();
    InitGridCfgItm();
});

function InitKeyWords() {
    $("#kwAuthType").keywords({
        singleSelect: true,
        labelCls: 'blue',
        items: [{
                text: '用户',
                id: 'U'
            },

            {
                text: '安全组',
                id: 'G'
            },
            {
                text: '科室',
                id: 'L',
                selected: true
            },
            {
                text: '医院',
                id: 'H'
            }
        ],
        onClick: function (v) {
            QueryAuth();
        }
    });
    $("#kwAuthStat").keywords({
        singleSelect: false,
        labelCls: 'red',
        items: [{
            text: '未授权',
            id: 'N',
            selected: true
        }, {
            text: '已授权',
            id: 'Y',
            selected: true
        }]
    });
}
// 表格-产品模块
function InitGridAuth() {
    var columns = [
        [{
                field: "authId",
                title: '权限Id',
                hidden: true,
                width: 100
            },
            {
                field: "authDesc",
                title: '名称',
                width: 150
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.MOB.MenuCfg.Query',
            QueryName: 'AuthType',
            Type: "L",
            InputStr: "^A"
        },
        displayMsg: "",
        pagination: true,
        columns: columns,
        fitColumns: true,
        toolbar: "#gridAuthBar",
        onSelect: function (rowIndex, rowData) {
            QueryMenu();
            QueryCfgItm();
        },
        onLoadSuccess: function () {
            $("#gridMenu").datagrid("clear");
            $("#gridCfgItm").datagrid("clear");
        }
    };
    PHA.Grid("gridAuth", dataGridOption);

}

function InitGridMenu() {
    var columns = [
        [{
                field: "menuId",
                title: '菜单Id',
                hidden: true,
                width: 100
            },
            {
                field: "menuOperate",
                title: '操作',
                width: 20,
                align: "center",
                formatter: function (value, rowData, rowIndex) {
                    return '<img title="授权" onclick="AddCfgItm()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/select_grant.png" style="border:0px;cursor:pointer">'
                }
            },
            {
                field: "menuDesc",
                title: '名称',
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.MOB.MenuCfg.Query',
            QueryName: 'PHAINMobMenu'
        },
        fitColumns: true,
        singleSelect: true,
        toolbar: "#gridMenuBar",
        pagination: false,
        columns: columns,
        onSelect: function (rowIndex, rowData) {
            // alert(rowIndex)
        },
        onLoadSuccess: function () {
            // $("#gridMenu").datagrid("enableDnd");  // 不能再添加单元格编辑,有冲突
        }
    };
    PHA.Grid("gridMenu", dataGridOption);
}

// 授权
function AddCfgItm() {
    var $target = $(event.target);
    var menuRowIndex = $target.closest("tr[datagrid-row-index]").attr("datagrid-row-index");
    var menuRowData = $("#gridMenu").datagrid("getRows")[menuRowIndex];
    var authType = $("#kwAuthType").keywords("getSelected")[0].id;
    var authId = $("#gridAuth").datagrid("getSelected").authId;
    var menuId=menuRowData.menuId;
    var saveRet = $.cm({
		ClassName: 'PHA.MOB.MenuCfg.Save',
		MethodName: 'Save',
		DataStr:authType+"^"+ authId+"^"+menuId,
		dataType: 'text',
	}, false);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Popover({
            msg: saveInfo,
            type: 'alert'
        });
        return;
    }
    var newCfgItmRow={
        cfgItmId:saveVal,
        menuId:menuRowData.menuId,
        menuDesc:menuRowData.menuDesc
    }
    $("#gridMenu").datagrid("deleteRow", menuRowIndex);
    $("#gridCfgItm").datagrid("appendRow", newCfgItmRow);
    RefreshGrid();
}
// 取消授权
function DelCfgItm() {
    var $target = $(event.target);
    var cfgItmRowIndex = $target.closest("tr[datagrid-row-index]").attr("datagrid-row-index");
    var cfgItmRowData = $("#gridCfgItm").datagrid("getRows")[cfgItmRowIndex];
    var saveRet = $.cm({
		ClassName: 'PHA.MOB.MenuCfg.Save',
		MethodName: 'Delete',
		RowId:cfgItmRowData.cfgItmId,
		dataType: 'text',
	}, false);
    var saveArr = saveRet.split('^');
    var saveVal = saveArr[0];
    var saveInfo = saveArr[1];
    if (saveVal < 0) {
        PHA.Popover({
            msg: saveInfo,
            type: 'alert'
        });
        return;
    }
    var newMenuRow={
        menuId:cfgItmRowData.menuId,
        menuDesc:cfgItmRowData.menuDesc
    }
    $("#gridCfgItm").datagrid("deleteRow", cfgItmRowIndex);
    $("#gridMenu").datagrid("appendRow", newMenuRow);
    RefreshGrid();
}

//初始化表格
function InitGridCfgItm() {
    var columns = [
        [{
                field: "cfgItmId",
                title: '配置子表Id',
                hidden: true
            },{
                field: "menuId",
                title: '菜单Id',
                hidden: true
            },
            {
                field: "menuCfgOperate",
                title: '操作',
                width: 10,
                align: "center",
                formatter: function () {
                    return '<img title="取消授权" onclick="DelCfgItm()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel_select_grant.png" style="border:0px;cursor:pointer">'
                }
            }, {
                field: "menuDesc",
                title: '名称',
                width: 100
            }
        ]
    ];
    var dataGridOption = {
        url: $URL,
        queryParams: {
            ClassName: 'PHA.MOB.MenuCfg.Query',
            QueryName: 'PHAINMenuCfgItm'
        },
        fitColumns: true,
        pagination: false,
        columns: columns,
        toolbar: [],
        onDrop:function(){
            var cfgItmIdStr="";
            var rows=$("#gridCfgItm").datagrid("getRows");
            var rowsLen=rows.length;
            for (var i=0;i<rowsLen;i++){
                var cfgItmId=rows[i].cfgItmId;
                cfgItmIdStr=(cfgItmIdStr=="")?cfgItmId:cfgItmIdStr+"^"+cfgItmId;
            }
            var saveRet = $.cm({
                ClassName: 'PHA.MOB.MenuCfg.Save',
                MethodName: 'ReBuildSortCode',
                DataStr:cfgItmIdStr,
                dataType: 'text',
            }, false);
            var saveArr = saveRet.split('^');
            var saveVal = saveArr[0];
            var saveInfo = saveArr[1];
            if (saveVal < 0) {
                PHA.Popover({
                    msg: saveInfo,
                    type: 'alert'
                });
            }
        },
        onLoadSuccess: function () {
            $("#gridCfgItm").datagrid("enableDnd"); // 不能再添加单元格编辑,有冲突
        }
    };
    PHA.Grid("gridCfgItm", dataGridOption);

}

function QueryAuth() {
    var conAuthAlias = $("#conAuthAlias").searchbox("getValue") || "";
    var authType = $("#kwAuthType").keywords("getSelected")[0].id;
    var authStatSel = $("#kwAuthStat").keywords("getSelected");
    var authStat = "";
    if (authStatSel.length == 2) {
        authStat = "A";
    } else if (authStatSel.length == 1) {
        authStat = $("#kwAuthStat").keywords("getSelected")[0].id;
    }
    if (authStat == "") {
        PHA.Popover({
            msg: "请先选择[已授权][未授权]的条件",
            type: 'alert'
        });
        return;
    }
    $("#gridAuth").datagrid("query", {
        InputStr: conAuthAlias + "^" + authStat,
        Type: authType
    })
}

function QueryMenu(){
    var gridSelect=$('#gridAuth').datagrid('getSelected');
    if (gridSelect==null){
        PHA.Popover({
            msg: '请先选择授权类别',
            type: 'alert'
        });
        return;
    }
    var inputArr = [];
    inputArr.push($("#kwAuthType").keywords("getSelected")[0].id);
    inputArr.push(gridSelect.authId);
    inputArr.push($("#conMenuAlias").searchbox("getValue") || "");
    $("#gridMenu").datagrid("query", {
        InputStr: inputArr.join("^")
    });
}

function QueryCfgItm(){
    var gridSelect=$('#gridAuth').datagrid('getSelected');
    if (gridSelect==null){
        return;
    }
    var inputArr = [];
    inputArr.push($("#kwAuthType").keywords("getSelected")[0].id);
    inputArr.push(gridSelect.authId);
    $("#gridCfgItm").datagrid("query", {
        InputStr: inputArr.join("^")
    });
}

// 前台数据重构表格
function RefreshGrid() {
    $("#gridMenu").datagrid('loadData', $("#gridMenu").datagrid('getRows'));
    $("#gridCfgItm").datagrid('loadData', $("#gridCfgItm").datagrid('getRows'));
}