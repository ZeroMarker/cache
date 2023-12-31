$(document).ready(function() {
    initPage();
    initFunction();
    
});

function initPage()
{
     // 时间轴
	var timerNum = 0;
	var space = 210; // 移动间距
	var length = $('.timer-scale-cont').length, numL;
	// 分辨率
	if(window.screen.width > 1500) {
		numL = length - 4
	} else if(window.screen.width < 1500) {
		numL = length - 3
	}
	// 点击左侧
	$('.timer-left').on('click', function () {
		if(timerNum > 0) {
			timerNum -= 1;
			moveL(timerNum, numL)
		}
		tags(timerNum);
	})
	// 点击右侧
	$('.timer-right').on('click', function () {
		if(timerNum < length - 1) {
			timerNum += 1;
			tags(timerNum);
		}
		moveL(timerNum, numL)
	})
	// 点击节点
	$('.time-circle').each(function (index) {
		$(this).on('click', function () {
			timerNum = index;
			//moveL(timerNum, numL)
			tags(timerNum);
		})
	})
	function tags(num){
        $('.timer-scale-cont').eq(num).addClass('hov').siblings().removeClass('hov');
        $('.timer-scale-cont').eq(num).class=".timer-scale-cont hov"
		$('.shaft-detail-cont').eq(num).show().siblings().hide();
	}
	function moveL(num, len) {
		if (num < len) {
			moveLeft = -num * space;
			$('.timer-scale').animate({left:moveLeft}, 700);
		}
    }

    $("#PatLocation").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        // queryParams: {
        //     ClassName: ANCLS.BLL.CodeQueries,
        //     QueryName: "FindLegends",
        //     Arg1: "",
        //     ArgCnt: 1
        // }
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindPatTransLocation";
            param.Arg1 = "手术交接";
            param.ArgCnt = 1;
        }
    });

}

function initFunction()
{
    var station = {
        selectedRecord: null,
        banner: null
    };

    $("#ScanNo").keypress(function(e){
        if(e.keyCode===13){
            if ($("#ScanNo").val() == "") {
                $.messager.alert("提示", "请输入正确信息！！", "error");
                return;
            }
            var banner = operScheduleBanner.init('#patinfo_banner', {});
            station.banner = banner;
            var data = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: "CIS.AN.BL.PatTransfer",
                QueryName: 'FindOperScheduleList',
                Arg1: "",
                Arg2: "",
                Arg3: session.DeptID,
                Arg4: "",
                Arg5: "",
                Arg6: "",
                // param.Arg7 = "Application^Audit^Arrange^RoomIn^RoomOut^PACUIn^Finish^AreaOut^Stop^Accept";
                Arg7: "Arrange^RoomIn^RoomOut^PACUIn^Finish^AreaOut",
                Arg8: "",
                Arg9: $("#ScanNo").val(),
                //param.Arg9 ="";
                 Arg10: "",
                Arg11: "N",
                ArgCnt: 11
            }, "json",);
            if (data.length < 1) {
                $.messager.alert("提示", "病人信息未能识别，请重新扫码！！", "error");
                return;
            }
            $.messager.alert("简单提示", "扫码成功！", "info");
            banner.loadData(data[0]);
            session.OPSID=data[0].OPSID;
            session.RecordSheetID=dhccl.runServerMethodNormal(ANCLS.BLL.RecordSheet,"GetRecordSheetIdByModCode",session.OPSID,"AN_OPS_002",session.UserID);
            setHeaderParam(data[0]);
            operDataManager.initFormData();
           
            var Transdata = dhccl.getDatas(ANCSP.DataQuery, {
                ClassName: "CIS.AN.BL.PatTransfer",
                QueryName: 'FindPatTransTime',
                Arg1: session.RecordSheetID,
                ArgCnt: 1
            }, "json",);
            if (Transdata.length > 0) {
               for(i=0; i<Transdata.length;i++)
               {
                    switch(Transdata[i].PatLocation)
                    {
                        case "patWard":
                            $('#patWard').text(Transdata[i].ScanDate+" "+Transdata[i].ScanTime);
                            $('#'+Transdata[i].PatLocation+"Item").removeClass("gray");
                            break;
                        case "OperLoc":
                            $('#OperLoc').text(Transdata[i].ScanDate+" "+Transdata[i].ScanTime);
                            $('#'+Transdata[i].PatLocation+"Item").removeClass("gray");
                            break;
                        case "OperRoom":
                            $('#OperRoom').text(Transdata[i].ScanDate+" "+Transdata[i].ScanTime);
                            $('#'+Transdata[i].PatLocation+"Item").removeClass("gray");
                            break;
                        case "PACURoom":
                            $('#PACURoom').text(Transdata[i].ScanDate+" "+Transdata[i].ScanTime);
                            $('#'+Transdata[i].PatLocation+"Item").removeClass("gray");
                            break;
                        case "WardICU":
                            $('#WardICU').text(Transdata[i].ScanDate+" "+Transdata[i].ScanTime);
                            $('#'+Transdata[i].PatLocation+"Item").removeClass("gray");
                            break;
                    }
               }
            }

            if($("#PatLocation").combobox("getValue")!="")
            {
                var myDate = new Date;
                var year = myDate.getFullYear(); //获取当前年
                var mon = myDate.getMonth() + 1; //获取当前月
                var date = myDate.getDate(); //获取当前日
                var h = myDate.getHours();//获取当前小时数(0-23)
                var m = myDate.getMinutes();//获取当前分钟数(0-59)
                // var s = myDate.getSeconds();//获取当前秒
                var Scandate=year + "-" + mon + "-" + date;
                var Scantime=h + ":" + m;
                var ScanDateTime=Scandate+" "+Scantime

                var SaveTransTimeInfo = [];
                var SaveTransTime = {
                    RecordSheet:session.RecordSheetID,
                    PatLocation:$("#PatLocation").combobox("getValue"),
                    ScanDate:Scandate,
                    ScanTime:Scantime,
                    ModuleCode:"AN_OPS_002",
                    ClassName:"CIS.AN.PatTransData",
                    OPSID: session.OPSID,
                    Type:"手术交接",
                    UpdateUserID:session.UserID
                };
                SaveTransTimeInfo.push(SaveTransTime);
                var SaveTransTimeFormData = dhccl.formatObjects(SaveTransTimeInfo);
                var saveRet = dhccl.runServerMethod("CIS.AN.BL.PatTransfer", "SavePatTransTime",SaveTransTimeFormData);
                var sss=$("#PatLocation").combobox("getText")
                if(saveRet.result!="")
                {
                    $.messager.alert("简单提示", "保存交接时间失败，"+saveRet.result, "info");
                    return;
                }

                switch($("#PatLocation").combobox("getText"))
                {
                    case "病区":
                        $('#patWard').text(ScanDateTime);
                        $('#patWardItem').removeClass("gray");
                         break;
                    case "手术室":
                        $('#OperLoc').text(ScanDateTime);
                        $('#OperLocItem').removeClass("gray");
                         break;
                    case "手术间":
                        $('#OperRoom').text(ScanDateTime);
                        $('#OperRoomItem').removeClass("gray");
                        break;
                    case "恢复室":
                        $('#PACURoom').text(ScanDateTime);
                        $('#PACURoomItem').removeClass("gray");
                        break;
                    case "病区/ICU":
                        $('#WardICU').text(ScanDateTime);
                        $('#WardICUItem').removeClass("gray");
                        break;
                }
            }
            else if(Transdata.length<1)
            {
                $.messager.alert("简单提示", "请先选择病区，再扫码！！", "info");
                return;
            }
            $("#btnFullScreen").hide();
            $("#btnOperList").hide();
            $("#btnSave").show();
        }
    });

    $("#btnSave").linkbutton({
        onClick: function() {
            saveOperDatas();
        }
    });
}

