function initPage() {
    resizeRegion();
    initInstrumentsBox();
    initDressingsBox();
    initSurgicalKitOptions();
    initOperActions();
    //SignTool.loadSignature();
	
	SignTool.initSignatureBox(getToSignData);
    operDataManager.reloadPatInfo(loadApplicationData);
	setSubmitState();
}

var operCount = {
    schedule: null,
    contextMenu: null,
    contextMenuD: null,
    clickColumn: null
};

function msg(value, name) {
    var signCode = $(this).attr("id");
    var originalData = JSON.stringify(operDataManager.getOperDatas());
    var signView = new SignView({
        container: "#signContainer",
        originalData: originalData,
        signCode: signCode
    });
    signView.initView();
    signView.open();
    signCommon.loadSignatureCommon();
}
/**
 * 根据手术申请数据，设置病人信息表单元素的值。
 * @param {object} operApplication 手术申请数据对象
 */
function loadApplicationData(operApplication) {
    operCount.schedule = operApplication;
}

function resizeRegion() {
    console.log(window.innerWidth);
    var eastPanel = $("body").layout("panel", "east");
    var marginWidth = 30;
    var panelWidth = (window.innerWidth - marginWidth) / 2;
    $(eastPanel).panel("resize", {
        width: panelWidth
    });
    $("body").layout("resize");
}

function initInstrumentsBox() {
    $("body").resize(function() {
        resizeRegion();
    });
    var columns = [
        [
            { field: "CheckStatus", title: "选择", checkbox: true },
            { field: "SurgicalMaterial", title: "手术物品ID", hidden: true },
            { field: "MaterialNote", title: "手术物品", width: 100 },
            { field: "PreopCount", title: "术前清点", width: 76, editor: { type: "numberbox" } },
            { field: "OperAddCount", title: "术中加数(数值)", hidden: true },
            { field: "AddCountDesc", title: "术中加数", width: 120, editor: { type: "validatebox" } },
            {
                field: "PreCloseCount",
                title: "关前清点",
                width: 76,
                editor: { type: "numberbox" },
                styler: function(value, row, index) {
                    if (!operCountBalance(row, "PreCloseCount")) {
                        return "background-color:yellow;";
                    }
                }
            },
            {
                field: "PostCloseCount",
                title: "关后清点",
                width: 76,
                editor: { type: "numberbox" },
                styler: function(value, row, index) {
                    if (!operCountBalance(row, "PostCloseCount")) {
                        return "background-color:yellow;";
                    }
                }
            },
            {
                field: "PostSewCount",
                title: "缝皮后清点",
                width: 80,
                editor: { type: "numberbox" },
                styler: function(value, row, index) {
                    if (!operCountBalance(row, "PostSewCount")) {
                        return "background-color:yellow;";
                    }
                }
            },
			{ field: "SterilityPack", title: "消毒包ID", hidden: true },
        ]
    ];

    $("#instrumentsBox").datagrid({
        fit: true,
        title: "手术器械清点记录",
        headerCls: "panel-header-gray",
        checkOnSelect: false,
        selectOnCheck: false,
        singleSelect: false,
        pagination: false,
        iconCls: "icon-paper",
        url: ANCSP.DataQuery,
        toolbar: "#instrumentsTool",
        columns: columns,
        // rowStyler: function(index, row) {
        //     if(!operCountBalance(row)){
        //         return "background-color:yellow;";
        //     }
        // },
        queryParams: {
            ClassName: ANCLS.BLL.DataQueries,
            QueryName: "FindSurInventory",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        },
        onClickCell: function(index, field, value) {
            var countDatas = $(this).datagrid("getRows");
            if (countDatas && countDatas.length > 0) {
                var id = $(this).attr("id");
                genCountData(id, field, countDatas);
            }
        },
        onBeginEdit: function(rowIndex, rowData) {
            var editor = $(this).datagrid("getEditor", {
                index: rowIndex,
                field: "AddCountDesc"
            });
            calcAddCount(editor, rowData);
        },
        onLoadSuccess: function(data) {
            $(this).datagrid("clearChecked");
            $("#instrumentsBox").datagrid("reloadFooter", [{
                MaterialNote: "清点者1",
                InventoryType: "ZYS"
            }, {
                MaterialNote: "清点者2",
                InventoryType: "ZYS"
            }])
        }
    });

    $("#instrumentsBox").datagrid("enableCellEditing");


    $("#ISterilityPackBarCode,#DSterilityPackBarCode").keypress(function(e) {
        if (e.keyCode == 13) {
            var ISterilityPackBarCode = $("#ISterilityPackBarCode").val();
            var DSterilityPackBarCode = $("#DSterilityPackBarCode").val();
            var countBoxId = (ISterilityPackBarCode == "") ? "dressingsBox" : "instrumentsBox";
            var ivType = "I";
            if (countBoxId === "dressingsBox") {
                ivType = "D";
            }
            var packNo = (ISterilityPackBarCode == "") ? DSterilityPackBarCode : ISterilityPackBarCode;
            var ifValid = dhccl.runServerMethodNormal(ANCLS.BLL.SterilityPack, "JudgeCSSDValid", packNo, ivType);
            if (ifValid == 0) {
                $("#CSSPackDialog").dialog("open");
                $("#CSSPackBox").datagrid("reload");
                var opts = $("#CSSPackDialog").dialog("options");
                opts.countBoxId = (ISterilityPackBarCode == "") ? "dressingsBox" : "instrumentsBox";
                opts.comboBoxId = this.id;
            } else {
                $.messager.alert("提示", "扫码失败，原因：" + ifValid, "warning");
            }
        }
    });
}

function initDressingsBox() {
    var columns = [
        [
            { field: "CheckStatus", title: "选择", checkbox: true },
            { field: "SurgicalMaterial", title: "手术物品ID", hidden: true },
            { field: "MaterialNote", title: "手术物品", width: 100 },
            { field: "PreopCount", title: "术前清点", width: 76, editor: { type: "numberbox" } },
            { field: "OperAddCount", title: "术中加数(数值)", hidden: true },
            { field: "AddCountDesc", title: "术中加数", width: 120, editor: { type: "validatebox" } },
            {
                field: "PreCloseCount",
                title: "关前清点",
                width: 76,
                editor: { type: "numberbox" },
                styler: function(value, row, index) {
                    if (!operCountBalance(row, "PreCloseCount")) {
                        return "background-color:yellow;";
                    }
                }
            },
            {
                field: "PostCloseCount",
                title: "关后清点",
                width: 76,
                editor: { type: "numberbox" },
                styler: function(value, row, index) {
                    if (!operCountBalance(row, "PostCloseCount")) {
                        return "background-color:yellow;";
                    }
                }
            },
            {
                field: "PostSewCount",
                title: "缝皮后清点",
                width: 80,
                editor: { type: "numberbox" },
                styler: function(value, row, index) {
                    if (!operCountBalance(row, "PostSewCount")) {
                        return "background-color:yellow;";
                    }
                }
            }
        ]
    ];

    $("#dressingsBox").datagrid({
        fit: true,
        title: "手术敷料清点记录",
        headerCls: "panel-header-gray",
        checkOnSelect: false,
        selectOnCheck: false,
        singleSelect: false,
        pagination: false,
        iconCls: "icon-paper",
        url: ANCSP.DataQuery,
        toolbar: "#dressingsTool",
        columns: columns,
        // rowStyler: function(index, row) {
        //     if(!operCountBalance(row)){
        //         return "background-color:yellow;";
        //     }
        // },
        queryParams: {
            ClassName: ANCLS.BLL.DataQueries,
            QueryName: "FindDressingInventory",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        },
        onClickCell: function(index, field, value) {
            var countDatas = $(this).datagrid("getRows");
            if (countDatas && countDatas.length > 0) {
                var id = $(this).attr("id");
                genCountData(id, field, countDatas);
            }
        },
        onBeginEdit: function(rowIndex, rowData) {
            var editor = $(this).datagrid("getEditor", {
                index: rowIndex,
                field: "AddCountDesc"
            });
            calcAddCount(editor, rowData);
        },
        onLoadSuccess: function(data) {
            $(this).datagrid("clearChecked");
        }
    });

    $("#dressingsBox").datagrid("enableCellEditing");
}

