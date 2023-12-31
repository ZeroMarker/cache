function initPage(){
    initBloodTransfusion();
}
var signCode=""
function initBloodTransfusion() {
    var columns = [
        [{
                field: "Checked",
                title: "选择",
                width: 60,
                checkbox: true
            }, {
                field: "BloodBarCode",
                title: "储血编码",
                width: 160,
                formatter: function(value, row, index) {
                    if (row.BarCode && row.BarCode !== "") {
                        return row.BarCode + "<br>" + row.ComponentCode + " <strong>" + row.BloodABO + " RhD(" + (row.BloodRH === "阳性" ? "+" : "-") + ")</strong>";
                    }
                    return "";
                }
            },
            {
                field: "BloodCategory",
                title: "血液种类",
                width: 160
            },
            {
                field: "TransABO",
                title: "血型",
                width: 60
            },
            {
                field: "BloodVolUnit",
                title: "用量",
                width: 80,
                formatter: function(value, row, index) {
                    return row.Volume + row.Unit;
                }
            },
            {
                field: "ExecProvDesc",
                title: "输血执行者",
                width: 100
            },
            {
                field: "CheckProvDesc",
                title: "核对者",
                width: 80
            },
            {
                field: "TransStartDT",
                title: "输血开始时间",
                width: 160,
                editor: {
                    type: "datetimebox"
                }
            },
            {
                field: "TransEndDT",
                title: "输血结束时间",
                width: 160,
                editor: {
                    type: "datetimebox"
                }
            },
            {
                field: "CrossMatching",
                title: "交叉配血",
                width: 100
            },
            {
                field: "MatchingProvDesc",
                title: "配血者",
                width: 80
            },
            {
                field: "GrantProvDesc",
                title: "发血者",
                width: 80
            },
            {
                field: "MatchingDT",
                title: "配血时间",
                width: 160
            },
            {
                field: "FetchProvDesc",
                title: "取血者",
                width: 80
            },
            {
                field: "FetchDT",
                title: "取血时间",
                width: 80
            },
            {
                field: "TransRH",
                title: "RhD",
                width: 80
            },
			{
                field: "Note",
                title: "备注",
                width: 80
            }
        ]
    ];
    var dataForm = new DataForm({
        border:false,
        datagrid: $("#bloodTransBox"),
        gridColumns: columns,
        gridTitle: "",
        gridTool: "#bloodTransTools",
        form: $("#bloodTransForm"),
        modelType: ANCLS.Model.BloodTransRecord,
        queryType: ANCLS.BLL.BloodTransfusion,
        queryName: "FindBloodTransRecord",
        queryParams: {
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        },
        dialog: null,
        addButton: $("#btnAddBloodTrans"),
        editButton: $("#btnEditBloodTrans"),
        //delButton: $("#btnDelBloodTrans"),
        queryButton: null,
        submitCallBack: null,
        onSubmitCallBack: setBloodTransParam,
        openCallBack: null,
        closeCallBack: null,
        datagridSelectCallBack: null
    });
    dataForm.initDataForm();
    //手术清点列表
    $("#bloodTransBox").datagrid({
        // title:"手术输血记录",
        iconCls:"icon-paper",
        headerCls:"panel-header-gray",
        bodyCls:"panel-header-gray",
        border:false,
        onLoadError: function() {},
        onLoadSuccess: function(data) {
            if (data && data.rows && data.rows.length > 0) {
                var bloodTransDescArr = [];
                var bloodTransInfos = [];
                var bloodTransInfoArr = [];
                for (var i = 0; i < data.rows.length; i++) {
                    var dataRow = data.rows[i];
                    var index = bloodTransDescArr.indexOf(dataRow.BloodCategory);
                    if (index > -1) {
                        bloodTransInfos[index].Volume = Number(bloodTransInfos[index].Volume) + Number(dataRow.Volume);
                    } else {
                        bloodTransDescArr.push(dataRow.BloodCategory);
                        bloodTransInfos.push({
                            Desc: dataRow.BloodCategory,
                            Volume: dataRow.Volume,
                            Unit: dataRow.Unit
                        });
                    }
                }

                for (var index in bloodTransInfos) {
                    bloodTransInfoArr.push(bloodTransInfos[index].Desc + " " + bloodTransInfos[index].Volume + bloodTransInfos[index].Unit);
                }

                $("#BloodTransfusion").val(bloodTransInfoArr.join(','));
            }
        },
        onAfterEdit: function(rowIndex, rowData, changes) {
            if (rowData) {
                var transData = {};
                transData.ClassName = ANCLS.Model.BloodTransRecord;
                transData.UpdateUser = session.UserID;
                transData.RowId = rowData.RowId;
                if (rowData.TransStartDT !== "") {
                    var transStartDT = (new Date()).tryParse(rowData.TransStartDT, "yyyy-MM-dd HH:mm:ss");
                    transData.TransStartDate = transStartDT.format("yyyy-MM-dd");
                    transData.TransStartTime = transStartDT.format("HH:mm");
                }
                if (rowData.TransEndDT !== "") {
                    var transEndDT = (new Date()).tryParse(rowData.TransEndDT, "yyyy-MM-dd HH:mm:ss");
                    transData.TransEndDate = transEndDT.format("yyyy-MM-dd");
                    transData.TransEndTime = transEndDT.format("HH:mm");
                }
                dhccl.saveDatas(ANCSP.DataListService, {
                    jsonData: dhccl.formatObjects(transData)
                }, function(data) {
                    if (data.indexOf("S^") === 0) {
                        //$.messager.alert("提示","输血纪录保存成功！","info");
                    } else {
                        //$.messager.alert("提示","输血纪录保存成功！","info");
                    }
                });
            }
        }
    });

    $("#ScanBloodBarCode").keypress(function(e) {
        if (e.keyCode == 13) {
            var barCode = $("#ScanBloodBarCode").val();
			var serCode=$("#ScanBloodSerCode").val();
            addBloodTransfusionNewNew(barCode,serCode);
        }
    });

	$("#ScanBloodSerCode").keypress(function(e) {
        if (e.keyCode == 13) {
            var barCode = $("#ScanBloodBarCode").val();
			var serCode=$("#ScanBloodSerCode").val();
            addBloodTransfusionNewNew(barCode,serCode);
        }
    });

    $("#ScanBloodBarCode").focus(function() {
        try {
            dhcclcomm.OpenCom("COM1", "115200");
            scanCode = "Blood";
            // window.parent.CLCom.receiveData("test");
            // window.parent.CLCom.receiveData(window.addEquipRecord);
        } catch (ex) {
            console.log(ex.message);
        }

    });

    // $("#bloodTransBox").datagrid("enableCellEditing");
    
    $("#btnCheckSign,#btnTransSign").linkbutton({
        onClick: function() {
            if (dhccl.hasRowSelected($("#bloodTransBox"), true)) {
                var selectedRow = $("#bloodTransBox").datagrid("getSelected");
                signCode = $(this).attr("data-signcode");
                /*
				var title="";
                var originalData = JSON.stringify(operDataManager.getOperDatas());
                var CASign=new CASignature({
                    title:title || "",
                    contentData:originalData,
                    signCode:signCode,
                    signBox:"#"+signCode,
                    imgBox:"",
                    afterSignCallBack: reloadBloodTrans
                });
                CASign.open();
				*/
				var toSignData = JSON.stringify(operDataManager.getOperDatas());
                var userCode = session.UserCode;
                var userName = session.UserName;
				var recordSheetId = session.RecordSheetID;
                ca_key.LoginForm({
                    signCode: signCode,
                    userCode: userCode,
                    userName: userName,
                    toSignData: toSignData,
					recordSheetId: recordSheetId,
                    callback: function(cartn){
                        var userCertCode = cartn.userCertCode;
                        var hashData = cartn.hashData;
                        var signedData = cartn.signedData;
                        var certNo = cartn.certNo;
                        
                        if(cartn.account && cartn.pin){
                            //cartn.onAccountSignSuccess();
                            reloadBloodTrans();
                        }else{
                            reloadBloodTrans();
                        }
                    }
                });
            }
        }
    });

    $("#btnPrintBloodTrans").linkbutton({
        onClick: function() {
            printMessage();
        }
    });
	
	$("#btnDelBloodTrans").linkbutton({
        onClick:function(){
            var selectedRow = $("#bloodTransBox").datagrid("getSelected");
            if(!selectedRow)
            {
                $.messager.alert("提示","请先选择一行数据！！")
                return;
            }
            var saveSign = dhccl.runServerMethod(ANCLS.BLL.BloodTransfusion, "DeleteBloodRecord",selectedRow.RowId);
			if(!saveSign.success)
            {
                $.messager.alert("提示","删除失败"+saveSign.result)
                return;
            }
			$("#bloodTransBox").datagrid("reload");
        }
    })
}

