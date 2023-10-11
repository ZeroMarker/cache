/**
 * @author SongChao
 * @version 20180619
 * @description 标本采集时间js
 */
var GV = {
    _CLASSNAME: "Nur.HISUI.SpecManage"
};

var init = function () {
    initEvent();
}
$(init)

function initEvent() {
    $('#updateBtn').bind('click', updateBtnClick);
    $('#labNo').bind('keydown', function (e) {
        if (e.keyCode == 13) {
            updateBtnClick();
        }
    });
}
/*----------------------------------------------------------------------------------------------------------*/
/**
 * @description 采血时间更新按钮
 */
function updateBtnClick() {
	clearSpecInfo();
    var LabEpisodeNo = $('#labNo').val();
    if (LabEpisodeNo !== "") {
        $('#labNoRead').val(LabEpisodeNo);
        var UserID = session['LOGON.USERID'];
		var WardID= session['LOGON.WARDID'];
        $cm({
            ClassName: GV._CLASSNAME,
            MethodName: "updateCollDateTime",
            LabEpisodeNo: LabEpisodeNo,
            UserID: UserID,
			WardID: WardID
        }, function (jsonData) {
            if (String(jsonData.success) === "0") {
                setSpecInfo(jsonData);
            }
            else {
                $.messager.alert("错误提示", jsonData.errInfo, "info");
            }
        });
    } else {
        $.messager.popover({ msg: '条码号为空!', type: 'alert' });
    }
}
/**
 * @description  采血时间置成功后,设置页面相关标本信息
 * @param {*} jsonData
 */
function setSpecInfo(jsonData) {
    $("#retLabNo").val(jsonData.labNO);
    $("#retSpecName").val(jsonData.specName);
    $("#retBedCode").val(jsonData.bedCode);
    $("#retArcim").val(jsonData.arcim);
    $("#retPatName").val(jsonData.patName);
    $("#retRegNo").val(jsonData.regNo);
    $("#retCollDateTime").val(jsonData.collDateTime);
    $("#retPatSex").val(jsonData.patSex);
    $("#retPatAge").val(jsonData.patAge);
    $("#retOrdNote").val(jsonData.ordNote);
    //$("#retContainerColor").val(jsonData.containerColor);
	$("#retContainerColor").css("background-color",jsonData.containerColor);
	//$("#retContainerColor").css("color","white !important;");
    $("#retContainerName").val(jsonData.containerName);
    $("#retDoctor").val(jsonData.doctor);
    $("#retSttDateTime").val(jsonData.sttDateTime);
    $("#retExecNurse").val(jsonData.execNurse);
	if ("C"==jsonData.execState){
		$("#userName").html("撤销人");
		$("#oeordStat").html("医嘱撤销")
	}
    setStepInfo(jsonData.stepInfo);
}


/**
 * @description  设置步骤条信息
 * @param {*} jsonData
 */
function setStepInfo(jsonData) {
    //ordDoctor="",ordDateTime="",sttDateTime="",
    //printUser="",printDateTime="",execNurse="",execDateTime="",collUser="",collDateTime=""
    $("#stepOrderDoctor").html(jsonData.ordDoctor);
    $("#stepOrderTime").html(jsonData.ordDateTime);
    $("#stepExecDoctor").html(jsonData.ordDoctor);
    $("#stepSttDateTime").html(jsonData.sttDateTime);
    if (jsonData.printUser != "") $("#stepPrintUser").html(jsonData.printUser);
    if (jsonData.printDateTime != "") $("#stepPrintDateTime").html(jsonData.printDateTime);
    if (jsonData.execNurse != "") $("#stepExecNurse").html(jsonData.execNurse);
    if (jsonData.execDateTime != "") $("#stepExecDateTime").html(jsonData.execDateTime);
    if (jsonData.collUser != "") $("#stepCollUser").html(jsonData.collUser);
    if (jsonData.collDateTime != "") $("#stepCollDateTime").html(jsonData.collDateTime);
}


/**
 * @description  清空步骤条信息
 */
function clearStepInfo() {
    $("#stepOrderDoctor").html("");
    $("#stepOrderTime").html("");
    $("#stepExecDoctor").html("");
    $("#stepSttDateTime").html("");
    $("#stepPrintUser").html("");
    $("#stepPrintDateTime").html("");
    $("#stepExecNurse").html("");
    $("#stepExecDateTime").html("");
    $("#stepCollUser").html("");
    $("#stepCollDateTime").html("");
}

/**
 * @description 清空页面相关标本信息
 */
function clearSpecInfo() {
    $("#retLabNo").val("");
    $("#retSpecName").val("");
    $("#retBedCode").val("");
    $("#retArcim").val("");
    $("#retPatName").val("");
    $("#retRegNo").val("");
    $("#retCollDateTime").val("");
    $("#retPatSex").val("");
    $("#retPatAge").val("");
    $("#retOrdNote").val("");
    $("#retContainerColor").val("");
    $("#retContainerName").val("");
    $("#retDoctor").val("");
    $("#retSttDateTime").val("");
    $("#retExecNurse").val("");
	clearStepInfo();
}