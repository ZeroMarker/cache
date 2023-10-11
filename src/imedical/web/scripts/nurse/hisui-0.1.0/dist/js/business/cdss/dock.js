/*
 * @Descripttion: 护理病历对接惠美cdss
 * @Author: yaojining
 * @Date: 2022-06-23
 */
var maysonvte="";
function initCdssData(EpisodeID) {
    try {
        if ((!EpisodeID) || (typeof HM == 'undefined')) {
            return;
        }
        $cm({
            ClassName: 'NurMp.Service.CDSS.Main',
            MethodName: 'GetPatBasicInfo',
            EpisodeID: EpisodeID
        }, function (info) {
            var autherEntity = {
                "autherKey": info.autherKey,
                "userGuid": info.regNo,
                "serialNumber": EpisodeID,
                "doctorGuid": session["LOGON.USERID"],
                "doctorName": session["LOGON.USERNAME"],
                "inpatientDepartment": session['LOGON.CTLOCDESC'],
                "inpatientDepartmentId": info.locCode,
                "hospitalGuid": session['LOGON.HOSPID'],
                "hospitalName": session['LOGON.HOSPDESC'],
                "customEnv": info.visitType,
                "flag": info.verflag
            };
            var CurrNurMPDataID = "";
            var queryArray = GetQueryObject();
            if (!!queryArray["NurMPDataID"]) CurrNurMPDataID = queryArray["NurMPDataID"];
            if ((CurrNurMPDataID == undefined) || (CurrNurMPDataID == null)) CurrNurMPDataID = "";
            var vteBean = tkMakeServerCall("NurMp.Service.CDSS.Main", "getNurseVTEInfo", EpisodeID, CurrNurMPDataID, window.TemplateIndentity, session["LOGON.USERID"], "1","1");
            //页面初始化
            HM.maysonLoader(autherEntity, function (mayson) {
                mayson.setDrMaysonConfig(info.verflag, 1);
                maysonvte = mayson;
                if (maysonvte != "") {
                    maysonvte.setMaysonBean(eval("(" + vteBean + ")"));
                    maysonvte.ai();
                }
                maysonvte.listenViewData = function (data) {
                    if (data) {
                        for (var i = 0; i < data.length; i++) {
                            var perData = data[i];
                            if (perData.types == 11) {     //惠每文献，返回URL路径
                                if (perData.items) {
                                    for (var j = 0; j < perData.items.length; j++) {
                                        window.open(perData.items[j].text);
                                    }
                                }
                            } else {    //文献外的类型，直接做回显处理
                                if (perData.items) {
                                    for (var j = 0; j < perData.items.length; j++) {
                                        window.alert(perData.items[j].text);
                                    }
                                }
                            }
                        }
                    }
                };
            });
        });
    } catch (err) {
        maysonvte = "";
    }
}
function getCdssInfoForInPatient(episodeID, EmrId, EmrCode) {
    try {
        if (!!maysonvte) {
            var vteBean = tkMakeServerCall("NurMp.Service.CDSS.Main", "getNurseVTEInfo", episodeID, EmrId, EmrCode, session["LOGON.USERID"]);
            maysonvte.setMaysonBean(eval("(" + vteBean + ")"));
            maysonvte.ai();
        }
    } catch (err) {
        console.log(err)
    }
}