var operSchedule;
function loadApplicationData(appData) {
    if(!appData) return;
    operSchedule=appData;
    
}
function addBloodTransfusionNewNew(barCode,serCode) {
    barCode = barCode.replace("=", "");
	if(barCode=="" || serCode=="")
	{
		return;
	}
    dhccl.saveDatas(ANCSP.MethodService, {
        ClassName: ANCLS.BLL.BloodTransfusion,
        MethodName: "GetBloodTransInfo",
        Arg1: session.RecordSheetID,
        Arg2: barCode,
		Arg3: serCode,
        Arg4: session.UserID,
        ArgCnt: 4
    }, function(data) {
		if (data.indexOf("E^") == 0) {
			$.messager.alert("提示",data)
			return
		}
		var jsondata=$.parseJSON( data )
		if(jsondata.length>0)
		{
			var operInfoData = dhccl.formatObjects(jsondata);
			var testItem = dhccl.formatObjects(jsondata[0].TestItem);
			dhccl.saveDatas(ANCSP.MethodService, {
			ClassName: ANCLS.BLL.BloodTransfusion,
			MethodName: "AddBloodTransRecord",
			Arg1: session.RecordSheetID,
			Arg2: barCode,
			Arg3: serCode,
			Arg4: session.UserID,
			Arg5: operInfoData,
			Arg6: testItem,
			ArgCnt: 6
			},function(data){
				if (data.indexOf("S^") == 0) {
					$("#bloodTransBox").datagrid("reload");
					$("#ScanBloodBarCode").val("");
					$("#ScanBloodSerCode").val("");
				} else {
					alert("扫码失败！"+data);
				}

			});

		}
		else
		{
			$.messager.alert("提示","扫码失败，未找到此患者对应的该输血包")
		}
        
    });

    return "test";
}