function saveOperDatas(selector,extDatas) {
    var operDataSelector = (selector && selector != "") ? selector : ".operdata";
    var hasExtDatas=(extDatas && extDatas.length && extDatas.length>0);
    var operDatas = getFormOperDatas(operDataSelector);
    var hasOperDatas=(operDatas && operDatas.length && operDatas.length>0);
    if (!hasOperDatas && !hasExtDatas) return;
    var operDataPara="",extDataPara="";
    if(hasOperDatas){
        operDataPara=dhccl.formatObjects(operDatas);
    }
    if(hasExtDatas){
        extDataPara=dhccl.formatObjects(extDatas);
    }
    var saveRet=dhccl.runServerMethodNormal(ANCLS.BLL.OperData,"SaveOperDatas",operDataPara,extDataPara);
    dhccl.showMessage(saveRet, "保存", null, null, function() {
        var operDatas = operDataManager.getOperDatas();
        operDataManager.setFormOperDatas(operDatas);
    });
}

function getFormOperDatas (clsSelector) {
    var valueArr = [];
    var dataValue = null;
    var operDatas = [];
    $(clsSelector).each(function(index, el) {
        valueArr.length = 0;
        dataValue = null;
        var selector = "#" + $(el).attr("id");
        var enabled = operDataManager.getControlAbleStatus($(selector));
        if (enabled === false) return;
        var checkSelector = "input[data-formitem='" + $(el).attr("id") + "']";
        if ($(checkSelector).length > 0) {
            var controlEnabled;
            $(checkSelector).each(function(checkInd, checkItem) {
                enabled = operDataManager.getControlAbleStatus($(checkItem));
                if (enabled === false)
                {
                    controlEnabled=false;
                    return;
                }
                var checkValue = false;
                if ($(checkItem).hasClass("hisui-checkbox")) {
                    checkValue = $(checkItem).checkbox("getValue");
                } else if ($(checkItem).hasClass("hisui-radio")) {
                    checkValue = $(checkItem).radio("getValue");
                }
                if (!checkValue) return;
                if (valueArr.length > 0) valueArr.push(splitchar.comma);
                var curLabel = $(checkItem).attr("label");
                if (!curLabel || curLabel === "") {
                    curLabel = $(checkItem).attr("value");
                }
                
                valueArr.push(curLabel);
            });
            if(controlEnabled===false) return;
            dataValue = valueArr.join(splitchar.empty);
        } else {
            dataValue = operDataManager.getControlValue($(el));
        }
        var dataControl=$(selector).attr("data-control");
        if(dataControl && dataControl==="N"){
            dataValue=$(selector).attr("data-value");
        }
        var dataScore = $(el).attr("data-score");
        var operDataId = $(el).attr("data-rowid");
        // 如果不是已保存过的数据，且数据值或分数值为空，那么不保存
        if ((!operDataId || operDataId === "") && (!dataValue || dataValue === "") && (!dataScore || dataScore === "")) return;
        operDatas.push({
            RowId: $(el).attr("data-rowid"),
            RecordSheet: session.RecordSheetID,
            DataItem: $(el).attr("id"),
            DataValue: dataValue,
            UpdateUserID: session.UserID,
            ModuleCode:"AN_OPS_002",
            ClassName: ANCLS.Model.OperData,
            DataScore: dataScore ? dataScore : "",
            OPSID: session.OPSID
        });
    });

    return operDatas;
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
