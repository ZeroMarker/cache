$(document).ready(function() {
    operDataManager.initFormData(loadPatInfo,refreshAssessmentResults);
    initPage();
    operDataManager.setCheckChange();
    signCommon.loadSignature();
});

function initPage(){
    $("#btnSave").linkbutton({
        onClick: function() {
            operDataManager.saveOperDatas();
            //window.location.reload();
        }
    });

    $("#btnVisitNurseSign,#btnAssessmentNurseSign").linkbutton({
        onClick:function(){
            var signCode = $(this).attr("data-signcode");
            var originalData = JSON.stringify(operDataManager.getOperDatas());
            var signView = new SignView({
                container: "#signContainer",
                originalData: originalData,
                signCode: signCode
            });
            signView.initView();
            signView.open();
        }
    });

    $("#PressureSore1,#PressureSore2").radio({
        onChecked: function() {
            var hasPressureSore = $(this).attr('id') === "PressureSore2";
            if (hasPressureSore) {
                $(".pressurescore-description").show();
            } else {
                $(".pressurescore-description").hide();
            }
        }
    });
    
    $(".assess-form").find(".hisui-radio").radio({
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