/**
 * Desc:    �û�/����/��ȫ�����������ҩ���� ά��
 * Creator: Huxt 2019-09-11
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
$(function () {
    PHA.SearchBox("conAuthAlias", {
        searcher: QueryAuth,
        placeholder: "�������ƴ�����ƻس���ѯ"
    });
    PHA.SearchBox("conMenuAlias", {
        searcher: QueryMenu,
        placeholder: "�������ƴ�����ƻس���ѯ,˫����Ȩ"
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
                text: '�û�',
                id: 'U'
            },

            {
                text: '��ȫ��',
                id: 'G'
            },
            {
                text: '����',
                id: 'L',
                selected: true
            },
            {
                text: 'ҽԺ',
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
            text: 'δ��Ȩ',
            id: 'N',
            selected: true
        }, {
            text: '����Ȩ',
            id: 'Y',
            selected: true
        }]
    });
}
// ����-��Ʒģ��
function InitGridAuth() {
    var columns = [
        [{
                field: "authId",
                title: 'Ȩ��Id',
                hidden: true,
                width: 100
            },
            {
                field: "authDesc",
                title: '����',
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
                title: '�˵�Id',
                hidden: true,
                width: 100
            },
            {
                field: "menuOperate",
                title: '����',
                width: 20,
                align: "center",
                formatter: function (value, rowData, rowIndex) {
                    return '<img title="��Ȩ" onclick="AddCfgItm()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/select_grant.png" style="border:0px;cursor:pointer">'
                }
            },
            {
                field: "menuDesc",
                title: '����',
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
            // $("#gridMenu").datagrid("enableDnd");  // ���������ӵ�Ԫ��༭,�г�ͻ
        }
    };
    PHA.Grid("gridMenu", dataGridOption);
}

// ��Ȩ
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
// ȡ����Ȩ
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

//��ʼ������
function InitGridCfgItm() {
    var columns = [
        [{
                field: "cfgItmId",
                title: '�����ӱ�Id',
                hidden: true
            },{
                field: "menuId",
                title: '�˵�Id',
                hidden: true
            },
            {
                field: "menuCfgOperate",
                title: '����',
                width: 10,
                align: "center",
                formatter: function () {
                    return '<img title="ȡ����Ȩ" onclick="DelCfgItm()" src="../scripts_lib/hisui-0.1.0/dist/css/icons/cancel_select_grant.png" style="border:0px;cursor:pointer">'
                }
            }, {
                field: "menuDesc",
                title: '����',
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
            $("#gridCfgItm").datagrid("enableDnd"); // ���������ӵ�Ԫ��༭,�г�ͻ
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
            msg: "����ѡ��[����Ȩ][δ��Ȩ]������",
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
            msg: '����ѡ����Ȩ���',
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

// ǰ̨�����ع�����
function RefreshGrid() {
    $("#gridMenu").datagrid('loadData', $("#gridMenu").datagrid('getRows'));
    $("#gridCfgItm").datagrid('loadData', $("#gridCfgItm").datagrid('getRows'));
}