/**
 * 初始化手术包和手术物品可选项。
 */
function initSurgicalKitOptions() {
    $("#ISurgicalKit,#DSurgicalKit").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurgicalKits";
            param.Arg1 = "N";
            param.Arg2 = "Y";
            param.Arg3 = param.q ? param.q : "";
            param.Arg4 = "";
            param.Arg5 = session.HospID;
            param.ArgCnt = 5;
        },
        mode: "remote",
        onSelect: function(record) {
            var id = $(this).attr("id");
            if (id === "ISurgicalKit") {
                selectedSurgicalKit(id, "手术包", record, "instrumentsBox");
            } else {
                selectedSurgicalKit(id, "手术包", record, "dressingsBox");
            }

        }
    });

    $("#SurgicalKitBox").datagrid({
        fit: true,
        singleSelect: false,
        checkOnSelect: false,
        selectOnCheck: false,
        rownumbers: true,
        headerCls: "panel-header-gray",
        bodyCls: "panel-header-gray",
        // style:{"border-color":"#333"},
        url: ANCSP.DataQuery,
        toolbar: "",
        columns: [
            [{
                field: "CheckStatus",
                title: "选择",
                width: 60,
                checkbox: true
            }, {
                field: "SurgicalMaterial",
                title: "SurgicalMaterial",
                width: 100,
                hidden: true
            }, {
                field: "SurgicalMaterialDesc",
                title: "项目名称",
                width: 120
            }, {
                field: "DefaultQty",
                title: "数量",
                width: 80
            }]
        ],
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurKitMaterial";
            var surKitId = $("#ISurgicalKit").combobox("getValue");
            var dsurKitId = $("#DSurgicalKit").combobox("getValue");
            param.Arg1 = (surKitId == "") ? dsurKitId : surKitId;
            param.ArgCnt = 1;
        },
        onLoadSuccess: function(data) {
            $(this).datagrid("checkAll");
        }
    });

    $("#CSSPackBox").datagrid({
        fit: true,
        singleSelect: false,
        checkOnSelect: false,
        selectOnCheck: false,
        rownumbers: true,
        headerCls: "panel-header-gray",
        bodyCls: "panel-header-gray",
        // style:{"border-color":"#333"},
        url: ANCSP.DataQuery,
        toolbar: "",
        columns: [
            [{
                field: "CheckStatus",
                title: "选择",
                width: 60,
                checkbox: true
            }, {
                field: "SurgicalMaterial",
                title: "SurgicalMaterial",
                width: 100,
                hidden: true
            }, {
                field: "SurgicalMaterialDesc",
                title: "项目名称",
                width: 120
            }, {
                field: "DefaultQty",
                title: "数量",
                width: 80
            }, {
                field: "packNo",
                title: "包号",
                width: 80,
                hidden: true
            }, {
                field: "packName",
                title: "包名",
                width: 200
            }, {
                field: "ItemId",
                title: "项目Id",
                width: 200,
                hidden: true
            }]
        ],
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.SterilityPack;
            param.QueryName = "FindCSSDItemByPackNo";
            var ISterilityPackBarCode = $("#ISterilityPackBarCode").val();
            var DSterilityPackBarCode = $("#DSterilityPackBarCode").val();
            param.Arg1 = (ISterilityPackBarCode == "") ? DSterilityPackBarCode : ISterilityPackBarCode;
            param.ArgCnt = 1;
        },
        onLoadSuccess: function(data) {
            $(this).datagrid("checkAll");
        }
    });

    $("#ISurgicalItem,#DSurgicalItem").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindSurgicalMaterials";
            param.Arg1 = param.q ? param.q : "";
            param.Arg2 = session.HospID;
            param.ArgCnt = 2;
        },
        mode: "remote",
        onSelect: function(record) {
            var id = $(this).attr("id");
            if (id === "ISurgicalItem") {
                addSurgicalItem("instrumentsBox", id, record, "I");
            } else {
                addSurgicalItem("dressingsBox", id, record, "D");
            }
        }
    });

    $("#btnAddISurgicalItem,#btnAddDSurgicalItem").linkbutton({
        onClick: function() {
            var id = $(this).attr("id");
            if (id === "btnAddISurgicalItem") {
                addSurgicalItem("instrumentsBox", "ISurgicalItem", record, "I");
            } else {
                addSurgicalItem("dressingsBox", "DSurgicalItem", record, "D");
            }
        }
    });

    $("#btnDelISurgicalItem,#btnDelDSurgicalItem").linkbutton({
        onClick: function() {
            var buttonId = $(this).attr("id");
            var boxId = "instrumentsBox";
            if (buttonId === "btnDelDSurgicalItem") {
                boxId = "dressingsBox";
            }
            var boxSelector = "#" + boxId;
            var checkedRows = $(boxSelector).datagrid("getChecked");
            if (checkedRows && checkedRows.length > 0) {
                $.messager.confirm("确认", "是否删除勾选清点记录？", function(result) {
                    if (result) {
                        delCountRecord(boxId, checkedRows);
                    }
                });
            } else {
                $.messager.alert("提示", "请先勾选需要删除的清点记录，再进行操作。", "warning");
            }
        }
    });

    $("#btnConfirmKit").linkbutton({
        onClick: function() {
            var opts = $("#surKitDialog").dialog("options");
            var countBoxId = opts.countBoxId;
            var comboBoxId = opts.comboBoxId;
            var kitItems = $("#SurgicalKitBox").datagrid("getChecked");
            if (kitItems && kitItems.length > 0 && countBoxId) {
                for (var i = 0; i < kitItems.length; i++) {
                    const kitItem = kitItems[i];
                    var countItem = existsSurgicalItem(countBoxId, kitItem.SurgicalMaterial, kitItem.SurgicalMaterialDesc);
                    if (countItem.exists) {
                        var addCountDesc = countItem.rowData.AddCountDesc ? countItem.rowData.AddCountDesc : "";
                        countItem.rowData.AddCountDesc = addCountDesc + (addCountDesc ? "+" : "") + kitItem.DefaultQty;
                        countItem.rowData.OperAddCount = calExp(countItem.rowData.AddCountDesc);
                        $("#" + countBoxId).datagrid("refreshRow", countItem.rowIndex);
                    } else {
                        var ivType = "I";
                        if (countBoxId === "dressingsBox") {
                            ivType = "D";
                        }
                        $("#" + countBoxId).datagrid("appendRow", {
                            SurgicalMaterial: kitItem.SurgicalMaterial,
                            SurgicalMaterialDesc: kitItem.SurgicalMaterialDesc,
                            MaterialNote: kitItem.SurgicalMaterialDesc,
                            PreopCount: (kitItem.DefaultQty) ? kitItem.DefaultQty : 1,
                            AddCountDesc: "",
                            PreCloseCount: "",
                            PostCloseCount: "",
                            PostSewCount: "",
                            InventoryType: ivType
                        });
                    }

                }
                $("#surKitDialog").dialog("close");
                $("#" + comboBoxId).combobox("clear");
            }
        }
    });

    $("#btnConfirmCSSPack").linkbutton({
        onClick: function() {
            var opts = $("#CSSPackDialog").dialog("options");
            var countBoxId = opts.countBoxId;
            var comboBoxId = opts.comboBoxId;
            var savePackNo = [];
            var saveSterilityPack = [];
			var packNo = "";
            var kitItems = $("#CSSPackBox").datagrid("getChecked");
            if (kitItems && kitItems.length > 0 && countBoxId) {
                for (var i = 0; i < kitItems.length; i++) {
                    const kitItem = kitItems[i];
					packNo = kitItem.packNo;
                    var countItem = existsSurgicalItem(countBoxId, kitItem.SurgicalMaterial, kitItem.SurgicalMaterialDesc);

                    if (i == 0) {
                        var packInfo = {
                            RecordSheet: session.RecordSheetID,
                            Description: kitItem.packName,
                            BarCode: kitItem.packNo,
                            ClassName: ANCLS.Model.SterilityPack
                        }
                        savePackNo.push(packInfo);
                    }

                    var SterilityPackInfo = {
                        ItemCode: kitItem.ItemId,
                        ItemDesc: kitItem.SurgicalMaterialDesc,
                        Qty: kitItem.DefaultQty,
                        ClassName: ANCLS.Model.SterilityItem
                    }
                    saveSterilityPack.push(SterilityPackInfo);
                }
                $("#CSSPackDialog").dialog("close");
                $("#" + comboBoxId).val("");

            }
            var saveCSSDRet = saveCSSDPackDatas(savePackNo, saveSterilityPack);
            if (saveCSSDRet.success) {
				var SterilityPackId = dhccl.runServerMethod(ANCLS.BLL.SterilityPack, "GetPackIdByBarCode", packNo);
                if (kitItems && kitItems.length > 0 && countBoxId) {
                    for (var i = 0; i < kitItems.length; i++) {
                        const kitItem = kitItems[i];
                        var countItem = existsSurgicalItem(countBoxId, kitItem.SurgicalMaterial, kitItem.SurgicalMaterialDesc);
                        if (countItem.exists) {
                            var addCountDesc = countItem.rowData.AddCountDesc ? countItem.rowData.AddCountDesc : "";
                            countItem.rowData.AddCountDesc = addCountDesc + (addCountDesc ? "+" : "") + kitItem.DefaultQty;
                            countItem.rowData.OperAddCount = calExp(countItem.rowData.AddCountDesc);
                            $("#" + countBoxId).datagrid("refreshRow", countItem.rowIndex);
                        } else {
                            var ivType = "I";
                            if (countBoxId === "dressingsBox") {
                                ivType = "D";
                            }
                            $("#" + countBoxId).datagrid("appendRow", {
                                SurgicalMaterial: kitItem.SurgicalMaterial,
                                SurgicalMaterialDesc: kitItem.SurgicalMaterialDesc,
                                MaterialNote: kitItem.SurgicalMaterialDesc,
                                PreopCount: (kitItem.DefaultQty) ? kitItem.DefaultQty : 1,
                                AddCountDesc: "",
                                PreCloseCount: "",
                                PostCloseCount: "",
                                PostSewCount: "",
                                InventoryType: ivType,
								SterilityPack: SterilityPackId
                            });
                        }
                    }
                }
                saveCountDatas();
                $.messager.alert("提示", "扫码成功", "success");
            } else {
                $.messager.alert("提示", "数据回传失败。" + saveCSSDRet.result, "warning");
            }

        }
    });


    $("#btnExitKit").linkbutton({
        onClick: function() {
            $("#surKitDialog").dialog("close");
            var opts = $("#surKitDialog").dialog("options");
            // var countBoxId=opts.countBoxId;
            var comboBoxId = opts.comboBoxId;
            $("#" + comboBoxId).combobox("clear");
        }
    });
    $("#btnExitKit1").linkbutton({
        onClick: function() {
            $("#CSSPackDialog").dialog("close");
            var opts = $("#CSSPackDialog").dialog("options");
            // var countBoxId=opts.countBoxId;
            var comboBoxId = opts.comboBoxId;
            $("#" + comboBoxId).combobox("clear");
        }
    });
	$("#PackListBox").datagrid({
        fit: true,
        singleSelect: false,
        checkOnSelect: false,
        selectOnCheck: false,
        rownumbers: true,
        headerCls: "panel-header-gray",
        bodyCls: "panel-header-gray",
        url: ANCSP.DataQuery,
        toolbar: "",
        columns: [
            [{
                field: "CheckStatus",
                title: "选择",
                width: 60,
                checkbox: true
            }, {
                field: "RowId",
                title: "RowId",
                width: 100,
                hidden: true
            },{
                field: "BarCode",
                title: "包号",
                width: 150
            }, {
                field: "Description",
                title: "无菌包名称",
                width: 200
            }]
        ],
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.SterilityPack;
            param.QueryName = "FindUsedPackList";
            param.Arg1 = session.RecordSheetID;
            param.ArgCnt = 1;
        },
        onLoadSuccess: function(data) {
            //$(this).datagrid("checkAll");
        }
    });
	$("#btnPackList").linkbutton({
        onClick: function() {
			$("#PackListDialog").dialog("open");
            $("#PackListBox").datagrid("reload");
		}
	});
	$("#btnCancelPack").linkbutton({
        onClick: function() {
			var checkedPackRows = $("#PackListBox").datagrid("getChecked");
			if (checkedPackRows && checkedPackRows.length > 0) {
				$.messager.confirm("确认", "撤销已勾选消毒包？", function(result) {
					if (result) {
						for (var i = 0; i < checkedPackRows.length; i++) 
						{
							var checkedPack = checkedPackRows[i];
							var packNo=checkedPack.BarCode;
							var saveSign = dhccl.runServerMethod(ANCLS.BLL.SterilityPack, "CancelPackage", session.OPSID,packNo);  
						}
						window.location.reload();
					}
				});
			}
			else
			{
				$.messager.alert("提示","未勾选消毒包!","error");
			}
		}
	});
}

