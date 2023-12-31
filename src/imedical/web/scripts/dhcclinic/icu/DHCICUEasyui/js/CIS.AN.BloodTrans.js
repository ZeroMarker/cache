$(document).ready(initPage);
function initPage(){
    initInBloodTranstp("N");
    initFunction();
}

function initInBloodTranstp(ret)
{
    var TransItems=dhccl.runServerMethodNormal("CIS.AN.BL.PatTransfer","GetTransItemTime",session.RecordSheetID,"输血交接");
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
            param.Arg1 = "输血交接";
            param.ArgCnt = 1;
        }
    });
    $("#BloodTranstp").empty();
    $("#BloodTranstp").hstep({
        //showNumber:false,
        stepWidth:200,
        currentInd:1,
        onSelect:function(ind,item){console.log(item);},
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
    $("#BloodTranstp").hstep("setStep",Index);
    if(ret=="N")  return
    
    if(retTransItems[1]!=0)
        $.messager.alert("简单提示", "扫码成功！", "info");
    else 
        $.messager.alert("简单提示", "患者未含有交接信息，请选择输血进度后扫码！！", "info");
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
            session.RecordSheetID=dhccl.runServerMethodNormal(ANCLS.BLL.RecordSheet,"GetRecordSheetIdByModCode",session.OPSID,"AN_OPS_008",session.UserID);
            setHeaderParam(data[0]);
            operDataManager.initFormData();
           
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
                    ModuleCode:"AN_OPS_008",   ///暂时先用输血记录表单
                    ClassName:"CIS.AN.PatTransData",
                    OPSID: session.OPSID,
                    Type:"输血交接",
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