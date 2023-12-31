$(document).ready(initPage);
function initPage(){
	dhccl.parseDateTimeFormat();
    initInBloodTranstp("N");
    initFunction();
    SignTool.loadSignature();
    operDataManager.setCheckChange();
    initPermission(true) ;
}

function initInBloodTranstp(ret)
{
    
    var TransItems=dhccl.runServerMethodNormal("CIS.AN.BL.PatTransfer","GetTransItemTime",session.RecordSheetID,"手术交接");
    var retTransItems=TransItems.split("^")
    var TransItemsFormData = JSON.parse(retTransItems[0])
    var Index=+retTransItems[1]
    $("#PatLocation").combobox({
        valueField: "RowId",
        textField: "Description",
        url: ANCSP.DataQuery,
        onBeforeLoad: function(param) {
            param.ClassName = ANCLS.BLL.CodeQueries;
            param.QueryName = "FindPatTransLocation";
            param.Arg1 = "手术交接";
            param.ArgCnt = 1;
        }
    });
    $("#PatTranstp").empty();
    $("#PatTranstp").hstep({
        //showNumber:false,
        stepWidth:200,
        currentInd:1,
        onSelect:function(ind,item){
            $('.shaft-detail-cont').eq(ind-1).show().siblings().hide();
        },
        //titlePostion:'top',
        /*
        items:[{
                title:'输血科取血',
                context:"<div>王二</div><div>2020-07-03 09:10</div>"
            },{
                title:'输血交接',
                context:"<div>张三</div> 2020-07-03 10:10"
            },{
                title:"输血完成", 
                context:"<div>李四</div> 2020-07-03 11:10"
            }],*/
        items:TransItemsFormData
    });
    $("#PatTranstp").hstep("setStep",Index);
    if(ret=="N")  return
    if(Index==0) $('.shaft-detail-cont').eq(0).show().siblings().hide();
    else  $('.shaft-detail-cont').eq(Index-1).show().siblings().hide();
    if(retTransItems[1]!=0)
        $.messager.alert("简单提示", "扫码成功！", "info");
    else 
        $.messager.alert("简单提示", "患者未含有交接信息，请选择病人位置后扫码！！", "info");
}
function initPermission(Permission)
{
    if(Permission)
    {
        $("input").attr('readonly', true); 
        $(':checkbox').attr('disabled', true);
        $('.hisui-triggerbox').triggerbox('disable')
    }
    else
    {
        $("input").attr('readonly', false);   
        $(':checkbox').attr('disabled', false);
        $('.hisui-triggerbox').triggerbox('enable')
    }
    $('#ScanNo').attr('readonly', false);   
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
            }, "json");
            if (data.length < 1) {
                $.messager.alert("提示", "病人信息未能识别，请重新扫码！！", "error");
                return;
            }
           // $.messager.alert("简单提示", "扫码成功！", "info");
           
            banner.loadData(data[0]);
            session.OPSID=data[0].OPSID;
            session.RecordSheetID=dhccl.runServerMethodNormal(ANCLS.BLL.RecordSheet,"GetRecordSheetIdByModCode",session.OPSID,"AN_OPS_002",session.UserID);
            SignTool.loadSignature();
            setHeaderParam(data[0]);
            operDataManager.initFormData();
            initPermission(false);
            
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
                    ModuleCode:"AN_OPS_002",   ///暂时先用输血记录表单
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
                    initInBloodTranstp("N");
                    return;
                }
            }
            initInBloodTranstp("R");   
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