/**
 * 提交表单
 */
function submitRecord(signCode){
    if(!signCode){
        $.messager.alert("提示","无签名代码","error");
        return;
    }
    var toSignData = getToSignData();
    var archiveData = "";
    var drawData = getDrawData();

    archiveRecordManager.signAndRecordArchive(signCode, toSignData, archiveData, drawData, "", function(){
        setSubmitState();
    });
}

function revokeSubmitRecord(signCode){
    if(!signCode){
        $.messager.alert("提示","无签名代码","error");
        return;
    }
    $.messager.confirm('确定', '你是否要撤销提交表单?', function(r){
        if (r){
            archiveRecordManager.revokeRecordArchive(signCode, function(){
                SignTool.clearSignatureBoxList();
                setSubmitState();
            });
        }
    });
}

function archiveAllPagesNew(){
    archiveRecordManager.archive();
}

function printSubmitAllNew(){
    archiveRecordManager.print();
}

function setSubmitState(){
    var archiveCodeStr = "DCircualNurseSign^ICircualNurseSign";
    SignTool.setSignatureBoxList();
    var recordSheetId = session.RecordSheetID;

    $('#btnICircualNurseRevokeSubmit').linkbutton("disable");
    $('#btnDCircualNurseRevokeSubmit').linkbutton("disable");

    //加载签名信息
    var archiveRecordList = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: ANCLS.BLL.ArchiveRecord,
        QueryName: "FindArchiveRecordList",
        Arg1: recordSheetId,
        ArgCnt: 1
    }, "json");
    if(archiveRecordList && archiveRecordList.length && archiveRecordList.length > 0){
        for (var i = 0; i < archiveRecordList.length; i++) {
            var archiveRecord = archiveRecordList[i];
            var archiveRecordId = archiveRecord.RowId;
            var signatureList = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: ANCLS.BLL.ArchiveRecord,
                QueryName: "FindArchiveSignatureList",
                Arg1: archiveRecordId,
                ArgCnt: 1
            }, "json");
            SignTool.setSignatureBoxList(signatureList);

            if(archiveRecord.ArchiveCode == "ICircualNurseSign"){
                $('#btnICircualNurseSubmit').linkbutton("disable");
                $('#btnICircualNurseRevokeSubmit').linkbutton("enable");
                
            }else{
                $('#btnICircualNurseSubmit').linkbutton("enable");
                $('#btnICircualNurseRevokeSubmit').linkbutton("disable");
            }

            if(archiveRecord.ArchiveCode == "DCircualNurseSign"){
                $('#btnDCircualNurseSubmit').linkbutton("disable");
                $('#btnDCircualNurseRevokeSubmit').linkbutton("enable");
                
            }else{
                $('#btnDCircualNurseSubmit').linkbutton("enable");
                $('#btnDCircualNurseRevokeSubmit').linkbutton("disable");
            }
        }
    }

    var isSubmited = dhccl.runServerMethodNormal(ANCLS.BLL.ArchiveRecord, "CheckAllSubmitState", recordSheetId, archiveCodeStr);
    if(isSubmited == "Y"){
        $('#btnSave').css("background","gray")
        $('#btnSave').linkbutton('disable');
        $('#btnPrint').linkbutton('enable');
        $('#btnArchive').linkbutton('enable');

        $('#ISurgicalKit').combobox('disable');
        $('#ISurgicalItem').combobox('disable');
        $('#btnDelISurgicalItem').linkbutton('disable');
        $('#DSurgicalKit').combobox('disable');
        $('#DSurgicalItem').combobox('disable');
        $('#btnDelDSurgicalItem').linkbutton('disable');
    }else{
        $('#btnArchive').linkbutton({ text: '归档', iconCls: 'icon-w-file'});
        $('#btnSave').css("background","#21ba45")
        $('#btnSave').linkbutton('enable');
        $('#btnPrint').linkbutton('disable');
        $('#btnArchive').linkbutton('disable');

        $('#ISurgicalKit').combobox('enable');
        $('#ISurgicalItem').combobox('enable');
        $('#btnDelISurgicalItem').linkbutton('enable');
        $('#DSurgicalKit').combobox('enable');
        $('#DSurgicalItem').combobox('enable');
        $('#btnDelDSurgicalItem').linkbutton('enable');
    }
}

