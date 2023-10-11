function CDSSRJ(){
	this.init=function(data){
		this.cdssApiUrl=data.args.cdssApiUrl;
	}
	this.getData=function(param,actionType){
		var _this=this;
		_paramNow=param;
		var action=actionType.toUpperCase();
		var instanceId = param.id;
		var paramter =  "AEpisodeID:"+episodeID+",AUserID:"+userID+",ADocID:"+param.emrDocId+",AInstanceID:"+instanceId+",AAction:"+action+",AType:"+episodeType+",ACdssTool:CDSSRJ"
		jQuery.ajax({
			type: "post",
			dataType: "json",
			url: '../EMRservice.BOCDSSService.cls',
			async: false,
			data: {
				"action":"GetCDSSData",
				"param":paramter
			},
			success: function(d){
				if(d.success==1){
					_this.sendData.call(_this,d.message);
				}
			},
			error: function(d){
				HISAlert("取病历数据出错","提示信息");
				cdssLock="N";
			}
		});
	},
	this.sendData=function(message){
		CDSS_UI.call(this,"DOCUMENT",message);
	}	
}﻿
function CDSS_UI(funcCode, msgXML) {
    if (!!window.ActiveXObject || "ActiveXObject" in window) {
        try {
            var shell = new ActiveXObject("WScript.Shell");
            var key1 = shell.RegRead("HKEY_CLASSES_ROOT\\CDSSClient\\shell\\open\\command\\");
            shell = null;
            if (!key1 || key1 == "" || key1 == null) {
                return;
            }
        } catch (e) {
            return;
        }
    }

    var url = this.cdssApiUrl;
	//var url = "http://194.1.5.5:9091/api/rule/cdssApi";
	try{
	jQuery.ajax({
		async: false,
        data: msgXML,
        contentType: 'text/plain',
        timeout: 10000,
		type: "post",
		dataType: "json",
		url: url + '?funcCode=' + funcCode + '&bcType=BS',
		async: false,
		success: function(data){
			if (data) {
                    var dataObj = data
                    //eval('(' + data + ')');
                    if (dataObj.xmlInfo != null) {
                        var result = dataObj.xmlInfo;
                        if (funcCode == 'LOGIN') {
                            var xmlDoc = loadXML(result);
                            var tokenArr = xmlDoc.getElementsByTagName("token");
                            var token = tokenArr[0].textContent;
                            if (!token) {
                                token = xmlDoc.getElementsByTagName("token")[0].childNodes[0].nodeValue;
                            }
                            cdssToken = token;
                            if (funcCode == 'LOGIN') {
                                initCDSSClient(msgXML);
                            }
                        }
                    }
                }
		},
		error: function(){
			 if (funcCode == 'LOGIN') {
                    HISAlert("登录失败！","提示信息")
                }	
		}
	})
	}catch(err){
		HISAlert("CDSS请求出错","提示信息");
		cdssLock = "N";	
	}
}