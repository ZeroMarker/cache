var PRA_SELREASON_RET="";	// 返回值
$(function () {
    InitReasonTreeGrid();
    InitGridLinkOrd();
    InitGridQuestion();
    $("#btnCancel").on("click", function () {
        SelReasonClose("cancel");
    });
    $("#btnSure").on("click", function () {
        SelReasonClose("sure");
    });
    ReLoadPRASelReason();
});

function ReLoadPRASelReason(){
	SELREASONRET="";
	$("#phNotes").val("");
	$('#gridQuestion').datagrid('loadData', {rows:[],total:0});
	$('#gridLinkOrder').datagrid('loadData', {rows:[],total:0});
    $.cm({
        ClassName: 'PHA.PRC.Com.Store',
        MethodName: 'GetPRCReasonTree',
        wayId: PRA_WAYID,
        ParentId: ''
    }, function (data) {
        $('#gridReason').tree({
            data: data
        });
    });
    $.cm({
        ClassName: 'PHA.PRA.Com.Query',
        QueryName: 'SelOrdArcimData',
        Oeori: PRA_OEORI,
        PrescNo: PRA_PRESCNO, 
        SelType: PRA_SELTYPE 
	},function(data){
		$('#gridLinkOrder').datagrid('loadData', data);
	})
    
}
function InitReasonTreeGrid() {
    PHA.Tree("gridReason", {
        onDblClick: function (node) {
            treeClickEvent(node);
        }
    })
}

function InitGridLinkOrd() {
    var columns = [
        [{
                field: "arcimDesc",
                title: '医嘱名称',
                width: 220,
            },
            {
                field: "oeori",
                title: 'oeori',
                width: 80,
                hidden: true
            },
        ]
    ];
    var dataGridOption = {
        url: "",
        columns: columns,
        fitColumns: true,
        pagination: false,
        onDblClickRow: function (rowIndex, rowData) {
            OrderClickEvent(rowData.oeori, rowData.arcimDesc);
        }
    };
    PHA.Grid("gridLinkOrder", dataGridOption);
}

//初始化表格-问题列表
function InitGridQuestion() {
    var columns = [
        [{
                field: "desc",
                title: '描述',
                width: 200
            },
            {
                field: "level",
                title: '分级',
                width: 80,
                hidden: true
            },
            {
                field: "rowid",
                title: 'rowid',
                width: 40,
                hidden: true
            }
        ]
    ];
    var dataGridOption = {
        columns: columns,
        pagination: false,
        fitColumns: true,
        toolbar: [],
        onDblClickRow: function (rowIndex, rowData) {
	        var reasonlevel=rowData.level;
	        var rows =$("#gridQuestion").datagrid("getRows")
	        var totalnum=rows.length;
	        if (reasonlevel==""){
				for(var i=(rowIndex+1);i<totalnum;i++){
	                var reasonlevel=rows[rowIndex+1].level ;
					if (reasonlevel=="")
					{
						break;  
					}

					$('#gridQuestion').datagrid('deleteRow', rowIndex+1);
				}
			}
            $('#gridQuestion').datagrid('deleteRow', rowIndex);
        }
    };
    PHA.Grid("gridQuestion", dataGridOption);
}

function treeClickEvent(node) {
    if (node.isLeaf == "N") {
        var reasonId = node.id;
        var reasonDesc = node.text;
        if (reasonId == "") {
            return;
        }

        var gridChanges = $('#gridQuestion').datagrid('getChanges');
        var gridChangeLen = gridChanges.length;
        for (var counter = gridChangeLen-1; counter >=0; counter--) {
            var quesData = gridChanges[counter];
            var selReasonId = quesData.rowid || "";
            var level = quesData.level || "";
			if(level!="")break;
            if (selReasonId == reasonId) {
                PHA.Popover({
                    msg: '该原因已存在,不能重复添加',
                    type: 'alert'
                });
                return;
            }

        }
        $("#gridQuestion").datagrid('appendRow', {
            desc: reasonDesc,
            level: '',
            rowid: reasonId
        });

    }

}