function getToSignData(){
    return JSON.stringify({
        operSchedule: operCount.schedule,
        instruments: getCountDatas('instrumentsBox'),
        dressings: getCountDatas('dressingsBox')
    });
}

function getDrawData(){
    var drawContext = new DrawContext({
        id: operCount.schedule.RowId,
        date: operCount.schedule.OperDate,
        code: session.ModuleCode,
        name: session.ModuleDesc,
        printRatio: 1,
        archiveRatio: 1
    });
    
    var titleStyle = {
        color: "black",
        font: "bold 30px 宋体",
        valueColor: "blue"
    };
    drawContext.drawBoxText(session.ExtHospDesc, {left: 20, top:40, width: 750, height: 40}, titleStyle, false);
    drawContext.drawBoxText("手术清点记录", {left: 20, top:80, width: 750, height: 40}, titleStyle, false);
    
    var operSchedule = operCount.schedule || {};
    var itemStyle = {
        color: "black",
        font: "normal 16px 宋体",
        valueColor: "blue"
    };
    drawContext.drawTextboxItem("姓名：", {left: 20, top:180, width: 130, height: 30}, operSchedule.PatName||"", "", itemStyle, true);
    drawContext.drawTextboxItem("性别：", {left: 160, top:180, width: 80, height: 30}, operSchedule.PatGender||"", "", itemStyle, true);
    drawContext.drawTextboxItem("年龄：", {left: 260, top:180, width: 80, height: 30}, operSchedule.PatAge||"", "", itemStyle, true);
    drawContext.drawTextboxItem("科室：", {left: 360, top:180, width: 150, height: 30}, operSchedule.PatDeptDesc||"", "", itemStyle, true);
    drawContext.drawTextboxItem("床号：", {left: 530, top:180, width: 100, height: 30}, operSchedule.PatBedCode||"", "", itemStyle, true);
    drawContext.drawTextboxItem("住院号：", {left: 640, top:180, width: 130, height: 30}, operSchedule.MedcareNo||"", "", itemStyle, true);

    drawContext.drawTextboxItem("手术日期：", {left: 20, top:210, width: 200, height: 30}, operSchedule.OperDate||"", "", itemStyle, true);
    drawContext.drawTextboxItem("手术方式：", {left: 230, top:210, width: 540, height: 30}, operSchedule.OperDesc||"", "", itemStyle, true);

    if($("#ICircualNurseSignImage").attr("src")){
        drawContext.drawTextboxItem("巡回护士：", {left: 20, top:240, width: 200, height: 30}, "", "", itemStyle, false);
        drawContext.drawImage($("#ICircualNurseSignImage").attr("src"), 100, 240, 100, 30);
    }else{
        drawContext.drawTextboxItem("巡回护士：", {left: 20, top:240, width: 200, height: 30}, $("#ICircualNurseSign").triggerbox("getValue"), "", itemStyle, true);
    }
    
    if($("#DCircualNurseSignImage").attr("src")){
        drawContext.drawTextboxItem("器械护士：", {left: 230, top:240, width: 200, height: 30}, "", "", itemStyle, false);
        drawContext.drawImage($("#DCircualNurseSignImage").attr("src"), 310, 240, 100, 30);
    }else{
        drawContext.drawTextboxItem("器械护士：", {left: 230, top:240, width: 200, height: 30}, $("#DCircualNurseSign").triggerbox("getValue"), "", itemStyle, true);
    }

    var startPos = {
        x: 20,
        y: 300
    }
    var titleTextArr = [['器械名称', '术前清点', '术中加数', '关体腔前', '关体腔后', '缝皮肤后','器械名称', '术前清点', '术中加数', '关体腔前', '关体腔后', '缝皮肤后']];
    
    var instrumentsRows = $("#instrumentsBox").datagrid("getRows");
    var dressingCountRows = $("#dressingsBox").datagrid("getRows");
    var maxRowsCount = Math.max(instrumentsRows.length, dressingCountRows.length);
    for (let i = 0; i < maxRowsCount; i++) {
        var singleTextArr = [];
        singleTextArr.push(i < instrumentsRows.length ? instrumentsRows[i].MaterialNote: '');
        singleTextArr.push(i < instrumentsRows.length ? instrumentsRows[i].PreopCount: '');
        singleTextArr.push(i < instrumentsRows.length ? instrumentsRows[i].OperAddCount: '');
        singleTextArr.push(i < instrumentsRows.length ? instrumentsRows[i].PreCloseCount: '');
        singleTextArr.push(i < instrumentsRows.length ? instrumentsRows[i].PostCloseCount: '');
        singleTextArr.push(i < instrumentsRows.length ? instrumentsRows[i].PostSewCount: '');

        singleTextArr.push(i < dressingCountRows.length ? dressingCountRows[i].MaterialNote: '');
        singleTextArr.push(i < dressingCountRows.length ? dressingCountRows[i].PreopCount: '');
        singleTextArr.push(i < dressingCountRows.length ? dressingCountRows[i].OperAddCount: '');
        singleTextArr.push(i < dressingCountRows.length ? dressingCountRows[i].PreCloseCount: '');
        singleTextArr.push(i < dressingCountRows.length ? dressingCountRows[i].PostCloseCount: '');
        singleTextArr.push(i < dressingCountRows.length ? dressingCountRows[i].PostSewCount: '');

        titleTextArr.push(singleTextArr);
    }

    var left = startPos.x;
    var top = startPos.y;
    var boxWidth = 40;
    var boxHeight = 50;
    var maxWidth = 40;

    for(var i=0; i<titleTextArr.length; i++){
        for(var j=0; j<titleTextArr[i].length; j++){
            if(j==0 || j ==6) {
                boxWidth=100;
                maxWidth=90;
            }
            else {
                boxWidth=50;
                maxWidth=40;
            }

            var text = titleTextArr[i][j];
            drawContext.drawBoxText(text, {left: left, top:top, width: boxWidth, height: boxHeight}, itemStyle, true, maxWidth);

            left += boxWidth;
            if(j==5) left+=10;
        }
        left = startPos.x;
        top += boxHeight;

        if(top>1000){
            drawContext.addPage();
            top = 20;
        }
    }
    
    drawContext.addPage();
    drawContext.drawRectangle({left: 20, top:40, width: 740, height: 800}, 'black', '');
    drawContext.drawTextboxItem("体内植入物条形码粘贴处：", {left: 20, top:860, width: 200, height: 30}, "", "", itemStyle, false);
    drawContext.drawTextboxItem("填表说明：", {left: 20, top:900, width: 200, height: 30}, "", "", itemStyle, false);
    drawContext.drawTextboxItem("1.表格内的清点数必须用数字说明，不得用\"√\"表示。", {left: 20, top:940, width: 200, height: 30}, "", "", itemStyle, false);
    drawContext.drawTextboxItem("2.空格处可以填写其他手术物品。", {left: 20, top:980, width: 200, height: 30}, "", "", itemStyle, false);
    drawContext.drawTextboxItem("3.表格内的清点数目必须清晰，不得采用刮、粘、涂等方法涂改。", {left: 20, top:1020, width: 200, height: 30}, "", "", itemStyle, false);

    return JSON.stringify(drawContext);
}

