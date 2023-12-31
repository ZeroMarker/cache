$(document).ready(function() {
    dhccl.parseDateTimeFormat();
    operDataManager.initFormData(loadPatInfo,refreshAssessmentResults);
    operDataManager.setCheckChange();
    initPage();
    initDefaultValue();
    SignTool.loadSignature();
});

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

function initPage(){
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
            //window.location.reload();
        }
    });

    $("#PressureSore1,#PressureSore2").checkbox({
        onChecked: function() {
            var hasPressureSore = $(this).attr('id') === "PressureSore2";
            if (hasPressureSore) {
                $(".pressurescore-description").show();
            } else {
                $(".pressurescore-description").hide();
            }
        }
    });
    
    $(".assess-form").find(".hisui-radio").checkbox({
        onChecked: refreshAssessmentResults
    });
    
    $(".assess-form").find(".hisui-checkbox").checkbox({
        onChecked: refreshAssessmentResults,
        onUnChecked: refreshAssessmentResults
    });
}

var assessmentResultList = {
    scattTrigger: [{
        range: {
            min: 0,
            max: 1
        },
        result: "低风险"
    }, {
        range: {
            min: 2,
            max: 4
        },
        result: "高风险"
    }],
    preoper: [{
        range: {
            min: 0,
            max: 6
        },
        result: "低风险"
    }, {
        range: {
            min: 7,
            max: 14
        },
        result: "中风险"
    }, {
        range: {
            min: 15,
            max: 21
        },
        result: "高风险"
    }],
    inoper: [{
        range: {
            min: 0,
            max: 13
        },
        result: "低风险"
    }, {
        range: {
            min: 14,
            max: 24
        },
        result: "中风险"
    }, {
        range: {
            min: 25,
            max: 39
        },
        result: "高风险"
    }],
    postoper: [{
        range: {
            min: 0,
            max: 15
        },
        result: "低风险"
    }, {
        range: {
            min: 16,
            max: 28
        },
        result: "中风险"
    }, {
        range: {
            min: 29,
            max: 45
        },
        result: "高风险"
    }]
}


function refreshAssessmentResults() {
    var scattTriggerAssessmentScore = 0;
    $.each($('#ScattTrigger_form').find("input"), function(index, e) {
        if ($(this).prop('checked')) {
            var score = Number($(this).attr('data-score'));
            scattTriggerAssessmentScore = scattTriggerAssessmentScore + score;
        }
    });

    $("#ScattTriggerResult").val(getAssessmentResult(assessmentResultList.scattTrigger, scattTriggerAssessmentScore));

    var preoperAssessmentScore = 0;
    var inoperAssessmentScore = 0;
    var postoperAssessmentScore = 0;
    $.each($('#preoperassess_form').find("input"), function(index, e) {
        if ($(this).prop('checked')) {
            var score = Number($(this).attr('data-score'));
            preoperAssessmentScore = preoperAssessmentScore + score;
            inoperAssessmentScore = inoperAssessmentScore + score;
            postoperAssessmentScore = postoperAssessmentScore + score;
        }
    });
    $.each($('#inoperassess_form').find("input"), function(index, e) {
        if ($(this).prop('checked')) {
            var score = Number($(this).attr('data-score'));
            inoperAssessmentScore = inoperAssessmentScore + score;
            postoperAssessmentScore = postoperAssessmentScore + score;
        }
    });
    $.each($('#postoperassess_form').find("input"), function(index, e) {
        if ($(this).prop('checked')) {
            var score = Number($(this).attr('data-score'));
            postoperAssessmentScore = postoperAssessmentScore + score;
        }
    });

    $("#PreOperAssessmentResult").val(preoperAssessmentScore + "分 ~ " + getAssessmentResult(assessmentResultList.preoper, preoperAssessmentScore));
    $("#InOperAssessmentResult").val(inoperAssessmentScore + "分 ~ " + getAssessmentResult(assessmentResultList.inoper, inoperAssessmentScore));
    $("#PostOperAssessmentResult").val(postoperAssessmentScore + "分 ~ " + getAssessmentResult(assessmentResultList.postoper, postoperAssessmentScore));

}

