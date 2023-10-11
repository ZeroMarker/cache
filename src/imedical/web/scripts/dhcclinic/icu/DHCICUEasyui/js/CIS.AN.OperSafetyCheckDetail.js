$(document).ready(function() {
    operDataManager.initFormData(loadApplicationData);
    initPage();
    operDataManager.setCheckChange();
    signCommon.loadSignatureCommon();
    $(".hisui-triggerbox").triggerbox("disable");
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
   
}

var operSchedule;
function loadApplicationData(appData) {
    if(!appData) return;
    operSchedule=appData;
    
}