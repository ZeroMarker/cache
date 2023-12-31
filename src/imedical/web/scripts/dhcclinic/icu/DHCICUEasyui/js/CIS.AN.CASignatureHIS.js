function dhcsys_getcacert(options, logonType, singleLogon, forceOpen) {
    var isHeaderMenuOpen = true;
    var SignUserCode = "";
    var notLoadCAJs = 0,
        loc = "",
        groupDesc = "";
    var callback = undefined;
    if ("object" == typeof options) {
        if ("undefined" !== typeof options.isHeaderMenuOpen) isHeaderMenuOpen = options.isHeaderMenuOpen;
        if ("undefined" !== typeof options.SignUserCode) SignUserCode = options.SignUserCode;
        if ("undefined" !== typeof options.notLoadCAJs) notLoadCAJs = options.notLoadCAJs
        if ("undefined" !== typeof options.loc) loc = options.loc
        if ("undefined" !== typeof options.groupDesc) groupDesc = options.groupDesc;
        callback = options.callback;
    }
    if ("function" == typeof options) {
        callback = options;
    }
    var win = websys_getMenuWin() || window;
    if (isHeaderMenuOpen) {
        if (win != self && win.dhcsys_getcacert) { //force to menu iframe
            return win.dhcsys_getcacert(options, logonType, singleLogon, forceOpen);
        }
    }
    if ("undefined" === typeof singleLogon) singleLogon = 1;
    if ("undefined" === typeof logonType || "" == logonType) {
        logonType = "UKEY";
        if (win.LastCALogonType) logonType = win.LastCALogonType;
    }
    if ("undefined" === typeof forceOpen) forceOpen = 0;
    var obj = {},
        varCert = "",
        ContainerName = "",
        CTLoc = "",
        arr = [],
        rtn = {};
    var failRtn = {
        IsSucc: false,
        varCert: "",
        ContainerName: "",
        "IsCA": false
    };
    if (loc != "") {
        CTLoc = loc
    } else {
        if (session.ExtDeptID) {
            CTLoc = session.ExtDeptID;
        }
    }

    if (CTLoc == "") {
        rtn = {
            IsSucc: true,
            varCert: "",
            ContainerName: "",
            "IsCA": false
        };
        if (callback) callback(rtn);
        return rtn;
    }
    var userName = session.ExtUserCode;
    if ("0" == forceOpen) {
        var flag = IsCaLogon(CTLoc, userName, groupDesc);
        if (flag == 0) { //2019-03-27
            rtn = {
                IsSucc: true,
                varCert: "",
                ContainerName: "",
                "IsCA": false
            };
            if (callback) callback(rtn);
            return rtn;
        }
        ContainerName = dhcsys_getContainerNameAndPin();
        if (ContainerName.indexOf("^") > -1) {
            arr = ContainerName.split("^");
            ContainerName = arr[0];
            logonType = arr[2] || "UKEY";
        }
    }

    if (ContainerName) {
        var rtn = {
            "IsCA": true,
            IsSucc: true,
            ContainerName: ContainerName,
            UserName: arr[7] || "",
            UserID: arr[6] || "",
            CALogonType: arr[2] || "",
            CAUserCertCode: arr[3] || "",
            CACertNo: arr[4] || "",
            CAToken: arr[5] || "",
            ca_key: win.ca_key || ""
        };
        if (logonType == "PHONE" || logonType == "PINPHONE") {
            try {
                rtn.varCert = win.GetSignCert(ContainerName);
            } catch (ex) {};
            if (callback) callback(rtn);
            return rtn;
        }
        if (logonType == "UKEY") {
            // SessionContainerName=CurrentUKeyContainerName?
            if (notLoadCAJs == 1) {
                if (callback) callback(rtn);
                return rtn;
            }
            var userList = win.GetUserList(); //Name||key&&& Name||key
            var causerArr = userList.split("&&&");
            for (var i = 0; i < causerArr.length; i++) {
                if (causerArr[i].split("||").length > 1 && causerArr[i].split("||")[1] == ContainerName) {
                    try {
                        rtn.varCert = win.GetSignCert(ContainerName);
                    } catch (ex) {};
                    if (callback) callback(rtn);
                    return rtn;
                }
            }
        }
    }
    // not calogon show calogon dialog
    obj = dhcsys_calogonshow(CTLoc, userName, logonType, singleLogon, callback, options);
    if (obj.IsSucc && obj.ContainerName) {
        //ie error-> not exec [destory script]
        //obj.varCert = obj.ca_key.GetSignCert(obj.ContainerName);
        try {
            obj.varCert = win.GetSignCert(obj.ContainerName);
        } catch (ex) {};
        obj.ca_key = win.ca_key || "";
    }
    return obj;
}