function getAssessmentResult(resultList, score) {
    var length = resultList.length;
    var item;
    for (var i = 0; i < length; i++) {
        item = resultList[i];
        if (score >= item.range.min && score <= item.range.max) {
            return item.result;
        }
    }

    return "";
}

function loadPatInfo(appData) {
    if(!appData) return;
    $.each($("#patientInfo").find(".form-item"), function(index, item) {
        var field = $(item).attr('id');
        $(item).text(appData[field] || '');
    });
    $("#MedcareNo").text(appData.MedcareNo);
}

function initDefaultValue(){
    var pressureSoreList=dhccl.runServerMethod(ANCLS.BLL.OperData,"GetPressureSoreData",session.OPSID);
    if(pressureSoreList && pressureSoreList.length>0){
        var pressureSoreData=pressureSoreList[0];
        var ageNum=Number(pressureSoreData.AgeNum);
        if(ageNum>62){
            $("#GT62CHK1").checkbox("setValue",true);
        }else{
            $("#GT62CHK2").checkbox("setValue",true);
        }
        if(ageNum<=39){
            $("#PatientAgeCHK1").checkbox("setValue",true);
        }else if(ageNum>=40 && ageNum<=59){
            $("#PatientAgeCHK2").checkbox("setValue",true);
        }else if(ageNum>=60){
            $("#PatientAgeCHK3").checkbox("setValue",true);
        }

        var BMI=Number(pressureSoreData.BMI);
        if(BMI<19 || BMI>40){
            $("#BMICHK1").checkbox("setValue",true);
        }else{
            $("#BMICHK2").checkbox("setValue",true);
        }
        if(BMI<30){
            $("#BMISelectorCHK1").checkbox("setValue",true);
        }else if(BMI>=30 && BMI<=35){
            $("#BMISelectorCHK2").checkbox("setValue",true);
        }else if(BMI>35){
            $("#BMISelectorCHK3").checkbox("setValue",true);
        }

        var ASAClass=pressureSoreData.ASAClass;
        switch(ASAClass){
            case "P1":
                $("#ASALevel1").checkbox("setValue",true);
                break;
            case "P2":
                $("#ASALevel2").checkbox("setValue",true);
                break;
            case "P3":
                $("#ASALevel3").checkbox("setValue",true);
                break;
            case "P4":
                $("#ASALevel4").checkbox("setValue",true);
                break;
            case "P5":
            case "P6":
                $("#ASALevel5").checkbox("setValue",true);
                break;
        }

        var operDuration=pressureSoreData.OperDuration;
        switch(operDuration){
            case "T1":
                $("#EstimateOperTimeCHK1").checkbox("setValue",true);
                break;
            case "T2":
                $("#EstimateOperTimeCHK2").checkbox("setValue",true);
                break;
        }

        var bleedingVolume=Number(pressureSoreData.BleedingVolume);
        if (bleedingVolume<200){
            $("#BloodLossCHK1").checkbox("setValue",true);
        }else if(bleedingVolume>=200 && bleedingVolume<=400){
            $("#BloodLossCHK2").checkbox("setValue",true);
        }else if(bleedingVolume>400){
            $("#BloodLossCHK3").checkbox("setValue",true);
        }

        if(pressureSoreData.OperDurationHours){
            var durationHours=Number(pressureSoreData.OperDurationHours);
            if(durationHours<=2){
                $("#OperTimeCHK1").checkbox("setValue",true);
            }else if(durationHours>2 && durationHours<4){
                $("#OperTimeCHK2").checkbox("setValue",true);
            }else if(durationHours>=4){
                $("#OperTimeCHK3").checkbox("setValue",true);
            }
        }
    }
}