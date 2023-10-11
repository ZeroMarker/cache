///智能诊断工具   相关参数
var cdssTool;
var CDSS = {};
var userName = userName || "";
var hospitalID = hospitalID || "";
var cdssLock = "Y";
var cdssSucess = [];
var episodeType = "";
var environment = "TEST";
if (typeof episodeID == undefined) {
    var episodeID = "";
    var patientID = "";
    var userID = "";
    var userLocID = "";
}
(function () {
    // ie 方法兼容
    compitableIE();
    // 获取环境参数
    getEnvironment();
    if (typeof patInfo != "undefined") {
        userID = patInfo.UserID;
        userLocID = patInfo.UserLocID;
        patientID = patInfo.PatientID;
        episodeID = patInfo.EpisodeID;
        userName = patInfo.UserName;
        hospitalID = patInfo.HospitalID;
        if (episodeID == "") {
            var frm = top.document.forms['fEPRMENU'];
            episodeID = frm.EpisodeID.value;
            patientID = frm.PatientID.value;
        }
    }
    if (typeof setting != "undefined") {
        userID = setting.userId;
        userLocID = setting.userLocId;
        patientID = setting.patientId;
        episodeID = setting.episodeId;
        hospitalID = setting.hospitalID;
    }
    initCDSSData(episodeID, patientID);
})();
//初始化第三方CDSS
function initCDSSData(EpisodeID, PatientID) {
    episodeID = EpisodeID;
    patientID = PatientID;
    if (episodeID == "") {
        cdssLock = "Y";
        return
    }
    var paramter = "AEpisodeID:" + episodeID + ",AUserLocID:" + userLocID + ",AUserID:" + userID + ",APatientID:" + patientID
    jQuery.ajax({
        type: "post",
        dataType: "json",
        url: '../EMRservice.BOCDSSService.cls',
        async: false,
        data: {
            "action": "GetOptions",
            "param": paramter
        },
        success: function (d) {
            if (d.length > 0) {
                for (var i = 0; i < d.length; i++) {
                    if (d[i].success == 1) {
                        cdssSucess.push(d[i]);
                    } else {
                        HISAlert("初始化失败：" + d[i].message, "提示信息");
                    }
                }
                if (cdssSucess.length === 0) {
                    cdssLock = "N";
                } else {
                    cdssTool = new loadTool();
                    cdssTool.init(cdssSucess);
                }
            } else {
                cdssLock = "N";
            }
        },
        error: function () {
            HISAlert("CDSS初始化出错，检查病历初始化接口", "提示信息");
            cdssLock = "N";
        }
    })

}
function loadTool() {
    this.init = function (data) {
        for (var i = 0; i < data.length; i++) {
            loadCDSS(data[i]);
        }
    }
    this.getData = function (param, type, eventType) {
        for (var i = 0; i < cdssSucess.length; i++) {
            getData(cdssSucess[i], param, type, eventType);
        }
    }
}
//匹配第三方CDSS 加载对应函数对象
function loadCDSS(data) {
    var cdssType = data.args.cdssType;
    episodeType = data.args.episodeType;
    if (cdssType == "CDSSHM") {
        if (typeof CDSSHM == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSHM"] = new CDSSHM();
            CDSS["CDSSHM"].init(data);
        }
    } else if (cdssType == "CDSSBD") {
        if (typeof CDSSBD == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSBD"] = new CDSSBD();
            CDSS["CDSSBD"].init();
        }
    } else if (cdssType == "CDSSDH") {
        if (typeof CDSSDH == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSDH"] = new CDSSDH();
            CDSS["CDSSDH"].init(data);
        }
    } else if (cdssType == "CDSSRJ") {
        if (typeof CDSSRJ == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSRJ"] = new CDSSRJ();
            CDSS["CDSSRJ"].init(data);
        }
    } else if (cdssType == "CDSSWF") {
        if (typeof CDSSWF == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSWF"] = new CDSSWF();
            CDSS["CDSSWF"].init(data);
        }
    } else if (cdssType == "CDSSTFZW") {
        if (typeof CDSSTFZW == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSTFZW"] = new CDSSTFZW();
            CDSS["CDSSTFZW"].init(data);
        }
    }else if (cdssType == "CDSSBDLY") {
        if (typeof CDSSBDLY == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSBDLY"] = new CDSSBDLY();
            CDSS["CDSSBDLY"].init(data);
        }
    } else {
        cdssLock = "N";
    }
}
//匹配第三方CDSS 加载对应函数对象
function getData(data, param, type, eventType) {
    var cdssType = data.args.cdssType;
    if (cdssType == "CDSSHM") {
        if (typeof CDSSHM == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSHM"].getData(param, type);
        }
    } else if (cdssType == "CDSSBD") {
        if (typeof CDSSBD == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSBD"].getData(param, type, eventType);
        }
    } else if (cdssType == "CDSSDH") {
        if (typeof CDSSDH == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSDH"].getData(param, type);
        }
    } else if (cdssType == "CDSSRJ") {
        if (typeof CDSSRJ == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSRJ"].getData(param, type);
        }
    } else if (cdssType == "CDSSWF") {
        if (typeof CDSSWF == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSWF"].getData(param, type);
        }
    } else if (cdssType == "CDSSTFZW") {
        if (typeof CDSSTFZW == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSTFZW"].getData(param, type);
        }
    } else if (cdssType == "CDSSBDLY") {
        if (typeof CDSSBDLY == "undefined") {
            cdssLock = "N";
        } else {
            CDSS["CDSSBDLY"].getData(param, type);
        }
    }else {
        cdssLock = "N";
    }
}