/**
 * 初始化操作功能按钮
 */
function initOperActions() {
    $('#btnSave').linkbutton({
        onClick: function() {
            saveCountDatas();
        }
    });

    $('#btnPrint').linkbutton({
        onClick:function(){
            archiveAllPagesNew();
        }
    });

    $('#btnArchive').linkbutton({
        onClick:function(){
            //printMessage();
            printSubmitAllNew();
        }
    });

    // 巡回护士提交
    $('#btnICircualNurseSubmit').linkbutton({
        onClick:function(){
            submitRecord('ICircualNurseSign');
        }
    });

    $('#btnICircualNurseRevokeSubmit').linkbutton({
        onClick:function(){
            revokeSubmitRecord('ICircualNurseSign');
        }
    });

    // 器械护士提交
    $('#btnDCircualNurseSubmit').linkbutton({
        onClick:function(){
            submitRecord('DCircualNurseSign');
        }
    });

    $('#btnDCircualNurseRevokeSubmit').linkbutton({
        onClick:function(){
            revokeSubmitRecord('DCircualNurseSign');
        }
    });

    $('#btnDirectPrint').linkbutton({
        onClick:function(){
            var drawData = getDrawData();
            archiveRecordManager.directPrint(drawData);
        }
    });
}

/**
 * 术中加数编辑框文本变化，重新计算术中加数。
 */
function calcAddCount(editor, rowData) {
    if (editor && editor.target) {
        $(editor.target).change(function(e) {
            var addCountStr = $(this).val();
            var operAddCount = 0;
            if (addCountStr) {
                var addCountArr = addCountStr.split("+"); // 用户在术中加数编辑框中输入的文本必须是以+拼接数字字符串，如：1+1+2+4 表示术中加了4次器械，第1次加了1把，第2次加了1把，第3次加了2把，第4次加了4把。
                for (var index = 0; index < addCountArr.length; index++) {
                    var element = Number(addCountArr[index]);
                    if (!isNaN(element)) {
                        operAddCount += element;
                    }
                }
                rowData.OperAddCount = operAddCount;
            }
        });
    }
}

/**
 * 判断某一器械各阶段的数量是否一致，即：(术前清点数+术中加数)=关前清点数/关后清点数/缝皮后清点数
 * @param {object} row 器械清点记录行数据对象
 */
function operCountBalance(row, field) {
    var preopCount = isNaN(row.PreopCount) ? 0 : Number(row.PreopCount), // 术前清点数存在用户未填写数值的情况，需要判断值是否为数字。
        operAddCount = isNaN(row.OperAddCount) ? 0 : Number(row.OperAddCount),
        fieldCount = isNaN(row[field]) ? 0 : Number(row[field]),
        preopTotalCount = preopCount + operAddCount;
    // 如果(术前清点数+术中加数)≠关前清点数或关后清点数或缝皮后清点数
    if (preopTotalCount !== fieldCount) {
        return false;
    }
    return true;
}

function selectedSurgicalKit(id, title, surgicalKit, countBoxId) {
    $("#surKitDialog").dialog("open");
    var opts = $("#surKitDialog").dialog("options");
    opts.countBoxId = countBoxId;
    opts.comboBoxId = id;
    // $("#surKitDialog").dialog({
    //     countBoxId:countBoxId,
    //     comboBoxId:id
    // });
    $("#SurgicalKitBox").datagrid("reload");
    var surKitDesc = $("#" + id).combobox("getText");
    $("#surKitDialog").dialog("setTitle", title + "-" + surKitDesc);
    var comboBoxId = opts.comboBoxId;
    $("#" + comboBoxId).combobox("clear");
}

/**
 * 添加手术物品
 * @param {String} boxId 清点记录表格ID
 * @param {object} surgicalItem 手术物品json对象
 */
function addSurgicalItem(boxId, comboId, surgicalItem, ivType) {
    var result = existsSurgicalItem(boxId, surgicalItem.RowId, surgicalItem.Description);
    if (result.existence) {
        $.messager.alert("提示", "手术清点列表已存在" + result.rowData.MaterialNote + "。", "warning");
        $("#" + boxId).datagrid("selectRow", result.rowIndex);
    } else {
        $.messager.confirm("提示", "是否添加“" + surgicalItem.Description + "”到清点列表？", function(r) {
            if (r) {
                $("#" + boxId).datagrid("appendRow", {
                    SurgicalMaterial: surgicalItem.RowId,
                    SurgicalMaterialDesc: surgicalItem.Description,
                    MaterialNote: surgicalItem.Description,
                    PreopCount: (surgicalItem.PreopCount ? surgicalItem.PreopCount : 1),
                    AddCountDesc: (surgicalItem.AddCountDesc ? surgicalItem.AddCountDesc : ""),
                    PreCloseCount: (surgicalItem.PreCloseCount ? surgicalItem.PreCloseCount : ""),
                    PostCloseCount: (surgicalItem.PostCloseCount ? surgicalItem.PostCloseCount : ""),
                    PostSewCount: (surgicalItem.PostSewCount ? surgicalItem.PostSewCount : ""),
                    BarCode: "",
                    InventoryType: ivType
                });
                $("#" + comboId).combobox("clear");
            }
        });
    }
}

/**
 * 判断清点记录表格存在手术物品的清点记录。
 * @param {string} boxId 清点记录表格ID
 * @param {string} surgicalItem 手术物品RowId或名称
 */
function existsSurgicalItem(boxId, surgicalItem, SurgicalMaterialDesc) {
    var result = {
        existence: false,
        rowIndex: -1,
        rowData: null
    };
    var countRows = $("#" + boxId).datagrid("getRows");
    if (countRows && countRows.length > 0) {
        for (var countIndex = 0; countIndex < countRows.length; countIndex++) {
            var countRow = countRows[countIndex];
            if ((countRow.SurgicalMaterial === surgicalItem && surgicalItem != "") || countRow.MaterialNote === SurgicalMaterialDesc) {
                result.exists = true;
                result.rowIndex = countIndex;
                result.rowData = countRow;
                break;
            }
        }
    }
    return result;
}

/**
 * 批量删除清点记录
 * @param {String} boxId 表格ID
 * @param {Array} countDatas 需要删除清点记录数组
 */
