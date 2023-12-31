$(document).ready(function() {
    operDataManager.initFormData(loadApplicationData,calcRiskScore);
    initPage();
    operDataManager.setCheckChange();
    calcRiskScore();
    signCommon.loadSignatureCommon();
});

function initPage(){
}
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

function calcRiskScore(){
    var bladeScore=Number($("#OpBladeClean").attr("data-score"));
    var asaClassScore=Number($("#ASAClass").attr("data-score"));
    var durationScore=Number($("#OpDurationTimes").attr("data-score"));
    $("#OpBladeCleanScore").text((bladeScore>0)?bladeScore:0);
    $("#ASAClassScore").text((asaClassScore>0)?asaClassScore:0);
    $("#OpDurationTimesScore").text((durationScore>0)?durationScore:0);
    if(!isNaN(bladeScore) || !isNaN(asaClassScore) || !isNaN(durationScore)){
        $("#SumScore").text(((!isNaN(bladeScore)?bladeScore:0)+(!isNaN(asaClassScore)?asaClassScore:0)+(!isNaN(durationScore)?durationScore:0)));
    }else{
        $("#SumScore").text("");
    }
    $("#RiskScore").val($("#SumScore").text());
}

var operSchedule;
function loadApplicationData(appData) {
    if(!appData) return;
    operSchedule=appData;
}