function setBloodTransParam(param) {
    var transStartDTStr = $("#TransStartDT").datetimebox("getValue"),
        transStartDate = "",
        transStartTime = "";
    if (transStartDTStr && transStartDTStr !== "") {
        var transStartDT = (new Date()).tryParse(transStartDTStr);
        transStartDate = transStartDT.format("yyyy-MM-dd");
        transStartTime = transStartDT.format("HH:mm:ss");
    }

    var transEndDTStr = $("#TransEndDT").datetimebox("getValue"),
        transEndDate = "",
        transEndTime = "";
    if (transEndDTStr && transEndDTStr !== "") {
        var transEndDT = (new Date()).tryParse(transEndDTStr);
        transEndDate = transEndDT.format("yyyy-MM-dd");
        transEndTime = transEndDT.format("HH:mm:ss");
    }
    param.TransStartDate = transStartDate;
    param.TransStartTime = transStartTime;
    param.TransEndDate = transEndDate;
    param.TransEndTime = transEndTime;
    param.RecordSheet = session.RecordSheetID;
    param.UpdateUser = session.UserID;
}

function reloadBloodTrans() {
    var selectedRow = $("#bloodTransBox").datagrid("getSelected");
    var saveSign = dhccl.runServerMethod(ANCLS.BLL.BloodTransfusion, "SaveBloodSignUser",session.RecordSheetID, selectedRow.RowId,signCode);
    signCode=""
    //$.messager.alert("提示","输血纪录保存成功！")
    $("#bloodTransBox").datagrid("reload");
}