function delCountRecord(boxId, countDatas) {
    var saveDatas = [],
        delDatas = [];
    for (var i = 0; i < countDatas.length; i++) {
        const element = countDatas[i];
        var rowIndex = $("#" + boxId).datagrid("getRowIndex", element);
        var dto = {
            ClassName: ANCLS.Model.SurInventory,
            RowId: element.RowId
        };
        var delObj = {
            RowIndex: rowIndex,
            RowData: element
        }
        if (dto.RowId) {
            saveDatas.push(dto);
        }
        delDatas.push(delObj);
    }
    if (saveDatas.length > 0) {
        var jsonStr = dhccl.formatObjects(saveDatas);
        var delResult = dhccl.removeDatas(jsonStr);
        if (delResult.indexOf("S^") === 0) {
            for (var i = 0; i < delDatas.length; i++) {
                const element = delDatas[i];
                var rowIndex = $("#" + boxId).datagrid("getRowIndex", element.RowData);
                $("#" + boxId).datagrid("deleteRow", rowIndex);
            }
            $("#" + boxId).datagrid("clearChecked");
        } else {
            $.messager.alert("提示", "删除失败，原因：" + delResult, "error");
        }
    } else {
        for (var i = 0; i < delDatas.length; i++) {
            const element = delDatas[i];
            var rowIndex = $("#" + boxId).datagrid("getRowIndex", element.RowData);
            $("#" + boxId).datagrid("deleteRow", rowIndex);
        }
        $("#" + boxId).datagrid("clearChecked");
    }

}

/**
 * 用户点击单元格时，自动计算并生成清点记录数据。
 * @param {String} boxId 表格ID
 * @param {Array} countDatas 清点记录数组
 */
function genCountData(boxId, clickField, countDatas) {
    var genFields = ['PreCloseCount', 'PostCloseCount', 'PostSewCount'];
    if (genFields.indexOf(clickField) < 0) return; // 只有关前清点、关后清点和缝皮后清点数据自动生成
    for (var i = 0; i < countDatas.length; i++) {
        const element = countDatas[i];
        var curCount = parseFloat(element[clickField]);
        var preopCount = parseFloat(element['PreopCount']);
        preopCount = !isNaN(preopCount) ? preopCount : 0;
        var operAddCount = parseFloat(element['OperAddCount']);
        operAddCount = !isNaN(operAddCount) ? operAddCount : 0;
        if (curCount === (preopCount + operAddCount)) continue;
        element[clickField] = preopCount + operAddCount;
        $('#' + boxId).datagrid('updateRow', {
            index: i,
            data: element
        });
    }
}

/**
 * 结束表格中所有单元格的编辑状态
 * @param {String} boxId 表格ID
 */
function endEditDataGrid(boxId) {
    var rows = $('#' + boxId).datagrid('getRows');
    if (rows && rows.length > 0) {
        for (var i = 0; i < rows.length; i++) {
            const element = rows[i];
            $('#' + boxId).datagrid('endEdit', i);
        }
    }
}

/**
 * 保存清点记录数据
 * @param {String} boxId 表格ID
 */
function saveCountDatas() {
    var boxIdList = ['instrumentsBox', 'dressingsBox'];
    var saveDatas = [];

    for (var i = 0; i < boxIdList.length; i++) {
        const boxId = boxIdList[i];
        var countDatas = getCountDatas(boxId);
        for (var j = 0; j < countDatas.length; j++) {
            const countData = countDatas[j];
            saveDatas.push(countData);
        }
    }
    if (saveDatas.length == 0) {
        $.messager.alert("提示信息", "请添加手术物品后再保存！！");
        return;
    }
    var jsonData = dhccl.formatObjects(saveDatas);
    var data = dhccl.saveDatas(ANCSP.DataListService, {
        jsonData: jsonData
    }, function(result) {
        if (result.indexOf("S^") === 0) {
            $('#instrumentsBox,#dressingsBox').datagrid("reload");
        } else {
            $.messager.alert("保存清点数据失败，原因：" + result);
        }

    });
}

/**
 * 保存无菌包信息
 */
function saveCSSDPackDatas(savePackNo, saveSterilityPack) {

    if (savePackNo.length == 0) {
        return "数据为空，不能回传";
    }
    var savePackNojsonData = dhccl.formatObjects(savePackNo);
    var saveSterilityPackjsonData = dhccl.formatObjects(saveSterilityPack);

    operDataManager.reloadPatInfo(loadApplicationData);
    var operInfo = [];
    var PatInfo = {
        OPAID: operCount.schedule.OPAID,
        PatName: operCount.schedule.PatName,
        PatientID: operCount.schedule.EpisodeID,
        AppCareProvID: operCount.schedule.AppCareProvID,
        ArrOperRoom: operCount.schedule.ArrOperRoom,
        ScrubNurse: operCount.schedule.ScrubNurse,
        CircualNurse: operCount.schedule.CircualNurse,
        OperDesc: operCount.schedule.OperDesc
    }
    operInfo.push(PatInfo);
    var operInfoData = dhccl.formatObjects(operInfo);
    var saveSign = dhccl.runServerMethod(ANCLS.BLL.SterilityPack, "SaveSterilityPack", savePackNojsonData, saveSterilityPackjsonData, operInfoData);
    return saveSign;
}

function getCountDatas(boxId) {
    var countDatas = $('#' + boxId).datagrid('getRows');
    var saveDatas = [];
    if (countDatas && countDatas.length > 0 && session.RecordSheetID) {
        for (var i = 0; i < countDatas.length; i++) {
            const element = countDatas[i];
            var surgicalCount = {
                RowId: element.RowId,
                RecordSheet: session.RecordSheetID,
                SurgicalMaterial: element.SurgicalMaterial,
                MaterialNote: element.MaterialNote,
                AddCountDesc: element.AddCountDesc,
                InventoryType: element.InventoryType,
				SterilityPack: element.SterilityPack,
                ClassName: ANCLS.Model.SurInventory
            }
            var preopCount = parseFloat(element.PreopCount);
            surgicalCount.PreopCount = !isNaN(preopCount) ? preopCount : "";
            var operAddCount = parseFloat(element.OperAddCount);
            surgicalCount.OperAddCount = !isNaN(operAddCount) ? operAddCount : "";
            var preCloseCount = parseFloat(element.PreCloseCount);
            surgicalCount.PreCloseCount = !isNaN(preCloseCount) ? preCloseCount : "";
            var postCloseCount = parseFloat(element.PostCloseCount);
            surgicalCount.PostCloseCount = !isNaN(postCloseCount) ? postCloseCount : "";
            var postSewCount = parseFloat(element.PostSewCount);
            surgicalCount.PostSewCount = !isNaN(postSewCount) ? postSewCount : "";
            saveDatas.push(surgicalCount);
        }
    }
    return saveDatas;
}

function calExp(exp) {
    var expArr = exp.split("+");
    var result = 0;
    for (var i = 0; i < expArr.length; i++) {
        result += Number(expArr[i]);
    }
    return result;
}

var patInfo;
var operSchedule;

function printMessage() {
    var count = operDataManager.printCount(session.RecordSheetID, session.ModuleCode)
    var ifMessage = operDataManager.ifPrintMessage()
    if (ifMessage != "Y" || Number(count) == 0) printDocument()
    else if (Number(count) > 0) {
        $.messager.confirm("提示", "表单已打印" + count + "次,是否继续打印", function(r) {
            if (r) {
                printDocument()
            }
        });
    }
}

