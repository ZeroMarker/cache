var timestampOld = 0;
var timestampNow = 0;
var TriggerDHCDSS = null;
function CDSSDH() {
    this.init = function (data) {
        try {
            //初始化患者
            TriggerDHCDSS = parent.TriggerDHCDSS || parent.parent.TriggerDHCDSS || (window.parent.document.getElementById('cdss_iframe') ? window.parent.document.getElementById('cdss_iframe').contentWindow.TriggerDHCDSS : "");
            if (TriggerDHCDSS) {
                if (data.args.loadType == 1) {
                    try {
                        TriggerDHCDSS("INITIALIZE_PATIENT_INFORMATION", data.message);
                    } catch (err) {
                        cdssLock = "N";
                        HISAlert("东华CDSS接口调用出错,联系CDSS开发检查接口", "提示信息");
                    }
                }
                return
            }
            this.initData = data.message;
        } catch (err) {
            cdssLock = "N";
            HISAlert("初始化接口出错,检查病历CDSSDH文件-init接口", "提示信息");
        }
    };
    this.getData = function (param, actionType) {
        timestampNow = (new Date()).getTime();
        if (timestampNow - timestampOld < 500) return
        timestampold = timestampNow;
        var _this = this;
        var action = actionType.toUpperCase();
        var instanceId = param.id;
        if (!instanceId) {
            return
        }
        var emrDocId = param.emrDocId
        if (!emrDocId) {
            emrDocId = "";
        }
        var paramter = "AEpisodeID:" + episodeID + ",AUserID:" + userID + ",AUserLocID:" + userLocID + ",ADocID:" + emrDocId + ",AInstanceID:" + instanceId + ",AAction:" + action + ",AType:" + episodeType + ",ACdssTool:CDSSDH"
        jQuery.ajax({
            type: "post",
            dataType: "json",
            url: '../EMRservice.BOCDSSService.cls',
            async: false,
            data: {
                "action": "GetCDSSData",
                "param": paramter
            },
            success: function (data) {
                if (data.success == 1) {
                    if (!TriggerDHCDSS) {
                        TriggerDHCDSS = parent.TriggerDHCDSS || parent.parent.TriggerDHCDSS || (window.parent.document.getElementById('cdss_iframe') ? window.parent.document.getElementById('cdss_iframe').contentWindow.TriggerDHCDSS : "");
                        if (TriggerDHCDSS) {
                            try {
                                TriggerDHCDSS("INITIALIZE_PATIENT_INFORMATION", _this.initData);
                            } catch (err) {
                                cdssLock = "N";
                                HISAlert("东华CDSS初始化接口调用出错,联系CDSS开发检查初始化接口", "提示信息");
                            }
                        } else {
                            HISAlert("没有获取到东华CDSS-TriggerDHCDSS接口，联系开发确认CDSS服务正常!", "提示信息");
                            return
                        }
                    }
                    try {
                        if (action === "DELETE") {
                            TriggerDHCDSS("DELETE_MEDICAL_RECORD_INFORMATION", data.message);
                        } else {
                            TriggerDHCDSS("SAVE_MEDICAL_RECORD_INFORMATION", data.message);
                        }
                    } catch (err) {
                        cdssLock = "N";
                        HISAlert("东华CDSS数据传输接口调用出错，联系CDSS开发确认接口正常！", "提示信息");
                    }

                } else {
                    if (environment === "TEST") {
                        HISAlert("取病历数据出错：" + (data.message || data), "提示信息");
                    }
                }
            },
            error: function (d) { cdssLock = "N"; HISAlert("取病历数据出错，检查数据配置，查看调试接口", "提示信息"); }
        });
    }
}
//数据回写
function receive(data) {
	
	//判定浏览器版本
	var framRecord = "";
	if (window.frames["framRecord"]!=undefined)
	{
		if (!!window.ActiveXObject || "ActiveXObject" in window)
		{
			framRecord = window.frames["framRecord"];
		}
		else
		{
			framRecord = window.frames["framRecord"].contentWindow;
		}		
	}		
			
    if (typeof data === "undefined") return
    if (typeof insertText != "undefined") {
        insertText(data);
    } else if (framRecord != undefined && framRecord.insertText != undefined) {
        framRecord.insertText(data + " ");
    }
}