/*当前日期时间*/
function getCurrentDateTime() {
    var date = new Date();
    var m = date.getMonth() + 1;
    var time = date.getFullYear() + "-" + m + "-" + date.getDate() + " " + date.getHours() + ":" + date.getMinutes() + ":" + date.getSeconds();
    return time;
}
//动态脚本引入外部JS
function loadScript(url, callback) {
    var script = document.createElement("script");
    script.type = "text/javascript";
    //绑定加载完毕的事件
    if (script.readyState) {
        script.onreadystatechange = function () {
            if (script.readyState === "loaded" || script.readyState === "complete") {
                callback && callback();
            }
        }
    } else {
        script.onload = function () {
            callback && callback();
        }
    }
    script.src = url;
    document.getElementsByTagName("head")[0].appendChild(script);
}
function getEnvironment() {
    jQuery.ajax({
        type: "post",
        dataType: "text",
        url: '../EMRservice.BOCDSSService.cls',
        async: false,
        data: {
            "action": "GetEnvironment"
        },
        success: function (d) {
            environment = d;
        },
        error: function () {
            HISAlert("获取环境参数接口错误", "提示信息");
            cdssLock = "N";
        }
    })
}


//ie 兼容 filter forEach
function compitableIE() {
    if (!Array.prototype.filter) {

        Array.prototype.filter = function (fun) {
            var len = this.length;
            if (typeof fun != "function") {
                throw new TypeError();
            }
            var res = new Array();
            var thisp = arguments[1];
            for (var i = 0; i < len; i++) {
                if (i in this) {
                    var val = this[i]; // in case fun mutates this  
                    if (fun.call(thisp, val, i, this)) {
                        res.push(val);
                    }
                }
            }
            return res;
        };
    }
    if (!Array.prototype.forEach) {
        Array.prototype.forEach = function forEach(callback, thisArg) {
            var T, k;
            if (this == null) {
                throw new TypeError("this is null or not defined");
            }
            var O = Object(this);
            var len = O.length >>> 0;
            if (typeof callback !== "function") {
                throw new TypeError(callback + " is not a function");
            }
            if (arguments.length > 1) {
                T = thisArg;
            }
            k = 0;
            while (k < len) {

                var kValue;
                if (k in O) {
                    kValue = O[k];
                    callback.call(T, kValue, k, O);
                }
                k++;
            }
        };
    }

}

// alert和hisui 兼容

function HISAlert(value, title, i, a) {

    if ($ && $.messager && $.messager.alert && typeof $.messager.alert === "function") {
        if (title === "" || title === undefined) {
            title = "提示信息";
        }
        $.messager.alert(title, value, i, a);
    } else {
        alert(value);
    }
}