function printDocument() {
    var dataIntegrity = operDataManager.isDataIntegrity(".operdata");
    if (dataIntegrity === false) {
        $.messager.alert("提示", "手术清点数据不完整！", "warning");
        //return;
    }
    //operDataManager.printCount(session.RecordSheetID,session.ModuleCode,true);
    operDataManager.reloadPatInfo(loadApplicationData);
    var lodop = getLodop();
    lodop.PRINT_INIT("OperCount" + session.OPSID);
    lodop.SET_PRINT_MODE("PRINT_DUPLEX", 2);
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, "A4");
    var printCount;
    /*if(lodop.SET_PRINTER_INDEXA(PrintSetting.PrintPaper.Printer))
    {
        createPrintOnePage(lodop,operCount.schedule);
        lodop.SET_PREVIEW_WINDOW(1,2,0,0,0,"");
        lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW",1);
        printCount=lodop.PREVIEW();

    }else{*/
    createPrintOnePage(lodop, operCount.schedule);
    lodop.SET_PREVIEW_WINDOW(1, 2, 0, 0, 0, "");
    lodop.SET_PRINT_MODE("AUTO_CLOSE_PREWINDOW", 1);
    printCount = lodop.PREVIEW();
    //}
    operDataManager.savePrintLog(session.RecordSheetID, session.ModuleCode, session.UserID);
}

function createPrintOnePage(lodop, operSchedule) {
    var prtConfig = sheetPrintConfig;
    lodop.SET_PRINT_PAGESIZE(prtConfig.paper.direction, 0, 0, prtConfig.paper.name);



    // 打印首页
    var startPos = getPrintTitle(lodop, operSchedule);
    var operCountHtml = getOperCountHtml(1);
    lodop.ADD_PRINT_HTM(startPos.y, startPos.x, "RightMargin:1.5cm", "BottomMargin:1cm", operCountHtml.html);

    // 打印首页背面
    lodop.NEWPAGE();
    var lineHeight = 20;
    startPos.x = prtConfig.paper.margin.left;
    startPos.y = prtConfig.paper.margin.top;
    lodop.ADD_PRINT_RECT(startPos.y, startPos.x, "RightMargin:1.5cm", 880, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y + 10, startPos.x + 10, "100%", lineHeight, "体内植入物条形码粘贴处：");
    startPos.y += 900;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", lineHeight, "填表说明：");
    startPos.y += lineHeight;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", lineHeight, "1.表格内的清点数必须用数字说明，不得用\"√\"表示。");
    startPos.y += lineHeight;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", lineHeight, "2.空格处可以填写其他手术物品。");
    startPos.y += lineHeight;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", lineHeight, "3.表格内的清点数目必须清晰，不得采用刮、粘、涂等方法涂改。");

    // 清点记录超出一页，打印到第2页
    if (operCountHtml.morePage) {
        lodop.NEWPAGE();
        startPos = getPrintTitle(lodop, operSchedule);
        operCountHtml = getOperCountHtml(2);
        lodop.ADD_PRINT_HTM(startPos.y, startPos.x, "RightMargin:1.5cm", "BottomMargin:1cm", operCountHtml.html);
    }

    // 打印页码
    lodop.ADD_PRINT_HTM(1050, 300, "100%", 28, "<span tdata='pageNO'>第##页</span> <span tdata='pageCount'>共##页</span>");
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "ItemType", 1);
}

function getPrintTitle(lodop, operSchedule) {
    var prtConfig = sheetPrintConfig,
        logoMargin = prtConfig.logo.margin,
        logoSize = prtConfig.logo.size,
        titleFont = prtConfig.title.font,
        titleSize = prtConfig.title.size,
        titleMargin = prtConfig.title.margin;
    var startPos = {
        x: prtConfig.paper.margin.left,
        y: logoMargin.top + logoSize.height + logoMargin.bottom
    };
    lodop.ADD_PRINT_TEXT(70, startPos.x, 620, 60, session.ExtHospDesc);
    lodop.SET_PRINT_STYLEA(0, "FontName", "宋体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Bold",1);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 620, 30, "手术清点记录");
    lodop.SET_PRINT_STYLEA(0, "FontName", "宋体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Bold",1);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    startPos.y += titleSize.height + titleMargin.bottom;
    var lineHeight = 20;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 200, 15, "姓名：" + (operSchedule ? operSchedule.PatName : ""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 120, 200, 15, "性别：" + (operSchedule ? operSchedule.PatGender : ""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 200, 200, 15, "年龄：" + (operSchedule ? operSchedule.PatAge : ""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 300, 200, 15, "科室：" + (operSchedule ? operSchedule.PatDeptDesc : ""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 460, 200, 15, "床号：" + (operSchedule ? operSchedule.PatBedCode : ""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 540, 200, 15, "住院号：" + (operSchedule ? operSchedule.MedcareNo : ""));
    var anaestMethodInfo = operSchedule ? operSchedule.AnaestMethodInfo : ""
    if (!anaestMethodInfo || anaestMethodInfo === "") {
        anaestMethodInfo = operSchedule ? operSchedule.PrevAnaMethodDesc : "";
    }
    startPos.y += lineHeight;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 540, 200, 15, "手术日期:" + (operSchedule ? operSchedule.OperDate : ""));
    var operInfo = $("#OperationDesc").val();
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, "100%", 15, "手术方式：");
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 70, 470, 30, operSchedule ? operSchedule.OperDesc : "");

    startPos.y += lineHeight + (operInfo.length > 40 ? 25 : 0);

    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x, 200, 15, "巡回护士:" + $("#ICircualNurseSign").triggerbox("getValue"));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x + 200, 200, 15, "器械护士:" + $("#DCircualNurseSign").triggerbox("getValue"));
    startPos.y += lineHeight;

    return startPos;
}

