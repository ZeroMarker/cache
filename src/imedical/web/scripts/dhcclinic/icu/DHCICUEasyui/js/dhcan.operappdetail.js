$(document).ready(function() {
    // 加载数据
    loadDatas();
});

function loadDatas() {
    var patInfo = getOperAppInfo();
    //console.log(patInfo);
    setPatBaseInfo(patInfo);
    setApplicationInfo(patInfo);
    setAnaArrangeInfo(patInfo);
    setOperArrangeInfo(patInfo);
}
// 获取病人基本信息
function getOperAppInfo() {
    var opsId = dhccl.getQueryString("opsId");
    var datas = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: dhcan.bll.operSchedule,
        QueryName: "FindOperScheduleList",
        Arg1: "",
        Arg2: "",
        Arg3: "",
        Arg4: opsId,
        ArgCnt: 4
    }, "json")
    result = null;
    if (datas && datas.length > 0) {
        result = datas[0];
    }
    return result;
}

//设置病人基本信息的值
function setPatBaseInfo(patient) {
    var pat = dhccl.getDatas(ANCSP.DataQuery, {
        ClassName: dhccl.bll.admission,
        QueryName: "FindPatient",
        Arg1: patient.EpisodeID,
        ArgCnt: 1
    }, "json");

    $("#PatName").val(patient.PatName); //姓名
    $("#PatDeptDesc").val(patient.PatDeptDesc) //病人科室
    $("#WardBed").val(patient.WardBed) //病区床位
    $("#RegNo").val(patient.RegNo); //登记号
    if (pat && pat.length > 0) {
        $("#AdmReason").val(pat[0].AdmReason); //费别
        $("#PatSecretLevel").val(pat[0].PatSecretLevel); //病人密级
    } else {
        $("#AdmReason").val("");
        $("#PatSecretLevel").val("");
    }

}
//设置手术申请信息
function setApplicationInfo(patient) {
    $("#OperDeptDesc").val(patient.OperDeptDesc); //手术室
    $("#AppDeptDesc").val(patient.AppDeptDesc); //手术类型
    $("#SourceTypeDesc").val(patient.SourceTypeDesc); //手术类型
    $("#OperDate").val(patient.OperDate); //手术日期
    $("#OperTime").val(patient.OperTime); //手术时间
    $("#OperDuration").val(patient.OperDuration); //手术时长
    $("#Anaesthesia").val(function() {
        if (patient.Anaesthesia == "") {
            return "否";
        } else {
            return patient.Anaesthesia;
        }
    }); //是否麻醉
    $("#PrevAnaMethodDesc").val(patient.PrevAnaMethodDesc); //拟施麻醉
    $("#ReentryOperation").val(function() {
        if (patient.ReentryOperation == "") {
            return "否";
        } else {
            return patient.ReentryOperation;
        }
    }); //重返手术
    $("#PrevDiagnosisDesc").val(patient.PrevDiagnosisDesc); //术前诊断
    $("#SurgicalMaterials").val(patient.SurgicalMaterials); //手术物品
    $("#SpecialConditions").val(patient.SpecialConditions); //特殊情况
    $("#Surgeon").val(patient.SurgeonDesc); //主刀医生
    $("#Assistant").val(patient.AssistantDesc); //手术助手
    $("#OperInfo").val(patient.OperInfo); //拟施手术
    $("#IsoOperation").attr("checked", function() {
        if (patient.IsoOperation == "Y") {
            return true;
        } else {
            return false;
        }
    })
    $("#ECC").attr("checked", function() {
        if (patient.ECC == "Y") {
            return true;
        } else {
            return false;
        }
    });
    $("#TransAutoblood").attr("checked", function() {
        if (patient.TransAutoblood == "Y") {
            return true;
        } else {
            return false;
        }
    });
    $("#PrepareBlood").attr("checked", function() {
        if (patient.PrepareBlood == "Y") {
            return true;
        } else {
            return false;
        }
    })
    $("#PlanSeq").val(patient.PlanSeq); //计划台次
    $("#OperRequirement").val(patient.OperRequirement); //手术要求
    $("#BloodType").val(patient.BloodType); //血型
    $("#RHBloodType").val(patient.RHBloodType); //RH血型
    $("#HbsAg").val(patient.HbsAg); //HbsAg
    $("#HcvAb").val(patient.HcvAb);
    $("#HivAb").val(patient.HivAb);
    $("#Syphilis").val(patient.Syphilis);
    $("#LabTest").val(patient.LabTest);
}

//设置麻醉安排信息
function setAnaArrangeInfo(patient) {
    $("#AnaExpert").val(patient.AnaExpertDesc); //麻醉指导
    $("#Anesthesiologist").val(patient.AnesthesiologistDesc); //麻醉医师
    $("#AnaAssistant").val(patient.AnaAssistantDesc); //麻醉助手
}
//设置手术室安排信息
function setOperArrangeInfo(patient) {
    $("#OperRoom").val(patient.RoomDesc); //手术间
    $("#ScrubNurse").val(patient.ScrubNurseDesc); //器械护士
    $("#CircualNurse").val(patient.CircualNurseDesc); //巡回护士
}