function printMessage() {
    var count=operDataManager.printCount(session.RecordSheetID,session.ModuleCode)
    var ifMessage=operDataManager.ifPrintMessage()
    if(ifMessage!="Y"||Number(count)==0) printBloodTransfusion()
    else if(Number(count)>0){
        $.messager.confirm("提示","表单已打印"+count+"次,是否继续打印",function (r)
        {
            if(r)
            {
                printBloodTransfusion()
            } 
        } );
    }
}

function printBloodTransfusion() {
    lodop = getLodop();
    lodop.SET_PRINT_PAGESIZE(1, 0, 0, PrintSetting.Common.Paper);
    operDataManager.reloadPatInfo(loadApplicationData);
    //if (lodop.SET_PRINTER_INDEX(PrintSetting.Common.Printer)) {
        createBloodTransPage(lodop);
        
    //}
}
function createBloodTransPage(lodop) {

    var dataRows = $("#bloodTransBox").datagrid("getRows");
    if (!dataRows || dataRows.length <= 0) {
        $.messager.alert("提示", "没有输血纪录。", "error");
        return;
    }
    var startPos = { x: 10, y: 10 };
    var linePos = { x: startPos.x, y: startPos.y };
    var contentLineHeight = 30,
        titleLineHeight = 40,
        contentLineMargin = 15;

    lodop.ADD_PRINT_TEXT(startPos.y, 300, "100%", 60, session.ExtHospDesc+"临床输血记录单");
    lodop.SET_PRINT_STYLEA(0, "FontName", "黑体");
    lodop.SET_PRINT_STYLEA(0, "FontSize", 16);
    lodop.SET_PRINT_STYLEA(0, "Alignment", 2);
    lodop.SET_PRINT_STYLEA(0, "Horient", 2);

    startPos.y += titleLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+10, 200, 15, "姓名："+(operSchedule?operSchedule.PatName:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+120, 200, 15, "性别："+(operSchedule?operSchedule.PatGender:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+200, 200, 15, "年龄："+(operSchedule?operSchedule.PatAge:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+300, 200, 15, "科室："+(operSchedule?operSchedule.PatDeptDesc:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+460, 200, 15, "床号："+(operSchedule?operSchedule.PatBedCode:""));
    lodop.ADD_PRINT_TEXT(startPos.y, startPos.x+540, 200, 15, "住院号："+(operSchedule?operSchedule.MedcareNo:""));

    startPos.y += titleLineHeight;
    linePos.y = startPos.y + contentLineMargin;
    var firstTransRecord = dataRows[0];
    lodop.ADD_PRINT_TEXT(startPos.y, 20, 200, 15, "受血者血样血型复检结果");

    lodop.ADD_PRINT_TEXT(startPos.y, 220, 200, 15, "血型");
    lodop.ADD_PRINT_LINE(linePos.y, 250, linePos.y, 300, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 260, 40, 15, firstTransRecord.TransABO);
    lodop.ADD_PRINT_TEXT(startPos.y, 300, 200, 15, "型");

    lodop.ADD_PRINT_TEXT(startPos.y, 360, 200, 15, "Rh(D)");
    lodop.ADD_PRINT_LINE(linePos.y, 400, linePos.y, 450, 0, 1);
    lodop.ADD_PRINT_TEXT(startPos.y, 410, 40, 15, firstTransRecord.TransRH);

    //lodop.ADD_PRINT_TEXT(startPos.y, 500, 200, 15, "复检者签名");
    //lodop.ADD_PRINT_LINE(linePos.y, 580, linePos.y, 650, 0, 1);
    //lodop.ADD_PRINT_TEXT(startPos.y, 590, 40, 15, firstTransRecord.TestProvDesc);



    var dataHeader = "<thead><tr><th>储血编码</th><th>血液种类</th><th>血型</th><th>用量</th><th>交叉配血<br>盐水+凝聚胺+镜检</th><th>配血者</th>";
    dataHeader += "<th>发血者</th><th>配血时间</th><th>取血者</th><th>取血时间</th></tr></thead>";
    var tableStyle = "<style>table,td,th {border: 1px solid black;border-style: solid;border-collapse: collapse;font-size:14px;}";
    tableStyle += "th {font-size:16px;font-weight:bold;text-align:center} tr>td {text-align:center} tr {height:24px;} </style>";
    if (dataRows && dataRows.length > 0) {
        for (var i = 0; i < dataRows.length; i++) {
            startPos.y += contentLineHeight;
            linePos.y = startPos.y + contentLineMargin;
            var dataRow = dataRows[i];
            var CXBM=dataRow.BarCode==""?"": dataRow.BarCode + "<br>" + dataRow.ComponentCode + " <strong>" + dataRow.TransABO + " RhD(" + (dataRow.TransRH === "阳性" ? "+" : "-")+")"
            var html = tableStyle + "<table>" + dataHeader + "<tbody><tr>";
            html += "<td>" + CXBM + "</strong>" + "</td>";
            html += "<td>" + dataRow.BloodCategory + "</td>";
            html += "<td style='width:30px;'>" + dataRow.TransABO + "</td>";
            html += "<td>" + dataRow.Volume + dataRow.Unit + "</td>";
            html += "<td>" + dataRow.CrossMatching + "</td>";
            html += "<td>" + dataRow.MatchingProvDesc + "</td>";
            html += "<td>" + dataRow.GrantProvDesc + "</td>";
            html += "<td style='width:80px;'>" + dataRow.MatchingDT + "</td>";
            html += "<td>" + dataRow.FetchProvDesc + "</td>";
            html += "<td style='width:80px;'>" + dataRow.FetchDT + "</td><tr></tbody></table>";
            lodop.ADD_PRINT_TABLE(startPos.y, 10, "100%", "100%", html);
            startPos.y += 90;
            lodop.ADD_PRINT_TEXT(startPos.y, 10, 200, 15, "输血执行者:"+dataRow.ExecProvDesc);
            lodop.ADD_PRINT_TEXT(startPos.y, 190, 200, 15, "核对者:"+dataRow.CheckProvDesc);
            var transStartDTStr = "",
                transEndDTStr = "";
            if (dataRow.TransStartDT !== "") {
                var transStartDT = (new Date()).tryParse(dataRow.TransStartDT, "yyyy-MM-dd HH:mm:ss");
                transStartDTStr = transStartDT.format("yyyy-MM-dd HH:mm");
            }
            if (dataRow.TransEndDT !== "") {
                var transEndDT = (new Date()).tryParse(dataRow.TransEndDT, "yyyy-MM-dd HH:mm:ss");
                transEndDTStr = transEndDT.format("yyyy-MM-dd HH:mm");
            }
            lodop.ADD_PRINT_TEXT(startPos.y, 350, "100%", 15, "输血开始时间:" + transStartDTStr);
            lodop.ADD_PRINT_TEXT(startPos.y, 570, "100%", 15, "输血结束时间:" + transEndDTStr);
        }
    }
    lodop.PREVIEW();
    operDataManager.savePrintLog(session.RecordSheetID,session.ModuleCode,session.UserID);
}
$(document).ready(initPage);