function getOperCountHtml(pageNo) {
    var hasMorePage = false;
    var htmlArr = [
        "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size: 14px;}",
        "table {table-layout:fixed;} td {text-align:center}",
        "tr {height:22px;} .textline {display:inline-block;width:100px;height:18px;border:none;border-bottom:1px solid #000;}</style>",
        "<table>"
    ];

    var inventoryPageRowCount = 20,
        inventoryPageCount = 2 * inventoryPageRowCount;
    var inventoryRows = $("#instrumentsBox").datagrid("getRows");
    var inventory = {
        rows: inventoryRows,
        pageRowCount: inventoryPageRowCount,
        startRowIndex: (pageNo - 1) * inventoryPageRowCount,
        endRowIndex: pageNo * inventoryPageRowCount,
        startCount: (pageNo - 1) * inventoryPageCount,
        endCount: pageNo * inventoryPageCount
    }

    if (pageNo == 2) {
        inventory.startRowIndex = (pageNo - 1) * inventoryPageCount;
        inventory.endRowIndex = inventory.startRowIndex + inventoryPageRowCount;
    }
    var operCountRow, secCountRow;
    var operCount = {
        MaterialNote: "",
        PreopCount: "",
        OperAddCount: "",
        PreCloseCount: "",
        PostCloseCount: "",
        PostSewCount: ""
    }

    if (inventoryRows.length > inventory.startCount || pageNo === 1) {
        htmlArr.push("<tr><th width='140'>器械名称</th><th width='40'>术前清点</th><th width='40'>术中加数</th><th width='40'>关体腔前</th><th width='40'>关体腔后</th><th width='40'>缝皮肤后</th><th width='140'>器械名称</th><th width='40'>术前清点</th><th width='40'>术中加数</th><th width='40'>关体腔前</th><th width='40'>关体腔后</th><th width='40'>缝皮肤后</th></tr>");
        //alert(operCountRows.length)
        for (var i = inventory.startRowIndex; i < inventory.endRowIndex; i++) {
            if (i >= inventoryRows.length) {
                operCountRow = operCount;
                secCountRow = operCount;
            } else {
                operCountRow = inventoryRows[i];
                secCountRow = inventoryRows.length > (i + inventory.pageRowCount) ? inventoryRows[i + inventory.pageRowCount] : operCount;
            }

            htmlArr.push("<tr><td>" + (operCountRow.MaterialNote ? operCountRow.MaterialNote : "") + "</td>");
            if (operCountRow.MaterialNote) {
                htmlArr.push("<td>" + (operCountRow.PreopCount ? operCountRow.PreopCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (operCountRow.MaterialNote) {
                htmlArr.push("<td>" + (Number(operCountRow.OperAddCount) > 0 ? operCountRow.OperAddCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (operCountRow.MaterialNote) {
                htmlArr.push("<td>" + (operCountRow.PreCloseCount ? operCountRow.PreCloseCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (operCountRow.MaterialNote) {
                htmlArr.push("<td>" + (operCountRow.PostCloseCount ? operCountRow.PostCloseCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (operCountRow.MaterialNote) {
                htmlArr.push("<td>" + (operCountRow.PostSewCount ? operCountRow.PostSewCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }

            htmlArr.push("<td>" + (secCountRow.MaterialNote ? secCountRow.MaterialNote : "") + "</td>");
            if (secCountRow.MaterialNote) {
                htmlArr.push("<td>" + (secCountRow.PreopCount ? secCountRow.PreopCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (secCountRow.MaterialNote) {
                htmlArr.push("<td>" + (Number(secCountRow.OperAddCount) > 0 ? secCountRow.OperAddCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (secCountRow.MaterialNote) {
                htmlArr.push("<td>" + (secCountRow.PreCloseCount ? secCountRow.PreCloseCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (secCountRow.MaterialNote) {
                htmlArr.push("<td>" + (secCountRow.PostCloseCount ? secCountRow.PostCloseCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (secCountRow.MaterialNote) {
                htmlArr.push("<td>" + (secCountRow.PostSewCount ? secCountRow.PostSewCount : 0) + "</td></tr>");
            } else {
                htmlArr.push("<td></td></tr>");
            }

        }

        htmlArr.push("<tr><td colspan='12'></td></tr>");
    }


    var dressingCountRows = $("#dressingsBox").datagrid("getRows");
    var dressingPageRowCount = 7,
        dressingPageCount = 2 * dressingPageRowCount;
    var dressing = {
        rows: dressingCountRows,
        pageRowCount: dressingPageRowCount,
        startRowIndex: (pageNo - 1) * dressingPageRowCount,
        endRowIndex: pageNo * dressingPageRowCount,
        startCount: (pageNo - 1) * dressingPageCount,
        endCount: pageNo * dressingPageCount
    }

    operCount = {
        MaterialNote: "",
        PreopCount: "",
        OperAddCount: "",
        PreCloseCount: "",
        PostCloseCount: "",
        PostSewCount: ""
    }
    if (dressingCountRows.length > dressing.startCount || pageNo === 1) {
        htmlArr.push("<tr><th>敷料名称</th><th>术前清点</th><th>术中加数</th><th>关体腔前</th><th>关体腔后</th><th>缝皮肤后</th>");
        htmlArr.push("<th>敷料名称</th><th>术前清点</th><th>术中加数</th><th>关体腔前</th><th>关体腔后</th><th>缝皮肤后</th></tr>");
        for (var i = dressing.startRowIndex; i < dressing.endRowIndex; i++) {
            if (i >= dressingCountRows.length) {
                operCountRow = operCount;
                secCountRow = operCount;
            } else {
                operCountRow = dressingCountRows[i];
                secCountRow = dressingCountRows.length > (i + dressing.pageRowCount) ? dressingCountRows[i + dressing.pageRowCount] : operCount;
            }

            htmlArr.push("<tr><td>" + (operCountRow.MaterialNote ? operCountRow.MaterialNote : "") + "</td>");

            if (operCountRow.MaterialNote) {
                htmlArr.push("<td>" + (operCountRow.PreopCount ? operCountRow.PreopCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (operCountRow.MaterialNote) {
                htmlArr.push("<td>" + (Number(operCountRow.OperAddCount) > 0 ? operCountRow.OperAddCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (operCountRow.MaterialNote) {
                htmlArr.push("<td>" + (operCountRow.PreCloseCount ? operCountRow.PreCloseCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (operCountRow.MaterialNote) {
                htmlArr.push("<td>" + (operCountRow.PostCloseCount ? operCountRow.PostCloseCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (operCountRow.MaterialNote) {
                htmlArr.push("<td>" + (operCountRow.PostSewCount ? operCountRow.PostSewCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }

            htmlArr.push("<td>" + (secCountRow.MaterialNote ? secCountRow.MaterialNote : "") + "</td>");
            if (secCountRow.MaterialNote) {
                htmlArr.push("<td>" + (secCountRow.PreopCount ? secCountRow.PreopCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (secCountRow.MaterialNote) {
                htmlArr.push("<td>" + (Number(secCountRow.OperAddCount) > 0 ? secCountRow.OperAddCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (secCountRow.MaterialNote) {
                htmlArr.push("<td>" + (secCountRow.PreCloseCount ? secCountRow.PreCloseCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (secCountRow.MaterialNote) {
                htmlArr.push("<td>" + (secCountRow.PostCloseCount ? secCountRow.PostCloseCount : 0) + "</td>");
            } else {
                htmlArr.push("<td></td>");
            }
            if (secCountRow.MaterialNote) {
                htmlArr.push("<td>" + (secCountRow.PostSewCount ? secCountRow.PostSewCount : 0) + "</td></tr>");
            } else {
                htmlArr.push("<td></td></tr>");
            }

        }
    }


    htmlArr.push("</table>");

    if (inventoryPageCount < inventoryRows.length || dressingPageCount < dressingCountRows.length) {
        hasMorePage = true;
    }
    return { html: htmlArr.join(""), morePage: hasMorePage };
}

function getDressingHtml() {

}

function loadPatInfo(result) {
    if (result) {
        operSchedule = result;
        $("#PatName").text(result.PatName);
        $("#PatGender").text(result.PatGender);
        $("#PatAge").text(result.PatAge);
        $("#PatDept").text(result.PatDeptDesc);
        $("#PatWardBed").text(result.PatBedCode);
        $("#PatMedCareNo").text(result.MedcareNo);
        $("#OperDate").text(result.OperDate);
        $("#AreaInTime").text(result.AreaInDT);
        $("#OperRoom").text(result.RoomDesc);
        $("#OperationDesc").text(result.OperDesc);
        var surgenDesc = result.SurgeonDesc;
        if (result.AssistantDesc && result.AssistantDesc != "") {
            surgenDesc += "," + result.AssistantDesc;
        }
        $("#SurgeonDesc").text(surgenDesc);
        $("#SurgeonInfo").val(surgenDesc);
        var anaDoctor = result.AnesthesiologistDesc;
        if (!anaDoctor || anaDoctor === "") {
            anaDoctor = $("#AnaestDoctor").val();
        }
        $("#AnesthetistDesc").text(anaDoctor);
        $("#ABO").text(result.ABO);
        $("#RH").text(result.RH);
        $("#RealOperationDesc").val(result.OperationDesc);
        patInfo = result;

        //if(result.AreaInDT && $("#TheatreInTime").val()==='') $("#TheatreInTime").val(result.AreaInDT);
        //if(result.AreaInDT && $("#TheatreOutTime").val()==='') $("#TheatreOutTime").val(result.TheatreOutDT);

        var anaMethod = result.AnaestMethodInfo || result.PrevAnaMethodDesc;
        $("#AnaestMethod").combobox('setText', anaMethod);
        if (anaMethod == "局部麻醉" || anaMethod == "局部麻醉/全麻醉") $('.opertime-setting').show();
        else $('.opertime-setting').hide();

        $('#oper_start_time').text(result.OperStartDT);
        $('#oper_finish_time').text(result.OperFinishDT);

        if (patInfo.TheatreInDT != "") {
            $("#AnaestMethod").combobox('disable');
            $("#AnaestDoctor").attr('disabled', true);
            $("#AnaestDoctor").attr('title', '已填写麻醉单，以麻醉单上为准');
            $("#AnaestDoctor").val(patInfo.AnesthesiologistDesc);
        }
    }
}
$(document).ready(initPage);