function OrderClickEvent(selOrdItm, selOrdDesc) {
    if (selOrdItm == "") {
        return;
    }
    var gridChanges = $('#gridQuestion').datagrid('getChanges');
    var gridChangeLen = gridChanges.length;
    if (gridChangeLen == "0") {
        PHA.Popover({
            msg: '请先双击选择拒绝原因,然后再重试',
            type: 'alert'
        });
        return;
    }
    var reasonRowId = "" // 原因Id
    for (var counter = gridChangeLen-1; counter>=0; counter--) {
        var quesData = gridChanges[counter];
        var selRowid = quesData.rowid || "";
        var level = quesData.level || "";
        if(level=="")break;
        if (selOrdItm == selRowid) {
            PHA.Popover({
                msg: '该医嘱已存在,不能重复添加',
                type: 'alert'
            });
            return;
        }
    }
    lastData = gridChanges[(gridChangeLen - 1)]
    var lastRowId = lastData.rowid || "";
    var selOrdDesc = "└──" + selOrdDesc
    $("#gridQuestion").datagrid('appendRow', {
        desc: selOrdDesc,
        level: selOrdItm, 
        rowid: selOrdItm
    });
}

function SelReasonClose(type) {
	if (type=="sure"){
		PRA_SELREASON_RET=GetSelReason();
		if (PRA_SELREASON_RET==""){
			return;
		}
	}else{
		PRA_SELREASON_RET="";
	}
	top.$("#PHA_PRA_V1_SELREASON").window("close"); 
	/* 调用了此js,必然有此window,用不上如下判断
    var reasonFrm;
    var frms = top.frames
    for (var i = (frms.length - 1); i >= 0; i--) {
        if (frms[i].TRELOADPAGE == "pha.pra.v1.selreason.csp") {
            reasonFrm = frms[i];
            break;
        }
    }
    if (reasonFrm != "") {
	    top.$("#PHA_PRA_V1_SELREASON").window("close"); // 固定值
    }
    */
}

/**
 * 获取界面值
 */
function GetSelReason() {
    var gridRows = $('#gridQuestion').datagrid('getRows');
    if (gridRows==""){
        PHA.Popover({
            msg: '请先选择拒绝原因与医嘱',
            type: 'alert'
        });
        return ""; 
    }
    var rowsLen = gridRows.length;
    if (rowsLen == 0) {
        PHA.Popover({
            msg: '请先选择拒绝原因与医嘱',
            type: 'alert'
        });
        return "";
    }
    var reasonIdStr = ""
    var levelFlag = 0;
    var chkExistFlag = 0;
    var lastLevel = gridRows[rowsLen-1].level || "";
    if (lastLevel != ""){
		chkExistFlag=1
	}
	if (chkExistFlag == 0) {
        PHA.Popover({
            msg: '请原因后选择医嘱',
            type: 'alert'
        });
        return "";
    }
    for (var counter = 0; counter < rowsLen; counter++) {
        var quesData = gridRows[counter];
        var selReasonId = quesData.rowid || "";
        var selLevel = quesData.level || "";
        if (selLevel != "") {
            reasonIdStr = reasonIdStr + "$$$" + selReasonId;
            levelFlag = 1;
           
        } else {
            if (reasonIdStr == "") {
                reasonIdStr = selReasonId;
            } else {
                if (levelFlag == 1) {
                    reasonIdStr = reasonIdStr + "!" + selReasonId;
                    levelFlag = 0;
                } else {
                    reasonIdStr = reasonIdStr + "^" + selReasonId;
                }
            }

        }
        
    }
    var ret= tkMakeServerCall("web.DHCSTCNTSOUTMONITOR", "CheckRefReasonAndOrd", reasonIdStr)
	if(ret!==""){
		PHA.Popover({
            msg: ret,
            type: 'alert'
        });
        return "";
	}
    
    var phNotes = $.trim($("#phNotes").val());
    phNotes=phNotes.replace(/[*&^%$@!#]/g, "")
    return reasonIdStr + "@@@" + phNotes;
}