function tkMakeServerCall() {
    var result = null;
    if (arguments.length < 2) return result;
    var className = arguments[0];
    var methodName = arguments[1];
    var params = [];
    for (var i = 2; i < arguments.length; i++) {
        if (params.length > 0) params.push(splitchar.comma);
        params.push("\"" + arguments[i] + "\"");
    }
    $.ajax({
        url: ANCSP.MethodService,
        async: false,
        data: {
            ClassName: className,
            MethodName: methodName,
            Params: params.join("")
        },
        type: "post",
        success: function (data) {
            result = $.trim(data);
        }
    });
    return result;
}

/**
 * 签名工具类
 */
var SignTool = {
    /**
     * 初始化签名控件
     * 加载签名信息赋值给签名控件
     */
    loadSignature: function () {
        this.initSignature();
        this.loadSignatureList();
    },

    /**
     * 初始化页面的签名控件
     */
    initSignature: function () {
		var ifCAInUsage = this.CheckCAIfInUsage();
		var _this = this;
		
        $(".signature").triggerbox({
            handler: function () {
                var signCode = $(this).attr("id");
                var title = "";
                var related=""  //有些签名需要互斥，比如交班/接班 YL 20220128
                var opts = $(this).triggerbox("options");
                if (opts) {
                    title = opts.prompt;
					related=opts.related?opts.related:""
                }
                var CareProvType = opts.CareProvType;
                var operDatas = operDataManager.getOperDatas();
                var originalData = JSON.stringify(operDatas);
				var recordSheetId = session.RecordSheetID;
				
				if(ifCAInUsage){
					_this.signData(signCode, originalData, function(userCertCode, signCode, hashData, signedData, certNo){
						var saveRet = dhccl.runServerMethodNormal(ANCLS.CA.SignatureService, "Sign", recordSheetId, userCertCode, signCode, hashData, signedData, "", certNo);
                        if (saveRet.indexOf("S^") === 0) {
                            $.messager.popover({
                                msg: "签名成功!",
                                type: "success"
                            });
                            _this.setSignImageBySignCode(signCode, recordSheetId);
                        } else {
                            $.messager.alert("提示", "签名失败，原因：" + saveRet, "error");
                        }
					});
				}else{
					var CASign = new CASignature({
						title: title || "",
						contentData: originalData,
						signCode: signCode,
						signBox: "#" + signCode,
						imgBox: "", //"#" + signCode + "Image",
						CareProvType: CareProvType,
					    related:related
					});
					CASign.open();
				}
            }
        });
		
		if(!ifCAInUsage) return;

        $(".signature").each(function (index, item) {
            var iconWidth = 28;
            var inputWidth = $(this).next(".triggerbox").find("input").width();
            if (!inputWidth) inputWidth = 142;
            inputWidth = inputWidth - iconWidth;

            $(this).next(".triggerbox").find("input").hide();
            $(this).next(".triggerbox").css({
                "width": "28px",
                "margin-top": "-22px"
            });
            var container = $(this).wrap("<span></span>")
            container.css({
                "margin": "0px",
                "padding": "0px"
            });
            var caSignIcon = $("<span style='width:28px;height:28px;background:white url(../skin/default/images/ca_icon_green.png) no-repeat center center;'></span>");
            caSignIcon.insertBefore(container);
            caSignIcon.css({
                "width": "28px",
                "height": "28px",
                "overflow": "hidden",
                "display": "inline-block",
                "vertical-align": "top"
            });

            var signCode = $(this).attr("id");
            var imgId = signCode + "Image";
            var img = $("<img id='" + imgId + "' height='28' width='" + inputWidth + "' style='border:1px solid #9ed2f2'></img>");
            img.insertBefore(container);

            var deleteIcon = $('<span class="triggerbox triggerbox-button icon-cancel" style="width:28px;height:28px;"></span>').insertAfter(container);
            deleteIcon.click(function () {
                $.messager.confirm("提示", "是否删除已有签名？", function (r) {
                    if (r) {
                        var saveRet = dhccl.runServerMethodNormal(ANCLS.CA.SignatureService, "RemoveSignature", session.RecordSheetID, signCode);
                        if (saveRet.indexOf("S^") === 0) {
                            img.attr("src", "");
                        } else {
                            $.messager.alert("提示", "删除签名失败，原因：" + saveRet, "error");
                        }
                    }
                });
            });
        });
    },

    /**加载页面签名信息
     */
    loadSignatureList: function () {
        var signatureList = this.getSignatureList();
        if (signatureList && signatureList.length > 0) {
            for (var i = 0; i < signatureList.length; i++) {
                var signature = signatureList[i];
                var signCode = signature.SignCode;
				var selector = "#" + signCode;
				 if($(selector).hasClass("hisui-triggerbox")){
                    $(selector).triggerbox("setValue",signature.FullName);
                }
                this.setSignImageBySignCode(signCode, session.RecordSheetID);
            }
        }

        return signatureList;
    },

    setSignImageBySignCode: function(signCode, recordSheetID){
        if (!signCode || $("#" + signCode).length <= 0) return;
        var signImage = dhccl.runServerMethodNormal(ANCLS.CA.SignatureService, "GetSignImage", recordSheetID, signCode);
        if (signImage) {
            var imgSelector = "#" + signCode + "Image";
            $(imgSelector).attr("src", "data:image/png;base64," + signImage);
        }
    },

    getSignatureList: function() {
        var signatureList = dhccl.getDatas(ANCSP.DataQuery, {
            ClassName: ANCLS.CA.SignatureService,
            QueryName: "FindSignature",
            Arg1: session.RecordSheetID,
            ArgCnt: 1
        }, "json", false);
        return signatureList;
    },
	
	signData: function(signCode, toSignData, onAfterSign){
		var _this = this;
		var logonType = ""; //UKEY|PHONE|FACE|SOUND|"" 空时弹出配置签名方式，其它弹出固定方式
		var singleLogon = 0; //0-弹出多页签签名，1-单种签名方式
		var forceOpen = 1; //1-强制每次都弹出签名窗口
		var ret=_this.CheckCAIfInUsage();
		if(ret=="1"){
			dhcsys_getcacert({
				modelCode: "ANOPSign",
				callback: function (cartn) {
					// 签名窗口关闭后,会进入这里
					if (cartn.IsSucc) {
						if (cartn.ContainerName) {
							if ("object" == typeof cartn && cartn.IsCAReLogon) {
								var userCertCode = cartn.CAUserCertCode;
								var certNo = cartn.CACertNo;
								var hashData = cartn.ca_key.HashData(JSON.stringify(toSignData));
								var signedData = cartn.ca_key.SignedData(hashData, cartn.ContainerName);
								if(onAfterSign) onAfterSign(userCertCode, signCode, hashData, signedData, certNo);
								
								return true;
							}
						} else {
							$.messager.alert("提示","未开启CA,使用HIS系统签名!");
							return false;
						}
					} else {
						alert("签名失败！");
						return false;
					}
				}
			}, logonType, singleLogon, forceOpen);
		}
		else{
			return true;
		}
	},
	
	getSignImageBySrc: function(signCode){
		var imgSelector = "#" + signCode + "Image";
        return $(imgSelector).attr("src");
	},
	
	/*检查CA签名是否开启*/
	CheckCAIfInUsage: function(){
		var userId = session.ExtUserID;
		var locId = session.ExtDeptID;
		var groupId = session.ExtGroupID;

		var ret = dhccl.runServerMethodNormal("CA.DigitalSignatureService", "GetCAServiceStatus", locId, userId, groupId, "ANOPSign");
		if (ret == "0") {
			return false;
		} else {
			return true;
		}
	},
	
	//手术申请签名
	signOperAppData: function(opsId, signCode, toSignData, onAfterSign){
		var _this = this;
		var logonType = ""; //UKEY|PHONE|FACE|SOUND|"" 空时弹出配置签名方式，其它弹出固定方式
		var singleLogon = 0; //0-弹出多页签签名，1-单种签名方式
		var forceOpen = 1; //1-强制每次都弹出签名窗口
		dhcsys_getcacert({
			modelCode: "ANOPSign",
			callback: function (cartn) {
				// 签名窗口关闭后,会进入这里
				if (cartn.IsSucc) {
					if (cartn.ContainerName) {
						if ("object" == typeof cartn && cartn.IsCAReLogon) {
							var userCertCode = cartn.CAUserCertCode;
							var certNo = cartn.CACertNo;
							var hashData = cartn.ca_key.HashData(JSON.stringify(toSignData));
							var signedData = cartn.ca_key.SignedData(hashData, cartn.ContainerName);
							if(onAfterSign) onAfterSign(userCertCode, signCode, hashData, signedData, certNo);
							
							var OrdItms = _this.GetOrdItmIdByOpsId(opsId);
							//插入手术申请医嘱签名
							if(OrdItms != ""){
								var XmlType = "A", ModuleMark = "ANOPAppSign";
								var itmValData = "", itmHashData = "", itmSignData = "";
								var DatasArr = OrdItms.split("^");
								for (var i=0; i < DatasArr.length; i++){
									//医嘱信息串:
									var itmsXml = _this.GetOrdItemXml(DatasArr[i], XmlType);
									var itmXmlArr = itmsXml.split(String.fromCharCode(2));
									for (var j = 0; j < itmXmlArr.length; j++) {
										if (itmXmlArr[j] == "") continue;
										var itmXml = itmXmlArr[j].split(String.fromCharCode(1))[1];
										var itmOpType = itmXmlArr[j].split(String.fromCharCode(1))[0];
										var itmXmlHash = cartn.ca_key.HashData(itmXml);
										//签名串Hash值
										if (itmHashData == "") itmHashData = itmXmlHash;
										else itmHashData = itmHashData + "&&&&&&&&&&" + itmXmlHash;
										//签名串
										var SignedData = cartn.ca_key.SignedOrdData(itmXmlHash, cartn.ContainerName);
										if (itmSignData == "") itmSignData = SignedData;
										else itmSignData = itmSignData + "&&&&&&&&&&" + SignedData;
										
										if (itmValData == "") itmValData = itmOpType + String.fromCharCode(1) + DatasArr[i];
										else itmValData = itmValData + "^" + itmOpType + String.fromCharCode(1) + DatasArr[i];
									}
								}
								
								if (itmHashData != "") itmHashData = itmHashData + "&&&&&&&&&&";
								if (itmSignData != "") itmSignData = itmSignData + "&&&&&&&&&&";
								
								//3.保存医嘱签名信息记录
								if ((itmValData != "") && (itmHashData != "") && (certNo != "") && (itmSignData != "")) {
									var ret = _this.InsBatchSign(itmValData, session.ExtUserID, XmlType, itmHashData, userCertCode, itmSignData, certNo, ModuleMark);
									if (ret != "0") $.messager.alert("警告", "保存手术申请医嘱数字签名没成功");
								} else {
									$.messager.alert("警告", "数字签名错误");
								}
							}
							
							return true;
						}
					} else {
						$.messager.alert("未开启CA,使用HIS系统签名!");
						return false;
					}
				} else {
					$.messager.alert("签名失败！");
					return false;
				}
			}
		}, logonType, singleLogon, forceOpen);
	},
	
	GetOrdItmIdByOpsId : function(opsId){
		var OrdItms = dhccl.runServerMethodNormal("CIS.AN.CA.SignatureService","GetOrdItms",opsId);
		return OrdItms;
	},
	
	/* 取医嘱信息串 */
	GetOrdItemXml:function(OeOriId, XmlType){
		var OrdItemXml=dhccl.runServerMethodNormal("web.DHCDocSignVerify","GetOEORIItemXML",OeOriId,XmlType)
		return OrdItemXml;
	},
	
	/*插入批量签名*/
	InsBatchSign:function(itmValData, LgUserID, XmlType, itmHashData, varCertCode, itmSignData, varCert, ModuleMark){
		var retFlag = dhccl.runServerMethodNormal("web.DHCDocSignVerify","InsertSignBatchSignRecord",itmValData,LgUserID,XmlType, itmHashData,varCertCode,itmSignData,"",varCert)
		return retFlag;
	}
}